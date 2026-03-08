# Clinical Data API (FastAPI)

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