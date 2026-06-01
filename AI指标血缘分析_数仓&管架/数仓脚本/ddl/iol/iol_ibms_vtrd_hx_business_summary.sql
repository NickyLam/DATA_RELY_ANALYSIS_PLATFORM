/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_hx_business_summary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_hx_business_summary
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_hx_business_summary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_hx_business_summary(
    txn_dt date -- 交易日期
    ,txn_tm varchar2(30) -- 交易时间
    ,blng_org_id varchar2(45) -- 所属机构编码
    ,oper_teller_id varchar2(96) -- 经办柜员编码
    ,oper_teller_name varchar2(150) -- 经办柜员名称
    ,auth_teller_id varchar2(96) -- 授权柜员编码
    ,auth_teller_name varchar2(150) -- 授权柜员名称
    ,txn_num varchar2(15) -- 交易码
    ,txn_desc varchar2(150) -- 交易描述
    ,biz_sys_evt_id varchar2(50) -- 业务系统流水号
    ,bcs_evt_id varchar2(45) -- 核心系统流水号
    ,data_src_cd varchar2(5) -- 系统代码
    ,pay_agt_id varchar2(75) -- 付款账户
    ,rcv_agt_id varchar2(300) -- 收款账户
    ,txn_amt number(31,4) -- 交易金额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_vtrd_hx_business_summary to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_hx_business_summary to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_hx_business_summary to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_hx_business_summary to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_hx_business_summary is '同业业务管理系统-业务量统计';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.txn_dt is '交易日期';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.txn_tm is '交易时间';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.blng_org_id is '所属机构编码';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.oper_teller_id is '经办柜员编码';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.oper_teller_name is '经办柜员名称';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.auth_teller_id is '授权柜员编码';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.txn_num is '交易码';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.txn_desc is '交易描述';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.biz_sys_evt_id is '业务系统流水号';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.bcs_evt_id is '核心系统流水号';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.data_src_cd is '系统代码';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.pay_agt_id is '付款账户';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.rcv_agt_id is '收款账户';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.txn_amt is '交易金额';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_hx_business_summary.etl_timestamp is 'ETL处理时间戳';
