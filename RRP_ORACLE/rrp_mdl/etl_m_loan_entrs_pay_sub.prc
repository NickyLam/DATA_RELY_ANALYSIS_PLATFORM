CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_ENTRS_PAY_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_ENTRS_PAY_SUB
  *  功能描述：受托支付子表
              以借据为粒度，接入借据表中放款方式为“受托支付”或“混合支付”的数据
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：O_IML_AGT_ENTR_PAY_INFO_H
            O_ICL_CMM_CORP_LOAN_DUBIL_INFO
            O_ICL_CMM_RETL_LOAN_DUBIL_INFO
            O_IML_AGT_LOAN_OUT_ACCT_APPL_H
  *  目标表：  M_LOAN_ENTRS_PAY_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20220524  梅炜       首次创建
  *             2    20221114  hulj       增加数据重复校验
  *             3    20230424  XUXIAOBIN  新增零售执行计划
  *             4    20230526  LIP        修改受托支付对象行名的口径
  *             5    20230829  LIP        增加受托支付总金额字段以便业务核数，增加REPORT_FLAG字段，以便east取数
  *             6    20231009  LIP        张家伟：零售受托支付表的日期筛选要改为按照放款时间来取
  *             7    20260417  LIP        与严希婧确认：1、如果受托支付日期和借据放款日期不在同一个月，将受托支付日期调整成放款日期报送；
  *                                       2、受托支付状态是：空、支付中、已止付的也判断为当月报送的情况，失败的情况再具体分析
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;           --处理步骤
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);          --任务名称
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_ENTRS_PAY_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_ENTRS_PAY_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入受托支付贷款子表--对公部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_ENTRS_PAY_SUB
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,RCPT_ID                   --借据编号
    ,ENTRS_PAY_AMT             --受托支付金额
    ,ENTRS_PAY_DT              --受托支付日期
    ,ENTRS_PAY_OBJ_ACC         --受托支付对象账号
    ,ENTRS_PAY_OBJ_ACC_NM      --受托支付对象户名
    ,ENTRS_PAY_OBJ_PBC_NO      --受托支付对象行号
    ,ENTRS_PAY_OBJ_BANK_NM     --受托支付对象行名
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,PAY_FLOW_NUM              --支付流水号
    ,PAY_STATUS_CD             --支付状态代码
    ,TOT_ENTRS_PAY_AMT         --受托支付总金额 --ADD BY LIP 20230829
    ,REPORT_FLAG               --是否报送标志--ADD BY LIP 20230829
    )
  SELECT  V_P_DATE                          AS DATA_DT                        --数据日期
         ,B.LP_ID                           AS LGL_REP_ID                     --法人编号
         ,B.DUBIL_ID                        AS RCPT_ID                        --借据编号
         ,A.PAY_AMT                         AS ENTRS_PAY_AMT                  --受托支付金额
         --,TO_CHAR(A.PAY_DT,'YYYYMMDD')      AS ENTRS_PAY_DT                   --受托支付日期
         --MOD BY LIP 20260417 与严希婧确认，如果录入的受托支付日期与借据放款日期不在同一个月，将受托支付日期调整成放款日期
         ,CASE WHEN TRUNC(A.PAY_DT,'MM') <> TRUNC(B.DISTR_DT,'MM')
               THEN TO_CHAR(B.DISTR_DT,'YYYYMMDD')
               ELSE TO_CHAR(A.PAY_DT,'YYYYMMDD')
           END                              AS ENTRS_PAY_DT                   --受托支付日期
         ,A.RECVBL_ACCT_ID                  AS ENTRS_PAY_OBJ_ACC              --受托支付对象账号
         ,A.RECVER_NAME                     AS ENTRS_PAY_OBJ_ACC_NM           --受托支付对象户名
         --MOD BY 20240204 二级福费廷业务的对方行号为空时，取出账表的 OTHERRECEIVEDBANKNO 对方收款行号
         ,CASE WHEN TRIM(A.RECVER_OPEN_BANK_NAME) IS NOT NULL 
               THEN TRIM(A.RECVER_OPEN_BANK_NAME)
               WHEN E.OUT_ACCT_FLOW_NUM IS NOT NULL 
               THEN TRIM(E.CNTPTY_RECVBL_BANK_NO)
           END                              AS ENTRS_PAY_OBJ_PBC_NO           --受托支付对象行号
         --MOD BY LIP 20230526 因源系统行名为空，需通过行号转成行名
         ,CASE WHEN TRIM(A.TRAN_IN_BANK_NAME) IS NOT NULL
               THEN TRIM(A.TRAN_IN_BANK_NAME)
               ELSE C.SYS_PRTCPTR_BIGAMT_BANK_NAME_A
           END                              AS ENTRS_PAY_OBJ_BANK_NM          --受托支付对象行名
         ,'800919'                          AS DEPT_LINE                      --部门条线 /*风险管理部*/ 
         ,'对公贷款'                        AS DATA_SRC                       --数据来源
         ,TRIM(A.PAY_FLOW_NUM)              AS PAY_FLOW_NUM                   --支付流水号
         ,TRIM(A.PAY_STATUS_CD)             AS PAY_STATUS_CD                  --支付状态代码
         ,D.ENTR_PAY_AMT                    AS TOT_ENTRS_PAY_AMT              --受托支付总金额 --ADD BY LIP 20230829
         ,CASE WHEN A.PAY_DT <= TO_DATE('20230501','YYYYMMDD') THEN 'Y'
               WHEN TRIM(A.PAY_STATUS_CD) = 'SUCCESS' THEN 'Y'
               --MOD BY LIP 20260416 受托支付状态是：空、支付中、已止付的也判断为当月报送的情况，失败的情况再具体分析
               WHEN NVL(TRIM(A.PAY_STATUS_CD),'-') IN ('-','FREEZEED','PROCESSING') THEN 'Y'
               ELSE 'N'
           END                              AS REPORT_FLAG                    --是否报送标志--ADD BY LIP 20230829
    FROM RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H A --受托支付信息历史 --ICMS_PAYMENT_INFO
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM C --票交所会员
      ON C.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.RECVER_OPEN_BANK_NAME)
     AND C.RANK = 1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H D --贷款出账申请历史 --ADD BY LIP 20230829
      ON D.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND D.ID_MARK <> 'D'
     AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H E --贷款出账对公贷款附属信息历史
      ON E.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND TRIM(E.CNTPTY_RECVBL_ACCT_ID) = A.RECVBL_ACCT_ID
     AND E.ID_MARK <> 'D'
     AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入受托支付贷款子表--零售部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_ENTRS_PAY_SUB
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,RCPT_ID                   --借据编号
    ,ENTRS_PAY_AMT             --受托支付金额
    ,ENTRS_PAY_DT              --受托支付日期
    ,ENTRS_PAY_OBJ_ACC         --受托支付对象账号
    ,ENTRS_PAY_OBJ_ACC_NM      --受托支付对象户名
    ,ENTRS_PAY_OBJ_PBC_NO      --受托支付对象行号
    ,ENTRS_PAY_OBJ_BANK_NM     --受托支付对象行名
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,PAY_FLOW_NUM              --支付流水号
    ,PAY_STATUS_CD             --支付状态代码
    ,TOT_ENTRS_PAY_AMT         --受托支付总金额 --ADD BY LIP 20230829
    ,REPORT_FLAG               --是否报送标志--ADD BY LIP 20230829
    )
  SELECT /*+ORDER USE_HASH(A,C,B)*/
          V_P_DATE                            AS DATA_DT                  --数据日期
         ,A.LP_ID                             AS LGL_REP_ID               --法人编号
         ,A.DUBIL_ID                          AS RCPT_ID                  --借据编号
         ,B.PAY_AMT                           AS ENTRS_PAY_AMT            --受托支付金额
         --MOD BY LIP 20231009 张家伟：零售受托支付表的日期筛选要改为按照放款时间来取
         ,TO_CHAR(A.FIR_DISTR_DT,'YYYYMMDD')  AS ENTRS_PAY_DT             --受托支付日期
         ,B.RECVBL_ACCT_ID                    AS ENTRS_PAY_OBJ_ACC        --受托支付对象账号
         ,B.RECVER_NAME                       AS ENTRS_PAY_OBJ_ACC_NM     --受托支付对象户名
         ,TRIM(B.RECVER_OPEN_BANK_NAME)       AS ENTRS_PAY_OBJ_PBC_NO     --受托支付对象行号
         --MOD BY LIP 20230526 因源系统行名为空，需通过行号转成行名
         ,CASE WHEN TRIM(B.TRAN_IN_BANK_NAME) IS NOT NULL
               THEN TRIM(B.TRAN_IN_BANK_NAME)
               ELSE D.SYS_PRTCPTR_BIGAMT_BANK_NAME_A
           END                                AS ENTRS_PAY_OBJ_BANK_NM    --受托支付对象行名
         ,'800924'                            AS DEPT_LINE                --部门条线/*零售信贷部(普惠金融部)*/
         ,'零售贷款'                          AS DATA_SRC                 --数据来源
         ,TRIM(B.PAY_FLOW_NUM)                AS PAY_FLOW_NUM             --支付流水号
         ,TRIM(B.PAY_STATUS_CD)               AS PAY_STATUS_CD            --支付状态代码
         ,C.ENTR_PAY_AMT                      AS TOT_ENTRS_PAY_AMT        --受托支付总金额 --ADD BY LIP 20230829
         ,CASE WHEN NVL(TRIM(A.MODE_PAY_CD),'2') IN ('1') THEN 'Y' --CD1372零售部分自主支付的也在受托支付表，EAST只报送受托支付的
               ELSE 'N'
           END                                AS REPORT_FLAG              --是否报送标志--ADD BY LIP 20230829
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A--零售贷款借据信息
   INNER JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H C --贷款出账申请历史 --MODIFY BY TANGAN AT 20221219 用于关联
      ON C.DUBIL_ID = A.DUBIL_ID
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H B --受托支付信息历史 --ICMS_PAYMENT_INFO
      ON B.OUT_ACCT_FLOW_NUM = C.OUT_ACCT_FLOW_NUM
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM D --票交所会员
      ON D.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(B.RECVER_OPEN_BANK_NAME)
     AND D.RANK = 1
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,ENTRS_PAY_OBJ_ACC,PAY_FLOW_NUM,PAY_STATUS_CD,ENTRS_PAY_DT,COUNT(1)
    FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID,ENTRS_PAY_OBJ_ACC,PAY_FLOW_NUM,PAY_STATUS_CD,ENTRS_PAY_DT
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
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

END ETL_M_LOAN_ENTRS_PAY_SUB;
/

