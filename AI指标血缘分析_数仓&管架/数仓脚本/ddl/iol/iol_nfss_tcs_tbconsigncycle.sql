/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbconsigncycle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbconsigncycle
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbconsigncycle(
    ta_code varchar2(14) -- ta代码
    ,prd_code varchar2(30) -- 产品代码
    ,allow_type varchar2(2) -- 允许类型
    ,cycle_type varchar2(2) -- 周期类型
    ,start_date number(22,0) -- 起始日期
    ,end_date number(22,0) -- 截止日期
    ,serial_no varchar2(48) -- 方案编号
    ,int1 number(22,0) -- 备用整数1
    ,int2 number(22,0) -- 备用整数2
    ,int3 number(22,0) -- 备用整数2
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
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
grant select on ${iol_schema}.nfss_tcs_tbconsigncycle to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbconsigncycle to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbconsigncycle to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbconsigncycle to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbconsigncycle is '周期产品周期方案';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.allow_type is '允许类型';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.cycle_type is '周期类型';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.start_date is '起始日期';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.end_date is '截止日期';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.serial_no is '方案编号';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.int1 is '备用整数1';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.int2 is '备用整数2';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.int3 is '备用整数2';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.reserve1 is '保留字段1';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.reserve2 is '保留字段2';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.reserve3 is '保留字段3';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbconsigncycle.etl_timestamp is 'ETL处理时间戳';
