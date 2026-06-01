/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_transfer_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_transfer_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_transfer_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_transfer_details(
    ccy varchar2(3) -- 币种
    ,doc_type varchar2(10) -- 凭证类型
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,withdrawal_type varchar2(1) -- 支取方式
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,contrast_bat_no varchar2(50) -- 对方批次号
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,in_purpose varchar2(400) -- 转入账户用途
    ,job_run_id varchar2(50) -- 批处理任务id
    ,narrative varchar2(400) -- 摘要
    ,out_purpose varchar2(400) -- 转出账户用途
    ,prefix varchar2(10) -- 前缀
    ,rec_amt_ctrl varchar2(1) -- 扣款方式
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,seq_no varchar2(50) -- 序号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,transfer_status varchar2(1) -- 转账状态
    ,sign_time varchar2(26) -- 登记时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,in_acct_name varchar2(200) -- 转入账户名称
    ,in_base_acct_no varchar2(50) -- 移入账号
    ,in_ccy varchar2(3) -- 转入账户币种
    ,in_prod_type varchar2(12) -- 转入账户产品类型
    ,in_seq_no varchar2(5) -- 转入账户序号
    ,out_acct varchar2(50) -- 账号
    ,out_acct_name varchar2(200) -- 转出账户名称
    ,out_ccy varchar2(3) -- 转出账户币种
    ,out_prod_type varchar2(12) -- 转出账户产品
    ,out_seq_no varchar2(5) -- 转出账户序号
    ,tran_amt number(17,2) -- 交易金额
    ,act_tran_amt number(17,2) -- 实际交易金额
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
grant select on ${iol_schema}.ncbs_rb_batch_transfer_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_transfer_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_transfer_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_transfer_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_transfer_details is '批量转账明细登记薄';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.contrast_bat_no is '对方批次号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_purpose is '转入账户用途';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_purpose is '转出账户用途';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.rec_amt_ctrl is '扣款方式';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.transfer_status is '转账状态';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.sign_time is '登记时间';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_acct_name is '转入账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_base_acct_no is '移入账号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_ccy is '转入账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_prod_type is '转入账户产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.in_seq_no is '转入账户序号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_acct is '账号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_acct_name is '转出账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_ccy is '转出账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_prod_type is '转出账户产品';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.out_seq_no is '转出账户序号';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.act_tran_amt is '实际交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_transfer_details.etl_timestamp is 'ETL处理时间戳';
