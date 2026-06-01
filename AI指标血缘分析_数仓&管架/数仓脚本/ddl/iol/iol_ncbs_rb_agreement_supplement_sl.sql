/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_supplement_sl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_supplement_sl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_supplement_sl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_supplement_sl(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,receipt_reason_code varchar2(10) -- 回收原因
    ,seq_no varchar2(50) -- 序号
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dd_reason_code varchar2(200) -- 发放原因
    ,limit_amt_agg number(38,2) -- 卡易贷放贷(转账)渠道最大额度
    ,limit_amt_cash_agg number(38,2) -- 卡易贷放贷(现金)渠道最大额度
    ,max_dd_amt number(17,2) -- 最大发放金额
    ,min_dd_amt number(17,2) -- 最小发放金额
    ,used_amt_agg number(38,2) -- 转账已用额度
    ,used_amt_cash_agg number(38,2) -- 现金已用额度
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
grant select on ${iol_schema}.ncbs_rb_agreement_supplement_sl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_supplement_sl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_supplement_sl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_supplement_sl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_supplement_sl is '金额补足签约渠道额度信息表';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.receipt_reason_code is '回收原因';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.dd_reason_code is '发放原因';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.limit_amt_agg is '卡易贷放贷(转账)渠道最大额度';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.limit_amt_cash_agg is '卡易贷放贷(现金)渠道最大额度';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.max_dd_amt is '最大发放金额';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.min_dd_amt is '最小发放金额';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.used_amt_agg is '转账已用额度';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.used_amt_cash_agg is '现金已用额度';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_supplement_sl.etl_timestamp is 'ETL处理时间戳';
