/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_tmm_commissioning_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_tmm_commissioning_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_tmm_commissioning_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_tmm_commissioning_info(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,RECORD_ID NUMBER(18,0)
    ,COMMISSIONING_DATE TIMESTAMP(6)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_tmm_commissioning_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_tmm_commissioning_info is '生产运行任务';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.RECORD_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.COMMISSIONING_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_commissioning_info.ID_MARK is '增删标志';
