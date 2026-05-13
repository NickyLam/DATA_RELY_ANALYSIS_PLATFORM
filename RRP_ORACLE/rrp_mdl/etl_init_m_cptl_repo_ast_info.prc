CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_REPO_AST_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_REPO_AST_INFO
  *  功能描述：回购业务（资产方）信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_REPO_AST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  梅炜      首次创建
  *             2    20220915  hulj      新增逻辑资金债券买入返售、外币买入返售 、同业现金借贷买入返售。
  *             3    20221031  XUXIAOBIN  修改机构编号 取原值
  *             4    20221031  XUXIAOBINJS  是报送一个月，月中结清月底余额则为0，余额为0条件需在应用层添加
  *             5    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CPTL_REPO_AST_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_START_DT              DATE;
  V_DATE           DATE; --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  I_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_DATE                  := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                                     SUBSTR(I_P_DATE, 5, 2) || '-' ||
                                     SUBSTR(I_P_DATE, 7, 2),
                                     'YYYY-MM-DD');
  V_START_DT              := TRUNC(V_DATE, 'MM');
  V_TAB_NAME := 'M_CPTL_REPO_AST_INFO'; --表名
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
  I_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(I_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(I_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  I_START_DT := TO_CHAR(TO_DATE(I_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
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
  V_STEP_DESC := '插入回购业务（资产方）信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_AST_INFO
  ( DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,ACC_ID                             --账户编号
    ,LMT_ID                             --额度编号
    ,ACC_TYP                            --账户类型
    ,CUR                                --币种
    ,REPO_BIZ_TYP                       --回购业务类型
    ,ULYG_AST_TYP                       --标的资产类型
    ,ULYG_PROD_ID                       --标的产品编号
    ,OPR_TYP                            --经营类型
    ,AMT                                --发生额
    ,BAL                                --余额
    ,INT                                --利息
    ,NEXT_INT_PAY_DT                    --下一付息日
    ,START_DT                           --起始日期
    ,EXP_DT                             --到期日期
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,LVL5_CL                            --五级分类
    ,MRGN_CUR                           --保证金币种
    ,MRGN                               --保证金
    ,SPCL_PRO                           --专项准备
    ,PARTI_PRO                          --特种准备
    ,COM_PRO                            --一般准备
    ,INT_CALC_FLG                       --计息标志
    ,COLL_RSK_CL                        --担保品风险分类
    ,ULYG_MKT_VAL                       --标的物市场价值
    ,RE_MTG_FLG                         --再抵押标志
    ,NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                           --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,STATS_SUBJ_ID                      --统计科目编号
    ,REPY_ACC                           --还款账号
    ,LOAN_ETR_ACC                       --贷款入账账号
    ,SUBJ_ID                            --科目编号
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                         --销户日期
    ,OVD_DT                             --逾期日期
    ,LAST_REPY_DT                       --上次还款日期
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,PRC_BASE_TYP                       --定价基准类型
    ,INT_CALC_MODE                      --计息方式
    ,ACT_END_DT                         --实际终止日期
    ,APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,PRO_IMPT                           --减值准备
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,BUS_ID                             --业务编号
    ,STL_DT                             --结算日期
  )
  SELECT
     T.DATA_DT                            --数据日期
    ,T.LGL_REP_ID                         --法人编号
    ,T.CUST_ID                            --客户编号
    ,T.ORG_ID                             --机构编号
    ,T.ACC_ID                             --账户编号
    ,T.LMT_ID                             --额度编号
    ,T.ACC_TYP                            --账户类型
    ,T.CUR                                --币种
    ,T.REPO_BIZ_TYP                       --回购业务类型
    ,T.ULYG_AST_TYP                       --标的资产类型
    ,T.ULYG_PROD_ID                       --标的产品编号
    ,T.OPR_TYP                            --经营类型
    ,T.AMT                                --发生额
    ,T.BAL                                --余额
    ,T.INT                                --利息
    ,T.NEXT_INT_PAY_DT                    --下一付息日
    ,T.START_DT                           --起始日期
    ,T.EXP_DT                             --到期日期
    ,T.RATE_RE_PRC_DT                     --利率重新定价日期
    ,T.LVL5_CL                            --五级分类
    ,T.MRGN_CUR                           --保证金币种
    ,T.MRGN                               --保证金
    ,T.SPCL_PRO                           --专项准备
    ,T.PARTI_PRO                          --特种准备
    ,T.COM_PRO                            --一般准备
    ,T.INT_CALC_FLG                       --计息标志
    ,T.COLL_RSK_CL                        --担保品风险分类
    ,T.ULYG_MKT_VAL                       --标的物市场价值
    ,T.RE_MTG_FLG                         --再抵押标志
    ,T.NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,T.APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,T.RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,T.FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,T.FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,T.ACT_RATE                           --实际利率
    ,T.BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,T.STATS_SUBJ_ID                      --统计科目编号
    ,T.REPY_ACC                           --还款账号
    ,T.LOAN_ETR_ACC                       --贷款入账账号
    ,T.SUBJ_ID                            --科目编号
    ,T.OPEN_ACC_DT                        --开户日期
    ,T.CNL_ACC_DT                         --销户日期
    ,T.OVD_DT                             --逾期日期
    ,T.LAST_REPY_DT                       --上次还款日期
    ,T.OUT_INT_OVD_BAL                    --表外欠息余额
    ,T.BASE_RATE                          --基准利率
    ,T.RATE_FLT_FREQ                      --利率浮动频率
    ,T.PRC_BASE_TYP                       --定价基准类型
    ,T.INT_CALC_MODE                      --计息方式
    ,T.ACT_END_DT                         --实际终止日期
    ,T.APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,T.APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,T.APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,T.PRO_IMPT                           --减值准备
    ,T.DEPT_LINE                          --部门条线
    ,T.DATA_SRC                           --数据来源
    ,T.BUS_ID                             --业务编号
    ,T.STL_DT                             --结算日期
  FROM (
    SELECT
         TO_CHAR(A.ETL_DT,'YYYYMMDD')                       AS DATA_DT                            --数据日期
        ,A.LP_ID                                            AS LGL_REP_ID                         --法人编号
        ,B.CUST_ID                                          AS CUST_ID                            --客户编号
        ,A.ACCT_INSTIT_ID                                   AS ORG_ID                             --机构编号
        ,A.BUS_ID                                           AS ACC_ID                             --账户编号
        ,NULL                                               AS LMT_ID                             --额度编号
        ,NULL                                               AS ACC_TYP                            --账户类型
        ,A.CURR_CD                                          AS CUR                                --币种
        ,CASE WHEN A.BUS_TYPE_CD = 'BT02' THEN '10101'
              WHEN A.BUS_TYPE_CD = 'BT03' THEN '10102'
         END                                                AS REPO_BIZ_TYP                       --回购业务类型 BT02-质押式回购 BT03-买断式回购
        ,'2'                                                AS ULYG_AST_TYP                 --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
        ,A.BILL_ID                                          AS ULYG_PROD_ID                       --标的产品编号
        ,'A'                                                AS OPR_TYP                            --经营类型
        ,A.FAC_VAL_AMT                                      AS AMT                                --发生额
        ,A.CURRT_BAL                                          AS BAL                                --余额
        ,A.INT_AMT                                          AS INT                                --利息
        ,NULL                                               AS NEXT_INT_PAY_DT                    --下一付息日
        --,TO_CHAR(A.DRAW_DT,'YYYYMMDD')                      AS START_DT                           --起始日期
        ,TO_CHAR(A.BUS_DT,'YYYYMMDD')                      AS START_DT                           --起始日期
        --modify by LHQ 20220617 根据源系统口径修改起始日期取值
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                       AS EXP_DT                             --到期日期
        ,NULL                                               AS RATE_RE_PRC_DT                     --利率重新定价日期
        ,NULL                                               AS LVL5_CL                            --五级分类
        ,NULL                                               AS MRGN_CUR                           --保证金币种
        ,NULL                                               AS MRGN                               --保证金
        ,NULL                                               AS SPCL_PRO                           --专项准备
        ,NULL                                               AS PARTI_PRO                          --特种准备
        ,NULL                                               AS COM_PRO                            --一般准备
        ,'1'                                               AS INT_CALC_FLG                       --计息标志
        ,NULL                                               AS COLL_RSK_CL                        --担保品风险分类
        ,NULL                                               AS ULYG_MKT_VAL                       --标的物市场价值
        ,NULL                                               AS RE_MTG_FLG                         --再抵押标志
        ,NULL                                               AS NET_AMT_SETL_AGRT_NO               --净额结算协议号
        ,A.REPO_AMT                                         AS APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
        ,NULL                                               AS RSK_EXP_DISC_COE                   --风险暴露折扣系数
        ,NULL                                               AS FIN_PLG_DISC_COE                   --金融质押品折扣系数
        ,NULL                                               AS FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
        ,A.DISCNT_INT_RAT                                   AS ACT_RATE                           --实际利率
        ,A.DISCNT_INT_RAT                                   AS BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
        ,NULL                                               AS STATS_SUBJ_ID                      --统计科目编号
        ,NULL                                               AS REPY_ACC                           --还款账号
        ,NULL                                               AS LOAN_ETR_ACC                       --贷款入账账号
        ,A.SUBJ_ID                                               AS SUBJ_ID                        --科目编号
        ,NULL                                               AS OPEN_ACC_DT                        --开户日期
        ,NULL                                               AS CNL_ACC_DT                         --销户日期
        ,NULL                                               AS OVD_DT                             --逾期日期
        ,NULL                                               AS LAST_REPY_DT                       --上次还款日期
        ,NULL                                               AS OUT_INT_OVD_BAL                    --表外欠息余额
        ,NULL                                               AS BASE_RATE                          --基准利率
        ,NULL                                               AS RATE_FLT_FREQ                      --利率浮动频率
        ,NULL                                               AS PRC_BASE_TYP                       --定价基准类型
        ,NULL                                               AS INT_CALC_MODE                      --计息方式
        ,TO_CHAR(A.ACTL_EXP_DT,'YYYYMMDD')                  AS ACT_END_DT                         --实际终止日期
        ,TO_CHAR(A.REPO_DT,'YYYYMMDD')                      AS APPT_RESL_OR_REPO_DT               --约定返售或回购日期
      /*  ,A.REDEM_INT_RAT                                    AS APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
        ,A.REPO_INT_AMT                                     AS APPT_RESL_OR_REPO_INT               --约定返售或回购利息*/
       /* ,A.DISCNT_INT_RAT                                    AS APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
         --modify by LHQ 20220617修改利率利息口径
        ,A.INT_AMT                                     AS APPT_RESL_OR_REPO_INT                    --约定返售或回购利息*/
         ,CASE WHEN A.BUS_TYPE_CD ='BT02' THEN A.DISCNT_INT_RAT
               WHEN A.BUS_TYPE_CD ='BT03' THEN A.REDEM_INT_RAT
                END                                         AS APPT_RESL_OR_REPO_RATE               --约定返售或回购利率
                                                 --modify 20220908 修改买断式和质押式回购利率取值 LHQ
        ,CASE WHEN A.BUS_TYPE_CD ='BT02' THEN A.INT_AMT
              WHEN A.BUS_TYPE_CD ='BT03' THEN A.REPO_INT_AMT
               END                                          AS APPT_RESL_OR_REPO_INT                --约定返售或回购利息
        ,D.N_ECL_BEFORE                                     AS PRO_IMPT            --减值准备
        ,NULL                                               AS DEPT_LINE                          --部门条线
        ,'票据回购'                                          AS DATA_SRC                           --数据来源
        ,A.BUS_ID                                           AS BUS_ID                          --业务编号
        ,TO_CHAR(A.STL_DT,'YYYYMMDD')                       AS STL_DT                         --结算日期
        ,ROW_NUMBER() OVER(PARTITION BY A.BILL_ID ORDER BY A.ACTL_REPO_DT DESC)  AS NUM
      FROM O_ICL_CMM_BILL_DISCOUNT_INFO A   --票据转贴现信息
 LEFT JOIN O_ICL_CMM_BILL_CENTER_INFO B  --票据中心信息
        ON A.BILL_ID = B.BILL_ID
       AND A.ETL_DT = B.ETL_DT
 LEFT JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO M --对公贷款借据信息
      ON A.BILL_ID = M.BILL_ID
      AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
 LEFT JOIN O_IOL_IFRS_FCT_ECL_RES_DTL  D  --减值结果表
      ON D.V_ID_NUMBER = /*M.DUBIL_ID*/A.BILL_NUM
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.TRAN_DIR_CD = '01'  --买入
       AND A.BUS_TYPE_CD IN ('BT02' ,'BT03') -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
       AND A.ENTRY_STATUS_CD = '03'  --筛选记账成功的票据
    --modify by 蔡正伟 20220428 实际回购日期不为空的数据剔除 begin
    /*   AND (A.ACTL_REPO_DT >= V_START_DT OR A.ACTL_REPO_DT IS NULL)*/


    /*AND A.ETL_DT IS NOT NULL
  AND B.CUST_ID IS NOT NULL
  AND A.ACCT_INSTIT_ID IS NOT NULL
  AND A.CURR_CD IS NOT NULL
  AND A.FAC_VAL_AMT IS NOT NULL
  AND A.STL_AMT IS NOT NULL
  AND A.INT_AMT IS NOT NULL
  AND A.DRAW_DT IS NOT NULL
  AND A.EXP_DT IS NOT NULL
  AND A.REPO_AMT IS NOT NULL
  AND A.REPO_DT IS NOT NULL
  --AND C.EXP_INT_RAT IS NOT NULL
  AND A.REPO_INT_AMT IS NOT NULL*/

/*    AND A.ACTL_REPO_DT IS NULL
*/    --modify by 蔡正伟 20220428 实际回购日期不为空的数据剔除 end
  ) T
  WHERE T.NUM = 1
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金债券回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_AST_INFO
  ( DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,ACC_ID                             --账户编号
    ,LMT_ID                             --额度编号
    ,ACC_TYP                            --账户类型
    ,CUR                                --币种
    ,REPO_BIZ_TYP                       --回购业务类型
    ,ULYG_AST_TYP                       --标的资产类型
    ,ULYG_PROD_ID                       --标的产品编号
    ,OPR_TYP                            --经营类型
    ,AMT                                --发生额
    ,BAL                                --余额
    ,INT                                --利息
    ,NEXT_INT_PAY_DT                    --下一付息日
    ,START_DT                           --起始日期
    ,EXP_DT                             --到期日期
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,LVL5_CL                            --五级分类
    ,MRGN_CUR                           --保证金币种
    ,MRGN                               --保证金
    ,SPCL_PRO                           --专项准备
    ,PARTI_PRO                          --特种准备
    ,COM_PRO                            --一般准备
    ,INT_CALC_FLG                       --计息标志
    ,COLL_RSK_CL                        --担保品风险分类
    ,ULYG_MKT_VAL                       --标的物市场价值
    ,RE_MTG_FLG                         --再抵押标志
    ,NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                           --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,STATS_SUBJ_ID                      --统计科目编号
    ,REPY_ACC                           --还款账号
    ,LOAN_ETR_ACC                       --贷款入账账号
    ,SUBJ_ID                            --科目编号
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                         --销户日期
    ,OVD_DT                             --逾期日期
    ,LAST_REPY_DT                       --上次还款日期
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,PRC_BASE_TYP                       --定价基准类型
    ,INT_CALC_MODE                      --计息方式
    ,ACT_END_DT                         --实际终止日期
    ,APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,PRO_IMPT                           --减值准备
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,TRAN_ID                            --交易编号
    ,BUS_ID                             --业务编号
    ,SPV_CUST_ID                        --SPV客户编号
  )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID                           --法人编号
    ,NVL(G.PARTY_ID,A.CUST_ID)/*NVL(TRIM(E.CUST_ID), NVL(TRIM(E.PARTY_ID), '-'))*/ AS CUST_ID  --MODIFY BY XUXIAOBIN 2022/07/12
    ,A.ENTRY_ORG_ID                  AS ORG_ID                             --机构编号
    ,--A.BUS_ID
    SUBSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,1,INSTR(A.BAG_ID || '.' || A.BOND_ID_COMB,'.')-1) AS ACC_ID  --MODIFY BY XUXIAOBIN 2022/07/12 AS ACC_ID                              --账户编号
    ,NULL AS LMT_ID                                  --额度编号
    ,NULL AS ACC_TYP                                 --账户类型
    ,A.CURR_CD AS CUR                                --币种
    ,TTA.TAR_VALUE_CODE AS REPO_BIZ_TYP                   --回购业务类型
    ,'1'  AS ULYG_AST_TYP         --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
    ,B.BOND_ID AS ULYG_PROD_ID                       --标的产品编号
    ,'A' AS OPR_TYP                            --经营类型
    ,A.TRAN_AMT AS AMT                                --发生额
    ,A.CURR_BAL AS BAL                          --余额  当前金额
    ,A.ACRU_INT AS INT                          --利息  应计利息
    ,NULL AS NEXT_INT_PAY_DT                    --下一付息日
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS START_DT  --起始日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT      --到期日期
    ,NULL AS RATE_RE_PRC_DT                     --利率重新定价日期
    ,NULL AS LVL5_CL                            --五级分类
    ,NULL AS MRGN_CUR                           --保证金币种
    ,NULL AS MRGN                               --保证金
    ,NULL AS SPCL_PRO                           --专项准备
    ,NULL AS PARTI_PRO                          --特种准备
    ,NULL AS COM_PRO                            --一般准备
    ,'1' AS INT_CALC_FLG                       --计息标志
    ,NULL AS COLL_RSK_CL                        --担保品风险分类
    ,NULL AS ULYG_MKT_VAL                       --标的物市场价值
    ,NULL AS RE_MTG_FLG                         --再抵押标志
    ,NULL AS NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,NULL AS APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,NULL AS RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,NULL AS FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,NULL AS FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,A.REPO_INT_RAT AS ACT_RATE                 --实际利率
    ,A.REPO_INT_RAT AS BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,NULL AS STATS_SUBJ_ID                      --统计科目编号
    ,NULL AS REPY_ACC                           --还款账号
    ,NULL AS LOAN_ETR_ACC                       --贷款入账账号
    ,A.SUBJ_ID AS SUBJ_ID                        --科目编号
    ,NULL AS OPEN_ACC_DT                        --开户日期
    ,NULL AS CNL_ACC_DT                         --销户日期
    ,NULL AS OVD_DT                             --逾期日期
    ,NULL AS LAST_REPY_DT                       --上次还款日期
    ,NULL AS OUT_INT_OVD_BAL                    --表外欠息余额
    ,NULL AS BASE_RATE                          --基准利率
    ,NULL AS RATE_FLT_FREQ                      --利率浮动频率
    ,NULL AS PRC_BASE_TYP                       --定价基准类型
    ,NULL AS INT_CALC_MODE                      --计息方式
    ,NULL AS ACT_END_DT                         --实际终止日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD')               AS APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,A.REPO_INT_RAT                             AS APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,A.INT_RECVBL                               AS APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,NVL(TRIM(F.N_ECL_BEFORE),B.IMPAM_PREP)       --减值准备
    ,NULL AS DEPT_LINE                          --部门条线
    ,'债券回购' AS DATA_SRC           --数据来源
    ,A.TRAN_ID AS TRAN_ID             --交易编号
    ,A.BUS_ID  AS BUS_ID              --业务编号
    ,G.SPV_CUST_ID AS SPV_CUST_ID     --SPV客户编号
  FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO A  --资金债券回购
  LEFT JOIN O_ICL_CMM_CAP_BUS_POST B --资金债券持仓
  ON B.BUS_ID = A.BUS_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN  O_IML_PTY_SPV_CUST_INFO G --SPV客户信息
         ON  A.CUST_ID=G.SPV_CUST_ID
        AND  G.START_DT<=TO_DATE(V_P_DATE, 'YYYYMMDD')
        AND  G.END_DT>TO_DATE(V_P_DATE, 'YYYYMMDD')
/*    LEFT JOIN O_IML_PTY_CAP_CNTPTY_INFO E --资金交易对手信息  --MODIFY BY XUXIAOBIN 2022/07/12
    ON A.CNTPTY_ID = E.CNTPTY_ID
   AND E.ETL_DT = A.ETL_DT*/
 /*  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D  --对公客户信息
         ON A.CUST_ID=D.CUST_ID
         AND D.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        LEFT JOIN  O_IML_PTY_SPV_CUST_INFO G --SPV客户信息
          ON A.CUST_ID=G.SPV_CUST_ID
          AND  G.START_DT<=TO_DATE(V_P_DATE, 'YYYYMMDD')
          AND  G.END_DT>TO_DATE(V_P_DATE, 'YYYYMMDD')
       LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO F  --对公客户信息
         ON G.PARTY_ID=F.CUST_ID
         AND F.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')*/
     LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
      ON B.MAIN_ASSET_ID = F.V_ID_NUMBER
     AND F.ETL_DT = /*A.ETL_DT*/V_DATE
     LEFT JOIN CODE_MAP TTA --回购类型转码
     ON TTA.SRC_VALUE_CODE = A.REPO_TYPE_CD
     AND TTA.SRC_CLASS_CODE = 'CD1185'
     AND TTA.TAR_CLASS_CODE = 'T0012'
     AND MOD_FLG = 'MDM'
  WHERE A.SUBJ_ID LIKE '111102%'   --买入返售债券
    AND A.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND A.CURR_BAL>0 20221031 JS是报送一个月，月中结清月底余额则为0
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入外币回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_AST_INFO
  ( DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,ACC_ID                             --账户编号
    ,LMT_ID                             --额度编号
    ,ACC_TYP                            --账户类型
    ,CUR                                --币种
    ,REPO_BIZ_TYP                       --回购业务类型
    ,ULYG_AST_TYP                       --标的资产类型
    ,ULYG_PROD_ID                       --标的产品编号
    ,OPR_TYP                            --经营类型
    ,AMT                                --发生额
    ,BAL                                --余额
    ,INT                                --利息
    ,NEXT_INT_PAY_DT                    --下一付息日
    ,START_DT                           --起始日期
    ,EXP_DT                             --到期日期
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,LVL5_CL                            --五级分类
    ,MRGN_CUR                           --保证金币种
    ,MRGN                               --保证金
    ,SPCL_PRO                           --专项准备
    ,PARTI_PRO                          --特种准备
    ,COM_PRO                            --一般准备
    ,INT_CALC_FLG                       --计息标志
    ,COLL_RSK_CL                        --担保品风险分类
    ,ULYG_MKT_VAL                       --标的物市场价值
    ,RE_MTG_FLG                         --再抵押标志
    ,NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                           --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,STATS_SUBJ_ID                      --统计科目编号
    ,REPY_ACC                           --还款账号
    ,LOAN_ETR_ACC                       --贷款入账账号
    ,SUBJ_ID                            --科目编号
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                         --销户日期
    ,OVD_DT                             --逾期日期
    ,LAST_REPY_DT                       --上次还款日期
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,PRC_BASE_TYP                       --定价基准类型
    ,INT_CALC_MODE                      --计息方式
    ,ACT_END_DT                         --实际终止日期
    ,APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,PRO_IMPT                           --减值准备
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,BUS_ID                             --业务编号
  )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID                           --法人编号
    ,CASE WHEN A.CUST_ID=' ' THEN A.CNTPTY_ID ELSE A.CUST_ID END AS CUST_ID  --客户编号
    --NVL(TRIM(E.CUST_ID), NVL(TRIM(E.CNTPTY_ID), '-'))
    ,A.ENTRY_ORG_ID        AS ORG_ID                             --机构编号
    ,/*A.BUS_ID*/A.BAG_ID AS ACC_ID                              --账户编号
    ,NULL AS LMT_ID                                  --额度编号
    ,NULL AS ACC_TYP                                 --账户类型
    ,A.CURR_CD AS CUR                                --币种
    ,'10101' AS REPO_BIZ_TYP                            --回购业务类型
    ,'1'  AS ULYG_AST_TYP                     --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
    ,NULL AS ULYG_PROD_ID                       --标的产品编号
    ,'A' AS OPR_TYP                            --经营类型
    ,A.TRAN_AMT AS AMT                                --发生额
    ,A.CURRT_BAL AS BAL                          --余额  当期余额
    ,A.ACRU_INT AS INT                          --利息  应计利息
    ,NULL AS NEXT_INT_PAY_DT                    --下一付息日
    ,TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS START_DT                           --起始日期
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT                             --到期日期
    ,NULL AS RATE_RE_PRC_DT                     --利率重新定价日期
    ,NULL AS LVL5_CL                            --五级分类
    ,NULL AS MRGN_CUR                           --保证金币种
    ,NULL AS MRGN                               --保证金
    ,NULL AS SPCL_PRO                           --专项准备
    ,NULL AS PARTI_PRO                          --特种准备
    ,NULL AS COM_PRO                            --一般准备
    ,'1' AS INT_CALC_FLG                       --计息标志
    ,NULL AS COLL_RSK_CL                        --担保品风险分类
    ,NULL AS ULYG_MKT_VAL                       --标的物市场价值
    ,NULL AS RE_MTG_FLG                         --再抵押标志
    ,NULL AS NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,NULL AS APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,NULL AS RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,NULL AS FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,NULL AS FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,A.EXEC_INT_RAT AS ACT_RATE                           --实际利率
    ,NULL AS BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,NULL AS STATS_SUBJ_ID                      --统计科目编号
    ,NULL AS REPY_ACC                           --还款账号
    ,NULL AS LOAN_ETR_ACC                       --贷款入账账号
    ,A.SUBJ_ID AS SUBJ_ID                            --科目编号
    ,NULL AS OPEN_ACC_DT                        --开户日期
    ,NULL AS CNL_ACC_DT                         --销户日期
    ,NULL AS OVD_DT                             --逾期日期
    ,NULL AS LAST_REPY_DT                       --上次还款日期
    ,NULL AS OUT_INT_OVD_BAL                    --表外欠息余额
    ,A.BASE_RAT AS BASE_RATE                          --基准利率
    ,NULL AS RATE_FLT_FREQ                      --利率浮动频率
    ,NULL AS PRC_BASE_TYP                       --定价基准类型
    ,'07' AS INT_CALC_MODE                      --计息方式
    ,NULL AS ACT_END_DT                         --实际终止日期
    ,NULL AS APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,NULL AS APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,NULL AS APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,F.N_ECL_BEFORE  AS PRO_IMPT            --减值准备
    ,NULL AS DEPT_LINE                          --部门条线
    ,'外币回购' AS DATA_SRC           --数据来源
    ,A.BUS_ID  AS BUS_ID                        --业务编号
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A  --外汇同业拆借表
  /*LEFT JOIN O_IML_PTY_FX_CAP_CNTPTY E --外汇资金交易对手表  --MODIFY BY XUXIAOBIN 2022/07/12
    ON A.CNTPTY_ID = E.CNTPTY_ID
   AND E.ETL_DT = A.ETL_DT*/
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
    ON F.V_ID_NUMBER = A.BOND_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.TRAN_ACCT_B_ID
     AND F.ETL_DT = /*A.ETL_DT*/V_DATE
  WHERE A.SUBJ_ID LIKE '111102%'   --买入返售债券
    AND A.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.INV_PORT_STATUS_CD IN ('A','C')--20230102 XUXIAOBIN ADD 来源陆炜迪提数脚本
    --AND A.CURRT_BAL > 0 20221031 JS是报送一个月，月中结清月底余额则为0
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入同业现金借贷质押式回购信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_REPO_AST_INFO
  ( DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,ACC_ID                             --账户编号
    ,LMT_ID                             --额度编号
    ,ACC_TYP                            --账户类型
    ,CUR                                --币种
    ,REPO_BIZ_TYP                       --回购业务类型
    ,ULYG_AST_TYP                       --标的资产类型
    ,ULYG_PROD_ID                       --标的产品编号
    ,OPR_TYP                            --经营类型
    ,AMT                                --发生额
    ,BAL                                --余额
    ,INT                                --利息
    ,NEXT_INT_PAY_DT                    --下一付息日
    ,START_DT                           --起始日期
    ,EXP_DT                             --到期日期
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,LVL5_CL                            --五级分类
    ,MRGN_CUR                           --保证金币种
    ,MRGN                               --保证金
    ,SPCL_PRO                           --专项准备
    ,PARTI_PRO                          --特种准备
    ,COM_PRO                            --一般准备
    ,INT_CALC_FLG                       --计息标志
    ,COLL_RSK_CL                        --担保品风险分类
    ,ULYG_MKT_VAL                       --标的物市场价值
    ,RE_MTG_FLG                         --再抵押标志
    ,NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,ACT_RATE                           --实际利率
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,STATS_SUBJ_ID                      --统计科目编号
    ,REPY_ACC                           --还款账号
    ,LOAN_ETR_ACC                       --贷款入账账号
    ,SUBJ_ID                            --科目编号
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                         --销户日期
    ,OVD_DT                             --逾期日期
    ,LAST_REPY_DT                       --上次还款日期
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,PRC_BASE_TYP                       --定价基准类型
    ,INT_CALC_MODE                      --计息方式
    ,ACT_END_DT                         --实际终止日期
    ,APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,PRO_IMPT            --减值准备
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,BUS_ID                             --业务编号

  )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
    ,A.LP_ID AS LGL_REP_ID                           --法人编号
    ,--CASE WHEN A.CNTPTY_CUST_ID=' ' THEN A.CNTPTY_ID ELSE A.CNTPTY_CUST_ID END
    DECODE(NVL(TRIM(D.CUST_ID), NVL(TRIM(D.SRC_PARTY_ID), '-')),
        '-',
        '9620007313',
        NVL(TRIM(D.CUST_ID), NVL(TRIM(D.SRC_PARTY_ID), '-'))) AS CUST_ID  --客户编号 MODIFY BY XUXIAOBIN 2022/07/12
    ,A.BELONG_ORG_ID AS ORG_ID                             --机构编号
    ,A.BUS_ID AS ACC_ID                              --账户编号
    ,NULL AS LMT_ID                                  --额度编号
    ,NULL AS ACC_TYP                                 --账户类型
    ,A.CURR_CD AS CUR                                --币种
    ,'10101' AS REPO_BIZ_TYP                            --回购业务类型
    ,'1'  AS ULYG_AST_TYP                            --标的资产类型 1.债券 2：商业汇票 3:其他票据 4:信贷资产 5:股票及其他股权 6 黄金 0 其他标的物
    ,A.FIN_INSTM_ID AS ULYG_PROD_ID                       --标的产品编号
    ,'A' AS OPR_TYP                            --经营类型
    ,A.TRAN_AMT AS AMT                                --发生额
    ,A.CURRT_BAL AS BAL                          --余额  当期余额
    ,A.ACRU_INT AS INT                          --利息  应计利息
    ,NULL AS NEXT_INT_PAY_DT                    --下一付息日
    ,/*TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS START_DT                           --起始日期*/
     TO_CHAR(TRD.CFM_DT,'YYYYMMDD') AS START_DT                           --起始日期 20221107 XUXIAOBIN MODIFY
    ,TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT                             --到期日期
    ,NULL AS RATE_RE_PRC_DT                     --利率重新定价日期
    ,NULL AS LVL5_CL                            --五级分类
    ,NULL AS MRGN_CUR                           --保证金币种
    ,NULL AS MRGN                               --保证金
    ,NULL AS SPCL_PRO                           --专项准备
    ,NULL AS PARTI_PRO                          --特种准备
    ,NULL AS COM_PRO                            --一般准备
    ,'1' AS INT_CALC_FLG                       --计息标志
    ,NULL AS COLL_RSK_CL                        --担保品风险分类
    ,NULL AS ULYG_MKT_VAL                       --标的物市场价值
    ,NULL AS RE_MTG_FLG                         --再抵押标志
    ,NULL AS NET_AMT_SETL_AGRT_NO               --净额结算协议号
    ,NULL AS APPT_RESL_OR_REPO_PRC              --约定返售或回购价格
    ,NULL AS RSK_EXP_DISC_COE                   --风险暴露折扣系数
    ,NULL AS FIN_PLG_DISC_COE                   --金融质押品折扣系数
    ,NULL AS FIN_COLL_RSK_COE                   --金融质押品和风险暴露币种错配系数
    ,A.FAC_VAL_INT_RAT AS ACT_RATE                           --实际利率
    ,NULL AS BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,NULL AS STATS_SUBJ_ID                      --统计科目编号
    ,NULL AS REPY_ACC                           --还款账号
    ,NULL AS LOAN_ETR_ACC                       --贷款入账账号
    ,A.SUBJ_ID AS SUBJ_ID                            --科目编号
    ,NULL AS OPEN_ACC_DT                        --开户日期
    ,NULL AS CNL_ACC_DT                         --销户日期
    ,NULL AS OVD_DT                             --逾期日期
    ,NULL AS LAST_REPY_DT                       --上次还款日期
    ,NULL AS OUT_INT_OVD_BAL                    --表外欠息余额
    ,A.BASE_RAT AS BASE_RATE                          --基准利率
    ,NULL AS RATE_FLT_FREQ                      --利率浮动频率
    ,NULL AS PRC_BASE_TYP                       --定价基准类型
    ,CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01'-- 0M	按月
               WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q	按季 3M	按3个月
               WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03'-- 1Y	按年
               WHEN A.PAY_INT_PED_CD = '6M' THEN '06'-- 6M	按6个月
               --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
               ELSE '99' --其他 00	未知 0D	按日 1M	按周 4M	按4个月
               END   --20220929 XUXIAOBIN ADD
     AS INT_CALC_MODE                      --计息方式
    ,NULL AS ACT_END_DT                         --实际终止日期
    ,NULL AS APPT_RESL_OR_REPO_DT               --约定返售或回购日期
    ,NULL AS APPT_RESL_OR_REPO_RATE             --约定返售或回购利率
    ,NULL AS APPT_RESL_OR_REPO_INT              --约定返售或回购利息
    ,F.N_ECL_BEFORE AS PRO_IMPT                --减值准备
    ,NULL AS DEPT_LINE                          --部门条线
    ,'同业买入返售' AS DATA_SRC           --数据来源
    ,A.BUS_ID    AS BUS_ID          --业务编号
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷
  LEFT JOIN O_IML_PTY_IBANK_CNTPTY_INFO D --同业交易对手信息表
    ON A.CNTPTY_ID = D.SRC_PARTY_ID
   AND D.ETL_DT = A.ETL_DT
  LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F --减值结果表
      ON F.V_ID_NUMBER = A.OBJ_ID||'_'||A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD
     AND F.ETL_DT = /*A.ETL_DT*/TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN O_IML_EVT_IBANK_TRAN TRD --同业交易表 ADD BY XUXIAOBIN 20221107
        ON A.BUS_ID = TRD.INTNAL_TRAN_NUM
       AND A.ETL_DT = TRD.ETL_DT
  WHERE A.SUBJ_ID LIKE '111102%'   --买入返售
    AND A.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND A.CURRT_BAL>0 20221031 JS是报送一个月，月中结清月底余额则为0
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
    SELECT DATA_DT, ACC_ID,COUNT(1)
      FROM M_CPTL_REPO_AST_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ACC_ID
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

  END ETL_INIT_M_CPTL_REPO_AST_INFO;
/

