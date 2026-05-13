CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_G51_GUA_LOAN
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_G51_GUA_LOAN
  *  功能描述：对公-国别-内保外贷模型（G51）
  *  创建日期：20221227
  *  开发人员：孙满洋
  *  来源表：
  *  目标表：A_FGB_G51_GUA_LOAN
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期    修改人         修改原因
  *   1    20221227   sunmanyang      首次创建
  ***************************************************************************/


 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_G51_GUA_LOAN';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_G51_GUA_LOAN'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 /*增加表分区及重跑逻辑,在插入目标报表数据逻辑之前添加这段逻辑*/
 V_STEP := V_STEP + 1;
 V_STEP_DESC := '分区处理';
 V_STARTTIME := SYSDATE;

 ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

 V_SQLCOUNT := SQL%ROWCOUNT;
 V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
 V_ENDTIME := SYSDATE;
 COMMIT;
 ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 V_STEP := V_STEP + 1;
 V_STEP_DESC := '从M层表接数开始';
 V_STARTTIME := SYSDATE;

  INSERT INTO A_FGB_G51_GUA_LOAN (
         BGRQ          -- 报告日期
        ,ACCT_ORG_NUM  -- 账务机构编号
        ,JYWYM          -- 交易唯一码
        ,ZHWYM          -- 账户唯一码
        ,ZWJGMC          -- 账务机构名称
        ,YWLB          -- 业务类别
        ,SFNBWD          -- 是否内保外贷
        ,DWDBLB          -- 对外担保类别
        ,YSQSRQ          -- 原始起始日期
        ,SFBNQY          -- 是否本年签约
        ,SJDQRQ          -- 实际到期日期
        ,DWDBQYE      -- 对外担保签约额（元）
        ,DWDBLYRQ      -- 对外担保履约日期
        ,SFBNLY          -- 是否本年履约
        ,DWDBLYE      -- 对外担保履约额（元）
        ,DWDBDQSXJE      -- 对外担保到期失效金额（元）
        ,DWDBQMYE      -- 对外担保期末余额（元）
        ,YCHDWDBDKJE  -- 已偿还对外担保垫款金额（元）
        ,DWDBQMDKYE      -- 对外担保期末垫款余额（元）
        ,SYS_SOURCE      -- 来源系统
  )
  SELECT
         V_P_DATE                                 AS BGRQ         -- 数据日期
        ,A.ACCT_ORG_NUM                           AS ACCT_ORG_NUM -- 账务机构编号
        ,A.JYWYM                                  AS JYWYM        -- 交易唯一码
        ,A.ZHWYM                                  AS ZHWYM        -- 账户唯一码
        ,A.ZWJGMC                                 AS ZWJGMC        -- 账务机构名称
        ,A.YWLB                                   AS YWLB         -- 业务类别
        ,DECODE(A.SFNBWD,'Y','是','否')           AS SFNBWD        -- 是否内保外贷
        ,M1.CODENAME                              AS DWDBLB       -- 对外担保类别
        ,A.YSQSRQ                                 AS YSQSRQ        -- 原始起始日期
        ,DECODE(A.SFBNQY,'Y','是','否')           AS SFBNQY        -- 是否本年签约
        ,A.SJDQRQ                                 AS SJDQRQ       -- 实际到期日期
        ,A.DWDBQYE                                AS DWDBQYE    -- 对外担保签约额（元）
        ,A.DWDBLYRQ                               AS DWDBLYRQ     -- 对外担保履约日期
        ,DECODE(A.SFBNLY,'Y','是','否')           AS SFBNLY       -- 是否本年履约
        ,A.DWDBLYE                                AS DWDBLYE      -- 对外担保履约额（元）
        ,A.DWDBDQSXJE                             AS DWDBDQSXJE   -- 对外担保到期失效金额（元）
        ,A.DWDBQMYE                               AS DWDBQMYE     -- 对外担保期末余额（元）
        ,A.YCHDWDBDKJE                            AS YCHDWDBDKJE  -- 已偿还对外担保垫款金额（元）
        ,A.DWDBQMDKYE                             AS DWDBQMDKYE   -- 对外担保期末垫款余额（元）
        ,A.SYS_SOURCE                             AS SYS_SOURCE   -- 来源系统
   FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY JYWYM ORDER BY JYWYM ) AS RN
           FROM M_ADD_DG_015_NATION_FOREIGN T
          WHERE T.DATA_DATE = V_P_DATE) A
   LEFT JOIN M_BASIC_CODETABLE M1
     ON A.DWDBLB = M1.CODE
    AND M1.CODE_TABLE_CODE = 'A0037' -- 对外担保类别
  WHERE A.DATA_DATE = V_P_DATE
    AND A.RN = 1
  ;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_G51_GUA_LOAN T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_G51_GUA_LOAN;
/

