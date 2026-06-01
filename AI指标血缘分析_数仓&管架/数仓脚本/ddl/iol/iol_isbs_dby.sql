/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dby
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dby
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dby purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dby(
    inr varchar2(12) -- 
    ,rptdate date -- 
    ,actiontype varchar2(2) -- 
    ,inptelc varchar2(30) -- 
    ,ver varchar2(6) -- 
    ,actiondesc varchar2(192) -- 
    ,rptno varchar2(33) -- 
    ,regno varchar2(30) -- 
    ,txcode varchar2(9) -- 
    ,tmpref varchar2(24) -- 
    ,ownextkey varchar2(12) -- 
    ,crtuser varchar2(30) -- 
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
grant select on ${iol_schema}.isbs_dby to ${iml_schema};
grant select on ${iol_schema}.isbs_dby to ${icl_schema};
grant select on ${iol_schema}.isbs_dby to ${idl_schema};
grant select on ${iol_schema}.isbs_dby to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dby is '购汇申请书-管理信息';
comment on column ${iol_schema}.isbs_dby.inr is '';
comment on column ${iol_schema}.isbs_dby.rptdate is '';
comment on column ${iol_schema}.isbs_dby.actiontype is '';
comment on column ${iol_schema}.isbs_dby.inptelc is '';
comment on column ${iol_schema}.isbs_dby.ver is '';
comment on column ${iol_schema}.isbs_dby.actiondesc is '';
comment on column ${iol_schema}.isbs_dby.rptno is '';
comment on column ${iol_schema}.isbs_dby.regno is '';
comment on column ${iol_schema}.isbs_dby.txcode is '';
comment on column ${iol_schema}.isbs_dby.tmpref is '';
comment on column ${iol_schema}.isbs_dby.ownextkey is '';
comment on column ${iol_schema}.isbs_dby.crtuser is '';
comment on column ${iol_schema}.isbs_dby.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dby.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dby.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dby.etl_timestamp is 'ETL处理时间戳';
