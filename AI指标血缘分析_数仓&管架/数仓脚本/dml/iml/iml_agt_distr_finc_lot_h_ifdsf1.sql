/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_distr_finc_lot_h_ifdsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_distr_finc_lot_h add partition p_ifdsf1 values ('ifdsf1')(
        subpartition p_ifdsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ifdsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_distr_finc_lot_h partition for ('ifdsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm purge;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op purge;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm nologging
compress ${option_switch} for query high
as select
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_distr_finc_lot_h partition for ('ifdsf1')
where 0=1
;

create table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_distr_finc_lot_h partition for ('ifdsf1') where 0=1;

create table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_distr_finc_lot_h partition for ('ifdsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_fds_tbshare1-1
insert into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm(
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 理财客户编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,'160012'||P1.IN_CLIENT_NO||P1.BANK_NO||P1.TA_CODE -- 协议编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户分组代码
    ,P1.APPEND_FLAG -- 追加投资标志
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益率
    ,P1.COST -- 买入成本金额
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.DIV_RATE -- 分红比例
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbshare1' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbshare1 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TA_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE1'
        AND R1.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DIV_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE1'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE1'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifms_fds_tbshare2-1
insert into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm(
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 理财客户编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,'160012'||P1.IN_CLIENT_NO||P1.BANK_NO||P1.TA_CODE -- 协议编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户分组代码
    ,P1.APPEND_FLAG -- 追加投资标志
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益率
    ,P1.COST -- 买入成本金额
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.DIV_RATE -- 分红比例
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbshare2' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbshare2 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TA_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE2'
        AND R1.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DIV_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE2'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE2'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifms_fds_tbshare3-1
insert into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm(
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 理财客户编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,'160012'||P1.IN_CLIENT_NO||P1.BANK_NO||P1.TA_CODE -- 协议编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户分组代码
    ,P1.APPEND_FLAG -- 追加投资标志
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益率
    ,P1.COST -- 买入成本金额
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.DIV_RATE -- 分红比例
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbshare3' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbshare3 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TA_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE3'
        AND R1.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DIV_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE3'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE3'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifms_fds_tbshare4-1
insert into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm(
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 理财客户编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,'160012'||P1.IN_CLIENT_NO||P1.BANK_NO||P1.TA_CODE -- 协议编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户分组代码
    ,P1.APPEND_FLAG -- 追加投资标志
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益率
    ,P1.COST -- 买入成本金额
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.DIV_RATE -- 分红比例
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbshare4' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbshare4 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TA_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE4'
        AND R1.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DIV_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE4'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE4'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifms_fds_tbshare5-1
insert into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm(
    finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.IN_CLIENT_NO -- 理财客户编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.BANK_NO -- 银行编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.PRD_CODE -- 源产品编号
    ,'160012'||P1.IN_CLIENT_NO||P1.BANK_NO||P1.TA_CODE -- 协议编号
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 分红方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户分组代码
    ,P1.APPEND_FLAG -- 追加投资标志
    ,P1.TOT_VOL -- 份额总数
    ,P1.INCOME -- 本期收益
    ,P1.INCOME_RATE -- 收益率
    ,P1.COST -- 买入成本金额
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.DIV_RATE -- 分红比例
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbshare5' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbshare5 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TA_CODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE5'
        AND R1.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DIV_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE5'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_FDS_TBSHARE5'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_DISTR_FINC_LOT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl(
            finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op(
            finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.src_prod_id, o.src_prod_id) as src_prod_id -- 源产品编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.cust_grouping_cd, o.cust_grouping_cd) as cust_grouping_cd -- 客户分组代码
    ,nvl(n.supp_invest_flg, o.supp_invest_flg) as supp_invest_flg -- 追加投资标志
    ,nvl(n.lot_tot, o.lot_tot) as lot_tot -- 份额总数
    ,nvl(n.curr_issue_prft, o.curr_issue_prft) as curr_issue_prft -- 本期收益
    ,nvl(n.yld_rat, o.yld_rat) as yld_rat -- 收益率
    ,nvl(n.buy_cost_amt, o.buy_cost_amt) as buy_cost_amt -- 买入成本金额
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.divd_ratio, o.divd_ratio) as divd_ratio -- 分红比例
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,case when
            n.finc_cust_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.ta_tran_acct_id is null
            and n.src_prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finc_cust_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.ta_tran_acct_id is null
            and n.src_prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finc_cust_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.bank_id is null
            and n.ta_tran_acct_id is null
            and n.src_prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm n
    full join (select * from ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.finc_cust_id = n.finc_cust_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.bank_id = n.bank_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.src_prod_id = n.src_prod_id
where (
        o.finc_cust_id is null
        and o.lp_id is null
        and o.seller_id is null
        and o.bank_id is null
        and o.ta_tran_acct_id is null
        and o.src_prod_id is null
    )
    or (
        n.finc_cust_id is null
        and n.lp_id is null
        and n.seller_id is null
        and n.bank_id is null
        and n.ta_tran_acct_id is null
        and n.src_prod_id is null
    )
    or (
        o.agt_id <> n.agt_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.finc_acct_id <> n.finc_acct_id
        or o.belong_org_id <> n.belong_org_id
        or o.ta_cd <> n.ta_cd
        or o.divd_way_cd <> n.divd_way_cd
        or o.cust_grouping_cd <> n.cust_grouping_cd
        or o.supp_invest_flg <> n.supp_invest_flg
        or o.lot_tot <> n.lot_tot
        or o.curr_issue_prft <> n.curr_issue_prft
        or o.yld_rat <> n.yld_rat
        or o.buy_cost_amt <> n.buy_cost_amt
        or o.unpaid_prft <> n.unpaid_prft
        or o.divd_ratio <> n.divd_ratio
        or o.finc_prod_id <> n.finc_prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl(
            finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op(
            finc_cust_id -- 理财客户编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,bank_id -- 银行编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,src_prod_id -- 源产品编号
    ,agt_id -- 协议编号
    ,bank_acct_id -- 银行账户编号
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_cd -- TA代码
    ,divd_way_cd -- 分红方式代码
    ,cust_grouping_cd -- 客户分组代码
    ,supp_invest_flg -- 追加投资标志
    ,lot_tot -- 份额总数
    ,curr_issue_prft -- 本期收益
    ,yld_rat -- 收益率
    ,buy_cost_amt -- 买入成本金额
    ,unpaid_prft -- 未付收益
    ,divd_ratio -- 分红比例
    ,finc_prod_id -- 理财产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finc_cust_id -- 理财客户编号
    ,o.lp_id -- 法人编号
    ,o.seller_id -- 销售商编号
    ,o.bank_id -- 银行编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.src_prod_id -- 源产品编号
    ,o.agt_id -- 协议编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.finc_acct_id -- 理财账户编号
    ,o.belong_org_id -- 所属机构编号
    ,o.ta_cd -- TA代码
    ,o.divd_way_cd -- 分红方式代码
    ,o.cust_grouping_cd -- 客户分组代码
    ,o.supp_invest_flg -- 追加投资标志
    ,o.lot_tot -- 份额总数
    ,o.curr_issue_prft -- 本期收益
    ,o.yld_rat -- 收益率
    ,o.buy_cost_amt -- 买入成本金额
    ,o.unpaid_prft -- 未付收益
    ,o.divd_ratio -- 分红比例
    ,o.finc_prod_id -- 理财产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_bk o
    left join ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op n
        on
            o.finc_cust_id = n.finc_cust_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.bank_id = n.bank_id
            and o.ta_tran_acct_id = n.ta_tran_acct_id
            and o.src_prod_id = n.src_prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl d
        on
            o.finc_cust_id = d.finc_cust_id
            and o.lp_id = d.lp_id
            and o.seller_id = d.seller_id
            and o.bank_id = d.bank_id
            and o.ta_tran_acct_id = d.ta_tran_acct_id
            and o.src_prod_id = d.src_prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_distr_finc_lot_h;
alter table ${iml_schema}.agt_distr_finc_lot_h truncate partition for ('ifdsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_distr_finc_lot_h exchange subpartition p_ifdsf1_19000101 with table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl;
alter table ${iml_schema}.agt_distr_finc_lot_h exchange subpartition p_ifdsf1_20991231 with table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_distr_finc_lot_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_tm purge;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_op purge;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_distr_finc_lot_h_ifdsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_distr_finc_lot_h', partname => 'p_ifdsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
