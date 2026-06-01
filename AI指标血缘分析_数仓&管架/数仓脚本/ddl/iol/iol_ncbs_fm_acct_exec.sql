/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_acct_exec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_acct_exec
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_acct_exec purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_acct_exec(
    branch varchar2(12) -- 机构编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,profit_center varchar2(20) -- 利润中心
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_exec_name varchar2(200) -- 客户经理姓名
    ,acct_exec_status varchar2(1) -- 客户经理状态
    ,acct_exec_type varchar2(3) -- 客户经理类型
    ,collat_mgr_ind varchar2(1) -- 是否担保经理
    ,company varchar2(20) -- 法人
    ,manager varchar2(30) -- 主管经理
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,contact_id varchar2(200) -- 联系类型id
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_fm_acct_exec to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_acct_exec to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_acct_exec to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_acct_exec to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_acct_exec is '客户经理表';
comment on column ${iol_schema}.ncbs_fm_acct_exec.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_acct_exec.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_fm_acct_exec.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_fm_acct_exec.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_fm_acct_exec.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_fm_acct_exec.acct_exec_name is '客户经理姓名';
comment on column ${iol_schema}.ncbs_fm_acct_exec.acct_exec_status is '客户经理状态';
comment on column ${iol_schema}.ncbs_fm_acct_exec.acct_exec_type is '客户经理类型';
comment on column ${iol_schema}.ncbs_fm_acct_exec.collat_mgr_ind is '是否担保经理';
comment on column ${iol_schema}.ncbs_fm_acct_exec.company is '法人';
comment on column ${iol_schema}.ncbs_fm_acct_exec.manager is '主管经理';
comment on column ${iol_schema}.ncbs_fm_acct_exec.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_acct_exec.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_fm_acct_exec.contact_id is '联系类型id';
comment on column ${iol_schema}.ncbs_fm_acct_exec.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_acct_exec.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_acct_exec.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_acct_exec.etl_timestamp is 'ETL处理时间戳';
