/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party(
    party_id varchar2(30) -- 当事人标识
    ,party_type_id varchar2(30) -- 当事人类型标识
    ,external_id varchar2(30) -- 老核心客户号
    ,preferred_currency_uom_id varchar2(30) -- 优先使用币种
    ,description varchar2(600) -- 描述
    ,status_id varchar2(30) -- 状态  创建时间
    ,created_date timestamp -- 创建日期  创建时间
    ,created_by_user_login varchar2(383) -- 创建的用户登录标识
    ,last_modified_date timestamp -- 最后修改日期
    ,last_modified_by_user_login varchar2(383) -- 最后修改的用户登录标识
    ,data_source_id varchar2(30) -- 数据源标识
    ,is_unread varchar2(2) -- 是否没有人看的
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
grant select on ${iol_schema}.eifs_party to ${iml_schema};
grant select on ${iol_schema}.eifs_party to ${icl_schema};
grant select on ${iol_schema}.eifs_party to ${idl_schema};
grant select on ${iol_schema}.eifs_party to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party is '当事人表';
comment on column ${iol_schema}.eifs_party.party_id is '当事人标识';
comment on column ${iol_schema}.eifs_party.party_type_id is '当事人类型标识';
comment on column ${iol_schema}.eifs_party.external_id is '老核心客户号';
comment on column ${iol_schema}.eifs_party.preferred_currency_uom_id is '优先使用币种';
comment on column ${iol_schema}.eifs_party.description is '描述';
comment on column ${iol_schema}.eifs_party.status_id is '状态  创建时间';
comment on column ${iol_schema}.eifs_party.created_date is '创建日期  创建时间';
comment on column ${iol_schema}.eifs_party.created_by_user_login is '创建的用户登录标识';
comment on column ${iol_schema}.eifs_party.last_modified_date is '最后修改日期';
comment on column ${iol_schema}.eifs_party.last_modified_by_user_login is '最后修改的用户登录标识';
comment on column ${iol_schema}.eifs_party.data_source_id is '数据源标识';
comment on column ${iol_schema}.eifs_party.is_unread is '是否没有人看的';
comment on column ${iol_schema}.eifs_party.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party.etl_timestamp is 'ETL处理时间戳';
