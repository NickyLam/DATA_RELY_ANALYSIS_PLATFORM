/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bid_margin_enter_acct_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bid_margin_enter_acct_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bid_margin_enter_acct_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bid_margin_enter_acct_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_tran_flow_num varchar2(100) -- 中台交易流水号
    ,tran_cd varchar2(30) -- 交易代码
    ,midgrod_dt date -- 中台日期
    ,chn_sys_cd varchar2(30) -- 渠道系统代码
    ,chn_tran_dt date -- 渠道交易日期
    ,chn_tran_flow_num varchar2(100) -- 渠道交易流水号
    ,chn_org_id varchar2(100) -- 渠道机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,avl_tm timestamp -- 到帐时间
    ,avl_amt number(30,2) -- 到帐金额
    ,advise_status_cd varchar2(30) -- 通知状态代码
    ,fin_status_cd varchar2(30) -- 财务状态代码
    ,aldy_check_entry_flg varchar2(10) -- 已对账标志
    ,refund_flg varchar2(10) -- 退汇标志
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(750) -- 付款账户名称
    ,payer_open_bank_num varchar2(100) -- 付款人开户行号
    ,payer_open_bank_name varchar2(750) -- 付款人开户行名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(750) -- 收款账户名称
    ,stl_acct_id varchar2(100) -- 结算账户编号
    ,stl_acct_name varchar2(750) -- 结算账户名称
    ,stl_acct_bal number(30,2) -- 结算账户余额
    ,margin_acct_status_cd varchar2(30) -- 保证金账户状态代码
    ,core_entry_tran_dt date -- 核心记账交易日期
    ,core_entry_host_flow_num varchar2(100) -- 核心记账主机流水号
    ,core_entry_tran_flow_num varchar2(100) -- 核心记账交易流水号
    ,core_entry_status varchar2(30) -- 核心记账状态代码
    ,memo_cd varchar2(30) -- 摘要代码
    ,f_r_acct_up_host_return_code varchar2(150) -- 内部户到结算户上主机返回码
    ,f_r_acct_host_return_info varchar2(750) -- 内部户到结算户主机返回信息
    ,f_r_acct_host_dt date -- 内部户到结算户主机日期
    ,f_r_acct_host_flow varchar2(100) -- 内部户到结算户主机流水号
    ,open_acct_status_cd varchar2(30) -- 开户状态代码
    ,open_acct_dt date -- 开户日期
    ,open_acct_host_flow_num varchar2(100) -- 开户上主机流水号
    ,open_acct_host_dt date -- 开户主机日期
    ,open_acct_uphost_flow varchar2(100) -- 开户主机流水号
    ,open_acct_host_return_code varchar2(150) -- 开户主机返回码
    ,open_acct_host_return_info varchar2(750) -- 开户主机返回信息
    ,open_bank_name varchar2(150) -- 开户行名称
    ,trdpty_tran_dt date -- 第三方交易日期
    ,trdpty_flow_num varchar2(100) -- 第三方流水号
    ,rest_cd varchar2(30) -- 处理结果代码
    ,rest_descb varchar2(750) -- 处理结果描述
    ,fail_rs_descb varchar2(750) -- 失败原因描述
    ,postsc varchar2(750) -- 附言
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,tran_vouch_type_cd varchar2(30) -- 交易凭证类型代码
    ,tran_vouch_no varchar2(60) -- 交易凭证号码
    ,tran_vouch_sell_dt date -- 交易凭证出售日期
    ,aldy_spdst_flg_cd varchar2(30) -- 已试算标志代码
    ,spdst_uniq_idf varchar2(150) -- 试算唯一标识
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,advise_send_cnt number(10) -- 通知推送次数
    ,proj_name varchar2(750) -- 项目名称
    ,oper_name varchar2(750) -- 经办名称
    ,memo_descb varchar2(750) -- 摘要描述
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_bid_margin_enter_acct_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_bid_margin_enter_acct_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_bid_margin_enter_acct_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bid_margin_enter_acct_info_h is '招投标保证金入账信息历史';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.midgrod_tran_flow_num is '中台交易流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_cd is '交易代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.midgrod_dt is '中台日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.chn_sys_cd is '渠道系统代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.chn_tran_dt is '渠道交易日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.chn_tran_flow_num is '渠道交易流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.chn_org_id is '渠道机构编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.avl_tm is '到帐时间';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.avl_amt is '到帐金额';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.advise_status_cd is '通知状态代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.fin_status_cd is '财务状态代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.aldy_check_entry_flg is '已对账标志';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.refund_flg is '退汇标志';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.payer_open_bank_num is '付款人开户行号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.payer_open_bank_name is '付款人开户行名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.stl_acct_id is '结算账户编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.stl_acct_name is '结算账户名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.stl_acct_bal is '结算账户余额';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.margin_acct_status_cd is '保证金账户状态代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.core_entry_tran_dt is '核心记账交易日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.core_entry_host_flow_num is '核心记账主机流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.core_entry_tran_flow_num is '核心记账交易流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.core_entry_status is '核心记账状态代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.memo_cd is '摘要代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.f_r_acct_up_host_return_code is '内部户到结算户上主机返回码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.f_r_acct_host_return_info is '内部户到结算户主机返回信息';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.f_r_acct_host_dt is '内部户到结算户主机日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.f_r_acct_host_flow is '内部户到结算户主机流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_status_cd is '开户状态代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_host_flow_num is '开户上主机流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_host_dt is '开户主机日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_uphost_flow is '开户主机流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_host_return_code is '开户主机返回码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_acct_host_return_info is '开户主机返回信息';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.open_bank_name is '开户行名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.trdpty_tran_dt is '第三方交易日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.trdpty_flow_num is '第三方流水号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.rest_cd is '处理结果代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.rest_descb is '处理结果描述';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.fail_rs_descb is '失败原因描述';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.postsc is '附言';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_vouch_type_cd is '交易凭证类型代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_vouch_no is '交易凭证号码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_vouch_sell_dt is '交易凭证出售日期';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.aldy_spdst_flg_cd is '已试算标志代码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.spdst_uniq_idf is '试算唯一标识';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.advise_send_cnt is '通知推送次数';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.proj_name is '项目名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.oper_name is '经办名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.memo_descb is '摘要描述';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bid_margin_enter_acct_info_h.etl_timestamp is 'ETL处理时间戳';
