/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbprdmanager
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbprdmanager
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbprdmanager purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdmanager(
    prd_manager varchar2(18) -- 
    ,manager_shortname varchar2(64) -- 
    ,manager_name varchar2(375) -- 
    ,position_code varchar2(30) -- 
    ,position_name varchar2(375) -- 
    ,reg_address varchar2(375) -- 
    ,off_address varchar2(375) -- 
    ,manager varchar2(30) -- 
    ,link_name varchar2(375) -- 
    ,link_method varchar2(90) -- 
    ,hot_line varchar2(45) -- 
    ,web varchar2(375) -- 
    ,risk_level number(22) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,company_code varchar2(12) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbprdmanager to ${iml_schema};
grant select on ${iol_schema}.ifms_tbprdmanager to ${icl_schema};
grant select on ${iol_schema}.ifms_tbprdmanager to ${idl_schema};
grant select on ${iol_schema}.ifms_tbprdmanager to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbprdmanager is '产品管理人表';
comment on column ${iol_schema}.ifms_tbprdmanager.prd_manager is '';
comment on column ${iol_schema}.ifms_tbprdmanager.manager_shortname is '';
comment on column ${iol_schema}.ifms_tbprdmanager.manager_name is '';
comment on column ${iol_schema}.ifms_tbprdmanager.position_code is '';
comment on column ${iol_schema}.ifms_tbprdmanager.position_name is '';
comment on column ${iol_schema}.ifms_tbprdmanager.reg_address is '';
comment on column ${iol_schema}.ifms_tbprdmanager.off_address is '';
comment on column ${iol_schema}.ifms_tbprdmanager.manager is '';
comment on column ${iol_schema}.ifms_tbprdmanager.link_name is '';
comment on column ${iol_schema}.ifms_tbprdmanager.link_method is '';
comment on column ${iol_schema}.ifms_tbprdmanager.hot_line is '';
comment on column ${iol_schema}.ifms_tbprdmanager.web is '';
comment on column ${iol_schema}.ifms_tbprdmanager.risk_level is '';
comment on column ${iol_schema}.ifms_tbprdmanager.reserve1 is '';
comment on column ${iol_schema}.ifms_tbprdmanager.reserve2 is '';
comment on column ${iol_schema}.ifms_tbprdmanager.company_code is '';
comment on column ${iol_schema}.ifms_tbprdmanager.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbprdmanager.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbprdmanager.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbprdmanager.etl_timestamp is 'ETL处理时间戳';
