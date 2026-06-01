/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_spall_client_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_spall_client_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_spall_client_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_spall_client_info(
    client_name varchar2(200) -- 客户名称
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,contact_tel varchar2(20) -- 客户联系电话
    ,expire_date date -- 失效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_tb_spall_client_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_spall_client_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_spall_client_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_spall_client_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_spall_client_info is '兑换人信息登记薄';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_spall_client_info.etl_timestamp is 'ETL处理时间戳';
