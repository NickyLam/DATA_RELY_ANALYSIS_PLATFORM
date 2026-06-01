/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bail_repayment_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bail_repayment_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bail_repayment_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bail_repayment_info(
    id varchar2(60) -- ID主键
    ,draft_number varchar2(45) -- 票据号码
    ,draft_id varchar2(60) -- 票据ID
    ,base_acct_no varchar2(45) -- 备款账号
    ,acct_seq_no varchar2(8) -- 子账户序号
    ,reserve_amt number(16,2) -- 备款金额
    ,reserve_status varchar2(5) -- 备款状态
    ,reserve_date varchar2(12) -- 备款日期
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
grant select on ${iol_schema}.bdms_bail_repayment_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bail_repayment_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bail_repayment_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bail_repayment_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bail_repayment_info is '备款信息表';
comment on column ${iol_schema}.bdms_bail_repayment_info.id is 'ID主键';
comment on column ${iol_schema}.bdms_bail_repayment_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_bail_repayment_info.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bail_repayment_info.base_acct_no is '备款账号';
comment on column ${iol_schema}.bdms_bail_repayment_info.acct_seq_no is '子账户序号';
comment on column ${iol_schema}.bdms_bail_repayment_info.reserve_amt is '备款金额';
comment on column ${iol_schema}.bdms_bail_repayment_info.reserve_status is '备款状态';
comment on column ${iol_schema}.bdms_bail_repayment_info.reserve_date is '备款日期';
comment on column ${iol_schema}.bdms_bail_repayment_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bail_repayment_info.etl_timestamp is 'ETL处理时间戳';
