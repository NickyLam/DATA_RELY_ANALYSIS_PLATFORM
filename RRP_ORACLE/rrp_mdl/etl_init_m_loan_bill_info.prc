CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_BILL_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_BILL_INFO
  *  功能描述：票据出票表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_BILL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220522  梅炜     首次创建
  *             2    20221107  hulj     增加主键校验
  *             5    20221121  xucx     增加字段取票据状态
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_BILL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
 -- V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE :=TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'M_LOAN_BILL_INFO'; --表名
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
  V_STEP_DESC := '插入票据出票表';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_BILL_INFO
  (
        DATA_DT    --数据日期
      ,LGL_REP_ID  --法人编号
      ,ORG_ID  --机构编号
      ,SUBJ_ID  --科目编号
      ,RCPT_ID  --借据号
      ,LOAN_CONT_ID  --贷款合同号
      ,BILL_NO  --票据号码
      ,BILL_BIZ_TYP  --票据业务类型
      ,CUR  --币种
      ,BILL_PAR_AMT  --票面金额
      ,BILL_ISU_DT  --票据出票日期
      ,BILL_EXP_DT  --票据到期日期
      ,DRAWER_ID  --出票人编号
      ,DRAWER_NM  --出票人名称
      ,DRAWER_ACC  --出票人账号
      ,DRAWER_OPEN_BANK_NM  --出票人开户行名称
      ,PAYEE_NM  --收款人名称
      ,PAYEE_ACC  --收款人账号
      ,PAYEE_OPEN_BANK_NM  --收款人开户行名称
      ,BANK_DISC_FLG  --本行贴现标志
      ,BILL_TRA_BKGD  --票据交易背景
      ,COMM_AMT  --手续费金额
      ,OTH_COST_CUR  --其他费用币种
      ,OTH_COST_AMT  --其他费用金额
      ,MRGN_PCT  --保证金比例
      ,MRGN_CUR  --保证金币种
      ,MRGN  --保证金
      ,MRGN_ACC  --保证金账号
      ,BILL_STAT  --票据状态
      ,HDLR_NO  --经办人工号
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      ,DIR_IDY   --投向行业
      ,CURRT_BAL --余额
      ,GRN_CRDT_USEAGE_CL_1104  --绿色授信用途分类1104
      ,STD_PROD_ID              --标准产品编号
      ,BILL_STATUS              --票据状态 add by 20221121 xucx
      ,PAYOFF_DT                --结清日期
      ,DUBIL_BAL                --借据余额
      ,PAYEE_CRDL_NO            --收款人证件号码
      ,ACCT_TYP                 --账户类别
      ,GRN_CRDT_USEAGE_CL       --绿色授信用途分类
    )
    WITH BILL_CENTER_INFO AS (SELECT ROW_NUMBER() OVER(PARTITION BY BILL_NUM ORDER BY  BILL_SRC_CD ASC,BILL_ID ASC ) AS RW,
                              T.*
                             FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T --票据中心信息
                              WHERE DATA_SRC_CD <> '03' --02-票据系统；(03-电子票据 是票交所的，不需报送) --源数据无票据系统数据，需确认
                              AND BILL_STATUS_CD <> '99' --过滤无效的票据
                              AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
     BILL_DISCNT_INFO AS (SELECT ROW_NUMBER() OVER(PARTITION BY BILL_NUM ORDER BY BILL_ID DESC, HXB_ACPT_FLG) AS RW,
                              BILL_NUM,
                              HXB_ACPT_FLG
                               FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T --票据贴现信息
                              WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
   SELECT --针对大表可以写SELECT /*PRALLEL(4)*/
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')      DATA_DT    --数据日期
      ,A.LP_ID                            LGL_REP_ID  --法人编号
      ,B.ACPT_ORG_ID                      ORG_ID  --机构编号    --MODIFY BY MW 20221223 --更改为承兑机构编号
      ,B.SUBJ_ID                          SUBJ_ID  --科目编号
      ,A.DUBIL_ID                         RCPT_ID  --借据编号
      ,A.CONT_ID                          LOAN_CONT_ID  --贷款合同号
      ,A.BILL_NUM                         BILL_NO  --票据号码
      ,'01'                               BILL_BIZ_TYP  --票据业务类型  01:银行承兑汇票
      ,A.CURR_CD                    CUR  --币种
      ,NVL(B.FAC_VAL_AMT,A.DUBIL_AMT)                BILL_PAR_AMT  --票面金额
      ,TO_CHAR(NVL(C.DRAW_DT,B.DRAW_DT), 'YYYYMMDD')                BILL_ISU_DT  --票据出票日期
      ,TO_CHAR(C.EXP_DT, 'YYYYMMDD')                BILL_EXP_DT  --票据到期日期
      --,CASE WHEN A.PAYOFF_DT <= C.EXP_DT THEN TO_CHAR(A.PAYOFF_DT, 'YYYYMMDD') ELSE TO_CHAR(C.EXP_DT, 'YYYYMMDD') END AS BILL_EXP_DT  --票据到期日期  modify by tangan at 20221226  取实际到期日期逻辑，如需要则使用此逻辑
      ,NVL(NVL(C.DRAWER_CUST_ID,C.CUST_ID),A.CUST_ID)           DRAWER_ID  --出票人编号
      ,C.DRAWER_NAME                              DRAWER_NM  --出票人名称
      ,C.DRAWER_ACCT_NUM                          DRAWER_ACC  --出票人账号
      ,C.DRAWER_OPEN_BANK_NAME                    DRAWER_OPEN_BANK_NM  --出票人开户行名称
      ,NVL(C.RECVER_NAME,G.CUST_NAME)                              PAYEE_NM  --收款人名称
      ,NVL(C.RECVER_ACCT_NUM,A.REPAY_NUM)                          PAYEE_ACC  --收款人账号
      ,NVL(C.RECVER_OPEN_BANK_NAME,A.BNFT_BK_NAME)                    PAYEE_OPEN_BANK_NM  --收款人开户行名称
      ,CASE WHEN D.HXB_ACPT_FLG = '1'
            THEN  'Y'
            ELSE  'N'
       END                                    BANK_DISC_FLG  --本行贴现标志
      ,F.LOAN_USAGE_DESCB                      BILL_TRA_BKGD  --票据交易背景
      ,B.COMM_FEE                             COMM_AMT  --手续费金额
      ,NULL                                   OTH_COST_CUR  --其他费用币种
      ,NULL                                   OTH_COST_AMT  --其他费用金额
      ,B.MARGIN_RATIO                         MRGN_PCT  --保证金比例
      ,B.MARGIN_CURR                          MRGN_CUR  --保证金币种
      ,B.MARGIN_AMT                           MRGN  --保证金
      ,A.MARGIN_ACCT_NUM                      MRGN_ACC  --保证金账号
      ,nvl(TTA.TAR_VALUE_CODE,'99')           BILL_STAT  --票据状态
      ,I.CLERK_ID                            HDLR_NO  --经办人工号
      ,'800926'   /*公司银行总部*/             DEPT_LINE  --部门条线
      ,'票据承兑'                             DATA_SRC  --数据来源
      ,A.DIR_INDUS_CD                        DIR_IDY   --投向行业
      ,B.CURRT_BAL                           CURRT_BAL --余额
      ,/*CASE WHEN A.STD_PROD_ID IN (
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
     THEN (CASE WHEN G.GREEN_CRDT_CLS_CD LIKE 'A01%' THEN '0801'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A02%' THEN '0802'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A03%' THEN '0803'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A04%' THEN '0804'
                ELSE '0805' END  )
     ELSE*/ NVL(TTC.TAR_VALUE_CODE,G.GREEN_CRDT_CLS_CD)
     /*END  */    AS GRN_CRDT_USEAGE_CL_1104  --绿色授信用途分类1104
     ,A.STD_PROD_ID                           STD_PROD_ID --标准产品编号
     ,B.BILL_STATUS AS BILL_STATUS              --票据状态 add by 20221121 xucx
     ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') AS  PAYOFF_DT    --结清日期
     ,A.DUBIL_BAL                     AS DUBIL_BAL     --借据余额
     ,COALESCE(T2.ORGNZ_CD,T3.ORGNZ_CD,T21.ORGNZ_CD,T31.ORGNZ_CD,T22.ORGNZ_CD,T32.ORGNZ_CD) AS PAYEE_CRDL_NO --收款人证件号码
     ,'111'                           AS ACCT_TYP      --账户类别
     ,CASE WHEN G.GREEN_CRDT_CUST_FLG = '1'
           THEN DECODE(G.GREEN_CRDT_CLS_CD,'-','',G.GREEN_CRDT_CLS_CD)
      END             AS GRN_CRDT_USEAGE_CL   --绿色授信用途分类
 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息
 INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO B --银承账户信息
         ON A.BILL_NUM = B.BILL_NUM
        AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND B.BILL_NUM <> ' '
/*        AND B.BILL_STATUS IN  ('01','00') --已承兑*/
 LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO CONT
      ON A.CONT_ID = CONT.CONT_ID
      AND CONT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  left JOIN BILL_CENTER_INFO C
         ON A.BILL_NUM = C.BILL_NUM
        AND C.RW = 1
  LEFT JOIN BILL_DISCNT_INFO D
         ON  D.BILL_NUM = A.BILL_NUM
        AND D.RW = 1
  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G--对公客户基本信息
         ON A.CUST_ID = G.CUST_ID
        AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO F --对公贷款合同信息
         ON A.CONT_ID = F.CONT_ID
        AND F.STD_PROD_ID IN ('204010100001','204010200001','601010100001')
        AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN  (SELECT TELLER_ID, CLERK_ID
                   FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
                  WHERE TRIM(TELLER_ID) <> ' '
                    AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') )I --行员信息  --行员信息表
         ON A.OPER_TELLER_ID = I.TELLER_ID
  LEFT JOIN (SELECT T.BILL_NUM, T.REQER_ACCT_NUM AS ACCT_NUM,REPLACE(T.REQER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.REQER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.REQER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.REQER_ORGNZ_CD),'-','') IS NOT NULL) T2
        ON  C.BILL_NUM = T2.BILL_NUM AND C.RECVER_ACCT_NUM = T2.ACCT_NUM AND T2.RN = 1
  LEFT JOIN (SELECT T.BILL_NUM, T.RECVER_ACCT_NUM AS ACCT_NUM,REPLACE(T.RECVER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM,T.RECVER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.RECVER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.RECVER_ORGNZ_CD),'-','') IS NOT NULL)T3
        ON  C.BILL_NUM = T3.BILL_NUM AND C.RECVER_ACCT_NUM = T3.ACCT_NUM AND T3.RN = 1
  LEFT JOIN (SELECT T.BILL_NUM, T.REQER_ACCT_NUM AS ACCT_NUM,REPLACE(T.REQER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.REQER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.REQER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.REQER_ORGNZ_CD),'-','') IS NOT NULL) T21
        ON   C.RECVER_ACCT_NUM = T21.ACCT_NUM AND T21.RN = 1
  LEFT JOIN (SELECT T.BILL_NUM, T.RECVER_ACCT_NUM AS ACCT_NUM,REPLACE(T.RECVER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.RECVER_ACCT_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.RECVER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.RECVER_ORGNZ_CD),'-','') IS NOT NULL)T31
        ON   C.RECVER_ACCT_NUM = T31.ACCT_NUM AND T31.RN = 1
  LEFT JOIN (SELECT T.BILL_NUM, T.REQER_ACCT_NUM AS ACCT_NUM,REPLACE(T.REQER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.REQER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.REQER_ORGNZ_CD),'-','') IS NOT NULL) T22
        ON   C.BILL_NUM = T22.BILL_NUM AND T22.RN = 1
  LEFT JOIN (SELECT T.BILL_NUM, T.RECVER_ACCT_NUM AS ACCT_NUM,REPLACE(T.RECVER_ORGNZ_CD,'-','') AS ORGNZ_CD
                       ,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY DECODE(T.BILL_STATUS_CD,'E010_02_20',1,99) ASC) AS RN
                  FROM O_IML_EVT_ELEC_BILL_TRAN_FLOW T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.RECVER_ACCT_NUM != '0'
                   AND REPLACE(TRIM(T.RECVER_ORGNZ_CD),'-','') IS NOT NULL)T32
        ON   C.BILL_NUM = T32.BILL_NUM AND T32.RN = 1
  LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(票据状态)
         ON TTA.SRC_VALUE_CODE = (CASE WHEN C.BILL_STATUS_CD = '000000' THEN 'S21'
                                  WHEN C.BILL_STATUS_CD = '000002' THEN '9903' ELSE C.BILL_STATUS_CD END)
        AND (TTA.SRC_CLASS_CODE = 'CD1487'
         /*OR TTA.SRC_CLASS_CODE = 'CD1489'*/)
        AND TTA.TAR_CLASS_CODE = 'D0125'
        AND TTA.MOD_FLG = 'MDM'            --监管集市明细层
/*  LEFT JOIN RRP_MDL.CODE_MAP TTB  --票据种类转码
         ON TTB.SRC_VALUE_CODE = C.BILL_TYPE_CD
        AND TTB.SRC_CLASS_CODE = 'CD1384'
        AND TTB.TAR_CLASS_CODE = 'D0039'
        AND TTB.MOD_FLG = 'MDM'  */          --监管集市明细层
  LEFT JOIN CODE_MAP TTC  --绿色贷款用途转码
       ON TTC.SRC_VALUE_CODE = G.GREEN_CRDT_CLS_CD
       AND TTC.SRC_CLASS_CODE = 'CD2390'
       AND TTC.TAR_CLASS_CODE = 'D0142'
       AND TTC.MOD_FLG = 'MDM'
     WHERE A.STD_PROD_ID IN (/*'204010100001','204010200001',*/'601010100001')  -- 601010100001  银承承兑 20221121 mw
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.BILL_NUM IS NOT NULL;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP AS (
    SELECT DATA_DT, BILL_NO,COUNT(1)
      FROM M_LOAN_BILL_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, BILL_NO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP ;

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

  END ETL_INIT_M_LOAN_BILL_INFO;
/

