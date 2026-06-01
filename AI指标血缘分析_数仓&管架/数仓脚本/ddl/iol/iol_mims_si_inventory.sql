/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_inventory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_inventory
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_inventory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_inventory(
    sccode varchar2(48) -- 
    ,region varchar2(150) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,unit varchar2(3) -- 
    ,amount number(22) -- 
    ,totalvalue number(20,2) -- 
    ,isreg varchar2(3) -- 
    ,regulatory varchar2(150) -- 
    ,regulatorycode varchar2(90) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,remark varchar2(4000) -- 
    ,otherremark varchar2(45) -- 
    ,tdcurrency varchar2(5) -- 
    ,guarinfono varchar2(300) -- 
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
grant select on ${iol_schema}.mims_si_inventory to ${iml_schema};
grant select on ${iol_schema}.mims_si_inventory to ${icl_schema};
grant select on ${iol_schema}.mims_si_inventory to ${idl_schema};
grant select on ${iol_schema}.mims_si_inventory to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_inventory is '存货';
comment on column ${iol_schema}.mims_si_inventory.sccode is '';
comment on column ${iol_schema}.mims_si_inventory.region is '';
comment on column ${iol_schema}.mims_si_inventory.province is '';
comment on column ${iol_schema}.mims_si_inventory.city is '';
comment on column ${iol_schema}.mims_si_inventory.unit is '';
comment on column ${iol_schema}.mims_si_inventory.amount is '';
comment on column ${iol_schema}.mims_si_inventory.totalvalue is '';
comment on column ${iol_schema}.mims_si_inventory.isreg is '';
comment on column ${iol_schema}.mims_si_inventory.regulatory is '';
comment on column ${iol_schema}.mims_si_inventory.regulatorycode is '';
comment on column ${iol_schema}.mims_si_inventory.startdate is '';
comment on column ${iol_schema}.mims_si_inventory.enddate is '';
comment on column ${iol_schema}.mims_si_inventory.remark is '';
comment on column ${iol_schema}.mims_si_inventory.otherremark is '';
comment on column ${iol_schema}.mims_si_inventory.tdcurrency is '';
comment on column ${iol_schema}.mims_si_inventory.guarinfono is '';
comment on column ${iol_schema}.mims_si_inventory.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_inventory.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_inventory.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_inventory.etl_timestamp is 'ETL处理时间戳';
