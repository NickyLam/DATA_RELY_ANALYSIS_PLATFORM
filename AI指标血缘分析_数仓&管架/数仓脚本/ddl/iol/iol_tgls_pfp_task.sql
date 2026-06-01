/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_pfp_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_pfp_task
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_pfp_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pfp_task(
    stacid number(19) -- 账套
    ,acptyr varchar2(4) -- 年份
    ,brchcd varchar2(12) -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
    ,middit varchar2(30) -- 利润分配的中间科目编号,如利润分配-提取盈余公积
    ,resuit varchar2(30) -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
    ,orderi number -- 分配顺序号
    ,pfrtvl number(19,3) -- 利润分配比例百分数
    ,remark varchar2(300) -- 备注
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
grant select on ${iol_schema}.tgls_pfp_task to ${iml_schema};
grant select on ${iol_schema}.tgls_pfp_task to ${icl_schema};
grant select on ${iol_schema}.tgls_pfp_task to ${idl_schema};
grant select on ${iol_schema}.tgls_pfp_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_pfp_task is '年底利润分配配置表';
comment on column ${iol_schema}.tgls_pfp_task.stacid is '账套';
comment on column ${iol_schema}.tgls_pfp_task.acptyr is '年份';
comment on column ${iol_schema}.tgls_pfp_task.brchcd is '机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)';
comment on column ${iol_schema}.tgls_pfp_task.middit is '利润分配的中间科目编号,如利润分配-提取盈余公积';
comment on column ${iol_schema}.tgls_pfp_task.resuit is '利润分配的最终科目编号,如盈余公积-一般盈余公积';
comment on column ${iol_schema}.tgls_pfp_task.orderi is '分配顺序号';
comment on column ${iol_schema}.tgls_pfp_task.pfrtvl is '利润分配比例百分数';
comment on column ${iol_schema}.tgls_pfp_task.remark is '备注';
comment on column ${iol_schema}.tgls_pfp_task.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_pfp_task.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_pfp_task.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_pfp_task.etl_timestamp is 'ETL处理时间戳';
