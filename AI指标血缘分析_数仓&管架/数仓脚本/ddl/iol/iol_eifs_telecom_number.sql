/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_telecom_number
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_telecom_number
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_telecom_number purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_telecom_number(
    contact_mech_id varchar2(30) -- 联系机制编号
    ,country_code varchar2(15) -- 国家代码
    ,area_code varchar2(15) -- 地区代码
    ,contact_number varchar2(90) -- 联系号码
    ,ask_for_name varchar2(150) -- 问候名称
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,contact_channel varchar2(15) -- 
    ,contact_date varchar2(15) -- 
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
grant select on ${iol_schema}.eifs_telecom_number to ${iml_schema};
grant select on ${iol_schema}.eifs_telecom_number to ${icl_schema};
grant select on ${iol_schema}.eifs_telecom_number to ${idl_schema};
grant select on ${iol_schema}.eifs_telecom_number to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_telecom_number is '电话号码表';
comment on column ${iol_schema}.eifs_telecom_number.contact_mech_id is '联系机制编号';
comment on column ${iol_schema}.eifs_telecom_number.country_code is '国家代码';
comment on column ${iol_schema}.eifs_telecom_number.area_code is '地区代码';
comment on column ${iol_schema}.eifs_telecom_number.contact_number is '联系号码';
comment on column ${iol_schema}.eifs_telecom_number.ask_for_name is '问候名称';
comment on column ${iol_schema}.eifs_telecom_number.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_telecom_number.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_telecom_number.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_telecom_number.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_telecom_number.contact_channel is '';
comment on column ${iol_schema}.eifs_telecom_number.contact_date is '';
comment on column ${iol_schema}.eifs_telecom_number.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_telecom_number.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_telecom_number.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_telecom_number.etl_timestamp is 'ETL处理时间戳';
