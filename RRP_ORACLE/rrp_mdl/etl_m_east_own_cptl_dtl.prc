CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_EAST_OWN_CPTL_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
*  程序名称：ETL_M_EAST_OWN_CPTL_DTL
*  功能描述：自营资金交易信息
*  创建日期：20220610
*  开发人员：梅炜
*  来源表：
*  目标表：  M_EAST_OWN_CPTL_DTL
*  配置表：  CODE_MAP
*  修改情况：序号  修改日期  修改人   修改原因
*             1    20220610  梅炜      首次创建
*             2    20221122  hulj      增加数据重复校验
*             3    20250116  LIP       优化同业代付逻辑
**************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;          --处理步骤
  V_P_DATE    VARCHAR2(8);           --跑批数据日期
  V_STARTTIME DATE;                  --处理开始时间
  V_ENDTIME   DATE;                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);         --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);         --任务名称
  V_PART_NAME VARCHAR2(100);         --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_EAST_OWN_CPTL_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_EAST_OWN_CPTL_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  V_BEG_THIS_MON DATE; --本月初
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); --获取跑批日期
  V_BEG_THIS_MON := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'); --本月初
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := 2;
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

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入自营资金交易信息-资金债券回购表出卖出回购和买入返售数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,CASE WHEN B.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
              WHEN B.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
              ELSE NULL
          END                                         AS ACC_TYP                  --账户类型
        ,NVL(B.BAG_ID,B.TRAN_ID)                      AS TRA_ID                   --交易编号
        ,B.CNTPTY_ID ||'_'|| B.TRAN_ID                AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
              ELSE NULL
          END                                         AS BIZ_MID_CL               --业务中类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
              ELSE NULL
          END                                         AS BIZ_SML_CL               --业务小类
        ,A.ASSET_TYPE_NAME||A.BUS_CATE_NAME           AS PROD_NM                  --产品名称
        ,B.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,B.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,B.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,B.REPO_INT_RAT                               AS YEAR_RATE                --年化利率
        ,TO_CHAR(B.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(B.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(B.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,B.TRAN_CLEAR_ACCT_ID                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                             OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
         END                                          AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),B.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,B.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_REPO B  --资金债券回购
      ON B.BUS_ID = A.BUS_ID
     AND B.REPO_TYPE_CD IN ('N','B') --N-质押式回购交易、B-买断式回购交易
     AND B.VALUE_DT >= V_BEG_THIS_MON
     AND B.VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D    --对公客户基本信息
      ON D.CUST_ID = B.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME LIKE '%回购%'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '插入自营资金交易信息-同业现金借贷表出卖出回购和买入返售证券数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.BUS_ID                                     AS TRA_ID                   --交易编号
        --因暂未用该部分数据，先将主键拼接起来以免主键冲突
        ,A.FIN_INSTM_ID||A.OBJ_ID                     AS FIN_INST_ID         --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
              ELSE NULL
          END                                         AS BIZ_MID_CL               --业务中类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
              ELSE NULL
          END                                         AS BIZ_SML_CL               --业务小类
        ,C.FIN_INSTM_NAME                             AS PROD_NM                  --产品名称
        ,CASE WHEN B.EXTRA_DIMEN_CD = 'L' THEN '01' --买入
              WHEN B.EXTRA_DIMEN_CD = 'S' THEN '02' --卖出
              ELSE '01' --买入
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,B.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(B.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,A.INTNAL_SECU_ACCT_ID                        AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                           OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,A.CNTPTY_ACCT_NUM                            AS CNTPR_ACC                --交易对手账号
        ,A.CNTPTY_OPEN_BANK_NUM                       AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,A.CNTPTY_OPEN_BANK_NAME                      AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800975'                                     AS DEPT_LINE                --部门条线 /*投金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
   INNER JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST B --同业证券持仓
      ON B.BUS_ID = A.BUS_ID
     AND B.TRAN_DT >= V_BEG_THIS_MON
     AND B.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CNTPTY_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME LIKE '%回购%'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 5;
  V_STEP_DESC := '插入自营资金交易信息-票据转贴现信息表出卖出回购和买入返售票据数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ACCT_INSTIT_ID                             AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.BUS_ID                                     AS TRA_ID                   --交易编号
        ,A.BILL_NUM                                   AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '买入返售'
              WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '卖出回购'
          END                                         AS BIZ_MID_CL               --业务中类
        ,CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '其他-买入返售票据'
              WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '其他-卖出回购票据'
          END                                         AS BIZ_SML_CL               --业务小类
        ,B.CD_DESCB||C.CD_DESCB                       AS PROD_NM                  --产品名称
        ,A.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.FAC_VAL_AMT                                AS CONT_AMT                 --合约金额
        ,A.DISCNT_INT_RAT                             AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.BUS_DT, 'YYYYMMDD')                AS TRA_DT                   --交易日期
        ,TO_CHAR(A.STL_DT, 'YYYYMMDD')                AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.REPO_DT, 'YYYYMMDD')               AS CONT_EXP_DT              --合同到期日期
        ,NULL                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,A.CNTPTY_BANK_NO                             AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,A.CUST_MGR_ID                                AS APRV_PSN_NO              --审批人工号
        ,A.CUST_MGR_ID                                AS HDLR_NO                  --经办人工号
        ,'800935'                                     AS DEPT_LINE                --部门条线/*票据业务事业部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD B --公共代码表 --票据类型代码
      ON B.CD_VAL = A.BILL_KIND_CD
     AND B.CD_ID = 'CD1384'
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表 --票据类型代码
      ON C.CD_VAL = A.BUS_TYPE_CD
     AND C.CD_ID = 'CD1076'
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D    --对公客户基本信息
      ON D.CUST_ID = A.CNTPTY_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.BUS_TYPE_CD IN('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
     AND A.ENTRY_STATUS_CD = '03'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.BUS_DT >= V_BEG_THIS_MON
     AND A.BUS_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 6;
  V_STEP_DESC := '插入自营资金交易信息-外汇同业拆借表出外币回购数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT DISTINCT
         TO_CHAR(A.ETL_DT,'YYYYMMDD')                 AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.CNTPTY_ID||'_'||A.BUS_ID                   AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '买入返售'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '卖出回购'
              ELSE NULL
          END                                         AS BIZ_MID_CL               --业务中类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) = '111104' THEN '买入返售证券'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '211105' THEN '卖出回购证券'
              ELSE NULL
          END                                         AS BIZ_SML_CL               --业务小类
        ,A.PORTF_NAME                                 AS PROD_NM                  --产品名称
        ,A.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.EXEC_INT_RAT                               AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,'8901575909'                                 AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表_视图
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE TRIM(A.ENTRY_ORG_ID) IS NOT NULL
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.PORTF_NAME = '外币质押式回购'
     AND A.VALUE_DT >= V_BEG_THIS_MON
     AND A.VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 7;
  V_STEP_DESC := '插入自营资金交易信息-资金债券借贷表出债券借贷数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,CASE WHEN A.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
              WHEN A.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
              ELSE NULL
          END                                         AS ACC_TYP                  --账户类型
        ,A.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.BUS_ID                                     AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,'其他'                                       AS BIZ_MID_CL               --业务中类
        ,'债券借贷'                                   AS BIZ_SML_CL               --业务小类
        ,CASE WHEN A.TRAN_DIR_CD = '01' THEN A.CNTPTY_NAME||'_债券借入'
              WHEN A.TRAN_DIR_CD = '02' THEN A.CNTPTY_NAME||'_债券借出'
          END                                         AS PROD_NM                  --产品名称
        ,A.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,B.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,A.TRAN_CLEAR_ACCT_ID                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,A.DEALER_ID                                  AS APRV_PSN_NO              --审批人工号
        ,A.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_DEBIT_CRDT A --资金债券借贷表
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON B.BOND_ID = A.UNDERLY_BOND_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND UPPER(B.DATA_SRC_SYS_IDF) = 'CTMS'
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.TRAN_DT >= V_BEG_THIS_MON
     AND A.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 8;
  V_STEP_DESC := '插入自营资金交易信息-资金同业拆借表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,CASE WHEN A.ACCT_B_ATTR_CD = 'B' THEN '银行账户'
              WHEN A.ACCT_B_ATTR_CD = 'T' THEN '交易账户'
              ELSE NULL
          END                                         AS ACC_TYP                  --账户类型
        ,A.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.BUS_ID                                     AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
              ELSE NULL
          END                                         AS BIZ_MID_CL               --业务中类
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
          END                                         AS BIZ_SML_CL               --业务小类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
              ELSE NULL
          END                                         AS PROD_NM                  --产品名称
        ,A.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.EXEC_INT_RAT                               AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,A.TRAN_CLEAR_ACCT_ID                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,A.DEALER_ID                                  AS APRV_PSN_NO              --审批人工号
        ,A.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A  --资金同业拆借表
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D    --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.TAR_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.TRAN_DT >= V_BEG_THIS_MON
     AND A.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 9;
  V_STEP_DESC := '插入自营资金交易信息-外汇同业拆借表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.CNTPTY_ID||'_'||A.BUS_ID                   AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
              ELSE NULL
         END                                          AS BIZ_MID_CL               --业务中类
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
         END                                          AS BIZ_SML_CL               --业务小类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
              ELSE NULL
         END                                          AS PROD_NM                  --产品名称
        ,A.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.EXEC_INT_RAT                               AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,NULL                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000', '820000', '710000')
                           OR NVL(TRIM(D.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
         END                                          AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.PORTF_NAME = '外币拆借'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.VALUE_DT >= V_BEG_THIS_MON
     AND A.VALUE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 10;
  V_STEP_DESC := '插入自营资金交易信息-同业现金借贷表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.BUS_ID                                     AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID                               AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,6) = '130203' THEN '同业借款'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' AND SUBSTR(A.SUBJ_ID,1,6) <> '130203' THEN '拆出'
              ELSE NULL
          END                                         AS BIZ_MID_CL               --业务中类
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
          END                                         AS BIZ_SML_CL               --业务小类
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '同业拆入'
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '拆放同业'
              ELSE NULL
          END                                         AS PROD_NM                  --产品名称
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '01' --买入
              WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '02' --卖出
              ELSE NULL
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,ABS(A.EXEC_INT_RAT)                          AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,A.INTNAL_SECU_ACCT_ID                        AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                              OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,A.CNTPTY_ACCT_NUM                            AS CNTPR_ACC                --交易对手账号
        ,A.CNTPTY_OPEN_BANK_NUM                       AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,A.CNTPTY_OPEN_BANK_NAME                      AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800975'                                     AS DEPT_LINE                --部门条线/*投金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
   INNER JOIN (SELECT BUS_ID FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') GROUP BY BUS_ID) B  --同业证券持仓
      ON B.BUS_ID = A.BUS_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CNTPTY_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE SUBSTR(A.SUBJ_ID,1,4) IN ('1302','2003')
     --AND A.ASSET_TYPE_NAME NOT LIKE '%回购%' --踢掉回购部分
     AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 11;
  V_STEP_DESC := '插入自营资金交易信息-资金债券投资表出同业存单投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,CASE WHEN A.ACCT_ATTR_CD = 'B' THEN '银行账户'
              WHEN A.ACCT_ATTR_CD = 'T' THEN '交易账户'
              ELSE NULL
          END                                         AS ACC_TYP                  --账户类型
        ,T.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.BOND_ID                                    AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,'同业存单'                                   AS BIZ_MID_CL               --业务中类
        ,'同业存单投资'                               AS BIZ_SML_CL               --业务小类
        ,A.BOND_NAME                                  AS PROD_NM                  --产品名称
        ,T.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,NVL(TRIM(T.CURR_CD),A.CURR_CD)               AS CONT_CUR                 --合约币种
        ,T.STL_AMT                                    AS CONT_AMT                 --合约金额
        ,CASE WHEN NVL(TRIM(A.FAC_VAL_INT_RAT),0) <> 0 THEN A.FAC_VAL_INT_RAT
              ELSE NVL(TRIM(B.ISSUE_INT_RAT),0)*1
          END                                         AS YEAR_RATE                --年化利率
        ,TO_CHAR(T.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.TRAN_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.CNTPTY_ACCT_ID
              ELSE NULL
          END                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (T.CNTPTY_NAME LIKE '%银行%' OR T.CNTPTY_NAME LIKE '%农村信用合作%'
                   OR T.CNTPTY_NAME LIKE '%农商%' OR T.CNTPTY_NAME LIKE '%农联社%'
                   OR T.CNTPTY_NAME LIKE '%农村信用联社%')
                   AND T.CNTPTY_NAME NOT LIKE '%理财%'
                   AND T.CNTPTY_NAME NOT LIKE '%信托%'
                   AND T.CNTPTY_NAME NOT LIKE '%基金%'
                   AND T.CNTPTY_NAME NOT LIKE '%系列%'
                   AND T.CNTPTY_NAME NOT LIKE '%资管%'
                   AND T.CNTPTY_NAME NOT LIKE '%计划%'
                   AND T.CNTPTY_NAME NOT LIKE '%号%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,T.CNTPTY_NAME                                AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_ID
              ELSE NULL
          END                                         AS CNTPR_ACC                --交易对手账号
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_NO
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_NO
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        /*,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_BANK_NAME
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_BANK_NAME
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名*/
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,T.DEALER_ID                                  AS APRV_PSN_NO              --审批人工号
        ,T.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T --资金现券交易
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A  --资金债券投资表
      ON A.BOND_ID = T.BOND_ID
     AND A.TRAN_ACCT_B_ID = T.TRAN_ACCT_B_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
      ON B.BOND_ID = A.BOND_ID
     AND B.BOND_TYPE_CD = 'W' --同业存单
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(A.SUBJ_ID) IS NOT NULL
     --AND A.TRAN_ACCT_B_ID IN ('200','201','202') --200-交易性金融资产、201-可供出售金融资产、202-持有至到期金融资产
     AND T.STL_DT >= V_BEG_THIS_MON
     AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 12;
  V_STEP_DESC := '插入自营资金交易信息--同业证券持仓表出同业存单发行数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT DISTINCT
         TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.TRAN_NUM                                   AS TRA_ID                   --交易编号
        /*,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号*/
        --因暂未用该部分数据，先将主键拼接起来以免主键冲突
        ,A.FIN_INSTM_ID||A.OBJ_ID                     AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,'同业存单'                                   AS BIZ_MID_CL               --业务中类
        ,'同业存单发行'                               AS BIZ_SML_CL               --业务小类
        ,D.FIN_INSTM_NAME                             AS PROD_NM                  --产品名称
        ,CASE WHEN A.EXTRA_DIMEN_CD = 'L' THEN '01'
              WHEN A.EXTRA_DIMEN_CD = 'S' THEN '02'
              ELSE '01'
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,ABS(A.NET_PRICE_COST)                        AS CONT_AMT                 --合约金额
        ,A.ACTL_INT_RAT                               AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,'800001011003020003'                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (C.CNTPTY_NAME LIKE '%银行%' OR C.CNTPTY_NAME LIKE '%农村信用合作%'
                   OR C.CNTPTY_NAME LIKE '%农商%' OR C.CNTPTY_NAME LIKE '%农联社%'
                   OR C.CNTPTY_NAME LIKE '%农村信用联社%')
                   AND C.CNTPTY_NAME NOT LIKE '%理财%'
                   AND C.CNTPTY_NAME NOT LIKE '%信托%'
                   AND C.CNTPTY_NAME NOT LIKE '%基金%'
                   AND C.CNTPTY_NAME NOT LIKE '%系列%'
                   AND C.CNTPTY_NAME NOT LIKE '%资管%'
                   AND C.CNTPTY_NAME NOT LIKE '%计划%'
                   AND C.CNTPTY_NAME NOT LIKE '%号%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,C.CNTPTY_NAME                                AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,C.CNTPTY_ACCT_NUM                            AS CNTPR_ACC                --交易对手账号
        ,C.CNTPTY_OPEN_BANK_NUM                       AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,C.CNTPTY_OPEN_BANK_NAME                      AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,C.CHECKER_ID                                 AS APRV_PSN_NO              --审批人工号
        ,C.OPERR_ID                                   AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A  --同业证券持仓表
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN C --同业交易表
      ON C.INTNAL_TRAN_NUM = A.TRAN_NUM
     AND C.CFM_DT = A.TRAN_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM D --同业金融工具
      ON D.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND D.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND D.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ASSET_TYPE_NAME LIKE '%同业存单%'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.TRAN_DT >= V_BEG_THIS_MON
     AND A.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 13;
  V_STEP_DESC := '插入自营资金交易信息--同业证券持仓表出同业存单发行数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,T.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,B.BOND_ID                                    AS FIN_INST_ID              --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,'债券发行'                                   AS BIZ_MID_CL               --业务中类
        ,CASE WHEN B.BOND_TYPE_CD IN ('7','71','X') THEN '银行次级债'
              WHEN B.BOND_TYPE_CD = 'Y' THEN '银行永续债'
              ELSE NULL
          END                                         AS BIZ_SML_CL               --业务小类
        ,B.BOND_ABBR                                  AS PROD_NM                  --产品名称
        ,T.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,NVL(TRIM(T.CURR_CD),A.CURR_CD)               AS CONT_CUR                 --合约币种
        ,T.BOND_FAC_VAL                               AS CONT_AMT                 --合约金额
        ,T.EXP_YLD_RAT                                AS YEAR_RATE                --年化利率
        ,TO_CHAR(T.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.TRAN_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.CNTPTY_ACCT_ID
              ELSE NULL
          END                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (T.CNTPTY_NAME LIKE '%银行%' OR T.CNTPTY_NAME LIKE '%农村信用合作%'
                   OR T.CNTPTY_NAME LIKE '%农商%' OR T.CNTPTY_NAME LIKE '%农联社%'
                   OR T.CNTPTY_NAME LIKE '%农村信用联社%')
                   AND T.CNTPTY_NAME NOT LIKE '%理财%'
                   AND T.CNTPTY_NAME NOT LIKE '%信托%'
                   AND T.CNTPTY_NAME NOT LIKE '%基金%'
                   AND T.CNTPTY_NAME NOT LIKE '%系列%'
                   AND T.CNTPTY_NAME NOT LIKE '%资管%'
                   AND T.CNTPTY_NAME NOT LIKE '%计划%'
                   AND T.CNTPTY_NAME NOT LIKE '%号%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,T.CNTPTY_NAME                                AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_ID
              ELSE NULL
          END                                         AS CNTPR_ACC                --交易对手账号
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_NO
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_NO
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        /*,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_BANK_NAME
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_BANK_NAME
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名*/
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,T.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线 /*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T --资金现券交易
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
      ON A.BOND_ID = T.BOND_ID
     AND A.ASSET_TYPE_NAME = '债券发行'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON B.BOND_ID = A.MAIN_ASSET_ID
     AND B.BOND_TYPE_CD IN ('7','71','X','Y')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(A.SUBJ_ID) IS NOT NULL
     AND T.STL_DT >= V_BEG_THIS_MON
     AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 14;
  V_STEP_DESC := '插入自营资金交易信息--资金债券投资表出债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,CASE WHEN A.ACCT_ATTR_CD = 'B' THEN '银行账户'
              WHEN A.ACCT_ATTR_CD = 'T' THEN '交易账户'
              ELSE NULL
          END                                         AS ACC_TYP                  --账户类型
        ,T.TRAN_ID                                    AS TRA_ID                   --交易编号
        ,A.BOND_ID                                    AS FIN_INST_ID              --金融工具编号
        ,'债券投资与同业投资'                         AS BIZ_LRG_CL               --业务大类
        ,'债券投资'                                   AS BIZ_MID_CL               --业务中类
        ,CASE WHEN B.BOND_TYPE_CD = '1' THEN '国债'
              WHEN B.BOND_TYPE_CD = '5' THEN '央票'
              WHEN B.BOND_TYPE_CD = 'M' THEN '地方政府债'
              WHEN B.BOND_TYPE_CD = 'Q' THEN '政府支持机构债'
              WHEN B.ISSUER_NAME  IN ('中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '政策性金融债'
              WHEN B.BOND_TYPE_CD IN ('61','9','C','C1','C2','C3','C4','C5','C6','U','X','Y') THEN '商业性金融债'
              WHEN B.BOND_TYPE_CD IN ('4','6','D','E','G','H','I','J','N','O','P','V') THEN '非金融企业债券'
              WHEN B.BOND_TYPE_CD = 'L' /*AND A.TRAN_ACCT_B_ID = 'FVTPL'*/ THEN '资产支持证券（信贷资产证券化）' --据银鹏反馈，调整债券类型为L的都归为资产支持证券（信贷资产证券化）
              --WHEN B.BOND_TYPE_CD = 'L' AND A.ASSET_THD_CLS_CD <> 'FVTPL' THEN '资产支持证券（交易所资产支持证券）'
              WHEN B.BOND_TYPE_CD = 'L1' THEN '资产支持证券（资产支持票据）'
              WHEN B.BOND_TYPE_CD IN ('F','FL','FG') THEN '外国债券'
              ELSE '其他-'||D.CD_DESCB
          END                                         AS BIZ_SML_CL               --业务小类
        ,B.BOND_ABBR                                  AS PROD_NM                  --产品名称
        ,T.TRAN_DIR_CD                                AS TRA_DIR                  --交易方向
        ,NVL(TRIM(T.CURR_CD),A.CURR_CD)               AS CONT_CUR                 --合约币种
        ,T.STL_AMT                                    AS CONT_AMT                 --合约金额
        ,CASE WHEN NVL(TRIM(A.FAC_VAL_INT_RAT),0) <> 0 THEN A.FAC_VAL_INT_RAT
              ELSE NVL(TRIM(B.ISSUE_INT_RAT),0)*1
          END                                         AS YEAR_RATE                --年化利率
        ,TO_CHAR(T.STL_DT, 'YYYYMMDD')                AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.TRAN_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.CNTPTY_ACCT_ID
              ELSE NULL
          END                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (T.CNTPTY_NAME LIKE '%银行%' OR T.CNTPTY_NAME LIKE '%农村信用合作%'
                   OR T.CNTPTY_NAME LIKE '%农商%' OR T.CNTPTY_NAME LIKE '%农联社%'
                   OR T.CNTPTY_NAME LIKE '%农村信用联社%' OR T.CNTPTY_NAME LIKE '%商行%'
                   OR T.CNTPTY_NAME LIKE '%渣打%')
                   AND T.CNTPTY_NAME NOT LIKE '%理财%'
                   AND T.CNTPTY_NAME NOT LIKE '%信托%'
                   AND T.CNTPTY_NAME NOT LIKE '%基金%'
                   AND T.CNTPTY_NAME NOT LIKE '%系列%'
                   AND T.CNTPTY_NAME NOT LIKE '%资管%'
                   AND T.CNTPTY_NAME NOT LIKE '%计划%'
                   AND T.CNTPTY_NAME NOT LIKE '%号%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,T.CNTPTY_NAME                                AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_ID
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_ID
              ELSE NULL
          END                                         AS CNTPR_ACC                --交易对手账号
        ,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_NO
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_NO
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        /*,CASE WHEN T.TRAN_DIR_CD = '01' THEN T.CNTPTY_ACCT_OPEN_BANK_BANK_NAME
              WHEN T.TRAN_DIR_CD = '02' THEN T.TRAN_ACCT_OPEN_BANK_BANK_NAME
              ELSE NULL
          END                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名*/
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,T.DEALER_ID                                  AS APRV_PSN_NO              --审批人工号
        ,T.DEALER_ID                                  AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线 /*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T --资金现券交易
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A  --资金债券投资表
      ON A.BOND_ID = T.BOND_ID
     AND A.TRAN_ACCT_B_ID = T.TRAN_ACCT_B_ID
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.BUS_CATE_NAME IN ('现券','债券负债')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
      ON B.BOND_ID = A.BOND_ID
     AND NVL(TRIM(B.BOND_TYPE_CD),' ') NOT IN ('W',' ')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD D --数仓码值表 --债券类型代码
      ON D.CD_VAL = B.BOND_TYPE_CD
     AND D.CD_ID = 'CD1486'
   WHERE T.STL_DT >= V_BEG_THIS_MON
     AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP :=15;
  V_STEP_DESC := '插入自营资金交易信息--同业债券投资表出债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        /*,A.BUS_ID||A.OBJ_ID                           AS TRA_ID                   --交易编号*/
        --,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID              --金融工具编号
        ,A.OBJ_ID                                     AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号
        ,'债券投资与同业投资'                         AS BIZ_LRG_CL               --业务大类
        ,'债券投资'                                   AS BIZ_MID_CL               --业务中类
        ,CASE WHEN A.ASSET_TYPE_NAME LIKE '资产支持证券%' THEN '资产支持证券（交易所资产支持证券）'
              WHEN A.ASSET_TYPE_NAME IN ('一般公司债','一般企业债') THEN '非金融企业债券'
              WHEN A.ISSUER_NAME IN ('中国进出口银行','中国农业发展银行','国家开发银行') THEN '政策性金融债'
              ELSE '商业性金融债'
          END                                         AS BIZ_SML_CL               --业务小类
        ,A.BOND_NAME                                  AS PROD_NM                  --产品名称
        ,CASE WHEN A.EXTRA_DIMEN_CD = 'L' THEN '01'
              WHEN A.EXTRA_DIMEN_CD = 'S' THEN '02'
              ELSE '01'
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.BOOK_BAL                                   AS CONT_AMT                 --合约金额
        ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.LAST_UPDATE_DT, 'YYYYMMDD')        AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,NULL                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              WHEN TRIM(E.TAR_VALUE_CODE) IS NOT NULL
                   OR NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%理财%'
                   OR NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%信托%'
                   OR NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%基金%'
                   OR NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%系列%' THEN '非银行业金融机构'
              WHEN NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME) LIKE '%政府%' THEN '政府机关'
              ELSE '公司客户'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A  --同业债券投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = C.ISSUER_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.CAP_TYPE_CD = '0' --自营
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
     AND A.LAST_UPDATE_DT >= V_BEG_THIS_MON
     AND A.LAST_UPDATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 16;
  V_STEP_DESC := '插入自营资金交易信息--同业非标投资表出资产支持证券（资产支持票据）和公募基金投资、资产管理产品投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        /*,A.BUS_ID|| A.OBJ_ID                          AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号*/
        ,A.OBJ_ID                                     AS TRA_ID                   --交易编号
        --因暂未用该部分数据，先将主键拼接起来以免主键冲突
        ,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号
        ,'债券投资与同业投资'                         AS BIZ_LRG_CL               --业务大类
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
          END                                         AS BIZ_MID_CL               --业务中类
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
          END                                         AS BIZ_SML_CL               --业务小类
        ,C.FIN_INSTM_NAME                             AS PROD_NM                  --产品名称
        ,CASE WHEN A.EXTRA_DIMEN_CD = 'L' THEN '01'
              WHEN A.EXTRA_DIMEN_CD = 'S' THEN '02'
              ELSE '01'
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.LAST_UPDATE_DT, 'YYYYMMDD')        AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,NULL                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%系列%' THEN '银行业金融机构'
              WHEN TRIM(E.TAR_VALUE_CODE) IS NOT NULL
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%理财%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%信托%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%基金%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%系列%' THEN '非银行业金融机构'
              WHEN NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%政府%' THEN '政府机关'
              ELSE '公司客户'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) AS CNTPR_NM --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CNTPTY_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME NOT LIKE '%货币基金%'
     --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.LAST_UPDATE_DT >= V_BEG_THIS_MON
     AND A.LAST_UPDATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 17;
  V_STEP_DESC := '插入自营资金交易信息--同业净值型产品投资表出资产管理计划、债券基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        /*,A.BUS_ID|| A.OBJ_ID                          AS TRA_ID                    --交易编号
        ,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号*/
        ,A.OBJ_ID                                     AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID                               AS FIN_INST_ID              --金融工具编号
        ,'债券投资与同业投资'                         AS BIZ_LRG_CL               --业务大类
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
          END                                         AS BIZ_MID_CL               --业务中类
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
          END                                         AS BIZ_SML_CL               --业务小类
        ,B.FIN_INSTM_NAME /*A.ASSET_TYPE_NAME*/       AS PROD_NM                  --产品名称
        ,CASE WHEN A.EXTRA_DIMEN_CD = 'L' THEN '01'
              WHEN A.EXTRA_DIMEN_CD = 'S' THEN '02'
              ELSE '01'
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.BOOK_BAL                                   AS CONT_AMT                 --合约金额
        ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,NULL                                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL    THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) NOT LIKE '%系列%' THEN '银行业金融机构'
              WHEN TRIM(E.TAR_VALUE_CODE) IS NOT NULL
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%理财%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%信托%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%基金%'
                   OR NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%系列%' THEN '非银行业金融机构'
              WHEN NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) LIKE '%政府%' THEN '政府机关'
              ELSE '公司客户'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) AS CNTPR_NM --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线 /*资金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM B --同业金融工具
      ON B.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND B.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND B.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO C --债券基本信息
      ON C.BOND_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND CASE WHEN C.DATA_SRC_SYS_IDF = 'CTMS' THEN 'X_CNBD' ELSE C.BOND_MARKET_TYPE_CD END = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = C.ISSUER_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE TRIM(A.SUBJ_ID) IS NOT NULL
     --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
     AND A.LAST_UPDATE_DT >= V_BEG_THIS_MON
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 18;
  V_STEP_DESC := '插入自营资金交易信息--同业证券持仓表出货币基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT DISTINCT
         V_P_DATE                                     AS DATA_DT                  --数据日期
        ,B.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,NVL(TRIM(B.BELONG_ORG_ID),'896821')          AS ORG_ID                   --机构编号
        ,'1101020301'                                 AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,A.INTNAL_TRAN_NUM                            AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID                               AS FIN_INST_ID              --金融工具编号
        ,'债券投资与同业投资'                         AS BIZ_LRG_CL               --业务大类
        ,'公募基金投资'                               AS BIZ_MID_CL               --业务中类
        ,'货币市场基金'                               AS BIZ_SML_CL               --业务小类
        ,B.FIN_INSTM_NAME                             AS PROD_NM                  --产品名称
        ,CASE WHEN NVL(TRIM(A.REDEM_TYPE_CD),'B') = 'B' THEN '01'
              ELSE '02'
          END                                         AS TRA_DIR                  --交易方向
        ,B.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,A.TRAN_QTTY                                  AS CONT_AMT                 --合约金额
        ,B.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(A.CFM_DT, 'YYYYMMDD')                AS TRA_DT                   --交易日期
        ,TO_CHAR(A.CFM_DT, 'YYYYMMDD')                AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.TERM_END_DAY, 'YYYYMMDD')          AS CONT_EXP_DT              --合同到期日期
        ,'800001011003020003'                         AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (A.CNTPTY_NAME LIKE '%银行%' OR A.CNTPTY_NAME LIKE '%农村信用合作%'
                   OR A.CNTPTY_NAME LIKE '%农商%' OR A.CNTPTY_NAME LIKE '%农联社%'
                   OR A.CNTPTY_NAME LIKE '%农村信用联社%')
                   AND A.CNTPTY_NAME NOT LIKE '%理财%'
                   AND A.CNTPTY_NAME NOT LIKE '%信托%'
                   AND A.CNTPTY_NAME NOT LIKE '%基金%'
                   AND A.CNTPTY_NAME NOT LIKE '%系列%'
                   AND A.CNTPTY_NAME NOT LIKE '%资管%'
                   AND A.CNTPTY_NAME NOT LIKE '%计划%'
                   AND A.CNTPTY_NAME NOT LIKE '%号%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,A.CNTPTY_NAME                                AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,A.CNTPTY_ACCT_NUM                            AS CNTPR_ACC                --交易对手账号
        ,A.CNTPTY_OPEN_BANK_NUM                       AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,A.CNTPTY_OPEN_BANK_NAME                      AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,A.CHECKER_ID                                 AS APRV_PSN_NO              --审批人工号
        ,A.OPERR_ID                                   AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线/*资金部*/
        ,SUBSTR(B.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_IML_EVT_IBANK_TRAN A --同业交易表
   INNER JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM B --同业金融工具
      ON B.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND B.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND B.MARKET_TYPE_ID = A.TRAN_MARKET_ID
     AND B.ASSET_TYPE_NAME LIKE '%货币基金%'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_STATUS_CD = '4'
     AND A.TRAN_AMT <> 0 --MOD BY 20240517 过滤交易金额为0的数据
     AND A.CFM_DT >= V_BEG_THIS_MON
     AND A.CFM_DT <= TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 19;
  V_STEP_DESC := '插入自营资金交易信息--同业现金借贷表出非结算性存放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        /*,A.OBJ_ID                                     AS TRA_ID                   --交易编号
        ,A.FIN_INSTM_ID ||A.OBJ_ID                    AS FIN_INST_ID              --金融工具编号*/
        ,A.BUS_ID                                     AS TRA_ID                   --交易编号
        --因暂未用该部分数据，先将主键拼接起来以免主键冲突
        ,A.FIN_INSTM_ID||A.OBJ_ID                     AS FIN_INST_ID         --金融工具编号
        ,'同业往来'                                   AS BIZ_LRG_CL               --业务大类
        ,'存放同业'                                   AS BIZ_MID_CL               --业务中类
        ,'非结算性存放同业'                           AS BIZ_SML_CL               --业务小类
        ,C.FIN_INSTM_NAME                             AS PROD_NM                  --产品名称
        ,CASE WHEN B.EXTRA_DIMEN_CD = 'L' THEN '01' --买入
              WHEN B.EXTRA_DIMEN_CD = 'S' THEN '02' --卖出
              ELSE '01' --买入
          END                                         AS TRA_DIR                  --交易方向
        ,A.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,B.TRAN_AMT                                   AS CONT_AMT                 --合约金额
        ,A.FAC_VAL_INT_RAT                            AS YEAR_RATE                --年化利率
        ,TO_CHAR(B.TRAN_DT, 'YYYYMMDD')               AS TRA_DT                   --交易日期
        ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,A.INTNAL_SECU_ACCT_ID                        AS LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(D.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(D.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(E.TAR_VALUE_CODE) IS NOT NULL THEN '境外金融机构'
              WHEN SUBSTR(E.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%银行%'
                    OR NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                         AS CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS CNTPR_NM                 --交易对手名称
        ,D.CRDT_CUST_RISK_RATING_CD                   AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,A.CNTPTY_ACCT_NUM                            AS CNTPR_ACC                --交易对手账号
        ,A.CNTPTY_OPEN_BANK_NUM                       AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,A.CNTPTY_OPEN_BANK_NAME                      AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800975'                                     AS DEPT_LINE                --部门条线/*投金部*/
        ,SUBSTR(A.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
   INNER JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST B --同业证券持仓
      ON B.BUS_ID = A.BUS_ID
     AND B.TRAN_DT >= V_BEG_THIS_MON
     AND B.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON D.CUST_ID = A.CNTPTY_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = D.CRDT_CUST_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2074' --信贷客户类型代码
     AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME LIKE '%存放同业%'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入自营资金交易信息--资金系统自然到期数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT TO_CHAR(B.ETL_DT, 'YYYYMMDD')                AS DATA_DT                  --数据日期
        ,B.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,'896821'                                     AS ORG_ID                   --机构编号
        ,CASE WHEN T.ASSETTYPE = '交易性金融资产' THEN
               CASE WHEN B.ISSUER_NAME IN('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '1101011501'
                    WHEN B.ISSUER_NAME  IN( '中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '1101011301'
                    WHEN B.BOND_TYPE_CD IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '1101011401'
                    WHEN B.BOND_TYPE_CD = '1' THEN '1101011101'
                    WHEN B.BOND_TYPE_CD = '5' THEN '1101011201'
                    WHEN B.ISSUER_NAME = '中央汇金投资有限责任公司' OR B.BOND_TYPE_CD IN ('N','6','O','P','V','4','E','L1','D','J') THEN '1101011601'
                    WHEN B.BOND_TYPE_CD = 'M' THEN '1101011701'
                    WHEN B.BOND_TYPE_CD = 'W' THEN '1101011901'
                    WHEN B.BOND_TYPE_CD = 'Z' THEN '1101012001'
                    ELSE '1101011801' END
              WHEN T.ASSETTYPE = '可供出售金融资产' THEN
               CASE WHEN B.ISSUER_NAME IN('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15031501'
                    WHEN B.ISSUER_NAME  IN( '中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '15031301'
                    WHEN B.BOND_TYPE_CD IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '15031401'
                    WHEN B.BOND_TYPE_CD = '1' THEN '15031101'
                    WHEN B.BOND_TYPE_CD = '5' THEN '15031201'
                    WHEN B.ISSUER_NAME IN('中央汇金投资有限责任公司')  OR B.BOND_TYPE_CD IN ('N','6','O','P','V','4','E','L1','D','J') THEN '15031601'
                    WHEN B.BOND_TYPE_CD = 'M' THEN '15031701'
                    WHEN B.BOND_TYPE_CD = 'W' THEN '15032001'
                    WHEN B.BOND_TYPE_CD = 'Z' THEN '15032501'
                    ELSE '15031801' END
              WHEN T.ASSETTYPE = '持有至到期投资'  THEN
               CASE  WHEN B.ISSUER_NAME IN('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15011501'
                     WHEN B.ISSUER_NAME  IN( '中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '15011301'
                     WHEN B.BOND_TYPE_CD IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '15011401'
                     WHEN B.BOND_TYPE_CD = '1' THEN '15011101'
                     WHEN B.BOND_TYPE_CD = '5' THEN '15011201'
                     WHEN B.ISSUER_NAME IN('中央汇金投资有限责任公司')  OR B.BOND_TYPE_CD IN ('N','6','O','P','V','4','E','L1','D','J') THEN '15011601'
                     WHEN B.BOND_TYPE_CD = 'M' THEN '15011701'
                     WHEN B.BOND_TYPE_CD = 'W' THEN '15011901'
                     WHEN B.BOND_TYPE_CD = 'Z' THEN '15012001'
                    ELSE '15011801' END
         END                                          AS SUBJ_ID                  --明细科目编号
        ,'银行账户'                                   AS ACC_TYP                  --账户类型
        ,TO_CHAR(T.DEAL_NAME || '_' || T.DEAL_ID)     AS TRA_ID                   --交易编号
        ,T.BONDSCODE                                  AS FIN_INST_ID              --金融工具编号
        ,CASE WHEN B.BOND_TYPE_CD = 'W' THEN '同业往来'
              ELSE '债券投资与同业投资'
         END                                          AS BIZ_LRG_CL               --业务大类
        ,CASE WHEN B.BOND_TYPE_CD = 'W' THEN '同业存单'
              ELSE '债券投资'
         END                                          AS BIZ_MID_CL               --业务中类
        ,CASE WHEN B.BOND_TYPE_CD = 'W' THEN '同业存单投资'
              WHEN B.BOND_TYPE_CD = '1' THEN '国债'
              WHEN B.BOND_TYPE_CD = 'M' THEN '地方政府债'
              WHEN B.BOND_TYPE_CD = '5' THEN '央票'
              WHEN B.BOND_TYPE_CD = 'Q' THEN '政府支持机构债'
              WHEN B.ISSUER_NAME  IN( '中国进出口银行','中国农业发展银行','国家开发银行')  OR B.BOND_TYPE_CD = '8' THEN '政策性金融债'
              WHEN B.BOND_TYPE_CD IN ('61','C1','C2','C3','C4','C5','C6','C9','7','U','9','L','X','Y') THEN '商业性金融债'
              WHEN B.BOND_TYPE_CD IN ('N','6','O','P','V','4','E','G','D','J','I','H') THEN '非金融企业债券'
              WHEN B.BOND_TYPE_CD = 'L' THEN '资产支持证券（信贷资产证券化）'
              WHEN B.BOND_TYPE_CD = 'L1' THEN '资产支持证券（资产支持票据）'
              WHEN B.BOND_TYPE_CD IN('F','FL','FG') THEN '外国债券'
              ELSE '其他-'||D.CD_DESCB
         END                                          AS BIZ_SML_CL               --业务小类
        ,B.BOND_ABBR                                  AS PROD_NM                  --产品名称
        ,'02'                                         AS TRA_DIR                  --交易方向
        ,B.CURR_CD                                    AS CONT_CUR                 --合约币种
        ,T.PRINCIPALAMOUNT + T.INTERESTAMOUNT         AS CONT_AMT                 --合约金额
        ,NVL(TRIM(B.EXP_YLD_RAT),B.FAC_VAL_INT_RAT)   AS YEAR_RATE                --年化利率
        ,T.ACT_PAYDATE                                AS TRA_DT                   --交易日期
        ,T.ACT_PAYDATE                                AS CONT_START_DT            --合同起始日期
        ,TO_CHAR(B.EXP_DT, 'YYYYMMDD')                AS CONT_EXP_DT              --合同到期日期
        ,'800001011003020003'                         AS LIQ_ACC                  --本方清算账号
        ,NULL                                         AS CNTPR_TYP                --交易对手类别
        ,NULL                                         AS CNTPR_NM                 --交易对手名称
        ,NULL                                         AS CNTPR_RTG                --交易对手评级
        ,NULL                                         AS CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,NULL                                         AS CNTPR_ACC                --交易对手账号
        ,NULL                                         AS CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,NULL                                         AS CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                          AS ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                         AS APRV_PSN_NO              --审批人工号
        ,NULL                                         AS HDLR_NO                  --经办人工号
        ,'800976'                                     AS DEPT_LINE                --部门条线
        ,SUBSTR(B.JOB_CD, 0, 4)                       AS DATA_SRC                 --数据来源
    FROM RRP_MDL.O_IOL_CTMS_TBS_V_COUPONDEALS T
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
      ON B.BOND_ID = T.BONDSCODE
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD D --数仓码值表
      ON D.CD_VAL = B.BOND_TYPE_CD
     AND D.CD_ID = 'CD1486' --债券类型代码
   WHERE T.ASSETTYPE IN ('交易性金融资产', '可供出售金融资产', '持有至到期投资')
     AND T.PRINCIPALAMOUNT > 0
     AND T.ACT_PAYDATE >= TO_CHAR(V_BEG_THIS_MON,'YYYYMMDD')
     AND T.ACT_PAYDATE <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  V_STEP := 20;
  V_STEP_DESC := '插入自营资金交易信息--同业代付';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_OWN_CPTL_DTL
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --明细科目编号
    ,ACC_TYP                  --账户类型
    ,TRA_ID                   --交易编号
    ,FIN_INST_ID              --金融工具编号
    ,BIZ_LRG_CL               --业务大类
    ,BIZ_MID_CL               --业务中类
    ,BIZ_SML_CL               --业务小类
    ,PROD_NM                  --产品名称
    ,TRA_DIR                  --交易方向
    ,CONT_CUR                 --合约币种
    ,CONT_AMT                 --合约金额
    ,YEAR_RATE                --年化利率
    ,TRA_DT                   --交易日期
    ,CONT_START_DT            --合同起始日期
    ,CONT_EXP_DT              --合同到期日期
    ,LIQ_ACC                  --本方清算账号
    ,CNTPR_TYP                --交易对手类别
    ,CNTPR_NM                 --交易对手名称
    ,CNTPR_RTG                --交易对手评级
    ,CNTPR_RTG_ORG_NM         --交易对手评级机构
    ,CNTPR_ACC                --交易对手账号
    ,CNTPR_OPEN_BANK_NO       --交易对手开户行号
    ,CNTPR_OPEN_BANK_NM       --交易对手开户行名
    ,ENTRS_MGT_FLG            --委托管理标志
    ,APRV_PSN_NO              --审批人工号
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT V_P_DATE                                   DATA_DT                  --数据日期
        ,A.LP_ID                                    LGL_REP_ID               --法人编号
        ,A.OUT_ACCT_ORG_ID                          ORG_ID                   --机构编号
        ,'13050701'                                 SUBJ_ID                  --明细科目编号
        ,'银行账户'                                 ACC_TYP                  --账户类型
        ,A.OUT_ACCT_FLOW_NUM                        TRA_ID                   --交易编号
        ,A.DUBIL_ID                                 FIN_INST_ID              --金融工具编号
        ,'同业往来'                                 BIZ_LRG_CL               --业务大类
        ,'同业代付'                                 BIZ_MID_CL               --业务中类
        ,CASE WHEN C.CTY_RG_CD = 'CHN' THEN '代理境内同业付款'
              ELSE '代理境外同业付款'
          END                                       BIZ_SML_CL               --业务小类
        ,TRIM(B.ERA_PAY_BANK_NAME)                  PROD_NM                  --产品名称
        ,'02'                                       TRA_DIR                  --交易方向
        ,A.CURR_CD                                  CONT_CUR                 --合约币种
        ,A.CONT_AMT                                 CONT_AMT                 --合约金额
        ,A.EXEC_INT_RAT                             YEAR_RATE                --年化利率
        ,TO_CHAR(A.DISTR_DT, 'YYYYMMDD')            TRA_DT                   --交易日期
        ,TO_CHAR(A.DISTR_DT, 'YYYYMMDD')            CONT_START_DT            --合同起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')              CONT_EXP_DT              --合同到期日期
        ,TRIM(A.ENTER_ID)                           LIQ_ACC                  --本方清算账号
        ,CASE WHEN (CASE WHEN (TRIM(C.RG_CD) IN ('810000','820000','710000')
                               OR NVL(TRIM(C.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111'))
                         THEN 'Y' ELSE 'N' END) = 'Y'
                   AND TRIM(COD1.TAR_VALUE_CODE) IS NOT NULL THEN '境外金融机构'
              WHEN SUBSTR(COD1.TAR_VALUE_CODE,1,1) IN ('C','D') THEN '银行业金融机构'
              WHEN (NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) LIKE '%银行%'
                    OR NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) LIKE '%农村信用合作%')
                   AND NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) NOT LIKE '%理财%'
                   AND NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) NOT LIKE '%信托%'
                   AND NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) NOT LIKE '%基金%'
                   AND NVL(TRIM(C.CUST_NAME),B.ERA_PAY_BANK_NAME) NOT LIKE '%系列%' THEN '银行业金融机构'
              ELSE '非银行业金融机构'
          END                                       CNTPR_TYP                --交易对手类别
        ,NVL(TRIM(C.CUST_NAME),TRIM(B.ERA_PAY_BANK_NAME)) CNTPR_NM           --交易对手名称
        ,TRIM(C.CRDT_CUST_RISK_RATING_CD)           CNTPR_RTG                --交易对手评级
        ,NULL                                       CNTPR_RTG_ORG_NM         --交易对手评级机构
        ,'0'                                        CNTPR_ACC                --交易对手账号
        ,'0'                                        CNTPR_OPEN_BANK_NO       --交易对手开户行号
        ,'0'                                        CNTPR_OPEN_BANK_NM       --交易对手开户行名
        ,'N'                                        ENTRS_MGT_FLG            --委托管理标志
        ,NULL                                       APRV_PSN_NO              --审批人工号
        ,TRIM(A.BUS_OPER_TELLER_ID)                 HDLR_NO                  --经办人工号
        ,'800975'                                   DEPT_LINE                --部门条线
        ,SUBSTR(A.JOB_CD, 0, 4)                     DATA_SRC                 --数据来源
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H B --贷款出账对公贷款附属信息历史
      ON B.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ID_MARK <> 'D'
    LEFT JOIN RRP_MDL.O_ICL_CMM_IMP_FIN_BUS_INFO BL --进口融资业务信息 --MOD BY LIP 20250116
      ON BL.DUBIL_ID = A.DUBIL_ID
     AND BL.STD_PROD_ID IN ('401020300001')
     AND BL.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT A.CUST_NAME,A.CUST_ID,ROW_NUMBER()OVER(PARTITION BY A.CUST_NAME ORDER BY A.OPEN_ACCT_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A
                WHERE TRIM(A.SOCI_CRDT_CD) IS NOT NULL
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TA
      ON TA.CUST_NAME = TRIM(B.ERA_PAY_BANK_NAME)
     AND TA.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基础信息
      ON C.CUST_ID = NVL(TRIM(BL.ERA_PAY_BANK_CUST_ID),TA.CUST_ID)
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP COD1
      ON COD1.SRC_VALUE_CODE = C.CRDT_CUST_TYPE_CD
     AND COD1.SRC_CLASS_CODE = 'CD2074'
     AND COD1.TAR_CLASS_CODE = 'C0005'
     AND COD1.MOD_FLG = 'MDM'
   WHERE TRIM(B.ERA_PAY_BANK_NAME) IS NOT NULL
     AND A.PROD_ID IN ('203020700001','203020700002')
     AND A.EXP_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --未结清
     AND A.DISTR_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --当月放款
     AND A.DISTR_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 21;
  V_STEP_DESC := '重复数据校验';
  V_STARTTIME := SYSDATE;
  -- 增加数据重复校验 --
  WITH TMP1 AS (
  SELECT DATA_DT,TRA_ID,FIN_INST_ID,PROD_NM,TRA_DT,COUNT(1)
    FROM RRP_MDL.M_EAST_OWN_CPTL_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_ID,FIN_INST_ID,PROD_NM,TRA_DT
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 22;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := 23;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_EAST_OWN_CPTL_DTL;
/

