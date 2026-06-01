/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbdictmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbdictmap
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbdictmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbdictmap(
    templet varchar2(30) -- 
    ,key_no varchar2(75) -- 
    ,direction varchar2(2) -- 
    ,source varchar2(30) -- 
    ,val varchar2(90) -- 
    ,prompt varchar2(250) -- 
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
grant select on ${iol_schema}.ifms_tbdictmap to ${iml_schema};
grant select on ${iol_schema}.ifms_tbdictmap to ${icl_schema};
grant select on ${iol_schema}.ifms_tbdictmap to ${idl_schema};
grant select on ${iol_schema}.ifms_tbdictmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbdictmap is '保险数据字典转换表';
comment on column ${iol_schema}.ifms_tbdictmap.templet is '';
comment on column ${iol_schema}.ifms_tbdictmap.key_no is '';
comment on column ${iol_schema}.ifms_tbdictmap.direction is '';
comment on column ${iol_schema}.ifms_tbdictmap.source is '';
comment on column ${iol_schema}.ifms_tbdictmap.val is '';
comment on column ${iol_schema}.ifms_tbdictmap.prompt is '';
comment on column ${iol_schema}.ifms_tbdictmap.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbdictmap.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbdictmap.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbdictmap.etl_timestamp is 'ETL处理时间戳';
