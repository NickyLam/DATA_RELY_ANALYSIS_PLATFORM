CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_IND_REL_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_IND_REL_SUB
  *  功能描述：监管集市自然人客户的关系人信息
  *  创建日期：20220608
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_GUAR_CONT   --担保合同
  *            ICL.CMM_INDV_CUST_BASIC_INFO    --个人客户基本信息
  *            ICL.CMM_INDV_CUST_RELA_PS_INFO  --个人客户关联人信息
  *            ICL.CMM_RETL_LOAN_CONT_INFO     --零售贷款合同信息
  *  目标表：  M_CUST_IND_REL_SUB --个人客户关系人子表
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_IND_REL_SUB'; -- 程序名称
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_PART_NAME  VARCHAR2(50);  --表分区名字
  V_TAB_NAME   VARCHAR2(50); -- 表名
 V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_IND_REL_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  ----将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                       SUBSTR(I_P_DATE, 5, 2) || '-' ||
                       SUBSTR(I_P_DATE, 7, 2),
                       'YYYY-MM-DD');

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
  V_STEP_DESC := '-- 插入个人客户关系人子表-ECIF客户信息 --';

  INSERT  INTO M_CUST_IND_REL_SUB
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,CUST_ID                    --客户编号
    ,REL_TYP                    --关系类型
    ,REL_PSN_NM                 --关系人姓名
    ,REL_PSN_CRDL_TYP           --关系人证件类型
    ,REL_PSN_CRDL_NO            --关系人证件号码
    ,REL_PSN_CUST_ID            --关系人客户编号
    ,REL_STAT                   --关系状态
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
    ,RELA_PS_ID                 --关联人编号
  )
  SELECT
     T.DATA_DT                    --数据日期
    ,T.LGL_REP_ID                 --法人编号
    ,T.CUST_ID                    --客户编号
    ,T.REL_TYP                    --关系类型
    ,T.REL_PSN_NM                 --关系人姓名
    ,T.REL_PSN_CRDL_TYP           --关系人证件类型
    ,T.REL_PSN_CRDL_NO            --关系人证件号码
    ,T.REL_PSN_CUST_ID            --关系人客户编号
    ,T.REL_STAT                   --关系状态
    ,T.DEPT_LINE                  --部门条线
    ,T.DATA_SRC                   --数据来源
    ,T.RELA_PS_ID                 --关联人编号
  FROM
  (
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')      AS DATA_DT                    --数据日期
    ,A.LP_ID                            AS LGL_REP_ID                 --法人编号
    ,A.CUST_ID                          AS CUST_ID                    --客户编号
    ,B.TAR_VALUE_CODE                   AS REL_TYP                    --关系类型
   -- ,replace(A.RELA_PS_NAME,'.','')   AS REL_PSN_NM                 --关系人姓名
     ,A.RELA_PS_NAME                    AS REL_PSN_NM                 --关系人姓名
    ,A.RELA_PS_CERT_TYPE_CD             AS REL_PSN_CRDL_TYP           --关系人证件类型
    ,A.RELA_PS_CERT_NO                  AS REL_PSN_CRDL_NO            --关系人证件号码
    ,A.RELA_PS_CUST_ID/*RELA_PS_ID*/    AS REL_PSN_CUST_ID            --关系人客户编号 -- 20221104 MW 修改为关联人客户编号
    ,'Y'                                AS REL_STAT                   --关系状态
    ,'800924'  /*零售信贷部(普惠金融部)*/AS DEPT_LINE                  --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)             AS DATA_SRC                   --数据来源
    ,A.RELA_PS_ID                       AS RELA_PS_ID                 --关联人编号
    ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,B.TAR_VALUE_CODE,A.RELA_PS_CERT_NO ORDER BY A.JOB_CD DESC,A.RELA_PS_ID DESC) AS NUM
  FROM RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO A --个人客户关联人信息
  LEFT JOIN RRP_MDL.CODE_MAP B
         ON A.RELA_TYPE_CD = B.SRC_VALUE_CODE
        AND B.SRC_CLASS_CODE = 'CD1280'  --当事人关系类型代码
        AND B.TAR_CLASS_CODE = 'C0017'   --对私关系类型
        AND B.MOD_FLG = 'MDM'            --监管集市明细层
  WHERE A.ETL_DT = TO_DATE(I_P_DATE, 'yyyymmdd')
    AND TRIM(A.CUST_ID) IS NOT NULL
    AND TRIM(A.RELA_PS_CERT_NO) IS NOT NULL
    AND TRIM(A.RELA_PS_NAME) IS NOT NULL
  ) T
  WHERE T.NUM = 1
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入个人客户关系人子表-信贷系统-担保关系';
  V_STARTTIME := SYSDATE;
   /*信贷系统-担保关系*/
  INSERT INTO M_CUST_IND_REL_SUB
  (
     DATA_DT              --数据日期
    ,LGL_REP_ID           --法人编号
    ,CUST_ID              --客户编号
    ,REL_TYP              --关系类型
    ,REL_PSN_NM           --关系人姓名
    ,REL_PSN_CRDL_TYP     --关系人证件类型
    ,REL_PSN_CRDL_NO      --关系人证件号码
    ,REL_PSN_CUST_ID      --关系人客户编号
    ,REL_STAT             --关系状态
    ,DEPT_LINE            --部门条线
    ,DATA_SRC             --数据来源
     )
    WITH TMP1 AS (
      SELECT A.ETL_DT,
             A.LP_ID,
             C.CUST_ID,
             A.GUARTOR_NAME,
             A.GUARTOR_CERT_NO,
             A.GUARTOR_ID,
             A.GUARTOR_CERT_TYPE_CD,
             UPPER(A.JOB_CD) JOB_CD,
             ROW_NUMBER() OVER(PARTITION BY C.CUST_ID,A.GUARTOR_CERT_NO ORDER BY A.GUARTOR_ID ) RN
        FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A  --担保合同
       INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售贷款合同信息
          ON A.PRI_CONTR_ID = C.CONT_ID
         AND C.ETL_DT = V_DATE
       WHERE A.ETL_DT = V_DATE
         AND A.EFFECT_DT = V_DATE
         AND A.STATUS_CD = '101')--'101'有效，‘111’已失效
  SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')         AS DATA_DT,      --数据日期
       A.LP_ID                               AS LGL_REP_ID,   --法人编号
       A.CUST_ID                             AS CUST_ID ,     --客户编号
       '9901'                                AS REL_TYP,/*其他-担保*/   --关联类型代码
       A.GUARTOR_NAME                        AS REL_PSN_NM,             --担保人名称
       A.GUARTOR_CERT_TYPE_CD                AS REL_PSN_CRDL_TYP,       --担保人证件类型代码
       A.GUARTOR_CERT_NO                     AS REL_PSN_CRDL_NO,        --担保人证件号码
       A.GUARTOR_ID                          AS REL_PSN_CUST_ID,        --担保人编号
       'Y'                                   AS REL_STAT,               --关系状态
       '05'                                  AS DEPT_LINE,              --部门条线
       SUBSTR(A.JOB_CD, 0, 4)                AS DATA_SRC                --数据来源
  /*FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A  --担保合同
  INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售贷款合同信息
    ON A.PRI_CONTR_ID = C.CONT_ID
    AND C.ETL_DT = V_DATE*/
  FROM TMP1 A
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
    ON A.CUST_ID = D.CUST_ID
   AND D.ETL_DT = V_DATE
 WHERE A.RN = 1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,REL_TYP,REL_PSN_CRDL_NO,COUNT(1)
      FROM M_CUST_IND_REL_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID,REL_TYP,REL_PSN_CRDL_NO
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

  END ETL_INIT_M_CUST_IND_REL_SUB;
/

