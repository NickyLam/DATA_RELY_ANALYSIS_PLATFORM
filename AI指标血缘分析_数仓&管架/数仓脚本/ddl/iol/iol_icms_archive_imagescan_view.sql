/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_archive_imagescan_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_archive_imagescan_view
whenever sqlerror continue none;
drop table ${iol_schema}.icms_archive_imagescan_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_archive_imagescan_view(
    inputdate varchar2(8) -- 
    ,orgname varchar2(200) -- 
    ,operateuserrole varchar2(20) -- 
    ,userid varchar2(8) -- 
    ,username varchar2(200) -- 
    ,authuserid varchar2(20) -- 
    ,authusername varchar2(20) -- 
    ,authorgid varchar2(20) -- 
    ,objecttype varchar2(32) -- 
    ,objecttypename varchar2(18) -- 
    ,startdate varchar2(19) -- 
    ,enddate varchar2(19) -- 
    ,serialno varchar2(64) -- 
    ,system varchar2(54) -- 
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
grant select on ${iol_schema}.icms_archive_imagescan_view to ${iml_schema};
grant select on ${iol_schema}.icms_archive_imagescan_view to ${icl_schema};
grant select on ${iol_schema}.icms_archive_imagescan_view to ${idl_schema};
grant select on ${iol_schema}.icms_archive_imagescan_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_archive_imagescan_view is '档案影像扫描表';
comment on column ${iol_schema}.icms_archive_imagescan_view.inputdate is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.orgname is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.operateuserrole is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.userid is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.username is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.authuserid is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.authusername is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.authorgid is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.objecttype is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.objecttypename is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.startdate is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.enddate is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.serialno is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.system is '';
comment on column ${iol_schema}.icms_archive_imagescan_view.start_dt is '开始时间';
comment on column ${iol_schema}.icms_archive_imagescan_view.end_dt is '结束时间';
comment on column ${iol_schema}.icms_archive_imagescan_view.id_mark is '增删标志';
comment on column ${iol_schema}.icms_archive_imagescan_view.etl_timestamp is 'ETL处理时间戳';
