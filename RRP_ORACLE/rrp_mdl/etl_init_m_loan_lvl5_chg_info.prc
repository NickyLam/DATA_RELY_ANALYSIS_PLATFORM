CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_LVL5_CHG_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_LVL5_CHG_INFO
  *  功能描述：贷款五级形态变动信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LVL5_CHG_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜     首次创建
  *             2    20220906  MW       增加审批员工号、授权员工号、调整员工号口径
  *             3    20221114  hulj     增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_LVL5_CHG_INFO'; -- 程序名称
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
  V_LAST_MONTH VARCHAR2(8); --上月
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_LVL5_CHG_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_MONTH := TO_CHAR(ADD_MONTHS(TO_DATE(V_P_DATE,'YYYYMMDD'),-1),'YYYYMMDD');  --上月
   SELECT  TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;
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
  V_STEP_DESC := '插入贷款五级形态变动信息--对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
  (
        DATA_DT  --数据日期
        ,LGL_REP_ID  --法人编号
        ,ORG_ID  --机构编号
        ,CONT_ID  --合同编号
        ,RCPT_ID  --借据编号
        ,ADJ_DT  --调整日期
        ,ORIG_LVL5_CL  --原五级分类
        ,CURR_LVL5_CL  --现五级分类
        ,CUR  --币种
        ,TRF_IN_AMT  --转入金额
        ,TFR_OUT_AMT  --转出金额
        ,HDLR_NO  --经办人工号
        ,ADJ_EMP_NO  --调整员工号
        ,GRANT_EMP_NO  --授权员工号
        ,APRV_EMP_NO  --审批员工号
        ,CHG_RSN  --变动原因
        ,CHG_MODE  --变动方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
      )
      SELECT
          V_P_DATE                                                                     AS DATA_DT        -- 数据日期
         ,A.LP_ID                                                                      AS LGL_REP_ID     -- 法人编号
         ,A.OPEN_ACCT_ORG_ID                                                           AS ORG_ID         -- 机构编号
         ,A.CONT_ID                                                                    AS CONT_ID        -- 合同编号
         ,A.DUBIL_NUM                                                                  AS RCPT_ID        -- 借据编号
         ,CASE WHEN H.CLASSIFYDATE IS NOT NULL THEN TO_CHAR(H.CLASSIFYDATE,'YYYYMMDD')
               WHEN B.LEVEL5_CLS_IDTFY_DT IS NOT NULL THEN TO_CHAR(B.LEVEL5_CLS_IDTFY_DT,'YYYYMMDD')
               ELSE V_P_DATE END                                                       AS ADJ_DT         -- 调整日期
         ,E.TAR_VALUE_CODE                                                             AS ORIG_LVL5_CL   -- 原五级分类
         ,F.TAR_VALUE_CODE                                                             AS CURR_LVL5_CL   -- 现五级分类
         ,NULL                                                                         AS CUR            -- 币种
         ,NULL                                                                         AS TRF_IN_AMT     -- 转入金额
         ,NULL                                                                         AS TFR_OUT_AMT    -- 转出金额
         ,NVL(I.CLERK_ID,A.CUST_MGR_ID)                                                AS HDLR_NO        -- 经办人工号
         ,H.ADJ_EMPLY_NUM                                                             AS ADJ_EMP_NO     -- 调整员工号
         ,H.AUTH_EMPLY_NUM                                                             AS GRANT_EMP_NO   -- 授权员工号
         ,H.APRV_EMPLY_NUM                                                             AS APRV_EMP_NO    -- 审批员工号
         ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN SUBSTRB(TRIM(H.REMARK),1,30)
               ELSE '系统自动评定'
           END                                                                         AS CHG_RSN        -- 变动原因
         ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN '01'
               ELSE '02'
           END                                                                         AS CHG_MODE       -- 变动方式
         ,'800919'   /*风险管理部*/                                                    AS DEPT_LINE      -- 部门条线
         ,'对公信贷'                                                                    AS DATA_SRC       -- 数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A  --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B--对公贷款借据信息 本月
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C--对公贷款借据信息 上月
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.ETL_DT = TO_DATE(V_LAST_MONTH,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E  --码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP F  --码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN (SELECT  CR.LOAN_ACCT_ID
                      ,MAX(CR.RAT_DT) AS CLASSIFYDATE
                      ,MAX(CR.LOAN_FIFTH_MODAL_CHG_RSNS ) AS REMARK
                      ,MAX(CR.ADJ_EMPLY_NUM) AS ADJ_EMPLY_NUM
                      ,MAX(CR.AUTH_EMPLY_NUM) AS AUTH_EMPLY_NUM
                      ,MAX(CR.APRV_EMPLY_NUM) AS APRV_EMPLY_NUM
                 FROM RRP_MDL.O_IOL_RCDS_SRC_DW_AGT_CMS_RISK_RAT CR  --信贷风险评级
                WHERE CR.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY CR.LOAN_ACCT_ID
                 ) H --风险分类记录
      ON A.ACCT_ID = H.LOAN_ACCT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO G --对公贷款合同信息
      ON G.CONT_ID = B.CONT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO I  --行员信息表
      ON CASE WHEN I.TELLER_ID = '01207' AND I.CLERK_ID ='01060180' THEN NULL
              ELSE I.TELLER_ID END = TRIM(G.MGMT_TELLER_ID)
     AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
   /*and (B.BUS_BREED_ID LIKE '1%' OR B.BUS_BREED_ID LIKE '2070%' OR B.BUS_BREED_ID IS NULL OR B.BUS_BREED_ID IN ('203020112','203020210','4030010020')
         OR G.BUS_BREED_ID LIKE '1%' OR G.BUS_BREED_ID LIKE '2070%' OR G.BUS_BREED_ID IS NULL OR B.BUS_BREED_ID IN ('203020112','203020210','4030010020'))
        AND (A.OPEN_ACCT_DT <> A.CLOS_ACCT_DT
         --加入203020112-二级福费廷 203020210-二级福费廷 4030010020-同业间福费廷 3个业务品种
         OR (A.OPEN_ACCT_DT = A.CLOS_ACCT_DT AND NVL(B.BUS_BREED_ID,G.BUS_BREED_ID) IN ('1060080','203020112','203020210','4030010020'))
          )*/
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入贷款五级形态变动信息--零售';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
  (
        DATA_DT  --数据日期
        ,LGL_REP_ID  --法人编号
        ,ORG_ID  --机构编号
        ,CONT_ID  --合同编号
        ,RCPT_ID  --借据编号
        ,ADJ_DT  --调整日期
        ,ORIG_LVL5_CL  --原五级分类
        ,CURR_LVL5_CL  --现五级分类
        ,CUR  --币种
        ,TRF_IN_AMT  --转入金额
        ,TFR_OUT_AMT  --转出金额
        ,HDLR_NO  --经办人工号
        ,ADJ_EMP_NO  --调整员工号
        ,GRANT_EMP_NO  --授权员工号
        ,APRV_EMP_NO  --审批员工号
        ,CHG_RSN  --变动原因
        ,CHG_MODE  --变动方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
      )
      SELECT DISTINCT
           V_P_DATE                                                                AS DATA_DT        -- 数据日期
         ,A.LP_ID                                                                 AS LGL_REP_ID     -- 法人编号
         ,A.OPEN_ACCT_ORG_ID                                                      AS ORG_ID         -- 机构编号
         ,A.CONT_ID                                                               AS CONT_ID        -- 合同编号
         ,A.DUBIL_NUM                                                             AS RCPT_ID        -- 借据编号
         ,NVL(TO_CHAR(B.LOAN_LEVEL5_CLS_DT,'YYYYMMDD'),V_P_DATE)                  AS ADJ_DT         -- 调整日期
         ,E.TAR_VALUE_CODE                                                        AS ORIG_LVL5_CL   -- 原五级分类
         ,F.TAR_VALUE_CODE                                                        AS CURR_LVL5_CL   -- 现五级分类
         ,NULL                                                                    AS CUR            -- 币种
         ,NULL                                                                    AS TRF_IN_AMT     -- 转入金额
         ,NULL                                                                    AS TFR_OUT_AMT    -- 转出金额
         ,NVL(TRIM(B.CUST_MGR_ID),D.RAT_OPER_EMPLY_ID)                           AS HDLR_NO        -- 经办人工号
         ,NULL                                                                    AS ADJ_EMP_NO     -- 调整员工号
         ,NULL                                                                    AS GRANT_EMP_NO   -- 授权员工号
         ,NULL                                                                    AS APRV_EMP_NO    -- 审批员工号
         ,NVL(SUBSTRB(TRIM(D.LOAN_FIFTH_MODAL_CHG_RSNS),1,30),'系统自动评定')          AS CHG_RSN        -- 变动原因
         --,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) ='2' THEN '02' ELSE '01' END AS CHG_MODE       -- 变动方式
         ,CASE WHEN NVL(SUBSTRB(TRIM(D.LOAN_FIFTH_MODAL_CHG_RSNS),1,30),'系统自动评定') = '系统自动评定' THEN '02' ELSE '01' END AS CHG_MODE       -- 变动方式
         ,'800924'   /*零售信贷部(普惠金融部)*/                                   AS DEPT_LINE      -- 部门条线
         ,'零售贷款'                                                               AS DATA_SRC       -- 数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A  --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B--零售贷款借据信息 本月
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO C--零售贷款借据信息 上月
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.ETL_DT = TO_DATE(V_LAST_MONTH,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IOL_RCDS_SRC_DW_AGT_CMS_RISK_RAT D  --数仓_信贷风险评级
     ON D.LOAN_ACCT_ID = A.ACCT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E  --数仓码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP F  --数仓码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'            --监管集市明细层
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND (A.CLOS_ACCT_DT >= V_MONTH_START_DATE OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入贷款五级形态变动信息--联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
  (
        DATA_DT  --数据日期
        ,LGL_REP_ID  --法人编号
        ,ORG_ID  --机构编号
        ,CONT_ID  --合同编号
        ,RCPT_ID  --借据编号
        ,ADJ_DT  --调整日期
        ,ORIG_LVL5_CL  --原五级分类
        ,CURR_LVL5_CL  --现五级分类
        ,CUR  --币种
        ,TRF_IN_AMT  --转入金额
        ,TFR_OUT_AMT  --转出金额
        ,HDLR_NO  --经办人工号
        ,ADJ_EMP_NO  --调整员工号
        ,GRANT_EMP_NO  --授权员工号
        ,APRV_EMP_NO  --审批员工号
        ,CHG_RSN  --变动原因
        ,CHG_MODE  --变动方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
      )
      SELECT DISTINCT
          V_P_DATE                           AS DATA_DT        -- 数据日期
         ,A.LP_ID                            AS LGL_REP_ID     -- 法人编号
         ,A.ACCT_INSTIT_ID                   AS ORG_ID         -- 机构编号
         ,A.DUBIL_ID                         AS CONT_ID        -- 合同编号
         ,A.DUBIL_ID                         AS RCPT_ID        -- 借据编号
         ,NVL(TO_CHAR(A.ETL_DT-1,'YYYYMMDD'),V_P_DATE)        AS ADJ_DT         -- 调整日期
         ,E.TAR_VALUE_CODE                   AS ORIG_LVL5_CL   -- 原五级分类
         ,F.TAR_VALUE_CODE                   AS CURR_LVL5_CL   -- 现五级分类
         ,NULL                               AS CUR            -- 币种
         ,NULL                               AS TRF_IN_AMT     -- 转入金额
         ,NULL                               AS TFR_OUT_AMT    -- 转出金额
         ,TRIM(A.CUST_MGR_ID)                AS HDLR_NO        -- 经办人工号
         ,NULL                               AS ADJ_EMP_NO     -- 调整员工号
         ,NULL                               AS GRANT_EMP_NO   -- 授权员工号
         ,NULL                               AS APRV_EMP_NO    -- 审批员工号
         ,'系统自动评定'                      AS CHG_RSN        -- 变动原因
         ,'02'                               AS CHG_MODE       -- 变动方式
         ,'800924'   /*零售信贷部(普惠金融部)*/AS DEPT_LINE      -- 部门条线
         ,'联合网贷'                          AS DATA_SRC       -- 数据来源
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A  --联合网贷借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B--联合网贷借据信息 上月
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_LAST_MONTH,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E  --数仓码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP F  --数仓码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'            --监管集市明细层
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND  (((A.PAYOFF_DT >= V_MONTH_START_DATE OR A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD'))
            AND NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0)>0)
         OR ((A.LAST_REPAY_DT >= V_MONTH_START_DATE - 1 OR A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD'))
            AND NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0)>0)
            OR NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0)>0)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


         -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CONT_ID,RCPT_ID,COUNT(1)
      FROM M_LOAN_LVL5_CHG_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CONT_ID,RCPT_ID
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

  END ETL_INIT_M_LOAN_LVL5_CHG_INFO;
/

