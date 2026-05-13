CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_LS_003_MONEY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_LS_003_MONEY
  *  功能描述：补录表-零售-账务基表。
  *  创建日期：20221220
  *  开发人员：liuyu
  *  来源表：  ICL.CMM_RETL_LOAN_ACCT_INFO  --零售贷款账户信息表
  *            ICL.CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息表
               ICL.CMM_RETL_LOAN_CONT_INFO  --零售贷款合同信息表
               ICL.CMM_INDV_CUST_BASIC_INFO --个人客户基本信息表
               ICL.CMM_STD_PROD_INFO --贷款产品信息表
               RRP_MDL.CODE_MAP  --码值映射表(贷款类型)
  *  目标表：  M_ADD_LS_003_MONEY  -零售-账务基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221220  liuyu    首次创建。
  *             2    20230531  liuyu    新增重复数据校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                              -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_LS_003_MONEY';       -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_LS_003_MONEY';           -- 报表名称
  V_PART_NAME   VARCHAR2(100);                                    -- 分区名称
  V_P_DATE      VARCHAR2(8);                                      -- 跑批数据日期
  V_STARTTIME   DATE;                                             -- 处理开始时间
  V_ENDTIME     DATE;                                             -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                              -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                    -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                     -- 来源系统

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

   --DELETE FROM M_ADD_LS_003_MONEY T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_LS_003_MONEY';

  INSERT INTO TMP_M_ADD_LS_003_MONEY
  (
     DATA_DATE       --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   )
   SELECT
      A.DATA_DATE       --01 数据日期
     ,A.ACCT_ORG_NUM    --02 账务机构编号
     ,A.JYWYM           --03 交易唯一码
     ,A.ZHWYM           --04 账户唯一码
     ,A.KHWYM           --05 客户唯一码
     ,A.KHMC            --06 客户名称
     ,A.DKYWPZMC        --07 贷款业务品种名称
     ,A.TJYE            --08 统计余额（元）
     ,A.SSGMJJHYXLDM    --09 所属国民经济行业小类代码
     ,A.TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   FROM (
      SELECT B.*,ROW_NUMBER()OVER(PARTITION BY B.JYWYM ORDER BY B.SYS_OPER_DATE DESC) RN
      FROM ADD_LS_003_MONEY_ETL B
      WHERE B.DATA_DATE = V_P_DATE
       ) A
   WHERE A.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 3;
   V_STEP_DESC := 'ADD数据与跑批数据插入到目标表';
   V_STARTTIME := SYSDATE;

   INSERT INTO M_ADD_LS_003_MONEY
    (
     DATA_DATE,     --01 数据日期
     ACCT_ORG_NUM,  --02 账务机构编号
     JYWYM,         --03 交易唯一码
     ZHWYM,         --04 账户唯一码
     KHWYM,         --05 客户唯一码
     KHMC,          --06 客户名称
     DKYWPZMC,      --07 贷款业务品种名称
     TJYE,          --08 统计余额（元）
     SSGMJJHYXLDM,  --09 所属国民经济行业小类代码
     TXGMJJXYXLDM   --10 投向国民经济行业小类代码
    )
   SELECT /*+ PARALLEL(A,4) */
     A.DATA_DATE,     --01 数据日期
     A.ACCT_ORG_NUM,  --02 账务机构编号
     A.JYWYM,         --03 交易唯一码
     A.ZHWYM,         --04 账户唯一码
     A.KHWYM,         --05 客户唯一码
     A.KHMC,          --06 客户名称
     A.DKYWPZMC,      --07 贷款业务品种名称
     NVL(B.TJYE,A.TJYE),                  --08 统计余额（元）
     NVL(B.SSGMJJHYXLDM,A.SSGMJJHYXLDM),  --09 所属国民经济行业小类代码
     NVL(B.TXGMJJXYXLDM,A.TXGMJJXYXLDM)   --10 投向国民经济行业小类代码
   FROM ADD_LS_003_MONEY A
   LEFT JOIN TMP_M_ADD_LS_003_MONEY B
   ON A.JYWYM = B.JYWYM
   WHERE A.DATA_DATE = V_P_DATE
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 4;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.M_ADD_LS_003_MONEY T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 5;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_ADD_LS_003_MONEY;
/

