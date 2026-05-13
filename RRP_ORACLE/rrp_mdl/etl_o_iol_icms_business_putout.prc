CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BUSINESS_PUTOUT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_BUSINESS_PUTOUT
  *  功能描述：出账信息表出账信息表
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_BUSINESS_PUTOUT
  *  目标表： O_IOL_ICMS_BUSINESS_PUTOUT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
  *             2    20251222  YJY     新增字段
  ************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_BUSINESS_PUTOUT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-出账信息表出账信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT NOLOGGING
    (     SERIALNO                --出账流水号
          ,EXECUTERATE            --执行利率
          ,REPAYCYCLE             --还款周期
          ,PIGEONHOLEDATE         --归档日期
          ,GAINAMOUNT             --递变幅度
          ,PRODUCTID              --产品编号
          ,PURPOSE                --贷款用途(手输描述)
          ,PDGPAYMETHOD           --手续费收取方式
          ,REPAYDATE              --默认还款日
          ,CUSTOMERID             --客户编号
          ,LOANACCOUNTNOSUB       --贷款入账账号(收款账户)子户号
          ,BASERATE               --基准利率
          ,POLICYID               --政策编号
          ,OCCURDATE              --发生日期
          ,PAYMENTTYPE            --支付方式
          ,COMPLETEFLAG           --数据录入完整性标识
          ,INPUTUSERID            --登记人
          ,SUBJECTNO              --科目代码
          ,PUTOUTORGID            --出账机构编号(核心机构)
          ,APPLYTYPE              --申请类型
          ,APPROVESTATUS          --审批状态
          ,UPDATEUSERID           --更新人
          ,CUSTOMERNAME           --客户名称
          ,RATEADJUSTFREQUENCY    --利率调整周期
          ,PUTOUTDATE             --起息日
          ,UPDATEDATE             --更新日期
          ,SEGTERM                --指定还款计算期限
          ,INPUTORGID             --登记机构
          ,FLOWTYPE               --流程类型
          ,EXCHANGETIME           --交易时间
          ,OFFSHEETFLAG           --表内外标志
          ,OVERDUERATEFLOATVALUE  --逾期利率浮动值
          ,PDGSUM                 --手续费金额(元)
          ,JXHJDUEBILLNO          --借新还旧借据号
          ,RATEADJUSTTYPE         --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
          ,PDGACCOUNTNO           --手续费扣费账户
          ,ZFTRANSSERIALNO        --受托支付止付流水号
          ,CONTRACTSERIALNO       --合同编号
          ,INTERESTREPAYCYCLE     --结息方式
          ,EXCHANGESTATE          --交易状态
          ,BPSPREADS              --合同点差
          ,FIXEDRATE              --固定利率
          ,FLOATRANGE             --浮动幅度
          ,OVERDUERATEFLOATTYPE   --逾期利率浮动方式
          ,REMARK                 --备注
          ,RATEMODEL              --利率模式利率模式(1固定利率2浮动利率3组合利率)
          ,RATEFLOATTYPE          --利率浮动类型浮动利率类型
          ,ISLOWRISK              --是否低风险
          ,LENDINGORGID           --贷款机构编号(核心机构)
          ,COMMISSIONPAYSUM       --受托支付金额
          ,CLNO                   --额度编号
          ,SEGRPTAMOUNT           --指定区段拟还本金金额
          ,BAILRATIO              --保证金比例(%)
          ,TRANSSERIALNO          --核心交易流水号
          ,PAYFREQUENCYUNIT       --指定周期单位
          ,PAYFREQUENCY           --指定周期
          ,REPAYTYPE              --还款方式
          ,OVERDUERATE            --逾期执行利率
          ,MIGTFLAG               --迁移标志：crs rcr ilc upl
          ,TERMMONTH              --期限月
          ,MATURITY               --到期日
          ,GAINCYC                --递变周期
          ,LOANACCOUNTNO          --贷款入账账号
          ,OPERATEUSERID          --经办人
          ,CONTRACTSUM            --合同金额
          ,BAILTRANSACCOUNT       --保证金转出账号
          ,OPERATEDATE            --经办日期
          ,CORPORGID              --法人机构编号
          ,CURRENCY               --币种
          ,ARTIFICIALNO           --文本合同编号
          ,BAILSUM                --保证金金额
          ,VOUCHTYPE              --主要担保方式
          ,TRANSDATE              --核心交易日期
          ,SECONDPAYACCOUNT       --第二还款账号
          ,BAILSUBACCOUNT         --保证金子户号
          ,PUTOUTCONTROL          --到日期超批复半年设置，1允许，0禁止
          ,TERMDAY                --期限天
          ,BUSINESSSUM            --本次放款金额
          ,OCCURTYPE              --发生类型
          ,OPERATEORGID           --经办机构
          ,INPUTDATE              --登记日期
          ,BAILACCOUNT            --保证金账号
          ,BAILCURRENCY           --保证金币种
          ,SETTLEMENTACCOUNTNAME  --结算账户(还款账户)名
          ,LOANACCOUNTBANKNAME    --结算账户(还款账户)开户行
          ,BASERATETYPE           --基准利率类型
          ,UPDATEORGID            --更新机构
          ,PDGAMORFG              --手续费是否摊销
          ,LOANACCOUNTORGID       --贷款入账(收款账户)账户开户机构
          ,BELONGDEPT             --所属条线
          ,POLICYVERSIONID        --政策版本编号
          ,SETTLEMENTACCOUNT      --结算账号(还款账户)
          ,LOANUSETYPE            --借款用途类型
          ,LOANACCOUNTNAME        --贷款入账(收款账户)账户名
          ,DUEBILLSERIALNO        --借据号
          ,PDGPAYPERCENT          --手续费率
          ,MIGTOLDVALUE           --迁移数据-参数转换前字段值
          ,REMART                 --计量标记InvestGroup
          ,RATEFLOATRATIOORBP     --利率浮动类型（1-按比例2-按点差）
          ,CASHCONCENACCOUNT      --资金归集账户
          ,ECODEPARTMENTCODE      --国民经济类型-EcoDepartmentCode
          ,ENTSCALE               --企业规模
          ,ISFIRSTLOANS           --是否首次放款-YesNo
          ,ISPENSIONINDUSTRY      --养老产业标识
          ,MIGTCUSTOMERID         --转换前客户号
          ,MIGTBUSINESSTYPE       --转换前产品ID
          ,HANGSEQNO              --挂账账户序列号
          ,RELACONTRACTNO         --占用承兑行额度编号
          ,NEXTSETTLEMENTDATE     --下一结息日
          ,LPRREFERTYPE           --LPR参照方式
          ,OTHCUSTOMERNAME        --对手客户名称
          ,OTHCUSTOMERID          --对手客户编号
          ,SUBPRODUCTNAME         --子产品名称
          ,START_DT               --开始时间
          ,END_DT                 --结束时间
          ,ID_MARK                --增删标志
          ,ETL_TIMESTAMP          --ETL处理时间戳
          ,RENEWALTYPE            --展期类型 --ADD BY YJY 20251222
     )
  SELECT /*+PARALLEL*/
         SERIALNO                --出账流水号
          ,EXECUTERATE            --执行利率
          ,REPAYCYCLE             --还款周期
          ,PIGEONHOLEDATE         --归档日期
          ,GAINAMOUNT             --递变幅度
          ,PRODUCTID              --产品编号
          ,PURPOSE                --贷款用途(手输描述)
          ,PDGPAYMETHOD           --手续费收取方式
          ,REPAYDATE              --默认还款日
          ,CUSTOMERID             --客户编号
          ,LOANACCOUNTNOSUB       --贷款入账账号(收款账户)子户号
          ,BASERATE               --基准利率
          ,POLICYID               --政策编号
          ,OCCURDATE              --发生日期
          ,PAYMENTTYPE            --支付方式
          ,COMPLETEFLAG           --数据录入完整性标识
          ,INPUTUSERID            --登记人
          ,SUBJECTNO              --科目代码
          ,PUTOUTORGID            --出账机构编号(核心机构)
          ,APPLYTYPE              --申请类型
          ,APPROVESTATUS          --审批状态
          ,UPDATEUSERID           --更新人
          ,CUSTOMERNAME           --客户名称
          ,RATEADJUSTFREQUENCY    --利率调整周期
          ,PUTOUTDATE             --起息日
          ,UPDATEDATE             --更新日期
          ,SEGTERM                --指定还款计算期限
          ,INPUTORGID             --登记机构
          ,FLOWTYPE               --流程类型
          ,EXCHANGETIME           --交易时间
          ,OFFSHEETFLAG           --表内外标志
          ,OVERDUERATEFLOATVALUE  --逾期利率浮动值
          ,PDGSUM                 --手续费金额(元)
          ,JXHJDUEBILLNO          --借新还旧借据号
          ,RATEADJUSTTYPE         --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
          ,PDGACCOUNTNO           --手续费扣费账户
          ,ZFTRANSSERIALNO        --受托支付止付流水号
          ,CONTRACTSERIALNO       --合同编号
          ,INTERESTREPAYCYCLE     --结息方式
          ,EXCHANGESTATE          --交易状态
          ,BPSPREADS              --合同点差
          ,FIXEDRATE              --固定利率
          ,FLOATRANGE             --浮动幅度
          ,OVERDUERATEFLOATTYPE   --逾期利率浮动方式
          ,REMARK                 --备注
          ,RATEMODEL              --利率模式利率模式(1固定利率2浮动利率3组合利率)
          ,RATEFLOATTYPE          --利率浮动类型浮动利率类型
          ,ISLOWRISK              --是否低风险
          ,LENDINGORGID           --贷款机构编号(核心机构)
          ,COMMISSIONPAYSUM       --受托支付金额
          ,CLNO                   --额度编号
          ,SEGRPTAMOUNT           --指定区段拟还本金金额
          ,BAILRATIO              --保证金比例(%)
          ,TRANSSERIALNO          --核心交易流水号
          ,PAYFREQUENCYUNIT       --指定周期单位
          ,PAYFREQUENCY           --指定周期
          ,REPAYTYPE              --还款方式
          ,OVERDUERATE            --逾期执行利率
          ,MIGTFLAG               --迁移标志：crs rcr ilc upl
          ,TERMMONTH              --期限月
          ,MATURITY               --到期日
          ,GAINCYC                --递变周期
          ,LOANACCOUNTNO          --贷款入账账号
          ,OPERATEUSERID          --经办人
          ,CONTRACTSUM            --合同金额
          ,BAILTRANSACCOUNT       --保证金转出账号
          ,OPERATEDATE            --经办日期
          ,CORPORGID              --法人机构编号
          ,CURRENCY               --币种
          ,ARTIFICIALNO           --文本合同编号
          ,BAILSUM                --保证金金额
          ,VOUCHTYPE              --主要担保方式
          ,TRANSDATE              --核心交易日期
          ,SECONDPAYACCOUNT       --第二还款账号
          ,BAILSUBACCOUNT         --保证金子户号
          ,PUTOUTCONTROL          --到日期超批复半年设置，1允许，0禁止
          ,TERMDAY                --期限天
          ,BUSINESSSUM            --本次放款金额
          ,OCCURTYPE              --发生类型
          ,OPERATEORGID           --经办机构
          ,INPUTDATE              --登记日期
          ,BAILACCOUNT            --保证金账号
          ,BAILCURRENCY           --保证金币种
          ,SETTLEMENTACCOUNTNAME  --结算账户(还款账户)名
          ,LOANACCOUNTBANKNAME    --结算账户(还款账户)开户行
          ,BASERATETYPE           --基准利率类型
          ,UPDATEORGID            --更新机构
          ,PDGAMORFG              --手续费是否摊销
          ,LOANACCOUNTORGID       --贷款入账(收款账户)账户开户机构
          ,BELONGDEPT             --所属条线
          ,POLICYVERSIONID        --政策版本编号
          ,SETTLEMENTACCOUNT      --结算账号(还款账户)
          ,LOANUSETYPE            --借款用途类型
          ,LOANACCOUNTNAME        --贷款入账(收款账户)账户名
          ,DUEBILLSERIALNO        --借据号
          ,PDGPAYPERCENT          --手续费率
          ,MIGTOLDVALUE           --迁移数据-参数转换前字段值
          ,REMART                 --计量标记InvestGroup
          ,RATEFLOATRATIOORBP     --利率浮动类型（1-按比例2-按点差）
          ,CASHCONCENACCOUNT      --资金归集账户
          ,ECODEPARTMENTCODE      --国民经济类型-EcoDepartmentCode
          ,ENTSCALE               --企业规模
          ,ISFIRSTLOANS           --是否首次放款-YesNo
          ,ISPENSIONINDUSTRY      --养老产业标识
          ,MIGTCUSTOMERID         --转换前客户号
          ,MIGTBUSINESSTYPE       --转换前产品ID
          ,HANGSEQNO              --挂账账户序列号
          ,RELACONTRACTNO         --占用承兑行额度编号
          ,NEXTSETTLEMENTDATE     --下一结息日
          ,LPRREFERTYPE           --LPR参照方式
          ,OTHCUSTOMERNAME        --对手客户名称
          ,OTHCUSTOMERID          --对手客户编号
          ,SUBPRODUCTNAME         --子产品名称
          ,START_DT               --开始时间
          ,END_DT                 --结束时间
          ,ID_MARK                --增删标志
          ,ETL_TIMESTAMP          --ETL处理时间戳
          ,RENEWALTYPE            --展期类型 --ADD BY YJY 20251222
    FROM IOL.V_ICMS_BUSINESS_PUTOUT   --出账信息表出账信息表_视图
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

  END ETL_O_IOL_ICMS_BUSINESS_PUTOUT;
/

