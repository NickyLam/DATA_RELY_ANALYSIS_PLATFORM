/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_khfa_khzb_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_khfa_khzb_jg
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_khfa_khzb_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_khfa_khzb_jg(
    etl_dt date
    ,khzbdh number(22)
    ,khzbmc varchar2(150)
    ,zbdh number(22)
    ,sdbs varchar2(15)
    ,bz varchar2(15)
    ,tjkj varchar2(15)
    ,zbpx number(22)
    ,ydsfzs varchar2(2)
    ,ydbm varchar2(150)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_khfa_khzb_jg to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_khfa_khzb_jg is '考核方案-考核指标-机构';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.khzbdh is '考核指标代号';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.khzbmc is '考核指标名称';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.zbdh is '指标代号';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.sdbs is '时段标识';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.bz is '币种';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.tjkj is '统计口径';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.zbpx is '指标排序';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.ydsfzs is '移动是否展示';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.ydbm is '移动别名';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.start_dt is '开始日期';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.end_dt is '结束日期';
comment on column ${msl_schema}.msl_edw_pams_khfa_khzb_jg.id_mark is '增删标志';
