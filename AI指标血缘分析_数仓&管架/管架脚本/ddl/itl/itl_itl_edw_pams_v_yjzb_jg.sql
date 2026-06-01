/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_v_yjzb_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_v_yjzb_jg
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_v_yjzb_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_v_yjzb_jg(
    tjrq number(22) -- 统计日期
    ,zbdh number(22) -- 指标代号
    ,sdbs varchar2(2) -- 时段标识
    ,tjkj varchar2(2) -- 统计口径
    ,bz varchar2(5) -- 币种
    ,khdxdh number(22) -- 考核对象代号
    ,zbz number(25,4) -- 指标值
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pams_v_yjzb_jg to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_v_yjzb_jg is '业绩指标-机构';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.tjrq is '统计日期';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.zbdh is '指标代号';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.sdbs is '时段标识';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.tjkj is '统计口径';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.bz is '币种';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.khdxdh is '考核对象代号';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.zbz is '指标值';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_v_yjzb_jg.etl_timestamp is 'ETL处理时间戳';
