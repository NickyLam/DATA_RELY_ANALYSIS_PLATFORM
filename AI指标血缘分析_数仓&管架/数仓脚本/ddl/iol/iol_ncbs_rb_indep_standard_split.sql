/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_indep_standard_split
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_indep_standard_split
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_indep_standard_split purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_indep_standard_split(
    agg number(38,2) -- 积数
    ,client_no varchar2(16) -- 客户编号
    ,days number(5) -- 天数
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,retry_flag varchar2(1) -- 是否重算
    ,int_class varchar2(6) -- 利息分类
    ,accr_date date -- 计提日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,real_rate number(15,8) -- 执行利率
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_indep_standard_split to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_indep_standard_split to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_indep_standard_split to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_indep_standard_split to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_indep_standard_split is '智能通知存款达标分段表';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.agg is '积数';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.days is '天数';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.company is '法人';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.accr_date is '计提日期';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_indep_standard_split.etl_timestamp is 'ETL处理时间戳';
