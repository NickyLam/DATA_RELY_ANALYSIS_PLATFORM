/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_acc_loan
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_mybk_acc_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybk_acc_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_acc_loan_op purge;
drop table ${iol_schema}.icms_mybk_acc_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_acc_loan_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_mybk_acc_loan where 0=1;

create table ${iol_schema}.icms_mybk_acc_loan_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_mybk_acc_loan where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_mybk_acc_loan_op(
        contractno -- 借据号
        ,dayrate -- 贷款日利率
        ,encashaccttype -- 收款帐号类型
        ,prinovddays -- 本金逾期天数
        ,encashbankname -- 收款银行名称
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期
        ,encashamt -- 放款金额
        ,intbal -- 正常利息余额
        ,lpr -- LPR
        ,opttype -- 转让类型，转出（OUT）\转入（IN）
        ,bsntype -- 产品业务类型
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,typecontributionration -- 出资比例类型
        ,industrytype -- 贷款投向行业
        ,fundseqno -- 放款资金流水号
        ,creditno -- 授信编号
        ,encashacctno -- 收款帐号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intrepayfrequency -- 利息还款频率
        ,repaybankname -- 还款银行名称
        ,ovdterms -- 逾期期次数
        ,contributionration -- 出资比例
        ,repaymode -- 还款方式
        ,encashacctname -- 收款账号户名
        ,prinbal -- 正常本金余额
        ,cusmgrid -- 客户经理
        ,loanstatus -- 贷款状态
        ,enddate -- 贷款到期日
        ,accruedstatus -- 应计非应计标识
        ,ipid -- 用户ID
        ,iswhite -- 是否白户
        ,currency -- 币种
        ,prinrepayfrequency -- 本金还款频率
        ,repayacctname -- 还款账号户名
        ,assetclass -- 五级分类标识
        ,intovddays -- 利息逾期天数
        ,ovdintbal -- 逾期利息余额
        ,execrate -- 执行年利率，网商贷推送日利率X360
        ,migtflag -- 迁移标志：crs rcr ilc upl
        ,biztype -- 业务种类
        ,prodcode -- 产品码
        ,name -- 客户真实姓名
        ,applydate -- 申请支用时间
        ,totalterms -- 贷款期次数
        ,guaranteetype -- 担保类型
        ,ovdprinbal -- 逾期本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,ratelprtype -- 利率类型1基准利率2LPR
        ,encashdate -- 放款日期
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,ratefloatmode -- 利率浮动方式
        ,isbankrel -- 是否关联人1是2否
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,graceday -- 宽限期天数
        ,status -- 合约状态
        ,certno -- 客户证件号码
        ,startdate -- 贷款起息日
        ,cusid -- 客户号
        ,floatratebp -- 利率上限浮动点差BP
        ,businessesflag -- 客群经营标签（人行口径）
        ,agriflg -- 是否农户
        ,classifyresult -- 五级分类标识(信贷)
        ,encashbanknm -- 收款银行名称
        ,externalserialno -- 清算交易编号
        ,isdebttransfer -- 是否债权直转(1是/0否)
        ,inputdate -- 登记日期
        ,updatedate -- 更新日期
        ,selfencashamt -- 我行贷款金额
        ,selfterms -- 我行贷款总期数
        ,selfstartdate -- 我行贷款起始日
        ,contracttype -- 网商借据类型
        ,contractserialno -- 合同编号
        ,oldenddate -- 原借据到期日
        ,isregroup -- 是否重组
        ,regroupdate -- 重组日期
        ,regrouptype -- 重组贷款类型
        ,regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
        ,occurtype -- 发生方式
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.contractno -- 借据号
    ,n.dayrate -- 贷款日利率
    ,n.encashaccttype -- 收款帐号类型
    ,n.prinovddays -- 本金逾期天数
    ,n.encashbankname -- 收款银行名称
    ,n.repayaccttype -- 还款帐号类型
    ,n.cleardate -- 结清日期
    ,n.encashamt -- 放款金额
    ,n.intbal -- 正常利息余额
    ,n.lpr -- LPR
    ,n.opttype -- 转让类型，转出（OUT）\转入（IN）
    ,n.bsntype -- 产品业务类型
    ,n.loanuse -- 贷款用途
    ,n.settledate -- 会计日期
    ,n.typecontributionration -- 出资比例类型
    ,n.industrytype -- 贷款投向行业
    ,n.fundseqno -- 放款资金流水号
    ,n.creditno -- 授信编号
    ,n.encashacctno -- 收款帐号
    ,n.repayacctno -- 还款帐号
    ,n.ovdintpnltbal -- 逾期利息罚息余额
    ,n.writeoff -- 核销标识，已核销为Y，否则为N
    ,n.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,n.intrepayfrequency -- 利息还款频率
    ,n.repaybankname -- 还款银行名称
    ,n.ovdterms -- 逾期期次数
    ,n.contributionration -- 出资比例
    ,n.repaymode -- 还款方式
    ,n.encashacctname -- 收款账号户名
    ,n.prinbal -- 正常本金余额
    ,n.cusmgrid -- 客户经理
    ,n.loanstatus -- 贷款状态
    ,n.enddate -- 贷款到期日
    ,n.accruedstatus -- 应计非应计标识
    ,n.ipid -- 用户ID
    ,n.iswhite -- 是否白户
    ,n.currency -- 币种
    ,n.prinrepayfrequency -- 本金还款频率
    ,n.repayacctname -- 还款账号户名
    ,n.assetclass -- 五级分类标识
    ,n.intovddays -- 利息逾期天数
    ,n.ovdintbal -- 逾期利息余额
    ,n.execrate -- 执行年利率，网商贷推送日利率X360
    ,n.migtflag -- 迁移标志：crs rcr ilc upl
    ,n.biztype -- 业务种类
    ,n.prodcode -- 产品码
    ,n.name -- 客户真实姓名
    ,n.applydate -- 申请支用时间
    ,n.totalterms -- 贷款期次数
    ,n.guaranteetype -- 担保类型
    ,n.ovdprinbal -- 逾期本金余额
    ,n.ovdprinpnltbal -- 逾期本金罚息余额
    ,n.ratelprtype -- 利率类型1基准利率2LPR
    ,n.encashdate -- 放款日期
    ,n.ratetype -- 利率类型
    ,n.nextrepaydate -- 下一还款日期
    ,n.unclearterms -- 未结清期数
    ,n.ratefloatmode -- 利率浮动方式
    ,n.isbankrel -- 是否关联人1是2否
    ,n.certtype -- 证件类型
    ,n.usearea -- 贷款资金使用位置
    ,n.graceday -- 宽限期天数
    ,n.status -- 合约状态
    ,n.certno -- 客户证件号码
    ,n.startdate -- 贷款起息日
    ,n.cusid -- 客户号
    ,n.floatratebp -- 利率上限浮动点差BP
    ,n.businessesflag -- 客群经营标签（人行口径）
    ,n.agriflg -- 是否农户
    ,n.classifyresult -- 五级分类标识(信贷)
    ,n.encashbanknm -- 收款银行名称
    ,n.externalserialno -- 清算交易编号
    ,n.isdebttransfer -- 是否债权直转(1是/0否)
    ,n.inputdate -- 登记日期
    ,n.updatedate -- 更新日期
    ,n.selfencashamt -- 我行贷款金额
    ,n.selfterms -- 我行贷款总期数
    ,n.selfstartdate -- 我行贷款起始日
    ,n.contracttype -- 网商借据类型
    ,n.contractserialno -- 合同编号
    ,n.oldenddate -- 原借据到期日
    ,n.isregroup -- 是否重组
    ,n.regroupdate -- 重组日期
    ,n.regrouptype -- 重组贷款类型
    ,n.regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
    ,n.occurtype -- 发生方式
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_mybk_acc_loan_bk o
    right join (select * from ${itl_schema}.icms_mybk_acc_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractno = n.contractno
where (
        o.contractno is null
    )
    or (
        o.dayrate <> n.dayrate
        or o.encashaccttype <> n.encashaccttype
        or o.prinovddays <> n.prinovddays
        or o.encashbankname <> n.encashbankname
        or o.repayaccttype <> n.repayaccttype
        or o.cleardate <> n.cleardate
        or o.encashamt <> n.encashamt
        or o.intbal <> n.intbal
        or o.lpr <> n.lpr
        or o.opttype <> n.opttype
        or o.bsntype <> n.bsntype
        or o.loanuse <> n.loanuse
        or o.settledate <> n.settledate
        or o.typecontributionration <> n.typecontributionration
        or o.industrytype <> n.industrytype
        or o.fundseqno <> n.fundseqno
        or o.creditno <> n.creditno
        or o.encashacctno <> n.encashacctno
        or o.repayacctno <> n.repayacctno
        or o.ovdintpnltbal <> n.ovdintpnltbal
        or o.writeoff <> n.writeoff
        or o.assetthreetypecd <> n.assetthreetypecd
        or o.intrepayfrequency <> n.intrepayfrequency
        or o.repaybankname <> n.repaybankname
        or o.ovdterms <> n.ovdterms
        or o.contributionration <> n.contributionration
        or o.repaymode <> n.repaymode
        or o.encashacctname <> n.encashacctname
        or o.prinbal <> n.prinbal
        or o.cusmgrid <> n.cusmgrid
        or o.loanstatus <> n.loanstatus
        or o.enddate <> n.enddate
        or o.accruedstatus <> n.accruedstatus
        or o.ipid <> n.ipid
        or o.iswhite <> n.iswhite
        or o.currency <> n.currency
        or o.prinrepayfrequency <> n.prinrepayfrequency
        or o.repayacctname <> n.repayacctname
        or o.assetclass <> n.assetclass
        or o.intovddays <> n.intovddays
        or o.ovdintbal <> n.ovdintbal
        or o.execrate <> n.execrate
        or o.migtflag <> n.migtflag
        or o.biztype <> n.biztype
        or o.prodcode <> n.prodcode
        or o.name <> n.name
        or o.applydate <> n.applydate
        or o.totalterms <> n.totalterms
        or o.guaranteetype <> n.guaranteetype
        or o.ovdprinbal <> n.ovdprinbal
        or o.ovdprinpnltbal <> n.ovdprinpnltbal
        or o.ratelprtype <> n.ratelprtype
        or o.encashdate <> n.encashdate
        or o.ratetype <> n.ratetype
        or o.nextrepaydate <> n.nextrepaydate
        or o.unclearterms <> n.unclearterms
        or o.ratefloatmode <> n.ratefloatmode
        or o.isbankrel <> n.isbankrel
        or o.certtype <> n.certtype
        or o.usearea <> n.usearea
        or o.graceday <> n.graceday
        or o.status <> n.status
        or o.certno <> n.certno
        or o.startdate <> n.startdate
        or o.cusid <> n.cusid
        or o.floatratebp <> n.floatratebp
        or o.businessesflag <> n.businessesflag
        or o.agriflg <> n.agriflg
        or o.classifyresult <> n.classifyresult
        or o.encashbanknm <> n.encashbanknm
        or o.externalserialno <> n.externalserialno
        or o.isdebttransfer <> n.isdebttransfer
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.selfencashamt <> n.selfencashamt
        or o.selfterms <> n.selfterms
        or o.selfstartdate <> n.selfstartdate
        or o.contracttype <> n.contracttype
        or o.contractserialno <> n.contractserialno
        or o.oldenddate <> n.oldenddate
        or o.isregroup <> n.isregroup
        or o.regroupdate <> n.regroupdate
        or o.regrouptype <> n.regrouptype
        or o.regroupcontractno <> n.regroupcontractno
        or o.occurtype <> n.occurtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybk_acc_loan_cl(
            contractno -- 借据号
        ,dayrate -- 贷款日利率
        ,encashaccttype -- 收款帐号类型
        ,prinovddays -- 本金逾期天数
        ,encashbankname -- 收款银行名称
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期
        ,encashamt -- 放款金额
        ,intbal -- 正常利息余额
        ,lpr -- LPR
        ,opttype -- 转让类型，转出（OUT）\转入（IN）
        ,bsntype -- 产品业务类型
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,typecontributionration -- 出资比例类型
        ,industrytype -- 贷款投向行业
        ,fundseqno -- 放款资金流水号
        ,creditno -- 授信编号
        ,encashacctno -- 收款帐号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intrepayfrequency -- 利息还款频率
        ,repaybankname -- 还款银行名称
        ,ovdterms -- 逾期期次数
        ,contributionration -- 出资比例
        ,repaymode -- 还款方式
        ,encashacctname -- 收款账号户名
        ,prinbal -- 正常本金余额
        ,cusmgrid -- 客户经理
        ,loanstatus -- 贷款状态
        ,enddate -- 贷款到期日
        ,accruedstatus -- 应计非应计标识
        ,ipid -- 用户ID
        ,iswhite -- 是否白户
        ,currency -- 币种
        ,prinrepayfrequency -- 本金还款频率
        ,repayacctname -- 还款账号户名
        ,assetclass -- 五级分类标识
        ,intovddays -- 利息逾期天数
        ,ovdintbal -- 逾期利息余额
        ,execrate -- 执行年利率，网商贷推送日利率X360
        ,migtflag -- 迁移标志：crs rcr ilc upl
        ,biztype -- 业务种类
        ,prodcode -- 产品码
        ,name -- 客户真实姓名
        ,applydate -- 申请支用时间
        ,totalterms -- 贷款期次数
        ,guaranteetype -- 担保类型
        ,ovdprinbal -- 逾期本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,ratelprtype -- 利率类型1基准利率2LPR
        ,encashdate -- 放款日期
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,ratefloatmode -- 利率浮动方式
        ,isbankrel -- 是否关联人1是2否
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,graceday -- 宽限期天数
        ,status -- 合约状态
        ,certno -- 客户证件号码
        ,startdate -- 贷款起息日
        ,cusid -- 客户号
        ,floatratebp -- 利率上限浮动点差BP
        ,businessesflag -- 客群经营标签（人行口径）
        ,agriflg -- 是否农户
        ,classifyresult -- 五级分类标识(信贷)
        ,encashbanknm -- 收款银行名称
        ,externalserialno -- 清算交易编号
        ,isdebttransfer -- 是否债权直转(1是/0否)
        ,inputdate -- 登记日期
        ,updatedate -- 更新日期
        ,selfencashamt -- 我行贷款金额
        ,selfterms -- 我行贷款总期数
        ,selfstartdate -- 我行贷款起始日
        ,contracttype -- 网商借据类型
        ,contractserialno -- 合同编号
        ,oldenddate -- 原借据到期日
        ,isregroup -- 是否重组
        ,regroupdate -- 重组日期
        ,regrouptype -- 重组贷款类型
        ,regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
        ,occurtype -- 发生方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybk_acc_loan_op(
            contractno -- 借据号
        ,dayrate -- 贷款日利率
        ,encashaccttype -- 收款帐号类型
        ,prinovddays -- 本金逾期天数
        ,encashbankname -- 收款银行名称
        ,repayaccttype -- 还款帐号类型
        ,cleardate -- 结清日期
        ,encashamt -- 放款金额
        ,intbal -- 正常利息余额
        ,lpr -- LPR
        ,opttype -- 转让类型，转出（OUT）\转入（IN）
        ,bsntype -- 产品业务类型
        ,loanuse -- 贷款用途
        ,settledate -- 会计日期
        ,typecontributionration -- 出资比例类型
        ,industrytype -- 贷款投向行业
        ,fundseqno -- 放款资金流水号
        ,creditno -- 授信编号
        ,encashacctno -- 收款帐号
        ,repayacctno -- 还款帐号
        ,ovdintpnltbal -- 逾期利息罚息余额
        ,writeoff -- 核销标识，已核销为Y，否则为N
        ,assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
        ,intrepayfrequency -- 利息还款频率
        ,repaybankname -- 还款银行名称
        ,ovdterms -- 逾期期次数
        ,contributionration -- 出资比例
        ,repaymode -- 还款方式
        ,encashacctname -- 收款账号户名
        ,prinbal -- 正常本金余额
        ,cusmgrid -- 客户经理
        ,loanstatus -- 贷款状态
        ,enddate -- 贷款到期日
        ,accruedstatus -- 应计非应计标识
        ,ipid -- 用户ID
        ,iswhite -- 是否白户
        ,currency -- 币种
        ,prinrepayfrequency -- 本金还款频率
        ,repayacctname -- 还款账号户名
        ,assetclass -- 五级分类标识
        ,intovddays -- 利息逾期天数
        ,ovdintbal -- 逾期利息余额
        ,execrate -- 执行年利率，网商贷推送日利率X360
        ,migtflag -- 迁移标志：crs rcr ilc upl
        ,biztype -- 业务种类
        ,prodcode -- 产品码
        ,name -- 客户真实姓名
        ,applydate -- 申请支用时间
        ,totalterms -- 贷款期次数
        ,guaranteetype -- 担保类型
        ,ovdprinbal -- 逾期本金余额
        ,ovdprinpnltbal -- 逾期本金罚息余额
        ,ratelprtype -- 利率类型1基准利率2LPR
        ,encashdate -- 放款日期
        ,ratetype -- 利率类型
        ,nextrepaydate -- 下一还款日期
        ,unclearterms -- 未结清期数
        ,ratefloatmode -- 利率浮动方式
        ,isbankrel -- 是否关联人1是2否
        ,certtype -- 证件类型
        ,usearea -- 贷款资金使用位置
        ,graceday -- 宽限期天数
        ,status -- 合约状态
        ,certno -- 客户证件号码
        ,startdate -- 贷款起息日
        ,cusid -- 客户号
        ,floatratebp -- 利率上限浮动点差BP
        ,businessesflag -- 客群经营标签（人行口径）
        ,agriflg -- 是否农户
        ,classifyresult -- 五级分类标识(信贷)
        ,encashbanknm -- 收款银行名称
        ,externalserialno -- 清算交易编号
        ,isdebttransfer -- 是否债权直转(1是/0否)
        ,inputdate -- 登记日期
        ,updatedate -- 更新日期
        ,selfencashamt -- 我行贷款金额
        ,selfterms -- 我行贷款总期数
        ,selfstartdate -- 我行贷款起始日
        ,contracttype -- 网商借据类型
        ,contractserialno -- 合同编号
        ,oldenddate -- 原借据到期日
        ,isregroup -- 是否重组
        ,regroupdate -- 重组日期
        ,regrouptype -- 重组贷款类型
        ,regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
        ,occurtype -- 发生方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contractno -- 借据号
    ,o.dayrate -- 贷款日利率
    ,o.encashaccttype -- 收款帐号类型
    ,o.prinovddays -- 本金逾期天数
    ,o.encashbankname -- 收款银行名称
    ,o.repayaccttype -- 还款帐号类型
    ,o.cleardate -- 结清日期
    ,o.encashamt -- 放款金额
    ,o.intbal -- 正常利息余额
    ,o.lpr -- LPR
    ,o.opttype -- 转让类型，转出（OUT）\转入（IN）
    ,o.bsntype -- 产品业务类型
    ,o.loanuse -- 贷款用途
    ,o.settledate -- 会计日期
    ,o.typecontributionration -- 出资比例类型
    ,o.industrytype -- 贷款投向行业
    ,o.fundseqno -- 放款资金流水号
    ,o.creditno -- 授信编号
    ,o.encashacctno -- 收款帐号
    ,o.repayacctno -- 还款帐号
    ,o.ovdintpnltbal -- 逾期利息罚息余额
    ,o.writeoff -- 核销标识，已核销为Y，否则为N
    ,o.assetthreetypecd -- 业务模式(FVOCI模式,AC模式)
    ,o.intrepayfrequency -- 利息还款频率
    ,o.repaybankname -- 还款银行名称
    ,o.ovdterms -- 逾期期次数
    ,o.contributionration -- 出资比例
    ,o.repaymode -- 还款方式
    ,o.encashacctname -- 收款账号户名
    ,o.prinbal -- 正常本金余额
    ,o.cusmgrid -- 客户经理
    ,o.loanstatus -- 贷款状态
    ,o.enddate -- 贷款到期日
    ,o.accruedstatus -- 应计非应计标识
    ,o.ipid -- 用户ID
    ,o.iswhite -- 是否白户
    ,o.currency -- 币种
    ,o.prinrepayfrequency -- 本金还款频率
    ,o.repayacctname -- 还款账号户名
    ,o.assetclass -- 五级分类标识
    ,o.intovddays -- 利息逾期天数
    ,o.ovdintbal -- 逾期利息余额
    ,o.execrate -- 执行年利率，网商贷推送日利率X360
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.biztype -- 业务种类
    ,o.prodcode -- 产品码
    ,o.name -- 客户真实姓名
    ,o.applydate -- 申请支用时间
    ,o.totalterms -- 贷款期次数
    ,o.guaranteetype -- 担保类型
    ,o.ovdprinbal -- 逾期本金余额
    ,o.ovdprinpnltbal -- 逾期本金罚息余额
    ,o.ratelprtype -- 利率类型1基准利率2LPR
    ,o.encashdate -- 放款日期
    ,o.ratetype -- 利率类型
    ,o.nextrepaydate -- 下一还款日期
    ,o.unclearterms -- 未结清期数
    ,o.ratefloatmode -- 利率浮动方式
    ,o.isbankrel -- 是否关联人1是2否
    ,o.certtype -- 证件类型
    ,o.usearea -- 贷款资金使用位置
    ,o.graceday -- 宽限期天数
    ,o.status -- 合约状态
    ,o.certno -- 客户证件号码
    ,o.startdate -- 贷款起息日
    ,o.cusid -- 客户号
    ,o.floatratebp -- 利率上限浮动点差BP
    ,o.businessesflag -- 客群经营标签（人行口径）
    ,o.agriflg -- 是否农户
    ,o.classifyresult -- 五级分类标识(信贷)
    ,o.encashbanknm -- 收款银行名称
    ,o.externalserialno -- 清算交易编号
    ,o.isdebttransfer -- 是否债权直转(1是/0否)
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.selfencashamt -- 我行贷款金额
    ,o.selfterms -- 我行贷款总期数
    ,o.selfstartdate -- 我行贷款起始日
    ,o.contracttype -- 网商借据类型
    ,o.contractserialno -- 合同编号
    ,o.oldenddate -- 原借据到期日
    ,o.isregroup -- 是否重组
    ,o.regroupdate -- 重组日期
    ,o.regrouptype -- 重组贷款类型
    ,o.regroupcontractno -- 重组前借据号（多笔借据间用|分隔）
    ,o.occurtype -- 发生方式
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_mybk_acc_loan_bk o
    left join ${iol_schema}.icms_mybk_acc_loan_op n
        on
            o.contractno = n.contractno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_mybk_acc_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybk_acc_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybk_acc_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybk_acc_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybk_acc_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_acc_loan_cl;
alter table ${iol_schema}.icms_mybk_acc_loan exchange partition p_20991231 with table ${iol_schema}.icms_mybk_acc_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_acc_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybk_acc_loan_op purge;
drop table ${iol_schema}.icms_mybk_acc_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybk_acc_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_acc_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
