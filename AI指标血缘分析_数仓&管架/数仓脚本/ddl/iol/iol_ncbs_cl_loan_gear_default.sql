/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_loan_gear_default
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_loan_gear_default
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_loan_gear_default purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_gear_default(
    client_no varchar2(16) -- 客户编号
    ,term_type varchar2(1) -- 期限单位
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
    ,start_days number(5) -- 起始相差天数
    ,end_days number(5) -- 结束日
    ,cross_period_rate number(15,8) -- 跨月/季利率
    ,period_rate number(15,8) -- 不跨月/季利率
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
grant select on ${iol_schema}.ncbs_cl_loan_gear_default to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_loan_gear_default to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_gear_default to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_gear_default to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_loan_gear_default is '贷款合同靠档利率';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.company is '法人';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.start_days is '起始相差天数';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.end_days is '结束日';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.cross_period_rate is '跨月/季利率';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.period_rate is '不跨月/季利率';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_loan_gear_default.etl_timestamp is 'ETL处理时间戳';
