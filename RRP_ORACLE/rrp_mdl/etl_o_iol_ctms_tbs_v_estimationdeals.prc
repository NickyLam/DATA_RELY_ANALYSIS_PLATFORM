CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_TBS_V_ESTIMATIONDEALS(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_TBS_V_ESTIMATIONDEALS
  *  功能描述：估值
  *  创建日期：20250728
  *  开发人员：YJY
  *  来源表：
  *  目标表： O_IOL_CTMS_TBS_V_ESTIMATIONDEALS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250728  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_CTMS_TBS_V_ESTIMATIONDEALS'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_TBS_V_ESTIMATIONDEALS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-估值';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_CTMS_TBS_V_ESTIMATIONDEALS
    (DEAL_ID               --引用表ID
    ,DEAL_NAME             --引用表名
    ,ASPCLIENT_ID          --部门编号
    ,CALCDATE              --估值日期
    ,BALANCE_ID            --引用表2ID
    ,HOLDAMOUNT            --持仓量
    ,FACEAMOUNTESTIMATE    --账面估值
    ,MARKETESTIMATE        --市场估值
    ,FAIRVALUEALTER        --公允价值变动
    ,PRICEDATE             --公允价格日期
    ,FAIRPRICE             --公允价格
    ,PRICESRC              --价格来源
    ,KEEPFOLDER_ID         --账户ID
    ,ASSETTYPE             --资产类别
    ,MAJORASSETCODE        --债券代码
    ,LASTMODIFIED          --最后修改时间
    ,START_DT              --开始时间
    ,END_DT                --结束时间
    ,ID_MARK               --增删标志
    ,ETL_TIMESTAMP         --ETL处理时间戳
    )
  SELECT 
     DEAL_ID               --引用表ID
    ,DEAL_NAME             --引用表名
    ,ASPCLIENT_ID          --部门编号
    ,CALCDATE              --估值日期
    ,BALANCE_ID            --引用表2ID
    ,HOLDAMOUNT            --持仓量
    ,FACEAMOUNTESTIMATE    --账面估值
    ,MARKETESTIMATE        --市场估值
    ,FAIRVALUEALTER        --公允价值变动
    ,PRICEDATE             --公允价格日期
    ,FAIRPRICE             --公允价格
    ,PRICESRC              --价格来源
    ,KEEPFOLDER_ID         --账户ID
    ,ASSETTYPE             --资产类别
    ,MAJORASSETCODE        --债券代码
    ,LASTMODIFIED          --最后修改时间
    ,START_DT              --开始时间
    ,END_DT                --结束时间
    ,ID_MARK               --增删标志
    ,ETL_TIMESTAMP         --ETL处理时间戳
    FROM IOL.V_CTMS_TBS_V_ESTIMATIONDEALS  --视图-估值
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_CTMS_TBS_V_ESTIMATIONDEALS', '', O_ERRCODE);

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

END ETL_O_IOL_CTMS_TBS_V_ESTIMATIONDEALS;
/

