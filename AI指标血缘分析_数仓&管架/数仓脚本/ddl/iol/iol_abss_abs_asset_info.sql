/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_asset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_asset_info
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_asset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_asset_info(
    serialno varchar2(90) -- 资产流水号
    ,assetchannel varchar2(90) -- 资产来源
    ,assetno varchar2(90) -- 资产编号
    ,contractserialno varchar2(90) -- 合同编号
    ,assettype varchar2(90) -- 资产类型
    ,putoutdate varchar2(15) -- 放款日期
    ,maturitydate varchar2(15) -- 到期日
    ,loanterm number(10,0) -- 贷款期次
    ,residualterm number(10,0) -- 剩余期次
    ,rpttermid varchar2(15) -- 还款方式
    ,iccyc varchar2(15) -- 还款频率
    ,defaultdate number(10,0) -- 每期还款日
    ,businesssum number(24,2) -- 贷款金额
    ,badbalance number(24,2) -- 坏账金额
    ,overduebalance number(24,2) -- 逾期金额
    ,balance number(24,2) -- 贷款余额
    ,dullbalance number(24,2) -- 呆滞金额
    ,overduedate varchar2(15) -- 逾期日期
    ,overduedays number(10,0) -- 逾期天数
    ,maxoverduedays number(10,0) -- 最大预期天数
    ,reserveinterest number(24,2) -- 当前未到期利息（计提利息）
    ,payinterestamt number(24,2) -- 应还利息
    ,breakdate varchar2(36) -- 违约时间
    ,payprincipalpenaltyamt number(24,2) -- 本金罚息
    ,payinterestpenaltyamt number(24,2) -- 利息罚息
    ,currency varchar2(15) -- 币种
    ,classifyresult varchar2(15) -- 贷款五级分类
    ,ratetype varchar2(15) -- 利率类型
    ,businessrate number(14,10) -- 执行利率
    ,debtratinglevel varchar2(15) -- 债项评级
    ,accountno varchar2(60) -- 账号
    ,creditcardvariety varchar2(27) -- 信用卡品种
    ,creditcardno varchar2(48) -- 信用卡号码
    ,creditlimit number(24,2) -- 信用额度
    ,loanstatus varchar2(15) -- 贷款状态
    ,operateuserid varchar2(48) -- 经办人ID
    ,operateorgid varchar2(48) -- 经办机构
    ,rateadjusway varchar2(15) -- 利率调整方式
    ,fixedcyle varchar2(15) -- 固定周期
    ,rateadjustcyle varchar2(15) -- 利率调整周期
    ,benchmarkratetype varchar2(36) -- 基准利率类型
    ,benchmarkrate number(14,10) -- 基准利率
    ,ratefloatway varchar2(15) -- 利率浮动方式
    ,ratefloat number(14,10) -- 浮动值
    ,finedayrate number(14,10) -- 罚息日利率
    ,fineratetype varchar2(15) -- 罚息利率类型
    ,customerid varchar2(90) -- 客户编号
    ,isoverdue varchar2(2) -- 是否逾期(0-否,1-是)
    ,customername varchar2(150) -- 客户姓名
    ,certtype varchar2(27) -- 证件类型
    ,certid varchar2(60) -- 证件编号
    ,customertype varchar2(15) -- 客户类型
    ,assetstatus varchar2(15) -- 资产状态
    ,packetdate varchar2(15) -- 封包日期
    ,publishdate varchar2(15) -- 发行日期
    ,businessdate varchar2(15) -- 贷款处理日期
    ,affiliationregion varchar2(300) -- 所属区域
    ,creditline number(18,2) -- 借款人授信额度
    ,maxoverdueperiod number(10,0) -- 在其他银行贷款的历史最长逾期期数
    ,sex varchar2(3) -- 性别
    ,age number(10,0) -- 年龄
    ,nation varchar2(15) -- 民族
    ,birthday varchar2(15) -- 出生日期
    ,countrycode varchar2(27) -- 国籍
    ,city varchar2(72) -- 借款人所在城市（地级市）
    ,province varchar2(27) -- 借款人所在省份
    ,occupation varchar2(27) -- 职业
    ,degree varchar2(15) -- 最高学位
    ,education varchar2(15) -- 最高学历
    ,marriage varchar2(15) -- 婚姻状况
    ,homeaddress varchar2(300) -- 家庭住址
    ,companyname varchar2(150) -- 单位名称
    ,companyindustry varchar2(15) -- 单位所属行业
    ,creditscore number(10,0) -- 信用评分
    ,staff varchar2(2) -- 是否本行员工
    ,organizationcode varchar2(90) -- 组织机构代码
    ,entnature varchar2(15) -- 企业性质
    ,industrytype varchar2(15) -- 行业分类
    ,entscope varchar2(15) -- 企业规模
    ,listedflag varchar2(2) -- 是否上市
    ,countryregion varchar2(27) -- 所在国家地区
    ,registeredplace varchar2(300) -- 注册地
    ,groupflag varchar2(2) -- 集团客户标识
    ,groupname varchar2(150) -- 所属集团名称
    ,addmethod varchar2(15) -- 数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）
    ,customerbalance number(24,2) -- 客户在本行贷款余额
    ,annualincome number(24,2) -- 年收入
    ,inputuserid varchar2(60) -- 登记人
    ,inputorgid varchar2(60) -- 登记机构
    ,inputtime varchar2(30) -- 登记日期
    ,updateuserid varchar2(60) -- 更新人
    ,updateorgid varchar2(60) -- 更新机构
    ,updatetime varchar2(36) -- 更新日期
    ,offdebitinterest number(24,2) -- 表外欠息
    ,artificialno varchar2(150) -- 合同文本编号
    ,occurtype varchar2(27) -- 发生类型
    ,lngotimes number(10,0) -- 借新还旧次数
    ,conduedate varchar2(36) -- 合同到期日
    ,guarantyrate number(24,8) -- 抵质押率
    ,connormalbalance number(24,8) -- 合同正常余额
    ,conoverduebalance number(24,8) -- 合同逾期余额
    ,direction varchar2(27) -- 行业投向
    ,creditcycle varchar2(27) -- 循环标识
    ,vouchtype varchar2(27) -- 主担保方式
    ,constartdate varchar2(36) -- 合同起始日
    ,contractterm number(10,0) -- 合同期限
    ,contractamount number(24,6) -- 合同金额
    ,actualputoutsum number(24,6) -- 实际已发放金额
    ,contactbalance number(24,6) -- 合同余额
    ,purpose varchar2(300) -- 贷款用途
    ,extendtimes number(10,0) -- 展期次数
    ,tempsave varchar2(15) -- 暂存状态
    ,socialcreditcode varchar2(48) -- 统一社会信用代码
    ,housingarea number(10,2) -- 住房面积
    ,housinglocation varchar2(48) -- 住房所在地区
    ,valuationprice number(10,2) -- 评估价格
    ,fixingprice number(10,2) -- 认定价格
    ,loantovalueretio number(10,2) -- 贷款价值比
    ,isused varchar2(15) -- 一手二手
    ,downpaymentsrate number(10,2) -- 首付比例
    ,businesstype varchar2(60) -- 产品编码
    ,ismaxguarantee varchar2(27) -- 是否涉及最高额担保
    ,businesstypeflag1 varchar2(27) -- 产品分类标志
    ,businesstypename varchar2(120) -- 产品名称
    ,intoverduedays varchar2(15) -- 利息逾期天数
    ,manageorgid varchar2(48) -- 经办机构
    ,manageusername varchar2(48) -- 经办人名称
    ,operateorgname varchar2(48) -- 账务机构名称
    ,termday number(10,0) -- 贷款期限（天）
    ,termmonth number(10,0) -- 贷款期限（月）
    ,guarantyamtrate number(24,2) -- 保证金比例
    ,guarantyamt number(24,2) -- 保证金金额
    ,depositamt number(24,2) -- 存单金额
    ,nationaldebtamt number(24,2) -- 国债金额
    ,financialproductamt number(24,2) -- 理财产品金额
    ,costumelevel varchar2(27) -- 客户评级
    ,publishamt number(24,2) -- 资产转让价格
    ,overduerate number(14,10) -- 逾期利率
    ,lnopin varchar2(30) -- 封包时归属我行利息
    ,lnccst varchar2(30) -- 封包时本金余额
    ,packetassetbalance number(24,6) -- 封包时资产余额
    ,lnopinrate number(24,6) -- 封包时归属我行利息
    ,redpin number(24,6) -- 赎回时归属我行利息
    ,redcst number(24,6) -- 赎回时归属信托利息
    ,accruedchargedate varchar2(36) -- 费用计提日
    ,finishamt number(24,6) -- 赎回对价
    ,redxtpin number(24,6) -- 赎回时归属信托本金
    ,reddate varchar2(15) -- 赎回时间
    ,redeemprinciple number(24,6) -- 赎回对价本金
    ,redeeminterest number(24,6) -- 赎回对价利息
    ,pkg_bef_rcva_int_val number(18,2) -- 封包前应收利息余额
    ,pkg_after_rcva_int_total_amt number(18,2) -- 封包后应收利息总额
    ,pkg_after_rcva_int_bal number(18,2) -- 封包后应收利息余额
    ,has_retn_pkg_after_rcva_int number(18,2) -- 已归还封包后应收利息
    ,totallnccst number(24,6) -- 实时归属我行本金余额
    ,totallnopinrate number(24,6) -- 实时归属我行利息余额
    ,tfr_loan_int_total_amt number(18,2) -- 转让贷款利息总额
    ,errormsg varchar2(300) -- 错误信息
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
grant select on ${iol_schema}.abss_abs_asset_info to ${iml_schema};
grant select on ${iol_schema}.abss_abs_asset_info to ${icl_schema};
grant select on ${iol_schema}.abss_abs_asset_info to ${idl_schema};
grant select on ${iol_schema}.abss_abs_asset_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_asset_info is '基础资产表';
comment on column ${iol_schema}.abss_abs_asset_info.serialno is '资产流水号';
comment on column ${iol_schema}.abss_abs_asset_info.assetchannel is '资产来源';
comment on column ${iol_schema}.abss_abs_asset_info.assetno is '资产编号';
comment on column ${iol_schema}.abss_abs_asset_info.contractserialno is '合同编号';
comment on column ${iol_schema}.abss_abs_asset_info.assettype is '资产类型';
comment on column ${iol_schema}.abss_abs_asset_info.putoutdate is '放款日期';
comment on column ${iol_schema}.abss_abs_asset_info.maturitydate is '到期日';
comment on column ${iol_schema}.abss_abs_asset_info.loanterm is '贷款期次';
comment on column ${iol_schema}.abss_abs_asset_info.residualterm is '剩余期次';
comment on column ${iol_schema}.abss_abs_asset_info.rpttermid is '还款方式';
comment on column ${iol_schema}.abss_abs_asset_info.iccyc is '还款频率';
comment on column ${iol_schema}.abss_abs_asset_info.defaultdate is '每期还款日';
comment on column ${iol_schema}.abss_abs_asset_info.businesssum is '贷款金额';
comment on column ${iol_schema}.abss_abs_asset_info.badbalance is '坏账金额';
comment on column ${iol_schema}.abss_abs_asset_info.overduebalance is '逾期金额';
comment on column ${iol_schema}.abss_abs_asset_info.balance is '贷款余额';
comment on column ${iol_schema}.abss_abs_asset_info.dullbalance is '呆滞金额';
comment on column ${iol_schema}.abss_abs_asset_info.overduedate is '逾期日期';
comment on column ${iol_schema}.abss_abs_asset_info.overduedays is '逾期天数';
comment on column ${iol_schema}.abss_abs_asset_info.maxoverduedays is '最大预期天数';
comment on column ${iol_schema}.abss_abs_asset_info.reserveinterest is '当前未到期利息（计提利息）';
comment on column ${iol_schema}.abss_abs_asset_info.payinterestamt is '应还利息';
comment on column ${iol_schema}.abss_abs_asset_info.breakdate is '违约时间';
comment on column ${iol_schema}.abss_abs_asset_info.payprincipalpenaltyamt is '本金罚息';
comment on column ${iol_schema}.abss_abs_asset_info.payinterestpenaltyamt is '利息罚息';
comment on column ${iol_schema}.abss_abs_asset_info.currency is '币种';
comment on column ${iol_schema}.abss_abs_asset_info.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.abss_abs_asset_info.ratetype is '利率类型';
comment on column ${iol_schema}.abss_abs_asset_info.businessrate is '执行利率';
comment on column ${iol_schema}.abss_abs_asset_info.debtratinglevel is '债项评级';
comment on column ${iol_schema}.abss_abs_asset_info.accountno is '账号';
comment on column ${iol_schema}.abss_abs_asset_info.creditcardvariety is '信用卡品种';
comment on column ${iol_schema}.abss_abs_asset_info.creditcardno is '信用卡号码';
comment on column ${iol_schema}.abss_abs_asset_info.creditlimit is '信用额度';
comment on column ${iol_schema}.abss_abs_asset_info.loanstatus is '贷款状态';
comment on column ${iol_schema}.abss_abs_asset_info.operateuserid is '经办人ID';
comment on column ${iol_schema}.abss_abs_asset_info.operateorgid is '经办机构';
comment on column ${iol_schema}.abss_abs_asset_info.rateadjusway is '利率调整方式';
comment on column ${iol_schema}.abss_abs_asset_info.fixedcyle is '固定周期';
comment on column ${iol_schema}.abss_abs_asset_info.rateadjustcyle is '利率调整周期';
comment on column ${iol_schema}.abss_abs_asset_info.benchmarkratetype is '基准利率类型';
comment on column ${iol_schema}.abss_abs_asset_info.benchmarkrate is '基准利率';
comment on column ${iol_schema}.abss_abs_asset_info.ratefloatway is '利率浮动方式';
comment on column ${iol_schema}.abss_abs_asset_info.ratefloat is '浮动值';
comment on column ${iol_schema}.abss_abs_asset_info.finedayrate is '罚息日利率';
comment on column ${iol_schema}.abss_abs_asset_info.fineratetype is '罚息利率类型';
comment on column ${iol_schema}.abss_abs_asset_info.customerid is '客户编号';
comment on column ${iol_schema}.abss_abs_asset_info.isoverdue is '是否逾期(0-否,1-是)';
comment on column ${iol_schema}.abss_abs_asset_info.customername is '客户姓名';
comment on column ${iol_schema}.abss_abs_asset_info.certtype is '证件类型';
comment on column ${iol_schema}.abss_abs_asset_info.certid is '证件编号';
comment on column ${iol_schema}.abss_abs_asset_info.customertype is '客户类型';
comment on column ${iol_schema}.abss_abs_asset_info.assetstatus is '资产状态';
comment on column ${iol_schema}.abss_abs_asset_info.packetdate is '封包日期';
comment on column ${iol_schema}.abss_abs_asset_info.publishdate is '发行日期';
comment on column ${iol_schema}.abss_abs_asset_info.businessdate is '贷款处理日期';
comment on column ${iol_schema}.abss_abs_asset_info.affiliationregion is '所属区域';
comment on column ${iol_schema}.abss_abs_asset_info.creditline is '借款人授信额度';
comment on column ${iol_schema}.abss_abs_asset_info.maxoverdueperiod is '在其他银行贷款的历史最长逾期期数';
comment on column ${iol_schema}.abss_abs_asset_info.sex is '性别';
comment on column ${iol_schema}.abss_abs_asset_info.age is '年龄';
comment on column ${iol_schema}.abss_abs_asset_info.nation is '民族';
comment on column ${iol_schema}.abss_abs_asset_info.birthday is '出生日期';
comment on column ${iol_schema}.abss_abs_asset_info.countrycode is '国籍';
comment on column ${iol_schema}.abss_abs_asset_info.city is '借款人所在城市（地级市）';
comment on column ${iol_schema}.abss_abs_asset_info.province is '借款人所在省份';
comment on column ${iol_schema}.abss_abs_asset_info.occupation is '职业';
comment on column ${iol_schema}.abss_abs_asset_info.degree is '最高学位';
comment on column ${iol_schema}.abss_abs_asset_info.education is '最高学历';
comment on column ${iol_schema}.abss_abs_asset_info.marriage is '婚姻状况';
comment on column ${iol_schema}.abss_abs_asset_info.homeaddress is '家庭住址';
comment on column ${iol_schema}.abss_abs_asset_info.companyname is '单位名称';
comment on column ${iol_schema}.abss_abs_asset_info.companyindustry is '单位所属行业';
comment on column ${iol_schema}.abss_abs_asset_info.creditscore is '信用评分';
comment on column ${iol_schema}.abss_abs_asset_info.staff is '是否本行员工';
comment on column ${iol_schema}.abss_abs_asset_info.organizationcode is '组织机构代码';
comment on column ${iol_schema}.abss_abs_asset_info.entnature is '企业性质';
comment on column ${iol_schema}.abss_abs_asset_info.industrytype is '行业分类';
comment on column ${iol_schema}.abss_abs_asset_info.entscope is '企业规模';
comment on column ${iol_schema}.abss_abs_asset_info.listedflag is '是否上市';
comment on column ${iol_schema}.abss_abs_asset_info.countryregion is '所在国家地区';
comment on column ${iol_schema}.abss_abs_asset_info.registeredplace is '注册地';
comment on column ${iol_schema}.abss_abs_asset_info.groupflag is '集团客户标识';
comment on column ${iol_schema}.abss_abs_asset_info.groupname is '所属集团名称';
comment on column ${iol_schema}.abss_abs_asset_info.addmethod is '数据新增方式（1人工新增，2批量导入，3excel导入，4接口导入）';
comment on column ${iol_schema}.abss_abs_asset_info.customerbalance is '客户在本行贷款余额';
comment on column ${iol_schema}.abss_abs_asset_info.annualincome is '年收入';
comment on column ${iol_schema}.abss_abs_asset_info.inputuserid is '登记人';
comment on column ${iol_schema}.abss_abs_asset_info.inputorgid is '登记机构';
comment on column ${iol_schema}.abss_abs_asset_info.inputtime is '登记日期';
comment on column ${iol_schema}.abss_abs_asset_info.updateuserid is '更新人';
comment on column ${iol_schema}.abss_abs_asset_info.updateorgid is '更新机构';
comment on column ${iol_schema}.abss_abs_asset_info.updatetime is '更新日期';
comment on column ${iol_schema}.abss_abs_asset_info.offdebitinterest is '表外欠息';
comment on column ${iol_schema}.abss_abs_asset_info.artificialno is '合同文本编号';
comment on column ${iol_schema}.abss_abs_asset_info.occurtype is '发生类型';
comment on column ${iol_schema}.abss_abs_asset_info.lngotimes is '借新还旧次数';
comment on column ${iol_schema}.abss_abs_asset_info.conduedate is '合同到期日';
comment on column ${iol_schema}.abss_abs_asset_info.guarantyrate is '抵质押率';
comment on column ${iol_schema}.abss_abs_asset_info.connormalbalance is '合同正常余额';
comment on column ${iol_schema}.abss_abs_asset_info.conoverduebalance is '合同逾期余额';
comment on column ${iol_schema}.abss_abs_asset_info.direction is '行业投向';
comment on column ${iol_schema}.abss_abs_asset_info.creditcycle is '循环标识';
comment on column ${iol_schema}.abss_abs_asset_info.vouchtype is '主担保方式';
comment on column ${iol_schema}.abss_abs_asset_info.constartdate is '合同起始日';
comment on column ${iol_schema}.abss_abs_asset_info.contractterm is '合同期限';
comment on column ${iol_schema}.abss_abs_asset_info.contractamount is '合同金额';
comment on column ${iol_schema}.abss_abs_asset_info.actualputoutsum is '实际已发放金额';
comment on column ${iol_schema}.abss_abs_asset_info.contactbalance is '合同余额';
comment on column ${iol_schema}.abss_abs_asset_info.purpose is '贷款用途';
comment on column ${iol_schema}.abss_abs_asset_info.extendtimes is '展期次数';
comment on column ${iol_schema}.abss_abs_asset_info.tempsave is '暂存状态';
comment on column ${iol_schema}.abss_abs_asset_info.socialcreditcode is '统一社会信用代码';
comment on column ${iol_schema}.abss_abs_asset_info.housingarea is '住房面积';
comment on column ${iol_schema}.abss_abs_asset_info.housinglocation is '住房所在地区';
comment on column ${iol_schema}.abss_abs_asset_info.valuationprice is '评估价格';
comment on column ${iol_schema}.abss_abs_asset_info.fixingprice is '认定价格';
comment on column ${iol_schema}.abss_abs_asset_info.loantovalueretio is '贷款价值比';
comment on column ${iol_schema}.abss_abs_asset_info.isused is '一手二手';
comment on column ${iol_schema}.abss_abs_asset_info.downpaymentsrate is '首付比例';
comment on column ${iol_schema}.abss_abs_asset_info.businesstype is '产品编码';
comment on column ${iol_schema}.abss_abs_asset_info.ismaxguarantee is '是否涉及最高额担保';
comment on column ${iol_schema}.abss_abs_asset_info.businesstypeflag1 is '产品分类标志';
comment on column ${iol_schema}.abss_abs_asset_info.businesstypename is '产品名称';
comment on column ${iol_schema}.abss_abs_asset_info.intoverduedays is '利息逾期天数';
comment on column ${iol_schema}.abss_abs_asset_info.manageorgid is '经办机构';
comment on column ${iol_schema}.abss_abs_asset_info.manageusername is '经办人名称';
comment on column ${iol_schema}.abss_abs_asset_info.operateorgname is '账务机构名称';
comment on column ${iol_schema}.abss_abs_asset_info.termday is '贷款期限（天）';
comment on column ${iol_schema}.abss_abs_asset_info.termmonth is '贷款期限（月）';
comment on column ${iol_schema}.abss_abs_asset_info.guarantyamtrate is '保证金比例';
comment on column ${iol_schema}.abss_abs_asset_info.guarantyamt is '保证金金额';
comment on column ${iol_schema}.abss_abs_asset_info.depositamt is '存单金额';
comment on column ${iol_schema}.abss_abs_asset_info.nationaldebtamt is '国债金额';
comment on column ${iol_schema}.abss_abs_asset_info.financialproductamt is '理财产品金额';
comment on column ${iol_schema}.abss_abs_asset_info.costumelevel is '客户评级';
comment on column ${iol_schema}.abss_abs_asset_info.publishamt is '资产转让价格';
comment on column ${iol_schema}.abss_abs_asset_info.overduerate is '逾期利率';
comment on column ${iol_schema}.abss_abs_asset_info.lnopin is '封包时归属我行利息';
comment on column ${iol_schema}.abss_abs_asset_info.lnccst is '封包时本金余额';
comment on column ${iol_schema}.abss_abs_asset_info.packetassetbalance is '封包时资产余额';
comment on column ${iol_schema}.abss_abs_asset_info.lnopinrate is '封包时归属我行利息';
comment on column ${iol_schema}.abss_abs_asset_info.redpin is '赎回时归属我行利息';
comment on column ${iol_schema}.abss_abs_asset_info.redcst is '赎回时归属信托利息';
comment on column ${iol_schema}.abss_abs_asset_info.accruedchargedate is '费用计提日';
comment on column ${iol_schema}.abss_abs_asset_info.finishamt is '赎回对价';
comment on column ${iol_schema}.abss_abs_asset_info.redxtpin is '赎回时归属信托本金';
comment on column ${iol_schema}.abss_abs_asset_info.reddate is '赎回时间';
comment on column ${iol_schema}.abss_abs_asset_info.redeemprinciple is '赎回对价本金';
comment on column ${iol_schema}.abss_abs_asset_info.redeeminterest is '赎回对价利息';
comment on column ${iol_schema}.abss_abs_asset_info.pkg_bef_rcva_int_val is '封包前应收利息余额';
comment on column ${iol_schema}.abss_abs_asset_info.pkg_after_rcva_int_total_amt is '封包后应收利息总额';
comment on column ${iol_schema}.abss_abs_asset_info.pkg_after_rcva_int_bal is '封包后应收利息余额';
comment on column ${iol_schema}.abss_abs_asset_info.has_retn_pkg_after_rcva_int is '已归还封包后应收利息';
comment on column ${iol_schema}.abss_abs_asset_info.totallnccst is '实时归属我行本金余额';
comment on column ${iol_schema}.abss_abs_asset_info.totallnopinrate is '实时归属我行利息余额';
comment on column ${iol_schema}.abss_abs_asset_info.tfr_loan_int_total_amt is '转让贷款利息总额';
comment on column ${iol_schema}.abss_abs_asset_info.errormsg is '错误信息';
comment on column ${iol_schema}.abss_abs_asset_info.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_asset_info.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_asset_info.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_asset_info.etl_timestamp is 'ETL处理时间戳';
