CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BUSINESS_FATOU_PUTOUT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_BUSINESS_FATOU_PUTOUT
  *  功能描述：法透出账详情
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_BUSINESS_FATOU_PUTOUT
  *  目标表： O_IOL_ICMS_BUSINESS_FATOU_PUTOUT
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_BUSINESS_FATOU_PUTOUT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BUSINESS_FATOU_PUTOUT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-法透出账详情';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BUSINESS_FATOU_PUTOUT NOLOGGING
    (   SERIALNO                    --流水号
        ,BUSINESSRATE               --正常贷款执行利率
        ,LONTYP                     --透支还款方式
        ,INPUTUSERID                --登记人
        ,UPDATEORGID                --更新机构
        ,ODRPUTOUTDATE              --法透额度起始日
        ,LOANAM                     --透支额度
        ,ODRMATURITY                --法透额度到期日
        ,CONTRACTSUM                --合同金额
        ,OPERATEUSERID              --经办人
        ,OVERDUEFLOAT               --逾期贷款利率浮动
        ,LNCMAM                     --透支承诺费
        ,ODRNEXTMONTH               --法透不跨月
        ,INPUTORGID                 --登记机构
        ,LENDINGORGID               --贷款机构
        ,RATEGENRE                  --新重定价方式
        ,BUSINESSTYPE               --业务品种
        ,FARMINGLOANUSE             --涉农贷款投向
        ,MIGTFLAG                   --
        ,CAREERGUARANTEELOANTYPE    --创业担保贷款类型
        ,RATEFLOAT                  --正常贷款利率浮动
        ,OBLOPT                     --使用余额选择
        ,ISPUTOUT                   --是否出账通过
        ,BUSINESSCURRENCY           --币种
        ,ISCAREERGUARANTEELOAN      --是否创业担保贷款(1是0否)
        ,DIRECTIONNEW               --行业投向17年版（最新）
        ,FARMINGLOANTYPE            --涉农贷款主体类型
        ,TEMPSAVEFLAG               --暂存标志
        ,ACCOUNTNO1                 --透支户账号
        ,BASERATE                   --基准利率
        ,OPERATEDATE                --经办日期
        ,LPRTYPE                    --基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
        ,UPDATEDATE                 --更新日期
        ,UPDATEUSERID               --更新人
        ,CUSTOMERNAME               --透支客户名称
        ,DIRECTIONRS                --行业投向（征信）
        ,ISFARMING                  --是否涉农(1是0否)
        ,CONTRACTSERIALNO           --合同流水号
        ,CUSTOMERID                 --透支客户号
        ,BASERATETYPE               --基准利率类型
        ,BENGDT                     --业务提醒短信发送时机
        ,DAYNUM                     --单笔透支有效天数
        ,OVERDUERATE                --逾期贷款执行利率
        ,OVDRMI                     --起透金额
        ,ODRFREEINTEREST            --法透不跨月免息天数
        ,PLATFORMPAYCASHSOURCE      --地方融资平台偿债资金来源分类
        ,LOANHANDLECHANNEL          --贷款办理渠道
        ,INPUTDATE                  --输入日期
        ,ACCEPTINTTYPE              --结息方式
        ,WHITELIST                  --白名单
        ,SECTIONALINTEREST          --是否靠档计息
        ,FRECHARGER                 --收费频率（按月、按日）码值：refreq
        ,BINLLINGDAY                --收费日
        ,ARTIFICIALNO               --文本合同号
        ,SUBSAC                     --透支账户子户号
        ,MAINTP                     --维护类型
        ,AGRBDT                     --协议法透额度有效期起始日
        ,AGREDT                     --协议法透额度有效期结束日
        ,PURPOSE                    --资金用途
        ,OVTYPE                     --日间隔夜透支类型
        ,FLRTTP                     --利率浮动类型
        ,FEEIVL                     --手续费费率
        ,TYFLAG                     --对公同业法透类型
        ,TZRATE                     --透支利率
        ,AGREEMENTID                --协议编号
        ,STATUS                     --任务状态
        ,FEEDATE                    --手续费收费日
        ,OVERDUEFLOATCYCLE          --利率浮动周期
        ,OVERDUEFLOATMODEL          --利率浮动方式
        ,FEEFREQUENCY               --手续费收费频率
        ,FEEMODEL                   --手续费收取方式
        ,FEERATE                    --手续费收费比率
        ,ISSUPPLYCHAINFINANCE       --是否为供应链金融业务
        ,SUPPLYCHAINFINANCETYPE     --供应链金融业务产品分类
        ,INPUTTIME                  --
        ,ECODEPARTMENTCODE          --
        ,ENTSCALE                   --
        ,CLASSIFYRESULTELEVEN       --
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
        ,ETL_TIMESTAMP              --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        SERIALNO                    --流水号
        ,BUSINESSRATE               --正常贷款执行利率
        ,LONTYP                     --透支还款方式
        ,INPUTUSERID                --登记人
        ,UPDATEORGID                --更新机构
        ,ODRPUTOUTDATE              --法透额度起始日
        ,LOANAM                     --透支额度
        ,ODRMATURITY                --法透额度到期日
        ,CONTRACTSUM                --合同金额
        ,OPERATEUSERID              --经办人
        ,OVERDUEFLOAT               --逾期贷款利率浮动
        ,LNCMAM                     --透支承诺费
        ,ODRNEXTMONTH               --法透不跨月
        ,INPUTORGID                 --登记机构
        ,LENDINGORGID               --贷款机构
        ,RATEGENRE                  --新重定价方式
        ,BUSINESSTYPE               --业务品种
        ,FARMINGLOANUSE             --涉农贷款投向
        ,MIGTFLAG                   --
        ,CAREERGUARANTEELOANTYPE    --创业担保贷款类型
        ,RATEFLOAT                  --正常贷款利率浮动
        ,OBLOPT                     --使用余额选择
        ,ISPUTOUT                   --是否出账通过
        ,BUSINESSCURRENCY           --币种
        ,ISCAREERGUARANTEELOAN      --是否创业担保贷款(1是0否)
        ,DIRECTIONNEW               --行业投向17年版（最新）
        ,FARMINGLOANTYPE            --涉农贷款主体类型
        ,TEMPSAVEFLAG               --暂存标志
        ,ACCOUNTNO1                 --透支户账号
        ,BASERATE                   --基准利率
        ,OPERATEDATE                --经办日期
        ,LPRTYPE                    --基准利率选择LPR的取值方式（1最新LPR2首笔LPR）
        ,UPDATEDATE                 --更新日期
        ,UPDATEUSERID               --更新人
        ,CUSTOMERNAME               --透支客户名称
        ,DIRECTIONRS                --行业投向（征信）
        ,ISFARMING                  --是否涉农(1是0否)
        ,CONTRACTSERIALNO           --合同流水号
        ,CUSTOMERID                 --透支客户号
        ,BASERATETYPE               --基准利率类型
        ,BENGDT                     --业务提醒短信发送时机
        ,DAYNUM                     --单笔透支有效天数
        ,OVERDUERATE                --逾期贷款执行利率
        ,OVDRMI                     --起透金额
        ,ODRFREEINTEREST            --法透不跨月免息天数
        ,PLATFORMPAYCASHSOURCE      --地方融资平台偿债资金来源分类
        ,LOANHANDLECHANNEL          --贷款办理渠道
        ,INPUTDATE                  --输入日期
        ,ACCEPTINTTYPE              --结息方式
        ,WHITELIST                  --白名单
        ,SECTIONALINTEREST          --是否靠档计息
        ,FRECHARGER                 --收费频率（按月、按日）码值：refreq
        ,BINLLINGDAY                --收费日
        ,ARTIFICIALNO               --文本合同号
        ,SUBSAC                     --透支账户子户号
        ,MAINTP                     --维护类型
        ,AGRBDT                     --协议法透额度有效期起始日
        ,AGREDT                     --协议法透额度有效期结束日
        ,PURPOSE                    --资金用途
        ,OVTYPE                     --日间隔夜透支类型
        ,FLRTTP                     --利率浮动类型
        ,FEEIVL                     --手续费费率
        ,TYFLAG                     --对公同业法透类型
        ,TZRATE                     --透支利率
        ,AGREEMENTID                --协议编号
        ,STATUS                     --任务状态
        ,FEEDATE                    --手续费收费日
        ,OVERDUEFLOATCYCLE          --利率浮动周期
        ,OVERDUEFLOATMODEL          --利率浮动方式
        ,FEEFREQUENCY               --手续费收费频率
        ,FEEMODEL                   --手续费收取方式
        ,FEERATE                    --手续费收费比率
        ,ISSUPPLYCHAINFINANCE       --是否为供应链金融业务
        ,SUPPLYCHAINFINANCETYPE     --供应链金融业务产品分类
        ,INPUTTIME                  --
        ,ECODEPARTMENTCODE          --
        ,ENTSCALE                   --
        ,CLASSIFYRESULTELEVEN       --
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
        ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IOL.V_ICMS_BUSINESS_FATOU_PUTOUT   --法透出账详情_视图
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

  END ETL_O_IOL_ICMS_BUSINESS_FATOU_PUTOUT;
/

