CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_INTL_ACC_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_INTL_ACC_DTL
  *  功能描述：监管集市银行业银行机构开设的所有内部账户的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ACCT       --内部账户
  *            ICL.CMM_INTNAL_ORG_INFO   --内部机构信息表
  *            ICL.CMM_SUBJ_INFO         --科目信息
  *            ICL.CMM_GL_BAL            --总账余额
  *  目标表：  M_TRA_INTL_ACC_DTL  --内部分户账交易流水
  *
  *  配置表：  IML.REF_PUB_CD       --公共代码表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221011   hulj    调整授权柜员取值。
  *             2    20221122   hulj    增加数据重复校验。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20230201  TANGAN   根据业务卢萌反馈，先去掉交易对手兜底逻辑
  *             7    20241011  LIP      根据east现场检查，调整交易序列号的排序方式，增加原始交易时间戳字段
  *             8    20251027  LTJ      增加挂销账标志字段
  *             9    20260120  LIP      因核算中台中部分用户代码是域账号，根据域账号转换成员工号
  *             9    20260205  LIP      增加核心的内部户对方账号科目、对方行名行号的取数来源
  *             10   20260316  LIP      调整交易时间的取数，按照核心口径，源系统时间戳更准确
  ***************************************************************************/
AS
  --定义变量
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);              --分区名
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLCOUNT2 INTEGER := 0;               --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_INTL_ACC_DTL'; --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_INTL_ACC_DTL'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_TRA_INTL_ACC_DTL T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  ETL_PARTITION_ADD(V_P_DATE,'M_TRA_INTL_ACC_DTL','1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_TRA_INTL_ACC_DTL'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分户账号信息--存款分户信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.CUST_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         A.CDS_LIAB_ACCT_NUM                AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         --NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         'F'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    --FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    FROM (SELECT DISTINCT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
          FROM (
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               AND TRIM(CUST_ACCT_ID) IS NOT NULL
               UNION ALL
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_CARD_NO AS CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               AND TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
          ) T
       ) A
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分户账号信息--内部账户';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.MAIN_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.SUB_ACCT_NUM                     AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         NULL                               AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         '1'                                AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         --NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         'N'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分户账号信息--对公贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.DUBIL_NUM                        AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         '1'                                AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         --NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         'L'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.DUBIL_NUM                        AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         '0'                                AS CORP_ACCT_FLG,            --对公账户标志
         A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         --NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                  --目标机构银行机构名称
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         'P'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--银行卡信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.CARD_NO                          AS ACCT_ID,                  --账户编号
         A.CARD_HOLDER_NAME                 AS ACCT_NAME,                --账户名称
         A.CARD_NO                          AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         NULL                               AS SUBJ_ID,                  --科目编号
         NULL                               AS SUBJ_NAME,                --科目名称
         '0'                                AS CORP_ACCT_FLG,            --对公账户标志
         A.CARD_ISS_ORG_ID                  AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         'C'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
    FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A --银行卡基本信息
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 B
      ON B.CUST_ACCT_ID = A.CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.CARD_ISS_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.CUST_ACCT_ID IS NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230616 对账户信息进行排序并整合到临时表
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--账户信息临时表';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02';
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 NOLOGGING(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG,                     --标志
    RANK,                     --按CUST_ACCT_ID对全部数据排序
    NU                        --按ACCT_ID对数据排序
    )
  SELECT TRIM(ACCT_ID),            --账户编号
         ACCT_NAME,                --账户名称
         TRIM(CUST_ACCT_ID),       --客户账户编号
         CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         CDS_LIAB_ACCT_NUM,        --负债账户编号
         CUST_ID,                  --客户编号
         SUBJ_ID,                  --科目编号
         SUBJ_NAME,                --科目名称
         CORP_ACCT_FLG,            --对公账户标志
         BELONG_ORG_ID,            --所属机构编号
         ORG_ID1,                  --目标机构号
         FIN_INST_CODE,            --目标机构银行机构代码
         ORG_NAME,                 --目标机构银行机构名称
         FLAG,                      --标志
         ROW_NUMBER() OVER(PARTITION BY TRIM(CUST_ACCT_ID)
                               ORDER BY CASE WHEN FLAG = 'F' THEN 1  --F分户
                                             WHEN FLAG = 'N' THEN 2  --N内部户
                                             WHEN FLAG = 'L' THEN 3  --L对公贷款
                                             WHEN FLAG = 'P' THEN 4  --P零售贷款
                                             WHEN FLAG = 'C' THEN 5  --C主账户
                                         END,ACCT_ID) AS RANK, --按CUST_ACCT_ID对全部数据排序
         ROW_NUMBER() OVER(PARTITION BY TRIM(ACCT_ID)
                               ORDER BY CASE WHEN FLAG = 'F' THEN 1
                                             WHEN FLAG = 'L' THEN 2
                                             WHEN FLAG = 'N' THEN 3
                                             ELSE 4
                                         END,CUST_ACCT_ID)    AS NU --按ACCT_ID对数据排序
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易信息临时表处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04 NOLOGGING
    (DATA_DT             ,  --数据日期
     TRAN_DT             ,  --交易日期
     TRAN_FLOW_NUM       ,  --交易流水号
     TRA_SEQ_NO          ,  --交易流水号
     OPP_ACC_ID          ,  --对方账户ID
     OPP_CUST_ACCT_ID    ,  --对方账户
     OPP_SUB_ACCT_ID     ,  --对方账户子序号
     NU                     --序号
     )
  /*SELECT \*+USE_HASH(A,B,X,E,C,F,D,G)*\
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
         A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
         A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
         COALESCE(TRIM(B.DEP_SUB_ACCT_ID),TRIM(X.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID,      --对方账户ID
         TRIM(A.CNTPTY_ACCT_ID)                                                        AS OPP_CUST_ACCT_ID,--对方账户
         TRIM(A.CNTPTY_SUB_ACCT_ID)                                                    AS OPP_SUB_ACCT_ID, --对方账户子序号
         ROW_NUMBER() OVER(PARTITION BY A.TRAN_DT,A.TRAN_FLOW_NUM,A.ACCT_BILL_FLOW_NUM
                      ORDER BY COALESCE(B.TRAN_AMT,X.TRAN_AMT) DESC)                   AS NU --序号
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT D --内部账户
      ON \*D.SUB_ACCT_NUM = A.SUB_ACCT_ID AND*\ \*A.CUST_ID*\ A.DEP_SUB_ACCT_ID = D.ACCT_ID
     AND SUBSTR(D.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL B --存款分户账交易明细
      ON B.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND B.TRAN_DT = A.TRAN_DT
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL X --内部帐户交易明细
      ON X.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND X.TRAN_DT = A.TRAN_DT
     AND X.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');*/  ---modify by tangan ta 20220111
    SELECT T.DATA_DT        AS DATA_DT             ,  --数据日期
           T.TRAN_DT        AS TRAN_DT             ,  --交易日期
           T.TRAN_FLOW_NUM  AS TRAN_FLOW_NUM       ,  --交易流水号
           T.TRA_SEQ_NO     AS TRA_SEQ_NO          ,  --交易流水号
           T.OPP_ACC_ID     AS OPP_ACC_ID          ,  --对方账户ID
           NULL             AS OPP_CUST_ACCT_ID    ,  --对方账户
           NULL             AS OPP_SUB_ACCT_ID     ,  --对方账户子序号
           1                AS NU                     --序号
     FROM (--交易方向为D-借方，对手方应该取C-贷方信息
    SELECT DISTINCT
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
           A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
           A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
           /*COALESCE(TRIM(C.DEP_SUB_ACCT_ID),TRIM(A.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID       --对方账户ID*/
           TRIM(C.DEP_SUB_ACCT_ID)                                                       AS OPP_ACC_ID       --对方账户ID
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
     INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT  B --内部账户
        ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (SELECT DISTINCT TRAN_FLOW_NUM, DEP_SUB_ACCT_ID, TRAN_CURR_CD, CUST_ACCT_ID, SUB_ACCT_ID
                   FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL AA --存款账户交易明细
                  WHERE AA.DEBIT_CRDT_DIR_CD = 'C' --贷方
                    AND AA.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) C
        ON C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
       AND C.TRAN_CURR_CD = A.TRAN_CURR_CD
       AND C.CUST_ACCT_ID = NVL(TRIM(A.CNTPTY_ACCT_ID),A.CUST_ACCT_ID)
       AND C.SUB_ACCT_ID = NVL(TRIM(A.CNTPTY_SUB_ACCT_ID),A.SUB_ACCT_ID)
     WHERE SUBSTR(B.SUBJ_ID,1,4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
       AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
       AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --交易方向为C-贷方，对手方应该取D-借方信息
    SELECT DISTINCT
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
           A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
           A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
           /*COALESCE(TRIM(C.DEP_SUB_ACCT_ID),TRIM(A.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID       --对方账户ID*/
           TRIM(C.DEP_SUB_ACCT_ID)                                                       AS OPP_ACC_ID       --对方账户ID
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
     INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
        ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN (SELECT DISTINCT TRAN_FLOW_NUM, DEP_SUB_ACCT_ID, TRAN_CURR_CD, CUST_ACCT_ID, SUB_ACCT_ID
                   FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL AA --存款账户交易明细
                  WHERE AA.DEBIT_CRDT_DIR_CD = 'D'  --借方
                    AND AA.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) C
        ON C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
       AND C.TRAN_CURR_CD = A.TRAN_CURR_CD
       AND C.CUST_ACCT_ID = NVL(TRIM(A.CNTPTY_ACCT_ID),A.CUST_ACCT_ID)
       AND C.SUB_ACCT_ID = NVL(TRIM(A.CNTPTY_SUB_ACCT_ID),A.SUB_ACCT_ID)
     WHERE SUBSTR(B.SUBJ_ID,1,4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
       AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
       AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表1-核心借方找贷方';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,         --数据日期
     TRA_SEQ_NO,      --交易流水号
     ACC_ID,          --对方账户ID
     OPP_SUBJ_ID,     --对方科目编号
     OPP_SUBJ_NM,     --对方科目名称
     OPP_ACC,         --对方账号
     OPP_ACC_NM,      --对方户名
     OPP_PBC_NO,      --对方行号
     OPP_BANK_NM,     --对方行名
     TRA_TLR_NO,      --交易柜员号
     GRANT_TLR_NO,    --授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
    /*WITH ACC_DTL_TEMP01 AS (
    SELECT
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG,                      --标志
    ROW_NUMBER() OVER(PARTITION BY ACCT_ID ORDER BY CASE WHEN FLAG = 'F' THEN 1
                                                         WHEN FLAG = 'L' THEN 2
                                                         WHEN FLAG = 'N' THEN 3
                                                         ELSE 4
                                                    END)       AS NU --序号  --modify by tangan at 20230111
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01)
    SELECT \*+USE_HASH(A,F,D,G)*\
         A.DATA_DT                                              AS DATA_DT,     --数据日期
         A.TRA_SEQ_NO                                           AS TRA_SEQ_NO,  --交易流水号
         COALESCE(F.ACCT_ID,D.ACCT_ID,G.ACCT_ID)                AS ACC_ID,      --对方账户ID
         COALESCE(F.SUBJ_ID,D.SUBJ_ID,G.SUBJ_ID)                AS OPP_SUBJ_ID, --对方科目编号
         COALESCE(F.SUBJ_NAME,D.SUBJ_NAME,G.SUBJ_NAME)          AS OPP_SUBJ_NM, --对方科目名称
         COALESCE(F.CUST_ACCT_ID,D.CUST_ACCT_ID,G.CUST_ACCT_ID) AS OPP_ACC, -- 对方账户号
         COALESCE(F.ACCT_NAME,D.ACCT_NAME,G.ACCT_NAME)          AS OPP_ACC_NM,  --对方户名
         COALESCE(F.FIN_INST_CODE,D.FIN_INST_CODE,G.FIN_INST_CODE) AS OPP_PBC_NO, --对方行号
         COALESCE(F.ORG_NAME,D.ORG_NAME,G.ORG_NAME)             AS OPP_BANK_NM --对方行名
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04 A --交易信息临时表
    LEFT JOIN ACC_DTL_TEMP01 F --分户账号信息--临时表
      ON F.ACCT_ID = A.OPP_ACC_ID
     AND F.NU = 1  --modify by tangan at 20230104
    LEFT JOIN ACC_DTL_TEMP01 D --分户账号信息--临时表
      ON D.CUST_ACCT_ID = A.OPP_CUST_ACCT_ID
     AND A.OPP_SUB_ACCT_ID IS NULL
     AND D.FLAG IN ('N','L') --借据、内部户
     AND F.NU = 1  --modify by tangan at 20230104
    LEFT JOIN ACC_DTL_TEMP01 G --分户账号信息--临时表
      ON G.CUST_ACCT_ID = A.OPP_CUST_ACCT_ID
     AND G.CUST_ACCT_SUB_ACCT_NUM = A.OPP_SUB_ACCT_ID
     AND A.OPP_SUB_ACCT_ID IS NOT NULL
     AND G.FLAG IN ('N','F') --借据、内部户
   WHERE A.NU = 1;*/
   WITH INTL_ACC_DTL_TMP01 AS (
    SELECT /*+MATERIALIZE*/A.CNTPTY_ACCT_ID
          ,A.TRAN_FLOW_NUM
          ,A.CUST_ACCT_ID
          ,A.DEP_SUB_ACCT_ID
          ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS CORP_ACCT_FLG
          ,NVL(C.ACCT_NAME,B.ACCT_NAME) AS ACCT_NAME
          ,NVL(C.SUBJ_ID,B.SUBJ_ID) AS SUBJ_ID
          ,NVL(C.SUBJ_NAME,B.SUBJ_NAME) AS SUBJ_NAME
          ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS FIN_INST_CODE
          ,NVL(C.ORG_NAME,B.ORG_NAME) AS ORG_NAME
          ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC ) AS RN
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 B
      ON B.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND B.RANK = 1
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 C
      ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND C.RANK = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(C.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC
          END                                                                 AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_ID
          END                                                                 AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_NM
          END                                                                 AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC/*||'等'*/
          END                                                                 AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ACCT_NAME/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC_NM/*||'等'*/
          END                                                                 AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.FIN_INST_CODE
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_PBC_NO
          END                                                                 AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ORG_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_BANK_NM
          END                                                                 AS OPP_BANK_NM, --对方行名
         TRIM(A.TRAN_TELLER_ID)                                               AS TRA_TLR_NO,  --交易柜员号
         TRIM(A.AUTH_TELLER_ID)                                               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN C.CORP_ACCT_FLG
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CORP_ACCT_FLG
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN '1'
          END                                                                 AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
      ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN INTL_ACC_DTL_TMP01 C
      ON C.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND C.RN = 1
    LEFT JOIN (
         SELECT D1.SOURSQ, REGEXP_SUBSTR(D1.SRVCSQ,'[0-9]+') AS SRVCSQ, D1.BSNSSQ, D1.AMNTCD, D1.TRANAM, D1.ITEMCD, D1.ITEMNA
               ,D1.ACCTBR || D1.ITEMCD || D1.CRCYCD AS OPP_ACC
               ,D1.ITEMNA AS OPP_ACC_NM
               ,D2.FIN_INST_CODE AS OPP_PBC_NO
               ,D1.ITEMCD AS OPP_SUBJ_ID
               ,D1.ITEMNA AS OPP_SUBJ_NM
               --,D2.ORG_NAME AS OPP_BANK_NM
               ,D2.BKNAME AS OPP_BANK_NM
               ,ROW_NUMBER() OVER(PARTITION BY D1.SOURSQ,D1.SRVCSQ,D1.BSNSSQ ORDER BY D1.TRANAM DESC) AS RN
           FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H D1
           LEFT JOIN RRP_MDL.ORG_CONFIG D2
             ON D2.ORG_ID = D1.ACCTBR
          WHERE D1.STACID = 1
            AND D1.SYSTID = 'NCBS'
            AND D1.AMNTCD = 'C' --借方
            AND D1.TRANDT = V_P_DATE) D
      ON D.BSNSSQ = A.OVA_FLOW_NUM
     AND D.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND D.SOURSQ = A.TRAN_FLOW_NUM
     AND D.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表2-核心贷方找借方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
  WITH INTL_ACC_DTL_TMP02 AS(
    SELECT /*+MATERIALIZE*/A.CNTPTY_ACCT_ID
          ,A.TRAN_FLOW_NUM
          ,A.CUST_ACCT_ID
          ,A.DEP_SUB_ACCT_ID
          ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS CORP_ACCT_FLAG
          ,NVL(C.ACCT_NAME,B.ACCT_NAME) AS ACCT_NAME
          ,NVL(C.SUBJ_ID,B.SUBJ_ID) AS SUBJ_ID
          ,NVL(C.SUBJ_NAME,B.SUBJ_NAME) AS SUBJ_NAME
          ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS FIN_INST_CODE
          ,NVL(C.ORG_NAME,B.ORG_NAME) AS ORG_NAME
          ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC ) AS RN
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
     INNER JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 B
        ON B.CUST_ACCT_ID = A.CUST_ACCT_ID
       AND B.RANK = 1
      LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 C
        ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
       AND C.RANK = 1
     WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
       AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
       AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
       AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(C.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC
          END                                                                 AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_ID
          END                                                                 AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_NM
          END                                                                 AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC/*||'等'*/
          END                                                                 AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ACCT_NAME/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC_NM/*||'等'*/
          END                                                                 AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.FIN_INST_CODE
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_PBC_NO
          END                                                                 AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ORG_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_BANK_NM
          END                                                                 AS OPP_BANK_NM, --对方行名
         TRIM(A.TRAN_TELLER_ID)                                               AS TRA_TLR_NO,  --交易柜员号
         TRIM(A.AUTH_TELLER_ID)                                               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN C.CORP_ACCT_FLAG
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CORP_ACCT_FLAG
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN '1'
          END                                                                 AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
      ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN INTL_ACC_DTL_TMP02 C
      ON C.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND C.RN = 1
    LEFT JOIN (
         SELECT D1.SOURSQ, REGEXP_SUBSTR(D1.SRVCSQ,'[0-9]+') AS SRVCSQ, D1.BSNSSQ, D1.AMNTCD, D1.TRANAM, D1.ITEMCD, D1.ITEMNA
               ,D1.ACCTBR || D1.ITEMCD || D1.CRCYCD AS OPP_ACC
               ,D1.ITEMNA AS OPP_ACC_NM
               ,D2.FIN_INST_CODE AS OPP_PBC_NO
               ,D1.ITEMCD AS OPP_SUBJ_ID
               ,D1.ITEMNA AS OPP_SUBJ_NM
               --,D2.ORG_NAME AS OPP_BANK_NM
               ,D2.BKNAME AS OPP_BANK_NM
               ,ROW_NUMBER() OVER(PARTITION BY D1.SOURSQ,D1.SRVCSQ,D1.BSNSSQ ORDER BY D1.TRANAM DESC) AS RN
           FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H D1
           LEFT JOIN RRP_MDL.ORG_CONFIG D2
             ON D2.ORG_ID = D1.ACCTBR
          WHERE D1.STACID = 1
            AND D1.SYSTID = 'NCBS'
            AND D1.AMNTCD = 'D' --借方
            AND D1.TRANDT = V_P_DATE) D
      ON D.BSNSSQ = A.OVA_FLOW_NUM
     AND D.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND D.SOURSQ = A.TRAN_FLOW_NUM
     AND D.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表3--核算中台贷方找借方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
    WITH TGLS_GLA_VCHR_H AS (
      SELECT /*+MATERIALIZE*/A.TRANSQ
            ,A.VCHRSQ
            ,A.ACCTBR || A.ITEMCD || A.CRCYCD AS OPP_ACC     --对方账号
            ,'1'                              AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,A.ITEMCD                         AS OPP_SUBJ_ID --对方科目编号
            ,A.ITEMNA                         AS OPP_SUBJ_NM --对方科目名称
            ,A.ITEMNA                         AS OPP_ACC_NM  --对方户名
            ,B.FIN_INST_CODE                  AS OPP_PBC_NO  --对方行号
            --,B.ORG_NAME                       AS OPP_BANK_NM --对方行名
            ,B.BKNAME                         AS OPP_BANK_NM --对方行名
            ,A.TRANAM
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ,A.TRANAM ORDER BY A.VCHRSQ DESC) AS RN
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ ORDER BY A.TRANAM DESC) AS RAN
        FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A --核算中台的交易表
        LEFT JOIN RRP_MDL.ORG_CONFIG B
          ON B.ORG_ID = A.ACCTBR
       WHERE A.STACID = 1  --基础账套
         AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
         AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
              OR A.ITEMCD IN ('30010101','30010251','30010253'))  --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
         AND ((A.AMNTCD = 'C' AND A.TRANAM < 0) OR (A.AMNTCD = 'D' AND A.TRANAM > 0))  --借方
         AND A.TRANDT = V_P_DATE
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    DEP_ACCT_TRAN_DTL AS (
      SELECT /*+MATERIALIZE*/A.TRAN_FLOW_NUM
            ,A.ACCT_BILL_FLOW_NUM
            ,A.OVA_FLOW_NUM
            ,A.CUST_ACCT_ID                 AS OPP_ACC           --对方账号
            ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,NVL(C.SUBJ_ID,B.SUBJ_ID)       AS OPP_SUBJ_ID       --对方科目编号
            ,NVL(C.SUBJ_NAME,B.SUBJ_NAME)   AS OPP_SUBJ_NM       --对方科目名称
            ,NVL(C.ACCT_NAME,B.ACCT_NAME)   AS OPP_ACC_NM        --对方户名
            ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS OPP_PBC_NO  --对方行号
            ,NVL(C.ORG_NAME,B.ORG_NAME)     AS OPP_BANK_NM       --对方行名
            ,TRIM(A.TRAN_TELLER_ID)         AS TRA_TLR_NO        --交易柜员号
            ,TRIM(A.AUTH_TELLER_ID)         AS GRANT_TLR_NO      --授权柜员号
            ,ROW_NUMBER() OVER(PARTITION BY /*A.TRAN_FLOW_NUM,*/A.OVA_FLOW_NUM ORDER BY A.TRAN_AMT DESC,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D'THEN 1 ELSE 2 END ) AS RN
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
       INNER JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 B
          ON B.CUST_ACCT_ID = A.CUST_ACCT_ID
         AND B.RANK = 1
        LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 C
          ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
         AND C.RANK = 1
       WHERE A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
         --AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
         AND TRIM(REPLACE(A.CUST_ACCT_ID,'0','')) IS NOT NULL
         AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         A.TRANSQ || A.VCHRSQ         AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
         END                          AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_ID)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_ID)
         END                          AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_NM)
         END                          AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
         END                          AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC_NM)
         END                          AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_PBC_NO)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_PBC_NO)
         END                          AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_BANK_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_BANK_NM)
         END                          AS OPP_BANK_NM, --对方行名
         T.TRA_TLR_NO                 AS TRA_TLR_NO,  --交易柜员号
         T.GRANT_TLR_NO               AS GRANT_TLR_NO, --授权柜员号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_CORP_ACCT_FLG)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_CORP_ACCT_FLG)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_CORP_ACCT_FLG)
         END                          AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN TGLS_GLA_VCHR_H F
      ON F.TRANSQ = A.TRANSQ
     AND F.TRANAM = A.TRANAM
     AND F.RN = 1
    LEFT JOIN TGLS_GLA_VCHR_H H
      ON H.TRANSQ = A.TRANSQ
     AND H.RAN = 1
    LEFT JOIN DEP_ACCT_TRAN_DTL T
      ON T.OVA_FLOW_NUM = A.BSNSSQ
     /*AND T.TRAN_FLOW_NUM = A.SOURSQ*/ 
     AND T.RN = 1
   WHERE A.STACID = 1 --基础账套
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
          OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND ((A.AMNTCD = 'C' AND A.TRANAM > 0) OR (A.AMNTCD = 'D' AND A.TRANAM < 0)) --贷方
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表4-核算中台借方找贷方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    )
    WITH TGLS_GLA_VCHR_H AS (
      SELECT /*+MATERIALIZE*/A.TRANSQ
            ,A.VCHRSQ
            ,A.ACCTBR || A.ITEMCD || A.CRCYCD AS OPP_ACC     --对方账号
            ,'1'                              AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,A.ITEMCD                         AS OPP_SUBJ_ID --对方科目编号
            ,A.ITEMNA                         AS OPP_SUBJ_NM --对方科目名称
            ,A.ITEMNA                         AS OPP_ACC_NM  --对方户名
            ,B.FIN_INST_CODE                  AS OPP_PBC_NO  --对方行号
            --,B.ORG_NAME                       AS OPP_BANK_NM --对方行名
            ,B.BKNAME                         AS OPP_BANK_NM --对方行名
            ,A.TRANAM
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ,A.TRANAM ORDER BY A.VCHRSQ DESC ) AS RN
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ ORDER BY A.TRANAM DESC ) AS RAN
        FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
        LEFT JOIN RRP_MDL.ORG_CONFIG B
          ON B.ORG_ID = A.ACCTBR
       WHERE A.STACID = 1  --基础账套
         AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
         AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
             OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
         AND ((A.AMNTCD = 'C' AND A.TRANAM > 0) OR (A.AMNTCD = 'D' AND A.TRANAM < 0)) --贷方
         AND A.TRANDT = V_P_DATE
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    DEP_ACCT_TRAN_DTL AS (
      SELECT /*+MATERIALIZE*/A.TRAN_FLOW_NUM
            ,A.ACCT_BILL_FLOW_NUM
            ,A.OVA_FLOW_NUM
            ,A.CUST_ACCT_ID                   AS OPP_ACC     --对方账号
            ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,NVL(C.SUBJ_ID,B.SUBJ_ID)         AS OPP_SUBJ_ID --对方科目编号
            ,NVL(C.SUBJ_NAME,B.SUBJ_NAME)     AS OPP_SUBJ_NM --对方科目名称
            ,NVL(C.ACCT_NAME,B.ACCT_NAME)     AS OPP_ACC_NM  --对方户名
            ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS OPP_PBC_NO  --对方行号
            ,NVL(C.ORG_NAME,B.ORG_NAME)       AS OPP_BANK_NM--对方行名
            ,TRIM(A.TRAN_TELLER_ID)           AS TRA_TLR_NO  --交易柜员号
            ,TRIM(A.AUTH_TELLER_ID)           AS GRANT_TLR_NO --授权柜员号
            ,ROW_NUMBER() OVER(PARTITION BY /*A.TRAN_FLOW_NUM,*/A.OVA_FLOW_NUM ORDER BY A.TRAN_AMT DESC,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C'THEN 1 ELSE 2 END ) AS RN
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
       INNER JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 B
          ON B.CUST_ACCT_ID = A.CUST_ACCT_ID
         AND B.RANK = 1
        LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 C
          ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
         AND C.RANK = 1
       WHERE TRIM(REPLACE(A.CUST_ACCT_ID,'0','')) IS NOT NULL
         --AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
         AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
         AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         A.TRANSQ || A.VCHRSQ         AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
          END                         AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_ID)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_ID)
          END                         AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_NM)
          END                         AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
          END                         AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC_NM)
          END                         AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_PBC_NO)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_PBC_NO)
          END                         AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_BANK_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_BANK_NM)
          END                         AS OPP_BANK_NM, --对方行名
         T.TRA_TLR_NO                 AS TRA_TLR_NO,  --交易柜员号
         T.GRANT_TLR_NO               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_CORP_ACCT_FLG)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_CORP_ACCT_FLG)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_CORP_ACCT_FLG)
          END                         AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN TGLS_GLA_VCHR_H F
      ON F.TRANSQ = A.TRANSQ
     AND F.TRANAM = A.TRANAM
     AND F.RN = 1
    LEFT JOIN TGLS_GLA_VCHR_H H
      ON H.TRANSQ = A.TRANSQ
     AND H.RAN = 1
    LEFT JOIN DEP_ACCT_TRAN_DTL T
      ON T.OVA_FLOW_NUM = A.BSNSSQ
     /*AND T.TRAN_FLOW_NUM = A.SOURSQ*/ 
     AND T.RN = 1
   WHERE A.STACID = 1  --基础账套
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
         OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND ((A.AMNTCD = 'C' AND A.TRANAM < 0) OR (A.AMNTCD = 'D' AND A.TRANAM > 0)) --借方
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20231221
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表5-微众联合存款：其他-互联网金融往来-贷记';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         TRIM(C.ACCT_ID)              AS ACC_ID,      --对方账户ID
         D.SUBJ_ID                    AS OPP_SUBJ_ID, --对方科目编号
         F.SUBJ_NAME                  AS OPP_SUBJ_NM, --对方科目名称
         TRIM(C.ACCT_ID)              AS OPP_ACC,     --对方账号
         D.ACCT_NAME                  AS OPP_ACC_NM,  --对方户名
         E.FIN_INST_CODE              AS OPP_PBC_NO,  --对方行号
         E.ORG_NAME                   AS OPP_BANK_NM, --对方行名
         A.TRAN_TELLER_ID             AS TRA_TLR_NO,  --交易柜员号
         A.AUTH_TELLER_ID             AS GRANT_TLR_NO,--授权柜员号
         '0'                          AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_IOL_TGLS_GLA_VCHR_H B --核算中台的交易表
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.AMNTCD = 'D'
     AND B.STACID = '1'
     AND B.SYSTID = 'IFSX'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_EVT_IFS_ACCT_TRAN_DTL C --联合存款账户交易明细
      ON C.TRAN_FLOW_ID = B.SOURSQ
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO D
      ON D.CUST_ACCT_ID = C.ACCT_ID
     AND D.CUST_ACCT_SUB_ACCT_NUM = C.DEP_SUB_ACCT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG E
      ON E.ORG_ID = D.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO F
      ON F.SUBJ_ID = D.SUBJ_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DEBIT_CRDT_DIR_CD = 'C'
     AND A.TRAN_KIND_CD = 'H003' --互联网金融往来-贷记
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账核心交易流水';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,TRA_SEQ_NO                     --交易流水号
    ,ACC_ID                         --账户编号
    ,ORG_ID                         --机构编号
    ,SUBJ_ID                        --科目编号
    ,CUR                            --币种
    ,ACC_NM                         --账户名称
    ,TRA_TYP                        --交易类型
    ,TRA_AMT                        --交易金额
    ,OPP_ACC                        --对方账号
    ,OPP_SUBJ_ID                    --对方科目编号
    ,OPP_SUBJ_NM                    --对方科目名称
    ,OPP_ACC_NM                     --对方户名
    ,OPP_PBC_NO                     --对方行号
    ,OPP_BANK_NM                    --对方行名
    ,TRA_CHAN                       --交易渠道
    ,CASH_TRF_FLG                   --现转标志
    ,TRA_TLR_NO                     --交易柜员号
    ,GRANT_TLR_NO                   --授权柜员号
    ,ENT_ACCT_DT                    --进账日期
    ,WRT_OFF_DT                     --销账日期
    ,ABSTR                          --摘要
    ,FLUSH_PATCH_FLG                --冲补抹标志
    ,TRA_DR_CR_FLG                  --交易借贷标志
    ,TRA_DT                         --交易日期
    ,TRA_TM                         --交易时间
    ,DR_BAL                         --借方余额
    ,CR_BAL                         --贷方余额
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,CORE_TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM             --账单流水号
    ,OVA_FLOW_NUM                   --全局流水号
    ,INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG              --对方对公账户标志 -ADD BY LIP 20241018
    ,SUSPD_WRTOFF_FLG               --挂销账标志 --ADD BY LTJ 20241027
    ,MEMO_CD                        --摘要代码  --ADD BY LTJ 20251215
    )
    WITH TMP_TRA_DTL AS (
  SELECT /*+MATERIALIZE*/ /*+USE_HASH(A,TMP,J,B,D,E,F,BB,BD,K,K1,K2,K3,KK,KKB)*/
          TO_CHAR(A.TRAN_DT,'YYYYMMDD')                     AS DATA_DT          --数据日期
         ,A.LP_ID                                           AS LGL_REP_ID       --法人编号
         --,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO --交易流水号
         --MOD BY LIP 20241011 为方便查询数据，将交易流水号放在最后面
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.ACCT_BILL_FLOW_NUM||A.TRAN_FLOW_NUM AS TRA_SEQ_NO --交易流水号
         ,A.DEP_SUB_ACCT_ID                                 AS ACC_ID           --账户编号
         ,A.ACCT_ORG_ID                                     AS ORG_ID           --机构编号
         ,D.SUBJ_ID                                         AS SUBJ_ID          --科目编号
         ,A.TRAN_CURR_CD                                    AS CUR              --币种
         ,B.ACCT_NAME                                       AS ACC_NM           --账户名称
         ,A.TRAN_KIND_CD                                    AS TRA_TYP          --交易类型  --modify by tangan at 20230105
         ,A.TRAN_AMT                                        AS TRA_AMT          --交易金额
         ,CASE --WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC)
               --WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC)  --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC)
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC)   --modify by tangan at 20230403 调整优先级
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
               --MOD BY 20240327 当是行内账号时，优先取账号ID
               WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
          END                                               AS OPP_ACC          --对方账号
         ,CASE --WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_ID)
               --WHEN TRIM(TC.OPP_SUBJ_ID) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_ID) --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_ID)
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_ID)   --modify by tangan at 20230403 调整优先级
               WHEN TRIM(S2.SUBJ_ID) IS NOT NULL THEN TRIM(S2.SUBJ_ID)
               WHEN TRIM(S1.SUBJ_ID) IS NOT NULL THEN TRIM(S1.SUBJ_ID)
          END                                               AS OPP_SUBJ_ID      --对方科目编号
         ,CASE --WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_NM)
               --WHEN TRIM(TC.OPP_SUBJ_NM) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_NM) --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_NM)
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_NM)   --modify by tangan at 20230403 调整优先级
               WHEN TRIM(S2.SUBJ_NAME) IS NOT NULL THEN TRIM(S2.SUBJ_NAME)
               WHEN TRIM(S1.SUBJ_NAME) IS NOT NULL THEN TRIM(S1.SUBJ_NAME)
          END                                               AS OPP_SUBJ_NM      --对方科目名称
         ,CASE --WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC_NM)
               --WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM)  --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM)
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC_NM)   --modify by tangan at 20230403 调整优先级
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
          END                                               AS OPP_ACC_NM       --对方户名
         ,CASE --WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_PBC_NO)
               --WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))  --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_PBC_NO)  --modify by tangan at 20230403 调整优先级
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID))
          END                                               AS OPP_PBC_NO       --对方行号
         ,CASE --WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.BKNAME),TRIM(TC.OPP_BANK_NM))  --modify by tangan at 20230207
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.BKNAME),TRIM(TC.OPP_BANK_NM))
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_BANK_NM)  --modify by tangan at 20230403 调整优先级
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.BKNAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.BKNAME),TRIM(A.CNTPTY_OPEN_BANK_NAME))
           END                                              AS OPP_BANK_NM      --对方行名
         /*---MODIFY BY TANGAN AT 20230201 应业务卢萌要求修改 END----*/
         /*UPDATE BY CXL 20220516*/
         --,NVL(K1.TAR_VALUE_CODE,'99-0000')                  AS TRA_CHAN         --交易渠道
         ,A.CHN_CD                                          AS TRA_CHAN         --交易渠道 --MODIFY BY TANGAN AT 20221205
         ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' --现
               WHEN A.CASH_TRANS_FLG = '0' THEN '2' --转
               ELSE '2'
          END                                               AS CASH_TRF_FLG     --现转标志 --modify by tangan at 20230215
         ,TRIM(A.ENTRY_TELLER_ID)                           AS TRA_TLR_NO       --交易柜员号
         ,TRIM(A.AUTH_TELLER_ID)                            AS GRANT_TLR_NO     --授权柜员号
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS ENT_ACCT_DT      --进账日期
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS WRT_OFF_DT       --销账日期
         ,TRIM(REPLACE(REPLACE(NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB),CHR(10),''),CHR(13),'')) AS ABSTR  --摘要
         ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4'--抹账  --modify by tangan at 20230106 码值调整CD1674
               WHEN A.REVS_FLG = '1' THEN '2' --冲账
               WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%冲账%' THEN '2' --冲账
               ELSE '1'  --正常
           END                                              AS FLUSH_PATCH_FLG  --冲补抹标志
         ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD) AS TRA_DR_CR_FLG --交易借贷标志
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS TRA_DT           --交易日期
         --MODIFY BY 蔡正伟 20220429 修改核心交易时间加工逻辑 BEGIN
         --,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT,'YYYYMMDD'),'YYYYMMDD HH24:MI:SS') AS TRA_TM --交易时间
         --,A.TRAN_TIMESTAMP                                  AS TRA_TM           --交易时间
         ,A.INIT_TRAN_TIMESTAMP                             AS TRA_TM --交易时间 --MOD BY LIP 20260316 根据旭颖反馈，源系统交易时间戳更准确
         --MODIFY BY 蔡正伟 20220429 修改核心交易时间加工逻辑 END
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN A.TRAN_BAL
               ELSE 0
           END                                              AS DR_BAL           --借方余额
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C' THEN A.TRAN_BAL
               ELSE 0
           END                                              AS CR_BAL           --贷方余额
         ,'800001'                                          AS DEPT_LINE        --部门条线 /*营运管理部*/
         --,SUBSTR(A.JOB_CD, 0, 4)                            AS DATA_SRC         --数据来源
         ,'核心数据'                                        AS DATA_SRC         --数据来源
         ,A.TRAN_FLOW_NUM                                   AS CORE_TRAN_FLOW_NUM  --核心交易流水号
         ,A.ACCT_BILL_FLOW_NUM                              AS ACCT_BILL_FLOW_NUM  --账单流水号
         ,A.OVA_FLOW_NUM                                    AS OVA_FLOW_NUM        --全局流水号
         ,TO_CHAR(A.INIT_TRAN_TIMESTAMP,'YYYYMMDDHH24MISSFF') AS INIT_TRAN_TIMESTAMP --原交易时间戳 --ADD BY LIP 20241011
         ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL AND TC.OPP_CORP_ACCT_FLG IS NOT NULL
               THEN TC.OPP_CORP_ACCT_FLG
               WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL
               AND NVL(TRIM(B3.BKNAME),TRIM(TC.OPP_BANK_NM)) LIKE '%华兴%'
               THEN NVL(TRIM(S1.CORP_ACCT_FLG),TRIM(S2.CORP_ACCT_FLG))
               WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_CORP_ACCT_FLG)
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL AND NVL(TRIM(B2.BKNAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))  LIKE '%华兴%'
               THEN NVL(TRIM(S1.CORP_ACCT_FLG),TRIM(S2.CORP_ACCT_FLG))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL AND NVL(TRIM(B2.BKNAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))  LIKE '%华兴%'
               THEN NVL(TRIM(S1.CORP_ACCT_FLG),TRIM(S2.CORP_ACCT_FLG))
          END                                               AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
          ,B.SUSPD_WRTOFF_FLG                               AS SUSPD_WRTOFF_FLG  --挂销账标志字段 --ADD BY LTJ 20251027
          ,A.MEMO_CD                                        AS MEMO_CD           --摘要代码  --ADD BY LTJ 20251215
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
      ON /*B.SUB_ACCT_NUM = A.SUB_ACCT_ID
     AND*/ B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND NVL(B.TRAVEL_CARD_ACCT_FLG,'0') = '0' --MOD BY LIP 20241101 过滤旅通卡母户,虚户从分户表取
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DATA_DT,     --数据日期
                     TRA_SEQ_NO,  --交易流水号
                     ACC_ID,      --对方账户ID
                     OPP_SUBJ_ID, --对方科目编号
                     OPP_SUBJ_NM, --对方科目名称
                     OPP_ACC,     --对方账号
                     OPP_ACC_NM,  --对方户名
                     OPP_PBC_NO,  --对方行号
                     OPP_BANK_NM, --对方行名
                     OPP_CORP_ACCT_FLG, --对方对公账户标志 -ADD BY LIP 20241018
                     ROW_NUMBER() OVER(PARTITION BY TRA_SEQ_NO ORDER BY OPP_ACC NULLS LAST) AS RN
              FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP
              WHERE DATA_DT = V_P_DATE) TMP
      ON TMP.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
     AND TMP.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO D --科目信息
      ON D.SUBJ_ID = B.SUBJ_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP03 E --MODIFY BY LIP 20220726
      ON E.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND E.TRAN_DT = A.TRAN_DT
    --MODIFY BY 蔡正伟 20220429 修改核心交易时间/摘要加工逻辑 END
    LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB K --modify by tangan at 20230203
      ON K.MEMO_CODE = A.MEMO_CD
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP K1  --交易渠道
      ON K1.SRC_VALUE_CODE = A.CHN_CD
     AND K1.SRC_CLASS_CODE = 'CD1751'
     AND K1.TAR_CLASS_CODE = 'Z0014'
     AND K1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_MID_TRA_CNTPTY_INFO TC --交易对手信息中间表 --add by tangan at 20230207
      ON TC.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
     --AND TC.TRA_DT = TO_CHAR(A.TRAN_DT,'YYYYMMDD')
     AND TC.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG B1  --MODIFY BY TANGAN AT 20230201
      ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B2  --MODIFY BY TANGAN AT 20230201
      ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN RRP_MDL.ORG_CONFIG B3  --MODIFY BY TANGAN AT 20230207
      ON B3.ORG_ID = TC.OPP_PBC_NO
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 S1 --modify by tangan at 20230201
      --ON S1.ACCT_ID = NVL(NVL(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
      --MOD BY 20240327
      ON S1.ACCT_ID = COALESCE(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID),DECODE(NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0'),'0','',TRIM(A.CNTPTY_INTER_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
      --ON NVL(NVL(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.CNTPTY_ACCT_ID)),TRIM(TC.OPP_ACC)) = S1.ACCT_ID
     AND S1.NU = 1
     AND S1.ACCT_ID IS NOT NULL
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 S2 --MODIFY BY TANGAN AT 20230201
      --ON S2.CUST_ACCT_ID = NVL(NVL(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
      --MOD BY 20240327
      ON S2.CUST_ACCT_ID = COALESCE(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID),DECODE(NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0'),'0','',TRIM(A.CNTPTY_INTER_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
      --ON NVL(NVL(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.CNTPTY_ACCT_ID)),TRIM(TC.OPP_ACC)) = S2.CUST_ACCT_ID
     AND S2.RANK = 1
     AND S2.CUST_ACCT_ID IS NOT NULL
   WHERE A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND SUBSTR(B.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801') --不用上报科目
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
     ADR AS ( --ADD BY LIP 20251225
  SELECT /*+MATERIALIZE*/TRIM(BIC) AS BIC,TRIM(NAM1)||TRIM(NAM2)||TRIM(NAM3) AS NAM,TRIM(STR1)||TRIM(STR2) AS ADDSTR,
         ROW_NUMBER() OVER(PARTITION BY BIC ORDER BY INR) RN
    FROM RRP_MDL.O_IOL_ISBS_ADR T --存放所有PARTY的地址信息 --STFPRD.ADR
   WHERE TRIM(BIC) IS NOT NULL
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.DATA_DT                        --数据日期
        ,T.LGL_REP_ID                     --法人编号
        ,T.TRA_SEQ_NO                     --交易流水号
        ,T.ACC_ID                         --账户编号
        ,T.ORG_ID                         --机构编号
        ,T.SUBJ_ID                        --科目编号
        ,T.CUR                            --币种
        ,T.ACC_NM                         --账户名称
        ,T.TRA_TYP                        --交易类型
        ,T.TRA_AMT                        --交易金额
        ,T.OPP_ACC                        --对方账号
        ,CASE WHEN TRIM(T.OPP_SUBJ_ID) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(T1.SUBJ_ID) IS NOT NULL THEN TRIM(T1.SUBJ_ID)
              WHEN TRIM(T4.SUBJ_ID) IS NOT NULL THEN TRIM(T4.SUBJ_ID) --ADD BY LIP 20260205
          END AS OPP_SUBJ_ID              --对方科目编号
        ,CASE WHEN TRIM(T.OPP_SUBJ_NM) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(T1.SUBJ_NAME) IS NOT NULL THEN TRIM(T1.SUBJ_NAME)
              WHEN TRIM(T4.SUBJ_NAME) IS NOT NULL THEN TRIM(T4.SUBJ_NAME) --ADD BY LIP 20260205
          END AS OPP_SUBJ_NM              --对方科目名称
        ,CASE WHEN TRIM(T.OPP_ACC_NM) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(T1.ACCT_NAME) IS NOT NULL THEN TRIM(T1.ACCT_NAME)
              WHEN TRIM(T4.ACCT_NAME) IS NOT NULL THEN TRIM(T4.ACCT_NAME) --ADD BY LIP 20260205
          END AS OPP_ACC_NM               --对方户名
        ,CASE WHEN TRIM(T.OPP_PBC_NO) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(T1.FIN_INST_CODE) IS NOT NULL THEN TRIM(T1.FIN_INST_CODE)
              WHEN TRIM(T4.FIN_INST_CODE) IS NOT NULL THEN TRIM(T4.FIN_INST_CODE) --ADD BY LIP 20260205
          END AS OPP_PBC_NO               --对方行号
        ,CASE WHEN T5.NAM IS NOT NULL THEN T5.NAM --ADD BY LIP 20251225
              WHEN T6.INSTNA IS NOT NULL THEN T6.INSTNA --ADD BY LIP 20250105
              WHEN TRIM(T.OPP_BANK_NM) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN T2.ORG_NAME IS NOT NULL THEN T2.ORG_NAME --MOD BY LIP 20231010
              WHEN T3.BKNAME IS NOT NULL THEN T3.BKNAME --MOD BY LIP 20231010
              WHEN TRIM(T1.ORG_NAME) IS NOT NULL THEN TRIM(T1.ORG_NAME)
              WHEN TRIM(T4.ORG_NAME) IS NOT NULL THEN TRIM(T4.ORG_NAME)
          END AS OPP_BANK_NM              --对方行名
        ,T.TRA_CHAN                       --交易渠道
        ,T.CASH_TRF_FLG                   --现转标志
        ,T.TRA_TLR_NO                     --交易柜员号
        ,T.GRANT_TLR_NO                   --授权柜员号
        ,T.ENT_ACCT_DT                    --进账日期
        ,T.WRT_OFF_DT                     --销账日期
        ,T.ABSTR                          --摘要
        ,T.FLUSH_PATCH_FLG                --冲补抹标志
        ,T.TRA_DR_CR_FLG                  --交易借贷标志
        ,T.TRA_DT                         --交易日期
        ,T.TRA_TM                         --交易时间
        ,T.DR_BAL                         --借方余额
        ,T.CR_BAL                         --贷方余额
        ,T.DEPT_LINE                      --部门条线
        ,T.DATA_SRC                       --数据来源
        ,T.CORE_TRAN_FLOW_NUM             --核心交易流水号
        ,T.ACCT_BILL_FLOW_NUM             --账单流水号
        ,T.OVA_FLOW_NUM                   --全局流水号
        ,T.INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
        ,CASE WHEN TRIM(T.OPP_BANK_NM) LIKE '%华兴%' AND T1.CUST_ACCT_ID IS NOT NULL THEN NVL(T1.CORP_ACCT_FLG,T4.CORP_ACCT_FLG)
              WHEN T2.ORG_NAME LIKE '%华兴%' AND T1.CUST_ACCT_ID IS NOT NULL THEN NVL(T1.CORP_ACCT_FLG,T4.CORP_ACCT_FLG)
              WHEN T3.BKNAME LIKE '%华兴%' AND T1.CUST_ACCT_ID IS NOT NULL THEN NVL(T1.CORP_ACCT_FLG,T4.CORP_ACCT_FLG)
              WHEN TRIM(T1.ORG_NAME) LIKE '%华兴%' AND T1.CUST_ACCT_ID IS NOT NULL THEN NVL(T1.CORP_ACCT_FLG,T4.CORP_ACCT_FLG)
              ELSE T.OPP_CORP_ACCT_FLG
          END AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
        ,T.SUSPD_WRTOFF_FLG               --挂销账标志 --ADD BY LTJ 20241027
        ,T.MEMO_CD                        --摘要代码  --ADD BY LTJ 20251215
    FROM TMP_TRA_DTL T
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 T1
      ON T1.CUST_ACCT_ID = T.OPP_ACC
     AND T1.CUST_ACCT_ID IS NOT NULL
     AND T1.RANK = 1
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 T4
      ON T4.ACCT_ID = T.OPP_ACC
     AND T4.ACCT_ID IS NOT NULL
     AND T4.NU = 1
    LEFT JOIN RRP_MDL.ADD_BANK_NAME_YL T2
      ON T2.YLH = TRIM(T.OPP_PBC_NO)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T3
      ON T3.BKCD = TRIM(T.OPP_PBC_NO)
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ADR T5 --ADD BY LIP 20251225
      ON T5.BIC = TRIM(T.OPP_PBC_NO)
     AND T5.RN = 1
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A51UBINSTID T6 --中台的银联机构信息表 --ADD BY LIP 20260105
      ON T6.INSTID = TRIM(T.OPP_PBC_NO)
     AND T6.RM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20241106 增加旅通卡数据加工口径
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账核心交易流水--旅通卡数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,TRA_SEQ_NO                     --交易流水号
    ,ACC_ID                         --账户编号
    ,ORG_ID                         --机构编号
    ,SUBJ_ID                        --科目编号
    ,CUR                            --币种
    ,ACC_NM                         --账户名称
    ,TRA_TYP                        --交易类型
    ,TRA_AMT                        --交易金额
    ,OPP_ACC                        --对方账号
    ,OPP_SUBJ_ID                    --对方科目编号
    ,OPP_SUBJ_NM                    --对方科目名称
    ,OPP_ACC_NM                     --对方户名
    ,OPP_PBC_NO                     --对方行号
    ,OPP_BANK_NM                    --对方行名
    ,TRA_CHAN                       --交易渠道
    ,CASH_TRF_FLG                   --现转标志
    ,TRA_TLR_NO                     --交易柜员号
    ,GRANT_TLR_NO                   --授权柜员号
    ,ENT_ACCT_DT                    --进账日期
    ,WRT_OFF_DT                     --销账日期
    ,ABSTR                          --摘要
    ,FLUSH_PATCH_FLG                --冲补抹标志
    ,TRA_DR_CR_FLG                  --交易借贷标志
    ,TRA_DT                         --交易日期
    ,TRA_TM                         --交易时间
    ,DR_BAL                         --借方余额
    ,CR_BAL                         --贷方余额
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,CORE_TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM             --账单流水号
    ,OVA_FLOW_NUM                   --全局流水号
    ,INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG              --对方对公账户标志 -ADD BY LIP 20241018
    ,MEMO_CD                        --摘要代码  --ADD BY LTJ 20251215
    )
    WITH ADR AS ( --ADD BY LIP 20251225
  SELECT /*+MATERIALIZE*/TRIM(BIC) AS BIC,TRIM(NAM1)||TRIM(NAM2)||TRIM(NAM3) AS NAM,TRIM(STR1)||TRIM(STR2) AS ADDSTR,
         ROW_NUMBER() OVER(PARTITION BY BIC ORDER BY INR) RN
    FROM RRP_MDL.O_IOL_ISBS_ADR T --存放所有PARTY的地址信息 --STFPRD.ADR
   WHERE TRIM(BIC) IS NOT NULL
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,B,C,K,S1,S2)*/
          V_P_DATE                                          AS DATA_DT          --数据日期
         ,A.LP_ID                                           AS LGL_REP_ID       --法人编号
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.ACCT_BILL_FLOW_NUM||A.TRAN_FLOW_NUM AS TRA_SEQ_NO --交易流水号
         ,A.DEP_SUB_ACCT_ID                                 AS ACC_ID           --账户编号
         ,A.ACCT_ORG_ID                                     AS ORG_ID           --机构编号
         ,B.SUBJ_ID                                         AS SUBJ_ID          --科目编号
         ,A.TRAN_CURR_CD                                    AS CUR              --币种
         ,B.ACCT_NAME                                       AS ACC_NM           --账户名称
         ,A.TRAN_KIND_CD                                    AS TRA_TYP          --交易类型
         ,A.TRAN_AMT                                        AS TRA_AMT          --交易金额
         ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
               WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
          END                                               AS OPP_ACC          --对方账号
         ,CASE WHEN TRIM(S2.SUBJ_ID) IS NOT NULL THEN TRIM(S2.SUBJ_ID)
               WHEN TRIM(S1.SUBJ_ID) IS NOT NULL THEN TRIM(S1.SUBJ_ID)
          END                                               AS OPP_SUBJ_ID      --对方科目编号
         ,CASE WHEN TRIM(S2.SUBJ_NAME) IS NOT NULL THEN TRIM(S2.SUBJ_NAME)
               WHEN TRIM(S1.SUBJ_NAME) IS NOT NULL THEN TRIM(S1.SUBJ_NAME)
          END                                               AS OPP_SUBJ_NM      --对方科目名称
         ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
          END                                               AS OPP_ACC_NM       --对方户名
         ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL
               THEN COALESCE(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD),TRIM(S1.FIN_INST_CODE),TRIM(S2.FIN_INST_CODE))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL
               THEN COALESCE(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID),TRIM(S1.FIN_INST_CODE),TRIM(S2.FIN_INST_CODE))
          END                                               AS OPP_PBC_NO       --对方行号
         ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL AND T5.NAM IS NOT NULL THEN T5.NAM --ADD BY LIP 20251225
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL AND T6.INSTNA IS NOT NULL THEN T6.INSTNA --ADD BY LIP 20250105
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL
               THEN COALESCE(TRIM(B2.BKNAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME),TRIM(T2.ORG_NAME),TRIM(S1.ORG_NAME),TRIM(S2.ORG_NAME))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL
               THEN COALESCE(TRIM(B1.BKNAME),TRIM(A.CNTPTY_OPEN_BANK_NAME),TRIM(S1.ORG_NAME),TRIM(S2.ORG_NAME))
          END                                               AS OPP_BANK_NM      --对方行名
         ,A.CHN_CD                                          AS TRA_CHAN         --交易渠道
         ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' --现
               WHEN A.CASH_TRANS_FLG = '0' THEN '2' --转
               ELSE '2'
          END                                               AS CASH_TRF_FLG     --现转标志
         ,TRIM(A.ENTRY_TELLER_ID)                           AS TRA_TLR_NO       --交易柜员号
         ,TRIM(A.AUTH_TELLER_ID)                            AS GRANT_TLR_NO     --授权柜员号
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS ENT_ACCT_DT      --进账日期
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS WRT_OFF_DT       --销账日期
         ,TRIM(REPLACE(REPLACE(NVL(TRIM(K.MEMO_CODE_DESCB),A.MEMO_CD_DESCB),CHR(10),''),CHR(13),'')) AS ABSTR  --摘要
         ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4'--抹账
               WHEN A.REVS_FLG = '1' THEN '2' --冲账
               WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%冲账%' THEN '2' --冲账
               ELSE '1'  --正常
           END                                              AS FLUSH_PATCH_FLG  --冲补抹标志
         ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD) AS TRA_DR_CR_FLG --交易借贷标志
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS TRA_DT           --交易日期
         --,A.TRAN_TIMESTAMP                                  AS TRA_TM           --交易时间
         ,A.INIT_TRAN_TIMESTAMP                             AS TRA_TM --交易时间 --MOD BY LIP 20260316 根据旭颖反馈，源系统交易时间戳更准确
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN A.TRAN_BAL
               ELSE 0
           END                                              AS DR_BAL           --借方余额
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C' THEN A.TRAN_BAL
               ELSE 0
           END                                              AS CR_BAL           --贷方余额
         ,'800001'                                          AS DEPT_LINE        --部门条线 /*营运管理部*/
         ,'旅通卡数据'                                      AS DATA_SRC         --数据来源
         ,A.TRAN_FLOW_NUM                                   AS CORE_TRAN_FLOW_NUM  --核心交易流水号
         ,A.ACCT_BILL_FLOW_NUM                              AS ACCT_BILL_FLOW_NUM  --账单流水号
         ,A.OVA_FLOW_NUM                                    AS OVA_FLOW_NUM     --全局流水号
         ,TO_CHAR(A.INIT_TRAN_TIMESTAMP,'YYYYMMDDHH24MISSFF') AS INIT_TRAN_TIMESTAMP --原交易时间戳
         ,NVL(TRIM(S1.CORP_ACCT_FLG),TRIM(S2.CORP_ACCT_FLG))AS OPP_CORP_ACCT_FLG --对方对公账户标志
         ,A.MEMO_CD                                         AS MEMO_CD           --摘要代码  --ADD BY LTJ 20251215
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO B --存款分户信息
      ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO C --存款分户补充信息
      ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND NVL(C.TRAVEL_CARD_ACCT_FLG,'0') = '1' --只取旅通卡虚户
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB K
      ON K.MEMO_CODE = A.MEMO_CD
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG B1
      ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B2
      ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 S1
      ON S1.ACCT_ID = COALESCE(TRIM(A.REAL_CNTPTY_ACCT_ID),DECODE(NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0'),'0','',TRIM(A.CNTPTY_INTER_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
     AND S1.ACCT_ID IS NOT NULL
     AND S1.NU = 1
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP02 S2
      ON S2.CUST_ACCT_ID = COALESCE(TRIM(A.REAL_CNTPTY_ACCT_ID),DECODE(NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0'),'0','',TRIM(A.CNTPTY_INTER_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
     AND S2.CUST_ACCT_ID IS NOT NULL
     AND S2.RANK = 1
    LEFT JOIN RRP_MDL.ADD_BANK_NAME_YL T2
      ON T2.YLH = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN ADR T5 --ADD BY LIP 20251225
      ON T5.BIC = A.REAL_CNTPTY_FIN_INST_CD
     AND T5.RN = 1
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A51UBINSTID T6 --中台的银联机构信息表 --ADD BY LIP 20260105
      ON T6.INSTID = TRIM(A.REAL_CNTPTY_FIN_INST_CD)
     AND T6.RM = 1
   WHERE A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账核算中台交易流水'; --ADD BY TANGAN AT 20230213
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,TRA_SEQ_NO                     --交易流水号
    ,ACC_ID                         --账户编号
    ,ORG_ID                         --机构编号
    ,SUBJ_ID                        --科目编号
    ,CUR                            --币种
    ,ACC_NM                         --账户名称
    ,TRA_TYP                        --交易类型
    ,TRA_AMT                        --交易金额
    ,OPP_ACC                        --对方账号
    ,OPP_SUBJ_ID                    --对方科目编号
    ,OPP_SUBJ_NM                    --对方科目名称
    ,OPP_ACC_NM                     --对方户名
    ,OPP_PBC_NO                     --对方行号
    ,OPP_BANK_NM                    --对方行名
    ,TRA_CHAN                       --交易渠道
    ,CASH_TRF_FLG                   --现转标志
    ,TRA_TLR_NO                     --交易柜员号
    ,GRANT_TLR_NO                   --授权柜员号
    ,ENT_ACCT_DT                    --进账日期
    ,WRT_OFF_DT                     --销账日期
    ,ABSTR                          --摘要
    ,FLUSH_PATCH_FLG                --冲补抹标志
    ,TRA_DR_CR_FLG                  --交易借贷标志
    ,TRA_DT                         --交易日期
    ,TRA_TM                         --交易时间
    ,DR_BAL                         --借方余额
    ,CR_BAL                         --贷方余额
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,CORE_TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM             --账单流水号
    ,OVA_FLOW_NUM                   --全局流水号
    ,INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG              --对方对公账户标志 -ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,TMP,C,B,D,E,F)*/
          A.TRANDT                                AS DATA_DT                        --数据日期
         ,'9999'                                  AS LGL_REP_ID                     --法人编号
         ,A.TRANDT || A.TRANSQ || A.VCHRSQ || A.ACCTBR || A.ITEMCD || A.CRCYCD AS TRA_SEQ_NO --交易流水号
         ,A.ACCTBR || A.ITEMCD || A.CRCYCD        AS ACC_ID                         --账户编号
         ,A.ACCTBR                                AS ORG_ID                         --机构编号
         ,A.ITEMCD                                AS SUBJ_ID                        --科目编号
         ,A.CRCYCD                                AS CUR                            --币种
         ,A.ITEMNA                                AS ACC_NM                         --账户名称
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN 'CS'
               WHEN NVL(A.TRANTP,'*') = '*' THEN '99'
               ELSE A.TRANTP
          END                                     AS TRA_TYP                        --交易类型
         ,ABS(A.TRANAM)                           AS TRA_AMT                        --交易金额  --modify by tangan at 20230528
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_ACCT)
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL THEN TRIM(C.TX_CNTPTY_ACCT_NUM)
               ELSE TRIM(TMP.OPP_ACC)
          END                                     AS OPP_ACC                        --对方账号
         ,CASE WHEN TRIM(A.TOITEM) IS NOT NULL THEN TRIM(A.TOITEM)
               ELSE TRIM(TMP.OPP_SUBJ_ID)
          END                                     AS OPP_SUBJ_ID                    --对方科目编号
         ,CASE WHEN TRIM(B.SUBJ_NAME) IS NOT NULL THEN TRIM(B.SUBJ_NAME)
               ELSE TRIM(TMP.OPP_SUBJ_NM)
          END                                     AS OPP_SUBJ_NM                    --对方科目名称
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_NAME)
               WHEN TRIM(C.TX_CNTPTY_NAME) IS NOT NULL THEN TRIM(C.TX_CNTPTY_NAME)
               ELSE TRIM(TMP.OPP_ACC_NM)
          END                                     AS OPP_ACC_NM                     --对方户名
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_BANK_NO)
               WHEN TRIM(C.CNTPTY_FIN_INST_BRAC_CD) IS NOT NULL THEN TRIM(C.CNTPTY_FIN_INST_BRAC_CD)
               ELSE TRIM(TMP.OPP_PBC_NO)
          END                                     AS OPP_PBC_NO                     --对方行号
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_BANK_NAME)
               WHEN TRIM(C.CNTPTY_FIN_INST_BRAC_NAME) IS NOT NULL THEN TRIM(C.CNTPTY_FIN_INST_BRAC_NAME)
               ELSE TRIM(TMP.OPP_BANK_NM)
          END                                     AS OPP_BANK_NM                    --对方行名
         ,A.ASSIS0                                AS TRA_CHAN                       --交易渠道
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN '1' ELSE '2' END AS CASH_TRF_FLG --现转标志
         --,TMP.TRA_TLR_NO                          AS TRA_TLR_NO                     --交易柜员号
         --MOD BY 20240117 核算中台的交易柜员默认为TGLS0001
         ,CASE --WHEN A.SYSTID IN ('TGLS') THEN 'TGLS0001'
               WHEN A.SYSTID IN ('TGLS') AND TRIM(A.USERCD) IS NOT NULL THEN A.USERCD --MOD BY LIP 20251223 一表通调研反馈，核算中台已有柜员号
               WHEN TRIM(TMP.TRA_TLR_NO) IS NOT NULL THEN TRIM(TMP.TRA_TLR_NO)
               ELSE 'M0001'
           END                                    AS TRA_TLR_NO                     --交易柜员号
         ,TMP.GRANT_TLR_NO                        AS GRANT_TLR_NO                   --授权柜员号
         ,A.TRANDT                                AS ENT_ACCT_DT                    --进账日期
         ,A.TRANDT                                AS WRT_OFF_DT                     --销账日期
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN '现金'
               WHEN A.TRANTP = 'TR' THEN '转账'
               ELSE '其他'
          END                                     AS ABSTR                          --摘要
         ,CASE WHEN A.STRKST = '9' THEN '2' --冲账
               ELSE '1'  --正常
          END                                     AS FLUSH_PATCH_FLG                --冲补抹标志
         --,A.AMNTCD                                AS TRA_DR_CR_FLG                  --交易借贷标志
         ,CASE WHEN A.AMNTCD = 'C' AND A.TRANAM < 0 THEN 'D'
               WHEN A.AMNTCD = 'D' AND A.TRANAM < 0 THEN 'C'
               ELSE A.AMNTCD
          END                                     AS TRA_DR_CR_FLG                  --交易借贷标志  --modify by tangan at 20230528
         ,A.TRANDT                                AS TRA_DT                         --交易日期
         ,NULL                                    AS TRA_TM                         --交易时间
         /*,CASE WHEN A.AMNTCD = 'D' THEN A.TRANBL ELSE 0 END AS DR_BAL             --借方余额
         ,CASE WHEN A.AMNTCD = 'C' THEN A.TRANBL ELSE 0 END AS CR_BAL               --贷方余额*/
         ,NVL(TRIM(F.TD_OC_DR_BAL),0)             AS DR_BAL                         --借方余额
         ,NVL(TRIM(F.TD_OC_CR_BAL),0)             AS CR_BAL                         --贷方余额
         ,'800001'                                AS DEPT_LINE                      --部门条线 /*营运管理部*/
         ,'核算中台'                              AS DATA_SRC                       --数据来源
         ,A.SOURSQ                                AS CORE_TRAN_FLOW_NUM             --核心交易流水号
         ,A.SRVCSQ                                AS ACCT_BILL_FLOW_NUM             --账单流水号
         ,A.BSNSSQ                                AS OVA_FLOW_NUM                   --全局流水号
         ,TO_CHAR(A.TRANTI,'YYYYMMDDHH24MISSFF')  AS INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND TRIM(C.TX_CNTPTY_CERT_TYPE) LIKE '2%' THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND TRIM(C.TX_CNTPTY_CERT_TYPE) LIKE '1%' THEN '0'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND LENGTH(TRIM(C.TX_CNTPTY_NAME)) > 3 THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND LENGTH(TRIM(C.TX_CNTPTY_NAME)) <= 3 THEN '0'
               ELSE TRIM(TMP.OPP_CORP_ACCT_FLG)
          END                                     AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B  --科目信息
      ON B.SUBJ_ID = TRIM(A.TOITEM)
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --MOD BY 20240402 增加票据的取数
    LEFT JOIN (
         SELECT PJ.*,
                ROW_NUMBER() OVER(PARTITION BY PJ.BSNSSQ,ISCUSTACCT,PJ.EVETDN ORDER BY PJ.SERINO DESC) AS RN
           FROM RRP_MDL.O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO PJ --票据系统交易对手信息视图
          WHERE TRIM(PJ.CUST_ACCT) IS NOT NULL
            AND ISCUSTACCT = '0') BDMS
      ON BDMS.BSNSSQ = A.BSNSSQ --全局流水号
     AND BDMS.EVETDN = A.AMNTCD
     AND BDMS.RN = 1
    LEFT JOIN (
         SELECT CC.*
               ,ROW_NUMBER() OVER(PARTITION BY CC.CORE_TRAN_FLOW_NUM,CC.BIZ_SEQ_NUM,CC.TRA_SEQ_NO ORDER BY CC.TX_CNTPTY_ACCT_NUM DESC) AS RN
           FROM RRP_MDL.O_IOL_TX_CNTPTY_INFO CC --交易对手视图
          WHERE TRIM(CC.CORE_TRAN_FLOW_NUM) IS NOT NULL
            AND CC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
            AND CC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) C
      ON C.CORE_TRAN_FLOW_NUM = A.BSNSSQ --全局流水号
     AND C.BIZ_SEQ_NUM = A.SOURSQ        --系统流水号
     AND C.TRA_SEQ_NO = A.SRVCSQ         --交易序号
     AND C.RN = 1
    LEFT JOIN (
          SELECT DATA_DT,     --数据日期
                 TRA_SEQ_NO,  --交易流水号
                 ACC_ID,      --对方账户ID
                 OPP_SUBJ_ID, --对方科目编号
                 OPP_SUBJ_NM, --对方科目名称
                 OPP_ACC,     --对方账号
                 OPP_ACC_NM,  --对方户名
                 OPP_PBC_NO,  --对方行号
                 OPP_BANK_NM, --对方行名
                 TRA_TLR_NO,  --交易柜员号
                 GRANT_TLR_NO,--授权柜员号
                 OPP_CORP_ACCT_FLG,--对方对公账户标志 -ADD BY LIP 20241018
                 ROW_NUMBER() OVER(PARTITION BY TRA_SEQ_NO ORDER BY OPP_ACC) AS RN
          FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP 
          WHERE DATA_DT = V_P_DATE) TMP
      ON TMP.TRA_SEQ_NO = A.TRANSQ || A.VCHRSQ
     AND TMP.RN = 1
    LEFT JOIN (SELECT DISTINCT A.TRAN_FLOW_NUM,A.OVA_FLOW_NUM,A.ACCT_BILL_FLOW_NUM
                 FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
                 LEFT JOIN RRP_MDL.O_IOL_TGLS_GLA_VCHR_H H
                   ON H.SOURSQ = A.TRAN_FLOW_NUM
                  AND H.STACID = 1
                  AND H.ITEMCD = '64110102' --MODIFY BY TANGAN AT 20230612  64110102科目数据需要报送
                  AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE H.SOURSQ IS NULL
                  AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) D
      ON D.TRAN_FLOW_NUM = A.SOURSQ
     AND D.OVA_FLOW_NUM = A.BSNSSQ
     AND D.ACCT_BILL_FLOW_NUM = REGEXP_SUBSTR(A.SRVCSQ,'[0-9]+')
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 E
      ON E.SUBJ_ID = A.ITEMCD
    LEFT JOIN ( --关联总账余额表取余额
         SELECT SUBJ_ID,ORG_ID,CURR_CD,STD_PROD_ID,TRAN_CHN_CD,TD_OC_DR_BAL,TD_OC_CR_BAL,ABS(TD_OC_DR_BAL-TD_OC_CR_BAL) AS BAL
           FROM RRP_MDL.O_ICL_CMM_GL_BAL  --核算中台的总账余额表
          WHERE DATA_SRC_CD = '99'
            AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) F
      ON F.SUBJ_ID = A.ITEMCD
     AND F.ORG_ID = A.TRANBR
     AND F.CURR_CD = A.CRCYCD
     AND F.STD_PROD_ID = A.ASSIS1
     AND F.TRAN_CHN_CD = A.ASSIS0
   WHERE A.STACID = 1 --基础账套
    --AND A.SYSTID NOT IN ('NCBS','IFSX')  --剔除新核心、互联网金融数据 暂定 modify by tangan at 20230215
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
         OR A.ITEMCD IN ('30010101','30010251','30010253'))  --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND A.TRANAM <> 0
     AND TRIM(D.TRAN_FLOW_NUM) IS NULL
     AND TRIM(E.SUBJ_ID) IS NULL
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20260120 更新交易柜员是域账户的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新交易柜员是域账户的数据';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT * FROM RRP_MDL.M_TRA_INTL_ACC_DTL WHERE TRA_TLR_NO LIKE '%.%' AND DATA_DT = V_P_DATE) TA
  USING (SELECT T1.TRA_SEQ_NO,T1.ACC_ID,T.REGION_ACCT_NUM,T.CLERK_ID,
                ROW_NUMBER() OVER(PARTITION BY T.REGION_ACCT_NUM ORDER BY T.EMPLY_STATUS_CD,T.EMPYT_DT DESC) RN
           FROM RRP_MDL.M_TRA_INTL_ACC_DTL T1
          INNER JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T --行员信息表
             ON TRIM(T.REGION_ACCT_NUM) = T1.TRA_TLR_NO
            AND TRIM(T.REGION_ACCT_NUM) IS NOT NULL
            AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          WHERE T1.TRA_TLR_NO LIKE '%.%'
            AND T1.DATA_DT = V_P_DATE) TB
     ON (TB.TRA_SEQ_NO = TA.TRA_SEQ_NO AND TB.ACC_ID = TA.ACC_ID)
   WHEN MATCHED THEN UPDATE SET
     TA.TRA_TLR_NO = TB.CLERK_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
     WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  IF V_SQLCOUNT > 0 THEN
    O_ERRCODE  := '1';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
    RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  --MOD BY LIP 20231010 月批调账后重跑一次后，增加月批的标志
    WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE ETL_DATE = V_P_DATE AND PROC_NAME = V_PROC_NAME)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_TRA_INTL_ACC_DTL;
/

