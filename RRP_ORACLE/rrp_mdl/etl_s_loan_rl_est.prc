CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_RL_EST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_LOAN_RL_EST
  *  功能描述：房地产贷款整合表
  *  创建日期：20220525
  *  开发人员：
  *  来源表：
  *  目标表： S_LOAN_RL_EST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20221117  许明尊   增加资本金比例字段（S67报表）
  *            2     20221126  徐菲     增加项目总投资，押品最新价值；更改数据范围，
  *            3     20221129  徐菲     修改房产抵押标志逻辑，增加月物业管理费，房屋首付金额，售价总额
  *            4     20221130  徐菲     新增利率是否固定，利率类型
               5     20230116  卢伟博   新增审批金额，终审日期，申请状态，申请流水号
               6     20231117  LWB       新增展期未到期贷款
               7     20231116  LWB       修改取应还日期在本月的数据
               8     20231226  HYF      修改DSR，优先通过家庭月收入计算
               9     20240105  LWB      修改利率类型的出数口径
               10    20240208  LWB      同步房地产小基表，修改应还本金及利息的口径
               11    20240308  LWB      201406302312002默认建筑面积为174.67平方，
                                        新增民营房企开发项目相关的个人住房贷款标志
               12    20240315  LWB      修改固定利率的出数口径
               13    20240423  LWB      'R202204280016106150'统计为经营性物业贷款
               14    20241112  LWB      修改'R202204280016106150'统计为经营性物业贷款的逻辑 
               15    20251020  HYF      押品重构需求，调整押品类型取值过滤
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'S_LOAN_RL_EST'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_S_LOAN_RL_EST'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN_RL_EST T WHERE T.DATA_DT = V_P_DATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.S_LOAN_RL_EST';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_LOAN_RL_EST','1', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '房地产贷款整合表--资产业务';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_RL_EST(
    DATA_DT, --数据日期
    LGL_REP_ID, --法人编号
    ORG_ID, --机构编号
    CUST_ID, --客户编号
    RCPT_ID, --借据编号
    CUR, --币种
    LOAN_BAL, --贷款余额
    --LOAN_AMT, --放款金额
    DSBR_AMT, --放款金额
    LOAN_ACT_DSTR_DT, --贷款实际发放日期
    ORIG_EXP_DT, --原始到期日期
    INT_ADJ, --利息调整
    RATE_TYP, --利率类型
    ACT_RATE, --实际利率
    GUA_MODE, --担保方式
    CORP_CUST_TYP, --对公客户类型
    RL_EST_LOAN_TYP, --房地产贷款类型
    AFP_TYP, --保障性安居工程类型
    LVL5_CL, --五级分类
    EXTN_FLG, --展期标志
    OVD_DAYS, --逾期天数
    PRIN_OVD_AMT, --本金逾期金额
    CPTL_FND, --资本金
    LTV, --LTV
    DSR, --DSR
    ALDY_HAVE_HSE_NUM, --已有住房套数
    HSE_BLDG_AREA, --房屋建筑面积
    OPR_PTY_LOAN_FLG, --经营性物业贷款标志
    HSE_PTY_MTG_FLG, --房产抵押标志
    IND_HSE_LOAN_TYP, --个人住房贷款类型
    HSE_TYP, --房屋类型
    SCRTZ_FLG, --证券化标志
    DSBR_DT, --放款日期
    TRF_IN_LOAN_FLG, --转入贷款标志
    MAIN_GUA_MODE, --主要担保方式
    DEPT_LINE, --部门条线
    DATA_SRC, --数据来源
    /*NORM_REPY_AMT,--正常还款金额
    PART_ADV_REPY_AMT,--部分提前还款金额
    FULL_ADV_REPY_AMT,--全额提前还款金额*/
    CPTL_FND_RATE, --资本金比例
    PRIN_OVD_AMT_S67, --统计逾期金额_S67
    PROJ_TOT_INVEST, --项目总投资
    BANK_IDNT_PRC_VAL, --押品最新估值
    MON_PTY_CHGS, --月物业费
    HOUSE_FIRST_PAY_AMT, --房屋首付额
    HOUSE_TOT_PRICE, --房屋总价
    FIXED_INT_MARK, --利率是否固定
    PRC_BASE_TYP, --定价基准类型
    LPR, --LPR
    HOUSE_LEASE_TYPE, --住房租赁贷款类别
    APPLY_SYS, --申请状态
    APPROVE_AMT, --审批金额
    MTG_LOAN_FLG, --抵押贷款标识
    LOAN_APPL_FLOW_NUM, --贷款申请流水号
    APPROVE_DT, --终审时间
    RENEW_FLG_WDQ, --展期未到期标志
    SFMYFQKFXM,
    INT_RAT_FLO_VAL
    )
  WITH GUA_COLL_INFO AS (
  /*SELECT F.BIZ_CONT_ID BIZ_CONT_ID
          ,SUM(NVL(H.BANK_IDNT_PRC_VAL,0)) BANK_IDNT_PRC_VAL
          --,MAX(CASE WHEN H.COLL_TYP IN ('C01','C02') THEN 'Y' ELSE 'N' END) AS REL_COLL
          ,MAX(CASE WHEN H.COLL_TYP IN ('C01','C02','C03','C04','C05','C06') THEN 'Y' ELSE 'N' END) AS REL_COLL --MDF BY XMZ 20230202 业务容炳华确认房地产贷款类型为这6类
    FROM RRP_MDL.M_GUA_REL_BSN_CONT F --担保合同和业务合同对应关系表
    LEFT JOIN RRP_MDL.M_GUA_REL_COLL I --担保合同与押品对应关系表 --抵质押物价值拆分表 M_GUA_COLL_VAL_SPLT
      ON I.GUA_CONT_ID = F.GUA_CONT_ID
     AND I.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_GUA_COLL_INFO H --抵质押物详细信息
      ON H.COLL_ID = I.COLL_ID
     AND H.DATA_DT = V_P_DATE
   WHERE F.DATA_DT = V_P_DATE
   GROUP BY BIZ_CONT_ID)*/
  SELECT A.CREDNO,
         SUM(NVL(A.CONFMAMT,0)) CONFMAMT,
         MAX(CASE WHEN B.FIELDIDX IN ('30','31','32','33','34','35') THEN 'Y' ELSE 'N' END) AS REL_COLL --MDF BY XMZ 20230202 业务容炳华确认房地产贷款类型为这6类
    FROM RRP_MDL.S_G13_BASE A
    LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION B
      ON B.GUARTYPE = A.GUARTYPE
     --AND B.GUARTYPE <> 'ZY0304001'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DATA_DT = V_P_DATE
   GROUP BY A.CREDNO,B.FIELDIDX
   UNION ALL
  SELECT A.RCPT_ID,SUM(NVL(A.CONFMAMT,0)) CONFMAMT,'' REL_COLL
    FROM RRP_MDL.S_S67_YP A --个人住房贷款和个人购买商用房贷款取不到押品价值的借据由业务老师补录押品价值
   GROUP BY A.RCPT_ID) --MDF BY XMZ 20230209从G13押品表中取数
  SELECT DISTINCT
         A.DATA_DT                                 AS DATA_DT, --数据日期
         A.LGL_REP_ID                              AS LGL_REP_ID, --法人编号
         A.ORG_ID                                  AS ORG_ID, --机构编号
         A.CUST_ID                                 AS CUST_ID, --客户编号
         A.RCPT_ID                                 AS RCPT_ID, --借据编号
         A.CUR                                     AS CUR, --币种
         CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN ('810601','710701') THEN 0
              ELSE A.LOAN_BAL
          END                                      AS LOAN_BAL, --贷款余额
         A.LOAN_AMT                                AS LOAN_AMT, --放款金额
         A.LOAN_ACT_DSTR_DT                        AS LOAN_ACT_DSTR_DT, --贷款实际发放日期
         A.LOAN_ORIG_EXP_DT                        AS ORIG_EXP_DT, --原始到期日期
         A.INT_ADJ                                 AS INT_ADJ, --利息调整
         BB.INT_RAT_ADJ_WAY_CD                     AS RATE_TYP, --利率类型
         A.EXEC_RATE                               AS ACT_RATE, --实际利率
         A.GUA_MODE                                AS GUA_MODE, --担保方式
         C.CUST_CL                                 AS CORP_CUST_TYP, --对公客户类型
         CASE WHEN A.RCPT_ID IN ('R202204280016106150','50202409180011002') THEN '501'
              ELSE B.RL_EST_LOAN_TYP
          END                                      AS RL_EST_LOAN_TYP, --房地产贷款类型
         B.AFP_TYP                                 AS AFP_TYP, --保障性安居工程类型
         A.LVL5_CL                                 AS LVL5_CL, --五级分类
         CASE WHEN A.EXTN_CNT > 0 THEN 'Y'
              ELSE 'N'
          END                                      AS EXTN_FLG, --展期标志
         A.OVD_DAYS                                AS OVD_DAYS, --逾期天数
         A.OVD_PRIN_BAL                            AS PRIN_OVD_AMT, --本金逾期金额
         H.CPTL_FND                                AS CPTL_FND, --资本金
         CASE WHEN NVL(M.CONFMAMT, 0) = 0 THEN NULL
              ELSE (A.LOAN_BAL / M.CONFMAMT) * 100
          END                                      AS LTV, --LTV
         CASE WHEN NVL(D.FAMILY_MON_INCO,0) > 0 THEN (NVL(E.CURR_ISSUE_RECVBL_PRIC, 0) + NVL(E.CURR_ISSUE_INT_RECVBL, 0) +
                   NVL(B.MON_PTY_CHGS, 0)) / NVL(D.FAMILY_MON_INCO,0) * 100
              WHEN D.FAMILY_YEAR_INCOME > 0 THEN (NVL(E.CURR_ISSUE_RECVBL_PRIC, 0) + NVL(E.CURR_ISSUE_INT_RECVBL, 0) +
                   NVL(B.MON_PTY_CHGS, 0)) / (D.FAMILY_YEAR_INCOME / 12) * 100
              WHEN NVL(D.FAMILY_YEAR_INCOME, 0) = 0 THEN 0
          END                                      AS DSR, --DSR
         B.ALDY_HAVE_HSE_NUM                       AS ALDY_HAVE_HSE_NUM, --已有住房套数
         CASE WHEN B.RCPT_ID = '201406302312002' THEN 174.67
              WHEN B.RCPT_ID = '201509231413001' THEN 84.6
              WHEN B.RCPT_ID = '201506261101002' THEN 94.19
              WHEN B.RCPT_ID = '20150430927001' THEN 70.06
              WHEN B.RCPT_ID = '20150320896001' THEN 90.00
              ELSE B.HSE_PTY_BLDG_AREA
          END                                      AS HSE_BLDG_AREA, --房屋建筑面积 modify by lwb 20240308
         B.OPR_PTY_LOAN_FLG                        AS OPR_PTY_LOAN_FLG, --经营性物业贷款标志
         --B.HSE_PTY_MTG_FLG
         M.REL_COLL                                AS HSE_PTY_MTG_FLG, --房产抵押标志  --MDF BY XUFEI 20221129 修改逻辑，从押品表出
         B.IND_HSE_LOAN_TYP                        AS IND_HSE_LOAN_TYP, --个人住房贷款类型
         B.HSE_TYP                                 AS HSE_TYP, --房屋类型
         B.SCRTZ_FLG                               AS SCRTZ_FLG, --证券化标志
         A.LOAN_ACT_DSTR_DT                        AS DSBR_DT, --放款日期
         CASE WHEN G.CONT_ID IS NOT NULL THEN 'Y'
              ELSE 'N'
          END                                      AS TRF_IN_LOAN_FLG, --转入贷款标志
         A.GUA_MODE                                AS MAIN_GUA_MODE, --主担保方式
         A.DEPT_LINE                               AS DEPT_LINE, --部门条线
         A.DATA_SRC                                AS DATA_SRC, --数据来源
         /*CASE WHEN B.PAY_TYPE = '01' THEN B.PAY_AMT
                ELSE 0
          END                                      AS NORM_REPY_AMT, --正常还款金额
         CASE WHEN B.PAY_TYPE IN ('02','03') AND A.LOAN_BAL <> 0 THEN B.PAY_AMT
              ELSE 0
          END                                      AS PART_ADV_REPY_AMT, --部分提前还款金额
         CASE WHEN B.PAY_TYPE IN ('02','03') AND A.LOAN_BAL = 0 THEN B.PAY_AMT
              ELSE 0
          END                                      AS FULL_ADV_REPY_AMT, --全额提前还款金额*/
         CASE WHEN H.PROJ_TOT_INVEST = 0 OR H.PROJ_TOT_INVEST IS NULL THEN 0
              ELSE H.CPTL_FND / H.PROJ_TOT_INVEST * 100
          END                                      AS CPTL_FND_RATE, --资本金比例   ADD BY XMZ 20221117
         CASE WHEN A.OVD_DAYS = 0 THEN 0
              WHEN A.OVD_DAYS <= 90 AND (SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0101','0103','0104') OR A.LOAN_BIZ_TYP = '010201') --个人消费
                   AND A.GXH_PAY_TYPE IN ('1','2','6','7','8','9','11') --还款方式 1-等额本息  2-等额本金  6-气球贷  7-等额累进 8-等比累进  9-等本等息 11-按比例还本
                   AND A.GXH_PAY_FREQ = 'M' --还款频率 按月还款
              THEN NVL(A.OVD_PRIN_BAL, 0) * U.EXRT --逾期金额
              ELSE (NVL(A.LOAN_BAL, 0) + NVL(A.INT_ADJ, 0)) * U.EXRT --贷款余额
          END                                      AS PRIN_OVD_AMT_S67, --统计逾期金额_S67 --ADD BY XMZ 20221119
         H.PROJ_TOT_INVEST                         AS PROJ_TOT_INVEST, --项目总投资  --ADD BY XUFEI 20221125
         M.CONFMAMT                                AS CONFMAMT, --押品最新估值  --ADD BY XUFEI 20221125
         B.MON_PTY_CHGS                            AS MON_PTY_CHGS, --月物业费 --ADD BY XUFEI 20221129
         NVL(AA.SFJE,B.HOUSE_FIRST_PAY_AMT)        AS HOUSE_FIRST_PAY_AMT, --房屋首付额 --ADD BY XUFEI 20221129
         NVL(AA.FWZJ,B.HOUSE_TOT_PRICE)            AS HOUSE_TOT_PRICE, --房屋总价 --ADD BY XUFEI 20221129
         A.FIXED_INT_MARK                          AS FIXED_INT_MARK, --利率是否固定 --ADD BY XUFEI 20221130
         A.PRC_BASE_TYP                            AS PRC_BASE_TYP, --定价基准类型   --ADD BY XUFEI 20221130
         A.BASE_RATE                               AS LPR, --LPR
         CASE WHEN M1.JYWYM IS NOT NULL THEN DECODE(M1.ZFZLDKLB,
                   '01','01' --住房租赁开发贷款
                  ,'02','02' --住房租赁经营贷款
                  ,'03','03' --住房租赁购买贷款
                  ,'04','04' --住房租赁消费贷款
                  ,'05','05' --其他
                  ,'NA')
              WHEN A.LOAN_STD_PROD_ID IN ('201010300006') THEN '04'
              ELSE 'NA'
          END                                      AS HOUSE_LEASE_TYPE, --住房租赁贷款类别
         B.APPLY_SYS                               AS APPLY_SYS, --申请状态
         B.APPROVE_AMT                             AS APPROVE_AMT, --审批金额
         B.MTG_LOAN_FLG                            AS MTG_LOAN_FLG, --抵押贷款标识
         B.LOAN_APPL_FLOW_NUM                      AS LOAN_APPL_FLOW_NUM, --贷款申请流水号
         NVL(B.FINAL_JUD_END_DT,B.CONT_CREATE_DT)  AS APPROVE_DT, --终审时间（优先取终审结束时间，取不到则取合同创建日期）
         B.RENEW_FLG_WDQ                           AS RENEW_FLG_WDQ, --展期未到期标志
         CASE WHEN AAA.JJH IS NOT NULL THEN 'Y'
              ELSE 'N'
          END                                      AS SFMYFQKFXM,
         NVL(BB.INT_RAT_FLO_VAL,0)                 AS INT_RAT_FLO_VAL
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据表
    LEFT JOIN RRP_MDL.M_LOAN_RL_EST_SUB B --房地产贷款子表 改为左关联 MODIFY BY LWB 20241112
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S67_CONFIG AA
      ON AA.RCPT_ID = B.RCPT_ID
    LEFT JOIN RRP_MDL.CONFIG_S67_MYQYKF AAA
      ON AAA.JJH = B.RCPT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO BB --零售贷款借据信息
      ON BB.DUBIL_NUM = A.RCPT_ID
     AND BB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = A.CUST_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    /*LEFT JOIN (SELECT RCPT_ID, SUM(PRIN) AS PRIN, SUM(INT) AS INT
                 FROM RRP_MDL.M_LOAN_RP_PLAN_INFO --贷款还款计划表
                WHERE SUBSTR(PRIN_EXP_DT,1,6) = SUBSTR(V_P_DATE,1,6)--MODIFY BY LWB 修改取应还日期在本月的数据
                  AND DATA_DT = V_P_DATE
                GROUP BY RCPT_ID) E --MDF BY XMZ 20230203*/
   LEFT JOIN (SELECT DUBIL_ID
                    ,MAX(JOB_CD) AS JOB_CD
                    ,MAX(ACCT_ID) AS ACCT_ID
                    ,MAX(CUST_ID) AS CUST_ID
                    ,MAX(REPAYBL_DT) AS REPAYBL_DT
                    ,SUM(CURR_ISSUE_RECVBL_PRIC) AS CURR_ISSUE_RECVBL_PRIC
                    ,SUM(CURR_ISSUE_INT_RECVBL) AS CURR_ISSUE_INT_RECVBL
               FROM ICL.V_CMM_RETL_LOAN_REPAY_PLAN --零售贷款还款计划
              WHERE TRUNC(REPAYBL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              GROUP BY DUBIL_ID) E
      ON E.DUBIL_ID = A.RCPT_ID
    LEFT JOIN RRP_MDL.M_LOAN_TRF_SUB G --贷款借据转入子表
      ON G.RCPT_ID = A.RCPT_ID
     AND G.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_PROJ_SUB H --项目贷款子表
      ON H.CONT_ID = A.CONT_ID
     AND H.PROJ_TOT_INVEST <> 0
     AND H.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
      ON U.BASE_CUR = A.CUR
     AND U.CNV_CUR = 'CNY'
     AND U.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT CREDNO,SUM(CONFMAMT) CONFMAMT,MAX(REL_COLL) REL_COLL
                 FROM GUA_COLL_INFO GROUP BY CREDNO) M
      ON M.CREDNO = A.RCPT_ID
    LEFT JOIN RRP_MDL.M_ADD_DG_006_HOUSE_LAND M1 --补录表-对公-房地产小基表
      ON M1.JYWYM = A.RCPT_ID
     AND M1.DATA_DATE = A.DATA_DT
   WHERE /*A.RL_EST_LOAN_FLG = 'Y'*/
         (B.RL_EST_LOAN_TYP IS NOT NULL OR A.RCPT_ID IN ('R202204280016106150','50202409180011002')) --MDF BY XUFEI 20221125 更改数据范围
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_RL_EST;
/

