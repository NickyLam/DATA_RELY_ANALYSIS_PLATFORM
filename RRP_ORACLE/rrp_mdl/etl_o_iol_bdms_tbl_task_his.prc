CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_TBL_TASK_HIS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：审批历史表
  **存储过程名称：    ETL_O_IOL_BDMS_TBL_TASK_HIS
  **存储过程创建日期：20250408
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250408    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_BDMS_TBL_TASK_HIS'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_TBL_TASK_HIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-审批历史表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_TBL_TASK_HIS NOLOGGING 
    (ID                 --主键ID
    ,TASK_ID            --任务编号
    ,PROCESS_ID         --流程实例编号
    ,NODE_ID            --节点编号
    ,TASK_NAME          --任务名称
    ,TASK_FLAG          --任务完成标志
    ,ASSIGN_ID          --操作员编号
    ,TASK_DESCRIPTION   --审批描述
    ,TASK_COMMENT       --备注
    ,CREATE_TIME        --创建时间
    ,TAKED_TIME         --领用时间
    ,DEAL_TIME          --处理时间
    ,NAME1              --备用字段1
    ,NAME2              --业务批次ID
    ,NAME3              --备用字段3
    ,NAME4              --业务汇总金额
    ,NAME5              --业务机构编号
    ,NAME6              --上级机构编号
    ,NAME7              --备用字段7
    ,NAME8              --备用字段8
    ,TASK_MARK          --任务备注
    ,PROTOCOL_NO        --业务协议编号
    ,CONTRACT_ID        --业务批次ID
    ,NODE_NAME          --节点名称
    ,ASSIGN_NAME        --操作员名称
    ,PARENT_ID          --父节点ID
    ,APPROVE_FLAG       --审批意见: 1-同意 2-拒绝 3-退回
    ,ETL_DT             --ETL处理日期
    ,ETL_TIMESTAMP      --ETL处理时间戳
    )
  SELECT ID                 --主键ID
        ,TASK_ID            --任务编号
        ,PROCESS_ID         --流程实例编号
        ,NODE_ID            --节点编号
        ,TASK_NAME          --任务名称
        ,TASK_FLAG          --任务完成标志
        ,ASSIGN_ID          --操作员编号
        ,TASK_DESCRIPTION   --审批描述
        ,TASK_COMMENT       --备注
        ,CREATE_TIME        --创建时间
        ,TAKED_TIME         --领用时间
        ,DEAL_TIME          --处理时间
        ,NAME1              --备用字段1
        ,NAME2              --业务批次ID
        ,NAME3              --备用字段3
        ,NAME4              --业务汇总金额
        ,NAME5              --业务机构编号
        ,NAME6              --上级机构编号
        ,NAME7              --备用字段7
        ,NAME8              --备用字段8
        ,TASK_MARK          --任务备注
        ,PROTOCOL_NO        --业务协议编号
        ,CONTRACT_ID        --业务批次ID
        ,NODE_NAME          --节点名称
        ,ASSIGN_NAME        --操作员名称
        ,PARENT_ID          --父节点ID
        ,APPROVE_FLAG       --审批意见: 1-同意 2-拒绝 3-退回
        ,ETL_DT             --ETL处理日期
        ,ETL_TIMESTAMP      --ETL处理时间戳
    FROM IOL.V_BDMS_TBL_TASK_HIS --视图-审批历史表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_BDMS_TBL_TASK_HIS', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_BDMS_TBL_TASK_HIS;
/

