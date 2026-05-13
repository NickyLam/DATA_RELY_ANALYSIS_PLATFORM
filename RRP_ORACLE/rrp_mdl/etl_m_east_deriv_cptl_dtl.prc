CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_EAST_DERIV_CPTL_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_EAST_DERIV_CPTL_DTL
  *  功能描述：即期及衍生品交易信息表
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_EAST_DERIV_CPTL_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  *             2    20221122  HULJ      增加数据重复校验
  *             3    20230523  MW        修改结售汇客户号取值
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_EAST_DERIV_CPTL_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_EAST_DERIV_CPTL_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入即期及衍生品交易信息表--资金系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_DERIV_CPTL_DTL
    (DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,ORG_ID            --机构编号
    ,TRA_ID            --交易编号
    ,BIZ_VRTY          --业务品种
    ,BASE_AST_TYP      --基础资产类型
    ,BASE_AST_NM       --基础资产名称
    ,TRA_TYP           --交易类型
    ,CONT_CL           --合约种类
    ,TRA_STAT          --交易状态
    ,BUYER_NM          --买方名称
    ,BUYER_CUST_ID     --买方客户统一编号
    ,SELLER_NM         --卖方名称
    ,SELLER_CUST_ID    --卖方客户统一编号
    ,TRA_DT            --交易日期
    ,TRA_TM            --交易时间
    ,VAL_DT            --起息日期
    ,EXP_DT            --到期日期
    ,END_DT            --截止日期
    ,DELY_FREQ         --交割频率
    ,ULYG_NUM          --标的数量
    ,ULYG_NUM_UNIT     --标的数量单位
    ,DEAL_PRC          --成交价格
    ,DEAL_PRC_UNIT     --成交价格单位
    ,TRA_PLACE         --交易场所
    ,DELY_MODE         --交割方式
    ,OPTION_TYP        --期权类型
    ,EXER_MODE         --行权方式
    ,EXER_PRC          --行权价格
    ,EXER_PRC_UNIT     --行权价格单位
    ,MRGN_FLG          --保证金标志
    ,PRIM_AGRT_NM      --主协议名称
    ,CNTRL_CNTPR_NM    --中央交易对手
    ,VALT_AMT          --估值金额
    ,VALT_CUR          --估值币种
    ,VALT_DT           --估值日期
    ,TRA_EMP_NO        --交易员工号
    ,APRV_PSN_NO       --审批人工号
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
    )
  SELECT V_P_DATE                                           AS DATA_DT           --数据日期
         ,'9999'                                            AS LGL_REP_ID        --法人编号
         ,'896'                                             AS ORG_ID            --机构编号
         ,A.BUS_ID                                          AS TRA_ID            --交易编号
         ,CASE WHEN A.FST_CURR_CD = 'CNY' OR A.SECD_CURR_CD = 'CNY'
               THEN '即期结售汇'
               ELSE '即期外汇买卖'
           END                                              AS BIZ_VRTY          --业务品种
         ,'02'                                              AS BASE_AST_TYP      --基础资产类型
         ,A.FST_CURR_CD||A.SECD_CURR_CD                     AS BASE_AST_NM       --基础资产名称
         ,DECODE(A.PORTF_TYPE_NAME,'市场平盘','03','05')    AS TRA_TYP           --交易类型
         ,'01'                                              AS CONT_CL           --合约种类
         ,'01'                                              AS TRA_STAT          --交易状态
         ,C.CN_NAME                                         AS BUYER_NM          --买方名称
         ,C.CUST_ID                                         AS BUYER_CUST_ID     --买方客户统一编号  MODIFY BY XIEYUGENG 20221021
         ,'广东华兴银行股份有限公司'                        AS SELLER_NM         --卖方名称
         ,'B1194H244050001'                                 AS SELLER_CUST_ID    --卖方客户统一编号
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                     AS TRA_DT            --交易日期
         ,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT,'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS') AS TRA_TM --交易时间
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                    AS VAL_DT            --起息日期
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                    AS EXP_DT            --到期日期
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                    AS END_DT            --截止日期
         ,NULL                                              AS DELY_FREQ         --交割频率
         ,DECODE(A.TRAN_DIR_CD,'02',ABS(A.FST_CURR_TRAN_AMT),ABS(A.SECD_CURR_TRAN_AMT))  AS ULYG_NUM       --标的数量
         ,DECODE(A.TRAN_DIR_CD,'02',A.FST_CURR_CD,A.SECD_CURR_CD)                        AS ULYG_NUM_UNIT  --标的数量单位
         ,DECODE(A.TRAN_DIR_CD,'01',ABS(A.FST_CURR_TRAN_AMT),ABS(A.SECD_CURR_TRAN_AMT))  AS DEAL_PRC       --成交价格
         ,DECODE(A.TRAN_DIR_CD,'01',A.FST_CURR_CD,A.SECD_CURR_CD)                        AS DEAL_PRC_UNIT  --成交价格单位
         ,DECODE(A.TRAN_SITE_CD,'02','中国外汇交易中心','场外')                          AS TRA_PLACE      --交易场所
         ,CASE WHEN A.CLEAR_WAY_CD IN ('1','3') THEN '03'
               ELSE '01'
           END                                              AS DELY_MODE         --交割方式
         ,NULL                                              AS OPTION_TYP        --期权类型
         ,NULL                                              AS EXER_MODE         --行权方式
         ,NULL                                              AS EXER_PRC          --行权价格
         ,NULL                                              AS EXER_PRC_UNIT     --行权价格单位
         ,'N'                                               AS MRGN_FLG          --保证金标志
         ,NULL                                              AS PRIM_AGRT_NM      --主协议名称
         ,NULL                                              AS CNTRL_CNTPR_NM    --中央交易对手
         ,NULL                                              AS VALT_AMT          --估值金额
         ,NULL                                              AS VALT_CUR          --估值币种
         ,NULL                                              AS VALT_DT           --估值日期
         ,E.EMP_NO                                          AS TRA_EMP_NO        --交易员工号
         ,'00200802'                                        AS APRV_PSN_NO       --审批人工号
         ,'800976'                                          AS DEPT_LINE         --部门条线
         ,SUBSTR(A.JOB_CD,0,4)                              AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_IML_AGT_FX_SPOT A --外汇即期交易
   INNER JOIN (SELECT ORI_DEAL_SQNO,MAX(DEAL_SQNO) AS LAST_DEAL_SQNO
                 FROM (SELECT CONNECT_BY_ROOT(SPOT.BUS_ID) AS ORI_DEAL_SQNO,SPOT.BUS_ID AS DEAL_SQNO
                         FROM RRP_MDL.O_IML_AGT_FX_SPOT SPOT --外汇即期交易
                        START WITH RELA_TRAN_ID = 0
                      CONNECT BY SPOT.RELA_TRAN_ID = PRIOR SPOT.BUS_ID) TMP_DATA
                GROUP BY ORI_DEAL_SQNO) B
      ON B.LAST_DEAL_SQNO = A.BUS_ID
    LEFT JOIN RRP_MDL.O_IML_PTY_FX_CAP_CNTPTY C --交易对手信息 --MODIFY BY XIEYUGENG 20221021 数仓重新下发该表 暂时先用视图 20221022 已更改为O层表
      ON C.CNTPTY_ID = A.CNTPTY_ID
    LEFT JOIN RRP_MDL.ADD_TRA_EMP_NO E --交易员工补录表
      ON E.ACCT_ID = A.DEALER_ACCT_NUM --MODIFY BY XIEYUGENG 20221018
   WHERE A.PORTF_TYPE_NAME IN ('自营买卖','市场平盘')--MDY 剔除代客数据 PY 20220602
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入即期及衍生品交易信息表--逻辑2-核心系统数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_DERIV_CPTL_DTL
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,ORG_ID                    --机构编号
    ,TRA_ID                    --交易编号
    ,BIZ_VRTY                  --业务品种
    ,BASE_AST_TYP              --基础资产类型
    ,BASE_AST_NM               --基础资产名称
    ,TRA_TYP                   --交易类型
    ,CONT_CL                   --合约种类
    ,TRA_STAT                  --交易状态
    ,BUYER_NM                  --买方名称
    ,BUYER_CUST_ID             --买方客户统一编号
    ,SELLER_NM                 --卖方名称
    ,SELLER_CUST_ID            --卖方客户统一编号
    ,TRA_DT                    --交易日期
    ,TRA_TM                    --交易时间
    ,VAL_DT                    --起息日期
    ,EXP_DT                    --到期日期
    ,END_DT                    --截止日期
    ,DELY_FREQ                 --交割频率
    ,ULYG_NUM                  --标的数量
    ,ULYG_NUM_UNIT             --标的数量单位
    ,DEAL_PRC                  --成交价格
    ,DEAL_PRC_UNIT             --成交价格单位
    ,TRA_PLACE                 --交易场所
    ,DELY_MODE                 --交割方式
    ,OPTION_TYP                --期权类型
    ,EXER_MODE                 --行权方式
    ,EXER_PRC                  --行权价格
    ,EXER_PRC_UNIT             --行权价格单位
    ,MRGN_FLG                  --保证金标志
    ,PRIM_AGRT_NM              --主协议名称
    ,CNTRL_CNTPR_NM            --中央交易对手
    ,VALT_AMT                  --估值金额
    ,VALT_CUR                  --估值币种
    ,VALT_DT                   --估值日期
    ,TRA_EMP_NO                --交易员工号
    ,APRV_PSN_NO               --审批人工号
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,BUS_TYP                   --业务类型
    ,DR_ACC_ID                 --借方账户编号
    ,CR_ACC_ID                 --贷方账户编号
    ,BUY_CUR                   --买入币种
    ,BUYR_EXRT                 --买方汇率
    ,SELL_CUR                  --卖出币种
    ,SELLR_EXRT                --卖方汇率
    )
  WITH CLERK_TMP AS (
    SELECT T.TELLER_ID,T.CLERK_ID,T.EMPLY_TYPE_CD,T.EMPYT_DT,T.JOBS_CD,T.TELLER_DIRECTOR_ID
      FROM (
      SELECT TELLER_ID,CLERK_ID,EMPLY_TYPE_CD,EMPYT_DT,JOBS_CD,TELLER_DIRECTOR_ID,ROW_NUMBER() OVER(PARTITION BY TELLER_ID ORDER BY EMPYT_DT DESC) AS NUM
        FROM RRP_MDL.O_ICL_CMM_CLERK_INFO --行员信息表
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND CLERK_ID IS NOT NULL
        AND TELLER_FLG = '1'
        AND EMPYT_DT <= ETL_DT) T
    WHERE T.NUM = 1)
  SELECT DISTINCT TO_CHAR(A.ETL_DT,'YYYYMMDD')          AS DATA_DT         --数据日期
         ,A.LP_ID                                       AS LGL_REP_ID      --法人编号
         ,A.TRAN_ORG_ID                                 AS ORG_ID          --机构编号
         ,A.TRAN_FLOW_NUM                               AS TRA_ID          --交易编号
         ,'即期结售汇'                                  AS BIZ_VRTY        --业务品种
         ,'02'                                          AS BASE_AST_TYP    --基础资产类型
         ,CASE WHEN A.BUS_TYPE_CD='B' THEN (CASE WHEN A.BUY_CURR_CD = 'AUS' THEN 'AUD' ELSE A.BUY_CURR_CD END)||(CASE WHEN A.SELL_CURR = 'AUS' THEN 'AUD' ELSE A.SELL_CURR END)
               WHEN A.BUS_TYPE_CD='S' THEN (CASE WHEN A.SELL_CURR = 'AUS' THEN 'AUD' ELSE A.SELL_CURR END)||(CASE WHEN A.BUY_CURR_CD = 'AUS' THEN 'AUD' ELSE A.BUY_CURR_CD END)
           END                                          AS BASE_AST_NM     --基础资产名称 modify by tangan at 20221226
         ,'02'                                          AS TRA_TYP         --交易类型
         ,'01'                                          AS CONT_CL         --合约种类
         ,'01'                                          AS TRA_STAT        --交易状态
         ,NVL(M.CUST_NAME,M1.CUST_NAME)                 AS BUYER_NM        --买方名称 MODIFY BY XIEYUGENG 20221012  添加买方名称取数途径
         ,CASE WHEN LENGTH(A.CUST_ID) < 10
               THEN T.CUST_ID
               ELSE A.CUST_ID
           END                                          AS BUYER_CUST_ID   --买方客户统一编号     MODIFY BY MW 20230523
         ,C.ORG_NAME                                    AS SELLER_NM       --卖方名称
         ,C.FIN_LICS_NUM                                AS SELLER_CUST_ID  --卖方客户统一编号  MODIFY BY TANGAN AT 20221112
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                 AS TRA_DT          --交易日期
         ,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT, 'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS') AS TRA_TM --交易时间
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                 AS VAL_DT          --起息日期
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                 AS EXP_DT          --到期日期
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                 AS END_DT          --截止日期
         ,NULL                                          AS DELY_FREQ       --交割频率
         ,A.SELL_AMT                                    AS ULYG_NUM        --标的数量
         ,CASE WHEN A.SELL_CURR = 'AUS' THEN 'AUD' ELSE A.SELL_CURR END AS ULYG_NUM_UNIT --标的数量单位 modify by tangan at 20221226
         ,A.BUY_AMT                                     AS DEAL_PRC        --成交价格
         ,CASE WHEN A.BUY_CURR_CD = 'AUS' THEN 'AUD' ELSE A.BUY_CURR_CD END AS DEAL_PRC_UNIT --成交价格单位 modify by tangan at 20221226
         ,'场外'                                        AS TRA_PLACE       --交易场所
         ,'01'                                          AS DELY_MODE       --交割方式
         ,NULL                                          AS OPTION_TYP      --期权类型
         ,NULL                                          AS EXER_MODE       --行权方式
         ,NULL                                          AS EXER_PRC        --行权价格
         ,NULL                                          AS EXER_PRC_UNIT   --行权价格单位
         ,'N'                                           AS MRGN_FLG        --保证金标志
         ,NULL                                          AS PRIM_AGRT_NM    --主协议名称
         ,NULL                                          AS CNTRL_CNTPR_NM  --中央交易对手
         ,NULL                                          AS VALT_AMT        --估值金额
         ,NULL                                          AS VALT_CUR        --估值币种
         ,NULL                                          AS VALT_DT         --估值日期
         ,NVL(NVL(TRIM(B.CLERK_ID),B1.CLERK_ID),G.CLERK_ID) AS TRA_EMP_NO  --交易员工号
         ,H.CLERK_ID                                    AS APRV_PSN_NO     --审批人工号
         ,'800976'                                      AS DEPT_LINE       --部门条线
         ,SUBSTR(A.JOB_CD,0,4)                          AS DATA_SRC        --数据来源
         ,A.BUS_TYPE_CD                                 AS BUS_TYP         --业务类型
         ,A.DR_CUST_ACCT_NUM                            AS DR_ACC_ID       --借方账户编号
         ,A.CR_CUST_ACCT_NUM                            AS CR_ACC_ID       --贷方账户编号
         ,A.BUY_CURR_CD                                 AS BUY_CUR         --买入币种
         ,A.BUYER_EXCH_RAT                              AS BUYR_EXRT       --买方汇率
         ,A.SELL_CURR                                   AS SELL_CUR        --卖出币种
         ,A.SELLER_EXCH_RAT                             AS SELLR_EXRT      --卖方汇率
    FROM RRP_MDL.O_IML_EVT_WRT_GUAT_TRAN_FLOW A --结售汇交易明细
    LEFT JOIN CLERK_TMP B
      ON B.TELLER_ID = A.CORE_TRAN_TELLER_ID --MODIFY BY TANGAN AT 20221121 根据BUG_055901调整交易柜员号，取EVT_WRT_GUAT_TRAN_FLOW.CORE_TRAN_TELLER_ID
    LEFT JOIN CLERK_TMP B1
      ON B1.TELLER_DIRECTOR_ID = A.CORE_TRAN_TELLER_ID --MODIFY BY TANGAN AT 20221121 根据BUG_055901调整交易柜员号，取EVT_WRT_GUAT_TRAN_FLOW.CORE_TRAN_TELLER_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.TRAN_ORG_ID
    LEFT JOIN RRP_MDL.O_IML_EVT_INTSTL_TRAN_FLOW_EVT F --国结交易流水事件
      ON F.SRC_EVT_ID = A.EVT_ID
     AND F.AUTH_STATUS_CD = 'R'
    LEFT JOIN CLERK_TMP G
      ON G.TELLER_ID = F.RGST_TELLER_ID
    LEFT JOIN CLERK_TMP H
      ON H.TELLER_ID = F.BUS_TELLER_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO M --个人客户基本信息
      ON M.CUST_ID = A.CUST_ID
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO M1 --对公客户基本信息 --ADD BY XIEYUGENG 20221012 关联对公客户基本信息取客户名称
      ON M1.CUST_ID = A.CUST_ID
     AND M1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T
      ON T.ACCT_ID = A.CR_ACCT_ID
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.BUS_TYPE_CD IN ('B','S')  --3结汇 5售汇
     --AND A.TRAN_STATUS_CD = '413' --交易状态正常
     AND TRIM(A.REVS_TRAN_CD) IS NULL --过滤冲正数据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '判断数据是否重复';
  V_STARTTIME := SYSDATE;
  --增加数据重复校验
    WITH TMP1 AS (
  SELECT DATA_DT,TRA_ID,COUNT(1)
    FROM RRP_MDL.M_EAST_DERIV_CPTL_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  IF V_SQLCOUNT > 0 THEN
    O_ERRCODE := '1';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
    RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '程序跑批结束';
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_EAST_DERIV_CPTL_DTL;
/

