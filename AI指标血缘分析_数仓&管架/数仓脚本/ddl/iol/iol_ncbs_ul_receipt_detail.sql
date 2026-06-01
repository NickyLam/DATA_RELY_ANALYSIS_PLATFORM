/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_receipt_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_receipt_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_receipt_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_receipt_detail(
    receipt_no varchar2(50) -- 回收号|回收号
    ,batch_no varchar2(50) -- 批次号|批次号
    ,cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,stage_no number(5,0) -- 期次|期次
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,pri_amt number(17,2) -- 本金金额|本金金额
    ,int_amt number(17,2) -- 利息金额|利息金额
    ,odp_amt number(17,2) -- 罚息金额|罚息金额
    ,odi_amt number(17,2) -- 复利金额|复利金额
    ,company varchar2(20) -- 法人|法人
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,ul_partner_reference varchar2(100) -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,pre_int_amt varchar2(50) -- 还款前应收未收正常利息
    ,pre_odi_amt varchar2(50) -- 还款前应收未收复利
    ,pre_odp_amt varchar2(50) -- 还款前应收未收罚息
    ,pre_pri_amt varchar2(50) -- 还款前应收未收正常本金
    ,receipt_amt varchar2(50) -- 回收金额
    ,receipt_type varchar2(50) -- 还款类型
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
grant select on ${iol_schema}.ncbs_ul_receipt_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_receipt_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_receipt_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_receipt_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_receipt_detail is '联合贷贷款还款明细表';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.receipt_no is '回收号|回收号';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.stage_no is '期次|期次';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.pri_amt is '本金金额|本金金额';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.int_amt is '利息金额|利息金额';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.odp_amt is '罚息金额|罚息金额';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.odi_amt is '复利金额|复利金额';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.company is '法人|法人';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.ul_partner_reference is '联合贷合作方交易流水号|联合贷合作方交易流水号';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.pre_int_amt is '还款前应收未收正常利息';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.pre_odi_amt is '还款前应收未收复利';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.pre_odp_amt is '还款前应收未收罚息';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.pre_pri_amt is '还款前应收未收正常本金';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.receipt_amt is '回收金额';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.receipt_type is '还款类型';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_receipt_detail.etl_timestamp is 'ETL处理时间戳';
