/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cl_batch_tran_detail_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,ret_status varchar2(2) -- 结果状态
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cr_acct_ccy varchar2(3) -- 贷方账户币种
    ,cr_acct_seq_no varchar2(5) -- 贷方账户序号
    ,cr_base_acct_no varchar2(50) -- 贷方账号
    ,cr_prod_type varchar2(12) -- 贷方产品类型
    ,dr_acct_ccy varchar2(3) -- 借方账户币种
    ,dr_acct_seq_no varchar2(5) -- 借方账户序号
    ,dr_base_acct_no varchar2(50) -- 借方账号
    ,dr_prod_type varchar2(12) -- 借方产品类型
    ,tran_amt number(17,2) -- 交易金额
    ,remark varchar2(600) -- 备注
    ,res_seq_no varchar2(50) -- 限制编号
    ,wt_tran_deal_flow varchar2(1) -- 委托转账处理方式（1-解限,2-转账）
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
grant select on ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist is '存款贷款批量转账明细历史表';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.ret_status is '结果状态';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.cr_acct_ccy is '贷方账户币种';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.cr_acct_seq_no is '贷方账户序号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.cr_base_acct_no is '贷方账号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.cr_prod_type is '贷方产品类型';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.dr_acct_ccy is '借方账户币种';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.dr_acct_seq_no is '借方账户序号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.dr_base_acct_no is '借方账号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.dr_prod_type is '借方产品类型';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.wt_tran_deal_flow is '委托转账处理方式（1-解限,2-转账）';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_cl_batch_tran_detail_hist.etl_timestamp is 'ETL处理时间戳';
