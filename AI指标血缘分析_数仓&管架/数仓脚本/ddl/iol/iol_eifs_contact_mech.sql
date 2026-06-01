/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_contact_mech
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_contact_mech
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_contact_mech purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_contact_mech(
    contact_mech_id varchar2(30) -- 联系机制编号
    ,contact_mech_type_id varchar2(30) -- 联系机制类型编号
    ,info_string varchar2(383) -- 信息描述
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
grant select on ${iol_schema}.eifs_contact_mech to ${iml_schema};
grant select on ${iol_schema}.eifs_contact_mech to ${icl_schema};
grant select on ${iol_schema}.eifs_contact_mech to ${idl_schema};
grant select on ${iol_schema}.eifs_contact_mech to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_contact_mech is '联系机制表';
comment on column ${iol_schema}.eifs_contact_mech.contact_mech_id is '联系机制编号';
comment on column ${iol_schema}.eifs_contact_mech.contact_mech_type_id is '联系机制类型编号';
comment on column ${iol_schema}.eifs_contact_mech.info_string is '信息描述';
comment on column ${iol_schema}.eifs_contact_mech.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_contact_mech.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_contact_mech.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_contact_mech.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_contact_mech.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_contact_mech.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_contact_mech.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_contact_mech.etl_timestamp is 'ETL处理时间戳';
