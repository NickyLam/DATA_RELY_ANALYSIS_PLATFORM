/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_dmms
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_dmms
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_dmms purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_dmms(
    dmmc varchar2(45) -- 
    ,dmz varchar2(90) -- 代码值
    ,dmms varchar2(600) -- 代码描述
    ,dmsm varchar2(1500) -- 代码说明
    ,xh number -- 序号
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
grant select on ${iol_schema}.pams_csb_dmms to ${iml_schema};
grant select on ${iol_schema}.pams_csb_dmms to ${icl_schema};
grant select on ${iol_schema}.pams_csb_dmms to ${idl_schema};
grant select on ${iol_schema}.pams_csb_dmms to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_dmms is '参数表-代码描述';
comment on column ${iol_schema}.pams_csb_dmms.dmmc is '';
comment on column ${iol_schema}.pams_csb_dmms.dmz is '代码值';
comment on column ${iol_schema}.pams_csb_dmms.dmms is '代码描述';
comment on column ${iol_schema}.pams_csb_dmms.dmsm is '代码说明';
comment on column ${iol_schema}.pams_csb_dmms.xh is '序号';
comment on column ${iol_schema}.pams_csb_dmms.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_csb_dmms.etl_timestamp is 'ETL处理时间戳';
