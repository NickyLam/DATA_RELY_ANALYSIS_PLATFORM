CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_FEE_WAIVER_TYPE

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_FEE_WAIVER_TYPE
  *  功能描述：
  *  创建日期：20221104
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_FEE_WAIVER_TYPE --零售-减免费用类别
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221104   刘宇      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_FEE_WAIVER_TYPE';   -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ; --表名
  V_PART_NAME  VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_FEE_WAIVER_TYPE'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
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

  INSERT INTO RRP_MDL.A_PHB_FEE_WAIVER_TYPE
  (
         DATA_DATE               -- 1 数据日期
        ,ORG_NUM                 -- 2 账务机构编号
        ,ORG_NAME                -- 3 账务机构名称
        ,KHWYM                   -- 4 客户唯一码
        ,KHMC                    -- 5 客户名称
        ,YWHTBH                  -- 6 业务合同编号
        ,TJYWPZ                  -- 7 统计业务品种
        ,GRKHATJFL               -- 8 个人客户按统计分类
        ,BXCDFYLB                -- 9 本行承担费用类別
        ,BXJMFYLB                -- 10 本行减免费用类別
        ,BNLJCDHJMDXDXGFYJE      -- 11 本年累计承担或减免的信贷相关费用金额（元）
        --,SYS_SOURCE              -- 12 来源系统
  )
   SELECT
         T1.DATA_DATE                    AS DATA_DATE               -- 1 数据日期
        ,T1.ACCT_ORG_NUM                 AS ORG_NUM                 -- 2 账务机构编号
        ,T3.ORG_NM                       AS ORG_NAME                -- 3 账务机构名称
        ,T1.KHWYM                        AS KHWYM                   -- 4 客户唯一码
        ,T1.KHMC                         AS KHMC                    -- 5 客户名称
        ,T1.YWHTBH                       AS YWHTBH                  -- 6 业务合同编号
        ,T1.TJYWPZ                       AS TJYWPZ                  -- 7 统计业务品种
        ,DECODE(T1.GRKHATJFL,'A','个体工商户'
                            ,'B','小微企业主'
                            ,'C','个体工商户和小微企业主'
                            ,'D','其他')  AS GRKHATJFL               -- 8 个人客户按统计分类
        ,DECODE(T1.BXCDFYLB,'01','抵押登记费'--抵押登记费(承担)
        									 ,'02','押品评估费'--押品评估费(承担)
        									 ,'03','其他信贷相关承担费用'--其他信贷相关承担费用(承担)
        									 ,'04','客户承担'--客户承担(承担)
		        							 ,'不适用')      AS BXCDFYLB                -- 9 本行承担费用类別
        , DECODE(T1.BXJMFYLB,'05','咨询费'--咨询费(减免)
        										,'06','财务顾问费'--财务顾问费(减免)
        									  ,'07','其他信贷相关减免费用'--其他信贷相关减免费用(减免)
        										,'08','其他表外费用减免'--其他表外费用减免(减免)
		        								,'不适用')     AS BXJMFYLB                -- 10 本行减免费用类別
        ,T1.BNLJCDHJMDXDXGFYJE             AS BNLJCDHJMDXDXGFYJE      -- 11 本年累计承担或减免的信贷相关费用金额（元）
        --,T1.SYS_SOURCE       AS SYS_SOURCE              -- 12 来源系统
      FROM (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY YWHTBH ORDER BY YWHTBH ) AS RN
              FROM RRP_MDL.M_ADD_LS_FEE_WAIVER_TYPE T
             WHERE T.DATA_DATE = V_P_DATE) T1
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
        ON T1.ACCT_ORG_NUM = T3.ORG_ID
       AND T3.DATA_DT = V_P_DATE
     WHERE T1.DATA_DATE = V_P_DATE
       AND T1.RN = 1
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
    SELECT DATA_DATE,YWHTBH,COUNT(1)
      FROM RRP_MDL.A_PHB_FEE_WAIVER_TYPE T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,YWHTBH
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

  END ETL_A_PHB_FEE_WAIVER_TYPE;
/

