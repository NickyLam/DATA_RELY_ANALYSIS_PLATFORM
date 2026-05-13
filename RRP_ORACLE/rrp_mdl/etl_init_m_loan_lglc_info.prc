CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_LGLC_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_LGLC_INFO
  *  功能描述：保函与信用证信息表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO
  *  配置表：  CODE_MAP
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20220523  梅炜      首次创建
  *   2    20220903  MW      增加远期标志逻辑
  *   3    20221009  hulj    调整受益人国家代码，受益人开户行名称逻辑
  *   4    20221011  hulj    调整表外业务取值
  *   5    20221101  hulj    新增卖断式转贴现部分口径
  *   6    20221118  LHQ     调整支付期限口径
  *   7    20221121  xucx    增加字段取合同有效标志
  *   8    20221122  LHQ     调整信用证合同期起始日期和合同到期日期口径，以east5.0口径为准
  *   9    20221201  hulj    修改卖断式转贴现部分票据转贴和对公借据的关联条件
  *   10   20221202  hulj    新增字标准产品编号,取消关联科目信息表逻辑,经办柜员号直取信用证账户表经办柜员号,部门条线为空
  *   11   20221227  hulj    修改卖断式转贴现部分机构号和客户号取值
  *   12   20230207  ly      调整过程格式

  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_LGLC_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_LGLC_INFO'; --表名
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
  V_STEP_DESC := '插入保函与信用证信息表-信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_LGLC_INFO

  (
       DATA_DT                                   --01 数据日期
      ,LGL_REP_ID                                --02 法人编号
      ,ORG_ID                                    --03 机构编号
      ,ACCT_INSTIT_ID                            --04 账务机构
      ,SUBJ_ID                                   --05 科目编号
      ,BIZ_ID                                    --06 业务编号
      ,DUBIL_ID                                  --07 借据编号
      ,CONT_ID                                   --08 合同编号
      ,OUT_BIZ_TYP                               --09 表外业务类型
      ,LC_TYP                                    --10 信用证类型
      ,CUR                                       --11 币种
      ,CONT_AMT                                  --12 合同金额
      ,ALDY_CASH_AMT                             --13 已兑付金额
      ,TD_PAY_AMT                                --14 待支付金额
      ,CONT_START_DT                             --15 合同起始日期
      ,CONT_EXP_DT                               --16 合同到期日期
      ,APP_PSN_ID                                --17 申请人编号
      ,APP_PSN_NM                                --18 申请人名称
      ,APP_PSN_ACC                               --19 申请人账号
      ,APP_PSN_OPEN_BANK_NM                      --20 申请人开户行名称
      ,BNF_NM                                    --21 受益人名称
      ,BNF_CTRY_CD                               --22 受益人国家代码
      ,BNF_ACC                                   --23 受益人账号
      ,BNF_OPEN_BANK_NM                          --24 受益人开户行名称
      ,PAY_BANK_ID                               --25 付款行编号
      ,PAY_BANK_NM                               --26 付款行名称
      ,APP_PSN_PAY_TERM                          --27 申请人支付期限
      ,CONT_TRA_BKGD                             --28 合同贸易背景
      ,COMM_CUR                                  --29 手续费币种
      ,COMM_AMT                                  --30 手续费金额
      ,MRGN_PCT                                  --31 保证金比例
      ,MRGN_CUR                                  --32 保证金币种
      ,MRGN_ACC                                  --33 保证金账号
      ,MRGN                                      --34 保证金
      ,CONT_STAT                                 --35 合同状态
      ,HDLR_NO                                   --36 经办人工号
      ,DEPT_LINE                                 --37 部门条线
      ,DATA_SRC                                  --38 数据来源
      ,GRN_CRDT_USEAGE_CL_1104                   --39 绿色授信用途分类1104
      ,CER_MTG_CRDT_FLG                          --40 以碳排放权为抵押的授信标志
      ,ER_MTG_CRDT_FLG                           --41 以环境权益为抵押的授信标志
      ,PAY_TERM                                  --42 支付期限
      ,DIR_IDY                                   --43 投向行业
      ,LCL_GOVFINPLTF_FIN_CHAR                   --44 地方政府融资平台融资性质
      ,PRO_IMPT                                  --45 减值准备
      ,BIZ_CL                                    --46 业务种类
      ,APP_PSN_CTRY_CD                           --47 申请人国家代码
      ,FWD_FLG                                   --48 远期标志
      ,ORIG_TERM_CODE                            --49 原始期限类型
      ,BAL                                       --50 余额
      ,CUST_ID                                   --51 客户编号
      ,TRAN_AMT                                  --52 业务发生金额
      ,VALID_FLG_CD                              --53 合同有效标志代码cd2586
      ,STD_PROD_ID                               --54 标准产品编号
      ,CTR_NT_ID                                 --55 成交单编号
      ,BUS_DT                                    --56 业务日期
      ,DISCNT_INT_RAT                            --57 贴现利率
      ,ACCT_TYP                                  --58 账户类型
      ,GRN_CRDT_USEAGE_CL                        --59 绿色授信用途分类
    )
 SELECT --针对大表可以写SELECT /*PRALLEL(4)*/
        TO_CHAR(E.ETL_DT, 'YYYYMMDD')          AS DATA_DT                     --01 数据日期
       ,E.LP_ID                                AS LGL_REP_ID                  --02 法人编号
       ,C.ORG_ID                               AS ORG_ID                      --03 机构编号
       ,A.ACCT_INSTIT_ID                       AS ACCT_INSTIT_ID              --04 账务机构编号
       ,A.SUBJ_ID                              AS SUBJ_ID                     --05 明细科目编号
       ,NVL(A.LC_ID, B.DUBIL_ID)               AS BIZ_ID                      --06 业务编号 这个字段EAST没有用到，后续可根据需要调整
       ,B.DUBIL_ID                             AS DUBIL_ID                    --07 借据编号
       ,E.CONT_ID                              AS CONT_ID                     --08 合同编号
       ,CASE WHEN B.STD_PROD_ID = '601040100001' THEN 'A0201'
             ELSE 'A0299'
        END                                    AS OUT_BIZ_TYP                 --09 表外业务类型
       ,CASE WHEN B.STD_PROD_ID IN ('601020100001','601020100002','603010100002') THEN '01' --国内
             WHEN B.STD_PROD_ID IN ('601020200001','601020200002','603010300002') THEN '02' -- 国际信用证
        END                                    AS LC_TYP                      --10 信用证类型
       ,E.CURR_CD                              AS CUR                         --11 币种
       ,E.CONT_AMT                             AS CONT_AMT                    --12 合同金额 MODIFY BY MW 20221108
       ,NVL(E.CONT_AMT,0) - NVL(B.DUBIL_BAL,0) AS ALDY_CASH_AMT               --13 已兑付金额
       ,B.DUBIL_BAL                            AS TD_PAY_AMT                  --14 待支付金额                                                             --合同到期日期
       ,CASE WHEN TO_CHAR(A.ISSUE_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.ISSUE_DT,'YYYYMMDD')
             WHEN TO_CHAR(E.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(E.DISTR_DT,'YYYYMMDD')
        END                                    AS CONT_START_DT               --15 合同起始日期 --20221122  LHQ 以east5.0口径为准
       ,CASE WHEN TO_CHAR(A.WRTOFF_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.WRTOFF_DT,'YYYYMMDD')
             WHEN TO_CHAR(E.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(E.EXP_DT,'YYYYMMDD')
             ELSE '99991231'
        END                                    AS CONT_EXP_DT                 --16 合同到期日期  --20221122  LHQ 以east5.0口径为准
       ,NVL(A.CUST_ID, E.CUST_ID)              AS APP_PSN_ID                  --17 申请人编号
       ,K.CUST_NAME                            AS APP_PSN_NM                  --18 申请人名称
       ,NULL                                   AS APP_PSN_ACC                 --19 申请人账号
       ,NULL                                   AS APP_PSN_OPEN_BANK_NM        --20 申请人开户行名称
       ,A.BENEFC_NAME                          AS BNF_NM                      --21 受益人名称
       ,A.BENEFC_CTY_CD                        AS BNF_CTRY_CD                 --22 受益人国家代码
       ,B.DISTR_ACCT_NUM                       AS BNF_ACC                     --23 受益人账号
       ,B.RECVBL_BANK_NAME                     AS BNF_OPEN_BANK_NM            --24 受益人开户行名称 字段需等到数仓新增
       ,NULL                                   AS PAY_BANK_ID                 --25 付款行编号
       ,NULL                                   AS PAY_BANK_NM                 --26 付款行名称
       ,CASE WHEN A.FWD_FLG = '0' THEN 0
                  --如果是已开证尚未提示付款/承兑的，按照答疑口径，支付期限可以暂时为空
             WHEN TO_CHAR(L.PAY_DT,'YYYYMMDD') IN ('00010101','20991231') THEN NULL
             ELSE L.PAY_DT - /*L.ACPT_DT*/IBS_EVT.CHECK_DT --提示承兑的日期
        END                                    AS APP_PSN_PAY_TERM            --27 申请人支付期限 --20221118 LHQ 调整支付期限口径
       ,H.BACK_INFO_DESCB                      AS CONT_TRA_BKGD               --28 合同贸易背景
       ,NVL(A.CURR_CD, E.CURR_CD)              AS COMM_CUR                    --29 手续费币种
       ,CASE WHEN NVL(A.COMM_FEE_AMT,0) <> 0 THEN A.COMM_FEE_AMT
             WHEN NVL(E.COMM_FEE_AMT,0) <> 0 THEN E.COMM_FEE_AMT
             WHEN NVL(E.COMM_FEE_RAT,0) <> 0 THEN E.CONT_AMT * E.COMM_FEE_RAT / 1000  --新一代手续费核心不计算，只有手续费率
             ELSE 0
        END                                    AS COMM_AMT                    --30 手续费金额  --modify by tangan at 20230113
       ,E.MARGIN_RATIO                         AS MRGN_PCT                    --31 保证金比例
       ,E.MARGIN_CURR_CD                       AS MRGN_CUR                    --32 保证金币种
       ,NVL(E.MARGIN_ACCT_NUM,B.MARGIN_ACCT_NUM)
                                               AS MRGN_ACC                    --33 保证金账号
       ,E.MARGIN_AMT                           AS MRGN                        --34 保证金
       ,CASE WHEN A.LC_STATUS_CD = '01' THEN '02' --正常
             WHEN A.LC_STATUS_CD = '02' THEN '06' --关闭
           ELSE '99'
        END                                    AS CONT_STAT                   --35 合同状态
       ,NVL(I.CLERK_ID,A.OPER_TELLER_ID)       AS HDLR_NO                     --36 经办人工号
       ,NULL                                   AS DEPT_LINE                   --37 部门条线
       ,'信用证'                               AS DATA_SRC                    --38 数据来源
       ,NVL(TTA.TAR_VALUE_CODE,K.GREEN_CRDT_CLS_CD)
                                               AS GRN_CRDT_USEAGE_CL_1104     --39 绿色授信用途分类1104
       ,NULL                                   AS CER_MTG_CRDT_FLG            --40 以碳排放权为抵押的授信标志
       ,NULL                                   AS ER_MTG_CRDT_FLG             --41 以环境权益为抵押的授信标志
       ,NULL                                   AS PAY_TERM                    --42 支付期限
       ,B.DIR_INDUS_CD                         AS DIR_IDY                     --43 投向行业
       ,NULL                                   AS LCL_GOVFINPLTF_FIN_CHAR     --44 地方政府融资平台融资性质
       ,NULL                                   AS PRO_IMPT                    --45 减值准备
       ,NULL                                   AS BIZ_CL                      --46 业务种类
       ,NULL                                   AS APP_PSN_CTRY_CD             --47 申请人国家代码
       ,A.FWD_FLG                              AS FWD_FLG                     --48 远期标志
       ,CASE WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>60 THEN '5YA'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>36 THEN '5Y'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>24 THEN '3Y'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>12 THEN '2Y'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>6 THEN '12M'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>3 THEN '6M'
             WHEN MONTHS_BETWEEN(A.EXP_DT,A.EFFECT_DT)>=0 THEN '3M'
        END                                    AS ORIG_TERM_CODE              --49 原始期限类型
       ,B.NOMAL_PRIC                           AS BAL                         --50 余额  ADD 20221028
       ,A.CUST_ID                              AS CUST_ID                     --51 客户编号
       ,A.ISSUE_AMT                            AS TRAN_AMT                    --52 业务发生金额
       ,E.VALID_FLG_CD                         AS VALID_FLG_CD                --53 合同有效标志代码cd2586
       ,A.STD_PROD_ID                          AS STD_PROD_ID                 --54 标准产品编号
       ,NULL                                   AS CTR_NT_ID                   --55 成交单编号
       ,NULL                                   AS BUS_DT                      --56 业务日期
       ,NULL                                   AS DISCNT_INT_RAT              --57 贴现利率
       ,CASE WHEN A.LC_PAY_TYPE_CD= 'P' THEN '311' ELSE '312' END
                                               AS ACCT_TYP                    --58 账户类型
       ,CASE WHEN K.GREEN_CRDT_CUST_FLG = '1'
             THEN DECODE(K.GREEN_CRDT_CLS_CD,'-','',K.GREEN_CRDT_CLS_CD)
        END                                    AS GRN_CRDT_USEAGE_CL          --59 绿色授信用途分类
  FROM RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
 INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    ON A.DUBIL_NUM = B.DUBIL_ID
   AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
    ON B.CONT_ID = E.CONT_ID
   AND E.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息
    ON C.ORG_ID = A.ACCT_INSTIT_ID
   AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO K --对公客户信息表
    ON NVL(A.CUST_ID, E.CUST_ID) = K.CUST_ID
   AND K.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO H --对公贷款合同业务补充信息
    ON E.CONT_ID = H.CONT_ID
   AND H.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN (SELECT TELLER_ID, CLERK_ID
               FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
              WHERE TRIM(TELLER_ID) <> ' '
                AND ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')) I --行员信息
    ON B.OPER_TELLER_ID = I.TELLER_ID
  LEFT JOIN (SELECT LC_ACCT_ID,
                    MX_LC_FLG,
                    MIN(ACPT_DT) AS ACPT_DT,
                    MAX(PAY_DT) AS PAY_DT --MODIFY BY LHQ 20221118
               FROM RRP_MDL.O_ICL_CMM_LC_DOC_INFO
              WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
              GROUP BY LC_ACCT_ID, MX_LC_FLG) L --信用证单据信息
    ON L.LC_ACCT_ID = A.ACCT_ID
   AND L.MX_LC_FLG = A.MX_LC_FLG
  LEFT JOIN RRP_MDL.O_IML_EVT_INTSTL_TRAN_FLOW_EVT IBS_EVT --ADD BY LHQ 20221118 取信用证提示承兑的日期
    ON IBS_EVT.BUS_TAB_FLOW_NUM = A.ACCT_ID
   AND IBS_EVT.AUTH_STATUS_CD = 'R'
   AND IBS_EVT.TRAN_NAME IN ('BRTUDP', 'BDTUDP')
   AND IBS_EVT.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN CODE_MAP TTA --绿色贷款用途转码
    ON TTA.SRC_VALUE_CODE = K.GREEN_CRDT_CLS_CD
   AND TTA.SRC_CLASS_CODE = 'CD2390'
   AND TTA.TAR_CLASS_CODE = 'D0142'
   AND TTA.MOD_FLG = 'MDM'
 WHERE B.STD_PROD_ID IN ('601020100001',
                         '601020100002',
                         '603010100002',
                         '601020200001',
                         '601020200002',
                         '603010300002') --信用证
   AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入保函与信用证信息表-保函';
  V_STARTTIME := SYSDATE;

   INSERT /*+APPEND */INTO RRP_MDL.M_LOAN_LGLC_INFO
  (

       DATA_DT                                   --01 数据日期
      ,LGL_REP_ID                                --02 法人编号
      ,ORG_ID                                    --03 机构编号
      ,ACCT_INSTIT_ID                            --04 账务机构
      ,SUBJ_ID                                   --05 科目编号
      ,BIZ_ID                                    --06 业务编号
      ,DUBIL_ID                                  --07 借据编号
      ,CONT_ID                                   --08 合同编号
      ,OUT_BIZ_TYP                               --09 表外业务类型
      ,LC_TYP                                    --10 信用证类型
      ,CUR                                       --11 币种
      ,CONT_AMT                                  --12 合同金额
      ,ALDY_CASH_AMT                             --13 已兑付金额
      ,TD_PAY_AMT                                --14 待支付金额
      ,CONT_START_DT                             --15 合同起始日期
      ,CONT_EXP_DT                               --16 合同到期日期
      ,APP_PSN_ID                                --17 申请人编号
      ,APP_PSN_NM                                --18 申请人名称
      ,APP_PSN_ACC                               --19 申请人账号
      ,APP_PSN_OPEN_BANK_NM                      --20 申请人开户行名称
      ,BNF_NM                                    --21 受益人名称
      ,BNF_CTRY_CD                               --22 受益人国家代码
      ,BNF_ACC                                   --23 受益人账号
      ,BNF_OPEN_BANK_NM                          --24 受益人开户行名称
      ,PAY_BANK_ID                               --25 付款行编号
      ,PAY_BANK_NM                               --26 付款行名称
      ,APP_PSN_PAY_TERM                          --27 申请人支付期限
      ,CONT_TRA_BKGD                             --28 合同贸易背景
      ,COMM_CUR                                  --29 手续费币种
      ,COMM_AMT                                  --30 手续费金额
      ,MRGN_PCT                                  --31 保证金比例
      ,MRGN_CUR                                  --32 保证金币种
      ,MRGN_ACC                                  --33 保证金账号
      ,MRGN                                      --34 保证金
      ,CONT_STAT                                 --35 合同状态
      ,HDLR_NO                                   --36 经办人工号
      ,DEPT_LINE                                 --37 部门条线
      ,DATA_SRC                                  --38 数据来源
      ,GRN_CRDT_USEAGE_CL_1104                   --39 绿色授信用途分类1104
      ,CER_MTG_CRDT_FLG                          --40 以碳排放权为抵押的授信标志
      ,ER_MTG_CRDT_FLG                           --41 以环境权益为抵押的授信标志
      ,PAY_TERM                                  --42 支付期限
      ,DIR_IDY                                   --43 投向行业
      ,LCL_GOVFINPLTF_FIN_CHAR                   --44 地方政府融资平台融资性质
      ,PRO_IMPT                                  --45 减值准备
      ,BIZ_CL                                    --46 业务种类
      ,APP_PSN_CTRY_CD                           --47 申请人国家代码
      ,FWD_FLG                                   --48 远期标志
      ,ORIG_TERM_CODE                            --49 原始期限类型
      ,BAL                                       --50 余额
      ,CUST_ID                                   --51 客户编号
      ,TRAN_AMT                                  --52 业务发生金额
      ,VALID_FLG_CD                              --53 合同有效标志代码cd2586
      ,STD_PROD_ID                               --54 标准产品编号
      ,CTR_NT_ID                                 --55 成交单编号
      ,BUS_DT                                    --56 业务日期
      ,DISCNT_INT_RAT                            --57 贴现利率
      ,ACCT_TYP                                  --58 账户类型
      ,GRN_CRDT_USEAGE_CL                        --59 绿色授信用途分类
  )
  SELECT
       TO_CHAR(E.ETL_DT, 'YYYYMMDD')           AS DATA_DT                    --01 数据日期
      ,E.LP_ID                                 AS LGL_REP_ID                 --02 法人编号
      ,C.ORG_ID                                AS ORG_ID                     --03 内部机构编号
      ,A.ACCT_INSTIT_ID                        AS ACCT_INSTIT_ID             --04 账务机构编号
      ,A.SUBJ_CD                               AS SUBJ_ID                    --05 明细科目编号
      ,NVL(A.LOG_CONT_ID, B.DUBIL_ID)          AS BIZ_ID                     --06 业务编号 这个字段EAST没有用到，后续可根据需要调整
      ,B.DUBIL_ID                              AS DUBIL_ID                   --07 借据编号
      ,E.CONT_ID                               AS CONT_ID                    --08 合同编号
      ,CASE WHEN A.FIN_LOG_FLG = '1' THEN 'A0301' --融资性保函
            WHEN A.FIN_LOG_FLG = '0' THEN 'A0302' --非融资性保函
            ELSE
              CASE WHEN B.STD_PROD_ID LIKE '60103010000%' THEN 'A0301'--融资性保函
                   WHEN B.STD_PROD_ID  LIKE '60103020000%'THEN 'A0302'  --非融资性保函
                   WHEN B.STD_PROD_ID  LIKE '5020101%'THEN 'A0301'  --融资性保函
                   WHEN B.STD_PROD_ID  LIKE '5020102%'THEN 'A0302'  --非融资性保函
              END
       END                                     AS OUT_BIZ_TYP                --09 表外业务类型
      ,NULL                                    AS LC_TYP                     --10 信用证类型  modify by xieyugeng 20221011
      ,E.CURR_CD                               AS CUR                        --11 币种
      ,E.CONT_AMT                              AS CONT_AMT                   --12 合同金额
      ,NVL(E.CONT_AMT,0) - NVL(B.DUBIL_BAL,0)
                                               AS ALDY_CASH_AMT              --13 已兑付金额
      ,B.DUBIL_BAL                             AS TD_PAY_AMT                 --14 待支付金额
      ,TO_CHAR(NVL(A.OPEN_DT, E.DISTR_DT), 'YYYYMMDD')
                                               AS CONT_START_DT              --15 合同起始日期
      ,CASE WHEN TO_CHAR(NVL(A.EXP_DT, E.EXP_DT), 'YYYYMMDD') IN ('00010101','20991231') THEN '99991231'
            ELSE TO_CHAR(NVL(A.EXP_DT, E.EXP_DT), 'YYYYMMDD')
       END                                     AS CONT_EXP_DT                --16 合同到期日期
      ,E.CUST_ID                               AS APP_PSN_ID                 --17 申请人编号
      ,CC.CUST_NAME                            AS APP_PSN_NM                 --18 申请人名称
      ,NULL                                    AS APP_PSN_ACC                --19 申请人账号
      ,NULL                                    AS APP_PSN_OPEN_BANK_NM       --20 申请人开户行名称
      ,TRIM(A.BENEFC_NAME)                     AS BNF_NM                     --21 受益人名称       --MODIFY BY hulj 20221009
      ,TRIM(A.BENEFC_CTY_CD)                   AS BNF_CTRY_CD                --22 受益人国家代码   --MODIFY BY hulj 20221009
      ,TRIM(A.BENEFC_ACCT_NUM)                 AS BNF_ACC                    --23 受益人账号       --MODIFY BY hulj 20221009
      ,TRIM(A.BENEFC_OPEN_BANK_NAME)           AS BNF_OPEN_BANK_NM           --24 受益人开户行名称 --MODIFY BY hulj 20221009
      ,NULL                                    AS PAY_BANK_ID                --25 付款行编号
      ,NULL                                    AS PAY_BANK_NM                --26 付款行名称
      ,0                                       AS APP_PSN_PAY_TERM           --27 申请人支付期限 --MODIFY BY LHQ 20221118
      ,H.BACK_INFO_DESCB                       AS CONT_TRA_BKGD              --28 合同贸易背景
      ,NVL(A.CURR_CD, E.CURR_CD)               AS COMM_CUR                   --29 手续费币种
      ,NVL(A.COMM_FEE_AMT, E.COMM_FEE_AMT)     AS COMM_AMT                   --30 手续费金额
      ,A.MARGIN_RATIO                          AS MRGN_PCT                   --31 保证金比例
      ,A.MARGIN_CURR                           AS MRGN_CUR                   --32 保证金币种
      ,A.MARGIN_ACCT_NUM                       AS MRGN_ACC                   --33 保证金账号
      ,E.MARGIN_AMT                            AS MRGN                       --34 保证金
      ,CASE WHEN A.LOG_STATUS = '01' THEN '02'
            WHEN A.LOG_STATUS = '05' THEN '05'
            ELSE '99'
       END                                     AS CONT_STAT                  --35 合同状态   modify  xieyugeng 20221010  数仓码值变化 码值引用 CD2853-保函状态代码
      ,NVL(I.CLERK_ID,B.OPER_ORG_ID)           AS HDLR_NO                    --36 经办人工号
      ,NULL                                    AS DEPT_LINE                  --37 部门条线
      ,'保函'                                  AS DATA_SRC                   --38 数据来源
      ,CASE WHEN A.STD_PROD_ID IN (
       '203020100001',
       '203020100002',
       '203020100003',
       '203020100004',
       '203020100005',
       '203020100006',
       '203020200001',
       '203020300001',
       '203020300002',
       '203020400001',
       '203020500001',
       '203020600001',
       '203020700001',
       '203020700002',
       '203020800001',
       '203030100001',
       '203030200001',
       '203030300001',
       '203030300002',
       '203030400001',
       '203030500001',
       '203030600001',
       '203030600002') --贸易融资
       THEN (CASE WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A01%' THEN '0801'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A02%' THEN '0802'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A03%' THEN '0803'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A04%' THEN '0804'
                  ELSE '0805' END  )
       ELSE NVL(TTA.TAR_VALUE_CODE,CC.GREEN_CRDT_CLS_CD)
       END
                                               AS GRN_CRDT_USEAGE_CL_1104    --39 绿色授信用途分类1104
      ,NULL                                    AS CER_MTG_CRDT_FLG           --40 以碳排放权为抵押的授信标志
      ,NULL                                    AS ER_MTG_CRDT_FLG            --41 以环境权益为抵押的授信标志
      ,NULL                                    AS PAY_TERM                   --42 支付期限
      ,B.DIR_INDUS_CD                          AS DIR_IDY                    --43 投向行业
      ,NULL                                    AS LCL_GOVFINPLTF_FIN_CHAR    --44 地方政府融资平台融资性质
      ,NULL                                    AS PRO_IMPT                   --45 减值准备
      ,NULL                                    AS BIZ_CL                     --46 业务种类
      ,NULL                                    AS APP_PSN_CTRY_CD            --47 申请人国家代码
      ,NULL                                    AS FWD_FLG                    --48 远期标志
      ,CASE WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>60 THEN '5YA'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>36 THEN '5Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>24 THEN '3Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>12 THEN '2Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>6 THEN '12M'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>3 THEN '6M'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.OPEN_DT)>=0 THEN '3M'
       END                                     AS ORIG_TERM_CODE             --49 原始期限类型
      ,A.CURRT_BAL                             AS BAL                        --50 余额
      ,B.CUST_ID                               AS CUST_ID                    --51 客户编号
      ,A.LOG_AMT                               AS TRAN_AMT                   --52 业务发生金额
      ,E.VALID_FLG_CD                          AS VALID_FLG_CD               --53 合同有效标志代码CD2586 add by 20221121 xucx
      ,A.STD_PROD_ID                           AS STD_PROD_ID                --54 标准产品编号
      ,NULL                                    AS CTR_NT_ID                  --55 成交单编号
      ,NULL                                    AS BUS_DT                     --56 业务日期
      ,NULL                                    AS DISCNT_INT_RAT             --57 贴现利率
      ,CASE WHEN A.FIN_LOG_FLG = '1' OR A.SUBJ_CD='71180101' THEN '121'
            WHEN A.FIN_LOG_FLG = '0' THEN '211'
            ELSE ''
       END                                     AS ACCT_TYP                   --58 账户类型
      ,CASE WHEN CC.GREEN_CRDT_CUST_FLG = '1'
            THEN DECODE(CC.GREEN_CRDT_CLS_CD,'-','',CC.GREEN_CRDT_CLS_CD)
       END                                     AS GRN_CRDT_USEAGE_CL         --59 绿色授信用途分类
   FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
     ON E.CONT_ID = B.CONT_ID
    AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  INNER JOIN RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息
     ON A.LOG_CONT_ID = B.DUBIL_ID
    AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO CC --对公客户基本信息
     ON E.CUST_ID = CC.CUST_ID
    AND CC.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息
     ON C.ORG_ID = E.RGST_ORG_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO D --科目信息
     ON A.SUBJ_CD = D.SUBJ_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO H --业务合同补充信息
     ON E.CONT_ID = H.CONT_ID
    AND H.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN (SELECT TELLER_ID, CLERK_ID
                FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
               WHERE TRIM(TELLER_ID) <> ' '
                 AND ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')) I --行员信息
     ON B.OPER_TELLER_ID = I.TELLER_ID
   LEFT JOIN RRP_MDL.O_ICL_CMM_OUT_REMIT_DTL J --汇出汇款明细
     ON J.RECVER_NAME = A.BENEFC_NAME
    AND J.TRAN_FLOW_ID = E.APV_FLOW_NUM
    AND J.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN CODE_MAP TTA --绿色贷款用途转码
     ON TTA.SRC_VALUE_CODE = CC.GREEN_CRDT_CLS_CD
    AND TTA.SRC_CLASS_CODE = 'CD2390'
    AND TTA.TAR_CLASS_CODE = 'D0142'
    AND TTA.MOD_FLG = 'MDM'
  WHERE (B.STD_PROD_ID LIKE '60103010000%' OR
        B.STD_PROD_ID LIKE '60103020000%')
    AND E.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入保函与信用证信息表-卖断式转贴现部分'; ---信用风险仍在银行的销售与购买协议
  V_STARTTIME := SYSDATE;

   INSERT /*+APPEND */INTO RRP_MDL.M_LOAN_LGLC_INFO
  (
       DATA_DT                                   --01 数据日期
      ,LGL_REP_ID                                --02 法人编号
      ,ORG_ID                                    --03 机构编号
      ,ACCT_INSTIT_ID                            --04 账务机构
      ,SUBJ_ID                                   --05 科目编号
      ,BIZ_ID                                    --06 业务编号
      ,DUBIL_ID                                  --07 借据编号
      ,CONT_ID                                   --08 合同编号
      ,OUT_BIZ_TYP                               --09 表外业务类型
      ,LC_TYP                                    --10 信用证类型
      ,CUR                                       --11 币种
      ,CONT_AMT                                  --12 合同金额
      ,ALDY_CASH_AMT                             --13 已兑付金额
      ,TD_PAY_AMT                                --14 待支付金额
      ,CONT_START_DT                             --15 合同起始日期
      ,CONT_EXP_DT                               --16 合同到期日期
      ,APP_PSN_ID                                --17 申请人编号
      ,APP_PSN_NM                                --18 申请人名称
      ,APP_PSN_ACC                               --19 申请人账号
      ,APP_PSN_OPEN_BANK_NM                      --20 申请人开户行名称
      ,BNF_NM                                    --21 受益人名称
      ,BNF_CTRY_CD                               --22 受益人国家代码
      ,BNF_ACC                                   --23 受益人账号
      ,BNF_OPEN_BANK_NM                          --24 受益人开户行名称
      ,PAY_BANK_ID                               --25 付款行编号
      ,PAY_BANK_NM                               --26 付款行名称
      ,APP_PSN_PAY_TERM                          --27 申请人支付期限
      ,CONT_TRA_BKGD                             --28 合同贸易背景
      ,COMM_CUR                                  --29 手续费币种
      ,COMM_AMT                                  --30 手续费金额
      ,MRGN_PCT                                  --31 保证金比例
      ,MRGN_CUR                                  --32 保证金币种
      ,MRGN_ACC                                  --33 保证金账号
      ,MRGN                                      --34 保证金
      ,CONT_STAT                                 --35 合同状态
      ,HDLR_NO                                   --36 经办人工号
      ,DEPT_LINE                                 --37 部门条线
      ,DATA_SRC                                  --38 数据来源
      ,GRN_CRDT_USEAGE_CL_1104                   --39 绿色授信用途分类1104
      ,CER_MTG_CRDT_FLG                          --40 以碳排放权为抵押的授信标志
      ,ER_MTG_CRDT_FLG                           --41 以环境权益为抵押的授信标志
      ,PAY_TERM                                  --42 支付期限
      ,DIR_IDY                                   --43 投向行业
      ,LCL_GOVFINPLTF_FIN_CHAR                   --44 地方政府融资平台融资性质
      ,PRO_IMPT                                  --45 减值准备
      ,BIZ_CL                                    --46 业务种类
      ,APP_PSN_CTRY_CD                           --47 申请人国家代码
      ,FWD_FLG                                   --48 远期标志
      ,ORIG_TERM_CODE                            --49 原始期限类型
      ,BAL                                       --50 余额
      ,CUST_ID                                   --51 客户编号
      ,TRAN_AMT                                  --52 业务发生金额
      ,VALID_FLG_CD                              --53 合同有效标志代码cd2586
      ,STD_PROD_ID                               --54 标准产品编号
      ,CTR_NT_ID                                 --55 成交单编号
      ,BUS_DT                                    --56 业务日期
      ,DISCNT_INT_RAT                            --57 贴现利率
      ,ACCT_TYP                                  --58 账户类型
      ,GRN_CRDT_USEAGE_CL                        --59 绿色授信用途分类
  )
  SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                   --01 数据日期
      ,A.LP_ID                                      AS LGL_REP_ID                --02 法人编号
      ,'896001'                                     AS ORG_ID                    --03 内部机构编号
      ,'896001'                                     AS ACCT_INSTIT_ID            --04 账务机构编号
      ,A.SUBJ_ID                                    AS SUBJ_ID                   --05 明细科目编号
      ,A.BILL_ID                                    AS BIZ_ID                    --06 业务编号 -- MOD BY LIUYU 基表核对取主键BILL_ID
      ,A.BILL_ID                                    AS DUBIL_ID                  --07 借据编号 -- MOD BY LIUYU 基表核对取主键BILL_ID
      ,NVL(TRIM(B.CONT_ID), TRIM(A.BILL_ID))        AS CONT_ID                   --08 合同编号
      ,'A0401'                                      AS OUT_BIZ_TYP               --09 表外业务类型
      ,NULL                                         AS LC_TYP                    --10 信用证类型
      ,A.CURR_CD                                    AS CUR                       --11 币种
      ,A.FAC_VAL_AMT                                AS CONT_AMT                  --12 合同金额
      ,NVL(A.FAC_VAL_AMT,0) - NVL(A.CURRT_BAL,0)    AS ALDY_CASH_AMT             --13 已兑付金额
      ,A.CURRT_BAL                                  AS TD_PAY_AMT                --14 待支付金额
      ,CASE WHEN TO_CHAR(A.DRAW_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.DRAW_DT,'YYYYMMDD')
            WHEN TO_CHAR(C.DRAW_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(C.DRAW_DT,'YYYYMMDD')
       END                                          AS CONT_START_DT             --15 合同起始日期 --MODIFY BY LIP 20220720
      ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
            WHEN TO_CHAR(C.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(C.EXP_DT,'YYYYMMDD')
       END                                          AS CONT_EXP_DT               --16 合同到期日期 --MODIFY BY LIP 20220720
      ,B.CUST_ID                                    AS APP_PSN_ID                --17 申请人编号
      ,C.ACCPTOR_NAME                               AS APP_PSN_NM                --18 申请人名称
      ,C.ACCPTOR_ACCT_NUM                           AS APP_PSN_ACC               --19 申请人账号
      ,C.ACCPTOR_OPEN_BANK_NAME                     AS APP_PSN_OPEN_BANK_NM      --20 申请人开户行名称
      ,C.RECVER_NAME                                AS BNF_NM                    --21 受益人名称
      ,'CHN'                                        AS BNF_CTRY_CD               --22 受益人国家代码
      ,TRIM(C.RECVER_ACCT_NUM)                      AS BNF_ACC                   --23 受益人账号
      ,TRIM(C.RECVER_OPEN_BANK_NAME)                AS BNF_OPEN_BANK_NM          --24 受益人开户行名称
      ,TRIM(C.PAY_BANK_BANK_NO)                     AS PAY_BANK_ID               --25 付款行编号
      ,TRIM(C.PAY_BANK_NAME)                        AS PAY_BANK_NM               --26 付款行名称
      ,0                                            AS APP_PSN_PAY_TERM          --27 申请人支付期限
      ,D.TRADE_TRAN_CONTENT                         AS CONT_TRA_BKGD             --28 合同贸易背景
      ,NULL                                         AS COMM_CUR                  --29 手续费币种
      ,0                                            AS COMM_AMT                  --30 手续费金额
      ,B.MARGIN_RATIO                               AS MRGN_PCT                  --31 保证金比例
      ,B.MARGIN_CURR_CD                             AS MRGN_CUR                  --32 保证金币种
      ,B.MARGIN_ACCT_NUM                            AS MRGN_ACC                  --33 保证金账号
      ,B.MARGIN_AMT                                 AS MRGN                      --34 保证金
      ,'02'                                         AS CONT_STAT                 --35 合同状态
      ,A.CUST_MGR_ID                                AS HDLR_NO                   --36 经办人工号
      ,NULL                                         AS DEPT_LINE                 --37 部门条线
      ,'卖断式转贴现'                               AS DATA_SRC                  --38 数据来源
      ,CASE WHEN A.STD_PROD_ID IN (
       '203020100001',
       '203020100002',
       '203020100003',
       '203020100004',
       '203020100005',
       '203020100006',
       '203020200001',
       '203020300001',
       '203020300002',
       '203020400001',
       '203020500001',
       '203020600001',
       '203020700001',
       '203020700002',
       '203020800001',
       '203030100001',
       '203030200001',
       '203030300001',
       '203030300002',
       '203030400001',
       '203030500001',
       '203030600001',
       '203030600002') --贸易融资
       THEN (CASE WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A01%' THEN '0801'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A02%' THEN '0802'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A03%' THEN '0803'
                  WHEN CC.GREEN_CRDT_CLS_CD LIKE 'A04%' THEN '0804'
                  ELSE '0805' END  )
       ELSE NVL(TTA.TAR_VALUE_CODE,CC.GREEN_CRDT_CLS_CD)
       END
                                                    AS GRN_LOAN_USEAGE_CL_1104     --39 绿色贷款用途分类1104
      ,NULL                                         AS CER_MTG_CRDT_FLG            --40 以碳排放权为抵押的授信标志
      ,NULL                                         AS ER_MTG_CRDT_FLG             --41 以环境权益为抵押的授信标志
      ,NULL                                         AS PAY_TERM                    --42 支付期限
      ,B.DIR_INDUS_CD                               AS DIR_IDY                     --43 投向行业
      ,NULL                                         AS LCL_GOVFINPLTF_FIN_CHAR     --44 地方政府融资平台融资性质
      ,NULL                                         AS PRO_IMPT                    --45 减值准备
      ,NULL                                         AS BIZ_CL                      --46 业务种类
      ,NULL                                         AS APP_PSN_CTRY_CD             --47 申请人国家代码
      ,NULL                                         AS FWD_FLG                     --48 远期标志
      ,CASE WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>60 THEN '5YA'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>36 THEN '5Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>24 THEN '3Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>12 THEN '2Y'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>6 THEN '12M'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>3 THEN '6M'
            WHEN MONTHS_BETWEEN(A.EXP_DT,A.BUS_DT)>=0 THEN '3M'
       END                                          AS ORIG_TERM_CODE              --49 原始期限类型
      ,A.FAC_VAL_AMT                                AS BAL                         --50 余额
      ,F.CUST_ID                                    AS CUST_ID                     --51 客户编号
      ,A.FAC_VAL_AMT                                AS TRAN_AMT                    --52 业务发生金额
      ,NULL                                         AS VALID_FLG_CD                --53 合同有效标志代码CD2586 add by 20221121 xucx
      ,A.STD_PROD_ID                                AS STD_PROD_ID                 --54 标准产品编号
      ,A.CTR_NT_ID                                  AS CTR_NT_ID                   --55 成交单编号
      ,TO_CHAR(A.BUS_DT,'YYYYMMDD')                 AS BUS_DT                      --56 业务日期
      ,A.DISCNT_INT_RAT                             AS DISCNT_INT_RAT              --57 贴现利率
      ,'611'                                        AS ACCT_TYP                    --58 账户类型
      ,DECODE(CC.GREEN_CRDT_CLS_CD,'-','',CC.GREEN_CRDT_CLS_CD)
                                                    AS GRN_CRDT_USEAGE_CL          --59 绿色授信用途分类
  FROM O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
  LEFT JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息表
    ON A.BILL_ID = B.BILL_ID --mod by hulj 20221201
   AND A.ETL_DT = B.ETL_DT
  LEFT JOIN O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款业务合同补充信息
    ON B.CONT_ID = D.CONT_ID
   AND D.ETL_DT = B.ETL_DT
--========= MOD BY LIUYU 20220926 根据严希婧要求，直贴后卖断的按直贴票据的申请人取客户号
  LEFT JOIN (SELECT T.CUST_ID, T.CUST_NAME, BILL_NUM
               FROM O_ICL_CMM_BILL_DISCNT_INFO T -- 票据贴现申请表
              WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                AND T.CUST_ID IS NOT NULL
                   --AND ENTRY_STATUS_CD = '3' -- 筛选记账成功的票据
                AND ENTRY_STATUS_CD = '03' -- 筛选记账成功的票据
              GROUP BY T.CUST_ID, T.CUST_NAME, BILL_NUM) F -- 票据贴现信息
    ON F.BILL_NUM = A.BILL_NUM
 INNER JOIN O_ICL_CMM_BILL_CENTER_INFO C --票据中心信息
    ON A.BILL_ID = C.BILL_ID
   AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN (SELECT A.BILL_NUM
               FROM O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
              WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                AND A.BUS_TYPE_CD = 'BT01'
                AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
                AND A.TRAN_DIR_CD = '01' --转贴现买入  --MODIFY BY MW 20221207
                AND A.CURRT_BAL > 0) E
    ON A.BILL_NUM = E.BILL_NUM
  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO CC --对公客户基本信息
    ON CC.CUST_ID = B.CUST_ID
   AND CC.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  LEFT JOIN CODE_MAP TTA --绿色贷款用途转码
    ON TTA.SRC_VALUE_CODE = CC.GREEN_CRDT_CLS_CD
   AND TTA.SRC_CLASS_CODE = 'CD2390'
   AND TTA.TAR_CLASS_CODE = 'D0142'
   AND TTA.MOD_FLG = 'MDM'
 WHERE A.TRAN_DIR_CD = '02' -- 00-未知 01-买入 02-卖出  --MODIFY BY MW 20221207
   AND A.BUS_TYPE_CD = 'BT01' -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
   AND A.ENTRY_STATUS_CD = '03' -- 筛选记账成功的票据
   AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   AND C.BILL_STATUS_CD IN ('21', 'S04') --已卖断销账
   AND C.EXP_DT > TO_DATE(V_P_DATE, 'YYYYMMDD') --未到期
   AND ((A.STD_PROD_ID = '204010100001' AND A.HXB_ACPT_FLG = '0') OR
       A.STD_PROD_ID = '204010100002')
      /*剔除自开自贴、票据贴现过（他行未到期）、剔除在库的转贴现未到期*/
   AND (A.SYS_IN_FLG = '1' --系统内
       OR (A.SYS_IN_FLG = '0' AND E.BILL_NUM IS NULL)) --系统外转出
   AND A.BILL_SRC_CD <> 'SR005' --剔除转贴现  --modify by tangan at 20221109
;

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
    SELECT DATA_DT, BIZ_ID,CONT_ID,COUNT(1)
      FROM M_LOAN_LGLC_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, BIZ_ID,CONT_ID
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

  END ETL_INIT_M_LOAN_LGLC_INFO;
/

