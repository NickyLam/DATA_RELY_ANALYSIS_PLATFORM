/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_responsor_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_responsor_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_responsor_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_responsor_table(
    logic_id varchar2(36) -- 编号
    ,dev_no varchar2(20) -- 设备号
    ,catalog varchar2(2) -- 责任人分类
    ,grade varchar2(2) -- 责任人级别
    ,responser_no varchar2(40) -- 责任人编号
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
grant select on ${iol_schema}.atms_dev_responsor_table to ${iml_schema};
grant select on ${iol_schema}.atms_dev_responsor_table to ${icl_schema};
grant select on ${iol_schema}.atms_dev_responsor_table to ${idl_schema};
grant select on ${iol_schema}.atms_dev_responsor_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_responsor_table is '设备责任人表';
comment on column ${iol_schema}.atms_dev_responsor_table.logic_id is '编号';
comment on column ${iol_schema}.atms_dev_responsor_table.dev_no is '设备号';
comment on column ${iol_schema}.atms_dev_responsor_table.catalog is '责任人分类';
comment on column ${iol_schema}.atms_dev_responsor_table.grade is '责任人级别';
comment on column ${iol_schema}.atms_dev_responsor_table.responser_no is '责任人编号';
comment on column ${iol_schema}.atms_dev_responsor_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_responsor_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_responsor_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_responsor_table.etl_timestamp is 'ETL处理时间戳';
