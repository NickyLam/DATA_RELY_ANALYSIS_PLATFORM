/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_indv_e_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_indv_e_acct_tran_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_indv_e_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_indv_e_acct_tran_dtl(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_acct_tran_dtl_id varchar2(60) -- 金融账户交易明细编号
    ,init_tran_dtl_id varchar2(60) -- 原交易明细编号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,party_id varchar2(60) -- 当事人编号
    ,pay_id varchar2(60) -- 支付编号
    ,indent_id varchar2(60) -- 订单编号
    ,operr_id varchar2(60) -- 操作人编号
    ,init_chn_id varchar2(60) -- 发起渠道编号
    ,tran_tm timestamp -- 交易时间
    ,acct_tm timestamp -- 账务时间
    ,effect_tm timestamp -- 生效时间
    ,invalid_tm timestamp -- 失效时间
    ,tran_amt number(30,2) -- 交易金额
    ,actl_bal number(30,2) -- 实际余额
    ,aval_bal number(30,2) -- 可用余额
    ,fund_corp_return_order_no varchar2(60) -- 基金公司返回订单号
    ,init_flow_num varchar2(60) -- 发起流水号
    ,status_cd varchar2(20) -- 状态代码
    ,fin_acct_tran_type_cd varchar2(20) -- 金融账户交易类型代码
    ,final_update_tm timestamp -- 最后更新时间
    ,dep_term varchar2(20) -- 存期
    ,memo varchar2(500) -- 摘要
    ,postsc varchar2(500) -- 附言
    ,remark varchar2(500) -- 备注
    ,call_sys_id varchar2(60) -- 调用系统编号
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
grant select on ${idl_schema}.aml_evt_indv_e_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_indv_e_acct_tran_dtl is '个人电子账户交易明细';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.fin_acct_tran_dtl_id is '金融账户交易明细编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.init_tran_dtl_id is '原交易明细编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.prod_acct_id is '产品账户编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.party_id is '当事人编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.pay_id is '支付编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.indent_id is '订单编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.operr_id is '操作人编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.init_chn_id is '发起渠道编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.acct_tm is '账务时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.effect_tm is '生效时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.invalid_tm is '失效时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.actl_bal is '实际余额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.aval_bal is '可用余额';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.fund_corp_return_order_no is '基金公司返回订单号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.init_flow_num is '发起流水号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.status_cd is '状态代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.fin_acct_tran_type_cd is '金融账户交易类型代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.final_update_tm is '最后更新时间';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.dep_term is '存期';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.memo is '摘要';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.postsc is '附言';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.remark is '备注';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.call_sys_id is '调用系统编号';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_indv_e_acct_tran_dtl.etl_timestamp is '数据处理时间';
