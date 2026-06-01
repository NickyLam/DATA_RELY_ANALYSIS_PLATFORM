/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondfundusing
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondfundusing
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondfundusing purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondfundusing(
    object_id varchar2(150) -- 
    ,s_info_windcode varchar2(60) -- 
    ,sec_id varchar2(60) -- 
    ,start_dt_ora varchar2(12) -- 
    ,end_dt_ora varchar2(12) -- 
    ,cur_sign number(1,0) -- 
    ,funduse varchar2(4000) -- 
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_cbondfundusing to ${iml_schema};
grant select on ${iol_schema}.wind_cbondfundusing to ${icl_schema};
grant select on ${iol_schema}.wind_cbondfundusing to ${idl_schema};
grant select on ${iol_schema}.wind_cbondfundusing to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondfundusing is '中国债券募集资金用途';
comment on column ${iol_schema}.wind_cbondfundusing.object_id is '';
comment on column ${iol_schema}.wind_cbondfundusing.s_info_windcode is '';
comment on column ${iol_schema}.wind_cbondfundusing.sec_id is '';
comment on column ${iol_schema}.wind_cbondfundusing.start_dt_ora is '';
comment on column ${iol_schema}.wind_cbondfundusing.end_dt_ora is '';
comment on column ${iol_schema}.wind_cbondfundusing.cur_sign is '';
comment on column ${iol_schema}.wind_cbondfundusing.funduse is '';
comment on column ${iol_schema}.wind_cbondfundusing.opdate is '';
comment on column ${iol_schema}.wind_cbondfundusing.opmode is '';
comment on column ${iol_schema}.wind_cbondfundusing.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondfundusing.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondfundusing.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondfundusing.etl_timestamp is 'ETL处理时间戳';
