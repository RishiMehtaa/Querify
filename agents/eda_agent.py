import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import io
import base64
import json
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import JsonOutputParser, StrOutputParser
from pydantic import BaseModel, Field
from llm_setup import get_llm
from db_connection import get_db

class EDAPlan(BaseModel):
    thought_process: str = Field(description="Reasoning about the data and approach")
    code: str = Field(description="The executable Python code.")

class EDAAgent:
    def __init__(self):
        self.db = get_db()
        # Ensure this uses the 'fast' or 'smart' model correctly configured in llm_setup.py
        self.llm = get_llm(model_type="groq") 
        self.parser = JsonOutputParser(pydantic_object=EDAPlan)

    def get_schema(self):
        return self.db.get_table_info()

    def generate_plan_and_code(self, question: str, retry_context: str = ""):
        schema = self.get_schema()
        format_instructions = self.parser.get_format_instructions()
        format_instructions = format_instructions.replace("{", "{{").replace("}", "}}")
        
        # 1. SYSTEM MESSAGE: Context & Rules only
        system_prompt = """
        You are a Senior Data Scientist.
        DATABASE SCHEMA: {schema}
        
        INSTRUCTIONS:
        1. Connect: engine = create_engine('mysql+mysqlconnector://root:@localhost:3306/learn')
        2. engine is already available. Do NOT create it. Just use: df = pd.read_sql("SELECT ...", engine)
        3. OUTPUTS:
           - Assign the main result/dataframe to final_result.
           - If generating a PLOT: 
             1. Create the plot using matplotlib. 
             2. Assign the figure to final_plot (e.g., final_plot = plt.gcf()).
        
        {format_instructions}
        """
        
        if retry_context:
            system_prompt += f"\n\nPREVIOUS ERROR:\n{retry_context}\nFix the code."

        # 2. HUMAN MESSAGE: The actual trigger
        prompt = ChatPromptTemplate.from_messages([
            ("system", system_prompt),
            ("human", "Question: {question}")
        ])
        
        chain = prompt | self.llm | self.parser

        print("=== FORMAT INSTRUCTIONS ===")
        print(format_instructions[:200])
        print("=== END ===")
        
        result = chain.invoke({
            "schema": schema, 
            "question": question, 
            "format_instructions": format_instructions
        })
        print("=== GENERATED CODE ===")
        print(result['code'])
        print("=== END ===")
        
        return result
    

    def synthesize_answer(self, question, steps, final_result):
        """
        Consumes the logs and result to create the final "Gemini-style" text response.
        """
        result_summary = str(final_result)
        if isinstance(final_result, pd.DataFrame):
            result_summary = f"DataFrame with columns: {list(final_result.columns)}. Preview: {final_result.head().to_string()}"

        # 1. SYSTEM: Persona
        system_prompt = """
        You are a Data Analyst acting as the interface for a BI tool.
        Your task is to provide a clear, natural language conclusion based on the provided technical logs and results.
        - Interpret the data/plot for the user.
        - Do not show code (that is hidden elsewhere).
        """
        
        # 2. HUMAN: The Data
        human_message = """
        USER QUESTION: {question}
        
        TECHNICAL EXECUTION LOGS:
        {logs}
        
        FINAL RESULT/DATA:
        {result}
        """
        
        prompt = ChatPromptTemplate.from_messages([
            ("system", system_prompt),
            ("human", human_message)
        ])
        
        chain = prompt | self.llm | StrOutputParser()
        return chain.invoke({"question": question, "logs": str(steps), "result": result_summary})

    def run(self, question: str):
        steps = [] 
        max_retries = 3
        
        for attempt in range(max_retries):
            print(f"=== STARTING ATTEMPT {attempt+1} ===")
            step_record = {
                "attempt": attempt + 1,
                "thought": "Planning logic...",
                "code": "",
                "error": None,
                "output": None
            }
            
            try:
                # 1. Plan
                prev_err = steps[-1]['error'] if steps else ""
                plan_data = self.generate_plan_and_code(question, prev_err)
                
                step_record["thought"] = plan_data['thought_process']
                step_record["code"] = plan_data['code']
                # Auto-fix reserved keyword 'order'
                code = plan_data['code']
                code = code.replace('FROM order', 'FROM `order`')
                code = code.replace('JOIN order', 'JOIN `order`')
                code = code.replace('plt.show()', '')

                # Auto-inject final_result if missing
                if 'final_result' not in code:
                    code += "\nfinal_result = df"

                plan_data['code'] = code
                
                # 2. Execute
                from sqlalchemy import create_engine
                import os
                from dotenv import load_dotenv
                load_dotenv()
                db_url = os.getenv("DATABASE_URL")
                engine = create_engine(db_url)
                local_scope = {"engine": engine}
                import sys
                from io import StringIO
                old_stdout = sys.stdout
                redirected_output = sys.stdout = StringIO()
                
                try:
                    exec(plan_data['code'], globals(), local_scope)
                    sys.stdout = old_stdout 
                    print("=== EXEC COMPLETED ===")
                    step_record["output"] = redirected_output.getvalue()
                except Exception as exec_err:
                    sys.stdout = old_stdout
                    raise exec_err

                # 3. Handle Results
                # if 'final_result' not in local_scope:
                #     raise ValueError("`final_result` variable missing.")
                
                # actual_result = local_scope['final_result']
                # 3. Handle Results
                print("=== HANDLING RESULTS ===")
                if 'final_result' not in local_scope:
                    raise ValueError("`final_result` variable missing.")

                actual_result = local_scope['final_result']
                print(f"=== actual_result type: {type(actual_result)} ===")

                dataframe_json = None
                if isinstance(actual_result, pd.DataFrame):
                    dataframe_json = actual_result.head(100).to_json(orient='records', date_format='iso')
                print(f"=== dataframe_json done ===")

                plot_base64 = None
                if 'final_plot' in local_scope:
                    print("=== saving plot ===")
                    fig = local_scope['final_plot']
                    buf = io.BytesIO()
                    fig.savefig(buf, format="png", bbox_inches='tight')
                    buf.seek(0)
                    plot_base64 = base64.b64encode(buf.read()).decode("utf-8")
                    plt.close(fig)
                    print(f"=== plot saved, length: {len(plot_base64)} ===")

                steps.append(step_record)
                print("=== synthesizing answer ===")
                natural_answer = self.synthesize_answer(question, steps, actual_result)
                print("=== synthesis done ===")
                
                # DataFrame to JSON for UI
                dataframe_json = None
                if isinstance(actual_result, pd.DataFrame):
                    dataframe_json = actual_result.head(100).to_json(orient='records', date_format='iso')
                
                # 4. Handle Plots
                plot_base64 = None
                if 'final_plot' in local_scope:
                    fig = local_scope['final_plot']
                    buf = io.BytesIO()
                    fig.savefig(buf, format="png", bbox_inches='tight')
                    buf.seek(0)
                    plot_base64 = base64.b64encode(buf.read()).decode("utf-8")
                    plt.close(fig)

                steps.append(step_record)
                
                # 5. Final Synthesis
                natural_answer = self.synthesize_answer(question, steps, actual_result)
                
                return {
                    "status": "success",
                    "answer": natural_answer,
                    "steps": steps,
                    "image": plot_base64,
                    "dataframe": dataframe_json 
                }

            except Exception as e:
                step_record["error"] = str(e)
                steps.append(step_record)
                print(f"=== ATTEMPT {attempt+1} FAILED: {e} ===")

        # print("=== RETURN PAYLOAD ===")
        # print("answer:", natural_answer[:50])
        # print("image is None:", plot_base64 is None)
        # print("dataframe is None:", dataframe_json is None)
        # print("=== END ===")
        
        return {
            "status": "failure",
            "answer": "I failed to generate a valid analysis after multiple attempts.",
            "steps": steps,
            "image": None,
            "dataframe": None
        }