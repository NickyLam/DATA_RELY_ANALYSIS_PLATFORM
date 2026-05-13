CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_CREDITLINE

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_CREDITLINE
  *  功能描述：
  *  创建日期：20221104
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_CREDITLINE --零售_授信基表
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221104   liuyu      首次创建
  *   2    20230523   liuyu      根据测试情况调整码值 普惠涉农授信区间 个人消费授信区间
  *   3    20250115   HYF        增加授信审批日期
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_CREDITLINE';   -- 程序名称
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
  V_TAB_NAME   := 'A_PHB_CREDITLINE'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_PHB_CREDITLINE
  (
         BGRQ                    -- 1 报告日期
        ,KHWYM                   -- 2 客户唯一码
        ,KHMC                    -- 3 客户名称
        ,GRKHATJFL               -- 4 个人客户按统计分类
        ,GRKHZJLX                -- 5 个人客户证件类型
        ,SXYWLB                  -- 6 授信业务类别
        ,SXZED                   -- 7 授信总额度（元）
        ,SXZED_W                 -- 8 授信总额度（万元）
        ,XFDKSXED                -- 9 消费贷款授信额度（元）
        ,XFDKSXED_W              -- 10 消费贷款授信额度（万元）
        ,PHXFSXQJ                -- 11 普惠消费授信区间
        ,GRJYDKSXED              -- 12 个人经营贷款授信额度（元）
        ,GRJYDKSXED_W            -- 13 个人经营贷款授信额度（万元）
        ,PHXWSXQJ                -- 14 普惠小微授信区间
        ,PHSNSXQJ                -- 15 普惠涉农授信区间
        ,YXYE                    -- 16 用信余额（元）
        ,CNYE                    -- 17 承诺余额（元）
        ,GRXFSXQJ                -- 18 个人消费授信区间
        ,GRKHZJH                 -- 19 个人客户证件号
        ,CRDT_APVED_DT           -- 20 授信审批日期
  )
   SELECT
         T1.DATA_DT              AS BGRQ                    -- 1 报告日期
        ,T1.CUST_ID              AS KHWYM                   -- 2 客户唯一码
        ,T4.CUST_NM              AS KHMC                    -- 3 客户名称
        ,CASE WHEN T4.OPR_CUST_TYP = 'A' THEN '个体工商户'
              WHEN T4.OPR_CUST_TYP = 'B' THEN '小微企业主'
              ELSE '其他'
         END                     AS GRKHATJFL               -- 4 个人客户按统计分类
        ,CASE
             WHEN T4.CRDL_TYP LIKE '10%' THEN '居民身份证' --居民身份证
             WHEN T4.CRDL_TYP LIKE '11%' THEN '户口簿' --户口簿
             WHEN T4.CRDL_TYP LIKE '12%' THEN '护照' --护照
             WHEN T4.CRDL_TYP LIKE '13%' THEN '军官证' --军官证
             WHEN T4.CRDL_TYP LIKE '14%' THEN '士兵证' --士兵证
             WHEN SUBSTR(T4.CRDL_TYP,1,2) IN ('15','16') THEN '其他有效通行旅行证件' --其他有效通行旅行证件
             WHEN T4.CRDL_TYP = '17' THEN '临时身份证' --临时身份证
             WHEN T4.CRDL_TYP = '19' THEN '警官证' --警官证
             WHEN T4.CRDL_TYP = '1B' THEN '学生证' --学生证
             WHEN T4.CRDL_TYP = '1E' THEN '文职干部证' --文职干部证
             ELSE '其他' --其他
          END                    AS GRKHZJLX                -- 5 个人客户证件类型
        ,'各项贷款'              AS SXYWLB                  -- 6 授信业务类别
        ,NVL(T1.CRDT_TOTAL_LMT,0)
                                 AS SXZED                   -- 7 授信总额度（元）
        ,NVL(T1.CRDT_TOTAL_LMT,0)/10000
                                 AS SXZED_W                 -- 8 授信总额度（万元）
        ,NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0)
                                 AS XFDKSXED                -- 9 消费贷款授信额度（元）
        ,(NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0)) / 10000
                                 AS XFDKSXED_W              -- 10 消费贷款授信额度（万元）
        ,CASE WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 10000 THEN '单户授信1万元（含）以下'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 100000 THEN '单户授信1万-10万元（含）'
         END                     AS PHXFSXQJ                -- 11 普惠消费授信区间
        ,NVL(T1.OPR_CRDT_TOT_AMT,0)
                                 AS GRJYDKSXED              -- 12 个人经营贷款授信额度（元）
        ,NVL(T1.OPR_CRDT_TOT_AMT,0)/10000
                                 AS GRJYDKSXED_W            -- 13 个人经营贷款授信额度（万元）
        ,CASE WHEN T1.CRDT_TOTAL_LMT <= 1000000 THEN '单户授信100万（含）元以下'
              WHEN T1.CRDT_TOTAL_LMT <= 5000000 THEN '单户授信100-500万元（含）'
              WHEN T1.CRDT_TOTAL_LMT <= 10000000 THEN '单户授信500-1000万元（含）'
              WHEN T1.CRDT_TOTAL_LMT <= 30000000 THEN '单户授信1000-3000万元（含）'
              WHEN T1.CRDT_TOTAL_LMT > 30000000 THEN '单户授信3000万元以上'
              ELSE '不适用'
         END                     AS PHXWSXQJ                -- 14 普惠小微授信区间 --S7101 专用额度
        ,CASE WHEN T1.OPR_CRDT_TOT_AMT <= 100000 THEN '单户经营授信10万（含）元以下'
              WHEN T1.OPR_CRDT_TOT_AMT <= 1000000 THEN '单户经营授信10-100万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 50000000 THEN '单户经营授信100-500万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 100000000 THEN '单户经营授信500-1000万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT > 100000000 THEN '单户经营授信1000万元以上'
              ELSE '不适用'
         END                     AS PHSNSXQJ                -- 15 普惠涉农授信区间 -- S7102专用维度
        ,NVL(T2.ALDY_USE_LMT,0)  AS YXYE                    -- 16 用信余额（元）
        ,NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T2.ALDY_USE_LMT,0)
                                 AS CNYE                    -- 17 承诺余额（元）
        ,CASE WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) = 0 THEN '不适用'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 100000 THEN '10万元及以下'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 300000 THEN '10万元-30万元（含）'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 500000 THEN '30万元-50万元（含）'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0) <= 1000000 THEN '50万元-100万元（含）'
              WHEN NVL(T1.CRDT_TOTAL_LMT,0) - NVL(T1.OPR_CRDT_TOT_AMT,0)  > 1000000 THEN '100万元以上'
         END                     AS GRXFSXQJ                -- 18 个人消费授信区间 -- G05专用维度
        ,T4.CRDL_NO              AS GRKHZJH                 -- 19 个人客户证件号
        ,T2.CRDT_APVED_DT        AS CRDT_APVED_DT           -- 20 授信审批日期
    FROM RRP_MDL.S_LOAN_CRDT_CUST T1
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T2
      ON T2.CUST_ID = T1.CUST_ID
     AND T2.DATA_DT = V_P_DATE
   INNER JOIN RRP_MDL.M_CUST_IND_INFO     T4 --个人客户信息
      ON T4.CUST_ID = T1.CUST_ID
     AND T4.DATA_DT = V_P_DATE
   WHERE T1.DATA_DT = V_P_DATE
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
    SELECT BGRQ,KHWYM,COUNT(1)
      FROM RRP_MDL.A_PHB_CREDITLINE T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,KHWYM
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

  END ETL_A_PHB_CREDITLINE;
/

