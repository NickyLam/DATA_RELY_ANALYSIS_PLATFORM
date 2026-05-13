CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_TRF_REL_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_TRF_REL_INFO
  *  功能描述：信贷资产转让关系信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_TRF_REL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_TRF_REL_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

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
  V_STEP_DESC := '插入信贷资产转让关系信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO
  (
      DATA_DT              --数据日期
      ,LGL_REP_ID          --法人编号
      ,ORG_ID              --机构编号
      ,TRF_CONT_ID         --转让合同号
      ,RCPT_ID             --借据编号
      ,ASSET_POOL_ID       --资产池编号
      ,TRF_LOAN_PRIN       --转让贷款本金
      ,TRF_LOAN_INT        --转让贷款利息
      ,DEPT_LINE           --部门条线
      ,DATA_SRC            --数据来源
      ,LOAN_BIZ_TYP        --业务类别
      ,ASSET_TRAN_DT       --转让日期
      )
      SELECT
       V_P_DATE                 DATA_DT          --数据日期
      ,T1.LP_ID                  LGL_REP_ID       --法人编号
      ,T1.ACCT_INSTIT_ID         ORG_ID           --机构编号
      ,T1.CONT_ID                TRF_CONT_ID      --转让合同号
      ,T2.DUBIL_ID               RCPT_ID          --借据编号
      ,T1.ASSET_POOL_ID          ASSET_POOL_ID    --资产池编号
      ,T2.PKG_ASSET_BAL          TRF_LOAN_PRIN    --转让贷款本金
      ,T2.PKG_BELONG_HXB_INT     TRF_LOAN_INT     --转让贷款利息
      ,NULL                     DEPT_LINE        --部门条线
      ,'资产证券化'              DATA_SRC         --数据来源
      ,T1.ASSET_POOL_TYPE_CD     LOAN_BIZ_TYP     --业务类别
      ,NVL(TO_CHAR(T3.ASSET_TRAN_DT,'YYYYMMDD'),TO_CHAR(T4.ASSET_TRAN_DT,'YYYYMMDD'))
                                 ASSET_TRAN_DT    --资产转让日期
        FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T1   --资产证券化转让合同信息
       INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO  T2          --资产证券化基础资产信息
          ON T1.CONT_ID=T2.CONT_ID
         AND T2.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN O_ICL_CMM_CORP_LOAN_ACCT_INFO           T3  --对公贷款账户信息
            ON T3.DUBIL_NUM = T2.DUBIL_ID
            AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN O_ICL_CMM_RETL_LOAN_ACCT_INFO           T4  --零售贷款账户信息
            ON T4.DUBIL_NUM = T2.DUBIL_ID
            AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*  LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = NVL(A.ACCT_INSTIT_ID, A.RGST_ORG_ID)*/
     /*    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO D
      ON D.DUBIL_ID = B.DUBIL_ID
     AND D.ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')*/
        /*LEFT JOIN CODE_MAP TA
        ON TA.SRC_VALUE_CODE = A.ASSET_POOL_TYPE_CD
        AND TA.SRC_CLASS_CODE = 'CD2080'
        AND TA.TAR_CLASS_CODE = 'T0001'*/
       WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

      -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TRF_CONT_ID,RCPT_ID,ASSET_POOL_ID,COUNT(1)
      FROM M_LOAN_TRF_REL_INFO   T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, TRF_CONT_ID,RCPT_ID,ASSET_POOL_ID
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

  END ETL_INIT_M_LOAN_TRF_REL_INFO;
/

