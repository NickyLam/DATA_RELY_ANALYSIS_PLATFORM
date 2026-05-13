CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_002_CREDIT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_002_CREDIT
  *  功能描述：补录表-对公-授信基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL_CMM_BILL_DISCNT_INFO      -- 票据贴现信息
  *            ICL.CMM_CORP_LOAN_CONT_INFO   --对公贷款合同信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            ICL.CMM_BILL_CENTER_INFO      --票据中心信息
  *  目标表：  M_ADD_DG_002_CREDIT  --授信基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj     首次创建。
  *             2    20230531  liuyu    新增重复值校验
                3    20230604  liuyu    调整为直取前端补录数据
                4    20230911  lwb      调整继承逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                              -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_DG_002_CREDIT';      -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_DG_002_CREDIT';          -- 报表名称
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

   --DELETE FROM M_ADD_DG_002_CREDIT T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD_ETL的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  --EXECUTE IMMEDIATE 'TRUNCATE TABLE M_ADD_DG_002_CREDIT_TMP';

   INSERT INTO M_ADD_DG_002_CREDIT
    (
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM   --02 账务机构编号
     ,KHWYM          --03 客户唯一码
     ,KHMC           --04 客户名称
     ,ZSXED          --05 总授信额度
     ,YYED           --06 已用额度
     ,CNYE           --07 承诺余额（元）
     ,CNLB           --08 承诺类别
     ,SYS_SOURCE     --09 来源系统
    )
   SELECT /*+ PARALLEL(A,4) */
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM   --02 账务机构编号
     ,KHWYM          --03 客户唯一码
     ,KHMC           --04 客户名称
     ,ZSXED          --05 总授信额度
     ,YYED           --06 已用额度
     ,CNYE           --07 承诺余额（元）
     ,'01'           --08 承诺类别
     ,SYS_SOURCE     --09 来源系统
   FROM (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_002_CREDIT_ETL A
      WHERE A.DATA_DATE = V_P_DATE
       ) T
   WHERE T.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  --EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_DG_002_CREDIT';

   INSERT INTO M_ADD_DG_002_CREDIT
    (
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM   --02 账务机构编号
     ,KHWYM          --03 客户唯一码
     ,KHMC           --04 客户名称
     ,ZSXED          --05 总授信额度
     ,YYED           --06 已用额度
     ,CNYE           --07 承诺余额（元）
     ,CNLB           --08 承诺类别
     ,SYS_SOURCE     --09 来源系统
    )
   SELECT /*+ PARALLEL(A,4) */
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM   --02 账务机构编号
     ,KHWYM          --03 客户唯一码
     ,KHMC           --04 客户名称
     ,ZSXED          --05 总授信额度
     ,YYED           --06 已用额度
     ,CNYE           --07 承诺余额（元）
     ,'01'           --08 承诺类别
     ,SYS_SOURCE     --09 来源系统
   FROM (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_SOURCE DESC) RN
      FROM ADD_DG_002_CREDIT A
      WHERE A.DATA_DATE = V_P_DATE
       ) T
   WHERE T.RN = 1
     AND NOT EXISTS (SELECT 1 FROM M_ADD_DG_002_CREDIT TT WHERE TT.KHWYM=T.KHWYM AND TT.DATA_DATE=V_P_DATE)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  /* V_STEP      := 3;
   V_STEP_DESC := 'ADD数据与跑批数据插入到目标表';
   V_STARTTIME := SYSDATE;

   INSERT INTO M_ADD_DG_002_CREDIT
    (
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM  --02 账务机构编号
     ,KHWYM          --03 客户唯一码
     ,KHMC          --04 客户名称
     ,ZSXED          --05 总授信额度
     ,YYED          --06 已用额度
     ,CNYE          --07 承诺余额（元）
     ,CNLB          --08 承诺类别
     ,SYS_SOURCE    --09 来源系统
    )
   SELECT \*+ PARALLEL(A,4) *\
      A.DATA_DATE        AS DATA_DATE     --01 数据日期
     ,A.ACCT_ORG_NUM     AS ACCT_ORG_NUM  --02 账务机构编号
     ,A.KHWYM            AS KHWYM         --03 客户唯一码
     ,A.KHMC             AS KHMC          --04 客户名称
     ,A.ZSXED            AS ZSXED         --05 总授信额度
     ,A.YYED             AS YYED          --06 已用额度
     ,NVL(B.CNYE,A.CNYE) AS CNYE          --07 承诺余额（元）
     ,'01'               AS CNLB          --08 承诺类别
     ,A.SYS_SOURCE       AS SYS_SOURCE    --09 来源系统
   FROM RRP_MDL.ADD_DG_002_CREDIT A
   LEFT JOIN TMP_M_ADD_DG_002_CREDIT B
   ON A.KHWYM = B.KHWYM
   WHERE A.DATA_DATE = V_P_DATE
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/
   V_STEP      := 3;
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
    SELECT DATA_DATE,KHWYM,COUNT(1)
      FROM RRP_MDL.M_ADD_DG_002_CREDIT T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,KHWYM
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

END ETL_M_ADD_DG_002_CREDIT;
/

