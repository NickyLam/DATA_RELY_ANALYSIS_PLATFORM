CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CRDT_LMT_SUB(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_M_CRDT_LMT_SUB
  *  功能描述：授信额度子表-每个债项对应授信额度。包括对公和个人、同业。按最细颗粒填，按授信协议填，不要计算之后再报送。
  *  1.有授信的客户都需要报送，如低风险自动授信都需要填报授信信息。
  *  2.报送范围：表内、表外、代管理的信贷资产,如：本行信贷资产转让后由本行代管的授信信息仍需报送。
  *  3.增加授信的，应该报单笔。
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CRDT_LMT_SUB
  *  配置表：  CODE_MAP
  *  修改情况：
  *  序号  修改日期  修改人   修改原因
  *	 1    20220524  梅炜     首次创建
     2    20220901  MW       增加码值表模块判定
     3    20221201  liuyu    重新开发
     零售口径：额度合同有效的取额度合同金额，单笔单批取不到额度合同取业务合同金额。
               只有 原额度续作、借新还旧、资产重组三种发生方式会产生新的合同，如果额度项下有借据置为有效，否则为失效。
     对公口径：与旧系统一致，不含迁移数据
     4    20221221  liuyu    为基表新增 合同发生类型 原合同号字段
     5    20221211  liuyu    CRDT_BIZ_TYP 授信业务类型，无法按照模型码值粒度区分，调整接标准产品号
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CRDT_LMT_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE; --跑批日期
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN
/*
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_DATE :=TO_DATE(V_P_DATE,'YYYYMMDD');
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
    V_TAB_NAME := 'M_CRDT_LMT_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_CRDT_LMT_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  \*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRDT_LMT_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*\
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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 用到的临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP01'; --对公已用额度临时表 01
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP02'; --各项贷款余额（不含联合网贷）
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP04'; --按照授信合同维度整合表 04

  -- 程序业务逻辑处理主体部分 --
  \*V_STEP := V_STEP + 1;
  V_STEP_DESC := '授信额度子表--对公信贷部分已用额度加工';

  INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP01
    (DATA_DT                     --数据日期
    ,CRDT_CONT_ID                --授信合同编号
    ,ALDY_USE_LMT                --已用额度
    )
  SELECT V_P_DATE                       AS DATA_DT,                    --数据日期
         T.CONT_ID                      AS CRDT_CONT_ID,               --授信合同编号
         NVL(SUM(NVL(T.USEDAMT,0)), 0)  AS ALDY_USE_LMT                --已用额度
    FROM (SELECT BC1.CONT_ID,
                 SUM(CASE WHEN BC1.LMT_CIRCL_FLG = '0' THEN BC1.BUSINESSSUM --额度合同不可循环
                          WHEN BC1.LMT_CIRCL_FLG = '1' AND BC1.BTCYCLEFLAG = '1' AND BC1.VALID_FLG_CD = '03' THEN 0.00--额度合同可循环,授信产品可循环,业务合同到期结清失效
                          WHEN BC1.LMT_CIRCL_FLG = '1' AND BC1.BTCYCLEFLAG = '1' AND --额度合同可循环,授信产品可循环,业务合同有效或未结清失效
                               (BC1.VALID_FLG_CD <> '3' OR BC1.VALID_FLG_CD IS NULL) THEN
                                 (BC1.BUSINESSSUM - BC1.ACTUALPUTOUTSUM + BC1.BALANCE)
                            ELSE BC1.BUSINESSSUM --额度合同可循环,授信产品不可循环
                      END) AS USEDAMT
            FROM (SELECT \*+USE_HASH(TA,TB,TC)*\
                         TA.CONT_ID                                                 AS CONT_ID,       --授信合同号
                         TA.LMT_CIRCL_FLG                                           AS LMT_CIRCL_FLG, --额度合同的额度循环标志
                         CASE WHEN TB.CONT_ID IS NULL THEN 0
                              ELSE NVL(TB.CONT_AMT,0)
                          END                                                       AS BUSINESSSUM,--额度合同只作为他用额度时业务合同的金额、余额等都为0
                         CASE WHEN TB.CONT_ID IS NULL THEN 0
                              ELSE (NVL(TB.ACM_DISTR_AMT,0)-NVL(TB.ACM_CALLBK_AMT,0))
                          END                                                       AS BALANCE,
                         CASE WHEN TB.CONT_ID IS NULL THEN 0
                              ELSE NVL(TB.ACM_DISTR_AMT,0)
                          END                                                       AS ACTUALPUTOUTSUM,
                         TB.VALID_FLG_CD                                            AS VALID_FLG_CD, --有效标志
                         TA.LMT_CIRCL_FLG                                           AS BTCYCLEFLAG --不在切分范围内则取额度合同循环标志 1-是0-否
                    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO TA --对公贷款合同信息
                    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO TB --对公贷款合同信息
                           ON TB.LMT_CONT_ID = TA.CONT_ID
                          AND TB.CRDT_TYPE_CD = '02'  --授信类型代码 01-额度合同，02-业务合同
                          AND TB.VALID_FLG_CD IN ('1','2','3') --有效标志
                          AND TB.ONL_BUS_FLG <> 'yes' --线上业务标志 排除线上业务合同1-是0-否(表外业务)
                          AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
             \*       LEFT JOIN RRP_MDL.O_ICL_CMM_EXCH_RAT_INFO TC --汇率信息
                           ON TC.CURR_CD = TB.CURR_CD
                          AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*\   --MODIFY BY MW 20221125 取消折币
                   WHERE TA.CUST_ID IS NOT NULL
                     AND TA.CRDT_TYPE_CD = '01'  --授信类型代码 01-额度合同，02-业务合同
                     AND TA.VALID_FLG_CD IN ('2') --有效标志
                     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 ) BC1
           GROUP BY BC1.CONT_ID
         ) T
     GROUP BY CONT_ID;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*\


   V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--对公贷款';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP02';
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(B1,A,C,D,O)*\
         A.DUBIL_ID                        AS RCPT_ID,             --借据号
         A.CONT_ID                         AS CONT_ID,              --合同号
         TRIM(A.BILL_NUM)                  AS BILL_NO,              --票据号
         TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         TRIM(B.CUST_ID)                   AS CUST_ID,              --客户号
         TRIM(D.CUST_ID)                   AS LMT_CUST_ID,          --授信客户号
         B.ACCT_INSTIT_ID                  AS ORG_ID,               --机构号
         A.STD_PROD_ID                     AS LOAN_PROD_ID,         --产品号
         NVL(B.CURR_CD, 'CNY')             AS CUR,                  --币种
         A.DUBIL_AMT                       AS LOAN_AMT,             --放款金额
         CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              WHEN B.WRT_OFF_FLG <> '1' THEN
              CASE WHEN B.SUBJ_ID LIKE '1313%'
                   THEN NVL(B.OVDUE_PRIC_BAL, 0) + NVL(B.IDLE_PRIC, 0) + NVL(B.BAD_DEBT_PRIC, 0)
                   ELSE NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0)
              END
         END                               AS LOAN_BAL,             --贷款余额
         CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              WHEN B.WRT_OFF_FLG <> '1' THEN
              CASE WHEN B.SUBJ_ID LIKE '1313%'
                   THEN 0
                   WHEN B.SUBJ_ID IN ('30070102')
                   THEN 0
                   WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%')
                   THEN NVL(B.IN_BS_INT, 0)
                   WHEN A.STD_PROD_ID IN('203020300002','203030600002','203020300001','203030600001') --福费廷
                   THEN NVL(B.IN_BS_INT, 0)
                   ELSE 0
               END
         END                               AS INT_ADJ,              --利息调整
         CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              WHEN B.WRT_OFF_FLG <> '1' THEN
              CASE WHEN B.SUBJ_ID LIKE '1313%'
                   THEN 0
                   WHEN B.SUBJ_ID IN ('30070102')
                   THEN 0
                   WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%')
                   THEN NVL(AA.N_PV_VARIATION, 0)
                   WHEN A.STD_PROD_ID IN('203030600002','203020300002','203020300001','203030600001')
                   THEN NVL(AA.N_PV_VARIATION, 0)
                   ELSE 0
               END
         END                               AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '普通贷款'                        AS DATA_SRC_DESC         --数据来源中文
    FROM O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息表
   INNER JOIN O_ICL_CMM_CORP_LOAN_ACCT_INFO B     --对公贷款账户信息表
      ON B.DUBIL_NUM = A.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表 取额度合同
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_IOL_IFRS_VAL_RPT_TRADE  AA    --估值报告表
      ON A.DUBIL_ID = AA.V_TRADE_NO
     AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (A.STD_PROD_ID LIKE '2%'
         OR A.STD_PROD_ID LIKE '6020%'
         OR A.STD_PROD_ID IS NULL
         OR A.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002')
         OR C.STD_PROD_ID LIKE '2%'
         OR C.STD_PROD_ID LIKE '6020%'
         OR C.STD_PROD_ID IS NULL
         OR C.STD_PROD_ID IN ('203040600001','203020300002','203030600001','203030600002')
         )
     AND A.DUBIL_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--贴现';
  INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(B1,A,C,D,O)*\
         B.DUBIL_ID                        AS RCPT_ID,             --借据号
         B.CONT_ID                         AS CONT_ID,              --合同号
         A.BILL_ID                         AS BILL_NO,              --票据号
         TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         TRIM(A.CUST_ID)                   AS CUST_ID,              --客户号
         TRIM(D.CUST_ID)                   AS LMT_CUST_ID,          --授信客户号
         A.ENTER_ACCT_ORG_ID               AS ORG_ID,               --机构号
         A.STD_PROD_ID                     AS LOAN_PROD_ID,         --产品号
         NVL(A.CURR_CD, 'CNY')             AS CUR,                  --币种
         A.FAC_VAL_AMT                     AS LOAN_AMT,             --放款金额
         CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN ROUND(NVL(A.CURRT_BAL, 0),2)
              ELSE 0
         END                               AS LOAN_BAL,             --贷款余额
         NVL(A.INT_ADJ_BAL, 0)             AS INT_ADJ,              --利息调整
         NVL(O.N_PV_VARIATION, 0)          AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '贴现部分'                        AS DATA_SRC_DESC         --数据来源中文
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_NUM = A.BILL_NUM
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
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
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '整合各项贷款余额--买断式转贴现';
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(A,C,F2,D,DD,O)*\
         B.DUBIL_ID                       AS  RCPT_ID,             --借据号
         B.CONT_ID                        AS CONT_ID,              --合同号
         TRIM(A.BILL_NUM)                 AS BILL_NO,              --票据号
         TRIM(D.LMT_CONT_ID)              AS LMT_CONT_ID,          --授信合同号
         B.CUST_ID                        AS CUST_ID,              --客户号
         TRIM(E.CUST_ID)                  AS LMT_CUST_ID,          --授信客户号
         A.ACCT_INSTIT_ID                 AS ORG_ID,               --机构号
         B.BUS_BREED_ID                   AS LOAN_PROD_ID,         --产品号
         NVL(A.CURR_CD, 'CNY')            AS CUR,                  --币种
         A.FAC_VAL_AMT                    AS LOAN_AMT,             --放款金额
         CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
              THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
              WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
              ELSE 0
         END                               AS LOAN_BAL,             --贷款余额
         CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
              THEN NVL(A.INT_ADJ_BAL, 0)
              WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN NVL(A.INT_ADJ_BAL, 0)
              ELSE 0
          END                              AS INT_ADJ,              --利息调整
         CASE WHEN V_P_DATE <= '20210630' AND NVL(A.CURRT_BAL, 0) = 0 AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0
              WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = 0
              THEN NVL(O.N_PV_VARIATION, 0)
              WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN NVL(O.N_PV_VARIATION, 0)
              ELSE 0
          END                              AS FAIR_VAL_CHG,         --公允价值变动
         '买断式转贴现部分'                AS DATA_SRC,             --数据来源
         '买断式转贴现部分'                AS DATA_SRC_DESC         --数据来源中文
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
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合表外业务余额--信用证';
     INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
    SELECT \*+USE_HASH(A,C,D)*\
         A.ACCT_ID||'_'||A.MX_LC_FLG       AS RCPT_ID,             --借据号
         E.CONT_ID                         AS CONT_ID,              --合同号
         ''                                AS BILL_NO,              --票据号
         TRIM(E.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         NULL                              AS LMT_CUST_ID,          --授信客户号 表外的不用算转授信
         B.CUST_ID                         AS CUST_ID,              --客户号
         A.ACCT_INSTIT_ID                  AS ORG_ID,               --机构号
         ''                                AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         A.ISSUE_AMT                       AS LOAN_AMT,             --放款金额
         B.NOMAL_PRIC                      AS LOAN_BAL,             --贷款余额
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '信用证部分'                      AS DATA_SRC_DESC         --数据来源中文
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON E.CONT_ID = B.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A --信用证账户信息
      ON A.LC_ID = B.BILL_NUM
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.STD_PROD_ID IN ('601020100001','601020100002','603010100002','601020200001','601020200002','603010300002')
     --信用证
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '整合表外业务余额--保函';
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
    SELECT \*+USE_HASH(A,B,C,D)*\
         A.ACCT_ID                         AS  RCPT_ID,             --借据号
         E.CONT_ID                         AS CONT_ID,              --合同号
         ''                                AS BILL_NO,              --票据号
         TRIM(E.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         E.CUST_ID                         AS CUST_ID,              --客户号
         NULL                              AS LMT_CUST_ID,          --授信客户号 表外的不用算转授信
         A.ACCT_INSTIT_ID                  AS ORG_ID,               --机构号
         ''                                AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         A.LOG_AMT                         AS LOAN_AMT,             --放款金额
         A.CURRT_BAL                       AS LOAN_BAL,             --贷款余额
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '保函部分'                        AS DATA_SRC_DESC         --数据来源中文
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON E.CONT_ID = B.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A --保函账户信息
      ON A.LOG_CONT_ID = B.DUBIL_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (B.STD_PROD_ID LIKE '60103010000%'
          OR B.STD_PROD_ID LIKE '60103020000%')
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
   COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合表外业务余额--银行承兑汇票';
    INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(A,B,C,D)*\
         B.ACCT_ID                         AS RCPT_ID,             --借据号
         A.CONT_ID                         AS CONT_ID,              --合同号
         TRIM(A.BILL_NUM)                  AS BILL_NO,              --票据号
         TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         NVL(C.CUST_ID, A.CUST_ID)         AS CUST_ID,              --客户号
         NULL                              AS LMT_CUST_ID,          --授信客户号 表外的不用算转授信
         B.ACPT_ORG_ID                     AS ORG_ID,               --机构号
         A.STD_PROD_ID                     AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         NVL(B.FAC_VAL_AMT,A.DUBIL_AMT)    AS LOAN_AMT,             --放款金额
         A.DUBIL_BAL                       AS LOAN_BAL,             --贷款余额
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '银承部分'                        AS DATA_SRC_DESC         --数据来源中文
     FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息
    INNER JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO B --银承账户信息
       ON A.BILL_NUM = B.BILL_NUM
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C  --存款客户账户信息表
       ON A.STL_ACCT_NUM = C.CUST_ACCT_ID
      AND A.ETL_DT = C.ETL_DT
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
       ON D.CONT_ID = A.CONT_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.STD_PROD_ID IN ('601010100001')  -- 601010100001  银承承兑 20221121 mw
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.BILL_NUM IS NOT NULL;
  COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合对公当天失效部分';
    INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(A,B,C,D)*\
         A.DUBIL_ID                        AS RCPT_ID,             --借据号
         A.CONT_ID                         AS CONT_ID,              --合同号
         TRIM(A.BILL_NUM)                  AS BILL_NO,              --票据号
         TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         A.CUST_ID                         AS CUST_ID,              --客户号
         NULL                              AS LMT_CUST_ID,          --授信客户号
         ''                                AS ORG_ID,               --机构号
         ''                                AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         A.DUBIL_AMT                       AS LOAN_AMT,             --放款金额
         0                                 AS LOAN_BAL,             --贷款余额
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '当天失效'                        AS DATA_SRC_DESC         --数据来源中文
     FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A    --对公贷款借据信息
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
       ON D.CONT_ID = A.CONT_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
      AND NVL(A.PAYOFF_DT,DATE'9999-12-31') = NVL(A.DISTR_DT,DATE'0001-01-01') -- 结清日=发放日
      AND NVL(A.PAYOFF_DT,DATE'9999-12-31') = TO_DATE(I_P_DATE,'YYYYMMDD'); --结清日=当天
  COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合各项贷款余额--零售贷款';
    INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP02
    (RCPT_ID,              --借据号
     CONT_ID,              --合同号
     BILL_NO,              --票据号
     LMT_CONT_ID,          --授信合同号
     CUST_ID,              --客户号
     LMT_CUST_ID,          --授信客户号
     ORG_ID,               --机构号
     LOAN_PROD_ID,         --产品号
     CUR,                  --币种
     LOAN_AMT,             --放款金额
     LOAN_BAL,             --贷款余额
     INT_ADJ,              --利息调整
     FAIR_VAL_CHG,         --公允价值变动
     DATA_SRC,             --数据来源
     DATA_SRC_DESC         --数据来源中文
    )
  SELECT \*+USE_HASH(A,B,C,D)*\
         A.DUBIL_NUM                       AS RCPT_ID,             --借据号
         A.CONT_ID                         AS CONT_ID,              --合同号
         ''                                AS BILL_NO,              --票据号
         TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         A.CUST_ID                         AS CUST_ID,              --客户号
         NULL                              AS LMT_CUST_ID,          --授信客户号
         ''                                AS ORG_ID,               --机构号
         ''                                AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         A.DUBIL_AMT                       AS LOAN_AMT,             --放款金额
         A.CURRT_BAL                       AS LOAN_BAL,             --贷款余额
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '零售'                            AS DATA_SRC_DESC         --数据来源中文
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A  --零售贷款账户信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售合同表
      ON B.CONT_ID = C.CONT_ID
     AND C.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.CURRT_BAL > 0  -- 余额大于0
     AND A.WRT_OFF_FLG <> '1' --不含核销
     AND A.SUBJ_ID NOT LIKE '3007%' --不含委托贷款
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表--对公已用额度';
   V_STARTTIME := SYSDATE;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP01';

   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP01
    (DATA_DT                     --数据日期
    ,CRDT_CONT_ID                --授信合同编号
    ,ALDY_USE_LMT                --已用额度
    )
  SELECT V_P_DATE                        AS DATA_DT,                    --数据日期
         T.LMT_CONT_ID                   AS CRDT_CONT_ID,               --授信合同编号
         NVL(SUM(NVL(T.LOAN_BAL,0)), 0)  AS ALDY_USE_LMT                --已用额度
    FROM RRP_MDL. M_CRDT_LMT_SUB_TEMP02 T --余额之和
   GROUP BY LMT_CONT_ID;
  COMMIT;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表--对公信贷部分';
   V_STARTTIME := SYSDATE;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_SUB_TEMP04';
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP04
  (
       DATA_DT                      --01数据日期
      ,LGL_REP_ID                   --02法人编号
      ,PRIM_CRDT_CONT_ID            --03主授信合同编号
      ,CRDT_CONT_ID                 --04授信合同编号
      ,CRDT_CONT_NM                 --05授信合同名称
      ,CUST_ID                      --06客户编号
      ,ORG_ID                       --07机构编号
      ,CRDT_LMT                     --08授信额度
      ,ALDY_USE_LMT                 --09已用额度
      ,SUR_CRDT_LMT                 --10剩余授信额度
      ,EXP_CRDT_LMT                 --11敞口授信额度
      ,EXP_ALDY_USE_LMT             --12敞口已用额度
      ,EXP_SUR_LMT                  --13敞口剩余额度
      ,CUR                          --14币种
      ,CRDT_SUBJ_TYP                --15授信主体类型
      ,EFF_DT                       --16生效日期
      ,CRDT_STAT                    --17授信状态
      ,CRDT_APP_DT                  --18授信申请日期
      ,CRDT_START_DT                --19授信开始日期
      ,CRDT_EXP_DT                  --20授信到期日期
      ,CRDT_BIZ_TYP                 --21授信业务类型
      ,CIR_LMT_FLG                  --22循环额度标志
      ,TEMP_LMT_FLG                 --23临时额度标志
      ,CRDT_SUBJ_CL                 --24授信主体种类
      ,BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
      ,DSN_SHT_OPN                  --26决策单意见
      ,APRV_PSN_NO                  --27审批人工号
      ,CRDT_EMP_NO                  --28授信员工号
      ,DEPT_LINE                    --29部门条线
      ,DATA_SRC                     --30数据来源
      ,LMT_TYPE_CD                  --31授信种类代码
      ,LOAN_HAPP_TYPE_CD            --32合同发生类型
      ,RELA_CONT_ID                 --33原合同编号
      )
       WITH LMT_INTO_TEMP06 AS (
      SELECT \*+MATERIALIZE*\ T6.LMT_CONT_ID  --物化视图
        FROM RRP_MDL.M_CRDT_LMT_SUB_TEMP02 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.LMT_CONT_ID)
        ,LMT_INTO_TEMP07 AS (
      SELECT \*+MATERIALIZE*\ T7.LMT_CONT_ID  --物化视图
        FROM RRP_MDL.M_CRDT_LMT_SUB_TEMP02 T7
       WHERE T7.DATA_SRC_DESC = '当天失效'
       GROUP BY T7.LMT_CONT_ID)
   SELECT V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,A.LP_ID                                         AS LGL_REP_ID                  --02法人编号
         ,A.CONT_ID                                       AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                       AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(A.MANU_CONT_ID),A.CONT_ID)             AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                       AS CUST_ID                     --06客户编号
         ,COALESCE(A.OPER_ORG_ID,A.MGMT_ORG_ID,A.RGST_ORG_ID)
                                                          AS ORG_ID                      --07机构编号
         ,A.CONT_AMT                                      AS CRDT_LMT                    --08授信额度
         ,NVL(F.ALDY_USE_LMT,0)                           AS ALDY_USE_LMT                --09已用额度
         ,NVL(A.CONT_AMT,0) - NVL(F.ALDY_USE_LMT,0)       AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                            AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                            AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                            AS EXP_SUR_LMT                 --13敞口剩余额度
         ,A.CURR_CD                                       AS CUR                         --14币种
         ,TA.TAR_VALUE_CODE                               AS CRDT_SUBJ_TYP               --15授信主体类型 CD1471-->C0032
         ,CASE WHEN A.DISTR_DT > TO_DATE('00010101','YYYYMMDD') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN B.LMT_CONT_ID IS NOT NULL THEN 'Y' --表内外借据有余额的置为有效
               WHEN G.LMT_CONT_ID IS NOT NULL THEN 'Y' --当天发放当天结清的置为有效
               WHEN A.LOAN_HAPP_TYPE_CD = '0201' THEN 'N' --展期合同置为失效 CD04031 贷款发放类型代码
               WHEN A.STD_PROD_ID = '100030000002' THEN 'N' --gl开头的都是集团客户的管理额度，集团客户无法发生业务
               WHEN A.CONT_ID LIKE 'MIGT%' THEN 'N' --信贷回复MIGT开头的是新信贷迁移规则，根据批复生成的额度合同，黄娅娅回复剔除
               WHEN A.VALID_FLG_CD = '2' THEN 'Y' --CD04022 合同状态代码
               ELSE 'N'
          END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,COALESCE(LEAST(NVL(CASE WHEN A.RGST_DT >TO_DATE('00010101','YYYYMMDD') THEN
         TO_CHAR(A.RGST_DT,'YYYYMMDD') END,
                             CASE WHEN A.DISTR_DT >TO_DATE('00010101','YYYYMMDD') THEN
                             TO_CHAR(A.DISTR_DT,'YYYYMMDD') END),
                   CASE WHEN A.DISTR_DT >TO_DATE('00010101','YYYYMMDD') THEN
                   TO_CHAR(A.DISTR_DT,'YYYYMMDD') END),
                   CASE WHEN A.DISTR_DT >TO_DATE('00010101','YYYYMMDD') THEN
                   TO_CHAR(A.DISTR_DT,'YYYYMMDD') END,
                   TO_CHAR(D.CRDT_LMT_BEGIN_DT,'YYYYMMDD') ,'99991231')
                                                          AS CRDT_APP_DT                 --18授信申请日期
         ,TO_CHAR(LEAST(NVL(CASE WHEN A.RGST_DT >TO_DATE('00010101','YYYYMMDD') THEN A.RGST_DT END,
                    CASE WHEN A.DISTR_DT >TO_DATE('00010101','YYYYMMDD') THEN A.DISTR_DT END),
                CASE WHEN A.DISTR_DT >TO_DATE('00010101','YYYYMMDD') THEN A.DISTR_DT
                END),'YYYYMMDD')                          AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN A.EXP_DT = TO_DATE('20991231','YYYYMMDD') THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,A.STD_PROD_ID                                   AS CRDT_BIZ_TYP                --21授信业务类型
         -- 由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,CASE WHEN A.LMT_CIRCL_FLG ='0' THEN 'N'
               ELSE 'Y'
           END                                            AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN A.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
               WHEN A.STD_PROD_ID IN ('100010100003') THEN '02'--低风险
               WHEN A.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
               WHEN NVL(A.OPEN_BAL,0) = 0 OR A.CONT_TYPE_CD IN ('03') THEN '02'
               ELSE '9901' --其他-敞口授信
          END                                              AS CRDT_SUBJ_CL               --24授信主体种类
         ,'N'                                              AS BANK_TAX_COOP_LOAN_CRDT_FLG--25银税合作贷款授信标志
         ,NVL(SUBSTRB(D.CRDT_LMT_APV_OPINION,1,2000),'同意')
                                                           AS DSN_SHT_OPN                --26决策单意见
         ,D.FINAL_APVER_ID                                 AS APRV_PSN_NO                --27审批人工号
         ,CASE WHEN A.MGMT_TELLER_ID = 'system' AND A.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE E.CLERK_ID
           END                                             AS CRDT_EMP_NO                --28授信员工号
         ,'800919'                                         AS DEPT_LINE                  --29部门条线
				 ,'对公信贷'                                       AS DATA_SRC                   --30数据来源
         ,T4.LMT_KIND_CD                                   AS LMT_TYPE_CD                --31额度种类代码
         ,A.LOAN_HAPP_TYPE_CD                              AS LOAN_HAPP_TYPE_CD          --32合同发生类型
         ,A.RELA_CONT_ID                                   AS RELA_CONT_ID               --33原合同编号
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 B -- 额度项下借据有余额的
      ON B.LMT_CONT_ID = A.CONT_ID
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C--对公客户基本信息
         \*迁移数据会有部分客户号不在ECIF系统中，直接剔除*\
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO D --对公授信额度合同审批信息
      ON D.CRDT_LMT_APV_FLOW_NUM=A.APV_FLOW_NUM
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO E --行员信息表
      ON E.TELLER_ID = TRIM(A.MGMT_TELLER_ID)
     AND E.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_CRDT_LMT_SUB_TEMP01 F--对公信贷已用额度临时表
      ON F.CRDT_CONT_ID = A.CONT_ID
     AND F.DATA_DT = V_P_DATE
    LEFT JOIN LMT_INTO_TEMP07 G --当天授信当天结清的
      ON G.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO T4  --对公贷款额度合同补充信息
      ON T4.CONT_ID  = A.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --授信主体类型 CD1471-->C0032
      ON TA.SRC_VALUE_CODE = C.CUST_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1471'
     AND TA.TAR_CLASS_CODE = 'C0032'
     AND TA.MOD_FLG = 'MDM'
   WHERE A.CRDT_TYPE_CD = '01'  --授信类型代码 01-额度合同，02-业务合同
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-对公-转授信';
  V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP04
    (
       DATA_DT                      --01数据日期
      ,LGL_REP_ID                   --02法人编号
      ,PRIM_CRDT_CONT_ID            --03主授信合同编号
      ,CRDT_CONT_ID                 --04授信合同编号
      ,CRDT_CONT_NM                 --05授信合同名称
      ,CUST_ID                      --06客户编号
      ,ORG_ID                       --07机构编号
      ,CRDT_LMT                     --08授信额度
      ,ALDY_USE_LMT                 --09已用额度
      ,SUR_CRDT_LMT                 --10剩余授信额度
      ,EXP_CRDT_LMT                 --11敞口授信额度
      ,EXP_ALDY_USE_LMT             --12敞口已用额度
      ,EXP_SUR_LMT                  --13敞口剩余额度
      ,CUR                          --14币种
      ,CRDT_SUBJ_TYP                --15授信主体类型
      ,EFF_DT                       --16生效日期
      ,CRDT_STAT                    --17授信状态
      ,CRDT_APP_DT                  --18授信申请日期
      ,CRDT_START_DT                --19授信开始日期
      ,CRDT_EXP_DT                  --20授信到期日期
      ,CRDT_BIZ_TYP                 --21授信业务类型
      ,CIR_LMT_FLG                  --22循环额度标志
      ,TEMP_LMT_FLG                 --23临时额度标志
      ,CRDT_SUBJ_CL                 --24授信主体种类
      ,BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
      ,DSN_SHT_OPN                  --26决策单意见
      ,APRV_PSN_NO                  --27审批人工号
      ,CRDT_EMP_NO                  --28授信员工号
      ,DEPT_LINE                    --29部门条线
      ,DATA_SRC                     --30数据来源
      ,LMT_TYPE_CD                  --31授信种类代码
      ,LOAN_HAPP_TYPE_CD            --32合同发生类型
      ,RELA_CONT_ID                 --33原合同编号
     )
  SELECT  \*+USE_HASH(A,B,C,D,E,F,TA)*\
          V_P_DATE                                      AS DATA_DT                     --01数据日期
         ,B.LP_ID                                       AS LGL_REP_ID                  --02法人编号
         ,A.CONT_ID                                     AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                     AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(B.MANU_CONT_ID),A.CONT_ID)           AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                     AS CUST_ID                     --06客户编号
         ,A.ORG_ID                                      AS ORG_ID                      --07机构编号
         ,B.CONT_AMT                                    AS CRDT_LMT                    --08授信额度
         ,B.OCCU_CRDT_LMT                               AS ALDY_USE_LMT                --09已用额度
         ,0                                             AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                          AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                          AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                          AS EXP_SUR_LMT                 --13敞口剩余额度
         ,B.CURR_CD                                     AS CUR                         --14币种
         ,TA.TAR_VALUE_CODE                             AS CRDT_SUBJ_TYP               --15授信主体类型 CD1471-->C0032
         ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(B.DISTR_DT,'YYYYMMDD')
           END                                          AS EFF_DT                      --16生效日期
         ,'Y'                                           AS CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END)  --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                        AS CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                        AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(B.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(B.EXP_DT,'YYYYMMDD')
           END                                          AS CRDT_EXP_DT                 --20授信到期日期
         ,B.STD_PROD_ID                                 AS CRDT_BIZ_TYP                --21授信业务类型
         ,'N'                                           AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                          AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN B.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
               WHEN B.STD_PROD_ID IN ('100010100003') THEN '02'--低风险
               WHEN B.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
               WHEN NVL(B.OPEN_BAL,0) = 0 OR B.CONT_TYPE_CD IN ('03') THEN '02'
               ELSE '9901' --其他-敞口授信
          END                                           AS CRDT_SUBJ_CL               --24授信主体种类 T0029
         ,'N'                                           AS BANK_TAX_COOP_LOAN_CRDT_FLG--25银税合作贷款授信标志
         ,'同意'                                        AS DSN_SHT_OPN                --26决策单意见
         ,F.FINAL_APVER_ID                              AS APRV_PSN_NO                --27审批人工号
         ,CASE WHEN B.MGMT_TELLER_ID = 'system' AND B.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE B.MGMT_TELLER_ID
           END                                          AS CRDT_EMP_NO                --28授信员工号
         ,'800919'                                      AS DEPT_LINE                  --29部门条线
         ,'转授信'                                      AS DATA_SRC                   --30数据来源
         ,T4.LMT_KIND_CD                                AS LMT_TYPE_CD                --31额度种类代码
         ,B.LOAN_HAPP_TYPE_CD                           AS LOAN_HAPP_TYPE_CD          --32合同发生类型
         ,B.RELA_CONT_ID                                AS RELA_CONT_ID               --33原合同编号
    FROM RRP_MDL.M_CRDT_LMT_SUB_TEMP02 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C--对公客户基本信息
      ON C.CUST_ID = B.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息
      ON D.CONT_ID = A.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO F --对公授信额度合同审批信息
      ON F.CRDT_LMT_APV_FLOW_NUM = D.APV_FLOW_NUM
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO T4  --对公贷款额度合同补充信息
      ON T4.CONT_ID  = A.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --授信主体类型 CD1471-->C0032
      ON TA.SRC_VALUE_CODE = C.CUST_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1471'
     AND TA.TAR_CLASS_CODE = 'C0032'
     AND TA.MOD_FLG = 'MDM'
   WHERE A.LOAN_BAL <> 0 --业务仍有余额的
     AND A.DATA_SRC_DESC NOT IN ('零售')
     AND A.CUST_ID <> A.LMT_CUST_ID; --业务客户号和授信客户号不一致的表内部分（表外部分授信客户号赋空值）

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表--零售额度合同';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP04
   (
       DATA_DT                      --01数据日期
      ,LGL_REP_ID                   --02法人编号
      ,PRIM_CRDT_CONT_ID            --03主授信合同编号
      ,CRDT_CONT_ID                 --04授信合同编号
      ,CRDT_CONT_NM                 --05授信合同名称
      ,CUST_ID                      --06客户编号
      ,ORG_ID                       --07机构编号
      ,CRDT_LMT                     --08授信额度
      ,ALDY_USE_LMT                 --09已用额度
      ,SUR_CRDT_LMT                 --10剩余授信额度
      ,EXP_CRDT_LMT                 --11敞口授信额度
      ,EXP_ALDY_USE_LMT             --12敞口已用额度
      ,EXP_SUR_LMT                  --13敞口剩余额度
      ,CUR                          --14币种
      ,CRDT_SUBJ_TYP                --15授信主体类型
      ,EFF_DT                       --16生效日期
      ,CRDT_STAT                    --17授信状态
      ,CRDT_APP_DT                  --18授信申请日期
      ,CRDT_START_DT                --19授信开始日期
      ,CRDT_EXP_DT                  --20授信到期日期
      ,CRDT_BIZ_TYP                 --21授信业务类型
      ,CIR_LMT_FLG                  --22循环额度标志
      ,TEMP_LMT_FLG                 --23临时额度标志
      ,CRDT_SUBJ_CL                 --24授信主体种类
      ,BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
      ,DSN_SHT_OPN                  --26决策单意见
      ,APRV_PSN_NO                  --27审批人工号
      ,CRDT_EMP_NO                  --28授信员工号
      ,DEPT_LINE                    --29部门条线
      ,DATA_SRC                     --30数据来源
     )
     WITH LMT_INTO_TEMP06 AS (
      SELECT \*+MATERIALIZE*\ T6.LMT_CONT_ID  --物化视图
        FROM RRP_MDL.M_CRDT_LMT_SUB_TEMP02 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.LMT_CONT_ID)
  SELECT
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,A.LP_ID                                         AS LGL_REP_ID                  --02法人编号
         ,A.LMT_CONT_ID                                   AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.LMT_CONT_ID                                   AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(A.LMT_CONT_CN_NAME,A.LMT_CONT_CN_NAME)      AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                       AS CUST_ID                     --06客户编号
         ,NVL(A.ACCT_INSTIT_ID,A.BELONG_ORG_ID)           AS ORG_ID                      --07机构编号
         ,A.CRDT_LMT                                      AS CRDT_LMT                    --08授信额度
         ,A.OCCU_CRDT_LMT                                 AS ALDY_USE_LMT                --09已用额度
         ,NULL                                            AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                            AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                            AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                            AS EXP_SUR_LMT                 --13敞口剩余额度
         ,A.CURR_CD                                       AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(A.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.BEGIN_DT,'YYYYMMDD')
          END                                             AS EFF_DT                      --16生效日期
         ,CASE WHEN A.PROD_ID IN ('602030100002') THEN 'N' --剔除委托贷款
               WHEN TMP.LMT_CONT_ID IS NOT NULL THEN 'Y' --额度项下有余额的置为有效
               WHEN A.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN A.STATUS_CD = '2' AND NVL(A.EXP_DT,DATE'9999-12-31') >= V_DATE -- 合同有效且未到期
               THEN 'Y'--有效 --CD04022 合同状态代码
               ELSE 'N'
          END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(M.RGST_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(M.RGST_DT,'YYYYMMDD')
          END                                             AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(A.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.BEGIN_DT,'YYYYMMDD')
          END                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                             AS CRDT_EXP_DT                 --20授信到期日期
         ,A.PROD_ID                                       AS CRDT_BIZ_TYP                --21授信业务类型
         ,CASE WHEN A.CIRCL_FLG = '0' THEN 'N'
               ELSE 'Y'
          END                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,CASE WHEN A.PROD_ID IN ('201020100003','201020100012') THEN 'Y'
               ELSE 'N'
          END                                             AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见
         ,''                                              AS APRV_PSN_NO                 --27审批人工号
         ,''                                              AS CRDT_EMP_NO                 --28授信员工号
         ,'800924'                                        AS DEPT_LINE                   --29部门条线
         ,'零售额度合同'                                  AS DATA_SRC                    --30数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO A  --零售贷款授信额度信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO M --零售授信额度审批信息
      ON M.CRDT_LMT_APV_FLOW_NUM = A.LMT_APPL_FLOW_NUM
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN LMT_INTO_TEMP06 TMP --余额大于0的借据
      ON TMP.LMT_CONT_ID  = A.LMT_CONT_ID
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表--单笔单批';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP04
   (
       DATA_DT                      --01数据日期
      ,LGL_REP_ID                   --02法人编号
      ,PRIM_CRDT_CONT_ID            --03主授信合同编号
      ,CRDT_CONT_ID                 --04授信合同编号
      ,CRDT_CONT_NM                 --05授信合同名称
      ,CUST_ID                      --06客户编号
      ,ORG_ID                       --07机构编号
      ,CRDT_LMT                     --08授信额度
      ,ALDY_USE_LMT                 --09已用额度
      ,SUR_CRDT_LMT                 --10剩余授信额度
      ,EXP_CRDT_LMT                 --11敞口授信额度
      ,EXP_ALDY_USE_LMT             --12敞口已用额度
      ,EXP_SUR_LMT                  --13敞口剩余额度
      ,CUR                          --14币种
      ,CRDT_SUBJ_TYP                --15授信主体类型
      ,EFF_DT                       --16生效日期
      ,CRDT_STAT                    --17授信状态
      ,CRDT_APP_DT                  --18授信申请日期
      ,CRDT_START_DT                --19授信开始日期
      ,CRDT_EXP_DT                  --20授信到期日期
      ,CRDT_BIZ_TYP                 --21授信业务类型
      ,CIR_LMT_FLG                  --22循环额度标志
      ,TEMP_LMT_FLG                 --23临时额度标志
      ,CRDT_SUBJ_CL                 --24授信主体种类
      ,BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
      ,DSN_SHT_OPN                  --26决策单意见
      ,APRV_PSN_NO                  --27审批人工号
      ,CRDT_EMP_NO                  --28授信员工号
      ,DEPT_LINE                    --29部门条线
      ,DATA_SRC                     --30数据来源
     )
     WITH LMT_INTO_TEMP06 AS (
      SELECT \*+MATERIALIZE*\ T6.CONT_ID  --物化视图
            ,SUM(NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0)) AS BAL
        FROM RRP_MDL.M_CRDT_LMT_INFO_TEMP06 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.CONT_ID)
  SELECT
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,A.LP_ID                                         AS LGL_REP_ID                  --02法人编号
         ,A.CONT_ID                                       AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                       AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(A.CONT_NAME),A.CONT_ID)                AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                       AS CUST_ID                     --06客户编号
         ,COALESCE(A.ACCT_INSTIT_ID,A.RGST_ORG_ID,A.MGMT_ORG_ID)
                                                          AS ORG_ID                      --07机构编号
         ,A.CONT_AMT                                      AS CRDT_LMT                    --08授信额度
         ,NVL(B.BAL,0)                                    AS ALDY_USE_LMT                --09已用额度
         ,NULL                                            AS SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                            AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                            AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                            AS EXP_SUR_LMT                 --13敞口剩余额度
         ,A.CURR_CD                                       AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.START_DT,'YYYYMMDD')
          END                                             AS EFF_DT                      --16生效日期
         ,CASE WHEN A.PROD_ID IN ('602030100002') THEN 'N' --不含委托贷款
               WHEN B.CONT_ID IS NOT NULL THEN 'Y'
               WHEN A.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN A.CONT_STATUS_CD = '2' AND NVL(A.EXP_DT,DATE'9999-12-31') >= V_DATE -- 合同有效且未到期
               THEN 'Y'--有效 --CD04022 合同状态代码
               ELSE 'N'
          END                                            AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(A.APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.APPL_DT,'YYYYMMDD')
          END                                             AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.START_DT,'YYYYMMDD')
          END                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                             AS CRDT_EXP_DT                 --20授信到期日期
         ,A.PROD_ID                                       AS CRDT_BIZ_TYP                --21授信业务类型
         ,CASE WHEN A.CONT_TYPE_CD = '04' THEN 'Y'
               ELSE 'N'
          END                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,CASE WHEN A.PROD_ID IN ('201020100003','201020100012') THEN 'Y'
               ELSE 'N'
          END                                             AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见
         ,''                                              AS APRV_PSN_NO                 --27审批人工号
         ,''                                              AS CRDT_EMP_NO                 --28授信员工号
         ,'800924'                                        AS DEPT_LINE                   --29部门条线
         ,'零售单笔单批'                                  AS DATA_SRC                    --30数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO A  --零售贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 B --有借据余额的合同
      ON B.CONT_ID = A.CONT_ID
   WHERE A.ETL_DT = V_DATE
     AND TRIM(A.LMT_CONT_ID) IS NULL;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表-联合网贷';
   V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_TEMP04
   (
       DATA_DT                      --01数据日期
      ,LGL_REP_ID                   --02法人编号
      ,PRIM_CRDT_CONT_ID            --03主授信合同编号
      ,CRDT_CONT_ID                 --04授信合同编号
      ,CRDT_CONT_NM                 --05授信合同名称
      ,CUST_ID                      --06客户编号
      ,ORG_ID                       --07机构编号
      ,CRDT_LMT                     --08授信额度
      ,ALDY_USE_LMT                 --09已用额度
      ,SUR_CRDT_LMT                 --10剩余授信额度
      ,EXP_CRDT_LMT                 --11敞口授信额度
      ,EXP_ALDY_USE_LMT             --12敞口已用额度
      ,EXP_SUR_LMT                  --13敞口剩余额度
      ,CUR                          --14币种
      ,CRDT_SUBJ_TYP                --15授信主体类型
      ,EFF_DT                       --16生效日期
      ,CRDT_STAT                    --17授信状态
      ,CRDT_APP_DT                  --18授信申请日期
      ,CRDT_START_DT                --19授信开始日期
      ,CRDT_EXP_DT                  --20授信到期日期
      ,CRDT_BIZ_TYP                 --21授信业务类型
      ,CIR_LMT_FLG                  --22循环额度标志
      ,TEMP_LMT_FLG                 --23临时额度标志
      ,CRDT_SUBJ_CL                 --24授信主体种类
      ,BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
      ,DSN_SHT_OPN                  --26决策单意见
      ,APRV_PSN_NO                  --27审批人工号
      ,CRDT_EMP_NO                  --28授信员工号
      ,DEPT_LINE                    --29部门条线
      ,DATA_SRC                     --30数据来源
     )
  WITH CMM_UNITE_WL_LMT_INFO_QC AS (
     -- 由于数仓保留了BUS_BREED_ID在联合网贷额度表，但是没有标准产品号，现在把BUS_BREED_ID映射为标准产品号
     SELECT T.CUST_ID                            AS CUST_ID --客户号
           ,T.LMT_CONT_ID                        AS LMT_CONT_ID --额度申请号
           ,T.CRDT_LMT                           AS CRDT_LMT --授信额度
           ,T.STATUS_CD                          AS STATUS_CD --状态代码
           ,MIN(BEGIN_DT)OVER(PARTITION BY CUST_ID,
                              CASE WHEN T.BUS_BREED_ID IN ('202020100001','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                                   WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222') THEN '202010100001' --借呗
                                   WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                                   WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                                   WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                               END)              AS BEGIN_DT --授信起始日期
           ,CASE WHEN TO_CHAR(EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                 THEN EXP_DT
            END                                  AS EXP_DT --授信到期日期
           ,CASE WHEN T.BUS_BREED_ID IN ('202020100001','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                 WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222') THEN '202010100001' --借呗
                 WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                 WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                 WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
             END                                  AS BUS_BREED_ID1 --统一后的授信品种
           ,ROW_NUMBER()OVER(PARTITION BY CUST_ID,
                             CASE WHEN T.BUS_BREED_ID IN ('202020100001','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                                  WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222') THEN '202010100001' --借呗
                                  WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                                  WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                                  WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                              END
                ORDER BY BEGIN_DT DESC,T.LMT_CONT_ID DESC)
                                                 AS RN --去重
            --一个客户在一个业务品种中可能有多次审批记录，取当前最新的一个额度为准 --梁秋茹/杨光泽
            --标准产品号之后没有分借呗/借呗三期，网商贷/网商贷引流产品。但是数仓保留了旧的BUS_BREED_ID字段，赋了原来的业务品种值
       FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T
      WHERE T.ETL_DT = V_DATE
        AND TRIM(T.CUST_ID) IS NOT NULL
        AND T.CRDT_LMT > 0
        )
  SELECT  V_P_DATE                              AS DATA_DT                      --01数据日期
         ,A.LP_ID                               AS LGL_REP_ID                   --02法人编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)        AS PRIM_CRDT_CONT_ID            --03主授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)        AS CRDT_CONT_ID                 --04授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)        AS CRDT_CONT_NM                 --05授信合同名称
         ,A.CUST_ID                             AS CUST_ID                      --06客户编号
         ,A.ACCT_INSTIT_ID                      AS ORG_ID                       --07机构编号
         ,NVL(TB.CRDT_LMT,A.DUBIL_AMT)          AS CRDT_LMT                     --08授信额度
         ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
               ELSE A.PRIC_BAL
           END                                  AS ALDY_USE_LMT                 --09已用额度
         ,NULL                                  AS SUR_CRDT_LMT                 --10剩余授信额度
         ,NULL                                  AS EXP_CRDT_LMT                 --11敞口授信额度
         ,NULL                                  AS EXP_ALDY_USE_LMT             --12敞口已用额度
         ,NULL                                  AS EXP_SUR_LMT                  --13敞口剩余额度
         ,A.CURR_CD                             AS CUR                          --14币种
         ,'04'                                  AS CRDT_SUBJ_TYP                --15授信主体类型 04个人客户授信
         ,TO_CHAR(NVL(TB.BEGIN_DT,A.DISTR_DT),'YYYYMMDD')
                                                AS EFF_DT                       --16生效日期
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0)= 0 THEN 'N'
               WHEN A.WRT_OFF_FLG = '1' THEN 'N'
               WHEN TB.STATUS_CD IN ('01','711') OR TB.CUST_ID IS NULL THEN 'Y'
               ELSE 'N'
           END                                  AS CRDT_STAT                    --17授信状态 Z0002
         ,TO_CHAR(NVL(TB.BEGIN_DT,A.DISTR_DT),'YYYYMMDD')
                                                AS CRDT_APP_DT                  --18授信申请日期
         ,TO_CHAR(NVL(TB.BEGIN_DT,A.DISTR_DT),'YYYYMMDD')
                                                AS CRDT_START_DT                --19授信开始日期
         ,TO_CHAR(NVL(TB.EXP_DT,A.EXP_DT),'YYYYMMDD')
                                                AS CRDT_EXP_DT                  --20授信到期日期
         ,NVL(TB.BUS_BREED_ID1,A.STD_PROD_ID)   AS CRDT_BIZ_TYP                 --21授信业务类型
         ,'Y'                                   AS CIR_LMT_FLG                  --22循环额度标志
         ,NULL                                  AS TEMP_LMT_FLG                 --23临时额度标志
         ,'02'                                  AS CRDT_SUBJ_CL                 --24授信主体种类T0029
         ,'N'                                   AS BANK_TAX_COOP_LOAN_CRDT_FLG  --25银税合作贷款授信标志
         ,'同意'                                AS DSN_SHT_OPN                  --26决策单意见
         ,NULL                                  AS APRV_PSN_NO                  --27审批人工号
         ,NULL                                  AS CRDT_EMP_NO                  --28授信员工号
         ,'800924'                              AS DEPT_LINE                    --29部门条线
         ,'联合网贷'                            AS DATA_SRC                     --30数据来源
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A -- 联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO B -- 核销表
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC TB   --存在有借据无授信情况
      ON TB.CUST_ID = A.CUST_ID
     AND TB.BUS_BREED_ID1 = (CASE WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN '202010100005' --京东白条
                                  WHEN A.STD_PROD_ID IN ('202010100002','202010100001') THEN '202010100001' --借呗
                                  ELSE A.STD_PROD_ID --新一代标准产品没有分网商贷、网商贷引流
                             END)
     \*AND TB.*\--要加客户号关联客户号，产品号关联产品号逻辑
     AND TB.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO TC     --内部机构信息表
      ON TC.ORG_ID = A.ACCT_INSTIT_ID
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE ((NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0)-- 取余额大于0的借据
          OR (A.WRT_OFF_FLG = '1' AND B.FIR_WRT_OFF_DT >= V_MONTH_START_DATE-1)
          OR A.PAYOFF_DT >= V_MONTH_START_DATE-1 )
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表-整合';
   V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_SUB
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,CRDT_LMT                        --授信额度
    ,ALDY_USE_LMT                    --已用额度
    ,SUR_CRDT_LMT                    --剩余授信额度
    ,EXP_CRDT_LMT                    --敞口授信额度
    ,EXP_ALDY_USE_LMT                --敞口已用额度
    ,EXP_SUR_LMT                     --敞口剩余额度
    ,CUR                             --币种
    ,CRDT_SUBJ_TYP                   --授信主体类型
    ,EFF_DT                          --生效日期
    ,CRDT_STAT                       --授信状态
    ,CRDT_APP_DT                     --授信申请日期
    ,CRDT_START_DT                   --授信开始日期
    ,CRDT_EXP_DT                     --授信到期日期
    ,CRDT_BIZ_TYP                    --授信业务类型
    ,CIR_LMT_FLG                     --循环额度标志
    ,TEMP_LMT_FLG                    --临时额度标志
    ,CRDT_SUBJ_CL                    --授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
    ,DSN_SHT_OPN                     --决策单意见
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,LMT_TYPE_CD                     --额度种类代码
    ,LOAN_HAPP_TYPE_CD               --合同发生类型
    ,RELA_CONT_ID                    --原合同编号
     )
  WITH TMP1 AS (
  SELECT DATA_DT                         --数据日期
        ,LGL_REP_ID                      --法人编号
        ,PRIM_CRDT_CONT_ID               --主授信合同编号
        ,CRDT_CONT_ID                    --授信合同编号
        ,NVL(TRIM(CRDT_CONT_NM),CRDT_CONT_ID) CRDT_CONT_NM --授信合同名称
        ,CUST_ID                         --客户编号
        ,COALESCE(TA.ORG_ID1,TB.ORG_ID1,'800') ORG_ID --机构编号
        ,CRDT_LMT                        --授信额度
        ,SUM(ALDY_USE_LMT) OVER(PARTITION BY CRDT_CONT_ID) ALDY_USE_LMT --已用额度
        ,SUR_CRDT_LMT                    --剩余授信额度
        ,EXP_CRDT_LMT                    --敞口授信额度
        ,EXP_ALDY_USE_LMT                --敞口已用额度
        ,EXP_SUR_LMT                     --敞口剩余额度
        ,CUR                             --币种
        ,CRDT_SUBJ_TYP                   --授信主体类型
        ,MIN(EFF_DT) OVER(PARTITION BY CRDT_CONT_ID ORDER BY EFF_DT NULLS LAST) AS EFF_DT --生效日期
        ,CRDT_STAT                       --授信状态
        ,MIN(CRDT_APP_DT) OVER(PARTITION BY CRDT_CONT_ID ORDER BY CRDT_APP_DT NULLS LAST) CRDT_APP_DT --授信申请日期
        ,MIN(CRDT_START_DT) OVER(PARTITION BY CRDT_CONT_ID ORDER BY CRDT_START_DT NULLS LAST) CRDT_START_DT  --授信开始日期
        ,MAX(CRDT_EXP_DT) OVER(PARTITION BY CRDT_CONT_ID ORDER BY CRDT_EXP_DT NULLS LAST) CRDT_EXP_DT --授信到期日期
        ,CRDT_BIZ_TYP                    --授信业务类型
        ,CIR_LMT_FLG                     --循环额度标志
        ,TEMP_LMT_FLG                    --临时额度标志
        ,CRDT_SUBJ_CL                    --授信主体种类
        ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
        ,NVL(TRIM(DSN_SHT_OPN),'同意') DSN_SHT_OPN --决策单意见
        ,APRV_PSN_NO                     --审批人工号
        ,CRDT_EMP_NO                     --授信员工号
        ,DEPT_LINE                       --部门条线
        ,DATA_SRC                        --数据来源
        ,T.LMT_TYPE_CD                   --额度类型代码
        ,T.LOAN_HAPP_TYPE_CD             --合同发生类型
        ,T.RELA_CONT_ID                  --原合同编号
        ,ROW_NUMBER() OVER(PARTITION BY CRDT_CONT_ID,PRIM_CRDT_CONT_ID ORDER BY CRDT_STAT DESC,CRDT_APP_DT DESC NULLS LAST) RN
    FROM RRP_MDL.M_CRDT_LMT_SUB_TEMP04 T
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TB
      ON TB.ORG_ID = SUBSTR(T.ORG_ID,1,3)
   WHERE TRIM(CRDT_CONT_ID) IS NOT NULL
     AND TRIM(PRIM_CRDT_CONT_ID) IS NOT NULL
     )

   SELECT  DATA_DT                         --数据日期
          ,LGL_REP_ID                      --法人编号
          ,PRIM_CRDT_CONT_ID               --主授信合同编号
          ,CRDT_CONT_ID                    --授信合同编号
          ,CRDT_CONT_NM                    --授信合同名称
          ,CUST_ID                         --客户编号
          ,ORG_ID                          --机构编号
          --,CRDT_LMT                        --授信额度
          ,CASE WHEN NVL(CRDT_LMT,0) < NVL(ALDY_USE_LMT,0)
                THEN NVL(ALDY_USE_LMT,0)
                ELSE NVL(CRDT_LMT,0)
            END ALDY_USE_LMT               --授信额度
          ,ALDY_USE_LMT                    --已用额度
          ,SUR_CRDT_LMT                    --剩余授信额度
          ,EXP_CRDT_LMT                    --敞口授信额度
          ,EXP_ALDY_USE_LMT                --敞口已用额度
          ,EXP_SUR_LMT                     --敞口剩余额度
          ,CUR                             --币种
          ,CRDT_SUBJ_TYP                   --授信主体类型
          ,EFF_DT                          --生效日期
          ,CRDT_STAT                       --授信状态
          ,CASE WHEN CRDT_APP_DT < CRDT_START_DT THEN CRDT_START_DT
                ELSE CRDT_APP_DT
            END                            --授信申请日期
          ,CRDT_START_DT                   --授信开始日期
          ,CRDT_EXP_DT                     --授信到期日期
          ,CRDT_BIZ_TYP                    --授信业务类型
          ,CIR_LMT_FLG                     --循环额度标志
          ,TEMP_LMT_FLG                    --临时额度标志
          ,CRDT_SUBJ_CL                    --授信主体种类
          ,BANK_TAX_COOP_LOAN_CRDT_FLG     --银税合作贷款授信标志
          ,REPLACE(REPLACE(TRIM(DSN_SHT_OPN),CHR(10),''),CHR(13),'') DSN_SHT_OPN --决策单意见
          ,APRV_PSN_NO                     --审批人工号
          ,CRDT_EMP_NO                     --授信员工号
          ,DEPT_LINE                       --部门条线
          ,DATA_SRC                        --数据来源
          ,LMT_TYPE_CD                     --额度种类代码
          ,LOAN_HAPP_TYPE_CD               --合同发生类型
          ,RELA_CONT_ID                    --原合同编号
     FROM TMP1
     WHERE RN = 1;


  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

*/
   -- 程序跑批结束记录 --
   
   V_STEP_DESC := '程序跑批结束';
   O_ERRCODE   := '0';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
   COMMIT;

   -- 程序异常处理部分 --
   EXCEPTION
   WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_CRDT_LMT_SUB;
/

