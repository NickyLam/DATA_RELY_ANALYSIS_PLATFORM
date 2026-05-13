CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_BILL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_BILL_INFO
  *  功能描述：票据出票表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_BILL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人 修改原因
  *             1    20220522  梅炜   首次创建
  *             2    20221107  HULJ   增加主键校验
  *             5    20221121  XUCX   增加字段取票据状态
  *             6    20230523  MW     修改保证金取值来源，从银承账户表改为信贷借据表
  *             7    20230605  LIP    修改经办员工号的口径，调整为直取
  *             8    20230905  HULJ   新增承兑状态代码
  *             9    20230914  LYH    收款人证件号码只能用收款人账户匹配，不能号票号匹配
  *             10   20230918  HYF    票据承兑修改关联条件
  *             11   20240104  HYF    新增借据放款日期
  *             12   20240205  LYH    优化收款人证件号码逻辑
  *             13   20250103  LIP    优化出票人、收款人相关信息：出票人和收款人信息优先从票据承兑信息表中取
  *             14   20250414  LAL    一表通，增加承兑协议批次编号取数逻辑
  *             15   20250819  YJY    修改绿色授信用途分类1104逻辑，取借据表的绿色信贷分类_新版代码
  *             16   20250821  LIP    一表通增加客户编号和授信合同号取数逻辑
  *             17   20250916  LIP    一表通增加客户经理工号和批次编号取数逻辑
  *             18   20251023  LIP    是否在我行贴现的判断中贴现的数据增加成功状态的判断
  *             19   20251112  LIP    保证金信息优先取承兑账户中的保证金信息
  *             20   20251225  LYH    增加票据子区间号字段
  *             21   20260408  YJY    新增五级分类字段
  ***********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_BILL_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_BILL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
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
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入票据出票表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_BILL_INFO
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --科目编号
    ,RCPT_ID                  --借据号
    ,LOAN_CONT_ID             --贷款合同号
    ,BILL_NO                  --票据号码
    ,BILL_BIZ_TYP             --票据业务类型
    ,CUR                      --币种
    ,BILL_PAR_AMT             --票面金额
    ,BILL_ISU_DT              --票据出票日期
    ,BILL_EXP_DT              --票据到期日期
    ,DRAWER_ID                --出票人编号
    ,DRAWER_NM                --出票人名称
    ,DRAWER_ACC               --出票人账号
    ,DRAWER_OPEN_BANK_NM      --出票人开户行名称
    ,PAYEE_NM                 --收款人名称
    ,PAYEE_ACC                --收款人账号
    ,PAYEE_OPEN_BANK_NM       --收款人开户行名称
    ,BANK_DISC_FLG            --本行贴现标志
    ,BILL_TRA_BKGD            --票据交易背景
    ,COMM_AMT                 --手续费金额
    ,OTH_COST_CUR             --其他费用币种
    ,OTH_COST_AMT             --其他费用金额
    ,MRGN_PCT                 --保证金比例
    ,MRGN_CUR                 --保证金币种
    ,MRGN                     --保证金
    ,MRGN_ACC                 --保证金账号
    ,BILL_STAT                --票据状态
    ,HDLR_NO                  --经办人工号
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,DIR_IDY                  --投向行业
    ,CURRT_BAL                --余额
    ,GRN_CRDT_USEAGE_CL_1104  --绿色授信用途分类1104
    ,STD_PROD_ID              --标准产品编号
    ,BILL_STATUS              --票据状态 ADD BY 20221121 XUCX
    ,PAYOFF_DT                --结清日期
    ,DUBIL_BAL                --借据余额
    ,PAYEE_CRDL_NO            --收款人证件号码
    ,ACCT_TYP                 --账户类别
    ,GRN_CRDT_USEAGE_CL       --绿色授信用途分类
    ,MARGIN_SUB_ACCT_NUM      --借据保证金子户号
    ,BILL_ACPT_STATUS_CD      --承兑状态代码 ADD BY HULJ20230905
    ,DISTR_DT                 --放款日期 ADD BY HYF 20240104
    ,ACPT_AGT_BATCH_ID        --承兑协议批次编号 ADD BY LAL 20250414
    ,CUST_ID                  --客户编号     --ADD BY LIP 20250821
    ,LMT_CONT_ID              --额度合同编号 --ADD BY LIP 20250821
    ,CUST_MGR_NO              --客户经理工号 --ADD BY LIP 20250916
    ,BATCH_ID                 --批次编号 --ADD BY LIP 20250916
    ,BILL_SUB_INTRV_ID        --票据子区间号 --ADD BY LYH 20251225
    ,LVL5_CL                  --五级分类 ADD BY YJY 20260408
    )
  WITH BILL_CENTER_INFO AS (
  SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY BILL_NUM ORDER BY BILL_SRC_CD ASC,BILL_ID ASC) AS RW
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T --票据中心信息
   WHERE DATA_SRC_CD <> '03' --02-票据系统；(03-电子票据 是票交所的，不需报送) --源数据无票据系统数据，需确认
     AND BILL_STATUS_CD <> '99' --过滤无效的票据
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  BILL_DISCNT_INFO AS (
  SELECT /*+MATERIALIZE*/BILL_NUM,HXB_ACPT_FLG,ROW_NUMBER() OVER(PARTITION BY BILL_NUM ORDER BY BILL_ID DESC,HXB_ACPT_FLG) AS RW
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T --票据贴现信息
   WHERE T.DISCNT_STATUS_CD IN ('06') --06为记账完成 --ADD BY LIP 20251023 是否贴现需要判断成功状态
     AND T.ENTRY_STATUS_CD = '03'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  DEPOSIT_APPLY_INFO AS (
  SELECT /*+MATERIALIZE*/TA.*,ROW_NUMBER() OVER(PARTITION BY TA.CONTRACTNO ORDER BY TA.EXCHANGEDATE,TA.PUTOUTNO) RN
    FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO TA
   WHERE TA.APPROVESTATUS = 'Finished'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  --ADD BY LYH 20240205，优化收款人证件号码逻辑
  TMP1_PAYEE_CRDL_NO AS (--票号 + 收款人账号关联
  SELECT /*+MATERIALIZE*/T.BILL_NUM,T.REQER_ACCT_NUM AS ACCT_NUM,REPLACE(T.REQER_ORGNZ_CD,'-','') AS ORGNZ_CD,'1' FLAG,
         ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.REQER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
    FROM RRP_MDL.O_IML_EVT_ELEC_BILL_TRAN_FLOW T
   WHERE T.REQER_ACCT_NUM != '0'
     AND REPLACE(TRIM(T.REQER_ORGNZ_CD),'-','') IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT T.BILL_NUM, T.RECVER_ACCT_NUM AS ACCT_NUM,REPLACE(T.RECVER_ORGNZ_CD,'-','') AS ORGNZ_CD,'2' FLAG,
         ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.RECVER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
    FROM RRP_MDL.O_IML_EVT_ELEC_BILL_TRAN_FLOW T
   WHERE T.RECVER_ACCT_NUM != '0'
     AND REPLACE(TRIM(T.RECVER_ORGNZ_CD),'-','') IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
   --新票
  SELECT T.BILL_NUM,T.RECVER_ACCT_NUM AS ACCT_NUM,T.RECVER_SOCI_CRDT_CD AS ORGNZ_CD,'3' FLAG,
         ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.RECVER_ACCT_NUM ORDER BY T.DRAW_DT DESC) AS RN
    FROM RRP_MDL.O_IML_AGT_CPES_BILL_INFO T 
   WHERE SUBSTR(T.BILL_NUM,1,1) IN ('5','6')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP2_PAYEE_CRDL_NO AS (--收款人账号关联
  SELECT /*+MATERIALIZE*/T.REQER_ACCT_NUM AS ACCT_NUM,REPLACE(T.REQER_ORGNZ_CD,'-','') AS ORGNZ_CD,'1' FLAG,
         ROW_NUMBER() OVER(PARTITION BY T.REQER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
    FROM RRP_MDL.O_IML_EVT_ELEC_BILL_TRAN_FLOW T
   WHERE T.REQER_ACCT_NUM != '0'
     AND REPLACE(TRIM(T.REQER_ORGNZ_CD),'-','') IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT T.RECVER_ACCT_NUM AS ACCT_NUM,REPLACE(T.RECVER_ORGNZ_CD,'-','') AS ORGNZ_CD,'2' FLAG,
         ROW_NUMBER() OVER(PARTITION BY T.RECVER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
    FROM RRP_MDL.O_IML_EVT_ELEC_BILL_TRAN_FLOW T
   WHERE T.RECVER_ACCT_NUM != '0'
     AND REPLACE(TRIM(T.RECVER_ORGNZ_CD),'-','') IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+PRALLEL(4)*/
         TO_CHAR(A.ETL_DT,'YYYYMMDD')                    AS DATA_DT                  --数据日期
        ,A.LP_ID                                         AS LGL_REP_ID               --法人编号
        ,B.ACPT_ORG_ID                                   AS ORG_ID                   --机构编号 --MODIFY BY MW 20221223 --更改为承兑机构编号
        ,B.SUBJ_ID                                       AS SUBJ_ID                  --科目编号
        ,A.DUBIL_ID                                      AS RCPT_ID                  --借据编号
        ,A.CONT_ID                                       AS LOAN_CONT_ID             --贷款合同号
        ,A.BILL_NUM                                      AS BILL_NO                  --票据号码
        ,'01'                                            AS BILL_BIZ_TYP             --票据业务类型  01:银行承兑汇票
        ,A.CURR_CD                                       AS CUR                      --币种
        ,NVL(B.FAC_VAL_AMT,A.DUBIL_AMT)                  AS BILL_PAR_AMT             --票面金额
        ,TO_CHAR(NVL(C.DRAW_DT,B.DRAW_DT), 'YYYYMMDD')   AS BILL_ISU_DT              --票据出票日期
        ,TO_CHAR(C.EXP_DT, 'YYYYMMDD')                   AS BILL_EXP_DT              --票据到期日期
        /*,NVL(NVL(C.DRAWER_CUST_ID,C.CUST_ID),A.CUST_ID)  DRAWER_ID                 --出票人编号
        ,C.DRAWER_NAME                                   DRAWER_NM                 --出票人名称
        ,C.DRAWER_ACCT_NUM                               DRAWER_ACC                --出票人账号
        ,C.DRAWER_OPEN_BANK_NAME                         DRAWER_OPEN_BANK_NM       --出票人开户行名称
        ,NVL(C.RECVER_NAME,G.CUST_NAME)                  PAYEE_NM                  --收款人名称
        ,NVL(C.RECVER_ACCT_NUM,A.REPAY_NUM)              PAYEE_ACC                 --收款人账号
        ,NVL(C.RECVER_OPEN_BANK_NAME,A.BNFT_BK_NAME)     PAYEE_OPEN_BANK_NM        --收款人开户行名称*/
        --MOD BY LIP 20250103 出票人和收款人优先获取票据承兑信息表的信息
        ,COALESCE(TRIM(B1.CUST_ID),TRIM(C.DRAWER_CUST_ID))  AS DRAWER_ID                --出票人编号  
        ,COALESCE(TRIM(B1.DRAWER_NAME),TRIM(C.DRAWER_NAME)) AS DRAWER_NM                --出票人名称
        ,COALESCE(TRIM(B1.DRAWER_ACCT_NUM),TRIM(C.DRAWER_ACCT_NUM))  
                                                          AS DRAWER_ACC                 --出票人账号
        ,COALESCE(TRIM(B1.DRAWER_OPEN_BANK_NAME),TRIM(C.DRAWER_OPEN_BANK_NAME)) 
                                                          AS DRAWER_OPEN_BANK_NM        --出票人开户行名称
        ,COALESCE(TRIM(B1.RECVER_NAME),TRIM(C.RECVER_NAME),TRIM(G.CUST_NAME)) 
                                                          AS PAYEE_NM                   --收款人名称
        ,COALESCE(TRIM(B1.RECVER_ACCT_NUM),TRIM(C.RECVER_ACCT_NUM),TRIM(A.REPAY_NUM)) 
                                                          AS PAYEE_ACC                  --收款人账号
        ,COALESCE(TRIM(B1.RECVER_OPEN_BANK_NAME),TRIM(C.RECVER_OPEN_BANK_NAME),TRIM(A.BNFT_BK_NAME)) 
                                                          AS PAYEE_OPEN_BANK_NM         --收款人开户行名称
        ,CASE WHEN D.HXB_ACPT_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                             AS BANK_DISC_FLG              --本行贴现标志
        ,F.LOAN_USAGE_DESCB                               AS BILL_TRA_BKGD              --票据交易背景
        ,B.COMM_FEE                                       AS COMM_AMT                   --手续费金额
        ,NULL                                             AS OTH_COST_CUR               --其他费用币种
        ,NULL                                             AS OTH_COST_AMT               --其他费用金额
        --,CONT.MARGIN_RATIO                                AS MRGN_PCT                   --保证金比例
        --MOD BY LIP 20251112 优先取承兑账户中的保证金金额
        ,CASE WHEN B.MARGIN_RATIO <> 0 THEN B.MARGIN_RATIO
              ELSE CONT.MARGIN_RATIO
          END                                             AS MRGN_PCT                   --保证金比例
        --经与信贷和票据确认，以信贷合同表的数据为准
        ,CASE WHEN CONT.MARGIN_CURR_CD IS NULL OR CONT.MARGIN_CURR_CD = '-' THEN A.CURR_CD
              ELSE CONT.MARGIN_CURR_CD
          END                                             AS MRGN_CUR                   --保证金币种
        --,CONT.MARGIN_AMT                                  AS MRGN                       --保证金
        --MOD BY LIP 20251112 优先取承兑账户中的保证金金额，需要借据维度的保证金
        ,CASE WHEN B.MARGIN_AMT <> 0 THEN B.MARGIN_AMT
              WHEN CONT.MARGIN_AMT > 0 THEN CONT.MARGIN_AMT
              ELSE 0
          END                                             AS MRGN                       --保证金
        ,CASE WHEN TRIM(REPLACE(A.MARGIN_ACCT_NUM,'/','')) IS NOT NULL THEN TRIM(A.MARGIN_ACCT_NUM)
              WHEN TRIM(CONT.MARGIN_ACCT_NUM) IS NOT NULL THEN TRIM(CONT.MARGIN_ACCT_NUM)
              ELSE TRIM(TTD.GRTEAC)
          END                                             AS MRGN_ACC                   --保证金账号
        ,NVL(TTA.TAR_VALUE_CODE,'99')                     AS BILL_STAT                  --票据状态
        --MOD BY LIP 20230605 新一代的柜员和员工号一样，不需转换
        ,A.OPER_TELLER_ID                                 AS HDLR_NO                    --经办人工号
        ,'800926'                                         AS DEPT_LINE                  --部门条线 /*公司银行总部*/
        ,'票据承兑'                                       AS DATA_SRC                   --数据来源
        ,A.DIR_INDUS_CD                                   AS DIR_IDY                    --投向行业
        ,B.CURRT_BAL                                      AS CURRT_BAL                  --余额
        --,NVL(TTC.TAR_VALUE_CODE,G.GREEN_CRDT_CLS_CD)      
        ,A.GREEN_CRDT_CLS_NEW                             AS GRN_CRDT_USEAGE_CL_1104    --绿色授信用途分类1104 --MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
        ,A.STD_PROD_ID                                    AS STD_PROD_ID                --标准产品编号
        ,B.BILL_STATUS                                    AS BILL_STATUS                --票据状态 add by 20221121 xucx
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                  AS PAYOFF_DT                  --结清日期
        ,A.DUBIL_BAL                                      AS DUBIL_BAL                  --借据余额
        --,COALESCE(T2.ORGNZ_CD,T3.ORGNZ_CD,T21.ORGNZ_CD,T31.ORGNZ_CD,T22.ORGNZ_CD,T32.ORGNZ_CD) AS PAYEE_CRDL_NO --收款人证件号码
        --UPDATE BY LYH 20230914，收款人证件号码只能用收款人账户匹配，不能号票号匹配
        --,COALESCE(T2.ORGNZ_CD,T3.ORGNZ_CD,T21.ORGNZ_CD,T31.ORGNZ_CD) AS PAYEE_CRDL_NO --收款人证件号码
        --MOD BY LYH 20240205，优化收款人证件号码逻辑
        ,COALESCE(T2.ORGNZ_CD,T3.ORGNZ_CD,T4.SOCIAL_CREDIT_CODE) AS PAYEE_CRDL_NO       --收款人证件号码
        ,'111'                                            AS ACCT_TYP                   --账户类别
        ,CASE WHEN G.GREEN_CRDT_CUST_FLG = '1'
              THEN DECODE(/*G.GREEN_CRDT_CLS_CD*/ G.GREEN_CRDT_CLS_NEW,'-','',/*G.GREEN_CRDT_CLS_CD*/ G.GREEN_CRDT_CLS_NEW) --MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
          END                                             AS GRN_CRDT_USEAGE_CL         --绿色授信用途分类
        ,A.MARGIN_SUB_ACCT_NUM                            AS MARGIN_SUB_ACCT_NUM        --借据保证金子户号
        ,B1.BILL_ACPT_STATUS_CD                           AS BILL_ACPT_STATUS_CD        --承兑状态代码
        ,NVL(TO_CHAR(A.DISTR_DT,'YYYYMMDD'),TO_CHAR(S.DISTR_DT,'YYYYMMDD')) AS DISTR_DT --放款日期
        ,B1.ACPT_AGT_BATCH_ID                             AS ACPT_AGT_BATCH_ID          --承兑协议批次编号 ADD BY LAL 20250414
        ,A.CUST_ID                                        AS CUST_ID                    --客户编号 --ADD BY LIP 20250821
        ,TRIM(CONT.LMT_CONT_ID)                           AS LMT_CONT_ID                --额度合同编号 --ADD BY LIP 20250821
        ,TRIM(B1.CUST_MGR_ID)                             AS CUST_MGR_NO                --客户经理工号 --ADD BY LIP 20250916
        ,TRIM(B1.BATCH_ID)                                AS BATCH_ID                   --批次编号 --ADD BY LIP 20250916
        ,B1.BILL_SUB_INTRV_ID                             AS BILL_SUB_INTRV_ID          --票据子区间号 --ADD BY LYH 20251225
        ,TTB.TAR_VALUE_CODE                               AS LVL5_CL                    --五级分类 ADD BY YJY 202600408
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO B --银承账户信息
      ON B.BILL_NUM = A.BILL_NUM
     AND B.BILL_NUM <> ' '
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_ACPT_INFO B1 --票据承兑信息
      ON B1.BILL_ID = B.ACCT_ID --修改过滤条件 --20230918
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO CONT
      ON CONT.CONT_ID = A.CONT_ID
     AND CONT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN BILL_CENTER_INFO C
      ON C.BILL_NUM = A.BILL_NUM
     AND C.RW = 1
    LEFT JOIN BILL_DISCNT_INFO D
      ON D.BILL_NUM = A.BILL_NUM
     AND D.RW = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息
      ON G.CUST_ID = A.CUST_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO F --对公贷款合同信息
      ON F.CONT_ID = A.CONT_ID
     AND F.STD_PROD_ID IN ('204010100001','204010200001','601010100001')
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO S --对公贷款账户信息
      ON S.DUBIL_NUM = A.DUBIL_ID
     AND S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.ACCT_NUM ORDER BY FLAG ASC) AS RN_FLAG 
                 FROM TMP1_PAYEE_CRDL_NO T WHERE T.RN = 1) T2
      ON T2.BILL_NUM = C.BILL_NUM AND T2.ACCT_NUM = C.RECVER_ACCT_NUM AND T2.RN_FLAG = 1
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.ACCT_NUM ORDER BY FLAG ASC) AS RN_FLAG 
                 FROM TMP2_PAYEE_CRDL_NO T WHERE T.RN = 1) T3
      ON T3.ACCT_NUM = C.RECVER_ACCT_NUM AND T3.RN_FLAG = 1
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.COMP_NAME ORDER BY T.OPDATE ASC) AS RN_FLAG 
                 FROM RRP_MDL.O_IOL_WIND_COMPINTRODUCTION T --万德数据客户基本信息总表
                WHERE TRIM(SOCIAL_CREDIT_CODE) IS NOT NULL) T4 --统一社会信用代码
      ON T4.COMP_NAME = C.RECVER_NAME AND T4.RN_FLAG = 1
    LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(票据状态)
      ON TTA.SRC_VALUE_CODE = (CASE WHEN C.BILL_STATUS_CD = '000000' THEN 'S21'
                                    WHEN C.BILL_STATUS_CD = '000002' THEN '9903'
                                    ELSE C.BILL_STATUS_CD
                                END)
     AND TTA.SRC_CLASS_CODE = 'CD1487'
     AND TTA.TAR_CLASS_CODE = 'D0125'
     AND TTA.MOD_FLG = 'MDM'
    /*LEFT JOIN RRP_MDL.CODE_MAP TTC --绿色贷款用途转码
      ON TTC.SRC_VALUE_CODE = G.GREEN_CRDT_CLS_CD 
     AND TTC.SRC_CLASS_CODE = 'CD2390'
     AND TTC.TAR_CLASS_CODE = 'D0142'
     AND TTC.MOD_FLG = 'MDM'*/ --MOD BY YJY 20250819 
    LEFT JOIN DEPOSIT_APPLY_INFO TTD --保证金追加流水表 --ADD BY LIP 20230612 根据信贷反馈，当合同的保证金账号为空时，取追加表的账号
      ON TTD.CONTRACTNO = A.CONT_ID
     AND TTD.RN = 1
    --ADD BY YJY 20260408
    LEFT JOIN RRP_MDL.CODE_MAP TTB --码值映射表(贷款五级分类)
      ON TTB.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND TTB.SRC_CLASS_CODE = 'CD1032'
     AND TTB.TAR_CLASS_CODE = 'D0005'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.STD_PROD_ID = '601010100001' --601010100001 银承承兑 20221121 MW
     AND A.BILL_NUM IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := 4;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP AS (
  SELECT DATA_DT,BILL_NO,COUNT(1)
    FROM RRP_MDL.M_LOAN_BILL_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,BILL_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_SQLMSG  := 'M_LOAN_BILL_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 5;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := 6;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
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

END ETL_M_LOAN_BILL_INFO;
/

