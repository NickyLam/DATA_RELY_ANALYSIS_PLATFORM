/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_psndoc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_psndoc
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_psndoc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_psndoc(
    addr varchar2(30) -- 
    ,birthdate varchar2(15) -- 
    ,code varchar2(75) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,def1 varchar2(152) -- 
    ,def10 varchar2(152) -- 
    ,def11 varchar2(152) -- 
    ,def12 varchar2(152) -- 
    ,def13 varchar2(152) -- 
    ,def14 varchar2(152) -- 
    ,def15 varchar2(152) -- 
    ,def16 varchar2(152) -- 
    ,def17 varchar2(152) -- 
    ,def18 varchar2(152) -- 
    ,def19 varchar2(152) -- 
    ,def2 varchar2(152) -- 
    ,def20 varchar2(152) -- 
    ,def3 varchar2(152) -- 
    ,def4 varchar2(152) -- 
    ,def5 varchar2(152) -- 
    ,def6 varchar2(152) -- 
    ,def7 varchar2(152) -- 
    ,def8 varchar2(152) -- 
    ,def9 varchar2(152) -- 
    ,dr number(10,0) -- 
    ,email varchar2(75) -- 
    ,enablestate number(38,0) -- 
    ,homephone varchar2(45) -- 
    ,id varchar2(42) -- 
    ,idtype number(38,0) -- 
    ,isshopassist varchar2(2) -- 
    ,joinworkdate varchar2(15) -- 
    ,mnecode varchar2(75) -- 
    ,mobile varchar2(45) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,officephone varchar2(45) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_psndoc varchar2(30) -- 
    ,sex number(38,0) -- 
    ,ts varchar2(29) -- 
    ,usedname varchar2(450) -- 
    ,bloodtype varchar2(30) -- 
    ,censusaddr varchar2(576) -- 
    ,characterrpr varchar2(30) -- 
    ,country varchar2(30) -- 
    ,die_date varchar2(15) -- 
    ,die_remark varchar2(4000) -- 
    ,edu varchar2(30) -- 
    ,fax varchar2(45) -- 
    ,fileaddress varchar2(288) -- 
    ,health varchar2(30) -- 
    ,ishiskeypsn varchar2(2) -- 
    ,joinpolitydate varchar2(15) -- 
    ,marital varchar2(30) -- 
    ,marriagedate varchar2(15) -- 
    ,nationality varchar2(30) -- 
    ,nativeplace varchar2(30) -- 
    ,penelauth varchar2(30) -- 
    ,permanreside varchar2(30) -- 
    ,photo varchar2(4000) -- 
    ,pk_degree varchar2(30) -- 
    ,pk_hrorg varchar2(30) -- 
    ,polity varchar2(30) -- 
    ,postalcode varchar2(30) -- 
    ,previewphoto varchar2(4000) -- 
    ,prof varchar2(30) -- 
    ,retiredate varchar2(15) -- 
    ,secret_email varchar2(75) -- 
    ,shortname varchar2(300) -- 
    ,titletechpost varchar2(30) -- 
    ,glbdef1 varchar2(192) -- 
    ,glbdef2 varchar2(30) -- 
    ,glbdef3 varchar2(30) -- 
    ,glbdef4 varchar2(30) -- 
    ,glbdef5 varchar2(30) -- 
    ,glbdef6 varchar2(30) -- 
    ,glbdef7 varchar2(15) -- 
    ,glbdef8 varchar2(15) -- 
    ,glbdef9 varchar2(30) -- 
    ,glbdef10 number(22,0) -- 
    ,glbdef11 varchar2(150) -- 
    ,glbdef12 varchar2(15) -- 
    ,glbdef13 varchar2(192) -- 
    ,glbdef14 varchar2(192) -- 
    ,glbdef15 varchar2(30) -- 
    ,glbdef16 varchar2(29) -- 
    ,glbdef17 number(22,0) -- 
    ,glbdef18 varchar2(30) -- 
    ,glbdef19 varchar2(30) -- 
    ,glbdef20 varchar2(192) -- 
    ,glbdef21 number(22,0) -- 
    ,glbdef22 varchar2(30) -- 
    ,glbdef23 varchar2(1500) -- 
    ,glbdef24 number(22,0) -- 
    ,glbdef25 number(22,0) -- 
    ,glbdef26 number(22,0) -- 
    ,glbdef27 varchar2(1500) -- 
    ,glbdef28 varchar2(1500) -- 
    ,glbdef29 varchar2(1500) -- 
    ,glbdef30 varchar2(768) -- 
    ,glbdef31 varchar2(450) -- 
    ,glbdef32 varchar2(192) -- 
    ,glbdef40 varchar2(60) -- 
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
grant select on ${iol_schema}.nhrs_bd_psndoc to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_psndoc to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_psndoc to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_psndoc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_psndoc is '人员基本信息';
comment on column ${iol_schema}.nhrs_bd_psndoc.addr is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.birthdate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.code is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.creator is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def1 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def10 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def11 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def12 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def13 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def14 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def15 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def16 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def17 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def18 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def19 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def2 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def20 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def3 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def4 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def5 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def6 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def7 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def8 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.def9 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.dr is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.email is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.enablestate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.homephone is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.id is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.idtype is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.isshopassist is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.joinworkdate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.mnecode is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.mobile is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.modifier is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name2 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name3 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name4 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name5 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.name6 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.officephone is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.pk_psndoc is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.sex is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.ts is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.usedname is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.bloodtype is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.censusaddr is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.characterrpr is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.country is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.die_date is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.die_remark is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.edu is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.fax is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.fileaddress is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.health is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.ishiskeypsn is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.joinpolitydate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.marital is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.marriagedate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.nationality is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.nativeplace is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.penelauth is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.permanreside is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.photo is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.pk_degree is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.pk_hrorg is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.polity is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.postalcode is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.previewphoto is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.prof is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.retiredate is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.secret_email is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.shortname is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.titletechpost is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef1 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef2 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef3 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef4 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef5 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef6 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef7 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef8 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef9 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef10 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef11 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef12 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef13 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef14 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef15 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef16 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef17 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef18 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef19 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef20 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef21 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef22 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef23 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef24 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef25 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef26 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef27 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef28 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef29 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef30 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef31 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef32 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.glbdef40 is '';
comment on column ${iol_schema}.nhrs_bd_psndoc.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_psndoc.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_psndoc.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_psndoc.etl_timestamp is 'ETL处理时间戳';
