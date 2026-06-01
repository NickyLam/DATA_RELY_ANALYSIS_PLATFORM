/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_loan(
    operorg varchar2(10) -- 合作机构号
    ,contractno varchar2(40) -- 借款合同号
    ,lendingref varchar2(64) -- 借据号
    ,seqno varchar2(32) -- 流水号
    ,fullname varchar2(128) -- 客户姓名
    ,termdate varchar2(4) -- 贷款期限
    ,putoutdate varchar2(8) -- 起始日期
    ,maturity varchar2(8) -- 到期日期
    ,tremmonth number(4) -- 期限月
    ,businesscurrency varchar2(3) -- 币种
    ,businesssum number(16,2) -- 贷款金额
    ,balance number(16,2) -- 贷款余额
    ,businessrate number(24,6) -- 贷款利率
    ,overduefine number(24,6) -- 逾期利率
    ,startinterestdate varchar2(8) -- 起息日
    ,payday varchar2(2) -- 还款日
    ,status varchar2(10) -- 处理标志
    ,loanstatus varchar2(10) -- 贷款状态
    ,absstatus varchar2(10) -- 资产转让状态
    ,projectid varchar2(20) -- 项目编号
    ,corpuspaymethod varchar2(20) -- 还款方式
    ,payacctno varchar2(40) -- 贷款还款账号
    ,payacctnoname varchar2(100) -- 贷款还款账号名称
    ,payacctbankno varchar2(40) -- 贷款还款行号
    ,payacctbank varchar2(100) -- 贷款还款行名
    ,inacctno varchar2(40) -- 贷款入账账号
    ,inacctnoname varchar2(100) -- 贷款入账账号名称
    ,inacctbankno varchar2(40) -- 贷款入账行号
    ,inacctbank varchar2(100) -- 贷款入账行名
    ,bondacctno varchar2(40) -- 保证金帐号
    ,typeofcust varchar2(20) -- 客户类型
    ,termflag varchar2(2) -- 短期中长期的标识
    ,lprbaserate number(16,6) -- lpr基准利率
    ,loanchangfrequency varchar2(3) -- 申请延期还款交易成功次数
    ,loanusage varchar2(10) -- 贷款用途
    ,withdrawsettleid varchar2(100) -- 放款清算交易编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 五级分类
    ,ipcode varchar2(10) -- 结息方式
    ,interestcalculatetype varchar2(10) -- 计息方式
    ,rateadjusttype varchar2(6) -- 利率调整方式
    ,repricetermunit varchar2(15) -- 利率调整周期单位
    ,repricetermfrequency varchar2(64) -- 利率调整周期频率
    ,baseratetype varchar2(4) -- 基准利率类型
    ,ratefloattype varchar2(36) -- 利率浮动方式
    ,ratefloatvalue number(20,8) -- 利率浮动值
    ,isriskcreditwhite varchar2(4) -- 风控返回是否征信白户
    ,remart varchar2(200) -- 资产三分类
    ,accrueinterday number(22,8) -- 当日应计利息
    ,ysintamt number(22,8) -- 应收欠息
    ,rcvaaccrpnlt number(22,8) -- 应收应计罚息。
    ,ysodpamt number(22,8) -- 应收罚息
    ,category varchar2(10) -- 国标行业分类
    ,fksdbusinesssum number(24,6) -- 放款时点额度金额
    ,putoutorgid varchar2(30) -- 账务机构
    ,taxflag varchar2(10) -- 涉税标识(是否免税,0-否,1-是)
    ,loanusagedesc varchar2(320) -- 贷款用途原描述
    ,overduedays number(11) -- 逾期天数
    ,paidoutdate varchar2(64) -- 结清日期
    ,ddtyp varchar2(10) -- 放款类型
    ,participantratio number(24,6) -- 
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
grant select on ${iol_schema}.icms_wyd_loan to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_loan to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_loan to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_loan is '贷款主文件';
comment on column ${iol_schema}.icms_wyd_loan.operorg is '合作机构号';
comment on column ${iol_schema}.icms_wyd_loan.contractno is '借款合同号';
comment on column ${iol_schema}.icms_wyd_loan.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_loan.seqno is '流水号';
comment on column ${iol_schema}.icms_wyd_loan.fullname is '客户姓名';
comment on column ${iol_schema}.icms_wyd_loan.termdate is '贷款期限';
comment on column ${iol_schema}.icms_wyd_loan.putoutdate is '起始日期';
comment on column ${iol_schema}.icms_wyd_loan.maturity is '到期日期';
comment on column ${iol_schema}.icms_wyd_loan.tremmonth is '期限月';
comment on column ${iol_schema}.icms_wyd_loan.businesscurrency is '币种';
comment on column ${iol_schema}.icms_wyd_loan.businesssum is '贷款金额';
comment on column ${iol_schema}.icms_wyd_loan.balance is '贷款余额';
comment on column ${iol_schema}.icms_wyd_loan.businessrate is '贷款利率';
comment on column ${iol_schema}.icms_wyd_loan.overduefine is '逾期利率';
comment on column ${iol_schema}.icms_wyd_loan.startinterestdate is '起息日';
comment on column ${iol_schema}.icms_wyd_loan.payday is '还款日';
comment on column ${iol_schema}.icms_wyd_loan.status is '处理标志';
comment on column ${iol_schema}.icms_wyd_loan.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_wyd_loan.absstatus is '资产转让状态';
comment on column ${iol_schema}.icms_wyd_loan.projectid is '项目编号';
comment on column ${iol_schema}.icms_wyd_loan.corpuspaymethod is '还款方式';
comment on column ${iol_schema}.icms_wyd_loan.payacctno is '贷款还款账号';
comment on column ${iol_schema}.icms_wyd_loan.payacctnoname is '贷款还款账号名称';
comment on column ${iol_schema}.icms_wyd_loan.payacctbankno is '贷款还款行号';
comment on column ${iol_schema}.icms_wyd_loan.payacctbank is '贷款还款行名';
comment on column ${iol_schema}.icms_wyd_loan.inacctno is '贷款入账账号';
comment on column ${iol_schema}.icms_wyd_loan.inacctnoname is '贷款入账账号名称';
comment on column ${iol_schema}.icms_wyd_loan.inacctbankno is '贷款入账行号';
comment on column ${iol_schema}.icms_wyd_loan.inacctbank is '贷款入账行名';
comment on column ${iol_schema}.icms_wyd_loan.bondacctno is '保证金帐号';
comment on column ${iol_schema}.icms_wyd_loan.typeofcust is '客户类型';
comment on column ${iol_schema}.icms_wyd_loan.termflag is '短期中长期的标识';
comment on column ${iol_schema}.icms_wyd_loan.lprbaserate is 'lpr基准利率';
comment on column ${iol_schema}.icms_wyd_loan.loanchangfrequency is '申请延期还款交易成功次数';
comment on column ${iol_schema}.icms_wyd_loan.loanusage is '贷款用途';
comment on column ${iol_schema}.icms_wyd_loan.withdrawsettleid is '放款清算交易编号';
comment on column ${iol_schema}.icms_wyd_loan.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_loan.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_loan.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_loan.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_loan.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_loan.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_loan.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_loan.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_loan.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_wyd_loan.ipcode is '结息方式';
comment on column ${iol_schema}.icms_wyd_loan.interestcalculatetype is '计息方式';
comment on column ${iol_schema}.icms_wyd_loan.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_wyd_loan.repricetermunit is '利率调整周期单位';
comment on column ${iol_schema}.icms_wyd_loan.repricetermfrequency is '利率调整周期频率';
comment on column ${iol_schema}.icms_wyd_loan.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_wyd_loan.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_wyd_loan.ratefloatvalue is '利率浮动值';
comment on column ${iol_schema}.icms_wyd_loan.isriskcreditwhite is '风控返回是否征信白户';
comment on column ${iol_schema}.icms_wyd_loan.remart is '资产三分类';
comment on column ${iol_schema}.icms_wyd_loan.accrueinterday is '当日应计利息';
comment on column ${iol_schema}.icms_wyd_loan.ysintamt is '应收欠息';
comment on column ${iol_schema}.icms_wyd_loan.rcvaaccrpnlt is '应收应计罚息。';
comment on column ${iol_schema}.icms_wyd_loan.ysodpamt is '应收罚息';
comment on column ${iol_schema}.icms_wyd_loan.category is '国标行业分类';
comment on column ${iol_schema}.icms_wyd_loan.fksdbusinesssum is '放款时点额度金额';
comment on column ${iol_schema}.icms_wyd_loan.putoutorgid is '账务机构';
comment on column ${iol_schema}.icms_wyd_loan.taxflag is '涉税标识(是否免税,0-否,1-是)';
comment on column ${iol_schema}.icms_wyd_loan.loanusagedesc is '贷款用途原描述';
comment on column ${iol_schema}.icms_wyd_loan.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_wyd_loan.paidoutdate is '结清日期';
comment on column ${iol_schema}.icms_wyd_loan.ddtyp is '放款类型';
comment on column ${iol_schema}.icms_wyd_loan.participantratio is '';
comment on column ${iol_schema}.icms_wyd_loan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_loan.etl_timestamp is 'ETL处理时间戳';
