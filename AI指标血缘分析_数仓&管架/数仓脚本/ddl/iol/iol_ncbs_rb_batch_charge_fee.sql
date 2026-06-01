/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_charge_fee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_charge_fee
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_charge_fee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_charge_fee(
    remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,batch_file_status varchar2(1) -- 批处理文件处理状态
    ,batch_no varchar2(50) -- 批次号
    ,charge_mode varchar2(1) -- 收取标志
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,fee_type varchar2(20) -- 费率类型
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,charge_base_acct_no varchar2(50) -- 手续费收取账号
    ,tran_amt number(17,2) -- 交易金额
    ,inc_exp_type varchar2(10) -- 收支类型
    ,reference varchar2(50) -- 交易参考号
    ,fee_charge_method varchar2(1) -- 手续费收取方式
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,amort_end date -- 摊销截止日期
    ,amort_start date -- 摊销起始日期
    ,sc_seq_no varchar2(50) -- 收费序号|收费序号
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
grant select on ${iol_schema}.ncbs_rb_batch_charge_fee to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge_fee to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge_fee to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge_fee to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_charge_fee is '批量手续费收取明细表';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.batch_file_status is '批处理文件处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.charge_mode is '收取标志';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.charge_base_acct_no is '手续费收取账号';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.inc_exp_type is '收支类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.fee_charge_method is '手续费收取方式';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.amort_end is '摊销截止日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.amort_start is '摊销起始日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.sc_seq_no is '收费序号|收费序号';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge_fee.etl_timestamp is 'ETL处理时间戳';
