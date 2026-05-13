CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PRD_IBANK_CASHFLOW_DTL_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：同业现金流明细历史
  **存储过程名称：    ETL_O_IML_PRD_IBANK_CASHFLOW_DTL_H
  **存储过程创建日期：20251021
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251021    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_PRD_IBANK_CASHFLOW_DTL_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PRD_IBANK_CASHFLOW_DTL_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业现金流明细历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PRD_IBANK_CASHFLOW_DTL_H NOLOGGING 
  (          FIN_INSTM_ID            --金融工具编号
            ,ASSET_TYPE_ID           --资产类型编号
            ,MARKET_TYPE_ID          --市场类型编号
            ,LP_ID                   --法人编号
            ,TASK_GROUP_ID           --任务组编号
            ,CASHFLOW_ID             --现金流编号
            ,INT_RAT_FLOW_ID         --利率流编号
            ,PRICING_ENVIR_ID        --定价环境编号
            ,CFM_CASHFLOW_FLG        --确定现金流标志
            ,CALC_DT                 --计算日期
            ,INT_ACCR_START_DT       --计息开始日期
            ,INT_ACCR_END_DT         --计息结束日期
            ,PAY_DT                  --支付日期
            ,PAY_AMT                 --支付金额
            ,DISCT_RAT               --折现率
            ,PRIC_AMT                --本金金额
            ,PRE_PRIC_AMT            --预测本金金额
            ,INT_AMT                 --利息金额
            ,PRE_INT_AMT             --预测利息金额
            ,PAY_BF_PRIC             --支付前本金
            ,PAY_POST_PRIC           --支付后本金
            ,OPTION_PREMIUM          --期权费
            ,PRE_OPTION_PREMIUM      --预测期权费
            ,CURR_CD                 --币种代码
            ,STL_CURR_CD             --结算币种代码
            ,ACCU_PD                 --累积违约概率
            ,REAL_FIN_INSTM_ID       --真实金融工具编号
            ,SRC_UPDATE_TM           --源更新时间
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,SRC_TABLE_NAME          --源表名称
            ,JOB_CD                  --任务编码
            ,ETL_TIMESTAMP           --ETL处理时间戳
    )
    SELECT
             FIN_INSTM_ID            --金融工具编号
            ,ASSET_TYPE_ID           --资产类型编号
            ,MARKET_TYPE_ID          --市场类型编号
            ,LP_ID                   --法人编号
            ,TASK_GROUP_ID           --任务组编号
            ,CASHFLOW_ID             --现金流编号
            ,INT_RAT_FLOW_ID         --利率流编号
            ,PRICING_ENVIR_ID        --定价环境编号
            ,CFM_CASHFLOW_FLG        --确定现金流标志
            ,CALC_DT                 --计算日期
            ,INT_ACCR_START_DT       --计息开始日期
            ,INT_ACCR_END_DT         --计息结束日期
            ,PAY_DT                  --支付日期
            ,PAY_AMT                 --支付金额
            ,DISCT_RAT               --折现率
            ,PRIC_AMT                --本金金额
            ,PRE_PRIC_AMT            --预测本金金额
            ,INT_AMT                 --利息金额
            ,PRE_INT_AMT             --预测利息金额
            ,PAY_BF_PRIC             --支付前本金
            ,PAY_POST_PRIC           --支付后本金
            ,OPTION_PREMIUM          --期权费
            ,PRE_OPTION_PREMIUM      --预测期权费
            ,CURR_CD                 --币种代码
            ,STL_CURR_CD             --结算币种代码
            ,ACCU_PD                 --累积违约概率
            ,REAL_FIN_INSTM_ID       --真实金融工具编号
            ,SRC_UPDATE_TM           --源更新时间
            ,START_DT                --开始时间
            ,END_DT                  --结束时间
            ,ID_MARK                 --增删标志
            ,SRC_TABLE_NAME          --源表名称
            ,JOB_CD                  --任务编码
            ,ETL_TIMESTAMP           --ETL处理时间戳
  FROM IML.V_PRD_IBANK_CASHFLOW_DTL_H --视图-同业现金流明细历史
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_PRD_IBANK_CASHFLOW_DTL_H', '', O_ERRCODE);

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

END ETL_O_IML_PRD_IBANK_CASHFLOW_DTL_H;
/

