/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_yjzb_hy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_yjzb_hy_recal
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_yjzb_hy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_yjzb_hy_recal(
    etl_dt date
    ,tjrq number(22)
    ,recal_dt number(22)
    ,zbdh number(22)
    ,sdbs varchar2(3)
    ,bz varchar2(9)
    ,khdxdh number(22)
    ,zbz number(25,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_yjzb_hy_recal to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_yjzb_hy_recal is '业绩指标-行员_重算';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.tjrq is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.recal_dt is '重算日期';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.zbdh is '指标编号';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.sdbs is '时段标识';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.bz is '币种代码';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_yjzb_hy_recal.zbz is '指标结果';
