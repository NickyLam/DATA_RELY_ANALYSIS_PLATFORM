/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_otherpledge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_otherpledge
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_otherpledge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherpledge(
    sccode varchar2(48) -- 
    ,guarname varchar2(150) -- 
    ,amount number(22) -- 
    ,unit varchar2(3) -- 
    ,gaindate varchar2(15) -- 
    ,value number(20,2) -- 
    ,remark varchar2(4000) -- 
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
grant select on ${iol_schema}.mims_si_otherpledge to ${iml_schema};
grant select on ${iol_schema}.mims_si_otherpledge to ${icl_schema};
grant select on ${iol_schema}.mims_si_otherpledge to ${idl_schema};
grant select on ${iol_schema}.mims_si_otherpledge to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_otherpledge is '其他质押物';
comment on column ${iol_schema}.mims_si_otherpledge.sccode is '';
comment on column ${iol_schema}.mims_si_otherpledge.guarname is '';
comment on column ${iol_schema}.mims_si_otherpledge.amount is '';
comment on column ${iol_schema}.mims_si_otherpledge.unit is '';
comment on column ${iol_schema}.mims_si_otherpledge.gaindate is '';
comment on column ${iol_schema}.mims_si_otherpledge.value is '';
comment on column ${iol_schema}.mims_si_otherpledge.remark is '';
comment on column ${iol_schema}.mims_si_otherpledge.tdcurrency is '';
comment on column ${iol_schema}.mims_si_otherpledge.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_otherpledge.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_otherpledge.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_otherpledge.etl_timestamp is 'ETL处理时间戳';
