/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_clrec_deduction_detail_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,amt_ctl varchar2(1) -- 金额控制标志
    ,auto_blocking varchar2(1) -- 自动锁定标志
    ,batch_no varchar2(50) -- 批次号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,fixed_amt number(17,2) -- 额定监管总金额
    ,group_id varchar2(30) -- 流程组id
    ,priority varchar2(20) -- 优先级
    ,res_seq_no varchar2(50) -- 限制编号
    ,ret_status varchar2(2) -- 结果状态
    ,scene_id varchar2(200) -- 场景id
    ,seq_no varchar2(50) -- 序号
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_no varchar2(50) -- 结算编号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,oppo_acct_no varchar2(50) -- 行外对手账号
    ,oppo_bank_code varchar2(20) -- 行外对手账户行号
    ,oppo_bank_name varchar2(100) -- 行外对手账户行名
    ,oth_settle_acct_ccy varchar2(3) -- 对手结算账户币种
    ,oth_settle_acct_name varchar2(200) -- 对手结算账户户名
    ,oth_settle_acct_seq_no varchar2(5) -- 对手结算账户序号
    ,oth_settle_base_acct_no varchar2(50) -- 对手结算账号
    ,oth_settle_client varchar2(16) -- 对手结算客户号
    ,oth_settle_prod_type varchar2(12) -- 对手结算账户产品类型
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_client varchar2(16) -- 结算客户号
    ,tran_amt number(17,2) -- 交易金额
    ,deal_status varchar2(1) -- 处理状态
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
grant select on ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist is '存款贷款回收扣款明细表';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.amt_ctl is '金额控制标志';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.auto_blocking is '自动锁定标志';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.fixed_amt is '额定监管总金额';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.group_id is '流程组id';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.priority is '优先级';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.ret_status is '结果状态';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.scene_id is '场景id';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oppo_acct_no is '行外对手账号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oppo_bank_code is '行外对手账户行号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oppo_bank_name is '行外对手账户行名';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_acct_ccy is '对手结算账户币种';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_acct_name is '对手结算账户户名';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_acct_seq_no is '对手结算账户序号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_base_acct_no is '对手结算账号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_client is '对手结算客户号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.oth_settle_prod_type is '对手结算账户产品类型';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.deal_status is '处理状态';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist.etl_timestamp is 'ETL处理时间戳';
