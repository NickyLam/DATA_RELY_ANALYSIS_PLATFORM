/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_txy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_txy
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_txy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_txy(
    agreement_id varchar2(50) -- 协议编号
    ,main_agreement_id varchar2(50) -- 主协议协议号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,client_no varchar2(16) -- 客户编号
    ,agree_int_rate number(15,8) -- 协议利率
    ,over_grade_rate number(15,8) -- 超档利率
    ,past_fad_rate number(15,8) -- 违约利率
    ,cycle_freq varchar2(5) -- 结息频率
    ,agre_prod_type varchar2(12) -- 签约主产品类型
    ,main_flag varchar2(1) -- 主、分账户类型标志
    ,sign_id varchar2(50) -- 外围系统协议编号
    ,internal_key number(15,0) -- 账户内部键值
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,user_id varchar2(8) -- 交易柜员编号
    ,branch varchar2(12) -- 交易机构编号
    ,channel varchar2(10) -- 渠道
    ,company varchar2(20) -- 法人
    ,agg number(38,2) -- 积数
    ,int_accrued_calc_ctd number(25,10) -- 累计计提
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
grant select on ${iol_schema}.ncbs_rb_agreement_txy to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_txy to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_txy to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_txy to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_txy is '同兴赢协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.main_agreement_id is '主协议协议号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.agree_int_rate is '协议利率';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.over_grade_rate is '超档利率';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.past_fad_rate is '违约利率';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.agre_prod_type is '签约主产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.main_flag is '主、分账户类型标志';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.sign_id is '外围系统协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.agg is '积数';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.int_accrued_calc_ctd is '累计计提';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_agreement_txy.etl_timestamp is 'ETL处理时间戳';
