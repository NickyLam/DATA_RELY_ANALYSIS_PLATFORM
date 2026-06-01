/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_bab_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_bab_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_bab_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_register(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,payment_flag varchar2(1) -- 备款顺序
    ,register_status varchar2(1) -- 登记状态
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accept_contract_no varchar2(30) -- 银承合同编号
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
grant select on ${iol_schema}.ncbs_rb_bab_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_bab_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_bab_register is '银行承兑汇票登记表';
comment on column ${iol_schema}.ncbs_rb_bab_register.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_bab_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_bab_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_bab_register.payment_flag is '备款顺序';
comment on column ${iol_schema}.ncbs_rb_bab_register.register_status is '登记状态';
comment on column ${iol_schema}.ncbs_rb_bab_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_bab_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_bab_register.accept_contract_no is '银承合同编号';
comment on column ${iol_schema}.ncbs_rb_bab_register.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_bab_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_bab_register.etl_timestamp is 'ETL处理时间戳';
