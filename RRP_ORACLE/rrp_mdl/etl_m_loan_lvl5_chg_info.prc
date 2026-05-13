CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_LVL5_CHG_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_LVL5_CHG_INFO
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
  *             4    20240730  LIP      调整对公部分调整原因取数
  *             5    20241025  LIP      调整对公信贷零售部分调整原因取数
  *             6    20250217  YJY      新增对公联合网贷的判断
  *             7    20250408  XZY      一表通增加APRV_EMP_NO审批员工号逻辑 、修改币种取数逻辑
  *             8    20250521  YJY      修改联合网贷部分的借据号，取联合网贷借据表的核心借据编号
  *             9    20250619  LIP      将过程调整成日批增量
  *            10    20250725  YJY      回退联合网贷部分的借据号
  *            11    20250829  YJY      调整‘变动原因’字段，由于一表通不限制字段长度，现取消截取字段长度
  *            12    20251120  YJY      新增203050100002-微众对公联合贷（微业贷4.0）产品
  *            13    20260410  HML      应张家伟要求，修改零售模块变动方式，变动原因，经办和审批员工取数				
  ***********************************************************************/
AS
  -- 定义变量 --
  V_P_DATE     VARCHAR2(8);               --跑批数据日期
  V_STARTTIME  DATE;                      --处理开始时间
  V_ENDTIME    DATE;                      --处理结束时间
  V_SQLMSG     VARCHAR2(300);             --SQL执行描述信息
  V_STEP_DESC  VARCHAR2(200);             --任务名称
  V_PART_NAME  VARCHAR2(100);             --分区名
  V_STEP       INTEGER := 0;              --处理步骤
  V_SQLCOUNT   INTEGER := 0;              --更新或删除影响的记录数
  V_MONTH_START_DATE DATE;                --系统时间对应月初日期
  V_PROC_NAME  VARCHAR2(100) := 'ETL_M_LOAN_LVL5_CHG_INFO'; --程序名称
  V_TAB_NAME   VARCHAR2(100) := 'M_LOAN_LVL5_CHG_INFO'; --表名
  V_SYSTEM     VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'MM');

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_LVL5_CHG_INFO T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_LOAN_LVL5_CHG_INFO'||' TRUNCATE PARTITION '||'写上分区名'); --分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
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

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款五级形态变动信息--对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ORG_ID           --机构编号
    ,CONT_ID          --合同编号
    ,RCPT_ID          --借据编号
    ,ADJ_DT           --调整日期
    ,ORIG_LVL5_CL     --原五级分类
    ,CURR_LVL5_CL     --现五级分类
    ,CUR              --币种
    ,TRF_IN_AMT       --转入金额
    ,TFR_OUT_AMT      --转出金额
    ,HDLR_NO          --经办人工号
    ,ADJ_EMP_NO       --调整员工号
    ,GRANT_EMP_NO     --授权员工号
    ,APRV_EMP_NO      --审批员工号
    ,CHG_RSN          --变动原因
    ,CHG_MODE         --变动方式
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  WITH RISK_CHG_REASON AS (
        SELECT /*+MATERIALIZE*/TA.OBJECTNO,TA.INPUTDATE,T.TYPE,T.CUSTOMERID,T.CUSTOMERNAME,
               CASE WHEN T.TYPE = '0010' THEN TB.ADJUSTREASON --0010 评级模型调整法+核心定义法
                    WHEN T.TYPE = '0020' THEN TB.BUSINESSDESCRIBE --0020 直接认定
                END REMARK,TB.INPUTUSERID,TO_CHAR(TO_DATE(TRIM(T.UPDATEDATE),'YYYY-MM-DD'),'YYYYMMDD') UPDATEDATE,
               ROW_NUMBER() OVER(PARTITION BY TA.OBJECTNO ORDER BY TA.INPUTDATE DESC) RN
          FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_APPLY T
         INNER JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TA
            ON TA.SERIALNO = T.SERIALNO
           AND TA.OBJECTTYPE = 'DueBill'
           AND TA.ID_MARK <> 'D'
           AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
          LEFT JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TB
            ON TB.SERIALNO = T.SERIALNO
           AND TB.OBJECTTYPE = 'RelativeKernel'
           AND TB.ID_MARK <> 'D'
           AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         WHERE T.APPROVESTATUS = 'Finished'
           AND T.ID_MARK <> 'D'
           AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  RISK_ADJ_REASON AS (
        SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.OBJECTNO ORDER BY T.ADJUSTFINISHDATE DESC) RN
          FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST T
         WHERE T.OBJECTTYPE = 'BusinessDuebill'
           AND T.ID_MARK <> 'D'
           AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A B C RRI) LEADING(A)*/
         V_P_DATE                                           AS DATA_DT        --数据日期
        ,A.LP_ID                                            AS LGL_REP_ID     --法人编号
        ,A.OPEN_ACCT_ORG_ID                                 AS ORG_ID         --机构编号
        ,A.CONT_ID                                          AS CONT_ID        --合同编号
        ,A.DUBIL_NUM                                        AS RCPT_ID        --借据编号
        ,CASE WHEN B.LEVEL5_CLS_IDTFY_DT IS NOT NULL THEN TO_CHAR(B.LEVEL5_CLS_IDTFY_DT,'YYYYMMDD')
              WHEN TRIM(H.UPDATEDATE) IS NOT NULL THEN H.UPDATEDATE
              WHEN TRIM(I.ADJUSTFINISHDATE) IS NOT NULL THEN TO_CHAR(I.ADJUSTFINISHDATE,'YYYYMMDD')
              ELSE V_P_DATE
          END                                               AS ADJ_DT         --调整日期
        ,E.TAR_VALUE_CODE                                   AS ORIG_LVL5_CL   --原五级分类
        ,F.TAR_VALUE_CODE                                   AS CURR_LVL5_CL   --现五级分类
        --MODIFY BY XIEZY 20250409 修改币种取数逻辑,B表长度10，避免风险截取3位
        ,SUBSTR(B.CURR_CD,1,3)                              AS CUR            --币种
        ,NULL                                               AS TRF_IN_AMT     --转入金额
        ,NULL                                               AS TFR_OUT_AMT    --转出金额
        /*,NVL(I.CLERK_ID,A.CUST_MGR_ID)                      AS HDLR_NO        --经办人工号
        ,H.ADJ_EMPLY_NUM                                    AS ADJ_EMP_NO     --调整员工号
        ,H.AUTH_EMPLY_NUM                                   AS GRANT_EMP_NO   --授权员工号
        ,H.APRV_EMPLY_NUM                                   AS APRV_EMP_NO    --审批员工号*/
        --MOD BY LIP 20240730
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.OPERATEUSERID))     AS HDLR_NO        --经办人工号
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.UPDATEUSERID))      AS ADJ_EMP_NO     --调整员工号
        ,NULL                                               AS GRANT_EMP_NO   --授权员工号
        --MODIFY BY XIEZY 20250409 取审批员工号
        ,RRI.APV_CLERK_ID                                   AS APRV_EMP_NO    --审批员工号        
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN /*SUBSTRB(TRIM(H.REMARK),1,30)*/ TRIM(H.REMARK)
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN /*SUBSTRB(TRIM(I.ADJUSTREASON),1,30)*/ TRIM(I.ADJUSTREASON) 
              ELSE '系统自动评定' 
          END                                               AS CHG_RSN        --变动原因 --MOD BY YJY 20250829 由于一表通不限制字段长度，取消截取字段长度
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN '01'
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN '01'
              ELSE '02'
          END                                               AS CHG_MODE       --变动方式
        ,'800919'                                           AS DEPT_LINE      --部门条线 /*风险管理部*/
        ,'对公信贷'                                         AS DATA_SRC       --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息 本月
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C --对公贷款借据信息 上日--上月
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY LIP 20250619 改成取与上日比对的调整结果
    LEFT JOIN RRP_MDL.O_ICL_CMM_CRDT_RISK_RATING_INFO RRI --信贷风险评级信息 ADD BY XIEZY 20250409 取审批员工号
      ON RRI.DUBIL_ID = A.DUBIL_NUM
     AND RRI.RATING_CATE_CD = '2'
     AND RRI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E --码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP F --码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'
    /*LEFT JOIN (SELECT CR.LOAN_ACCT_ID
                     ,MAX(CR.RAT_DT) AS CLASSIFYDATE
                     ,MAX(CR.LOAN_FIFTH_MODAL_CHG_RSNS) AS REMARK
                     ,MAX(CR.ADJ_EMPLY_NUM) AS ADJ_EMPLY_NUM
                     ,MAX(CR.AUTH_EMPLY_NUM) AS AUTH_EMPLY_NUM
                     ,MAX(CR.APRV_EMPLY_NUM) AS APRV_EMPLY_NUM
                 FROM RRP_MDL.O_IOL_RCDS_SRC_DW_AGT_CMS_RISK_RAT CR --信贷风险评级
                WHERE CR.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY CR.LOAN_ACCT_ID) H --风险分类记录
      ON H.LOAN_ACCT_ID = A.ACCT_ID*/
    LEFT JOIN RISK_CHG_REASON H --ADD BY LIP 20240730
      ON H.OBJECTNO = A.DUBIL_NUM
     AND H.RN = 1
    LEFT JOIN RISK_ADJ_REASON I
      ON I.OBJECTNO = A.DUBIL_NUM
     AND I.RN = 1
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款五级形态变动信息--零售';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ORG_ID           --机构编号
    ,CONT_ID          --合同编号
    ,RCPT_ID          --借据编号
    ,ADJ_DT           --调整日期
    ,ORIG_LVL5_CL     --原五级分类
    ,CURR_LVL5_CL     --现五级分类
    ,CUR              --币种
    ,TRF_IN_AMT       --转入金额
    ,TFR_OUT_AMT      --转出金额
    ,HDLR_NO          --经办人工号
    ,ADJ_EMP_NO       --调整员工号
    ,GRANT_EMP_NO     --授权员工号
    ,APRV_EMP_NO      --审批员工号
    ,CHG_RSN          --变动原因
    ,CHG_MODE         --变动方式
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  SELECT /*+LEADING(C) USE_HASH(A,B,C,RRI,E,F) LEADING(A)*/ DISTINCT
         V_P_DATE                                                                AS DATA_DT        --数据日期
        ,A.LP_ID                                                                 AS LGL_REP_ID     --法人编号
        ,A.OPEN_ACCT_ORG_ID                                                      AS ORG_ID         --机构编号
        ,A.CONT_ID                                                               AS CONT_ID        --合同编号
        ,A.DUBIL_NUM                                                             AS RCPT_ID        --借据编号
        ,NVL(TO_CHAR(B.LOAN_LEVEL5_CLS_DT,'YYYYMMDD'),V_P_DATE)                  AS ADJ_DT         --调整日期
        ,E.TAR_VALUE_CODE                                                        AS ORIG_LVL5_CL   --原五级分类
        ,F.TAR_VALUE_CODE                                                        AS CURR_LVL5_CL   --现五级分类
        ,SUBSTR(B.CURR_CD,1,3)                                                   AS CUR            --币种 --MODIFY BY XIEZY 20250409 修改币种取数逻辑,B表长度10，避免风险截取3位
        ,NULL                                                                    AS TRF_IN_AMT     --转入金额
        ,NULL                                                                    AS TFR_OUT_AMT    --转出金额
        --,NVL(TRIM(B.CUST_MGR_ID),D.RAT_OPER_EMPLY_ID)                          AS HDLR_NO        --经办人工号
        --,NVL(TRIM(B.RISK_RGST_APVER_ID),TRIM(B.CUST_MGR_ID))                   AS HDLR_NO        --经办人工号 --MOD BY 20240418 变动原因从信贷系统取数	
        ,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) = '1' THEN NVL(TRIM(B.RISK_RGST_APVER_ID),TRIM(B.CUST_MGR_ID)) 
          ELSE NULL END                                                      AS HDLR_NO  --经办人工号 -- modify by huangml 20260410
    ,NULL                                                                    AS ADJ_EMP_NO     --调整员工号
        ,NULL                                                                    AS GRANT_EMP_NO   --授权员工号
        --MODIFY BY XIEZY 20250409 取审批员工号
        ,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) = '1' THEN RRI.APV_CLERK_ID 
        ELSE NULL END                                                        AS APRV_EMP_NO    --审批员工号-- modify by huangml 20260410
        /*,NVL(SUBSTRB(TRIM(D.LOAN_FIFTH_MODAL_CHG_RSNS),1,30),'系统自动评定')     AS CHG_RSN        --变动原因
        --,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) = '2' THEN '02' ELSE '01' END AS CHG_MODE       --变动方式
        ,CASE WHEN NVL(SUBSTRB(TRIM(D.LOAN_FIFTH_MODAL_CHG_RSNS),1,30),'系统自动评定') = '系统自动评定' THEN '02' ELSE '01' END AS CHG_MODE       -- 变动方式*/
        --MOD BY 20240418 变动原因从信贷系统取数
        --,NVL(SUBSTRB(TRIM(B.LAST_RISK_RGST_ADJ_RS),1,30),'系统自动评定')         AS CHG_RSN        --变动原因 --MOD BY YJY 20250829 由于一表通不限制字段长度，取消截取字段长度
        ,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) = '1' THEN TRIM(B.LAST_RISK_RGST_ADJ_RS) 
          ELSE '系统自动评定' END                                              AS CHG_RSN        --变动原因 --MOD BY HUANGML 20260410
        /*张家伟反馈，五级分类变动如果人工审批流程没有走完，就不能算人工变动，找科技柯东煜调研反馈,
        BUSINESS_DUEBILL .TENCLAIND字段如果是人工变动，一定会有是1，huangml 20260410*/
    ,CASE WHEN TRIM(B.LEVEL10_CLS_MANU_MED_FLG) = '1' THEN '01' 
          ELSE '02' END                                                       AS CHG_MODE       --变动方式 
    /*,CASE WHEN NVL(SUBSTRB(TRIM(B.LAST_RISK_RGST_ADJ_RS),1,30),'系统自动评定') = '系统自动评定' 
              THEN '02' 
              ELSE '01'
          END                                                                    AS CHG_MODE       -- 变动方式*/

        ,'800924'                                                                AS DEPT_LINE      --部门条线 /*零售信贷部(普惠金融部)*/
        ,'零售贷款'                                                              AS DATA_SRC       --数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息 本月
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO C --零售贷款借据信息 上日--上月
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY LIP 20250619 改成取与上日比对的调整结果
    LEFT JOIN RRP_MDL.O_ICL_CMM_CRDT_RISK_RATING_INFO RRI --信贷风险评级信息 ADD BY XIEZY 20250409 取审批员工号
      ON RRI.DUBIL_ID = A.DUBIL_NUM
     AND RRI.RATING_CATE_CD = '2'
     AND RRI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E --数仓码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP F --数仓码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND (A.CLOS_ACCT_DT >= V_MONTH_START_DATE OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) > 0)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款五级形态变动信息--联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ORG_ID           --机构编号
    ,CONT_ID          --合同编号
    ,RCPT_ID          --借据编号
    ,ADJ_DT           --调整日期
    ,ORIG_LVL5_CL     --原五级分类
    ,CURR_LVL5_CL     --现五级分类
    ,CUR              --币种
    ,TRF_IN_AMT       --转入金额
    ,TFR_OUT_AMT      --转出金额
    ,HDLR_NO          --经办人工号
    ,ADJ_EMP_NO       --调整员工号
    ,GRANT_EMP_NO     --授权员工号
    ,APRV_EMP_NO      --审批员工号
    ,CHG_RSN          --变动原因
    ,CHG_MODE         --变动方式
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  SELECT /*+ USE_HASH(A,B,RRI) LEADING(A) */DISTINCT
         V_P_DATE                                     AS DATA_DT        --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID     --法人编号
        ,A.ACCT_INSTIT_ID                             AS ORG_ID         --机构编号
        ,A.DUBIL_ID                                   AS CONT_ID        --合同编号
        /*,A.DUBIL_ID                                   AS RCPT_ID        --借据编号*/
        /*,A.CORE_DUBIL_ID                              AS RCPT_ID        --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号*/
        ,A.DUBIL_ID                                   AS RCPT_ID        --借据编号 MOD BY YJY 20250725
        ,NVL(TO_CHAR(A.ETL_DT-1,'YYYYMMDD'),V_P_DATE) AS ADJ_DT         --调整日期
        ,E.TAR_VALUE_CODE                             AS ORIG_LVL5_CL   --原五级分类
        ,F.TAR_VALUE_CODE                             AS CURR_LVL5_CL   --现五级分类
        ,SUBSTR(A.CURR_CD,1,3)                        AS CUR            --币种  --MODIFY BY XIEZY 20250409 修改币种取数逻辑,B表长度10，避免风险截取3位
        ,NULL                                         AS TRF_IN_AMT     --转入金额
        ,NULL                                         AS TFR_OUT_AMT    --转出金额
        ,TRIM(A.CUST_MGR_ID)                          AS HDLR_NO        --经办人工号
        ,NULL                                         AS ADJ_EMP_NO     --调整员工号
        ,NULL                                         AS GRANT_EMP_NO   --授权员工号
        ,NULL                                         AS APRV_EMP_NO    --审批员工号
        --MODIFY BY XIEZY 20250409 取审批员工号
        --,RRI.APV_CLERK_ID                             AS APRV_EMP_NO    --审批员工号
        ,'系统自动评定'                               AS CHG_RSN        --变动原因
        ,'02'                                         AS CHG_MODE       --变动方式
        ,'800924'                                     AS DEPT_LINE      --部门条线 /*零售信贷部(普惠金融部)*/
        ,CASE WHEN A.STD_PROD_ID IN ('203050100001','203050100002') THEN '对公联合网贷' --MOD BY YJY 20250217 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE '联合网贷'
         END                                          AS DATA_SRC       --数据来源
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B --联合网贷借据信息 上日--上月
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY LIP 20250619 改成取与上日比对的调整结果
    --联合网贷数据不在该表中
    /*LEFT JOIN RRP_MDL.O_ICL_CMM_CRDT_RISK_RATING_INFO RRI --信贷风险评级信息 ADD BY XIEZY 20250409 取审批员工号
      ON RRI.DUBIL_ID = A.DUBIL_ID
     AND RRI.RATING_CATE_CD = '2'
     AND RRI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN RRP_MDL.CODE_MAP E --数仓码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP F --数仓码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款五级形态变动信息--对公-本月表内上月表外';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ORG_ID           --机构编号
    ,CONT_ID          --合同编号
    ,RCPT_ID          --借据编号
    ,ADJ_DT           --调整日期
    ,ORIG_LVL5_CL     --原五级分类
    ,CURR_LVL5_CL     --现五级分类
    ,CUR              --币种
    ,TRF_IN_AMT       --转入金额
    ,TFR_OUT_AMT      --转出金额
    ,HDLR_NO          --经办人工号
    ,ADJ_EMP_NO       --调整员工号
    ,GRANT_EMP_NO     --授权员工号
    ,APRV_EMP_NO      --审批员工号
    ,CHG_RSN          --变动原因
    ,CHG_MODE         --变动方式
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  WITH RISK_CHG_REASON AS (
  SELECT /*+MATERIALIZE*/TA.OBJECTNO,TA.INPUTDATE,T.TYPE,T.CUSTOMERID,T.CUSTOMERNAME,
         CASE WHEN T.TYPE = '0010' THEN TB.ADJUSTREASON --0010 评级模型调整法+核心定义法
              WHEN T.TYPE = '0020' THEN TB.BUSINESSDESCRIBE --0020 直接认定
          END REMARK,TB.INPUTUSERID,TO_CHAR(TO_DATE(TRIM(T.UPDATEDATE),'YYYY-MM-DD'),'YYYYMMDD') UPDATEDATE,
         ROW_NUMBER() OVER(PARTITION BY TA.OBJECTNO ORDER BY TA.INPUTDATE DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_APPLY T
   INNER JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TA
      ON TA.SERIALNO = T.SERIALNO
     AND TA.OBJECTTYPE = 'DueBill'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TB
      ON TB.SERIALNO = T.SERIALNO
     AND TB.OBJECTTYPE = 'RelativeKernel'
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.APPROVESTATUS = 'Finished'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  RISK_ADJ_REASON AS (
  SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.OBJECTNO ORDER BY T.ADJUSTFINISHDATE DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST T
   WHERE T.OBJECTTYPE = 'BusinessDuebill'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,B,C,RRI) LEADING(B,C) */
         V_P_DATE                                           AS DATA_DT        --数据日期
        ,A.LP_ID                                            AS LGL_REP_ID     --法人编号
        ,A.OPEN_ACCT_ORG_ID                                 AS ORG_ID         --机构编号
        ,A.CONT_ID                                          AS CONT_ID        --合同编号
        ,A.DUBIL_NUM                                        AS RCPT_ID        --借据编号
        ,CASE WHEN B.LEVEL5_CLS_IDTFY_DT IS NOT NULL THEN TO_CHAR(B.LEVEL5_CLS_IDTFY_DT,'YYYYMMDD')
              WHEN TRIM(H.UPDATEDATE) IS NOT NULL THEN H.UPDATEDATE
              WHEN TRIM(I.ADJUSTFINISHDATE) IS NOT NULL THEN TO_CHAR(I.ADJUSTFINISHDATE,'YYYYMMDD')
              ELSE V_P_DATE
          END                                               AS ADJ_DT         --调整日期
        ,E.TAR_VALUE_CODE                                   AS ORIG_LVL5_CL   --原五级分类
        ,F.TAR_VALUE_CODE                                   AS CURR_LVL5_CL   --现五级分类
        ,SUBSTR(A.CURR_CD,1,3)                              AS CUR            --币种 MODIFY BY XIEZY 20250409
        ,NULL                                               AS TRF_IN_AMT     --转入金额
        ,NULL                                               AS TFR_OUT_AMT    --转出金额
        /*,NVL(I.CLERK_ID,A.CUST_MGR_ID)                      AS HDLR_NO        --经办人工号
        ,H.ADJ_EMPLY_NUM                                    AS ADJ_EMP_NO     --调整员工号
        ,H.AUTH_EMPLY_NUM                                   AS GRANT_EMP_NO   --授权员工号
        ,H.APRV_EMPLY_NUM                                   AS APRV_EMP_NO    --审批员工号*/
        --MOD BY LIP 20240730
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.OPERATEUSERID))     AS HDLR_NO        --经办人工号
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.UPDATEUSERID))      AS ADJ_EMP_NO     --调整员工号
        ,NULL                                               AS GRANT_EMP_NO   --授权员工号
        --MODIFY BY XIEZY 20250409 取审批员工号
        ,RRI.APV_CLERK_ID                                   AS APRV_EMP_NO    --审批员工号
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN /*SUBSTRB(TRIM(H.REMARK),1,30)*/ TRIM(H.REMARK)
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN /*SUBSTRB(TRIM(I.ADJUSTREASON),1,30)*/ TRIM(I.ADJUSTREASON)
              ELSE '系统自动评定'
          END                                               AS CHG_RSN        --变动原因 --MOD BY YJY 20250829 由于一表通不限制字段长度，取消截取字段长度
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN '01'
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN '01'
              ELSE '02'
          END                                               AS CHG_MODE       --变动方式
        ,'800919'                                           AS DEPT_LINE      --部门条线 /*风险管理部*/
        ,'对公信贷-上月表外'                                AS DATA_SRC       --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息 本月
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.DISTR_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --这个月发放的
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C --对公贷款借据信息 上日--上月
      ON C.DUBIL_ID = TRIM(B.RELA_DUBIL_ID)
     --AND C.ETL_DT = TO_DATE(V_LAST_MONTH,'YYYYMMDD')
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY LIP 20250619 改成取与上日比对的调整结果
    LEFT JOIN RRP_MDL.O_ICL_CMM_CRDT_RISK_RATING_INFO RRI --信贷风险评级信息 ADD BY XIEZY 20250409 取审批员工号
      ON RRI.DUBIL_ID = A.DUBIL_NUM
     AND RRI.RATING_CATE_CD = '2'
     AND RRI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E --码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP F --码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RISK_CHG_REASON H --ADD BY LIP 20240730
      ON H.OBJECTNO = A.DUBIL_NUM
     AND H.RN = 1
    LEFT JOIN RISK_ADJ_REASON I --ADD BY LIP 20241025
      ON I.OBJECTNO = A.DUBIL_NUM
     AND I.RN = 1
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240516 增加票据等核心中不存在的借据数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款五级形态变动信息--对公-核心中不存在的借据数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LVL5_CHG_INFO
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ORG_ID           --机构编号
    ,CONT_ID          --合同编号
    ,RCPT_ID          --借据编号
    ,ADJ_DT           --调整日期
    ,ORIG_LVL5_CL     --原五级分类
    ,CURR_LVL5_CL     --现五级分类
    ,CUR              --币种
    ,TRF_IN_AMT       --转入金额
    ,TFR_OUT_AMT      --转出金额
    ,HDLR_NO          --经办人工号
    ,ADJ_EMP_NO       --调整员工号
    ,GRANT_EMP_NO     --授权员工号
    ,APRV_EMP_NO      --审批员工号
    ,CHG_RSN          --变动原因
    ,CHG_MODE         --变动方式
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  WITH RISK_CHG_REASON AS (
  SELECT /*+MATERIALIZE*/TA.OBJECTNO,TA.INPUTDATE,T.TYPE,T.CUSTOMERID,T.CUSTOMERNAME,
         CASE WHEN T.TYPE = '0010' THEN TB.ADJUSTREASON --0010 评级模型调整法+核心定义法
              WHEN T.TYPE = '0020' THEN TB.BUSINESSDESCRIBE --0020 直接认定
          END REMARK,TB.INPUTUSERID,TO_CHAR(TO_DATE(TRIM(T.UPDATEDATE),'YYYY-MM-DD'),'YYYYMMDD') UPDATEDATE,
         ROW_NUMBER() OVER(PARTITION BY TA.OBJECTNO ORDER BY TA.INPUTDATE DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_APPLY T
   INNER JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TA
      ON TA.SERIALNO = T.SERIALNO
     AND TA.OBJECTTYPE = 'DueBill'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE TB
      ON TB.SERIALNO = T.SERIALNO
     AND TB.OBJECTTYPE = 'RelativeKernel'
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.APPROVESTATUS = 'Finished'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  RISK_ADJ_REASON AS (
  SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.OBJECTNO ORDER BY T.ADJUSTFINISHDATE DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST T
   WHERE T.OBJECTTYPE = 'BusinessDuebill'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(C,B,RRI) LEADING(B,C)*/
         V_P_DATE                                           AS DATA_DT        --数据日期
        ,B.LP_ID                                            AS LGL_REP_ID     --法人编号
        ,B.ORG_ID                                           AS ORG_ID         --机构编号
        ,B.CONT_ID                                          AS CONT_ID        --合同编号
        ,B.DUBIL_ID                                         AS RCPT_ID        --借据编号
        ,CASE WHEN B.LEVEL5_CLS_IDTFY_DT IS NOT NULL THEN TO_CHAR(B.LEVEL5_CLS_IDTFY_DT,'YYYYMMDD')
              ELSE V_P_DATE
          END                                               AS ADJ_DT         --调整日期
        ,E.TAR_VALUE_CODE                                   AS ORIG_LVL5_CL   --原五级分类
        ,F.TAR_VALUE_CODE                                   AS CURR_LVL5_CL   --现五级分类
        ,SUBSTR(A.CURR_CD,1,3)                              AS CUR            --币种 MODIFY BY XIEZY 20250409
        ,NULL                                               AS TRF_IN_AMT     --转入金额
        ,NULL                                               AS TFR_OUT_AMT    --转出金额
        --,TRIM(B.RGST_TELLER_ID)                             AS HDLR_NO        --经办人工号
        --MOD BY LIP 20240730
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.OPERATEUSERID))     AS HDLR_NO        --经办人工号
        ,NVL(TRIM(H.INPUTUSERID),TRIM(I.UPDATEUSERID))      AS ADJ_EMP_NO     --调整员工号
        ,NULL                                               AS GRANT_EMP_NO   --授权员工号
        ,RRI.APV_CLERK_ID                                   AS APRV_EMP_NO    --审批员工号 --MODIFY BY XIEZY 20250409 取审批员工号
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN /*SUBSTRB(TRIM(H.REMARK),1,30)*/ TRIM(H.REMARK)
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN /*SUBSTRB(TRIM(I.ADJUSTREASON),1,30)*/ TRIM(I.ADJUSTREASON)
              ELSE '系统自动评定'
          END                                               AS CHG_RSN        --变动原因   --MOD BY YJY 20250829 由于一表通不限制字段长度，取消截取字段长度
        ,CASE WHEN TRIM(H.REMARK) IS NOT NULL THEN '01'
              WHEN TRIM(I.ADJUSTREASON) IS NOT NULL THEN '01'
              ELSE '02'
          END                                               AS CHG_MODE       --变动方式
        ,'800919'                                           AS DEPT_LINE      --部门条线 /*风险管理部*/
        ,'对公信贷'                                         AS DATA_SRC       --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息 本月
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C --对公贷款借据信息 上日--上月
      ON C.DUBIL_ID = B.DUBIL_ID
     --AND C.ETL_DT = TO_DATE(V_LAST_MONTH,'YYYYMMDD')
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --MOD BY LIP 20250619 改成取与上日比对的调整结果
    LEFT JOIN RRP_MDL.O_ICL_CMM_CRDT_RISK_RATING_INFO RRI --信贷风险评级信息 ADD BY XIEZY 20250409 取审批员工号
      ON RRI.DUBIL_ID = B.DUBIL_ID
     AND RRI.RATING_CATE_CD = '2'
     AND RRI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E --码值映射表 CD1032-->D0005
      ON E.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND E.SRC_CLASS_CODE = 'CD1032'
     AND E.TAR_CLASS_CODE = 'D0005'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP F --码值映射表 CD1032-->D0005
      ON F.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND F.SRC_CLASS_CODE = 'CD1032'
     AND F.TAR_CLASS_CODE = 'D0005'
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A
      ON A.DUBIL_NUM = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RISK_CHG_REASON H --ADD BY LIP 20240730
      --ON H.OBJECTNO = A.DUBIL_NUM
      ON H.OBJECTNO = B.DUBIL_ID
     AND H.RN = 1
    LEFT JOIN RISK_ADJ_REASON I --ADD BY LIP 20241025
      --ON I.OBJECTNO = A.DUBIL_NUM
      ON I.OBJECTNO = B.DUBIL_ID
     AND I.RN = 1
   WHERE E.TAR_VALUE_CODE <> F.TAR_VALUE_CODE
     AND A.DUBIL_NUM IS NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,CONT_ID,RCPT_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_LVL5_CHG_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CONT_ID,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);

  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_LVL5_CHG_INFO;
/

