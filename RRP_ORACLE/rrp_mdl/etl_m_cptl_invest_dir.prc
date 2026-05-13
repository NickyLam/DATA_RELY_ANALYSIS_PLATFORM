CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_INVEST_DIR(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_INVEST_DIR
  *  功能描述：投资业务投向信息
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_INVEST_DIR
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20230113  hulj      增加同业-货币基金、理财产品、信托计划、资产管理计划、债券基金 口径
  *             4    20230830  HYF       修改非标部分账目余额字段逻辑改为取持仓表的净价成本（剔除应收未收利息）
  *             5    20241028  YJY       调整同业债券部分调整ID字段
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_INVEST_DIR'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_CPTL_INVEST_DIR'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_INVEST_DIR T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_INVEST_DIR'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '投资业务投向信息--同业系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_DIR
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,PK                          --主键
    ,ACC_ID                      --账户编号
    ,FNL_DIR_TYP                 --最终投向类型
    ,FNL_DIR_IDY                 --最终投向行业
    ,THRO_AFTER_BAL              --穿透后余额
    ,CUR                         --币种
    ,AST_SPRT_SCR_SUM_CL         --资产支持证券细类
    --,CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,INT_INCOME                  --利息收入
    ,STD_PROD_ID                 --标准产品编号
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,RID                         --业务主键
    ,FNL_DIR_RATIO               --最终投向比例
    ,PRO_PK                      --穿透后主键
    ,OVDUE_FLG                   --逾期标志
    )
  SELECT V_P_DATE                                     AS DATA_DT                     --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID                  --法人编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                      --机构编号
        ,A.BUS_ID                                     AS PK                          --主键
        ,A.INTNAL_SECU_ACCT_ID || A.FIN_INSTM_ID      AS ACC_ID                      --账户编号   
        ,NVL(COD3.TAR_VALUE_CODE,'F04')               AS FNL_DIR_TYP                 --最终投向类型
        ,NVL(COD1.TAR_VALUE_CODE,0)                   AS FNL_DIR_IDY                 --最终投向行业
        ,A.PRIC_BAL                                   AS THRO_AFTER_BAL              --穿透后余额
        ,A.CURR_CD                                    AS CUR                         --币种
        ,NULL                                         AS AST_SPRT_SCR_SUM_CL         --资产支持证券细类
        ,NULL                                         AS DEPT_LINE                   --部门条线
        ,'同业债券投资'                               AS DATA_SRC                    --数据来源
        ,A1.EVHA_VAL_CHAG_PL                          AS EVHA_VAL_CHAG_PL            --公允价值变动损益
        ,A1.SPD_PL                                    AS SPD_PL                      --价差损益
        ,A1.INT_INCOME                                AS INT_INCOME                  --利息收入
        ,A.STD_PROD_ID                                AS STD_PROD_ID                 --标准产品编号
        ,A.ASSET_THD_CLS_CD                           AS ASSET_THD_CLS_CD            --资产三分类代码
        -- ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.INTNAL_SECU_ACCT_ID AS RID --业务主键
        ,A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD 
                                                      AS ID                           --业务主键  --mod by yjy  20241028
        ,100                                          AS FNL_DIR_RATIO               --最终投向比例
        ,T3.ID                                        AS PRO_PK                      --穿透后主键
        ,A.OVDUE_FLG                                  AS OVDUE_FLG                   --逾期标志
    FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A  --同业债券投资
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 -- 同业证券持仓表
      ON A1.FIN_INSTM_ID||'_'||A1.ASSET_THD_CLS_CD||'_'||A1.OBJ_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID
     AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_RISK_GRADE_PROPORTION T3 --最终投向类型详细信息
      ON T3.I_CODE = A.FIN_INSTM_ID
     AND T3.A_TYPE = A.ASSET_TYPE_ID
     AND T3.M_TYPE = A.MARKET_TYPE_ID
     AND T3.IS_CURRENT = '1'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_RISK_GRADE_RATIO T4 --最终投向类型信息
      ON T4.ID = T3.RISK_ID
     AND T4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM T5 --金融工具表
      ON T5.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND T5.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND T5.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND T5.PROD_TYPE_CD = A.PROD_TYPE_CD
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP COD1 --最终投向大类
      ON COD1.SRC_VALUE_NAME = A.FINAL_DIR_INDUS_GEN
     AND COD1.SRC_CLASS_CODE = 'TXHYDL'
     AND COD1.TAR_CLASS_CODE = 'TXHYDL'
     AND COD1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP COD2 --最终投向类型
      ON COD2.SRC_VALUE_CODE = T4.ID
     AND COD2.SRC_CLASS_CODE = 'ZZTXLX'
     AND COD2.TAR_CLASS_CODE = 'ZZTXLX'
     AND COD2.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP COD3 --最终投向类型 -债券产品类别
      ON COD3.SRC_VALUE_NAME = T5.ASSET_TYPE_NAME
     AND COD3.SRC_CLASS_CODE = 'TYZQLB'
     AND COD3.TAR_CLASS_CODE = 'ZZTXLX'
     AND COD3.MOD_FLG = 'MDM'
   WHERE A.BOOK_BAL > 0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP_DESC := '投资业务投向信息--资金系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_DIR
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,PK                          --主键
    ,ACC_ID                      --账户编号
    ,FNL_DIR_TYP                 --最终投向类型
    ,FNL_DIR_IDY                 --最终投向行业
    ,THRO_AFTER_BAL              --穿透后余额
    ,CUR                         --币种
    ,AST_SPRT_SCR_SUM_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,INT_INCOME                  --利息收入
    ,STD_PROD_ID                 --标准产品编号
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,RID                         --业务主键
    ,FNL_DIR_RATIO               --最终投向比例
    ,PRO_PK                      --穿透后主键
    ,OVDUE_FLG                   --逾期标志
    )
  SELECT V_P_DATE                                     AS DATA_DT                     --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID                  --法人编号
        ,B.ENTRY_ORG_ID                               AS ORG_ID                      --机构编号
        ,A.BOND_ID                                    AS PK                          --主键
        ,B.BOND_ID || B.TRAN_ACCT_B_ID                AS ACC_ID                      --账户编号
        ,NVL(COD1.TAR_VALUE_CODE,'F04')               AS FNL_DIR_TYP                 --最终投向类型
        ,'0'                                          AS FNL_DIR_IDY                 --最终投向行业
        ,B.BOOK_BAL                                   AS THRO_AFTER_BAL              --穿透后余额
        ,B.CURR_CD                                    AS CUR                         --币种
        ,NULL                                         AS AST_SPRT_SCR_SUM_CL         --资产支持证券细类
        ,NULL                                         AS CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
        ,NULL                                         AS DEPT_LINE                   --部门条线
        ,'资金债券投资'                               AS DATA_SRC                    --数据来源
        ,B.EVHA_VAL_CHAG_PL                           AS EVHA_VAL_CHAG_PL            --公允价值变动损益
        ,B.SPD_PRFT                                   AS SPD_PL                      --价差损益
        ,B.INT_COST                                   AS INT_INCOME                  --利息收入
        ,B.STD_PROD_ID                                AS STD_PROD_ID                 --标准产品编号
        ,B.ASSET_THD_CLS_CD                           AS ASSET_THD_CLS_CD            --资产三分类代码
        ,B.BOND_ID||'_'||B.ASSET_THD_CLS_CD||'_'||B.TRAN_ACCT_B_ID 
                                                      AS RID                         --业务主键
        ,100                                          AS FNL_DIR_RATIO               --最终投向比例
        ,NULL                                         AS PRO_PK                      --穿透后主键
        ,0                                            AS OVDUE_FLG                   --逾期标志
    FROM RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO A --债券基本信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST B --资金债券投资表
      ON B.BOND_ID = A.BOND_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP COD1 --投向行业
      ON COD1.SRC_VALUE_CODE = A.BOND_TYPE_CD
     AND COD1.SRC_CLASS_CODE = 'CD1486'
     AND COD1.TAR_VALUE_CODE = 'D0049'
     AND COD1.MOD_FLG = 'MDM'
   WHERE A.BOND_TYPE_CD <> 'W' --W 为同业存单
     AND A.DATA_SRC_SYS_IDF = 'CTMS'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --------------ADD BY MW 20221123--------同业非标投资
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '投资业务投向信息--同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_DIR
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,PK                          --主键
    ,ACC_ID                      --账户编号
    ,FNL_DIR_TYP                 --最终投向类型
    ,FNL_DIR_IDY                 --最终投向行业
    ,THRO_AFTER_BAL              --穿透后余额
    ,CUR                         --币种
    ,AST_SPRT_SCR_SUM_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,UNDERLYING_BASE_AST_ID      --底层基础资产编号
    ,AST_SPRT_SCR_SUB_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
    ,TRA_PLTF                    --交易平台
    ,UNSTD_TRF_AST_FLG           --非标转标资产标志
    ,BASIC_ASSET_NAME            --底层资产名称
    ,BASIC_ASSET_RATING          --底层资产评级
    ,ACRU_INT                    --应计利息
    ,INT_RECVBL                  --应收利息
    ,RECVBL_UNCOL_INT            --应收未收利息
    ,FINAL_DIR_INDUS_GEN         --最终投向行业_大类
    ,FINAL_DIR_INDUS_SUBCLASS    --最终投向行业_细类
    ,DIR_IND_FUND_PART           --投向产业基金的部分
    ,DIR_DEBT_EQTY_PART          --投向债转股的部分
    ,DIR_PAM_PROD_PART           --投向私募资产管理产品的部分
    ,RID                         --业务主键
    ,PROD_TYPE_CD                --产品类型代码
    ,ASSET_TYPE_NAME             --产品类型名称
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,INT_INCOME                  --利息收入
    ,STD_PROD_ID                 --标准产品编号
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,FNL_DIR_RATIO               --最终投向比例
    ,PRO_PK                      --穿透后主键
    ,OVDUE_FLG                   --逾期标志
    )
  SELECT V_P_DATE                                                 AS DATA_DT                     --数据日期
        ,A.LP_ID                                                  AS LGL_REP_ID                  --法人编号
        ,A.BELONG_ORG_ID                                          AS ORG_ID                      --机构编号
        ,A.OBJ_ID                                                 AS PK                          --主键
        ,A.OBJ_ID                                                 AS ACC_ID                      --账户编号
        ,NVL(T5.ZZTXLXDM,'F04')                                   AS FNL_DIR_TYP                 --最终投向类型
        ,NVL(COD1.TAR_VALUE_CODE,'0')                             AS FNL_DIR_IDY                 --最终投向行业
        ,NVL(A1.NET_PRICE_COST,0)                                 AS THRO_AFTER_BAL              --穿透后余额
        ,A.CURR_CD                                                AS CUR                         --币种
        ,NULL                                                     AS AST_SPRT_SCR_SUM_CL         --资产支持证券细类
        ,NULL                                                     AS CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
        ,NULL                                                     AS DEPT_LINE                   --部门条线
        ,'同业非标投资'                                           AS DATA_SRC                    --数据来源
        ,A.UDER_BOND_CD                                           AS UNDERLYING_BASE_AST_ID      --底层基础资产编号
        ,NULL                                                     AS AST_SPRT_SCR_SUB_CL         --资产支持证券细类
        ,NULL                                                     AS CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
        ,NULL                                                     AS TRA_PLTF                    --交易平台
        ,NULL                                                     AS UNSTD_TRF_AST_FLG           --非标转标资产标志
        ,A.UDER_BOND_NAME                                         AS BASIC_ASSET_NAME            --底层资产名称
        ,T5.PJ                                                    AS BASIC_ASSET_RATING          --底层资产评级
        ,A.ACRU_INT                                               AS ACRU_INT                    --应计利息
        ,A.INT_RECVBL                                             AS INT_RECVBL                  --应收利息
        ,A.RECVBL_UNCOL_INT                                       AS RECVBL_UNCOL_INT            --应收未收利息
        ,A.FINAL_DIR_INDUS_GEN                                    AS FINAL_DIR_INDUS_GEN         --最终投向行业_大类
        ,A.FINAL_DIR_INDUS_SUBCLASS                               AS FINAL_DIR_INDUS_SUBCLASS    --最终投向行业_细类
        ,A.DIR_IND_FUND_PART                                      AS DIR_IND_FUND_PART           --投向产业基金的部分
        ,A.DIR_DEBT_EQTY_PART                                     AS DIR_DEBT_EQTY_PART          --投向债转股的部分
        ,A.DIR_PAM_PROD_PART                                      AS DIR_PAM_PROD_PART           --投向私募资产管理产品的部分
        ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS RID                   --业务主键
        ,A.PROD_TYPE_CD                                           AS PROD_TYPE_CD                --产品类型代码
        ,A.ASSET_TYPE_NAME                                        AS ASSET_TYPE_NAME             --资产类型名称
        ,A1.EVHA_VAL_CHAG_PL                                      AS EVHA_VAL_CHAG_PL            --公允价值变动损益
        ,A1.SPD_PL                                                AS SPD_PL                      --价差损益
        ,A1.INT_INCOME                                            AS INT_INCOME                  --利息收入
        ,A.STD_PROD_ID                                            AS STD_PROD_ID                 --标准产品编号
        ,A.ASSET_THD_CLS_CD                                       AS ASSET_THD_CLS_CD            --资产三分类代码
        ,NVL(T5.ZB,100)                                           AS FNL_DIR_RATIO               --最终投向比例
        ,T5.ID                                                    AS PRO_PK                      --穿透后主键
        ,A.OVDUE_FLG                                              AS OVDUE_FLG                   --逾期标志
    FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 -- 同业证券持仓表
      ON A1.FIN_INSTM_ID||'_'||A1.ASSET_THD_CLS_CD||'_'||A1.OBJ_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID
     AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动 MODIFY BY HYF
      ON O.V_ASSET_CODE = A.FIN_INSTM_ID
     AND O.V_THREE_CLASS = A.ASSET_THD_CLS_CD
     AND O.V_TRADE_NO = A.OBJ_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ADD_INVEST_FINAL_DIR T5 --最终投向信息业务补录表
      ON T5.FIN_INSTM_ID = A.FIN_INSTM_ID
    LEFT JOIN RRP_MDL.CODE_MAP COD1 --最终投向细类
      ON COD1.SRC_VALUE_CODE = A.FINAL_DIR_INDUS_SUBCLASS
     AND COD1.SRC_CLASS_CODE = 'TXHYXL'
     AND COD1.TAR_CLASS_CODE = 'TXHYXL'
     AND COD1.MOD_FLG = 'MDM'
   WHERE /*A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%'
     AND A.BOOK_BAL > 0
     AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --------------------ADD BY MW 20221125--------同业净值型投资
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '投资业务投向信息--同业净值型产品';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_DIR
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,PK                          --主键
    ,ACC_ID                      --账户编号
    ,FNL_DIR_TYP                 --最终投向类型
    ,FNL_DIR_IDY                 --最终投向行业
    ,THRO_AFTER_BAL              --穿透后余额
    ,CUR                         --币种
    ,AST_SPRT_SCR_SUM_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,UNDERLYING_BASE_AST_ID      --底层基础资产编号
    ,AST_SPRT_SCR_SUB_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
    ,TRA_PLTF                    --交易平台
    ,UNSTD_TRF_AST_FLG           --非标转标资产标志
    ,BASIC_ASSET_NAME            --底层资产名称
    ,BASIC_ASSET_RATING          --底层资产评级
    ,ACRU_INT                    --应计利息
    ,INT_RECVBL                  --应收利息
    ,RECVBL_UNCOL_INT            --应收未收利息
    ,FINAL_DIR_INDUS_GEN         --最终投向行业_大类
    ,FINAL_DIR_INDUS_SUBCLASS    --最终投向行业_细类
    ,DIR_IND_FUND_PART           --投向产业基金的部分
    ,DIR_DEBT_EQTY_PART          --投向债转股的部分
    ,DIR_PAM_PROD_PART           --投向私募资产管理产品的部分
    ,RID                         --业务主键
    ,PROD_TYPE_CD                --产品类型代码
    ,ASSET_TYPE_NAME             --产品类型名称
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,INT_INCOME                  --利息收入
    ,STD_PROD_ID                 --标准产品编号
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,FNL_DIR_RATIO               --最终投向比例
    ,PRO_PK                      --穿透后主键
    ,OVDUE_FLG                   --逾期标志
    )
  SELECT V_P_DATE                                               AS DATA_DT                  --数据日期
        ,A.LP_ID                                                AS LGL_REP_ID               --法人编号
        ,A.BELONG_ORG_ID                                        AS ORG_ID                   --机构编号
        ,A.OBJ_ID                                               AS PK                       --主键
        ,A.OBJ_ID                                               AS ACC_ID                   --账户编号
        ,NVL(T5.ZZTXLXDM,'F04')                                 AS FNL_DIR_TYP              --最终投向类型
        ,NVL(COD1.TAR_VALUE_CODE,'0')                           AS FNL_DIR_IDY              --最终投向行业
        ,NVL(A.BOOK_BAL,0)                                      AS THRO_AFTER_BAL           --穿透后余额
        ,A.CURR_CD                                              AS CUR                      --币种
        ,NULL                                                   AS AST_SPRT_SCR_SUM_CL      --资产支持证券细类
        ,NULL                                                   AS CRED_RTS_FIN_PROD_SUM_CL --债权融资类产品细类
        ,NULL                                                   AS DEPT_LINE                --部门条线
        ,'同业净值型产品'                                       AS DATA_SRC                 --数据来源
        ,A.UDER_BOND_CD                                         AS UNDERLYING_BASE_AST_ID   --底层基础资产编号
        ,NULL                                                   AS AST_SPRT_SCR_SUB_CL      --资产支持证券细类
        ,NULL                                                   AS CRED_RTS_FIN_PROD_SUB_CL --债权融资类产品细类
        ,NULL                                                   AS TRA_PLTF                 --交易平台
        ,NULL                                                   AS UNSTD_TRF_AST_FLG        --非标转标资产标志
        ,A.UDER_BOND_NAME                                       AS BASIC_ASSET_NAME         --底层资产名称
        ,T5.PJ                                                  AS BASIC_ASSET_RATING       --底层资产评级
        ,A.ACRU_INT                                             AS ACRU_INT                 --应计利息
        ,A.INT_RECVBL                                           AS INT_RECVBL               --应收利息
        ,A.RECVBL_UNCOL_INT                                     AS RECVBL_UNCOL_INT         --应收未收利息
        ,A.FINAL_DIR_INDUS_GEN                                  AS FINAL_DIR_INDUS_GEN      --最终投向行业_大类
        ,A.FINAL_DIR_INDUS_SUBCLASS                             AS FINAL_DIR_INDUS_SUBCLASS --最终投向行业_细类
        ,A.DIR_IND_FUND_PART                                    AS DIR_IND_FUND_PART        --投向产业基金的部分
        ,A.DIR_DEBT_EQTY_PART                                   AS DIR_DEBT_EQTY_PART       --投向债转股的部分
        ,A.DIR_PAM_PROD_PART                                    AS DIR_PAM_PROD_PART        --投向私募资产管理产品的部分
        ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS RID                      --业务主键
        ,A.PROD_TYPE_CD                                         AS PROD_TYPE_CD             --产品类型代码
        ,A.ASSET_TYPE_NAME                                      AS ASSET_TYPE_NAME          --资产类型名称
        ,A1.EVHA_VAL_CHAG_PL                                    AS EVHA_VAL_CHAG_PL         --公允价值变动损益
        ,A1.SPD_PL                                              AS SPD_PL                   --价差损益
        ,A1.INT_INCOME                                          AS INT_INCOME               --利息收入
        ,A.STD_PROD_ID                                          AS STD_PROD_ID              --标准产品编号
        ,A.ASSET_THD_CLS_CD                                     AS ASSET_THD_CLS_CD         --资产三分类代码
        ,NVL(T5.ZB,100)                                         AS FNL_DIR_RATIO            --最终投向比例
        ,T5.ID                                                  AS PRO_PK                   --穿透后主键
        ,A.OVDUE_FLG                                            AS OVDUE_FLG                --逾期标志
    FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 -- 同业证券持仓表
      ON A1.FIN_INSTM_ID||'_'||A1.ASSET_THD_CLS_CD||'_'||A1.OBJ_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID
     AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ADD_INVEST_FINAL_DIR T5 --最终投向信息业务补录表
      ON T5.FIN_INSTM_ID = A.FIN_INSTM_ID
    LEFT JOIN RRP_MDL.CODE_MAP COD1 --最终投向行业大类
      ON COD1.SRC_VALUE_CODE = A.FINAL_DIR_INDUS_SUBCLASS
     AND COD1.SRC_CLASS_CODE = 'TXHYXL'
     AND COD1.TAR_CLASS_CODE = 'TXHYXL'
     AND COD1.MOD_FLG = 'MDM'
   WHERE /*A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%'
     AND A.ASSET_TYPE_NAME NOT LIKE '%债券基金%'
     AND */A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --------------------ADD BY HULJ 20220113--------同业证券持仓
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '投资业务投向信息--同业证券持仓';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_DIR
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,PK                          --主键
    ,ACC_ID                      --账户编号
    ,FNL_DIR_TYP                 --最终投向类型
    ,FNL_DIR_IDY                 --最终投向行业
    ,THRO_AFTER_BAL              --穿透后余额
    ,CUR                         --币种
    ,AST_SPRT_SCR_SUM_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,UNDERLYING_BASE_AST_ID      --底层基础资产编号
    ,AST_SPRT_SCR_SUB_CL         --资产支持证券细类
    ,CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
    ,TRA_PLTF                    --交易平台
    ,UNSTD_TRF_AST_FLG           --非标转标资产标志
    ,BASIC_ASSET_NAME            --底层资产名称
    ,BASIC_ASSET_RATING          --底层资产评级
    ,ACRU_INT                    --应计利息
    ,INT_RECVBL                  --应收利息
    ,RECVBL_UNCOL_INT            --应收未收利息
    ,FINAL_DIR_INDUS_GEN         --最终投向行业_大类
    ,FINAL_DIR_INDUS_SUBCLASS    --最终投向行业_细类
    ,DIR_IND_FUND_PART           --投向产业基金的部分
    ,DIR_DEBT_EQTY_PART          --投向债转股的部分
    ,DIR_PAM_PROD_PART           --投向私募资产管理产品的部分
    ,RID                         --业务主键
    ,PROD_TYPE_CD                --产品类型代码
    ,ASSET_TYPE_NAME             --产品类型名称
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,INT_INCOME                  --利息收入
    ,STD_PROD_ID                 --标准产品编号
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,FNL_DIR_RATIO               --最终投向比例
    ,PRO_PK                      --穿透后主键
    ,OVDUE_FLG                   --逾期标志
    )
  SELECT V_P_DATE                                                 AS DATA_DT                     --数据日期
        ,A1.LP_ID                                                 AS LGL_REP_ID                  --法人编号
        ,A1.BELONG_ORG_ID                                         AS ORG_ID                      --机构编号
        ,A1.OBJ_ID                                                AS PK                          --主键
        ,A1.OBJ_ID                                                AS ACC_ID                      --账户编号
        ,'A01'                                                    AS FNL_DIR_TYP                 --最终投向类型 --'A01' 货币市场基金
        ,'0'                                                      AS FNL_DIR_IDY                 --最终投向行业
        ,NVL(A1.ACTL_BAL, 0) + NVL(A1.EVHA_VAL_CHAG, 0)           AS THRO_AFTER_BAL              --穿透后余额
        ,A1.CURR_CD                                               AS CUR                         --币种
        ,NULL                                                     AS AST_SPRT_SCR_SUM_CL         --资产支持证券细类
        ,NULL                                                     AS CRED_RTS_FIN_PROD_SUM_CL    --债权融资类产品细类
        ,NULL                                                     AS DEPT_LINE                   --部门条线
        ,'同业证券持仓'                                           AS DATA_SRC                    --数据来源
        ,NULL                                                     AS UNDERLYING_BASE_AST_ID      --底层基础资产编号
        ,NULL                                                     AS AST_SPRT_SCR_SUB_CL         --资产支持证券细类
        ,NULL                                                     AS CRED_RTS_FIN_PROD_SUB_CL    --债权融资类产品细类
        ,NULL                                                     AS TRA_PLTF                    --交易平台
        ,NULL                                                     AS UNSTD_TRF_AST_FLG           --非标转标资产标志
        ,NULL                                                     AS BASIC_ASSET_NAME            --底层资产名称
        ,NULL                                                     AS BASIC_ASSET_RATING          --底层资产评级
        ,A1.ACRU_INT                                              AS ACRU_INT                    --应计利息
        ,A1.INT_RECVBL                                            AS INT_RECVBL                  --应收利息
        ,NULL                                                     AS RECVBL_UNCOL_INT            --应收未收利息
        ,NULL                                                     AS FINAL_DIR_INDUS_GEN         --最终投向行业_大类
        ,NULL                                                     AS FINAL_DIR_INDUS_SUBCLASS    --最终投向行业_细类
        ,NULL                                                     AS DIR_IND_FUND_PART           --投向产业基金的部分
        ,NULL                                                     AS DIR_DEBT_EQTY_PART          --投向债转股的部分
        ,NULL                                                     AS DIR_PAM_PROD_PART           --投向私募资产管理产品的部分
        ,A1.FIN_INSTM_ID||'_'||A1.ASSET_THD_CLS_CD||'_'||A1.OBJ_ID AS RID                        --业务主键
        ,A1.PROD_TYPE_CD                                          AS PROD_TYPE_CD                --产品类型代码
        ,A1.ASSET_TYPE_NAME                                       AS ASSET_TYPE_NAME             --资产类型名称
        ,A1.EVHA_VAL_CHAG_PL                                      AS EVHA_VAL_CHAG_PL            --公允价值变动损益
        ,A1.SPD_PL                                                AS SPD_PL                      --价差损益
        ,A1.INT_INCOME                                            AS INT_INCOME                  --利息收入
        ,A1.STD_PROD_ID                                           AS STD_PROD_ID                 --标准产品编号
        ,A1.ASSET_THD_CLS_CD                                      AS ASSET_THD_CLS_CD            --资产三分类代码
        ,NVL(T3.PROPORTION,100)                                   AS FNL_DIR_RATIO               --最终投向比例
        ,T3.ID                                                    AS PRO_PK                      --穿透后主键
        ,A1.OVDUE_FLG                                             AS OVDUE_FLG                   --逾期标志
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 -- 同业证券持仓表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM T2 --同业金融工具
      ON T2.FIN_INSTM_ID = A1.FIN_INSTM_ID
     AND T2.ASSET_TYPE_ID = A1.ASSET_TYPE_ID
     AND T2.MARKET_TYPE_ID = A1.MARKET_TYPE_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_RISK_GRADE_PROPORTION T3 --最终投向类型详细信息
      ON T3.I_CODE = A1.FIN_INSTM_ID
     AND T3.A_TYPE = A1.ASSET_TYPE_ID
     AND T3.M_TYPE = A1.MARKET_TYPE_ID
     AND T3.IS_CURRENT = '1'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_RISK_GRADE_RATIO T4 --最终投向类型信息
      ON T4.ID = T3.RISK_ID
     AND T4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP COD2 --最终投向类型
      ON COD2.SRC_VALUE_CODE = T4.ID
     AND COD2.SRC_CLASS_CODE = 'ZZTXLX'
     AND COD2.TAR_CLASS_CODE = 'ZZTXLX'
     AND COD2.MOD_FLG = 'MDM'
   WHERE A1.ASSET_TYPE_NAME LIKE '%货币基金%'
     AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID,PK,RID ,PRO_PK,COUNT(1)
      FROM RRP_MDL.M_CPTL_INVEST_DIR T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, ACC_ID,PK,RID,PRO_PK
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;*/

  --程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);--表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_INVEST_DIR;
/

