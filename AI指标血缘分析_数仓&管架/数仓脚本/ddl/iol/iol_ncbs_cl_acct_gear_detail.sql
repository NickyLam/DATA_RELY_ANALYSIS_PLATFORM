/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_gear_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_gear_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_gear_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_gear_detail(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,term_type varchar2(1) -- 期限单位
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_acct_gear_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_gear_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_gear_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_gear_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_gear_detail is '靠档利率明细表';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.start_days is '起始相差天数';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.end_days is '结束日';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.cross_period_rate is '跨月/季利率';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.period_rate is '不跨月/季利率';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_gear_detail.etl_timestamp is 'ETL处理时间戳';
