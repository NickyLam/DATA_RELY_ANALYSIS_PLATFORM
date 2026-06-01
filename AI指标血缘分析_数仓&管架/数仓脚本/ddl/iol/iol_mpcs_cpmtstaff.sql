/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_cpmtstaff
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_cpmtstaff
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_cpmtstaff purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_cpmtstaff(
    staffno varchar2(15) -- 
    ,tlrtype varchar2(2) -- 
    ,staffname varchar2(90) -- 
    ,sex varchar2(2) -- 
    ,birthday varchar2(12) -- 
    ,idtype varchar2(2) -- 
    ,idno varchar2(45) -- 
    ,ofinstno varchar2(15) -- 
    ,ofdeptno varchar2(15) -- 
    ,stafftype varchar2(2) -- 
    ,mobile varchar2(30) -- 
    ,email varchar2(90) -- 
    ,safemode varchar2(2) -- 
    ,signpswd varchar2(96) -- 
    ,pswdchgdt varchar2(12) -- 
    ,rowstat varchar2(2) -- 
    ,upddt varchar2(12) -- 
    ,updtm varchar2(9) -- 
    ,ygno varchar2(15) -- 
    ,motto varchar2(450) -- 
    ,ofdeptnm varchar2(150) -- 
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
grant select on ${iol_schema}.mpcs_cpmtstaff to ${iml_schema};
grant select on ${iol_schema}.mpcs_cpmtstaff to ${icl_schema};
grant select on ${iol_schema}.mpcs_cpmtstaff to ${idl_schema};
grant select on ${iol_schema}.mpcs_cpmtstaff to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_cpmtstaff is '员工表';
comment on column ${iol_schema}.mpcs_cpmtstaff.staffno is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.tlrtype is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.staffname is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.sex is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.birthday is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.idtype is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.idno is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.ofinstno is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.ofdeptno is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.stafftype is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.mobile is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.email is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.safemode is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.signpswd is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.pswdchgdt is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.rowstat is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.upddt is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.updtm is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.ygno is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.motto is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.ofdeptnm is '';
comment on column ${iol_schema}.mpcs_cpmtstaff.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_cpmtstaff.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_cpmtstaff.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_cpmtstaff.etl_timestamp is 'ETL处理时间戳';
