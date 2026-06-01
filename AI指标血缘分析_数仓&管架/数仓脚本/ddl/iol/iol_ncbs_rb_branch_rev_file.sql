/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_branch_rev_file
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_branch_rev_file
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_branch_rev_file purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_branch_rev_file(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,job_run_id varchar2(50) -- 批处理任务id
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,tran_status varchar2(1) -- 冲补抹标志
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,new_branch varchar2(12) -- 变更后机构
    ,old_branch varchar2(12) -- 变更前机构
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
grant select on ${iol_schema}.ncbs_rb_branch_rev_file to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_branch_rev_file to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_rev_file to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_rev_file to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_branch_rev_file is '存款批量账户机构变更中间表';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.company is '法人';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.new_branch is '变更后机构';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_branch_rev_file.etl_timestamp is 'ETL处理时间戳';
