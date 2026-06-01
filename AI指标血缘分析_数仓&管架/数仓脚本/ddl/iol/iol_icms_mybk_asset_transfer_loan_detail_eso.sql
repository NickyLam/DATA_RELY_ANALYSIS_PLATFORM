/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_asset_transfer_loan_detail_eso
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso(
    contractno varchar2(64) -- 融资平台贷款合同号
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,prodcode varchar2(64) -- 产品码
    ,name varchar2(128) -- 客户真实姓名
    ,certtype varchar2(8) -- 证件类型
    ,certno varchar2(64) -- 客户证件号码
    ,loanstatus varchar2(2) -- 贷款状态
    ,loanuse varchar2(2) -- 贷款用途
    ,usearea varchar2(2) -- 贷款资金使用位置
    ,applydate varchar2(64) -- 申请支用时间
    ,encashdate varchar2(64) -- 放款日期
    ,currency varchar2(3) -- 币种
    ,encashamt number(24,6) -- 放款金额（单位分）
    ,startdate varchar2(64) -- 贷款起息日
    ,enddate varchar2(64) -- 贷款到期日
    ,totalterms number(24,6) -- 贷款期次数
    ,repaymode varchar2(8) -- 还款方式
    ,graceday number(24,6) -- 宽限期天数
    ,ratetype varchar2(2) -- 利率类型
    ,dayrate number(24,6) -- 贷款日利率
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,guaranteetype varchar2(3) -- 担保类型
    ,creditno varchar2(64) -- 授信编号
    ,encashaccttype varchar2(64) -- 收款帐号类型
    ,encashacctname varchar2(128) -- 收款账号户名
    ,encashacctno varchar2(64) -- 收款帐号
    ,encashbankname varchar2(128) -- 收款银行名称
    ,repayaccttype varchar2(64) -- 还款帐号类型
    ,repayacctname varchar2(128) -- 还款账号户名
    ,repayacctno varchar2(64) -- 还款帐号
    ,repaybankname varchar2(128) -- 还款银行名称
    ,bsntype varchar2(64) -- 产品业务类型
    ,ipid varchar2(64) -- 用户ID
    ,regioncode varchar2(8) -- 行政区划代码
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
grant select on ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso is '网商贷转入资产放款（合约）明细文件中间表-债权直转';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.contractno is '融资平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.prodcode is '产品码';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.name is '客户真实姓名';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.certno is '客户证件号码';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.usearea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashdate is '放款日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.currency is '币种';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashamt is '放款金额（单位分）';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.startdate is '贷款起息日';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.enddate is '贷款到期日';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.repaymode is '还款方式';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.ratetype is '利率类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.dayrate is '贷款日利率';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.creditno is '授信编号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashaccttype is '收款帐号类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashacctname is '收款账号户名';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.encashbankname is '收款银行名称';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.repayaccttype is '还款帐号类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.repayacctname is '还款账号户名';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.repaybankname is '还款银行名称';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.ipid is '用户ID';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_asset_transfer_loan_detail_eso.etl_timestamp is 'ETL处理时间戳';
