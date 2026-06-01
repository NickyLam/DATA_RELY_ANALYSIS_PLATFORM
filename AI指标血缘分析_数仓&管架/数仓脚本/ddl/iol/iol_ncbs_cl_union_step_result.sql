/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_union_step_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_union_step_result
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_union_step_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_union_step_result(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
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
grant select on ${iol_schema}.ncbs_cl_union_step_result to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_union_step_result to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_union_step_result to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_union_step_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_union_step_result is '联合步骤处理结果表';
comment on column ${iol_schema}.ncbs_cl_union_step_result.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_union_step_result.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_union_step_result.company is '法人';
comment on column ${iol_schema}.ncbs_cl_union_step_result.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_cl_union_step_result.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_union_step_result.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_union_step_result.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_union_step_result.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_union_step_result.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_union_step_result.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_union_step_result.etl_timestamp is 'ETL处理时间戳';
