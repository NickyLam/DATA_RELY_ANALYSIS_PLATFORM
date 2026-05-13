CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_INVEST_INFO(I_P_DATE IN INTEGER,
                                                   O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_INVEST_INFO
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
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CPTL_INVEST_INFO'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
BEGIN

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
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入投资业务信息-同业系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT, --1 数据日期
     LGL_REP_ID, --2 法人编号
     ORG_ID, --3 机构编号
     CUST_ID, --4  客户编号
     INVEST_ORG_TYP, --5 投资机构类型
     ACC_ID, --6 账户编号
     ACC_TYP, --7  账户类型
     ULYG_PROD_ID, --8 标的产品编号
     INVEST_BIZ_VRTY, --9  投资业务品种
     OPR_TYP, --10 经营类型
     IN_OUT_FLG, --11  表内表外标志
     CUR, --12 币种
     BIZ_DT, --13  业务发生日期
     EXP_DT, --14  到期日期
     BOOK_BAL, --15  账面余额
     FAIR_VAL, --16  公允价值
     HIS_COST, --17  历史成本
     INT, --18 利息
     NEXT_INT_PAY_DT, --19 下一付息日
     RATE_RE_PRC_DT, --20  利率重新定价日期
     PRO_IMPT, --21  减值准备
     LVL5_CL, --22 五级分类
     LMT_ID, --23  额度编号
     MGT_MOD, --24 管理方式
     FIN_AST_CL, --25  金融资产分类
     BIG_AMT_RSK_EXP_EXMPT, --26 大额风险暴露豁免
     HOLD_UN_BOT_AST_LBY_BAL, --27 持有非底层资产产生的间接负债余额
     PROD_RAISE_MODE, --28 产品募集方式
     HOLD_FACE_VAL, --29 持有面值
     SPV_ID, --30  特定目的载体编号
     OPR_MODE, --31  运行方式
     AST_MGT_PROD_STATS_ID, --32 资管产品统计编号
     BIZ_OCCUR_TMPNT_ACT_RATE, --33  业务发生时点实际利率
     AMT, --34 发生额
     SELF_VALET_FLG, --35  自营代客标志
     DEPT_LINE, --36 部门条线
     DATA_SRC, --37 数据来源
     ID --38 业务主键
     ,EVHA_VAL_CHAG_PL     --39公允价值变动损益
     ,SPD_PL               --40价差损益
     ,INT_INCOME           --41利息收入
     ,ASSET_THD_CLS_CD     --42资产三分类代码
     ,STD_PROD_ID          --43标准产品编号
     ,SUBJ_ID              --44科目编号
     ,OBJ_ID --对象编号
     ,CURRT_BAL  --当期余额
     ,ASSET_TYPE_ID --39原始资产类型代码
     ,ASSET_NAME     --40资产名称
     ,VALUE_DT   --起息日
     ,LIST_DT    --上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
     ,OVDUE_FLG --逾期标志
     ,BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
     ,BGN_YEAR_SPD_PL                --年初价差损益
     ,BGN_YEAR_INT_INCOME            --年初利息收入
     )
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                 AS DATA_DT, --1 数据日期
           A.LP_ID                                       AS LGL_REP_ID, --2 法人编号
           A.BELONG_ORG_ID                               AS ORG_ID, --3  机构编号
           NVL(A.ISSUER_CUST_ID, A.ISSUER_ID)            AS CUST_ID, --4 客户编号  取不到发行人客户编号取发行人编号
           NULL                                          AS INVEST_ORG_TYP, --5  投资机构类型
           A.INTNAL_SECU_ACCT_ID || A.FIN_INSTM_ID       AS ACC_ID, --6  账户编号
           NULL                                          AS ACC_TYP, --7 账户类型
           A.FIN_INSTM_ID                                AS ULYG_PROD_ID, --8  标的产品编号
           'A01'                                         AS INVEST_BIZ_VRTY, --9 投资业务品种--01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
           TA.TAR_VALUE_CODE                             AS OPR_TYP, --10  经营类型
           '1'                                           AS IN_OUT_FLG, --11 表内表外标志 --XUXIAOBIN 20220905 ADD
           A.CURR_CD                                     AS CUR, --12 币种
           TO_CHAR(A.ISSUE_DT, 'YYYYMMDD')               AS BIZ_DT, --13 业务发生日期
           TO_CHAR(A.EXP_DT, 'YYYYMMDD')                 AS EXP_DT, --14 到期日期
           A.BOOK_BAL                                    AS BOOK_BAL, --15 账面余额
           --A.CURRT_BAL AS BOOK_BAL, --15 账面余额  当期余额
           A.EVHA_VAL_CHAG                               AS FAIR_VAL, --16 公允价值
           NULL                                          AS HIS_COST, --17 历史成本
           --A.INT_RECVBL AS INT, --18  利息
           A.ACRU_INT                                    AS INT, --18  利息   --20220702 XUCX
           NULL                                          AS NEXT_INT_PAY_DT, --19  下一付息日
           NULL                                          AS RATE_RE_PRC_DT, --20 利率重新定价日期
           NULL                                          AS PRO_IMPT, --21 减值准备
           NVL(TB.TAR_VALUE_CODE, '01')                  AS LVL5_CL, --22  五级分类
           NULL                                          AS LMT_ID, --23 额度编号
           E.MGMT_MODE_CD                                AS MGT_MOD, --24  管理方式
           TC.TAR_VALUE_CODE                             AS FIN_AST_CL, --25 金融资产分类
           NULL                                          AS BIG_AMT_RSK_EXP_EXMPT, --26  大额风险暴露豁免
           NULL                                          AS HOLD_UN_BOT_AST_LBY_BAL, --27  持有非底层资产产生的间接负债余额
           NULL                                          AS PROD_RAISE_MODE, --28  产品募集方式    --mod by hulj20230116
           A.HOLD_FAC_VAL                                AS HOLD_FACE_VAL, --29  持有面值
           NULL                                          AS SPV_ID, --30 特定目的载体编号
           E.MOVE_WAY_CD                                 AS OPR_MODE, --31 运行方式
           NULL                                          AS AST_MGT_PROD_STATS_ID, --32  资管产品统计编号
           /*A.ACTL_INT_RAT*/
           E.FAC_VAL_INT_RAT                             AS BIZ_OCCUR_TMPNT_ACT_RATE, --33 业务发生时点实际利率
           NULL                                          AS AMT, --34  发生额
           NULL                                          AS SELF_VALET_FLG, --35 自营代客标志
           ''                                            AS DEPT_LINE, --36  部门条线
           '同业债券'                                     AS DATA_SRC, --37  数据来源
           A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.INTNAL_SECU_ACCT_ID
                                                         AS ID --业务主键
           ,F.EVHA_VAL_CHAG_PL                           AS EVHA_VAL_CHAG_PL     --39公允价值变动损益
           ,F.SPD_PL                                     AS SPD_PL               --40价差损益
           ,F.INT_INCOME                                 AS INT_INCOME           --41利息收入
           ,F.ASSET_THD_CLS_CD                           AS ASSET_THD_CLS_CD     --42资产三分类代码
           ,A.STD_PROD_ID                                AS STD_PROD_ID          --43标准产品编号
           ,A.SUBJ_ID                                    AS SUBJ_ID              --44科目编号
           ,A.OBJ_ID                                     AS OBJ_ID --对象编号
           ,A.CURRT_BAL                                  AS CURRT_BAL  --当期余额
           ,A.ASSET_TYPE_ID                              AS ASSET_TYPE_ID --39原始资产类型代码
           ,A.ASSET_TYPE_NAME                            AS ASSET_NAME     --40资产名称
           ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS VALUE_DT   --起息日
           ,TO_CHAR(E.LIST_DT,'YYYYMMDD')                AS LIST_DT    --上市日期
           ,E.SPEC_AIM_VECTOR_TYPE_CD                    AS SPEC_AIM_VECTOR_TYPE_CD --特定目的载体类型代码
           ,A.OVDUE_FLG                                  AS OVDUE_FLG --逾期标志
           ,F1.EVHA_VAL_CHAG_PL                          AS BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
           ,F1.SPD_PL                                    AS BGN_YEAR_SPD_PL                --年初价差损益
           ,F1.INT_INCOME                                AS BGN_YEAR_INT_INCOME            --年初利息收入
      FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A --同业债券投资
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM E --同业金融工具
        ON A.FIN_INSTM_ID || A.MARKET_TYPE_ID =
           E.FIN_INSTM_ID || E.MARKET_TYPE_ID
       AND A.ASSET_TYPE_ID = E.ASSET_TYPE_ID --20221013 XUXIAOBIN MODIFY
       AND E.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
/*      LEFT JOIN (SELECT F.*,
                   ROW_NUMBER() OVER(PARTITION BY F.FIN_INSTM_ID ORDER BY LEVEL5_CLS_CD DESC) RN
                   FROM O_ICL_CMM_IBANK_SECU_POST F) F --同业证券持仓
        ON A.FIN_INSTM_ID = F.FIN_INSTM_ID
       AND F.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND F.RN = 1 */
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST  F  --同业证券持仓
        ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
       AND F.MARKET_TYPE_ID = A.MARKET_TYPE_ID
       AND F.ASSET_TYPE_ID = A.ASSET_TYPE_ID
       AND F.FIN_INSTM_ID || '_' || F.ASSET_THD_CLS_CD || '_' || F.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.INTNAL_SECU_ACCT_ID
       AND F.OBJ_ID = A.OBJ_ID
       AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN  O_ICL_CMM_IBANK_SECU_POST  F1  --同业证券持仓 取年末公允价值变动损益、价差损益、利息收入
        ON F1.FIN_INSTM_ID = A.FIN_INSTM_ID
       AND F1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
       AND F1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
       AND F1.OBJ_ID = A.OBJ_ID
       AND F1.FIN_INSTM_ID || '_' || F1.ASSET_THD_CLS_CD || '_' || F1.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.INTNAL_SECU_ACCT_ID
       AND F1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') -1
      LEFT JOIN CODE_MAP TB --五级分类转码
        ON TB.SRC_VALUE_CODE = F.LEVEL5_CLS_CD
       AND TB.SRC_CLASS_CODE = 'CD1032'
       AND TB.TAR_CLASS_CODE = 'D0005'
       AND TB.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TA
        ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
       AND TA.SRC_CLASS_CODE = 'CD1479'
       AND TA.TAR_CLASS_CODE = 'D0046'
       AND TA.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
     WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND A.BOOK_BAL > 0
    /*AND (A.ASSET_TYPE_NAME LIKE '%公司债%' OR A.ASSET_TYPE_NAME LIKE '%企业债%' OR A.ASSET_TYPE_NAME LIKE '%资产支持%'
    OR A.ASSET_TYPE_NAME LIKE '%其他债券%' OR A.ASSET_TYPE_NAME LIKE '%私募债%' )*/
    --AND A.SUBJ_ID IS NOT NULL --需拿6月底前余额为0的债券
    /*AND A.BOOK_BAL>0*/
    ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  /*****************资金系统*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-资金系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT, --1 数据日期
     LGL_REP_ID, --2 法人编号
     ORG_ID, --3 机构编号
     CUST_ID, --4  客户编号
     INVEST_ORG_TYP, --5 投资机构类型
     ACC_ID, --6 账户编号
     ACC_TYP, --7  账户类型
     ULYG_PROD_ID, --8 标的产品编号
     INVEST_BIZ_VRTY, --9  投资业务品种
     OPR_TYP, --10 经营类型
     IN_OUT_FLG, --11  表内表外标志
     CUR, --12 币种
     BIZ_DT, --13  业务发生日期
     EXP_DT, --14  到期日期
     BOOK_BAL, --15  账面余额
     FAIR_VAL, --16  公允价值
     HIS_COST, --17  历史成本
     INT, --18 利息
     NEXT_INT_PAY_DT, --19 下一付息日
     RATE_RE_PRC_DT, --20  利率重新定价日期
     PRO_IMPT, --21  减值准备
     LVL5_CL, --22 五级分类
     LMT_ID, --23  额度编号
     MGT_MOD, --24 管理方式
     FIN_AST_CL, --25  金融资产分类
     BIG_AMT_RSK_EXP_EXMPT, --26 大额风险暴露豁免
     HOLD_UN_BOT_AST_LBY_BAL, --27 持有非底层资产产生的间接负债余额
     PROD_RAISE_MODE, --28 产品募集方式
     HOLD_FACE_VAL, --29 持有面值
     SPV_ID, --30  特定目的载体编号
     OPR_MODE, --31  运行方式
     AST_MGT_PROD_STATS_ID, --32 资管产品统计编号
     BIZ_OCCUR_TMPNT_ACT_RATE, --33  业务发生时点实际利率
     AMT, --34 发生额
     SELF_VALET_FLG, --35  自营代客标志
     DEPT_LINE, --36 部门条线
     DATA_SRC, --37 数据来源
     ID --38 业务主键
     ,EVHA_VAL_CHAG_PL     --39公允价值变动损益
     ,SPD_PL               --40价差损益
     ,INT_INCOME           --41利息收入
     ,ASSET_THD_CLS_CD     --42资产三分类代码
     ,STD_PROD_ID          --43标准产品编号
     ,SUBJ_ID              --44科目编号
     ,OBJ_ID --对象编号
     ,CURRT_BAL  --当期余额
     ,ASSET_TYPE_ID --原始资产类型代码
     ,ASSET_NAME    --资产名称
     ,VALUE_DT   --起息日
     ,LIST_DT    --上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD        --特定目的载体类型代码
     ,BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
     ,BGN_YEAR_SPD_PL                --年初价差损益
     ,BGN_YEAR_INT_INCOME            --年初利息收入
     )
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD') AS DATA_DT, --1 数据日期
           A.LP_ID AS LGL_REP_ID, --2 法人编号
           A.ENTRY_ORG_ID AS ORG_ID, --3  机构编号
           NVL(A.ISSUER_CUST_ID,B.ISSUER_CD) AS CUST_ID, --4 客户编号  发行人客户编号为空就取发行人编号
           NULL AS INVEST_ORG_TYP, --5  投资机构类型
           A.BOND_ID || A.TRAN_ACCT_B_ID AS ACC_ID, --6  账户编号
           A.ACCT_ATTR_CD AS ACC_TYP, --7 账户类型
           A.BOND_ID AS ULYG_PROD_ID, --8  标的产品编号
           'A01' AS INVEST_BIZ_VRTY, --9 投资业务品种-- 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
           'A' AS OPR_TYP, --10  经营类型
           '1' AS IN_OUT_FLG, --11 表内表外标志 --XUXIAOBIN 20220905 ADD
           A.CURR_CD AS CUR, --12 币种
           --TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS BIZ_DT, --13 业务发生日期
           --TO_CHAR(NVL(A.VALUE_DT,A.OPEN_DT), 'YYYYMMDD')  AS BIZ_DT, --13 业务发生日期
           TO_CHAR(A.ISSUE_DT, 'YYYYMMDD')  AS BIZ_DT, --13 业务发生日期
           TO_CHAR(A.EXP_DT, 'YYYYMMDD') AS EXP_DT, --14 到期日期
           /*A.CURRT_BAL AS BOOK_BAL, --15 账面余额 当期余额*/
           A.BOOK_BAL AS BOOK_BAL, --15 账面余额
           A.EVHA_VAL_CHAG AS FAIR_VAL, --16 公允价值
           NULL AS HIS_COST, --17 历史成本
           A.ACRU_INT AS INT, --18  利息  应计利息
           NULL AS NEXT_INT_PAY_DT, --19  下一付息日
           NULL AS RATE_RE_PRC_DT, --20 利率重新定价日期
           NULL AS PRO_IMPT, --21 减值准备
           '01' AS LVL5_CL, --22  五级分类
           NULL AS LMT_ID, --23 额度编号
           B.MGMT_MODE_CD AS MGT_MOD, --24  管理方式
           TC.TAR_VALUE_CODE AS FIN_AST_CL, --25 金融资产分类
           NULL AS BIG_AMT_RSK_EXP_EXMPT, --26  大额风险暴露豁免
           NULL AS HOLD_UN_BOT_AST_LBY_BAL, --27  持有非底层资产产生的间接负债余额
           NULL       AS PROD_RAISE_MODE, --28  产品募集方式   mod by hulj20230116
           A.HOLD_FAC_VAL AS HOLD_FACE_VAL, --29  持有面值
           NULL AS SPV_ID, --30 特定目的载体编号
           E.MOVE_WAY_CD AS OPR_MODE, --31 运行方式
           NULL AS AST_MGT_PROD_STATS_ID, --32  资管产品统计编号
           A.FAC_VAL_INT_RAT AS BIZ_OCCUR_TMPNT_ACT_RATE, --33 业务发生时点实际利率 --20221013 XUXIAOBIN MODIFY
           NULL AS AMT, --34  发生额
           NULL AS SELF_VALET_FLG, --35 自营代客标志
           '' AS DEPT_LINE, --36  部门条线 20220805 XUXIAOBIN
           '资金债券' AS DATA_SRC, --37  数据来源
           /*A.FIN_INSTM_ID || '_' || */
           A.BOND_ID||'_'||A.ASSET_THD_CLS_CD || '_' || A.TRAN_ACCT_B_ID AS ID --38 业务主键 --modify by hulj20221101
            ,A.EVHA_VAL_CHAG_PL                   EVHA_VAL_CHAG_PL     --39公允价值变动损益
            ,A.SPD_PRFT                           SPD_PL               --40价差损益
            ,A.INT_PRFT                           INT_INCOME           --41利息收入
            ,A.ASSET_THD_CLS_CD                   ASSET_THD_CLS_CD     --42资产三分类代码
            ,A.STD_PROD_ID                        STD_PROD_ID          --43标准产品编号
            ,A.SUBJ_ID                            SUBJ_ID              --44科目编号
            ,NULL AS OBJ_ID --对象编号
            ,A.CURRT_BAL AS CURRT_BAL  --当期余额
            ,A.BOND_TYPE_CD AS ASSET_TYPE_ID --原始资产类型代码
            ,A.ASSET_TYPE_NAME AS ASSET_NAME --资产名称
            ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS VALUE_DT   --起息日
            ,TO_CHAR(E.LIST_DT,'YYYYMMDD')   AS LIST_DT    --上市日期
            ,E.SPEC_AIM_VECTOR_TYPE_CD       AS SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
            ,NVL(A1.EVHA_VAL_CHAG_PL,0)      AS BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
            ,NVL(A1.SPD_PRFT,0)              AS BGN_YEAR_SPD_PL                --年初价差损益
            ,NVL(A1.INT_PRFT,0)              AS BGN_YEAR_INT_INCOME            --年初利息收入
      FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A --资金债券投资表
      LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息表
        ON A.BOND_ID = B.BOND_ID
       AND B.DATA_SRC_SYS_IDF = 'CTMS'
       AND A.ETL_DT = B.ETL_DT
     LEFT JOIN O_ICL_CMM_CAP_BOND_INVEST A1 --资金债券投资表 取年初数据
       ON A1.BOND_ID = A.BOND_ID
      AND A1.BOND_TYPE_CD = A.BOND_TYPE_CD
      AND A1.TRAN_ACCT_B_ID = A.TRAN_ACCT_B_ID
      AND A1.BOND_ID||'_'||A1.ASSET_THD_CLS_CD || '_' || A1.TRAN_ACCT_B_ID = A.BOND_ID||'_'||A.ASSET_THD_CLS_CD || '_' || A.TRAN_ACCT_B_ID
      AND A1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM E
        ON A.BOND_ID = E.FIN_INSTM_ID
       AND E.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
     WHERE A.BOND_TYPE_CD <> 'W' --W 为同业存单
       AND B.DATA_SRC_SYS_IDF = 'CTMS' --数据来源系统标识
          --AND B.ISSUER_CD IS NOT NULL  --发行人编号不为空
       AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    /*AND A.BOOK_BAL>0*/
    ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  /*****************特定载体*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-特定载体';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (
     DATA_DT, --1 数据日期
     LGL_REP_ID, --2 法人编号
     ORG_ID, --3 机构编号
     CUST_ID, --4  客户编号
     INVEST_ORG_TYP, --5 投资机构类型
     ACC_ID, --6 账户编号
     ACC_TYP, --7  账户类型
     ULYG_PROD_ID, --8 标的产品编号
     INVEST_BIZ_VRTY, --9  投资业务品种
     OPR_TYP, --10 经营类型
     IN_OUT_FLG, --11  表内表外标志
     CUR, --12 币种
     BIZ_DT, --13  业务发生日期
     EXP_DT, --14  到期日期
     BOOK_BAL, --15  账面余额
     FAIR_VAL, --16  公允价值
     HIS_COST, --17  历史成本
     INT, --18 利息
     NEXT_INT_PAY_DT, --19 下一付息日
     RATE_RE_PRC_DT, --20  利率重新定价日期
     PRO_IMPT, --21  减值准备
     LVL5_CL, --22 五级分类
     LMT_ID, --23  额度编号
     MGT_MOD, --24 管理方式
     FIN_AST_CL, --25  金融资产分类
     BIG_AMT_RSK_EXP_EXMPT, --26 大额风险暴露豁免
     HOLD_UN_BOT_AST_LBY_BAL, --27 持有非底层资产产生的间接负债余额
     PROD_RAISE_MODE, --28 产品募集方式
     HOLD_FACE_VAL, --29 持有面值
     SPV_ID, --30  特定目的载体编号
     OPR_MODE, --31  运行方式
     AST_MGT_PROD_STATS_ID, --32 资管产品统计编号
     BIZ_OCCUR_TMPNT_ACT_RATE, --33  业务发生时点实际利率
     AMT, --34 发生额
     SELF_VALET_FLG, --35  自营代客标志
     DEPT_LINE, --36 部门条线
     DATA_SRC, --37 数据来源
     ID,        --38 业务主键
     ASSET_TYPE_ID, --39原始资产类型代码
     ASSET_NAME     --40资产名称
     ,EVHA_VAL_CHAG_PL     --39公允价值变动损益
     ,SPD_PL               --40价差损益
     ,INT_INCOME           --41利息收入
     ,ASSET_THD_CLS_CD     --42资产三分类代码
     ,STD_PROD_ID          --43标准产品编号
     ,SUBJ_ID              --44科目编号
     ,OBJ_ID --对象编号
     ,CURRT_BAL  --当期余额
     ,VALUE_DT   --起息日
     ,LIST_DT    --上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
     ,OVDUE_FLG --逾期标志
     ,BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
     ,BGN_YEAR_SPD_PL                --年初价差损益
     ,BGN_YEAR_INT_INCOME            --年初利息收入
     )
  --技术口径-同业净值型产品投资
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD') AS DATA_DT, --1 数据日期
           A.LP_ID AS LGL_REP_ID, --2 法人编号
           A.BELONG_ORG_ID AS ORG_ID, --3  机构编号
           COALESCE(TRIM(A.UDER_ACTL_FINER_CUST_ID),
                    TRIM(G.ISSUER_CUST_ID),
                    TRIM(D.CUST_ID),
                    TRIM(F1.CUST_ID),
                    TRIM(H.CUST_ID),
                    TRIM(G.ACTL_FINER_CUST_ID),
                    TRIM(TRIM(H.SRC_PARTY_ID)),
                    '-') CUST_ID, --4 客户编号
           NULL AS INVEST_ORG_TYP, --5  投资机构类型
            A.FIN_INSTM_ID, --6  账户编号
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%货币基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%理财%' OR
                  A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
                  A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' OR
                  A.ASSET_TYPE_NAME LIKE '%资%管%计划%' OR
                  A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR
                  A.ASSET_TYPE_NAME LIKE '%资产支持证券%' OR
                  A.ASSET_TYPE_NAME = '类信贷资产' THEN
              '1'
             ELSE
              '2'
           END ACC_TYP, --7  账户类型
           A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID AS ULYG_PROD_ID, --8  标的产品编号 20221102XUXIAOBIN MODIFY
           'A03' AS INVEST_BIZ_VRTY, --9 投资业务品种 --01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
           TA.TAR_VALUE_CODE AS OPR_TYP, --10  经营类型
           '1' AS IN_OUT_FLG, --11 表内表外标志 --XUXIAOBIN 20220905 ADD
           A.CURR_CD AS CUR, --12 币种
           --TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS BIZ_DT, --13 业务发生日期
           CASE WHEN TO_CHAR(A.VALUE_DT, 'YYYYMMDD') <> '00010101'
                 THEN TO_CHAR(A.VALUE_DT, 'YYYYMMDD')
                WHEN TO_CHAR(A.VALUE_DT, 'YYYYMMDD') = '00010101' AND TO_CHAR(A.SUBSCR_DT, 'YYYYMMDD') <>  '00010101'
                 THEN TO_CHAR(A.SUBSCR_DT, 'YYYYMMDD')
                ELSE NULL
             END AS BIZ_DT, --13 业务发生日期
           CASE
             /*WHEN G.ASSET_TYPE_NAME LIKE '%货币基金%' THEN
              TO_CHAR(A.ETL_DT + 1, 'YYYYMMDD') --若为货币基金的，到期日统一为数据日期+1天的日期
             WHEN G.ASSET_TYPE_NAME LIKE '%债券基金%' AND G.MOVE_WAY_CD = '01' THEN
              TO_CHAR(A.ETL_DT + 1, 'YYYYMMDD') --若为债券基金，运行方式为01，到期日统一为数据日期+1天的日期*/
             WHEN TO_CHAR(A.EXP_DT, 'YYYY-MM-DD') = '2999-12-31' THEN
              NULL
             ELSE
              TO_CHAR(A.EXP_DT, 'YYYYMMDD') --其它因数据补全暂按现逻辑
           END AS EXP_DT, --14 到期日期 20220905 XUXIAOBIN MODIFY
           A.BOOK_BAL AS BOOK_BAL, --15 账面余额
           -- A.CURRT_BAL AS BOOK_BAL, --15 账面余额  --20220702 当期余额
           A.EVHA_VAL_CHAG AS FAIR_VAL, --16 公允价值
           NULL AS HIS_COST, --17 历史成本
           --A.INT_RECVBL AS INT, --18  利息
           A.ACRU_INT AS INT, --18  利息 --20220702 应计利息
           NULL AS NEXT_INT_PAY_DT, --19  下一付息日
           NULL AS RATE_RE_PRC_DT, --20 利率重新定价日期
           NULL AS PRO_IMPT, --21 减值准备
           NVL(TB.TAR_VALUE_CODE, '01') AS LVL5_CL, --22  五级分类
           NULL AS LMT_ID, --23 额度编号
           G.MGMT_MODE_CD AS MGT_MOD, --24  管理方式
           TC.TAR_VALUE_CODE FIN_AST_CL, --25 金融资产分类
           NULL AS BIG_AMT_RSK_EXP_EXMPT, --26  大额风险暴露豁免
           NULL AS HOLD_UN_BOT_AST_LBY_BAL, --27  持有非底层资产产生的间接负债余额
           CASE WHEN A.UDER_COLL_WAY_CD = '0'
                THEN 'A'
                WHEN A.UDER_COLL_WAY_CD = '1'
                THEN 'B'
                END   AS PROD_RAISE_MODE, --28  产品募集方式  --mod by hulj 20230116
          A.FAC_VAL_AMT AS HOLD_FACE_VAL, --29  持有面值
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN
              'G' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%理财%' THEN
              'A' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
                  G.FIN_INSTM_NAME LIKE '%信托%' OR
                  A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN
              'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN
              'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND
                  A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' OR
                  A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR
                  A.ASSET_TYPE_NAME LIKE '%资产支持证券%' THEN
              'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME = '类信贷资产' THEN
              'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             ELSE
              ''
           END AS SPV_ID, --30 特定目的载体编号
           G.MOVE_WAY_CD AS OPR_MODE, --31 运行方式
           NULL AS AST_MGT_PROD_STATS_ID, --32  资管产品统计编号
           NULL AS BIZ_OCCUR_TMPNT_ACT_RATE, --33 业务发生时点实际利率
           NULL AS AMT, --34  发生额
           NULL AS SELF_VALET_FLG, --35 自营代客标志
           '' AS DEPT_LINE, --36  部门条线
           '同业净值型' AS DATA_SRC, --37  数据来源
           A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID, --业务主键
           G.ASSET_TYPE_ID   AS ASSET_TYPE_ID,          --原始资产类型代码
           A.ASSET_TYPE_NAME AS ASSET_NAME              --资产名称
           ,/*F.EVHA_VAL_CHAG_PL*/
            CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC')
            OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001','304030100002'
            ,'304030100003','304030100004','304040100001','304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
            --业务要求这些产品的公允价值变动从减估值系统取
                THEN NVL(T5.N_PV_VARIATION,0)
                ELSE NVL(F.EVHA_VAL_CHAG_PL,0)
                END            AS EVHA_VAL_CHAG_PL     --39公允价值变动损益
           ,F.SPD_PL           AS SPD_PL               --40价差损益
           ,F.INT_INCOME       AS INT_INCOME           --41利息收入
           ,A.ASSET_THD_CLS_CD AS ASSET_THD_CLS_CD     --42资产三分类代码
           ,A.STD_PROD_ID      AS STD_PROD_ID          --43标准产品编号
           ,A.SUBJ_ID          AS SUBJ_ID              --44科目编号
           ,A.OBJ_ID AS OBJ_ID --对象编号
           ,A.CURRT_BAL AS CURRT_BAL  --当期余额
           ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS VALUE_DT   --起息日
           ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ( '29991231','00010101') THEN NULL
           ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD') END   AS LIST_DT    --上市日期
           ,G.SPEC_AIM_VECTOR_TYPE_CD       AS SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
           ,A.OVDUE_FLG AS OVDUE_FLG --逾期标志
           ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC')
            OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001','304030100002'
            ,'304030100003','304030100004','304040100001','304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
            --业务要求这些产品的公允价值变动从减估值系统取
                THEN NVL(T6.N_PV_VARIATION,0)
                ELSE NVL(F2.EVHA_VAL_CHAG_PL,0)
                END                         AS EVHA_VAL_CHAG_PL     --39公允价值变动损益      AS BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
           ,NVL(F2.SPD_PL,0)                AS BGN_YEAR_SPD_PL                --年初价差损益
           ,NVL(F2.INT_INCOME,0)            AS BGN_YEAR_INT_INCOME            --年初利息收入
      FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A --同业净值型产品投资
      LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
        ON A.UDER_ACTL_FINER_CUST_ID = D.CUST_ID
       AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
        ON A.UDER_ACTL_FINER_CUST_ID = E.SPV_CUST_ID
       AND E.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND E.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO F1 --对公客户信息
        ON E.PARTY_ID = F1.CUST_ID
       AND F1.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
        ON A.FIN_INSTM_ID = G.FIN_INSTM_ID
       AND A.MARKET_TYPE_ID = G.MARKET_TYPE_ID
       AND A.ASSET_TYPE_ID = G.ASSET_TYPE_ID
       AND A.ETL_DT = G.ETL_DT
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST F --同业证券持仓
        ON A.FIN_INSTM_ID = F.FIN_INSTM_ID
       AND A.BUS_ID = F.BUS_ID --20220924 xuxiaobin数据发散，加条件
       AND A.OBJ_ID = F.OBJ_ID --20220924 xuxiaobin数据发散，加条件
       AND F.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST F2 --同业证券持仓 取年初数据
        ON A.FIN_INSTM_ID = F2.FIN_INSTM_ID
       AND A.BUS_ID = F2.BUS_ID
       AND A.OBJ_ID = F2.OBJ_ID
       AND F2.ETL_DT = TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'Y')-1
      LEFT JOIN O_IOL_IFRS_FCT_ECL_RES_DTL T5 --减值结果表
           ON T5.V_FINANCIAL_ID = A.FIN_INSTM_ID
           AND T5.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
           AND T5.V_ID_NUMBER = A.OBJ_ID
           AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IOL_IFRS_FCT_ECL_RES_DTL T6 --减值结果表 取年初数据
           ON T6.V_FINANCIAL_ID = A.FIN_INSTM_ID
           AND T6.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
           AND T6.V_ID_NUMBER = A.OBJ_ID
           AND T6.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
      LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO H
        ON G.ISSUE_ORG_ID = H.SRC_PARTY_ID
       AND H.ETL_DT = G.ETL_DT
      LEFT JOIN CODE_MAP TA --经营类型转码
        ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
       AND TA.SRC_CLASS_CODE = 'CD1479'
       AND TA.TAR_CLASS_CODE = 'D0046'
       AND TA.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TB --五级分类转码
        ON TB.SRC_VALUE_CODE = F.LEVEL5_CLS_CD
       AND TB.SRC_CLASS_CODE = 'CD1032'
       AND TB.TAR_CLASS_CODE = 'D0005'
       AND TB.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
     WHERE TO_CHAR(A.ETL_DT, 'YYYYMMDD') = V_P_DATE
    UNION ALL
    --技术口径-同业-货币基金、理财产品、信托计划、资产管理计划、债券基金
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD') AS DATA_DT, --1 数据日期
           A.LP_ID AS LGL_REP_ID, --2 法人编号
           A.BELONG_ORG_ID AS ORG_ID, --3  机构编号
           --NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-')),--OBJ_ID AS CUST_ID, --4 客户编号
           COALESCE(TRIM(G.ISSUER_CUST_ID),D.CUST_ID, F.CUST_ID,
               TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-')), --4 客户编号
           NULL AS INVEST_ORG_TYP, --5  投资机构类型
            A.FIN_INSTM_ID, --A.INTNAL_SECU_ACCT_ID || A.FIN_INSTM_ID||A.BUS_ID AS ACC_ID, --6  账户编号
           NULL AS ACC_TYP, --7 账户类型
           A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID AS ULYG_PROD_ID, --8  标的产品编号20221102 XUXIAOBIN MODIFY
           'A04' AS INVEST_BIZ_VRTY, --9 投资业务品种 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
           TA.TAR_VALUE_CODE AS OPR_TYP, --10  经营类型
           '1' AS IN_OUT_FLG, --11 表内表外标志 --XUXIAOBIN 20220905 ADD
           A.CURR_CD AS CUR, --12 币种
           --TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS BIZ_DT, --13 业务发生日期
           TO_CHAR(NVL(A.VALUE_DT,A.OPEN_DT), 'YYYYMMDD') AS BIZ_DT, --13 业务发生日期
           TO_CHAR(A.EXP_DT, 'YYYYMMDD') AS EXP_DT, --14 到期日期
           /*A.CURRT_BAL AS BOOK_BAL, --15 账面余额  --当期余额 20220702 XUCX*/
           NVL(A.ACTL_BAL, 0) + NVL(A.EVHA_VAL_CHAG, 0) AS BOOK_BAL, --15 账面余额 --XUXIAOBIN 根据金数修改
           A.EVHA_VAL_CHAG AS FAIR_VAL, --16 公允价值
           NULL AS HIS_COST, --17 历史成本
           --A.INT_RECVBL AS INT, --18  利息
           A.CURRT_ACRU_INT AS INT, --18  利息  当期应计利息  20220702 XUCX
           NULL AS NEXT_INT_PAY_DT, --19  下一付息日
           NULL AS RATE_RE_PRC_DT, --20 利率重新定价日期
           NULL AS PRO_IMPT, --21 减值准备
           NVL(TB.TAR_VALUE_CODE, '01') AS LVL5_CL, --22  五级分类
           NULL AS LMT_ID, --23 额度编号
           G.MGMT_MODE_CD AS MGT_MOD, --24  管理方式
           TC.TAR_VALUE_CODE AS FIN_AST_CL, --25 金融资产分类
           NULL AS BIG_AMT_RSK_EXP_EXMPT, --26  大额风险暴露豁免
           NULL AS HOLD_UN_BOT_AST_LBY_BAL, --27  持有非底层资产产生的间接负债余额
           NULL  AS PROD_RAISE_MODE, --28  产品募集方式  --mod by hulj 20230116
           NULL AS HOLD_FACE_VAL, --29  持有面值
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN
              'G' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%理财%' THEN
              'A' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
             G.FIN_INSTM_NAME LIKE '%信托%' OR
                  A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN
              'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN
              'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND
                  A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' OR
                  A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR
                  A.ASSET_TYPE_NAME LIKE '%资产支持证券%' THEN
              'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME = '类信贷资产' THEN
              'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             ELSE
              ''
           END AS SPV_ID, --30 特定目的载体编号
           G.MOVE_WAY_CD AS OPR_MODE, --31 运行方式
           NULL AS AST_MGT_PROD_STATS_ID, --32  资管产品统计编号
           NULL AS BIZ_OCCUR_TMPNT_ACT_RATE, --33 业务发生时点实际利率
           NULL AS AMT, --34  发生额
           NULL AS SELF_VALET_FLG, --35 自营代客标志
           '' AS DEPT_LINE, --36  部门条线
           '同业证券持仓' AS DATA_SRC, --37  数据来源
           A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID, --业务主键
           G.ASSET_TYPE_ID   AS ASSET_TYPE_ID,         --原始资产类型代码
           A.ASSET_TYPE_NAME AS ASSET_TYPE_NAEM        --资产名称
           ,A.EVHA_VAL_CHAG  AS EVHA_VAL_CHAG_PL     --39公允价值变动损益
           ,A.SPD_PL         AS SPD_PL               --40价差损益
           ,A.INT_INCOME     AS INT_INCOME           --41利息收入
           ,A.ASSET_THD_CLS_CD  AS ASSET_THD_CLS_CD     --42资产三分类代码
           ,A.STD_PROD_ID       AS STD_PROD_ID          --43标准产品编号
           ,A.SUBJ_ID           AS SUBJ_ID              --44科目编号
           ,A.OBJ_ID AS OBJ_ID --对象编号
           ,A.CURRT_BAL AS CURRT_BAL  --当期余额
           ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS VALUE_DT --起息日
           ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ( '29991231','00010101') THEN NULL
          ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD') END    AS LIST_DT  --上市日期
           ,G.SPEC_AIM_VECTOR_TYPE_CD         AS SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
           ,A.OVDUE_FLG AS OVDUE_FLG --逾期标志
           ,NVL(A1.EVHA_VAL_CHAG_PL,0)      AS BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
           ,NVL(A1.SPD_PL,0)                AS BGN_YEAR_SPD_PL                --年初价差损益
           ,NVL(A1.INT_INCOME,0)            AS BGN_YEAR_INT_INCOME            --年初利息收入
      FROM O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST A1 --同业证券持仓表
        ON  A1.FIN_INSTM_ID = A.FIN_INSTM_ID
       AND  A1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
       AND  A1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
       AND  A1.FIN_INSTM_ID || '_' || A1.ASSET_THD_CLS_CD || '_' || A1.OBJ_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
       AND  A1.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
      LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO B --同业交易对手信息
        ON B.SRC_PARTY_ID = A.ISSUER_ID
       AND B.ETL_DT = A.ETL_DT
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
        ON A.FIN_INSTM_ID = G.FIN_INSTM_ID
       AND A.MARKET_TYPE_ID = G.MARKET_TYPE_ID
       AND A.ASSET_TYPE_ID = G.ASSET_TYPE_ID
       AND G.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
        ON NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-')) = D.CUST_ID
       AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
        ON NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-')) =
           E.SPV_CUST_ID
       AND E.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND E.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户信息
        ON E.PARTY_ID = F.CUST_ID
       AND F.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN CODE_MAP TA --经营类型转码
        ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
       AND TA.SRC_CLASS_CODE = 'CD1479'
       AND TA.TAR_CLASS_CODE = 'D0046'
       AND TA.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TB --五级分类转码
        ON TB.SRC_VALUE_CODE = A.LEVEL5_CLS_CD
       AND TB.SRC_CLASS_CODE = 'CD1032'
       AND TB.TAR_CLASS_CODE = 'D0005'
       AND TB.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
    /*  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D  --对公客户信息表
    ON NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-')) = D.CUST_ID*/
     WHERE TO_CHAR(A.ETL_DT, 'YYYYMMDD') = V_P_DATE
       AND A.ASSET_TYPE_NAME LIKE '%货币基金%'
       /*AND A.OBJ_ID NOT IN (select A.OBJ_ID from RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST WHERE TO_CHAR(ETL_DT, 'YYYYMMDD') = V_P_DATE
       UNION
       select A.OBJ_ID from RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST WHERE TO_CHAR(ETL_DT, 'YYYYMMDD') = V_P_DATE
       )*/
       ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  /*****************同业非标投资*****************/
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入投资业务信息-同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_INVEST_INFO
    (DATA_DT, --1 数据日期
     LGL_REP_ID, --2 法人编号
     ORG_ID, --3 机构编号
     CUST_ID, --4  客户编号
     INVEST_ORG_TYP, --5 投资机构类型
     ACC_ID, --6 账户编号
     ACC_TYP, --7  账户类型
     ULYG_PROD_ID, --8 标的产品编号
     INVEST_BIZ_VRTY, --9  投资业务品种
     OPR_TYP, --10 经营类型
     IN_OUT_FLG, --11  表内表外标志
     CUR, --12 币种
     BIZ_DT, --13  业务发生日期
     EXP_DT, --14  到期日期
     BOOK_BAL, --15  账面余额
     FAIR_VAL, --16  公允价值
     HIS_COST, --17  历史成本
     INT, --18 利息
     NEXT_INT_PAY_DT, --19 下一付息日
     RATE_RE_PRC_DT, --20  利率重新定价日期
     PRO_IMPT, --21  减值准备
     LVL5_CL, --22 五级分类
     LMT_ID, --23  额度编号
     MGT_MOD, --24 管理方式
     FIN_AST_CL, --25  金融资产分类
     BIG_AMT_RSK_EXP_EXMPT, --26 大额风险暴露豁免
     HOLD_UN_BOT_AST_LBY_BAL, --27 持有非底层资产产生的间接负债余额
     PROD_RAISE_MODE, --28 产品募集方式
     HOLD_FACE_VAL, --29 持有面值
     SPV_ID, --30  特定目的载体编号
     OPR_MODE, --31  运行方式
     AST_MGT_PROD_STATS_ID, --32 资管产品统计编号
     BIZ_OCCUR_TMPNT_ACT_RATE, --33  业务发生时点实际利率
     AMT, --34 发生额
     SELF_VALET_FLG, --35  自营代客标志
     DEPT_LINE, --36 部门条线
     DATA_SRC, --37 数据来源
     ID,        --38 业务主键
     ASSET_TYPE_ID, --39原始资产类别代码
     ASSET_NAME    --40资产名称
     ,EVHA_VAL_CHAG_PL     --39公允价值变动损益
     ,SPD_PL               --40价差损益
     ,INT_INCOME           --41利息收入
     ,ASSET_THD_CLS_CD     --42资产三分类代码
     ,STD_PROD_ID          --43标准产品编号
     ,SUBJ_ID              --44科目编号
     ,OBJ_ID --对象编号
     ,CURRT_BAL  --当期余额
     ,VALUE_DT   --起息日
     ,LIST_DT    --上市日期
     ,SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
     ,OVDUE_FLG --逾期标志
     ,BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
     ,BGN_YEAR_SPD_PL                --年初价差损益
     ,BGN_YEAR_INT_INCOME            --年初利息收入
     )
    SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD') DATA_DT, --1 数据日期
           A.LP_ID LGL_REP_ID, --2 法人编号
           A.BELONG_ORG_ID ORG_ID, --3 机构编号
           --A.UDER_ACTL_FINER_CUST_ID, --A.OBJ_ID  CUST_ID, --4  客户编号
           COALESCE(TRIM(A.UDER_ACTL_FINER_CUST_ID),
           TRIM(G.ISSUER_CUST_ID),TRIM(A.CNTPTY_CUST_ID),TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-')),--4  客户编号  MD BY 20221107 XUXIAOBIN
           NULL INVEST_ORG_TYP, --5 投资机构类型
            A.FIN_INSTM_ID, --A.INTNAL_SECU_ACCT_ID || A.FIN_INSTM_ID||A.BUS_ID ACC_ID, --6 账户编号
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%货币基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%理财%' OR
                  A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
                  A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' OR
                  A.ASSET_TYPE_NAME LIKE '%资%管%计划%' OR
                  A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR
                  A.ASSET_TYPE_NAME LIKE '%资产支持证券%' OR
                  A.ASSET_TYPE_NAME = '类信贷资产' THEN
              '1'
             ELSE
              '2'
           END ACC_TYP, --7  账户类型
           /*A.FIN_INSTM_ID*/A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID ULYG_PROD_ID,
            --8 标的产品编号 --20221102 XUXIAOBIN MODIFY
           'A05' INVEST_BIZ_VRTY, --9  投资业务品种 01资金债券投资 02同业债券投资 03同业净值型产品投资 04同业货币基金 05同业非标投资
           TA.TAR_VALUE_CODE OPR_TYP, --10 经营类型
           '1' AS IN_OUT_FLG, --11 表内表外标志 --XUXIAOBIN 20220905 ADD
           A.CURR_CD CUR, --12 币种
           TO_CHAR(A.VALUE_DT, 'YYYYMMDD') BIZ_DT, --13  业务发生日期
           TO_CHAR(A.EXP_DT, 'YYYYMMDD') EXP_DT, --14  到期日期
           --A.CURRT_BAL  BOOK_BAL, --15  账面余额
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN
              NVL(A.BOOK_BAL, 0)
             ELSE
              NVL(A.BOOK_BAL, 0) + ROUND(NVL(O.N_PV_VARIATION, 0), 2)
           END AS BOOK_BAL, --15  账面余额 20220806 XUXIAOBIN MODIFY
           A.EVHA_VAL_CHAG FAIR_VAL, --16  公允价值
           NULL HIS_COST, --17  历史成本
           A.ACRU_INT + A.RECVBL_UNCOL_INT AS INT, --18 利息  因新一代中同业系统将原应收利息和应计利息的部分逾期利息拆分到应收未收利息 陈晓桂老师确认利息应取应计+应收未收
           NULL NEXT_INT_PAY_DT, --19 下一付息日
           NULL RATE_RE_PRC_DT, --20  利率重新定价日期
           NULL PRO_IMPT, --21  减值准备
           NVL(TB.TAR_VALUE_CODE,'01') LVL5_CL, --22 五级分类
           NULL LMT_ID, --23  额度编号
           G.MGMT_MODE_CD  MGT_MOD, --24 管理方式
           TC.TAR_VALUE_CODE FIN_AST_CL, --25  金融资产分类
           NULL BIG_AMT_RSK_EXP_EXMPT, --26 大额风险暴露豁免
           NULL HOLD_UN_BOT_AST_LBY_BAL, --27 持有非底层资产产生的间接负债余额
           CASE WHEN A.UDER_COLL_WAY_CD = '0'
                THEN 'A'
                WHEN A.UDER_COLL_WAY_CD = '1'
                THEN 'B'
                END AS   PROD_RAISE_MODE, --28 产品募集方式  --mod by hulj20230116
           NULL HOLD_FACE_VAL, --29 持有面值
           CASE
             WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR
                  A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN
              'G' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%理财%' THEN
              'A' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR
                  G.FIN_INSTM_NAME LIKE '%信托%' OR
                  A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN
              'B' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN
              'F' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND
                  A.ASSET_TYPE_NAME NOT LIKE '保险资管计划' OR
                  A.ASSET_TYPE_NAME LIKE '%交易所公司债%' OR
                  A.ASSET_TYPE_NAME LIKE '%资产支持证券%' THEN
              'C' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             WHEN A.ASSET_TYPE_NAME = '类信贷资产' THEN
              'Z' || A.FIN_INSTM_ID || A.ASSET_TYPE_ID
             ELSE
              ''
           END SPV_ID, --30  特定目的载体编号
           G.MOVE_WAY_CD OPR_MODE, --31  运行方式
           NULL AST_MGT_PROD_STATS_ID, --32 资管产品统计编号
           A.FAC_VAL_INT_RAT BIZ_OCCUR_TMPNT_ACT_RATE, --33  业务发生时点实际利率
           NULL AMT, --34 发生额
           NULL SELF_VALET_FLG, --35  自营代客标志
           '' DEPT_LINE, --36 部门条线
           '同业非标' DATA_SRC, --37 数据来源
           A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID, --38业务主键
           G.ASSET_TYPE_ID   AS ASSET_TYPE_ID,          --39原始资产类型代码
           A.ASSET_TYPE_NAME AS ASSET_NAME             --40资产名称
          ,/*T1.EVHA_VAL_CHAG_PL*/
           CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC')
            OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001','304030100002'
            ,'304030100003','304030100004','304040100001','304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
            --业务要求这些产品的公允价值变动从减估值系统取
                THEN NVL(T5.N_PV_VARIATION,0)
                ELSE NVL(T1.EVHA_VAL_CHAG_PL,0)
                END             AS EVHA_VAL_CHAG_PL   --39公允价值变动损益
          ,T1.SPD_PL           AS SPD_PL               --40价差损益
          ,T1.INT_INCOME       AS INT_INCOME           --41利息收入
          ,A.ASSET_THD_CLS_CD AS ASSET_THD_CLS_CD     --42资产三分类代码
          ,A.STD_PROD_ID       AS STD_PROD_ID          --43标准产品编号
          ,A.SUBJ_ID           AS SUBJ_ID              --44科目编号
          ,A.OBJ_ID AS OBJ_ID --对象编号
          ,A.CURRT_BAL AS CURRT_BAL  --当期余额
          ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD') AS VALUE_DT   --起息日
          ,CASE WHEN TO_CHAR(G.LIST_DT,'YYYYMMDD') IN ( '29991231','00010101') THEN NULL
          ELSE TO_CHAR(G.LIST_DT,'YYYYMMDD') END
          ,G.SPEC_AIM_VECTOR_TYPE_CD       AS SPEC_AIM_VECTOR_TYPE_CD  --特定目的载体类型代码
          ,A.OVDUE_FLG AS OVDUE_FLG --逾期标志
          ,CASE WHEN (A.ASSET_THD_CLS_CD IN ('FVOCI','AC')
            OR A.STD_PROD_ID IN ('304010100001','304020100001','304020100002','304020100003','304020100004','304030100001','304030100002'
            ,'304030100003','304030100004','304040100001','304050100001','307010100001','307020100001','307020100002','307030100001','307030200001','307030200002'))
            --业务要求这些产品的公允价值变动从减估值系统取
                THEN NVL(T6.N_PV_VARIATION,0)
                ELSE NVL(T0.EVHA_VAL_CHAG_PL,0)
                END             AS BGN_YEAR_EVHA_VAL_CHAG_PL      --年初公允价值变动损益
          ,T0.SPD_PL                       AS BGN_YEAR_SPD_PL                --年初价差损益
          ,T0.INT_INCOME                   AS BGN_YEAR_INT_INCOME            --年初利息收入
      FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A --同业非标投资表
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST T1        --同业证券持仓表
           ON T1.FIN_INSTM_ID || '_' || T1.ASSET_THD_CLS_CD || '_' || T1.OBJ_ID=A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
           AND T1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
           AND T1.BUS_ID = A.BUS_ID
           AND A.INTNAL_SECU_ACCT_ID =T1.INTNAL_SECU_ACCT_ID
           AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_ICL_CMM_IBANK_SECU_POST T0 --同业证券持仓 取年初数据
           ON T0.FIN_INSTM_ID || '_' || T0.ASSET_THD_CLS_CD || '_' || T0.OBJ_ID=A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
           AND T0.MARKET_TYPE_ID = A.MARKET_TYPE_ID
           AND T0.BUS_ID = A.BUS_ID
           AND A.INTNAL_SECU_ACCT_ID =T0.INTNAL_SECU_ACCT_ID
           AND T0.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
      LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM G --同业金融工具表
        ON A.FIN_INSTM_ID = G.FIN_INSTM_ID
       AND A.ASSET_TYPE_ID = G.ASSET_TYPE_ID
       AND A.MARKET_TYPE_ID = G.MARKET_TYPE_ID
       AND G.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D  --同业交易对手信息
      ON G.ISSUE_ORG_ID = D.SRC_PARTY_ID ---ADD 20221107 XUXIAOBIN
      AND D.CREATE_DT <= G.ETL_DT
      AND D.ETL_DT = A.ETL_DT
      LEFT JOIN O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动 XUXIAOBIN 20220806 ADD
        ON A.FIN_INSTM_ID = O.V_ASSET_CODE
       AND A.ASSET_THD_CLS_CD = O.V_THREE_CLASS
       AND A.OBJ_ID = O.V_TRADE_NO
       AND A.ETL_DT = O.ETL_DT
      LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO T2
           ON A.APV_ODD_NO = T2.CONT_ID
           AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IOL_IFRS_FCT_ECL_RES_DTL T5   --减值结果表
           ON T5.V_FINANCIAL_ID = A.FIN_INSTM_ID
           AND T5.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
           AND T5.V_ID_NUMBER = A.OBJ_ID
           AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN O_IOL_IFRS_FCT_ECL_RES_DTL T6   --减值结果表 取年初公允价值变动
        ON T6.V_FINANCIAL_ID = A.FIN_INSTM_ID
       AND T6.V_THREE_STAGE_CD = A.ASSET_THD_CLS_CD
       AND T6.V_ID_NUMBER = A.OBJ_ID
       AND T6.ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1
      LEFT JOIN CODE_MAP TC --金融资产类型转码
        ON TC.SRC_VALUE_CODE = A.ASSET_THD_CLS_CD
       AND TC.SRC_CLASS_CODE = 'CD2060'
       AND TC.TAR_CLASS_CODE = 'D0048'
       AND TC.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TA
        ON TA.SRC_VALUE_CODE = A.CAP_TYPE_CD
       AND TA.SRC_CLASS_CODE = 'CD1479'
       AND TA.TAR_CLASS_CODE = 'D0046'
       AND TA.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TB --五级分类转码
        ON TB.SRC_VALUE_CODE = T2.LOAN_LEVEL5_CLS_CD
       AND TB.SRC_CLASS_CODE = 'CD1032'
       AND TB.TAR_CLASS_CODE = 'D0005'
       AND TB.MOD_FLG = 'MDM'
     WHERE TO_CHAR(A.ETL_DT, 'YYYYMMDD') = V_P_DATE
       ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

        -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID,ID,COUNT(1)
      FROM M_CPTL_INVEST_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ACC_ID,ID
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
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                '');

  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_INIT_M_CPTL_INVEST_INFO;
/

