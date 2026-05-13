CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_ASSET_DISPL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_ASSET_DISPL_INFO
  *  功能描述：资产清收处置信息
  *  创建日期：20220705
  *  开发人员：MW
  *  来源表：
  *  目标表：  S_ASSET_DISPL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230705  梅炜      首次创建
  *             2    20230912  潘金成    剔除898不良贷款的现金收回处置时点为关注类的数
  *             3    20231010  tzj       调整处置方式、处置金额字段的取数口径，剔除各个余额的上月关注本月不良、或者本月关注、正常
                                         新增字段贷款产品编号、贷款产品名称、核销日期、还款日期
                4    20231030  tzj       1.调整处置欠息金额、处置代垫费用 修改处置代垫费用字段 为0
                                         2.处置欠息金额字段 改成首先 判断核销日期是本月（0830-0929）的日期 -- 取（贷款核销信息）实核收回表内利息+实核收回表外利息
                                         3.所有处置金额均为0时，不需要展示在此表
                5    20231208 tzj        调整还款明细表的还款日期，精确到日频度，还款日期有 时分秒
                6    20240830 tzj        调整处置欠息金额字段，根据还款日期和核销日期判断
                7    20260204 HYF        调整年初本金取值
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER := 0;                                  -- 处理步骤
  V_PROC_NAME   VARCHAR2(100) := 'ETL_S_ASSET_DISPL_INFO';     -- 程序名称
  V_P_DATE      VARCHAR2(8);                                   -- 跑批数据日期
  V_STARTTIME   DATE;                                          -- 处理开始时间
  V_ENDTIME     DATE;                                          -- 处理结束时间
  V_SQLCOUNT    INTEGER := 0;                                  -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                 -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                  -- 来源系统
  V_STEP_DESC   VARCHAR2(200);                                 --任务名称
  V_TAB_NAME    VARCHAR2(100) ;                                --表名
  V_PART_NAME    VARCHAR2(100);                                 --分区名
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE);                                -- 获取跑批日期
  V_SYSTEM := '监管报送';                                       -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_ASSET_DISPL_INFO'; --表名
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
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 程序业务逻辑处理主体部分 --

  V_STEP := 3;
  V_STEP_DESC := '首次下调至不良信息加工';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE S_ASSET_DISPL_INFO_TMP1');
  INSERT INTO RRP_MDL.S_ASSET_DISPL_INFO_TMP1
  (DUBIL_ID
  ,ADJ_DT)
  SELECT
  DUBIL_ID                              AS DUBIL_ID      --借据编号
  ,TO_CHAR(MIN(ETL_DT),'YYYYMMDD')      AS ADJ_DT        --调整日期
  FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO T1  --联合网贷借据信息
  WHERE GREATEST(NVL(T1.PRIC_OVDUE_DAYS, 0), NVL(T1.INT_OVDUE_DAYS, 0)) >= 90
  GROUP BY DUBIL_ID
  ;
  V_STEP := 4;
  V_STEP_DESC := '897-资产清收处置信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.S_ASSET_DISPL_INFO
 (
      ID                   --序号
    ,DATA_DT               --数据日期
    ,ORG_ID                --机构号
    ,MGR_CUST_ID           --客户经理
    ,CUST_ID               --客户编号
    ,DUBIL_ID              --借据编号
    ,CUST_NAME             --客户名称
    ,CUST_TYPE             --客户类型
    ,CUST_CLS              --客户分类-小微企业标识
    ,INDUS                 --行业
    ,ENT_SCALE             --企业规模
    ,ASSET_TYPE            --资产类型
    ,BEGIN_YEAR_PRIC_BAL   --年初本金余额
    ,BEGIN_YEAR_LVL5_CL    --年初风险分类
    ,FIRST_TRUN_BAD_DT     --第一次下调不良时间
    ,RISK_CHECK_RESULT     --风险排查结果
    ,DISPL_LVL5_CL         --处置时风险分类
    ,DISPL_WAY             --处置方式
    ,ASSET_TRANSFER_TYPE   --资产转让类型
    ,DISPL_DT              --处置时间
    ,DISPL_AMT             --处置金额
    ,REPAY_SOURCE          --还款来源
    ,DISPL_OVD_INT         --处置欠息金额
    ,DISPL_FALT_INT        --处置罚息金额
    ,DISPL_COMP_INT        --处置复息金额
    ,DISPL_FEE             --处置代垫费用
    ,NOTE                  --备注
    ,BUS_MOD               --业务模式
    ,LOAN_PROD_ID          --贷款产品编号
    ,LOAN_PROD_NM          --贷款产品名称
    ,CNCL_DT               --核销日期
    ,REPAY_DT              --还款日期
      )
    WITH  UNITE_WL_REPAY AS
   (SELECT  DUBIL_ID
           ,CURRT_REPAY_PRIC AS CURRT_REPAY_PRIC
           ,CURR_REPAY_INT   AS CURR_REPAY_INT
           ,CURRT_REPAY_PNLT AS CURRT_REPAY_PNLT
           ,CURRT_REPAY_FEE  AS CURRT_REPAY_FEE
           ,TO_CHAR(REPAY_DT,'YYYYMMDD') AS REPAY_DT
           ,'还款明细'       AS DATA_SRC
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL T
     WHERE T.REPAY_DT < TO_DATE(V_P_DATE,'YYYYMMDD')  --20231208 tzj 调整还款明细表的还款日期，精确到日频度，还款日期有 时分秒
       AND T.REPAY_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
    UNION ALL  --modify by tzj 20231010
    SELECT  T4.RCPT_ID      AS DUBIL_ID
           ,T4.CNCL_LN_PRIN AS CURRT_REPAY_PRIC
           ,0               AS CURR_REPAY_INT
           ,0               AS CURRT_REPAY_PNLT
           ,0               AS CURRT_REPAY_FEE
           ,T4.CNCL_DT      AS REPAY_DT
           ,'核销明细'      AS DATA_SRC
      FROM RRP_MDL.M_LOAN_CNCL_INFO     T4    --贷款核销信息
     WHERE TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
       AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
       AND T4.DATA_DT = V_P_DATE
    )
   SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
     ROWNUM                   AS ID                   --序号
    ,V_P_DATE                 AS DATA_DT               --数据日期
    ,T1.ORG_ID                AS ORG_ID                --机构号
    ,'00100673'               AS MGR_CUST_ID           --客户经理
    ,T1.CUST_ID               AS CUST_ID               --客户编号
    ,T1.RCPT_ID               AS DUBIL_ID              --借据编号
    ,T2.CUST_NM               AS CUST_NAME            --客户名称
    ,'个人'                   AS CUST_TYPE            --客户类型
    ,CASE WHEN T1.INDTYPE IN ('01')
          THEN '个体工商户'
          WHEN T1.INDTYPE IN ('02')
          THEN '小微企业主'
          ELSE '其他'
     END                      AS CUST_CLS             --客户分类-小微企业标识
    ,T1.LOAN_DIR_IDY          AS INDUS                --行业
    ,''                       AS ENT_SCALE            --企业规模
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
           AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN CASE WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT >  T4.CNCL_DT  THEN '已核销资产'
                    WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT =  T4.CNCL_DT  THEN '不良贷款'
          WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT <  T4.CNCL_DT THEN '不良贷款'
                    ELSE  '不良贷款' END
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN '已核销资产'
          WHEN T3.LVL5_CL IN ('02')  --上月关注
          THEN '非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN '不良贷款'
          ELSE ''
     END                      AS ASSET_TYPE            --资产类型
    ,CASE WHEN T5.WRT_OFF_FLG = '1' THEN 0 
          WHEN SUBSTR(T5.SUBJ_ID,1,6) IN ('810601','710701') THEN 0
     ELSE T5.CURRT_BAL END    AS BEGIN_YEAR_PRIC_BAL  --年初本金余额
    ,CASE WHEN T5.LOAN_LEVEL5_CLS_CD IN ('00','10','90','99') THEN '正常'
          WHEN T5.LOAN_LEVEL5_CLS_CD IN ('20') THEN '关注'
          WHEN T5.LOAN_LEVEL5_CLS_CD IN ('30') THEN '次级'
          WHEN T5.LOAN_LEVEL5_CLS_CD IN ('40') THEN '可疑'
          WHEN T5.LOAN_LEVEL5_CLS_CD IN ('50') THEN '损失'
          ELSE '正常'
     END                      AS BEGIN_YEAR_LVL5_CL    --年初风险分类
    ,TO_DATE(T6.ADJ_DT,'YYYYMMDD')
                              AS FIRST_TRUN_BAD_DT    --第一次下调不良时间
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN 'R1'--不良贷款
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN 'R1'--'已核销资产'
          WHEN T3.LVL5_CL IN ('02')  --上月关注
          THEN 'R2'--'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN 'R1'--'不良贷款'
          ELSE ''
     END                      AS RISK_CHECK_RESULT    --风险排查结果
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN '损失'  --本月核销置为'损失'
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN '损失'  --已核销资产置为'损失'
          WHEN T3.LVL5_CL IN ('01') THEN '正常'
          WHEN T3.LVL5_CL IN ('02') THEN '关注'
          WHEN T3.LVL5_CL IN ('03') THEN '次级'
          WHEN T3.LVL5_CL IN ('04') THEN '可疑'
          WHEN T3.LVL5_CL IN ('05') THEN '损失'
     END                      AS DISPL_LVL5_CL        --处置时风险分类
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN CASE WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT >  T4.CNCL_DT  THEN '现金收回'
                    WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT =  T4.CNCL_DT AND T9.DATA_SRC = '还款明细'  THEN  '现金收回'  ----modify by tzj 20231010
                     WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT =  T4.CNCL_DT AND T9.DATA_SRC = '核销明细'  THEN  '呆账核销'
                    WHEN  T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT <  T4.CNCL_DT THEN '现金收回'
               ELSE  '呆账核销' END
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN '现金收回'--'已核销资产'
          WHEN T3.LVL5_CL IN ('02')  --上月关注
          THEN '现金收回'--'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05')-- 上月不良
          THEN '现金收回'--'不良问题贷款'
          ELSE ''
     END                      AS DISPL_WAY            --处置方式
    ,''                       AS ASSET_TRANSFER_TYPE  --资产转让类型
    ,TO_DATE(V_P_DATE,'YYYYMMDD') - 1
                              AS DISPL_DT              --处置时间
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN /*NVL(T4.CNCL_RETRV_PRIN,0)*/
               CASE WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT <  T4.CNCL_DT  THEN NVL(T9.CURRT_REPAY_PRIC,0)
                    WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT >=  T4.CNCL_DT THEN NVL(T9.CURRT_REPAY_PRIC,0)
                     ELSE  NVL(T4.CNCL_LN_PRIN,0) END  --根据吴楚菲口径应取实核贷款本金，通过还款日期、核销日期判断--modify by tzj 20231010
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN /*NVL(T4.CNCL_RETRV_PRIN,0)*/ NVL(T9.CURRT_REPAY_PRIC,0)--'已核销资产'
          WHEN T3.LVL5_CL IN ('02') --上月关注
          THEN /*NVL(T7.PRIC_BAL,0)*/ NVL(T9.CURRT_REPAY_PRIC,0)  --'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN /*NVL(T7.PRIC_BAL,0)*/NVL(T9.CURRT_REPAY_PRIC,0)  --'不良问题贷款'
          ELSE 0
     END                      AS DISPL_AMT            --处置金额  --modify by tzj 20231010
    ,''                       AS REPAY_SOURCE          --还款来源
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN
               CASE WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT >  T4.CNCL_DT THEN NVL(T9.CURR_REPAY_INT,0)
                    WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT =  T4.CNCL_DT AND T9.DATA_SRC = '还款明细'  THEN NVL(T9.CURR_REPAY_INT,0)
                    WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT =  T4.CNCL_DT AND T9.DATA_SRC = '核销明细'  THEN NVL(T4.CNCL_IN_TAM_INT,0)+NVL(T4.CNCL_OUT_TAM_INT,0)  --实核表内利息 + 实核表外利息update by tzj at 20231030
                    WHEN T9.DUBIL_ID IS NOT NULL AND T9.REPAY_DT <  T4.CNCL_DT THEN NVL(T9.CURR_REPAY_INT,0)
                END   -- 20240830 tzj 调整处置欠息金额字段，根据还款日期和核销日期判断
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN /*NVL(T4.CNCL_RETRV_IN_TAM_INT,0)+NVL(T4.CNCL_RETRV_OUT_TAM_INT,0)*/NVL(T9.CURR_REPAY_INT,0) --'已核销资产'
          WHEN T3.LVL5_CL IN ('02') --上月关注
          THEN /*NVL(T7.IN_BS_OVER_INT_BAL,0) + NVL(T7.OFF_BS_OVER_INT_BAL,0)*/NVL(T9.CURR_REPAY_INT,0) --'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN /*NVL(T7.IN_BS_OVER_INT_BAL,0) + NVL(T7.OFF_BS_OVER_INT_BAL,0)*/NVL(T9.CURR_REPAY_INT,0) --'不良问题贷款'
          ELSE 0
     END                      AS DISPL_OVD_INT        --处置欠息金额
    ,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN 0
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN 0 --'已核销资产'
          WHEN T3.LVL5_CL IN ('02')  --上月关注
          THEN /*NVL(T7.RECVBL_PNLT,0)*/NVL(T9.CURRT_REPAY_PNLT,0)  --'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN /*NVL(T7.RECVBL_PNLT,0)*/NVL(T9.CURRT_REPAY_PNLT,0) --'不良问题贷款'
          ELSE 0
     END                      AS DISPL_FALT_INT        --处置罚息金额
    ,0                        AS DISPL_COMP_INT        --处置复息金额
    /*,CASE WHEN (TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
            AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1)
          THEN NVL(T8.WRT_OFF_RETRA_ADVC_FEE,0)
          WHEN TO_DATE(T4.CNCL_DT,'YYYYMMDD') < TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          THEN NVL(T9.CURRT_REPAY_FEE,0) --'已核销资产'
          WHEN T3.LVL5_CL IN ('02')  --上月关注
          THEN NVL(T9.CURRT_REPAY_FEE,0) --'非不良问题贷款'
          WHEN T3.LVL5_CL IN('03','04','05') -- 上月不良
          THEN NVL(T9.CURRT_REPAY_FEE,0)--'不良问题贷款'
          ELSE 0
     END                           AS DISPL_FEE            --处置代垫费用*/
      ,0                           AS DISPL_FEE           --处置代垫费用  update by tzj 处置代垫费用置 0
      ,''                          AS NOTE                  --备注
      ,''                          AS BUS_MOD              --业务模式
      ,T1.LOAN_PROD_ID             AS LOAN_PROD_ID         --贷款产品编号
      ,T1.LOAN_PROD_NM             AS LOAN_PROD_NM         --贷款产品名称
      ,T4.CNCL_DT                  AS CNCL_DT              --核销日期
      ,T9.REPAY_DT                 AS REPAY_DT             --还款日期
   FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO                         T1    --表内借据信息
   LEFT JOIN RRP_MDL.M_CUST_IND_INFO                          T2    --个人客户基础信息
     ON T1.CUST_ID = T2.CUST_ID
    AND T2.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO                    T3    --表内借据信息 --上月
     ON T1.RCPT_ID = T3.RCPT_ID
    AND T3.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD')
    AND T3.DATA_SRC = '联合网贷'
   LEFT JOIN RRP_MDL.M_LOAN_CNCL_INFO                         T4    --贷款核销信息
     ON T1.RCPT_ID = T4.RCPT_ID
    AND T4.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO            T5    --联合网贷借据信息 --上年底
     ON T1.RCPT_ID = T5.DUBIL_ID
    AND T5.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1
   LEFT JOIN RRP_MDL.S_ASSET_DISPL_INFO_TMP1                  T6    --临时表-加工首次下调至不良时间
     ON T1.RCPT_ID = T6.DUBIL_ID
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO            T7    --联合网贷借据信息 --当天
     ON T1.RCPT_ID = T7.DUBIL_ID
    AND T7.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO          T8    --联合网贷核销信息
     ON T1.RCPT_ID = T8.DUBIL_ID
    AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.UNITE_WL_REPAY                           T9    --联合网贷还款
     ON T1.RCPT_ID = T9.DUBIL_ID
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC = '联合网贷'
     AND ((TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
     AND TO_DATE(T4.CNCL_DT,'YYYYMMDD') >=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') -1)
     OR T9.DUBIL_ID IS NOT NULL)
     AND (TO_DATE(T4.CNCL_DT,'YYYYMMDD') = TO_DATE(V_P_DATE,'YYYYMMDD') - 1
          OR TO_DATE(T4.CNCL_DT,'YYYYMMDD') <= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
          OR (T3.LVL5_CL IN ('02') AND T1.LVL5_CL IN ('01','02'))
          /* OR (T3.LVL5_CL IN('03','04','05') OR (T3.LVL5_CL IN ('02') AND T1.LVL5_CL IN ('03','04','05')) )) */
          OR (T3.LVL5_CL IN('03','04','05') OR (T3.LVL5_CL IN ('02') AND SUBSTR(T1.ORG_ID,1,3) <> '898' AND T1.LVL5_CL IN ('03','04','05')) ))
      /* mdf by panjincheng 20230912 根据吴楚菲口径剔除898不良贷款的现金收回处置时点为关注类的数 */
   ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_S_ASSET_DISPL_INFO;
/

