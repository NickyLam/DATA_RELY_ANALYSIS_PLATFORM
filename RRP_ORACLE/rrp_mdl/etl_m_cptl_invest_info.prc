CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_INVEST_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_CPTL_INVEST_INFO
  *  功能描述：投资业务信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_INVEST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  程序员    首次创建
  *             2    20220831  hulj      调整资金系统、同业系统取值，增加同业净值型产品投资,同业非标投资,同业证券持仓取数口径。
  *             3    20221101  hulj      投资业务信息-资金系统 修改业务主键
  *             4    20221114  hulj      增加数据重复校验
  *             5    20220116  hulj      增加产品募集方式
  *             6    20230510  XXB       SPV调整客户号（人行要求，业务陆炜迪确认修改）
  *             7    20230528  HYF       修改非标部分账目余额字段取数来源，由账目余额更改为本金余额才能与总分对平
  *             8    20230529  MW        新增净值余额字段NV_BAL
  *             9    20230830  HYF       修改非标部分账目余额字段逻辑改为取持仓表的净价成本（剔除应收未收利息）
  *             10   20230918  HYF       同业债券部分，债券编号不唯一，增加市场类型编号与债券基本信息表保持一致
  *             11   20230926  HYF       同业非标部分，新增本月利息收入、非生息资产标志用于判定是否为非生息资产
  *             12   20231023  HYF       新增利息调整金额、应计利息金额，修改净价余额、公允价值字段取值同报表集市逻辑一致
  *             13   20231026  LYH       新增金融工具名称字段
  *             14   20231117  HYF       新增资产唯一标识编号
  *             15   20231129  hulj      新增房地产债券类型名称
  *             16   20231219  HYF       新增逾期天数
  *             17   20240116  LYH       新增 开放类型代码、本周期开放终止日期、本周期持有到期日期 字段
  *             18   20240308  HYF       新增账簿类型字段
  *             19   20240914  HYF       修改同业债券部分账簿类型
  *             20   20241028  YJY       调整同业债券部分调整ID字段
  *             21   20241113  YJY       新增最终投向类型代码、最终投向行业大类、最终投向行业种类、最终投向行业细类
  *             22   20250210  YJY       新增现金管理类产品标志
  *             23   20250303  YJY       同业债券、资金债权部分新增修正久期字段
  *             24   20250515  LTJ       新增交易对手评级、交易对手评级机构
  *             25   20250704  HYF       修改同业净值型公允价值直取同业系统
  *             26   20250704  LTJ       修改债券评级信息关联逻辑，修复重复数据
  *             27   20250708  YJY       新增验证数据重复语句
  *             28   20251011  YJY       同业债券部分，新增金融工具编号关联确认唯一
  *********************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_LAST_YEAR_END   VARCHAR2(8);           --上年年末 --ADD BY YJY 20250303
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(100);               --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_INVEST_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_INVEST_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_LAST_YEAR_END := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'); --上年年末 --ADD BY YJY 20250303
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
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
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-同业系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT                    --1 数据日期
    ,LGL_REP_ID                 --2 法人编号
    ,ORG_ID                     --3 机构编号
    ,CUST_ID                    --4 客户编号
    ,INVEST_ORG_TYP             --5 投资机构类型
    ,ACC_ID                     --6 账户编号
    ,ACC_TYP                    --7 账户类型
    ,ULYG_PROD_ID               --8 标的产品编号
    ,INVEST_BIZ_VRTY            --9 投资业务品种
    ,OPR_TYP                    --10 经营类型
    ,IN_OUT_FLG                 --11 表内表外标志
    ,CUR                        --12 币种
    ,BIZ_DT                     --13 业务发生日期
    ,EXP_DT                     --14 到期日期
    ,BOOK_BAL                   --15 账面余额
    ,FAIR_VAL                   --16 公允价值
    ,HIS_COST                   --17 历史成本
    ,INT                        --18 利息
    ,NEXT_INT_PAY_DT            --19 下一付息日
    ,RATE_RE_PRC_DT             --20 利率重新定价日期
    ,PRO_IMPT                   --21 减值准备
    ,LVL5_CL                    --22 五级分类
    ,LMT_ID                     --23 额度编号
    ,MGT_MOD                    --24 管理方式
    ,FIN_AST_CL                 --25 金融资产分类
    ,BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
    ,HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
    ,PROD_RAISE_MODE            --28 产品募集方式
    ,HOLD_FACE_VAL              --29 持有面值
    ,SPV_ID                     --30 特定目的载体编号
    ,OPR_MODE                   --31 运行方式
    ,AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
    ,BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率
    ,AMT                        --34 发生额
    ,SELF_VALET_FLG             --35 自营代客标志
    ,DEPT_LINE                  --36 部门条线
    ,DATA_SRC                   --37 数据来源
    ,ID                         --38 业务主键
    ,EVHA_VAL_CHAG_PL           --39 公允价值变动损益
    ,SPD_PL                     --40 价差损益
    ,INT_INCOME                 --41 利息收入
    ,ASSET_THD_CLS_CD           --42 资产三分类代码
    ,STD_PROD_ID                --43 标准产品编号
    ,SUBJ_ID                    --44 科目编号
    ,OBJ_ID                     --45 对象编号
    ,CURRT_BAL                  --46 当期余额
    ,ASSET_TYPE_ID              --47 原始资产类型代码
    ,ASSET_NAME                 --48 资产名称
    ,VALUE_DT                   --49 起息日
    ,LIST_DT                    --50 上市日期
    ,SPEC_AIM_VECTOR_TYPE_CD    --51 特定目的载体类型代码
    ,OVDUE_FLG                  --52 逾期标志
    ,BGN_YEAR_EVHA_VAL_CHAG_PL  --53 年初公允价值变动损益
    ,BGN_YEAR_SPD_PL            --54 年初价差损益
    ,BGN_YEAR_INT_INCOME        --55 年初利息收入
    ,NV_BAL                     --56 净值余额
    ,CNTPTY_NAME                --57 交易对手名称
    ,MARKET_TYPE_ID             --58 市场类型编号
    ,INT_ADJ_AMT                --59 利息调整金额 20231023
    ,ACRU_INT_AMT               --60 应计利息金额 20231023
    ,FIN_INSTM_NAME             --61 金融工具名称 ADD BY LYH 20231026
    ,ASSET_UNIQ_IDF_ID          --62 资产唯一标识编号 ADD BY HYF 20231117
    ,OVD_DAYS                   --63 逾期天数 ADD BY HYF 20231219
    ,ACCT_B_CATE_CD             --64 账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
    ,FINAL_DIR_TYPE_CD          --65 最终投向类型代码    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_GEN        --66 最终投向行业大类    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_MIDDLE_CLASS--67 最终投向行业中类   ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_SUBCLASS   --68 最终投向行业细类    ADD BY YJY 20241113
    ,CASH_MANAGE_FLG            --69 现金管理类产品标志  ADD BY YJY 20250210
    ,CORET_DURAN                --70 修正久期            ADD BY YJY 20250303
    ,RATING_REST_CD             --71 交易对手评级        ADD BY LTJ 20250515
    ,RATING_CORP_CN_NAME        --72 交易对手评级机构    ADD BY LTJ 20250515
    )
    WITH CMM_IBANK_BOND_INVEST_TMP AS (
  SELECT T1.ASSET_THD_CLS_CD
        ,T1.FIN_INSTM_ID,OBJ_ID
        ,SUM(NVL(T1.CORET_DURAN,0)) CORET_DURAN 
    FROM (--当年修正久期
          SELECT T1.ASSET_THD_CLS_CD   AS ASSET_THD_CLS_CD --资产三分类编号
                ,T1.FIN_INSTM_ID       AS FIN_INSTM_ID     --金融工具编号
                ,T1.OBJ_ID             AS OBJ_ID           --对象编号
                ,NVL(T1.ESTIM_CORET_DURAN,CASE WHEN T1.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                                               THEN (T1.EXP_DT - TO_DATE(V_P_DATE,'YYYYMMDD')) / 365 
                                           END) AS CORET_DURAN
            FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST T1 --同业债券投资业务
           WHERE (T1.PRIC_BAL > 0 OR T1.FAIR_VAL_PL <> 0)
             AND T1.EXP_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           UNION ALL --ADD BY YJY 20250303 补充同业债券当前损益为0但年初不为0的数据
          SELECT T1.ASSET_THD_CLS_CD   AS ASSET_THD_CLS_CD     --资产三分类编号
                ,T1.FIN_INSTM_ID       AS FIN_INSTM_ID         --金融工具编号
                ,T1.OBJ_ID             AS OBJ_ID               --对象编号
                ,NVL(T6.ESTIM_CORET_DURAN,CASE WHEN T6.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                                               THEN (T6.EXP_DT - TO_DATE(V_P_DATE,'YYYYMMDD')) / 365 
                                           END) AS CORET_DURAN
            FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST T1 --同业债券投资业务
            LEFT JOIN (SELECT T1.OBJ_ID AS OBJ_ID1
                             ,T2.OBJ_ID AS OBJ_ID2
                             ,T1.FAIR_VAL_PL AS FAIR_VAL_PL1
                             ,T2.FAIR_VAL_PL AS FAIR_VAL_PL2
                          FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST T1
                          LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST T2
                            ON T2.OBJ_ID = T1.OBJ_ID
                           AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                         WHERE T1.FAIR_VAL_PL <> 0 
                           AND T1.ETL_DT = TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')) T5 --上年年末--同业债券投资业务
              ON T1.OBJ_ID = T5.OBJ_ID1
            LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST  T6 --同业债券投资业务
              ON T1.OBJ_ID = T6.OBJ_ID
             AND T6.EXP_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           WHERE T1.FAIR_VAL_PL <> 0 --本金余额/公允价值变动损益
             AND (T5.OBJ_ID2 IS NULL OR T5.FAIR_VAL_PL2 = 0)
             AND T1.ETL_DT = TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')) T1 --上年年末
   GROUP BY T1.ASSET_THD_CLS_CD,T1.FIN_INSTM_ID,T1.OBJ_ID)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                   AS DATA_DT                  --1 数据日期
         ,A.LP_ID                                       AS LGL_REP_ID               --2 法人编号
         ,A.BELONG_ORG_ID                               AS ORG_ID                   --3 机构编号
         ,NVL(A.ISSUER_CUST_ID, A.ISSUER_ID)            AS CUST_ID                  --4 客户编号 取不到发行人客户编号取发行人编号
         ,NULL                                          AS INVEST_ORG_TYP           --5 投资机构类型
         ,A.INTNAL_SECU_ACCT_ID || A.FIN_INSTM_ID       AS ACC_ID                   --6 账户编号
         ,NULL                                          AS ACC_TYP                  --7 账户类型
         ,A.FIN_INSTM_ID                                AS ULYG_PROD_ID             --8 标的产品编号
         ,'A01'                                         AS INVEST_BIZ_VRTY          --9 投资业务品种--01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,TA.TAR_VALUE_CODE                             AS OPR_TYP                  --10 经营类型
         ,'1'                                           AS IN_OUT_FLG               --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                     AS CUR                      --12 币种
         ,TO_CHAR(A.ISSUE_DT,'YYYYMMDD')                AS BIZ_DT                   --13 业务发生日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                  AS EXP_DT                  --14 到期日期
         ,A.BOOK_BAL                                    AS BOOK_BAL                 --15 账面余额
         ,NVL(A.EVHA_VAL_CHAG,0)                        AS FAIR_VAL                 --16 公允价值
         ,NULL                                          AS HIS_COST                 --17 历史成本
         ,A.ACRU_INT                                    AS INT                      --18 利息 --20220702 XUCX
         ,NULL                                          AS NEXT_INT_PAY_DT          --19 下一付息日
         ,NULL                                          AS RATE_RE_PRC_DT           --20 利率重新定价日期
         ,NULL                                          AS PRO_IMPT                 --21 减值准备
         ,NVL(TB.TAR_VALUE_CODE, '01')                  AS LVL5_CL                  --22 五级分类
         ,NULL                                          AS LMT_ID                   --23 额度编号
         ,E.MGMT_MODE_CD                                AS MGT_MOD                  --24 管理方式
         ,TC.TAR_VALUE_CODE                             AS FIN_AST_CL               --25 金融资产分类
         ,NULL                                          AS BIG_AMT_RSK_EXP_EXMPT    --26 大额风险暴露豁免
         ,NULL                                          AS HOLD_UN_BOT_AST_LBY_BAL  --27 持有非底层资产产生的间接负债余额
         ,NULL                                          AS PROD_RAISE_MODE          --28 产品募集方式 --mod by hulj20230116
         ,A.HOLD_FAC_VAL                                AS HOLD_FACE_VAL            --29 持有面值
         ,NULL                                          AS SPV_ID                   --30 特定目的载体编号
         ,E.MOVE_WAY_CD                                 AS OPR_MODE                 --31 运行方式
         ,NULL                                          AS AST_MGT_PROD_STATS_ID    --32 资管产品统计编号
         ,E.FAC_VAL_INT_RAT                             AS BIZ_OCCUR_TMPNT_ACT_RATE --33 业务发生时点实际利率
         ,NULL                                          AS AMT                      --34 发生额
         ,NULL                                          AS SELF_VALET_FLG           --35 自营代客标志
         ,''                                            AS DEPT_LINE                --36 部门条线
         ,'同业债券'                                    AS DATA_SRC                 --37 数据来源
         --A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.INTNAL_SECU_ACCT_ID AS ID --业务主键
         ,A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD
                                                        AS ID                       --38 业务主键    --MOD BY YJY 20241028
         ,F.EVHA_VAL_CHAG_PL                            AS EVHA_VAL_CHAG_PL         --39 公允价值变动损益
         ,F.SPD_PL                                      AS SPD_PL                   --40 价差损益
         ,F.INT_INCOME                                  AS INT_INCOME               --41 利息收入
         ,F.ASSET_THD_CLS_CD                            AS ASSET_THD_CLS_CD         --42 资产三分类代码
         ,A.STD_PROD_ID                                 AS STD_PROD_ID              --43 标准产品编号
         ,A.SUBJ_ID                                     AS SUBJ_ID                  --44 科目编号
         ,A.OBJ_ID                                      AS OBJ_ID                   --45 对象编号
         ,A.CURRT_BAL                                   AS CURRT_BAL                --46 当期余额
         ,A.ASSET_TYPE_ID                               AS ASSET_TYPE_ID            --47 原始资产类型代码
         ,A.ASSET_TYPE_NAME                             AS ASSET_NAME               --48 资产名称
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                AS VALUE_DT                 --49 起息日
         ,TO_CHAR(E.LIST_DT,'YYYYMMDD')                 AS LIST_DT                  --50 上市日期
         ,E.SPEC_AIM_VECTOR_TYPE_CD                     AS SPEC_AIM_VECTOR_TYPE_CD  --52 特定目的载体类型代码
         ,A.OVDUE_FLG                                   AS OVDUE_FLG                --52 逾期标志
         ,F1.EVHA_VAL_CHAG_PL                           AS BGN_YEAR_EVHA_VAL_CHAG_PL --53 年初公允价值变动损益
         ,F1.SPD_PL                                     AS BGN_YEAR_SPD_PL          --54 年初价差损益
         ,F1.INT_INCOME                                 AS BGN_YEAR_INT_INCOME      --55 年初利息收入
         ,NVL(F.NET_PRICE_COST,0)                       AS NV_BAL                   --56 净值余额
         ,CASE WHEN T8.RWA_CUST_CLS_NAME LIKE '境内.资产管理产品%' 
                 OR T8.RWA_CUST_CLS_NAME LIKE '境内.私募基金%'
               THEN SUBSTR(T8.RWA_CUST_CLS_NAME,INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 3) + 2,LENGTH(T8.RWA_CUST_CLS_NAME) - INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 3))
               WHEN INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 2) = 0
               THEN SUBSTR(T8.RWA_CUST_CLS_NAME,INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 1) + 1,LENGTH(T8.RWA_CUST_CLS_NAME) - INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 1))
               WHEN INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 3) = 0
               THEN SUBSTR(T8.RWA_CUST_CLS_NAME,INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 2) + 1,LENGTH(T8.RWA_CUST_CLS_NAME) - INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 2))
               ELSE SUBSTR(T8.RWA_CUST_CLS_NAME, INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 2) + 1,INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 3) - INSTR(T8.RWA_CUST_CLS_NAME, '.', 1, 2)-1)
           END                                           AS CNTPTY_NAME             --57 交易对手名称
         ,A.MARKET_TYPE_ID                               AS MARKET_TYPE_ID          --58 市场类型编号
         ,NVL(F.INT_ADJ_AMT,0)                           AS INT_ADJ_AMT             --59 利息调整金额 20231023
         ,NVL(F.ACRU_INT,0)                              AS ACRU_INT_AMT            --60 应计利息金额 20231023
         ,E.FIN_INSTM_NAME                               AS FIN_INSTM_NAME          --61 金融工具名称 ADD BY LYH 20231026
         ,F.ASSET_UNIQ_IDF_ID                            AS ASSET_UNIQ_IDF_ID       --62 资产唯一标识编号 ADD BY HYF 20231117
         ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS)   AS OVD_DAYS                --63 逾期天数 ADD BY HYF 20231219
         ,T9.ACCT_B_CATE_CD                              AS ACCT_B_CATE_CD          --64 账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
         ,''                                             AS FINAL_DIR_TYPE_CD       --65 最终投向类型代码    ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_GEN                          AS FINAL_DIR_INDUS_GEN     --66 最终投向行业大类    ADD BY YJY 20241113
         ,''                                             AS FINAL_DIR_INDUS_MIDDLE_CLASS --67 最终投向行业中类    ADD BY YJY 20241113
         ,''                                             AS FINAL_DIR_INDUS_SUBCLASS --68 最终投向行业细类    ADD BY YJY 20241113
         ,CASE WHEN E.CASH_MANAGE_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                            AS CASH_MANAGE_FLG          --69 现金管理类产品标志  ADD BY YJY 20250210
         ,T10.CORET_DURAN                                AS CORET_DURAN              --70 修正久期            ADD BY YJY 20250303
         ,D.RATING_REST_CD                               AS RATING_REST_CD           --71 交易对手评级        ADD BY LTJ 20250515
         ,D.RATING_CORP_CN_NAME                          AS RATING_CORP_CN_NAME      --72 交易对手评级机构    ADD BY LTJ 20250515
    FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A --同业债券投资    
    LEFT JOIN (SELECT ETL_DT  
                     ,BOND_ID              --债券编号
                     ,ASSET_TYPE_ID        --资产类型编号
                     ,BOND_MARKET_TYPE_CD  --债券市场类型代码
                     ,RATING_REST_CD       --评级结果代码
                     ,RATING_CORP_CN_NAME  --评级公司中文名称
                     ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO --债券评级信息 --MOD BY LTJ 20250704
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) D
      ON D.BOND_ID||D.ASSET_TYPE_ID||D.BOND_MARKET_TYPE_CD = A.FIN_INSTM_ID ||A.ASSET_TYPE_ID|| A.MARKET_TYPE_ID     
     AND D.RN =1
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM E --同业金融工具
      ON E.FIN_INSTM_ID || E.MARKET_TYPE_ID = A.FIN_INSTM_ID || A.MARKET_TYPE_ID
     AND E.ASSET_TYPE_ID = A.ASSET_TYPE_ID     --20221013 XUXIAOBIN MODIFY
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST F  --同业证券持仓
      ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND F.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND F.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND F.FIN_INSTM_ID||'_'||F.ASSET_THD_CLS_CD||'_'||F.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.INTNAL_SECU_ACCT_ID
     AND F.OBJ_ID = A.OBJ_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST F1  --同业证券持仓 取年末公允价值变动损益、价差损益、利息收入
      ON F1.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND F1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND F1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND F1.OBJ_ID = A.OBJ_ID
     AND F1.FIN_INSTM_ID||'_'||F1.ASSET_THD_CLS_CD||'_'||F1.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.INTNAL_SECU_ACCT_ID
     AND F1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C
      ON C.FIN_INSTM_ID = F.FIN_INSTM_ID
     AND C.MARKET_TYPE_ID = F.MARKET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO T8
      ON T8.SRC_PARTY_ID = C.MGER_ID
     AND T8.STATUS_CD = '2' --已启用
     AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT A.FIN_INSTM_ID
                     ,A.ASSET_THD_CLS_CD
                     ,A.INTNAL_SECU_ACCT_ID
                     ,MAX(CASE WHEN REPLACE(T9.ACCT_B_CATE_CD,'-','') = 'Trade' THEN 'T' ELSE 'B' END) AS ACCT_B_CATE_CD
                 FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A
                 LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST F
                   ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
                  AND F.MARKET_TYPE_ID = A.MARKET_TYPE_ID
                  AND F.ASSET_TYPE_ID = A.ASSET_TYPE_ID
                  AND F.FIN_INSTM_ID||'_'||F.ASSET_THD_CLS_CD||'_'||F.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.INTNAL_SECU_ACCT_ID
                  AND F.OBJ_ID = A.OBJ_ID
                  AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN T9
                   ON F.ASSET_TYPE_ID = T9.ASSET_TYPE_ID
                  AND F.MARKET_TYPE_ID = T9.TRAN_MARKET_ID
                  AND F.INTNAL_SECU_ACCT_ID = T9.INTNAL_SECU_ACCT_ID
                  AND F.FIN_INSTM_ID = T9.FIN_INSTM_ID --MOD BY YJY 20251011 以上三个字段无法确认唯一，需新增金融工具编号关联
                  AND T9.TRAN_STATUS_CD > 0
                  AND T9.DLVY_DT > TO_DATE('20211231','YYYYMMDD')
                  AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE A.ASSET_TYPE_ID IN ('SPT_BD', 'SPT_CB', 'SPT_ABS') --资产类型编号
                  AND A.EXTRA_DIMEN_CD = 'L' --额外维度代码
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY A.FIN_INSTM_ID,A.ASSET_THD_CLS_CD,A.INTNAL_SECU_ACCT_ID ) T9
      ON T9.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND T9.ASSET_THD_CLS_CD = A.ASSET_THD_CLS_CD
     AND T9.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
    LEFT JOIN CMM_IBANK_BOND_INVEST_TMP T10  --补充修正久期的数据  ADD BY YJY 20250303
      ON T10.OBJ_ID || '_' || T10.FIN_INSTM_ID || '_' || T10.ASSET_THD_CLS_CD = A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级分类转码
      ON TB.SRC_VALUE_CODE = F.LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TA
      ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1479'
     AND TA.TAR_CLASS_CODE = 'D0046'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
     --AND A.BOOK_BAL > 0  --1104用四件套进行加工，会存在账面余额为0的情况
     /*AND (A.ASSET_TYPE_NAME LIKE '%公司债%' OR A.ASSET_TYPE_NAME LIKE '%企业债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持%'
           OR A.ASSET_TYPE_NAME LIKE '%其他债券%' OR A.ASSET_TYPE_NAME LIKE '%私募债%' )*/
     --AND A.SUBJ_ID IS NOT NULL --需拿6月底前余额为0的债券
     /*AND A.BOOK_BAL > 0*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*****************资金系统*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-资金系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT                    --1 数据日期
    ,LGL_REP_ID                 --2 法人编号
    ,ORG_ID                     --3 机构编号
    ,CUST_ID                    --4 客户编号
    ,INVEST_ORG_TYP             --5 投资机构类型
    ,ACC_ID                     --6 账户编号
    ,ACC_TYP                    --7 账户类型
    ,ULYG_PROD_ID               --8 标的产品编号
    ,INVEST_BIZ_VRTY            --9 投资业务品种
    ,OPR_TYP                    --10 经营类型
    ,IN_OUT_FLG                 --11 表内表外标志
    ,CUR                        --12 币种
    ,BIZ_DT                     --13 业务发生日期
    ,EXP_DT                     --14 到期日期
    ,BOOK_BAL                   --15 账面余额
    ,FAIR_VAL                   --16 公允价值
    ,HIS_COST                   --17 历史成本
    ,INT                        --18 利息
    ,NEXT_INT_PAY_DT            --19 下一付息日
    ,RATE_RE_PRC_DT             --20 利率重新定价日期
    ,PRO_IMPT                   --21 减值准备
    ,LVL5_CL                    --22 五级分类
    ,LMT_ID                     --23 额度编号
    ,MGT_MOD                    --24 管理方式
    ,FIN_AST_CL                 --25 金融资产分类
    ,BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
    ,HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
    ,PROD_RAISE_MODE            --28 产品募集方式
    ,HOLD_FACE_VAL              --29 持有面值
    ,SPV_ID                     --30 特定目的载体编号
    ,OPR_MODE                   --31 运行方式
    ,AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
    ,BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率
    ,AMT                        --34 发生额
    ,SELF_VALET_FLG             --35 自营代客标志
    ,DEPT_LINE                  --36 部门条线
    ,DATA_SRC                   --37 数据来源
    ,ID                         --38 业务主键
    ,EVHA_VAL_CHAG_PL           --39 公允价值变动损益
    ,SPD_PL                     --40 价差损益
    ,INT_INCOME                 --41 利息收入
    ,ASSET_THD_CLS_CD           --42 资产三分类代码
    ,STD_PROD_ID                --43 标准产品编号
    ,SUBJ_ID                    --44 科目编号
    ,OBJ_ID                     --45 对象编号
    ,CURRT_BAL                  --46 当期余额
    ,ASSET_TYPE_ID              --47 原始资产类型代码
    ,ASSET_NAME                 --48 资产名称
    ,VALUE_DT                   --49 起息日
    ,LIST_DT                    --50 上市日期
    ,SPEC_AIM_VECTOR_TYPE_CD    --51 特定目的载体类型代码
    ,BGN_YEAR_EVHA_VAL_CHAG_PL  --52 年初公允价值变动损益
    ,BGN_YEAR_SPD_PL            --53 年初价差损益
    ,BGN_YEAR_INT_INCOME        --54 年初利息收入
    ,NV_BAL                     --55 净值余额
    ,MARKET_TYPE_ID             --56 市场类型编号
    ,INT_ADJ_AMT                --57 利息调整金额 20231023
    ,ACRU_INT_AMT               --58 应计利息金额 20231023
    ,FIN_INSTM_NAME             --59 金融工具名称 ADD BY LYH 20231026
    ,ESTATE_BOND_TYPE_NAME      --60 房地产债券类型名称 add by hulj 20231129
    ,OVD_DAYS                   --61 逾期天数 ADD BY HYF 20231219
    ,ACCT_B_CATE_CD             --62 账簿类型 T-交易账簿 B-银行账簿
    ,FINAL_DIR_TYPE_CD          --63 最终投向类型代码    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_GEN        --64 最终投向行业大类    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_MIDDLE_CLASS --65 最终投向行业中类  ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_SUBCLASS   --66 最终投向行业细类    ADD BY YJY 20241113
    ,CASH_MANAGE_FLG            --67 现金管理类产品标志  ADD BY YJY 20250210
    ,CORET_DURAN                --68 修正久期            ADD BY YJY 20250303
    ,RATING_REST_CD             --69 交易对手评级        ADD BY LTJ 20250515
    ,RATING_CORP_CN_NAME        --70 交易对手评级机构    ADD BY LTJ 20250515
    )
  --ADD BY YJY 20250303 取修正久期
    WITH CMM_CAP_BOND_INVEST_TMP AS (
  SELECT TO_CHAR(T1.ETL_DT,'YYYYMMDD')  AS ETL_DT            --数据日期
         ,T1.ASSET_TYPE_NAME            AS ACCT_NAME         --资产类型名称
         ,T1.BOND_TYPE_CD               AS BOND_CLS_CD       --债券类型代码
         ,T1.BOND_ID                    AS BOND_ID           --债券编号
         ,T1.BOND_NAME                  AS BOND_NAME         --债券名称
         ,T1.ASSET_THD_CLS_CD           AS ASSET_THD_CLS_CD  --资产三分类代码
         ,T1.TRAN_ACCT_B_ID             AS TRAN_ACCT_B_ID    --交易账簿编号
         ,NVL(T1.ESTIM_CORET_DURAN,CASE WHEN T1.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                                        THEN (T1.EXP_DT - TO_DATE(V_P_DATE,'YYYYMMDD')) / 365
                                    END) AS CORET_DURAN       --修正久期
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST T1 --资金债券投资业务
   WHERE (CASE WHEN SUBSTR(V_P_DATE,5,4) = '1231' AND T1.EVHA_VAL_CHAG_PL_CARR_BF <> 0 THEN 1
               WHEN SUBSTR(V_P_DATE,5,4) <> '1231' AND (T1.HOLD_POS > 0 OR T1.EVHA_VAL_CHAG_PL <> 0) THEN 1
               ELSE 0 
           END) = 1
     AND TRIM(T1.BUS_CATE_NAME) = '现券' --业务类别名称
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))--持有仓位/公允价值变动损益
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                  AS DATA_DT                    --1 数据日期
         ,A.LP_ID                                       AS LGL_REP_ID                 --2 法人编号
         ,A.ENTRY_ORG_ID                                AS ORG_ID                     --3 机构编号
         ,NVL(A.ISSUER_CUST_ID,B.ISSUER_CD)             AS CUST_ID                    --4 客户编号 发行人客户编号为空就取发行人编号
         ,NULL                                          AS INVEST_ORG_TYP             --5 投资机构类型
         ,A.BOND_ID || A.TRAN_ACCT_B_ID                 AS ACC_ID                     --6 账户编号
         ,A.ACCT_ATTR_CD                                AS ACC_TYP                    --7 账户类型
         ,A.BOND_ID                                     AS ULYG_PROD_ID               --8 标的产品编号
         ,'A01'                                         AS INVEST_BIZ_VRTY            --9 投资业务品种--01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,'A'                                           AS OPR_TYP                    --10 经营类型
         ,'1'                                           AS IN_OUT_FLG                 --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                     AS CUR                        --12 币种
         ,TO_CHAR(A.ISSUE_DT,'YYYYMMDD')                AS BIZ_DT                     --13 业务发生日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                  AS EXP_DT                     --14 到期日期
         ,A.BOOK_BAL                                    AS BOOK_BAL                   --15 账面余额
         ,A.EVHA_VAL_CHAG                               AS FAIR_VAL                   --16 公允价值
         ,NULL                                          AS HIS_COST                   --17 历史成本
         ,A.ACRU_INT                                    AS INT                        --18 利息 应计利息
         ,NULL                                          AS NEXT_INT_PAY_DT            --19 下一付息日
         ,NULL                                          AS RATE_RE_PRC_DT             --20 利率重新定价日期
         ,NULL                                          AS PRO_IMPT                   --21 减值准备
         ,'01'                                          AS LVL5_CL                    --22 五级分类
         ,NULL                                          AS LMT_ID                     --23 额度编号
         ,B.MGMT_MODE_CD                                AS MGT_MOD                    --24 管理方式
         ,TC.TAR_VALUE_CODE                             AS FIN_AST_CL                 --25 金融资产分类
         ,NULL                                          AS BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
         ,NULL                                          AS HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
         ,NULL                                          AS PROD_RAISE_MODE            --28 产品募集方式   mod by hulj20230116
         ,A.HOLD_FAC_VAL                                AS HOLD_FACE_VAL              --29 持有面值
         ,NULL                                          AS SPV_ID                     --30 特定目的载体编号
         ,E.MOVE_WAY_CD                                 AS OPR_MODE                   --31 运行方式
         ,NULL                                          AS AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
         ,A.FAC_VAL_INT_RAT                             AS BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率 --20221013 XUXIAOBIN MODIFY
         ,NULL                                          AS AMT                        --34 发生额
         ,NULL                                          AS SELF_VALET_FLG             --35 自营代客标志
         ,''                                            AS DEPT_LINE                  --36 部门条线 20220805 XUXIAOBIN
         ,'资金债券'                                    AS DATA_SRC                   --37 数据来源
         /*A.FIN_INSTM_ID || '_' || */
         ,A.BOND_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.TRAN_ACCT_B_ID
                                                        AS ID                          --38 业务主键 --modify by hulj20221101
         ,A.EVHA_VAL_CHAG_PL                            AS EVHA_VAL_CHAG_PL            --39 公允价值变动损益
         ,A.SPD_PRFT                                    AS SPD_PL                      --40 价差损益
         ,A.INT_PRFT                                    AS INT_INCOME                  --41 利息收入
         ,A.ASSET_THD_CLS_CD                            AS ASSET_THD_CLS_CD            --42 资产三分类代码
         ,A.STD_PROD_ID                                 AS STD_PROD_ID                 --43 标准产品编号
         ,A.SUBJ_ID                                     AS SUBJ_ID                     --44 科目编号
         ,NULL                                          AS OBJ_ID                      --45 对象编号
         ,A.CURRT_BAL                                   AS CURRT_BAL                   --46 当期余额
         ,A.BOND_TYPE_CD                                AS ASSET_TYPE_ID               --47 原始资产类型代码
         ,A.ASSET_TYPE_NAME                             AS ASSET_NAME                  --48 资产名称
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                AS VALUE_DT                    --49 起息日
         ,TO_CHAR(E.LIST_DT,'YYYYMMDD')                 AS LIST_DT                     --50 上市日期
         ,E.SPEC_AIM_VECTOR_TYPE_CD                     AS SPEC_AIM_VECTOR_TYPE_CD     --51 特定目的载体类型代码
         ,NVL(A1.EVHA_VAL_CHAG_PL,0)                    AS BGN_YEAR_EVHA_VAL_CHAG_PL   --52 年初公允价值变动损益
         ,NVL(A1.SPD_PRFT,0)                            AS BGN_YEAR_SPD_PL             --53 年初价差损益
         ,NVL(A1.INT_PRFT,0)                            AS BGN_YEAR_INT_INCOME         --54 年初利息收入
         ,NVL(A.CURRT_BAL,0)                            AS NV_BAL                      --55 净值余额
         ,B.ASSET_TYPE_ID||'_'||B.BOND_MARKET_TYPE_CD   AS MARKET_TYPE_ID              --56 市场类型编号
         ,NVL(A.INT_ADJ_AMT,0)                          AS INT_ADJ_AMT                 --57 利息调整金额 20231023
         ,NVL(A.ACRU_INT,0)                             AS ACRU_INT_AMT                --58 应计利息金额 20231023
         ,E.FIN_INSTM_NAME                              AS FIN_INSTM_NAME              --59 金融工具名称 ADD BY LYH 20231026
         ,B.ESTATE_BOND_TYPE_NAME                       AS ESTATE_BOND_TYPE_NAME       --60 房地产债券类型名称 add by hulj 20231129
         ,0                                             AS OVD_DAYS                    --61 逾期天数 ADD BY HYF 20231219
         ,CASE WHEN A.ACCT_ATTR_CD = 'T' THEN 'T'
               ELSE 'B'
          END                                           AS ACCT_B_CATE_CD              --62 账簿类型 T-交易账簿 B-银行账簿
         ,''                                            AS FINAL_DIR_TYPE_CD           --63 最终投向类型代码    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_GEN         --64 最终投向行业大类    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_MIDDLE_CLASS--65 最终投向行业中类    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_SUBCLASS    --66 最终投向行业细类    ADD BY YJY 20241113
         ,CASE WHEN E.CASH_MANAGE_FLG='1' THEN 'Y'
               ELSE 'N'
          END                                           AS CASH_MANAGE_FLG             --67 现金管理类产品标志  ADD BY YJY 20250210
         ,C.CORET_DURAN                                 AS CORET_DURAN                 --68 修正久期            ADD BY YJY 20250303
         ,D.RATING_REST_CD                              AS RATING_REST_CD              --69 交易对手评级        ADD BY LTJ 20250515
         ,D.RATING_CORP_CN_NAME                         AS RATING_CORP_CN_NAME         --70 交易对手评级机构    ADD BY LTJ 20250515
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A --资金债券投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息表
      ON B.BOND_ID = A.BOND_ID
     AND B.DATA_SRC_SYS_IDF = 'CTMS'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A1 --资金债券投资表 取年初数据
      ON A1.BOND_ID = A.BOND_ID
     AND A1.BOND_TYPE_CD = A.BOND_TYPE_CD
     AND A1.TRAN_ACCT_B_ID = A.TRAN_ACCT_B_ID
     AND A1.BOND_ID || '_' || A1.ASSET_THD_CLS_CD || '_' || A1.TRAN_ACCT_B_ID = A.BOND_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.TRAN_ACCT_B_ID
     AND A1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1 --年初数据
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM E
      ON E.FIN_INSTM_ID = A.BOND_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN CMM_CAP_BOND_INVEST_TMP C --资金债券投资表  ADD BY YJY 20250303 取修正久期
      ON C.BOND_ID || '_' || C.ASSET_THD_CLS_CD || '_' || C.TRAN_ACCT_B_ID = A.BOND_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.TRAN_ACCT_B_ID
    LEFT JOIN ( SELECT ETL_DT
                       ,BOND_ID             --债券编号
                       ,ASSET_TYPE_ID       --资产类型编号
                       ,BOND_MARKET_TYPE_CD --债券市场类型代码
                       ,RATING_REST_CD      --评级结果代码
                       ,RATING_CORP_CN_NAME --评级公司中文名称
                       ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO  --债券评级信息 --MOD BY LTJ 20250704 
                 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND BOND_TYPE_CD IS NOT NULL ) D --MOD BY YJY 20250708 债券类型代码不为空
      ON D.BOND_ID = A.BOND_ID   
     AND D.RN =1
   WHERE B.DATA_SRC_SYS_IDF = 'CTMS' --数据来源系统标识
     --AND B.ISSUER_CD IS NOT NULL  --发行人编号不为空
     /*AND A.BOOK_BAL > 0*/
     AND A.BOND_TYPE_CD <> 'W' --W 为同业存单
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*****************特定载体*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-特定载体';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT                      --1 数据日期
    ,LGL_REP_ID                   --2 法人编号
    ,ORG_ID                       --3 机构编号
    ,CUST_ID                      --4 客户编号
    ,INVEST_ORG_TYP               --5 投资机构类型
    ,ACC_ID                       --6 账户编号
    ,ACC_TYP                      --7 账户类型
    ,ULYG_PROD_ID                 --8 标的产品编号
    ,INVEST_BIZ_VRTY              --9 投资业务品种
    ,OPR_TYP                      --10 经营类型
    ,IN_OUT_FLG                   --11 表内表外标志
    ,CUR                          --12 币种
    ,BIZ_DT                       --13 业务发生日期
    ,EXP_DT                       --14 到期日期
    ,BOOK_BAL                     --15 账面余额
    ,FAIR_VAL                     --16 公允价值
    ,HIS_COST                     --17 历史成本
    ,INT                          --18 利息
    ,NEXT_INT_PAY_DT              --19 下一付息日
    ,RATE_RE_PRC_DT               --20 利率重新定价日期
    ,PRO_IMPT                     --21 减值准备
    ,LVL5_CL                      --22 五级分类
    ,LMT_ID                       --23 额度编号
    ,MGT_MOD                      --24 管理方式
    ,FIN_AST_CL                   --25 金融资产分类
    ,BIG_AMT_RSK_EXP_EXMPT        --26 大额风险暴露豁免
    ,HOLD_UN_BOT_AST_LBY_BAL      --27 持有非底层资产产生的间接负债余额
    ,PROD_RAISE_MODE              --28 产品募集方式
    ,HOLD_FACE_VAL                --29 持有面值
    ,SPV_ID                       --30 特定目的载体编号
    ,OPR_MODE                     --31 运行方式
    ,AST_MGT_PROD_STATS_ID        --32 资管产品统计编号
    ,BIZ_OCCUR_TMPNT_ACT_RATE     --33 业务发生时点实际利率
    ,AMT                          --34 发生额
    ,SELF_VALET_FLG               --35 自营代客标志
    ,DEPT_LINE                    --36 部门条线
    ,DATA_SRC                     --37 数据来源
    ,ID                           --38 业务主键
    ,ASSET_TYPE_ID                --39 原始资产类型代码
    ,ASSET_NAME                   --40 资产名称
    ,EVHA_VAL_CHAG_PL             --41 公允价值变动损益
    ,SPD_PL                       --42 价差损益
    ,INT_INCOME                   --43 利息收入
    ,ASSET_THD_CLS_CD             --44 资产三分类代码
    ,STD_PROD_ID                  --45 标准产品编号
    ,SUBJ_ID                      --46 科目编号
    ,OBJ_ID                       --47 对象编号
    ,CURRT_BAL                    --48 当期余额
    ,VALUE_DT                     --49 起息日
    ,LIST_DT                      --50 上市日期
    ,SPEC_AIM_VECTOR_TYPE_CD      --51 特定目的载体类型代码
    ,OVDUE_FLG                    --52 逾期标志
    ,BGN_YEAR_EVHA_VAL_CHAG_PL    --53 年初公允价值变动损益
    ,BGN_YEAR_SPD_PL              --54 年初价差损益
    ,BGN_YEAR_INT_INCOME          --55 年初利息收入
    ,NV_BAL                       --56 净值余额
    ,INT_ADJ_AMT                  --57 利息调整金额 20231023
    ,ACRU_INT_AMT                 --58 应计利息金额 20231023
    ,FIN_INSTM_NAME               --59 金融工具名称 ADD BY LYH 20231026
    ,ASSET_UNIQ_IDF_ID            --60 资产唯一标识编号 ADD BY HYF 20231117
    ,OVD_DAYS                     --61 逾期天数 ADD BY HYF 20231219
    ,OPEN_TYPE_CD                 --62 开放类型代码 ADD BY LYH 20240116
    ,THIS_PED_OPEN_TERMNT_DT      --63 本周期开放终止日期 ADD BY LYH 20240116
    ,THIS_PED_HOLD_EXP_DT         --64 本周期持有到期日期 ADD BY LYH 20240116
    ,ACCT_B_CATE_CD               --65 账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
    ,FINAL_DIR_TYPE_CD            --66 最终投向类型代码    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_GEN          --67 最终投向行业大类    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_MIDDLE_CLASS --68 最终投向行业中类    ADD BY YJY 20241113
    ,FINAL_DIR_INDUS_SUBCLASS     --69 最终投向行业细类    ADD BY YJY 20241113
    ,CASH_MANAGE_FLG              --70 现金管理类产品标志  ADD BY YJY 20250210
    ,RATING_REST_CD               --71 交易对手评级        ADD BY LTJ 20250515
    ,RATING_CORP_CN_NAME          --72 交易对手评级机构    ADD BY LTJ 20250515
    )
  --技术口径-同业净值型产品投资
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                  AS DATA_DT                    --1 数据日期
         ,A.LP_ID                                       AS LGL_REP_ID                 --2 法人编号
         ,A.BELONG_ORG_ID                               AS ORG_ID                     --3 机构编号
         ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),
                   TRIM(D.CUST_ID),TRIM(F1.CUST_ID),TRIM(H.CUST_ID),TRIM(G.ACTL_FINER_CUST_ID),
                   TRIM(TRIM(H.SRC_PARTY_ID)),'-')      AS CUST_ID                    --4 客户编号
         ,NULL                                          AS INVEST_ORG_TYP             --5 投资机构类型
         ,A.FIN_INSTM_ID                                AS ACC_ID                     --6 账户编号
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%'
                 OR A.ASSET_TYPE_NAME LIKE '%货币基金%'
                 OR A.ASSET_TYPE_NAME LIKE '%理财%'
                 OR A.ASSET_TYPE_NAME LIKE '%信托计划%'
                 OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
                 OR A.ASSET_TYPE_NAME LIKE '%资%管%计划%'
                 OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
                 OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'
                 OR A.ASSET_TYPE_NAME = '类信贷资产'
               THEN '1'
               ELSE '2'
          END                                           AS ACC_TYP                    --7 账户类型
         ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID
                                                        AS ULYG_PROD_ID               --8 标的产品编号 20221102XUXIAOBIN MODIFY
         ,'A03'                                         AS INVEST_BIZ_VRTY            --9 投资业务品种 --01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,TA.TAR_VALUE_CODE                             AS OPR_TYP                    --10 经营类型
         ,'1'                                           AS IN_OUT_FLG                 --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                     AS CUR                        --12 币种
         ,CASE WHEN TO_CHAR(A.VALUE_DT,'YYYYMMDD') <> '00010101'
               THEN TO_CHAR(A.VALUE_DT,'YYYYMMDD')
               WHEN TO_CHAR(A.VALUE_DT,'YYYYMMDD') = '00010101' AND TO_CHAR(A.SUBSCR_DT,'YYYYMMDD') <> '00010101'
               THEN TO_CHAR(A.SUBSCR_DT,'YYYYMMDD')
               ELSE NULL
          END                                           AS BIZ_DT                     --13 业务发生日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYY-MM-DD') = '2999-12-31' THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD') --其它因数据补全暂按现逻辑
           END                                          AS EXP_DT                     --14 到期日期 20220905 XUXIAOBIN MODIFY
         ,A.BOOK_BAL                                    AS BOOK_BAL                   --15 账面余额
         ,A.EVHA_VAL_CHAG                               AS FAIR_VAL                   --16 公允价值 --20250704 
         ,NULL                                          AS HIS_COST                   --17 历史成本
         ,A.ACRU_INT                                    AS INT                        --18 利息 --20220702 应计利息
         ,NULL                                          AS NEXT_INT_PAY_DT            --19 下一付息日
         ,NULL                                          AS RATE_RE_PRC_DT             --20 利率重新定价日期
         ,NULL                                          AS PRO_IMPT                   --21 减值准备
         ,NVL(TB.TAR_VALUE_CODE,'01')                   AS LVL5_CL                    --22 五级分类
         ,NULL                                          AS LMT_ID                     --23 额度编号
         ,G.MGMT_MODE_CD                                AS MGT_MOD                    --24 管理方式
         ,TC.TAR_VALUE_CODE                             AS FIN_AST_CL                 --25 金融资产分类
         ,NULL                                          AS BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
         ,NULL                                          AS HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
         ,CASE WHEN A.UDER_COLL_WAY_CD = '0' THEN 'A'
               WHEN A.UDER_COLL_WAY_CD = '1' THEN 'B'
           END                                          AS PROD_RAISE_MODE            --28 产品募集方式 --MOD BY HULJ 20230116
         ,A.FAC_VAL_AMT                                 AS HOLD_FACE_VAL              --29 持有面值
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%'
               THEN 'G'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%理财%'
               THEN 'A'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR G.FIN_INSTM_NAME LIKE '%信托%' OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
               THEN 'B'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划'
               THEN 'F'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%'
                AND A.ASSET_TYPE_NAME NOT LIKE '保险资管计划'
                 OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
                 OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'
              THEN 'C'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
              WHEN A.ASSET_TYPE_NAME = '类信贷资产'
              THEN 'Z'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
              ELSE ''
          END                                           AS SPV_ID                     --30 特定目的载体编号
         ,G.MOVE_WAY_CD                                 AS OPR_MODE                   --31 运行方式
         ,NULL                                          AS AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
         ,NULL                                          AS BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率
         ,NULL                                          AS AMT                        --34 发生额
         ,NULL                                          AS SELF_VALET_FLG             --35 自营代客标志
         ,''                                            AS DEPT_LINE                  --36 部门条线
         ,'同业净值型'                                  AS DATA_SRC                   --37 数据来源
         ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID                --38业务主键
         ,G.ASSET_TYPE_ID                               AS ASSET_TYPE_ID              --39原始资产类型代码
         ,A.ASSET_TYPE_NAME                             AS ASSET_NAME                 --40资产名称
         ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC') OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002',
                   '304020100003','304020100004','304030100001','304030100002','304030100003','304030100004','304040100001',
                   '304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
               --业务要求这些产品的公允价值变动从减估值系统取
               THEN NVL(T5.N_PV_VARIATION,0)
               ELSE NVL(F.EVHA_VAL_CHAG_PL,0)
          END                                          AS EVHA_VAL_CHAG_PL            --41公允价值变动损益
        ,F.SPD_PL                                      AS SPD_PL                      --42价差损益
        ,F.INT_INCOME                                  AS INT_INCOME                  --43利息收入
        ,A.ASSET_THD_CLS_CD                            AS ASSET_THD_CLS_CD            --44资产三分类代码
        ,A.STD_PROD_ID                                 AS STD_PROD_ID                 --45标准产品编号
        ,A.SUBJ_ID                                     AS SUBJ_ID                     --46科目编号
        ,A.OBJ_ID                                      AS OBJ_ID                      --47对象编号
        ,A.CURRT_BAL                                   AS CURRT_BAL                   --48当期余额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                AS VALUE_DT                    --49起息日
        ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ('29991231','00010101') THEN NULL
              ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD')
          END                                          AS LIST_DT                     --50上市日期
        ,G.SPEC_AIM_VECTOR_TYPE_CD                     AS SPEC_AIM_VECTOR_TYPE_CD     --51特定目的载体类型代码
        ,A.OVDUE_FLG                                   AS OVDUE_FLG                   --52逾期标志
        ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC') OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002',
                   '304020100003','304020100004','304030100001','304030100002','304030100003','304030100004','304040100001',
                   '304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
              --业务要求这些产品的公允价值变动从减估值系统取
              THEN NVL(T6.N_PV_VARIATION,0)
              ELSE NVL(F2.EVHA_VAL_CHAG_PL,0)
          END                                          AS BGN_YEAR_EVHA_VAL_CHAG_PL   --53年初公允价值变动损益
         ,NVL(F2.SPD_PL,0)                             AS BGN_YEAR_SPD_PL             --54年初价差损益
         ,NVL(F2.INT_INCOME,0)                         AS BGN_YEAR_INT_INCOME         --55年初利息收入
         ,NVL(F.NET_PRICE_COST,0)                      AS NV_BAL                      --56净值余额
         ,NVL(F.INT_ADJ_AMT,0)                         AS INT_ADJ_AMT                 --57利息调整金额 20231023
         ,NVL(F.ACRU_INT,0)                            AS ACRU_INT_AMT                --58应计利息金额 20231023
         ,G.FIN_INSTM_NAME                             AS FIN_INSTM_NAME              --59金融工具名称 ADD BY LYH 20231026
         ,F.ASSET_UNIQ_IDF_ID                          AS ASSET_UNIQ_IDF_ID           --60资产唯一标识编号 ADD BY HYF 20231117
         ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS) AS OVD_DAYS                    --61逾期天数 ADD BY HYF 20231219
         ,G.OPEN_TYPE_CD                               AS OPEN_TYPE_CD                --62开放类型代码 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_OPEN_TERMNT_DT,'YYYYMMDD')AS THIS_PED_OPEN_TERMNT_DT     --63本周期开放终止日期 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_HOLD_EXP_DT,'YYYYMMDD')   AS THIS_PED_HOLD_EXP_DT        --64本周期持有到期日期 ADD BY LYH 20240116
         ,CASE WHEN T9.ACCT_B_CATE_CD = 'Trade' THEN 'T'
               ELSE 'B'
          END                                          AS ACCT_B_CATE_CD              --65账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
         ,A.FINAL_DIR_TYPE_CD                          AS FINAL_DIR_TYPE_CD           --66最终投向类型代码    ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_GEN                        AS FINAL_DIR_INDUS_GEN         --67最终投向行业大类    ADD BY YJY 20241113
         ,''                                           AS FINAL_DIR_INDUS_MIDDLE_CLASS--68最终投向行业中类    ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_SUBCLASS                   AS FINAL_DIR_INDUS_SUBCLASS    --69最终投向行业细类    ADD BY YJY 20241113
         ,CASE WHEN G.CASH_MANAGE_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                          AS CASH_MANAGE_FLG             --70现金管理类产品标志  ADD BY YJY 20250210
         ,R.RATING_REST_CD                             AS RATING_REST_CD              --71评级结果代码        ADD BY LTJ 20250515
         ,R.RATING_CORP_CN_NAME                        AS RATING_CORP_CN_NAME         --72评级公司中文名称    ADD BY LTJ 20250515
    FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A --同业净值型产品投资
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
      ON D.CUST_ID = A.UDER_ACTL_FINER_CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
      ON E.SPV_CUST_ID = A.UDER_ACTL_FINER_CUST_ID
     AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F1 --对公客户信息
      ON F1.CUST_ID = E.PARTY_ID
     AND F1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
      ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST F --同业证券持仓
      ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND F.BUS_ID = A.BUS_ID --20220924 XUXIAOBIN数据发散，加条件
     AND F.OBJ_ID = A.OBJ_ID --20220924 XUXIAOBIN数据发散，加条件
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST F2 --同业证券持仓 取年初数据
      ON F2.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND F2.BUS_ID = A.BUS_ID
     AND F2.OBJ_ID = A.OBJ_ID
     AND F2.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL T5 --减值结果表
      ON T5.V_FINANCIAL_ID = A.FIN_INSTM_ID
     AND T5.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
     AND T5.V_ID_NUMBER = A.OBJ_ID
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL T6 --减值结果表 取年初数据
      ON T6.V_FINANCIAL_ID = A.FIN_INSTM_ID
     AND T6.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
     AND T6.V_ID_NUMBER = A.OBJ_ID
     AND T6.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN T9
      ON T9.INTNAL_TRAN_NUM = F.BUS_ID
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO H
      ON H.SRC_PARTY_ID = G.ISSUE_ORG_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*G.ETL_DT*/
    LEFT JOIN ( SELECT ETL_DT
                       ,BOND_ID
                       ,ASSET_TYPE_ID
                       ,BOND_MARKET_TYPE_CD
                       ,RATING_REST_CD
                       ,RATING_CORP_CN_NAME
                       ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO  --债券评级信息 --MOD BY LTJ 20250704
                 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) R
      ON R.BOND_ID || R.ASSET_TYPE_ID || R.BOND_MARKET_TYPE_CD = A.FIN_INSTM_ID || A.ASSET_TYPE_ID || A.MARKET_TYPE_ID     
     AND R.RN =1
    LEFT JOIN RRP_MDL.CODE_MAP TA --经营类型转码
      ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1479'
     AND TA.TAR_CLASS_CODE = 'D0046'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级分类转码
      ON TB.SRC_VALUE_CODE = F.LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL --技术口径-同业-货币基金、理财产品、信托计划、资产管理计划、债券基金
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                   AS DATA_DT                    --1 数据日期
         ,A.LP_ID                                       AS LGL_REP_ID                 --2 法人编号
         ,A.BELONG_ORG_ID                               AS ORG_ID                     --3 机构编号
         ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(G.ISSUER_CUST_ID),D.CUST_ID
                  ,F.CUST_ID,TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-'))     
                                                        AS CUST_ID                    --4 客户编号
         ,NULL                                          AS INVEST_ORG_TYP             --5 投资机构类型
         ,A.FIN_INSTM_ID                                AS ACC_ID                     --6 账户编号
         ,NULL                                          AS ACC_TYP                    --7 账户类型
         ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID AS ULYG_PROD_ID --8 标的产品编号20221102 XUXIAOBIN MODIFY
         ,'A04'                                         AS INVEST_BIZ_VRTY            --9 投资业务品种 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,TA.TAR_VALUE_CODE                             AS OPR_TYP                    --10 经营类型
         ,'1'                                           AS IN_OUT_FLG                 --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                     AS CUR                        --12 币种
         ,TO_CHAR(NVL(A.VALUE_DT,A.OPEN_DT),'YYYYMMDD') AS BIZ_DT                     --13 业务发生日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                  AS EXP_DT                     --14 到期日期
         ,NVL(A.ACTL_BAL,0) + NVL(A.EVHA_VAL_CHAG,0)    AS BOOK_BAL                   --15 账面余额 --XUXIAOBIN 根据金数修改
         ,A.EVHA_VAL_CHAG                               AS FAIR_VAL                   --16 公允价值
         ,NULL                                          AS HIS_COST                   --17 历史成本
         ,A.CURRT_ACRU_INT                              AS INT                        --18 利息 当期应计利息  20220702 XUCX
         ,NULL                                          AS NEXT_INT_PAY_DT            --19 下一付息日
         ,NULL                                          AS RATE_RE_PRC_DT             --20 利率重新定价日期
         ,NULL                                          AS PRO_IMPT                   --21 减值准备
         ,NVL(TB.TAR_VALUE_CODE,'01')                   AS LVL5_CL                    --22 五级分类
         ,NULL                                          AS LMT_ID                     --23 额度编号
         ,G.MGMT_MODE_CD                                AS MGT_MOD                    --24 管理方式
         ,TC.TAR_VALUE_CODE                             AS FIN_AST_CL                 --25 金融资产分类
         ,NULL                                          AS BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
         ,NULL                                          AS HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
         ,NULL                                          AS PROD_RAISE_MODE            --28 产品募集方式  --MOD BY HULJ 20230116
         ,NULL                                          AS HOLD_FACE_VAL              --29 持有面值
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%' 
               THEN 'G'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%理财%' 
               THEN 'A'||A.FIN_INSTM_ID||A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR G.FIN_INSTM_NAME LIKE '%信托%' OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
               THEN 'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' 
               THEN 'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' OR
                    A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'
               THEN 'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME = '类信贷资产' 
               THEN 'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               ELSE ''
          END                                           AS SPV_ID                     --30 特定目的载体编号
         ,G.MOVE_WAY_CD                                 AS OPR_MODE                   --31 运行方式
         ,NULL                                          AS AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
         ,NULL                                          AS BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率
         ,NULL                                          AS AMT                        --34 发生额
         ,NULL                                          AS SELF_VALET_FLG             --35 自营代客标志
         ,''                                            AS DEPT_LINE                  --36 部门条线
         ,'同业证券持仓'                                AS DATA_SRC                   --37 数据来源
         ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID                --38业务主键
         ,G.ASSET_TYPE_ID                               AS ASSET_TYPE_ID              --39原始资产类型代码
         ,A.ASSET_TYPE_NAME                             AS ASSET_TYPE_NAEM            --40资产名称
         ,A.EVHA_VAL_CHAG                               AS EVHA_VAL_CHAG_PL           --41公允价值变动损益
         ,A.SPD_PL                                      AS SPD_PL                     --42价差损益
         ,A.INT_INCOME                                  AS INT_INCOME                 --43利息收入
         ,A.ASSET_THD_CLS_CD                            AS ASSET_THD_CLS_CD           --44资产三分类代码
         ,A.STD_PROD_ID                                 AS STD_PROD_ID                --45标准产品编号
         ,A.SUBJ_ID                                     AS SUBJ_ID                    --46科目编号
         ,A.OBJ_ID                                      AS OBJ_ID                     --47对象编号
         ,A.CURRT_BAL                                   AS CURRT_BAL                  --48当期余额
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                AS VALUE_DT                   --49起息日
         ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ('29991231','00010101') THEN NULL
               ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD')
           END                                          AS LIST_DT                     --50上市日期
         ,G.SPEC_AIM_VECTOR_TYPE_CD                     AS SPEC_AIM_VECTOR_TYPE_CD     --51特定目的载体类型代码
         ,A.OVDUE_FLG                                   AS OVDUE_FLG                   --52逾期标志
         ,NVL(A1.EVHA_VAL_CHAG_PL,0)                    AS BGN_YEAR_EVHA_VAL_CHAG_PL   --53年初公允价值变动损益
         ,NVL(A1.SPD_PL,0)                              AS BGN_YEAR_SPD_PL             --54年初价差损益
         ,NVL(A1.INT_INCOME,0)                          AS BGN_YEAR_INT_INCOME         --55年初利息收入
         ,NVL(A.NET_PRICE_COST,0)                       AS NV_BAL                      --56净值余额
         ,NVL(A.INT_ADJ_AMT,0)                          AS INT_ADJ_AMT                 --57利息调整金额 20231023
         ,NVL(A.ACRU_INT,0)                             AS ACRU_INT_AMT                --58应计利息金额 20231023
         ,G.FIN_INSTM_NAME                              AS FIN_INSTM_NAME              --59金融工具名称 ADD BY LYH 20231026
         ,A.ASSET_UNIQ_IDF_ID                           AS ASSET_UNIQ_IDF_ID           --60资产唯一标识编号 ADD BY HYF 20231117
         ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)  AS OVD_DAYS                    --61逾期天数 ADD BY HYF 20231219
         ,G.OPEN_TYPE_CD                                AS OPEN_TYPE_CD                --62开放类型代码 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_OPEN_TERMNT_DT,'YYYYMMDD') AS THIS_PED_OPEN_TERMNT_DT     --63本周期开放终止日期 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_HOLD_EXP_DT,'YYYYMMDD')    AS THIS_PED_HOLD_EXP_DT        --64本周期持有到期日期 ADD BY LYH 20240116
         ,CASE WHEN T9.ACCT_B_CATE_CD = 'Trade' THEN 'T'
               ELSE 'B'
           END                                          AS ACCT_B_CATE_CD              --65账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
         ,''                                            AS FINAL_DIR_TYPE_CD           --66最终投向类型代码    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_GEN         --67最终投向行业大类    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_MIDDLE_CLASS--68最终投向行业中类    ADD BY YJY 20241113
         ,''                                            AS FINAL_DIR_INDUS_SUBCLASS    --69最终投向行业细类    ADD BY YJY 20241113
         ,CASE WHEN G.CASH_MANAGE_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                           AS CASH_MANAGE_FLG             --70现金管理类产品标志  ADD BY YJY 20250210
         ,R.RATING_REST_CD                              AS RATING_REST_CD              --71评级结果代码        ADD BY LTJ 20250515
         ,R.RATING_CORP_CN_NAME                         AS RATING_CORP_CN_NAME         --72评级公司中文名称    ADD BY LTJ 20250515
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 --同业证券持仓表
      ON A1.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND A1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND A1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND A1.FIN_INSTM_ID || '_' || A1.ASSET_THD_CLS_CD || '_' || A1.OBJ_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
     AND A1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO B --同业交易对手信息
      ON B.SRC_PARTY_ID = A.ISSUER_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
      ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
      ON D.CUST_ID = NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-'))
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
      ON E.SPV_CUST_ID = NVL(TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-'))
     AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户信息
      ON F.CUST_ID = E.PARTY_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN T9
      ON T9.INTNAL_TRAN_NUM = A.BUS_ID
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ( SELECT ETL_DT
                       ,BOND_ID
                       ,ASSET_TYPE_ID
                       ,BOND_MARKET_TYPE_CD
                       ,RATING_REST_CD
                       ,RATING_CORP_CN_NAME
                       ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) RN
                  FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO  --债券评级信息 --MOD BY LTJ 20250704 
                 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ) R
      ON R.BOND_ID || R.ASSET_TYPE_ID || R.BOND_MARKET_TYPE_CD = A.FIN_INSTM_ID || A.ASSET_TYPE_ID || A.MARKET_TYPE_ID     
     AND R.RN =1
    LEFT JOIN RRP_MDL.CODE_MAP TA --经营类型转码
      ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1479'
     AND TA.TAR_CLASS_CODE = 'D0046'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级分类转码
      ON TB.SRC_VALUE_CODE = A.LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME LIKE '%货币基金%'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*****************同业非标投资*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    ( DATA_DT                    --1 数据日期
     ,LGL_REP_ID                 --2 法人编号
     ,ORG_ID                     --3 机构编号
     ,CUST_ID                    --4 客户编号
     ,INVEST_ORG_TYP             --5 投资机构类型
     ,ACC_ID                     --6 账户编号
     ,ACC_TYP                    --7 账户类型
     ,ULYG_PROD_ID               --8 标的产品编号
     ,INVEST_BIZ_VRTY            --9 投资业务品种
     ,OPR_TYP                    --10 经营类型
     ,IN_OUT_FLG                 --11 表内表外标志
     ,CUR                        --12 币种
     ,BIZ_DT                     --13 业务发生日期
     ,EXP_DT                     --14 到期日期
     ,BOOK_BAL                   --15 账面余额
     ,FAIR_VAL                   --16 公允价值
     ,HIS_COST                   --17 历史成本
     ,INT                        --18 利息
     ,NEXT_INT_PAY_DT            --19 下一付息日
     ,RATE_RE_PRC_DT             --20 利率重新定价日期
     ,PRO_IMPT                   --21 减值准备
     ,LVL5_CL                    --22 五级分类
     ,LMT_ID                     --23 额度编号
     ,MGT_MOD                    --24 管理方式
     ,FIN_AST_CL                 --25 金融资产分类
     ,BIG_AMT_RSK_EXP_EXMPT      --26 大额风险暴露豁免
     ,HOLD_UN_BOT_AST_LBY_BAL    --27 持有非底层资产产生的间接负债余额
     ,PROD_RAISE_MODE            --28 产品募集方式
     ,HOLD_FACE_VAL              --29 持有面值
     ,SPV_ID                     --30 特定目的载体编号
     ,OPR_MODE                   --31 运行方式
     ,AST_MGT_PROD_STATS_ID      --32 资管产品统计编号
     ,BIZ_OCCUR_TMPNT_ACT_RATE   --33 业务发生时点实际利率
     ,AMT                        --34 发生额
     ,SELF_VALET_FLG             --35 自营代客标志
     ,DEPT_LINE                  --36 部门条线
     ,DATA_SRC                   --37 数据来源
     ,ID                         --38 业务主键
     ,ASSET_TYPE_ID              --39 原始资产类别代码
     ,ASSET_NAME                 --40 资产名称
     ,EVHA_VAL_CHAG_PL           --41 公允价值变动损益
     ,SPD_PL                     --42 价差损益
     ,INT_INCOME                 --43 利息收入
     ,ASSET_THD_CLS_CD           --44 资产三分类代码
     ,STD_PROD_ID                --45 标准产品编号
     ,SUBJ_ID                    --46 科目编号
     ,OBJ_ID                     --47 对象编号
     ,CURRT_BAL                  --48 当期余额
     ,VALUE_DT                   --49 起息日
     ,LIST_DT                    --50 上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD    --51 特定目的载体类型代码
     ,OVDUE_FLG                  --52 逾期标志
     ,BGN_YEAR_EVHA_VAL_CHAG_PL  --53 年初公允价值变动损益
     ,BGN_YEAR_SPD_PL            --54 年初价差损益
     ,BGN_YEAR_INT_INCOME        --55 年初利息收入
     ,NV_BAL                     --56 净值余额
     ,CNTPTY_NAME                --57 交易对手名称
     ,TH_MON_INT_INCOME          --58 本月利息收入
     ,FSXZC_FLG                  --59 非生息资产标志
     ,INT_ADJ_AMT                --60 利息调整金额 20231023
     ,ACRU_INT_AMT               --61 应计利息金额 20231023
     ,FIN_INSTM_NAME             --62 金融工具名称 ADD BY LYH 20231026
     ,ASSET_UNIQ_IDF_ID          --63 资产唯一标识编号 ADD BY HYF 20231117
     ,OVD_DAYS                   --64 逾期天数 ADD BY HYF 20231219
     ,OPEN_TYPE_CD               --65 开放类型代码 ADD BY LYH 20240116
     ,THIS_PED_OPEN_TERMNT_DT    --66 本周期开放终止日期 ADD BY LYH 20240116
     ,THIS_PED_HOLD_EXP_DT       --67 本周期持有到期日期 ADD BY LYH 20240116
     ,ACCT_B_CATE_CD             --68 账簿类型 T-交易账簿 B-银行账簿 ADD BY HYF 20240308
     ,FINAL_DIR_TYPE_CD          --69 最终投向类型代码    ADD BY YJY 20241113
     ,FINAL_DIR_INDUS_GEN        --70 最终投向行业大类    ADD BY YJY 20241113
     ,FINAL_DIR_INDUS_MIDDLE_CLASS --71 最终投向行业中类    ADD BY YJY 20241113
     ,FINAL_DIR_INDUS_SUBCLASS   --72 最终投向行业细类    ADD BY YJY 20241113
     ,CASH_MANAGE_FLG            --73 现金管理类产品标志  ADD BY YJY 20250210
     )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                   AS DATA_DT                 --1 数据日期
         ,A.LP_ID                                                       AS LGL_REP_ID              --2 法人编号
         ,A.BELONG_ORG_ID                                               AS ORG_ID                  --3 机构编号
         ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID)
                   ,TRIM(A.CNTPTY_CUST_ID),TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-'))               
                                                                        AS CUST_ID                 --4 客户编号 MD BY 20221107 XUXIAOBIN
         ,NULL                                                          AS INVEST_ORG_TYP          --5 投资机构类型
         ,A.FIN_INSTM_ID                                                AS ACC_ID                  --6 账户编号
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%' OR
                    A.ASSET_TYPE_NAME LIKE '%理财%' OR A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
                    A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' OR A.ASSET_TYPE_NAME LIKE '%资%管%计划%' OR
                    A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%' OR
                    A.ASSET_TYPE_NAME = '类信贷资产'
               THEN '1'
               ELSE '2'
           END                                                           AS ACC_TYP                 --7 账户类型
         ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID    AS ULYG_PROD_ID            --8 标的产品编号 --20221102 XUXIAOBIN MODIFY
         ,'A05'                                                          AS INVEST_BIZ_VRTY         --9 投资业务品种 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,TA.TAR_VALUE_CODE                                              AS OPR_TYP                 --10 经营类型
         ,'1'                                                            AS IN_OUT_FLG              --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                                      AS CUR                     --12 币种
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                 AS BIZ_DT                  --13 业务发生日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                   AS EXP_DT                  --14 到期日期
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN NVL(A.BOOK_BAL,0)
               ELSE NVL(T1.NET_PRICE_COST,0)
           END                                                           AS BOOK_BAL                --15 账面余额 20230830 HYF MODIFY
         ,CASE WHEN NVL(T1.EVHA_VAL_CHAG,0) <> 0 THEN NVL(T1.EVHA_VAL_CHAG,0)
               ELSE (CASE WHEN T5.V_THREE_STAGE_CD = 'AC' THEN 0 ELSE NVL(T5.N_PV_VARIATION,0) END)
           END                                                           AS FAIR_VAL                --16 公允价值 20231023
         ,NULL                                                           AS HIS_COST                --17 历史成本
         ,A.ACRU_INT + A.RECVBL_UNCOL_INT                                AS INT                     --18 利息 因新一代中同业系统将原应收利息和应计利息的部分逾期利息拆分到应收未收利息 陈晓桂老师确认利息应取应计+应收未收
         ,NULL                                                           AS NEXT_INT_PAY_DT         --19 下一付息日
         ,NULL                                                           AS RATE_RE_PRC_DT          --20 利率重新定价日期
         ,NULL                                                           AS PRO_IMPT                --21 减值准备
         ,NVL(TB.TAR_VALUE_CODE,'01')                                    AS LVL5_CL                 --22 五级分类
         ,NULL                                                           AS LMT_ID                  --23 额度编号
         ,G.MGMT_MODE_CD                                                 AS MGT_MOD                 --24 管理方式
         ,TC.TAR_VALUE_CODE                                              AS FIN_AST_CL              --25 金融资产分类
         ,NULL                                                           AS BIG_AMT_RSK_EXP_EXMPT   --26 大额风险暴露豁免
         ,NULL                                                           AS HOLD_UN_BOT_AST_LBY_BAL --27 持有非底层资产产生的间接负债余额
         ,CASE WHEN A.UDER_COLL_WAY_CD = '0' THEN 'A'
               WHEN A.UDER_COLL_WAY_CD = '1' THEN 'B'
           END                                                           AS PROD_RAISE_MODE         --28 产品募集方式 --mod by hulj20230116
         ,NULL                                                           AS HOLD_FACE_VAL           --29 持有面值
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%'
               THEN 'G' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%理财%' 
               THEN 'A' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR G.FIN_INSTM_NAME LIKE '%信托%' OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
               THEN 'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' 
               THEN 'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' OR
                    A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'
               THEN 'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME = '类信贷资产' 
               THEN 'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               ELSE ''
           END                                                           AS SPV_ID                  --30 特定目的载体编号
         ,G.MOVE_WAY_CD                                                  AS OPR_MODE                --31 运行方式
         ,NULL                                                           AS AST_MGT_PROD_STATS_ID   --32 资管产品统计编号
         ,A.FAC_VAL_INT_RAT                                              AS BIZ_OCCUR_TMPNT_ACT_RATE--33 业务发生时点实际利率
         ,NULL                                                           AS AMT                     --34 发生额
         ,NULL                                                           AS SELF_VALET_FLG          --35 自营代客标志
         ,''                                                             AS DEPT_LINE               --36 部门条线
         ,'同业非标'                                                     AS DATA_SRC                --37 数据来源
         ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID                      --38业务主键
         ,G.ASSET_TYPE_ID                                                AS ASSET_TYPE_ID           --39原始资产类型代码
         ,A.ASSET_TYPE_NAME                                              AS ASSET_NAME              --40资产名称
         ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC') OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002',
                    '304020100003','304020100004','304030100001','304030100002','304030100003','304030100004','304040100001',
                    '304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
               --业务要求这些产品的公允价值变动从减估值系统取
               THEN NVL(T5.N_PV_VARIATION,0)
               ELSE NVL(T1.EVHA_VAL_CHAG_PL,0)
          END                                                           AS EVHA_VAL_CHAG_PL         --41公允价值变动损益
        ,T1.SPD_PL                                                      AS SPD_PL                   --42价差损益
        ,T1.INT_INCOME                                                  AS INT_INCOME               --43利息收入
        ,A.ASSET_THD_CLS_CD                                             AS ASSET_THD_CLS_CD         --44资产三分类代码
        ,A.STD_PROD_ID                                                  AS STD_PROD_ID              --45标准产品编号
        ,A.SUBJ_ID                                                      AS SUBJ_ID                  --46科目编号
        ,A.OBJ_ID                                                       AS OBJ_ID                   --47对象编号
        ,A.CURRT_BAL                                                    AS CURRT_BAL                --48当期余额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                 AS VALUE_DT                 --49起息日
        ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ('29991231','00010101') THEN NULL
              ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD')
          END                                                           AS LIST_DT                  --50上市日期
        ,G.SPEC_AIM_VECTOR_TYPE_CD                                      AS SPEC_AIM_VECTOR_TYPE_CD  --51特定目的载体类型代码
        ,A.OVDUE_FLG                                                    AS OVDUE_FLG                --52逾期标志
        ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC') OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002',
                   '304020100003','304020100004','304030100001','304030100002','304030100003','304030100004','304040100001',
                   '304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
              --业务要求这些产品的公允价值变动从减估值系统取
              THEN NVL(T6.N_PV_VARIATION,0)
              ELSE NVL(T0.EVHA_VAL_CHAG_PL,0)
          END                                                           AS BGN_YEAR_EVHA_VAL_CHAG_PL--53年初公允价值变动损益
        ,T0.SPD_PL                                                      AS BGN_YEAR_SPD_PL          --54年初价差损益
        ,T0.INT_INCOME                                                  AS BGN_YEAR_INT_INCOME      --55年初利息收入
        ,NVL(T1.NET_PRICE_COST,0)                                       AS NV_BAL                   --56净值余额
        ,CASE WHEN D.RWA_CUST_CLS_NAME LIKE '境内.资产管理产品%' OR D.RWA_CUST_CLS_NAME LIKE '境内.私募基金%'
              THEN SUBSTR(D.RWA_CUST_CLS_NAME,INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 3) + 2,
                   LENGTH(D.RWA_CUST_CLS_NAME) - INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 3))
              WHEN INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 2) = 0
              THEN SUBSTR(D.RWA_CUST_CLS_NAME,LENGTH(D.RWA_CUST_CLS_NAME) - INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 1))
              WHEN INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 3) = 0
              THEN SUBSTR(D.RWA_CUST_CLS_NAME,INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 2) + 1,
                   LENGTH(D.RWA_CUST_CLS_NAME) - INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 2))
              ELSE SUBSTR(D.RWA_CUST_CLS_NAME,INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 2) + 1,
                   INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 3) - INSTR(D.RWA_CUST_CLS_NAME, '.', 1, 2)-1)
          END                                                           AS CNTPTY_NAME              --57交易对手名称
         ,NVL(T1.INT_INCOME,0)-NVL(T3.INT_INCOME,0)                     AS TH_MON_INT_INCOME        --58本月利息收入
         ,CASE WHEN NVL(T1.INT_INCOME,0)-NVL(T3.INT_INCOME,0) = 0 
               THEN 'Y'
               WHEN A.OBJ_ID <> NVL(T3.OBJ_ID,'-') AND A.OVDUE_FLG = '1' AND T1.INT_INCOME <= 0 
               THEN 'Y'
               ELSE 'N'
          END                                                           AS FSXZC_FLG                --59非生息资产标志
         ,NVL(T1.INT_ADJ_AMT,0)                                         AS INT_ADJ_AMT              --60利息调整金额 20231023
         ,NVL(T1.ACRU_INT,0)                                            AS ACRU_INT_AMT             --61应计利息金额 20231023
         ,G.FIN_INSTM_NAME                                              AS FIN_INSTM_NAME           --62金融工具名称 ADD BY LYH 20231026
         ,T1.ASSET_UNIQ_IDF_ID                                          AS ASSET_UNIQ_IDF_ID        --63资产唯一标识编号 ADD BY HYF 20231117
         ,GREATEST(T1.PRIC_OVDUE_DAYS,T1.INT_OVDUE_DAYS)                AS OVD_DAYS                 --64逾期天数 ADD BY HYF 20231219
         ,G.OPEN_TYPE_CD                                                AS OPEN_TYPE_CD             --65开放类型代码 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_OPEN_TERMNT_DT,'YYYYMMDD')                 AS THIS_PED_OPEN_TERMNT_DT  --66本周期开放终止日期 ADD BY LYH 20240116
         ,TO_CHAR(G.THIS_PED_HOLD_EXP_DT,'YYYYMMDD')                    AS THIS_PED_HOLD_EXP_DT     --67本周期持有到期日期 ADD BY LYH 20240116
         ,CASE WHEN T9.ACCT_B_CATE_CD = 'Trade' THEN 'T'
               ELSE 'B'
          END                                                           AS ACCT_B_CATE_CD           --68账簿类型 T-交易账簿 B-银行账簿
         ,A.FINAL_DIR_TYPE_CD                                           AS FINAL_DIR_TYPE_CD        --69最终投向类型代码     ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_GEN                                         AS FINAL_DIR_INDUS_GEN      --70最终投向行业大类     ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_MIDDLE_CLASS                                AS FINAL_DIR_INDUS_MIDDLE_CLASS --71最终投向行业中类   ADD BY YJY 20241113
         ,A.FINAL_DIR_INDUS_SUBCLASS                                    AS FINAL_DIR_INDUS_SUBCLASS --72最终投向行业细类    ADD BY YJY 20241113
         ,CASE WHEN G.CASH_MANAGE_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                                           AS CASH_MANAGE_FLG          --73现金管理类产品标志  ADD BY YJY 20250210
    FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A --同业非标投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST T1 --同业证券持仓表
      ON T1.FIN_INSTM_ID || '_' || T1.ASSET_THD_CLS_CD || '_' || T1.OBJ_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
     AND T1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND T1.BUS_ID = A.BUS_ID
     AND T1.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST T0 --同业证券持仓 取年初数据
      ON T0.FIN_INSTM_ID || '_' || T0.ASSET_THD_CLS_CD || '_' || T0.OBJ_ID=A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
     AND T0.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND T0.BUS_ID = A.BUS_ID
     AND T0.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
     AND T0.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
      ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT A.OBJ_ID,T1.INT_INCOME,A.OVDUE_FLG
                 FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A --同业非标投资表
                 LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST T1 --同业证券持仓表
                   ON T1.FIN_INSTM_ID || '_' || T1.ASSET_THD_CLS_CD || '_' || T1.OBJ_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
                  AND T1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
                  AND T1.BUS_ID = A.BUS_ID
                  AND T1.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
                  AND T1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1
                WHERE A.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1) T3 --取上月利息收入
      ON T3.OBJ_ID = A.OBJ_ID
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息
      ON D.SRC_PARTY_ID = G.MGER_ID
     AND D.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动 XUXIAOBIN 20220806 ADD
      ON O.V_ASSET_CODE = A.FIN_INSTM_ID
     AND O.V_THREE_CLASS = A.ASSET_THD_CLS_CD
     AND O.V_TRADE_NO = A.OBJ_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T2
      ON T2.CONT_ID = A.APV_ODD_NO
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL T5   --减值结果表
      ON T5.V_FINANCIAL_ID = A.FIN_INSTM_ID
     AND T5.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
     AND T5.V_ID_NUMBER = A.OBJ_ID
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL T6   --减值结果表 取年初公允价值变动
      ON T6.V_FINANCIAL_ID = A.FIN_INSTM_ID
     AND T6.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
     AND T6.V_ID_NUMBER = A.OBJ_ID
     AND T6.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN T9
      ON T9.INTNAL_TRAN_NUM = T1.BUS_ID
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TC --金融资产类型转码
      ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
     AND TC.SRC_CLASS_CODE = 'CD2060'
     AND TC.TAR_CLASS_CODE = 'D0048'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TA
      ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1479'
     AND TA.TAR_CLASS_CODE = 'D0046'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级分类转码
      ON TB.SRC_VALUE_CODE = T2.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,ACC_ID,ID,COUNT(1)
    FROM RRP_MDL.M_CPTL_INVEST_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ACC_ID,ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_INVEST_INFO;
/

