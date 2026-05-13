CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：中收分户余额历史
  **存储过程名称：    ETL_O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-中收分户余额历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H NOLOGGING 
  (          AGT_ID                            --协议编号
            ,LP_ID                             --法人编号
            ,SOB_ID                            --账套编号
            ,BUS_SYS_ID                        --业务系统编号
            ,DOC_ID                            --单据编号
            ,FIN_DT                            --财务日期
            ,TRAN_FLOW_NUM                     --交易流水号
            ,PROD_ID                           --产品编号
            ,CUST_ID                           --客户编号
            ,ACCT_INSTIT_ID                    --账务机构编号
            ,CURR_CD                           --币种代码
            ,AMORT_START_DT                    --摊销开始日期
            ,AMORT_END_DT                      --摊销结束日期
            ,ACTL_AMORT_START_DT               --实际摊销开始日期
            ,AMORTED_TOT_AMT                   --待摊总金额
            ,THS_TM_AMORT_AMT                  --本次摊销金额
            ,ACM_AMORT_AMT                     --累计摊销金额
            ,INTER_INCOME_AMORT_STATUS_CD      --中收摊销状态代码
            ,SURP_AMORT_AMT                    --剩余摊销金额
            ,AMORT_DAYS                        --摊销天数
            ,AMORT_FREQ_CD                     --摊销频度代码
            ,THS_TM_AMORT_AMT_A_CALC_IDF_CD    --本次摊销金额重新计算标识代码
            ,BUS_ID                            --业务编号
            ,CHARGE_WAY_CD                     --收费方式代码
            ,OVA_FLOW_NUM                      --全局流水号
            ,TRAN_ORG_ID                       --交易机构编号
            ,START_DT                          --开始时间
            ,END_DT                            --结束时间
            ,ID_MARK                           --增删标志
            ,SRC_TABLE_NAME                    --源表名称
            ,JOB_CD                            --任务编码
            ,ETL_TIMESTAMP                     --ETL处理时间戳
    )
    SELECT
             AGT_ID                            --协议编号
            ,LP_ID                             --法人编号
            ,SOB_ID                            --账套编号
            ,BUS_SYS_ID                        --业务系统编号
            ,DOC_ID                            --单据编号
            ,FIN_DT                            --财务日期
            ,TRAN_FLOW_NUM                     --交易流水号
            ,PROD_ID                           --产品编号
            ,CUST_ID                           --客户编号
            ,ACCT_INSTIT_ID                    --账务机构编号
            ,CURR_CD                           --币种代码
            ,AMORT_START_DT                    --摊销开始日期
            ,AMORT_END_DT                      --摊销结束日期
            ,ACTL_AMORT_START_DT               --实际摊销开始日期
            ,AMORTED_TOT_AMT                   --待摊总金额
            ,THS_TM_AMORT_AMT                  --本次摊销金额
            ,ACM_AMORT_AMT                     --累计摊销金额
            ,INTER_INCOME_AMORT_STATUS_CD      --中收摊销状态代码
            ,SURP_AMORT_AMT                    --剩余摊销金额
            ,AMORT_DAYS                        --摊销天数
            ,AMORT_FREQ_CD                     --摊销频度代码
            ,THS_TM_AMORT_AMT_A_CALC_IDF_CD    --本次摊销金额重新计算标识代码
            ,BUS_ID                            --业务编号
            ,CHARGE_WAY_CD                     --收费方式代码
            ,OVA_FLOW_NUM                      --全局流水号
            ,TRAN_ORG_ID                       --交易机构编号
            ,START_DT                          --开始时间
            ,END_DT                            --结束时间
            ,ID_MARK                           --增删标志
            ,SRC_TABLE_NAME                    --源表名称
            ,JOB_CD                            --任务编码
            ,ETL_TIMESTAMP                     --ETL处理时间戳
  FROM IML.V_AGT_INTER_INCOME_SUB_ACCT_BAL_H --视图-中收分户余额历史
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_INTER_INCOME_SUB_ACCT_BAL_H;
/

