/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_tran_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_tran_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_tran_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_tran_details(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,acct_desc varchar2(200) -- 账户描述
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,fh_seq_no varchar2(50) -- 资金冻结流水号
    ,job_run_id varchar2(50) -- 批处理任务id
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,oth_gl_code varchar2(20) -- 对方科目代码
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,oth_tran_type varchar2(10) -- 对方交易类型
    ,prefix varchar2(10) -- 前缀
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,serv_charge varchar2(1) -- 服务费标识
    ,source_type varchar2(6) -- 渠道编号
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_note varchar2(1000) -- 交易附言
    ,channel varchar2(10) -- 渠道
    ,settlement_date date -- 清算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,oth_base_acct_no varchar2(64) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,oth_tran_name varchar2(200) -- 交易对手名称
    ,remark1 varchar2(600) -- 备注1
    ,remark2 varchar2(600) -- 备注2
    ,remark3 varchar2(600) -- 备注3
    ,remark4 varchar2(600) -- 备注5
    ,remark5 varchar2(600) -- 备注6
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,narrative_code varchar2(30) -- 摘要码
    ,oth_real_bank_code varchar2(30) -- 真实对方金融机构代码
    ,oth_real_bank_name varchar2(200) -- 真实对方金融机构名称
    ,oth_real_base_acct_no varchar2(64) -- 真实交易对手账号
    ,oth_real_document_id varchar2(60) -- 真实交易对手证件号码
    ,oth_real_document_type varchar2(4) -- 真实交易对手证件类型
    ,oth_real_prod_type varchar2(30) -- 真实交易对手账户产品类型
    ,oth_real_tran_addr varchar2(400) -- 真实交易发生地
    ,oth_real_tran_name varchar2(200) -- 真实交易对手名称
    ,med_ins_tran_flag varchar2(1) -- 医保账户交易标志
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
grant select on ${iol_schema}.ncbs_rb_batch_tran_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_tran_details is '批量转账信息登记薄';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.fh_seq_no is '资金冻结流水号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_gl_code is '对方科目代码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_tran_type is '对方交易类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.serv_charge is '服务费标识';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.settlement_date is '清算日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_tran_name is '交易对手名称';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.remark2 is '备注2';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.remark4 is '备注5';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.remark5 is '备注6';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_bank_code is '真实对方金融机构代码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_bank_name is '真实对方金融机构名称';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_base_acct_no is '真实交易对手账号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_document_id is '真实交易对手证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_document_type is '真实交易对手证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_prod_type is '真实交易对手账户产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_tran_addr is '真实交易发生地';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.oth_real_tran_name is '真实交易对手名称';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.med_ins_tran_flag is '医保账户交易标志';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_tran_details.etl_timestamp is 'ETL处理时间戳';
