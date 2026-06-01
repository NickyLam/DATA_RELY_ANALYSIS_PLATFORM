/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_pt_payment_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_pt_payment_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_pt_payment_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_pt_payment_tran_hist(
    acct_name varchar2(200) -- 账户名称
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,acct_payment_status varchar2(2) -- 账户支付状态
    ,acgl_flag varchar2(1) -- 记账种类
    ,bill_no varchar2(30) -- 票据号码
    ,bill_type varchar2(1) -- 票据种类
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,collate_batch_no varchar2(50) -- 对账批号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,direction varchar2(1) -- 来往账类型
    ,entry_success_flag varchar2(1) -- 入账成功标识
    ,hang_status varchar2(1) -- 挂账状态
    ,pt_operate_type varchar2(2) -- 支付操作类型
    ,res_seq_no varchar2(50) -- 限制编号
    ,ret_code varchar2(50) -- 状态码
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,settle_no varchar2(50) -- 结算编号
    ,settle_step number(5) -- 记账步骤
    ,trusted_pay_no varchar2(50) -- 受托支付编号
    ,channel varchar2(10) -- 渠道
    ,collate_date date -- 对账日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,contra_acct_name varchar2(200) -- 对手账号名称
    ,contra_base_acct_no varchar2(50) -- 交易对手账号
    ,fee_amt number(17,2) -- 费用金额
    ,orig_reference varchar2(50) -- 源交易参考号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_pt_payment_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_pt_payment_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_pt_payment_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_pt_payment_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_pt_payment_tran_hist is '支付核心交易流水表';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.acct_payment_status is '账户支付状态';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.acgl_flag is '记账种类';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.bill_no is '票据号码';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.bill_type is '票据种类';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.collate_batch_no is '对账批号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.direction is '来往账类型';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.entry_success_flag is '入账成功标识';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.hang_status is '挂账状态';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.pt_operate_type is '支付操作类型';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.ret_code is '状态码';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.settle_step is '记账步骤';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.trusted_pay_no is '受托支付编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.channel is '渠道';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.collate_date is '对账日期';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.contra_acct_name is '对手账号名称';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.contra_base_acct_no is '交易对手账号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.orig_reference is '源交易参考号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_pt_payment_tran_hist.etl_timestamp is 'ETL处理时间戳';
