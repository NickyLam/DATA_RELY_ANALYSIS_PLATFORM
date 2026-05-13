CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_EAST_OWN_CPTL_BAL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_EAST_OWN_CPTL_BAL
  *  功能描述：自营资金业务余额表
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_EAST_OWN_CPTL_BAL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  *             2    20221122  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_EAST_OWN_CPTL_BAL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_END_LAST_MON DATE; --上月末
  V_BEG_THIS_MON DATE; --本月初
  V_BEG_THIS_YEAR DATE;--本年初
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
    V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_BEG_THIS_MON := TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'MM');
  V_END_LAST_MON := LAST_DAY(ADD_MONTHS(TO_DATE(V_P_DATE, 'YYYYMMDD'), -1)); --上月末
  V_BEG_THIS_YEAR := TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD'); --本年初
  V_TAB_NAME := 'M_EAST_OWN_CPTL_BAL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

   /*SELECT CASE WHEN I_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN I_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN I_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN I_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN I_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN I_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;*/
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
  V_STEP_DESC := '插入自营资金业务余额表--资金债券回购表出卖出回购和买入返售证券数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,/*A.BUS_ID*/ B.CNTPTY_ID ||'_'|| B.TRAN_ID   AS FIN_INST_ID         --金融工具编号
    ,CASE WHEN B.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
          WHEN B.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
          ELSE '银行账户'
     END                                          AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,A.ASSET_TYPE_NAME||A.BUS_CATE_NAME           AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,B.TRAN_AMT /*A.HOLD_FAC_VAL*/                AS HOLD_COST           --持有成本
    ,A.CURR_BAL                                   AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_PRFT),0)-NVL(TRIM(D1.INT_PRFT),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_PRFT),0)                      AS CUM_PFT             --累计收益
    ,B.REPO_INT_RAT /*A.ACTL_INT_RAT*/            AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,NVL(TRIM(F.N_ECL_BEFORE),A.IMPAM_PREP)       AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
  INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_REPO B  --资金债券回购
     ON A.BUS_ID = B.BUS_ID
    AND B.REPO_TYPE_CD IN ('N','B') --N-质押式回购交易、B-买断式回购交易
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  /*LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
    ON A.ENTRY_ORG_ID = C.ORG_ID*/
  LEFT JOIN (--本期累计收益
    SELECT ASSET_TYPE_NAME,BUS_CATE_NAME,ACCT_B_ID,MAIN_ASSET_ID,MINOR_ASSET_ID,SUM(INT_PRFT) AS INT_PRFT
    FROM RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL --本币资金资产余额变动明细
    WHERE ACTL_ACPT_PAY_DT >= V_BEG_THIS_YEAR
    AND ACTL_ACPT_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND BUS_TAB_NAME <> 'CARRYOVERDEALS'
    GROUP BY ASSET_TYPE_NAME,BUS_CATE_NAME,ACCT_B_ID,MAIN_ASSET_ID,MINOR_ASSET_ID
  ) D
    ON A.ASSET_TYPE_NAME = D.ASSET_TYPE_NAME
   AND A.BUS_CATE_NAME = D.BUS_CATE_NAME
   AND A.TRAN_ACCT_B_ID = D.ACCT_B_ID
   AND A.MAIN_ASSET_ID = D.MAIN_ASSET_ID
   AND A.BUS_ID = D.MINOR_ASSET_ID
  LEFT JOIN (--上期累计收益
    SELECT ASSET_TYPE_NAME,BUS_CATE_NAME,ACCT_B_ID,MAIN_ASSET_ID,MINOR_ASSET_ID,SUM(INT_PRFT) AS INT_PRFT
    FROM RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL --本币资金资产余额变动明细
    WHERE ACTL_ACPT_PAY_DT >= V_BEG_THIS_YEAR
    AND ACTL_ACPT_PAY_DT <= V_END_LAST_MON
    AND BUS_TAB_NAME <> 'CARRYOVERDEALS'
    GROUP BY ASSET_TYPE_NAME,BUS_CATE_NAME,ACCT_B_ID,MAIN_ASSET_ID,MINOR_ASSET_ID
  ) D1
    ON A.ASSET_TYPE_NAME = D1.ASSET_TYPE_NAME
   AND A.BUS_CATE_NAME = D1.BUS_CATE_NAME
   AND A.TRAN_ACCT_B_ID = D1.ACCT_B_ID
   AND A.MAIN_ASSET_ID = D1.MAIN_ASSET_ID
   AND A.BUS_ID = D1.MINOR_ASSET_ID
  LEFT JOIN (  --信用风险权重
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BUS_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.MAIN_ASSET_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME LIKE '%回购%'
    AND (A.CURR_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURR_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--同业现金借贷表出卖出回购和买入返售证券数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.PRIC_BAL /*+ A.RECVBL_UNCOL_PRIC */        AS HOLD_COST           --持有成本
    ,A.ACTL_BAL                                   AS BOOK_BAL            --账面余额
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN (NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0))*1
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN (NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0))*(-1)
     END                                          AS CURR_PFT            --本期收益
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN NVL(TRIM(D.INT_INCOME),0)*1
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN NVL(TRIM(D.INT_INCOME),0)*(-1)
     END                                          AS CUM_PFT             --累计收益
    ,ABS(A.EXEC_INT_RAT)                          AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800975' /*投金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID||'_'||A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME LIKE '%回购%'
    AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURRT_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--票据转贴现信息表出卖出回购和买入返售票据数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ACCT_INSTIT_ID /*D.ORG_ID1*/               AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.BILL_NUM                                   AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '买入返售'
          WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '卖出回购'
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '其他-买入返售票据'
          WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '其他-卖出回购票据'
     END                                          AS BIZ_SML_CL          --业务小类
    ,B.CD_DESCB||C.CD_DESCB                       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.FAC_VAL_AMT                                AS HOLD_COST           --持有成本
    ,NVL(A.CURRT_BAL, 0) - NVL(A.INT_ADJ_BAL, 0)  AS BOOK_BAL            --账面余额
    ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN (NVL(TRIM(E.INT_AMT),0)-NVL(TRIM(E1.INT_AMT),0))*1
          WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN (NVL(TRIM(E.INT_AMT),0)-NVL(TRIM(E1.INT_AMT),0))*(-1)
     END                                          AS CURR_PFT            --本期收益
    ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN (NVL(TRIM(E.INT_AMT),0))*1
          WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN (NVL(TRIM(E.INT_AMT),0))*(-1)
     END                                          AS CUM_PFT             --累计收益
    ,A.DISCNT_INT_RAT                             AS YEAR_RATE           --年化利率
    ,NULL                                         AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.STL_DT, 'YYYYMMDD')                AS VAL_DT              --起息日期
    ,TO_CHAR(A.REPO_DT, 'YYYYMMDD')               AS EXP_DT              --到期日期
    ,'800935' /*票据业务事业部*/                  AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
  INNER JOIN (
    SELECT AA.BUS_ID,ROW_NUMBER() OVER(PARTITION BY AA.BILL_NUM ORDER BY NVL(TRIM(AA.ACTL_REPO_DT),'99991231') DESC) AS NUM
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO AA --票据转贴现信息表
    WHERE AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND AA.BUS_TYPE_CD IN ('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
    AND AA.ENTRY_STATUS_CD = '03'
    AND (TRIM(AA.ACTL_REPO_DT) IS NULL OR AA.ACTL_REPO_DT >= V_BEG_THIS_MON)
  ) A1
    ON A1.BUS_ID = A.BUS_ID
   AND A1.NUM = 1
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD B --公共代码表
    ON A.BILL_KIND_CD = B.CD_VAL
   AND B.CD_ID = 'CD1384'  --票据类型代码
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表
    ON A.BUS_TYPE_CD = C.CD_VAL
   AND C.CD_ID = 'CD1076'  --票据类型代码
  /*LEFT JOIN RRP_MDL.ORG_CONFIG D --机构映射表
    ON A.ACCT_INSTIT_ID = D.ORG_ID*/
  LEFT JOIN ( --本期累计收益
    SELECT BILL_NUM,SUM(INT_AMT) INT_AMT
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND BUS_TYPE_CD IN ('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
      AND ENTRY_STATUS_CD = '03'
      AND ((ACTL_REPO_DT >= V_BEG_THIS_YEAR
          AND ACTL_REPO_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
           OR TRIM(ACTL_REPO_DT) IS NULL)
    GROUP BY BILL_NUM
  ) E
    ON A.BILL_NUM = E.BILL_NUM
  LEFT JOIN ( --上期累计收益
    SELECT BILL_NUM,SUM(INT_AMT)  INT_AMT
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO
    WHERE ETL_DT = V_END_LAST_MON
      AND BUS_TYPE_CD IN ('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
      AND ENTRY_STATUS_CD = '03'
      AND ((ACTL_REPO_DT >= V_BEG_THIS_YEAR
          AND ACTL_REPO_DT <= V_END_LAST_MON)
           OR TRIM(ACTL_REPO_DT) IS NULL)
    GROUP BY BILL_NUM
  ) E1
    ON A.BILL_NUM = E1.BILL_NUM
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BILL_NUM = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.BUS_TYPE_CD IN ('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
    AND A.ENTRY_STATUS_CD = '03'
    AND (TRIM(A.ACTL_REPO_DT) IS NULL OR A.ACTL_REPO_DT >= V_BEG_THIS_MON)
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--外汇同业拆借表出外币回购数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT DISTINCT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*B.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.CNTPTY_ID||'_'||A.BUS_ID/*A.BAG_ID*/       AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,A.PORTF_NAME                                 AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.TRAN_AMT                                   AS HOLD_COST           --持有成本
    ,A.CURRT_BAL                                  AS BOOK_BAL            --账面余额
    ,NVL(TRIM(C.SPD_PRFT),0) + NVL(TRIM(C.AMORT_PRFT),0) + NVL(TRIM(C.INT_PRFT),0) -
     NVL(TRIM(D.SPD_PRFT),0) - NVL(TRIM(D.AMORT_PRFT),0) - NVL(TRIM(D.INT_PRFT),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(C.SPD_PRFT),0) + NVL(TRIM(C.AMORT_PRFT),0) + NVL(TRIM(C.INT_PRFT),0) AS CUM_PFT             --累计收益
    ,A.EXEC_INT_RAT                               AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表_视图
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.ENTRY_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_FX_CAP_POST C --外汇资金持仓
    ON A.BUS_ID = C.MAIN_ASSET_ID
   AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_FX_CAP_POST D --外汇资金持仓
    ON A.BUS_ID = D.MAIN_ASSET_ID
   AND D.ETL_DT = V_END_LAST_MON
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(A.ENTRY_ORG_ID) IS NOT NULL
    AND A.PORTF_NAME = '外币质押式回购'
    AND (A.CURRT_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURRT_BAL  > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--资金债券借贷表出债券借贷数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.BUS_ID                                     AS FIN_INST_ID         --金融工具编号
    ,CASE WHEN A.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
          WHEN A.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
          ELSE NULL
     END                                          AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,'其他'                                       AS BIZ_MID_CL          --业务中类
    ,'债券借贷'                                   AS BIZ_SML_CL          --业务小类
    ,CASE WHEN A.TRAN_DIR_CD = '01' THEN A.CNTPTY_NAME||'_债券借入'
          WHEN A.TRAN_DIR_CD = '02' THEN A.CNTPTY_NAME||'_债券借出'
     END                                          AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.CURRT_BAL                                  AS HOLD_COST           --持有成本
    ,CASE WHEN A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') AND A.TRAN_DIR_CD = '01' THEN A.CURRT_BAL*(-1)
          WHEN A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') AND A.TRAN_DIR_CD = '02' THEN A.CURRT_BAL*1
          ELSE 0
     END                                          AS BOOK_BAL            --账面余额
    ,CASE WHEN A.TRAN_DIR_CD = '01' THEN (NVL(TRIM(A.ACRU_INT),0) - NVL(TRIM(D.ACRU_INT),0))*(-1)
          WHEN A.TRAN_DIR_CD = '02' THEN (NVL(TRIM(A.ACRU_INT),0) - NVL(TRIM(D.ACRU_INT),0))*1
          ELSE 0
     END                                          AS CURR_PFT            --本期收益
    ,CASE WHEN A.TRAN_DIR_CD = '01' THEN NVL(TRIM(A.ACRU_INT),0)*(-1)
          WHEN A.TRAN_DIR_CD = '02' THEN NVL(TRIM(A.ACRU_INT),0)*1
          ELSE 0
     END                                          AS CUM_PFT             --累计收益
    ,B.FAC_VAL_INT_RAT                            AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BOND_DEBIT_CRDT A  --资金债券借贷表
  LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
    ON A.UNDERLY_BOND_ID = B.BOND_ID
   AND A.ETL_DT = B.ETL_DT
   AND UPPER(B.DATA_SRC_SYS_IDF) = 'CTMS'
  /*LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
    ON A.ENTRY_ORG_ID = C.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_DEBIT_CRDT D  --资金债券借贷表
    ON A.BUS_ID = D.BUS_ID
   AND D.ETL_DT = V_END_LAST_MON
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.UNDERLY_BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.UNDERLY_BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.EXP_DT >= V_BEG_THIS_MON
    --AND A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--资金同业拆借表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*B.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.BUS_ID /*A.BAG_ID*/                        AS FIN_INST_ID         --金融工具编号
    ,CASE WHEN A.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
          WHEN A.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
          ELSE NULL
     END                                          AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030101','20030201','20030301')  THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '200304' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030102','20030202','20030302')  THEN '拆入非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('13020301','13020302') THEN '境内同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020303' THEN '境外同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020401' THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010101','1302010201') THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020402' THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010102','1302010202') THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆出银行金融机构'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
          ELSE NULL
     END                                          AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.TRAN_AMT                                   AS HOLD_COST           --持有成本
    ,A.CURRT_BAL                                  AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_PRFT),0)-NVL(TRIM(D1.INT_PRFT),0) AS CURR_PFT        --本期收益
    ,NVL(TRIM(D.INT_PRFT),0)                      AS CUM_PFT             --累计收益
    ,A.EXEC_INT_RAT                               AS YEAR_RATE           --年化利率
    ,NULL                                         AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A  --资金同业拆借表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.ENTRY_ORG_ID = B.ORG_ID*/
  LEFT JOIN (--本期累计收益
    SELECT MAIN_ASSET_ID,SUM(INT_PRFT) AS INT_PRFT
    FROM RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL --本币资金资产余额变动明细
    WHERE ACTL_ACPT_PAY_DT >= V_BEG_THIS_YEAR
    AND ACTL_ACPT_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND BUS_TAB_NAME <> 'CARRYOVERDEALS'
    GROUP BY MAIN_ASSET_ID
  ) D
    ON A.BUS_ID = D.MAIN_ASSET_ID
  LEFT JOIN (--上期累计收益
    SELECT MAIN_ASSET_ID,SUM(INT_PRFT) AS INT_PRFT
    FROM RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL --本币资金资产余额变动明细
    WHERE ACTL_ACPT_PAY_DT >= V_BEG_THIS_YEAR
    AND ACTL_ACPT_PAY_DT <= V_END_LAST_MON
    AND BUS_TAB_NAME <> 'CARRYOVERDEALS'
    GROUP BY MAIN_ASSET_ID
  ) D1
    ON A.BUS_ID = D1.MAIN_ASSET_ID
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BAG_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND (A.CURRT_BAL  > 0 OR A.EXP_DT > V_BEG_THIS_MON)
    --AND (A.CURRT_BAL  > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--外汇同业拆借表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*B.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.CNTPTY_ID||'_'||A.BUS_ID/*A.BAG_ID*/       AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030101','20030201','20030301')  THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '200304' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030102','20030202','20030302')  THEN '拆入非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('13020301','13020302') THEN '境内同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020303' THEN '境外同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020401' THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010101','1302010201') THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020402' THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010102','1302010202') THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆出银行金融机构'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
          ELSE NULL
     END                                          AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.TRAN_AMT                                   AS HOLD_COST           --持有成本
    ,A.CURRT_BAL                                  AS BOOK_BAL            --账面余额
    ,NVL(TRIM(C.SPD_PRFT),0) + NVL(TRIM(C.AMORT_PRFT),0) + NVL(TRIM(C.INT_PRFT),0) -
     NVL(TRIM(D.SPD_PRFT),0) - NVL(TRIM(D.AMORT_PRFT),0) - NVL(TRIM(D.INT_PRFT),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(C.SPD_PRFT),0) + NVL(TRIM(C.AMORT_PRFT),0) + NVL(TRIM(C.INT_PRFT),0) AS CUM_PFT             --累计收益
    ,A.EXEC_INT_RAT                               AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.ENTRY_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_FX_CAP_POST C --外汇资金持仓
    ON A.BUS_ID = C.MAIN_ASSET_ID
   AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_FX_CAP_POST D --外汇资金持仓
    ON A.BUS_ID = D.MAIN_ASSET_ID
   AND D.ETL_DT = V_END_LAST_MON
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.PORTF_NAME = '外币拆借'
    AND (A.CURRT_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURRT_BAL  > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--同业现金借贷表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
          ELSE NULL
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030101','20030201','20030301')  THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,6) = '200304' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20030102','20030202','20030302')  THEN '拆入非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('13020301','13020302') THEN '境内同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020303' THEN '境外同业借款'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020401' THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010101','1302010201') THEN '拆出银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,8) = '13020402' THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,10) IN ('1302010102','1302010202') THEN '拆出非银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入银行金融机构'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆出银行金融机构'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
          ELSE NULL
     END                                          AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.PRIC_BAL                                   AS HOLD_COST           --持有成本
    ,A.ACTL_BAL                                   AS BOOK_BAL            --账面余额
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN (NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0))*(-1)
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN (NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0))*1
     END                                          AS CURR_PFT            --本期收益
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN NVL(TRIM(D.INT_INCOME),0)*(-1)
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN NVL(TRIM(D.INT_INCOME),0)*1
     END                                          AS CUM_PFT             --累计收益
    ,ABS(A.EXEC_INT_RAT)                          AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800975' /*投金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID||'_'||A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND A.ASSET_TYPE_NAME NOT LIKE '%回购%' --踢掉回购部分
    AND SUBSTR(A.SUBJ_ID,1,4) IN ('1302','2003')
    AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURRT_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-资金债券投资表出同业存单投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.BOND_ID /*A.BAL_ID*/                       AS FIN_INST_ID         --金融工具编号
    ,CASE WHEN A.ACCT_ATTR_CD = 'B' THEN '银行账户'
          WHEN A.ACCT_ATTR_CD = 'T' THEN '交易账户'
          ELSE NULL
     END                                          AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,'同业存单'                                   AS BIZ_MID_CL          --业务中类
    ,'同业存单投资'                               AS BIZ_SML_CL          --业务小类
    ,A.BOND_NAME                                  AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,CASE WHEN A.DISCNT_DEBT_FLG = '1' THEN A.HOLD_POS
          ELSE A.HOLD_FAC_VAL
     END                                          AS HOLD_COST           --持有成本
    ,A.BOOK_BAL                                   AS BOOK_BAL            --账面余额
    ,A.SPD_PRFT + A.AMORT_PRFT + A.INT_PRFT  - NVL(TRIM(D.INT_PRFT),0) AS CURR_PFT            --本期收益
    ,A.SPD_PRFT + A.AMORT_PRFT + A.INT_PRFT       AS CUM_PFT             --累计收益
    ,CASE WHEN NVL(TRIM(A.FAC_VAL_INT_RAT),0) <> 0 THEN A.FAC_VAL_INT_RAT
          ELSE NVL(TRIM(B.ISSUE_INT_RAT),0)*1
     END                                          AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A  --资金债券投资表
  INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
     ON A.BOND_ID = B.BOND_ID
    AND A.ETL_DT = B.ETL_DT
  /*LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
    ON A.ENTRY_ORG_ID = C.ORG_ID*/
  LEFT JOIN (
    SELECT BAL_ID
          ,SPD_PRFT + AMORT_PRFT + INT_PRFT AS INT_PRFT
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST  --资金债券投资表
    WHERE ETL_DT = V_END_LAST_MON
    AND BOND_TYPE_CD = 'W' --同业存单
  ) D
    ON A.BAL_ID = D.BAL_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.BOND_TYPE_CD = 'W' --同业存单
    AND (A.BOOK_BAL > 0 OR A.STL_DT >= V_BEG_THIS_MON)
    AND A.TRAN_ACCT_B_ID IN ('200','201','202')  --200-交易性金融资产、201-可供出售金融资产、202-持有至到期金融资产
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-同业证券持仓表出同业存单发行数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,'同业存单'                                   AS BIZ_MID_CL          --业务中类
    ,'同业存单发行'                               AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.NET_PRICE_COST                             AS HOLD_COST           --持有成本
    ,A.ACTL_BAL + A.INT_ADJ_AMT                   AS BOOK_BAL            --账面余额
    ,A.SPD_PL + A.INT_INCOME - NVL(TRIM(D.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,A.SPD_PL + A.INT_INCOME                      AS CUM_PFT             --累计收益
    ,A.ACTL_INT_RAT                               AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A  --同业证券持仓表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --上期累计收益
    SELECT OBJ_ID
          ,FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE ETL_DT = V_END_LAST_MON
    GROUP BY OBJ_ID,FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.OBJ_ID = D.OBJ_ID
   AND A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ASSET_TYPE_NAME LIKE '%同业存单%'
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND (ABS(A.ACTL_BAL) > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (ABS(A.ACTL_BAL) > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-资金业务持仓表出银行次级债、银行永续债数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
    DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,B.BOND_ID  /*A.BAL_ID*/                      AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,'债券发行'                                   AS BIZ_MID_CL          --业务中类
    ,CASE WHEN B.BOND_TYPE_CD IN ('7','71','X') THEN '银行次级债'
          WHEN B.BOND_TYPE_CD = 'Y' THEN '银行永续债'
          ELSE NULL
     END                                          AS BIZ_SML_CL          --业务小类
    ,B.BOND_ABBR                                  AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.HOLD_FAC_VAL                               AS HOLD_COST           --持有成本
    ,A.CURR_BAL + A.INT_ADJ_AMT                   AS BOOK_BAL            --账面余额
    ,A.SPD_PRFT+A.AMORT_PRFT+A.INT_PRFT-NVL(TRIM(D.LAST_PFT),0) AS CURR_PFT --本期收益  累计收益 减去上一期的金额
    ,A.SPD_PRFT+A.AMORT_PRFT+A.INT_PRFT           AS CUM_PFT             --累计收益
    ,NVL(TRIM(B.FAC_VAL_INT_RAT),B.ISSUE_INT_RAT) AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,NVL(TRIM(F.N_ECL_BEFORE),A.IMPAM_PREP)       AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
  INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
     ON A.MAIN_ASSET_ID = B.BOND_ID
    AND A.ETL_DT = B.ETL_DT
  /*LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
    ON A.ENTRY_ORG_ID = C.ORG_ID*/
  LEFT JOIN (--上期收益
       SELECT SA.BOND_ID||'_'||SA.ASSET_THD_CLS_CD||'_'||SA.TRAN_ACCT_B_ID AS LAST_ID
              ,SA.SPD_PRFT+SA.AMORT_PRFT+SA.INT_PRFT AS LAST_PFT
       FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST SA --资金业务持仓
       WHERE SA.ETL_DT = V_END_LAST_MON
         AND SA.ASSET_TYPE_NAME = '债券发行'
         AND SA.STL_DT <= V_END_LAST_MON
         AND SA.HOLD_POS <> 0
  ) D
    ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = D.LAST_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.MAIN_ASSET_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME = '债券发行'
    AND B.BOND_TYPE_CD IN ('7','71','X','Y')
    AND A.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.HOLD_POS <> 0
    --AND (A.CURR_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-资金债券投资表出债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.BOND_ID /*A.BAL_ID*/                       AS FIN_INST_ID         --金融工具编号
    ,CASE WHEN A.ACCT_ATTR_CD = 'B' THEN '银行账户'
          WHEN A.ACCT_ATTR_CD = 'T' THEN '交易账户'
          ELSE NULL
     END                                          AS ACC_TYP             --账户类型
    ,'债券投资与同业投资'                         AS BIZ_LRG_CL          --业务大类
    ,'债券投资'                                   AS BIZ_MID_CL          --业务中类
    ,CASE WHEN B.BOND_TYPE_CD = '1' THEN '国债'
          WHEN B.BOND_TYPE_CD = '5' THEN '央票'
          WHEN B.BOND_TYPE_CD = 'M' THEN '地方政府债'
          WHEN B.BOND_TYPE_CD = 'Q' THEN '政府支持机构债'
          WHEN B.ISSUER_NAME  IN ('中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '政策性金融债'
          WHEN B.BOND_TYPE_CD IN ('61','9','C','C1','C2','C3','C4','C5','C6','U','X','Y') THEN '商业性金融债'
          WHEN B.BOND_TYPE_CD IN ('4','6','D','E','G','H','I','J','N','O','P','V') THEN '非金融企业债券'
          WHEN B.BOND_TYPE_CD = 'L'  THEN '资产支持证券（信贷资产证券化）' --据银鹏反馈，调整债券类型为L的都归为资产支持证券（信贷资产证券化）
          WHEN B.BOND_TYPE_CD = 'L1' THEN '资产支持证券（资产支持票据）'
           WHEN B.BOND_TYPE_CD IN ('F','FL','FG') THEN '外国债券'
           ELSE '其他-'||D.CD_DESCB
     END                                          AS BIZ_SML_CL          --业务小类
    ,B.BOND_ABBR                                  AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,CASE WHEN A.DISCNT_DEBT_FLG = '1' THEN A.HOLD_POS
          ELSE A.HOLD_FAC_VAL
     END                                          AS HOLD_COST           --持有成本
    ,A.BOOK_BAL                                   AS BOOK_BAL            --账面余额
    ,A.SPD_PRFT + A.AMORT_PRFT + A.INT_PRFT - NVL(TRIM(T.INT_PRFT),0) AS CURR_PFT            --本期收益
    ,A.SPD_PRFT + A.AMORT_PRFT + A.INT_PRFT       AS CUM_PFT             --累计收益
    ,CASE WHEN NVL(TRIM(A.FAC_VAL_INT_RAT),0) <> 0 THEN A.FAC_VAL_INT_RAT
          ELSE NVL(TRIM(B.ISSUE_INT_RAT),0)*1
     END                                          AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,'正常'                                       AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A  --资金债券投资表
  INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
     ON A.BOND_ID = B.BOND_ID
    AND A.ETL_DT = B.ETL_DT
  /*LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
    ON A.ENTRY_ORG_ID = C.ORG_ID*/
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD D --数仓码值表
    ON B.BOND_TYPE_CD = D.CD_VAL
   AND D.CD_ID = 'CD1486' --债券类型代码
  LEFT JOIN (
    SELECT BAL_ID
          ,SPD_PRFT + AMORT_PRFT + INT_PRFT AS INT_PRFT
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST  --资金债券投资表
    WHERE ETL_DT = V_END_LAST_MON
      AND NVL(TRIM(BOND_TYPE_CD),' ') NOT IN ('W',' ') --同业存单
      AND BUS_CATE_NAME IN ('现券','债券负债')
  ) T
    ON A.BAL_ID = T.BAL_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND NVL(TRIM(B.BOND_TYPE_CD),' ') NOT IN ('W',' ')
    AND A.BUS_CATE_NAME IN ('现券','债券负债')
    AND (A.BOOK_BAL > 0 OR A.STL_DT >= V_BEG_THIS_MON)
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-同业债券投资表出债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'债券投资与同业投资'                         AS BIZ_LRG_CL          --业务大类
    ,'债券投资'                                   AS BIZ_MID_CL          --业务中类
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '资产支持证券%' THEN '资产支持证券（交易所资产支持证券）'
          WHEN A.ASSET_TYPE_NAME IN ('一般公司债','一般企业债') THEN '非金融企业债券'
          WHEN A.ISSUER_NAME  IN ('中国进出口银行','中国农业发展银行','国家开发银行')  THEN '政策性金融债'
          ELSE '商业性金融债'
     END                                          AS BIZ_SML_CL          --业务小类
    ,A.BOND_NAME                                  AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.HOLD_FAC_VAL + A.RECVBL_UNCOL_PRIC         AS HOLD_COST           --持有成本
    ,A.BOOK_BAL                                   AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_INCOME),0) - NVL(TRIM(D1.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_INCOME),0)                    AS CUM_PFT             --累计收益
    ,A.FAC_VAL_INT_RAT /*A.ACTL_INT_RAT*/         AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A  --同业债券投资表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID||'_'||A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
    AND A.CAP_TYPE_CD = '0' --自营
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-同业非标投资表出资产支持证券（资产支持票据）和公募基金投资、资产管理产品投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'债券投资与同业投资'                         AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '债券投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%'
            OR A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '公募基金投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%'
            OR A.ASSET_TYPE_NAME LIKE '%信托计划%'
            OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
            OR A.ASSET_TYPE_NAME LIKE '保险资管计划'
            OR (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'  THEN '资产管理产品投资'
          ELSE '其他投产'
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '资产支持证券（资产支持票据）'
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' THEN '债券基金'
          WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '货币市场基金'
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%' THEN '非保本理财投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%'
            OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN '信托产品（资金信托）'
          WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划'
            OR A.CNTPTY_CLS_DESCB LIKE '%保险%'
            OR A.CNTPTY_CLS_DESCB LIKE '%中国人寿%'
            OR A.CNTPTY_CLS_DESCB LIKE '%新华资产%'
            OR A.CNTPTY_CLS_DESCB LIKE '%民生通惠%' THEN '保险业资产管理产品'
          WHEN (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%保险资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%' THEN '证券业资产管理产品（不含公募基金）'
          ELSE '其他债权融资（其他交易平台债权融资工具）'
     END                                          AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.PRIC_BAL + A.RECVBL_UNCOL_PRIC             AS HOLD_COST           --持有成本
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN A.BOOK_BAL
          ELSE A.BOOK_BAL+ROUND(NVL(O.N_PV_VARIATION,0),2)
     END                                          AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_INCOME),0)                    AS CUM_PFT             --累计收益
    ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动
    ON A.FIN_INSTM_ID = O.V_ASSET_CODE
   AND A.ASSET_THD_CLS_CD = O.V_THREE_CLASS
   AND A.OBJ_ID = O.V_TRADE_NO
   AND A.ETL_DT = O.ETL_DT
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND A.ASSET_TYPE_NAME NOT LIKE '%货币基金%'
    AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表-同业净值型产品投资表出资产管理计划、债券基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'债券投资与同业投资'                         AS BIZ_LRG_CL          --业务大类
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '债券投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%'
            OR A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '公募基金投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%'
            OR A.ASSET_TYPE_NAME LIKE '%信托计划%'
            OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
            OR A.ASSET_TYPE_NAME LIKE '保险资管计划'
            OR (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'  THEN '资产管理产品投资'
          ELSE '其他投产'
     END                                          AS BIZ_MID_CL          --业务中类
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '资产支持证券（资产支持票据）'
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' THEN '债券基金'
          WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '货币市场基金'
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%' THEN '非保本理财投资'
          WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%'
            OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN '信托产品（资金信托）'
          WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划'
            OR A.CNTPTY_CLS_DESCB LIKE '%保险%'
            OR A.CNTPTY_CLS_DESCB LIKE '%中国人寿%'
            OR A.CNTPTY_CLS_DESCB LIKE '%新华资产%'
            OR A.CNTPTY_CLS_DESCB LIKE '%民生通惠%' THEN '保险业资产管理产品'
          WHEN (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%保险资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%' THEN '证券业资产管理产品（不含公募基金）'
          ELSE '其他债权融资（其他交易平台债权融资工具）'
     END                                          AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.PRIC_BAL + A.RECVBL_UNCOL_PRIC             AS HOLD_COST           --持有成本
    ,A.BOOK_BAL                                   AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_INCOME),0)                    AS CUM_PFT             --累计收益
    ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--同业证券持仓表出货币基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID/*||A.OBJ_ID*/                 AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'债券投资与同业投资'                         AS BIZ_LRG_CL          --业务大类
    ,'公募基金投资'                               AS BIZ_MID_CL          --业务中类
    ,'货币市场基金'                               AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.NET_PRICE_COST                             AS HOLD_COST           --持有成本
    ,NVL(A.ACTL_BAL,0)+NVL(A.EVHA_VAL_CHAG,0)     AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_INCOME),0)                    AS CUM_PFT             --累计收益
    ,A.ACTL_INT_RAT                               AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'

          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800976' /*资金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A  --同业证券持仓表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME LIKE '%货币基金%'
    AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.ACTL_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--同业现金借贷表出非结算性存放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT             --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID              --机构编号
    ,A.SUBJ_ID                                    AS SUBJ_ID             --科目编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID         --金融工具编号
    ,'银行账户'                                   AS ACC_TYP             --账户类型
    ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
    ,'存放同业'                                   AS BIZ_MID_CL          --业务中类
    ,'非结算性存放同业'                           AS BIZ_SML_CL          --业务小类
    ,C.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM             --产品名称
    ,A.CURR_CD                                    AS CUR                 --币种
    ,A.PRIC_BAL /*+ A.RECVBL_UNCOL_PRIC */        AS HOLD_COST           --持有成本
    ,A.ACTL_BAL                                   AS BOOK_BAL            --账面余额
    ,NVL(TRIM(D.INT_INCOME),0)-NVL(TRIM(D1.INT_INCOME),0) AS CURR_PFT            --本期收益
    ,NVL(TRIM(D.INT_INCOME),0)                    AS CUM_PFT             --累计收益
    ,ABS(A.EXEC_INT_RAT)                          AS YEAR_RATE           --年化利率
    ,E.SPECIFIC_RISK_CHARGE                       AS CR_RSK_WGT          --信用风险权重
    ,CASE WHEN F.V_REGUL_CLASSIF_CD = '10' THEN '正常'
          WHEN F.V_REGUL_CLASSIF_CD = '20' THEN '关注'
          WHEN F.V_REGUL_CLASSIF_CD = '30' THEN '次级'
          WHEN F.V_REGUL_CLASSIF_CD = '40' THEN '可疑'
          WHEN F.V_REGUL_CLASSIF_CD = '50' THEN '损失'
          ELSE '正常'
     END                                          AS LVL5_CL             --五级分类
    ,F.N_ECL_BEFORE                               AS PRO_IMPT            --减值准备
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
    ,'800975' /*投金部*/                          AS DEPT_LINE           --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
  /*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构映射表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN ( --本期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D
    ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
  LEFT JOIN ( --上期累计收益
    SELECT FIN_INSTM_ID
          ,ASSET_TYPE_ID
          ,MARKET_TYPE_ID
          ,SUM(SPD_PL+INT_INCOME) AS INT_INCOME
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST --同业证券持仓
    WHERE VALUE_DT >= V_BEG_THIS_YEAR
    AND VALUE_DT <= V_END_LAST_MON
    GROUP BY FIN_INSTM_ID,ASSET_TYPE_ID,MARKET_TYPE_ID
  ) D1
    ON A.FIN_INSTM_ID = D1.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = D1.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = D1.MARKET_TYPE_ID
  LEFT JOIN (
       SELECT LOAN_REF_NO
             ,REPLACE(SPECIFIC_RISK_CHARGE,'%','') AS SPECIFIC_RISK_CHARGE
             ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM
       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES  --债项填报信息表
       WHERE SPECIFIC_RISK_CHARGE <> '0.00%'
       ) E
     ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = E.LOAN_REF_NO
    AND E.NUM = 1
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON A.OBJ_ID||'_'||A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD = F.V_ID_NUMBER
   AND A.ETL_DT = F.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME LIKE '%存放同业%'
    AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURRT_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入自营资金业务余额表--委托同业代付数据';  --modify by tangan at 20221223 新增同业代付逻辑
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_BAL
  (
     DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,SUBJ_ID             --科目编号
    ,FIN_INST_ID         --金融工具编号
    ,ACC_TYP             --账户类型
    ,BIZ_LRG_CL          --业务大类
    ,BIZ_MID_CL          --业务中类
    ,BIZ_SML_CL          --业务小类
    ,PROD_NM             --产品名称
    ,CUR                 --币种
    ,HOLD_COST           --持有成本
    ,BOOK_BAL            --账面余额
    ,CURR_PFT            --本期收益
    ,CUM_PFT             --累计收益
    ,YEAR_RATE           --年化利率
    ,CR_RSK_WGT          --信用风险权重
    ,LVL5_CL             --五级分类
    ,PRO_IMPT            --减值准备
    ,VAL_DT              --起息日期
    ,EXP_DT              --到期日期
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
  )
  SELECT  V_P_DATE                AS DATA_DT             --数据日期
         ,A.LP_ID                                      AS LGL_REP_ID          --法人编号
         ,D.ORG_ID1                                    AS ORG_ID              --机构编号
         ,/*A.SUBJ_ID*/'13050701'                      AS SUBJ_ID             --科目编号
         ,A.DUBIL_ID                                   AS FIN_INST_ID         --金融工具编号
         ,'银行账户'                                   AS ACC_TYP             --账户类型
         ,'同业往来'                                   AS BIZ_LRG_CL          --业务大类
         ,'同业代付'                                   AS BIZ_MID_CL          --业务中类
         ,CASE WHEN E.CTY_RG_CD = 'CHN' THEN '代理境内同业付款'
               ELSE '代理境外同业付款'
           END                                         AS BIZ_SML_CL          --业务小类
         ,A.CUST_NAME                                  AS PROD_NM             --产品名称
         ,A.CURR_CD                                    AS CUR                 --币种
         ,A.CONT_AMT                                   AS HOLD_COST           --持有成本
         ,G.CURRT_BAL                                  AS BOOK_BAL            --账面余额
         ,G.IN_BS_INT+G.OFF_BS_INT - NVL(H.IN_BS_INT+H.OFF_BS_INT,0) AS CURR_PFT --本期收益
         ,G.IN_BS_INT+G.OFF_BS_INT                     AS CUM_PFT             --累计收益
         ,G.EXEC_INT_RAT                               AS YEAR_RATE           --年化利率
         ,0                                            AS CR_RSK_WGT          --信用风险权重
         ,CASE WHEN I.LOAN_LEVEL5_CLS_CD = '10' THEN '正常'
               WHEN I.LOAN_LEVEL5_CLS_CD = '20' THEN '关注'
               WHEN I.LOAN_LEVEL5_CLS_CD = '30' THEN '次级'
               WHEN I.LOAN_LEVEL5_CLS_CD = '40' THEN '可疑'
               WHEN I.LOAN_LEVEL5_CLS_CD = '50' THEN '损失'
               ELSE '正常'
          END                                          AS LVL5_CL             --五级分类
         ,0                                            AS PRO_IMPT            --减值准备
         ,TO_CHAR(G.VALUE_DT, 'YYYYMMDD')              AS VAL_DT              --起息日期
         ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT              --到期日期
         ,'800975'                                     AS DEPT_LINE           --部门条线 /*投行与金融机构部*/
         ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC            --数据来源
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = A.OUT_ACCT_ORG_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E
           ON E.CUST_ID = A.CUST_ID
          AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO G
           ON G.DUBIL_NUM = A.DUBIL_ID
          AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO H
           ON H.DUBIL_NUM = A.DUBIL_ID
          AND H.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO I
           ON I.DUBIL_ID = A.DUBIL_ID
          AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG I
           ON I.ORG_ID = G.OPEN_ACCT_ORG_ID
    WHERE A.PROD_ID IN ('203020700001','203020700002')
      AND A.EXP_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --未结清
      AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



   -- 如需要分析表，请用如下代码 --
       /* WITH TMP1 AS (
  SELECT DATA_DT,FIN_INST_ID,PROD_NM,COUNT(1)
    FROM RRP_MDL.M_EAST_OWN_CPTL_BAL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,FIN_INST_ID,PROD_NM
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;*/
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

  END ETL_INIT_M_EAST_OWN_CPTL_BAL;
/

