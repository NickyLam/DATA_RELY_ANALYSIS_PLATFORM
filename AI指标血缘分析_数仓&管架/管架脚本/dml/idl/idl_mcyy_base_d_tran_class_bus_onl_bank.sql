/*
Purpose:    BASE_D_TRAN_CLASS_BUS_ONL_BANK:交易类基础指标结果表:网银
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_tran_class_bus_onl_bank
Createdate: 20220430

Logs:
            
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop tmp tables and add partition
whenever sqlerror continue none;

alter table ${idl_schema}.base_d_tran_class_bus_onl_bank add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

drop table ${idl_schema}.tmp_base_d_tran_class_bus_onl_bank purge;

-- 1.2 create tmp tables
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_base_d_tran_class_bus_onl_bank
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_tran_class_bus_onl_bank
where 0=1;

-- 2.指标数据逻辑开始
-- 2.1 指标数据前置依赖
whenever sqlerror exit sql.sqlcode;
INSERT /*+ append */ INTO ${idl_schema}.TMP_base_d_tran_class_bus_onl_bank
(
INDEX_NO
,ORG_NO
,SUP_ORG_NO
,INDEX_VALUE_D
,INDEX_VALUE_M
,INDEX_VALUE_Q
,INDEX_VALUE_Y
,ESPEC_DIMEN_CD1
,ESPEC_DIMEN_CD2
,ESPEC_DIMEN_CD3
,ESPEC_DIMEN_CD4
,ESPEC_DIMEN_CD5
,REMARK
,ETL_DT
,ETL_TIMESTAMP
)
WITH 
ST1 AS (SELECT * FROM itl_edw_evt_priv_onl_bank_tran_flow WHERE ETL_DT>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy') AND ETL_DT <=to_date('${batch_date}', 'yyyymmdd')),
ST2 AS (SELECT * FROM itl_edw_evt_bank_pc_edit_tran_flow  WHERE ETL_DT>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy') AND ETL_DT <=to_date('${batch_date}', 'yyyymmdd')),
ST3 AS (SELECT * FROM ITL_EDW_CMM_DEP_ACCT_INFO WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')),
ST4 AS (SELECT * FROM MCYY_ORGA_PARA WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')),
ST5 AS (SELECT * FROM itl_edw_evt_conl_bk_payoff_tran_h WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')),

--2.2 指标数据生成
--网银交易量_个人
TMP_WD040601_INDV AS (
SELECT 
'WD040601' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,COUNT(CASE WHEN ST1.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_D 
,COUNT(CASE WHEN ST1.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_M
,COUNT(CASE WHEN ST1.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Q 
,COUNT(CASE WHEN ST1.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Y
,CASE WHEN ST1.tran_amt>0 THEN '1' ELSE '2' END AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST1 LEFT JOIN ST3 ON ST1.whole_unify_cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE (ST1.tran_code IN ('TPS02002',
                         'TPS08002',
                         'TPS12001',
                         'TPS12004',
                         'TPS10005',
                         'TPS10004',
                         'TPS08002',
                         'TPS02018',
                         'TPS02018',
                         'TPS08011')
 OR ST1.tran_code IN ('FLS01009',
                            'FLS01010',
                            'FLS15001',
                            'FLS12007',
                            'FLS05013',
                            'FLS12006',
                            'TPS06014',
                            'TPS06015',
                            'FLS02040',
                            'FLS02021',
                            'FLS02022',
                            'FLS15003',
                            'FLS15005',
                            'FLS05005',
                            'FLS05006',
                            'FLS21015',
                            'FLS16004',
                            'FLS03075',
                            'FLS16004',
                            'FLS16004',
                            'FLS16004',
                            'FLS12012',
                            'FLS21014'))
   AND ST1.tran_status_cd = '90'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易量_企业_非资金
TMP_WD040601_CORP_1 AS (
SELECT 
'WD040601' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO  AS SUP_ORG_NO
,COUNT(CASE WHEN ST2.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_D
,COUNT(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_M
,COUNT(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Q
,COUNT(CASE WHEN ST2.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Y
,'1' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST2 LEFT JOIN ST3 ON ST2.unify_cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE (ST2.tran_amt IS NULL OR ST2.tran_amt = 0) OR
       ST2.tran_order = 'ReceiptPrint' OR ST2.tran_order LIKE '%LoanApply%')
   AND ST2.tran_status_cd = '90'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易量_企业_资金1
TMP_WD040601_CORP_2 AS (
SELECT
'WD040601' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,COUNT(CASE WHEN ST2.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_D
,COUNT(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_M
,COUNT(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Q
,COUNT(CASE WHEN ST2.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Y
,'2' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST2 LEFT JOIN ST3 ON ST2.unify_cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE (st2.tran_amt IS NOT NULL AND st2.tran_amt > 0 AND st2.tran_amt <> 0)
   AND st2.tran_order != 'BatchTransfer'
   AND st2.tran_order != 'Expenses'
   AND st2.tran_order != 'SalaryPay'
   AND st2.tran_order != 'ReceiptPrint'
   AND st2.tran_order NOT LIKE '%LoanApply%'
   AND st2.tran_status_cd = '90'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易量_企业_资金2
TMP_WD040601_CORP_3 AS (
SELECT 
'WD040601' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,COUNT(CASE WHEN ST5.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_D
,COUNT(CASE WHEN ST5.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_M
,COUNT(CASE WHEN ST5.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Q
,COUNT(CASE WHEN ST5.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN 1 END) AS INDEX_VALUE_Y
,'2' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST5 LEFT JOIN ST3 ON ST5.cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE ST5.tran_status_cd = '1'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易量 
TMP_WD040601 AS (
SELECT 
'WD040601' AS INDEX_NO
,ORG_NO AS ORG_NO
,SUP_ORG_NO AS SUP_ORG_NO
,SUM(INDEX_VALUE_D) AS INDEX_VALUE_D
,SUM(INDEX_VALUE_M) AS INDEX_VALUE_M
,SUM(INDEX_VALUE_Q) AS INDEX_VALUE_Q
,SUM(INDEX_VALUE_Y) AS INDEX_VALUE_Y
,ESPEC_DIMEN_CD1 AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  TMP_WD040601_INDV
UNION ALL TMP_WD040601_CORP_1
UNION ALL TMP_WD040601_CORP_2
UNION ALL TMP_WD040601_CORP_3
GROUP BY ORG_NO,SUP_ORG_NO,ESPEC_DIMEN_CD1
),
--网银交易额_个人
TMP_WD040602_INDV AS (
SELECT 
'WD040602' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,SUM(CASE WHEN ST1.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN ST1.tran_amt END) AS INDEX_VALUE_D
,SUM(CASE WHEN ST1.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN ST1.tran_amt END) AS INDEX_VALUE_M
,SUM(CASE WHEN ST1.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN ST1.tran_amt END) AS INDEX_VALUE_Q
,SUM(CASE WHEN ST1.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST1.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN ST1.tran_amt END) AS INDEX_VALUE_Y
,'2' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST1 LEFT JOIN ST3 ON ST1.whole_unify_cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE (ST1.tran_code IN ('TPS02002',
                         'TPS08002',
                         'TPS12001',
                         'TPS12004',
                         'TPS10005',
                         'TPS10004',
                         'TPS08002',
                         'TPS02018',
                         'TPS02018',
                         'TPS08011')
 OR ST1.tran_code IN ('FLS01009',
                            'FLS01010',
                            'FLS15001',
                            'FLS12007',
                            'FLS05013',
                            'FLS12006',
                            'TPS06014',
                            'TPS06015',
                            'FLS02040',
                            'FLS02021',
                            'FLS02022',
                            'FLS15003',
                            'FLS15005',
                            'FLS05005',
                            'FLS05006',
                            'FLS21015',
                            'FLS16004',
                            'FLS03075',
                            'FLS16004',
                            'FLS16004',
                            'FLS16004',
                            'FLS12012',
                            'FLS21014'))
   AND ST1.tran_status_cd = '90'
   AND ST1.tran_amt>0
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易额_企业_资金1
TMP_WD040602_CORP_1 AS (
SELECT 
'WD040602' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,SUM(CASE WHEN ST2.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN st2.tran_amt END) AS INDEX_VALUE_D
,SUM(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st2.tran_amt END) AS INDEX_VALUE_M
,SUM(CASE WHEN ST2.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st2.tran_amt END) AS INDEX_VALUE_Q
,SUM(CASE WHEN ST2.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST2.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st2.tran_amt END) AS INDEX_VALUE_Y
,'2' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST2 LEFT JOIN ST3 ON ST2.unify_cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE (st2.tran_amt IS NOT NULL AND st2.tran_amt > 0 AND st2.tran_amt <> 0)
   AND st2.tran_order != 'BatchTransfer'
   AND st2.tran_order != 'Expenses'
   AND st2.tran_order != 'SalaryPay'
   AND st2.tran_order != 'ReceiptPrint'
   AND st2.tran_order NOT LIKE '%LoanApply%'
   AND st2.tran_status_cd = '90'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易额_企业_资金2
TMP_WD040602_CORP_2 AS (
SELECT 
'WD040602' AS INDEX_NO
,ST3.OPEN_ACCT_ORG_ID AS ORG_NO
,ST4.SUP_ORG_NO AS SUP_ORG_NO
,SUM(CASE WHEN ST5.tran_dt=to_date('${batch_date}', 'yyyymmdd') THEN st5.tran_amt END) AS INDEX_VALUE_D
,SUM(CASE WHEN ST5.tran_dt>=trunc(to_date('${batch_date}','yyyyMMdd'),'MM')  AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st5.tran_amt END) AS INDEX_VALUE_M
,SUM(CASE WHEN ST5.tran_dt>=trunc(to_date('${batch_date}','yyyymmdd') ,'Q') AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st5.tran_amt END) AS INDEX_VALUE_Q
,SUM(CASE WHEN ST5.tran_dt>= trunc(to_date('${batch_date}','yyyyMMdd') ,'yyyy')AND ST5.tran_dt <=to_date('${batch_date}', 'yyyymmdd') THEN st5.tran_amt END) AS INDEX_VALUE_Y
,'2' AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  ST5 LEFT JOIN ST3 ON ST5.cust_id=ST3.CUST_ID LEFT JOIN ST4 ON ST4.ORG_NO=ST3.OPEN_ACCT_ORG_ID
WHERE ST5.tran_status_cd = '1'
GROUP BY ST3.OPEN_ACCT_ORG_ID,ST4.SUP_ORG_NO
),
--网银交易额
TMP_WD040602 AS (
SELECT 
'WD040602' AS INDEX_NO
,ORG_NO AS ORG_NO
,SUP_ORG_NO AS SUP_ORG_NO
,SUM(INDEX_VALUE_D) AS INDEX_VALUE_D
,SUM(INDEX_VALUE_M) AS INDEX_VALUE_M
,SUM(INDEX_VALUE_Q) AS INDEX_VALUE_Q
,SUM(INDEX_VALUE_Y) AS INDEX_VALUE_Y
,ESPEC_DIMEN_CD1 AS ESPEC_DIMEN_CD1
,'' AS ESPEC_DIMEN_CD2
,'' AS ESPEC_DIMEN_CD3
,'' AS ESPEC_DIMEN_CD4
,'' AS ESPEC_DIMEN_CD5
,'' AS REMARK
,to_date('${batch_date}','yyyymmdd') AS ETL_DT
,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') AS ETL_TIMESTAMP
FROM  TMP_WD040602_INDV
UNION ALL TMP_WD040602_CORP_1
UNION ALL TMP_WD040602_CORP_2
GROUP BY ORG_NO,SUP_ORG_NO,ESPEC_DIMEN_CD1
),
DB_REST AS (
SELECT * FROM TMP_WD040601
UNION ALL 
SELECT * FROM TMP_WD040602
)
SELECT 
*
FROM DB_REST;
COMMIT;


-- 3.2 exchage ex table and target table
alter table ${idl_schema}.base_d_tran_class_bus_onl_bank exchange partition p_${batch_date} with table ${idl_schema}.tmp_base_d_tran_class_bus_onl_bank;

-- 3.3 drop tmp table
drop TABLE ${idl_schema}.tmp_base_d_tran_class_bus_onl_bank purge;

-- 4.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_tran_class_bus_onl_bank',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);



