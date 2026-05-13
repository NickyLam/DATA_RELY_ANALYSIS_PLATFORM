CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ABSS_FLOW_TASK(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：流程阶段数据
  **存储过程名称：    ETL_O_IOL_ABSS_FLOW_TASK
  **存储过程创建日期：20250910
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250910    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ABSS_FLOW_TASK'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ABSS_FLOW_TASK';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-流程阶段数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ABSS_FLOW_TASK NOLOGGING 
  (         SERIALNO               --流水号
           ,OBJECTNO               --对象编号
           ,OBJECTTYPE             --对象类型
           ,RELATIVESERIALNO       --上一流水号
           ,FLOWNO                 --流程编号
           ,FLOWNAME               --流程名称
           ,PHASENO                --阶段编号
           ,PHASENAME              --阶段名称
           ,PHASETYPE              --阶段类型
           ,APPLYTYPE              --申请类型
           ,USERID                 --承办人编号
           ,USERNAME               --承办人姓名
           ,ORGID                  --承办机构编号
           ,ORGNAME                --承办机构名称
           ,BEGINTIME              --开始执行时间
           ,ENDTIME                --完成执行时间
           ,PHASECHOICE            --阶段意见
           ,PHASEACTION            --阶段动作
           ,PHASEOPINION           --意见详情
           ,PHASEOPINION1          --意见详情1
           ,PHASEOPINION2          --意见详情2
           ,PHASEOPINION3          --意见详情3
           ,PHASEOPINION4          --意见详情4
           ,CHECKLISTRESULT        --检查清单结果
           ,AUTODECISION           --自动审批判断结果
           ,RISKSCANRESULT         --风险探测结果
           ,STANDARDTIME1          --标准审批用时
           ,STANDARDTIME2          --最长审批用时
           ,COSTLOB                --审批成本归属
           ,CLIENTX                --图元X坐标
           ,CLIENTY                --图元Y坐标
           ,WIDTH                  --图元宽度
           ,HEIGTH                 --图元高度
           ,GROUPINFO              --分组信息
           ,PROCESSINSTNO          --流程实例
           ,PROCESSTASKNO          --任务编号
           ,RELATIVEOBJECTNO       --关联对象编号
           ,FLOWSTATE              --工作流状态
           ,FORKSTATE      
           ,VERSION                --系统未使用
           ,BASEFLOWNO             --基础流程编号
           ,TASKSTATE              --任务状态
           ,FORKNO      
           ,ALLFORKNO      
           ,PARENTFLOWNO           --父流程编号
           ,ASSIGNEDTASKNO      
           ,RELANOTICENO      
           ,START_DT               --开始时间
           ,END_DT                 --结束时间
           ,ID_MARK                --增删标志
           ,ETL_TIMESTAMP          --ETL处理时间戳
    )
    SELECT
            SERIALNO               --流水号
           ,OBJECTNO               --对象编号
           ,OBJECTTYPE             --对象类型
           ,RELATIVESERIALNO       --上一流水号
           ,FLOWNO                 --流程编号
           ,FLOWNAME               --流程名称
           ,PHASENO                --阶段编号
           ,PHASENAME              --阶段名称
           ,PHASETYPE              --阶段类型
           ,APPLYTYPE              --申请类型
           ,USERID                 --承办人编号
           ,USERNAME               --承办人姓名
           ,ORGID                  --承办机构编号
           ,ORGNAME                --承办机构名称
           ,BEGINTIME              --开始执行时间
           ,ENDTIME                --完成执行时间
           ,PHASECHOICE            --阶段意见
           ,PHASEACTION            --阶段动作
           ,PHASEOPINION           --意见详情
           ,PHASEOPINION1          --意见详情1
           ,PHASEOPINION2          --意见详情2
           ,PHASEOPINION3          --意见详情3
           ,PHASEOPINION4          --意见详情4
           ,CHECKLISTRESULT        --检查清单结果
           ,AUTODECISION           --自动审批判断结果
           ,RISKSCANRESULT         --风险探测结果
           ,STANDARDTIME1          --标准审批用时
           ,STANDARDTIME2          --最长审批用时
           ,COSTLOB                --审批成本归属
           ,CLIENTX                --图元X坐标
           ,CLIENTY                --图元Y坐标
           ,WIDTH                  --图元宽度
           ,HEIGTH                 --图元高度
           ,GROUPINFO              --分组信息
           ,PROCESSINSTNO          --流程实例
           ,PROCESSTASKNO          --任务编号
           ,RELATIVEOBJECTNO       --关联对象编号
           ,FLOWSTATE              --工作流状态
           ,FORKSTATE      
           ,VERSION                --系统未使用
           ,BASEFLOWNO             --基础流程编号
           ,TASKSTATE              --任务状态
           ,FORKNO      
           ,ALLFORKNO      
           ,PARENTFLOWNO           --父流程编号
           ,ASSIGNEDTASKNO      
           ,RELANOTICENO      
           ,START_DT               --开始时间
           ,END_DT                 --结束时间
           ,ID_MARK                --增删标志
           ,ETL_TIMESTAMP          --ETL处理时间戳
  FROM IOL.V_ABSS_FLOW_TASK   --视图-流程阶段数据
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D'
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ABSS_FLOW_TASK', '', O_ERRCODE);

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

END ETL_O_IOL_ABSS_FLOW_TASK;
/

