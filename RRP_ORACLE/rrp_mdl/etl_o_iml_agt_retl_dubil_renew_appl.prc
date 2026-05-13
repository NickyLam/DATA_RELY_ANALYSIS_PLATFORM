CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_RETL_DUBIL_RENEW_APPL(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：零售借据展期申请
  **存储过程名称：    ETL_O_IML_AGT_RETL_DUBIL_RENEW_APPL
  **存储过程创建日期：20250604
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250604    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_RETL_DUBIL_RENEW_APPL'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_RETL_DUBIL_RENEW_APPL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售借据展期申请';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_RETL_DUBIL_RENEW_APPL NOLOGGING 
  (         APPL_ID                --申请编号
           ,LP_ID                  --法人编号
           ,RENEW_FLOW_NUM         --展期流水号
           ,RELA_DUBIL_ID          --关联借据编号
           ,OBJ_ID                 --对象编号
           ,OBJ_TYPE_NAME          --对象类型名称
           ,BASE_RAT_TYPE_CD       --基准利率类型代码
           ,RENEW_SUCS_FLG         --展期成功标志
           ,RENEW_CONT_ID          --展期合同编号
           ,REPAY_WAY_CD           --还款方式代码
           ,REPAY_PED_CD           --还款周期代码
           ,EFFECT_DT              --生效日期
           ,EXP_DT                 --到期日期
           ,MON_TENOR              --月期限
           ,BASE_INT_RAT           --基准利率
           ,INT_RAT_FLOAT_POINT    --利率浮动点数
           ,INT_RAT_FLOAT_WAY_CD   --利率浮动方式代码
           ,LOAN_EXEC_YEAR_INT_RAT --执行年利率
           ,OVDUE_INT_RAT_FLOAT_WAY_CD      --逾期利率浮动方式代码
           ,OVDUE_INT_RAT_FL_RT    --逾期利率浮动比例
           ,INT_RAT_ADJ_WAY_CD     --利率调整方式代码
           ,INT_RAT_ADJ_PED_CD     --利率调整周期代码
           ,REGROUP_LOAN_FLG       --重组贷款标志
           ,ALDY_CALL_CORE_INTFC_FLG     --已调用核心接口标志
           ,PRECON_ID              --预约编号
           ,BLON_LOAN_AMORT_DT     --气球贷摊销日期
           ,BLON_LOAN_INCRS_AMT    --气球贷递增金额
           ,BLON_LOAN_INCRS_RATIO  --气球贷递增比例
           ,REMARK                 --备注
           ,INIT_CONT_EXP_DT       --原合同到期日期
           ,INIT_REPAY_WAY_CD      --原还款方式代码
           ,INIT_REPAY_PED_CD      --原还款周期代码
           ,INIT_INT_RAT_FLOAT_WAY_CD      --原利率浮动方式代码
           ,INIT_INT_RAT_ADJ_WAY_CD        --原利率调整方式代码
           ,INIT_INT_RAT_FLOAT_POINT       --原利率浮动点数
           ,INIT_EXEC_YEAR_INT_RAT         --原执行年利率
           ,START_DT                --开始时间
           ,END_DT                  --结束时间
           ,ID_MARK                 --增删标志
           ,SRC_TABLE_NAME          --源表名称
           ,JOB_CD                  --任务编码
           ,ETL_TIMESTAMP           --ETL处理时间戳
    )
    SELECT
           APPL_ID                --申请编号
           ,LP_ID                  --法人编号
           ,RENEW_FLOW_NUM         --展期流水号
           ,RELA_DUBIL_ID          --关联借据编号
           ,OBJ_ID                 --对象编号
           ,OBJ_TYPE_NAME          --对象类型名称
           ,BASE_RAT_TYPE_CD       --基准利率类型代码
           ,RENEW_SUCS_FLG         --展期成功标志
           ,RENEW_CONT_ID          --展期合同编号
           ,REPAY_WAY_CD           --还款方式代码
           ,REPAY_PED_CD           --还款周期代码
           ,EFFECT_DT              --生效日期
           ,EXP_DT                 --到期日期
           ,MON_TENOR              --月期限
           ,BASE_INT_RAT           --基准利率
           ,INT_RAT_FLOAT_POINT    --利率浮动点数
           ,INT_RAT_FLOAT_WAY_CD   --利率浮动方式代码
           ,LOAN_EXEC_YEAR_INT_RAT --执行年利率
           ,OVDUE_INT_RAT_FLOAT_WAY_CD      --逾期利率浮动方式代码
           ,OVDUE_INT_RAT_FL_RT    --逾期利率浮动比例
           ,INT_RAT_ADJ_WAY_CD     --利率调整方式代码
           ,INT_RAT_ADJ_PED_CD     --利率调整周期代码
           ,REGROUP_LOAN_FLG       --重组贷款标志
           ,ALDY_CALL_CORE_INTFC_FLG     --已调用核心接口标志
           ,PRECON_ID              --预约编号
           ,BLON_LOAN_AMORT_DT     --气球贷摊销日期
           ,BLON_LOAN_INCRS_AMT    --气球贷递增金额
           ,BLON_LOAN_INCRS_RATIO  --气球贷递增比例
           ,REMARK                 --备注
           ,INIT_CONT_EXP_DT       --原合同到期日期
           ,INIT_REPAY_WAY_CD      --原还款方式代码
           ,INIT_REPAY_PED_CD      --原还款周期代码
           ,INIT_INT_RAT_FLOAT_WAY_CD      --原利率浮动方式代码
           ,INIT_INT_RAT_ADJ_WAY_CD        --原利率调整方式代码
           ,INIT_INT_RAT_FLOAT_POINT       --原利率浮动点数
           ,INIT_EXEC_YEAR_INT_RAT         --原执行年利率
           ,START_DT                --开始时间
           ,END_DT                  --结束时间
           ,ID_MARK                 --增删标志
           ,SRC_TABLE_NAME          --源表名称
           ,JOB_CD                  --任务编码
           ,ETL_TIMESTAMP           --ETL处理时间戳
  FROM IML.V_AGT_RETL_DUBIL_RENEW_APPL --视图-零售借据展期申请
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') 
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_RETL_DUBIL_RENEW_APPL', '', O_ERRCODE);

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

END ETL_O_IML_AGT_RETL_DUBIL_RENEW_APPL;
/

