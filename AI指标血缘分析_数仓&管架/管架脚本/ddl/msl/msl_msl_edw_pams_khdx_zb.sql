/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_khdx_zb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_khdx_zb
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_khdx_zb purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_khdx_zb(
    etl_dt date
    ,zbdh number(22)
    ,zbmc varchar2(300)
    ,zbdw varchar2(15)
    ,zbjb varchar2(2)
    ,whfs varchar2(2)
    ,sfxs varchar2(2)
    ,ddsx number(22)
    ,zbpx number(22)
    ,zbcc varchar2(3)
    ,ddlb varchar2(150)
    ,jspl varchar2(2)
    ,sjzb number(22)
    ,zbzt varchar2(2)
    ,dlbz varchar2(2)
    ,xszbdh number(22)
    ,kzlx varchar2(3)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_khdx_zb to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_khdx_zb is '考核对象-指标';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbdh is '指标代号';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbmc is '指标名称';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbdw is '指标单位';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbjb is '指标级别';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.whfs is '维护方式';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.sfxs is '是否显示';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.ddsx is '调度顺序';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbpx is '指标排序';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbcc is '指标层次';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.ddlb is '调度类别';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.jspl is '计算频率';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.sjzb is '上级指标';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.zbzt is '指标状态';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.dlbz is '定量标准';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.xszbdh is '显示指标代号';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.kzlx is '扩展类型';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.start_dt is '开始时间';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.end_dt is '结束时间';
comment on column ${msl_schema}.msl_edw_pams_khdx_zb.id_mark is '增删标志';
