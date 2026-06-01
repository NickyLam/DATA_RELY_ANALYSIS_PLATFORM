/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_qxb_tran_entr_h_fsmsf1
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
alter table ${iml_schema}.evt_qxb_tran_entr_h add partition p_fsmsf1 values ('fsmsf1')(
        subpartition p_fsmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fsmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_entr_h partition for ('fsmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm purge;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op purge;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_entr_h partition for ('fsmsf1')
where 0=1
;

create table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_entr_h partition for ('fsmsf1') where 0=1;

create table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_entr_h partition for ('fsmsf1') where 0=1;

-- 3.1 get new data into table
-- fsms_yeb_app_trans-
insert into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102061'||P1.APP_SNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.APP_SNO -- 申请单编号
    ,P1.DISTRIBUTORCODE -- 销售商编号
    ,P1.PARTNER -- 商户编号
    ,P1.TANO -- TA代码
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.FUNDCODE -- 产品编号
    ,P1.BUSINESSCODE -- 业务代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SHARETYPE END -- 收费方式代码
    ,P1.CUST_NO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUST_TYPE END -- 客户类型代码
    ,P1.TAACCOUNTID -- 基金账户编号
    ,P1.TRANSACTIONACCOUNTID -- 交易账户编号
    ,NVL(TRIM(P1.DEFDIVIDENDMETHOD),'-') -- 分红方式代码
    ,P1.ACCT_NO -- 账户编号
    ,P1.DEPOSIT_ACCT -- 银行卡号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,P1.APPLICATIONVOL -- 申请份额
    ,P1.APPLICATIONAMOUNT -- 申请金额
    ,P1.CONFIRMEDVOL -- 交易确认份额
    ,P1.CONFIRMEDAMOUNT -- 交易确认金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONCFMDATE) -- 交易确认日期
    ,P1.ORG_APP_SNO -- 原申请单编号
    ,P1.ORG_APP_VOL -- 原申请份额
    ,P1.PROTOCOLNO -- 基金代销协议编号
    ,P1.LARGEREDEMPTIONFLAG -- 巨额赎回处理代码
    ,P1.CHARGE -- 手续费
    ,P1.TARGETTAACCOUNTID -- 对方基金账户编号
    ,P1.TARGETDISTRIBUTORCODE -- 对方销售商代码
    ,P1.TARGETTRANSACTIONACCOUNTID -- 对方交易账户编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.TARGETSHARETYPE END -- 对方收费方式代码
    ,P1.FM_MANAGER -- 理财客户经理编号
    ,P1.AGENT_NAME -- 经办人姓名
    ,NVL(TRIM(P1.LAST_STATUS),'-') -- 上次申请状态代码
    ,NVL(TRIM(P1.STATUS),'-') -- 申请状态代码
    ,NVL(TRIM(P1.RISKMATCHING),'-') -- 风险等级匹配标志
    ,NVL(TRIM(P1.ORDERFLAG),'-') -- 下单方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCEPTMETHOD END -- 受理方式代码
    ,P1.OPERID -- 操作柜员编号
    ,P1.RETURNMSG -- 返回信息
    ,P1.OPERORGCENTER -- 交易分行编号
    ,P1.OPERORG -- 交易网点编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE||LPAD(P1.TRANSACTIONTIME,6,'0')) -- 交易时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE) -- 新增日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE||LPAD(P1.NEWTIME,6,'0')） -- 新增时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_app_trans' -- 源表名称
    ,'fsmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_app_trans p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SHARETYPE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FSMS'
        AND R4.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R4.SRC_FIELD_EN_NAME= 'SHARETYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUST_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R1.SRC_FIELD_EN_NAME= 'CUST_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCYTYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.TARGETSHARETYPE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FSMS'
        AND R5.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R5.SRC_FIELD_EN_NAME= 'TARGETSHARETYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCEPTMETHOD= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FSMS'
        AND R3.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R3.SRC_FIELD_EN_NAME= 'ACCEPTMETHOD'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- fsms_yeb_app_trans_his-
insert into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102061'||P1.APP_SNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.APP_SNO -- 申请单编号
    ,P1.DISTRIBUTORCODE -- 销售商编号
    ,P1.PARTNER -- 商户编号
    ,P1.TANO -- TA代码
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.FUNDCODE -- 产品编号
    ,P1.BUSINESSCODE -- 业务代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.SHARETYPE END -- 收费方式代码
    ,P1.CUST_NO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUST_TYPE END -- 客户类型代码
    ,P1.TAACCOUNTID -- 基金账户编号
    ,P1.TRANSACTIONACCOUNTID -- 交易账户编号
    ,NVL(TRIM(P1.DEFDIVIDENDMETHOD),'-') -- 分红方式代码
    ,P1.ACCT_NO -- 账户编号
    ,P1.DEPOSIT_ACCT -- 银行卡号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,P1.APPLICATIONVOL -- 申请份额
    ,P1.APPLICATIONAMOUNT -- 申请金额
    ,P1.CONFIRMEDVOL -- 交易确认份额
    ,P1.CONFIRMEDAMOUNT -- 交易确认金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONCFMDATE) -- 交易确认日期
    ,P1.ORG_APP_SNO -- 原申请单编号
    ,P1.ORG_APP_VOL -- 原申请份额
    ,P1.PROTOCOLNO -- 基金代销协议编号
    ,P1.LARGEREDEMPTIONFLAG -- 巨额赎回处理代码
    ,P1.CHARGE -- 手续费
    ,P1.TARGETTAACCOUNTID -- 对方基金账户编号
    ,P1.TARGETDISTRIBUTORCODE -- 对方销售商代码
    ,P1.TARGETTRANSACTIONACCOUNTID -- 对方交易账户编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.TARGETSHARETYPE END -- 对方收费方式代码
    ,P1.FM_MANAGER -- 理财客户经理编号
    ,P1.AGENT_NAME -- 经办人姓名
    ,NVL(TRIM(P1.LAST_STATUS),'-') -- 上次申请状态代码
    ,NVL(TRIM(P1.STATUS),'-') -- 申请状态代码
    ,NVL(TRIM(P1.RISKMATCHING),'-') -- 风险等级匹配标志
    ,NVL(TRIM(P1.ORDERFLAG),'-') -- 下单方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCEPTMETHOD END -- 受理方式代码
    ,P1.OPERID -- 操作柜员编号
    ,P1.RETURNMSG -- 返回信息
    ,P1.OPERORGCENTER -- 交易分行编号
    ,P1.OPERORG -- 交易网点编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE||LPAD(P1.TRANSACTIONTIME,6,'0')) -- 交易时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE) -- 新增日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE||LPAD(P1.NEWTIME,6,'0')） -- 新增时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_app_trans_his' -- 源表名称
    ,'fsmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_app_trans_his p1
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.SHARETYPE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FSMS'
        AND R4.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R4.SRC_FIELD_EN_NAME= 'SHARETYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUST_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'CUST_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCYTYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.TARGETSHARETYPE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FSMS'
        AND R5.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS'
        AND R5.SRC_FIELD_EN_NAME= 'TARGETSHARETYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCEPTMETHOD= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FSMS'
        AND R3.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_TRANS_HIS'
        AND R3.SRC_FIELD_EN_NAME= 'ACCEPTMETHOD'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_ENTR_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
where  1 = 1 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
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
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 联行号
    ,nvl(n.appl_form_id, o.appl_form_id) as appl_form_id -- 申请单编号
    ,nvl(n.seller_id, o.seller_id) as seller_id -- 销售商编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.sell_mode_cd, o.sell_mode_cd) as sell_mode_cd -- 销售模式代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.bus_cd, o.bus_cd) as bus_cd -- 业务代码
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.fund_acct_id, o.fund_acct_id) as fund_acct_id -- 基金账户编号
    ,nvl(n.tran_acct_id, o.tran_acct_id) as tran_acct_id -- 交易账户编号
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.bank_card_num, o.bank_card_num) as bank_card_num -- 银行卡号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.appl_lot, o.appl_lot) as appl_lot -- 申请份额
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.tran_cfm_lot, o.tran_cfm_lot) as tran_cfm_lot -- 交易确认份额
    ,nvl(n.tran_cfm_amt, o.tran_cfm_amt) as tran_cfm_amt -- 交易确认金额
    ,nvl(n.tran_cfm_dt, o.tran_cfm_dt) as tran_cfm_dt -- 交易确认日期
    ,nvl(n.init_appl_form_id, o.init_appl_form_id) as init_appl_form_id -- 原申请单编号
    ,nvl(n.init_appl_lot, o.init_appl_lot) as init_appl_lot -- 原申请份额
    ,nvl(n.fund_consmt_agt_id, o.fund_consmt_agt_id) as fund_consmt_agt_id -- 基金代销协议编号
    ,nvl(n.huge_redem_proc_cd, o.huge_redem_proc_cd) as huge_redem_proc_cd -- 巨额赎回处理代码
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.cntpty_fund_acct_id, o.cntpty_fund_acct_id) as cntpty_fund_acct_id -- 对方基金账户编号
    ,nvl(n.cntpty_seller_cd, o.cntpty_seller_cd) as cntpty_seller_cd -- 对方销售商代码
    ,nvl(n.cntpty_tran_acct_id, o.cntpty_tran_acct_id) as cntpty_tran_acct_id -- 对方交易账户编号
    ,nvl(n.cntpty_charge_way_cd, o.cntpty_charge_way_cd) as cntpty_charge_way_cd -- 对方收费方式代码
    ,nvl(n.finc_cust_mgr_id, o.finc_cust_mgr_id) as finc_cust_mgr_id -- 理财客户经理编号
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 经办人姓名
    ,nvl(n.last_appl_status_cd, o.last_appl_status_cd) as last_appl_status_cd -- 上次申请状态代码
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.risk_level_match_flg, o.risk_level_match_flg) as risk_level_match_flg -- 风险等级匹配标志
    ,nvl(n.order_way_cd, o.order_way_cd) as order_way_cd -- 下单方式代码
    ,nvl(n.accpt_way_cd, o.accpt_way_cd) as accpt_way_cd -- 受理方式代码
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.tran_brch_id, o.tran_brch_id) as tran_brch_id -- 交易分行编号
    ,nvl(n.tran_brac_id, o.tran_brac_id) as tran_brac_id -- 交易网点编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.add_dt, o.add_dt) as add_dt -- 新增日期
    ,nvl(n.add_tm, o.add_tm) as add_tm -- 新增时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ibank_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ibank_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ibank_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm n
    full join (select * from ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ibank_no = n.ibank_no
where (
        o.evt_id is null
        and o.lp_id is null
        and o.ibank_no is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.ibank_no is null
    )
    or (
        o.appl_form_id <> n.appl_form_id
        or o.seller_id <> n.seller_id
        or o.mercht_id <> n.mercht_id
        or o.ta_cd <> n.ta_cd
        or o.sell_mode_cd <> n.sell_mode_cd
        or o.prod_id <> n.prod_id
        or o.bus_cd <> n.bus_cd
        or o.charge_way_cd <> n.charge_way_cd
        or o.cust_id <> n.cust_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.fund_acct_id <> n.fund_acct_id
        or o.tran_acct_id <> n.tran_acct_id
        or o.divd_way_cd <> n.divd_way_cd
        or o.acct_id <> n.acct_id
        or o.bank_card_num <> n.bank_card_num
        or o.curr_cd <> n.curr_cd
        or o.appl_lot <> n.appl_lot
        or o.appl_amt <> n.appl_amt
        or o.tran_cfm_lot <> n.tran_cfm_lot
        or o.tran_cfm_amt <> n.tran_cfm_amt
        or o.tran_cfm_dt <> n.tran_cfm_dt
        or o.init_appl_form_id <> n.init_appl_form_id
        or o.init_appl_lot <> n.init_appl_lot
        or o.fund_consmt_agt_id <> n.fund_consmt_agt_id
        or o.huge_redem_proc_cd <> n.huge_redem_proc_cd
        or o.comm_fee <> n.comm_fee
        or o.cntpty_fund_acct_id <> n.cntpty_fund_acct_id
        or o.cntpty_seller_cd <> n.cntpty_seller_cd
        or o.cntpty_tran_acct_id <> n.cntpty_tran_acct_id
        or o.cntpty_charge_way_cd <> n.cntpty_charge_way_cd
        or o.finc_cust_mgr_id <> n.finc_cust_mgr_id
        or o.operr_name <> n.operr_name
        or o.last_appl_status_cd <> n.last_appl_status_cd
        or o.appl_status_cd <> n.appl_status_cd
        or o.risk_level_match_flg <> n.risk_level_match_flg
        or o.order_way_cd <> n.order_way_cd
        or o.accpt_way_cd <> n.accpt_way_cd
        or o.oper_teller_id <> n.oper_teller_id
        or o.return_info <> n.return_info
        or o.tran_brch_id <> n.tran_brch_id
        or o.tran_brac_id <> n.tran_brac_id
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.add_dt <> n.add_dt
        or o.add_tm <> n.add_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,appl_form_id -- 申请单编号
    ,seller_id -- 销售商编号
    ,mercht_id -- 商户编号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,charge_way_cd -- 收费方式代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,divd_way_cd -- 分红方式代码
    ,acct_id -- 账户编号
    ,bank_card_num -- 银行卡号
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,tran_cfm_dt -- 交易确认日期
    ,init_appl_form_id -- 原申请单编号
    ,init_appl_lot -- 原申请份额
    ,fund_consmt_agt_id -- 基金代销协议编号
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,comm_fee -- 手续费
    ,cntpty_fund_acct_id -- 对方基金账户编号
    ,cntpty_seller_cd -- 对方销售商代码
    ,cntpty_tran_acct_id -- 对方交易账户编号
    ,cntpty_charge_way_cd -- 对方收费方式代码
    ,finc_cust_mgr_id -- 理财客户经理编号
    ,operr_name -- 经办人姓名
    ,last_appl_status_cd -- 上次申请状态代码
    ,appl_status_cd -- 申请状态代码
    ,risk_level_match_flg -- 风险等级匹配标志
    ,order_way_cd -- 下单方式代码
    ,accpt_way_cd -- 受理方式代码
    ,oper_teller_id -- 操作柜员编号
    ,return_info -- 返回信息
    ,tran_brch_id -- 交易分行编号
    ,tran_brac_id -- 交易网点编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
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
    ,o.ibank_no -- 联行号
    ,o.appl_form_id -- 申请单编号
    ,o.seller_id -- 销售商编号
    ,o.mercht_id -- 商户编号
    ,o.ta_cd -- TA代码
    ,o.sell_mode_cd -- 销售模式代码
    ,o.prod_id -- 产品编号
    ,o.bus_cd -- 业务代码
    ,o.charge_way_cd -- 收费方式代码
    ,o.cust_id -- 客户编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.fund_acct_id -- 基金账户编号
    ,o.tran_acct_id -- 交易账户编号
    ,o.divd_way_cd -- 分红方式代码
    ,o.acct_id -- 账户编号
    ,o.bank_card_num -- 银行卡号
    ,o.curr_cd -- 币种代码
    ,o.appl_lot -- 申请份额
    ,o.appl_amt -- 申请金额
    ,o.tran_cfm_lot -- 交易确认份额
    ,o.tran_cfm_amt -- 交易确认金额
    ,o.tran_cfm_dt -- 交易确认日期
    ,o.init_appl_form_id -- 原申请单编号
    ,o.init_appl_lot -- 原申请份额
    ,o.fund_consmt_agt_id -- 基金代销协议编号
    ,o.huge_redem_proc_cd -- 巨额赎回处理代码
    ,o.comm_fee -- 手续费
    ,o.cntpty_fund_acct_id -- 对方基金账户编号
    ,o.cntpty_seller_cd -- 对方销售商代码
    ,o.cntpty_tran_acct_id -- 对方交易账户编号
    ,o.cntpty_charge_way_cd -- 对方收费方式代码
    ,o.finc_cust_mgr_id -- 理财客户经理编号
    ,o.operr_name -- 经办人姓名
    ,o.last_appl_status_cd -- 上次申请状态代码
    ,o.appl_status_cd -- 申请状态代码
    ,o.risk_level_match_flg -- 风险等级匹配标志
    ,o.order_way_cd -- 下单方式代码
    ,o.accpt_way_cd -- 受理方式代码
    ,o.oper_teller_id -- 操作柜员编号
    ,o.return_info -- 返回信息
    ,o.tran_brch_id -- 交易分行编号
    ,o.tran_brac_id -- 交易网点编号
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.add_dt -- 新增日期
    ,o.add_tm -- 新增时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_bk o
    left join ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ibank_no = n.ibank_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.ibank_no = d.ibank_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_qxb_tran_entr_h;
alter table ${iml_schema}.evt_qxb_tran_entr_h truncate partition for ('fsmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_qxb_tran_entr_h exchange subpartition p_fsmsf1_19000101 with table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl;
alter table ${iml_schema}.evt_qxb_tran_entr_h exchange subpartition p_fsmsf1_20991231 with table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_qxb_tran_entr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_tm purge;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_op purge;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_qxb_tran_entr_h_fsmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_qxb_tran_entr_h', partname => 'p_fsmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
