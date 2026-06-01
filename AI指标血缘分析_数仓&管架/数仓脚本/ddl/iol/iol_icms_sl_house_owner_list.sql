/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sl_house_owner_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sl_house_owner_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sl_house_owner_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sl_house_owner_list(
    serialno varchar2(32) -- 主键
    ,inputdate date -- 数据记录时间
    ,serno varchar2(32) -- 流水号
    ,slhouseowner varchar2(60) -- 赎楼对应房产产权所有人
    ,slhouseownerratio varchar2(40) -- 赎楼对应房产产权所有人比例
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_sl_house_owner_list to ${iml_schema};
grant select on ${iol_schema}.icms_sl_house_owner_list to ${icl_schema};
grant select on ${iol_schema}.icms_sl_house_owner_list to ${idl_schema};
grant select on ${iol_schema}.icms_sl_house_owner_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sl_house_owner_list is '赎楼对应房产产权信息';
comment on column ${iol_schema}.icms_sl_house_owner_list.serialno is '主键';
comment on column ${iol_schema}.icms_sl_house_owner_list.inputdate is '数据记录时间';
comment on column ${iol_schema}.icms_sl_house_owner_list.serno is '流水号';
comment on column ${iol_schema}.icms_sl_house_owner_list.slhouseowner is '赎楼对应房产产权所有人';
comment on column ${iol_schema}.icms_sl_house_owner_list.slhouseownerratio is '赎楼对应房产产权所有人比例';
comment on column ${iol_schema}.icms_sl_house_owner_list.migtflag is '';
comment on column ${iol_schema}.icms_sl_house_owner_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sl_house_owner_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sl_house_owner_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sl_house_owner_list.etl_timestamp is 'ETL处理时间戳';
