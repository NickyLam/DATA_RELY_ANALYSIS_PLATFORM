/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_trans_loan_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_trans_loan_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_trans_loan_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_trans_loan_detail(
    contractno varchar2(64) -- 融资平台贷款合同号
    ,encashaccttype varchar2(64) -- 收款帐号类型
    ,ipid varchar2(64) -- 用户ID
    ,regioncode varchar2(8) -- 行政区划代码
    ,name varchar2(128) -- 客户真实姓名
    ,repaymode varchar2(8) -- 还款方式
    ,dayrate number(22) -- 贷款日利率
    ,repayaccttype varchar2(64) -- 还款帐号类型
    ,repayacctname varchar2(128) -- 还款账号户名
    ,graceday number(22) -- 宽限期天数
    ,startdate varchar2(64) -- 贷款起息日
    ,ratetype varchar2(2) -- 利率类型
    ,repaybankname varchar2(128) -- 还款银行名称
    ,yearrate number(22) -- 贷款年利率
    ,prodcode varchar2(64) -- 产品码
    ,certtype varchar2(8) -- 证件类型
    ,repayacctno varchar2(64) -- 还款帐号
    ,usearea varchar2(2) -- 贷款资金使用位置，0:境外1:境内
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,encashbankname varchar2(128) -- 收款银行名称
    ,loanstatus varchar2(2) -- 贷款状态
    ,encashdate varchar2(64) -- 放款日期
    ,totalterms number(20,0) -- 贷款期次数
    ,encashacctno varchar2(64) -- 收款帐号
    ,applydate varchar2(64) -- 申请支用时间
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,creditno varchar2(64) -- 授信编号
    ,encashacctname varchar2(128) -- 收款账号户名
    ,bsntype varchar2(64) -- 产品业务类型
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,currency varchar2(3) -- 币种
    ,encashamt number(22) -- 放款金额
    ,certno varchar2(64) -- 客户证件号码
    ,enddate varchar2(64) -- 贷款到期日
    ,guaranteetype varchar2(3) -- 担保类型
    ,loanuse varchar2(2) -- 贷款用途
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
grant select on ${iol_schema}.icms_mybk_asset_trans_loan_detail to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_trans_loan_detail to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_trans_loan_detail to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_trans_loan_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_trans_loan_detail is '转入资产放款（合约）明细文件';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.contractno is '融资平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashaccttype is '收款帐号类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.ipid is '用户ID';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.name is '客户真实姓名';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.repaymode is '还款方式';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.dayrate is '贷款日利率';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.repayaccttype is '还款帐号类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.repayacctname is '还款账号户名';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.startdate is '贷款起息日';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.ratetype is '利率类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.repaybankname is '还款银行名称';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.yearrate is '贷款年利率';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.prodcode is '产品码';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.usearea is '贷款资金使用位置，0:境外1:境内';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashbankname is '收款银行名称';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashdate is '放款日期';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.creditno is '授信编号';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashacctname is '收款账号户名';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.currency is '币种';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.encashamt is '放款金额';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.certno is '客户证件号码';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.enddate is '贷款到期日';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_trans_loan_detail.etl_timestamp is 'ETL处理时间戳';
