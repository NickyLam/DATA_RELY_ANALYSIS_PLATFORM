/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_slc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_slc
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_slc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_slc(
    sccode varchar2(48) -- 
    ,slcno varchar2(90) -- 
    ,slccountry varchar2(150) -- 
    ,orgname varchar2(150) -- 
    ,orgtype varchar2(3) -- 
    ,outratingresult varchar2(45) -- 
    ,outratingdate varchar2(15) -- 
    ,remark varchar2(4000) -- 
    ,inratingresult varchar2(150) -- 
    ,intatingdate varchar2(15) -- 
    ,registcountry varchar2(150) -- 
    ,registcountryresult varchar2(150) -- 
    ,slcmoney number(20,2) -- 
    ,iscancel varchar2(3) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_slc to ${iml_schema};
grant select on ${iol_schema}.mims_si_slc to ${icl_schema};
grant select on ${iol_schema}.mims_si_slc to ${idl_schema};
grant select on ${iol_schema}.mims_si_slc to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_slc is '备用信用证';
comment on column ${iol_schema}.mims_si_slc.sccode is '';
comment on column ${iol_schema}.mims_si_slc.slcno is '';
comment on column ${iol_schema}.mims_si_slc.slccountry is '';
comment on column ${iol_schema}.mims_si_slc.orgname is '';
comment on column ${iol_schema}.mims_si_slc.orgtype is '';
comment on column ${iol_schema}.mims_si_slc.outratingresult is '';
comment on column ${iol_schema}.mims_si_slc.outratingdate is '';
comment on column ${iol_schema}.mims_si_slc.remark is '';
comment on column ${iol_schema}.mims_si_slc.inratingresult is '';
comment on column ${iol_schema}.mims_si_slc.intatingdate is '';
comment on column ${iol_schema}.mims_si_slc.registcountry is '';
comment on column ${iol_schema}.mims_si_slc.registcountryresult is '';
comment on column ${iol_schema}.mims_si_slc.slcmoney is '';
comment on column ${iol_schema}.mims_si_slc.iscancel is '';
comment on column ${iol_schema}.mims_si_slc.tdcurrency is '';
comment on column ${iol_schema}.mims_si_slc.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_slc.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_slc.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_slc.etl_timestamp is 'ETL处理时间戳';
