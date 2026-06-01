/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_conothertraffic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_conothertraffic
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_conothertraffic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_conothertraffic(
    sccode varchar2(48) -- 
    ,equipmentbrand varchar2(150) -- 
    ,specificationno varchar2(90) -- 
    ,predate varchar2(15) -- 
    ,issign varchar2(3) -- 
    ,contdate varchar2(15) -- 
    ,contno number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_conothertraffic to ${iml_schema};
grant select on ${iol_schema}.mims_si_conothertraffic to ${icl_schema};
grant select on ${iol_schema}.mims_si_conothertraffic to ${idl_schema};
grant select on ${iol_schema}.mims_si_conothertraffic to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_conothertraffic is '在建其他运输工具';
comment on column ${iol_schema}.mims_si_conothertraffic.sccode is '';
comment on column ${iol_schema}.mims_si_conothertraffic.equipmentbrand is '';
comment on column ${iol_schema}.mims_si_conothertraffic.specificationno is '';
comment on column ${iol_schema}.mims_si_conothertraffic.predate is '';
comment on column ${iol_schema}.mims_si_conothertraffic.issign is '';
comment on column ${iol_schema}.mims_si_conothertraffic.contdate is '';
comment on column ${iol_schema}.mims_si_conothertraffic.contno is '';
comment on column ${iol_schema}.mims_si_conothertraffic.remark is '';
comment on column ${iol_schema}.mims_si_conothertraffic.tdcurrency is '';
comment on column ${iol_schema}.mims_si_conothertraffic.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_conothertraffic.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_conothertraffic.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_conothertraffic.etl_timestamp is 'ETL处理时间戳';
