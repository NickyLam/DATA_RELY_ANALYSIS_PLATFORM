CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CPTL_INVEST_G31(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CPTL_INVEST_G31
  *  功能描述：投资业务整合表_G31
  *  创建日期：20220118
  *  开发人员：周一威
  *  来源表：  S_CPTL_INVEST、M_CPTL_INVEST_INFO_BAL0
  *
  *  目标表：  S_CPTL_INVEST_G31
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CPTL_INVEST_G31'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_YEAR_END   VARCHAR2(8); -- 去年年末
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_FREQ_FLAG VARCHAR2(10);    --跑批频度标识
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_CPTL_INVEST_G31'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CPTL_INVEST_G31 T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  --O_ERRCODE := '0';
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  V_LAST_YEAR_END :=(SUBSTR(I_P_DATE,1,4)-1) || '1231'; -- 去年年末
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--

/*  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN*/

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
  -- 程序业务逻辑处理主体部分 --


  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_CPTL_INVEST_G31', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

--删除当前分区数据

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '投资业务整合表_G31--（债券、股票、基金、其他证券、股权、长期股权）';
  V_STARTTIME := SYSDATE;
  --资金债券
  INSERT INTO S_CPTL_INVEST_G31
      (DATA_DT,                          --数据日期
       LGL_REP_ID,                       --法人编号
       ACC_ID,                           --账户编号
       CUST_ID,                          --客户编号
       CORP_CUST_TYP,                    --对公客户类型
       ORG_NO,                           --机构号
       FIN_ORG_TYP,                      --金融机构类型
       FIN_ORG_NM,                       --金融机构名称
       FIN_ORG_ID,                       --金融机构编号
       BIO_FLG,                          --境内外标志
       BOOK_BAL,                         --账面余额
       CUR,                              --币种
       INVEST_BIZ_VRTY,                  --投资业务品种
       FIN_AST_CL,                       --金融资产分类
       ULYG_PROD_ID,                     --标的产品编号
       PROD_CL,                          --产品分类
       MGT_MODE,                         --管理方式
       ISU_SUBJ_RTG,                     --发行主体评级
       PROD_RAISE_MODE,                  --产品募集方式
       REGD_LAND_AREA_CD,                --注册地行政区划代码
       BOND_ISU_MODE,                    --债券发行方式
       FLT_RATE_TYP,                     --浮动利率类型
       BOND_SUR_TERM,                    --债券剩余期限
       ISU_DT,                           --发行日期
       HOLD_UN_BOT_AST_LBY_BAL,          --持有非底层资产产生的间接负债余额
       AST_SPRT_SCR_SUB_CL,              --资产支持证券细类
       LVL5_CL,                          --五级分类
       ACPT_ORG_TYP,                     --承兑机构类型
       ORIG_BILL_HLDR_TYP,               --原始持票人类型
       PRO_IMPT,                         -- 减值准备
       EXP_DT,                           -- 到期日期
       CRED_RTS_FIN_PROD_SUB_CL,         -- 债权融资类产品细类
       GRN_INVEST_USEAGE_CL_1104,        -- 绿色投资用途分类1104
       CER_MTG_INVEST_FLG,               -- 以碳排放权为抵押的投资标志
       ER_MTG_INVEST_FLG,                -- 以环境权益为抵押的投资标志
       DEPT_LINE,                        --部门条线
       DATA_SRC,                         --数据来源
       PROD_TYP,                         --产品细类
       ID,                               --业务主键
       BOND_ID,                          --债券编号
       BOND_NAME,                        --债券名称
       ASSET_TYPE_ID,                    --原始债券类型代码
       ASSET_NAME,                       --资产名称
       BOND_RTG,                         --债券评级
       INVEST_TYP,                       --投资大类代码
       INVEST_TYP_NAME,                  --投资大类名称
       G31_INVEST_TYPE,                  --G31投资分类
       G31_INVEST_TYPE_NAME,             --G31投资分类名称
       A1411_INVEST_TYPE,                --A1411投资分类代码
       A1411_INVEST_TYPE_NAME,           --A1411投资分类名称
       SUBJ_ID,                          --科目代码
       LEVEL4_PROD_ID,                   --四级产品编号
       LEVEL4_PROD_NAME,                 --四级产品名称
       INVEST_INCOME,                    --投资收入
       OVDUE_FLG,                        --逾期标志
       EVHA_VAL_CHAG_PL,                 --公允价值变动损益
       SPD_PL,                           --价差损益
       INT_INCOME,                       --利息收入
       YEAR_EVHA_VAL_CHAG_PL,                 --本年公允价值变动损益
       YEAR_SPD_PL,                           --本年价差损益
       YEAR_INT_INCOME,                       --本年利息收入
       YEAR_INVEST_INCOME                     --本年投资收入
       )
      SELECT
         A.DATA_DT,                          --数据日期
         A.LGL_REP_ID,                       --法人编号
         A.ACC_ID,                           --账户编号
         A.CUST_ID,                          --客户编号
         A.CORP_CUST_TYP,                    --对公客户类型
         A.ORG_NO,                           --机构号
         A.FIN_ORG_TYP,                      --金融机构类型
         A.FIN_ORG_NM,                       --金融机构名称
         A.FIN_ORG_ID,                       --金融机构编号
         A.BIO_FLG,                          --境内外标志
         A.BOOK_BAL,                         --账面余额
         A.CUR,                              --币种
         A.INVEST_BIZ_VRTY,                  --投资业务品种
         A.FIN_AST_CL,                       --金融资产分类
         A.ULYG_PROD_ID,                     --标的产品编号
         A.PROD_CL,                          --产品分类
         A.MGT_MODE,                         --管理方式
         A.ISU_SUBJ_RTG,                     --发行主体评级
         A.PROD_RAISE_MODE,                  --产品募集方式
         A.REGD_LAND_AREA_CD,                --注册地行政区划代码
         A.BOND_ISU_MODE,                    --债券发行方式
         A.FLT_RATE_TYP,                     --浮动利率类型
         A.BOND_SUR_TERM,                    --债券剩余期限
         A.ISU_DT,                           --发行日期
         A.HOLD_UN_BOT_AST_LBY_BAL,          --持有非底层资产产生的间接负债余额
         A.AST_SPRT_SCR_SUB_CL,              --资产支持证券细类
         A.LVL5_CL,                          --五级分类
         A.ACPT_ORG_TYP,                     --承兑机构类型
         A.ORIG_BILL_HLDR_TYP,               --原始持票人类型
         A.PRO_IMPT,                         -- 减值准备
         A.EXP_DT,                           -- 到期日期
         A.CRED_RTS_FIN_PROD_SUB_CL,         -- 债权融资类产品细类
         A.GRN_INVEST_USEAGE_CL_1104,        -- 绿色投资用途分类1104
         A.CER_MTG_INVEST_FLG,               -- 以碳排放权为抵押的投资标志
         A.ER_MTG_INVEST_FLG,                -- 以环境权益为抵押的投资标志
         A.DEPT_LINE,                        --部门条线
         '投资业务整合表' AS DATA_SRC,                      --数据来源
         A.PROD_TYP,                         --产品细类
         A.ID,                               --业务主键
         A.BOND_ID,                          --债券编号
         A.BOND_NAME,                        --债券名称
         A.ASSET_TYPE_ID,                    --原始债券类型代码
         A.ASSET_NAME,                       --资产名称
         A.BOND_RTG,                         --债券评级
         A.INVEST_TYP,                       --投资大类代码
         A.INVEST_TYP_NAME,                  --投资大类名称
         A.G31_INVEST_TYPE,                  --G31投资分类
         A.G31_INVEST_TYPE_NAME,             --G31投资分类名称
         A.A1411_INVEST_TYPE,                --A1411投资分类代码
         A.A1411_INVEST_TYPE_NAME,           --A1411投资分类名称
         A.SUBJ_ID,                          --科目代码
         A.LEVEL4_PROD_ID,                   --四级产品编号
         A.LEVEL4_PROD_NAME,                 --四级产品名称
         A.INVEST_INCOME,                    --投资收入
         A.OVDUE_FLG,                        --逾期标志
         A.EVHA_VAL_CHAG_PL,                 --公允价值变动损益
         A.SPD_PL,                           --价差损益
         A.INT_INCOME,                       --利息收入
         A.YEAR_EVHA_VAL_CHAG_PL,                 --本年公允价值变动损益
         A.YEAR_SPD_PL,                           --本年价差损益
         A.YEAR_INT_INCOME,                       --本年利息收入
         A.YEAR_INVEST_INCOME                     --本年投资收入
        FROM S_CPTL_INVEST A --投资业务整合表
       WHERE A.DATA_DT = V_P_DATE
        -- AND A.BOOK_BAL <>0
        -- AND A.EXP_DT>=TRUNC(A.ETL_DT,'YYYY')
        -- AND A.ASSET_NAME NOT LIKE '%保险资管计划%'
         AND A.ASSET_NAME NOT LIKE '%票据资管计划%'
   AND A.ULYG_PROD_ID IN ('304010100001', '304010200001',
                          '304020100001', '304020100002','304020100003','304020100004','304020200001',
                          '304030100001', '304030100002','304030100003','304030100004','304030200001','304030200002','304030300001','304030400001',
                          '304040100001', '304040200001',
                          '304050100001', '304050200001',
                          '307010100001','307020100001','307020100002','307030100001','307030200001','307030200002','307030200001',
                          '307030200002')--他行非保本理财产品 信托产品 证券业资产管理产品（不含公募基金） 保险业资产管理产品 其他资产管理产品 其他债权融资类产品 -- 以上未包括的投资项目

         ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  --同业非标、净值产品及货币基金
  INSERT INTO S_CPTL_INVEST_G31
      (DATA_DT,                          --数据日期
       LGL_REP_ID,                       --法人编号
       ACC_ID,                           --账户编号
       CUST_ID,                          --客户编号
       CORP_CUST_TYP,                    --对公客户类型
       ORG_NO,                           --机构号
       FIN_ORG_TYP,                      --金融机构类型
       FIN_ORG_NM,                       --金融机构名称
       FIN_ORG_ID,                       --金融机构编号
       BIO_FLG,                          --境内外标志
       BOOK_BAL,                         --账面余额
       CUR,                              --币种
       INVEST_BIZ_VRTY,                  --投资业务品种
       FIN_AST_CL,                       --金融资产分类
       ULYG_PROD_ID,                      --标准产品编号
       PROD_CL,                          --产品分类
       MGT_MODE,                         --管理方式
       ISU_SUBJ_RTG,                     --发行主体评级
       PROD_RAISE_MODE,                  --产品募集方式
       REGD_LAND_AREA_CD,                --注册地行政区划代码
       BOND_ISU_MODE,                    --债券发行方式
       FLT_RATE_TYP,                     --浮动利率类型
       BOND_SUR_TERM,                    --债券剩余期限
       ISU_DT,                           --发行日期
       HOLD_UN_BOT_AST_LBY_BAL,          --持有非底层资产产生的间接负债余额
       AST_SPRT_SCR_SUB_CL,              --资产支持证券细类
       LVL5_CL,                          --五级分类
       ACPT_ORG_TYP,                     --承兑机构类型
       ORIG_BILL_HLDR_TYP,               --原始持票人类型
       PRO_IMPT                 ,        -- 减值准备
       EXP_DT                   ,        -- 到期日期
       CRED_RTS_FIN_PROD_SUB_CL ,        -- 债权融资类产品细类
       GRN_INVEST_USEAGE_CL_1104,        -- 绿色投资用途分类1104
       CER_MTG_INVEST_FLG       ,        -- 以碳排放权为抵押的投资标志
       ER_MTG_INVEST_FLG        ,        -- 以环境权益为抵押的投资标志
       DEPT_LINE,                        --部门条线
       DATA_SRC,                         --数据来源
       PROD_TYP,                         --产品细类
       ID,                               --业务主键
       BOND_ID,                          --债券编号
       BOND_NAME,                        --债券名称
       ASSET_TYPE_ID,                    --原始债券类型代码
       ASSET_NAME,                       --资产名称
       BOND_RTG,                         --债券评级
       INVEST_TYP,                       --投资大类代码
       INVEST_TYP_NAME,                  --投资大类名称
       G31_INVEST_TYPE,                  --G31投资分类
       G31_INVEST_TYPE_NAME,             --G31投资分类名称
       A1411_INVEST_TYPE,                --A1411投资分类代码
       A1411_INVEST_TYPE_NAME,           --A1411投资分类名称
       SUBJ_ID,                          --科目代码
       LEVEL4_PROD_ID,                   --四级产品编号
       LEVEL4_PROD_NAME,                  --四级产品名称
       INVEST_INCOME,                      --投资收入
       OVDUE_FLG,                        --逾期标志
       EVHA_VAL_CHAG_PL,                 --公允价值变动损益
       SPD_PL,                           --价差损益
       INT_INCOME,                        --利息收入
       YEAR_EVHA_VAL_CHAG_PL,                 --本年公允价值变动损益
       YEAR_SPD_PL,                           --本年价差损益
       YEAR_INT_INCOME,                       --本年利息收入
       YEAR_INVEST_INCOME                     --本年投资收入
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
             A.BOOK_BAL                                             AS BOOK_BAL,                  --账面余额
             A.CUR                                                  AS CUR,                       --币种
             A.INVEST_BIZ_VRTY                                      AS INVEST_BIZ_VRTY,           --投资业务品种
             A.FIN_AST_CL                                           AS FIN_AST_CL,                --金融资产分类
             A.STD_PROD_ID                                          AS STD_PROD_ID,               --标准产品编号
             NVL(C.PROD_CL, D.ULYG_PROD_CL)                         AS PROD_CL,                   --产品分类
             A.MGT_MOD                                              AS MGT_MODE,                  --管理方式
             C.ISU_SUBJ_RTG                                         AS ISU_SUBJ_RTG,              --发行主体评级
             A.PROD_RAISE_MODE                                      AS PROD_RAISE_MODE,           --产品募集方式
             B.REGD_LAND_AREA_CD                                    AS REGD_LAND_AREA_CD,         --注册地行政区划代码
             C.BOND_ISU_MODE                                        AS BOND_ISU_MODE,             --债券发行方式
             C.FLT_RATE_TYP                                         AS FLT_RATE_TYP,              --浮动利率类型
             TO_DATE(C.EXP_DT, 'YYYY-MM-DD') -TO_DATE(V_P_DATE,'YYYYMMDD')  AS BOND_SUR_TERM,     --债券剩余期限
             C.ISU_DT                                               AS ISU_DT,                    --发行日期
             A.HOLD_UN_BOT_AST_LBY_BAL                              AS HOLD_UN_BOT_AST_LBY_BAL,   --持有非底层资产产生的间接负债余额
             E.AST_SPRT_SCR_SUB_CL                                  AS AST_SPRT_SCR_SUB_CL,       --资产支持证券细类
             A.LVL5_CL                                              AS LVL5_CL,                   --五级分类
             D.ACPT_ORG_TYP                                         AS ACPT_ORG_TYP,              --承兑机构类型
             D.ORIG_BILL_HLDR_TYP                                   AS ORIG_BILL_HLDR_TYP,        --原始持票人类型
             A.PRO_IMPT                                             AS PRO_IMPT                 , -- 减值准备
             C.EXP_DT                                               AS EXP_DT                   , -- 到期日期
             E.CRED_RTS_FIN_PROD_SUB_CL                             AS CRED_RTS_FIN_PROD_SUB_CL , -- 债权融资类产品细类
             C.GRN_INVEST_USEAGE_CL_1104                            AS GRN_INVEST_USEAGE_CL_1104, -- 绿色投资用途分类1104
             C.CER_MTG_INVEST_FLG                                   AS CER_MTG_INVEST_FLG       , -- 以碳排放权为抵押的投资标志
             C.ER_MTG_INVEST_FLG                                    AS ER_MTG_INVEST_FLG        , -- 以环境权益为抵押的投资标志
             A.DEPT_LINE                                            AS DEPT_LINE,                 --部门条线
             '持仓'                                                 AS DATA_SRC,                  --数据来源
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
                 ,C.BOND_RTG                                        AS BOND_RTG                   --债券评级
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
                  END AS G31_INVEST_TYPE_NAME  --G31投资分类名称
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '00'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN 'XTGSZGCP'
                  WHEN A.ASSET_NAME LIKE '%理财%' THEN 'LCCPZT'
              WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN 'BXZGCP'
              WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN 'ZQJJ'
              WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN 'HBJJ'
              WHEN (F.LEVEL4_PROD_ID IN ('3040501','3040502','3040302') AND A.ID <> 'GSGQBGJJ_FVTPL_35225' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' ) OR A.ID IN ('469441706150170000035892_FVTPL_24702','469461604110170000035938_FVTPL_31314' ) THEN 'ZQGSZGCP'
              WHEN F.LEVEL4_PROD_ID IN ('3040301') OR A.ID IN ('1875612111250170000078249_FVTPL_30685','GSGQBGJJ_FVTPL_35225') THEN 'JJGLZHCP'
              WHEN F.LEVEL4_PROD_ID IN ('3040304') THEN 'QHZCGLCP'
              WHEN  A.ASSET_NAME LIKE '%基金%' THEN '01'
			  WHEN A.ID IN ('469462201270170000082666_AC_32015','469462112280170000080360_AC_31362','469412204280170000088275_AC_33884','469482204010170000086437_AC_33226'
			                ,'469472111290170000078415_AC_30726','469472112030170000079060_AC_30916','469412202140170000083398_AC_32250') THEN 'QTZQTZ' --QTZQTZ其他债权性投资
			  WHEN 	F.LEVEL4_PROD_ID IN ('3070101','3070201') OR A.ASSET_NAME LIKE '%票据资管计划%' THEN '05'		--05境内非金融企业债券投资
               ELSE '99' END
          END AS A1411_INVEST_TYPE
         ,CASE WHEN A.INVEST_BIZ_VRTY = 'A01' THEN '债券投资'
               ELSE CASE WHEN A.ASSET_NAME LIKE '%信托%' OR A.ASSET_NAME LIKE '%银登中心%' THEN '信托公司资管产品'
                  WHEN A.ASSET_NAME LIKE '%理财%' THEN '理财产品投资'
              WHEN F.LEVEL4_PROD_ID IN ('3040401','3040402') THEN '保险资管产品'
              WHEN F.LEVEL4_PROD_ID IN ('3030101') THEN '债券基金'
              WHEN F.LEVEL4_PROD_ID IN ('3030201') THEN '货币市场基金'
              WHEN (F.LEVEL4_PROD_ID IN ('3040501','3040502','3040302') AND A.ID <> 'GSGQBGJJ_FVTPL_35225' AND A.ASSET_NAME NOT LIKE '%票据资管计划%' ) OR A.ID IN ('469441706150170000035892_FVTPL_24702','469461604110170000035938_FVTPL_31314' ) THEN '证券公司及子公司资管产品'
              WHEN F.LEVEL4_PROD_ID IN ('3040301') OR A.ID IN ('1875612111250170000078249_FVTPL_30685','GSGQBGJJ_FVTPL_35225') THEN '基金管理公司及子公司专户产品'
              WHEN F.LEVEL4_PROD_ID IN ('3040304') THEN '净值型期货资产管理产品'
              WHEN  A.ASSET_NAME LIKE '%基金%' THEN '基金投资'
			  WHEN A.ID IN ('469462201270170000082666_AC_32015','469462112280170000080360_AC_31362','469412204280170000088275_AC_33884','469482204010170000086437_AC_33226'
			                ,'469472111290170000078415_AC_30726','469472112030170000079060_AC_30916','469412202140170000083398_AC_32250') THEN '其他债权性投资' --QTZQTZ其他债权性投资
			  WHEN 	F.LEVEL4_PROD_ID IN ('3070101','3070201') OR A.ASSET_NAME LIKE '%票据资管计划%' THEN '境内非金融企业债券投资'		--05境内非金融企业债券投资
               ELSE '其它投资' END
          END AS A1411_INVEST_TYPE_NAME
         ,A.SUBJ_ID                                         AS SUBJ_ID                      --科目代码
         ,F.LEVEL4_PROD_ID                                  AS  LEVEL4_PROD_ID              --四级产品编号
          ,F.LEVEL4_PROD_NAME                                AS  LEVEL4_PROD_NAME            --四级产品名称
         ,NVL(A.EVHA_VAL_CHAG_PL,0)+NVL(A.SPD_PL,0)+NVL(A.INT_INCOME,0)          AS  INVEST_INCOME         --投资收入
         ,A.OVDUE_FLG AS OVDUE_FLG                      --逾期标志
         ,NVL(A.EVHA_VAL_CHAG_PL,0)                 --公允价值变动损益
         ,NVL(A.SPD_PL,0)                           --价差损益
         ,NVL(A.INT_INCOME,0)                       --利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)   AS YEAR_EVHA_VAL_CHAG_PL   --本年公允价值变动损益
         ,NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)                       AS YEAR_SPD_PL             --本年价差损益
         ,NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)               AS YEAR_INT_INCOME         --本年利息收入
         ,NVL(A.EVHA_VAL_CHAG_PL,0)-NVL(A.BGN_YEAR_EVHA_VAL_CHAG_PL,0)+NVL(A.SPD_PL,0)-NVL(A.BGN_YEAR_SPD_PL,0)+NVL(A.INT_INCOME,0)-NVL(A.BGN_YEAR_INT_INCOME,0)  AS  YEAR_INVEST_INCOME --本年投资收入
        FROM M_CPTL_INVEST_INFO_BAL0 A --投资业务信息
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
          ON A.ACC_ID = E.ACC_ID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO F
          ON A.STD_PROD_ID = F.PROD_ID
          AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*  LEFT JOIN RRP_MDL.M_CPTL_INVEST_INFO_BAL0 G -- 取去年年末
          ON G.DATA_DT= V_LAST_YEAR_END
         AND A.ID=G.ID*/
       WHERE A.DATA_DT = V_P_DATE
         AND A.ID NOT IN (SELECT ID
                            FROM S_CPTL_INVEST A
                           WHERE A.DATA_DT = V_P_DATE
                             AND A.ASSET_NAME NOT LIKE '%票据资管计划%'
                             AND A.ULYG_PROD_ID IN ('304010100001', '304010200001',
                          '304020100001', '304020100002','304020100003','304020100004','304020200001',
                          '304030100001', '304030100002','304030100003','304030100004','304030200001','304030200002','304030300001','304030400001',
                          '304040100001', '304040200001',
                          '304050100001', '304050200001',
                          '307010100001','307020100001','307020100002','307030100001','307030200001','307030200002','307030200001',
                          '307030200002'))
         AND A.BOOK_BAL =0
   AND ((A.INVEST_BIZ_VRTY <> 'A01' AND A.ASSET_NAME NOT LIKE '%票据资管计划%')
        OR A.ASSET_NAME IS NULL)
   AND A.STD_PROD_ID IN ('304010100001', '304010200001',
                          '304020100001', '304020100002','304020100003','304020100004','304020200001',
                          '304030100001', '304030100002','304030100003','304030100004','304030200001','304030200002','304030300001','304030400001',
                          '304040100001', '304040200001',
                          '304050100001', '304050200001',
                          '307010100001','307020100001','307020100002','307030100001','307030200001','307030200002','307030200001',
                          '307030200002')--他行非保本理财产品 信托产品 证券业资产管理产品（不含公募基金） 保险业资产管理产品 其他资产管理产品 其他债权融资类产品 -- 以上未包括的投资项目
       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

/*   END IF;*/
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

  END ETL_S_CPTL_INVEST_G31;
/

