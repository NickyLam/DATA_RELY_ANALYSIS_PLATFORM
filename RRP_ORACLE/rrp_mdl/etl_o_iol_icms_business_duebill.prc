CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BUSINESS_DUEBILL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_BUSINESS_DUEBILL
  *  功能描述：借据信息表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_BUSINESS_DUEBILL
  *  目标表： O_IOL_ICMS_BUSINESS_DUEBILL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_BUSINESS_DUEBILL'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BUSINESS_DUEBILL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地借据信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BUSINESS_DUEBILL NOLOGGING
    (    SERIALNO                       --借据编号
         ,PUTOUTSERIALNO                --关联出账编号
         ,CONTRACTSERIALNO              --关联合同编号
         ,OCCURDATE                     --发生日期
         ,OCCURTYPE                     --贷款发放类型
         ,VOUCHTYPE                     --主担保方式
         ,CUSTOMERID                    --客户编号
         ,CUSTOMERNAME                  --客户名称
         ,PRODUCTID                     --产品编号
         ,CURRENCY                      --币种
         ,BUSINESSSUM                   --放款金额
         ,TERMMONTH                     --期限(月)
         ,TERMDAY                       --期限(天)
         ,PUTOUTDATE                    --发放日期
         ,MATURITY                      --约定到期日
         ,ACTUALMATURITY                --实际到期日
         ,RATEMODEL                     --利率模式
         ,BASERATETYPE                  --基准利率类型
         ,BASERATE                      --基准利率
         ,RATEFLOATTYPE                 --利率浮动方式
         ,EXECUTERATE                   --执行年利率
         ,BAILRATIO                     --保证金比例
         ,BAILSUM                       --保证金金额
         ,BAILACCOUNT                   --保证金账户编号
         ,REPAYTYPE                     --还款方式
         ,PAYMENTTYPE                   --支付方式
         ,REPAYCYCLE                    --还款周期
         ,BALANCE                       --贷款余额
         ,NORMALBALANCE                 --正常余额
         ,OVERDUEBALANCE                --逾期余额
         ,DULLBALANCE                   --呆滞余额
         ,BADBALANCE                    --呆账余额
         ,EXTENDTIMES                   --展期次数
         ,INNERINTERESTBALANCE          --表内欠息余额
         ,OUTERINTERESTBALANCE          --表外欠息余额
         ,CAPITALPENALTYBALANCE         --逾期罚息余额
         ,INTERESTPENALTYBALANCE        --复息余额
         ,OVERDUEDAYS                   --贷款逾期天数
         ,OWNINTERESTDAYS               --欠息天数
         ,ICHANGEDATE                   --欠息更新日期
         ,GRACEPERIOD                   --贷款宽限期
         ,REDUCERESERVESUM              --计提准备金额
         ,PREDICTLOSTSUM                --预测损失金额
         ,FINISHTYPE                    --终结类型
         ,FINISHDATE                    --终结日期
         ,BELONGDEPT                    --所属条线
         ,OFFSHEETFLAG                  --表内外标志
         ,ISLOWRISK                     --是否低风险
         ,BADCONFIRMDATE                --首次认定不良日期
         ,CLASSIFYRESULT                --贷款五级分类
         ,CLASSIFYDATE                  --风险分类日期
         ,ADVANCEFLAG                   --担保代偿/垫款标志
         ,BUSINESSSTATUS                --业务状态
         ,MFORGID                       --主机机构号
         ,RELATIVEDUEBILLNO             --原始借据号
         ,LOANNO                        --贷款卡号
         ,REMARK                        --备注
         ,OPERATEDATE                   --经办日期
         ,OPERATEUSERID                 --业务经办人编号
         ,OPERATEORGID                  --经办机构
         ,INPUTUSERID                   --登记人
         ,INPUTORGID                    --登记机构
         ,INPUTDATE                     --登记日期
         ,UPDATEUSERID                  --更新人
         ,UPDATEORGID                   --更新机构
         ,UPDATEDATE                    --更新日期
         ,CORPORGID                     --法人机构编号
         ,REPAYDATE                     --默认还款日
         ,MFCUSTOMERID                  --核心客户号
         ,SETTLEMENTACCOUNT             --结算账号
         ,OVERDUEDATE                   --逾期日期
         ,OWEINTERESTDATE               --欠息日期
         ,CLASSIFYRESULTELEVEN          --风险分类结果（11级）
         ,OVERDUERATE                   --逾期利率
         ,MAINORGID                     --机构代号(核心记账机构ID)
         ,REMART                        --计量标记-资产三分类
         ,VOUCHTYPE2                    --担保方式2
         ,VOUCHTYPE3                    --担保方式3
         ,RATEADJUSTTYPE                --利率调整方式
         ,RATEADJUSTFREQUENCY           --利率调整周期
         ,FLOATRANGE                    --浮动幅度
         ,SETTLEMENTACCOUNTNAME         --结算账户(还款账户)名
         ,LOANACCOUNTORGID              --贷款入账(出账账户)账户开户机构
         ,OVERDUERATEFLOATTYPE          --逾期利率浮动方式
         ,OVERDUERATEFLOATVALUE         --逾期利率浮动值
         ,PUTOUTORGID                   --出账机构编号(核心机构)
         ,DZHXSTATUS                    --呆账核销状态
         ,CLASSIFYRESULTELEVENDATE      --十一级分类日期
         ,LOANACCOUNTNO                 --贷款入账账号
         ,MIGTFLAG                      --迁移标志：crs rcr ilc upl
         ,LOANSTATUS                    --贷款状态
         ,ZXZFLAG                       --支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
         ,ASSETFLAG                     --是否被认定为问题资产
         ,MIGTCUSTOMERID                --转换前客户号
         ,MIGTBUSINESSTYPE              --转换前产品ID
         ,MIGTOLDVALUE                  --迁移数据-参数转换前字段值
         ,WRNDATE                       --核销日期
         ,REPAYAMT                      --实付金额
         ,PRIFIRSTDUEDATE               --本金未还最早日期
         ,INTFIRSTDUEDATE               --利息未还最早日期
         ,COMPENSATEAMT                 --代偿金额
         ,YJINTAMT                      --应计利息
         ,CSYJINTAMT                    --催收应计利息
         ,YSINTAMT                      --应收欠息
         ,CSINTAMT                      --催收欠息
         ,YJODPAMT                      --应计罚息
         ,CSYJODPAMT                    --催收应计罚息
         ,YSODPAMT                      --应收罚息
         ,CSODPAMT                      --催收罚息
         ,ODPPOSTEDCTDDR                --应收未收罚息
         ,ODIPOSTEDCTDDR                --应收未收复息
         ,YJODIAMT                      --应计复息
         ,WRNPRIAMT                     --核销本金
         ,WRNINTAMT                     --核销利息
         ,WRNRECEIPTAMT                 --核销回收金额
         ,INTDATE                       --下一结息日
         ,ACCOUNTBALANCE                --还款账号余额
         ,ACCOUNTUSERBALANCE            --还款账户可用余额
         ,TERMTYPE                      --期限类型
         ,INSUM                         --累计归还本金
         ,INTERESTINSUM                 --累计归还利息
         ,EXTTRADENO                    --原业务编号
         ,FYJBALAMT                     --非应计余额
         ,PERIODS                       --贷款总期数
         ,REMAIN_PERIODS                --剩余还款期数
         ,LASTCLASSIFYRESULTTEN         --上期十级分类标志
         ,LASTCLASSIFYRESULTTENDATE     --上期十级分类日期
         ,CLASSIFYFIVEHCHANGEDATE       --上一期五级分类变更日期
         ,TENCLAIND                     --十级分类人工干预标志1-人工、2-系统
         ,LASTCLASSIFYRESULT            --上期五级分类结果
         ,LASTCLASSIFYRESULTDATE        --上期五级分类完成日期
         ,NPLTRANSFLAG                  --不良资产转让标识：转入转出
         ,REVERSALFLAG                  --冲正标志：Y-冲正，N-未冲正
         ,RISKTYPE                      --风险业务类型
         ,RATEFLOATRATIOORBP            --利率浮动类型（1-按比例2-按点差）
         ,LOANACCOUNTNAME               --贷款入账(收款账户)账户名
         ,ODIFLAG                       --是否复利
         ,ODPFLAG                       --是否罚息
         ,COMPENSATEPOTYPE              --宽限到期日
         ,GRACESTARTDATE                --宽限起始日
         ,LOANSERIALNO                  --风险监测关联流水号
         ,WHETHERTORESTRUCTURETHELOAN   --是否重组贷款
         ,RESTRUCTURETHELOANTYPE        --重组贷款类型
         ,ISPENSIONINDUSTRY             --养老产业标识
         ,GRACETYPE                     --宽限期类型
         ,GEARPRODFLAG                  --是否靠档计息标识
         ,ABSFLAG                       --资产证券化标志
         ,INTAPPLTYPE                   --利率启用方式
         ,ROLLFREQ                      --利率变更周期
         ,ACCTSPREADRATE                --浮动百分点
         ,INTINDFLAG                    --是否计息
         ,INTDAY                        --存贷结息日期
         ,INTTYPE                       --利率类型
         ,INTERESTBALANCE               --利息余额
         ,PAYMENTSERIALNO               --关联付款申请书编号
         ,ACTUALOVERDUEDAYS             --实际逾期天数（来源核心系统）
         ,NOTIFICATIONSTATUS            --债权通知书状态（客户级债权通知书）01-未确认,02-已确认
         ,PRINCIPALBALANCE              --本金余额(仅用于对账使用)
         ,TYSUMCP                       --同业系统本金余额(仅用于对账使用)
         ,ORIGINALLOANDEADLINE          --原贷款到期日
         ,SETTLEMENTACCOUNTBANK         --结算账号开户行
         ,SETTLEMENTACCOUNTNUM          --结算账户序号
         ,RESTRUCTURETHELOANDATE        --实施重组日期
         ,SHAREAMOUNT                   --分润金额
         ,OVERDUECOUNT                  --逾期次数
         ,FIRSTOVERDUEDATE              --首次逾期日期
         ,CONTOVERDUEDATE               --连续逾期日期
         ,PRIOVERDUEDAYS                --本金逾期天数
         ,INTOVERDUEDAYS                --利息逾期天数
         ,PRIOVERDUEAMT                 --本金逾期金额
         ,INTOVERDUEAMT                 --利息逾期金额
         ,NEXTROLLDATE                  --下一重定价日期
         ,FIRSTROLLDATE                 --首次重定价日期
         ,SUBPRODUCTNAME                --子产品名称
         ,START_DT                      --开始时间
         ,END_DT                        --结束时间
         ,ID_MARK                       --增删标志
         ,ETL_TIMESTAMP                 --ETL处理时间戳
         ,RENEWALTYPE                   --展期类型
     )
  SELECT /*+PARALLEL*/
          SERIALNO                       --借据编号
         ,PUTOUTSERIALNO                --关联出账编号
         ,CONTRACTSERIALNO              --关联合同编号
         ,OCCURDATE                     --发生日期
         ,OCCURTYPE                     --贷款发放类型
         ,VOUCHTYPE                     --主担保方式
         ,CUSTOMERID                    --客户编号
         ,CUSTOMERNAME                  --客户名称
         ,PRODUCTID                     --产品编号
         ,CURRENCY                      --币种
         ,BUSINESSSUM                   --放款金额
         ,TERMMONTH                     --期限(月)
         ,TERMDAY                       --期限(天)
         ,PUTOUTDATE                    --发放日期
         ,MATURITY                      --约定到期日
         ,ACTUALMATURITY                --实际到期日
         ,RATEMODEL                     --利率模式
         ,BASERATETYPE                  --基准利率类型
         ,BASERATE                      --基准利率
         ,RATEFLOATTYPE                 --利率浮动方式
         ,EXECUTERATE                   --执行年利率
         ,BAILRATIO                     --保证金比例
         ,BAILSUM                       --保证金金额
         ,BAILACCOUNT                   --保证金账户编号
         ,REPAYTYPE                     --还款方式
         ,PAYMENTTYPE                   --支付方式
         ,REPAYCYCLE                    --还款周期
         ,BALANCE                       --贷款余额
         ,NORMALBALANCE                 --正常余额
         ,OVERDUEBALANCE                --逾期余额
         ,DULLBALANCE                   --呆滞余额
         ,BADBALANCE                    --呆账余额
         ,EXTENDTIMES                   --展期次数
         ,INNERINTERESTBALANCE          --表内欠息余额
         ,OUTERINTERESTBALANCE          --表外欠息余额
         ,CAPITALPENALTYBALANCE         --逾期罚息余额
         ,INTERESTPENALTYBALANCE        --复息余额
         ,OVERDUEDAYS                   --贷款逾期天数
         ,OWNINTERESTDAYS               --欠息天数
         ,ICHANGEDATE                   --欠息更新日期
         ,GRACEPERIOD                   --贷款宽限期
         ,REDUCERESERVESUM              --计提准备金额
         ,PREDICTLOSTSUM                --预测损失金额
         ,FINISHTYPE                    --终结类型
         ,FINISHDATE                    --终结日期
         ,BELONGDEPT                    --所属条线
         ,OFFSHEETFLAG                  --表内外标志
         ,ISLOWRISK                     --是否低风险
         ,BADCONFIRMDATE                --首次认定不良日期
         ,CLASSIFYRESULT                --贷款五级分类
         ,CLASSIFYDATE                  --风险分类日期
         ,ADVANCEFLAG                   --担保代偿/垫款标志
         ,BUSINESSSTATUS                --业务状态
         ,MFORGID                       --主机机构号
         ,RELATIVEDUEBILLNO             --原始借据号
         ,LOANNO                        --贷款卡号
         ,REMARK                        --备注
         ,OPERATEDATE                   --经办日期
         ,OPERATEUSERID                 --业务经办人编号
         ,OPERATEORGID                  --经办机构
         ,INPUTUSERID                   --登记人
         ,INPUTORGID                    --登记机构
         ,INPUTDATE                     --登记日期
         ,UPDATEUSERID                  --更新人
         ,UPDATEORGID                   --更新机构
         ,UPDATEDATE                    --更新日期
         ,CORPORGID                     --法人机构编号
         ,REPAYDATE                     --默认还款日
         ,MFCUSTOMERID                  --核心客户号
         ,SETTLEMENTACCOUNT             --结算账号
         ,OVERDUEDATE                   --逾期日期
         ,OWEINTERESTDATE               --欠息日期
         ,CLASSIFYRESULTELEVEN          --风险分类结果（11级）
         ,OVERDUERATE                   --逾期利率
         ,MAINORGID                     --机构代号(核心记账机构ID)
         ,REMART                        --计量标记-资产三分类
         ,VOUCHTYPE2                    --担保方式2
         ,VOUCHTYPE3                    --担保方式3
         ,RATEADJUSTTYPE                --利率调整方式
         ,RATEADJUSTFREQUENCY           --利率调整周期
         ,FLOATRANGE                    --浮动幅度
         ,SETTLEMENTACCOUNTNAME         --结算账户(还款账户)名
         ,LOANACCOUNTORGID              --贷款入账(出账账户)账户开户机构
         ,OVERDUERATEFLOATTYPE          --逾期利率浮动方式
         ,OVERDUERATEFLOATVALUE         --逾期利率浮动值
         ,PUTOUTORGID                   --出账机构编号(核心机构)
         ,DZHXSTATUS                    --呆账核销状态
         ,CLASSIFYRESULTELEVENDATE      --十一级分类日期
         ,LOANACCOUNTNO                 --贷款入账账号
         ,MIGTFLAG                      --迁移标志：crs rcr ilc upl
         ,LOANSTATUS                    --贷款状态
         ,ZXZFLAG                       --支小再专用标志（是否已报账） 1 ：是 2：否 3：已失效 1代表做过支小再业务2代表还未做过3代表该借据给在支小再业务中移除了
         ,ASSETFLAG                     --是否被认定为问题资产
         ,MIGTCUSTOMERID                --转换前客户号
         ,MIGTBUSINESSTYPE              --转换前产品ID
         ,MIGTOLDVALUE                  --迁移数据-参数转换前字段值
         ,WRNDATE                       --核销日期
         ,REPAYAMT                      --实付金额
         ,PRIFIRSTDUEDATE               --本金未还最早日期
         ,INTFIRSTDUEDATE               --利息未还最早日期
         ,COMPENSATEAMT                 --代偿金额
         ,YJINTAMT                      --应计利息
         ,CSYJINTAMT                    --催收应计利息
         ,YSINTAMT                      --应收欠息
         ,CSINTAMT                      --催收欠息
         ,YJODPAMT                      --应计罚息
         ,CSYJODPAMT                    --催收应计罚息
         ,YSODPAMT                      --应收罚息
         ,CSODPAMT                      --催收罚息
         ,ODPPOSTEDCTDDR                --应收未收罚息
         ,ODIPOSTEDCTDDR                --应收未收复息
         ,YJODIAMT                      --应计复息
         ,WRNPRIAMT                     --核销本金
         ,WRNINTAMT                     --核销利息
         ,WRNRECEIPTAMT                 --核销回收金额
         ,INTDATE                       --下一结息日
         ,ACCOUNTBALANCE                --还款账号余额
         ,ACCOUNTUSERBALANCE            --还款账户可用余额
         ,TERMTYPE                      --期限类型
         ,INSUM                         --累计归还本金
         ,INTERESTINSUM                 --累计归还利息
         ,EXTTRADENO                    --原业务编号
         ,FYJBALAMT                     --非应计余额
         ,PERIODS                       --贷款总期数
         ,REMAIN_PERIODS                --剩余还款期数
         ,LASTCLASSIFYRESULTTEN         --上期十级分类标志
         ,LASTCLASSIFYRESULTTENDATE     --上期十级分类日期
         ,CLASSIFYFIVEHCHANGEDATE       --上一期五级分类变更日期
         ,TENCLAIND                     --十级分类人工干预标志1-人工、2-系统
         ,LASTCLASSIFYRESULT            --上期五级分类结果
         ,LASTCLASSIFYRESULTDATE        --上期五级分类完成日期
         ,NPLTRANSFLAG                  --不良资产转让标识：转入转出
         ,REVERSALFLAG                  --冲正标志：Y-冲正，N-未冲正
         ,RISKTYPE                      --风险业务类型
         ,RATEFLOATRATIOORBP            --利率浮动类型（1-按比例2-按点差）
         ,LOANACCOUNTNAME               --贷款入账(收款账户)账户名
         ,ODIFLAG                       --是否复利
         ,ODPFLAG                       --是否罚息
         ,COMPENSATEPOTYPE              --宽限到期日
         ,GRACESTARTDATE                --宽限起始日
         ,LOANSERIALNO                  --风险监测关联流水号
         ,WHETHERTORESTRUCTURETHELOAN   --是否重组贷款
         ,RESTRUCTURETHELOANTYPE        --重组贷款类型
         ,ISPENSIONINDUSTRY             --养老产业标识
         ,GRACETYPE                     --宽限期类型
         ,GEARPRODFLAG                  --是否靠档计息标识
         ,ABSFLAG                       --资产证券化标志
         ,INTAPPLTYPE                   --利率启用方式
         ,ROLLFREQ                      --利率变更周期
         ,ACCTSPREADRATE                --浮动百分点
         ,INTINDFLAG                    --是否计息
         ,INTDAY                        --存贷结息日期
         ,INTTYPE                       --利率类型
         ,INTERESTBALANCE               --利息余额
         ,PAYMENTSERIALNO               --关联付款申请书编号
         ,ACTUALOVERDUEDAYS             --实际逾期天数（来源核心系统）
         ,NOTIFICATIONSTATUS            --债权通知书状态（客户级债权通知书）01-未确认,02-已确认
         ,PRINCIPALBALANCE              --本金余额(仅用于对账使用)
         ,TYSUMCP                       --同业系统本金余额(仅用于对账使用)
         ,ORIGINALLOANDEADLINE          --原贷款到期日
         ,SETTLEMENTACCOUNTBANK         --结算账号开户行
         ,SETTLEMENTACCOUNTNUM          --结算账户序号
         ,RESTRUCTURETHELOANDATE        --实施重组日期
         ,SHAREAMOUNT                   --分润金额
         ,OVERDUECOUNT                  --逾期次数
         ,FIRSTOVERDUEDATE              --首次逾期日期
         ,CONTOVERDUEDATE               --连续逾期日期
         ,PRIOVERDUEDAYS                --本金逾期天数
         ,INTOVERDUEDAYS                --利息逾期天数
         ,PRIOVERDUEAMT                 --本金逾期金额
         ,INTOVERDUEAMT                 --利息逾期金额
         ,NEXTROLLDATE                  --下一重定价日期
         ,FIRSTROLLDATE                 --首次重定价日期
         ,SUBPRODUCTNAME                --子产品名称
         ,START_DT                      --开始时间
         ,END_DT                        --结束时间
         ,ID_MARK                       --增删标志
         ,ETL_TIMESTAMP                 --ETL处理时间戳
         ,RENEWALTYPE                   --展期类型
    FROM IOL.V_ICMS_BUSINESS_DUEBILL   --借据信息表
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

  END ETL_O_IOL_ICMS_BUSINESS_DUEBILL;
/

