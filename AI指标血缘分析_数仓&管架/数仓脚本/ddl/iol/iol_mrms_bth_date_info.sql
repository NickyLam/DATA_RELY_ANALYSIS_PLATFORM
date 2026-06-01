/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_bth_date_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_bth_date_info
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_bth_date_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_bth_date_info(
    hostdt varchar2(12) -- 核心日期
    ,iswork varchar2(2) -- 是否节假日 1-是 0-否
    ,reserve varchar2(75) -- 保留区域
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_bth_date_info to ${iml_schema};
grant select on ${iol_schema}.mrms_bth_date_info to ${icl_schema};
grant select on ${iol_schema}.mrms_bth_date_info to ${idl_schema};
grant select on ${iol_schema}.mrms_bth_date_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_bth_date_info is '核心节假日信息表';
comment on column ${iol_schema}.mrms_bth_date_info.hostdt is '核心日期';
comment on column ${iol_schema}.mrms_bth_date_info.iswork is '是否节假日 1-是 0-否';
comment on column ${iol_schema}.mrms_bth_date_info.reserve is '保留区域';
comment on column ${iol_schema}.mrms_bth_date_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mrms_bth_date_info.etl_timestamp is 'ETL处理时间戳';
