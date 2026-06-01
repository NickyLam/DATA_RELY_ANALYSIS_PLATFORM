/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_settle_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_settle_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_settle_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_settle_hist(
    amt_type varchar2(10) -- 金额类型
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,amt_ctl varchar2(1) -- 金额控制标志
    ,auto_blocking varchar2(1) -- 自动锁定标志
    ,batch_no varchar2(50) -- 批次号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,diff_amt number(15,10) -- 差错金额
    ,event_type varchar2(20) -- 事件类型
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,order_no varchar2(50) -- 预约编号
    ,oth_settle_method varchar2(10) -- 对手账户结算方式
    ,priority varchar2(20) -- 优先级
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_method varchar2(3) -- 结算方法
    ,settle_no varchar2(50) -- 结算编号
    ,settle_type varchar2(2) -- 结算方式
    ,stage_no number(5) -- 期次
    ,status varchar2(1) -- 状态
    ,tran_status varchar2(1) -- 冲补抹标志
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,diff_settle_amt number(17,2) -- 差额结算金额
    ,loan_no varchar2(50) -- 贷款号
    ,oppo_acct_no varchar2(50) -- 行外对手账号
    ,oppo_bank_code varchar2(20) -- 行外对手账户行号
    ,oppo_bank_name varchar2(100) -- 行外对手账户行名
    ,oth_settle_acct_ccy varchar2(3) -- 对手结算账户币种
    ,oth_settle_acct_name varchar2(200) -- 对手结算账户户名
    ,oth_settle_acct_seq_no varchar2(5) -- 对手结算账户序号
    ,oth_settle_acct_type varchar2(1) -- 对手账户结算账户类型
    ,oth_settle_base_acct_no varchar2(50) -- 对手结算账号
    ,oth_settle_client varchar2(16) -- 对手结算客户号
    ,oth_settle_prod_type varchar2(12) -- 对手结算账户产品类型
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_client varchar2(16) -- 结算客户号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,tran_amt number(17,2) -- 交易金额
    ,cmisloan_no varchar2(64) -- 借据号
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
grant select on ${iol_schema}.ncbs_cl_batch_settle_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_settle_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_settle_hist is '贷款批量回收明细历史表';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.amt_ctl is '金额控制标志';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.auto_blocking is '自动锁定标志';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.diff_amt is '差错金额';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.order_no is '预约编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_method is '对手账户结算方式';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.priority is '优先级';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_method is '结算方法';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_type is '结算方式';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.status is '状态';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.diff_settle_amt is '差额结算金额';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oppo_acct_no is '行外对手账号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oppo_bank_code is '行外对手账户行号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oppo_bank_name is '行外对手账户行名';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_acct_ccy is '对手结算账户币种';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_acct_name is '对手结算账户户名';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_acct_seq_no is '对手结算账户序号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_acct_type is '对手账户结算账户类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_base_acct_no is '对手结算账号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_client is '对手结算客户号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.oth_settle_prod_type is '对手结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.cmisloan_no is '借据号';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_batch_settle_hist.etl_timestamp is 'ETL处理时间戳';
