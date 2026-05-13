CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_OTH_SHRH_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_OTH_SHRH_INFO
  *  功能描述：监管集市银行股东及银行关联方相关信息
  *  创建日期：20220525
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_RELA_PARTY_BASIC_INFO --关联方基本信息
  *            IOL.NOAS_OA_STOCKHOLDER_INFO  --股东信息表
  *            IOL.NOAS_OA_STOCK_FINANCE     --股东财务表
  *  目标表：  M_OTH_SHRH_INFO  --股东及关联方信息表
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114   HULJ    增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20240624  LIP      调整股东部分证件类型映射。
  *             4    20250319  LAL      一表通，增加当事人持股比例的取数逻辑。
  *             5    20250820  LAL      一表通，补充受益人、持股标志的取数逻辑。
  *             6    20250903  LIP      增加股东及关联方的编号字段
  *             7    20251014  LAL      增加撤股日期字段，补充资产负债率、净利润的取值逻辑
  *             8    20251027  LIP      修改关联方不良信息的取值逻辑
  *             9    20251029  LAL      一表通，增加股东及关联方类型_一表通字段及取值逻辑
  *             10   20260414  LAL      一表通，增加过滤条件，只取关联方本身有效的数据
  ***************************************************************************/
AS
  --定义变量
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_PART_NAME VARCHAR2(100);              --分区名
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_OTH_SHRH_INFO'; --程序名称
  V_TAB_NAME  VARCHAR2(100):= 'M_OTH_SHRH_INFO'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME); --分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := 2;
  V_STEP_DESC := '股东及关联方信息表-关联方信息';
  V_STARTTIME := SYSDATE;
  /***************************OA系统--关联方信息******************************/
  INSERT INTO RRP_MDL.M_OTH_SHRH_INFO
    (DATA_DT                 --数据日期
    ,LGL_REP_ID              --法人编号
    ,CUST_ID                 --客户编号
    ,ORG_ID                  --机构编号
    ,SHRH_AF_PARTY_STAT      --股东或关联方状态
    ,SHRH_AF_PARTY_NM        --股东或关联方名称
    ,SHRH_AF_PARTY_TYP       --股东或关联方类型
    ,SHRH_AF_PARTY_CRDL_TYP  --股东或关联方证件类型
    ,SHRH_AF_PARTY_CRDL_NO   --股东或关联方证件号码
    ,SHRH_CRDL_TYP           --股东证件类型
    ,SHRH_CRDL_NO            --股东证件号码
    ,CTRY_CD                 --国家代码
    ,HOLD_SHR_PCT            --持股比例
    ,SHR_IN_DT               --入股日期
    ,ALDY_PLG_HOLD_SHR_PCT   --已质押持股比例
    ,HLDG_SHRH_FLG           --控股股东标志
    ,HOLD_SHR_NUM            --持股数量
    ,LAST_CHG_DT             --上次变动日期
    ,SHRH_AF_PARTY_BLNG_IDY  --股东或关联方所属行业
    ,SHRH_AF_PARTY_REGD_LAND --股东或关联方注册地
    ,REL_TYP                 --关系类型
    ,ACT_CNTLR               --实际控制人
    ,BANK_ATND_SHR_NUM       --参股商业银行的数量
    ,BANK_HLDG_SHR_NUM       --控股商业银行的数量
    ,BAD_INFO                --不良信息
    ,LIMIT_WGHT_FLG          --限权标志
    ,SHR_IN_CPTL_SRC         --入股资金来源
    ,SHR_IN_CPTL_ACC         --入股资金账号
    ,STN_DIR_FLG             --驻派董监事标志
    ,SHRH_TYP                --股东类型
    ,OWNERSHIP_CHAR          --所有制性质
    ,AST_LBY_RTO             --资产负债率
    ,NET_PROFIT              --净利润
    ,MRG_HOLD_SHR_PCT        --实际控制人及其一致行动人合并持股比例
    ,ACT_CNTLR_MGT_ORG       --实际控制人管理机构
    ,PAR_CO_CTRY_CD          --母公司所在国家代码
    ,OV_SEA_IVS_FLG          --境外投资者标志
    ,INTR_FN_CPTL_BAL        --引进外资余额
    ,FN_SHRH_YEAR_RSRV_PFT   --外方股东当年留存收益
    ,FN_CPTL_CHG_SIT         --报告期内利用外资金额变化情况
    ,CHG_DT                  --变化日期
    ,CHG_MODE                --变化方式
    ,ACT_CHG_AMT             --实际变化金额
    ,ENT_HLDG_TYP            --企业控股类型
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,PARTY_SHARE_RATIO       --当事人持股比例 --ADD BY LAL 20250319
    ,SHRH_AF_PARTY_ID        --股东或关联方编号 --ADD BY LIP 20250903
    ,SHRH_AF_PARTY_TYP_YBT   --股东或关联方类型_一表通  --ADD BY LAL 20251029
    )
  WITH RELA_PARTY_BASIC_INFO AS (
  SELECT  TA.RELA_PARTY_ID                     AS RELA_PARTY_ID
         ,NVL(TC.CUST_ID,TD.CUST_ID)           AS PARTY_ID
         ,TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1)   AS CERTIFICATE_CODE
         ,NVL(TC.CTY_RG_CD,TD.NATION_CD)       AS NATION_CD
         ,TC.NATNAL_ECON_DEPT_TYPE_CD          AS NATNAL_ECON_DEPT_TYPE_CD
         ,CASE WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_1) IS NOT NULL
               THEN TA.RELA_PARTY_CERT_TYPE_CD_1
               WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_2) IS NOT NULL
               THEN TA.RELA_PARTY_CERT_TYPE_CD_2
               ELSE TA.RELA_PARTY_CERT_TYPE_CD_1
           END                                 AS SHRH_AF_PARTY_CRDL_TYP --股东或关联方证件类型
         ,CASE WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_1) IS NOT NULL
               THEN TRIM(TA.RELA_PARTY_CERT_ID_1)
               WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_2) IS NOT NULL
               THEN TRIM(TA.RELA_PARTY_CERT_ID_2)
               ELSE TRIM(TA.RELA_PARTY_CERT_ID_1)
           END                                AS SHRH_AF_PARTY_CRDL_NO
         ,ROW_NUMBER() OVER(PARTITION BY TA.RELA_PARTY_ID ORDER BY NVL(TC.CUST_ID,TD.CUST_ID)) AS RN
    FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO TA
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TB
      ON TB.CERT_NUM = TRIM(TA.RELA_PARTY_CERT_ID_1)
     AND TB.CERT_TYPE_CD = TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1)
     AND TB.CERT_NUM NOT IN (' ','-','0')
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TE
      ON TE.CERT_NUM = TRIM(TA.RELA_PARTY_CERT_ID_2)
     AND TE.CERT_TYPE_CD = TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2)
     AND TE.CERT_NUM NOT IN (' ','-','0')
     AND TE.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TE.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO TC
      ON TC.CUST_ID = NVL(TB.PARTY_ID,TE.PARTY_ID)
     AND TC.CUST_STATUS_CD NOT IN ('P','2')
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO TD
      ON TD.CUST_ID = NVL(TB.PARTY_ID,TE.PARTY_ID)
     AND TD.CUST_STATUS_CD NOT IN ('P','2')
     AND TD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT DISTINCT
         TO_CHAR(A.ETL_DT, 'YYYYMMDD')                          AS DATA_DT                --数据日期
        ,A.LP_ID                                                AS LGL_REP_ID             --法人编号
        ,B.PARTY_ID                                             AS CUST_ID                --客户编号
        ,A.RELA_PARTY_BELONG_ORG_ID                             AS ORG_ID                 --机构编号
        ,CASE WHEN A.RELA_STATUS_CD = '1' THEN 'Y' ELSE 'N' END AS SHRH_AF_PARTY_STAT     --股东或关联方状态
        ,A.RELA_PARTY_NAME                                      AS SHRH_AF_PARTY_NM       --股东或关联方名称
        ,A.SHARD_OR_RELA_PARTY_TYPE_CD                          AS SHRH_AF_PARTY_TYP      --股东或关联方类型
        ,B.SHRH_AF_PARTY_CRDL_TYP                               AS SHRH_AF_PARTY_CRDL_TYP --股东或关联方证件类型 --取消转码
        ,B.SHRH_AF_PARTY_CRDL_NO                                AS SHRH_AF_PARTY_CRDL_NO  --股东或关联方证件号码
        ,B.SHRH_AF_PARTY_CRDL_TYP                               AS SHRH_CRDL_TYP          --股东或关联方证件类型 --取消转码
        ,B.SHRH_AF_PARTY_CRDL_NO                                AS SHRH_CRDL_NO           --股东证件号码
        ,B.NATION_CD                                            AS CTRY_CD                --国家代码
        ,NULL                                                   AS HOLD_SHR_PCT           --持股比例
        ,NULL                                                   AS SHR_IN_DT              --入股日期
        ,NULL                                                   AS ALDY_PLG_HOLD_SHR_PCT  --已质押持股比例
        ,NULL                                                   AS HLDG_SHRH_FLG          --控股股东标志
        ,NULL                                                   AS HOLD_SHR_NUM           --持股数量
        --最近一次变动日期”这个字段，对标他们系统的“关联关系生效日期”这个字段
        ,CASE WHEN A.RELA_EFFECT_DT NOT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('29991231','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
              THEN TO_CHAR(A.RELA_EFFECT_DT,'YYYYMMDD')
          END                                                   AS LAST_CHG_DT            --上次变动日期
        ,A.SHARD_OR_RELA_PARTY_BL_INDUTY_CD                     AS SHRH_AF_PARTY_BLNG_IDY --股东或关联方所属行业
        ,TRIM(A.SHARD_OR_RELA_PARTY_RGST_ADDR)                  AS SHRH_AF_PARTY_REGD_LAND--股东或关联方注册地
        ,A.SHARD_OR_RELA_PARTY_RELA_TYPE_CD                     AS REL_TYP                --关系类型
        ,NULL                                                   AS ACT_CNTLR              --实际控制人
        ,NULL                                                   AS BANK_ATND_SHR_NUM      --参股商业银行的数量
        ,NULL                                                   AS BANK_HLDG_SHR_NUM      --控股商业银行的数量
        ,DECODE(A.RELA_EAST_NON_INFO,'-',NULL,A.RELA_EAST_NON_INFO) AS BAD_INFO           --不良信息 --MOD BY LIP 20251027 关联方系统增加字段CD3222
        ,NULL                                                   AS LIMIT_WGHT_FLG         --限权标志
        ,NULL                                                   AS SHR_IN_CPTL_SRC        --入股资金来源
        ,NULL                                                   AS SHR_IN_CPTL_ACC        --入股资金账号
        ,NULL                                                   AS STN_DIR_FLG            --驻派董监事标志
        ,NULL                                                   AS SHRH_TYP               --股东类型
        ,NULL                                                   AS OWNERSHIP_CHAR         --所有制性质
        ,NULL                                                   AS AST_LBY_RTO            --资产负债率
        ,NULL                                                   AS NET_PROFIT             --净利润
        ,NULL                                                   AS MRG_HOLD_SHR_PCT       --实际控制人及其一致行动人合并持股比例
        ,NULL                                                   AS ACT_CNTLR_MGT_ORG      --实际控制人管理机构
        ,NULL                                                   AS PAR_CO_CTRY_CD         --母公司所在国家代码
        ,NULL                                                   AS OV_SEA_IVS_FLG         --境外投资者标志
        ,NULL                                                   AS INTR_FN_CPTL_BAL       --引进外资余额
        ,NULL                                                   AS FN_SHRH_YEAR_RSRV_PFT  --外方股东当年留存收益
        ,NULL                                                   AS FN_CPTL_CHG_SIT        --报告期内利用外资金额变化情况
        ,TO_CHAR(A.RELA_INVALID_DT,'YYYYMMDD')                  AS CHG_DT                 --变化日期 --用于存放关系失效日期
        ,NULL                                                   AS CHG_MODE               --变化方式
        ,NULL                                                   AS ACT_CHG_AMT            --实际变化金额
        ,TA.TAR_VALUE_CODE                                      AS ENT_HLDG_TYP           --企业控股类型
        ,'800906'                                               AS DEPT_LINE              --部门条线/*董事会办公室*/
        ,'关联方'                                               AS DATA_SRC               --数据来源
        ,A.PARTY_SHARE_RATIO                                    AS PARTY_SHARE_RATIO      --当事人持股比例  --ADD 20250319 LINAILIAN
        ,TRIM(A.RELA_PARTY_ID)                                  AS SHRH_AF_PARTY_ID       --股东或关联方编号 --ADD BY LIP 20250903
        ,A.RELA_EAST_ECON_TYPE_CD                               AS SHRH_AF_PARTY_TYP_YBT   --股东或关联方类型_一表通  --ADD BY LAL 20251029 CD3223
    FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO A --关联方基本信息
    LEFT JOIN RELA_PARTY_BASIC_INFO B
      ON B.RELA_PARTY_ID = A.RELA_PARTY_ID
     AND B.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
      ON C.CUST_ID = B.PARTY_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --企业控股类型转码
      ON TA.SRC_VALUE_CODE = C.HOLD_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1417'
     AND TA.TAR_CLASS_CODE = 'C0004'
     AND TA.MOD_FLG = 'MDM'
   WHERE A.RELA_PARTY_STATUS_CD = '1' --ADD BY LAL 20260414 只取关联方本身有效的数据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --记录正常日志
  V_STEP := 3;
  V_STEP_DESC := '股东及关联方信息表';
  V_STARTTIME := SYSDATE;
  /***************************OA系统--股东信息******************************/
  INSERT INTO RRP_MDL.M_OTH_SHRH_INFO
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,CUST_ID                         --客户编号
    ,ORG_ID                          --机构编号
    ,SHRH_AF_PARTY_STAT              --股东或关联方状态
    ,SHRH_AF_PARTY_NM                --股东或关联方名称
    ,SHRH_AF_PARTY_TYP               --股东或关联方类型
    ,SHRH_AF_PARTY_CRDL_TYP          --股东或关联方证件类型
    ,SHRH_AF_PARTY_CRDL_NO           --股东或关联方证件号码
    ,SHRH_CRDL_TYP                   --股东证件类型
    ,SHRH_CRDL_NO                    --股东证件号码
    ,CTRY_CD                         --国家代码
    ,HOLD_SHR_PCT                    --持股比例
    ,SHR_IN_DT                       --入股日期
    ,ALDY_PLG_HOLD_SHR_PCT           --已质押持股比例
    ,HLDG_SHRH_FLG                   --控股股东标志
    ,HOLD_SHR_NUM                    --持股数量
    ,LAST_CHG_DT                     --上次变动日期
    ,SHRH_AF_PARTY_BLNG_IDY          --股东或关联方所属行业
    ,SHRH_AF_PARTY_REGD_LAND         --股东或关联方注册地
    ,REL_TYP                         --关系类型
    ,ACT_CNTLR                       --实际控制人
    ,BANK_ATND_SHR_NUM               --参股商业银行的数量
    ,BANK_HLDG_SHR_NUM               --控股商业银行的数量
    ,BAD_INFO                        --不良信息
    ,LIMIT_WGHT_FLG                  --限权标志
    ,SHR_IN_CPTL_SRC                 --入股资金来源
    ,SHR_IN_CPTL_ACC                 --入股资金账号
    ,STN_DIR_FLG                     --驻派董监事标志
    ,SHRH_TYP                        --股东类型
    ,OWNERSHIP_CHAR                  --所有制性质
    ,AST_LBY_RTO                     --资产负债率
    ,NET_PROFIT                      --净利润
    ,MRG_HOLD_SHR_PCT                --实际控制人及其一致行动人合并持股比例
    ,ACT_CNTLR_MGT_ORG               --实际控制人管理机构
    ,PAR_CO_CTRY_CD                  --母公司所在国家代码
    ,OV_SEA_IVS_FLG                  --境外投资者标志
    ,INTR_FN_CPTL_BAL                --引进外资余额
    ,FN_SHRH_YEAR_RSRV_PFT           --外方股东当年留存收益
    ,FN_CPTL_CHG_SIT                 --报告期内利用外资金额变化情况
    ,CHG_DT                          --变化日期
    ,CHG_MODE                        --变化方式
    ,ACT_CHG_AMT                     --实际变化金额
    ,ENT_HLDG_TYP                    --企业控股类型
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,FNL_BNF                         --最终受益人 ADD BY LAL 20250820 一表通，补充受益人取值
    ,EAST_REMARK                     --EAST备注 --ADD BY 20240403
    ,SHRH_AF_PARTY_ID                --股东或关联方编号 --ADD BY LIP 20250903
    ,SHR_OUT_DT                      --撤股日期 --ADD BY LAL 20251014
    )
    WITH TMP1 AS (
  SELECT TA.STOCK_INFO_ID,TA.STOCKHOLDER_ID,TB.PARTY_ID,TRIM(TA.CERTIFICATE_CODE) CERTIFICATE_CODE,
         ROW_NUMBER() OVER(PARTITION BY TA.STOCK_INFO_ID ORDER BY REPLACE(NVL(TD.CUST_STATUS_CD,TC.CUST_STATUS_CD),'-','Z'),
                           LENGTH(TB.PARTY_ID)) RN
    FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO TA
   INNER JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TB
      ON TB.CERT_NUM = TRIM(TA.CERTIFICATE_CODE)
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO TC
      ON TC.CUST_ID = TB.PARTY_ID
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO TD
      ON TD.CUST_ID = TB.PARTY_ID
     AND TD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(TA.CERTIFICATE_CODE) IS NOT NULL
     AND NVL(TC.CUST_ID,TD.CUST_ID) IS NOT NULL
     AND TRIM(TA.CERTIFICATE_CODE) NOT IN ('0','-') --MOD BY 20240402 证件号为0的不匹配客户号
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
  TOTALSTOCKAMOUNT AS (
  SELECT SUM(STOCK_OWN_AMOUNT) AS TOTALSTOCKAMOUNT
    FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO
   WHERE STATUS = '1'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   --ADD BY LAL 20251014
   STOCK_FINANCE AS (
   SELECT STOCK_INFO_ID,A_PARTICULAR_YEAR,RETAINED_PROFITS,RATIO_OF_LIABILITIES
     FROM (SELECT A.*
                 ,ROW_NUMBER() OVER (PARTITION BY STOCK_INFO_ID ORDER BY A_PARTICULAR_YEAR DESC) AS RN
             FROM RRP_MDL.O_IOL_NOAS_OA_STOCK_FINANCE A
            WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              AND A_PARTICULAR_YEAR < SUBSTR(TO_CHAR(SYSDATE,'YYYYMMDD'),1,4))
    WHERE RN =1)
  SELECT V_P_DATE                                               AS DATA_DT                --数据日期
        ,'9999'                                                 AS LGL_REP_ID             --法人编号
        ,T3.PARTY_ID                                            AS CUST_ID                --客户编号
        ,'800'                                                  AS ORG_ID                 --机构编号
        ,T1.STATUS                                              AS SHRH_AF_PARTY_STAT     --股东或关联方状态
        ,T1.STOCKHOLDER_NAME                                    AS SHRH_AF_PARTY_NM       --股东或关联方名称
        --,T1.EAST_STOCKHOLDER_TYPE                               AS SHRH_AF_PARTY_TYP      --股东或关联方类型
        --MOD BY LIP 20251224 因OA系统将5变更成国务院国资委监管的国有控股企业，所以将该码值调整成17
        ,DECODE(T1.EAST_STOCKHOLDER_TYPE,'5','17',T1.EAST_STOCKHOLDER_TYPE) AS SHRH_AF_PARTY_TYP      --股东或关联方类型
        ,CASE WHEN T1.EAST_STOCKHOLDER_TYPE NOT IN ('0','1') AND T1.STOCKHOLDER_CERTIFICATE_TYPE = '19'
              THEN '2999' --如果关联方类型不是个人，则映射为“其他-其他组织证件”
              WHEN T1.EAST_STOCKHOLDER_TYPE NOT IN ('0','1') AND TB.TAR_VALUE_CODE = '1999'
              THEN '2999' --如果关联方类型不是个人，则映射为“其他-其他组织证件”
              ELSE NVL(TB.TAR_VALUE_CODE,T1.STOCKHOLDER_CERTIFICATE_TYPE)
          END                                                   AS SHRH_AF_PARTY_CRDL_TYP --股东或关联方证件类型 --MOD BY LIP 20240624
        ,NVL(TRIM(T1.CERTIFICATE_CODE),'1')                     AS SHRH_AF_PARTY_CRDL_NO  --股东或关联方证件号码--MODIFY BY CAIZHENGWEI 20220514加TRIM
        ,T1.STOCKHOLDER_CERTIFICATE_TYPE                        AS SHRH_CRDL_TYP          --股东证件类型 /*'2X'*/
        ,NVL(TRIM(T1.CERTIFICATE_CODE),'1')                     AS SHRH_CRDL_NO           --股东证件号码--MODIFY BY CAIZHENGWEI 20220514加TRIM
        ,NULL                                                   AS CTRY_CD                --国家代码
        ,CASE WHEN NVL(T2.TOTALSTOCKAMOUNT,0) = 0 THEN 0
              ELSE T1.STOCK_OWN_AMOUNT / 8000000000 * 100
          END                                                   AS HOLD_SHR_PCT           --持股比例
        --MODIFY 20230222 LHQ 根据林伟安口径调整，分母已80亿为准
        ,CASE WHEN TO_CHAR(T1.STOCKHOLDER_BEGIN_DATE,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(T1.STOCKHOLDER_BEGIN_DATE,'YYYYMMDD')
          END                                                   AS SHR_IN_DT              --入股日期
        ,TO_NUMBER(TRIM(T1.PLEDGE_PROPORTION))                  AS ALDY_PLG_HOLD_SHR_PCT  --已质押持股比例  MODIFY 20230222 LHQ 根据林伟安口径调整，改为直取
        /*,NULL                                                   AS HLDG_SHRH_FLG          --控股股东标志*/
        ,T1.DOMINANT_STOCKHOLDER                                AS HLDG_SHRH_FLG          --控股股东标志 MOD BY LAL 20250820 一表通，补充取值
        ,T1.STOCK_OWN_AMOUNT                                    AS HOLD_SHR_NUM           --持股数量
        ,CASE WHEN TO_CHAR(T1.LAST_TIME_CHANGE_DATE,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(T1.LAST_TIME_CHANGE_DATE,'YYYYMMDD')
          END                                                   AS LAST_CHG_DT            --上次变动日期
        ,T1.NATIONAL_ECONOMY_CODE                               AS SHRH_AF_PARTY_BLNG_IDY --股东或关联方所属行业
        ,T1.STOCKHOLDER_REGISTRATION_PLACE                      AS SHRH_AF_PARTY_REGD_LAND--股东或关联方注册地
        ,'1'                                                    AS REL_TYP                --关系类型--1股东
        ,TRIM(T1.ACTUAL_CONTROLLER)                             AS ACT_CNTLR              --实际控制人
        ,T1.STOCKHOLDER_SHARE_BANK_AMOUNT                       AS BANK_ATND_SHR_NUM      --参股商业银行的数量
        ,T1.STOCKHOLDER_HOLD_BANK_AMOUNT                        AS BANK_HLDG_SHR_NUM      --控股商业银行的数量
        ,TRIM(T1.BAD_INFORMATION)                               AS BAD_INFO               --不良信息
        ,T1.IS_POWER_RESTRAINT                                  AS LIMIT_WGHT_FLG         --限权标志
        ,T1.CAPITAL_SOURCE                                      AS SHR_IN_CPTL_SRC        --入股资金来源
        ,T1.FUND_ACCOUNT                                        AS SHR_IN_CPTL_ACC        --入股资金账号
        ,T1.INDIRECTOR                                          AS STN_DIR_FLG            --驻派董监事标志
        ,NULL                                                   AS SHRH_TYP               --股东类型
        ,NULL                                                   AS OWNERSHIP_CHAR         --所有制性质
      /*,NULL                                                   AS AST_LBY_RTO            --资产负债率
        ,NULL                                                   AS NET_PROFIT             --净利润*/
        ,/*T5.RATIO_OF_LIABILITIES*/ TO_NUMBER(REPLACE(T5.RATIO_OF_LIABILITIES,'%'))  AS AST_LBY_RTO     --资产负债率 MOD BY LAL 20251014
        ,T5.RETAINED_PROFITS                                    AS NET_PROFIT             --净利润     MOD BY LAL 20251014
        ,NULL                                                   AS MRG_HOLD_SHR_PCT       --实际控制人及其一致行动人合并持股比例
        ,NULL                                                   AS ACT_CNTLR_MGT_ORG      --实际控制人管理机构
        ,NULL                                                   AS PAR_CO_CTRY_CD         --母公司所在国家代码
        ,NULL                                                   AS OV_SEA_IVS_FLG         --境外投资者标志
        ,NULL                                                   AS INTR_FN_CPTL_BAL       --引进外资余额
        ,NULL                                                   AS FN_SHRH_YEAR_RSRV_PFT  --外方股东当年留存收益
        ,NULL                                                   AS FN_CPTL_CHG_SIT        --报告期内利用外资金额变化情况
        ,NULL                                                   AS CHG_DT                 --变化日期
        ,NULL                                                   AS CHG_MODE               --变化方式
        ,NULL                                                   AS ACT_CHG_AMT            --实际变化金额
        ,TA.TAR_VALUE_CODE                                      AS ENT_HLDG_TYP           --企业控股类型
        ,'800906'                                               AS DEPT_LINE              --部门条线/*董事会办公室*/
        ,'OA系统'                                               AS DATA_SRC               --数据来源
        ,T1.FINAL_BENEFICIARY                                   AS FNL_BNF                --数据来源 ADD BY LAL 20250820 一表通，补充受益人取值
        ,TRIM(REPLACE(REPLACE(T1.EAST_REMARK,CHR(10),''),CHR(13),'')) AS EAST_REMARK      --EAST备注 --ADD BY 20240403
        ,TRIM(T1.STOCKHOLDER_ID)                                AS SHRH_AF_PARTY_ID       --股东或关联方编号 --ADD BY LIP 20250903
        ,TO_CHAR(T1.STOCKHOLDER_END_DATE,'YYYYMMDD')            AS SHR_OUT_DT             --撤股日期 --ADD BY LAL 20251014
    FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO T1 --股东信息表
    LEFT JOIN TOTALSTOCKAMOUNT T2
      ON 1 = 1
    LEFT JOIN TMP1 T3 --获取股东的客户号
      ON T3.STOCK_INFO_ID = T1.STOCK_INFO_ID
     AND T3.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T4 --对公客户基本信息
      ON T4.CUST_ID = T3.PARTY_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN STOCK_FINANCE                          T5 --股东财务表
      ON T5.STOCK_INFO_ID = T1.STOCK_INFO_ID
    LEFT JOIN RRP_MDL.CODE_MAP TA --企业控股类型转码
      ON TA.SRC_VALUE_CODE = T4.HOLD_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1417'
     AND TA.TAR_CLASS_CODE = 'C0004'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --股东及关联方证件类型转码
      ON TB.SRC_VALUE_CODE = T1.STOCKHOLDER_CERTIFICATE_TYPE
     AND TB.SRC_CLASS_CODE = 'GDZJLL'
     AND TB.TAR_CLASS_CODE = 'CD1014'
     AND TB.MOD_FLG = 'MDM'
   WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  /*V_STEP := 4;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT,CUST_ID,REL_TYP,SHRH_AF_PARTY_CRDL_NO,SHRH_CRDL_NO,SHRH_AF_PARTY_NM,SHRH_AF_PARTY_STAT,COUNT(1)
      FROM RRP_MDL.M_OTH_SHRH_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT,CUST_ID,REL_TYP,SHRH_AF_PARTY_CRDL_NO,SHRH_CRDL_NO,SHRH_AF_PARTY_NM,SHRH_AF_PARTY_STAT
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;*/

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_OTH_SHRH_INFO;
/

