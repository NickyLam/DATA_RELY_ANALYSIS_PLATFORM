/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_ghbr_system
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_ghbr_system
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_ghbr_system purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_ghbr_system(
    id number(18,0) -- 
    ,system_code varchar2(75) -- 
    ,system_name varchar2(150) -- 
    ,serial_number number(18,0) -- 
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
grant select on ${iol_schema}.orws_t_ghbr_system to ${iml_schema};
grant select on ${iol_schema}.orws_t_ghbr_system to ${icl_schema};
grant select on ${iol_schema}.orws_t_ghbr_system to ${idl_schema};
grant select on ${iol_schema}.orws_t_ghbr_system to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_ghbr_system is '系统代码表';
comment on column ${iol_schema}.orws_t_ghbr_system.id is '';
comment on column ${iol_schema}.orws_t_ghbr_system.system_code is '';
comment on column ${iol_schema}.orws_t_ghbr_system.system_name is '';
comment on column ${iol_schema}.orws_t_ghbr_system.serial_number is '';
comment on column ${iol_schema}.orws_t_ghbr_system.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_ghbr_system.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_ghbr_system.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_ghbr_system.etl_timestamp is 'ETL处理时间戳';
