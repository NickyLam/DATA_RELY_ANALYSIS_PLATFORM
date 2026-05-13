CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_EAST_AGT_CPTL_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_EAST_AGT_CPTL_DTL
  *  功能描述：代理代销交易信息表
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_EAST_AGT_CPTL_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20220611  梅炜    首次创建
  *             2    20221019  HULJ    简化关联表,调整逻辑
  *             3    20221122  HULJ    增加数据重复校验
  *             4    20221128  HULJ    新增字段新增保单号、保单日期、保单状态字段
  *             5    20240813  LIP     业务代码为198快速过户的，需报送，报送的金额为确认流水中的确认份额
  *                                    业务代码为142强行赎回，且客户名称是广东华兴银行的，不作报送
  *             6    20241015  LIP     发行机构清算账号理财取数状态加上'7'
  *             7    20241114  LIP     增加债券承销数据
  *             8    20241125  LIP     调整发行机构清算账号的取数方式
  *             9    20250508  LIP     理财部分的保单号赋值为确认流水号，以供业务核数
  *             10   20250519  LTJ     新增销售日期、销售时间
  *             11   20250715  LIP     债券承销部分SPV客户号转换成ECIF客户号
  *             12   20250919  LIP     代理理财、基金、信托部分，因财富管理平台改造，需增加取数的交易代码范围
  *             13   20251027  LIP     POS商户信息上游不迁移，用迁移前的数据补充清算账号信息
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;              --处理步骤
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);             --任务名称
  V_PART_NAME VARCHAR2(100);             --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_EAST_AGT_CPTL_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_EAST_AGT_CPTL_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';--来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_EAST_AGT_CPTL_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_EAST_AGT_CPTL_DTL'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

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
  V_STEP_DESC := '插入代理代销交易信息表-代理代销信托资管保险基金';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_AGT_CPTL_DTL
    (DATA_DT                             --数据日期
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
    ,BUS_CD                              --业务代码
    --MODIFY BY CYK
    --,PRD_ATTR                          --产品属性
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
    ,TRAN_DT                             --销售日期
    ,TRAN_TM                             --销售时间
    )
    WITH NFSS_TCS_TBPRDPARAMVALUE AS (--简化关联表
  SELECT PRD_CODE,T.FIELD_CODE,TRIM(T.FIELD_VALUE) FIELD_VALUE
    FROM RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE T
   WHERE T.FIELD_CODE IN ('pub_org_name','pub_org_level','pub_org_level_org','financier_name',
                          'hx_finalindustry','hx_prdtype','hx_typedetail')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   TCS_TBPRDPARAMVALUE AS (
  SELECT /*+MATERIALIZE*/ * FROM (SELECT PRD_CODE,FIELD_CODE,FIELD_VALUE FROM NFSS_TCS_TBPRDPARAMVALUE)
   PIVOT(MAX(FIELD_VALUE) FOR FIELD_CODE IN
     ('pub_org_name' AS PUB_ORG_NAME,'pub_org_level' AS PUB_ORG_LEVEL,'pub_org_level_org' AS PUB_ORG_LEVEL_ORG,
     'financier_name' AS FINANCIER_NAME,'hx_finalindustry' AS HX_FINALINDUSTRY,'hx_prdtype' AS HX_PRDTYPE,'hx_typedetail' AS HX_TYPEDETAIL)))
  SELECT DISTINCT
          V_P_DATE                                                   AS DATA_DT           --数据日期
         ,A.LP_ID                                                    AS LGL_REP_ID        --法人编号
         ,NVL(B.ORG_ID1,'800')                                       AS ORG_ID            --机构编号
         ,A.CUST_ID                                                  AS CUST_ID           --客户统一编号
         ,NVL(D.CUST_NAME,E.CUST_NAME)                               AS CUST_NM           --客户名称
         ,A.BANK_ACCT_ID                                             AS CUST_ACC          --客户账号
         ,M.ORG_NAME                                                 AS OPEN_BANK_NM      --开户行名称
         ,A.TA_CD||A.TA_CFM_FLOW_NUM                                 AS TRA_ID            --交易编号
         ,CASE WHEN A.TRAN_STATUS_CD = '8' AND C.RISK_LEVEL_CD <> '-' AND A.CONSMT_BUS_TYPE_CD = '04'
                    AND (F.HX_PRDTYPE = '1' OR C.MGER_NAME LIKE '%信托%') THEN '02' --代理代销信托计划
               WHEN A.TRAN_STATUS_CD = '8' AND C.RISK_LEVEL_CD <> '-' AND A.CONSMT_BUS_TYPE_CD = '04'
                    AND F.HX_PRDTYPE = '2' THEN '03' --代理资产管理计划
               /*WHEN A.CONSMT_BUS_TYPE_CD = '02' THEN '04' --代理代销保险产品*/
               WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05') THEN '05' --代理代销基金
               WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07' THEN '07' --代销他行理财产品
           END                                                       AS AGCY_CONSI_TRA_TYP --代理代销交易类型
         ,A.PROD_NAME                                                AS CONSI_PROD_NM     --代销产品名称
         ,CASE WHEN A.TRAN_CD IN ('100200','100204','200209','200208') THEN '01'
               --WHEN A.TRAN_CD IN ('110200','110204','1B0200','1B0204') THEN '01' --财富平台新代码 --ADD BY 20250919
               WHEN A.TRAN_CD IN ('110200','110204','210208','1B0200','1B0204','2B0208','180200','180204') THEN '01' --财富平台新代码 --ADD BY 20260123
               ELSE '02'
           END                                                       AS TRA_DIR           --交易方向
         ,TO_CHAR(A.TA_CFM_DT,'YYYYMMDD')                            AS TRA_DT            --交易日期
         ,A.CURR_CD                                                  AS CUR               --币种
         ,CASE WHEN A.BUS_CD = '198' THEN A.CFM_LOT --MOD BY LIP 20240813 业务代码为198快速过户的，需报送，报送的金额为确认流水中的确认份额
               ELSE A.CFM_AMT
           END                                                       AS TRA_AMT           --交易金额
         ,CASE WHEN (A.TRAN_STATUS_CD IN ('7','8') AND A.TA_CD IN ('Y4','GDHX') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
               THEN '华夏理财有限责任公司' --MOD BY LIP 20230711 根据岑建明口径变更
               ELSE COALESCE(TRIM(F.PUB_ORG_NAME),TRIM(C.ISSUER_NAME),TRIM(IFM1.CD_DESCB)) --MODIFY BY TANGAN AT 20221107
           END                                                        AS ISU_ORG_NM        --发行机构名称
         ,F.PUB_ORG_LEVEL                                             AS ISU_ORG_RTG       --发行机构评级--MOD BY HULJ 20221019
         ,CASE WHEN (A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
               THEN '无' --ADD BY LAIHAIQIANG 20220708 根据上游提供的口径：代销理财的写死为：无
               ELSE F.PUB_ORG_LEVEL_ORG
           END                                                        AS ISU_ORG_RTG_ORG_NM--发行机构评级机构
        ,CASE WHEN (A.TRAN_STATUS_CD IN ('7','8') AND A.TA_CD IN ('Y4','GDHX') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '10237000000233670' --ADD BY LAIHAIQIANG 20220704 根据上游提供的口径：代销理财的写死为：10237000000233670
              WHEN (A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN IFM2.MAKE_ACCT_BANK_ACCT_ID
              ELSE NVL(N.BANK_ACC_UP,Q1.MAKE_ACCT_BANK_ACCT_NUM)
          END                                                         AS ISU_ORG_LIQ_ACC   --发行机构清算账号
        ,CASE WHEN (A.TRAN_STATUS_CD IN ('7','8') AND A.TA_CD IN ('Y4','GDHX') AND A.CONSMT_BUS_TYPE_CD IN ('07')) --代销理财
              THEN '华夏银行北京自贸试验区国际商务服务片区支行' --ADD BY HULJ20221019 根据上游提供的口径：代销理财的写死为：华夏银行北京自贸试验区国际商务服务片区支行
              --ELSE COALESCE(TRIM(IFM3.ORG_CN_FNAME),TRIM(O.PROMPT),TRIM(Q2.CD_DESCB))
              ELSE COALESCE(TRIM(IFM3.ORG_CN_FNAME),TRIM(IFM4.BKNAME),TRIM(O.PROMPT),TRIM(Q2.CD_DESCB)) --MOD BY LIP 20260123
          END                                                         AS ISU_ORG_LIQ_BANK_NM--发行机构清算行名
        ,CASE WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05') THEN ''
              ELSE F.FINANCIER_NAME
          END                                                         AS FIN_PSN_NM        --融资人名称
        ,F.HX_FINALINDUSTRY                                           AS FIN_PSN_BLNG_IDY  --融资人所属行业
        ,'CNY'                                                        AS COMM_CUR          --手续费币种
        ,A.TRAN_COMM_FEE                                              AS COMM_AMT          --手续费金额
        ,'2'                                                          AS CASH_TRF_FLG      --现转标志
        ,CASE WHEN LENGTH(A.CUST_MGR_ID) = 8 THEN A.CUST_MGR_ID END   AS HDLR_NO          --经办人工号
        ,CASE WHEN A.TRAN_STATUS_CD = '8' AND C.RISK_LEVEL_CD <> '-' AND A.CONSMT_BUS_TYPE_CD = '04'
                   AND (F.HX_PRDTYPE = '1' OR C.MGER_NAME LIKE '%信托%') THEN '800996' --代理代销信托计划 私人银行部
              WHEN A.TRAN_STATUS_CD = '8' AND C.RISK_LEVEL_CD <> '-' AND A.CONSMT_BUS_TYPE_CD = '04'
                   AND F.HX_PRDTYPE = '2' THEN '800996' --代理资产管理计划 私人银行部
              WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05') THEN '800957'
              WHEN A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD = '07' THEN '800957' --财富管理部
          END                                                        AS DEPT_LINE         --部门条线
        ,'代理代销信托资管保险基金'                                  AS DATA_SRC           --数据来源
        ,A.BUS_CD                                                    AS BUS_CD             --业务编号
        ,C.PROD_ATTR_CD                                              AS PROD_ATTR_CD       --产品属性
        ,C.MGER_NAME                                                 AS MGR_NM             --管理人名称
        ,A.CFM_AMT                                                   AS CURR_AMT           --账户余额
        ,A.CONSMT_BUS_TYPE_CD                                        AS CONSMT_BUS_TYPE_CD --代销业务类别
        ,A.TA_CD                                                     AS TA_CD              --TA_代码 --ADD BY MW 20221123
        ,A.TRAN_STATUS_CD                                            AS TRAN_STATUS_CD     --交易状态代码
        ,A.TRAN_CD                                                   AS TRAN_CD            --交易编号
        ,DECODE(F.HX_TYPEDETAIL,'1','货币型','2','债券型','3','股票型','4','FOF型','5','非标类','6','混合类',F.HX_TYPEDETAIL) AS HX_TYPEDETAIL --代销细分类型
        ,A.PROD_ID                                                   AS PROD_ID            --产品编号                                                                                                                                                                                                                                                                                  --交易代码
        ,F.HX_PRDTYPE                                                AS FIELD_VALUE        --参数值
        ,C.MGER_NAME                                                 AS MGER_NAME          --管理人名称
        ,C.RISK_LEVEL_CD                                             AS RISK_LEVEL_CD      --风险等级代码
        ,TO_CHAR(C.END_DT,'YYYYMMDD')                                AS END_DT             --到期日期 --MOD BY LIP 20250425
        ,CASE WHEN A.CONSMT_BUS_TYPE_CD = '07' THEN A.TA_CFM_FLOW_NUM
              ELSE NULL
          END                                                        AS INSURE_PL_NUM      --保险单号 --MOD BY LIP 20250508 理财的赋值为确认流水号，以供业务核数
        ,NULL                                                        AS POLICY_DT          --保单日期
        ,NULL                                                        AS TRAN_STATUS_INSUR_CD --保单状态
        ,A.TRAN_AGENT_FEE                                            AS AGENCY_FEE         --代理费
        ,CASE WHEN A.CONSMT_BUS_TYPE_CD = '07' AND A.BUS_CD = '142' AND A.CUST_ID = '800001' THEN 'N' --MOD BY LIP 20240809 业务代码为142强行赎回，且客户名称是广东华兴银行的，不作报送
              WHEN A.CONSMT_BUS_TYPE_CD = '07' AND A.BUS_CD = '142' AND A.CUST_ID = '5000000332' THEN 'N' --MOD BY LIP 20260209 业务代码为142强行赎回，且客户名称是广东华兴银行的，不作报送
              WHEN A.CONSMT_BUS_TYPE_CD = '07' AND A.BUS_CD = '198' THEN 'Y' --MOD BY LIP 20240813 业务代码为198快速过户的，需报送，报送的金额为确认流水中的确认份额
              WHEN (((A.TRAN_STATUS_CD = '8' AND C.RISK_LEVEL_CD <> '-' AND A.CONSMT_BUS_TYPE_CD IN ('04')
                   AND ((F.HX_PRDTYPE = '1' OR C.MGER_NAME LIKE '%信托%') --代理代销信托计划
                   OR F.HX_PRDTYPE = '2')) --代理资产管理计划
                   OR (A.TRAN_STATUS_CD IN ('7','8') AND A.CONSMT_BUS_TYPE_CD IN ('01','03','05','07'))) --新增 07他行理财产品
                   /*AND A.TRAN_CD IN ('100200','100202','100204','200209','200208','100406','110200','1B0200','110202', --ADD BY LIP 20230815 增加100406强制赎回
                       '1B0202','110204','1B0204','110406','1B0406') --ADD BY LIP 20250919 增加财富平台新版代码*/
                   AND A.TRAN_CD IN ('100200','100202','100204','200209','200208','100406','110200','110202','110204','110406',
                       '210208','1B0200','1B0202','1B0204','2B0208','1B0406',
                       '180200','180202','180204','180406'))--MOD BY LIP 20250919 增加财富平台新版代码
              THEN 'Y'
              ELSE 'N'
          END                                                         AS MON_FLG           --月口径标识
        ,A.TRAN_HAPP_DT                                               AS TRAN_DT           --销售日期 ADD BY LTJ 20250519
        ,A.TRAN_HAPP_TM                                               AS TRAN_TM           --销售时间 ADD BY LTJ 20250519
    FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL A --代理代销交易明细
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = NVL(A.TRAN_ORG_ID,A.TRAN_BELONG_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO C --代理代销产品信息
      ON C.PROD_ID = A.PROD_ID
     AND C.CONSMT_BUS_TYPE_CD = A.CONSMT_BUS_TYPE_CD
     AND C.TA_CD = A.TA_CD
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TCS_TBPRDPARAMVALUE F --资管信托产品参数值表 --MOD BY LIP 简化关联表
      ON F.PRD_CODE = A.PROD_ID
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD IFM1 --公共代码表--ADD BY LIP 20220914 理财的通过TA代码转义发行机构名称
      ON IFM1.CD_VAL = A.TA_CD
     AND IFM1.CD_ID = 'CD1574'
    LEFT JOIN RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO IFM2 --理财产品清算账户信息
      ON IFM2.PROD_ID = A.PROD_ID
     AND IFM2.TA_CD = A.TA_CD
     AND IFM2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND IFM2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM IFM3
      ON IFM3.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(IFM2.REMARK_1)
     AND IFM3.RANK = 1
     AND IFM3.ID_MARK <> 'D'
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO IFM4
      ON IFM4.BKCD = TRIM(IFM2.REMARK_1)
     AND IFM4.ID_MARK <> 'D'
     AND IFM4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND IFM4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE Q --资管信托产品参数值表
      ON Q.PRD_CODE = A.PROD_ID
     AND Q.FIELD_CODE = 'hx_prdtype'
     AND Q.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND Q.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
    /*LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE J1 --资管信托产品参数值表
      ON J1.PRD_CODE = A.PROD_ID
     AND J1.FIELD_CODE = 'hx_typedetail'
     AND J1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND J1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN RRP_MDL.O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H Q1 --资管信托产品账号信息历史
      ON Q1.PROD_ID = A.PROD_ID
     AND Q1.TA_CD = A.TA_CD
     AND Q1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND Q1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD Q2 --公共代码表 --MODIFY BY 20220712 LHQ 因数仓修改Q1.CAP_VERI_ACCT_OPEN_BANK_CD码值映射，所以改为从代码表中取发行机构清算行名
      ON Q2.CD_VAL = Q1.CAP_VERI_ACCT_OPEN_BANK_CD
     AND Q2.CD_ID = 'CD1662'
    LEFT JOIN RRP_MDL.O_IOL_NFSS_TBPRDBANKACC N --基金产品账号表
      ON N.PRD_CODE = A.PROD_ID /*(CASE WHEN A.CONSMT_BUS_TYPE_CD IN ('01','03','05') AND A.BUS_CD = '136' THEN T.TARGET_FINC_PROD_ID
                                  ELSE A.PROD_ID END)*/ --O_IML_EVT_CONSMT_FUND_TRAN_ENTR_H T 代销基金交易委托历史未接入
     AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.O_IOL_NFSS_TBDICT O --基金数据字典 --MODIFY BY 20220718 LHQ因基金回因不同渠道会影响清算行名的取值，修改关联逻辑
      ON O.VAL = (CASE WHEN A.BUS_CD = '150' THEN N.OPEN_BANK_VER WHEN A.BUS_CD != '150' THEN N.OPEN_BANK_UP END)
     AND O.HS_KEY = 'K_CPTGR'
     AND O.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND O.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN RRP_MDL.O_IOL_IFMS_TBDICT O --基金数据字典 --MODIFY BY 20260309 财富管理平台切换
      ON O.VAL = (CASE WHEN A.BUS_CD = '150' THEN N.OPEN_BANK_VER WHEN A.BUS_CD != '150' THEN N.OPEN_BANK_UP END)
     AND O.HS_KEY = 'K_CPTGR'
     AND O.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND O.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L --存款主账户信息
      ON L.CUST_ACCT_ID = A.BANK_ACCT_ID --用折号关联
     AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L1 --存款主账户信息 --MODIFY BY TANGAN AT 20221107 新一代里面，账号和卡号是分开的，以前CUST_ACCT_ID是优先取卡再取折，现在拆成了CUST_ACCT_ID和CUST_ACCT_CARD_NO，有卡有折的话，CUST_ACCT_ID放的是折号、CUST_ACCT_CARD_NO放的是卡号
      ON L1.CUST_ACCT_CARD_NO = A.BANK_ACCT_ID --用卡号关联
     AND L1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO M --内部机构信息表
      ON M.ORG_ID = NVL(L1.OPEN_ACCT_ORG_ID,L.OPEN_ACCT_ORG_ID)
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TA_CFM_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.TA_CFM_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     /*AND A.TA_CFM_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入代理代销交易信息表-代理代销贵金属';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_EAST_AGT_CPTL_DTL
    (DATA_DT                             --数据日期
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
  SELECT DISTINCT
          V_P_DATE                                                 AS DATA_DT           --数据日期
         ,A.LP_ID                                                  AS LGL_REP_ID        --法人编号
         --,NVL(TRIM(A.CUST_OPEN_ACCT_ORG_ID),'800')                 AS ORG_ID            --机构编号
         ,NVL(TRIM(A.PAY_CARD_OPEN_ACCT_ORG_ID),'800')             AS ORG_ID            --机构编号 --MOD BY LIP 20251016
         ,A.CUST_ID                                                AS CUST_ID           --客户统一编号
         ,NVL(D.CUST_NAME,E.CUST_NAME)                             AS CUST_NM           --客户名称
         ,A.PAY_CARD_NUM                                           AS CUST_ACC          --客户账号
         ,NVL(H.ORG_NAME,TRIM(A.BANK_NAME))                        AS OPEN_BANK_NM       --开户行名称 MODIFY BY TANGAN AT 20221223
         ,A.INDENT_FLOW_NUM                                        AS TRA_ID            --交易编号
         ,'06'                                                     AS AGCY_CONSI_TRA_TYP--代理代销交易类型：代理贵金属交易
         ,C.MERCHD_NAME                                            AS CONSI_PROD_NM     --代销产品名称
         ,'01'                                                     AS TRA_DIR           --交易方向
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                           AS TRA_DT            --交易日期
         ,'CNY'                                                    AS CUR               --币种
         ,A.INDENT_TOT_AMT                                         AS TRA_AMT           --交易金额
         ,C.PROVI_NAME                                             AS ISU_ORG_NM        --发行机构名称
         ,NULL                                                     AS ISU_ORG_RTG       --发行机构评级
         ,NULL                                                     AS ISU_ORG_RTG_ORG_NM--发行机构评级机构
         /*,G.ACCT_ID                                                AS ISU_ORG_LIQ_ACC   --发行机构清算账号
         ,G.OPEN_ACCT_BANK_NAME                                    AS ISU_ORG_LIQ_BANK_NM--发行机构清算行名*/
         ,NVL(TRIM(G.ACCT_ID),TRIM(G1.ACCT_ID))                    AS ISU_ORG_LIQ_ACC   --发行机构清算账号
         ,NVL(TRIM(G.OPEN_ACCT_BANK_NAME),TRIM(G1.OPEN_ACCT_BANK_NAME)) AS ISU_ORG_LIQ_BANK_NM--发行机构清算行名
         ,NULL                                                     AS FIN_PSN_NM        --融资人名称
         ,NULL                                                     AS FIN_PSN_BLNG_IDY  --融资人所属行业
         ,'CNY'                                                    AS COMM_CUR          --手续费币种
         --,B.SINGL_MERCHD_COMM_FEE*B.MERCHD_TOT_QTTY                AS COMM_AMT          --手续费金额
         ,B.SINGLE_MERCHD_COMM_FEE*B.MERCHD_TOT_QTTY               AS COMM_AMT           --手续费金额 --MOD BY LIP 20251016 商户收单切换
         ,'2'                                                      AS CASH_TRF_FLG      --现转标志
         --,A.BANK_CUST_MGR_ID                                       AS HDLR_NO           --经办人工号
         ,TRIM(A.CUST_MGR_ID)                                      AS HDLR_NO           --经办人工号 --MOD BY LIP 20251016 商户收单切换
         ,'800957'                                                 AS DEPT_LINE         --部门条线/*财富管理部*/
         ,'代理代销贵金属'                                         AS DATA_SRC          --数据来源
         ,A.SURP_AVAL_AMT                                          AS CURR_AMT           --当前余额
         ,NULL                                                     AS CONSMT_BUS_TYPE_CD --代销业务类别
         ,NULL                                                     AS TA_CD              --TA代码
         --,B.TRAN_STATUS_CD                                         AS TRAN_STATUS_CD     --交易状态代码
         ,A.TRAN_STATUS_CD                                         AS TRAN_STATUS_CD     --交易状态代码
         /*,CASE WHEN A.MERCHD_TYPE_CD = '003' \*贵金属*\ AND A.TRAN_CODE = '2301' \*消费*\
                    AND A.SURP_AVAL_AMT != 0 AND A.TRAN_STATUS_CD = '001'
               THEN 'Y'
               ELSE 'N'
           END                                                     AS MON_FLG            --月口径标识*/
         ,CASE WHEN A.MERCHD_TYPE_CD = '003' /*贵金属*/ AND A.TRAN_DESCB = '消费' /*消费*/
                    AND A.SURP_AVAL_AMT != 0 AND A.TRAN_STATUS_CD = '02'
               THEN 'Y'
               ELSE 'N'
           END                                                     AS MON_FLG            --月口径标识
    FROM RRP_MDL.O_IML_EVT_POINT_MALL_PAY_FLOW A --积分商城订单流水 
   INNER JOIN RRP_MDL.O_IML_EVT_POINT_MALL_PAY_MEC_INFO B --积分商城订单商品信息
      ON B.INDENT_FLOW_NUM = A.INDENT_FLOW_NUM
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    /*FROM RRP_MDL.O_IML_EVT_WEB_MALL_INDENT_INFO_H A --网上商城订单信息历史
   INNER JOIN RRP_MDL.O_IML_EVT_WEB_MALL_MERCHD_SUB_INFO_H B --网上商城商品子订单信息历史
      ON B.INDENT_FLOW_NUM = A.INDENT_FLOW_NUM
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN RRP_MDL.O_IML_PRD_NOBLE_MET_PROD_INFO C --贵金属产品信息
      ON C.MERCHD_ID = B.MERCHD_ID
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO G --POS商户信息
      --ON G.MERCHT_ID = A.MERCHT_NO
      ON G.MERCHT_ID = A.MERCHT_ID --MOD BY LIP 20251016
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO H --内部机构信息表  MODIFY BY TANGAN AT 20221223
      --ON H.ORG_ID = A.CUST_OPEN_ACCT_ORG_ID
      ON H.ORG_ID = A.PAY_CARD_OPEN_ACCT_ORG_ID --MOD BY LIP 20251016
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO G1 --POS商户信息 --迁移前的数据
      ON G1.MERCHT_ID = A.MERCHT_ID
     AND G1.ETL_DT = TO_DATE('20250521','YYYYMMDD')
   WHERE A.MERCHD_TYPE_CD = '003' --贵金属
     --AND A.TRAN_CODE = '2301' --消费
     AND A.TRAN_DESCB = '消费' --MOD BY LIP 20251016 商户收单调整
     AND A.SURP_AVAL_AMT != 0
     --AND A.TRAN_STATUS_CD = '001'
     AND A.TRAN_STATUS_CD = '02' --MOD BY LIP 20251016 商户收单调整 02 支付成功（退款成功）
     /*AND A.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')*/
     AND TRUNC(A.TRAN_DT) <= TO_DATE(V_P_DATE,'YYYYMMDD') --MOD BY LIP 20260104 感谢凡哥发现日期带有时间戳
     AND TRUNC(A.TRAN_DT) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入代理代销交易信息表-代理代销保险';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_EAST_AGT_CPTL_DTL NOLOGGING
    (DATA_DT                             --1数据日期
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
    ,TRAN_DT                             --53销售日期 ADD BY LTJ 20250519
    ,TRAN_TM                             --54销售时间 ADD BY LTJ 20250519
    )
    WITH AGT_INSURE_PL AS (
  SELECT DISTINCT A.INSURE_PL_ID,B.CORP_NAME,A.TRAN_STATUS_CD,B.TA_CD
    FROM RRP_MDL.O_IML_AGT_INSURE_PL A --保险单
    LEFT JOIN RRP_MDL.O_IML_REF_INSU_COMP B --保险公司
      ON B.TA_CD = A.TA_CD
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20250227
   /*WHERE A.TRAN_STATUS_CD = '0' --保单状态 正常 CD2173*/
   WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --ADD BY 20250227
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   AGT_INSU_COMP_ACCT_NUM_INFO_H AS (
  SELECT N.ACCT_NAME,N.ACCT_ID,ROW_NUMBER() OVER(PARTITION BY ACCT_NAME ORDER BY ACCT_TYPE_CD) RN
    FROM RRP_MDL.O_IML_AGT_INSU_COMP_ACCT_NUM_INFO_H N --保险公司账号信息历史
   WHERE N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT DISTINCT V_P_DATE                                  AS DATA_DT              --01数据日期
         ,A.LP_ID                                           AS LGL_REP_ID           --02法人编号
         ,NVL(B.ORG_ID1,'800')                              AS ORG_ID               --03机构编号
         ,NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID)          AS CUST_ID              --04客户统一编号 MODIFY BY TANGAN AT 20221223
         ,NVL(D.CUST_NAME,E.CUST_NAME)                      AS CUST_NM              --05客户名称
         ,A.BANK_ACCT_ID                                    AS CUST_ACC             --06客户账号
         ,G.ORG_NAME                                        AS OPEN_BANK_NM         --07开户行名称
         ,A.FLOW_NUM                                        AS TRA_ID               --08交易编号
         ,'04'                                              AS AGCY_CONSI_TRA_TYP   --09代理代销交易类型：代理保险
         ,C.PROD_NAME                                       AS CONSI_PROD_NM        --10代销产品名称
         ,'01'                                              AS TRA_DIR              --11交易方向
         ,TO_CHAR(A.POLICY_DT,'YYYYMMDD')                   AS TRA_DT               --12交易日期
         ,A.CURR_CD                                         AS CUR                  --13币种
         ,A.TRAN_AMT                                        AS TRA_AMT              --14交易金额
         ,H.CORP_NAME                                       AS ISU_ORG_NM           --15发行机构名称
         ,NULL                                              AS ISU_ORG_RTG          --16发行机构评级
         ,NULL                                              AS ISU_ORG_RTG_ORG_NM   --17发行机构评级机构
         ,NVL(N.ACCT_ID,NN.ACCT_ID)                         AS ISU_ORG_LIQ_ACC      --18发行机构清算账号
         ,O.ORG_NAME                                        AS ISU_ORG_LIQ_BANK_NM  --19发行机构清算行名
         ,NULL                                              AS FIN_PSN_NM           --20融资人名称
         ,NULL                                              AS FIN_PSN_BLNG_IDY     --21融资人所属行业
         ,A.CURR_CD                                         AS COMM_CUR             --22手续费币种
         ,A.COMM_FEE                                        AS COMM_AMT             --23手续费金额
         ,'2'                                               AS CASH_TRF_FLG         --24现转标志
         ,A.CUST_MGR_ID                                     AS HDLR_NO              --25经办人工号
         ,'800957'                                          AS DEPT_LINE            --26部门条线/*财富管理部 */
         ,'代理代销保险'                                    AS DATA_SRC              --27数据来源
         ,A.TRAN_AMT                                        AS CURR_AMT              --28当前余额
         ,A.STD_PROD_ID                                     AS PROD_ID               --29标准产品编号
         ,C.PROD_ATTR_CD                                    AS PROD_ATTR_CD          --30产品属性代码
         ,A.TRAN_CD                                         AS TRAN_CD               --31交易代码
         ,DECODE(K.FIELD_VALUE,'1','货币型','2','债券型','3','股票型','4','FOF型','5','非标类','6','混合类',K.FIELD_VALUE) AS HX_TYPEDETAIL --32代销细分类型
         ,M.TA_CD||M.TA_CFM_FLOW_NUM                        AS FLOW_NUM              --33流水号
         ,A.TRAN_STATUS_CD                                  AS TRAN_STATUS_CD        --34交易状态代码
         ,TO_CHAR(M.TA_CFM_DT,'YYYYMMDD')                   AS CFM_DT                --35确认日期
         ,C.RISK_LEVEL_CD                                   AS RISK_LEVEL_CD         --36风险等级代码
         ,M.TRAN_AGENT_FEE                                  AS AGENCY_FEE            --37代理费
         ,T.NV                                              AS NV                    --38净值
         ,T.TOT_LOT                                         AS TOT_LOT               --39总份额
         ,TO_CHAR(C.END_DT,'YYYYMMDD')                      AS END_DT                --40产品到期日
         ,A.TRAN_CHN_CD                                     AS TRAN_CHN_CD           --41交易渠道
         ,A.COMM_FEE                                        AS COMM_FEE              --42手续费
         ,C.INSURE_PROD_PROJ_TYPE_CD                        AS INSURE_PROD_PROJ_TYPE_CD --43产品子类型
         ,C.CTRL_FLG_INFO                                   AS CTRL_FLG_INFO         --44控制标志信息
         ,C.CONSMT_BUS_TYPE_CD                              AS CONSMT_BUS_TYPE_CD    --45代销业务类别
         ,C.TA_CD                                           AS TA_CD                 --46TA代码
         ,NULL                                              AS FIELD_VALUE           --47参数值
         ,C.MGER_NAME                                       AS MGER_NAME             --48管理人名称
         ,A.INSURE_PL_NUM                                   AS INSURE_PL_NUM         --49保险单号 add by hulj 20221128
         ,TO_CHAR(A.POLICY_DT,'YYYYMMDD')                   AS POLICY_DT             --50保单日期 add by hulj 20221128
         ,H.TRAN_STATUS_CD                                  AS TRAN_STATUS_INSUR_CD  --51保单状态 add by hulj 20221128
         ,CASE WHEN (A.TRAN_STATUS_CD = 'S' AND H.TRAN_STATUS_CD = '0')
                     OR (A.TRAN_STATUS_CD = '3' AND H.TRAN_STATUS_CD = '1')
               THEN 'Y'
               ELSE 'N'
           END                                              AS MON_FLG               --月口径标识
         ,M.TRAN_HAPP_DT                                    AS TRAN_DT               --销售日期 ADD BY LTJ 20250519
         ,M.TRAN_HAPP_TM                                    AS TRAN_TM               --销售时间 ADD BY LTJ 20250519
    FROM RRP_MDL.O_IML_EVT_INSURE_TRAN_FLOW A --保险交易流水
   INNER JOIN AGT_INSURE_PL H
      ON H.INSURE_PL_ID = A.INSURE_PL_NUM
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = A.TRAN_ORG_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO C --代理代销产品信息
      ON C.PROD_ID = A.PROD_ID
     AND C.TA_CD = A.TA_CD
     AND C.CONSMT_BUS_TYPE_CD = '02'
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO F --存款主账户信息
      ON F.CUST_ACCT_ID = A.BANK_ACCT_ID --用折号关联
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO F1 --存款主账户信息 --MODIFY BY TANGAN AT 20221107 新一代里面，账号和卡号是分开的，以前CUST_ACCT_ID是优先取卡再取折，现在拆成了CUST_ACCT_ID和CUST_ACCT_CARD_NO，有卡有折的话，CUST_ACCT_ID放的是折号、CUST_ACCT_CARD_NO放的是卡号
      ON F1.CUST_ACCT_CARD_NO = A.BANK_ACCT_ID --用卡号关联
     AND F1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = NVL(NVL(F1.CUST_ID,F.CUST_ID),A.CUST_ID)
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO G --内部机构信息表
      ON G.ORG_ID = NVL(F1.OPEN_ACCT_ORG_ID,F.OPEN_ACCT_ORG_ID)
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_NFSS_TCS_TBPRDPARAMVALUE K --资管信托产品参数值表
      ON K.PRD_CODE = A.PROD_ID
     AND K.FIELD_CODE = 'hx_typedetail'
     AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT * FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TRIM(RELA_FLOW_NUM) IS NOT NULL) M
      ON M.RELA_FLOW_NUM = A.RELA_FLOW_NUM
    /*LEFT JOIN RRP_MDL.O_IML_AGT_INSU_COMP_ACCT_NUM_INFO_H N --保险公司账号信息历史
      ON N.ACCT_NAME = H.CORP_NAME
     AND N.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND N.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*//*调整发行机构清算账号取数口径MDY 20220708 LHQ*/
    LEFT JOIN AGT_INSU_COMP_ACCT_NUM_INFO_H N --MOD BY LIP 20251202
      ON N.ACCT_NAME = H.CORP_NAME
     AND N.RN = 1
    LEFT JOIN RRP_MDL.O_IML_AGT_INSU_COMP_ACCT_NUM_INFO_H NN --保险公司账号信息历史--MOD BY LIP 20220915
      ON NN.INSU_COMP_ID = H.TA_CD
     AND NN.ACCT_TYPE_CD = '2'
     AND NN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND NN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO L --存款主账户信息
      ON L.CUST_ACCT_ID = NVL(N.ACCT_ID,NN.ACCT_ID)
     AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT LL
      ON LL.MAIN_ACCT_ID = NVL(N.ACCT_ID,NN.ACCT_ID)
     AND LL.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO O --内部机构信息表
      ON O.ORG_ID = NVL(L.OPEN_ACCT_ORG_ID,LL.BELONG_ORG_ID)
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT PROD_ID,NV,SUM(TOT_LOT)TOT_LOT
                 FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO
                WHERE CONSMT_BUS_TYPE_CD = '04'
                  AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY PROD_ID,NV) T --代销产品份额信息
      ON T.PROD_ID = A.PROD_ID
   WHERE ((A.TRAN_STATUS_CD = 'S' AND H.TRAN_STATUS_CD = '0')
         OR (A.TRAN_STATUS_CD = '3' AND H.TRAN_STATUS_CD = '1')) --MODIFY BY MW 20221116 交易状态为CD1048 S成功,保单状态CD2173 0正常;或者:交易状态3已退保,保单状态1非犹豫期退保
     --AND A.TRAN_DT < TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20241114 增加债券承销数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入代理代销交易信息表-债券承销';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.M_EAST_AGT_CPTL_DTL NOLOGGING
    (DATA_DT                             --1数据日期
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
  WITH TBS_VS_ISSUER AS (
  SELECT T.ISSUER_NAME_ZH,T.ISSUER_ID,TA.FIRM_ID,TA.RATING,TA.RATING_DATE,TB.FIRM_NAME_ZH,
         TC.LABEL,TD.INDUS_TYPE_CD,
         ROW_NUMBER() OVER(PARTITION BY T.ISSUER_NAME_ZH ORDER BY TA.RATING_DATE DESC) RN
    FROM RRP_MDL.O_IOL_CTMS_TBS_VS_ISSUER T
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_ISSUER_RATING TA
      ON TA.ISSUER_ID = T.ISSUER_ID
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_RATING_FIRM TB
      ON TB.FIRM_ID = TA.FIRM_ID
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS TC
      ON TC.REF_ISSUER_ID = T.ISSUER_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO TD
      ON TD.CUST_ID = TC.LABEL
     AND TD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  FXJGZH AS ( --MOD BY LIP 20241125 调整发行机构清算账号的取数方式
  SELECT T1.SECURITY_TRADE_NO, --用于与BONDSDEALS关联
         TRIM(T4.CASH_ACC_NO) CASH_ACC_NO, --取买入时的账号当做发行机构清算账号
         TRIM(T4.CASH_ACC_BANK) CASH_ACC_BANK
    FROM RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE T1 --表里每一条记录，都有一个SECURITY_TRADE_NO，跟V_BONDSDEALS的SERIAL_NUMBER是对应的
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE T2 --用买入流水关联
      ON T2.SERIAL_NUMBER = TRIM(T1.UW_BUY_NO)
     AND T2.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T3
      ON T3.SERIAL_NUMBER = T2.SECURITY_TRADE_NO
    LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T4
      ON T4.SERIAL_NUMBER = T3.SERIAL_NUMBER
     AND T4.BS <> T3.BUYORSELL
   WHERE TRIM(T1.UW_BUY_NO) IS NOT NULL
     AND T1.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')),
  CLEAK_INFO AS (
  SELECT CLERK_ID,CLERK_NAME,
         ROW_NUMBER() OVER(PARTITION BY CLERK_NAME ORDER BY EMPYT_DT DESC,EMPLY_STATUS_CD) RN --CD1596
    FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                           AS DATA_DT               --1数据日期
        ,'9999'                                             AS LGL_REP_ID            --2法人编号
        ,M.DEPARTMENTID                                     AS ORG_ID                --3机构编号
        --,TRIM(T7.LABEL)                                     AS CUST_ID               --4客户统一编号
        --MOD BY LIP 20250715 SPV客户号转换成ECIF客户号
        ,COALESCE(TRIM(T9.PARTY_ID),TRIM(T7.LABEL))         AS CUST_ID               --4客户统一编号
        ,CASE WHEN REGEXP_REPLACE(TRIM(T7.CPTYS_NAME),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
              THEN REPLACE(REPLACE(REPLACE(TRIM(T7.CPTYS_NAME),'(','（'),')','）'),' ','')
              ELSE TRIM(T7.CPTYS_NAME)
          END                                               AS CUST_NM               --5客户名称
        ,TRIM(T6.CASH_ACC_NO)                               AS CUST_ACC              --6客户账号
        ,TRIM(T6.CASH_ACC_BANK)                             AS OPEN_BANK_NM          --7开户行名称
        ,T1.REF_NUMBER                                      AS TRA_ID                --8交易编号
        ,'01'                                               AS AGCY_CONSI_TRA_TYP    --9代理代销交易类型 --T0031 债券承销
        ,T1.BONDSNAME                                       AS CONSI_PROD_NM         --10代销产品名称
        ,DECODE(T1.BUYORSELL,'B','02','01')                 AS TRA_DIR               --11交易方向 --D0133
        ,TRIM(T1.SETTLEDATE)                                AS TRA_DT                --12交易日期
        ,TRIM(T4.CCY)                                       AS CUR                   --13币种
        ,T1.SETTLEAMOUNT                                    AS TRA_AMT               --14交易金额
        ,CASE WHEN REGEXP_REPLACE(TRIM(T4.ISSUER),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
              THEN REPLACE(REPLACE(REPLACE(TRIM(T4.ISSUER),'(','（'),')','）'),' ','')
              ELSE TRIM(T4.ISSUER)
          END                                               AS ISU_ORG_NM            --15发行机构名称
        ,TRIM(T11.RATING)                                   AS ISU_ORG_RTG           --16发行机构评级
        ,CASE WHEN REGEXP_REPLACE(TRIM(T11.FIRM_NAME_ZH),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
              THEN REPLACE(REPLACE(REPLACE(TRIM(T11.FIRM_NAME_ZH),'(','（'),')','）'),' ','')
              ELSE TRIM(T11.FIRM_NAME_ZH)
          END                                               AS ISU_ORG_RTG_ORG_NM    --17发行机构评级机构
        ,TRIM(T12.CASH_ACC_NO)                              AS ISU_ORG_LIQ_ACC       --18发行机构清算账号
        ,TRIM(T12.CASH_ACC_BANK)                            AS ISU_ORG_LIQ_BANK_NM   --19发行机构清算行名
        ,CASE WHEN REGEXP_REPLACE(TRIM(T4.ISSUER),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
              THEN REPLACE(REPLACE(REPLACE(TRIM(T4.ISSUER),'(','（'),')','）'),' ','')
              ELSE TRIM(T4.ISSUER)
          END                                               AS FIN_PSN_NM            --20融资人名称
        ,TRIM(T11.INDUS_TYPE_CD)                            AS FIN_PSN_BLNG_IDY      --21融资人所属行业
        ,TRIM(T4.CCY)                                       AS COMM_CUR              --22手续费币种
        ,T1.FEEAMOUNT                                       AS COMM_AMT              --23手续费金额
        ,'2'                                                AS CASH_TRF_FLG          --24现转标志 --Z0019
        ,T13.CLERK_ID                                       AS HDLR_NO               --25经办人工号
        ,'000'                                              AS DEPT_LINE             --26部门条线
        ,'债券承销'                                         AS DATA_SRC              --27数据来源
        ,T1.SETTLEAMOUNT                                    AS CURR_AMT              --28当前余额
        ,NULL                                               AS PROD_ID               --29标准产品编号
        ,NULL                                               AS PROD_ATTR_CD          --30产品属性代码
        ,NULL                                               AS TRAN_CD               --31交易代码
        ,'债券型'                                           AS HX_TYPEDETAIL         --32代销细分类型
        ,T1.REF_NUMBER                                      AS FLOW_NUM              --33流水号
        ,NULL                                               AS TRAN_STATUS_CD        --34交易状态代码
        ,TRIM(T1.SETTLEDATE)                                AS CFM_DT                --35确认日期
        ,NULL                                               AS RISK_LEVEL_CD         --36风险等级代码
        ,NULL                                               AS AGENCY_FEE            --37代理费
        ,NULL                                               AS NV                    --38净值
        ,NULL                                               AS TOT_LOT               --39总份额
        ,NULL                                               AS END_DT                --40产品到期日
        ,NULL                                               AS TRAN_CHN_CD           --41交易渠道
        ,T1.FEEAMOUNT                                       AS COMM_FEE              --42手续费
        ,NULL                                               AS INSURE_PROD_PROJ_TYPE_CD --43产品子类型
        ,NULL                                               AS CTRL_FLG_INFO         --44控制标志信息
        ,'01'                                               AS CONSMT_BUS_TYPE_CD    --45代销业务类别
        ,NULL                                               AS TA_CD                 --46TA代码
        ,NULL                                               AS FIELD_VALUE           --47参数值
        ,NULL                                               AS MGER_NAME             --48管理人名称
        ,NULL                                               AS INSURE_PL_NUM         --49保险单号
        ,NULL                                               AS POLICY_DT             --50保单日期
        ,NULL                                               AS TRAN_STATUS_INSUR_CD  --51保单状态
        ,'Y'                                                AS MON_FLG               --52月口径标识
    FROM RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T1
   INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_ADDONPORTFOLIO T2
      ON T2.PORTFOLIO_ID = T1.PORTFOLIO_ID
   INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T3
      ON T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
   INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
      ON M.KEEPFOLDER_ID = T3.KEEPFOLDER_ID
   INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T4
      ON T4.SECURITY_CODE = T1.BONDSCODE
    LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T6
      ON T6.SERIAL_NUMBER = T1.SERIAL_NUMBER
     AND T6.BS <> T1.BUYORSELL
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T7
      ON T7.KEY_SRC = T1.CPTYS_ID
    LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T8
      ON T8.SECURITY_CODE = T1.BONDSCODE
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO T9 --MOD BY LIP 20250715 SPV客户号转换成ECIF客户号
      ON T9.SPV_CUST_ID = TRIM(T7.LABEL)
     AND T9.ID_MARK <> 'D'
     AND T9.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T9.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TBS_VS_ISSUER T11
      ON T11.ISSUER_NAME_ZH = T4.ISSUER
     AND T11.RN = 1
    LEFT JOIN FXJGZH T12
      ON T12.SECURITY_TRADE_NO = T1.SERIAL_NUMBER
    LEFT JOIN CLEAK_INFO T13
      ON T13.CLERK_NAME = NVL(SUBSTR(T1.DN_DEALER,1,INSTR(T1.DN_DEALER,'(') -1),T1.DN_DEALER)
     AND T13.RN = 1
   WHERE SUBSTR(T1.SERIAL_NUMBER,0,2) = 'BO'
     AND T1.SOURCE IN ('I','J')
     AND T1.BUYORSELL <> 'B'
     AND T1.SETTLEDATE >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
     AND T1.SETTLEDATE <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --增加数据重复校验 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据重复校验';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,TRA_ID,CUST_ID,COUNT(1)
    FROM RRP_MDL.M_EAST_AGT_CPTL_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_ID,CUST_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
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

END ETL_M_EAST_AGT_CPTL_DTL;
/

