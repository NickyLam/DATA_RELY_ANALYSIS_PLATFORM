/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khfa_level_manage
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khfa_level_manage
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khfa_level_manage purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khfa_level_manage(
    khnf number(22) -- 考核年份
    ,fabh number(22) -- 方案编号
    ,jg varchar2(300) -- 结构
    ,lx varchar2(6) -- 类型
    ,khzbbh number(22) -- 考核指标编号
    ,khpl varchar2(6) -- 考核频率
    ,dfly varchar2(300) -- 得分来源
    ,xh number(22) -- 序号
    ,czr number(22) -- 操作人
    ,czsj date -- 操作时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_khfa_level_manage to ${iml_schema};
grant select on ${iol_schema}.pams_khfa_level_manage to ${icl_schema};
grant select on ${iol_schema}.pams_khfa_level_manage to ${idl_schema};
grant select on ${iol_schema}.pams_khfa_level_manage to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khfa_level_manage is '考核方案层级管理';
comment on column ${iol_schema}.pams_khfa_level_manage.khnf is '考核年份';
comment on column ${iol_schema}.pams_khfa_level_manage.fabh is '方案编号';
comment on column ${iol_schema}.pams_khfa_level_manage.jg is '结构';
comment on column ${iol_schema}.pams_khfa_level_manage.lx is '类型';
comment on column ${iol_schema}.pams_khfa_level_manage.khzbbh is '考核指标编号';
comment on column ${iol_schema}.pams_khfa_level_manage.khpl is '考核频率';
comment on column ${iol_schema}.pams_khfa_level_manage.dfly is '得分来源';
comment on column ${iol_schema}.pams_khfa_level_manage.xh is '序号';
comment on column ${iol_schema}.pams_khfa_level_manage.czr is '操作人';
comment on column ${iol_schema}.pams_khfa_level_manage.czsj is '操作时间';
comment on column ${iol_schema}.pams_khfa_level_manage.start_dt is '开始时间';
comment on column ${iol_schema}.pams_khfa_level_manage.end_dt is '结束时间';
comment on column ${iol_schema}.pams_khfa_level_manage.id_mark is '增删标志';
comment on column ${iol_schema}.pams_khfa_level_manage.etl_timestamp is 'ETL处理时间戳';
