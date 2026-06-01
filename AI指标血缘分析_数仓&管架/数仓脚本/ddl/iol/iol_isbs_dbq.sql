/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbq
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbq(
    inr varchar2(12) -- 
    ,tmpref varchar2(24) -- 
    ,ownextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,actiontype varchar2(2) -- 
    ,actiondesc varchar2(198) -- 
    ,rptno varchar2(33) -- 
    ,country varchar2(5) -- 
    ,isref varchar2(2) -- 
    ,paytype varchar2(2) -- 
    ,payattr varchar2(2) -- 
    ,txcode varchar2(9) -- 
    ,tc1amt number(22,0) -- 
    ,txcode2 varchar2(9) -- 
    ,tc2amt number(22,0) -- 
    ,impdate date -- 
    ,contrno varchar2(390) -- 
    ,invoino varchar2(390) -- 
    ,regno varchar2(30) -- 
    ,cusmno varchar2(18) -- 
    ,customs varchar2(4000) -- 
    ,crtuser varchar2(30) -- 
    ,inptelc varchar2(30) -- 
    ,rptdate date -- 
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
grant select on ${iol_schema}.isbs_dbq to ${iml_schema};
grant select on ${iol_schema}.isbs_dbq to ${icl_schema};
grant select on ${iol_schema}.isbs_dbq to ${idl_schema};
grant select on ${iol_schema}.isbs_dbq to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbq is '';
comment on column ${iol_schema}.isbs_dbq.inr is '';
comment on column ${iol_schema}.isbs_dbq.tmpref is '';
comment on column ${iol_schema}.isbs_dbq.ownextkey is '';
comment on column ${iol_schema}.isbs_dbq.ver is '';
comment on column ${iol_schema}.isbs_dbq.actiontype is '';
comment on column ${iol_schema}.isbs_dbq.actiondesc is '';
comment on column ${iol_schema}.isbs_dbq.rptno is '';
comment on column ${iol_schema}.isbs_dbq.country is '';
comment on column ${iol_schema}.isbs_dbq.isref is '';
comment on column ${iol_schema}.isbs_dbq.paytype is '';
comment on column ${iol_schema}.isbs_dbq.payattr is '';
comment on column ${iol_schema}.isbs_dbq.txcode is '';
comment on column ${iol_schema}.isbs_dbq.tc1amt is '';
comment on column ${iol_schema}.isbs_dbq.txcode2 is '';
comment on column ${iol_schema}.isbs_dbq.tc2amt is '';
comment on column ${iol_schema}.isbs_dbq.impdate is '';
comment on column ${iol_schema}.isbs_dbq.contrno is '';
comment on column ${iol_schema}.isbs_dbq.invoino is '';
comment on column ${iol_schema}.isbs_dbq.regno is '';
comment on column ${iol_schema}.isbs_dbq.cusmno is '';
comment on column ${iol_schema}.isbs_dbq.customs is '';
comment on column ${iol_schema}.isbs_dbq.crtuser is '';
comment on column ${iol_schema}.isbs_dbq.inptelc is '';
comment on column ${iol_schema}.isbs_dbq.rptdate is '';
comment on column ${iol_schema}.isbs_dbq.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbq.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbq.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbq.etl_timestamp is 'ETL处理时间戳';
