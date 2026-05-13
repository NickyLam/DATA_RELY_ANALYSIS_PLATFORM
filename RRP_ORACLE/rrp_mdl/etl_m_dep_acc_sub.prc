CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_DEP_ACC_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_DEP_ACC_SUB
  *  功能描述：监管集市银行所有存款账户信息，包括个人、对公、活期、定期
  *  创建日期：202205223
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_DEP_ACCT_INFO   --存款分户信息
  *            ICL.CMM_IFS_ACCT_INFO       --联合存款分户信息
  *  目标表：  M_DEP_ACC_SUB  --存款账户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220901  许晓滨   科目调整，与旧监管不同。
  *             2    20221031  许晓滨   新增字段，协定存款模式不做拆分
  *             3    20221102  hulj     存款产品代码调整取值
  *             4    20221114  hulj     增加数据重复校验
  *             5    20221227  hulj     新增字段原始开户日期、原始到期日期
  *             6    20230104  hulj     调整保证金类别取值口径
  *             7    20250928  YJY      修改普通存款部分、存款分户-协定户活期部分的CO_DEP_TYP、C_DEPOSIT_TYPE判断
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_DEP_ACC_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_DEP_ACC_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_DEP_ACC_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '存款账户信息';
  V_STARTTIME := SYSDATE;
  /***存款分户信息-协定存款处理1***/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_ACC_SUB
    (DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ACC_ID                     --账户编号
    ,CUST_ID                    --客户编号
    ,ORG_ID                     --机构编号
    ,CUR                        --币种
    ,DEP_PROD_CD                --存款产品代码
    ,DEP_PROD_TYP               --存款产品类型
    ,VAL_DT                     --起息日期
    ,DEP_BAL                    --存款余额
    ,DEP_EXP_DT                 --存款到期日期
    ,CORP_IND_FLG               --对公对私标志
    ,SUBJ_ID                    --科目编号
    ,RATE                       --利率
    ,OPEN_ACC_DT                --开户日期
    ,OPEN_ACC_TLR_NO            --开户柜员号
    ,CNL_ACC_DT                 --销户日期
    ,DEP_ACC_STAT               --存款账户状态
    ,DEP_ACCT_STATUS_CD         --存款账户状态原码值
    ,LAST_ACC_CHG_DT            --上次动户日期
    ,CASH_REMIT_TYP             --钞汇类型
    ,AGRT_DEP_PSN_TYP           --协议存款人类型
    ,RATE_RE_PRC_DT             --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG    --内嵌提前到期期权标志
    ,ADV_DRAW_FLG               --可提前支取标志
    ,NTC_WD_DT                  --通知取款日期
    ,NTC_WD_AMT                 --通知取款金额
    ,CR_CRD_EX_PAY_FLG          --信用卡溢缴款标志
    ,PBL_INT                    --应付利息
    ,CO_DEP_TYP                 --单位存款类型
    ,DEP_INS_AMT                --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT            --有业务关系存款金额
    ,TD_APVL_ACC_FLG            --待核准账户标志
    ,INT_CALC_FLG               --计息标志
    ,SPCL_DEP_TYP               --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL     --委托贷款基金细类
    ,CONSR_TYP                  --委托人类型
    ,IND_DMD_DEP_ACC_TYP        --个人活期存款账户类型
    ,PBC_ACC_TYP                --人行账户类型
    ,TIME_DMD_FLG               --定活标志
    ,OPEN_ACC_CHAN              --开户渠道
    ,PRC_BASE_TYP               --定价基准类型
    ,RATE_TYP                   --利率类型
    ,BASE_RATE                  --基准利率
    ,RATE_FLT_FREQ              --利率浮动频率
    ,GUA_YLD                    --保底收益率
    ,HIGH_YLD_RTO               --最高收益率
    ,DIF_PLC_DEP_FLG            --异地存款标志
    ,DEP_RSV_MODE               --缴存准备金方式
    ,ACT_END_DT                 --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
    ,CRN_PRD_ACCRD_INT          --当期应计利息
    ,INTDAY_ACCRD_INT           --当日应计利息
    ,APPROVAL_ID                --核准件编号
    ,CORE_ACC_TYP               --客户类型
    ,SUB_ACC_ID                 --子账户编号
    ,ACC_ID_EAST                --账户编号_EAST
    ,EAR_M_BAL                  --月初余额
    ,NEXT_INT_SET_DT            --下次结息日期
    ,STD_PROD_ID                --标准产品代码
    ,DEP_TERM                   --存期
    ,IBANK_DEP_FLG              --同业存款标志
    ,AGREE_DEP_EXP_DT           --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG              --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT         --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT         --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT              --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT          --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD               --账户属性代码
    ,FROZ_FLG                   --冻结标志
    ,ACCT_CARD_NO               --客户账户卡号
    ,STOP_PAY_STATUS_CD         --止付状态代码
    ,FROZ_DT                    --冻结日期
    ,UNFRZ_DT                   --解冻日期
    ,INIT_OPEN_ACCT_DT          --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                --原始到期日期  add by hulj 20221227
    ,C_DEPOSIT_TYPE             --单位存款类型
    ,OVER_TERM_EXEC_INT_RAT     --超期执行利率
    ,ACCT_MED                   --账户介质
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')              AS DATA_DT                    --数据日期
        ,A.LP_ID                                   AS LGL_REP_ID                 --法人编号
        ,A.CUST_ACCT_ID                            AS ACC_ID                     --账户编号
        ,A.CUST_ID                                 AS CUST_ID                    --客户编号
        ,A.BELONG_ORG_ID                           AS ORG_ID                     --机构编号
        ,A.CURR_CD                                 AS CUR                        --币种                                                                                   --存款产品代码
        ,A.STD_PROD_ID                             AS DEP_PROD_CD                --存款产品代码 --modify by hulj
        ,CASE WHEN A.SUBJ_ID IN ('20110101','20110201','20110210') --仅针对活期存款
                   AND A.AGREE_DEP_FLG = '1' AND NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) <= 0
              THEN '0601' --结算户存款
              WHEN A.SUBJ_ID IN ('20110101','20110201','20110210') --仅针对活期存款
                   AND A.AGREE_DEP_FLG = '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN '0602' --协定户存款
              ELSE NVL(C.TAR_VALUE_CODE,A.STD_PROD_ID)
          END                                      AS DEP_PROD_TYP               --存款产品类型
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')            AS VAL_DT                     --起息日期
        ,CASE WHEN A.SUBJ_ID IN ('20110101','20110201','20110210')
                   AND A.AGREE_DEP_FLG = '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)
              ELSE A.CURRT_BAL
          END                                      AS DEP_BAL                    --存款余额
        ,CASE WHEN A.SUBJ_ID IN ('20110101','20110201','20110210')
                   AND A.AGREE_DEP_FLG LIKE '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN TO_CHAR(A.AGREE_DEP_EXP_DT,'YYYYMMDD')                        --协定存款到期日期
              ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                      AS DEP_EXP_DT                 --存款到期日期
        ,CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
              WHEN E.CUST_ID IS NOT NULL THEN '2'
          END                                      AS CORP_IND_FLG               --对公对私标志
        ,A.SUBJ_ID                                 AS SUBJ_ID                    --科目编号
        ,CASE WHEN A.SUBJ_ID IN ('20110101','20110201','20110210')
                   AND A.AGREE_DEP_FLG LIKE '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN A.AGREE_INT_RAT --协定利率
              ELSE A.EXEC_INT_RAT --执行利率
          END                                      AS RATE                       --利率
        ,CASE WHEN A.SUBJ_ID IN ('20110101','20110201','20110210')
                   AND A.AGREE_DEP_FLG LIKE '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN TO_CHAR(A.AGREE_DEP_VALUE_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')
          END                                      AS OPEN_ACC_DT                --开户日期
        ,TRIM(A.OPEN_ACCT_TELLER_ID)               AS OPEN_ACC_TLR_NO            --开户柜员号
        ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231')
              THEN '99991231'
              ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
          END                                      AS CNL_ACC_DT                 --销户日期
        ,NVL(TTA.TAR_VALUE_CODE,'99')              AS DEP_ACC_STAT               --存款账户状态
        ,A.DEP_ACCT_STATUS_CD                      AS DEP_ACCT_STATUS_CD         --存款账户状态原码值
        ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD') AS LAST_ACC_CHG_DT            --上次动户日期
        ,CASE WHEN A.EC_FLG = 'CA' THEN '02'--钞
              WHEN A.EC_FLG = 'TT' THEN '03'--汇
          END                                      AS CASH_REMIT_TYP             --钞汇类型
        ,G.AGT_DEP_TYPE_CD                         AS AGRT_DEP_PSN_TYP           --协议存款人类型
        ,NULL                                      AS RATE_RE_PRC_DT             --利率重新定价日期
        ,NULL                                      AS INNR_ADV_EXP_OPTION_FLG    --内嵌提前到期期权标志
        ,A.ADVD_DRAW_FLG                           AS ADV_DRAW_FLG               --可提前支取标志
        ,NULL                                      AS NTC_WD_DT                  --通知取款日期
        ,NULL                                      AS NTC_WD_AMT                 --通知取款金额
        ,NULL                                      AS CR_CRD_EX_PAY_FLG          --信用卡溢缴款标志
        ,NVL(A.CURRT_ACRU_INT,0)+NVL(A.CURRT_INT_PAYBL_ADJ,0) AS PBL_INT         --应付利息 --当期应计利息+当期应付利息调整
        ,CASE WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN (/*'1'*/'11','JJSB') THEN 'C' --社保 --基金社保 
              --MOD BY YJY 20250928 旧的1-社保基金-债券质押改为11-社保基金-债券质押  
              WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN (/*'2'*/'12','GJJ') THEN 'E' --住房公积金 --暂无公积金
              --MOD BY YJY 20250928 旧的2-社保基金-非债券质押改为12-社保基金-非债券质押  
              WHEN SUBSTR(A.SUBJ_ID,1,4) IN ('2005','2010','3008') THEN 'F' --财政性存款 --2022/07/16 XUXIAOBIN MODIFY
              WHEN E.CUST_ID IS NOT NULL THEN 'A' --企业存款
          END                                      AS CO_DEP_TYP                 --单位存款类型 --20220920xuxiaobinadd
        ,NULL                                      AS DEP_INS_AMT                --被存款保险制度覆盖的金额
        ,NULL                                      AS BIZ_REL_DEP_AMT            --有业务关系存款金额
        ,NULL                                      AS TD_APVL_ACC_FLG            --待核准账户标志
        ,A.INT_ACCR_FLG                            AS INT_CALC_FLG               --计息标志
        ,NULL                                      AS SPCL_DEP_TYP               --专项存款类型
        ,CASE WHEN A.SUBJ_ID LIKE '30070101%' --委托存款
              THEN '9012'
          END                                      AS ENTRS_LOAN_FUND_SUM_CL     --委托贷款基金细类
        ,NULL                                      AS CONSR_TYP                  --委托人类型
        ,CASE WHEN A.ACCT_TYPE_CD IN ('1','2','3') THEN A.ACCT_TYPE_CD
              ELSE C.TAR_VALUE_CODE
          END                                      AS IND_DMD_DEP_ACC_TYP        --个人活期存款账户类型
        ,A.ACCT_CLS_CD                             AS PBC_ACC_TYP                --人行账户类型
        ,A.RC_FLG                                  AS TIME_DMD_FLG               --定活标志
        ,A.OPEN_ACCT_CHN_TYPE_CD                   AS OPEN_ACC_CHAN              --开户渠道
        ,'TR09'                                    AS PRC_BASE_TYP               --定价基准类型 默认TR09：存款基准利率
        /*,CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
              ELSE '0' --浮动利率
          END                                      AS RATE_TYP                   --利率类型*/
        ,'1'                                       AS RATE_TYP                   --利率类型 默认固定利率
        ,A.BASE_RAT                                AS BASE_RATE                  --基准利率
        ,'00'                                      AS RATE_FLT_FREQ              --利率浮动频率 固定利率不浮动
        ,NULL                                      AS GUA_YLD                    --保底收益率
        ,A.EXPE_HIGT_YLD_RAT                       AS HIGH_YLD_RTO               --最高收益率
        ,NULL                                      AS DIF_PLC_DEP_FLG            --异地存款标志
        ,'DR03'                                    AS DEP_RSV_MODE               --缴存准备金方式
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              AS ACT_END_DT                 --实际终止日期
        --,TO_CHAR(A1.EXEC_INT_RAT,'YYYYMMDD')       AS BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
        ,A1.EXEC_INT_RAT                           AS BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
        --,TO_CHAR(A1.VALUE_DT,'YYYYMMDD')           AS BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
        ,A1.BASE_RAT                               AS BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
        ,NULL                                      AS DEPT_LINE                  --部门条线 --计划财务部
        ,'普通存款'                                AS DATA_SRC                   --数据来源
        ,A.CURRT_ACRU_INT                          AS CRN_PRD_ACCRD_INT          --当期应计利息
        ,A.TD_ACRU_INT                             AS INTDAY_ACCRD_INT           --当日应计利息
        ,A.APPROVAL_ID                             AS APPROVAL_ID                --核准件编号
        ,A.CUST_TYPE_CD                            AS CORE_ACC_TYP               --客户类型
        --,NVL(A.OLD_CUST_ACCT_SUB_ACCT_NUM,A.CUST_ACCT_SUB_ACCT_NUM) AS SUB_ACC_ID --子账户编号
        ,CASE WHEN A.SUBJ_ID LIKE '201101%' AND A.AGREE_DEP_FLG LIKE '%1%'
                   AND(A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0
                   AND NVL(A.AGREE_DEP_INIT_AMT, 0) != 0 --ADD BY XXL 20211020 排除协定金额为0或为空的情况
              THEN 'XD'||A.CUST_ACCT_SUB_ACCT_NUM --协定存款的特殊处理
              WHEN A.SUBJ_ID LIKE '201101%' AND A.AGREE_DEP_FLG LIKE '%1%'
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) < 0
                   AND NVL(A.AGREE_DEP_INIT_AMT, 0) != 0
              THEN 'XD2' --MDF BY TYJ 20220609  协定存款结算户部分特殊处理，赋默认值XD002
              ELSE A.CUST_ACCT_SUB_ACCT_NUM
          END                                      AS SUB_ACC_ID                 --子账户编号20221102 XUXIAOBIN业务希望用回以前的
        ,A.ACCT_ID                                 AS ACC_ID_EAST                --账户编号_EAST
        ,A.EAR_M_BAL                               AS EAR_M_BAL                  --月初余额
        ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')     AS NEXT_INT_SET_DT            --下次结息日期
        ,A.STD_PROD_ID                             AS STD_PROD_ID                --标准产品代码
        ,CASE WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('1Y','12M','365D') THEN '301' --一年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('2Y','24M','730D') THEN '302' --二年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('3Y','24M','1095D') THEN '303' --三年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('5Y','60M') THEN '305' --五年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('6Y','72M') THEN '306' --六年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('8Y','96M') THEN '308' --8年
              ELSE '999'
          END                                      AS DEP_TERM                   --存期
        ,A.IBANK_DEP_FLG                           AS IBANK_DEP_FLG              --同业存款标志
        ,TO_CHAR(A.AGREE_DEP_EXP_DT,'YYYYMMDD')    AS AGREE_DEP_EXP_DT           --协定存款到期日期(金数IMAS用)20221031 ADD
        ,A.AGREE_DEP_FLG                           AS AGREE_DEP_FLG              --协定存款标志(金数IMAS用)20221031 ADD
        ,A.AGREE_DEP_INIT_AMT                      AS AGREE_DEP_INIT_AMT         --协定存款起存金额(金数IMAS用)20221031 ADD
        ,TO_CHAR(A.AGREE_DEP_VALUE_DT,'YYYYMMDD')  AS AGREE_DEP_VALUE_DT         --协定存款起息日期(金数IMAS用)20221031 ADD
        ,A.AGREE_INT_RAT                           AS AGREE_INT_RAT              --协定利率(金数IMAS用)20221031 ADD
        ,TO_CHAR(A.AGREE_DEP_RELS_DT,'YYYYMMDD')   AS AGREE_DEP_RELS_DT          --协定存款解约日期(金数IMAS用)20221031 ADD
        ,G.FX_ACCT_CHAR_CD                         AS ACCT_CHAR_CD               --账户属性代码
        ,A.FROZ_FLG                                AS FROZ_FLG                   --冻结标志
        ,A.CUST_ACCT_CARD_NO                       AS ACCT_CARD_NO               --客户账户卡号
        ,A.STOP_PAY_STATUS_CD                      AS STOP_PAY_STATUS_CD         --止付状态代码
        ,TO_CHAR(A.FROZ_DT,'YYYYMMDD')             AS FROZ_DT                    --冻结日期
        ,TO_CHAR(A.UNFRZ_DT,'YYYYMMDD')            AS UNFRZ_DT                   --解冻日期
        ,TO_CHAR(G.INIT_OPEN_ACCT_DT,'YYYYMMDD')   AS INIT_OPEN_ACCT_DT          --原始开户日期  add by hulj 20221227
        ,TO_CHAR(G.INIT_EXP_DT,'YYYYMMDD')         AS INIT_EXP_DT                --原始到期日期  add by hulj 20221227
        ,CASE WHEN E.DEPOSITR_CATE_CD = '101' THEN 'A' --企业法人
              WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN ('CZCK','-',/*'3','4'*/'21','22','31','32') THEN 'B' --103 机关 3-其他财政性存款 4-其他
              --MOD BY YJY 20250928 修改存款性质代码，旧的3-住房公积金、4-其他财政性存款改为21-住房公积金-债券质押  、22-住房公积金-非债券质押、31-其他财政性存款-债券质押、32-其他财政性存款-非债券质押
              WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN (/*'1'*/'11','JJSB') THEN 'C' --'JJSB' 基金社保 1-社保基金 --MOD BY YJY 20250928 修改存款性质代码，旧的1-社保基金-债券质押改为11-社保基金-债券质押
              WHEN E.DEPOSITR_CATE_CD IN ('106','107') THEN 'D'
              WHEN A.DEP_CHAR_CD IN (/*'2'*/'12','GJJ') THEN 'E' --2-公积金 --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
              --MOD BY YJY 20250928 修改存款性质代码，旧的2-社保基金-非债券质押改为12-社保基金-非债券质押
              WHEN E.CUST_ID IS NOT NULL THEN 'A'
          END                                      AS C_DEPOSIT_TYPE             --单位存款类型
        ,A.OVER_TERM_EXEC_INT_RAT                  AS OVER_TERM_EXEC_INT_RAT     --超期执行利率
        ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6'  --A存单
              WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5'  --B折或一本通
              --WHEN H.VOUCH_FORM_CD = 'C' THEN '2'  --C贷记卡 华兴无贷记卡
              WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1'  --D借记卡
              WHEN H.VOUCH_FORM_CD IN ('CHQ','CHK') THEN '4'  --E支票
              ELSE '9' --其他
          END                                      AS ACCT_MED                   --账户介质
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A  --存款分户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO G  --存款账户附加信息
      ON G.ACCT_ID = A.ACCT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO H  --存款主账户信息
      ON H.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP C  --码值映射表
      ON C.SRC_VALUE_CODE = A.STD_PROD_ID
     AND C.SRC_CLASS_CODE = 'STD0001'
     AND C.TAR_CLASS_CODE = 'T0015'
     AND C.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基础信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A1  --存款分户信息 取业务发生时点基准利率
      ON A1.ACCT_ID = A.ACCT_ID
     AND A1.ETL_DT = A.VALUE_DT
    /*20221104 许晓滨 ADD 区分保证金*/
    LEFT JOIN (SELECT BZJ.*,ROW_NUMBER()OVER(PARTITION BY BZJ.GRTEAC ORDER BY EXCHANGEDATE,EXCHANGETIME DESC) RN
                 FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO BZJ
                WHERE BZJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BZJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TRIM(BZJ.GRTEAC) IS NOT NULL) BZJ--解冻保证金申请详情
      ON BZJ.GRTEAC = A.CUST_ACCT_ID
     AND BZJ.RN  = 1
    LEFT JOIN (SELECT HT.*,ROW_NUMBER()OVER(PARTITION BY HT.CONT_ID ORDER BY HT.EXP_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO HT
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) HT
      ON HT.CONT_ID = BZJ.CONTRACTNO
     AND HT.RN = 1
   WHERE (SUBSTR(A.SUBJ_ID,1,4) IN ('2011','2002','2010','2005','3007')) --2005 财政存款 2011 吸收存款（个人 对公） 2002 保证金 3007 委托存款 --科目筛选  20220901 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /***存款分户信息-协定存款处理2***/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_ACC_SUB
    (DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ACC_ID                     --账户编号
    ,CUST_ID                    --客户编号
    ,ORG_ID                     --机构编号
    ,CUR                        --币种
    ,DEP_PROD_CD                --存款产品代码
    ,DEP_PROD_TYP               --存款产品类型
    ,VAL_DT                     --起息日期
    ,DEP_BAL                    --存款余额
    ,DEP_EXP_DT                 --存款到期日期
    ,CORP_IND_FLG               --对公对私标志
    ,SUBJ_ID                    --科目编号
    ,RATE                       --利率
    ,OPEN_ACC_DT                --开户日期
    ,OPEN_ACC_TLR_NO            --开户柜员号
    ,CNL_ACC_DT                 --销户日期
    ,DEP_ACC_STAT               --存款账户状态
    ,DEP_ACCT_STATUS_CD         --存款账户状态原码值
    ,LAST_ACC_CHG_DT            --上次动户日期
    ,CASH_REMIT_TYP             --钞汇类型
    ,AGRT_DEP_PSN_TYP           --协议存款人类型
    ,RATE_RE_PRC_DT             --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG    --内嵌提前到期期权标志
    ,ADV_DRAW_FLG               --可提前支取标志
    ,NTC_WD_DT                  --通知取款日期
    ,NTC_WD_AMT                 --通知取款金额
    ,CR_CRD_EX_PAY_FLG          --信用卡溢缴款标志
    ,PBL_INT                    --应付利息
    ,CO_DEP_TYP                 --单位存款类型
    ,DEP_INS_AMT                --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT            --有业务关系存款金额
    ,TD_APVL_ACC_FLG            --待核准账户标志
    ,INT_CALC_FLG               --计息标志
    ,SPCL_DEP_TYP               --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL     --委托贷款基金细类
    ,CONSR_TYP                  --委托人类型
    ,IND_DMD_DEP_ACC_TYP        --个人活期存款账户类型
    ,PBC_ACC_TYP                --人行账户类型
    ,TIME_DMD_FLG               --定活标志
    ,OPEN_ACC_CHAN              --开户渠道
    ,PRC_BASE_TYP               --定价基准类型
    ,RATE_TYP                   --利率类型
    ,BASE_RATE                  --基准利率
    ,RATE_FLT_FREQ              --利率浮动频率
    ,GUA_YLD                    --保底收益率
    ,HIGH_YLD_RTO               --最高收益率
    ,DIF_PLC_DEP_FLG            --异地存款标志
    ,DEP_RSV_MODE               --缴存准备金方式
    ,ACT_END_DT                 --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
    ,CRN_PRD_ACCRD_INT          --当期应计利息
    ,INTDAY_ACCRD_INT           --当日应计利息
    ,APPROVAL_ID                --核准件编号
    ,CORE_ACC_TYP               --客户类型
    ,SUB_ACC_ID                 --子账户编号
    ,ACC_ID_EAST                --账户编号_EAST
    ,EAR_M_BAL                  --月初余额
    ,NEXT_INT_SET_DT            --下次结息日期
    ,STD_PROD_ID                --标准产品代码
    ,DEP_TERM                   --存期
    ,IBANK_DEP_FLG              --同业存款标志
    ,AGREE_DEP_EXP_DT           --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG              --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT         --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT         --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT              --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT          --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD               --账户属性代码
    ,FROZ_FLG                   --冻结标志
    ,ACCT_CARD_NO               --客户账户卡号
    ,STOP_PAY_STATUS_CD         --止付状态代码
    ,FROZ_DT                    --冻结日期
    ,UNFRZ_DT                   --解冻日期
    ,INIT_OPEN_ACCT_DT          --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                --原始到期日期  add by hulj 20221227
    ,C_DEPOSIT_TYPE             --单位存款类型
    ,OVER_TERM_EXEC_INT_RAT     --超期执行利率
    ,ACCT_MED                   --账户介质
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')             AS DATA_DT                    --数据日期
        ,A.LP_ID                                   AS LGL_REP_ID                 --法人编号
        ,A.CUST_ACCT_ID                            AS ACC_ID                     --账户编号
        ,A.CUST_ID                                 AS CUST_ID                    --客户编号
        ,A.BELONG_ORG_ID                           AS ORG_ID                     --机构编号
        ,A.CURR_CD                                 AS CUR                        --币种                                                                                   --存款产品代码
        ,A.STD_PROD_ID                             AS DEP_PROD_CD                --存款产品代码 --modify by hulj
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN '0601'
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN '0602'
          END                                      AS DEP_PROD_TYP               --存款产品类型
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')            AS VAL_DT                     --起息日期
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN NVL(A.AGREE_DEP_INIT_AMT,0)
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN 0
          END                                      AS DEP_BAL                    --存款余额
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN TO_CHAR(A.AGREE_DEP_EXP_DT,'YYYYMMDD')
          END                                      AS DEP_EXP_DT                 --存款到期日期
        ,CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
              WHEN E.CUST_ID IS NOT NULL THEN '2'
          END                                      AS CORP_IND_FLG               --对公对私标志
        ,A.SUBJ_ID                                 AS SUBJ_ID                    --科目编号
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN A.EXEC_INT_RAT  --执行利率
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN A.AGREE_INT_RAT --协定利率 --MDF BY TYJ 20220609 协定户部分利率取协定利率
          END                                      AS RATE                       --利率
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN TO_CHAR(A.AGREE_DEP_VALUE_DT,'YYYYMMDD')
          END                                      AS OPEN_ACC_DT                --开户日期
        ,TRIM(A.OPEN_ACCT_TELLER_ID)               AS OPEN_ACC_TLR_NO            --开户柜员号
        ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231') THEN '99991231'
              ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
          END                                      AS CNL_ACC_DT                 --销户日期
        ,NVL(TTA.TAR_VALUE_CODE,'99')              AS DEP_ACC_STAT               --存款账户状态
        ,A.DEP_ACCT_STATUS_CD                      AS DEP_ACCT_STATUS_CD         --存款账户状态原码值
        ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD') AS LAST_ACC_CHG_DT            --上次动户日期
        ,CASE WHEN A.EC_FLG = 'CA' THEN '02'--钞
              WHEN A.EC_FLG = 'TT' THEN '03'--汇
          END                                      AS CASH_REMIT_TYP             --钞汇类型
        ,G.AGT_DEP_TYPE_CD                         AS AGRT_DEP_PSN_TYP           --协议存款人类型
        ,NULL                                      AS RATE_RE_PRC_DT             --利率重新定价日期
        ,NULL                                      AS INNR_ADV_EXP_OPTION_FLG    --内嵌提前到期期权标志
        ,A.ADVD_DRAW_FLG                           AS ADV_DRAW_FLG               --可提前支取标志
        ,NULL                                      AS NTC_WD_DT                  --通知取款日期
        ,NULL                                      AS NTC_WD_AMT                 --通知取款金额
        ,NULL                                      AS CR_CRD_EX_PAY_FLG          --信用卡溢缴款标志
        ,NVL(A.CURRT_ACRU_INT,0)+NVL(A.CURRT_INT_PAYBL_ADJ,0) AS PBL_INT         --应付利息 --当期应计利息+当期应付利息调整
        ,CASE WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN (/*'1'*/'11','JJSB') THEN 'C' --社保 --基金社保 --MOD BY YJY 20250928 旧的1-社保基金-债券质押改为11-社保基金-债券质押
              WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN (/*'2'*/'12','GJJ') THEN 'E' --住房公积金 --暂无公积金 --MOD BY YJY 20250928 旧的2-社保基金-非债券质押改为12-社保基金-非债券质押
              WHEN SUBSTR(A.SUBJ_ID,1,4) IN ('2005','2010','3008') THEN 'F' --财政性存款 --2022/07/16 XUXIAOBIN MODIFY
              WHEN E.CUST_ID IS NOT NULL THEN 'A' --企业存款
          END                                      AS CO_DEP_TYP                 --单位存款类型 --20220920xuxiaobinadd
        ,NULL                                      AS DEP_INS_AMT                --被存款保险制度覆盖的金额
        ,NULL                                      AS BIZ_REL_DEP_AMT            --有业务关系存款金额
        ,NULL                                      AS TD_APVL_ACC_FLG            --待核准账户标志
        ,A.INT_ACCR_FLG                            AS INT_CALC_FLG               --计息标志
        ,NULL                                      AS SPCL_DEP_TYP               --专项存款类型
        ,CASE WHEN A.SUBJ_ID LIKE '30070101%' --委托存款
              THEN '9012'
          END                                      AS ENTRS_LOAN_FUND_SUM_CL     --委托贷款基金细类
        ,NULL                                      AS CONSR_TYP                  --委托人类型
        ,CASE WHEN A.ACCT_TYPE_CD IN ('1','2','3') THEN A.ACCT_TYPE_CD
              ELSE C.TAR_VALUE_CODE
          END                                      AS IND_DMD_DEP_ACC_TYP        --个人活期存款账户类型
        ,A.ACCT_CLS_CD                             AS PBC_ACC_TYP                --人行账户类型
        ,A.RC_FLG                                  AS TIME_DMD_FLG               --定活标志
        ,A.OPEN_ACCT_CHN_TYPE_CD                   AS OPEN_ACC_CHAN              --开户渠道
        ,'TR09'                                    AS PRC_BASE_TYP               --定价基准类型 默认TR09：存款基准利率
        /*,CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
              ELSE '0' --浮动利率
          END                                      AS RATE_TYP                   --利率类型*/
        ,'1'                                       AS RATE_TYP                   --利率类型 默认固定利率
        ,A.BASE_RAT                                AS BASE_RATE                  --基准利率
        ,'00'                                      AS RATE_FLT_FREQ              --利率浮动频率 固定利率不浮动
        ,NULL                                      AS GUA_YLD                    --保底收益率
        ,A.EXPE_HIGT_YLD_RAT                       AS HIGH_YLD_RTO               --最高收益率
        ,NULL                                      AS DIF_PLC_DEP_FLG            --异地存款标志
        ,'DR03'                                    AS DEP_RSV_MODE               --缴存准备金方式
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              AS ACT_END_DT                 --实际终止日期
        --,TO_CHAR(A1.EXEC_INT_RAT,'YYYYMMDD')       AS BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
        ,A1.EXEC_INT_RAT                           AS BIZ_OCCUR_TMPNT_ACT_RATE   --业务发生时点实际利率
        --,TO_CHAR(A1.VALUE_DT,'YYYYMMDD')           AS BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
        ,A1.BASE_RAT                               AS BIZ_TMPNT_BASE_RATE        --业务发生时点基准利率
        ,NULL                                      AS DEPT_LINE                  --部门条线 --计划财务部
        ,'存款分户-协定户活期部分'                 AS DATA_SRC                   --数据来源
        ,A.CURRT_ACRU_INT                          AS CRN_PRD_ACCRD_INT          --当期应计利息
        ,A.TD_ACRU_INT                             AS INTDAY_ACCRD_INT           --当日应计利息
        ,A.APPROVAL_ID                             AS APPROVAL_ID                --核准件编号
        ,A.CUST_TYPE_CD                            AS CORE_ACC_TYP               --客户类型
        --,NVL(A.OLD_CUST_ACCT_SUB_ACCT_NUM,A.CUST_ACCT_SUB_ACCT_NUM) AS SUB_ACC_ID --子账户编号
        ,CASE WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) > 0 THEN 'XD2'
              WHEN A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT,0) < 0 THEN 'XD1'
          END                                      AS SUB_ACC_ID                 --子账户编号20221102 XUXIAOBIN业务希望用回以前的
        ,A.ACCT_ID                                 AS ACC_ID_EAST                --账户编号_EAST
        ,A.EAR_M_BAL                               AS EAR_M_BAL                  --月初余额
        ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')     AS NEXT_INT_SET_DT            --下次结息日期
        ,A.STD_PROD_ID                             AS STD_PROD_ID                --标准产品代码
        ,CASE WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('1Y','12M','365D') THEN '301' --一年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('2Y','24M','730D') THEN '302' --二年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('3Y','24M','1095D') THEN '303' --三年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('5Y','60M') THEN '305' --五年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('6Y','72M') THEN '306' --六年
              WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD IN ('8Y','96M') THEN '308' --8年
              ELSE '999'
          END                                      AS DEP_TERM                   --存期
        ,A.IBANK_DEP_FLG                           AS IBANK_DEP_FLG              --同业存款标志
        ,TO_CHAR(A.AGREE_DEP_EXP_DT,'YYYYMMDD')    AS AGREE_DEP_EXP_DT           --协定存款到期日期(金数IMAS用)20221031 ADD
        ,A.AGREE_DEP_FLG                           AS AGREE_DEP_FLG              --协定存款标志(金数IMAS用)20221031 ADD
        ,A.AGREE_DEP_INIT_AMT                      AS AGREE_DEP_INIT_AMT         --协定存款起存金额(金数IMAS用)20221031 ADD
        ,TO_CHAR(A.AGREE_DEP_VALUE_DT,'YYYYMMDD')  AS AGREE_DEP_VALUE_DT         --协定存款起息日期(金数IMAS用)20221031 ADD
        ,A.AGREE_INT_RAT                           AS AGREE_INT_RAT              --协定利率(金数IMAS用)20221031 ADD
        ,TO_CHAR(A.AGREE_DEP_RELS_DT,'YYYYMMDD')   AS AGREE_DEP_RELS_DT          --协定存款解约日期(金数IMAS用)20221031 ADD
        ,G.FX_ACCT_CHAR_CD                         AS ACCT_CHAR_CD               --账户属性代码
        ,A.FROZ_FLG                                AS FROZ_FLG                   --冻结标志
        ,A.CUST_ACCT_CARD_NO                       AS ACCT_CARD_NO               --客户账户卡号
        ,A.STOP_PAY_STATUS_CD                      AS STOP_PAY_STATUS_CD         --止付状态代码
        ,TO_CHAR(A.FROZ_DT,'YYYYMMDD')             AS FROZ_DT                    --冻结日期
        ,TO_CHAR(A.UNFRZ_DT,'YYYYMMDD')            AS UNFRZ_DT                   --解冻日期
        ,TO_CHAR(G.INIT_OPEN_ACCT_DT,'YYYYMMDD')   AS INIT_OPEN_ACCT_DT          --原始开户日期  add by hulj 20221227
        ,TO_CHAR(G.INIT_EXP_DT,'YYYYMMDD')         AS INIT_EXP_DT                --原始到期日期  add by hulj 20221227
        ,CASE WHEN E.DEPOSITR_CATE_CD = '101' THEN 'A' --企业法人
              WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN ('CZCK','-',/*'3','4'*/'21','22','31','32') THEN 'B' --103 机关 3-其他财政性存款 4-其他
              --MOD BY YJY 20250928 旧的3-住房公积金、4-其他财政性存款改为21-住房公积金-债券质押、22-住房公积金-非债券质押、31-其他财政性存款-债券质押、32-其他财政性存款-非债券质押
              WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN (/*'1'*/'11','JJSB') THEN 'C' --'JJSB' 基金社保 1-社保基金
              --MOD BY YJY 20250928 修改存款性质代码，旧的1-社保基金-债券质押改为11-社保基金-债券质押
              WHEN E.DEPOSITR_CATE_CD IN ('106','107') THEN 'D'
              WHEN A.DEP_CHAR_CD IN (/*'2'*/'12','GJJ') THEN 'E' --2-公积金 --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
              --MOD BY YJY 20250928 修改存款性质代码，旧的2-社保基金-非债券质押改为12-社保基金-非债券质押
              WHEN E.CUST_ID IS NOT NULL THEN 'A'
          END                                      AS C_DEPOSIT_TYPE             --单位存款类型
        ,A.OVER_TERM_EXEC_INT_RAT                  AS OVER_TERM_EXEC_INT_RAT     --超期执行利率
        ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6' --A存单
              WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5' --B折或一本通
              --WHEN H.VOUCH_FORM_CD = 'C' THEN '2' --C贷记卡 华兴无贷记卡
              WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1' --D借记卡
              WHEN H.VOUCH_FORM_CD IN('CHQ','CHK') THEN '4' --E支票
              ELSE '9' --其他
          END                                      AS ACCT_MED                   --账户介质
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO G --存款账户附加信息
      ON G.ACCT_ID = A.ACCT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO H --存款主账户信息
      ON H.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP C --码值映射表
      ON C.SRC_VALUE_CODE = A.STD_PROD_ID
     AND C.SRC_CLASS_CODE = 'STD0001'
     AND C.TAR_CLASS_CODE = 'T0015'
     AND C.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基础信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A1 --存款分户信息 取业务发生时点基准利率
      ON A1.ACCT_ID = A.ACCT_ID
     AND A1.ETL_DT = A.VALUE_DT
    /*20221104 许晓滨 ADD 区分保证金*/
    LEFT JOIN (SELECT BZJ.*,ROW_NUMBER()OVER(PARTITION BY BZJ.GRTEAC ORDER BY EXCHANGEDATE,EXCHANGETIME DESC) RN
                 FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO BZJ
                WHERE BZJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BZJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TRIM(BZJ.GRTEAC) IS NOT NULL) BZJ--解冻保证金申请详情
      ON BZJ.GRTEAC = A.CUST_ACCT_ID
     AND BZJ.RN  = 1
    LEFT JOIN (SELECT HT.*,ROW_NUMBER()OVER(PARTITION BY HT.CONT_ID ORDER BY HT.EXP_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO HT
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) HT
      ON HT.CONT_ID = BZJ.CONTRACTNO
     AND HT.RN = 1
   WHERE A.AGREE_DEP_FLG = '1' --仅处理协定存款
     AND NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
     AND (SUBSTR(A.SUBJ_ID,1,4) IN ('2011')) --科目筛选  20220901 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT,NVL(T.ACCT_CARD_NO,T.ACC_ID)||T.SUB_ACC_ID,T.ACC_ID,COUNT(1)
      FROM RRP_MDL.M_DEP_ACC_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,NVL(T.ACCT_CARD_NO,T.ACC_ID)||T.SUB_ACC_ID,T.ACC_ID
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
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_M_DEP_ACC_SUB;
/

