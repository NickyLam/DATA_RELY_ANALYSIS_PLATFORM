/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_acct_class_stat_rept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_acct_class_stat_rept
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_acct_class_stat_rept purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_acct_class_stat_rept(
    etl_dt date -- 数据日期
    ,rept_dt date --报表周期(月)
    ,index_no varchar2(200) -- 指标编码
    ,index_name varchar2(600) -- 指标名称
    ,org_no varchar2(60) -- 机构编码
    ,org_name varchar2(200) -- 机构名称
    ,super_org_no varchar2(6) -- 上级机构编码
    ,bu_type varchar2(30) -- 业务品种
    ,td_index_value_d number(38,8) -- 当日日累计
    ,td_index_value_m number(38,8) -- 当日月累计
    ,td_index_value_q number(38,8) -- 当日季累计
    ,td_index_value_y number(38,8) -- 当日年累计
    ,td_rate_up_day number(38,8) -- 当日比上日
    ,td_rate_last_month number(38,8) -- 当日比上月
    ,td_rate_last_quater number(38,8) -- 当日比上季
    ,td_rate_last_year number(38,8) -- 当日比上年
    ,td_rate_up_day_per number(38,8) -- 当日比上日百分比
    ,td_rate_last_month_per number(38,8) -- 当日比上月百分比
    ,td_rate_last_quater_per number(38,8) -- 当日比上季百分比
    ,td_rate_last_year_per number(38,8) -- 当日比上年百分比
    ,td_day_ratio_index number(38,8) -- 当日日占比
    ,td_mon_ratio_index number(38,8) -- 当日月占比
    ,td_quar_ratio_index number(38,8) -- 当日季占比
    ,td_year_ratio_index number(38,8) -- 当日年占比
    ,currt_index_value_d number(38,8) -- 当期日累计
    ,currt_index_value_m number(38,8) -- 当期月累计
    ,currt_index_value_q number(38,8) -- 当期季累计
    ,currt_index_value_y number(38,8) -- 当期年累计
    ,currt_rate_up_day number(38,8) -- 当期比上日
    ,currt_rate_last_month number(38,8) -- 当期比上月
    ,currt_rate_last_quater number(38,8) -- 当期比上季
    ,currt_rate_last_year number(38,8) -- 当期比上年
    ,currt_rate_up_day_per number(38,8) -- 当期比上日百分比
    ,currt_rate_last_month_per number(38,8) -- 当期比上月百分比
    ,currt_rate_last_quater_per number(38,8) -- 当期比上季百分比
    ,currt_rate_last_year_per number(38,8) -- 当期比上年百分比
    ,currt_day_ratio_index number(38,8) -- 当期日占比
    ,currt_mon_ratio_index number(38,8) -- 当期月占比
    ,currt_quar_ratio_index number(38,8) -- 当期季占比
    ,currt_year_ratio_index number(38,8) -- 当期年占比
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
    
)

partition by list(rept_dt)(
    partition p_190001 values (to_date('190001','yyyymm'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_acct_class_stat_rept to ${idl_schema};

-- comment
comment on table ${idl_schema}.mcyy_acct_class_stat_rept is '账户类报表落地表';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.rept_dt is '报表周期(月)';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.org_no is '机构编码';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.org_name is '机构名称';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.bu_type is '业务品种';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_index_value_d is '当日日累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_index_value_m is '当日月累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_index_value_q is '当日季累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_index_value_y is '当日年累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_up_day is '当日比上日';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_month is '当日比上月';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_quater is '当日比上季';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_year is '当日比上年';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_up_day_per is '当日比上日百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_month_per is '当日比上月百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_quater_per is '当日比上季百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_rate_last_year_per is '当日比上年百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_day_ratio_index is '当日日占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_mon_ratio_index is '当日月占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_quar_ratio_index is '当日季占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.td_year_ratio_index is '当日年占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_index_value_d is '当期日累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_index_value_m is '当期月累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_index_value_q is '当期季累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_index_value_y is '当期年累计';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_up_day is '当期比上日';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_month is '当期比上月';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_quater is '当期比上季';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_year is '当期比上年';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_up_day_per is '当期比上日百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_month_per is '当期比上月百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_quater_per is '当期比上季百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_rate_last_year_per is '当期比上年百分比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_day_ratio_index is '当期日占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_mon_ratio_index is '当期月占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_quar_ratio_index is '当期季占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.currt_year_ratio_index is '当期年占比';
comment on column ${idl_schema}.mcyy_acct_class_stat_rept.etl_timestamp is 'ETL处理时间戳';
