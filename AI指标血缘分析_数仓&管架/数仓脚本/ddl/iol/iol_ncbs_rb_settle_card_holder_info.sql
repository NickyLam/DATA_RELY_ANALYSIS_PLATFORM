/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_holder_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_holder_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_holder_info(
    card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,main_card_flag varchar2(1) -- 主卡标识
    ,mobile_no varchar2(30) -- 电话号码
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,main_card_no varchar2(50) -- 主卡卡号
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_holder_info is '单位结算卡持卡人信息表';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.main_card_flag is '主卡标识';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.main_card_no is '主卡卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_holder_info.etl_timestamp is 'ETL处理时间戳';
