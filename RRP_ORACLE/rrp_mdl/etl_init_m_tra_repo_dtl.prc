CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_REPO_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_REPO_DTL
  *  功能描述：回购业务交易流水
  *  创建日期：20220616
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_TRA_REPO_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20220913  许晓滨    增加口径
  *             3    20220916  hulj      增加口径
  *             4    20221122  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_REPO_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) := 'M_TRA_REPO_DTL'; --表名
  V_PART_NAME VARCHAR2(100);
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_TRA_REPO_DTL'; --表名
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
  V_STEP_DESC := '插入回购业务交易流水--对公贷款';
  V_STARTTIME := SYSDATE;
 /* INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
   )
   SELECT DISTINCT
      V_P_DATE    DATA_DT  --数据日期
      ,A.LP_ID    LGL_REP_ID  --法人编号
      ,NVL(A.OUT_ACCT_FLOW_NUM,'0000')    SEQ_NO  --流水号
      ,NVL(B.ACCT_ID,'999')                ACC_ID  --账户编号
      ,A.BUS_BREED_ID           TRA_TYP  --交易类型
      ,A.OPER_ORG_ID            OPEN_ACC_ORG_ID  --开户机构
      ,A.OPER_ORG_ID            HDL_ORG_ID  --经办机构编号
      ,G.CONT_AMT               TRA_AMT  --交易金额
      ,A.SECD_REPAY_NUM          OPP_ACC  --对方账号
      ,G.ENTER_NAME          OPP_ACC_NM  --对方户名
      ,NULL                  OPP_PBC_NO  --对方行号
      ,NULL                  OPP_BANK_NM  --对方行名
      ,SUBSTR(H.TRAN_CHN_DESCB,0,60)      TRA_CHAN  --交易渠道
      ,A.CURR_CD             CUR  --币种
      ,NULL           CASH_TRF_FLG  --现转标志
      ,NULL                             AGT_NM  --代办人姓名
      ,NULL                             AGT_CRDL_TYP  --代办人证件类型
      ,NULL                             AGT_CRDL_NO  --代办人证件号码
      ,NVL(A.OPER_TELLER_ID,H.TRAN_TELLER_ID)  TRA_TLR_NO  --交易柜员号
      ,NVL(A.OPER_TELLER_ID,H.TRAN_TELLER_ID)GRANT_TLR_NO  --授权柜员号
      ,NULL                                                    ABSTR  --摘要
      ,NULL                                   FLUSH_PATCH_FLG  --冲补抹标志
      ,NULL                                     TRA_DR_CR_FLG  --交易借贷标志
      ,G.TRAN_TM  --交易时间
      ,NULL                   AST_LBY_SIDE_FLG  --资产负债方标志
      ,B.SUBJ_ID              SUBJ_ID  --科目编号
      ,NULL                   OCCUR_SETL_TYP  --发生结清类型
      ,NULL                     DEPT_LINE  --部门条线
      ,'对公贷款'         DATA_SRC  --数据来源
   FROM   O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
     JOIN O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
     ON B.DUBIL_NUM = A.DUBIL_ID
    AND B.ETL_DT = A.ETL_DT
     LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
     ON C.CUST_ID = A.CUST_ID
    AND C.ETL_DT = A.ETL_DT
    LEFT JOIN O_ICL_CMM_STD_PROD_INFO F --标准产品信息表
     ON F.PROD_ID = B.STD_PROD_ID
     AND F.ETL_DT = A.ETL_DT
     LEFT JOIN O_ICL_CMM_SUBJ_INFO E --科目信息
     ON E.SUBJ_ID = B.SUBJ_ID
     AND E.ETL_DT = A.ETL_DT
     LEFT JOIN O_IML_AGT_LOAN_OUT_ACCT_APPL_H  G--贷款出账申请历史
     ON G.CONT_ID = A.CONT_ID
     LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO D --内部机构信息表
      ON D.ORG_ID = G.OUT_ACCT_ORG_ID
      AND D.ETL_DT = A.ETL_DT
     LEFT JOIN O_ICL_CMM_ABMT_REMIT_DTL  H  --汇入汇款明细
     ON H.TRAN_FLOW_ID = A.OUT_ACCT_FLOW_NUM
     AND H.ETL_DT = A.ETL_DT
    WHERE (TRIM(A.MATN_FLG) IS NULL OR TRIM(A.MATN_FLG) <> '2')
     AND TRIM(A.DUBIL_ID) IS NOT NULL
     AND B.DUBIL_NUM IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');


   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '插入回购业务交易流水--对公贷款(核心的借据)';
   V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
   )
   SELECT DISTINCT
      V_P_DATE    DATA_DT  --数据日期
      ,B.LP_ID    LGL_REP_ID  --法人编号
      ,NVL(A.TRAN_FLOW_NUM,'0000')    SEQ_NO  --流水号
      ,NVL(B.ACCT_ID,'999')                ACC_ID  --账户编号
      ,D.BUS_BREED_ID           TRA_TYP  --交易类型
      ,D.OPER_ORG_ID            OPEN_ACC_ORG_ID  --开户机构
      ,D.OPER_ORG_ID            HDL_ORG_ID  --经办机构编号
      ,D.DUBIL_AMT             TRA_AMT  --交易金额
      ,A.CNTPTY_CUST_ACCT_NUM          OPP_ACC  --对方账号
      ,A.CNTPTY_ACCT_NAME         OPP_ACC_NM  --对方户名
      ,A.CNTPTY_BANK_NO                 OPP_PBC_NO  --对方行号
      ,A.CNTPTY_BANK_NAME              OPP_BANK_NM  --对方行名
      ,SUBSTR(A.CHN_ID,0,60)      TRA_CHAN  --交易渠道
      ,D.CURR_CD             CUR  --币种
      ,CASE WHEN A.TRAN_KIND_CD LIKE 'C%' THEN '1' --'1' --现金
            WHEN A.TRAN_KIND_CD LIKE 'T%' THEN '2'--'0' --转账
            WHEN SUBSTR(A.TRAN_KIND_CD, 0, 1) NOT IN ('C', 'T') AND A.TRAN_FLOW_NUM IS NOT NULL THEN '1' --'1' --有现金记账(账单)
            WHEN SUBSTR(A.TRAN_KIND_CD, 0, 1) NOT IN ('C', 'T') AND A.TRAN_FLOW_NUM IS NULL THEN '2'--NULL --无现金记账(账单)
            ELSE '2'
        END
            CASH_TRF_FLG  --现转标志
      ,A.PUBLIC_AGENT_NAME                             AGT_NM  --代办人姓名
      ,NULL                             AGT_CRDL_TYP  --代办人证件类型
      ,NULL                             AGT_CRDL_NO  --代办人证件号码
      ,NVL(A.TRAN_TELLER_ID,D.OPER_TELLER_ID)  TRA_TLR_NO  --交易柜员号
      ,NVL(A.TRAN_TELLER_ID,D.OPER_TELLER_ID) GRANT_TLR_NO  --授权柜员号
      ,NULL                                                    ABSTR  --摘要
      ,CASE WHEN TRIM(M.STRK_BAL_FLG) = '1' THEN '1'
            WHEN TRIM(M.STRK_BAL_FLG) IN ('2','3') THEN '2'
            ELSE '1'
        END
                                     FLUSH_PATCH_FLG  --冲补抹标志
      ,M.DEBIT_CRDT_FLG                                   TRA_DR_CR_FLG  --交易借贷标志
      ,A.TRAN_TM       TRA_TM                              --交易时间
      ,NULL                   AST_LBY_SIDE_FLG  --资产负债方标志
      ,B.SUBJ_ID              SUBJ_ID  --科目编号
      ,NULL                   OCCUR_SETL_TYP  --发生结清类型
      ,NULL                     DEPT_LINE  --部门条线
      ,'对公贷款-核心'         DATA_SRC  --数据来源
   FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
   LEFT JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO D
   ON D.DUBIL_ID = B.DUBIL_NUM
   LEFT JOIN O_IML_EVT_LOAN_FIN_TRAN_FLOW A
   ON B.DISTR_FLOW_NUM = A.TRAN_FLOW_NUM
   AND A.ETL_DT = B.ETL_DT
   LEFT JOIN O_ICL_CMM_DEP_ACCT_TRAN_DTL  C
   ON A.TRAN_FLOW_NUM = C.TRAN_FLOW_NUM
   AND C.ETL_DT = B.ETL_DT
    LEFT JOIN O_ICL_CMM_CORP_LOAN_REPAY_DTL  M
   ON  M.DUBIL_ID =B.DUBIL_NUM
   AND M.ETL_DT = B.ETL_DT
 LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
   ON F.CUST_ID = B.CUST_ID
 LEFT JOIN O_ICL_CMM_SUBJ_INFO E --科目信息
    ON E.SUBJ_ID = B.SUBJ_ID
    AND F.ETL_DT = B.ETL_DT
    LEFT JOIN O_IML_AGT_LOAN_OUT_ACCT_APPL_H  G--贷款出账申请历史
     ON G.CONT_ID = B.CONT_ID
 LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO D --内部机构信息表
  ON D.ORG_ID = NVL(TRIM(C.TRAN_ORG_ID),B.ACCT_INSTIT_ID)
  AND D.ETL_DT = A.ETL_DT
 LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO H --内部机构信息表
     ON H.ORG_ID = C.CNTPTY_OPEN_BANK_ID
  AND H.ETL_DT = A.ETL_DT
  WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');*/

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
--20220913 XUXIAOBIN ADD

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入回购业务交易流水--票据回购';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
   )
   --票据回购发生
   SELECT
       V_P_DATE          AS       DATA_DT  --数据日期
      ,MIN(A.LP_ID)           AS       LGL_REP_ID  --法人编号
      ,A.CONT_ID         AS       SEQ_NO  --流水号
      ,A.CTR_NT_ID       AS       ACC_ID  --账户编号
      ,'' AS TRA_TYP  --交易类型
      ,'' AS OPEN_ACC_ORG_ID  --开户机构
      ,A.ACCT_INSTIT_ID   AS       HDL_ORG_ID  --经办机构编号
      ,SUM(A.FAC_VAL_AMT) AS       TRA_AMT  --交易金额
      ,'' AS OPP_ACC  --对方账号
      ,MIN(A.CNTPTY_NAME)  AS      OPP_ACC_NM  --对方户名
      ,MIN(A.CNTPTY_BANK_NO) AS OPP_PBC_NO  --对方行号
      ,'' AS OPP_BANK_NM  --对方行名
      ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
      ,A.CURR_CD          AS       CUR  --币种
      ,'' AS CASH_TRF_FLG  --现转标志
      ,'' AS AGT_NM  --代办人姓名
      ,'' AS AGT_CRDL_TYP  --代办人证件类型
      ,'' AS AGT_CRDL_NO  --代办人证件号码
      ,'' AS TRA_TLR_NO  --交易柜员号
      ,'' AS GRANT_TLR_NO  --授权柜员号
      ,'' AS ABSTR  --摘要
      ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
      ,'' AS TRA_DR_CR_FLG  --交易借贷标志
      ,A.STL_DT         AS         TRA_TM  --交易时间
      ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
      ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
      ,'1' AS OCCUR_SETL_TYP  --发生结清类型
      ,'' AS DEPT_LINE  --部门条线
      ,'票据回购发生' AS DATA_SRC  --数据来源
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A  --票据转贴现信息表
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.BUS_TYPE_CD IN('BT02', 'BT03')
    AND A.ENTRY_STATUS_CD = '03'
    AND TRUNC(A.STL_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
    GROUP BY A.CONT_ID,A.CTR_NT_ID,A.ACCT_INSTIT_ID,A.TRAN_DIR_CD,A.CURR_CD,A.STL_DT,A.SUBJ_ID,
    CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '101'
         WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '201'
         END

      UNION ALL
      --票据回购结清
      SELECT
       V_P_DATE          AS       DATA_DT  --数据日期
      ,MIN(A.LP_ID)           AS       LGL_REP_ID  --法人编号
      ,A.EXP_REPO_AGT_ID         AS       SEQ_NO  --流水号
      ,A.CTR_NT_ID       AS       ACC_ID  --账户编号
      ,'' AS TRA_TYP  --交易类型
      ,'' AS OPEN_ACC_ORG_ID  --开户机构
      ,A.ACCT_INSTIT_ID   AS       HDL_ORG_ID  --经办机构编号
      ,SUM(A.FAC_VAL_AMT) AS       TRA_AMT  --交易金额
      ,'' AS OPP_ACC  --对方账号
      ,MIN(A.CNTPTY_NAME)  AS      OPP_ACC_NM  --对方户名
      ,MIN(A.CNTPTY_BANK_NO) AS OPP_PBC_NO  --对方行号
      ,'' AS OPP_BANK_NM  --对方行名
      ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
      ,A.CURR_CD          AS       CUR  --币种
      ,'' AS CASH_TRF_FLG  --现转标志
      ,'' AS AGT_NM  --代办人姓名
      ,'' AS AGT_CRDL_TYP  --代办人证件类型
      ,'' AS AGT_CRDL_NO  --代办人证件号码
      ,'' AS TRA_TLR_NO  --交易柜员号
      ,'' AS GRANT_TLR_NO  --授权柜员号
      ,'' AS ABSTR  --摘要
      ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
      ,'' AS TRA_DR_CR_FLG  --交易借贷标志
      ,A.ACTL_REPO_DT         AS         TRA_TM  --交易时间
      ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
      ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
      ,'0' AS OCCUR_SETL_TYP  --发生结清类型
      ,'' AS DEPT_LINE  --部门条线
      ,'票据回购结清' AS DATA_SRC  --数据来源

    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A  --票据转贴现信息表
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.BUS_TYPE_CD IN('BT02', 'BT03')
    AND A.ENTRY_STATUS_CD = '03'
    AND TRUNC(A.ACTL_REPO_DT, 'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
    GROUP BY A.EXP_REPO_AGT_ID,A.CTR_NT_ID,A.ACCT_INSTIT_ID,A.TRAN_DIR_CD,A.CURR_CD,A.ACTL_REPO_DT,A.SUBJ_ID,
    CASE WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '01' THEN '101'
         WHEN A.BUS_TYPE_CD IN ('BT02','BT03') AND A.TRAN_DIR_CD = '02' THEN '201'
         END
         ;
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入回购业务交易流水--资金债券回购';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
   )
   --资金债权回购发生
   SELECT
       V_P_DATE          AS       DATA_DT  --数据日期
      ,A.LP_ID           AS       LGL_REP_ID  --法人编号
      ,A.TRAN_ID||'_1'         AS       SEQ_NO  --流水号
      ,SUBSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,1,INSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,'.')-1)       AS       ACC_ID  --账户编号
      ,'' AS TRA_TYP  --交易类型
      ,'' AS OPEN_ACC_ORG_ID  --开户机构
      ,A.ENTRY_ORG_ID   AS       HDL_ORG_ID  --经办机构编号
      ,A.TRAN_AMT AS       TRA_AMT  --交易金额
      ,'' AS OPP_ACC  --对方账号
      ,A.CNTPTY_NAME  AS      OPP_ACC_NM  --对方户名
      ,'' AS OPP_PBC_NO  --对方行号
      ,'' AS OPP_BANK_NM  --对方行名
      ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
      ,A.CURR_CD          AS       CUR  --币种
      ,'' AS CASH_TRF_FLG  --现转标志
      ,'' AS AGT_NM  --代办人姓名
      ,'' AS AGT_CRDL_TYP  --代办人证件类型
      ,'' AS AGT_CRDL_NO  --代办人证件号码
      ,A.DEALER_ID AS TRA_TLR_NO  --交易柜员号
      ,'' AS GRANT_TLR_NO  --授权柜员号
      ,'' AS ABSTR  --摘要
      ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
      ,'' AS TRA_DR_CR_FLG  --交易借贷标志
      ,A.VALUE_DT         AS         TRA_TM  --交易时间
      ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
      ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
      ,'1' AS OCCUR_SETL_TYP  --发生结清类型
      ,'' AS DEPT_LINE  --部门条线
      ,'资金债权回购发生' AS DATA_SRC  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A --资金债券回购表
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TRUNC(A.VALUE_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')

    UNION ALL
    --资金债权回购结清
    SELECT
       V_P_DATE          AS       DATA_DT  --数据日期
      ,A.LP_ID           AS       LGL_REP_ID  --法人编号
      ,A.TRAN_ID||'_0'         AS       SEQ_NO  --流水号
      ,SUBSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,1,INSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,'.')-1)       AS       ACC_ID  --账户编号
      ,'' AS TRA_TYP  --交易类型
      ,'' AS OPEN_ACC_ORG_ID  --开户机构
      ,A.ENTRY_ORG_ID   AS       HDL_ORG_ID  --经办机构编号
      ,A.TRAN_AMT AS       TRA_AMT  --交易金额
      ,'' AS OPP_ACC  --对方账号
      ,A.CNTPTY_NAME  AS      OPP_ACC_NM  --对方户名
      ,'' AS OPP_PBC_NO  --对方行号
      ,'' AS OPP_BANK_NM  --对方行名
      ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
      ,A.CURR_CD          AS       CUR  --币种
      ,'' AS CASH_TRF_FLG  --现转标志
      ,'' AS AGT_NM  --代办人姓名
      ,'' AS AGT_CRDL_TYP  --代办人证件类型
      ,'' AS AGT_CRDL_NO  --代办人证件号码
      ,A.DEALER_ID AS TRA_TLR_NO  --交易柜员号
      ,'' AS GRANT_TLR_NO  --授权柜员号
      ,'' AS ABSTR  --摘要
      ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
      ,'' AS TRA_DR_CR_FLG  --交易借贷标志
      ,A.EXP_DT         AS         TRA_TM  --交易时间
      ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
      ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
      ,'0' AS OCCUR_SETL_TYP  --发生结清类型
      ,'' AS DEPT_LINE  --部门条线
      ,'资金债权回购结清' AS DATA_SRC  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A --资金债券回购表
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TRUNC(A.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')

      ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入回购业务交易流水--外币回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
   )
   --外币回购发生
   SELECT
    TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID                           --法人编号
    ,A.BUS_ID||'_1' AS SEQ_NO  --流水号
    ,/*A.BUS_ID*/A.BAG_ID AS ACC_ID                              --账户编号20221108 XUXIAOBIN MODIFY
    ,NULL AS  TRA_TYP  --交易类型
    ,A.ENTRY_ORG_ID AS ORG_ID                             --机构编号
    ,A.ENTRY_ORG_ID AS HDL_ORG_ID  --经办机构编号
    ,ABS(A.TRAN_AMT) AS TRA_AMT  --交易金额
    ,NULL AS OPP_ACC  --对方账号
    ,A.CNTPTY_NAME  AS      OPP_ACC_NM  --对方户名
    ,NULL AS OPP_PBC_NO  --对方行号
    ,NULL AS OPP_BANK_NM  --对方行名
    ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
    ,A.CURR_CD          AS       CUR  --币种
    ,'' AS CASH_TRF_FLG  --现转标志
    ,'' AS AGT_NM  --代办人姓名
    ,'' AS AGT_CRDL_TYP  --代办人证件类型
    ,'' AS AGT_CRDL_NO  --代办人证件号码
    ,'' AS TRA_TLR_NO  --交易柜员号
    ,'' AS GRANT_TLR_NO  --授权柜员号
    ,'' AS ABSTR  --摘要
    ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
    ,'' AS TRA_DR_CR_FLG  --交易借贷标志
    ,A.VALUE_DT         AS         TRA_TM  --交易时间
    ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
    ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
    ,'1' AS OCCUR_SETL_TYP  --发生结清类型
    ,'' AS DEPT_LINE  --部门条线
    ,'外币回购发生'         DATA_SRC  --数据来源
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表

  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')--还需要看其他模块的是否是每天取数再增加条件限制
      AND A.INV_PORT_STATUS_CD IN ('A','C')--20230102 XUXIAOBIN ADD 来源陆炜迪提数脚本
      AND TRUNC(A.VALUE_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
      UNION ALL

      SELECT
    TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID                           --法人编号
    ,A.BUS_ID||'_0' AS SEQ_NO  --流水号
    ,/*A.BUS_ID*/A.BAG_ID AS ACC_ID                              --账户编号
    ,NULL AS  TRA_TYP  --交易类型
    ,A.ENTRY_ORG_ID AS ORG_ID                             --机构编号
    ,A.ENTRY_ORG_ID AS HDL_ORG_ID  --经办机构编号
    ,ABS(A.TRAN_AMT) AS TRA_AMT  --交易金额
    ,NULL AS OPP_ACC  --对方账号
    ,A.CNTPTY_NAME  AS      OPP_ACC_NM  --对方户名
    ,NULL AS OPP_PBC_NO  --对方行号
    ,NULL AS OPP_BANK_NM  --对方行名
    ,A.TRAN_DIR_CD AS TRA_CHAN  --交易渠道
    ,A.CURR_CD          AS       CUR  --币种
    ,'' AS CASH_TRF_FLG  --现转标志
    ,'' AS AGT_NM  --代办人姓名
    ,'' AS AGT_CRDL_TYP  --代办人证件类型
    ,'' AS AGT_CRDL_NO  --代办人证件号码
    ,'' AS TRA_TLR_NO  --交易柜员号
    ,'' AS GRANT_TLR_NO  --授权柜员号
    ,'' AS ABSTR  --摘要
    ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
    ,'' AS TRA_DR_CR_FLG  --交易借贷标志
    ,A.EXP_DT         AS         TRA_TM  --交易时间
    ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
    ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
    ,'0' AS OCCUR_SETL_TYP  --发生结清类型
    ,'' AS DEPT_LINE  --部门条线
    ,'外币回购结清'         DATA_SRC  --数据来源
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')--还需要看其他模块的是否是每天取数再增加条件限制
      AND TRUNC(A.EXP_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
      AND A.INV_PORT_STATUS_CD IN ('A','C')--20230102 XUXIAOBIN ADD 来源陆炜迪提数脚本

      ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入回购业务交易流水--同业现金借贷质押式回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_REPO_DTL
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,SEQ_NO  --流水号
      ,ACC_ID  --账户编号
      ,TRA_TYP  --交易类型
      ,OPEN_ACC_ORG_ID  --开户机构
      ,HDL_ORG_ID  --经办机构编号
      ,TRA_AMT  --交易金额
      ,OPP_ACC  --对方账号
      ,OPP_ACC_NM  --对方户名
      ,OPP_PBC_NO  --对方行号
      ,OPP_BANK_NM  --对方行名
      ,TRA_CHAN  --交易渠道
      ,CUR  --币种
      ,CASH_TRF_FLG  --现转标志
      ,AGT_NM  --代办人姓名
      ,AGT_CRDL_TYP  --代办人证件类型
      ,AGT_CRDL_NO  --代办人证件号码
      ,TRA_TLR_NO  --交易柜员号
      ,GRANT_TLR_NO  --授权柜员号
      ,ABSTR  --摘要
      ,FLUSH_PATCH_FLG  --冲补抹标志
      ,TRA_DR_CR_FLG  --交易借贷标志
      ,TRA_TM  --交易时间
      ,AST_LBY_SIDE_FLG  --资产负债方标志
      ,SUBJ_ID  --科目编号
      ,OCCUR_SETL_TYP  --发生结清类型
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
    )
     SELECT
     TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID   --法人编号
    ,A.OBJ_ID AS SEQ_NO  --流水号
    ,A.BUS_ID AS ACC_ID   --账户编号
    ,NULL AS  TRA_TYP  --交易类型
    ,A.BELONG_ORG_ID AS ORG_ID                             --机构编号
    ,A.BELONG_ORG_ID AS HDL_ORG_ID  --经办机构编号
    ,A.TRAN_AMT AS TRA_AMT  --交易金额
    ,A.CNTPTY_ACCT_NUM AS OPP_ACC  --对方账号
    ,A.CNTPTY_ACCT_NAME AS OPP_ACC_NM  --对方户名
    ,A.CNTPTY_OPEN_BANK_NUM AS OPP_PBC_NO  --对方行号
    ,A.CNTPTY_OPEN_BANK_NAME AS OPP_BANK_NM  --对方行名
    ,NULL AS TRA_CHAN  --交易渠道
    ,A.CURR_CD AS CUR  --币种
    ,NULL AS CASH_TRF_FLG  --现转标志
    ,'' AS AGT_NM  --代办人姓名
    ,'' AS AGT_CRDL_TYP  --代办人证件类型
    ,'' AS AGT_CRDL_NO  --代办人证件号码
    ,'' AS TRA_TLR_NO  --交易柜员号
    ,'' AS GRANT_TLR_NO  --授权柜员号
    ,'' AS ABSTR  --摘要
    ,'' AS FLUSH_PATCH_FLG  --冲补抹标志
    ,'' AS TRA_DR_CR_FLG  --交易借贷标志
    ,A.VALUE_DT  AS         TRA_TM  --交易时间
    ,'' AS AST_LBY_SIDE_FLG  --资产负债方标志
    ,A.SUBJ_ID         AS      SUBJ_ID  --科目编号
    ,'' AS OCCUR_SETL_TYP  --发生结清类型
    ,'' AS DEPT_LINE  --部门条线
    ,'同业现金借贷回购'         DATA_SRC  --数据来源
      FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
  LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息表
    ON A.CNTPTY_ID = D.SRC_PARTY_ID
   AND D.ETL_DT = A.ETL_DT
  WHERE A.SUBJ_ID LIKE '111102%'   --买入返售
    AND A.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.CURRT_BAL>0;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 数据重复校验 --
        WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_REPO_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,SEQ_NO,ACC_ID
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

  END ETL_INIT_M_TRA_REPO_DTL;
/

