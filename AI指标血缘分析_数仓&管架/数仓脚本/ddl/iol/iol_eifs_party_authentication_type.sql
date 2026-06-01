/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_authentication_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_authentication_type
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_authentication_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_authentication_type(
    party_id varchar2(30) -- 当事人类型
    ,authentication_type varchar2(30) -- 认证方式
    ,is_authentication varchar2(30) -- 是否认证
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.eifs_party_authentication_type to ${iml_schema};
grant select on ${iol_schema}.eifs_party_authentication_type to ${icl_schema};
grant select on ${iol_schema}.eifs_party_authentication_type to ${idl_schema};
grant select on ${iol_schema}.eifs_party_authentication_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_authentication_type is '当事人认证方式记录表';
comment on column ${iol_schema}.eifs_party_authentication_type.party_id is '当事人类型';
comment on column ${iol_schema}.eifs_party_authentication_type.authentication_type is '认证方式';
comment on column ${iol_schema}.eifs_party_authentication_type.is_authentication is '是否认证';
comment on column ${iol_schema}.eifs_party_authentication_type.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party_authentication_type.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_authentication_type.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_authentication_type.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_authentication_type.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_authentication_type.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_authentication_type.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_authentication_type.etl_timestamp is 'ETL处理时间戳';
