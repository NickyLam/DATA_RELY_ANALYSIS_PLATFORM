/*
Purpose:    客户存量户数D层-业务分析表:数据来源于核心+电子账户
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_bu_analysis_acct_sum
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

Logs:
            
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

drop table ${idl_schema}.tmp_mcyy_bu_detail_acct_sum purge;
drop table ${idl_schema}.mcyy_bu_analysis_temp1_ratio purge;
drop table ${idl_schema}.mcyy_bu_analysis_temp1 purge;
drop table ${idl_schema}.mcyy_bu_analysis_final1 purge;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_acct_sum;

alter table ${idl_schema}.mcyy_bu_detail truncate subpartition p_${batch_date}_acct_sum;

-- 1.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_acct_sum values ('ACCT_SUM')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_acct_sum values ('ACCT_SUM')
;

alter table ${idl_schema}.mcyy_bu_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_acct_sum values ('ACCT_SUM')
                                              )
;
alter table ${idl_schema}.mcyy_bu_detail modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_acct_sum values ('ACCT_SUM')
;

-- 1.3 create temp tables 
create table ${idl_schema}.tmp_mcyy_bu_detail_acct_sum as select * from ${idl_schema}.mcyy_bu_detail where 1=2 ;
--计算结构占比临时表
create table  ${idl_schema}.mcyy_bu_analysis_temp1_ratio compress 
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


create table ${idl_schema}.mcyy_bu_analysis_temp1 as select * from ${idl_schema}.mcyy_bu_analysis where 1=2 ;
create table ${idl_schema}.mcyy_bu_analysis_final1 as select * from ${idl_schema}.mcyy_bu_analysis where 1=2 ;

-- 2.1 基础指标数据处理
whenever sqlerror exit sql.sqlcode;
--2.1.1 第一组 对公结算账户数据
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--对公结算存量户数临时表

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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公结算存量户数数据
    tmp_corp_stl_open_data AS 
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,(CASE e.spectp
                          WHEN '4' THEN
                           'WD030111'
                          WHEN '6' THEN
                           'WD030112'
                          WHEN '7' THEN
                           'WD030113'
                          WHEN '5' THEN
                           'WD030114'
                      END) AS index_no
      
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
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND A.ACCTST='1')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_corp_stl_open_data t;
COMMIT;

--2.1.2 第二组 对公定期存款账户存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--对公定期存款账户存量户数临时表
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公定期存量户数数据
    tmp_corp_reg_open_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030115' AS index_no
      
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
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND A.ACCTST='1')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_corp_reg_open_data t;

COMMIT;

--2.1.3 第三组 对公保证金存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--对公保证金账户存量户数临时表
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公保证金存量户数数据
    tmp_corp_margin_open_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030116' AS index_no
      
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
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND A.ACCTST='1')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_corp_margin_open_data t;

COMMIT;

--2.1.4 第四组 个人结算I类存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--个人结算I类存量户数临时表
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
                   ,8) <= '${batch_date}'
      AND    t2.spectp = '1'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --个人结算I类存量户数数据
    tmp_indv_stl_open_first_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030209' AS index_no
      
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
      WHERE  a.accstp = '0'
      AND A.ACCTST='1')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_indv_stl_open_first_data t;


COMMIT;

--2.1.5 第五组 个人结算II/III类存量户数据
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT DISTINCT bill.external_account_id AS bu_no
                           ,bill.account_branch_id AS bu_org_no
                           ,to_char(bill.from_date
                                   ,'yyyymmdd') AS bu_dt
                           ,(CASE bill.account_category_level
                                WHEN 'SECOND-ACCT' THEN
                                 'WD030210'
                                WHEN 'THIRD-ACCT' THEN
                                 'WD030211'
                            END) AS index_no
            FROM   msl_iats_billing_account bill
            LEFT   JOIN msl_iats_bill_card_acc_assoc axx
            ON     axx.account_no = bill.external_account_id
            WHERE  bill.status_id NOT IN ('4','3')
            AND    bill.account_type IN
                   (SELECT billing_account_type_id
                     FROM   msl_iats_billing_account_type
                     WHERE  parent_type_id = 'PRIVATE_E')
            AND    (bill.account_category_level = 'SECOND-ACCT' OR
                  bill.account_category_level = 'THIRD-ACCT')
            AND    to_char(bill.from_date
                          ,'YYYYMMDD') <= '${batch_date}') t;
COMMIT;


--2.1.6 第六组 个人定期存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--个人定期存量户数临时表
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      AND    t2.spectp = '0'
      WHERE  t1.accstp = '0'
      AND    t1.subsac = '00001'
      AND    t1.crcycd = '01'),
    --个人定期存量户数(核心+电子)
    tmp_indv_reg_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030212' AS index_no
      
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
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
      AND A.ACCTST='1'
      
      UNION ALL
      
      SELECT DISTINCT bill.external_account_id AS bu_no
                     ,bill.account_branch_id AS bu_org_no
                     ,to_char(bill.from_date
                             ,'yyyymmdd') AS bu_dt
                     ,'WD030212' AS index_no
      FROM   msl_iats_billing_account bill
      LEFT   JOIN msl_iats_bill_card_acc_assoc axx
      ON     axx.account_no = bill.external_account_id
      WHERE  bill.status_id NOT IN ('4','3')
      AND    bill.account_type IN
             (SELECT billing_account_type_id
               FROM   msl_iats_billing_account_type
               WHERE  parent_type_id = 'PRIVATE_E')
      AND    bill.account_category_level = 'FIXED-ACCT'
      AND    to_char(bill.from_date
                    ,'YYYYMMDD') <= '${batch_date}'
      
      )
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_indv_reg_open_data t;


COMMIT;


--2.1.7 第七组 外汇结算存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--外汇结算存量户数临时表
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      AND    t2.spectp = 'F'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'),
    --外汇结算存量户数据
    tmp_fx_stl_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030304' AS index_no
      
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
     AND A.ACCTST='1'
      
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

--2.1.8 第八组 外汇定期、保证金存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--外汇定期、保证金存量户临时表
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      AND    t2.spectp = 'G'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd <> '01'),
    --外汇定期、保证金存量户数据
    tmp_fx_non_stl_open_data AS
     (SELECT DISTINCT a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,(CASE
                          WHEN e.debttp = 'P01' THEN
                           'WD030306'
                          ELSE
                           'WD030305'
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
      AND A.ACCTST='1'
      
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

--2.1.9 第九组 个人保证金存量户数
INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)
--对公保证金账户存量户数临时表
    WITH tmp_indv_margin_sum AS
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
                   ,8) <= '${batch_date}'
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
                   ,8) <= '${batch_date}'
      WHERE  t1.accstp = '0'
      AND    t1.crcycd = '01'),
    --对公保证金开户数数据
    tmp_indv_margin_sum_data AS
     (SELECT DISTINCT  a.acctno AS bu_no
                     ,a.brchno AS bu_org_no
                     ,a.opendt AS bu_dt
                     ,'WD030215' AS index_no
      
      FROM   msl_cbss_kna_acct a
      INNER  JOIN msl_cbss_knc_acid b
      ON     a.acctno = b.datavl
      INNER  JOIN msl_cbss_cifs_cfb_cust d
      ON     b.custno = d.custno
      AND    d.custtp  IN ('1'
                             ,'3'
                             ,'7')
      INNER  JOIN tmp_indv_margin_sum e
      ON     e.acctno = a.acctno
      WHERE  a.accstp = '0'
      AND    NOT EXISTS (SELECT 1
              FROM   msl_cbss_kna_acct_repl t
              WHERE  t.nwacno = a.acctno)
       AND A.ACCTST='1')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   tmp_indv_margin_sum_data t;

COMMIT;


-- 2.2 组合指标数据处理
whenever sqlerror exit sql.sqlcode;

--2.2.1 第一组 人民币对公结算账户存量户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030110' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
            WHERE  index_no IN ('WD030111'
                               ,'WD030112'
                               ,'WD030113'
                               ,'WD030114')
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.2 第二组 人民币对公账户存量户数(含保证金)

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030109' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
            WHERE  index_no IN ('WD030110'
                               ,'WD030115'
                               ,'WD030116'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.3 第三组 人民币个人结算账户存量户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030208' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
            WHERE  index_no IN ('WD030209'
                               ,'WD030210'
                               ,'WD030211'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.4 第四组 外汇账户存量户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030308' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
            WHERE  index_no IN ('WD030304'
                               ,'WD030305'
                               ,'WD030306'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;

--2.2.3 第五组 人民币个人账户存量户数

INSERT /*+ append */
INTO ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
    (etl_dt, bu_org_no, bu_no, bu_dt, index_no, etl_timestamp)

    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt
          ,t.bu_org_no
          ,t.bu_no
          ,t.bu_dt
          ,t.index_no
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp
    FROM   (SELECT bu_org_no, bu_no, bu_dt, 'WD030207' as index_no
            FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum
            WHERE  index_no IN ('WD030208'
                               ,'WD030212'
                               ,'WD030215'
                               )
            AND    etl_dt = to_date('${batch_date}'
                                   ,'yyyymmdd')) t;

COMMIT;


--3.1 对指标数据汇总处理

set serveroutput  on 
--根据存量户类指标循环遍历明细数据生成汇总数据

DECLARE
    CURSOR cur_acct_sum_index IS
        SELECT t.index_no,t.index_name_mcs
        FROM   ${idl_schema}.mcyy_index_define t
        WHERE  t.index_clsaa_s_mcs = '账户类业务'
        AND    t.index_name_mcs LIKE '%累计%'
        AND    T.DEPT_USE='内页';

BEGIN 
 FOR rec_acct_sum_index IN cur_acct_sum_index
 LOOP
  INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp1
                (etl_dt -- 数据日期
                ,etl_timestamp -- ETL处理时间戳
                ,index_no -- 指标编码
                ,index_name -- 指标名称
                ,org_no -- 机构编码
                ,org_name -- 机构名称
                ,super_org_no -- 上级机构编码
                ,index_value -- 指标值
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
                         END AS index_value
                        , --指标值
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
                              FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum t
                              WHERE  t.etl_dt =to_date('${batch_date}'
                                   ,'yyyymmdd')
                              AND    t.index_no = rec_acct_sum_index.index_no
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
                  ON     rec_acct_sum_index.index_no = t4.index_no_mcs),
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
                         -- 度量名称
                        
                        ,coalesce(t1.index_value
                                 ,0) - coalesce(t2.index_value
                                               ,0) AS rate_up_day --比上日   
                        ,CASE
                             WHEN coalesce(t2.index_value
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.index_value
                                             ,0) - coalesce(t2.index_value
                                                            ,0)) /
                                    coalesce(t2.index_value
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
                         coalesce(t1.index_value
                                 ,0) - coalesce(t2.index_value
                                               ,0) AS rate_last_month --比上月  
                        ,CASE
                             WHEN coalesce(t2.index_value
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.index_value
                                             ,0) - coalesce(t2.index_value
                                                            ,0)) /
                                    coalesce(t2.index_value
                                            ,0)
                                   ,6)
                         END AS rate_last_month_per --比上月百分比     
                  FROM   tmp_td_initza t1 -- 当日数据
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
                         coalesce(t1.index_value
                                 ,0) - coalesce(t2.index_value
                                               ,0) AS rate_last_quater --比上季 
                        ,CASE
                             WHEN coalesce(t2.index_value
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.index_value
                                             ,0) - coalesce(t2.index_value
                                                            ,0)) /
                                    coalesce(t2.index_value
                                            ,0)
                                   ,6)
                         END AS rate_last_quater_per --比上季百分比   
                  FROM   tmp_td_initza t1 -- 当日数据
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
                         coalesce(t1.index_value
                                 ,0) - coalesce(t2.index_value
                                               ,0) AS rate_last_year --比上年
                        ,CASE
                             WHEN coalesce(t2.index_value
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.index_value
                                             ,0) - coalesce(t2.index_value
                                                            ,0)) /
                                    coalesce(t2.index_value
                                            ,0)
                                   ,6)
                         END AS rate_last_year_per --比上年百分比   
                  FROM   tmp_td_initza t1 -- 当日数据
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
                         coalesce(t1.index_value
                                 ,0) - coalesce(t2.index_value
                                               ,0) AS rate_last_period --同比
                        ,CASE
                             WHEN coalesce(t2.index_value
                                          ,0) = 0 THEN
                              0
                             ELSE
                              round((coalesce(t1.index_value
                                             ,0) - coalesce(t2.index_value
                                                            ,0)) /
                                    coalesce(t2.index_value
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
                      ,SUM(mcyy_bu_analysis_tmp.index_value)   -- 指标值            
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
                      ,'ACCT_SUM' source_sys --来源系统
                      --,rec_acct_sum_index.index_name_mcs source_sys --来源系统
                FROM   (SELECT index_no
                              ,index_name
                              ,org_no
                              ,org_name
                              ,super_org_no
                              ,index_value        
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
                              ,NULL  index_value        

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
                                                     ,NULL  index_value        

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
                                                           ,NULL  index_value        

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
                                                           ,NULL  index_value        

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
                                                           ,NULL  index_value        

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
    dbms_output.put_line('营运存量户类指标汇总出错 ' || sqlerrm);


end;
/

-- 总体计算结构占比
  --分类型指标计算

  INSERT INTO ${idl_schema}.mcyy_bu_analysis_temp1_ratio
     SELECT f.index_no -- 指标编号  
           ,f.org_no -- 机构
           ,f.etl_dt -- 日期
           ,f.bu_type -- 渠道
           ,ratio_to_report(f.index_value) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 日占比
           ,ratio_to_report(f.index_value) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 月占比
           ,ratio_to_report(f.index_value) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 季占比
           ,ratio_to_report(f.index_value) over(PARTITION BY d.index_clsaa_t_mcs, f.org_no) -- 年占比
     FROM   mcyy_bu_analysis_temp1 f
     LEFT   JOIN mcyy_index_define d
     ON     d.index_no = f.index_no
     WHERE  d.index_clsaa_s_mcs = '账户类业务'
     AND    d.unit = '户'
     AND    d.index_state = '在用'
     AND    d.index_name_mcs LIKE '%累计%'
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
           d.index_clsaa_t_mcs = '外汇对公/个人账户汇总'OR
           d.index_clsaa_t_mcs = '人民币个人账户汇总'OR
           d.index_clsaa_t_mcs = '人民币对公账户汇总'
           )
     AND    f.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd');
 
 COMMIT;
 
 --将结构占比数据回插事实表

INSERT INTO ${idl_schema}.mcyy_bu_analysis_final1
    (etl_dt -- 数据日期
                ,etl_timestamp -- ETL处理时间戳
                ,index_no -- 指标编码
                ,index_name -- 指标名称
                ,org_no -- 机构编码
                ,org_name -- 机构名称
                ,super_org_no -- 上级机构编码
                ,index_value -- 指标值
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
     )
    SELECT t1.etl_dt -- 数据日期
                ,t1.etl_timestamp -- ETL处理时间戳
                ,t1.index_no -- 指标编码
                ,t1.index_name -- 指标名称
                ,t1.org_no -- 机构编码
                ,t1.org_name -- 机构名称
                ,t1.super_org_no -- 上级机构编码
                ,t1.index_value -- 指标值
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
    
    FROM   mcyy_bu_analysis_temp1 t1
    LEFT   JOIN mcyy_bu_analysis_temp1_ratio t2
    ON     t1.etl_dt = t2.etl_dt
    AND    t1.org_no = t2.org_no
    AND    t1.index_no = t2.index_no;
    
COMMIT;

--3.2 将临时表数据回插后删除临时表
--whenever sqlerror continue none;

INSERT INTO ${idl_schema}.mcyy_bu_detail(
    ETL_DT,
BU_ORG_NO,
BU_NO ,
BU_DT,
INDEX_NO ,
ETL_TIMESTAMP,
SOURCE_SYS
    )
    SELECT etl_dt
          ,bu_org_no
          ,bu_no
          ,bu_dt
          ,index_no
          ,etl_timestamp
          ,'ACCT_SUM' AS source_sys
    FROM   ${idl_schema}.tmp_mcyy_bu_detail_acct_sum;

commit;
drop table ${idl_schema}.tmp_mcyy_bu_detail_acct_sum purge;
ALTER TABLE ${idl_schema}.mcyy_bu_analysis exchange SUBPARTITION p_${batch_date}_acct_sum WITH TABLE ${idl_schema}.mcyy_bu_analysis_final1;

-- 4.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);



