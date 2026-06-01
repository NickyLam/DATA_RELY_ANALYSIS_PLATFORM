/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_holder_info_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_holder_info_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_holder_info_hist(
    card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,main_card_flag varchar2(1) -- 主卡标识
    ,mobile_no varchar2(30) -- 电话号码
    ,old_mobile_phone varchar2(20) -- 变更前手机号码
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,main_card_no varchar2(50) -- 主卡卡号
    ,old_client_ch_name varchar2(200) -- 变更前客户中文名称
    ,old_document_id varchar2(60) -- 变更前证件号码
    ,old_document_type varchar2(4) -- 旧证件类型
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_holder_info_hist is '单位结算卡持卡人历史信息表';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.main_card_flag is '主卡标识';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.old_mobile_phone is '变更前手机号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.main_card_no is '主卡卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.old_client_ch_name is '变更前客户中文名称';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.old_document_id is '变更前证件号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.old_document_type is '旧证件类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info_hist.etl_timestamp is 'ETL处理时间戳';
