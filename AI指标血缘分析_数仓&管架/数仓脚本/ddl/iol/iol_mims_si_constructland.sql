/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_constructland
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_constructland
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_constructland purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_constructland(
    sccode varchar2(48) -- 
    ,landno varchar2(90) -- 
    ,landusenature varchar2(3) -- 
    ,landgainway varchar2(3) -- 
    ,landstartdate varchar2(15) -- 
    ,landenddate varchar2(15) -- 
    ,landusering varchar2(3) -- 
    ,landusearea number(20,2) -- 
    ,landtype varchar2(3) -- 
    ,province varchar2(90) -- 
    ,city varchar2(90) -- 
    ,counties varchar2(90) -- 
    ,street varchar2(90) -- 
    ,address varchar2(300) -- 
    ,landdec varchar2(90) -- 
    ,tradedate varchar2(15) -- 
    ,tradeprice number(20,2) -- 
    ,isattachments varchar2(3) -- 
    ,attachmenttype varchar2(3) -- 
    ,buildterm number(22) -- 
    ,attachmentowner varchar2(150) -- 
    ,attachmentregion varchar2(150) -- 
    ,overallfloorage number(20,2) -- 
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
grant select on ${iol_schema}.mims_si_constructland to ${iml_schema};
grant select on ${iol_schema}.mims_si_constructland to ${icl_schema};
grant select on ${iol_schema}.mims_si_constructland to ${idl_schema};
grant select on ${iol_schema}.mims_si_constructland to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_constructland is '建设用地使用权';
comment on column ${iol_schema}.mims_si_constructland.sccode is '';
comment on column ${iol_schema}.mims_si_constructland.landno is '';
comment on column ${iol_schema}.mims_si_constructland.landusenature is '';
comment on column ${iol_schema}.mims_si_constructland.landgainway is '';
comment on column ${iol_schema}.mims_si_constructland.landstartdate is '';
comment on column ${iol_schema}.mims_si_constructland.landenddate is '';
comment on column ${iol_schema}.mims_si_constructland.landusering is '';
comment on column ${iol_schema}.mims_si_constructland.landusearea is '';
comment on column ${iol_schema}.mims_si_constructland.landtype is '';
comment on column ${iol_schema}.mims_si_constructland.province is '';
comment on column ${iol_schema}.mims_si_constructland.city is '';
comment on column ${iol_schema}.mims_si_constructland.counties is '';
comment on column ${iol_schema}.mims_si_constructland.street is '';
comment on column ${iol_schema}.mims_si_constructland.address is '';
comment on column ${iol_schema}.mims_si_constructland.landdec is '';
comment on column ${iol_schema}.mims_si_constructland.tradedate is '';
comment on column ${iol_schema}.mims_si_constructland.tradeprice is '';
comment on column ${iol_schema}.mims_si_constructland.isattachments is '';
comment on column ${iol_schema}.mims_si_constructland.attachmenttype is '';
comment on column ${iol_schema}.mims_si_constructland.buildterm is '';
comment on column ${iol_schema}.mims_si_constructland.attachmentowner is '';
comment on column ${iol_schema}.mims_si_constructland.attachmentregion is '';
comment on column ${iol_schema}.mims_si_constructland.overallfloorage is '';
comment on column ${iol_schema}.mims_si_constructland.remark is '';
comment on column ${iol_schema}.mims_si_constructland.tdcurrency is '';
comment on column ${iol_schema}.mims_si_constructland.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_constructland.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_constructland.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_constructland.etl_timestamp is 'ETL处理时间戳';
