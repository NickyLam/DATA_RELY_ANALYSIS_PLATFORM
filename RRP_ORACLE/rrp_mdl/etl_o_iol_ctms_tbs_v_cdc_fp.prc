CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_TBS_V_CDC_FP(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_TBS_V_CDC_FP
  *  功能描述：CDC公允价格
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： IOL.V_CTMS_TBS_V_CDC_FP
  *  目标表： O_IOL_CTMS_TBS_V_CDC_FP
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1     20220525  梅炜     首次创建
  *             2     20251127  YJY     修改为分区表，每天增量获取数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_CTMS_TBS_V_CDC_FP'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_TBS_V_CDC_FP'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-CDC公允价格';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_CTMS_TBS_V_CDC_FP
  (   
       SECURITY_CODE             --债券代码
      ,PRICING_DATE              --日期
      ,MARKET                    --市场类别
      ,TTM                       --剩余期限
      ,RELIABILITY               --是否推荐
      ,DP                        --全价
      ,CP                        --净价
      ,YIELD                     --到期收益率
      ,DURATION                  --久期
      ,MDURATION                 --修正久期
      ,VALID                     --有效性
      ,LASTUPDATE                --最后更新时间
      -- AI,                        --
      ,END_DP                    --日终全价
      ,CDC_YIELD                 --估价收益率（%）
      ,CDC_MD                    --估价修正久期
      ,CDC_CONVEXITY             --估价凸性
      ,ETL_DT                    --ETL处理日期
   )
  SELECT 
       SECURITY_CODE             --债券代码
      ,PRICING_DATE              --日期
      ,MARKET                    --市场类别
      ,TTM                       --剩余期限
      ,RELIABILITY               --是否推荐
      ,DP                        --全价
      ,CP                        --净价
      ,YIELD                     --到期收益率
      ,DURATION                  --久期
      ,MDURATION                 --修正久期
      ,VALID                     --有效性
      ,LASTUPDATE                --最后更新时间
      -- AI,                        --
      ,END_DP                    --日终全价
      ,CDC_YIELD                 --估价收益率（%）
      ,CDC_MD                    --估价修正久期
      ,CDC_CONVEXITY             --估价凸性
      ,ETL_DT                    --ETL处理日期
    FROM IOL.V_CTMS_TBS_V_CDC_FP --视图-CDC公允价格
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_CTMS_TBS_V_CDC_FP;
/

