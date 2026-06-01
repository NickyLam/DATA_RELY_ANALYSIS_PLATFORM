/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_v_yjzb_hy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_v_yjzb_hy
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_v_yjzb_hy purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_v_yjzb_hy(
    etl_dt date
    ,tjrq number(22)
    ,zbdh number(22)
    ,sdbs varchar2(2)
    ,bz varchar2(5)
    ,khdxdh number(22)
    ,zbz number(25,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_v_yjzb_hy to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_v_yjzb_hy is '业绩指标-行员';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.zbdh is '指标代号';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.sdbs is '时段标识';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_v_yjzb_hy.zbz is '指标值';
