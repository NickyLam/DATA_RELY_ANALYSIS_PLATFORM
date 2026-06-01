/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_kpikhdfmx_hy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_kpikhdfmx_hy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_kpikhdfmx_hy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_kpikhdfmx_hy(
    tjrq number -- 统计日期
    ,khdxdh number -- 考核对象代号
    ,fabh varchar2(60) -- 方案编号
    ,famc varchar2(300) -- 方案名称
    ,zbmc varchar2(600) -- 指标项名称
    ,bzdf number(12,6) -- 标准得分
    ,dfsx number(25,4) -- 得分上限
    ,dfxx number(25,4) -- 得分下限
    ,ndmbz number(25,4) -- 年度目标值
    ,sjjdz number(25,4) -- 时间进度值
    ,js number(25,4) -- 基数
    ,zbz number(25,4) -- 指标值
    ,jzz number(25,4) -- 净增值
    ,khdf number(25,4) -- 考核得分
    ,ndwcl number(12,6) -- 年度完成率
    ,sjjdwcl number(12,6) -- 时间进度完成率
    ,xh number -- 展示序号
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
grant select on ${iol_schema}.pams_jxbb_kpikhdfmx_hy to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_kpikhdfmx_hy to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_kpikhdfmx_hy to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_kpikhdfmx_hy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_kpikhdfmx_hy is '绩效报表_KPI考核得分明细_行员';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.fabh is '方案编号';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.famc is '方案名称';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.zbmc is '指标项名称';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.bzdf is '标准得分';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.dfsx is '得分上限';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.dfxx is '得分下限';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.ndmbz is '年度目标值';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.sjjdz is '时间进度值';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.js is '基数';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.zbz is '指标值';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.jzz is '净增值';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.khdf is '考核得分';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.ndwcl is '年度完成率';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.sjjdwcl is '时间进度完成率';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.xh is '展示序号';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_kpikhdfmx_hy.etl_timestamp is 'ETL处理时间戳';
