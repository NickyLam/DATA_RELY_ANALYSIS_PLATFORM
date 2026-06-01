/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_assemble
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_assemble
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_assemble purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_assemble(
    client_no varchar2(16) -- 客户编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,favorable_ruler varchar2(1) -- 优惠规则
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,loan_prod_type varchar2(12) -- 贷款产品类型
    ,over_amt number(17,2) -- 超额金额
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
grant select on ${iol_schema}.ncbs_rb_agreement_assemble to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_assemble to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_assemble to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_assemble to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_assemble is '存贷组合签约表';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.favorable_ruler is '优惠规则';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.loan_prod_type is '贷款产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.over_amt is '超额金额';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_assemble.etl_timestamp is 'ETL处理时间戳';
