CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_LBY_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_LBY_INFO
  *  功能描述：资金业务（负债方）信息
  *  创建日期：20220607
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_LBY_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人      修改原因
  *             1    20220607  程序员      首次创建
  *             2    20220909  hulj       调整账户编号逻辑，新增字段SUB_ACC_ID --子账户编号,TIME_DWD_FLG  --定活标志,
  *                                       FIN_INSTM_ID --金融工具编号,BUS_ID --业务编号,ASSET_THD_CLS_CD --资产三分类代码
  *             3    20221031  XUXIAOBIN  修改机构编号 取原值
  *             4    20221102  XUCHANGXIN 补充利息字段的取数逻辑
  *             5    20221110  HULJ       ACCT_ID  --账户编号新增字段
  *             6    20221114  HULJ       增加数据重复校验
  *             7    20221122  XUCX       修改同业代付口径
  *             8    20230424  XUXIAOBIN  修改债券发行表间关联条件
  *             9    20230711  MW         修改同业现金借贷部分定价基准类型字段逻辑
  *             10   20230821  HULJ       新增转贷款标志字段
  *             11   20231128  HULJ       同业代付口径部分改从国结系统出数
  *             12   20240110  HYF        修改同业现金借贷部分利息字段取值
  *             13   20240116  LYH        修改同业代付 ACC_ID 取数逻辑，与发生额保持一致
  *             14   20240117  LYH        修改同业代付 实际利率、基准利率 改回原逻辑
  *             15   20240626  LIP        给标准产品编号赋值
  *             16   20241101  LIP        过滤旅通卡数据
  *             17   20250212  YJY        新增现金管理类产品标志
  *             18   20250314  LIP        调整资金同业拆借的实际到期日期取数
  *             19   20250506  LIP        调整同业现金借贷的取数，与流水表中ACC_ID取数一致，避免数据为空
  **************************************************************************/
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
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_LBY_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_CPTL_LBY_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_LBY_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_LBY_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理 --
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

  --程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金业务（负债方）信息 --存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,HDW_ACT_RATE                   --数仓实际利率 --ADD BY LIP 20231108
    ,TXY_MAIN_AGT_FILES_INT_RAT     --同兴赢主协议超档利率 --ADD BY LIP 20231108
    ,TXY_SUB_AGT_AGREE_INT_RAT      --同兴赢子协议协定利率 --ADD BY LIP 20231108
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                     AS DATA_DT                        --数据日期
        ,A.LP_ID                                          AS LGL_REP_ID                     --法人编号
        ,A.BELONG_ORG_ID                                  AS ORG_ID                         --机构编号
        ,A.CUST_ID                                        AS CUST_ID                        --客户编号
        ,A.CUST_ACCT_ID                                   AS ACC_ID                         --账户编号
        ,T1.TAR_VALUE_CODE                                AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                        AS CUR                            --币种
        ,NVL(TTB.TAR_VALUE_CODE,'20101')                  AS BIZ_TYP                        --业务类型
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                   AS START_DT                       --起始日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                     AS EXP_DT                         --到期日期
        ,CASE WHEN NVL(C.TXY_SUB_AGT_AGREE_INT_RAT,0) <> 0 THEN C.TXY_SUB_AGT_AGREE_INT_RAT
              WHEN NVL(C.TXY_MAIN_AGT_FILES_INT_RAT,0) <> 0 THEN C.TXY_MAIN_AGT_FILES_INT_RAT
              ELSE NVL(A.EXEC_INT_RAT, 0)
          END                                             AS ACT_RATE                       --实际利率
        ,A.CURRT_ACRU_INT                                 AS INT                            --利息 MD BY 20221102 XUCX
        ,NULL                                             AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                             AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,NULL                                             AS BIZ_AMT                        --业务发生金额
        ,A.CURRT_BAL                                      AS BAL                            --余额
        ,NULL                                             AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                             AS ACTP_BILL_NO                   --承兑汇票票号
        ,NULL                                             AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,CASE WHEN A.SUBJ_ID LIKE '2015%' AND A.ACCT_USAGE_CD = '6' THEN 'Y'  --2015% 同业存放  6 结算性
              WHEN A.SUBJ_ID LIKE '2015%' AND A.ACCT_USAGE_CD <> '6' THEN 'N'
              ELSE NULL
          END                                             AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')               AS OPEN_ACC_DT                    --开户日期
        ,A.OPEN_ACCT_TELLER_ID                            AS OPEN_ACC_TLR_NO                --开户柜员号
        ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')               AS CNL_ACC_DT                     --销户日期
        ,A.DEP_ACCT_STATUS_CD                             AS ACC_STAT                       --账户状态
        ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD')        AS LAST_ACC_CHG_DT                --上次动户日期
        ,NULL                                             AS DEP_STABLE_CL                  --存款稳定性分类
        ,NULL                                             AS BIZ_REL_FLG                    --具有业务关系标志
        ,NULL                                             AS ADV_DRAW_FLG                   --可提前支取标志
        ,NULL                                             AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                             AS OUTSRC_FLG                     --委外标志
        ,CASE WHEN FLOAT_INT_RAT_FLG ='1' THEN 'RF02'
              ELSE 'RF01'
          END                                             AS RATE_TYP                       --利率类型
        ,NULL                                             AS NTC_WD_DT                      --通知取款日期
        ,A.SUBJ_ID                                        AS SUBJ_ID                        --科目编号
        ,NULL                                             AS STATS_SUBJ_ID                  --统计科目编号
        ,A.ACCT_CLS_CD                                    AS PBC_ACC_TYP                    --人行账户类型
        ,A.MARGIN_FLG                                     AS MRGN_ACC_FLG                   --保证金账户标志
        ,CASE WHEN A.BASE_RAT_TYPE_CD LIKE '21%' THEN 'TR09'
              ELSE TTA.TAR_VALUE_CODE
          END                                             AS PRC_BASE_TYP                   --定价基准类型
        ,A.BASE_RAT                                       AS RATE_FLT_FREQ                  --利率浮动频率
        ,NULL                                             AS RATE_FLT_FREQ                  --利率浮动频率
        ,A.INT_ACCR_FLG                                   AS INT_CALC_MODE                  --计息方式
        ,NULL                                             AS ACT_END_DT                     --实际终止日期
        ,CASE WHEN A.SUBJ_ID = '20150101' THEN 'DR01'
              ELSE 'DR03'  --20221230 与业务陆炜迪确认
          END                                             AS DEP_RSV_MODE                   --缴存准备金方式
        ,CASE WHEN A.EC_FLG = '0' THEN '02'--钞
              WHEN A.EC_FLG = '1' THEN '03'--汇
              WHEN A.EC_FLG = '2' THEN '04'--可钞可汇
              ELSE '01'
          END                                             AS CASH_REMIT_FLG                 --钞汇标志
        ,NULL                                             AS DEPT_LINE                      --部门条线
        ,'存款分户-同业存放'                              AS DATA_SRC                       --数据来源
        ,NVL(A.OLD_CUST_ACCT_SUB_ACCT_NUM,A.CUST_ACCT_SUB_ACCT_NUM) AS SUB_ACC_ID           --子账户编号
        ,NULL                                             AS FIN_INSTM_ID                   --金融工具编号
        ,NULL                                             AS BUS_ID                         --业务编号
        ,NULL                                             AS ASSET_THD_CLS_CD               --资产三分类代码
        ,A.RC_FLG                                         AS TIME_DWD_FLG                   --定活标志 20220923 许晓滨
        ,A.STD_PROD_ID                                    AS STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
        ,A.ACCT_ID                                        AS ACCT_ID                        --账户编号  20221110 hulj add
        ,A.STOP_PAY_STATUS_CD                             AS STOP_PAY_STATUS_CD             --止付状态代码
        ,A.FROZ_FLG                                       AS FROZ_FLG                       --冻结标志
        ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1'
              ELSE '0'
         END                                              AS LG_FROZ_FLG      --司法冻结标志
        ,A.CUST_ACCT_SUB_ACCT_NUM                         AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
        ,A.EXEC_INT_RAT                                   AS HDW_ACT_RATE                   --数仓实际利率 --ADD BY LIP 20231108
        ,C.TXY_MAIN_AGT_FILES_INT_RAT                     AS TXY_MAIN_AGT_FILES_INT_RAT     --同兴赢主协议超档利率 --ADD BY LIP 20231108
        ,C.TXY_SUB_AGT_AGREE_INT_RAT                      AS TXY_SUB_AGT_AGREE_INT_RAT      --同兴赢子协议协定利率 --ADD BY LIP 20231108
        ,CASE WHEN C.CASH_MANAGE_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                              AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A  --存款分户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO C --存款分户补充信息
      ON C.ACCT_ID = A.ACCT_ID
     AND NVL(C.TRAVEL_CARD_ACCT_FLG,'0') = '0' --MOD BY LIP 20241101 过滤旅通卡数据
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP T1
      ON T1.SRC_VALUE_CODE = A.ACCT_ATTR_CD
     AND T1.SRC_CLASS_CODE = 'CD1924'
     AND T1.TAR_CLASS_CODE = 'P0004'
     AND T1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --定价基准方式转码
      ON TTA.SRC_VALUE_CODE = A.BASE_RAT_TYPE_CD
     AND TTA.SRC_CLASS_CODE = 'CD1010'
     AND TTA.TAR_CLASS_CODE = 'Z0015'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TTB
      ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTB.SRC_CLASS_CODE = 'STD0003'
     AND TTB.TAR_CLASS_CODE = 'T0010'
     AND TTB.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT DISTINCT DEP_SUB_ACCT_ID
                 FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
                WHERE FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
                  AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
                  AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')--冻结截止日期
                  AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) DJ
      ON DJ.DEP_SUB_ACCT_ID = A.ACCT_ID
   WHERE (A.SUBJ_ID LIKE '2015%' OR A.SUBJ_ID LIKE '2016%' OR A.SUBJ_ID LIKE '2017%') /*同业*/
     AND A.CORP_ACCT_FLG = '1' --只取对公*
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*******************资金同业拆借*******************/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业拆入（无押品）数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  WITH CAP_IB_LEND_CLEAR AS (
  SELECT /*+MATERIALIZE*/NB.*,
         ROW_NUMBER() OVER(PARTITION BY NB.MINORASSETCODE ORDER BY NB.SETTLEDATE DESC, NB.BALANCE_ID DESC) RN
    FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE NB
   WHERE NB.ASSETTYPE = '拆借'
     AND NB.HOLDPOSITION = 0
     AND NVL(NB.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
     AND NB.SETTLEDATE <= V_P_DATE
     AND NB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND NB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT                        --数据日期
        ,A.LP_ID                                  AS LGL_REP_ID                     --法人编号
        ,A.ENTRY_ORG_ID                           AS ORG_ID                         --机构编号
        ,A.CUST_ID                                AS CUST_ID                        --客户编号
        ,A.BAG_ID                                 AS ACC_ID                         --账户编号
        ,NULL                                     AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                AS CUR                            --币种
        ,NVL(TTB.TAR_VALUE_CODE,'202')            AS BIZ_TYP                        --业务类型 202同业拆入 205同业借款 201 同业存放 206同业存单发行
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')           AS START_DT                       --起始日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS EXP_DT                         --到期日期
        ,NVL(A.EXEC_INT_RAT,0)                    AS ACT_RATE                       --实际利率
        ,A.CURRT_ACRU_INT                         AS INT                            --利息 当期应计利息
        ,NULL                                     AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                     AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,NULL                                     AS BIZ_AMT                        --业务发生金额
        ,A.CURRT_BAL                              AS BAL                            --余额
        ,'0'                                      AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                     AS ACTP_BILL_NO                   --承兑汇票票号
        ,NULL                                     AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,NULL                                     AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')           AS OPEN_ACC_DT                    --开户日期
        ,NULL                                     AS OPEN_ACC_TLR_NO                --开户柜员号
        --,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS CNL_ACC_DT                     --销户日期
        ,TO_CHAR(TA.SETTLEDATE)                   AS CNL_ACC_DT                     --销户日期 --MOD BY LIP 20250314
        ,NULL                                     AS ACC_STAT                       --账户状态
        ,NULL                                     AS LAST_ACC_CHG_DT                --上次动户日期
        ,NULL                                     AS DEP_STABLE_CL                  --存款稳定性分类
        ,NULL                                     AS BIZ_REL_FLG                    --具有业务关系标志
        ,NULL                                     AS ADV_DRAW_FLG                   --可提前支取标志
        ,NULL                                     AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                     AS OUTSRC_FLG                     --委外标志
        ,'RF01'                                   AS RATE_TYP                       --利率类型
        ,NULL                                     AS NTC_WD_DT                      --通知取款日期
        ,A.SUBJ_ID                                AS SUBJ_ID                        --科目编号
        ,NULL                                     AS STATS_SUBJ_ID                  --统计科目编号
        ,'TYCR'                                   AS PBC_ACC_TYP                    --人行账户类型 --20220623 XUXIAOBIN
        ,NULL                                     AS MRGN_ACC_FLG                   --保证金账户标志
        ,NULL                                     AS PRC_BASE_TYP                   --定价基准类型
        ,NULL                                     AS BASE_RATE                      --基准利率
        ,NULL                                     AS RATE_FLT_FREQ                  --利率浮动频率
        ,'07'                                     AS INT_CALC_MODE                  --计息方式 --20220929 XUXIAOBIN ADD
        /*,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') = V_P_DATE
              THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
              ELSE NULL
          END                                     AS ACT_END_DT                     --实际终止日期*/
        ,TO_CHAR(TA.SETTLEDATE)                   AS ACT_END_DT                     --实际终止日期 --MOD BY LIP 20250314
        ,NULL                                     AS DEP_RSV_MODE                   --缴存准备金方式式
        ,NULL                                     AS CASH_REMIT_FLG                 --钞汇标志
        ,NULL                                     AS DEPT_LINE                      --部门条线
        ,'资金同业拆借'                           AS DATA_SRC                       --数据来源
        ,NULL                                     AS SUB_ACC_ID                     --子账户编号
        ,NULL                                     AS FIN_INSTM_ID                   --金融工具编号
        ,A.TRAN_ID                                AS BUS_ID                         --业务编号--MODIFY CCH 20221017 根据IMAS生产数据修改
        ,A.ASSET_THD_CLS_CD                       AS ASSET_THD_CLS_CD               --资产三分类代码
        ,NULL                                     AS TIME_DWD_FLG                   --定活标志 20220923 许晓滨
        ,A.STD_PROD_ID                            AS STD_PROD_ID                    --标准产品编号 --MOD BY LIP 20240626
        ,NULL                                     AS ACCT_ID                        --账户编号 HULJ 20221110 ADD
        ,NULL                                     AS STOP_PAY_STATUS_CD             --止付状态代码
        ,NULL                                     AS FROZ_FLG                       --冻结标志
        ,NULL                                     AS LG_FROZ_FLG                    --司法冻结标志
        ,NULL                                     AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
        ,NULL                                     AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A --资金同业拆借
    LEFT JOIN CAP_IB_LEND_CLEAR TA --拆借结清日期 --ADD BY LIP 20250314
      ON TA.MINORASSETCODE = A.BUS_ID
     AND TA.RN = 1  -- MOD BY YJY 20250323
    LEFT JOIN RRP_MDL.CODE_MAP TTB --业务类型
      ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTB.SRC_CLASS_CODE = 'STD0003'
     AND TTB.TAR_CLASS_CODE = 'T0010'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.SUBJ_ID LIKE '2003%'  --拆入同业款项 20221010 XUXIAOBIN modify
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*******************外汇同业拆借*******************/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金（负债方）信息 --外汇同业拆入（无押品）数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT                        --数据日期
        ,A.LP_ID                                  AS LGL_REP_ID                     --法人编号
        ,A.ENTRY_ORG_ID                           AS ORG_ID                         --机构编号
        ,A.CUST_ID                                AS CUST_ID                        --客户编号
        ,A.BAG_ID                                 AS ACC_ID                         --账户编号
        ,NULL                                     AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                AS CUR                            --币种
        ,NVL(TTB.TAR_VALUE_CODE,'202')            AS BIZ_TYP                        --业务类型 202同业拆入 205同业借款 201 同业存放 206同业存单发行
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')           AS START_DT                       --起始日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS EXP_DT                         --到期日期
        ,NVL(A.EXEC_INT_RAT,0)                    AS ACT_RATE                       --实际利率
        ,A.CURRT_ACRU_INT                         AS INT                            --利息
        ,NULL                                     AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                     AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,NULL                                     AS BIZ_AMT                        --业务发生金额
        ,A.CURRT_BAL                              AS BAL                            --余额
        ,'0'                                      AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                     AS ACTP_BILL_NO                   --承兑汇票票号
        ,NULL                                     AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,NULL                                     AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,NULL                                     AS OPEN_ACC_DT                    --开户日期
        ,NULL                                     AS OPEN_ACC_TLR_NO                --开户柜员号
        ,NULL                                     AS CNL_ACC_DT                     --销户日期
        ,NULL                                     AS ACC_STAT                       --账户状态
        ,NULL                                     AS LAST_ACC_CHG_DT                --上次动户日期
        ,NULL                                     AS DEP_STABLE_CL                  --存款稳定性分类
        ,NULL                                     AS BIZ_REL_FLG                    --具有业务关系标志
        ,NULL                                     AS ADV_DRAW_FLG                   --可提前支取标志
        ,NULL                                     AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                     AS OUTSRC_FLG                     --委外标志
        ,'RF01'                                   AS RATE_TYP                       --利率类型
        ,NULL                                     AS NTC_WD_DT                      --通知取款日期
        ,A.SUBJ_ID                                AS SUBJ_ID                        --科目编号
        ,NULL                                     AS STATS_SUBJ_ID                  --统计科目编号
        ,'TYCR'                                   AS PBC_ACC_TYP                    --人行账户类型 --20220623 XUXIAOBIN
        ,NULL                                     AS MRGN_ACC_FLG                   --保证金账户标志
        ,NULL                                     AS PRC_BASE_TYP                   --定价基准类型
        ,A.BASE_RAT                               AS BASE_RATE                      --基准利率
        ,NULL                                     AS RATE_FLT_FREQ                  --利率浮动频率
        ,'07'                                     AS INT_CALC_MODE                  --计息方式 --20220929 XUXIAOBIN ADD
        ,NULL                                     AS ACT_END_DT                     --实际终止日期
        ,NULL                                     AS DEP_RSV_MODE                   --缴存准备金方式
        ,NULL                                     AS CASH_REMIT_FLG                 --钞汇标志
        ,NULL                                     AS DEPT_LINE                      --部门条线 --计划财务部
        ,'外汇同业拆借'                           AS DATA_SRC                       --数据来源
        ,NULL                                     AS SUB_ACC_ID                     --子账户编号
        ,NULL                                     AS FIN_INSTM_ID                   --金融工具编号
        ,A.BUS_ID                                 AS BUS_ID                         --业务编号
        ,A.ASSET_THD_CLS_CD                       AS ASSET_THD_CLS_CD               --资产三分类代码
        ,NULL                                     AS TIME_DWD_FLG                   --定活标志 20220923 许晓滨
        ,A.STD_PROD_ID                            AS STD_PROD_ID                    --标准产品编号 --MOD BY LIP 20240626
        ,NULL                                     AS ACCT_ID                        --账户编号 HULJ 20221110 ADD
        ,NULL                                     AS STOP_PAY_STATUS_CD             --止付状态代码
        ,NULL                                     AS FROZ_FLG                       --冻结标志
        ,NULL                                     AS LG_FROZ_FLG                    --司法冻结标志
        ,NULL                                     AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
        ,NULL                                     AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --业务类型
      ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTB.SRC_CLASS_CODE = 'STD0003'
     AND TTB.TAR_CLASS_CODE = 'T0010'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.SUBJ_ID LIKE '2003%'  --拆入同业 20221010 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*******************同业现金借贷表*******************/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业借款（无押品）';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 --20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号 --20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 --HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,TRANS_LOAN_FLG                 --转贷款标志
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT                        --数据日期
        ,A.LP_ID                                  AS LGL_REP_ID                     --法人编号
        ,A.BELONG_ORG_ID                          AS ORG_ID                         --机构编号
        ,A.CNTPTY_CUST_ID                         AS CUST_ID                        --客户编号
        --,A.ACCT_ID                                AS ACC_ID                         --账户编号
        ,NVL(TRIM(A.ACCT_ID),A.FIN_INSTM_ID)      AS ACC_ID                         --账户编号 --MOD BY LIP 20250506
        ,NULL                                     AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                AS CUR                            --币种
        ,NVL(TTB.TAR_VALUE_CODE,'205')            AS BIZ_TYP                        --业务类型  202同业拆入 205同业借款 201 同业存放  206同业存单发行
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')           AS START_DT                       --起始日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS EXP_DT                         --到期日期
        ,NVL(A.EXEC_INT_RAT,0)                    AS ACT_RATE                       --实际利率
        ,ABS(A.INT_RECVBL)                        AS INT                            --利息 --MDF HYF 20240110 应收利息
        ,NULL                                     AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                     AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,NULL                                     AS BIZ_AMT                        --业务发生金额
        ,ABS(A.ACTL_BAL)                          AS BAL                            --余额
        ,'0'                                      AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                     AS ACTP_BILL_NO                   --承兑汇票票号
        ,NULL                                     AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,NULL                                     AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,NULL                                     AS OPEN_ACC_DT                    --开户日期
        ,NULL                                     AS OPEN_ACC_TLR_NO                --开户柜员号
        ,NULL                                     AS CNL_ACC_DT                     --销户日期
        ,NULL                                     AS ACC_STAT                       --账户状态
        ,NULL                                     AS LAST_ACC_CHG_DT                --上次动户日期
        ,NULL                                     AS DEP_STABLE_CL                  --存款稳定性分类
        ,NULL                                     AS BIZ_REL_FLG                    --具有业务关系标志
        ,NULL                                     AS ADV_DRAW_FLG                   --可提前支取标志
        ,NULL                                     AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                     AS OUTSRC_FLG                     --委外标志
        ,CASE WHEN A.INT_RAT_ADJ_WAY_CD = '1' THEN 'RF01'
              ELSE 'RF02'
          END                                     AS RATE_TYP                       --利率类型
        ,NULL                                     AS NTC_WD_DT                      --通知取款日期
        ,A.SUBJ_ID                                AS SUBJ_ID                        --科目编号
        ,NULL                                     AS STATS_SUBJ_ID                  --统计科目编号
        ,'TYXJJD'                                 AS PBC_ACC_TYP                    --人行账户类型 --20220623 XUXIAOBIN
        ,NULL                                     AS MRGN_ACC_FLG                   --保证金账户标志
        ,CASE WHEN A.BASE_RAT_TYPE_CD IN 'LPR_1Y'
              THEN 'TR07' --LPR利率
          END                                     AS PRC_BASE_TYP                   --定价基准类型
        ,A.BASE_RAT                               AS BASE_RATE                      --基准利率
        ,NULL                                     AS RATE_FLT_FREQ                  --利率浮动频率
        ,CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01'--0M  按月
              WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q  按季 3M  按3个月
              WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03'--1Y  按年
              WHEN A.PAY_INT_PED_CD = '6M' THEN '06'--6M  按6个月
              --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
              ELSE '99' --其他 00  未知 0D  按日 1M  按周 4M  按4个月
          END                                     AS INT_CALC_MODE                  --计息方式 --20220929 XUXIAOBIN ADD
        ,NULL                                     AS ACT_END_DT                     --实际终止日期
        ,NULL                                     AS DEP_RSV_MODE                   --缴存准备金方式
        ,NULL                                     AS CASH_REMIT_FLG                 --钞汇标志
        ,NULL                                     AS DEPT_LINE                      --部门条线
        ,'同业现金借贷'                           AS DATA_SRC                       --数据来源
        ,NULL                                     AS SUB_ACC_ID                     --子账户编号
        ,A.FIN_INSTM_ID                           AS FIN_INSTM_ID                   --金融工具编号
        ,A.BUS_ID                                 AS BUS_ID                         --业务编号
        ,A.ASSET_THD_CLS_CD                       AS ASSET_THD_CLS_CD               --资产三分类代码
        ,NULL                                     AS TIME_DWD_FLG                   --定活标志 20220923 许晓滨
        --,NULL                                     AS STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
        ,A.STD_PROD_ID                            AS STD_PROD_ID                    --标准产品编号 --MOD BY LIP 20240626
        ,NULL                                     AS ACCT_ID                        --账户编号 hulj 20221110 add
        ,NULL                                     AS STOP_PAY_STATUS_CD             --止付状态代码
        ,NULL                                     AS FROZ_FLG                       --冻结标志
        ,NULL                                     AS LG_FROZ_FLG                    --司法冻结标志
        ,NULL                                     AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
        ,A.TRANS_LOAN_FLG                         AS TRANS_LOAN_FLG                 --转贷款标志
        ,NULL                                     AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --业务类型
      ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTB.SRC_CLASS_CODE = 'STD0003'
     AND TTB.TAR_CLASS_CODE = 'T0010'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.SUBJ_ID LIKE '200303%' --同业借款 --20220929 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业代付';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,ERA_PAY_BANK_CUST_NAME         --代付行客户名称
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  SELECT V_P_DATE                                  AS DATA_DT                       --数据日期
         ,A.LP_ID                                  AS LGL_REP_ID                    --法人编号
         ,A.BELONG_ORG_ID                          AS ORG_ID                        --机构编号
         ,TRIM(A.ERA_PAY_BANK_CUST_ID)             AS CUST_ID                       --客户编号
         ,B.CONT_ID                                AS ACC_ID                        --账户编号 MOD BY LYH 20240116
         ,NULL                                     AS ACC_TYP                       --账户类型
         ,A.CURR_CD                                AS CUR                           --币种
         ,'20203'                                  AS BIZ_TYP                       --业务类型 103同业借款 101存放同业 10203同业代付
         ,TO_CHAR(A.TRUST_OPEN_DT,'YYYYMMDD')      AS START_DT                      --起始日期
         ,TO_CHAR(A.TRUST_EXP_DT,'YYYYMMDD')       AS EXP_DT                        --到期日期
         ,B.EXEC_INT_RAT                           AS ACT_RATE                      --实际利率 MOD BY LYH 20240117
         ,A.CURRT_INT_AMT                          AS INT                           --利息
         ,NULL                                     AS NEXT_INT_PAY_DT               --下一付息日
         ,NULL                                     AS RATE_RE_PRC_DT                --利率重新定价日期
         ,CAST(0 AS NUMBER(30,2))                  AS BIZ_AMT                       --业务发生金额
         ,A.PAYBL_PRIC_BAL                         AS BAL                           --余额
         ,'1'                                      AS PEERS_PAY_FLG                 --同业代付标志
         ,NULL                                     AS ACTP_BILL_NO                  --承兑汇票票号
         ,'N'                                      AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG --外汇储备委托贷款资金标志
         ,'N'                                      AS SETL_PEERS_DEP_FLG            --结算性同业存款标志
         ,NULL                                     AS OPEN_ACC_DT                   --开户日期
         ,NULL                                     AS OPEN_ACC_TLR_NO               --开户柜员号
         ,NULL                                     AS CNL_ACC_DT                    --销户日期
         ,NULL                                     AS ACC_STAT                      --账户状态
         ,NULL                                     AS LAST_ACC_CHG_DT               --上次动户日期
         ,NULL                                     AS DEP_STABLE_CL                 --存款稳定性分类
         ,NULL                                     AS BIZ_REL_FLG                   --具有业务关系标志
         ,NULL                                     AS ADV_DRAW_FLG                  --可提前支取标志
         ,NULL                                     AS BIZ_REL_DEP_AMT               --有业务关系存款金额
         ,NULL                                     AS OUTSRC_FLG                    --委外标志
         ,'RF01'                                   AS RATE_TYP                      --利率类型
         ,NULL                                     AS NTC_WD_DT                     --通知取款日期
         ,'2202010301'                             AS SUBJ_ID                       --科目编号
         ,NULL                                     AS STATS_SUBJ_ID                 --统计科目编号
         ,'TYCR'                                   AS PBC_ACC_TYP                   --人行账户类型
         ,NULL                                     AS MRGN_ACC_FLG                  --保证金账户标志
         ,TB.TAR_VALUE_CODE                        AS PRC_BASE_TYP                  --定价基准类型
         --A.OVDUE_INT_RAT                          AS BASE_RATE,                     --基准利率 --根据数仓陈伟峰提供基准利率拿数仓的逾期利率字段
         ,B.BASE_RAT                               AS BASE_RATE                     --基准利率  MOD BY LYH 20240117
         ,TA.TAR_VALUE_CODE                        AS RATE_FLT_FREQ                 --利率浮动频率
         ,NULL                                     AS INT_CALC_MODE                 --计息方式
         ,NULL                                     AS ACT_END_DT                    --实际终止日期
         ,NULL                                     AS DEP_RSV_MODE                  --缴存准备金方式
         ,NULL                                     AS CASH_REMIT_FLG                --钞汇标志
         ,'800975'                                 AS DEPT_LINE                     --部门条线 信贷系统-委托同业代付
         ,'同业代付'                               AS DATA_SRC                      --数据来源 --计划财务部
         ,NULL                                     AS SUB_ACC_ID                    --子账户编号
         ,NULL                                     AS FIN_INSTM_ID                  --金融工具编号
         ,A.BUS_ID                                 AS BUS_ID                        --业务编号
         ,NULL                                     AS ASSET_THD_CLS_CD               --资产三分类代码
         ,NULL                                     AS TIME_DWD_FLG                   --定活标志
         ,A.STD_PROD_ID                            AS STD_PROD_ID                    --标准产品编号
         ,NULL                                     AS ACCT_ID                        --账户编号
         ,NULL                                     AS STOP_PAY_STATUS_CD             --止付状态代码
         ,NULL                                     AS FROZ_FLG                       --冻结标志
         ,NULL                                     AS LG_FROZ_FLG                    --司法冻结标志
         ,NULL                                     AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
         ,A.ERA_PAY_BANK_CUST_NAME                 AS ERA_PAY_BANK_CUST_NAME         --代付行客户名称
         ,NULL                                     AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM RRP_MDL.O_ICL_CMM_IMP_FIN_BUS_INFO A--进口融资业务信息
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H B --业务出账申请
      ON A.DUBIL_ID = B.DUBIL_ID
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.APV_STATUS_CD = 'Finished'
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

  /*******************债券发行*******************/
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金业务（负债方）信息 --债券发行';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
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
    ,PEERS_PAY_FLG                  --同业代付标志
    ,ACTP_BILL_NO                   --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG             --结算性同业存款标志
    ,OPEN_ACC_DT                    --开户日期
    ,OPEN_ACC_TLR_NO                --开户柜员号
    ,CNL_ACC_DT                     --销户日期
    ,ACC_STAT                       --账户状态
    ,LAST_ACC_CHG_DT                --上次动户日期
    ,DEP_STABLE_CL                  --存款稳定性分类
    ,BIZ_REL_FLG                    --具有业务关系标志
    ,ADV_DRAW_FLG                   --可提前支取标志
    ,BIZ_REL_DEP_AMT                --有业务关系存款金额
    ,OUTSRC_FLG                     --委外标志
    ,RATE_TYP                       --利率类型
    ,NTC_WD_DT                      --通知取款日期
    ,SUBJ_ID                        --科目编号
    ,STATS_SUBJ_ID                  --统计科目编号
    ,PBC_ACC_TYP                    --人行账户类型
    ,MRGN_ACC_FLG                   --保证金账户标志
    ,PRC_BASE_TYP                   --定价基准类型
    ,BASE_RATE                      --基准利率
    ,RATE_FLT_FREQ                  --利率浮动频率
    ,INT_CALC_MODE                  --计息方式
    ,ACT_END_DT                     --实际终止日期
    ,DEP_RSV_MODE                   --缴存准备金方式
    ,CASH_REMIT_FLG                 --钞汇标志
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,SUB_ACC_ID                     --子账户编号
    ,FIN_INSTM_ID                   --金融工具编号
    ,BUS_ID                         --业务编号
    ,ASSET_THD_CLS_CD               --资产三分类代码
    ,TIME_DWD_FLG                   --定活标志 20220923 许晓滨
    ,STD_PROD_ID                    --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID                        --账户编号 HULJ 20221110 ADD
    ,STOP_PAY_STATUS_CD             --止付状态代码
    ,FROZ_FLG                       --冻结标志
    ,LG_FROZ_FLG                    --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
    ,CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')             AS DATA_DT                        --数据日期
        ,A.LP_ID                                  AS LGL_REP_ID                     --法人编号
        ,A.ENTRY_ORG_ID                           AS ORG_ID                         --机构编号
        ,COALESCE(C.CUST_ID,C.CNTPTY_ID,T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID) AS CUST_ID --客户编号
        ,A.BOND_ID                                AS ACC_ID                         --账户编号 债券编号
        ,NULL                                     AS ACC_TYP                        --账户类型
        ,A.CURR_CD                                AS CUR                            --币种
        ,NVL(TTB.TAR_VALUE_CODE,'206')            AS BIZ_TYP                        --业务类型 202同业拆入 205同业借款 201 同业存放 206同业存单发行
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')           AS START_DT                       --起始日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')             AS EXP_DT                         --到期日期
        ,A.ACTL_INT_RAT                           AS ACT_RATE                       --实际利率
        ,T.ACRU_INT                               AS INT                            --利息 当期应计利息
        ,NULL                                     AS NEXT_INT_PAY_DT                --下一付息日
        ,NULL                                     AS RATE_RE_PRC_DT                 --利率重新定价日期
        ,A.HAPP_AMT                               AS BIZ_AMT                        --业务发生金额
        ,A.CURR_BAL                               AS BAL                            --余额
        ,'0'                                      AS PEERS_PAY_FLG                  --同业代付标志
        ,NULL                                     AS ACTP_BILL_NO                   --承兑汇票票号
        ,NULL                                     AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,NULL                                     AS SETL_PEERS_DEP_FLG             --结算性同业存款标志
        ,NULL                                     AS OPEN_ACC_DT                    --开户日期
        ,NULL                                     AS OPEN_ACC_TLR_NO                --开户柜员号
        ,NULL                                     AS CNL_ACC_DT                     --销户日期
        ,NULL                                     AS ACC_STAT                       --账户状态
        ,NULL                                     AS LAST_ACC_CHG_DT                --上次动户日期
        ,NULL                                     AS DEP_STABLE_CL                  --存款稳定性分类
        ,NULL                                     AS BIZ_REL_FLG                    --具有业务关系标志
        ,NULL                                     AS ADV_DRAW_FLG                   --可提前支取标志
        ,NULL                                     AS BIZ_REL_DEP_AMT                --有业务关系存款金额
        ,NULL                                     AS OUTSRC_FLG                     --委外标志
        ,'RF01'                                   AS RATE_TYP                       --利率类型
        ,NULL                                     AS NTC_WD_DT                      --通知取款日期
        ,A.SUBJ_ID                                AS SUBJ_ID                        --科目编号
        ,NULL                                     AS STATS_SUBJ_ID                  --统计科目编号
        ,'TYXJJD'                                 AS PBC_ACC_TYP                    --人行账户类型  --20220623 XUXIAOBIN
        ,NULL                                     AS MRGN_ACC_FLG                   --保证金账户标志
        ,NULL                                     AS PRC_BASE_TYP                   --定价基准类型
        ,B.FAC_VAL_INT_RAT                        AS BASE_RATE                      --基准利率
        ,NULL                                     AS RATE_FLT_FREQ                  --利率浮动频率
        ,NULL                                     AS INT_CALC_MODE                  --计息方式
        ,NULL                                     AS ACT_END_DT                     --实际终止日期
        ,NULL                                     AS DEP_RSV_MODE                   --缴存准备金方式
        ,NULL                                     AS CASH_REMIT_FLG                 --钞汇标志
        ,NULL                                     AS DEPT_LINE                      --部门条线
        ,'债券发行'                               AS DATA_SRC                       --数据来源
        ,A.BOND_ID                                AS SUB_ACC_ID                     --子账户编号
        ,A.BOND_ID                                AS FIN_INSTM_ID                   --金融工具编号
        ,A.BUS_ID                                 AS BUS_ID                         --业务编号
        ,A.ASSET_THD_CLS_CD                       AS ASSET_THD_CLS_CD               --资产三分类代码
        ,NULL                                     AS TIME_DWD_FLG                   --定活标志 20220923 许晓滨
        ,A.STD_PROD_ID                            AS STD_PROD_ID                    --标准产品编号 --MOD BY LIP 20240626
        ,NULL                                     AS ACCT_ID                        --账户编号 HULJ 20221110 ADD
        ,NULL                                     AS STOP_PAY_STATUS_CD             --止付状态代码
        ,NULL                                     AS FROZ_FLG                       --冻结标志
        ,NULL                                     AS LG_FROZ_FLG                    --司法冻结标志
        ,A.BOND_ID                                AS CUST_ACCT_SUB_ACCT_NUM         --客户账户子户号_新一代
        ,NULL                                     AS CASH_MANAGE_FLG                --现金管理类产品标志   --ADD BY YJY 20250212
    FROM (SELECT T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID,T.BOND_ID,T.ETL_DT,T.BOND_TYPE_CD,T.STL_DT,T.TRAN_DIR_CD,T.ACRU_INT
                 ,ROW_NUMBER() OVER(PARTITION BY T.BOND_ID
                                        ORDER BY T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID,T.ETL_DT,T.BOND_TYPE_CD,T.STL_DT,T.TRAN_DIR_CD,T.ACRU_INT DESC) RM
            FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T
           WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))T --资金现券交易
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
      ON A.BOND_ID = T.BOND_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')--20230424 XUXIAO BIN MODIFY
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON B.BOND_ID = A.MAIN_ASSET_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CAP_CNTPTY_INFO C --资金交易对手信息 --无交易对手，交易对手编号和客户号都是空值
      ON C.CNTPTY_ID = T.CNTPTY_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --业务类型
      ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTB.SRC_CLASS_CODE = 'STD0003'
     AND TTB.TAR_CLASS_CODE = 'T0010'
     AND TTB.MOD_FLG = 'MDM'
   WHERE A.ASSET_TYPE_NAME = '债券发行'
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND T.BOND_TYPE_CD <> 'W' --剔除同业存单发行
     AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.TRAN_DIR_CD = '02'--交易方向01买入02卖出
     AND T.RM = 1
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT,ACC_ID,ACCT_ID,COUNT(1)
      FROM RRP_MDL.M_CPTL_LBY_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,ACC_ID,ACCT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

--程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_LBY_INFO;
/

