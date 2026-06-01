/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl evt_scps_city_wide_bill_tx_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow
whenever sqlerror continue none;
drop table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow(
    etl_dt date -- ETL处理日期
    ,evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,proc_id varchar2(100) -- 受理编号
    ,root_proc_id varchar2(100) -- 根受理编号
    ,flow_num varchar2(100) -- 流水号
    ,upper_tran_amt varchar2(100) -- 大写交易金额
    ,lower_tran_amt number(30,2) -- 小写交易金额
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,city_wide_bill_tran_status_cd varchar2(30) -- 同城票据交易状态代码
    ,tran_status_descb varchar2(500) -- 交易状态描述
    ,memo_code varchar2(60) -- 摘要码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,batch_proc_sync_proc_center_flg varchar2(10) -- 批量处理同步受理中心标志
    ,batch_tot number(10) -- 批量总笔数
    ,splt_cnt number(10) -- 拆分笔数
    ,teller_id varchar2(100) -- 柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,entry_msg_flow_num varchar2(100) -- 记账报文流水号
    ,entry_core_tran_flow_num varchar2(100) -- 记账核心交易流水号
    ,entry_core_tran_dt date -- 记账核心交易日期
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,entry_org_id varchar2(100) -- 记账机构编号
    ,city_wide_bill_tx_bus_cd varchar2(30) -- 同城票交业务代码
    ,city_wide_bill_tx_bus_kind_cd varchar2(30) -- 同城票交业务种类代码
    ,bus_attr_cd varchar2(30) -- 业务属性代码
    ,exch_chn_cd varchar2(30) -- 交换渠道代码
    ,exch_num_site number(10) -- 交换场次
    ,exch_bank_no varchar2(60) -- 交换行号
    ,exch_dt date -- 交换日期
    ,bus_submit_status_cd varchar2(30) -- 业务提交状态代码
    ,vouch_kind_cd varchar2(30) -- 凭证种类代码
    ,vouch_id varchar2(100) -- 凭证编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,curr_cd varchar2(30) -- 币种代码
    ,payer_name varchar2(500) -- 付款人名称
    ,payer_acct_id varchar2(100) -- 付款人账户编号
    ,payer_addr_desc varchar2(500) -- 付款人地址描述
    ,pay_bank_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_name varchar2(500) -- 付款行名称
    ,intnal_acct_flg varchar2(10) -- 内部账户标志
    ,recver_name varchar2(500) -- 收款人名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,recver_addr_desc varchar2(500) -- 收款人地址描述
    ,recvbl_bank_no varchar2(60) -- 收款行行号
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,pay_msg_flow_num varchar2(100) -- 支付报文流水号
    ,pay_msg_tran_dt date -- 支付报文交易日期
    ,pay_host_flow_num varchar2(100) -- 支付主机流水号
    ,pay_host_tran_dt date -- 支付主机交易日期
    ,pay_bus_seq_num varchar2(60) -- 支付业务序号
    ,recver_info_rest_descb varchar2(500) -- 收款人信息处理结果描述
    ,recver_info_proc_tm timestamp -- 收款人信息处理时间
    ,recver_info_proc_status_cd varchar2(30) -- 收款人信息处理状态代码
    ,bill_cnt number(10) -- 票据张数
    ,endors_number number(10) -- 背书人数
    ,endors_lt_descb varchar2(4000) -- 背书清单描述
    ,draw_dt date -- 出票日期
    ,tax_bill_flg varchar2(10) -- 税票标志
    ,auto_seal_batch_id varchar2(100) -- 自动验印批次编号
    ,present_cfm_batch_id varchar2(100) -- 提出确认批次编号
    ,clear_num_site number(10) -- 清算场次
    ,clear_dt date -- 清算日期
    ,city_wide_in_main_tran_flow_num varchar2(100) -- 同城提入主交易流水号
    ,main_acct_que_info_desc varchar2(1000) -- 主账户查询信息描述
    ,acct_num_open_acct_org_id varchar2(100) -- 账号开户机构编号
    ,city_wide_bill_tx_acct_status_cd varchar2(30) -- 同城票交账户状态代码
    ,acct_num_bal_status_cd varchar2(30) -- 账号余额状态代码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,enter_acct_flg varchar2(10) -- 入账标志
    ,inacct_entry_status_cd varchar2(30) -- 收妥入账记账状态代码
    ,inacct_bus_submit_status_cd varchar2(30) -- 收妥入账业务提交状态代码
    ,inacct_entry_msg_flow_num varchar2(100) -- 收妥入账记账报文流水号
    ,inacct_entry_core_tran_flow varchar2(100) -- 收妥入账记账核心交易流水号
    ,inacct_entry_core_tran_dt date -- 收妥入账记账核心交易日期
    ,inacct_entry_teller_id varchar2(100) -- 收妥入账记账柜员编号
    ,inacct_auth_teller_id varchar2(100) -- 收妥入账授权柜员编号
    ,inacct_tm timestamp -- 收妥入账时间
    ,agent_pay_bank_num varchar2(60) -- 代理付款行号
    ,revs_teller_id varchar2(100) -- 冲正柜员编号
    ,revs_auth_teller_id varchar2(100) -- 冲正授权柜员编号
    ,revs_submit_status_cd varchar2(30) -- 冲正提交状态代码
    ,revs_msg_flow_num varchar2(100) -- 冲正报文流水号
    ,revs_core_tran_flow_num varchar2(100) -- 冲正核心交易流水号
    ,revs_core_tran_dt date -- 冲正核心交易日期
    ,revs_tm timestamp -- 冲正时间
    ,revs_rs_descb varchar2(500) -- 冲正原因描述
    ,present_cfm_oper_teller_id varchar2(100) -- 提出确认操作柜员编号
    ,present_cfm_auth_teller_id varchar2(100) -- 提出确认授权柜员编号
    ,present_cfm_tm timestamp -- 提出确认时间
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,check_tm timestamp -- 复核时间
    ,post_enter_acct_teller_id varchar2(100) -- 暂缓入账柜员编号
    ,post_enter_acct_auth_teller_id varchar2(100) -- 暂缓入账授权柜员编号
    ,post_enter_acct_tm timestamp -- 暂缓入账时间
    ,cancel_post_enter_acct_teller_id varchar2(100) -- 取消暂缓入账柜员编号
    ,cancel_post_enter_acct_auth_teller_id varchar2(100) -- 取消暂缓入账授权柜员编号
    ,cancel_post_enter_acct_tm timestamp -- 取消暂缓入账时间
    ,micr varchar2(30) -- 磁码交易码
    ,init_batch_proc_id varchar2(100) -- 原批量受理编号
    ,init_batch_flow_num varchar2(100) -- 原批量流水号
    ,in_seq_num number(18) -- 提入序号
    ,in_bk_bank_no varchar2(60) -- 提入行行号
    ,in_bank_name varchar2(500) -- 提入行名称
    ,in_bus_init_way_cd varchar2(30) -- 提入业务发起方式代码
    ,in_bk_num_site_attr_cd varchar2(30) -- 提入行场次属性代码
    ,present_bk_bank_no varchar2(60) -- 提出行行号
    ,present_bank_name varchar2(500) -- 提出行名称
    ,paper_bill_bus_flg varchar2(10) -- 纸质票据业务标志
    ,on_acct_proc_id varchar2(100) -- 挂账受理编号
    ,obank_disho_bill_acct_proc_way_cd varchar2(30) -- 他行退票账务处理方式代码
    ,disho_bill_type_cd varchar2(30) -- 退票类型代码
    ,disho_bill_reason_descb varchar2(1000) -- 退票理由描述
    ,disho_bill_reason varchar2(4000) -- 退票理由
    ,senti_acct_flg varchar2(10) -- 敏感账户标志
    ,trigger_od_bus_flg varchar2(10) -- 触发透支业务标志
    ,od_amt number(30,2) -- 透支金额
    ,espec_submit_flg varchar2(10) -- 特殊提交标志
    ,postsc varchar2(500) -- 附言
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow is '后援中心同城票交业务流水';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.evt_id is '事件编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.lp_id is '法人编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.ser_num is '序列号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.proc_id is '受理编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.root_proc_id is '根受理编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.flow_num is '流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.upper_tran_amt is '大写交易金额';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.lower_tran_amt is '小写交易金额';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.city_wide_bill_tran_status_cd is '同城票据交易状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.tran_status_descb is '交易状态描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.memo_code is '摘要码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.tran_dt is '交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.tran_tm is '交易时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.batch_proc_sync_proc_center_flg is '批量处理同步受理中心标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.batch_tot is '批量总笔数';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.splt_cnt is '拆分笔数';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.teller_id is '柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.auth_teller_id is '授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.entry_msg_flow_num is '记账报文流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.entry_core_tran_flow_num is '记账核心交易流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.entry_core_tran_dt is '记账核心交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.entry_org_id is '记账机构编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.city_wide_bill_tx_bus_cd is '同城票交业务代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.city_wide_bill_tx_bus_kind_cd is '同城票交业务种类代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.bus_attr_cd is '业务属性代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.exch_chn_cd is '交换渠道代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.exch_num_site is '交换场次';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.exch_bank_no is '交换行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.exch_dt is '交换日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.bus_submit_status_cd is '业务提交状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.vouch_kind_cd is '凭证种类代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.vouch_id is '凭证编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.cust_id is '客户编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.cust_name is '客户名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.curr_cd is '币种代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.payer_name is '付款人名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.payer_acct_id is '付款人账户编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.payer_addr_desc is '付款人地址描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_bank_bank_no is '付款行行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_bank_name is '付款行名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.intnal_acct_flg is '内部账户标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_name is '收款人名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_acct_id is '收款人账户编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_addr_desc is '收款人地址描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recvbl_bank_no is '收款行行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recv_bank_name is '收款行名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_msg_flow_num is '支付报文流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_msg_tran_dt is '支付报文交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_host_flow_num is '支付主机流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_host_tran_dt is '支付主机交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.pay_bus_seq_num is '支付业务序号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_info_rest_descb is '收款人信息处理结果描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_info_proc_tm is '收款人信息处理时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.recver_info_proc_status_cd is '收款人信息处理状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.bill_cnt is '票据张数';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.endors_number is '背书人数';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.endors_lt_descb is '背书清单描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.draw_dt is '出票日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.tax_bill_flg is '税票标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.auto_seal_batch_id is '自动验印批次编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_cfm_batch_id is '提出确认批次编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.clear_num_site is '清算场次';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.clear_dt is '清算日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.city_wide_in_main_tran_flow_num is '同城提入主交易流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.main_acct_que_info_desc is '主账户查询信息描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.acct_num_open_acct_org_id is '账号开户机构编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.city_wide_bill_tx_acct_status_cd is '同城票交账户状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.acct_num_bal_status_cd is '账号余额状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.debit_crdt_flg is '借贷标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.rela_flow_num is '关联流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.enter_acct_flg is '入账标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_entry_status_cd is '收妥入账记账状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_bus_submit_status_cd is '收妥入账业务提交状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_entry_msg_flow_num is '收妥入账记账报文流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_entry_core_tran_flow is '收妥入账记账核心交易流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_entry_core_tran_dt is '收妥入账记账核心交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_entry_teller_id is '收妥入账记账柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_auth_teller_id is '收妥入账授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.inacct_tm is '收妥入账时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.agent_pay_bank_num is '代理付款行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_teller_id is '冲正柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_auth_teller_id is '冲正授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_submit_status_cd is '冲正提交状态代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_msg_flow_num is '冲正报文流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_core_tran_flow_num is '冲正核心交易流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_core_tran_dt is '冲正核心交易日期';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_tm is '冲正时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.revs_rs_descb is '冲正原因描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_cfm_oper_teller_id is '提出确认操作柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_cfm_auth_teller_id is '提出确认授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_cfm_tm is '提出确认时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.check_teller_id is '复核柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.check_tm is '复核时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.post_enter_acct_teller_id is '暂缓入账柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.post_enter_acct_auth_teller_id is '暂缓入账授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.post_enter_acct_tm is '暂缓入账时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.cancel_post_enter_acct_teller_id is '取消暂缓入账柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.cancel_post_enter_acct_auth_teller_id is '取消暂缓入账授权柜员编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.cancel_post_enter_acct_tm is '取消暂缓入账时间';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.micr is '磁码交易码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.init_batch_proc_id is '原批量受理编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.init_batch_flow_num is '原批量流水号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.in_seq_num is '提入序号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.in_bk_bank_no is '提入行行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.in_bank_name is '提入行名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.in_bus_init_way_cd is '提入业务发起方式代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.in_bk_num_site_attr_cd is '提入行场次属性代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_bk_bank_no is '提出行行号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.present_bank_name is '提出行名称';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.paper_bill_bus_flg is '纸质票据业务标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.on_acct_proc_id is '挂账受理编号';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.obank_disho_bill_acct_proc_way_cd is '他行退票账务处理方式代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.disho_bill_type_cd is '退票类型代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.disho_bill_reason_descb is '退票理由描述';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.disho_bill_reason is '退票理由';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.senti_acct_flg is '敏感账户标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.trigger_od_bus_flg is '触发透支业务标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.od_amt is '透支金额';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.espec_submit_flg is '特殊提交标志';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.postsc is '附言';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.job_cd is '任务代码';
comment on column ${idl_schema}.evt_scps_city_wide_bill_tx_bus_flow.etl_timestamp is 'ETL处理时间戳';