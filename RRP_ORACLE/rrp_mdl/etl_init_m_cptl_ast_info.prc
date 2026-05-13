CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CPTL_AST_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CPTL_AST_INFO
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
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_M_CPTL_AST_INFO'; -- 程序名称
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
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CPTL_AST_INFO'; --表名
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
  V_STEP_DESC := '插入资金业务（资产方）信息--资金系统同业拆借';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
       -- ,SPCL_PRO  --专项准备
       -- ,PARTI_PRO  --特种准备
       -- ,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG  --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT --DISTINCT
       V_P_DATE AS DATA_DT, --1  数据日期
       A.LP_ID AS LGL_REP_ID, --2  法人编号
       A.ENTRY_ORG_ID AS ORG_ID, --3  机构编号
       A.CUST_ID,                --4  客户编号 暂行
       COALESCE(A.BAG_ID,A.BUS_ID) AS ACC_ID, --5  账户编号
       A.ACCT_B_ATTR_CD AS ACC_TYP, --6  账户类型
       A.CURR_CD AS CUR, --7  币种
       '10201'  AS BIZ_TYP, --8  业务类型  101存放同业  102拆放同业  103同业借款  10203同业代付   10501法透交易
       TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS START_DT, --9  起始日期
       TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT, --10  到期日期
       A.EXEC_INT_RAT AS ACT_RATE, --11  实际利率
       A.CURRT_ACRU_INT AS INT, --12  利息
       --A.ACRU_INT AS INT, --12  利息  --应计利息
       NULL AS NEXT_INT_PAY_DT, --13  下一付息日
       NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
       A.TRAN_AMT AS BIZ_AMT, --15  业务发生金额
       A.CURRT_BAL AS BAL, --16  余额
/*       CASE WHEN A.CURR_CD <> 'CNY' THEN NVL(A.CURRT_BAL,0) * F.MDL_PRICE / 100
         ELSE NVL(A.CURRT_BAL,0)
        END AS BAL,   -- 余额*/
       NULL AS OVD_PRIN_AMT, --17  逾期本金金额
       NULL AS OVD_INT_AMT, --18  逾期利息金额
       NULL AS LVL5_CL, --19  五级分类
       NULL AS MRGN, --20  保证金
       NULL AS MRGN_CUR, --21  保证金币种
      -- NULL AS SPCL_PRO, --22  专项准备
      -- NULL AS PARTI_PRO, --23  特种准备
       --NULL AS COM_PRO, --24  一般准备
       NULL AS PEERS_PAY_FLG, --25  同业代付标志
       NULL AS ACTP_BILL_NO, --26  承兑汇票票号
       NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
       NULL AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
       NULL AS BIZ_REL_FLG, --29  业务关系标志
       NULL AS COLL_RSK_CL, --30  担保品风险分类
       NULL AS COLL_MKT_VAL, --31  担保品市场价值
       NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
       NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
       NULL AS AGRT_OD_FLG, --34  协议透支标志
       NULL AS SPV_FLG, --35  特殊目的载体标志
       NULL AS GUA_FINC_FLG, --36  保本理财标志
       NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
       NULL AS OUTSRC_FLG, --38  委外标志
       'RF01' AS RATE_TYP, --39  利率类型
       'TR99' AS PRC_BASE_TYP, --40  定价基准类型
       A.EXEC_INT_RAT AS BASE_RATE, --41  基准利率
       '99' AS RATE_FLT_FREQ, --42  利率浮动频率
       '07' AS INT_CALC_MODE, --43  计息方式 --07 利随本清 20220929 xuxiaobin ADD
       NULL AS CRDT_LMT_ID, --44  授信额度编号
       NULL AS ACT_END_DT, --45  实际终止日期
       NULL AS DEP_RSV_MODE, --46  缴存准备金方式
       '800919' AS DEPT_LINE, --47  部门条线
       /*UPPER(SUBSTR(A.JOB_CD,1,4))*/'资金同业拆借' AS DATA_SRC, --48  数据来源
       NULL AS SUB_ACC_ID, --子账户编号
       NULL AS TIME_DWD_FLG,  --定活标志
       NULL AS FIN_INSTM_ID, --金融工具编号
       A.BUS_ID AS BUS_ID, --业务编号
       A.ASSET_THD_CLS_CD AS ASSET_THD_CLS_CD, --资产三分类代码
       A.STD_PROD_ID      AS STD_PROD_ID,      --标准产品编号
       A.SUBJ_ID          AS SUBJ_ID,          --科目编号
       A.TRAN_ID          AS TRAN_ID           --交易编号
      ,NULL               AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
  FROM O_ICL_CMM_CAP_IB_LEND A --资金同业拆借 A
/*  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
    ON A.CNTPTY_ID = G.CUST_ID
   AND G.ETL_DT = A.ETL_DT*/
  /*LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO TI --同业客户特有信息
    ON G.CUST_ID = TI.PARTY_ID
   AND TI.FIN_INST_CATE_CD != '000000'
   AND TI.START_DT <= A.ETL_DT
   AND TI.END_DT > A.ETL_DT*/
/*   LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D -- 对公客户关联人信息表
       ON A.CUST_ID = D.CUST_ID
       AND  D.RELA_TYPE_CD = '30101'--法定代表人
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
/*  LEFT JOIN O_ICL_CMM_EXCH_RAT_INFO F        -- 汇率信息表
       ON A.CURR_CD = F.CURR_CD*/
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   AND A.SUBJ_ID LIKE '130201%' -- 拆放境内同业款项 20220929 XUXIAOBIN MODIFY
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息--外汇系统-同业拆借、外币回购借';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
        --,SPCL_PRO  --专项准备
       -- ,PARTI_PRO  --特种准备
       -- ,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG  --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT DISTINCT
        V_P_DATE AS DATA_DT, --1  数据日期
         A.LP_ID AS LGL_REP_ID, --2  法人编号
         A.ENTRY_ORG_ID AS ORG_ID, --3  机构编号
         A.CUST_ID,                --4  客户编号
         COALESCE(A.BAG_ID,A.BOND_ID) AS ACC_ID, --5  账户编号
         NULL AS ACC_TYP, --6  账户类型
         A.CURR_CD AS CUR, --7  币种
         '10201' AS BIZ_TYP, --8  业务类型  拆放同业
         TO_CHAR(A.VALUE_DT/*INPUT_DT*/,'YYYYMMDD') AS START_DT, --9  起始日期
         TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT, --10  到期日期
         A.EXEC_INT_RAT AS ACT_RATE, --11  实际利率
         A.CURRT_ACRU_INT AS INT, --12  利息
         NULL AS NEXT_INT_PAY_DT, --13  下一付息日
         NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
         A.TRAN_AMT AS BIZ_AMT, --15  业务发生金额
         A.CURRT_BAL AS BAL, --16  余额
         NULL AS OVD_PRIN_AMT, --17  逾期本金金额
         NULL AS OVD_INT_AMT, --18  逾期利息金额
         NULL AS LVL5_CL, --19  五级分类
         NULL AS MRGN, --20  保证金
         NULL AS MRGN_CUR, --21  保证金币种
        -- NULL AS SPCL_PRO, --22  专项准备
        -- NULL AS PARTI_PRO, --23  特种准备
        -- NULL AS COM_PRO, --24  一般准备
         NULL AS PEERS_PAY_FLG, --25  同业代付标志
         NULL AS ACTP_BILL_NO, --26  承兑汇票票号
         NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
         NULL AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
         NULL AS BIZ_REL_FLG, --29  业务关系标志
         NULL AS COLL_RSK_CL, --30  担保品风险分类
         NULL AS COLL_MKT_VAL, --31  担保品市场价值
         NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
         NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
         NULL AS AGRT_OD_FLG, --34  协议透支标志
         NULL AS SPV_FLG, --35  特殊目的载体标志
         NULL AS GUA_FINC_FLG, --36  保本理财标志
         NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
         NULL AS OUTSRC_FLG, --38  委外标志
         CASE WHEN A.INT_RAT_ADJ_WAY_CD = '0'
              THEN 'RF01'
              WHEN A.INT_RAT_ADJ_WAY_CD = '1'
              THEN 'RF02'
              ELSE '0'
              END AS RATE_TYP, --39  利率类型
         'TR99' AS PRC_BASE_TYP, --40  定价基准类型
         A.BASE_RAT AS BASE_RATE, --41  基准利率
         NVL(A.INT_RAT_ADJ_FREQ_CD,'99') AS RATE_FLT_FREQ, --42  利率浮动频率
         '07' AS INT_CALC_MODE, --43  计息方式 --07 利随本清 20220929 xuxiaobin ADD
         NULL AS CRDT_LMT_ID, --44  授信额度编号
         TO_CHAR(A.EXP_DT,'YYYYMMDD') AS ACT_END_DT, --45  实际终止日期
         NULL AS DEP_RSV_MODE, --46  缴存准备金方式
         '800919' AS DEPT_LINE, --47  部门条线
         /*UPPER(SUBSTR(A.JOB_CD,1,4))*/'外汇同业拆借' AS DATA_SRC, --48  数据来源
         NULL AS SUB_ACC_ID, --子账户编号
         NULL AS TIME_DWD_FLG,  --定活标志
         NULL AS FIN_INSTM_ID, --金融工具编号
         A.BUS_ID AS BUS_ID, --业务编号
         A.ASSET_THD_CLS_CD AS ASSET_THD_CLS_CD, --资产三分类代码
         A.STD_PROD_ID      AS STD_PROD_ID,       --标准产品编号
         A.SUBJ_ID          AS SUBJ_ID,          --科目编号
         A.TRAN_ID          AS TRAN_ID           --交易编号
         ,NULL               AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
    FROM O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表 A
/*    LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
      ON A.CNTPTY_ID = G.CUST_ID
     AND G.ETL_DT = A.ETL_DT*/
    /*LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO TI --同业客户特有信息
      ON G.CUST_ID = TI.PARTY_ID
     AND TI.FIN_INST_CATE_CD != '000000'
     AND TI.START_DT <= A.ETL_DT
     AND TI.END_DT > A.ETL_DT*/
   /* LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D -- 对公客户关联人信息表
         ON A.CUST_ID = D.CUST_ID
         AND A.ETL_DT = D.ETL_DT
         AND D.RELA_TYPE_CD = '30101'*/
    /*LEFT JOIN O_ICL_CMM_EXCH_RAT_INFO F        -- 汇率信息表
         ON A.CURR_CD = F.CURR_CD*/
    --WHERE TI.FIN_INST_CATE_CD IS NOT NULL
     WHERE --A.SUBJ_ID IS NOT NULL AND
      A.SUBJ_ID LIKE '1302%'  --拆放同业20221018 XUXIAOBIN MODIFY
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息-同业系统-同业借款、同业现金借贷质押式回购';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
       -- ,SPCL_PRO  --专项准备
       -- ,PARTI_PRO  --特种准备
      -- ,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG  --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,ASSET_TYPE_NAME  --资产类型名称（外管报表筛选）
        ,APV_ODD_NO       --审批单号（外管报表筛选） --ADD BY MW 20221014
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT    DISTINCT
             V_P_DATE AS DATA_DT, --1  数据日期
             A.LP_ID AS LGL_REP_ID, --2  法人编号
             A.BELONG_ORG_ID AS ORG_ID, --3  机构编号

             --A.CNTPTY_ID AS CUST_ID, --4  客户编号
             A.CNTPTY_CUST_ID,         --4  客户编号 暂行    \*20220527 XUCX*\

             COALESCE(A.ACCT_ID,A.FIN_INSTM_ID,A.BUS_ID) AS ACC_ID, --5  账户编号
             NULL AS ACC_TYP, --6  账户类型
             A.CURR_CD AS CUR, --7  币种
             '10202' AS BIZ_TYP, --8  业务类型  同业借款
             TO_CHAR(A.VALUE_DT,'YYYYMMDD') AS START_DT, --9  起始日期
             TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT, --10  到期日期
             --A.EXEC_INT_RAT AS ACT_RATE, --11  实际利率
             A.FAC_VAL_INT_RAT AS ACT_RATE, --11  实际利率    --MODIFY  CCH  20220908
             A.ACRU_INT AS INT, --12  利息
             NULL AS NEXT_INT_PAY_DT, --13  下一付息日
             NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
             A.TRAN_AMT AS BIZ_AMT, --15  recvbl_uncol_pric 业务发生金额
             A.CURRT_BAL AS BAL, --16  余额
             A.RECVBL_UNCOL_PRIC AS OVD_PRIN_AMT, --17  逾期本金金额
             A.RECVBL_UNCOL_INT  AS OVD_INT_AMT, --18  逾期利息金额
             CASE WHEN A.LEVEL5_CLS_CD = '10' THEN '01'  --正常
                  WHEN A.LEVEL5_CLS_CD = '00' THEN '01'  --正常
                  WHEN A.LEVEL5_CLS_CD = '20' THEN '02'  --关注
                  WHEN A.LEVEL5_CLS_CD = '30' THEN '03'  --次级
                  WHEN A.LEVEL5_CLS_CD = '40' THEN '04'  --可疑
                  WHEN A.LEVEL5_CLS_CD = '50' THEN '05'  --损失
                   END AS LVL5_CL, --19  五级分类    --20221019 modify lhh
             NULL AS MRGN, --20  保证金
             NULL AS MRGN_CUR, --21  保证金币种
             --NULL AS SPCL_PRO, --22  专项准备
             --NULL AS PARTI_PRO, --23  特种准备
             --NULL AS COM_PRO, --24  一般准备
             NULL AS PEERS_PAY_FLG, --25  同业代付标志
             NULL AS ACTP_BILL_NO, --26  承兑汇票票号
             NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
             NULL AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
             NULL AS BIZ_REL_FLG, --29  业务关系标志
             NULL AS COLL_RSK_CL, --30  担保品风险分类
             NULL AS COLL_MKT_VAL, --31  担保品市场价值
             NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
             NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
             NULL AS AGRT_OD_FLG, --34  协议透支标志
             NULL AS SPV_FLG, --35  特殊目的载体标志
             NULL AS GUA_FINC_FLG, --36  保本理财标志
             NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
             NULL AS OUTSRC_FLG, --38  委外标志
             CASE
             WHEN A.PROD_TYPE_CD = '0125' AND A.INT_RAT_ADJ_WAY_CD = '2' AND A.INT_RAT_ADJ_FREQ_CD = '0D' THEN 'RF01'
             ELSE  DECODE(A.INT_RAT_ADJ_WAY_CD,'1','RF01','2','RF02','RF01')
             END   AS RATE_TYP, --39  利率类型利率调整频率代码 利率调整方式代码
            CASE
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE '%SHIBOR%' THEN
          'TR01'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE '%LIBOR%' THEN
          'TR04'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE '%HIBOR%' THEN
          'TR05'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE '%EURIBOR%' THEN
          'TR06'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE 'LPR%' THEN
          'TR07'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE 'CHN%' THEN
          'TR08'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE 'DEPO_%' THEN
          'TR09'
         WHEN A.INT_RAT_ADJ_WAY_CD = '2' and C.BASE_RAT_ID LIKE 'LN_%' THEN
          'TR10'
         ELSE
          'TR99'
       END AS PRC_BASE_TYP, --40  定价基准类型
       A.BASE_RAT,           --41 基准利率
       NVL(TTA.TAR_VALUE_CODE,'99') AS RATE_FLT_FREQ, --42  利率浮动频率
             CASE WHEN A.PAY_INT_PED_CD = '0M' THEN '01'-- 0M 按月
               WHEN A.PAY_INT_PED_CD IN ('3M','1Q') THEN '02' --1Q 按季 3M 按3个月
               WHEN A.PAY_INT_PED_CD LIKE '%Y' THEN '03'-- 1Y 按年
               WHEN A.PAY_INT_PED_CD = '6M' THEN '06'-- 6M 按6个月
               --WHEN A.PAY_INT_PED_CD = 'irreg' THEN '04'
               ELSE '99' --其他 00 未知 0D 按日 1M 按周 4M 按4个月
               END AS INT_CALC_MODE, --43  计息方式
             NULL AS CRDT_LMT_ID, --44  授信额度编号
         --TO_CHAR(NVL(A.CASH_DT,A.EXP_DT),'YYYYMMDD') AS ACT_END_DT, --45  实际终止日期
         CASE WHEN A.PRIC_BAL+A.RECVBL_UNCOL_PRIC = 0 THEN V_P_DATE
         ELSE NULL END AS ACT_END_DT, --45  实际终止日期  --20230109 MODIFY  CCH 根据IMAS旧监管逻辑更改
             NULL AS DEP_RSV_MODE, --46  缴存准备金方式
             '800919' AS DEPT_LINE, --47  部门条线
          /*UPPER(SUBSTR(A.JOB_CD,1,4))*/ '同业现金借贷' AS DATA_SRC, --48  数据来源
          NULL AS SUB_ACC_ID, --子账户编号
          NULL AS TIME_DWD_FLG,  --定活标志
          NVL(A.FIN_INSTM_ID,'999') AS FIN_INSTM_ID, --金融工具编号
          A.BUS_ID AS BUS_ID, --业务编号
          A.asset_thd_cls_cd   AS ASSET_THD_CLS_CD, --资产三分类代码
          A.STD_PROD_ID        AS STD_PROD_ID,      --标准产品编号
          A.ASSET_TYPE_NAME  AS ASSET_TYPE_NAME,   --资产类型名称（外管报表筛选）
          A.APV_ODD_NO       AS APV_ODD_NO,        --审批单号（外管报表筛选） --ADD BY MW 20221014
          A.SUBJ_ID          AS SUBJ_ID,          --科目编号
          A.TRAN_SEQ_NUM     AS TRAN_ID           --交易编号
          ,NULL AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
       FROM O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷表 A
       LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C  --同业金融工具表
            ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
            AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
            AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
            AND A.ETL_DT = C.ETL_DT
      LEFT JOIN CODE_MAP TTA
           ON TTA.SRC_VALUE_CODE = A.PAY_INT_PED_CD
           AND TTA.SRC_CLASS_CODE = 'CD1623'
           AND TTA.TAR_CLASS_CODE = 'D0105'
           AND TTA.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TTB  --五级分类转码
           ON TTB.SRC_VALUE_CODE = A.LEVEL5_CLS_CD
           AND TTB.SRC_CLASS_CODE = 'CD1032'
           AND TTB.TAR_CLASS_CODE = 'D0005'
           AND TTB.MOD_FLG = 'MDM'
        /*LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D  -- 对公客户关联人信息
             ON A.CNTPTY_CUST_ID = D.CUST_ID
             AND D.RELA_TYPE_CD = '30101'*/--20220928 xuxiaobin 注释，此表目前无用
     /*   LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO C
             ON A.CNTPTY_CUST_ID = C.PARTY_ID  */
        WHERE

         A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.SUBJ_ID LIKE '130203%' ;-- 同业借出





  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
--20220928 xuxiaobin法透由表内借据出
 V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息--核心系统-法透当天透支当天还款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
       -- ,SPCL_PRO  --专项准备
        --,PARTI_PRO  --特种准备
        --,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG  --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT DISTINCT
             V_P_DATE  AS DATA_DT, --1  数据日期
             B.LP_ID AS LGL_REP_ID, --2  法人编号
             B.ACCT_INSTIT_ID AS ORG_ID, --3  机构编号
             B.CUST_ID AS CUST_ID, --4  客户编号
             B.DUBIL_NUM AS ACC_ID, --5  账户编号
             NULL AS ACC_TYP, --6  账户类型
             B.CURR_CD AS CUR, --7  币种

             '10204' AS BIZ_TYP, --8  业务类型  拆放同业--法透
             TO_CHAR(B.VALUE_DT,'YYYYMMDD') AS START_DT, --9  起始日期
             TO_CHAR(B.EXP_DT,'YYYYMMDD') AS EXP_DT, --10  到期日期
             B.EXEC_INT_RAT AS ACT_RATE, --11  实际利率
             B.CURRT_ACRU_INT AS INT, --12  利息
             NULL AS NEXT_INT_PAY_DT, --13  下一付息日
             NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
             B.DISTR_AMT AS BIZ_AMT, --15  业务发生金额
             B.CURRT_BAL AS BAL, --16  余额
             B.OVDUE_PRIC_BAL AS OVD_PRIN_AMT, --17  逾期本金金额
             B.OVDUE_INT_AMT AS OVD_INT_AMT, --18  逾期利息金额
             TTB.TAR_VALUE_CODE AS LVL5_CL, --19  五级分类
             NULL AS MRGN, --20  保证金
             NULL AS MRGN_CUR, --21  保证金币种
             --NULL AS SPCL_PRO, --22  专项准备
            -- NULL AS PARTI_PRO, --23  特种准备
            --NULL AS COM_PRO, --24  一般准备
             NULL AS PEERS_PAY_FLG, --25  同业代付标志
             NULL AS ACTP_BILL_NO, --26  承兑汇票票号
             NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
             NULL AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
             NULL AS BIZ_REL_FLG, --29  业务关系标志
             NULL AS COLL_RSK_CL, --30  担保品风险分类
             NULL AS COLL_MKT_VAL, --31  担保品市场价值
             NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
             NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
             NULL AS AGRT_OD_FLG, --34  协议透支标志
             NULL AS SPV_FLG, --35  特殊目的载体标志
             NULL AS GUA_FINC_FLG, --36  保本理财标志
             NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
             NULL AS OUTSRC_FLG, --38  委外标志
             CASE WHEN  B.INT_RAT_ADJ_WAY_CD = '0'
               THEN '1'   --固定利率
               ELSE '2'   --浮动利率
               END  AS RATE_TYP, --39  利率类型
             CASE WHEN B.INT_RAT_CURVE_TYPE_CD IN ('241','242') THEN 'TR07' ELSE 'TR10' END
              AS PRC_BASE_TYP, --40  定价基准类型
             /*CASE WHEN A.BASE_RAT_CD LIKE 'A%' THEN to_number(SUBSTR(A.BASE_RAT_CD,2,10))
                  ELSE TO_NUMBER(A.BASE_RAT_CD) --20220916 XUXIAOBIN 取值有问题
                   END*/
             B.BASE_RAT AS BASE_RATE, --41  基准利率
             '05' AS RATE_FLT_FREQ, --42  利率浮动频率
             '05' AS INT_CALC_MODE, --43  计息方式
             NULL AS CRDT_LMT_ID, --44  授信额度编号
             TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') AS ACT_END_DT, --45  实际终止日期
             NULL AS DEP_RSV_MODE, --46  缴存准备金方式
             '800919' AS DEPT_LINE, --47  部门条线
             /*UPPER(SUBSTR(A.JOB_CD,1,4))*/'法透' AS DATA_SRC, --48  数据来源
             D.OD_SUB_ACCT_ID AS SUB_ACC_ID, --子账户编号
             NULL AS TIME_DWD_FLG,  --定活标志
             NULL AS FIN_INSTM_ID, --金融工具编号
             B.DUBIL_NUM AS BUS_ID, --业务编号
             NULL AS ASSET_THD_CLS_CD, --资产三分类代码
             B.STD_PROD_ID  AS STD_PROD_ID, --标准产品编号
             B.SUBJ_ID AS SUBJ_ID,           --科目编号
             B.DISTR_FLOW_NUM             AS TRAN_ID  --交易编号
             ,D.OD_SUB_ACCT_ID AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
      LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
        ON B.CONT_ID = C.CONT_ID
       AND B.ETL_DT = C.ETL_DT
      LEFT JOIN O_ICL_CMM_LP_OD_SIGN_INFO D --法透签约信息表
        ON B.DUBIL_NUM = D.DUBIL_ID
       AND B.ETL_DT = D.ETL_DT
       LEFT JOIN CODE_MAP TTB  --五级分类转码
           ON TTB.SRC_VALUE_CODE = C.LOAN_LEVEL5_CLS_CD
           AND TTB.SRC_CLASS_CODE = 'CD1032'
           AND TTB.TAR_CLASS_CODE = 'D0005'
           AND TTB.MOD_FLG = 'MDM'
     WHERE D.LP_OD_TYPE_CD IN ('1', '2')--0 对公法透 1 同业日间法透 2 同业隔夜法透
       AND B.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
    ;
     V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息----同业系统-存放同业活期1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
        --,SPCL_PRO  --专项准备
       -- ,PARTI_PRO  --特种准备
       -- ,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT DISTINCT
             V_P_DATE AS DATA_DT, --1  数据日期
             A.LP_ID AS LGL_REP_ID, --2  法人编号
             A.OPEN_ACCT_ORG_ID AS ORG_ID, --3  机构编号
             A.CUST_ID AS CUST_ID, --4  客户编号
             A.CUST_ACCT_ID AS ACC_ID, --5  账户编号
             A.ACCT_CLS_CD AS ACC_TYP, --6  账户类型
             A.CURR_CD AS CUR, --7  币种
             '101' AS BIZ_TYP, --8  业务类型  存放同业
             TO_CHAR(A./*OPEN_DT*/INT_START_DT,'YYYYMMDD') AS START_DT, --9  起始日期
             TO_CHAR(A.EXP_DT/*CLOS_ACCT_DT*/,'YYYYMMDD') AS EXP_DT, --10  到期日期
             A.EXEC_INT_RAT AS ACT_RATE, --11  实际利率
             A.CURRT_ACRU_INT AS INT, --12  利息
             NULL AS NEXT_INT_PAY_DT, --13  下一付息日
             NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
             NULL AS BIZ_AMT, --15  业务发生金额
             /*A.CURRT_BAL*/A.OBANK_CURR_BAL AS BAL, --16  余额 --20220929 XUXIAOBIN MODIFY
             NULL AS OVD_PRIN_AMT, --17  逾期本金金额
             NULL AS OVD_INT_AMT, --18  逾期利息金额
             NULL AS LVL5_CL, --19  五级分类
             NULL AS MRGN, --20  保证金
             NULL AS MRGN_CUR, --21  保证金币种
            -- NULL AS SPCL_PRO, --22  专项准备
            -- NULL AS PARTI_PRO, --23  特种准备
            -- NULL AS COM_PRO, --24  一般准备
             NULL AS PEERS_PAY_FLG, --25  同业代付标志
             NULL AS ACTP_BILL_NO, --26  承兑汇票票号
             NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
             CASE WHEN A.ACCT_USAGE_CD = '6' THEN 'Y'
                  ELSE 'N'
             END  AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
             NULL AS BIZ_REL_FLG, --29  业务关系标志
             NULL AS COLL_RSK_CL, --30  担保品风险分类
             NULL AS COLL_MKT_VAL, --31  担保品市场价值
             NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
             NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
             NULL AS AGRT_OD_FLG, --34  协议透支标志
             NULL AS SPV_FLG, --35  特殊目的载体标志
             NULL AS GUA_FINC_FLG, --36  保本理财标志
             NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
             NULL AS OUTSRC_FLG, --38  委外标志
             CASE WHEN A.INT_RAT_FLO_VAL >0
                  THEN 'RF02'
                  ELSE 'RF01'
                  END   AS RATE_TYP, --39  利率类型
             NULL AS PRC_BASE_TYP, --40  定价基准类型
             A.BASE_RAT AS BASE_RATE, --41  基准利率
             NULL AS RATE_FLT_FREQ, --42  利率浮动频率
             CASE WHEN A.PAY_INT_FREQ = 'M3' THEN '02' --M3 3个月 按季
                  WHEN A.PAY_INT_FREQ LIKE '%Y%' THEN '03' --Y 按年
                  WHEN A.PAY_INT_FREQ = '0' THEN '07'
                  ELSE '99' END
              AS INT_CALC_MODE, --43  计息方式
             NULL AS CRDT_LMT_ID, --44  授信额度编号
             TO_CHAR(A.EXP_DT,'YYYYMMDD') AS ACT_END_DT, --45  实际终止日期
             'DR01'                         AS DEP_RSV_MODE, --46  缴存准备金方式
             NULL                         AS DEPT_LINE, --47  部门条线
             /*UPPER(SUBSTR(A.JOB_CD,1,4))*/'存放同业账户' AS DATA_SRC, --48  数据来源
             /*A.CUST_SUB_ACCT_ID*/NVL(B.OLD_SUB_ACCT_NUM,A.CUST_SUB_ACCT_ID) AS SUB_ACC_ID, --子账户编号
             CASE WHEN A.ACCT_CHAR_CD = '18' THEN '0' ELSE '1' END AS TIME_DWD_FLG, --定活标志
             NULL AS FIN_INSTM_ID, --金融工具编号
             NULL AS BUS_ID, --业务编号
             NULL AS ASSET_THD_CLS_CD, --资产三分类代码
             A.STD_PROD_ID             AS STD_PROD_ID, --标准产品编号
             A.SUBJ_ID                 AS SUBJ_ID, --科目编号
             A.OPEN_FLOW_NUM           AS TRAN_ID  --交易编号
             ,A.CUST_SUB_ACCT_ID AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        FROM O_ICL_CMM_NOSTRO_ACCT_INFO A --存放同业账户信息 A
/*        LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
          ON A.CUST_ID = G.CUST_ID
         AND G.ETL_DT = A.ETL_DT*/
         LEFT JOIN O_ICL_CMM_INTNAL_ACCT B
         ON A.CUST_ACCT_ID = B.MAIN_ACCT_ID
         AND A.CUST_SUB_ACCT_ID = B.SUB_ACCT_NUM
         AND B.ETL_DT = A.ETL_DT
    /*    LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO TI --同业客户特有信息
          ON G.CUST_ID = TI.PARTY_ID
         AND TI.FIN_INST_CATE_CD != '000000'
         AND TI.START_DT <= A.ETL_DT
         AND TI.END_DT > A.ETL_DT  */
        /*LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D -- 对公客户关联人信息表
             ON A.CUST_ID = D.CUST_ID
             AND D.RELA_TYPE_CD = '30101'*/
        /*LEFT JOIN O_ICL_CMM_EXCH_RAT_INFO F        -- 汇率信息表
             ON A.CURR_CD = F.CURR_CD*/
        WHERE
         --AND A.SUBJ_ID LIKE '1011%'
          A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息----同业代付';
  V_STARTTIME := SYSDATE;


  INSERT INTO RRP_MDL.M_CPTL_AST_INFO

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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
        --,SPCL_PRO  --专项准备
        -- ,PARTI_PRO  --特种准备
        -- ,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,STD_PROD_ID      --标准产品编号
        ,SUBJ_ID          --科目编号
        ,TRAN_ID          --交易编号
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
   )
   SELECT DISTINCT
         V_P_DATE AS DATA_DT  --数据日期
        ,A.LP_ID AS LGL_REP_ID  --法人编号
        ,A.OUT_ACCT_ORG_ID AS ORG_ID  --机构编号
        ,A.CUST_ID AS CUST_ID  --客户编号
        ,A.OUT_ACCT_FLOW_NUM AS ACC_ID  --账户编号  --出账流水号
        ,NULL AS ACC_TYP  --账户类型
        ,A.CURR_CD AS CUR  --币种
        ,'10203' AS BIZ_TYP  --业务类型 101存放同业  102拆放同业  103同业借款  10203同业代付 10501法透交易
        ,TO_CHAR(A.DISTR_DT, 'YYYYMMDD') AS START_DT  --起始日期
        ,TO_CHAR(A.EXP_DT, 'YYYYMMDD') AS EXP_DT  --到期日期
        ,A.EXEC_INT_RAT AS ACT_RATE  --实际利率
         --根据陆炜迪意见，同业代付利息=当期余额*计提利率/365*截止到节点的使用天数
        ,A.THS_TM_DISTR_AMT * B.IBANK_PAYFAN_PROVI_INT_RAT /100 /365 * (
               CASE WHEN A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_DATE(V_P_DATE,'YYYYMMDD')
               ELSE A.EXP_DT END
             - A.DISTR_DT)
         AS INT--利息
        --,A.THS_TM_DISTR_AMT * B.IBANK_PAYFAN_PROVI_INT_RAT * B.INT_ACCR_DAYS AS INT--利息
        ,NULL AS NEXT_INT_PAY_DT  --下一付息日
        ,NULL AS RATE_RE_PRC_DT  --利率重新定价日期
        ,CAST(0 AS NUMBER(30,2)) AS BIZ_AMT  --业务发生金额
        ,A.THS_TM_DISTR_AMT AS BAL  --余额
        ,0.00 AS OVD_PRIN_AMT  --逾期本金金额
        ,0.00 AS OVD_INT_AMT  --逾期利息金额
        ,'1' AS LVL5_CL  --五级分类
        ,A.MARGIN_AMT AS MRGN  --保证金
        ,A.MARGIN_CURR_CD AS MRGN_CUR  --保证金币种
        --,SPCL_PRO  --专项准备
        -- ,PARTI_PRO  --特种准备
        -- ,COM_PRO  --一般准备
        ,'1' AS PEERS_PAY_FLG  --同业代付标志
        ,NULL AS ACTP_BILL_NO  --承兑汇票票号
        ,'N' AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,'N' AS SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,NULL AS BIZ_REL_FLG  --业务关系标志
        ,NULL AS COLL_RSK_CL  --担保品风险分类
        ,NULL AS COLL_MKT_VAL  --担保品市场价值
        ,NULL AS INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,NULL AS STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,NULL AS AGRT_OD_FLG  --协议透支标志
        ,'N' AS SPV_FLG  --特殊目的载体标志
        ,'N' AS GUA_FINC_FLG  --保本理财标志
        ,NULL AS BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,NULL AS OUTSRC_FLG  --委外标志
        ,NULL AS RATE_TYP  --利率类型
        ,TB.TAR_VALUE_CODE AS PRC_BASE_TYP  --定价基准类型
        ,A.BASE_RAT AS BASE_RATE  --基准利率
        ,TA.TAR_VALUE_CODE AS RATE_FLT_FREQ  --利率浮动频率
        ,NULL AS INT_CALC_MODE  --计息方式
        ,A.DUBIL_ID AS CRDT_LMT_ID  --授信额度编号  --借据编号
        ,NULL AS ACT_END_DT  --实际终止日期
        ,NULL AS DEP_RSV_MODE  --缴存准备金方式
        ,'800975' AS DEPT_LINE  --部门条线 --信贷系统-委托同业代付 投行与金融机构部
        ,'同业代付' AS DATA_SRC  --数据来源
        ,NULL AS SUB_ACC_ID --子账户编号
        ,NULL AS TIME_DWD_FLG --定活标志
        ,NULL AS FIN_INSTM_ID --金融工具编号
        ,NULL AS BUS_ID --业务编号
        ,NULL AS ASSET_THD_CLS_CD --资产三分类代码
        ,A.PROD_ID                AS STD_PROD_ID     --标准产品编号
        ,A.SUBJ_ID AS SUBJ_ID          --科目编号
        ,A.OUT_ACCT_FLOW_NUM AS TRAN_ID              --交易编号
        ,NULL AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请 A
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H B --贷款出账对公贷款附属信息历史
    ON A.OUT_ACCT_FLOW_NUM = B.OUT_ACCT_FLOW_NUM
    AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
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
    WHERE --A.SUBJ_ID LIKE '130603%'
       A.PROD_ID IN ('203020700001','203020700002')
       AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.DISTR_DT <=  TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  --还未到期
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 --20220930 xuxiaobin此逻辑是否仍需要，旧监管剔除此逻辑
 /*V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资金业务（资产方）信息--资金系统-存放同业活期2';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_AST_INFO
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
        ,OVD_PRIN_AMT  --逾期本金金额
        ,OVD_INT_AMT  --逾期利息金额
        ,LVL5_CL  --五级分类
        ,MRGN  --保证金
        ,MRGN_CUR  --保证金币种
        --,SPCL_PRO  --专项准备
       -- ,PARTI_PRO  --特种准备
        --,COM_PRO  --一般准备
        ,PEERS_PAY_FLG  --同业代付标志
        ,ACTP_BILL_NO  --承兑汇票票号
        ,FOREX_RSV_ENTRS_LOAN_CPTL_FLG  --外汇储备委托贷款资金标志
        ,SETL_PEERS_DEP_FLG  --结算性同业存款标志
        ,BIZ_REL_FLG  --业务关系标志
        ,COLL_RSK_CL  --担保品风险分类
        ,COLL_MKT_VAL  --担保品市场价值
        ,INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
        ,STK_PLG_LOAN_FLG  --股票质押贷款标志
        ,AGRT_OD_FLG  --协议透支标志
        ,SPV_FLG  --特殊目的载体标志
        ,GUA_FINC_FLG  --保本理财标志
        ,BIZ_REL_DEP_AMT  --有业务关系存款金额
        ,OUTSRC_FLG  --委外标志
        ,RATE_TYP  --利率类型
        ,PRC_BASE_TYP  --定价基准类型
        ,BASE_RATE  --基准利率
        ,RATE_FLT_FREQ  --利率浮动频率
        ,INT_CALC_MODE  --计息方式
        ,CRDT_LMT_ID  --授信额度编号
        ,ACT_END_DT  --实际终止日期
        ,DEP_RSV_MODE  --缴存准备金方式
        ,DEPT_LINE  --部门条线
        ,DATA_SRC  --数据来源
        ,SUB_ACC_ID --子账户编号
        ,TIME_DWD_FLG --定活标志
        ,FIN_INSTM_ID --金融工具编号
        ,BUS_ID --业务编号
        ,ASSET_THD_CLS_CD --资产三分类代码
        ,CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        )
   SELECT DISTINCT
             V_P_DATE AS DATA_DT, --1  数据日期
             A.LP_ID AS LGL_REP_ID, --2  法人编号
             NVL(A.BELONG_ORG_ID,896) AS ORG_ID, --3  机构编号
             A.ISSUER_ID AS CUST_ID, --4  客户编号
             \*NVL(A.OBJ_ID,'999')*\A.BUS_ID||A.FIN_INSTM_ID AS ACC_ID, --5  账户编号
             NULL AS ACC_TYP, --6  账户类型
             A.CURR_CD AS CUR, --7  币种
             '101' AS BIZ_TYP, --8  业务类型  存放同业
             TO_CHAR(A.OPEN_DT,'YYYYMMDD') AS START_DT, --9  起始日期
             TO_CHAR(A.EXP_DT,'YYYYMMDD') AS EXP_DT, --10  到期日期
             A.ACTL_INT_RAT AS ACT_RATE, --11  实际利率
             A.CURRT_ACRU_INT AS INT, --12  利息
             NULL AS NEXT_INT_PAY_DT, --13  下一付息日
             NULL AS RATE_RE_PRC_DT, --14  利率重新定价日期
             A.TRAN_AMT AS BIZ_AMT, --15  业务发生金额
             A.CURRT_BAL AS BAL, --16  余额
             NULL AS OVD_PRIN_AMT, --17  逾期本金金额
             NULL AS OVD_INT_AMT, --18  逾期利息金额
             NULL AS LVL5_CL, --19  五级分类
             NULL AS MRGN, --20  保证金
             NULL AS MRGN_CUR, --21  保证金币种
            -- NULL AS SPCL_PRO, --22  专项准备
             --NULL AS PARTI_PRO, --23  特种准备
            -- NULL AS COM_PRO, --24  一般准备
             NULL AS PEERS_PAY_FLG, --25  同业代付标志
             NULL AS ACTP_BILL_NO, --26  承兑汇票票号
             NULL AS FOREX_RSV_ENTRS_LOAN_CPTL_FLG, --27  外汇储备委托贷款资金标志
             NULL AS SETL_PEERS_DEP_FLG, --28  结算性同业存款标志
             NULL AS BIZ_REL_FLG, --29  业务关系标志
             NULL AS COLL_RSK_CL, --30  担保品风险分类
             NULL AS COLL_MKT_VAL, --31  担保品市场价值
             NULL AS INNR_ADV_EXP_OPTION_FLG, --32  内嵌提前到期期权标志
             NULL AS STK_PLG_LOAN_FLG, --33  股票质押贷款标志
             NULL AS AGRT_OD_FLG, --34  协议透支标志
             NULL AS SPV_FLG, --35  特殊目的载体标志
             NULL AS GUA_FINC_FLG, --36  保本理财标志
             NULL AS BIZ_REL_DEP_AMT, --37  有业务关系存款金额
             NULL AS OUTSRC_FLG, --38  委外标志
             NULL AS RATE_TYP, --39  利率类型
             NULL AS PRC_BASE_TYP, --40  定价基准类型
             NULL AS BASE_RATE, --41  基准利率
             NULL AS RATE_FLT_FREQ, --42  利率浮动频率
             NULL AS INT_CALC_MODE, --43  计息方式
             NULL AS CRDT_LMT_ID, --44  授信额度编号
             NULL AS ACT_END_DT, --45  实际终止日期
             NULL AS DEP_RSV_MODE, --46  缴存准备金方式
             '900919' AS DEPT_LINE, --47  部门条线
             \*UPPER(SUBSTR(A.JOB_CD,1,4))*\'同业证券持仓' AS DATA_SRC ,--48  数据来源
             NULL AS SUB_ACC_ID, --子账户编号
             '0' AS TIME_DWD_FLG, --定活标志
             A.FIN_INSTM_ID AS FIN_INSTM_ID,--金融工具编号
             A.BUS_ID AS BUS_ID, --业务编号
             A.ASSET_THD_CLS_CD AS ASSET_THD_CLS_CD --资产三分类代码
             ,NULL CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
        FROM O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表 A
        LEFT JOIN O_ICL_CMM_IBANK_FIN_INSTM C1 --同业金融工具表
          ON A.FIN_INSTM_ID = C1.FIN_INSTM_ID
         AND C1.ETL_DT = A.ETL_DT
      LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息表
          ON A.ISSUER_ID = G.CUST_ID
         AND G.ETL_DT = A.ETL_DT
        \*LEFT JOIN O_ICL_CMM_CORP_CUST_RELA_PS_INFO D -- 对公客户关联人信息表
             ON A.ISSUER_ID = D.CUST_ID
             AND D.RELA_TYPE_CD = '30101'*\
        \*LEFT JOIN O_ICL_CMM_EXCH_RAT_INFO F        -- 汇率信息表
             ON A.CURR_CD = F.CURR_CD*\
         \*LEFT JOIN O_IML_PTY_IBANK_CUST_CHAT_INFO TI --同业客户特有信息
          ON G.CUST_ID = TI.PARTY_ID
         AND TI.FIN_INST_CATE_CD != '000000'
         AND TI.START_DT <= A.ETL_DT
         AND TI.END_DT > A.ETL_DT*\
        WHERE
         --AND A.SUBJ_ID LIKE '1011%'
          A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      ;*/

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

  END ETL_INIT_M_CPTL_AST_INFO;
/

