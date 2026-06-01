/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_extend_d
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本 
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_bc_extend_d_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_bc_extend_d');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_bc_extend_d drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_bc_extend_d add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_bc_extend_d(
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag --  
            ,scanstatus -- 
            ,discountrate -- 
            ,tradcontractno -- 
            ,claimterm -- 
            ,agentbankname -- 
            ,agentbankno -- 
            ,issuedbusinessno -- 
            ,confirmbankname -- 
            ,confirmbankid -- 
            ,guaranteetype -- 
            ,guaranteesum -- 
            ,finishterm -- 
            ,proquestionupdatedate -- 
            ,scanuserid -- 
            ,scanusername -- 
            ,bizuniqueno -- 
            ,ratestartmode -- 
            ,compoundintflag -- 
            ,compoundintfloatvalue -- 
            ,compoundintratio -- 
            ,stopintflag -- 
            ,tagcompleteflag -- 
            ,capitalsourcebailtransaccount -- 
            ,capitalsourcebailsum -- 
            ,capitalsourcebustype -- 
            ,stoppayacct -- 
            ,subacctnum -- 
            ,depositsum -- 
            ,xztflag -- 
            ,isrealestateloan -- 是否属于房地产开发贷款
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 合同编号
            ,locfinancefundsource -- 地方融资平台偿债资金来源分类
            ,projectartificialno -- 项目信息文本号
            ,creditincrementtype -- 主要增信方式
            ,isforeign -- 是否境外贷款
            ,isyfconfirmed -- 是否经议付行确认
            ,isventureguaranty -- 是否创业担保贷款
            ,ventureguarantytype -- 创业担保贷款类型
            ,rateexplain -- 利率/费率说明
            ,lctermtype -- 信用证期限类型
            ,qtxkzbh -- 其他许可证编号
            ,graceperiod -- 远期付款期限(天)
            ,lcopertype -- 信用证类型
            ,rivalname -- 交易对手名称
            ,outradio -- 溢短装比例（%）
            ,tradesum -- 贸易合同总金额(元)
            ,careerguaranteeloantype -- 创业担保贷款类型
            ,proposerpaymentscale -- 贴现利息申请人支付比例(%)
            ,putoutorgid -- 放贷机构
            ,farmingloanuse -- 涉农贷款投向
            ,oldlccurrency -- 母证币种
            ,tradecurrency -- 委托存款币种
            ,totalcast -- 货物标的
            ,zfsxlx -- 政府授信类型
            ,xmztz -- 项目总投资
            ,ghxkzbh -- 规划许可证编号
            ,discountratenote -- 贴现利率说明
            ,ifqueryflag -- 是否先贴后查
            ,yffdkje -- 银团已发放贷款金额(元)
            ,billnum -- 汇票数量(张)
            ,lccurrency -- 信用证币种
            ,loanhandlechannel -- 贷款办理渠道
            ,mainproduct -- 经营商品（贸易融资）
            ,repayremark -- 还款说明
            ,iscounterparty -- 是否合格中央交易对手
            ,consigneecerttype -- 管理人/主承销商证件类型
            ,hasoutradio -- 是否存在溢短装的条款
            ,migtflag -- 
            ,mandatedepacctno -- 委托存款帐户
            ,productcollectmoney -- 产品募集金额
            ,thirdpartyaccounts -- 提单号码
            ,beneficiaryname -- 受益人名称
            ,oldlcno -- 母证编号
            ,guarantybailaccount -- 押品转保证金账号
            ,businessinvoicesum -- 商业发票金额
            ,importantloan -- 重点贷款项目
            ,hpxkzbh -- 环评许可证编号
            ,discountsum -- 应收帐款净额(元)
            ,classifyfrequency -- 检查频率
            ,contextinfo -- 交易背景描述
            ,purchaserpayintratio -- 贴现利息买方承担比例(%)
            ,thirdparty1type -- 代付类型
            ,sfgksx -- 是否国开行授信
            ,consigneename -- 管理人/主承销商
            ,consigneecertid -- 管理人/主承销商证件号码
            ,registerinotherbank -- 是否他行代开
            ,securitiestype -- 运输方式
            ,termcd -- 保证金利率档次
            ,tradecontractno -- 贸易合同号
            ,sfgjxzhy -- 是否国家限制行业
            ,isconsumerfinance -- 是否为消费服务类融资
            ,oldlcsum -- 母证金额
            ,bailaccount -- 保证金帐号
            ,loanquality -- 贷款性质
            ,interestrate -- 保证金协议利率
            ,zfsxfs -- 政府授信支持方式
            ,lcsum -- 信用证金额（元）
            ,businessinvoicetype -- 商业发票种类
            ,useproduct -- 使用产品（贸易融资）
            ,issupplychainfinance -- 是否为供应链金融业务
            ,fxfltp -- 保证金利率类型
            ,supplychainfinancetype -- 供应链金融业务产品分类
            ,tdtimes -- 与交易对手成功交易次数
            ,otherarealoan -- 是否异地业务
            ,purchaserregion -- 买方所在地区
            ,mandatecustname -- 委托人
            ,ifagreementflag -- 是否协议付息
            ,iscareerguaranteeloan -- 是否创业担保贷款
            ,beneficiarycountryname -- 受益人所在国家或地区
            ,cargoinfo -- 货物名称
            ,ifgudingcredit -- 是否固定资产授信
            ,qtxkz -- 其他许可证
            ,othercondition -- 其他条件和要求
            ,interestmethod -- 保证金计息方法
            ,isfarming -- 是否涉农
            ,destination1 -- 装运地
            ,costpersontype -- 费用承担人
            ,gksxpz -- 国开授信品种
            ,zbj -- 资本金
            ,lxpw -- 立项批文
            ,bailtransaccount -- 保证金转出帐号
            ,restbalancesum -- 打包成数(%)
            ,businessinvoicecurrency -- 商业发票币种
            ,drawingtype -- 提款方式
            ,platformpaycashsource -- 地方融资平台偿债资金来源分类
            ,lcpaymethod -- 付款方式
            ,discountcusttype -- 贴现申请人种类
            ,loantradesum -- 贷款用途交易金额
            ,pdrifd -- 保证金利率浮动类型
            ,lcno -- 信用证编号
            ,drawingremark -- 提款说明
            ,moneytype -- 委托存款钞汇类别
            ,sfzfsx -- 是否政府授信
            ,toindustryfund -- 是否投向产业基金
            ,isgovernfinance -- 是否涉及政府类融资
            ,farmingloandirect -- 涉农贷款投向
            ,tdstrenth -- 交易对手实力
            ,paymentname -- 付息方
            ,mandatesource -- 委托贷款资金来源
            ,purchasername -- 买方名称
            ,productlevel -- 产品分级级别
            ,kgrq -- 开工日期
            ,noticebankname -- 通知行
            ,directionrs -- 行业投向(征信)
            ,gshy -- 过剩行业
            ,lcquality -- 信用证性质
            ,offerbilldate -- 提供单据日期
            ,financesupportmode -- 贷款财政扶持方式
            ,pwwh -- 批文文号
            ,realestateloantype -- 房地产贷款类型
            ,isyfreceive -- 是否预付应收帐款
            ,corpuspaymethod -- 还款方式
            ,mfeeratio -- 其他费率(‰)
            ,acceptbankname -- 承兑行名称
            ,businessinvoiceinfo -- 商业发票号码
            ,jsydxkzbh -- 建设用地许可证编号
            ,mandatecustid -- 委托人客户
            ,oldlcloadingdate -- 装运日期
            ,isrz -- 是否融资合同
            ,isimportantloan -- 是否重点项目贷款
            ,tdyears -- 与交易对手合作年限
            ,destination2 -- 货物运输目的地
            ,farmingloantype -- 涉农贷款主体类型
            ,pdrifm -- 保证金利率浮动方式
            ,tradingassets -- 交易资产
            ,farmingsubjecttype -- 涉农贷款主体类型
            ,lccdflag -- 远期信用证是否已承兑
            ,lcapplyserialno -- 开证申请书编号
            ,issjorcs -- 是否三旧改造或城市更新项目
            ,bailcurrency -- 保证金币种
            ,duepaymethod -- 应收帐款预付方式
            ,consignmentloandirect -- 委托贷款特殊投向
            ,loantraderatio -- 贷款金额占交易价款比例(%)
            ,discountdrafttype -- 贴现的商业承兑汇票类别
            ,creditattribute -- 合同类型
            ,sgxkzbh -- 施工许可证编号
            ,guarantytype -- 担保/操作模式(担保切分必选项)
            ,fundsource -- 资金来源
            ,factoringtype -- 保理类型
            ,pdrifv -- 保证金浮动值
            ,bondno -- 标的产品编号
            ,lctype -- 信用证种类
            ,financier -- 实际融资人
            ,businessprop -- 放款成数(%)
            ,isdebttoequity -- 是否投向市场化债转股
            ,guaranteehprojecttype -- 保障性安居工程贷款类型LoanPurposeType
            ,landuseno -- 土地使用证编号
            ,landusedate -- 土地使用证日期
            ,landplanpermitno -- 用地规划许可证编号
            ,landplanpermitdate -- 用地规划许可证日期
            ,constructpermitdate -- 施工许可证日期
            ,projectplanpermitdate -- 工程规划许可证日期
            ,buyername -- 购货方名称
            ,sellername -- 销货方名称
            ,tradetransactioncontent -- 贸易交易内容
            ,transferacc -- 应收账款转让方式 码值:TransferBL
            ,isprojectfinancing -- 是否项目融资
            ,jsydxkzrq -- 建设用地许可证日期
            ,projectname -- 项目名称
            ,advancedmanuflag -- 先进制造业标志（0-否，1-是）
            ,cultureindustryflag -- 文化产业标志（0-否，1-是）
            ,industrialrestructuringtype -- 客户产业结构调整类型
            ,onlynewentflag -- 专精特新中小企业标志（0-否，1-是）
            ,onlynewsmallentflag -- 专精特新小巨人企业标志（0-否，1-是）
            ,strategicemergingindustrytype -- 战略性新兴产业类型
            ,transformationandupgradeid -- 工业企业技术改造升级标志（0-否，1-是）
            ,interestrepaycycle -- 结息方式
            ,operationstartdate -- 运营开始日期
            ,isoverssocipproj -- 是否投向政府和社会资本合作（PPP）项目
            ,isnewmechissueloan -- 是否新机制发放贷款
            ,iscoverdbbalance
            ,isadvancedindustry -- 是否高技术服务业贷款
            ,advancedindustryloantype -- 高技术服务业贷款类型
            ,guarantybailsubaccount -- 
            ,limitcoreent -- 
            ,paymentaccount -- 
            ,factoringcredittype -- 
            ,belongitem -- 
            ,lcsumrate -- 
            ,maxpdrifv -- 
            ,isguaranteeloan -- 
            ,collectionnumbers -- 
            ,remittancenumbers -- 
            ,lcloanflag -- 
            ,' ' as scanstatus -- 
            ,0 as discountrate -- 
            ,' ' as tradcontractno -- 
            ,' ' as claimterm -- 
            ,' ' as agentbankname -- 
            ,' ' as agentbankno -- 
            ,' ' as issuedbusinessno -- 
            ,' ' as confirmbankname -- 
            ,' ' as confirmbankid -- 
            ,' ' as guaranteetype -- 
            ,0 as guaranteesum -- 
            ,0 as finishterm -- 
            ,to_date('00010101','yyyymmdd') as proquestionupdatedate -- 
            ,' ' as scanuserid -- 
            ,' ' as scanusername -- 
            ,' ' as bizuniqueno -- 
            ,' ' as ratestartmode -- 
            ,' ' as compoundintflag -- 
            ,0 as compoundintfloatvalue -- 
            ,0 as compoundintratio -- 
            ,' ' as stopintflag -- 
            ,' ' as tagcompleteflag -- 
            ,' ' as capitalsourcebailtransaccount -- 
            ,0 as capitalsourcebailsum -- 
            ,' ' as capitalsourcebustype -- 
            ,' ' as stoppayacct -- 
            ,' ' as subacctnum -- 
            ,0 as depositsum -- 
            ,' ' as xztflag -- 
            ,' ' as isrealestateloan -- 是否属于房地产开发贷款 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bc_extend_d_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
