/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_adac_ind_ranking_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_adac_ind_ranking_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_adac_ind_ranking_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_adac_ind_ranking_dtl(
    curr_no varchar2(10) -- 币种编号
    ,curr_name varchar2(200) -- 币种名称
    ,index_no varchar2(60) -- 指标编号
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(50) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,super_org_no varchar2(60) -- 上级机构编号
    ,dimen_obj_id varchar2(50) -- 维度对象编号
    ,dimen_obj_name varchar2(200) -- 维度对象名称
    ,measure_no varchar2(60) -- 度量编号
    ,index_measure varchar2(200) -- 度量名称
    ,index_value number(38,8) -- 指标值
    ,rate_up_day number(38,8) -- 较上日
    ,rate_up_day_per number(38,8) -- 较上日百分比
    ,rate_last_month number(38,8) -- 较上月
    ,rate_last_month_per number(38,8) -- 较上月百分比
    ,rate_last_year number(38,8) -- 较上年
    ,rate_last_year_per number(38,8) -- 较上年百分比
    ,rate_last_period number(38,8) -- 较上年同期
    ,rate_last_period_per number(38,8) -- 较上年同期百分比
    ,index_ranking number(10) -- 排名
    ,ratio_index number(38,8) -- 占比
    ,ranking_dimen_id varchar2(60) -- 排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name varchar2(200) -- 排行维度名称
    ,unit varchar2(200) -- 单位
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
grant select on ${idl_schema}.mc_adac_ind_ranking_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_adac_ind_ranking_dtl is '管理会计指标排行明细';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.curr_no is '币种编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.curr_name is '币种名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.index_no is '指标编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.index_name is '指标名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.org_no is '机构编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.org_name is '机构名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.super_org_no is '上级机构编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.dimen_obj_id is '维度对象编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.dimen_obj_name is '维度对象名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.measure_no is '度量编号';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.index_measure is '度量名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.index_value is '指标值';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_up_day is '较上日';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_up_day_per is '较上日百分比';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_month is '较上月';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_month_per is '较上月百分比';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_year is '较上年';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_year_per is '较上年百分比';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_period is '较上年同期';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.rate_last_period_per is '较上年同期百分比';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.index_ranking is '排名';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.ratio_index is '占比';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.ranking_dimen_id is '排行维度编号(001分行002支行团队003客户经理004产品)';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.ranking_dimen_name is '排行维度名称';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.unit is '单位';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_adac_ind_ranking_dtl.etl_timestamp is 'ETL处理时间戳';