/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_yjzb_jgsgzb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_yjzb_jgsgzb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_yjzb_jgsgzb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_jgsgzb(
    zbdh number(22) -- 
    ,khdxdh number(22) -- 
    ,bz varchar2(5) -- 
    ,sdbs varchar2(2) -- 
    ,tjkj varchar2(2) -- 
    ,tjrq number(22) -- 
    ,zbz number(25,4) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_yjzb_jgsgzb to ${iml_schema};
grant select on ${iol_schema}.pams_yjzb_jgsgzb to ${icl_schema};
grant select on ${iol_schema}.pams_yjzb_jgsgzb to ${idl_schema};
grant select on ${iol_schema}.pams_yjzb_jgsgzb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_yjzb_jgsgzb is '业绩指标-机构手工指标';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.zbdh is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.khdxdh is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.bz is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.sdbs is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.tjkj is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.tjrq is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.zbz is '';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_yjzb_jgsgzb.etl_timestamp is 'ETL处理时间戳';
