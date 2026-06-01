/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_bank_fact
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_bank_fact
whenever sqlerror continue none;
drop table ${idl_schema}.mc_bank_fact purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_bank_fact(
    etl_dt date -- ETL处理日期
    ,index_no VARCHAR2(60) -- 指标编码
    ,index_name VARCHAR2(200) -- 指标名称
    ,org_no VARCHAR2(60) -- 机构编码
    ,org_name VARCHAR2(200) -- 机构名称
    ,super_org_no VARCHAR2(60) -- 上级机构编码
    ,org_sort VARCHAR2(30) -- 机构分类
    ,curr_no VARCHAR2(10) -- 币种编号
    ,curr_name VARCHAR2(200) -- 币种名称
    ,index_value NUMBER(38,8) -- 指标值
    ,accu_index_value_m NUMBER(38,8) -- 当月累计
    ,accu_index_value_y NUMBER(38,8) -- 当年累计
    ,rate_up_day NUMBER(38,8) -- 比上日
    ,rate_last_month NUMBER(38,8) -- 比上月
    ,rate_last_year NUMBER(38,8) -- 比上年
    ,rate_last_period NUMBER(38,8) -- 同比
    ,rate_up_day_per NUMBER(38,8) -- 比上日百分比
    ,rate_last_month_per NUMBER(38,8) -- 比上月百分比
    ,rate_last_year_per NUMBER(38,8) -- 比上年百分比
    ,rate_last_period_per NUMBER(38,8) -- 同比百分比
    ,index_ranking NUMBER(10,0) -- 当前排名
    ,index_ranking_cha NUMBER(10,0) -- 排名变动
    ,index_value_avg NUMBER(38,8) -- 均值
    ,index_value_limit NUMBER(38,8) -- 阀值
    ,ratio_index NUMBER(38,8) -- 结构占比
    ,ratio_org NUMBER(38,8) -- 分行贡献度
    ,unit VARCHAR2(10) -- 单位
    ,frequency VARCHAR2(10) -- 频度
    ,measure_no VARCHAR2(60) -- 度量编号
    ,source_sys  VARCHAR2(60)  ---来源表 
    ,index_measure VARCHAR2(200) -- 度量名称
    ,org_type VARCHAR2(50) -- 机构类别
    ,first_name VARCHAR2(200) -- 一级分类名称
    ,second_name VARCHAR2(200) -- 二级分类名称
    ,third_name VARCHAR2(200) -- 三级分类名称
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)
subpartition by list(source_sys)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    
)
storage (initial 128k next 128k)
compress ${option_switch} for query high
nologging
;


create index wind_date_index   on  mc_bank_fact(etl_dt desc) ;
create index wind_index_index  on  mc_bank_fact(index_no asc) ;
create index wind_org_index    on  mc_bank_fact(org_no asc) ;
create index wind_curr_index   on  mc_bank_fact(curr_no asc) ;
create index wind_all_index    on  mc_bank_fact(etl_dt desc,index_no asc,org_no asc,curr_no asc) ;

-- grant
-- comment
comment on table ${idl_schema}.mc_bank_fact is '万德指标事实表';
comment on column ${idl_schema}.mc_bank_fact.index_no is '指标编码';
comment on column ${idl_schema}.mc_bank_fact.index_name is '指标名称';
comment on column ${idl_schema}.mc_bank_fact.org_no is '机构编码';
comment on column ${idl_schema}.mc_bank_fact.org_name is '机构名称';
comment on column ${idl_schema}.mc_bank_fact.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mc_bank_fact.org_sort is '机构分类';
comment on column ${idl_schema}.mc_bank_fact.curr_no is '币种编号';
comment on column ${idl_schema}.mc_bank_fact.curr_name is '币种名称';
comment on column ${idl_schema}.mc_bank_fact.index_value is '指标值';
comment on column ${idl_schema}.mc_bank_fact.accu_index_value_m is '当月累计';
comment on column ${idl_schema}.mc_bank_fact.accu_index_value_y is '当年累计';
comment on column ${idl_schema}.mc_bank_fact.rate_up_day is '比上日';
comment on column ${idl_schema}.mc_bank_fact.rate_last_month is '比上月';
comment on column ${idl_schema}.mc_bank_fact.rate_last_year is '比上年';
comment on column ${idl_schema}.mc_bank_fact.rate_last_period is '同比';
comment on column ${idl_schema}.mc_bank_fact.rate_up_day_per is '比上日百分比';
comment on column ${idl_schema}.mc_bank_fact.rate_last_month_per is '比上月百分比';
comment on column ${idl_schema}.mc_bank_fact.rate_last_year_per is '比上年百分比';
comment on column ${idl_schema}.mc_bank_fact.rate_last_period_per is '同比百分比';
comment on column ${idl_schema}.mc_bank_fact.index_ranking is '当前排名';
comment on column ${idl_schema}.mc_bank_fact.index_ranking_cha is '排名变动';
comment on column ${idl_schema}.mc_bank_fact.index_value_avg is '均值';
comment on column ${idl_schema}.mc_bank_fact.index_value_limit is '阀值';
comment on column ${idl_schema}.mc_bank_fact.ratio_index is '结构占比';
comment on column ${idl_schema}.mc_bank_fact.ratio_org is '分行贡献度';
comment on column ${idl_schema}.mc_bank_fact.unit is '单位';
comment on column ${idl_schema}.mc_bank_fact.frequency is '频度';
comment on column ${idl_schema}.mc_bank_fact.measure_no is '度量编号';
comment on column ${idl_schema}.mc_bank_fact.index_measure is '度量名称';
comment on column ${idl_schema}.mc_bank_fact.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_bank_fact.org_type is '机构类别';
comment on column ${idl_schema}.mc_bank_fact.first_name is '一级分类名称';
comment on column ${idl_schema}.mc_bank_fact.second_name is '二级分类名称';
comment on column ${idl_schema}.mc_bank_fact.third_name is '三级分类名称';
comment on column ${idl_schema}.mc_bank_fact.etl_timestamp is 'ETL处理时间戳';