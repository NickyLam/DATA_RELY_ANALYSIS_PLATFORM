CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_OTH_SHRH_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_OTH_SHRH_INFO
  *  功能描述：监管集市银行股东及银行关联方相关信息
  *  创建日期：20220525
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_RELA_PARTY_BASIC_INFO  --关联方基本信息
  *            IOL.NOAS_OA_STOCKHOLDER_INFO --股东信息表
  *
  *  目标表：  M_OTH_SHRH_INFO  --股东及关联方信息表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114   hulj    增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_OTH_SHRH_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_OTH_SHRH_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_DATE    := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                       SUBSTR(I_P_DATE, 5, 2) || '-' ||
                       SUBSTR(I_P_DATE, 7, 2),
                       'YYYY-MM-DD');

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
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '股东及关联方信息表';
  V_STARTTIME := SYSDATE;

  /***************************OA系统--关联方信息******************************/
  INSERT INTO RRP_MDL.M_OTH_SHRH_INFO(
    DATA_DT                                     --数据日期
    ,LGL_REP_ID                                 --法人编号
    ,CUST_ID                                    --客户编号
    ,ORG_ID                                     --机构编号
    ,SHRH_AF_PARTY_STAT                         --股东或关联方状态
    ,SHRH_AF_PARTY_NM                           --股东或关联方名称
    ,SHRH_AF_PARTY_TYP                          --股东或关联方类型
    ,SHRH_AF_PARTY_CRDL_TYP                     --股东或关联方证件类型
    ,SHRH_AF_PARTY_CRDL_NO                      --股东或关联方证件号码
    ,SHRH_CRDL_TYP                              --股东证件类型
    ,SHRH_CRDL_NO                               --股东证件号码
    ,CTRY_CD                                    --国家代码
    ,HOLD_SHR_PCT                               --持股比例
    ,SHR_IN_DT                                  --入股日期
    ,ALDY_PLG_HOLD_SHR_PCT                      --已质押持股比例
    ,HLDG_SHRH_FLG                              --控股股东标志
    ,HOLD_SHR_NUM                               --持股数量
    ,LAST_CHG_DT                                --上次变动日期
    ,SHRH_AF_PARTY_BLNG_IDY                     --股东或关联方所属行业
    ,SHRH_AF_PARTY_REGD_LAND                    --股东或关联方注册地
    ,REL_TYP                                    --关系类型
    ,ACT_CNTLR                                  --实际控制人
    ,BANK_ATND_SHR_NUM                          --参股商业银行的数量
    ,BANK_HLDG_SHR_NUM                          --控股商业银行的数量
    ,BAD_INFO                                   --不良信息
    ,LIMIT_WGHT_FLG                             --限权标志
    ,SHR_IN_CPTL_SRC                            --入股资金来源
    ,SHR_IN_CPTL_ACC                            --入股资金账号
    ,STN_DIR_FLG                                --驻派董监事标志
    ,SHRH_TYP                                   --股东类型
    ,OWNERSHIP_CHAR                             --所有制性质
    ,AST_LBY_RTO                                --资产负债率
    ,NET_PROFIT                                 --净利润
    ,MRG_HOLD_SHR_PCT                           --实际控制人及其一致行动人合并持股比例
    ,ACT_CNTLR_MGT_ORG                          --实际控制人管理机构
    ,PAR_CO_CTRY_CD                             --母公司所在国家代码
    ,OV_SEA_IVS_FLG                             --境外投资者标志
    ,INTR_FN_CPTL_BAL                           --引进外资余额
    ,FN_SHRH_YEAR_RSRV_PFT                      --外方股东当年留存收益
    ,FN_CPTL_CHG_SIT                            --报告期内利用外资金额变化情况
    ,CHG_DT                                     --变化日期
    ,CHG_MODE                                   --变化方式
    ,ACT_CHG_AMT                                --实际变化金额
    ,ENT_HLDG_TYP                               --企业控股类型
    ,DEPT_LINE                                  --部门条线
    ,DATA_SRC                                   --数据来源
  )
  WITH RELA_PARTY_BASIC_INFO AS (
      SELECT TA.RELA_PARTY_ID,NVL(TB.PARTY_ID,TE.PARTY_ID) PARTY_ID,TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1) CERTIFICATE_CODE,
             NVL(TC.CTY_RG_CD,TD.NATION_CD) NATION_CD,TC.NATNAL_ECON_DEPT_TYPE_CD,
             CASE WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_1) IS NOT NULL
                  THEN TA.RELA_PARTY_CERT_TYPE_CD_1
                  WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_2) IS NOT NULL
                  THEN TA.RELA_PARTY_CERT_TYPE_CD_2
                  ELSE TA.RELA_PARTY_CERT_TYPE_CD_1
              END                                 AS SHRH_AF_PARTY_CRDL_TYP, --股东或关联方证件类型
             CASE WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_1) IS NOT NULL
                  THEN TRIM(TA.RELA_PARTY_CERT_ID_1)
                  WHEN TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2) IS NOT NULL AND TRIM(TA.RELA_PARTY_CERT_ID_2) IS NOT NULL
                  THEN TRIM(TA.RELA_PARTY_CERT_ID_2)
                  ELSE TRIM(TA.RELA_PARTY_CERT_ID_1)
              END                                 AS SHRH_AF_PARTY_CRDL_NO,
             ROW_NUMBER() OVER(PARTITION BY TA.RELA_PARTY_ID ORDER BY REPLACE(NVL(TD.CUST_STATUS_CD,TC.CUST_STATUS_CD),'-','Z'),
                               LENGTH(NVL(TB.PARTY_ID,TE.PARTY_ID))) RN
        FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO TA
        LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TB
          ON TB.CERT_NUM = TRIM(TA.RELA_PARTY_CERT_ID_1)
         AND TB.CERT_TYPE_CD = TRIM(TA.RELA_PARTY_CERT_TYPE_CD_1)
         AND TB.START_DT <= V_DATE
         AND TB.END_DT > V_DATE
        LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TE
          ON TE.CERT_NUM = TRIM(TA.RELA_PARTY_CERT_ID_2)
         AND TE.CERT_TYPE_CD = TRIM(TA.RELA_PARTY_CERT_TYPE_CD_2)
         AND TE.START_DT <= V_DATE
         AND TE.END_DT > V_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO TC
          ON TC.CUST_ID = NVL(TB.PARTY_ID,TE.PARTY_ID)
         AND TC.ETL_DT = V_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO TD
          ON TD.CUST_ID = NVL(TB.PARTY_ID,TE.PARTY_ID)
         AND TD.ETL_DT = V_DATE
/*        LEFT JOIN RRP_MDL.ADD_CONFIG_CODE_MAP B
          ON B.EDW_VALUE_CODE = TA.RELA_PARTY_CERT_TYPE_CD_1
         AND B.EDW_CLASS_CODE = 'CD1014'
         AND B.RRP_CLASS_CODE = 'C0001' --ADD BY LIP 20221010
        LEFT JOIN RRP_MDL.ADD_CONFIG_CODE_MAP D
          ON D.EDW_VALUE_CODE = TA.RELA_PARTY_CERT_TYPE_CD_2
         AND D.EDW_CLASS_CODE = 'CD1014'
         AND D.RRP_CLASS_CODE = 'C0001' --ADD BY LIP 20221010*/
       WHERE TA.PARTY_ID = 'GHB'
         AND TA.ETL_DT = V_DATE)
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                    --数据日期
    ,A.LP_ID                                         --法人编号
    ,NVL(B.PARTY_ID,A.RELA_PARTY_ID)                 --客户编号
    ,/*'800'  */
    A.RELA_PARTY_BELONG_ORG_ID                                        --机构编号
    ,CASE WHEN A.RELA_STATUS_CD = 'A' THEN 'Y' ELSE 'N' END --股东或关联方状态
    ,A.RELA_PARTY_NAME                               --股东或关联方名称
    ,'01'/*A.SHARD_OR_RELA_PARTY_TYPE_CD  */                 --股东或关联方类型
   -- ,B.TAR_VALUE_CODE                                --股东或关联方证件类型
    ,B.SHRH_AF_PARTY_CRDL_TYP                      --股东或关联方证件类型   --取消转码
    ,B.SHRH_AF_PARTY_CRDL_NO                       --股东或关联方证件号码
    --,B.TAR_VALUE_CODE                                --股东证件类型
    ,B.SHRH_AF_PARTY_CRDL_TYP                      --股东或关联方证件类型  --取消转码
    ,B.SHRH_AF_PARTY_CRDL_NO                         --股东证件号码
    ,NULL                                            --国家代码
    ,NULL                                            --持股比例
    ,NULL                                            --入股日期
    ,NULL                                            --已质押持股比例
    ,NULL                                            --控股股东标志
    ,NULL                                            --持股数量
    ,NULL                                            --上次变动日期
    ,A.SHARD_OR_RELA_PARTY_BL_INDUTY_CD              --股东或关联方所属行业
    ,A.SHARD_OR_RELA_PARTY_RGST_ADDR                 --股东或关联方注册地
    ,A.SHARD_OR_RELA_PARTY_RELA_TYPE_CD               --关系类型
    ,NULL                                            --实际控制人
    ,NULL                                            --参股商业银行的数量
    ,NULL                                            --控股商业银行的数量
    ,NULL                                            --不良信息
    ,NULL                                            --限权标志
    ,NULL                                            --入股资金来源
    ,NULL                                            --入股资金账号
    ,NULL                                            --驻派董监事标志
    ,NULL                                            --股东类型
    ,NULL                                            --所有制性质
    ,NULL                                            --资产负债率
    ,NULL                                            --净利润
    ,NULL                                            --实际控制人及其一致行动人合并持股比例
    ,NULL                                            --实际控制人管理机构
    ,NULL                                            --母公司所在国家代码
    ,NULL                                            --境外投资者标志
    ,NULL                                            --引进外资余额
    ,NULL                                            --外方股东当年留存收益
    ,NULL                                            --报告期内利用外资金额变化情况
    ,NULL                                            --变化日期
    ,NULL                                            --变化方式
    ,NULL                                            --实际变化金额
    ,TA.TAR_VALUE_CODE                               --企业控股类型
    ,'800906' /*董事会办公室*/                       --部门条线
    ,'关联方'                                        --数据来源
  FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO A --关联方基本信息
/*  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
  ON A.PARTY_ID  = C.CUST_ID
  AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
  LEFT JOIN RELA_PARTY_BASIC_INFO B
      ON B.RELA_PARTY_ID = A.RELA_PARTY_ID
     AND B.RN = 1
 LEFT JOIN
    (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY (CASE WHEN T.SOCI_CRDT_CD IS NOT NULL THEN T.SOCI_CRDT_CD
                                     WHEN T.ORGNZ_CD IS NOT NULL THEN T.ORGNZ_CD
                                     WHEN T.BUS_LICS_NUM IS NOT NULL THEN T.BUS_LICS_NUM
                                     WHEN T.RGSTION_CD IS NOT NULL THEN T.RGSTION_CD
                                     WHEN T.NATION_TAX_RGST_CERT_NUM IS NOT NULL THEN T.NATION_TAX_RGST_CERT_NUM
                                     WHEN T.LOCAL_TAX_RGST_CERT_NUM IS  NOT NULL THEN T.LOCAL_TAX_RGST_CERT_NUM
                                     WHEN T.FIN_LICS_NUM IS NOT NULL THEN T.FIN_LICS_NUM
                                     WHEN T.PBC_PAY_BANK_NO IS  NOT NULL THEN T.PBC_PAY_BANK_NO
                                     END) ORDER BY OPEN_ACCT_DT ) RN  FROM  O_ICL_CMM_CORP_CUST_BASIC_INFO T
                                     WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ) C
    ON A.RELA_PARTY_CERT_ID_1 = CASE WHEN C.SOCI_CRDT_CD IS NOT NULL THEN C.SOCI_CRDT_CD
                                     WHEN C.ORGNZ_CD IS NOT NULL THEN C.ORGNZ_CD
                                     WHEN C.BUS_LICS_NUM IS NOT NULL THEN C.BUS_LICS_NUM
                                     WHEN C.RGSTION_CD IS NOT NULL THEN C.RGSTION_CD
                                     WHEN C.NATION_TAX_RGST_CERT_NUM IS NOT NULL THEN C.NATION_TAX_RGST_CERT_NUM
                                     WHEN C.LOCAL_TAX_RGST_CERT_NUM IS  NOT NULL THEN C.LOCAL_TAX_RGST_CERT_NUM
                                     WHEN C.FIN_LICS_NUM IS NOT NULL THEN C.FIN_LICS_NUM
                                     WHEN C.PBC_PAY_BANK_NO IS  NOT NULL THEN C.PBC_PAY_BANK_NO
                                     END
    AND A.RELA_PARTY_NAME = C.CUST_NAME
    AND C.RN = 1
    LEFT JOIN CODE_MAP TA --企业控股类型转码
  ON TA.SRC_VALUE_CODE = C.HOLD_TYPE_CD
  AND TA.SRC_CLASS_CODE = 'CD1417'
  AND TA.TAR_CLASS_CODE = 'C0004'
  AND TA.MOD_FLG = 'MDM'
 /* LEFT JOIN RRP_MDL.CODE_MAP B
    ON A.RELA_PARTY_CERT_TYPE_CD_1 = B.SRC_VALUE_CODE
    AND B.SRC_CLASS_CODE = 'CD1014' --证件类型
    AND B.MOD_FLG = 'MDM'            --监管集市明细层*/
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.PARTY_ID = 'GHB' --AND A.RELA_PARTY_CERT_ID_1 IS NOT NULL
  ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ---记录正常日志
  V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '股东及关联方信息表';
  V_STARTTIME := SYSDATE;

  /***************************OA系统--股东信息******************************/
  INSERT INTO RRP_MDL.M_OTH_SHRH_INFO(
    DATA_DT                          --数据日期
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
  )
  WITH TMP1 AS (
      SELECT TA.STOCK_INFO_ID,TA.STOCKHOLDER_ID,TB.PARTY_ID,TRIM(TA.CERTIFICATE_CODE) CERTIFICATE_CODE,
             ROW_NUMBER() OVER(PARTITION BY TA.STOCK_INFO_ID ORDER BY REPLACE(NVL(TD.CUST_STATUS_CD,TC.CUST_STATUS_CD),'-','Z'),
                               LENGTH(TB.PARTY_ID)) RN
        FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO TA
       INNER JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TB
          ON TB.CERT_NUM = TRIM(TA.CERTIFICATE_CODE)
         AND TB.START_DT <= V_DATE
         AND TB.END_DT > V_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO TC
          ON TC.CUST_ID = TB.PARTY_ID
         AND TC.ETL_DT = V_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO TD
          ON TD.CUST_ID = TB.PARTY_ID
         AND TD.ETL_DT = V_DATE
       WHERE TRIM(TA.CERTIFICATE_CODE) IS NOT NULL
         AND NVL(TC.CUST_ID,TD.CUST_ID) IS NOT NULL
         AND TA.START_DT <= V_DATE
         AND TA.END_DT > V_DATE),
    TOTALSTOCKAMOUNT AS (
      SELECT SUM(STOCK_OWN_AMOUNT) AS TOTALSTOCKAMOUNT
        FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO
       WHERE STATUS = '1'
         AND START_DT <= V_DATE
         AND END_DT > V_DATE)
  SELECT
    V_P_DATE                                --数据日期
    ,'9999'                                 --法人编号
    ,T3.PARTY_ID                            --客户编号
    ,'800'                                  --机构编号
    ,T1.STATUS                              --股东或关联方状态
    ,T1.STOCKHOLDER_NAME                     --股东或关联方名称
    ,T1.EAST_STOCKHOLDER_TYPE                --股东或关联方类型
    ,NVL(TB.TAR_VALUE_CODE,T1.STOCKHOLDER_CERTIFICATE_TYPE)
                                             --股东或关联方证件类型
    ,NVL(TRIM(T1.CERTIFICATE_CODE),'1')      --股东或关联方证件号码--MODIFY BY CAIZHENGWEI 20220514加TRIM
    ,T1.STOCKHOLDER_CERTIFICATE_TYPE /*'2X'*/--股东证件类型
    ,NVL(TRIM(T1.CERTIFICATE_CODE),'1')      --股东证件号码--MODIFY BY CAIZHENGWEI 20220514加TRIM
    ,NULL                                   --国家代码
    /*,CASE WHEN NVL(T2.TOTALSTOCKAMOUNT,0) = 0 THEN 0
           ELSE T1.STOCK_OWN_AMOUNT / B.TOTALSTOCKAMOUNT * 100
     END                                    --持股比例*/
    ,CASE WHEN NVL(T2.TOTALSTOCKAMOUNT,0) = 0 THEN 0
           ELSE T1.STOCK_OWN_AMOUNT / 8000000000 * 100
     END                                    --持股比例 */
     --MODIFY 20230222 LHQ 根据林伟安口径调整，分母已80亿为准
    ,CASE WHEN TO_CHAR(T1.STOCKHOLDER_BEGIN_DATE,'YYYYMMDD') NOT IN ('00010101','29991231')
          THEN TO_CHAR(T1.STOCKHOLDER_BEGIN_DATE,'YYYYMMDD')
     END                                    --入股日期
    /*,CASE WHEN NVL(T2.TOTALSTOCKAMOUNT,0) = 0 THEN 0
           ELSE T1.STOCK_PLEDGE_AMOUNT / T2.TOTALSTOCKAMOUNT * 100
     END                                    --已质押持股比例*/
    ,TO_NUMBER(TRIM(T1.PLEDGE_PROPORTION))                    --已质押持股比例  MODIFY 20230222 LHQ 根据林伟安口径调整，改为直取
    ,NULL                                   --控股股东标志
    ,T1.STOCK_OWN_AMOUNT                     --持股数量
    ,CASE WHEN TO_CHAR(T1.LAST_TIME_CHANGE_DATE,'YYYYMMDD') NOT IN ('00010101','29991231')
          THEN TO_CHAR(T1.LAST_TIME_CHANGE_DATE,'YYYYMMDD')
    END                                      --上次变动日期
    ,T1.NATIONAL_ECONOMY_CODE                --股东或关联方所属行业
    ,T1.STOCKHOLDER_REGISTRATION_PLACE       --股东或关联方注册地
    ,'1' --股东                               --关系类型
    ,TRIM(T1.ACTUAL_CONTROLLER)                --实际控制人
    ,T1.STOCKHOLDER_SHARE_BANK_AMOUNT          --参股商业银行的数量
    ,T1.STOCKHOLDER_HOLD_BANK_AMOUNT           --控股商业银行的数量
    ,TRIM(T1.BAD_INFORMATION)                  --不良信息
    ,T1.IS_POWER_RESTRAINT                            --限权标志
    ,T1.CAPITAL_SOURCE                                --入股资金来源
    ,T1.FUND_ACCOUNT                                  --入股资金账号
    ,T1.INDIRECTOR                                    --驻派董监事标志
    ,NULL                                            --股东类型
    ,NULL                                            --所有制性质
    ,NULL                                            --资产负债率
    ,NULL                                            --净利润
    ,NULL                                            --实际控制人及其一致行动人合并持股比例
    ,NULL                                            --实际控制人管理机构
    ,NULL                                            --母公司所在国家代码
    ,NULL                                            --境外投资者标志
    ,NULL                                            --引进外资余额
    ,NULL                                            --外方股东当年留存收益
    ,NULL                                            --报告期内利用外资金额变化情况
    ,NULL                                            --变化日期
    ,NULL                                            --变化方式
    ,NULL                                            --实际变化金额
    ,TA.TAR_VALUE_CODE
    ,'800906' /*董事会办公室*/                       --部门条线
    ,'OA系统'                                         --数据来源
  FROM O_IOL_NOAS_OA_STOCKHOLDER_INFO T1 --股东信息表
  LEFT JOIN TOTALSTOCKAMOUNT T2
      ON 1 = 1
  LEFT JOIN TMP1             T3 --获取股东的客户号
      ON T3.STOCK_INFO_ID = T1.STOCK_INFO_ID
     AND T3.RN = 1
  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO T4 --对公客户基本信息
  ON T1.CERTIFICATE_CODE  =
  COALESCE(T4.SOCI_CRDT_CD,T4.BUS_LICS_NUM,T4.FIN_LICS_NUM,T4.RGSTION_CD,T4.NATION_TAX_RGST_CERT_NUM,T4.LOCAL_TAX_RGST_CERT_NUM)
  AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND T1.STOCKHOLDER_NAME=T4.CUST_NAME
  LEFT JOIN CODE_MAP TA --企业控股类型转码
  ON TA.SRC_VALUE_CODE = T4.HOLD_TYPE_CD
  AND TA.SRC_CLASS_CODE = 'CD1417'
  AND TA.TAR_CLASS_CODE = 'C0004'
  AND TA.MOD_FLG = 'MDM'
  LEFT JOIN CODE_MAP TB --股东及关联方证件类型转码
    ON TB.SRC_VALUE_CODE = T1.STOCKHOLDER_CERTIFICATE_TYPE
   AND TB.SRC_CLASS_CODE = 'GDZJLL'
   AND TB.TAR_CLASS_CODE = 'CD1014'
   AND TB.MOD_FLG = 'MDM'
  LEFT JOIN (
    SELECT SUM(STOCK_OWN_AMOUNT) AS TOTALSTOCKAMOUNT
    FROM RRP_MDL.O_IOL_NOAS_OA_STOCKHOLDER_INFO
    WHERE STATUS = '1'
      AND START_DT <= V_DATE AND END_DT > V_DATE
    --GROUP BY STOCK_INFO_ID
  ) B
    ON 1 = 1
  WHERE T1.START_DT <= V_DATE AND T1.END_DT > V_DATE
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,SHRH_AF_PARTY_CRDL_NO,SHRH_CRDL_NO,SHRH_AF_PARTY_NM,COUNT(1)
      FROM M_OTH_SHRH_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID,SHRH_AF_PARTY_CRDL_NO,SHRH_CRDL_NO,SHRH_AF_PARTY_NM
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

  END ETL_INIT_M_OTH_SHRH_INFO;
/

