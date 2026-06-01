/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_tmm_oper_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_tmm_oper_config
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_tmm_oper_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_tmm_oper_config(
    ETL_DT DATE
    ,ID NUMBER(18,0)
    ,MODEL_ID NUMBER(18,0)
    ,MODEL_GROUP NUMBER(18,0)
    ,WARN_LEVEL NUMBER(18,0)
    ,IS_AUTO NUMBER(2,0)
    ,AUTO_DESCRIPTION VARCHAR2(2000)
    ,AUTO_EMP_ID NUMBER(18,0)
    ,POWER_VALUE VARCHAR2(100)
    ,BIZINFO_TEMPLATE VARCHAR2(2000)
    ,OWNER_ORGAN_ID NUMBER(18,0)
    ,RISK_LEVEL NUMBER(1,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_tmm_oper_config to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_tmm_oper_config is '模型业务信息配置';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.MODEL_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.MODEL_GROUP is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.WARN_LEVEL is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.IS_AUTO is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.AUTO_DESCRIPTION is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.AUTO_EMP_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.POWER_VALUE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.BIZINFO_TEMPLATE is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.OWNER_ORGAN_ID is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.RISK_LEVEL is '';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_orws_tmm_oper_config.ID_MARK is '增删标志';
