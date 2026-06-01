/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_qxb_cust_cap_flow_fsmsi1
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
drop table ${iml_schema}.evt_qxb_cust_cap_flow_fsmsi1_tm purge;
alter table ${iml_schema}.evt_qxb_cust_cap_flow add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_qxb_cust_cap_flow modify partition p_fsmsi1
    add subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_qxb_cust_cap_flow_fsmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,cap_flow_id -- 资金流水编号
    ,subm_bank_flow_id -- 报送银行流水编号
    ,appl_form_id -- 申请单编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,acct_id -- 账户编号
    ,fund_cust_id -- 基金客户编号
    ,bank_card_num -- 银行卡号
    ,bank_acct -- 银行账户
    ,accpt_way_cd -- 受理方式代码
    ,return_tran_flow_num -- 返回交易流水号
    ,return_acct_dt -- 返回账务日期
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,spec_acct_brac_id -- 专户开户网点编号
    ,spec_acct_fname -- 专户全称
    ,spec_acct_name -- 专户帐户名称
    ,spec_acct_num -- 专户帐号
    ,spec_acct_cate_cd -- 专户类别代码
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,happ_amt -- 发生金额
    ,bank_acct_bal -- 银行账户余额
    ,need_send_cnt -- 需发送次数
    ,sended_cnt -- 已发送次数
    ,last_pay_status_cd -- 上次支付状态代码
    ,pay_status_cd -- 支付状态代码
    ,cancel_form_flg_cd -- 撤单标志代码
    ,tran_happ_brac_id -- 交易发生网点编号
    ,check_entry_status_cd -- 对账状态代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_qxb_cust_cap_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fsms_yeb_app_moneyall-
insert into ${iml_schema}.evt_qxb_cust_cap_flow_fsmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ibank_no -- 联行号
    ,cap_flow_id -- 资金流水编号
    ,subm_bank_flow_id -- 报送银行流水编号
    ,appl_form_id -- 申请单编号
    ,tran_happ_dt -- 交易发生日期
    ,tran_happ_tm -- 交易发生时间
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,prod_id -- 产品编号
    ,bus_cd -- 业务代码
    ,acct_id -- 账户编号
    ,fund_cust_id -- 基金客户编号
    ,bank_card_num -- 银行卡号
    ,bank_acct -- 银行账户
    ,accpt_way_cd -- 受理方式代码
    ,return_tran_flow_num -- 返回交易流水号
    ,return_acct_dt -- 返回账务日期
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,spec_acct_brac_id -- 专户开户网点编号
    ,spec_acct_fname -- 专户全称
    ,spec_acct_name -- 专户帐户名称
    ,spec_acct_num -- 专户帐号
    ,spec_acct_cate_cd -- 专户类别代码
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,happ_amt -- 发生金额
    ,bank_acct_bal -- 银行账户余额
    ,need_send_cnt -- 需发送次数
    ,sended_cnt -- 已发送次数
    ,last_pay_status_cd -- 上次支付状态代码
    ,pay_status_cd -- 支付状态代码
    ,cancel_form_flg_cd -- 撤单标志代码
    ,tran_happ_brac_id -- 交易发生网点编号
    ,check_entry_status_cd -- 对账状态代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102054'||P1.MONEYSERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.UNIONCODE -- 联行号
    ,P1.MONEYSERIALNO -- 资金流水编号
    ,P1.SERIALNO2BANK -- 报送银行流水编号
    ,P1.APP_SNO -- 申请单编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSACTIONDATE) -- 交易发生日期
    ,P1.TRANSACTIONTIME -- 交易发生时间
    ,P1.TANO -- TA代码
    ,NVL(TRIM(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.FUNDCODE -- 产品编号
    ,NVL(TRIM(P1.BUSINESSCODE),'-') -- 业务代码
    ,P1.ACCT_NO -- 账户编号
    ,P1.CUST_NO -- 基金客户编号
    ,P1.DEPOSIT_ACCT -- 银行卡号
    ,P1.DEPOSITACCOUNT -- 银行账户
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCEPTMETHOD END -- 受理方式代码
    ,P1.RETURNSERIALNO -- 返回交易流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.RETURNACCTDATE) -- 返回账务日期
    ,P1.RETURNCODE -- 返回码
    ,P1.RETURNMSG -- 返回信息
    ,P1.ACCTBANKCODE -- 专户开户网点编号
    ,P1.ACCTFULLNAME -- 专户全称
    ,P1.ACCTNAME -- 专户帐户名称
    ,P1.ACCTCODE -- 专户帐号
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 专户类别代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURRENCYTYPE END -- 币种代码
    ,NVL(TRIM(P1.SDCSHFLG),'-') -- 钞汇标识代码
    ,P1.MONEYASSET -- 发生金额
    ,P1.BANKACCTBALANCE -- 银行账户余额
    ,P1.SENDNEED -- 需发送次数
    ,P1.SENDTOT -- 已发送次数
    ,NVL(TRIM(P1.LAST_STATUS),'-') -- 上次支付状态代码
    ,NVL(TRIM(P1.STATUS),'-') -- 支付状态代码
    ,P1.CANCELFLAG -- 撤单标志代码
    ,P1.OPERORG -- 交易发生网点编号
    ,NVL(TRIM(P1.CHKSTATUS),'-') -- 对账状态代码
    ,P1.POSTSCRIPT -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_app_moneyall' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_app_moneyall p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCEPTMETHOD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_MONEYALL'
        AND R1.SRC_FIELD_EN_NAME= 'ACCEPTMETHOD'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_QXB_CUST_CAP_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACCPT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURRENCYTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_YEB_APP_MONEYALL'
        AND R2.SRC_FIELD_EN_NAME= 'CURRENCYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_QXB_CUST_CAP_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
    and P1.NEWDATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_qxb_cust_cap_flow truncate subpartition p_fsmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_qxb_cust_cap_flow exchange subpartition p_fsmsi1_${batch_date} with table ${iml_schema}.evt_qxb_cust_cap_flow_fsmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_qxb_cust_cap_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_qxb_cust_cap_flow_fsmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_qxb_cust_cap_flow', partname => 'p_fsmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);