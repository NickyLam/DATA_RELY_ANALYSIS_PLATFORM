/*
Purpose:    客户开户数D层-业务分析表:数据来源于核心+电子账户
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_acct_open
Createdate: 20210427

-- 以下为依赖了上游的表 :
msl_cbss_kna_accs
msl_cbss_kna_dpac
msl_cbss_kna_accs_dele 
msl_cbss_kna_acct_repl
msl_cbss_cifs_cfb_cust
msl_cbss_knc_acid
msl_cbss_kna_acct
msl_iats_billing_account
msl_iats_bill_card_acc_assoc
msl_iats_billing_account_type
itl_edw_cmm_dep_acct_info
Logs:
            
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

drop table ${idl_schema}.tmp_mcyy_bu_detail_acct_open purge;
drop table ${idl_schema}.mcyy_bu_analysis_temp_ratio purge;
drop table ${idl_schema}.mcyy_bu_analysis_temp purge;
drop table ${idl_schema}.mcyy_bu_analysis_final purge;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_acct_open;
alter table ${idl_schema}.mcyy_bu_detail truncate subpartition p_${batch_date}_acct_open;


-- 1.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_acct_open values ('ACCT_OPEN')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_acct_open values ('ACCT_OPEN')
;

alter table ${idl_schema}.mcyy_bu_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_acct_open values ('ACCT_OPEN')
                                              )
;
alter table ${idl_schema}.mcyy_bu_detail modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_acct_open values ('ACCT_OPEN')
;

-- 1.3 create temp tables 
create table ${idl_schema}.tmp_mcyy_bu_detail_acct_open as select * from ${idl_schema}.mcyy_bu_detail where 1=2 ;
--计算结构占比临时表
create table  ${idl_schema}.mcyy_bu_analysis_temp_ratio compress 
		as   
		select INDEX_NO 
     ,ORG_NO    
     ,ETL_DT    
     ,BU_TYPE   
     ,DAY_RATIO_INDEX --日占比
     ,MON_RATIO_INDEX --月占比
     ,QUAR_RATIO_INDEX --季占比
     ,YEAR_RATIO_INDEX --年占比
from ${idl_schema}.mcyy_bu_analysis 
where 1=2 ; 

create table ${idl_schema}.mcyy_bu_analysis_temp as select * from ${idl_schema}.mcyy_bu_analysis where 1=2 ;
create table ${idl_schema}.mcyy_bu_analysis_final as select * from ${idl_schema}.mcyy_bu_analysis where 1=2 ;

-- 2.1 基础指标数据处理
whenever sqlerror exit sql.sqlcode;
--2.1.1 第一组 对公结算账户数据
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--对公结算开户数临时表

    WITH tmp_corp_stl_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.spectp IN ('4'
                          ,'5'
                          ,'6'
                          ,'7')
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.spectp IN ('4'
                          ,'5'
                          ,'6'
                          ,'7')
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公结算开户数数据
    tmp_corp_stl_open_data AS 
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,(CASE e.spectp
                          WHEN '4' THEN
                           'WD030103'
                          WHEN '6' THEN
                           'WD030104'
                          WHEN '7' THEN
                           'WD030105'
                          WHEN '5' THEN
                           'WD030106'
                      END) AS index_no
                      ,t3.open_acct_chn_type_cd AS DATA_SOURCE
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp NOT IN ('1'
                             ,'3'
                             ,'7')
      INNER  JOIN tmp_corp_stl_open e
      ON     e.acctno = a.acctno
      LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
                       ,t.DATA_SOURCE
    FROM   tmp_corp_stl_open_data t;
COMMIT;

--2.1.2 第二组 对公定期存款账户开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--对公定期存款账户开户数临时表
    WITH tmp_corp_reg_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.debttp NOT IN ('P01'
                              ,'A18'
                              ,'A14'
                              ,'A13'
                              ,'A12')
      AND    t2.spectp = '9'
      AND    t2.acustg NOT LIKE '2002%'
        AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.debttp NOT IN ('P01'
                              ,'A18'
                              ,'A14'
                              ,'A13'
                              ,'A12')
      AND    t2.spectp = '9'
      AND    t2.acustg NOT LIKE '2002%'
        AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公定期开户数数据
    tmp_corp_reg_open_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030107' AS index_no
                     ,nvl(t3.open_acct_chn_type_cd,'1001') AS DATA_SOURCE --对公定期存在取不到渠道 TODO
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp NOT IN ('1'
                             ,'3'
                             ,'7')
      INNER  JOIN tmp_corp_reg_open e
      ON     e.acctno = a.acctno
      LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,t.DATA_SOURCE
    FROM   tmp_corp_reg_open_data t;

COMMIT;

--2.1.3 第三组 对公保证金开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--对公保证金账户开户数临时表
    WITH tmp_corp_margin_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    (t2.debttp = 'P01' OR t2.acustg LIKE '2002%')
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    (t2.debttp = 'P01' OR t2.acustg LIKE '2002%')
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公保证金开户数数据
    tmp_corp_margin_open_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030108' AS index_no
                      ,nvl(t3.open_acct_chn_type_cd,'1001') AS DATA_SOURCE --对公保证金存在取不到渠道 TODO
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp NOT IN ('1'
                             ,'3'
                             ,'7')
      INNER  JOIN tmp_corp_margin_open e
      ON     e.acctno = a.acctno
     LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,t.DATA_SOURCE
    FROM   tmp_corp_margin_open_data t;

COMMIT;

--2.1.4 第四组 个人结算I类开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--个人结算I类开户数临时表
    WITH tmp_indv_stl_open_first AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.debttp = 'S01'
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = '1'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.debttp = 'S01'
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = '1'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --个人结算I类开户数数据
    tmp_indv_stl_open_first_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030203' AS index_no
      							 ,t3.open_acct_chn_type_cd AS DATA_SOURCE
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp IN ('1'
                         ,'3'
                         ,'7')
      INNER  JOIN tmp_indv_stl_open_first e
      ON     e.acctno = a.acctno
      LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,T.DATA_SOURCE
    FROM   tmp_indv_stl_open_first_data t;


COMMIT;

--2.1.5 第五组 个人结算II/III类开户数据
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,T.DATA_SOURCE
    FROM   (SELECT DISTINCT bill.external_account_id AS bu_no
                           ,bill.account_branch_id AS bu_org_no
                           ,to_char(bill.from_date
                                   ,'yyyymmdd') AS bu_dt
                           ,(CASE bill.account_category_level
                                WHEN 'SECOND-ACCT' THEN
                                 'WD030204'
                                WHEN 'THIRD-ACCT' THEN
                                 'WD030205'
                            END) AS index_no
                            ,bill.CHANNEL AS DATA_SOURCE
            FROM   msl_iats_billing_account bill
            LEFT   JOIN msl_iats_bill_card_acc_assoc axx
            ON     axx.account_no = bill.external_account_id
            WHERE  bill.status_id NOT IN ('4')
            AND    bill.account_type IN
                   (SELECT billing_account_type_id
                     FROM   msl_iats_billing_account_type
                     WHERE  parent_type_id = 'PRIVATE_E')
            AND    (bill.account_category_level = 'SECOND-ACCT' OR
                  bill.account_category_level = 'THIRD-ACCT')
            AND    to_char(bill.from_date
                          ,'YYYYMMDD') = '${batch_date}') t;
COMMIT;


--2.1.6 第六组 个人定期开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--个人定期开户数临时表
    WITH tmp_indv_reg_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t1.subsac = '00001'
      AND    t2.debttp = 'S02'
            
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = '0'
      WHERE  t1.accstp = '0'
      AND    t1.subsac = '00001'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t1.subsac = '00001'
      AND    t2.debttp = 'S02'
            
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = '0'
      WHERE  t1.accstp = '0'
      AND    t1.subsac = '00001'
      AND    t1.crcycd = '01'),
    --个人定期开户数(核心+电子)
    tmp_indv_reg_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030206' AS index_no
                     ,t3.open_acct_chn_type_cd AS DATA_SOURCE
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp IN ('1'
                         ,'3'
                         ,'7')
      INNER  JOIN tmp_indv_reg_open e
      ON     e.acctno = a.acctno
      LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt
      
      UNION ALL
      
      SELECT DISTINCT bill.external_account_id AS bu_no
                     ,bill.account_branch_id AS bu_org_no
                     ,to_char(bill.from_date
                             ,'yyyymmdd') AS bu_dt
                     ,'WD030206' AS index_no
                     ,bill.CHANNEL as DATA_SOURCE
      FROM   msl_iats_billing_account bill
      LEFT   JOIN msl_iats_bill_card_acc_assoc axx
      ON     axx.account_no = bill.external_account_id
      WHERE  bill.status_id NOT IN ('4')
      AND    bill.account_type IN
             (SELECT billing_account_type_id
               FROM   msl_iats_billing_account_type
               WHERE  parent_type_id = 'PRIVATE_E')
      AND    bill.account_category_level = 'FIXED-ACCT'
      AND    to_char(bill.from_date
                    ,'YYYYMMDD') = '${batch_date}'
      
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,T.DATA_SOURCE
    FROM   tmp_indv_reg_open_data t;


COMMIT;


--2.1.7 第七组 外汇结算开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--外汇结算开户数临时表
    WITH tmp_fx_stl_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = 'F'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = 'F'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'),
    --外汇结算开户数据
    tmp_fx_stl_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030301' AS index_no
      
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      INNER  JOIN tmp_fx_stl_open e
      ON     e.acctno = a.acctno
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt
      
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_fx_stl_open_data t;

COMMIT;

--2.1.8 第八组 外汇定期、保证金开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--外汇定期、保证金开户临时表
    WITH tmp_fx_non_stl_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
             ,T2.debttp
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = 'G'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
            ,T2.debttp

      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp = 'G'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'),
    --外汇定期、保证金开户数据
    tmp_fx_non_stl_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,(CASE
                          WHEN e.debttp = 'P01' THEN
                           'WD030303'
                          ELSE
                           'WD030302'
                      END) AS index_no
      
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      INNER  JOIN tmp_fx_non_stl_open e
      ON     e.acctno = a.acctno
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt
      
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_fx_non_stl_open_data t;

COMMIT;

--2.1.9 第九组 个人保证金开户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)
--个人保证金开户数临时表
    WITH tmp_indv_margin_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    (t2.debttp = 'P01' OR t2.acustg LIKE '2002%')
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    (t2.debttp = 'P01' OR t2.acustg LIKE '2002%')
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --个人保证金开户数数据
    tmp_indv_margin_open_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030214' AS index_no
                     ,NVL(T3.open_acct_chn_type_cd,'1001') as DATA_SOURCE --个人保证金取不到渠道 TODO
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp  IN ('1'
                             ,'3'
                             ,'7')
      INNER  JOIN tmp_indv_margin_open e
      ON     e.acctno = a.acctno
      LEFT  JOIN itl_edw_cmm_dep_acct_info T3
      ON t3.acct_id =  e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,DATA_SOURCE            
    FROM   tmp_indv_margin_open_data t;

COMMIT;
--2.1.10 第十组 外汇结算开户数据按渠道区分(对公、个人)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp, data_source)

    WITH tmp_fx_open AS
     (
      
      SELECT t1.acctno
             ,t1.subsac
             ,t1.acctid
             ,t1.accstp
             ,t1.basetg
             ,t1.crcycd
             ,t1.csextg
             ,t1.prodcd
             ,t1.acpdcd
             ,t2.spectp
             ,t2.opendt
      FROM   msl_cbss_kna_accs t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp IN ('F'
                          ,'G')
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'
      
      UNION
      SELECT t1.acctno
            ,t1.subsac
            ,t1.acctid
            ,t1.accstp
            ,t1.basetg
            ,t1.crcycd
            ,t1.csextg
            ,t1.prodcd
            ,t1.acpdcd
            ,t2.spectp
            ,t2.opendt
      FROM   msl_cbss_kna_accs_dele t1
      INNER  JOIN msl_cbss_kna_dpac t2
      ON     t2.acctid = t1.acctid
      AND    t2.acustg NOT LIKE '2002%'
      AND    substr(t2.opendt
                   ,1
                   ,8) = '${batch_date}'
      AND    t2.spectp IN ('F'
                          ,'G')
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'),
    --外汇结算开户数据(对公、个人)
    tmp_fx_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,(CASE WHEN d.custtp IN ('1'
                                             ,'3'
                                             ,'7') THEN 'WD030310' ELSE
                       'WD030309' END ) AS index_no
          ,nvl(f.open_acct_chn_type_cd,'1001') AS data_source --TODO     
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      INNER  JOIN tmp_fx_open e
      ON     e.acctno = a.acctno
      LEFT   JOIN itl_edw_cmm_dep_acct_info f
      ON     f.acct_id = e.acctid
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND    a.opendt = e.opendt
      
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,data_source
    FROM   tmp_fx_open_data t;

COMMIT;


-- 2.2 组合指标数据处理
whenever sqlerror exit sql.sqlcode;

--2.2.1 第一组 人民币对公结算账户开户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,DATA_SOURCE
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030102' as index_no,DATA_SOURCE
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open
            WHERE  index_no IN ('WD030103'
                               ,'WD030104'
                               ,'WD030105'
                               ,'WD030106')
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.2 第二组 人民币对公账户开户数(含保证金)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
             --对公的开户渠道只显示 1013流程银行/1009PAD移动终端/1001柜面渠道，其他渠道一律归类为柜面渠道
          ,(CASE WHEN t.data_source NOT IN ('1001','1009','1013') THEN '1001' else t.data_source end  ) AS data_source
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030117' as index_no,DATA_SOURCE
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open
            WHERE  index_no IN ('WD030102'
                               ,'WD030107'
                               ,'WD030108'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.3 第三组 人民币个人结算账户开户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,DATA_SOURCE
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030202' as index_no,DATA_SOURCE
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open
            WHERE  index_no IN ('WD030203'
                               ,'WD030204'
                               ,'WD030205'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.4 第四组 人民币个人账户开户数(含保证金)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp,DATA_SOURCE)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
         ,(CASE WHEN DATA_SOURCE='1218' THEN '9999' else DATA_SOURCE END) AS DATA_SOURCE
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030213' as index_no,DATA_SOURCE
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open
            WHERE  index_no IN ('WD030202'
                               ,'WD030206'
                               ,'WD030214'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.5 第五组 外汇账户开户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030307' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open
            WHERE  index_no IN ('WD030301'
                               ,'WD030302'
                               ,'WD030303'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.6 第六组 对公账户开户数(渠道)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp, data_source)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
           --对公的开户渠道只显示 1013流程银行/1009PAD移动终端/1001柜面渠道，其他渠道一律归类为柜面渠道
          ,(CASE WHEN t.data_source NOT IN ('1001','1009','1013') THEN '1001' else t.data_source END ) AS data_source
    FROM   (SELECT bu_org_no
                  ,bu_no
                  ,bu_dt
                  ,'WD030118' AS index_no
                  ,data_source
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open t1
            WHERE  T1.index_no IN ('WD030117'
                               ,'WD030309')
            AND    T1.etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')
            AND t1.data_source IS NOT NULL
            ) t;

COMMIT;

--2.2.3 第七组 个人账户开户数(渠道)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_open
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp, data_source)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
          ,data_source
    FROM   (SELECT bu_org_no
                  ,bu_no
                  ,bu_dt
                  ,'WD030216' AS index_no
                  , data_source
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open T1
            WHERE  T1.index_no IN ('WD030213'
                               ,'WD030310')
            AND    T1.etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')
            AND t1.data_source IS NOT NULL                       
            ) t;

COMMIT;


--3.1 对指标数据汇总处理
--3.1.1 区分渠道

set serveroutput  on 
--根据开户类指标循环遍历明细数据生成汇总数据

DECLARE
    CURSOR cur_acct_open_index IS
        SELECT t.index_no,t.index_name_mcs
        FROM   ${idl_schema}.mcyy_index_define t
        WHERE  t.index_clsaa_s_mcs = '账户类业务'
        AND    t.index_name_mcs LIKE '%开户%'
        AND    T.DEPT_USE='内页'
        AND    EXISTS (SELECT 1 FROM MCYY_DIM_INDEX WHERE INDEX_NO=t.INDEX_NO);

BEGIN 
 FOR rec_acct_open_index IN cur_acct_open_index
 LOOP
  INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp
                (etl_dt -- 数据日期
                ,etl_timestamp -- ETL处理时间戳
                ,index_no -- 指标编码
                ,index_name -- 指标名称
                ,org_no -- 机构编码
                ,org_name -- 机构名称
                ,super_org_no -- 上级机构编码
                ,accu_index_value_d -- 当日累计
                ,accu_index_value_m -- 当月累计
                ,accu_index_value_q -- 当季累计
                ,accu_index_value_y -- 当年累计
                ,rate_up_day -- 比上日
                ,rate_last_month -- 比上月
                ,rate_last_quater -- 比上季
                ,rate_last_year -- 比上年
                ,rate_last_period -- 同比
                ,rate_up_day_per -- 比上日百分比
                ,rate_last_month_per -- 比上月百分比
                ,rate_last_quater_per -- 比上季百分比
                ,rate_last_year_per -- 比上年百分比
                ,rate_last_period_per -- 同比百分比
                ,index_ranking -- 当前排名
                ,index_ranking_cha -- 排名变动
                ,unit -- 单位
                ,frequency -- 频度
                ,measure_no --- 度量编号
                ,index_measure -- 度量名称
                ,source_sys --来源系统
                ,bu_type 
                 )
                WITH tmp_td_initza AS
                --当日数据初始化
                 (SELECT t4.index_no
                        , --指标编码
                         t4.index_name_mcs AS index_name
                        , --指标名称
                         t1.org_no AS org_no
                        , --机构编码
                         t1.org_name AS org_name
                        , --机构名称
                         t1.super_org_no AS super_org_no
                        , --上级机构编码
                         CASE
                             WHEN t1.org_no = '000000' THEN
                              SUM(coalesce(t2.index_value
                                          ,0)) over(PARTITION BY t4.index_no ,t1.bu_type)
                             WHEN length(t1.org_no) = 3 THEN
                              SUM(coalesce(t2.index_value
                                          ,0)) over(PARTITION BY substr(t1.org_no
                                                          ,1
                                                          ,3),t1.bu_type)
                             ELSE
                              coalesce(t2.index_value
                                      ,0)
                         END AS accu_index_value_d
                        , --当日累计
                         rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.index_value, 0) DESC) AS index_ranking
                        , --当前排名
                         t4.unit
                        , -- 单位
                         t4.frequency
                        , -- 频度
                         NULL measure_no
                        , --- 度量编号
                         t4.index_measure -- 度量名称
                        ,T1.BU_TYPE AS BU_TYPE 
                  FROM   (SELECT *
                     FROM   mcyy_orga_para org_tab
                   ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
        FROM   mcyy_index_define t1
        LEFT   JOIN mcyy_dim_index t2
        ON     t1.index_no = t2.index_no
        LEFT   JOIN mcyy_dim_define t3
        ON     t2.dim_class = t3.dim_class
        AND    t3.dim_class_name IS NOT NULL
        WHERE  t1.index_no = rec_acct_open_index.index_no) dim_tab )t1
                  LEFT   JOIN (SELECT count(distinct t.bu_no) AS index_value
                                     --89以及800001机构要统计但是暂不显示
                                    ,(CASE
                                         WHEN substr(t.BU_org_no
                                                    ,1
                                                    ,2) = '89'
                                              OR t.BU_org_no = '800001' THEN
                                          '-000000'                                        
                                         ELSE
                                          t.BU_org_no
                                     END) AS org_no
                                    ,T.etl_dt
                                    ,t.index_no AS index_no
                                    ,fun_code_conv(t.DATA_SOURCE,rec_acct_open_index.index_no) as bu_type--关联不到直接用产品渠道，对公不可能关联不到
                              FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open t
                              WHERE  t.etl_dt =to_date('${batch_date}'
                                   ,'yyyymmdd')
                              AND    t.index_no = rec_acct_open_index.index_no
                              GROUP BY (CASE
                                         WHEN substr(t.bu_org_no
                                                    ,1
                                                    ,2) = '89'
                                              OR t.bu_org_no = '800001' THEN
                                          '-000000'                                        
                                         ELSE
                                          t.bu_org_no
                                     END),T.etl_dt,t.index_no,t.DATA_SOURCE
                              ) t2
                  ON     t1.org_no = t2.org_no
                  and    t1.bu_type=t2.bu_type
                  INNER  JOIN mcyy_index_define t4
                  ON     rec_acct_open_index.index_no = t4.index_no_mcs),
                --取上日数据来做日比较类计算
                tmp_ld_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         --当月初取当日数据作为当月累计，否则在上日的数据基础上累加
                         CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'mm') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_m
                                                    ,0)
                         END AS accu_index_value_m --当月累计
                         --当季初取当日数据作为当季累计，否则在上日的数据基础上累加
                        ,CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'Q') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_q
                                                    ,0)
                         END AS accu_index_value_q --当季累计 
                         --当年初取当日数据作为当年累计，否则在上日的数据基础上累加
                        ,CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'yy') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_y
                                                    ,0)
                         END AS accu_index_value_y --当年累计
                        ,coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                               ,0) AS rate_up_day --比上日   
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_d
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_d
                                             ,0) - coalesce(t2.accu_index_value_d
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_d
                                            ,0)
                                   ,6)
                         END AS rate_up_day_per --比上日百分比 
                         
                       ,t1.index_ranking- t2.index_ranking AS index_ranking_cha --排名变动   
                       -- ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY t1.accu_index_value_d DESC) - t2.index_ranking AS index_ranking_cha --排名变动                                                  
                          ,t1.bu_type
                  FROM   tmp_td_initza t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上日数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd') - 1
                  AND T1.BU_TYPE=T2.BU_TYPE                 
                                   ),
                --取上月数据来做月比较类计算
                
                tmp_lm_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_m
                                 ,0) - coalesce(t2.accu_index_value_m
                                               ,0) AS rate_last_month --比上月  
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_m
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_m
                                             ,0) - coalesce(t2.accu_index_value_m
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_m
                                            ,0)
                                   ,6)
                         END AS rate_last_month_per --比上月百分比  
                         ,t1.bu_type   
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-1)
                   AND T1.BU_TYPE=T2.BU_TYPE  ),
                --取上季数据来做月比较类计算
                tmp_lq_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_q
                                 ,0) - coalesce(t2.accu_index_value_q
                                               ,0) AS rate_last_quater --比上季 
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_q
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_q
                                             ,0) - coalesce(t2.accu_index_value_q
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_q
                                            ,0)
                                   ,6)
                         END AS rate_last_quater_per --比上季百分比   
                         ,t1.bu_type
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上季数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-3)
                                           AND T1.BU_TYPE=T2.BU_TYPE      ),
                
                tmp_ly_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_y
                                 ,0) - coalesce(t2.accu_index_value_y
                                               ,0) AS rate_last_year --比上年
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_y
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_y
                                             ,0) - coalesce(t2.accu_index_value_y
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_y
                                            ,0)
                                   ,6)
                         END AS rate_last_year_per --比上年百分比   
                         ,t1.bu_type
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-12)
                  AND T1.BU_TYPE=T2.BU_TYPE  ),
                tmp_yoy_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                               ,0) AS rate_last_period --同比
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_d
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_d
                                             ,0) - coalesce(t2.accu_index_value_d
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_d
                                            ,0)
                                   ,6)
                         END AS rate_last_period_per --同比百分比   
                         ,t1.bu_type
                  FROM   tmp_td_initza t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                               ,-12)
                                                AND T1.BU_TYPE=T2.BU_TYPE      )
                
                SELECT to_date('${batch_date}'
                                   ,'yyyymmdd') etl_dt -- 数据日期
                      ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
                      ,mcyy_bu_analysis_tmp.index_no -- 指标编码
                      ,mcyy_bu_analysis_tmp.index_name -- 指标名称
                      ,mcyy_bu_analysis_tmp.org_no -- 机构编码
                      ,mcyy_bu_analysis_tmp.org_name -- 机构名称
                      ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计
                      ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_month) -- 比上月
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_quater) -- 比上季
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_year) -- 比上年
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_period) -- 同比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_up_day) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_up_day_per) = 0 THEN
            							1
          						 ELSE
            						SUM(mcyy_bu_analysis_tmp.rate_up_day_per)
       									END) -- 比上日百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_month) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_month_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_month_per) 
          						 end)  -- 比上月百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_quater) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) 
          						 end)  -- 比上季百分比
          						 ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_year) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_year_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_year_per) 
          						 end)-- 比上年百分比
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_period_per) -- 同比百分比
                      ,mcyy_bu_analysis_tmp.index_ranking -- 当前排名
                      ,mcyy_bu_analysis_tmp.index_ranking_cha -- 排名变动
                      ,mcyy_bu_analysis_tmp.unit -- 单位
                      ,mcyy_bu_analysis_tmp.frequency -- 频度
                      ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
                      ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
                      ,'ACCT_OPEN' source_sys --来源系统
                      --,rec_acct_open_index.index_name_mcs source_sys --来源系统
                      ,mcyy_bu_analysis_tmp.bu_type
                FROM   (SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,accu_index_value_d
                              ,NULL               accu_index_value_m
                              ,NULL               accu_index_value_q
                              ,NULL               accu_index_value_y
                              ,NULL               rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,NULL               rate_last_year
                              ,NULL               rate_last_period
                              ,NULL               rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,NULL               rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                              ,bu_type
                        FROM   tmp_td_initza
                        
                        UNION ALL
                        
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL               accu_index_value_d
                              ,accu_index_value_m
                              ,accu_index_value_q
                              ,accu_index_value_y
                              ,rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,NULL               rate_last_year
                              ,NULL               rate_last_period
                              ,rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,NULL               rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                              ,bu_type
                        FROM   tmp_ld_data
                        
                        UNION ALL
                        SELECT
                        
                         index_no
                        ,index_name
                        ,org_no
                        ,org_name
                        ,super_org_no
                        ,NULL                accu_index_value_d
                        ,NULL                accu_index_value_m
                        ,NULL                accu_index_value_q
                        ,NULL                accu_index_value_y
                        ,NULL                rate_up_day
                        ,rate_last_month
                        ,NULL                rate_last_quater
                        ,NULL                rate_last_year
                        ,NULL                rate_last_period
                        ,NULL                rate_up_day_per
                        ,rate_last_month_per
                        ,NULL                rate_last_quater_per
                        ,NULL                rate_last_year_per
                        ,NULL                rate_last_period_per
                        ,index_ranking
                        ,0                   index_ranking_cha
                        ,
                         
                         unit
                        ,frequency
                        ,measure_no
                        ,index_measure
                        ,bu_type
                        FROM   tmp_lm_data
                        
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL                 accu_index_value_d
                              ,NULL                 accu_index_value_m
                              ,NULL                 accu_index_value_q
                              ,NULL                 accu_index_value_y
                              ,NULL                 rate_up_day
                              ,NULL                 rate_last_month
                              ,rate_last_quater
                              ,NULL                 rate_last_year
                              ,NULL                 rate_last_period
                              ,NULL                 rate_up_day_per
                              ,NULL                 rate_last_month_per
                              ,rate_last_quater_per
                              ,NULL                 rate_last_year_per
                              ,NULL                 rate_last_period_per
                              ,index_ranking
                              ,0                    index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                              ,bu_type
                        FROM   tmp_lq_data
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL               accu_index_value_d
                              ,NULL               accu_index_value_m
                              ,NULL               accu_index_value_q
                              ,NULL               accu_index_value_y
                              ,NULL               rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,rate_last_year
                              ,NULL               rate_last_period
                              ,NULL               rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                              ,bu_type
                        FROM   tmp_ly_data
                        
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL                 accu_index_value_d
                              ,NULL                 accu_index_value_m
                              ,NULL                 accu_index_value_q
                              ,NULL                 accu_index_value_y
                              ,NULL                 rate_up_day
                              ,NULL                 rate_last_month
                              ,NULL                 rate_last_quater
                              ,NULL                 rate_last_year
                              ,rate_last_period
                              ,NULL                 rate_up_day_per
                              ,NULL                 rate_last_month_per
                              ,NULL                 rate_last_quater_per
                              ,NULL                 rate_last_year_per
                              ,rate_last_period_per
                              ,index_ranking
                              ,0                    index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                              ,bu_type
                        FROM   tmp_yoy_data
                        
                        ) mcyy_bu_analysis_tmp
                
                GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
                         ,mcyy_bu_analysis_tmp.index_name -- 指标名称
                         ,mcyy_bu_analysis_tmp.org_no -- 机构编码
                         ,mcyy_bu_analysis_tmp.org_name -- 机构名称
                         ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
                         ,mcyy_bu_analysis_tmp.index_ranking
                         ,mcyy_bu_analysis_tmp.index_ranking_cha
                         ,mcyy_bu_analysis_tmp.unit -- 单位
                         ,mcyy_bu_analysis_tmp.frequency -- 频度
                         ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
                         ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
                         ,mcyy_bu_analysis_tmp.bu_type 
                ;
                
 
 
 
 COMMIT;
        
 END LOOP;

exception
  when others then
    rollback;
    dbms_output.put_line('营运开户类指标汇总出错 ' || sqlerrm);


end;
/

--3.1.2 正常指标不区分渠道
set serveroutput  on 
--根据开户类指标循环遍历明细数据生成汇总数据

DECLARE
    CURSOR cur_acct_open_index IS
        SELECT t.index_no,t.index_name_mcs
        FROM   ${idl_schema}.mcyy_index_define t
        WHERE  t.index_clsaa_s_mcs = '账户类业务'
        AND    t.index_name_mcs LIKE '%开户%'
        AND    T.DEPT_USE='内页'
        AND    NOT EXISTS (SELECT 1 FROM MCYY_DIM_INDEX WHERE INDEX_NO=t.INDEX_NO);

BEGIN 
 FOR rec_acct_open_index IN cur_acct_open_index
 LOOP
  INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp
                (etl_dt -- 数据日期
                ,etl_timestamp -- ETL处理时间戳
                ,index_no -- 指标编码
                ,index_name -- 指标名称
                ,org_no -- 机构编码
                ,org_name -- 机构名称
                ,super_org_no -- 上级机构编码
                ,accu_index_value_d -- 当日累计
                ,accu_index_value_m -- 当月累计
                ,accu_index_value_q -- 当季累计
                ,accu_index_value_y -- 当年累计
                ,rate_up_day -- 比上日
                ,rate_last_month -- 比上月
                ,rate_last_quater -- 比上季
                ,rate_last_year -- 比上年
                ,rate_last_period -- 同比
                ,rate_up_day_per -- 比上日百分比
                ,rate_last_month_per -- 比上月百分比
                ,rate_last_quater_per -- 比上季百分比
                ,rate_last_year_per -- 比上年百分比
                ,rate_last_period_per -- 同比百分比
                ,index_ranking -- 当前排名
                ,index_ranking_cha -- 排名变动
                ,unit -- 单位
                ,frequency -- 频度
                ,measure_no --- 度量编号
                ,index_measure -- 度量名称
                ,source_sys --来源系统
                 )
                WITH tmp_td_initza AS
                --当日数据初始化
                 (SELECT t4.index_no
                        , --指标编码
                         t4.index_name_mcs AS index_name
                        , --指标名称
                         t1.org_no AS org_no
                        , --机构编码
                         t1.org_name AS org_name
                        , --机构名称
                         t1.super_org_no AS super_org_no
                        , --上级机构编码
                         CASE
                             WHEN t1.org_no = '000000' THEN
                              SUM(coalesce(t2.index_value
                                          ,0)) over(PARTITION BY t4.index_no)
                             WHEN length(t1.org_no) = 3 THEN
                              SUM(coalesce(t2.index_value
                                          ,0)) over(PARTITION BY substr(t1.org_no
                                                          ,1
                                                          ,3))
                             ELSE
                              coalesce(t2.index_value
                                      ,0)
                         END AS accu_index_value_d
                        , --当日累计
                         rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY coalesce(t2.index_value, 0) DESC) AS index_ranking
                        , --当前排名
                         t4.unit
                        , -- 单位
                         t4.frequency
                        , -- 频度
                         NULL measure_no
                        , --- 度量编号
                         t4.index_measure -- 度量名称
                  FROM   mcyy_orga_para t1
                  LEFT   JOIN (SELECT count(distinct t.bu_no) AS index_value
                                     --89以及800001机构要统计但是暂不显示
                                    ,(CASE
                                         WHEN substr(t.BU_org_no
                                                    ,1
                                                    ,2) = '89'
                                              OR t.BU_org_no = '800001' THEN
                                          '-000000'                                        
                                         ELSE
                                          t.BU_org_no
                                     END) AS org_no
                                    ,T.etl_dt
                                    ,t.index_no AS index_no
                              FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open t
                              WHERE  t.etl_dt =to_date('${batch_date}'
                                   ,'yyyymmdd')
                              AND    t.index_no = rec_acct_open_index.index_no
                              GROUP BY (CASE
                                         WHEN substr(t.bu_org_no
                                                    ,1
                                                    ,2) = '89'
                                              OR t.bu_org_no = '800001' THEN
                                          '-000000'                                        
                                         ELSE
                                          t.bu_org_no
                                     END),T.etl_dt,t.index_no 
                              ) t2
                  ON     t1.org_no = t2.org_no
                  INNER  JOIN mcyy_index_define t4
                  ON     rec_acct_open_index.index_no = t4.index_no_mcs),
                --取上日数据来做日比较类计算
                tmp_ld_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         --当月初取当日数据作为当月累计，否则在上日的数据基础上累加
                         CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'mm') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_m
                                                    ,0)
                         END AS accu_index_value_m --当月累计
                         --当季初取当日数据作为当季累计，否则在上日的数据基础上累加
                        ,CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'Q') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_q
                                                    ,0)
                         END AS accu_index_value_q --当季累计 
                         --当年初取当日数据作为当年累计，否则在上日的数据基础上累加
                        ,CASE
                             WHEN trunc(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                       ,'yy') = to_date('${batch_date}'
                                   ,'yyyymmdd') THEN
                              t1.accu_index_value_d
                             ELSE
                              coalesce(t1.accu_index_value_d
                                      ,0) + coalesce(t2.accu_index_value_y
                                                    ,0)
                         END AS accu_index_value_y --当年累计
                        ,coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                               ,0) AS rate_up_day --比上日   
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_d
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_d
                                             ,0) - coalesce(t2.accu_index_value_d
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_d
                                            ,0)
                                   ,6)
                         END AS rate_up_day_per --比上日百分比 
                         
                       ,t1.index_ranking- t2.index_ranking AS index_ranking_cha --排名变动   
                       -- ,rank() over(PARTITION BY decode(length(t1.super_org_no), '1', 1, '3', 2, '6', 3) ORDER BY t1.accu_index_value_d DESC) - t2.index_ranking AS index_ranking_cha --排名变动                                                  
                  FROM   tmp_td_initza t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上日数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd') - 1),
                --取上月数据来做月比较类计算
                
                tmp_lm_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_m
                                 ,0) - coalesce(t2.accu_index_value_m
                                               ,0) AS rate_last_month --比上月  
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_m
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_m
                                             ,0) - coalesce(t2.accu_index_value_m
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_m
                                            ,0)
                                   ,6)
                         END AS rate_last_month_per --比上月百分比     
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上月数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-1)),
                --取上季数据来做月比较类计算
                tmp_lq_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_q
                                 ,0) - coalesce(t2.accu_index_value_q
                                               ,0) AS rate_last_quater --比上季 
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_q
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_q
                                             ,0) - coalesce(t2.accu_index_value_q
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_q
                                            ,0)
                                   ,6)
                         END AS rate_last_quater_per --比上季百分比   
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上季数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-3)),
                
                tmp_ly_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_y
                                 ,0) - coalesce(t2.accu_index_value_y
                                               ,0) AS rate_last_year --比上年
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_y
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_y
                                             ,0) - coalesce(t2.accu_index_value_y
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_y
                                            ,0)
                                   ,6)
                         END AS rate_last_year_per --比上年百分比   
                  FROM   tmp_ld_data t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                         ,'yyyymmdd')
                 ,-12)),
                tmp_yoy_data AS
                 (SELECT t1.index_no
                        , ---- 指标编码
                         t1.index_name
                        , -- 指标名称
                         t1.org_no
                        , -- 机构编码
                         t1.org_name
                        , -- 机构名称
                         t1.super_org_no
                        , -- 上级机构编码
                         t1.index_ranking
                        , -- 当前排名
                         t1.unit
                        , -- 单位
                         t1.frequency
                        , -- 频度
                         t1.measure_no
                        , -- 度量编号
                         t1.index_measure
                        , -- 度量名称
                         coalesce(t1.accu_index_value_d
                                 ,0) - coalesce(t2.accu_index_value_d
                                               ,0) AS rate_last_period --同比
                        ,CASE
                             WHEN coalesce(t2.accu_index_value_d
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.accu_index_value_d
                                             ,0) - coalesce(t2.accu_index_value_d
                                                            ,0)) /
                                    coalesce(t2.accu_index_value_d
                                            ,0)
                                   ,6)
                         END AS rate_last_period_per --同比百分比   
                  FROM   tmp_td_initza t1 -- 当日数据
                  LEFT   JOIN ${idl_schema}.mcyy_bu_analysis t2 --上年数据
                  ON     t1.index_no = t2.index_no
                  AND    t1.org_no = t2.org_no
                  AND    t2.etl_dt = add_months(to_date('${batch_date}'
                                   ,'yyyymmdd')
                                               ,-12))
                
                SELECT to_date('${batch_date}'
                                   ,'yyyymmdd') etl_dt -- 数据日期
                      ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
                      ,mcyy_bu_analysis_tmp.index_no -- 指标编码
                      ,mcyy_bu_analysis_tmp.index_name -- 指标名称
                      ,mcyy_bu_analysis_tmp.org_no -- 机构编码
                      ,mcyy_bu_analysis_tmp.org_name -- 机构名称
                      ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_d) -- 当日累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_m) -- 当月累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_q) -- 当季累计
                      ,SUM(mcyy_bu_analysis_tmp.accu_index_value_y) -- 当年累计
                      ,SUM(mcyy_bu_analysis_tmp.rate_up_day) -- 比上日
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_month) -- 比上月
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_quater) -- 比上季
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_year) -- 比上年
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_period) -- 同比
                       ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_up_day) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_up_day_per) = 0 THEN
            							1
          						 ELSE
            						SUM(mcyy_bu_analysis_tmp.rate_up_day_per)
       									END) -- 比上日百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_month) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_month_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_month_per) 
          						 end)  -- 比上月百分比
                      ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_quater) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_quater_per) 
          						 end)  -- 比上季百分比
          						 ,(CASE
          						 WHEN SUM(mcyy_bu_analysis_tmp.rate_last_year) > 0
               					 AND SUM(mcyy_bu_analysis_tmp.rate_last_year_per) = 0 THEN
            							1
          						 ELSE 
          						 SUM(mcyy_bu_analysis_tmp.rate_last_year_per) 
          						 end)-- 比上年百分比
                      ,SUM(mcyy_bu_analysis_tmp.rate_last_period_per) -- 同比百分比
                      ,mcyy_bu_analysis_tmp.index_ranking -- 当前排名
                      ,mcyy_bu_analysis_tmp.index_ranking_cha -- 排名变动
                      ,mcyy_bu_analysis_tmp.unit -- 单位
                      ,mcyy_bu_analysis_tmp.frequency -- 频度
                      ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
                      ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
                      ,'ACCT_OPEN' source_sys --来源系统
                      --,rec_acct_open_index.index_name_mcs source_sys --来源系统
                FROM   (SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,accu_index_value_d
                              ,NULL               accu_index_value_m
                              ,NULL               accu_index_value_q
                              ,NULL               accu_index_value_y
                              ,NULL               rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,NULL               rate_last_year
                              ,NULL               rate_last_period
                              ,NULL               rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,NULL               rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                        FROM   tmp_td_initza
                        
                        UNION ALL
                        
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL               accu_index_value_d
                              ,accu_index_value_m
                              ,accu_index_value_q
                              ,accu_index_value_y
                              ,rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,NULL               rate_last_year
                              ,NULL               rate_last_period
                              ,rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,NULL               rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                        FROM   tmp_ld_data
                        
                        UNION ALL
                        SELECT
                        
                         index_no
                        ,index_name
                        ,org_no
                        ,org_name
                        ,super_org_no
                        ,NULL                accu_index_value_d
                        ,NULL                accu_index_value_m
                        ,NULL                accu_index_value_q
                        ,NULL                accu_index_value_y
                        ,NULL                rate_up_day
                        ,rate_last_month
                        ,NULL                rate_last_quater
                        ,NULL                rate_last_year
                        ,NULL                rate_last_period
                        ,NULL                rate_up_day_per
                        ,rate_last_month_per
                        ,NULL                rate_last_quater_per
                        ,NULL                rate_last_year_per
                        ,NULL                rate_last_period_per
                        ,index_ranking
                        ,0                   index_ranking_cha
                        ,
                         
                         unit
                        ,frequency
                        ,measure_no
                        ,index_measure
                        FROM   tmp_lm_data
                        
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL                 accu_index_value_d
                              ,NULL                 accu_index_value_m
                              ,NULL                 accu_index_value_q
                              ,NULL                 accu_index_value_y
                              ,NULL                 rate_up_day
                              ,NULL                 rate_last_month
                              ,rate_last_quater
                              ,NULL                 rate_last_year
                              ,NULL                 rate_last_period
                              ,NULL                 rate_up_day_per
                              ,NULL                 rate_last_month_per
                              ,rate_last_quater_per
                              ,NULL                 rate_last_year_per
                              ,NULL                 rate_last_period_per
                              ,index_ranking
                              ,0                    index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                        
                        FROM   tmp_lq_data
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL               accu_index_value_d
                              ,NULL               accu_index_value_m
                              ,NULL               accu_index_value_q
                              ,NULL               accu_index_value_y
                              ,NULL               rate_up_day
                              ,NULL               rate_last_month
                              ,NULL               rate_last_quater
                              ,rate_last_year
                              ,NULL               rate_last_period
                              ,NULL               rate_up_day_per
                              ,NULL               rate_last_month_per
                              ,NULL               rate_last_quater_per
                              ,rate_last_year_per
                              ,NULL               rate_last_period_per
                              ,index_ranking
                              ,0                  index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                        FROM   tmp_ly_data
                        
                        UNION ALL
                        SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,NULL                 accu_index_value_d
                              ,NULL                 accu_index_value_m
                              ,NULL                 accu_index_value_q
                              ,NULL                 accu_index_value_y
                              ,NULL                 rate_up_day
                              ,NULL                 rate_last_month
                              ,NULL                 rate_last_quater
                              ,NULL                 rate_last_year
                              ,rate_last_period
                              ,NULL                 rate_up_day_per
                              ,NULL                 rate_last_month_per
                              ,NULL                 rate_last_quater_per
                              ,NULL                 rate_last_year_per
                              ,rate_last_period_per
                              ,index_ranking
                              ,0                    index_ranking_cha
                              ,
                               
                               unit
                              ,frequency
                              ,measure_no
                              ,index_measure
                        FROM   tmp_yoy_data
                        
                        ) mcyy_bu_analysis_tmp
                
                GROUP  BY mcyy_bu_analysis_tmp.index_no -- 指标编码
                         ,mcyy_bu_analysis_tmp.index_name -- 指标名称
                         ,mcyy_bu_analysis_tmp.org_no -- 机构编码
                         ,mcyy_bu_analysis_tmp.org_name -- 机构名称
                         ,mcyy_bu_analysis_tmp.super_org_no -- 上级机构编码
                         ,mcyy_bu_analysis_tmp.index_ranking
                         ,mcyy_bu_analysis_tmp.index_ranking_cha
                         ,mcyy_bu_analysis_tmp.unit -- 单位
                         ,mcyy_bu_analysis_tmp.frequency -- 频度
                         ,mcyy_bu_analysis_tmp.measure_no --- 度量编号
                         ,mcyy_bu_analysis_tmp.index_measure -- 度量名称
                ;
                
 
 
 
 COMMIT;
        
 END LOOP;
  
   

exception
  when others then
    rollback;
    dbms_output.put_line('营运开户类指标汇总出错 ' || sqlerrm);


end;
/

-- 总体计算结构占比
  --分类型指标计算

  INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp_ratio
     SELECT f.index_no -- 指标编号  
           ,f.org_no -- 机构
           ,f.etl_dt -- 日期
           ,f.bu_type -- 渠道
           ,ratio_to_report(f.accu_index_value_d) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 日占比
           ,ratio_to_report(f.accu_index_value_m) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 月占比
           ,ratio_to_report(f.accu_index_value_q) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 季占比
           ,ratio_to_report(f.accu_index_value_y) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 年占比
     FROM   mcyy_bu_analysis_temp f
     LEFT   JOIN mcyy_index_define d
     ON     d.index_no = f.index_no
     WHERE  d.index_clsaa_s_mcs = '账户类业务'
     AND    d.unit = '户'
     AND    d.index_state = '在用'
     AND    d.index_name_mcs LIKE '%开户%'
     AND    d.dept_use = '内页'
     AND    (d.index_clsaa_t_mcs = '人民币对公结算账户' OR
           d.index_clsaa_t_mcs = '人民币对公非结算账户' OR
           d.index_clsaa_t_mcs = '人民币个人结算账户' OR
           d.index_clsaa_t_mcs = '人民币个人非结算账户' OR
           d.index_clsaa_t_mcs = '外汇非结算账户' OR
           --以下汇总
           d.index_clsaa_t_mcs = '人民币对公结算账户汇总' OR
           d.index_clsaa_t_mcs = '人民币个人结算账户汇总' OR
           d.index_clsaa_t_mcs = '外汇结算账户汇总' OR
           d.index_clsaa_t_mcs = '外汇对公/个人账户汇总')
     AND    f.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd');
 
 COMMIT;
 --区分渠道汇总型指标计算
 INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp_ratio
     SELECT f.index_no -- 指标编号  
           ,f.org_no -- 机构
           ,f.etl_dt -- 日期
           ,f.bu_type -- 渠道
           ,ratio_to_report(f.accu_index_value_d) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 日占比
           ,ratio_to_report(f.accu_index_value_m) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 月占比
           ,ratio_to_report(f.accu_index_value_q) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 季占比
           ,ratio_to_report(f.accu_index_value_y) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 年占比
     FROM   mcyy_bu_analysis_temp f
     LEFT   JOIN mcyy_index_define d
     ON     d.index_no = f.index_no
     WHERE  d.index_clsaa_s_mcs = '账户类业务'
     AND    d.unit = '户'
     AND    d.index_state = '在用'
     AND    d.index_name_mcs LIKE '%开户%'
     AND    d.dept_use = '内页'
     AND    (d.index_clsaa_t_mcs = '对公账户汇总' OR
           d.index_clsaa_t_mcs = '个人账户汇总' OR
           d.index_clsaa_t_mcs = '外汇对公账户汇总' OR
           d.index_clsaa_t_mcs = '外汇个人账户汇总' OR
           d.index_clsaa_t_mcs = '人民币对公账户汇总' OR
           d.index_clsaa_t_mcs = '人民币个人账户汇总')
     AND    f.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd');
 COMMIT;

--将结构占比数据回插事实表

INSERT INTO ${idl_schema}.mcyy_bu_analysis_final
    (etl_dt -- 数据日期
    ,etl_timestamp -- ETL处理时间戳
    ,index_no -- 指标编码
    ,index_name -- 指标名称
    ,org_no -- 机构编码
    ,org_name -- 机构名称
    ,super_org_no -- 上级机构编码
    ,accu_index_value_d -- 当日累计
    ,accu_index_value_m -- 当月累计
    ,accu_index_value_q -- 当季累计
    ,accu_index_value_y -- 当年累计
    ,rate_up_day -- 比上日
    ,rate_last_month -- 比上月
    ,rate_last_quater -- 比上季
    ,rate_last_year -- 比上年
    ,rate_last_period -- 同比
    ,rate_up_day_per -- 比上日百分比
    ,rate_last_month_per -- 比上月百分比
    ,rate_last_quater_per -- 比上季百分比
    ,rate_last_year_per -- 比上年百分比
    ,rate_last_period_per -- 同比百分比
    ,day_ratio_index --日占比
    ,mon_ratio_index --月占比
    ,quar_ratio_index --季占比
    ,year_ratio_index --年占比
    ,index_ranking -- 当前排名
    ,index_ranking_cha -- 排名变动
    ,unit -- 单位
    ,frequency -- 频度
    ,measure_no --- 度量编号
    ,index_measure -- 度量名称
    ,source_sys --来源系统
    ,BU_TYPE 
     )
    SELECT t1.etl_dt -- 数据日期
          ,t1.etl_timestamp -- ETL处理时间戳
          ,t1.index_no -- 指标编码
          ,t1.index_name -- 指标名称
          ,t1.org_no -- 机构编码
          ,t1.org_name -- 机构名称
          ,t1.super_org_no -- 上级机构编码
          ,t1.accu_index_value_d -- 当日累计
          ,t1.accu_index_value_m -- 当月累计
          ,t1.accu_index_value_q -- 当季累计
          ,t1.accu_index_value_y -- 当年累计
          ,t1.rate_up_day -- 比上日
          ,t1.rate_last_month -- 比上月
          ,t1.rate_last_quater -- 比上季
          ,t1.rate_last_year -- 比上年
          ,t1.rate_last_period -- 同比
          ,t1.rate_up_day_per -- 比上日百分比
          ,t1.rate_last_month_per -- 比上月百分比
          ,t1.rate_last_quater_per -- 比上季百分比
          ,t1.rate_last_year_per -- 比上年百分比
          ,t1.rate_last_period_per -- 同比百分比
          ,t2.day_ratio_index --日占比
          ,t2.mon_ratio_index --月占比
          ,t2.quar_ratio_index --季占比
          ,t2.year_ratio_index --年占比
          ,t1.index_ranking -- 当前排名
          ,t1.index_ranking_cha -- 排名变动
          ,t1.unit -- 单位
          ,t1.frequency -- 频度
          ,t1.measure_no --- 度量编号
          ,t1.index_measure -- 度量名称
          ,t1.source_sys --来源系统
          ,T1.BU_TYPE
    
    FROM   mcyy_bu_analysis_temp t1
    LEFT   JOIN mcyy_bu_analysis_temp_ratio t2
    ON     t1.etl_dt = t2.etl_dt
    AND    t1.org_no = t2.org_no
    AND    t1.index_no = t2.index_no
    AND    nvl(t1.bu_type
              ,'null') = nvl(t2.bu_type
                             ,'null');
COMMIT;

--3.2 将临时表数据回插后删除临时表
--whenever sqlerror continue none;

INSERT INTO ${idl_schema}.mcyy_bu_detail
    (etl_dt
    ,bu_org_no
    ,bu_no
    ,bu_dt
    ,index_no
    ,etl_timestamp
    ,source_sys
    ,data_source)
    SELECT etl_dt
          ,bu_org_no
          ,bu_no
          ,bu_dt
          ,index_no
          ,etl_timestamp
          ,'ACCT_OPEN' AS source_sys
          ,data_source
    FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_open;

COMMIT;
drop TABLE ${idl_schema}.tmp_mcyy_bu_detail_acct_open purge;
ALTER TABLE ${idl_schema}.mcyy_bu_analysis exchange SUBPARTITION p_${batch_date}_acct_open WITH TABLE ${idl_schema}.mcyy_bu_analysis_final;

-- 4.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);



