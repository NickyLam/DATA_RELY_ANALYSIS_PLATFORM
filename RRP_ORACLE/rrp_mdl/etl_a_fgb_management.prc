CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_MANAGEMENT
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_MANAGEMENT
  *  功能描述：对公不良处置基表
  *  创建日期：20221031
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_FGB_MANAGEMENT --对公不良处置基表
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221107   liuyu      首次创建
  *   2    20230331   Liuyu      根据荣炳华最终口径调整基表逻辑
  *   3    20230508   liuyu      新增机构号字段
  *   4    20230526   liuyu      根据测试数据修改过滤条件
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_MANAGEMENT';
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
  V_TAB_NAME   := 'A_FGB_MANAGEMENT'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 分区表分区处理 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '从S层不良处置表直接出数';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_FGB_MANAGEMENT
    (
           BGRQ            --报告日期
          ,BLCZXJLWYM      --不良处置现金流唯一码
          ,JYWYM           --交易唯一码
          ,ZHWYM           --账户唯一码
          ,KHWYM           --客户唯一码
          ,KHMC            --客户名称
          ,BLZCLB          --不良资产类别
          ,BLCZHJFS        --不良处置化解方式
          ,BLCZHJRQ        --不良处置化解日期
          ,BLCZJE          --不良处置金额
          ,BLCZSHQTJE      --不良处置收回其他金额
          ,SJLY            --数据来源
          ,JGBH            --机构编号
    )
     SELECT
            V_P_DATE          AS BGRQ            -- 报告日期
           ,T1.SERIALNO       AS BLCZXJLWYM      --不良处置现金流唯一码
           ,T1.DUEBILLID      AS JYWYM           --交易唯一码
           ,T1.ACC_ID         AS ZHWYM           --账户唯一码 来源表暂时置空
           ,T1.CUSTOMERID     AS KHWYM           --客户唯一码
           ,T1.CUSTOMERNAME   AS KHMC            --客户名称
           ,T1.ASSETTYPE      AS BLZCLB          --不良资产类别
           ,T1.HANDLETYPE     AS BLCZHJFS        --不良处置化解方式
           ,TO_CHAR(T1.HANDLETIME,'YYYYMMDD')     AS BLCZHJRQ        --不良处置化解日期
           ,T1.HANDLEBALANCE  AS BLCZJE          --不良处置金额
           ,T1.RECOVERBALANCE AS BLCZSHQTJE      --不良处置收回其他金额
           ,'对公'            AS SJLY            --数据来源
           ,T1.ORG_ID         AS JGBH            --机构编号
     FROM S_ASSET_LEDGET T1 --不良资产处置台账
    WHERE T1.DATA_DT = V_P_DATE
      AND T1.CUSTOMERTYPE IN ('公司客户','对公') --mod by liuyu 20230523
    ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,BLCZXJLWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_MANAGEMENT T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,BLCZXJLWYM
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

  END ETL_A_FGB_MANAGEMENT;
/

