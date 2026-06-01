/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_payment_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_payment_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_payment_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_payment_detail(
    trandate varchar2(10) -- 交易日期
    ,receiptno varchar2(50) -- 回收号
    ,internalkey varchar2(50) -- 借据号
    ,prodtype varchar2(50) -- 产品类型
    ,recstageno number(5,0) -- 还款期数
    ,ccy varchar2(3) -- 币种
    ,receiptamt number(17,2) -- 实还总额
    ,recpriamt number(17,2) -- 实还本金
    ,recintamt number(17,2) -- 实还利息
    ,recodpamt number(17,2) -- 实还罚息
    ,recodiamt number(17,2) -- 实还复利
    ,recfeeamt number(17,2) -- 实还其他费用
    ,paydate varchar2(10) -- 应还款日期
    ,actrepaydate varchar2(10) -- 实际还款日期
    ,ovedate number(5,0) -- 逾期天数
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_payment_detail to ${iml_schema};
grant select on ${iol_schema}.icms_wph_payment_detail to ${icl_schema};
grant select on ${iol_schema}.icms_wph_payment_detail to ${idl_schema};
grant select on ${iol_schema}.icms_wph_payment_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_payment_detail is '唯品消金还款明细表';
comment on column ${iol_schema}.icms_wph_payment_detail.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_payment_detail.receiptno is '回收号';
comment on column ${iol_schema}.icms_wph_payment_detail.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_payment_detail.prodtype is '产品类型';
comment on column ${iol_schema}.icms_wph_payment_detail.recstageno is '还款期数';
comment on column ${iol_schema}.icms_wph_payment_detail.ccy is '币种';
comment on column ${iol_schema}.icms_wph_payment_detail.receiptamt is '实还总额';
comment on column ${iol_schema}.icms_wph_payment_detail.recpriamt is '实还本金';
comment on column ${iol_schema}.icms_wph_payment_detail.recintamt is '实还利息';
comment on column ${iol_schema}.icms_wph_payment_detail.recodpamt is '实还罚息';
comment on column ${iol_schema}.icms_wph_payment_detail.recodiamt is '实还复利';
comment on column ${iol_schema}.icms_wph_payment_detail.recfeeamt is '实还其他费用';
comment on column ${iol_schema}.icms_wph_payment_detail.paydate is '应还款日期';
comment on column ${iol_schema}.icms_wph_payment_detail.actrepaydate is '实际还款日期';
comment on column ${iol_schema}.icms_wph_payment_detail.ovedate is '逾期天数';
comment on column ${iol_schema}.icms_wph_payment_detail.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_payment_detail.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_payment_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wph_payment_detail.etl_timestamp is 'ETL处理时间戳';
