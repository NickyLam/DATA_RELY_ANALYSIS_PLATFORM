/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_mpcs_cpmtstaff
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_mpcs_cpmtstaff
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_mpcs_cpmtstaff purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_mpcs_cpmtstaff(
    etl_dt date
    ,staffno varchar2(10)
    ,tlrtype varchar2(1)
    ,staffname varchar2(60)
    ,sex varchar2(1)
    ,birthday varchar2(8)
    ,idtype varchar2(1)
    ,idno varchar2(30)
    ,ofinstno varchar2(10)
    ,ofdeptno varchar2(10)
    ,stafftype varchar2(1)
    ,mobile varchar2(20)
    ,email varchar2(60)
    ,safemode varchar2(1)
    ,signpswd varchar2(64)
    ,pswdchgdt varchar2(8)
    ,rowstat varchar2(1)
    ,upddt varchar2(8)
    ,updtm varchar2(6)
    ,ygno varchar2(10)
    ,motto varchar2(300)
    ,ofdeptnm varchar2(100)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_mpcs_cpmtstaff to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_mpcs_cpmtstaff is '员工表';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.staffno is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.tlrtype is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.staffname is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.sex is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.birthday is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.idtype is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.idno is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.ofinstno is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.ofdeptno is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.stafftype is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.mobile is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.email is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.safemode is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.signpswd is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.pswdchgdt is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.rowstat is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.upddt is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.updtm is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.ygno is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.motto is '';
comment on column ${msl_schema}.msl_edw_mpcs_cpmtstaff.ofdeptnm is '';
