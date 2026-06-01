/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ptabnmlbizinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ptabnmlbizinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ptabnmlbizinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ptabnmlbizinfo(
    transdt varchar2(12) -- 交易日期
    ,transeqno varchar2(53) -- 报文标识号
    ,no varchar2(12) -- 序号
    ,abnmlcause varchar2(600) -- 异常经营列入经营异常名录原因类型
    ,abnmldate varchar2(12) -- 异常经营列入日期
    ,abnmldcsnauth varchar2(384) -- 异常经营列入决定机关
    ,rmvcause varchar2(600) -- 异常经营移出经营异常名录原因
    ,rmvdate varchar2(12) -- 异常经营移出日期
    ,rmvdcsnauth varchar2(384) -- 异常经营移出决定机关
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
grant select on ${iol_schema}.mpcs_a1ptabnmlbizinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ptabnmlbizinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ptabnmlbizinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ptabnmlbizinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ptabnmlbizinfo is '异常经营信息登记表';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.transeqno is '报文标识号';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.no is '序号';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.abnmlcause is '异常经营列入经营异常名录原因类型';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.abnmldate is '异常经营列入日期';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.abnmldcsnauth is '异常经营列入决定机关';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.rmvcause is '异常经营移出经营异常名录原因';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.rmvdate is '异常经营移出日期';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.rmvdcsnauth is '异常经营移出决定机关';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ptabnmlbizinfo.etl_timestamp is 'ETL处理时间戳';
