SELECT OUTSTANDING_KEY, total_cva, CVA_CAPITAL_CALC_SCOPE
FROM (SELECT OUTSTANDING_KEY,
             total_cva,
             RANK() OVER (partition by OUTSTANDING_KEY ORDER BY r.code desc) as prio,c.CODE CVA_CAPITAL_CALC_SCOPE
      from dwh_total_cva_trade t,
           PORTFOLIO_SCOPE r,
           cva_capital_calculation_scope c
      where r.portfolio_scope_key = t.portfolio_scope_key
        AND c.CVA_CAPITAL_CALCN_SCOPE_KEY = t.CVA_CAPITAL_CALCN_SCOPE_KEY
        and run_scope_key in CASE
                             WHEN c.code = 'INCAP'THEN (SELECT NVL(RUN_SCOPE_KEY,0) FROM RUN_SCOPE WHERE OFFICIAL_INCAP_SCOPE_IND ='Y' AND record_valid_from <= v_reporting_date  AND ( record_valid_until IS NULL OR record_valid_until > v_reporting_date ))
							 WHEN c.code = 'RECAP'THEN (SELECT NVL(RUN_SCOPE_KEY,0) FROM RUN_SCOPE WHERE OFFICIAL_RECAP_SCOPE_IND ='Y' AND record_valid_from <= v_reporting_date  AND ( record_valid_until IS NULL OR record_valid_until > v_reporting_date ))
							 END    --Added as part of 13856230 story
     and reporting_purpose_key in (SELECT NVL(REPORTING_PURPOSE_KEY,0) FROM REPORTING_PURPOSE WHERE CODE = 'CONS')
     AND t.portfolio_scope_key in (SELECT /*+ PRECOMPUTE_SUBQUERY */ NVL(PORTFOLIO_SCOPE_KEY,0) FROM PORTFOLIO_SCOPE WHERE CODE IN('with_sft','no_sft'))
     AND entity_key = (SELECT NVL(ENTITY_KEY,0) FROM ENTITY WHERE CODE = '36004367')
      order by OUTSTANDING_KEY) tmp
where prio = 1;