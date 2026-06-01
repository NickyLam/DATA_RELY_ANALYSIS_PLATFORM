/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_tran
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_tran(
    client_no varchar2(16) -- 客户编号
    ,file_name varchar2(200) -- 文件名称
    ,file_path varchar2(200) -- 文件路径
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,appr_flag varchar2(1) -- 复核标志
    ,auth_flag varchar2(1) -- 授权标志
    ,batch_class varchar2(10) -- 批次类型
    ,batch_desc varchar2(50) -- 批处理描述
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_desc varchar2(3000) -- 错误描述
    ,failure_number number(5) -- 失败数量
    ,mac_value varchar2(200) -- 传输密押
    ,narrative varchar2(400) -- 摘要
    ,program_id varchar2(20) -- 交易代码
    ,seq_no varchar2(50) -- 序号
    ,source_branch_no varchar2(12) -- 源节点编号
    ,source_type varchar2(6) -- 渠道编号
    ,succ_num number(5) -- 成功数量
    ,system_id varchar2(20) -- 系统id
    ,thread_no varchar2(50) -- 线程编号
    ,total_num number(5) -- 总数量
    ,tran_mode varchar2(1) -- 交易模式
    ,user_lang varchar2(3) -- 柜员语言
    ,begin_time varchar2(26) -- 开始时间
    ,deal_date date -- 处理日期
    ,expire_date date -- 失效日期
    ,run_date date -- 运行日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,dest_branch_no varchar2(12) -- 目标机构编号
    ,total_amt number(17,2) -- 总金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,approval_no varchar2(50) -- 审批单号
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
grant select on ${iol_schema}.ncbs_rb_batch_tran to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_tran is '批量交易信息登记簿';
comment on column ${iol_schema}.ncbs_rb_batch_tran.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_rb_batch_tran.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_rb_batch_tran.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_rb_batch_tran.auth_flag is '授权标志';
comment on column ${iol_schema}.ncbs_rb_batch_tran.batch_class is '批次类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran.batch_desc is '批处理描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_tran.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_tran.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran.failure_number is '失败数量';
comment on column ${iol_schema}.ncbs_rb_batch_tran.mac_value is '传输密押';
comment on column ${iol_schema}.ncbs_rb_batch_tran.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_batch_tran.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_batch_tran.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.source_branch_no is '源节点编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.succ_num is '成功数量';
comment on column ${iol_schema}.ncbs_rb_batch_tran.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_batch_tran.thread_no is '线程编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.total_num is '总数量';
comment on column ${iol_schema}.ncbs_rb_batch_tran.tran_mode is '交易模式';
comment on column ${iol_schema}.ncbs_rb_batch_tran.user_lang is '柜员语言';
comment on column ${iol_schema}.ncbs_rb_batch_tran.begin_time is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_tran.deal_date is '处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran.run_date is '运行日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_tran.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_batch_tran.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_batch_tran.dest_branch_no is '目标机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_batch_tran.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_batch_tran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran.etl_timestamp is 'ETL处理时间戳';
