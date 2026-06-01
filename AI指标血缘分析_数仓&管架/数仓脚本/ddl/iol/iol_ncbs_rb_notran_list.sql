/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_notran_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_notran_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_notran_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_notran_list(
    acct_status varchar2(1) -- 账户状态
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,add_flag varchar2(1) -- 添加标识
    ,asyn_id varchar2(50) -- 异步编号
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,black_no varchar2(50) -- 黑名单编号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,examine_flag varchar2(1) -- 可疑账户核实标志
    ,examine_teller varchar2(10) -- 检查柜面
    ,job_run_id varchar2(50) -- 批处理任务id
    ,list_operate_type varchar2(5) -- 名单操作类型
    ,list_source varchar2(1) -- 名单来源
    ,our_bank_flag varchar2(1) -- 黑名单客户标志
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,uncounter_desc varchar2(50) -- 入表原因
    ,asyn_date date -- 同步日期
    ,black_check_time varchar2(26) -- 黑名单检查时间
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,input_branch varchar2(12) -- 录入机构
    ,oper_user_id varchar2(8) -- 操作柜员
    ,remark1 varchar2(600) -- 备注1
    ,remark3 varchar2(600) -- 备注3
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
grant select on ${iol_schema}.ncbs_rb_notran_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_notran_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_notran_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_notran_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_notran_list is '6个月无交易名单表';
comment on column ${iol_schema}.ncbs_rb_notran_list.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_notran_list.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_notran_list.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_notran_list.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_notran_list.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_notran_list.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_notran_list.add_flag is '添加标识';
comment on column ${iol_schema}.ncbs_rb_notran_list.asyn_id is '异步编号';
comment on column ${iol_schema}.ncbs_rb_notran_list.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_notran_list.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_notran_list.black_no is '黑名单编号';
comment on column ${iol_schema}.ncbs_rb_notran_list.company is '法人';
comment on column ${iol_schema}.ncbs_rb_notran_list.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_notran_list.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_notran_list.examine_flag is '可疑账户核实标志';
comment on column ${iol_schema}.ncbs_rb_notran_list.examine_teller is '检查柜面';
comment on column ${iol_schema}.ncbs_rb_notran_list.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_notran_list.list_operate_type is '名单操作类型';
comment on column ${iol_schema}.ncbs_rb_notran_list.list_source is '名单来源';
comment on column ${iol_schema}.ncbs_rb_notran_list.our_bank_flag is '黑名单客户标志';
comment on column ${iol_schema}.ncbs_rb_notran_list.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_notran_list.uncounter_desc is '入表原因';
comment on column ${iol_schema}.ncbs_rb_notran_list.asyn_date is '同步日期';
comment on column ${iol_schema}.ncbs_rb_notran_list.black_check_time is '黑名单检查时间';
comment on column ${iol_schema}.ncbs_rb_notran_list.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_notran_list.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_notran_list.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_notran_list.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_notran_list.input_branch is '录入机构';
comment on column ${iol_schema}.ncbs_rb_notran_list.oper_user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_rb_notran_list.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_notran_list.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rb_notran_list.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_notran_list.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_notran_list.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_notran_list.etl_timestamp is 'ETL处理时间戳';
