CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_TBS_V_BALANCE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_TBS_V_BALANCE
  *  功能描述：资产-余额
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： IOL.V_CTMS_TBS_V_BALANCE
  *  目标表： O_IOL_CTMS_TBS_V_BALANCE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE;   -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_TBS_V_BALANCE'; -- 程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_CTMS_TBS_V_BALANCE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-资产-余额';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE NOLOGGING
  (    BARETRADE_ID         --引用表ID
      ,BARETRADENAME        --引用表名
      ,BALANCE_ID           --引用表2ID
      ,ALTERBALANCE_ID      --引用表3ID
      ,ASPCLIENT_ID         --部门ID
      ,KEEPFOLDER_ID        --账户ID
      ,SETTLEDATE           --结算日期
      ,ASSETTYPE            --资产类别
      ,BUZTYPE              --业务类别
      ,MAJORASSETCODE       --主资产代码
      ,MINORASSETCODE       --次资产代码
      ,HOLDPOSITION         --持有仓位
      ,HOLDFACEAMOUNT       --持有面额
      ,CLEANPRICECOST       --净价成本
      ,INTERESTADJUST       --利息调整
      ,FAIRVALUEALTER       --公允价值变动
      ,INTERESTCOST         --利息成本
      ,DIRTYPRICECOST       --全价成本
      ,IMPAIRMENT           --减值准备
      ,PRICEEARNING         --价差收益
      ,AMORTIZEEARNING      --摊销收益
      ,INTERESTEARNING      --利息收益
      ,FAIRVALUEINCOME      --公允价值变动损益
      ,IMPAIRMENTLOST       --减值损失
      ,TRADEEXPENSE         --交易费用
      ,REALRATE             --实际利率
      ,VALUEDATE            --起息日期
      ,MATURITYDATE         --到期日期
      ,LASTMODIFIED         --最后更新时间
      ,OCCURAMOUNT          --发生金额
      ,BALANCE_ID_PREV      --上一笔的BALANCE_ID
      ,REV_FLAG             --冲账标志
      ,RESERVEVALUE1        --备选值1
      ,RESERVEVALUE2        --备选值2
      ,CHARGEINCOME         --手续费收入
      ,CHARGEEXPENSE        --手续费支出
      ,START_DT             --开始时间
      ,END_DT               --结束时间
      ,ID_MARK              --增删标志
      ,ETL_TIMESTAMP        --ETL处理时间戳
   )
  SELECT /*+PARALLEL*/
       BARETRADE_ID         --引用表ID
      ,BARETRADENAME        --引用表名
      ,BALANCE_ID           --引用表2ID
      ,ALTERBALANCE_ID      --引用表3ID
      ,ASPCLIENT_ID         --部门ID
      ,KEEPFOLDER_ID        --账户ID
      ,SETTLEDATE           --结算日期
      ,ASSETTYPE            --资产类别
      ,BUZTYPE              --业务类别
      ,MAJORASSETCODE       --主资产代码
      ,MINORASSETCODE       --次资产代码
      ,HOLDPOSITION         --持有仓位
      ,HOLDFACEAMOUNT       --持有面额
      ,CLEANPRICECOST       --净价成本
      ,INTERESTADJUST       --利息调整
      ,FAIRVALUEALTER       --公允价值变动
      ,INTERESTCOST         --利息成本
      ,DIRTYPRICECOST       --全价成本
      ,IMPAIRMENT           --减值准备
      ,PRICEEARNING         --价差收益
      ,AMORTIZEEARNING      --摊销收益
      ,INTERESTEARNING      --利息收益
      ,FAIRVALUEINCOME      --公允价值变动损益
      ,IMPAIRMENTLOST       --减值损失
      ,TRADEEXPENSE         --交易费用
      ,REALRATE             --实际利率
      ,VALUEDATE            --起息日期
      ,MATURITYDATE         --到期日期
      ,LASTMODIFIED         --最后更新时间
      ,OCCURAMOUNT          --发生金额
      ,BALANCE_ID_PREV      --上一笔的BALANCE_ID
      ,REV_FLAG             --冲账标志
      ,RESERVEVALUE1        --备选值1
      ,RESERVEVALUE2        --备选值2
      ,CHARGEINCOME         --手续费收入
      ,CHARGEEXPENSE        --手续费支出
      ,START_DT             --开始时间
      ,END_DT               --结束时间
      ,ID_MARK              --增删标志
      ,ETL_TIMESTAMP        --ETL处理时间戳
    FROM IOL.V_CTMS_TBS_V_BALANCE   --资产-余额_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  --MOD BY YJY 20250610

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

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

  END ETL_O_IOL_CTMS_TBS_V_BALANCE;
/

