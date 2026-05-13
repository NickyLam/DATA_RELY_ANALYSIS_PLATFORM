CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_EAST_AGT_CPTL_DTL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_EAST_AGT_CPTL_DTL
  *  功能描述：代理代销交易信息表
  初始化一月数据
  *  创建日期：20230224
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_EAST_AGT_CPTL_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20220611  梅炜    首次创建
  *             2    20221019  hulj    简化关联表,调整逻辑
  *             3    20221122  hulj    增加数据重复校验
  *             4    20221128  hulj    新增字段新增保单号、保单日期、保单状态字段
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_EAST_AGT_CPTL_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_DATE      DATE;            --数据日期
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_EAST_AGT_CPTL_DTL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_DATE := TO_DATE(V_P_DATE,'YYYYMMDD') ;

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
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入代理代销交易信息表-代理代销信托资管保险基金';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_AGT_CPTL_DTL
  (
    DATA_DT                             --数据日期
   ,LGL_REP_ID                          --法人编号
   ,ORG_ID                              --机构编号
   ,CUST_ID                             --客户统一编号
   ,CUST_NM                             --客户名称
   ,CUST_ACC                            --客户账号
   ,OPEN_BANK_NM                        --开户行名称
   ,TRA_ID                              --交易编号
   ,AGCY_CONSI_TRA_TYP                  --代理代销交易类型
   ,CONSI_PROD_NM                       --代销产品名称
   ,TRA_DIR                             --交易方向
   ,TRA_DT                              --交易日期
   ,CUR                                 --币种
   ,TRA_AMT                             --交易金额
   ,ISU_ORG_NM                          --发行机构名称
   ,ISU_ORG_RTG                         --发行机构评级
   ,ISU_ORG_RTG_ORG_NM                  --发行机构评级机构
   ,ISU_ORG_LIQ_ACC                     --发行机构清算账号
   ,ISU_ORG_LIQ_BANK_NM                 --发行机构清算行名
   ,FIN_PSN_NM                          --融资人名称
   ,FIN_PSN_BLNG_IDY                    --融资人所属行业
   ,COMM_CUR                            --手续费币种
   ,COMM_AMT                            --手续费金额
   ,CASH_TRF_FLG                        --现转标志
   ,HDLR_NO                             --经办人工号
   ,DEPT_LINE                           --部门条线
   ,DATA_SRC                            --数据来源
   ,bus_cd                              --业务代码
   --modify by cyk
   --,PRD_ATTR                            --产品属性
   ,PROD_ATTR_CD                        --产品属性代码

   ,MGR_NM                              --管理人名称
   ,CURR_AMT                            --账户余额
   ,CONSMT_BUS_TYPE_CD                  --代销业务类别
   ,TA_CD                               --TA代码
   ,TRAN_STATUS_CD                      --交易状态代码
   ,TRAN_CD                             --交易代码
   ,HX_TYPEDETAIL                       --代销细分类型
   ,PROD_ID                             --产品编号
   ,FIELD_VALUE                         --参数值
   ,MGER_NAME                           --管理人名称
   ,RISK_LEVEL_CD                       --风险等级代码
   ,END_DT                              --到期日期
   ,INSURE_PL_NUM                       --保险单号
   ,POLICY_DT                           --保单日期
   ,TRAN_STATUS_INSUR_CD                --保单状态
   ,AGENCY_FEE                          --代理费
   ,MON_FLG                             --月口径标识
  )
  WITH CLERK_TMP AS (
      SELECT /*+MATERIALIZE*/T.TELLER_ID,T.CLERK_ID,T.EMPLY_TYPE_CD,T.EMPYT_DT,T.JOBS_CD
        FROM (
        SELECT TELLER_ID,CLERK_ID,EMPLY_TYPE_CD,EMPYT_DT,JOBS_CD,
               ROW_NUMBER() OVER(PARTITION BY TELLER_ID ORDER BY EMPYT_DT DESC) AS NUM
          FROM RRP_MDL.O_ICL_CMM_CLERK_INFO --行员信息表
         WHERE TRIM(CLERK_ID) IS NOT NULL
           AND TELLER_FLG = '1'
           AND EMPYT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T
       WHERE T.NUM = 1),
    --简化关联表
    NFSS_TCS_TBPRDPARAMVALUE AS (
      SELECT PRD_CODE,T.FIELD_CODE,TRIM(T.FIELD_VALUE) FIELD_VALUE
        FROM RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE T
       WHERE T.FIELD_CODE IN ('pub_org_name','pub_org_level','pub_org_level_org','financier_name',
                              'hx_finalindustry','hx_prdtype')
         AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   TCS_TBPRDPARAMVALUE AS (
      SELECT /*+MATERIALIZE*/ * FROM (SELECT PRD_CODE,FIELD_CODE,FIELD_VALUE FROM NFSS_TCS_TBPRDPARAMVALUE)
       PIVOT(MAX(FIELD_VALUE) FOR FIELD_CODE IN
         ('pub_org_name' AS PUB_ORG_NAME,'pub_org_level' AS PUB_ORG_LEVEL,'pub_org_level_org' AS PUB_ORG_LEVEL_ORG,
         'financier_name' AS FINANCIER_NAME,'hx_finalindustry' AS HX_FINALINDUSTRY,'hx_prdtype' AS HX_PRDTYPE))),
    PTY_CPES_MEM AS (
         SELECT  /*+MATERIALIZE*/TRIM(TTA.MEM_ORG_CD) MEM_ORG_CD,--会员机构代码
                TRIM(TTA.MEM_ORG_ID) MEM_ORG_ID,--会员机构编号
                TRIM(TTA.ORG_CN_FNAME) ORG_CN_FNAME,--机构中文全称
                TRIM(TTA.ORG_CN_ABBR) ORG_CN_ABBR,--机构中文简称
                TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) SYS_PRTCPTR_BIGAMT_BANK_NO,--系统参与者大额行号
                CASE WHEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),'0') <> '0' THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME)
                     ELSE TRIM(TTA.ORG_CN_FNAME)
                 END SYS_PRTCPTR_BIGAMT_BANK_NAME,--系统参与者大额行名
                ROW_NUMBER() OVER(PARTITION BY CASE WHEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
                                                    THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO)
                                                    ELSE TRIM(TTA.ORG_CN_ABBR) END
                   ORDER BY TRIM(SYS_PRTCPTR_BIGAMT_BANK_NAME) NULLS LAST) RN
           FROM RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
          WHERE TTA.ID_MARK <> 'D')
  SELECT DISTINCT
    TO_CHAR(A.TA_CFM_DT, 'YYYYMMDD') AS DATA_DT,                                                       --数据日期
   -- V_P_DATE,                                                                                            --数据日期
    A.LP_ID AS LGL_REP_ID,                                                                             --法人编号
   NVL(B.ORG_ID1,'800') /*NVL(NVL(A.TRAN_ORG_ID,A.TRAN_BELONG_ORG_ID),'800')*/  AS ORG_ID,             --机构编号                                                        --机构编号
    A.CUST_ID,                                                                                         --客户统一编号
    NVL(D.CUST_NAME,E.CUST_NAME) AS CUST_NM,                                                           --客户名称
    A.BANK_ACCT_ID AS CUST_ACC,                                                                        --客户账号
    M.ORG_NAME AS OPEN_BANK_NM,                                                                        --开户行名称
    A.TA_CD||A.TA_CFM_FLOW_NUM AS TRA_ID,                                                              --交易编号
    CASE WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND (Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')
           THEN '02' --代理代销信托计划
         WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND Q.FIELD_VALUE = '2'
           THEN '03' --代理资产管理计划
       /*  WHEN A.CONSMT_BUS_TYPE_CD = '02'
           THEN '04' --代理代销保险产品
    */
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05')
           THEN '05' --代理代销基金
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07'
           THEN '07' END AS AGCY_CONSI_TRA_TYP, --代销他行理财产品                                       --代理代销交易类型
    A.PROD_NAME AS CONSI_PROD_NM,                                                                       --代销产品名称
    CASE WHEN A.TRAN_CD IN ('100200','100204','200209','200208') THEN '01' ELSE '02' END AS TRA_DIR ,   --交易方向
    TO_CHAR(A.TA_CFM_DT, 'YYYYMMDD') AS TRA_DT,                                                         --交易日期
    A.CURR_CD AS CUR,                                                                                   --币种
    A.CFM_AMT AS TRA_AMT,                                                                               --交易金额
    --F.FIELD_VALUE AS ISU_ORG_NM,                                                                      --发行机构名称
    CASE WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y4','GDHX' ) AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '华夏理财有限公司'   --ADD BY LIP 20220704 根据上游提供的口径：代销理财的写死为：华夏理财有限公司
              --ELSE NVL(P.PUBLISHER_NAME,F.FIELD_VALUE)
              --ELSE NVL(TRIM(P.PUBLISHER_NAME),Q.PUB_ORG_NAME)
              --ELSE TRIM(F.PUB_ORG_NAME) --MOD BY hulj 20221019
              ELSE COALESCE(TRIM(F.PUB_ORG_NAME),TRIM(C.ISSUER_NAME),TRIM(IFM1.CD_DESCB)) --modify by tangan at 20221107
     END                                                        AS ISU_ORG_NM,                          --发行机构名称
    F.PUB_ORG_LEVEL AS ISU_ORG_RTG,                                                                     --发行机构评级--MOD BY hulj 20221019
    CASE --WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y4','GDHX' ) AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              --WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y4','GDHX','Y03','Y04','999') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              WHEN (A.TRAN_STATUS_CD IN ('8') /*AND A.TA_CD IN ('Y4','GDHX','Y03','Y04','999','66','NY','Y12','Y15')*/
                   AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '无'   --ADD BY LAIHAIQIANG 20220708 根据上游提供的口径：代销理财的写死为：无
              --ELSE H.FIELD_VALUE
              ELSE F.PUB_ORG_LEVEL_ORG
          END  AS ISU_ORG_RTG_ORG_NM,                                                                --发行机构评级机构
    /*NVL(N.BANK_ACC_UP,Q1.MAKE_ACCT_BANK_ACCT_NUM) N.prod_acct_num AS ISU_ORG_LIQ_ACC,               --发行机构清算账号*/
    CASE WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y4','GDHX' ) AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '10237000000233670'   --ADD BY LAIHAIQIANG 20220704 根据上游提供的口径：代销理财的写死为：10237000000233670
              --WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y03','Y04','999') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              WHEN (A.TRAN_STATUS_CD IN ('8') /*AND A.TA_CD IN ('Y03','Y04','999','66','NY','Y12','Y15')*/
                   AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN IFM2.MAKE_ACCT_BANK_ACCT_ID --ADD BY LIP 20220914
              ELSE NVL(N.BANK_ACC_UP,Q1.MAKE_ACCT_BANK_ACCT_NUM) --N.prod_acct_num
          END                                                        AS ISU_ORG_LIQ_ACC,                --发行机构清算账号
    CASE WHEN (A.TRAN_STATUS_CD IN ('8') AND A.TA_CD IN ('Y4','GDHX' ) AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '华夏银行北京自贸试验区国际商务服务片区支行'   --ADD BY hulj20221019 根据上游提供的口径：代销理财的写死为：华夏银行北京自贸试验区国际商务服务片区支行
              --ELSE NVL(O.PROMPT,Q2.CD_DESCB)
              --ELSE TRIM(O.PROMPT)
              ELSE COALESCE(TRIM(IFM3.ORG_CN_FNAME),TRIM(O.PROMPT),TRIM(Q2.CD_DESCB))
      END                                                        AS ISU_ORG_LIQ_BANK_NM,                --发行机构清算行名
    CASE WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05') THEN ''
              --ELSE SUBSTRB(I.FIELD_VALUE,1,30)
              ELSE SUBSTRB(F.FINANCIER_NAME,1,30)
          END                                                        AS FIN_PSN_NM,                     --融资人名称
    F.HX_FINALINDUSTRY AS FIN_PSN_BLNG_IDY,                                                             --融资人所属行业
    'CNY' AS COMM_CUR,                                                                                  --手续费币种
    A.TRAN_COMM_FEE AS COMM_AMT,                                                                        --手续费金额
    '2' AS CASH_TRF_FLG,                                                                                --现转标志
    CASE WHEN LENGTH(A.CUST_MGR_ID) = 8 THEN A.CUST_MGR_ID END AS HDLR_NO ,                             --经办人工号
     CASE WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND (Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')
           THEN '800996' --代理代销信托计划  私人银行部
         WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND Q.FIELD_VALUE = '2'
           THEN '800996' --代理资产管理计划  私人银行部
        /* WHEN A.CONSMT_BUS_TYPE_CD = '02'
           THEN '800957' --代理代销保险产品  财富管理
    */
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05')
           THEN '800957'
          WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07'
           THEN '800957' END  AS DEPT_LINE, /*财富管理部 */                                             --部门条线
     '代理代销信托资管保险基金'  AS DATA_SRC                                                                --数据来源
    ,A.BUS_CD                                                                                          --业务编号
    ,C.PROD_ATTR_CD                                                                                    --产品属性
    ,C.MGER_NAME                                                                                       --管理人名称
    ,NVL(P.ACCT_BAL,A.cfm_amt)                                                                         --账户余额
    ,A.CONSMT_BUS_TYPE_CD                                                                              --代销业务类别
    ,A.TA_CD                                                                                           --TA_代码        --ADD BY MW 20221123
    ,A.TRAN_STATUS_CD                                                                                  --交易状态代码
    ,A.TRAN_CD            AS TRAN_CD        --交易编号
    ,DECODE(J1.FIELD_VALUE,'1','货币型','2','债券型','3','股票型','4','FOF型','5','非标类','6','混合类',J1.FIELD_VALUE)
                          AS  HX_TYPEDETAIL --代销细分类型
    ,A.PROD_ID            AS PROD_ID        --产品编号                                                                                                                                                                                                                                                                                  --交易代码
    ,Q.FIELD_VALUE                                                                                     --参数值
    ,C.MGER_NAME                                                                                       --管理人名称
    ,C.RISK_LEVEL_CD     AS RISK_LEVEL_CD                                                              --风险等级代码
    ,C.END_DT            AS END_DT                                                                     --到期日期
   ,NULL AS INSURE_PL_NUM                       --保险单号 add by hulj 20221128
   ,NULL AS POLICY_DT                           --保单日期 add by hulj 20221128
   ,NULL AS TRAN_STATUS_INSUR_CD                --保单状态 add by hulj 20221128
   ,A.TRAN_AGENT_FEE                            --代理费
   ,CASE WHEN (((A.TRAN_STATUS_CD = '8' /*AND A.TRAN_CD = '100200' */AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD IN ('04')
              AND ((Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')  --代理代销信托计划
              OR Q.FIELD_VALUE = '2'))  --代理资产管理计划
              OR (A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05','07'))) --新增 07他行理财产品
              AND A.TRAN_CD IN ('100200', '100202','100204','200209','200208'))
         THEN 'Y'
         ELSE 'N'
         END                                    MON_FLG  --月口径标识
  FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL A  --代理代销交易明细
  LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
   ON  NVL(A.TRAN_ORG_ID,A.TRAN_BELONG_ORG_ID) = B.ORG_ID
  LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO C --代理代销产品信息
    ON A.PROD_ID =C.PROD_ID
    AND A.CONSMT_BUS_TYPE_CD = C.CONSMT_BUS_TYPE_CD
    AND A.TA_CD = C.TA_CD
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D  --个人客户基本信息
    ON A.CUST_ID = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基本信息
    ON A.CUST_ID = E.CUST_ID
   AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN TCS_TBPRDPARAMVALUE F --资管信托产品参数值表 --MOD BY LIP 简化关联表
    ON F.PRD_CODE = A.PROD_ID
  LEFT JOIN O_ICL_CMM_FINC_ACCT_BAL_INFO P --理财账户余额信息
       ON P.TRAN_ACCT_ID = A.TRAN_ACCT_ID
       AND P.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD IFM1 --公共代码表--ADD BY LIP 20220914 理财的通过TA代码转义发行机构名称
           ON IFM1.CD_VAL = A.TA_CD
          AND IFM1.CD_ID = 'CD1574'
 LEFT JOIN RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO IFM2 --理财产品清算账户信息
           ON IFM2.PROD_ID = A.PROD_ID
          AND IFM2.TA_CD = A.TA_CD
          AND IFM2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND IFM2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN PTY_CPES_MEM IFM3
           ON IFM3.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(IFM2.REMARK_1)
          AND IFM3.RN = 1
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE G  --资管信托产品参数值表
    ON A.PROD_ID= G.PRD_CODE
   AND G.FIELD_CODE = 'pub_org_level'
   AND G.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND G.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE H  --资管信托产品参数值表
    ON A.PROD_ID= H.PRD_CODE
   AND H.FIELD_CODE = 'pub_org_level_org'
   AND H.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND H.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE I  --资管信托产品参数值表
    ON A.PROD_ID= I.PRD_CODE
   AND I.FIELD_CODE = 'financier_name'
   AND I.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND I.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE J  --资管信托产品参数值表
    ON A.PROD_ID= J.PRD_CODE
   AND J.FIELD_CODE = 'hx_finalindustry'
   AND J.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND J.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE Q  --资管信托产品参数值表
    ON A.PROD_ID= Q.PRD_CODE
   AND Q.FIELD_CODE = 'hx_prdtype'
   AND Q.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND Q.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE J1  --资管信托产品参数值表
    ON A.PROD_ID= J1.PRD_CODE
   AND J1.FIELD_CODE = 'hx_typedetail'
   AND J1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND J1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H Q1  --资管信托产品账号信息历史
    ON A.PROD_ID= Q1.PROD_ID
   AND A.TA_CD = Q1.TA_CD
   AND Q1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND Q1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD Q2          --公共代码表   --modify by 20220712 LHQ 因数仓修改Q1.CAP_VERI_ACCT_OPEN_BANK_CD码值映射，所以改为从代码表中取发行机构清算行名
    ON Q2.CD_VAL = Q1.CAP_VERI_ACCT_OPEN_BANK_CD
   AND Q2.CD_ID = 'CD1662'
   LEFT JOIN RRP_MDL.O_IOL_NFSS_TBPRDBANKACC N  --基金产品账号表
           ON N.PRD_CODE = A.PROD_ID /*(CASE WHEN A.CONSMT_BUS_TYPE_CD IN ('01','03','05') AND A.BUS_CD = '136' THEN T.TARGET_FINC_PROD_ID
                                 ELSE A.PROD_ID END)*/ --O_IML_EVT_CONSMT_FUND_TRAN_ENTR_H T  代销基金交易委托历史未接入
          AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_NFSS_TBDICT O   --基金数据字典       --modify by 20220718 LHQ因基金回因不同渠道会影响清算行名的取值，修改关联逻辑
           ON O.VAL = (CASE WHEN A.BUS_CD='150' THEN  N.OPEN_BANK_VER
                            WHEN A.BUS_CD !='150' THEN  N.OPEN_BANK_UP END)
          AND O.HS_KEY = 'K_CPTGR'
          AND O.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND O.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L  --存款主账户信息
    ON  A.BANK_ACCT_ID = L.CUST_ACCT_ID --用折号关联
   AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L1  ----存款主账户信息  --modify by tangan at 20221107 新一代里面，账号和卡号是分开的，以前CUST_ACCT_ID是优先取卡再取折，现在拆成了CUST_ACCT_ID和CUST_ACCT_CARD_NO，有卡有折的话，CUST_ACCT_ID放的是折号、CUST_ACCT_CARD_NO放的是卡号
    ON A.BANK_ACCT_ID = L1.CUST_ACCT_CARD_NO --用卡号关联
   AND L1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO M  --内部机构信息表
    ON NVL(L1.OPEN_ACCT_ORG_ID,L.OPEN_ACCT_ORG_ID) = M.ORG_ID
   AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
 WHERE
   TRUNC(A.TA_CFM_DT,'MM')= TRUNC(V_DATE,'MM')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 /*   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '插入代理代销交易信息表-代理代销信托资管保险基金';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_EAST_AGT_CPTL_DTL
   (
      DATA_DT                             --数据日期
   ,LGL_REP_ID                          --法人编号
   ,ORG_ID                              --机构编号
   ,CUST_ID                             --客户统一编号
   ,CUST_NM                             --客户名称
   ,CUST_ACC                            --客户账号
   ,OPEN_BANK_NM                        --开户行名称
   ,TRA_ID                              --交易编号
   ,AGCY_CONSI_TRA_TYP                  --代理代销交易类型
   ,CONSI_PROD_NM                       --代销产品名称
   ,TRA_DIR                             --交易方向
   ,TRA_DT                              --交易日期
   ,CUR                                 --币种
   ,TRA_AMT                             --交易金额
   ,ISU_ORG_NM                          --发行机构名称
   ,ISU_ORG_RTG                         --发行机构评级
   ,ISU_ORG_RTG_ORG_NM                  --发行机构评级机构
   ,ISU_ORG_LIQ_ACC                     --发行机构清算账号
   ,ISU_ORG_LIQ_BANK_NM                 --发行机构清算行名
   ,FIN_PSN_NM                          --融资人名称
   ,FIN_PSN_BLNG_IDY                    --融资人所属行业
   ,COMM_CUR                            --手续费币种
   ,COMM_AMT                            --手续费金额
   ,CASH_TRF_FLG                        --现转标志
   ,HDLR_NO                             --经办人工号
   ,DEPT_LINE                           --部门条线
   ,DATA_SRC                            --数据来源
   ,BUS_CD
   ,PRD_ATTR
   ,MGR_NM
   --,CURR_AMT
  )
  SELECT DISTINCT
    TO_CHAR(A.TA_CFM_DT, 'YYYYMMDD') AS DATA_DT,                                                       --数据日期
    A.LP_ID AS LGL_REP_ID,                                                                             --法人编号
    \*NVL(B.ORG_ID1,'800')*\ NVL(NVL(A.TRAN_ORG_ID,A.TRAN_BELONG_ORG_ID),'800')  AS ORG_ID,                                                                    --机构编号
    A.CUST_ID,                                                                                         --客户统一编号
    NVL(D.CUST_NAME,E.CUST_NAME) AS CUST_NM,                                                           --客户名称
    A.BANK_ACCT_ID AS CUST_ACC,                                                                        --客户账号
    M.ORG_NAME AS OPEN_BANK_NM,                                                                        --开户行名称
    A.TA_CD||A.TA_CFM_FLOW_NUM AS TRA_ID,                                                              --交易编号
    CASE WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND (Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')
           THEN '02' --代理代销信托计划
         WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND Q.FIELD_VALUE = '2'
           THEN '03' --代理资产管理计划
       \*  WHEN A.CONSMT_BUS_TYPE_CD = '02'
           THEN '04' --代理代销保险产品
    *\
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05')
           THEN '05' --代理代销基金
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07'
           THEN '07' END AS AGCY_CONSI_TRA_TYP, --代销他行理财产品                                      --代理代销交易类型
    A.PROD_NAME AS CONSI_PROD_NM,                                                                       --代销产品名称
    CASE WHEN A.TRAN_CD IN ('100200','100204','200209','200208') THEN '01' ELSE '02' END AS TRA_DIR ,   --交易方向
    TO_CHAR(A.TA_CFM_DT, 'YYYYMMDD') AS TRA_DT,                                                         --交易日期
    A.CURR_CD AS CUR,                                                                                   --币种
    A.CFM_AMT AS TRA_AMT,                                                                               --交易金额
    F.FIELD_VALUE AS ISU_ORG_NM,                                                  --发行机构名称
    G.FIELD_VALUE AS ISU_ORG_RTG,                                                                       --发行机构评级
    H.FIELD_VALUE AS ISU_ORG_RTG_ORG_NM,                                                                --发行机构评级机构
    \*NVL(*N.BANK_ACC_UP*,Q1.MAKE_ACCT_BANK_ACCT_NUM)*\ N.prod_acct_num AS ISU_ORG_LIQ_ACC,                                   --发行机构清算账号
    O.PROMPT AS ISU_ORG_LIQ_BANK_NM,                                                     --发行机构清算行名
   \* SUBSTRB(NVL(P.PUBLISHER_NAME,I.FIELD_VALUE),1,30)*\ SUBSTR(I.FIELD_VALUE,1,30) AS FIN_PSN_NM,                                    --融资人名称
    J.FIELD_VALUE AS FIN_PSN_BLNG_IDY,                                                                  --融资人所属行业
    'CNY' AS COMM_CUR,                                                                                  --手续费币种
    A.TRAN_COMM_FEE AS COMM_AMT,                                                                        --手续费金额
    '2' AS CASH_TRF_FLG,                                                                                --现转标志
    CASE WHEN LENGTH(A.CUST_MGR_ID) = 8 THEN A.CUST_MGR_ID END AS HDLR_NO ,                             --经办人工号
     CASE WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND (Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')
           THEN '800996' --代理代销信托计划  私人银行部
         WHEN A.TRAN_STATUS_CD = '8'  AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD = '04' AND Q.FIELD_VALUE = '2'
           THEN '800996' --代理资产管理计划  私人银行部
        \* WHEN A.CONSMT_BUS_TYPE_CD = '02'
           THEN '800957' --代理代销保险产品  财富管理
    *\
         WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05')
           THEN '800957'
          WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07'
           THEN '800957' END  AS DEPT_LINE, \*财富管理部 *\                                             --部门条线
    SUBSTR(A.JOB_CD, 0, 4)  AS DATA_SRC                                                                --数据来源
    ,A.BUS_CD
    ,C.PROD_ATTR_CD
    ,C.MGER_NAME
   -- ,C.CURR_BAL
  FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL A  --代理代销交易明细
  \*LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
   ON  NVL(A.TRAN_ORG_ID,A.TRAN_BELONG_ORG_ID) = B.ORG_ID *\
  LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO C --代理代销产品信息
    ON A.PROD_ID =C.PROD_ID
    AND A.STD_PROD_ID = C.STD_PROD_ID
    AND A.TA_CD = C.TA_CD
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D  --个人客户基本信息
    ON A.CUST_ID = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基本信息
    ON A.CUST_ID = E.CUST_ID
   AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE F  --资管信托产品参数值表
    ON A.PROD_ID= F.PRD_CODE
   AND F.FIELD_CODE = 'pub_org_name'
   AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE G  --资管信托产品参数值表
    ON A.PROD_ID= G.PRD_CODE
   AND G.FIELD_CODE = 'pub_org_level'
   AND G.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND G.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE H  --资管信托产品参数值表
    ON A.PROD_ID= H.PRD_CODE
   AND H.FIELD_CODE = 'pub_org_level_org'
   AND H.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND H.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE I  --资管信托产品参数值表
    ON A.PROD_ID= I.PRD_CODE
   AND I.FIELD_CODE = 'financier_name'
   AND I.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND I.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE J  --资管信托产品参数值表
    ON A.PROD_ID= J.PRD_CODE
   AND J.FIELD_CODE = 'hx_finalindustry'
   AND J.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND J.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE Q  --资管信托产品参数值表
    ON A.PROD_ID= Q.PRD_CODE
   AND Q.FIELD_CODE = 'hx_prdtype'
   AND Q.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND Q.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  \*LEFT JOIN RRP_MDL.O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H Q1  --资管信托产品账号信息历史
    ON A.PROD_ID= Q1.PROD_ID
   AND A.TA_CD = Q1.TA_CD
   AND Q1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND Q1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') *\
  \*LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBDICT Q2   --资管信托数据字典
    ON Q1.CAP_VERI_ACCT_OPEN_BANK_CD= Q2.VAL
   AND Q2.HS_KEY = 'K_CPTGR'
   AND Q2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND Q2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') *\
  \*LEFT JOIN RRP_MDL.O_IOL_NFSS_TBPRDPARAMVALUE K   --基金产品参数值表
    ON A.PROD_ID= K.PRD_CODE
   AND K.FIELD_CODE = 'prd_publisher'
   AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  \*LEFT JOIN RRP_MDL.O_IOL_NFSS_TBPRDBANKACC N  --基金产品账号表
    ON A.PROD_ID= N.PRD_CODE
   AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*\
   LEFT JOIN ( SELECT NN.*,ROW_NUMBER() OVER(PARTITION BY prod_cd ORDER BY TRAN_DT DESC ) RN   --------取最新一笔 modify by ljy at 20220817
     FROM RRP_MDL.O_IML_EVT_CONSMT_FUND_CLEAR_INFO_H NN
     WHERE NN.START_DT <= TO_DATE('20220531','YYYYMMDD')
   AND NN.END_DT > TO_DATE('20220531','YYYYMMDD')
    ) N--代销基金资金清算信息历史
    ON N.prod_cd = A.PROD_ID
    AND N.RN = 1
    \*  LEFT JOIN RRP_MDL.O_IML_EVT_CONSMT_FUND_CLEAR_INFO_H N--代销基金资金清算信息历史
    ON N.prod_CD = A.PROD_ID
    AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*\
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TBDICT O   --基金数据字典
    ON N.EVT_ID= O.VAL
   AND O.HS_KEY = 'K_CPTGR'
   AND O.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND O.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
 \* LEFT JOIN RRP_MDL.O_IOL_NFSS_TBPRDPUBLISHER P  --基金产品发行人表
    ON K.FIELD_VALUE = P.PUBLISHER_CODE
   AND P.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND P.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') *\
 \* LEFT JOIN O_IML_prd_consmt_fund_prod Z --代销基金产品
    ON Z.PROD_ID = A.PROD_ID
    AND Z.prod_found_dt < A.ETL_DT
    AND Z.prod_end_dt > a.etl_dt *\
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L  --存款主账户信息
    ON  A.BANK_ACCT_ID = L.CUST_ACCT_ID
   AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO M  --内部机构信息表
    ON L.OPEN_ACCT_ORG_ID = M.ORG_ID
   AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')         \*调整开户行名称取数口径MDY 20220512 PY *\
 WHERE (((A.TRAN_STATUS_CD = '8' \*AND A.TRAN_CD = '100200' *\AND C.RISK_LEVEL_CD<>'-' AND A.CONSMT_BUS_TYPE_CD IN ('04')
   AND ((Q.FIELD_VALUE = '1' OR C.MGER_NAME LIKE '%信托%')  --代理代销信托计划
    OR Q.FIELD_VALUE = '2'))  --代理资产管理计划
    OR (A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05','07'))) --新增 07他行理财产品
   AND A.TRAN_CD IN ('100200', '100202','100204','200209','200208'))  --04信托资管 02 保险 01 七兴宝 03 金融产品 05 盈米
   AND A.TA_CFM_DT = TO_DATE(V_P_DATE,'YYYYMMDD')   \*调整保险资管取数口径MDY 20220523 PY *\
   \* AND TRIM(A.APPL_FORM_ID) <> ' '*\
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '插入代理代销交易信息表-代理代销贵金属';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_EAST_AGT_CPTL_DTL
   (
    DATA_DT                             --数据日期
   ,LGL_REP_ID                          --法人编号
   ,ORG_ID                              --机构编号
   ,CUST_ID                             --客户统一编号
   ,CUST_NM                             --客户名称
   ,CUST_ACC                            --客户账号
   ,OPEN_BANK_NM                        --开户行名称
   ,TRA_ID                              --交易编号
   ,AGCY_CONSI_TRA_TYP                  --代理代销交易类型
   ,CONSI_PROD_NM                       --代销产品名称
   ,TRA_DIR                             --交易方向
   ,TRA_DT                              --交易日期
   ,CUR                                 --币种
   ,TRA_AMT                             --交易金额
   ,ISU_ORG_NM                          --发行机构名称
   ,ISU_ORG_RTG                         --发行机构评级
   ,ISU_ORG_RTG_ORG_NM                  --发行机构评级机构
   ,ISU_ORG_LIQ_ACC                     --发行机构清算账号
   ,ISU_ORG_LIQ_BANK_NM                 --发行机构清算行名
   ,FIN_PSN_NM                          --融资人名称
   ,FIN_PSN_BLNG_IDY                    --融资人所属行业
   ,COMM_CUR                            --手续费币种
   ,COMM_AMT                            --手续费金额
   ,CASH_TRF_FLG                        --现转标志
   ,HDLR_NO                             --经办人工号
   ,DEPT_LINE                           --部门条线
   ,DATA_SRC                            --数据来源
   ,CURR_AMT                            --当前余额
   ,CONSMT_BUS_TYPE_CD                  --代销业务类别
   ,TA_CD                               --TA代码
   ,TRAN_STATUS_CD                      --交易状态代码
   ,MON_FLG                             --月口径标识
  )
  SELECT  DISTINCT
    TO_CHAR(A.TRAN_DT, 'YYYYMMDD') AS DATA_DT,                                                          --数据日期
    --V_P_DATE,                                                                                            --数据日期
    A.LP_ID AS LGL_REP_ID,                                                                              --法人编号
    /*NVL(F.ORG_ID1,'800')*/  NVL(A.CUST_OPEN_ACCT_ORG_ID,'800')  AS ORG_ID,                                                                     --机构编号
    A.CUST_ID,                                                                                          --客户统一编号
    NVL(D.CUST_NAME,E.CUST_NAME) AS CUST_NM,                                                            --客户名称
    A.PAY_CARD_NUM AS CUST_ACC,                                                                         --客户账号
    NVL(H.ORG_NAME,A.BANK_NAME) AS OPEN_BANK_NM,                                                        --开户行名称  modify by tangan at 20221223
    A.INDENT_FLOW_NUM AS TRA_ID,                                                                        --交易编号
    '06' AS AGCY_CONSI_TRA_TYP,                                                                         --代理代销交易类型：代理贵金属交易
    C.MERCHD_NAME AS CONSI_PROD_NM,                                                                     --代销产品名称
    '01' AS TRA_DIR,                                                                                    --交易方向
    TO_CHAR(A.TRAN_DT, 'YYYYMMDD') AS TRA_DT,                                                           --交易日期
    'CNY' AS CUR,                                                                                       --币种
    A.INDENT_TOT_AMT AS TRA_AMT,                                                                        --交易金额
    C.PROVI_NAME AS ISU_ORG_NM,                                                                         --发行机构名称
    NULL AS ISU_ORG_RTG,                                                                                --发行机构评级
    NULL AS ISU_ORG_RTG_ORG_NM,                                                                         --发行机构评级机构
    G.ACCT_ID AS ISU_ORG_LIQ_ACC,                                                                       --发行机构清算账号
    SUBSTRB(G.OPEN_ACCT_BANK_NAME,1,30) AS ISU_ORG_LIQ_BANK_NM,                                         --发行机构清算行名
    NULL AS FIN_PSN_NM,                                                                                 --融资人名称
    NULL AS FIN_PSN_BLNG_IDY,                                                                           --融资人所属行业
    'CNY' AS COMM_CUR,                                                                                  --手续费币种
    B.SINGL_MERCHD_COMM_FEE*B.MERCHD_TOT_QTTY AS COMM_AMT,                                              --手续费金额
    '2' AS CASH_TRF_FLG,                                                                                --现转标志
    A.BANK_CUST_MGR_ID AS HDLR_NO,                                                                      --经办人工号
    '800957' AS DEPT_LINE , /*财富管理部 */                                                             --部门条线
    '代理代销贵金属' AS DATA_SRC,                                                                  --数据来源
    A.SURP_AVAL_AMT       AS CURR_AMT                                                                    --当前余额
    ,NULL                 AS CONSMT_BUS_TYPE_CD                                                          --代销业务类别
    ,NULL                 AS TA_CD                                                                       --TA代码
    ,B.TRAN_STATUS_CD     AS TRAN_STATUS_CD                                                              --交易状态代码
    ,CASE WHEN  A.MERCHD_TYPE_CD = '003'  --贵金属
                AND A.TRAN_CODE = '2301'  --消费
                AND A.SURP_AVAL_AMT!= 0
                AND A.TRAN_STATUS_CD = '001'
          THEN 'Y'
          ELSE 'N'
          END                                                                             MON_FLG     --月口径标识
  FROM RRP_MDL.O_IML_EVT_WEB_MALL_INDENT_INFO_H A --网上商城订单信息历史
 INNER JOIN RRP_MDL.O_IML_EVT_WEB_MALL_MERCHD_SUB_INFO_H B --网上商城商品子订单信息历史
    ON A.INDENT_FLOW_NUM = B.INDENT_FLOW_NUM
   AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_PRD_NOBLE_MET_PROD_INFO C --贵金属产品信息
    ON B.MERCHD_ID = C.MERCHD_ID
   AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D  --个人客户基本信息
    ON A.CUST_ID = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基本信息
    ON A.CUST_ID = E.CUST_ID
   AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  /*LEFT JOIN RRP_MDL.ORG_CONFIG F --机构配置表
   ON  A.CUST_OPEN_ACCT_ORG_ID = F.ORG_ID */
  LEFT JOIN RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO G --POS商户信息
   ON  A.MERCHT_NO = G.MERCHT_ID
  AND  G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO H  --内部机构信息表  modify by tangan at 20221223
    ON A.CUST_OPEN_ACCT_ORG_ID = H.ORG_ID
   AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
 WHERE A.MERCHD_TYPE_CD = '003'  --贵金属
   AND A.TRAN_CODE = '2301'  --消费
   AND A.SURP_AVAL_AMT!= 0
   AND A.TRAN_STATUS_CD = '001'
   AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND A.END_DT > TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
   AND TRUNC(A.TRAN_DT,'MM') = TRUNC(V_DATE,'MM');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '插入代理代销交易信息表-代理代销保险';
   V_STARTTIME := SYSDATE;
   INSERT /*+APPEND */INTO RRP_MDL.M_EAST_AGT_CPTL_DTL NOLOGGING
  (
    DATA_DT                             --1数据日期
   ,LGL_REP_ID                          --2法人编号
   ,ORG_ID                              --3机构编号
   ,CUST_ID                             --4客户统一编号
   ,CUST_NM                             --5客户名称
   ,CUST_ACC                            --6客户账号
   ,OPEN_BANK_NM                        --7开户行名称
   ,TRA_ID                              --8交易编号
   ,AGCY_CONSI_TRA_TYP                  --9代理代销交易类型
   ,CONSI_PROD_NM                       --10代销产品名称
   ,TRA_DIR                             --11交易方向
   ,TRA_DT                              --12交易日期
   ,CUR                                 --13币种
   ,TRA_AMT                             --14交易金额
   ,ISU_ORG_NM                          --15发行机构名称
   ,ISU_ORG_RTG                         --16发行机构评级
   ,ISU_ORG_RTG_ORG_NM                  --17发行机构评级机构
   ,ISU_ORG_LIQ_ACC                     --18发行机构清算账号
   ,ISU_ORG_LIQ_BANK_NM                 --19发行机构清算行名
   ,FIN_PSN_NM                          --20融资人名称
   ,FIN_PSN_BLNG_IDY                    --21融资人所属行业
   ,COMM_CUR                            --22手续费币种
   ,COMM_AMT                            --23手续费金额
   ,CASH_TRF_FLG                        --24现转标志
   ,HDLR_NO                             --25经办人工号
   ,DEPT_LINE                           --26部门条线
   ,DATA_SRC                            --27数据来源
   ,CURR_AMT                            --28当前余额
   ,PROD_ID                             --29标准产品编号
   ,PROD_ATTR_CD                        --30产品属性代码
   ,TRAN_CD                             --31交易代码
   ,HX_TYPEDETAIL                       --32代销细分类型
   ,FLOW_NUM                            --33流水号
   ,TRAN_STATUS_CD                      --34交易状态代码
   ,CFM_DT                              --35确认日期
   ,RISK_LEVEL_CD                       --36风险等级代码
   ,AGENCY_FEE                          --37代理费
   ,NV                                  --38净值
   ,TOT_LOT                             --39总份额
   ,END_DT                              --40产品到期日
   ,TRAN_CHN_CD                         --41交易渠道
   ,COMM_FEE                            --42手续费
   ,INSURE_PROD_PROJ_TYPE_CD            --43产品子类型
   ,CTRL_FLG_INFO                       --44控制标志信息
   ,CONSMT_BUS_TYPE_CD                  --45代销业务类别
   ,TA_CD                               --46TA代码
   ,FIELD_VALUE                         --47参数值
   ,MGER_NAME                           --48管理人名称
   ,INSURE_PL_NUM                       --49保险单号
   ,POLICY_DT                           --50保单日期
   ,TRAN_STATUS_INSUR_CD                --51保单状态
   ,MON_FLG                             --52月口径标识
  )
  SELECT  DISTINCT
    TO_CHAR(POLICY_DT,'YYYYMMDD'),                                                                                           --01数据日期
    A.LP_ID AS LGL_REP_ID,                                                                              --02法人编号
    NVL(B.ORG_ID1,'800') AS ORG_ID,                                                                     --03机构编号
    NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID) AS CUST_ID,                                                --04客户统一编号 modify by tangan at 20221223
    NVL(D.CUST_NAME,E.CUST_NAME) AS CUST_NM,                                                            --05客户名称
    A.BANK_ACCT_ID AS CUST_ACC,                                                                         --06客户账号
    G.ORG_NAME AS OPEN_BANK_NM,                                                                         --07开户行名称
    A.FLOW_NUM AS TRA_ID,                                                                               --08交易编号
    '04' AS AGCY_CONSI_TRA_TYP,                                                                         --09代理代销交易类型：代理保险
    C.PROD_NAME AS CONSI_PROD_NM,                                                                       --10代销产品名称
    '01' AS TRA_DIR,                                                                                    --11交易方向
   /* TO_CHAR(A.TRAN_DT, 'YYYYMMDD')*/
    TO_CHAR(A.POLICY_DT,'YYYYMMDD') AS TRA_DT,                                                          --12交易日期
    A.CURR_CD AS CUR,                                                                                   --13币种
    A.TRAN_AMT AS TRA_AMT,                                                                              --14交易金额
    H.CORP_NAME AS ISU_ORG_NM,                                                                          --15发行机构名称
    NULL AS ISU_ORG_RTG,                                                                                --16发行机构评级
    NULL AS ISU_ORG_RTG_ORG_NM,                                                                         --17发行机构评级机构
    NVL(N.ACCT_ID,NN.ACCT_ID) AS ISU_ORG_LIQ_ACC,                                                                            --18发行机构清算账号
    O.ORG_NAME AS ISU_ORG_LIQ_BANK_NM,                                                                        --19发行机构清算行名
    NULL AS FIN_PSN_NM,                                                                                 --20融资人名称
    NULL AS FIN_PSN_BLNG_IDY,                                                                           --21融资人所属行业
    A.CURR_CD AS COMM_CUR,                                                                              --22手续费币种
    A.COMM_FEE AS COMM_AMT,                                                                             --23手续费金额
    '2' AS CASH_TRF_FLG,                                                                                --24现转标志
    A.CUST_MGR_ID AS HDLR_NO,                                                                           --25经办人工号
    '800957' AS DEPT_LINE , /*财富管理部 */                                                             --26部门条线
    '代理代销保险' AS DATA_SRC                                                                          --27数据来源
    ,A.TRAN_AMT   AS  CURR_AMT                                                                          --28当前余额
    ,A.STD_PROD_ID  AS  PROD_ID                                                                         --29标准产品编号
    ,C.PROD_ATTR_CD AS  PROD_ATTR_CD                                                                    --30产品属性代码
    ,A.TRAN_CD  AS  TRAN_CD                                                                             --31交易代码
    ,DECODE(K.FIELD_VALUE,'1','货币型','2','债券型','3','股票型','4','FOF型','5','非标类','6','混合类',K.FIELD_VALUE)
                    AS  HX_TYPEDETAIL                                                                   --32代销细分类型
    ,M.TA_CD||M.TA_CFM_FLOW_NUM       AS  FLOW_NUM                                                      --33流水号
    ,A.TRAN_STATUS_CD  AS  TRAN_STATUS_CD    --modify by hulj 20221128                                  --34交易状态代码

    ,TO_CHAR(M.TA_CFM_DT,'YYYYMMDD')  AS  CFM_DT                                                        --35确认日期
    ,C.RISK_LEVEL_CD  AS  RISK_LEVEL_CD                                                                 --36风险等级代码
    ,M.TRAN_AGENT_FEE  AS  AGENCY_FEE                                                                   --37代理费
    ,T.NV  AS  NV                                                                                       --38净值
    ,T.TOT_LOT  AS  TOT_LOT                                                                                  --39总份额
    ,TO_CHAR(C.END_DT,'YYYYMMDD')  AS  END_DT                                                           --40产品到期日
    ,A.TRAN_CHN_CD  AS  TRAN_CHN_CD                                                                     --41交易渠道
    ,A.COMM_FEE  AS  COMM_FEE                                                                           --42手续费
    ,C.INSURE_PROD_PROJ_TYPE_CD  AS  INSURE_PROD_PROJ_TYPE_CD                                           --43产品子类型
    ,C.CTRL_FLG_INFO                                                                                    --44控制标志信息
    ,C.CONSMT_BUS_TYPE_CD                  CONSMT_BUS_TYPE_CD                                           --45代销业务类别
    ,C.TA_CD                               TA_CD                                                        --46TA代码
    ,NULL                   AS FIELD_VALUE                         --47参数值
    ,C.MGER_NAME            AS MGER_NAME                           --48管理人名称
    ,A.INSURE_PL_NUM        AS  INSURE_PL_NUM   --49保险单号 add by hulj 20221128
    ,TO_CHAR(A.POLICY_DT,'YYYYMMDD')        AS  POLICY_DT  --50保单日期 add by hulj 20221128
    ,H.TRAN_STATUS_CD       AS TRAN_STATUS_INSUR_CD --51保单状态 add by hulj 20221128
    , CASE WHEN (A.TRAN_STATUS_CD = 'S' AND H.TRAN_STATUS_CD = '0')
                 OR (A.TRAN_STATUS_CD = '3' AND H.TRAN_STATUS_CD = '1')
           THEN 'Y'
           ELSE 'N'
           END                  AS MON_FLG  --月口径标识
  FROM (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY T.FLOW_NUM ORDER BY T.END_DT DESC) RN FROM  O_IML_EVT_INSURE_TRAN_FLOW T   --保险交易流水
    WHERE  T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND  T.END_DT > TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')) A
 INNER JOIN (SELECT DISTINCT A.INSURE_PL_ID,B.CORP_NAME,A.TRAN_STATUS_CD,B.TA_CD
               FROM RRP_MDL.O_IML_AGT_INSURE_PL A --保险单
               LEFT JOIN RRP_MDL.O_IML_REF_INSU_COMP B --保险公司
                 ON A.TA_CD = B.TA_CD
             /* WHERE A.TRAN_STATUS_CD='0'*/ --保单状态 正常   CD2173
             ) H
    ON A.INSURE_PL_NUM = H.INSURE_PL_ID
  LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
    ON A.TRAN_ORG_ID = B.ORG_ID
  LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO C --代理代销产品信息
    ON A.PROD_ID = C.PROD_ID
   AND A.TA_CD = C.TA_CD
   AND C.CONSMT_BUS_TYPE_CD='02'
   AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO F  ----存款主账户信息
    ON A.BANK_ACCT_ID = F.CUST_ACCT_ID  --用折号关联
   AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO F1  ----存款主账户信息  --modify by tangan at 20221107 新一代里面，账号和卡号是分开的，以前CUST_ACCT_ID是优先取卡再取折，现在拆成了CUST_ACCT_ID和CUST_ACCT_CARD_NO，有卡有折的话，CUST_ACCT_ID放的是折号、CUST_ACCT_CARD_NO放的是卡号
    ON A.BANK_ACCT_ID = F1.CUST_ACCT_CARD_NO --用卡号关联
   AND F1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D  --个人客户基本信息
    ON NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID) = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基本信息
    ON NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID) = E.CUST_ID
   AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO G  --内部机构信息表
    ON NVL(F1.OPEN_ACCT_ORG_ID,F.OPEN_ACCT_ORG_ID) = G.ORG_ID
   AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE K  --资管信托产品参数值表
    ON A.PROD_ID= K.PRD_CODE
   AND K.FIELD_CODE = 'hx_typedetail'
   AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND K.END_DT > TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
/*  LEFT JOIN O_ICL_CMM_AGENT_CONSMT_TRAN_DTL M
       ON M.RELA_FLOW_NUM = A.RELA_FLOW_NUM     --modify by tangan at 20221107 存在空关联空的情况，调整逻辑
       AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
  LEFT JOIN (SELECT * FROM O_ICL_CMM_AGENT_CONSMT_TRAN_DTL WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND TRIM(RELA_FLOW_NUM) IS NOT NULL) M
         ON M.RELA_FLOW_NUM = A.RELA_FLOW_NUM
  LEFT JOIN RRP_MDL.O_IML_AGT_INSU_COMP_ACCT_NUM_INFO_H N   --保险公司账号信息历史
      ON H.CORP_NAME = N.ACCT_NAME
     AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND N.END_DT > TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD') ,'MM')                              /*调整发行机构清算账号取数口径MDY 20220708 LHQ */
  LEFT JOIN RRP_MDL.O_IML_AGT_INSU_COMP_ACCT_NUM_INFO_H NN   --保险公司账号信息历史--MOD BY LIP 20220915
      ON NN.INSU_COMP_ID = H.TA_CD
     AND NN.ACCT_TYPE_CD = '2'
     AND NN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND NN.END_DT > TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
  LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L  --存款主账户信息
      ON L.CUST_ACCT_ID = NVL(N.ACCT_ID,NN.ACCT_ID)
     AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT LL
      ON LL.MAIN_ACCT_ID = NVL(N.ACCT_ID,NN.ACCT_ID)
     AND LL.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO O  --内部机构信息表
      ON O.ORG_ID = NVL(L.OPEN_ACCT_ORG_ID,LL.BELONG_ORG_ID)
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (select PROD_ID,NV,SUM(TOT_LOT)TOT_LOT
                  from  RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO
                  WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND CONSMT_BUS_TYPE_CD='04'
                  GROUP BY PROD_ID,NV)   T --代销产品份额信息
    ON A.PROD_ID =T.PROD_ID
  /*LEFT JOIN (select PROD_ID,NV,SUM(TOT_LOT)TOT_LOT
                  from  RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO
                  WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND CONSMT_BUS_TYPE_CD='04'
                  GROUP BY PROD_ID,NV) T5 --tcs.tbshare0
         ON A.PROD_ID=T5.PROD_ID*/
 WHERE /*A.TRAN_CD = '510001'
   AND A.TRAN_STATUS_CD ='S'*/
   ( (A.TRAN_STATUS_CD = 'S' AND H.TRAN_STATUS_CD = '0')
   OR (A.TRAN_STATUS_CD = '3' AND H.TRAN_STATUS_CD = '1') ) --MODIFY BY MW 20221116  交易状态为 S 成功,保单状态 0 正常） 或者 （交易状态 3   已退保   保单状态 1  非犹豫期退保 ）
   AND TRUNC(A.POLICY_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
/*   AND A.TRAN_AMT > 0*/
   AND A.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 增加数据重复校验 --
        WITH TMP1 AS (
  SELECT DATA_DT,TRA_ID,CUST_ID,COUNT(1)
    FROM RRP_MDL.M_EAST_AGT_CPTL_DTL T
   WHERE SUBSTR(T.DATA_DT,1,6) = SUBSTR(V_P_DATE,1,6)
   GROUP BY DATA_DT,TRA_ID,CUST_ID
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
/*   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
*/
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

  END ETL_INIT_M_EAST_AGT_CPTL_DTL;
/

