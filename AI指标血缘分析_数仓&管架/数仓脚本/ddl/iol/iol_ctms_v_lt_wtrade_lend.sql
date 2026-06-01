/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_v_lt_wtrade_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_v_lt_wtrade_lend
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_v_lt_wtrade_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_v_lt_wtrade_lend(
    wtrade_lend_id number(22,0) -- 主键
    ,wtrade_lend_id_grand number(38,0) -- 最早发生交易的deal_id
    ,wtrade_lend_id_max number(22,0) -- 最新发生交易的deal_id
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
grant select on ${iol_schema}.ctms_v_lt_wtrade_lend to ${iml_schema};
grant select on ${iol_schema}.ctms_v_lt_wtrade_lend to ${icl_schema};
grant select on ${iol_schema}.ctms_v_lt_wtrade_lend to ${idl_schema};
grant select on ${iol_schema}.ctms_v_lt_wtrade_lend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_v_lt_wtrade_lend is '';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.wtrade_lend_id is '主键';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.wtrade_lend_id_grand is '最早发生交易的deal_id';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.wtrade_lend_id_max is '最新发生交易的deal_id';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_v_lt_wtrade_lend.etl_timestamp is 'ETL处理时间戳';
