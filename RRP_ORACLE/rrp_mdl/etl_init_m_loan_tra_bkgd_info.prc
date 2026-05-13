CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_TRA_BKGD_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_TRA_BKGD_INFO
  *  功能描述：交易背景信息表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_TRA_BKGD_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221105  MW        修改信用证及承兑汇票单据编号、种类、金额口径
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_TRA_BKGD_INFO'; -- 程序名称
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
  V_TAB_NAME := 'M_LOAN_TRA_BKGD_INFO'; --表名
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
  V_STEP_DESC := '插入交易背景信息表-信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO
  (
      DATA_DT    --数据日期
      ,LGL_REP_ID    --法人编号
      ,ORG_ID    --机构编号
      ,BIZ_CL    --业务种类
      ,BIZ_ID    --业务编号
      ,CUR    --币种
      ,CONT_AMT    --合同金额
      ,INV_ID    --单据编号
      ,INV_CL    --单据种类
      ,INV_CUR    --单据币种
      ,INV_AMT    --单据金额
      ,DEPT_LINE    --部门条线
      ,DATA_SRC    --数据来源
      ,INV_START_DT --单据起始日期
  )
  SELECT DISTINCT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD'),                                                                  --数据日期
    A.LP_ID,                                                                                        --法人编号
    A.ACCT_INSTIT_ID,                                                                               --内部机构号
   'A02',                                                                                           --业务种类
    NVL(F.CONT_ID,'1'),                                                                             --业务编号
    F.CURR_CD,                                                                                      --币种
    F.CONT_AMT,                                                                                     --合同金额
    IMG.INVNB,                                                                                     --单据编号
    CASE WHEN IMG.INVTP = 'COMM' THEN '普通发票'
              WHEN IMG.INVTP = 'SPEC' THEN '专用发票'
              WHEN IMG.INVTP = 'ECOM' THEN '电子普通发票'
              WHEN IMG.INVTP = 'ESPE' THEN '电子专用发票'
              ELSE '其他发票'
          END,                                                                            --单据种类
    'CNY',                                                                            --单据币种
    IMG.UNTAXAMT,                                                                                   --单据金额
    '800919', /*风险管理部*/                                                                            --部门条线
    '信用证'                                                                                            --数据来源
    , TO_CHAR(IMG.INVDT,'YYYYMMDD')                                                                  --单据起始日期
  FROM RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    ON A.LC_ID = B.BILL_NUM
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C  --内部机构信息
    ON C.ORG_ID=A.ACCT_INSTIT_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_LC_DOC_INFO E --信用证单据信息
    ON A.ACCT_ID = E.LC_ACCT_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO F --对公贷款合同信息
    ON F.CONT_ID = B.CONT_ID
    AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_EVT_INTSTL_TRAN_FLOW_EVT TRN
      ON TRN.TRAN_ID = E.DOC_ID
     AND TRN.AUTH_STATUS_CD = 'R'
     AND TRN.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ISBS_IMG IMG --发票信息表
      ON IMG.OBJINR = TRN.SRC_EVT_ID
     AND IMG.OBJTYP = 'TRN'
     AND IMG.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
 /* LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO  D  --对公贷款业务合同补充信息
    ON D.CONT_ID = B.CONT_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
  /*LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(单据类型)
    ON TTA.SRC_VALUE_CODE = F.DOC_TYPE_CD
    AND TTA.SRC_CLASS_CODE = 'CD1384'
    AND TTA.TAR_CLASS_CODE = 'D0039'
  WHERE (B.BUS_BREED_ID LIKE '2080010%' OR B.BUS_BREED_ID LIKE '2080030%' OR B.BUS_BREED_ID LIKE '2085010%')
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
  WHERE /*(F.BUS_BREED_ID LIKE '2080010%' OR F.BUS_BREED_ID LIKE '2080030%' OR F.BUS_BREED_ID LIKE '2085010%')*/
     F.STD_PROD_ID IN ('601020200001','601020200002','603010300002', --国际信用证
     '601020100001','601020100002','603010100002',  --国内信用证
     '203020700001'--进口代付
     )
     AND NVL(IMG.INVNB,' ') <>  ' ' /*目前只有国内出口信息证有单据信息，故只过滤这些数据来报送*/
     --AND IMG.INVDT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;



   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

/*  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入交易背景信息表-保函';
  V_STARTTIME := SYSDATE;

   INSERT \*+APPEND *\INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO
  (
    DATA_DT    --数据日期
      ,LGL_REP_ID    --法人编号
      ,ORG_ID    --机构编号
      ,BIZ_CL    --业务种类
      ,BIZ_ID    --业务编号
      ,CUR    --币种
      ,CONT_AMT    --合同金额
      ,INV_ID    --单据编号
      ,INV_CL    --单据种类
      ,INV_CUR    --单据币种
      ,INV_AMT    --单据金额
      ,DEPT_LINE    --部门条线
      ,DATA_SRC    --数据来源
   )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD'),                                                                  --数据日期
    A.LP_ID,                                                                                        --法人编号
    A.ACCT_INSTIT_ID,                                                                               --内部机构号
    'A03',                                                                                          --业务种类
    B.CONT_ID,                                                                                      --业务编号
    E.CURR_CD,                                                                                      --币种
    E.CONT_AMT,                                                                                     --合同金额
    A.LOG_CONT_ID,                                                                                   --单据编号
    D.COMMER_INV_KIND_CD,                                                                           --单据种类
    D.COMMER_INV_CURR_CD,                                                                           --单据币种
    D.COMMER_INV_AMT,                                                                               --单据金额
    '800919',                                                                                         --部门条线
    '保函'                                                                                           --数据来源
  FROM RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    ON A.LOG_CONT_ID = B.DUBIL_ID
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C  --内部机构信息
    ON C.ORG_ID=A.ACCT_INSTIT_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款合同补充信息表
    ON D.CONT_ID = B.CONT_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
    ON E.CONT_ID = B.CONT_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE (B.BUS_BREED_ID LIKE '2030%' OR B.BUS_BREED_ID LIKE '2040%' OR B.BUS_BREED_ID LIKE '2080020%')
  AND A.LOG_CONT_ID IS NOT NULL
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入交易背景信息表-承兑汇票';
  V_STARTTIME := SYSDATE;

/*   INSERT \*+APPEND *\INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO
  (
    DATA_DT    --数据日期
      ,LGL_REP_ID    --法人编号
      ,ORG_ID    --机构编号
      ,BIZ_CL    --业务种类
      ,BIZ_ID    --业务编号
      ,CUR    --币种
      ,CONT_AMT    --合同金额
      ,INV_ID    --单据编号
      ,INV_CL    --单据种类
      ,INV_CUR    --单据币种
      ,INV_AMT    --单据金额
      ,DEPT_LINE    --部门条线
      ,DATA_SRC    --数据来源
   )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD'),                                                                  --数据日期
    A.LP_ID,                                                                                        --法人编号
    A.BELONG_ORG_ID,                                                                                --内部机构号
    'A01', --承兑汇票                                                                               --业务种类
    E.CONT_ID,                                                                                      --业务编号
    E.CURR_CD,                                                                                      --币种
    E.CONT_AMT,                                                                                     --合同金额
    D.COMMER_INV_INFO_DESC,                                                                                   --单据编号
    D.COMMER_INV_KIND_CD,                                                                         --单据种类
    D.COMMER_INV_CURR_CD,                                                                                --单据币种
    D.COMMER_INV_AMT,                                                                              --单据金额
    '800919', \*风险管理部*\                                                                        --部门条线
    '承兑汇票'                                                                                      --数据来源
  FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO A --票据中心信息表
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    ON A.BILL_ID = B.BILL_ID
    AND A.BILL_NUM = B.BILL_NUM
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
    ON B.CONT_ID = E.CONT_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款合同补充信息表
    ON D.CONT_ID = B.CONT_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE A.BILL_TYPE_CD IN ('01', '02')
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND D.COMMER_INV_INFO_DESC IS NOT NULL
  ;
*/
INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO(
     DATA_DT
    ,LGL_REP_ID
    ,ORG_ID
    ,BIZ_CL
    ,BIZ_ID
    ,CUR
    ,CONT_AMT
    ,INV_ID
    ,INV_CL
    ,INV_CUR
    ,INV_AMT
    ,DEPT_LINE
    ,DATA_SRC
    ,INV_START_DT
    )
    WITH H AS (
      SELECT A.ETL_DT,A.LP_ID,I.ORG_ID1,E.CONT_ID,E.CURR_CD,E.CONT_AMT,G.VOUCHER_NO,
             G.VOUCHER_TYPE,G.VOUCHER_CURCD,G.VOUCHER_AMT,A.JOB_CD,E.RGST_DT
        FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO A --票据中心信息表
       INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
          --ON A.BILL_ID = B.DUBIL_ID
          ON A.BILL_ID = B.BILL_ID
         AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E  --对公贷款合同信息
          ON B.CONT_ID = E.CONT_ID
         AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        /*LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO D --对公贷款合同补充信息表
          ON D.CONT_ID = B.CONT_ID
         AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
       INNER JOIN (SELECT DISTINCT DRAFT_NUMBER,VOUCHER_NO,VOUCHER_AMT,VOUCHER_CURCD,VOUCHER_TYPE
                     FROM RRP_MDL.O_IOL_BDMS_BIL_COMMERCIAL_VOUCHER_INFO
                    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                      AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))G  --票据发票信息表
          ON G.DRAFT_NUMBER = A.BILL_NUM
       INNER JOIN RRP_MDL.ORG_CONFIG I
          ON A.BELONG_ORG_ID = I.ORG_ID
       WHERE A.BILL_TYPE_CD IN ('AC01', 'AC02') --承兑汇票
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    K AS (
      SELECT DISTINCT
             TO_CHAR(H.ETL_DT, 'YYYYMMDD')       AS DATA_DT,    --数据日期
             H.LP_ID                             AS LGL_REP_ID, --法人编号
             H.ORG_ID1                           AS ORG_ID,     --内部机构号
             'A01'                               AS BIZ_CL,     --业务种类
             H.CONT_ID                           AS BIZ_ID,     --业务编号
             H.CURR_CD                           AS CUR,        --币种
             H.CONT_AMT                          AS CONT_AMT,   --合同金额
             REGEXP_SUBSTR(REPLACE(H.VOUCHER_NO,'、',';'),'[^;]+',1,LEVEL) AS INV_ID, --单据编号
             CASE WHEN H.VOUCHER_TYPE = '00' THEN '商业发票'
                  WHEN H.VOUCHER_TYPE = '01' THEN '详细发票'
                  WHEN H.VOUCHER_TYPE = '02' THEN '证实发票'
                  WHEN H.VOUCHER_TYPE = '03' THEN '收妥发票'
                  WHEN H.VOUCHER_TYPE = '04' THEN '厂商发票'
                  WHEN H.VOUCHER_TYPE = '05' THEN '形式发票'
                  WHEN H.VOUCHER_TYPE = '06' THEN '样品发票'
                  WHEN H.VOUCHER_TYPE = '07' THEN '领事发票'
                  WHEN H.VOUCHER_TYPE = '08' THEN '寄售发票'
                  WHEN H.VOUCHER_TYPE = '09' THEN '海关发票'
              END                                AS INV_CL,     --单据种类
             H.VOUCHER_CURCD                     AS INV_CUR,    --单据币种
             H.VOUCHER_AMT                       AS INV_AMT,    --单据金额
             '800919'                            AS DEPT_LINE,  --部门条线/*风险管理部*/
             '承兑汇票'            AS DATA_SRC,   --数据来源
             TO_CHAR(H.RGST_DT,'YYYYMMDD')       AS INV_START_DT--单据起始日期
        FROM H
     CONNECT BY H.VOUCHER_NO = PRIOR H.VOUCHER_NO
         AND LEVEL <= LENGTH(REPLACE(H.VOUCHER_NO,'、',';'))- LENGTH(REGEXP_REPLACE(REPLACE(H.VOUCHER_NO,'、',';'),';',''))+1
         AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL )
  SELECT K.DATA_DT,K.LGL_REP_ID,K.ORG_ID,K.BIZ_CL,K.BIZ_ID,K.CUR,K.CONT_AMT,K.INV_ID,K.INV_CL,K.INV_CUR,
         K.INV_AMT,K.DEPT_LINE,K.DATA_SRC,K.INV_START_DT
    FROM K
   WHERE LENGTH(K.INV_ID) <= 30
     AND K.INV_ID <> '0';
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, BIZ_ID,INV_ID,ORG_ID,COUNT(1)
      FROM M_LOAN_TRA_BKGD_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, BIZ_ID,INV_ID,ORG_ID
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

  END ETL_INIT_M_LOAN_TRA_BKGD_INFO;
/

