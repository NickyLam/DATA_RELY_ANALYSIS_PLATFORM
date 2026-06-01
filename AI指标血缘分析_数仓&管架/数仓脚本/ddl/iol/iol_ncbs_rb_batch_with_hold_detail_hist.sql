/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_with_hold_detail_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist(
    client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,issue_no varchar2(50) -- 发布编号
    ,periods varchar2(5) -- 批量扣扣频率
    ,weight varchar2(20) -- 权重
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_amt number(17,2) -- 实际金额
    ,loan_internal_key number(15) -- 贷款账户key值
    ,loan_no varchar2(50) -- 贷款号
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_ccy varchar2(3) -- 结算币种
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,settle_seq_no varchar2(5) -- 清算序号
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist is '贷款批量扣款信息历史表';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.issue_no is '发布编号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.periods is '批量扣扣频率';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.weight is '权重';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.actual_amt is '实际金额';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.loan_internal_key is '贷款账户key值';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.settle_seq_no is '清算序号';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_with_hold_detail_hist.etl_timestamp is 'ETL处理时间戳';
