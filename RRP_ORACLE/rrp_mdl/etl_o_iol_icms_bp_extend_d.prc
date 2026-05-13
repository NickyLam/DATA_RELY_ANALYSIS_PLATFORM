CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BP_EXTEND_D(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_BP_EXTEND_D
  *  功能描述：对公传统信贷业务出账附表
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_BP_EXTEND_D
  *  目标表： O_IOL_ICMS_BP_EXTEND_D
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_BP_EXTEND_D'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BP_EXTEND_D';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公传统信贷业务出账附表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BP_EXTEND_D NOLOGGING
    (     SERIALNO              --出账流水号
          ,BILLTYPE             --票据类型
          ,CAREFLAG             --是否托管
          ,PAYBANKNAME          --代付行
          ,KEYNO                --票据唯一标识号
          ,TRADESUM1            --贸易融资相关金额1
          ,CHAGGEADDRESS        --地址（福费廷用）
          ,TRADESUM2            --贸易融资相关金额2
          ,RESUMEINTTYPE        --计复息标志
          ,LINKNAME             --联系人（福费廷用）
          ,ABOUTBANKNAME        --受益人、收款人开户行行名
          ,BAILPDRIFM           --保证金利率浮动方式
          ,BFINTG               --是否预收息or先付利息摊销标志
          ,ACCOUNTOPENBANKNAME  --结算帐号开户行名称
          ,BAILMATURITY         --保证金到期日
          ,CAPITALRETURNFLAG    --本金自动归还标志
          ,MIGTFLAG             --迁移标志：crs rcr ilc upl
          ,FBSNUMBER            --信用证编号\业务编号FBS
          ,ASSUREORGID          --担保机构编号(我行分支机构)
          ,INVOICENUMBER        --发票号码
          ,TRADETYPE1           --代收或托收类型
          ,BAILEXCHANGESTATE    --保证金交易状态
          ,CDEXCHANGEDATE       --承兑记账交易日期
          ,ACPTDATE             --出票日
          ,LOANTYPE             --贷款类型
          ,CZFLAG               --冲账标志
          ,PAYMODE              --保函支付方式
          ,ACCEPTORNAME         --承兑人名称
          ,OTHERTXBALANCE       --买方付息金额
          ,ACCOUNTNOCUSTOMER    --结算帐号客户名称
          ,TRADEDATE1           --贸易融资相关日期1
          ,ACCEPTORBANKNAME     --承兑人开户行名称
          ,COMPOUNDINTRATIO     --复利利率
          ,TEXTNO               --总合同文本编号（福费廷用）
          ,INSTRT               --同业代付计提利率（%）
          ,TRADECURRECY2        --贸易融资相关币种2
          ,REPAYMENTPLANFLAG    --信贷发放还款计划标志
          ,CHARGEPHONE          --电话（福费廷用）
          ,TRADETERMMONTH2      --贸易融资相关期限2
          ,RATESTARTMODE        --利率启用方式
          ,AUTOCONTROLFLAG      --自动回收控制开关
          ,LOANTERMTHING        --放款条件是否落实
          ,BAILFXFLTP           --保证金利率类型
          ,GATHERINGNAME        --收票人全称
          ,PRINCIPALACCOUNTNO   --委托存款账号
          ,OPENBANKNAME         --出口信用证开证行名称、开证行ID
          ,ABOUTBANKNAME2       --保函受益人
          ,PREINTTYPE           --预收息标志
          ,LOANTERMCONTROLFLAG  --出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
          ,ACCEPTANCEBANK       --承兑行行号（福费廷）
          ,TRADEDATE2           --贸易融资相关日期2
          ,OTHERDRAWERACCTNO    --买方付息账户号
          ,PRINCIPALSUBACCOUNTNO--委托存款子户号
          ,CONTINUEPAYFLAG      --持续扣款标志
          ,BILLNO               --票据号码
          ,APPROVEORGID         --复核机构
          ,CLIENTACCOUNTNO      --委托人存款账号
          ,REPAYEXCHANGESTATE   --还款计划交易状态
          ,CHARGENAME           --负责人（福费廷用）
          ,COMMERCETYPE         --贸易融资类型
          ,TRADETERMMONTH1      --贸易融资相关期限1
          ,DPRINPAYMETHOD       --代付本金还款方式
          ,LPRTYPE              --LPR参照方式
          ,LOANACCOUNTNOORGNAME --贷款帐号开户行名称
          ,ISRZ                 --是否融资系统出账1是0否
          ,PERIOD               --分期贷款总期数
          ,APPROVEUSERID        --复核人
          ,TRADERATE1           --福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
          ,REPURCHASEFLAG       --是否回购（赎回）
          ,DEPOSITTERMTYPE      --保证金期限类型
          ,LINKPHONE            --联系人手机号（福费廷用）
          ,TERMTYPE             --期限类型
          ,LOANACCOUNTNOCUSTOMER--贷款帐号客户名称
          ,PDGPAYPERCENT2       --手续费率(委托贷款)
          ,BAILINTERESTRATE     --保证金协议利率
          ,CDEXCHANGENO         --承兑记账交易流水号
          ,BUSINESSSUBTYPE      --保函类型
          ,TRADESERIALNO1       --贸易融资业务编号1
          ,TXREGISTER           --票据登记状态
          ,AMLRESULT            --反洗钱评级结果
          ,COMPOUNDINTFLOATVALUE--复利利率浮动比例
          ,PAYSUM               --工本费
          ,NAME1                --汇票承兑人名称
          ,FUNDSOURCE           --资金来源
          ,STOPINTFLAG          --是否停息
          ,LNBAL                --同业代付本金
          ,ACCEPTORBANKNO       --承兑人开户行行号
          ,CONFIRMINGBANK       --保兑行行号（福费廷）
          ,CHARGEFAX            --传真（福费廷用）
          ,PDGSUM2              --手续费金额(元)(承兑汇票)
          ,DEPOSITBASERATE      --存款基准利率
          ,LCSUM                --信用证金额（元）
          ,TRADERATE2           --贸易融资相关比例或利率2
          ,TRADECURRECY1        --贸易融资相关币种1
          ,ISFINANCEGUARANTEE   --是否融资性保函
          ,PUTOUTNO             --出账号
          ,BAILPDRIFD           --保证金利率浮动类型
          ,DEPOSITTERM          --存期期限
          ,BILLCLASS            --票据种类
          ,TRADESUM3            --贸易融资相关金额3
          ,TRADECURRECY3        --贸易融资相关币种3
          ,QUERYABNORMITYTHING  --贷款卡当日查询是否有异常情况
          ,CREDITAGGREEMENT     --使用授信额度协议号
          ,EXCHANGETYPE         --出帐交易代码
          ,BAILTERM             --保证金利率档次
          ,BAILPDRIFV           --保证金浮动值
          ,INTERESTRETURNFLAG   --利息自动归还标志
          ,COMPOUNDINTFLAG      --是否收复息标志
          ,CHARGEPOST           --职务（福费廷用）
          ,ISBANKACCOUNT        --受益人账号是否本行
          ,FIXCYC               --计息天数
          ,ORDINARYORMONTHLY    --普通分期还款标志
          ,UNPAIDBANKNAME       --代付行名称
          ,APPROVEDATE          --复核日期
          ,LINKEMAIL            --联系人电子邮箱（福费廷用）
          ,DISCOUNTSUM          --利息金额
          ,LOANACCOUNTNO2       --贷款帐号
          ,ABNORMITYTHING       --贷款卡异常情况说明
          ,TRADESERIALNO2       --贸易融资业务编号2
          ,BAILINTERESTMETHOD   --保证金计息方法
          ,TRANTP               --手续费收费方式(票据)
          ,POOLFINANCINGFLAG    --是否已签订池融资协议
          ,ISBELONGTERM         --是否靠档计息
          ,CONTRACTSIGNFEE      --签约手续费
          ,ABOUTBANKID          --信用证受益人客户号
          ,ISFIXEDRATE          --利率是否固定
          ,OPENCUSTOMER         --信用证开证人
          ,SELLSTATUS           --卖出状态
          ,OTHERRECEIVEDBANKNO  --对方收款行号
          ,OTHERRECEIVEDNAME    --对方收款账号
          ,OTHERRECEIVEDACCNAME --对方收款户名
          ,OTHERRECEIVEDBANKNAME--对方收款行名称
          ,CREDITBENEFICIARY    --信用证收益人名称
          ,ACTUALLOANACCOUNTNO  --贷款实际入账账号
          ,REPLACEOLDDEPT       --是否置换旧债
          ,ISPROXYDP            --是否代理交单
          ,SQDKZE               --申请银团贷款总额
          ,SOCIALCREDITCODE     --统一社会信用代码
          ,BUYCHANNEL           --买入渠道
          ,ISLINKOUTPAY         --是否联动对外支付
          ,POST                 --附言
          ,PAYINTERESTCUSTOMER  --付息客户
          ,PURCHASERCUSTFLAG    --买方是否为我行客户
          ,OTHERCUSTOMERID      --买方客户号
          ,OTHERCUSTOMERNAME    --买方客户名称
          ,FINALMERGER          --是否末期合并：0否，1是
          ,LCSUMRATE            --信用证金额上浮比例
          ,LINKCHARGEINTFLAG    --是否联动扣收利息
          ,ISACTUALDDAMTFLAG    --是否按实际放款金额冻结标志
          ,MAXPDRIFV            --保证金浮动上限
          ,ISMERGEENTRPAYMENT   --是否合并受托支付
          ,OWNFUNDS             --自有资金
          ,OWNFUNDSACCTNO       --自有资金账号
          ,OWNFUNDSACCTNAME     --自有资金账户名称
          ,OWNFUNDSACCTCCY      --自有资金账户币种
          ,ARRIVALNUMBERS       --到单编号
          ,CLAIMAMOUNT          --索偿金额
          ,BUSINESSAMOUNT       --业务金额
          ,MARKETFLOWS          --市场流转次数，含到我行
          ,SERVICECONTENT       --货物/服务品种
          ,SCANSTATUS           --扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
          ,PRICEORDERNO         --定价单号
          ,PRICEAPPROVESTATUS   --定价单审批状态
          ,PRICEENDDATE         --定价单生效截止日
          ,PLEDGETYPE           --质押类型
          ,SUBMITPUTOUTCENTERTIME  --提交放款中心时间
          ,ISCENTRALIZEDACCOUNT    --是否集中出账
          ,ISSUEDBUSINESSNO     --代开保函业务编号
          ,BHSTARTDATE          --保函生效日期
          ,BHMATURITY           --保函失效日期
          ,GUARANTEEBUSINESSNO  --保函业务编号
          ,GUARANTEESUM         --保函金额
          ,ISSUEDATE            --开立日期
          ,GUARANTEEPUTOUTSTATUS  --保函信息状态(code:guaranteeputoutstatus)
          ,ISREPLENISHMENT     --是否补录完成
          ,SCANUSERID          --扫描人
          ,SCANUSERNAME        --扫描人名称
          ,BIZUNIQUENO         --业务唯一流水号（票据/供应链）
          ,ISXDAPPROVE         --是否信贷审批（票据/供应链推送流程）
          ,ISIGNORERESULT      --是否忽略不动产查册策略结果
          ,START_DT            --开始时间
          ,END_DT              --结束时间
          ,ID_MARK             --增删标志
          ,ETL_TIMESTAMP       --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
         SERIALNO              --出账流水号
          ,BILLTYPE             --票据类型
          ,CAREFLAG             --是否托管
          ,PAYBANKNAME          --代付行
          ,KEYNO                --票据唯一标识号
          ,TRADESUM1            --贸易融资相关金额1
          ,CHAGGEADDRESS        --地址（福费廷用）
          ,TRADESUM2            --贸易融资相关金额2
          ,RESUMEINTTYPE        --计复息标志
          ,LINKNAME             --联系人（福费廷用）
          ,ABOUTBANKNAME        --受益人、收款人开户行行名
          ,BAILPDRIFM           --保证金利率浮动方式
          ,BFINTG               --是否预收息or先付利息摊销标志
          ,ACCOUNTOPENBANKNAME  --结算帐号开户行名称
          ,BAILMATURITY         --保证金到期日
          ,CAPITALRETURNFLAG    --本金自动归还标志
          ,MIGTFLAG             --迁移标志：crs rcr ilc upl
          ,FBSNUMBER            --信用证编号\业务编号FBS
          ,ASSUREORGID          --担保机构编号(我行分支机构)
          ,INVOICENUMBER        --发票号码
          ,TRADETYPE1           --代收或托收类型
          ,BAILEXCHANGESTATE    --保证金交易状态
          ,CDEXCHANGEDATE       --承兑记账交易日期
          ,ACPTDATE             --出票日
          ,LOANTYPE             --贷款类型
          ,CZFLAG               --冲账标志
          ,PAYMODE              --保函支付方式
          ,ACCEPTORNAME         --承兑人名称
          ,OTHERTXBALANCE       --买方付息金额
          ,ACCOUNTNOCUSTOMER    --结算帐号客户名称
          ,TRADEDATE1           --贸易融资相关日期1
          ,ACCEPTORBANKNAME     --承兑人开户行名称
          ,COMPOUNDINTRATIO     --复利利率
          ,TEXTNO               --总合同文本编号（福费廷用）
          ,INSTRT               --同业代付计提利率（%）
          ,TRADECURRECY2        --贸易融资相关币种2
          ,REPAYMENTPLANFLAG    --信贷发放还款计划标志
          ,CHARGEPHONE          --电话（福费廷用）
          ,TRADETERMMONTH2      --贸易融资相关期限2
          ,RATESTARTMODE        --利率启用方式
          ,AUTOCONTROLFLAG      --自动回收控制开关
          ,LOANTERMTHING        --放款条件是否落实
          ,BAILFXFLTP           --保证金利率类型
          ,GATHERINGNAME        --收票人全称
          ,PRINCIPALACCOUNTNO   --委托存款账号
          ,OPENBANKNAME         --出口信用证开证行名称、开证行ID
          ,ABOUTBANKNAME2       --保函受益人
          ,PREINTTYPE           --预收息标志
          ,LOANTERMCONTROLFLAG  --出账详情页面贷款类型和期限是否进行系统校验标识,1进行校验,0或者空值不进行校验
          ,ACCEPTANCEBANK       --承兑行行号（福费廷）
          ,TRADEDATE2           --贸易融资相关日期2
          ,OTHERDRAWERACCTNO    --买方付息账户号
          ,PRINCIPALSUBACCOUNTNO--委托存款子户号
          ,CONTINUEPAYFLAG      --持续扣款标志
          ,BILLNO               --票据号码
          ,APPROVEORGID         --复核机构
          ,CLIENTACCOUNTNO      --委托人存款账号
          ,REPAYEXCHANGESTATE   --还款计划交易状态
          ,CHARGENAME           --负责人（福费廷用）
          ,COMMERCETYPE         --贸易融资类型
          ,TRADETERMMONTH1      --贸易融资相关期限1
          ,DPRINPAYMETHOD       --代付本金还款方式
          ,LPRTYPE              --LPR参照方式
          ,LOANACCOUNTNOORGNAME --贷款帐号开户行名称
          ,ISRZ                 --是否融资系统出账1是0否
          ,PERIOD               --分期贷款总期数
          ,APPROVEUSERID        --复核人
          ,TRADERATE1           --福费廷年贴现率、出口退税帐户托管融资业务退税比例、短期出口信用保险项下押汇业务押汇利率、国际贸易融资项下同业代付代付利率（代付行价格）
          ,REPURCHASEFLAG       --是否回购（赎回）
          ,DEPOSITTERMTYPE      --保证金期限类型
          ,LINKPHONE            --联系人手机号（福费廷用）
          ,TERMTYPE             --期限类型
          ,LOANACCOUNTNOCUSTOMER--贷款帐号客户名称
          ,PDGPAYPERCENT2       --手续费率(委托贷款)
          ,BAILINTERESTRATE     --保证金协议利率
          ,CDEXCHANGENO         --承兑记账交易流水号
          ,BUSINESSSUBTYPE      --保函类型
          ,TRADESERIALNO1       --贸易融资业务编号1
          ,TXREGISTER           --票据登记状态
          ,AMLRESULT            --反洗钱评级结果
          ,COMPOUNDINTFLOATVALUE--复利利率浮动比例
          ,PAYSUM               --工本费
          ,NAME1                --汇票承兑人名称
          ,FUNDSOURCE           --资金来源
          ,STOPINTFLAG          --是否停息
          ,LNBAL                --同业代付本金
          ,ACCEPTORBANKNO       --承兑人开户行行号
          ,CONFIRMINGBANK       --保兑行行号（福费廷）
          ,CHARGEFAX            --传真（福费廷用）
          ,PDGSUM2              --手续费金额(元)(承兑汇票)
          ,DEPOSITBASERATE      --存款基准利率
          ,LCSUM                --信用证金额（元）
          ,TRADERATE2           --贸易融资相关比例或利率2
          ,TRADECURRECY1        --贸易融资相关币种1
          ,ISFINANCEGUARANTEE   --是否融资性保函
          ,PUTOUTNO             --出账号
          ,BAILPDRIFD           --保证金利率浮动类型
          ,DEPOSITTERM          --存期期限
          ,BILLCLASS            --票据种类
          ,TRADESUM3            --贸易融资相关金额3
          ,TRADECURRECY3        --贸易融资相关币种3
          ,QUERYABNORMITYTHING  --贷款卡当日查询是否有异常情况
          ,CREDITAGGREEMENT     --使用授信额度协议号
          ,EXCHANGETYPE         --出帐交易代码
          ,BAILTERM             --保证金利率档次
          ,BAILPDRIFV           --保证金浮动值
          ,INTERESTRETURNFLAG   --利息自动归还标志
          ,COMPOUNDINTFLAG      --是否收复息标志
          ,CHARGEPOST           --职务（福费廷用）
          ,ISBANKACCOUNT        --受益人账号是否本行
          ,FIXCYC               --计息天数
          ,ORDINARYORMONTHLY    --普通分期还款标志
          ,UNPAIDBANKNAME       --代付行名称
          ,APPROVEDATE          --复核日期
          ,LINKEMAIL            --联系人电子邮箱（福费廷用）
          ,DISCOUNTSUM          --利息金额
          ,LOANACCOUNTNO2       --贷款帐号
          ,ABNORMITYTHING       --贷款卡异常情况说明
          ,TRADESERIALNO2       --贸易融资业务编号2
          ,BAILINTERESTMETHOD   --保证金计息方法
          ,TRANTP               --手续费收费方式(票据)
          ,POOLFINANCINGFLAG    --是否已签订池融资协议
          ,ISBELONGTERM         --是否靠档计息
          ,CONTRACTSIGNFEE      --签约手续费
          ,ABOUTBANKID          --信用证受益人客户号
          ,ISFIXEDRATE          --利率是否固定
          ,OPENCUSTOMER         --信用证开证人
          ,SELLSTATUS           --卖出状态
          ,OTHERRECEIVEDBANKNO  --对方收款行号
          ,OTHERRECEIVEDNAME    --对方收款账号
          ,OTHERRECEIVEDACCNAME --对方收款户名
          ,OTHERRECEIVEDBANKNAME--对方收款行名称
          ,CREDITBENEFICIARY    --信用证收益人名称
          ,ACTUALLOANACCOUNTNO  --贷款实际入账账号
          ,REPLACEOLDDEPT       --是否置换旧债
          ,ISPROXYDP            --是否代理交单
          ,SQDKZE               --申请银团贷款总额
          ,SOCIALCREDITCODE     --统一社会信用代码
          ,BUYCHANNEL           --买入渠道
          ,ISLINKOUTPAY         --是否联动对外支付
          ,POST                 --附言
          ,PAYINTERESTCUSTOMER  --付息客户
          ,PURCHASERCUSTFLAG    --买方是否为我行客户
          ,OTHERCUSTOMERID      --买方客户号
          ,OTHERCUSTOMERNAME    --买方客户名称
          ,FINALMERGER          --是否末期合并：0否，1是
          ,LCSUMRATE            --信用证金额上浮比例
          ,LINKCHARGEINTFLAG    --是否联动扣收利息
          ,ISACTUALDDAMTFLAG    --是否按实际放款金额冻结标志
          ,MAXPDRIFV            --保证金浮动上限
          ,ISMERGEENTRPAYMENT   --是否合并受托支付
          ,OWNFUNDS             --自有资金
          ,OWNFUNDSACCTNO       --自有资金账号
          ,OWNFUNDSACCTNAME     --自有资金账户名称
          ,OWNFUNDSACCTCCY      --自有资金账户币种
          ,ARRIVALNUMBERS       --到单编号
          ,CLAIMAMOUNT          --索偿金额
          ,BUSINESSAMOUNT       --业务金额
          ,MARKETFLOWS          --市场流转次数，含到我行
          ,SERVICECONTENT       --货物/服务品种
          ,SCANSTATUS           --扫描任务状态(0-扫描中、1-扫描完成、2-撤销)
          ,PRICEORDERNO         --定价单号
          ,PRICEAPPROVESTATUS   --定价单审批状态
          ,PRICEENDDATE         --定价单生效截止日
          ,PLEDGETYPE           --质押类型
          ,SUBMITPUTOUTCENTERTIME  --提交放款中心时间
          ,ISCENTRALIZEDACCOUNT    --是否集中出账
          ,ISSUEDBUSINESSNO     --代开保函业务编号
          ,BHSTARTDATE          --保函生效日期
          ,BHMATURITY           --保函失效日期
          ,GUARANTEEBUSINESSNO  --保函业务编号
          ,GUARANTEESUM         --保函金额
          ,ISSUEDATE            --开立日期
          ,GUARANTEEPUTOUTSTATUS  --保函信息状态(code:guaranteeputoutstatus)
          ,ISREPLENISHMENT     --是否补录完成
          ,SCANUSERID          --扫描人
          ,SCANUSERNAME        --扫描人名称
          ,BIZUNIQUENO         --业务唯一流水号（票据/供应链）
          ,ISXDAPPROVE         --是否信贷审批（票据/供应链推送流程）
          ,ISIGNORERESULT      --是否忽略不动产查册策略结果
          ,START_DT            --开始时间
          ,END_DT              --结束时间
          ,ID_MARK             --增删标志
          ,ETL_TIMESTAMP       --ETL处理时间戳
    FROM IOL.V_ICMS_BP_EXTEND_D   --对公传统信贷业务出账附表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_ICMS_BP_EXTEND_D;
/

