CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BC_EXTEND_D(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：对公传统信贷业务合同个性化信息
  **存储过程名称：    ETL_O_IOL_ICMS_BC_EXTEND_D
  **存储过程创建日期：20251229
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251229    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_BC_EXTEND_D'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BC_EXTEND_D';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公传统信贷业务合同个性化信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BC_EXTEND_D NOLOGGING 
  (             SERIALNO                        --合同编号
               ,LOCFINANCEFUNDSOURCE            --地方融资平台偿债资金来源分类
               ,PROJECTARTIFICIALNO             --项目信息文本号
               ,CREDITINCREMENTTYPE             --主要增信方式
               ,ISFOREIGN                       --是否境外贷款
               ,ISYFCONFIRMED                   --是否经议付行确认
               ,ISVENTUREGUARANTY               --是否创业担保贷款
               ,VENTUREGUARANTYTYPE             --创业担保贷款类型
               ,RATEEXPLAIN                     --利率/费率说明
               ,LCTERMTYPE                      --信用证期限类型
               ,QTXKZBH                         --其他许可证编号
               ,GRACEPERIOD                     --远期付款期限(天)
               ,LCOPERTYPE                      --信用证类型
               ,RIVALNAME                       --交易对手名称
               ,OUTRADIO                        --溢短装比例（%）
               ,TRADESUM                        --贸易合同总金额(元)
               ,CAREERGUARANTEELOANTYPE         --创业担保贷款类型
               ,PROPOSERPAYMENTSCALE            --贴现利息申请人支付比例(%)
               ,PUTOUTORGID                     --放贷机构
               ,FARMINGLOANUSE                  --涉农贷款投向
               ,OLDLCCURRENCY                   --母证币种
               ,TRADECURRENCY                   --委托存款币种
               ,TOTALCAST                       --货物标的
               ,ZFSXLX                          --政府授信类型
               ,XMZTZ                           --项目总投资
               ,GHXKZBH                         --规划许可证编号
               ,DISCOUNTRATENOTE                --贴现利率说明
               ,IFQUERYFLAG                     --是否先贴后查
               ,YFFDKJE                         --银团已发放贷款金额(元)
               ,BILLNUM                         --汇票数量(张)
               ,LCCURRENCY                      --信用证币种
               ,LOANHANDLECHANNEL               --贷款办理渠道
               ,MAINPRODUCT                     --经营商品（贸易融资）
               ,REPAYREMARK                     --还款说明
               ,ISCOUNTERPARTY                  --是否合格中央交易对手
               ,CONSIGNEECERTTYPE               --管理人/主承销商证件类型
               ,HASOUTRADIO                     --是否存在溢短装的条款
               ,MIGTFLAG                        --迁移标志：crs rcr ilc upl
               ,MANDATEDEPACCTNO                --委托存款帐户
               ,PRODUCTCOLLECTMONEY             --产品募集金额
               ,THIRDPARTYACCOUNTS              --提单号码
               ,BENEFICIARYNAME                 --受益人名称
               ,OLDLCNO                         --母证编号
               ,GUARANTYBAILACCOUNT             --押品转保证金账号
               ,BUSINESSINVOICESUM              --商业发票金额
               ,IMPORTANTLOAN                   --重点贷款项目
               ,HPXKZBH                         --环评许可证编号
               ,DISCOUNTSUM                     --应收帐款净额(元)
               ,CLASSIFYFREQUENCY               --检查频率
               ,CONTEXTINFO                     --交易背景描述
               ,PURCHASERPAYINTRATIO            --贴现利息买方承担比例(%)
               ,THIRDPARTY1TYPE                 --代付类型
               ,SFGKSX                          --是否国开行授信
               ,CONSIGNEENAME                   --管理人/主承销商
               ,CONSIGNEECERTID                 --管理人/主承销商证件号码
               ,REGISTERINOTHERBANK             --是否他行代开
               ,SECURITIESTYPE                  --运输方式
               ,TERMCD                          --保证金利率档次
               ,TRADECONTRACTNO                 --贸易合同号
               ,SFGJXZHY                        --是否国家限制行业
               ,ISCONSUMERFINANCE               --是否为消费服务类融资
               ,OLDLCSUM                        --母证金额
               ,BAILACCOUNT                     --保证金帐号
               ,LOANQUALITY                     --贷款性质
               ,INTERESTRATE                    --保证金协议利率
               ,ZFSXFS                          --政府授信支持方式
               ,LCSUM                           --信用证金额（元）
               ,BUSINESSINVOICETYPE             --商业发票种类
               ,USEPRODUCT                      --使用产品（贸易融资）
               ,ISSUPPLYCHAINFINANCE            --是否为供应链金融业务
               ,FXFLTP                          --保证金利率类型
               ,SUPPLYCHAINFINANCETYPE          --供应链金融业务产品分类
               ,TDTIMES                         --与交易对手成功交易次数
               ,OTHERAREALOAN                   --是否异地业务
               ,PURCHASERREGION                 --买方所在地区
               ,MANDATECUSTNAME                 --委托人
               ,IFAGREEMENTFLAG                 --是否协议付息
               ,ISCAREERGUARANTEELOAN           --是否创业担保贷款
               ,BENEFICIARYCOUNTRYNAME          --受益人所在国家或地区
               ,CARGOINFO                       --货物名称
               ,IFGUDINGCREDIT                  --是否固定资产授信
               ,QTXKZ                           --其他许可证
               ,OTHERCONDITION                  --其他条件和要求
               ,INTERESTMETHOD                  --保证金计息方法
               ,ISFARMING                       --是否涉农
               ,DESTINATION1                    --装运地
               ,COSTPERSONTYPE                  --费用承担人
               ,GKSXPZ                          --国开授信品种
               ,ZBJ                             --资本金
               ,LXPW                            --立项批文
               ,BAILTRANSACCOUNT                --保证金转出帐号
               ,RESTBALANCESUM                  --打包成数(%)
               ,BUSINESSINVOICECURRENCY         --商业发票币种
               ,DRAWINGTYPE                     --提款方式
               ,PLATFORMPAYCASHSOURCE           --地方融资平台偿债资金来源分类
               ,LCPAYMETHOD                     --付款方式
               ,DISCOUNTCUSTTYPE                --贴现申请人种类
               ,LOANTRADESUM                    --贷款用途交易金额
               ,PDRIFD                          --保证金利率浮动类型
               ,LCNO                            --信用证编号
               ,DRAWINGREMARK                   --提款说明
               ,MONEYTYPE                       --委托存款钞汇类别
               ,SFZFSX                          --是否政府授信
               ,TOINDUSTRYFUND                  --是否投向产业基金
               ,ISGOVERNFINANCE                 --是否涉及政府类融资
               ,FARMINGLOANDIRECT               --涉农贷款投向
               ,TDSTRENTH                       --交易对手实力
               ,PAYMENTNAME                     --付息方
               ,MANDATESOURCE                   --委托贷款资金来源
               ,PURCHASERNAME                   --买方名称
               ,PRODUCTLEVEL                    --产品分级级别
               ,KGRQ                            --开工日期
               ,NOTICEBANKNAME                  --通知行
               ,DIRECTIONRS                     --行业投向(征信)
               ,GSHY                            --过剩行业
               ,LCQUALITY                       --信用证性质
               ,OFFERBILLDATE                   --提供单据日期
               ,FINANCESUPPORTMODE              --贷款财政扶持方式
               ,PWWH                            --批文文号
               ,REALESTATELOANTYPE              --房地产贷款类型
               ,ISYFRECEIVE                     --是否预付应收帐款
               ,CORPUSPAYMETHOD                 --还款方式
               ,MFEERATIO                       --其他费率(‰)
               ,ACCEPTBANKNAME                  --承兑行名称
               ,BUSINESSINVOICEINFO             --商业发票号码
               ,JSYDXKZBH                       --建设用地许可证编号
               ,MANDATECUSTID                   --委托人客户
               ,OLDLCLOADINGDATE                --装运日期
               ,ISRZ                            --是否融资合同
               ,ISIMPORTANTLOAN                 --是否重点项目贷款
               ,TDYEARS                         --与交易对手合作年限
               ,DESTINATION2                    --货物运输目的地
               ,FARMINGLOANTYPE                 --涉农贷款主体类型
               ,PDRIFM                          --保证金利率浮动方式
               ,TRADINGASSETS                   --交易资产
               ,FARMINGSUBJECTTYPE              --涉农贷款主体类型
               ,LCCDFLAG                        --远期信用证是否已承兑
               ,LCAPPLYSERIALNO                 --开证申请书编号
               ,ISSJORCS                        --是否三旧改造或城市更新项目
               ,BAILCURRENCY                    --保证金币种
               ,DUEPAYMETHOD                    --应收帐款预付方式
               ,CONSIGNMENTLOANDIRECT           --委托贷款特殊投向
               ,LOANTRADERATIO                  --贷款金额占交易价款比例(%)
               ,DISCOUNTDRAFTTYPE               --贴现的商业承兑汇票类别
               ,CREDITATTRIBUTE                 --合同类型
               ,SGXKZBH                         --施工许可证编号
               ,GUARANTYTYPE                    --担保/操作模式(担保切分必选项)
               ,FUNDSOURCE                      --资金来源
               ,FACTORINGTYPE                   --保理类型
               ,PDRIFV                          --保证金浮动值
               ,BONDNO                          --标的产品编号
               ,LCTYPE                          --信用证种类
               ,FINANCIER                       --实际融资人
               ,BUSINESSPROP                    --放款成数(%)
               ,ISDEBTTOEQUITY                  --是否投向市场化债转股
               ,GUARANTEEHPROJECTTYPE           --保障性安居工程贷款类型LoanPurposeType
               ,LANDUSENO                       --土地使用证编号
               ,LANDUSEDATE                     --土地使用证日期
               ,LANDPLANPERMITNO                --用地规划许可证编号
               ,LANDPLANPERMITDATE              --用地规划许可证日期
               ,CONSTRUCTPERMITDATE             --施工许可证日期
               ,PROJECTPLANPERMITDATE           --工程规划许可证日期
               ,BUYERNAME                       --购货方名称
               ,SELLERNAME                      --销货方名称
               ,TRADETRANSACTIONCONTENT         --贸易交易内容
               ,TRANSFERACC                     --应收账款转让方式 码值:TransferBL
               ,ISPROJECTFINANCING              --是否项目融资
               ,JSYDXKZRQ                       --建设用地许可证日期
               ,PROJECTNAME                     --项目名称
               ,ADVANCEDMANUFLAG                --先进制造业标志（0-否，1-是）
               ,CULTUREINDUSTRYFLAG             --文化产业标志（0-否，1-是）
               ,INDUSTRIALRESTRUCTURINGTYPE     --客户产业结构调整类型
               ,ONLYNEWENTFLAG                  --专精特新中小企业标志（0-否，1-是）
               ,ONLYNEWSMALLENTFLAG             --专精特新小巨人企业标志（0-否，1-是）
               ,STRATEGICEMERGINGINDUSTRYTYPE   --战略性新兴产业类型
               ,TRANSFORMATIONANDUPGRADEID      --工业企业技术改造升级标志（0-否，1-是）
               ,INTERESTREPAYCYCLE              --结息方式
               ,OPERATIONSTARTDATE              --运营开始日期
               ,ISOVERSSOCIPPROJ                --是否投向政府和社会资本合作（PPP）项目
               ,ISNEWMECHISSUELOAN              --是否新机制发放贷款
               ,ISCOVERDBBALANCE                --预测现金流是否覆盖借款余额
               ,ISADVANCEDINDUSTRY              --是否高技术服务业贷款
               ,ADVANCEDINDUSTRYLOANTYPE        --高技术服务业贷款类型
               ,GUARANTYBAILSUBACCOUNT          --
               ,LIMITCOREENT                    --
               ,PAYMENTACCOUNT                  --
               ,FACTORINGCREDITTYPE             --
               ,BELONGITEM                      --
               ,LCSUMRATE                       --
               ,MAXPDRIFV                       --
               ,ISGUARANTEELOAN                 --
               ,COLLECTIONNUMBERS               --
               ,REMITTANCENUMBERS               --
               ,LCLOANFLAG                      --
               ,START_DT                        --开始时间
               ,END_DT                          --结束时间
               ,ID_MARK                         --增删标志
               ,ETL_TIMESTAMP                   --ETL处理时间戳
    )
  SELECT 
            SERIALNO                        --合同编号
               ,LOCFINANCEFUNDSOURCE            --地方融资平台偿债资金来源分类
               ,PROJECTARTIFICIALNO             --项目信息文本号
               ,CREDITINCREMENTTYPE             --主要增信方式
               ,ISFOREIGN                       --是否境外贷款
               ,ISYFCONFIRMED                   --是否经议付行确认
               ,ISVENTUREGUARANTY               --是否创业担保贷款
               ,VENTUREGUARANTYTYPE             --创业担保贷款类型
               ,RATEEXPLAIN                     --利率/费率说明
               ,LCTERMTYPE                      --信用证期限类型
               ,QTXKZBH                         --其他许可证编号
               ,GRACEPERIOD                     --远期付款期限(天)
               ,LCOPERTYPE                      --信用证类型
               ,RIVALNAME                       --交易对手名称
               ,OUTRADIO                        --溢短装比例（%）
               ,TRADESUM                        --贸易合同总金额(元)
               ,CAREERGUARANTEELOANTYPE         --创业担保贷款类型
               ,PROPOSERPAYMENTSCALE            --贴现利息申请人支付比例(%)
               ,PUTOUTORGID                     --放贷机构
               ,FARMINGLOANUSE                  --涉农贷款投向
               ,OLDLCCURRENCY                   --母证币种
               ,TRADECURRENCY                   --委托存款币种
               ,TOTALCAST                       --货物标的
               ,ZFSXLX                          --政府授信类型
               ,XMZTZ                           --项目总投资
               ,GHXKZBH                         --规划许可证编号
               ,DISCOUNTRATENOTE                --贴现利率说明
               ,IFQUERYFLAG                     --是否先贴后查
               ,YFFDKJE                         --银团已发放贷款金额(元)
               ,BILLNUM                         --汇票数量(张)
               ,LCCURRENCY                      --信用证币种
               ,LOANHANDLECHANNEL               --贷款办理渠道
               ,MAINPRODUCT                     --经营商品（贸易融资）
               ,REPAYREMARK                     --还款说明
               ,ISCOUNTERPARTY                  --是否合格中央交易对手
               ,CONSIGNEECERTTYPE               --管理人/主承销商证件类型
               ,HASOUTRADIO                     --是否存在溢短装的条款
               ,MIGTFLAG                        --迁移标志：crs rcr ilc upl
               ,MANDATEDEPACCTNO                --委托存款帐户
               ,PRODUCTCOLLECTMONEY             --产品募集金额
               ,THIRDPARTYACCOUNTS              --提单号码
               ,BENEFICIARYNAME                 --受益人名称
               ,OLDLCNO                         --母证编号
               ,GUARANTYBAILACCOUNT             --押品转保证金账号
               ,BUSINESSINVOICESUM              --商业发票金额
               ,IMPORTANTLOAN                   --重点贷款项目
               ,HPXKZBH                         --环评许可证编号
               ,DISCOUNTSUM                     --应收帐款净额(元)
               ,CLASSIFYFREQUENCY               --检查频率
               ,CONTEXTINFO                     --交易背景描述
               ,PURCHASERPAYINTRATIO            --贴现利息买方承担比例(%)
               ,THIRDPARTY1TYPE                 --代付类型
               ,SFGKSX                          --是否国开行授信
               ,CONSIGNEENAME                   --管理人/主承销商
               ,CONSIGNEECERTID                 --管理人/主承销商证件号码
               ,REGISTERINOTHERBANK             --是否他行代开
               ,SECURITIESTYPE                  --运输方式
               ,TERMCD                          --保证金利率档次
               ,TRADECONTRACTNO                 --贸易合同号
               ,SFGJXZHY                        --是否国家限制行业
               ,ISCONSUMERFINANCE               --是否为消费服务类融资
               ,OLDLCSUM                        --母证金额
               ,BAILACCOUNT                     --保证金帐号
               ,LOANQUALITY                     --贷款性质
               ,INTERESTRATE                    --保证金协议利率
               ,ZFSXFS                          --政府授信支持方式
               ,LCSUM                           --信用证金额（元）
               ,BUSINESSINVOICETYPE             --商业发票种类
               ,USEPRODUCT                      --使用产品（贸易融资）
               ,ISSUPPLYCHAINFINANCE            --是否为供应链金融业务
               ,FXFLTP                          --保证金利率类型
               ,SUPPLYCHAINFINANCETYPE          --供应链金融业务产品分类
               ,TDTIMES                         --与交易对手成功交易次数
               ,OTHERAREALOAN                   --是否异地业务
               ,PURCHASERREGION                 --买方所在地区
               ,MANDATECUSTNAME                 --委托人
               ,IFAGREEMENTFLAG                 --是否协议付息
               ,ISCAREERGUARANTEELOAN           --是否创业担保贷款
               ,BENEFICIARYCOUNTRYNAME          --受益人所在国家或地区
               ,CARGOINFO                       --货物名称
               ,IFGUDINGCREDIT                  --是否固定资产授信
               ,QTXKZ                           --其他许可证
               ,OTHERCONDITION                  --其他条件和要求
               ,INTERESTMETHOD                  --保证金计息方法
               ,ISFARMING                       --是否涉农
               ,DESTINATION1                    --装运地
               ,COSTPERSONTYPE                  --费用承担人
               ,GKSXPZ                          --国开授信品种
               ,ZBJ                             --资本金
               ,LXPW                            --立项批文
               ,BAILTRANSACCOUNT                --保证金转出帐号
               ,RESTBALANCESUM                  --打包成数(%)
               ,BUSINESSINVOICECURRENCY         --商业发票币种
               ,DRAWINGTYPE                     --提款方式
               ,PLATFORMPAYCASHSOURCE           --地方融资平台偿债资金来源分类
               ,LCPAYMETHOD                     --付款方式
               ,DISCOUNTCUSTTYPE                --贴现申请人种类
               ,LOANTRADESUM                    --贷款用途交易金额
               ,PDRIFD                          --保证金利率浮动类型
               ,LCNO                            --信用证编号
               ,DRAWINGREMARK                   --提款说明
               ,MONEYTYPE                       --委托存款钞汇类别
               ,SFZFSX                          --是否政府授信
               ,TOINDUSTRYFUND                  --是否投向产业基金
               ,ISGOVERNFINANCE                 --是否涉及政府类融资
               ,FARMINGLOANDIRECT               --涉农贷款投向
               ,TDSTRENTH                       --交易对手实力
               ,PAYMENTNAME                     --付息方
               ,MANDATESOURCE                   --委托贷款资金来源
               ,PURCHASERNAME                   --买方名称
               ,PRODUCTLEVEL                    --产品分级级别
               ,KGRQ                            --开工日期
               ,NOTICEBANKNAME                  --通知行
               ,DIRECTIONRS                     --行业投向(征信)
               ,GSHY                            --过剩行业
               ,LCQUALITY                       --信用证性质
               ,OFFERBILLDATE                   --提供单据日期
               ,FINANCESUPPORTMODE              --贷款财政扶持方式
               ,PWWH                            --批文文号
               ,REALESTATELOANTYPE              --房地产贷款类型
               ,ISYFRECEIVE                     --是否预付应收帐款
               ,CORPUSPAYMETHOD                 --还款方式
               ,MFEERATIO                       --其他费率(‰)
               ,ACCEPTBANKNAME                  --承兑行名称
               ,BUSINESSINVOICEINFO             --商业发票号码
               ,JSYDXKZBH                       --建设用地许可证编号
               ,MANDATECUSTID                   --委托人客户
               ,OLDLCLOADINGDATE                --装运日期
               ,ISRZ                            --是否融资合同
               ,ISIMPORTANTLOAN                 --是否重点项目贷款
               ,TDYEARS                         --与交易对手合作年限
               ,DESTINATION2                    --货物运输目的地
               ,FARMINGLOANTYPE                 --涉农贷款主体类型
               ,PDRIFM                          --保证金利率浮动方式
               ,TRADINGASSETS                   --交易资产
               ,FARMINGSUBJECTTYPE              --涉农贷款主体类型
               ,LCCDFLAG                        --远期信用证是否已承兑
               ,LCAPPLYSERIALNO                 --开证申请书编号
               ,ISSJORCS                        --是否三旧改造或城市更新项目
               ,BAILCURRENCY                    --保证金币种
               ,DUEPAYMETHOD                    --应收帐款预付方式
               ,CONSIGNMENTLOANDIRECT           --委托贷款特殊投向
               ,LOANTRADERATIO                  --贷款金额占交易价款比例(%)
               ,DISCOUNTDRAFTTYPE               --贴现的商业承兑汇票类别
               ,CREDITATTRIBUTE                 --合同类型
               ,SGXKZBH                         --施工许可证编号
               ,GUARANTYTYPE                    --担保/操作模式(担保切分必选项)
               ,FUNDSOURCE                      --资金来源
               ,FACTORINGTYPE                   --保理类型
               ,PDRIFV                          --保证金浮动值
               ,BONDNO                          --标的产品编号
               ,LCTYPE                          --信用证种类
               ,FINANCIER                       --实际融资人
               ,BUSINESSPROP                    --放款成数(%)
               ,ISDEBTTOEQUITY                  --是否投向市场化债转股
               ,GUARANTEEHPROJECTTYPE           --保障性安居工程贷款类型LoanPurposeType
               ,LANDUSENO                       --土地使用证编号
               ,LANDUSEDATE                     --土地使用证日期
               ,LANDPLANPERMITNO                --用地规划许可证编号
               ,LANDPLANPERMITDATE              --用地规划许可证日期
               ,CONSTRUCTPERMITDATE             --施工许可证日期
               ,PROJECTPLANPERMITDATE           --工程规划许可证日期
               ,BUYERNAME                       --购货方名称
               ,SELLERNAME                      --销货方名称
               ,TRADETRANSACTIONCONTENT         --贸易交易内容
               ,TRANSFERACC                     --应收账款转让方式 码值:TransferBL
               ,ISPROJECTFINANCING              --是否项目融资
               ,JSYDXKZRQ                       --建设用地许可证日期
               ,PROJECTNAME                     --项目名称
               ,ADVANCEDMANUFLAG                --先进制造业标志（0-否，1-是）
               ,CULTUREINDUSTRYFLAG             --文化产业标志（0-否，1-是）
               ,INDUSTRIALRESTRUCTURINGTYPE     --客户产业结构调整类型
               ,ONLYNEWENTFLAG                  --专精特新中小企业标志（0-否，1-是）
               ,ONLYNEWSMALLENTFLAG             --专精特新小巨人企业标志（0-否，1-是）
               ,STRATEGICEMERGINGINDUSTRYTYPE   --战略性新兴产业类型
               ,TRANSFORMATIONANDUPGRADEID      --工业企业技术改造升级标志（0-否，1-是）
               ,INTERESTREPAYCYCLE              --结息方式
               ,OPERATIONSTARTDATE              --运营开始日期
               ,ISOVERSSOCIPPROJ                --是否投向政府和社会资本合作（PPP）项目
               ,ISNEWMECHISSUELOAN              --是否新机制发放贷款
               ,ISCOVERDBBALANCE                --预测现金流是否覆盖借款余额
               ,ISADVANCEDINDUSTRY              --是否高技术服务业贷款
               ,ADVANCEDINDUSTRYLOANTYPE        --高技术服务业贷款类型
               ,GUARANTYBAILSUBACCOUNT          --
               ,LIMITCOREENT                    --
               ,PAYMENTACCOUNT                  --
               ,FACTORINGCREDITTYPE             --
               ,BELONGITEM                      --
               ,LCSUMRATE                       --
               ,MAXPDRIFV                       --
               ,ISGUARANTEELOAN                 --
               ,COLLECTIONNUMBERS               --
               ,REMITTANCENUMBERS               --
               ,LCLOANFLAG                      --
               ,START_DT                        --开始时间
               ,END_DT                          --结束时间
               ,ID_MARK                         --增删标志
               ,ETL_TIMESTAMP                   --ETL处理时间戳
    FROM IOL.V_ICMS_BC_EXTEND_D --视图-对公传统信贷业务合同个性化信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_BC_EXTEND_D', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_BC_EXTEND_D;
/

