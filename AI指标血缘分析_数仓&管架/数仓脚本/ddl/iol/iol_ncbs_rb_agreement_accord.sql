/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_accord
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_accord
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_accord purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_accord(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,company varchar2(20) -- 法人
    ,month_basis varchar2(3) -- 月基准
    ,seq_no varchar2(50) -- 序号
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accord_prod_type varchar2(12) -- 协定协议产品类型
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate varchar2(22) -- 分户级利率浮动百分比
    ,acct_spread_rate varchar2(22) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,float_rate number(15,8) -- 浮动利率
    ,near_amt number(17,2) -- 靠档金额
    ,int_rate_form_no varchar2(50) -- 利率审批单单号
    ,last_start_date date -- 上一开始日
    ,last_end_date date -- 上一结束日
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
grant select on ${iol_schema}.ncbs_rb_agreement_accord to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_accord to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_accord to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_accord to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_accord is '协定协议登记簿';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.term is '存期';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.accord_prod_type is '协定协议产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.near_amt is '靠档金额';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.int_rate_form_no is '利率审批单单号';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.last_start_date is '上一开始日';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.last_end_date is '上一结束日';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_accord.etl_timestamp is 'ETL处理时间戳';
