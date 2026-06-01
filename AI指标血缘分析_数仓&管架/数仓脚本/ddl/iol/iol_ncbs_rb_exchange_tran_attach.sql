/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_exchange_tran_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_exchange_tran_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_exchange_tran_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_exchange_tran_attach(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,exchange_class varchar2(2) -- 结售汇申报类型
    ,exchange_item_code varchar2(40) -- 结售汇项目编码
    ,exchange_purpose varchar2(10) -- 结售汇用途
    ,exchange_purpose_details varchar2(200) -- 结售汇用途详细信息
    ,exchange_report_no varchar2(50) -- 报送号码
    ,exchange_report_type varchar2(1) -- 申报客户类型
    ,exchange_tran_code varchar2(10) -- 收入方交易编码
    ,exchange_tran_codet varchar2(10) -- 支出方交易编码
    ,exchange_tran_status varchar2(1) -- 结售汇交易状态
    ,exchange_type varchar2(10) -- 结售汇类型
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,approval_date date -- 复核日期
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,discount_value number(15,8) -- 客户单户优惠值
    ,int_rate_form_no varchar2(50) -- 利率审批单单号
    ,cash_from_code varchar2(10) -- 现钞来源代码|现钞来源代码
    ,cash_from_country varchar2(6) -- 现钞来源国家(地区)代码|现钞来源国家(地区)代码
    ,cash_to_code varchar2(10) -- 现钞提取用途说明|现钞提取用途说明
    ,cash_to_country varchar2(6) -- 现钞去向国家(地区)代码|现钞去向国家(地区)代码
    ,remark varchar2(600) -- 备注|备注
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
grant select on ${iol_schema}.ncbs_rb_exchange_tran_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_exchange_tran_attach is '结售汇交易流水附属表';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.company is '法人';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_class is '结售汇申报类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_item_code is '结售汇项目编码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_purpose is '结售汇用途';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_purpose_details is '结售汇用途详细信息';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_report_no is '报送号码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_report_type is '申报客户类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_tran_code is '收入方交易编码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_tran_codet is '支出方交易编码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_tran_status is '结售汇交易状态';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.exchange_type is '结售汇类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.discount_value is '客户单户优惠值';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.int_rate_form_no is '利率审批单单号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.cash_from_code is '现钞来源代码|现钞来源代码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.cash_from_country is '现钞来源国家(地区)代码|现钞来源国家(地区)代码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.cash_to_code is '现钞提取用途说明|现钞提取用途说明';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.cash_to_country is '现钞去向国家(地区)代码|现钞去向国家(地区)代码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.remark is '备注|备注';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_attach.etl_timestamp is 'ETL处理时间戳';
