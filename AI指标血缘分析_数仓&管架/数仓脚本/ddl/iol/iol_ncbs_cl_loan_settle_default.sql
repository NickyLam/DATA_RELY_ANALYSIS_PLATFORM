/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_loan_settle_default
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_loan_settle_default
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_loan_settle_default purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_settle_default(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,auto_blocking varchar2(1) -- 自动锁定标志
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,pay_rec_ind varchar2(3) -- 收付款标志
    ,priority varchar2(20) -- 优先级
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_bank_flag varchar2(1) -- 资金转移账户银行标识
    ,settle_method varchar2(3) -- 结算方法
    ,settle_mobile_phone varchar2(20) -- 绑定账户手机号码
    ,settle_no varchar2(50) -- 结算编号
    ,settle_weight number(5,2) -- 结算权重
    ,settle_xrate_id varchar2(1) -- 结算汇兑方式
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_bank_name varchar2(100) -- 清算账号开户行行名
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_branch varchar2(12) -- 清算机构
    ,settle_ccy varchar2(3) -- 结算币种
    ,settle_client varchar2(16) -- 结算客户号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,settle_xrate number(15,8) -- 结算汇率
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
grant select on ${iol_schema}.ncbs_cl_loan_settle_default to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_loan_settle_default to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_settle_default to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_settle_default to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_loan_settle_default is '贷款合同结算信息';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.auto_blocking is '自动锁定标志';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.company is '法人';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.pay_rec_ind is '收付款标志';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.priority is '优先级';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_bank_flag is '资金转移账户银行标识';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_method is '结算方法';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_mobile_phone is '绑定账户手机号码';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_weight is '结算权重';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_xrate_id is '结算汇兑方式';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_bank_name is '清算账号开户行行名';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.settle_xrate is '结算汇率';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_loan_settle_default.etl_timestamp is 'ETL处理时间戳';
