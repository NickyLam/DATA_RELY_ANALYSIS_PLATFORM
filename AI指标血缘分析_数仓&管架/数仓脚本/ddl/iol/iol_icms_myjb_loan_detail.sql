/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_loan_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_loan_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_loan_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_loan_detail(
    contract_no varchar2(64) -- 借据号
    ,credit_no varchar2(64) -- 授信编号
    ,encash_acct_type varchar2(2) -- 收款帐号类型，01:银行借记卡02:支付宝
    ,guarantee_type varchar2(3) -- 担保类型
    ,apply_no varchar2(64) -- 贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件
    ,name varchar2(128) -- 客户真实姓名
    ,grace_day number(22) -- 宽限期天数
    ,prin_repay_frequency varchar2(2) -- 本金还款频率
    ,encash_date varchar2(20) -- 放款日期
    ,fund_seq_no varchar2(64) -- 放款资金流水号
    ,start_date varchar2(8) -- 贷款起息日
    ,encash_acct_no varchar2(64) -- 收款帐号
    ,end_date varchar2(8) -- 贷款到期日
    ,rate_type varchar2(2) -- 利率类型
    ,repay_acct_type varchar2(2) -- 还款帐号类型，01:银行借记卡02:支付宝03:网商二类户
    ,repay_acct_no varchar2(64) -- 还款帐号
    ,loan_status varchar2(2) -- 贷款状态1:成功2:失败3:在途
    ,apply_date varchar2(20) -- 申请支用时间
    ,encash_amt number(16,0) -- 放款金额（单位分）
    ,cert_no varchar2(18) -- 客户证件号码
    ,use_area varchar2(2) -- 贷款资金使用位置
    ,int_repay_frequency varchar2(2) -- 利息还款频率
    ,currency varchar2(3) -- 币种，默认为CNY
    ,day_rate number(9,6) -- 贷款日利率，保留6位小数
    ,cert_type varchar2(2) -- 证件类型
    ,loan_use varchar2(2) -- 贷款用途
    ,repay_mode varchar2(8) -- 还款方式，1:等额本息2:等额本金
    ,total_terms number(22) -- 贷款期次数
    ,prod_code varchar2(64) -- 产品码
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
grant select on ${iol_schema}.icms_myjb_loan_detail to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_loan_detail is '蚂蚁借呗放款（合约）明细文件';
comment on column ${iol_schema}.icms_myjb_loan_detail.contract_no is '借据号';
comment on column ${iol_schema}.icms_myjb_loan_detail.credit_no is '授信编号';
comment on column ${iol_schema}.icms_myjb_loan_detail.encash_acct_type is '收款帐号类型，01:银行借记卡02:支付宝';
comment on column ${iol_schema}.icms_myjb_loan_detail.guarantee_type is '担保类型';
comment on column ${iol_schema}.icms_myjb_loan_detail.apply_no is '贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件';
comment on column ${iol_schema}.icms_myjb_loan_detail.name is '客户真实姓名';
comment on column ${iol_schema}.icms_myjb_loan_detail.grace_day is '宽限期天数';
comment on column ${iol_schema}.icms_myjb_loan_detail.prin_repay_frequency is '本金还款频率';
comment on column ${iol_schema}.icms_myjb_loan_detail.encash_date is '放款日期';
comment on column ${iol_schema}.icms_myjb_loan_detail.fund_seq_no is '放款资金流水号';
comment on column ${iol_schema}.icms_myjb_loan_detail.start_date is '贷款起息日';
comment on column ${iol_schema}.icms_myjb_loan_detail.encash_acct_no is '收款帐号';
comment on column ${iol_schema}.icms_myjb_loan_detail.end_date is '贷款到期日';
comment on column ${iol_schema}.icms_myjb_loan_detail.rate_type is '利率类型';
comment on column ${iol_schema}.icms_myjb_loan_detail.repay_acct_type is '还款帐号类型，01:银行借记卡02:支付宝03:网商二类户';
comment on column ${iol_schema}.icms_myjb_loan_detail.repay_acct_no is '还款帐号';
comment on column ${iol_schema}.icms_myjb_loan_detail.loan_status is '贷款状态1:成功2:失败3:在途';
comment on column ${iol_schema}.icms_myjb_loan_detail.apply_date is '申请支用时间';
comment on column ${iol_schema}.icms_myjb_loan_detail.encash_amt is '放款金额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_detail.cert_no is '客户证件号码';
comment on column ${iol_schema}.icms_myjb_loan_detail.use_area is '贷款资金使用位置';
comment on column ${iol_schema}.icms_myjb_loan_detail.int_repay_frequency is '利息还款频率';
comment on column ${iol_schema}.icms_myjb_loan_detail.currency is '币种，默认为CNY';
comment on column ${iol_schema}.icms_myjb_loan_detail.day_rate is '贷款日利率，保留6位小数';
comment on column ${iol_schema}.icms_myjb_loan_detail.cert_type is '证件类型';
comment on column ${iol_schema}.icms_myjb_loan_detail.loan_use is '贷款用途';
comment on column ${iol_schema}.icms_myjb_loan_detail.repay_mode is '还款方式，1:等额本息2:等额本金';
comment on column ${iol_schema}.icms_myjb_loan_detail.total_terms is '贷款期次数';
comment on column ${iol_schema}.icms_myjb_loan_detail.prod_code is '产品码';
comment on column ${iol_schema}.icms_myjb_loan_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_loan_detail.etl_timestamp is 'ETL处理时间戳';
