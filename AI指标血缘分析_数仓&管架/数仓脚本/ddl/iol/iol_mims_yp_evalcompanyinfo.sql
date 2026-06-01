/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_evalcompanyinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_evalcompanyinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_evalcompanyinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_evalcompanyinfo(
    extcustid varchar2(45) -- 
    ,extcustcname varchar2(300) -- 
    ,orgcertcode varchar2(45) -- 
    ,licenseid varchar2(60) -- 
    ,enrolmoney number(16,2) -- 
    ,thebegindate varchar2(15) -- 
    ,thecompanyenddate varchar2(15) -- 
    ,begindate varchar2(15) -- 
    ,contactname varchar2(180) -- 
    ,contacttell varchar2(45) -- 
    ,contactphone varchar2(45) -- 
    ,barsign varchar2(2) -- 
    ,deptcode varchar2(30) -- 
    ,address varchar2(180) -- 
    ,modifydate varchar2(15) -- 
    ,modifyinstruction varchar2(1200) -- 
    ,outdate varchar2(15) -- 
    ,outstruction varchar2(1200) -- 
    ,status varchar2(3) -- 
    ,approvestatus varchar2(2) -- 
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
grant select on ${iol_schema}.mims_yp_evalcompanyinfo to ${iml_schema};
grant select on ${iol_schema}.mims_yp_evalcompanyinfo to ${icl_schema};
grant select on ${iol_schema}.mims_yp_evalcompanyinfo to ${idl_schema};
grant select on ${iol_schema}.mims_yp_evalcompanyinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_evalcompanyinfo is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.extcustid is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.extcustcname is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.orgcertcode is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.licenseid is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.enrolmoney is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.thebegindate is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.thecompanyenddate is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.begindate is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.contactname is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.contacttell is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.contactphone is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.barsign is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.deptcode is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.address is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.modifydate is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.modifyinstruction is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.outdate is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.outstruction is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.status is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.approvestatus is '';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_evalcompanyinfo.etl_timestamp is 'ETL处理时间戳';
