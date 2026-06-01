/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_rdw_rdw_nation_risk_lmt_situ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ
whenever sqlerror continue none;
drop table ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ(
    ETL_DT DATE
    ,NATION_NAME VARCHAR2(200)
    ,RATING_REST VARCHAR2(20)
    ,LMT_CTRL_TARGET_VAL NUMBER(33,4)
    ,CURRT_BAL NUMBER(33,4)
    ,COMP_LAST_YEAR NUMBER(33,4)
    ,COMP_LAST_QUA NUMBER(33,4)
    ,COMP_LAST_MONTH NUMBER(33,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ is '国别风险限额情况';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.NATION_NAME is '国别名称';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.RATING_REST is '风险评级';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.LMT_CTRL_TARGET_VAL is '限制目标值';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.CURRT_BAL is '当前余额';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.COMP_LAST_YEAR is '对比上年末';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.COMP_LAST_QUA is '对比上季末';
comment on column ${msl_schema}.msl_rdw_rdw_nation_risk_lmt_situ.COMP_LAST_MONTH is '对比上月末';
