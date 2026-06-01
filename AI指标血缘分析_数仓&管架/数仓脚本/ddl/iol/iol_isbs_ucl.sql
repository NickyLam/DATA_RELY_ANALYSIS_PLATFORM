/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ucl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ucl
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ucl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ucl(
    assignflg varchar2(2) -- 
    ,objlst varchar2(120) -- 
    ,usr varchar2(12) -- 
    ,usrdef varchar2(2) -- 
    ,mannam varchar2(60) -- 
    ,branchinr varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_ucl to ${iml_schema};
grant select on ${iol_schema}.isbs_ucl to ${icl_schema};
grant select on ${iol_schema}.isbs_ucl to ${idl_schema};
grant select on ${iol_schema}.isbs_ucl to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ucl is '用户机构控制表,用户以及用户所在机构';
comment on column ${iol_schema}.isbs_ucl.assignflg is '';
comment on column ${iol_schema}.isbs_ucl.objlst is '';
comment on column ${iol_schema}.isbs_ucl.usr is '';
comment on column ${iol_schema}.isbs_ucl.usrdef is '';
comment on column ${iol_schema}.isbs_ucl.mannam is '';
comment on column ${iol_schema}.isbs_ucl.branchinr is '';
comment on column ${iol_schema}.isbs_ucl.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ucl.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ucl.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ucl.etl_timestamp is 'ETL处理时间戳';
