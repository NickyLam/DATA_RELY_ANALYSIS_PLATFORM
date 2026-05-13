CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_OTH_CNY_INT_MRG_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_OTH_CNY_INT_MRG_INFO
  *  功能描述：监管集市个人客户信息加工示例程序
  *  创建日期：20220627
  *  开发人员：hulijuan
  *  来源表：  FDMS_FDL_IDX_INDEX_DATA_NEW   --指标_指标数据
  *  目标表：  M_OTH_CNY_INT_MRG_INFO        --人民币利差息差统计表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;       --处理步骤
  V_P_DATE    VARCHAR2(8);        --跑批数据日期
  V_STARTTIME DATE;               --处理开始时间
  V_ENDTIME   DATE;               --处理结束时间
  V_SQLCOUNT  INTEGER := 0;       --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);      --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);      --任务名称
  V_PART_NAME VARCHAR2(100);      --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_OTH_CNY_INT_MRG_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_OTH_CNY_INT_MRG_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入人民币利差息差统计表数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_OTH_CNY_INT_MRG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人代码
    ,ORG_ID           --机构编号
    ,PROFIT_DIF       --利差
    ,INT_PAY_LBY_RATE --付息负债利率
    ,AST_RATE         --生息资产利率
    ,NET_PROFIT_DIF   --净利差
    ,NET_INT_DIF      --净息差
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  SELECT DATA_DT                        AS DATA_DT                              --数据日期
        ,'9999'                         AS LGL_REP_ID                           --法人代码
        ,ORG_ID                         AS ORG_ID                               --机构编号
        ,ROUND("'FM0500069'" ,5)        AS PROFIT_DIF                           --利差
        ,ROUND("'FM0500033'" ,5)        AS INT_PAY_LBY_RATE                     --付息负债利率
        ,ROUND("'FM0500018'" ,5)        AS AST_RATE                             --生息资产利率
        ,ROUND("'FM0500018'" ,5) - ROUND("'FM0500033'" ,5) AS NET_PROFIT_DIF    --净利差
        ,ROUND("'FM0500038'" ,2)        AS NET_INT_DIF                          --净息差
        ,NULL                           AS DEPT_LINE                            --部门条线
        ,NULL                           AS DATA_SRC                             --数据来源
    FROM (
      SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')   AS DATA_DT
            ,'9999'                         AS LGL_REP_ID
            ,A.ORG_NO                       AS ORG_ID
            ,A.INDEX_NO                     AS INDEX_NO
            ,ROUND(A.INDEX_VAL*100,5)       AS INDEX_VAL
        FROM RRP_MDL.O_FDW_FDL_IDX_INDEX_DATA_NEW A  --指标_指标数据
       WHERE A.INDEX_NO IN ('FM0500069','FM0500033','FM0500018','FM0500034','FM0500038')
         AND A.INDEX_MEASURE = '013'
         AND A.ORG_NO = '000000'
         AND A.CURR_CD = 'CNY') TA
   PIVOT (SUM(TA.INDEX_VAL) FOR INDEX_NO IN ('FM0500069','FM0500033','FM0500018','FM0500034','FM0500038'))
   WHERE DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_OTH_CNY_INT_MRG_INFO;
/

