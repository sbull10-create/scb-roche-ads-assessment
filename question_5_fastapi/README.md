# Clinical Data API (FastAPI)

## Folder Structure

```
question_5_fastapi
│
├── main.py
│   FastAPI application implementing the clinical trial data API.
│   Includes endpoints for dynamic adverse event filtering and
│   patient safety risk score calculation.
│
├── adae.csv
│   Input dataset used by the API containing adverse event data.
│
└── README.md
    Documentation describing the API and instructions for running
    the application locally.
```

## Setup

Install dependencies:

python3 -m pip install fastapi uvicorn pandas

## Run the API

python3 -m uvicorn main:app --reload

## API Documentation

After running the server open:

http://127.0.0.1:8000/docs

## Endpoints

GET /
Returns API status message.

POST /ae-query
Filters adverse events based on severity and/or treatment arm and returns total count of AEs that fit filters and output.
Example Entry: 
{
"severity": ["MILD","MODERATE"],
"treatment_arm":"Placebo"
}

GET /subject-risk/{subject_id}
Calculates a safety risk score for a specific subject.
Example Entry:
01-701-1015
