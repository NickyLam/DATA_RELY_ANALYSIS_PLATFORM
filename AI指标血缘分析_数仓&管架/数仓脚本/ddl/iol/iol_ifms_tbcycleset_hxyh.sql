/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbcycleset_hxyh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbcycleset_hxyh
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbcycleset_hxyh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcycleset_hxyh(
    ta_code varchar2(14) -- ta代码
    ,prd_code varchar2(30) -- 产品代码
    ,date_type varchar2(2) -- 开放日类型a-产品申购日9-产品赎回日
    ,cycle_start_date number(22,0) -- 开放开始日期
    ,cycle_end_date number(22,0) -- 开放结束日期
    ,cycle_cfm_date number(22,0) -- 开放确认日
    ,reserve1 varchar2(375) -- 备用字段1
    ,reserve2 varchar2(375) -- 备用字段2
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
grant select on ${iol_schema}.ifms_tbcycleset_hxyh to ${iml_schema};
grant select on ${iol_schema}.ifms_tbcycleset_hxyh to ${icl_schema};
grant select on ${iol_schema}.ifms_tbcycleset_hxyh to ${idl_schema};
grant select on ${iol_schema}.ifms_tbcycleset_hxyh to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbcycleset_hxyh is '华兴银行开放周期设置表';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.ta_code is 'ta代码';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.prd_code is '产品代码';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.date_type is '开放日类型a-产品申购日9-产品赎回日';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.cycle_start_date is '开放开始日期';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.cycle_end_date is '开放结束日期';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.cycle_cfm_date is '开放确认日';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.reserve1 is '备用字段1';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.reserve2 is '备用字段2';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbcycleset_hxyh.etl_timestamp is 'ETL处理时间戳';
