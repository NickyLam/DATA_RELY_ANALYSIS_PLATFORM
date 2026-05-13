CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_GREEN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_GREEN
  *  功能描述：绿色贷款整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  S_LOAN
  *            M_LOAN_GREEN_SUB
  *            M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *            M_LOAN_AGR_REL_SUB
  *
  *
  *  目标表：  S_LOAN_GREEN
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230129  于敬艺   新增重大环境安全风险企业分类
  *             2    20250515  HYF      新增绿色信贷客户标志、绿色信贷分类_新版代码
  *             3    20250604  HYF      新增贷款投向境内外标识
  *             4    20250911  HYF      新增放款金额、年化收益、贷款实际发放日期
  *             5    20251216  HYF      新增贷款业务类型
  *             6    20260107  HYF      新增客户名称
  *             7    20260128  HYF      新增人行是否融资租赁标志
  ***************************************************************************/
AS
  --定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_STEP_DESC VARCHAR2(1000);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_PART_NAME VARCHAR2(300);              --分区名
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_TAB_NAME  VARCHAR2(100) := 'S_LOAN_GREEN'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_GREEN'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN_GREEN T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_GREEN'||' TRUNCATE PARTITION '||'写上分区名'); --分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_LOAN_GREEN', '1', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '绿色贷款整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_GREEN(
    DATA_DT,                  --数据日期
    LGL_REP_ID,               --法人编号
    ORG_ID,                   --机构编号
    CUST_ID,                  --客户编号
    CUST_NM,                  --客户名称
    RCPT_ID,                  --借据编号
    CUR,                      --币种
    LOAN_BAL,                 --贷款余额
    CUST_LRG_CL,              --客户大类
    CUST_BLNG_IDY,            --客户所属行业
    GRN_CNSMP_FIN_USEAGE_CL,  --绿色消费融资用途分类
    GRN_LOAN_USEAGE_CL,       --绿色贷款用途分类
    GRN_LOAN_USEAGE_CL_1104,  --绿色贷款用途分类1104
    LVL5_CL,                  --五级分类
    MJR_RSK_ENT_CL,           --重大风险企业分类
    CER_MTG_LOAN_FLG,         --以碳排放权为抵押的贷款标志
    ER_MTG_LOAN_FLG,          --以环境权益为抵押的贷款标志
    GRN_LOAN_IDY_CL,          --绿色贷款有关行业分类
    DEPT_LINE,                --部门条线
    DATA_SRC,                 --数据来源
    CUST_TYP,                 --客户类型
    ZDHJAQFXQYFL,             --重大环境安全风险企业分类
    FHLSDKYTFLDHYLB,          --符合绿色贷款用途分类的行业类别
    ACCT_TYP,                 --账户类型
    GREEN_CRDT_CUST_FLG,      --绿色信贷客户标志
    GREEN_CRDT_CLS_NEW,       --绿色信贷分类_新版代码
    LOAN_DIR_BIO_FLG,         --贷款投向境内外标识
    LOAN_AMT,                 --放款金额
    INCOME_ANNUAL,            --年化收益
    LOAN_ACT_DSTR_DT,         --贷款实际发放日期
    LOAN_BIZ_TYP,             --贷款业务类型
    RZZL_PBOC_IND             --人行是否融资租赁标志
    )
  SELECT A.DATA_DT                                                AS DATA_DT,                      --数据日期
         A.LGL_REP_ID                                             AS LGL_REP_ID,                   --法人编号
         A.ORG_ID                                                 AS ORG_ID,                       --机构编号
         A.CUST_ID                                                AS CUST_ID,                      --客户编号
         NVL(C.CUST_NM,D.CUST_NM)                                 AS CUST_NM,                      --客户名称                                          
         A.RCPT_ID                                                AS RCPT_ID,                      --借据编号
         A.CUR                                                    AS CUR,                          --币种
         A.LOAN_NET_VAL                                           AS LOAN_BAL,                     --贷款余额
         CASE WHEN D.CUST_ID IS NOT NULL OR C.CUST_CL = 'E' THEN '01' --对私客户(含个体工商户)
              WHEN C.CUST_ID IS NOT NULL AND C.CUST_CL != 'E' THEN '02' --对公客户（剔除个体工商户）
         END                                                      AS CUST_LRG_CL,                   --客户大类
         NVL(C.CUST_BLNG_IDY, D.CUST_BLNG_IDY)                    AS CUST_BLNG_IDY,                 --客户所属行业
         NULL                                                     AS GRN_CNSMP_FIN_USEAGE_CL,       --绿色消费融资用途分类
         B.GRN_LOAN_USEAGE_CL                                     AS GRN_LOAN_USEAGE_CL,            --绿色贷款用途分类
         B.GRN_LOAN_USEAGE_CL_1104                                AS GRN_LOAN_USEAGE_CL_1104,       --绿色贷款用途分类1104
         A.LVL5_CL                                                AS LVL5_CL,                       --五级分类
         C.MJR_ENV_SAFE_RSK_ENT_CL                                AS MJR_RSK_ENT_CL,                --重大风险企业分类
         B.CER_MTG_LOAN_FLG                                       AS CER_MTG_LOAN_FLG,              --以碳排放权为抵押的贷款标志
         B.ER_MTG_LOAN_FLG                                        AS ER_MTG_LOAN_FLG,               --以环境权益为抵押的贷款标志
         C.GRN_LOAN_IDY_CL                                        AS GRN_LOAN_IDY_CL,               --绿色贷款有关行业分类
         A.DEPT_LINE                                              AS DEPT_LINE,                     --部门条线
         A.DATA_SRC                                               AS DATA_SRC,                      --数据来源
         NVL(C.CUST_CL,D.OPR_CUST_TYP)                            AS CUST_TYP,                      --客户类型
         F.ZDHJAQFXQYFL                                           AS ZDHJAQFXQYFL,                  --重大环境安全风险企业分类
         F.FHLSDKYTFLDHYLB                                        AS FHLSDKYTFLDHYLB,               --符合绿色贷款用途分类的行业类别
         B.ACCT_TYP                                               AS ACCT_TYP,                      --账户类型
         DECODE(B.GREEN_CRDT_CUST_FLG,'1','Y','N')                AS GREEN_CRDT_CUST_FLG,           --绿色信贷客户标志、
         B.GREEN_CRDT_CLS_NEW                                     AS GREEN_CRDT_CLS_NEW,            --绿色信贷分类_新版代码
         A.LOAN_DIR_BIO_FLG                                       AS LOAN_DIR_BIO_FLG,              --贷款投向境内外标识
         A.LOAN_AMT                                               AS LOAN_AMT,                      --放款金额
         A.INCOME_ANNUAL                                          AS INCOME_ANNUAL,                 --年化收益
         A.LOAN_ACT_DSTR_DT                                       AS LOAN_ACT_DSTR_DT,              --贷款实际发放日期
         A.LOAN_BIZ_TYP                                           AS LOAN_BIZ_TYP,                  --贷款业务类型
         CASE WHEN NVL(C.CUST_NM,D.CUST_NM) LIKE '%融资租赁%' AND B.GREEN_CRDT_CLS_NEW NOT IN ('196','269') THEN 'N'
         ELSE 'Y' END                                             AS RZZL_PBOC_IND                  --人行是否融资租赁标志
    FROM RRP_MDL.S_LOAN A --贷款业务整合表
    LEFT JOIN RRP_MDL.M_LOAN_GREEN_SUB B --绿色贷款子表
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = A.CUST_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_AGR_REL_SUB E --涉农贷款子表
      ON E.RCPT_ID = B.RCPT_ID
     AND E.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_ADD_DG_001_CUST F --补录表-对公-客户基表
      ON F.KHWYM = A.CUST_ID
     AND F.DATA_DATE = V_P_DATE--A.DATA_DT
   WHERE (A.PBOC_GRN_LOAN_FLG = 'Y' OR A.CBRC_GRN_LOAN_FLG = 'Y')
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_GREEN;
/

