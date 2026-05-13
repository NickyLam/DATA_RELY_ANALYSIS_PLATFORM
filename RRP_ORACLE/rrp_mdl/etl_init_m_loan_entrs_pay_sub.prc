CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_ENTRS_PAY_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_ENTRS_PAY_SUB
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
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_ENTRS_PAY_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_ENTRS_PAY_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
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
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入受托支付贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_ENTRS_PAY_SUB
  (
       DATA_DT                                                                          --数据日期
      ,LGL_REP_ID                                                                       --法人编号
      ,RCPT_ID                                                                          --借据编号
      ,ENTRS_PAY_AMT                                                                    --受托支付金额
      ,ENTRS_PAY_DT                                                                     --受托支付日期
      ,ENTRS_PAY_OBJ_ACC                                                                --受托支付对象账号
      ,ENTRS_PAY_OBJ_ACC_NM                                                             --受托支付对象户名
      ,ENTRS_PAY_OBJ_PBC_NO                                                             --受托支付对象行号
      ,ENTRS_PAY_OBJ_BANK_NM                                                            --受托支付对象行名
      ,DEPT_LINE                                                                        --部门条线
      ,DATA_SRC                                                                         --数据来源
      ,PAY_FLOW_NUM                                                                     --支付流水号
      ,PAY_STATUS_CD                                                                    --支付状态代码
      )
      SELECT
    V_P_DATE                                             DATA_DT                        --数据日期
   ,B.LP_ID                                              LGL_REP_ID                     --法人编号
   ,B.DUBIL_ID                                           RCPT_ID                        --借据编号
   ,A.PAY_AMT                                            ENTRS_PAY_AMT                  --受托支付金额
   ,TO_CHAR(A.PAY_DT,'YYYYMMDD')                         ENTRS_PAY_DT                   --受托支付日期
   ,A.RECVBL_ACCT_ID                                     ENTRS_PAY_OBJ_ACC              --受托支付对象账号
   ,A.RECVER_NAME                                        ENTRS_PAY_OBJ_ACC_NM           --受托支付对象户名
   ,TRIM(A.RECVER_OPEN_BANK_NAME)                        ENTRS_PAY_OBJ_PBC_NO           --受托支付对象行号
   ,/*TRIM(A.TRAN_IN_BK_BANK_NO)*/
    A.TRAN_IN_BANK_NAME                                  ENTRS_PAY_OBJ_BANK_NM          --受托支付对象行名
   ,'800919'   /*风险管理部*/                            DEPT_LINE                      --部门条线
   ,'对公贷款'                                           DATA_SRC                       --数据来源
   ,TRIM(A.PAY_FLOW_NUM)                                 PAY_FLOW_NUM                   --支付流水号
   ,TRIM(A.PAY_STATUS_CD)                                PAY_STATUS_CD                  --支付状态代码
   FROM RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H A --受托支付信息历史
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B--对公贷款借据信息
     ON A.OUT_ACCT_FLOW_NUM=B.OUT_ACCT_FLOW_NUM
    AND A.START_DT <= B.ETL_DT
    AND A.END_DT > B.ETL_DT
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE /*B.MONEY_USE_TYPE_CD ='2'   --款项使用类型为委托支付的
    AND */ A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    INSERT INTO RRP_MDL.M_LOAN_ENTRS_PAY_SUB
  (
      DATA_DT                                                                             --数据日期
      ,LGL_REP_ID                                                                         --法人编号
      ,RCPT_ID                                                                            --借据编号
      ,ENTRS_PAY_AMT                                                                      --受托支付金额
      ,ENTRS_PAY_DT                                                                       --受托支付日期
      ,ENTRS_PAY_OBJ_ACC                                                                  --受托支付对象账号
      ,ENTRS_PAY_OBJ_ACC_NM                                                               --受托支付对象户名
      ,ENTRS_PAY_OBJ_PBC_NO                                                               --受托支付对象行号
      ,ENTRS_PAY_OBJ_BANK_NM                                                              --受托支付对象行名
      ,DEPT_LINE                                                                          --部门条线
      ,DATA_SRC                                                                           --数据来源
      ,PAY_FLOW_NUM                                                                       --支付流水号
      ,PAY_STATUS_CD                                                                      --支付状态代码
      )
      SELECT
       V_P_DATE                                          DATA_DT                          --数据日期
      ,A.LP_ID                                           LGL_REP_ID                       --法人编号
      ,A.DUBIL_ID                                        RCPT_ID                          --借据编号
      ,B.PAY_AMT                                         ENTRS_PAY_AMT                    --受托支付金额
      ,TO_CHAR(B.RGST_DT,'YYYYMMDD')                     ENTRS_PAY_DT                     --受托支付日期
      ,B.RECVBL_ACCT_ID                                  ENTRS_PAY_OBJ_ACC                --受托支付对象账号
      ,B.RECVER_NAME                                     ENTRS_PAY_OBJ_ACC_NM             --受托支付对象户名
      ,TRIM(B.RECVER_OPEN_BANK_NAME)                     ENTRS_PAY_OBJ_PBC_NO             --受托支付对象行号
      ,B.TRAN_IN_BANK_NAME                               ENTRS_PAY_OBJ_BANK_NM            --受托支付对象行名
      ,'800924'   /*零售信贷部(普惠金融部)*/             DEPT_LINE                        --部门条线
      ,'零售贷款'                                         DATA_SRC                         --数据来源
      ,TRIM(B.PAY_FLOW_NUM)                              PAY_FLOW_NUM                     --支付流水号
      ,TRIM(B.PAY_STATUS_CD)                             PAY_STATUS_CD                    --支付状态代码
  FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A--零售贷款借据信息
  INNER JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H C --贷款出账申请历史 --modify by tangan at 20221219 用于关联
     ON A.DUBIL_ID = C.DUBIL_ID
    AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H B --受托支付信息历史
   -- ON B.OUT_ACCT_FLOW_NUM = A.DUBIL_ID
     ON B.OUT_ACCT_FLOW_NUM = C.OUT_ACCT_FLOW_NUM
    AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     /* A.MODE_PAY_CD IN ('2','3') */
     /*AND A.ETL_DT = TO_DATE(V_DATEID,'YYYYMMDD')
     AND REPLACE(SUBSTR(B.rgst_dt,0,10),'-','')=V_P_DATE */
     ;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,ENTRS_PAY_OBJ_ACC,PAY_FLOW_NUM,PAY_STATUS_CD ,ENTRS_PAY_DT, COUNT(1)
      FROM M_LOAN_ENTRS_PAY_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID,ENTRS_PAY_OBJ_ACC,PAY_FLOW_NUM,PAY_STATUS_CD ,ENTRS_PAY_DT
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

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
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_ENTRS_PAY_SUB;
/

