CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_PUM_EMP_TLR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_PUM_EMP_TLR
  *  功能描述：监管集市柜员信息包含实体柜员和虚拟柜员
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            ICL.CMM_CLERK_INFO   --行员信息表
  *            ICL.CMM_TELLER_INFO  --柜员信息表
  *            IOL.ISBS_USR   --用户信息
  *            IOL.DPSS_TLP_TELLER --柜员参数表
  *  目标表：  M_PUM_EMP_TLR  --柜员表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221010  hulj     调整柜员类型取数逻辑。
  *             2    20221108  hulj     增加数据重复校验 。
  *             3    20221112  LHQ      修改员工编号，柜员状态取值。
  *             4    20221130  hulj     调整是否实体柜员口径。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_PUM_EMP_TLR'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_PUM_EMP_TLR'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
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
  V_STEP_DESC := '柜员表:逻辑1-核心系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_TLR
  (
    DATA_DT        --数据日期
   ,LGL_REP_ID     --法人编号
   ,TLR_NO         --柜员号
   ,EMP_ID         --员工编号
   ,ORG_ID         --机构编号
   ,TLR_TYP        --柜员类型
   ,ENT_TLR_FLG    --实体柜员标志
   ,POST_ID        --岗位编号
   ,TLR_AUTH_LVL   --柜员权限级别
   ,ON_DUTY_DT     --上岗日期
   ,TLR_STAT       --柜员状态
   ,DEPT_LINE      --部门条线
   ,DATA_SRC       --数据来源
   ,TELLER_STATUS_CD --柜员状态代码
  )
  /*WITH CLERK_TMP AS (
    SELECT T.TELLER_ID,T.CLERK_ID,T.EMPLY_TYPE_CD,T.EMPYT_DT
    FROM (
      SELECT TELLER_ID,CLERK_ID,EMPLY_TYPE_CD,EMPYT_DT,ROW_NUMBER() OVER(PARTITION BY TELLER_ID ORDER BY EMPYT_DT DESC) AS NUM
      FROM O_ICL_CMM_CLERK_INFO --行员信息表
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND CLERK_ID IS NOT NULL
        AND TELLER_FLG = '1'
        AND EMPYT_DT <= ETL_DT
      ) T
    WHERE T.NUM = 1
  )
  SELECT
     TO_CHAR(A.ETL_DT,'YYYYMMDD')           AS DATA_DT       --数据日期
    ,A.LP_ID                                AS LGL_REP_ID    --法人编号
    ,A.TELLER_ID                            AS TLR_NO        --柜员号
    ,C.CLERK_ID                             AS EMP_ID        --员工编号
    ,NVL(B.ORG_ID,E.ORG_ID)                 AS ORG_ID        --机构编号
    ,CASE WHEN A.TELLER_TYPE_CD ='C' THEN '柜台柜员'
          WHEN A.TELLER_TYPE_CD ='D' THEN '非营运柜员'
          WHEN A.TELLER_TYPE_CD ='P' THEN '客户经理'
          ELSE REPLACE(REPLACE(TRANSLATE(A.TELLER_NAME,'0123456789',' '),' ',''),'柜员','')||'虚拟柜员'
     END                                    AS TLR_TYP       --柜员类型
    ,CASE WHEN A.ENTY_TELLER_FLG ='1' AND TRIM(C.CLERK_ID) IS NOT NULL THEN 'Y'
          ELSE 'N'
     END                                    AS ENT_TLR_FLG   --实体柜员标志
    ,A.JOBS_CD                              AS POST_ID       --岗位编号
    ,'99'                                   AS TLR_AUTH_LVL  --柜员权限级别
    ,CASE WHEN A.EMPYT_DT IS NOT NULL THEN TO_CHAR(A.EMPYT_DT,'YYYYMMDD')
          WHEN C.EMPYT_DT IS NOT NULL THEN TO_CHAR(C.EMPYT_DT,'YYYYMMDD')
          ELSE '99991231'
     END                                    AS ON_DUTY_DT    --上岗日期
    ,CASE WHEN A.TELLER_STATUS_CD IN ('0','1') AND C.EMPLY_TYPE_CD NOT IN ('3','5')  THEN '02'
          WHEN A.TELLER_STATUS_CD IN ('0','1') AND C.EMPLY_TYPE_CD IN ('3','5') THEN '04'
          ELSE '09'
     END                                    AS TLR_STAT      --柜员状态
    ,'800001'                               AS DEPT_LINE     --部门条线
    ,SUBSTR(A.JOB_CD,0,4)                   AS DATA_SRC      --数据来源
  FROM O_ICL_CMM_TELLER_INFO A --柜员信息
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息表
  ON B.ORG_ID = (CASE WHEN A.BELONG_ORG_ID = '800922' THEN '800' ELSE A.BELONG_ORG_ID END)
  LEFT JOIN CLERK_TMP C --行员信息表
  ON A.TELLER_ID = C.TELLER_ID
  LEFT JOIN O_IML_REF_PUB_CD D
  ON A.TELLER_TYPE_CD = D.CD_VAL
  AND D.CD_ID = 'CD2260'  --柜员类型
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO E --内部机构信息表
  ON E.ORG_ID = '800001'
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.TELLER_ID IS NOT NULL
  ;*/
  WITH CLERK_TMP1 AS (
     SELECT TRIM(SUBSTR(TC.RELA_PS_ID,7)) CLERK_ID,SUBSTR(TC.CUST_ID,7) TELLER_ID,
            TA.EMPLY_TYPE_CD,TA.EMPYT_DT,TA.JOBS_CD,TA.POST_CD AS POST_CD
       FROM RRP_MDL.O_ICL_CMM_CORP_CUST_RELA_PS_INFO TC
       LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO TA
         ON TA.CLERK_ID = TRIM(SUBSTR(TC.RELA_PS_ID,7))
        AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --WHERE TC.RELA_TYPE_CD = 'dw009'
      UNION ALL
     SELECT CLERK_ID,TELLER_ID,EMPLY_TYPE_CD,EMPYT_DT,JOBS_CD,POST_CD
       FROM RRP_MDL.O_ICL_CMM_CLERK_INFO TA
      WHERE TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND TRIM(TA.TELLER_ID) IS NOT NULL),
      CLERK_TMP AS (
        SELECT T.TELLER_ID,T.CLERK_ID,T.EMPLY_TYPE_CD,T.EMPYT_DT,T.JOBS_CD,T.POST_CD
        FROM (
          SELECT CLERK_ID,TELLER_ID,EMPLY_TYPE_CD,EMPYT_DT,JOBS_CD,POST_CD,ROW_NUMBER() OVER(PARTITION BY TELLER_ID ORDER BY EMPYT_DT DESC) AS NUM
          FROM CLERK_TMP1 --行员信息表
          WHERE CLERK_ID IS NOT NULL
            AND EMPYT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          ) T
        WHERE T.NUM = 1
      )
    SELECT
       TO_CHAR(A.ETL_DT,'YYYYMMDD')           AS DATA_DT       --数据日期
      ,A.LP_ID                                AS LGL_REP_ID    --法人编号
      ,A.TELLER_ID                            AS TLR_NO        --柜员号
      --,NVL(C.CLERK_ID,'2')                    AS EMP_ID        --员工编号
       ,/*CASE WHEN A.TELLER_TYPE_SUBCLASS_CD = '01' THEN A.TELLER_ID
             ELSE '2'  END  */
        A.TELLER_ID                           AS EMP_ID        --员工编号
       ,A.BELONG_ORG_ID                       AS ORG_ID        --机构编号
      /*,CASE WHEN A.TELLER_TYPE_CD ='C' THEN '柜台柜员'
            WHEN A.TELLER_TYPE_CD ='D' THEN '非营运柜员'
            WHEN A.TELLER_TYPE_CD ='P' THEN '客户经理'
            WHEN A.TELLER_NAME ='邱莉如' THEN '虚拟柜员'
            WHEN A.TELLER_TYPE_CD ='DUMMY_TELLER' THEN '虚拟柜员'
            WHEN A.TELLER_TYPE_CD ='TELLER_USER' THEN '普通柜员'
            ELSE REPLACE(REPLACE(TRANSLATE(A.TELLER_NAME,'0123456789',' '),' ',''),'柜员','')||'虚拟柜员'
       END                                    AS TLR_TYP       --柜员类型 --MODIFY BY hulj 20221010 */
      ,CASE /*WHEN A.TELLER_ID IN ('M0001','M0002') THEN '中间业务虚拟柜员' --modify by tangan at 20221229
            WHEN A.TELLER_ID = 'S####'            THEN '系统虚拟柜员'     --modify by tangan at 20221229*/
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '01' THEN '普通柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '02' THEN 'CRS虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '03' THEN 'ATM虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '04' THEN 'POS虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '05' THEN 'BSM虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '06' THEN '查询终端虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '07' THEN 'STM虚拟柜员'
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '08' THEN '清机公司柜员' --modify by tangan at 20230110 核心确定08-清机公司柜员,邮件“柜员类型-08码值映射问题”
            WHEN A.TELLER_TYPE_SUBCLASS_CD = '09' THEN '其他-其他' --modify by tangan at 20230106 根据邮件“关于新一代EAST柜员表缺陷（BUG_067290）问题”调整
            END                            AS TLR_TYP       --柜员类型 --20221018 MW
       /*CASE WHEN A.ENTY_TELLER_FLG ='1' AND TRIM(C.CLERK_ID) IS NOT NULL THEN 'Y'
            ELSE 'N'
       END                                    AS ENT_TLR_FLG   --实体柜员标志*/
      ,CASE WHEN  A.TELLER_TYPE_CD = 'DUMMY_TELLER'
            THEN 'N' ELSE 'Y'
             END                            AS TLR_TYP       --柜员类型 mod by hulj 20221130
      ,/*CASE WHEN TRIM(A.JOBS_CD) IS NOT NULL THEN TRIM(A.JOBS_CD)
            WHEN TRIM(C.JOBS_CD) IS NOT NULL THEN TRIM(C.JOBS_CD)
              ELSE TRIM(C.POST_CD) END */
       A.JOBS_CD                                 AS POST_ID       --岗位编号
      ,A.TELLER_PRVLG_LEV_CD                    AS TLR_AUTH_LVL  --柜员权限级别
      ,/*CASE WHEN C.EMPYT_DT IS NOT NULL THEN TO_CHAR(C.EMPYT_DT,'YYYYMMDD')
            WHEN A.EMPYT_DT IS NOT NULL THEN TO_CHAR(A.EMPYT_DT,'YYYYMMDD')
            ELSE '99991231'
       END */
       TO_CHAR(A.EMPYT_DT,'YYYYMMDD')        AS ON_DUTY_DT    --上岗日期 mod by hulj 20221203
      ,CASE WHEN A.TELLER_TYPE_CD = 'DUMMY_TELLER' THEN '04' ---MODIFY BY CAIZHENGWEI 20220609 特殊柜员处理
            WHEN A.TELLER_STATUS_CD IN ('A','U','O') AND C.EMPLY_TYPE_CD IN ('1','2')  THEN '02'   --正式员工在职    modify BY LHQ 20221112
            WHEN A.TELLER_STATUS_CD IN ('A','U','O') AND C.EMPLY_TYPE_CD IN ('3','4','5','6','7') THEN '04'    --非正式员工在职   modify BY LHQ 20221112
            ELSE '09'
           -- ELSE '99'
       END                                    AS TLR_STAT      --柜员状态
      ,'800001' /*营运管理部 */                 AS DEPT_LINE     --部门条线
      ,'柜员信息'                             AS DATA_SRC      --数据来源
      ,A.TELLER_STATUS_CD                     AS TELLER_STATUS_CD --柜员状态代码 add by hulj 20221203
       FROM O_ICL_CMM_TELLER_INFO A --柜员信息
/*  LEFT JOIN ORG_CONFIG B
         ON B.ORG_ID = (CASE WHEN A.BELONG_ORG_ID = '800922' THEN '800' ELSE A.BELONG_ORG_ID END)*/
  LEFT JOIN CLERK_TMP C --行员信息表
         ON A.TELLER_ID = C.TELLER_ID
  /*LEFT JOIN O_IML_REF_PUB_CD D
         ON A.TELLER_TYPE_CD = D.CD_VAL
        AND D.CD_ID = 'CD2260'  --柜员类型*/
  /*LEFT JOIN ORG_CONFIG E
         ON E.ORG_ID = '800001'*/
      WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND A.TELLER_ID IS NOT NULL
    ;
     V_SQLCOUNT := SQL%ROWCOUNT;
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
     COMMIT;

  ---记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
/*
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '柜员表:逻辑2-国结系统--柜员自编的';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_PUM_EMP_TLR (
    DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    TLR_NO,        --柜员号
    EMP_ID,        --员工编号
    ORG_ID,        --机构编号
    TLR_TYP,       --柜员类型
    ENT_TLR_FLG,   --实体柜员标志
    POST_ID,       --岗位编号
    TLR_AUTH_LVL,  --柜员权限级别
    ON_DUTY_DT,    --上岗日期
    TLR_STAT,      --柜员状态
    DEPT_LINE,     --部门条线
    DATA_SRC       --数据来源
  )
  SELECT
     V_P_DATE                     AS DATA_DT        --数据日期
    ,'9999'                       AS LGL_REP_ID     --法人代码
    ,A.EXTKEY                     AS TLR_NO         --柜员编号
    ,'1'                          AS EMP_ID         --员工编号
    ,'800'                        AS ORG_ID         --机构编号
    ,'国结柜员'                   AS TLR_TYP        --柜员类型
    ,'N'                          AS ENT_TLR_FLG    --实体柜员标志
    ,NULL                         AS POST_ID        --岗位编号
    ,'99'                         AS TLR_AUTH_LVL   --柜员权限级别
    ,TO_CHAR(A.START_DT,'YYYYMMDD')                   AS ON_DUTY_DT     --上岗日期
    ,'02'                         AS TLR_STAT       --柜员状态
    ,'800001'                     AS DEPT_LINE      --部门条线 营运管理部
    ,'ISBS'                       AS DATA_SRC       --数据来源
  FROM IOL.V_ISBS_USR A --用户信息
  LEFT JOIN O_ICL_CMM_TELLER_INFO B --柜员信息
         ON A.EXTKEY = B.TELLER_ID
        AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.TELLER_ID IS NULL
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
*/
 /* V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '柜员表:逻辑3-储蓄产品';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_TLR (
    DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    TLR_NO,        --柜员号
    EMP_ID,        --员工编号
    ORG_ID,        --机构编号
    TLR_TYP,       --柜员类型
    ENT_TLR_FLG,   --实体柜员标志
    POST_ID,       --岗位编号
    TLR_AUTH_LVL,  --柜员权限级别
    ON_DUTY_DT,    --上岗日期
    TLR_STAT,      --柜员状态
    DEPT_LINE,     --部门条线
    DATA_SRC       --数据来源
  )
  SELECT DISTINCT
     V_P_DATE                     AS DATA_DT        --数据日期
    ,A.LEDGE_COD                  AS LGL_REP_ID     --法人代码
    ,A.OPR_COD                    AS TLR_NO         --柜员编号
    ,NULL                         AS EMP_ID         --员工编号
    ,NVL(B.ORG_ID1,C.ORG_ID1)     AS ORG_ID         --机构编号
    ,'储蓄产品柜员'               AS TLR_TYP        --柜员类型
    ,'N'                          AS ENT_TLR_FLG    --实体柜员标志
    ,NULL                         AS POST_ID        --岗位编号
    ,'99'                         AS TLR_AUTH_LVL   --柜员权限级别
    ,A.ENABLE_DATE                AS ON_DUTY_DT     --上岗日期
    ,'02'                         AS TLR_STAT       --柜员状态
    ,'800001'                     AS DEPT_LINE      --部门条线 营运管理部
    ,'DPSS'                       AS DATA_SRC       --数据来源
  FROM O_IOL_DPSS_TLP_TELLER A
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息表
         ON B.ORG_ID =(CASE WHEN A.ACCT_UP_UNIT = '800922' THEN '800' ELSE A.ACCT_UP_UNIT END)
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
         ON C.ORG_ID = '800001'
  LEFT JOIN O_ICL_CMM_TELLER_INFO D
         ON A.TL_NAME = D.TELLER_ID
        AND D.ETL_DT = TO_DATE(V_DATEID,'YYYYMMDD')
  WHERE A.START_DT <= TO_DATE(V_DATEID,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_DATEID,'YYYYMMDD')
    AND D.TELLER_ID IS NULL
  ;
*/ ---缺少表O_IOL_DPSS_TLP_TELLER
/*   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

 /* V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '柜员表:逻辑4-贷款产';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_TLR (
    DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    TLR_NO,        --柜员号
    EMP_ID,        --员工编号
    ORG_ID,        --机构编号
    TLR_TYP,       --柜员类型
    ENT_TLR_FLG,   --实体柜员标志
    POST_ID,       --岗位编号
    TLR_AUTH_LVL,  --柜员权限级别
    ON_DUTY_DT,    --上岗日期
    TLR_STAT,      --柜员状态
    DEPT_LINE,     --部门条线
    DATA_SRC       --数据来源
  )
  SELECT DISTINCT
     V_P_DATE                     AS DATA_DT        --数据日期
    ,A.LEDGE_COD                  AS LGL_REP_ID     --法人代码
    ,A.OPR_COD                    AS TLR_NO         --柜员编号
    ,NULL                         AS EMP_ID         --员工编号
    ,NVL(B.ORG_ID1,C.ORG_ID1)     AS ORG_ID         --机构编号
    ,'贷款产品柜员'               AS TLR_TYP        --柜员类型
    ,'N'                          AS ENT_TLR_FLG    --实体柜员标志
    ,NULL                         AS POST_ID        --岗位编号
    ,'99'                         AS TLR_AUTH_LVL   --柜员权限级别
    ,A.ENABLE_DATE                AS ON_DUTY_DT     --上岗日期
    ,'02'                         AS TLR_STAT       --柜员状态
    ,'800001'                     AS DEPT_LINE      --部门条线 营运管理部
    ,'LPSS'                       AS DATA_SRC       --数据来源
  FROM O_IOL_LPSS_TLP_TELLER A
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息表
         ON B.ORG_ID =(CASE WHEN A.ACCT_UP_UNIT = '800922' THEN '800' ELSE A.ACCT_UP_UNIT END)
  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
         ON C.ORG_ID = '800001'
  LEFT JOIN O_ICL_CMM_TELLER_INFO D
         ON A.OPR_COD = D.TELLER_ID
        AND D.ETL_DT = TO_DATE(V_DATEID,'YYYYMMDD')
  WHERE  D.TELLER_ID IS NULL
  ; */ --缺少表 O_IOL_LPSS_TLP_TELLER
/*   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

 /* V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '柜员表:逻辑5-上岗日期特殊处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_TLR (
    DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    TLR_NO,        --柜员号
    EMP_ID,        --员工编号
    ORG_ID,        --机构编号
    TLR_TYP,       --柜员类型
    ENT_TLR_FLG,   --实体柜员标志
    POST_ID,       --岗位编号
    TLR_AUTH_LVL,  --柜员权限级别
    ON_DUTY_DT,    --上岗日期
    TLR_STAT,      --柜员状态
    DEPT_LINE,     --部门条线
    DATA_SRC       --数据来源
  )
  SELECT
     T.DATA_DT                     AS DATA_DT        --数据日期
    ,T.LGL_REP_ID                  AS LGL_REP_ID     --法人代码
    ,T.TLR_NO                      AS TLR_NO         --柜员编号
    ,T.EMP_ID                      AS EMP_ID         --员工编号
    ,T.ORG_ID                      AS ORG_ID         --机构编号
    ,T.TLR_TYP                     AS TLR_TYP        --柜员类型
    ,T.ENT_TLR_FLG                 AS ENT_TLR_FLG    --实体柜员标志
    ,T.POST_ID                     AS POST_ID        --岗位编号
    ,T.TLR_AUTH_LVL                AS TLR_AUTH_LVL   --柜员权限级别
    ,T.ON_DUTY_DT                  AS ON_DUTY_DT     --上岗日期
    ,T.TLR_STAT                    AS TLR_STAT       --柜员状态
    ,T.DEPT_LINE                   AS DEPT_LINE      --部门条线 营运管理部
    ,T.DATA_SRC                    AS DATA_SRC       --数据来源
  FROM (SELECT DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    TLR_NO,        --柜员号
    EMP_ID,        --员工编号
    ORG_ID,        --机构编号
    TLR_TYP,       --柜员类型
    ENT_TLR_FLG,   --实体柜员标志
    POST_ID,       --岗位编号
    TLR_AUTH_LVL,  --柜员权限级别
    ON_DUTY_DT,    --上岗日期
    TLR_STAT,      --柜员状态
    DEPT_LINE,     --部门条线
    DATA_SRC ,      --数据来源
    ROW_NUMBER() OVER(PARTITION BY TLR_NO ORDER BY ON_DUTY_DT DESC) ROWNO
    FROM TMP_M_PUM_EMP_TLR) T
  WHERE T.ROWNO=1
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TLR_NO,EMP_ID,COUNT(1)
      FROM M_PUM_EMP_TLR T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, TLR_NO,EMP_ID
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

  END ETL_INIT_M_PUM_EMP_TLR;
/

