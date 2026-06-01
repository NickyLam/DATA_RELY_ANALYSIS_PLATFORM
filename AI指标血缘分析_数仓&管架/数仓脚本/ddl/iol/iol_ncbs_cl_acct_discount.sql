/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_discount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_discount
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_discount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_discount(
    ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,bill_no varchar2(30) -- 票据号码
    ,bill_status varchar2(2) -- 票据状态
    ,company varchar2(20) -- 法人
    ,payer_bank varchar2(20) -- 票据贴现收款人开户行
    ,sell_not_flag varchar2(1) -- 是否卖断式
    ,sell_own_draft_flag varchar2(1) -- 是否本行票据
    ,discount_date date -- 贷款贴现日期
    ,draft_mature_date date -- 票面到期日期
    ,issue_date date -- 发行日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,bill_amt number(17,2) -- 票面金额
    ,book_branch varchar2(12) -- 贷款银行
    ,dd_day number(5) -- 增加天数
    ,disc_base_rate number(15,8) -- 基准利率1
    ,int_rate number(15,8) -- 出单利率
    ,issue_acct_no varchar2(50) -- 出售账号
    ,issue_client_name varchar2(200) -- 出票人全名称
    ,loan_no varchar2(50) -- 贷款号
    ,pay_branch varchar2(12) -- 缴存机构
    ,payee_acct_name varchar2(200) -- 收款人名称
    ,payee_base_acct_no varchar2(50) -- 收款人账号
    ,payer_branch_name varchar2(200) -- 付款人机构名称
    ,sell_int number(17,2) -- 账户利息支出
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_cl_acct_discount to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_discount to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_discount to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_discount to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_discount is '票据贴现信息表';
comment on column ${iol_schema}.ncbs_cl_acct_discount.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_acct_discount.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_cl_acct_discount.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_discount.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_discount.bill_no is '票据号码';
comment on column ${iol_schema}.ncbs_cl_acct_discount.bill_status is '票据状态';
comment on column ${iol_schema}.ncbs_cl_acct_discount.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_discount.payer_bank is '票据贴现收款人开户行';
comment on column ${iol_schema}.ncbs_cl_acct_discount.sell_not_flag is '是否卖断式';
comment on column ${iol_schema}.ncbs_cl_acct_discount.sell_own_draft_flag is '是否本行票据';
comment on column ${iol_schema}.ncbs_cl_acct_discount.discount_date is '贷款贴现日期';
comment on column ${iol_schema}.ncbs_cl_acct_discount.draft_mature_date is '票面到期日期';
comment on column ${iol_schema}.ncbs_cl_acct_discount.issue_date is '发行日期';
comment on column ${iol_schema}.ncbs_cl_acct_discount.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_discount.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_discount.bill_amt is '票面金额';
comment on column ${iol_schema}.ncbs_cl_acct_discount.book_branch is '贷款银行';
comment on column ${iol_schema}.ncbs_cl_acct_discount.dd_day is '增加天数';
comment on column ${iol_schema}.ncbs_cl_acct_discount.disc_base_rate is '基准利率1';
comment on column ${iol_schema}.ncbs_cl_acct_discount.int_rate is '出单利率';
comment on column ${iol_schema}.ncbs_cl_acct_discount.issue_acct_no is '出售账号';
comment on column ${iol_schema}.ncbs_cl_acct_discount.issue_client_name is '出票人全名称';
comment on column ${iol_schema}.ncbs_cl_acct_discount.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_acct_discount.pay_branch is '缴存机构';
comment on column ${iol_schema}.ncbs_cl_acct_discount.payee_acct_name is '收款人名称';
comment on column ${iol_schema}.ncbs_cl_acct_discount.payee_base_acct_no is '收款人账号';
comment on column ${iol_schema}.ncbs_cl_acct_discount.payer_branch_name is '付款人机构名称';
comment on column ${iol_schema}.ncbs_cl_acct_discount.sell_int is '账户利息支出';
comment on column ${iol_schema}.ncbs_cl_acct_discount.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_acct_discount.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_discount.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_discount.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_discount.etl_timestamp is 'ETL处理时间戳';
