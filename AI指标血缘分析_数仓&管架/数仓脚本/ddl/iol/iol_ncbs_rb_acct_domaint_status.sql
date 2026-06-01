/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_domaint_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_domaint_status
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_domaint_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_domaint_status(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,domaint_status varchar2(3) -- 变更后状态
    ,mth_non_op varchar2(3) -- 变更月基准
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,max_bal number(17,2) -- 最大余额
    ,doss_day varchar2(2) -- 自动转久悬日
    ,out_day varchar2(2) -- 自动转营业外日
    ,out_mth_op varchar2(2) -- 自动转营业外间隔月份
    ,doss_mth_op varchar2(2) -- 自动转久悬间隔月份
    ,dormant_day varchar2(2) -- 自动转睡眠日
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
grant select on ${iol_schema}.ncbs_rb_acct_domaint_status to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_domaint_status to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_domaint_status to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_domaint_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_domaint_status is '账户转不动户参数表';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.domaint_status is '变更后状态';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.mth_non_op is '变更月基准';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.max_bal is '最大余额';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.doss_day is '自动转久悬日';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.out_day is '自动转营业外日';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.out_mth_op is '自动转营业外间隔月份';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.doss_mth_op is '自动转久悬间隔月份';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.dormant_day is '自动转睡眠日';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_domaint_status.etl_timestamp is 'ETL处理时间戳';
