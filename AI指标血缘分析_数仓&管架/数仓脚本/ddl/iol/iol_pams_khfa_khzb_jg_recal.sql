/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khfa_khzb_jg_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khfa_khzb_jg_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khfa_khzb_jg_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khfa_khzb_jg_recal(
    tjrq number(22) -- 统计日期
    ,khzbdh number(22) -- 考核指标代号
    ,khzbmc varchar2(300) -- 考核指标名称
    ,zbdh number(22) -- 指标代号
    ,sdbs varchar2(30) -- 时段标识
    ,bz varchar2(30) -- 币种
    ,tjkj varchar2(30) -- 统计口径
    ,zbpx number(22) -- 指标排序
    ,ydsfzs varchar2(3) -- 移动是否展示
    ,ydbm varchar2(300) -- 移动别名
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_khfa_khzb_jg_recal to ${iml_schema};
grant select on ${iol_schema}.pams_khfa_khzb_jg_recal to ${icl_schema};
grant select on ${iol_schema}.pams_khfa_khzb_jg_recal to ${idl_schema};
grant select on ${iol_schema}.pams_khfa_khzb_jg_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khfa_khzb_jg_recal is '考核方案-考核指标-机构_重算';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.khzbdh is '考核指标代号';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.khzbmc is '考核指标名称';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.zbdh is '指标代号';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.sdbs is '时段标识';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.bz is '币种';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.tjkj is '统计口径';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.zbpx is '指标排序';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.ydsfzs is '移动是否展示';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.ydbm is '移动别名';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_khfa_khzb_jg_recal.etl_timestamp is 'ETL处理时间戳';
