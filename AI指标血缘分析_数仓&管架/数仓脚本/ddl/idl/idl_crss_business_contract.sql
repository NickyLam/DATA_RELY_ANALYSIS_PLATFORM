/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crss_business_contract
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
    xzh 2021-10-23 临时修改截取32位长度substr(t1.bondno,1,32)
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crss_business_contract drop partition p_${last_date};
alter table ${idl_schema}.crss_business_contract drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crss_business_contract add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crss_business_contract (
    etl_dt  -- 数据日期
    ,serialno  -- 
    ,relativeserialno  -- 
    ,artificialno  -- 
    ,occurdate  -- 
    ,customerid  -- 
    ,customername  -- 
    ,businesstype  -- 
    ,oldbusinesstype  -- 
    ,businesssubtype  -- 
    ,occurtype  -- 
    ,creditdigest  -- 
    ,creditcycle  -- 
    ,credittype  -- 
    ,currenylist  -- 
    ,currencymode  -- 
    ,businesstypelist  -- 
    ,calculatemode  -- 
    ,useorglist  -- 
    ,flowreduceflag  -- 
    ,contractflag  -- 
    ,subcontractflag  -- 
    ,selfuseflag  -- 
    ,creditindex  -- 
    ,creditreducesum  -- 
    ,limitationterm  -- 
    ,useterm  -- 
    ,creditaggreement  -- 
    ,relativeagreement  -- 
    ,loanflag  -- 
    ,totalsum  -- 
    ,ourrole  -- 
    ,reversibility  -- 
    ,billnum  -- 
    ,housetype  -- 
    ,lctermtype  -- 
    ,riskattribute  -- 
    ,suretype  -- 
    ,safeguardtype  -- 
    ,creditbusiness  -- 
    ,businesscurrency  -- 
    ,businesssum  -- 
    ,businessprop  -- 
    ,termyear  -- 
    ,termmonth  -- 
    ,termday  -- 
    ,lgterm  -- 
    ,baseratetype  -- 
    ,baserate  -- 
    ,ratefloattype  -- 
    ,ratefloat  -- 
    ,businessrate  -- 
    ,ictype  -- 
    ,iccyc  -- 
    ,pdgratio  -- 
    ,pdgsum  -- 
    ,pdgpaymethod  -- 
    ,pdgpayperiod  -- 
    ,promisesfeeratio  -- 
    ,promisesfeesum  -- 
    ,promisesfeeperiod  -- 
    ,promisesfeebegin  -- 
    ,mfeeratio  -- 
    ,mfeesum  -- 
    ,mfeepaymethod  -- 
    ,agentfee  -- 
    ,dealfee  -- 
    ,totalcast  -- 
    ,discountinterest  -- 
    ,purchaserinterest  -- 
    ,bargainorinterest  -- 
    ,discountsum  -- 
    ,bailratio  -- 
    ,bailcurrency  -- 
    ,bailsum  -- 
    ,bailaccount  -- 
    ,fineratetype  -- 
    ,finerate  -- 
    ,drawingtype  -- 
    ,firstdrawingdate  -- 
    ,drawingperiod  -- 
    ,paytimes  -- 
    ,paycyc  -- 
    ,graceperiod  -- 
    ,overdraftperiod  -- 
    ,oldlcno  -- 
    ,oldlctermtype  -- 
    ,oldlccurrency  -- 
    ,oldlcsum  -- 
    ,oldlcloadingdate  -- 
    ,oldlcvaliddate  -- 
    ,direction  -- 
    ,purpose  -- 
    ,planallocation  -- 
    ,immediacypaysource  -- 
    ,paysource  -- 
    ,corpuspaymethod  -- 
    ,interestpaymethod  -- 
    ,putoutdate  -- 
    ,maturity  -- 
    ,thirdparty1  -- 
    ,thirdpartyid1  -- 
    ,thirdparty2  -- 
    ,thirdpartyid2  -- 
    ,thirdparty3  -- 
    ,thirdpartyid3  -- 
    ,thirdpartyregion  -- 
    ,thirdpartyaccounts  -- 
    ,cargoinfo  -- 
    ,projectname  -- 
    ,operationinfo  -- 
    ,contextinfo  -- 
    ,securitiestype  -- 
    ,securitiesregion  -- 
    ,constructionarea  -- 
    ,usearea  -- 
    ,flag1  -- 
    ,flag2  -- 
    ,flag3  -- 
    ,tradecontractno  -- 
    ,invoiceno  -- 
    ,tradecurrency  -- 
    ,tradesum  -- 
    ,lcno  -- 
    ,paymentdate  -- 
    ,operationmode  -- 
    ,begindate  -- 
    ,enddate  -- 
    ,vouchclass  -- 
    ,vouchtype  -- 
    ,vouchtype1  -- 
    ,vouchtype2  -- 
    ,vouchflag  -- 
    ,warrantor  -- 
    ,warrantorid  -- 
    ,othercondition  -- 
    ,guarantyvalue  -- 
    ,guarantyrate  -- 
    ,baseevaluateresult  -- 
    ,riskrate  -- 
    ,lowrisk  -- 
    ,otherarealoan  -- 
    ,lowriskbailsum  -- 
    ,applytype  -- 
    ,originalputoutdate  -- 
    ,extendtimes  -- 
    ,lngotimes  -- 
    ,golntimes  -- 
    ,drtimes  -- 
    ,guarantyno  -- 
    ,putoutsum  -- 
    ,actualputoutsum  -- 
    ,balance  -- 
    ,normalbalance  -- 
    ,overduebalance  -- 
    ,dullbalance  -- 
    ,badbalance  -- 
    ,interestbalance1  -- 
    ,interestbalance2  -- 
    ,finebalance1  -- 
    ,finebalance2  -- 
    ,overduedays  -- 
    ,oweinterestdays  -- 
    ,tabalance  -- 
    ,tainterestbalance  -- 
    ,tatimes  -- 
    ,lcatimes  -- 
    ,pbinterestsum  -- 
    ,pbmfeesum  -- 
    ,pbpdgsum  -- 
    ,pblegalcostsum  -- 
    ,polegalcostsum  -- 
    ,originalbaddate  -- 
    ,baseclassifyresult  -- 
    ,classifyresult  -- 
    ,classifytype  -- 
    ,classifydate  -- 
    ,classifyorgid  -- 
    ,reservesum  -- 
    ,expectlosssum  -- 
    ,bailrate  -- 
    ,finishorg  -- 
    ,finishtype  -- 
    ,finishdate  -- 
    ,describe1  -- 
    ,reinforceflag  -- 
    ,manageorgid  -- 
    ,manageuserid  -- 
    ,recoveryorgid  -- 
    ,recoveryuserid  -- 
    ,statorgid  -- 
    ,statuserid  -- 
    ,operateorgid  -- 
    ,operateuserid  -- 
    ,operatedate  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,pigeonholedate  -- 
    ,remark  -- 
    ,flag4  -- 
    ,paycurrency  -- 
    ,paydate  -- 
    ,flag5  -- 
    ,classifysum1  -- 
    ,classifysum2  -- 
    ,classifysum3  -- 
    ,classifysum4  -- 
    ,classifysum5  -- 
    ,shifttype  -- 
    ,operatetype  -- 
    ,fundsource  -- 
    ,cycleflag  -- 
    ,creditfreezeflag  -- 
    ,shiftbalance  -- 
    ,classifyfrequency  -- 
    ,classifylevel  -- 
    ,vouchnewflag  -- 
    ,actualartificialno  -- 
    ,deleteflag  -- 
    ,accountno  -- 
    ,loanaccountno  -- 
    ,secondpayaccount  -- 
    ,adjustratetype  -- 
    ,adjustrateterm  -- 
    ,overinttype  -- 
    ,rateadjustcyc  -- 
    ,pdgaccountno  -- 
    ,deductdate  -- 
    ,fzanbalance  -- 
    ,acceptinttype  -- 
    ,ratio  -- 
    ,thirdpartyadd1  -- 
    ,thirdpartyzip1  -- 
    ,thirdpartyadd2  -- 
    ,thirdpartyzip2  -- 
    ,thirdpartyadd3  -- 
    ,thirdpartyzip3  -- 
    ,effectarea  -- 
    ,termdate1  -- 
    ,termdate2  -- 
    ,termdate3  -- 
    ,fixcyc  -- 
    ,describe2  -- 
    ,cancelsum  -- 
    ,cancelinterest  -- 
    ,loanterm  -- 
    ,putoutorgid  -- 
    ,tempsaveflag  -- 
    ,overduedate  -- 
    ,oweinterestdate  -- 
    ,freezeflag  -- 
    ,approvedate  -- 
    ,shiftstatus  -- 
    ,recoverycognorgid  -- 
    ,recoverycognuserid  -- 
    ,shiftdocdescribe  -- 
    ,guarantyflag  -- 
    ,totalbalance  -- 
    ,grouplineid  -- 
    ,transformtimes  -- 
    ,transformflag  -- 
    ,fundbackaccount  -- 
    ,requitalaccount  -- 
    ,paymentmode  -- 
    ,classifyresulteleven  -- 
    ,interestrateexplain  -- 
    ,guarantytype  -- 
    ,creditmode  -- 
    ,mainreturntype  -- 主还款方式(代码:MainReturnMethod)
    ,effectflag  -- 
    ,creditattribute  -- 合同类型
    ,isnewcustomertime  -- 检查时间
    ,isnewcustomer  -- 是否为黑名单
    ,hasbothflag  -- 转加按
    ,fundserialno  -- 公积金申请编号
    ,ctogetherborrower  -- 共同借款人个数
    ,csinglnassure  -- 保证人个数
    ,guarantyhouse  -- 抵押房产套数
    ,formerserialno  -- 重组合同号
    ,abysum  -- 赎楼金额
    ,loadrelabarcode  -- 关联贷款条码
    ,loanrelacontractno  -- 增值贷合同号
    ,betterrateflag  -- 利率优惠
    ,goldflag  -- 存贷通
    ,applyinsuranceflag  -- 申请贷款保障保险
    ,sendchitflag  -- 短信提醒
    ,introducerid  -- 介绍人编号
    ,presignflag  -- 预签合同
    ,signaddress  -- 服务中心
    ,sealtype  -- 用印类型
    ,oapproveflag  -- 例外审批
    ,operateusermind  -- 经办单位负责人<br>意见
    ,preapproverid  -- 初审人
    ,buyaddress  -- 房屋用于购买
    ,gracetermpay  -- 宽限期固定还款额
    ,graceterm  -- 还款宽限期
    ,gracetermflag  -- 还款宽限期单位
    ,ratecode  -- 利率类型
    ,gaincyc  -- 等比（等额）<br>递变周期
    ,gainamount  -- 等比（等额）<br>递变幅度
    ,calcterm  -- 低供贷计算期
    ,returntype  -- 期供方式
    ,holdbalance  -- 尾款金额
    ,returnperiod  -- 还款周期
    ,loantermflag  -- 期限类型
    ,schemeno  -- 贷款方案编码
    ,ltvvalue  -- 贷款成数
    ,ratemode  -- 利率执行方式
    ,otherpurpose  -- 其他用途
    ,cycleratio  -- 循环额度比
    ,cguarantypeople  -- 抵押共有权人人数
    ,buyhousetype  -- 所购房屋性质
    ,buyhouseproperty  -- 所购房屋类型
    ,houseareage  -- 购房总面积
    ,housecount  -- 购房套数
    ,industrytype  -- 客户行业属性
    ,isfinance  -- 是否供应链金融模式业务
    ,isimportantloan  -- 是否重点项目贷款
    ,importantloan  -- 重点贷款项目
    ,gshy  -- 过剩行业
    ,sfgjxzhy  -- 是否国家限制行业
    ,zfsxfs  -- 政府授信支持方式
    ,zfsxlx  -- 政府授信类型
    ,sfzfsx  -- 是否政府授信
    ,gksxpz  -- 国开授信品种
    ,sfgksx  -- 是否国开行授信
    ,ifgudingcredit  -- 是否固定资产授信
    ,benefitarea  -- 保函受益人地区
    ,ifqueryflag  -- 是否先贴后查
    ,lastclassifyresult  -- 上次五级分类结果
    ,mainproduct  -- 经营商品
    ,useproduct  -- 使用产品
    ,penalizeratesign  -- 罚息标志
    ,financesupportmode  -- 贷款财政扶持方式
    ,rategenre  -- 利率类型
    ,ifagreementflag  -- 是否协议付息
    ,loanquality  -- 贷款性质
    ,yearratebase  -- 年基数
    ,penalizerateratio  -- 罚息率差值
    ,purchaserpaymentscale  -- 贴现利息买方承担比例(%)
    ,loanratio  -- 贷款费率(%)
    ,bearratio  -- 承担费率(%)
    ,proposerpaymentscale  -- 贴现利息申请人支付比例(%)
    ,compoundinterestratio  -- 复利罚息率(%)
    ,tradeflag  -- 是否走货押中心流程
    ,paymentname  -- 付息方
    ,houseprice  -- 
    ,pawnremitratio  -- 
    ,pawnremitdate  -- 
    ,pawnremitsum  -- 
    ,loadingdate  -- 
    ,chargetype  -- 
    ,offerbilldate  -- 
    ,restbalancesum  -- 
    ,hasoutradio  -- 
    ,outradio  -- 
    ,terminateflag  -- 合同终止标记
    ,paystatus  -- 贷款发放状态
    ,executestatus  -- 合同履行情况
    ,otherexecutestatus  -- 其他合同旅行情况
    ,terminatestatus  -- 终止情况
    ,terminatereason  -- 终止原因
    ,inputdate1  -- 终止合同原因登记日期
    ,aggreementcontractputoutflag  -- 额度合同出账标记
    ,oldcreditline  -- 够划算冻结前授信额度
    ,relativeserialno2  -- 
    ,lcsum  -- 信用证金额
    ,carbrand  -- 
    ,cartype  -- 
    ,carnumber  -- 
    ,chariotnumber  -- 
    ,motornumber  -- 
    ,printeruserid  -- 合同审核和打印人用户号
    ,relativeapplyserialno  -- 无批复额度申请流水号
    ,whetherhousemortgage  -- 是否以住房进行抵押：1-是，2-否
    ,housenum  -- 购第几套住房：1-第一套，2-第二套，3-第三套（以上）
    ,houseadd  -- 购买房产地址
    ,buyhousedetail  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,thirdparty1type  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,thirdorgname  -- 代付行,承兑行
    ,loansource  -- 贷款来源
    ,invaliddate  -- 合同失效日期
    ,oldeffectflag  -- 备份生效标志
    ,oldcreditaggreement  -- 使用授信协议号(备份额度合同流水号)
    ,contractname  -- 合同名称
    ,contracttype  -- 合同类型
    ,contractsum  -- 合同资金
    ,contractitems  -- 合同期次
    ,consignor  -- 委托人
    ,bailee  -- 受托人
    ,trustee  -- 托管人
    ,partybname  -- 借款人
    ,entrustacc  -- 信托专户
    ,beneficiaryacc  -- 受益人账户
    ,entrustinterestrate  -- 信托报酬率
    ,entrustinterestratetype  -- 信托报酬率计提方式
    ,beneficiaryyieldrate  -- 受益人的预计年净收益率
    ,entrustyieldtype  -- 信托收益计提方式
    ,custodian  -- 管理人
    ,manageratetype  -- 管理费费率及计提方式
    ,depositratetype  -- 托管费费率及计提方式
    ,expectyieldrate  -- 预期收益率
    ,priequname  -- 私募债名称
    ,deadline  -- 私募债期限
    ,couponrate  -- 票面利率
    ,issuescale  -- 发行规模
    ,subtotalprices  -- 认购总价
    ,repayinteresttype  -- 还本付息方式
    ,raisefundpurpose  -- 募集资金用途
    ,issuer  -- 发行人/融资者
    ,subscriber  -- 认购人/投资者
    ,raisemoneyaccount  -- 募集资金账户
    ,isinuse  -- 添加维护标志1正常2不维护
    ,creditlineflag  -- 
    ,busirisktype  -- 风险类型
    ,prhdate  -- 按揭房产产权到期日
    ,playtype  -- 参与方式
    ,ischengnuobank  -- 是否承诺行:codeno=YesNo
    ,xmztz  -- 项目总投资
    ,zbj  -- 资本金
    ,pwwh  -- 批文文号
    ,lxpw  -- 立项批文
    ,ghxkzbh  -- 规划许可证编号
    ,jsydxkzbh  -- 建设用地许可证编号
    ,hpxkzbh  -- 环评许可证编号
    ,sgxkzbh  -- 施工许可证编号
    ,qtxkz  -- 其他许可证
    ,qtxkzbh  -- 其他许可证编号
    ,kgrq  -- 开工日期
    ,businesstype2  -- 专业贷款分类
    ,classifytype2  -- 风险暴露分类
    ,approvalsuggestion  -- 建议审批等级
    ,yffdkje  -- 
    ,precreditcycle  -- 变更前额度是否循环标志
    ,tdstrenth  -- 交易对手实力
    ,tdyears  -- 与交易对手合作年限
    ,tdtimes  -- 与交易对手成功交易次数
    ,bailsubaccount  -- 保证金子户
    ,interestrate  -- 保证金利率
    ,isrz  -- 是否融资系统合同 1是0否
    ,financier  -- 实际融资人
    ,iscounterparty  -- 是否合格中央交易对手
    ,investway  -- 投资方式
    ,managemodel  -- 管理模式
    ,toindustryfund  -- 是否投向产业基金
    ,isdebttoequity  -- 是否投向市场化债转股
    ,isgovfinance  -- 是否涉及政府类融资
    ,isconsumefinance  -- 是否为消费服务类融资
    ,isbalancedeposit  -- 是否结算性存款
    ,canbacktosale  -- 是否含有回售选择权
    ,canseparate  -- 是否可分离
    ,businessmarkettype  -- 交易市场类型
    ,businessmarket  -- 交易市场
    ,absabnname  -- ABS/ABN名称
    ,isfillassetsinfo  -- 是否已完整录入全部底层资产信息
    ,backtosaletype  -- 回购类型
    ,afterloanmanagerid  -- 贷后管理人员
    ,afterloanmanagement  -- 贷后管理机构
    ,creditincrementtype  -- 主要增信方式
    ,tradingassets  -- 交易资产
    ,depositno  -- 同业存单号码
    ,depositname  -- 同业存单简称
    ,issueprice  -- 发行价格
    ,issueamount  -- 发行量（元）
    ,issuesum  -- 发行金额（元）
    ,bondno  -- 债券代码
    ,bondname  -- 债券名称
    ,outerevaluate1  -- 债券外部评级结果（发行时）
    ,outerevaluate2  -- 债券外部评级结果（购买时）
    ,outerevaluate3  -- 债券外部评级结果（当前）
    ,investkind  -- 投资性质
    ,transactionprice  -- 成交净价
    ,transactionrate  -- 成交利率
    ,transactoinamount  -- 成交量
    ,transactiondate  -- 实际交割日期
    ,salebackbegindate  -- 回售申请起始日
    ,salebackenddate  -- 回售申请截止日
    ,financialtype  -- 理财产品类型
    ,financialclassify  -- 理财产品风险分类
    ,acceptcustomerid  -- 承兑行我行客户编号
    ,acceptbankid  -- 承兑行行号
    ,acceptbankname  -- 承兑行名称
    ,iswhzt  -- 是否我行直贴票据
    ,stockcode  -- 标的股票代码
    ,stockname  -- 标的股票名称
    ,stockamount  -- 总股本（万股）
    ,circulatestockamount  -- 流通股本（万股）
    ,bdindustry  -- 标的公司行业分类
    ,guranteerate  -- 质押率/初始履约保障比例
    ,alarmline  -- 预警线
    ,pcline  -- 平仓线
    ,billtype  -- 票据类型
    ,billkind  -- 票据种类
    ,billno  -- 票据号码
    ,billcurrency  -- 票据币种
    ,billsum  -- 票面金额
    ,billacptdate  -- 出票日
    ,billmaturity  -- 票据到期日
    ,billwriter  -- 出票人
    ,operationtype  -- 业务类型
    ,reinforcechecker  -- 补登复核人
    ,onlineamount  -- 线上额度
    ,businesssumentpart  -- 集团授信额度公司部分
    ,totalsumentpart  -- 集团授信敞口公司部分
    ,businesssumtypart  -- 集团授信额度同业部分
    ,totalsumtypart  -- 集团授信额度同业部分
    ,creditflowtype  -- 授信业务流程类型
    ,batchno  -- 批量新增借据合同关键字段
    ,datatype  -- 批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）
    ,creditarea  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,isestatefinance  -- 是否涉及房地产融资
    ,isgovernfinance  -- 是否涉及政府类融资
    ,isconsumerfinance  -- 是否为消费服务类融资
    ,isbeltroadfinance  -- 是否为一带一路建设投融资
    ,isgreenfinance  -- 是否为绿色信贷融资
    ,reinforcetype  -- 补登来源 dg-对公 空-同业
    ,rivalid  -- 同业交易对手
    ,rivalname  -- 同业交易对手名称
    ,consigneeid  -- 管理人/主承销商客户编号
    ,consigneename  -- 管理人/主承销商名称
    ,consigneecerttype  -- 管理人/主承销商证件类型
    ,consigneecertid  -- 管理人/主承销商证件号码
    ,outclassifylevel  -- 外部债项评级
    ,outclassifyorg  -- 评级机构
    ,outclassifydate  -- 评级日期
    ,isonlinebusiness  -- 是否线上业务：yes-是 no/空-否
    ,keyno  -- 票据唯一标识
    ,actno  -- 成交单号--资金交易系统批量
    ,registerinotherbank  -- 是否他行代开
    ,issupplychainfinance  -- 是否为供应链金融业务
    ,supplychainfinancetype  -- 供应链金融业务产品分类
    ,issjorcs  -- 是否三旧改造或城市更新项目
    ,islikeloan  -- 是否类信贷
    ,guarantybailaccount  -- 押品保证金账号
    ,guarantybailsubaccount  -- 押品保证金子户号
    ,consignmentloandirect  -- 委托贷款特殊投向
    ,isclassflag  -- 是否分级标志
    ,productlevel  -- 产品分级级别
    ,productcollectmoney  -- 产品募集金额
    ,finalinvestdirecttype  -- 最终投向类型
    ,realestateloantype  -- 房地产贷款类型
    ,chuantoutype  -- 穿透类型
    ,corecompany  -- 核心企业名称
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.serialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.artificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.customername,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldbusinesstype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesssubtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occurtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditdigest,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditcycle,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.credittype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currenylist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.currencymode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesstypelist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.calculatemode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.useorglist,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flowreduceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contractflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.subcontractflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.selfuseflag,chr(13),''),chr(10),'')  -- 
    ,t1.creditindex  -- 
    ,t1.creditreducesum  -- 
    ,replace(replace(t1.limitationterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.useterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditaggreement,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativeagreement,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanflag,chr(13),''),chr(10),'')  -- 
    ,t1.totalsum  -- 
    ,replace(replace(t1.ourrole,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.reversibility,chr(13),''),chr(10),'')  -- 
    ,t1.billnum  -- 
    ,replace(replace(t1.housetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.lctermtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.riskattribute,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.suretype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.safeguardtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditbusiness,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'')  -- 
    ,t1.businesssum  -- 
    ,t1.businessprop  -- 
    ,t1.termyear  -- 
    ,t1.termmonth  -- 
    ,t1.termday  -- 
    ,t1.lgterm  -- 
    ,replace(replace(t1.baseratetype,chr(13),''),chr(10),'')  -- 
    ,t1.baserate  -- 
    ,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'')  -- 
    ,t1.ratefloat  -- 
    ,t1.businessrate  -- 
    ,replace(replace(t1.ictype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.iccyc,chr(13),''),chr(10),'')  -- 
    ,t1.pdgratio  -- 
    ,t1.pdgsum  -- 
    ,replace(replace(t1.pdgpaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgpayperiod,chr(13),''),chr(10),'')  -- 
    ,t1.promisesfeeratio  -- 
    ,t1.promisesfeesum  -- 
    ,t1.promisesfeeperiod  -- 
    ,replace(replace(t1.promisesfeebegin,chr(13),''),chr(10),'')  -- 
    ,t1.mfeeratio  -- 
    ,t1.mfeesum  -- 
    ,replace(replace(t1.mfeepaymethod,chr(13),''),chr(10),'')  -- 
    ,t1.agentfee  -- 
    ,t1.dealfee  -- 
    ,t1.totalcast  -- 
    ,t1.discountinterest  -- 
    ,t1.purchaserinterest  -- 
    ,t1.bargainorinterest  -- 
    ,t1.discountsum  -- 
    ,t1.bailratio  -- 
    ,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'')  -- 
    ,t1.bailsum  -- 
    ,replace(replace(t1.bailaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fineratetype,chr(13),''),chr(10),'')  -- 
    ,t1.finerate  -- 
    ,replace(replace(t1.drawingtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.firstdrawingdate,chr(13),''),chr(10),'')  -- 
    ,t1.drawingperiod  -- 
    ,t1.paytimes  -- 
    ,replace(replace(t1.paycyc,chr(13),''),chr(10),'')  -- 
    ,t1.graceperiod  -- 
    ,t1.overdraftperiod  -- 
    ,replace(replace(t1.oldlcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlctermtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlccurrency,chr(13),''),chr(10),'')  -- 
    ,t1.oldlcsum  -- 
    ,replace(replace(t1.oldlcloadingdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oldlcvaliddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.direction,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.purpose,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.planallocation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.immediacypaysource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paysource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interestpaymethod,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.putoutdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.maturity,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdparty3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyid3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyregion,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyaccounts,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cargoinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.projectname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operationinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.contextinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiestype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.securitiesregion,chr(13),''),chr(10),'')  -- 
    ,t1.constructionarea  -- 
    ,t1.usearea  -- 
    ,replace(replace(t1.flag1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tradecontractno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.invoiceno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tradecurrency,chr(13),''),chr(10),'')  -- 
    ,t1.tradesum  -- 
    ,replace(replace(t1.lcno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymentdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operationmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.begindate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.enddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchclass,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchtype2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.warrantor,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.warrantorid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.othercondition,chr(13),''),chr(10),'')  -- 
    ,t1.guarantyvalue  -- 
    ,t1.guarantyrate  -- 
    ,replace(replace(t1.baseevaluateresult,chr(13),''),chr(10),'')  -- 
    ,t1.riskrate  -- 
    ,replace(replace(t1.lowrisk,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.otherarealoan,chr(13),''),chr(10),'')  -- 
    ,t1.lowriskbailsum  -- 
    ,replace(replace(t1.applytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.originalputoutdate,chr(13),''),chr(10),'')  -- 
    ,t1.extendtimes  -- 
    ,t1.lngotimes  -- 
    ,t1.golntimes  -- 
    ,t1.drtimes  -- 
    ,replace(replace(t1.guarantyno,chr(13),''),chr(10),'')  -- 
    ,t1.putoutsum  -- 
    ,t1.actualputoutsum  -- 
    ,t1.balance  -- 
    ,t1.normalbalance  -- 
    ,t1.overduebalance  -- 
    ,t1.dullbalance  -- 
    ,t1.badbalance  -- 
    ,t1.interestbalance1  -- 
    ,t1.interestbalance2  -- 
    ,t1.finebalance1  -- 
    ,t1.finebalance2  -- 
    ,t1.overduedays  -- 
    ,t1.oweinterestdays  -- 
    ,t1.tabalance  -- 
    ,t1.tainterestbalance  -- 
    ,t1.tatimes  -- 
    ,t1.lcatimes  -- 
    ,t1.pbinterestsum  -- 
    ,t1.pbmfeesum  -- 
    ,t1.pbpdgsum  -- 
    ,t1.pblegalcostsum  -- 
    ,t1.polegalcostsum  -- 
    ,replace(replace(t1.originalbaddate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.baseclassifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresult,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyorgid,chr(13),''),chr(10),'')  -- 
    ,t1.reservesum  -- 
    ,t1.expectlosssum  -- 
    ,t1.bailrate  -- 
    ,replace(replace(t1.finishorg,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finishtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finishdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.describe1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.reinforceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.manageorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.manageuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.recoveryorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.recoveryuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.statorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.statuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pigeonholedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paycurrency,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paydate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.flag5,chr(13),''),chr(10),'')  -- 
    ,t1.classifysum1  -- 
    ,t1.classifysum2  -- 
    ,t1.classifysum3  -- 
    ,t1.classifysum4  -- 
    ,t1.classifysum5  -- 
    ,replace(replace(t1.shifttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.operatetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundsource,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cycleflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditfreezeflag,chr(13),''),chr(10),'')  -- 
    ,t1.shiftbalance  -- 
    ,t1.classifyfrequency  -- 
    ,replace(replace(t1.classifylevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.vouchnewflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.actualartificialno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.deleteflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.accountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loanaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.secondpayaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.adjustrateterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.overinttype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.rateadjustcyc,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.pdgaccountno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.deductdate,chr(13),''),chr(10),'')  -- 
    ,t1.fzanbalance  -- 
    ,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'')  -- 
    ,t1.ratio  -- 
    ,replace(replace(t1.thirdpartyadd1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyadd2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyadd3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.thirdpartyzip3,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.effectarea,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate1,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate2,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.termdate3,chr(13),''),chr(10),'')  -- 
    ,t1.fixcyc  -- 
    ,replace(replace(t1.describe2,chr(13),''),chr(10),'')  -- 
    ,t1.cancelsum  -- 
    ,t1.cancelinterest  -- 
    ,replace(replace(t1.loanterm,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.overduedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.oweinterestdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.freezeflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.approvedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shiftstatus,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.recoverycognorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.recoverycognuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.shiftdocdescribe,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantyflag,chr(13),''),chr(10),'')  -- 
    ,t1.totalbalance  -- 
    ,replace(replace(t1.grouplineid,chr(13),''),chr(10),'')  -- 
    ,t1.transformtimes  -- 
    ,replace(replace(t1.transformflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fundbackaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.requitalaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paymentmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.classifyresulteleven,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.interestrateexplain,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.guarantytype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditmode,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mainreturntype,chr(13),''),chr(10),'')  -- 主还款方式(代码:MainReturnMethod)
    ,replace(replace(t1.effectflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditattribute,chr(13),''),chr(10),'')  -- 合同类型
    ,replace(replace(t1.isnewcustomertime,chr(13),''),chr(10),'')  -- 检查时间
    ,replace(replace(t1.isnewcustomer,chr(13),''),chr(10),'')  -- 是否为黑名单
    ,replace(replace(t1.hasbothflag,chr(13),''),chr(10),'')  -- 转加按
    ,replace(replace(t1.fundserialno,chr(13),''),chr(10),'')  -- 公积金申请编号
    ,replace(replace(t1.ctogetherborrower,chr(13),''),chr(10),'')  -- 共同借款人个数
    ,replace(replace(t1.csinglnassure,chr(13),''),chr(10),'')  -- 保证人个数
    ,replace(replace(t1.guarantyhouse,chr(13),''),chr(10),'')  -- 抵押房产套数
    ,replace(replace(t1.formerserialno,chr(13),''),chr(10),'')  -- 重组合同号
    ,replace(replace(t1.abysum,chr(13),''),chr(10),'')  -- 赎楼金额
    ,replace(replace(t1.loadrelabarcode,chr(13),''),chr(10),'')  -- 关联贷款条码
    ,replace(replace(t1.loanrelacontractno,chr(13),''),chr(10),'')  -- 增值贷合同号
    ,replace(replace(t1.betterrateflag,chr(13),''),chr(10),'')  -- 利率优惠
    ,replace(replace(t1.goldflag,chr(13),''),chr(10),'')  -- 存贷通
    ,replace(replace(t1.applyinsuranceflag,chr(13),''),chr(10),'')  -- 申请贷款保障保险
    ,replace(replace(t1.sendchitflag,chr(13),''),chr(10),'')  -- 短信提醒
    ,replace(replace(t1.introducerid,chr(13),''),chr(10),'')  -- 介绍人编号
    ,replace(replace(t1.presignflag,chr(13),''),chr(10),'')  -- 预签合同
    ,replace(replace(t1.signaddress,chr(13),''),chr(10),'')  -- 服务中心
    ,replace(replace(t1.sealtype,chr(13),''),chr(10),'')  -- 用印类型
    ,replace(replace(t1.oapproveflag,chr(13),''),chr(10),'')  -- 例外审批
    ,replace(replace(t1.operateusermind,chr(13),''),chr(10),'')  -- 经办单位负责人<br>意见
    ,replace(replace(t1.preapproverid,chr(13),''),chr(10),'')  -- 初审人
    ,replace(replace(t1.buyaddress,chr(13),''),chr(10),'')  -- 房屋用于购买
    ,replace(replace(t1.gracetermpay,chr(13),''),chr(10),'')  -- 宽限期固定还款额
    ,replace(replace(t1.graceterm,chr(13),''),chr(10),'')  -- 还款宽限期
    ,replace(replace(t1.gracetermflag,chr(13),''),chr(10),'')  -- 还款宽限期单位
    ,replace(replace(t1.ratecode,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.gaincyc,chr(13),''),chr(10),'')  -- 等比（等额）<br>递变周期
    ,replace(replace(t1.gainamount,chr(13),''),chr(10),'')  -- 等比（等额）<br>递变幅度
    ,replace(replace(t1.calcterm,chr(13),''),chr(10),'')  -- 低供贷计算期
    ,replace(replace(t1.returntype,chr(13),''),chr(10),'')  -- 期供方式
    ,replace(replace(t1.holdbalance,chr(13),''),chr(10),'')  -- 尾款金额
    ,replace(replace(t1.returnperiod,chr(13),''),chr(10),'')  -- 还款周期
    ,replace(replace(t1.loantermflag,chr(13),''),chr(10),'')  -- 期限类型
    ,replace(replace(t1.schemeno,chr(13),''),chr(10),'')  -- 贷款方案编码
    ,replace(replace(t1.ltvvalue,chr(13),''),chr(10),'')  -- 贷款成数
    ,replace(replace(t1.ratemode,chr(13),''),chr(10),'')  -- 利率执行方式
    ,replace(replace(t1.otherpurpose,chr(13),''),chr(10),'')  -- 其他用途
    ,replace(replace(t1.cycleratio,chr(13),''),chr(10),'')  -- 循环额度比
    ,replace(replace(t1.cguarantypeople,chr(13),''),chr(10),'')  -- 抵押共有权人人数
    ,replace(replace(t1.buyhousetype,chr(13),''),chr(10),'')  -- 所购房屋性质
    ,replace(replace(t1.buyhouseproperty,chr(13),''),chr(10),'')  -- 所购房屋类型
    ,replace(replace(t1.houseareage,chr(13),''),chr(10),'')  -- 购房总面积
    ,replace(replace(t1.housecount,chr(13),''),chr(10),'')  -- 购房套数
    ,replace(replace(t1.industrytype,chr(13),''),chr(10),'')  -- 客户行业属性
    ,replace(replace(t1.isfinance,chr(13),''),chr(10),'')  -- 是否供应链金融模式业务
    ,replace(replace(t1.isimportantloan,chr(13),''),chr(10),'')  -- 是否重点项目贷款
    ,replace(replace(t1.importantloan,chr(13),''),chr(10),'')  -- 重点贷款项目
    ,replace(replace(t1.gshy,chr(13),''),chr(10),'')  -- 过剩行业
    ,replace(replace(t1.sfgjxzhy,chr(13),''),chr(10),'')  -- 是否国家限制行业
    ,replace(replace(t1.zfsxfs,chr(13),''),chr(10),'')  -- 政府授信支持方式
    ,replace(replace(t1.zfsxlx,chr(13),''),chr(10),'')  -- 政府授信类型
    ,replace(replace(t1.sfzfsx,chr(13),''),chr(10),'')  -- 是否政府授信
    ,replace(replace(t1.gksxpz,chr(13),''),chr(10),'')  -- 国开授信品种
    ,replace(replace(t1.sfgksx,chr(13),''),chr(10),'')  -- 是否国开行授信
    ,replace(replace(t1.ifgudingcredit,chr(13),''),chr(10),'')  -- 是否固定资产授信
    ,replace(replace(t1.benefitarea,chr(13),''),chr(10),'')  -- 保函受益人地区
    ,replace(replace(t1.ifqueryflag,chr(13),''),chr(10),'')  -- 是否先贴后查
    ,replace(replace(t1.lastclassifyresult,chr(13),''),chr(10),'')  -- 上次五级分类结果
    ,replace(replace(t1.mainproduct,chr(13),''),chr(10),'')  -- 经营商品
    ,replace(replace(t1.useproduct,chr(13),''),chr(10),'')  -- 使用产品
    ,replace(replace(t1.penalizeratesign,chr(13),''),chr(10),'')  -- 罚息标志
    ,replace(replace(t1.financesupportmode,chr(13),''),chr(10),'')  -- 贷款财政扶持方式
    ,replace(replace(t1.rategenre,chr(13),''),chr(10),'')  -- 利率类型
    ,replace(replace(t1.ifagreementflag,chr(13),''),chr(10),'')  -- 是否协议付息
    ,replace(replace(t1.loanquality,chr(13),''),chr(10),'')  -- 贷款性质
    ,replace(replace(t1.yearratebase,chr(13),''),chr(10),'')  -- 年基数
    ,t1.penalizerateratio  -- 罚息率差值
    ,t1.purchaserpaymentscale  -- 贴现利息买方承担比例(%)
    ,t1.loanratio  -- 贷款费率(%)
    ,t1.bearratio  -- 承担费率(%)
    ,t1.proposerpaymentscale  -- 贴现利息申请人支付比例(%)
    ,t1.compoundinterestratio  -- 复利罚息率(%)
    ,replace(replace(t1.tradeflag,chr(13),''),chr(10),'')  -- 是否走货押中心流程
    ,replace(replace(t1.paymentname,chr(13),''),chr(10),'')  -- 付息方
    ,t1.houseprice  -- 
    ,t1.pawnremitratio  -- 
    ,replace(replace(t1.pawnremitdate,chr(13),''),chr(10),'')  -- 
    ,t1.pawnremitsum  -- 
    ,replace(replace(t1.loadingdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chargetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.offerbilldate,chr(13),''),chr(10),'')  -- 
    ,t1.restbalancesum  -- 
    ,replace(replace(t1.hasoutradio,chr(13),''),chr(10),'')  -- 
    ,t1.outradio  -- 
    ,replace(replace(t1.terminateflag,chr(13),''),chr(10),'')  -- 合同终止标记
    ,replace(replace(t1.paystatus,chr(13),''),chr(10),'')  -- 贷款发放状态
    ,replace(replace(t1.executestatus,chr(13),''),chr(10),'')  -- 合同履行情况
    ,replace(replace(t1.otherexecutestatus,chr(13),''),chr(10),'')  -- 其他合同旅行情况
    ,replace(replace(t1.terminatestatus,chr(13),''),chr(10),'')  -- 终止情况
    ,replace(replace(t1.terminatereason,chr(13),''),chr(10),'')  -- 终止原因
    ,replace(replace(t1.inputdate1,chr(13),''),chr(10),'')  -- 终止合同原因登记日期
    ,replace(replace(t1.aggreementcontractputoutflag,chr(13),''),chr(10),'')  -- 额度合同出账标记
    ,t1.oldcreditline  -- 够划算冻结前授信额度
    ,replace(replace(t1.relativeserialno2,chr(13),''),chr(10),'')  -- 
    ,t1.lcsum  -- 信用证金额
    ,replace(replace(t1.carbrand,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.cartype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.carnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.chariotnumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.motornumber,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.printeruserid,chr(13),''),chr(10),'')  -- 合同审核和打印人用户号
    ,replace(replace(t1.relativeapplyserialno,chr(13),''),chr(10),'')  -- 无批复额度申请流水号
    ,replace(replace(t1.whetherhousemortgage,chr(13),''),chr(10),'')  -- 是否以住房进行抵押：1-是，2-否
    ,replace(replace(t1.housenum,chr(13),''),chr(10),'')  -- 购第几套住房：1-第一套，2-第二套，3-第三套（以上）
    ,replace(replace(t1.houseadd,chr(13),''),chr(10),'')  -- 购买房产地址
    ,replace(replace(t1.buyhousedetail,chr(13),''),chr(10),'')  -- 购房细分：1-购一手房，2-购二手房，3-购其他类型住房，4-购商铺，5-购写字楼，6-购厂房，7-购其他商业用房
    ,replace(replace(t1.thirdparty1type,chr(13),''),chr(10),'')  -- 代付类型：1-买方押汇，2-打包放款，3-卖方押汇，4-国内信用证项下贴现
    ,replace(replace(t1.thirdorgname,chr(13),''),chr(10),'')  -- 代付行,承兑行
    ,replace(replace(t1.loansource,chr(13),''),chr(10),'')  -- 贷款来源
    ,replace(replace(t1.invaliddate,chr(13),''),chr(10),'')  -- 合同失效日期
    ,replace(replace(t1.oldeffectflag,chr(13),''),chr(10),'')  -- 备份生效标志
    ,replace(replace(t1.oldcreditaggreement,chr(13),''),chr(10),'')  -- 使用授信协议号(备份额度合同流水号)
    ,replace(replace(t1.contractname,chr(13),''),chr(10),'')  -- 合同名称
    ,replace(replace(t1.contracttype,chr(13),''),chr(10),'')  -- 合同类型
    ,t1.contractsum  -- 合同资金
    ,t1.contractitems  -- 合同期次
    ,replace(replace(t1.consignor,chr(13),''),chr(10),'')  -- 委托人
    ,replace(replace(t1.bailee,chr(13),''),chr(10),'')  -- 受托人
    ,replace(replace(t1.trustee,chr(13),''),chr(10),'')  -- 托管人
    ,replace(replace(t1.partybname,chr(13),''),chr(10),'')  -- 借款人
    ,replace(replace(t1.entrustacc,chr(13),''),chr(10),'')  -- 信托专户
    ,replace(replace(t1.beneficiaryacc,chr(13),''),chr(10),'')  -- 受益人账户
    ,t1.entrustinterestrate  -- 信托报酬率
    ,replace(replace(t1.entrustinterestratetype,chr(13),''),chr(10),'')  -- 信托报酬率计提方式
    ,t1.beneficiaryyieldrate  -- 受益人的预计年净收益率
    ,replace(replace(t1.entrustyieldtype,chr(13),''),chr(10),'')  -- 信托收益计提方式
    ,replace(replace(t1.custodian,chr(13),''),chr(10),'')  -- 管理人
    ,replace(replace(t1.manageratetype,chr(13),''),chr(10),'')  -- 管理费费率及计提方式
    ,replace(replace(t1.depositratetype,chr(13),''),chr(10),'')  -- 托管费费率及计提方式
    ,t1.expectyieldrate  -- 预期收益率
    ,replace(replace(t1.priequname,chr(13),''),chr(10),'')  -- 私募债名称
    ,t1.deadline  -- 私募债期限
    ,t1.couponrate  -- 票面利率
    ,replace(replace(t1.issuescale,chr(13),''),chr(10),'')  -- 发行规模
    ,t1.subtotalprices  -- 认购总价
    ,replace(replace(t1.repayinteresttype,chr(13),''),chr(10),'')  -- 还本付息方式
    ,replace(replace(t1.raisefundpurpose,chr(13),''),chr(10),'')  -- 募集资金用途
    ,replace(replace(t1.issuer,chr(13),''),chr(10),'')  -- 发行人/融资者
    ,replace(replace(t1.subscriber,chr(13),''),chr(10),'')  -- 认购人/投资者
    ,replace(replace(t1.raisemoneyaccount,chr(13),''),chr(10),'')  -- 募集资金账户
    ,replace(replace(t1.isinuse,chr(13),''),chr(10),'')  -- 添加维护标志1正常2不维护
    ,replace(replace(t1.creditlineflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.busirisktype,chr(13),''),chr(10),'')  -- 风险类型
    ,replace(replace(t1.prhdate,chr(13),''),chr(10),'')  -- 按揭房产产权到期日
    ,replace(replace(t1.playtype,chr(13),''),chr(10),'')  -- 参与方式
    ,replace(replace(t1.ischengnuobank,chr(13),''),chr(10),'')  -- 是否承诺行:codeno=YesNo
    ,t1.xmztz  -- 项目总投资
    ,t1.zbj  -- 资本金
    ,replace(replace(t1.pwwh,chr(13),''),chr(10),'')  -- 批文文号
    ,replace(replace(t1.lxpw,chr(13),''),chr(10),'')  -- 立项批文
    ,replace(replace(t1.ghxkzbh,chr(13),''),chr(10),'')  -- 规划许可证编号
    ,replace(replace(t1.jsydxkzbh,chr(13),''),chr(10),'')  -- 建设用地许可证编号
    ,replace(replace(t1.hpxkzbh,chr(13),''),chr(10),'')  -- 环评许可证编号
    ,replace(replace(t1.sgxkzbh,chr(13),''),chr(10),'')  -- 施工许可证编号
    ,replace(replace(t1.qtxkz,chr(13),''),chr(10),'')  -- 其他许可证
    ,replace(replace(t1.qtxkzbh,chr(13),''),chr(10),'')  -- 其他许可证编号
    ,replace(replace(t1.kgrq,chr(13),''),chr(10),'')  -- 开工日期
    ,replace(replace(t1.businesstype2,chr(13),''),chr(10),'')  -- 专业贷款分类
    ,replace(replace(t1.classifytype2,chr(13),''),chr(10),'')  -- 风险暴露分类
    ,replace(replace(t1.approvalsuggestion,chr(13),''),chr(10),'')  -- 建议审批等级
    ,t1.yffdkje  -- 
    ,replace(replace(t1.precreditcycle,chr(13),''),chr(10),'')  -- 变更前额度是否循环标志
    ,replace(replace(t1.tdstrenth,chr(13),''),chr(10),'')  -- 交易对手实力
    ,replace(replace(t1.tdyears,chr(13),''),chr(10),'')  -- 与交易对手合作年限
    ,replace(replace(t1.tdtimes,chr(13),''),chr(10),'')  -- 与交易对手成功交易次数
    ,replace(replace(t1.bailsubaccount,chr(13),''),chr(10),'')  -- 保证金子户
    ,t1.interestrate  -- 保证金利率
    ,replace(replace(t1.isrz,chr(13),''),chr(10),'')  -- 是否融资系统合同 1是0否
    ,replace(replace(t1.financier,chr(13),''),chr(10),'')  -- 实际融资人
    ,replace(replace(t1.iscounterparty,chr(13),''),chr(10),'')  -- 是否合格中央交易对手
    ,replace(replace(t1.investway,chr(13),''),chr(10),'')  -- 投资方式
    ,replace(replace(t1.managemodel,chr(13),''),chr(10),'')  -- 管理模式
    ,replace(replace(t1.toindustryfund,chr(13),''),chr(10),'')  -- 是否投向产业基金
    ,replace(replace(t1.isdebttoequity,chr(13),''),chr(10),'')  -- 是否投向市场化债转股
    ,replace(replace(t1.isgovfinance,chr(13),''),chr(10),'')  -- 是否涉及政府类融资
    ,replace(replace(t1.isconsumefinance,chr(13),''),chr(10),'')  -- 是否为消费服务类融资
    ,replace(replace(t1.isbalancedeposit,chr(13),''),chr(10),'')  -- 是否结算性存款
    ,replace(replace(t1.canbacktosale,chr(13),''),chr(10),'')  -- 是否含有回售选择权
    ,replace(replace(t1.canseparate,chr(13),''),chr(10),'')  -- 是否可分离
    ,replace(replace(t1.businessmarkettype,chr(13),''),chr(10),'')  -- 交易市场类型
    ,replace(replace(t1.businessmarket,chr(13),''),chr(10),'')  -- 交易市场
    ,replace(replace(t1.absabnname,chr(13),''),chr(10),'')  -- ABS/ABN名称
    ,replace(replace(t1.isfillassetsinfo,chr(13),''),chr(10),'')  -- 是否已完整录入全部底层资产信息
    ,replace(replace(t1.backtosaletype,chr(13),''),chr(10),'')  -- 回购类型
    ,replace(replace(t1.afterloanmanagerid,chr(13),''),chr(10),'')  -- 贷后管理人员
    ,replace(replace(t1.afterloanmanagement,chr(13),''),chr(10),'')  -- 贷后管理机构
    ,replace(replace(t1.creditincrementtype,chr(13),''),chr(10),'')  -- 主要增信方式
    ,replace(replace(t1.tradingassets,chr(13),''),chr(10),'')  -- 交易资产
    ,replace(replace(t1.depositno,chr(13),''),chr(10),'')  -- 同业存单号码
    ,replace(replace(t1.depositname,chr(13),''),chr(10),'')  -- 同业存单简称
    ,t1.issueprice  -- 发行价格
    ,t1.issueamount  -- 发行量（元）
    ,t1.issuesum  -- 发行金额（元）
    ,replace(replace(substr(t1.bondno,1,32),chr(13),''),chr(10),'')  -- 债券代码
    ,replace(replace(t1.bondname,chr(13),''),chr(10),'')  -- 债券名称
    ,replace(replace(t1.outerevaluate1,chr(13),''),chr(10),'')  -- 债券外部评级结果（发行时）
    ,replace(replace(t1.outerevaluate2,chr(13),''),chr(10),'')  -- 债券外部评级结果（购买时）
    ,replace(replace(t1.outerevaluate3,chr(13),''),chr(10),'')  -- 债券外部评级结果（当前）
    ,replace(replace(t1.investkind,chr(13),''),chr(10),'')  -- 投资性质
    ,t1.transactionprice  -- 成交净价
    ,t1.transactionrate  -- 成交利率
    ,replace(replace(t1.transactoinamount,chr(13),''),chr(10),'')  -- 成交量
    ,replace(replace(t1.transactiondate,chr(13),''),chr(10),'')  -- 实际交割日期
    ,replace(replace(t1.salebackbegindate,chr(13),''),chr(10),'')  -- 回售申请起始日
    ,replace(replace(t1.salebackenddate,chr(13),''),chr(10),'')  -- 回售申请截止日
    ,replace(replace(t1.financialtype,chr(13),''),chr(10),'')  -- 理财产品类型
    ,replace(replace(t1.financialclassify,chr(13),''),chr(10),'')  -- 理财产品风险分类
    ,replace(replace(t1.acceptcustomerid,chr(13),''),chr(10),'')  -- 承兑行我行客户编号
    ,replace(replace(t1.acceptbankid,chr(13),''),chr(10),'')  -- 承兑行行号
    ,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'')  -- 承兑行名称
    ,replace(replace(t1.iswhzt,chr(13),''),chr(10),'')  -- 是否我行直贴票据
    ,replace(replace(t1.stockcode,chr(13),''),chr(10),'')  -- 标的股票代码
    ,replace(replace(t1.stockname,chr(13),''),chr(10),'')  -- 标的股票名称
    ,t1.stockamount  -- 总股本（万股）
    ,t1.circulatestockamount  -- 流通股本（万股）
    ,replace(replace(t1.bdindustry,chr(13),''),chr(10),'')  -- 标的公司行业分类
    ,t1.guranteerate  -- 质押率/初始履约保障比例
    ,replace(replace(t1.alarmline,chr(13),''),chr(10),'')  -- 预警线
    ,replace(replace(t1.pcline,chr(13),''),chr(10),'')  -- 平仓线
    ,replace(replace(t1.billtype,chr(13),''),chr(10),'')  -- 票据类型
    ,replace(replace(t1.billkind,chr(13),''),chr(10),'')  -- 票据种类
    ,replace(replace(t1.billno,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.billcurrency,chr(13),''),chr(10),'')  -- 票据币种
    ,t1.billsum  -- 票面金额
    ,replace(replace(t1.billacptdate,chr(13),''),chr(10),'')  -- 出票日
    ,replace(replace(t1.billmaturity,chr(13),''),chr(10),'')  -- 票据到期日
    ,replace(replace(t1.billwriter,chr(13),''),chr(10),'')  -- 出票人
    ,replace(replace(t1.operationtype,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.reinforcechecker,chr(13),''),chr(10),'')  -- 补登复核人
    ,t1.onlineamount  -- 线上额度
    ,t1.businesssumentpart  -- 集团授信额度公司部分
    ,t1.totalsumentpart  -- 集团授信敞口公司部分
    ,t1.businesssumtypart  -- 集团授信额度同业部分
    ,t1.totalsumtypart  -- 集团授信额度同业部分
    ,replace(replace(t1.creditflowtype,chr(13),''),chr(10),'')  -- 授信业务流程类型
    ,replace(replace(t1.batchno,chr(13),''),chr(10),'')  -- 批量新增借据合同关键字段
    ,replace(replace(t1.datatype,chr(13),''),chr(10),'')  -- 批量数据来源（PJ.票据系统供数 LC.理财资管系统供数 ZJ.资金系统供数 ZH.同业综合业务系统供数）
    ,replace(replace(t1.creditarea,chr(13),''),chr(10),'')  -- 授信区域:01 本地 02 省内异地 03 省外异地
    ,replace(replace(t1.isestatefinance,chr(13),''),chr(10),'')  -- 是否涉及房地产融资
    ,replace(replace(t1.isgovernfinance,chr(13),''),chr(10),'')  -- 是否涉及政府类融资
    ,replace(replace(t1.isconsumerfinance,chr(13),''),chr(10),'')  -- 是否为消费服务类融资
    ,replace(replace(t1.isbeltroadfinance,chr(13),''),chr(10),'')  -- 是否为一带一路建设投融资
    ,replace(replace(t1.isgreenfinance,chr(13),''),chr(10),'')  -- 是否为绿色信贷融资
    ,replace(replace(t1.reinforcetype,chr(13),''),chr(10),'')  -- 补登来源 dg-对公 空-同业
    ,replace(replace(t1.rivalid,chr(13),''),chr(10),'')  -- 同业交易对手
    ,replace(replace(t1.rivalname,chr(13),''),chr(10),'')  -- 同业交易对手名称
    ,replace(replace(t1.consigneeid,chr(13),''),chr(10),'')  -- 管理人/主承销商客户编号
    ,replace(replace(t1.consigneename,chr(13),''),chr(10),'')  -- 管理人/主承销商名称
    ,replace(replace(t1.consigneecerttype,chr(13),''),chr(10),'')  -- 管理人/主承销商证件类型
    ,replace(replace(t1.consigneecertid,chr(13),''),chr(10),'')  -- 管理人/主承销商证件号码
    ,replace(replace(t1.outclassifylevel,chr(13),''),chr(10),'')  -- 外部债项评级
    ,replace(replace(t1.outclassifyorg,chr(13),''),chr(10),'')  -- 评级机构
    ,replace(replace(t1.outclassifydate,chr(13),''),chr(10),'')  -- 评级日期
    ,replace(replace(t1.isonlinebusiness,chr(13),''),chr(10),'')  -- 是否线上业务：yes-是 no/空-否
    ,replace(replace(t1.keyno,chr(13),''),chr(10),'')  -- 票据唯一标识
    ,replace(replace(t1.actno,chr(13),''),chr(10),'')  -- 成交单号--资金交易系统批量
    ,replace(replace(t1.registerinotherbank,chr(13),''),chr(10),'')  -- 是否他行代开
    ,replace(replace(t1.issupplychainfinance,chr(13),''),chr(10),'')  -- 是否为供应链金融业务
    ,replace(replace(t1.supplychainfinancetype,chr(13),''),chr(10),'')  -- 供应链金融业务产品分类
    ,replace(replace(t1.issjorcs,chr(13),''),chr(10),'')  -- 是否三旧改造或城市更新项目
    ,replace(replace(t1.islikeloan,chr(13),''),chr(10),'')  -- 是否类信贷
    ,replace(replace(t1.guarantybailaccount,chr(13),''),chr(10),'')  -- 押品保证金账号
    ,replace(replace(t1.guarantybailsubaccount,chr(13),''),chr(10),'')  -- 押品保证金子户号
    ,replace(replace(t1.consignmentloandirect,chr(13),''),chr(10),'')  -- 委托贷款特殊投向
    ,replace(replace(t1.isclassflag,chr(13),''),chr(10),'')  -- 是否分级标志
    ,t1.productlevel  -- 产品分级级别
    ,t1.productcollectmoney  -- 产品募集金额
    ,replace(replace(t1.finalinvestdirecttype,chr(13),''),chr(10),'')  -- 最终投向类型
    ,replace(replace(t1.realestateloantype,chr(13),''),chr(10),'')  -- 房地产贷款类型
    ,replace(replace(t1.chuantoutype,chr(13),''),chr(10),'')  -- 穿透类型
    ,replace(replace(t1.corecompany,chr(13),''),chr(10),'')  -- 核心企业名称
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_business_contract t1    --业务合同信息
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crss_business_contract',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);