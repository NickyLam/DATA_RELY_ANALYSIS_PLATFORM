/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_indv_e_acct_pay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,pay_id varchar2(60) -- 支付编号
    ,fin_acct_tran_dtl_id varchar2(60) -- 金融账户交易明细编号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,init_pay_id varchar2(60) -- 原支付编号
    ,payment_flow_num varchar2(60) -- 前台流水号
    ,pay_type_cd varchar2(20) -- 支付类型代码
    ,mode_pay_type_cd varchar2(30) -- 支付方式类型代码
    ,from_mem_cd varchar2(20) -- 自会员代码
    ,status_cd varchar2(20) -- 状态代码
    ,mode_pay_flg varchar2(10) -- 支付方式标志
    ,curr_cd varchar2(20) -- 币种代码
    ,tran_kind_cd varchar2(20) -- 交易种类代码
    ,acct_tm timestamp -- 账务时间
    ,tran_tm timestamp -- 交易时间
    ,tran_amt number(30,2) -- 交易金额
    ,actl_amt number(30,2) -- 实际金额
    ,actl_bal number(30,2) -- 实际余额
    ,aval_bal number(30,2) -- 可用余额
    ,cntpty_acct_num varchar2(60) -- 对方账号
    ,cntpty_acct_name varchar2(500) -- 对方户名称
    ,cntpty_acct_open_bank_num varchar2(60) -- 对方账户开户行号
    ,cntpty_acct_open_bank_name varchar2(500) -- 对方账户开户行名称
    ,final_update_tm timestamp -- 最后更新时间
    ,remark varchar2(500) -- 备注
    ,memo varchar2(500) -- 摘要
    ,postsc varchar2(500) -- 附言
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_evt_indv_e_acct_pay_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_indv_e_acct_pay_dtl is '个人电子账户支付明细';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.pay_id is '支付编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.fin_acct_tran_dtl_id is '金融账户交易明细编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.prod_acct_id is '产品账户编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.init_pay_id is '原支付编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.payment_flow_num is '前台流水号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.pay_type_cd is '支付类型代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.mode_pay_type_cd is '支付方式类型代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.from_mem_cd is '自会员代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.status_cd is '状态代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.mode_pay_flg is '支付方式标志';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.tran_kind_cd is '交易种类代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.acct_tm is '账务时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.actl_amt is '实际金额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.actl_bal is '实际余额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.aval_bal is '可用余额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.cntpty_acct_num is '对方账号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.cntpty_acct_name is '对方户名称';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.cntpty_acct_open_bank_num is '对方账户开户行号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.cntpty_acct_open_bank_name is '对方账户开户行名称';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.final_update_tm is '最后更新时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.remark is '备注';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.memo is '摘要';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.postsc is '附言';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_pay_dtl.etl_timestamp is '数据处理时间';
