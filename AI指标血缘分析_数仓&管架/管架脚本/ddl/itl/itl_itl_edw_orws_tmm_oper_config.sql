/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_tmm_oper_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_tmm_oper_config
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_tmm_oper_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_tmm_oper_config(
    id number(18,0) -- 
    ,model_id number(18,0) -- 
    ,model_group number(18,0) -- 
    ,warn_level number(18,0) -- 
    ,is_auto number(2,0) -- 
    ,auto_description varchar2(2000) -- 
    ,auto_emp_id number(18,0) -- 
    ,power_value varchar2(100) -- 
    ,bizinfo_template varchar2(2000) -- 
    ,owner_organ_id number(18,0) -- 
    ,risk_level number(1,0) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${itl_schema}.itl_edw_orws_tmm_oper_config to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_tmm_oper_config is '模型业务信息配置';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.model_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.model_group is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.warn_level is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.is_auto is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.auto_description is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.auto_emp_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.power_value is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.bizinfo_template is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.owner_organ_id is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.risk_level is '';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_tmm_oper_config.etl_timestamp is 'ETL处理时间戳';