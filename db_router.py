import uuid
from typing import Dict

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import mysql.connector

router = APIRouter(prefix="/db", tags=["database"])

# ---------------------------------------------------------------------------
# In-memory connection store  { connection_id -> connection_params }
# ---------------------------------------------------------------------------

active_connections: Dict[str, dict] = {}


# ---------------------------------------------------------------------------
# Schemas
# ---------------------------------------------------------------------------

class DBConnectRequest(BaseModel):
    host: str
    user: str
    password: str
    dbname: str


class DBConnectResponse(BaseModel):
    success: bool
    connection_id: str


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------

@router.post("/connect", response_model=DBConnectResponse)
def connect_db(req: DBConnectRequest):
    # Test the connection
    try:
        conn = mysql.connector.connect(
            host=req.host,
            user=req.user,
            password=req.password,
            database=req.dbname,
            connection_timeout=5,
        )
        conn.close()
    except mysql.connector.Error as e:
        raise HTTPException(status_code=400, detail=f"Database connection failed: {str(e)}")

    # Store params and return an ID
    connection_id = str(uuid.uuid4())
    active_connections[connection_id] = {
        "host": req.host,
        "user": req.user,
        "password": req.password,
        "dbname": req.dbname,
    }

    return DBConnectResponse(success=True, connection_id=connection_id)


# ---------------------------------------------------------------------------
# Helper used by the chat endpoint
# ---------------------------------------------------------------------------

def get_connection_params(connection_id: str) -> dict:
    params = active_connections.get(connection_id)
    if not params:
        raise HTTPException(status_code=404, detail="connection_id not found. Please reconnect your database.")
    return params