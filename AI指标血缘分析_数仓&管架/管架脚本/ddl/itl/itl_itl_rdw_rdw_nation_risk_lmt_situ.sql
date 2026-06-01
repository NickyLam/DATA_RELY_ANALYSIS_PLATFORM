/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_rdw_rdw_nation_risk_lmt_situ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ
whenever sqlerror continue none;
drop table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ(
    nation_name varchar2(200) -- 国别名称
    ,rating_rest varchar2(20) -- 风险评级
    ,lmt_ctrl_target_val number(33,4) -- 限制目标值
    ,currt_bal number(33,4) -- 当前余额
    ,comp_last_year number(33,4) -- 对比上年末
    ,comp_last_qua number(33,4) -- 对比上季末
    ,comp_last_month number(33,4) -- 对比上月末
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
grant select on ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ is '国别风险限额情况';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.nation_name is '国别名称';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.rating_rest is '风险评级';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.lmt_ctrl_target_val is '限制目标值';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.currt_bal is '当前余额';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.comp_last_year is '对比上年末';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.comp_last_qua is '对比上季末';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.comp_last_month is '对比上月末';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_rdw_rdw_nation_risk_lmt_situ.etl_timestamp is 'ETL处理时间戳';
