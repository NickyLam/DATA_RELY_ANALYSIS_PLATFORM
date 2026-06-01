/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_jxbb_kpikhdfmx_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg(
    etl_dt date
    ,tjrq number(22)
    ,khdxdh number(22)
    ,fabh varchar2(60)
    ,famc varchar2(300)
    ,zbmc varchar2(600)
    ,bzdf number(12,6)
    ,dfsx number(25,4)
    ,dfxx number(25,4)
    ,ndmbz number(25,4)
    ,sjjdz number(25,4)
    ,js number(25,4)
    ,zbz number(25,4)
    ,jzz number(25,4)
    ,khdf number(25,4)
    ,ndwcl number(12,6)
    ,sjjdwcl number(12,6)
    ,xh number(22)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg is '绩效报表_KPI考核得分明细_机构';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.tjrq is '统计日期';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.fabh is '方案编号';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.famc is '方案名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.zbmc is '指标项名称';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.bzdf is '标准得分';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.dfsx is '得分上限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.dfxx is '得分下限';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.ndmbz is '年度目标值';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.sjjdz is '时间进度值';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.js is '基数';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.zbz is '指标值';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.jzz is '净增值';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.khdf is '考核得分';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.ndwcl is '年度完成率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.sjjdwcl is '时间进度完成率';
comment on column ${msl_schema}.msl_edw_pams_jxbb_kpikhdfmx_jg.xh is '展示序号';
