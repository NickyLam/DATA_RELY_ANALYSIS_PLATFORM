CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_LOAN_DTL_BFD(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_LOAN_DTL_BFD
  *  功能描述：监管集市所有影响个人信贷账户、余额变动的交易信息。
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO         --内部机构信息
  *            ICL.CMM_UNITE_WL_DUBIL_INFO     --联合网贷借据信息
  *            ICL.CMM_UNITE_WL_WRT_OFF_INFO   --联合网贷核销信息
  *            ICL.CMM_INDV_CUST_BASIC_INFO    --个人客户基本信息
  *            ICL.CMM_SUBJ_INFO               --科目信息
  *            ICL.CMM_TELLER_INFO             --柜员信息
  *            ICL.CMM_UNITE_WL_DISTR_DTL      --联合网贷放款明细
  *            ICL.CMM_RETL_LOAN_ACCT_INFO     --零售贷款账户信息
  *            ICL.CMM_RETL_LOAN_DUBIL_INFO    --零售贷款借据信息
  *            ICL.CMM_DEP_CUST_ACCT_INFO      --存款主账户信息
  *            IML.AGT_RETL_LOAN_ASSET_TRAN_H  --零售贷款账户资产转让历史
  *  目标表：  M_TRA_LOAN_DTL  --信贷账户交易流水
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230804  XUXIAOBIN  联合网贷核销当天还款判断为正常还款 零售冲账标识逻辑调整
  *            2     20230925  LYH        调整网商贷债权直转发放收回类型为转入
  *            3     20250421  LYH        解决字节小微贷数据重复问题
  *            4     20250521  YJY        修改联合网贷部分的借据号，取核心借据编号
  *            5     20250702  YJY        修改联合网贷部分的借据号，优先取核心借据编号，取不到再取借据号
  *            6     20250725  YJY        回退联合网贷部分的借据号
  *            7     20250929  LYH        调整联合网贷核销口径
  *            8     20260126  LYH        调整IML.V_EVT_REPAY_FLOW还款流水取数口径
  ************************************************************************/
  AS
  --定义变量 --
  V_DATE      DATE;                       --数据日期(判断输入参数日期格式是否准确)
  V_STEP      INTEGER := 0;               --处理步骤
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_YESTADAY  VARCHAR2(8);                --上日
  V_PART_NAME VARCHAR2(100);
  --V_MONTH_START_DATE DATE;                --系统时间对应月初日期
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_LOAN_DTL_BFD'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_LOAN_DTL_BFD'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写 
BEGIN
  /*判断传入日期参数是否正确*/
  IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(I_P_DATE,'YYYYMMDD');
    --V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD')-1,'MM');
  END IF;

  V_P_DATE := I_P_DATE; --获取跑批日期
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD'); --上日
  V_PART_NAME := 'PARTITION_'||V_YESTADAY;

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_YESTADAY,'M_TRA_LOAN_DTL_BFD','1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_TRA_LOAN_DTL_BFD'||' TRUNCATE PARTITION '||'PARTITION_'||V_YESTADAY);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款收回';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,REPAY_PERDS    --还款期数
    ,DTL_SEQ_NUM    --交易序号
    ,AMT_TYPE       --金额类型
    ,REPAY_TYPE     --还款类型代码
    ,STD_PROD_ID    --标准产品编号
    ,DISCNT_INT_RAT --贴现利率
    ,CTR_NT_ID      --成交单编号
    )
  SELECT V_YESTADAY                               AS DATA_DT        --数据日期
        ,T1.LP_ID                                 AS LGL_REP_ID     --法人编号
        ,T1.TRAN_ORG_ID                           AS TRA_ORG_ID     --交易机构编号
        ,SUBSTR(TO_CHAR(T1.LOAN_REPAY_DT,'YYYYMMDD')||T2.ADVISE_ODD_NO||T2.CURR_PD||T1.EVT_ID,1,60)
                                                  AS TRA_SEQ_NO     --交易流水号--29230804 xuxiaobin modify
        ,T2.ACCT_ID                               AS ACC_ID         --账户编号
        ,T1.CUST_ID                               AS CUST_ID        --客户编号
        ,T1.LOAN_NUM                              AS CONT_ID        --合同编号
        ,'1'                                      AS CORP_IND_FLG   --对公对私标志
        ,T3.ACCT_INSTIT_ID                        AS ORG_ID         --机构编号
        ,T3.SUBJ_ID                               AS SUBJ_ID        --科目编号
        ,T3.DUBIL_NUM                             AS RCPT_ID        --借据编号
        ,T1.CUST_ID                               AS CUST_NM        --客户名称
        ,CASE WHEN T2.AMT_TYPE_CD IN ('PRI') THEN '12' --贷款还本
              WHEN T2.AMT_TYPE_CD IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                     AS TRA_TYP        --交易类型 D0121
        ,'C'                                      AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,T2.CALLBK_PRIC                           AS TRA_AMT        --交易金额
        ,T3.PRIC_BAL                              AS ACC_BAL        --账户余额
        /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 BEGIN*/
        ,CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              ELSE T4.ENTER_ACCT_ID
          END                                     AS OPP_ACC        --对方账号
        ,CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NAME
          END                                     AS OPP_ACC_NM     --对方户名
        ,CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
          END                                     AS OPP_PBC_NO     --对方行号
        ,CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
          END                                     AS OPP_BANK_NM    --对方行名
        /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 END*/
        ,T9.CHN_ID                                AS TRA_CHAN       --交易渠道
        ,T1.CURR_CD                               AS CUR            --币种
        ,'贷款回收-'||T10.CD_DESCB                AS ABSTR          --摘要
        ,CASE WHEN T1.REVS_FLG = '1' THEN '2'
              ELSE '1'
          END                                     AS FLUSH_PATCH_FLG--冲补抹标志 D0128 1-正常 2-冲账 3-补账20230804 XUXIAOBIN MODIFY
        ,T1.TRAN_TELLER_ID                        AS TRA_TLR_NO     --交易柜员号
        ,T1.ACCT_APV_TELLER_ID                    AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                      AS CASH_TRF_FLG   --现转标志 2-转账
        ,NULL                                     AS AGT_NM         --代办人姓名
        ,NULL                                     AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                     AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                     AS BATCH_TRF_FLG  --批量转让标志
        ,CASE WHEN T1.LOAN_REPAY_TYPE_CD = 'NS' OR T1.LOAN_REPAY_TYPE_CD = 'PO'
              THEN T1.CALLBK_PRIC
          END                                     AS NORM_RETRV_AMT --正常回收金额
        ,CASE WHEN T1.LOAN_REPAY_TYPE_CD = 'ER'
              THEN T1.CALLBK_PRIC
          END                                     AS ADV_REPY_AMT   --提前还款金额
        ,CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10'--核销后收回ADD20230203XUXIAOBIN
              WHEN T1.LOAN_REPAY_TYPE_CD = 'NS' OR T1.LOAN_REPAY_TYPE_CD = 'PO' THEN 'B01'
              WHEN T1.LOAN_REPAY_TYPE_CD = 'ER' THEN 'B02'
              ELSE 'B01' --20230804 兜底
          END                                     AS DSTR_RETRV_TYP --发放收回类型
        ,CASE WHEN T2.AMT_TYPE_CD IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                                     AS PRIN_TRA_FLG   --本金交易标志
        ,T1.TRAN_TM                               AS TRA_TM         --交易时间
        ,TO_CHAR(T1.LOAN_REPAY_DT,'YYYYMMDD')     AS TRA_DT         --交易日期
        ,NULL                                     AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                     AS DEPT_LINE      --部门条线
        ,'零售贷款收回'                           AS DATA_SRC       --数据来源
        ,T2.CURR_PD                               AS REPAY_PERDS    --还款期数
        ,T1.EVT_ID                                AS DTL_SEQ_NUM    --交易序号
        ,T2.AMT_TYPE_CD                           AS AMT_TYPE       --金额类型
        ,T1.LOAN_REPAY_TYPE_CD                    AS REPAY_TYPE     --还款类型代码
        ,T3.STD_PROD_ID                           AS STD_PROD_ID    --标准产品编号
        ,NULL                                     AS DISCNT_INT_RAT --贴现利率
        ,NULL                                     AS CTR_NT_ID      --成交单编号
    FROM IML.v_EVT_REPAY_FLOW T1 --还款流水
   INNER JOIN IML.V_EVT_REPAY_DTL T2 --还款明细
      ON T2.EVT_ID = T1.EVT_ID
   INNER JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO T3 --零售贷款账户信息
      ON T3.ACCT_ID = T2.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      ON TB.CONT_ID = T3.CONT_ID
     AND TB.START_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN (SELECT ACCT_ID,MAX(CHN_ID) CHN_ID
                 FROM IML.V_EVT_LOAN_FIN_TRAN_FLOW A
                WHERE A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
                GROUP BY ACCT_ID) T9 --贷款金融交易流水
      ON T9.ACCT_ID = T2.ACCT_ID
    LEFT JOIN IML.V_REF_PUB_CD T10 --公共代码表 取还款备注
      ON T10.CD_VAL = T2.AMT_TYPE_CD
     AND T10.CD_ID = 'CD2558'
    LEFT JOIN ICL.V_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息表
      ON D.DUBIL_ID = T3.DUBIL_NUM
     AND D.FIR_WRT_OFF_DT <= T1.LOAN_REPAY_DT
     AND D.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   --WHERE T1.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');
   WHERE T1.BUS_TRAN_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');--ADD BY LYH 20260126

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款发放';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC        --数据来源
    ,REPAY_PERDS     --还款期数
    ,DTL_SEQ_NUM     --交易序号
    ,AMT_TYPE        --金额类型
    ,STD_PROD_ID     --标准产品编号
    ,DISCNT_INT_RAT  --贴现利率
    ,CTR_NT_ID       --成交单编号
    )
  SELECT V_YESTADAY                               AS DATA_DT        --数据日期
        ,T1.LP_ID                                 AS LGL_REP_ID     --法人编号
        ,T1.TRAN_ORG_ID                           AS TRA_ORG_ID     --交易机构编号
        ,SUBSTR(TO_CHAR(T1.TRAN_DT,'YYYYMMDD')||T1.TRAN_FLOW_NUM||T1.MAIN_TRAN_SEQ_NUM,1,60)
                                                  AS TRA_SEQ_NO     --交易流水号
        ,T1.ACCT_ID                               AS ACC_ID         --账户编号
        ,T1.CUST_ID                               AS CUST_ID        --客户编号
        ,T2.CONT_ID                               AS CONT_ID        --合同编号
        ,'1'                                      AS CORP_IND_FLG   --对公对私标志
        ,T2.ACCT_INSTIT_ID                        AS ORG_ID         --机构编号
        ,T2.SUBJ_ID                               AS SUBJ_ID        --科目编号
        ,T2.DUBIL_NUM                             AS RCPT_ID        --借据编号
        ,T1.CUST_NAME                             AS CUST_NM        --客户名称
        ,'11'                                     AS TRA_TYP        --交易类型 D0121 --11-贷款放款
        ,T1.DEBIT_CRDT_FLG                        AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                              AS TRA_AMT        --交易金额
        ,T1.ACTL_BAL                              AS ACC_BAL        --账户余额
        /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 BEGIN*/
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200005','202020200006') 
               AND TRIM(T4.ENTER_ACCT_ID) IS NOT NULL --网商小贷 取合同栏位的账号
              THEN T4.ENTER_ACCT_ID
              WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') 
               AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              ELSE T1.CNTPTY_ACCT_ID
          END                                     AS OPP_ACC        --对方账号
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') 
               AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NAME
             /*ELSE NVL(NVL(T1.CNTPTY_ACCT_NAME,T7.CUST_ACCT_NAME),T11.CUST_ACCT_NAME)*/
          END                                     AS OPP_ACC_NM     --对方户名
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') 
               AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
             /*ELSE NVL(NVL(T1.CNTPTY_BANK_NO,T7.PBC_PAY_BANK_NO),T11.PBC_PAY_BANK_NO)*/
          END                                     AS OPP_PBC_NO     --对方行号
        ,CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') 
               AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
             /*ELSE NVL(NVL(T1.CNTPTY_BANK_NAME,T7.ORG_NAME),T11.ORG_NAME)*/
          END                                     AS OPP_BANK_NM    --对方行名
         /*MODIFY BY TANGAN AT 20230111 调整助贷产品对手方信息逻辑 END*/
        ,T1.CHN_ID                                AS TRA_CHAN       --交易渠道 Z0014
        ,T1.CURR_CD                               AS CUR            --币种
        ,T1.TRAN_MEMO_DESCB                       AS ABSTR          --摘要
        ,'1'                                      AS FLUSH_PATCH_FLG--冲补抹标志
        ,T1.TRAN_TELLER_ID                        AS TRA_TLR_NO     --交易柜员号
        ,T1.CHECK_TELLER_ID                       AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                      AS CASH_TRF_FLG   --现转标志
        ,NULL                                     AS AGT_NM         --代办人姓名
        ,NULL                                     AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                     AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                     AS BATCH_TRF_FLG  --批量转让标志
        ,NULL                                     AS NORM_RETRV_AMT --正常回收金额
        ,NULL                                     AS ADV_REPY_AMT   --提前还款金额
        ,CASE WHEN T2.STD_PROD_ID IN ('203010500001') THEN 'A03' --透支 --法人透支
              ELSE 'A01' --贷款发放
          END                                     AS DSTR_RETRV_TYP --发放收回类型
        ,'Y'                                      AS PRIN_TRA_FLG   --本金交易标志
        ,T1.TRAN_TM                               AS TRA_TM         --交易时间
        ,TO_CHAR(T1.TRAN_DT,'YYYYMMDD')           AS TRA_DT         --交易日期
        ,NULL                                     AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                     AS DEPT_LINE      --部门条线
        ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '零售贷款放款'
              ELSE '对公贷款放款'
          END                                     AS DATA_SRC        --数据来源
        ,NULL                                     AS REPAY_PERDS     --还款期数
        ,T1.MAIN_TRAN_SEQ_NUM                     AS DTL_SEQ_NUM     --交易序号
        ,'PRI'                                    AS AMT_TYPE        --金额类型
        ,T2.STD_PROD_ID                           AS STD_PROD_ID     --标准产品编号
        ,NULL                                     AS DISCNT_INT_RAT  --贴现利率
        ,NULL                                     AS CTR_NT_ID       --成交单编号
    FROM IML.V_EVT_LOAN_FIN_TRAN_FLOW T1 --贷款金融交易流水
   INNER JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.ACCT_ID = T1.ACCT_ID
     AND T2.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息 --MODIFY BY TANGAN AT 20230111
      ON T4.CONT_ID = T2.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      ON TB.CONT_ID = T2.CONT_ID
     AND TB.START_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_YESTADAY,'YYYYMMDD')
   WHERE T1.EVT_CATE_ID = 'DRW'
     AND T1.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款核销';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC        --数据来源
    ,REPAY_PERDS     --还款期数
    ,DTL_SEQ_NUM     --交易序号
    ,AMT_TYPE        --金额类型
    ,STD_PROD_ID     --标准产品编号
    ,DISCNT_INT_RAT  --贴现利率
    ,CTR_NT_ID       --成交单编号
    )
  WITH CMM_LOAN_WRT_OFF_INFO AS (
  SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD,
         A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,
         CASE LVL WHEN 1 THEN 'PRI' --本金
                  WHEN 2 THEN 'INT' --利息
                  WHEN 3 THEN 'FEE' --费用
          END AS AMT_TYPE,
         CASE LVL WHEN 1 THEN ACTL_WRTOFF_LOAN_PRIC
                  WHEN 2 THEN ACTL_WRTOFF_IN_BS_INT + ACTL_WRTOFF_OFF_BS_INT
                  WHEN 3 THEN WRT_OFF_RETRA_ADVC_FEE
           END AS TRAN_AMT
    FROM ICL.V_CMM_LOAN_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3 )
   WHERE A.FIR_WRT_OFF_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')--mod by hulj 20230109
     AND A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD') )
  SELECT V_YESTADAY                             AS DATA_DT        --数据日期
        ,T1.LP_ID                               AS LGL_REP_ID     --法人编号
        ,T2.ACCT_INSTIT_ID                      AS TRA_ORG_ID     --交易机构编号
        ,TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')||T1.DUBIL_ID AS TRA_SEQ_NO     --交易流水号
        ,T2.ACCT_ID                             AS ACC_ID         --账户编号
        ,T1.CUST_ID                             AS CUST_ID        --客户编号
        ,T1.CONT_ID                             AS CONT_ID        --合同编号
        ,'1'                                    AS CORP_IND_FLG   --对公对私标志
        ,T2.ACCT_INSTIT_ID                      AS ORG_ID         --机构编号
        ,T2.SUBJ_ID                             AS SUBJ_ID        --科目编号
        ,T1.DUBIL_ID                            AS RCPT_ID        --借据编号
        ,T2.CUST_ID                             AS CUST_NM        --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                   AS TRA_TYP        --交易类型 D0121
        ,'C'                                    AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                            AS TRA_AMT        --交易金额
        ,0                                      AS ACC_BAL        --账户余额
        ,NULL                                   AS OPP_ACC        --对方账号
        ,NULL                                   AS OPP_ACC_NM     --对方户名
        ,NULL                                   AS OPP_PBC_NO     --对方行号
        ,NULL                                   AS OPP_BANK_NM    --对方行名
        ,'999996'                               AS TRA_CHAN       --交易渠道 其他-核销
        ,T1.CURR_CD                             AS CUR            --币种
        ,'核销'                                 AS ABSTR          --摘要
        ,'1'                                    AS FLUSH_PATCH_FLG--冲补抹标志
        ,T1.APPL_TELLER_ID                      AS TRA_TLR_NO     --交易柜员号
        ,NULL                                   AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                    AS CASH_TRF_FLG   --现转标志
        ,NULL                                   AS AGT_NM         --代办人姓名
        ,NULL                                   AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                   AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                   AS BATCH_TRF_FLG  --批量转让标志
        ,NULL                                   AS NORM_RETRV_AMT --正常回收金额
        ,NULL                                   AS ADV_REPY_AMT   --提前还款金额
        ,'B03'                                  AS DSTR_RETRV_TYP --发放收回类型
        ,NULL                                   AS PRIN_TRA_FLG   --本金交易标志
        ,T1.FIR_WRT_OFF_DT                      AS TRA_TM         --交易时间
        ,TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')  AS TRA_DT--交易日期
        ,NULL                                   AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                   AS DEPT_LINE      --部门条线
        ,'零售贷款核销'                         AS DATA_SRC       --数据来源
        ,'1'                                    AS REPAY_PERDS    --还款期数
        ,'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                  WHEN 'INT' THEN '02'
                                  WHEN 'FEE' THEN '03'
                  END                           AS DTL_SEQ_NUM     --交易序号
        ,T1.AMT_TYPE                            AS AMT_TYPE        --金额类型
        ,T1.STD_PROD_ID                         AS STD_PROD_ID     --标准产品编号
        ,NULL                                   AS DISCNT_INT_RAT  --贴现利率
        ,NULL                                   AS CTR_NT_ID       --成交单编号
    FROM CMM_LOAN_WRT_OFF_INFO T1 --贷款核销信息
   INNER JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款转让';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,REPAY_PERDS    --还款期数
    ,DTL_SEQ_NUM    --交易序号
    ,AMT_TYPE       --金额类型
    ,STD_PROD_ID    --标准产品编号
    ,DISCNT_INT_RAT --贴现利率
    ,CTR_NT_ID      --成交单编号
    )
  WITH CMM_RETL_LOAN_ACCT_INFO AS (
  SELECT A.DUBIL_NUM,A.CURR_CD,A.LP_ID,A.ACCT_INSTIT_ID,A.ACCT_ID,A.CUST_ID,A.CONT_ID,A.SUBJ_ID,A.CURRT_BAL,
         A.STD_PROD_ID,A.ASSET_TRAN_DT,
         CASE LVL WHEN 1 THEN 'PRI' --本金
                  WHEN 2 THEN 'INT' --利息
          END AS AMT_TYPE,
         CASE LVL WHEN 1 THEN PRIC_BAL
                  WHEN 2 THEN IN_BS_INT+OFF_BS_INT
          END AS TRAN_AMT
    FROM ICL.V_CMM_RETL_LOAN_ACCT_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 2)
   WHERE A.ASSET_TRAN_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD'))
  SELECT V_YESTADAY                             AS DATA_DT        --数据日期
        ,T1.LP_ID                               AS LGL_REP_ID     --法人编号
        ,T1.ACCT_INSTIT_ID                      AS TRA_ORG_ID     --交易机构编号
        ,TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD')||T1.DUBIL_NUM   AS TRA_SEQ_NO     --交易流水号
        ,T1.ACCT_ID                             AS ACC_ID         --账户编号
        ,T1.CUST_ID                             AS CUST_ID        --客户编号
        ,T1.CONT_ID                             AS CONT_ID        --合同编号
        ,'2'                                    AS CORP_IND_FLG   --对公对私标志
        ,T1.ACCT_INSTIT_ID                      AS ORG_ID         --机构编号
        ,T1.SUBJ_ID                             AS SUBJ_ID        --科目编号
        ,T1.DUBIL_NUM                           AS RCPT_ID        --借据编号
        ,T1.CUST_ID                             AS CUST_NM        --客户名称
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                   AS TRA_TYP        --交易类型 D0121
        ,'C'                                    AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                            AS TRA_AMT        --交易金额
        ,T1.CURRT_BAL                           AS ACC_BAL        --账户余额
        ,T2.CNTPTY_ACCT_NUM                     AS OPP_ACC        --对方账号
        ,T2.CNTPTY_NAME                         AS OPP_ACC_NM     --对方户名
        ,T2.CNTPTY_OPEN_BANK_NAME               AS OPP_PBC_NO     --对方行号
        ,T3.CUST_NAME                           AS OPP_BANK_NM    --对方行名
        ,'999013'                               AS TRA_CHAN       --交易渠道 Z0014
        ,T1.CURR_CD                             AS CUR            --币种
        ,'零售贷款-转让'                        AS ABSTR          --摘要
        ,'1'                                    AS FLUSH_PATCH_FLG --冲补抹标志
        ,T4.CUST_MGR_ID                         AS TRA_TLR_NO     --交易柜员号
        ,T4.CUST_MGR_ID                         AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                    AS CASH_TRF_FLG   --现转标志
        ,NULL                                   AS AGT_NM         --代办人姓名
        ,NULL                                   AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                   AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                   AS BATCH_TRF_FLG  --批量转让标志
        ,NULL                                   AS NORM_RETRV_AMT --正常回收金额
        ,NULL                                   AS ADV_REPY_AMT   --提前还款金额
        ,'B06'                                  AS DSTR_RETRV_TYP --发放收回类型
        ,CASE WHEN T1.AMT_TYPE IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                                   AS PRIN_TRA_FLG   --本金交易标志
        ,T1.ASSET_TRAN_DT                       AS TRA_TM         --交易时间
        ,TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD')   AS TRA_DT         --交易日期
        ,NULL                                   AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                   AS DEPT_LINE      --部门条线
        ,'零售贷款转让'                         AS DATA_SRC       --数据来源
        ,'1'                                    AS REPAY_PERDS    --还款期数
        ,'ZR'||CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
                    WHEN T1.AMT_TYPE = 'INT' THEN '2'
                END                             AS DTL_SEQ_NUM    --交易序号
        ,T1.AMT_TYPE                            AS AMT_TYPE       --金额类型
        ,T1.STD_PROD_ID                         AS STD_PROD_ID    --标准产品编号
        ,NULL                                   AS DISCNT_INT_RAT --贴现利率
        ,NULL                                   AS CTR_NT_ID      --成交单编号
    FROM CMM_RETL_LOAN_ACCT_INFO T1 --零售贷款账户信息
   INNER JOIN ICL.V_CMM_ASSET_SECU_TRAN_CONT_INFO T2 --资产证券化转让合同信息
      ON T2.CONT_ID = T1.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO T3 --个人客户信息表
      ON TRIM(T3.PBC_PAY_BANK_NO) = TRIM(T2.CNTPTY_OPEN_BANK_NAME)
     AND T3.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_RETL_LOAN_DUBIL_INFO T4 --零售贷款借据信息
      ON T4.DUBIL_ID  = T1.DUBIL_NUM
     AND T4.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0
     AND T1.ASSET_TRAN_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--放款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD NOLOGGING
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,CRN_PRD_ACCRD_INT  --当期应计利息
    ,CRN_PRD_REPY_PNY_INT  --当期还款罚息
    ,CRN_PRD_REPY_CP_INT  --当期还款复息
    ,REPAY_PERDS    --还款期数
    ,DTL_SEQ_NUM    --交易序号
    ,STD_PROD_ID    --标准产品编号
    ,DISCNT_INT_RAT --贴现利率
    ,CTR_NT_ID      --成交单编号
    ,AMT_TYPE
    )
  SELECT DISTINCT
         V_YESTADAY                                               AS DATA_DT        --数据日期
        ,A.LP_ID                                                  AS LGL_REP_ID     --法人编号
        ,A.OPEN_ACCT_ORG_ID                                       AS TRA_ORG_ID     --交易机构编号
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')||A.DUBIL_ID               AS TRA_SEQ_NO     --交易流水号
        ,A.DUBIL_ID                                               AS ACC_ID         --账户编号
        ,A.CUST_ID                                                AS CUST_ID        --客户编号
        ,A.DUBIL_ID                                               AS CONT_ID        --合同编号
        ,'1'                                                      AS CORP_IND_FLG   --对公对私标志
        ,A.ACCT_INSTIT_ID                                         AS ORG_ID         --机构编号
        ,A.SUBJ_ID                                                AS SUBJ_ID        --科目编号
        /*A.DUBIL_ID                                               RCPT_ID,        --借据编号*/
        --,NVL(TRIM(A.CORE_DUBIL_ID),A.DUBIL_ID)                    AS RCPT_ID        --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号  --MOD BY YJY 20250702 优先取核心借据号，再取借据号
        ,A.DUBIL_ID                                               AS RCPT_ID        --借据编号  MOD BY YJY 20250725 回退
        ,NULL                                                     AS CUST_NM        --客户名称
        ,'11'                                                     AS TRA_TYP        --交易类型 D0121
        ,'D'                                                      AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,NVL(B.DISTR_AMT,A.DISTR_AMT)                             AS TRA_AMT        --交易金额
        ,A.CURRT_BAL                                              AS ACC_BAL        --账户余额
        ,NVL(TRIM(A.ENTER_ACCT_ACCT_NUM),A.REPAY_NUM)             AS OPP_ACC        --对方账号
        ,C.CUST_NAME                                              AS OPP_ACC_NM     --对方户名
        ,NULL                                                     AS OPP_PBC_NO     --对方行号
        ,CASE WHEN A.PROD_ID IN ('202010100004') THEN '京东'
              WHEN A.PROD_ID IN ('202010100006') AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                                     AS OPP_BANK_NM    --对方行名
        ,CASE WHEN A.PROD_ID IN ('202010100006') THEN '403011' --微信
              WHEN A.PROD_ID IN ('202010100004') THEN '403002' --京东
              ELSE '403001' --支付宝
          END                                                     AS TRA_CHAN       --交易渠道 Z0014
        ,A.CURR_CD                                                AS CUR            --币种
        ,'贷款发放'                                               AS ABSTR          --摘要
        ,'1'                                                      AS FLUSH_PATCH_FLG--冲补抹标志
        ,NULL                                                     AS TRA_TLR_NO     --交易柜员号
        ,NULL                                                     AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                                      AS CASH_TRF_FLG   --现转标志
        ,NULL                                                     AS AGT_NM         --代办人姓名
        ,NULL                                                     AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                                     AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                                     AS BATCH_TRF_FLG  --批量转让标志
        ,NULL                                                     AS NORM_RETRV_AMT --正常回收金额
        ,NULL                                                     AS ADV_REPY_AMT   --提前还款金额
        --UPDATE BY LYH 20230925，网商贷债权直转 
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') 
               AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' 
               AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN 'A02' --贷款转入 
              ELSE 'A01'
          END                                                     AS DSTR_RETRV_TYP --发放收回类型
        ,NULL                                                     AS PRIN_TRA_FLG   --本金交易标志
        ,A.DISTR_DT                                               AS TRA_TM         --交易时间
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                           AS TRA_DT         --交易日期
        ,NULL                                                     AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                                     AS DEPT_LINE      --部门条线
        ,'联合网贷放款'                                           AS DATA_SRC        --数据来源
        ,NULL                                                     AS CRN_PRD_ACCRD_INT  --当期应计利息
        ,NULL                                                     AS CRN_PRD_REPY_PNY_INT  --当期还款罚息
        ,NULL                                                     AS CRN_PRD_REPY_CP_INT  --当期还款复息
        ,'1'                                                      AS REPAY_PERDS    --还款期数
        ,'001'                                                    AS DTL_SEQ_NUM    --交易序号
        ,A.STD_PROD_ID                                            AS STD_PROD_ID    --标准产品编号
        ,NULL                                                     AS DISCNT_INT_RAT --贴现利率
        ,NULL                                                     AS CTR_NT_ID      --成交单编号
        ,'PRI'                                                    AS AMT_TYPE
    FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO A
    LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = V_DATE
    LEFT JOIN ICL.V_CMM_UNITE_WL_DISTR_DTL B --联合网贷放款明细
      ON B.DUBIL_ID = A.DUBIL_ID
     AND TO_CHAR(B.DISTR_DT,'YYYYMMDD') = TO_CHAR(A.DISTR_DT,'YYYYMMDD')
     AND B.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')--A.ETL_DT
   WHERE NVL(B.DISTR_AMT,A.DISTR_AMT) > 0
     --AND A.DISTR_AMT > 0
     --AND A.DISTR_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND A.DISTR_DT <= TO_DATE(TO_CHAR(V_DATE,'YYYYMMDD')||'235959','YYYYMMDD HH24:MI:SS') - 1
     AND A.DISTR_DT >= TO_DATE(TO_CHAR(V_DATE,'YYYYMMDD')||'000000','YYYYMMDD HH24:MI:SS') - 1
     AND A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--收回';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ORG_ID     --交易机构编号
    ,TRA_SEQ_NO     --交易流水号
    ,ACC_ID         --账户编号
    ,CUST_ID        --客户编号
    ,CONT_ID        --合同编号
    ,CORP_IND_FLG   --对公对私标志
    ,ORG_ID         --机构编号
    ,SUBJ_ID        --科目编号
    ,RCPT_ID        --借据编号
    ,CUST_NM        --客户名称
    ,TRA_TYP        --交易类型 D0121
    ,TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
    ,TRA_AMT        --交易金额
    ,ACC_BAL        --账户余额
    ,OPP_ACC        --对方账号
    ,OPP_ACC_NM     --对方户名
    ,OPP_PBC_NO     --对方行号
    ,OPP_BANK_NM    --对方行名
    ,TRA_CHAN       --交易渠道 Z0014
    ,CUR            --币种
    ,ABSTR          --摘要
    ,FLUSH_PATCH_FLG--冲补抹标志
    ,TRA_TLR_NO     --交易柜员号
    ,GRANT_TLR_NO   --授权柜员号
    ,CASH_TRF_FLG   --现转标志
    ,AGT_NM         --代办人姓名
    ,AGT_CRDL_TYP   --代办人证件类型
    ,AGT_CRDL_NO    --代办人证件号码
    ,BATCH_TRF_FLG  --批量转让标志
    ,NORM_RETRV_AMT --正常回收金额
    ,ADV_REPY_AMT   --提前还款金额
    ,DSTR_RETRV_TYP --发放收回类型
    ,PRIN_TRA_FLG   --本金交易标志
    ,TRA_TM         --交易时间
    ,TRA_DT         --交易日期
    ,LOAN_CHG_TYP   --贷款变动类型
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,REPAY_PERDS    --还款期数
    ,DTL_SEQ_NUM    --交易序号
    ,AMT_TYPE       --金额类型
    ,REPAY_TYPE     --还款类型代码
    ,STD_PROD_ID    --标准产品编号
    ,DISCNT_INT_RAT --贴现利率
    ,CTR_NT_ID      --成交单编号
    )
  WITH CMM_UNITE_WL_REPAY_DTL AS (
  SELECT A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID,A.REPAY_TYPE_CD,A.CURR_NOMAL_PRIC_BAL,A.CURR_CD,
         CASE LVL WHEN 1 THEN 'PRI' --本金
                  WHEN 2 THEN 'INT' --利息
                  WHEN 3 THEN 'ODI' --罚息
                  WHEN 4 THEN 'FEE' --费用
          END AS AMT_TYPE,
         CASE LVL WHEN 1 THEN (CASE WHEN A.CURRT_REPAY_PRIC = 0 AND T2.ENTER_ACCT_AMT <> 0
                                    THEN T2.ENTER_ACCT_AMT ELSE A.CURRT_REPAY_PRIC
                                END)
                  WHEN 2 THEN CURR_REPAY_INT
                  WHEN 3 THEN CURRT_REPAY_PNLT
                  WHEN 4 THEN CURRT_REPAY_FEE
          END AS TRAN_AMT,
         ROW_NUMBER() OVER(PARTITION BY A.REPAY_FLOW_ID ORDER BY A.DUBIL_ID) RN
    FROM ICL.V_CMM_UNITE_WL_REPAY_DTL A --联合网贷还款明细
    LEFT JOIN IML.V_EVT_WLD_ACCT_ETY_TRAN T2 --微粒贷会计分录交易事件
      ON T2.SER_NUM = A.REPAY_FLOW_ID
     AND T2.BAL_COMPNT_GROUP_CD = 'LP'
     AND ((T2.EVT_TRAN_CODE = 'G202' AND T2.RB_W_FLG = 'B') OR
          (T2.SUBJ_ID = '111001156304001010' AND T2.DEBIT_CRDT_FLG = '0') OR
          (T2.SUBJ_ID = '111001156304001010' AND T2.EVT_TRAN_CODE = 'Z961' AND T2.DEBIT_CRDT_FLG = '1') OR
          (T2.EVT_TRAN_CODE = 'G911' AND T2.DEBIT_CRDT_FLG = '0' AND T2.SUBJ_ID IN ('111001156601002010','111001156601002020')))
     AND T2.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD'),(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 4)
   WHERE /*A.REPAY_DT <= TO_DATE(TO_CHAR(V_DATE,'YYYYMMDD')||'235959','YYYYMMDD HH24:MI:SS') - 1
     AND A.REPAY_DT >= TO_DATE(TO_CHAR(V_DATE,'YYYYMMDD')||'000000','YYYYMMDD HH24:MI:SS') - 1
     --AND A.REPAY_DT = TO_DATE(V_YESTADAY,'YYYYMMDD') --MOD BY LIP 20250728 字节小微存在账务处理时间和实际还款日期不一致的问题，且明细是增量数据，注释还款日期限制条件
     AND*/ A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   ORDER BY A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID)
  SELECT V_YESTADAY                             AS DATA_DT        --数据日期
        ,T2.LP_ID                               AS LGL_REP_ID     --法人编号
        ,T2.OPEN_ACCT_ORG_ID                    AS TRA_ORG_ID     --交易机构编号
        --,TO_CHAR(T1.REPAY_DT,'YYYYMMDD')||T1.REPAY_FLOW_ID||T1.RN AS TRA_SEQ_NO     --交易流水号
        --MOD BY LYH 20250421
        ,TO_CHAR(T1.REPAY_DT,'YYYYMMDD')||T1.REPAY_FLOW_ID||TO_CHAR(T1.RN,'FM009') AS TRA_SEQ_NO     --交易流水号
        ,T1.DUBIL_ID                            AS ACC_ID         --账户编号
        ,T2.CUST_ID                             AS CUST_ID        --客户编号
        ,T1.DUBIL_ID                            AS CONT_ID        --合同编号
        ,'1'                                    AS CORP_IND_FLG   --对公对私标志
        ,T2.ACCT_INSTIT_ID                      AS ORG_ID         --机构编号
        ,T2.SUBJ_ID                             AS SUBJ_ID        --科目编号
        /*,T1.DUBIL_ID                            AS RCPT_ID        --借据编号*/
        --,NVL(TRIM(T2.CORE_DUBIL_ID),T1.DUBIL_ID) AS RCPT_ID       --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号 --MOD BY YJY 20250702 优先取核心借据号，再取借据号
        ,T1.DUBIL_ID                            AS RCPT_ID        --借据编号  MOD BY YJY 20250725 回退
        ,T3.CUST_NAME                           AS CUST_NM        --客户名称
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '12' --贷款还本
              WHEN T1.AMT_TYPE = 'INT' THEN '13' --贷款还息
              WHEN T1.AMT_TYPE = 'ODI' THEN '18' --贷款还罚息
              WHEN T1.AMT_TYPE = 'FEE' THEN '19' --费用
          END                                   AS TRA_TYP        --交易类型 D0121
        ,'C'                                    AS TRA_DR_CR_FLG  --交易借贷标志 Z0017 D-借，C-贷
        ,T1.TRAN_AMT                            AS TRA_AMT        --交易金额
        --,T1.CURR_NOMAL_PRIC_BAL                 AS ACC_BAL        --账户余额
        ,T2.CURRT_BAL                           AS ACC_BAL        --账户余额
        /*MODIFY LHQ 20230112 零售和联合网贷口径的账户余额目前上游是没有实时借据的账户余额，所以取不到实时的账户余额 ,经咨询张家伟后，沿用生产口径*/
        ,NVL(TRIM(T2.REPAY_NUM),T2.ENTER_ACCT_ACCT_NUM) AS OPP_ACC        --对方账号
        ,T3.CUST_NAME                           AS OPP_ACC_NM     --对方户名
        ,NULL                                   AS OPP_PBC_NO     --对方行号
        /*T4.PROD_NAME                            AS PROD_NAME*/
        ,CASE WHEN T2.PROD_ID IN ('202010100004') THEN '京东'
              WHEN T2.PROD_ID IN ('202010100006') AND TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
              WHEN TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                   AS OPP_BANK_NM    --对方行名
        ,CASE WHEN T2.PROD_ID IN ('202010100006') THEN '403011' --微信
              WHEN T2.PROD_ID IN ('202010100004') THEN '403002' --京东
              ELSE '403001' --支付宝
          END                                   AS TRA_CHAN       --交易渠道 Z0014
        ,T1.CURR_CD                             AS CUR            --币种
        ,'贷款回收'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '本金'
                                      WHEN 'INT' THEN '利息'
                                      WHEN 'ODI' THEN '罚息'
                                      WHEN 'FEE' THEN '费用'
                      END                       AS ABSTR          --摘要
        ,'1'                                    AS FLUSH_PATCH_FLG--冲补抹标志
        ,NULL                                   AS TRA_TLR_NO     --交易柜员号
        ,NULL                                   AS GRANT_TLR_NO   --授权柜员号
        ,'2'                                    AS CASH_TRF_FLG   --现转标志
        ,NULL                                   AS AGT_NM         --代办人姓名
        ,NULL                                   AS AGT_CRDL_TYP   --代办人证件类型
        ,NULL                                   AS AGT_CRDL_NO    --代办人证件号码
        ,NULL                                   AS BATCH_TRF_FLG  --批量转让标志
        ,CASE WHEN T1.REPAY_TYPE_CD = '06' --CD2820
              THEN T1.TRAN_AMT
          END                                   AS NORM_RETRV_AMT --正常回收金额
        ,CASE WHEN T1.REPAY_TYPE_CD = '07'
              THEN T1.TRAN_AMT
          END                                   AS ADV_REPY_AMT   --提前还款金额
        ,CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10'--核销后收回ADD20230203XUXIAOBIN
              WHEN T1.REPAY_TYPE_CD = '07' THEN 'B02' --提前还款
              ELSE 'B01'
          END                                   AS DSTR_RETRV_TYP --发放收回类型
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN 'Y'
              ELSE 'N'
          END                                    AS PRIN_TRA_FLG   --本金交易标志
        ,T1.REPAY_DT                             AS TRA_TM         --交易时间
        ,TO_CHAR(T1.REPAY_DT,'YYYYMMDD')         AS TRA_DT         --交易日期
        ,NULL                                    AS LOAN_CHG_TYP   --贷款变动类型
        ,NULL                                    AS DEPT_LINE      --部门条线
        ,'联合网贷收回'                          AS DATA_SRC       --数据来源
        ,'1'                                     AS REPAY_PERDS    --还款期数
        ,CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
              WHEN T1.AMT_TYPE = 'INT' THEN '2'
              WHEN T1.AMT_TYPE = 'ODI' THEN '3'
              WHEN T1.AMT_TYPE = 'FEE' THEN '4'
              ELSE '9'
          END                                    AS DTL_SEQ_NUM     --交易序号
        ,T1.AMT_TYPE                             AS AMT_TYPE        --金额类型
        ,T1.REPAY_TYPE_CD                        AS REPAY_TYPE      --还款类型代码
        ,T2.STD_PROD_ID                          AS STD_PROD_ID     --标准产品编号
        ,NULL                                    AS DISCNT_INT_RAT  --贴现利率
        ,NULL                                    AS CTR_NT_ID       --成交单编号
    FROM CMM_UNITE_WL_REPAY_DTL T1 --联合网贷还款明细
    LEFT JOIN ICL.V_CMM_UNITE_WL_DUBIL_INFO T2 --联合网贷借据信息
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_UNITE_WL_WRT_OFF_INFO D --联合网贷核销信息
      ON D.DUBIL_ID = T1.DUBIL_ID
     AND D.FIR_WRT_OFF_DT < T1.REPAY_DT--20230804 XUXIAOBIN MODIFY
     AND D.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO T3 --个人客户基础信息
      ON T3.CUST_ID = T2.CUST_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T4 --标准产品信息表
      ON T4.PROD_ID = T2.STD_PROD_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷核销';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_LOAN_DTL_BFD(
    DATA_DT,        --数据日期
    LGL_REP_ID,     --法人编号
    TRA_ORG_ID,     --交易机构编号
    TRA_SEQ_NO,     --交易流水号
    ACC_ID,         --账户编号
    CUST_ID,        --客户编号
    CONT_ID,        --合同编号
    CORP_IND_FLG,   --对公对私标志
    ORG_ID,         --机构编号
    SUBJ_ID,        --科目编号
    RCPT_ID,        --借据编号
    CUST_NM,        --客户名称
    TRA_TYP,        --交易类型 D0121
    TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
    TRA_AMT,        --交易金额
    ACC_BAL,        --账户余额
    OPP_ACC,        --对方账号
    OPP_ACC_NM,     --对方户名
    OPP_PBC_NO,     --对方行号
    OPP_BANK_NM,    --对方行名
    TRA_CHAN,       --交易渠道 Z0014
    CUR,            --币种
    ABSTR,          --摘要
    FLUSH_PATCH_FLG,--冲补抹标志
    TRA_TLR_NO,     --交易柜员号
    GRANT_TLR_NO,   --授权柜员号
    CASH_TRF_FLG,   --现转标志
    AGT_NM,         --代办人姓名
    AGT_CRDL_TYP,   --代办人证件类型
    AGT_CRDL_NO,    --代办人证件号码
    BATCH_TRF_FLG,  --批量转让标志
    NORM_RETRV_AMT, --正常回收金额
    ADV_REPY_AMT,   --提前还款金额
    DSTR_RETRV_TYP, --发放收回类型
    PRIN_TRA_FLG,   --本金交易标志
    TRA_TM,         --交易时间
    TRA_DT,         --交易日期
    LOAN_CHG_TYP,   --贷款变动类型
    DEPT_LINE,      --部门条线
    DATA_SRC,        --数据来源
    REPAY_PERDS,     --还款期数
    DTL_SEQ_NUM,     --交易序号
    AMT_TYPE,        --金额类型
    STD_PROD_ID,     --标准产品编号
    DISCNT_INT_RAT, --贴现利率
    CTR_NT_ID       --成交单编号
    )
  WITH CMM_UNITE_WL_WRT_OFF_INFO AS (
  SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD,
         A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,
         CASE LVL WHEN 1 THEN 'PRI' --本金
                  WHEN 2 THEN 'INT' --利息
                  WHEN 3 THEN 'FEE' --费用
          END AS AMT_TYPE,
         CASE LVL WHEN 1 THEN ACTL_WRTOFF_LOAN_PRIC
                  WHEN 2 THEN ACTL_WRTOFF_IN_BS_INT+ACTL_WRTOFF_OFF_BS_INT
                  WHEN 3 THEN WRT_OFF_RETRA_ADVC_FEE
          END AS TRAN_AMT
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3)
  -- WHERE A.FIR_WRT_OFF_DT = TO_DATE(V_YESTADAY,'YYYYMMDD') - 1 --MOD BY HULJ 20230109
   WHERE A.FIR_WRT_OFF_DT = TO_DATE(V_YESTADAY,'YYYYMMDD') --MOD BY HULJ 20230109  MOD BY LYH 20250929
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --联合网贷均为T-2
  SELECT V_YESTADAY                             AS DATA_DT,        --数据日期
         T1.LP_ID                               AS LGL_REP_ID,     --法人编号
         T2.OPEN_ACCT_ORG_ID                    AS TRA_ORG_ID,      --交易机构编号
         TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')||T1.DUBIL_ID AS TRA_SEQ_NO,     --交易流水号
         T1.DUBIL_ID                            AS ACC_ID,         --账户编号
         T1.CUST_ID                             AS CUST_ID,        --客户编号
         T1.CONT_ID                             AS CONT_ID,        --合同编号
         '1'                                    AS CORP_IND_FLG,   --对公对私标志
         T2.ACCT_INSTIT_ID                      AS ORG_ID,         --机构编号
         T2.SUBJ_ID                             AS SUBJ_ID,        --科目编号
         /*T1.DUBIL_ID                            AS RCPT_ID,        --借据编号*/
         --NVL(TRIM(T2.CORE_DUBIL_ID),T1.DUBIL_ID) AS RCPT_ID,     --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号 --MOD BY YJY 20250702 优先取核心借据号，再取借据号
         T1.DUBIL_ID                            AS RCPT_ID,        --借据编号  MOD BY YJY 20250725 回退
         T2.SUBJ_ID                             AS CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12' --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13' --贷款还息
              ELSE '99'
          END                                   AS TRA_TYP,        --交易类型 D0121
         'C'                                    AS TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                            AS TRA_AMT,        --交易金额
         0                                      AS ACC_BAL,        --账户余额
         NULL                                   AS OPP_ACC,        --对方账号
         NULL                                   AS OPP_ACC_NM,     --对方户名
         NULL                                   AS OPP_PBC_NO,     --对方行号
         NULL                                   AS OPP_BANK_NM,    --对方行名
         '999996'                               AS TRA_CHAN,       --交易渠道 其他-核销
         T1.CURR_CD                             AS CUR,            --币种
         '核销'                                 AS ABSTR,          --摘要
         '1'                                    AS FLUSH_PATCH_FLG,--冲补抹标志
         T1.APPL_TELLER_ID                      AS TRA_TLR_NO,     --交易柜员号
         NULL                                   AS GRANT_TLR_NO,   --授权柜员号
         '2'                                    AS CASH_TRF_FLG,   --现转标志
         NULL                                   AS AGT_NM,         --代办人姓名
         NULL                                   AS AGT_CRDL_TYP,   --代办人证件类型
         NULL                                   AS AGT_CRDL_NO,    --代办人证件号码
         NULL                                   AS BATCH_TRF_FLG,  --批量转让标志
         NULL                                   AS NORM_RETRV_AMT, --正常回收金额
         NULL                                   AS ADV_REPY_AMT,   --提前还款金额
         'B03'                                  AS DSTR_RETRV_TYP, --发放收回类型
         NULL                                   AS PRIN_TRA_FLG,   --本金交易标志
         T1.FIR_WRT_OFF_DT                      AS TRA_TM,         --交易时间
         TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')  AS TRA_DT,         --交易日期
         NULL                                   AS LOAN_CHG_TYP,   --贷款变动类型
         NULL                                   AS DEPT_LINE,      --部门条线
         '联合网贷核销'                         AS DATA_SRC,       --数据来源
         '1'                                    AS REPAY_PERDS,    --还款期数
         'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                  WHEN 'INT' THEN '02'
                                  WHEN 'FEE' THEN '03'
                  END                           AS DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                            AS AMT_TYPE,        --金额类型
         T1.STD_PROD_ID                         AS STD_PROD_ID,     --标准产品编号
         NULL                                   AS DISCNT_INT_RAT,  --贴现利率
         NULL                                   AS CTR_NT_ID        --成交单编号
    FROM CMM_UNITE_WL_WRT_OFF_INFO T1 --联合网贷核销信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T2 --联合网贷账户信息
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
    SELECT DATA_DT,TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS,COUNT(1)
      FROM M_TRA_LOAN_DTL_BFD T
     WHERE DATA_DT = V_YESTADAY
    GROUP BY DATA_DT,TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_YESTADAY, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  --程序跑批结束记录
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
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
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_TRA_LOAN_DTL_BFD;
/

