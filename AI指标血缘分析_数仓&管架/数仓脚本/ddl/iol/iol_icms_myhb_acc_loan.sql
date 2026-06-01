/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_acc_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_acc_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_acc_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_acc_loan(
    billno varchar2(64) -- 借据号
    ,isbankrel varchar2(1) -- 是否关联人1是2否
    ,ratetype varchar2(2) -- 利率类型
    ,agreementno varchar2(64) -- 贷款合同号
    ,settledate varchar2(8) -- 会计日期
    ,ovdprinbal number(20,2) -- 逾期本金余额
    ,floatratebp number(14,2) -- 利率浮动点差BP
    ,ratelprtype varchar2(4) -- lpr利率类型
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,encashaccttype varchar2(2) -- 收款帐号类型
    ,cleardate varchar2(64) -- 结清日期
    ,assetclass varchar2(2) -- 五级分类标识
    ,ovdintbal number(20,2) -- 逾期利息余额
    ,creditcode varchar2(64) -- 额度类型
    ,applydate varchar2(20) -- 申请支用时间
    ,encashamt number(20,2) -- 放款金额
    ,totalterms number(22) -- 贷款期次数
    ,migtflag varchar2(80) -- 
    ,iswhite varchar2(2) -- 是否白户
    ,loanuse varchar2(2) -- 贷款用途
    ,repayaccttype varchar2(2) -- 还款帐号类型
    ,prinbal number(20,2) -- 正常本金余额
    ,ovdprinpnltbal number(20,2) -- 逾期本金罚息余额
    ,regioncode varchar2(8) -- 行政区划代码
    ,certtype varchar2(4) -- 证件类型
    ,loanstatus varchar2(2) -- 贷款状态
    ,guaranteetype varchar2(3) -- 担保类型
    ,applyno varchar2(64) -- 贷款申请单号
    ,encashacctnobak varchar2(60) -- 收款帐号2
    ,usearea varchar2(2) -- 贷款资金使用位置
    ,startdate varchar2(8) -- 贷款起息日
    ,graceday number(22) -- 宽限期天数
    ,ovdterms number(22) -- 逾期期次数
    ,intovddays number(22) -- 利息逾期天数
    ,encashacctno varchar2(128) -- 收款帐号
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,prodcode varchar2(64) -- 产品码
    ,internaltransfertag varchar2(8) -- 内部结转标识
    ,cusmgr varchar2(20) -- 客户经理
    ,beginprin number(20,2) -- 贷款原始本金
    ,repayacctnobak varchar2(60) -- 还款帐号2
    ,enddate varchar2(8) -- 贷款到期日
    ,totalfeerate number(9,6) -- 分期总手续费率
    ,dayrate number(9,6) -- 贷款日利率
    ,assetthreetypecd varchar2(10) -- 业务模式(FVOCI模式,AC模式)
    ,intbal number(20,2) -- 正常利息余额
    ,ovdintpnltbal number(20,2) -- 逾期利息罚息余额
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,currency varchar2(3) -- 币种
    ,creditno varchar2(64) -- 授信编号
    ,accruedstatus varchar2(2) -- 应计非应计标识
    ,contracttype varchar2(8) -- 借据类型
    ,certno varchar2(60) -- 客户证件号码
    ,cusid varchar2(20) -- 客户号
    ,encashdate varchar2(20) -- 放款日期
    ,repayacctno varchar2(128) -- 还款帐号
    ,status varchar2(10) -- 合约状态
    ,lpr number(14,10) -- LPR
    ,name varchar2(128) -- 客户真实姓名
    ,repaymode varchar2(2) -- 还款方式
    ,prinovddays number(22) -- 本金逾期天数
    ,biztype varchar2(30) -- 产品编号
    ,fundseqno varchar2(128) -- 放款资金流水号
    ,nextrepaydate varchar2(8) -- 下一还款日期
    ,unclearterms number(22) -- 未结清期数
    ,execrate number(14,10) -- 执行年利率，推送日利率X360
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
grant select on ${iol_schema}.icms_myhb_acc_loan to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_acc_loan to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_acc_loan to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_acc_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_acc_loan is '花呗借据信息';
comment on column ${iol_schema}.icms_myhb_acc_loan.billno is '借据号';
comment on column ${iol_schema}.icms_myhb_acc_loan.isbankrel is '是否关联人1是2否';
comment on column ${iol_schema}.icms_myhb_acc_loan.ratetype is '利率类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.agreementno is '贷款合同号';
comment on column ${iol_schema}.icms_myhb_acc_loan.settledate is '会计日期';
comment on column ${iol_schema}.icms_myhb_acc_loan.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.floatratebp is '利率浮动点差BP';
comment on column ${iol_schema}.icms_myhb_acc_loan.ratelprtype is 'lpr利率类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_myhb_acc_loan.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_myhb_acc_loan.encashaccttype is '收款帐号类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_myhb_acc_loan.assetclass is '五级分类标识';
comment on column ${iol_schema}.icms_myhb_acc_loan.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.creditcode is '额度类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_myhb_acc_loan.encashamt is '放款金额';
comment on column ${iol_schema}.icms_myhb_acc_loan.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_myhb_acc_loan.migtflag is '';
comment on column ${iol_schema}.icms_myhb_acc_loan.iswhite is '是否白户';
comment on column ${iol_schema}.icms_myhb_acc_loan.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_myhb_acc_loan.repayaccttype is '还款帐号类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.prinbal is '正常本金余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_myhb_acc_loan.certtype is '证件类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_myhb_acc_loan.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.applyno is '贷款申请单号';
comment on column ${iol_schema}.icms_myhb_acc_loan.encashacctnobak is '收款帐号2';
comment on column ${iol_schema}.icms_myhb_acc_loan.usearea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_myhb_acc_loan.startdate is '贷款起息日';
comment on column ${iol_schema}.icms_myhb_acc_loan.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_myhb_acc_loan.ovdterms is '逾期期次数';
comment on column ${iol_schema}.icms_myhb_acc_loan.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_myhb_acc_loan.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_myhb_acc_loan.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myhb_acc_loan.prodcode is '产品码';
comment on column ${iol_schema}.icms_myhb_acc_loan.internaltransfertag is '内部结转标识';
comment on column ${iol_schema}.icms_myhb_acc_loan.cusmgr is '客户经理';
comment on column ${iol_schema}.icms_myhb_acc_loan.beginprin is '贷款原始本金';
comment on column ${iol_schema}.icms_myhb_acc_loan.repayacctnobak is '还款帐号2';
comment on column ${iol_schema}.icms_myhb_acc_loan.enddate is '贷款到期日';
comment on column ${iol_schema}.icms_myhb_acc_loan.totalfeerate is '分期总手续费率';
comment on column ${iol_schema}.icms_myhb_acc_loan.dayrate is '贷款日利率';
comment on column ${iol_schema}.icms_myhb_acc_loan.assetthreetypecd is '业务模式(FVOCI模式,AC模式)';
comment on column ${iol_schema}.icms_myhb_acc_loan.intbal is '正常利息余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_myhb_acc_loan.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_myhb_acc_loan.currency is '币种';
comment on column ${iol_schema}.icms_myhb_acc_loan.creditno is '授信编号';
comment on column ${iol_schema}.icms_myhb_acc_loan.accruedstatus is '应计非应计标识';
comment on column ${iol_schema}.icms_myhb_acc_loan.contracttype is '借据类型';
comment on column ${iol_schema}.icms_myhb_acc_loan.certno is '客户证件号码';
comment on column ${iol_schema}.icms_myhb_acc_loan.cusid is '客户号';
comment on column ${iol_schema}.icms_myhb_acc_loan.encashdate is '放款日期';
comment on column ${iol_schema}.icms_myhb_acc_loan.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_myhb_acc_loan.status is '合约状态';
comment on column ${iol_schema}.icms_myhb_acc_loan.lpr is 'LPR';
comment on column ${iol_schema}.icms_myhb_acc_loan.name is '客户真实姓名';
comment on column ${iol_schema}.icms_myhb_acc_loan.repaymode is '还款方式';
comment on column ${iol_schema}.icms_myhb_acc_loan.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myhb_acc_loan.biztype is '产品编号';
comment on column ${iol_schema}.icms_myhb_acc_loan.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_myhb_acc_loan.nextrepaydate is '下一还款日期';
comment on column ${iol_schema}.icms_myhb_acc_loan.unclearterms is '未结清期数';
comment on column ${iol_schema}.icms_myhb_acc_loan.execrate is '执行年利率，推送日利率X360';
comment on column ${iol_schema}.icms_myhb_acc_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myhb_acc_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myhb_acc_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myhb_acc_loan.etl_timestamp is 'ETL处理时间戳';
