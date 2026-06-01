/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_consmt_fund_tran_entr_h_nfssf1
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
alter table ${iml_schema}.evt_consmt_fund_tran_entr_h add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nfssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_consmt_fund_tran_entr_h partition for ('nfssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm purge;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op purge;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_consmt_fund_tran_entr_h partition for ('nfssf1')
where 0=1
;

create table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_consmt_fund_tran_entr_h partition for ('nfssf1') where 0=1;

create table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_consmt_fund_tran_entr_h partition for ('nfssf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tbhistransreq-
insert into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104025'||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 委托流水号
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.dateformat_min(P1.TRANS_DATE) -- 申请日期
    ,${iml_schema}.dateformat_min(P1.TRANS_DATE||LPAD(P1.TRANS_TIME,6,'0')) -- 申请时间
    ,${iml_schema}.dateformat_min(P1.OCCUR_INIT_DATE) -- 系统日期
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.TRANS_CODE -- 交易码
    ,P1.CONTROL_FLAG -- 控制标志
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易账户开户机构编号
    ,nvl(trim(P1.TA_CODE),'-') -- TA代码
    ,P1.DEBIT_ACCOUNT -- 购买账户编号
    ,' ' -- P1.CREBIT_ACCOUNT -- 赎回账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 交易客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,nvl(trim(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,nvl(trim(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END  -- 交易渠道编号
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.AUTH_OPER -- 授权柜员编号
    ,P1.PRD_CODE -- 理财产品编号
    ,nvl(trim(P1.PRD_TYPE),'9999') -- 产品类别代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 产品币种代码
    ,nvl(trim(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,${iml_schema}.dateformat_min(P1.ASSO_DATE) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.AMT -- 交易金额
    ,nvl(trim(P1.LIQU_STATUS),'-') -- 账务状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ORI_CHANNEL END -- 原交易渠道代码
    ,P1.ORI_BRANCH_NO -- 原交易机构编号
    ,P1.VOL -- 交易份额
    ,nvl(trim(P1.LARG_RED_FLAG),'-') -- 巨额赎回处理代码
    ,nvl(trim(P1.DIV_MODE),'-') -- 分红方式代码
    ,nvl(trim(P1.CONV_DIR),'-') -- 转换方向代码
    ,P1.TARG_PRD_CODE -- 目标理财产品编号
    ,P1.TARG_SELLER_CODE -- 对方销售商编号
    ,P1.TARG_ASSET_ACC -- 对方理财账户编号
    ,P1.TARG_BANK_ACC -- 目标银行账户编号
    ,P1.CLIENT_RISK -- 客户风险等级代码
    ,P1.PRODUCT_RISK -- 产品风险登记代码
    ,${iml_schema}.dateformat_min(P1.CFM_DATE) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.CFM_VOL -- 确认份额
    ,P1.TO_HOST_SERIAL -- 发送主机流水号
    ,${iml_schema}.dateformat_min(P1.HOST_CHECK_DATE) -- 主机对账日期
    ,${iml_schema}.dateformat_min(P1.ORI_HOST_CHK_DATE) -- 原交易主机对账日期
    ,nvl(trim(P1.HOST_TRANS_CODE),'-') -- 主机交易码
    ,${iml_schema}.dateformat_min(P1.HOST_DATE) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,CASE WHEN P1.MONITOR_FLAG='1' THEN '0'
     WHEN P1.MONITOR_FLAG='0' THEN '1'
     ELSE '-' END -- 监管正常标志
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.DEAL_MODE),'-') -- 受理方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbhistransreq' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbhistransreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBHISTRANSREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CHANNEL= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R3.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD' 
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURR_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBHISTRANSREQ'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ORI_CHANNEL= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R4.SRC_FIELD_EN_NAME= 'ORI_CHANNEL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INIT_TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- nfss_tbtransreq-
insert into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104025'||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 委托流水号
    ,P1.EX_SERIAL -- 发起方流水号
    ,P1.CONTRACT_NO -- 合约编号
    ,${iml_schema}.dateformat_min(P1.TRANS_DATE) -- 申请日期
    ,${iml_schema}.dateformat_min(P1.TRANS_DATE||LPAD(P1.TRANS_TIME,6,'0')) -- 申请时间
    ,${iml_schema}.dateformat_min(P1.OCCUR_INIT_DATE) -- 系统日期
    ,P1.SELLER_CODE -- 销售商编号
    ,P1.TRANS_CODE -- 交易码
    ,P1.CONTROL_FLAG -- 控制标志
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易账户开户机构编号
    ,nvl(trim(P1.TA_CODE),'-') -- TA代码
    ,P1.DEBIT_ACCOUNT -- 购买账户编号
    ,' ' -- P1.CREBIT_ACCOUNT -- 赎回账户编号
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 交易客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,nvl(trim(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,nvl(trim(P1.TRANS_ACCOUNT_TYPE),'-') -- 交易介质类型代码
    ,P1.TRANS_ACCOUNT -- 交易介质编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END  -- 交易渠道编号
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.AUTH_OPER -- 授权柜员编号
    ,P1.PRD_CODE -- 理财产品编号
    ,nvl(trim(P1.PRD_TYPE),'9999') -- 产品类别代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 产品币种代码
    ,nvl(trim(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,${iml_schema}.dateformat_min(P1.ASSO_DATE) -- 关联日期
    ,P1.ASSO_SERIAL -- 关联流水号
    ,P1.AMT -- 交易金额
    ,nvl(trim(P1.LIQU_STATUS),'-') -- 账务状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ORI_CHANNEL END -- 原交易渠道代码
    ,P1.ORI_BRANCH_NO -- 原交易机构编号
    ,P1.VOL -- 交易份额
    ,nvl(trim(P1.LARG_RED_FLAG),'-') -- 巨额赎回处理代码
    ,nvl(trim(P1.DIV_MODE),'-') -- 分红方式代码
    ,nvl(trim(P1.CONV_DIR),'-') -- 转换方向代码
    ,P1.TARG_PRD_CODE -- 目标理财产品编号
    ,P1.TARG_SELLER_CODE -- 对方销售商编号
    ,P1.TARG_ASSET_ACC -- 对方理财账户编号
    ,P1.TARG_BANK_ACC -- 目标银行账户编号
    ,P1.CLIENT_RISK -- 客户风险等级代码
    ,P1.PRODUCT_RISK -- 产品风险登记代码
    ,${iml_schema}.dateformat_min(P1.CFM_DATE) -- 确认日期
    ,P1.CFM_NO -- TA确认流水号
    ,P1.CFM_VOL -- 确认份额
    ,P1.TO_HOST_SERIAL -- 发送主机流水号
    ,${iml_schema}.dateformat_min(P1.HOST_CHECK_DATE) -- 主机对账日期
    ,${iml_schema}.dateformat_min(P1.ORI_HOST_CHK_DATE) -- 原交易主机对账日期
    ,nvl(trim(P1.HOST_TRANS_CODE),'-') -- 主机交易码
    ,${iml_schema}.dateformat_min(P1.HOST_DATE) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,nvl(trim(P1.MONITOR_FLAG),'-') -- 监管正常标志
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.DEAL_MODE),'-') -- 受理方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbtransreq' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tbtransreq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CHANNEL= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R3.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD' 
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURR_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ORI_CHANNEL= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBTRANSREQ'
        AND R4.SRC_FIELD_EN_NAME= 'ORI_CHANNEL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_CONSMT_FUND_TRAN_ENTR_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INIT_TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
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
        into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.entr_flow_num, o.entr_flow_num) as entr_flow_num -- 委托流水号
    ,nvl(n.intior_flow_num, o.intior_flow_num) as intior_flow_num -- 发起方流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合约编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.appl_tm, o.appl_tm) as appl_tm -- 申请时间
    ,nvl(n.sys_dt, o.sys_dt) as sys_dt -- 系统日期
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.ctrl_flg, o.ctrl_flg) as ctrl_flg -- 控制标志
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_open_acct_org_id, o.tran_open_acct_org_id) as tran_open_acct_org_id -- 交易账户开户机构编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.buy_acct_id, o.buy_acct_id) as buy_acct_id -- 购买账户编号
    ,nvl(n.redem_acct_id, o.redem_acct_id) as redem_acct_id -- 赎回账户编号
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 交易客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.tran_med_type_cd, o.tran_med_type_cd) as tran_med_type_cd -- 交易介质类型代码
    ,nvl(n.tran_med_id, o.tran_med_id) as tran_med_id -- 交易介质编号
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.prod_curr_cd, o.prod_curr_cd) as prod_curr_cd -- 产品币种代码
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.rela_dt, o.rela_dt) as rela_dt -- 关联日期
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账务状态代码
    ,nvl(n.init_tran_chn_cd, o.init_tran_chn_cd) as init_tran_chn_cd -- 原交易渠道代码
    ,nvl(n.init_tran_org_id, o.init_tran_org_id) as init_tran_org_id -- 原交易机构编号
    ,nvl(n.tran_lot, o.tran_lot) as tran_lot -- 交易份额
    ,nvl(n.huge_redem_proc_cd, o.huge_redem_proc_cd) as huge_redem_proc_cd -- 巨额赎回处理代码
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 转换方向代码
    ,nvl(n.target_finc_prod_id, o.target_finc_prod_id) as target_finc_prod_id -- 目标理财产品编号
    ,nvl(n.cntpty_seller_id, o.cntpty_seller_id) as cntpty_seller_id -- 对方销售商编号
    ,nvl(n.cntpty_finc_acct_id, o.cntpty_finc_acct_id) as cntpty_finc_acct_id -- 对方理财账户编号
    ,nvl(n.target_bank_acct_id, o.target_bank_acct_id) as target_bank_acct_id -- 目标银行账户编号
    ,nvl(n.cust_risk_level_cd, o.cust_risk_level_cd) as cust_risk_level_cd -- 客户风险等级代码
    ,nvl(n.prod_risk_rgst_cd, o.prod_risk_rgst_cd) as prod_risk_rgst_cd -- 产品风险登记代码
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.ta_cfm_flow_num, o.ta_cfm_flow_num) as ta_cfm_flow_num -- TA确认流水号
    ,nvl(n.cfm_lot, o.cfm_lot) as cfm_lot -- 确认份额
    ,nvl(n.send_host_flow_num, o.send_host_flow_num) as send_host_flow_num -- 发送主机流水号
    ,nvl(n.host_check_entry_dt, o.host_check_entry_dt) as host_check_entry_dt -- 主机对账日期
    ,nvl(n.init_tran_host_check_entry_dt, o.init_tran_host_check_entry_dt) as init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,nvl(n.host_tran_code, o.host_tran_code) as host_tran_code -- 主机交易码
    ,nvl(n.host_dt, o.host_dt) as host_dt -- 主机日期
    ,nvl(n.host_flow_num, o.host_flow_num) as host_flow_num -- 主机流水号
    ,nvl(n.supv_nomal_flg, o.supv_nomal_flg) as supv_nomal_flg -- 监管正常标志
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.accpt_way_cd, o.accpt_way_cd) as accpt_way_cd -- 受理方式代码
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm n
    full join (select * from ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.entr_flow_num <> n.entr_flow_num
        or o.intior_flow_num <> n.intior_flow_num
        or o.cont_id <> n.cont_id
        or o.appl_dt <> n.appl_dt
        or o.appl_tm <> n.appl_tm
        or o.sys_dt <> n.sys_dt
        or o.seller_id <> n.seller_id
        or o.tran_code <> n.tran_code
        or o.ctrl_flg <> n.ctrl_flg
        or o.tran_org_id <> n.tran_org_id
        or o.tran_open_acct_org_id <> n.tran_open_acct_org_id
        or o.ta_cd <> n.ta_cd
        or o.buy_acct_id <> n.buy_acct_id
        or o.redem_acct_id <> n.redem_acct_id
        or o.finc_acct_id <> n.finc_acct_id
        or o.finc_cust_id <> n.finc_cust_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.bank_id <> n.bank_id
        or o.cust_id <> n.cust_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.tran_med_type_cd <> n.tran_med_type_cd
        or o.tran_med_id <> n.tran_med_id
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.tran_teller_id <> n.tran_teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.finc_prod_id <> n.finc_prod_id
        or o.prod_cate_cd <> n.prod_cate_cd
        or o.prod_curr_cd <> n.prod_curr_cd
        or o.charge_way_cd <> n.charge_way_cd
        or o.rela_dt <> n.rela_dt
        or o.rela_flow_num <> n.rela_flow_num
        or o.tran_amt <> n.tran_amt
        or o.acct_status_cd <> n.acct_status_cd
        or o.init_tran_chn_cd <> n.init_tran_chn_cd
        or o.init_tran_org_id <> n.init_tran_org_id
        or o.tran_lot <> n.tran_lot
        or o.huge_redem_proc_cd <> n.huge_redem_proc_cd
        or o.divd_way_cd <> n.divd_way_cd
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.target_finc_prod_id <> n.target_finc_prod_id
        or o.cntpty_seller_id <> n.cntpty_seller_id
        or o.cntpty_finc_acct_id <> n.cntpty_finc_acct_id
        or o.target_bank_acct_id <> n.target_bank_acct_id
        or o.cust_risk_level_cd <> n.cust_risk_level_cd
        or o.prod_risk_rgst_cd <> n.prod_risk_rgst_cd
        or o.cfm_dt <> n.cfm_dt
        or o.ta_cfm_flow_num <> n.ta_cfm_flow_num
        or o.cfm_lot <> n.cfm_lot
        or o.send_host_flow_num <> n.send_host_flow_num
        or o.host_check_entry_dt <> n.host_check_entry_dt
        or o.init_tran_host_check_entry_dt <> n.init_tran_host_check_entry_dt
        or o.host_tran_code <> n.host_tran_code
        or o.host_dt <> n.host_dt
        or o.host_flow_num <> n.host_flow_num
        or o.supv_nomal_flg <> n.supv_nomal_flg
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.return_code <> n.return_code
        or o.return_info <> n.return_info
        or o.tran_status_cd <> n.tran_status_cd
        or o.accpt_way_cd <> n.accpt_way_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entr_flow_num -- 委托流水号
    ,intior_flow_num -- 发起方流水号
    ,cont_id -- 合约编号
    ,appl_dt -- 申请日期
    ,appl_tm -- 申请时间
    ,sys_dt -- 系统日期
    ,seller_id -- 销售商编号
    ,tran_code -- 交易码
    ,ctrl_flg -- 控制标志
    ,tran_org_id -- 交易机构编号
    ,tran_open_acct_org_id -- 交易账户开户机构编号
    ,ta_cd -- TA代码
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,finc_acct_id -- 理财账户编号
    ,finc_cust_id -- 理财客户编号
    ,cust_type_cd -- 客户类型代码
    ,bank_id -- 银行编号
    ,cust_id -- 交易客户编号
    ,bank_acct_id -- 银行账户编号
    ,ec_idf_cd -- 钞汇标识代码
    ,tran_med_type_cd -- 交易介质类型代码
    ,tran_med_id -- 交易介质编号
    ,tran_chn_cd -- 交易渠道编号
    ,tran_teller_id -- 交易柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,finc_prod_id -- 理财产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_curr_cd -- 产品币种代码
    ,charge_way_cd -- 收费方式代码
    ,rela_dt -- 关联日期
    ,rela_flow_num -- 关联流水号
    ,tran_amt -- 交易金额
    ,acct_status_cd -- 账务状态代码
    ,init_tran_chn_cd -- 原交易渠道代码
    ,init_tran_org_id -- 原交易机构编号
    ,tran_lot -- 交易份额
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,divd_way_cd -- 分红方式代码
    ,tran_dir_cd -- 转换方向代码
    ,target_finc_prod_id -- 目标理财产品编号
    ,cntpty_seller_id -- 对方销售商编号
    ,cntpty_finc_acct_id -- 对方理财账户编号
    ,target_bank_acct_id -- 目标银行账户编号
    ,cust_risk_level_cd -- 客户风险等级代码
    ,prod_risk_rgst_cd -- 产品风险登记代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_lot -- 确认份额
    ,send_host_flow_num -- 发送主机流水号
    ,host_check_entry_dt -- 主机对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,supv_nomal_flg -- 监管正常标志
    ,cust_mgr_id -- 客户经理编号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,tran_status_cd -- 交易状态代码
    ,accpt_way_cd -- 受理方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.entr_flow_num -- 委托流水号
    ,o.intior_flow_num -- 发起方流水号
    ,o.cont_id -- 合约编号
    ,o.appl_dt -- 申请日期
    ,o.appl_tm -- 申请时间
    ,o.sys_dt -- 系统日期
    ,o.seller_id -- 销售商编号
    ,o.tran_code -- 交易码
    ,o.ctrl_flg -- 控制标志
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_open_acct_org_id -- 交易账户开户机构编号
    ,o.ta_cd -- TA代码
    ,o.buy_acct_id -- 购买账户编号
    ,o.redem_acct_id -- 赎回账户编号
    ,o.finc_acct_id -- 理财账户编号
    ,o.finc_cust_id -- 理财客户编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.bank_id -- 银行编号
    ,o.cust_id -- 交易客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.tran_med_type_cd -- 交易介质类型代码
    ,o.tran_med_id -- 交易介质编号
    ,o.tran_chn_cd -- 交易渠道编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.finc_prod_id -- 理财产品编号
    ,o.prod_cate_cd -- 产品类别代码
    ,o.prod_curr_cd -- 产品币种代码
    ,o.charge_way_cd -- 收费方式代码
    ,o.rela_dt -- 关联日期
    ,o.rela_flow_num -- 关联流水号
    ,o.tran_amt -- 交易金额
    ,o.acct_status_cd -- 账务状态代码
    ,o.init_tran_chn_cd -- 原交易渠道代码
    ,o.init_tran_org_id -- 原交易机构编号
    ,o.tran_lot -- 交易份额
    ,o.huge_redem_proc_cd -- 巨额赎回处理代码
    ,o.divd_way_cd -- 分红方式代码
    ,o.tran_dir_cd -- 转换方向代码
    ,o.target_finc_prod_id -- 目标理财产品编号
    ,o.cntpty_seller_id -- 对方销售商编号
    ,o.cntpty_finc_acct_id -- 对方理财账户编号
    ,o.target_bank_acct_id -- 目标银行账户编号
    ,o.cust_risk_level_cd -- 客户风险等级代码
    ,o.prod_risk_rgst_cd -- 产品风险登记代码
    ,o.cfm_dt -- 确认日期
    ,o.ta_cfm_flow_num -- TA确认流水号
    ,o.cfm_lot -- 确认份额
    ,o.send_host_flow_num -- 发送主机流水号
    ,o.host_check_entry_dt -- 主机对账日期
    ,o.init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,o.host_tran_code -- 主机交易码
    ,o.host_dt -- 主机日期
    ,o.host_flow_num -- 主机流水号
    ,o.supv_nomal_flg -- 监管正常标志
    ,o.cust_mgr_id -- 客户经理编号
    ,o.return_code -- 返回码
    ,o.return_info -- 返回信息
    ,o.tran_status_cd -- 交易状态代码
    ,o.accpt_way_cd -- 受理方式代码
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
from ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_bk o
    left join ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_consmt_fund_tran_entr_h;
--alter table ${iml_schema}.evt_consmt_fund_tran_entr_h truncate partition for ('nfssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_consmt_fund_tran_entr_h') 
               and substr(subpartition_name,1,8)=upper('p_nfssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_consmt_fund_tran_entr_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_consmt_fund_tran_entr_h modify partition p_nfssf1 
add subpartition p_nfssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_consmt_fund_tran_entr_h exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl;
alter table ${iml_schema}.evt_consmt_fund_tran_entr_h exchange subpartition p_nfssf1_20991231 with table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_consmt_fund_tran_entr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_tm purge;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_op purge;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_consmt_fund_tran_entr_h_nfssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_consmt_fund_tran_entr_h', partname => 'p_nfssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
