CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_AST_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_AST_INFO
  *  功能描述：资金业务（资产方）信息
  *  创建日期：20220607
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_AST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220909  hulj    调整账户编号取值，新增字段：SUB_ACC_ID --子账户编号,TIME_DWD_FLG  --定活标志,
  *                                    FIN_INSTM_ID --金融工具编号,BUS_ID --业务编号,ASSET_THD_CLS_CD --资产三分类代码
  *             2    20221031  XUXIAOBIN  修改机构编号 取原值
  *             3    20221122  xucx       增加同业代付口径
  *             4    20230619  MW         修改同业代付口径的执行利率
  *             5    20230711  HYF        修改同业代付客户号
  *             6    20231128  hulj       重新调整同业代付口径，改从国结系统出数
  *             7    20240328  HYF        修改拆放同业过滤条件
  *             8    20240923  HYF        放开同业代付到期日期过滤条件，已到期的明细其利息需要报送
  *             9    20241209  LIP        增加同业代付的实际到期日期加工
  *             10   20260228  HYF        调整PROD_TYPE_CD=0179为银团同业银款业务，客户号取值取实际融资人
  ***************************************************************************/
AS
  --定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_AST_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_CPTL_AST_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统
BEGIN
  --处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_EAST.M_CPTL_AST_INFO T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_AST_INFO'||' TRUNCATE PARTITION '||'写上分区名'); --分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

 --分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入资金业务（资产方）信息--资金系统同业拆借';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    --,SPCL_PRO                     --专项准备
    --,PARTI_PRO                    --特种准备
    --,COM_PRO                      --一般准备
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    )
  SELECT V_P_DATE                                    AS DATA_DT                  --1数据日期
         ,A.LP_ID                                    AS LGL_REP_ID               --2法人编号
         ,A.ENTRY_ORG_ID                             AS ORG_ID                   --3机构编号
         ,A.CUST_ID                                  AS CUST_ID                  --4客户编号 暂行
         ,COALESCE(A.BAG_ID,A.BUS_ID)                AS ACC_ID                   --5账户编号
         ,A.ACCT_B_ATTR_CD                           AS ACC_TYP                  --6账户类型
         ,A.CURR_CD                                  AS CUR                      --7币种
         ,'10201'                                    AS BIZ_TYP                  --8业务类型 101存放同业 102拆放同业 103同业借款 10203同业代付 10501法透交易
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')             AS START_DT                 --9起始日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')               AS EXP_DT                   --10到期日期
         ,A.EXEC_INT_RAT                             AS ACT_RATE                 --11实际利率
         ,A.CURRT_ACRU_INT                           AS INT                      --12利息
         --A.ACRU_INT                                 AS INT,                    --12利息 --应计利息
         ,NULL                                       AS NEXT_INT_PAY_DT          --13下一付息日
         ,NULL                                       AS RATE_RE_PRC_DT           --14利率重新定价日期
         ,A.TRAN_AMT                                 AS BIZ_AMT                  --15业务发生金额
         ,A.CURRT_BAL                                AS BAL                      --16余额
         ,NULL                                       AS OVD_PRIN_AMT             --17逾期本金金额
         ,NULL                                       AS OVD_INT_AMT              --18逾期利息金额
         ,NULL                                       AS LVL5_CL                  --19五级分类
         ,NULL                                       AS MRGN                     --20保证金
         ,NULL                                       AS MRGN_CUR                 --21保证金币种
         --NULL                                     AS SPCL_PRO,                 --22专项准备
         --NULL                                     AS PARTI_PRO,                --23特种准备
         --NULL                                     AS COM_PRO,                  --24一般准备
         ,NULL                                       AS PEERS_PAY_FLG            --25同业代付标志
         ,NULL                                       AS ACTP_BILL_NO             --26承兑汇票票号
         ,NULL                                       AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --27外汇储备委托贷款资金标志
         ,NULL                                       AS SETL_PEERS_DEP_FLG       --28结算性同业存款标志
         ,NULL                                       AS BIZ_REL_FLG              --29业务关系标志
         ,NULL                                       AS COLL_RSK_CL              --30担保品风险分类
         ,NULL                                       AS COLL_MKT_VAL             --31担保品市场价值
         ,NULL                                       AS INNR_ADV_EXP_OPTION_FLG  --32内嵌提前到期期权标志
         ,NULL                                       AS STK_PLG_LOAN_FLG         --33股票质押贷款标志
         ,NULL                                       AS AGRT_OD_FLG              --34协议透支标志
         ,NULL                                       AS SPV_FLG                  --35特殊目的载体标志
         ,NULL                                       AS GUA_FINC_FLG             --36保本理财标志
         ,NULL                                       AS BIZ_REL_DEP_AMT          --37有业务关系存款金额
         ,NULL                                       AS OUTSRC_FLG               --38委外标志
         ,'RF01'                                     AS RATE_TYP                 --39利率类型
         ,'TR99'                                     AS PRC_BASE_TYP             --40定价基准类型
         ,A.EXEC_INT_RAT                             AS BASE_RATE                --41基准利率
         ,'99'                                       AS RATE_FLT_FREQ            --42利率浮动频率
         ,'07'                                       AS INT_CALC_MODE            --43计息方式 --07 利随本清 20220929 xuxiaobin ADD
         ,NULL                                       AS CRDT_LMT_ID              --44授信额度编号
         ,NULL                                       AS ACT_END_DT               --45实际终止日期
         ,NULL                                       AS DEP_RSV_MODE             --46缴存准备金方式
         ,'800919'                                   AS DEPT_LINE                --47部门条线
         ,'资金同业拆借'                             AS DATA_SRC                 --48数据来源
         ,NULL                                       AS SUB_ACC_ID               --49子账户编号
         ,NULL                                       AS TIME_DWD_FLG             --50定活标志
         ,NULL                                       AS FIN_INSTM_ID             --51金融工具编号
         ,A.BUS_ID                                   AS BUS_ID                   --52业务编号
         ,A.ASSET_THD_CLS_CD                         AS ASSET_THD_CLS_CD         --53资产三分类代码
         ,A.STD_PROD_ID                              AS STD_PROD_ID              --54标准产品编号
         ,A.SUBJ_ID                                  AS SUBJ_ID                  --55科目编号
         ,A.TRAN_ID                                  AS TRAN_ID                  --56交易编号
    FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A --资金同业拆借 A
   WHERE A.SUBJ_ID LIKE '1302%' --拆放同业款项 20220929 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '插入资金业务（资产方）信息--外汇系统-同业拆借、外币回购借';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    --,SPCL_PRO                     --专项准备
    --,PARTI_PRO                    --特种准备
    --,COM_PRO                      --一般准备
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    )
  SELECT DISTINCT
         V_P_DATE                         AS DATA_DT                          --1数据日期
         ,A.LP_ID                         AS LGL_REP_ID                       --2法人编号
         ,A.ENTRY_ORG_ID                  AS ORG_ID                           --3机构编号
         ,A.CUST_ID                       AS CUST_ID                          --4客户编号
         ,COALESCE(A.BAG_ID,A.BOND_ID)    AS ACC_ID                           --5账户编号
         ,NULL                            AS ACC_TYP                          --6账户类型
         ,A.CURR_CD                       AS CUR                              --7币种
         ,'10201'                         AS BIZ_TYP                          --8业务类型 拆放同业
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')  AS START_DT                         --9起始日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')    AS EXP_DT                           --10到期日期
         ,A.EXEC_INT_RAT                  AS ACT_RATE                         --11实际利率
         ,A.CURRT_ACRU_INT                AS INT                              --12利息
         ,NULL                            AS NEXT_INT_PAY_DT                  --13下一付息日
         ,NULL                            AS RATE_RE_PRC_DT                   --14利率重新定价日期
         ,A.TRAN_AMT                      AS BIZ_AMT                          --15业务发生金额
         ,A.CURRT_BAL                     AS BAL                              --16余额
         ,NULL                            AS OVD_PRIN_AMT                     --17逾期本金金额
         ,NULL                            AS OVD_INT_AMT                      --18逾期利息金额
         ,NULL                            AS LVL5_CL                          --19五级分类
         ,NULL                            AS MRGN                             --20保证金
         ,NULL                            AS MRGN_CUR                         --21保证金币种
         --NULL                          AS SPCL_PRO,                         --22专项准备
         --NULL                          AS PARTI_PRO,                        --23特种准备
         --NULL                          AS COM_PRO,                          --24一般准备
         ,NULL                            AS PEERS_PAY_FLG                    --25同业代付标志
         ,NULL                            AS ACTP_BILL_NO                     --26承兑汇票票号
         ,NULL                            AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG    --27外汇储备委托贷款资金标志
         ,NULL                            AS SETL_PEERS_DEP_FLG               --28结算性同业存款标志
         ,NULL                            AS BIZ_REL_FLG                      --29业务关系标志
         ,NULL                            AS COLL_RSK_CL                      --30担保品风险分类
         ,NULL                            AS COLL_MKT_VAL                     --31担保品市场价值
         ,NULL                            AS INNR_ADV_EXP_OPTION_FLG          --32内嵌提前到期期权标志
         ,NULL                            AS STK_PLG_LOAN_FLG                 --33股票质押贷款标志
         ,NULL                            AS AGRT_OD_FLG                      --34协议透支标志
         ,NULL                            AS SPV_FLG                          --35特殊目的载体标志
         ,NULL                            AS GUA_FINC_FLG                     --36保本理财标志
         ,NULL                            AS BIZ_REL_DEP_AMT                  --37有业务关系存款金额
         ,NULL                            AS OUTSRC_FLG                       --38委外标志
         ,CASE WHEN A.INT_RAT_ADJ_WAY_CD = '0' THEN 'RF01'
               WHEN A.INT_RAT_ADJ_WAY_CD = '1' THEN 'RF02'
               ELSE '0'
          END                             AS RATE_TYP                         --39利率类型
         ,'TR99'                          AS PRC_BASE_TYP                     --40定价基准类型
         ,A.BASE_RAT                      AS BASE_RATE                        --41基准利率
         ,NVL(A.INT_RAT_ADJ_FREQ_CD,'99') AS RATE_FLT_FREQ                    --42利率浮动频率
         ,'07'                            AS INT_CALC_MODE                    --43计息方式 --07 利随本清 20220929 xuxiaobin ADD
         ,NULL                            AS CRDT_LMT_ID                      --44授信额度编号
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')    AS ACT_END_DT                       --45实际终止日期
         ,NULL                            AS DEP_RSV_MODE                     --46缴存准备金方式
         ,'800919'                        AS DEPT_LINE                        --47部门条线
         ,'外汇同业拆借'                  AS DATA_SRC                         --48数据来源
         ,NULL                            AS SUB_ACC_ID                       --49子账户编号
         ,NULL                            AS TIME_DWD_FLG                     --50定活标志
         ,NULL                            AS FIN_INSTM_ID                     --51金融工具编号
         ,A.BUS_ID                        AS BUS_ID                           --52业务编号
         ,A.ASSET_THD_CLS_CD              AS ASSET_THD_CLS_CD                 --53资产三分类代码
         ,A.STD_PROD_ID                   AS STD_PROD_ID                      --54标准产品编号
         ,A.SUBJ_ID                       AS SUBJ_ID                          --55科目编号
         ,A.TRAN_ID                       AS TRAN_ID                          --56交易编号
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表 A
   WHERE A.SUBJ_ID LIKE '1302%' --拆放同业20221018 XUXIAOBIN MODIFY
     --AND A.SUBJ_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 5 ;
  V_STEP_DESC := '插入资金业务（资产方）信息-同业系统-同业借款、同业现金借贷质押式回购';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    --,SPCL_PRO                     --专项准备
    --,PARTI_PRO                    --特种准备
    --,COM_PRO                      --一般准备
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,ASSET_TYPE_NAME                --资产类型名称（外管报表筛选）
    ,APV_ODD_NO                     --审批单号（外管报表筛选） --ADD BY MW 20221014
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    )
  SELECT DISTINCT
         V_P_DATE                                    AS DATA_DT               --1数据日期
         ,A.LP_ID                                     AS LGL_REP_ID           --2法人编号
         ,A.BELONG_ORG_ID                             AS ORG_ID               --3机构编号
         --A.CNTPTY_ID                                 AS CUST_ID,            --4客户编号
         --,A.CNTPTY_CUST_ID                            AS CUST_ID              --4客户编号 暂行
         ,CASE WHEN TRIM(A.PROD_TYPE_CD) = '0179' THEN A.ACTL_FINER_CUST_ID
          ELSE A.CNTPTY_CUST_ID END                   AS CUST_ID              --4客户编号 MOD BY 20260228
         ,COALESCE(A.ACCT_ID,A.FIN_INSTM_ID,A.BUS_ID) AS ACC_ID               --5账户编号
         ,NULL                                        AS ACC_TYP              --6账户类型
         ,A.CURR_CD                                   AS CUR                  --7币种
         ,'10202'                                     AS BIZ_TYP              --8业务类型  同业借款
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')              AS START_DT             --9起始日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS EXP_DT               --10到期日期
         --A.EXEC_INT_RAT                              AS ACT_RATE,             --11实际利率
         ,A.FAC_VAL_INT_RAT                           AS ACT_RATE             --11实际利率    --MODIFY  CCH  20220908
         ,A.ACRU_INT                                  AS INT                  --12利息
         ,NULL                                        AS NEXT_INT_PAY_DT      --13下一付息日
         ,NULL                                        AS RATE_RE_PRC_DT       --14利率重新定价日期
         ,A.TRAN_AMT                                  AS BIZ_AMT              --15RECVBL_UNCOL_PRIC 业务发生金额
         ,A.CURRT_BAL                                 AS BAL                  --16余额
         ,A.RECVBL_UNCOL_PRIC                         AS OVD_PRIN_AMT         --17逾期本金金额
         ,A.RECVBL_UNCOL_INT                          AS OVD_INT_AMT          --18逾期利息金额
         ,CASE WHEN A.LEVEL5_CLS_CD = '10' THEN '01'--正常
               WHEN A.LEVEL5_CLS_CD = '00' THEN '01'--正常
               WHEN A.LEVEL5_CLS_CD = '20' THEN '02'--关注
               WHEN A.LEVEL5_CLS_CD = '30' THEN '03'--次级
               WHEN A.LEVEL5_CLS_CD = '40' THEN '04'--可疑
               WHEN A.LEVEL5_CLS_CD = '50' THEN '05'--损失
          END                                         AS LVL5_CL              --19五级分类 --20221019 MODIFY LHH
         ,NULL                                        AS MRGN                 --20保证金
         ,NULL                                        AS MRGN_CUR             --21保证金币种
         --NULL                                        AS SPCL_PRO,             --22专项准备
         --NULL                                        AS PARTI_PRO,            --23特种准备
         --NULL                                        AS COM_PRO,              --24一般准备
         ,NULL                                        AS PEERS_PAY_FLG        --25同业代付标志
         ,NULL                                        AS ACTP_BILL_NO         --26承兑汇票票号
         ,NULL                                        AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --27外汇储备委托贷款资金标志
         ,NULL                                        AS SETL_PEERS_DEP_FLG   --28结算性同业存款标志
         ,NULL                                        AS BIZ_REL_FLG          --29业务关系标志
         ,NULL                                        AS COLL_RSK_CL          --30担保品风险分类
         ,NULL                                        AS COLL_MKT_VAL         --31担保品市场价值
         ,NULL                                        AS INNR_ADV_EXP_OPTION_FLG--32内嵌提前到期期权标志
         ,NULL                                        AS STK_PLG_LOAN_FLG     --33股票质押贷款标志
         ,NULL                                        AS AGRT_OD_FLG          --34协议透支标志
         ,NULL                                        AS SPV_FLG              --35特殊目的载体标志
         ,NULL                                        AS GUA_FINC_FLG         --36保本理财标志
         ,NULL                                        AS BIZ_REL_DEP_AMT      --37有业务关系存款金额
         ,NULL                                        AS OUTSRC_FLG           --38委外标志
         ,CASE WHEN A.PROD_TYPE_CD = '0125'
                AND A.INT_RAT_ADJ_WAY_CD = '2'
                AND A.INT_RAT_ADJ_FREQ_CD = '0D'
               THEN 'RF01'
               ELSE DECODE(A.INT_RAT_ADJ_WAY_CD,'1','RF01','2','RF02','RF01')
          END                                        AS RATE_TYP             --39利率类型利率调整频率代码 利率调整方式代码
         ,CASE WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE '%SHIBOR%' THEN 'TR01'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE '%LIBOR%' THEN 'TR04'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE '%HIBOR%' THEN 'TR05'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE '%EURIBOR%' THEN 'TR06'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE 'LPR%' THEN 'TR07'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE 'CHN%' THEN 'TR08'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE 'DEPO_%' THEN 'TR09'
               WHEN A.INT_RAT_ADJ_WAY_CD = '2' AND C.BASE_RAT_ID LIKE 'LN_%' THEN 'TR10'
               ELSE 'TR99'
          END                                         AS PRC_BASE_TYP         --40定价基准类型
         ,A.BASE_RAT                                  AS BASE_RATE            --41基准利率
         ,NVL(TTA.TAR_VALUE_CODE,'99')                AS RATE_FLT_FREQ        --42利率浮动频率
         ,CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01'--0M 按月
               WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q 按季 3M 按3个月
               WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03'--1Y 按年
               WHEN A.PAY_INT_PED_CD = '6M' THEN '06'--6M 按6个月
               --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
               ELSE '99' --其他 00 未知 0D 按日 1M 按周 4M 按4个月
          END                                         AS INT_CALC_MODE        --43计息方式
         ,NULL                                        AS CRDT_LMT_ID          --44授信额度编号
         ,CASE WHEN A.PRIC_BAL+A.RECVBL_UNCOL_PRIC = 0
               THEN V_P_DATE
               ELSE NULL
          END                                         AS ACT_END_DT          --45实际终止日期 --20230109 MODIFY CCH 根据IMAS旧监管逻辑更改
         ,NULL                                        AS DEP_RSV_MODE        --46缴存准备金方式
         ,'800919'                                    AS DEPT_LINE           --47部门条线
         /*UPPER(SUBSTR(A.JOB_CD,1,4))                 AS DATA_SRC,             --48数据来源*/
         ,'同业现金借贷'                              AS DATA_SRC             --48数据来源
         ,NULL                                        AS SUB_ACC_ID           --49子账户编号
         ,NULL                                        AS TIME_DWD_FLG         --50定活标志
         ,NVL(A.FIN_INSTM_ID,'999')                   AS FIN_INSTM_ID         --51金融工具编号
         ,A.BUS_ID                                    AS BUS_ID               --52业务编号
         ,A.ASSET_THD_CLS_CD                          AS ASSET_THD_CLS_CD     --53资产三分类代码
         ,A.STD_PROD_ID                               AS STD_PROD_ID          --54标准产品编号
         ,A.ASSET_TYPE_NAME                           AS ASSET_TYPE_NAME      --55资产类型名称（外管报表筛选）
         ,A.APV_ODD_NO                                AS APV_ODD_NO           --56审批单号（外管报表筛选） --ADD BY MW 20221014
         ,A.SUBJ_ID                                   AS SUBJ_ID              --57科目编号
         ,A.TRAN_SEQ_NUM                              AS TRAN_ID              --58交易编号
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷表 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C  --同业金融工具表
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA
      ON TTA.SRC_VALUE_CODE = A.PAY_INT_PED_CD
     AND TTA.SRC_CLASS_CODE = 'CD1623'
     AND TTA.TAR_CLASS_CODE = 'D0105'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --五级分类转码
      ON TTB.SRC_VALUE_CODE = A.LEVEL5_CLS_CD
     AND TTB.SRC_CLASS_CODE = 'CD1032'
     AND TTB.TAR_CLASS_CODE = 'D0005'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.SUBJ_ID LIKE '130203%' --同业借出
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --20220928 xuxiaobin法透由表内借据出
  V_STEP := 6;
  V_STEP_DESC := '插入资金业务（资产方）信息--核心系统-法透当天透支当天还款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    --,SPCL_PRO                     --专项准备
    --,PARTI_PRO                    --特种准备
    --,COM_PRO                      --一般准备
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    )
  SELECT DISTINCT
         V_P_DATE                                   AS DATA_DT                       --1数据日期
         ,B.LP_ID                                    AS LGL_REP_ID                    --2法人编号
         ,B.ACCT_INSTIT_ID                           AS ORG_ID                       --3机构编号
         ,B.CUST_ID                                  AS CUST_ID                       --4客户编号
         ,B.DUBIL_NUM                                AS ACC_ID                        --5账户编号
         ,NULL                                       AS ACC_TYP                       --6账户类型
         ,B.CURR_CD                                  AS CUR                           --7币种
         ,'10204'                                    AS BIZ_TYP                       --8业务类型  拆放同业--法透
         ,TO_CHAR(B.VALUE_DT,'YYYYMMDD')             AS START_DT                      --9起始日期
         ,TO_CHAR(B.EXP_DT,'YYYYMMDD')               AS EXP_DT                        --10到期日期
         ,B.EXEC_INT_RAT                             AS ACT_RATE                      --11实际利率
         ,B.CURRT_ACRU_INT                           AS INT                           --12利息
         ,NULL                                       AS NEXT_INT_PAY_DT               --13下一付息日
         ,NULL                                       AS RATE_RE_PRC_DT                --14利率重新定价日期
         ,B.DISTR_AMT                                AS BIZ_AMT                       --15业务发生金额
         ,B.CURRT_BAL                                AS BAL                           --16余额
         ,B.OVDUE_PRIC_BAL                           AS OVD_PRIN_AMT                  --17逾期本金金额
         ,B.OVDUE_INT_AMT                            AS OVD_INT_AMT                   --18逾期利息金额
         ,TTB.TAR_VALUE_CODE                         AS LVL5_CL                       --19五级分类
         ,NULL                                       AS MRGN                          --20保证金
         ,NULL                                       AS MRGN_CUR                      --21保证金币种
         --NULL                                       AS SPCL_PRO,                      --22专项准备
         --NULL                                       AS PARTI_PRO,                     --23特种准备
         --NULL                                       AS COM_PRO,                       --24一般准备
         ,NULL                                       AS PEERS_PAY_FLG                 --25同业代付标志
         ,NULL                                       AS ACTP_BILL_NO                  --26承兑汇票票号
         ,NULL                                       AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --27外汇储备委托贷款资金标志
         ,NULL                                       AS SETL_PEERS_DEP_FLG            --28结算性同业存款标志
         ,NULL                                       AS BIZ_REL_FLG                   --29业务关系标志
         ,NULL                                       AS COLL_RSK_CL                   --30担保品风险分类
         ,NULL                                       AS COLL_MKT_VAL                  --31担保品市场价值
         ,NULL                                       AS INNR_ADV_EXP_OPTION_FLG       --32内嵌提前到期期权标志
         ,NULL                                       AS STK_PLG_LOAN_FLG              --33股票质押贷款标志
         ,NULL                                       AS AGRT_OD_FLG                   --34协议透支标志
         ,NULL                                       AS SPV_FLG                       --35特殊目的载体标志
         ,NULL                                       AS GUA_FINC_FLG                  --36保本理财标志
         ,NULL                                       AS BIZ_REL_DEP_AMT               --37有业务关系存款金额
         ,NULL                                       AS OUTSRC_FLG                    --38委外标志
         ,CASE WHEN B.INT_RAT_ADJ_WAY_CD = '0' THEN '1' --固定利率
               ELSE '2' --浮动利率
          END                                        AS RATE_TYP                      --39利率类型
         ,CASE WHEN B.INT_RAT_CURVE_TYPE_CD IN ('241','242') THEN 'TR07'
               ELSE 'TR10'
          END                                        AS PRC_BASE_TYP                  --40定价基准类型
         ,B.BASE_RAT                                 AS BASE_RATE                     --41基准利率
         ,'05'                                       AS RATE_FLT_FREQ                 --42利率浮动频率
         ,'05'                                       AS INT_CALC_MODE                 --43计息方式
         ,NULL                                       AS CRDT_LMT_ID                   --44授信额度编号
         ,TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')         AS ACT_END_DT                    --45实际终止日期
         ,NULL                                       AS DEP_RSV_MODE                  --46缴存准备金方式
         ,'800919'                                   AS DEPT_LINE                     --47部门条线
         ,'法透'                                     AS DATA_SRC                      --48数据来源
         ,D.OD_SUB_ACCT_ID                           AS SUB_ACC_ID                    --子账户编号
         ,NULL                                       AS TIME_DWD_FLG                  --定活标志
         ,NULL                                       AS FIN_INSTM_ID                  --金融工具编号
         ,B.DUBIL_NUM                                AS BUS_ID                        --业务编号
         ,NULL                                       AS ASSET_THD_CLS_CD              --资产三分类代码
         ,B.STD_PROD_ID                              AS STD_PROD_ID                   --标准产品编号
         ,B.SUBJ_ID                                  AS SUBJ_ID                       --科目编号
         ,B.DISTR_FLOW_NUM                           AS TRAN_ID                        --交易编号
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
      ON C.CONT_ID = B.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LP_OD_SIGN_INFO D --法透签约信息表
      ON D.DUBIL_ID = B.DUBIL_NUM
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTB --五级分类转码
      ON TTB.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
     AND TTB.SRC_CLASS_CODE = 'CD1032'
     AND TTB.TAR_CLASS_CODE = 'D0005'
     AND TTB.MOD_FLG = 'MDM'
   WHERE D.LP_OD_TYPE_CD IN ('1','2')--0 对公法透 1 同业日间法透 2 同业隔夜法透
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 7;
  V_STEP_DESC := '插入资金业务（资产方）信息----同业系统-存放同业活期1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    --,SPCL_PRO                     --专项准备
    --,PARTI_PRO                    --特种准备
    --,COM_PRO                      --一般准备
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
    )
  SELECT DISTINCT
         V_P_DATE                                    AS DATA_DT                       --1数据日期
         ,A.LP_ID                                    AS LGL_REP_ID                    --2法人编号
         ,A.OPEN_ACCT_ORG_ID                         AS ORG_ID                        --3机构编号
         ,A.CUST_ID                                  AS CUST_ID                       --4客户编号
         ,A.CUST_ACCT_ID                             AS ACC_ID                        --5账户编号
         ,A.ACCT_CLS_CD                              AS ACC_TYP                       --6账户类型
         ,A.CURR_CD                                  AS CUR                           --7币种
         ,'101'                                      AS BIZ_TYP                       --8业务类型  存放同业
         ,TO_CHAR(A.INT_START_DT,'YYYYMMDD')         AS START_DT                      --9起始日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')               AS EXP_DT                        --10到期日期
         ,A.EXEC_INT_RAT                             AS ACT_RATE                      --11实际利率
         ,A.CURRT_ACRU_INT                           AS INT                           --12利息
         ,TO_CHAR(A.OPEN_DT,'YYYYMMDD')              AS NEXT_INT_PAY_DT               --13下一付息日
         ,NULL                                       AS RATE_RE_PRC_DT                --14利率重新定价日期
         ,NULL                                       AS BIZ_AMT                       --15业务发生金额
         ,A.OBANK_CURR_BAL                           AS BAL                           --16余额 --20220929 XUXIAOBIN MODIFY
         ,NULL                                       AS OVD_PRIN_AMT                  --17逾期本金金额
         ,NULL                                       AS OVD_INT_AMT                   --18逾期利息金额
         ,NULL                                       AS LVL5_CL                       --19五级分类
         ,NULL                                       AS MRGN                          --20保证金
         ,NULL                                       AS MRGN_CUR                      --21保证金币种
         --NULL                                       AS SPCL_PRO,                      --22专项准备
         --NULL                                       AS PARTI_PRO,                     --23特种准备
         --NULL                                       AS COM_PRO,                       --24一般准备
         ,NULL                                       AS PEERS_PAY_FLG                 --25同业代付标志
         ,NULL                                       AS ACTP_BILL_NO                  --26承兑汇票票号
         ,NULL                                       AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --27外汇储备委托贷款资金标志
         ,CASE WHEN A.ACCT_USAGE_CD = '6'
               THEN 'Y'
               ELSE 'N'
          END                                        AS SETL_PEERS_DEP_FLG            --28结算性同业存款标志
         ,NULL                                       AS BIZ_REL_FLG                   --29业务关系标志
         ,NULL                                       AS COLL_RSK_CL                  --30担保品风险分类
         ,NULL                                       AS COLL_MKT_VAL                  --31担保品市场价值
         ,NULL                                       AS INNR_ADV_EXP_OPTION_FLG       --32内嵌提前到期期权标志
         ,NULL                                       AS STK_PLG_LOAN_FLG              --33股票质押贷款标志
         ,NULL                                       AS AGRT_OD_FLG                   --34协议透支标志
         ,NULL                                       AS SPV_FLG                       --35特殊目的载体标志
         ,NULL                                       AS GUA_FINC_FLG                  --36保本理财标志
         ,NULL                                       AS BIZ_REL_DEP_AMT               --37有业务关系存款金额
         ,NULL                                       AS OUTSRC_FLG                    --38委外标志
         ,CASE WHEN A.INT_RAT_FLO_VAL > 0
               THEN 'RF02'
               ELSE 'RF01'
          END                                        AS RATE_TYP                      --39利率类型
         ,NULL                                       AS PRC_BASE_TYP                  --40定价基准类型
         ,A.BASE_RAT                                 AS BASE_RATE                     --41基准利率
         ,NULL                                       AS RATE_FLT_FREQ                 --42利率浮动频率
         ,CASE WHEN A.PAY_INT_FREQ = 'M3' THEN '02' --M3 3个月 按季
               WHEN A.PAY_INT_FREQ LIKE '%Y%' THEN '03' --Y 按年
               WHEN A.PAY_INT_FREQ = '0' THEN '07'
               ELSE '99'
          END                                        AS INT_CALC_MODE                --43计息方式
         ,NULL                                       AS CRDT_LMT_ID                   --44授信额度编号
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')               AS ACT_END_DT                    --45实际终止日期
         ,'DR01'                                     AS DEP_RSV_MODE                  --46缴存准备金方式
         ,NULL                                       AS DEPT_LINE                     --47部门条线
         ,'存放同业账户'                             AS DATA_SRC                      --48数据来源
         ,NVL(B.OLD_SUB_ACCT_NUM,A.CUST_SUB_ACCT_ID) AS SUB_ACC_ID                    --子账户编号
         ,CASE WHEN A.ACCT_CHAR_CD = '18'
               THEN '0'
               ELSE '1'
          END                                        AS TIME_DWD_FLG                  --定活标志
         ,NULL                                       AS FIN_INSTM_ID                  --金融工具编号
         ,NULL                                       AS BUS_ID                        --业务编号
         ,NULL                                       AS ASSET_THD_CLS_CD              --资产三分类代码
         ,A.STD_PROD_ID                              AS STD_PROD_ID                   --标准产品编号
         ,A.SUBJ_ID                                  AS SUBJ_ID                       --科目编号
         ,A.OPEN_FLOW_NUM                            AS TRAN_ID                       --交易编号
         ,A.CUST_SUB_ACCT_ID                         AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    FROM RRP_MDL.O_ICL_CMM_NOSTRO_ACCT_INFO A --存放同业账户信息 A
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B
      ON B.MAIN_ACCT_ID = A.CUST_ACCT_ID
     AND B.SUB_ACCT_NUM = A.CUST_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 8;
  V_STEP_DESC := '插入资金业务（资产方）信息----同业代付';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,ORG_ID                         --机构编号
    ,CUST_ID                        --客户编号
    ,ACC_ID                         --账户编号
    ,ACC_TYP                        --账户类型
    ,CUR                            --币种
    ,BIZ_TYP                        --业务类型
    ,START_DT                       --起始日期
    ,EXP_DT                         --到期日期
    ,ACT_RATE                       --实际利率
    ,INT                            --利息
    ,NEXT_INT_PAY_DT                --下一付息日
    ,RATE_RE_PRC_DT                 --利率重新定价日期
    ,BIZ_AMT                        --业务发生金额
    ,BAL                            --余额
    ,OVD_PRIN_AMT                   --逾期本金金额
    ,OVD_INT_AMT                    --逾期利息金额
    ,LVL5_CL                        --五级分类
    ,MRGN                           --保证金
    ,MRGN_CUR                       --保证金币种
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,BIZ_REL_FLG                    --业务关系标志
    ,COLL_RSK_CL                    --担保品风险分类
    ,COLL_MKT_VAL                   --担保品市场价值
    ,INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
    ,STK_PLG_LOAN_FLG               --股票质押贷款标志
    ,AGRT_OD_FLG                    --协议透支标志
    ,SPV_FLG                        --特殊目的载体标志
    ,GUA_FINC_FLG                   --保本理财标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,CRDT_LMT_ID                    --授信额度编号
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,TIME_DWD_FLG                   --定活标志
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,STD_PROD_ID                    --标准产品编号
    ,SUBJ_ID                        --科目编号
    ,TRAN_ID                        --交易编号
    ,ERA_PAY_BANK_CUST_NAME         --代付行客户名称
    )
  SELECT DISTINCT
         V_P_DATE                                   AS DATA_DT                        --数据日期
        ,A.LP_ID                                    AS LGL_REP_ID                     --法人编号
        ,A.BELONG_ORG_ID                            AS ORG_ID                         --机构编号
        ,TRIM(A.ERA_PAY_BANK_CUST_ID)               AS CUST_ID                        --客户编号
        ,A.AGT_ID                                   AS ACC_ID                         --账户编号
        ,NULL                                       AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                  AS CUR                            --币种
        ,'10203'                                    AS BIZ_TYP                        --业务类型 101存放同业  102拆放同业  103同业借款  10203同业代付 10501法透交易
        ,TO_CHAR(A.TRUST_OPEN_DT, 'YYYYMMDD')       AS START_DT                       --起始日期
        ,TO_CHAR(A.TRUST_EXP_DT, 'YYYYMMDD')        AS EXP_DT                         --到期日期
        ,A.EXEC_INT_RAT                             AS ACT_RATE                       --实际利率
        ,A.CURRT_INT_AMT                            AS INT                            --利息
        ,NULL                                       AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                       AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,CAST(0 AS NUMBER(30,2))                    AS BIZ_AMT                        --业务发生金额
        ,A.PAYBL_PRIC_BAL                           AS BAL                            --余额
        ,0.00                                       AS OVD_PRIN_AMT                   --逾期本金金额
        ,0.00                                       AS OVD_INT_AMT                    --逾期利息金额
        ,'1'                                        AS LVL5_CL                        --五级分类
        ,NULL                                       AS MRGN                           --保证金
        ,NULL                                       AS MRGN_CUR                       --保证金币种
        ,'1'                                        AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                       AS ACTP_BILL_NO                   --承兑汇票票号
        ,'N'                                        AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,'N'                                        AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,NULL                                       AS BIZ_REL_FLG                    --业务关系标志
        ,NULL                                       AS COLL_RSK_CL                    --担保品风险分类
        ,NULL                                       AS COLL_MKT_VAL                   --担保品市场价值
        ,NULL                                       AS INNR_ADV_EXP_OPTION_FLG        --内嵌提前到期期权标志
        ,NULL                                       AS STK_PLG_LOAN_FLG               --股票质押贷款标志
        ,NULL                                       AS AGRT_OD_FLG                    --协议透支标志
        ,'N'                                        AS SPV_FLG                        --特殊目的载体标志
        ,'N'                                        AS GUA_FINC_FLG                   --保本理财标志
        ,NULL                                       AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                       AS OUTSRC_FLG                     --委外标志
        ,NULL                                       AS RATE_TYP                       --利率类型
        ,TB.TAR_VALUE_CODE                          AS PRC_BASE_TYP                   --定价基准类型
        ,A.OVDUE_INT_RAT                            AS BASE_RATE                      --基准利率 --根据数仓陈伟峰提供基准利率拿数仓的逾期利率字段
        ,TA.TAR_VALUE_CODE                          AS RATE_FLT_FREQ                  --利率浮动频率
        ,NULL                                       AS INT_CALC_MODE                  --计息方式
        ,A.DUBIL_ID                                 AS CRDT_LMT_ID                    --授信额度编号  --借据编号
        --,NULL                                       AS ACT_END_DT                     --实际终止日期
        ,CASE WHEN TO_CHAR(A.TRUST_REVO_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.TRUST_REVO_DT,'YYYYMMDD')
          END                                       AS ACT_END_DT                     --实际终止日期 --MOD BY LIP 20241209
        ,NULL                                       AS DEP_RSV_MODE                   --缴存准备金方式
        ,'800975'                                   AS DEPT_LINE                      --部门条线
        ,'同业代付'                                 AS DATA_SRC                       --数据来源
        ,NULL                                       AS SUB_ACC_ID                     --子账户编号
        ,NULL                                       AS TIME_DWD_FLG                   --定活标志
        ,NULL                                       AS FIN_INSTM_ID                   --金融工具编号
        ,A.BUS_ID                                   AS BUS_ID                         --业务编号
        ,NULL                                       AS ASSET_THD_CLS_CD               --资产三分类代码
        ,A.STD_PROD_ID                              AS STD_PROD_ID                    --标准产品编号
        ,A.SUBJ_ID                                  AS SUBJ_ID                        --科目编号
        ,A.AGT_ID                                   AS TRAN_ID                        --交易编号
        ,A.ERA_PAY_BANK_CUST_NAME                   AS ERA_PAY_BANK_CUST_NAME         --代付行客户名称
    FROM RRP_MDL.O_ICL_CMM_IMP_FIN_BUS_INFO A --进口融资业务信息
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H B --业务出账申请
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.APV_STATUS_CD = 'Finished'
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --利率浮动频率
      ON TA.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CD
     AND TA.SRC_CLASS_CODE = 'CD2636'
     AND TA.TAR_CLASS_CODE = 'D0015'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --定价基准类型
      ON TB.SRC_VALUE_CODE = B.BASE_RAT_TYPE_CD
     AND TB.SRC_CLASS_CODE = 'CD1010'
     AND TB.TAR_CLASS_CODE = 'Z0015'
     AND TB.MOD_FLG = 'MDM'
   WHERE A.STD_PROD_ID IN ('401020300001')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

--程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_AST_INFO;
/

