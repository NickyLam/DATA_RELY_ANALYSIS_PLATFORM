/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_eg_interface_name
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_eg_interface_name
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_eg_interface_name purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_eg_interface_name(
    online_message_code varchar2(50) -- 联机接口码
    ,online_message_name varchar2(200) -- 联机接口名
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_eg_interface_name to ${iml_schema};
grant select on ${iol_schema}.ncbs_eg_interface_name to ${icl_schema};
grant select on ${iol_schema}.ncbs_eg_interface_name to ${idl_schema};
grant select on ${iol_schema}.ncbs_eg_interface_name to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_eg_interface_name is '接口名称参数表';
comment on column ${iol_schema}.ncbs_eg_interface_name.online_message_code is '联机接口码';
comment on column ${iol_schema}.ncbs_eg_interface_name.online_message_name is '联机接口名';
comment on column ${iol_schema}.ncbs_eg_interface_name.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_eg_interface_name.company is '法人';
comment on column ${iol_schema}.ncbs_eg_interface_name.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_eg_interface_name.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_eg_interface_name.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_eg_interface_name.etl_timestamp is 'ETL处理时间戳';
