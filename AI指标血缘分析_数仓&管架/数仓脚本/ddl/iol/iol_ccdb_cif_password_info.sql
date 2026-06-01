/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_cif_password_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_cif_password_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_cif_password_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_cif_password_info(
    id number(22) -- 流水号
    ,customer_no varchar2(50) -- 客户号
    ,business_type varchar2(4) -- 业务类型
    ,password_type varchar2(4) -- 密码类型
    ,status varchar2(4) -- 状态
    ,update_date date -- 更新日期
    ,version number(22) -- 版本号
    ,card_no varchar2(30) -- 账号
    ,password varchar2(50) -- 密码（密文）
    ,from_channel varchar2(50) -- 请求渠道
    ,verify_error_num number(22) -- 验证错误次数
    ,verify_record_date date -- 验证日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ccdb_cif_password_info to ${iml_schema};
grant select on ${iol_schema}.ccdb_cif_password_info to ${icl_schema};
grant select on ${iol_schema}.ccdb_cif_password_info to ${idl_schema};
grant select on ${iol_schema}.ccdb_cif_password_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_cif_password_info is '电话银行系统';
comment on column ${iol_schema}.ccdb_cif_password_info.id is '流水号';
comment on column ${iol_schema}.ccdb_cif_password_info.customer_no is '客户号';
comment on column ${iol_schema}.ccdb_cif_password_info.business_type is '业务类型';
comment on column ${iol_schema}.ccdb_cif_password_info.password_type is '密码类型';
comment on column ${iol_schema}.ccdb_cif_password_info.status is '状态';
comment on column ${iol_schema}.ccdb_cif_password_info.update_date is '更新日期';
comment on column ${iol_schema}.ccdb_cif_password_info.version is '版本号';
comment on column ${iol_schema}.ccdb_cif_password_info.card_no is '账号';
comment on column ${iol_schema}.ccdb_cif_password_info.password is '密码（密文）';
comment on column ${iol_schema}.ccdb_cif_password_info.from_channel is '请求渠道';
comment on column ${iol_schema}.ccdb_cif_password_info.verify_error_num is '验证错误次数';
comment on column ${iol_schema}.ccdb_cif_password_info.verify_record_date is '验证日期';
comment on column ${iol_schema}.ccdb_cif_password_info.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_cif_password_info.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_cif_password_info.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_cif_password_info.etl_timestamp is 'ETL处理时间戳';
