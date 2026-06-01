/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_om_post
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_om_post
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_om_post purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_post(
    abortdate varchar2(15) -- 
    ,builddate varchar2(15) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,employment varchar2(30) -- 
    ,enablestate number(38,0) -- 
    ,innercode varchar2(300) -- 
    ,isabort varchar2(2) -- 
    ,isdeptrespon varchar2(2) -- 
    ,junior varchar2(4000) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,pk_dept varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_job varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_post varchar2(30) -- 
    ,pk_postseries varchar2(30) -- 
    ,postcode varchar2(60) -- 
    ,postname varchar2(450) -- 
    ,postname2 varchar2(450) -- 
    ,postname3 varchar2(450) -- 
    ,postname4 varchar2(450) -- 
    ,postname5 varchar2(450) -- 
    ,postname6 varchar2(450) -- 
    ,reqedu varchar2(450) -- 
    ,reqexp varchar2(450) -- 
    ,reqother varchar2(2304) -- 
    ,reqpro varchar2(450) -- 
    ,reqsex varchar2(450) -- 
    ,reqworktime varchar2(450) -- 
    ,reqyold varchar2(450) -- 
    ,seq varchar2(75) -- 
    ,suporior varchar2(30) -- 
    ,ts varchar2(29) -- 
    ,worksumm varchar2(1536) -- 
    ,worktype varchar2(30) -- 
    ,hrcanceldate varchar2(15) -- 
    ,hrcanceled varchar2(2) -- 
    ,iskeypost varchar2(2) -- 
    ,isstd varchar2(2) -- 
    ,pk_hrorg varchar2(30) -- 
    ,pk_poststd varchar2(30) -- 
    ,sealflag varchar2(2) -- 
    ,glbdef1 number(22,0) -- 
    ,glbdef2 number(22,0) -- 
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
grant select on ${iol_schema}.nhrs_om_post to ${iml_schema};
grant select on ${iol_schema}.nhrs_om_post to ${icl_schema};
grant select on ${iol_schema}.nhrs_om_post to ${idl_schema};
grant select on ${iol_schema}.nhrs_om_post to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_om_post is '岗位表';
comment on column ${iol_schema}.nhrs_om_post.abortdate is '';
comment on column ${iol_schema}.nhrs_om_post.builddate is '';
comment on column ${iol_schema}.nhrs_om_post.creationtime is '';
comment on column ${iol_schema}.nhrs_om_post.creator is '';
comment on column ${iol_schema}.nhrs_om_post.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_om_post.dr is '';
comment on column ${iol_schema}.nhrs_om_post.employment is '';
comment on column ${iol_schema}.nhrs_om_post.enablestate is '';
comment on column ${iol_schema}.nhrs_om_post.innercode is '';
comment on column ${iol_schema}.nhrs_om_post.isabort is '';
comment on column ${iol_schema}.nhrs_om_post.isdeptrespon is '';
comment on column ${iol_schema}.nhrs_om_post.junior is '';
comment on column ${iol_schema}.nhrs_om_post.modifiedtime is '';
comment on column ${iol_schema}.nhrs_om_post.modifier is '';
comment on column ${iol_schema}.nhrs_om_post.pk_dept is '';
comment on column ${iol_schema}.nhrs_om_post.pk_group is '';
comment on column ${iol_schema}.nhrs_om_post.pk_job is '';
comment on column ${iol_schema}.nhrs_om_post.pk_org is '';
comment on column ${iol_schema}.nhrs_om_post.pk_post is '';
comment on column ${iol_schema}.nhrs_om_post.pk_postseries is '';
comment on column ${iol_schema}.nhrs_om_post.postcode is '';
comment on column ${iol_schema}.nhrs_om_post.postname is '';
comment on column ${iol_schema}.nhrs_om_post.postname2 is '';
comment on column ${iol_schema}.nhrs_om_post.postname3 is '';
comment on column ${iol_schema}.nhrs_om_post.postname4 is '';
comment on column ${iol_schema}.nhrs_om_post.postname5 is '';
comment on column ${iol_schema}.nhrs_om_post.postname6 is '';
comment on column ${iol_schema}.nhrs_om_post.reqedu is '';
comment on column ${iol_schema}.nhrs_om_post.reqexp is '';
comment on column ${iol_schema}.nhrs_om_post.reqother is '';
comment on column ${iol_schema}.nhrs_om_post.reqpro is '';
comment on column ${iol_schema}.nhrs_om_post.reqsex is '';
comment on column ${iol_schema}.nhrs_om_post.reqworktime is '';
comment on column ${iol_schema}.nhrs_om_post.reqyold is '';
comment on column ${iol_schema}.nhrs_om_post.seq is '';
comment on column ${iol_schema}.nhrs_om_post.suporior is '';
comment on column ${iol_schema}.nhrs_om_post.ts is '';
comment on column ${iol_schema}.nhrs_om_post.worksumm is '';
comment on column ${iol_schema}.nhrs_om_post.worktype is '';
comment on column ${iol_schema}.nhrs_om_post.hrcanceldate is '';
comment on column ${iol_schema}.nhrs_om_post.hrcanceled is '';
comment on column ${iol_schema}.nhrs_om_post.iskeypost is '';
comment on column ${iol_schema}.nhrs_om_post.isstd is '';
comment on column ${iol_schema}.nhrs_om_post.pk_hrorg is '';
comment on column ${iol_schema}.nhrs_om_post.pk_poststd is '';
comment on column ${iol_schema}.nhrs_om_post.sealflag is '';
comment on column ${iol_schema}.nhrs_om_post.glbdef1 is '';
comment on column ${iol_schema}.nhrs_om_post.glbdef2 is '';
comment on column ${iol_schema}.nhrs_om_post.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_om_post.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_om_post.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_om_post.etl_timestamp is 'ETL处理时间戳';
