CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER
  *  功能描述：流程节点登记表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_BDMS_BMS_FLOW_SHARP_REGISTER
  *  目标表： O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
  *************************************************************************/
AS
  --定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; --默认写监管报送系统，有真实来源的按实际写 --来源系统
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-流程节点登记表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER NOLOGGING
    (ID                   --主键
    ,FLOW_SHARP_ID        --流程ID
    ,CUR_NODE_ID          --当前节点ID
    ,CUR_APP_ROUTE_FLAG   --当前是否含审批路线
    ,NEXT_NODE_ID         --下一节点ID
    ,NEXT_APP_ROUTE_FLAG  --当前是否含审批路线
    ,PRODUCT_NO           --产品类型编码
    ,PROTOCOL_NO          --协议号
    ,CONTRACT_ID          --协议ID
    ,TABLE_TYPE           --表类型
    ,STATUS               --流程状态
    ,LAST_OPERATOR_NO     --最后操作员编号
    ,LAST_TXN_DATE        --最后操作日期
    ,ETL_DT               --ETL处理日期
    ,ETL_TIMESTAMP        --ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
         ID                   --主键
        ,FLOW_SHARP_ID        --流程ID
        ,CUR_NODE_ID          --当前节点ID
        ,CUR_APP_ROUTE_FLAG   --当前是否含审批路线
        ,NEXT_NODE_ID         --下一节点ID
        ,NEXT_APP_ROUTE_FLAG  --当前是否含审批路线
        ,PRODUCT_NO           --产品类型编码
        ,PROTOCOL_NO          --协议号
        ,CONTRACT_ID          --协议ID
        ,TABLE_TYPE           --表类型
        ,STATUS               --流程状态
        ,LAST_OPERATOR_NO     --最后操作员编号
        ,LAST_TXN_DATE        --最后操作日期
        ,ETL_DT               --ETL处理日期
        ,ETL_TIMESTAMP        --ETL处理时间戳
    FROM IOL.V_BDMS_BMS_FLOW_SHARP_REGISTER --流程节点登记表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_BDMS_BMS_FLOW_SHARP_REGISTER;
/

