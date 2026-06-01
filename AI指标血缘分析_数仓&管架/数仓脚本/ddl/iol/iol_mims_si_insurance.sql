/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_insurance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_insurance
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_insurance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_insurance(
    sccode varchar2(48) -- 
    ,incode varchar2(45) -- 
    ,inno varchar2(90) -- 
    ,insurname varchar2(300) -- 
    ,insurcode varchar2(30) -- 
    ,isfullguar varchar2(2) -- 
    ,insumn number(20,2) -- 
    ,stdate varchar2(15) -- 
    ,eddate varchar2(15) -- 
    ,efdate varchar2(15) -- 
    ,underwriters1 varchar2(150) -- 
    ,underwriters2 varchar2(150) -- 
    ,operatorid varchar2(30) -- 
    ,optdate varchar2(15) -- 
    ,updates varchar2(15) -- 
    ,state varchar2(2) -- 
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
grant select on ${iol_schema}.mims_si_insurance to ${iml_schema};
grant select on ${iol_schema}.mims_si_insurance to ${icl_schema};
grant select on ${iol_schema}.mims_si_insurance to ${idl_schema};
grant select on ${iol_schema}.mims_si_insurance to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_insurance is '押品保险信息表';
comment on column ${iol_schema}.mims_si_insurance.sccode is '';
comment on column ${iol_schema}.mims_si_insurance.incode is '';
comment on column ${iol_schema}.mims_si_insurance.inno is '';
comment on column ${iol_schema}.mims_si_insurance.insurname is '';
comment on column ${iol_schema}.mims_si_insurance.insurcode is '';
comment on column ${iol_schema}.mims_si_insurance.isfullguar is '';
comment on column ${iol_schema}.mims_si_insurance.insumn is '';
comment on column ${iol_schema}.mims_si_insurance.stdate is '';
comment on column ${iol_schema}.mims_si_insurance.eddate is '';
comment on column ${iol_schema}.mims_si_insurance.efdate is '';
comment on column ${iol_schema}.mims_si_insurance.underwriters1 is '';
comment on column ${iol_schema}.mims_si_insurance.underwriters2 is '';
comment on column ${iol_schema}.mims_si_insurance.operatorid is '';
comment on column ${iol_schema}.mims_si_insurance.optdate is '';
comment on column ${iol_schema}.mims_si_insurance.updates is '';
comment on column ${iol_schema}.mims_si_insurance.state is '';
comment on column ${iol_schema}.mims_si_insurance.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_insurance.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_insurance.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_insurance.etl_timestamp is 'ETL处理时间戳';
