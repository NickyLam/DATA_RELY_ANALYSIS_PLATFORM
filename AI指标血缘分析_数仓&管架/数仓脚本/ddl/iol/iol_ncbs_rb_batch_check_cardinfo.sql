/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_check_cardinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_check_cardinfo
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_check_cardinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_check_cardinfo(
    acct_name varchar2(200) -- 账户名称
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,card_no varchar2(50) -- 卡号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,acct_class varchar2(1) -- 账户等级
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,error_msg varchar2(3000) -- 错误代码
    ,job_run_id varchar2(50) -- 批处理任务id
    ,pass_flag varchar2(1) -- 通过标记
    ,phone_no varchar2(20) -- 固定电话
    ,phone_no1 varchar2(20) -- 电话号码1
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,credit_card_no varchar2(50) -- 信用卡号
    ,document_id1 varchar2(60) -- 证件号1
    ,document_type1 varchar2(4) -- 证件类型1
    ,out_acct_name varchar2(200) -- 转出账户名称
    ,remark1 varchar2(600) -- 备注1
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
grant select on ${iol_schema}.ncbs_rb_batch_check_cardinfo to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_check_cardinfo to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_check_cardinfo to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_check_cardinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_check_cardinfo is '委托关系验证';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.pass_flag is '通过标记';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.phone_no is '固定电话';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.phone_no1 is '电话号码1';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.credit_card_no is '信用卡号';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.document_id1 is '证件号1';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.document_type1 is '证件类型1';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.out_acct_name is '转出账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_check_cardinfo.etl_timestamp is 'ETL处理时间戳';
