/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_qxb_tran_cfm_h_fsmsi1
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
alter table ${iml_schema}.evt_qxb_tran_cfm_h add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_fsmsi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_cfm_h partition for ('fsmsi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm purge;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op purge;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_cfm_h partition for ('fsmsi1')
where 0=1
;

create table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_cfm_h partition for ('fsmsi1') where 0=1;

create table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_qxb_tran_cfm_h partition for ('fsmsi1') where 0=1;

-- 3.1 get new data into table
-- fsms_yeb_ack_trans-
insert into ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102058'||TRANSACTIONCFMDATE||TASERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.TANO -- TA代码
    ,P1.DISTRIBUTORCODE -- 销售商编号
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSACTIONCFMDATE) -- 确认日期
    ,P1.TASERIALNO -- TA确认流水号
    ,P1.APP_SNO -- 申请单编号
    ,P1.BUSINESSCODE_ACK -- 业务代码
    ,NVL(TRIM(P2.BANK_CUST_CODE),P1.CUST_NO) -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUST_TYPE END -- 客户类型代码
    ,P1.TAACCOUNTID -- 基金账户编号
    ,P1.TRANSACTIONACCOUNTID -- 交易账户编号
    ,P1.FUNDCODE -- 产品编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SHARETYPE END -- 收费方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,P1.APPLICATIONVOL -- 申请份额
    ,P1.APPLICATIONAMOUNT -- 申请金额
    ,P1.CONFIRMEDVOL -- 交易确认份额
    ,P1.CONFIRMEDAMOUNT -- 交易确认金额
    ,P1.ORG_APP_SNO -- 原申请单编号
    ,P1.DEPOSIT_ACCT -- 银行卡号
    ,NVL(TRIM(P1.DEFDIVIDENDMETHOD),'-') -- 分红方式代码
    ,NVL(TRIM(P1.LARGEREDEMPTIONFLAG),'-') -- 巨额赎回处理代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.FROZENCAUSE END -- 冻结原因代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.FREEZINGDEADLINE) -- 冻结截止日期
    ,NVL(TRIM(P1.FROMTAFLAG),'-') -- TA发起标志
    ,P1.CHARGE -- 手续费
    ,P1.RATEFEE -- 手续费费率
    ,P1.DISCOUNTRATE -- 佣金折扣率
    ,P1.AGENCYFEE -- 代理费
    ,P1.BACKFARE -- 后收手续费
    ,P1.INTEREST -- 利息
    ,P1.INTERESTTAX -- 利息税
    ,NVL(TRIM(P1.BUSINESSFINISHFLAG),'-') -- 业务过程结束标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.ACCEPTMETHOD END -- 受理方式代码
    ,P1.RETURNMSG -- 返回信息
    ,P1.RETURNCODE -- 返回码
    ,P1.OPERORGCENTER -- 交易发生支行编号
    ,P1.OPERORG -- 交易发生网点编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE) -- 交易发生日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE||LPAD(P1.TRANSACTIONTIME,6,'0')) -- 交易发生时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE) -- 新增日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE||LPAD(P1.NEWTIME,6,'0')) -- 新增时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_ack_trans' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_ack_trans p1
    left join ${iol_schema}.fsms_com_cust_info p2 on P1.CUST_NO=P2.CUST_NO
and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUST_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS'
        AND R1.SRC_FIELD_EN_NAME= 'CUST_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SHARETYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS'
        AND R2.SRC_FIELD_EN_NAME= 'SHARETYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURRENCYTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FSMS'
        AND R3.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS'
        AND R3.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.FROZENCAUSE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FSMS'
        AND R4.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS'
        AND R4.SRC_FIELD_EN_NAME= 'FROZENCAUSE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'FROZ_RS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ACCEPTMETHOD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FSMS'
        AND R5.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS'
        AND R5.SRC_FIELD_EN_NAME= 'ACCEPTMETHOD'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.TRANSACTIONCFMDATE='${batch_date}'
;
commit;

-- fsms_yeb_ack_trans_his-
insert into ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
    ,add_dt -- 新增日期
    ,add_tm -- 新增时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102058'||TRANSACTIONCFMDATE||TASERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.TANO -- TA代码
    ,P1.DISTRIBUTORCODE -- 销售商编号
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSACTIONCFMDATE) -- 确认日期
    ,P1.TASERIALNO -- TA确认流水号
    ,P1.APP_SNO -- 申请单编号
    ,P1.BUSINESSCODE_ACK -- 业务代码
    ,NVL(TRIM(P2.BANK_CUST_CODE),P1.CUST_NO) -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUST_TYPE END -- 客户类型代码
    ,P1.TAACCOUNTID -- 基金账户编号
    ,P1.TRANSACTIONACCOUNTID -- 交易账户编号
    ,P1.FUNDCODE -- 产品编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SHARETYPE END -- 收费方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,P1.APPLICATIONVOL -- 申请份额
    ,P1.APPLICATIONAMOUNT -- 申请金额
    ,P1.CONFIRMEDVOL -- 交易确认份额
    ,P1.CONFIRMEDAMOUNT -- 交易确认金额
    ,P1.ORG_APP_SNO -- 原申请单编号
    ,P1.DEPOSIT_ACCT -- 银行卡号
    ,NVL(TRIM(P1.DEFDIVIDENDMETHOD),'-') -- 分红方式代码
    ,NVL(TRIM(P1.LARGEREDEMPTIONFLAG),'-') -- 巨额赎回处理代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.FROZENCAUSE END -- 冻结原因代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.FREEZINGDEADLINE) -- 冻结截止日期
    ,NVL(TRIM(P1.FROMTAFLAG),'-') -- TA发起标志
    ,P1.CHARGE -- 手续费
    ,P1.RATEFEE -- 手续费费率
    ,P1.DISCOUNTRATE -- 佣金折扣率
    ,P1.AGENCYFEE -- 代理费
    ,P1.BACKFARE -- 后收手续费
    ,P1.INTEREST -- 利息
    ,P1.INTERESTTAX -- 利息税
    ,NVL(TRIM(P1.BUSINESSFINISHFLAG),'-') -- 业务过程结束标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.ACCEPTMETHOD END -- 受理方式代码
    ,P1.RETURNMSG -- 返回信息
    ,P1.RETURNCODE -- 返回码
    ,P1.OPERORGCENTER -- 交易发生支行编号
    ,P1.OPERORG -- 交易发生网点编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE) -- 交易发生日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE||LPAD(P1.TRANSACTIONTIME,6,'0')) -- 交易发生时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE) -- 新增日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.NEWDATE||LPAD(P1.NEWTIME,6,'0')) -- 新增时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_ack_trans_his' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_ack_trans_his p1
    left join ${iol_schema}.fsms_com_cust_info p2 on P1.CUST_NO=P2.CUST_NO
and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUST_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'CUST_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SHARETYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS_HIS'
        AND R2.SRC_FIELD_EN_NAME= 'SHARETYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CHARGE_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURRENCYTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FSMS'
        AND R3.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS_HIS'
        AND R3.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.FROZENCAUSE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FSMS'
        AND R4.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS_HIS'
        AND R4.SRC_FIELD_EN_NAME= 'FROZENCAUSE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'FROZ_RS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.ACCEPTMETHOD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'FSMS'
        AND R5.SRC_TAB_EN_NAME= 'FSMS_YEB_ACK_TRANS_HIS'
        AND R5.SRC_FIELD_EN_NAME= 'ACCEPTMETHOD'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_QXB_TRAN_CFM_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.TRANSACTIONCFMDATE='${batch_date}'
;
commit;


commit;

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
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
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.ibank_no -- 联行号
    ,n.ta_cd -- TA代码
    ,n.seller_id -- 销售商编号
    ,n.sell_mode_cd -- 销售模式代码
    ,n.cfm_dt -- 确认日期
    ,n.ta_cfm_flow_num -- TA确认流水号
    ,n.appl_form_id -- 申请单编号
    ,n.bus_cd -- 业务代码
    ,n.cust_id -- 客户编号
    ,n.cust_type_cd -- 客户类型代码
    ,n.fund_acct_id -- 基金账户编号
    ,n.tran_acct_id -- 交易账户编号
    ,n.prod_id -- 产品编号
    ,n.charge_way_cd -- 收费方式代码
    ,n.curr_cd -- 币种代码
    ,n.appl_lot -- 申请份额
    ,n.appl_amt -- 申请金额
    ,n.tran_cfm_lot -- 交易确认份额
    ,n.tran_cfm_amt -- 交易确认金额
    ,n.init_appl_form_id -- 原申请单编号
    ,n.bank_card_num -- 银行卡号
    ,n.divd_way_cd -- 分红方式代码
    ,n.huge_redem_proc_cd -- 巨额赎回处理代码
    ,n.froz_rs_cd -- 冻结原因代码
    ,n.froz_closing_dt -- 冻结截止日期
    ,n.ta_init_flg -- TA发起标志
    ,n.comm_fee -- 手续费
    ,n.comm_fee_rat -- 手续费费率
    ,n.comm_discnt_rat -- 佣金折扣率
    ,n.agent_fee -- 代理费
    ,n.post_recv_comm_fee -- 后收手续费
    ,n.interest -- 利息
    ,n.int_tax -- 利息税
    ,n.bus_prdure_end_flg -- 业务过程结束标志
    ,n.accpt_way_cd -- 受理方式代码
    ,n.return_info -- 返回信息
    ,n.return_code -- 返回码
    ,n.tran_happ_subrch_id -- 交易发生支行编号
    ,n.tran_happ_brac_id -- 交易发生网点编号
    ,n.tran_happ_dt -- 交易发生日期
    ,n.tran_happ_tm -- 交易发生时间
    ,n.add_dt -- 新增日期
    ,n.add_tm -- 新增时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'fsmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm n
    left join (select * from ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ibank_no = n.ibank_no
            and o.ta_cd = n.ta_cd
where (
        o.evt_id is null
        and o.lp_id is null
        and o.ibank_no is null
        and o.ta_cd is null
    )
    or (
        o.seller_id <> n.seller_id
        or o.sell_mode_cd <> n.sell_mode_cd
        or o.cfm_dt <> n.cfm_dt
        or o.ta_cfm_flow_num <> n.ta_cfm_flow_num
        or o.appl_form_id <> n.appl_form_id
        or o.bus_cd <> n.bus_cd
        or o.cust_id <> n.cust_id
        or o.cust_type_cd <> n.cust_type_cd
        or o.fund_acct_id <> n.fund_acct_id
        or o.tran_acct_id <> n.tran_acct_id
        or o.prod_id <> n.prod_id
        or o.charge_way_cd <> n.charge_way_cd
        or o.curr_cd <> n.curr_cd
        or o.appl_lot <> n.appl_lot
        or o.appl_amt <> n.appl_amt
        or o.tran_cfm_lot <> n.tran_cfm_lot
        or o.tran_cfm_amt <> n.tran_cfm_amt
        or o.init_appl_form_id <> n.init_appl_form_id
        or o.bank_card_num <> n.bank_card_num
        or o.divd_way_cd <> n.divd_way_cd
        or o.huge_redem_proc_cd <> n.huge_redem_proc_cd
        or o.froz_rs_cd <> n.froz_rs_cd
        or o.froz_closing_dt <> n.froz_closing_dt
        or o.ta_init_flg <> n.ta_init_flg
        or o.comm_fee <> n.comm_fee
        or o.comm_fee_rat <> n.comm_fee_rat
        or o.comm_discnt_rat <> n.comm_discnt_rat
        or o.agent_fee <> n.agent_fee
        or o.post_recv_comm_fee <> n.post_recv_comm_fee
        or o.interest <> n.interest
        or o.int_tax <> n.int_tax
        or o.bus_prdure_end_flg <> n.bus_prdure_end_flg
        or o.accpt_way_cd <> n.accpt_way_cd
        or o.return_info <> n.return_info
        or o.return_code <> n.return_code
        or o.tran_happ_subrch_id <> n.tran_happ_subrch_id
        or o.tran_happ_brac_id <> n.tran_happ_brac_id
        or o.tran_happ_dt <> n.tran_happ_dt
        or o.tran_happ_tm <> n.tran_happ_tm
        or o.add_dt <> n.add_dt
        or o.add_tm <> n.add_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
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
        into ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,seller_id -- 销售商编号
    ,sell_mode_cd -- 销售模式代码
    ,cfm_dt -- 确认日期
    ,ta_cfm_flow_num -- TA确认流水号
    ,appl_form_id -- 申请单编号
    ,bus_cd -- 业务代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,fund_acct_id -- 基金账户编号
    ,tran_acct_id -- 交易账户编号
    ,prod_id -- 产品编号
    ,charge_way_cd -- 收费方式代码
    ,curr_cd -- 币种代码
    ,appl_lot -- 申请份额
    ,appl_amt -- 申请金额
    ,tran_cfm_lot -- 交易确认份额
    ,tran_cfm_amt -- 交易确认金额
    ,init_appl_form_id -- 原申请单编号
    ,bank_card_num -- 银行卡号
    ,divd_way_cd -- 分红方式代码
    ,huge_redem_proc_cd -- 巨额赎回处理代码
    ,froz_rs_cd -- 冻结原因代码
    ,froz_closing_dt -- 冻结截止日期
    ,ta_init_flg -- TA发起标志
    ,comm_fee -- 手续费
    ,comm_fee_rat -- 手续费费率
    ,comm_discnt_rat -- 佣金折扣率
    ,agent_fee -- 代理费
    ,post_recv_comm_fee -- 后收手续费
    ,interest -- 利息
    ,int_tax -- 利息税
    ,bus_prdure_end_flg -- 业务过程结束标志
    ,accpt_way_cd -- 受理方式代码
    ,return_info -- 返回信息
    ,return_code -- 返回码
    ,tran_happ_subrch_id -- 交易发生支行编号
    ,tran_happ_brac_id -- 交易发生网点编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
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
    ,o.ta_cd -- TA代码
    ,o.seller_id -- 销售商编号
    ,o.sell_mode_cd -- 销售模式代码
    ,o.cfm_dt -- 确认日期
    ,o.ta_cfm_flow_num -- TA确认流水号
    ,o.appl_form_id -- 申请单编号
    ,o.bus_cd -- 业务代码
    ,o.cust_id -- 客户编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.fund_acct_id -- 基金账户编号
    ,o.tran_acct_id -- 交易账户编号
    ,o.prod_id -- 产品编号
    ,o.charge_way_cd -- 收费方式代码
    ,o.curr_cd -- 币种代码
    ,o.appl_lot -- 申请份额
    ,o.appl_amt -- 申请金额
    ,o.tran_cfm_lot -- 交易确认份额
    ,o.tran_cfm_amt -- 交易确认金额
    ,o.init_appl_form_id -- 原申请单编号
    ,o.bank_card_num -- 银行卡号
    ,o.divd_way_cd -- 分红方式代码
    ,o.huge_redem_proc_cd -- 巨额赎回处理代码
    ,o.froz_rs_cd -- 冻结原因代码
    ,o.froz_closing_dt -- 冻结截止日期
    ,o.ta_init_flg -- TA发起标志
    ,o.comm_fee -- 手续费
    ,o.comm_fee_rat -- 手续费费率
    ,o.comm_discnt_rat -- 佣金折扣率
    ,o.agent_fee -- 代理费
    ,o.post_recv_comm_fee -- 后收手续费
    ,o.interest -- 利息
    ,o.int_tax -- 利息税
    ,o.bus_prdure_end_flg -- 业务过程结束标志
    ,o.accpt_way_cd -- 受理方式代码
    ,o.return_info -- 返回信息
    ,o.return_code -- 返回码
    ,o.tran_happ_subrch_id -- 交易发生支行编号
    ,o.tran_happ_brac_id -- 交易发生网点编号
    ,o.tran_happ_dt -- 交易发生日期
    ,o.tran_happ_tm -- 交易发生时间
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
from ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_bk o
    left join ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ibank_no = n.ibank_no
            and o.ta_cd = n.ta_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_qxb_tran_cfm_h;
alter table ${iml_schema}.evt_qxb_tran_cfm_h truncate partition for ('fsmsi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_qxb_tran_cfm_h exchange subpartition p_fsmsi1_19000101 with table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_cl;
alter table ${iml_schema}.evt_qxb_tran_cfm_h exchange subpartition p_fsmsi1_20991231 with table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_qxb_tran_cfm_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_tm purge;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_op purge;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_qxb_tran_cfm_h_fsmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_qxb_tran_cfm_h', partname => 'p_fsmsi1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
