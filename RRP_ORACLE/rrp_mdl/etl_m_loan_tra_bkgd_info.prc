CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_TRA_BKGD_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_TRA_BKGD_INFO
  *  功能描述：交易背景信息表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_TRA_BKGD_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221105  MW        修改信用证及承兑汇票单据编号、种类、金额口径
  *             3    20230424  XUXIAOBIN 承兑汇票卡住，增加HINT执行
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;         --处理步骤
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);        --任务名称
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_TRA_BKGD_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_TRA_BKGD_INFO'; --程序名称
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-信用证--信贷部分';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT V_P_DATE                                          AS DATA_DT      --数据日期
        ,A.LP_ID                                           AS LGL_REP_ID   --法人编号
        ,A.ACCT_INSTIT_ID                                  AS ORG_ID       --机构编号
        ,CASE WHEN TB.SRC_VALUE_CODE IS NOT NULL THEN TB.TAR_VALUE_CODE
              WHEN A.STD_PROD_ID IN ('601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                   '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007') THEN 'A03' --A03保函
              WHEN A.STD_PROD_ID IN ('601020100001','601020100002','601020200001','601020200002') THEN 'A02' --A02信用证
              ELSE '99' --其他
          END                                              AS BIZ_CL       --业务种类 --T0002 T0006
        ,A.CONT_ID                                         AS BIZ_ID       --业务编号
        ,F.CURR_CD                                         AS CUR          --币种
        ,F.CONT_AMT                                        AS CONT_AMT     --合同金额
        ,C.RECEIPTID                                       AS INV_ID       --单据编号
        ,CASE WHEN C.RECEIPTTYPE = '01' THEN '商业发票'
              WHEN C.RECEIPTTYPE = '02' THEN '增值税发票'
              WHEN C.RECEIPTTYPE = '03' THEN '证实发票'
              WHEN C.RECEIPTTYPE = '04' THEN '收妥发票'
              WHEN C.RECEIPTTYPE = '05' THEN '厂商发票'
              WHEN C.RECEIPTTYPE = '06' THEN '形式发票'
              WHEN C.RECEIPTTYPE = '07' THEN '样品发票'
              WHEN C.RECEIPTTYPE = '08' THEN '领事发票'
              WHEN C.RECEIPTTYPE = '09' THEN '寄售发票'
              WHEN C.RECEIPTTYPE = '10' THEN '海关发票'
              WHEN C.RECEIPTTYPE = '11' THEN '提单'
              WHEN C.RECEIPTTYPE = '12' THEN '报关单'
              WHEN C.RECEIPTTYPE = '13' THEN '货物清单'
              WHEN C.RECEIPTTYPE = '00' THEN '其他'
              WHEN TRIM(C.RECEIPTTYPE) IS NULL THEN '增值税发票'
          END                                              AS INV_CL       --单据种类
        ,C.RECEIPTCCY                                      AS INV_CUR      --单据币种
        ,C.RECEIPTAMOUNT                                   AS INV_AMT      --单据金额
        ,'800919'                                          AS DEPT_LINE    --部门条线
        ,'信贷系统-信用证'                                 AS DATA_SRC     --数据来源
        ,TO_CHAR(C.INPUTDATE,'YYYYMMDD')                   AS INV_START_DT --单据起始日期
        ,A.CONT_ID                                         AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
   INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_RECEIPT_INFO C --商业票据信息表
      ON C.OBJECTNO = A.OUT_ACCT_FLOW_NUM
     AND TRIM(C.RECEIPTID) IS NOT NULL
     AND C.ID_MARK <> 'D'
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO F --对公贷款合同信息
      ON F.CONT_ID = A.CONT_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TB --贸易融资品种映射改成配置表出数
      ON TB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TB.SRC_CLASS_CODE = 'STD0002'
     AND TB.TAR_CLASS_CODE = 'T0006'
     AND TB.MOD_FLG = 'MDM'
   WHERE SUBSTR(A.STD_PROD_ID,1,5) IN ('20302','20303','60102','60103')
     AND A.STD_PROD_ID IN ('203020200001','203030100001','203020100001','203020100002','203020100003','203020100004','203020100005',
                           '203020100006','203020500001','203030300001','203030300002','203020800001','203030200001','203020300001',
                           '203030600001','601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                           '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007','601020100001',
                           '601020100002','601020200001','601020200002','203020700001','203020700002','203020600001','203030400001',
                           '203020400001')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-国结部分单据--借据编号关联';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT V_P_DATE                                          AS DATA_DT      --数据日期
        ,T3.LP_ID                                          AS LGL_REP_ID   --法人编号
        ,T3.ACCT_INSTIT_ID                                 AS ORG_ID       --机构编号
        ,CASE WHEN T5.SRC_VALUE_CODE IS NOT NULL THEN T5.TAR_VALUE_CODE
              WHEN T3.STD_PROD_ID IN ('601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                   '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007') THEN 'A03' --A03保函
              WHEN T3.STD_PROD_ID IN ('601020100001','601020100002','601020200001','601020200002') THEN 'A02' --A02信用证
              ELSE '99' --其他
          END                                              AS BIZ_CL       --业务种类 --T0002 T0006
        ,T3.CONT_ID                                        AS BIZ_ID       --业务编号
        ,T4.CURR_CD                                        AS CUR          --币种
        ,T4.CONT_AMT                                       AS CONT_AMT     --合同金额
        ,T1.DOCID                                          AS INV_ID       --单据编号
        ,CASE WHEN T1.DOCTYP = '01' THEN '商业发票'
              WHEN T1.DOCTYP = '02' THEN '增值税发票'
              WHEN T1.DOCTYP = '03' THEN '证实发票'
              WHEN T1.DOCTYP = '04' THEN '收妥发票'
              WHEN T1.DOCTYP = '05' THEN '厂商发票'
              WHEN T1.DOCTYP = '06' THEN '形式发票'
              WHEN T1.DOCTYP = '07' THEN '样品发票'
              WHEN T1.DOCTYP = '08' THEN '领事发票'
              WHEN T1.DOCTYP = '09' THEN '寄售发票'
              WHEN T1.DOCTYP = '10' THEN '海关发票'
              WHEN T1.DOCTYP = '11' THEN '提单'
              WHEN T1.DOCTYP = '12' THEN '报关单'
              WHEN T1.DOCTYP = '13' THEN '货物清单'
              WHEN T1.DOCTYP = '00' THEN '其他'
              WHEN TRIM(T1.DOCTYP) IS NULL THEN '增值税发票'
          END                                              AS INV_CL       --单据种类
        ,T1.DOCCUR                                         AS INV_CUR      --单据币种
        ,T1.DOCAMT                                         AS INV_AMT      --单据金额
        ,'800994'                                          AS DEPT_LINE    --部门条线
        ,'国结系统-借据编号关联'                           AS DATA_SRC     --数据来源
        ,TO_CHAR(T1.DJDATE,'YYYYMMDD')                     AS INV_START_DT --单据起始日期
        ,T3.CONT_ID                                        AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_IOL_ISBS_RPTCOD T1 --商业单据信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.DUBIL_ID = T1.FINCOD
     AND SUBSTR(T3.STD_PROD_ID,1,5) IN ('20302','20303','60102','60103')
     AND T3.STD_PROD_ID IN ('203020200001','203030100001','203020100001','203020100002','203020100003','203020100004','203020100005',
                            '203020100006','203020500001','203030300001','203030300002','203020800001','203030200001','203020300001',
                            '203030600001','601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                            '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007','601020100001',
                            '601020100002','601020200001','601020200002','203020700001','203020700002','203020600001','203030400001',
                            '203020400001')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO T2 --信用证账户信息
      ON T2.LC_ID = T1.OWNREF
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T4 --对公贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP T5 --贸易融资品种映射改成配置表出数
      ON T5.SRC_VALUE_CODE = T3.STD_PROD_ID
     AND T5.SRC_CLASS_CODE = 'STD0002'
     AND T5.TAR_CLASS_CODE = 'T0006'
     AND T5.MOD_FLG = 'MDM'
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-国结部分单据--国结业务编号关联';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT V_P_DATE                                          AS DATA_DT      --数据日期
        ,T3.LP_ID                                          AS LGL_REP_ID   --法人编号
        ,T3.ACCT_INSTIT_ID                                 AS ORG_ID       --机构编号
        ,CASE WHEN T5.SRC_VALUE_CODE IS NOT NULL THEN T5.TAR_VALUE_CODE
              WHEN T3.STD_PROD_ID IN ('601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                   '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007') THEN 'A03' --A03保函
              WHEN T3.STD_PROD_ID IN ('601020100001','601020100002','601020200001','601020200002') THEN 'A02' --A02信用证
              ELSE '99' --其他
          END                                              AS BIZ_CL       --业务种类 --T0002 T0006
        ,T3.CONT_ID                                        AS BIZ_ID       --业务编号
        ,T4.CURR_CD                                        AS CUR          --币种
        ,T4.CONT_AMT                                       AS CONT_AMT     --合同金额
        ,T1.DOCID                                          AS INV_ID       --单据编号
        ,CASE WHEN T1.DOCTYP = '01' THEN '商业发票'
              WHEN T1.DOCTYP = '02' THEN '增值税发票'
              WHEN T1.DOCTYP = '03' THEN '证实发票'
              WHEN T1.DOCTYP = '04' THEN '收妥发票'
              WHEN T1.DOCTYP = '05' THEN '厂商发票'
              WHEN T1.DOCTYP = '06' THEN '形式发票'
              WHEN T1.DOCTYP = '07' THEN '样品发票'
              WHEN T1.DOCTYP = '08' THEN '领事发票'
              WHEN T1.DOCTYP = '09' THEN '寄售发票'
              WHEN T1.DOCTYP = '10' THEN '海关发票'
              WHEN T1.DOCTYP = '11' THEN '提单'
              WHEN T1.DOCTYP = '12' THEN '报关单'
              WHEN T1.DOCTYP = '13' THEN '货物清单'
              WHEN T1.DOCTYP = '00' THEN '其他'
              WHEN TRIM(T1.DOCTYP) IS NULL THEN '增值税发票'
          END                                              AS INV_CL       --单据种类
        ,T1.DOCCUR                                         AS INV_CUR      --单据币种
        ,T1.DOCAMT                                         AS INV_AMT      --单据金额
        ,'800994'                                          AS DEPT_LINE    --部门条线
        ,'国结系统--国结业务编号'                          AS DATA_SRC     --数据来源
        ,TO_CHAR(T1.DJDATE,'YYYYMMDD')                     AS INV_START_DT --单据起始日期
        ,T3.CONT_ID                                        AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_IOL_ISBS_RPTCOD T1 --商业单据信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.INTNL_TRAD_FIN_RELA_ID_2 = T1.OWNREF
     AND SUBSTR(T3.STD_PROD_ID,1,5) IN ('20302','20303','60102','60103')
     AND T3.STD_PROD_ID IN ('203020200001','203030100001','203020100001','203020100002','203020100003','203020100004','203020100005',
                            '203020100006','203020500001','203030300001','203030300002','203020800001','203030200001','203020300001',
                            '203030600001','601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                            '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007','601020100001',
                            '601020100002','601020200001','601020200002','203020700001','203020700002','203020600001','203030400001',
                            '203020400001')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO T2 --信用证账户信息
      ON T2.LC_ID = T1.OWNREF
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T4 --对公贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP T5 --贸易融资品种映射改成配置表出数
      ON T5.SRC_VALUE_CODE = T3.STD_PROD_ID
     AND T5.SRC_CLASS_CODE = 'STD0002'
     AND T5.TAR_CLASS_CODE = 'T0006'
     AND T5.MOD_FLG = 'MDM'
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-国结部分单据--进口代付';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT V_P_DATE                                          AS DATA_DT      --数据日期
        ,T3.LP_ID                                          AS LGL_REP_ID   --法人编号
        ,T3.ACCT_INSTIT_ID                                 AS ORG_ID       --机构编号
        ,CASE WHEN T5.SRC_VALUE_CODE IS NOT NULL THEN T5.TAR_VALUE_CODE
              WHEN T3.STD_PROD_ID IN ('601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                   '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007') THEN 'A03' --A03保函
              WHEN T3.STD_PROD_ID IN ('601020100001','601020100002','601020200001','601020200002') THEN 'A02' --A02信用证
              ELSE '99' --其他
          END                                              AS BIZ_CL       --业务种类 --T0002 T0006
        ,T3.CONT_ID                                        AS BIZ_ID       --业务编号
        ,T4.CURR_CD                                        AS CUR          --币种
        ,T4.CONT_AMT                                       AS CONT_AMT     --合同金额
        ,T1.DOCID                                          AS INV_ID       --单据编号
        ,CASE WHEN T1.DOCTYP = '01' THEN '商业发票'
              WHEN T1.DOCTYP = '02' THEN '增值税发票'
              WHEN T1.DOCTYP = '03' THEN '证实发票'
              WHEN T1.DOCTYP = '04' THEN '收妥发票'
              WHEN T1.DOCTYP = '05' THEN '厂商发票'
              WHEN T1.DOCTYP = '06' THEN '形式发票'
              WHEN T1.DOCTYP = '07' THEN '样品发票'
              WHEN T1.DOCTYP = '08' THEN '领事发票'
              WHEN T1.DOCTYP = '09' THEN '寄售发票'
              WHEN T1.DOCTYP = '10' THEN '海关发票'
              WHEN T1.DOCTYP = '11' THEN '提单'
              WHEN T1.DOCTYP = '12' THEN '报关单'
              WHEN T1.DOCTYP = '13' THEN '货物清单'
              WHEN T1.DOCTYP = '00' THEN '其他'
              WHEN TRIM(T1.DOCTYP) IS NULL THEN '增值税发票'
          END                                              AS INV_CL       --单据种类
        ,T1.DOCCUR                                         AS INV_CUR      --单据币种
        ,T1.DOCAMT                                         AS INV_AMT      --单据金额
        ,'800994'                                          AS DEPT_LINE    --部门条线
        ,'国结系统--进口代付'                              AS DATA_SRC     --数据来源
        ,TO_CHAR(T1.DJDATE,'YYYYMMDD')                     AS INV_START_DT --单据起始日期
        ,T3.CONT_ID                                        AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_IOL_ISBS_RPTCOD T1 --商业单据信息表
   INNER JOIN RRP_MDL.O_IOL_ICMS_BP_EXTEND_D T6 --对公传统信贷业务出账附表
      ON T6.ARRIVALNUMBERS = T1.OWNREF
     AND T6.ID_MARK <> 'D'
     AND T6.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T6.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公贷款借据信息
      ON T3.OUT_ACCT_FLOW_NUM = T6.SERIALNO
     AND SUBSTR(T3.STD_PROD_ID,1,5) IN ('20302','20303','60102','60103')
     AND T3.STD_PROD_ID IN ('203020200001','203030100001','203020100001','203020100002','203020100003','203020100004','203020100005',
                            '203020100006','203020500001','203030300001','203030300002','203020800001','203030200001','203020300001',
                            '203030600001','601030100002','601030100003','601030100004','601030100005','601030100006','601030100007',
                            '601030200002','601030200003','601030200004','601030200005','601030200006','601030200007','601020100001',
                            '601020100002','601020200001','601020200002','203020700001','203020700002','203020600001','203030400001',
                            '203020400001')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO T2 --信用证账户信息
      ON T2.LC_ID = T1.OWNREF
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T4 --对公贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP T5 --贸易融资品种映射改成配置表出数
      ON T5.SRC_VALUE_CODE = T3.STD_PROD_ID
     AND T5.SRC_CLASS_CODE = 'STD0002'
     AND T5.TAR_CLASS_CODE = 'T0006'
     AND T5.MOD_FLG = 'MDM'
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20260311 根据一表通逻辑，不按这段逻辑取数
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT  V_P_DATE                         AS DATA_DT     --数据日期
         ,A.LP_ID                          AS LGL_REP_ID  --法人编号
         ,A.ACCT_INSTIT_ID                 AS ORG_ID      --内部机构号
         ,'A02'                            AS BIZ_CL      --业务种类 --T0002 信用证
         ,NVL(F.CONT_ID,'1')               AS BIZ_ID      --业务编号
         ,F.CURR_CD                        AS CUR         --币种
         ,F.CONT_AMT                       AS CONT_AMT    --合同金额
         ,IMG.INVNB                        AS INV_ID      --单据编号
         ,CASE WHEN IMG.INVTP = 'COMM' THEN '普通发票'
               WHEN IMG.INVTP = 'SPEC' THEN '专用发票'
               WHEN IMG.INVTP = 'ECOM' THEN '电子普通发票'
               WHEN IMG.INVTP = 'ESPE' THEN '电子专用发票'
               ELSE '其他发票'
          END                              AS INV_CL      --单据种类
         ,'CNY'                            AS INV_CUR     --单据币种
         ,IMG.UNTAXAMT                     AS INV_AMT     --单据金额
         ,'800919'                         AS DEPT_LINE   --部门条线 \*风险管理部*\
         ,'信用证'                         AS DATA_SRC    --数据来源
         ,TO_CHAR(IMG.INVDT,'YYYYMMDD')    AS INV_START_DT --单据起始日期
         ,TRIM(F.CONT_ID)                  AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_NUM = A.LC_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_DOC_INFO E --信用证单据信息
      ON E.LC_ACCT_ID = A.ACCT_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO F --对公贷款合同信息
      ON F.CONT_ID = B.CONT_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_INTSTL_TRAN_FLOW_EVT TRN
      ON TRN.TRAN_ID = E.DOC_ID
     AND TRN.AUTH_STATUS_CD = 'R'
     AND TRN.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT TA.*,ROW_NUMBER() OVER (PARTITION BY TA.OBJINR,TA.INVNB ORDER BY TA.INR DESC) RN
                 FROM RRP_MDL.O_IOL_ISBS_IMG TA
                WHERE TA.OBJTYP = 'TRN'
                  AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) IMG --发票信息表
      ON IMG.OBJINR = TRN.SRC_EVT_ID
     AND IMG.RN = 1
   WHERE F.STD_PROD_ID IN ('601020200001','601020200002','603010300002', --国际信用证
                           '601020100001','601020100002','603010100002', --国内信用证
                           '203020700001') --进口代付
     AND TRIM(IMG.INVNB) IS NOT NULL \*目前只有国内出口信息证有单据信息，故只过滤这些数据来报送*\
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-承兑汇票';
  V_STARTTIME := SYSDATE;
  /*INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    )
    WITH H AS (\*+ ORDERED USE_HASH(A,B,E)*\
  SELECT A.ETL_DT,A.LP_ID,I.ORG_ID1,E.CONT_ID,E.CURR_CD,E.CONT_AMT,G.VOUCHER_NO,
         G.VOUCHER_TYPE,G.VOUCHER_CURCD,G.VOUCHER_AMT,A.JOB_CD,E.RGST_DT
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO A --票据中心信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
      ON E.CONT_ID = B.CONT_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN (SELECT DISTINCT DRAFT_NUMBER,VOUCHER_NO,VOUCHER_AMT,VOUCHER_CURCD,VOUCHER_TYPE
                 FROM RRP_MDL.O_IOL_BDMS_BIL_COMMERCIAL_VOUCHER_INFO
                WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) G --票据发票信息表
      ON G.DRAFT_NUMBER = A.BILL_NUM
   INNER JOIN RRP_MDL.ORG_CONFIG I
      ON I.ORG_ID = A.BELONG_ORG_ID
   WHERE A.BILL_TYPE_CD IN ('AC01','AC02') --承兑汇票
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    K AS (
  SELECT DISTINCT
         TO_CHAR(H.ETL_DT,'YYYYMMDD')         AS DATA_DT    --数据日期
         ,H.LP_ID                             AS LGL_REP_ID --法人编号
         ,H.ORG_ID1                           AS ORG_ID     --内部机构号
         ,'A01'                               AS BIZ_CL     --业务种类
         ,H.CONT_ID                           AS BIZ_ID     --业务编号
         ,H.CURR_CD                           AS CUR        --币种
         ,H.CONT_AMT                          AS CONT_AMT   --合同金额
         ,REGEXP_SUBSTR(REPLACE(H.VOUCHER_NO,'、',';'),'[^;]+',1,LEVEL) 
                                              AS INV_ID     --单据编号
         ,CASE WHEN H.VOUCHER_TYPE = '00' THEN '商业发票'
               WHEN H.VOUCHER_TYPE = '01' THEN '详细发票'
               WHEN H.VOUCHER_TYPE = '02' THEN '证实发票'
               WHEN H.VOUCHER_TYPE = '03' THEN '收妥发票'
               WHEN H.VOUCHER_TYPE = '04' THEN '厂商发票'
               WHEN H.VOUCHER_TYPE = '05' THEN '形式发票'
               WHEN H.VOUCHER_TYPE = '06' THEN '样品发票'
               WHEN H.VOUCHER_TYPE = '07' THEN '领事发票'
               WHEN H.VOUCHER_TYPE = '08' THEN '寄售发票'
               WHEN H.VOUCHER_TYPE = '09' THEN '海关发票'
           END                                AS INV_CL     --单据种类
         ,H.VOUCHER_CURCD                     AS INV_CUR    --单据币种
         ,H.VOUCHER_AMT                       AS INV_AMT    --单据金额
         ,'800919'                            AS DEPT_LINE  --部门条线\*风险管理部*\
         ,'承兑汇票'                          AS DATA_SRC   --数据来源
         ,TO_CHAR(H.RGST_DT,'YYYYMMDD')       AS INV_START_DT--单据起始日期
    FROM H
 CONNECT BY H.VOUCHER_NO = PRIOR H.VOUCHER_NO
     AND LEVEL <= LENGTH(REPLACE(H.VOUCHER_NO,'、',';'))- LENGTH(REGEXP_REPLACE(REPLACE(H.VOUCHER_NO,'、',';'),';',''))+1
     AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL )
  SELECT K.DATA_DT,K.LGL_REP_ID,K.ORG_ID,K.BIZ_CL,K.BIZ_ID,K.CUR,K.CONT_AMT,K.INV_ID,K.INV_CL,K.INV_CUR,
         K.INV_AMT,K.DEPT_LINE,K.DATA_SRC,K.INV_START_DT
    FROM K
   WHERE LENGTH(K.INV_ID) <= 30
     AND K.INV_ID <> '0';*/
  --MOD BY LIP 20260306 参考一表通3.8 9.4的逻辑调整取数逻辑
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
    WITH BILL_CONT AS (
  SELECT /*+MATERIALIZE*/C.LP_ID,B.CONT_ID,A.BILL_NUM,C.DRAW_DT,C.EXP_DT,C.BILL_STATUS
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO A --票据中心信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO C --银承账户信息
      ON C.ACCT_ID = A.BILL_ID
     AND C.BILL_NUM <> ' '
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.BILL_TYPE_CD IN ('AC01','AC02') --承兑汇票
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY C.LP_ID,B.CONT_ID,A.BILL_NUM,C.DRAW_DT,C.EXP_DT,C.BILL_STATUS),
  CORP_CUST_INFO AS (
  SELECT /*+MATERIALIZE*/CUST_NAME,CUST_ID,
         ROW_NUMBER() OVER(PARTITION BY CUST_NAME ORDER BY CASE WHEN CUST_ID LIKE '9%' THEN '2' ELSE '1' END ASC,OPEN_ACCT_DT DESC) AS RN
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T2 --对公客户信息
   WHERE TRIM(CUST_ID) IS NOT NULL
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  COMMERCIAL_DOC_INFO AS (
  SELECT /*+MATERIALIZE*/
         DISTINCT CONTRACTSERIALNO,T2.CUST_ID AS CUSTOMERID,PAYERNAME,
         '02' AS BILLDOCTYPE,INVOICECODE,CURRENCY,AMOUNTTAX --录入有重复的，先去重，不能直接GROUP BY
    FROM RRP_MDL.O_IOL_ICMS_COMMERCIAL_DOC_INFO T1 --商业单据信息表
    LEFT JOIN CORP_CUST_INFO T2 --对公客户信息
      ON T2.CUST_NAME = TRIM(T1.PAYERNAME)
     AND T2.RN = 1
   WHERE TRIM(T1.INVOICECODE) IS NOT NULL
     AND TRIM(T1.PAYERNAME) <> TRIM(T1.CUSTOMERNAME) --开票人名称不等于承兑人名称
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT DISTINCT CONTRACTSERIALNO,T2.CUST_ID AS CUSTOMERID,PAYERNAME,
         '02' AS BILLDOCTYPE,INVOICECODE,CURRENCY,AMOUNTTAX --录入有重复的，先去重，不能直接GROUP BY
    FROM RRP_MDL.O_IOL_ICMS_COMMERCIAL_DOC_INFO T1 --商业单据信息表
    LEFT JOIN CORP_CUST_INFO T2 --对公客户信息
      ON T2.CUST_NAME = TRIM(T1.PAYERNAME)
     AND T2.RN = 1
   WHERE TRIM(T1.INVOICECODE) IS NOT NULL
     AND TRIM(T1.PAYERNAME) = TRIM(T1.CUSTOMERNAME)
     AND NOT EXISTS (SELECT 1 FROM RRP_MDL.O_IOL_ICMS_COMMERCIAL_DOC_INFO T3 
                      WHERE T3.INVOICECODE = T1.INVOICECODE
                        AND TRIM(T3.INVOICECODE) IS NOT NULL
                        AND TRIM(T3.PAYERNAME) <> TRIM(T3.CUSTOMERNAME)
                        AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  M_LOAN_TRA_BKGD_INFO_TMP AS (/*+ ORDERED USE_HASH(A,B,E)*/
  SELECT /*+MATERIALIZE*/DISTINCT E.CONT_ID,E.CURR_CD,
         CASE WHEN TRIM(E.MGMT_ORG_ID) IS NULL THEN E.RGST_ORG_ID ELSE E.MGMT_ORG_ID END AS BELONG_ORG_ID
        ,H.INVOICECODE AS VOUCHER_NO      --单据ID
        ,H.BILLDOCTYPE AS VOUCHER_TYPE    --单据种类
        ,H.CURRENCY    AS VOUCHER_CURCD   --商业单据币种
        ,H.AMOUNTTAX   AS VOUCHER_AMT     --商业单据金额（发票含税金额）
        ,H.CUSTOMERID  AS CUSTOMERID      --客户编号
        ,H.PAYERNAME   AS PAYERNAME       --开票人客户名称
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
   INNER JOIN (SELECT CONTRACTSERIALNO,CUSTOMERID,PAYERNAME,BILLDOCTYPE,INVOICECODE,CURRENCY,SUM(AMOUNTTAX) AS AMOUNTTAX
                 FROM COMMERCIAL_DOC_INFO
                GROUP BY CONTRACTSERIALNO,CUSTOMERID,PAYERNAME,BILLDOCTYPE,INVOICECODE,CURRENCY) H --商业单据信息表
      ON H.CONTRACTSERIALNO = E.CONT_ID
   WHERE E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                          AS DATA_DT      --数据日期
        ,T2.LP_ID                                          AS LGL_REP_ID   --法人编号
        ,T1.BELONG_ORG_ID                                  AS ORG_ID       --机构编号
        ,'A01'                                             AS BIZ_CL       --业务种类 --T0002 承兑汇票
        ,T2.BILL_NUM                                       AS BIZ_ID       --业务编号 --因EAST的业务编号需和票据出票表跨表校验，将该字段赋值为票据号码
        ,T1.CURR_CD                                        AS CUR          --币种
        ,T1.VOUCHER_AMT                                    AS CONT_AMT     --合同金额
        ,T1.VOUCHER_NO                                     AS INV_ID       --单据编号
        ,CASE WHEN T1.VOUCHER_TYPE = '01' THEN '商业发票'
              WHEN T1.VOUCHER_TYPE = '02' THEN '增值税发票'
              WHEN T1.VOUCHER_TYPE = '03' THEN '证实发票'
              WHEN T1.VOUCHER_TYPE = '04' THEN '收妥发票'
              WHEN T1.VOUCHER_TYPE = '05' THEN '厂商发票'
              WHEN T1.VOUCHER_TYPE = '06' THEN '形式发票'
              WHEN T1.VOUCHER_TYPE = '07' THEN '样品发票'
              WHEN T1.VOUCHER_TYPE = '08' THEN '领事发票'
              WHEN T1.VOUCHER_TYPE = '09' THEN '寄售发票'
              WHEN T1.VOUCHER_TYPE = '10' THEN '海关发票'
              WHEN T1.VOUCHER_TYPE = '11' THEN '提单'
              WHEN T1.VOUCHER_TYPE = '12' THEN '报关单'
              WHEN T1.VOUCHER_TYPE = '13' THEN '货物清单'
              WHEN T1.VOUCHER_TYPE = '00' THEN '其他'
          END                                              AS INV_CL       --单据种类
        ,T1.VOUCHER_CURCD                                  AS INV_CUR      --单据币种
        ,T1.VOUCHER_AMT                                    AS INV_AMT      --单据金额
        ,'800919'                                          AS DEPT_LINE    --部门条线
        ,'承兑汇票'                                        AS DATA_SRC     --数据来源
        ,TO_CHAR(T2.DRAW_DT,'YYYYMMDD')                    AS INV_START_DT --单据起始日期
        ,T1.CONT_ID                                        AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM M_LOAN_TRA_BKGD_INFO_TMP T1
   INNER JOIN BILL_CONT T2
      ON T2.CONT_ID = T1.CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-保理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
  SELECT /*+MATERIALIZE*/
         V_P_DATE                                          AS DATA_DT      --数据日期
        ,T1.LP_ID                                          AS LGL_REP_ID   --法人编号
        ,T1.ACCT_INSTIT_ID                                 AS ORG_ID       --内部机构号
        ,'17'                                              AS BIZ_CL       --业务种类 --T0006 国内保理
        ,NVL(TRIM(T1.CONT_ID),'1')                         AS BIZ_ID       --业务编号
        ,T2.CURR_CD                                        AS CUR          --币种
        ,T2.CONT_AMT                                       AS CONT_AMT     --合同金额
        ,T3.INVONUM                                        AS INV_ID       --单据编号
        ,'增值税发票'                                      AS INV_CL       --单据种类
        ,'CNY'                                             AS INV_CUR      --单据币种
        ,T3.INVOAMTTAX                                     AS INV_AMT      --单据金额
        ,'800919'                                          AS DEPT_LINE    --部门条线 /*风险管理部*/
        ,'保理'                                            AS DATA_SRC     --数据来源
        ,TO_CHAR(T1.DISTR_DT,'YYYYMMDD')                   AS INV_START_DT --单据起始日期
        ,TRIM(T1.CONT_ID)                                  AS CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T1 --对公贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T2 --对公贷款合同信息
      ON T2.CONT_ID = T1.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IOL_ICMS_PUTOUT_INVOCODELIST T3 --兴链贷发票列表
      ON T3.PUTOUTSERIALNO = T1.OUT_ACCT_FLOW_NUM
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.STD_PROD_ID IN ('203030500001','203030500015') --203030500001兴链贷、203030500015兴付贷预支价金
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入交易背景信息表-汇总数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRA_BKGD_INFO
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,ORG_ID       --机构编号
    ,BIZ_CL       --业务种类
    ,BIZ_ID       --业务编号
    ,CUR          --币种
    ,CONT_AMT     --合同金额
    ,INV_ID       --单据编号
    ,INV_CL       --单据种类
    ,INV_CUR      --单据币种
    ,INV_AMT      --单据金额
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    ,INV_START_DT --单据起始日期
    ,CONT_ID      --合同号 --ADD BY LIP 20260306
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*/
         DATA_DT      --数据日期
        ,LGL_REP_ID   --法人编号
        ,ORG_ID       --机构编号
        ,BIZ_CL       --业务种类
        ,BIZ_ID       --业务编号
        ,CUR          --币种
        ,CONT_AMT     --合同金额
        ,INV_ID       --单据编号
        ,INV_CL       --单据种类
        ,INV_CUR      --单据币种
        ,INV_AMT      --单据金额
        ,DEPT_LINE    --部门条线
        ,DATA_SRC     --数据来源
        ,INV_START_DT --单据起始日期
        ,CONT_ID      --合同号 --ADD BY LIP 20260306
        ,ROW_NUMBER() OVER(PARTITION BY BIZ_ID,INV_ID ORDER BY INV_START_DT DESC) AS RN
    FROM RRP_MDL.M_LOAN_TRA_BKGD_INFO_TEMP01)
  SELECT DATA_DT      --数据日期
        ,LGL_REP_ID   --法人编号
        ,ORG_ID       --机构编号
        ,BIZ_CL       --业务种类
        ,BIZ_ID       --业务编号
        ,CUR          --币种
        ,CONT_AMT     --合同金额
        ,INV_ID       --单据编号
        ,INV_CL       --单据种类
        ,INV_CUR      --单据币种
        ,INV_AMT      --单据金额
        ,DEPT_LINE    --部门条线
        ,DATA_SRC     --数据来源
        ,INV_START_DT --单据起始日期
        ,CONT_ID      --合同号 --ADD BY LIP 20260306
    FROM TMP1
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,BIZ_ID,INV_ID,ORG_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_TRA_BKGD_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,BIZ_ID,INV_ID,ORG_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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

END ETL_M_LOAN_TRA_BKGD_INFO;
/

