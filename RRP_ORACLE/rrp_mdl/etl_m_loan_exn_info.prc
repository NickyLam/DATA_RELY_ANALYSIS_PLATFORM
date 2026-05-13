CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_EXN_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：ETL_M_LOAN_EXN_INFO
 *  功能描述：贷款展期信息
 *  创建日期：20220524
 *  开发人员：梅炜
 *  来源表：
 *  目标表：  ETL_M_LOAN_EXN_INFO
 *  配置表：  CODE_MAP
 *  修改情况：序号  修改日期  修改人   修改原因
 *             1    20220524  梅炜      首次创建
 *             2    20250911  LIP       展期的部分信息改成从信贷系统取数,目前表中的展期金额和展期日期会有数据不准
 *             3    20250928  LIP       增加网商贷的展期数据
 *             4    20251024  LIP       有多次展期的，优先取最近的那个合同，取不到可以取之前最近的一笔展期合同
 *             5    20251029  LIP       增加是否参维标志
 *             6    20251111  LIP       调整展期金额取数口径
 *             7    20251211  LIP       调整展期到期日取数口径
 ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;          --处理步骤
  V_P_DATE    VARCHAR2(8);           --跑批数据日期
  V_STARTTIME DATE;                  --处理开始时间
  V_ENDTIME   DATE;                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);         --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);         --任务名称
  V_PART_NAME VARCHAR2(100);         --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_EXN_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_EXN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款展期信息临时表';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_EXN_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO_TEMP01
    (DUBIL_ID	        --借据号
    ,RENEW_FLOW_NUM	  --展期流水号
    ,CONT_ID	        --展期合同号
    ,HAPP_DT	        --展期流水发生日期
    ,START_DT	        --展期合同号发生日期
    ,RENEW_AMT	      --展期金额
    ,CONT_AMT	        --展期合同金额
    ,INIT_INT_RAT     --展期前贷款利率
    ,A_RENEW_INT_RAT	--展期后贷款利率
    ,A_RENEW_EXP_DT	  --展期后到期日
    ,ORG_ID	          --展期操作机构
    ,OPER_TELLER_ID	  --展期操作员工
    ,LOAN_USAGE_DESCB	--展期合同的合同用途
    ,RNM	            --序号
    ,NOW_CONT_ID      --本次展期合同号 --ADD BY LIP 20251029
    )
    WITH RENEW_INFO AS (
  SELECT /*+MATERIALIZE*/
         T1.RELA_DUBIL_ID                                 AS DUBIL_ID	        --借据号
        ,T1.RENEW_FLOW_NUM                                AS RENEW_FLOW_NUM	  --展期流水号
        --,COALESCE(TRIM(T2.CONT_ID),T3.CONT_ID,T4.CONT_ID) AS CONT_ID	        --展期合同号
        --MOD BY LIP 20250929 与黄娅娅确认：有多次展期的，优先取最近的那个合同，取不到可以取之前最近的一笔展期合同
        /*,CASE WHEN TRIM(T2.CONT_ID) IS NOT NULL THEN TRIM(T2.CONT_ID)
              WHEN MAX(TRIM(T2.CONT_ID)) OVER(PARTITION BY T1.RELA_DUBIL_ID) IS NOT NULL 
              THEN MAX(TRIM(T2.CONT_ID)) OVER(PARTITION BY T1.RELA_DUBIL_ID)
              ELSE COALESCE(T3.CONT_ID,T4.CONT_ID)
          END                                             AS CONT_ID          --展期合同号*/
        ,TRIM(T2.CONT_ID)                                 AS CONT_ID          --展期合同号
        ,COALESCE(TRIM(T3.CONT_ID),TRIM(T4.CONT_ID))      AS ORG_CONT_ID      --原始合同号
        ,TO_CHAR(T1.HAPP_DT,'YYYYMMDD')                   AS HAPP_DT	        --展期流水发生日期
        ,TO_CHAR(NVL(T5.START_DT,T6.START_DT),'YYYYMMDD') AS START_DT	        --展期合同号发生日期
        ,T1.RENEW_AMT                                     AS RENEW_AMT	      --展期金额
        ,NVL(T5.CONT_AMT,T6.CONT_AMT)                     AS CONT_AMT	        --展期合同金额
        ,T1.INIT_INT_RAT                                  AS INIT_INT_RAT     --展期前贷款利率
        ,T1.A_RENEW_INT_RAT                               AS A_RENEW_INT_RAT  --展期后贷款利率
        ,TO_CHAR(T1.A_RENEW_EXP_DT,'YYYYMMDD')            AS A_RENEW_EXP_DT   --展期后到期日
        ,T1.ORG_ID                                        AS ORG_ID           --展期操作机构
        ,T1.OPER_TELLER_ID                                AS OPER_TELLER_ID	  --展期操作员工
        ,NVL(TRIM(T5.LOAN_USAGE_DESCB),TRIM(T7.CD_DESCB)) AS LOAN_USAGE_DESCB --展期合同的合同用途
    FROM RRP_MDL.O_IML_AGT_LOAN_RENEW_INFO_H T1
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T2
      ON T2.OUT_ACCT_FLOW_NUM = T1.OUT_ACCT_FLOW_NUM
     AND T2.ID_MARK <> 'D'
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.DUBIL_ID = T1.RELA_DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T4
      ON T4.DUBIL_ID = T1.RELA_DUBIL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T5
      ON T5.CONT_ID = NVL(TRIM(T2.CONT_ID),T3.CONT_ID)
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T6
      ON T6.CONT_ID = NVL(TRIM(T2.CONT_ID),T4.CONT_ID)
     AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T7 --公共代码表 --CD1274贷款用途
      ON T7.CD_VAL = T6.BORW_USAGE_TYPE_CD
     AND T7.CD_ID = 'CD1274'
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  --零售部分 因会存在和上面的数据重复部分，所以用UNION ALL 合并后排序
  SELECT T1.RELA_DUBIL_ID                                 AS DUBIL_ID	        --借据号
        ,T1.RENEW_FLOW_NUM                                AS RENEW_FLOW_NUM	  --展期流水号
        --,NVL(TRIM(T2.CONT_ID),T3.CONT_ID)                 AS CONT_ID	        --展期合同号
        ,TRIM(T2.CONT_ID)                                 AS CONT_ID          --展期合同号
        ,TRIM(T3.CONT_ID)                                 AS ORG_CONT_ID      --原始合同号
        ,NULL                                             AS HAPP_DT	        --展期流水发生日期
        ,TO_CHAR(T2.START_DT,'YYYYMMDD')                  AS START_DT	        --展期合同号发生日期
        ,NULL                                             AS RENEW_AMT	      --展期金额
        ,T2.CONT_AMT                                      AS CONT_AMT	        --展期合同金额
        ,T1.INIT_EXEC_YEAR_INT_RAT                        AS INIT_INT_RAT     --展期前贷款利率
        ,T1.LOAN_EXEC_YEAR_INT_RAT                        AS A_RENEW_INT_RAT  --展期后贷款利率
        ,TO_CHAR(T1.EXP_DT,'YYYYMMDD')                    AS A_RENEW_EXP_DT   --展期后到期日
        ,NULL                                             AS ORG_ID           --展期操作机构
        ,NULL                                             AS OPER_TELLER_ID	  --展期操作员工
        ,TRIM(TC.CD_DESCB)                                AS LOAN_USAGE_DESCB --展期合同的合同用途
    FROM RRP_MDL.O_IML_AGT_RETL_DUBIL_RENEW_APPL T1 --零售借据展期申请 ICMS_RENEW_INFO
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T2 --零售贷款合同信息
      ON T2.APV_FLOW_NUM = T1.OBJ_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T3
      ON T3.DUBIL_ID = T1.RELA_DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD TC --公共代码表 --CD1274贷款用途
      ON TC.CD_VAL = NVL(T2.BORW_USAGE_TYPE_CD,T4.BORW_USAGE_TYPE_CD)
     AND TC.CD_ID = 'CD1274'
   WHERE T1.OBJ_TYPE_NAME = 'BusinessApprove'
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  NEW_RENRE_CONT_ID AS (--有多次展期的，优先取最近的那个合同，取不到可以取之前最近的一笔展期合同
  SELECT T1.DUBIL_ID,T1.CONT_ID,
         ROW_NUMBER() OVER(PARTITION BY T1.DUBIL_ID ORDER BY T1.A_RENEW_EXP_DT DESC NULLS LAST,
         T1.HAPP_DT DESC NULLS LAST,T1.START_DT DESC NULLS LAST) AS RNM
    FROM RENEW_INFO T1
   WHERE TRIM(T1.CONT_ID) IS NOT NULL)
  SELECT TA.DUBIL_ID	        --借据号
        ,TA.RENEW_FLOW_NUM	  --展期流水号
        --,TA.CONT_ID           --展期合同号
        ,COALESCE(TA.CONT_ID,TB.CONT_ID,TA.ORG_CONT_ID) AS CONT_ID --展期合同号
        ,TA.HAPP_DT           --展期流水发生日期
        ,TA.START_DT	        --展期合同号发生日期
        ,TA.RENEW_AMT         --展期金额
        ,TA.CONT_AMT	        --展期合同金额
        ,TA.INIT_INT_RAT      --展期前贷款利率
        ,TA.A_RENEW_INT_RAT   --展期后贷款利率
        ,TA.A_RENEW_EXP_DT	  --展期后到期日
        ,TA.ORG_ID	          --展期操作机构
        ,TA.OPER_TELLER_ID	  --展期操作员工
        ,TA.LOAN_USAGE_DESCB	--展期合同的合同用途
        ,ROW_NUMBER() OVER(PARTITION BY TA.DUBIL_ID ORDER BY TA.A_RENEW_EXP_DT DESC NULLS LAST,
         TA.HAPP_DT DESC NULLS LAST,TA.START_DT DESC NULLS LAST) AS RNM --序号
        ,TA.CONT_ID AS NOW_CONT_ID      --本次展期合同号 --ADD BY LIP 20251029
    FROM RENEW_INFO TA
    LEFT JOIN NEW_RENRE_CONT_ID TB --有多次展期的，优先取最近的那个合同，取不到可以取之前最近的一笔展期合同
      ON TB.DUBIL_ID = TA.DUBIL_ID
     AND TB.RNM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款展期信息--对公';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO
    (DATA_DT               --1数据日期
    ,LGL_REP_ID            --2法人编号
    ,CONT_ID               --3合同编号
    ,RCPT_ID               --4借据编号
    ,LOAN_EXTN_ID          --5贷款展期编号
    ,CUST_ID               --6客户编号
    ,ORG_ID                --7机构编号
    ,EXTN_DT               --8展期日期
    ,EXTN_EXP_DT           --9展期到期日期
    ,CUR                   --10币种
    ,EXTN_AMT              --11展期金额
    ,ORIG_RATE             --12原利率
    ,RATE_TYP              --13利率类型
    ,EXTN_BASE_RATE        --14展期基准利率
    ,RATE_FLT_VAL          --15利率浮动值
    ,ORIG_CONT_ID          --16原合同号
    ,ORIG_RCPT_NO          --17原借据号
    ,TRA_TLR_NO            --18交易柜员号
    ,GRANT_TLR_NO          --19授权柜员号
    ,EXTN_RATE             --20展期利率
    ,DEPT_LINE             --21部门条线
    ,DATA_SRC              --22数据来源
    ,LOAN_USAGE_DESCB      --23展期合同的合同用途 --ADD BY LIP 20250911
    ,IS_CSWF               --24是否参维 --ADD BY LIP 20251029
    )
    WITH CL_AMEND AS (
  --MOD BY LIP 20251111 核心改造后调整展期金额取数
  --MODIF_POST_VAL/AFTER_VAL格式：{"prd":0,"matamt":5853.56,"maturityDate":"20280630","osl":5853.56,"gprd":0,"bal":5853.56}
  SELECT /*+MATERIALIZE*/
         T1.BUS_FLOW_NUM,T1.MODIF_CONTENT_KEY_VAL,T1.MODIF_DT,REGEXP_SUBSTR(T1.MODIF_POST_VAL,'[^:\}",{]+',2,4) AS AFTER_VAL,
         ROW_NUMBER() OVER(PARTITION BY T1.MODIF_CONTENT_KEY_VAL ORDER BY T1.MODIF_DT DESC NULLS LAST,T1.TRAN_TM DESC NULLS LAST) RN
    FROM RRP_MDL.O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL T1 --IOL.NCBS_CL_AMEND
   WHERE T1.ACCT_MODIF_CATE_CD IN ('MAT','MATE')
     AND T1.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                     AS DATA_DT             --1数据日期
        ,A.LP_ID                                      AS LGL_REP_ID          --2法人编号
        ,NVL(TRIM(C.CONT_ID),A.CONT_ID)               AS CONT_ID             --3合同编号
        ,A.DUBIL_NUM                                  AS RCPT_ID             --4借据编号
        ,NVL(C.RENEW_FLOW_NUM,E.BUS_FLOW_NUM)         AS LOAN_EXTN_ID        --5贷款展期编号
        ,A.CUST_ID                                    AS CUST_ID             --6客户编号
        ,A.ACCT_INSTIT_ID                             AS ORG_ID              --7机构编号
        ,CASE WHEN TO_CHAR(E.MODIF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(E.MODIF_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                         AS EXTN_DT             --8展期日期
        ,TO_CHAR(A.RENEW_EXP_DAY,'YYYYMMDD')          AS EXTN_EXP_DT         --9展期到期日期
        --,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS EXTN_EXP_DT         --9展期到期日期 --MOD BY LIP 20251211
        ,A.CURR_CD                                    AS CUR                 --10币种
        ,CASE /*WHEN NVL(C.RENEW_AMT,0) <> 0 THEN C.RENEW_AMT
              ELSE NVL(C.CONT_AMT,0) --展期后的金额，但是会存在多个借据对应同一个展期合同，金额无法拆分的情况*/
              WHEN E.AFTER_VAL IS NOT NULL THEN TO_NUMBER(E.AFTER_VAL) --MOD BY LIP 20251111
          END                                         AS EXTN_AMT            --11展期金额
        ,NVL(C.INIT_INT_RAT,A.EXEC_INT_RAT)           AS ORIG_RATE           --12原利率
        ,A.INT_RAT_BASE_TYPE_CD                       AS RATE_TYP            --13利率类型
        ,A.BASE_RAT                                   AS EXTN_BASE_RATE      --14展期基准利率
        ,A.INT_RAT_FLO_VAL                            AS RATE_FLT_VAL        --15利率浮动值
        ,A.CONT_ID                                    AS ORIG_CONT_ID        --16原合同号
        ,A.DUBIL_NUM                                  AS ORIG_RCPT_NO        --17原借据号
        ,C.OPER_TELLER_ID                             AS TRA_TLR_NO          --18交易柜员号
        ,NVL(C.OPER_TELLER_ID,B.RGST_TELLER_ID)       AS GRANT_TLR_NO        --19授权柜员号
        ,A.EXEC_INT_RAT                               AS EXTN_RATE           --20展期利率
        ,NULL                                         AS DEPT_LINE           --21部门条线
        ,'展期-对公'                                  AS DATA_SRC            --22数据来源
        ,TRIM(D.LOAN_USAGE_DESCB)                     AS LOAN_USAGE_DESCB    --23展期合同的合同用途 --ADD BY LIP 20250911
        ,CASE WHEN C.NOW_CONT_ID IS NULL THEN 'Y'
              ELSE 'N'
          END                                         AS IS_CSWF             --24是否参维 --ADD BY LIP 20251029
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      --ON B.CONT_ID = A.CONT_ID
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_EXN_INFO_TEMP01 C --贷款展期信息历史
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.RNM = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D
      ON D.CONT_ID = NVL(TRIM(C.CONT_ID),A.CONT_ID)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CL_AMEND E --展期信息表 --MOD BY LIP 20251017
      ON E.MODIF_CONTENT_KEY_VAL = A.ACCT_ID
     AND E.RN = 1
   WHERE A.RENEW_FLG = '1'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款展期信息--零售';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO
    (DATA_DT               --1数据日期
    ,LGL_REP_ID            --2法人编号
    ,CONT_ID               --3合同编号
    ,RCPT_ID               --4借据编号
    ,LOAN_EXTN_ID          --5贷款展期编号
    ,CUST_ID               --6客户编号
    ,ORG_ID                --7机构编号
    ,EXTN_DT               --8展期日期
    ,EXTN_EXP_DT           --9展期到期日期
    ,CUR                   --10币种
    ,EXTN_AMT              --11展期金额
    ,ORIG_RATE             --12原利率
    ,RATE_TYP              --13利率类型
    ,EXTN_BASE_RATE        --14展期基准利率
    ,RATE_FLT_VAL          --15利率浮动值
    ,ORIG_CONT_ID          --16原合同号
    ,ORIG_RCPT_NO          --17原借据号
    ,TRA_TLR_NO            --18交易柜员号
    ,GRANT_TLR_NO          --19授权柜员号
    ,EXTN_RATE             --20展期利率
    ,DEPT_LINE             --21部门条线
    ,DATA_SRC              --22数据来源
    ,LOAN_USAGE_DESCB      --23展期合同的合同用途 --ADD BY LIP 20250911
    ,IS_CSWF               --24是否参维 --ADD BY LIP 20251029
    )
    WITH CL_AMEND AS (
  --MOD BY LIP 20251111 核心改造后调整展期金额取数
  --MODIF_POST_VAL/AFTER_VAL格式：{"prd":0,"matamt":5853.56,"maturityDate":"20280630","osl":5853.56,"gprd":0,"bal":5853.56}
  SELECT /*+MATERIALIZE*/
         T1.BUS_FLOW_NUM,T1.MODIF_CONTENT_KEY_VAL,T1.MODIF_DT,REGEXP_SUBSTR(T1.MODIF_POST_VAL,'[^:\}",{]+',2,4) AS AFTER_VAL,
         ROW_NUMBER() OVER(PARTITION BY T1.MODIF_CONTENT_KEY_VAL ORDER BY T1.MODIF_DT DESC NULLS LAST,T1.TRAN_TM DESC NULLS LAST) RN
    FROM RRP_MDL.O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL T1 --IOL.NCBS_CL_AMEND
   WHERE T1.ACCT_MODIF_CATE_CD IN ('MAT','MATE')
     AND T1.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                             AS DATA_DT          --1数据日期
        ,A.LP_ID                              AS LGL_REP_ID       --2法人编号
        ,NVL(TRIM(C.CONT_ID),A.CONT_ID)       AS CONT_ID          --3合同编号
        ,A.DUBIL_NUM                          AS RCPT_ID          --4借据编号
        ,NVL(C.RENEW_FLOW_NUM,F.BUS_FLOW_NUM) AS LOAN_EXTN_ID     --5贷款展期编号
        ,A.CUST_ID                            AS CUST_ID          --6客户编号
        ,A.ACCT_INSTIT_ID                     AS ORG_ID           --7机构编号
        ,CASE WHEN TO_CHAR(F.MODIF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(F.MODIF_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                 AS EXTN_DT          --8展期日期
        ,TO_CHAR(A.RENEW_EXP_DT,'YYYYMMDD')   AS EXTN_EXP_DT      --9展期到期日期
        --,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXTN_EXP_DT      --9展期到期日期 --MOD BY LIP 20251211
        ,A.CURR_CD                            AS CUR              --10币种
        ,CASE /*WHEN NVL(C.RENEW_AMT,0) <> 0 THEN C.RENEW_AMT
              ELSE NVL(C.CONT_AMT,0) --展期后的金额，但是会存在多个借据对应同一个展期合同，金额无法拆分的情况*/
              WHEN F.AFTER_VAL IS NOT NULL THEN TO_NUMBER(F.AFTER_VAL) --MOD BY LIP 20251111
          END                                 AS EXTN_AMT         --11展期金额
        ,NVL(C.INIT_INT_RAT,A.EXEC_INT_RAT)   AS ORIG_RATE        --12原利率
        ,A.INT_RAT_BASE_TYPE_CD               AS RATE_TYP         --13利率类型
        ,A.BASE_RAT                           AS EXTN_BASE_RATE   --14展期基准利率
        ,A.INT_RAT_FLO_VAL                    AS RATE_FLT_VAL     --15利率浮动值
        ,A.CONT_ID                            AS ORIG_CONT_ID     --16原合同号
        ,A.DUBIL_NUM                          AS ORIG_RCPT_NO     --17原借据号
        ,C.OPER_TELLER_ID                     AS TRA_TLR_NO       --18交易柜员号
        ,B.CUST_MGR_ID                        AS GRANT_TLR_NO     --19授权柜员号
        ,A.EXEC_INT_RAT                       AS EXTN_RATE        --20展期利率
        ,NULL                                 AS DEPT_LINE        --21部门条线
        ,'展期-零售'                          AS DATA_SRC         --22数据来源
        ,TRIM(E.CD_DESCB)                     AS LOAN_USAGE_DESCB --23展期合同的合同用途 --ADD BY LIP 20250911
        ,CASE WHEN C.NOW_CONT_ID IS NULL THEN 'Y'
              ELSE 'N'
          END                                         AS IS_CSWF             --24是否参维 --ADD BY LIP 20251029
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
      --ON B.CONT_ID = A.CONT_ID
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_EXN_INFO_TEMP01 C --贷款展期信息历史
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.RNM = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO D --零售贷款合同信息
      ON D.CONT_ID = NVL(TRIM(C.CONT_ID),A.CONT_ID)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E --公共代码表 --CD1274贷款用途
      ON E.CD_VAL = D.BORW_USAGE_TYPE_CD
     AND E.CD_ID = 'CD1274'
    LEFT JOIN CL_AMEND F --展期信息表 --MOD BY LIP 20251017
      ON F.MODIF_CONTENT_KEY_VAL = A.ACCT_ID
     AND F.RN = 1
   WHERE A.RENEW_FLG = '1'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款展期信息--联合网贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_EXN_INFO
    (DATA_DT               --1数据日期
    ,LGL_REP_ID            --2法人编号
    ,CONT_ID               --3合同编号
    ,RCPT_ID               --4借据编号
    ,LOAN_EXTN_ID          --5贷款展期编号
    ,CUST_ID               --6客户编号
    ,ORG_ID                --7机构编号
    ,EXTN_DT               --8展期日期
    ,EXTN_EXP_DT           --9展期到期日期
    ,CUR                   --10币种
    ,EXTN_AMT              --11展期金额
    ,ORIG_RATE             --12原利率
    ,RATE_TYP              --13利率类型
    ,EXTN_BASE_RATE        --14展期基准利率
    ,RATE_FLT_VAL          --15利率浮动值
    ,ORIG_CONT_ID          --16原合同号
    ,ORIG_RCPT_NO          --17原借据号
    ,TRA_TLR_NO            --18交易柜员号
    ,GRANT_TLR_NO          --19授权柜员号
    ,EXTN_RATE             --20展期利率
    ,DEPT_LINE             --21部门条线
    ,DATA_SRC              --22数据来源
    ,LOAN_USAGE_DESCB      --23展期合同的合同用途
    ,IS_CSWF               --24是否参维 --ADD BY LIP 20251029
    )
    WITH MYBK_EXTEND_DETAIL_TOTAL_EF AS (
  SELECT T1.CONTRACTNO                                        AS DUBIL_ID,
         MAX(SUBSTR(REPLACE(TRIM(T1.SETTLEDATE),'-',''),1,8)) AS SETTLEDATE,
         SUM(T1.PRINAMT+T1.OVDPRINAMT)                        AS EXTN_AMT
    FROM RRP_MDL.O_IOL_ICMS_MYBK_EXTEND_DETAIL_TOTAL_EF T1 --还款计划调整明细文件汇总表
   WHERE T1.EXTENDCODE = '1' --1-调整转入
     AND TRIM(T1.CONTRACTNO) IS NOT NULL
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.CONTRACTNO)
  SELECT V_P_DATE                             AS DATA_DT          --1数据日期
        ,A.LP_ID                              AS LGL_REP_ID       --2法人编号
        ,A.DUBIL_ID                           AS CONT_ID          --3合同编号
        ,A.DUBIL_ID                           AS RCPT_ID          --4借据编号
        ,A.DUBIL_ID                           AS LOAN_EXTN_ID     --5贷款展期编号
        ,A.CUST_ID                            AS CUST_ID          --6客户编号
        ,A.ACCT_INSTIT_ID                     AS ORG_ID           --7机构编号
        ,CASE WHEN TRIM(B.SETTLEDATE) IS NOT NULL THEN B.SETTLEDATE
              ELSE '99991231'
          END                                 AS EXTN_DT          --8展期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXTN_EXP_DT      --9展期到期日期
        ,A.CURR_CD                            AS CUR              --10币种
        ,NVL(B.EXTN_AMT,0)                    AS EXTN_AMT         --11展期金额
        ,A.EXEC_INT_RAT                       AS ORIG_RATE        --12原利率
        ,A.INT_RAT_BASE_TYPE_CD               AS RATE_TYP         --13利率类型
        ,A.BASE_RAT                           AS EXTN_BASE_RATE   --14展期基准利率
        ,A.INT_RAT_FLO_VAL                    AS RATE_FLT_VAL     --15利率浮动值
        ,A.DUBIL_ID                           AS ORIG_CONT_ID     --16原合同号
        ,A.DUBIL_ID                           AS ORIG_RCPT_NO     --17原借据号
        ,A.CUST_MGR_ID                        AS TRA_TLR_NO       --18交易柜员号
        ,A.CUST_MGR_ID                        AS GRANT_TLR_NO     --19授权柜员号
        ,A.EXEC_INT_RAT                       AS EXTN_RATE        --20展期利率
        ,NULL                                 AS DEPT_LINE        --21部门条线
        ,'展期-联合网贷'                      AS DATA_SRC         --22数据来源
        ,C.CD_DESCB                           AS LOAN_USAGE_DESCB --23展期合同的合同用途 --ADD BY LIP 20250911
        ,'N'                                  AS IS_CSWF          --24是否参维 --ADD BY LIP 20251029
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN MYBK_EXTEND_DETAIL_TOTAL_EF B --展期后需要还的贷款金额
      ON B.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表 取贷款用途
      ON C.CD_VAL = A.LOAN_USAGE_CD
     AND C.CD_ID = 'CD1274'
   WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.DUBIL_ID IS NOT NULL
     AND A.STD_PROD_ID IN ('202020100001','202020200004')
     AND A.REGROUP_LOAN_TYPE_CD = '0010' --0010还款计划变更+展期
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_EXN_INFO;
/

