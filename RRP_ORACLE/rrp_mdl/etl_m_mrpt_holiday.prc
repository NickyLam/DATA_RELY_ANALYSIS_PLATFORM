CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_HOLIDAY(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_HOLIDAY
  *  功能描述：节假日信息表
  *  创建日期：2022/12/13
  *  开发人员：HDY
  *  来源表：  O_IML_REF_RG_HOLIDAY_PARA 节假日参数信息表

  *  目标表：  M_MRPT_HOLIDAY
  *
  *  配置表：
  *  修改情况：1  2022/12/13  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_HOLIDAY' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_TAB_NAME      VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;


BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_HOLIDAY'; --表名称
  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE '||V_TAB_NAME;
  EXECUTE IMMEDIATE V_SQL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 节假日信息表--';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_HOLIDAY
             (
                 DATA_DT,                   --01 数据日期
                 LAST_WORD_DAY2,            --02 节假日前2个工作日
                 LAST_WORD_DAY1,            --03 节假日前1个工作日
                 START_DAY,                 --04 节假日开始时间
                 END_DAY,                   --05 节假日结束时间
                 ONE_WORD_DAY               --06 假期后第一个工作日
       )
  WITH HOLDY_TMP AS (
          SELECT HOLIDAY_DT,
                 HOLIDAY_TYPE_DESCB,
                 CASE WHEN SUBSTR(TO_CHAR(HOLIDAY_DT,'YYYYMMDD'),7,2) IN ('10',20) OR HOLIDAY_DT = LAST_DAY(HOLIDAY_DT)
              THEN HOLIDAY_DT
            ELSE NULL END AS T_DAYS  -- 旬末
            FROM RRP_MDL.O_IML_REF_RG_HOLIDAY_PARA --节假日参数信息表
           WHERE LOCAL_CTY_RG_CD = 'CHN'
             AND WD_FLG = '0'
   ),LAST_WORD_DAY AS (
          SELECT HOLIDAY_DT - 2  AS LAST_WORD_DAY2,                   --假期前2个工作日
                 HOLIDAY_DT - 1  AS LAST_WORD_DAY1,                   --假期前1个工作日
                 T_DAYS          AS T_DAYS,                           --旬末
                 CONNECT_BY_ISLEAF,                                   --子节点
                 MIN(CONNECT_BY_ROOT HOLIDAY_DT)   AS START_DAY,      --假期开始时间
                 MAX(CONNECT_BY_ROOT HOLIDAY_DT)   AS END_DAY,        --假期结束时间
                 MAX(CONNECT_BY_ROOT HOLIDAY_DT)+1 AS ONE_WORK_DAY    --假期后第一个工作日
            FROM HOLDY_TMP
      CONNECT BY PRIOR HOLIDAY_DT-1 = HOLIDAY_DT
        GROUP BY HOLIDAY_DT-2,HOLIDAY_TYPE_DESCB,HOLIDAY_DT,CONNECT_BY_ISLEAF,T_DAYS
   )      SELECT DISTINCT
                 V_P_DATE，                                           --数据日期
                 A.LAST_WORD_DAY2,                                    --假期前2个工作日
                 CASE WHEN A.T_DAYS IS NOT NULL THEN A.T_DAYS
                             WHEN B.T_DAYS IS NOT NULL THEN B.T_DAYS
                             ELSE A.LAST_WORD_DAY1
                             END AS LAST_WORD_DAY1,                   --假期前一个工作日，如果假期期间有旬末，则假期前一个工作日为旬末
                        A.START_DAY,                                  --假期开始时间
                        A.END_DAY,                                    --假期结束时间
                        A.ONE_WORK_DAY                                --假期后第一个工作日
            FROM LAST_WORD_DAY A
       LEFT JOIN LAST_WORD_DAY B
              ON A.ONE_WORK_DAY = B.ONE_WORK_DAY
             AND B.CONNECT_BY_ISLEAF = '0'
           WHERE A.CONNECT_BY_ISLEAF = '1';
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --V_SQL :='TRUNCATE TABLE TMP_M_MFD_ASSURANCE_DP';
 -- EXECUTE IMMEDIATE V_SQL;

 --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_HOLIDAY;
/

