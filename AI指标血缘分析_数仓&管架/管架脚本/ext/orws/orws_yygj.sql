SELECT
    id
    ,organnum
    ,risk_level
    ,num
    ,task_date
    ,craete_date
    ,type_name
    ,problemer_no
    ,problemer_name
FROM ${src_schema}.yygj
WHERE 1 = 1 