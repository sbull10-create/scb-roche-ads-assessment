import pandas as pd


SCHEMA = """
Dataset: AE (Adverse Events)

Columns:
USUBJID – Unique subject identifier
AETERM – Adverse Event term
AESOC – System Organ Class
AESEV – Severity of event (Mild, Moderate, Severe)
AESTDTC – Adverse event start date
"""


class ClinicalTrialDataAgent:

    def __init__(self, dataframe):

        self.df = dataframe

        # Extract possible values dynamically
        self.severity_values = dataframe["AESEV"].dropna().unique()
        self.aeterm_values = dataframe["AETERM"].dropna().unique()
        self.aesoc_values = dataframe["AESOC"].dropna().unique()

        # Convert date column
        self.df["AESTDTC"] = pd.to_datetime(self.df["AESTDTC"], errors="coerce")

        self.month_map = {
            "january":1, "february":2, "march":3, "april":4,
            "may":5, "june":6, "july":7, "august":8,
            "september":9, "october":10, "november":11, "december":12
        }


    # -------------------------
    # Parse user question
    # -------------------------
    def parse_question(self, question):

        q = question.lower()

        # Check severity
        for sev in self.severity_values:
            if str(sev).lower() in q:
                return {
                    "target_column": "AESEV",
                    "filter_value": sev
                }

        # Check adverse event term
        for term in self.aeterm_values:
            if str(term).lower() in q:
                return {
                    "target_column": "AETERM",
                    "filter_value": term
                }

        # Check body system
        for soc in self.aesoc_values:
            if str(soc).lower() in q:
                return {
                    "target_column": "AESOC",
                    "filter_value": soc
                }

        # Check month queries
        for month_name, month_num in self.month_map.items():
            if month_name in q:
                return {
                    "target_column": "AESTDTC",
                    "filter_value": month_num,
                    "filter_type": "month"
                }

        raise ValueError("Could not interpret the question")


    # -------------------------
    # Execute Pandas query
    # -------------------------
    def run_query(self, parsed_query):

        column = parsed_query["target_column"]
        value = parsed_query["filter_value"]

        if parsed_query.get("filter_type") == "month":

            filtered = self.df[self.df[column].dt.month == value]

        else:

            filtered = self.df[
                self.df[column].astype(str).str.contains(str(value), case=False, na=False)
            ]

        subjects = filtered["USUBJID"].unique()

        return {
            "count": len(subjects),
            "subjects": list(subjects)
        }


    # -------------------------
    # Full pipeline
    # -------------------------
    def ask(self, question):

        print("\nQuestion:", question)

        parsed = self.parse_question(question)

        print("Parsed query:", parsed)

        result = self.run_query(parsed)

        return result
