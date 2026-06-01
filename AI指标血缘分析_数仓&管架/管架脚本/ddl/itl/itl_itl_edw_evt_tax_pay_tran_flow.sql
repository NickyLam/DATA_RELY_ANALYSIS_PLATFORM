/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_tax_pay_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_tm timestamp -- 交易时间
    ,tran_type_subdv_cd varchar2(30) -- 交易类型细分代码
    ,nostro_cd varchar2(30) -- 往来账代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,check_entry_dt date -- 对账日期
    ,core_tran_dt date -- 核心交易日期
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,revs_dt date -- 冲正日期
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,return_code varchar2(30) -- 返回码
    ,return_info varchar2(250) -- 返回信息
    ,init_rg_cd varchar2(30) -- 发起地区代码
    ,recv_rg_cd varchar2(30) -- 接收地区代码
    ,entr_dt date -- 委托日期
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee number(30,2) -- 手续费
    ,postage number(30,2) -- 邮电费
    ,todos number(30,2) -- 工本费
    ,origi_bank_no varchar2(100) -- 发起行行号
    ,pay_bank_no varchar2(100) -- 付款行行号
    ,payer_open_bank_no varchar2(100) -- 付款人开户行行号
    ,payer_acct_id varchar2(60) -- 付款人账户编号
    ,payer_name varchar2(250) -- 付款人名称
    ,payer_open_acct_org_id varchar2(60) -- 付款人开户机构编号
    ,recv_bank_no varchar2(100) -- 收款行行号
    ,recver_open_bank_no varchar2(100) -- 收款人开户行行号
    ,recver_acct_id varchar2(60) -- 收款人账户编号
    ,recver_name varchar2(250) -- 收款人名称
    ,bus_chn_cd varchar2(30) -- 业务渠道代码
    ,bank_no varchar2(100) -- 经收处银行行号
    ,bank_submit_dt date -- 银行提交日期
    ,tax_bur_flow_num varchar2(100) -- 税局流水号
    ,org_cate_cd varchar2(30) -- 机关类别代码
    ,impose_org_id varchar2(60) -- 征收机关编号
    ,impose_org_submit_dt date -- 征收机关提交日期
    ,impose_org_flow_num varchar2(100) -- 征收机关流水号
    ,recvbl_trea_id varchar2(60) -- 收款国库编号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,impose_org_revs_dt date -- 征收机关冲正日期
    ,impose_org_revs_flow_num varchar2(100) -- 征收机关冲正流水号
    ,taxpayer_id varchar2(60) -- 纳税人编号
    ,taxpayer_name varchar2(250) -- 纳税人名称
    ,decl_way_cd varchar2(30) -- 申报方式代码
    ,decl_flow_num varchar2(100) -- 申报流水号
    ,pay_way_cd varchar2(30) -- 缴款方式代码
    ,clear_dt date -- 清算日期
    ,bus_org_id varchar2(60) -- 营业机构编号
    ,teller_id varchar2(60) -- 柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,auth_brac_id varchar2(60) -- 授权网点编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,refund_acct_id varchar2(60) -- 退款账户编号
    ,refund_acct_name varchar2(250) -- 退款户账户名称
    ,pay_ps_tel_num varchar2(100) -- 缴款人电话号码
    ,pay_ps_cert_type_cd varchar2(30) -- 缴款人证件类型代码
    ,pay_ps_cert_no varchar2(100) -- 缴款人证件号码
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,vouch_id varchar2(60) -- 凭证编号
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,chn_flow_num varchar2(100) -- 渠道流水号
    ,etl_dt date -- 数据日期
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
grant select on ${itl_schema}.itl_edw_evt_tax_pay_tran_flow to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow is '财税缴费交易流水';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_tm is '交易时间';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_type_subdv_cd is '交易类型细分代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.nostro_cd is '往来账代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.mgmt_org_id is '管理机构编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.check_entry_dt is '对账日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.revs_dt is '冲正日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.revs_flow_num is '冲正流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.return_code is '返回码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.return_info is '返回信息';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.init_rg_cd is '发起地区代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recv_rg_cd is '接收地区代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.entr_dt is '委托日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.mode_pay_cd is '支付方式代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_amt is '交易金额';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.comm_fee is '手续费';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.postage is '邮电费';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.todos is '工本费';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.origi_bank_no is '发起行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.pay_bank_no is '付款行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.payer_open_bank_no is '付款人开户行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.payer_acct_id is '付款人账户编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.payer_name is '付款人名称';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.payer_open_acct_org_id is '付款人开户机构编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recv_bank_no is '收款行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recver_open_bank_no is '收款人开户行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recver_acct_id is '收款人账户编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recver_name is '收款人名称';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.bus_chn_cd is '业务渠道代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.bank_no is '经收处银行行号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.bank_submit_dt is '银行提交日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tax_bur_flow_num is '税局流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.org_cate_cd is '机关类别代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.impose_org_id is '征收机关编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.impose_org_submit_dt is '征收机关提交日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.impose_org_flow_num is '征收机关流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.recvbl_trea_id is '收款国库编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.impose_org_revs_dt is '征收机关冲正日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.impose_org_revs_flow_num is '征收机关冲正流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.taxpayer_id is '纳税人编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.taxpayer_name is '纳税人名称';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.decl_way_cd is '申报方式代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.decl_flow_num is '申报流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.pay_way_cd is '缴款方式代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.clear_dt is '清算日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.bus_org_id is '营业机构编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.teller_id is '柜员编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.auth_brac_id is '授权网点编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.refund_acct_id is '退款账户编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.refund_acct_name is '退款户账户名称';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.pay_ps_tel_num is '缴款人电话号码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.pay_ps_cert_type_cd is '缴款人证件类型代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.pay_ps_cert_no is '缴款人证件号码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.vouch_id is '凭证编号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.chn_flow_num is '渠道流水号';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_evt_tax_pay_tran_flow.etl_timestamp is 'ETL处理时间戳';
