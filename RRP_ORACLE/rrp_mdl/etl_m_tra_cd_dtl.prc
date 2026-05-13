CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_CD_DTL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_M_TRA_CD_DTL
  *  功能描述：存单业务交易流水
  *  创建日期：20220618
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_TRA_CD_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220618  梅炜      首次创建
  *             2    20221122  hulj      增加数据重复校验
  *             3    20231106  LYH       增加同业存单投资票面金额字段
  *             4    20250327  LYH       解决数据重复问题
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);        --任务名称
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_CD_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_CD_DTL'; --程序名称
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
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  /*20221031 存单应只保函存单投资与存单发行，同业存放不放此表*/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单业务交易流水表--同业存单投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
    (DATA_DT         --数据日期
    ,LGL_REP_ID      --法人编号
    ,SEQ_NO          --流水号
    ,CUST_ID         --客户编号
    ,TRA_TYP         --交易类型
    ,HDL_ORG_ID      --经办机构编号
    ,OPP_ACC         --对方账号
    ,OPP_ACC_NM      --对方户名
    ,OPP_PBC_NO      --对方行号
    ,OPP_BANK_NM     --对方行名
    ,TRA_CHAN        --交易渠道
    ,CUR             --币种
    ,ACC_ID          --账户编号
    ,TRA_AMT         --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE       --部门条线
    ,DATA_SRC        --数据来源
    ,TRA_TM          --交易时间
    ,TRAN_ACCT_ID    --本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
    ,ACT_RATE        --实际利率
    ,NOMINAL         --券面总额 ADD BY LYH 20231106
    )
  SELECT V_P_DATE                                  AS DATA_DT         --数据日期
        ,A.LP_ID                                   AS LGL_REP_ID      --法人编号
        ,A.TRAN_ID                                 AS SEQ_NO          --流水号
        ,NVL(A.CUST_ID,M.CUST_ID)                  AS CUST_ID         --客户编号
        ,A.TRAN_DIR_CD                             AS TRA_TYP         --交易类型
        ,B.ENTRY_ORG_ID                            AS HDL_ORG_ID      --经办机构编号
        ,A.CNTPTY_ACCT_ID                          AS OPP_ACC         --对方账号
        ,A.CNTPTY_NAME                             AS OPP_ACC_NM      --对方户名
        ,A.CNTPTY_ACCT_OPEN_BANK_NO                AS OPP_PBC_NO      --对方行号
        ,A.CNTPTY_ACCT_OPEN_BANK_NO                AS OPP_BANK_NM     --对方行名
        ,P.CD_DESCB                                AS TRA_CHAN        --交易渠道
        ,A.CURR_CD                                 AS CUR             --币种
        ,A.BOND_ID||'_'||A.TRAN_ACCT_B_ID          AS ACC_ID          --账户编号 20221018 XUXIAOBIN MODIFY
        ,A.BOND_FAC_VAL                            AS TRA_AMT         --交易金额
        ,DECODE(A.TRAN_DIR_CD,'01','1','02','0')   AS OCCUR_SETL_TYP  --发生结清类型
        ,'800975'                                  AS DEPT_LINE       --部门条线
        ,'存单投资'                                AS DATA_SRC        --数据来源
        ,A.STL_DT                                  AS TRA_TM          --交易时间
        ,A.TRAN_ACCT_ID                            AS TRAN_ACCT_ID    --本方清算账户编号
        ,A.TRAN_ACCT_OPEN_BANK_NO                  AS TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
        ,A.EXP_YLD_RAT                             AS ACT_RATE        --实际利率
        ,F.NOMINAL                                 AS NOMINAL         --券面总额 ADD BY LYH 20231106
    FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN A --资金现券交易表
    LEFT JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST B  --资金债券投资表
      ON B.BOND_ID = A.BOND_ID
     AND B.TRAN_ACCT_B_ID = A.TRAN_ACCT_B_ID --20221018 XUXIAOBIN ADD
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO C  --债券基本信息
      ON C.BOND_ID = B.BOND_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CAP_CNTPTY_INFO M --资金交易对手信息
      ON M.CNTPTY_ID = A.CNTPTY_ID
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL D --存款账户交易明细
      ON D.TRAN_FLOW_NUM = A.TRAN_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD P  --公共代码表
      ON P.CD_VAL = D.CHN_CD
     AND P.CD_ID = 'CD2119'
    --BEGIN ADD BY LYH 20231106，增加同业存单投资票面金额字段
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS F
      ON F.DEAL_ID = A.BUS_ID
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    --END ADD BY LYH 20231106，增加同业存单投资票面金额字段
   WHERE A.BOND_TYPE_CD = 'W'
     AND A.TRAN_SRC_CD NOT IN ('13','02','04','09')--20221018 XUXIAOBIN ADD
     AND A.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /*20221101 XUXIAOBIN ADD*/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单业务交易流水表--同业存款现券收付息(收回)';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
    (DATA_DT         --数据日期
    ,LGL_REP_ID      --法人编号
    ,SEQ_NO          --流水号
    ,CUST_ID         --客户编号
    ,TRA_TYP         --交易类型
    ,HDL_ORG_ID      --经办机构编号
    ,OPP_ACC         --对方账号
    ,OPP_ACC_NM      --对方户名
    ,OPP_PBC_NO      --对方行号
    ,OPP_BANK_NM     --对方行名
    ,TRA_CHAN        --交易渠道
    ,CUR             --币种
    ,ACC_ID          --账户编号
    ,TRA_AMT         --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE       --部门条线
    ,DATA_SRC        --数据来源
    ,TRA_TM          --交易时间
    ,TRAN_ACCT_ID    --本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
    ,ACT_RATE        --实际利率
    )
  SELECT V_P_DATE                                    AS DATA_DT         --数据日期
        ,A.LP_ID                                     AS LGL_REP_ID      --法人编号
        ,A.QUOTE_TABLE_NAME || '_' || A.SRC_EVT_ID   AS SEQ_NO          --流水号
        ,NVL(B.ISSUER_CUST_ID,' ')                   AS CUST_ID         --客户编号
        ,A.PRIC_INT_TYPE_CD                          AS TRA_TYP         --交易类型
        ,B.ENTRY_ORG_ID                              AS HDL_ORG_ID      --经办机构编号
        ,EX.TRAN_ACCT_OPEN_BANK_NO                   AS OPP_ACC         --对方账号
        ,EX.CNTPTY_NAME                              AS OPP_ACC_NM      --对方户名
        ,EX.CNTPTY_ACCT_OPEN_BANK_NO                 AS OPP_PBC_NO      --对方行号
        ,''                                          AS OPP_BANK_NM     --对方行名
        ,''                                          AS TRA_CHAN        --交易渠道
        ,B.CURR_CD                                   AS CUR             --币种
        ,A.BOND_CD || '_' || A.ACCT_ID               AS ACC_ID          --账户编号 20221018 XUXIAOBIN MODIFY
        ,DECODE(B.DISCNT_DEBT_FLG,'1',A.RPP_AMT + A.PAY_INT_AMT,A.RPP_AMT) AS TRA_AMT  --交易金额
        ,('0')                                       AS OCCUR_SETL_TYP  --发生结清类型
        ,'800975'                                    AS DEPT_LINE       --部门条线
        ,'同业存款现券收付息(收回)'                  AS DATA_SRC        --数据来源
        ,A.ACTL_PAY_DT                               AS TRA_TM          --交易时间
        ,EX.CNTPTY_ACCT_ID                           AS TRAN_ACCT_ID    --本方清算账号 收回时是反过来拿20221204
        ,EX.CNTPTY_ACCT_OPEN_BANK_NO                 AS TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号 收回时是反过来拿20221204
        ,NVL(CASE WHEN C.ISSUE_INT_RAT = 0 THEN NULL ELSE C.ISSUE_INT_RAT END,B.FAC_VAL_INT_RAT) AS ACT_RATE  --实际利率
    FROM RRP_MDL.O_IML_EVT_SEC_ACPT_PAY_INT A --现券收付息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST B --资金债券投资
      ON B.TRAN_ACCT_B_ID = A.ACCT_ID
     AND B.BOND_ID = A.BOND_CD
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO C --债券基本信息
      ON C.BOND_ID = A.BOND_CD
     AND C.JOB_CD = 'ctmsf1'
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY A.BOND_ID||'_'||A.TRAN_ACCT_B_ID ORDER BY A.STL_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN A
                WHERE A.TRAN_DIR_CD <> '02')EX
      ON EX.BOND_ID||'_'||EX.TRAN_ACCT_B_ID = A.BOND_CD || '_' || A.ACCT_ID
     AND EX.RN = 1
   WHERE B.BOND_TYPE_CD = 'W'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.RPP_AMT > 0 --只取还本金额大于0的
     AND A.ACTL_PAY_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单业务交易流水表--同业存单发行（发生）';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
    (DATA_DT         --数据日期
    ,LGL_REP_ID      --法人编号
    ,SEQ_NO          --流水号
    ,CUST_ID         --客户编号
    ,TRA_TYP         --交易类型
    ,HDL_ORG_ID      --经办机构编号
    ,OPP_ACC         --对方账号
    ,OPP_ACC_NM      --对方户名
    ,OPP_PBC_NO      --对方行号
    ,OPP_BANK_NM     --对方行名
    ,TRA_CHAN        --交易渠道
    ,CUR             --币种
    ,ACC_ID          --账户编号
    ,TRA_AMT         --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE       --部门条线
    ,DATA_SRC        --数据来源
    ,TRA_TM          --交易时间
    ,TRAN_ACCT_ID    --本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
    ,ACT_RATE        --实际利率
    )
  SELECT V_P_DATE                                    AS DATA_DT         --数据日期
        ,B.LP_ID                                     AS LGL_REP_ID      --法人编号
        ,A.INTNAL_TRAN_FLOW_NUM                      AS SEQ_NO          --流水号
        ,NVL(D1.CUST_ID,' ')                         AS CUST_ID         --客户编号
        ,A.TRAN_TYPE_CD                              AS TRA_TYP         --交易类型
        ,G.BELONG_ORG_ID                             AS HDL_ORG_ID      --经办机构编号
        --MD BY 20221105 XUXIAOBIN
        ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531') THEN TT.PAYER_ACCT_NUM
              ELSE EX.EXCHG_ACCT_ID
          END                                        AS OPP_ACC         --对方账号 交易对手账户号
        ,B.CNTPTY_ACCT_NAME                          AS OPP_ACC_NM      --对方户名 交易对手账户名
        ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531') THEN EX.OPEN_ACCT_BANK_NO
              ELSE TT.PAYER_OPEN_BANK_NO
          END                                        AS OPP_PBC_NO      --对方行号 交易对手开户行号
        ,B.CNTPTY_OPEN_BANK_NAME                     AS OPP_BANK_NM     --对方行名 交易对手开户行名
        ,NULL                                        AS TRA_CHAN        --交易渠道
        ,D.CURR_CD                                   AS CUR             --币种
        ,G.FIN_INSTM_ID||'.'||G.TRAN_NUM             AS ACC_ID          --账户编号 20221018 xuxiaobin modify
        ,ABS(F.ACTL_NET_PRICE_AMT)                   AS TRA_AMT         --交易金额20221018 MODIFY
        ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531') THEN '0'
              ELSE '1'
          END                                        AS OCCUR_SETL_TYP  --发生结清类型 --20221018 XUXIAOBIN MODIFY
        ,'800975'                                    AS DEPT_LINE       --部门条线
        ,'同业存单发行(发生)'                        AS DATA_SRC        --数据来源
        ,A.ACTL_STL_DT                               AS TRA_TM          --交易时间
        ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
              THEN NVL(EX.EXCHG_ACCT_ID,B.CNTPTY_ACCT_NUM)
              ELSE TT.PAYER_ACCT_NUM
          END                                        AS TRAN_ACCT_ID    --本方清算账户编号
        ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
              THEN EX.OPEN_ACCT_BANK_NO
              ELSE TT.PAYER_OPEN_BANK_NO
          END                                        AS TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
        ,CASE WHEN A.TRAN_TYPE_CD = '0000081' THEN E.ANNUAL_INT_RAT
              ELSE D.FAC_VAL_INT_RAT
          END                                        AS ACT_RATE        --实际利率
    FROM RRP_MDL.O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN B --同业交易表
      ON B.INTNAL_TRAN_NUM = A.INTNAL_TRAN_FLOW_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY LYH 20231222，解决数据重复问题
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN B1 --同业交易表
      ON B1.TRAN_NUM = B.QUOTE_TRAN_NUM
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM D --同业金融工具表
      ON D.FIN_INSTM_ID = B.FIN_INSTM_ID
     AND D.ASSET_TYPE_ID = B.ASSET_TYPE_ID
     AND D.MARKET_TYPE_ID = B.TRAN_MARKET_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT E  --同业存单表
      ON E.DEP_RCPT_CD = B1.FIN_INSTM_ID
     AND E.ASSET_TYPE_CD = B1.ASSET_TYPE_ID
     AND E.MARKET_TYPE_CD = B1.TRAN_MARKET_ID
     --UPDATE BY LYH 20231222，解决数据重复问题
     AND SUBSTR(E.VOUCH_ID,7) = B1.INTNAL_TRAN_NUM
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL F --同业券指令明细
      ON F.MAIN_INSTR_SEQ_NUM = A.MAIN_INSTR_SEQ_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST G --同业证券持仓表
      ON G.BUS_ID = B.INTNAL_TRAN_NUM
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_CAP_BAL EX --同业资金余额表
      ON EX.INTNAL_CAP_ACCT_ID = B.INTNAL_CAP_ACCT_ID
     AND EX.EXT_CAP_ACCT_ID = B.EXT_CAP_ACCT_ID
     AND EX.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D1 --同业交易对手信息
      ON D1.SRC_PARTY_ID = B.CNTPTY_ID
     AND D1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY 20221105 XUXIAOBIN
    LEFT JOIN (SELECT ROW_NUMBER()OVER(PARTITION BY T.TRAN_DT,T.TRAN_AMT,T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO,T.PAYER_NAME ORDER BY T.TRAN_DT)RN
                     ,T.TRAN_DT,T.TRAN_AMT,T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO,T.PAYER_NAME
                 FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW T) TT
      ON TT.TRAN_DT = A.ACTL_STL_DT
     AND TT.TRAN_AMT = ABS(F.ACTL_NET_PRICE_AMT)
     --MOD BY LYH 20250327
     --AND SUBSTR(TT.PAYER_NAME,1,10) = SUBSTR(B.CNTPTY_NAME,1,10)
     AND TT.PAYER_NAME = B.CNTPTY_NAME 
     AND TT.RN = 1
   WHERE D.ASSET_TYPE_NAME = '同业存单'
     AND F.ACTL_NET_PRICE_AMT <> 0
     AND F.ACTL_NET_PRICE_AMT+F.ACTL_ACRU_INT <> 0
     AND A.TRAN_TYPE_CD IN ('0000000','0202100','0000081')
     AND A.TRAN_TYPE_CD NOT LIKE D.PROD_TYPE_CD||'2%'
     AND A.INSTR_STATUS_CD = '02'
     AND (A.PARENT_INSTR_ID IN (0,-1) OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
     AND A.ACTL_STL_DT >= D.VALUE_DT
     AND A.ACTL_STL_DT <= D.EXP_DT
     AND A.ACTL_STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /*20221031 XUXIAOBIN ADD*/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单业务交易流水表--同业存单发行(收回)';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
    (DATA_DT         --数据日期
    ,LGL_REP_ID      --法人编号
    ,SEQ_NO          --流水号
    ,CUST_ID         --客户编号
    ,TRA_TYP         --交易类型
    ,HDL_ORG_ID      --经办机构编号
    ,OPP_ACC         --对方账号
    ,OPP_ACC_NM      --对方户名
    ,OPP_PBC_NO      --对方行号
    ,OPP_BANK_NM     --对方行名
    ,TRA_CHAN        --交易渠道
    ,CUR             --币种
    ,ACC_ID          --账户编号
    ,TRA_AMT         --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE       --部门条线
    ,DATA_SRC        --数据来源
    ,TRA_TM          --交易时间
    ,TRAN_ACCT_ID    --本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
    ,ACT_RATE        --实际利率
    )
  SELECT V_P_DATE                                     AS DATA_DT         --数据日期
        ,B.LP_ID                                      AS LGL_REP_ID      --法人编号
        ,V.MAIN_INSTR_SEQ_NUM+A.ACCTI_OBJ_ID          AS SEQ_NO          --流水号
        ,COALESCE(B.CNTPTY_ID,C.CNTPTY_ID,'1')        AS CUST_ID         --客户编号
        ,NULL                                         AS TRA_TYP         --交易类型
        ,I.BELONG_ORG_ID                              AS HDL_ORG_ID      --经办机构编号
        ,NVL(B.CNTPTY_ACCT_NUM,C.CNTPTY_ACCT_NUM)     AS OPP_ACC         --对方账号
        ,B.CNTPTY_ACCT_NAME                           AS OPP_ACC_NM      --对方户名
        ,COALESCE(EX.OPEN_ACCT_BANK_NO,B.CNTPTY_OPEN_BANK_NUM,C.CNTPTY_OPEN_BANK_NUM) AS OPP_PBC_NO --对方行号
        ,B.CNTPTY_OPEN_BANK_NAME                      AS OPP_BANK_NM     --对方行名
        ,NULL                                         AS TRA_CHAN        --交易渠道
        ,E.CURR_CD                                    AS CUR             --币种
        ,A.FIN_INSTM_ID||'.'||A.TRAN_NUM              AS ACC_ID          --账户编号
        ,ABS(A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT) AS TRA_AMT --交易金额
        ,'0'                                          AS OCCUR_SETL_TYP  --发生结清类型
        ,'800975'                                     AS DEPT_LINE       --部门条线
        ,'同业存单发行(收回)'                         AS DATA_SRC        --数据来源
        ,A.CHG_DT                                     AS TRA_TM          --交易时间
        ,EX.EXCHG_ACCT_ID                             AS TRAN_ACCT_ID    --本方清算账号
        ,EX.OPEN_ACCT_BANK_NO                         AS TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
        ,CASE WHEN B.TRAN_TYPE_ID = '0000081' THEN D.ANNUAL_INT_RAT ELSE E.FAC_VAL_INT_RAT END AS ACT_RATE --实际利率
    FROM RRP_MDL.O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H A --证券账户核算余额变动历史
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN B  --同业交易表
      ON B.INTNAL_TRAN_NUM = A.TRAN_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN C --同业交易表
      ON C.TRAN_NUM = B.QUOTE_TRAN_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT D --同业存单表
      ON D.DEP_RCPT_CD = B.FIN_INSTM_ID
     AND D.ASSET_TYPE_CD = B.ASSET_TYPE_ID
     AND D.MARKET_TYPE_CD = B.TRAN_MARKET_ID
     AND D.VOUCH_ID = '101007'||C.INTNAL_TRAN_NUM
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM E --同业金融工具表
      ON E.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND E.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND E.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL F   --同业券指令明细
      ON F.SECU_INSTR_SEQ_NUM = A.INSTR_ID
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL V   --同业主指令明细
      ON V.MAIN_INSTR_SEQ_NUM = F.MAIN_INSTR_SEQ_NUM
     AND V.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND V.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL PV --同业主指令明细
      ON PV.MAIN_INSTR_SEQ_NUM = V.PARENT_INSTR_ID
     AND PV.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND PV.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST I --同业证券持仓表
      ON I.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND I.BUS_ID = A.TRAN_NUM
     AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_CAP_BAL EX --同业资金余额表
      ON EX.INTNAL_CAP_ACCT_ID = B.INTNAL_CAP_ACCT_ID
     AND EX.EXT_CAP_ACCT_ID = B.EXT_CAP_ACCT_ID
     AND EX.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE V.TRAN_TYPE_CD IN ('0000300','0000301','0000001','0202101')
     AND E.ASSET_TYPE_NAME = '同业存单'
     AND (PV.PARENT_INSTR_ID IN (0,-1) OR PV.PARENT_INSTR_ID = PV.MAIN_INSTR_SEQ_NUM)
     AND A.REVO_RELA_CHG_ID = -1  --撤销关联变动编号=-1估计就是未撤销的
     AND A.ACCTI_TYPE_CD = 'R'
     AND A.NET_PRICE_COST + A.RECVBL_UNCOL_NET_PRICE_COST + A.ACRU_INT + A.RECVBL_UNCOL_ACRU_INT <> 0
     AND A.CHG_DT >= E.VALUE_DT
     AND A.CHG_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 数据重复校验 --
  WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_CD_DTL T
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

END ETL_M_TRA_CD_DTL;
/

