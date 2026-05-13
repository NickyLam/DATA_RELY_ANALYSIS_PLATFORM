CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_DEP_ACC_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_DEP_ACC_DTL
  *  功能描述：监管集市银行对公、对私活期及定期账户交易明细，不包括计息和扣利息税记录
     初始化一月数据
  *  创建日期：20220525
  *  开发人员：hulijuan
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
  *             1    20220919  hulj     调整账户编号,子账户号取值。
  *             2    20220903   MW      增加交易渠道TRAN_CHAN、交易类型TRAN_TYP口径。
  *             3    20220903   MW      增加交易渠道TRAN_CHAN、交易类型TRAN_TYP口径。
  *             4    20221024  hulj     交易类型调整码值。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20230201  tangan   根据业务卢萌反馈，先去掉交易对手兜底逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_DEP_ACC_DTL'; -- 程序名称
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_COUNT     INTEGER; --数据记录条数
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_START_DT   DATE;
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  I_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_TRA_DEP_ACC_DTL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  ----将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(SUBSTR(V_P_DATE, 1, 4) || '-' ||
                       SUBSTR(V_P_DATE, 5, 2) || '-' ||
                       SUBSTR(V_P_DATE, 7, 2),
                       'YYYY-MM-DD');
  V_START_DT:= TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'MM');
   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  I_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(I_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(I_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  I_START_DT := TO_CHAR(TO_DATE(I_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

      --加工账户信息
  V_STEP := 2;
  V_STEP_DESC := '加工账户信息--存款分户信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03';
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
    ACCT_ID,                   --账户编号
    ACCT_NAME,                 --账户名称
    CUST_ACCT_ID,              --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,    --客户账户子户号
    CDS_LIAB_ACCT_NUM,         --负债账户编号
    CUST_ID,                   --客户编号
    FLAG,                      --标志
    BELONG_ORG_ID,             --所属机构编号
    ORG_ID1,                   --目标机构号
    FIN_INST_CODE,             --目标机构银行机构代码
    ORG_NAME                   --目标机构银行机构名称
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.CUST_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         A.CDS_LIAB_ACCT_NUM                AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         'F'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME                  --目标机构银行机构名称
    --FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    FROM (SELECT DISTINCT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
          FROM (
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = V_DATE
               AND TRIM(CUST_ACCT_ID) IS NOT NULL
               UNION ALL
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_CARD_NO AS CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = V_DATE
               AND TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
          ) T
       ) A
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --加工账户信息
  V_STEP := 3;
  V_STEP_DESC := '加工账户信息--内部账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
    ACCT_ID,                   --账户编号
    ACCT_NAME,                 --账户名称
    CUST_ACCT_ID,              --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,    --客户账户子户号
    CDS_LIAB_ACCT_NUM,         --负债账户编号
    CUST_ID,                   --客户编号
    FLAG,                      --标志
    BELONG_ORG_ID,             --所属机构编号
    ORG_ID1,                   --目标机构号
    FIN_INST_CODE,             --目标机构银行机构代码
    ORG_NAME                   --目标机构银行机构名称
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.MAIN_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.SUB_ACCT_NUM                     AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         NULL                               AS CUST_ID,                  --客户编号
         'N'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME                  --目标机构银行机构名称
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --加工账户信息
  V_STEP := 4;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
    ACCT_ID,                   --账户编号
    ACCT_NAME,                 --账户名称
    CUST_ACCT_ID,              --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,    --客户账户子户号
    CDS_LIAB_ACCT_NUM,         --负债账户编号
    CUST_ID,                   --客户编号
    FLAG,                      --标志
    BELONG_ORG_ID,             --所属机构编号
    ORG_ID1,                   --目标机构号
    FIN_INST_CODE,             --目标机构银行机构代码
    ORG_NAME                   --目标机构银行机构名称
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.DUBIL_NUM                        AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         'L'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME                  --目标机构银行机构名称
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --加工账户信息
  V_STEP := 5;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
    ACCT_ID,                   --账户编号
    ACCT_NAME,                 --账户名称
    CUST_ACCT_ID,              --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,    --客户账户子户号
    CDS_LIAB_ACCT_NUM,         --负债账户编号
    CUST_ID,                   --客户编号
    FLAG,                      --标志
    BELONG_ORG_ID,             --所属机构编号
    ORG_ID1,                   --目标机构号
    FIN_INST_CODE,             --目标机构银行机构代码
    ORG_NAME                   --目标机构银行机构名称
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.DUBIL_NUM                        AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         'P'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME                  --目标机构银行机构名称
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --加工账户信息
  V_STEP := 5;
  V_STEP_DESC := '加工账户信息--存款主账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03(
    ACCT_ID,                   --账户编号
    ACCT_NAME,                 --账户名称
    CUST_ACCT_ID,              --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,    --客户账户子户号
    CDS_LIAB_ACCT_NUM,         --负债账户编号
    CUST_ID,                   --客户编号
    FLAG,                      --标志
    BELONG_ORG_ID,             --所属机构编号
    ORG_ID1,                   --目标机构号
    FIN_INST_CODE,              --目标机构银行机构代码
    ORG_NAME                   --目标机构银行机构名称
    )
  SELECT /*+USE_HASH(A,C,D)*/
         A.CUST_ACCT_ID                     AS ACCT_ID,                  --账户编号
         A.CUST_ACCT_NAME                   AS ACCT_NAME,                --账户名称
         A.CUST_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         'C'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.ACCT_BELONG_ORG_ID               AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME                  --目标机构银行机构名称
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.ACCT_BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-加工利息的对手方信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP04';
  INSERT INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP04(
      TRAN_DT,                   --交易日期
      TRAN_FLOW_NUM,             --交易流水号
      ACCT_BILL_FLOW_NUM,        --账单流水号
      CURR_CD,                   --币种代码CD1728
      AMT,                       --金额
      INVO_ACCT_ID,              --涉及账户编号
      MAIN_ACCT_ID,              --主账户编号
      CNTPTY_ACCT_ID             --对手方账户编号
      )
    SELECT /*+USE_HASH(A,B,C,D)*/
           A.TRAN_DT,                   --交易日期
           A.TRAN_FLOW_NUM,             --交易流水号
           A.ACCT_BILL_FLOW_NUM,        --账单流水号
           A.TRAN_CURR_CD,              --币种代码CD1728
           A.TRAN_AMT,                  --金额
           A.DEP_SUB_ACCT_ID,           --涉及账户编号
           D.MAIN_ACCT_ID,              --对手方主账户编号
           D.ACCT_ID  AS CNTPTY_ACCT_ID --对手方账户编号
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款分户账交易明细
     /*INNER JOIN RRP_MDL.O_IML_EVT_INSTR_TOT_RGST_B B  --指令汇总登记簿 --ADD BY LIP 20220712
             ON B.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
            AND B.TRAN_DT = A.TRAN_DT
            AND B.AMT = A.TRAN_AMT
            AND B.INSTR_TYPE_CD IN ('DI')--存息
            AND B.ETL_DT = V_DATE*/
      LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO C --存款分户信息
             ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
            AND C.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT D --内部账户
             ON D.SUBJ_ID = C.INT_PAYBL_SUBJ_ID
            AND D.BELONG_ORG_ID = C.BELONG_ORG_ID
            AND D.CURR_CD = C.CURR_CD
            AND D.ETL_DT = V_DATE
     --WHERE A.MEMO_CD_DESCB IN ('智能存款利息存入','存息','自动转存结息')
     WHERE A.MEMO_CD_DESCB IN ('智能存款利息存入','存息','自动转存结息','智能存款利息收入') --20220809 MODIFY BY LIP 增加智能存款利息收入
       AND A.ETL_DT = V_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP :=7; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-加工普通存款的对手方信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02';

  INSERT /*APPEND*/ INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02
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
    SELECT T.ETL_DT               AS ETL_DT   --数据日期
          ,T.TRAN_FLOW_NUM        AS TRAN_FLOW_NUM   --交易流水
          ,T.TRA_SEQ_NO           AS TRA_SEQ_NO   --交易序列号
          ,T.MAIN_ACCT_ID         AS MAIN_ACCT_ID   --账户号
          ,T.CUST_ACCT_ID         AS CUST_ACCT_ID   --对方账户号
          ,CASE WHEN REGEXP_REPLACE(T.CUST_NAME,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.CUST_NAME),'(','（'),')','）'),' ','')
                ELSE TRIM(T.CUST_NAME)
            END                   AS CUST_NAME   --对方账户名
          ,T.PBC_PAY_BANK_NO      AS PBC_PAY_BANK_NO   --对方行号
          ,T.ORG_NAME             AS ORG_NAME   --对方行名
          ,'普通存款'             AS DATA_SRC --数据来源
    FROM (SELECT /*+USE_HASH(A,B,X,EE,Y,C,D,E,I,H)*/
                 ROW_NUMBER() OVER(PARTITION BY A.TRAN_DT,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC, X.TRAN_AMT DESC,TRIM(A.CNTPTY_OPEN_BANK_ID)) AS NU
                ,A.ETL_DT
                ,A.TRAN_FLOW_NUM
                ,A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD') AS TRA_SEQ_NO
                ,A.CUST_ACCT_ID                                 AS MAIN_ACCT_ID --账户号
                ,CASE WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID) --自己表不为空时，取本表的
                      WHEN TRIM(A.CUST_ACCT_ID) IS NOT NULL THEN TRIM(A.CUST_ACCT_ID) --内部户不为空时，取内部户的账号
                      WHEN TRIM(X.CUST_ACCT_ID) IS NOT NULL THEN TRIM(X.CUST_ACCT_ID) --多借多贷的情况，取对方的账号
                      WHEN TRIM(Y.CUST_ACCT_ID) IS NOT NULL THEN TRIM(Y.CUST_ACCT_ID) --利息收入取对手的账号
                  END                                           AS CUST_ACCT_ID -- 对方账户号
                ,CASE WHEN TRIM(A.CNTPTY_ACCT_NAME) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
                      WHEN TRIM(C.ACCT_NAME) IS NOT NULL THEN TRIM(C.ACCT_NAME) --当借据的户名不为空时，取借据的户名
                      WHEN TRIM(Y.ACCT_NAME) IS NOT NULL THEN TRIM(Y.ACCT_NAME) --当借据的户名不为空时，取借据的户名
                      WHEN TRIM(X.CUST_NAME) IS NOT NULL THEN TRIM(X.CUST_NAME) --当借据的户名不为空时，取借据的户名
                      WHEN A.MEMO_CD_DESCB IN ('灵活盈','跳板存款','睡眠户转回') THEN A.CUST_NAME
                  END                                           AS CUST_NAME --对方户名
                ,CASE WHEN I.FIN_INST_CODE IS NOT NULL THEN I.FIN_INST_CODE
                      WHEN C.FIN_INST_CODE IS NOT NULL THEN C.FIN_INST_CODE
                      WHEN TRIM(A.CNTPTY_ACCT_NAME) IS NOT NULL THEN NULL
                      WHEN Y.FIN_INST_CODE IS NOT NULL THEN Y.FIN_INST_CODE
                      WHEN H.FIN_INST_CODE IS NOT NULL AND NVL(TRIM(A.CUST_ACCT_ID),TRIM(X.CUST_ACCT_ID)) IS NOT NULL
                           AND TRIM(A.CNTPTY_ACCT_ID) IS NULL
                      THEN H.FIN_INST_CODE
                  END                                           AS PBC_PAY_BANK_NO --对方行号
                ,CASE WHEN I.ORG_NAME IS NOT NULL THEN I.ORG_NAME
                      WHEN C.ORG_NAME IS NOT NULL THEN C.ORG_NAME
                      WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN
                        CASE WHEN A.RECE_DESCB_INFO LIKE '%快捷支付%'
                             THEN SUBSTR(A.RECE_DESCB_INFO,INSTR(A.RECE_DESCB_INFO,'：')+1,INSTR(A.RECE_DESCB_INFO,'（')-INSTR(A.RECE_DESCB_INFO,'：')-1)
                             WHEN A.MEMO_CD_DESCB IN ('银联入账','POS','POS消费','消费免密免签','二维码消费','银联代收','银联转账','二维码收款',
                                                      '新兴存','二维码消费撤销','二维码退货','退货','预授权完成免密免签','ATM转')
                             THEN '中国银联股份有限公司'
                             WHEN A.MEMO_CD_DESCB LIKE '银联%' THEN '中国银联股份有限公司'
                             WHEN A.CNTPTY_ACCT_NAME LIKE '%财付通%' THEN '财付通'
                             WHEN A.CNTPTY_ACCT_NAME LIKE '%支付宝%' THEN '支付宝'
                         END
                      WHEN Y.ORG_NAME IS NOT NULL THEN Y.ORG_NAME
                      WHEN H.ORG_NAME IS NOT NULL  AND NVL(TRIM(A.CUST_ACCT_ID),TRIM(X.CUST_ACCT_ID)) IS NOT NULL
                           AND TRIM(A.CNTPTY_ACCT_ID) IS NULL
                      THEN H.ORG_NAME
                  END                                            AS ORG_NAME --对方行名
          FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款分户账交易明细
          LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL X --存款分户账交易明细
                 ON X.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
                AND X.DEP_SUB_ACCT_ID <> A.DEP_SUB_ACCT_ID  --存款分户编号是唯一的
                AND UPPER(SUBSTR(X.JOB_CD,1,4)) IN ('CBSS')   --电子账户有多个流水对应多个客户的情况
                AND X.ETL_DT = V_DATE
          LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP04 EE  --指令汇总登记簿 --ADD BY LIP 20220712
                 ON EE.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
                AND EE.TRAN_DT = A.TRAN_DT
                --AND EE.AMT = A.TRAN_AMT
                AND EE.TRAN_DT = V_DATE
          LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 Y --内部账户
                 --ON Y.ACCT_ID = NVL(TRIM(B.INTNAL_ACCT_ID),TRIM(EE.CNTPTY_ACCT_ID))  --分户号
                 ON Y.ACCT_ID = COALESCE(TRIM(A.DEP_SUB_ACCT_ID),TRIM(EE.CNTPTY_ACCT_ID),TRIM(A.CNTPTY_ACCT_ID))  --分户号
                AND Y.FLAG IN ('L','P','F','N') --F分户 N内部户 L对公贷款 P零售贷款 C主账户
          LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP03 C --账号信息--临时表
                 ON C.CUST_ACCT_ID = A.CNTPTY_ACCT_ID  --借据号或主账户号
                --AND C.FLAG IN ('L','P','C') --F分户 N内部户 L对公贷款 P零售贷款 C主账户
                AND C.FLAG IN ('L','P','C','N') --F分户 N内部户 L对公贷款 P零售贷款 C主账户
          LEFT JOIN RRP_MDL.ORG_CONFIG I
                 ON I.ORG_ID = TRIM(A.CNTPTY_OPEN_BANK_ID)
          LEFT JOIN RRP_MDL.ORG_CONFIG H
                 ON H.ORG_ID = NVL(TRIM(A.TRAN_ORG_ID),TRIM(X.ACCT_ORG_ID))
          WHERE /*NVL(TRIM(B.TRAN_FLOW_NUM),TRIM(X.TRAN_FLOW_NUM)) IS NOT NULL
            AND*/ A.ETL_DT >= TRUNC(V_DATE,'MM')
            AND A.ETL_DT <= V_DATE
         ) T
    WHERE T.NU = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 8; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户交易流水-普通存款数据信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01';
  /***********************普通存款****************************/
  INSERT /*+APPEND */INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 NOLOGGING
  (
      DATA_DT           --01数据日期
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
     ,IP                --37ip地址
     ,MAC               --38mac地址
     ,POSTSCRIPT        --39附言
     ,CTY_RG_CD         --国家和地区
     ,DEPT_LINE         --40部门条线
     ,DATA_SRC          --41数据来源
     ,SUB_ACC_ID        --42子账户编号
     ,ACC_ID_EAST       --43内部账户编号
     ,US_AGE            --44 20221020 XUXIAOBIN ADD JS
     ,REAL_CNTPTY_ACCT_ID
                        --45真实交易对手账户编号
     ,REAL_CNTPTY_ACCT_NAME
                        --46真实交易对手名称
     ,REAL_CNTPTY_FIN_INST_CD
                        --47真实交易对手金融机构代码
     ,REAL_CNTPTY_FIN_INST_NAME
                        --48真实交易对手金融机构名称
     ,CORE_TRAN_FLOW_NUM
                        --49 核心交易流水号
  )
  SELECT
        TO_CHAR(A.TRAN_DT, 'YYYYMMDD')            AS DATA_DT    --数据日期
       ,A.LP_ID                                  AS LGL_REP_ID --法人编号
       ,A.TRAN_FLOW_NUM || A.ACCT_BILL_FLOW_NUM||A.CUST_ID||TO_CHAR(A.TRAN_DT,'YYYYMMDD')
                                                 AS TRA_SEQ_NO --交易流水号
       ,A.CUST_ACCT_ID                           AS ACC_ID     --账户编号
       ,NVL(TRIM(A.OLD_SUB_ACCT_ID),A.DEP_SUB_ACCT_ID)  AS EXT_ACC    --外部账号
       ,A.CUST_ID                                AS CUST_ID    --客户编号
       ,NVL(C.CUST_NAME, D.CUST_NAME)            AS CUST_NM    --客户名称
       ,/*KK.ORG_ID1*/A.ACCT_ORG_ID               AS ORG_ID     --机构编号--20221019 xuxiaobin MODIFY
       ,--E.SUBJ_ID
        NULL                                     AS SUBJ_ID    --科目编号
       ,A.TRAN_CURR_CD                           AS CUR        --币种
       ,CASE WHEN C.CUST_ID IS NOT NULL THEN '1'  --对私
             WHEN D.CUST_ID IS NOT NULL THEN '2'  --对公
        END                                      AS CORP_IND_FLG --对公对私标志
       ,NULL                                     AS TIME_DMD_FLG --定活标志
       ,A.TRAN_AMT                               AS TRA_AMT --交易金额
       ,A.ACCT_ORG_ID                            AS OPEN_ACC_ORG_ID --开户机构
       ,A.TRAN_ORG_ID                            AS HDL_ORG_ID --经办机构编号
       ,A.TRAN_BAL                               AS ACC_BAL --账户余额
       /*---modify by tangan at 20230201 应业务卢萌要求修改 BEGIN----*/
       ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC)  --modify by tangan at 20230207
             WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
             WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
             WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL AND NVL(TRIM(A.CNTPTY_ACCT_ID),'0') IN ('0','-','--') THEN TRIM(B.RECVER_ACCT_NUM) --ADD BY LIP 20220707
           -- ELSE TRIM(G.CUST_ACCT_ID)
        END                                    AS OPP_ACC --对方账号
       ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM) --modify by tangan at 20230207
             WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
             WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
             WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_NAME)
           --  ELSE TRIM(G.CUST_NAME)
          END                                     AS OPP_ACC_NM --对方户名 均为中文时，EAST替换半角括号为全角括号
       ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))  --modify by tangan at 20230207
             WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD))
             WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID))
             WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_OPEN_BANK_NO)
           --  ELSE TRIM(G.PBC_PAY_BANK_NO)
           END                                     AS OPP_PBC_NO --对方行号

       ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.ORG_NAME),TRIM(TC.OPP_BANK_NM))  --modify by tangan at 20230207
             WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.ORG_NAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))
             WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.ORG_NAME),TRIM(A.CNTPTY_OPEN_BANK_NAME))
             WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL THEN TRIM(B.RECVER_OPEN_BANK_NAME)
             -- WHEN TRIM(G.ORG_NAME) IS NOT NULL THEN TRIM(G.ORG_NAME)
          END                                      AS OPP_BANK_NM --对方行名
       /*---modify by tangan at 20230201 应业务卢萌要求修改 END----*/
       ,A.CHN_CD                                     AS TRA_CHAN    --交易渠道
       ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' -- 现
             /*  WHEN A.MEMO_CD IN ('D1','D2','C3','CD','AQ','TC','CA','AD','AF') THEN '1' -- 现
               WHEN A.MEMO_CD IN ('AC','YL','AD','CR') THEN '1' -- 现 AC银联取现  YL银联 AD:ATM存款  CR存入 */  --modify by mw 20221210 暂时注释
               WHEN A.CASH_TRANS_FLG = '0' THEN '2' -- 转
               ELSE '2'
          END                                      AS CASH_TRF_FLG --现转标志
          --源数据问题存在ATM存取现金的现转标志是转，按照摘要调整
         ,TRIM(A.AGENT_NAME)                       AS AGT_NM --代办人姓名
         ,A.AGENT_CERT_TYPE_CD                     AS AGT_CRDL_TYP --代办人证件类型
         ,TRIM(A.AGENT_CERT_NO)                    AS AGT_CRDL_NO --代办人证件号码
         ,TRIM(A.TRAN_TELLER_ID)                   AS TRA_TLR_NO --交易柜员号
        --  ,TRIM(A.AUTH_TELLER_ID)                   AS GRANT_TLR_NO --授权柜员号
         ,NVL(TRIM(A.CHECK_TELLER_ID),TRIM(A.AUTH_TELLER_ID))                  AS GRANT_TLR_NO   -- 20230130 授权柜员改为取核心的复核柜员
         ,CASE WHEN TRIM(TM.MEMO_CODE_DESCB) IS NOT NULL THEN TM.MEMO_CODE_DESCB
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EEA000601' THEN 'EEA000601司法扣划'
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EEA000301' THEN 'EEA000301理财收益'
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS000102' THEN 'EAS000102资金转出'
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001013' THEN 'EAS001013兴E贷还款'
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001101' THEN 'EAS001101华兴尊享划转'
               WHEN TRIM(A.MEMO_CD_DESCB) = 'EAS001102' THEN 'EAS001102华兴尊享还款'
               WHEN TRIM(A.MEMO_CD_DESCB) IS NOT NULL THEN TRIM(A.MEMO_CD_DESCB)
               ELSE TRIM(A.TRAN_DESCB)
           END                                     AS ABSTR --摘要
         ,A.TRAN_STATUS_CD                         AS FLUSH_PATCH_FLG --冲补抹标志  --TRAN_STATUS_CD 通过交易状态代码判断
         ,/*CASE WHEN A.DEBIT_CRDT_DIR_CD IS NULL AND (A.ERASE_ACCT_FLG = '1' OR A.REVS_FLG =  '1')
               THEN 'D'
               ELSE A.DEBIT_CRDT_DIR_CD
          END */
          A.DEBIT_CRDT_DIR_CD                      AS TRA_DR_CR_FLG --交易借贷标志
         ,NULL                                     AS ADV_DRAW_FLG --提前支取标志
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')           AS TRA_DT --交易日期
         ,A.TRAN_TIMESTAMP                         AS TRA_TM --交易时间
         ,CASE WHEN H.CARD_TYPE_CD='0'THEN 'A'
               WHEN H.CARD_TYPE_CD='1'THEN 'A'
               WHEN H.CARD_TYPE_CD='2'THEN 'A'
               ELSE 'Z'
               END                                  AS TRA_MED_TYP --交易介质类型
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
                    OR A.CHN_CD = '2306' THEN '17' -- ADD BY LIUYU 为了和交易渠道校验添加'其他-三方支付'
               WHEN A.MEMO_CD_DESCB = 'POS' OR A.MEMO_CD_DESCB LIKE '%消费%' THEN '06'--消费 --modify by hulj 20221024
               WHEN A.MEMO_CD IN ('TR','AP','ET','EL','AR','AI','AM','AS','EO','EF') THEN '01'--转账 --modify by hulj 20221024
               WHEN A.TRAN_KIND_CD IN ('TR','4986','4989') THEN '01'--转账
               ELSE A.TRAN_KIND_CD --其他-银行自定义类型
          END                                      AS TRA_TYP --交易类型
          --ADD BY LIUYU 根据业务和科技反馈使用摘要判断交易类型，数仓交易类型码值CD1311
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN '0' ELSE '1' END AS DEP_IN_OUT_FLG --存入存出类型  --MODIFY  CCH  20220909
         ,A.CLIENT_IP_ADDR                         AS IP --IP地址
         ,A.CUST_TERMN_MAC_ADDR                    AS MAC --MAC地址
         ,A.RECE_DESCB_INFO                        AS POSTSCRIPT --附言
         ,NVL(C.NATION_CD,D.CTY_RG_CD)             AS CTY_RG_CD         --国家和地区
         ,NULL                                     AS DEPT_LINE --部门条线
         ,'普通存款'                               AS DATA_SRC --数据来源
         ,A.SUB_ACCT_ID                            AS SUB_ACC_ID --子账户编号
         ,A.DEP_SUB_ACCT_ID                        AS ACC_ID_EAST --内部账户编号(EAST)
         ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN 'A'
               WHEN A.MEMO_CD IN ('D1','D2','C3','CD','AQ','TC','CA','AD','AF') THEN 'A'
                ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((CASE WHEN REGEXP_LIKE(TRIM(A.RECE_DESCB_INFO), '^([A-Z]|[0-9])+$') OR TRIM(A.RECE_DESCB_INFO) IS NULL THEN TRIM(A.MEMO_CD_DESCB) ELSE TRIM(A.RECE_DESCB_INFO) END),
                                               '?',''),'!',''),'^',''),'？',''),'！',''),' ',''),'  ',''),'|',''),'  ','')
                END  AS US_AGE --20221020 XUXIAOBIN ADD
         ,A.REAL_CNTPTY_ACCT_ID                    AS REAL_CNTPTY_ACCT_ID    --真实交易对手账户编号
         ,A.REAL_CNTPTY_ACCT_NAME                  AS REAL_CNTPTY_ACCT_NAME  --真实交易对手账户名称
         ,A.REAL_CNTPTY_FIN_INST_CD                AS REAL_CNTPTY_FIN_INST_CD--47真实交易对手金融机构代码
         ,A.REAL_CNTPTY_FIN_INST_NAME              AS REAL_CNTPTY_FIN_INST_NAME--48真实交易对手金融机构名称
         ,A.TRAN_FLOW_NUM                          AS CORE_TRAN_FLOW_NUM     --49核心交易流水号
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细表
    /*LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02 G  --ADD BY LIP 20220622 增加对手方信息的来源
           ON G.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
          AND G.ETL_DT = V_DATE*/
    /*LEFT JOIN RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW B  --人行通道交易流水表*/
    LEFT JOIN (  --modify by tangan at 20230130
               SELECT TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM AS TRAN_FLOW_NUM_BB
               ,ROW_NUMBER() OVER(PARTITION BY TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM ORDER BY JOB_CD DESC) AS RN
               ,BB.*
               FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW BB --人行通道交易流水表
               WHERE BB.TRAN_DT >= TRUNC(V_DATE,'MM')
               AND BB.TRAN_DT <= V_DATE
            ) B
           /*ON B.OVA_FLOW_NUM = A.OVA_FLOW_NUM*/
           ON B.TRAN_FLOW_NUM_BB = A.TRAN_FLOW_NUM
          AND TRIM(A.MEMO_CD_DESCB) IN ('缴税','社保费','社保')  --modify by tangan at 20230130
          AND B.TRAN_DT = A.TRAN_DT
          AND B.RN = 1
          --AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
           ON C.CUST_ID = A.CUST_ID
          AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
           ON D.CUST_ID = A.CUST_ID
          AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP02 G  --增加对手方信息的来源
             ON G.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
            AND G.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.CODE_MAP F1 --数仓补录码值表
           ON F1.SRC_VALUE_CODE = A.TRAN_KIND_CD
          AND F1.SRC_CLASS_CODE = 'CD1311' -- 交易类型代码
          AND F1.TAR_CLASS_CODE = 'D0121' --ADD BY LIP 20220620
          AND F1.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP F2 --数仓补录码值表
           ON F2.SRC_VALUE_CODE = A.CHN_CD
          AND F2.SRC_CLASS_CODE = 'CD1751' -- 渠道代码
          AND F2.TAR_CLASS_CODE = 'Z0014' --ADD BY LIP 20220620
          AND F2.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.M_MID_TRA_CNTPTY_INFO TC --交易对手信息中间表 --add by tangan at 20230207
           ON TC.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
          AND TC.TRA_DT = TO_CHAR(A.TRAN_DT,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG KK
           ON KK.ORG_ID = A.ACCT_ORG_ID  -- MOD BY LIUYU 修改关联条件
    LEFT JOIN RRP_MDL.ORG_CONFIG B1
           ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B2  --modify by tangan at 20230201
           ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN RRP_MDL.ORG_CONFIG B3  --modify by tangan at 20230207
           ON B3.ORG_ID = TC.OPP_PBC_NO
    LEFT JOIN O_ICL_CMM_BANK_CARD_BASIC_INFO H --银行卡基本信息表
           ON A.ETL_DT = H.ETL_DT
           --AND A.CUST_ACCT_ID LIKE '6%' --卡账户
           AND H.CARD_NO = A.CUST_ACCT_ID
    LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB TM --modify by tangan at 20230203
      ON A.MEMO_CD = TM.MEMO_CODE
     AND TM.START_DT <= V_DATE
     AND TM.END_DT > V_DATE
   WHERE A.TRAN_AMT <> 0
     AND TRUNC(A.TRAN_DT,'MM') = TRUNC(V_DATE,'MM')
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  V_STEP :=9;
  V_STEP_DESC := '插入存款账户交易流水-联合存款数据信息';
  V_STARTTIME := SYSDATE;
  /****************************联合存款**************************/
  INSERT /*+APPEND */INTO RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 NOLOGGING
  (
      DATA_DT           --01数据日期
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
     ,IP                --37ip地址
     ,MAC               --38mac地址
     ,POSTSCRIPT        --39附言
     ,CTY_RG_CD         --国家和地区代码
     ,DEPT_LINE         --40部门条线
     ,DATA_SRC          --41数据来源
     ,SUB_ACC_ID        --子账户编号
     ,ACC_ID_EAST       --内部账户编号_EAST
     ,REAL_CNTPTY_ACCT_ID
                        --真实交易对手账户编号
     ,REAL_CNTPTY_ACCT_NAME
                        --真实交易对手账户名称
     ,REAL_CNTPTY_FIN_INST_CD
                        --47真实交易对手金融机构代码
     ,REAL_CNTPTY_FIN_INST_NAME
                        --48真实交易对手金融机构名称
     ,CORE_TRAN_FLOW_NUM--49核心交易流水号
  )
  SELECT /*+USE HASH(A, B)*/
          TO_CHAR(A.TRAN_DT, 'YYYYMMDD')           AS DATA_DT    --数据日期
         ,A.LP_ID                                  AS LGL_REP_ID --法人编号
         ,A.TRAN_FLOW_ID||A.CUST_ID||TO_CHAR(A.TRAN_DT, 'YYYYMMDD')
                                                   AS TRA_SEQ_NO --交易流水号
         ,A.ACCT_ID                                AS ACC_ID     --账户编号
         ,A.ACCT_ID || A.DEP_SUB_ACCT_ID           AS EXT_ACC    --外部账号
         ,A.CUST_ID                                AS CUST_ID    --客户编号
         ,NVL(C.CUST_NAME, D.CUST_NAME)            AS CUST_NM    --客户名称
         ,/*KK.ORG_ID1*/A.TRAN_ORG_ID              AS ORG_ID     --机构编号 --20221019 xuxiaobin MODIFY
         ,--E.SUBJ_ID --MOD BY LIUYU 20220429 科目号逻辑置空
          NULL                                     AS SUBJ_ID    --科目编号
         ,'CNY'                                    AS CUR        --币种
         ,CASE WHEN C.CUST_ID IS NOT NULL THEN '1'
               WHEN D.CUST_ID IS NOT NULL THEN '2'
          END                                      AS CORP_IND_FLG --对公对私标志
         ,NULL                                     AS TIME_DMD_FLG --定活标志
         ,A.TRAN_AMT                               AS TRA_AMT --交易金额
         ,NULL                                     AS OPEN_ACC_ORG_ID --开户机构
         ,A.TRAN_ORG_ID                            AS HDL_ORG_ID --经办机构编号
         ,A.DEP_RCPT_BAL                           AS ACC_BAL --账户余额
         ,REPLACE(A.CNTPTY_ACCT_ID,' ','')         AS OPP_ACC --对方账号
         ,CASE WHEN REGEXP_REPLACE(A.CNTPTY_ACCT_NAME,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
               THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPTY_ACCT_NAME),'(','（'),')','）'),' ','')
               ELSE TRIM(A.CNTPTY_ACCT_NAME)
          END                                      AS OPP_ACC_NM --对方户名
         ,A.CNTPTY_ORG_ID                          AS OPP_PBC_NO --对方行号
         ,'微众银行'                                AS OPP_BANK_NM --对方行名
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
         ,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT, 'YYYY-MM-DD') || ' ' ||TO_CHAR(TO_DATE(A.TRAN_TM, 'HH24:MI:SS'), 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS')
                                                   AS TRA_TM --tran_tm tran_tm varchar2(10)
         ,CASE WHEN G.CARD_TYPE_CD='0'THEN 'A'
               WHEN G.CARD_TYPE_CD='1'THEN 'A'
               WHEN G.CARD_TYPE_CD='2'THEN 'A'
               ELSE 'Z'
               END                                 AS TRA_MED_TYP --交易介质类型
         ,NVL(F1.TAR_VALUE_CODE,'99')              AS TRA_TYP --交易类型
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN '0' ELSE '1' END AS DEP_IN_OUT_FLG --存入存出类型  --MODIFY  CCH  20220909
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
    FROM RRP_MDL.O_IML_EVT_IFS_ACCT_TRAN_DTL A --联合存款账户交易明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.CODE_MAP F1 --数仓补录码值表
      ON F1.SRC_VALUE_CODE = A.TRAN_TYPE_CD
     AND F1.SRC_CLASS_CODE = 'CD1311' -- 交易类型代码
     AND F1.TAR_CLASS_CODE = 'D0121' --ADD BY LIP 20220620
     AND F1.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.ORG_CONFIG KK
      ON KK.ORG_ID = A.TRAN_ORG_ID
    LEFT JOIN O_ICL_CMM_BANK_CARD_BASIC_INFO G --银行卡基本信息表
      ON A.ETL_DT = G.ETL_DT
      AND A.CNTPTY_ACCT_ID LIKE '6%' --卡账户
      AND G.CARD_NO = A.CNTPTY_ACCT_ID
   WHERE A.TRAN_AMT <> 0
      AND TRUNC(A.TRAN_DT,'MM') = TRUNC(V_DATE,'MM')
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --数据插入目标表
  V_STEP :=10;
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
     ,REAL_CNTPTY_ACCT_ID --真实交易对手账户编号
     ,REAL_CNTPTY_ACCT_NAME --真实交易对手账户名称
     ,REAL_CNTPTY_FIN_INST_CD--47真实交易对手金融机构代码
     ,REAL_CNTPTY_FIN_INST_NAME--48真实交易对手金融机构名称  ADD BY MW 20230206
     ,CORE_TRAN_FLOW_NUM       --49 核心交易流水号
    )
  SELECT DISTINCT  /*+USE_HASH(T,TA,TB,TC)*/
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
         --,NVL(TC.ORG_ID1,'800')                  AS HDL_ORG_ID       --15经办机构编号
         ,T.ACC_BAL                              AS ACC_BAL          --16账户余额
         /*---modify by tangan at 20230201 应业务卢萌要求修改 BEGIN----*/
        /* ,CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
               WHEN T.POSTSCRIPT LIKE '%灵活盈转%' AND T.CASH_TRF_FLG = '1' THEN TRIM(T.EXT_ACC)
               WHEN T.ABSTR IN ('灵活盈','跳板存款','睡眠户转回') THEN TRIM(T.EXT_ACC)
               WHEN T.ABSTR IN ('存息','转开','转销') THEN TRIM(T.EXT_ACC)
           END                                   AS OPP_ACC          --17对方账号
         ,CASE WHEN TRIM(T.OPP_ACC_NM) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
               WHEN T.POSTSCRIPT LIKE '%灵活盈转%' AND T.CASH_TRF_FLG = '1' THEN T.CUST_NM
               WHEN T.ABSTR IN ('灵活盈','跳板存款','睡眠户转回') THEN T.CUST_NM
               WHEN T.ABSTR IN ('存息','转开','转销') THEN T.CUST_NM
           END                                   AS OPP_ACC_NM       --18对方户名
         ,CASE WHEN TRIM(T.OPP_PBC_NO) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
               WHEN T.POSTSCRIPT LIKE '%灵活盈转%' AND T.CASH_TRF_FLG = '1' THEN NVL(TRIM(TA.FIN_INST_CODE),TRIM(TB.FIN_INST_CODE))
               WHEN T.ABSTR IN ('灵活盈','跳板存款','睡眠户转回') THEN NVL(TRIM(TA.FIN_INST_CODE),TRIM(TB.FIN_INST_CODE))
               WHEN T.ABSTR IN ('存息','转开','转销') THEN NVL(TRIM(TA.FIN_INST_CODE),TRIM(TB.FIN_INST_CODE))
           END                                   AS OPP_PBC_NO       --19对方行号
         ,CASE WHEN TRIM(T.OPP_BANK_NM) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
               WHEN T.POSTSCRIPT LIKE '%快捷支付%'
               THEN SUBSTR(T.POSTSCRIPT,INSTR(T.POSTSCRIPT,'：')+1,INSTR(T.POSTSCRIPT,'（')-INSTR(T.POSTSCRIPT,'：')-1)
               WHEN T.OPP_ACC_NM LIKE '%财付通%' THEN '财付通'
               WHEN T.OPP_ACC_NM LIKE '%支付宝%' THEN '支付宝'
               WHEN T.OPP_ACC_NM LIKE '银联%' THEN '中国银联股份有限公司'
               --摘要为转账交易渠道为三方支付-网联支付对手方行号和行名 是否可以默认网联 --MODIFY BY LIP 20220712
               --WHEN T.TRA_CHAN = '08-2306' THEN '网联清算有限公司'
               WHEN T.TRA_CHAN = '403007' THEN '网联清算有限公司' --modify by tangan at 20230130
               WHEN T.POSTSCRIPT LIKE '%灵活盈转%' AND T.CASH_TRF_FLG = '1' THEN NVL(TRIM(TA.ORG_NAME),TRIM(TB.ORG_NAME))
               WHEN T.ABSTR IN ('灵活盈','跳板存款','睡眠户转回') THEN NVL(TRIM(TA.ORG_NAME),TRIM(TB.ORG_NAME))
               WHEN T.ABSTR IN ('存息','转开','转销','手续费','预授权','银承备款','兴享存')
               THEN NVL(TRIM(TA.ORG_NAME),TRIM(TB.ORG_NAME))
               WHEN T.POSTSCRIPT IN ('存息','转开','转销','手续费','预授权','银承备款','兴享存')
               THEN NVL(TRIM(TA.ORG_NAME),TRIM(TB.ORG_NAME))
               WHEN T.POSTSCRIPT IN ('大额存单','新兴存','零售定期存款') THEN NVL(TRIM(TA.ORG_NAME),TRIM(TB.ORG_NAME))
               WHEN TRIM(T.OPP_PBC_NO) = '313586000006' THEN '广东华兴银行股份有限公司'
           END                                    AS OPP_BANK_NM      --20对方行名*/
         ,T.OPP_ACC                               AS OPP_ACC          --17对方账号
         ,T.OPP_ACC_NM                            AS OPP_ACC_NM       --18对方户名
         ,T.OPP_PBC_NO                            AS OPP_PBC_NO       --19对方行号
         ,T.OPP_BANK_NM                           AS OPP_BANK_NM      --20对方行名
         /*---modify by tangan at 20230201 应业务卢萌要求修改 END----*/
         ,T.TRA_CHAN                              AS TRA_CHAN         --21交易渠道
         ,/*CASE WHEN T.POSTSCRIPT LIKE '%灵活盈转%' AND T.CASH_TRF_FLG = '1' THEN '2'
               WHEN T.ABSTR LIKE '%取现%' AND T.CASH_TRF_FLG = '2' THEN '1'
               WHEN T.ABSTR IN ('ATM存款','银联取现','存入','银联') AND T.CASH_TRF_FLG = '2' THEN '1'
               ELSE T.CASH_TRF_FLG
           END */
          T.CASH_TRF_FLG                         AS CASH_TRF_FLG     --22现转标志
         ,T.AGT_NM                               AS AGT_NM           --23代办人姓名
         ,T.AGT_CRDL_TYP                         AS AGT_CRDL_TYP     --24代办人证件类型
         ,T.AGT_CRDL_NO                          AS AGT_CRDL_NO      --25代办人证件号码
         ,T.TRA_TLR_NO                           AS TRA_TLR_NO       --26交易柜员号
         ,T.GRANT_TLR_NO                         AS GRANT_TLR_NO     --27授权柜员号
         ,T.ABSTR                                AS ABSTR            --28摘要
         ,T.FLUSH_PATCH_FLG                      AS FLUSH_PATCH_FLG  --29冲补抹标志
         ,T.TRA_DR_CR_FLG                        AS TRA_DR_CR_FLG    --30交易借贷标志
         ,T.ADV_DRAW_FLG                         AS ADV_DRAW_FLG     --31提前支取标志
         ,T.TRA_DT                               AS TRA_DT           --32交易日期
         ,T.TRA_TM                               AS TRA_TM           --33交易时间
         ,T.TRA_MED_TYP                          AS TRA_MED_TYP      --34交易介质类型
         ,T.TRA_TYP                              AS TRA_TYP          --35交易类型
         ,T.DEP_IN_OUT_FLG                       AS DEP_IN_OUT_FLG   --36存入存出类型
         ,T.IP                                   AS IP               --37IP地址
         ,T.MAC                                  AS MAC              --38MAC地址
         ,T.POSTSCRIPT                           AS POSTSCRIPT       --39附言
         ,T.CTY_RG_CD                            AS CTY_RG_CD        --国家和地区
         ,T.DEPT_LINE                            AS DEPT_LINE        --40部门条线
         ,UPPER(T.DATA_SRC)                      AS DATA_SRC         --41数据来源
         ,T.SUB_ACC_ID                           AS SUB_ACC_ID       --子账户编号
         ,T.ACC_ID_EAST                          AS ACC_ID_EAST      --账户编号_EAST
         ,T.US_AGE                               AS US_AGE           --资金用途20221020 XUXIAOBIN ADD
         ,T.REAL_CNTPTY_ACCT_ID                  AS REAL_CNTPTY_ACCT_ID
                                                                     --真实交易对手账户编号
         ,T.REAL_CNTPTY_ACCT_NAME                AS REAL_CNTPTY_ACCT_NAME
                                                                     --真实交易对手账户名称
         ,T.REAL_CNTPTY_FIN_INST_CD              AS REAL_CNTPTY_FIN_INST_CD
                                                                     --真实交易对手金融机构代码
         ,T.REAL_CNTPTY_FIN_INST_NAME            AS REAL_CNTPTY_FIN_INST_NAME
                                                                     --真实交易对手金融机构名称
         ,T.CORE_TRAN_FLOW_NUM                   AS CORE_TRAN_FLOW_NUM
                                                                     --核心交易流水号
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL_TEMP01 T
/*    LEFT JOIN RRP_MDL.ORG_CONFIG TC
      ON TC.ORG_ID = T.HDL_ORG_ID*/
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  -- ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否有重复';
  V_STARTTIME := SYSDATE;

    WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL T
   WHERE DATA_DT = I_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1 ;

  IF V_COUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END   ;
/

