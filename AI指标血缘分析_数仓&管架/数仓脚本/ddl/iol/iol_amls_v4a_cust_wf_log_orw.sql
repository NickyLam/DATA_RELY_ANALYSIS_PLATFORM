/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_v4a_cust_wf_log_orw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_v4a_cust_wf_log_orw
whenever sqlerror continue none;
drop table ${iol_schema}.amls_v4a_cust_wf_log_orw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_v4a_cust_wf_log_orw(
    tr_tm varchar2(20) -- 交易时间
    ,tr_org_id varchar2(20) -- 交易机构
    ,post_name varchar2(500) -- 经办业务人员岗位
    ,opr_user varchar2(200) -- 用户号
    ,opr_user_name varchar2(500) -- 用户姓名
    ,opr_id varchar2(200) -- 授权柜员号
    ,opr_name varchar2(500) -- 授权柜员姓名
    ,opr_org_id varchar2(200) -- 授权机构
    ,tr_code varchar2(200) -- 交易码值
    ,tr_name varchar2(500) -- 交易名称
    ,tr_begin_tm date -- 交易开始时间
    ,tr_end_tm date -- 交易结束时间
    ,tr_no varchar2(500) -- 业务流水号
    ,system varchar2(100) -- 系统
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
grant select on ${iol_schema}.amls_v4a_cust_wf_log_orw to ${iml_schema};
grant select on ${iol_schema}.amls_v4a_cust_wf_log_orw to ${icl_schema};
grant select on ${iol_schema}.amls_v4a_cust_wf_log_orw to ${idl_schema};
grant select on ${iol_schema}.amls_v4a_cust_wf_log_orw to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_v4a_cust_wf_log_orw is '';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_tm is '交易时间';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_org_id is '交易机构';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.post_name is '经办业务人员岗位';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.opr_user is '用户号';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.opr_user_name is '用户姓名';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.opr_id is '授权柜员号';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.opr_name is '授权柜员姓名';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.opr_org_id is '授权机构';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_code is '交易码值';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_name is '交易名称';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_begin_tm is '交易开始时间';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_end_tm is '交易结束时间';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.tr_no is '业务流水号';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.system is '系统';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_v4a_cust_wf_log_orw.etl_timestamp is 'ETL处理时间戳';
