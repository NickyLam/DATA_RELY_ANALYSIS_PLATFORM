CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_GREEN_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_GREEN_SUB
  *  功能描述：监管集市以借据为粒度，接入绿色贷款有关信息。
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_LOAN_ACCT_INFO   --对公贷款账户信息
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息表
  *            ICL.CMM_CORP_LOAN_CONT_INFO   --对公贷款合同信息表
  *            ICL.CMM_COL_GUAR_CONT_RELA    --押品与担保合同关系
  *            ICL.CMM_COL_INFO              --押品信息
  *            ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            ICL.CMM_BILL_DISCNT_INFO      -- 票据贴现信息
  *            IOL.IFRS_VAL_RPT_TRADE        --估值报告表
  *  目标表：  M_LOAN_GREEN_SUB  --绿色贷款子表
  *
  *  配置表：  IML.REF_PUB_CD       --公共代码表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj      增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_GREEN_SUB'; -- 绿色贷款子表
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_GREEN_SUB'; --表名
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
  V_STEP := 2;
  V_STEP_DESC := '插入绿色贷款子表-对公部分';
  V_STARTTIME := SYSDATE;
  /*****************对公部分******************/
  INSERT /*+APPEND */INTO M_LOAN_GREEN_SUB NOLOGGING
  (
   DATA_DT                     --数据日期
   ,LGL_REP_ID                  --法人编号
   ,ORG_ID                      --机构编号
   ,RCPT_ID                     --借据编号
   ,CUST_ID                     --客户编号
   ,CUR                         --币种
   ,LOAN_BAL                    --贷款余额
   ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
   ,GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
   ,GRN_TRA_ULYG_CL             --绿色贸易标的物分类
   ,CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
   ,ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
   ,DEPT_LINE                   --部门条线
   ,DATA_SRC                    --数据来源
   ,ACCT_TYP                    --账户类型
   )
   SELECT DISTINCT
    V_P_DATE                     AS DATA_DT                     --数据日期
    ,B.LP_ID                     AS LGL_REP_ID                  --法人编号
    ,B.ACCT_INSTIT_ID            AS ORG_ID                      --机构编号
    ,B.DUBIL_NUM                 AS RCPT_ID                     --借据编号
    ,B.CUST_ID                   AS CUST_ID                     --客户号
    ,NVL(B.CURR_CD, 'CNY')       AS CUR                         --币种
    ,CASE WHEN B.WRT_OFF_FLG = '1'
               THEN 0  --MODIFY BY ZM 20201102 核销贷款余额默认为0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN
     CASE WHEN B.SUBJ_ID LIKE '1313%'   -- 特殊处理
         THEN NVL(B.OVDUE_PRIC_BAL, 0) + NVL(B.IDLE_PRIC, 0) + NVL(B.BAD_DEBT_PRIC, 0)
         WHEN B.SUBJ_ID IN ('300702', '1303029901', '1303029902')   -- 特殊处理
         THEN NVL(B.PRIC_BAL,0) - NVL(B.WRT_OFF_PRIC, 0)                     --正常本金剔除核销本金
         WHEN A.BUS_BREED_ID IN('1060080') AND B.SUBJ_ID LIKE '131501%'
         THEN ( NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0) + NVL(round(O.N_PV_VARIATION, 2),0) - NVL(B.IN_BS_INT, 0) )  -- 国内信用证福费廷剔除公允价值变动、利息调整
         WHEN A.BUS_BREED_ID IN('1060080') AND B.SUBJ_ID LIKE '131502%'
         THEN ( NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0) + NVL(round(O.N_PV_VARIATION, 2),0) - NVL(B.IN_BS_INT, 0) ) --国际信用证福费廷剔除利息调整
         WHEN A.BUS_BREED_ID IN('203020112','203020210','4030010020')                                       --加上3个福费廷业务
         THEN ( NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0) + NVL(round(O.N_PV_VARIATION, 2),0) - NVL(B.IN_BS_INT, 0) )
         ELSE NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0)
         END
         END                    AS LOAN_BAL                    --贷款余额
     , DECODE(G.GREEN_CRDT_CLS_CD,'-','',G.GREEN_CRDT_CLS_CD)  --从 S_ICL_CMM_CORP_CUST_BASIC_INFO 取值
                                                            AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
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
     THEN (CASE WHEN G.GREEN_CRDT_CLS_CD LIKE 'A01%' THEN '0801'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A02%' THEN '0802'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A03%' THEN '0803'
                WHEN G.GREEN_CRDT_CLS_CD LIKE 'A04%' THEN '0804'
                ELSE '0805' END  )
     ELSE NVL(TTA.TAR_VALUE_CODE,G.GREEN_CRDT_CLS_CD)
     END
                     AS GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
     ,NULL                      AS GRN_TRA_ULYG_CL             --绿色贸易标的物分类
     /*,CASE WHEN D3.COL_TYPE_ID IN(D3.) THEN 'Y' ELSE 'N' END
      END                       AS CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
     ,CASE WHEN D3.COL_TYPE_ID IN(D3.) THEN 'Y' ELSE 'N' END
      END                       AS ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志*/--目前数仓没有这两个标志,待数仓加码值
     ,'N'                       AS CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
     ,'N'                       AS ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
     ,NULL                      AS DEPT_LINE                   --部门条线
     ,'对公贷款部分'             AS DATA_SRC                  	--数据来源
     ,CASE WHEN A.STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002')
           THEN '020499' --福费廷
           WHEN A.STD_PROD_ID LIKE '20303%'
           THEN '020402' --国内贸易融资
           ELSE TTB.TAR_VALUE_CODE
      END                       AS ACCT_TYP                     --账户类型
    FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B    --对公贷款账户信息
    INNER JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表 --MODIFY BY WZC 以账户为主表关联 20200528
      ON A.DUBIL_ID = B.DUBIL_NUM
     AND A.ETL_DT = B.ETL_DT
    LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表  ADD BY ZM 20200428
      ON A.CONT_ID = C.CONT_ID
     AND A.ETL_DT = C.ETL_DT
  LEFT JOIN (SELECT /*+USE_HASH(C,D)*/C1.COL_ID,C1.ETL_DT,C1.GUAR_CONT_ID,MAX(D1.CUST_ID) AS CUST_ID
        FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA C1  --押品与担保合同关系
       INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT D1
          ON D1.GUAR_CONT_ID=C1.GUAR_CONT_ID
         AND D1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY C1.COL_ID,C1.ETL_DT,C1.GUAR_CONT_ID) G2 --押品与担保合同关系
     ON C.CONT_ID=G2.GUAR_CONT_ID
     AND C.ETL_DT=G2.ETL_DT
   LEFT JOIN O_ICL_CMM_COL_INFO D3 --押品信息
     ON G2.COL_ID=D3.COL_ID
     AND G2.ETL_DT=D3.ETL_DT
  LEFT JOIN O_IOL_IFRS_VAL_RPT_TRADE O  --估值报告表  关联估值表取 国内信用证福费廷 公允价值变动
      ON B.DUBIL_NUM = O.V_TRADE_NO
            --处理生产问题排查发现131502福费廷这部分没做公允价值变动的
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
    ON A.CUST_ID = G.CUST_ID
    AND A.ETL_DT = G.ETL_DT
  LEFT JOIN CODE_MAP TTA  --绿色贷款用途转码
       ON TTA.SRC_VALUE_CODE = G.GREEN_CRDT_CLS_CD
       AND TTA.SRC_CLASS_CODE = 'CD2390'
       AND TTA.TAR_CLASS_CODE = 'D0142'
       AND TTA.MOD_FLG = 'MDM'
  LEFT JOIN CODE_MAP TTB --账户类别转码
       ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
       AND TTB.SRC_CLASS_CODE = 'STD0002'
       AND TTB.TAR_CLASS_CODE = 'T0001'
       AND TTB.MOD_FLG = 'MDM'
  WHERE G.GREEN_CRDT_CUST_FLG = '1'
        AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入绿色贷款子表-零售部分';
  V_STARTTIME := SYSDATE;
  /*****************零售部分******************/
  INSERT /*+APPEND */INTO M_LOAN_GREEN_SUB NOLOGGING
  (
   DATA_DT                     --数据日期
   ,LGL_REP_ID                  --法人编号
   ,ORG_ID                      --机构编号
   ,RCPT_ID                     --借据编号
   ,CUST_ID                     --客户编号
   ,CUR                         --币种
   ,LOAN_BAL                    --贷款余额
   ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
   ,GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
   ,GRN_TRA_ULYG_CL             --绿色贸易标的物分类
   ,CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
   ,ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
   ,DEPT_LINE                   --部门条线
   ,DATA_SRC                    --数据来源
   ,ACCT_TYP                    --账户类型
   )
   SELECT DISTINCT
    V_P_DATE                               DATA_DT                     --数据日期
   ,T1.LP_ID                               LGL_REP_ID                  --法人编号
   ,T1.ACCT_INSTIT_ID                      ORG_ID                      --机构编号
   ,T1.DUBIL_NUM                           RCPT_ID                     --借据编号
   ,T1.CUST_ID                             CUST_ID                     --客户编号
   ,T1.CURR_CD                             CUR                         --币种
   ,CASE WHEN T1.WRT_OFF_FLG = '1'
         THEN 0
         ELSE T1.PRIC_BAL
    END                                    LOAN_BAL                    --贷款余额
   ,DECODE(T3.GREEN_LOAN_USAGE_CD,'-','',T3.GREEN_LOAN_USAGE_CD)
                                           GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
   ,NVL(COD2.TAR_VALUE_CODE,T3.GREEN_LOAN_USAGE_CD)
                                           GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
   ,''                                     GRN_TRA_ULYG_CL             --绿色贸易标的物分类
   ,'N'                                    CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
   ,'N'                                    ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
   ,NULL                                   DEPT_LINE                   --部门条线
   ,'零售贷款'                              DATA_SRC                    --数据来源
   ,CASE WHEN COD1.TAR_VALUE_CODE LIKE '0103%' AND T3.BORW_USAGE_TYPE_CD = '100101'
         THEN '010301' --个人汽车贷款
         WHEN COD1.TAR_VALUE_CODE LIKE '0103%' AND T3.BORW_USAGE_TYPE_CD = '100102'
         THEN '010302' --房屋装修贷款
         WHEN COD1.TAR_VALUE_CODE LIKE '0103%' AND T3.BORW_USAGE_TYPE_CD IN ( '100109')
         THEN '010301' --个人汽车贷款
         WHEN COD1.TAR_VALUE_CODE LIKE '0102%' AND T3.BORW_USAGE_TYPE_CD IN ( '100201')
         THEN '010202' --商用车贷款
         WHEN T1.STD_PROD_ID IN ('201030200001','201030200002','201030200003')
         THEN '010101' --个人住房按揭商业贷款
         WHEN  T1.STD_PROD_ID IN ('201030200001','201030200002')
                AND T3.BORW_USAGE_TYPE_CD <> '100301'
         THEN '010101'              --个人中长期住房贷款(个人住房按揭商业贷款)
         WHEN  T1.STD_PROD_ID IN ('201030100001','201030100002')
              AND T3.BORW_USAGE_TYPE_CD = '100301'
         THEN '010201'              --个人中长期住房贷款(商业用房贷款)
              ELSE NVL(COD1.TAR_VALUE_CODE,T1.STD_PROD_ID)
         END                               ACCT_TYP                    --账户类型
   FROM  O_ICL_CMM_RETL_LOAN_ACCT_INFO           T1 --零售贷款账户信息
   LEFT JOIN O_ICL_CMM_RETL_LOAN_DUBIL_INFO      T2 --零售贷款借据信息
     ON T1.DUBIL_NUM = T2.DUBIL_ID
    AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN O_ICL_CMM_RETL_LOAN_CONT_INFO       T3 --零售贷款合同信息
     ON T1.CONT_ID = T3.CONT_ID
    AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN CODE_MAP                            COD1 --账户类型转码
     ON COD1.SRC_VALUE_CODE = T1.STD_PROD_ID
    AND COD1.SRC_CLASS_CODE = 'STD0001'
    AND COD1.TAR_CLASS_CODE = 'STD0002'
    AND COD1.MOD_FLG = 'MDM'
   LEFT JOIN CODE_MAP                            COD2 --绿色贷款用途转码
     ON T3.GREEN_LOAN_USAGE_CD = COD2.SRC_VALUE_CODE
    AND COD2.SRC_CLASS_CODE = 'CD2390'
    AND COD2.TAR_CLASS_CODE = 'D0142'
    AND COD2.MOD_FLG = 'MDM'
  WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(T3.GREEN_CRDT_FLG) IS NOT NULL
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := 4;
  V_STEP_DESC := '插入绿色贷款子表-贴现部分';
  V_STARTTIME := SYSDATE;
  /*****************贴现部分******************/
  INSERT /*+APPEND */INTO RRP_MDL.M_LOAN_GREEN_SUB NOLOGGING
  (
    DATA_DT                     --数据日期
   ,LGL_REP_ID                  --法人编号
   ,ORG_ID                      --机构编号
   ,RCPT_ID                     --借据编号
   ,CUST_ID                     --客户编号
   ,CUR                         --币种
   ,LOAN_BAL                    --贷款余额
   ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
   ,GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
   ,GRN_TRA_ULYG_CL             --绿色贸易标的物分类
   ,CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
   ,ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
   ,DEPT_LINE                   --部门条线
   ,DATA_SRC                    --数据来源
   ,ACCT_TYP                    --账户类型
   )
   SELECT  DISTINCT
   V_P_DATE                                   AS DATA_DT                     --数据日期
  ,B1.LP_ID                                   AS LGL_REP_ID                  --法人编号
  ,B1.ENTER_ACCT_ORG_ID                       AS ORG_ID                      --机构编号
  ,A.DUBIL_ID                                 AS RCPT_ID                     --借据编号
  ,COALESCE(C.CUST_ID,A.CUST_ID,B1.CUST_ID)   AS CUST_ID                     --客户号
  ,CASE WHEN B1.CURR_CD IS NULL
               THEN 'CNY'
               ELSE B1.CURR_CD
    END                                       AS CUR                         --币种
  , CASE WHEN A.PAYOFF_DT >= TO_DATE(I_P_DATE, 'YYYYMMDD')
               THEN (NVL(B1.CURRT_BAL, 0) - NVL(B1.INT_ADJ_BAL, 0) + NVL(round(O.N_PV_VARIATION, 2),0)) --modify hyf 20220905 公允价值四舍五入取小数点后两位再加减
               ELSE 0
    END                                       AS LOAN_BAL                    --贷款余额
            --贷款余额 --经数仓翟若平确认，到期的贴现票据也存在净值大于0（挂账）的情况，报送应为0，因此在字段加工中默认为0
  ,CASE WHEN I.GREEN_CRDT_CUST_FLG = '1'
               THEN DECODE(I.GREEN_CRDT_CLS_CD,'-','',I.GREEN_CRDT_CLS_CD)
    END                                       AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
  ,CASE WHEN I.GREEN_CRDT_CUST_FLG = '1'
               THEN DECODE(I.GREEN_CRDT_CLS_CD,'-','',I.GREEN_CRDT_CLS_CD)
    END                                       AS GRN_LOAN_USEAGE_CL_1104     --绿色贷款用途分类1104
  ,NULL                                       AS GRN_TRA_ULYG_CL             --绿色贸易标的物分类
   /*,CASE WHEN D3.COL_TYPE_ID IN(D3.) THEN 'Y' ELSE 'N' END
      END                       AS CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
   ,CASE WHEN D3.COL_TYPE_ID IN(D3.) THEN 'Y' ELSE 'N' END
      END                       AS ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志*/--目前数仓没有这两个标志,待数仓加码值
  ,'N'                                        AS CER_MTG_LOAN_FLG            --以碳排放权为抵押的贷款标志
  ,'N'                                        AS ER_MTG_LOAN_FLG             --以环境权益为抵押的贷款标志
  ,NULL                                       AS DEPT_LINE                   --部门条线--票据业务事业部
  ,'票据贴现部分'                              AS DATA_SRC                    --数据来源
  ,TTA.TAR_VALUE_CODE                         AS ACCT_TYP                    --账户类型
  FROM O_ICL_CMM_BILL_DISCNT_INFO B1  -- 票据贴现信息
   LEFT JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO A  -- 对公贷款借据信息
      ON A.BILL_NUM = B1.BILL_NUM
     AND A.STD_PROD_ID LIKE '2040%'
     AND A.ETL_DT = B1.ETL_DT
   LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C  -- 对公贷款合同信息表
      ON A.CONT_ID = C.CONT_ID
     AND (C.CRDT_TYPE_CD = '02' OR C.CRDT_TYPE_CD IS NULL)
     AND A.ETL_DT = C.ETL_DT
  LEFT JOIN (SELECT /*+USE_HASH(C,D)*/C1.COL_ID,C1.ETL_DT,C1.GUAR_CONT_ID,MAX(D1.CUST_ID) AS CUST_ID
        FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA C1  --押品与担保合同关系
       INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT D1
          ON D1.GUAR_CONT_ID=C1.GUAR_CONT_ID
         AND D1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY C1.COL_ID,C1.ETL_DT,C1.GUAR_CONT_ID) G2 --押品与担保合同关系
     ON C.CONT_ID=G2.GUAR_CONT_ID
     AND C.ETL_DT=G2.ETL_DT
   LEFT JOIN O_ICL_CMM_COL_INFO D3 --押品信息
     ON G2.COL_ID=D3.COL_ID
     AND G2.ETL_DT=D3.ETL_DT
   LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO I  -- --注释绿色贷款客户名单补录表，改从 S_ICL_CMM_CORP_CUST_BASIC_INFO 取绿色信贷分类代码  MODIFY BY LUZM 20211230
       ON I.CUST_ID = A.CUST_ID
      AND I.ETL_DT = A.ETL_DT
   LEFT JOIN O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表 ADD BY ZM 20210228 关联估值表取 贴现 公允价值变动
       ON O.V_TRADE_NO = B1.BILL_NUM
      AND O.ETL_DT = C.ETL_DT
      AND O.V_BUSINESSTYPE = A.STD_PROD_ID
   LEFT JOIN CODE_MAP      TTA        --账户类别转码
        ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
        AND TTA.SRC_CLASS_CODE = 'STD0002'
        AND TTA.TAR_CLASS_CODE = 'T0001'
   WHERE B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --AND B1.DISCNT_STATUS_CD NOT IN ('012','001')
      --AND B1.EXP_DT > B1.ETL_DT  --MODIFY BY ZM 20201214 经数仓翟若平确认，到期的贴现票据也存在净值大于0（挂账）的情况，报送应为0，因此在字段加工中默认为0
      AND B1.ENTRY_STATUS_CD = '03'
      AND A.DUBIL_ID IS NOT NULL
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := 5;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_GREEN_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
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
   V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_GREEN_SUB;
/

