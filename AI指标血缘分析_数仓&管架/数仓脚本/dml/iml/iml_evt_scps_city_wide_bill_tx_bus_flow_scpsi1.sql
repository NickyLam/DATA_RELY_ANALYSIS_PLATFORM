/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_scps_city_wide_bill_tx_bus_flow_scpsi1
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
drop table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow_scpsi1_tm purge;
alter table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow add partition p_scpsi1 values ('scpsi1')(
        subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow modify partition p_scpsi1
    add subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow_scpsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,proc_id -- 受理编号
    ,root_proc_id -- 根受理编号
    ,flow_num -- 流水号
    ,upper_tran_amt -- 大写交易金额
    ,lower_tran_amt -- 小写交易金额
    ,tran_org_id -- 交易机构编号
    ,city_wide_bill_tran_status_cd -- 同城票据交易状态代码
    ,tran_status_descb -- 交易状态描述
    ,memo_code -- 摘要码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,batch_proc_sync_proc_center_flg -- 批量处理同步受理中心标志
    ,batch_tot -- 批量总笔数
    ,splt_cnt -- 拆分笔数
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,entry_msg_flow_num -- 记账报文流水号
    ,entry_core_tran_flow_num -- 记账核心交易流水号
    ,entry_core_tran_dt -- 记账核心交易日期
    ,entry_status_cd -- 记账状态代码
    ,entry_org_id -- 记账机构编号
    ,city_wide_bill_tx_bus_cd -- 同城票交业务代码
    ,city_wide_bill_tx_bus_kind_cd -- 同城票交业务种类代码
    ,bus_attr_cd -- 业务属性代码
    ,exch_chn_cd -- 交换渠道代码
    ,exch_num_site -- 交换场次
    ,exch_bank_no -- 交换行号
    ,exch_dt -- 交换日期
    ,bus_submit_status_cd -- 业务提交状态代码
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_id -- 凭证编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_addr_desc -- 付款人地址描述
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,intnal_acct_flg -- 内部账户标志
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_addr_desc -- 收款人地址描述
    ,recvbl_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,pay_msg_flow_num -- 支付报文流水号
    ,pay_msg_tran_dt -- 支付报文交易日期
    ,pay_host_flow_num -- 支付主机流水号
    ,pay_host_tran_dt -- 支付主机交易日期
    ,pay_bus_seq_num -- 支付业务序号
    ,recver_info_rest_descb -- 收款人信息处理结果描述
    ,recver_info_proc_tm -- 收款人信息处理时间
    ,recver_info_proc_status_cd -- 收款人信息处理状态代码
    ,bill_cnt -- 票据张数
    ,endors_number -- 背书人数
    ,endors_lt_descb -- 背书清单描述
    ,draw_dt -- 出票日期
    ,tax_bill_flg -- 税票标志
    ,auto_seal_batch_id -- 自动验印批次编号
    ,present_cfm_batch_id -- 提出确认批次编号
    ,clear_num_site -- 清算场次
    ,clear_dt -- 清算日期
    ,city_wide_in_main_tran_flow_num -- 同城提入主交易流水号
    ,main_acct_que_info_desc -- 主账户查询信息描述
    ,acct_num_open_acct_org_id -- 账号开户机构编号
    ,city_wide_bill_tx_acct_status_cd -- 同城票交账户状态代码
    ,acct_num_bal_status_cd -- 账号余额状态代码
    ,debit_crdt_flg -- 借贷标志
    ,rela_flow_num -- 关联流水号
    ,enter_acct_flg -- 入账标志
    ,inacct_entry_status_cd -- 收妥入账记账状态代码
    ,inacct_bus_submit_status_cd -- 收妥入账业务提交状态代码
    ,inacct_entry_msg_flow_num -- 收妥入账记账报文流水号
    ,inacct_entry_core_tran_flow -- 收妥入账记账核心交易流水号
    ,inacct_entry_core_tran_dt -- 收妥入账记账核心交易日期
    ,inacct_entry_teller_id -- 收妥入账记账柜员编号
    ,inacct_auth_teller_id -- 收妥入账授权柜员编号
    ,inacct_tm -- 收妥入账时间
    ,agent_pay_bank_num -- 代理付款行号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_submit_status_cd -- 冲正提交状态代码
    ,revs_msg_flow_num -- 冲正报文流水号
    ,revs_core_tran_flow_num -- 冲正核心交易流水号
    ,revs_core_tran_dt -- 冲正核心交易日期
    ,revs_tm -- 冲正时间
    ,revs_rs_descb -- 冲正原因描述
    ,present_cfm_oper_teller_id -- 提出确认操作柜员编号
    ,present_cfm_auth_teller_id -- 提出确认授权柜员编号
    ,present_cfm_tm -- 提出确认时间
    ,check_teller_id -- 复核柜员编号
    ,check_tm -- 复核时间
    ,post_enter_acct_teller_id -- 暂缓入账柜员编号
    ,post_enter_acct_auth_teller_id -- 暂缓入账授权柜员编号
    ,post_enter_acct_tm -- 暂缓入账时间
    ,cancel_post_enter_acct_teller_id -- 取消暂缓入账柜员编号
    ,cancel_post_enter_acct_auth_teller_id -- 取消暂缓入账授权柜员编号
    ,cancel_post_enter_acct_tm -- 取消暂缓入账时间
    ,micr -- 磁码交易码
    ,init_batch_proc_id -- 原批量受理编号
    ,init_batch_flow_num -- 原批量流水号
    ,in_seq_num -- 提入序号
    ,in_bk_bank_no -- 提入行行号
    ,in_bank_name -- 提入行名称
    ,in_bus_init_way_cd -- 提入业务发起方式代码
    ,in_bk_num_site_attr_cd -- 提入行场次属性代码
    ,present_bk_bank_no -- 提出行行号
    ,present_bank_name -- 提出行名称
    ,paper_bill_bus_flg -- 纸质票据业务标志
    ,on_acct_proc_id -- 挂账受理编号
    ,obank_disho_bill_acct_proc_way_cd -- 他行退票账务处理方式代码
    ,disho_bill_type_cd -- 退票类型代码
    ,disho_bill_reason_descb -- 退票理由描述
    ,disho_bill_reason -- 退票理由
    ,senti_acct_flg -- 敏感账户标志
    ,trigger_od_bus_flg -- 触发透支业务标志
    ,od_amt -- 透支金额
    ,espec_submit_flg -- 特殊提交标志
    ,postsc -- 附言
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- scps_bp_bill_info_tb-1
insert into ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow_scpsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,proc_id -- 受理编号
    ,root_proc_id -- 根受理编号
    ,flow_num -- 流水号
    ,upper_tran_amt -- 大写交易金额
    ,lower_tran_amt -- 小写交易金额
    ,tran_org_id -- 交易机构编号
    ,city_wide_bill_tran_status_cd -- 同城票据交易状态代码
    ,tran_status_descb -- 交易状态描述
    ,memo_code -- 摘要码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,batch_proc_sync_proc_center_flg -- 批量处理同步受理中心标志
    ,batch_tot -- 批量总笔数
    ,splt_cnt -- 拆分笔数
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,entry_msg_flow_num -- 记账报文流水号
    ,entry_core_tran_flow_num -- 记账核心交易流水号
    ,entry_core_tran_dt -- 记账核心交易日期
    ,entry_status_cd -- 记账状态代码
    ,entry_org_id -- 记账机构编号
    ,city_wide_bill_tx_bus_cd -- 同城票交业务代码
    ,city_wide_bill_tx_bus_kind_cd -- 同城票交业务种类代码
    ,bus_attr_cd -- 业务属性代码
    ,exch_chn_cd -- 交换渠道代码
    ,exch_num_site -- 交换场次
    ,exch_bank_no -- 交换行号
    ,exch_dt -- 交换日期
    ,bus_submit_status_cd -- 业务提交状态代码
    ,vouch_kind_cd -- 凭证种类代码
    ,vouch_id -- 凭证编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,payer_name -- 付款人名称
    ,payer_acct_id -- 付款人账户编号
    ,payer_addr_desc -- 付款人地址描述
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行名称
    ,intnal_acct_flg -- 内部账户标志
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_addr_desc -- 收款人地址描述
    ,recvbl_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,pay_msg_flow_num -- 支付报文流水号
    ,pay_msg_tran_dt -- 支付报文交易日期
    ,pay_host_flow_num -- 支付主机流水号
    ,pay_host_tran_dt -- 支付主机交易日期
    ,pay_bus_seq_num -- 支付业务序号
    ,recver_info_rest_descb -- 收款人信息处理结果描述
    ,recver_info_proc_tm -- 收款人信息处理时间
    ,recver_info_proc_status_cd -- 收款人信息处理状态代码
    ,bill_cnt -- 票据张数
    ,endors_number -- 背书人数
    ,endors_lt_descb -- 背书清单描述
    ,draw_dt -- 出票日期
    ,tax_bill_flg -- 税票标志
    ,auto_seal_batch_id -- 自动验印批次编号
    ,present_cfm_batch_id -- 提出确认批次编号
    ,clear_num_site -- 清算场次
    ,clear_dt -- 清算日期
    ,city_wide_in_main_tran_flow_num -- 同城提入主交易流水号
    ,main_acct_que_info_desc -- 主账户查询信息描述
    ,acct_num_open_acct_org_id -- 账号开户机构编号
    ,city_wide_bill_tx_acct_status_cd -- 同城票交账户状态代码
    ,acct_num_bal_status_cd -- 账号余额状态代码
    ,debit_crdt_flg -- 借贷标志
    ,rela_flow_num -- 关联流水号
    ,enter_acct_flg -- 入账标志
    ,inacct_entry_status_cd -- 收妥入账记账状态代码
    ,inacct_bus_submit_status_cd -- 收妥入账业务提交状态代码
    ,inacct_entry_msg_flow_num -- 收妥入账记账报文流水号
    ,inacct_entry_core_tran_flow -- 收妥入账记账核心交易流水号
    ,inacct_entry_core_tran_dt -- 收妥入账记账核心交易日期
    ,inacct_entry_teller_id -- 收妥入账记账柜员编号
    ,inacct_auth_teller_id -- 收妥入账授权柜员编号
    ,inacct_tm -- 收妥入账时间
    ,agent_pay_bank_num -- 代理付款行号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_submit_status_cd -- 冲正提交状态代码
    ,revs_msg_flow_num -- 冲正报文流水号
    ,revs_core_tran_flow_num -- 冲正核心交易流水号
    ,revs_core_tran_dt -- 冲正核心交易日期
    ,revs_tm -- 冲正时间
    ,revs_rs_descb -- 冲正原因描述
    ,present_cfm_oper_teller_id -- 提出确认操作柜员编号
    ,present_cfm_auth_teller_id -- 提出确认授权柜员编号
    ,present_cfm_tm -- 提出确认时间
    ,check_teller_id -- 复核柜员编号
    ,check_tm -- 复核时间
    ,post_enter_acct_teller_id -- 暂缓入账柜员编号
    ,post_enter_acct_auth_teller_id -- 暂缓入账授权柜员编号
    ,post_enter_acct_tm -- 暂缓入账时间
    ,cancel_post_enter_acct_teller_id -- 取消暂缓入账柜员编号
    ,cancel_post_enter_acct_auth_teller_id -- 取消暂缓入账授权柜员编号
    ,cancel_post_enter_acct_tm -- 取消暂缓入账时间
    ,micr -- 磁码交易码
    ,init_batch_proc_id -- 原批量受理编号
    ,init_batch_flow_num -- 原批量流水号
    ,in_seq_num -- 提入序号
    ,in_bk_bank_no -- 提入行行号
    ,in_bank_name -- 提入行名称
    ,in_bus_init_way_cd -- 提入业务发起方式代码
    ,in_bk_num_site_attr_cd -- 提入行场次属性代码
    ,present_bk_bank_no -- 提出行行号
    ,present_bank_name -- 提出行名称
    ,paper_bill_bus_flg -- 纸质票据业务标志
    ,on_acct_proc_id -- 挂账受理编号
    ,obank_disho_bill_acct_proc_way_cd -- 他行退票账务处理方式代码
    ,disho_bill_type_cd -- 退票类型代码
    ,disho_bill_reason_descb -- 退票理由描述
    ,disho_bill_reason -- 退票理由
    ,senti_acct_flg -- 敏感账户标志
    ,trigger_od_bus_flg -- 触发透支业务标志
    ,od_amt -- 透支金额
    ,espec_submit_flg -- 特殊提交标志
    ,postsc -- 附言
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201017 '||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 序列号
    ,P1.ACCEPT_NO -- 受理编号
    ,P1.ROOT_ACCEPT_NO -- 根受理编号
    ,P1.SCAN_SEQ_NO -- 流水号
    ,nvl(trim(P1.TRN_AMT_CH),0) -- 大写交易金额
    ,nvl(trim(P1.TRN_AMT),0) -- 小写交易金额
    ,P1.TRAN_BR_CODE -- 交易机构编号
    ,P1.TR_STATE -- 同城票据交易状态代码
    ,P1.TR_STATE_MSG -- 交易状态描述
    ,P1.MEMOCD -- 摘要码
    ,P1.TR_DATE -- 交易日期
    ,to_timestamp(trim(P1.ACCEPT_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 交易时间
    ,P1.BATCH_IS_SYNC_ETE -- 批量处理同步受理中心标志
    ,nvl(trim(P1.BATCH_COUNT),0) -- 批量总笔数
    ,nvl(trim(P1.SPLIT_COUNT),0) -- 拆分笔数
    ,P1.USER_ID -- 柜员编号
    ,P1.CHARGE_ID -- 授权柜员编号
    ,P1.TALLY_SEND_SEQNO -- 记账报文流水号
    ,P1.TALLY_HOST_SEQNO -- 记账核心交易流水号
    ,${iml_schema}.dateformat_min(P1.TALLY_HOST_DATE) -- 记账核心交易日期
    ,decode(P1.TALLY_STATE,'0','11','1','03','2','15','00') -- 记账状态代码
    ,P1.BR_CODE -- 记账机构编号
    ,nvl(trim(P1.BIZ_CODE),'-') -- 同城票交业务代码
    ,P1.TXCD -- 同城票交业务种类代码
    ,P1.BIZ_TYPE -- 业务属性代码
    ,P1.CHANGE_CHANNEL -- 交换渠道代码
    ,nvl(trim(P1.TRADE_ROUND),0) -- 交换场次
    ,P1.TRADE_BANK_CODE -- 交换行号
    ,${iml_schema}.dateformat_min(P1.TRADE_DATE) -- 交换日期
    ,nvl(trim(P1.SUBMIT_STATE),'-') -- 业务提交状态代码
    ,P1.VOUCHER_CODE -- 凭证种类代码
    ,P1.VOUCHER_NO -- 凭证编号
    ,P1.CUST_NO -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,P1.CURR_CODE -- 币种代码
    ,P1.DRAWEE_NAME -- 付款人名称
    ,P1.DRAWEE_ACCT_NO -- 付款人账户编号
    ,P1.DRAWEE_ADDR -- 付款人地址描述
    ,P1.DRAWEE_BK_NO -- 付款行行号
    ,P1.DRAWEE_BK_NAME -- 付款行名称
    ,P1.INAC_FLAG -- 内部账户标志
    ,P1.PAYEE_NAME -- 收款人名称
    ,P1.PAYEE_ACCT_NO -- 收款人账户编号
    ,P1.PAYEE_ADDR -- 收款人地址描述
    ,P1.PAYEE_BK_NO -- 收款行行号
    ,P1.PAYEE_BK_NAME -- 收款行名称
    ,P1.PAY_SEND_SEQNO -- 支付报文流水号
    ,${iml_schema}.dateformat_min(P1.PAY_SEND_DATE) -- 支付报文交易日期
    ,P1.PAY_HOST_SEQNO -- 支付主机流水号
    ,${iml_schema}.dateformat_min(P1.PAY_HOST_DATE) -- 支付主机交易日期
    ,P1.PAY_BUSINESSTRACE -- 支付业务序号
    ,P1.DRAWEE_INFO_SEND_RESULT -- 收款人信息处理结果描述
    ,to_timestamp(trim(P1.DRAWEE_INFO_SEND_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 收款人信息处理时间
    ,P1.DRAWEE_INFO_SEND_FLAG -- 收款人信息处理状态代码
    ,nvl(trim(P1.TICKET_COUNT),0) -- 票据张数
    ,nvl(trim(P1.ENDORSER_NUM),0) -- 背书人数
    ,P1.ENDORSERS -- 背书清单描述
    ,${iml_schema}.dateformat_min(P1.BILL_DATE) -- 出票日期
    ,P1.TAX_BILL_FLAG -- 税票标志
    ,P1.AUTO_SEAL_BATCH_NO -- 自动验印批次编号
    ,P1.CONFIRM_BATCH_NO -- 提出确认批次编号
    ,nvl(trim(P1.CLEAR_CHANGE_NO),0) -- 清算场次
    ,${iml_schema}.dateformat_min(P1.CLEAR_DATE) -- 清算日期
    ,P1.BILL_SEQ_NO -- 同城提入主交易流水号
    ,P1.ACCT_QUERY_MSG -- 主账户查询信息描述
    ,P1.ACCT_BR_CODE -- 账号开户机构编号
    ,nvl(trim(P1.ACCT_STAT),'-') -- 同城票交账户状态代码
    ,nvl(trim(P1.ACCT_AMT_STAT),'-')  -- 账号余额状态代码
    ,P1.BILL_FLAG -- 借贷标志
    ,P1.RET_SCAN_SEQ_NO -- 关联流水号
    ,P1.INACCT_FLAG -- 入账标志
    ,nvl(trim(P1.INACCT_STATE),'-')   -- 收妥入账记账状态代码
    ,P1.INACCT_SUBMIT_STATE -- 收妥入账业务提交状态代码
    ,P1.INACCT_SEND_SEQNO -- 收妥入账记账报文流水号
    ,P1.INACCT_HOST_SEQNO -- 收妥入账记账核心交易流水号
    ,${iml_schema}.dateformat_min(P1.INACCT_HOST_DATE) -- 收妥入账记账核心交易日期
    ,P1.INACCT_USER_ID -- 收妥入账记账柜员编号
    ,P1.INACCT_CHARGE_ID -- 收妥入账授权柜员编号
    ,to_timestamp(trim(P1.INACCT_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 收妥入账时间
    ,P1.PROXY_DRAWEE_BK_NO -- 代理付款行号
    ,P1.REVERSED_USER_ID -- 冲正柜员编号
    ,P1.REVERSED_CHARGE_ID -- 冲正授权柜员编号
    ,P1.REVERSED_SUBMIT_STATE -- 冲正提交状态代码
    ,P1.REVERSED_SEND_SEQNO -- 冲正报文流水号
    ,P1.REVERSED_HOST_SEQNO -- 冲正核心交易流水号
    ,${iml_schema}.dateformat_min(P1.REVERSED_HOST_DATE) -- 冲正核心交易日期
    ,to_timestamp(trim(P1.REVERSED_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 冲正时间
    ,P1.REVERSED_REASON -- 冲正原因描述
    ,P1.OUT_CONFIRM_USERID -- 提出确认操作柜员编号
    ,P1.OUT_CONFIRM_CHARGEID -- 提出确认授权柜员编号
    ,to_timestamp(trim(P1.OUT_CONFIRM_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 提出确认时间
    ,P1.CHECK_USER_ID -- 复核柜员编号
    ,to_timestamp(trim(P1.CHECK_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 复核时间
    ,P1.DELAY_INACCT_USER_ID -- 暂缓入账柜员编号
    ,P1.DELAY_INACCT_CHARGE_ID -- 暂缓入账授权柜员编号
    ,to_timestamp(trim(P1.DELAY_INACCT_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 暂缓入账时间
    ,P1.CANCEL_DELAY_USER_ID -- 取消暂缓入账柜员编号
    ,P1.CANCEL_DELAY_CHARGE_ID -- 取消暂缓入账授权柜员编号
    ,to_timestamp(trim(P1.CANCEL_DELAY_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 取消暂缓入账时间
    ,P1.MICR -- 磁码交易码
    ,P1.REF_BATCH_ACCEPT_NO -- 原批量受理编号
    ,P1.REF_BATCH_SCAN_SEQ_NO -- 原批量流水号
    ,nvl(trim(P1.BILL_IN_ORDER),0) -- 提入序号
    ,P1.IN_BK_NO -- 提入行行号
    ,P1.IN_BK_NAME -- 提入行名称
    ,nvl(trim(P1.START_WAY),'-')   -- 提入业务发起方式代码
    ,P1.CHANGE_NO -- 提入行场次属性代码
    ,P1.OUT_BK_NO -- 提出行行号
    ,P1.OUT_BK_NAME -- 提出行名称
    ,P1.BILLND -- 纸质票据业务标志
    ,P1.SUSPEND_ACCT_ACCTPNO -- 挂账受理编号
    ,nvl(trim(P1.ACCT_DO_TYPE),'-')  -- 他行退票账务处理方式代码
    ,nvl(trim(P1.RET_TYPE),'-')  -- 退票类型代码
    ,P1.RETURN_REASON_DESC -- 退票理由描述
    ,P1.RETURN_REASON -- 退票理由
    ,P1.IF_SENSITIVE_ACCOUNT -- 敏感账户标志
    ,P1.ODRTFG -- 触发透支业务标志
    ,nvl(trim(P1.ODRTAM),0) -- 透支金额
    ,P1.IS_SPECIAL_SUBMIT -- 特殊提交标志
    ,P1.PURPOSE -- 附言
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scps_bp_bill_info_tb' -- 源表名称
    ,'scpsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scps_bp_bill_info_tb p1
where p1.TR_DATE = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow truncate subpartition p_scpsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow exchange subpartition p_scpsi1_${batch_date} with table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow_scpsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_scps_city_wide_bill_tx_bus_flow_scpsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_scps_city_wide_bill_tx_bus_flow', partname => 'p_scpsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);