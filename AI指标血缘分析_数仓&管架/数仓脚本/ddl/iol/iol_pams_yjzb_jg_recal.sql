/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_yjzb_jg_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_yjzb_jg_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_yjzb_jg_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_yjzb_jg_recal(
    tjrq number(22) -- 数据日期
    ,recal_dt number(22) -- 重算日期
    ,zbdh number(22) -- 指标编号
    ,sdbs varchar2(3) -- 时段标识
    ,tjkj varchar2(3) -- 统计口径
    ,bz varchar2(9) -- 币种代码
    ,khdxdh number(22) -- 考核对象代号
    ,zbz number(25,4) -- 指标结果
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
grant select on ${iol_schema}.pams_yjzb_jg_recal to ${iml_schema};
grant select on ${iol_schema}.pams_yjzb_jg_recal to ${icl_schema};
grant select on ${iol_schema}.pams_yjzb_jg_recal to ${idl_schema};
grant select on ${iol_schema}.pams_yjzb_jg_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_yjzb_jg_recal is '业绩指标-机构_重算';
comment on column ${iol_schema}.pams_yjzb_jg_recal.tjrq is '数据日期';
comment on column ${iol_schema}.pams_yjzb_jg_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_yjzb_jg_recal.zbdh is '指标编号';
comment on column ${iol_schema}.pams_yjzb_jg_recal.sdbs is '时段标识';
comment on column ${iol_schema}.pams_yjzb_jg_recal.tjkj is '统计口径';
comment on column ${iol_schema}.pams_yjzb_jg_recal.bz is '币种代码';
comment on column ${iol_schema}.pams_yjzb_jg_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_yjzb_jg_recal.zbz is '指标结果';
comment on column ${iol_schema}.pams_yjzb_jg_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_yjzb_jg_recal.etl_timestamp is 'ETL处理时间戳';
