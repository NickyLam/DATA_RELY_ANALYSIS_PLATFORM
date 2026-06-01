/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_detail(
    asset_acct_status varchar2(1) -- 资产账户状态
    ,balance number(17,2) -- 余额
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,sale_batch_no varchar2(50) -- 发行批次号
    ,accounting_status varchar2(3) -- 核算状态
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
    ,pack_reference varchar2(50) -- 资产证券化封包流水号
    ,sale_reference varchar2(50) -- 发行流水号
    ,sale_cancel_batch_no varchar2(50) -- 发行撤销批次号
    ,amortized_int number(17,2) -- 已摊销利息
    ,circle_buy_flag varchar2(1) -- 循环购买标志
    ,circle_buy_reference varchar2(50) -- 循环购买流水号
    ,pack_cancel_batch_no varchar2(50) -- 撤包批次号
    ,circle_buy_date date -- 循环购买日期
    ,sale_float_amount number(17,2) -- 发行折溢价
    ,circle_buy_batch_no varchar2(50) -- 循环购买批次号
    ,sale_cancel_reference varchar2(50) -- 资产发行撤销交易参考号
    ,redeem_reference varchar2(50) -- 赎回交易流水号
    ,pack_batch_no varchar2(50) -- 封包批次号
    ,pack_cancel_reference varchar2(50) -- 撤包交易流水号
    ,asset_detail_seq_no varchar2(50) -- 资产包合同明细序号
    ,redeem_date date -- 资产赎回日期
    ,redeem_batch_no varchar2(50) -- 赎回批次号
    ,pack_tran_date date -- 封包交易日期
    ,asset_contract_seq_no varchar2(50) -- 资产包合同序号
    ,redeem_float_amount number(17,2) -- 赎回折溢价
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
grant select on ${iol_schema}.ncbs_cl_transfer_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_detail is '资产转让合同明细表';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.asset_acct_status is '资产账户状态';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.balance is '余额';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.sale_batch_no is '发行批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.pack_reference is '资产证券化封包流水号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.sale_reference is '发行流水号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.sale_cancel_batch_no is '发行撤销批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.amortized_int is '已摊销利息';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.circle_buy_flag is '循环购买标志';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.circle_buy_reference is '循环购买流水号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.pack_cancel_batch_no is '撤包批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.circle_buy_date is '循环购买日期';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.sale_float_amount is '发行折溢价';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.circle_buy_batch_no is '循环购买批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.sale_cancel_reference is '资产发行撤销交易参考号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.redeem_reference is '赎回交易流水号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.pack_batch_no is '封包批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.pack_cancel_reference is '撤包交易流水号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.asset_detail_seq_no is '资产包合同明细序号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.redeem_date is '资产赎回日期';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.redeem_batch_no is '赎回批次号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.pack_tran_date is '封包交易日期';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.asset_contract_seq_no is '资产包合同序号';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.redeem_float_amount is '赎回折溢价';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_detail.etl_timestamp is 'ETL处理时间戳';
