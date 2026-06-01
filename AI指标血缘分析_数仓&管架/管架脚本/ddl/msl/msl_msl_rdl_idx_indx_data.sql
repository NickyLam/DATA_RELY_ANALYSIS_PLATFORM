/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_rdl_idx_indx_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_rdl_idx_indx_data
whenever sqlerror continue none;
drop table ${msl_schema}.msl_rdl_idx_indx_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_rdl_idx_indx_data(
    INDX_NO VARCHAR2(60)
    ,ORG_NO VARCHAR2(60)
    ,CURR_CD VARCHAR2(10)
    ,INDX_DIMEN_NO VARCHAR2(10)
    ,INDX_DIMEN_CD VARCHAR2(10)
    ,STAT_PED_CD VARCHAR2(10)
    ,INDX_VAL NUMBER(38,6)
    ,COMP_EAR_YEAR_VAL NUMBER(18,6)
    ,COMP_SAME_TERM_VAL NUMBER(18,6)
    ,COMP_LAST_MON_VAL NUMBER(18,6)
    ,COMP_LAST_QUA_VAL NUMBER(18,6)
    ,ETL_DT DATE
    ,ETL_TIMESTAMP TIMESTAMP(6)
    ,BIZ_STRIP_LINE_CD VARCHAR2(64)
    ,INDEX_MEASURE VARCHAR2(64)
)
storage (initial 1024k next 1024k)
compress nologging
;


-- comment
comment on table ${msl_schema}.msl_rdl_idx_indx_data is 'RDL_指标_指标数据';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.INDX_NO is '指标编号';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.ORG_NO is '机构编号';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.CURR_CD is '币种代码';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.INDX_DIMEN_NO is '指标维度编号';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.INDX_DIMEN_CD is '指标维度代码';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.STAT_PED_CD is '统计周期代码';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.INDX_VAL is '指标值';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.COMP_EAR_YEAR_VAL is '与年初比';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.COMP_SAME_TERM_VAL is '与同期比';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.COMP_LAST_MON_VAL is '与上月比';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.COMP_LAST_QUA_VAL is '与上季比';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.ETL_TIMESTAMP is 'ETL处理时间戳';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.BIZ_STRIP_LINE_CD is '业务条线代码';
comment on column ${msl_schema}.msl_rdl_idx_indx_data.INDEX_MEASURE is '指标度量';
