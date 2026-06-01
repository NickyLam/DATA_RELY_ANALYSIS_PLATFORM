/*
Purpose:    BASE_D_ACCT_CLASS_BUS(BASE_D_ACCT_CLASS_BUS_INCRS):账户类基础指标结果表(账户类基础指标结果表_增长)
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_acct_class_bus_incrs
Createdate: 20220509

Logs:
   郑沛隆 2022-05-09 新建脚本         
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop tmp tables and add partition
whenever sqlerror continue none;

alter table ${idl_schema}.base_d_acct_class_bus_incrs add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

drop table ${idl_schema}.tmp_base_d_acct_class_bus_incrs purge;

-- 1.2 create tmp tables
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_base_d_acct_class_bus_incrs
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_acct_class_bus_incrs
where 0=1;

-- 2.指标数据逻辑开始
-- 2.1 指标数据前置依赖

whenever sqlerror exit sql.sqlcode;
INSERT /*+ append */ INTO ${idl_schema}.TMP_BASE_D_ACCT_CLASS_BUS_INCRS
(
INDEX_NO
,ORG_NO
,SUP_ORG_NO
,INDEX_VALUE_D
,INDEX_VALUE_M
,INDEX_VALUE_Q
,INDEX_VALUE_Y
,ESPEC_DIMEN_CD1
,ETL_DT
,ETL_TIMESTAMP
)

WITH ST1 AS (
SELECT *
FROM ITL_EDW_CMM_DEP_OC_ACCT_DTL 
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
ST2 AS (
SELECT * 
FROM ITL_EDW_CMM_DEP_ACCT_INFO
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
AND  OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy') 
AND  OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')
),
ST3 AS (
SELECT * 
FROM ITL_EDW_EVT_CARD_CHANGE_RGST_B
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
ST4 AS (
SELECT *
FROM MCYY_ORGA_PARA
--WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
--2.2 指标数据生成

--人民币对公账户开户数
TMP_WD030101 AS (
SELECT 
'WD030101'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.CUST_ACCT_ID END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.CUST_ACCT_ID END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.CUST_ACCT_ID END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.CUST_ACCT_ID END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' 
AND ST2.CORP_ACCT_FLG = '1'
AND ST2.ACCT_USAGE_CD NOT LIKE '2002%'
AND ((ST2.ACCT_CLS_CD IN ('11001','11002','11003','11004')) 
OR (
ST2.ACCT_CLS_CD <> '99001' 
AND ST2.RC_FLG ='1' 
AND ST2.CUST_ACCT_SUB_ACCT_NUM='1'))
AND NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO)
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公基本存款账户开户数
TMP_WD030103 AS (
SELECT 
'WD030103'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '11001' AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' and ST2.CORP_ACCT_FLG = '1'and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公一般存款账户开户数
TMP_WD030104 AS (
SELECT 
'WD030104'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '11002' AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' and ST2.CORP_ACCT_FLG = '1'and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公专用存款账户开户数
TMP_WD030105 AS (
SELECT 
'WD030105'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '11004' AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' and ST2.CORP_ACCT_FLG = '1'and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公临时账户开户数存款
TMP_WD030106 AS (
SELECT 
'WD030106'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '11003' AND ST2.ACCT_USAGE_CD NOT LIKE '2002%'and ST2.CORP_ACCT_FLG = '1'and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公定期存款账户开户数
TMP_WD030107 AS (
SELECT 
'WD030107'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD <> '99001' AND ST2.RC_FLG ='1' 
--AND ST2.MATER_ACCT_FLG = '1'
AND ST2.CUST_ACCT_SUB_ACCT_NUM='1'
AND ST2.ACCT_USAGE_CD NOT LIKE '2002%'and ST2.CORP_ACCT_FLG = '1'and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币对公保证金存款账户开户数
TMP_WD030108 AS (
SELECT 
'WD030108'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '99001' AND (ST2.STD_PROD_ID  IN ('103010200001', '103020700001') OR ST2.ACCT_USAGE_CD LIKE '2002%') AND  ST2.CORP_ACCT_FLG = '1' AND ST2.MATER_ACCT_FLG = '1' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
/*--人民币个人账户开户数
TMP_WD030201 AS (
SELECT 
'WD030201'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON (ST1.acct_id=ST2.cust_acct_id OR ST1.acct_id = ST2.CUST_ACCT_CARD_NO) AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ((ST2.STD_PROD_ID NOT IN ('101010200001', '101020500001') --去除保证金 
       AND ST2.ACCT_USAGE_CD not like '2002%' --去除保证金母户
       ) or ( ST2.RC_FLG = '1' AND ST2.MATER_ACCT_FLG <> '1' ) --去除定期子户
       )
        and ST2.CORP_ACCT_FLG = '0'
and ST2.cust_acct_id not like '24%' --剔除大额存单   
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
*/
--人民币个人结算Ⅰ类户开户数
TMP_WD030203 AS (
SELECT 
'WD030203'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON (ST1.acct_id=ST2.cust_acct_id OR ST1.acct_id = ST2.CUST_ACCT_CARD_NO) AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '21001' AND ST2.STD_PROD_ID = '101010100001' AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' AND  ST2.CORP_ACCT_FLG = '0' AND ST2.ACCT_TYPE_CD='1' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币个人结算Ⅱ类户开户数
TMP_WD030204 AS (
SELECT 
'WD030204'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '21001' AND  ST2.CORP_ACCT_FLG = '0' AND ST2.ACCT_TYPE_CD='2' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币个人结算Ⅲ类户开户数
TMP_WD030205 AS (
SELECT 
'WD030205'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '21001' AND  ST2.CORP_ACCT_FLG = '0' AND ST2.ACCT_TYPE_CD='3' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币个人定期存款账户开户数
TMP_WD030206 AS (
SELECT 
'WD030206'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' 
--and ST2.ACCT_CLS_CD = '21003' 
AND  ST2.CORP_ACCT_FLG = '0' 
AND ST2.CUST_ACCT_SUB_ACCT_NUM='1'
--and ST2.STD_PROD_ID = '101020100002'
--and ST2.STD_PROD_ID = '101020100009'
and (ST2.STD_PROD_ID = '101020100002'
       or ST2.STD_PROD_ID = '101020100009' or ST2.STD_PROD_ID='101020200001')
AND ST2.RC_FLG ='1' 
AND ST2.ACCT_USAGE_CD not LIKE '2002%'
--AND ST2.ACCT_TYPE_CD='9'
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--人民币个人保证金存款账户开户数
TMP_WD030214 AS (
SELECT 
'WD030214'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD = 'CNY' and ST2.ACCT_CLS_CD = '99001' AND  ST2.CORP_ACCT_FLG = '0' 
AND (ST2.STD_PROD_ID IN( '101010200001','101020500001') OR ST2.ACCT_USAGE_CD LIKE '2002%')
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--外汇结算账户开户数
TMP_WD030301 AS (
SELECT 
'WD030301'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD <> 'CNY' and ST2.ACCT_CLS_CD = '12001' 
AND ST2.STD_PROD_ID NOT IN ('103010200004','103020700004','101020600002') AND ST2.ACCT_USAGE_CD NOT LIKE '2002%'
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--外汇定期母户开户数
TMP_WD030302 AS (
SELECT 
'WD030302'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD <> 'CNY' and ST2.ACCT_CLS_CD = '12002' 
AND ST2.STD_PROD_ID NOT IN ('103010200004','103020700004','101020600002')  AND ST2.ACCT_USAGE_CD NOT LIKE '2002%'
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--外汇保证金母户开户数
TMP_WD030303 AS (
SELECT 
'WD030303'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO 
WHERE ST2.CURR_CD <> 'CNY' and ST2.ACCT_CLS_CD = '99001' 
AND (ST2.STD_PROD_ID IN ('103010200004','103020700004','101020600002')  OR ST2.ACCT_USAGE_CD NOT LIKE '2002%')
and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
--外汇账户对公开户数
TMP_WD030309 AS (
SELECT 
'WD030309'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD <> 'CNY' AND ST2.CORP_ACCT_FLG='1'  AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD 
),
--外汇账户个人开户数
TMP_WD030310 AS (
SELECT 
'WD030310'
,ST2.BELONG_ORG_ID
,ST4.SUPER_ORG_NO
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd')  THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,COUNT(DISTINCT (CASE WHEN ST2.OPEN_ACCT_DT >= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.OPEN_ACCT_DT <=to_date('${batch_date}', 'yyyymmdd') THEN ST2.cust_acct_id END))
,ST2.OPEN_ACCT_CHN_TYPE_CD
--,''
--,''
--,''
--,''
--,''
,to_date('${batch_date}','yyyymmdd')
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
FROM ST1 LEFT JOIN ST2 ON ST1.acct_id=ST2.cust_acct_id AND ST1.DEP_PROD_ACCT_ID=ST2.ACCT_ID    INNER JOIN ST4 ON ST2.BELONG_ORG_ID=ST4.ORG_NO
WHERE ST2.CURR_CD <> 'CNY' AND ST2.CORP_ACCT_FLG='0'  AND ST2.ACCT_USAGE_CD NOT LIKE '2002%' and NOT EXISTS (SELECT 1 FROM ST3 WHERE ST3.NEW_CARD_NUM=ST2.CUST_ACCT_CARD_NO )
GROUP BY ST2.BELONG_ORG_ID,ST4.SUPER_ORG_NO,ST2.OPEN_ACCT_CHN_TYPE_CD
),
-- 3.1 集合结果输出
DB_REST AS (
SELECT * FROM TMP_WD030101
UNION ALL SELECT * FROM TMP_WD030103
UNION ALL SELECT * FROM TMP_WD030104
UNION ALL SELECT * FROM TMP_WD030105
UNION ALL SELECT * FROM TMP_WD030106
UNION ALL SELECT * FROM TMP_WD030107
UNION ALL SELECT * FROM TMP_WD030108
--UNION ALL SELECT * FROM TMP_WD030201
UNION ALL SELECT * FROM TMP_WD030203
UNION ALL SELECT * FROM TMP_WD030204
UNION ALL SELECT * FROM TMP_WD030205
UNION ALL SELECT * FROM TMP_WD030206
UNION ALL SELECT * FROM TMP_WD030214
UNION ALL SELECT * FROM TMP_WD030301
UNION ALL SELECT * FROM TMP_WD030302
UNION ALL SELECT * FROM TMP_WD030303
UNION ALL SELECT * FROM TMP_WD030309
UNION ALL SELECT * FROM TMP_WD030310
)
SELECT 
*
FROM DB_REST;

COMMIT;


-- 3.2 exchage ex table and target table
alter table ${idl_schema}.base_d_acct_class_bus_incrs exchange partition p_${batch_date} with table ${idl_schema}.tmp_base_d_acct_class_bus_incrs;

-- 3.3 drop tmp table
drop TABLE ${idl_schema}.tmp_base_d_acct_class_bus_incrs purge;

-- 4.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_acct_class_bus_incrs',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);



