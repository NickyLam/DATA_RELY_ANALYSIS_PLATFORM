CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_DEP_ACC_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_DEP_ACC_DTL
  *  功能描述：监管集市银行对公、对私活期及定期账户交易明细，不包括计息和扣利息税记录
  *  创建日期：20220525
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_DEP_ACCT_TRAN_DTL   --存款账户交易明细表
  *            ICL.CMM_INDV_CUST_BASIC_INFO  --个人客户信息
  *            ICL.CMM_INTNAL_ORG_INFO    --内部机构信息表
  *            ICL.CMM_DEP_ACCT_INFO   --存款分户账
  *            IML.EVT_IFS_ACCT_TRAN_DTL   --联合存款账户交易明细
  *            ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息
  *  目标表：  M_TRA_DEP_ACC_DTL  --存款账户交易流水
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220919  HULJ     调整账户编号,子账户号取值。
  *             2    20220903   MW      增加交易渠道TRAN_CHAN、交易类型TRAN_TYP口径。
  *             3    20220903   MW      增加交易渠道TRAN_CHAN、交易类型TRAN_TYP口径。
  *             4    20221024  HULJ     交易类型调整码值。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20230201  TANGAN   根据业务卢萌反馈，先去掉交易对手兜底逻辑\
  *             7    20230306  MW       增加电子现金账户流水口径
  *             8    20230804  LIP      调整对手方的机构名取数口径，调整账户信息的取数
  *             9    20240819  LIP      根据ETS需求，拆分普通存款明细中的流水，金额、交易对手信息用明细中的
  *             10   20241011  LIP      根据east现场检查，调整交易序列号的排序方式，增加原始交易时间戳字段
  *             11   20241021  LIP      增加交易对手是我行账号是的对公账户标志
  *             12   20241105  YJY      剔除旅行通卡的账户交易流水
  *             13   20241121  LIP      更新前一天的IP和MAC地址
  *             14   20241220  LIP      更新本月内的代理人信息 如需调整历史数据，需单独调整
  *             15   20250922  LIP      增加业务产品编号字段，区分流水发生时点的产品
  *             16   20260106  LIP      对分期乐的代偿流水按全局流水号进行拆分，交易金额、交易对手相关信息取信贷登记的数据
  *             17   20260109  LIP      增加摘要代码字段
  *             18   20260212  LIP      增加快手交易对手加工逻辑
  *             19   20260316  LIP      调整交易时间的取数，按照核心口径，源系统时间戳更准确
  *             20   20260414  LIP      调整部分核心交易类型映射，增加附言字段
  *************************************************************************/
AS
  --定义变量
  V_STEP_DESC  VARCHAR2(100);                            --处理步骤描述
  V_P_DATE     VARCHAR2(8);                              --跑批数据日期
  V_SQLMSG     VARCHAR2(300);                            --SQL执行描述信息
  V_PART_NAME  VARCHAR2(100);                            --分区名
  V_STARTTIME  DATE;                                     --处理开始时间
  V_ENDTIME    DATE;                                     --处理结束时间
  V_COUNT      INTEGER;                                  --数据记录条数
  V_STEP       INTEGER := 0;                             --处理步骤
  V_SQLCOUNT   INTEGER := 0;                             --更新或删除影响的记录数
  V_SQLCOUNT2  INTEGER := 0;                             --更新或删除影响的记录数
  V_PROC_NAME  VARCHAR2(100) := 'ETL_M_TRA_DEP_ACC_DTL'; --程序名称
  V_TAB_NAME   VARCHAR2(100) := 'M_TRA_DEP_ACC_DTL';     --表名
  V_SYSTEM     VARCHAR2(30) := '监管报送';               --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20230807 将下方关联时的条件改为用ACCT_ID关联，调整账户表的口径，将ACCT_ID的调整成唯一的
  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款分户信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03';
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,A.CDS_LIAB_ACCT_NUM                AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'F'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.BELONG_ORG_ID                    AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--内部账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.MAIN_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,A.SUB_ACCT_NUM                     AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,NULL                               AS CUST_ID                  --客户编号
         ,'N'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.BELONG_ORG_ID                    AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
 WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
          DISTINCT
          A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.ACCT_ID ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'1'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT ACCT_ID                   --账户编号
         ,ACCT_NAME                 --账户名称
         ,CUST_ACCT_ID              --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
         ,CDS_LIAB_ACCT_NUM         --负债账户编号
         ,CUST_ID                   --客户编号
         ,FLAG                      --标志
         ,BELONG_ORG_ID             --所属机构编号
         ,ORG_ID1                   --目标机构号
         ,FIN_INST_CODE             --目标机构银行机构代码
         ,ORG_NAME                  --目标机构银行机构名称
         ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息2';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.DUBIL_NUM                        AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_NUM                        AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_NUM) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息3';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*/ /*+USE_HASH(A,C,D)*/
          A.LOAN_NUM                         AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.LOAN_NUM                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.LOAN_NUM ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'1'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.LOAN_NUM
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.LOAN_NUM) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  ACCT_ID                   --账户编号
         ,ACCT_NAME                 --账户名称
         ,CUST_ACCT_ID              --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
         ,CDS_LIAB_ACCT_NUM         --负债账户编号
         ,CUST_ID                   --客户编号
         ,FLAG                      --标志
         ,BELONG_ORG_ID             --所属机构编号
         ,ORG_ID1                   --目标机构号
         ,FIN_INST_CODE             --目标机构银行机构代码
         ,ORG_NAME                  --目标机构银行机构名称
         ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息4';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.DUBIL_ID                         AS ACCT_ID                  --账户编号
         ,E.CUST_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_ID                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
          A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.ACCT_ID ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'0'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.ACCT_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  ACCT_ID                   --账户编号
         ,ACCT_NAME                 --账户名称
         ,CUST_ACCT_ID              --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
         ,CDS_LIAB_ACCT_NUM         --负债账户编号
         ,CUST_ID                   --客户编号
         ,FLAG                      --标志
         ,BELONG_ORG_ID             --所属机构编号
         ,ORG_ID1                   --目标机构号
         ,FIN_INST_CODE             --目标机构银行机构代码
         ,ORG_NAME                  --目标机构银行机构名称
         ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.DUBIL_NUM                        AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_NUM                        AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'0'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_NUM) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
          A.LOAN_NUM                         AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.LOAN_NUM                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.LOAN_NUM ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'0'                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.LOAN_NUM
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.LOAN_NUM) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  ACCT_ID                   --账户编号
         ,ACCT_NAME                 --账户名称
         ,CUST_ACCT_ID              --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
         ,CDS_LIAB_ACCT_NUM         --负债账户编号
         ,CUST_ID                   --客户编号
         ,FLAG                      --标志
         ,BELONG_ORG_ID             --所属机构编号
         ,ORG_ID1                   --目标机构号
         ,FIN_INST_CODE             --目标机构银行机构代码
         ,ORG_NAME                  --目标机构银行机构名称
         ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 因主账户表中已经存在分户账和内部账中的主账号，所以上面两种存款表的情况下不取相关的主账号信息
  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款主账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE              --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG              --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.CUST_ACCT_ID                     AS ACCT_ID                  --账户编号
         ,A.CUST_ACCT_NAME                   AS ACCT_NAME                --账户名称
         ,A.CUST_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'C'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_BELONG_ORG_ID               AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,CASE WHEN LENGTH(A.CUST_ID) < 10 THEN '1' --内部户
              ELSE A.CORP_ACCT_FLG
          END                                AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.CUST_ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款分户信息2';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
    WITH TMP1 AS (
  SELECT /*+USE_HASH(A,C,D)*/
          A.CUST_ACCT_CARD_NO                AS ACCT_ID                  --账户编号
         ,A.CUST_ACCT_NAME                   AS ACCT_NAME                --账户名称
         ,A.CUST_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'C'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_BELONG_ORG_ID               AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ACCT_CARD_NO ORDER BY A.OPEN_ACCT_DT,A.VRIF_STATUS_CD DESC) RN
         ,A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.CUST_ACCT_CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.CUST_ACCT_CARD_NO) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  ACCT_ID                   --账户编号
         ,ACCT_NAME                 --账户名称
         ,CUST_ACCT_ID              --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
         ,CDS_LIAB_ACCT_NUM         --负债账户编号
         ,CUST_ID                   --客户编号
         ,FLAG                      --标志
         ,BELONG_ORG_ID             --所属机构编号
         ,ORG_ID1                   --目标机构号
         ,FIN_INST_CODE             --目标机构银行机构代码
         ,ORG_NAME                  --目标机构银行机构名称
         ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--银行卡信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
     ACCT_ID                   --账户编号
    ,ACCT_NAME                 --账户名称
    ,CUST_ACCT_ID              --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号
    ,CDS_LIAB_ACCT_NUM         --负债账户编号
    ,CUST_ID                   --客户编号
    ,FLAG                      --标志
    ,BELONG_ORG_ID             --所属机构编号
    ,ORG_ID1                   --目标机构号
    ,FIN_INST_CODE             --目标机构银行机构代码
    ,ORG_NAME                  --目标机构银行机构名称
    ,CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,C,D)*/
          A.CARD_NO                          AS ACCT_ID                  --账户编号
         ,A.CARD_HOLDER_NAME                 AS ACCT_NAME                --账户名称
         ,A.CARD_NO                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,'C'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,D.ORG_ID                           AS BELONG_ORG_ID            --所属机构编号
         ,D.ORG_ID1                          AS ORG_ID1                  --目标机构号
         ,D.FIN_INST_CODE                    AS FIN_INST_CODE            --目标机构银行机构代码
         ,D.BKNAME                           AS ORG_NAME                 --目标机构银行机构名称
         ,CASE WHEN SUBSTR(A.CUST_ID,1,1) IN ('1','3') THEN '0'
               ELSE '1'
           END                               AS CORP_ACCT_FLG             --对公账户标志 --ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A --银行卡基本信息
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.CARD_NO) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询M_TRA_DEP_ACC_DTL_TEMP03数据是否重复';
  WITH TMP1 AS (
  SELECT ACCT_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 T
   GROUP BY ACCT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

  IF V_COUNT > 0 THEN
     O_ERRCODE  := '1';
     V_ENDTIME  := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-加工利息的对手方信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP04';
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP04(
     TRAN_DT                   --交易日期
    ,TRAN_FLOW_NUM             --交易流水号
    ,ACCT_BILL_FLOW_NUM        --账单流水号
    ,CURR_CD                   --币种代码CD1728
    ,AMT                       --金额
    ,INVO_ACCT_ID              --涉及账户编号
    ,MAIN_ACCT_ID              --主账户编号
    ,CNTPTY_ACCT_ID             --对手方账户编号
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          A.TRAN_DT                   --交易日期
         ,A.TRAN_FLOW_NUM             --交易流水号
         ,A.ACCT_BILL_FLOW_NUM        --账单流水号
         ,A.TRAN_CURR_CD              --币种代码CD1728
         ,A.TRAN_AMT                  --金额
         ,A.DEP_SUB_ACCT_ID           --涉及账户编号
         ,D.MAIN_ACCT_ID              --对手方主账户编号
         ,D.ACCT_ID  AS CNTPTY_ACCT_ID --对手方账户编号
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款分户账交易明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO C --存款分户信息
      ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT D --内部账户
      ON D.SUBJ_ID = C.INT_PAYBL_SUBJ_ID
     AND D.BELONG_ORG_ID = C.BELONG_ORG_ID
     AND D.CURR_CD = C.CURR_CD
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.MEMO_CD_DESCB IN ('智能存款利息存入','存息','自动转存结息','智能存款利息收入' --20220809 MODIFY BY LIP 增加智能存款利息收入
         ,'灵活盈结息') --20231106 MODIFY BY LIP 增加灵活盈结息
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-多借一贷处理逻辑';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02';
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02
    (ETL_DT            --数据日期
    ,TRAN_FLOW_NUM     --交易流水
    ,TRA_SEQ_NO        --交易序列号
    ,MAIN_ACCT_ID      --账户号
    ,CUST_ACCT_ID      --对方账户号
    ,CUST_NAME         --对方账户名
    ,PBC_PAY_BANK_NO   --对方行号
    ,ORG_NAME          --对方行名
    ,DATA_SRC          --数据来源
    )
    WITH DEP_ACC_DTL_TMP01 AS (
  SELECT A.CNTPTY_ACCT_ID
        ,A.TRAN_FLOW_NUM
        ,A.CUST_ACCT_ID
        ,A.DEP_SUB_ACCT_ID
        ,B.ACCT_NAME
        ,B.FIN_INST_CODE
        ,B.ORG_NAME
        ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC ) AS RN
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.CUST_ACCT_ID
   WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
     AND A.MEMO_CD <> 'TO' --代发失败退款 代发工资代发失败的需剔除后再取最大的一笔
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT A.ETL_DT                                                             AS ETL_DT            --数据日期
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM     --交易流水
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO        --交易序列号
        ,A.CUST_ACCT_ID                                                       AS MAIN_ACCT_ID      --账户号
        ,CASE WHEN NVL(TRIM(B.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(B.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(B.CUST_ACCT_ID) IS NOT NULL THEN B.CUST_ACCT_ID
              ELSE TRIM(B.CUST_ACCT_ID)
          END                                                                 AS CUST_ACCT_ID      --对方账户号
        ,CASE WHEN TRIM(B.CUST_ACCT_ID) IS NOT NULL THEN B.ACCT_NAME
              ELSE TRIM(B.ACCT_NAME)
          END                                                                 AS CUST_NAME         --对方账户名
        ,B.FIN_INST_CODE                                                      AS PBC_PAY_BANK_NO   --对方行号
        ,B.ORG_NAME                                                           AS ORG_NAME          --对方行名
        ,'多借一贷'                                                           AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN DEP_ACC_DTL_TMP01 B
      ON B.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND B.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND B.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-一借多贷处理逻辑';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02
    (ETL_DT            --数据日期
    ,TRAN_FLOW_NUM     --交易流水
    ,TRA_SEQ_NO        --交易序列号
    ,MAIN_ACCT_ID      --账户号
    ,CUST_ACCT_ID      --对方账户号
    ,CUST_NAME         --对方账户名
    ,PBC_PAY_BANK_NO   --对方行号
    ,ORG_NAME          --对方行名
    ,DATA_SRC          --数据来源
    )
    WITH DEP_ACC_DTL_TMP02 AS (
  SELECT A.CNTPTY_ACCT_ID
        ,A.TRAN_FLOW_NUM
        ,A.CUST_ACCT_ID
        ,A.DEP_SUB_ACCT_ID
        ,B.ACCT_NAME
        ,B.FIN_INST_CODE
        ,B.ORG_NAME
        ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC) AS RN
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 B
      ON B.ACCT_ID = A.CUST_ACCT_ID
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
     AND A.MEMO_CD <> 'TO' --代发失败退款 代发工资代发失败的需剔除后再取最大的一笔
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT A.ETL_DT                                                             AS ETL_DT            --数据日期
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM     --交易流水
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO        --交易序列号
        ,A.CUST_ACCT_ID                                                       AS MAIN_ACCT_ID      --账户号
        /*,CASE WHEN TRIM(B.CUST_ACCT_ID) IS NOT NULL THEN B.CUST_ACCT_ID\*||'等'*\
              ELSE TRIM(B.CUST_ACCT_ID)
         END                                                                  AS CUST_ACCT_ID      --对方账户号*/
        ,CASE WHEN NVL(TRIM(B.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(B.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(B.CUST_ACCT_ID) IS NOT NULL THEN B.CUST_ACCT_ID
              ELSE TRIM(B.CUST_ACCT_ID)
         END                                                                  AS CUST_ACCT_ID      --对方账户号
        ,CASE WHEN TRIM(B.CUST_ACCT_ID) IS NOT NULL THEN B.ACCT_NAME
              ELSE TRIM(B.ACCT_NAME)
         END                                                                  AS CUST_NAME         --对方账户名
        ,B.FIN_INST_CODE                                                      AS PBC_PAY_BANK_NO   --对方行号
        ,B.ORG_NAME                                                           AS ORG_NAME          --对方行名
        ,'一借多贷'                                                           AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN DEP_ACC_DTL_TMP02 B
      ON B.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND B.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND B.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260106 分期乐交易对手拆分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-分期乐交易对手拆分';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP05';
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP05
    (OVA_FLOW_NUM       --全局流水号
    ,TRAN_FLOW_NUM      --核心流水号
    ,ACCT_BILL_FLOW_NUM --账单流水号
    ,TRAN_DT            --交易日期
    ,OPP_ACC            --交易对手账号
    ,TRA_AMT            --交易金额
    ,OPP_ACC_CUST_ID    --交易对手客户号
    ,OPP_ACC_NM         --交易对手户名
    ,OPP_PBC_NO         --交易对手行号
    ,OPP_BANK_NM        --交易对手行名
    ,RM                 --序号
    ,OPP_CORP_ACCT_FLG  --对方对公账户标志
    ,TRAN_AMT2          --账户级交易金额 ADD BY 20260303
    ,S_TRAN_AMT         --明细级汇总交易金额 ADD BY 20260303
    )
  SELECT T1.OVA_FLOW_NUM                        AS OVA_FLOW_NUM,        --全局流水号
         T1.TRAN_FLOW_NUM                       AS TRAN_FLOW_NUM,       --核心流水号
         T1.ACCT_BILL_FLOW_NUM                  AS ACCT_BILL_FLOW_NUM,  --账单流水号
         TRUNC(T1.TRAN_DT)                      AS TRAN_DT,             --交易日期
         T2.DUEBILLNO                           AS OPP_ACC,             --交易对手账号
         T2.TRANSAMT                            AS TRA_AMT,             --交易金额
         T3.CUST_ID                             AS OPP_ACC_CUST_ID,     --交易对手客户号
         T4.CUST_NAME                           AS OPP_ACC_NM,          --交易对手户名
         NVL(T5.FIN_INST_CODE,T6.FIN_INST_CODE) AS OPP_PBC_NO,          --交易对手行号
         NVL(T5.BKNAME,T6.BKNAME)               AS OPP_BANK_NM,         --交易对手行名
         ROW_NUMBER() OVER(PARTITION BY T1.OVA_FLOW_NUM ORDER BY T2.TRANSAMT DESC) RM, --序号
         '0'                                    AS OPP_CORP_ACCT_FLG,    --对方对公账户标志
         T1.TRAN_AMT                            AS TRAN_AMT2,            --账户级交易金额 ADD BY 20260303
         SUM(T2.TRANSAMT) OVER(PARTITION BY T1.TRAN_FLOW_NUM,T1.ACCT_BILL_FLOW_NUM) AS S_TRAN_AMT  --明细级汇总交易金额 ADD BY 20260303
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL T1 --存款账户交易明细表
   INNER JOIN RRP_MDL.O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY T2 --信贷供交易流水文件临时表历史表
      ON T2.GLOBSEQNUM = T1.OVA_FLOW_NUM --根据信贷反馈，后续不会出现全局流水号相同的情况
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T3 --联合网贷借据信息
      ON T3.DUBIL_ID = T2.DUEBILLNO
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO T4 --个人客户基本信息
      ON T4.CUST_ID = T3.CUST_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG T5
      ON T5.ORG_ID = T3.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG T6
      ON T6.ORG_ID = '800'
   WHERE NVL(T1.CUST_TYPE_CD,'-') NOT IN ('-') --交易主体不是内部户的
     AND T1.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
 
  /*--ADD BY LIP 20260212 快手交易对手拆分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-快手交易对手拆分';
  V_STARTTIME := SYSDATE;
  INSERT  INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP05
    (OVA_FLOW_NUM       --全局流水号
    ,TRAN_FLOW_NUM      --核心流水号
    ,ACCT_BILL_FLOW_NUM --账单流水号
    ,TRAN_DT            --交易日期
    ,OPP_ACC            --交易对手账号
    ,TRA_AMT            --交易金额
    ,OPP_ACC_CUST_ID    --交易对手客户号
    ,OPP_ACC_NM         --交易对手户名
    ,OPP_PBC_NO         --交易对手行号
    ,OPP_BANK_NM        --交易对手行名
    ,RM                 --序号
    ,OPP_CORP_ACCT_FLG  --对方对公账户标志
    ,TRAN_AMT2          --账户级交易金额 ADD BY 20260303
    ,S_TRAN_AMT         --明细级汇总交易金额 ADD BY 20260303
    )
  SELECT T1.OVA_FLOW_NUM                        AS OVA_FLOW_NUM,        --全局流水号
         T1.TRAN_FLOW_NUM                       AS TRAN_FLOW_NUM,       --核心流水号
         T1.ACCT_BILL_FLOW_NUM                  AS ACCT_BILL_FLOW_NUM,  --账单流水号
         TRUNC(T1.TRAN_DT)                      AS TRAN_DT,             --交易日期
         TRIM(T2.OTH_REAL_BASE_ACCT_NO)         AS OPP_ACC,             --交易对手账号
         T2.TRAN_AMT                            AS TRA_AMT,             --交易金额
         NULL                                   AS OPP_ACC_CUST_ID,     --交易对手客户号
         TRIM(T2.OTH_REAL_TRAN_NAME)            AS OPP_ACC_NM,          --交易对手户名
         TRIM(T2.CONTRA_BANK_CODE)              AS OPP_PBC_NO,          --交易对手行号
         TRIM(T2.CONTRA_BANK_NAME)              AS OPP_BANK_NM,         --交易对手行名
         T2.REG_SEQ_NO                          AS RM,                  --序号
         NULL                                   AS OPP_CORP_ACCT_FLG,   --对方对公账户标志
         T1.TRAN_AMT                            AS TRAN_AMT2,           --账户级交易金额 ADD BY 20260303
         SUM(T2.TRAN_AMT) OVER(PARTITION BY T1.TRAN_FLOW_NUM,T1.ACCT_BILL_FLOW_NUM) AS S_TRAN_AMT --明细级汇总交易金额 ADD BY 20260303
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL T1 --存款账户交易明细表
   INNER JOIN RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG_SP T2 --新真实交易对手登记簿
      ON T2.SEQ_NO = T1.ACCT_BILL_FLOW_NUM
     AND T2.REFERENCE = T1.TRAN_FLOW_NUM
     AND T2.CHANNEL_SEQ_NO = T1.OVA_FLOW_NUM
     AND T2.SUB_SEQ_NO = T1.TRAN_FLG_NUM
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.MEMO_CD = 'KSS' --快手业务汇总记账
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,''); */

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-普通存款数据信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01';
  /***********************普通存款****************************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 NOLOGGING
    (DATA_DT                   --01数据日期
    ,LGL_REP_ID                --02法人编号
    ,TRA_SEQ_NO                --03交易流水号
    ,ACC_ID                    --04账户编号
    ,EXT_ACC                   --05外部账号
    ,CUST_ID                   --06客户编号
    ,CUST_NM                   --07客户名称
    ,ORG_ID                    --08机构编号
    ,SUBJ_ID                   --09科目编号
    ,CUR                       --10币种
    ,CORP_IND_FLG              --11对公对私标志
    ,TIME_DMD_FLG              --12定活标志
    ,TRA_AMT                   --13交易金额
    ,OPEN_ACC_ORG_ID           --14开户机构
    ,HDL_ORG_ID                --15经办机构编号
    ,ACC_BAL                   --16账户余额
    ,OPP_ACC                   --17对方账号
    ,OPP_ACC_NM                --18对方户名
    ,OPP_PBC_NO                --19对方行号
    ,OPP_BANK_NM               --20对方行名
    ,TRA_CHAN                  --21交易渠道
    ,CASH_TRF_FLG              --22现转标志
    ,AGT_NM                    --23代办人姓名
    ,AGT_CRDL_TYP              --24代办人证件类型
    ,AGT_CRDL_NO               --25代办人证件号码
    ,TRA_TLR_NO                --26交易柜员号
    ,GRANT_TLR_NO              --27授权柜员号
    ,ABSTR                     --28摘要
    ,FLUSH_PATCH_FLG           --29冲补抹标志
    ,TRA_DR_CR_FLG             --30交易借贷标志
    ,ADV_DRAW_FLG              --31提前支取标志
    ,TRA_DT                    --32交易日期
    ,TRA_TM                    --33交易时间
    ,TRA_MED_TYP               --34交易介质类型
    ,TRA_TYP                   --35交易类型
    ,DEP_IN_OUT_FLG            --36存入存出类型
    ,IP                        --37IP地址
    ,MAC                       --38MAC地址
    ,POSTSCRIPT                --39附言
    ,CTY_RG_CD                 --国家和地区
    ,DEPT_LINE                 --40部门条线
    ,DATA_SRC                  --41数据来源
    ,SUB_ACC_ID                --42子账户编号
    ,ACC_ID_EAST               --43内部账户编号
    ,US_AGE                    --44 20221020 XUXIAOBIN ADD JS
    ,REAL_CNTPTY_ACCT_ID       --45真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME     --46真实交易对手名称
    ,REAL_CNTPTY_FIN_INST_CD   --47真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME --48真实交易对手金融机构名称
    ,CORE_TRAN_FLOW_NUM        --49核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --50账单流水号
    ,OVA_FLOW_NUM              --51全局流水号
    ,INIT_TRAN_TIMESTAMP       --52原交易时间戳 --ADD BY LIP 20241011
    ,BUS_PROD_ID               --业务产品编号 --ADD BY LIP 20250922
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20260106
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260109
    ,TRAN_MEMO_DESCB           --附言 --ADD BY LIP 20260414
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                  AS DATA_DT    --数据日期
        ,A.LP_ID                                        AS LGL_REP_ID --法人编号
        --,A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD') AS TRA_SEQ_NO --交易流水号
        --MOD BY LIP 当是ETS流水时，流水中拼上序号
        /*,CASE WHEN TN.HOSTNBR IS NOT NULL
              THEN A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')||TRIM(TN.SEQNO)
              ELSE A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')
          END                                           AS TRA_SEQ_NO --交易流水号*/
        --MOD BY LIP 20241011 为方便查询数据，将交易流水号放在最后面
        ,CASE WHEN TN.HOSTNBR IS NOT NULL
              THEN A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')||TRIM(TN.SEQNO)||A.TRAN_FLOW_NUM
              WHEN T1.OVA_FLOW_NUM IS NOT NULL --分期乐拆分明细
              THEN A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')||TRIM(T1.RM)||A.TRAN_FLOW_NUM --MOD BY LIP 20260106
              ELSE A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM
          END                                           AS TRA_SEQ_NO --交易流水号
        ,A.CUST_ACCT_ID                                 AS ACC_ID     --账户编号
        ,NVL(TRIM(A.OLD_SUB_ACCT_ID),A.DEP_SUB_ACCT_ID) AS EXT_ACC    --外部账号
        ,A.CUST_ID                                      AS CUST_ID    --客户编号
        ,NVL(C.CUST_NAME,D.CUST_NAME)                   AS CUST_NM    --客户名称
        ,A.ACCT_ORG_ID                                  AS ORG_ID     --机构编号--20221019 xuxiaobin MODIFY
        ,NULL                                           AS SUBJ_ID    --科目编号
        ,A.TRAN_CURR_CD                                 AS CUR        --币种
        ,CASE WHEN C.CUST_ID IS NOT NULL THEN '1'  --对私
              WHEN D.CUST_ID IS NOT NULL THEN '2'  --对公
          END                                           AS CORP_IND_FLG --对公对私标志
        ,NULL                                           AS TIME_DMD_FLG --定活标志
        --MOD BY LIP 当是ETS流水时，交易金额用明细表中的明细金额
        ,CASE WHEN TN.HOSTNBR IS NOT NULL THEN TN.AMOUNT --明细金额
              WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.TRA_AMT --分期乐明细金额 --MOD BY LIP 20260106
              ELSE A.TRAN_AMT
          END                                           AS TRA_AMT --交易金额
        ,A.ACCT_ORG_ID                                  AS OPEN_ACC_ORG_ID --开户机构
        ,A.TRAN_ORG_ID                                  AS HDL_ORG_ID --经办机构编号
        ,A.TRAN_BAL                                     AS ACC_BAL --账户余额
        /*--MODIFY BY TANGAN AT 20230201 应业务卢萌要求修改 BEGIN--*/
        ,CASE WHEN TN.HOSTNBR IS NOT NULL THEN TRIM(TN.PAYERACCTNO) --付款账号 --MOD BY LIP 20240819 --ETS需求
              WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.OPP_ACC --分期乐明细 --MOD BY LIP 20260106
              WHEN TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC) --MODIFY BY TANGAN AT 20230207
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL AND NVL(TRIM(A.CNTPTY_ACCT_ID),'0') IN ('0','-','--')
              THEN TRIM(B.RECVER_ACCT_NUM) --ADD BY LIP 20220707
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              --MOD BY 20240327 当是行内账号时，优先取账号ID
              WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(G.CUST_ACCT_ID) IS NOT NULL THEN TRIM(G.CUST_ACCT_ID)
          END                                           AS OPP_ACC --对方账号
        ,CASE WHEN TN.HOSTNBR IS NOT NULL THEN TRIM(TN.TAXINAME) --纳税人名称 --MOD BY LIP 20240819 --ETS需求
              WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.OPP_ACC_NM --分期乐明细 --MOD BY LIP 20260106
              WHEN TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM) --MODIFY BY TANGAN AT 20230207
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_NAME)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(G.CUST_ACCT_ID) IS NOT NULL THEN TRIM(G.CUST_NAME)
          END                                           AS OPP_ACC_NM --对方户名 均为中文时，EAST替换半角括号为全角括号
        ,CASE WHEN TN.HOSTNBR IS NOT NULL THEN TRIM(TN.OPENBANKNO)  --经收处商业银行号 --MOD BY LIP 20240819 --ETS需求
              WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.OPP_PBC_NO --分期乐明细 --MOD BY LIP 20260106
              WHEN TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))  --modify by tangan at 20230207
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_OPEN_BANK_NO)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD))
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID))
              WHEN TRIM(G.CUST_ACCT_ID) IS NOT NULL THEN TRIM(G.PBC_PAY_BANK_NO)
          END                                           AS OPP_PBC_NO --对方行号
        ,CASE WHEN TN.HOSTNBR IS NOT NULL THEN '' --MOD BY LIP 20240819 --ETS需求：根据行号自行匹配
              WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.OPP_BANK_NM --分期乐明细 --MOD BY LIP 20260106
              WHEN TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.BKNAME)/*TRIM(B3.ORG_NAME)*/,TRIM(TC.OPP_BANK_NM))  --modify by tangan at 20230207
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_OPEN_BANK_NAME)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.BKNAME)/*TRIM(B2.ORG_NAME)*/,TRIM(A.REAL_CNTPTY_FIN_INST_NAME))
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.BKNAME)/*TRIM(B1.ORG_NAME)*/,TRIM(A.CNTPTY_OPEN_BANK_NAME))
              WHEN TRIM(G.CUST_ACCT_ID) IS NOT NULL THEN TRIM(G.ORG_NAME)
          END                                           AS OPP_BANK_NM --对方行名
        /*--MODIFY BY TANGAN AT 20230201 应业务卢萌要求修改 END--*/
        ,A.CHN_CD                                       AS TRA_CHAN    --交易渠道
        ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' --现
              WHEN A.CASH_TRANS_FLG = '0' THEN '2' --转
              ELSE '2'
          END                                         AS CASH_TRF_FLG --现转标志
        --源数据问题存在ATM存取现金的现转标志是转，按照摘要调整
        ,TRIM(A.AGENT_NAME)                           AS AGT_NM --代办人姓名
        ,A.AGENT_CERT_TYPE_CD                         AS AGT_CRDL_TYP --代办人证件类型
        ,TRIM(A.AGENT_CERT_NO)                        AS AGT_CRDL_NO --代办人证件号码
        ,TRIM(A.TRAN_TELLER_ID)                       AS TRA_TLR_NO --交易柜员号
        ,TRIM(A.AUTH_TELLER_ID)                       AS GRANT_TLR_NO --授权柜员号
        ,CASE WHEN TRIM(TM.MEMO_CODE_DESCB) IS NOT NULL THEN TM.MEMO_CODE_DESCB
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EEA000601' THEN 'EEA000601司法扣划'
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EEA000301' THEN 'EEA000301理财收益'
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS000102' THEN 'EAS000102资金转出'
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001013' THEN 'EAS001013兴E贷还款'
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001101' THEN 'EAS001101华兴尊享划转'
              WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001102' THEN 'EAS001102华兴尊享还款'
              WHEN TRIM(A.MEMO_CD_DESCB) IS NOT NULL THEN TRIM(A.MEMO_CD_DESCB)
              ELSE TRIM(A.TRAN_DESCB)
          END                                         AS ABSTR --摘要
        ,A.TRAN_STATUS_CD                             AS FLUSH_PATCH_FLG --冲补抹标志  --TRAN_STATUS_CD 通过交易状态代码判断
        ,A.DEBIT_CRDT_DIR_CD                          AS TRA_DR_CR_FLG --交易借贷标志
        ,NULL                                         AS ADV_DRAW_FLG --提前支取标志
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                AS TRA_DT --交易日期
        --,A.TRAN_TIMESTAMP                             AS TRA_TM --交易时间
        ,A.INIT_TRAN_TIMESTAMP                        AS TRA_TM --交易时间 --MOD BY LIP 20260316 根据旭颖反馈，源系统交易时间戳更准确
        ,CASE WHEN H.CARD_TYPE_CD = '0' THEN 'A'
              WHEN H.CARD_TYPE_CD = '1' THEN 'A'
              WHEN H.CARD_TYPE_CD = '2' THEN 'A'
              ELSE 'Z'                  
          END                                         AS TRA_MED_TYP --交易介质类型
        ,CASE WHEN A.MEMO_CD IN ('D1','D2','C3','CD','AQ','TC','AC') THEN '02'--取现 --20220927 XUXIAOBIN ADD AC银联取现
              WHEN A.MEMO_CD IN ('CA','AD','AF') THEN '03'--存现
              WHEN A.TRAN_KIND_CD IN ('H2','H4','04')THEN '04'--结息
              WHEN A.MEMO_CD IN ('M0','TO') THEN '07'--代发
              WHEN A.MEMO_CD IN ('DU','KF','AL','FW','D7','KS') THEN '08'--代扣
              WHEN A.MEMO_CD IN ('GD') THEN '09'--代缴
              WHEN A.MEMO_CD IN ('BT','ON','D6') THEN '10'--批量交易
              WHEN A.MEMO_CD IN ('PO','V1','C1','L3')THEN '11'--贷款发放
              WHEN A.MEMO_CD IN ('L2','RC') THEN '12'--贷款还本
              WHEN A.MEMO_CD IN ('L4','RD','C6') THEN '13'--贷款还息
              WHEN A.MEMO_CD IN ('SE') THEN '14'--银证业务
              WHEN A.MEMO_CD IN ('LB','LC','LD','LE','PS') THEN '15'--投资理财
              WHEN A.MEMO_CD IN ('KJ','E0','E1','KL','CT','UL','UM','9O','9R','9T')
                   OR A.CHN_CD = '2306' THEN '17' --ADD BY LIUYU 为了和交易渠道校验添加'其他-三方支付'
              WHEN A.MEMO_CD_DESCB = 'POS' OR A.MEMO_CD_DESCB LIKE '%消费%' THEN '06'--消费 --MODIFY BY HULJ 20221024
              WHEN A.MEMO_CD IN ('TR','AP','ET','EL','AR','AI','AM','AS','EO','EF') THEN '01'--转账 --MODIFY BY HULJ 20221024
              WHEN A.TRAN_KIND_CD IN ('TR','4986','4989') THEN '01'--转账
              WHEN A.TRAN_KIND_CD IN ('01','02','03','06','07') THEN F1.TAR_VALUE_CODE --ADD BY LIP 20260414 因模型交易代码中有这几个码值，所以对这几个码值进行转换
              ELSE A.TRAN_KIND_CD --其他-银行自定义类型
          END                                         AS TRA_TYP --交易类型 D0121
        --ADD BY LIUYU 根据业务和科技反馈使用摘要判断交易类型，数仓交易类型码值CD1311
        ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN '0' ELSE '1' END AS DEP_IN_OUT_FLG --存入存出类型 --MODIFY CCH 20220909
        ,A.CLIENT_IP_ADDR                             AS IP --IP地址
        ,A.CUST_TERMN_MAC_ADDR                        AS MAC --MAC地址
        ,A.RECE_DESCB_INFO                            AS POSTSCRIPT --附言
        ,NVL(C.NATION_CD,D.CTY_RG_CD)                 AS CTY_RG_CD         --国家和地区
        ,NULL                                         AS DEPT_LINE --部门条线
        ,'普通存款'                                   AS DATA_SRC --数据来源
        ,A.SUB_ACCT_ID                                AS SUB_ACC_ID --子账户编号
        ,A.DEP_SUB_ACCT_ID                            AS ACC_ID_EAST --内部账户编号(EAST)
        ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN 'A'
              WHEN A.MEMO_CD IN ('D1','D2','C3','CD','AQ','TC','CA','AD','AF') THEN 'A'
              ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((CASE WHEN REGEXP_LIKE(TRIM(A.RECE_DESCB_INFO), '^([A-Z]|[0-9])+$') OR TRIM(A.RECE_DESCB_INFO) IS NULL THEN TRIM(A.MEMO_CD_DESCB) ELSE TRIM(A.RECE_DESCB_INFO) END),
                     '?',''),'!',''),'^',''),'？',''),'！',''),' ',''),'  ',''),'|',''),'  ','')
          END                                         AS US_AGE --20221020 XUXIAOBIN ADD
        ,A.REAL_CNTPTY_ACCT_ID                        AS REAL_CNTPTY_ACCT_ID    --真实交易对手账户编号
        ,A.REAL_CNTPTY_ACCT_NAME                      AS REAL_CNTPTY_ACCT_NAME  --真实交易对手账户名称
        ,A.REAL_CNTPTY_FIN_INST_CD                    AS REAL_CNTPTY_FIN_INST_CD--47真实交易对手金融机构代码
        ,A.REAL_CNTPTY_FIN_INST_NAME                  AS REAL_CNTPTY_FIN_INST_NAME--48真实交易对手金融机构名称
        ,A.TRAN_FLOW_NUM                              AS CORE_TRAN_FLOW_NUM     --49核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                         AS ACCT_BILL_FLOW_NUM --50 账单流水号
        ,A.OVA_FLOW_NUM                               AS OVA_FLOW_NUM       --51 全局流水号
        ,TO_CHAR(A.INIT_TRAN_TIMESTAMP,'YYYYMMDDHH24MISSFF') AS INIT_TRAN_TIMESTAMP --52 原交易时间戳 --ADD BY LIP 20241011
        ,A.BUS_PROD_ID                                AS BUS_PROD_ID               --业务产品编号 --ADD BY LIP 20250922
        ,CASE WHEN T1.OVA_FLOW_NUM IS NOT NULL THEN T1.OPP_CORP_ACCT_FLG
              ELSE NULL
          END                                         AS OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20260106
        ,A.MEMO_CD                                    AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260109
        ,TRIM(REGEXP_REPLACE(T2.TRAN_MEMO_DESCB,'[?!^· $%^#°*|[:space:]？！'||CHR(10)||CHR(13)||']','')) AS TRAN_MEMO_DESCB --附言 --ADD BY LIP 20260414
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细表
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO E --存款分户补充信息
      ON E.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND NVL(E.TRAVEL_CARD_ACCT_FLG,'0') = '0' --MOD BY YJY 20241105 取剔除旅行通卡的存款分户信息
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT ETL_DT            --数据日期
                     ,TRAN_FLOW_NUM     --交易流水
                     ,TRA_SEQ_NO        --交易序列号
                     ,MAIN_ACCT_ID      --账户号
                     ,CUST_ACCT_ID      --对方账户号
                     ,CUST_NAME         --对方账户名
                     ,PBC_PAY_BANK_NO   --对方行号
                     ,ORG_NAME          --对方行名
                     ,DATA_SRC          --数据来源
                     ,ROW_NUMBER() OVER(PARTITION BY TRA_SEQ_NO ORDER BY DATA_SRC) AS RN
                 FROM RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) G
      ON G.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
     AND G.RN = 1
    LEFT JOIN (--MODIFY BY TANGAN AT 20230130
               SELECT TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM AS TRAN_FLOW_NUM_BB
                     ,BB.RECVER_ACCT_NUM,BB.TRAN_DT,BB.RECVER_NAME,BB.RECVER_OPEN_BANK_NO,BB.RECVER_OPEN_BANK_NAME
                     ,ROW_NUMBER() OVER(PARTITION BY TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM ORDER BY JOB_CD DESC) AS RN
                 FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW BB --人行通道交易流水表
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) B
      ON B.TRAN_FLOW_NUM_BB = A.TRAN_FLOW_NUM
     AND TRIM(A.MEMO_CD_DESCB) IN ('缴税','社保费','社保') --MODIFY BY TANGAN AT 20230130
     AND B.TRAN_DT = A.TRAN_DT
     AND B.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02 G --增加对手方信息的来源
      ON G.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN RRP_MDL.CODE_MAP F1 --数仓补录码值表
      ON F1.SRC_VALUE_CODE = A.TRAN_KIND_CD
     AND F1.SRC_CLASS_CODE = 'CD1311' --交易类型代码
     AND F1.TAR_CLASS_CODE = 'D0121' --ADD BY LIP 20220620
     AND F1.MOD_FLG = 'MDM'
    /*LEFT JOIN RRP_MDL.CODE_MAP F2 --数仓补录码值表
      ON F2.SRC_VALUE_CODE = A.CHN_CD
     AND F2.SRC_CLASS_CODE = 'CD1751' --渠道代码
     AND F2.TAR_CLASS_CODE = 'Z0014' --ADD BY LIP 20220620
     AND F2.MOD_FLG = 'MDM'*/
    LEFT JOIN RRP_MDL.M_MID_TRA_CNTPTY_INFO TC --交易对手信息中间表 --ADD BY TANGAN AT 20230207
      ON TC.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
     AND TC.TRA_DT = TO_CHAR(A.TRAN_DT,'YYYYMMDD')
     AND TC.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG B1
      ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B2 --MODIFY BY TANGAN AT 20230201
      ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN RRP_MDL.ORG_CONFIG B3 --MODIFY BY TANGAN AT 20230207
      ON B3.ORG_ID = TC.OPP_PBC_NO
    LEFT JOIN RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO H --银行卡基本信息表
      ON H.CARD_NO = A.CUST_ACCT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB TM --MODIFY BY TANGAN AT 20230203
      ON TM.MEMO_CODE = A.MEMO_CD
     AND TM.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TM.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A49TETSTRANDETAIL TN --社保费明细表 --ADD BY LIP 20240819 ETS需求
      ON TN.HOSTNBR = A.TRAN_FLOW_NUM
     AND TRIM(TN.HOSTNBR) IS NOT NULL
     AND TN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP05 T1 --分期乐交易对手拆分数据 --ADD BY LIP 20260106 --快手也从这个表出数
      ON T1.OVA_FLOW_NUM = A.OVA_FLOW_NUM
     AND T1.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND T1.ACCT_BILL_FLOW_NUM = A.ACCT_BILL_FLOW_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO T2 --ADD BY LIP 20260414 取流水的附言信息
      ON T2.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND T2.ACCT_BILL_FLOW_NUM = A.ACCT_BILL_FLOW_NUM
     AND T2.OVA_FLOW_NUM = A.OVA_FLOW_NUM
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_AMT <> 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-联合存款数据信息';
  V_STARTTIME := SYSDATE;
  /****************************联合存款**************************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 NOLOGGING
    (DATA_DT                   --01数据日期
    ,LGL_REP_ID                --02法人编号
    ,TRA_SEQ_NO                --03交易流水号
    ,ACC_ID                    --04账户编号
    ,EXT_ACC                   --05外部账号
    ,CUST_ID                   --06客户编号
    ,CUST_NM                   --07客户名称
    ,ORG_ID                    --08机构编号
    ,SUBJ_ID                   --09科目编号
    ,CUR                       --10币种
    ,CORP_IND_FLG              --11对公对私标志
    ,TIME_DMD_FLG              --12定活标志
    ,TRA_AMT                   --13交易金额
    ,OPEN_ACC_ORG_ID           --14开户机构
    ,HDL_ORG_ID                --15经办机构编号
    ,ACC_BAL                   --16账户余额
    ,OPP_ACC                   --17对方账号
    ,OPP_ACC_NM                --18对方户名
    ,OPP_PBC_NO                --19对方行号
    ,OPP_BANK_NM               --20对方行名
    ,TRA_CHAN                  --21交易渠道
    ,CASH_TRF_FLG              --22现转标志
    ,AGT_NM                    --23代办人姓名
    ,AGT_CRDL_TYP              --24代办人证件类型
    ,AGT_CRDL_NO               --25代办人证件号码
    ,TRA_TLR_NO                --26交易柜员号
    ,GRANT_TLR_NO              --27授权柜员号
    ,ABSTR                     --28摘要
    ,FLUSH_PATCH_FLG           --29冲补抹标志
    ,TRA_DR_CR_FLG             --30交易借贷标志
    ,ADV_DRAW_FLG              --31提前支取标志
    ,TRA_DT                    --32交易日期
    ,TRA_TM                    --33交易时间
    ,TRA_MED_TYP               --34交易介质类型
    ,TRA_TYP                   --35交易类型
    ,DEP_IN_OUT_FLG            --36存入存出类型
    ,IP                        --37IP地址
    ,MAC                       --38MAC地址
    ,POSTSCRIPT                --39附言
    ,CTY_RG_CD                 --国家和地区代码
    ,DEPT_LINE                 --40部门条线
    ,DATA_SRC                  --41数据来源
    ,SUB_ACC_ID                --子账户编号
    ,ACC_ID_EAST               --内部账户编号_EAST
    ,REAL_CNTPTY_ACCT_ID       --真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME     --真实交易对手账户名称
    ,REAL_CNTPTY_FIN_INST_CD   --47真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME --48真实交易对手金融机构名称
    ,CORE_TRAN_FLOW_NUM        --49核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --50账单流水号
    ,OVA_FLOW_NUM              --51全局流水号
    ,INIT_TRAN_TIMESTAMP       --52原交易时间戳 --ADD BY LIP 20241011
    ,BUS_PROD_ID               --业务产品编号 --ADD BY LIP 20250922
    )
  SELECT /*+USE HASH(A, B)*/
          TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT    --数据日期
         ,A.LP_ID                                  AS LGL_REP_ID --法人编号
         ,A.TRAN_FLOW_ID||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD') AS TRA_SEQ_NO --交易流水号
         ,A.ACCT_ID                                AS ACC_ID     --账户编号
         ,A.ACCT_ID || A.DEP_SUB_ACCT_ID           AS EXT_ACC    --外部账号
         ,A.CUST_ID                                AS CUST_ID    --客户编号
         ,NVL(C.CUST_NAME,D.CUST_NAME)             AS CUST_NM    --客户名称
         ,A.TRAN_ORG_ID                            AS ORG_ID     --机构编号 --20221019 XUXIAOBIN MODIFY
         ,NULL                                     AS SUBJ_ID    --科目编号
         ,'CNY'                                    AS CUR        --币种
         ,CASE WHEN C.CUST_ID IS NOT NULL THEN '1'
               WHEN D.CUST_ID IS NOT NULL THEN '2'
           END                                     AS CORP_IND_FLG --对公对私标志
         ,NULL                                     AS TIME_DMD_FLG --定活标志
         ,A.TRAN_AMT                               AS TRA_AMT --交易金额
         ,NULL                                     AS OPEN_ACC_ORG_ID --开户机构
         ,A.TRAN_ORG_ID                            AS HDL_ORG_ID --经办机构编号
         ,A.DEP_RCPT_BAL                           AS ACC_BAL --账户余额
         ,REPLACE(A.CNTPTY_ACCT_ID,' ','')         AS OPP_ACC --对方账号
         ,CASE WHEN REGEXP_REPLACE(A.CNTPTY_ACCT_NAME,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
               THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPTY_ACCT_NAME),'(','（'),')','）'),' ','')
               ELSE TRIM(A.CNTPTY_ACCT_NAME)
           END                                     AS OPP_ACC_NM --对方户名
         ,A.CNTPTY_ORG_ID                          AS OPP_PBC_NO --对方行号
         ,'微众银行'                               AS OPP_BANK_NM --对方行名
         ,A.TRAN_CHN_CD                            AS TRA_CHAN --交易渠道
         ,'2'                                      AS CASH_TRF_FLG --现转标志
         ,NULL                                     AS AGT_NM --代办人姓名
         ,NULL                                     AS AGT_CRDL_TYP --代办人证件类型
         ,NULL                                     AS AGT_CRDL_NO --代办人证件号码
         ,NULL                                     AS TRA_TLR_NO --交易柜员号
         ,NULL                                     AS GRANT_TLR_NO --授权柜员号
         --MOD BY LIUYU 查询交易渠道后联合存款只有一个支付产品化平台渠道，非柜面，置空柜员号
         ,'转账'                                   AS ABSTR --摘要
         --MOD BY LIUYU 摘要默认转账
         ,'N'                                      AS FLUSH_PATCH_FLG --冲补抹标志
         ,A.DEBIT_CRDT_DIR_CD                      AS TRA_DR_CR_FLG --交易借贷标志
         ,NULL                                     AS ADV_DRAW_FLG --提前支取标志
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')           AS TRA_DT --交易日期
         ,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT,'YYYY-MM-DD')||' '||TO_CHAR(TO_DATE(A.TRAN_TM,'HH24:MI:SS'),'HH24:MI:SS'),'YYYY-MM-DD HH24:MI:SS')
                                                   AS TRA_TM --TRAN_TM VARCHAR2(10)
         ,CASE WHEN G.CARD_TYPE_CD = '0' THEN 'A'
               WHEN G.CARD_TYPE_CD = '1' THEN 'A'
               WHEN G.CARD_TYPE_CD = '2' THEN 'A'
               ELSE 'Z'
           END                                     AS TRA_MED_TYP --交易介质类型
         ,NVL(F1.TAR_VALUE_CODE,'99')              AS TRA_TYP --交易类型
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN '0' ELSE '1' END AS DEP_IN_OUT_FLG --存入存出类型 --MODIFY CCH 20220909
         ,NULL                                     AS IP --ip地址
         ,NULL                                     AS MAC --mac地址
         ,NULL                                     AS POSTSCRIPT --附言
         ,NVL(C.NATION_CD,D.CTY_RG_CD)             AS CTY_RG_CD  --国家和地区代码
         ,NULL                                     AS DEPT_LINE --部门条线
         ,'联合存款'                               AS DATA_SRC --数据来源
         ,SUBSTR(A.DEP_SUB_ACCT_ID,5,1)            AS SUB_ACC_ID --子账户编号
         ,A.ACCT_ID || A.DEP_SUB_ACCT_ID           AS ACC_ID_EAST
         ,NULL                                     AS REAL_CNTPTY_ACCT_ID --真实交易对手账户编号
         ,NULL                                     AS REAL_CNTPTY_ACCT_NAME --真实交易对手账户名称
         ,NULL                                     AS REAL_CNTPTY_FIN_INST_CD--47真实交易对手金融机构代码
         ,NULL                                     AS REAL_CNTPTY_FIN_INST_NAME--48真实交易对手金融机构名称
         ,A.TRAN_FLOW_ID                           AS CORE_TRAN_FLOW_NUM       --核心交易流水号
         ,A.TRAN_FLOW_ID                           AS ACCT_BILL_FLOW_NUM --50 账单流水号
         ,A.TRAN_FLOW_ID                           AS OVA_FLOW_NUM       --51 全局流水号
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_TM AS INIT_TRAN_TIMESTAMP --52 原交易时间戳 --ADD BY LIP 20241011
         ,B.STD_PROD_ID                            AS BUS_PROD_ID --业务产品编号 --ADD BY LIP 20250922
    FROM RRP_MDL.O_IML_EVT_IFS_ACCT_TRAN_DTL A --联合存款账户交易明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO B --联合存款分户信息 --ADD BY LIP 20250922
      ON B.CUST_ACCT_ID = A.ACCT_ID
     AND B.CUST_ACCT_SUB_ACCT_NUM = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP F1 --数仓补录码值表
      ON F1.SRC_VALUE_CODE = A.TRAN_TYPE_CD
     AND F1.SRC_CLASS_CODE = 'CD1311' --交易类型代码
     AND F1.TAR_CLASS_CODE = 'D0121' --ADD BY LIP 20220620
     AND F1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO G --银行卡基本信息表
      ON G.CARD_NO = A.CNTPTY_ACCT_ID
     AND A.CNTPTY_ACCT_ID LIKE '6%' --卡账户
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_AMT <> 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230711 增加电子现金交易流水信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款账户交易流水-电子现金交易数据信息';
  V_STARTTIME := SYSDATE;
  /****************************联合存款**************************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 NOLOGGING
    (DATA_DT                   --01数据日期
    ,LGL_REP_ID                --02法人编号
    ,TRA_SEQ_NO                --03交易流水号
    ,ACC_ID                    --04账户编号
    ,EXT_ACC                   --05外部账号
    ,CUST_ID                   --06客户编号
    ,CUST_NM                   --07客户名称
    ,ORG_ID                    --08机构编号
    ,SUBJ_ID                   --09科目编号
    ,CUR                       --10币种
    ,CORP_IND_FLG              --11对公对私标志
    ,TIME_DMD_FLG              --12定活标志
    ,TRA_AMT                   --13交易金额
    ,OPEN_ACC_ORG_ID           --14开户机构
    ,HDL_ORG_ID                --15经办机构编号
    ,ACC_BAL                   --16账户余额
    ,OPP_ACC                   --17对方账号
    ,OPP_ACC_NM                --18对方户名
    ,OPP_PBC_NO                --19对方行号
    ,OPP_BANK_NM               --20对方行名
    ,TRA_CHAN                  --21交易渠道
    ,CASH_TRF_FLG              --22现转标志
    ,AGT_NM                    --23代办人姓名
    ,AGT_CRDL_TYP              --24代办人证件类型
    ,AGT_CRDL_NO               --25代办人证件号码
    ,TRA_TLR_NO                --26交易柜员号
    ,GRANT_TLR_NO              --27授权柜员号
    ,ABSTR                     --28摘要
    ,FLUSH_PATCH_FLG           --29冲补抹标志
    ,TRA_DR_CR_FLG             --30交易借贷标志
    ,ADV_DRAW_FLG              --31提前支取标志
    ,TRA_DT                    --32交易日期
    ,TRA_TM                    --33交易时间
    ,TRA_MED_TYP               --34交易介质类型
    ,TRA_TYP                   --35交易类型
    ,DEP_IN_OUT_FLG            --36存入存出类型
    ,IP                        --37IP地址
    ,MAC                       --38MAC地址
    ,POSTSCRIPT                --39附言
    ,CTY_RG_CD                 --国家和地区代码
    ,DEPT_LINE                 --40部门条线
    ,DATA_SRC                  --41数据来源
    ,SUB_ACC_ID                --子账户编号
    ,ACC_ID_EAST               --内部账户编号_EAST
    ,REAL_CNTPTY_ACCT_ID       --真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME     --真实交易对手账户名称
    ,REAL_CNTPTY_FIN_INST_CD   --47真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME --48真实交易对手金融机构名称
    ,CORE_TRAN_FLOW_NUM        --49核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --50 账单流水号
    ,OVA_FLOW_NUM              --51 全局流水号
    ,INIT_TRAN_TIMESTAMP       --52 原交易时间戳 --ADD BY LIP 20241011
    ,BUS_PROD_ID               --业务产品编号 --ADD BY LIP 20250922
    )
  SELECT /*+USE HASH(A, B)*/
          TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT    --数据日期
         ,A.LP_ID                                  AS LGL_REP_ID --法人编号
         ,A.OVA_FLOW_NUM||TO_CHAR(A.TRAN_DT,'YYYYMMDD') AS TRA_SEQ_NO --交易流水号
         ,A.CARD_NO                                AS ACC_ID     --账户编号
         ,B.AGT_ID||B.CARD_SER_NUM                 AS EXT_ACC    --外部账号
         ,D.CUST_ID                                AS CUST_ID    --客户编号
         ,C.CUST_NAME                              AS CUST_NM    --客户名称
         ,A.TRAN_ORG_ID                            AS ORG_ID     --机构编号
         ,NULL                                     AS SUBJ_ID    --科目编号
         ,A.TRAN_CURR_CD                           AS CUR        --币种
         ,'1'                                      AS CORP_IND_FLG --对公对私标志
         ,NULL                                     AS TIME_DMD_FLG --定活标志
         ,A.TRAN_AMT                               AS TRA_AMT --交易金额
         ,NULL                                     AS OPEN_ACC_ORG_ID --开户机构
         ,A.TRAN_ORG_ID                            AS HDL_ORG_ID --经办机构编号
         ,A.ELEC_CASH_ACCT_BAL                     AS ACC_BAL --账户余额
         --MOD BY 20231114 根据业务提供的口径，电子现金的交易对手方就是自己
         ,CASE WHEN REPLACE(A.CNTPTY_ACCT_NUM,' ','') IS NOT NULL
               THEN REPLACE(A.CNTPTY_ACCT_NUM,' ','')
               ELSE TRIM(A.CARD_NO)
           END                                     AS OPP_ACC --对方账号
         ,CASE WHEN REPLACE(A.CNTPTY_ACCT_NUM,' ','') IS NOT NULL
               THEN F.CUST_NAME
               ELSE C.CUST_NAME
           END                                     AS OPP_ACC_NM --对方户名
         ,CASE WHEN REPLACE(A.CNTPTY_ACCT_NUM,' ','') IS NOT NULL
               THEN G.FIN_INST_CODE
               ELSE H.FIN_INST_CODE
           END                                     AS OPP_PBC_NO --对方行号
         ,CASE WHEN REPLACE(A.CNTPTY_ACCT_NUM,' ','') IS NOT NULL
               THEN G.BKNAME
               ELSE H.BKNAME
           END                                     AS OPP_BANK_NM --对方行名
         ,A.TRAN_CHN_ID                            AS TRA_CHAN --交易渠道
         ,'2'                                      AS CASH_TRF_FLG --现转标志
         ,NULL                                     AS AGT_NM --代办人姓名
         ,NULL                                     AS AGT_CRDL_TYP --代办人证件类型
         ,NULL                                     AS AGT_CRDL_NO --代办人证件号码
         ,A.TRAN_TELLER_ID                         AS TRA_TLR_NO --交易柜员号
         ,NULL                                     AS GRANT_TLR_NO --授权柜员号
         ,'电子现金交易'                           AS ABSTR --摘要
         ,'N'                                      AS FLUSH_PATCH_FLG --冲补抹标志
         ,A.DEBIT_CRDT_FLG                         AS TRA_DR_CR_FLG --交易借贷标志
         ,NULL                                     AS ADV_DRAW_FLG --提前支取标志
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')            AS TRA_DT --交易日期
         ,A.TRAN_TM                                AS TRA_TM
         ,CASE WHEN D.CARD_TYPE_CD = '0' THEN 'A'
               WHEN D.CARD_TYPE_CD = '1' THEN 'A'
               WHEN D.CARD_TYPE_CD = '2' THEN 'A'
               ELSE 'Z'
           END                                     AS TRA_MED_TYP --交易介质类型
         ,CASE WHEN A.TRAN_CODE IN ('1') THEN '03' --存现 --现金存入
               WHEN A.TRAN_CODE IN ('10') THEN 'IC13' --消费 --脱机消费
               WHEN A.TRAN_CODE IN ('2','3','6') THEN 'IC03' --圈存 --圈存,6调账默认圈存
               WHEN A.TRAN_CODE IN ('4','7') THEN 'IC10' --圈提 --圈提、结清
               WHEN A.TRAN_CODE IN ('8') THEN 'IC11' --ADD BY 20240402
           END                                     AS TRA_TYP --交易类型
         ,CASE WHEN A.DEBIT_CRDT_FLG = 'D' THEN '0' ELSE '1' END AS DEP_IN_OUT_FLG --存入存出类型 --MODIFY CCH 20220909
         ,NULL                                     AS IP --IP地址
         ,NULL                                     AS MAC --MAC地址
         ,NULL                                     AS POSTSCRIPT --附言
         ,C.NATION_CD                              AS CTY_RG_CD  --国家和地区代码
         ,NULL                                     AS DEPT_LINE --部门条线
         ,'电子现金'                               AS DATA_SRC --数据来源
         ,NVL(TRIM(A.CARD_SER_NUM),'00')           AS SUB_ACC_ID --子账户编号
         ,B.AGT_ID||B.CARD_SER_NUM                 AS ACC_ID_EAST
         ,NULL                                     AS REAL_CNTPTY_ACCT_ID --真实交易对手账户编号
         ,NULL                                     AS REAL_CNTPTY_ACCT_NAME --真实交易对手账户名称
         ,NULL                                     AS REAL_CNTPTY_FIN_INST_CD--47真实交易对手金融机构代码
         ,NULL                                     AS REAL_CNTPTY_FIN_INST_NAME--48真实交易对手金融机构名称
         ,A.SYS_FLOW_NUM                           AS CORE_TRAN_FLOW_NUM       --核心交易流水号
         ,A.PLAT_TRAN_FLOW_NUM                     AS ACCT_BILL_FLOW_NUM --50 账单流水号
         ,A.OVA_FLOW_NUM                           AS OVA_FLOW_NUM       --51 全局流水号
         ,TO_CHAR(A.TRAN_TM,'YYYYMMDDHH24MISSFF')  AS INIT_TRAN_TIMESTAMP --52 原交易时间戳 --ADD BY LIP 20241011
         ,'101010100004'                           AS BUS_PROD_ID --业务产品编号 --ADD BY LIP 20250922
    FROM RRP_MDL.O_IML_EVT_IC_CARD_TRAN_FLOW A --IC卡交易流水
    LEFT JOIN RRP_MDL.O_IML_AGT_IC_CARD_ELEC_CASH_ACCT_H B
      ON B.CARD_NO = A.CARD_NO
     AND B.CARD_SER_NUM = NVL(TRIM(A.CARD_SER_NUM),'00')
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ID_MARK <> 'D'
    LEFT JOIN RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO D --银行卡基本信息表
      ON D.CARD_NO = A.CARD_NO
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = D.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO E --银行卡基本信息表
      ON E.CARD_NO = A.CNTPTY_ACCT_NUM
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F --个人客户基本信息
      ON F.CUST_ID = E.CUST_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG G
      ON G.ORG_ID = F.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG H
      ON H.ORG_ID = A.TRAN_ORG_ID
   WHERE A.TRAN_AMT <> 0
     AND A.SERV_STATUS_DESCB IN ('SUCCESS','成功')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --数据插入目标表
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据插入目标表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL NOLOGGING
    (DATA_DT           --01数据日期
    ,LGL_REP_ID        --02法人编号
    ,TRA_SEQ_NO        --03交易流水号
    ,ACC_ID            --04账户编号
    ,EXT_ACC           --05外部账号
    ,CUST_ID           --06客户编号
    ,CUST_NM           --07客户名称
    ,ORG_ID            --08机构编号
    ,SUBJ_ID           --09科目编号
    ,CUR               --10币种
    ,CORP_IND_FLG      --11对公对私标志
    ,TIME_DMD_FLG      --12定活标志
    ,TRA_AMT           --13交易金额
    ,OPEN_ACC_ORG_ID   --14开户机构
    ,HDL_ORG_ID        --15经办机构编号
    ,ACC_BAL           --16账户余额
    ,OPP_ACC           --17对方账号
    ,OPP_ACC_NM        --18对方户名
    ,OPP_PBC_NO        --19对方行号
    ,OPP_BANK_NM       --20对方行名
    ,TRA_CHAN          --21交易渠道
    ,CASH_TRF_FLG      --22现转标志
    ,AGT_NM            --23代办人姓名
    ,AGT_CRDL_TYP      --24代办人证件类型
    ,AGT_CRDL_NO       --25代办人证件号码
    ,TRA_TLR_NO        --26交易柜员号
    ,GRANT_TLR_NO      --27授权柜员号
    ,ABSTR             --28摘要
    ,FLUSH_PATCH_FLG   --29冲补抹标志
    ,TRA_DR_CR_FLG     --30交易借贷标志
    ,ADV_DRAW_FLG      --31提前支取标志
    ,TRA_DT            --32交易日期
    ,TRA_TM            --33交易时间
    ,TRA_MED_TYP       --34交易介质类型
    ,TRA_TYP           --35交易类型
    ,DEP_IN_OUT_FLG    --36存入存出类型
    ,IP                --37IP地址
    ,MAC               --38MAC地址
    ,POSTSCRIPT        --39附言
    ,CTY_RG_CD
    ,DEPT_LINE         --40部门条线
    ,DATA_SRC          --41数据来源
    ,SUB_ACC_ID        --子账户编号
    ,ACC_ID_EAST       --账户编号_EAST
    ,US_AGE            --20221020 XUXIAOBIN ADD
    ,REAL_CNTPTY_ACCT_ID       --真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME     --真实交易对手账户名称
    ,REAL_CNTPTY_FIN_INST_CD   --47真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME --48真实交易对手金融机构名称  ADD BY MW 20230206
    ,CORE_TRAN_FLOW_NUM        --49 核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --50 账单流水号
    ,OVA_FLOW_NUM              --51 全局流水号
    ,INIT_TRAN_TIMESTAMP       --52 原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG         --53 对方对公账户标志 --ADD BY LIP 20241018
    ,BUS_PROD_ID               --业务产品编号 --ADD BY LIP 20250922
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260109
    ,TRAN_MEMO_DESCB           --附言 --ADD BY LIP 20260414
    )
    WITH ADR AS ( --ADD BY LIP 20251225
  SELECT /*+MATERIALIZE*/TRIM(BIC) AS BIC,TRIM(NAM1)||TRIM(NAM2)||TRIM(NAM3) AS NAM,TRIM(STR1)||TRIM(STR2) AS ADDSTR,
         ROW_NUMBER() OVER(PARTITION BY BIC ORDER BY INR) RN
    FROM RRP_MDL.O_IOL_ISBS_ADR T --存放所有PARTY的地址信息 --STFPRD.ADR
   WHERE TRIM(BIC) IS NOT NULL
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT DISTINCT /*+USE_HASH(T,TA,TB,TC)*/
          T.DATA_DT                              AS DATA_DT          --01数据日期
         ,T.LGL_REP_ID                           AS LGL_REP_ID       --02法人编号
         ,T.TRA_SEQ_NO                           AS TRA_SEQ_NO       --03交易流水号
         ,T.ACC_ID                               AS ACC_ID           --04账户编号
         ,T.EXT_ACC                              AS EXT_ACC          --05外部账号
         ,T.CUST_ID                              AS CUST_ID          --06客户编号
         ,T.CUST_NM                              AS CUST_NM          --07客户名称
         ,T.ORG_ID                               AS ORG_ID           --08机构编号
         ,T.SUBJ_ID                              AS SUBJ_ID          --09科目编号
         ,T.CUR                                  AS CUR              --10币种
         ,T.CORP_IND_FLG                         AS CORP_IND_FLG     --11对公对私标志
         ,T.TIME_DMD_FLG                         AS TIME_DMD_FLG     --12定活标志
         ,T.TRA_AMT                              AS TRA_AMT          --13交易金额
         ,T.OPEN_ACC_ORG_ID                      AS OPEN_ACC_ORG_ID  --14开户机构
         ,T.HDL_ORG_ID                           AS HDL_ORG_ID       --15经办机构编号
         ,T.ACC_BAL                              AS ACC_BAL          --16账户余额
         /*--MODIFY BY TANGAN AT 20230201 应业务卢萌要求修改 BEGIN--*/       
         ,TRIM(REPLACE(REPLACE(T.OPP_ACC,CHR(10),''),CHR(13),'')) AS OPP_ACC          --17对方账号
         ,CASE WHEN TRIM(T.OPP_ACC_NM) IS NOT NULL
               THEN TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.OPP_ACC_NM,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),''))
               WHEN TRIM(T1.ACCT_NAME) IS NOT NULL
               THEN TRIM(REPLACE(REPLACE(T1.ACCT_NAME,CHR(10),''),CHR(13),''))
          END                                     AS OPP_ACC_NM       --18对方户名
         ,CASE WHEN TRIM(T.OPP_PBC_NO) IS NOT NULL
               THEN TRIM(REPLACE(REPLACE(T.OPP_PBC_NO,CHR(10),''),CHR(13),''))
               WHEN TRIM(T1.FIN_INST_CODE) IS NOT NULL THEN TRIM(T1.FIN_INST_CODE)
          END                                     AS OPP_PBC_NO       --19对方行号
         ,CASE WHEN TRIM(T.OPP_BANK_NM) IS NOT NULL
               THEN TRIM(REPLACE(REPLACE(T.OPP_BANK_NM,CHR(10),''),CHR(13),''))
               WHEN T2.ORG_NAME IS NOT NULL THEN T2.ORG_NAME --MOD BY LIP 20230904
               WHEN T3.BKNAME IS NOT NULL THEN T3.BKNAME --银联号 --MOD BY LIP 20231010
               WHEN T4.NAM IS NOT NULL THEN T4.NAM --ADD BY LIP 20251225
               WHEN T5.INSTNA IS NOT NULL THEN T5.INSTNA --ADD BY LIP 20250105
               WHEN TRIM(T1.ORG_NAME) IS NOT NULL THEN TRIM(T1.ORG_NAME)
               WHEN T.ABSTR IN ('银联入账','POS','POS消费','消费免密免签','二维码消费','银联代收','银联转账','二维码收款',
                                '新兴存','二维码消费撤销','二维码退货','退货','预授权完成免密免签','ATM转','收单消费撤销',
                                'POS预授权完成','离线预授权完成')
               THEN '中国银联股份有限公司'
               WHEN T.ABSTR LIKE '银联%' THEN '中国银联股份有限公司'
               WHEN T.OPP_ACC_NM LIKE '银联%' THEN '中国银联股份有限公司'
               WHEN T1.ACCT_NAME LIKE '银联%' THEN '中国银联股份有限公司'
               WHEN T.ABSTR LIKE '%云闪付%' THEN '中国银联股份有限公司'
          END                                     AS OPP_BANK_NM      --20对方行名
         /*--MODIFY BY TANGAN AT 20230201 应业务卢萌要求修改 END----*/
         ,T.TRA_CHAN                              AS TRA_CHAN         --21交易渠道
         ,T.CASH_TRF_FLG                         AS CASH_TRF_FLG     --22现转标志
         ,TRIM(T.AGT_NM)                         AS AGT_NM           --23代办人姓名
         ,TRIM(T.AGT_CRDL_TYP)                   AS AGT_CRDL_TYP     --24代办人证件类型
         ,TRIM(T.AGT_CRDL_NO)                    AS AGT_CRDL_NO      --25代办人证件号码
         ,TRIM(T.TRA_TLR_NO)                     AS TRA_TLR_NO       --26交易柜员号
         ,TRIM(T.GRANT_TLR_NO)                   AS GRANT_TLR_NO     --27授权柜员号
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.ABSTR,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS ABSTR --28摘要
         ,T.FLUSH_PATCH_FLG                      AS FLUSH_PATCH_FLG  --29冲补抹标志
         ,T.TRA_DR_CR_FLG                        AS TRA_DR_CR_FLG    --30交易借贷标志
         ,T.ADV_DRAW_FLG                         AS ADV_DRAW_FLG     --31提前支取标志
         ,T.TRA_DT                               AS TRA_DT           --32交易日期
         ,T.TRA_TM                               AS TRA_TM           --33交易时间
         ,T.TRA_MED_TYP                          AS TRA_MED_TYP      --34交易介质类型
         ,T.TRA_TYP                              AS TRA_TYP          --35交易类型
         ,T.DEP_IN_OUT_FLG                       AS DEP_IN_OUT_FLG   --36存入存出类型
         ,TRIM(T.IP)                             AS IP               --37IP地址
         ,TRIM(T.MAC)                            AS MAC              --38MAC地址
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.POSTSCRIPT,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS POSTSCRIPT --39附言
         ,T.CTY_RG_CD                            AS CTY_RG_CD        --国家和地区
         ,T.DEPT_LINE                            AS DEPT_LINE        --40部门条线
         ,UPPER(T.DATA_SRC)                      AS DATA_SRC         --41数据来源
         ,T.SUB_ACC_ID                           AS SUB_ACC_ID       --子账户编号
         ,T.ACC_ID_EAST                          AS ACC_ID_EAST      --账户编号_EAST
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.US_AGE,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS US_AGE --资金用途20221020 XUXIAOBIN ADD
         ,TRIM(REPLACE(REPLACE(T.REAL_CNTPTY_ACCT_ID,CHR(10),''),CHR(13),'')) AS REAL_CNTPTY_ACCT_ID        --真实交易对手账户编号
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.REAL_CNTPTY_ACCT_NAME,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS REAL_CNTPTY_ACCT_NAME      --真实交易对手账户名称
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.REAL_CNTPTY_FIN_INST_CD,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS REAL_CNTPTY_FIN_INST_CD    --真实交易对手金融机构代码
         ,TRIM(REPLACE(REPLACE(REGEXP_REPLACE(T.REAL_CNTPTY_FIN_INST_NAME,'[· ？！?!$%^#°*?!^|       ]',''),CHR(10),''),CHR(13),'')) AS REAL_CNTPTY_FIN_INST_NAME  --真实交易对手金融机构名称
         ,T.CORE_TRAN_FLOW_NUM                   AS CORE_TRAN_FLOW_NUM       --核心交易流水号
         ,T.ACCT_BILL_FLOW_NUM                   AS ACCT_BILL_FLOW_NUM       --50 账单流水号
         ,T.OVA_FLOW_NUM                         AS OVA_FLOW_NUM             --51 全局流水号
         ,T.INIT_TRAN_TIMESTAMP                  AS INIT_TRAN_TIMESTAMP      --52 原交易时间戳 --ADD BY LIP 20241011
         ,CASE WHEN TRIM(T.OPP_BANK_NM) LIKE '%华兴%' THEN T1.CORP_ACCT_FLG
               WHEN T2.ORG_NAME IS NOT NULL AND T2.ORG_NAME LIKE '%华兴%' THEN T1.CORP_ACCT_FLG
               WHEN T3.BKNAME IS NOT NULL AND T3.BKNAME LIKE '%华兴%' THEN T1.CORP_ACCT_FLG
               WHEN TRIM(T1.ORG_NAME) IS NOT NULL AND TRIM(T1.ORG_NAME) LIKE '%华兴%' THEN T1.CORP_ACCT_FLG
               WHEN T.OPP_CORP_ACCT_FLG IS NOT NULL THEN T.OPP_CORP_ACCT_FLG --ADD BY LIP 20260106
               ELSE NULL
           END                                   AS OPP_CORP_ACCT_FLG        --53 对方对公账户标志 --ADD BY LIP 20241018
        ,T.BUS_PROD_ID                           AS BUS_PROD_ID              --业务产品编号 --ADD BY LIP 20250922
        ,T.MEMO_CD                               AS MEMO_CD                  --摘要代码 --ADD BY LIP 20260109
        ,T.TRAN_MEMO_DESCB                       AS TRAN_MEMO_DESCB          --附言 --ADD BY LIP 20260414
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 T
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 T1
      ON T1.ACCT_ID = T.OPP_ACC
    LEFT JOIN RRP_MDL.ADD_BANK_NAME_YL T2
      ON T2.YLH = TRIM(T.OPP_PBC_NO)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T3
      ON T3.BKCD = TRIM(T.OPP_PBC_NO)
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ADR T4 --ADD BY LIP 20251225
      ON T4.BIC = T.OPP_PBC_NO
     AND T4.RN = 1
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A51UBINSTID T5 --中台的银联机构信息表 --ADD BY LIP 20260105
      ON T5.INSTID = TRIM(T.OPP_PBC_NO)
     AND T5.RM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20241121 更新前一天的IP和MAC地址
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新前一天的IP和MAC地址';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT * FROM RRP_MDL.M_TRA_DEP_ACC_DTL
               WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD')) TA
  USING (SELECT * FROM ICL.V_CMM_DEP_ACCT_TRAN_DTL
          WHERE (TRIM(CLIENT_IP_ADDR) IS NOT NULL OR TRIM(CUST_TERMN_MAC_ADDR) IS NOT NULL)
            AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')-1) TB
     ON (TB.TRAN_FLOW_NUM = TA.CORE_TRAN_FLOW_NUM AND TB.ACCT_BILL_FLOW_NUM = TA.ACCT_BILL_FLOW_NUM)
   WHEN MATCHED THEN UPDATE SET
     TA.IP = TRIM(TB.CLIENT_IP_ADDR),
     TA.MAC = TRIM(TB.CUST_TERMN_MAC_ADDR);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20241220 更新本月内的代理人信息 如需调整历史数据，需单独调整
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新本月内的代理人信息';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT *
                FROM RRP_MDL.M_TRA_DEP_ACC_DTL
               WHERE DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')) TA
  USING (SELECT INIT_TRAN_OVA_FLOW_NUM,                         --原交易全局流水号
                TO_CHAR(INIT_TRAN_DT,'YYYYMMDD') INIT_TRAN_DT,  --原交易日期
                TRIM(PUBLIC_AGENT_NAME) PUBLIC_AGENT_NAME,      --代办人名称
                TRIM(CERT_TYPE_CD) CERT_TYPE_CD,                --证件类型代码  
                TRIM(CERT_NO) CERT_NO,                          --证件号码
                ROW_NUMBER() OVER(PARTITION BY INIT_TRAN_OVA_FLOW_NUM, INIT_TRAN_DT ORDER BY MODIF_DT DESC) RN
           FROM RRP_MDL.O_IML_EVT_PUBLIC_AGENT_MODIF_FLOW --代办人信息修改登记流水
          WHERE TRIM(PUBLIC_AGENT_NAME) IS NOT NULL
            AND TRIM(INIT_TRAN_OVA_FLOW_NUM) IS NOT NULL
            AND INIT_TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')) TB
     ON (TB.INIT_TRAN_DT = TA.DATA_DT AND TB.INIT_TRAN_OVA_FLOW_NUM = TA.OVA_FLOW_NUM AND TB.RN = 1)
   WHEN MATCHED THEN UPDATE SET
     TA.AGT_NM       = TB.PUBLIC_AGENT_NAME, --代办人名称
     TA.AGT_CRDL_TYP = TB.CERT_TYPE_CD,      --证件类型代码  
     TA.AGT_CRDL_NO  = TB.CERT_NO;           --证件号码

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE); --表分析

  --MOD BY LIP 20231010 月批调账后重跑一次后，增加月批的标志
  WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE PROC_NAME = V_PROC_NAME AND ETL_DATE = V_P_DATE)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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

END ETL_M_TRA_DEP_ACC_DTL;
/

