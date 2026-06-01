/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_type_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_type_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_type_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_type_table(
    no varchar2(15) -- 编号
    ,name varchar2(180) -- 设备型号
    ,dev_vendor varchar2(15) -- 所属品牌
    ,dev_catalog varchar2(15) -- 所属类型
    ,spec varchar2(60) -- 设备规格
    ,weight varchar2(30) -- 设备重量
    ,watt varchar2(30) -- 平均功率
    ,cash_type varchar2(6) -- 现金非现金标志,1.现金,2.非现金
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
grant select on ${iol_schema}.atms_dev_type_table to ${iml_schema};
grant select on ${iol_schema}.atms_dev_type_table to ${icl_schema};
grant select on ${iol_schema}.atms_dev_type_table to ${idl_schema};
grant select on ${iol_schema}.atms_dev_type_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_type_table is '设备型号表';
comment on column ${iol_schema}.atms_dev_type_table.no is '编号';
comment on column ${iol_schema}.atms_dev_type_table.name is '设备型号';
comment on column ${iol_schema}.atms_dev_type_table.dev_vendor is '所属品牌';
comment on column ${iol_schema}.atms_dev_type_table.dev_catalog is '所属类型';
comment on column ${iol_schema}.atms_dev_type_table.spec is '设备规格';
comment on column ${iol_schema}.atms_dev_type_table.weight is '设备重量';
comment on column ${iol_schema}.atms_dev_type_table.watt is '平均功率';
comment on column ${iol_schema}.atms_dev_type_table.cash_type is '现金非现金标志,1.现金,2.非现金';
comment on column ${iol_schema}.atms_dev_type_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_type_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_type_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_type_table.etl_timestamp is 'ETL处理时间戳';
