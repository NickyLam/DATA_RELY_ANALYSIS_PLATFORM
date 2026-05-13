CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_002_CREDIT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_002_CREDIT
  *  功能描述：补录表-对公-授信基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL_CMM_BILL_DISCNT_INFO      -- 票据贴现信息
  *            ICL.CMM_CORP_LOAN_CONT_INFO   --对公贷款合同信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款借据信息表
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            ICL.CMM_BILL_CENTER_INFO      --票据中心信息
  *  目标表：  ADD_DG_002_CREDIT  --授信基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221114  hulj     首次创建。
  *   2    20230426  Liuyu    删除当天新增数据,客户补录表不接收新增客户条数补录
  *   3    20230509	 liuyu	  删除关联存款账户表
  *   4    20230511  Liuyu    按照黄娅娅邮件调整补录下发口径，以下调整仅限授信补录表下发逻辑：
  *                           只取对公客户10001 且有效，剔除其他额度类型；不考虑转授信因素
                              只要公司客户 综合 专项 低风险 保贴 四个产品
                              已用额度取额度对应项下借据放款金额之和
  *   5    20230526  mw       业务黄娅娅要求，800958866机构放到891机构数字银行总部
  *   6    20230530  liuyu    调整继承上天数据逻辑
  *   7    20230530  liuyu    剔除MIGT这类合同 A.CONT_ID NOT LIKE 'MIGT%'
  *   8    20230530  liuyu    调整取已用额度的逻辑
  *   9    20230616  mw       调整数据范围筛选逻辑
  *   10   20230718  mw       处理放款金额增加保函、信用证、贴现、转贴、银承口径
  *   11   20231101  HYF      按业务黄娅娅要求，账务机构编号优先取系统出数，再取补录表，再取上一天
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                         -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                               -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100)  := 'ETL_ADD_DG_002_CREDIT';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_002_CREDIT';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                               -- 分区名称
  V_P_DATE      VARCHAR2(8);                                 -- 跑批数据日期
  V_STARTTIME   DATE;                                        -- 处理开始时间
  V_ENDTIME     DATE;                                        -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                         -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                               -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                -- 来源系统

BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_002_CREDIT_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_002_CREDIT';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP1_ADD_DG_002_CREDIT';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_002_CREDIT_L
   (
    DATA_DATE      --01 数据日期
   ,ACCT_ORG_NUM   --02 账务机构编号
   ,KHWYM          --06 客户唯一码
   ,KHMC           --07 客户名称
   ,CNYE           --08 承诺余额（元）
   ,SYS_SOURCE     --09 来源系统
   ,ZSXED          --10 总授信额度
   ,YYED           --11 已用额度
   )
  SELECT /*+ PARALLEL*/
         V_P_DATE       --01 数据日期
        ,ACCT_ORG_NUM   --02 账务机构编号
        ,KHWYM          --06 客户唯一码
        ,KHMC           --07 客户名称
        ,CNYE           --08 承诺余额（元）
        ,SYS_SOURCE     --09 来源系统
        ,ZSXED          --10 总授信额度
        ,YYED           --11 已用额度
    FROM ( SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
            FROM ADD_DG_002_CREDIT_ETL A
           WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_002_CREDIT_ETL) ) T
   WHERE T.RN = 1
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 3;
   V_STEP_DESC := '备份当期数据-从ADD表继承';
   V_STARTTIME := SYSDATE;

   INSERT INTO ADD_DG_002_CREDIT_L
     (
      DATA_DATE      --01 数据日期
     ,ACCT_ORG_NUM   --02 账务机构编号
     ,KHWYM          --06 客户唯一码
     ,KHMC           --07 客户名称
     ,CNYE           --08 承诺余额（元）
     ,SYS_SOURCE     --09 来源系统
     ,ZSXED          --10 总授信额度
     ,YYED           --11 已用额度
     )
    SELECT /*+ PARALLEL*/
           V_P_DATE       --01 数据日期
          ,ACCT_ORG_NUM   --02 账务机构编号
          ,KHWYM          --06 客户唯一码
          ,KHMC           --07 客户名称
          ,CNYE           --08 承诺余额（元）
          ,SYS_SOURCE     --09 来源系统
          ,ZSXED          --10 总授信额度
          ,YYED           --11 已用额度
      FROM RRP_MDL.ADD_DG_002_CREDIT T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_002_CREDIT_L T2
                        WHERE T1.KHWYM = T2.KHWYM
                          AND T2.DATA_DATE = V_P_DATE) ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 4;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 5;
  V_STEP_DESC := '处理数据-处理有效合同-对公贷款';
  V_STARTTIME := SYSDATE;

 /*********************处理有效合同-对公贷款***********************/
  INSERT /*+ APPEND PARALLEL */ INTO TMP1_ADD_DG_002_CREDIT
     (CONT_ID,      --额度合同
      SYS_SOURCE  --数据来源
      )
     SELECT DISTINCT 
            TMP.LMT_CONT_ID    AS CONT_ID
           ,'对公贷款'         AS SYS_SOURCE
       FROM( SELECT C.LMT_CONT_ID -- 额度合同
                   ,A.CONT_ID -- 业务合同
                   ,A.CUST_ID -- 借据归属客户号
                   ,C.CUST_ID AS LMT_CUST_ID -- 额度客户号
                   ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
                         WHEN B.WRT_OFF_FLG <> '1' 
                         THEN CASE WHEN B.SUBJ_ID LIKE '1313%'
                                   THEN NVL(B.OVDUE_PRIC_BAL, 0) + NVL(B.IDLE_PRIC, 0) + NVL(B.BAD_DEBT_PRIC, 0)
                                   ELSE NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0)
                               END
                     END      AS LOAN_BAL             --贷款余额
                   ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
                         WHEN B.WRT_OFF_FLG <> '1' 
                         THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                                   WHEN B.SUBJ_ID IN ('30070102') THEN 0
                                   WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%') 
                                   THEN NVL(B.IN_BS_INT, 0)
                                   WHEN A.STD_PROD_ID IN('203020300002','203030600002','203020300001','203030600001') --福费廷
                                   THEN NVL(B.IN_BS_INT, 0)
                                   ELSE 0
                               END
                     END       AS INT_ADJ              --利息调整
                   ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
                         WHEN B.WRT_OFF_FLG <> '1' 
                         THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                                   WHEN B.SUBJ_ID IN ('30070102') THEN 0
                                   WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%') 
                                   THEN NVL(AA.N_PV_VARIATION, 0)
                                   WHEN A.STD_PROD_ID IN('203030600002','203020300002','203020300001','203030600001')
                                   THEN NVL(AA.N_PV_VARIATION, 0)
                                   ELSE 0
                              END
                    END       AS FAIR_VAL_CHG         --公允价值变动
               FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息表
              INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B     --对公贷款账户信息表
                 ON B.DUBIL_NUM = A.DUBIL_ID
                AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
                 ON C.CONT_ID = A.CONT_ID
                AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表 取额度合同
                 ON D.CONT_ID = C.LMT_CONT_ID
                AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE  AA    --估值报告表
                 ON A.DUBIL_ID = AA.V_TRADE_NO
                AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              WHERE (A.STD_PROD_ID LIKE '2%'
                  OR A.STD_PROD_ID LIKE '6020%'
                  OR A.STD_PROD_ID IS NULL
                  OR A.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002')
                  OR C.STD_PROD_ID LIKE '2%'
                  OR C.STD_PROD_ID LIKE '6020%'
                  OR C.STD_PROD_ID IS NULL
                  OR C.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002'))
              AND A.DUBIL_ID IS NOT NULL
              AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TMP
     WHERE NVL(TMP.LOAN_BAL,0)+NVL(TMP.INT_ADJ,0)-NVL(TMP.FAIR_VAL_CHG,0) <> 0 ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************处理有效合同-贴现****************/
  V_STEP      := 6;
  V_STEP_DESC := '处理数据-处理有效合同-贴现';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP1_ADD_DG_002_CREDIT 
  ( CONT_ID
   ,SYS_SOURCE
   )
  SELECT DISTINCT 
         TMP.LMT_CONT_ID
        ,'贴现' AS SYS_SOURCE
    FROM (SELECT C.LMT_CONT_ID -- 额度合同
                ,B.CONT_ID     -- 业务合同
                ,B.CUST_ID     -- 借据归属客户号
                ,CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
                      THEN ROUND(NVL(A.CURRT_BAL, 0),2)
                     ELSE 0
                 END         AS LOAN_BAL            --贷款余额
                ,NVL(A.INT_ADJ_BAL, 0)    AS INT_ADJ        --利息调整
                ,NVL(O.N_PV_VARIATION, 0) AS FAIR_VAL_CHG   --公允价值变动
          FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
         INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
            ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
           AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
           AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
           AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
            ON C.CONT_ID = B.CONT_ID
           AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表 取额度合同
            ON D.CONT_ID = C.LMT_CONT_ID
           AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
            ON O.V_TRADE_NO = A.BILL_NUM
           AND O.V_BUSINESSTYPE = B.STD_PROD_ID
           AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         WHERE A.DISCNT_STATUS_CD IN ('06')
           AND A.ENTRY_STATUS_CD = '03'
           AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TMP
    WHERE NVL(TMP.LOAN_BAL,0)+NVL(TMP.INT_ADJ,0)-NVL(TMP.FAIR_VAL_CHG,0) <> 0 ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************处理有效合同-买断式转贴现****************/
  V_STEP      := 7;
  V_STEP_DESC := '处理数据-处理有效合同-买断式转贴现';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP1_ADD_DG_002_CREDIT 
  (  CONT_ID
    ,SYS_SOURCE
  )
     SELECT DISTINCT 
            LMT_CONT_ID
            ,'买断式转贴现' AS SYS_SOURCE
       FROM (SELECT /*+PARALLEL*/
                    E.LMT_CONT_ID
                   ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
                         THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
                         WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                         THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
                         ELSE 0
                     END         AS LOAN_BAL             --贷款余额
                   ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
                         THEN NVL(A.INT_ADJ_BAL, 0)
                         WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                         THEN NVL(A.INT_ADJ_BAL, 0)
                         ELSE 0
                     END         AS INT_ADJ              --利息调整
                   ,CASE WHEN V_P_DATE <= '20210630' AND NVL(A.CURRT_BAL, 0) = 0 AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0
                         WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = 0
                         THEN NVL(O.N_PV_VARIATION, 0)
                         WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                         THEN NVL(O.N_PV_VARIATION, 0)
                         ELSE 0
                     END         AS FAIR_VAL_CHG         --公允价值变动
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
                INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
                   ON B.BILL_ID = A.BILL_ID
                  AND B.STD_PROD_ID IN ('204010100001','204010100002')
                  AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
                   ON D.CONT_ID = B.CONT_ID
                  AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'
                  AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
                   ON J.BILL_ID = A.BILL_ID
                  AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E  --对公贷款合同信息表
                   ON E.CONT_ID = D.LMT_CONT_ID
                  AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表 关联估值表取 转贴现 公允价值变动
                   ON O.V_TRADE_NO = B.BILL_NUM
                  AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE A.TRAN_DIR_CD = '01'  --买入
                  AND A.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
                  AND A.ENTRY_STATUS_CD = '03'  --记账成功
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T
    WHERE NVL(T.LOAN_BAL,0)+NVL(T.INT_ADJ,0)-NVL(T.FAIR_VAL_CHG,0) <> 0 
      AND NOT EXISTS (SELECT 1 FROM TMP1_ADD_DG_002_CREDIT TT WHERE TT.CONT_ID = T.LMT_CONT_ID ) ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************处理有效合同-表外信用证****************/
  V_STEP      := 8;
  V_STEP_DESC := '处理数据-处理有效合同-表外信用证';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP1_ADD_DG_002_CREDIT 
  (   CONT_ID
     ,SYS_SOURCE
   )
     SELECT DISTINCT 
            LMT_CONT_ID
           ,'表外信用证' AS SYS_SOURCE
       FROM (SELECT /*+PARALLEL*/
                    E.LMT_CONT_ID
                   ,B.NOMAL_PRIC AS LOAN_BAL             --贷款余额
                   ,0            AS INT_ADJ              --利息调整
                   ,0            AS FAIR_VAL_CHG         --公允价值变动
               FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
              INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
                 ON B.CONT_ID = E.CONT_ID
                AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              INNER JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
                 ON A.LC_ID = B.BILL_NUM
                AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              WHERE B.STD_PROD_ID IN ('601020100001','601020100002','603010100002','601020200001','601020200002','603010300002') --信用证
                AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T
      WHERE NVL(T.LOAN_BAL,0)+NVL(T.INT_ADJ,0)-NVL(T.FAIR_VAL_CHG,0) <> 0
        AND NOT EXISTS (SELECT 1 FROM TMP1_ADD_DG_002_CREDIT TT WHERE TT.CONT_ID = T.LMT_CONT_ID ) ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   /**************处理有效合同-表外保函****************/
  V_STEP      := 9;
  V_STEP_DESC := '处理有效合同-表外保函';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP1_ADD_DG_002_CREDIT 
    (  CONT_ID
      ,SYS_SOURCE
    )
     SELECT DISTINCT 
            LMT_CONT_ID
           ,'表外保函' AS SYS_SOURCE
       FROM (SELECT /*+PARALLEL*/
                    E.LMT_CONT_ID
                    ,A.CURRT_BAL AS LOAN_BAL             --贷款余额
                    ,0           AS INT_ADJ              --利息调整
                    ,0           AS FAIR_VAL_CHG         --公允价值变动
               FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
              INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
                 ON B.CONT_ID = E.CONT_ID
                AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              INNER JOIN RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息
                 ON A.LOG_CONT_ID = B.DUBIL_ID
                AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              WHERE SUBSTR(B.STD_PROD_ID,0,7) IN ('6010301','6010302','6010303','6010304') -- MOD BY LIUYU 调整保函范围
                AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T
     WHERE NVL(T.LOAN_BAL,0)+NVL(T.INT_ADJ,0)-NVL(T.FAIR_VAL_CHG,0) <> 0
       AND NOT EXISTS (SELECT 1 FROM TMP1_ADD_DG_002_CREDIT TT WHERE TT.CONT_ID = T.LMT_CONT_ID );

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    /**************处理有效合同-表外银承****************/
  V_STEP      := 10;
  V_STEP_DESC := '处理有效合同-表外银承';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP1_ADD_DG_002_CREDIT 
  (   CONT_ID
     ,SYS_SOURCE
   )
     SELECT DISTINCT 
             LMT_CONT_ID
            ,'表外银承' AS SYS_SOURCE
       FROM (SELECT /*+PARALLEL*/
                      D.LMT_CONT_ID
                     ,A.DUBIL_BAL AS LOAN_BAL             --贷款余额
                     ,0           AS INT_ADJ              --利息调整
                     ,0           AS FAIR_VAL_CHG         --公允价值变动
                FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息
               INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO B --银承账户信息
                  ON B.BILL_NUM = A.BILL_NUM
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
                  ON D.CONT_ID = A.CONT_ID
                 AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.STD_PROD_ID IN ('601010100001')  -- 601010100001  银承承兑 20221121 mw
                 AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.BILL_NUM IS NOT NULL) T
      WHERE NVL(T.LOAN_BAL,0)+NVL(T.INT_ADJ,0)-NVL(T.FAIR_VAL_CHG,0) <> 0
        AND NOT EXISTS (SELECT 1 FROM TMP1_ADD_DG_002_CREDIT TT WHERE TT.CONT_ID = T.LMT_CONT_ID ) ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 11;
   V_STEP_DESC := '整合对公当天失效部分';
   V_STARTTIME := SYSDATE;

    INSERT INTO TMP1_ADD_DG_002_CREDIT 
     ( CONT_ID
      ,SYS_SOURCE
      )
     SELECT DISTINCT 
            D.LMT_CONT_ID
            ,'当天失效' AS SYS_SOURCE
       FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息
       LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
         ON D.CONT_ID = A.CONT_ID
        AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND NVL(A.DISTR_DT,DATE'0001-01-01') = TO_DATE(V_P_DATE,'YYYYMMDD')  --发放日=当天
        AND NOT EXISTS (SELECT 1 FROM TMP1_ADD_DG_002_CREDIT TT WHERE TT.CONT_ID = D.LMT_CONT_ID )
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 12;
   V_STEP_DESC := '处理对公额度下总放款金额';
   V_STARTTIME := SYSDATE;

   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_ADD_DG_002_CREDIT_DISTR';
   INSERT INTO TMP_ADD_DG_002_CREDIT_DISTR
    ( LMT_CONT_ID
      ,DISTR_AMT
     )
    SELECT T.LMT_CONT_ID
           ,SUM(NVL(T.CURRT_BAL,0))
      FROM (SELECT  A.DUBIL_NUM         AS DUBIL_ID
                   ,A.CONT_ID           AS CONT_ID
                   ,TRIM(B.LMT_CONT_ID) AS LMT_CONT_ID
                   /*A.CURRT_BAL*/
                   ,A.DUBIL_AMT         AS CURRT_BAL
                   -- MOD BY LIUYU 20230602 调整按照借据余额作为已用额度
                   --MOD BY MW 20230724 根据黄娅娅口径调整为放款金额
              FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息表
              LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息表
                ON B.CONT_ID = A.CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
               AND A.STD_PROD_ID <> '203040100001'  --剔除银承垫款20230728
             --普通贷款
             UNION ALL
             SELECT A.LOG_CONT_ID       AS DUBIL_ID
                   ,C.CONT_ID           AS CONT_ID
                   ,TRIM(C.LMT_CONT_ID) AS LMT_CONT_ID
                   /*A.CURRT_BAL*/
                   ,B.DUBIL_AMT         AS CURRT_BAL
              FROM RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息表
             INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息表
                ON B.DUBIL_ID = A.LOG_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
              LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
                ON B.CONT_ID = C.CONT_ID
               AND C.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             --表外保函
             UNION ALL
             SELECT A.ACCT_ID    AS DUBIL_ID
                   ,C.CONT_ID    AS CONT_ID
                   ,TRIM(C.LMT_CONT_ID)   AS LMT_CONT_ID
                   /*B.DUBIL_BAL*/
                   ,B.DUBIL_AMT   AS CURRT_BAL
             FROM RRP_MDL.O_ICL_CMM_BA_ACCT_INFO A --银承账户信息
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
               ON A.BILL_NUM =B.BILL_NUM
              AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
              AND B.STD_PROD_ID IN ('601010100001')
             LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息
               ON B.CONT_ID = C.CONT_ID
              AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              AND A.BILL_NUM IS NOT NULL
             --银承
             UNION ALL
             SELECT A.ACCT_ID||'_'||A.MX_LC_FLG AS DUBIL_ID
                   ,C.CONT_ID                   AS CONT_ID
                   ,TRIM(C.LMT_CONT_ID)         AS LMT_CONT_ID
                   /*B.NOMAL_PRIC*/
                   ,B.DUBIL_AMT                 AS CURRT_BAL
              FROM RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
             INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
                ON A.LC_ID = B.BILL_NUM
               AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               AND B.STD_PROD_ID IN ('601020100001','601020100002','603010100002','601020200001','601020200002','603010300002')
             INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C
                ON B.CONT_ID = C.CONT_ID
               AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               AND A.LC_ID IS NOT NULL
            --信用证
            UNION ALL
            SELECT B.DUBIL_ID                   AS DUBIL_ID
                  ,C.CONT_ID                    AS CONT_ID
                  ,TRIM(C.LMT_CONT_ID)          AS LMT_CONT_ID
                  /*CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
                        THEN ROUND(NVL(A.CURRT_BAL, 0),2)
                        ELSE 0
                   END  */
                  ,B.DUBIL_AMT                  AS CURRT_BAL
             FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
               ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
              AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
              AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息
               ON B.CONT_ID = C.CONT_ID
              AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            WHERE A.DISCNT_STATUS_CD IN ('06')
              AND A.ENTRY_STATUS_CD = '03'
              AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            --贴现
            UNION ALL
            SELECT B.DUBIL_ID                  AS BUBIL_ID
                  ,D.CONT_ID                   AS CONT_ID
                  ,TRIM(D.LMT_CONT_ID)         AS LMT_CONT_ID
                  /*CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
                        THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
                        WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                        THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
                        ELSE 0
                   END*/
                  ,B.DUBIL_AMT                      AS CURRT_BAL
             FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
               ON B.BILL_ID = A.BILL_ID
              AND B.STD_PROD_ID IN ('204010100001','204010100002')
              AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
               ON D.CONT_ID = B.CONT_ID
              AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'
              AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
             LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
               ON J.BILL_ID = A.BILL_ID
              AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            WHERE A.TRAN_DIR_CD = '01'  --买入
              AND A.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
              AND A.ENTRY_STATUS_CD = '03'  --记账成功
              AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
             ) T
     GROUP BY T.LMT_CONT_ID;

  COMMIT;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   /**************额度合同-插入临时表****************/
  V_STEP      := 13;
  V_STEP_DESC := '额度合同-插入临时表';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP_ADD_DG_002_CREDIT
    (DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,KHWYM          --06 客户唯一码
    ,KHMC           --07 客户名称
    ,CNYE           --08 承诺余额（元）
    ,SYS_SOURCE     --09 来源系统
    ,ZSXED          --10 总授信额度
    ,YYED           --11 已用额度
    ,CONT_ID        --12 合同号
    --,CNLB           --13 承诺类别
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                          AS DATA_DATE      --01 数据日期
          --所属机构为空取开户机构
          ,CASE WHEN T1.CUST_ID IN ('5000024671','5000003354','5000008743','5000019808','5000035650') THEN '805001'
                WHEN T1.CUST_ID IN ('5600127171','5600126986') THEN '801001'
                WHEN T2.BELONG_ORG_ID LIKE '800993%' THEN '801001'
                ELSE NVL(TRIM(T2.BELONG_ORG_ID),T2.OPEN_ACCT_ORG_ID) 
            END                              AS ACCT_ORG_NUM   --02 账务机构编号
          ,T1.CUST_ID                        AS KHWYM          --06 客户唯一码
          ,T2.CUST_NAME                      AS KHMC           --07 客户名称
          ,DECODE(T1.CURR_CD,'CNY',T1.CONT_AMT - T1.OCCU_CRDT_LMT,T3.CNY_EXCH_RAT * T1.CONT_AMT - T3.CNY_EXCH_RAT * T1.OCCU_CRDT_LMT)
                                             AS CNYE           --08 承诺余额（元）   补录字段，可置空，继承上一天数据
          ,'额度合同'                        AS SYS_SOURCE     --09 来源系统
          ,DECODE(T1.CURR_CD,'CNY',T1.CONT_AMT,T3.CNY_EXCH_RAT * T1.CONT_AMT)
                                             AS ZSXED          --10 总授信额度
          /*T1.OCCU_CRDT_LMT*/
          ,NVL(T4.DISTR_AMT,0)               AS YYED           --11 已用额度
          ,T1.CONT_ID                        AS CONT_ID        --12 合同号
          --,'01'                            AS CNLB           --12 承诺类别
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T1 --对公贷款合同信息表
     INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T2 --对公客户基本信息表
        ON T1.CUST_ID = T2.CUST_ID
       AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN TMP1_ADD_DG_002_CREDIT A
        ON T1.LMT_CONT_ID = A.CONT_ID
      LEFT JOIN RRP_MDL.O_ICL_CMM_EXCH_RAT_INFO T3  --汇率表
        ON T1.CURR_CD = T3.CURR_CD
       AND T3.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN TMP_ADD_DG_002_CREDIT_DISTR T4
        ON T1.CONT_ID = T4.LMT_CONT_ID
        -- MOD BY LIUYU 改关联条件
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO T5  --对公贷款额度合同补充信息
        ON T1.CONT_ID = T5.CONT_ID
       AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T1.VALID_FLG_CD = '2' --取合同有效的
       AND T1.CRDT_TYPE_CD = '01' --01-额度合同02-业务合同
       --AND T1.CONT_ID NOT LIKE 'MIGT%'
       AND ( T1.STD_PROD_ID IN ('100010100001', --公司客户综合
                                '100010100003', --公司客户低风险
                                '100010200003') --公司客户保贴额度
        -- MOD BY liuyu 明确只要公司客户额度里面的四个产品
        -- MOD BY liuyu 专项额度只要可售产品是贷款的
           OR (T1.STD_PROD_ID = '100010100002' AND (SUBSTR(T5.LMT_UNDER_SELLBL_PROD_ID,1,1) = '2'
           OR T5.LMT_UNDER_SELLBL_PROD_ID IN ('602060100001','602060100002') )) -- 可售产品为贷款的或表外银团贷款
            )
       AND (A.CONT_ID IS NOT NULL
           OR (A.CONT_ID IS NULL AND T1.LOAN_HAPP_TYPE_CD = '0201'))  -- 0201展期
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /**************处理数据-插入目标表****************/
  V_STEP      := 14;
  V_STEP_DESC := '处理数据-插入目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_002_CREDIT NOLOGGING
    (
     DATA_DATE      --01 数据日期
    ,ACCT_ORG_NUM   --02 账务机构编号
    ,KHWYM          --06 客户唯一码
    ,KHMC           --07 客户名称
    ,CNYE           --08 承诺余额（元）
    ,SYS_SOURCE     --09 来源系统
    ,ZSXED          --10 总授信额度
    ,YYED           --11 已用额度
    --,CNLB           --12 承诺类别
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                   AS DATA_DATE      --01 数据日期
          ,CASE WHEN T1.ACCT_ORG_NUM IN ('801001','805001') THEN T1.ACCT_ORG_NUM
                WHEN COALESCE(T1.ACCT_ORG_NUM,T2.ACCT_ORG_NUM,T3.ACCT_ORG_NUM) = '800958866'  THEN '891' --20230526业务黄娅娅要求，800958866 放到891机构数字银行总部
                ELSE COALESCE(T2.ACCT_ORG_NUM,T3.ACCT_ORG_NUM,T1.ACCT_ORG_NUM) 
           END                        AS ACCT_ORG_NUM   --02 账务机构编号
          ,T1.KHWYM                   AS KHWYM          --06 客户唯一码
          ,T1.KHMC                    AS KHMC           --07 客户名称
          ,COALESCE(T2.CNYE,T3.CNYE,T1.CNYE)
                                      AS CNYE           --08 承诺余额（元）
          ,T1.SYS_SOURCE              AS SYS_SOURCE     --09 来源系统
          ,T1.ZSXED                   AS ZSXED          --10 总授信额度
          ,T1.YYED                    AS YYED           --11 已用额度
          --,COALESCE(T2.CNLB,T3.CNLB,'01')
                                      --AS CNLB           --12 承诺类别
      FROM (SELECT  T.ACCT_ORG_NUM
                   ,T.KHWYM
                   ,T.KHMC
                   ,SUM(T.CNYE)  AS CNYE
                   ,SUM(T.ZSXED) AS ZSXED
                   ,SUM(T.YYED)  AS YYED
                   ,MAX(T.SYS_SOURCE) AS SYS_SOURCE
              FROM TMP_ADD_DG_002_CREDIT T
             GROUP BY T.ACCT_ORG_NUM, T.KHWYM, T.KHMC) T1 --当天跑批数据
      LEFT JOIN ADD_DG_002_CREDIT_L T2 --当天跑批后补录数据
        ON T1.KHWYM = T2.KHWYM
      LEFT JOIN (SELECT A.*
                        ,ROW_NUMBER() OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                   FROM ADD_DG_002_CREDIT_ETL A
                  WHERE A.DATA_DATE =(SELECT MAX(TT.DATA_DATE) FROM ADD_DG_002_CREDIT_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
                 ) T3 --上一天数据
        ON T1.KHWYM = T3.KHWYM
       AND T3.RN = 1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 16;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,KHWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_002_CREDIT T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,KHWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 17;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_DG_002_CREDIT;
/

