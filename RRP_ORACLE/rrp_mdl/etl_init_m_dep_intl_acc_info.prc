CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_DEP_INTL_ACC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_DEP_INTL_ACC_INFO
  *  功能描述：监管集市银行业银行机构开设的所有内部账户的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ACCT       --内部账户
  *            ICL.CMM_INTNAL_ORG_INFO   --内部机构信息表
  *            ICL.CMM_SUBJ_INFO         --科目信息
  *            ICL.CMM_GL_BAL            --总账余额
  *  目标表：  M_DEP_INTL_ACC_INFO  --内部分户账信息
  *
  *  配置表：  IML.REF_PUB_CD       --公共代码表
  *
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220921  mw       修改east是否报送字段口径
  *             2    20221108  hulj     增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_DEP_INTL_ACC_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_DEP_INTL_ACC_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  /*判断传入日期参数是否正确*/
  IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(I_P_DATE, 'yyyymmdd');
  END IF;

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
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账信息-核心数据信息';
  V_STARTTIME := SYSDATE;
  /*****************核心系统-内部户******************/
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_INTL_ACC_INFO NOLOGGING
  (
     DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ACC_ID           --账户编号
    ,ORG_ID           --机构编号
    ,SUBJ_ID          --科目编号
    ,ACC_NM           --账户名称
    ,DR_CR_FLG        --借贷标志
    ,CUR              --币种
    ,STATS_SUBJ_ID    --统计科目编号
    ,DR_BAL           --借方余额
    ,CR_BAL           --贷方余额
    ,INT_CALC_FLG     --计息标志
    ,INT_CALC_MODE    --计息方式
    ,RATE             --利率
    ,OPEN_ACC_DT      --开户日期
    ,CNL_ACC_DT       --销户日期
    ,ACC_STAT         --账户状态
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    ,SUB_ACC_ID       --子账户编号
    ,SEPARATE_ACCT_FLG--是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD   --存款账户状态原码值
    ,ACC_BAL          --账户余额
    ,MAIN_ACCT_ID     --主账户编号
  )
  /* WITH CMM_INTNAL_ACCT_EAST_NOT_REP AS (
    SELECT C.MAIN_ACCT_ID
      FROM RRP_MDL.O_IML_REF_LOAN_ACCT_ACCTI_PARA_H T
     INNER JOIN RRP_MDL.O_IML_REF_INTNAL_ACCT_BUS_COMP_H B
        ON B.BUS_ID = T.BUS_ID_CD
       AND B.START_DT <= V_DATE
       AND B.END_DT > V_DATE
     INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT C
        ON C.BUS_CODE_SER_NUM = B.INTNAL_ACCT_SEQ_NUM
       AND C.ETL_DT = V_DATE
     WHERE T.ACCTI_TYPE_CD IN ('02', '03', '04', '29', '01', '13') -- U对公贷款损失准备
       AND T.ACCTI_CD NOT IN ('1303019902', '1303019901')
       AND T.START_DT <= V_DATE
       AND T.END_DT > V_DATE
     GROUP BY C.MAIN_ACCT_ID)*/  --因源表未接入暂时注释
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                 AS DATA_DT             --数据日期
   ,A.LP_ID                                                       AS LGL_REP_ID          --法人编号
   /*,A.MAIN_ACCT_ID  --账户编号*/
	 ,A.ACCT_ID                                                     AS ACC_ID              --账户编号  modify by xieyugeng 20221020 因核心内部账户进行拆分，继续取MAIN_ACCT_ID会导致账户号重复，经科技区志豪确认区ACCT_ID
   ,A.BELONG_ORG_ID                                               AS ORG_ID              --机构编号
   ,A.SUBJ_ID                                                     AS SUBJ_ID             --科目编号
   ,A.ACCT_NAME                                                   AS ACC_NM              --账户名称
   ,A.BAL_DIR_CD                                                  AS DR_CR_FLG           --借贷标志
   ,A.CURR_CD                                                     AS CUR                 --币种
   ,NULL                                                          AS STATS_SUBJ_ID       --统计科目编号
   ,CASE WHEN A.BAL_DIR_CD='D'
         THEN ABS(NVL(ACCT_BAL, 0.00))
         ELSE 0.00
         END                                                      AS DR_BAL              --借方余额
   ,CASE WHEN A.BAL_DIR_CD='C'
         THEN ABS(NVL(ACCT_BAL, 0.00))
         ELSE 0.00
         END                                                      AS CR_BAL              --贷方余额
   ,'N'                                                           AS INT_CALC_FLG        --计息标志
   ,'05'                                                          AS INT_CALC_MODE       --计息方式 ----不计计息
   ,0.0000                                                        AS RATE                --利率
   ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                           AS OPEN_ACC_DT         --开户日期
   ,CASE WHEN A.CLOS_ACCT_DT = TO_DATE('29991231','YYYYMMDD')
         THEN '99991231'
         ELSE TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD')
         END                                                      AS CNL_ACC_DT          --销户日期
   ,TTA.TAR_VALUE_CODE                                            AS ACC_STAT            --账户状态
   ,'800918'   /*计划财务部*/                                                          AS DEPT_LINE           --部门条线
   ,'核心数据信息'                                                AS DATA_SRC            --数据来源
   ,A.SUB_ACCT_NUM                                                AS SUB_ACC_ID          --子账户编号
   ,'1'/*CASE WHEN F.MAIN_ACCT_ID IS NOT NULL THEN '0'
               ELSE '1'
           END   */                                                AS SEPARATE_ACCT_FLG   --是否单列账标志1报送0不报送
   ,A.ACCT_STATUS_CD                                               AS ACCT_STATUS_CD      --存款账户状态原码值
   ,A.ACCT_BAL                                                     AS ACC_BAL             --账户余额
   ,A.MAIN_ACCT_ID                                                 AS MAIN_ACCT_ID        --主账户编号
  FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A            --内部账户
  INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.BELONG_ORG_ID = B.ORG_ID
    AND B.ETL_DT = V_DATE
  LEFT JOIN RRP_MDL.ORG_CONFIG D
    ON A.BELONG_ORG_ID = D.ORG_ID
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
    ON E.CD_ID = 'CD1817'
    AND A.ACCT_STATUS_CD = E.CD_VAL
 /* LEFT JOIN CMM_INTNAL_ACCT_EAST_NOT_REP F
      ON F.MAIN_ACCT_ID = A.MAIN_ACCT_ID  */   --因源表未接入暂时注释
  LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
    ON TTA.SRC_VALUE_CODE = A.ACCT_STATUS_CD
    AND TTA.SRC_CLASS_CODE = 'CD2554'
    AND TTA.TAR_CLASS_CODE = 'Z0018'
    AND TTA.MOD_FLG = 'MDM'
  WHERE A.ETL_DT = V_DATE
  AND SUBSTR(A.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
  AND A.OPEN_ACCT_DT <= V_DATE  --modify by tangan at 20221105 剔除开户日期大于跑批日期的数据
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入内部分户账信息-总账数据信息';
    V_STARTTIME := SYSDATE;
    /*************************总账*************************/
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_INTL_ACC_INFO NOLOGGING
  (
    DATA_DT                 --数据日期
    ,LGL_REP_ID             --法人编号
    ,ACC_ID                 --账户编号
    ,ORG_ID                 --机构编号
    ,SUBJ_ID                --科目编号
    ,ACC_NM                 --账户名称
    ,DR_CR_FLG              --借贷标志
    ,CUR                    --币种
    ,STATS_SUBJ_ID          --统计科目编号
    ,DR_BAL                 --借方余额
    ,CR_BAL                 --贷方余额
    ,INT_CALC_FLG           --计息标志
    ,INT_CALC_MODE          --计息方式
    ,RATE                   --利率
    ,OPEN_ACC_DT            --开户日期
    ,CNL_ACC_DT             --销户日期
    ,ACC_STAT               --账户状态
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,SUB_ACC_ID             --子账户编号
    ,SEPARATE_ACCT_FLG      --是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD         --存款账户状态原码值
    ,MAIN_ACCT_ID           --主账户编号
  )
  WITH TMP_SUBJ AS (
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_DEP_ACC_INFO WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_DEP_INTL_ACC_INFO WHERE DATA_DT = V_P_DATE

  )

  SELECT
      TO_CHAR(T1.ETL_DT, 'YYYYMMDD')                    AS DATA_DT --数据日期
     ,'9999'                                            AS LGL_REP_ID--法人编号
     ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS ACC_ID--账户编号
     ,KK.ORG_ID1                                        AS ORG_ID--机构编号
     ,T1.SUBJ_ID                                        AS SUBJ_ID--科目编号
     ,C.SUBJ_NAME                                       AS ACC_NM--账户名称
     ,CASE WHEN T1.SUBJ_DIR_CD = 'R' THEN 'C'
         WHEN T1.SUBJ_DIR_CD = 'P' THEN 'D' --表外业务 收方对应贷方，付方对应借方
         ELSE T1.SUBJ_DIR_CD
     END                                                AS DR_CR_FLG --借贷标志
     ,T1.CURR_CD                                        AS CUR --币种
     ,NULL                                              AS STATS_SUBJ_ID--统计科目编号
     ,NVL(ABS(T1.QMJFYE), 0.00)                         AS DR_BAL--借方余额
     ,NVL(ABS(T1.QMDFYE), 0.00)                         AS CR_BAL --贷方余额
     ,'N'                                               AS INT_CALC_FLG --计息标志
     ,'05'                                              AS INT_CALC_MODE --计息方式 --不计计息
     ,0.0000                                            AS RATE --利率
    -- ,'99991231'                                       --开户日期
     ,CASE WHEN TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD') = '00010101' THEN TO_CHAR(B1.ORG_FOUND_DT, 'YYYYMMDD')
           ELSE TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD')  END  AS  OPEN_ACC_DT          --开户日期
       -- modify by 20220714 LHQ 根据业务口径:机构+科目+币种拼接的账号，没有开户日期取对应机构成立日期
       --modify by tangan at 20221105 如果机构成立日期为00010101，则取映射后的
     ,'99991231'                                        AS CNL_ACC_DT--销户日期
     ,'01'                                              AS ACC_STAT --账户状态 --正常
     ,'800918'                                          AS DEPT_LINE --部门条线/*计划财务部*/
     ,'总账数据信息'                                    AS DATA_SRC      --数据来源
     ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS SUB_ACC_ID --子账户编号
     ,'1'                                               AS SEPARATE_ACCT_FLG  --是否单列账标志1报送0不报送
     ,'A'                                               AS ACCT_STATUS_CD   --存款账户状态原码值
     ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS MAIN_ACCT_ID           --主账户编号
  FROM
      (
        /**本币**/
        SELECT A.ETL_DT       ETL_DT                --数据日期
          ,A.ACCT_DURAN  ACCT_DURAN--数据区间
          ,A.ORG_ID           ORG_ID               --机构编号
          ,A.SUBJ_ID      SUBJ_ID                    --会计科目编号
          ,A.CURR_CD     CURR_CD                     --币种代码
          ,A.SUBJ_DIR_CD
          ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_OC_DR_BAL -A.TD_OC_CR_BAL  --轧差
               WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL> 0 THEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL ELSE 0 END)
               WHEN A.SUBJ_DIR_CD = 'C' THEN 0
           ELSE A.TD_OC_DR_BAL END) QMJFYE
          ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL   --轧差
               WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL> 0 THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL ELSE 0 END)
               WHEN A.SUBJ_DIR_CD = 'D' THEN 0
           ELSE A.TD_OC_CR_BAL END)    QMDFYE
          ,SUBSTR(A.JOB_CD, 0, 4) AS JOB_CD
         FROM RRP_MDL.O_ICL_CMM_GL_BAL A  --总账余额
       WHERE A.CURR_CD = 'CNY'
         /*AND A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_DATEID,1,4) || '-14' ELSE SUBSTR(V_DATA_DT, 0, 7)
         END --年末取结转后的数据，监管报送也是取的调账后的*/
         AND A.ETL_DT = V_DATE
         AND A.DATA_SRC_CD <> '99'  --modify by tangan at 20230104
         AND A.STD_PROD_ID <> '999999999999'  --modify by tangan at 20230104
       GROUP BY
         A.ETL_DT
         ,A.ACCT_DURAN
         ,A.ORG_ID
         ,A.SUBJ_ID
         ,A.CURR_CD
         ,A.SUBJ_DIR_CD
         ,SUBSTR(A.JOB_CD, 0, 4)
       UNION

       /**本外币**/
       SELECT A.ETL_DT       ETL_DT                --数据日期
          ,A.ACCT_DURAN  ACCT_DURAN--数据区间
          ,A.ORG_ID           ORG_ID               --机构编号
          ,A.SUBJ_ID      SUBJ_ID                    --会计科目编号
          ,'BWB'     CURR_CD                     --币种代码
          ,A.SUBJ_DIR_CD
          ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_DC_DR_BAL -A.TD_DC_CR_BAL  --轧差
               WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_DC_DR_BAL-A.TD_DC_CR_BAL> 0 THEN A.TD_DC_DR_BAL-A.TD_DC_CR_BAL ELSE 0 END)
               WHEN A.SUBJ_DIR_CD = 'C' THEN 0
           ELSE A.TD_DC_DR_BAL END) AS QMJFYE
          ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL   --轧差
               WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL> 0 THEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL ELSE 0 END)
               WHEN A.SUBJ_DIR_CD = 'D' THEN 0
           ELSE A.TD_DC_CR_BAL END) AS QMDFYE
          ,SUBSTR(A.JOB_CD, 0, 4) AS JOB_CD
       FROM RRP_MDL.O_ICL_CMM_GL_BAL A  --总账余额
       WHERE /*A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_DATEID,1,4) || '-14' ELSE SUBSTR(V_DATA_DT, 0, 7)
        END --年末取结转后的数据，监管报送也是取的调账后的*/
       A.ETL_DT = V_DATE
       AND A.CURR_CD NOT IN ('CCC','USC','CFC','CUC')  --modify by tangan at 20230104 剔除上游汇总币种数据
       AND A.DATA_SRC_CD <> '99' --modify by tangan at 20230104
       AND A.STD_PROD_ID <> '999999999999'  --modify by tangan at 20230104
       GROUP BY A.ETL_DT --1.数据日期
        ,A.ACCT_DURAN--数据区间
        ,A.ORG_ID --3.机构编号
        ,A.SUBJ_ID --4.会计科目编号
        ,A.SUBJ_DIR_CD
        ,SUBSTR(A.JOB_CD, 0, 4)
      ) T1
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON T1.ORG_ID = B.ORG_ID
    AND B.ETL_DT = V_DATE
  LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C  --科目信息
    ON T1.SUBJ_ID = C.SUBJ_ID
    AND C.ETL_DT = V_DATE
  INNER JOIN RRP_MDL.O_IML_REF_PUB_CD D
    ON C.SUBJ_CHAR_CD=D.CD_VAL
    AND D.CD_ID = 'CD1390'
  LEFT JOIN RRP_MDL.ORG_CONFIG KK
    ON T1.ORG_ID = KK.ORG_ID --update by cxl 20220511
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B1  --内部机构信息表  --modify by tangan at 20221105 如果机构成立日期为00010101，则取映射后的
    ON KK.ORG_ID1 = B1.ORG_ID
    AND B1.ETL_DT = V_DATE
  WHERE /*C.SUBJ_LEV_CD <= '3'    --要求只报三级科目
      AND*/ NOT EXISTS (SELECT 1 FROM TMP_SUBJ E WHERE T1.SUBJ_ID = E.SUBJ_ID)  --update by chenxl 20220401 剔除存贷款科目
      AND SUBSTR(T1.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
      AND T1.ORG_ID <> '999999'  --modify by tangan at 20221105 剔除999999机构的数据
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
    SELECT DATA_DT,ACC_ID,COUNT(1)
      FROM M_DEP_INTL_ACC_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT,ACC_ID
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

  END ETL_INIT_M_DEP_INTL_ACC_INFO;
/

