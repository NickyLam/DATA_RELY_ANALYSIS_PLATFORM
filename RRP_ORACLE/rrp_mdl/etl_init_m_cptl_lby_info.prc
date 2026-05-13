CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_LBY_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_LBY_INFO
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
  *             4    20221102  xuchangxin 补充利息字段的取数逻辑
  *             5    20221110  hulj       ACCT_ID  --账户编号新增字段
  *             6    20221114  hulj       增加数据重复校验
  *             7    20221122  xucx       修改同业代付口径
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_M_CPTL_LBY_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CPTL_LBY_INFO'; --表名
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
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（负债方）信息 --存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                               --数据日期
    ,A.LP_ID                                                                                    --法人编号
    ,A.BELONG_ORG_ID                                                                            --机构编号
    ,A.CUST_ID                                                                                  --客户编号
    ,A.CUST_ACCT_ID                                                                             --主账户编号
    ,T1.TAR_VALUE_CODE                                                                          --账户类型
    ,A.CURR_CD                                                                                  --币种
    ,NVL(TTB.TAR_VALUE_CODE,'20101')                                                             --业务类型
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                                             --起始日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                                               --到期日期
    ,NVL(A.EXEC_INT_RAT, 0)                                                                     --实际利率
    --,NULL                                                                                       --利息
    ,A.CURRT_ACRU_INT                                                                           --利息 MD BY 20221102 XUCX
    ,NULL                                                                                       --下一付息日
    ,NULL                                                                                       --利率重新定价日期
    ,NULL                                                                                       --业务发生金额
    ,A.CURRT_BAL                                                                                --余额
    ,NULL                                                                                       --同业代付标志
    ,NULL                                                                                       --承兑汇票票号
    ,NULL                                                                                       --外汇储备委托贷款资金标志
    ,/*CASE WHEN A.STD_PROD_ID LIKE '30%' OR   A.STD_PROD_ID LIKE '40%' AND A.RC_FLG = '1'--'1'定期
          THEN 'N'
          WHEN A.STD_PROD_ID LIKE '30%' OR   A.STD_PROD_ID LIKE '40%' AND A.RC_FLG = '0'--'0'活期
          THEN 'Y'
          ELSE NULL
          END
       */
    CASE WHEN A.SUBJ_ID LIKE '2015%' AND A.ACCT_USAGE_CD = '6' THEN 'Y'  --2015% 同业存放  6 结算性
         WHEN A.SUBJ_ID LIKE '2015%' AND A.ACCT_USAGE_CD <> '6' THEN 'N'
         ELSE NULL
    END                                                                                         --结算性同业存款标志
    ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                                                        --开户日期
    ,A.OPEN_ACCT_TELLER_ID                                                                      --开户柜员号
    ,TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD')                                                        --销户日期
    ,CASE WHEN A.DEP_ACCT_STATUS_CD IN ('01', '06') THEN '02'   --01表示关闭,06表示结清
         WHEN A.DEP_ACCT_STATUS_CD = '02' THEN '01'            --02表示正常
         WHEN A.DEP_ACCT_STATUS_CD = '03' THEN '04' --03,04分别表示部分冻结，全额冻结
         WHEN A.DEP_ACCT_STATUS_CD = '04' THEN '05'
         WHEN A.DEP_ACCT_STATUS_CD = '05' THEN '09'            --05表示不进不出-未使用.
    ELSE '99' END                                                                              --账户状态
    ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT, 'YYYYMMDD')                                                 --上次动户日期
    ,NULL                                                                                       --存款稳定性分类
    ,NULL                                                                                       --具有业务关系标志
    ,NULL                                                                                       --可提前支取标志
    ,NULL                                                                                       --有业务关系存款金额
    ,NULL                                                                                       --委外标志
    ,CASE WHEN FLOAT_INT_RAT_FLG ='1'
    THEN 'RF02'
    ELSE 'RF01'
     END                                                                                        --利率类型
    ,NULL                                                                                       --通知取款日期
    ,A.SUBJ_ID                                                                                  --科目编号
    ,NULL                                                                                       --统计科目编号
    ,A.ACCT_CLS_CD                                                                              --人行账户类型
    ,A.MARGIN_FLG                                                                               --保证金账户标志
    ,CASE WHEN A.BASE_RAT_TYPE_CD LIKE '21%' THEN 'TR09'
          ELSE
          TTA.TAR_VALUE_CODE    END                                                                                   --定价基准类型
    ,A.BASE_RAT                                                                                       --基准利率
    ,NULL                                                                                       --利率浮动频率
   -- ,NULL                                                                                     --计息方式
    ,A.INT_ACCR_FLG                                                                             --计息方式
    ,NULL                                                                                       --实际终止日期
    ,CASE WHEN   A.SUBJ_ID ='20150101'
               THEN 'DR01'
               ELSE 'DR03' END      --20221230 与业务陆炜迪确认                                                                                  --缴存准备金方式
    ,CASE WHEN A.EC_FLG = '0' THEN '02'--钞
         WHEN A.EC_FLG = '1' THEN '03'--汇
         WHEN A.EC_FLG = '2' THEN '04'--可钞可汇
       ELSE '01' END                                                                            --钞汇类型
    ,NULL                                                                                       --部门条线
    ,'存款分户-同业存放'                                                                         --数据来源
    ,NVL(A.OLD_CUST_ACCT_SUB_ACCT_NUM,A.CUST_ACCT_SUB_ACCT_NUM)                                                               --子账户编号
    ,NULL                                                                                       --金融工具编号
    ,NULL                                                                                       --业务编号
    ,NULL                                                                                       --资产三分类代码
    ,A.RC_FLG   AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,A.STD_PROD_ID AS STD_PROD_ID --标准产品编号  20220929 XUXIAOBIN ADD
    ,A.ACCT_ID AS ACCT_ID  --账户编号  20221110 hulj add
    ,A.STOP_PAY_STATUS_CD AS STOP_PAY_STATUS_CD  --止付状态代码
    ,A.FROZ_FLG AS FROZ_FLG --冻结标志
    ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1' ELSE '0' END AS LG_FROZ_FLG --司法冻结标志
    ,A.CUST_ACCT_SUB_ACCT_NUM AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A  --存款分户信息
/*  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.BELONG_ORG_ID = B.ORG_ID
    AND A.ETL_DT = B.ETL_DT*/
  LEFT JOIN CODE_MAP T1
  ON T1.SRC_VALUE_CODE = A.ACCT_ATTR_CD
  AND T1.SRC_CLASS_CODE = 'CD1924'
  AND T1.TAR_CLASS_CODE = 'P0004'
  AND T1.MOD_FLG = 'MDM'            --监管集市明细层
  LEFT JOIN CODE_MAP TTA  --定价基准方式转码
       ON TTA.SRC_VALUE_CODE = A.BASE_RAT_TYPE_CD
       AND TTA.SRC_CLASS_CODE = 'CD1010'
       AND TTA.TAR_CLASS_CODE = 'Z0015'
       AND TTA.MOD_FLG = 'MDM'
  LEFT JOIN CODE_MAP TTB
       ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
       AND TTB.SRC_CLASS_CODE = 'STD0003'
       AND TTB.TAR_CLASS_CODE = 'T0010'
       AND TTB.MOD_FLG = 'MDM'
 /* LEFT JOIN RRP_MDL.ORG_CONFIG KK
    ON A.BELONG_ORG_ID = KK.ORG_ID  */
  LEFT JOIN (
    SELECT DISTINCT DEP_SUB_ACCT_ID
    FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
    WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD') AND FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
    AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
    AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')--冻结截止日期
  ) DJ
  ON A.ACCT_ID = DJ.DEP_SUB_ACCT_ID
  WHERE ( A.SUBJ_ID LIKE '2015%'  OR A.SUBJ_ID LIKE '2016%'
             OR    A.SUBJ_ID LIKE '2017%') /*同业*/
    AND A.CORP_ACCT_FLG = '1' --只取对公*
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  /*V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款业务（负债方）信息 --联合存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID --账户编号
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                              --数据日期
    ,A.LP_ID                                                                                    --法人编号
    ,A.ACCT_INSTIT_ID                                                                           --机构编号
    ,A.CUST_ID                                                                                  --客户编号
    ,A.CUST_ACCT_ID                                                                             --账户编号
    ,NULL                                                                                       --账户类型
    ,A.CURR_CD                                                                                  --币种
    ,NVL(TTB.TAR_VALUE_CODE,'201')                                                              --业务类型
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                                             --起始日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                                               --到期日期
    ,NVL(A.EXEC_INT_RAT, 0)                                                                     --实际利率
    --,NULL                                                                                       --利息
    ,A.CURRT_ACRU_INT                                                                           --利息 MD BY 20221102 XUCX
    ,NULL                                                                                       --下一付息日
    ,NULL                                                                                       --利率重新定价日期
    ,NULL                                                                                       --业务发生金额
    ,A.CURRT_BAL                                                                                --余额
    ,NULL                                                                                       --同业代付标志
    ,NULL                                                                                       --承兑汇票票号
    ,NULL                                                                                       --外汇储备委托贷款资金标志
    ,CASE WHEN A.STD_PROD_ID LIKE '30%' OR   A.STD_PROD_ID LIKE '40%' AND A.RC_FLG = '1'--'1'定期
          THEN 'N'
          WHEN A.STD_PROD_ID LIKE '30%' OR   A.STD_PROD_ID LIKE '40%' AND A.RC_FLG = '0'--'0'活期
          THEN 'Y'
          ELSE NULL
          END                                                                                        --结算性同业存款标志
    ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                                                        --开户日期
    ,A.OPEN_ACCT_TELLER_ID                                                                      --开户柜员号
    ,TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD')                                                        --销户日期
    ,CASE WHEN A.DEP_ACCT_STATUS_CD = '1' THEN '01'
         WHEN A.DEP_ACCT_STATUS_CD = '2' THEN '04'
         WHEN A.DEP_ACCT_STATUS_CD = '0' THEN '02'
    ELSE '99' END                                                                               --账户状态
    ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT, 'YYYYMMDD')                                                 --上次动户日期
    ,NULL                                                                                       --存款稳定性分类
    ,NULL                                                                                       --具有业务关系标志
    ,NULL                                                                                       --可提前支取标志
    ,NULL                                                                                       --有业务关系存款金额
    ,NULL                                                                                       --委外标志
    ,CASE WHEN INT_RAT_FLO_VAL >0
    THEN 'RF02'
     ELSE 'RF01'
     END                                                                                       --利率类型
    ,NULL                                                                                       --通知取款日期
    ,A.SUBJ_ID                                                                                  --科目编号
    ,NULL                                                                                       --统计科目编号
    ,'9901'                                                                                --人行账户类型
    ,NULL                                                                                       --保证金账户标志
    ,NVL(TTA.TAR_VALUE_CODE,'TR09')                                                                                       --定价基准类型
    ,A.BASE_RAT                                                                                       --基准利率
    ,NULL                                                                                       --利率浮动频率
  --  ,NULL                                                                                     --计息方式
    ,A.INT_ACCR_FLG                                                                             --计息方式
    ,NULL                                                                                       --实际终止日期
    ,CASE WHEN (\*A.SUBJ_ID LIKE '201202%' OR A.SUBJ_ID LIKE '20150102%' OR A.SUBJ_ID LIKE '20150103%' OR A.SUBJ_ID LIKE '201502%' OR
                     A.SUBJ_ID LIKE '20160102%' OR A.SUBJ_ID LIKE '20160103%' OR A.SUBJ_ID LIKE '201701%' OR A.SUBJ_ID LIKE '201702%'*\
                 A.SUBJ_ID LIKE '2015%') THEN 'DR03'
               ELSE 'DR01' END                                                                                       --缴存准备金方式
    ,'01'   --人民币                                                                            --钞汇类型
    ,'800918' --计划财务部                                                                      --部门条线
    ,'联合存款'                                                                                 --数据来源
    ,A.CUST_ACCT_SUB_ACCT_NUM                                                                   --子账户编号
    ,NULL                                                                                       --金融工具编号
    ,NULL                                                                                       --业务编号
    ,NULL                                                                                       --资产三分类代码
    ,A.RC_FLG   AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,A.STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,A.CUST_ACCT_SUB_ACCT_NUM||A.CUST_ACCT_ID AS ACCT_ID --账户编号 hulj 20221110 add
    ,A.STOP_PAY_STATUS_CD AS STOP_PAY_STATUS_CD  --止付状态代码
    ,A.FROZ_STATUS_CD AS FROZ_FLG --冻结标志
    ,NULL AS LG_FROZ_FLG                              --司法冻结标志
    ,A.CUST_ACCT_SUB_ACCT_NUM AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO A  --联合存款分户信息
  LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
    ON A.ACCT_INSTIT_ID = B.ORG_ID
    AND A.ETL_DT = B.ETL_DT
  LEFT JOIN CODE_MAP TTB  --业务类型
    ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTB.SRC_CLASS_CODE = 'STD0003'
    AND TTB.TAR_CLASS_CODE = 'T0010'
    AND TTB.MOD_FLG = 'MDM'
  LEFT JOIN CODE_MAP TTA
  ON A.BASE_RAT_TYPE_CD = TTA.SRC_VALUE_CODE
  AND TTA.SRC_CLASS_CODE ='CD1010'
  AND TTA.TAR_CLASS_CODE = 'Z0015'
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
    ON E.CD_ID = 'CD1253'
    AND A.DEP_ACCT_STATUS_CD = E.CD_VAL
    --AND E.ETL_DT = V_DATE
  \*LEFT JOIN RRP_MDL.ORG_CONFIG KK
    ON A.ACCT_INSTIT_ID = KK.ORG_ID*\
    WHERE
     A.SUBJ_ID LIKE '2015%'  OR A.SUBJ_ID LIKE '2017%'
    AND  A.CORP_ACCT_FLG = '1' --只取对公
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

*/
   /*******************资金同业拆借*******************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业拆入（无押品）数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                               --数据日期
    ,A.LP_ID                                                                                    --法人编号
    ,A.ENTRY_ORG_ID                                                                             --机构编号
    ,A.CUST_ID                                                                                  --客户编号
    ,A.BAG_ID                                                                                   --账户编号
    ,NULL                                                                                       --账户类型
    ,A.CURR_CD                                                                                  --币种
    ,NVL(TTB.TAR_VALUE_CODE,'202')                                                              --业务类型 :202同业拆入 205同业借款 201 同业存放 206同业存单发行
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')                                                            --起始日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                                                              --到期日期
    ,NVL(A.EXEC_INT_RAT, 0)                                                                     --实际利率
    ,A.CURRT_ACRU_INT                                                                           --利息  当期应计利息
    ,NULL                                                                                       --下一付息日
    ,NULL                                                                                       --利率重新定价日期
    ,NULL                                                                                       --业务发生金额
    ,A.CURRT_BAL                                                                                --余额
    ,'0'                                                                                       --同业代付标志
    ,NULL                                                                                       --承兑汇票票号
    ,NULL                                                                                       --外汇储备委托贷款资金标志
    ,NULL                                                                                      --结算性同业存款标志
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                                              --开户日期
    ,null                                                                                       --开户柜员号
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                                               --销户日期
    ,null                                                                                       --账户状态
    ,null                                                                                       --上次动户日期
    ,NULL                                                                                       --存款稳定性分类
    ,NULL                                                                                       --具有业务关系标志
    ,NULL                                                                                       --可提前支取标志
    ,NULL                                                                                       --有业务关系存款金额
    ,NULL                                                                                       --委外标志
    ,'RF01'                                                                                       --利率类型
    ,NULL                                                                                       --通知取款日期
    ,A.SUBJ_ID                                                                                  --科目编号
    ,NULL                                                                                       --统计科目编号
    ,'TYCR'  --20220623    XUXIAOBIN                                                            --人行账户类型
    ,NULL                                                                                       --保证金账户标志
    ,NULL                                                                                       --定价基准类型
    ,NULL                                                                                       --基准利率
    ,NULL                                                                                       --利率浮动频率
    ,'07'--20220929  XUXIAOBIN ADD                                                              --计息方式
    ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') = V_P_DATE
          THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
          ELSE NULL
          END                                                                                   --实际终止日期
    ,NULL                                                                                       --缴存准备金方式
    ,NULL                                                                                       --钞汇类型
    ,NULL                                                                                       --部门条线
    ,'资金同业拆借'                                                                              --数据来源
    ,NULL                                                                                       --子账户编号
    ,NULL                                                                                       --金融工具编号
    --,A.BUS_ID                                                                                   --业务编号
    ,A.TRAN_ID                                                                                  --业务编号  --MODIFY  CCH  20221017  根据IMAS生产数据修改
    ,A.ASSET_THD_CLS_CD                                                                         --资产三分类代码
    ,NULL AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,NULL AS STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,NULL AS ACCT_ID  --账户编号 hulj 20221110 add
    ,NULL AS STOP_PAY_STATUS_CD  --止付状态代码
    ,NULL AS FROZ_FLG --冻结标志
    ,NULL AS LG_FROZ_FLG                              --司法冻结标志
    ,NULL AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A  --资金同业拆借
  LEFT JOIN CODE_MAP TTB  --业务类型
    ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTB.SRC_CLASS_CODE = 'STD0003'
    AND TTB.TAR_CLASS_CODE = 'T0010'
    AND TTB.MOD_FLG = 'MDM'
  WHERE (A.SUBJ_ID LIKE  '2003%' )       -- 拆入同业款项 20221010 XUXIAOBIN modify
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   /*******************外汇同业拆借*******************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金（负债方）信息 --外汇同业拆入（无押品）数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                        --数据日期
    ,A.LP_ID                                                                             --法人编号
    ,A.ENTRY_ORG_ID                                                                      --机构编号
    ,A.CUST_ID                                                                                  --客户编号
    ,A.BAG_ID                                                                        --账户编号
    ,NULL                                                                                       --账户类型
    ,A.CURR_CD                                                                                  --币种
    ,NVL(TTB.TAR_VALUE_CODE,'202')                                                                                      --业务类型 :202同业拆入 205同业借款 201 同业存放 206同业存单发行
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')                                                                                       --起始日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                                                                                       --到期日期
    ,NVL(A.EXEC_INT_RAT, 0)                                                                     --实际利率
    ,A.CURRT_ACRU_INT                                                                           --利息  当期应计利息
    ,NULL                                                                                       --下一付息日
    ,NULL                                                                                       --利率重新定价日期
    ,NULL                                                                                       --业务发生金额
    ,A.CURRT_BAL                                                                                --余额
    ,'0'                                                                                       --同业代付标志
    ,NULL                                                                                       --承兑汇票票号
    ,NULL                                                                                       --外汇储备委托贷款资金标志
    ,NULL                                                                                       --结算性同业存款标志
    ,null                                                                                       --开户日期
    ,null                                                                                       --开户柜员号
    ,null                                                                                       --销户日期
    ,null                                                                                       --账户状态
    ,null                                                                                       --上次动户日期
    ,NULL                                                                                       --存款稳定性分类
    ,NULL                                                                                       --具有业务关系标志
    ,NULL                                                                                       --可提前支取标志
    ,NULL                                                                                       --有业务关系存款金额
    ,NULL                                                                                       --委外标志
    ,'RF01'                                                                                       --利率类型
    ,NULL                                                                                       --通知取款日期
    ,A.SUBJ_ID                                                                                  --科目编号
    ,NULL                                                                                       --统计科目编号
    ,'TYCR'       --20220623    XUXIAOBIN                                                       --人行账户类型
    ,NULL                                                                                       --保证金账户标志
    ,NULL                                                                                       --定价基准类型
    ,A.BASE_RAT                                                                                       --基准利率
    ,NULL                                                                                       --利率浮动频率
    ,'07'--20220929  XUXIAOBIN ADD                                                              --计息方式
    ,NULL                                                                                       --实际终止日期
    ,NULL                                                                                       --缴存准备金方式
    ,NULL                                                                                       --钞汇类型
    ,NULL --计划财务部                                                                      --部门条线
    ,'外汇同业拆借'                                                                             --数据来源
    ,NULL                                                                                       --子账户编号
    ,NULL                                                                                       --金融工具编号
    ,A.BUS_ID                                                                                   --业务编号
    ,A.ASSET_THD_CLS_CD                                                                         --资产三分类代码
    ,NULL AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,NULL AS STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,NULL AS ACCT_ID  --账户编号 hulj 20221110 add
    ,NULL AS STOP_PAY_STATUS_CD  --止付状态代码
    ,NULL AS FROZ_FLG --冻结标志
    ,NULL AS LG_FROZ_FLG                              --司法冻结标志
    ,NULL AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
    LEFT JOIN CODE_MAP TTB  --业务类型
    ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTB.SRC_CLASS_CODE = 'STD0003'
    AND TTB.TAR_CLASS_CODE = 'T0010'
    AND TTB.MOD_FLG = 'MDM'
  WHERE (/*A.SUBJ_ID = '2003010101' OR*/ A.SUBJ_ID LIKE '2003%')  --拆入同业 20221010 XUXIAOBIN modify
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   /*******************同业现金借贷表*******************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业借款（无押品）';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                               --数据日期
    ,A.LP_ID                                                                                    --法人编号
    ,A.BELONG_ORG_ID                                                                            --机构编号
    ,A.CNTPTY_CUST_ID                                                                           --客户编号
    ,A.ACCT_ID                                                                                  --账户编号
    ,NULL                                                                                       --账户类型
    ,A.CURR_CD                                                                                  --币种
    ,NVL(TTB.TAR_VALUE_CODE,'205')                                                                                      --业务类型 :202同业拆入 205同业借款 201 同业存放  206同业存单发行
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')                                                                                        --起始日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                                                                                        --到期日期
    ,NVL(A.EXEC_INT_RAT, 0)                                                                     --实际利率
    ,ABS(A.RECVBL_UNCOL_INT)--ABS(A.ACRU_INT)                                                   --利息  应计利息   -MD 20220725 应收未收利息
    ,NULL                                                                                       --下一付息日
    ,NULL                                                                                       --利率重新定价日期
    ,NULL                                                                                       --业务发生金额
    ,ABS(A.ACTL_BAL)                                                                                --余额  --实际余额
    ,'0'                                                                                        --同业代付标志
    ,NULL                                                                                       --承兑汇票票号
    ,NULL                                                                                       --外汇储备委托贷款资金标志
    ,NULL                                                                                       --结算性同业存款标志
    ,NULL                                                                                       --开户日期
    ,NULL                                                                                       --开户柜员号
    ,NULL                                                                                       --销户日期
    ,NULL                                                                                       --账户状态
    ,NULL                                                                                       --上次动户日期
    ,NULL                                                                                       --存款稳定性分类
    ,NULL                                                                                       --具有业务关系标志
    ,NULL                                                                                       --可提前支取标志
    ,NULL                                                                                       --有业务关系存款金额
    ,NULL                                                                                       --委外标志
    ,CASE WHEN A.INT_RAT_ADJ_WAY_CD = '1'
          THEN 'RF01'
         ELSE 'RF02'
         END                                                                                      --利率类型
    ,NULL                                                                                       --通知取款日期
    ,A.SUBJ_ID                                                                                  --科目编号
    ,NULL                                                                                       --统计科目编号
    ,'TYXJJD'    --20220623    XUXIAOBIN                                                        --人行账户类型
    ,NULL                                                                                       --保证金账户标志
    ,NULL                                                                                       --定价基准类型
    ,A.BASE_RAT                                                                                       --基准利率
    ,NULL                                                                                       --利率浮动频率
    ,CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01'-- 0M  按月
               WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q  按季 3M  按3个月
               WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03'-- 1Y  按年
               WHEN A.PAY_INT_PED_CD = '6M' THEN '06'-- 6M  按6个月
               --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
               ELSE '99' --其他 00  未知 0D  按日 1M  按周 4M  按4个月
               END   --20220929 XUXIAOBIN ADD                                                     --计息方式
    ,NULL                                                                                       --实际终止日期
    ,NULL                                                                                       --缴存准备金方式
    ,NULL                                                                                       --钞汇类型
    ,NULL                                                                                       --部门条线
    ,'同业现金借贷'                                                                             --数据来源
    ,NULL                                                                                       --子账户编号
    ,A.FIN_INSTM_ID                                                                             --金融工具编号
    ,A.BUS_ID                                                                                   --业务编号
    ,A.ASSET_THD_CLS_CD                                                                         --资产三分类代码
    ,NULL AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,NULL AS STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,NULL AS ACCT_ID  --账户编号 hulj 20221110 add
    ,NULL AS STOP_PAY_STATUS_CD  --止付状态代码
    ,NULL AS FROZ_FLG --冻结标志
    ,NULL AS LG_FROZ_FLG                              --司法冻结标志
    ,NULL AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
  LEFT JOIN CODE_MAP TTB  --业务类型
    ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTB.SRC_CLASS_CODE = 'STD0003'
    AND TTB.TAR_CLASS_CODE = 'T0010'
    AND TTB.MOD_FLG = 'MDM'
  WHERE A.SUBJ_ID LIKE '200303%'        --同业借款 --20220929 XUXIAOBIN MODIFY
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   /*******************同业代付*******************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（负债方）信息 --同业代付';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,ORG_ID  --机构编号
    ,CUST_ID  --客户编号
    ,ACC_ID  --账户编号
    ,ACC_TYP  --账户类型
    ,CUR  --币种
    ,BIZ_TYP  --业务类型
    ,START_DT  --起始日期
    ,EXP_DT  --到期日期
    ,ACT_RATE  --实际利率
    ,INT  --利息
    ,NEXT_INT_PAY_DT  --下一付息日
    ,RATE_RE_PRC_DT  --利率重新定价日期
    ,BIZ_AMT  --业务发生金额
    ,BAL  --余额
    ,PEERS_PAY_FLG  --同业代付标志
    ,ACTP_BILL_NO  --承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
    ,OPEN_ACC_DT  --开户日期
    ,OPEN_ACC_TLR_NO  --开户柜员号
    ,CNL_ACC_DT  --销户日期
    ,ACC_STAT  --账户状态
    ,LAST_ACC_CHG_DT  --上次动户日期
    ,DEP_STABLE_CL  --存款稳定性分类
    ,BIZ_REL_FLG  --具有业务关系标志
    ,ADV_DRAW_FLG  --可提前支取标志
    ,BIZ_REL_DEP_AMT  --有业务关系存款金额
    ,OUTSRC_FLG  --委外标志
    ,RATE_TYP  --利率类型
    ,NTC_WD_DT  --通知取款日期
    ,SUBJ_ID  --科目编号
    ,STATS_SUBJ_ID  --统计科目编号
    ,PBC_ACC_TYP  --人行账户类型
    ,MRGN_ACC_FLG  --保证金账户标志
    ,PRC_BASE_TYP  --定价基准类型
    ,BASE_RATE  --基准利率
    ,RATE_FLT_FREQ  --利率浮动频率
    ,INT_CALC_MODE  --计息方式
    ,ACT_END_DT  --实际终止日期
    ,DEP_RSV_MODE  --缴存准备金方式
    ,CASH_REMIT_FLG  --钞汇标志
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,SUB_ACC_ID --子账户编号
    ,FIN_INSTM_ID --金融工具编号
    ,BUS_ID --业务编号
    ,ASSET_THD_CLS_CD --资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT V_P_DATE AS DATA_DT,--数据日期
            A.LP_ID AS LGL_REP_ID,--法人编号
            NVL(A.OUT_ACCT_ORG_ID,ORG.ORG_ID1) AS ORG_ID,--机构编号
            BL.CUST_ID AS CUST_ID,--客户编号 20230104 同业代付
            A.OUT_ACCT_FLOW_NUM  AS ACC_ID,--账户编号 出账流水号
            NULL AS ACC_TYP,--账户类型
            A.CURR_CD AS CUR,--币种
            '20203' AS BIZ_TYP,--业务类型   103同业借款  101存放同业 10203同业代付
            TO_CHAR(A.DISTR_DT, 'YYYYMMDD') AS START_DT,--起始日期
            TO_CHAR(A.EXP_DT, 'YYYYMMDD') AS EXP_DT,--到期日期
            /*A.FIX_INT_RAT*/B.IBANK_PAYFAN_PROVI_INT_RAT AS ACT_RATE,--实际利率
            --根据陆炜迪意见，同业代付利息=当期余额*计提利率/365*截止到节点的使用天数
            A.THS_TM_DISTR_AMT * B.IBANK_PAYFAN_PROVI_INT_RAT /100 /365 * (
                   CASE WHEN A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                   ELSE A.EXP_DT END
                 - A.DISTR_DT)
             AS INT,--利息
            --A.THS_TM_DISTR_AMT * B.IBANK_PAYFAN_PROVI_INT_RAT * B.INT_ACCR_DAYS AS INT,--利息
            NULL AS NEXT_INT_PAY_DT,--下一付息日
            NULL AS RATE_RE_PRC_DT,--利率重新定价日期
            CAST(0 AS NUMBER(30,2)) AS BIZ_AMT,--业务发生金额
            --A.CONT_AMT AS BAL,--余额
            A.THS_TM_DISTR_AMT AS BAL,--余额
            '1' AS PEERS_PAY_FLG,--同业代付标志
            NULL AS ACTP_BILL_NO,--承兑汇票票号
            'N' AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG,--外汇储备委托贷款资金标志
            'N' AS SETL_PEERS_DEP_FLG,--结算性同业存款标志
            NULL AS OPEN_ACC_DT,--开户日期
            NULL AS OPEN_ACC_TLR_NO,--开户柜员号
            NULL AS CNL_ACC_DT,--销户日期
            NULL AS ACC_STAT,--账户状态
            NULL AS LAST_ACC_CHG_DT,--上次动户日期
            NULL AS DEP_STABLE_CL,--存款稳定性分类
            NULL AS BIZ_REL_FLG,--具有业务关系标志
            NULL AS ADV_DRAW_FLG,--可提前支取标志
            NULL AS BIZ_REL_DEP_AMT,--有业务关系存款金额
            NULL AS OUTSRC_FLG,--委外标志
            'RF01' AS RATE_TYP,--利率类型
            NULL AS NTC_WD_DT,--通知取款日期
            --A.SUBJ_ID AS SUBJ_ID,--科目编号
            '2202010301' AS SUBJ_ID,--科目编号
            NULL AS STATS_SUBJ_ID,--统计科目编号
            'TYCR' AS PBC_ACC_TYP,--人行账户类型
            NULL AS MRGN_ACC_FLG,--保证金账户标志
            TB.TAR_VALUE_CODE AS PRC_BASE_TYP,--定价基准类型
            A.BASE_RAT AS BASE_RATE,--基准利率
            TA.TAR_VALUE_CODE AS RATE_FLT_FREQ,--利率浮动频率
            NULL AS INT_CALC_MODE,--计息方式
            NULL AS ACT_END_DT,--实际终止日期
            NULL AS DEP_RSV_MODE,--缴存准备金方式
            NULL AS CASH_REMIT_FLG,--钞汇标志
            '800975' AS DEPT_LINE,--部门条线 信贷系统-委托同业代付
            '同业代付'  AS DATA_SRC,--数据来源 --计划财务部
            NULL AS SUB_ACC_ID ,--子账户编号
            NULL AS FIN_INSTM_ID, --金融工具编号
            A.CONT_ID AS BUS_ID, --业务编号
            NULL AS ASSET_THD_CLS_CD --资产三分类代码
            ,NULL AS TIME_DWD_FLG --定活标志 20220923 许晓滨
            ,NULL AS STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
            ,NULL AS ACCT_ID  --账户编号 hulj 20221110 add
            ,NULL AS STOP_PAY_STATUS_CD  --止付状态代码
            ,NULL AS FROZ_FLG --冻结标志
            ,NULL AS LG_FROZ_FLG                              --司法冻结标志
            ,NULL AS CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
        FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请 A
        LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H B --贷款出账对公贷款附属信息历史
        ON A.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
        AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        LEFT JOIN M_WTTYDF_CUST BL--20230104 同业代付交易对手,暂行补录方案
        ON TRIM(B.ERA_PAY_BANK_NAME) = BL.CUST_NAME
        LEFT JOIN RRP_MDL.ORG_CONFIG ORG    --机构配置表
        ON A.OUT_ACCT_ORG_ID=ORG.ORG_ID  --出账机构编号
        LEFT JOIN CODE_MAP TA --利率浮动频率
             ON  TA.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CD
             AND TA.SRC_CLASS_CODE = 'CD2636'
             AND TA.TAR_CLASS_CODE = 'D0015'
             AND TA.MOD_FLG = 'MDM'
         LEFT JOIN CODE_MAP TB --定价基准类型
             ON  TA.SRC_VALUE_CODE = A.BASE_RAT_TYPE_CD
             AND TA.SRC_CLASS_CODE = 'CD1010'
             AND TA.TAR_CLASS_CODE = 'Z0015'
             AND TA.MOD_FLG = 'MDM'
        WHERE /*A.SUBJ_ID LIKE '130507%'*/
           A.PROD_ID IN ('203020700001','203020700002')
           --AND A.DISTR_DT <=  TO_DATE(V_P_DATE,'YYYYMMDD')
           --AND A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  -- 发放日期和到期日期 还未到期
           AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   /*******************债卷发行*******************/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（负债方）信息 --债卷发行';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_LBY_INFO
  (
    DATA_DT  --1数据日期
    ,LGL_REP_ID  --2法人编号
    ,ORG_ID  --3机构编号
    ,CUST_ID  --4客户编号
    ,ACC_ID  --5账户编号
    ,ACC_TYP  --6账户类型
    ,CUR  --7币种
    ,BIZ_TYP  --8业务类型
    ,START_DT  --9起始日期
    ,EXP_DT  --10到期日期
    ,ACT_RATE  --11实际利率
    ,INT  --12利息
    ,NEXT_INT_PAY_DT  --13下一付息日
    ,RATE_RE_PRC_DT  --14利率重新定价日期
    ,BIZ_AMT  --15业务发生金额
    ,BAL  --16余额
    ,PEERS_PAY_FLG  --17同业代付标志
    ,ACTP_BILL_NO  --18承兑汇票票号
    ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --19外汇储备委托贷款资金标志
    ,SETL_PEERS_DEP_FLG  --20结算性同业存款标志
    ,OPEN_ACC_DT  --21开户日期
    ,OPEN_ACC_TLR_NO  --22开户柜员号
    ,CNL_ACC_DT  --23销户日期
    ,ACC_STAT  --24账户状态
    ,LAST_ACC_CHG_DT  --25上次动户日期
    ,DEP_STABLE_CL  --26存款稳定性分类
    ,BIZ_REL_FLG  --27具有业务关系标志
    ,ADV_DRAW_FLG  --28可提前支取标志
    ,BIZ_REL_DEP_AMT  --29有业务关系存款金额
    ,OUTSRC_FLG  --30委外标志
    ,RATE_TYP  --31利率类型
    ,NTC_WD_DT  --32通知取款日期
    ,SUBJ_ID  --33科目编号
    ,STATS_SUBJ_ID  --34统计科目编号
    ,PBC_ACC_TYP  --35人行账户类型
    ,MRGN_ACC_FLG  --36保证金账户标志
    ,PRC_BASE_TYP  --37定价基准类型
    ,BASE_RATE  --38基准利率
    ,RATE_FLT_FREQ  --39利率浮动频率
    ,INT_CALC_MODE  --40计息方式
    ,ACT_END_DT  --41实际终止日期
    ,DEP_RSV_MODE  --42缴存准备金方式
    ,CASH_REMIT_FLG  --43钞汇标志
    ,DEPT_LINE  --44部门条线
    ,DATA_SRC  --45数据来源
    ,SUB_ACC_ID --46子账户编号
    ,FIN_INSTM_ID --47金融工具编号
    ,BUS_ID --48业务编号
    ,ASSET_THD_CLS_CD --49资产三分类代码
    ,TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,ACCT_ID  --账户编号 hulj 20221110 add
    ,STOP_PAY_STATUS_CD  --止付状态代码
    ,FROZ_FLG --冻结标志
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    )
    SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                               --1数据日期
    ,A.LP_ID                                                                                    --2法人编号
    ,NVL(A.ENTRY_ORG_ID,ORG.ORG_ID1  )                                                           --3机构编号
    ,COALESCE(C.CUST_ID,C.CNTPTY_ID,T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID)                            --4客户编号
    ,A.BOND_ID                                                                                  --5账户编号  债卷编号
    ,NULL                                                                                       --6账户类型
    ,A.CURR_CD                                                                                  --7币种
    ,NVL(TTB.TAR_VALUE_CODE,'206')                                                              --8业务类型 :202同业拆入 205同业借款 201 同业存放 206同业存单发行
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                                             --9起始日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                                               --10到期日期
    ,A.ACTL_INT_RAT                                                                             --11实际利率
    ,T.ACRU_INT                                                                                 --12利息   当期应计利息
    ,NULL                                                                                        --13下一付息日
    ,NULL                                                                                       --14利率重新定价日期
    ,A.HAPP_AMT                                                                                   --15业务发生金额
    ,A.CURR_BAL                                                                                 --16余额  --债券面值
    ,'0'                                                                                        --17同业代付标志
    ,NULL                                                                                       --18承兑汇票票号
    ,NULL                                                                                       --19外汇储备委托贷款资金标志
    ,NULL                                                                                       --20结算性同业存款标志
    ,NULL                                                                                       --21开户日期
    ,NULL                                                                                       --22开户柜员号
    ,NULL                                                                                       --23销户日期
    ,NULL                                                                                       --24账户状态
    ,NULL                                                                                       --25上次动户日期
    ,NULL                                                                                       --26存款稳定性分类
    ,NULL                                                                                       --27具有业务关系标志
    ,NULL                                                                                       --28可提前支取标志
    ,NULL                                                                                       --29有业务关系存款金额
    ,NULL                                                                                       --30委外标志
    ,'RF01'                                                                                       --31利率类型
    ,NULL                                                                                       --32通知取款日期
    ,A.SUBJ_ID                                                                                  --33科目编号
    ,NULL                                                                                       --34统计科目编号
    ,'TYXJJD'    --20220623    XUXIAOBIN                                                        --35人行账户类型
    ,NULL                                                                                       --36保证金账户标志
    ,NULL                                                                                       --37定价基准类型
    ,B.FAC_VAL_INT_RAT                                                                          --38基准利率
    ,NULL                                                                                       --39利率浮动频率
    ,NULL                                                                                       --40计息方式
    ,NULL                                                                                       --41实际终止日期
    ,NULL                                                                                       --42缴存准备金方式
    ,NULL                                                                                       --43钞汇类型起息日期
    ,NULL                                                                                       --44部门条线
    ,'债券发行'                                                                                  --45数据来源
    ,A.BOND_ID                                                                                  --46子账户编号
    ,A.BOND_ID                                                                                  --47金融工具编号
    ,A.BUS_ID                                                                                   --48业务编号
    ,A.ASSET_THD_CLS_CD                                                                         --49资产三分类代码
    ,NULL AS TIME_DWD_FLG --定活标志 20220923 许晓滨
    ,NULL AS STD_PROD_ID  --标准产品编号  20220929 XUXIAOBIN ADD
    ,NULL AS ACCT_ID  --账户编号 hulj 20221110 add
    ,NULL AS STOP_PAY_STATUS_CD  --止付状态代码
    ,NULL AS FROZ_FLG --冻结标志
    ,NULL AS LG_FROZ_FLG                                                                        --司法冻结标志
    ,A.BOND_ID AS CUST_ACCT_SUB_ACCT_NUM                                                        --客户账户子户号_新一代
 FROM (SELECT T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID,T.BOND_ID,T.ETL_DT,T.BOND_TYPE_CD,T.STL_DT,T.TRAN_DIR_CD,T.ACRU_INT
              ,ROW_NUMBER() OVER(PARTITION BY T.BOND_ID ORDER BY T.CNTPTY_ID,T.CUST_ID,T.TRAN_ID,T.ETL_DT,T.BOND_TYPE_CD,T.STL_DT,T.TRAN_DIR_CD,T.ACRU_INT DESC) RM
       FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T
       WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       )T --资金现券交易
  INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
     ON T.BOND_ID = A.BOND_ID
    AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
     ON A.MAIN_ASSET_ID = B.BOND_ID
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RRP_MDL.ORG_CONFIG ORG --机构映射表
    ON  A.ENTRY_ORG_ID = ORG.ORG_ID
  LEFT JOIN RRP_MDL.O_IML_PTY_CAP_CNTPTY_INFO C --资金交易对手信息   -无交易对手，交易对手编号和客户号都是空值
    ON  T.CNTPTY_ID=C.CNTPTY_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN CODE_MAP TTB  --业务类型
    ON TTB.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTB.SRC_CLASS_CODE = 'STD0003'
    AND TTB.TAR_CLASS_CODE = 'T0010'
    AND TTB.MOD_FLG = 'MDM'
  WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME = '债券发行'
    AND T.BOND_TYPE_CD <> 'W'   --剔除同业存单发行
    --AND B.BOND_TYPE_CD IN ('7','71','X','Y')
    AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(A.SUBJ_ID) IS NOT NULL
    AND T.TRAN_DIR_CD='02'--交易方向01买入02卖出
    AND T.RM=1
       ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


      -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID,ACCT_ID,COUNT(1)
      FROM M_CPTL_LBY_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ACC_ID,ACCT_ID
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
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CPTL_LBY_INFO;
/

