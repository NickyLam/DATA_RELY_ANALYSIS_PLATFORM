/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_torg_organ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_torg_organ
whenever sqlerror continue none;
drop table ${iol_schema}.orws_torg_organ purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_torg_organ(
    organid number(18,0) -- 
    ,ownerorganid number(18,0) -- 
    ,organcode varchar2(50) -- 
    ,organnum varchar2(75) -- 
    ,organname varchar2(383) -- 
    ,invoicename varchar2(75) -- 
    ,shortname varchar2(383) -- 
    ,organtype number(18,0) -- 
    ,isbuildaccunt number(18,0) -- 
    ,address varchar2(400) -- 
    ,builddate timestamp -- 
    ,invaliddate timestamp -- 
    ,corporation varchar2(75) -- 
    ,master varchar2(75) -- 
    ,postcode varchar2(75) -- 
    ,linkphone varchar2(75) -- 
    ,fax varchar2(75) -- 
    ,email varchar2(75) -- 
    ,taxno varchar2(75) -- 
    ,personnelnum number(18,0) -- 
    ,isused number(18,0) -- 
    ,remark varchar2(300) -- 
    ,ext1 varchar2(383) -- 
    ,ext2 varchar2(150) -- 
    ,ext3 varchar2(150) -- 
    ,officedate timestamp -- 
    ,managermaster varchar2(75) -- 
    ,mofficedate timestamp -- 
    ,status number(18,0) -- 
    ,source_type varchar2(150) -- 
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
grant select on ${iol_schema}.orws_torg_organ to ${iml_schema};
grant select on ${iol_schema}.orws_torg_organ to ${icl_schema};
grant select on ${iol_schema}.orws_torg_organ to ${idl_schema};
grant select on ${iol_schema}.orws_torg_organ to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_torg_organ is '机构表';
comment on column ${iol_schema}.orws_torg_organ.organid is '';
comment on column ${iol_schema}.orws_torg_organ.ownerorganid is '';
comment on column ${iol_schema}.orws_torg_organ.organcode is '';
comment on column ${iol_schema}.orws_torg_organ.organnum is '';
comment on column ${iol_schema}.orws_torg_organ.organname is '';
comment on column ${iol_schema}.orws_torg_organ.invoicename is '';
comment on column ${iol_schema}.orws_torg_organ.shortname is '';
comment on column ${iol_schema}.orws_torg_organ.organtype is '';
comment on column ${iol_schema}.orws_torg_organ.isbuildaccunt is '';
comment on column ${iol_schema}.orws_torg_organ.address is '';
comment on column ${iol_schema}.orws_torg_organ.builddate is '';
comment on column ${iol_schema}.orws_torg_organ.invaliddate is '';
comment on column ${iol_schema}.orws_torg_organ.corporation is '';
comment on column ${iol_schema}.orws_torg_organ.master is '';
comment on column ${iol_schema}.orws_torg_organ.postcode is '';
comment on column ${iol_schema}.orws_torg_organ.linkphone is '';
comment on column ${iol_schema}.orws_torg_organ.fax is '';
comment on column ${iol_schema}.orws_torg_organ.email is '';
comment on column ${iol_schema}.orws_torg_organ.taxno is '';
comment on column ${iol_schema}.orws_torg_organ.personnelnum is '';
comment on column ${iol_schema}.orws_torg_organ.isused is '';
comment on column ${iol_schema}.orws_torg_organ.remark is '';
comment on column ${iol_schema}.orws_torg_organ.ext1 is '';
comment on column ${iol_schema}.orws_torg_organ.ext2 is '';
comment on column ${iol_schema}.orws_torg_organ.ext3 is '';
comment on column ${iol_schema}.orws_torg_organ.officedate is '';
comment on column ${iol_schema}.orws_torg_organ.managermaster is '';
comment on column ${iol_schema}.orws_torg_organ.mofficedate is '';
comment on column ${iol_schema}.orws_torg_organ.status is '';
comment on column ${iol_schema}.orws_torg_organ.source_type is '';
comment on column ${iol_schema}.orws_torg_organ.start_dt is '开始时间';
comment on column ${iol_schema}.orws_torg_organ.end_dt is '结束时间';
comment on column ${iol_schema}.orws_torg_organ.id_mark is '增删标志';
comment on column ${iol_schema}.orws_torg_organ.etl_timestamp is 'ETL处理时间戳';
