/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_acc_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_acc_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_acc_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_acc_loan(
    contractno varchar2(64) -- 借据号
    ,dayrate number(9,6) -- 贷款日利率
    ,encashaccttype varchar2(64) -- 收款帐号类型
    ,prinovddays number(5,0) -- 本金逾期天数
    ,encashbankname varchar2(128) -- 收款银行名称
    ,repayaccttype varchar2(64) -- 还款帐号类型
    ,cleardate varchar2(64) -- 结清日期
    ,encashamt number(20,2) -- 放款金额
    ,intbal number(20,2) -- 正常利息余额
    ,lpr number(14,10) -- LPR
    ,opttype varchar2(8) -- 转让类型，转出（OUT）\转入（IN）
    ,bsntype varchar2(64) -- 产品业务类型
    ,loanuse varchar2(2) -- 贷款用途
    ,settledate varchar2(64) -- 会计日期
    ,typecontributionration varchar2(10) -- 出资比例类型
    ,industrytype varchar2(64) -- 贷款投向行业
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,creditno varchar2(64) -- 授信编号
    ,encashacctno varchar2(64) -- 收款帐号
    ,repayacctno varchar2(64) -- 还款帐号
    ,ovdintpnltbal number(20,2) -- 逾期利息罚息余额
    ,writeoff varchar2(8) -- 核销标识，已核销为Y，否则为N
    ,assetthreetypecd varchar2(10) -- 业务模式(FVOCI模式,AC模式)
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,repaybankname varchar2(128) -- 还款银行名称
    ,ovdterms number(3,0) -- 逾期期次数
    ,contributionration varchar2(20) -- 出资比例
    ,repaymode varchar2(8) -- 还款方式
    ,encashacctname varchar2(128) -- 收款账号户名
    ,prinbal number(20,2) -- 正常本金余额
    ,cusmgrid varchar2(32) -- 客户经理
    ,loanstatus varchar2(2) -- 贷款状态
    ,enddate varchar2(64) -- 贷款到期日
    ,accruedstatus varchar2(2) -- 应计非应计标识
    ,ipid varchar2(64) -- 用户ID
    ,iswhite varchar2(2) -- 是否白户
    ,currency varchar2(3) -- 币种
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,repayacctname varchar2(128) -- 还款账号户名
    ,assetclass varchar2(2) -- 五级分类标识
    ,intovddays number(5,0) -- 利息逾期天数
    ,ovdintbal number(20,2) -- 逾期利息余额
    ,execrate number(14,10) -- 执行年利率，网商贷推送日利率X360
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,biztype varchar2(30) -- 业务种类
    ,prodcode varchar2(64) -- 产品码
    ,name varchar2(128) -- 客户真实姓名
    ,applydate varchar2(64) -- 申请支用时间
    ,totalterms number(3,0) -- 贷款期次数
    ,guaranteetype varchar2(3) -- 担保类型
    ,ovdprinbal number(20,2) -- 逾期本金余额
    ,ovdprinpnltbal number(20,2) -- 逾期本金罚息余额
    ,ratelprtype varchar2(4) -- 利率类型1基准利率2LPR
    ,encashdate varchar2(64) -- 放款日期
    ,ratetype varchar2(2) -- 利率类型
    ,nextrepaydate varchar2(64) -- 下一还款日期
    ,unclearterms number(3,0) -- 未结清期数
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,isbankrel varchar2(1) -- 是否关联人1是2否
    ,certtype varchar2(8) -- 证件类型
    ,usearea varchar2(2) -- 贷款资金使用位置
    ,graceday number(3,0) -- 宽限期天数
    ,status varchar2(10) -- 合约状态
    ,certno varchar2(60) -- 客户证件号码
    ,startdate varchar2(64) -- 贷款起息日
    ,cusid varchar2(32) -- 客户号
    ,floatratebp number(18,10) -- 利率上限浮动点差BP
    ,businessesflag varchar2(20) -- 客群经营标签（人行口径）
    ,agriflg varchar2(10) -- 是否农户
    ,classifyresult varchar2(2) -- 五级分类标识(信贷)
    ,encashbanknm varchar2(200) -- 收款银行名称
    ,externalserialno varchar2(50) -- 清算交易编号
    ,isdebttransfer number(5,0) -- 是否债权直转(1是/0否)
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,selfencashamt number(24,6) -- 我行贷款金额
    ,selfterms number(5,0) -- 我行贷款总期数
    ,selfstartdate varchar2(64) -- 我行贷款起始日
    ,contracttype varchar2(64) -- 网商借据类型
    ,contractserialno varchar2(64) -- 合同编号
    ,oldenddate varchar2(64) -- 原借据到期日
    ,isregroup varchar2(4) -- 是否重组
    ,regroupdate date -- 重组日期
    ,regrouptype varchar2(64) -- 重组贷款类型
    ,regroupcontractno varchar2(500) -- 重组前借据号（多笔借据间用|分隔）
    ,occurtype varchar2(4) -- 发生方式
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
grant select on ${iol_schema}.icms_mybk_acc_loan to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_acc_loan to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_acc_loan to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_acc_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_acc_loan is '网商贷借据信息';
comment on column ${iol_schema}.icms_mybk_acc_loan.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_acc_loan.dayrate is '贷款日利率';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashaccttype is '收款帐号类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashbankname is '收款银行名称';
comment on column ${iol_schema}.icms_mybk_acc_loan.repayaccttype is '还款帐号类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashamt is '放款金额';
comment on column ${iol_schema}.icms_mybk_acc_loan.intbal is '正常利息余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.lpr is 'LPR';
comment on column ${iol_schema}.icms_mybk_acc_loan.opttype is '转让类型，转出（OUT）\转入（IN）';
comment on column ${iol_schema}.icms_mybk_acc_loan.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_mybk_acc_loan.settledate is '会计日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.typecontributionration is '出资比例类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.industrytype is '贷款投向行业';
comment on column ${iol_schema}.icms_mybk_acc_loan.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_mybk_acc_loan.creditno is '授信编号';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_mybk_acc_loan.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_mybk_acc_loan.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_acc_loan.assetthreetypecd is '业务模式(FVOCI模式,AC模式)';
comment on column ${iol_schema}.icms_mybk_acc_loan.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_mybk_acc_loan.repaybankname is '还款银行名称';
comment on column ${iol_schema}.icms_mybk_acc_loan.ovdterms is '逾期期次数';
comment on column ${iol_schema}.icms_mybk_acc_loan.contributionration is '出资比例';
comment on column ${iol_schema}.icms_mybk_acc_loan.repaymode is '还款方式';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashacctname is '收款账号户名';
comment on column ${iol_schema}.icms_mybk_acc_loan.prinbal is '正常本金余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.cusmgrid is '客户经理';
comment on column ${iol_schema}.icms_mybk_acc_loan.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_mybk_acc_loan.enddate is '贷款到期日';
comment on column ${iol_schema}.icms_mybk_acc_loan.accruedstatus is '应计非应计标识';
comment on column ${iol_schema}.icms_mybk_acc_loan.ipid is '用户ID';
comment on column ${iol_schema}.icms_mybk_acc_loan.iswhite is '是否白户';
comment on column ${iol_schema}.icms_mybk_acc_loan.currency is '币种';
comment on column ${iol_schema}.icms_mybk_acc_loan.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_mybk_acc_loan.repayacctname is '还款账号户名';
comment on column ${iol_schema}.icms_mybk_acc_loan.assetclass is '五级分类标识';
comment on column ${iol_schema}.icms_mybk_acc_loan.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_mybk_acc_loan.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.execrate is '执行年利率，网商贷推送日利率X360';
comment on column ${iol_schema}.icms_mybk_acc_loan.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_mybk_acc_loan.biztype is '业务种类';
comment on column ${iol_schema}.icms_mybk_acc_loan.prodcode is '产品码';
comment on column ${iol_schema}.icms_mybk_acc_loan.name is '客户真实姓名';
comment on column ${iol_schema}.icms_mybk_acc_loan.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_mybk_acc_loan.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_mybk_acc_loan.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_mybk_acc_loan.ratelprtype is '利率类型1基准利率2LPR';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashdate is '放款日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.ratetype is '利率类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.nextrepaydate is '下一还款日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.unclearterms is '未结清期数';
comment on column ${iol_schema}.icms_mybk_acc_loan.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_mybk_acc_loan.isbankrel is '是否关联人1是2否';
comment on column ${iol_schema}.icms_mybk_acc_loan.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.usearea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_mybk_acc_loan.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_mybk_acc_loan.status is '合约状态';
comment on column ${iol_schema}.icms_mybk_acc_loan.certno is '客户证件号码';
comment on column ${iol_schema}.icms_mybk_acc_loan.startdate is '贷款起息日';
comment on column ${iol_schema}.icms_mybk_acc_loan.cusid is '客户号';
comment on column ${iol_schema}.icms_mybk_acc_loan.floatratebp is '利率上限浮动点差BP';
comment on column ${iol_schema}.icms_mybk_acc_loan.businessesflag is '客群经营标签（人行口径）';
comment on column ${iol_schema}.icms_mybk_acc_loan.agriflg is '是否农户';
comment on column ${iol_schema}.icms_mybk_acc_loan.classifyresult is '五级分类标识(信贷)';
comment on column ${iol_schema}.icms_mybk_acc_loan.encashbanknm is '收款银行名称';
comment on column ${iol_schema}.icms_mybk_acc_loan.externalserialno is '清算交易编号';
comment on column ${iol_schema}.icms_mybk_acc_loan.isdebttransfer is '是否债权直转(1是/0否)';
comment on column ${iol_schema}.icms_mybk_acc_loan.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.updatedate is '更新日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.selfencashamt is '我行贷款金额';
comment on column ${iol_schema}.icms_mybk_acc_loan.selfterms is '我行贷款总期数';
comment on column ${iol_schema}.icms_mybk_acc_loan.selfstartdate is '我行贷款起始日';
comment on column ${iol_schema}.icms_mybk_acc_loan.contracttype is '网商借据类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.contractserialno is '合同编号';
comment on column ${iol_schema}.icms_mybk_acc_loan.oldenddate is '原借据到期日';
comment on column ${iol_schema}.icms_mybk_acc_loan.isregroup is '是否重组';
comment on column ${iol_schema}.icms_mybk_acc_loan.regroupdate is '重组日期';
comment on column ${iol_schema}.icms_mybk_acc_loan.regrouptype is '重组贷款类型';
comment on column ${iol_schema}.icms_mybk_acc_loan.regroupcontractno is '重组前借据号（多笔借据间用|分隔）';
comment on column ${iol_schema}.icms_mybk_acc_loan.occurtype is '发生方式';
comment on column ${iol_schema}.icms_mybk_acc_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_acc_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_acc_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_acc_loan.etl_timestamp is 'ETL处理时间戳';
