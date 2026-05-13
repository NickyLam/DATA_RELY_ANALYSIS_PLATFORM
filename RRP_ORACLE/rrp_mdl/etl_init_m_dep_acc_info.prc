CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_DEP_ACC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_DEP_ACC_INFO
  *  功能描述：监管集市银行所有存款账户信息，包括个人、对公、活期、定期
  *  创建日期：202205223
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_DEP_ACCT_INFO   --存款分户信息
  *            ICL.CMM_IFS_ACCT_INFO       --联合存款分户信息
  *  目标表：  M_DEP_ACC_INFO  --存款账户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220901  许晓滨   科目调整，与旧监管不同。
  *             2    20221031  许晓滨   新增字段，协定存款模式不做拆分
  *             3    20221102  hulj     存款产品代码调整取值
  *             4    20221114  hulj     增加数据重复校验
  *             5    20221227  hulj     新增字段原始开户日期、原始到期日期
  *             6    20230104  hulj     调整保证金类别取值口径
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_DEP_ACC_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
 V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_DEP_ACC_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

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

 /* --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '存款账户信息';
  V_STARTTIME := SYSDATE;

  /***存款分户信息***/
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_ACC_INFO
  (
     DATA_DT                                  --数据日期
    ,LGL_REP_ID                               --法人编号
    ,ACC_ID                                   --账户编号
    ,CUST_ID                                  --客户编号
    ,ORG_ID                                   --机构编号
    ,CUR                                      --币种
    ,DEP_PROD_CD                              --存款产品代码
    ,DEP_PROD_TYP                             --存款产品类型
    ,VAL_DT                                   --起息日期
    ,DEP_BAL                                  --存款余额
    ,DEP_EXP_DT                               --存款到期日期
    ,CORP_IND_FLG                             --对公对私标志
    ,SUBJ_ID                                  --科目编号
    ,RATE                                     --利率
    ,OPEN_ACC_DT                              --开户日期
    ,OPEN_ACC_TLR_NO                          --开户柜员号
    ,CNL_ACC_DT                               --销户日期
    ,DEP_ACC_STAT                             --存款账户状态
    ,DEP_ACCT_STATUS_CD                       --存款账户状态原码值
    ,LAST_ACC_CHG_DT                          --上次动户日期
    ,CASH_REMIT_TYP                           --钞汇类型
    ,AGRT_DEP_PSN_TYP                         --协议存款人类型
    ,RATE_RE_PRC_DT                           --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG                  --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                             --可提前支取标志
    ,NTC_WD_DT                                --通知取款日期
    ,NTC_WD_AMT                               --通知取款金额
    ,CR_CRD_EX_PAY_FLG                        --信用卡溢缴款标志
    ,PBL_INT                                  --应付利息
    ,CO_DEP_TYP                               --单位存款类型
    ,DEP_INS_AMT                              --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                          --有业务关系存款金额
    ,TD_APVL_ACC_FLG                          --待核准账户标志
    ,INT_CALC_FLG                             --计息标志
    ,SPCL_DEP_TYP                             --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL                   --委托贷款基金细类
    ,CONSR_TYP                                --委托人类型
    ,IND_DMD_DEP_ACC_TYP                      --个人活期存款账户类型
    ,PBC_ACC_TYP                              --人行账户类型
    ,TIME_DMD_FLG                             --定活标志
    ,OPEN_ACC_CHAN                            --开户渠道
    ,PRC_BASE_TYP                             --定价基准类型
    ,RATE_TYP                                 --利率类型
    ,BASE_RATE                                --基准利率
    ,RATE_FLT_FREQ                            --利率浮动频率
    ,GUA_YLD                                  --保底收益率
    ,HIGH_YLD_RTO                             --最高收益率
    ,DIF_PLC_DEP_FLG                          --异地存款标志
    ,DEP_RSV_MODE                             --缴存准备金方式
    ,ACT_END_DT                               --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE                 --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                      --业务发生时点基准利率
    ,DEPT_LINE                                --部门条线
    ,DATA_SRC                                 --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                               --子账户编号
    ,ACC_ID_EAST                              --账户编号_EAST
    ,EAR_M_BAL                                --月初余额
    ,NEXT_INT_SET_DT                          --下次结息日期
    ,STD_PROD_ID                              --标准产品代码
    ,DEP_TERM                                 --存期
    ,IBANK_DEP_FLG                            --同业存款标志
    ,AGREE_DEP_EXP_DT                         --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG                            --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT                       --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT                       --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT                            --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT                        --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD                             --账户属性代码
    ,FROZ_FLG                                 --冻结标志
    ,ACCT_CARD_NO                             --客户账户卡号
    ,STOP_PAY_STATUS_CD                       --止付状态代码
    ,FROZ_DT                                  --冻结日期
    ,UNFRZ_DT                                 --解冻日期
    ,INIT_OPEN_ACCT_DT                        --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                              --原始到期日期  add by hulj 20221227
    ,C_DEPOSIT_TYPE                           --单位存款类型
    ,OVER_TERM_EXEC_INT_RAT                   --超期执行利率
    ,ACCT_MED                                 --账户介质
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
   )
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')  AS DATA_DT                                     --数据日期
   ,A.LP_ID                        AS LGL_REP_ID                                  --法人编号
   ,A.CUST_ACCT_ID                 AS ACC_ID                                      --账户编号
   ,A.CUST_ID                      AS CUST_ID                                     --客户编号
   ,A.BELONG_ORG_ID                AS ORG_ID                                      --机构编号
   ,A.CURR_CD                      AS CUR                                         --币种                                                                                   --存款产品代码
   ,A.STD_PROD_ID                  AS DEP_PROD_CD                                 --存款产品代码 --modify by hulj
   ,CASE WHEN /*20230104 XUXIAOBIN ADD 保证金类别*/
          SUBSTR(HT.STD_PROD_ID,1,5) = '60101' AND A.SUBJ_ID LIKE '2002%' THEN '0701'--银行承兑汇票保证金
          WHEN SUBSTR(HT.STD_PROD_ID,1,5) = '60103' AND A.SUBJ_ID LIKE '2002%' THEN '0703'--保函保证金
          WHEN SUBSTR(HT.STD_PROD_ID,1,5) = '60102' AND A.SUBJ_ID LIKE '2002%' THEN '0702'--信用证保证金
          WHEN A.SUBJ_ID LIKE '2002%' THEN '0799' --其他保证金
          /*CASE WHEN --mod by hulj 20230104 保证金类别
          BZJ.BUSINESSTYPE = '601010100001' AND A.SUBJ_ID LIKE '2002%' THEN '0701'--银行承兑汇票保证金
          WHEN BZJ.BUSINESSTYPE IN('601030100001','601030100007','601030200001') AND A.SUBJ_ID LIKE '2002%' THEN '0703'--保函保证金
          WHEN BZJ.BUSINESSTYPE IN('601020100001','601020100002','601020200001','601020200002') AND A.SUBJ_ID LIKE '2002%' THEN '0702'--信用证保证金
          WHEN A.SUBJ_ID LIKE '2002%' THEN '0799' --其他保证金*/
          WHEN
          A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
          AND A.AGREE_DEP_FLG LIKE '1'
          AND NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
          AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) <= 0
          THEN '0601'            --结算户存款
        /* WHEN A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
          AND  A.ACCT_CLS_CD IN ('11001','11002','11003','11004','21001','22002')
         --基本存款账户,一般存款账户,临时存款账户,专用存款账户,个人人民币结算账户,个人外汇结算账户
          AND  A.AGREE_DEP_FLG = '1'  --ADD BY 20221124 xucx
         THEN '0601' --结算户存款   MODIFY BY MW 20221118*/
   /*      WHEN A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
         AND  A.AGREE_DEP_FLG = '1'
         THEN '0602' --协定户存款*/
         WHEN A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
         AND A.AGREE_DEP_FLG LIKE '1'
         AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
         AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
         THEN '0602'            --协定户存款
         ELSE NVL(C.TAR_VALUE_CODE,A.STD_PROD_ID)
         END                       AS DEP_PROD_TYP                               --存款产品类型
   ,TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS VAL_DT                                     --起息日期
   ,A.CURRT_BAL                    AS DEP_BAL                                    --存款余额
   ,TO_CHAR(A.EXP_DT,'YYYYMMDD')   AS DEP_EXP_DT                                 --存款到期日期
   ,CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
      WHEN E.CUST_ID IS NOT NULL THEN '2'
         END                       AS CORP_IND_FLG                                --对公对私标志
   ,A.SUBJ_ID                      AS SUBJ_ID                                     --科目编号
   ,NVL(A.EXEC_INT_RAT, 0)         AS RATE                                        --利率
   ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')  AS OPEN_ACC_DT                           --开户日期
   ,TRIM(A.OPEN_ACCT_TELLER_ID)          AS OPEN_ACC_TLR_NO                       --开户柜员号
   ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231')
         THEN '99991231'
       ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
          END                            AS CNL_ACC_DT                            --销户日期
   ,NVL(TTA.TAR_VALUE_CODE,'99')         AS DEP_ACC_STAT                          --存款账户状态
   ,A.DEP_ACCT_STATUS_CD                 AS DEP_ACCT_STATUS_CD                    --存款账户状态原码值
   ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT, 'YYYYMMDD')  AS LAST_ACC_CHG_DT                --上次动户日期
   ,CASE WHEN A.EC_FLG = 'CA' THEN '02'--钞
         WHEN A.EC_FLG = 'TT' THEN '03'--汇
         END                              AS CASH_REMIT_TYP                       --钞汇类型
   ,G.AGT_DEP_TYPE_CD                     AS AGRT_DEP_PSN_TYP                     --协议存款人类型
   ,NULL                                  AS RATE_RE_PRC_DT                       --利率重新定价日期
   ,NULL                                  AS INNR_ADV_EXP_OPTION_FLG              --内嵌提前到期期权标志
   ,A.ADVD_DRAW_FLG                       AS ADV_DRAW_FLG                         --可提前支取标志
   ,NULL                                  AS NTC_WD_DT                            --通知取款日期
   ,NULL                                  AS NTC_WD_AMT                           --通知取款金额
   ,NULL                                  AS CR_CRD_EX_PAY_FLG                    --信用卡溢缴款标志
   ,NVL(A.CURRT_ACRU_INT,0)+NVL(A.CURRT_INT_PAYBL_ADJ,0) --当期应计利息+当期应付利息调整
                                          AS PBL_INT                              --应付利息
   ,CASE
               WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN ('1','JJSB')--基金社保
               THEN 'C' --社保
               WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN( '2','GJJ') --暂无公积金
               THEN 'E'   --住房公积金
               WHEN SUBSTR(A.SUBJ_ID,1,4) IN ( '2005' , '2010' ,'3008') --2022/07/16 XUXIAOBIN MODIFY
               THEN 'F'   --财政性存款
               WHEN E.CUST_ID IS NOT NULL THEN 'A'    --企业存款
        END                               AS CO_DEP_TYP                           --单位存款类型 --20220920xuxiaobinadd
   ,NULL                                  AS DEP_INS_AMT                          --被存款保险制度覆盖的金额
   ,NULL                                  AS BIZ_REL_DEP_AMT                      --有业务关系存款金额
   ,NULL                                  AS TD_APVL_ACC_FLG                      --待核准账户标志
   ,A.INT_ACCR_FLG                        AS INT_CALC_FLG                         --计息标志
   ,NULL                                  AS SPCL_DEP_TYP                         --专项存款类型
   ,CASE WHEN A.SUBJ_ID LIKE '30070101%' --委托存款
         THEN '9012'
    END                                   AS ENTRS_LOAN_FUND_SUM_CL               --委托贷款基金细类
   ,NULL                                  AS CONSR_TYP                            --委托人类型
   ,CASE WHEN A.ACCT_TYPE_CD IN ('1','2','3') THEN A.ACCT_TYPE_CD
   ELSE C.TAR_VALUE_CODE END              AS IND_DMD_DEP_ACC_TYP                  --个人活期存款账户类型
   ,A.ACCT_CLS_CD                         AS PBC_ACC_TYP                          --人行账户类型
   ,A.RC_FLG                              AS TIME_DMD_FLG                         --定活标志
   ,A.OPEN_ACCT_CHN_TYPE_CD               AS OPEN_ACC_CHAN                        --开户渠道
   ,'TR09'                                AS PRC_BASE_TYP                         --定价基准类型 默认TR09：存款基准利率
   ,/*CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
         ELSE '0' --浮动利率
         END*/
   '1'                                       AS RATE_TYP                          --利率类型 默认固定利率
   ,A.BASE_RAT                               AS BASE_RATE                         --基准利率
   ,'00'                                     AS RATE_FLT_FREQ                     --利率浮动频率 固定利率不浮动
   ,NULL                                     AS GUA_YLD                           --保底收益率
   ,A.EXPE_HIGT_YLD_RAT                      AS HIGH_YLD_RTO                      --最高收益率
   ,NULL                                     AS DIF_PLC_DEP_FLG                   --异地存款标志
   ,'DR03'                                   AS DEP_RSV_MODE                      --缴存准备金方式
   ,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS ACT_END_DT                        --实际终止日期
   --,TO_CHAR(A1.EXEC_INT_RAT,'YYYYMMDD')                                         --业务发生时点实际利率
   ,A1.EXEC_INT_RAT                          AS BIZ_OCCUR_TMPNT_ACT_RATE          --业务发生时点实际利率
   --,TO_CHAR(A1.VALUE_DT,'YYYYMMDD')                                             --业务发生时点基准利率
   ,A1.BASE_RAT                              AS BIZ_TMPNT_BASE_RATE               --业务发生时点基准利率
   ,NULL                                     AS DEPT_LINE                         --部门条线 --计划财务部
   ,'普通存款'                                AS DATA_SRC                          --数据来源
   ,A.CURRT_ACRU_INT                         AS CRN_PRD_ACCRD_INT                 --当期应计利息
   ,A.TD_ACRU_INT                            AS INTDAY_ACCRD_INT                  --当日应计利息
   ,A.approval_id                            AS APPROVAL_ID                       --核准件编号
   ,A.CUST_TYPE_CD                           AS CUST_TYP                          --客户类型
   ,NVL(A.OLD_CUST_ACCT_SUB_ACCT_NUM,A.CUST_ACCT_SUB_ACCT_NUM)             AS SUB_ACC_ID                        --子账户编号20221102 XUXIAOBIN业务希望用回以前的
   ,A.ACCT_ID                                AS ACC_ID_EAST                       --账户编号_EAST
   ,A.EAR_M_BAL                              AS EAR_M_BAL                         --月初余额
   ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')    AS NEXT_INT_SET_DT                   --下次结息日期
   ,A.STD_PROD_ID                            AS STD_PROD_ID                       --标准产品代码
   ,CASE WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('1Y','12M','365D')
         THEN '301' --一年
         WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('2Y','24M','730D')
         THEN '302' --二年
         WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('3Y','24M','1095D')
         THEN '303' --三年
         WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('5Y','60M')
         THEN '305' --五年
         WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('6Y','72M')
         THEN '306' --六年
         WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('8Y','96M')
         THEN '308' --8年
         ELSE '999'
         END                                   AS DEP_TERM           --存期
   ,A.IBANK_DEP_FLG                            AS IBANK_DEP_FLG      --同业存款标志
   ,TO_CHAR(A.AGREE_DEP_EXP_DT, 'YYYYMMDD')    AS AGREE_DEP_EXP_DT   --协定存款到期日期(金数IMAS用)20221031 ADD
   ,A.AGREE_DEP_FLG                            AS AGREE_DEP_FLG      --协定存款标志(金数IMAS用)20221031 ADD
   ,A.AGREE_DEP_INIT_AMT                       AS AGREE_DEP_INIT_AMT --协定存款起存金额(金数IMAS用)20221031 ADD
   ,TO_CHAR(A.AGREE_DEP_VALUE_DT, 'YYYYMMDD')  AS AGREE_DEP_VALUE_DT --协定存款起息日期(金数IMAS用)20221031 ADD
   ,A.AGREE_INT_RAT                            AS AGREE_INT_RAT      --协定利率(金数IMAS用)20221031 ADD
   ,TO_CHAR(A.AGREE_DEP_RELS_DT,'YYYYMMDD')    AS AGREE_DEP_RELS_DT  --协定存款解约日期(金数IMAS用)20221031 ADD
   ,G.FX_ACCT_CHAR_CD                          AS ACCT_CHAR_CD       --账户属性代码
   ,A.FROZ_FLG                                 AS FROZ_FLG           --冻结标志
   ,A.CUST_ACCT_CARD_NO                        AS ACCT_CARD_NO       --客户账户卡号
   ,A.STOP_PAY_STATUS_CD                       AS STOP_PAY_STATUS_CD --止付状态代码
   ,TO_CHAR(A.FROZ_DT,'YYYYMMDD')              AS FROZ_DT            --冻结日期
   ,TO_CHAR(A.UNFRZ_DT,'YYYYMMDD')             AS UNFRZ_DT           --解冻日期
   ,TO_CHAR(G.INIT_OPEN_ACCT_DT,'YYYYMMDD')   AS INIT_OPEN_ACCT_DT  --原始开户日期  add by hulj 20221227
   ,TO_CHAR(G.INIT_EXP_DT,'YYYYMMDD')         AS INIT_EXP_DT        --原始到期日期  add by hulj 20221227
   ,CASE WHEN E.DEPOSITR_CATE_CD = '101'   --企业法人
               THEN 'A'
               WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN ('CZCK','-','3','4')  --103 机关 3-其他财政性存款 4-其他
               THEN 'B'
               WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN ('1','JJSB')   --'JJSB' 基金社保 1-社保基金
               THEN 'C'
               WHEN E.DEPOSITR_CATE_CD IN ('106', '107')
               THEN 'D'
               WHEN A.DEP_CHAR_CD IN( '2','GJJ') -- 2-公积金
               THEN 'E'   --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
               WHEN E.CUST_ID IS NOT NULL THEN 'A'

          END                                    AS C_DEPOSIT_TYPE
    ,A.OVER_TERM_EXEC_INT_RAT                   --超期执行利率
    ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6'  -- A存单
          WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5'  -- B折或一本通
        --WHEN H.VOUCH_FORM_CD = 'C' THEN '2'  -- C贷记卡 华兴无贷记卡
          WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1'  -- D借记卡
          WHEN H.VOUCH_FORM_CD IN('CHQ','CHK') THEN '4'  -- E支票
          ELSE '9'                             -- 其他
          END                                                              --账户介质
     ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1' ELSE '0' END AS LG_FROZ_FLG --司法冻结标志
     ,A.CUST_ACCT_SUB_ACCT_NUM AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A  --存款分户信息
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.BELONG_ORG_ID = B.ORG_ID
    AND A.ETL_DT = B.ETL_DT
  LEFT JOIN O_ICL_CMM_DEP_ACCT_ATTACH_INFO   G  --存款账户附加信息
    ON G.ACCT_ID = A.ACCT_ID
   AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN O_ICL_CMM_DEP_CUST_ACCT_INFO     H  --存款主账户信息
    ON A.CUST_ACCT_ID = H.CUST_ACCT_ID
   AND A.ETL_DT = H.ETL_DT
  LEFT JOIN RRP_MDL.CODE_MAP C  --码值映射表
    ON A.STD_PROD_ID = C.SRC_VALUE_CODE
    AND C.SRC_CLASS_CODE ='STD0001'
    AND C.TAR_CLASS_CODE = 'T0015'
    AND C.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
    ON A.CUST_ID = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E  --对公客户基础信息
    ON A.CUST_ID = E.CUST_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN CODE_MAP  TTA --账户状态转码
       ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
       AND TTA.SRC_CLASS_CODE = 'CD2554'
       AND TTA.TAR_CLASS_CODE = 'Z0018'
       AND TTA.MOD_FLG = 'MDM'
  LEFT JOIN O_ICL_CMM_DEP_ACCT_INFO A1  --存款分户信息 取业务发生时点基准利率
       ON A1.ACCT_ID = A.ACCT_ID
       AND A1.ETL_DT = A.VALUE_DT
  /*20221104 许晓滨 ADD 区分保证金*/
  LEFT JOIN
  (select BZJ.*,ROW_NUMBER()OVER(PARTITION BY BZJ.GRTEAC ORDER BY EXCHANGEDATE,EXCHANGETIME DESC)RN from
O_IOL_ICMS_DEPOSIT_APPLY_INFO BZJ
WHERE BZJ.START_DT <=TO_DATE(V_P_DATE,'YYYYMMDD')
AND BZJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
AND TRIM(BZJ.GRTEAC)  IS NOT NULL)  BZJ--解冻保证金申请详情
  ON BZJ.GRTEAC = A.CUST_ACCT_ID
 AND BZJ.RN  = 1
 LEFT JOIN
(SELECT HT.*,ROW_NUMBER()OVER(PARTITION BY HT.CONT_ID ORDER BY HT.EXP_DT DESC)RN FROM
O_ICL_CMM_CORP_LOAN_CONT_INFO HT
WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) HT
 ON BZJ.CONTRACTNO = HT.CONT_ID
 AND HT.RN = 1
/*LEFT JOIN O_ICL_CMM_BA_ACCT_INFO D --银承账户信息
 ON D.BILL_NUM = DG.BILL_NUM
 AND  D.ETL_DT = A.ETL_DT
LEFT JOIN O_ICL_CMM_LC_ACCT_INFO E --信用证账户信息
 ON E.LC_ID=DG.BILL_NUM
 AND E.ETL_DT = A.ETL_DT
LEFT JOIN O_ICL_CMM_LOG_ACCT_INFO F --保函账户信息
ON F.LOG_CONT_ID=DG.DUBIL_ID
 AND F.ETL_DT = A.ETL_DT*/

  LEFT JOIN (
    SELECT DISTINCT DEP_SUB_ACCT_ID
    FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
    WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD') AND FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
    AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
    AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')--冻结截止日期
  ) DJ
  ON A.ACCT_ID = DJ.DEP_SUB_ACCT_ID
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND  (SUBSTR(A.SUBJ_ID, 1, 4) IN ('2011', '2002', '2010','2005','3007') )
  or substr(a.subj_ID ,1,6)IN ('201404','201405') --2005  财政存款 2011  吸收存款（个人 对公） 2002  保证金  3007 委托存款
  --科目筛选  20220901 XUXIAOBIN MODIFY

       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
  ---记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户信息-联合存款信息';
  V_STARTTIME := SYSDATE;

  /***联合存款分户信息***/
  INSERT INTO RRP_MDL.M_DEP_ACC_INFO
  (
     DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,ACC_ID                             --账户编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,CUR                                --币种
    ,DEP_PROD_CD                        --存款产品代码
    ,DEP_PROD_TYP                       --存款产品类型
    ,VAL_DT                             --起息日期
    ,DEP_BAL                            --存款余额
    ,DEP_EXP_DT                         --存款到期日期
    ,CORP_IND_FLG                       --对公对私标志
    ,SUBJ_ID                            --科目编号
    ,RATE                               --利率
    ,OPEN_ACC_DT                        --开户日期
    ,OPEN_ACC_TLR_NO                    --开户柜员号
    ,CNL_ACC_DT                         --销户日期
    ,DEP_ACC_STAT                       --存款账户状态
    ,DEP_ACCT_STATUS_CD                 --存款账户状态原码值
    ,LAST_ACC_CHG_DT                    --上次动户日期
    ,CASH_REMIT_TYP                     --钞汇类型
    ,AGRT_DEP_PSN_TYP                   --协议存款人类型
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG            --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                       --可提前支取标志
    ,NTC_WD_DT                          --通知取款日期
    ,NTC_WD_AMT                         --通知取款金额
    ,CR_CRD_EX_PAY_FLG                  --信用卡溢缴款标志
    ,PBL_INT                            --应付利息
    ,CO_DEP_TYP                         --单位存款类型
    ,DEP_INS_AMT                        --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                    --有业务关系存款金额
    ,TD_APVL_ACC_FLG                    --待核准账户标志
    ,INT_CALC_FLG                       --计息标志
    ,SPCL_DEP_TYP                       --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL             --委托贷款基金细类
    ,CONSR_TYP                          --委托人类型
    ,IND_DMD_DEP_ACC_TYP                --个人活期存款账户类型
    ,PBC_ACC_TYP                        --人行账户类型
    ,TIME_DMD_FLG                       --定活标志
    ,OPEN_ACC_CHAN                      --开户渠道
    ,PRC_BASE_TYP                       --定价基准类型
    ,RATE_TYP                           --利率类型
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,GUA_YLD                            --保底收益率
    ,HIGH_YLD_RTO                       --最高收益率
    ,DIF_PLC_DEP_FLG                    --异地存款标志
    ,DEP_RSV_MODE                       --缴存准备金方式
    ,ACT_END_DT                         --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                --业务发生时点基准利率
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                          --子账户编号
    ,ACC_ID_EAST                         --账户编号_EAST
    ,EAR_M_BAL                           --月初余额
    ,NEXT_INT_SET_DT                     --下次结息日期
    ,STD_PROD_ID                         --标准产品编号
    ,DEP_TERM                            --存期
    ,IBANK_DEP_FLG                       --同业存款标志
    ,GD_PROV_INT_FLG                     --广东省内标志
    ,ACCT_CHAR_CD                        --账户属性代码
    ,FROZ_FLG                            --冻结标志
    ,ACCT_CARD_NO                        --客户账户卡号
    ,STOP_PAY_STATUS_CD                  --止付状态代码
    ,FROZ_DT                             --冻结日期
    ,UNFRZ_DT                            --解冻日期
    ,C_DEPOSIT_TYPE                      --大集中单位存款类型
    ,ACCT_MED                            --账户介质
    ,LG_FROZ_FLG                         --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM              --客户账户子户号_新一代
  )
  SELECT /*+use hash(A, B, C)*/
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                                --数据日期
   ,A.LP_ID                                                                                      --法人编号
   ,A.CUST_ACCT_ID                                                                               --账户编号
   ,A.CUST_ID                                                                                    --客户编号
   --,KK.ORG_ID1                                                                                   --机构编号
   ,A.OPEN_ACCT_ORG_ID                                                                             --机构编号
   ,A.CURR_CD                                                                                    --币种
   ,A.STD_PROD_ID                                                                                --存款产品代码 --modify by hulj  20221102
   ,NVL(C.TAR_VALUE_CODE,A.STD_PROD_ID)                                                          --存款产品类型
   ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                                               --起息日期
   ,A.CURRT_BAL                                                                                  --存款余额
   ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                                                 --存款到期日期
   ,/*DECODE(A.CORP_ACCT_FLG, '0', '1', '1', '2', A.CORP_ACCT_FLG)*/
   CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
      WHEN F.CUST_ID IS NOT NULL THEN '2' END                                                    --对公对私标志
   ,A.SUBJ_ID                                                                                    --科目编号
   ,NVL(A.EXEC_INT_RAT, 0)                                                                       --利率
   ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                                                          --开户日期
   ,TRIM(A.OPEN_ACCT_TELLER_ID)                                                                   --开户柜员号
   ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
         THEN '99991231'
       ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') END
   /*
    0  销户
    1  正常
    2  冻结
    -  未知
   */
   ,CASE WHEN A.DEP_ACCT_STATUS_CD = '1' THEN '01'
         WHEN A.DEP_ACCT_STATUS_CD = '2' THEN '04' --冻结
         WHEN A.DEP_ACCT_STATUS_CD = '0' THEN '02'
    ELSE '99' END                                                                                        --存款账户状态
   ,A.DEP_ACCT_STATUS_CD                                                                                 --存款账户状态原码值
   ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT, 'YYYYMMDD')                                                           --上次动户日期
   ,'01'                                                                                                  --钞汇类型
   ,'Z' --联合存款无协议存款                                                                               --协议存款人类型
   ,NULL                                                                                                 --利率重新定价日期
   ,NULL                                                                                                 --内嵌提前到期期权标志
   ,NULL                                                                                                 --可提前支取标志
   ,NULL                                                                                                 --通知取款日期
   ,NULL                                                                                                 --通知取款金额
   ,NULL                                                                                                 --信用卡溢缴款标志
   ,A.CURRT_ACRU_INT                                                                                     --应付利息
   ,CASE WHEN F.CUST_ID IS NOT NULL THEN 'A'  END--,'A'             MD BY 20221112 XUCX                  --单位存款类型
   ,NULL                                                                                                 --被存款保险制度覆盖的?
   ,NULL                                                                                                 --有业务关系存款金额
   ,NULL                                                                                                 --待核准账户标志
   ,NULL                                                                                                 --计息标志
   ,NULL                                                                                                 --专项存款类型
   ,NULL                                                                                                 --委托贷款基金细类
   ,NULL                                                                                                 --委托人类型
   ,CASE WHEN A.SAV_TYPE_CD = 'S01' THEN '9901'           --  2022/06/22 许晓滨 新增
    WHEN  A.SAV_TYPE_CD = 'S02' THEN '9902' END AS IND_DMD_DEP_ACC_TYP                                   --个人活期存款账户类型 其他+活期储蓄户
   ,'9901'                                                                                               --人行账户类型
   ,A.RC_FLG                                                                                             --定活标志
   ,A.OPEN_ACCT_CHN_CD                                                                                   --开户渠道
   ,'TR09'                                                                                               --定价基准类型 TR09 存款基准利率
   ,/*CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
         ELSE '0' --浮动利率
         END */
   '1'                                                                                                   --利率类型  --默认固定利率
   ,A.BASE_RAT                                                                                           --基准利率
   ,'00'--固定利率不浮动                                                                                  --利率浮动频率
   ,NULL                                                                                                 --保底收益率
   ,NULL                                                                                                 --最高收益率
   ,NULL                                                                                                 --异地存款标志
   ,'DR03'                                                                                               --缴存准备金方式
   ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')                                                                   --实际终止日期
   ,A1.EXEC_INT_RAT                                                                                      --业务发生时点实际利率
   ,A1.BASE_RAT                                                                                          --业务发生时点基准利率
   ,NULL                                                                                                 --部门条线
   ,'联合存款'                                                                                           --数据来源
   ,NULL
   ,NULL
   ,NULL
   ,NULL
   ,A.CUST_ACCT_SUB_ACCT_NUM                                                                            --子账户编号
   ,A.CUST_ACCT_ID || A.CUST_ACCT_SUB_ACCT_NUM         AS ACC_ID_EAST                                   --账户编号_EAST
   ,A.EAR_M_BAL                                        AS EAR_M_BAL                                     --月初余额
   ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')              AS NEXT_INT_SET_DT                               --下次结息日期
   ,A.STD_PROD_ID                                      AS STD_PROD_ID                                   --标准产品编号
   ,A.DEP_TERM                                         AS DEP_TERM                                      --存期
   ,'0'                                                AS IBANK_DEP_FLG                                 --同业存款标志
   ,T.GD_PROV_INT_FLG                                  AS GD_PROV_INT_FLG                               --广东省内标志
   ,G.FX_ACCT_CHAR_CD                                     AS ACCT_CHAR_CD                                  --账户属性代码
   ,A.FROZ_STATUS_CD                                   AS FROZ_FLG                                      --冻结标志
   ,A.BIND_WEBANK_CARD_NO                              AS ACCT_CARD_NO                                  --客户账户卡号
   ,A.STOP_PAY_STATUS_CD                               AS STOP_PAY_STATUS_CD                            --止付状态代码
   ,NULL                                               AS FROZ_DT                                       --冻结日期
   ,NULL                                               AS UNFRZ_DT                                      --解冻日期
   ,CASE WHEN F.DEPOSITR_CATE_CD = '101'
         THEN 'A'
         WHEN F.DEPOSITR_CATE_CD = '103'
         THEN 'B'
        WHEN F.DEPOSITR_CATE_CD IN ('106', '107')
               THEN 'D'
        WHEN F.CUST_ID IS NOT NULL THEN 'A'  --MDF BY HAP 20210202只能是对公的有值，否则指标会统计个人部分的数据
          END                                          AS C_DEPOSIT_TYPE --大集中单位存款类型
   ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6'  -- A存单
          WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5'  -- B折或一本通
          --WHEN H.VOUCH_FORM_CD = 'C' THEN '2'  -- C贷记卡 华兴无贷记卡
          WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1'  -- D借记卡
          WHEN H.VOUCH_FORM_CD IN ('CHQ','CHK') THEN '4'  -- E支票
          ELSE '9'                             -- 其他
          END
   ,NULL AS LG_FROZ_FLG --司法冻结标志
   ,A.CUST_ACCT_SUB_ACCT_NUM AS  CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO A  --联合存款分户信息
  LEFT JOIN (SELECT TT.*,ROW_NUMBER()OVER(PARTITION BY TT.CUST_ID ORDER BY TT.WEBANK_CARD_NO) RN
  FROM RRP_MDL.O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL TT WHERE TT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T --微众存款账户IP核对明细
  ON A.BIND_WEBANK_CARD_NO = T.WEBANK_CARD_NO
  AND T.ETL_DT = A.ETL_DT
  AND T.RN = 1
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.ACCT_INSTIT_ID = B.ORG_ID
    AND A.ETL_DT = B.ETL_DT
   LEFT JOIN O_ICL_CMM_DEP_ACCT_ATTACH_INFO G --存款账户附加信息历史
       ON G.ACCT_ID = A.CUST_ACCT_ID
       AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN O_ICL_CMM_DEP_CUST_ACCT_INFO H --存款客户账户信息
      ON A.CUST_ACCT_ID = H.CUST_ACCT_ID
     AND A.ETL_DT = H.ETL_DT
  LEFT JOIN RRP_MDL.CODE_MAP C --数仓码值映射表
    ON A.STD_PROD_ID = C.SRC_VALUE_CODE
    AND C.SRC_CLASS_CODE ='STD0001'
    AND C.TAR_CLASS_CODE ='T0015'
    AND C.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
    ON A.CUST_ID = D.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F
    ON A.CUST_ID = F.CUST_ID
    AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
    ON E.CD_ID = 'CD1253' /*update by chenxl*/
    AND A.DEP_ACCT_STATUS_CD = E.CD_VAL
  LEFT JOIN O_ICL_CMM_IFS_ACCT_INFO A1 --联合存款分户信息 取业务发生时点基准利率和执行利率
       ON A.CUST_ACCT_ID = A1.CUST_ACCT_ID
       AND A1.ETL_DT = A.VALUE_DT
    WHERE
       A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       and A.SUBJ_ID IN ('2011010204','20110202');--20110210 个人互联网取到活期存款 20110202 个人定期存款

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  V_STEP := 6; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户信息-电子现金账户';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_ACC_INFO
  (
     DATA_DT                                  --数据日期
    ,LGL_REP_ID                               --法人编号
    ,ACC_ID                                   --账户编号
    ,CUST_ID                                  --客户编号
    ,ORG_ID                                   --机构编号
    ,CUR                                      --币种
    ,DEP_PROD_CD                              --存款产品代码
    ,DEP_PROD_TYP                             --存款产品类型
    ,VAL_DT                                   --起息日期
    ,DEP_BAL                                  --存款余额
    ,DEP_EXP_DT                               --存款到期日期
    ,CORP_IND_FLG                             --对公对私标志
    ,SUBJ_ID                                  --科目编号
    ,RATE                                     --利率
    ,OPEN_ACC_DT                              --开户日期
    ,OPEN_ACC_TLR_NO                          --开户柜员号
    ,CNL_ACC_DT                               --销户日期
    ,DEP_ACC_STAT                             --存款账户状态
    ,DEP_ACCT_STATUS_CD                       --存款账户状态原码值
    ,LAST_ACC_CHG_DT                          --上次动户日期
    ,CASH_REMIT_TYP                           --钞汇类型
    ,AGRT_DEP_PSN_TYP                         --协议存款人类型
    ,RATE_RE_PRC_DT                           --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG                  --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                             --可提前支取标志
    ,NTC_WD_DT                                --通知取款日期
    ,NTC_WD_AMT                               --通知取款金额
    ,CR_CRD_EX_PAY_FLG                        --信用卡溢缴款标志
    ,PBL_INT                                  --应付利息
    ,CO_DEP_TYP                               --单位存款类型
    ,DEP_INS_AMT                              --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                          --有业务关系存款金额
    ,TD_APVL_ACC_FLG                          --待核准账户标志
    ,INT_CALC_FLG                             --计息标志
    ,SPCL_DEP_TYP                             --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL                   --委托贷款基金细类
    ,CONSR_TYP                                --委托人类型
    ,IND_DMD_DEP_ACC_TYP                      --个人活期存款账户类型
    ,PBC_ACC_TYP                              --人行账户类型
    ,TIME_DMD_FLG                             --定活标志
    ,OPEN_ACC_CHAN                            --开户渠道
    ,PRC_BASE_TYP                             --定价基准类型
    ,RATE_TYP                                 --利率类型
    ,BASE_RATE                                --基准利率
    ,RATE_FLT_FREQ                            --利率浮动频率
    ,GUA_YLD                                  --保底收益率
    ,HIGH_YLD_RTO                             --最高收益率
    ,DIF_PLC_DEP_FLG                          --异地存款标志
    ,DEP_RSV_MODE                             --缴存准备金方式
    ,ACT_END_DT                               --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE                 --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                      --业务发生时点基准利率
    ,DEPT_LINE                                --部门条线
    ,DATA_SRC                                 --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                               --子账户编号
    ,ACC_ID_EAST                              --账户编号_EAST
    ,EAR_M_BAL                                --月初余额
    ,NEXT_INT_SET_DT                          --下次结息日期
    ,STD_PROD_ID                              --标准产品代码
    ,DEP_TERM                                 --存期
    ,IBANK_DEP_FLG                            --同业存款标志
    ,AGREE_DEP_EXP_DT                         --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG                            --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT                       --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT                       --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT                            --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT                        --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD                             --账户属性代码
    ,FROZ_FLG                                 --冻结标志
    ,ACCT_CARD_NO                             --客户账户卡号
    ,STOP_PAY_STATUS_CD                       --止付状态代码
    ,FROZ_DT                                  --冻结日期
    ,UNFRZ_DT                                 --解冻日期
    ,INIT_OPEN_ACCT_DT                        --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                              --原始到期日期  add by hulj 20221227
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
   )
   SELECT
    V_P_DATE                                  DATA_DT                                  --数据日期
    ,T1.LP_ID                                 LGL_REP_ID                               --法人编号
    ,T1.AGT_ID                                ACC_ID                                   --账户编号
    ,T2.CUST_ID                               CUST_ID                                  --客户编号
    ,T2.OPEN_ACCT_ORG_ID                      ORG_ID                                   --机构编号
    ,T1.ELEC_CASH_ACCT_CURR_CD                CUR                                      --币种
    ,'101010100004'                           DEP_PROD_CD                              --存款产品代码
    ,'0502'                                     DEP_PROD_TYP  --储蓄活期                           --存款产品类型
    ,TO_CHAR(T1.APP_EFFECT_DT,'YYYYMMDD')     VAL_DT                                   --起息日期
    ,T1.ELEC_CASH_ACCT_BAL                    DEP_BAL                                  --存款余额
    ,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')               DEP_EXP_DT                    --存款到期日期
    ,'1'                                     CORP_IND_FLG                             --对公对私标志
    ,'2011010203'                             SUBJ_ID                                  --科目编号
    ,0                                     RATE                                     --利率
    ,TO_CHAR(T1.ELEC_CASH_ACCT_OPEN_ACCT_DT,'YYYYMMDD')  OPEN_ACC_DT                   --开户日期
    ,NULL                                     OPEN_ACC_TLR_NO                          --开户柜员号
    ,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')               CNL_ACC_DT                    --销户日期
    ,'01'--COD1.TAR_VALUE_CODE                      DEP_ACC_STAT                             --存款账户状态
    ,'A'--T1.ELEC_CASH_ACCT_STATUS_CD              DEP_ACCT_STATUS_CD                       --存款账户状态原码值
    ,NULL                                     LAST_ACC_CHG_DT                          --上次动户日期
    ,'01'                                     CASH_REMIT_TYP                           --钞汇类型
    ,NULL                                     AGRT_DEP_PSN_TYP                         --协议存款人类型
    ,NULL                                     RATE_RE_PRC_DT                           --利率重新定价日期
    ,NULL                                     INNR_ADV_EXP_OPTION_FLG                  --内嵌提前到期期权标志
    ,NULL                                     ADV_DRAW_FLG                             --可提前支取标志
    ,NULL                                     NTC_WD_DT                                --通知取款日期
    ,NULL                                     NTC_WD_AMT                               --通知取款金额
    ,NULL                                     CR_CRD_EX_PAY_FLG                        --信用卡溢缴款标志
    ,0                                        PBL_INT                                  --应付利息
    ,NULL                                     CO_DEP_TYP                               --单位存款类型
    ,NULL                                     DEP_INS_AMT                              --被存款保险制度覆盖的金额
    ,NULL                                     BIZ_REL_DEP_AMT                          --有业务关系存款金额
    ,NULL                                     TD_APVL_ACC_FLG                          --待核准账户标志
    ,NULL                                     INT_CALC_FLG                             --计息标志
    ,NULL                                     SPCL_DEP_TYP                             --专项存款类型
    ,NULL                                     ENTRS_LOAN_FUND_SUM_CL                   --委托贷款基金细类
    ,NULL                                     CONSR_TYP                                --委托人类型
    ,'A3'                                     IND_DMD_DEP_ACC_TYP                      --个人活期存款账户类型
    ,NULL                                     PBC_ACC_TYP                              --人行账户类型
    ,NULL                                     TIME_DMD_FLG                             --定活标志
    ,NULL                                     OPEN_ACC_CHAN                            --开户渠道
    ,NULL                                     PRC_BASE_TYP                             --定价基准类型
    ,'1'                                      RATE_TYP                                 --利率类型
    ,0                                        BASE_RATE                                --基准利率
    ,NULL                                     RATE_FLT_FREQ                            --利率浮动频率
    ,NULL                                     GUA_YLD                                  --保底收益率
    ,NULL                                     HIGH_YLD_RTO                             --最高收益率
    ,NULL                                     DIF_PLC_DEP_FLG                          --异地存款标志
    ,'DR03'                                   DEP_RSV_MODE                             --缴存准备金方式
    ,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')    ACT_END_DT                               --实际终止日期
    ,0                                     BIZ_OCCUR_TMPNT_ACT_RATE                 --业务发生时点实际利率
    ,0                                     BIZ_TMPNT_BASE_RATE                      --业务发生时点基准利率
    ,NULL                                     DEPT_LINE                                --部门条线
    ,'电子现金账户'                            DATA_SRC                                 --数据来源
    ,NULL                                     CRN_PRD_ACCRD_INT
    ,NULL                                     INTDAY_ACCRD_INT
    ,NULL                                     APPROVAL_ID
    ,NULL                                     CORE_ACC_TYP
    ,T1.CARD_SER_NUM                          SUB_ACC_ID                               --子账户编号
    ,T1.AGT_ID||CARD_SER_NUM                  ACC_ID_EAST                              --账户编号_EAST
    ,NULL                                     EAR_M_BAL                                --月初余额
    ,NULL                                     NEXT_INT_SET_DT                          --下次结息日期
    ,'101010100004'                           STD_PROD_ID                              --标准产品代码
    ,NULL                                     DEP_TERM                                 --存期
    ,NULL                                     IBANK_DEP_FLG                            --同业存款标志
    ,NULL                                     AGREE_DEP_EXP_DT                         --协定存款到期日期(金数IMAS用)20221031 ADD
    ,NULL                                     AGREE_DEP_FLG                            --协定存款标志(金数IMAS用)20221031 ADD
    ,NULL                                     AGREE_DEP_INIT_AMT                       --协定存款起存金额(金数IMAS用)20221031 ADD
    ,NULL                                     AGREE_DEP_VALUE_DT                       --协定存款起息日期(金数IMAS用)20221031 ADD
    ,NULL                                     AGREE_INT_RAT                            --协定利率(金数IMAS用)20221031 ADD
    ,NULL                                     AGREE_DEP_RELS_DT                        --协定存款解约日期(金数IMAS用)20221031 ADD
    ,NULL                                     ACCT_CHAR_CD                             --账户属性代码
    ,'0'                                      FROZ_FLG                                 --冻结标志
    ,T1.CARD_NO                               ACCT_CARD_NO                             --客户账户卡号
    ,'0'                                      STOP_PAY_STATUS_CD                       --止付状态代码
    ,NULL                                     FROZ_DT                                  --冻结日期
    ,NULL                                     UNFRZ_DT                                 --解冻日期
    ,NULL                                     INIT_OPEN_ACCT_DT                        --原始开户日期  add by hulj 20221227
    ,NULL                                     INIT_EXP_DT                              --原始到期日期  add by hulj 20221227
    ,NULL                                     LG_FROZ_FLG                              --司法冻结标志
    ,T1.CARD_SER_NUM                          CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    FROM RRP_MDL.O_IML_AGT_IC_CARD_ELEC_CASH_ACCT_H  T1 --IC卡电子现金账户历史
     /*LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY T.CUST_ACCT_CARD_NO ORDER BY T.CUST_ACCT_SUB_ACCT_NUM ) RN FROM  O_ICL_CMM_DEP_ACCT_INFO  T
               WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') )      T2 --存款分户信息
         ON   T1.CARD_NO = T2.CUST_ACCT_CARD_NO
         AND  T2.RN = 1 */
     LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T2 --存款客户账户信息
      ON T1.CARD_NO = T2.CUST_ACCT_CARD_NO
     AND  T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP                       COD1 --账户状态转码
         ON COD1.SRC_VALUE_CODE = T1.ELEC_CASH_ACCT_STATUS_CD
         AND COD1.SRC_CLASS_CODE = 'CD2554'
         AND COD1.TAR_CLASS_CODE = 'Z0018'
         AND COD1.MOD_FLG = 'MDM'
    WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  ;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID_EAST,COUNT(1)
      FROM M_DEP_ACC_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ACC_ID_EAST
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
    O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_DEP_ACC_INFO;
/

