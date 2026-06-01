/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tk_management_data_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tk_management_data_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tk_management_data_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tk_management_data_detail(
    messageserialno varchar2(32) -- 关联TK_MANAGEMENT_MESSAGE主键
    ,field1 varchar2(2000) -- 字段1
    ,field2 varchar2(2000) -- 字段2
    ,field3 varchar2(2000) -- 字段3
    ,field4 varchar2(2000) -- 字段4
    ,field5 varchar2(2000) -- 字段5
    ,field6 varchar2(2000) -- 字段6
    ,field7 varchar2(2000) -- 字段7
    ,field8 varchar2(2000) -- 字段8
    ,field9 varchar2(2000) -- 字段9
    ,field10 varchar2(2000) -- 字段10
    ,field11 varchar2(2000) -- 字段11
    ,field12 varchar2(2000) -- 字段12
    ,field13 varchar2(2000) -- 字段13
    ,field14 varchar2(2000) -- 字段14
    ,field15 varchar2(2000) -- 字段15
    ,field16 varchar2(2000) -- 字段16
    ,field17 varchar2(2000) -- 字段17
    ,field18 varchar2(2000) -- 字段18
    ,field19 varchar2(2000) -- 字段19
    ,field20 varchar2(2000) -- 字段20
    ,inputdate date -- 登记日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_tk_management_data_detail to ${iml_schema};
grant select on ${iol_schema}.icms_tk_management_data_detail to ${icl_schema};
grant select on ${iol_schema}.icms_tk_management_data_detail to ${idl_schema};
grant select on ${iol_schema}.icms_tk_management_data_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tk_management_data_detail is '经营平台推送数据明细表';
comment on column ${iol_schema}.icms_tk_management_data_detail.messageserialno is '关联TK_MANAGEMENT_MESSAGE主键';
comment on column ${iol_schema}.icms_tk_management_data_detail.field1 is '字段1';
comment on column ${iol_schema}.icms_tk_management_data_detail.field2 is '字段2';
comment on column ${iol_schema}.icms_tk_management_data_detail.field3 is '字段3';
comment on column ${iol_schema}.icms_tk_management_data_detail.field4 is '字段4';
comment on column ${iol_schema}.icms_tk_management_data_detail.field5 is '字段5';
comment on column ${iol_schema}.icms_tk_management_data_detail.field6 is '字段6';
comment on column ${iol_schema}.icms_tk_management_data_detail.field7 is '字段7';
comment on column ${iol_schema}.icms_tk_management_data_detail.field8 is '字段8';
comment on column ${iol_schema}.icms_tk_management_data_detail.field9 is '字段9';
comment on column ${iol_schema}.icms_tk_management_data_detail.field10 is '字段10';
comment on column ${iol_schema}.icms_tk_management_data_detail.field11 is '字段11';
comment on column ${iol_schema}.icms_tk_management_data_detail.field12 is '字段12';
comment on column ${iol_schema}.icms_tk_management_data_detail.field13 is '字段13';
comment on column ${iol_schema}.icms_tk_management_data_detail.field14 is '字段14';
comment on column ${iol_schema}.icms_tk_management_data_detail.field15 is '字段15';
comment on column ${iol_schema}.icms_tk_management_data_detail.field16 is '字段16';
comment on column ${iol_schema}.icms_tk_management_data_detail.field17 is '字段17';
comment on column ${iol_schema}.icms_tk_management_data_detail.field18 is '字段18';
comment on column ${iol_schema}.icms_tk_management_data_detail.field19 is '字段19';
comment on column ${iol_schema}.icms_tk_management_data_detail.field20 is '字段20';
comment on column ${iol_schema}.icms_tk_management_data_detail.inputdate is '登记日期';
comment on column ${iol_schema}.icms_tk_management_data_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tk_management_data_detail.etl_timestamp is 'ETL处理时间戳';
