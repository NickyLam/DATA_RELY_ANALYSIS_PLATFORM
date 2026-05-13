CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_TRAN_FINANCE_FUND(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_TRAN_FINANCE_FUND
  *  功能描述：代理代销交易表(A3304代理代销业务)
  *  创建日期：20221126
  *  开发人员：许明尊
  *  来源表：
  *  目标表：  S_TRAN_FINANCE_FUND
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20221126  许明尊    首次创建
  *             2    20231009  HYF       修改互联网渠道，业务确认901001-内部渠道 也属于互联网
  *             3    20231011  HYF       修改机构号取交易机构,新增GDHX-自营理财
  *             4    20240802  HYF       修改代理代销其他业务的机构号取实际交易机构-交易支行编号 TRAN_SUBRCH_ID
  *             5    20241104  HYF       修改代理贵金属业务的机构号取支付卡开户机构编号 PAY_CARD_OPEN_ORG_ID
  *             6    20250214  HYF       新增1-债券承销数据
  *             7    20250226  YJY       新增养老目标基金标志
  *             8    20250806  HYF       调整债券承销交易金额取券面总额
  *             9    20250905  HYF       调整债券承销剔除中间业务
  *             10   20251011  HYF       调整债券承销逻辑，根据其交易对手为财政厅或者财政局判定
  *             11   20251020  HYF       调整贵金属逻辑，用新表替换
  *             12   20251103  HYF       调整贵金属范围，响应码过滤调整为状态码过滤
  *             13   20251229  HYF       调整资管信托交易码取值，增加新交易码1B0200
  *             14   20260319  HYF       新增table_name = 'tbproduct' 预防其他表里相同枚举值
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);   --分区名
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PROC_NAME VARCHAR2(1000) := 'ETL_S_TRAN_FINANCE_FUND'; -- 程序名称
  V_TAB_NAME  VARCHAR2(100):= 'S_TRAN_FINANCE_FUND'; --表名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- 分区表分区处理 --
  ETL_PARTITION_ADD(V_P_DATE, 'S_TRAN_FINANCE_FUND', '1', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '代理代销交易明细_数据处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (
          DATA_DT            --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG  --17养老目标基金标志 ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                   AS DATA_DATE            --01 数据日期
         ,A.TA_CFM_DT                AS TRAN_DATE            --02 交易日期
         ,NVL(A.BANK_ACCT_ID, '-')   AS ACCT_NUM             --03 客户基金/理财账号
         ,A.TA_CFM_FLOW_NUM          AS REF_NUM              --04 交易流水号
         ,CASE WHEN A.CONSMT_BUS_TYPE_CD = '07' 
               THEN A.TRAN_SUBRCH_ID
               ELSE A.TRAN_ORG_ID 
          END                        AS ORG_NUM              --05 机构号      --取交易归属机构编号
         ,A.CUST_ID                  AS CUST_ID              --06 客户号
         ,A.PROD_ID                  AS PROD_CODE            --07 产品代码
         ,CASE WHEN A.CONSMT_BUS_TYPE_CD IN ('01','05')
               THEN '2'
               WHEN A.CONSMT_BUS_TYPE_CD = '03'
               THEN '2'
               WHEN A.TRAN_CD IN ('100200','1B0200') AND A.CONSMT_BUS_TYPE_CD = '04' 
                AND (B.FIELD_VALUE = '1' OR D.MGER_NAME LIKE '%信托%')
               THEN '3'
               WHEN A.TRAN_CD IN ('100200','1B0200') AND A.CONSMT_BUS_TYPE_CD = '04' 
                AND B.FIELD_VALUE = '2'
               THEN '4'
               WHEN  A.CONSMT_BUS_TYPE_CD = '07' 
               THEN '7'                      -- 新增代销理财产品
          END                        AS BUSINESS_TYPE        --08 业务类型
         /* ,CASE WHEN A.TRAN_CHN_CD IN ('0','6') THEN '1'
                 WHEN A.TRAN_CHN_CD IN ('1','3','5','7','9','M' ) THEN '2' END AS SELLING_CHANNEL  --09 销售渠道 1--非互联网 2--互联网*/
          ,CASE WHEN A.TRAN_CHN_CD IN ('0','100001','6') THEN '1'
                WHEN A.TRAN_CHN_CD IN ('1','1006','301001','3','100003','5'
                                      ,'7','302001','9','901001','M','201006' ) THEN '2'
           END                       AS SELLING_CHANNEL      --09 销售渠道 1--非互联网 2--互联网 MDF BY XMZ 20230307根据源系统给的标准化码值映射关系修改
         ,A.CFM_AMT                  AS AMT                  --10 交易金额
         ,'代理代销交易明细'         AS DEPARTMENTD          --11 归属部门
         ,'ICL'                      AS DATE_SOURCESD        --12 数据来源
         ,REPLACE(A.CURR_CD,'@156','CNY') AS CURR_CD         --13 币种
         ,A.BUS_CD                   AS BUS_CD               --14 业务代码
         ,A.TRAN_STATUS_CD           AS TRAN_STATUS_CD       --15 交易状态代码
         ,A.TA_CD                    AS TA_CD                --16 TA代码
         ,CASE WHEN D.PROVI_FOR_AGED_TARGET_FUND_FLG = '1'
               THEN 'Y'
               ELSE 'N'
          END                        AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志 ADD BY YJY 20250226
     FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL   A  --代理代销交易明细
     LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE   B
       ON A.PROD_ID = B.PRD_CODE      
      AND TRIM(LOWER(B.FIELD_CODE)) = 'hx_prdtype'
      AND TRIM(LOWER(B.TABLE_NAME)) = 'tbproduct' --ADD BY 20260319
      AND B.START_DT <= GREATEST(TO_DATE(I_P_DATE,'YYYYMMDD'),TO_DATE('20220114','YYYYMMDD'))
      AND B.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO  D
       ON A.PROD_ID = D.PROD_ID
      AND D.CONSMT_BUS_TYPE_CD = '04'
      AND D.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
    WHERE A.ETL_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
        ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '代理代销交易明细-保险';
   V_STARTTIME := SYSDATE;
   INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (     DATA_DT               --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                  AS DATA_DATE            --01 数据日期
         ,A.POLICY_DT               AS TRAN_DATE            --02 保单日期
         ,NVL(A.BANK_ACCT_ID, '-')  AS ACCT_NUM             --03 客户基金/理财账号
         ,A.INSURE_PL_NUM           AS REF_NUM              --04 交易流水号
         ,A.TRAN_ORG_ID             AS ORG_NUM              --05 机构号      --取交易归属机构编号
         ,A.CUST_ID                 AS CUST_ID              --06 客户号
         ,A.PROD_ID                 AS PROD_CODE            --07 产品代码
         ,'5'                       AS BUSINESS_TYPE        --08 业务类型
         /* ,CASE WHEN A.TRAN_CHN_CD IN ('0','6') THEN '1'
                 WHEN A.TRAN_CHN_CD IN ('1','3','5','7','9','M' ) THEN '2' END AS SELLING_CHANNEL  --09 销售渠道 1--非互联网 2--互联网*/
          ,CASE WHEN A.TRAN_CHN_CD IN ('0','100001','6') THEN '1'
                WHEN A.TRAN_CHN_CD IN ('1','1006','301001','3','100003','5','7'
                                      ,'302001','9','M','201006' ) THEN '2'
           END                      AS SELLING_CHANNEL      --09 销售渠道 1--非互联网 2--互联网 MDF BY XMZ 20230307根据源系统给的标准化码值映射关系修改
         ,A.TRAN_AMT                AS AMT                  --10 交易金额
         ,'代理代销交易明细-保险'   AS DEPARTMENTD          --11 归属部门
         ,'ICL'                     AS DATE_SOURCESD        --12 数据来源
         ,REPLACE(A.CURR_CD,'@156','CNY')  AS CURR_CD       --13 币种
         ,NULL                      AS BUS_CD               --14 业务代码
         ,C.TRAN_STATUS_CD          AS TRAN_STATUS_CD       --15 交易状态代码  保单状态 CD2173
         ,A.TA_CD                   AS TA_CD                --16 TA代码
         ,CASE WHEN B.PROVI_FOR_AGED_TARGET_FUND_FLG = '1'
               THEN 'Y'
               ELSE 'N'
          END                       AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志   ADD BY YJY 20250226
     FROM RRP_MDL.O_IML_EVT_INSURE_TRAN_FLOW   A --保险交易流水
     LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO  B  --代理代销产品信息
       ON A.PROD_ID = B.PROD_ID
      AND B.CONSMT_BUS_TYPE_CD = '02'
      AND B.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_IML_AGT_INSURE_PL C  --保险单
       ON A.INSURE_PL_NUM = C.INSURE_PL_ID
      AND C.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND C.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')           
    WHERE ( (A.TRAN_STATUS_CD = 'S' AND C.TRAN_STATUS_CD = '0')
           OR (A.TRAN_STATUS_CD = '3' AND C.TRAN_STATUS_CD = '1')
          ) --（交易状态为 S 成功,保单状态 0 正常） 或者 （交易状态 3  已退保  保单状态  1  非犹豫期退保 ）
      AND A.TRAN_AMT > 0
      AND A.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND A.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
      ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

/* V_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '代理代销交易明细-贵金属';
   V_STARTTIME := SYSDATE;
   INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (
          DATA_DT            --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                      AS DATA_DATE             --01 数据日期
         ,T1.TRAN_DT                    AS TRAN_DATE             --02 交易日期
         ,NVL(T1.BANK_CUST_MGR_ID, '-') AS ACCT_NUM              --03 客户基金/理财账号
         ,T1.TRAN_FLOW_NUM              AS REF_NUM               --04 交易流水号
         --,T1.CUST_OPEN_ACCT_ORG_ID AS ORG_NUM                  --05 机构号      
         ,T1.PAY_CARD_OPEN_ORG_ID       AS ORG_NUM               --05 机构号  
         ,T1.CUST_ID                    AS CUST_ID               --06 客户号
         ,T2.STD_PROD_ID                AS PROD_CODE             --07 产品代码
         ,'8'                           AS BUSINESS_TYPE         --08 业务类型
         ,'2'                           AS SELLING_CHANNEL       --09 销售渠道
         ,T1.INDENT_TOT_AMT             AS AMT                   --10 交易金额
         ,'代理代销交易明细-贵金属'     AS DEPARTMENTD           --11 归属部门
         ,'IML'                         AS DATE_SOURCESD         --12 数据来源
         ,'CNY'                         AS CURR_CD               --13 币种
         ,NULL                          AS BUS_CD                --14 业务代码
         ,T1.TRAN_STATUS_CD             AS TRAN_STATUS_CD        --15 交易状态代码
         ,''                            AS TA_CD                 --16 TA代码
         ,NULL                          AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
     FROM RRP_MDL.O_IML_EVT_WEB_MALL_MERCHD_SUB_INFO_H T2 --网上商城商品子订单信息历史
     LEFT JOIN RRP_MDL.O_IML_EVT_WEB_MALL_INDENT_INFO_H T1 --网上商城订单信息历史
       ON T1.TRAN_FLOW_NUM = T2.TRAN_FLOW_NUM
      AND T1.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T1.END_DT >  TO_DATE(I_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_IML_PRD_NOBLE_MET_PROD_INFO T3
       ON T2.MERCHD_ID = T3.MERCHD_ID
      AND T3.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T3.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
    WHERE T2.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T2.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T1.MERCHD_TYPE_CD = '003'  --商品类型为 003 表示贵金属
      AND T1.TRAN_CODE = '2301' --2301 表示贵金属购买
      AND T1.SURP_AVAL_AMT != 0 --过滤剔除退单，退单余额为0
      AND T1.RESP_CODE = 'MRMNAPX00000' --交易成功
      AND TRUNC(T1.TRAN_DT,'Y') = TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'Y')  --年初到报告期累计交易
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

   V_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '代理代销交易明细-贵金属';
   V_STARTTIME := SYSDATE;
   INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (
          DATA_DT            --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                      AS DATA_DATE             --01 数据日期
         ,T1.TRAN_DT                    AS TRAN_DATE             --02 交易日期
         ,T1.TRAN_FLOW_NUM              AS ACCT_NUM              --03 客户基金/理财账号
         ,T1.INDENT_ID                  AS REF_NUM               --04 交易流水号
         --,T1.CUST_OPEN_ACCT_ORG_ID AS ORG_NUM                  --05 机构号      
         ,T1.PAY_CARD_OPEN_ACCT_ORG_ID  AS ORG_NUM               --05 机构号  
         ,T1.CUST_ID                    AS CUST_ID               --06 客户号
         ,T1.MERCHD_TYPE_CD             AS PROD_CODE             --07 产品代码
         ,'8'                           AS BUSINESS_TYPE         --08 业务类型
         ,'2'                           AS SELLING_CHANNEL       --09 销售渠道
         ,T1.INDENT_TOT_AMT             AS AMT                   --10 交易金额
         ,'代理代销交易明细-贵金属'     AS DEPARTMENTD           --11 归属部门
         ,'IML'                         AS DATE_SOURCESD         --12 数据来源
         ,'CNY'                         AS CURR_CD               --13 币种
         ,NULL                          AS BUS_CD                --14 业务代码
         ,T1.TRAN_STATUS_CD             AS TRAN_STATUS_CD        --15 交易状态代码
         ,''                            AS TA_CD                 --16 TA代码
         ,NULL                          AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
     FROM RRP_MDL.O_IML_EVT_POINT_MALL_PAY_FLOW T1 --积分商城订单流水
    WHERE TRIM(T1.MERCHD_TYPE_CD) = '003'  --商品类型为 003 表示贵金属
      AND TRIM(T1.TRAN_DESCB) = '消费' --消费
      AND T1.SURP_AVAL_AMT != 0 --过滤剔除退单，退单余额为0
      --AND T1.RESP_CODE = 'MRMNAPX00000' --交易成功
      AND T1.TRAN_STATUS_CD = '02' --交易成功
      AND TRUNC(T1.TRAN_DT,'Y') = TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'Y')  --年初到报告期累计交易
      AND T1.START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T1.END_DT > TO_DATE(I_P_DATE,'YYYYMMDD')
      AND T1.ID_MARK <> 'D'
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   
  V_STEP := 6; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '代理代销交易明细_自营理财';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (
          DATA_DT            --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                   AS DATA_DATE            --01 数据日期
         ,A.CFM_DT                   AS TRAN_DATE            --02 交易日期
         ,NVL(A.BANK_ACCT_ID, '-')   AS ACCT_NUM             --03 客户基金/理财账号
         ,A.TA_CFM_FLOW_NUM          AS REF_NUM              --04 交易流水号
         ,A.TRAN_ORG_ID              AS ORG_NUM              --05 机构号      --取交易归属机构编号
         ,A.PARTY_ID                 AS CUST_ID              --06 客户号
         ,A.FINC_PROD_ID             AS PROD_CODE            --07 产品代码
         ,CASE WHEN A.BUS_CD IN ('130','122')  
               AND A.TA_CD = 'GDHX'
               AND A.TRAN_STATUS_CD = '8' 
              THEN '9'
          END                        AS BUSINESS_TYPE        --08 业务类型
         ,CASE WHEN A.TRAN_CHN_CD IN ('0','100001','6') THEN '1'
               WHEN A.TRAN_CHN_CD IN ('1','1006','301001','3','100003','5','7'
                                     ,'302001','9','901001','M','201006' ) THEN '2'
           END                       AS SELLING_CHANNEL      --09 销售渠道 1--非互联网 2--互联网 MDF BY XMZ 20230307根据源系统给的标准化码值映射关系修改
         ,A.CFM_AMT                  AS AMT                  --10 交易金额
         ,'代理代销交易明细-自营理财'AS DEPARTMENTD          --11 归属部门
         ,'IML'                      AS DATE_SOURCESD        --12 数据来源
         ,REPLACE(A.CURR_CD,'@156','CNY')   AS CURR_CD       --13 币种
         ,A.BUS_CD                   AS BUS_CD               --14 业务代码
         ,A.TRAN_STATUS_CD           AS TRAN_STATUS_CD       --15 交易状态代码
         ,A.TA_CD                    AS TA_CD                --16 TA代码
         ,NULL                       AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
     FROM RRP_MDL.O_IML_EVT_FINC_TRAN_CFM A  --理财交易确认事件
    WHERE A.TRAN_STATUS_CD = '8'
      AND A.CFM_AMT <> 0
      AND A.BUS_CD IN ('130','122')
      AND A.TA_CD = 'GDHX'
      AND TRUNC(A.CFM_DT,'Y') = TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'Y')  --年初到报告期累计交易
      AND A.ETL_DT <= TO_DATE(I_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '代理代销交易明细_债券承销';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_TRAN_FINANCE_FUND NOLOGGING
    (
          DATA_DT              --01 数据日期
         ,TRAN_DATE            --02 交易日期
         ,ACCT_NUM             --03 客户基金/理财账号
         ,REF_NUM              --04 交易流水号
         ,ORG_NUM              --05 机构号
         ,CUST_ID              --06 客户号
         ,PROD_CODE            --07 产品代码
         ,BUSINESS_TYPE        --08 业务类型
         ,SELLING_CHANNEL      --09 销售渠道
         ,AMT                  --10 交易金额
         ,DEPARTMENTD          --11 归属部门
         ,DATE_SOURCESD        --12 数据来源
         ,CURR_CD              --13 币种
         ,BUS_CD               --14 业务代码
         ,TRAN_STATUS_CD       --15 交易状态代码
         ,TA_CD                --16 TA代码
         ,PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
    )
    SELECT
          I_P_DATE                            AS DATA_DATE            --01 数据日期
         ,TO_DATE(A.SETTLEDATE,'YYYYMMDD')    AS TRAN_DATE            --02 交易日期
         ,NVL(A.REF_NUMBER, '-')              AS ACCT_NUM             --03 客户基金/理财账号
         ,A.REF_NUMBER                        AS REF_NUM              --04 交易流水号
         ,'896001'                            AS ORG_NUM              --05 机构号      --取交易归属机构编号
         ,A.CPTYS_ID                          AS CUST_ID              --06 客户号
         ,A.BONDSCODE                         AS PROD_CODE            --07 产品代码
         ,'1'                                 AS BUSINESS_TYPE        --08 业务类型
         ,'2'                                 AS SELLING_CHANNEL      --09 销售渠道 1--非互联网 2--互联网 MDF BY XMZ 20230307根据源系统给的标准化码值映射关系修改
         --,A.SETTLEAMOUNT                      AS AMT                  --10 交易金额
         ,A.NOMINAL                           AS AMT                  --10 交易金额
         ,'代理代销交易明细-债券承销'         AS DEPARTMENTD          --11 归属部门
         ,'IOL'                               AS DATE_SOURCESD        --12 数据来源
         ,A.CURRENCY                          AS CURR_CD              --13 币种
         ,A.PORTFOLIO_ID                      AS BUS_CD               --14 业务代码
         ,''                                  AS TRAN_STATUS_CD       --15 交易状态代码
         ,''                                  AS TA_CD                --16 TA代码
         ,NULL                                AS PROVI_FOR_AGED_TARGET_FUND_FLG   --17养老目标基金标志  ADD BY YJY 20250226
     FROM RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS  A  --现券交易
    WHERE ( A.SOURCE = 'I' OR (A.SOURCE = 'C' AND A.BONDSTYPE = '地方政府债' AND A.CPTYS_SHORTNAME LIKE '%财政%'))
      AND A.SETTLEDATE >= TO_CHAR(TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
      AND A.SETTLEDATE <= I_P_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
             
   -- 增加数据重复校验 --
  WITH TMP1 AS (
  SELECT DATA_DT,REF_NUM,CUST_ID,TA_CD,COUNT(1)
    FROM RRP_MDL.S_TRAN_FINANCE_FUND T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,REF_NUM,CUST_ID,TA_CD
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
      INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_TRAN_FINANCE_FUND;
/

