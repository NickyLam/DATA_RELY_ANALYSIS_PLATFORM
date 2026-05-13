CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_ADD_DG_006_HOUSE_LAND(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_ADD_DG_006_HOUSE_LAND
  *  功能描述：补录表-对公-房地产小基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            IML.PTY_IBANK_CUST_CHAT_INFO  --同业客户特有信息
  *            IML.PTY_PARTY_CERT_INFO_H     --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  M_ADD_DG_006_HOUSE_LAND  --房地产小基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221116  hulj     首次创建。
  *             2    20230531  liuyu    新增重复值校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                              -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                                    -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_M_ADD_DG_006_HOUSE_LAND';  -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'M_ADD_DG_006_HOUSE_LAND';      -- 报表名称
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

   --DELETE FROM M_ADD_DG_006_HOUSE_LAND T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
   ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '继承ADD中补录的数据插入到临时表';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_M_ADD_DG_006_HOUSE_LAND';

   INSERT INTO TMP_M_ADD_DG_006_HOUSE_LAND
    (
     DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZHWYM         --04 账户唯一码
    ,KHWYM         --05 客户唯一码
    ,KHMC          --06 客户名称
    ,ZFZLDKLB      --07 住房租赁贷款类别
    ,BZXZLZFDKLB   --08 保障性租赁住房贷款类别
    ,SYS_SOURCE    --09 来源系统
    )
   SELECT /*+ PARALLEL(T,4) */
     DATA_DATE     --01 数据日期
    ,ACCT_ORG_NUM  --02 账务机构编号
    ,JYWYM         --03 交易唯一码
    ,ZHWYM         --04 账户唯一码
    ,KHWYM         --05 客户唯一码
    ,KHMC          --06 客户名称
    ,ZFZLDKLB      --07 住房租赁贷款类别
    ,BZXZLZFDKLB   --08 保障性租赁住房贷款类别
    ,SYS_SOURCE    --09 来源系统
   FROM (
      SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
      FROM ADD_DG_006_HOUSE_LAND_ETL A
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

   V_STEP      := 3;
   V_STEP_DESC := 'ADD数据与跑批数据插入到目标表';
   V_STARTTIME := SYSDATE;

   INSERT INTO M_ADD_DG_006_HOUSE_LAND
    (
     DATA_DATE,    --01 数据日期,
     ACCT_ORG_NUM, --02 账务机构编号,
     JYWYM,        --03 交易唯一码,
     ZHWYM,        --04 账户唯一码,
     KHWYM,        --05 客户唯一码,
     KHMC,         --06 客户名称,
     ZFZLDKLB,     --07 住房租赁贷款类别,
     BZXZLZFDKLB,  --08 保障性租赁住房贷款类别,
     XMZTZ,        --09 项目总投资,
     XMZBJ,        --10 项目资本金,
     DYHSJE,       --11 当月回收金额,
     ZXDYPPGJZ,    --12 最新的押品评估价值,
     SYS_SOURCE    --13 来源系统
    )
   SELECT /*+ PARALLEL(A,4) */
     NVL(B.DATA_DATE,A.DATA_DATE),       --01 数据日期,
     NVL(B.ACCT_ORG_NUM,A.ACCT_ORG_NUM), --02 账务机构编号,
     NVL(B.JYWYM,A.JYWYM),               --03 交易唯一码,
     NVL(B.ZHWYM,A.ZHWYM),               --04 账户唯一码,
     NVL(B.KHWYM,A.KHWYM),               --05 客户唯一码,
     NVL(B.KHMC,A.KHMC),                 --06 客户名称,
     NVL(B.ZFZLDKLB,A.ZFZLDKLB),         --07 住房租赁贷款类别,
     NVL(B.BZXZLZFDKLB,A.BZXZLZFDKLB),   --08 保障性租赁住房贷款类别,
     NULL,           --09 项目总投资,                 ADD取消，M_ADD不加工
     NULL,           --10 项目资本金,                 ADD取消，M_ADD不加工
     NULL,           --11 当月回收金额,               ADD取消，M_ADD不加工
     NULL,           --12 最新的押品评估价值,         ADD取消，M_ADD不加工
     A.SYS_SOURCE    --13 来源系统
   FROM ADD_DG_006_HOUSE_LAND A
   LEFT JOIN TMP_M_ADD_DG_006_HOUSE_LAND B
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
      FROM RRP_MDL.M_ADD_DG_006_HOUSE_LAND T
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

END ETL_M_ADD_DG_006_HOUSE_LAND;
/

