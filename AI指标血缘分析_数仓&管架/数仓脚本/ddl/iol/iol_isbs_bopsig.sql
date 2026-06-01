/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bopsig
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bopsig
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bopsig purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bopsig(
    dat date -- 
    ,sta varchar2(5) -- 
    ,dblinr varchar2(12) -- 
    ,usr varchar2(12) -- 
    ,tim number(6,4) -- 
    ,inr varchar2(12) -- 
    ,txt varchar2(192) -- 
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
grant select on ${iol_schema}.isbs_bopsig to ${iml_schema};
grant select on ${iol_schema}.isbs_bopsig to ${icl_schema};
grant select on ${iol_schema}.isbs_bopsig to ${idl_schema};
grant select on ${iol_schema}.isbs_bopsig to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bopsig is '柜员操作信息表';
comment on column ${iol_schema}.isbs_bopsig.dat is '';
comment on column ${iol_schema}.isbs_bopsig.sta is '';
comment on column ${iol_schema}.isbs_bopsig.dblinr is '';
comment on column ${iol_schema}.isbs_bopsig.usr is '';
comment on column ${iol_schema}.isbs_bopsig.tim is '';
comment on column ${iol_schema}.isbs_bopsig.inr is '';
comment on column ${iol_schema}.isbs_bopsig.txt is '';
comment on column ${iol_schema}.isbs_bopsig.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bopsig.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bopsig.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bopsig.etl_timestamp is 'ETL处理时间戳';
