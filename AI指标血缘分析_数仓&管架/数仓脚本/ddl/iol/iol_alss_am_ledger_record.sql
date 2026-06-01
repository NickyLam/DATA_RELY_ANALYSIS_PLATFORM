/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_ledger_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_ledger_record
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_ledger_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_ledger_record(
    input_date varchar2(180) -- 通报日期
    ,data_release_id varchar2(180) -- 发布数据主键
    ,deal_status varchar2(180) -- 数据状态 0-未生效 1-生效 2-修订 3-待删除 4-删除
    ,add_organ_no varchar2(180) -- 补录操作柜员机构
    ,add_user varchar2(300) -- 补录操作人员
    ,add_date varchar2(180) -- 补录操作日期
    ,check_data varchar2(180) -- 补录复核时间
    ,check_user varchar2(300) -- 补录复核人员
    ,record_data_state varchar2(180) -- 补录状态 0-待补录  1-待复核 2-通过 3-不通过 4-退回
    ,batch_id varchar2(180) -- 批次号
    ,is_deal varchar2(180) -- 是否冻结/止付
    ,is_accountability varchar2(180) -- 是否问责
    ,l_r_id varchar2(180) -- 补录主id 主键
    ,is_reduction varchar2(180) -- 是否核减
    ,acct_status varchar2(180) -- 账号状态
    ,open_date varchar2(180) -- 开户日期
    ,open_organ varchar2(180) -- 开户机构
    ,source_type varchar2(180) -- 开户渠道
    ,acc_name varchar2(180) -- 账户名称
    ,acc_no varchar2(180) -- 卡号/账号
    ,cert_num varchar2(180) -- 证件号码
    ,cert_type varchar2(180) -- 证件类型
    ,cus_no varchar2(180) -- 客户号
    ,cus_type varchar2(180) -- 客户类型 个人/对公
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
grant select on ${iol_schema}.alss_am_ledger_record to ${iml_schema};
grant select on ${iol_schema}.alss_am_ledger_record to ${icl_schema};
grant select on ${iol_schema}.alss_am_ledger_record to ${idl_schema};
grant select on ${iol_schema}.alss_am_ledger_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_ledger_record is '';
comment on column ${iol_schema}.alss_am_ledger_record.input_date is '通报日期';
comment on column ${iol_schema}.alss_am_ledger_record.data_release_id is '发布数据主键';
comment on column ${iol_schema}.alss_am_ledger_record.deal_status is '数据状态 0-未生效 1-生效 2-修订 3-待删除 4-删除';
comment on column ${iol_schema}.alss_am_ledger_record.add_organ_no is '补录操作柜员机构';
comment on column ${iol_schema}.alss_am_ledger_record.add_user is '补录操作人员';
comment on column ${iol_schema}.alss_am_ledger_record.add_date is '补录操作日期';
comment on column ${iol_schema}.alss_am_ledger_record.check_data is '补录复核时间';
comment on column ${iol_schema}.alss_am_ledger_record.check_user is '补录复核人员';
comment on column ${iol_schema}.alss_am_ledger_record.record_data_state is '补录状态 0-待补录  1-待复核 2-通过 3-不通过 4-退回';
comment on column ${iol_schema}.alss_am_ledger_record.batch_id is '批次号';
comment on column ${iol_schema}.alss_am_ledger_record.is_deal is '是否冻结/止付';
comment on column ${iol_schema}.alss_am_ledger_record.is_accountability is '是否问责';
comment on column ${iol_schema}.alss_am_ledger_record.l_r_id is '补录主id 主键';
comment on column ${iol_schema}.alss_am_ledger_record.is_reduction is '是否核减';
comment on column ${iol_schema}.alss_am_ledger_record.acct_status is '账号状态';
comment on column ${iol_schema}.alss_am_ledger_record.open_date is '开户日期';
comment on column ${iol_schema}.alss_am_ledger_record.open_organ is '开户机构';
comment on column ${iol_schema}.alss_am_ledger_record.source_type is '开户渠道';
comment on column ${iol_schema}.alss_am_ledger_record.acc_name is '账户名称';
comment on column ${iol_schema}.alss_am_ledger_record.acc_no is '卡号/账号';
comment on column ${iol_schema}.alss_am_ledger_record.cert_num is '证件号码';
comment on column ${iol_schema}.alss_am_ledger_record.cert_type is '证件类型';
comment on column ${iol_schema}.alss_am_ledger_record.cus_no is '客户号';
comment on column ${iol_schema}.alss_am_ledger_record.cus_type is '客户类型 个人/对公';
comment on column ${iol_schema}.alss_am_ledger_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_ledger_record.etl_timestamp is 'ETL处理时间戳';
