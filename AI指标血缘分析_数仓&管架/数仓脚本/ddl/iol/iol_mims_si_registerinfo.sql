/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_registerinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_registerinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_registerinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_registerinfo(
    sccode varchar2(48) -- 
    ,regcode varchar2(45) -- 
    ,regdptname varchar2(300) -- 
    ,regvalue number(20,2) -- 
    ,regdate varchar2(15) -- 
    ,regenddate varchar2(15) -- 
    ,ymortgage varchar2(2) -- 
    ,fmortstartdate varchar2(15) -- 
    ,fmortenddate varchar2(15) -- 
    ,operatorid varchar2(30) -- 
    ,optdate varchar2(15) -- 
    ,updates varchar2(15) -- 
    ,regno varchar2(300) -- 
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
grant select on ${iol_schema}.mims_si_registerinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_registerinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_registerinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_registerinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_registerinfo is '押品登记信息表';
comment on column ${iol_schema}.mims_si_registerinfo.sccode is '';
comment on column ${iol_schema}.mims_si_registerinfo.regcode is '';
comment on column ${iol_schema}.mims_si_registerinfo.regdptname is '';
comment on column ${iol_schema}.mims_si_registerinfo.regvalue is '';
comment on column ${iol_schema}.mims_si_registerinfo.regdate is '';
comment on column ${iol_schema}.mims_si_registerinfo.regenddate is '';
comment on column ${iol_schema}.mims_si_registerinfo.ymortgage is '';
comment on column ${iol_schema}.mims_si_registerinfo.fmortstartdate is '';
comment on column ${iol_schema}.mims_si_registerinfo.fmortenddate is '';
comment on column ${iol_schema}.mims_si_registerinfo.operatorid is '';
comment on column ${iol_schema}.mims_si_registerinfo.optdate is '';
comment on column ${iol_schema}.mims_si_registerinfo.updates is '';
comment on column ${iol_schema}.mims_si_registerinfo.regno is '';
comment on column ${iol_schema}.mims_si_registerinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_registerinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_registerinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_registerinfo.etl_timestamp is 'ETL处理时间戳';
