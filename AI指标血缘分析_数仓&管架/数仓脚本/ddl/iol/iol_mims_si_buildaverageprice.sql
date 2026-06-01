/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_buildaverageprice
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_buildaverageprice
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_buildaverageprice purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_buildaverageprice(
    avgpricedate varchar2(15) -- 
    ,seqno varchar2(45) -- 
    ,guartype varchar2(30) -- 
    ,province varchar2(15) -- 
    ,city varchar2(15) -- 
    ,counties varchar2(15) -- 
    ,street varchar2(90) -- 
    ,roodname varchar2(150) -- 
    ,roomno varchar2(90) -- 
    ,buildingname varchar2(150) -- 
    ,buildingno varchar2(90) -- 
    ,buildingarea number(16,2) -- 
    ,limitinfo number(22) -- 
    ,outevaldate varchar2(15) -- 
    ,evaldate varchar2(15) -- 
    ,avgprice number(16,2) -- 
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
grant select on ${iol_schema}.mims_si_buildaverageprice to ${iml_schema};
grant select on ${iol_schema}.mims_si_buildaverageprice to ${icl_schema};
grant select on ${iol_schema}.mims_si_buildaverageprice to ${idl_schema};
grant select on ${iol_schema}.mims_si_buildaverageprice to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_buildaverageprice is '楼盘均价信息表';
comment on column ${iol_schema}.mims_si_buildaverageprice.avgpricedate is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.seqno is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.guartype is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.province is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.city is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.counties is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.street is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.roodname is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.roomno is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.buildingname is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.buildingno is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.buildingarea is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.limitinfo is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.outevaldate is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.evaldate is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.avgprice is '';
comment on column ${iol_schema}.mims_si_buildaverageprice.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mims_si_buildaverageprice.etl_timestamp is 'ETL处理时间戳';
