/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_khfa_khzb_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_khfa_khzb_jg
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_khfa_khzb_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_khfa_khzb_jg(
    khzbdh number(22) -- 考核指标代号
    ,khzbmc varchar2(150) -- 考核指标名称
    ,zbdh number(22) -- 指标代号
    ,sdbs varchar2(15) -- 时段标识
    ,bz varchar2(15) -- 币种
    ,tjkj varchar2(15) -- 统计口径
    ,zbpx number(22) -- 指标排序
    ,ydsfzs varchar2(2) -- 移动是否展示
    ,ydbm varchar2(150) -- 移动别名
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
grant select on ${itl_schema}.itl_edw_pams_khfa_khzb_jg to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_khfa_khzb_jg is '考核方案-考核指标-机构';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.khzbdh is '考核指标代号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.khzbmc is '考核指标名称';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.zbdh is '指标代号';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.sdbs is '时段标识';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.bz is '币种';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.tjkj is '统计口径';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.zbpx is '指标排序';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.ydsfzs is '移动是否展示';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.ydbm is '移动别名';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_khfa_khzb_jg.etl_timestamp is 'ETL处理时间戳';
