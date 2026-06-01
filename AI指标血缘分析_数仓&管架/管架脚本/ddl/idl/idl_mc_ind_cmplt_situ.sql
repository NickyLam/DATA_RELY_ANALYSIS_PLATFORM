/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_ind_cmplt_situ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_ind_cmplt_situ
whenever sqlerror continue none;
drop table ${idl_schema}.mc_ind_cmplt_situ purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_ind_cmplt_situ(
    index_no varchar2(150) -- 指标编号
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(150) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,measure_no varchar2(150) -- 度量编号
    ,index_value number(38,8) -- 指标值
    ,index_value_desc varchar2(200) -- 指标值备注
    ,budget_val varchar2(200) -- 预算值
    ,budget_val_desc varchar2(200) -- 预算值备注
    ,prog_target_val number(38,8) -- 进度目标值
    ,tm_prog_cmplt_rat number(38,8) -- 时间进度完成率
    ,tm_prog_cmplt_rat_desc varchar2(200) -- 时间进度完成率备注
    ,year_cmplt_rat number(38,8) -- 年度完成率
    ,year_cmplt_rat_desc varchar2(200) -- 年度完成率备注
    ,unit varchar2(150) -- 指标单位
    ,reach_std_situ varchar2(150) -- 达标情况
    ,ind_net_incre number(38,8) -- 指标净增值
    ,last_year_base number(38,8) -- 上年基数
    ,m_acm_val number(38,8) -- 月累计值
    ,yoy_val number(38,8) -- 同比值
    ,yoy_chg_lmt number(38,8) -- 同比变动额
    ,yoy_chg_rat number(38,8) -- 同比变动率
    ,chain_val number(38,8) -- 环比值
    ,chain_chg_lmt number(38,8) -- 环比变动额
    ,chain_chg_rat number(38,8) -- 环比变动率
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_ind_cmplt_situ to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_ind_cmplt_situ is '指标完成情况';
comment on column ${idl_schema}.mc_ind_cmplt_situ.index_no is '指标编号';
comment on column ${idl_schema}.mc_ind_cmplt_situ.index_name is '指标名称';
comment on column ${idl_schema}.mc_ind_cmplt_situ.org_no is '机构编号';
comment on column ${idl_schema}.mc_ind_cmplt_situ.org_name is '机构名称';
comment on column ${idl_schema}.mc_ind_cmplt_situ.measure_no is '度量编号';
comment on column ${idl_schema}.mc_ind_cmplt_situ.index_value is '指标值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.index_value_desc is '指标值备注';
comment on column ${idl_schema}.mc_ind_cmplt_situ.budget_val is '预算值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.budget_val_desc is '预算值备注';
comment on column ${idl_schema}.mc_ind_cmplt_situ.prog_target_val is '进度目标值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.tm_prog_cmplt_rat is '时间进度完成率';
comment on column ${idl_schema}.mc_ind_cmplt_situ.tm_prog_cmplt_rat_desc is '时间进度完成率备注';
comment on column ${idl_schema}.mc_ind_cmplt_situ.year_cmplt_rat is '年度完成率';
comment on column ${idl_schema}.mc_ind_cmplt_situ.year_cmplt_rat_desc is '年度完成率备注';
comment on column ${idl_schema}.mc_ind_cmplt_situ.unit is '指标单位';
comment on column ${idl_schema}.mc_ind_cmplt_situ.reach_std_situ is '达标情况';
comment on column ${idl_schema}.mc_ind_cmplt_situ.ind_net_incre is '指标净增值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.last_year_base is '上年基数';
comment on column ${idl_schema}.mc_ind_cmplt_situ.m_acm_val is '月累计值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.yoy_val is '同比值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.yoy_chg_lmt is '同比变动额';
comment on column ${idl_schema}.mc_ind_cmplt_situ.yoy_chg_rat is '同比变动率';
comment on column ${idl_schema}.mc_ind_cmplt_situ.chain_val is '环比值';
comment on column ${idl_schema}.mc_ind_cmplt_situ.chain_chg_lmt is '环比变动额';
comment on column ${idl_schema}.mc_ind_cmplt_situ.chain_chg_rat is '环比变动率';
comment on column ${idl_schema}.mc_ind_cmplt_situ.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_ind_cmplt_situ.etl_timestamp is 'ETL处理时间戳';