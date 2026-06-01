/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_tmm_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_tmm_record
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_tmm_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_tmm_record(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,MODEL_ID NUMBER(18,0)
    ,BIZ_DATE TIMESTAMP(6)
    ,EXEC_STATUS NUMBER(18,0)
    ,CREATE_TIME TIMESTAMP(6)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_tmm_record to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_tmm_record is '模型运行记录';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.MODEL_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.BIZ_DATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.EXEC_STATUS is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.CREATE_TIME is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_record.ID_MARK is '增删标志';
