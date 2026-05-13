CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：明细DUE对象历史表
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS
  **存储过程创建日期：20251010
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251010    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-明细DUE对象历史表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS NOLOGGING 
  (          OBJ_ID              --对象Id
            ,ACCTG_OBJ_ID      --核算对象Id
            ,EXT_SECU_ACCT_ID    --外部券账户
            ,SECU_ACCT_ID      --内部券账户
            ,TSK_ID              --任务Id
            ,BEG_DATE          --开始日期
            ,END_DATE          --结束日期
            ,CAL_START_DATE      --计息开始日期
            ,CAL_END_DATE      --计息结束日期
            ,OPEN_TIME          --开仓时间
            ,UPDATE_TIME      --更新时间
            ,DUE_AI              --应收未收利息
            ,DUE_CP              --应收未收净价成本
            ,DTL_DUE_TYPE      --明细due类型
            ,ETL_DT              --ETL处理日期
            ,ETL_TIMESTAMP      --ETL处理时间戳
    )
    SELECT
             OBJ_ID              --对象Id
            ,ACCTG_OBJ_ID      --核算对象Id
            ,EXT_SECU_ACCT_ID    --外部券账户
            ,SECU_ACCT_ID      --内部券账户
            ,TSK_ID              --任务Id
            ,BEG_DATE          --开始日期
            ,END_DATE          --结束日期
            ,CAL_START_DATE      --计息开始日期
            ,CAL_END_DATE      --计息结束日期
            ,OPEN_TIME          --开仓时间
            ,UPDATE_TIME      --更新时间
            ,DUE_AI              --应收未收利息
            ,DUE_CP              --应收未收净价成本
            ,DTL_DUE_TYPE      --明细due类型
            ,ETL_DT              --ETL处理日期
            ,ETL_TIMESTAMP      --ETL处理时间戳
  FROM IOL.V_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS --视图-明细DUE对象历史表
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS', '', O_ERRCODE);

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

END ETL_O_IOL_IBMS_TTRD_ACCOUNTING_DTLDUE_OBJ_HIS;
/

