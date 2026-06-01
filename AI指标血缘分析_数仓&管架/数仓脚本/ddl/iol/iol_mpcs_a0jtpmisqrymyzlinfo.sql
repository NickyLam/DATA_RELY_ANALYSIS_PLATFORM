/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0jtpmisqrymyzlinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,modifydttm varchar2(21) -- 修改日期时间
    ,year_month varchar2(9) -- 年月
    ,currency_code varchar2(5) -- 币种
    ,exchange varchar2(27) -- 折算率
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
grant select on ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo is '';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.modifydttm is '修改日期时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.year_month is '年月';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.currency_code is '币种';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.exchange is '折算率';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0jtpmisqrymyzlinfo.etl_timestamp is 'ETL处理时间戳';
