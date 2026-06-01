/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_qxb_tran_cfm_evt_fsmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_qxb_tran_cfm_evt_fsmsi1_tm purge;
alter table ${iml_schema}.evt_qxb_tran_cfm_evt add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_qxb_tran_cfm_evt modify partition p_fsmsi1
    add subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_qxb_tran_cfm_evt_fsmsi1_tm
compress ${option_switch} for query high
as
select
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
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_tran_cfm_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fsms_yeb_ack_trans_his-
insert into ${iml_schema}.evt_qxb_tran_cfm_evt_fsmsi1_tm(
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
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSACTIONDATE||P1.TRANSACTIONTIME) -- 交易发生时间
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



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_qxb_tran_cfm_evt truncate subpartition p_fsmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_qxb_tran_cfm_evt exchange subpartition p_fsmsi1_${batch_date} with table ${iml_schema}.evt_qxb_tran_cfm_evt_fsmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_qxb_tran_cfm_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_qxb_tran_cfm_evt_fsmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_qxb_tran_cfm_evt', partname => 'p_fsmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);