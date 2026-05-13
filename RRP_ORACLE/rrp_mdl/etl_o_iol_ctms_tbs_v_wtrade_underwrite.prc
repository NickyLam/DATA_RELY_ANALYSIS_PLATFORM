CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE
  *  功能描述：承分销
  *  创建日期：20241121
  *  开发人员：于敬艺
  *  来源表：
  *  目标表： O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE
  *  配置表： IOL.V_CTMS_TBS_V_WTRADE_UNDERWRITE
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-承分销';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE NOLOGGING
  (
     DEAL_ID                      --引用表ID                                          
    ,DEAL_NAME                    --引用表名                                         
    ,ASPCLIENT_ID                 --部门编号                                         
    ,PORTFOLIO_ID                 --交易组别                                         
    ,PORTFOLIO_NAME               --交易组别名称                                     
    ,CPTY_NAME                    --交易对手                                         
    ,KEEPFOLDER_ID                --账户ID                                           
    ,KEEPFOLDER_SHORTNAME         --账户名称                                         
    ,REF_NUMBER                   --成交编号                                         
    ,CURRENCY                     --交易币别                                         
    ,TRADE_DATE                   --交易日                                           
    ,VALUE_DATE                   --交割日                                           
    ,SECURITY_CODE                --债券代码                                         
    ,BONDSNAME                    --债券名称                                         
    ,AMOUNT                       --交易面额                                         
    ,SETTLE_AMT                   --成交金额                                         
    ,PRICE                        --承分销价                                         
    ,UW_FEE_RATE                  --承销手续费率                                     
    ,NOTE                         --备注                                             
    ,TRADE_TYPE                   --交易类型                                         
    ,SELL_PORTFOLIO               --转自营投组ID                                     
    ,SELL_PORTFOLIO_NAME          --转自营投组名称                                   
    ,SECURITY_TRADE_NO            --交易的现券表交易单号(SERIAL_NUMBER)              
    ,FEE                          --手续费                                           
    ,TAX_AMT                      --税金                                             
    ,BROKER_AMT                   --佣金                                             
    ,UW_BUY_NO                    --附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
    ,UW_BUY_ID                    --附属交易对应承销买入主交易的单号（DEAL_ID）      
    ,VALID_SOURCE_SN              --审批单号                                         
    ,CANCEL_REASON                --撤销原因                                         
    ,UW_PRICE                     --分销卖出对应承销买入的价格                       
    ,CFETS_FROM                   --是否场内交易                                     
    ,REVIEW_STATUS                --复核状态(前台)                                   
    ,REVIEW_USER_ID               --复核人员ID                                       
    ,REVIEW_USER_NAME             --复核人员名称                                     
    ,REVIEW_TIME                  --复核日期                                         
    ,SERIAL_NUMBER                --交易序号                                         
    ,DEALER_ID                    --交易员ID                                         
    ,LASTMODIFIED                 --最近更新时间                                     
    ,COUNTERPARTY_SEQ             --comstar交易对手序号                              
    ,COUNTERPARTY_SHORT_CNAME     --交易对手                                         
    ,SECURITY_TRADE_ID            --交易的现券表ID号(DEAL_ID)                        
    ,TRADING_FEE                  --交易费用                                         
    ,FEE_RETURN                   --返还手续费                                       
    ,FEE_DATE                     --手续费划付日                                     
    ,RETURN_RATE                  --手续费返还比例                                   
    ,FX_PRICE                     --分销价                                           
    ,FEE_TYPE                     --手续费类型                                       
    ,DN_DEALER                    --本币交易员                                       
    ,DEALER_NAME                  --交易员名称                                       
    ,START_DT                     --开始时间                                         
    ,END_DT                       --结束时间                                         
    ,ID_MARK                      --增删标志                                         
    ,ETL_TIMESTAMP                --ETL处理时间戳                                    

    )
  SELECT /*+PARALLEL*/
          DEAL_ID                      --引用表ID                                          
         ,DEAL_NAME                    --引用表名                                         
         ,ASPCLIENT_ID                 --部门编号                                         
         ,PORTFOLIO_ID                 --交易组别                                         
         ,PORTFOLIO_NAME               --交易组别名称                                     
         ,CPTY_NAME                    --交易对手                                         
         ,KEEPFOLDER_ID                --账户ID                                           
         ,KEEPFOLDER_SHORTNAME         --账户名称                                         
         ,REF_NUMBER                   --成交编号                                         
         ,CURRENCY                     --交易币别                                         
         ,TRADE_DATE                   --交易日                                           
         ,VALUE_DATE                   --交割日                                           
         ,SECURITY_CODE                --债券代码                                         
         ,BONDSNAME                    --债券名称                                         
         ,AMOUNT                       --交易面额                                         
         ,SETTLE_AMT                   --成交金额                                         
         ,PRICE                        --承分销价                                         
         ,UW_FEE_RATE                  --承销手续费率                                     
         ,NOTE                         --备注                                             
         ,TRADE_TYPE                   --交易类型                                         
         ,SELL_PORTFOLIO               --转自营投组ID                                     
         ,SELL_PORTFOLIO_NAME          --转自营投组名称                                   
         ,SECURITY_TRADE_NO            --交易的现券表交易单号(SERIAL_NUMBER)              
         ,FEE                          --手续费                                           
         ,TAX_AMT                      --税金                                             
         ,BROKER_AMT                   --佣金                                             
         ,UW_BUY_NO                    --附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
         ,UW_BUY_ID                    --附属交易对应承销买入主交易的单号（DEAL_ID）      
         ,VALID_SOURCE_SN              --审批单号                                         
         ,CANCEL_REASON                --撤销原因                                         
         ,UW_PRICE                     --分销卖出对应承销买入的价格                       
         ,CFETS_FROM                   --是否场内交易                                     
         ,REVIEW_STATUS                --复核状态(前台)                                   
         ,REVIEW_USER_ID               --复核人员ID                                       
         ,REVIEW_USER_NAME             --复核人员名称                                     
         ,REVIEW_TIME                  --复核日期                                         
         ,SERIAL_NUMBER                --交易序号                                         
         ,DEALER_ID                    --交易员ID                                         
         ,LASTMODIFIED                 --最近更新时间                                     
         ,COUNTERPARTY_SEQ             --comstar交易对手序号                              
         ,COUNTERPARTY_SHORT_CNAME     --交易对手                                         
         ,SECURITY_TRADE_ID            --交易的现券表ID号(DEAL_ID)                        
         ,TRADING_FEE                  --交易费用                                         
         ,FEE_RETURN                   --返还手续费                                       
         ,FEE_DATE                     --手续费划付日                                     
         ,RETURN_RATE                  --手续费返还比例                                   
         ,FX_PRICE                     --分销价                                           
         ,FEE_TYPE                     --手续费类型                                       
         ,DN_DEALER                    --本币交易员                                       
         ,DEALER_NAME                  --交易员名称                                       
         ,START_DT                     --开始时间                                         
         ,END_DT                       --结束时间                                         
         ,ID_MARK                      --增删标志                                         
         ,ETL_TIMESTAMP                --ETL处理时间戳                  
    FROM IOL.V_CTMS_TBS_V_WTRADE_UNDERWRITE   --持仓视图_承分销
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE;
/

