CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_CTMS_TBS_V_IAMDEALS(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_CTMS_TBS_V_IAMDEALS
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_CTMS_TBS_V_IAMDEALS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_CTMS_TBS_V_IAMDEALS'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --

  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_CTMS_TBS_V_IAMDEALS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_V_IAMDEALS NOLOGGING
    ( DEAL_ID,                  --引用表ID
      DEAL_TABLENAME,           --引用表名
      ASPCLIENT_ID,             --部门编号
      SERIAL_NUMBER,            --交易号(标识数据表中记录的唯一组合)
      TRADE_DATE,               --首期交易日
      VALUE_DATE,               --首期交割日
      MATURITY_DATE,            --到期交割日
      BUYORSELL,                --交易方向
      REPO_RATE,                --拆借利率
      AMOUNT,                   --首期结算金额
      MATURITY_AMOUNT,          --到期结算金额
      FEE,                      --首期费用
      TAX_AMT,                  --首期税金
      BROKER_AMT,               --首期佣金
      INTEREST,                 --应计利息
      PORTFOLIO_ID,             --交易组别
      PORTFOLIO_NAME,           --交易组别名称
      KEEPFOLDER_ID,            --账户ID
      KEEPFOLDER_SHORTNAME,     --账户名称
      CPTYS_SHORT_NAME,         --交易对手名
      CPTYS_ID,                 --交易对手ID
      DEALER_ID,                --交易员ID
      DEALER_NAME,              --交易员姓名
      REF_NUMBER,               --成交编号
      CFETS_FROM,               --是否是CFETS交易
      LASTMODIFIED,             --最后修改时间
      DATASYMBOL_ID,            --数据源ID
      REPO_DAYS,                --拆借天数
      IAMDEALS_ID_GRAND,        --原始交易ID
      NOTE,                     --备注
      COUNTERPARTY_TYPE,        --交易类别
      REPO_ID,                  --交易品种
      DN_DEALER,                --本币交易员
      START_DT,                 --开始时间
      END_DT,                   --结束时间
      ID_MARK                   --增删标志
     )
  SELECT /*+PARALLEL*/
         DEAL_ID,                  --引用表ID
         DEAL_TABLENAME,           --引用表名
         ASPCLIENT_ID,             --部门编号
         SERIAL_NUMBER,            --交易号(标识数据表中记录的唯一组合)
         TRADE_DATE,               --首期交易日
         VALUE_DATE,               --首期交割日
         MATURITY_DATE,            --到期交割日
         BUYORSELL,                --交易方向
         REPO_RATE,                --拆借利率
         AMOUNT,                   --首期结算金额
         MATURITY_AMOUNT,          --到期结算金额
         FEE,                      --首期费用
         TAX_AMT,                  --首期税金
         BROKER_AMT,               --首期佣金
         INTEREST,                 --应计利息
         PORTFOLIO_ID,             --交易组别
         PORTFOLIO_NAME,           --交易组别名称
         KEEPFOLDER_ID,            --账户ID
         KEEPFOLDER_SHORTNAME,     --账户名称
         CPTYS_SHORT_NAME,         --交易对手名
         CPTYS_ID,                 --交易对手ID
         DEALER_ID,                --交易员ID
         DEALER_NAME,              --交易员姓名
         REF_NUMBER,               --成交编号
         CFETS_FROM,               --是否是CFETS交易
         LASTMODIFIED,             --最后修改时间
         DATASYMBOL_ID,            --数据源ID
         REPO_DAYS,                --拆借天数
         IAMDEALS_ID_GRAND,        --原始交易ID
         NOTE,                     --备注
         COUNTERPARTY_TYPE,        --交易类别
         REPO_ID,                  --交易品种
         DN_DEALER,                --本币交易员
         START_DT,                 --开始时间
         END_DT,                   --结束时间
         ID_MARK                   --增删标志
    FROM IOL.V_CTMS_TBS_V_IAMDEALS   --拆借交易_视图
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_CTMS_TBS_V_IAMDEALS;
/

