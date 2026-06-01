/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_t_ghbr_system
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_ghbr_system
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_ghbr_system purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_ghbr_system(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,SYSTEM_CODE VARCHAR2(50)
    ,SYSTEM_NAME VARCHAR2(100)
    ,SERIAL_NUMBER NUMBER(18,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_ghbr_system to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_ghbr_system is '系统';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.SYSTEM_CODE is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.SYSTEM_NAME is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.SERIAL_NUMBER is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_system.ID_MARK is '增删标志';
