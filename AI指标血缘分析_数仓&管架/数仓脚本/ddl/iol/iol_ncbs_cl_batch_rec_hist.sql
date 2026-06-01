/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_rec_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_rec_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_rec_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_rec_hist(
    amt_type varchar2(10) -- 金额类型
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_class varchar2(1) -- 账户等级
    ,auto_blocking varchar2(1) -- 自动锁定标志
    ,bank_in_out varchar2(1) -- 是否行内行外
    ,batch_rec_status varchar2(1) -- 批量扣款状态
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,priority varchar2(20) -- 优先级
    ,rec_amt_ctrl varchar2(1) -- 扣款方式
    ,rec_status varchar2(3) -- 回收处理状态
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_bank varchar2(20) -- 结算行号
    ,settle_weight number(5,2) -- 结算权重
    ,stage_no number(5) -- 期次
    ,last_change_date date -- 最后修改日期
    ,maturity_date date -- 到期日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,paid_amt number(17,2) -- 已还金额
    ,rec_amt number(17,2) -- 回收金额(指回收的本金)
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_client varchar2(16) -- 结算客户号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
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
grant select on ${iol_schema}.ncbs_cl_batch_rec_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rec_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rec_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_rec_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_rec_hist is '贷款批量扣款历史信息表';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.auto_blocking is '自动锁定标志';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.bank_in_out is '是否行内行外';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.batch_rec_status is '批量扣款状态';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.priority is '优先级';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.rec_amt_ctrl is '扣款方式';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.rec_status is '回收处理状态';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_bank is '结算行号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_weight is '结算权重';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.paid_amt is '已还金额';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.rec_amt is '回收金额(指回收的本金)';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_batch_rec_hist.etl_timestamp is 'ETL处理时间戳';
