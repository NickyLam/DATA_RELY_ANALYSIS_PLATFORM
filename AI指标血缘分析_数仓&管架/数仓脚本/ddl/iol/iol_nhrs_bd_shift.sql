/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_shift
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_shift
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_shift purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_shift(
    allowearly number(16,4) -- 
    ,allowlate number(16,4) -- 
    ,beginday number(38,0) -- 
    ,begintime varchar2(12) -- 
    ,capbeginday number(38,0) -- 
    ,capbegintime varchar2(12) -- 
    ,capendday number(38,0) -- 
    ,capendtime varchar2(12) -- 
    ,capgzsj number(16,4) -- 
    ,cardtype number(38,0) -- 
    ,code varchar2(120) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,defaultflag varchar2(2) -- 
    ,dr number(10,0) -- 
    ,earliestendday number(38,0) -- 
    ,earliestendtime varchar2(12) -- 
    ,enablestate number(38,0) -- 
    ,endday number(38,0) -- 
    ,endtime varchar2(12) -- 
    ,gzsj number(16,4) -- 
    ,includenightshift varchar2(2) -- 
    ,isallowout varchar2(2) -- 
    ,isautokg varchar2(2) -- 
    ,iscapedited varchar2(2) -- 
    ,isflexiblefinal varchar2(2) -- 
    ,ishredited varchar2(2) -- 
    ,isotflexible varchar2(2) -- 
    ,isotflexiblefinal varchar2(2) -- 
    ,isrttimeflexible varchar2(2) -- 
    ,isrttimeflexiblefinal varchar2(2) -- 
    ,issinglecard varchar2(2) -- 
    ,isturn varchar2(2) -- 
    ,kghours number(16,4) -- 
    ,largeearly number(16,4) -- 
    ,largelate number(16,4) -- 
    ,latestbeginday number(38,0) -- 
    ,latestbegintime varchar2(12) -- 
    ,memo varchar2(150) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,nightbeginday number(38,0) -- 
    ,nightbegintime varchar2(12) -- 
    ,nightendday number(38,0) -- 
    ,nightendtime varchar2(12) -- 
    ,nightgzsj number(16,4) -- 
    ,ontmbeyond number(16,4) -- 
    ,ontmend number(16,4) -- 
    ,overtmbegin number(16,4) -- 
    ,overtmbeyond number(16,4) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_shift varchar2(30) -- 
    ,pk_shifttype varchar2(30) -- 
    ,timebeginday number(38,0) -- 
    ,timebegintime varchar2(12) -- 
    ,timeendday number(38,0) -- 
    ,timeendtime varchar2(12) -- 
    ,ts varchar2(29) -- 
    ,useontmrule varchar2(2) -- 
    ,useovertmrule varchar2(2) -- 
    ,worklen number(38,0) -- 
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
grant select on ${iol_schema}.nhrs_bd_shift to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_shift to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_shift to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_shift to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_shift is '班次';
comment on column ${iol_schema}.nhrs_bd_shift.allowearly is '';
comment on column ${iol_schema}.nhrs_bd_shift.allowlate is '';
comment on column ${iol_schema}.nhrs_bd_shift.beginday is '';
comment on column ${iol_schema}.nhrs_bd_shift.begintime is '';
comment on column ${iol_schema}.nhrs_bd_shift.capbeginday is '';
comment on column ${iol_schema}.nhrs_bd_shift.capbegintime is '';
comment on column ${iol_schema}.nhrs_bd_shift.capendday is '';
comment on column ${iol_schema}.nhrs_bd_shift.capendtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.capgzsj is '';
comment on column ${iol_schema}.nhrs_bd_shift.cardtype is '';
comment on column ${iol_schema}.nhrs_bd_shift.code is '';
comment on column ${iol_schema}.nhrs_bd_shift.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.creator is '';
comment on column ${iol_schema}.nhrs_bd_shift.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_shift.defaultflag is '';
comment on column ${iol_schema}.nhrs_bd_shift.dr is '';
comment on column ${iol_schema}.nhrs_bd_shift.earliestendday is '';
comment on column ${iol_schema}.nhrs_bd_shift.earliestendtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.enablestate is '';
comment on column ${iol_schema}.nhrs_bd_shift.endday is '';
comment on column ${iol_schema}.nhrs_bd_shift.endtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.gzsj is '';
comment on column ${iol_schema}.nhrs_bd_shift.includenightshift is '';
comment on column ${iol_schema}.nhrs_bd_shift.isallowout is '';
comment on column ${iol_schema}.nhrs_bd_shift.isautokg is '';
comment on column ${iol_schema}.nhrs_bd_shift.iscapedited is '';
comment on column ${iol_schema}.nhrs_bd_shift.isflexiblefinal is '';
comment on column ${iol_schema}.nhrs_bd_shift.ishredited is '';
comment on column ${iol_schema}.nhrs_bd_shift.isotflexible is '';
comment on column ${iol_schema}.nhrs_bd_shift.isotflexiblefinal is '';
comment on column ${iol_schema}.nhrs_bd_shift.isrttimeflexible is '';
comment on column ${iol_schema}.nhrs_bd_shift.isrttimeflexiblefinal is '';
comment on column ${iol_schema}.nhrs_bd_shift.issinglecard is '';
comment on column ${iol_schema}.nhrs_bd_shift.isturn is '';
comment on column ${iol_schema}.nhrs_bd_shift.kghours is '';
comment on column ${iol_schema}.nhrs_bd_shift.largeearly is '';
comment on column ${iol_schema}.nhrs_bd_shift.largelate is '';
comment on column ${iol_schema}.nhrs_bd_shift.latestbeginday is '';
comment on column ${iol_schema}.nhrs_bd_shift.latestbegintime is '';
comment on column ${iol_schema}.nhrs_bd_shift.memo is '';
comment on column ${iol_schema}.nhrs_bd_shift.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.modifier is '';
comment on column ${iol_schema}.nhrs_bd_shift.name is '';
comment on column ${iol_schema}.nhrs_bd_shift.name2 is '';
comment on column ${iol_schema}.nhrs_bd_shift.name3 is '';
comment on column ${iol_schema}.nhrs_bd_shift.name4 is '';
comment on column ${iol_schema}.nhrs_bd_shift.name5 is '';
comment on column ${iol_schema}.nhrs_bd_shift.name6 is '';
comment on column ${iol_schema}.nhrs_bd_shift.nightbeginday is '';
comment on column ${iol_schema}.nhrs_bd_shift.nightbegintime is '';
comment on column ${iol_schema}.nhrs_bd_shift.nightendday is '';
comment on column ${iol_schema}.nhrs_bd_shift.nightendtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.nightgzsj is '';
comment on column ${iol_schema}.nhrs_bd_shift.ontmbeyond is '';
comment on column ${iol_schema}.nhrs_bd_shift.ontmend is '';
comment on column ${iol_schema}.nhrs_bd_shift.overtmbegin is '';
comment on column ${iol_schema}.nhrs_bd_shift.overtmbeyond is '';
comment on column ${iol_schema}.nhrs_bd_shift.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_shift.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_shift.pk_shift is '';
comment on column ${iol_schema}.nhrs_bd_shift.pk_shifttype is '';
comment on column ${iol_schema}.nhrs_bd_shift.timebeginday is '';
comment on column ${iol_schema}.nhrs_bd_shift.timebegintime is '';
comment on column ${iol_schema}.nhrs_bd_shift.timeendday is '';
comment on column ${iol_schema}.nhrs_bd_shift.timeendtime is '';
comment on column ${iol_schema}.nhrs_bd_shift.ts is '';
comment on column ${iol_schema}.nhrs_bd_shift.useontmrule is '';
comment on column ${iol_schema}.nhrs_bd_shift.useovertmrule is '';
comment on column ${iol_schema}.nhrs_bd_shift.worklen is '';
comment on column ${iol_schema}.nhrs_bd_shift.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_shift.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_shift.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_shift.etl_timestamp is 'ETL处理时间戳';
