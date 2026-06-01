/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_khdx_zb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_khdx_zb
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_khdx_zb purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_khdx_zb(
    zbdh number(22) -- 指标代号
    ,zbmc varchar2(300) -- 指标名称
    ,zbdw varchar2(15) -- 指标单位
    ,zbjb varchar2(2) -- 指标级别
    ,whfs varchar2(2) -- 维护方式
    ,sfxs varchar2(2) -- 是否显示
    ,ddsx number(22) -- 调度顺序
    ,zbpx number(22) -- 指标排序
    ,zbcc varchar2(3) -- 指标层次
    ,ddlb varchar2(150) -- 调度类别
    ,jspl varchar2(2) -- 计算频率
    ,sjzb number(22) -- 上级指标
    ,zbzt varchar2(2) -- 指标状态
    ,dlbz varchar2(2) -- 定量标准
    ,xszbdh number(22) -- 显示指标代号
    ,kzlx varchar2(3) -- 扩展类型
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
grant select on ${itl_schema}.itl_edw_pams_khdx_zb to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_khdx_zb is '考核对象-指标';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbdh is '指标代号';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbmc is '指标名称';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbdw is '指标单位';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbjb is '指标级别';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.whfs is '维护方式';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.sfxs is '是否显示';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.ddsx is '调度顺序';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbpx is '指标排序';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbcc is '指标层次';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.ddlb is '调度类别';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.jspl is '计算频率';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.sjzb is '上级指标';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.zbzt is '指标状态';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.dlbz is '定量标准';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.xszbdh is '显示指标代号';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.kzlx is '扩展类型';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_khdx_zb.etl_timestamp is 'ETL处理时间戳';
