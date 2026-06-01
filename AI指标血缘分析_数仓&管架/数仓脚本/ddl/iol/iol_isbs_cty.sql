/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cty
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cty(
    inr varchar2(12) -- 
    ,cod varchar2(3) -- 
    ,cur varchar2(5) -- 
    ,reg varchar2(3) -- 
    ,ver varchar2(6) -- 
    ,fmtdomadrtyp varchar2(2) -- 
    ,fmtintadrtyp varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_cty to ${iml_schema};
grant select on ${iol_schema}.isbs_cty to ${icl_schema};
grant select on ${iol_schema}.isbs_cty to ${idl_schema};
grant select on ${iol_schema}.isbs_cty to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cty is '国家地区信息';
comment on column ${iol_schema}.isbs_cty.inr is '';
comment on column ${iol_schema}.isbs_cty.cod is '';
comment on column ${iol_schema}.isbs_cty.cur is '';
comment on column ${iol_schema}.isbs_cty.reg is '';
comment on column ${iol_schema}.isbs_cty.ver is '';
comment on column ${iol_schema}.isbs_cty.fmtdomadrtyp is '';
comment on column ${iol_schema}.isbs_cty.fmtintadrtyp is '';
comment on column ${iol_schema}.isbs_cty.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cty.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cty.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cty.etl_timestamp is 'ETL处理时间戳';
