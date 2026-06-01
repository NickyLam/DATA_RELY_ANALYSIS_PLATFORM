/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_lot_dtl_h_ifmsf1
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
alter table ${iml_schema}.agt_finc_lot_dtl_h add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_lot_dtl_h partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_lot_dtl_h partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_lot_dtl_h partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_lot_dtl_h partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbsharedetail1-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,P1.ORI_CFM_AMT -- 原确认金额
    ,P1.ORI_CFM_VOL -- 原确认份额
    ,P1.ORI_NAV -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 周期性理财到期日期
    ,'0' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail1' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail1 p1
    left join ${iol_schema}.ifms_tbsharedetail0 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL1'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL1'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL1'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.in_client_no is null 
;
commit;

-- ifms_tbsharedetail2-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,P1.ORI_CFM_AMT -- 原确认金额
    ,P1.ORI_CFM_VOL -- 原确认份额
    ,P1.ORI_NAV -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 周期性理财到期日期
    ,'0' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail2' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail2 p1
    left join ${iol_schema}.ifms_tbsharedetail0 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL2'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL2'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL2'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD' 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.in_client_no is null 
;
commit;

-- ifms_tbsharedetail3-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,P1.ORI_CFM_AMT -- 原确认金额
    ,P1.ORI_CFM_VOL -- 原确认份额
    ,P1.ORI_NAV -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 周期性理财到期日期
    ,'0' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail3' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail3 p1
    left join ${iol_schema}.ifms_tbsharedetail0 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL3'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL3'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL3'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.in_client_no is null 
;
commit;

-- ifms_tbsharedetail4-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,P1.ORI_CFM_AMT -- 原确认金额
    ,P1.ORI_CFM_VOL -- 原确认份额
    ,P1.ORI_NAV -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 周期性理财到期日期
    ,'0' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail4' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail4 p1
    left join ${iol_schema}.ifms_tbsharedetail0 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL4'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL4'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL4'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.in_client_no is null 
;
commit;

-- ifms_tbsharedetail5-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,P1.ORI_CFM_AMT -- 原确认金额
    ,P1.ORI_CFM_VOL -- 原确认份额
    ,P1.ORI_NAV -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(null) -- 周期性理财到期日期
    ,'0' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail5' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail5 p1
    left join ${iol_schema}.ifms_tbsharedetail0 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.in_client_no is null 
;
commit;

-- ifms_tbsharedetail0-
insert into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.CFM_NO -- TA确认流水号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CASH_FLAG END -- 钞汇标识代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.SERIAL_NO -- 申请流水号
    ,${iml_schema}.DATEFORMAT_min(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,p1.source_flag -- 份额来源代码
    ,P1.TOT_VOL -- 份额总数
    ,NVL(TRIM(P1.DIV_MODE),'-') -- 分红方式代码
    ,NVL(TRIM(P1.OLD_DIV_MODE),'-') -- 原分红方式代码
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.INCOME_ONWAY -- 未付收益
    ,P1.INCOME_FROZEN -- 冻结未付收益
    ,P1.INCOME_NEW -- 新分配收益
    ,CASE WHEN T1.ORI_CFM_AMT>0 THEN T1.ORI_CFM_AMT
     WHEN T2.ORI_CFM_AMT>0 THEN T2.ORI_CFM_AMT
     WHEN T3.ORI_CFM_AMT>0 THEN T3.ORI_CFM_AMT
     WHEN T4.ORI_CFM_AMT>0 THEN T4.ORI_CFM_AMT
     WHEN T5.ORI_CFM_AMT>0 THEN T5.ORI_CFM_AMT
     ELSE P1.ORI_CFM_AMT
END  -- 原确认金额
    ,CASE WHEN T1.ORI_CFM_VOL>0 THEN T1.ORI_CFM_VOL
     WHEN T2.ORI_CFM_VOL>0 THEN T2.ORI_CFM_VOL
     WHEN T3.ORI_CFM_VOL>0 THEN T3.ORI_CFM_VOL
     WHEN T4.ORI_CFM_VOL>0 THEN T4.ORI_CFM_VOL
     WHEN T5.ORI_CFM_VOL>0 THEN T5.ORI_CFM_VOL
     ELSE P1.ORI_CFM_VOL
END  -- 原确认份额
    ,CASE WHEN T1.ORI_NAV>0 THEN T1.ORI_NAV
     WHEN T2.ORI_NAV>0 THEN T2.ORI_NAV
     WHEN T3.ORI_NAV>0 THEN T3.ORI_NAV
     WHEN T4.ORI_NAV>0 THEN T4.ORI_NAV
     WHEN T5.ORI_NAV>0 THEN T5.ORI_NAV
     ELSE P1.ORI_NAV
END  -- 原单位净值
    ,p1.ori_source_flag -- 原份额来源代码
    ,nvl(trim(p1.CHANNEL),'-') -- 交易渠道代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.client_group END -- 客户分组代码
    ,P1.BANK_ACC -- 银行账户编号
    ,P1.TRANS_ACCOUNT_TYPE -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,P1.CONTRACT_NO -- 合约编号
    ,P1.COST -- 买入成本
    ,${iml_schema}.DATEFORMAT_MAX(to_char(END_DATE)) -- 周期性理财到期日期
    ,'1' -- 周期性理财标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbsharedetail0' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbsharedetail0 p1
    left join ${iol_schema}.ifms_tbsharedetail1 t1 on p1.in_CLIENT_NO=t1.IN_CLIENT_NO 
and p1.SELLER_CODE = t1.SELLER_CODE
and p1.cfm_no = t1.cfm_no
and  t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsharedetail2 t2 on p1.in_CLIENT_NO=t2.IN_CLIENT_NO 
and p1.SELLER_CODE = t2.SELLER_CODE
and p1.cfm_no = t2.cfm_no
and  t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsharedetail3 t3 on p1.in_CLIENT_NO=t3.IN_CLIENT_NO 
and p1.SELLER_CODE = t3.SELLER_CODE
and p1.cfm_no = t3.cfm_no
and  t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsharedetail4 t4 on p1.in_CLIENT_NO=t4.IN_CLIENT_NO 
and p1.SELLER_CODE = t4.SELLER_CODE
and p1.cfm_no = t4.cfm_no
and  t4.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbsharedetail5 t5 on p1.in_CLIENT_NO=t5.IN_CLIENT_NO 
and p1.SELLER_CODE = t5.SELLER_CODE
and p1.cfm_no = t5.cfm_no
and  t5.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t5.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CASH_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R1.SRC_FIELD_EN_NAME= 'CASH_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CLIENT_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFMS'
        AND R3.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R3.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLIENT_GROUP = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_TBSHAREDETAIL5'
        AND R5.SRC_FIELD_EN_NAME= 'CLIENT_GROUP'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FINC_LOT_DTL_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CUST_GROUPING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,seller_id
  	                                        ,prod_id
  	                                        ,ta_cfm_flow_num
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.ta_cfm_flow_num, o.ta_cfm_flow_num) as ta_cfm_flow_num -- TA确认流水号
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.lot_src_cd, o.lot_src_cd) as lot_src_cd -- 份额来源代码
    ,nvl(n.lot_tot, o.lot_tot) as lot_tot -- 份额总数
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.init_divd_way_cd, o.init_divd_way_cd) as init_divd_way_cd -- 原分红方式代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.froz_unpaid_prft, o.froz_unpaid_prft) as froz_unpaid_prft -- 冻结未付收益
    ,nvl(n.new_assign_prft, o.new_assign_prft) as new_assign_prft -- 新分配收益
    ,nvl(n.init_cfm_amt, o.init_cfm_amt) as init_cfm_amt -- 原确认金额
    ,nvl(n.init_cfm_lot, o.init_cfm_lot) as init_cfm_lot -- 原确认份额
    ,nvl(n.init_corp_nv, o.init_corp_nv) as init_corp_nv -- 原单位净值
    ,nvl(n.init_lot_src_cd, o.init_lot_src_cd) as init_lot_src_cd -- 原份额来源代码
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.cust_grouping_cd, o.cust_grouping_cd) as cust_grouping_cd -- 客户分组代码
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.tran_med_type_cd, o.tran_med_type_cd) as tran_med_type_cd -- 交易介质类型代码
    ,nvl(n.tran_med_id, o.tran_med_id) as tran_med_id -- 交易介质编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合约编号
    ,nvl(n.buy_cost, o.buy_cost) as buy_cost -- 买入成本
    ,nvl(n.ped_finc_exp_dt, o.ped_finc_exp_dt) as ped_finc_exp_dt -- 周期性理财到期日期
    ,nvl(n.ped_finc_flg, o.ped_finc_flg) as ped_finc_flg -- 周期性理财标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.prod_id is null
            and n.ta_cfm_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.prod_id is null
            and n.ta_cfm_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.seller_id is null
            and n.prod_id is null
            and n.ta_cfm_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm n
    full join (select * from ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.prod_id = n.prod_id
            and o.ta_cfm_flow_num = n.ta_cfm_flow_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.seller_id is null
        and o.prod_id is null
        and o.ta_cfm_flow_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.seller_id is null
        and n.prod_id is null
        and n.ta_cfm_flow_num is null
    )
    or (
        o.finc_cust_id <> n.finc_cust_id
        or o.cust_id <> n.cust_id
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.ta_cd <> n.ta_cd
        or o.finc_acct_id <> n.finc_acct_id
        or o.appl_flow_num <> n.appl_flow_num
        or o.cfm_dt <> n.cfm_dt
        or o.lot_src_cd <> n.lot_src_cd
        or o.lot_tot <> n.lot_tot
        or o.divd_way_cd <> n.divd_way_cd
        or o.init_divd_way_cd <> n.init_divd_way_cd
        or o.belong_org_id <> n.belong_org_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.unpaid_prft <> n.unpaid_prft
        or o.froz_unpaid_prft <> n.froz_unpaid_prft
        or o.new_assign_prft <> n.new_assign_prft
        or o.init_cfm_amt <> n.init_cfm_amt
        or o.init_cfm_lot <> n.init_cfm_lot
        or o.init_corp_nv <> n.init_corp_nv
        or o.init_lot_src_cd <> n.init_lot_src_cd
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.cust_grouping_cd <> n.cust_grouping_cd
        or o.bank_acct_id <> n.bank_acct_id
        or o.tran_med_type_cd <> n.tran_med_type_cd
        or o.tran_med_id <> n.tran_med_id
        or o.cont_id <> n.cont_id
        or o.buy_cost <> n.buy_cost
        or o.ped_finc_exp_dt <> n.ped_finc_exp_dt
        or o.ped_finc_flg <> n.ped_finc_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,seller_id -- 销售商编号
    ,prod_id -- 产品编号
    ,ta_cfm_flow_num -- TA确认流水号
    ,finc_cust_id -- 理财客户编号
    ,cust_id -- 客户编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,appl_flow_num -- 申请流水号
    ,cfm_dt -- 确认日期
    ,lot_src_cd -- 份额来源代码
    ,lot_tot -- 份额总数
    ,divd_way_cd -- 分红方式代码
    ,init_divd_way_cd -- 原分红方式代码
    ,belong_org_id -- 所属机构编号
    ,cust_type_cd -- 客户类型代码
    ,unpaid_prft -- 未付收益
    ,froz_unpaid_prft -- 冻结未付收益
    ,new_assign_prft -- 新分配收益
    ,init_cfm_amt -- 原确认金额
    ,init_cfm_lot -- 原确认份额
    ,init_corp_nv -- 原单位净值
    ,init_lot_src_cd -- 原份额来源代码
    ,tran_chn_cd -- 交易渠道代码
    ,cust_grouping_cd -- 客户分组代码
    ,bank_acct_id -- 银行账户编号
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,cont_id -- 合约编号
    ,buy_cost -- 买入成本
    ,ped_finc_exp_dt -- 周期性理财到期日期
    ,ped_finc_flg -- 周期性理财标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.seller_id -- 销售商编号
    ,o.prod_id -- 产品编号
    ,o.ta_cfm_flow_num -- TA确认流水号
    ,o.finc_cust_id -- 理财客户编号
    ,o.cust_id -- 客户编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.ta_cd -- TA代码
    ,o.finc_acct_id -- 理财账户编号
    ,o.appl_flow_num -- 申请流水号
    ,o.cfm_dt -- 确认日期
    ,o.lot_src_cd -- 份额来源代码
    ,o.lot_tot -- 份额总数
    ,o.divd_way_cd -- 分红方式代码
    ,o.init_divd_way_cd -- 原分红方式代码
    ,o.belong_org_id -- 所属机构编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.unpaid_prft -- 未付收益
    ,o.froz_unpaid_prft -- 冻结未付收益
    ,o.new_assign_prft -- 新分配收益
    ,o.init_cfm_amt -- 原确认金额
    ,o.init_cfm_lot -- 原确认份额
    ,o.init_corp_nv -- 原单位净值
    ,o.init_lot_src_cd -- 原份额来源代码
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.cust_grouping_cd -- 客户分组代码
    ,o.bank_acct_id -- 银行账户编号
    ,o.tran_med_type_cd -- 交易介质类型代码
    ,o.tran_med_id -- 交易介质编号
    ,o.cont_id -- 合约编号
    ,o.buy_cost -- 买入成本
    ,o.ped_finc_exp_dt -- 周期性理财到期日期
    ,o.ped_finc_flg -- 周期性理财标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_bk o
    left join ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.seller_id = n.seller_id
            and o.prod_id = n.prod_id
            and o.ta_cfm_flow_num = n.ta_cfm_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.seller_id = d.seller_id
            and o.prod_id = d.prod_id
            and o.ta_cfm_flow_num = d.ta_cfm_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_finc_lot_dtl_h;
--alter table ${iml_schema}.agt_finc_lot_dtl_h truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_finc_lot_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_finc_lot_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_finc_lot_dtl_h modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_finc_lot_dtl_h exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl;
alter table ${iml_schema}.agt_finc_lot_dtl_h exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_lot_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_lot_dtl_h_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_lot_dtl_h', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
