CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_IND_REL_SUB(I_P_DATE IN INTEGER,
                                                   O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_IND_REL_SUB
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
  *             2    20250430   LTJ     新增建立关系日期、解除关系日期
  *             3    20260116   YJY     一表通反馈需剔除203050100002-微众对公联合贷、203050100001-微业贷产品的数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;             --处理步骤
  V_STEP_DESC  VARCHAR2(100);            --处理步骤描述
  V_P_DATE     VARCHAR2(8);              --跑批数据日期
  V_STARTTIME  DATE;                     --处理开始时间
  V_ENDTIME    DATE;                     --处理结束时间
  V_SQLCOUNT   INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);            --SQL执行描述信息
  V_DATE       DATE;                     --数据日期(判断输入参数日期格式是否准确)
  V_PART_NAME  VARCHAR2(50);             --表分区名字
  V_TAB_NAME   VARCHAR2(50) := 'M_CUST_IND_REL_SUB'; --表名
  V_PROC_NAME  VARCHAR2(100) := 'ETL_M_CUST_IND_REL_SUB'; --程序名称
  V_SYSTEM     VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY   VARCHAR2(8);                --上日
  
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_DATE   := TO_DATE(I_P_DATE,'YYYY-MM-DD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');  --上日
  
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CUST_IND_REL_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'V_TAB_NAME'||' TRUNCATE PARTITION '||'PARTITION_'||I_P_DATE);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '-- 插入个人客户关系人子表-ECIF客户信息 --';
  INSERT INTO RRP_MDL.M_CUST_IND_REL_SUB
    (DATA_DT                    --数据日期
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
    ,CREATE_TM                  --建立关系日期 ADD BY LTJ 20250430
    ,RELEASE_TM                 --解除关系日期 ADD BY LTJ 20250430
    )
    WITH TMP1 AS ( --ADD BY LTJ 20250430 加工客户的解除日期
            SELECT T1.ETL_DT
                  ,T1.CUST_ID
                  ,T1.RELA_PS_ID
                  ,T2.RELA_TYPE_CD
             FROM RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO  T1     --个人客户关联人信息
             LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO  T2  --个人客户关联人信息
               ON T2.RELA_PS_ID = T1.RELA_PS_ID
              AND T2.CUST_ID = T1.CUST_ID
              AND T2.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
            WHERE T1.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD') - 1 
              AND T2.RELA_TYPE_CD IS NULL  )  
  SELECT T.DATA_DT                    --数据日期
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
        ,T.CREATE_TM                  --建立关系日期 ADD BY LTJ 20250430
        ,T.RELEASE_TM                 --解除关系日期 ADD BY LTJ 20250430
    FROM (
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')      AS DATA_DT                    --数据日期
          ,A.LP_ID                            AS LGL_REP_ID                 --法人编号
          ,A.CUST_ID                          AS CUST_ID                    --客户编号
          ,B.TAR_VALUE_CODE                   AS REL_TYP                    --关系类型
          --,REPLACE(A.RELA_PS_NAME,'.','')     AS REL_PSN_NM                 --关系人姓名
          ,A.RELA_PS_NAME                     AS REL_PSN_NM                 --关系人姓名
          ,A.RELA_PS_CERT_TYPE_CD             AS REL_PSN_CRDL_TYP           --关系人证件类型
          ,A.RELA_PS_CERT_NO                  AS REL_PSN_CRDL_NO            --关系人证件号码
          ,A.RELA_PS_CUST_ID/*RELA_PS_ID*/    AS REL_PSN_CUST_ID            --关系人客户编号 -- 20221104 MW 修改为关联人客户编号
          ,'Y'                                AS REL_STAT                   --关系状态
          ,'800924'                           AS DEPT_LINE                  --部门条线 /*零售信贷部(普惠金融部)*/
          ,SUBSTR(A.JOB_CD, 0, 4)             AS DATA_SRC                   --数据来源
          ,A.RELA_PS_ID                       AS RELA_PS_ID                 --关联人编号
          ,NVL(TO_CHAR(NVL(A.RELA_PS_CREATE_TM,A.RELA_PS_INPUT_SYS_TM),'YYYY-MM-DD'),'9999-12-31') 
                                              AS CREATE_TM                  --建立关系日期 ADD BY LTJ 20250430
          ,CASE WHEN C.RELA_TYPE_CD IS NULL 
                THEN TO_CHAR(A.ETL_DT, 'YYYY-MM-DD')
                ELSE '9999-12-31' 
           END                                AS RELEASE_TM                 --解除关系日期 ADD BY LTJ 20250430
          ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,B.TAR_VALUE_CODE,A.RELA_PS_CERT_NO ORDER BY A.JOB_CD DESC,A.RELA_PS_ID DESC) AS NUM
      FROM RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO A --个人客户关联人信息
      LEFT JOIN RRP_MDL.CODE_MAP B
        ON B.SRC_VALUE_CODE = A.RELA_TYPE_CD
       AND B.SRC_CLASS_CODE = 'CD1280'  --当事人关系类型代码
       AND B.TAR_CLASS_CODE = 'C0017'   --对私关系类型
       AND B.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN TMP1 C  --客户解除日期  ADD BY LTJ 20250430
      ON C.RELA_PS_ID = A.RELA_PS_ID
       AND C.CUST_ID = A.CUST_ID
     WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND TRIM(A.CUST_ID) IS NOT NULL
       AND TRIM(A.RELA_PS_CERT_NO) IS NOT NULL
       AND TRIM(A.RELA_PS_NAME) IS NOT NULL) T
   WHERE T.NUM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入个人客户关系人子表-信贷系统-担保关系';
  V_STARTTIME := SYSDATE;
  /*信贷系统-担保关系*/
  INSERT INTO RRP_MDL.M_CUST_IND_REL_SUB
    (DATA_DT              --数据日期
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
    SELECT  A.ETL_DT
           ,A.LP_ID
           ,C.CUST_ID
           ,A.GUARTOR_NAME
           ,A.GUARTOR_CERT_NO
           ,A.GUARTOR_ID
           ,A.GUARTOR_CERT_TYPE_CD
           ,UPPER(A.JOB_CD) JOB_CD
           ,ROW_NUMBER() OVER(PARTITION BY C.CUST_ID,A.GUARTOR_CERT_NO ORDER BY A.GUARTOR_ID ) RN
      FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A  --担保合同
     INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售贷款合同信息
        ON C.CONT_ID = A.PRI_CONTR_ID
       AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     WHERE A.EFFECT_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND A.STATUS_CD = '101'--'101'有效，‘111’已失效
       AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD'))
  SELECT  TO_CHAR(A.ETL_DT, 'YYYYMMDD')         AS DATA_DT      --数据日期
         ,A.LP_ID                               AS LGL_REP_ID   --法人编号
         ,A.CUST_ID                             AS CUST_ID      --客户编号
         ,'9901'                                AS REL_TYP   /*其他-担保*/   --关联类型代码
         ,A.GUARTOR_NAME                        AS REL_PSN_NM             --担保人名称
         ,A.GUARTOR_CERT_TYPE_CD                AS REL_PSN_CRDL_TYP       --担保人证件类型代码
         ,A.GUARTOR_CERT_NO                     AS REL_PSN_CRDL_NO        --担保人证件号码
         ,A.GUARTOR_ID                          AS REL_PSN_CUST_ID        --担保人编号
         ,'Y'                                   AS REL_STAT               --关系状态
         ,'05'                                  AS DEPT_LINE              --部门条线
         ,SUBSTR(A.JOB_CD, 0, 4)                AS DATA_SRC                --数据来源
    FROM TMP1 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   WHERE A.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入个人客户关系人子表-信贷系统-联合网贷担保关系';
  V_STARTTIME := SYSDATE;
  /*信贷系统-担保关系*/
  INSERT INTO RRP_MDL.M_CUST_IND_REL_SUB
    (DATA_DT              --数据日期
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
    SELECT  A.ETL_DT
           ,A.LP_ID
           ,D.CUST_ID
           ,A.GUARTOR_NAME
           ,A.GUARTOR_CERT_NO
           ,A.GUARTOR_CUST_ID
           ,A.GUARTOR_CERT_TYPE_CD
           ,UPPER(A.JOB_CD) JOB_CD
           ,ROW_NUMBER() OVER(PARTITION BY C.CUST_ID,A.GUARTOR_CERT_NO ORDER BY A.GUARTOR_CUST_ID ) RN
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A  --联合网贷担保合同信息
     INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B  --联合网贷贷款与担保合同关系
         ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
        AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO C --联合网贷贷款合同信息
        ON C.CONT_ID = B.LOAN_CONT_ID
       AND TRIM(C.CUST_ID) IS NOT NULL
       AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO D --联合网贷借据信息
        ON D.CONT_ID = C.CONT_ID
       AND TRIM(D.CUST_ID) IS NOT NULL
       AND D.DUBIL_STATUS_CD NOT IN ('2','5')
       AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND D.STD_PROD_ID NOT IN ('203050100001','203050100002') --MOD BY YJY 20260116 剔掉对公微业贷的相关产品
     WHERE A.EFFECT_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND A.STATUS_CD = '2' --'2'有效
       AND TRIM(A.GUARTOR_CUST_ID) IS NOT NULL
       AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')         AS DATA_DT,      --数据日期
         A.LP_ID                               AS LGL_REP_ID,   --法人编号
         A.CUST_ID                             AS CUST_ID ,     --客户编号
         '9901'                                AS REL_TYP,/*其他-担保*/   --关联类型代码
         A.GUARTOR_NAME                        AS REL_PSN_NM,             --担保人名称
         A.GUARTOR_CERT_TYPE_CD                AS REL_PSN_CRDL_TYP,       --担保人证件类型代码
         A.GUARTOR_CERT_NO                     AS REL_PSN_CRDL_NO,        --担保人证件号码
         A.GUARTOR_CUST_ID                     AS REL_PSN_CUST_ID,        --担保人编号
         'Y'                                   AS REL_STAT,               --关系状态
         '05'                                  AS DEPT_LINE,              --部门条线
         '联合网贷担保'                        AS DATA_SRC                --数据来源
    FROM TMP1 A
   WHERE A.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,REL_TYP,REL_PSN_CRDL_NO,COUNT(1)
      FROM RRP_MDL.M_CUST_IND_REL_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, CUST_ID,REL_TYP,REL_PSN_CRDL_NO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

 --程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CUST_IND_REL_SUB;
/

