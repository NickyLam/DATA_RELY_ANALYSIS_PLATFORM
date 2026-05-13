CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GUA_CONT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_GUA_CONT_INFO
  *  功能描述：担保合同信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_CONT_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20221201  hulj      新增字段担保人编号、担保人名称
  *             4    20240110  hulj      调整TMP表零售部分额度合同取值，改从零售贷款合同表直取
  *             5    20240703  LYH       增加 担保人国家和地区代码 字段
  *             6    20250825  YJY       一表通需求：新增一表通担保合同状态字段
  *             7    20251013  YJY       押品重构需求，调整数据取数来源，抵质押率取数规则：CMM_COL_GUAR_CONT_RELA.MTG_RAT
  *             8    20251029  LIP       增加业务合同对应的业务类型
  *             9    20251225  YJY       一表通报送要求也要包含本年内失效的担保合同将前一天的担保合同与当前跑批日期的担保合同对比
                                         没关联到的担保合同按照失效合同统计，其数据日期定义为担保合同的失效日期
  ***********************************************************************/
AS
  -- 定义变量 --
  V_P_DATE            VARCHAR2(8);                             --跑批数据日期
  V_STARTTIME         DATE;                                    --处理开始时间
  V_ENDTIME           DATE;                                    --处理结束时间
  V_SQLMSG            VARCHAR2(300);                           --SQL执行描述信息
  V_STEP_DESC         VARCHAR2(200);                           --任务名称
  V_DATE              DATE;                                    --数据日期
  V_START_DT          DATE;                                    --月初时点
  V_PART_NAME         VARCHAR2(100);                           --分区名
  V_STEP              INTEGER := 0;                            --处理步骤
  V_SQLCOUNT          INTEGER := 0;                            --更新或删除影响的记录数
  V_TAB_NAME          VARCHAR2(100) := 'M_GUA_CONT_INFO';      --表名
  V_PROC_NAME         VARCHAR2(100) := 'ETL_M_GUA_CONT_INFO';  --程序名称
  V_SYSTEM            VARCHAR2(30):= '监管报送';               --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR(I_P_DATE); --获取跑批日期
  V_DATE      := TO_DATE(V_P_DATE,'YYYYMMDD');
  V_START_DT  := TRUNC(V_DATE,'MM');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_GUA_CONT_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_GUA_CONT_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
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

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '担保合同信息--被担保业务类型';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_GUA_CONT_INFO_TMP';
  COMMIT;
  --担保合同信息--被担保业务类型
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TMP(CONT_ID,CONT_TYPE,EXP_DT,PAYOFF_DT,CONT_MGMT_ID)
  WITH TMP_LOAN_LMT_CONT AS (--授信合同和业务合同的汇总数据
  SELECT /*+MATERIALIZE*/CONT_ID,EXP_DT,TRIM(MGMT_TELLER_ID) CONT_MGMT_ID
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --对公贷款合同信息
   UNION ALL
  SELECT CONT_ID,TERMNT_DT,TRIM(CUST_MGR_ID) CONT_MGMT_ID
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --零售贷款合同信息
   UNION ALL
  SELECT LMT_CONT_ID,EXP_DT,CUST_MGR_ID CONT_MGMT_ID
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO  --零售贷款授信额度信息20230130 XUXIAOBIN ADD
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP_LOAN_CONT_LMT_RELA AS (--授信合同和贷款合同的关系 --MOD BY 20250115 合同层也取一次合同的类型
  SELECT /*+MATERIALIZE*/
         DISTINCT CONT_ID,LMT_CONT_ID,
         CASE WHEN STD_PROD_ID = '601010100001' THEN '02' --承兑汇票
              --MODIFY BY LUZM 20221024 原逻辑用的旧产品编号
              WHEN STD_PROD_ID IN ('601030100001','601030100002','601030100003','601030100004','601030100005',
                    '601030100006','601030100007','601030200001','601030200002','601030200003','601030200004',
                    '601030200005','601030200006','601030200007','603030100001','603030200001')
              THEN '03' --保函
              WHEN STD_PROD_ID IN ('601020100001','601020200001','601020100002','601020200002','603010100002','603010300002')
              THEN '04' --信用证
              WHEN STD_PROD_ID IN ('602030100001','602030100002') THEN '06' --委托贷款
              WHEN STD_PROD_ID LIKE '20%' THEN '01' --表内信贷
              ELSE '99'
          END AS CONT_TYPE
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO --对公贷款合同信息
   WHERE NVL(LMT_CONT_ID,' ') <> ' '
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT DISTINCT B.CONT_ID,B.LMT_CONT_ID,
         CASE WHEN PROD_ID IN ('602030100001','602030100002') THEN '06' --委托贷款
              WHEN PROD_ID LIKE '20%' THEN '01' --表内信贷
              ELSE '99'
          END AS CONT_TYPE
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO B  --零售贷款合同信息
   WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP_DUBIL_INFO AS (--有放款记录的业务合同对应担保类型映射
  SELECT /*+MATERIALIZE*/A.CONT_ID,
         CASE WHEN A.STD_PROD_ID = '601010100001' THEN '02' --承兑汇票
              --MODIFY BY LUZM 20221024 原逻辑用的旧产品编号
              WHEN A.STD_PROD_ID IN ('601030100001','601030100002','601030100003','601030100004','601030100005',
                    '601030100006','601030100007','601030200001','601030200002','601030200003','601030200004',
                    '601030200005','601030200006','601030200007','603030100001','603030200001')
              THEN '03' --保函
              WHEN A.STD_PROD_ID IN ('601020100001','601020200001','601020100002','601020200002','603010100002','603010300002')
              THEN '04' --信用证
              WHEN A.STD_PROD_ID IN ('602030100001','602030100002') THEN '06' --委托贷款
              WHEN A.STD_PROD_ID LIKE '20%' THEN '01' --表内信贷
              ELSE '99'
          END AS CONT_TYPE, --其他
         NVL(A.PAYOFF_DT,TO_DATE('20991231','YYYYMMDD')) AS PAYOFF_DT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A  --对公贷款借据信息
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT B.CONT_ID,
         CASE WHEN B.STD_PROD_ID IN ('602030100001','602030100002') THEN '06' --委托贷款
              WHEN B.STD_PROD_ID LIKE '20%' THEN '01' --表内信贷
              ELSE '99'
          END AS CONT_TYPE, --其他
         NVL(B.PAYOFF_DT,TO_DATE('20991231','YYYYMMDD')) AS PAYOFF_DT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B  --零售贷款借据信息
   WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT A.GUAR_CONT_ID,
         --MIN(NVL(C.CONT_TYPE,D.CONT_TYPE)) AS CONT_TYPE,
         MIN(COALESCE(C.CONT_TYPE,E.CONT_TYPE,D.CONT_TYPE)) AS CONT_TYPE, --MOD BY LIP 20251029 增加业务合同对应的业务类型
         MAX(B.EXP_DT) AS EXP_DT,
         MAX(C.PAYOFF_DT) AS PAYOFF_DT,
         MAX(CONT_MGMT_ID) AS CONT_MGMT_ID
    FROM RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA A  --贷款合同与担保合同关系
   INNER JOIN TMP_LOAN_LMT_CONT B
      ON B.CONT_ID = A.LOAN_CONT_ID
    LEFT JOIN TMP_LOAN_CONT_LMT_RELA D --被担保合同是授信合同的情况
      ON D.LMT_CONT_ID = A.LOAN_CONT_ID
    LEFT JOIN TMP_LOAN_CONT_LMT_RELA E --MOD BY LIP 20251029 --被担保合同是业务合同的情况
      ON E.CONT_ID = A.LOAN_CONT_ID
    LEFT JOIN TMP_DUBIL_INFO C --业务合同有放款的情况
      ON C.CONT_ID = NVL(D.CONT_ID,A.LOAN_CONT_ID)
   WHERE (B.EXP_DT >= V_START_DT OR (B.EXP_DT < V_START_DT AND C.PAYOFF_DT >= V_START_DT)) --取合同未到期的及合同到期但是借据未结清的
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.GUAR_CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --ADD BY LIP 20231106 增加联合网贷数据，排除掉借据已结清或者核销的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '担保合同信息--被担保业务类型--联合网贷部分';
  V_STARTTIME := SYSDATE;
  --担保合同信息--被担保业务类型
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TMP
    (CONT_ID, CONT_TYPE,EXP_DT,PAYOFF_DT)
  SELECT A.GUAR_CONT_ID        AS GUAR_CONT_ID,
         '01'                  AS CONT_TYPE,
         MAX(A.EXP_DT)         AS EXP_DT,
         MAX(D.PAYOFF_DT)      AS PAYOFF_DT
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A --联合网贷担保合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B --联合网贷贷款与担保合同关系
      ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO C --联合网贷贷款合同信息
      ON C.CONT_ID = B.LOAN_CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO D --联合网贷借据信息
      ON D.CONT_ID = C.CONT_ID
     AND D.DUBIL_STATUS_CD NOT IN ('2','5')
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO E  --联合网贷核销信息
      ON E.DUBIL_ID = D.DUBIL_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE ((LEAST(CASE WHEN D.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE(V_P_DATE,'YYYYMMDD') ELSE D.PAYOFF_DT END,
                 CASE WHEN D.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                      ELSE D.LAST_REPAY_DT END) >= V_START_DT 
          AND NVL(D.IN_BS_INT,0) + NVL(D.CURRT_BAL,0)+ NVL(D.OFF_BS_INT,0)+NVL(D.BAD_DEBT_PRIC,0) >= 0)
           OR NVL(D.IN_BS_INT,0) + NVL(D.CURRT_BAL,0) > 0
           OR D.WRT_OFF_FLG = '1')
     AND (NVL(E.FIR_WRT_OFF_DT,V_DATE) >= V_START_DT OR E.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')) --取借据未到期的及借据到期但是借据未结清的
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.GUAR_CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '担保合同信息--整合贷款余额--普通贷款';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_GUA_CONT_INFO_TEMP01';
  --普通贷款
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --源贷款余额
     ,CLOS_ACCT_DT         --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(B,A,C,D,O)*/
          B.DUBIL_NUM                       AS RCPT_ID             --借据号
         ,B.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,B.CUST_ID                         AS CUST_ID              --客户号
         ,TRIM(D.CUST_ID)                   AS LMT_CUST_ID          --授信客户号
         ,B.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,A.STD_PROD_ID                     AS LOAN_PROD_ID         --产品号
         ,NVL(B.CURR_CD, 'CNY')             AS CUR                  --币种
         ,B.DISTR_AMT                       AS LOAN_AMT             --放款金额
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%'
                         THEN NVL(B.OVDUE_PRIC_BAL, 0) + NVL(B.IDLE_PRIC, 0) + NVL(B.BAD_DEBT_PRIC, 0)
                         ELSE NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0)
                     END
           END                              AS LOAN_BAL             --贷款余额
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                         WHEN B.SUBJ_ID IN ('30070102') THEN 0
                         WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%') THEN NVL(B.IN_BS_INT, 0)
                         WHEN A.STD_PROD_ID IN('203020300002','203030600002','203020300001','203030600001') --福费廷
                         THEN NVL(B.IN_BS_INT, 0)
                         ELSE 0
                     END
           END                              AS INT_ADJ              --利息调整
         ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
               WHEN B.WRT_OFF_FLG <> '1'
               THEN CASE WHEN B.SUBJ_ID LIKE '1313%' THEN 0
                         WHEN B.SUBJ_ID IN ('30070102') THEN 0
                         WHEN A.STD_PROD_ID IN('203040600001') AND B.SUBJ_ID IN( '13050201%') THEN NVL(O.N_PV_VARIATION, 0)
                         WHEN A.STD_PROD_ID IN('203030600002','203020300002','203020300001','203030600001')
                         THEN NVL(O.N_PV_VARIATION, 0)
                         ELSE 0
                     END
           END                              AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(B.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'普通贷款'                        AS DATA_SRC_DESC        --数据来源中文
         ,B.PRIC_BAL                        AS BAL                  --源贷款本金余额
         ,CASE WHEN B.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') 
               THEN TO_DATE('99991231','YYYYMMDD')
               ELSE B.CLOS_ACCT_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B    --对公贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表 --以账户为主表关联
      ON A.DUBIL_ID = B.DUBIL_NUM
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O  --估值报告表 关联估值表取 国内信用证福费廷 公允价值变动
      ON O.V_TRADE_NO = B.DUBIL_NUM
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*( A.BUS_BREED_ID LIKE '1%' OR A.BUS_BREED_ID LIKE '2070%' OR A.BUS_BREED_ID IS NULL OR A.BUS_BREED_ID IN ('203020112','203020210','4030010020')
         OR C.BUS_BREED_ID LIKE '1%' OR C.BUS_BREED_ID LIKE '2070%' OR C.BUS_BREED_ID IS NULL OR A.BUS_BREED_ID IN ('203020112','203020210','4030010020'))
     AND (B.OPEN_ACCT_DT <> B.CLOS_ACCT_DT
         OR (B.OPEN_ACCT_DT = B.CLOS_ACCT_DT AND NVL(A.BUS_BREED_ID,C.BUS_BREED_ID) IN ('1060080','203020112','203020210','4030010020'))
          )  --经业务严希婧确认，贸易融资五笔数据为真实发生，不能筛除
     AND */(C.CRDT_TYPE_CD = '02' OR C.CRDT_TYPE_CD IS NULL ) --00未知 01额度合同  02业务合同
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--贴现部分';
  V_STARTTIME := SYSDATE;
  --贴现部分
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --源贷款本金余额
     ,CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(B1,A,C,D,O)*/
          A.DUBIL_ID                        AS RCPT_ID             --借据号
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(B1.BILL_NUM)                 AS BILL_NO              --票据号
         ,TRIM(C.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,TRIM(A.CUST_ID)                   AS CUST_ID              --客户号
         ,TRIM(D.CUST_ID)                   AS LMT_CUST_ID          --授信客户号
         ,B1.ENTER_ACCT_ORG_ID              AS ORG_ID               --机构号
         ,A.BUS_BREED_ID                    AS LOAN_PROD_ID         --产品号
         ,NVL(B1.CURR_CD, 'CNY')            AS CUR                  --币种
         ,A.DUBIL_AMT                       AS LOAN_AMT             --放款金额
         ,CASE WHEN A.PAYOFF_DT >= V_DATE
              THEN ROUND((NVL(B1.CURRT_BAL, 0)),2)
              ELSE 0
          END                               AS LOAN_BAL             --贷款余额
         ,NVL(B1.INT_ADJ_BAL, 0)            AS INT_ADJ              --利息调整
         ,NVL(O.N_PV_VARIATION, 0)          AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(B1.JOB_CD,1,4))      AS DATA_SRC             --数据来源
         ,'贴现'                            AS DATA_SRC_DESC        --数据来源中文
         ,B1.CURRT_BAL                      AS BAL                  --原贷款本金余额
         ,CASE WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
              ELSE A.PAYOFF_DT
          END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO B1  -- 票据贴现信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
     --MOD BY 20231102 调整关联条件
      ON A.BILL_UNIQ_MARK_ID = NVL(TRIM(B1.BILL_ENTRY_ID),B1.BILL_ID)
     AND TRIM(A.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND A.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND NVL(TRIM(C.CRDT_TYPE_CD),'02') = '02'
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O  --估值报告表 关联估值表取 国内信用证福费廷 公允价值变动
     --MOD BY 20231102 调整关联条件
      ON O.V_TRADE_NO = B1.BILL_ID
     AND O.V_BUSINESSTYPE = A.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B1.DISCNT_STATUS_CD IN ('06')   --06 记账完成 CD1270
     AND B1.ENTRY_STATUS_CD = '03'
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--买断式转贴现部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --源贷款本金余额
     ,CLOS_ACCT_DT         --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(A,C,F2,D,DD,O)*/
          F2.DUBIL_ID                       AS RCPT_ID             --借据号
         ,F2.CONT_ID                        AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,F2.CUST_ID                        AS CUST_ID              --客户号
         ,TRIM(DD.CUST_ID)                  AS LMT_CUST_ID          --授信客户号
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,F2.BUS_BREED_ID                   AS LOAN_PROD_ID         --产品号
         ,NVL(A.CURR_CD, 'CNY')             AS CUR                  --币种
         ,A.FAC_VAL_AMT                     AS LOAN_AMT             --放款金额
         ,CASE WHEN F2.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND F2.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND C.PAYOFF_FLG = '0'
              THEN ROUND((NVL(A.CURRT_BAL, 0)),2)  --根据行里报送，需加上发放日小于月末且结清日期为月末当天的数据
              WHEN NVL(A.CURRT_BAL, 0) > 0 AND F2.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN ROUND((NVL(A.CURRT_BAL, 0)),2)
              ELSE 0
          END                              AS LOAN_BAL             --贷款余额
         ,CASE WHEN F2.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND F2.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND C.PAYOFF_FLG = '0'
              THEN NVL(A.INT_ADJ_BAL, 0)
              WHEN NVL(A.CURRT_BAL, 0) > 0 AND F2.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN NVL(A.INT_ADJ_BAL, 0)
              ELSE 0
          END                              AS INT_ADJ              --利息调整
         ,NVL(O.N_PV_VARIATION, 0)          AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'买断式转贴现'                    AS DATA_SRC_DESC        --数据来源中文
         ,A.CURRT_BAL                       AS BAL                  --原贷款本金余额
         ,CASE WHEN F2.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
               ELSE F2.PAYOFF_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A  --票据转贴现信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO F2  --对公贷款借据信息
      ON F2.BILL_ID = A.BILL_ID
     AND F2.STD_PROD_ID IN ('204010100001','204010100002')  --承兑汇票转贴现
     AND F2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO C --票据中心信息
      ON C.BILL_ID = A.BILL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = F2.CONT_ID
     AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO DD  --对公贷款合同信息表
      ON DD.CONT_ID = D.LMT_CONT_ID
     AND DD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表 关联估值表取 转贴现 公允价值变动
      ON O.V_TRADE_NO = A.BILL_ID
     AND O.V_BUSINESSTYPE = F2.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD = '01'  --买入
     AND A.BUS_TYPE_CD = 'BT01'  --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --记账成功
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--信用证部分';
  V_STARTTIME := SYSDATE;
  --信用证部分
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    (RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --原贷款本金余额
     ,CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(A,C,D)*/
          C.DUBIL_ID                        AS RCPT_ID             --借据号
         ,C.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.LC_ID)                     AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 表外的不用算转授信
         ,A.CUST_ID                         AS CUST_ID              --客户号
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,C.BUS_BREED_ID                    AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.ISSUE_AMT                       AS LOAN_AMT             --放款金额
         ,C.NOMAL_PRIC                      AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'信用证部分'                      AS DATA_SRC_DESC        --数据来源中文
         ,C.NOMAL_PRIC                      AS BAL                  --原贷款本金余额
         ,CASE WHEN A.WRTOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
              ELSE A.WRTOFF_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_LC_ACCT_INFO A    --信用证账户信息表
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C --对公贷款借据信息表
      ON C.DUBIL_ID = A.DUBIL_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = C.CONT_ID
      AND (D.CRDT_TYPE_CD = '02' OR D.CRDT_TYPE_CD IS NULL) --取业务合同
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE(A.STD_PROD_ID LIKE '5010%'
        OR A.STD_PROD_ID LIKE '60102%'
        OR A.STD_PROD_ID LIKE '60301%'
        OR A.STD_PROD_ID LIKE '6010103%'
        OR A.STD_PROD_ID LIKE '6030202%'
        OR A.STD_PROD_ID LIKE '203030'
        OR A.STD_PROD_ID LIKE '203020%')
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--保函部分';
  V_STARTTIME := SYSDATE;
  --保函部分
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --原贷款本金余额
     ,CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          C.DUBIL_ID                        AS RCPT_ID             --借据号
         ,C.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.ACCT_ID)                   AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,NVL(C.CUST_ID, B.CUST_ID)         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 表外的不用算转授信
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,C.BUS_BREED_ID                    AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.LOG_AMT                         AS LOAN_AMT             --放款金额
         ,A.CURRT_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'保函部分'                        AS DATA_SRC_DESC        --数据来源中文
         ,A.CURRT_BAL                       AS BAL                  --原贷款本金余额
         ,CASE WHEN A.WRTOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
               ELSE A.WRTOFF_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO A    --保函账户信息表
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO B   --存款客户账户信息表
      ON B.CUST_ACCT_ID = A.STL_ACCT_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C  --对公贷款借据信息表
      ON C.DUBIL_ID = A.LOG_CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = C.CONT_ID
     AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'--取业务合同
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (A.STD_PROD_ID LIKE '60103010000%' OR A.STD_PROD_ID LIKE '60103020000%')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--银承部分';
  V_STARTTIME := SYSDATE;
  --银承部分
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --原贷款本金余额
     ,CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
          C.DUBIL_ID                        AS RCPT_ID             --借据号
         ,C.CONT_ID                         AS CONT_ID              --合同号
         ,TRIM(A.BILL_NUM)                  AS BILL_NO              --票据号
         ,TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID          --授信合同号
         ,NVL(C.CUST_ID, B.CUST_ID)         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 表外的不用算转授信
         ,A.ACPT_ORG_ID                     AS ORG_ID               --机构号
         ,C.BUS_BREED_ID                    AS LOAN_PROD_ID         --产品号
         ,A.FAC_VAL_CURR                    AS CUR                  --币种
         ,A.FAC_VAL_AMT                     AS LOAN_AMT             --放款金额
         ,A.CURRT_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'银承部分'                        AS DATA_SRC_DESC        --数据来源中文
         ,A.CURRT_BAL                       AS BAL                  --原贷款本金余额
         ,CASE WHEN A.CLOSE_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
               ELSE A.CLOSE_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_BA_ACCT_INFO A    --银承账户信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO C  --对公贷款借据信息表
      ON C.BILL_NUM = A.BILL_NUM
     AND C.BUS_BREED_ID LIKE '2010%'
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO B  --存款客户账户信息表
      ON B.CUST_ACCT_ID = A.STL_ACCT_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
      ON D.CONT_ID = C.CONT_ID
     AND NVL(TRIM(D.CRDT_TYPE_CD),'02') = '02'--取业务合同
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--整合贷款余额--零售部分';
  V_STARTTIME := SYSDATE;
  --零售部分
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO_TEMP01
    ( RCPT_ID              --借据号
     ,CONT_ID              --合同号
     ,BILL_NO              --票据号
     ,LMT_CONT_ID          --授信合同号
     ,CUST_ID              --客户号
     ,LMT_CUST_ID          --授信客户号
     ,ORG_ID               --机构号
     ,LOAN_PROD_ID         --产品号
     ,CUR                  --币种
     ,LOAN_AMT             --放款金额
     ,LOAN_BAL             --贷款余额
     ,INT_ADJ              --利息调整
     ,FAIR_VAL_CHG         --公允价值变动
     ,DATA_SRC             --数据来源
     ,DATA_SRC_DESC        --数据来源中文
     ,BAL                  --原贷款本金余额
     ,CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    )
  SELECT /*+USE_HASH(A,B,C,D,E,F)*/
          A.DUBIL_NUM                       AS RCPT_ID              --借据号
         ,A.CONT_ID                         AS CONT_ID              --合同号
         ,NULL                              AS BILL_NO              --票据号
         ,COALESCE(TRIM(D.LMT_CONT_ID),TRIM(E.LMT_CONT_ID),TRIM(F.LMT_CONT_ID),
                  TRIM(C.APV_FLOW_NUM),TRIM(A.CONT_ID)) AS LMT_CONT_ID --授信合同号
         ,A.CUST_ID                         AS CUST_ID              --客户号
         ,NULL                              AS LMT_CUST_ID          --授信客户号 零售先不看这个
         ,A.ACCT_INSTIT_ID                  AS ORG_ID               --机构号
         ,B.BUS_BREED_ID                    AS LOAN_PROD_ID         --产品号
         ,A.CURR_CD                         AS CUR                  --币种
         ,A.DUBIL_AMT                       AS LOAN_AMT             --放款金额
         ,A.CURRT_BAL                       AS LOAN_BAL             --贷款余额
         ,0                                 AS INT_ADJ              --利息调整
         ,0                                 AS FAIR_VAL_CHG         --公允价值变动
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC             --数据来源
         ,'零售部分'                        AS DATA_SRC_DESC        --数据来源中文
         ,A.CURRT_BAL                       AS BAL                  --原贷款本金余额
         ,CASE WHEN A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') THEN TO_DATE('99991231','YYYYMMDD')
               ELSE A.CLOS_ACCT_DT
           END                              AS CLOS_ACCT_DT          --销户日期 --ADD BY 20240321
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A    --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C  --零售贷款合同信息
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO D  --零售贷款授信额度信息
      ON D.LMT_APPL_FLOW_NUM = C.APV_FLOW_NUM
     AND D.STATUS_CD NOT IN ('00')
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO E  --零售贷款授信额度信息
      ON E.LMT_APPL_FLOW_NUM = C.APV_FLOW_NUM
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO F  --零售贷款授信额度信息
      ON F.LMT_CONT_ID = C.APV_FLOW_NUM
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '担保合同信息--抵质押率';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_RATE';
  COMMIT;
  --20220818 MODIFY BY LIP 增加零售部分取数逻辑，调整子查询改为WITH查询
  /*EAST与金数不一致：
  1、金数只需要对公部分的计算抵质押率；
  2、金数算抵质押率时，不需加上表外部分和贴现、买断式转贴现部分的本金余额部分；*/
  INSERT INTO RRP_MDL.TMP_RATE (CONT_ID, COLLATERAL_RATIO,COLLATERAL_RATIO_ORIG)
    WITH LMT_CONT_RELA AS  --额度合同和业务合同的关系
      (SELECT /*+MATERIALIZE*/A1.CONT_ID,A1.LMT_CONT_ID
         FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A1
        WHERE TRIM(A1.LMT_CONT_ID) IS NOT NULL
          AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       UNION ALL
       SELECT DISTINCT CONT_ID,LMT_CONT_ID
         FROM RRP_MDL.M_GUA_CONT_INFO_TEMP01 TA
        WHERE TA.LMT_CONT_ID IS NOT NULL
          AND TA.DATA_SRC_DESC = '零售部分'),
    GUAR_CONT_RELA AS --担保合同和业务合同关系
      (SELECT /*+MATERIALIZE*/DISTINCT
              NVL(C.CONT_ID,A.LOAN_CONT_ID) AS LOAN_CONT_ID  -- 业务合同号
              ,A.GUAR_CONT_ID,A.ETL_DT
         FROM RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA A --贷款合同与担保合同关系表
         LEFT JOIN LMT_CONT_RELA C --将额度合同转换成业务合同处理
           ON A.LOAN_CONT_ID = C.LMT_CONT_ID
        WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    GUAR_CONT_BALANCE_SUM AS --担保合同下所有借据的本金余额总额
      (SELECT /*+MATERIALIZE*/A.GUAR_CONT_ID
              ,SUM(CASE WHEN D.CUR = 'CNY' THEN D.LOAN_BAL ELSE D.LOAN_BAL*U.CNY_EXCH_RAT END) BALANCE
              ,SUM(CASE WHEN D.DATA_SRC_DESC <> '普通贷款' THEN 0
                        ELSE (CASE WHEN D.CUR = 'CNY' THEN D.BAL ELSE D.BAL*U.CNY_EXCH_RAT END)
                    END) BALANCE_ORIG
         FROM GUAR_CONT_RELA A
        INNER JOIN RRP_MDL.M_GUA_CONT_INFO_TEMP01 D --所有借据的余额整合
           ON D.CONT_ID = A.LOAN_CONT_ID
         LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT B --担保合同表
           ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
          AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         LEFT JOIN RRP_MDL.O_ICL_CMM_EXCH_RAT_INFO U
           ON U.CURR_CD = D.CUR --基准币种
          AND U.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.GUAR_CONT_ID),
    GUAR_COL_CFM_VAL_SUM AS --担保合同下所有押品的估值总额
      (SELECT /*+MATERIALIZE*/A.GUAR_CONT_ID
              ,SUM(CASE WHEN B.ESTIM_CURR_CD = 'CNY' THEN B.HXB_CFM_VAL ELSE B.HXB_CFM_VAL*U.CNY_EXCH_RAT END) HXB_CFM_VAL
         FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA A  --押品与担保合同关系表
         LEFT JOIN RRP_MDL.O_ICL_CMM_COL_INFO B  --押品信息
           ON B.COL_ID = A.COL_ID
          AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         LEFT JOIN RRP_MDL.O_ICL_CMM_EXCH_RAT_INFO U
           ON U.CURR_CD = B.ESTIM_CURR_CD --基准币种"
          AND U.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        WHERE (B.GUAR_WAY_CD LIKE 'DY%' OR B.GUAR_WAY_CD LIKE 'ZY%')
          AND B.GUAR_WAY_CD NOT IN ('ZY0102','ZY0102001','ZY0102002','ZY9901005') --不含保证金担保
          AND B.INSTO_STATUS_CD IN ('02','03')
          AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.GUAR_CONT_ID)
  SELECT A.GUAR_CONT_ID,
         CASE WHEN B.HXB_CFM_VAL = 0 OR B.HXB_CFM_VAL IS NULL THEN NULL
              ELSE A.BALANCE/B.HXB_CFM_VAL*100
          END AS COLLATERAL_RATIO,
         CASE WHEN B.HXB_CFM_VAL = 0 OR B.HXB_CFM_VAL IS NULL THEN NULL
              ELSE A.BALANCE_ORIG/B.HXB_CFM_VAL*100
          END AS COLLATERAL_RATIO_ORIG
    FROM GUAR_CONT_BALANCE_SUM A
   INNER JOIN GUAR_COL_CFM_VAL_SUM B
      ON B.GUAR_CONT_ID = A.GUAR_CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '插入担保合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,GUA_CONT_ID        --担保合同号
    ,ORG_ID             --机构编号
    ,GUA_TYP            --担保类型
    ,GUA_CONT_TYP       --担保合同类型
    ,GUA_BIZ_TYP        --被担保业务类型
    ,GUA_CONT_STAT      --担保合同状态
    ,GUA_CONT_SIGN_DT   --担保合同签订日期
    ,GUA_CONT_EFF_DT    --担保合同生效日期
    ,GUA_CONT_EXP_DT    --担保合同到期日期
    ,CUR                --币种
    ,GUA_CONT_AMT       --担保合同金额
    ,GUAR_NET_AST       --保证人净资产
    ,ESTBL_EMP_NO       --建立员工号
    ,MTG_PLG_RTO        --抵质押率
    ,APRV_MTG_PLG_RTO   --审批抵质押率
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    ,GUA_RATIO          --担保比例
    ,MTG_PLG_RTO_ORIG   --原抵质押率
    ,GUAR_IDY_TYP       --担保人行业类型
    ,GUAR_RGN           --担保人地区
    ,GUAR_ECON_DEPT     --担保人国民经济部门类型
    ,GUAR_ENT_SCALE     --担保人企业规模
    ,GUAR_CRDL_TYP      --担保人主证件类型
    ,GUAR_CRDL_NO       --担保人主证件号码
    ,ACTL_MTG_PLG_RTO   --实际抵质押率
    ,GUAR_ID            --担保人编号 add by hulj 20221201
    ,GUAR_NM            --担保人名称 add by hulj 20221201
    ,GUAR_CTY_CD        --注册国家/地区代码
    ,LOAN_MON_FLAG      --借据是否当月内有效 --ADD BY 20240321
    ,GUARTOR_CTY_RG_CD  --担保人国家和地区代码  --ADD BY LYH 20240703
    ,GUA_CONT_STAT_YBT  --一表通担保合同状态  --ADD BY YJY 20250825
    ) 
  WITH TMP1 AS (
    --ADD BY 20240321 获取当月销户或是余额不为0的业务/额度合同
    SELECT CONT_ID FROM RRP_MDL.M_GUA_CONT_INFO_TEMP01
     WHERE (CLOS_ACCT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') OR LOAN_BAL <> 0)
     UNION ALL
    SELECT LMT_CONT_ID FROM RRP_MDL.M_GUA_CONT_INFO_TEMP01
     WHERE (CLOS_ACCT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') OR LOAN_BAL <> 0)),
  GUA_CONT_INFO_TEMP01 AS (
    SELECT TA.GUAR_CONT_ID FROM TMP1 T
     INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA TA
        ON TA.LOAN_CONT_ID = T.CONT_ID
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY TA.GUAR_CONT_ID)
  SELECT V_P_DATE                                   AS DATA_DT            --数据日期
         ,A.LP_ID                                   AS LGL_REP_ID         --法人编号
         ,A.GUAR_CONT_ID                            AS GUA_CONT_ID        --担保合同号
         ,A.RGST_ORG_ID                             AS ORG_ID             --机构编号  --担保合同表账务机构为空，先按旧逻辑取注册机构号
         ,CASE WHEN A.GUAR_WAY_CD = 'B' THEN 'A' --抵押
               WHEN A.GUAR_WAY_CD = 'A' THEN 'B' --质押
               WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '01' THEN 'C01'--单人保证
               WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '02' THEN 'C03'--多人联保
               WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '03' THEN 'C04'--多人分保
               WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '-'  THEN 'C'  --保证
               ELSE 'Z'
           END                                      AS GUA_TYP            --担保类型
         ,CASE WHEN A.GUAR_CONT_TYPE_CD = '1' THEN '01' --一般担保合同
               WHEN A.GUAR_CONT_TYPE_CD = '2' THEN '02'--最高额度担保合同
               ELSE '99' --未知
           END                                      AS GUA_CONT_TYP       --担保合同类型
         ,NVL(C.CONT_TYPE,'99')                     AS GUA_BIZ_TYP        --被担保业务类型
				 ,CASE WHEN A.STATUS_CD IN ('100','101','102','109','112') THEN 'Y' --生效 20221110 XUXIAOBIN MODIFY 110未签合同，剔除
               ELSE 'N' --已失效
           END                                      AS GUA_CONT_STAT      --担保合同状态
         ,CASE WHEN TO_CHAR(A.SIGN_DT,'YYYYMMDD') NOT IN ('00010101','29991231','99991231')
               THEN TO_CHAR(A.SIGN_DT,'YYYYMMDD')
               ELSE TO_CHAR(A.RGST_DT,'YYYYMMDD')
           END                                      AS GUA_CONT_SIGN_DT   --担保合同签订日
         ,CASE WHEN TO_CHAR(A.EFFECT_DT,'YYYYMMDD') = '29991231' THEN '00010101'
               ELSE TO_CHAR(A.EFFECT_DT,'YYYYMMDD')
           END                                      AS GUA_CONT_EFF_DT    --担保合同生效日
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              AS GUA_CONT_EXP_DT    --担保合同到期日
         ,DECODE(A.CURR_CD,'-','CNY',' ','CNY',A.CURR_CD) AS CUR          --币种
         ,A.GUAR_AMT                                AS GUA_CONT_AMT       --担保合同金额
         ,B.GUARTOR_NET_ASSET_AMT                   AS GUAR_NET_AST       --保证人净资产
         ,CASE WHEN UPPER(A.CUST_MGR_ID) = 'APPS' AND TRIM(C.CONT_MGMT_ID) IS NOT NULL THEN C.CONT_MGMT_ID
               ELSE TRIM(A.CUST_MGR_ID)
           END                                      AS ESTBL_EMP_NO       --客户经理编号
         ,NVL(F.COLLATERAL_RATIO,0)                 AS MTG_PLG_RTO        --抵质押率
         ,NULL                                      AS APRV_MTG_PLG_RTO   --审批抵质押率
         ,'800919'                                  AS DEPT_LINE          --部门条线 /*风险管理部*/
         ,SUBSTR(UPPER(A.JOB_CD),1,4)               AS DATA_SRC           --数据来源
         ,CASE WHEN NVL(A.GUAR_AMT,0) = 0 THEN 0
               ELSE A.OCUP_AMT/A.GUAR_AMT
           END                                      AS GUA_RATIO          --担保比例
         ,CASE WHEN F.COLLATERAL_RATIO_ORIG = 0 THEN NULL
               ELSE F.COLLATERAL_RATIO_ORIG
           END                                      AS MTG_PLG_RTO_ORIG   --原抵质押率
         ,A.GUARTOR_INDUS_TYPE_CD                   AS GUAR_IDY_TYP       --担保人行业类型
         ,A.GUARTOR_DIST_CD                         AS GUAR_RGN           --担保人地区
         ,A.GUARTOR_NATNAL_ECON_DEPT_TYPE_CD        AS GUAR_ECON_DEPT     --担保人国民经济部门类型
         ,CASE WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='1' THEN 'CS01'
               WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='2' THEN 'CS02'
               WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='3' THEN 'CS03'
               WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='4' THEN 'CS04'
               WHEN TRIM(A.GUARTOR_CORP_SIZE_CD)='9' THEN 'CS05'
               ELSE NULL
           END                                      AS GUAR_ENT_SCALE     --担保人企业规模
         ,A.GUARTOR_CERT_TYPE_CD                    AS GUAR_CRDL_TYP      --担保人主证件类型
         ,A.GUARTOR_CERT_NO                         AS GUAR_CRDL_NO       --担保人主证件号码
         ,T3.MTG_RAT                                AS ACTL_MTG_PLG_RTO   --实际抵质押率
         ,A.GUARTOR_ID                              AS GUAR_ID            --担保人编号 add by hulj 20221201
         ,A.GUARTOR_NAME                            AS GUAR_NM            --担保人名称 add by hulj 20221201
         ,COALESCE(ID.CTY_RG_CD,ID1.NATION_CD)      AS GUAR_CTY_CD        --注册国家/地区代码
         ,CASE WHEN E.GUAR_CONT_ID IS NOT NULL THEN 'Y'
               ELSE 'N'
           END                                      AS LOAN_MON_FLAG      --借据是否当月内有效 --ADD BY 20240321
         ,A.GUARTOR_CTY_RG_CD                       AS GUARTOR_CTY_RG_CD  --担保人国家和地区代码  --ADD BY LYH 20240703
         ,A.STATUS_CD                               AS GUA_CONT_STAT_YBT  --一表通担保合同状态
   FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A  --担保合同
   INNER JOIN RRP_MDL.M_GUA_CONT_INFO_TMP C --被担保业务类型   20251016
      ON C.CONT_ID = A.GUAR_CONT_ID
    LEFT JOIN GUA_CONT_INFO_TEMP01 E
      ON E.GUAR_CONT_ID = A.GUAR_CONT_ID
    LEFT JOIN (SELECT B.GUARTOR_ID,MAX(CURR_CD) AS CURR_CD,MAX(GUARTOR_NET_ASSET_AMT) AS GUARTOR_NET_ASSET_AMT
                 FROM RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B --押品保证人评级信息
                WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY B.GUARTOR_ID) B
      ON B.GUARTOR_ID = A.GUARTOR_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO ID
      ON ID.CUST_ID = A.GUARTOR_ID
     AND ID.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO ID1
      ON ID1.CUST_ID = A.GUARTOR_ID
     AND ID1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.TMP_RATE F
      ON F.CONT_ID = A.GUAR_CONT_ID
   LEFT JOIN (SELECT MAX(MTG_RAT) MTG_RAT,GUAR_CONT_ID
                 --FROM RRP_MDL.O_IML_AST_GUAR_QUAL_IDTFY
                 FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA --押品与担保合同关系 MOD BY YJY 20251013 
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY GUAR_CONT_ID) T3
      ON T3.GUAR_CONT_ID = A.GUAR_CONT_ID
   WHERE /*A.GUAR_AMT <> 0 --担保合同金额为0的为默认为担保合同失效
     AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '插入担保合同联合网贷部分信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_CONT_INFO
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,GUA_CONT_ID        --担保合同号
    ,ORG_ID             --机构编号
    ,GUA_TYP            --担保类型
    ,GUA_CONT_TYP       --担保合同类型
    ,GUA_BIZ_TYP        --被担保业务类型
    ,GUA_CONT_STAT      --担保合同状态
    ,GUA_CONT_SIGN_DT   --担保合同签订日期
    ,GUA_CONT_EFF_DT    --担保合同生效日期
    ,GUA_CONT_EXP_DT    --担保合同到期日期
    ,CUR                --币种
    ,GUA_CONT_AMT       --担保合同金额
    ,GUAR_NET_AST       --保证人净资产
    ,ESTBL_EMP_NO       --建立员工号
    ,MTG_PLG_RTO        --抵质押率
    ,APRV_MTG_PLG_RTO   --审批抵质押率
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    ,GUA_RATIO          --担保比例
    ,MTG_PLG_RTO_ORIG   --原抵质押率
    ,GUAR_IDY_TYP       --担保人行业类型
    ,GUAR_RGN           --担保人地区
    ,GUAR_ECON_DEPT     --担保人国民经济部门类型
    ,GUAR_ENT_SCALE     --担保人企业规模
    ,GUAR_CRDL_TYP      --担保人主证件类型
    ,GUAR_CRDL_NO       --担保人主证件号码
    ,ACTL_MTG_PLG_RTO   --实际抵质押率
    ,GUAR_ID            --担保人编号 add by hulj 20221201
    ,GUAR_NM            --担保人名称 add by hulj 20221201
    ,GUAR_CTY_CD        --注册国家/地区代码
    ,LOAN_MON_FLAG      --借据是否当月内有效 --ADD BY 20240321
    ,GUARTOR_CTY_RG_CD  --担保人国家和地区代码  --ADD BY LYH 20240703
    ,GUA_CONT_STAT_YBT  --一表通担保合同状态  --ADD BY YJY 20250825
    )
  SELECT V_P_DATE                                  AS DATA_DT             --数据日期
        ,A.LP_ID                                   AS LGL_REP_ID          --法人编号
        ,A.GUAR_CONT_ID                            AS GUA_CONT_ID         --担保合同号
        ,A.RGST_ORG_ID                             AS ORG_ID              --机构编号 
        ,CASE WHEN A.GUAR_WAY_CD = 'B' THEN 'A' --抵押
              WHEN A.GUAR_WAY_CD = 'A' THEN 'B' --质押
              WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '21' THEN 'C01'--单人保证
              WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '22' THEN 'C03'--多人联保
              WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '23' THEN 'C04'--多人分保
              WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '24' THEN 'C02'--多人保证
              WHEN A.GUAR_WAY_CD = 'C' AND A.GUAR_KIND_CD = '-' THEN 'C'  --保证
              ELSE 'Z'
          END                                      AS GUA_TYP             --担保类型 
        ,CASE WHEN A.GUAR_CONT_TYPE_CD = '1' THEN '01' --一般担保合同
              WHEN A.GUAR_CONT_TYPE_CD = '2' THEN '02'--最高额度担保合同
              ELSE '99' --未知
          END                                      AS GUA_CONT_TYP        --担保合同类型
        --,'01'                                      AS GUA_BIZ_TYP         --被担保业务类型
        ,NVL(C.CONT_TYPE,'99')                     AS GUA_BIZ_TYP         --被担保业务类型
        ,CASE WHEN A.STATUS_CD = '2' THEN 'Y' --有效
              ELSE 'N' --已失效
          END                                      AS GUA_CONT_STAT       --担保合同状态        
        ,CASE WHEN TO_CHAR(A.SIGN_DT,'YYYYMMDD') NOT IN ('00010101','29991231','99991231')
              THEN TO_CHAR(A.SIGN_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.RGST_DT,'YYYYMMDD')
          END                                      AS GUA_CONT_SIGN_DT    --担保合同签订日
        ,CASE WHEN TO_CHAR(A.EFFECT_DT,'YYYYMMDD') = '29991231' THEN '00010101'
              ELSE TO_CHAR(A.EFFECT_DT,'YYYYMMDD')
          END                                      AS GUA_CONT_EFF_DT     --担保合同生效日
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              AS GUA_CONT_EXP_DT     --担保合同到期日
        ,DECODE(A.CURR_CD,'-','CNY',' ','CNY',A.CURR_CD) AS CUR           --币种
        ,A.GUAR_AMT                                AS GUA_CONT_AMT        --担保合同金额
        ,B.GUARTOR_NET_ASSET_AMT                   AS GUAR_NET_AST        --保证人净资产
        ,NULL                                      AS ESTBL_EMP_NO        --客户经理编号
        ,0                                         AS MTG_PLG_RTO         --抵质押率
        ,NULL                                      AS APRV_MTG_PLG_RTO    --审批抵质押率
        ,NULL                                      AS DEPT_LINE           --部门条线 /*风险管理部*/
        ,'联合网贷担保'                            AS DATA_SRC            --数据来源
        ,0                                         AS GUA_RATIO           --担保比例
        ,0                                         AS MTG_PLG_RTO_ORIG    --原抵质押率
        ,NULL                                      AS GUAR_IDY_TYP        --担保人行业类型
        ,NULL                                      AS GUAR_RGN            --担保人地区
        ,NULL                                      AS GUAR_ECON_DEPT      --担保人国民经济部门类型
        ,NULL                                      AS GUAR_ENT_SCALE      --担保人企业规模
        ,A.GUARTOR_CERT_TYPE_CD                    AS GUAR_CRDL_TYP       --担保人主证件类型
        ,A.GUARTOR_CERT_NO                         AS GUAR_CRDL_NO        --担保人主证件号码
        ,T3.MTG_RAT                                AS ACTL_MTG_PLG_RTO    --实际抵质押率
        ,A.GUARTOR_CUST_ID                         AS GUAR_ID             --担保人编号 
        ,A.GUARTOR_NAME                            AS GUAR_NM             --担保人名称 
        ,ID1.NATION_CD                             AS GUAR_CTY_CD         --注册国家/地区代码
        ,'Y'                                       AS LOAN_MON_FLAG       --借据是否当月内有效 --ADD BY 20240321
        ,ID1.NATION_CD                             AS GUARTOR_CTY_RG_CD   --担保人国家和地区代码  --ADD BY LYH 20240703
        ,A.STATUS_CD                               AS GUA_CONT_STAT_YBT   --一表通担保合同状态  --ADD BY YJY 20250825
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A  --联合网贷担保合同信息
   INNER JOIN RRP_MDL.M_GUA_CONT_INFO_TMP C --被担保业务类型
      ON C.CONT_ID = A.GUAR_CONT_ID
    LEFT JOIN (SELECT B.GUARTOR_ID,MAX(CURR_CD) AS CURR_CD,MAX(GUARTOR_NET_ASSET_AMT) AS GUARTOR_NET_ASSET_AMT
                 FROM RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B --押品保证人评级信息
                WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY B.GUARTOR_ID) B
      ON B.GUARTOR_ID = A.GUARTOR_CUST_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO ID1
      ON ID1.CUST_ID = A.GUARTOR_CUST_ID
     AND ID1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT MAX(MTG_RAT) MTG_RAT,GUAR_CONT_ID
                 --FROM RRP_MDL.O_IML_AST_GUAR_QUAL_IDTFY
                 FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA --押品与担保合同关系 MOD BY YJY 20251013
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY GUAR_CONT_ID) T3
      ON T3.GUAR_CONT_ID = A.GUAR_CONT_ID
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1; 
    V_STEP_DESC := '插入前一天被删除的担保合同数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_GUA_CONT_INFO
      (DATA_DT              --数据日期
      ,LGL_REP_ID           --法人编号
      ,GUA_CONT_ID          --担保合同号
      ,ORG_ID               --机构编号
      ,GUA_TYP              --担保类型
      ,GUA_CONT_TYP         --担保合同类型
      ,GUA_BIZ_TYP          --被担保业务类型
      ,GUA_CONT_STAT        --担保合同状态
      ,GUA_CONT_SIGN_DT     --担保合同签订日期
      ,GUA_CONT_EFF_DT      --担保合同生效日期
      ,GUA_CONT_EXP_DT      --担保合同到期日期
      ,CUR                  --币种
      ,GUA_CONT_AMT         --担保合同金额
      ,GUAR_NET_AST         --保证人净资产
      ,ESTBL_EMP_NO         --建立员工号
      ,MTG_PLG_RTO          --抵质押率
      ,APRV_MTG_PLG_RTO     --审批抵质押率
      ,DEPT_LINE            --部门条线
      ,DATA_SRC             --数据来源
      ,GUA_TAR              --担保标的
      ,GUA_RATIO            --担保比例
      ,MTG_PLG_RTO_ORIG     --原始抵质押率
      ,GUAR_IDY_TYP         --担保人行业类型
      ,GUAR_RGN             --担保人地区
      ,GUAR_ECON_DEPT       --担保人国民经济部门类型
      ,GUAR_ENT_SCALE       --担保人企业规模
      ,GUAR_CRDL_TYP        --担保人证件类型
      ,GUAR_CRDL_NO         --担保人证件号码
      ,ACTL_MTG_PLG_RTO     --实际抵质押率
      ,GUAR_ID              --担保人编号
      ,GUAR_NM              --担保人名称
      ,GUAR_CTY_CD          --注册国家/地区代码
      ,LOAN_MON_FLAG        --借据是否当月内有效 --ADD BY 20240321
      ,GUARTOR_CTY_RG_CD    --担保人国家和地区代码  --ADD BY LYH 20240703
      ,GUA_CONT_STAT_YBT    --一表通担保合同状态  --ADD BY YJY 20250825
	    ,GUA_CONT_END_DT      --担保合同失效日期  --ADD BY YJY 20251225
      )
     WITH TMP1 AS (
     SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.GUA_CONT_ID ORDER BY T.DATA_DT DESC) RN
       FROM RRP_MDL.M_GUA_CONT_INFO T
       LEFT JOIN RRP_MDL.M_GUA_CONT_INFO TB
         ON TB.GUA_CONT_ID = T.GUA_CONT_ID
        AND TB.DATA_DT = V_P_DATE
      WHERE TB.GUA_CONT_ID IS NULL
	      AND (T.GUA_CONT_END_DT IS NULL OR T.GUA_CONT_END_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')) --上一天采集的有效数据或者当年内失效的数据
        AND T.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD'))
    SELECT V_P_DATE                AS DATA_DT              --数据日期
          ,TA.LGL_REP_ID           AS LGL_REP_ID           --法人编号
          ,TA.GUA_CONT_ID          AS GUA_CONT_ID          --担保合同号
          ,TA.ORG_ID               AS ORG_ID               --机构编号
          ,TA.GUA_TYP              AS GUA_TYP              --担保类型
          ,TA.GUA_CONT_TYP         AS GUA_CONT_TYP         --担保合同类型
          ,TA.GUA_BIZ_TYP          AS GUA_BIZ_TYP          --被担保业务类型
          ,'N'                     AS GUA_CONT_STAT        --担保合同状态
          ,TA.GUA_CONT_SIGN_DT     AS GUA_CONT_SIGN_DT     --担保合同签订日期
          ,TA.GUA_CONT_EFF_DT      AS GUA_CONT_EFF_DT      --担保合同生效日期
          ,TA.GUA_CONT_EXP_DT      AS GUA_CONT_EXP_DT      --担保合同到期日期
          ,TA.CUR                  AS CUR                  --币种
          ,TA.GUA_CONT_AMT         AS GUA_CONT_AMT         --担保合同金额
          ,TA.GUAR_NET_AST         AS GUAR_NET_AST         --保证人净资产
          ,TA.ESTBL_EMP_NO         AS ESTBL_EMP_NO         --建立员工号
          ,TA.MTG_PLG_RTO          AS MTG_PLG_RTO          --抵质押率
          ,TA.APRV_MTG_PLG_RTO     AS APRV_MTG_PLG_RTO     --审批抵质押率
          ,TA.DEPT_LINE            AS DEPT_LINE            --部门条线
          ,TA.DATA_SRC             AS DATA_SRC             --数据来源
          ,TA.GUA_TAR              AS GUA_TAR              --担保标的
          ,TA.GUA_RATIO            AS GUA_RATIO            --担保比例
          ,TA.MTG_PLG_RTO_ORIG     AS MTG_PLG_RTO_ORIG     --原始抵质押率
          ,TA.GUAR_IDY_TYP         AS GUAR_IDY_TYP         --担保人行业类型
          ,TA.GUAR_RGN             AS GUAR_RGN             --担保人地区
          ,TA.GUAR_ECON_DEPT       AS GUAR_ECON_DEPT       --担保人国民经济部门类型
          ,TA.GUAR_ENT_SCALE       AS GUAR_ENT_SCALE       --担保人企业规模
          ,TA.GUAR_CRDL_TYP        AS GUAR_CRDL_TYP        --担保人证件类型
          ,TA.GUAR_CRDL_NO         AS GUAR_CRDL_NO         --担保人证件号码
          ,TA.ACTL_MTG_PLG_RTO     AS ACTL_MTG_PLG_RTO     --实际抵质押率
          ,TA.GUAR_ID              AS GUAR_ID              --担保人编号
          ,TA.GUAR_NM              AS GUAR_NM              --担保人名称
          ,TA.GUAR_CTY_CD          AS GUAR_CTY_CD          --注册国家/地区代码
          ,TA.LOAN_MON_FLAG        AS LOAN_MON_FLAG        --借据是否当月内有效 --ADD BY 20240321
          ,TA.GUARTOR_CTY_RG_CD    AS GUARTOR_CTY_RG_CD    --担保人国家和地区代码  --ADD BY LYH 20240703
          ,TA.GUA_CONT_STAT_YBT    AS GUA_CONT_STAT_YBT    --一表通担保合同状态  --ADD BY YJY 20250825
	    	  ,CASE WHEN TA.GUA_CONT_END_DT IS NOT NULL 
                THEN TA.GUA_CONT_END_DT
                ELSE V_P_DATE
            END     			         AS GUA_CONT_END_DT      --担保合同失效日期  --ADD BY YJY 20251225
      FROM TMP1 TA
     WHERE TA.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
    SELECT DATA_DT, GUA_CONT_ID,COUNT(1)
      FROM RRP_MDL.M_GUA_CONT_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, GUA_CONT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_GUA_CONT_INFO;
/

