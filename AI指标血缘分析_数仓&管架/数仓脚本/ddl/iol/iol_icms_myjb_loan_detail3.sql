/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_loan_detail3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_loan_detail3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_loan_detail3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_loan_detail3(
    contractno varchar2(64) -- 借据号
    ,name varchar2(128) -- 客户真实姓名
    ,loanuse varchar2(2) -- 贷款用途
    ,enddate varchar2(8) -- 贷款到期日
    ,applydate varchar2(20) -- 申请支用时间
    ,prodcode varchar2(64) -- 产品码
    ,certtype varchar2(2) -- 证件类型
    ,encashdate varchar2(20) -- 放款日期
    ,certno varchar2(18) -- 客户证件号码
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,loanstatus varchar2(2) -- 贷款状态1:成功2:失败3:在途
    ,currency varchar2(3) -- 币种，默认为CNY
    ,encashamt number(16,0) -- 放款金额（单位分）
    ,repaymode varchar2(8) -- 还款方式，1:等额本息2:等额本金
    ,guaranteetype varchar2(3) -- 担保类型
    ,encashacctno varchar2(64) -- 收款帐号
    ,totalterms number(22) -- 贷款期次数
    ,graceday number(22) -- 宽限期天数
    ,dayrate number(9,6) -- 贷款日利率，保留6位小数
    ,creditno varchar2(64) -- 授信编号
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,encashaccttype varchar2(2) -- 收款帐号类型，01:银行借记卡02:支付宝
    ,repayaccttype varchar2(2) -- 还款帐号类型，01:银行借记卡02:支付宝03:网商二类户
    ,repayacctno varchar2(64) -- 还款帐号
    ,applyno varchar2(64) -- 贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件
    ,usearea varchar2(2) -- 贷款资金使用位置
    ,startdate varchar2(8) -- 贷款起息日
    ,ratetype varchar2(2) -- 利率类型
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
grant select on ${iol_schema}.icms_myjb_loan_detail3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_loan_detail3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_loan_detail3 is '蚂蚁借呗3期放款（合约）明细文件';
comment on column ${iol_schema}.icms_myjb_loan_detail3.contractno is '借据号';
comment on column ${iol_schema}.icms_myjb_loan_detail3.name is '客户真实姓名';
comment on column ${iol_schema}.icms_myjb_loan_detail3.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_myjb_loan_detail3.enddate is '贷款到期日';
comment on column ${iol_schema}.icms_myjb_loan_detail3.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_myjb_loan_detail3.prodcode is '产品码';
comment on column ${iol_schema}.icms_myjb_loan_detail3.certtype is '证件类型';
comment on column ${iol_schema}.icms_myjb_loan_detail3.encashdate is '放款日期';
comment on column ${iol_schema}.icms_myjb_loan_detail3.certno is '客户证件号码';
comment on column ${iol_schema}.icms_myjb_loan_detail3.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_myjb_loan_detail3.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_myjb_loan_detail3.loanstatus is '贷款状态1:成功2:失败3:在途';
comment on column ${iol_schema}.icms_myjb_loan_detail3.currency is '币种，默认为CNY';
comment on column ${iol_schema}.icms_myjb_loan_detail3.encashamt is '放款金额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_detail3.repaymode is '还款方式，1:等额本息2:等额本金';
comment on column ${iol_schema}.icms_myjb_loan_detail3.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_myjb_loan_detail3.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_myjb_loan_detail3.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_myjb_loan_detail3.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_myjb_loan_detail3.dayrate is '贷款日利率，保留6位小数';
comment on column ${iol_schema}.icms_myjb_loan_detail3.creditno is '授信编号';
comment on column ${iol_schema}.icms_myjb_loan_detail3.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_myjb_loan_detail3.encashaccttype is '收款帐号类型，01:银行借记卡02:支付宝';
comment on column ${iol_schema}.icms_myjb_loan_detail3.repayaccttype is '还款帐号类型，01:银行借记卡02:支付宝03:网商二类户';
comment on column ${iol_schema}.icms_myjb_loan_detail3.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_myjb_loan_detail3.applyno is '贷款申请单号，和贷款合同号一一对应，根据这个单号可以到指定的合同文本文件目录下获取对应的文件';
comment on column ${iol_schema}.icms_myjb_loan_detail3.usearea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_myjb_loan_detail3.startdate is '贷款起息日';
comment on column ${iol_schema}.icms_myjb_loan_detail3.ratetype is '利率类型';
comment on column ${iol_schema}.icms_myjb_loan_detail3.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_loan_detail3.etl_timestamp is 'ETL处理时间戳';
