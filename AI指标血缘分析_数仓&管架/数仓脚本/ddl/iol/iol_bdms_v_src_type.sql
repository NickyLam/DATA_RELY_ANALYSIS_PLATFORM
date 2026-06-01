/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_v_src_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_v_src_type
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_v_src_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_v_src_type(
    id varchar2(60) -- ID主键
    ,draft_number varchar2(45) -- 汇票号码
    ,src_type varchar2(3) -- 来源类型
    ,data_type varchar2(2) -- 数据类型
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
grant select on ${iol_schema}.bdms_v_src_type to ${iml_schema};
grant select on ${iol_schema}.bdms_v_src_type to ${icl_schema};
grant select on ${iol_schema}.bdms_v_src_type to ${idl_schema};
grant select on ${iol_schema}.bdms_v_src_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_v_src_type is '票据来源类型';
comment on column ${iol_schema}.bdms_v_src_type.id is 'ID主键';
comment on column ${iol_schema}.bdms_v_src_type.draft_number is '汇票号码';
comment on column ${iol_schema}.bdms_v_src_type.src_type is '来源类型';
comment on column ${iol_schema}.bdms_v_src_type.data_type is '数据类型';
comment on column ${iol_schema}.bdms_v_src_type.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_v_src_type.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_v_src_type.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_v_src_type.etl_timestamp is 'ETL处理时间戳';
