/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbdict
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbdict
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbdict purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbdict(
    hs_key varchar2(20) -- 
    ,key_name varchar2(250) -- 
    ,val varchar2(256) -- 
    ,prompt varchar2(500) -- 
    ,kernal_flag varchar2(8) -- 
    ,belong_type varchar2(16) -- 
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
grant select on ${iol_schema}.ifms_tbdict to ${iml_schema};
grant select on ${iol_schema}.ifms_tbdict to ${icl_schema};
grant select on ${iol_schema}.ifms_tbdict to ${idl_schema};
grant select on ${iol_schema}.ifms_tbdict to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbdict is '';
comment on column ${iol_schema}.ifms_tbdict.hs_key is '';
comment on column ${iol_schema}.ifms_tbdict.key_name is '';
comment on column ${iol_schema}.ifms_tbdict.val is '';
comment on column ${iol_schema}.ifms_tbdict.prompt is '';
comment on column ${iol_schema}.ifms_tbdict.kernal_flag is '';
comment on column ${iol_schema}.ifms_tbdict.belong_type is '';
comment on column ${iol_schema}.ifms_tbdict.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbdict.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbdict.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbdict.etl_timestamp is 'ETL处理时间戳';
