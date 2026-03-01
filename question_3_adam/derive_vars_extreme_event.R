#LSTALVDT VS/AE/DS Dates Derivation

adsl_01_lstalv <- adsl_01_dm %>%
  derive_vars_extreme_event(
    by_vars = exprs(STUDYID, USUBJID),
    events = list(
      event(
        dataset_name = "ds",
        order = exprs(DSSTDTC, DSSEQ),
        condition = !is.na(DSSTDTC),
        mode="last",
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(DSSTDTC, highest_imputation = "n"),
          seq = DSSEQ
        ),
      ),
      event(
        dataset_name = "ae",
        order = exprs(AESTDTC, AESEQ),
        condition = !is.na(AESTDTC),
        mode="last",
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(AESTDTC, highest_imputation = "n"),
          seq = AESEQ
        ),
      ),
      event(
        dataset_name = "vs",
        order = exprs(VSDTC, VSSEQ),
        condition = !is.na(VSDTC) & !is.na(VSSTRESN) & !is.na(VSSTRESC),
        mode="last",
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(VSDTC, highest_imputation = "n"),
          seq = VSSEQ
        ),
      ),
      event(
        dataset_name = "ex",
        order = exprs(EXENDTC, EXSEQ),
        condition = !is.na(EXENDTC) & (EXDOSE > 0 | (EXDOSE == 0 & EXTRT=="PLACEBO")),
        mode="last",
        set_values_to = exprs(
          LSTALVDT = convert_dtc_to_dt(EXENDTC, highest_imputation = "n"),
          seq = EXSEQ
        )
      )
    ),
    source_datasets = list( ds = ds, ae = ae, vs = vs, ex = ex),
    tmp_event_nr_var = event_nr,
    order = exprs(LSTALVDT, seq, event_nr),
    mode = "last",
    new_vars = exprs(LSTALVDT)
  )
