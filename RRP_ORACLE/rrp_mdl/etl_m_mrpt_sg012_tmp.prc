CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_SG012_TMP(I_P_DATE IN INTEGER, O_ERRCODE  OUT VARCHAR2)
 /**************************************************************************
  *  程序名称：ETL_M_MRPT_SG012_TMP
  *  功能描述：手工报表SG012临时表
  *  创建日期：20231102
  *  开发人员：XMY
  *  来源表  ：O_IML_EVT_PPPS_PS_AGT_PAY_FLOW
  *            O_IML_EVT_PPPS_PS_REFUND_FLOW
  *            O_IML_EVT_PPPS_PS_PAY_FLOW
  *            O_IML_EVT_UPS_AGT_PAY_FLOW
  *            O_IML_EVT_UPS_REFUND_FLOW
  *            O_IML_EVT_UPS_PAY_FLOW
  *            O_ICL_CMM_CUST_SIGN_PROD_INFO
  *            O_IML_REF_TRAN_BANK_CODE_PARA
  *            O_IOL_CCDB_EMP_BASE_INFO
  *            O_IOL_CCDB_SYS_ACCOUNT_INFO
  *            O_IML_EVT_INTELLGE_BRAC_BUS_FLOW
  *  目标表  ：RRP_MDL.M_MRPT_SG012_TMP  --手工报表SG012临时表
  *  修改情况：20240711 tzj  新增TQ1的STM、微信银行、视频银行、直销银行的户数和交易数 的各类指标
                             新增TQ2的支付产品化平台并发用户数、分布式服务治理平台并发用户数各类指标
               20250409 tzj  调整柜面交易笔数、柜面交易金额的逻辑，剔除STM
                             调整视频银行的账户数和交易笔数
               20250718 yang 过滤交易失败的柜面交易
               20260126 LAL  为适配新调度工具Moia，在程序结束的步骤增加返回值
  ***************************************************************************/
  AS
    I_STEP      INTEGER := 0;                           -- 处理步骤
    V_P_DATE    VARCHAR2(8);                            -- 跑批数据日期
    D_P_DATE    DATE;                                   -- 跑批数据日期
    D_STARTTIME DATE;                                   -- 处理开始时间
    D_ENDTIME   DATE;                                   -- 处理结束时间
    D_QUA_FDATE DATE;                                   -- 本季第一天
    D_QUA_PDATE DATE;                                   -- 本季末
    V_QUA_FDATE VARCHAR2(8);                            -- 本季第一天
    V_QUA_PDATE VARCHAR2(8);                            -- 本季末
    I_SQLCOUNT  INTEGER := 0;                           -- 更新或删除影响的记录数
    V_SQLMSG    VARCHAR2(1000);                         -- SQL执行描述信息
    V_SYSTEM    VARCHAR2(30);                           -- 来源系统
    I_STEP_DESC VARCHAR2(1000);                         -- 任务名称
    V_TAB_NAME  VARCHAR2(100);                          -- 表名称
    V_FREQ_FLAG VARCHAR2(10);                           -- 跑批频度标识
    V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_SG012_TMP'; -- 程序名称

  BEGIN
    O_ERRCODE := '0';
    -- 处理参数及月末等判断逻辑 --
    V_P_DATE    := TO_CHAR(I_P_DATE); -- 获取跑批日期
    D_P_DATE    := TO_DATE(V_P_DATE,'YYYY-MM-DD'); -- 获取跑批日期
    D_QUA_FDATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'); -- 本季第一天
    D_QUA_PDATE := ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),3)-1; -- 本季末
    V_QUA_FDATE := TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'Q'), 'YYYYMMDD'); --本季第一天
    V_QUA_PDATE := TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'Q'),3)-1, 'YYYYMMDD'); --本季末
    V_SYSTEM    := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
    V_TAB_NAME  := 'M_MRPT_SG012_TMP'; --表名称
    V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
    
    IF V_FREQ_FLAG = '1' THEN
  
    -- 支持重跑 --
    I_STEP      := 1;
    I_STEP_DESC := '-- 程序跑批开始 --';
    D_STARTTIME := SYSDATE;
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    DELETE FROM M_MRPT_SG012_TMP T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    I_STEP      := 2;
    I_STEP_DESC := '统计其他电子银行业务_快捷支付_资金变动交易';
    D_STARTTIME := SYSDATE; 
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT 
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
         SELECT V_P_DATE                                 AS DATA_DT
               ,'00000V1'                                AS ORG_ID
               ,'SG012_0041_A_1'                         AS INDEX_NO
               ,'其他电子银行业务_快捷支付_资金变动交易' AS INDEX_DESC
               ,COUNT(1)                                 AS INDEX_VL   --交易笔数
               ,SUM(TRAN_AMT)                            AS INDEX_VL2  --交易金额
           FROM (          SELECT A.TRAN_AMT
                             FROM IML.V_EVT_PPPS_PS_AGT_PAY_FLOW  A  --PPPS协议支付流水
                            WHERE A.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '00'
                 UNION ALL
                           SELECT A.TRAN_AMT
                             FROM IML.V_EVT_PPPS_PS_REFUND_FLOW   A  --PPPS退款流水
                            WHERE A.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '00'
                 UNION ALL
                           SELECT A.TRAN_AMT
                             FROM IML.V_EVT_PPPS_PS_PAY_FLOW      A  --PPPS付款流水
                            WHERE A.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '00'
                 UNION ALL
                           SELECT A.TRAN_AMT
                             FROM IML.V_EVT_UPS_AGT_PAY_FLOW      A  --银联协议支付流水
                            WHERE A.SYS_TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '0'
                 UNION ALL
                           SELECT A.TRAN_AMT
                             FROM IML.V_EVT_UPS_REFUND_FLOW        A  --银联退款流水
                            WHERE A.SYS_TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '0'
                 UNION ALL
                           SELECT A.TRAN_AMT
                             FROM IML.V_EVT_UPS_PAY_FLOW           A --银联付款流水
                            WHERE A.SYS_TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                              AND A.TRAN_STATUS_CD  = '0');
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    
    I_STEP      := 3;
    I_STEP_DESC := '统计其他电子银行业务_快捷支付_非资金变动交易';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
        SELECT
               V_P_DATE                                   AS DATA_DT
              ,'00000V1'                                  AS ORG_ID
              ,'SG012_0042_A_1'                           AS INDEX_NO
              ,'其他电子银行业务_快捷支付_非资金变动交易' AS INDEX_DESC
              ,SUM(CNT)                                   AS CNT        --交易笔数
              ,''                                         AS AMT        --交易金
          FROM (
                          SELECT COUNT(*) AS CNT
                            FROM ICL.V_CMM_CUST_SIGN_PROD_INFO  --客户签约产品信息
                           WHERE ETL_DT=D_P_DATE
                             AND SIGN_PROD_TYPE_CD='DW003'
                             AND SIGN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                             AND SUBSTR(SIGN_AGT_ID,INSTR(SIGN_AGT_ID,2,1),8) BETWEEN V_QUA_FDATE AND V_P_DATE
                UNION ALL
                          SELECT COUNT(*) AS CNT
                            FROM ICL.V_CMM_CUST_SIGN_PROD_INFO  --客户签约产品信息
                           WHERE ETL_DT=D_P_DATE
                             AND SIGN_PROD_TYPE_CD='BZ002'
                             AND SIGN_AGT_ID LIKE 'UP%'
                             AND SIGN_DT BETWEEN D_QUA_FDATE AND D_P_DATE);
    I_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE  := '0';
    D_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   
    I_STEP      := 4;
    I_STEP_DESC := '统计电话银行_电话银行坐席';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC 
               ,CNT
               ,AMT)
         SELECT V_P_DATE       AS DATA_DT
               ,'00000V1'      AS ORG_ID
               ,'SG012_0008_A' AS INDEX_NO
               ,'电话银行坐席' AS INDEX_DESC
               ,COUNT(1)       AS CNT  --交易笔数
               ,''             AS AMT  --交易金额
           FROM IOL.V_CCDB_EMP_BASE_INFO    A --员工基础信息表
      LEFT JOIN IOL.V_CCDB_SYS_ACCOUNT_INFO B --用户信息表
             ON B.EMP_CODE = A.CODE
            AND B.START_DT <= D_P_DATE
            AND B.END_DT > D_P_DATE
          WHERE B.OPERATOR_TYPE_CODE = '2' --客服用户类型
            AND A.STATUS = '1' 
            AND B.STATUS = '1' 
            AND A.ORG_CODE = '800959' --机构属于集中作业中心
            AND A.START_DT <= D_P_DATE
            AND A.END_DT > D_P_DATE;
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    
    I_STEP      := 5;
    I_STEP_DESC := '统计柜面交易笔数';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
         SELECT V_P_DATE       AS DATA_DT
               ,'00000V1'      AS ORG_ID
               ,'SG012_0080_A' AS INDEX_NO
               ,'柜面交易笔数' AS INDEX_DESC
               ,COUNT(1)       AS CNT --交易笔数
               ,''             AS AMT   --交易金额
           FROM IML.V_EVT_INTELLGE_BRAC_BUS_FLOW A
          WHERE TRAN_STATUS_CD = 'S'  --交易正常 
            AND APP_NUM != 'SS-STM' 
            AND CHN_DT BETWEEN D_QUA_FDATE AND D_P_DATE;
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
    I_STEP      := 6;
    I_STEP_DESC := '统计柜面交易金额';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
         SELECT V_P_DATE             AS DATA_DT
               ,'00000V1'            AS ORG_ID
               ,'SG012_0081_A'       AS INDEX_NO
               ,'柜面交易金额'       AS INDEX_DESC
               ,''                   AS CNT        --交易笔数
               ,SUM(ABS(A.TRAN_AMT)) AS AMT        --交易金额 
           FROM IML.V_EVT_INTELLGE_BRAC_BUS_FLOW A --智能网点业务流水
      LEFT JOIN IOL.V_NIBS_IB_UPM_MENU_INFO      B --交易菜单表
             ON A.CHN_TRAN_CODE = B.MENUNUM
            AND B.END_DT = DATE'2099-12-31'
          WHERE CHN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
            AND A.TRAN_AMT <> '9999999999999.99'
            AND A.APP_NUM != 'SS-STM' 
            AND B.TRANFLAG = '1'         -- UPDATE 20240108  XMY
            AND A.TRAN_STATUS_CD = 'S';  -- add by yang 过滤交易失败的交易
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    I_STEP      := 7;
    I_STEP_DESC := '其他电子银行_非资金变动交易笔数_微信小程序';
    D_STARTTIME := SYSDATE;
 
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
         SELECT V_P_DATE                       AS DATA_DT
               ,'00000V1'                      AS ORG_ID
               ,'SG012_0042_A_2'               AS INDEX_NO
               ,'微信小程序非资金变动交易笔数' AS INDEX_DESC
               ,COUNT(*)                       AS CNT        --交易笔数
               ,''                             AS AMT        --交易额 
           FROM IML.V_EVT_PRIV_ONL_BANK_TRAN_FLOW A --对私网上银行交易流水
          WHERE TRAN_CODE LIKE 'SRMPSX%'
            AND ETL_DT BETWEEN D_QUA_FDATE AND D_P_DATE;
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    I_STEP      := 8;
    I_STEP_DESC := '个人网上银行_资金变动交易笔数及金额';
    D_STARTTIME := SYSDATE;

    INSERT ALL
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0032_A','个人网上银行资金变动交易笔数',ITEM_NUM,'')   -- SG012_0032_A 个人网上银行资金变动交易笔数
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0060_A','个人网上银行资金变动交易金额','',ITEM_NUM1) -- SG012_0060_A 个人网上银行资金变动交易金额
           SELECT SUM(CON)  ITEM_NUM  --交易笔数 
                 ,SUM(SUMU) ITEM_NUM1 --统计金额
             FROM (              SELECT /*+FULL(T1)*/COUNT(1)                          AS CON
                                       ,NVL(SUM(T1.TRAN_AMT*NVL(T3.CNY_EXCH_RAT,1)),0) AS SUMU -- PTF_AMONUT 交易金额
                                   FROM IML.V_EVT_ONL_BANK_TRAN_FLOW  T1 --f TPSPRD.PUB_TRADE_FLOW@LINK_TS_IBS  IML.EVT_ONL_BANK_TRAN_FLOW 网上银行交易流水
                             INNER JOIN IML.V_REF_ONL_BANK_TRAN_CODE_H  T2 --BASPRD.BAS_IM_SERVICE_TRANS_REL@LINK_TS_IBS  RRP_MDL.M_MRPT_REF_ONL_BANK_TRAN_CODE_H
                                     ON T1.TRAN_TYPE_CODE = T2.TRAN_CODE -- T1.PTF_TRANSTYPE = T2.BST_TRANSID 交易类型码
                                    AND SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '1'  -- BST_TRANSDIAPLSY 4 位，1-是，0-否。第1位：是否有交易明细；2 ：是否金融交易；3 ：预留；4 ：预留
                                    AND T2.END_DT=DATE'2099-12-31'
                              LEFT JOIN ICL.V_CMM_EXCH_RAT_INFO  T3  --汇率表
                                     ON T1.CURR_CD = T3.CURR_CD       --基准币种
                                    AND T1.TRAN_DT = T3.ETL_DT
                                  WHERE T1.ONL_BANK_TRAN_STATUS_CD = '90'  -- T1.PTF_STATE = '90' 网上银行交易状态代码
                                    AND T1.TRAN_CHN_CD IN ('EBK', 'NPB')      -- T1.PTF_CHANNEL IN ('EBK', 'NPB')
                                    AND T1.TRAN_CODE !='LACKCODE' -- T1.PTF_TRANSCODE!='LACKCODE' 交易码
                                    AND T1.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                   UNION ALL
                                 SELECT /*+FULL(T1)*/COUNT(1)                          AS CON
                                       ,NVL(SUM(T1.TRAN_AMT*NVL(T3.CNY_EXCH_RAT,1)),0) AS SUMU -- PTF_AMONUT 交易金额
                                   FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW T1 --外服投资理财业务流水 IML.EVT_OS_INVEST_FINC_BUS_FLOW ,-- FLSPRD.PUB_TRADE_FLOW@LINK_TS_IBS           ,
                             INNER JOIN IML.V_REF_ONL_BANK_TRAN_CODE_H T2
                                     ON T1.TRAN_TYPE_CODE = T2.TRAN_CODE -- PTF_TRANSTYPE 交易类型码
                                    AND SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '1'
                                    AND T2.END_DT=DATE'2099-12-31'
                              LEFT JOIN ICL.V_CMM_EXCH_RAT_INFO  T3  --汇率表
                                     ON T1.CURR_CD = T3.CURR_CD       --基准币种
                                    AND T1.TRAN_DT = T3.ETL_DT
                                  WHERE T1.TRAN_STATUS_CD = '90'  -- PTF_STATE 交易状态代码
                                    AND T1.TRAN_CHN_CD IN ('EBK', 'NPB') -- PTF_CHANNEL 渠道系统代码
                                    AND T1.TRAN_CODE!='LACKCODE' -- PTF_TRANSCODE 交易码
                                    AND T1.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE);
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    I_STEP      := 9;
    I_STEP_DESC := '个人网上银行_非资金变动交易笔数';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT 
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC
               ,CNT
               ,AMT)
         SELECT V_P_DATE                         AS DATA_DT
               ,'00000V1'                        AS ORG_ID
               ,'SG012_0033_A'                   AS INDEX_NO
               ,'个人网上银行非资金变动交易笔数' AS INDEX_DESC
               ,SUM(CON)/3                       AS CNT   --交易笔数
               ,''                               AS AMT   --交易金额 
          FROM (          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_ONL_BANK_TRAN_FLOW                                                 T1, -- f TPSPRD.PUB_TRADE_FLOW 网上银行交易流水 IML.EVT_ONL_BANK_TRAN_FLOW
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT = DATE'2099-12-31')T2  -- f BASPRD.REF_ONL_BANK_TRAN_CODE_H@LINK_TS_IBS 网上银行交易码参数历史 RRP_MDL.M_MRPT_REF_ONL_BANK_TRAN_CODE_H
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+) -- 交易码
                             AND T1.TRAN_RETURN_CODE IN ('000000','0','000000000000') -- 交易返回码
                             AND (SUBSTR(T2.TRAN_FLG_COMB,2,1) = '0' OR TRIM(T1.TRAN_TYPE_CODE) IS NULL)  -- 交易类型码
                             AND T1.TRAN_CHN_CD IN ('EBK','NPB') -- 交易渠道码
                             AND T1.TRAN_CODE != 'LACKCODE' -- 交易码
                             AND T1.TRAN_DT >= D_QUA_FDATE
                             AND T1.TRAN_DT <= D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW                                              T1, --IML.EVT_OS_INVEST_FINC_BUS_FLOW  T1 -- FLSPRD.PUB_TRADE_FLOW@LINK_TS_IBS 外服投资理财业务流水
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT = DATE'2099-12-31') T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.TRAN_RETURN_CODE IN ('000000', '0', '000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM( T1.TRAN_TYPE_CODE ) IS NULL) -- BST_TRANSDIAPLSY 交易标志组合
                             AND T1.TRAN_CHN_CD IN ('EBK', 'NPB')
                             AND T1.TRAN_CODE != 'LACKCODE'
                             AND T1.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_OS_PRIV_SERV_BUS_FLOW                                                T1, -- PBSPRD.PUB_TRADE_FLOW@LINK_TS_IBS IML.EVT_OS_PRIV_SERV_BUS_FLOW 外服对私服务业务流水
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT = DATE'2099-12-31') T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.TRAN_RETURN_CODE IN ('000000','0','000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM(T1.TRAN_TYPE_CODE) IS NULL)
                             AND T1.CHN_ID IN ('301001') --渠道代码 个人网上银行
                             AND T1.TRAN_CODE != 'LACKCODE' --此字段找不到映射 模型表需要加字段
                             AND T1.TRAN_DT >= D_QUA_FDATE
                             AND T1.TRAN_DT <= D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_PONL_BK_AUTHEN_FLOW                                                 T1,-- f ATSPRD.PUB_TRADE_FLOW@LINK_TS_IBS 个人网银鉴权流水 IML.EVT_PONL_BK_AUTHEN_FLOW
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT=DATE'2099-12-31' ) T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.RETURN_CODE IN ('000000','0','000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM( T1.TRAN_TYPE_CODE) IS NULL)
                             AND T1.TRAN_CHN_CD IN ('EBK', 'NPB')
                             AND SUBSTR(T1.TRAN_TM,1,8) >= V_QUA_FDATE
                             AND SUBSTR(T1.TRAN_TM,1,8) <= V_P_DATE);
    I_SQLCOUNT   := SQL%ROWCOUNT;
    V_SQLMSG     := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE    := '0';
    D_ENDTIME    := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
    I_STEP      := 10;
    I_STEP_DESC := '个人手机银行_资金变动交易笔数及金额';
    D_STARTTIME := SYSDATE;
    INSERT ALL
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0047_A','个人手机银行资金变动交易笔数',ITEM_NUM,'')  -- SG012_0047_A 主要电子交易 个人手机银行_资金变动交易笔数
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0064_A','个人手机银行资金变动交易金额','',ITEM_NUM1) -- SG012_0064_A 主要电子交易 个人手机银行_资金变动交易金额
           SELECT SUM(CON)  AS ITEM_NUM  --交易笔数
                 ,SUM(SUMU) AS ITEM_NUM1 --统计金额
             FROM (          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                                   ,SUM(T1.TRAN_AMT)      AS SUMU
                               FROM IML.V_EVT_ONL_BANK_TRAN_FLOW   T1, -- TPSPRD.PUB_TRADE_FLOW@LINK_TS_IBS   网上银行交易流水
                                    IML.V_REF_ONL_BANK_TRAN_CODE_H T2 -- 网上银行交易码参数历史
                              WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE -- 交易类型码
                                AND T1.ONL_BANK_TRAN_STATUS_CD = '90' --- 网上银行交易状态代码 90 ：成功
                                AND SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '1'
                                AND T1.TRAN_CHN_CD = 'NMB' -- 交易渠道代码
                                AND T1.TRAN_AMT>0
                                AND T1.TRAN_DT >= D_QUA_FDATE
                                AND T1.TRAN_DT <= D_P_DATE
                                AND T2.END_DT=DATE'2099-12-31'
                   UNION ALL
                             SELECT /*+FULL(T1)*/COUNT(1) AS CON, SUM(T1.TRAN_AMT) AS SUMU
                               FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW T1, -- FLSPRD.PUB_TRADE_FLOW@LINK_TS_IBS   外服投资理财业务流水
                                    IML.V_REF_ONL_BANK_TRAN_CODE_H    T2
                              WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE
                                AND T1.TRAN_STATUS_CD = '90'
                                AND SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '1'
                                AND T1.TRAN_CHN_CD = 'NMB'
                                AND T1.TRAN_AMT>0
                                AND T1.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                                AND T2.END_DT=DATE'2099-12-31');
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   
    I_STEP      := 11;
    I_STEP_DESC := '个人手机银行_非资金变动交易笔数';
    D_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP(
                DATA_DT
               ,ORG_ID
               ,INDEX_NO
               ,INDEX_DESC 
               ,CNT
               ,AMT)
         SELECT V_P_DATE                         AS DATA_DT
               ,'00000V1'                        AS ORG_ID
               ,'SG012_0048_A'                   AS INDEX_NO
               ,'个人手机银行非资金变动交易笔数' AS INDEX_DESC
               ,SUM(CON)/3                       AS CNT --交易笔数
               ,''                               AS AMT --交易金额 
          FROM (          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_ONL_BANK_TRAN_FLOW                                                 T1, -- f TPSPRD.PUB_TRADE_FLOW 网上银行交易流水 IML.EVT_ONL_BANK_TRAN_FLOW
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT=DATE'2099-12-31') T2  -- f BASPRD.REF_ONL_BANK_TRAN_CODE_H@LINK_TS_IBS 网上银行交易码参数历史 RRP_MDL.M_MRPT_REF_ONL_BANK_TRAN_CODE_H
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+) -- 交易码
                             AND T1.TRAN_RETURN_CODE IN ('000000', '0', '000000000000') -- 交易返回码
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM(T1.TRAN_TYPE_CODE) IS NULL)  -- 交易类型码
                             AND T1.TRAN_CHN_CD IN ('NMB') -- 交易渠道码 
                             AND T1.TRAN_CODE!='LACKCODE' -- 交易码
                             AND T1.TRAN_DT >= D_QUA_FDATE
                             AND T1.TRAN_DT <= D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW                                            T1, --IML.EVT_OS_INVEST_FINC_BUS_FLOW  T1,  -- FLSPRD.PUB_TRADE_FLOW@LINK_TS_IBS 外服投资理财业务流水
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT=DATE'2099-12-31') T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.TRAN_RETURN_CODE IN ('000000','0','000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM(T1.TRAN_TYPE_CODE) IS NULL)-- BST_TRANSDIAPLSY 交易标志组合
                             AND T1.TRAN_CHN_CD IN ('NMB')
                             AND T1.TRAN_CODE != 'LACKCODE'
                             AND T1.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_OS_PRIV_SERV_BUS_FLOW                                                T1, -- PBSPRD.PUB_TRADE_FLOW@LINK_TS_IBS IML.EVT_OS_PRIV_SERV_BUS_FLOW 外服对私服务业务流水
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT = DATE'2099-12-31') T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.TRAN_RETURN_CODE IN ('000000','0','000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM(T1.TRAN_TYPE_CODE) IS NULL)
                             AND T1.CHN_ID IN ('302001') --渠道代码 个人手机银行
                             AND T1.TRAN_CODE != 'LACKCODE' --此字段找不到映射 模型表需要加字段
                             AND T1.TRAN_DT >= D_QUA_FDATE
                             AND T1.TRAN_DT <= D_P_DATE
                UNION ALL
                          SELECT /*+FULL(T1)*/COUNT(1) AS CON
                            FROM IML.V_EVT_PONL_BK_AUTHEN_FLOW                                                  T1,-- f ATSPRD.PUB_TRADE_FLOW@LINK_TS_IBS 个人网银鉴权流水 IML.EVT_PONL_BK_AUTHEN_FLOW
                                 (SELECT * FROM IML.V_REF_ONL_BANK_TRAN_CODE_H WHERE END_DT = DATE'2099-12-31') T2
                           WHERE T1.TRAN_TYPE_CODE = T2.TRAN_CODE(+)
                             AND T1.RETURN_CODE IN ('000000','0','000000000000')
                             AND (SUBSTR(T2.TRAN_FLG_COMB, 2, 1) = '0' OR TRIM( T1.TRAN_TYPE_CODE) IS NULL)
                             AND T1.TRAN_CHN_CD IN ('NMB')
                             AND SUBSTR(T1.TRAN_TM,1,8) >= V_QUA_FDATE
                             AND SUBSTR(T1.TRAN_TM,1,8) <= V_P_DATE);
    I_SQLCOUNT  := SQL%ROWCOUNT;
    V_SQLMSG    := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
    O_ERRCODE   := '0';
    D_ENDTIME   := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    I_STEP      := 12;
    I_STEP_DESC := '个人网上银行系统_并发用户数';
    D_STARTTIME := SYSDATE;
    INSERT ALL
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0056_A','个人网上银行系统_系统平均在线并发用户数',ITEM_NUM,'')  -- SG013_0056_A_个人网上银行系统_系统平均在线并发用户数
      INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0057_A','个人网上银行系统_系统最大在线并发用户数',ITEM_NUM1,'')   --SG013_0057_A_个人网上银行系统_系统最大在线并发用户数
           SELECT SUM(CNT)/(TO_DATE(V_P_DATE,'YYYYMMDD')-TO_DATE(V_QUA_FDATE,'YYYYMMDD')+1)/24/60 AS ITEM_NUM
                 ,MAX(CNT)                                                                        AS ITEM_NUM1
            FROM (  SELECT COUNT(DISTINCT PTF_ECIFNO) AS CNT
                      FROM (SELECT /*+FULL(A)*/
                                   WHOLE_UNIFY_CUST_ID AS PTF_ECIFNO
                                  ,A.FLOW_NUM
                                  ,SUBSTR(A.TRAN_TM, 1, 12)        AS TRAN_TM
                              FROM IML.V_EVT_ONL_BANK_TRAN_FLOW A  --网上银行交易流水
                             WHERE TRAN_DT >= D_QUA_FDATE
                               AND TRAN_DT <= D_P_DATE
                               AND A.ONL_BANK_TRAN_STATUS_CD = '90' --交易成功
                               AND A.TRAN_CHN_CD IN ('NPB')        --新版个人网银
                               AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                  UNION ALL
                            SELECT /*+FULL(A)*/
                                   WHOLE_UNIFY_CUST_ID      AS PTF_ECIFNO
                                  ,A.FLOW_NUM
                                  ,SUBSTR(A.TRAN_TM, 1, 12) AS TRAN_TM
                              FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW A  --外服投资理财业务流水
                             WHERE A.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                               AND A.TRAN_STATUS_CD = '90'
                               AND A.TRAN_CHN_CD IN ('NPB')
                               AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                  UNION ALL
                            SELECT /*+FULL(A)*/
                                   WHOLE_UNIFY_CUST_ID      AS PTF_ECIFNO
                                  ,A.FLOW_NUM
                                  ,SUBSTR(A.TRAN_TM, 1, 12) AS TRAN_TM
                              FROM IML.V_EVT_OS_PRIV_SERV_BUS_FLOW A  --外服对私服务业务流水
                             WHERE TRAN_DT >= D_QUA_FDATE
                               AND TRAN_DT <= D_P_DATE
                               AND A.TRAN_STATUS_CD = '90'
                               AND A.TRAN_CHN_CD IN ('NPB')
                               AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                  UNION ALL
                            SELECT /*+FULL(A)*/
                                   CUST_ID                AS PTF_ECIFNO
                                  ,A.FLOW_NUM
                                  ,SUBSTR(A.TRAN_TM,1,12) AS TRAN_TM
                              FROM IML.V_EVT_PONL_BK_AUTHEN_FLOW A   --个人网银鉴权流水
                             WHERE SUBSTR(TRAN_TM,1,8) >= V_QUA_FDATE
                               AND SUBSTR(TRAN_TM,1,8) <= V_P_DATE
                               AND A.TRAN_STATUS_CD = '90'
                               AND A.TRAN_CHN_CD IN ('NPB')
                               AND TRIM(A.CUST_ID) IS NOT NULL)
         GROUP BY SUBSTR(TRAN_TM, 1, 12));

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  
   I_STEP      := 13;
  I_STEP_DESC := '个人手机银行系统_并发用户数';
  D_STARTTIME := SYSDATE;
 
  INSERT ALL
  INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0044_A','个人手机银行系统_系统平均在线并发用户数',ITEM_NUM,'')   -- SG013_0044_A_个人手机银行系统_系统平均在线并发用户数
  INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0045_A','个人手机银行系统_系统最大在线并发用户数',ITEM_NUM1,'')   --SG013_0045_A_个人手机银行系统_系统最大在线并发用户数
   SELECT 
         SUM(CNT) /(TO_DATE(V_P_DATE, 'YYYYMMDD') - TO_DATE(V_QUA_FDATE, 'YYYYMMDD') + 1) / 24 / 60 AS ITEM_NUM,
          MAX(CNT) ITEM_NUM1
      FROM (
          SELECT COUNT(DISTINCT PTF_ECIFNO) CNT
          FROM (SELECT /*+FULL(A)*/
                 WHOLE_UNIFY_CUST_ID PTF_ECIFNO, -- 全行统一客户编号
                 A.FLOW_NUM,          -- 流水号
                 SUBSTR(A.TRAN_TM, 1, 12) TRAN_TM
                  FROM IML.V_EVT_ONL_BANK_TRAN_FLOW A  --网上银行交易流水
                 WHERE TRAN_DT >= D_QUA_FDATE
                   AND TRAN_DT <= D_P_DATE
                   AND A.ONL_BANK_TRAN_STATUS_CD = '90' -- 网上银行交易状态代码  90：交易成功
                   AND A.TRAN_CHN_CD = 'NMB' -- 交易渠道码 --NMB：新手机银行
                   AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                UNION ALL
                SELECT /*+FULL(A)*/
                 WHOLE_UNIFY_CUST_ID PTF_ECIFNO,
                 A.FLOW_NUM,
                 SUBSTR(A.TRAN_TM, 1, 12) TRAN_TM
                  FROM IML.V_EVT_OS_INVEST_FINC_BUS_FLOW A  --外服投资理财业务流水
                 WHERE A.TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                   AND A.TRAN_STATUS_CD = '90'
                   AND A.TRAN_CHN_CD = 'NMB'
                   AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                UNION ALL
                SELECT /*+FULL(A)*/
                 WHOLE_UNIFY_CUST_ID PTF_ECIFNO,
                 A.FLOW_NUM,
                 SUBSTR(A.TRAN_TM, 1, 12) TRAN_TM
                  FROM IML.V_EVT_OS_PRIV_SERV_BUS_FLOW A   --外服对私服务业务流水
                 WHERE TRAN_DT >= D_QUA_FDATE
                   AND TRAN_DT <= D_P_DATE
                   AND A.TRAN_STATUS_CD = '90'
                   AND A.TRAN_CHN_CD = 'NMB'
                   AND TRIM(A.WHOLE_UNIFY_CUST_ID) IS NOT NULL
                UNION ALL
                SELECT /*+FULL(A)*/
                 CUST_ID PTF_ECIFNO,
                 A.FLOW_NUM,
                 SUBSTR(A.TRAN_TM, 1, 12) TRAN_TM
                  FROM IML.V_EVT_PONL_BK_AUTHEN_FLOW A  --个人网银鉴权流水
                 WHERE SUBSTR(TRAN_TM,1,8) >= V_QUA_FDATE
                   AND SUBSTR(TRAN_TM,1,8) <= V_P_DATE
                   AND A.TRAN_STATUS_CD = '90'
                   AND A.TRAN_CHN_CD = 'NMB'
                   AND  TRIM(A.CUST_ID) IS NOT NULL
                   )
         GROUP BY SUBSTR(TRAN_TM,1,12)
         )
                   ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  
  I_STEP      := 14;
  I_STEP_DESC := 'STM_数量';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
        SELECT
           V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0083_A'  INDEX_NO,
           'STM_数量_台' INDEX_DESC,
            COUNT(*)   CNT , --交易笔数,
           ''  AMT   --交易金额 
          FROM IML.V_CHN_EQUIP_INFO_H A  --设备信息历史
         WHERE START_DT <= D_P_DATE
           AND END_DT > D_P_DATE
           AND EQUIP_TYPE_CD = '06' --自助STM
           --AND EQUIP_STATUS_CD != '3' --剔除新增未审核的
           and equip_use_status_cd != '3'
                   ;
  
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  I_STEP      := 15;
  I_STEP_DESC := 'STM_资金变动交易笔数及STM_非资金变动交易笔数';
  D_STARTTIME := SYSDATE;
   
    INSERT ALL
    WHEN AMT <> 0.00 THEN INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0086_A','STM_资金变动交易笔数',CNT,'')   -- SG012_0086_A_STM_资金变动交易笔数_万笔
    WHEN AMT  = 0.00 THEN INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG012_0087_A','STM_非资金变动交易笔数',CNT,'')   --SG012_0087_A_STM_非资金变动交易笔数_万笔
      SELECT
           COUNT(*)   CNT , --交易笔数,
           TRAN_AMT   AMT   --交易金额 
          FROM IML.V_EVT_INTELLGE_BRAC_BUS_FLOW   --智能网点业务流水表视图
         WHERE CHN_DT >= D_QUA_FDATE
           AND CHN_DT <= D_P_DATE
           AND TRAN_STATUS_CD = 'S' --交易成功
           AND APP_NUM = 'SS-STM'  --STM机
           GROUP BY TRAN_AMT
                   ;
                   
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 16;
  I_STEP_DESC := '直销银行_资金变动交易笔数及直销银行_交易金额';
  D_STARTTIME := SYSDATE;
   
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
        SELECT
           V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0089_A'  INDEX_NO,
           '直销银行_资金变动交易笔数' INDEX_DESC,
            COUNT(*)   CNT , --交易笔数,
            ''  AMT   --交易金额 
  FROM IOL.V_IFDS_V_PAYMENT_ALL P
 WHERE P.FIN_ACCOUNT_ID IN
       (SELECT T.FIN_ACCOUNT_ID
          FROM IOL.V_IFDS_BILL_FIN_ACC_ASSOC T --视图-E账户与产品账号关联表
          WHERE T.PRODUCT_ID = '0900100100201' --0900100100201-活期户
            AND T.END_DT=DATE'2099-12-31'
            AND ID_MARK <> 'D'
          )
   AND TO_CHAR(P.CREATED_STAMP, 'YYYYMMDD') >= V_QUA_FDATE
   AND TO_CHAR(P.CREATED_STAMP, 'YYYYMMDD') <= V_P_DATE
                   ;
                   
                   
    INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
        SELECT
           V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0099_A'  INDEX_NO,
           '直销银行_交易金额' INDEX_DESC,
            ''   CNT , --交易笔数,
           SUM(P.AMOUNT)   AMT   --交易金额 
  FROM IOL.V_IFDS_V_PAYMENT_ALL P
 WHERE P.FIN_ACCOUNT_ID IN
       (SELECT T.FIN_ACCOUNT_ID
          FROM IOL.V_IFDS_BILL_FIN_ACC_ASSOC T --视图-E账户与产品账号关联表
          WHERE T.PRODUCT_ID = '0900100100201' --0900100100201-活期户
            AND T.END_DT=DATE'2099-12-31'
            AND ID_MARK <> 'D'
          )
   AND TO_CHAR(P.CREATED_STAMP, 'YYYYMMDD') >= V_QUA_FDATE
   AND TO_CHAR(P.CREATED_STAMP, 'YYYYMMDD') <= V_P_DATE
                   ;
                   
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 17;
  I_STEP_DESC := '直销银行_非资金变动交易笔数';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0090_A'  INDEX_NO,
           '直销银行_非资金变动交易笔数' INDEX_DESC,
           sum(cou)  CNT , --交易笔数,
           ''  AMT   --交易金额 
           FROM (
      SELECT COUNT(*) AS COU 
          FROM IOL.V_IFDS_CARD_BIND_HISTORY Y1
         WHERE Y1.BILLING_ACCOUNT_ID IN
               (SELECT DISTINCT T.BILLING_ACCOUNT_ID
                  FROM IOL.V_IFDS_BILLING_ACCOUNT    T,
                       IOL.V_IFDS_BILL_FIN_ACC_ASSOC T1
                 WHERE T.ACCOUNT_TYPE IN ('EAFE', 'DZHT', 'BSVA')
                   AND T.EXTERNAL_ACCOUNT_ID = T1.BILLING_ACCOUNT_ID
                   AND T.END_DT=DATE'2099-12-31'
                   AND T.ID_MARK <> 'D'
                   AND T1.END_DT=DATE'2099-12-31'
                   AND T1.ID_MARK <> 'D'
                   AND T1.PRODUCT_ID = '0900100100201')
           AND TO_CHAR(Y1.OPERATE_TIME, 'YYYYMMDD') >= V_QUA_FDATE
           AND TO_CHAR(Y1.OPERATE_TIME, 'YYYYMMDD') <= V_P_DATE
           UNION ALL  
       SELECT COUNT(*) AS COU
          FROM  IOL.V_IFDS_ACCOUNT_PASSWORD_HISTORY Y2
         WHERE Y2.ACCOUNT_ID IN
               (SELECT DISTINCT T.BILLING_ACCOUNT_ID
                  FROM IOL.V_IFDS_BILLING_ACCOUNT    T,
                       IOL.V_IFDS_BILL_FIN_ACC_ASSOC T1
                 WHERE T.ACCOUNT_TYPE IN ('EAFE', 'DZHT', 'BSVA')
                   AND T.EXTERNAL_ACCOUNT_ID = T1.BILLING_ACCOUNT_ID
                   AND T.END_DT=DATE'2099-12-31'
                   AND T.ID_MARK <> 'D'
                   AND T1.END_DT=DATE'2099-12-31'
                   AND T1.ID_MARK <> 'D'
                   AND T1.PRODUCT_ID = '0900100100201')
           AND TO_CHAR(Y2.MODIFY_TIME, 'YYYYMMDD') >= V_QUA_FDATE
           AND TO_CHAR(Y2.MODIFY_TIME, 'YYYYMMDD') <= V_P_DATE
           )
        ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 18;
  I_STEP_DESC := 'STM_交易金额';
  D_STARTTIME := SYSDATE;
 
  INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
        SELECT
           V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0098_A'  INDEX_NO,
           'STM_交易金额' INDEX_DESC,
            ''   CNT , --交易笔数,
            SUM(ABS(A.TRAN_AMT))  AMT   --交易金额 
         FROM IML.V_EVT_INTELLGE_BRAC_BUS_FLOW A  --智能网点业务流水
         LEFT JOIN IOL.V_NIBS_IB_UPM_MENU_INFO B  --交易菜单表
         ON A.CHN_TRAN_CODE=B.MENUNUM
         AND B.END_DT=DATE'2099-12-31'
         WHERE  CHN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
         AND A.TRAN_AMT <>'9999999999999.99'
         AND B.TRANFLAG='1'
         AND A.APP_NUM = 'SS-STM'
                   ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  
  I_STEP      := 19;
  I_STEP_DESC := 'TQ2支付产品化平台客户数公司客户数、个人客户数';
  D_STARTTIME := SYSDATE;

    INSERT ALL
    WHEN CORP_ACCT_FLG ='1' THEN INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0131_A','支付产品化平台_公司客户数',CNT,'')   -- SG013_0131_A_支付产品化平台_公司客户数
    WHEN CORP_ACCT_FLG ='0' THEN INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0132_A','支付产品化平台_个人客户数',CNT,'')   --SG013_0132_A_支付产品化平台_个人客户数
         SELECT B.CORP_ACCT_FLG as CORP_ACCT_FLG,  --对公客户标志
                count(DISTINCT B.CUST_ID) AS CNT
                FROM (
          select distinct ACCOUNTS AS ACCOUNTS from (
                   (SELECT a.PAYER_ACCT_ID AS ACCOUNTS
                  FROM IML.V_EVT_PPPS_PS_AGT_PAY_FLOW  A  --PPPS协议支付流水
                 WHERE A.TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
                   AND A.TRAN_STATUS_CD  = '00'
              UNION ALL
                SELECT a.PAYER_ACCT_ID  as accounts
                  FROM IML.V_EVT_UPS_AGT_PAY_FLOW A   --银联协议支付流水
                 WHERE A.SYS_TRAN_DT   BETWEEN D_QUA_FDATE AND D_P_DATE
                   AND A.TRAN_STATUS_CD  = '0'
              UNION ALL
                SELECT a.RECVER_ACCT_ID as accounts
                  FROM IML.V_EVT_PPPS_PS_PAY_FLOW A  --PPPS付款流水
                 WHERE A.TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
                   AND A.TRAN_STATUS_CD  = '00'
               UNION ALL
                SELECT a.PAYER_ACCT_ID as  accounts
                  FROM IML.V_EVT_UPS_PAY_FLOW A   --银联付款流水
                 WHERE A.SYS_TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
                   AND A.TRAN_STATUS_CD  = '0'
                UNION ALL
                SELECT pay_acct_id as account
                  from IML.V_EVT_PPPS_CRDT_CLASS_TRAN_FLOW --PPPS贷记类交易流水
                 where TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                   and tran_proc_status_cd = 'SUCCESS'
                     )
                   )
               )A
              INNER JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO B
                 ON A.ACCOUNTS = B.CUST_ACCT_ID
                AND B.ETL_DT = D_P_DATE
             group by  B.CORP_ACCT_FLG
             
                   ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  
  I_STEP      := 20;
  I_STEP_DESC := 'TQ2支付产品化平台_并发用户数_系统平均在线并发用户数-系统最大在线并发用户数';
  D_STARTTIME := SYSDATE;

  INSERT ALL
  INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0126_A','支付产品化平台_系统平均在线并发用户数',AVG_NUM,'')   --SG013_0126_A_支付产品化平台_系统平均在线并发用户数
  INTO RRP_MDL.M_MRPT_SG012_TMP VALUES(V_P_DATE,'00000V1','SG013_0127_A','支付产品化平台_系统最大在线并发用户数',MAX_NUM,'')   --SG013_0127_A_支付产品化平台_系统最大在线并发用户数
            SELECT AVG(NUM) AS AVG_NUM, MAX(NUM) AS MAX_NUM FROM (
              SELECT TIME, COUNT(1) AS NUM FROM (
           SELECT  to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_PPPS_PS_AGT_PAY_FLOW  A  --PPPS协议支付流水
                 WHERE A.TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
                 UNION ALL
                SELECT --to_char(to_date(substr(a.CREATE_TM,0,14),'yyyyMMddHH24miss'),'yyyy-MM-dd HH24:mi') as time
                        to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_UPS_AGT_PAY_FLOW A   --银联协议支付流水
                 WHERE A.SYS_TRAN_DT   BETWEEN D_QUA_FDATE AND D_P_DATE
                   UNION ALL
                SELECT to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_PPPS_PS_PAY_FLOW A  --PPPS付款流水
                 WHERE A.TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
                    UNION ALL
                SELECT --to_char(to_date(substr(A.CREATE_TM,0,14),'yyyyMMddHH24miss'),'yyyy-MM-dd HH24:mi') as time
                       to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_UPS_PAY_FLOW A   --银联付款流水
                 WHERE A.SYS_TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
             UNION ALL
                SELECT to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_PPPS_PS_REFUND_FLOW A  --PPPS退款流水
                 WHERE A.TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
             UNION ALL
                SELECT --to_char(to_date(substr(A.CREATE_TM,0,14),'yyyyMMddHH24miss'),'yyyy-MM-dd HH24:mi') as time
                       to_char(A.CREATE_TM,'yyyy-MM-dd HH24:mi') as time
                  FROM IML.V_EVT_UPS_REFUND_FLOW A   --银联退款流水
                 WHERE A.SYS_TRAN_DT  BETWEEN D_QUA_FDATE AND D_P_DATE
               UNION ALL
                SELECT to_char(FIR_CREATE_DT,'yyyy-MM-dd HH24:mi') as time
                  from IML.V_EVT_PPPS_CRDT_CLASS_TRAN_FLOW --PPPS贷记类交易流水
                 where TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
                   )group by time
                   )
                   ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 21;
  I_STEP_DESC := '电子银行主要业务规模-视频银行——现有开户数';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0085_A'  INDEX_NO,
           '视频银行_现有账户数_户' INDEX_DESC,
           sum(RES)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
           FROM (
              SELECT 
            COUNT(DISTINCT T1.CUST_NO) AS RES
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       -- AND T1.CONNECT_TYPE = '1'
        AND TRIM(T1.CUST_NO) IS NOT NULL
           UNION ALL  
      SELECT COUNT(DISTINCT BILLID)
        FROM IOL.V_SVBS_HX_TRAN_INFO_RECORD
        WHERE (SYSTEM_SIGN = 'HEP' OR TRAN_CODE IN ('V05011', 'V05013', 'V05014', 'V05015', 'V05106'))
         AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  >= V_QUA_FDATE
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  <= V_P_DATE
           )
        ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

I_STEP      := 22;
  I_STEP_DESC := '电子银行主要业务规模-其中_使用视频银行的客户数_营运-财富-零售信贷_现有账户数';
  D_STARTTIME := SYSDATE;
   
  /* INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0102_A'  INDEX_NO,
           '其中_使用视频银行的客户数_营运_现有账户数' INDEX_DESC,
            COUNT(DISTINCT T1.CUST_NO)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        --AND T1.CONNECT_TYPE = '1'
        AND TRIM(T1.CUST_NO) IS NOT NULL
        AND NVL(T1.TRANS_CODE  , 'NULL')  NOT IN ('V05104','V05105','V05117','V05118')
        ;*/
        
        INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0103_A'  INDEX_NO,
           '其中_使用视频银行的客户数_财富_现有账户数' INDEX_DESC,
            COUNT(DISTINCT T1.CUST_NO)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        --AND T1.CONNECT_TYPE = '1'
        AND TRIM(T1.CUST_NO) IS NOT NULL
       -- AND NVL(T1.TRANS_CODE  , 'NULL')  IN ('V05104','V05105','V05117','V05118')
        ;
        
        INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0104_A'  INDEX_NO,
           '其中_调用视频银行的录制次_零售信贷_现有账户数' INDEX_DESC,
            COUNT(DISTINCT BILLID)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRAN_INFO_RECORD
         WHERE (SYSTEM_SIGN = 'HEP' OR TRAN_CODE IN ('V05011', 'V05013', 'V05014', 'V05015', 'V05106'))
         AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  >= V_QUA_FDATE
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  <= V_P_DATE
        ;
        
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-----------------
  I_STEP      := 23;
  I_STEP_DESC := '主要电子交易笔数-视频银行_非资金变动交易笔数_万笔';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0096_A'  INDEX_NO,
           '视频银行_非资金变动交易笔数_万笔' INDEX_DESC,
           sum(RES)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
           FROM (
              SELECT 
            COUNT(DISTINCT T1.ACCESS_JNL_NO) AS RES
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.CONNECT_TYPE = '1'
        AND TRIM(T1.CUST_NO) IS NOT NULL
           UNION ALL  
      SELECT COUNT(BILLID) AS RES
        FROM IOL.V_SVBS_HX_TRAN_INFO_RECORD
        WHERE (SYSTEM_SIGN = 'HEP' OR TRAN_CODE IN ('V05011', 'V05013', 'V05014', 'V05015', 'V05106'))
         AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  >= V_QUA_FDATE
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  <= V_P_DATE
           )
        ;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

I_STEP      := 24;
  I_STEP_DESC := '主要电子交易笔数-其中_使用视频银行的客户数_营运-财富-零售信贷_万笔';
  D_STARTTIME := SYSDATE;
   
   /*INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0105_A'  INDEX_NO,
           '其中_使用视频银行的客户数_营运_万笔' INDEX_DESC,
            COUNT(DISTINCT T1.ACCESS_JNL_NO)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        --AND T1.CONNECT_TYPE = '1'
        AND trim(T1.CUST_NO) IS NOT NULL
        AND NVL(T1.TRANS_CODE  , 'NULL')  NOT IN ('V05104','V05105','V05117','V05118')
        ;*/
        
        INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0106_A'  INDEX_NO,
           '其中_使用视频银行的客户数_财富_万笔' INDEX_DESC,
            COUNT(DISTINCT T1.ACCESS_JNL_NO)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRANS_JNL T1
        LEFT JOIN IOL.V_SVBS_TL9_RESOURCEBASIC T2
         ON T1.TRANS_CODE = T2.RESOURCEID
        AND T2.START_DT <= TO_DATE( V_P_DATE,'YYYYMMDD')
        AND T2.END_DT > TO_DATE( V_P_DATE,'YYYYMMDD')
        WHERE TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') >= V_QUA_FDATE
        AND TO_CHAR(T1.TRANS_TIME,'YYYYMMDD') <= V_P_DATE
        AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.CONNECT_TYPE = '1'
        AND trim(T1.CUST_NO) IS NOT NULL
       -- AND NVL(T1.TRANS_CODE  , 'NULL')  IN ('V05104','V05105','V05117','V05118')
        ;
        
        INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0107_A'  INDEX_NO,
           '其中_调用视频银行的录制次_零售信贷_万笔' INDEX_DESC,
            COUNT(BILLID)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
        FROM IOL.V_SVBS_HX_TRAN_INFO_RECORD
        WHERE (SYSTEM_SIGN = 'HEP' OR TRAN_CODE IN ('V05011', 'V05013', 'V05014', 'V05015', 'V05106'))
         AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  >= V_QUA_FDATE
         AND TO_CHAR(CREATE_DATE,'YYYYMMDD')  <= V_P_DATE
        ;
        
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

---------------------


 I_STEP      := 25;
  I_STEP_DESC := '微信银行_非资金变动交易笔数_万笔';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG012_0093_A'  INDEX_NO,
           '微信银行_非资金变动交易笔数_万笔' INDEX_DESC,
            COUNT(*)  CNT , --—现有开户数,
           ''  AMT   --交易金额 
      FROM IML.V_EVT_PRIV_ONL_BANK_TRAN_FLOW a   --视图对私网上银行交易流水表
     WHERE SYS_ID  IN ('MPP', 'WMP', 'IFD') 
       AND TRAN_DT BETWEEN D_QUA_FDATE AND D_P_DATE
        ;
        
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   I_STEP      := 26;
  I_STEP_DESC := '分布式服务治理平台_系统平均在线并发用户数-系统最大在线并发用户数';
  D_STARTTIME := SYSDATE;
   
   INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG013_0137_A'  INDEX_NO,
           '分布式服务治理平台_系统平均在线并发用户数' INDEX_DESC,
            AVG(CEIL(ESC_TRANSACTION_TOTAL_DAY/1440))  CNT , --—分布式服务治理平台_系统平均在线并发用户数
           ''  AMT   --交易金额 
       FROM IOL.V_ESCS_ESC_INDICATOR_DATA  --视图-ESC特色指标表
      WHERE TO_CHAR(TO_DATE(STATISTICS_DATE,'YYYY-MM-DD'),'YYYYMMDD') >=  V_QUA_FDATE
        AND TO_CHAR(TO_DATE(STATISTICS_DATE,'YYYY-MM-DD'),'YYYYMMDD') <=  V_P_DATE
        ;
        
     INSERT INTO RRP_MDL.M_MRPT_SG012_TMP
              (
               DATA_DT, 
               ORG_ID, 
               INDEX_NO,
               INDEX_DESC, 
               CNT,
               AMT
               )
         select 
            V_P_DATE DATA_DT,
           '00000V1' ORG_ID,
           'SG013_0138_A'  INDEX_NO,
           '分布式服务治理平台_系统最大在线并发用户数' INDEX_DESC,
            MAX(CEIL(MAX_TPS*60))  CNT , --—分布式服务治理平台_系统平均在线并发用户数
           ''  AMT   --交易金额 
       FROM IOL.V_ESCS_ESC_INDICATOR_DATA  --视图-ESC特色指标表
      WHERE TO_CHAR(TO_DATE(STATISTICS_DATE,'YYYY-MM-DD'),'YYYYMMDD') >=  V_QUA_FDATE
        AND TO_CHAR(TO_DATE(STATISTICS_DATE,'YYYY-MM-DD'),'YYYYMMDD') <=  V_P_DATE
        ;
        
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  
    END IF ; 


  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP      := 27; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    D_ENDTIME   := SYSDATE;
   /* I_STEP      := I_STEP + 1;
    I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

end ETL_M_MRPT_SG012_TMP;
/

