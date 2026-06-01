/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_field_his_regist_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_field_his_regist_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_field_his_regist_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_field_his_regist_info(
    modify_his_id varchar2(90) -- 修改历史序列号
    ,party_id varchar2(90) -- 参与人ID
    ,cust_num varchar2(48) -- 客户号
    ,cust_name varchar2(900) -- 客户名称
    ,srv_seq_num varchar2(192) -- 全局流水号
    ,glob_seq_num varchar2(192) -- 业务流水号
    ,modify_time varchar2(90) -- 更新时间
    ,create_te varchar2(90) -- 创建柜员
    ,create_org varchar2(30) -- 创建机构号
    ,init_system_id varchar2(30) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ECIF的时间
    ,updated_ts timestamp -- 在ECIF中失效的时间
    ,last_updated_te varchar2(90) -- 最新更新柜员
    ,last_updated_org varchar2(60) -- 最新更新机构号
    ,last_system_id varchar2(30) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
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
grant select on ${iol_schema}.eifs_field_his_regist_info to ${iml_schema};
grant select on ${iol_schema}.eifs_field_his_regist_info to ${icl_schema};
grant select on ${iol_schema}.eifs_field_his_regist_info to ${idl_schema};
grant select on ${iol_schema}.eifs_field_his_regist_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_field_his_regist_info is '字段修改历史登记表';
comment on column ${iol_schema}.eifs_field_his_regist_info.modify_his_id is '修改历史序列号';
comment on column ${iol_schema}.eifs_field_his_regist_info.party_id is '参与人ID';
comment on column ${iol_schema}.eifs_field_his_regist_info.cust_num is '客户号';
comment on column ${iol_schema}.eifs_field_his_regist_info.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_field_his_regist_info.srv_seq_num is '全局流水号';
comment on column ${iol_schema}.eifs_field_his_regist_info.glob_seq_num is '业务流水号';
comment on column ${iol_schema}.eifs_field_his_regist_info.modify_time is '更新时间';
comment on column ${iol_schema}.eifs_field_his_regist_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_field_his_regist_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_field_his_regist_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_field_his_regist_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_field_his_regist_info.created_ts is '进入ECIF的时间';
comment on column ${iol_schema}.eifs_field_his_regist_info.updated_ts is '在ECIF中失效的时间';
comment on column ${iol_schema}.eifs_field_his_regist_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_field_his_regist_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_field_his_regist_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_field_his_regist_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_field_his_regist_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.eifs_field_his_regist_info.etl_timestamp is 'ETL处理时间戳';
