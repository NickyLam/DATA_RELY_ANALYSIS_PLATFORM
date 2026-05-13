CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_INVEST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_INVEST
  *  功能描述：投资业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_INVEST_INFO
  *            M_CUST_CORP_INFO
  *            M_FIN_INST_BOND_INFO
  *            M_FIN_INST_ULYG_INFO
  *            M_CPTL_INVEST_DIR
  *
  *  目标表：  S_CPTL_INVEST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *                 20221101  MW       增加客户细类、金融机构名称
  *                 20221205  HYF      增加投资大类代码、投资大类名称、G31投资分类、G31投资分类名称、科目代码
  *                 20230110  zhaoqian 增加投资收入字段
  *                 20230919  HYF      增加同业债券和资金债券的过滤条件，增加市场类型编号过滤确保债券唯一
  *                 20230926  HYF      同业非标部分，新增本月利息收入、非生息资产标志用于判定是否为非生息资产
  *                 20231023  HYF      修改账面余额逻辑，取净值余额+公允价值变动+利息调整+应计利息
  *                 20231213  HYF      修改债券评级，发行主体评级，为空默认为C00
  *                 20231214  HYF      新增五级分类和贷款投向逻辑，从信贷系统取
  *                 20231215  HYF      S67房地产业标志，同业系统取全部投向行业门类为房地产业的，资金系统取发行主体的ECIF行业
  *                 20240308  HYF      新增账簿类型字段
  *                 20240407  HYF      修改G31投资分类映射，汇金MTN需要映射到企业债而不是机构债
  *                 20240826  HYF      修改A1411投资分类映射，债券部分优先区分特定目的载体,写死一笔债券到境外债券
  *                 20241218  HYF      修改A1411投资分类映射,30108映射到特定目的载体,证券公司及子公司资管产品,基金管理公司及子公司专户产品,期货公司及子公司资管产品逻辑
  *                 20250211  HYF      新增现金管理类产品标志
  *                 20251013  YJY      更改’分配我行确认价值‘的取数来源
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_INVEST'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_YEAR_END   VARCHAR2(8); -- 去年年末
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_CPTL_INVEST'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_INVEST T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CPTL_INVEST'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  V_LAST_YEAR_END :=(SUBSTR(V_P_DATE,1,4)-1) || '1231'; -- 去年年末
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  EXECUTE IMMEDIATE ('TRUNCATE TABLE S_G1102_BASE');

  V_STEP := 3;
  V_STEP_DESC := 'G1102报表分配价值--用于出投资类分配我行确认价值';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_G1102_BASE(
  DATA_DT,--数据日期
  CREDNO,--借据号
  CONFMAMT --分配我行确认价值
  )
  /*SELECT V_P_DATE,CREDNO,SUM(NVL(CONFMAMT,0))
  FROM RRP_MDL.O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR   --按业务规则分配G13结果表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT>TO_DATE(V_P_DATE,'YYYYMMDD')
     AND SUBSTR(DATECODE,1,6)=SUBSTR(V_P_DATE,1,6)
     AND ID_MARK <> 'D'
     GROUP BY CREDNO
     ;*/
    SELECT V_P_DATE
          ,A.DUBIL_ID     --借据号
          ,SUM(NVL(B.HXB_CFM_VAL,0)) --分配我行确认价值
     FROM RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H A  --资产借据分配历史
     LEFT JOIN RRP_MDL.O_IML_AST_COL_VAL_INFO_H B   --押品价值信息历史
       ON B.ASSET_ID = A.ASSET_ID
      AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') --MOD BY YJY 20251013
    GROUP BY A.DUBIL_ID; 
      
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 4;
  V_STEP_DESC := '投资业务整合表--（债券、股票、基金、其他证券、股权、长期股权）';
  V_STARTTIME := SYSDATE;
  --资金债券
  INSERT INTO S_CPTL_INVEST
      ( DATA_DT                          --数据日期
       ,LGL_REP_ID                       --法人编号
       ,ACC_ID                           --账户编号
       ,CUST_ID                          --客户编号
       ,CORP_CUST_TYP                    --对公客户类型
       ,ORG_NO                           --机构号
       ,FIN_ORG_TYP                      --金融机构类型
       ,FIN_ORG_NM                       --金融机构名称
       ,FIN_ORG_ID                       --金融机构编号
       ,BIO_FLG                          --境内外标志
       ,BOOK_BAL                         --账面余额
       ,CUR                              --币种
       ,INVEST_BIZ_VRTY                  --投资业务品种
       ,FIN_AST_CL                       --金融资产分类
       ,ULYG_PROD_ID                     --标的产品编号
       ,PROD_CL                          --产品分类
       ,MGT_MODE                         --管理方式
       ,ISU_SUBJ_RTG                     --发行主体评级
       ,PROD_RAISE_MODE                  --产品募集方式
       ,REGD_LAND_AREA_CD                --注册地行政区划代码
       ,BOND_ISU_MODE                    --债券发行方式
       ,FLT_RATE_TYP                     --浮动利率类型
       ,BOND_SUR_TERM                    --债券剩余期限
       ,ISU_DT                           --发行日期
       ,HOLD_UN_BOT_AST_LBY_BAL          --持有非底层资产产生的间接负债余额
       ,AST_SPRT_SCR_SUB_CL              --资产支持证券细类
       ,LVL5_CL                          --五级分类
       ,ACPT_ORG_TYP                     --承兑机构类型
       ,ORIG_BILL_HLDR_TYP               --原始持票人类型
       ,PRO_IMPT                         --减值准备
       ,EXP_DT                           --到期日期
       ,CRED_RTS_FIN_PROD_SUB_CL         --债权融资类产品细类
       ,GRN_INVEST_USEAGE_CL_1104        --绿色投资用途分类1104
       ,CER_MTG_INVEST_FLG               --以碳排放权为抵押的投资标志
       ,ER_MTG_INVEST_FLG                --以环境权益为抵押的投资标志
       ,DEPT_LINE                        --部门条线
       ,DATA_SRC                         --数据来源
       ,PROD_TYP                         --产品细类
       ,ID                               --业务主键
       ,BOND_ID                          --债券编号
       ,BOND_NAME                        --债券名称
       ,ASSET_TYPE_ID                    --原始债券类型代码
       ,ASSET_NAME                       --资产名称
       ,BOND_RTG                         --债券评级
       ,INVEST_TYP                       --投资大类代码
       ,INVEST_TYP_NAME                  --投资大类名称
       ,G31_INVEST_TYPE                  --G31投资分类
       ,G31_INVEST_TYPE_NAME             --G31投资分类名称
       ,A1411_INVEST_TYPE                --A1411投资分类代码
       ,A1411_INVEST_TYPE_NAME           --A1411投资分类名称
       ,SUBJ_ID                          --科目代码
       ,LEVEL4_PROD_ID                   --四级产品编号
       ,LEVEL4_PROD_NAME                 --四级产品名称
       ,INVEST_INCOME                    --投资收入
       ,OVDUE_FLG                        --逾期标志
       ,EVHA_VAL_CHAG_PL                 --公允价值变动损益
       ,SPD_PL                           --价差损益
       ,INT_INCOME                       --利息收入
       ,YEAR_EVHA_VAL_CHAG_PL            --本年公允价值变动损益
       ,YEAR_SPD_PL                      --本年价差损益
       ,YEAR_INT_INCOME                  --本年利息收入
       ,YEAR_INVEST_INCOME               --本年投资收入
       ,ASSET_UNIQ_IDF_ID                --资产唯一标识编号 ADD BY HYF 20231120
       ,CREDNO                           --借据编号 ADD BY HYF 20231120
       ,CONFMAMT                         --分配我行确认价值 ADD BY HYF 20231120
       ,LOAN_DIR_IDY                     --贷款投向行业 ADD BY HYF 20231214
       ,ESTATE_BOND_TYPE_NAME            --房地产债券类型名称 ADD BY HYF 20231214
       ,S67_FDC_IND                      --S67房地产业标志 ADD BY HYF 20231215
       ,OVDUE_DAYS                       --逾期天数 ADD BY HYF 20231215
       ,ACCT_B_CATE_CD                   --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
       ,CASH_MANAGE_FLG                  --现金管理类产品标志 ADD BY HYF 20250211
       ,CORET_DURAN                      --修正久期 ADD BY HYF 20250314
       )
      SELECT DISTINCT
              A.DATA_DT                                              AS DATA_DT                    --数据日期
             ,A.LGL_REP_ID                                           AS LGL_REP_ID                 --法人编号
             ,A.ACC_ID                                               AS ACC_ID                     --账户编号
             ,A.CUST_ID                                              AS CUST_ID                    --客户编号
             ,B.CUST_CL                                              AS CORP_CUST_TYP              --对公客户类型
             ,A.ORG_ID                                               AS ORG_NO                     --机构号
             ,B.FIN_ORG_TYP                                          AS FIN_ORG_TYP                --金融机构类型
             ,B.CUST_NM                                              AS FIN_ORG_NM                 --金融机构名称
             ,B.FIN_ORG_ID                                           AS FIN_ORG_ID                 --金融机构编号
             ,B.BIO_FLG                                              AS BIO_FLG                    --境内外标志
             --A.BOOK_BAL                                             AS BOOK_BAL,                  --账面余额
             ,NVL(A.NV_BAL,0)+NVL(A.FAIR_VAL,0)+NVL(A.INT_ADJ_AMT,0)+NVL(A.ACRU_INT_AMT,0)
                                                                     AS BOOK_BAL                   --账面余额 20231023
             ,A.CUR                                                  AS CUR                        --币种
             ,A.INVEST_BIZ_VRTY                                      AS INVEST_BIZ_VRTY            --投资业务品种
             ,A.FIN_AST_CL                                           AS FIN_AST_CL                 --金融资产分类
             ,A.STD_PROD_ID                                          AS STD_PROD_ID                --标准产品编号
             ,NVL(C.PROD_CL, D.ULYG_PROD_CL)                         AS PROD_CL                    --产品分类
             ,A.MGT_MOD                                              AS MGT_MODE                   --管理方式
             ,NVL(C.ISU_SUBJ_RTG ,'C00')                             AS ISU_SUBJ_RTG               --发行主体评级
             ,A.PROD_RAISE_MODE                                      AS PROD_RAISE_MODE            --产品募集方式
             ,B.REGD_LAND_AREA_CD                                    AS REGD_LAND_AREA_CD          --注册地行政区划代码
             ,C.BOND_ISU_MODE                                        AS BOND_ISU_MODE              --债券发行方式
             ,C.FLT_RATE_TYP                                         AS FLT_RATE_TYP               --浮动利率类型
             ,TO_DATE(C.EXP_DT, 'YYYY-MM-DD') -TO_DATE(V_P_DATE,'YYYYMMDD')  AS BOND_SUR_TERM      --债券剩余期限
             ,C.ISU_DT                                               AS ISU_DT                     --发行日期
             ,A.HOLD_UN_BOT_AST_LBY_BAL                              AS HOLD_UN_BOT_AST_LBY_BAL    --持有非底层资产产生的间接负债余额
             ,E.AST_SPRT_SCR_SUB_CL                                  AS AST_SPRT_SCR_SUB_CL        --资产支持证券细类
             -- A.LVL5_CL                                              AS LVL5_CL,                   --五级分类
             ,NVL(TB.TAR_VALUE_CODE, '01')                           AS LVL5_CL                    --五级分类
             ,D.ACPT_ORG_TYP                                         AS ACPT_ORG_TYP               --承兑机构类型
             ,D.ORIG_BILL_HLDR_TYP                                   AS ORIG_BILL_HLDR_TYP         --原始持票人类型
             ,A.PRO_IMPT                                             AS PRO_IMPT                   -- 减值准备
             ,C.EXP_DT                                               AS EXP_DT                     -- 到期日期
             ,E.CRED_RTS_FIN_PROD_SUB_CL                             AS CRED_RTS_FIN_PROD_SUB_CL   -- 债权融资类产品细类
             ,C.GRN_INVEST_USEAGE_CL_1104                            AS GRN_INVEST_USEAGE_CL_1104  -- 绿色投资用途分类1104
             ,C.CER_MTG_INVEST_FLG                                   AS CER_MTG_INVEST_FLG         -- 以碳排放权为抵押的投资标志
             ,C.ER_MTG_INVEST_FLG                                    AS ER_MTG_INVEST_FLG          -- 以环境权益为抵押的投资标志
             ,A.DEPT_LINE                                            AS DEPT_LINE                 --部门条线
             ,A.DATA_SRC                                             AS DATA_SRC                  --数据来源
             ,CASE WHEN C.PROD_CL  =  'A0101' THEN 'GB01'
                   WHEN C.PROD_CL  =  'A0102' THEN 'GB02'
                   WHEN C.PROD_CL  =  'A0103' THEN 'GB03'
                   WHEN C.PROD_CL  =  'A0201' THEN 'GB042'
                   WHEN C.PROD_CL  =  'A0202' THEN 'GB041'
                   WHEN C.PROD_CL  =  'A03'   THEN 'CB01'
                   WHEN C.PROD_CL  =  'B01'   THEN 'CBN'
                   WHEN C.PROD_CL  =  'B02'   THEN 'FB00'
                   WHEN C.PROD_CL  =  'B0301' THEN 'FB01'
                   WHEN C.PROD_CL  =  'B0302' THEN 'FB02'
                   WHEN C.PROD_CL  =  'B0303' THEN 'FB03'
                   WHEN C.PROD_CL  =  'B0304' THEN 'FB04'
                   WHEN C.PROD_CL  =  'B0305' THEN 'FB05'
                   WHEN C.PROD_CL  =  'B0306' THEN 'FB06'
                   WHEN C.PROD_CL  =  'C01'   THEN 'CB01'
                   WHEN C.PROD_CL  =  'C0101' THEN 'CB02'
                   WHEN C.PROD_CL  =  'C0102' THEN 'CB01'
                   WHEN C.PROD_CL  =  'C0201' THEN 'CB04'
                   WHEN C.PROD_CL  =  'C0202' THEN 'CB05'
                   WHEN C.PROD_CL  =  'C02'   THEN 'CB03'
                   WHEN C.PROD_CL  =  'C03'   THEN 'CB06'
                   WHEN C.PROD_CL  =  'C0301' THEN 'MTN'
                   WHEN C.PROD_CL  =  'C0302' THEN 'CP'
                   WHEN C.PROD_CL  =  'C0303' THEN 'SCP'
                   WHEN C.PROD_CL  =  'C0304' THEN 'SMECN1'
                   WHEN C.PROD_CL  =  'C0305' THEN 'SMECN2'
                   WHEN C.PROD_CL  =  'C0306' THEN 'PPN'
                   WHEN C.PROD_CL  =  'C0307' THEN 'ABN'
                   WHEN C.PROD_CL  =  'C0308' THEN 'PRB'
                   WHEN C.PROD_CL  =  'C0309' THEN 'PRN'
                   WHEN C.PROD_CL  =  'D01'   THEN 'ABS01'
                   WHEN C.PROD_CL  =  'D02'   THEN 'ABS02'
                   WHEN C.PROD_CL  =  'F01'   THEN 'MDBB'
                   ELSE 'TB99'
              END                                                     AS PROD_TYP                   --产品细类 20221101 mw根据业务要求划分产品细类                                           AS PROD_TYP                   --产品细类
             ,A.ID                                                    AS ID                         --业务主键
             ,C.BOND_ID                                               AS BOND_ID                    --债券编号
             ,C.PROD_NM                                               AS BOND_NAME                  --债券名称
             ,NVL(C.ASSET_TYPE_ID,A.ASSET_TYPE_ID)                    AS ASSET_TYPE_ID              --原始债券代码
             ,NVL(C.ASSET_NAME,A.ASSET_NAME)                          AS ASSET_NAME                 --资产名称
             ,NVL(C.RATING_REST_CD,'C00')                             AS BOND_RTG                   --债券评级
             ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '00'
                   ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '05'
                             WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '04'
                             WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                               OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '12'
                             WHEN A.ASSET_NAME LIKE '%基金%' THEN '01'
                             WHEN A.ASSET_NAME LIKE '%票据资管计划%' THEN '00'
                             ELSE '99' END
               END                                                    AS INVEST_TYP                  --投资大类代码
             ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '债券投资'
                   ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '理财产品投资'
                             WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托产品投资'
                             WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                               OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '资产管理产品'
                             WHEN A.ASSET_NAME LIKE '%基金%' THEN '基金投资'
                             WHEN A.ASSET_NAME LIKE '%票据资管计划%' THEN '债券投资'
                             ELSE '其它投资' END
               END                                                    AS INVEST_TYP_NAME              --投资大类名称
             ,CASE WHEN TRIM(A.ASSET_TYPE_ID) = '1'  THEN '1.1' --1.1国债
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'M'  AND C.PROD_CL = 'B0201' THEN '1.2.1' --1.2.1地方政府专项债券
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'M'  THEN '1.2.2' --1.2.2普通地方政府债券
                   WHEN TRIM(A.ASSET_TYPE_ID) = '5'  THEN  '1.3' --1.3央票
                   WHEN TRIM(A.ASSET_TYPE_ID) = '8'  
                     OR ( TRIM(A.ASSET_TYPE_ID) IN ('9','U','7','X','Y','K') AND C.ISSUER_NAME IN ('国家开发银行','中国进出口银行','中国农业发展银行')) 
                   THEN  '1.4' --1.4政策性金融债 --其中政策性金融债，商业性金融债有一部分需要特殊处理，
                   --对于产品是商业性金融债，但是发行人是国家开发银行、进出口银行、农村发展银行改为“商业性金融 债”
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'Q' 
                     OR ( TRIM(A.ASSET_TYPE_ID) IN ('6','O','N') AND C.ISSUER_NAME IN ('中央汇金投资有限责任公司','中国国家铁路集团有限公司') AND C.PROD_NM NOT LIKE '%MTN%' )
                   THEN  '1.5' --1.5政府机构债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('9','U','7','X','Y','K','C5','61','C2','C6','C4','C1','C9')
                     OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND  C.ISSUER_NAME IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司'
                                                                               ,'中国华融资产管理股份有限公司','中国信达资产管理股份有限公司'
                                                                               ,'中国银河资产管理有限责任公司')) 
                   THEN '1.6' --1.6商业性金融债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('4','D','G') THEN '1.7.1' --1.7.1企业债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('E','V','I') THEN '1.7.2' --1.7.2公司债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('6','O','N','H','P','J','PPN','C3') THEN '1.7.3' --1.7.3企业债务融资工具
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'L'  THEN '1.8.1' --1.8.1信贷资产证券化
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'L1'  THEN '1.8.3' --1.8.3资产支持票据
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('F','FL','FG','S')  THEN '1.9' --1.9外国债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('Z')  THEN '6.2' --6.2非标转标资产(标准化票据)
               END                                                      AS G31_INVEST_TYPE  --G31投资分类
             ,CASE WHEN TRIM(A.ASSET_TYPE_ID) = '1'  THEN '国债' --1.1国债
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'M'  AND C.PROD_CL = 'B0201' THEN '地方政府专项债券' --1.2.1地方政府专项债券
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'M'  THEN '普通地方政府债券' --1.2.2普通地方政府债券
                   WHEN TRIM(A.ASSET_TYPE_ID) = '5'  THEN  '央票' --1.3央票
                   WHEN TRIM(A.ASSET_TYPE_ID) = '8'  
                     OR ( TRIM(A.ASSET_TYPE_ID) IN ('9','U','7','X','Y','K') AND C.ISSUER_NAME IN ('国家开发银行','中国进出口银行','中国农业发展银行') ) 
                   THEN '政策性金融债' --1.4政策性金融债 --其中政策性金融债，商业性金融债有一部分需要特殊处理，
                   --对于产品是商业性金融债，但是发行人是国家开发银行、进出口银行、农村发展银行改为“商业性金融 债”
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'Q' 
                     OR ( TRIM(A.ASSET_TYPE_ID) IN ('6','O','N') AND C.ISSUER_NAME IN ('中央汇金投资有限责任公司','中国国家铁路集团有限公司') AND C.PROD_NM NOT LIKE '%MTN%' )
                   THEN '政府机构债券' --1.5政府机构债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('9','U','7','X','Y','K','C5','61','C2','C6','C4','C1','C9')
                     OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND  C.ISSUER_NAME IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司',
                                                                              '中国华融资产管理股份有限公司','中国信达资产管理股份有限公司',
                                                                              '中国银河资产管理有限责任公司') ) 
                   THEN '商业性金融债' --1.6商业性金融债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('4','D','G')  THEN '企业债' --1.7.1企业债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('E','V','I') THEN '公司债' --1.7.2公司债
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('6','O','N','H','P','J','PPN','C3') THEN '企业债务融资工具' --1.7.3企业债务融资工具
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'L'  THEN '信贷资产证券化' --1.8.1信贷资产证券化
                   WHEN TRIM(A.ASSET_TYPE_ID) = 'L1'  THEN '资产支持票据' --1.8.3资产支持票据
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('F','FL','FG','S')  THEN '外国债券' --1.9外国债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('Z')  THEN '标准化票据' --6.2非标转标资产(标准化票据)
                END                                                     AS G31_INVEST_TYPE_NAME  --G31投资分类名称
             ,CASE WHEN SUBSTR(A.STD_PROD_ID,0,5) = '30108' THEN '99' --99境内特定目的载体债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('F','FL','FG','S') OR A.ACC_ID = 'X0007223B2700002205' OR B.BIO_FLG = 'N' THEN '10' --10境外债券投资
                   WHEN C.ISSUER_NAME IN ('中央汇金投资有限责任公司') THEN '09' --09境内其他金融机构债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('1','M') THEN '01' --01政府债券投资
                   WHEN TRIM(A.ASSET_TYPE_ID) = '5' THEN '02' --02中央银行债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('8','9','U','7','X','Y','K') THEN '03' --03境内银行业存款类金融机构债券
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('C6','C4','C1','C9') 
                     OR ( TRIM(A.ASSET_TYPE_ID) IN ('Q','4','D','G','E','V','I','6','O','N','H','P','J','PPN','L','L1')
                           AND (B.FIN_ORG_TYP LIKE 'D%' OR B.FIN_ORG_TYP ='Z30000')) 
                     OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND C.ISSUER_NAME IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司',
                                                                             '中国华融资产管理股份有限公司','中国信达资产管理股份有限公司',
                                                                             '中国银河资产管理有限责任公司') ) 
                   THEN '06' --06境内银行业非存款类金融机构债券(特殊情况：非金融企业债中金融机构类型是D开头的属于银行业非存款)
                   WHEN TRIM(A.ASSET_TYPE_ID) IN ('Q','4','D','G','E','V','I','6','O','N','H','P','J','PPN','L','L1')
                 OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND C.ISSUER_NAME NOT IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司',
                   '中国华融资产管理股份有限公司','中国信达资产管理股份有限公司','中国银河资产管理有限责任公司') ) THEN  '05' --05境内非金融企业债券投资
                 WHEN TRIM(A.ASSET_TYPE_ID) IN ('C5','61') THEN '07' --07境内证券业金融机构债券
                 WHEN TRIM(A.ASSET_TYPE_ID) IN ('C2') THEN '08' --08境内保险业金融机构债券
                 WHEN TRIM(A.ASSET_TYPE_ID) IN ('Z')  THEN '11' --11标准化票据
              ELSE S.A1411_INVEST_TYPE
              END AS A1411_INVEST_TYPE  --A1411投资分类代码
         ,CASE
             WHEN SUBSTR(A.STD_PROD_ID,0,5) = '30108' THEN '境内特定目的载体债券' --99境内特定目的载体债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('F','FL','FG','S') OR A.ACC_ID = 'X0007223B2700002205' OR B.BIO_FLG = 'N' THEN '境外债券投资' --10境外债券投资
             WHEN C.ISSUER_NAME IN ('中央汇金投资有限责任公司') THEN '境内其他金融机构债券' --09境内其他金融机构债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('1','M')  THEN '政府债券投资' --01政府债券投资
             WHEN TRIM(A.ASSET_TYPE_ID) = '5'  THEN  '中央银行债券' --02中央银行债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('8','9','U','7','X','Y','K')  THEN  '境内银行业存款类金融机构债券' --03境内银行业存款类金融机构债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('C6','C4','C1','C9') OR ( TRIM(A.ASSET_TYPE_ID) IN ('Q','4','D','G','E','V','I','6','O','N','H','P','J','PPN','L','L1')
             AND (B.FIN_ORG_TYP LIKE 'D%' OR B.FIN_ORG_TYP ='Z30000')) OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND C.ISSUER_NAME IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司',
               '中国华融资产管理股份有限公司','中国信达资产管理股份有限公司','中国银河资产管理有限责任公司') ) THEN '境内银行业非存款类金融机构债券' --06境内银行业非存款类金融机构债券(特殊情况：非金融企业债中金融机构类型是D开头的属于银行业非存款)
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('Q','4','D','G','E','V','I','6','O','N','H','P','J','PPN','L','L1')
             OR ( TRIM(A.ASSET_TYPE_ID) = 'C3' AND C.ISSUER_NAME NOT IN ('中国东方资产管理股份有限公司','中国长城资产管理股份有限公司',
               '中国华融资产管理股份有限公司','中国信达资产管理股份有限公司','中国银河资产管理有限责任公司') ) THEN  '境内非金融企业债券投资' --05境内非金融企业债券投资
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('C5','61') THEN '境内证券业金融机构债券' --07境内证券业金融机构债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('C2') THEN '境内保险业金融机构债券' --08境内保险业金融机构债券
             WHEN TRIM(A.ASSET_TYPE_ID) IN ('Z')  THEN '标准化票据' --11标准化票据
          ELSE S.A1411_INVEST_TYPE_NAME
          END AS A1411_INVEST_TYPE_NAME  --A1411投资分类名称
         ,A.SUBJ_ID                                         AS SUBJ_ID                      --科目代码
         ,F.LEVEL4_PROD_ID                                  AS  LEVEL4_PROD_ID              --四级产品编号
         ,F.LEVEL4_PROD_NAME                                AS  LEVEL4_PROD_NAME      --四级产品名称
         ,A.EVHA_VAL_CHAG_PL+A.SPD_PL+A.INT_INCOME          AS  INVEST_INCOME         --投资收入
         ,A.OVDUE_FLG                                       AS OVDUE_FLG  --逾期标志
         ,A.EVHA_VAL_CHAG_PL                 --公允价值变动损益
         ,A.SPD_PL                            --价差损益
         ,A.INT_INCOME                        --利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)   AS YEAR_EVHA_VAL_CHAG_PL   --本年公允价值变动损益
         ,NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)                       AS YEAR_SPD_PL             --本年价差损益
         ,NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)               AS YEAR_INT_INCOME         --本年利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)+NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)+NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)  AS  YEAR_INVEST_INCOME --本年投资收入
         ,A.ID                             AS ASSET_UNIQ_IDF_ID --资产唯一标识编号 ADD BY HYF 20231120
         ,G.DUBIL_ID                       AS CREDNO --借据编号 ADD BY HYF 20231120
         ,H.CONFMAMT                       AS CONFMAMT --分配我行确认价值 ADD BY HYF 20231120
         ,G.DIR_INDUS_CD                   AS LOAN_DIR_IDY --ADD BY HYF 20231214
         ,C.ESTATE_BOND_TYPE_NAME          AS ESTATE_BOND_TYPE_NAME --ADD BY HYF 20231214
         ,CASE WHEN B.CUST_BLNG_IDY LIKE 'K%' THEN 'Y'
          ELSE 'N' END                     AS S67_FDC_IND --S67房地产业标志
         ,A.OVD_DAYS                       AS OVDUE_DAYS --逾期天数 ADD BY HYF 20231215
         ,A.ACCT_B_CATE_CD                 AS ACCT_B_CATE_CD --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
         ,A.CASH_MANAGE_FLG                AS CASH_MANAGE_FLG --现金管理类产品标志 ADD BY HYF 20250211
         ,A.CORET_DURAN                    AS CORET_DURAN --修正久期 ADD BY HYF 20250314
        FROM RRP_MDL.M_CPTL_INVEST_INFO A --投资业务信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_FIN_INST_BOND_INFO C --债券基础信息
          ON A.ULYG_PROD_ID = C.BOND_ID
         AND A.DATA_SRC = C.DATA_SRC
         AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_FIN_INST_ULYG_INFO D --标的物基础信息
          ON A.ULYG_PROD_ID = D.ULYG_ID
         AND D.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CPTL_INVEST_DIR E --投资业务投向信息表
          ON A.ID = E.RID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO F
          ON A.STD_PROD_ID = F.PROD_ID
          AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO G --对公贷款借据信息
          ON A.ID = G.IBANK_ASSET_UNIQ_IDF_ID
         AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.S_G1102_BASE H --G1102报表分配价值
          ON H.CREDNO = G.DUBIL_ID
         AND H.DATA_DT = V_P_DATE
        LEFT JOIN CODE_MAP TB --五级分类转码
          ON TB.SRC_VALUE_CODE = G.LOAN_LEVEL5_CLS_CD
         AND TB.SRC_CLASS_CODE = 'CD1032'
         AND TB.TAR_CLASS_CODE = 'D0005'
         AND TB.MOD_FLG = 'MDM'
        LEFT JOIN RRP_MDL.S_CPTL_INVEST S
          ON A.ID = S.ID
         AND S.DATA_DT = '20240731'
       WHERE A.OPR_TYP = 'A' --自营
         AND A.DATA_SRC = '资金债券'
         AND A.DATA_DT = V_P_DATE ;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  --同业债券
  INSERT INTO S_CPTL_INVEST
      ( DATA_DT                          --数据日期
       ,LGL_REP_ID                       --法人编号
       ,ACC_ID                           --账户编号
       ,CUST_ID                          --客户编号
       ,CORP_CUST_TYP                    --对公客户类型
       ,ORG_NO                           --机构号
       ,FIN_ORG_TYP                      --金融机构类型
       ,FIN_ORG_NM                       --金融机构名称
       ,FIN_ORG_ID                       --金融机构编号
       ,BIO_FLG                          --境内外标志
       ,BOOK_BAL                         --账面余额
       ,CUR                              --币种
       ,INVEST_BIZ_VRTY                  --投资业务品种
       ,FIN_AST_CL                       --金融资产分类
       ,ULYG_PROD_ID                      --标准产品编号
       ,PROD_CL                          --产品分类
       ,MGT_MODE                         --管理方式
       ,ISU_SUBJ_RTG                     --发行主体评级
       ,PROD_RAISE_MODE                  --产品募集方式
       ,REGD_LAND_AREA_CD                --注册地行政区划代码
       ,BOND_ISU_MODE                    --债券发行方式
       ,FLT_RATE_TYP                     --浮动利率类型
       ,BOND_SUR_TERM                    --债券剩余期限
       ,ISU_DT                           --发行日期
       ,HOLD_UN_BOT_AST_LBY_BAL          --持有非底层资产产生的间接负债余额
       ,AST_SPRT_SCR_SUB_CL              --资产支持证券细类
       ,LVL5_CL                          --五级分类
       ,ACPT_ORG_TYP                     --承兑机构类型
       ,ORIG_BILL_HLDR_TYP               --原始持票人类型
       ,PRO_IMPT                         --减值准备
       ,EXP_DT                           --到期日期
       ,CRED_RTS_FIN_PROD_SUB_CL         --债权融资类产品细类
       ,GRN_INVEST_USEAGE_CL_1104        --绿色投资用途分类1104
       ,CER_MTG_INVEST_FLG               --以碳排放权为抵押的投资标志
       ,ER_MTG_INVEST_FLG                --以环境权益为抵押的投资标志
       ,DEPT_LINE                        --部门条线
       ,DATA_SRC                         --数据来源
       ,PROD_TYP                         --产品细类
       ,ID                               --业务主键
       ,BOND_ID                          --债券编号
       ,BOND_NAME                        --债券名称
       ,ASSET_TYPE_ID                    --原始债券类型代码
       ,ASSET_NAME                       --资产名称
       ,BOND_RTG                         --债券评级
       ,INVEST_TYP                       --投资大类代码
       ,INVEST_TYP_NAME                  --投资大类名称
       ,G31_INVEST_TYPE                  --G31投资分类
       ,G31_INVEST_TYPE_NAME             --G31投资分类名称
       ,A1411_INVEST_TYPE                --A1411投资分类代码
       ,A1411_INVEST_TYPE_NAME           --A1411投资分类名称
       ,SUBJ_ID                          --科目代码
       ,LEVEL4_PROD_ID                   --四级产品编号
       ,LEVEL4_PROD_NAME                 --四级产品名称
       ,INVEST_INCOME                    --投资收入
       ,OVDUE_FLG                        --逾期标志
       ,EVHA_VAL_CHAG_PL                 --公允价值变动损益
       ,SPD_PL                           --价差损益
       ,INT_INCOME                       --利息收入
       ,YEAR_EVHA_VAL_CHAG_PL            --本年公允价值变动损益
       ,YEAR_SPD_PL                      --本年价差损益
       ,YEAR_INT_INCOME                  --本年利息收入
       ,YEAR_INVEST_INCOME               --本年投资收入
       ,ASSET_UNIQ_IDF_ID                --资产唯一标识编号 ADD BY HYF 20231120
       ,CREDNO                           --借据编号 ADD BY HYF 20231120
       ,CONFMAMT                         --分配我行确认价值 ADD BY HYF 20231120
       ,LOAN_DIR_IDY                     --ADD BY HYF 20231214
       ,ESTATE_BOND_TYPE_NAME            --ADD BY HYF 20231214
       ,S67_FDC_IND                      --S67房地产业标志 ADD BY HYF 20231215
       ,OVDUE_DAYS                       --逾期天数 ADD BY HYF 20231215
       ,ACCT_B_CATE_CD                   --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
       ,CASH_MANAGE_FLG                  --现金管理类产品标志 ADD BY HYF 20250211
       ,CORET_DURAN                      --修正久期 ADD BY HYF 20250314
       )
      SELECT DISTINCT
             A.DATA_DT                                               AS DATA_DT                   --数据日期
             ,A.LGL_REP_ID                                           AS LGL_REP_ID                --法人编号
             ,A.ACC_ID                                               AS ACC_ID                    --账户编号
             ,A.CUST_ID                                              AS CUST_ID                   --客户编号
             ,B.CUST_CL                                              AS CORP_CUST_TYP             --对公客户类型
             ,A.ORG_ID                                               AS ORG_NO                    --机构号
             ,B.FIN_ORG_TYP                                          AS FIN_ORG_TYP               --金融机构类型
             ,B.CUST_NM                                              AS FIN_ORG_NM                --金融机构名称
             ,B.FIN_ORG_ID                                           AS FIN_ORG_ID                --金融机构编号
             ,B.BIO_FLG                                              AS BIO_FLG                   --境内外标志
             --A.BOOK_BAL                                             AS BOOK_BAL,                  --账面余额
             ,NVL(A.NV_BAL,0)+NVL(A.FAIR_VAL,0)+NVL(A.INT_ADJ_AMT,0)+NVL(A.ACRU_INT_AMT,0)
                                                                     AS BOOK_BAL                  --账面余额 20231023
             ,A.CUR                                                  AS CUR                       --币种
             ,A.INVEST_BIZ_VRTY                                      AS INVEST_BIZ_VRTY           --投资业务品种
             ,A.FIN_AST_CL                                           AS FIN_AST_CL                --金融资产分类
             ,A.STD_PROD_ID                                          AS STD_PROD_ID               --标准产品编号
             ,NVL(C.PROD_CL, D.ULYG_PROD_CL)                         AS PROD_CL                   --产品分类
             ,A.MGT_MOD                                              AS MGT_MODE                  --管理方式
             ,NVL(C.ISU_SUBJ_RTG,'C00')                              AS ISU_SUBJ_RTG              --发行主体评级
             ,A.PROD_RAISE_MODE                                      AS PROD_RAISE_MODE           --产品募集方式
             ,B.REGD_LAND_AREA_CD                                    AS REGD_LAND_AREA_CD         --注册地行政区划代码
             ,C.BOND_ISU_MODE                                        AS BOND_ISU_MODE             --债券发行方式
             ,C.FLT_RATE_TYP                                         AS FLT_RATE_TYP              --浮动利率类型
             ,TO_DATE(C.EXP_DT, 'YYYY-MM-DD') -TO_DATE(V_P_DATE,'YYYYMMDD')  AS BOND_SUR_TERM     --债券剩余期限
             ,C.ISU_DT                                               AS ISU_DT                    --发行日期
             ,A.HOLD_UN_BOT_AST_LBY_BAL                              AS HOLD_UN_BOT_AST_LBY_BAL   --持有非底层资产产生的间接负债余额
             ,E.AST_SPRT_SCR_SUB_CL                                  AS AST_SPRT_SCR_SUB_CL       --资产支持证券细类
             --A.LVL5_CL                                              AS LVL5_CL,                   --五级分类
             ,NVL(TB.TAR_VALUE_CODE, '01')                           AS LVL5_CL                   --五级分类
             ,D.ACPT_ORG_TYP                                         AS ACPT_ORG_TYP              --承兑机构类型
             ,D.ORIG_BILL_HLDR_TYP                                   AS ORIG_BILL_HLDR_TYP        --原始持票人类型
             ,A.PRO_IMPT                                             AS PRO_IMPT                  -- 减值准备
             ,C.EXP_DT                                               AS EXP_DT                    -- 到期日期
             ,E.CRED_RTS_FIN_PROD_SUB_CL                             AS CRED_RTS_FIN_PROD_SUB_CL  -- 债权融资类产品细类
             ,C.GRN_INVEST_USEAGE_CL_1104                            AS GRN_INVEST_USEAGE_CL_1104 -- 绿色投资用途分类1104
             ,C.CER_MTG_INVEST_FLG                                   AS CER_MTG_INVEST_FLG        -- 以碳排放权为抵押的投资标志
             ,C.ER_MTG_INVEST_FLG                                    AS ER_MTG_INVEST_FLG         -- 以环境权益为抵押的投资标志
             ,A.DEPT_LINE                                            AS DEPT_LINE                 --部门条线
             ,A.DATA_SRC                                             AS DATA_SRC                  --数据来源
             ,CASE WHEN C.PROD_CL  =  'A0101' THEN 'GB01'
                   WHEN C.PROD_CL  =  'A0102' THEN 'GB02'
                   WHEN C.PROD_CL  =  'A0103' THEN 'GB03'
                   WHEN C.PROD_CL  =  'A0201' THEN 'GB042'
                   WHEN C.PROD_CL  =  'A0202' THEN 'GB041'
                   WHEN C.PROD_CL  =  'A03'   THEN 'CB01'
                   WHEN C.PROD_CL  =  'B01'   THEN 'CBN'
                   WHEN C.PROD_CL  =  'B02'   THEN 'FB00'
                   WHEN C.PROD_CL  =  'B0301' THEN 'FB01'
                   WHEN C.PROD_CL  =  'B0302' THEN 'FB02'
                   WHEN C.PROD_CL  =  'B0303' THEN 'FB03'
                   WHEN C.PROD_CL  =  'B0304' THEN 'FB04'
                   WHEN C.PROD_CL  =  'B0305' THEN 'FB05'
                   WHEN C.PROD_CL  =  'B0306' THEN 'FB06'
                   WHEN C.PROD_CL  =  'C01'   THEN 'CB01'
                   WHEN C.PROD_CL  =  'C0101' THEN 'CB02'
                   WHEN C.PROD_CL  =  'C0102' THEN 'CB01'
                   WHEN C.PROD_CL  =  'C0201' THEN 'CB04'
                   WHEN C.PROD_CL  =  'C0202' THEN 'CB05'
                   WHEN C.PROD_CL  =  'C02'   THEN 'CB03'
                   WHEN C.PROD_CL  =  'C03'   THEN 'CB06'
                   WHEN C.PROD_CL  =  'C0301' THEN 'MTN'
                   WHEN C.PROD_CL  =  'C0302' THEN 'CP'
                   WHEN C.PROD_CL  =  'C0303' THEN 'SCP'
                   WHEN C.PROD_CL  =  'C0304' THEN 'SMECN1'
                   WHEN C.PROD_CL  =  'C0305' THEN 'SMECN2'
                   WHEN C.PROD_CL  =  'C0306' THEN 'PPN'
                   WHEN C.PROD_CL  =  'C0307' THEN 'ABN'
                   WHEN C.PROD_CL  =  'C0308' THEN 'PRB'
                   WHEN C.PROD_CL  =  'C0309' THEN 'PRN'
                   WHEN C.PROD_CL  =  'D01'   THEN 'ABS01'
                   WHEN C.PROD_CL  =  'D02'   THEN 'ABS02'
                   WHEN C.PROD_CL  =  'F01'   THEN 'MDBB'
                   ELSE  'TB99'
                END                                              AS PROD_TYP                   --产品细类 20221101 mw根据业务要求划分产品细类                                           AS PROD_TYP                   --产品细类
              ,A.ID                                              AS ID                         --业务主键
              ,C.BOND_ID                                         AS BOND_ID                    --债券编号
              ,C.PROD_NM                                         AS BOND_NAME                  --债券名称
              ,NVL(C.ASSET_TYPE_ID,A.ASSET_TYPE_ID)              AS ASSET_TYPE_ID              --原始债券代码
              ,NVL(C.ASSET_NAME,A.ASSET_NAME)                    AS ASSET_NAME                 --资产名称
              ,NVL(C.RATING_REST_CD,'C00')                       AS BOND_RTG                   --债券评级
              ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '00'
                    ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '05'
                              WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '04'
                              WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                                OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '12'
                              WHEN A.ASSET_NAME LIKE '%基金%' THEN '01'
                              WHEN A.ASSET_NAME LIKE '%票据资管计划%' THEN '00'
                              ELSE '99' END
                END                                              AS INVEST_TYP                  --投资大类代码
              ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '债券投资'
                    ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '理财产品投资'
                    WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托产品投资'
                    WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                      OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '资产管理产品'
                    WHEN A.ASSET_NAME LIKE '%基金%' THEN '基金投资'
                    WHEN A.ASSET_NAME LIKE '%票据资管计划%' THEN '债券投资'
                    ELSE '其它投资' END
                END                                              AS INVEST_TYP_NAME              --投资大类名称
              ,CASE WHEN TRIM(A.ASSET_NAME) = '国债'  THEN '1.1' --1.1国债
                    WHEN TRIM(A.ASSET_NAME) = '地方政府债'  AND C.PROD_CL = 'B0201' THEN '1.2.1' --1.2.1地方政府专项债券
                    WHEN TRIM(A.ASSET_NAME) = '地方政府债'  THEN '1.2.2' --1.2.2普通地方政府债券
                    WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN  '1.3' --1.3央票
                    WHEN TRIM(A.ASSET_NAME) = '政策银行债'  THEN  '1.4' --1.4政策性金融债
                    WHEN TRIM(A.ASSET_NAME) = '政府支持机构债'  THEN  '1.5' --1.5政府机构债券
                    WHEN TRIM(A.ASSET_NAME) IN ( '商业银行债','商业银行次级债券','证券公司债','证券公司短期融资券','保险公司债','其它金融机构债') THEN '1.6' --1.6商业性金融债
                    WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债')  THEN '1.7.1' --1.7.1企业债
                    WHEN TRIM(A.ASSET_NAME) IN ('一般公司债','其他债券') THEN '1.7.2' --1.7.2公司债(数据问题部分公司债落到其他债券)
                    WHEN TRIM(A.ASSET_NAME) IN ('资产支持证券-金融机构类','资产支持证券-企业类')  THEN '1.8.2' --1.8.2交易所资产支持证券
                    WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '1.8.3' --1.9外国债券
                END                                             AS G31_INVEST_TYPE  --G31投资分类
             ,CASE WHEN TRIM(A.ASSET_NAME) = '国债'  THEN '国债' --1.1国债
                   WHEN TRIM(A.ASSET_NAME) = '地方政府债'  AND C.PROD_CL = 'B0201' THEN '1.2.1' --1.2.1地方政府专项债券
                   WHEN TRIM(A.ASSET_NAME) = '地方政府债'  THEN '地方政府专项债券' --1.2.2普通地方政府债券
                   WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN  '央票' --1.3央票
                   WHEN TRIM(A.ASSET_NAME) = '政策银行债'  THEN  '政策性金融债' --1.4政策性金融债
                   WHEN TRIM(A.ASSET_NAME) = '政府支持机构债'  THEN  '政府机构债券' --1.5政府机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ( '商业银行债','商业银行次级债券','证券公司债','证券公司短期融资券','保险公司债','其它金融机构债') THEN '商业性金融债' --1.6商业性金融债
                   WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债')  THEN '企业债' --1.7.1企业债
                   WHEN TRIM(A.ASSET_NAME) IN ('一般公司债','其他债券') THEN '公司债' --1.7.2公司债(数据问题部分公司债落到其他债券)
                   WHEN TRIM(A.ASSET_NAME) IN ('资产支持证券-金融机构类','资产支持证券-企业类')  THEN '交易所资产支持证券' --1.8.2交易所资产支持证券
                   WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '外国债券' --1.9外国债券
               END                                              AS G31_INVEST_TYPE_NAME  --G31投资分类名称
             ,CASE WHEN SUBSTR(A.STD_PROD_ID,0,5) = '30108' THEN '99' --99境内特定目的载体债券
                   WHEN C.ISSUER_NAME IN ('中央汇金投资有限责任公司') OR TRIM(A.ASSET_NAME) = '其它金融机构债'  THEN  '09' --09境内其他金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ('国债','地方政府债')  THEN '01' --01政府债券投资
                   WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN '02' --02中央银行债券
                   WHEN TRIM(A.ASSET_NAME) IN ( '政策银行债','商业银行债','商业银行次级债券' ) THEN '03' --03境内银行业存款类金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债','一般公司债','其他债券' ) THEN '05' --05境内非金融企业债券投资
                   WHEN TRIM(A.ASSET_NAME) IN ( '证券公司债','证券公司短期融资券' ) THEN '07' --07境内证券业金融机构债券
                   WHEN TRIM(A.ASSET_NAME) = '保险公司债'  THEN  '08' --08境内保险业金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '10' --10境外债券投资
                   ELSE S.A1411_INVEST_TYPE
               END                                              AS A1411_INVEST_TYPE  --A1411投资分类代码
             ,CASE WHEN SUBSTR(A.STD_PROD_ID,0,5) = '30108' THEN '境内特定目的载体债券' --99境内特定目的载体债券
                   WHEN C.ISSUER_NAME IN ('中央汇金投资有限责任公司') OR TRIM(A.ASSET_NAME) = '其它金融机构债' THEN  '境内其他金融机构债券' --09境内其他金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ('国债','地方政府债')  THEN '政府债券投资' --01政府债券投资
                   WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN '中央银行债券' --02中央银行债券
                   WHEN TRIM(A.ASSET_NAME) IN ( '政策银行债','商业银行债','商业银行次级债券' ) THEN '境内银行业存款类金融机构债券' --03境内银行业存款类金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债','一般公司债','其他债券' ) THEN '境内非金融企业债券投资' --05境内非金融企业债券投资
                   WHEN TRIM(A.ASSET_NAME) IN ( '证券公司债','证券公司短期融资券' ) THEN '境内证券业金融机构债券' --07境内证券业金融机构债券
                   WHEN TRIM(A.ASSET_NAME) = '保险公司债'  THEN  '境内保险业金融机构债券' --08境内保险业金融机构债券
                   WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '境外债券投资' --10境外债券投资
                   ELSE S.A1411_INVEST_TYPE_NAME
               END                                              AS A1411_INVEST_TYPE_NAME  --A1411投资分类名称
             ,A.SUBJ_ID                                         AS SUBJ_ID                      --科目代码
             ,F.LEVEL4_PROD_ID                                  AS LEVEL4_PROD_ID               --四级产品编号
             ,F.LEVEL4_PROD_NAME                                AS LEVEL4_PROD_NAME             --四级产品名称
             ,A.EVHA_VAL_CHAG_PL+A.SPD_PL+A.INT_INCOME          AS INVEST_INCOME                --投资收入
             ,A.OVDUE_FLG                                       AS OVDUE_FLG                    --逾期标志
             ,A.EVHA_VAL_CHAG_PL                                                                --公允价值变动损益
             ,A.SPD_PL                                                                          --价差损益
             ,A.INT_INCOME                                                                      --利息收入
             ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)   AS YEAR_EVHA_VAL_CHAG_PL   --本年公允价值变动损益
             ,NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)                       AS YEAR_SPD_PL             --本年价差损益
             ,NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)               AS YEAR_INT_INCOME         --本年利息收入
             ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)+NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)+NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)  AS  YEAR_INVEST_INCOME --本年投资收入
             ,A.ASSET_UNIQ_IDF_ID                                AS ASSET_UNIQ_IDF_ID           --资产唯一标识编号 ADD BY HYF 20231120
             ,G.DUBIL_ID                                         AS CREDNO                      --借据编号 ADD BY HYF 20231120
             ,H.CONFMAMT                                         AS CONFMAMT                    --分配我行确认价值 ADD BY HYF 20231120
             ,G.DIR_INDUS_CD                                     AS LOAN_DIR_IDY                --ADD BY HYF 20231214
             ,C.ESTATE_BOND_TYPE_NAME                            AS ESTATE_BOND_TYPE_NAME       --ADD BY HYF 20231214
             ,CASE WHEN E.FNL_DIR_IDY = '6' THEN 'Y'
              ELSE 'N' END                                       AS S67_FDC_IND                 --S67房地产业标志 ADD BY HYF 20231215
             ,A.OVD_DAYS                                         AS OVDUE_DAYS                  --逾期天数 ADD BY HYF 20231215
             ,A.ACCT_B_CATE_CD                                   AS ACCT_B_CATE_CD              --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
             ,A.CASH_MANAGE_FLG                                  AS CASH_MANAGE_FLG             --现金管理类产品标志 ADD BY HYF 20250211
             ,A.CORET_DURAN                                      AS CORET_DURAN                 --修正久期 ADD BY HYF 20250211
        FROM RRP_MDL.M_CPTL_INVEST_INFO A --投资业务信息
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_FIN_INST_BOND_INFO C --债券基础信息
          ON A.ULYG_PROD_ID = C.BOND_ID
         AND A.DATA_SRC = C.DATA_SRC
         AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_FIN_INST_ULYG_INFO D --标的物基础信息
          ON A.ULYG_PROD_ID = D.ULYG_ID
         AND D.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CPTL_INVEST_DIR E --投资业务投向信息表
          ON A.ID = E.RID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO F
          ON A.STD_PROD_ID = F.PROD_ID
         AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO G --对公贷款借据信息
          ON A.ASSET_UNIQ_IDF_ID = G.IBANK_ASSET_UNIQ_IDF_ID
         AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.S_G1102_BASE H --G1102报表分配价值
          ON H.CREDNO = G.DUBIL_ID
         AND H.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST I
          ON I.FIN_INSTM_ID || '_' || I.ASSET_THD_CLS_CD || '_' || I.INTNAL_SECU_ACCT_ID = A.ID
         AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN CODE_MAP TB --五级分类转码
          ON TB.SRC_VALUE_CODE = G.LOAN_LEVEL5_CLS_CD
         AND TB.SRC_CLASS_CODE = 'CD1032'
         AND TB.TAR_CLASS_CODE = 'D0005'
         AND TB.MOD_FLG = 'MDM'
       LEFT JOIN RRP_MDL.S_CPTL_INVEST S
         ON A.ID = S.ID
        AND S.DATA_DT = '20240731'
      WHERE A.OPR_TYP = 'A' --自营
        AND A.DATA_SRC = '同业债券'
        AND A.DATA_DT = V_P_DATE;
        
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  --同业非标、净值产品及货币基金
  INSERT INTO S_CPTL_INVEST
      (DATA_DT                          --数据日期
       ,LGL_REP_ID                       --法人编号
       ,ACC_ID                           --账户编号
       ,CUST_ID                          --客户编号
       ,CORP_CUST_TYP                    --对公客户类型
       ,ORG_NO                           --机构号
       ,FIN_ORG_TYP                      --金融机构类型
       ,FIN_ORG_NM                       --金融机构名称
       ,FIN_ORG_ID                       --金融机构编号
       ,BIO_FLG                          --境内外标志
       ,BOOK_BAL                         --账面余额
       ,CUR                              --币种
       ,INVEST_BIZ_VRTY                  --投资业务品种
       ,FIN_AST_CL                       --金融资产分类
       ,ULYG_PROD_ID                      --标准产品编号
       ,PROD_CL                          --产品分类
       ,MGT_MODE                         --管理方式
       ,ISU_SUBJ_RTG                     --发行主体评级
       ,PROD_RAISE_MODE                  --产品募集方式
       ,REGD_LAND_AREA_CD                --注册地行政区划代码
       ,BOND_ISU_MODE                    --债券发行方式
       ,FLT_RATE_TYP                     --浮动利率类型
       ,BOND_SUR_TERM                    --债券剩余期限
       ,ISU_DT                           --发行日期
       ,HOLD_UN_BOT_AST_LBY_BAL          --持有非底层资产产生的间接负债余额
       ,AST_SPRT_SCR_SUB_CL              --资产支持证券细类
       ,LVL5_CL                          --五级分类
       ,ACPT_ORG_TYP                     --承兑机构类型
       ,ORIG_BILL_HLDR_TYP               --原始持票人类型
       ,PRO_IMPT                         --减值准备
       ,EXP_DT                           --到期日期
       ,CRED_RTS_FIN_PROD_SUB_CL         --债权融资类产品细类
       ,GRN_INVEST_USEAGE_CL_1104        --绿色投资用途分类1104
       ,CER_MTG_INVEST_FLG               --以碳排放权为抵押的投资标志
       ,ER_MTG_INVEST_FLG                --以环境权益为抵押的投资标志
       ,DEPT_LINE                        --部门条线
       ,DATA_SRC                         --数据来源
       ,PROD_TYP                         --产品细类
       ,ID                               --业务主键
       ,BOND_ID                          --债券编号
       ,BOND_NAME                        --债券名称
       ,ASSET_TYPE_ID                    --原始债券类型代码
       ,ASSET_NAME                       --资产名称
       ,BOND_RTG                         --债券评级
       ,INVEST_TYP                       --投资大类代码
       ,INVEST_TYP_NAME                  --投资大类名称
       ,G31_INVEST_TYPE                  --G31投资分类
       ,G31_INVEST_TYPE_NAME             --G31投资分类名称
       ,A1411_INVEST_TYPE                --A1411投资分类代码
       ,A1411_INVEST_TYPE_NAME           --A1411投资分类名称
       ,SUBJ_ID                          --科目代码
       ,LEVEL4_PROD_ID                   --四级产品编号
       ,LEVEL4_PROD_NAME                 --四级产品名称
       ,INVEST_INCOME                    --投资收入
       ,OVDUE_FLG                        --逾期标志
       ,EVHA_VAL_CHAG_PL                 --公允价值变动损益
       ,SPD_PL                           --价差损益
       ,INT_INCOME                       --利息收入
       ,YEAR_EVHA_VAL_CHAG_PL            --本年公允价值变动损益
       ,YEAR_SPD_PL                      --本年价差损益
       ,YEAR_INT_INCOME                  --本年利息收入
       ,YEAR_INVEST_INCOME               --本年投资收入
       ,TH_MON_INT_INCOME                --本月利息收入
       ,FSXZC_FLG                        --非生息资产标志
       ,ASSET_UNIQ_IDF_ID                --资产唯一标识编号 ADD BY HYF 20231120
       ,CREDNO                           --借据编号 ADD BY HYF 20231120
       ,CONFMAMT                         --分配我行确认价值 ADD BY HYF 20231120
       ,LOAN_DIR_IDY                     --ADD BY HYF 20231214
       ,ESTATE_BOND_TYPE_NAME            --ADD BY HYF 20231214
       ,S67_FDC_IND                      --S67房地产业标志 ADD BY HYF 20231215
       ,OVDUE_DAYS                       --逾期天数 ADD BY HYF 20231215
       ,ACCT_B_CATE_CD                   --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
       ,CASH_MANAGE_FLG                  --现金管理类产品标志 ADD BY HYF 20250211
       )
      SELECT DISTINCT
             A.DATA_DT                                              AS DATA_DT,          --数据日期
             A.LGL_REP_ID                                           AS LGL_REP_ID,                --法人编号
             A.ACC_ID                                               AS ACC_ID,                    --账户编号
             A.CUST_ID                                              AS CUST_ID,                   --客户编号
             B.CUST_CL                                              AS CORP_CUST_TYP,             --对公客户类型
             A.ORG_ID                                               AS ORG_NO,                    --机构号
             B.FIN_ORG_TYP                                          AS FIN_ORG_TYP,               --金融机构类型
             B.CUST_NM                                              AS FIN_ORG_NM,                --金融机构名称
             B.FIN_ORG_ID                                           AS FIN_ORG_ID,                --金融机构编号
             B.BIO_FLG                                              AS BIO_FLG,                   --境内外标志
             --A.BOOK_BAL                                             AS BOOK_BAL,                  --账面余额
             NVL(A.NV_BAL,0)+NVL(A.FAIR_VAL,0)+NVL(A.INT_ADJ_AMT,0)+NVL(A.ACRU_INT_AMT,0)
                                                                    AS BOOK_BAL,                  --账面余额 20231023
             A.CUR                                                  AS CUR,                       --币种
             A.INVEST_BIZ_VRTY                                      AS INVEST_BIZ_VRTY,           --投资业务品种
             A.FIN_AST_CL                                           AS FIN_AST_CL,                --金融资产分类
             A.STD_PROD_ID                                          AS STD_PROD_ID,               --标准产品编号
             NVL(C.PROD_CL, D.ULYG_PROD_CL)                         AS PROD_CL,                   --产品分类
             A.MGT_MOD                                              AS MGT_MODE,                  --管理方式
             NVL(C.ISU_SUBJ_RTG,'C00')                              AS ISU_SUBJ_RTG,              --发行主体评级
             A.PROD_RAISE_MODE                                      AS PROD_RAISE_MODE,           --产品募集方式
             B.REGD_LAND_AREA_CD                                    AS REGD_LAND_AREA_CD,         --注册地行政区划代码
             C.BOND_ISU_MODE                                        AS BOND_ISU_MODE,             --债券发行方式
             C.FLT_RATE_TYP                                         AS FLT_RATE_TYP,              --浮动利率类型
             TO_DATE(C.EXP_DT, 'YYYY-MM-DD') -TO_DATE(V_P_DATE,'YYYYMMDD')  AS BOND_SUR_TERM,     --债券剩余期限
             C.ISU_DT                                               AS ISU_DT,                    --发行日期
             A.HOLD_UN_BOT_AST_LBY_BAL                              AS HOLD_UN_BOT_AST_LBY_BAL,   --持有非底层资产产生的间接负债余额
             E.AST_SPRT_SCR_SUB_CL                                  AS AST_SPRT_SCR_SUB_CL,       --资产支持证券细类
             --A.LVL5_CL                                              AS LVL5_CL,                   --五级分类
             NVL(TB.TAR_VALUE_CODE, '01')                           AS LVL5_CL,                   --五级分类
             D.ACPT_ORG_TYP                                         AS ACPT_ORG_TYP,              --承兑机构类型
             D.ORIG_BILL_HLDR_TYP                                   AS ORIG_BILL_HLDR_TYP,        --原始持票人类型
             A.PRO_IMPT                                             AS PRO_IMPT                 , -- 减值准备
             C.EXP_DT                                               AS EXP_DT                   , -- 到期日期
             E.CRED_RTS_FIN_PROD_SUB_CL                             AS CRED_RTS_FIN_PROD_SUB_CL , -- 债权融资类产品细类
             C.GRN_INVEST_USEAGE_CL_1104                            AS GRN_INVEST_USEAGE_CL_1104, -- 绿色投资用途分类1104
             C.CER_MTG_INVEST_FLG                                   AS CER_MTG_INVEST_FLG       , -- 以碳排放权为抵押的投资标志
             C.ER_MTG_INVEST_FLG                                    AS ER_MTG_INVEST_FLG        , -- 以环境权益为抵押的投资标志
             A.DEPT_LINE                                            AS DEPT_LINE,                 --部门条线
             A.DATA_SRC                                             AS DATA_SRC,                  --数据来源
             CASE WHEN C.PROD_CL='A0101' THEN 'GB01'
                  WHEN C.PROD_CL='A0102' THEN 'GB02'
                  WHEN C.PROD_CL='A0103' THEN 'GB03'
                  WHEN C.PROD_CL='A0201' THEN 'GB042'
                  WHEN C.PROD_CL='A0202' THEN 'GB041'
                  WHEN C.PROD_CL='A03' THEN 'CB01'
                  WHEN C.PROD_CL='B01' THEN 'CBN'
                  WHEN C.PROD_CL='B02' THEN 'FB00'
                  WHEN C.PROD_CL='B0301' THEN 'FB01'
                  WHEN C.PROD_CL='B0302' THEN 'FB02'
                  WHEN C.PROD_CL='B0303' THEN 'FB03'
                  WHEN C.PROD_CL='B0304' THEN 'FB04'
                  WHEN C.PROD_CL='B0305' THEN 'FB05'
                  WHEN C.PROD_CL='B0306' THEN 'FB06'
                  WHEN C.PROD_CL='C01' THEN 'CB01'
                  WHEN C.PROD_CL='C0101' THEN 'CB02'
                  WHEN C.PROD_CL='C0102' THEN 'CB01'
                  WHEN C.PROD_CL='C0201' THEN 'CB04'
                  WHEN C.PROD_CL='C0202' THEN 'CB05'
                  WHEN C.PROD_CL='C02' THEN 'CB03'
                  WHEN C.PROD_CL='C03' THEN 'CB06'
                  WHEN C.PROD_CL='C0301' THEN 'MTN'
                  WHEN C.PROD_CL='C0302' THEN 'CP'
                  WHEN C.PROD_CL='C0303' THEN 'SCP'
                  WHEN C.PROD_CL='C0304' THEN 'SMECN1'
                  WHEN C.PROD_CL='C0305' THEN 'SMECN2'
                  WHEN C.PROD_CL='C0306' THEN 'PPN'
                  WHEN C.PROD_CL='C0307' THEN 'ABN'
                  WHEN C.PROD_CL='C0308' THEN 'PRB'
                  WHEN C.PROD_CL='C0309' THEN 'PRN'
                  WHEN C.PROD_CL='D01' THEN 'ABS01'
                  WHEN C.PROD_CL='D02' THEN 'ABS02'
                  WHEN C.PROD_CL='F01' THEN 'MDBB'
                  ELSE  'TB99'
                  END                                               AS PROD_TYP                   --产品细类 20221101 mw根据业务要求划分产品细类                                           AS PROD_TYP                   --产品细类
                 ,A.ID                                              AS ID                         --业务主键
                 ,C.BOND_ID                                         AS BOND_ID                    --债券编号
                 ,C.PROD_NM                                         AS BOND_NAME                  --债券名称
                 ,NVL(C.ASSET_TYPE_ID,A.ASSET_TYPE_ID)              AS ASSET_TYPE_ID              --原始债券代码
                 ,NVL(C.ASSET_NAME,A.ASSET_NAME)                    AS ASSET_NAME                 --资产名称
                 ,NVL(C.RATING_REST_CD,'C00')                       AS BOND_RTG                   --债券评级
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '00'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '05'
                    WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '04'
                  WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                       OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '12'
                  WHEN  A.ASSET_NAME LIKE '%基金%' THEN '01'
                  WHEN  A.ASSET_NAME LIKE '%票据资管计划%' THEN '00'
               ELSE '99' END
          END                                               AS INVEST_TYP                  --投资大类代码
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '债券投资'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%理财%' THEN '理财产品投资'
                    WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托产品投资'
                  WHEN A.ASSET_NAME LIKE '%交易所资产支持证券%' OR (A.ASSET_NAME LIKE '%资管%' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' )
                       OR A.ASSET_NAME LIKE '%交易所公司债%' OR A.ASSET_NAME LIKE '%资产管理产品%'  OR  A.ASSET_NAME LIKE '%资产管理计划%' THEN '资产管理产品'
                  WHEN  A.ASSET_NAME LIKE '%基金%' THEN '基金投资'
                  WHEN  A.ASSET_NAME LIKE '%票据资管计划%' THEN '债券投资'
               ELSE '其它投资' END
          END                                               AS INVEST_TYP_NAME              --投资大类名称
         ,CASE WHEN TRIM(A.ASSET_NAME) = '国债'  THEN '1.1' --1.1国债
               WHEN TRIM(A.ASSET_NAME) = '地方政府债'  AND C.PROD_CL = 'B0201' THEN '1.2.1' --1.2.1地方政府专项债券
               WHEN TRIM(A.ASSET_NAME) = '地方政府债'  THEN '1.2.2' --1.2.2普通地方政府债券
               WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN  '1.3' --1.3央票
               WHEN TRIM(A.ASSET_NAME) = '政策银行债'  THEN  '1.4' --1.4政策性金融债
               WHEN TRIM(A.ASSET_NAME) = '政府支持机构债'  THEN  '1.5' --1.5政府机构债券
               WHEN TRIM(A.ASSET_NAME) IN ( '商业银行债','商业银行次级债券','证券公司债','证券公司短期融资券','保险公司债','其它金融机构债') THEN '1.6' --1.6商业性金融债
               WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债')  THEN '1.7.1' --1.7.1企业债
               WHEN TRIM(A.ASSET_NAME) IN ('一般公司债','其他债券') THEN '1.7.2' --1.7.2公司债(数据问题部分公司债落到其他债券)
               WHEN TRIM(A.ASSET_NAME) IN ('资产支持证券-金融机构类','资产支持证券-企业类')  THEN '1.8.2' --1.8.2交易所资产支持证券
               WHEN TRIM(A.ASSET_NAME) LIKE '%票据资管计划%' THEN '1.8.3' --1.8.3资产支持票据
               WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '1.9' --1.9外国债券
               WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN '3.1' --3.1债券基金
               WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN '3.2' --3.2货币市场基金
               WHEN F.LEVEL4_PROD_ID IN ('3030301') THEN '3.3' --3.3股票基金
               WHEN F.LEVEL4_PROD_ID IN ('3030401') THEN '3.4' --3.4基金中基金
               WHEN F.LEVEL4_PROD_ID IN ('3030501') THEN '3.5' --3.5混合基金
               WHEN TRIM(A.ASSET_NAME) LIKE '%理财%' THEN '5.1' --5.1他行非保本理财产品
               WHEN TRIM(A.ASSET_NAME) LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '5.2' --5.2信托产品
               WHEN F.LEVEL4_PROD_ID IN ('3040301','3040303','3040304') OR A.STD_PROD_ID = '304030200001' THEN '5.3' --5.3证券业资产管理产品（不含公募基金）
               WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN '5.4' --5.4保险业资产管理产品
               WHEN F.LEVEL4_PROD_ID IN ('3040501','3040502') THEN '5.5' --5.5其他资产管理产品
               WHEN F.LEVEL4_PROD_ID IN ('3060101') THEN '4.1' --4.1私募证券投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060201') THEN '4.2' --4.2私募股权投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060301') THEN '4.3' --4.3私募创业投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060401') THEN '4.4' --4.4其他私募基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3070101','3070201','3070301') OR A.STD_PROD_ID = '307030200001' THEN '6.1' --6.1其他交易平台债权融资工具
               WHEN A.STD_PROD_ID = '307030200002' THEN '7' --7.以上未包括的投资项目（非底层资产）
               WHEN F.LEVEL4_PROD_ID IN ('3080101','3080201') THEN '2.3' --2.3非上市股权（剔除已计入2.1的部分）
          END AS G31_INVEST_TYPE  --G31投资分类
         ,CASE WHEN TRIM(A.ASSET_NAME) = '国债'  THEN '国债' --1.1国债
               WHEN TRIM(A.ASSET_NAME) = '地方政府债'  AND C.PROD_CL = 'B0201' THEN '1.2.1' --1.2.1地方政府专项债券
               WHEN TRIM(A.ASSET_NAME) = '地方政府债'  THEN '地方政府专项债券' --1.2.2普通地方政府债券
               WHEN TRIM(A.ASSET_NAME) = '央行票据'    THEN  '央票' --1.3央票
               WHEN TRIM(A.ASSET_NAME) = '政策银行债'  THEN  '政策性金融债' --1.4政策性金融债
               WHEN TRIM(A.ASSET_NAME) = '政府支持机构债'  THEN  '政府机构债券' --1.5政府机构债券
               WHEN TRIM(A.ASSET_NAME) IN ( '商业银行债','商业银行次级债券','证券公司债','证券公司短期融资券','保险公司债','其它金融机构债') THEN '商业性金融债' --1.6商业性金融债
               WHEN TRIM(A.ASSET_NAME) IN ( '一般企业债','集合企业债')  THEN '企业债' --1.7.1企业债
               WHEN TRIM(A.ASSET_NAME) IN ('一般公司债','其他债券') THEN '公司债' --1.7.2公司债(数据问题部分公司债落到其他债券)
               WHEN TRIM(A.ASSET_NAME) IN ('资产支持证券-金融机构类','资产支持证券-企业类')  THEN '交易所资产支持证券' --1.8.2交易所资产支持证券
               WHEN TRIM(A.ASSET_NAME) LIKE '%票据资管计划%' THEN '资产支持票据' --1.8.3资产支持票据
               WHEN TRIM(A.ASSET_NAME) IN ('国际机构债')  THEN '外国债券' --1.9外国债券
               WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN '债券基金' --3.1债券基金
               WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN '货币市场基金' --3.2货币市场基金
               WHEN F.LEVEL4_PROD_ID IN ('3030301') THEN '股票基金' --3.3股票基金
               WHEN F.LEVEL4_PROD_ID IN ('3030401') THEN '基金中基金' --3.4基金中基金
               WHEN F.LEVEL4_PROD_ID IN ('3030501') THEN '混合基金' --3.5混合基金
               WHEN TRIM(A.ASSET_NAME) LIKE '%理财%' THEN '他行非保本理财产品' --5.1他行非保本理财产品
               WHEN TRIM(A.ASSET_NAME) LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托产品' --5.2信托产品
               WHEN F.LEVEL4_PROD_ID IN ('3040301','3040303','3040304') OR A.STD_PROD_ID = '304030200001' THEN '证券业资产管理产品（不含公募基金）' --5.3证券业资产管理产品（不含公募基金）
               WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN '保险业资产管理产品' --5.4保险业资产管理产品
               WHEN F.LEVEL4_PROD_ID IN ('3040501','3040502') THEN '其他资产管理产品' --5.5其他资产管理产品
               WHEN F.LEVEL4_PROD_ID IN ('3060101') THEN '4.1' --4.1私募证券投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060201') THEN '4.2' --4.2私募股权投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060301') THEN '4.3' --4.3私募创业投资基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3060401') THEN '4.4' --4.4其他私募基金（含FOF）
               WHEN F.LEVEL4_PROD_ID IN ('3070101','3070201','3070301') OR A.STD_PROD_ID = '307030200001' THEN '其他交易平台债权融资工具' --6.1其他交易平台债权融资工具
               WHEN A.STD_PROD_ID = '307030200002' THEN '以上未包括的投资项目' --7.以上未包括的投资项目（非底层资产）
               WHEN F.LEVEL4_PROD_ID IN ('3080101','3080201') THEN '非上市股权（剔除已计入2.1的部分）' --2.3非上市股权（剔除已计入2.1的部分）
          END AS G31_INVEST_TYPE_NAME  --G31投资分类名称
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '00'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN 'XTGSZGCP'
                  WHEN A.ASSET_NAME LIKE '%理财%' THEN 'LCCPZT'
              WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN 'BXZGCP'
              WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN 'ZQJJ'
              WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN 'HBJJ'
              WHEN F.LEVEL4_PROD_ID IN ('3070101','3070201','3070302') THEN 'QTZQTZ' --QTZQTZ其他债权性投资
              WHEN K.DICT_KEY = '04' THEN 'JJGLZHCP'  
              WHEN K.DICT_KEY = '03' THEN 'ZQGSZGCP'
              WHEN K.DICT_KEY = '05' THEN 'QHZCGLCP'
               ELSE '99' END
           END AS A1411_INVEST_TYPE
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '债券投资'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托公司资管产品'
                  WHEN A.ASSET_NAME LIKE '%理财%' THEN '理财产品投资'
              WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN '保险资管产品'
              WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN '债券基金'
              WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN '货币市场基金'
              WHEN F.LEVEL4_PROD_ID IN ('3070101','3070201','3070302') THEN '其他债权性投资' --QTZQTZ其他债权性投资
              WHEN K.DICT_KEY = '04' THEN '基金管理公司及子公司专户产品'  
              WHEN K.DICT_KEY = '03' THEN '证券公司及子公司资管产品'
              WHEN K.DICT_KEY = '05' THEN '期货公司及子公司资管产品'
               ELSE '其它投资' END
          END AS A1411_INVEST_TYPE_NAME
         ,A.SUBJ_ID                                         AS SUBJ_ID                     --科目代码
         ,F.LEVEL4_PROD_ID                                  AS LEVEL4_PROD_ID              --四级产品编号
         ,F.LEVEL4_PROD_NAME                               AS LEVEL4_PROD_NAME             --四级产品名称
         ,A.EVHA_VAL_CHAG_PL+A.SPD_PL+A.INT_INCOME          AS INVEST_INCOME               --投资收入
         ,A.OVDUE_FLG AS OVDUE_FLG                      --逾期标志
         ,A.EVHA_VAL_CHAG_PL                 --公允价值变动损益
         ,A.SPD_PL                           --价差损益
         ,A.INT_INCOME                        --利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)   AS YEAR_EVHA_VAL_CHAG_PL   --本年公允价值变动损益
         ,NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)                       AS YEAR_SPD_PL             --本年价差损益
         ,NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)               AS YEAR_INT_INCOME         --本年利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)+NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)+NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)  AS  YEAR_INVEST_INCOME --本年投资收入
         ,A.TH_MON_INT_INCOME                                AS TH_MON_INT_INCOME          --本月利息收入
         ,A.FSXZC_FLG                                        AS FSXZC_FLG                  --非生息资产标志
         ,A.ASSET_UNIQ_IDF_ID                                AS ASSET_UNIQ_IDF_ID          --资产唯一标识编号 ADD BY HYF 20231120
         ,H.DUBIL_ID                                         AS CREDNO                     --借据编号 ADD BY HYF 20231120
         ,I.CONFMAMT                       AS CONFMAMT --分配我行确认价值 ADD BY HYF 20231120
         ,H.DIR_INDUS_CD                   AS LOAN_DIR_IDY --ADD BY HYF 20231214
         ,C.ESTATE_BOND_TYPE_NAME          AS ESTATE_BOND_TYPE_NAME --ADD BY HYF 20231214
         ,CASE WHEN E.FNL_DIR_IDY = '6' THEN 'Y'
          ELSE 'N' END                     AS S67_FDC_IND --S67房地产业标志 ADD BY HYF 20231215
         ,A.OVD_DAYS                       AS OVDUE_DAYS --逾期天数 ADD BY HYF 20231215
         ,A.ACCT_B_CATE_CD                 AS ACCT_B_CATE_CD --账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
         ,A.CASH_MANAGE_FLG                AS CASH_MANAGE_FLG --现金管理类产品标志 ADD BY HYF 20250211
        FROM M_CPTL_INVEST_INFO A --投资业务信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN M_FIN_INST_BOND_INFO C --债券基础信息
          ON A.ULYG_PROD_ID = C.BOND_ID
         AND A.DATA_SRC = C.DATA_SRC
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN M_FIN_INST_ULYG_INFO D --标的物基础信息
          ON A.ULYG_PROD_ID = D.ULYG_ID
         AND D.DATA_DT = V_P_DATE
        LEFT JOIN M_CPTL_INVEST_DIR E --投资业务投向信息表
          ON A.ID = E.RID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO F
          ON A.STD_PROD_ID = F.PROD_ID
          AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.M_CPTL_INVEST_INFO G --投资业务信息
          ON G.DATA_DT= V_LAST_YEAR_END
         AND A.ID=G.ID
        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO H --对公贷款借据信息
          ON A.ASSET_UNIQ_IDF_ID = H.IBANK_ASSET_UNIQ_IDF_ID
         AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN RRP_MDL.S_G1102_BASE I --G1102报表分配价值
          ON I.CREDNO = H.DUBIL_ID
         AND I.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE J
          ON A.ULYG_PROD_ID = J.I_CODE||'.'||J.A_TYPE||'.'||J.M_TYPE
         AND J.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND J.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND J.ID_MARK <> 'D'
        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_DICT_MULT_LANG K
          ON K.DICT_KEY = J.SPECIAL_PURPOSE_VEHICLE_TYPE
         AND K.DICT_SUB_TYPE = 'specialPurposeVehicleType'
         AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
         AND K.ID_MARK <> 'D'                 
         LEFT JOIN CODE_MAP TB --五级分类转码
          ON TB.SRC_VALUE_CODE = H.LOAN_LEVEL5_CLS_CD
         AND TB.SRC_CLASS_CODE = 'CD1032'
         AND TB.TAR_CLASS_CODE = 'D0005'
         AND TB.MOD_FLG = 'MDM'
       WHERE A.OPR_TYP = 'A' --自营
       AND A.DATA_SRC NOT IN ('同业债券','资金债券')
         AND  A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   UPDATE S_CPTL_INVEST A SET A.G31_INVEST_TYPE = '5.3',A.G31_INVEST_TYPE_NAME = '证券业资产管理产品（不含公募基金）'
   WHERE A.ID IN ('JX0726_FVTPL_40209')
   AND A.DATA_DT = V_P_DATE
   AND A.DATA_SRC = '同业净值型'
   ;
   
   UPDATE S_CPTL_INVEST A SET A.A1411_INVEST_TYPE = 'ZQGSZGCP',A.A1411_INVEST_TYPE_NAME = '证券公司及子公司资管产品'
   WHERE A.ID IN ('469461604110170000035938_FVTPL_31314')
   AND A.DATA_DT = V_P_DATE
   ;   
   COMMIT;
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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_CPTL_INVEST;
/

