/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_receipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_receipt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_receipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_receipt(
    receipt_no varchar2(50) -- 回收号|回收号
    ,batch_no varchar2(50) -- 批次号|批次号
    ,cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,tran_branch varchar2(12) -- 核心交易机构编号|核心交易机构编号
    ,receipt_date date -- 贷款还款日期|贷款还款日期
    ,receipt_type varchar2(2) -- 还款类型|还款类型|ns-正常回收,er-提前回收,ep-逾期提前还本,po-结清,wv-利息豁免,df-债权减免,tr-终止
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,ccy varchar2(3) -- 币种|币种
    ,repay_total_amt number(17,2) -- 还款总金额|还款总金额
    ,pri_amt number(17,2) -- 本金金额|本金金额
    ,int_amt number(17,2) -- 利息金额|利息金额
    ,odp_amt number(17,2) -- 罚息金额|罚息金额
    ,odi_amt number(17,2) -- 复利金额|复利金额
    ,tran_date date -- 交易日期|交易日期
    ,receipt_gen_code varchar2(1) -- 回收产生方式 |回收产生方式|m-人工,a-自动
    ,accounting_status varchar2(3) -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,company varchar2(20) -- 法人|法人
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,ul_partner_reference varchar2(100) -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,intp_amt varchar2(50) -- 逾期利息
    ,prd_amt varchar2(50) -- 逾期本金
    ,pre_intp_amt varchar2(50) -- 还款前应收未收逾期利息
    ,pre_int_amt varchar2(50) -- 还款前应收未收的正常利息
    ,pre_odi_amt varchar2(50) -- 还款前应收未收复利
    ,pre_odp_amt varchar2(50) -- 还款前应收未收罚息
    ,pre_prd_amt varchar2(50) -- 还款前应收未收的逾期本金
    ,pre_pri_amt varchar2(50) -- 还款前应收未收的正常本金
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
grant select on ${iol_schema}.ncbs_ul_receipt to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_receipt to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_receipt to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_receipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_receipt is '联合贷贷款还款信息表';
comment on column ${iol_schema}.ncbs_ul_receipt.receipt_no is '回收号|回收号';
comment on column ${iol_schema}.ncbs_ul_receipt.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_receipt.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_receipt.tran_branch is '核心交易机构编号|核心交易机构编号';
comment on column ${iol_schema}.ncbs_ul_receipt.receipt_date is '贷款还款日期|贷款还款日期';
comment on column ${iol_schema}.ncbs_ul_receipt.receipt_type is '还款类型|还款类型|ns-正常回收,er-提前回收,ep-逾期提前还本,po-结清,wv-利息豁免,df-债权减免,tr-终止';
comment on column ${iol_schema}.ncbs_ul_receipt.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_receipt.ccy is '币种|币种';
comment on column ${iol_schema}.ncbs_ul_receipt.repay_total_amt is '还款总金额|还款总金额';
comment on column ${iol_schema}.ncbs_ul_receipt.pri_amt is '本金金额|本金金额';
comment on column ${iol_schema}.ncbs_ul_receipt.int_amt is '利息金额|利息金额';
comment on column ${iol_schema}.ncbs_ul_receipt.odp_amt is '罚息金额|罚息金额';
comment on column ${iol_schema}.ncbs_ul_receipt.odi_amt is '复利金额|复利金额';
comment on column ${iol_schema}.ncbs_ul_receipt.tran_date is '交易日期|交易日期';
comment on column ${iol_schema}.ncbs_ul_receipt.receipt_gen_code is '回收产生方式 |回收产生方式|m-人工,a-自动';
comment on column ${iol_schema}.ncbs_ul_receipt.accounting_status is '核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止';
comment on column ${iol_schema}.ncbs_ul_receipt.company is '法人|法人';
comment on column ${iol_schema}.ncbs_ul_receipt.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_ul_receipt.ul_partner_reference is '联合贷合作方交易流水号|联合贷合作方交易流水号';
comment on column ${iol_schema}.ncbs_ul_receipt.intp_amt is '逾期利息';
comment on column ${iol_schema}.ncbs_ul_receipt.prd_amt is '逾期本金';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_intp_amt is '还款前应收未收逾期利息';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_int_amt is '还款前应收未收的正常利息';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_odi_amt is '还款前应收未收复利';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_odp_amt is '还款前应收未收罚息';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_prd_amt is '还款前应收未收的逾期本金';
comment on column ${iol_schema}.ncbs_ul_receipt.pre_pri_amt is '还款前应收未收的正常本金';
comment on column ${iol_schema}.ncbs_ul_receipt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_receipt.etl_timestamp is 'ETL处理时间戳';
