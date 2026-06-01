/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_dtlfreevalue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_dtlfreevalue
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_dtlfreevalue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_dtlfreevalue(
    pk_dtlfreevalue varchar2(30) -- 分录自定义项主键
    ,dr number(10) -- 删除标志
    ,freevalue1 varchar2(60) -- 对方类型
    ,freevalue10 varchar2(60) -- 预留字段10
    ,freevalue11 varchar2(60) -- 预留字段11
    ,freevalue12 varchar2(60) -- 预留字段12
    ,freevalue13 varchar2(60) -- 预留字段13
    ,freevalue14 varchar2(60) -- 预留字段14
    ,freevalue15 varchar2(60) -- 预留字段15
    ,freevalue16 varchar2(60) -- 预留字段16
    ,freevalue17 varchar2(60) -- 预留字段17
    ,freevalue18 varchar2(60) -- 预留字段18
    ,freevalue19 varchar2(60) -- 预留字段19
    ,freevalue2 varchar2(60) -- 人员
    ,freevalue20 varchar2(60) -- 预留字段20
    ,freevalue21 varchar2(300) -- 预留字段21
    ,freevalue22 varchar2(300) -- 预留字段22
    ,freevalue23 varchar2(300) -- 预留字段23
    ,freevalue24 varchar2(300) -- 预留字段24
    ,freevalue25 varchar2(300) -- 预留字段25
    ,freevalue26 varchar2(750) -- 预留字段26
    ,freevalue27 varchar2(750) -- 预留字段27
    ,freevalue28 varchar2(750) -- 预留字段28
    ,freevalue29 varchar2(750) -- 预留字段29
    ,freevalue3 varchar2(60) -- 个人银行账户
    ,freevalue30 varchar2(750) -- 预留字段30
    ,freevalue4 varchar2(60) -- 预留字段4
    ,freevalue5 varchar2(60) -- 供应商
    ,freevalue6 varchar2(60) -- 供应商银行账户
    ,freevalue7 varchar2(60) -- 预留字段7
    ,freevalue8 varchar2(60) -- 预留字段8
    ,freevalue9 varchar2(60) -- 预留字段9
    ,pk_detail varchar2(30) -- 分录标识
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.iers_gl_dtlfreevalue to ${iml_schema};
grant select on ${iol_schema}.iers_gl_dtlfreevalue to ${icl_schema};
grant select on ${iol_schema}.iers_gl_dtlfreevalue to ${idl_schema};
grant select on ${iol_schema}.iers_gl_dtlfreevalue to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_dtlfreevalue is '分录自定义项';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.pk_dtlfreevalue is '分录自定义项主键';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.dr is '删除标志';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue1 is '对方类型';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue10 is '预留字段10';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue11 is '预留字段11';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue12 is '预留字段12';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue13 is '预留字段13';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue14 is '预留字段14';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue15 is '预留字段15';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue16 is '预留字段16';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue17 is '预留字段17';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue18 is '预留字段18';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue19 is '预留字段19';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue2 is '人员';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue20 is '预留字段20';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue21 is '预留字段21';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue22 is '预留字段22';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue23 is '预留字段23';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue24 is '预留字段24';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue25 is '预留字段25';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue26 is '预留字段26';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue27 is '预留字段27';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue28 is '预留字段28';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue29 is '预留字段29';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue3 is '个人银行账户';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue30 is '预留字段30';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue4 is '预留字段4';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue5 is '供应商';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue6 is '供应商银行账户';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue7 is '预留字段7';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue8 is '预留字段8';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.freevalue9 is '预留字段9';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.pk_detail is '分录标识';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.ts is '时间戳';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iers_gl_dtlfreevalue.etl_timestamp is 'ETL处理时间戳';
