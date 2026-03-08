# GenAI Clinical Data Assistant

## Setup

Install dependencies:

```
python3 -m pip install pandas
```

Ensure the following files are in the same directory:

```
ae.csv
clinical_agent.py
test_agent.py
```

## Run the Agent

```
python3 test_agent.py
```

## Agent Overview

The Clinical Trial Data Agent allows users to ask **natural language questions** about the Adverse Events dataset.

The agent interprets the question, identifies the relevant dataset variable, and applies a **Pandas filter** to return matching subjects.

Supported dataset variables include:

* AESEV (Adverse Event Severity)
* AETERM (Adverse Event Term)
* AESOC (System Organ Class)
* AESTDTC (Adverse Event Start Date)

## Example Queries

Example questions that the agent can interpret:

Give me the subjects who had adverse events of Moderate severity

Which subjects had Headache?

Show subjects with Cardiac disorders

Give me subjects that had an Adverse Event in March

## Output

For each query the agent returns:

* Number of unique subjects with matching events
* List of subject IDs

Example Output:

```
Question: Which subjects had Headache?

Parsed query: {'target_column': 'AETERM', 'filter_value': 'HEADACHE'}

Unique Subjects: 8
Subject IDs: ['01-701-1015', '01-701-1030']
```

## Files

clinical_agent.py
Contains the `ClinicalTrialDataAgent` class responsible for:

* Parsing natural language queries
* Mapping queries to dataset variables
* Executing Pandas filters

test_agent.py
Simple test script that runs example queries and prints results.

ae.csv
Adverse Events dataset used by the agent.
