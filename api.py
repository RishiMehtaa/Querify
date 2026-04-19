from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
from agents.router import route_query
from agents.sql_agent import SQLAgent
from agents.eda_agent import EDAAgent
from auth_router import router as auth_router
from db_router import router as db_router
from db_router import get_connection_params
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Querify 2.0 API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(auth_router)
app.include_router(db_router)
sql_agent = SQLAgent()
eda_agent = EDAAgent()


class ChatRequest(BaseModel):
    text: str
    connection_id: Optional[str] = None 

@app.post("/chat")
def chat_endpoint(request: ChatRequest):
    user_input = request.text

    db_params = None
    if request.connection_id:
        db_params = get_connection_params(request.connection_id)
    
    try:
        route = route_query(user_input)
    except:
        route = "EDA_TASK"

    if route == "SQL_QUERY":
        response = sql_agent.run(user_input)
        return {"type": "sql", "answer": response}

    elif route == "EDA_TASK":
        result = eda_agent.run(user_input)
        return {
            "type": "eda",
            "answer": result["answer"],
            "steps": result.get("steps", []),
            "image": result.get("image"),
            "dataframe": result.get("dataframe")
        }

    return {"type": "error", "answer": "Unknown route"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)