/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_kmzz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_kmzz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_kmzz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_kmzz(
    zzrq number -- 总账日期
    ,kmh varchar2(60) -- 科目号
    ,jgdh varchar2(30) -- 机构代号
    ,bz varchar2(9) -- 币种
    ,jffse number(25,4) -- 借方发生额
    ,dffse number(25,4) -- 贷方发生额
    ,sqjfye number(25,4) -- 上期借方余额
    ,sqdfye number(25,4) -- 上期贷方余额
    ,jfye number(25,4) -- 借方余额
    ,dfye number(25,4) -- 贷方余额
    ,kmye number(25,4) -- 科目余额
    ,drkmye number(25,4) -- 当日科目余额
    ,cph varchar2(270) -- 产品号
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
grant select on ${iol_schema}.pams_jxdx_kmzz to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_kmzz to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_kmzz to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_kmzz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_kmzz is '绩效对象_科目总账';
comment on column ${iol_schema}.pams_jxdx_kmzz.zzrq is '总账日期';
comment on column ${iol_schema}.pams_jxdx_kmzz.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_kmzz.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_kmzz.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_kmzz.jffse is '借方发生额';
comment on column ${iol_schema}.pams_jxdx_kmzz.dffse is '贷方发生额';
comment on column ${iol_schema}.pams_jxdx_kmzz.sqjfye is '上期借方余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.sqdfye is '上期贷方余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.jfye is '借方余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.dfye is '贷方余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.kmye is '科目余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.drkmye is '当日科目余额';
comment on column ${iol_schema}.pams_jxdx_kmzz.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_kmzz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_kmzz.etl_timestamp is 'ETL处理时间戳';
