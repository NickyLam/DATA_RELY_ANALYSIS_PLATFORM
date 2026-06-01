/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_abs_asset_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.abss_abs_asset_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_abs_asset_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_asset_info_op purge;
drop table ${iol_schema}.abss_abs_asset_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_asset_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_asset_info where 0=1;

create table ${iol_schema}.abss_abs_asset_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_asset_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_asset_info_cl(
            serialno -- 资产流水号
            ,assetchannel -- 资产来源
            ,assetno -- 资产编号
            ,contractserialno -- 合同编号
            ,assettype -- 资产类型
            ,putoutdate -- 放款日期
            ,maturitydate -- 到期日
            ,loanterm -- 贷款期次
            ,residualterm -- 剩余期次
            ,rpttermid -- 还款方式
            ,iccyc -- 还款频率
            ,defaultdate -- 每期还款日
            ,businesssum -- 贷款金额
            ,badbalance -- 坏账金额
            ,overduebalance -- 逾期金额
            ,balance -- 贷款余额
            ,dullbalance -- 呆滞金额
            ,overduedate -- 逾期日期
            ,overduedays -- 逾期天数
            ,maxoverduedays -- 最大预期天数
            ,reserveinterest -- 当前未到期利息（计提利息）
            ,payinterestamt -- 应还利息
            ,breakdate -- 违约时间
            ,payprincipalpenaltyamt -- 本金罚息
            ,payinterestpenaltyamt -- 利息罚息
            ,currency -- 币种
            ,classifyresult -- 贷款五级分类
            ,ratetype -- 利率类型
            ,businessrate -- 执行利率
            ,debtratinglevel -- 债项评级
            ,accountno -- 账号
            ,creditcardvariety -- 信用卡品种
            ,creditcardno -- 信用卡号码
            ,creditlimit -- 信用额度
            ,loanstatus -- 贷款状态
            ,operateuserid -- 经办人ID
            ,operateorgid -- 经办机构
            ,rateadjusway -- 利率调整方式
            ,fixedcyle -- 固定周期
            ,rateadjustcyle -- 利率调整周期
            ,benchmarkratetype -- 基准利率类型
            ,benchmarkrate -- 基准利率
            ,ratefloatway -- 利率浮动方式
            ,ratefloat -- 浮动值
            ,finedayrate -- 罚息日利率
            ,fineratetype -- 罚息利率类型
            ,customerid -- 客户编号
            ,isoverdue -- 是否逾期(0-否,1-是)
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,assetstatus -- 资产状态
            ,packetdate -- 封包日期
            ,publishdate -- 发行日期
            ,businessdate -- 贷款处理日期
            ,affiliationregion -- 所属区域
            ,creditline -- 借款人授信额度
            ,maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
            ,sex -- 性别
            ,age -- 年龄
            ,nation -- 民族
            ,birthday -- 出生日期
            ,countrycode -- 国籍
            ,city -- 借款人所在城市（地级市）
            ,province -- 借款人所在省份
            ,occupation -- 职业
            ,degree -- 最高学位
            ,education -- 最高学历
            ,marriage -- 婚姻状况
            ,homeaddress -- 家庭住址
            ,companyname -- 单位名称
            ,companyindustry -- 单位所属行业
            ,creditscore -- 信用评分
            ,staff -- 是否本行员工
            ,organizationcode -- 组织机构代码
            ,entnature -- 企业性质
            ,industrytype -- 行业分类
            ,entscope -- 企业规模
            ,listedflag -- 是否上市
            ,countryregion -- 所在国家地区
            ,registeredplace -- 注册地
            ,groupflag -- 集团客户标识
            ,groupname -- 所属集团名称
            ,addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
            ,customerbalance -- 客户在本行贷款余额
            ,annualincome -- 年收入
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatetime -- 更新日期
            ,offdebitinterest -- 表外欠息
            ,artificialno -- 合同文本编号
            ,occurtype -- 发生类型
            ,lngotimes -- 借新还旧次数
            ,conduedate -- 合同到期日
            ,guarantyrate -- 抵质押率
            ,connormalbalance -- 合同正常余额
            ,conoverduebalance -- 合同逾期余额
            ,direction -- 行业投向
            ,creditcycle -- 循环标识
            ,vouchtype -- 主担保方式
            ,constartdate -- 合同起始日
            ,contractterm -- 合同期限
            ,contractamount -- 合同金额
            ,actualputoutsum -- 实际已发放金额
            ,contactbalance -- 合同余额
            ,purpose -- 贷款用途
            ,extendtimes -- 展期次数
            ,tempsave -- 暂存状态
            ,socialcreditcode -- 统一社会信用代码
            ,housingarea -- 住房面积
            ,housinglocation -- 住房所在地区
            ,valuationprice -- 评估价格
            ,fixingprice -- 认定价格
            ,loantovalueretio -- 贷款价值比
            ,isused -- 一手二手
            ,downpaymentsrate -- 首付比例
            ,businesstype -- 产品编码
            ,ismaxguarantee -- 是否涉及最高额担保
            ,businesstypeflag1 -- 产品分类标志
            ,businesstypename -- 产品名称
            ,intoverduedays -- 利息逾期天数
            ,manageorgid -- 经办机构
            ,manageusername -- 经办人名称
            ,operateorgname -- 账务机构名称
            ,termday -- 贷款期限（天）
            ,termmonth -- 贷款期限（月）
            ,guarantyamtrate -- 保证金比例
            ,guarantyamt -- 保证金金额
            ,depositamt -- 存单金额
            ,nationaldebtamt -- 国债金额
            ,financialproductamt -- 理财产品金额
            ,costumelevel -- 客户评级
            ,publishamt -- 资产转让价格
            ,overduerate -- 逾期利率
            ,lnopin -- 封包时归属我行利息
            ,lnccst -- 封包时本金余额
            ,packetassetbalance -- 封包时资产余额
            ,lnopinrate -- 封包时归属我行利息
            ,redpin -- 赎回时归属我行利息
            ,redcst -- 赎回时归属信托利息
            ,accruedchargedate -- 费用计提日
            ,finishamt -- 赎回对价
            ,redxtpin -- 赎回时归属信托本金
            ,reddate -- 赎回时间
            ,redeemprinciple -- 赎回对价本金
            ,redeeminterest -- 赎回对价利息
            ,pkg_bef_rcva_int_val -- 封包前应收利息余额
            ,pkg_after_rcva_int_total_amt -- 封包后应收利息总额
            ,pkg_after_rcva_int_bal -- 封包后应收利息余额
            ,has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
            ,totallnccst -- 实时归属我行本金余额
            ,totallnopinrate -- 实时归属我行利息余额
            ,tfr_loan_int_total_amt -- 转让贷款利息总额
            ,errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_asset_info_op(
            serialno -- 资产流水号
            ,assetchannel -- 资产来源
            ,assetno -- 资产编号
            ,contractserialno -- 合同编号
            ,assettype -- 资产类型
            ,putoutdate -- 放款日期
            ,maturitydate -- 到期日
            ,loanterm -- 贷款期次
            ,residualterm -- 剩余期次
            ,rpttermid -- 还款方式
            ,iccyc -- 还款频率
            ,defaultdate -- 每期还款日
            ,businesssum -- 贷款金额
            ,badbalance -- 坏账金额
            ,overduebalance -- 逾期金额
            ,balance -- 贷款余额
            ,dullbalance -- 呆滞金额
            ,overduedate -- 逾期日期
            ,overduedays -- 逾期天数
            ,maxoverduedays -- 最大预期天数
            ,reserveinterest -- 当前未到期利息（计提利息）
            ,payinterestamt -- 应还利息
            ,breakdate -- 违约时间
            ,payprincipalpenaltyamt -- 本金罚息
            ,payinterestpenaltyamt -- 利息罚息
            ,currency -- 币种
            ,classifyresult -- 贷款五级分类
            ,ratetype -- 利率类型
            ,businessrate -- 执行利率
            ,debtratinglevel -- 债项评级
            ,accountno -- 账号
            ,creditcardvariety -- 信用卡品种
            ,creditcardno -- 信用卡号码
            ,creditlimit -- 信用额度
            ,loanstatus -- 贷款状态
            ,operateuserid -- 经办人ID
            ,operateorgid -- 经办机构
            ,rateadjusway -- 利率调整方式
            ,fixedcyle -- 固定周期
            ,rateadjustcyle -- 利率调整周期
            ,benchmarkratetype -- 基准利率类型
            ,benchmarkrate -- 基准利率
            ,ratefloatway -- 利率浮动方式
            ,ratefloat -- 浮动值
            ,finedayrate -- 罚息日利率
            ,fineratetype -- 罚息利率类型
            ,customerid -- 客户编号
            ,isoverdue -- 是否逾期(0-否,1-是)
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,assetstatus -- 资产状态
            ,packetdate -- 封包日期
            ,publishdate -- 发行日期
            ,businessdate -- 贷款处理日期
            ,affiliationregion -- 所属区域
            ,creditline -- 借款人授信额度
            ,maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
            ,sex -- 性别
            ,age -- 年龄
            ,nation -- 民族
            ,birthday -- 出生日期
            ,countrycode -- 国籍
            ,city -- 借款人所在城市（地级市）
            ,province -- 借款人所在省份
            ,occupation -- 职业
            ,degree -- 最高学位
            ,education -- 最高学历
            ,marriage -- 婚姻状况
            ,homeaddress -- 家庭住址
            ,companyname -- 单位名称
            ,companyindustry -- 单位所属行业
            ,creditscore -- 信用评分
            ,staff -- 是否本行员工
            ,organizationcode -- 组织机构代码
            ,entnature -- 企业性质
            ,industrytype -- 行业分类
            ,entscope -- 企业规模
            ,listedflag -- 是否上市
            ,countryregion -- 所在国家地区
            ,registeredplace -- 注册地
            ,groupflag -- 集团客户标识
            ,groupname -- 所属集团名称
            ,addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
            ,customerbalance -- 客户在本行贷款余额
            ,annualincome -- 年收入
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatetime -- 更新日期
            ,offdebitinterest -- 表外欠息
            ,artificialno -- 合同文本编号
            ,occurtype -- 发生类型
            ,lngotimes -- 借新还旧次数
            ,conduedate -- 合同到期日
            ,guarantyrate -- 抵质押率
            ,connormalbalance -- 合同正常余额
            ,conoverduebalance -- 合同逾期余额
            ,direction -- 行业投向
            ,creditcycle -- 循环标识
            ,vouchtype -- 主担保方式
            ,constartdate -- 合同起始日
            ,contractterm -- 合同期限
            ,contractamount -- 合同金额
            ,actualputoutsum -- 实际已发放金额
            ,contactbalance -- 合同余额
            ,purpose -- 贷款用途
            ,extendtimes -- 展期次数
            ,tempsave -- 暂存状态
            ,socialcreditcode -- 统一社会信用代码
            ,housingarea -- 住房面积
            ,housinglocation -- 住房所在地区
            ,valuationprice -- 评估价格
            ,fixingprice -- 认定价格
            ,loantovalueretio -- 贷款价值比
            ,isused -- 一手二手
            ,downpaymentsrate -- 首付比例
            ,businesstype -- 产品编码
            ,ismaxguarantee -- 是否涉及最高额担保
            ,businesstypeflag1 -- 产品分类标志
            ,businesstypename -- 产品名称
            ,intoverduedays -- 利息逾期天数
            ,manageorgid -- 经办机构
            ,manageusername -- 经办人名称
            ,operateorgname -- 账务机构名称
            ,termday -- 贷款期限（天）
            ,termmonth -- 贷款期限（月）
            ,guarantyamtrate -- 保证金比例
            ,guarantyamt -- 保证金金额
            ,depositamt -- 存单金额
            ,nationaldebtamt -- 国债金额
            ,financialproductamt -- 理财产品金额
            ,costumelevel -- 客户评级
            ,publishamt -- 资产转让价格
            ,overduerate -- 逾期利率
            ,lnopin -- 封包时归属我行利息
            ,lnccst -- 封包时本金余额
            ,packetassetbalance -- 封包时资产余额
            ,lnopinrate -- 封包时归属我行利息
            ,redpin -- 赎回时归属我行利息
            ,redcst -- 赎回时归属信托利息
            ,accruedchargedate -- 费用计提日
            ,finishamt -- 赎回对价
            ,redxtpin -- 赎回时归属信托本金
            ,reddate -- 赎回时间
            ,redeemprinciple -- 赎回对价本金
            ,redeeminterest -- 赎回对价利息
            ,pkg_bef_rcva_int_val -- 封包前应收利息余额
            ,pkg_after_rcva_int_total_amt -- 封包后应收利息总额
            ,pkg_after_rcva_int_bal -- 封包后应收利息余额
            ,has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
            ,totallnccst -- 实时归属我行本金余额
            ,totallnopinrate -- 实时归属我行利息余额
            ,tfr_loan_int_total_amt -- 转让贷款利息总额
            ,errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 资产流水号
    ,nvl(n.assetchannel, o.assetchannel) as assetchannel -- 资产来源
    ,nvl(n.assetno, o.assetno) as assetno -- 资产编号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同编号
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类型
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.maturitydate, o.maturitydate) as maturitydate -- 到期日
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 贷款期次
    ,nvl(n.residualterm, o.residualterm) as residualterm -- 剩余期次
    ,nvl(n.rpttermid, o.rpttermid) as rpttermid -- 还款方式
    ,nvl(n.iccyc, o.iccyc) as iccyc -- 还款频率
    ,nvl(n.defaultdate, o.defaultdate) as defaultdate -- 每期还款日
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 贷款金额
    ,nvl(n.badbalance, o.badbalance) as badbalance -- 坏账金额
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期金额
    ,nvl(n.balance, o.balance) as balance -- 贷款余额
    ,nvl(n.dullbalance, o.dullbalance) as dullbalance -- 呆滞金额
    ,nvl(n.overduedate, o.overduedate) as overduedate -- 逾期日期
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 逾期天数
    ,nvl(n.maxoverduedays, o.maxoverduedays) as maxoverduedays -- 最大预期天数
    ,nvl(n.reserveinterest, o.reserveinterest) as reserveinterest -- 当前未到期利息（计提利息）
    ,nvl(n.payinterestamt, o.payinterestamt) as payinterestamt -- 应还利息
    ,nvl(n.breakdate, o.breakdate) as breakdate -- 违约时间
    ,nvl(n.payprincipalpenaltyamt, o.payprincipalpenaltyamt) as payprincipalpenaltyamt -- 本金罚息
    ,nvl(n.payinterestpenaltyamt, o.payinterestpenaltyamt) as payinterestpenaltyamt -- 利息罚息
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率类型
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 执行利率
    ,nvl(n.debtratinglevel, o.debtratinglevel) as debtratinglevel -- 债项评级
    ,nvl(n.accountno, o.accountno) as accountno -- 账号
    ,nvl(n.creditcardvariety, o.creditcardvariety) as creditcardvariety -- 信用卡品种
    ,nvl(n.creditcardno, o.creditcardno) as creditcardno -- 信用卡号码
    ,nvl(n.creditlimit, o.creditlimit) as creditlimit -- 信用额度
    ,nvl(n.loanstatus, o.loanstatus) as loanstatus -- 贷款状态
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办人ID
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办机构
    ,nvl(n.rateadjusway, o.rateadjusway) as rateadjusway -- 利率调整方式
    ,nvl(n.fixedcyle, o.fixedcyle) as fixedcyle -- 固定周期
    ,nvl(n.rateadjustcyle, o.rateadjustcyle) as rateadjustcyle -- 利率调整周期
    ,nvl(n.benchmarkratetype, o.benchmarkratetype) as benchmarkratetype -- 基准利率类型
    ,nvl(n.benchmarkrate, o.benchmarkrate) as benchmarkrate -- 基准利率
    ,nvl(n.ratefloatway, o.ratefloatway) as ratefloatway -- 利率浮动方式
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- 浮动值
    ,nvl(n.finedayrate, o.finedayrate) as finedayrate -- 罚息日利率
    ,nvl(n.fineratetype, o.fineratetype) as fineratetype -- 罚息利率类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.isoverdue, o.isoverdue) as isoverdue -- 是否逾期(0-否,1-是)
    ,nvl(n.customername, o.customername) as customername -- 客户姓名
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件编号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.assetstatus, o.assetstatus) as assetstatus -- 资产状态
    ,nvl(n.packetdate, o.packetdate) as packetdate -- 封包日期
    ,nvl(n.publishdate, o.publishdate) as publishdate -- 发行日期
    ,nvl(n.businessdate, o.businessdate) as businessdate -- 贷款处理日期
    ,nvl(n.affiliationregion, o.affiliationregion) as affiliationregion -- 所属区域
    ,nvl(n.creditline, o.creditline) as creditline -- 借款人授信额度
    ,nvl(n.maxoverdueperiod, o.maxoverdueperiod) as maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.nation, o.nation) as nation -- 民族
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.countrycode, o.countrycode) as countrycode -- 国籍
    ,nvl(n.city, o.city) as city -- 借款人所在城市（地级市）
    ,nvl(n.province, o.province) as province -- 借款人所在省份
    ,nvl(n.occupation, o.occupation) as occupation -- 职业
    ,nvl(n.degree, o.degree) as degree -- 最高学位
    ,nvl(n.education, o.education) as education -- 最高学历
    ,nvl(n.marriage, o.marriage) as marriage -- 婚姻状况
    ,nvl(n.homeaddress, o.homeaddress) as homeaddress -- 家庭住址
    ,nvl(n.companyname, o.companyname) as companyname -- 单位名称
    ,nvl(n.companyindustry, o.companyindustry) as companyindustry -- 单位所属行业
    ,nvl(n.creditscore, o.creditscore) as creditscore -- 信用评分
    ,nvl(n.staff, o.staff) as staff -- 是否本行员工
    ,nvl(n.organizationcode, o.organizationcode) as organizationcode -- 组织机构代码
    ,nvl(n.entnature, o.entnature) as entnature -- 企业性质
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 行业分类
    ,nvl(n.entscope, o.entscope) as entscope -- 企业规模
    ,nvl(n.listedflag, o.listedflag) as listedflag -- 是否上市
    ,nvl(n.countryregion, o.countryregion) as countryregion -- 所在国家地区
    ,nvl(n.registeredplace, o.registeredplace) as registeredplace -- 注册地
    ,nvl(n.groupflag, o.groupflag) as groupflag -- 集团客户标识
    ,nvl(n.groupname, o.groupname) as groupname -- 所属集团名称
    ,nvl(n.addmethod, o.addmethod) as addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
    ,nvl(n.customerbalance, o.customerbalance) as customerbalance -- 客户在本行贷款余额
    ,nvl(n.annualincome, o.annualincome) as annualincome -- 年收入
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新日期
    ,nvl(n.offdebitinterest, o.offdebitinterest) as offdebitinterest -- 表外欠息
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 合同文本编号
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型
    ,nvl(n.lngotimes, o.lngotimes) as lngotimes -- 借新还旧次数
    ,nvl(n.conduedate, o.conduedate) as conduedate -- 合同到期日
    ,nvl(n.guarantyrate, o.guarantyrate) as guarantyrate -- 抵质押率
    ,nvl(n.connormalbalance, o.connormalbalance) as connormalbalance -- 合同正常余额
    ,nvl(n.conoverduebalance, o.conoverduebalance) as conoverduebalance -- 合同逾期余额
    ,nvl(n.direction, o.direction) as direction -- 行业投向
    ,nvl(n.creditcycle, o.creditcycle) as creditcycle -- 循环标识
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.constartdate, o.constartdate) as constartdate -- 合同起始日
    ,nvl(n.contractterm, o.contractterm) as contractterm -- 合同期限
    ,nvl(n.contractamount, o.contractamount) as contractamount -- 合同金额
    ,nvl(n.actualputoutsum, o.actualputoutsum) as actualputoutsum -- 实际已发放金额
    ,nvl(n.contactbalance, o.contactbalance) as contactbalance -- 合同余额
    ,nvl(n.purpose, o.purpose) as purpose -- 贷款用途
    ,nvl(n.extendtimes, o.extendtimes) as extendtimes -- 展期次数
    ,nvl(n.tempsave, o.tempsave) as tempsave -- 暂存状态
    ,nvl(n.socialcreditcode, o.socialcreditcode) as socialcreditcode -- 统一社会信用代码
    ,nvl(n.housingarea, o.housingarea) as housingarea -- 住房面积
    ,nvl(n.housinglocation, o.housinglocation) as housinglocation -- 住房所在地区
    ,nvl(n.valuationprice, o.valuationprice) as valuationprice -- 评估价格
    ,nvl(n.fixingprice, o.fixingprice) as fixingprice -- 认定价格
    ,nvl(n.loantovalueretio, o.loantovalueretio) as loantovalueretio -- 贷款价值比
    ,nvl(n.isused, o.isused) as isused -- 一手二手
    ,nvl(n.downpaymentsrate, o.downpaymentsrate) as downpaymentsrate -- 首付比例
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 产品编码
    ,nvl(n.ismaxguarantee, o.ismaxguarantee) as ismaxguarantee -- 是否涉及最高额担保
    ,nvl(n.businesstypeflag1, o.businesstypeflag1) as businesstypeflag1 -- 产品分类标志
    ,nvl(n.businesstypename, o.businesstypename) as businesstypename -- 产品名称
    ,nvl(n.intoverduedays, o.intoverduedays) as intoverduedays -- 利息逾期天数
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 经办机构
    ,nvl(n.manageusername, o.manageusername) as manageusername -- 经办人名称
    ,nvl(n.operateorgname, o.operateorgname) as operateorgname -- 账务机构名称
    ,nvl(n.termday, o.termday) as termday -- 贷款期限（天）
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 贷款期限（月）
    ,nvl(n.guarantyamtrate, o.guarantyamtrate) as guarantyamtrate -- 保证金比例
    ,nvl(n.guarantyamt, o.guarantyamt) as guarantyamt -- 保证金金额
    ,nvl(n.depositamt, o.depositamt) as depositamt -- 存单金额
    ,nvl(n.nationaldebtamt, o.nationaldebtamt) as nationaldebtamt -- 国债金额
    ,nvl(n.financialproductamt, o.financialproductamt) as financialproductamt -- 理财产品金额
    ,nvl(n.costumelevel, o.costumelevel) as costumelevel -- 客户评级
    ,nvl(n.publishamt, o.publishamt) as publishamt -- 资产转让价格
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期利率
    ,nvl(n.lnopin, o.lnopin) as lnopin -- 封包时归属我行利息
    ,nvl(n.lnccst, o.lnccst) as lnccst -- 封包时本金余额
    ,nvl(n.packetassetbalance, o.packetassetbalance) as packetassetbalance -- 封包时资产余额
    ,nvl(n.lnopinrate, o.lnopinrate) as lnopinrate -- 封包时归属我行利息
    ,nvl(n.redpin, o.redpin) as redpin -- 赎回时归属我行利息
    ,nvl(n.redcst, o.redcst) as redcst -- 赎回时归属信托利息
    ,nvl(n.accruedchargedate, o.accruedchargedate) as accruedchargedate -- 费用计提日
    ,nvl(n.finishamt, o.finishamt) as finishamt -- 赎回对价
    ,nvl(n.redxtpin, o.redxtpin) as redxtpin -- 赎回时归属信托本金
    ,nvl(n.reddate, o.reddate) as reddate -- 赎回时间
    ,nvl(n.redeemprinciple, o.redeemprinciple) as redeemprinciple -- 赎回对价本金
    ,nvl(n.redeeminterest, o.redeeminterest) as redeeminterest -- 赎回对价利息
    ,nvl(n.pkg_bef_rcva_int_val, o.pkg_bef_rcva_int_val) as pkg_bef_rcva_int_val -- 封包前应收利息余额
    ,nvl(n.pkg_after_rcva_int_total_amt, o.pkg_after_rcva_int_total_amt) as pkg_after_rcva_int_total_amt -- 封包后应收利息总额
    ,nvl(n.pkg_after_rcva_int_bal, o.pkg_after_rcva_int_bal) as pkg_after_rcva_int_bal -- 封包后应收利息余额
    ,nvl(n.has_retn_pkg_after_rcva_int, o.has_retn_pkg_after_rcva_int) as has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
    ,nvl(n.totallnccst, o.totallnccst) as totallnccst -- 实时归属我行本金余额
    ,nvl(n.totallnopinrate, o.totallnopinrate) as totallnopinrate -- 实时归属我行利息余额
    ,nvl(n.tfr_loan_int_total_amt, o.tfr_loan_int_total_amt) as tfr_loan_int_total_amt -- 转让贷款利息总额
    ,nvl(n.errormsg, o.errormsg) as errormsg -- 错误信息
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_abs_asset_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_abs_asset_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.assetchannel <> n.assetchannel
        or o.assetno <> n.assetno
        or o.contractserialno <> n.contractserialno
        or o.assettype <> n.assettype
        or o.putoutdate <> n.putoutdate
        or o.maturitydate <> n.maturitydate
        or o.loanterm <> n.loanterm
        or o.residualterm <> n.residualterm
        or o.rpttermid <> n.rpttermid
        or o.iccyc <> n.iccyc
        or o.defaultdate <> n.defaultdate
        or o.businesssum <> n.businesssum
        or o.badbalance <> n.badbalance
        or o.overduebalance <> n.overduebalance
        or o.balance <> n.balance
        or o.dullbalance <> n.dullbalance
        or o.overduedate <> n.overduedate
        or o.overduedays <> n.overduedays
        or o.maxoverduedays <> n.maxoverduedays
        or o.reserveinterest <> n.reserveinterest
        or o.payinterestamt <> n.payinterestamt
        or o.breakdate <> n.breakdate
        or o.payprincipalpenaltyamt <> n.payprincipalpenaltyamt
        or o.payinterestpenaltyamt <> n.payinterestpenaltyamt
        or o.currency <> n.currency
        or o.classifyresult <> n.classifyresult
        or o.ratetype <> n.ratetype
        or o.businessrate <> n.businessrate
        or o.debtratinglevel <> n.debtratinglevel
        or o.accountno <> n.accountno
        or o.creditcardvariety <> n.creditcardvariety
        or o.creditcardno <> n.creditcardno
        or o.creditlimit <> n.creditlimit
        or o.loanstatus <> n.loanstatus
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.rateadjusway <> n.rateadjusway
        or o.fixedcyle <> n.fixedcyle
        or o.rateadjustcyle <> n.rateadjustcyle
        or o.benchmarkratetype <> n.benchmarkratetype
        or o.benchmarkrate <> n.benchmarkrate
        or o.ratefloatway <> n.ratefloatway
        or o.ratefloat <> n.ratefloat
        or o.finedayrate <> n.finedayrate
        or o.fineratetype <> n.fineratetype
        or o.customerid <> n.customerid
        or o.isoverdue <> n.isoverdue
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.customertype <> n.customertype
        or o.assetstatus <> n.assetstatus
        or o.packetdate <> n.packetdate
        or o.publishdate <> n.publishdate
        or o.businessdate <> n.businessdate
        or o.affiliationregion <> n.affiliationregion
        or o.creditline <> n.creditline
        or o.maxoverdueperiod <> n.maxoverdueperiod
        or o.sex <> n.sex
        or o.age <> n.age
        or o.nation <> n.nation
        or o.birthday <> n.birthday
        or o.countrycode <> n.countrycode
        or o.city <> n.city
        or o.province <> n.province
        or o.occupation <> n.occupation
        or o.degree <> n.degree
        or o.education <> n.education
        or o.marriage <> n.marriage
        or o.homeaddress <> n.homeaddress
        or o.companyname <> n.companyname
        or o.companyindustry <> n.companyindustry
        or o.creditscore <> n.creditscore
        or o.staff <> n.staff
        or o.organizationcode <> n.organizationcode
        or o.entnature <> n.entnature
        or o.industrytype <> n.industrytype
        or o.entscope <> n.entscope
        or o.listedflag <> n.listedflag
        or o.countryregion <> n.countryregion
        or o.registeredplace <> n.registeredplace
        or o.groupflag <> n.groupflag
        or o.groupname <> n.groupname
        or o.addmethod <> n.addmethod
        or o.customerbalance <> n.customerbalance
        or o.annualincome <> n.annualincome
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputtime <> n.inputtime
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatetime <> n.updatetime
        or o.offdebitinterest <> n.offdebitinterest
        or o.artificialno <> n.artificialno
        or o.occurtype <> n.occurtype
        or o.lngotimes <> n.lngotimes
        or o.conduedate <> n.conduedate
        or o.guarantyrate <> n.guarantyrate
        or o.connormalbalance <> n.connormalbalance
        or o.conoverduebalance <> n.conoverduebalance
        or o.direction <> n.direction
        or o.creditcycle <> n.creditcycle
        or o.vouchtype <> n.vouchtype
        or o.constartdate <> n.constartdate
        or o.contractterm <> n.contractterm
        or o.contractamount <> n.contractamount
        or o.actualputoutsum <> n.actualputoutsum
        or o.contactbalance <> n.contactbalance
        or o.purpose <> n.purpose
        or o.extendtimes <> n.extendtimes
        or o.tempsave <> n.tempsave
        or o.socialcreditcode <> n.socialcreditcode
        or o.housingarea <> n.housingarea
        or o.housinglocation <> n.housinglocation
        or o.valuationprice <> n.valuationprice
        or o.fixingprice <> n.fixingprice
        or o.loantovalueretio <> n.loantovalueretio
        or o.isused <> n.isused
        or o.downpaymentsrate <> n.downpaymentsrate
        or o.businesstype <> n.businesstype
        or o.ismaxguarantee <> n.ismaxguarantee
        or o.businesstypeflag1 <> n.businesstypeflag1
        or o.businesstypename <> n.businesstypename
        or o.intoverduedays <> n.intoverduedays
        or o.manageorgid <> n.manageorgid
        or o.manageusername <> n.manageusername
        or o.operateorgname <> n.operateorgname
        or o.termday <> n.termday
        or o.termmonth <> n.termmonth
        or o.guarantyamtrate <> n.guarantyamtrate
        or o.guarantyamt <> n.guarantyamt
        or o.depositamt <> n.depositamt
        or o.nationaldebtamt <> n.nationaldebtamt
        or o.financialproductamt <> n.financialproductamt
        or o.costumelevel <> n.costumelevel
        or o.publishamt <> n.publishamt
        or o.overduerate <> n.overduerate
        or o.lnopin <> n.lnopin
        or o.lnccst <> n.lnccst
        or o.packetassetbalance <> n.packetassetbalance
        or o.lnopinrate <> n.lnopinrate
        or o.redpin <> n.redpin
        or o.redcst <> n.redcst
        or o.accruedchargedate <> n.accruedchargedate
        or o.finishamt <> n.finishamt
        or o.redxtpin <> n.redxtpin
        or o.reddate <> n.reddate
        or o.redeemprinciple <> n.redeemprinciple
        or o.redeeminterest <> n.redeeminterest
        or o.pkg_bef_rcva_int_val <> n.pkg_bef_rcva_int_val
        or o.pkg_after_rcva_int_total_amt <> n.pkg_after_rcva_int_total_amt
        or o.pkg_after_rcva_int_bal <> n.pkg_after_rcva_int_bal
        or o.has_retn_pkg_after_rcva_int <> n.has_retn_pkg_after_rcva_int
        or o.totallnccst <> n.totallnccst
        or o.totallnopinrate <> n.totallnopinrate
        or o.tfr_loan_int_total_amt <> n.tfr_loan_int_total_amt
        or o.errormsg <> n.errormsg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_asset_info_cl(
            serialno -- 资产流水号
            ,assetchannel -- 资产来源
            ,assetno -- 资产编号
            ,contractserialno -- 合同编号
            ,assettype -- 资产类型
            ,putoutdate -- 放款日期
            ,maturitydate -- 到期日
            ,loanterm -- 贷款期次
            ,residualterm -- 剩余期次
            ,rpttermid -- 还款方式
            ,iccyc -- 还款频率
            ,defaultdate -- 每期还款日
            ,businesssum -- 贷款金额
            ,badbalance -- 坏账金额
            ,overduebalance -- 逾期金额
            ,balance -- 贷款余额
            ,dullbalance -- 呆滞金额
            ,overduedate -- 逾期日期
            ,overduedays -- 逾期天数
            ,maxoverduedays -- 最大预期天数
            ,reserveinterest -- 当前未到期利息（计提利息）
            ,payinterestamt -- 应还利息
            ,breakdate -- 违约时间
            ,payprincipalpenaltyamt -- 本金罚息
            ,payinterestpenaltyamt -- 利息罚息
            ,currency -- 币种
            ,classifyresult -- 贷款五级分类
            ,ratetype -- 利率类型
            ,businessrate -- 执行利率
            ,debtratinglevel -- 债项评级
            ,accountno -- 账号
            ,creditcardvariety -- 信用卡品种
            ,creditcardno -- 信用卡号码
            ,creditlimit -- 信用额度
            ,loanstatus -- 贷款状态
            ,operateuserid -- 经办人ID
            ,operateorgid -- 经办机构
            ,rateadjusway -- 利率调整方式
            ,fixedcyle -- 固定周期
            ,rateadjustcyle -- 利率调整周期
            ,benchmarkratetype -- 基准利率类型
            ,benchmarkrate -- 基准利率
            ,ratefloatway -- 利率浮动方式
            ,ratefloat -- 浮动值
            ,finedayrate -- 罚息日利率
            ,fineratetype -- 罚息利率类型
            ,customerid -- 客户编号
            ,isoverdue -- 是否逾期(0-否,1-是)
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,assetstatus -- 资产状态
            ,packetdate -- 封包日期
            ,publishdate -- 发行日期
            ,businessdate -- 贷款处理日期
            ,affiliationregion -- 所属区域
            ,creditline -- 借款人授信额度
            ,maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
            ,sex -- 性别
            ,age -- 年龄
            ,nation -- 民族
            ,birthday -- 出生日期
            ,countrycode -- 国籍
            ,city -- 借款人所在城市（地级市）
            ,province -- 借款人所在省份
            ,occupation -- 职业
            ,degree -- 最高学位
            ,education -- 最高学历
            ,marriage -- 婚姻状况
            ,homeaddress -- 家庭住址
            ,companyname -- 单位名称
            ,companyindustry -- 单位所属行业
            ,creditscore -- 信用评分
            ,staff -- 是否本行员工
            ,organizationcode -- 组织机构代码
            ,entnature -- 企业性质
            ,industrytype -- 行业分类
            ,entscope -- 企业规模
            ,listedflag -- 是否上市
            ,countryregion -- 所在国家地区
            ,registeredplace -- 注册地
            ,groupflag -- 集团客户标识
            ,groupname -- 所属集团名称
            ,addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
            ,customerbalance -- 客户在本行贷款余额
            ,annualincome -- 年收入
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatetime -- 更新日期
            ,offdebitinterest -- 表外欠息
            ,artificialno -- 合同文本编号
            ,occurtype -- 发生类型
            ,lngotimes -- 借新还旧次数
            ,conduedate -- 合同到期日
            ,guarantyrate -- 抵质押率
            ,connormalbalance -- 合同正常余额
            ,conoverduebalance -- 合同逾期余额
            ,direction -- 行业投向
            ,creditcycle -- 循环标识
            ,vouchtype -- 主担保方式
            ,constartdate -- 合同起始日
            ,contractterm -- 合同期限
            ,contractamount -- 合同金额
            ,actualputoutsum -- 实际已发放金额
            ,contactbalance -- 合同余额
            ,purpose -- 贷款用途
            ,extendtimes -- 展期次数
            ,tempsave -- 暂存状态
            ,socialcreditcode -- 统一社会信用代码
            ,housingarea -- 住房面积
            ,housinglocation -- 住房所在地区
            ,valuationprice -- 评估价格
            ,fixingprice -- 认定价格
            ,loantovalueretio -- 贷款价值比
            ,isused -- 一手二手
            ,downpaymentsrate -- 首付比例
            ,businesstype -- 产品编码
            ,ismaxguarantee -- 是否涉及最高额担保
            ,businesstypeflag1 -- 产品分类标志
            ,businesstypename -- 产品名称
            ,intoverduedays -- 利息逾期天数
            ,manageorgid -- 经办机构
            ,manageusername -- 经办人名称
            ,operateorgname -- 账务机构名称
            ,termday -- 贷款期限（天）
            ,termmonth -- 贷款期限（月）
            ,guarantyamtrate -- 保证金比例
            ,guarantyamt -- 保证金金额
            ,depositamt -- 存单金额
            ,nationaldebtamt -- 国债金额
            ,financialproductamt -- 理财产品金额
            ,costumelevel -- 客户评级
            ,publishamt -- 资产转让价格
            ,overduerate -- 逾期利率
            ,lnopin -- 封包时归属我行利息
            ,lnccst -- 封包时本金余额
            ,packetassetbalance -- 封包时资产余额
            ,lnopinrate -- 封包时归属我行利息
            ,redpin -- 赎回时归属我行利息
            ,redcst -- 赎回时归属信托利息
            ,accruedchargedate -- 费用计提日
            ,finishamt -- 赎回对价
            ,redxtpin -- 赎回时归属信托本金
            ,reddate -- 赎回时间
            ,redeemprinciple -- 赎回对价本金
            ,redeeminterest -- 赎回对价利息
            ,pkg_bef_rcva_int_val -- 封包前应收利息余额
            ,pkg_after_rcva_int_total_amt -- 封包后应收利息总额
            ,pkg_after_rcva_int_bal -- 封包后应收利息余额
            ,has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
            ,totallnccst -- 实时归属我行本金余额
            ,totallnopinrate -- 实时归属我行利息余额
            ,tfr_loan_int_total_amt -- 转让贷款利息总额
            ,errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_asset_info_op(
            serialno -- 资产流水号
            ,assetchannel -- 资产来源
            ,assetno -- 资产编号
            ,contractserialno -- 合同编号
            ,assettype -- 资产类型
            ,putoutdate -- 放款日期
            ,maturitydate -- 到期日
            ,loanterm -- 贷款期次
            ,residualterm -- 剩余期次
            ,rpttermid -- 还款方式
            ,iccyc -- 还款频率
            ,defaultdate -- 每期还款日
            ,businesssum -- 贷款金额
            ,badbalance -- 坏账金额
            ,overduebalance -- 逾期金额
            ,balance -- 贷款余额
            ,dullbalance -- 呆滞金额
            ,overduedate -- 逾期日期
            ,overduedays -- 逾期天数
            ,maxoverduedays -- 最大预期天数
            ,reserveinterest -- 当前未到期利息（计提利息）
            ,payinterestamt -- 应还利息
            ,breakdate -- 违约时间
            ,payprincipalpenaltyamt -- 本金罚息
            ,payinterestpenaltyamt -- 利息罚息
            ,currency -- 币种
            ,classifyresult -- 贷款五级分类
            ,ratetype -- 利率类型
            ,businessrate -- 执行利率
            ,debtratinglevel -- 债项评级
            ,accountno -- 账号
            ,creditcardvariety -- 信用卡品种
            ,creditcardno -- 信用卡号码
            ,creditlimit -- 信用额度
            ,loanstatus -- 贷款状态
            ,operateuserid -- 经办人ID
            ,operateorgid -- 经办机构
            ,rateadjusway -- 利率调整方式
            ,fixedcyle -- 固定周期
            ,rateadjustcyle -- 利率调整周期
            ,benchmarkratetype -- 基准利率类型
            ,benchmarkrate -- 基准利率
            ,ratefloatway -- 利率浮动方式
            ,ratefloat -- 浮动值
            ,finedayrate -- 罚息日利率
            ,fineratetype -- 罚息利率类型
            ,customerid -- 客户编号
            ,isoverdue -- 是否逾期(0-否,1-是)
            ,customername -- 客户姓名
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,assetstatus -- 资产状态
            ,packetdate -- 封包日期
            ,publishdate -- 发行日期
            ,businessdate -- 贷款处理日期
            ,affiliationregion -- 所属区域
            ,creditline -- 借款人授信额度
            ,maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
            ,sex -- 性别
            ,age -- 年龄
            ,nation -- 民族
            ,birthday -- 出生日期
            ,countrycode -- 国籍
            ,city -- 借款人所在城市（地级市）
            ,province -- 借款人所在省份
            ,occupation -- 职业
            ,degree -- 最高学位
            ,education -- 最高学历
            ,marriage -- 婚姻状况
            ,homeaddress -- 家庭住址
            ,companyname -- 单位名称
            ,companyindustry -- 单位所属行业
            ,creditscore -- 信用评分
            ,staff -- 是否本行员工
            ,organizationcode -- 组织机构代码
            ,entnature -- 企业性质
            ,industrytype -- 行业分类
            ,entscope -- 企业规模
            ,listedflag -- 是否上市
            ,countryregion -- 所在国家地区
            ,registeredplace -- 注册地
            ,groupflag -- 集团客户标识
            ,groupname -- 所属集团名称
            ,addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
            ,customerbalance -- 客户在本行贷款余额
            ,annualincome -- 年收入
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatetime -- 更新日期
            ,offdebitinterest -- 表外欠息
            ,artificialno -- 合同文本编号
            ,occurtype -- 发生类型
            ,lngotimes -- 借新还旧次数
            ,conduedate -- 合同到期日
            ,guarantyrate -- 抵质押率
            ,connormalbalance -- 合同正常余额
            ,conoverduebalance -- 合同逾期余额
            ,direction -- 行业投向
            ,creditcycle -- 循环标识
            ,vouchtype -- 主担保方式
            ,constartdate -- 合同起始日
            ,contractterm -- 合同期限
            ,contractamount -- 合同金额
            ,actualputoutsum -- 实际已发放金额
            ,contactbalance -- 合同余额
            ,purpose -- 贷款用途
            ,extendtimes -- 展期次数
            ,tempsave -- 暂存状态
            ,socialcreditcode -- 统一社会信用代码
            ,housingarea -- 住房面积
            ,housinglocation -- 住房所在地区
            ,valuationprice -- 评估价格
            ,fixingprice -- 认定价格
            ,loantovalueretio -- 贷款价值比
            ,isused -- 一手二手
            ,downpaymentsrate -- 首付比例
            ,businesstype -- 产品编码
            ,ismaxguarantee -- 是否涉及最高额担保
            ,businesstypeflag1 -- 产品分类标志
            ,businesstypename -- 产品名称
            ,intoverduedays -- 利息逾期天数
            ,manageorgid -- 经办机构
            ,manageusername -- 经办人名称
            ,operateorgname -- 账务机构名称
            ,termday -- 贷款期限（天）
            ,termmonth -- 贷款期限（月）
            ,guarantyamtrate -- 保证金比例
            ,guarantyamt -- 保证金金额
            ,depositamt -- 存单金额
            ,nationaldebtamt -- 国债金额
            ,financialproductamt -- 理财产品金额
            ,costumelevel -- 客户评级
            ,publishamt -- 资产转让价格
            ,overduerate -- 逾期利率
            ,lnopin -- 封包时归属我行利息
            ,lnccst -- 封包时本金余额
            ,packetassetbalance -- 封包时资产余额
            ,lnopinrate -- 封包时归属我行利息
            ,redpin -- 赎回时归属我行利息
            ,redcst -- 赎回时归属信托利息
            ,accruedchargedate -- 费用计提日
            ,finishamt -- 赎回对价
            ,redxtpin -- 赎回时归属信托本金
            ,reddate -- 赎回时间
            ,redeemprinciple -- 赎回对价本金
            ,redeeminterest -- 赎回对价利息
            ,pkg_bef_rcva_int_val -- 封包前应收利息余额
            ,pkg_after_rcva_int_total_amt -- 封包后应收利息总额
            ,pkg_after_rcva_int_bal -- 封包后应收利息余额
            ,has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
            ,totallnccst -- 实时归属我行本金余额
            ,totallnopinrate -- 实时归属我行利息余额
            ,tfr_loan_int_total_amt -- 转让贷款利息总额
            ,errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 资产流水号
    ,o.assetchannel -- 资产来源
    ,o.assetno -- 资产编号
    ,o.contractserialno -- 合同编号
    ,o.assettype -- 资产类型
    ,o.putoutdate -- 放款日期
    ,o.maturitydate -- 到期日
    ,o.loanterm -- 贷款期次
    ,o.residualterm -- 剩余期次
    ,o.rpttermid -- 还款方式
    ,o.iccyc -- 还款频率
    ,o.defaultdate -- 每期还款日
    ,o.businesssum -- 贷款金额
    ,o.badbalance -- 坏账金额
    ,o.overduebalance -- 逾期金额
    ,o.balance -- 贷款余额
    ,o.dullbalance -- 呆滞金额
    ,o.overduedate -- 逾期日期
    ,o.overduedays -- 逾期天数
    ,o.maxoverduedays -- 最大预期天数
    ,o.reserveinterest -- 当前未到期利息（计提利息）
    ,o.payinterestamt -- 应还利息
    ,o.breakdate -- 违约时间
    ,o.payprincipalpenaltyamt -- 本金罚息
    ,o.payinterestpenaltyamt -- 利息罚息
    ,o.currency -- 币种
    ,o.classifyresult -- 贷款五级分类
    ,o.ratetype -- 利率类型
    ,o.businessrate -- 执行利率
    ,o.debtratinglevel -- 债项评级
    ,o.accountno -- 账号
    ,o.creditcardvariety -- 信用卡品种
    ,o.creditcardno -- 信用卡号码
    ,o.creditlimit -- 信用额度
    ,o.loanstatus -- 贷款状态
    ,o.operateuserid -- 经办人ID
    ,o.operateorgid -- 经办机构
    ,o.rateadjusway -- 利率调整方式
    ,o.fixedcyle -- 固定周期
    ,o.rateadjustcyle -- 利率调整周期
    ,o.benchmarkratetype -- 基准利率类型
    ,o.benchmarkrate -- 基准利率
    ,o.ratefloatway -- 利率浮动方式
    ,o.ratefloat -- 浮动值
    ,o.finedayrate -- 罚息日利率
    ,o.fineratetype -- 罚息利率类型
    ,o.customerid -- 客户编号
    ,o.isoverdue -- 是否逾期(0-否,1-是)
    ,o.customername -- 客户姓名
    ,o.certtype -- 证件类型
    ,o.certid -- 证件编号
    ,o.customertype -- 客户类型
    ,o.assetstatus -- 资产状态
    ,o.packetdate -- 封包日期
    ,o.publishdate -- 发行日期
    ,o.businessdate -- 贷款处理日期
    ,o.affiliationregion -- 所属区域
    ,o.creditline -- 借款人授信额度
    ,o.maxoverdueperiod -- 在其他银行贷款的历史最长逾期期数
    ,o.sex -- 性别
    ,o.age -- 年龄
    ,o.nation -- 民族
    ,o.birthday -- 出生日期
    ,o.countrycode -- 国籍
    ,o.city -- 借款人所在城市（地级市）
    ,o.province -- 借款人所在省份
    ,o.occupation -- 职业
    ,o.degree -- 最高学位
    ,o.education -- 最高学历
    ,o.marriage -- 婚姻状况
    ,o.homeaddress -- 家庭住址
    ,o.companyname -- 单位名称
    ,o.companyindustry -- 单位所属行业
    ,o.creditscore -- 信用评分
    ,o.staff -- 是否本行员工
    ,o.organizationcode -- 组织机构代码
    ,o.entnature -- 企业性质
    ,o.industrytype -- 行业分类
    ,o.entscope -- 企业规模
    ,o.listedflag -- 是否上市
    ,o.countryregion -- 所在国家地区
    ,o.registeredplace -- 注册地
    ,o.groupflag -- 集团客户标识
    ,o.groupname -- 所属集团名称
    ,o.addmethod -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
    ,o.customerbalance -- 客户在本行贷款余额
    ,o.annualincome -- 年收入
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputtime -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatetime -- 更新日期
    ,o.offdebitinterest -- 表外欠息
    ,o.artificialno -- 合同文本编号
    ,o.occurtype -- 发生类型
    ,o.lngotimes -- 借新还旧次数
    ,o.conduedate -- 合同到期日
    ,o.guarantyrate -- 抵质押率
    ,o.connormalbalance -- 合同正常余额
    ,o.conoverduebalance -- 合同逾期余额
    ,o.direction -- 行业投向
    ,o.creditcycle -- 循环标识
    ,o.vouchtype -- 主担保方式
    ,o.constartdate -- 合同起始日
    ,o.contractterm -- 合同期限
    ,o.contractamount -- 合同金额
    ,o.actualputoutsum -- 实际已发放金额
    ,o.contactbalance -- 合同余额
    ,o.purpose -- 贷款用途
    ,o.extendtimes -- 展期次数
    ,o.tempsave -- 暂存状态
    ,o.socialcreditcode -- 统一社会信用代码
    ,o.housingarea -- 住房面积
    ,o.housinglocation -- 住房所在地区
    ,o.valuationprice -- 评估价格
    ,o.fixingprice -- 认定价格
    ,o.loantovalueretio -- 贷款价值比
    ,o.isused -- 一手二手
    ,o.downpaymentsrate -- 首付比例
    ,o.businesstype -- 产品编码
    ,o.ismaxguarantee -- 是否涉及最高额担保
    ,o.businesstypeflag1 -- 产品分类标志
    ,o.businesstypename -- 产品名称
    ,o.intoverduedays -- 利息逾期天数
    ,o.manageorgid -- 经办机构
    ,o.manageusername -- 经办人名称
    ,o.operateorgname -- 账务机构名称
    ,o.termday -- 贷款期限（天）
    ,o.termmonth -- 贷款期限（月）
    ,o.guarantyamtrate -- 保证金比例
    ,o.guarantyamt -- 保证金金额
    ,o.depositamt -- 存单金额
    ,o.nationaldebtamt -- 国债金额
    ,o.financialproductamt -- 理财产品金额
    ,o.costumelevel -- 客户评级
    ,o.publishamt -- 资产转让价格
    ,o.overduerate -- 逾期利率
    ,o.lnopin -- 封包时归属我行利息
    ,o.lnccst -- 封包时本金余额
    ,o.packetassetbalance -- 封包时资产余额
    ,o.lnopinrate -- 封包时归属我行利息
    ,o.redpin -- 赎回时归属我行利息
    ,o.redcst -- 赎回时归属信托利息
    ,o.accruedchargedate -- 费用计提日
    ,o.finishamt -- 赎回对价
    ,o.redxtpin -- 赎回时归属信托本金
    ,o.reddate -- 赎回时间
    ,o.redeemprinciple -- 赎回对价本金
    ,o.redeeminterest -- 赎回对价利息
    ,o.pkg_bef_rcva_int_val -- 封包前应收利息余额
    ,o.pkg_after_rcva_int_total_amt -- 封包后应收利息总额
    ,o.pkg_after_rcva_int_bal -- 封包后应收利息余额
    ,o.has_retn_pkg_after_rcva_int -- 已归还封包后应收利息
    ,o.totallnccst -- 实时归属我行本金余额
    ,o.totallnopinrate -- 实时归属我行利息余额
    ,o.tfr_loan_int_total_amt -- 转让贷款利息总额
    ,o.errormsg -- 错误信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.abss_abs_asset_info_bk o
    left join ${iol_schema}.abss_abs_asset_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_abs_asset_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.abss_abs_asset_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('abss_abs_asset_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.abss_abs_asset_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.abss_abs_asset_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.abss_abs_asset_info exchange partition p_${batch_date} with table ${iol_schema}.abss_abs_asset_info_cl;
alter table ${iol_schema}.abss_abs_asset_info exchange partition p_20991231 with table ${iol_schema}.abss_abs_asset_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_abs_asset_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_asset_info_op purge;
drop table ${iol_schema}.abss_abs_asset_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_abs_asset_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_abs_asset_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
