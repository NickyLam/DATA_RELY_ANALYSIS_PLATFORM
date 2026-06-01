/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_t_ghbr_system
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_t_ghbr_system
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_t_ghbr_system purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_t_ghbr_system(
    id number(18,0) -- 
    ,system_code varchar2(50) -- 
    ,system_name varchar2(100) -- 
    ,serial_number number(18,0) -- 
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
grant select on ${itl_schema}.itl_edw_orws_t_ghbr_system to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_t_ghbr_system is '系统';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.system_code is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.system_name is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.serial_number is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_system.etl_timestamp is 'ETL处理时间戳';