from fastapi import FastAPI, HTTPException
import pandas as pd
from typing import List, Optional
from pydantic import BaseModel

app = FastAPI()

df = pd.read_csv("adae.csv")

class AEQuery(BaseModel):
    severity: Optional[List[str]] = None
    treatment_arm: Optional[str] = None


@app.get("/")
def home():
    return {"message": "Clinical Trial Data API is running"}


@app.post("/ae-query")
def ae_query(query: AEQuery):

    filtered = df.copy()

    if query.severity:
        filtered = filtered[filtered["AESEV"].isin(query.severity)]

    if query.treatment_arm:
        filtered = filtered[filtered["ACTARM"] == query.treatment_arm]

    return {
        "count": len(filtered),
        "unique_subjects": filtered["USUBJID"].unique().tolist()
    }


@app.get("/subject-risk/{subject_id}")
def subject_risk(subject_id: str):

    subject_data = df[df["USUBJID"] == subject_id]

    if subject_data.empty:
        raise HTTPException(status_code=404, detail="Subject not found")

    severity_weights = {
        "MILD": 1,
        "MODERATE": 3,
        "SEVERE": 5
    }

    score = subject_data["AESEV"].map(severity_weights).sum()

    if score < 5:
        category = "Low"
    elif score < 15:
        category = "Medium"
    else:
        category = "High"

    return {
        "subject_id": subject_id,
        "risk_score": int(score),
        "risk_category": category
    }
