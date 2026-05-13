CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_CD_DTL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_CD_DTL
  *  功能描述：存单业务交易流水
  *  创建日期：20220618
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_TRA_CD_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220618  梅炜      首次创建
  *             2    20221122  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_CD_DTL'; -- 程序名称
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
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_TRA_CD_DTL'; --表名
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

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存单业务交易流水表--同业存单投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
  (
    DATA_DT                                         --01数据日期
    ,LGL_REP_ID                                     --02法人编号
    ,SEQ_NO                                         --03流水号
    ,CUST_ID                                        --04客户编号
    ,TRA_TYP                                        --05交易类型
    ,HDL_ORG_ID                                     --06经办机构编号
    ,OPP_ACC                                        --07对方账号
    ,OPP_ACC_NM                                     --08对方户名
    ,OPP_PBC_NO                                     --09对方行号
    ,OPP_BANK_NM                                    --10对方行名
    ,TRA_CHAN                                       --11交易渠道
    ,CUR                                            --12币种
    ,ACC_ID                                         --13账户编号
    ,TRA_AMT                                        --14交易金额
    ,OCCUR_SETL_TYP                                 --15发生结清类型
    ,DEPT_LINE                                      --16部门条线
    ,DATA_SRC                                       --17数据来源
    ,TRA_TM                                         --18交易时间
    ,TRAN_ACCT_ID                                   --19本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO                         --20本方清算账户开户行行号
    ,ACT_RATE                                       --21实际利率
    )
    SELECT
     TO_CHAR(A.STL_DT,'YYYYMMDD')               		DATA_DT                 --01数据日期
    ,A.LP_ID                                        LGL_REP_ID              --02法人编号
    ,A.TRAN_ID                                      SEQ_NO                  --03流水号
    ,NVL(A.CUST_ID,M.CUST_ID)                       CUST_ID                 --04客户编号
    ,A.TRAN_DIR_CD                                  TRA_TYP                 --05交易类型
    ,B.ENTRY_ORG_ID                                 HDL_ORG_ID              --06经办机构编号
    ,A.CNTPTY_ACCT_ID                               OPP_ACC                 --07对方账号
    ,A.CNTPTY_NAME                                  OPP_ACC_NM              --08对方户名
    ,A.CNTPTY_ACCT_OPEN_BANK_NO                     OPP_PBC_NO              --09对方行号
    ,A.CNTPTY_ACCT_OPEN_BANK_NO                     OPP_BANK_NM             --10对方行名
    ,P.CD_DESCB                                     TRA_CHAN                --11交易渠道
    ,A.CURR_CD                                      CUR                     --12币种
    ,A.BOND_ID||'_'||A.TRAN_ACCT_B_ID               ACC_ID                  --13账户编号
    ,A.BOND_FAC_VAL                                 TRA_AMT                 --14交易金额
    ,DECODE(A.TRAN_DIR_CD, '01', '1', '02', '0')    OCCUR_SETL_TYP          --15发生结清类型
    ,NULL                                           DEPT_LINE               --16部门条线
    ,'存单投资'                                      DATA_SRC                --17数据来源
    ,A.STL_DT                                       TRA_TM                  --18交易时间
    ,A.TRAN_ACCT_ID                                 TRAN_ACCT_ID            --19本方清算账户编号
    ,A.TRAN_ACCT_OPEN_BANK_NO                       TRAN_ACCT_OPEN_BANK_NO  --20本方清算账户开户行行号
    ,A.EXP_YLD_RAT                                  ACT_RATE                --21实际利率
    FROM O_ICL_CMM_CAP_SEC_TRAN A                   --资金现券交易表
    LEFT JOIN O_ICL_CMM_CAP_BOND_INVEST B           --资金债券投资表
    ON   A.BOND_ID = B.BOND_ID
    AND A.TRAN_ACCT_B_ID = B.TRAN_ACCT_B_ID
    AND  B.ETL_DT = A.ETL_DT
    LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO C           --债券基本信息
      ON B.BOND_ID = C.BOND_ID
     AND B.ETL_DT = C.ETL_DT
    LEFT JOIN O_IML_PTY_CAP_CNTPTY_INFO M           --资金交易对手信息
        ON A.CNTPTY_ID = M.CNTPTY_ID
       AND A.ETL_DT = M.ETL_DT
    LEFT JOIN O_ICL_CMM_DEP_ACCT_TRAN_DTL D         --存款账户交易明细
    ON D.TRAN_FLOW_NUM = A.TRAN_ID
    AND D.ETL_DT = A.ETL_DT
    LEFT JOIN O_IML_REF_PUB_CD  P  --公共代码表
    ON P.CD_VAL = D.CHN_CD
    AND P.CD_ID = 'CD2119'
    WHERE A.BOND_TYPE_CD = 'W'
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --每天全量流水
    AND A.TRAN_SRC_CD NOT IN ('13','02','04','09'）--20221018 XUXIAOBIN ADD
    AND TRUNC(A.STL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   /*20221101 xuxiaobin add*/
   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存单业务交易流水表--同业存款现券收付息(收回)';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,SEQ_NO  --流水号
    ,CUST_ID  --客户编号
    ,TRA_TYP  --交易类型
    ,HDL_ORG_ID  --经办机构编号
    ,OPP_ACC  --对方账号
    ,OPP_ACC_NM  --对方户名
    ,OPP_PBC_NO  --对方行号
    ,OPP_BANK_NM  --对方行名
    ,TRA_CHAN  --交易渠道
    ,CUR  --币种
    ,ACC_ID  --账户编号
    ,TRA_AMT  --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,TRA_TM    --交易时间
    ,TRAN_ACCT_ID --本方清算账号
    ,TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号
    ,ACT_RATE  --实际利率
    )
    SELECT
     TO_CHAR(A.ACTL_PAY_DT,'YYYYMMDD')                        DATA_DT  --数据日期
    ,A.LP_ID                                                  LGL_REP_ID  --法人编号
    ,A.QUOTE_TABLE_NAME || '_' || A.SRC_EVT_ID                SEQ_NO  --流水号
    ,NVL(B.ISSUER_CUST_ID,' ')                                CUST_ID  --客户编号
    ,A.PRIC_INT_TYPE_CD                                       TRA_TYP  --交易类型
    ,B.ENTRY_ORG_ID                                           HDL_ORG_ID  --经办机构编号
    ,EX.TRAN_ACCT_OPEN_BANK_NO                                OPP_ACC  --对方账号
    ,EX.CNTPTY_NAME                                           OPP_ACC_NM  --对方户名
    ,EX.CNTPTY_ACCT_OPEN_BANK_NO                              OPP_PBC_NO  --对方行号
    ,''                                                       OPP_BANK_NM  --对方行名
    ,''                                                       TRA_CHAN  --交易渠道
    ,B.CURR_CD                                                CUR  --币种
    ,A.BOND_CD || '_' || A.ACCT_ID                            ACC_ID  --账户编号20221018 XUXIAOBIN MODIFY
    ,DECODE(B.DISCNT_DEBT_FLG,'1',A.RPP_AMT + A.PAY_INT_AMT,A.RPP_AMT)
                                                              TRA_AMT  --交易金额
    ,('0')                                                    OCCUR_SETL_TYP  --发生结清类型
    ,'800975'                                                 DEPT_LINE  --部门条线
    ,'同业存款现券收付息(收回)'                                 DATA_SRC  --数据来源
    ,A.ACTL_PAY_DT                                            TRA_TM    --交易时间
    ,EX.CNTPTY_ACCT_ID AS TRAN_ACCT_ID --本方清算账号 收回时是反过来拿20221204
    ,EX.CNTPTY_ACCT_OPEN_BANK_NO  AS TRAN_ACCT_OPEN_BANK_NO --本方清算账户开户行行号 收回时是反过来拿20221204
    ,NVL(CASE WHEN C.ISSUE_INT_RAT = 0 THEN NULL ELSE C.ISSUE_INT_RAT END,B.FAC_VAL_INT_RAT) AS ACT_RATE  --实际利率
    FROM O_IML_EVT_SEC_ACPT_PAY_INT A--现券收付息
      LEFT JOIN O_ICL_CMM_CAP_BOND_INVEST B --资金债券投资
        ON A.ACCT_ID = B.TRAN_ACCT_B_ID
       AND A.BOND_CD = B.BOND_ID
      LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO C    --债券基本信息
        ON A.BOND_CD = C.BOND_ID
       AND C.JOB_CD = 'ctmsf1'
       AND B.ETL_DT = C.ETL_DT
      LEFT JOIN (SELECT ROW_NUMBER()OVER(PARTITION BY T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME ORDER BY T.TRAN_DT)RN
                      ,T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME
                 FROM O_ICL_CMM_PBC_PASS_TRAN_FLOW T
                ) TT
       ON A.ACTL_PAY_DT = TT.TRAN_DT
      AND DECODE(B.DISCNT_DEBT_FLG,'1',A.RPP_AMT + A.PAY_INT_AMT,A.RPP_AMT) = TT.TRAN_AMT
      AND RN = 1
      LEFT JOIN (SELECT A.*,ROW_NUMBER() OVER (PARTITION BY A.BOND_ID||'_'||A.TRAN_ACCT_B_ID ORDER BY A.STL_DT DESC) RN  FROM
      O_ICL_CMM_CAP_SEC_TRAN A
      WHERE A.TRAN_DIR_CD <> '02')EX
      ON A.BOND_CD || '_' || A.ACCT_ID =  EX.BOND_ID||'_'||EX.TRAN_ACCT_B_ID
      AND EX.RN = 1
     WHERE B.BOND_TYPE_CD = 'W'
       AND A.RPP_AMT > 0 --只取还本金额大于0的
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TRUNC(A.ACTL_PAY_DT,'MM')  = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存单业务交易流水表--同业存单发行（发生）';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
  (
   DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,SEQ_NO  --流水号
    ,CUST_ID  --客户编号
    ,TRA_TYP  --交易类型
    ,HDL_ORG_ID  --经办机构编号
    ,OPP_ACC  --对方账号
    ,OPP_ACC_NM  --对方户名
    ,OPP_PBC_NO  --对方行号
    ,OPP_BANK_NM  --对方行名
    ,TRA_CHAN  --交易渠道
    ,CUR  --币种
    ,ACC_ID  --账户编号
    ,TRA_AMT  --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,TRA_TM    --交易时间
    ,TRAN_ACCT_ID --本方清算账户编号
    ,TRAN_ACCT_OPEN_BANK_NO -- 本方清算账户开户行行号
    ,ACT_RATE --实际利率
    )
  SELECT
    TO_CHAR(A.ACTL_STL_DT,'YYYYMMDD')   DATA_DT  --数据日期
    ,B.LP_ID   LGL_REP_ID  --法人编号
    ,A.INTNAL_TRAN_FLOW_NUM SEQ_NO  --流水号
    ,NVL(D1.CUST_ID,' ')  CUST_ID  --客户编号
    ,A.TRAN_TYPE_CD       TRA_TYP  --交易类型
    ,G.BELONG_ORG_ID        HDL_ORG_ID  --经办机构编号
    /*B.CNTPTY_ACCT_NUM*/
/*      NVL(EX.EXCHG_ACCT_ID,B.CNTPTY_ACCT_NUM)    OPP_ACC  --对方账号  交易对手账户号
   ,B.CNTPTY_ACCT_NAME   OPP_ACC_NM  --对方户名
    ,EX.OPEN_ACCT_BANK_NO            OPP_PBC_NO  --对方行号  交易对手开户行号
    ,B.CNTPTY_OPEN_BANK_NAME            OPP_BANK_NM  --对方行名*/

    --md by 20221105 xuxiaobin
    , CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
             THEN   TT.PAYER_ACCT_NUM
              ELSE EX.EXCHG_ACCT_ID  END                          AS OPP_ACC     -- 对方账号  交易对手账户号
    ,B.CNTPTY_ACCT_NAME                                       AS OPP_ACC_NM  -- 对方户名 交易对手账户名
    , CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
         THEN EX.OPEN_ACCT_BANK_NO
           ELSE TT.PAYER_OPEN_BANK_NO     END                 AS OPP_PBC_NO  -- 对方行号  交易对手开户行号
    ,B.CNTPTY_OPEN_BANK_NAME                                  AS OPP_BANK_NM -- 对方行名  交易对手开户行名


    ,NULL                               TRA_CHAN  --交易渠道
    ,D.CURR_CD                          CUR  --币种
    ,/*B.INTNAL_CAP_ACCT_ID*/G.FIN_INSTM_ID||'.'||G.TRAN_NUM               ACC_ID  --账户编号 20221018 xuxiaobin modify
    ,/*B.TRAN_AMT*/ABS(F.ACTL_NET_PRICE_AMT)                         TRA_AMT  --交易金额20221018 MODIFY
    ,/*A.STL_TYPE_CD*/
    CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531') THEN '0'
                ELSE '1'  END                        OCCUR_SETL_TYP  --发生结清类型 --20221018 XUXIAOBIN MODIFY
    ,'800975' AS DEPT_LINE  --部门条线
    ,'同业存单发行(发生)'             DATA_SRC  --数据来源
    ,A.ACTL_STL_DT                         AS TRA_TM    --交易时间
    ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
         THEN   NVL(EX.EXCHG_ACCT_ID,B.CNTPTY_ACCT_NUM)
          ELSE  TT.PAYER_ACCT_NUM END AS  TRAN_ACCT_ID --本方清算账户编号
    ,CASE WHEN A.TRAN_TYPE_CD LIKE D.PROD_TYPE_CD||'30_' OR A.TRAN_TYPE_CD IN ('0100531')
         THEN EX.OPEN_ACCT_BANK_NO
           ELSE TT.PAYER_OPEN_BANK_NO   END AS     TRAN_ACCT_OPEN_BANK_NO --  本方清算账户开户行行号
    ,CASE WHEN A.TRAN_TYPE_CD = '0000081' THEN E.ANNUAL_INT_RAT ELSE D.FAC_VAL_INT_RAT END  AS ACT_RATE
   FROM O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL A --同业主指令明细
     LEFT JOIN O_IML_EVT_IBANK_TRAN B --同业交易表
       ON A.INTNAL_TRAN_FLOW_NUM = B.INTNAL_TRAN_NUM
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM D --同业金融工具表
       ON B.FIN_INSTM_ID = D.FIN_INSTM_ID
      AND B.ASSET_TYPE_ID = D.ASSET_TYPE_ID
      AND B.TRAN_MARKET_ID = D.MARKET_TYPE_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_IML_AGT_IBANK_DEP_RCPT E  --同业存单表
       ON B.FIN_INSTM_ID = E.DEP_RCPT_CD
      AND B.ASSET_TYPE_ID = E.ASSET_TYPE_CD
      AND B.TRAN_MARKET_ID = E.MARKET_TYPE_CD
      AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL F --同业券指令明细
       ON F.MAIN_INSTR_SEQ_NUM = A.MAIN_INSTR_SEQ_NUM
     LEFT JOIN O_ICL_CMM_IBANK_SECU_POST G --同业证券持仓表
       ON G.BUS_ID=B.INTNAL_TRAN_NUM
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_IBANK_CAP_BAL EX --同业资金余额表
       ON B.INTNAL_CAP_ACCT_ID = EX.INTNAL_CAP_ACCT_ID
      AND B.EXT_CAP_ACCT_ID = EX.EXT_CAP_ACCT_ID
      AND EX.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO D1 --同业交易对手信息
     ON B.CNTPTY_ID = D1.SRC_PARTY_ID
     AND B.ETL_DT = D1.ETL_DT
     --add by 20221105 xuxiaobin
     LEFT JOIN (SELECT ROW_NUMBER()OVER(PARTITION BY T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME ORDER BY T.TRAN_DT)RN
                      ,T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME
                 FROM O_ICL_CMM_PBC_PASS_TRAN_FLOW T
                ) TT
       ON A.ACTL_STL_DT = TT.TRAN_DT
      AND ABS(F.ACTL_NET_PRICE_AMT) = TT.TRAN_AMT
      AND SUBSTR(b.CNTPTY_NAME,1,10) = SUBSTR(TT.PAYER_NAME,1,10)
      AND RN = 1

     WHERE /*B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.INTNAL_CAP_ACCT_ID IS NOT NULL*/
      A.TRAN_TYPE_CD IN ('0000000','0202100','0000081')
      AND D.ASSET_TYPE_NAME='同业存单'
      AND F.ACTL_NET_PRICE_AMT <> 0
      AND A.TRAN_TYPE_CD NOT LIKE D.PROD_TYPE_CD||'2%'
      AND A.INSTR_STATUS_CD='02'
      AND (A.PARENT_INSTR_ID IN (0,-1) OR A.PARENT_INSTR_ID = A.MAIN_INSTR_SEQ_NUM)
      AND F.ACTL_NET_PRICE_AMT+F.ACTL_ACRU_INT<>0
      AND A.ACTL_STL_DT >= D.VALUE_DT
      AND A.ACTL_STL_DT <= D.EXP_DT
      AND TRUNC(A.ACTL_STL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
      ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   /*20221031 XUXIAOBIN ADD*/
    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存单业务交易流水表--同业存单发行(收回)';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_CD_DTL
  (
   DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,SEQ_NO  --流水号
    ,CUST_ID  --客户编号
    ,TRA_TYP  --交易类型
    ,HDL_ORG_ID  --经办机构编号
    ,OPP_ACC  --对方账号
    ,OPP_ACC_NM  --对方户名
    ,OPP_PBC_NO  --对方行号
    ,OPP_BANK_NM  --对方行名
    ,TRA_CHAN  --交易渠道
    ,CUR  --币种
    ,ACC_ID  --账户编号
    ,TRA_AMT  --交易金额
    ,OCCUR_SETL_TYP  --发生结清类型
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,TRA_TM    --交易时间
    ,TRAN_ACCT_ID --本方清算账户编号
    ,TRAN_ACCT_OPEN_BANK_NO -- 本方清算账户开户行行号
    ,ACT_RATE --实际利率
    )
  SELECT
    TO_CHAR(A.CHG_DT,'YYYYMMDD')   DATA_DT  --数据日期
    ,B.LP_ID   LGL_REP_ID  --法人编号
    ,V.MAIN_INSTR_SEQ_NUM+A.ACCTI_OBJ_ID SEQ_NO  --流水号
    ,COALESCE(B.CNTPTY_ID,C.CNTPTY_ID,'1')  CUST_ID  --客户编号
    ,NULL       TRA_TYP  --交易类型
    ,I.BELONG_ORG_ID        HDL_ORG_ID  --经办机构编号
    ,NVL(B.CNTPTY_ACCT_NUM,C.CNTPTY_ACCT_NUM)    OPP_ACC  --对方账号
    ,B.CNTPTY_ACCT_NAME   OPP_ACC_NM  --对方户名
    ,COALESCE(EX.OPEN_ACCT_BANK_NO,B.CNTPTY_OPEN_BANK_NUM,C.CNTPTY_OPEN_BANK_NUM)            OPP_PBC_NO  --对方行号
    ,B.CNTPTY_OPEN_BANK_NAME            OPP_BANK_NM  --对方行名
    ,NULL                               TRA_CHAN  --交易渠道
    ,E.CURR_CD                          CUR  --币种
    ,A.FIN_INSTM_ID||'.'||A.TRAN_NUM               ACC_ID  --账户编号
    ,ABS(A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT)        TRA_AMT  --交易金额
    ,'0'                        OCCUR_SETL_TYP  --发生结清类型
    ,'800975' AS DEPT_LINE  --部门条线
    ,'同业存单发行(收回)'             DATA_SRC  --数据来源
    ,A.CHG_DT                         AS TRA_TM    --交易时间
    ,EX.EXCHG_ACCT_ID AS TRAN_ACCT_ID
    ,EX.OPEN_ACCT_BANK_NO AS TRAN_ACCT_OPEN_BANK_NO
    ,CASE WHEN B.TRAN_TYPE_ID = '0000081' THEN D.ANNUAL_INT_RAT ELSE E.FAC_VAL_INT_RAT END  AS ACT_RATE
   FROM O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H A --证券账户核算余额变动历史
     LEFT JOIN O_IML_EVT_IBANK_TRAN B  --同业交易表
       ON A.TRAN_NUM = B.INTNAL_TRAN_NUM
     LEFT JOIN O_IML_EVT_IBANK_TRAN C --同业交易表
       ON B.QUOTE_TRAN_NUM = C.TRAN_NUM
     LEFT JOIN O_IML_AGT_IBANK_DEP_RCPT D --同业存单表
       ON B.FIN_INSTM_ID = D.DEP_RCPT_CD
      AND B.ASSET_TYPE_ID = D.ASSET_TYPE_CD
      AND B.TRAN_MARKET_ID = D.MARKET_TYPE_CD
      AND '101007'||C.INTNAL_TRAN_NUM = D.VOUCH_ID
     LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM E --同业金融工具表
       ON A.FIN_INSTM_ID = E.FIN_INSTM_ID
      AND A.ASSET_TYPE_ID = E.ASSET_TYPE_ID
      AND A.MARKET_TYPE_ID = E.MARKET_TYPE_ID
      AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL F   --同业券指令明细
       ON A.INSTR_ID = F.SECU_INSTR_SEQ_NUM
     LEFT JOIN O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL V   --同业主指令明细
       ON F.MAIN_INSTR_SEQ_NUM = V.MAIN_INSTR_SEQ_NUM
     LEFT JOIN O_IML_EVT_IBANK_TRAN_MAIN_INSTR_DTL PV --同业主指令明细
       ON V.PARENT_INSTR_ID = PV.MAIN_INSTR_SEQ_NUM
     LEFT JOIN O_ICL_CMM_IBANK_SECU_POST I --同业证券持仓表
       ON A.FIN_INSTM_ID = I.FIN_INSTM_ID
      AND A.TRAN_NUM=I.BUS_ID
      AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_ICL_CMM_IBANK_CAP_BAL EX --同业资金余额表
       ON B.INTNAL_CAP_ACCT_ID = EX.INTNAL_CAP_ACCT_ID
      AND B.EXT_CAP_ACCT_ID = EX.EXT_CAP_ACCT_ID
      AND EX.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     /*LEFT JOIN (SELECT ROW_NUMBER()OVER(PARTITION BY T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME ORDER BY T.TRAN_DT)RN
                      ,T.TRAN_DT, T.TRAN_AMT, T.PAYER_ACCT_NUM,T.PAYER_OPEN_BANK_NO, T.PAYER_NAME
                 FROM S_ICL_CMM_PBC_PASS_TRAN_FLOW T
               ) TT --ADD BY HAP 20211225
       --ON V.ACTL_STL_DT = TT.TRAN_DT
       ON B.STL_DT = TT.TRAN_DT---ADD BY WYP 20220228   交易表只有发生的流水所以关联发生时的时间通过发生的信息取对手
      AND ABS(F.ACTL_NET_PRICE_AMT) = TT.TRAN_AMT
      AND SUBSTR(B.CNTPTY_NAME,1,10) = SUBSTR(TT.PAYER_NAME,1,10)
      AND RN = 1*/
    WHERE V.TRAN_TYPE_CD IN ('0000300','0000301','0000001','0202101')
      AND E.ASSET_TYPE_NAME = '同业存单'
      AND A.REVO_RELA_CHG_ID = -1  --撤销关联变动编号=-1估计就是未撤销的
      AND (PV.PARENT_INSTR_ID IN (0,-1) OR PV.PARENT_INSTR_ID = PV.MAIN_INSTR_SEQ_NUM)
      AND A.ACCTI_TYPE_CD = 'R'
      AND A.NET_PRICE_COST+A.RECVBL_UNCOL_NET_PRICE_COST+A.ACRU_INT+A.RECVBL_UNCOL_ACRU_INT <> 0
      AND A.CHG_DT >= E.VALUE_DT
      AND TRUNC(A.CHG_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
 ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

 -- 数据重复校验 --
     WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_CD_DTL T
   WHERE SUBSTR(DATA_DT,1,6) =  SUBSTR(V_P_DATE,1,6)
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
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

  END ETL_INIT_M_TRA_CD_DTL;
/

