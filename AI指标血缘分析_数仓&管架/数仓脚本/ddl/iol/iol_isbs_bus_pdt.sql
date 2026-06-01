/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bus_pdt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bus_pdt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bus_pdt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bus_pdt(
    objtyp varchar2(5) -- 业务主表
    ,objinr varchar2(12) -- 业务主表主键号
    ,pdtcod5 varchar2(18) -- 可售产品号
    ,amttypcod varchar2(11) -- 
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
grant select on ${iol_schema}.isbs_bus_pdt to ${iml_schema};
grant select on ${iol_schema}.isbs_bus_pdt to ${icl_schema};
grant select on ${iol_schema}.isbs_bus_pdt to ${idl_schema};
grant select on ${iol_schema}.isbs_bus_pdt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bus_pdt is '业务可售产品表';
comment on column ${iol_schema}.isbs_bus_pdt.objtyp is '业务主表';
comment on column ${iol_schema}.isbs_bus_pdt.objinr is '业务主表主键号';
comment on column ${iol_schema}.isbs_bus_pdt.pdtcod5 is '可售产品号';
comment on column ${iol_schema}.isbs_bus_pdt.amttypcod is '';
comment on column ${iol_schema}.isbs_bus_pdt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_bus_pdt.etl_timestamp is 'ETL处理时间戳';
