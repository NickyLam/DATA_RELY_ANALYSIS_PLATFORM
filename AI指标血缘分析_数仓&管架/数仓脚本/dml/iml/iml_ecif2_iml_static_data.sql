/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 iml_ecif2_iml_static_data
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

alter session force parallel query parallel 8; 

-- 清除表
whenever sqlerror continue none ;
DROP TABLE IML.PTY_PARTY_CERT_INFO_H_ECIF1_STATIC_DATA PURGE;
DROP TABLE IML.PTY_PARTY_PHYS_ADDR_H_ECIF1_STATIC_DATA PURGE;
DROP TABLE IML.PTY_PARTY_ELEC_ADDR_H_ECIF1_STATIC_DATA PURGE;

-- ECIF1.0关联人静态数据处理
-- 关联人证件历史
whenever sqlerror exit sql.sqlcode;
CREATE TABLE IML.PTY_PARTY_CERT_INFO_H_ECIF1_STATIC_DATA 
nologging                                                 
COMPRESS for query high
AS 
WITH WITH_REL_PARTY AS
 (SELECT *
    FROM IML.PTY_PARTY T2
   WHERE T2.CREATE_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
     AND T2.ID_MARK <> 'D'
     AND T2.PARTY_TYPE_CD NOT IN
         ('301004', '301008', '301007', '301005', '201003', '201004')
     AND T2.JOB_CD = 'eifsf1')
SELECT DISTINCT T2.PARTY_ID,
       T1.LP_ID,
       T1.SORC_SYS_CD,
       T1.CERT_TYPE_CD,
       T1.CERT_NUM,
       T1.CERT_ADDR,
       T1.ISSUE_CERT_ORG,
       T1.ISSUE_CERT_ORG_CTY_CD,
       T1.CERT_EFFECT_DT,
       T1.CERT_INVALID_DT,
       T1.LICEN_ISSUE_AUTHO_DIST_CD,
       T1.CRDT_CD_CERT_ID,
       T1.CERT_VALID_FLG,
       T1.CERT_STATUS_CD,
       T1.MAIN_CERT_NO_FLG,
       ' ' AS NETW_VRFCTION_FLG,
       ' ' AS NETW_VRFCTION_REST_CD,
       T1.START_DT,
       T1.END_DT,
       T1.ID_MARK,
       T1.SRC_TABLE_NAME,
       T1.JOB_CD,
       T1.ETL_TIMESTAMP
  FROM IML.PTY_PARTY_CERT_INFO_H_ECIF1_20210326 T1
 INNER JOIN WITH_REL_PARTY T2
   ON T1.PARTY_ID = NVL(T2.SRC_PARTY_ID, T2.PARTY_ID)
 WHERE T1.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.JOB_CD = 'eifsf1'
   AND (TRIM(T1.CERT_NUM) IS NOT NULL OR TRIM(T1.CERT_TYPE_CD) IS NOT NULL)
   AND NOT EXISTS
 (SELECT 1
          FROM IML.PTY_PARTY_CERT_INFO_H T3, WITH_REL_PARTY t4
         WHERE T2.PARTY_ID = T3.PARTY_ID
           AND T3.PARTY_ID = T4.PARTY_ID
           AND NVL(T1.CERT_TYPE_CD, '0000') = NVL(T3.CERT_TYPE_CD, '0000')
           AND T3.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.JOB_CD = 'eifsf1');

-- 关联人物理地址历史
CREATE TABLE IML.PTY_PARTY_PHYS_ADDR_H_ECIF1_STATIC_DATA
nologging                                                 
COMPRESS for query high
AS
WITH WITH_REL_PARTY AS
 (SELECT T2.*
    FROM IML.PTY_PARTY T2
   WHERE T2.CREATE_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
     AND T2.ID_MARK <> 'D'
     AND T2.PARTY_TYPE_CD NOT IN
         ('301004', '301008', '301007', '301005', '201003', '201004')
     AND T2.JOB_CD = 'eifsf1')
SELECT T2.PARTY_ID,
       T1.LP_ID,
       T1.SRC_SYS_CD,
       T1.PHYS_ADDR_TYPE_CD,
       T1.SEQ_NUM,
       T1.CONT_ADDR,
       T1.ZIP_CD,
       T1.TEL_NUM,
       T1.FAX_NUM,
       T1.CTY_RG_CD,
       T1.PHYS_ADDR,
       T1.DIST_CD,
       T1.ADDR_STATUS_TYPE_CD,
       ' ' AS FC_FLG,
       ' ' AS PROV_CD,
       ' ' AS CITY_CD,
       ' ' AS RG_COUNTY_CD,
       ' ' AS STREET_NAME,
       T1.START_DT,
       T1.END_DT,
       T1.ID_MARK,
       T1.SRC_TABLE_NAME,
       T1.JOB_CD,
       T1.ETL_TIMESTAMP
  FROM IML.PTY_PARTY_PHYS_ADDR_H_ECIF1_20210326 T1
 INNER JOIN WITH_REL_PARTY T2
    ON T1.PARTY_ID = NVL(T2.SRC_PARTY_ID, T2.PARTY_ID)
 WHERE T1.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.JOB_CD = 'eifsf1'
   AND TRIM(T1.CONT_ADDR) IS NOT NULL
   AND NOT EXISTS
 (SELECT 1
          FROM IML.PTY_PARTY_PHYS_ADDR_H T3, WITH_REL_PARTY t4
         WHERE T1.PARTY_ID = T3.PARTY_ID
           AND T3.PARTY_ID = T4.PARTY_ID
           AND NVL(T1.PHYS_ADDR_TYPE_CD, '999999') =
               NVL(T3.PHYS_ADDR_TYPE_CD, '999999')
           AND T3.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.JOB_CD = 'eifsf1');
           
-- 关联人电子地址历史
CREATE TABLE IML.PTY_PARTY_ELEC_ADDR_H_ECIF1_STATIC_DATA 
nologging                                                 
COMPRESS for query high
AS
WITH WITH_REL_PARTY AS
 (SELECT T2.*
    FROM IML.PTY_PARTY T2
   WHERE T2.CREATE_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
     AND T2.ID_MARK <> 'D'
     AND T2.PARTY_TYPE_CD NOT IN
         ('301004', '301008', '301007', '301005', '201003', '201004')
     AND T2.JOB_CD = 'eifsf1')
SELECT T2.PARTY_ID,
       T1.LP_ID,
       T1.SRC_SYS_CD,
       T1.ELEC_ADDR_TYPE_CD,
       T1.SEQ_NUM,
       T1.ELEC_ADDR,
       T1.MAIN_ELEC_ADDR_FLG,
       ' ' AS DD_AREA_CD,
       ' ' AS EXT_NUM,
       T1.START_DT,
       T1.END_DT,
       T1.ID_MARK,
       T1.SRC_TABLE_NAME,
       T1.JOB_CD,
       T1.ETL_TIMESTAMP
  FROM IML.PTY_PARTY_ELEC_ADDR_H_ECIF1_20210326 T1
 INNER JOIN WITH_REL_PARTY T2
    ON T1.PARTY_ID = NVL(T2.SRC_PARTY_ID, T2.PARTY_ID)
 WHERE T1.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
   AND T1.JOB_CD = 'eifsf1'
   AND TRIM(T1.ELEC_ADDR) IS NOT NULL
   AND NOT EXISTS
 (SELECT 1
          FROM IML.PTY_PARTY_ELEC_ADDR_H T3, WITH_REL_PARTY t4
         WHERE T1.PARTY_ID = T4.SRC_PARTY_ID
           AND T3.PARTY_ID = T4.PARTY_ID
           AND NVL(T1.ELEC_ADDR_TYPE_CD, ' ') =
               NVL(T3.ELEC_ADDR_TYPE_CD, ' ')
           AND T3.START_DT <= TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.END_DT > TO_DATE('${batch_date}', 'YYYYMMDD')
           AND T3.JOB_CD = 'eifsf1');


GRANT SELECT ON IML.PTY_PARTY_CERT_INFO_H_ECIF1_STATIC_DATA TO ICL,IEL,IDL;
GRANT SELECT ON IML.PTY_PARTY_PHYS_ADDR_H_ECIF1_STATIC_DATA TO ICL,IEL,IDL;
GRANT SELECT ON IML.PTY_PARTY_ELEC_ADDR_H_ECIF1_STATIC_DATA TO ICL,IEL,IDL;


commit;