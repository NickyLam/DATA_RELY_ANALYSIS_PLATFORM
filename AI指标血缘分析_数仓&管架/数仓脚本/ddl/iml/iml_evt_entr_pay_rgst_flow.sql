/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_entr_pay_rgst_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_entr_pay_rgst_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_entr_pay_rgst_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entr_pay_rgst_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_tm timestamp -- 交易时间
    ,flow_num varchar2(100) -- 流水号
    ,tran_code varchar2(45) -- 交易码
    ,core_tran_code varchar2(45) -- 核心交易码
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,bank_int_flg varchar2(10) -- 行内标志
    ,origi_bank_no varchar2(100) -- 发起行行号
    ,payer_open_dept_id varchar2(100) -- 付款人开户行部门编号
    ,payer_acct_num varchar2(100) -- 付款人账号
    ,payer_name varchar2(150) -- 付款人名称
    ,pay_bank_name varchar2(150) -- 付款行名称
    ,recv_bank_no varchar2(100) -- 收款行行号
    ,recver_acct_num varchar2(100) -- 收款人账号
    ,recver_name varchar2(150) -- 收款人名称
    ,recv_bank_name varchar2(150) -- 收款行名称
    ,money_usage_descb varchar2(150) -- 款项用途描述
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,dubil_id varchar2(100) -- 借据编号
    ,stop_pay_dt date -- 止付日期
    ,stop_pay_flow_num varchar2(100) -- 止付流水号
    ,core_tran_dt date -- 核心交易日期
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,init_tran_dt date -- 原交易日期
    ,init_flow_num varchar2(100) -- 原流水号
    ,return_code varchar2(45) -- 返回码
    ,return_info varchar2(750) -- 返回信息
    ,prod_cd varchar2(30) -- 产品代码
    ,acct_ety_code varchar2(45) -- 会计分录编码
    ,chn_cd varchar2(30) -- 渠道代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_entr_pay_rgst_flow to ${icl_schema};
grant select on ${iml_schema}.evt_entr_pay_rgst_flow to ${idl_schema};
grant select on ${iml_schema}.evt_entr_pay_rgst_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_entr_pay_rgst_flow is '受托支付业务登记流水';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.core_tran_code is '核心交易码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.bank_int_flg is '行内标志';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.origi_bank_no is '发起行行号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.payer_open_dept_id is '付款人开户行部门编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.payer_acct_num is '付款人账号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.pay_bank_name is '付款行名称';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.recv_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.money_usage_descb is '款项用途描述';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.stop_pay_dt is '止付日期';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.stop_pay_flow_num is '止付流水号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.init_flow_num is '原流水号';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.return_info is '返回信息';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.prod_cd is '产品代码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.acct_ety_code is '会计分录编码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_entr_pay_rgst_flow.etl_timestamp is 'ETL处理时间戳';
