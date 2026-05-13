CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CRDT_LMT_INFO_BFD(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CRDT_LMT_INFO_BFD
  *  功能描述：授信额度主表、授信额度子表
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO 、 M_CRDT_LMT_SUB_BFD
  *  配置表：  CODE_MAP
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   01    20220524  梅炜     首次创建
     02    20220901  MW       增加码值表模块判定
     03    20221114  hulj     增加数据重复校验
     04    20221201  liuyu    重新开发
     零售口径：额度合同有效的取额度合同金额，单笔单批取不到额度合同取业务合同金额。
               只有原额度续作、借新还旧、资产重组三种发生方式会产生新的合同，如果额度项下有借据置为有效，否则为失效。
               零售系统: 曹志鹏以及禹晴确认合同有效未到期都纳入授信总额统计
               网贷系统：周吉荣确认原新心金融逻辑需要继续保持，其他网贷逻辑以旧系统为准
     05    20221222  liuyu    转授信的已用额度改成业务合同金额取数
     06    20221222  liuyu    对公已用额度经过确认可以直取数仓合同表已用额度调整逻辑
     07    20221223  liuyu    联合网贷有特殊操作，上线后需要注释
     08    20221226  liuyu    M层授信主表和授信子表合并在一个过程出数
     09    20221227  liuyu    新增关联综合信贷产品表取额度品种划分经营消费额度，取额度合同贷款用途字段判断贷款类型
     10    20230103  liuyu    按照周吉荣口径调整新心金融小微贷授信统计逻辑
     11    20230114  liuyu    网商小贷非循环逻辑根据额度差异讨论会议本身要监管加工，
                              咨询了李龙龙后发现无法按照原有逻辑取数，信贷会改变迁移逻辑，监管逻辑不变

  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CRDT_LMT_INFO_BFD'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE; --跑批日期
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
   SELECT TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM') INTO V_MONTH_START_DATE FROM DUAL;
   V_DATE :=TO_DATE(V_P_DATE,'YYYYMMDD');

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_CRDT_LMT_INFO_BFD T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --DELETE FROM M_CRDT_LMT_SUB_BFD T WHERE T.DATA_DT = V_P_DATE;

    -- 用到的临时表
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP01'; --对公已用额度临时表 01
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02'; --授信额度明细主表 02
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04'; --按照授信合同维度整合表 04
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP05'; --处理首次授信日期 05
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06'; --整合借据余额 06

  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRDT_LMT_INFO_BFD'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
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

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT, 'M_CRDT_LMT_INFO_BFD', '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| 'M_CRDT_LMT_INFO_BFD' ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


   -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT, 'M_CRDT_LMT_SUB_BFD', '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| 'M_CRDT_LMT_SUB_BFD' ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  V_STEP := V_STEP + 1; --2
  V_STEP_DESC := '整合各项贷款余额--对公贷款';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06';
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(B1,A,C,D,O)*/
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
     AND A.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表 取额度合同
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = V_DATE
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

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '整合各项贷款余额--贴现'; --3
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(B1,A,C,D,O)*/
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
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表 取额度合同
      ON D.CONT_ID = C.LMT_CONT_ID
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_NUM
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '整合各项贷款余额--买断式转贴现'; --4
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(A,C,F2,D,DD,O)*/
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
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
      ON J.BILL_ID = A.BILL_ID
     AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E  --对公贷款合同信息表
      ON E.CONT_ID = D.LMT_CONT_ID
     AND E.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表 关联估值表取 转贴现 公允价值变动
      ON O.V_TRADE_NO = B.BILL_NUM
     AND O.ETL_DT = V_DATE
   WHERE A.TRAN_DIR_CD = '01'  --买入
     AND A.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --记账成功
     AND A.ETL_DT = V_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合表外业务余额--信用证'; --5
     INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
    SELECT /*+USE_HASH(A,C,D)*/
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

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '整合表外业务余额--保函'; --6
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
    SELECT /*+USE_HASH(A,B,C,D)*/
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

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合表外业务余额--银行承兑汇票';--7
    INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(A,B,C,D)*/
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
      AND D.ETL_DT = V_DATE
    WHERE A.STD_PROD_ID IN ('601010100001')  -- 601010100001  银承承兑 20221121 mw
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.BILL_NUM IS NOT NULL;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    /*V_STEP_DESC := '整合表外业务余额--卖断式转贴现';--8
    -- 卖断式转贴现不占用授信，不统计授信余额
    INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
         B.DUBIL_ID                        AS RCPT_ID,              --借据号
         B.CONT_ID                         AS CONT_ID,              --合同号
         TRIM(A.BILL_NUM)                  AS BILL_NO,              --票据号
         TRIM(D.LMT_CONT_ID)               AS LMT_CONT_ID,          --授信合同号
         F.CUST_ID                         AS CUST_ID,              --客户号
         NULL                              AS LMT_CUST_ID,          --授信客户号 表外的不用算转授信
         '896001'                          AS ORG_ID,               --机构号
         B.STD_PROD_ID                     AS LOAN_PROD_ID,         --产品号
         A.CURR_CD                         AS CUR,                  --币种
         A.FAC_VAL_AMT                     AS LOAN_AMT,             --放款金额
         A.FAC_VAL_AMT                     AS LOAN_BAL,             --贷款余额
         -- 但是卖断式转贴现不占用授信，不知道怎么算授信户数 --问题待定
         0                                 AS INT_ADJ,              --利息调整
         0                                 AS FAIR_VAL_CHG,         --公允价值变动
         ''                                AS DATA_SRC,             --数据来源
         '卖断式转贴现'                    AS DATA_SRC_DESC         --数据来源中文
     FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A    --票据转贴现信息表
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B  --对公贷款借据信息表
       ON B.BILL_NUM = A.BILL_NUM   --mod by liuyu
      AND B.STD_PROD_ID IN ('204010200001','204010200002') -- 取贴现借据
      AND B.ETL_DT = V_DATE
    --========= MOD BY LIUYU 20220926 根据严希婧要求，直贴后卖断的按直贴票据的申请人取客户号
    LEFT JOIN
         (SELECT T.CUST_ID,T.CUST_NAME,BILL_NUM
            FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T -- 票据贴现申请表
           WHERE ETL_DT = V_DATE
             AND T.CUST_ID IS NOT NULL
             AND ENTRY_STATUS_CD = '03' -- 筛选记账成功的票据
           GROUP BY T.CUST_ID,T.CUST_NAME,BILL_NUM) F -- 票据贴现信息
       ON F.BILL_NUM = A.BILL_NUM
     --========= MOD BY LIUYU 20220926 根据严希婧要求，直贴后卖断的按直贴票据的申请人取客户号
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D  --对公贷款合同信息表
       ON B.CONT_ID = D.CONT_ID
      AND B.ETL_DT = V_DATE
    INNER JOIN O_ICL_CMM_BILL_CENTER_INFO C --票据中心信息
       ON A.BILL_ID = C.BILL_ID
      AND C.ETL_DT = V_DATE
     LEFT JOIN
         (SELECT A.BILL_NUM
            FROM O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
            WHERE A.ETL_DT = V_DATE
             AND A.BUS_TYPE_CD = 'BT01'
             AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
             AND A.TRAN_DIR_CD = '01' --转贴现买入  --MODIFY BY MW 20221207
             AND A.CURRT_BAL > 0
          ) E
       ON A.BILL_NUM = E.BILL_NUM
    WHERE A.TRAN_DIR_CD = '02'  -- 00-未知 01-买入 02-卖出  --MODIFY BY MW 20221207
      AND A.BUS_TYPE_CD = 'BT01' -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
      AND A.ENTRY_STATUS_CD = '03' -- 筛选记账成功的票据
      AND C.BILL_STATUS_CD IN ('21','S04') --已卖断销账
      AND C.EXP_DT > V_DATE --未到期
      AND ((A.STD_PROD_ID='204010100001' AND A.HXB_ACPT_FLG = '0')
           OR A.STD_PROD_ID='204010100002')
      \*剔除自开自贴、票据贴现过（他行未到期）、剔除在库的转贴现未到期*\
      AND (A.SYS_IN_FLG = '1' --系统内
           OR (A.SYS_IN_FLG = '0' AND E.BILL_NUM IS NULL)) --系统外转出
      AND A.BILL_SRC_CD <> 'SR005' --剔除转贴现  --modify by tangan at 20221109
      AND A.ETL_DT = V_DATE
      ;
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    */
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合对公当天失效部分';--9
    INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(A,B,C,D)*/
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
      AND D.ETL_DT = V_DATE
    WHERE A.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
      AND NVL(A.PAYOFF_DT,DATE'9999-12-31') = NVL(A.DISTR_DT,DATE'0001-01-01') -- 结清日=发放日
      AND NVL(A.PAYOFF_DT,DATE'9999-12-31') = TO_DATE(I_P_DATE,'YYYYMMDD'); --结清日=当天

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '整合各项贷款余额--零售贷款';--10
    INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06
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
  SELECT /*+USE_HASH(A,B,C,D)*/
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
     AND A.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO C --零售合同表
      ON B.CONT_ID = C.CONT_ID
     AND C.ETL_DT  = V_DATE
   WHERE A.CURRT_BAL > 0  -- 余额大于0
     AND A.WRT_OFF_FLG <> '1' --不含核销
     AND A.SUBJ_ID NOT LIKE '3007%' --不含委托贷款
     AND B.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := V_STEP + 1;
  V_STEP_DESC := '对公已用额度取额度项下借据余额之和';--11
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP01';
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP01
    (DATA_DT                     --数据日期
    ,CRDT_CONT_ID                --授信合同编号
    ,ALDY_USE_LMT                --已用额度
    )
  SELECT V_P_DATE                        AS DATA_DT,                    --数据日期
         T.LMT_CONT_ID                   AS CRDT_CONT_ID,               --授信合同编号
         NVL(SUM(NVL(T.LOAN_BAL,0)), 0)  AS ALDY_USE_LMT                --已用额度
    FROM RRP_MDL. M_CRDT_LMT_INFO_BFD_TEMP06 T --余额之和
   GROUP BY LMT_CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入授信额度主表-对公信贷部分';--12
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02';

  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
     )
    WITH LMT_INTO_TEMP06 AS (
      SELECT /*+MATERIALIZE*/ T6.LMT_CONT_ID  --物化视图
        FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.LMT_CONT_ID)
        ,LMT_INTO_TEMP07 AS (
      SELECT /*+MATERIALIZE*/ T7.LMT_CONT_ID  --物化视图
        FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06 T7
       WHERE T7.DATA_SRC_DESC = '当天失效'
       GROUP BY T7.LMT_CONT_ID)
  SELECT  /*+USE_HASH(A,C,D,E,F,TA,B)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,A.LP_ID                                         AS LGL_REP_ID                  --02法人编号
         ,NULL                                            AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                       AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(A.MANU_CONT_ID),A.CONT_ID)             AS CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                       AS CUST_ID                     --06客户编号
         ,NVL(TRIM(A.MGMT_ORG_ID),TRIM(A.RGST_ORG_ID))    AS ORG_ID                      --07机构编号
         ,A.CONT_AMT                                      AS CRDT_LMT                    --08授信额度
         /*CASE WHEN NVL(A.OCCU_CRDT_LMT,0) > NVL(F.ALDY_USE_LMT,0)
               THEN NVL(A.OCCU_CRDT_LMT,0)
                 \*经过信贷和数仓确认数仓的OCCU_CRDT_LMT字段加工逻辑与信贷一致，
                 但是为了保证数据稳定加入借据余额判断，已用额度需要>=借据余额*\
               ELSE NVL(F.ALDY_USE_LMT,0)
          END*/
          /*NVL(F.ALDY_USE_LMT,0)                           AS ALDY_USE_LMT                --09已用额度*/
         ,CASE WHEN NVL(A.OCCU_CRDT_LMT,0) <> 0 AND A.OCCU_CRDT_LMT <= A.CONT_AMT AND NVL(F.ALDY_USE_LMT,0) = 0 THEN NVL(A.OCCU_CRDT_LMT,0)
               ELSE NVL(F.ALDY_USE_LMT,0)
          END                                             AS ALDY_USE_LMT                --09已用额度  modify by tangan at 20230128
         /*NVL(A.CONT_AMT,0) - NVL(F.ALDY_USE_LMT,0)       AS SUR_CRDT_LMT                --10剩余授信额度*/
         ,CASE WHEN NVL(A.OCCU_CRDT_LMT,0) <> 0 AND A.OCCU_CRDT_LMT <= A.CONT_AMT AND NVL(F.ALDY_USE_LMT,0) = 0 THEN NVL(A.CONT_AMT,0) -  NVL(A.OCCU_CRDT_LMT,0)
               ELSE NVL(A.CONT_AMT,0) - NVL(F.ALDY_USE_LMT,0)
          END                                             AS SUR_CRDT_LMT                --10剩余授信额度   modify by tangan at 20230128
         ,NULL                                            AS EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                            AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                            AS EXP_SUR_LMT                 --13敞口剩余额度
         ,A.CURR_CD                                       AS CUR                         --14币种
         ,TA.TAR_VALUE_CODE                               AS CRDT_SUBJ_TYP               --15授信主体类型 CD1471-->C0032
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN B.LMT_CONT_ID IS NOT NULL THEN 'Y' --表内外借据有余额的置为有效
               WHEN G.LMT_CONT_ID IS NOT NULL THEN 'Y' --当天发放当天结清的置为有效
               WHEN A.LOAN_HAPP_TYPE_CD = '0201' THEN 'N' --展期合同置为失效 CD04031 贷款发放类型代码
               WHEN A.STD_PROD_ID = '100030000002' THEN 'N' --gl开头的都是集团客户的管理额度，集团客户无法发生业务
               WHEN A.CONT_ID LIKE 'MIGT%' THEN 'N' --信贷回复MIGT开头的是新信贷迁移规则，根据批复生成的额度合同，黄娅娅回复剔除
               WHEN A.VALID_FLG_CD = '2' THEN 'Y' --CD04022 合同状态代码
               ELSE 'N'
          END                                            AS CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(I.APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(I.APPL_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(A.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
                     ELSE '99991231' END)  --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                          AS CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(A.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
                     ELSE '99991231' END)  --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                          AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                            AS CRDT_EXP_DT                 --20授信到期日期
         ,A.STD_PROD_ID                                   AS CRDT_BIZ_TYP                --21授信业务类型
         -- 由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,CASE WHEN A.LMT_CIRCL_FLG = '0' THEN 'N'
               ELSE 'Y'
           END                                            AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
          ,CASE WHEN A.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
              WHEN A.STD_PROD_ID IN ('100010100003') THEN '02'--低风险
              WHEN A.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
              WHEN NVL(A.OPEN_BAL,0) = 0 OR A.CONT_TYPE_CD IN ('03') THEN '02'
              ELSE '9901' --其他-敞口授信
              END                                          AS CRDT_SUBJ_CL               --24授信主体种类 T0029
         ,NULL                                             AS BANK_TAX_COOP_LOAN_CRDT_FLG--25银税合作贷款授信标志
         ,NVL(SUBSTRB(D.CRDT_LMT_APV_OPINION,1,2000),'同意')
                                                           AS DSN_SHT_OPN                --26决策单意见
         ,D.FINAL_APVER_ID                                 AS APRV_PSN_NO                --27审批人工号
         ,CASE WHEN A.MGMT_TELLER_ID = 'system' AND A.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE E.CLERK_ID
           END                                             AS CRDT_EMP_NO                --28授信员工号
         ,'800919'   /*风险管理部*/                        AS DEPT_LINE                  --29部门条线
         ,'对公信贷'                                       AS DATA_SRC                   --30数据来源
         ,A.BUS_BREED_ID                                   AS BUS_BREED_ID               --31业务品种编号  --ADD BY LIP 20220728
         ,'DG对公部分'                                     AS DATA_SRC_DESC              --32数据来源描述  --ADD BY LIP 20220728
         ,H.LMT_KIND_CD                                    AS LMT_TYPE_CD                --33额度种类代码
         ,A.LOAN_HAPP_TYPE_CD                              AS LOAN_HAPP_TYPE_CD          --34合同发生类型
         ,A.RELA_CONT_ID                                   AS RELA_CONT_ID               --35原合同编号
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 B -- 额度项下借据有余额的
      ON B.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP01 F--对公信贷已用额度临时表
      ON F.CRDT_CONT_ID = A.CONT_ID
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C--对公客户基本信息
      /*迁移数据会有部分客户号不在ECIF系统中，直接剔除*/
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO D --对公授信额度合同审批信息
      ON D.CRDT_LMT_APV_FLOW_NUM=A.APV_FLOW_NUM
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO E --行员信息表
      ON E.TELLER_ID = TRIM(A.MGMT_TELLER_ID)
     AND E.ETL_DT  = V_DATE
    LEFT JOIN LMT_INTO_TEMP07 G --当天授信当天结清的
      ON G.LMT_CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO H  --对公贷款额度合同补充信息
      ON H.CONT_ID  = A.CONT_ID
     AND H.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO I --对公贷款申请表
      ON I.LOAN_APPL_FLOW_NUM = A.CONT_ID
     AND I.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.CODE_MAP TA --授信主体类型 CD1471-->C0032
      ON TA.SRC_VALUE_CODE = C.CUST_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1471'
     AND TA.TAR_CLASS_CODE = 'C0032'
     AND TA.MOD_FLG = 'MDM'
   WHERE A.CRDT_TYPE_CD = '01'  --额度合同
     AND A.ETL_DT = V_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '插入授信额度主表-对公-转授信'; --13
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号

     )
  SELECT  /*+USE_HASH(A,B,C,D,E,F,TA)*/
          V_P_DATE                                           DATA_DT                     --01数据日期
         ,B.LP_ID                                            LGL_REP_ID                  --02法人编号
         ,NULL                                               PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,A.CONT_ID                                          CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(B.MANU_CONT_ID),A.CONT_ID)                CRDT_CONT_NM                --05授信合同名称
         ,A.CUST_ID                                          CUST_ID                     --06客户编号
         ,A.ORG_ID                                           ORG_ID                      --07机构编号
         ,B.CONT_AMT                                         CRDT_LMT                    --08授信额度
         ,B.CONT_AMT                                         ALDY_USE_LMT                --09已用额度
         ,0                                                  SUR_CRDT_LMT                --10剩余授信额度
         ,NULL                                               EXP_CRDT_LMT                --11敞口授信额度
         ,NULL                                               EXP_ALDY_USE_LMT            --12敞口已用额度
         ,NULL                                               EXP_SUR_LMT                 --13敞口剩余额度
         ,B.CURR_CD                                          CUR                         --14币种
         ,TA.TAR_VALUE_CODE                                  CRDT_SUBJ_TYP               --15授信主体类型 CD1471-->C0032
         ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(B.DISTR_DT,'YYYYMMDD')
           END                                               EFF_DT                      --16生效日期
         ,'Y'                                                CRDT_STAT                   --17授信状态 Z0002
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END)  --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             CRDT_APP_DT                 --18授信申请日期
         ,LEAST(CASE WHEN TO_CHAR(B.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(B.START_DT,'YYYYMMDD')
                     ELSE '99991231' END,
                CASE WHEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                     THEN TO_CHAR(F.CRDT_LMT_BEGIN_DT,'YYYYMMDD')
                     ELSE '99991231' END) --MODIFY BY LIP 20220722 不给默认值时，有空值的情况，取最小值会取到空值
                                                             CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(B.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(B.EXP_DT,'YYYYMMDD')
           END                                               CRDT_EXP_DT                 --20授信到期日期
         ,B.STD_PROD_ID                                   AS CRDT_BIZ_TYP                --21授信业务类型
         -- 由于行内额度管理无法区分授信业务类型该字段取额度合同标准产品号
         ,'N'                                                CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                               TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN B.STD_PROD_ID IN ('100010100001','100020100001') THEN '01'--综合
              WHEN B.STD_PROD_ID IN ('100010100003') THEN '02'--低风险
              WHEN B.STD_PROD_ID IN ('100010100002','100020100002') THEN '05' --专项
              WHEN NVL(B.OPEN_BAL,0) = 0 OR B.CONT_TYPE_CD IN ('03') THEN '02'
              ELSE '9901' --其他-敞口授信
          END                                                 CRDT_SUBJ_CL               --24授信主体种类 T0029
         ,NULL                                                BANK_TAX_COOP_LOAN_CRDT_FLG--25银税合作贷款授信标志
         ,'同意'                                              DSN_SHT_OPN                --26决策单意见
         ,F.FINAL_APVER_ID                                    APRV_PSN_NO                --27审批人工号
         ,CASE WHEN B.MGMT_TELLER_ID = 'system' AND B.CONT_ID LIKE 'UPL%' THEN '03000063'
               ELSE B.MGMT_TELLER_ID
           END                                                CRDT_EMP_NO                --28授信员工号
         ,'800919'   /*风险管理部*/                           DEPT_LINE                  --29部门条线
         ,'转授信'                                            DATA_SRC                   --30数据来源
         ,B.BUS_BREED_ID                                      BUS_BREED_ID               --31业务品种编号  --ADD BY LIP 20220728
         ,'DG对公表内转授信'                                  DATA_SRC_DESC              --32数据来源描述  --ADD BY LIP 20220728
         ,G.LMT_KIND_CD                                       LMT_KIND_CD                --33额度种类代码
         ,B.LOAN_HAPP_TYPE_CD                                 LOAN_HAPP_TYPE_CD          --34发生类型
         ,B.RELA_CONT_ID                                      RELA_CONT_ID               --35原合同编号
    FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C--对公客户基本信息
      ON C.CUST_ID = B.CUST_ID
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息
      ON D.CONT_ID = A.LMT_CONT_ID
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO F --对公授信额度合同审批信息
      ON F.CRDT_LMT_APV_FLOW_NUM = D.APV_FLOW_NUM
     AND F.ETL_DT = V_DATE
    LEFT JOIN O_ICL_CMM_CORP_LOAN_LMT_CONT_ATTACH_INFO G  --对公贷款额度合同补充信息
      ON G.CONT_ID  = A.CONT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
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
  V_STEP_DESC := '零售逻辑-综合授信'; --14
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
     )
    WITH LMT_INTO_TEMP06 AS (
      SELECT /*+MATERIALIZE*/ T6.LMT_CONT_ID  --物化视图
      ,SUM(NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0)) AS USE_LMT  --modify by tangan at 20230129
        FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.LMT_CONT_ID)
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.LMT_CONT_ID                                  AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(T1.LMT_CONT_CN_NAME),T1.LMT_CONT_ID)   AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,NVL(T1.ACCT_INSTIT_ID,T1.BELONG_ORG_ID)         AS ORG_ID                      --07机构编号
         ,T1.CRDT_LMT                                     AS CRDT_LMT                    --08授信额度
        /* ,0\*T1.OCCU_CRDT_LMT *\                          AS ALDY_USE_LMT                --09已用额度*/
          -- 已用额度字段待源系统改造完成后使用T1.OCCU_CRDT_LMT ，现阶段使用余额兜底
         ,NVL(T4.USE_LMT,0)                               AS ALDY_USE_LMT                --09已用额度 --modify by tangan at 20230129
         ,NVL(T1.CRDT_LMT,0) - NVL(T1.OCCU_CRDT_LMT,0)
                                                          AS SUR_CRDT_LMT                --10剩余授信额度
         ,T1.CRDT_OPEN_AMT                                AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,T1.CURR_CD                                      AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD')
          END                                             AS EFF_DT                      --16生效日期
         ,CASE WHEN T1.PROD_ID IN ('602030100002') THEN 'N' --剔除委托贷款
               WHEN T4.LMT_CONT_ID IS NOT NULL THEN 'Y' --额度项下有余额的置为有效
               WHEN T1.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN T1.STATUS_CD = '2' AND NVL(T1.EXP_DT,DATE'9999-12-31') >= V_DATE -- 合同有效且未到期
               THEN 'Y'--有效 --CD04022 合同状态代码
               ELSE 'N'
          END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T3.RGST_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T3.RGST_DT,'YYYYMMDD')
          END                                             AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.BEGIN_DT,'YYYYMMDD')
          END                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T1.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.EXP_DT,'YYYYMMDD')
          END                                             AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,CASE WHEN T1.CIRCL_FLG = '0' THEN 'N'
               ELSE 'Y'
          END                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,CASE WHEN NVL(T1.CRDT_OPEN_AMT,0) > 0 THEN '9901' --其他-敞口授信
               ELSE '02'
          END                                             AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         /* ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见*/
         ,NVL(SUBSTRB(TE.APV_OPINION,1,2000),'同意')      AS DSN_SHT_OPN                 --26决策单意见  --modify by tangan at 20230129
         ,T3.OPERR_ID                                     AS APRV_PSN_NO                 --27审批人工号  --modify by tangan at 20230130
         ,T3.OPERR_ID                                     AS CRDT_EMP_NO                 --28授信员工号  --modify by tangan at 20230130
         ,'800924'   /*零售信贷部(普惠金融部)*/           AS DEPT_LINE                   --29部门条线
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'零售额度合同'                                  AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         ,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO T1  --零售贷款授信额度信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO T3 --零售授信额度审批信息
      ON T3.CRDT_LMT_APV_FLOW_NUM = T1.LMT_APPL_FLOW_NUM
     AND T3.ETL_DT = V_DATE
    LEFT JOIN LMT_INTO_TEMP06 T4 --余额大于0的借据
      ON T4.LMT_CONT_ID  = T1.LMT_CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO TE --零售贷款申请信息 --modify by tangan at 20230129
      ON TE.LOAN_APPL_FLOW_NUM = T1.LMT_APPL_FLOW_NUM
     AND TE.ETL_DT = V_DATE
   WHERE T1.ETL_DT = V_DATE
     AND T1.PROD_ID NOT IN ('202020200007') --剔除新心金融小微贷
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '零售逻辑-单笔单批'; --15
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
     )
     WITH LMT_INTO_TEMP06 AS (
      SELECT /*+MATERIALIZE*/ T6.CONT_ID  --物化视图
      ,SUM(NVL(T6.LOAN_AMT,0)) AS USE_LMT  --modify by tangan at 20230129
        FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP06 T6
       WHERE NVL(T6.LOAN_BAL,0) + NVL(T6.FAIR_VAL_CHG,0) - NVL(T6.INT_ADJ,0) <> 0
       GROUP BY T6.CONT_ID)
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.CONT_ID                                      AS CRDT_CONT_ID                --04授信合同编号
         ,NVL(TRIM(T1.CONT_NAME),T1.CONT_ID)              AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,COALESCE(T1.ACCT_INSTIT_ID,T1.RGST_ORG_ID,T1.MGMT_ORG_ID)
                                                          AS ORG_ID                      --07机构编号
         ,T1.CONT_AMT                                     AS CRDT_LMT                    --08授信额度
         ,NVL(T2.USE_LMT,0)                               AS ALDY_USE_LMT                --09已用额度 --modify by tangan at 20230129
         ,''                                               AS SUR_CRDT_LMT               --10剩余授信额度
         ,''                                              AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,T1.CURR_CD                                      AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T1.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.START_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,CASE WHEN T1.PROD_ID IN ('602030100002') THEN 'N' --不含委托贷款
               WHEN T2.CONT_ID IS NOT NULL THEN 'Y'
               WHEN T1.LOAN_HAPP_TYPE_CD IN ('0102','0202','0204') THEN 'N' --CD04031 贷款发放类型代码
               --零售的 原额度续作/借新还旧/债务重组置为失效，如果项下有借据余额再置为有效
               WHEN T1.CONT_STATUS_CD = '2' AND NVL(T1.EXP_DT,DATE'9999-12-31') >= V_DATE -- 合同有效且未到期
               THEN 'Y'--有效 --CD04022 合同状态代码
               ELSE 'N'
          END                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T1.APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.APPL_DT,'YYYYMMDD')
          END                                             AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T1.START_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.START_DT,'YYYYMMDD')
          END                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T1.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.EXP_DT,'YYYYMMDD')
          END                                             AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,CASE WHEN T1.CONT_TYPE_CD = '04' THEN 'Y'
               ELSE 'N'
          END                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         /*,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029*/
         ,CASE WHEN T1.PROD_ID IN ('201020100032','201020100033','201020100034','201020100035','202020200008','201020100036'
                                  ,'201020100037','202010200005','202020200002','201010300022','201010300023','201010300024'
                                  ,'201010300025','201010300026','202010200002','201010300027','201010300028','201010100002'
                                  ,'201010300012') THEN '9901' --其他-敞口授信  --助贷和微贷 modify by tangan at 20230129
               ELSE '02'
          END                                             AS CRDT_SUBJ_CL                --授信主体种类 T0029  --modify by tangan at 20230129
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
        /* ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见*/
         ,NVL(SUBSTRB(TE.APV_OPINION,1,2000),'同意')      AS DSN_SHT_OPN                 --26决策单意见  --modify by tangan at 20230129
         ,T1.CUST_MGR_ID                                  AS APRV_PSN_NO                 --27审批人工号  --modify by tangan at 20230130
         ,T1.CUST_MGR_ID                                  AS CRDT_EMP_NO                 --28授信员工号  --modify by tangan at 20230130
         ,'800924'   /*零售信贷部(普惠金融部)*/           AS DEPT_LINE                   --29部门条线
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'零售单笔单批'                                  AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         ,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T1  --零售贷款合同信息
    LEFT JOIN LMT_INTO_TEMP06 T2 --有借据余额的合同
      ON T2.CONT_ID = T1.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO TE --零售贷款申请信息 --modify by tangan at 20230129
      ON TE.LOAN_APPL_FLOW_NUM = T1.APV_FLOW_NUM
     AND TE.ETL_DT = V_DATE
   WHERE T1.ETL_DT = V_DATE
     AND TRIM(T1.LMT_CONT_ID) IS NULL --根据‘关联合同编号’为空区分单笔单批合同
     AND T1.PROD_ID NOT IN ('202020200007') --剔除新心金融小微贷
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '零售逻辑-新心金融小微贷'; --16
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --01数据日期
    ,LGL_REP_ID                      --02法人编号
    ,PRIM_CRDT_CONT_ID               --03主授信合同编号
    ,CRDT_CONT_ID                    --04授信合同编号
    ,CRDT_CONT_NM                    --05授信合同名称
    ,CUST_ID                         --06客户编号
    ,ORG_ID                          --07机构编号
    ,CRDT_LMT                        --08授信额度
    ,ALDY_USE_LMT                    --09已用额度
    ,SUR_CRDT_LMT                    --10剩余授信额度
    ,EXP_CRDT_LMT                    --11敞口授信额度
    ,EXP_ALDY_USE_LMT                --12敞口已用额度
    ,EXP_SUR_LMT                     --13敞口剩余额度
    ,CUR                             --14币种
    ,CRDT_SUBJ_TYP                   --15授信主体类型
    ,EFF_DT                          --16生效日期
    ,CRDT_STAT                       --17授信状态
    ,CRDT_APP_DT                     --18授信申请日期
    ,CRDT_START_DT                   --19授信开始日期
    ,CRDT_EXP_DT                     --20授信到期日期
    ,CRDT_BIZ_TYP                    --21授信业务类型
    ,CIR_LMT_FLG                     --22循环额度标志
    ,TEMP_LMT_FLG                    --23临时额度标志
    ,CRDT_SUBJ_CL                    --24授信主体种类
    ,BANK_TAX_COOP_LOAN_CRDT_FLG     --25银税合作贷款授信标志
    ,DSN_SHT_OPN                     --26决策单意见
    ,APRV_PSN_NO                     --27审批人工号
    ,CRDT_EMP_NO                     --28授信员工号
    ,DEPT_LINE                       --29部门条线
    ,DATA_SRC                        --30数据来源
    ,BUS_BREED_ID                    --31业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --32数据来源描述  --ADD BY LIP 20220728
    ,LMT_TYPE_CD                     --33额度种类代码
    ,LOAN_HAPP_TYPE_CD               --34合同发生类型
    ,RELA_CONT_ID                    --35原合同编号
     )
     WITH LOAN_APPL AS (
      SELECT T.*
        FROM (
      SELECT A.*,
             ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.APPL_AMT DESC ,A.LOAN_APPL_FLOW_NUM DESC) AS RN -- 按大的一笔授信申请取数
             --
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO A -- 贷款申请信息
       WHERE A.ETL_DT = V_DATE
         AND A.PROD_ID = '202020200007') T
       WHERE T.RN = 1
      )
     ,TMP_DUBIL AS (
      SELECT A.CUST_ID
            ,SUM(A.DUBIL_AMT) AS DUBIL_AMT
            ,SUM(A.CURRT_BAL) AS CURRT_BAL
            ,MIN(A.DISTR_DT) AS DISTR_DT
            ,MAX(A.EXP_DT) AS EXP_DT
            ,MAX(B.CUST_MGR_ID) AS CUST_MGR_ID  --modify by tangan at 20230130
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
       INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A  --零售贷款账户信息
          ON B.DUBIL_ID = A.DUBIL_NUM
         AND A.ETL_DT = V_DATE
       WHERE A.CURRT_BAL > 0  -- 余额大于0
         AND A.WRT_OFF_FLG <> '1' --不含核销
         AND A.STD_PROD_ID = '202020200007' --新心金融
         AND B.ETL_DT = V_DATE
       GROUP BY A.CUST_ID
      )
  SELECT  /*+USE_HASH(A B M C D)*/
          V_P_DATE                                        AS DATA_DT                     --01数据日期
         ,T1.LP_ID                                        AS LGL_REP_ID                  --02法人编号
         ,''                                              AS PRIM_CRDT_CONT_ID           --03主授信合同编号
         ,T1.LOAN_APPL_FLOW_NUM                           AS CRDT_CONT_ID                --04授信合同编号
         ,T1.LOAN_APPL_FLOW_NUM                           AS CRDT_CONT_NM                --05授信合同名称
         ,T1.CUST_ID                                      AS CUST_ID                     --06客户编号
         ,COALESCE(T1.ACCT_INSTIT_ID,T1.BELONG_ORG_ID,T1.MGMT_ORG_ID)
                                                          AS ORG_ID                      --07机构编号
         ,T1.APPL_AMT                                     AS CRDT_LMT                    --08授信额度
         ,T2.CURRT_BAL                                    AS ALDY_USE_LMT                --09已用额度
          --新心金融已用额度用借据余额
         ,''                                              AS SUR_CRDT_LMT                --10剩余授信额度
         ,''                                              AS EXP_CRDT_LMT                --11敞口授信额度
         ,''                                              AS EXP_ALDY_USE_LMT            --12敞口已用额度
         ,''                                              AS EXP_SUR_LMT                 --13敞口剩余额度
         ,'CNY'                                           AS CUR                         --14币种
         ,'04'                                            AS CRDT_SUBJ_TYP               --15授信主体类型 04个人客户授信
         ,CASE WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
           END                                            AS EFF_DT                      --16生效日期
         ,'Y'                                             AS CRDT_STAT                   --17授信状态 Z0002
         ,CASE WHEN TO_CHAR(T1.FIRST_TRIAL_APPL_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T1.FIRST_TRIAL_APPL_DT,'YYYYMMDD')
          END                                             AS CRDT_APP_DT                 --18授信申请日期
         ,CASE WHEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T2.DISTR_DT,'YYYYMMDD')
          END                                             AS CRDT_START_DT               --19授信开始日期
         ,CASE WHEN TO_CHAR(T2.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
               THEN TO_CHAR(T2.EXP_DT,'YYYYMMDD')
          END                                             AS CRDT_EXP_DT                 --20授信到期日期
         ,T1.PROD_ID                                      AS CRDT_BIZ_TYP                --21授信业务类型 T0007
         ,'Y'                                             AS CIR_LMT_FLG                 --22循环额度标志
         ,NULL                                            AS TEMP_LMT_FLG                --23临时额度标志
         ,'02'                                            AS CRDT_SUBJ_CL                --24授信主体种类 T0029
         ,NULL                                            AS BANK_TAX_COOP_LOAN_CRDT_FLG --25银税合作贷款授信标志
         ,'同意'                                          AS DSN_SHT_OPN                 --26决策单意见
         ,T2.CUST_MGR_ID                                  AS APRV_PSN_NO                 --27审批人工号
         ,T2.CUST_MGR_ID                                  AS CRDT_EMP_NO                 --28授信员工号 --modify by tangan at 20230130
         ,'800924'   /*零售信贷部(普惠金融部)*/           AS DEPT_LINE                   --29部门条线   --modify by tangan at 20230130
         ,'零售'                                          AS DATA_SRC                    --30数据来源
         ,T1.PROD_ID                                      AS BUS_BREED_ID                --31业务品种编号  --ADD BY LIP 20220728
         ,'零售新心金融'                                  AS DATA_SRC_DESC               --32数据来源描述  --ADD BY LIP 20220728
         ,''                                              AS LMT_TYPE_CD                 --33额度种类代码
         ,''                                              AS LOAN_HAPP_TYPE_CD           --34合同发生类型
         ,''                                              AS RELA_CONT_ID                --35原合同编号
    FROM LOAN_APPL T1  --零售贷款申请信息
   INNER JOIN TMP_DUBIL T2
      ON T1.CUST_ID = T2.CUST_ID -- 取客户项下申请金额最大的一个申请为授信额度
   WHERE T1.ETL_DT = V_DATE
     AND T1.PROD_ID = '202020200007'
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '插入授信额度主表-联合网贷'; --17
   V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,PRIM_CRDT_CONT_ID               --主授信合同编号
    ,CRDT_CONT_ID                    --授信合同编号
    ,CRDT_CONT_NM                    --授信合同名称
    ,RCPT_ID                         --借据号
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
    ,APRV_PSN_NO                     --审批人工号
    ,CRDT_EMP_NO                     --授信员工号
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,BUS_BREED_ID                    --业务品种编号  --ADD BY LIP 20220728
    ,DATA_SRC_DESC                   --数据来源描述  --ADD BY LIP 20220728
     )
  WITH CMM_UNITE_WL_LMT_INFO_QC AS (
     -- 由于数仓保留了BUS_BREED_ID在联合网贷额度表，但是没有标准产品号，现在把BUS_BREED_ID映射为标准产品号
     SELECT T.CUST_ID                            AS CUST_ID --客户号
           ,T.LMT_CONT_ID                        AS LMT_CONT_ID --额度申请号
           ,T.CRDT_LMT                           AS CRDT_LMT --授信额度
           ,T.STATUS_CD                          AS STATUS_CD --状态代码
           ,T.LOW_RISK_BUS_FLG  --低风险业务标志 --modify by tangan at 20230129
           ,T.CRDT_OPEN_AMT     --合同敞口金额   --modify by tangan at 20230129
           /*,CASE WHEN TO_CHAR(T.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                 THEN T.BEGIN_DT
            END                                  AS BEGIN_DT --授信起始日期*/
           ,MIN(BEGIN_DT) OVER(PARTITION BY CUST_ID,   --modify by tangan at 20230129
                 CASE WHEN T.BUS_BREED_ID IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                      WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                      WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                      WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                      WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                      ELSE T.BUS_BREED_ID END)   AS BEGIN_DT --授信起始日期
           ,CASE WHEN TO_CHAR(T.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                 THEN T.EXP_DT
            END                                  AS EXP_DT --授信到期日期
           ,CASE WHEN T.BUS_BREED_ID IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                 WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                 WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                 WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                 WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
             END                                  AS BUS_BREED_ID1 --统一后的授信品种
           ,ROW_NUMBER()OVER(PARTITION BY CUST_ID,
                             CASE WHEN T.BUS_BREED_ID IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
                                  WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                                  WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                                  WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                                  WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                              END
                ORDER BY BEGIN_DT DESC,T.LMT_CONT_ID DESC)
                                                 AS RN --去重
            --一个客户在一个业务品种中可能有多次审批记录，取当前最新的一个额度为准 --梁秋茹/杨光泽
            --标准产品号之后没有分借呗/借呗三期，网商贷/网商贷引流产品。但是数仓保留了旧的BUS_BREED_ID字段，赋了原来的业务品种值
       FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T
      WHERE T.ETL_DT = V_DATE + 1
        AND TRIM(T.CUST_ID) IS NOT NULL
        AND T.CRDT_LMT > 0
        AND (NVL(T.BEGIN_DT,DATE'0001-01-01') <= T.ETL_DT - 1
              OR T.BEGIN_DT = DATE'2099-12-31'
              OR T.BEGIN_DT = DATE'9999-12-31')
        --mod by liuyu 为了应对新一代测试环境有大于数据日期的业务数据，对发生日期限制
        )
  SELECT  V_P_DATE                               AS DATA_DT                      --数据日期
         ,A.LP_ID                                AS LGL_REP_ID                   --法人编号
         ,NULL                                   AS PRIM_CRDT_CONT_ID            --主授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)         AS CRDT_CONT_ID                 --授信合同编号
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)         AS CRDT_CONT_NM                 --授信合同名称
         ,''                                     AS RCPT_ID                      --借据号
         ,A.CUST_ID                              AS CUST_ID                      --客户编号
         ,A.ACCT_INSTIT_ID                       AS ORG_ID                       --机构编号
         ,NVL(TB.CRDT_LMT,A.DUBIL_AMT)           AS CRDT_LMT                     --授信额度
         ,SUM(NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0))
                                                 AS ALDY_USE_LMT                 --已用额度
         ,NULL                                   AS SUR_CRDT_LMT                 --剩余授信额度
         ,NULL                                   AS EXP_CRDT_LMT                 --敞口授信额度
         ,NULL                                   AS EXP_ALDY_USE_LMT             --敞口已用额度
         ,NULL                                   AS EXP_SUR_LMT                  --敞口剩余额度
         ,A.CURR_CD                              AS CUR                          --币种
         ,'04'                                   AS CRDT_SUBJ_TYP                --授信主体类型 04个人客户授信
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
              END)                               AS EFF_DT               --生效日期
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1'  THEN 'Y'
               WHEN A.WRT_OFF_FLG = '1' AND B.FIR_WRT_OFF_DT >= V_MONTH_START_DATE-1 THEN 'N'
               WHEN A.PAYOFF_DT >= V_MONTH_START_DATE-1 THEN 'N'
          END                                    AS CRDT_STAT                    --授信状态 Z0002
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
              END)                               AS CRDT_APP_DT          --授信申请日期
         ,MIN(CASE WHEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(TB.BEGIN_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
              END)                               AS CRDT_START_DT        --授信开始日期
         ,MAX(CASE WHEN TO_CHAR(TB.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(TB.EXP_DT,'YYYYMMDD')
                   WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231') THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
              END)                               AS CRDT_EXP_DT          --授信到期日期
         ,NVL(TB.BUS_BREED_ID1,A.STD_PROD_ID)    AS CRDT_BIZ_TYP                 --授信业务类型
         ,'Y'                                    AS CIR_LMT_FLG                  --循环额度标志
         ,NULL                                   AS TEMP_LMT_FLG                 --临时额度标志
         /*,'02'                                   AS CRDT_SUBJ_CL                --授信主体种类T0029*/
         ,CASE WHEN TB.LOW_RISK_BUS_FLG ='1' THEN '02'
               WHEN NVL(TB.CRDT_OPEN_AMT,0)>0 THEN '9901' --其他-敞口授信
               ELSE '02'
          END                                    AS CRDT_SUBJ_CL                --授信主体种类T0029  --modify by tangan at 20230129
         ,NULL                                   AS BANK_TAX_COOP_LOAN_CRDT_FLG --银税合作贷款授信标志
         ,MAX(A.CUST_MGR_ID)                     AS APRV_PSN_NO                 --审批人工号  --modify by tangan at 20230130
         ,MAX(A.CUST_MGR_ID)                     AS CRDT_EMP_NO                 --授信员工号  --modify by tangan at 20230130
         ,'800924'   /*零售信贷部(普惠金融部)*/  AS DEPT_LINE                   --部门条线
         ,'联合网贷'                             AS DATA_SRC                    --数据来源
         ,CASE WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165051','02001004120222','202010100001') THEN '202010100001' --借呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004135021','202010100003') THEN '202010100003' --花呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
          END                                    AS BUS_BREED_ID                --业务品种编号  --ADD BY LIP 20220728
         ,'LS'||'联合网贷'                       AS DATA_SRC_DESC               --数据来源描述  --ADD BY LIP 20220728
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO B --联合网贷核销表
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = V_DATE + 1
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC TB   --存在有借据无授信情况
      ON TB.CUST_ID = A.CUST_ID
     AND TB.BUS_BREED_ID1 = (CASE WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN '202010100004' --京东白条
                                  WHEN A.STD_PROD_ID IN ('202010100002','202010100001') THEN '202010100001' --借呗
                                  WHEN A.STD_PROD_ID IN ('202020200004','202020100001') THEN '202020100001' --网商贷
                                  ELSE A.STD_PROD_ID
                             END)
     AND TB.RN = 1
   WHERE ((NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0)--取余额大于0的借据
          OR (A.WRT_OFF_FLG = '1' AND B.FIR_WRT_OFF_DT >= V_MONTH_START_DATE-1)
          OR A.PAYOFF_DT >= V_MONTH_START_DATE-1 )
     AND A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销 --ADD BY LIP 20220722过滤没发放成功的数据
     AND A.ETL_DT = V_DATE + 1
   GROUP BY
          A.LP_ID
         ,NVL(TB.LMT_CONT_ID,A.DUBIL_ID)
         ,A.CUST_ID
         ,A.ACCT_INSTIT_ID
         ,NVL(TB.CRDT_LMT,A.DUBIL_AMT)
         ,A.CURR_CD
         ,CASE WHEN NVL(A.NOMAL_PRIC,0) + NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
                    AND A.WRT_OFF_FLG <> '1'  THEN 'Y'
               WHEN A.WRT_OFF_FLG = '1' AND B.FIR_WRT_OFF_DT >= V_MONTH_START_DATE-1 THEN 'N'
               WHEN A.PAYOFF_DT >= V_MONTH_START_DATE-1 THEN 'N'
          END
         ,NVL(TB.BUS_BREED_ID1,A.STD_PROD_ID)
         ,CASE WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('202020100001','202020200004','02001006135011','02001006160048') THEN '202020100001' -- 网商贷
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165051','02001004120222','202010100001') THEN '202010100001' --借呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('02001004135021','202010100003') THEN '202010100003' --花呗
               WHEN NVL(A.STD_PROD_ID,TB.BUS_BREED_ID1) IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
          END
         ,CASE WHEN TB.LOW_RISK_BUS_FLG ='1' THEN '02'
               WHEN NVL(TB.CRDT_OPEN_AMT,0)>0 THEN '9901' --其他-敞口授信
               ELSE '02'
          END
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
   V_STEP_DESC := '按授信合同维度整合'; --18
   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04';
   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04
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
    ,LMT_TYPE_CD                     --额度类型代码
    ,LOAN_HAPP_TYPE_CD               --合同发生类型
    ,RELA_CONT_ID                    --原合同编号
    ,BUS_BREED_ID                    --业务品种编号
    ,ORG_ID_ORI                      --合同原始机构编号
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
        ,BUS_BREED_ID                    --业务品种编号
        ,T.ORG_ID          AS ORG_ID_ORI --合同原始机构编号
        ,ROW_NUMBER() OVER(PARTITION BY CRDT_CONT_ID,PRIM_CRDT_CONT_ID
                               ORDER BY CRDT_STAT DESC,CRDT_APP_DT DESC NULLS LAST) RN --联合网贷去重
    FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP02 T
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TB
      ON TB.ORG_ID = SUBSTR(T.ORG_ID,1,3)
   WHERE TRIM(CRDT_CONT_ID) IS NOT NULL
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
          ,CASE WHEN CRDT_APP_DT >=/*<*/ CRDT_START_DT THEN CRDT_START_DT  --modify by tangan at 20230129 将<改为>=
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
          ,BUS_BREED_ID                    --业务品种编号
          ,ORG_ID_ORI                      --原始机构编号
     FROM TMP1
     WHERE RN = 1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1;
   V_STEP_DESC := '处理首次授信日期'; --19
   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP05';

   INSERT INTO RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP05(CUST_ID,FIRST_CRDT_DT)
   WITH TMP1 AS (
      SELECT CUST_ID,TO_CHAR(START_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO  --对公贷款合同信息
       WHERE CUST_ID IS NOT NULL AND CRDT_TYPE_CD = '01'
      UNION ALL
      SELECT CUST_ID,TO_CHAR(BEGIN_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO --零售贷款授信额度信息
      UNION ALL
      SELECT CUST_ID,TO_CHAR(START_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO -- 零售贷款合同信息
      UNION ALL
      SELECT CUST_ID,TO_CHAR(DUBIL_OPEN_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO -- 零售贷款借据信息
      UNION ALL
      SELECT CUST_ID,TO_CHAR(BEGIN_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO --联合网贷额度信息
       UNION ALL
      SELECT /*+PARALLEL*/CUST_ID,TO_CHAR(OPEN_ACCT_DT,'YYYYMMDD') FIRST_CRDT_DT
        FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO  --联合网贷借据信息
     )
   SELECT CUST_ID,MIN(FIRST_CRDT_DT) FROM TMP1 GROUP BY CUST_ID;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度子表-整合'; --20
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_CRDT_LMT_SUB_BFD
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
    ,ORG_ID_ORI                      --合同原始机构编号
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
        ,T.ORG_ID_ORI                    --合同原始机构编号
        ,ROW_NUMBER()OVER(PARTITION BY CRDT_CONT_ID,PRIM_CRDT_CONT_ID ORDER BY CRDT_STAT DESC,CRDT_APP_DT DESC NULLS LAST) RN
    FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04 T
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TB
      ON TB.ORG_ID = SUBSTR(T.ORG_ID,1,3)
   WHERE TRIM(CRDT_CONT_ID) IS NOT NULL
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
          ,CASE WHEN CRDT_APP_DT >=/*<*/ CRDT_START_DT THEN CRDT_START_DT  --modify by tangan at 20230129 将<改为>=
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
          ,ORG_ID_ORI                      --合同原始机构编号
     FROM TMP1
     WHERE RN = 1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
   V_STEP_DESC := '授信额度主表--整合到客户'; --21
   INSERT /*+APPEND*/ INTO RRP_MDL.M_CRDT_LMT_INFO_BFD
    (DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,PRIM_CRDT_CONT_ID                  --主授信合同编号
    ,PRIM_CRDT_CONT_NM                  --主授信合同名称
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,CUR                                --币种
    ,CRDT_TOTAL_LMT                     --授信总额度
    ,ALDY_USE_LMT                       --已用额度
    ,EXP_CRDT_LMT                       --敞口授信额度
    ,EXP_ALDY_USE_LMT                   --敞口已用额度
    ,OPR_CRDT_TOT_AMT                   --经营授信总额
    ,OPR_ALDY_USE_CRDT_TOT_AMT          --经营已用授信总额
    ,HSE_CRDT_LMT                       --住房授信额度
    ,HSE_ALDY_USE_CRDT_LMT              --住房已用授信额度
    ,CAR_LOAN_CRDT_LMT                  --车贷授信额度
    ,CAR_LOAN_ALDY_USE_CRDT_LMT         --车贷已用授信额度
    ,SL_CRDT_LMT                        --助学授信额度
    ,SL_ALDY_USE_CRDT_LMT               --助学已用授信额度
    ,OTH_CNSMP_CRDT_LMT                 --其他消费授信额度
    ,OTH_CNSMP_ALDY_USE_CRDT_LMT        --其他消费已用授信额度
    ,CRDT_STAT                          --授信状态
    ,FIRST_CRDT_DT                      --首次授信日期
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,CRDT_APP_DT                        --授信申请信息
    ,CRDT_START_DT                      --授信开始日期
    ,CRDT_EXP_DT                        --授信到期日期
    )
    WITH TMP AS (
    SELECT A.CRDT_CONT_ID AS CRDT_CONT_ID,
         CASE
         WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND
              TA.BORW_USAGE_TYPE_CD = '100101' THEN
          '010301' --个人汽车贷款
         WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND
              TA.BORW_USAGE_TYPE_CD = '100102' THEN
          '010302' --房屋装修贷款
         WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND
              TA.BORW_USAGE_TYPE_CD IN ('100109') THEN
          '010301' --个人汽车贷款
         WHEN TTA.TAR_VALUE_CODE LIKE '0102%' AND
              TA.BORW_USAGE_TYPE_CD IN ('100201') THEN
          '010202' --商用车贷款
         WHEN A.BUS_BREED_ID IN
              ('201030200001', '201030200002', '201030200003') THEN
          '010101' --个人住房按揭商业贷款
         WHEN A.BUS_BREED_ID IN ('201030200001', '201030200002') AND
              TA.BORW_USAGE_TYPE_CD <> '100301' THEN
          '010101' --个人中长期住房贷款(个人住房按揭商业贷款)
         WHEN A.BUS_BREED_ID IN ('201030100001', '201030100002') AND
              TA.BORW_USAGE_TYPE_CD = '100301' THEN
          '010201' --个人中长期住房贷款(商业用房贷款)
         ELSE
          NVL(TTA.TAR_VALUE_CODE, A.BUS_BREED_ID)
       END AS LOAN_BIZ_TYP --业务品种
      FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04 A
      LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA --零售贷款合同信息表
        ON TA.CONT_ID = A.CRDT_CONT_ID
       AND TA.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CRDT_LMT_INFO TB --零售贷款授信额度信息
        ON TB.LMT_CONT_ID = A.CRDT_CONT_ID
       AND TB.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(贷款类型)
        ON A.BUS_BREED_ID = TTA.SRC_VALUE_CODE
       AND TTA.SRC_CLASS_CODE = 'STD0002'
       AND TTA.TAR_CLASS_CODE = 'T0001'
    )
  SELECT  V_P_DATE                                       AS DATA_DT                            --数据日期
         ,MIN(A.LGL_REP_ID)                              AS LGL_REP_ID                         --法人编号
         ,''                                             AS PRIM_CRDT_CONT_ID                  --主授信合同编号
         ,''                                             AS PRIM_CRDT_CONT_NM                  --主授信合同名称
         --客户维度不需要这两个字段 add by liuyu
         ,A.CUST_ID                                      AS CUST_ID                            --客户编号
         ,MAX(A.ORG_ID)                                  AS ORG_ID                             --机构编号
         ,'CNY'                                          AS CUR                                --币种
         ,CASE WHEN SUM(NVL(A.CRDT_LMT,0)) < SUM(NVL(A.ALDY_USE_LMT,0)) THEN SUM(NVL(A.ALDY_USE_LMT,0) * B.EXRT)
               ELSE SUM(NVL(A.CRDT_LMT,0) * B.EXRT )
          END                                            AS CRDT_TOTAL_LMT                     --授信总额度
         ,SUM(NVL(A.ALDY_USE_LMT,0) * B.EXRT)            AS ALDY_USE_LMT                       --已用额度
         ,NULL                                           AS EXP_CRDT_LMT                       --敞口授信额度
         ,NULL                                           AS EXP_ALDY_USE_LMT                   --敞口已用额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                    < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.CRDT_LMT,0) * B.EXRT ELSE 0 END)
          END                                            AS OPR_CRDT_TOT_AMT                   --经营授信总额
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0102%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
                                                         AS OPR_ALDY_USE_CRDT_TOT_AMT          --经营已用授信总额
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                    < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.CRDT_LMT,0) * B.EXRT ELSE 0 END)
          END                                            AS HSE_CRDT_LMT                       --住房授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0101%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
                                                         AS HSE_ALDY_USE_CRDT_LMT              --住房已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                    < SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.CRDT_LMT,0) * B.EXRT ELSE 0 END)
          END                                            AS CAR_LOAN_CRDT_LMT                  --车贷授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP = '010301' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
                                                         AS CAR_LOAN_ALDY_USE_CRDT_LMT         --车贷已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                    < SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.CRDT_LMT,0) * B.EXRT ELSE 0 END)
          END                                            AS SL_CRDT_LMT                        --助学授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP LIKE '0104%' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
                                                         AS SL_ALDY_USE_CRDT_LMT               --助学已用授信额度
         ,CASE WHEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.CRDT_LMT,0) ELSE 0 END)
                    < SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
               ELSE SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.CRDT_LMT,0) * B.EXRT ELSE 0 END)
          END                                            AS OTH_CNSMP_CRDT_LMT                 --其他消费授信额度
         ,SUM(CASE WHEN C.LOAN_BIZ_TYP = '010399' THEN NVL(A.ALDY_USE_LMT,0) * B.EXRT ELSE 0 END)
                                                         AS OTH_CNSMP_ALDY_USE_CRDT_LMT        --其他消费已用授信额度
         ,'Y'                                            AS CRDT_STAT                          --授信状态
         ,MIN(B.FIRST_CRDT_DT)                           AS FIRST_CRDT_DT                      --首次授信日期
         ,MIN(A.DEPT_LINE)                               AS DEPT_LINE                          --部门条线
         ,MIN(A.DATA_SRC)                                AS DATA_SRC                           --数据来源
         ,MIN(A.EFF_DT)                                  AS CRDT_APP_DT                        --授信申请日期
         ,MIN(A.CRDT_START_DT)                           AS CRDT_START_DT                      --授信开始日期
         ,MAX(A.CRDT_EXP_DT)                             AS CRDT_EXP_DT                        --授信结束日期
    FROM RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP04 A -- 授信额度主表临时表含授信维度
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO_BFD_TEMP05 B --首次授信日期
      ON B.CUST_ID = A.CUST_ID
    LEFT JOIN TMP C --根据业务品种划分经营和消费
      ON A.CRDT_CONT_ID = C.CRDT_CONT_ID
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO B -- 汇率表
      ON A.CUR = B.BASE_CUR
     AND B.CNV_CUR = 'CNY'
     AND B.DATA_DT = V_P_DATE
   WHERE A.DATA_DT = V_P_DATE
     AND A.CRDT_STAT = 'Y' -- add By liuyu 取有效额度统计授信总额
  GROUP BY A.CUST_ID;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


      -- 去掉表的主键，通过语句判断数据是否重复--

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'M_CRDT_LMT_SUB_BFD是否重复'; --22

  WITH TMP2 AS (
    SELECT DATA_DT,CRDT_CONT_ID,COUNT(1) AS CT
      FROM M_CRDT_LMT_SUB_BFD
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, CRDT_CONT_ID
    HAVING COUNT(1) > 1)

  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP2 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'M_CRDT_LMT_INFO_BFD是否重复'; --23

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,COUNT(1) AS CT
      FROM M_CRDT_LMT_INFO_BFD T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID
    HAVING COUNT(1) > 1)

  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_INIT_M_CRDT_LMT_INFO_BFD;
/

