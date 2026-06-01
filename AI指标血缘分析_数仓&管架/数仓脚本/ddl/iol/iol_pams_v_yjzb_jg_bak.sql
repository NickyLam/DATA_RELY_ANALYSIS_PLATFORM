/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_v_yjzb_jg_bak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_v_yjzb_jg_bak
whenever sqlerror continue none;
drop table ${iol_schema}.pams_v_yjzb_jg_bak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_v_yjzb_jg_bak(
    tjrq number(22,0) -- 统计日期
    ,zbdh number(22,0) -- 指标代号
    ,sdbs varchar2(1) -- 时段标识
    ,tjkj varchar2(1) -- 统计口径
    ,bz varchar2(3) -- 币种
    ,khdxdh number(22,0) -- 考核对象代号
    ,zbz number(25,4) -- 指标值
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
grant select on ${iol_schema}.pams_v_yjzb_jg_bak to ${iml_schema};
grant select on ${iol_schema}.pams_v_yjzb_jg_bak to ${icl_schema};
grant select on ${iol_schema}.pams_v_yjzb_jg_bak to ${idl_schema};
grant select on ${iol_schema}.pams_v_yjzb_jg_bak to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_v_yjzb_jg_bak is '业绩指标-机构_重算';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.tjrq is '统计日期';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.zbdh is '指标代号';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.sdbs is '时段标识';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.tjkj is '统计口径';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.bz is '币种';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.zbz is '指标值';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_v_yjzb_jg_bak.etl_timestamp is 'ETL处理时间戳';
