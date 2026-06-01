/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lmis_asset_transaction_header
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lmis_asset_transaction_header
whenever sqlerror continue none;
drop table ${iol_schema}.lmis_asset_transaction_header purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_transaction_header(
    id number(38,0) -- id
    ,book_code varchar2(45) -- 账簿code
    ,asset_id number(38,0) -- 资产id
    ,transaction_number varchar2(45) -- 事物处理编号
    ,period_name varchar2(45) -- 期间
    ,transaction_type_code varchar2(30) -- 事务类型代码
    ,transaction_type_desc varchar2(45) -- 事务类型描述
    ,transaction_subtype_code varchar2(30) -- 明细事务类型代码
    ,transaction_subtype_desc varchar2(150) -- 明细事务类型描述
    ,transaction_date_entered timestamp -- 事物处理业务日期
    ,date_effective timestamp -- 事物处理有效日期（记账日期）
    ,account_flag varchar2(2) -- 会计核算标识
    ,account_status varchar2(2) -- 凭证入账状态
    ,source_code varchar2(15) -- 来源事物处理接口代码
    ,tenant_id number(38,0) -- 租户id
    ,created_by number(38,0) -- 创建人
    ,created_date timestamp -- 创建时间
    ,last_updated_by number(38,0) -- 最后更新人
    ,last_updated_date timestamp -- 最后更新时间
    ,version_number number(38,0) -- 版本号
    ,reverse_flag varchar2(2) -- 是否冲销
    ,reverse_transaction_header_id number(38,0) -- 待冲销事务id
    ,credential_create_user number(38,0) -- 凭证创建用户
    ,credential_approval_user number(38,0) -- 凭证审批用户
    ,lease_approval_status varchar2(750) -- 租赁资产审核状态
    ,error_msg varchar2(1500) -- 错误信息
    ,company_code varchar2(45) -- 
    ,company_id number(38,0) -- 
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
grant select on ${iol_schema}.lmis_asset_transaction_header to ${iml_schema};
grant select on ${iol_schema}.lmis_asset_transaction_header to ${icl_schema};
grant select on ${iol_schema}.lmis_asset_transaction_header to ${idl_schema};
grant select on ${iol_schema}.lmis_asset_transaction_header to ${iel_schema};

-- comment
comment on table ${iol_schema}.lmis_asset_transaction_header is '资产事务处理记录表';
comment on column ${iol_schema}.lmis_asset_transaction_header.id is 'id';
comment on column ${iol_schema}.lmis_asset_transaction_header.book_code is '账簿code';
comment on column ${iol_schema}.lmis_asset_transaction_header.asset_id is '资产id';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_number is '事物处理编号';
comment on column ${iol_schema}.lmis_asset_transaction_header.period_name is '期间';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_type_code is '事务类型代码';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_type_desc is '事务类型描述';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_subtype_code is '明细事务类型代码';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_subtype_desc is '明细事务类型描述';
comment on column ${iol_schema}.lmis_asset_transaction_header.transaction_date_entered is '事物处理业务日期';
comment on column ${iol_schema}.lmis_asset_transaction_header.date_effective is '事物处理有效日期（记账日期）';
comment on column ${iol_schema}.lmis_asset_transaction_header.account_flag is '会计核算标识';
comment on column ${iol_schema}.lmis_asset_transaction_header.account_status is '凭证入账状态';
comment on column ${iol_schema}.lmis_asset_transaction_header.source_code is '来源事物处理接口代码';
comment on column ${iol_schema}.lmis_asset_transaction_header.tenant_id is '租户id';
comment on column ${iol_schema}.lmis_asset_transaction_header.created_by is '创建人';
comment on column ${iol_schema}.lmis_asset_transaction_header.created_date is '创建时间';
comment on column ${iol_schema}.lmis_asset_transaction_header.last_updated_by is '最后更新人';
comment on column ${iol_schema}.lmis_asset_transaction_header.last_updated_date is '最后更新时间';
comment on column ${iol_schema}.lmis_asset_transaction_header.version_number is '版本号';
comment on column ${iol_schema}.lmis_asset_transaction_header.reverse_flag is '是否冲销';
comment on column ${iol_schema}.lmis_asset_transaction_header.reverse_transaction_header_id is '待冲销事务id';
comment on column ${iol_schema}.lmis_asset_transaction_header.credential_create_user is '凭证创建用户';
comment on column ${iol_schema}.lmis_asset_transaction_header.credential_approval_user is '凭证审批用户';
comment on column ${iol_schema}.lmis_asset_transaction_header.lease_approval_status is '租赁资产审核状态';
comment on column ${iol_schema}.lmis_asset_transaction_header.error_msg is '错误信息';
comment on column ${iol_schema}.lmis_asset_transaction_header.company_code is '';
comment on column ${iol_schema}.lmis_asset_transaction_header.company_id is '';
comment on column ${iol_schema}.lmis_asset_transaction_header.start_dt is '开始时间';
comment on column ${iol_schema}.lmis_asset_transaction_header.end_dt is '结束时间';
comment on column ${iol_schema}.lmis_asset_transaction_header.id_mark is '增删标志';
comment on column ${iol_schema}.lmis_asset_transaction_header.etl_timestamp is 'ETL处理时间戳';
