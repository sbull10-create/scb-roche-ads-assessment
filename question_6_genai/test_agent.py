import pandas as pd
from clinical_agent import ClinicalTrialDataAgent


# Load dataset
ae = pd.read_csv("ae.csv")


# Create agent
agent = ClinicalTrialDataAgent(ae)


queries = [

    "Give me the subjects who had adverse events of Moderate severity",

    "Which subjects had Headache?",

    "Show subjects with Cardiac disorders",

    "Give me subjects with Severe adverse events"

    "Show subjects with events in January"
]


for q in queries:

    result = agent.ask(q)

    print("Unique Subjects:", result["count"])
    print("Subject IDs:", result["subjects"][:10])
