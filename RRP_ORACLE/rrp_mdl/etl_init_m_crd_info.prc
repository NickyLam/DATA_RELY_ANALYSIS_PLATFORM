CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CRD_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CRD_INFO
  *  功能描述：监管集市银行所有卡片，卡面信息，卡和活期账户会有多对多的关系。
  *  创建日期：20220527
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            ICL.CMM_DEP_CUST_ACCT_INFO   --存款主账户
  *            ICL.CMM_BANK_CARD_BASIC_INFO   --银行卡基本信息
  *            IML.REF_PUB_CD           --公共代码表
  *            ICL.CMM_INDV_CUST_BASIC_INFO    -- 个人客户基本信息
  *  目标表：  M_CRD_INFO  --卡基本信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221122  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CRD_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_START_DT  DATE; --开始日期
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_START_DT := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM') ;
  V_TAB_NAME := 'M_CRD_INFO'; --表名
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
  V_STEP_DESC := '卡基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CRD_INFO
    (
     DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,CRD_NO                          --卡号
    ,SN                              --序号
    ,ORG_ID                          --机构编号
    ,CUST_ID                         --客户编号
    ,CRD_CL                          --卡片种类
    ,CRD_STAT                        --卡状态
    ,SUP_CRD_FLG                     --副卡标志
    ,CRD_ISU_DT                      --发卡日期
    ,ENABLE_DT                       --启用日期
    ,CRD_EXP_DT                      --卡到期日期
    ,CNL_CRD_DT                      --销卡日期
    ,UNPAID_ANN_FEE_TOT              --未交年费总计
    ,CRD_CUR                         --卡片币别
    ,CRD_ISU_ORG_ID                  --发卡机构识别码
    ,CRD_CUR_TYP                     --卡片币种类型
    ,CRD_FACE_FLG                    --卡面标志
    ,CRD_MED                         --卡片介质
    ,ELEC_CASH_PAY_FCN_FLG           --电子现金支付功能标志
    ,PROD_NM                         --产品名称
    ,OPEN_CRD_TLR_NO                 --开卡柜员号
    ,CRD_AMT                         --卡金额
    ,VRTL_CRD_FLG                    --虚拟卡标志
    ,EMP_CRD_FLG                     --员工卡标志
    ,OPEN_CRD_DT                     --开卡日期
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,VOUCH_NO                        --凭证编号
    ,FINAL_ACTIV_ACCT_DT             --最后动户日期
    ,BAL                             --余额
    ,CARD_LEVEL_CD                   --卡等级代码
     )
  WITH TMP_DEF_CUST_ACCT AS
  (SELECT
    A.ETL_DT,A.LP_ID, A.CUST_ACCT_ID,A.CUST_ACCT_CARD_NO, A.CUST_ID, A.ACCT_STATUS_CD, A.ACCT_DRAWDOWN_WAY_STATUS,
    A.CLOS_ACCT_DT, A.ACCT_BELONG_ORG_ID, A.OPEN_ACCT_DT, A.JOB_CD, A.VOUCH_KIND_CD, A.OPEN_ACCT_TELLER_ID,
    A.TRAN_CHN_STATUS_CD,A.FROZ_STATUS_CD
  FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  --AND A.ACCT_TYPE_CD = '1' --一类户
  -- AND A.CUST_ACCT_ID LIKE '6%'
  AND (A.CLOS_ACCT_DT >= V_START_DT OR A.CLOS_ACCT_DT = DATE'0001-01-01') --modify by cxl 增加销户日期是默认值00010101的数据
  AND A.ACCT_TYPE_CD <> '2' --过滤不报送的2类户数据，根据跟区志豪商量，行里二类户有配卡的情况很少，先剔除2类户的，去掉是2类户是续卡的情况，然后在把二类户有实体卡的加回来
  AND NOT EXISTS (
    SELECT 1
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO I --存款分户基本信息
    WHERE I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND I.CUST_ACCT_ID LIKE '623688%'
      AND I.OPEN_ACCT_ORG_ID = '805011'
      AND I.CUST_ACCT_ID = A.CUST_ACCT_ID)
  UNION ALL
  /*二类户配实体卡数据*/
  SELECT A.ETL_DT, A.LP_ID, A.CUST_ACCT_ID,A.CUST_ACCT_CARD_NO, A.CUST_ID, A.ACCT_STATUS_CD, A.ACCT_DRAWDOWN_WAY_STATUS,
    A.CLOS_ACCT_DT, A.ACCT_BELONG_ORG_ID, A.OPEN_ACCT_DT, A.JOB_CD, A.VOUCH_KIND_CD,A.OPEN_ACCT_TELLER_ID,
    A.TRAN_CHN_STATUS_CD,A.FROZ_STATUS_CD
  FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A
  JOIN (SELECT DISTINCT CUST_ACCT_ID, START_DT FROM RRP_MDL.ADD_TWO_TYPE_ACT) B
  ON A.CUST_ACCT_ID = B.CUST_ACCT_ID
  AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE A.CUST_ACCT_ID LIKE '6%' AND (A.CLOS_ACCT_DT >= V_START_DT OR A.CLOS_ACCT_DT = DATE'0001-01-01')
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')      AS DATA_DT,       --数据日期
    A.LP_ID                            AS LGL_REP_ID,    --法人编号
    A.CARD_NO                          AS CRD_NO,        --卡号
    ROWNUM                             AS SN,            --序号  /**EAST5.0没用该字段，后续可根据需要来开发该字段*/
    B.ACCT_BELONG_ORG_ID               AS ORG_ID,        --机构编号
    B.CUST_ID                          AS CUST_ID,       --客户编号
    CASE WHEN A.CO_CARD_TYPE_CD = '0' THEN '1'        --借记卡
               WHEN A.CO_CARD_TYPE_CD = '1' THEN '2'  --贷记卡
          END                          AS CRD_CL,         --卡片种类
   -- A.CARD_TYPE_CD,                                      --卡状态   --取值可能有误
    TA.TAR_VALUE_CODE                   AS CRD_STAT,       --卡状态
   --  CASE WHEN TMP.ACCT_STATUS_CD = 'A' AND H.CUST_ACCT_ID IS NOT NULL THEN '06'
     --    WHEN TMP.ACCT_STATUS_CD = 'A' AND (TMP.ACCT_DRAWDOWN_WAY_STATUS ='-' OR TMP.FROZ_STATUS_CD IN ('1','2','3')) THEN '02'

      --   WHEN TMP.ACCT_STATUS_CD = 'A' AND TMP.ACCT_DRAWDOWN_WAY_STATUS IN ('A', 'I', 'C') THEN '03'
      --   WHEN TMP.ACCT_STATUS_CD = 'A' AND TMP.ACCT_DRAWDOWN_WAY_STATUS = '6' THEN '01'
      --   WHEN TMP.ACCT_STATUS_CD = 'A' AND TMP.TRAN_CHN_STATUS_CD = '3' THEN '07'
      --   WHEN TMP.ACCT_STATUS_CD = 'C' THEN '04'
     --    ELSE '99'
    --   END                               AS CRD_STAT,       --卡状态
    'N'                                AS SUP_CRD_FLG,    --副卡标志        EAST5.0没用该字段，后续可根据需要来开发该字段
    TO_CHAR(A.MAKE_CARD_DT,'YYYYMMDD') AS CRD_ISU_DT,     --发卡日期
    TO_CHAR(A.EFFECT_DT,'YYYYMMDD')    AS ENABLE_DT,      --启用日期
    TO_CHAR(A.INVALID_DT,'YYYYMMDD')   AS CRD_EXP_DT,     --卡到期日期
    --TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD'),
    CASE WHEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231')
         THEN '99991231'
       ELSE TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')
         END                           AS CNL_CRD_DT,              --销卡日期
    NULL                               AS UNPAID_ANN_FEE_TOT,      --未交年费总计
    NULL                               AS CRD_CUR,                 --卡片币别
    NULL                               AS CRD_ISU_ORG_ID,          --发卡机构识别码
    C.CURR_CD                          AS CRD_CUR_TYP,             --卡片币种类型
    A.CO_CARD_TYPE_CD                  AS CRD_FACE_FLG,            --卡面标志
    A.CARD_TYPE_CD                     AS CRD_MED,                 --卡片介质
    NULL                               AS ELEC_CASH_PAY_FCN_FLG,   --电子现金支付功能标志
    NVL(E1.CD_DESCB,'无')              AS PROD_NM,                 --产品名称
    B.OPEN_ACCT_TELLER_ID              AS OPEN_CRD_TLR_NO,         --开卡柜员号
    A.CURR_BAL                         AS CRD_AMT,                 --卡金额
    A.VTUAL_CARD_FLG                   AS VRTL_CRD_FLG,            --虚拟卡标志
    CASE WHEN K.CRDL_NO IS NOT NULL THEN 'Y' ELSE
      DECODE(F.GHB_EMPLY_FLG,'1','Y','0','N', 'N')
       END                             AS EMP_CRD_FLG,              --员工卡标志
    TO_CHAR(B.OPEN_ACCT_DT,'YYYYMMDD') AS OPEN_CRD_DT,             --开卡日期
    NULL                               AS DEPT_LINE,/*财富管理部*/   --部门条线
    '卡基本信息'                        AS DATA_SRC                  --数据来源
    ,A.VOUCH_NO                        AS VOUCH_NO                  --凭证号码
    ,TO_CHAR(C.FINAL_ACTIV_ACCT_DT,'YYYYMMDD')
                                       AS FINAL_ACTIV_ACCT_DT       --最后动户日期
    ,C.BAL                             AS BAL                       --余额
    ,A.CARD_LEVEL_CD                   AS CARD_LEVEL_CD             --卡等级代码
   FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A  --银行卡基本信息表
   LEFT JOIN  TMP_DEF_CUST_ACCT TMP
        ON A.CARD_NO = NVL(TMP.CUST_ACCT_CARD_NO,TMP.CUST_ACCT_ID)
   LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO B --存款账户信息表
             ON A.ETL_DT = B.ETL_DT
            --AND B.CUST_ACCT_ID LIKE '6%' --卡账户
            AND (A.CARD_NO = nvl(B.CUST_ACCT_CARD_NO,B.CUST_ACCT_ID))
      LEFT JOIN (
           SELECT CUST_ACCT_ID
                 ,MIN(SLEEP_ACCT_FLG) AS SLEEP_ACCT_FLG  --如果所有账户都在睡眠，则该卡为睡眠卡，反之则为活动卡
                 ,MAX(FINAL_ACTIV_ACCT_DT) AS FINAL_ACTIV_ACCT_DT  --最后动户日期
                 ,SUM(BAL) AS BAL
                 ,MIN(CURR_CD) CURR_CD
           FROM (
           SELECT A.CUST_ACCT_ID
                 ,MIN(A.SLEEP_ACCT_FLG) AS SLEEP_ACCT_FLG  --如果所有账户都在睡眠，则该卡为睡眠卡，反之则为活动卡
                 ,MAX(A.FINAL_ACTIV_ACCT_DT) AS FINAL_ACTIV_ACCT_DT  --最后动户日期
                 ,SUM(A.CL_CURR_CURRT_BAL) AS BAL
                 ,MAX(A.CURR_CD)  CURR_CD
           FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息表  --ADD BY WEIYONGZHAO 20220302 睡眠户标志、最后动户取自存款分户信息表
           WHERE A.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
            -- AND A.CUST_ACCT_ID LIKE '6%' --卡账户
           GROUP BY A.CUST_ACCT_ID
           ) T
           GROUP BY CUST_ACCT_ID
      ) C
       ON A.CARD_NO = C.CUST_ACCT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F   -- 个人客户基本信息
     ON B.CUST_ID = F.CUST_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_DEP_ACCT_INFO H
         ON A.CARD_NO = NVL(H.CUST_ACCT_ID,H.CUST_ACCT_CARD_NO)
         AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND H.FROZ_FLG = '1'
         AND H.CUST_ACCT_SUB_ACCT_NUM = '1'
    LEFT JOIN (SELECT DISTINCT CRDL_NO FROM RRP_MDL.M_PUM_EMP_INFO WHERE DATA_DT = V_P_DATE) K
     ON F.CERT_NO = K.CRDL_NO
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E1          --公共代码表  取借记卡产品名称
     ON E1.CD_VAL = B.VOUCH_KIND_CD  --新一代存款账户信息表先取的折再取的卡，调整为取卡
     AND E1.CD_ID = 'CD1315'
    LEFT JOIN CODE_MAP TA
         ON TA.SRC_VALUE_CODE = A.CARD_STATUS_CD
         AND TA.SRC_CLASS_CODE = 'CD2547'
         AND TA.TAR_CLASS_CODE = 'D0042'
         AND TA.MOD_FLG = 'MDM'
     WHERE A.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD');
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 增加数据重复校验 --
   -- 增加数据重复校验 --
        WITH TMP1 AS (
  SELECT DATA_DT,CRD_NO,VOUCH_NO,COUNT(1)
    FROM RRP_MDL.M_CRD_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CRD_NO,VOUCH_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
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
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CRD_INFO;
/

