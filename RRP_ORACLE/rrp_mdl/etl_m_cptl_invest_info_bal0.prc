CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_INVEST_INFO_BAL0(I_P_DATE IN INTEGER,
                                                   O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_CPTL_INVEST_INFO_BAL0
  *  功能描述：投资业务信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_INVEST_INFO_BAL0
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  程序员    首次创建
  *             2    20220831  hulj      调整资金系统、同业系统取值，增加同业净值型产品投资,同业非标投资,同业证券持仓取数口径。
  *             3    20221101  hulj      投资业务信息-资金系统 修改业务主键
  *             4    20221114  hulj      增加数据重复校验
  *             5    20220116  hulj      增加产品募集方式
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_INVEST_INFO_BAL0'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_INVEST_INFO_BAL0'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_INVEST_INFO_BAL0 T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_INVEST_INFO_BAL0'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

  /*****************特定载体*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-特定载体';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO_BAL0
    (DATA_DT                         --1 数据日期
     ,LGL_REP_ID                     --2 法人编号
     ,ORG_ID                         --3 机构编号
     ,CUST_ID                        --4 客户编号
     ,INVEST_ORG_TYP                 --5 投资机构类型
     ,ACC_ID                         --6 账户编号
     ,ACC_TYP                        --7 账户类型
     ,ULYG_PROD_ID                   --8 标的产品编号
     ,INVEST_BIZ_VRTY                --9 投资业务品种
     ,OPR_TYP                        --10 经营类型
     ,IN_OUT_FLG                     --11 表内表外标志
     ,CUR                            --12 币种
     ,BIZ_DT                         --13 业务发生日期
     ,EXP_DT                         --14 到期日期
     ,BOOK_BAL                       --15 账面余额
     ,FAIR_VAL                       --16 公允价值
     ,HIS_COST                       --17 历史成本
     ,INT                            --18 利息
     ,NEXT_INT_PAY_DT                --19 下一付息日
     ,RATE_RE_PRC_DT                 --20 利率重新定价日期
     ,PRO_IMPT                       --21 减值准备
     ,LVL5_CL                        --22 五级分类
     ,LMT_ID                         --23 额度编号
     ,MGT_MOD                        --24 管理方式
     ,FIN_AST_CL                     --25 金融资产分类
     ,BIG_AMT_RSK_EXP_EXMPT          --26 大额风险暴露豁免
     ,HOLD_UN_BOT_AST_LBY_BAL        --27 持有非底层资产产生的间接负债余额
     ,PROD_RAISE_MODE                --28 产品募集方式
     ,HOLD_FACE_VAL                  --29 持有面值
     ,SPV_ID                         --30 特定目的载体编号
     ,OPR_MODE                       --31 运行方式
     ,AST_MGT_PROD_STATS_ID          --32 资管产品统计编号
     ,BIZ_OCCUR_TMPNT_ACT_RATE       --33 业务发生时点实际利率
     ,AMT                            --34 发生额
     ,SELF_VALET_FLG                 --35 自营代客标志
     ,DEPT_LINE                      --36 部门条线
     ,DATA_SRC                       --37 数据来源
     ,ID                             --38 业务主键
     ,ASSET_TYPE_ID                  --39 原始资产类型代码
     ,ASSET_NAME                     --40 资产名称
     ,EVHA_VAL_CHAG_PL               --39 公允价值变动损益
     ,SPD_PL                         --40 价差损益
     ,INT_INCOME                     --41 利息收入
     ,ASSET_THD_CLS_CD               --42 资产三分类代码
     ,STD_PROD_ID                    --43 标准产品编号
     ,SUBJ_ID                        --44 科目编号
     ,OBJ_ID                         --45 对象编号
     ,CURRT_BAL                      --46 当期余额
     ,VALUE_DT                       --47 起息日
     ,LIST_DT                        --48 上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD        --49 特定目的载体类型代码
     ,OVDUE_FLG                      --50 逾期标志
     ,BGN_YEAR_EVHA_VAL_CHAG_PL      --51 年初公允价值变动损益
     ,BGN_YEAR_SPD_PL                --52 年初价差损益
     ,BGN_YEAR_INT_INCOME            --53 年初利息收入
     )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                         AS DATA_DT                        --1 数据日期
         ,A.LP_ID                                             AS LGL_REP_ID                     --2 法人编号
         ,A.BELONG_ORG_ID                                     AS ORG_ID                         --3 机构编号
         ,COALESCE(TRIM(G.ISSUER_CUST_ID),D.CUST_ID,F.CUST_ID,TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID),'-'))  
                                                              AS CUST_ID                        --4 客户编号
         ,NULL                                                AS INVEST_ORG_TYP                 --5 投资机构类型
         ,A.FIN_INSTM_ID                                      AS ACC_ID                         --6 账户编号
         ,NULL                                                AS ACC_TYP                        --7 账户类型
         ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID AS ULYG_PROD_ID           --8 标的产品编号20221102 XUXIAOBIN MODIFY
         ,'A04'                                               AS INVEST_BIZ_VRTY                --9 投资业务品种 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
         ,TA.TAR_VALUE_CODE                                   AS OPR_TYP                        --10 经营类型
         ,'1'                                                 AS IN_OUT_FLG                     --11 表内表外标志 --XUXIAOBIN 20220905 ADD
         ,A.CURR_CD                                           AS CUR                            --12 币种
         ,TO_CHAR(NVL(A.VALUE_DT,A.OPEN_DT),'YYYYMMDD')       AS BIZ_DT                         --13 业务发生日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                        AS EXP_DT                         --14 到期日期
         ,NVL(A.ACTL_BAL,0) + NVL(A.EVHA_VAL_CHAG,0)          AS BOOK_BAL                       --15 账面余额 --XUXIAOBIN 根据金数修改
         ,A.EVHA_VAL_CHAG                                     AS FAIR_VAL                       --16 公允价值
         ,NULL                                                AS HIS_COST                       --17 历史成本
         ,A.CURRT_ACRU_INT                                    AS INT                            --18 利息 当期应计利息  20220702 XUCX
         ,NULL                                                AS NEXT_INT_PAY_DT                --19 下一付息日
         ,NULL                                                AS RATE_RE_PRC_DT                 --20 利率重新定价日期
         ,NULL                                                AS PRO_IMPT                       --21 减值准备
         ,NVL(TB.TAR_VALUE_CODE, '01')                        AS LVL5_CL                        --22 五级分类
         ,NULL                                                AS LMT_ID                         --23 额度编号
         ,G.MGMT_MODE_CD                                      AS MGT_MOD                        --24 管理方式
         ,TC.TAR_VALUE_CODE                                   AS FIN_AST_CL                     --25 金融资产分类
         ,NULL                                                AS BIG_AMT_RSK_EXP_EXMPT          --26 大额风险暴露豁免
         ,NULL                                                AS HOLD_UN_BOT_AST_LBY_BAL        --27 持有非底层资产产生的间接负债余额
         ,NULL                                                AS PROD_RAISE_MODE                --28 产品募集方式  --mod by hulj 20230116
         ,NULL                                                AS HOLD_FACE_VAL                  --29 持有面值
         ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%'
               THEN 'G' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%理财%'
               THEN 'A' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR G.FIN_INSTM_NAME LIKE '%信托%'
                 OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%'
               THEN 'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN 'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' 
                 OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'
               THEN 'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               WHEN A.ASSET_TYPE_NAME = '类信贷资产'
               THEN 'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
               ELSE ''
          END                                                 AS SPV_ID                         --30 特定目的载体编号
         ,G.MOVE_WAY_CD                                       AS OPR_MODE                       --31 运行方式
         ,NULL                                                AS AST_MGT_PROD_STATS_ID          --32 资管产品统计编号
         ,NULL                                                AS BIZ_OCCUR_TMPNT_ACT_RATE       --33 业务发生时点实际利率
         ,NULL                                                AS AMT                            --34 发生额
         ,NULL                                                AS SELF_VALET_FLG                 --35 自营代客标志
         ,''                                                  AS DEPT_LINE                      --36 部门条线
         ,'同业证券持仓'                                      AS DATA_SRC                       --37 数据来源
         ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID                  --38 业务主键
         ,G.ASSET_TYPE_ID                                     AS ASSET_TYPE_ID                  --39 原始资产类型代码
         ,A.ASSET_TYPE_NAME                                   AS ASSET_TYPE_NAEM                --40 资产名称
         ,CASE WHEN A.ASSET_THD_CLS_CD IN ('FVOCI','AC') 
                 OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001'
                                      ,'304030100002','304030100003','304030100004','304040100001','304050100001','307010100001'
                                      ,'307020100001','307020100002','307030100001','307030200001','307030200002')
                                     --业务要求这些产品的公允价值变动从减估值系统取
               THEN NVL(T5.N_PV_VARIATION,0)
               ELSE NVL(A.EVHA_VAL_CHAG_PL,0)
          END                                                AS EVHA_VAL_CHAG_PL                --41 公允价值变动损益
         ,A.SPD_PL                                           AS SPD_PL                          --42 价差损益
         ,A.INT_INCOME                                       AS INT_INCOME                      --43 利息收入
         ,A.ASSET_THD_CLS_CD                                 AS ASSET_THD_CLS_CD                --44 资产三分类代码
         ,A.STD_PROD_ID                                      AS STD_PROD_ID                     --45 标准产品编号
         ,A.SUBJ_ID                                          AS SUBJ_ID                         --46 科目编号
         ,A.OBJ_ID                                           AS OBJ_ID                          --47 对象编号
         ,A.CURRT_BAL                                        AS CURRT_BAL                       --48 当期余额
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                     AS VALUE_DT                        --49 起息日
         ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ('29991231','00010101') 
               THEN NULL
               ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD')
           END                                               AS LIST_DT                         --50 上市日期
         ,G.SPEC_AIM_VECTOR_TYPE_CD                          AS SPEC_AIM_VECTOR_TYPE_CD         --51 特定目的载体类型代码
         ,A.OVDUE_FLG                                        AS OVDUE_FLG                       --52 逾期标志
         ,CASE WHEN A.ASSET_THD_CLS_CD IN ('FVOCI','AC') 
                 OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001'
                                     ,'304030100002','304030100003','304030100004','304040100001','304050100001','307010100001'
                                     ,'307020100001','307020100002','307030100001','307030200001','307030200002')
                                     --业务要求这些产品的公允价值变动从减估值系统取
               THEN NVL(T6.N_PV_VARIATION,0)
               ELSE NVL(A1.EVHA_VAL_CHAG_PL,0)
           END                                               AS BGN_YEAR_EVHA_VAL_CHAG_PL       --53 年初公允价值变动损益
         ,NVL(A1.SPD_PL,0)                                   AS BGN_YEAR_SPD_PL                 --54 年初价差损益
         ,NVL(A1.INT_INCOME,0)                               AS BGN_YEAR_INT_INCOME             --55 年初利息收入
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 --同业证券持仓表
      ON A1.FIN_INSTM_ID||'_'||A1.ASSET_THD_CLS_CD||'_'||A1.OBJ_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID
     AND A1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO B --同业交易对手信息
      ON B.SRC_PARTY_ID = A.ISSUER_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
      ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
      ON D.CUST_ID = NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-'))
     AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
      ON E.SPV_CUST_ID = NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-'))
     AND E.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND E.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户信息
      ON F.CUST_ID = E.PARTY_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
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
   WHERE NVL(A.ACTL_BAL, 0) + NVL(A.EVHA_VAL_CHAG, 0) = 0
     AND (A.EXP_DT >= TRUNC(A.ETL_DT,'YYYY') OR A.LAST_UPDATE_DT >= TRUNC(A.ETL_DT,'YYYY'))
     AND A.ASSET_TYPE_NAME NOT LIKE '%保险资管计划%'
     AND A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%'
     AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID,ID,COUNT(1)
      FROM RRP_MDL.M_CPTL_INVEST_INFO_BAL0 T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, ACC_ID,ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

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
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    --V_STEP      := V_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_INVEST_INFO_BAL0;
/

