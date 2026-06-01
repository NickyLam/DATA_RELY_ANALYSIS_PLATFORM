/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_glb_exrt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_glb_exrt
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_glb_exrt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_glb_exrt(
    trandt varchar2(8) -- 维护日期
    ,crcycd varchar2(3) -- 源币种
    ,tocrcy varchar2(3) -- 目标币种
    ,exchrt number(15,8) -- 汇率
    ,exunit number(20,2) -- 折算单位
    ,stacid number(19) -- 账套
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
grant select on ${iol_schema}.tgls_glb_exrt to ${iml_schema};
grant select on ${iol_schema}.tgls_glb_exrt to ${icl_schema};
grant select on ${iol_schema}.tgls_glb_exrt to ${idl_schema};
grant select on ${iol_schema}.tgls_glb_exrt to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_glb_exrt is '折算汇率';
comment on column ${iol_schema}.tgls_glb_exrt.trandt is '维护日期';
comment on column ${iol_schema}.tgls_glb_exrt.crcycd is '源币种';
comment on column ${iol_schema}.tgls_glb_exrt.tocrcy is '目标币种';
comment on column ${iol_schema}.tgls_glb_exrt.exchrt is '汇率';
comment on column ${iol_schema}.tgls_glb_exrt.exunit is '折算单位';
comment on column ${iol_schema}.tgls_glb_exrt.stacid is '账套';
comment on column ${iol_schema}.tgls_glb_exrt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_glb_exrt.etl_timestamp is 'ETL处理时间戳';
