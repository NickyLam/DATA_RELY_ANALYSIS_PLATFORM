CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_REPO_LBY_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_REPO_LBY_INFO
  *  功能描述：回购业务（负债方）信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_REPO_LBY_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  梅炜      首次创建
  *             2    20220826  HULJ      添加口径：资金债券回购、外币回购、同业现金借贷回购
  *             3    20220913  MW        添加字段取值：结算金额、利息金额、交易对手
  *             4    20220921  hulj      调整回购业务类型逻辑取值
  *             5    20221031  XUXIAOBIN  修改机构编号 取原值
  *             6    20221031  XUXIAOBINJS  是报送一个月，月中结清月底余额则为0，余额为0条件需在应用层添加
  *             7    20221114  hulj       增加数据重复校验
  *             8    20221124  xucx       增加字段取当期应计利息
  *             9    20241120  LIP        卖出回购增加交易日期字段
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(100);               --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_REPO_LBY_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_REPO_LBY_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_REPO_LBY_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_REPO_LBY_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入卖出回购票据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_LBY_INFO
    (DATA_DT                              --数据日期
    ,LGL_REP_ID                           --法人编号
    ,CUST_ID                              --客户编号
    ,ORG_ID                               --机构编号
    ,ACC_ID                               --账户编号
    ,ACC_TYP                              --账户类型
    ,CUR                                  --币种
    ,REPO_BIZ_TYP                         --回购业务类型
    ,ULYG_AST_TYP                         --标的资产类型
    ,ULYG_PROD_ID                         --标的产品编号
    ,OPR_TYP                              --经营类型
    ,BAL                                  --余额
    ,INT                                  --利息
    ,NEXT_INT_PAY_DT                      --下一付息日
    ,START_DT                             --起始日期
    ,EXP_DT                               --到期日期
    ,RATE_RE_PRC_DT                       --利率重新定价日期
    ,INT_CALC_FLG                         --计息标志
    ,ULYG_MKT_VAL                         --标的物市场价值
    ,NET_AMT_SETL_AGRT_NO                 --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
    ,RSK_EXP_DISC_COE                     --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                     --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                             --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
    ,BASE_RATE                            --基准利率
    ,RATE_FLT_FREQ                        --利率浮动频率
    ,PRC_BASE_TYP                         --定价基准类型
    ,INT_CALC_MODE                        --计息方式
    ,ACT_END_DT                           --实际终止日期
    ,APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT                --约定返售或回购利息
    ,AMT                                  --发生额
    ,STL_AMT                              --结算金额
    ,INT_AMT                              --利息金额
    ,CNTPTY_NAME                          --交易对手名称
    ,CNTPTY_BANK_NO                       --交易对手行号
    ,DEPT_LINE                            --部门条线
    ,DATA_SRC                             --数据来源
    ,CTR_NT_ID                            --成交单号
    ,BUS_ID                               --业务编号
    ,CURRT_ACRU_INT                       --当期应计利息 ADD BY 20221124 XUCX
    ,CNTPTY_CUST_ID                       --交易对手客户编号
    ,ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期 ADD BY 20230105 XUCX
    ,SUBJ_ID                              --科目编号
    ,HOLD_DAYS                            --持票天数
    ,STL_DT                               --结算日期
    )
  SELECT T.DATA_DT                              --数据日期
        ,T.LGL_REP_ID                           --法人编号
        ,T.CUST_ID                              --客户编号
        ,T.ORG_ID                               --机构编号
        ,T.ACC_ID                               --账户编号
        ,T.ACC_TYP                              --账户类型
        ,T.CUR                                  --币种
        ,T.REPO_BIZ_TYP                         --回购业务类型
        ,T.ULYG_AST_TYP                         --标的资产类型
        ,T.ULYG_PROD_ID                         --标的产品编号
        ,T.OPR_TYP                              --经营类型
        ,T.BAL                                  --余额
        ,T.INT                                  --利息
        ,T.NEXT_INT_PAY_DT                      --下一付息日
        ,T.START_DT                             --起始日期
        ,T.EXP_DT                               --到期日期
        ,T.RATE_RE_PRC_DT                       --利率重新定价日期
        ,T.INT_CALC_FLG                         --计息标志
        ,T.ULYG_MKT_VAL                         --标的物市场价值
        ,T.NET_AMT_SETL_AGRT_NO                 --净额结算协议号
        ,T.APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
        ,T.RSK_EXP_DISC_COE                     --风险暴露折扣系数
        ,T.FIN_PLG_DISC_COE                     --金融质押品折扣系数
        ,T.FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
        ,T.ACT_RATE                             --实际利率
        ,T.BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
        ,T.BASE_RATE                            --基准利率
        ,T.RATE_FLT_FREQ                        --利率浮动频率
        ,T.PRC_BASE_TYP                         --定价基准类型
        ,T.INT_CALC_MODE                        --计息方式
        ,T.ACT_END_DT                           --实际终止日期
        ,T.APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
        ,T.APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
        ,T.APPT_RESL_OR_REPO_INT                --约定返售或回购利息
        ,T.AMT                                  --发生额
        ,T.STL_AMT                              --结算金额
        ,T.INT_AMT                              --利息金额
        ,T.CNTPTY_NAME                          --交易对手名称
        ,T.CNTPTY_BANK_NO                       --交易对手行号
        ,T.DEPT_LINE                            --部门条线
        ,T.DATA_SRC                             --数据来源
        ,T.CTR_NT_ID                            --成交单号
        ,T.BUS_ID                               --业务编号
        ,T.CURRT_ACRU_INT                       --当期应计利息
        ,T.CNTPTY_CUST_ID                       --交易对手客户编号
        ,T.ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期
        ,T.SUBJ_ID                              --科目编号
        ,T.HOLD_DAYS                            --持票天数
        ,T.STL_DT                               --结算日期
    FROM (
    SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')            AS DATA_DT                              --数据日期
          ,A.LP_ID                                 AS LGL_REP_ID                           --法人编号
          ,B.CUST_ID                               AS CUST_ID                              --客户编号
          ,A.ACCT_INSTIT_ID                        AS ORG_ID                               --机构编号
          ,A.BUS_ID                                AS ACC_ID                               --账户编号
          ,NULL                                    AS ACC_TYP                              --账户类型
          ,A.CURR_CD                               AS CUR                                  --币种
          ,CASE WHEN A.BUS_TYPE_CD = 'BT02' THEN '20101'
                WHEN A.BUS_TYPE_CD = 'BT03' THEN '20102'
            END                                    AS REPO_BIZ_TYP                         --回购业务类型 BT02-质押式回购 BT03-买断式回购
          ,'2'                                     AS ULYG_AST_TYP                         --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
          ,A.BILL_ID                               AS ULYG_PROD_ID                         --标的产品编号
          ,'A'                                     AS OPR_TYP                              --经营类型
          ,A.CURRT_BAL                             AS BAL                                  --余额 当期余额 --MD BY 20220804 XUCX
          ,A.CURRT_ACRU_INT                        AS INT                                  --利息 当期应计利息 --MD BY 20220804 XUCX
          ,NULL                                    AS NEXT_INT_PAY_DT                      --下一付息日
          ,TO_CHAR(A.BUS_DT,'YYYYMMDD')            AS START_DT                             --起始日期 --modify 20220617 根据源系统口径修改 laihaiqiang
          ,TO_CHAR(A.EXP_DT,'YYYYMMDD')            AS EXP_DT                               --到期日期
          ,TO_CHAR(A.EXP_DT,'YYYYMMDD')            AS RATE_RE_PRC_DT                       --利率重新定价日期
          ,'1'                                     AS INT_CALC_FLG                         --计息标志
          ,NULL                                    AS ULYG_MKT_VAL                         --标的物市场价值
          ,NULL                                    AS NET_AMT_SETL_AGRT_NO                 --净额结算协议号
          ,A.REPO_AMT                              AS APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
          ,NULL                                    AS RSK_EXP_DISC_COE                     --风险暴露折扣系数
          ,NULL                                    AS FIN_PLG_DISC_COE                     --金融质押品折扣系数
          ,NULL                                    AS FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
          ,A.DISCNT_INT_RAT                        AS ACT_RATE                             --实际利率
          ,NULL                                    AS BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
          ,NULL                                    AS BASE_RATE                            --基准利率
          ,NULL                                    AS RATE_FLT_FREQ                        --利率浮动频率
          ,NULL                                    AS PRC_BASE_TYP                         --定价基准类型
          ,NULL                                    AS INT_CALC_MODE                        --计息方式
          ,TO_CHAR(A.ACTL_EXP_DT,'YYYYMMDD')       AS ACT_END_DT                           --实际终止日期
          ,TO_CHAR(A.REPO_DT,'YYYYMMDD')           AS APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
          --MODIFY 20220607 修改买断式和质押式回购利率取值 LAIHAIQIANG
          ,CASE WHEN A.BUS_TYPE_CD = 'BT02' THEN A.DISCNT_INT_RAT
                WHEN A.BUS_TYPE_CD = 'BT03' THEN A.REDEM_INT_RAT
            END                                    AS APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
          --MODIFY 20220607 修改买断式和质押式回购利息取值 LAIHAIQIANG
          ,CASE WHEN A.BUS_TYPE_CD = 'BT02' THEN A.INT_AMT
                WHEN A.BUS_TYPE_CD = 'BT03' THEN A.REPO_INT_AMT
            END                                    AS APPT_RESL_OR_REPO_INT                --约定返售或回购利息
          ,A.FAC_VAL_AMT                           AS AMT                                  --发生额
          ,A.STL_AMT                               AS STL_AMT                              --结算金额
          ,A.INT_AMT                               AS INT_AMT                              --利息金额
          ,A.CNTPTY_NAME                           AS CNTPTY_NAME                          --交易对手名称
          ,A.CNTPTY_BANK_NO                        AS CNTPTY_BANK_NO                       --交易对手行号
          ,'800935'                                AS DEPT_LINE                            --部门条线 /*票据业务事业部*/
          ,'买入返售'                              AS DATA_SRC                             --数据来源
          ,A.CTR_NT_ID                             AS CTR_NT_ID                            --成交单号
          ,A.BUS_ID                                AS BUS_ID                               --业务编号
          ,A.CURRT_ACRU_INT                        AS CURRT_ACRU_INT                       --当期应计利息
          ,A.CNTPTY_ID                             AS CNTPTY_CUST_ID                       --交易对手客户编号
          ,TO_CHAR(A.ACTL_REPO_DT,'YYYYMMDD')      AS ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期
          ,A.SUBJ_ID                               AS SUBJ_ID                              --科目编号
          ,A.HOLD_DAYS                             AS HOLD_DAYS                            --持票天数
          ,TO_CHAR(A.STL_DT,'YYYYMMDD')            AS STL_DT                               --结算日期
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
      LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO B --票据中心信息
        ON B.BILL_ID = A.BILL_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
     WHERE A.TRAN_DIR_CD = '02' --卖出 待确认是否02是卖出 --MODIFY BY MW 20221207上游调整码值
       AND A.BUS_TYPE_CD IN ('BT02','BT03') --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
       AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --插入资金债券回购信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金债券回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_LBY_INFO
    (DATA_DT                              --数据日期
    ,LGL_REP_ID                           --法人编号
    ,CUST_ID                              --客户编号
    ,ORG_ID                               --机构编号
    ,ACC_ID                               --账户编号
    ,ACC_TYP                              --账户类型
    ,CUR                                  --币种
    ,REPO_BIZ_TYP                         --回购业务类型
    ,ULYG_AST_TYP                         --标的资产类型
    ,ULYG_PROD_ID                         --标的产品编号
    ,OPR_TYP                              --经营类型
    ,BAL                                  --余额
    ,INT                                  --利息
    ,NEXT_INT_PAY_DT                      --下一付息日
    ,START_DT                             --起始日期
    ,EXP_DT                               --到期日期
    ,RATE_RE_PRC_DT                       --利率重新定价日期
    ,INT_CALC_FLG                         --计息标志
    ,ULYG_MKT_VAL                         --标的物市场价值
    ,NET_AMT_SETL_AGRT_NO                 --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
    ,RSK_EXP_DISC_COE                     --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                     --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                             --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
    ,BASE_RATE                            --基准利率
    ,RATE_FLT_FREQ                        --利率浮动频率
    ,PRC_BASE_TYP                         --定价基准类型
    ,INT_CALC_MODE                        --计息方式
    ,ACT_END_DT                           --实际终止日期
    ,APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT                --约定返售或回购利息
    ,AMT                                  --发生额
    ,DEPT_LINE                            --部门条线
    ,DATA_SRC                             --数据来源
    ,TRAN_ID                              --交易编号
    ,BUS_ID                               --业务编号
    ,CURRT_ACRU_INT                       --当期应计利息
    ,CNTPTY_CUST_ID                       --交易对手客户编号
    ,ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期
    ,SUBJ_ID                              --科目编号
    ,REPO_ID                              --回购编号
    ,SPV_NAME                             --SPV名称
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                 AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,CASE WHEN A.CUST_ID = ' ' THEN A.CNTPTY_ID
              ELSE NVL(SPV.PARTY_ID,A.CUST_ID)
          END                                         AS CUST_ID                  --客户编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.BAG_ID                                     AS ACC_ID                   --账户编号
        ,NULL                                         AS ACC_TYP                  --账户类型
        ,A.CURR_CD                                    AS CUR                      --币种
        ,CASE WHEN STD_PROD_ID IN ('401030100001') THEN '20102'
              WHEN STD_PROD_ID IN ('401030200001') THEN '20101'
              WHEN STD_PROD_ID IN ('401030300001','401030300002') THEN '20102'
              WHEN STD_PROD_ID IN ('401030400001') THEN '20101'
          END                                         AS REPO_BIZ_TYP             --回购业务类型
        ,'1'                                          AS ULYG_AST_TYP             --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6黄金 0 其他标的物
        ,NULL                                         AS ULYG_PROD_ID             --标的产品编号
        ,'A'                                          AS OPR_TYP                  --经营类型
        ,A.CURR_BAL                                   AS BAL                      --余额 当前金额
        ,A.ACRU_INT                                   AS INT                      --利息 应计利息
        ,NULL                                         AS NEXT_INT_PAY_DT          --下一付息日
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')               AS START_DT                 --起始日期 起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS EXP_DT                   --到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS RATE_RE_PRC_DT           --利率重新定价日期
        ,'1'                                          AS INT_CALC_FLG             --计息标志
        ,NULL                                         AS ULYG_MKT_VAL             --标的物市场价值
        ,NULL                                         AS NET_AMT_SETL_AGRT_NO     --净额结算协议号
        ,NULL                                         AS APPT_RESL_OR_REPO_PRC    --约定返售或回购价格
        ,NULL                                         AS RSK_EXP_DISC_COE         --风险暴露折扣系数
        ,NULL                                         AS FIN_PLG_DISC_COE         --金融质押品折扣系数
        ,NULL                                         AS FIN_COLL_RSK_COE         --金融质押品和风险暴露币种错配系数
        ,A.REPO_INT_RAT                               AS ACT_RATE                 --实际利率
        ,NULL                                         AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
        ,NULL                                         AS BASE_RATE                --基准利率
        ,NULL                                         AS RATE_FLT_FREQ            --利率浮动频率
        ,NULL                                         AS PRC_BASE_TYP             --定价基准类型
        ,NULL                                         AS INT_CALC_MODE            --计息方式
        ,NULL                                         AS ACT_END_DT               --实际终止日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS APPT_RESL_OR_REPO_DT     --约定返售或回购日期
        ,A.REPO_INT_RAT                               AS APPT_RESL_OR_REPO_RATE   --约定返售或回购利率
        ,A.INT_RECVBL                                 AS APPT_RESL_OR_REPO_INT    --约定返售或回购利息
        ,A.TRAN_AMT                                   AS AMT                      --发生额
        ,NULL                                         AS DEPT_LINE                --部门条线
        ,'债券卖出回购'                               AS DATA_SRC                 --数据来源
        ,A.TRAN_ID                                    AS TRAN_ID                  --交易编号
        ,A.BUS_ID                                     AS BUS_ID                   --业务编号
        ,A.ACRU_INT                                   AS CURRT_ACRU_INT           --当期应计利息
        ,COALESCE(TRIM(A.CUST_ID),TRIM(E.CUST_ID),TRIM(E.CNTPTY_ID),TRIM(A.CNTPTY_ID),'-') AS CNTPTY_CUST_ID --交易对手客户编号
        ,NULL                                         AS ACTL_RESL_OR_REPO_DT     --实际返售或回购日期
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --科目编号
        ,A.REPO_ID                                    AS REPO_ID                  --回购编号
        ,SPV.SPV_NAME                                 AS SPV_NAME                 --SPV名称
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A --资金债券回购
    LEFT JOIN RRP_MDL.O_IML_PTY_CAP_CNTPTY_INFO E --资金交易对手信息 --MODIFY BY XUXIAOBIN 2022/07/12
      ON E.CNTPTY_ID = A.CNTPTY_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO SPV
      ON SPV.SPV_CUST_ID = A.CUST_ID
     AND SPV.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND SPV.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.SUBJ_ID LIKE '211102%' --卖出回购债券
     /*AND A.CURR_BAL > 0 20221031 JS是报送一个月，月中结清月底余额则为0*/
     AND A.ETL_DT= TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --插入外币回购信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入外币回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_LBY_INFO
    (DATA_DT                              --数据日期
    ,LGL_REP_ID                           --法人编号
    ,CUST_ID                              --客户编号
    ,ORG_ID                               --机构编号
    ,ACC_ID                               --账户编号
    ,ACC_TYP                              --账户类型
    ,CUR                                  --币种
    ,REPO_BIZ_TYP                         --回购业务类型
    ,ULYG_AST_TYP                         --标的资产类型
    ,ULYG_PROD_ID                         --标的产品编号
    ,OPR_TYP                              --经营类型
    ,BAL                                  --余额
    ,INT                                  --利息
    ,NEXT_INT_PAY_DT                      --下一付息日
    ,START_DT                             --起始日期
    ,EXP_DT                               --到期日期
    ,RATE_RE_PRC_DT                       --利率重新定价日期
    ,INT_CALC_FLG                         --计息标志
    ,ULYG_MKT_VAL                         --标的物市场价值
    ,NET_AMT_SETL_AGRT_NO                 --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
    ,RSK_EXP_DISC_COE                     --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                     --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                             --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
    ,BASE_RATE                            --基准利率
    ,RATE_FLT_FREQ                        --利率浮动频率
    ,PRC_BASE_TYP                         --定价基准类型
    ,INT_CALC_MODE                        --计息方式
    ,ACT_END_DT                           --实际终止日期
    ,APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT                --约定返售或回购利息
    ,AMT                                  --发生额
    ,DEPT_LINE                            --部门条线
    ,DATA_SRC                             --数据来源
    ,BUS_ID                               --业务编号
    ,CURRT_ACRU_INT                       --当期应计利息 ADD BY 20221124 XUCX
    ,CNTPTY_CUST_ID                       --交易对手客户编号
    ,ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期
    ,SUBJ_ID                              --科目编号
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                 AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,A.CUST_ID                                    AS CUST_ID                  --客户编号
        ,A.ENTRY_ORG_ID                               AS ORG_ID                   --机构编号
        ,A.BAG_ID                                     AS ACC_ID                   --账户编号 20221108 XUXIAOBIN MODIFY
        ,NULL                                         AS ACC_TYP                  --账户类型
        ,A.CURR_CD                                    AS CUR                      --币种
        ,'20101'                                      AS REPO_BIZ_TYP             --回购业务类型
        ,'1'                                          AS ULYG_AST_TYP             --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
        ,A.BOND_ID                                    AS ULYG_PROD_ID             --标的产品编号
        ,'A'                                          AS OPR_TYP                  --经营类型
        ,A.CURRT_BAL                                  AS BAL                      --余额 当期余额
        ,A.ACRU_INT                                   AS INT                      --利息 应计利息
        ,NULL                                         AS NEXT_INT_PAY_DT          --下一付息日
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')               AS START_DT                 --起始日期 起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS EXP_DT                   --到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS RATE_RE_PRC_DT           --利率重新定价日期
        ,'1'                                          AS INT_CALC_FLG             --计息标志
        ,NULL                                         AS ULYG_MKT_VAL             --标的物市场价值
        ,NULL                                         AS NET_AMT_SETL_AGRT_NO     --净额结算协议号
        ,NULL                                         AS APPT_RESL_OR_REPO_PRC    --约定返售或回购价格
        ,NULL                                         AS RSK_EXP_DISC_COE         --风险暴露折扣系数
        ,NULL                                         AS FIN_PLG_DISC_COE         --金融质押品折扣系数
        ,NULL                                         AS FIN_COLL_RSK_COE         --金融质押品和风险暴露币种错配系数
        ,A.EXEC_INT_RAT                               AS ACT_RATE                 --实际利率
        ,NULL                                         AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
        ,A.BASE_RAT                                   AS BASE_RATE                --基准利率
        ,NULL                                         AS RATE_FLT_FREQ            --利率浮动频率
        ,NULL                                         AS PRC_BASE_TYP             --定价基准类型
        ,'07'                                         AS INT_CALC_MODE            --计息方式--20220929 XUXIAOBIN ADD
        ,NULL                                         AS ACT_END_DT               --实际终止日期
        ,NULL                                         AS APPT_RESL_OR_REPO_DT     --约定返售或回购日期
        ,NULL                                         AS APPT_RESL_OR_REPO_RATE   --约定返售或回购利率
        ,NULL                                         AS APPT_RESL_OR_REPO_INT    --约定返售或回购利息
        ,A.TRAN_AMT                                   AS AMT                      --发生额
        ,NULL                                         AS DEPT_LINE                --部门条线
        ,'外币卖出回购'                               AS DATA_SRC                 --数据来源
        ,A.BUS_ID                                     AS BUS_ID                   --业务编号
        ,A.CURRT_ACRU_INT                             AS CURRT_ACRU_INT           --当期应计利息 add by 20221124 xucx
        ,A.CUST_ID                                    AS CNTPTY_CUST_ID           --交易对手客户编号
        ,NULL                                         AS ACTL_RESL_OR_REPO_DT     --实际返售或回购日期
        ,A.SUBJ_ID                                    AS SUBJ_ID                  --科目编号
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
   WHERE A.SUBJ_ID LIKE '211102%' --外汇拆借卖出回购
     --AND A.CURRT_BAL > 0 20221031 JS是报送一个月，月中结清月底余额则为0
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --插入同业现金借贷回购信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入同业现金借贷回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_LBY_INFO
    (DATA_DT                              --数据日期
    ,LGL_REP_ID                           --法人编号
    ,CUST_ID                              --客户编号
    ,ORG_ID                               --机构编号
    ,ACC_ID                               --账户编号
    ,ACC_TYP                              --账户类型
    ,CUR                                  --币种
    ,REPO_BIZ_TYP                         --回购业务类型
    ,ULYG_AST_TYP                         --标的资产类型
    ,ULYG_PROD_ID                         --标的产品编号
    ,OPR_TYP                              --经营类型
    ,BAL                                  --余额
    ,INT                                  --利息
    ,NEXT_INT_PAY_DT                      --下一付息日
    ,START_DT                             --起始日期
    ,EXP_DT                               --到期日期
    ,RATE_RE_PRC_DT                       --利率重新定价日期
    ,INT_CALC_FLG                         --计息标志
    ,ULYG_MKT_VAL                         --标的物市场价值
    ,NET_AMT_SETL_AGRT_NO                 --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC                --约定返售或回购价格
    ,RSK_EXP_DISC_COE                     --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                     --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                     --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                             --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE             --业务发生时点实际利率
    ,BASE_RATE                            --基准利率
    ,RATE_FLT_FREQ                        --利率浮动频率
    ,PRC_BASE_TYP                         --定价基准类型
    ,INT_CALC_MODE                        --计息方式
    ,ACT_END_DT                           --实际终止日期
    ,APPT_RESL_OR_REPO_DT                 --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT                --约定返售或回购利息
    ,AMT                                  --发生额
    ,DEPT_LINE                            --部门条线
    ,DATA_SRC                             --数据来源
    ,BUS_ID                               --业务编号
    ,CURRT_ACRU_INT                       --当期应计利息 add by 20221124 xucx
    ,CNTPTY_CUST_ID                       --交易对手客户编号
    ,ACTL_RESL_OR_REPO_DT                 --实际返售或回购日期
    ,SUBJ_ID                              --科目编号
    ,STL_DT                               --结算日期 --ADD BY LIP 20241120
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                 AS DATA_DT                  --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID               --法人编号
        ,CASE WHEN NVL(TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-')) = '-' THEN '9620007313'
              ELSE NVL(TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID), '-'))
          END                                         AS CUST_ID                  --客户编号 --存款保险用CUST_ID_DIIS填报客户编号
        ,A.BELONG_ORG_ID                              AS ORG_ID                   --机构编号
        ,A.BUS_ID                                     AS ACC_ID                   --账户编号
        ,NULL                                         AS ACC_TYP                  --账户类型
        ,A.CURR_CD                                    AS CUR                      --币种
        ,CASE WHEN A.STD_PROD_ID IN ('401030100001','401030300001','401030300002') THEN '20102'
              WHEN A.STD_PROD_ID IN ('401030200001','401030400001') THEN '20101'
          END                                         AS REPO_BIZ_TYP             --回购业务类型 --MOD BY 20240521
        ,'1'                                          AS ULYG_AST_TYP             --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
        ,A.FIN_INSTM_ID                               AS ULYG_PROD_ID             --标的产品编号
        ,'A'                                          AS OPR_TYP                  --经营类型
        ,ABS(A.CURRT_BAL)                             AS BAL                      --余额 当期余额 --MOD BY 20240521
        ,A.ACRU_INT                                   AS INT                      --利息 应计利息
        ,NULL                                         AS NEXT_INT_PAY_DT          --下一付息日
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')               AS START_DT                 --起始日期  起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS EXP_DT                   --到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS RATE_RE_PRC_DT           --利率重新定价日期
        ,'1'                                          AS INT_CALC_FLG             --计息标志
        ,NULL                                         AS ULYG_MKT_VAL             --标的物市场价值
        ,NULL                                         AS NET_AMT_SETL_AGRT_NO     --净额结算协议号
        ,NULL                                         AS APPT_RESL_OR_REPO_PRC    --约定返售或回购价格
        ,NULL                                         AS RSK_EXP_DISC_COE         --风险暴露折扣系数
        ,NULL                                         AS FIN_PLG_DISC_COE         --金融质押品折扣系数
        ,NULL                                         AS FIN_COLL_RSK_COE         --金融质押品和风险暴露币种错配系数
        ,A.FAC_VAL_INT_RAT                            AS ACT_RATE                 --实际利率
        ,NULL                                         AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
        ,A.BASE_RAT                                   AS BASE_RATE                --基准利率
        ,NULL                                         AS RATE_FLT_FREQ            --利率浮动频率
        ,NULL                                         AS PRC_BASE_TYP             --定价基准类型
        ,CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01' --0M 按月
              WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q 按季 3M 按3个月
              WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03' --1Y 按年
              WHEN A.PAY_INT_PED_CD = '6M' THEN '06' --6M 按6个月
              --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
              ELSE '99' --其他 00 未知 0D 按日 1M 按周 4M 按4个月
          END                                          AS INT_CALC_MODE           --计息方式 --20220929 XUXIAOBIN ADD
        ,NULL                                          AS ACT_END_DT              --实际终止日期
        ,NULL                                          AS APPT_RESL_OR_REPO_DT    --约定返售或回购日期
        ,NULL                                          AS APPT_RESL_OR_REPO_RATE  --约定返售或回购利率
        ,NULL                                          AS APPT_RESL_OR_REPO_INT   --约定返售或回购利息
        ,A.TRAN_AMT                                    AS AMT                     --发生额
        ,'800935'                                      AS DEPT_LINE               --部门条线
        ,'卖出回购'                                    AS DATA_SRC                --数据来源
        ,A.BUS_ID                                      AS BUS_ID                  --业务编号
        ,A.ACRU_INT                                    AS CURRT_ACRU_INT          --当期应计利息 ADD BY 20221124 XUCX
        ,COALESCE(TRIM(A.CNTPTY_CUST_ID),TRIM(D.CUST_ID),TRIM(D.SRC_PARTY_ID),TRIM(A.CNTPTY_ID)) AS CNTPTY_CUST_ID --交易对手客户编号
        ,NULL                                          AS ACTL_RESL_OR_REPO_DT    --实际返售或回购日期
        ,A.SUBJ_ID                                     AS SUBJ_ID                 --科目编号
        ,TO_CHAR(B.TRAN_DT,'YYYYMMDD')                 AS STL_DT                  --结算日期 --ADD BY LIP 20241120
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息表 --MODIFY BY XUXIAOBIN 2022/07/12
      ON D.SRC_PARTY_ID = A.CNTPTY_ID --MODIFY BY ZM 20200903 A.CNTPTY_ID = D.PARTY_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST B --同业证券持仓 --ADD BY LIP 20241120 在该表中取交易日期
      ON B.BUS_ID = A.BUS_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.SUBJ_ID IS NOT NULL
     --AND A.SUBJ_ID LIKE '2003%' --同业现金借贷卖出回购
     --AND A.CURRT_BAL > 0 20221031 JS是报送一个月，月中结清月底余额则为0
     AND A.STD_PROD_ID LIKE '40103%' --卖出回购
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,ACC_ID,BUS_ID,COUNT(1)
    FROM RRP_MDL.M_CPTL_REPO_LBY_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ACC_ID,BUS_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
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

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_REPO_LBY_INFO;
/

