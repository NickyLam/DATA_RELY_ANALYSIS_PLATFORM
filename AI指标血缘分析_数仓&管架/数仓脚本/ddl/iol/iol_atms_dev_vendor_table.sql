/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_vendor_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_vendor_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_vendor_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_vendor_table(
    no varchar2(15) -- 编号
    ,name varchar2(240) -- 品牌名称
    ,address varchar2(240) -- 生产商地址
    ,hotline1 varchar2(60) -- 生产商热线
    ,status varchar2(6) -- 生产商状态
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
grant select on ${iol_schema}.atms_dev_vendor_table to ${iml_schema};
grant select on ${iol_schema}.atms_dev_vendor_table to ${icl_schema};
grant select on ${iol_schema}.atms_dev_vendor_table to ${idl_schema};
grant select on ${iol_schema}.atms_dev_vendor_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_vendor_table is '设备品牌表';
comment on column ${iol_schema}.atms_dev_vendor_table.no is '编号';
comment on column ${iol_schema}.atms_dev_vendor_table.name is '品牌名称';
comment on column ${iol_schema}.atms_dev_vendor_table.address is '生产商地址';
comment on column ${iol_schema}.atms_dev_vendor_table.hotline1 is '生产商热线';
comment on column ${iol_schema}.atms_dev_vendor_table.status is '生产商状态';
comment on column ${iol_schema}.atms_dev_vendor_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_vendor_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_vendor_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_vendor_table.etl_timestamp is 'ETL处理时间戳';
