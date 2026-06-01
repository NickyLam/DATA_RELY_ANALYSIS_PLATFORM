/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bopcty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bopcty
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bopcty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bopcty(
    inr varchar2(12) -- 
    ,fultxt varchar2(150) -- 
    ,txt varchar2(120) -- 
    ,ver varchar2(6) -- 
    ,cod varchar2(5) -- 
    ,numcod varchar2(5) -- 
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
grant select on ${iol_schema}.isbs_bopcty to ${iml_schema};
grant select on ${iol_schema}.isbs_bopcty to ${icl_schema};
grant select on ${iol_schema}.isbs_bopcty to ${idl_schema};
grant select on ${iol_schema}.isbs_bopcty to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bopcty is '国家编号对照表';
comment on column ${iol_schema}.isbs_bopcty.inr is '';
comment on column ${iol_schema}.isbs_bopcty.fultxt is '';
comment on column ${iol_schema}.isbs_bopcty.txt is '';
comment on column ${iol_schema}.isbs_bopcty.ver is '';
comment on column ${iol_schema}.isbs_bopcty.cod is '';
comment on column ${iol_schema}.isbs_bopcty.numcod is '';
comment on column ${iol_schema}.isbs_bopcty.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bopcty.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bopcty.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bopcty.etl_timestamp is 'ETL处理时间戳';
