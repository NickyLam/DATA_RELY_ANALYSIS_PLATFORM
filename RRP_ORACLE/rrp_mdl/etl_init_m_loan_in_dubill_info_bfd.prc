CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_IN_DUBILL_INFO_BFD(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_IN_DUBILL_INFO_BFD
  *  功能描述：表内借据信息-所有以个人客户和机构名义开展信贷业务时所签订的信贷业务借据信息（仅表内部分+委托贷款），不含信用卡业务。
  *  核销、转让如果余额不为0，接数时，处理为0
  *  创建日期：20221214
  *  开发人员：
  *  来源表：
  *  目标表：  M_LOAN_IN_DUBILL_INFO_BFD
  *  配置表：  CODE_MAP

  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER := 0;                                    -- 处理步骤
  V_PROC_NAME   VARCHAR2(60) := 'ETL_INIT_M_LOAN_IN_DUBILL_INFO_BFD';     -- 程序名称
  V_P_DATE      VARCHAR2(8);                                     -- 跑批数据日期
  V_STARTTIME   DATE;                                            -- 处理开始时间
  V_ENDTIME     DATE;                                            -- 处理结束时间
  V_SQLCOUNT    INTEGER := 0;                                    -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                   -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(100);                                    -- 来源系统
  V_MONTH_START_DATE DATE;                                       --系统时间对应月初日期
  V_STEP_DESC   VARCHAR2(200);                                   --任务名称
  V_TAB_NAME VARCHAR2(100) ;                                     --表名
  V_PART_NAME VARCHAR2(100);                                     --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE);                               -- 获取跑批日期
  V_SYSTEM :='监管报送';                                          -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'M_LOAN_IN_DUBILL_INFO_BFD'; --表名
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

  V_STEP := 2;
  V_STEP_DESC := '-- 处理首贷日标志 --';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD';

   --加工客户的首笔借据及首次放款日期
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD
    (CUST_ID, RCPT_ID, LOAN_ACT_DSTR_DT)
  WITH TMP1 AS (
    SELECT /*+PARALLEL*/ CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT /*+PARALLEL*/ CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      UNION ALL
    SELECT /*+PARALLEL*/ CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END  AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO_CLEAR WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      UNION ALL
     SELECT /*+PARALLEL*/ CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
       FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    TMP2 AS
     (SELECT T.CUST_ID,T.RCPT_ID,TO_CHAR(T.LOAN_ACT_DSTR_DT, 'YYYYMMDD') LOAN_ACT_DSTR_DT,
             ROW_NUMBER() OVER(PARTITION BY T.CUST_ID ORDER BY T.LOAN_ACT_DSTR_DT,T.RCPT_ID NULLS LAST
             ) RN--20230130 XUXIAOBIN MODIFY
        FROM TMP1 T)
    SELECT T.CUST_ID, T.RCPT_ID, T.LOAN_ACT_DSTR_DT
      FROM TMP2 T
     WHERE RN = 1;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_IN_DUBILL_INFO_TEMP00_BFD', '', O_ERRCODE);

  V_STEP := 3;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总1 --';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD';
  COMMIT;

  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD
    (CUST_ACCT_ID,             --账户编号
     CUST_ACCT_NAME ,          --账户户名
     ACCT_BELONG_ORG_ID,       --账户所属机构
     ORG_ID1,                  --账户所属机构映射报送机构
     FIN_INST_CODE,            --银行机构代码
     FIN_LICS_NUM,             --金融许可证号
     ORG_NAME,                 --银行机构名称
     COUNTY_CD                 --机构地区
     )
   SELECT A.CUST_ACCT_ID,             --账户编号
          A.CUST_ACCT_NAME ,          --账户户名
          NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) ACCT_BELONG_ORG_ID,       --账户所属机构
          B.ORG_ID1,                  --账户所属机构映射报送机构
          B.FIN_INST_CODE,            --银行机构代码
          B.FIN_LICS_NUM,             --金融许可证号
          B.ORG_NAME,                 --银行机构名称
          COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
     FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
     LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
       ON B.ORG_ID = NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
     LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
       ON C.ORG_ID = B.ORG_ID1
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := 4;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总2 --';

  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD
    (CUST_ACCT_ID,             --账户编号
     CUST_ACCT_NAME ,          --账户户名
     ACCT_BELONG_ORG_ID,       --账户所属机构
     ORG_ID1,                  --账户所属机构映射报送机构
     FIN_INST_CODE,            --银行机构代码
     FIN_LICS_NUM,             --金融许可证号
     ORG_NAME,                 --银行机构名称
     COUNTY_CD                 --机构地区
     )
   SELECT A.MAIN_ACCT_ID AS CUST_ACCT_ID,            --账户编号
          A.ACCT_NAME  AS CUST_ACCT_NAME,            --账户户名
          TRIM(A.BELONG_ORG_ID) ACCT_BELONG_ORG_ID,  --账户所属机构
          B.ORG_ID1,                                 --账户所属机构映射报送机构
          B.FIN_INST_CODE,                           --银行机构代码
          B.FIN_LICS_NUM,                            --金融许可证号
          B.ORG_NAME,                 --银行机构名称
          COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
     FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
     LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
       ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
     LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
       ON C.ORG_ID = B.ORG_ID1
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_IN_DUBILL_INFO_TEMP02_BFD', '', O_ERRCODE);


  V_STEP := 5; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '清空临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TMP_BFD');
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   V_STEP   := 6;
    V_STEP_DESC := '精准扶贫临时表数据处理-1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP03_BFD');
  INSERT INTO M_LOAN_IN_DUBILL_INFO_TEMP03_BFD  --表内借据信息--精准扶贫按证件
    (
       CERT_NO      -- 01 证件号
      ,TPZT        -- 02 脱贫状态
      ,ACCT_DURAN  -- 03 扶贫名录期间
      ,QG_FLAG     -- 04 全国标志
    )
    SELECT
       CERT_NO      -- 01 证件号
      ,TPZT        -- 02 脱贫状态
      ,ACCT_DURAN  -- 03 扶贫名录期间
      ,QG_FLAG     -- 04 全国标志
    FROM (SELECT
                P1.PKHSFZH         AS CERT_NO     -- 01 证件号
               ,'已脱贫'           AS TPZT        -- 02 脱贫状态
               ,'2021-04'          AS ACCT_DURAN  -- 03扶贫名录期间
               ,'1'                AS QG_FLAG     -- 04 全国标志
           FROM ADD_JZFP_LIST_CN_202104 P1  -- 精准扶贫全国名录  --MODIFY BY LIUYU 20211210 发放日为20210401 之后按此名录为准
          WHERE P1.TPZT = '脱贫'
          GROUP BY P1.PKHSFZH   -- add by liuyu 20220110 202104名单全部是脱贫，默认已脱贫
         );

    V_SQLCOUNT := SQL%ROWCOUNT;
    COMMIT;
   ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_IN_DUBILL_INFO_TEMP03_BFD', '', O_ERRCODE);


    EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP04');
     INSERT INTO M_LOAN_IN_DUBILL_INFO_TEMP04_BFD --表内借据信息--精准扶贫按客户
    (
       CUST_ID      -- 01 客户号
      ,CERT_NO     -- 02 证件号
      ,TPZT        -- 03 脱贫状态
      ,ACCT_DURAN  -- 04 扶贫名录期间
    )
    SELECT
       P1.CUST_ID      -- 01 客户号
      ,P1.CERT_NO     -- 02 证件号
      ,P2.TPZT        -- 03 脱贫状态
      ,P2.ACCT_DURAN  -- 04 扶贫名录期间
    FROM O_ICL_CMM_INDV_CUST_BASIC_INFO P1   -- 个人客户基本信息表
    INNER JOIN M_LOAN_IN_DUBILL_INFO_TEMP03 P2
       ON P1.CERT_NO = P2.CERT_NO
    WHERE P1.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    COMMIT;
   ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_IN_DUBILL_INFO_TEMP04', '', O_ERRCODE);



   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '表内借据信息--零售贷款部分';
   V_STARTTIME := SYSDATE;
   INSERT INTO M_LOAN_IN_DUBILL_INFO_TMP_BFD
  (
    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                            --借据编号
    ,CONT_ID                            --合同编号
    ,BILL_NO                            --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                            --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                            --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                    --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                      --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                        --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                            --逾期类型
    ,LOAN_USEAGE                        --贷款用途
    ,LVL5_CL                            --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                      --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                  --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                    --房地产贷款标志
    ,IALL_LOAN_FLG                      --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频度
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,OVD_INT_BAL                         --逾期利息金额
    ,LOAN_CRDT_LMT_TOT                   --单户授信总额度
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 MOD BY HULJ 20221122
    ,OPER_TELLER_ID                      --经办柜员编号 MOD BY HULJ 20221122
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 MOD BY HULJ 20221122
    ,RENEW_EXP_DAY                       --展期到期日期 MOD BY HULJ 20221122
    ,CNCL_DT                             --核销日期   ADD BY MW 20221123
    ,FIXED_INT_MARK                      --利率是否固定
    )
     WITH RETL_LOAN_REPAY_PLAN AS (SELECT D.DUBIL_ID,
                 MAX(TOT_PERDS) TOT_PERDS,
                 MAX(REPAY_PERDS) REPAY_PERDS,
                 MAX(CASE WHEN D.VALUE_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE REPAY_PERDS END) CURR_PERDS,
                 SUM(CASE WHEN (D.OVDUE_FLG = '1' --逾期标志为是
                               AND D.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                               AND D.REPAY_FLG = '0') --未偿还
                               THEN 1 ELSE 0 END) LXQKQS, --连续欠款期数
                                 SUM(CASE WHEN (D.OVDUE_FLG = '1' --逾期标志为是
                                 AND D.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                                AND D.REPAY_FLG = '0') --未偿还
                                THEN 1 ELSE 0 END) LJQKQS --累计欠款期数
                 FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN D --零售贷款还款计划
                WHERE D.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY D.DUBIL_ID)
    SELECT
         TO_CHAR(A.ETL_DT,'YYYYMMDD')                    DATA_DT                    --数据日期
        ,A.LP_ID                    LGL_REP_ID                --法人编号
        ,A.ACCT_ID                  ACC_ID                    --账户编号
        ,A.DUBIL_NUM                RCPT_ID                    --借据编号
        ,A.CONT_ID                  CONT_ID                    --合同编号
        ,NULL                        BILL_NO                    --票据号码
        ,CASE WHEN B.STD_PROD_ID IN ('202020200005','202020200006') THEN '华兴深分后海合字第20191007001号' --网商小贷
              WHEN B.STD_PROD_ID IN ('202010200003') THEN '业务合作协议20181206号'  --玖富万卡
              WHEN B.STD_PROD_ID IN ('202010200004','202020200003') THEN '华兴微贷合作字第201904001号华兴普惠20191216001'  --人保助贷（经营/消费）
              WHEN B.STD_PROD_ID IN ('202010200005','202020200002')
                    AND A.DISTR_DT >= TO_DATE('20181130','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20210103','YYYYMMDD')
                    AND LENGTHB(REGEXP_REPLACE(TA.INCRE_CRDT_MODE_CD,'[^_]','')) = 1  --三方 --modify by hulj 增加增信模式
              THEN '华兴R20181130-01'  --平安普惠（经营/消费）+三方+2018年11月30日至2021年1月3日
               WHEN B.STD_PROD_ID IN ('202010200005','202020200002')
                    AND A.DISTR_DT >= TO_DATE('20210104','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20210118','YYYYMMDD')
                    AND LENGTHB(REGEXP_REPLACE(TA.INCRE_CRDT_MODE_CD,'[^_]','')) = 1  --三方 --modify by hulj 增加增信模式
              THEN '华兴R20210104-01'  --平安普惠（经营/消费）+三方+2021年1月4日至2021年1月18日
              WHEN B.STD_PROD_ID IN ('202010200005','202020200002')
                    AND A.DISTR_DT >= TO_DATE('20210119','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20221201','YYYYMMDD')
                    AND LENGTHB(REGEXP_REPLACE(TA.INCRE_CRDT_MODE_CD,'[^_]','')) = 1  --三方 --modify by hulj 增加增信模式
              THEN '华兴R20210119-02'  --平安普惠（经营/消费）+三方+2021年1月19日至2022年12月1日
               WHEN B.STD_PROD_ID IN ('202010200005','202020200002')
                    AND A.DISTR_DT >= TO_DATE('20201010','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20210118','YYYYMMDD')
                    AND LENGTHB(REGEXP_REPLACE(TA.INCRE_CRDT_MODE_CD,'[^_]','')) = 2  --四方 --modify by hulj 增加增信模式
              THEN '华兴R20201010-01'  --平安普惠（经营/消费）+四方+2020年10月10日至2022年10月9日
               WHEN B.STD_PROD_ID IN ('202010200005','202020200002')
                    AND A.DISTR_DT >= TO_DATE('20210119','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20221201','YYYYMMDD')
                    AND LENGTHB(REGEXP_REPLACE(TA.INCRE_CRDT_MODE_CD,'[^_]','')) = 2  --四方 --modify by hulj 增加增信模式
               THEN '华兴R20210119-01'  --平安普惠（经营/消费）+四方+2021年1月19日至2022年12月1日
         END                        COOP_AGRT_ID              --合作协议编号
        ,A.CUST_ID                  CUST_ID                    --客户编号
        ,A.ACCT_INSTIT_ID            ORG_ID                    --机构编号
        ,A.SUBJ_ID                  SUBJ_ID                    --科目编号
        ,A.STD_PROD_ID              LOAN_STD_PROD_ID          --贷款标准产品编号
        ,C.PROD_NAME                LOAN_STD_PROD_NM          --贷款标准产品名称
        ,A.STD_PROD_ID               LOAN_PROD_ID              --贷款产品编号
        ,C.PROD_NAME            LOAN_PROD_NM              --贷款产品名称
        ,/*CASE WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100101'
              THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100102'
              THEN '010302' --房屋装修贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD IN ( '100109')
              THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0102%' AND TA.BORW_USAGE_TYPE_CD IN ( '100201')
              THEN '010202' --商用车贷款
              WHEN A.STD_PROD_ID IN ('201030200001','201030200002','201030200003')
              THEN '010101' --个人住房按揭商业贷款
              WHEN  A.STD_PROD_ID IN ('201030200001','201030200002')
                AND TA.BORW_USAGE_TYPE_CD <> '100301'
              THEN '010101'              --个人中长期住房贷款(个人住房按揭商业贷款)
              WHEN  A.STD_PROD_ID IN ('201030100001','201030100002')
                AND TA.BORW_USAGE_TYPE_CD = '100301'
              THEN '010201'              --个人中长期住房贷款(商业用房贷款)
              ELSE NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)
         END */ NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)                      LOAN_BIZ_TYP              --贷款业务类型
        ,A.CURR_CD                  CUR                      --币种
        ,A.DUBIL_AMT                LOAN_AMT                  --借款金额
        ,CASE WHEN A.WRT_OFF_FLG ='1' THEN 0
              ELSE A.CURRT_BAL
         END                                   LOAN_BAL                  --贷款余额
        ,0                                    INT_ADJ                  --利息调整
        ,0                                    FAIR_VAL_CHG              --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1'
              THEN 0
              ELSE NVL(A.OVDUE_PRIC_BAL, 0)
         END                                       OVD_PRIN_BAL              --逾期本金余额
        ,A.IN_BS_INT                               IN_INT_OVD_BAL            --表内欠息余额
        ,A.OFF_BS_INT                              OUT_INT_OVD_BAL          --表外欠息余额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')            LOAN_ACT_DSTR_DT          --贷款实际发放日期
        ,TO_CHAR(B.DUBIL_EXP_DT,'YYYYMMDD')        LOAN_ORIG_EXP_DT          --贷款原始到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              LOAN_ACT_EXP_DT          --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
                    AND D.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
               WHEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101')
                    AND A.ASSET_TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')  THEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') --资产转让日期
               WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
               ELSE '99991231'
           END                                     ACT_END_DT                --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')       LAST_REPY_DT              --上次还款日期
        ,NULL                                      LAST_REPY_AMT            --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')            VAL_DT                    --起息日期
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')        OPEN_ACC_DT              --开户日期
        , CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
         END                                     CNL_ACC_DT                --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
         END                                      PRIN_OVD_DT              --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0 THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
         END                                      INT_OVD_DT                --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)            OVD_DAYS                  --逾期天数
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS > 0
              THEN '03'  --03：本金利息逾期
              WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS = 0
              THEN '01'  --01：本金逾期
              WHEN B.PRIC_OVDUE_DAYS = 0 AND B.INT_OVDUE_DAYS > 0
              THEN '02'  --02：利息逾期
              ELSE NULL   END                                    OVD_TYP                  --逾期类型
        ,CASE WHEN TTB.TAR_VALUE_CODE IS NOT NULL THEN TTB.TAR_VALUE_CODE
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100000') THEN '个人贷款用途'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100100') THEN '个人消费类贷款用途'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100101') THEN '购个人用车'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100102') THEN '装修'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100103') THEN '婚庆'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100104') THEN '留学'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100105') THEN '进修'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100106') THEN '旅游'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100107') THEN '高尔夫会籍'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100108') THEN '整形美容'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100109') THEN '购车+车牌'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100110') THEN '购车牌'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100111') THEN '购车位'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100112') THEN '购买电子产品'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100113') THEN '子女教育'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100114') THEN '房产税费'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100115') THEN '支付个人租房费用'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100116') THEN '医疗支出'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100117') THEN '绿色消费'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100199') THEN '其他个人消费'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100200') THEN '个人经营类贷款用途'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100201') THEN '购商用车'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100202') THEN '支付租赁经营费用'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100203') THEN '绿色经营'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100299') THEN '其他个人经营'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100300') THEN '个人按揭类贷款用途'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100301') THEN '购买商用房'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('100302') THEN '购买住房'
               WHEN TA.BORW_USAGE_TYPE_CD IN ('000000') THEN '未知'
               ELSE TA.BORW_USAGE_TYPE_CD
           END                          LOAN_USEAGE              --贷款用途
                                        --20220906 MW  修改码值映射关系
        ,TTC.TAR_VALUE_CODE              LVL5_CL                  --五级分类
        ,TTM.TAR_VALUE_CODE                  GUA_MODE                  --担保方式
        , CASE WHEN F.CERT_TYPE_CD = '1010' THEN
               CASE WHEN SUBSTR(SUBSTR(F.CERT_NO,1,6),-4)='0000' THEN SUBSTR(F.CERT_NO,1,2)||'0101'
                    WHEN SUBSTR(SUBSTR(F.CERT_NO,1,6),-2)='00' AND
                             SUBSTR(F.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                    THEN SUBSTR(F.CERT_NO,1,4) || '01'
                    ELSE SUBSTR(F.CERT_NO,1,6)
               END
         END                                LOAN_DIR_RGN              --贷款投向地区
        ,CASE WHEN B.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(B.DIR_INDUS_CD,'Z')
              END                     LOAN_DIR_IDY              --贷款投向行业
        ,NULL                                SYN_LOAN_FLG              --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('203010200001','203010200003','203010200004','203010200005','203010200006')--('1050010', '1030010', '1030020','1050020')
         THEN 'Y'
         ELSE 'N'
         END                                  PROJ_LOAN_FLG          --项目贷款标志
        ,NULL                                IDY_STRU_ADJ_TYP        --产业结构调整类型
        ,NULL                                IDY_TRNST_UPG_FLG       --工业转型升级标志
        ,NULL                                STRTG_EMER_IDY_TYP      --战略新兴产业类型
        ,CASE WHEN A.STD_PROD_ID IN ('201020100003','201020100012')  ---201020100003税兴贷、201020100012税兴贷（网贷）
         OR TA.COPRATOR_ID IN ('2290000001')  --深圳微众税银信息服务有限公司
         THEN 'Y'
         ELSE 'N'
          END                                      BANK_TAX_COOP_LOAN_FLG --银税合作贷款标志
        ,CASE WHEN (F.FARM_FLG = '1') THEN 'Y'
              ELSE 'N'
         END                                AGR_REL_LOAN_FLG          --涉农贷款标志
        ,CASE WHEN A.STD_PROD_ID IN( '201030100001' ,'201030100002','201030200001','201030200002')
              THEN 'Y'
              ELSE 'N'    END                RL_EST_LOAN_FLG          --房地产贷款标志
        ,NULL                                IALL_LOAN_FLG            --投贷联动贷款标志
        ,NULL                                OV_SEA_MRG_LOAN_FLG      --境外并购贷款标志
        ,NULL                                GRN_LOAN_USEAGE_CL       --绿色贷款用途分类
        ,NULL                                ENT_GUA_LOAN_TYP         --创业担保贷款类型
        ,NULL                                CAMPUS_CNSMP_LOAN_FLG    --校园消费贷款标志
        ,NULL                                LCL_GOVFINPLTF_LOAN_FLG  --地方政府融资平台贷款标志
        ,NULL                                LAND_THIRDPARTY_LOAN_TYP --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                FARMER_THIRDPARTY_LOAN_TY--将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                POV_ALLE_REC_FLG         --未脱贫建档立卡户贷款标志
        ,NVL(TJ.TAR_VALUE_CODE,M.CHN_ID)     LOAN_HDL_CHAN            --贷款办理渠道
        ,/*'N'*//*CASE WHEN B.BUS_BREED_ID IN ('02001004165073','02001006155012','02001004160029','02001010A9999',
                                       '02001006305010','02001006310010','02001004220010','02001006160045')
              THEN 'Y' ELSE 'N'
         END    */
         CASE WHEN B.STD_PROD_ID IN ('202010200005','202020200002','202010200008','202010200003',
           '202020200006','202020200005','202010200004','202020200003')
              THEN 'Y'
              ELSE 'N'
              END                            NET_LOAN_FLG              --互联网贷款标志
         ,'0'                                NET_LOAN_PROD_TYP         --网贷产品类别
        ,NULL                                CR_CRD_BIZ_OD_TYP        --类信用卡业务透支类型
        ,TTE.TAR_VALUE_CODE                  REPY_MODE                --还款方式
        /*,CASE WHEN A.RENEW_FLG = 1
              THEN '05' --展期
              ELSE TTF.TAR_VALUE_CODE
              END                            LOAN_FRM                  --贷款形式*/
        ,'01'                                LOAN_FRM                  --贷款形式   --20221121  参考east5.0口径修改 LHQ
        ,CASE WHEN TA.LOAN_HAPP_TYPE_CD IN ('0201' --展期
                                     ,'0204' --债务重组
                                     ,'0202') --借新还旧
         THEN 'Y'
         ELSE 'N'
         END                                  RCMM_LOAN_FLG            --重组贷款标识
        ,NULL                                ADJ_BAD_FLG              --下调为不良标志
        ,NULL                                ALDY_RCMM_FLG            --曾重组标志
        ,NULL                                CTON_PRD_LOAN_FLG        --缩期贷款标志
        ,NULL                                CASH_TRF_FLG              --现转标志
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')                                FST_LOAN_FLG                --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')                                FIRST_LOAN_FLG              --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                PBOC_GRN_LOAN_FLG        --PBOC绿色贷款标志
        ,'N'                                CBRC_GRN_LOAN_FLG        --CBRC绿色贷款标志
        ,NULL                                CNSMP_SCN_LOAN_FLG        --消费场景贷款标志
        ,NULL                                LOAN_FINC_SPT_MODE        --贷款财政扶持方式
        ,CASE WHEN ((AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫')
                   OR (A.DISTR_DT > DATE'2021-12-31' AND AC.CUST_ID IS NOT NULL))
              THEN 'Y'
              ELSE 'N'
              END                                         ACURT_POV_ALLE_LOAN_FLG  --精准扶贫贷款标志
        ,CASE WHEN A.NEXT_INT_RAT_ADJ_DT = DATE'0001-01-01' THEN NULL
        ELSE TO_CHAR(A.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD') END AS  RATE_RE_PRC_DT     --利率重新定价日期 20221109 XUXIAOBIN MODIFY
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1D' THEN '01'---按日
         WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN('7D','1W') THEN '02'--按周
          WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1M' THEN '03'---按月
          WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='3M' THEN '04'--按季
          WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='6M' THEN '05'--按半年
          WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='12M' THEN '06'--按年
          ELSE '99'
          END AS                                 RATE_FLT_FREQ            --利率浮动频率
        ,TTK.TAR_VALUE_CODE                                RATE_TYP                  --利率类型
        ,NULL                                AST_SCRTZ_PROD_ID        --资产证券化产品编号
        ,A.EXEC_INT_RAT                      EXEC_RATE                --执行利率
        ,A.BASE_RAT                          BASE_RATE                --基准利率
        ,NULL                                CNTR_GUA_LOAN_FLG        --反担保贷款标志
        ,B.INT_RAT_FLO_VAL                   RATE_FLT_VAL              --利率浮动值
        ,CASE WHEN A.BASE_RAT_ID IN ('2231','2232') THEN 'TR07'  --MODIFY  CCH  20221025  根据新监管码值，2231、2232对应报表的LPR
        ELSE TI.TAR_VALUE_CODE
         END
                                     PRC_BASE_TYP              --定价基准类型
        ,CASE WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS --因贷款产品跑批问题，部分借据的还款计划被清掉了
               THEN A.CURR_ISSUE_PERDS
               ELSE A.TOT_PERDS
         END                                TOT_PRD_NUM              --总期数
        ,A.CURR_ISSUE_PERDS                 CURR_PRD                  --当前期数
        ,NVL(DD.LJQKQS,0)                   CUM_DEBT_PRD_NUM          --累计欠款期数
        ,NVL(DD.LXQKQS,0)                   CNU_DEBT_PRD_NUM          --连续欠款期数
        ,A.RENEW_CNT                        EXTN_CNT                  --展期次数
        ,NVL(TTG.TAR_VALUE_CODE,'01')        DSBR_MODE                --放款方式
        ,TTH.TAR_VALUE_CODE                  INT_CALC_MODE            --计息方式
        ,NULL                                MRGN_PCT                  --保证金比例
        ,NULL                                MRGN_CUR                  --保证金币种
        ,NULL                                MRGN                      --保证金
        ,NULL                                MRGN_ACC                  --保证金账号
        ,B.CUST_MGR_ID                      LOAN_OFR_NO              --信贷员工号
        ,A.CURRT_ACRU_INT                    ACCRD_INT                --应计利息
        ,AA.N_ECL_BEFORE                       PRO_IMPT               --减值准备
        ,NULL                                COM_PRO                  --一般准备
        ,NULL                                SPCL_PRO                  --专项准备
        ,NULL                                ESP_PRO                  --特别准备
        ,NULL                                SPCL_LOAN_FLG            --专项贷款标志
        ,NULL                                ORIG_RCPT_NO              --原借据号
        ,NULL                                FND_PCT                  --出资比例
        ,A.LOAN_DISTR_ACCT_NUM              ETR_ACC                  --入账账号
       /* ,B.ENTER_ACCT_NAME                  ETR_ACC_NM                --入账账号户名
        ,B.ENTER_ACCT_NAME                  LOAN_ETR_ACC_OPEN_BANK_NM--贷款入账账号开户行名称*/
        ,E.CUST_ACCT_NAME                   ETR_ACC_NM                --入账账号户名
        ,E.ORG_NAME                         LOAN_ETR_ACC_OPEN_BANK_NM--贷款入账账号开户行名称
        ,A.LOAN_REPAY_NUM                    REPY_ACC                  --还款账号
        ,K.ORG_NAME                               LOAN_REPY_ACC_OPEN_BANK_N--贷款还款账号开户行名称
        ,CASE WHEN A.ASSET_TRAN_STATUS_CD = '121' THEN 'C0202'
             ELSE TTI.TAR_VALUE_CODE
         END                                RCPT_STAT                --借据状态
        ,TTJ.TAR_VALUE_CODE                ACC_STAT                  --账户状态
        ,CASE WHEN A.CIRCL_LOAN_FLG = '0' THEN 'N'
        WHEN A.CIRCL_LOAN_FLG = '1'THEN 'Y'
          ELSE A.CIRCL_LOAN_FLG END                   REV_LOAN_FLG              --循环贷贷款标志
        ,NULL                                REL_PSN_GUA_LOAN_FLG      --关系人保证贷款标志
        ,A.NEXT_REPAY_INT_AMT                                 BEAR_OR_RED_AMT          --承担或减免的信贷费用金额
        ,CASE WHEN F.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
         WHEN F.DOM_OVERS_FLG ='0' THEN 'N'  --MODIFY BY 20221103 1：境内 0 ：境外
         ELSE 'Z'    END                      BIO_LOAN_FLG             --客户境内外标志
        ,'800924'                             DEPT_LINE                --部门条线
        ,'零售贷款'                            DATA_SRC                  --数据来源
        ,TA.LMT_CONT_ID                       LMT_CONT_ID              --额度合同编号
        ,A.REPAY_WAY_CD                       GXH_PAY_TYPE             --还款方式
        ,A.REPAY_PED_CORP_CD                  GXH_PAY_FREQ             --还款频率
        ,TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD')  ASSET_TRAN_DT            --资产转让日期
        ,'Y'                                  LOAN_DIR_BIO_FLG         --贷款投向境内外标识 --零售贷款默认为境内
        ,CASE WHEN A.WRT_OFF_FLG = '1'
               THEN 0
               ELSE NVL(A.OVDUE_INT_AMT, 0)
           END AS OVD_INT_BAL                                          --逾期利息金额
        ,B.Cust_Crdt_Tot                     LOAN_CRDT_LMT_TOT         --放款时单户授信总额度
        ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1'
              THEN 'Y'
              ELSE 'N'
              END                           REFAC_FLG                  --支小再贷款标识
    ,NULL                                   BILL_ACT_AMT               --转帖现、福费廷的贷款金额取实付金额
    ,NULL                                   LOAN_MODAL_CD              --贷款形态代码
    ,NULL                                   OPER_ORG_ID                --经办机构编号 MOD BY HULJ 20221122
    ,NULL                                   OPER_TELLER_ID             --经办柜员编号 MOD BY HULJ 20221122
    ,/*TO_CHAR(H1.LOAN_ACT_DSTR_DT,'YYYYMMDD')*/
    H1.LOAN_ACT_DSTR_DT                     LOAN_ACT_FIRST_DT          --本行首贷日期 MOD BY HULJ 20221122
    ,TO_CHAR(A.RENEW_EXP_DT,'YYYYMMDD')     RENEW_EXP_DAY              --展期到期日期 MOD BY HULJ 20221122
    ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')   CNCL_DT                    --核销日期     ADD BY MW 20221123
    ,A.INT_RAT_ADJ_WAY_CD AS FIXED_INT_MARK                      --利率是否固定
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
       ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA  --零售贷款合同信息表
      ON TA.CONT_ID = A.CONT_ID
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO M
    ON TA.APV_FLOW_NUM = M.LOAN_APPL_FLOW_NUM
    AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO  C    --标准产品信息
      ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息
      ON D.DUBIL_ID = A.DUBIL_NUM
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F --个人客户基本信息
      ON F.CUST_ID = A.CUST_ID
     AND F.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RETL_LOAN_REPAY_PLAN DD
      ON DD.DUBIL_ID = B.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 E --表内借据信息表临时表02  --modify by tangan ta 20221124 取入账账号户名和贷款入账账号开户行名称
      ON E.CUST_ACCT_ID = A.LOAN_DISTR_ACCT_NUM
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 K --表内借据信息表临时表02
      ON K.CUST_ACCT_ID = A.LOAN_REPAY_NUM
     LEFT JOIN  O_IOL_IFRS_FCT_ECL_RES_DTL  AA--减值结果表
        ON AA.V_ID_NUMBER  = A.DUBIL_NUM
        AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN   M_LOAN_IN_DUBILL_INFO_TEMP04 AC --精准扶贫按客户整合
      ON A.CUST_ID = AC.CUST_ID
     AND AC.ACCT_DURAN = '2021-04'
    LEFT JOIN ADD_POVERTY_RELIF AD  --精准扶贫名录20211231填报数据基表
      ON AD.LOAN_NUM = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON B.STD_PROD_ID = TTA.SRC_VALUE_CODE
      AND TTA.SRC_CLASS_CODE = 'STD0002'
      AND TTA.TAR_CLASS_CODE = 'T0001'
      AND TTA.MOD_FLG = 'MDM'    --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTB  --码值映射表(贷款用途)
      ON TA.BORW_USAGE_TYPE_CD = TTB.SRC_VALUE_CODE
      AND TTB.SRC_CLASS_CODE = 'CD1274'
      AND TTB.MOD_FLG = 'MDM'     --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTC  --码值映射表(五级分类)
      ON B.LOAN_LEVEL5_CLS_CD = TTC.SRC_VALUE_CODE
      AND TTC.SRC_CLASS_CODE = 'CD1032'
      AND TTC.TAR_CLASS_CODE = 'D0005'
      AND TTC.MOD_FLG = 'MDM'     --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTE  --码值映射表(还款方式)
      ON a.int_set_way_cd = TTE.SRC_VALUE_CODE
      AND TTE.SRC_CLASS_CODE = 'CD2778'
      AND TTE.TAR_CLASS_CODE = 'D0103'
      AND TTE.MOD_FLG = 'MDM'     --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTF  --码值映射表(贷款形式)
      ON B.LOAN_HAPP_TYPE_CD = TTF.SRC_VALUE_CODE
      AND TTF.SRC_CLASS_CODE = 'CD1364'
      AND TTF.TAR_CLASS_CODE = 'D0008'
      AND TTF.MOD_FLG = 'MDM'      --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTG  --码值映射表(放款方式)
      ON B.MODE_PAY_CD = TTG.SRC_VALUE_CODE
      AND TTG.SRC_CLASS_CODE = 'CD1372'
      AND TTG.TAR_CLASS_CODE = 'D0104'
      AND TTG.MOD_FLG = 'MDM'      --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTH  --码值映射表(计息方式)
      ON A.INT_SET_WAY_CD = TTH.SRC_VALUE_CODE
      AND TTH.SRC_CLASS_CODE = 'CD1007'
      AND TTH.TAR_CLASS_CODE = 'D0061'
      AND TTH.MOD_FLG = 'MDM'     --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTI --码值映射表(借据状态)
      ON TTI.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
     AND TTI.SRC_CLASS_CODE = 'CD2554'
     AND TTI.TAR_CLASS_CODE = 'D0007'
     AND TTI.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTJ --码值映射表（账户状态）
      ON TTJ.SRC_VALUE_CODE = A.LOAN_ACCT_STATUS_CD
     AND TTJ.SRC_CLASS_CODE = 'CD2554'
     AND TTJ.TAR_CLASS_CODE = 'Z0018'
     AND TTJ.MOD_FLG = 'MDM'     --监管集市明细层
      LEFT JOIN CODE_MAP TI    --利率种类转码
      ON A.INT_RAT_BASE_TYPE_CD = TI.SRC_VALUE_CODE
      AND TI.SRC_CLASS_CODE = 'CD1010'
      AND TI.TAR_CLASS_CODE = 'Z0015'
      AND TI.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN CODE_MAP  TTK   --利率类型转码
    ON A.INT_RAT_FLOAT_WAY_CD = TTK.SRC_VALUE_CODE
    AND TTK.SRC_CLASS_CODE = 'CD1016'
    AND TTK.TAR_CLASS_CODE = 'Z0007'
    AND TTK.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN CODE_MAP TJ
    ON TJ.SRC_VALUE_CODE = M.CHN_ID
    AND TJ.SRC_CLASS_CODE = 'CD2366'
    and TJ.TAR_CLASS_CODE = 'Z0014'
    AND TJ.MOD_FLG = 'MDM'      --监管集市明细层
   LEFT JOIN CODE_MAP TTL  --利率调整频率
   ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
   AND TTL.SRC_CLASS_CODE = 'CD1041'
   AND TTL.TAR_CLASS_CODE = 'D0105'
   AND TTL.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TTM  --担保方式转码
   ON TTM.SRC_VALUE_CODE = B.GUAR_WAY_CD
   AND TTM.SRC_CLASS_CODE = 'CD2656'
   AND TTM.TAR_CLASS_CODE = 'D0002'
   AND TTM.MOD_FLG = 'MDM'
    LEFT JOIN M_LOAN_IN_DUBILL_INFO_TEMP00_BFD H1
      ON A.DUBIL_NUM = H1.RCPT_ID  --ADD BY 20220824 XUXIAOBIN  取是否首贷标志

    WHERE /*(A.CLOS_ACCT_DT >= V_MONTH_START_DATE OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
     AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
     AND*/ A.DUBIL_NUM IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '表内借据信息--联合网贷部分';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP_BFD
  (
    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                            --借据编号
    ,CONT_ID                            --合同编号
    ,BILL_NO                            --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                            --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                            --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                    --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                      --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                        --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                            --逾期类型
    ,LOAN_USEAGE                        --贷款用途
    ,LVL5_CL                            --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                      --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                  --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                    --房地产贷款标志
    ,IALL_LOAN_FLG                      --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频度
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,OVD_INT_BAL                         --逾期利息金额
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 MOD BY HULJ 20221122
    ,OPER_TELLER_ID                      --经办柜员编号 MOD BY HULJ 20221122
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 MOD BY HULJ 20221122
    ,RENEW_EXP_DAY                       --展期到期日期 MOD BY HULJ 20221122
    ,CNCL_DT                             --核销日期     ADD BY MW 20221123
    ,FIXED_INT_MARK                      --利率是否固定
    )
     WITH UNITE_WL_REPAY_PLAN AS
        (SELECT B.DUBIL_ID,
                MAX(B.TOT_PERDS) TOT_PERDS,
                MAX(B.REPAY_PERDS) REPAY_PERDS,
                MAX(CASE WHEN B.REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE B.REPAY_PERDS END) CURR_PERDS,
                SUM(CASE WHEN (TO_CHAR(B.PRIC_TURN_OVDUE_DT) NOT IN ('20991231','00010101')
                               OR TO_CHAR(B.INT_TURN_OVDUE_DT) NOT IN ('20991231','00010101'))
                          AND B.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                          AND B.OVDUE_FLG = '1'
                          AND B.REPAY_FLG = '0'
                         THEN 1 ELSE 0 END) LXQKQS, --连续欠款期数
                SUM(CASE WHEN B.OVDUE_FLG = '1' AND B.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 1 ELSE 0 END) LJQKQS --累计欠款期数
           FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN B --联合网贷还款计划
          WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          GROUP BY B.DUBIL_ID)
      /* ,UNITE_WL_DISTR_DTL AS (SELECT B.DUBIL_ID,SUM(B.DISTR_AMT) DISTR_AMT
           FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DISTR_DTL B
          INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO TA
             ON TA.DUBIL_ID = B.DUBIL_ID
            AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          WHERE B.JOB_CD LIKE 'myhb%'
            AND B.DISTR_AMT > 0
            AND B.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          GROUP BY B.DUBIL_ID  --花呗的放款金额从流水表中取数 ADD BY LIP 20220614
          )*/
    SELECT
        V_P_DATE                      DATA_DT                              --数据日期
        ,A.LP_ID                                        LGL_REP_ID                          --法人编号
        ,A.DUBIL_ID                                      ACC_ID                              --账户编号
        ,A.DUBIL_ID                                      RCPT_ID                            --借据编号
        ,A.DUBIL_ID                                      CONT_ID                            --合同编号
        ,A.DUBIL_ID                                      BILL_NO                            --票据号码
        ,CASE /*WHEN A.BUS_BREED_ID IN ('02001006135011','02001006160048')
                    AND A.DISTR_DT >= TO_DATE('20180921','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20191030','YYYYMMDD') THEN 'XR882018000851-1（2018年主协议）'
               WHEN A.BUS_BREED_ID IN ('02001006135011','02001006160048')
                    AND A.DISTR_DT >= TO_DATE('20191031','YYYYMMDD')
                    AND A.DISTR_DT <= TO_DATE('20201202','YYYYMMDD') THEN 'XZI52019000458（2019年主协议）'
               WHEN A.BUS_BREED_ID IN ('02001006135011','02001006160048')
                    AND A.DISTR_DT >= TO_DATE('20201203','YYYYMMDD') THEN 'R88HZXY20201201028（2020年主协议）'*/
               WHEN A.STD_PROD_ID = '202010100006' THEN '微银（联贷）字Y第496号'--微粒贷
               WHEN A.STD_PROD_ID  IN( '202010100001') THEN '10048663J'--借呗
               WHEN A.STD_PROD_ID  IN( '202010100003') THEN 'sign-1-180292131121'--花呗
               WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN 'JDJR-XFJR-2019-0284'--京东金条
         END                                          COOP_AGRT_ID                        --合作协议编号
        ,A.CUST_ID                                    CUST_ID                            --客户编号
        ,A.ACCT_INSTIT_ID                             ORG_ID                              --机构编号
        ,A.SUBJ_ID                                    SUBJ_ID                            --科目编号
        ,A.STD_PROD_ID                                LOAN_STD_PROD_ID                    --贷款标准产品编号
        ,M.PROD_NAME                                  LOAN_STD_PROD_NM                    --贷款标准产品名称
        ,A.STD_PROD_ID                                LOAN_PROD_ID                        --贷款产品编号
        ,/*CASE WHEN A.STD_PROD_ID  IN( '202010100001') THEN '蚂蚁借呗联合贷款'  --蚂蚁借呗
              WHEN A.STD_PROD_ID  IN( '202010100003') THEN '蚂蚁花呗联合贷款'
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN '网商贷'  --网商贷
               WHEN A.STD_PROD_ID = '202010100006' THEN '微粒贷'  --微粒贷
               WHEN A.BUS_BREED_ID = '02001004165085' THEN '京东金融'  --京东金融
          END  */
         NVL(TTA.SRC_VALUE_NAME,A.STD_PROD_ID)                                       LOAN_PROD_NM                        --贷款产品名称
        ,NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)                            LOAN_BIZ_TYP                        --贷款业务类型
        ,A.CURR_CD                                    CUR                                --币种
        ,A.DUBIL_AMT                                  LOAN_AMT                            --借款金额
        --,NVL(DTL.DISTR_AMT,A.DUBIL_AMT)              LOAN_AMT                    --借款金额 --花呗放款金额从流水表中取 20221029 LHQ
        ,CASE WHEN A.WRT_OFF_FLG ='1' THEN 0
               ELSE A.CURRT_BAL
         END                                           LOAN_BAL                            --贷款余额
        ,0                                            INT_ADJ                            --利息调整
        ,0                                            FAIR_VAL_CHG                        --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG ='1' THEN 0
              ELSE NVL(A.OVDUE_PRIC, 0) + NVL(A.IDLE_PRIC, 0)
         END                                          OVD_PRIN_BAL                        --逾期本金余额
        ,A.IN_BS_OVER_INT_BAL                          IN_INT_OVD_BAL                      --表内欠息余额
        ,A.OFF_BS_OVER_INT_BAL                        OUT_INT_OVD_BAL                    --表外欠息余额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                LOAN_ACT_DSTR_DT                    --贷款实际发放日期
        ,/*TO_CHAR(A.EXP_DT,'YYYYMMDD')*/
        --花呗存在原始到期日期可以更改的场景  参考旧金数取花呗取还款计划中的到期日
        CASE WHEN A.STD_PROD_ID='202010100003' THEN TO_CHAR(NVL(K.REPAYBL_DT,A.EXP_DT),'YYYYMMDD')
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                  LOAN_ORIG_EXP_DT                    --贷款原始到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                  LOAN_ACT_EXP_DT                    --贷款实际到期日期
        ,CASE WHEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
                    AND TFF.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) =0
                    AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231') THEN TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')
               WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231') THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')
               ELSE '29991231'
         END                                          ACT_END_DT                          --实际终止日期
       /* ,DECODE(TO_CHAR(A.PAYOFF_DT,'YYYYMMDD'),'29991231','',TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')) --实际终止日期 */--modify by hulj
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')          LAST_REPY_DT                        --上次还款日期
        ,NULL                                          LAST_REPY_AMT                      --上次还款金额
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')            VAL_DT                              --起息日期
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                OPEN_ACC_DT                        --开户日期
        /*,CASE WHEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
                    AND TFF.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) =0
                    AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231') THEN TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)>0 THEN '29991231' --modify by hulj 20221108京东金融只有到期日
               WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231') THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')
               ELSE '29991231'
         END                                           CNL_ACC_DT                */           --销户日期 --modify by hulj
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')             CNL_ACC_DT                  --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
         END                                          PRIN_OVD_DT                        --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0 THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
           END                                        INT_OVD_DT                          --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)          OVD_DAYS                            --逾期天数
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS > 0
              THEN '03'  --03：本金利息逾期
              WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS = 0
              THEN '01'  --01：本金逾期
              WHEN A.PRIC_OVDUE_DAYS = 0 AND A.INT_OVDUE_DAYS > 0
              THEN '02'  --02：利息逾期
              ELSE NULL   END                                    OVD_TYP                  --逾期类型
        ,--NVL(TTB.TAR_VALUE_CODE,A.LOAN_USAGE_CD)
        CASE WHEN A.LOAN_USAGE_CD = '100200' THEN '个人经营类贷款用途'
             WHEN A.LOAN_USAGE_CD = '010001' THEN '医疗'
             WHEN A.LOAN_USAGE_CD = '000000' THEN '未知'
             WHEN A.LOAN_USAGE_CD = '016001' THEN '消费'
             WHEN A.LOAN_USAGE_CD = '011001' THEN '教育'
             WHEN A.LOAN_USAGE_CD = '100100' THEN '个人消费类贷款用途'
             WHEN A.LOAN_USAGE_CD = '013001' THEN '旅游'
             WHEN A.LOAN_USAGE_CD = '009001' THEN '装修'
             WHEN A.LOAN_USAGE_CD = '100113' THEN '子女教育'
             WHEN A.LOAN_USAGE_CD = '100116' THEN '医疗支出'
             WHEN A.LOAN_USAGE_CD = '100106' THEN '旅游'
             WHEN A.LOAN_USAGE_CD = '100102' THEN '装修'
             ELSE A.LOAN_USAGE_CD END    LOAN_USEAGE  --20220825 XUXIAOBIN  --贷款用途
                                                      --20220906 MW 修改码值对应关系，数仓部分码值未落标
        ,TTC.TAR_VALUE_CODE                              LVL5_CL                            --五级分类
        ,TTM.TAR_VALUE_CODE                                 GUA_MODE                            --担保方式
        ,NVL(CASE WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-4)='0000' THEN SUBSTR(C.RG_COUNTY_CD,1,2)||'0101'
                   WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-2)='00' AND
                        SUBSTR(TRIM(C.RG_COUNTY_CD),1,6) NOT IN ('441900','442000','460300','460400')
                   THEN SUBSTR(C.RG_COUNTY_CD,1,4)||'01'
                   ELSE SUBSTR(TRIM(C.RG_COUNTY_CD),1,6)
               END,
              CASE WHEN E.CERT_TYPE_CD = '1010' THEN
                   CASE WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-4)='0000' THEN SUBSTR(E.CERT_NO,1,2)||'0101'
                        WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-2)='00' AND
                             SUBSTR(E.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                        THEN SUBSTR(E.CERT_NO,1,4) || '01'
                        ELSE SUBSTR(E.CERT_NO,1,6)
                    END
              END)                                      LOAN_DIR_RGN                        --贷款投向地区
        ,CASE WHEN A.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(A.DIR_INDUS_CD,'Z')
              END                                                  LOAN_DIR_IDY                        --贷款投向行业
               ,CASE WHEN A.STD_PROD_ID IN ('203010400001','203010400002')
            THEN 'Y'
           ELSE 'N'
          END AS BANK_TAX_COOP_LOAN_FLG    --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN (/*'203010200001',*/'203010200003','203010200004','203010200005','203010200006')--('1050010', '1030010', '1030020','1050020')
         THEN 'Y'
         ELSE 'N'
         END                                                     PROJ_LOAN_FLG            --项目贷款标志  --经业务确认 经营性物业贷款划分为一版固定资产贷款
        ,NULL                                                    IDY_STRU_ADJ_TYP                    --产业结构调整类型
        ,NULL                                                    IDY_TRNST_UPG_FLG                  --工业转型升级标志
        ,NULL                                                    STRTG_EMER_IDY_TYP                  --战略新兴产业类型
        ,/*CASE WHEN A.STD_PROD_ID IN ('201020100003','201020100012')  ---201020100003税兴贷、201020100012税兴贷（网贷）
         THEN 'Y'
          ELSE 'N'
          END  */
         'N'                                    BANK_TAX_COOP_LOAN_FLG   --银税合作贷款标志
        ,CASE WHEN (E.FARM_FLG = '1') THEN 'Y'
         ELSE 'N'
         END                                                   AGR_REL_LOAN_FLG                    --涉农贷款标志
        ,NULL                                                    RL_EST_LOAN_FLG                    --房地产贷款标志
        ,NULL                                                    IALL_LOAN_FLG                      --投贷联动贷款标志
        ,NULL                                                    OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
        ,NULL                                                    GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
        ,NULL                                                    ENT_GUA_LOAN_TYP                    --创业担保贷款类型
        ,NULL                                                    CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
        ,NULL                                                    LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
        ,NULL                                                    LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                    FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                    POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
        ,'08'                                                    LOAN_HDL_CHAN                      --贷款办理渠道
        ,'Y'                                                    NET_LOAN_FLG                        --互联网贷款标志
        ,CASE WHEN A.STD_PROD_ID IN( '202010100001','202010100002','202010100003','202010100004','202010100005','202010100006','202020100001')
              THEN '1' --联合贷
              WHEN A.STD_PROD_ID IN ('202010200002','202010200004','202020200003','202020200008','202010200007')
              THEN '2' --助贷
              ELSE '3' --自营
              END                                              NET_LOAN_PROD_TYP                    --网贷产品类别
        ,NULL                                                    CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
        ,TTD.TAR_VALUE_CODE                                      THREPY_MODE                          --还款方式
        ,'01'                                                    LOAN_FRM                            --贷款形式
        ,'N'                                                  RCMM_LOAN_FLG                      --重组贷款标识
        ,NULL                                                  ADJ_BAD_FLG                        --下调为不良标志
        ,NULL                                                  ALDY_RCMM_FLG                      --曾重组标志
        ,NULL                                                  CTON_PRD_LOAN_FLG                  --缩期贷款标志
        ,NULL                                                  CASH_TRF_FLG                        --现转标志
        ,DECODE(H2.RCPT_ID, NULL,'N', 'Y')                    FST_LOAN_FLG           --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H2.RCPT_ID, NULL,'N', 'Y')                    FIRST_LOAN_FLG         --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                                  PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
        ,'N'                                                  CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
        ,NULL                                                  CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
        ,NULL                                                  LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
        ,CASE WHEN  A.DISTR_DT >= DATE'2021-05-01' AND A.STD_PROD_ID = '202010100003' THEN 'N'
              WHEN ((AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫')
                    OR (A.DISTR_DT > DATE'2021-12-31' AND AC.CUST_ID IS NOT NULL))
                    THEN 'Y'
                    ELSE 'N'
                    END                                        ACURT_POV_ALLE_LOAN_FLG    --精准扶贫贷款标志
        ,NULL                                                  RATE_RE_PRC_DT                      --利率重新定价日期
/*        ,NVL(TTL.TAR_VALUE_CODE,'99')                                                  RATE_FLT_FREQ                      --利率浮动频率*/
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1D' THEN '01'---按日
        WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN('7D','1W') THEN '02'--按周
        WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1M' THEN '03'---按月
        WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='3M' THEN '04'--按季
        WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='6M' THEN '05'--按半年
        WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='12M' THEN '06'--按年
        ELSE '99'
         END AS                                                RATE_FLT_FREQ                      --利率浮动频率
        ,TTK.TAR_VALUE_CODE                                    RATE_TYP                            --利率类型
        ,NULL                                                  AST_SCRTZ_PROD_ID                  --资产证券化产品编号
        ,A.EXEC_INT_RAT                                        EXEC_RATE                          --执行利率
        ,A.BASE_RAT                                                  BASE_RATE                          --基准利率
        ,NULL                                                  CNTR_GUA_LOAN_FLG                  --反担保贷款标志
        ,A.INT_RAT_FLO_VAL                                     RATE_FLT_VAL                        --利率浮动值
        ,CASE WHEN A.STD_PROD_ID = '202010100006' THEN 'TR07' --微粒贷  --modify by hulj 20221107 更改标准产品编号
          ELSE TI.TAR_VALUE_CODE
          END                                                  PRC_BASE_TYP                        --定价基准类型
        ,CASE  WHEN (A.TOT_PERDS = 0 OR A.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') )
               THEN A.CURR_ISSUE_PERDS
               WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS
               THEN A.TOT_PERDS + 1
               ELSE A.TOT_PERDS
         END                                                TOT_PRD_NUM                        --总期数
        ,A.CURR_ISSUE_PERDS                                  CURR_PRD                            --当前期数
        ,NVL(B.LJQKQS,0)                                     CUM_DEBT_PRD_NUM                    --累计欠款期数
        ,NVL(B.LXQKQS,0)                                     CNU_DEBT_PRD_NUM                    --连续欠款期数
        ,CASE WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS
               THEN 1
              ELSE 0
           END                                              EXTN_CNT                            --展期次数
        ,'01'                                                DSBR_MODE                          --放款方式
        ,TTE.TAR_VALUE_CODE                                  INT_CALC_MODE                      --计息方式
        ,NULL                                                MRGN_PCT                            --保证金比例
        ,NULL                                                MRGN_CUR                            --保证金币种
        ,NULL                                                MRGN                                --保证金
        ,NULL                                                MRGN_ACC                            --保证金账号
        ,A.CUST_MGR_ID                                      LOAN_OFR_NO                        --信贷员工号
        ,A.CURRT_ACRU_INT                                    ACCRD_INT                          --应计利息
        ,AA.N_ECL_BEFORE                                      PRO_IMPT                            --减值准备
        ,NULL                                                COM_PRO                            --一般准备
        ,NULL                                                SPCL_PRO                            --专项准备
        ,NULL                                                ESP_PRO                            --特别准备
        ,NULL                                                SPCL_LOAN_FLG                      --专项贷款标志
        ,NULL                                                ORIG_RCPT_NO                        --原借据号
        ,CASE WHEN A.STD_PROD_ID IN( '202010100001','202010100003') THEN NVL(A.BANK_CONTRI_RATIO,1)*100  --蚂蚁花呗
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN 100 --网商贷
               WHEN A.STD_PROD_ID = '202010100006' THEN NVL(A.BANK_CONTRI_RATIO,1)*100  --微粒贷
               ELSE 90   --京东金融
         END                                                FND_PCT                            --出资比例
        ,TRIM(A.ENTER_ACCT_ACCT_NUM)                        ETR_ACC                            --入账账号
        ,CASE WHEN A.STD_PROD_ID IN ('202010100004') OR TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN E.CUST_NAME
          END                                            ETR_ACC_NM                          --入账账号户名
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006') AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
               WHEN A.STD_PROD_ID IN ('202010100004') THEN '京东'  --modify by hulj 20221107 更改标准产品编号
               WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
         END                                          LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
        ,CASE WHEN TRIM(A.REPAY_NUM) IS NOT NULL THEN TRIM(A.REPAY_NUM)
               ELSE TRIM(A.ENTER_ACCT_ACCT_NUM)
         END                                                  REPY_ACC                            --还款账号
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006') AND NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL THEN '微信'
               WHEN A.STD_PROD_ID IN ('202010100004') THEN '京东'  --modify by hulj 20221107 更改标准产品编号
               WHEN NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL THEN '支付宝'
         END                                          LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
        ,CASE WHEN A.OVDUE_FLG = '1' THEN 'B'
               WHEN A.WRT_OFF_FLG = '1' THEN 'C0201'
               ELSE TTF.TAR_VALUE_CODE
         END                                          RCPT_STAT                          --借据状态
        ,CASE WHEN A.CONT_STATUS_CD = 'NORMAL' THEN '01'   --正常
               WHEN A.CONT_STATUS_CD = 'OVD' THEN '01'   --逾期
               WHEN A.CONT_STATUS_CD = 'CLEAR' THEN '02'   --结清
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) = 0
                    AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN '02'
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) > 0 THEN '01'
               ELSE TTG.TAR_VALUE_CODE

         END                                        ACC_STAT                            --账户状态
        ,'N'                                         REV_LOAN_FLG                        --循环贷贷款标志
        ,NULL                                        REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
        ,NULL                                         BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
        ,CASE WHEN A.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
         WHEN A.DOM_OVERS_FLG ='0' THEN 'N'          --MODIFY BY MW 20221103 1:境内   0：境外
         ELSE 'Z'    END                              BIO_LOAN_FLG                       --境内外标志
        ,'800924'                                     DEPT_LINE                          --部门条线
        ,'联合网贷'                                    DATA_SRC                            --数据来源
        ,A.DUBIL_ID                                   LMT_CONT_ID                        --额度合同编号
        ,A.REPAY_WAY_CD                               GXH_PAY_TYPE                       --还款方式
        ,A.PRIC_REPAY_FREQ_CD                         GXH_PAY_FREQ                       --还款频度
        ,'Y'                                          LOAN_DIR_BIO_FLG                   --贷款投向境内外标识
        ,CASE WHEN A.WRT_OFF_FLG = '1'
               THEN 0
               ELSE NVL(A.OVDUE_INT, 0)
           END AS                               OVD_INT_BAL                --逾期利息金额
        ,'N'                                    REFAC_FLG                  --支小再贷款标识
        ,NULL                                   BILL_ACT_AMT               --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                   LOAN_MODAL_CD              --贷款形态代码
        ,NULL                                   OPER_ORG_ID                --经办机构编号
        ,NULL                                   OPER_TELLER_ID             --经办柜员编号
        ,/*TO_CHAR(H2.LOAN_ACT_DSTR_DT,'YYYYMMDD') */
         H2.LOAN_ACT_DSTR_DT                    LOAN_ACT_FIRST_DT          --本行首贷日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')           RENEW_EXP_DAY              --展期到期日期
        ,TO_CHAR(TFF.FIR_WRT_OFF_DT ,'YYYYMMDD')                    CNCL_DT                    --核销日期
        ,A.INT_RAT_ADJ_WAY_CD                  FIXED_INT_MARK                      --利率是否固定
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO  M  --标准产品信息
      ON M.PROD_ID = STD_PROD_ID
      AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN UNITE_WL_REPAY_PLAN B
      ON B.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
      ON E.CUST_ID = A.CUST_ID
      AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H C --当事人物理地址历史
      ON C.PARTY_ID = A.CUST_ID
     AND C.SRC_SYS_CD = 'EIFS'
     AND C.PHYS_ADDR_TYPE_CD = '003001' --居住地
     AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO TFF    --联合网贷核销信息
      ON TFF.DUBIL_ID = A.DUBIL_ID
     AND TFF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') + 1
       LEFT JOIN  O_IOL_IFRS_FCT_ECL_RES_DTL  AA--减值结果表
        ON AA.V_ID_NUMBER  = A.DUBIL_ID
        AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN   M_LOAN_IN_DUBILL_INFO_TEMP04 AC --精准扶贫按客户整合
      ON A.CUST_ID = AC.CUST_ID
     AND AC.ACCT_DURAN = '2021-04'
     LEFT JOIN ADD_POVERTY_RELIF AD  --精准扶贫名录20211231填报数据基表
      ON AD.LOAN_NUM = A.DUBIL_ID
    /* LEFT JOIN UNITE_WL_DISTR_DTL DTL    --ADD by LHQ 20221029
      ON DTL.DUBIL_ID = A.DUBIL_ID*/
     LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON A.STD_PROD_ID = TTA.SRC_VALUE_CODE
      AND TTA.SRC_CLASS_CODE = 'STD0002'
      AND TTA.TAR_CLASS_CODE = 'T0001'
      AND TTA.MOD_FLG = 'MDM'            --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTB  --码值映射表(贷款用途)
      ON A.LOAN_USAGE_CD = TTB.SRC_VALUE_CODE
      AND TTB.SRC_CLASS_CODE = 'CD1274'
      AND TTB.MOD_FLG = 'MDM'            --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TTC --码值映射表(五级形态)
      ON TTC.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND TTC.SRC_CLASS_CODE = 'CD1032'
     AND TTC.TAR_CLASS_CODE = 'D0005'
     AND TTC.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTD --码值映射表(还款方式)
      ON TTD.SRC_VALUE_CODE = A.int_set_way_cd
     AND TTD.SRC_CLASS_CODE = 'CD1007'
     AND TTD.TAR_CLASS_CODE = 'D0103'
     AND TTD.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTE --码值映射表(计息方式)
      ON TTE.SRC_VALUE_CODE = A.INT_SET_WAY_CD
     AND TTE.SRC_CLASS_CODE = 'CD1007'
     AND TTE.TAR_CLASS_CODE = 'D0061'
     AND TTE.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTF --码值映射表（借据状态）
      ON TTF.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TTF.SRC_CLASS_CODE = 'CD1278'
     AND TTF.TAR_CLASS_CODE = 'D0007'
     AND TTF.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTG --码值映射表(账户状态)转码
      ON TTG.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
     AND TTG.SRC_CLASS_CODE = 'CD1261'
     AND TTG.SRC_CLASS_CODE = 'Z0018'
     AND TTG.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN CODE_MAP TI       --利率种类转码
      ON A.INT_RAT_BASE_TYPE_CD = TI.SRC_VALUE_CODE
      AND TI.SRC_CLASS_CODE = 'CD1010'
      AND TI.TAR_CLASS_CODE = 'Z0015'
      AND TI.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN CODE_MAP  TTK   --利率类型转码
    ON A.INT_RAT_FLOAT_WAY_CD = TTK.SRC_VALUE_CODE
    AND TTK.SRC_CLASS_CODE = 'CD1016'
    AND TTK.TAR_CLASS_CODE = 'Z0007'
    AND TTK.MOD_FLG = 'MDM'            --监管集市明细层
   LEFT JOIN CODE_MAP TTL  --利率调整频率
   ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
   AND TTL.SRC_CLASS_CODE = 'CD1041'
   AND TTL.TAR_CLASS_CODE = 'D0105'
   AND TTL.MOD_FLG = 'MDM'
      LEFT JOIN CODE_MAP TTM  --担保方式转码
   ON TTM.SRC_VALUE_CODE = A.GUAR_WAY_CD
   AND TTM.SRC_CLASS_CODE = 'CD2656'
   AND TTM.TAR_CLASS_CODE = 'D0002'
   AND TTM.MOD_FLG = 'MDM'

   LEFT JOIN M_LOAN_IN_DUBILL_INFO_TEMP00_BFD H2
      ON A.DUBIL_ID = H2.RCPT_ID  --ADD BY 20221122 hulj  取是否首贷日期
   LEFT JOIN
       (SELECT DUBIL_ID,MAX(REPAYBL_DT) AS REPAYBL_DT   --应还款日期
        FROM O_ICL_CMM_UNITE_WL_REPAY_PLAN              --联合网贷还款计划
        WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY DUBIL_ID
      ) K ON A.DUBIL_ID =K.DUBIL_ID

    WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.DUBIL_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') + 1;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_IN_DUBILL_INFO_TMP_BFD', '', O_ERRCODE);


   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '表内借据信息--对公贷款贴现部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_IN_DUBILL_INFO_BFD
  (
    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                            --借据编号
    ,CONT_ID                            --合同编号
    ,BILL_NO                            --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                            --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                            --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                    --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                      --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                        --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                            --逾期类型
    ,LOAN_USEAGE                        --贷款用途
    ,LVL5_CL                            --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                      --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                  --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                    --房地产贷款标志
    ,IALL_LOAN_FLG                      --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 add by hulj 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 add by hulj 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 add by hulj 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 add by hulj 20221123
    ,FIR_LON_DT                          --征信首贷日期 add by hulj 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 add by hulj 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 add by hulj 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 add by hulj 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 add by hulj 20221123
    ,DISCNT_CUST_ID                      --直贴人客户编号
    )
    WITH PTY_CPES_MEM AS (
         SELECT TRIM(TTA.MEM_ORG_CD) MEM_ORG_CD,--会员机构代码
                TRIM(TTA.MEM_ORG_ID) MEM_ORG_ID,--会员机构编号
                TRIM(TTA.ORG_CN_FNAME) ORG_CN_FNAME,--机构中文全称
                TRIM(TTA.ORG_CN_ABBR) ORG_CN_ABBR,--机构中文简称
                TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) SYS_PRTCPTR_BIGAMT_BANK_NO,--系统参与者大额行号
                CASE WHEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),'0') <> '0' THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME)
                     ELSE TRIM(TTA.ORG_CN_FNAME)
                 END SYS_PRTCPTR_BIGAMT_BANK_NAME,--系统参与者大额行名
                ROW_NUMBER() OVER(PARTITION BY CASE WHEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
                                                    THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO)
                                                    ELSE TRIM(TTA.ORG_CN_ABBR) END
                   ORDER BY TRIM(SYS_PRTCPTR_BIGAMT_BANK_NAME) NULLS LAST) RN
           FROM RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
          WHERE TTA.ID_MARK <> 'D')
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                DATA_DT                     --数据日期
         ,A.LP_ID                                     LGL_REP_ID                  --法人编号
         ,A.BILL_NUM                                  ACC_ID                      --账户编号
         ,B.DUBIL_ID                                  RCPT_ID                     --借据编号
         ,B.CONT_ID                                   CONT_ID                     --合同编号
         ,A.BILL_ID                                   BILL_NO                     --票据号码 20220420改为票据唯一ID
         ,NULL                                        COOP_AGRT_ID                --合作协议编号
         ,B.CUST_ID                                   CUST_ID                     --客户编号
         ,A.ENTER_ACCT_ORG_ID                         ORG_ID                      --机构编号
         ,A.SUBJ_ID                                   SUBJ_ID                     --科目编号
         ,B.STD_PROD_ID                               LOAN_STD_PROD_ID            --贷款标准产品编号
         ,NULL                                        LOAN_STD_PROD_NM            --贷款标准产品名称
         ,B.STD_PROD_ID                              LOAN_PROD_ID                --贷款产品编号
         ,NVL(TTA.SRC_VALUE_NAME,B.STD_PROD_ID)       LOAN_PROD_NM                --贷款产品名称
         ,'0301'       LOAN_BIZ_TYP                --贷款业务类型
         ,A.CURR_CD                                   CUR                         --币种
         ,A.FAC_VAL_AMT                               LOAN_AMT                    --借款金额
         ,CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND((NVL(A.CURRT_BAL, 0) /*- NVL(A.INT_ADJ_BAL, 0) + NVL(O.N_PV_VARIATION, 0)*/),2)
               ELSE 0
           END                                        LOAN_BAL                    --贷款余额
         ,NVL(A.INT_ADJ_BAL, 0)                       INT_ADJ                     --利息调整
         ,NVL(O.N_PV_VARIATION, 0)                    FAIR_VAL_CHG                --公允价值变动
         ,NULL                                        OVD_PRIN_BAL                --逾期本金余额
         ,NULL                                        IN_INT_OVD_BAL              --表内欠息余额
         ,NULL                                        OUT_INT_OVD_BAL             --表外欠息余额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              LOAN_ACT_DSTR_DT            --贷款实际发放日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                LOAN_ORIG_EXP_DT            --贷款原始到期日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')           LOAN_ACT_EXP_DT             --贷款实际到期日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        ACT_END_DT                  --实际终止日期
         ,NULL                                        LAST_REPY_DT                --上次还款日期
         ,NULL                                        LAST_REPY_AMT               --上次还款金额
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')              VAL_DT                      --起息日期
         ,TO_CHAR(A.APPL_DT,'YYYYMMDD')               OPEN_ACC_DT                 --开户日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101')   -- ,'29991231'
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        CNL_ACC_DT                  --销户日期
         ,NULL                                        PRIN_OVD_DT                 --本金逾期日期
         ,NULL                                        INT_OVD_DT                  --利息逾期日期
         ,NULL                                        OVD_DAYS                    --逾期天数
        ,CASE WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS > 0
              THEN '03'  --03：本金利息逾期
              WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS = 0
              THEN '01'  --01：本金逾期
              WHEN C.PRIC_OVDUE_DAYS = 0 AND C.INT_OVDUE_DAYS > 0
              THEN '02'  --02：利息逾期
              ELSE NULL   END                                    OVD_TYP                  --逾期类型
         ,H.LOAN_USAGE_DESCB                          LOAN_USEAGE                 --贷款用途
         ,TB.TAR_VALUE_CODE                           LVL5_CL                     --五级分类
         ,B.GUAR_WAY_CD                               GUA_MODE                    --担保方式
         --,NVL(TRIM(E.RG_CD),TRIM(F.DIST_CD))          LOAN_DIR_RGN                --贷款投向地区
         ,CASE /*WHEN E.RG_CD = '810000' THEN 'HKG'
               WHEN E.RG_CD = '820000' THEN 'MAC'
               WHEN E.RG_CD = '710000' THEN 'TWN'
               WHEN NVL(TRIM(E.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111') THEN TRIM(E.INVTOR_CTY_CD)*/
               WHEN TRIM(E.RG_CD) NOT IN ('1000','999999','000000') THEN TRIM(E.RG_CD)
               WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(F.DIST_CD)
           END                                        LOAN_DIR_RGN                --贷款投向地区
         ,CASE WHEN B.DIR_INDUS_CD= '-' THEN 'Z'
               ELSE NVL(B.DIR_INDUS_CD,'Z')
               END                              LOAN_DIR_IDY                --贷款投向行业
         ,NULL                                        SYN_LOAN_FLG                --银团贷款标志
         ,NULL                                        PROJ_LOAN_FLG               --项目贷款标志
         ,NULL                                        IDY_STRU_ADJ_TYP            --产业结构调整类型
         ,NULL                                        IDY_TRNST_UPG_FLG           --工业转型升级标志
         ,NULL                                        STRTG_EMER_IDY_TYP          --战略新兴产业类型
        ,/*CASE WHEN A.STD_PROD_ID IN ('201020100003','201020100012')  ---201020100003税兴贷、201020100012税兴贷（网贷）
         THEN 'Y'
          ELSE 'N'
          END */
         'N'                                     BANK_TAX_COOP_LOAN_FLG   --银税合作贷款标志
         ,CASE WHEN H.AGCLT_FLG='1' THEN 'Y'
               ELSE 'N'
               END      AGR_REL_LOAN_FLG            --涉农贷款标志
         ,NULL                                        RL_EST_LOAN_FLG             --房地产贷款标志
         ,NULL                                        IALL_LOAN_FLG               --投贷联动贷款标志
         ,NULL                                        OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
         ,NULL                                        GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
         ,NULL                                        ENT_GUA_LOAN_TYP            --创业担保贷款类型
         ,NULL                                        CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
         ,NULL                                        LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
         ,NULL                                        LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
         ,NULL                                        FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
         ,NULL                                        POV_ALLE_REC_FLG            --建档立卡贫困人口贷款标志
         ,NULL                                        LOAN_HDL_CHAN               --贷款办理渠道
         ,'N'                                        NET_LOAN_FLG                --互联网贷款标志
         ,'0'                                        NET_LOAN_PROD_TYP            --网贷产品类别
         ,NULL                                        CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
         ,'9914'                                      REPY_MODE                   --还款方式 --其他-承兑人到期付款
         ,'01'                                        LOAN_FRM                    --贷款形式 D0008
         ,NULL                                        RCMB_LOAN_FLG               --重组贷款标识
         ,NULL                                        ADJ_BAD_FLG                 --下调为不良标志
         ,NULL                                        ALDY_RCMB_FLG               --曾重组标志
         ,NULL                                        CTON_PRD_LOAN_FLG           --缩期贷款标志
         ,NULL                                        CASH_TRF_FLG                --现转标志
         ,NULL                                        FST_LOAN_FLG                --首贷户贷款标志
         ,NULL                                        FIRST_LOAN_FLG              --首次贷款标志
         ,NULL                                        PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
         ,CASE WHEN SUBSTR(E.GREEN_CRDT_CLS_CD,1,1) IN ('A','B','C','D','E','F')
               AND B.STD_PROD_ID NOT IN( '602030100001','602030100002') THEN 'Y'
           END                                        CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
         ,NULL                                        CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
         ,NULL                                        LOAN_FINC_SPT_MODE          --贷款财政扶持方式
         ,'N'                                         ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
         ,NULL                                        RATE_RE_PRC_DT              --利率重新定价日期
         ,NULL                                        RATE_FLT_FREQ               --利率浮动频率
         ,NULL                                        RATE_TYP                    --利率类型
         ,NULL                                        AST_SCRTZ_PROD_ID           --资产证券化产品编号
         ,A.DISCNT_INT_RAT                            EXEC_RATE                   --执行利率
         ,NULL                                        BASE_RATE                   --基准利率
         ,NULL                                        CNTR_GUA_LOAN_FLG           --反担保贷款标志
         ,NULL                                        RATE_FLT_VAL                --利率浮动值
         ,NULL                                        PRC_BASE_TYP                --定价基准类型
         ,'1'                                         TOT_PRD_NUM                 --总期数
         ,'1'                                         CURR_PRD                    --当前期数
         ,0                                           CUM_DEBT_PRD_NUM            --累计欠款期数
         ,0                                           CNU_DEBT_PRD_NUM            --连续欠款期数
         ,NULL                                        EXTN_CNT                    --展期次数
         ,CASE WHEN B.MONEY_USE_TYPE_CD = '2' THEN '02'
               ELSE NVL(TF.TAR_VALUE_CODE,'01')
           END                                        DSBR_MODE                   --放款方式
         ,TC.TAR_VALUE_CODE                           INT_CALC_MODE               --计息方式 CD1386-->D0061
         ,NULL                                        MRGN_PCT                    --保证金比例
         ,NULL                                        MRGN_CUR                    --保证金币种
         ,NULL                                        MRGN                        --保证金
         ,NULL                                        MRGN_ACC                    --保证金账号
         ,A.CUST_MGR_ID                               LOAN_OFR_NO                 --信贷员工号
         ,A.INT_AMT                                   ACCRD_INT                   --应计利息
         ,NULL                                        PRO_IMPT                    --减值准备
         ,NULL                                        COM_PRO                     --一般准备
         ,NULL                                        SPCL_PRO                    --专项准备
         ,NULL                                        ESP_PRO                     --特别准备
         ,NULL                                        SPCL_LOAN_FLG               --专项贷款标志
         ,NULL                                        ORIG_RCPT_NO                --原借据号
         ,NULL                                        FND_PCT                     --出资比例
         ,NVL(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(B.STL_ACCT_NUM)) ETR_ACC          --入账账号
         ,NVL(TRIM(A.DSCNT_PROPS_NAME),TRIM(B.RECVBL_ACCT_NAME)) ETR_ACC_NM       --入账账号户名
         ,NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME)) LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
         /*,TRIM(A.ACCPTOR_ACCT_NUM)                    REPY_ACC                    --还款账号
         ,TRIM(A.ACCPTOR_OPEN_BANK_NAME)              LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称*/
         --银票取出票人账号，商票取贴现申请人的账号
         ,CASE WHEN A.BILL_KIND_CD='01' THEN TRIM(A.DRAWER_ACCT_NUM)--030101 银行承兑汇票贴现
               WHEN A.BILL_KIND_CD='02' THEN NVL(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(B.STL_ACCT_NUM))--030102 商业承兑汇票贴现
          END                                         REPY_ACC                    --还款账号
         ,CASE WHEN A.BILL_KIND_CD='01' THEN TRIM(A.DRAWER_OPEN_BANK_NAME)--030101 银行承兑汇票贴现
               WHEN A.BILL_KIND_CD='02' THEN NVL(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(B.STL_ACCT_NUM))--030102 商业承兑汇票贴现
          END                                         LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD') AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN 'C01'
               ELSE TD.TAR_VALUE_CODE
           END                                        RCPT_STAT                   --借据状态 CD1258-->D0007
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD') AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN '02' --02  销户
               ELSE '01' --01  正常
           END                                        ACC_STAT                    --账户状态 Z0008
         ,CASE WHEN H.CIRCL_FLG = '1' THEN 'Y'
          ELSE 'N'     END                             REV_LOAN_FLG                --循环贷贷款标志
         ,NULL                                        REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
         ,NULL                                        BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
         ,CASE WHEN E.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
         WHEN E.DOM_OVERS_FLG ='0' THEN 'N'   --MODIFY BY MW 20221103 1:境内 0：境外
         ELSE 'Z'    END                              BIO_LOAN_FLG                 --境内外标志
         ,'800926'                                    DEPT_LINE                   --部门条线--票据业务事业部
         ,'票据贴现'                                   DATA_SRC                    --数据来源
         ,H.LMT_CONT_ID                               LMT_CONT_ID                 --额度合同编号
         ,B.REPAY_WAY_CD                              GXH_PAY_TYPE                --还款方式
         ,TO_CHAR(C.ASSET_TRAN_DT,'YYYYMMDD')         ASSET_TRAN_DT               --资产转让日期
         ,CASE WHEN B.OVERS_LOAN_FLG = '1'
               THEN 'Y'
               WHEN B.OVERS_LOAN_FLG = '0'
               THEN 'N'
               ELSE 'Z'
               END                                    LOAN_DIR_BIO_FLG            --贷款投向境内外标识
         ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1'
               THEN 'Y'
               ELSE 'N'
               END                                    REFAC_FLG                   --支小再贷款标识
         ,A.ACTL_AMT                                  BILL_ACT_AMT                --贴现、转贴现实付金额
         ,A.HXB_ACPT_FLG                         LOAN_MODAL_CD               --贷款形态代码
         ,B.OPER_ORG_ID                               OPER_ORG_ID     --经办机构编号 add by hulj 20221123
         ,B.OPER_TELLER_ID                            OPER_TELLER_ID  --经办柜员编号 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            LOAN_ACT_FIRST_DT --本行首贷日期 add by hulj 20221123
         ,NULL                                        RENEW_EXP_DAY --展期到期日期 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            FIR_LON_DT --征信首贷日期 add by hulj 20221123
         ,T18.CLERK_ID                                LOAN_MGR_ID --借据主办客户经理号 add by hulj 20221123
         ,B.RGST_TELLER_ID                            LOAN_TELLER_ID --借据主办柜员号 add by hulj 20221123
         ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)        LOAN_MGR_NAME --借据主办客户经理名称 add by hulj 20221123
         ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)    LOAN_MGR_BELONG_ORG_ID --借据主办客户经理所属机构 add by hulj 20221123
         ,A.CUST_ID  AS DISCNT_CUST_ID                      --直贴人客户编号
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = A.BILL_ENTRY_ID
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     --AND (B.PAYOFF_DT >= V_MONTH_START_DATE OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0) --模型中过滤已结清的借据
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO C  --对公贷款账户信息
        ON B.DUBIL_ID = C.DUBIL_NUM
        AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO H --对公贷款合同信息
      ON H.CONT_ID=B.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = A.CUST_ID
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.PHYS_ADDR_TYPE_CD = '001001' --居住地
     AND TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
     AND F.ID_MARK <> 'D'
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
         ON T3.DUBIL_ID = B.DUBIL_ID
         AND  T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_NUM               --MODIFY BY MW 20221209  关联字段改为BILL_NUM
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN PTY_CPES_MEM TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RN = 1
     --AND TTA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON B.STD_PROD_ID = TTA.SRC_VALUE_CODE
      AND TTA.SRC_CLASS_CODE = 'STD0002'
      AND TTA.TAR_CLASS_CODE = 'T0001'
      AND TTA.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级形态转码
      ON TB.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --五级形态转码
      ON TC.SRC_VALUE_CODE = B.COL_INT_TYPE_CD
     AND TC.SRC_CLASS_CODE = 'CD1386'
     AND TC.TAR_CLASS_CODE = 'D0061'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TD --借据状态转码
      ON TD.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
     AND TD.SRC_CLASS_CODE = 'CD2651'
     AND TD.TAR_CLASS_CODE = 'D0007'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TF --放款方式转码 CD1372-->D0104
      ON TF.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
     AND TF.SRC_CLASS_CODE = 'CD1372'
     AND TF.TAR_CLASS_CODE = 'D0104'
     AND TF.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                  FROM O_ICL_CMM_CLERK_INFO T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.TELLER_ID IS NOT NULL
                ) T18
        ON B.RGST_TELLER_ID = T18.TELLER_ID
       AND T18.RN = 1
    LEFT JOIN O_ICL_CMM_TELLER_INFO T19
        ON B.RGST_TELLER_ID = T19.TELLER_ID
       AND T19.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
         --modify LHQ　20221113 LHQ
     AND A.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '表内借据信息--对公贷款买断式转贴现部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_IN_DUBILL_INFO_BFD
  (
    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                            --借据编号
    ,CONT_ID                            --合同编号
    ,BILL_NO                            --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                            --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                            --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                    --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                      --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                        --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                            --逾期类型
    ,LOAN_USEAGE                        --贷款用途
    ,LVL5_CL                            --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                      --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                  --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                    --房地产贷款标志
    ,IALL_LOAN_FLG                      --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 add by hulj 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 add by hulj 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 add by hulj 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 add by hulj 20221123
    ,FIR_LON_DT                          --征信首贷日期 add by hulj 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 add by hulj 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 add by hulj 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 add by hulj 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 add by hulj 20221123
    ,DISCNT_CUST_ID                      --直贴人客户编号
    ,SYS_IN_FLG                          --系统内标志： 1系统外 0系统内
    )
     WITH PTY_CPES_MEM AS (
         SELECT TRIM(TTA.MEM_ORG_CD) MEM_ORG_CD,--会员机构代码
                TRIM(TTA.MEM_ORG_ID) MEM_ORG_ID,--会员机构编号
                TRIM(TTA.ORG_CN_FNAME) ORG_CN_FNAME,--机构中文全称
                TRIM(TTA.ORG_CN_ABBR) ORG_CN_ABBR,--机构中文简称
                TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) SYS_PRTCPTR_BIGAMT_BANK_NO,--系统参与者大额行号
                TRIM(TTA.DIST_CD) DIST_CD,--行政区划代码
                CASE WHEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),'0') <> '0' THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME)
                     ELSE TRIM(TTA.ORG_CN_FNAME)
                 END SYS_PRTCPTR_BIGAMT_BANK_NAME,--系统参与者大额行名
                ROW_NUMBER() OVER(PARTITION BY CASE WHEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
                                                    THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO)
                                                    ELSE TRIM(TTA.ORG_CN_ABBR) END
                   ORDER BY TRIM(SYS_PRTCPTR_BIGAMT_BANK_NAME) NULLS LAST) RN
           FROM RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
          WHERE TTA.ID_MARK <> 'D')
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                DATA_DT                     --数据日期
         ,A.LP_ID                                     LGL_REP_ID                  --法人编号
         ,A.BILL_NUM                                  ACC_ID                      --账户编号
         ,A.BATCH_ID||A.BILL_NUM                                  RCPT_ID                     --借据编号
         ,B.CONT_ID                                   CONT_ID                     --合同编号
         ,A.BILL_ID                                   BILL_NO                     --票据号码 20220420改为票据唯一ID
         ,NULL                                        COOP_AGRT_ID                --合作协议编号
         ,A.CNTPTY_ID                                   CUST_ID                   --客户编号 取交易对手的客户编号
         ,A.ACCT_INSTIT_ID                            ORG_ID                      --机构编号
         ,A.SUBJ_ID                                   SUBJ_ID                     --科目编号
         ,B.STD_PROD_ID                               LOAN_STD_PROD_ID            --贷款标准产品编号
         ,NULL                                        LOAN_STD_PROD_NM            --贷款标准产品名称
         ,B.STD_PROD_ID                               LOAN_PROD_ID                --贷款产品编号
         ,NULL                                        LOAN_PROD_NM                --贷款产品名称
         ,'0302'
                                                      LOAN_BIZ_TYP                --贷款业务类型 --买断式转贴现
         ,A.CURR_CD                                   CUR                         --币种
         ,A.FAC_VAL_AMT                               LOAN_AMT                    --借款金额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
               THEN ROUND((NVL(A.CURRT_BAL, 0) /*- NVL(A.INT_ADJ_BAL, 0) + NVL(O.N_PV_VARIATION, 0)*/),2)
               WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND((NVL(A.CURRT_BAL, 0) /*- NVL(A.INT_ADJ_BAL, 0) + NVL(O.N_PV_VARIATION, 0)*/),2)
               ELSE 0                                        --MODIFY BY HYF 公允价值变动四舍五入取小数点后二位
           END                                        LOAN_BAL                    --贷款余额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = '0'
               THEN NVL(A.INT_ADJ_BAL, 0)
               WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN NVL(A.INT_ADJ_BAL, 0)
               ELSE 0                                        --MODIFY BY HYF 公允价值变动四舍五入取小数点后二位
           END                                        INT_ADJ                     --利息调整
         ,CASE WHEN V_P_DATE <= '20210630' AND NVL(A.CURRT_BAL, 0) = 0 AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0
               WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD') AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND J.PAYOFF_FLG = 0
               THEN NVL(O.N_PV_VARIATION, 0)
               WHEN NVL(A.CURRT_BAL, 0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN NVL(O.N_PV_VARIATION, 0)
               ELSE 0                                        --MODIFY BY HYF 公允价值变动四舍五入取小数点后二位
           END                                        FAIR_VAL_CHG                --公允价值变动
         ,NULL                                        OVD_PRIN_BAL                --逾期本金余额
         ,NULL                                        IN_INT_OVD_BAL              --表内欠息余额
         ,NULL                                        OUT_INT_OVD_BAL             --表外欠息余额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              LOAN_ACT_DSTR_DT            --贷款实际发放日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                LOAN_ORIG_EXP_DT            --贷款原始到期日期
         ,TO_CHAR(A.ACTL_EXP_DT,'YYYYMMDD')                LOAN_ACT_EXP_DT        --贷款实际到期日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        ACT_END_DT                  --实际终止日期
         ,NULL                                        LAST_REPY_DT                --上次还款日期
         ,NULL                                        LAST_REPY_AMT               --上次还款金额
         ,/*TO_CHAR(B.DISTR_DT,'YYYYMMDD')*/
         CASE WHEN A.SYS_IN_FLG='1' THEN TO_CHAR(A.BUS_DT,'YYYYMMDD')
                 ELSE TO_CHAR(A.DISCNT_DT,'YYYYMMDD')
            END              VAL_DT                      --起息日期20221206 MODIFY
         ,TO_CHAR(A.APPL_DT,'YYYYMMDD')               OPEN_ACC_DT                 --开户日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101')  -- ,'29991231'
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        CNL_ACC_DT                  --销户日期
         ,NULL                                        PRIN_OVD_DT                 --本金逾期日期
         ,NULL                                        INT_OVD_DT                  --利息逾期日期
         ,NULL                                        OVD_DAYS                    --逾期天数
        ,CASE WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS > 0
              THEN '03'  --03：本金利息逾期
              WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS = 0
              THEN '01'  --01：本金逾期
              WHEN C.PRIC_OVDUE_DAYS = 0 AND C.INT_OVDUE_DAYS > 0
              THEN '02'  --02：利息逾期
              ELSE NULL   END                                    OVD_TYP                  --逾期类型
         ,NVL(TRIM(H.LOAN_USAGE_DESCB),'上海票据交易所系统参与者间开展的票据交易') LOAN_USEAGE                 --贷款用途
         ,TB.TAR_VALUE_CODE                           LVL5_CL                     --五级分类
         ,B.GUAR_WAY_CD                               GUA_MODE                    --担保方式
         ,CASE WHEN E.RG_CD = '810000' THEN 'HKG'
               WHEN E.RG_CD = '820000' THEN 'MAC'
               WHEN E.RG_CD = '710000' THEN 'TWN'
               WHEN NVL(TRIM(E.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111') THEN TRIM(E.INVTOR_CTY_CD)
               WHEN TRIM(E.RG_CD) NOT IN ('1000','999999','000000') THEN TRIM(E.RG_CD)
               WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(F.DIST_CD)
               WHEN TRIM(TTA.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(TTA.DIST_CD)
               WHEN TRIM(TTB.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(TTB.DIST_CD)
           END                                        LOAN_DIR_RGN                --贷款投向地区
         ,CASE WHEN B.DIR_INDUS_CD= '-' THEN 'Z'
               ELSE NVL(B.DIR_INDUS_CD,'Z')
               END                                  LOAN_DIR_IDY                --贷款投向行业
         ,NULL                                        SYN_LOAN_FLG                --银团贷款标志
         ,NULL                                        PROJ_LOAN_FLG               --项目贷款标志
         ,NULL                                        IDY_STRU_ADJ_TYP            --产业结构调整类型
         ,NULL                                        IDY_TRNST_UPG_FLG           --工业转型升级标志
         ,NULL                                        STRTG_EMER_IDY_TYP          --战略新兴产业类型
        ,/*CASE WHEN A.STD_PROD_ID IN ('201020100003','201020100012')  ---201020100003税兴贷、201020100012税兴贷（网贷）
         THEN 'Y'
          ELSE 'N'
          END */
          'N'                                         BANK_TAX_COOP_LOAN_FLG   --银税合作贷款标志
         ,CASE WHEN H.AGCLT_FLG='1' THEN 'Y'
               ELSE 'N'
               END                                    AGR_REL_LOAN_FLG            --涉农贷款标志
         ,NULL                                        RL_EST_LOAN_FLG             --房地产贷款标志
         ,NULL                                        IALL_LOAN_FLG               --投贷联动贷款标志
         ,NULL                                        OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
         ,NULL                                        GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
         ,NULL                                        ENT_GUA_LOAN_TYP            --创业担保贷款类型
         ,NULL                                        CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
         ,NULL                                        LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
         ,NULL                                        LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
         ,NULL                                        FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
         ,NULL                                        POV_ALLE_REC_FLG            --建档立卡贫困人口贷款标志
         ,NULL                                        LOAN_HDL_CHAN               --贷款办理渠道
         ,'N'                                        NET_LOAN_FLG                --互联网贷款标志
         ,'0'                                        NET_LOAN_PROD_TYP            --网贷产品类别
         ,NULL                                        CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
         ,'9914'                                      REPY_MODE                   --还款方式 --其他-承兑人到期付款
         ,'01'                                        LOAN_FRM                    --贷款形式 D0008
         ,NULL                                        RCMB_LOAN_FLG               --重组贷款标识
         ,NULL                                        ADJ_BAD_FLG                 --下调为不良标志
         ,NULL                                        ALDY_RCMB_FLG               --曾重组标志
         ,NULL                                        CTON_PRD_LOAN_FLG           --缩期贷款标志
         ,NULL                                        CASH_TRF_FLG                --现转标志
         ,NULL                                        FST_LOAN_FLG                --首贷户贷款标志
         ,NULL                                        FIRST_LOAN_FLG              --首次贷款标志
         ,NULL                                        PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
         ,/*CASE WHEN SUBSTR(E.GREEN_CRDT_CLS_CD,1,1) IN ('A','B','C','D','E','F')
               AND B.BUS_BREED_ID <> '2070' THEN 'Y'
           END*/
          'N'                                         CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志 --监管报送中的表内借据没统计这部分
         ,NULL                                        CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
         ,NULL                                        LOAN_FINC_SPT_MODE          --贷款财政扶持方式
         ,'N'                                         ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
         ,NULL                                        RATE_RE_PRC_DT              --利率重新定价日期
         ,NULL                                        RATE_FLT_FREQ               --利率浮动频率
         ,NULL                                        RATE_TYP                    --利率类型
         ,NULL                                        AST_SCRTZ_PROD_ID           --资产证券化产品编号
         ,A.DISCNT_INT_RAT                            EXEC_RATE                   --执行利率
         ,NULL                                        BASE_RATE                   --基准利率
         ,NULL                                        CNTR_GUA_LOAN_FLG           --反担保贷款标志
         ,NULL                                        RATE_FLT_VAL                --利率浮动值
         ,NULL                                        PRC_BASE_TYP                --定价基准类型
         ,'1'                                         TOT_PRD_NUM                 --总期数
         ,'1'                                         CURR_PRD                    --当前期数
         ,0                                           CUM_DEBT_PRD_NUM            --累计欠款期数
         ,0                                           CNU_DEBT_PRD_NUM            --连续欠款期数
         ,0                                           EXTN_CNT                    --展期次数
         ,CASE WHEN B.MONEY_USE_TYPE_CD = '2' THEN '02'
               ELSE NVL(TF.TAR_VALUE_CODE,'01')
           END                                        DSBR_MODE                   --放款方式
         ,TC.TAR_VALUE_CODE                           INT_CALC_MODE               --计息方式 CD1386-->D0061
         ,NULL                                        MRGN_PCT                    --保证金比例
         ,NULL                                        MRGN_CUR                    --保证金币种
         ,NULL                                        MRGN                        --保证金
         ,NULL                                        MRGN_ACC                    --保证金账号
         ,A.CUST_MGR_ID                               LOAN_OFR_NO                 --信贷员工号
         ,A.INT_AMT                                   ACCRD_INT                   --应计利息
         ,NULL                                        PRO_IMPT                    --减值准备
         ,NULL                                        COM_PRO                     --一般准备
         ,NULL                                        SPCL_PRO                    --专项准备
         ,NULL                                        ESP_PRO                     --特别准备
         ,NULL                                        SPCL_LOAN_FLG               --专项贷款标志
         ,A.CTR_NT_ID                                 ORIG_RCPT_NO                --原借据号
         ,NULL                                        FND_PCT                     --出资比例
         /*,B.DISTR_ACCT_NUM                            ETR_ACC                     --入账账号
         ,B.RECVBL_ACCT_NAME                          ETR_ACC_NM                  --入账账号户名
         ,B.RECVBL_BANK_NAME                          LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称*/
         ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) ETR_ACC                 --入账账号 --参考答疑口径二期740、704调整
         ,A.CNTPTY_NAME                               ETR_ACC_NM                  --入账账号户名
         ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
         ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) REPY_ACC                --还款账号
         ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD') AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN 'C01'
               ELSE TD.TAR_VALUE_CODE
           END                                        RCPT_STAT                   --借据状态 CD1258-->D0007
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD') AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN '02' --02  销户
               ELSE '01' --01  正常
           END                                        ACC_STAT                    --账户状态
         ,CASE WHEN H.circl_flg = '1' THEN 'Y'
         ELSE 'N' END                                        REV_LOAN_FLG                --循环贷贷款标志
         ,NULL                                        REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
         ,NULL                                        BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
         ,CASE WHEN E.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
         WHEN E.DOM_OVERS_FLG ='0' THEN 'N'    --MODIFY BY MW 20221103 1:境内 0：境外
         ELSE 'Z'    END                                                       BIO_LOAN_FLG                 --境内外标志
         ,'800935'                                    DEPT_LINE                   --部门条线--票据业务事业部
         ,'票据转贴现'                                 DATA_SRC                    --数据来源
         ,H.LMT_CONT_ID                               LMT_CONT_ID                 --额度合同编号
         ,B.REPAY_WAY_CD                              GXH_PAY_TYPE                --还款方式
         ,to_char(C.ASSET_TRAN_DT,'yyyymmdd')         ASSET_TRAN_DT               --资产转让日期
         ,CASE WHEN B.OVERS_LOAN_FLG = '1'
               THEN 'Y'
               WHEN B.OVERS_LOAN_FLG = '0'
               THEN 'N'
               ELSE 'Z'
               END                                     LOAN_DIR_BIO_FLG            --贷款投向境内外标识
         ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1'
               THEN 'Y'
               ELSE 'N'
               END                                     REFAC_FLG                   --支小再贷款标识
         ,A.STL_AMT                                    BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
         ,A.HXB_ACPT_FLG                                        LOAN_MODAL_CD               --贷款形态代码
         ,B.OPER_ORG_ID                               OPER_ORG_ID     --经办机构编号 add by hulj 20221123
         ,B.OPER_TELLER_ID                            OPER_TELLER_ID  --经办柜员编号 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            LOAN_ACT_FIRST_DT --本行首贷日期 add by hulj 20221123
         ,NULL                                        RENEW_EXP_DAY --展期到期日期 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            FIR_LON_DT --征信首贷日期 add by hulj 20221123
         ,T18.CLERK_ID                                LOAN_MGR_ID --借据主办客户经理号 add by hulj 20221123
         ,B.RGST_TELLER_ID                            LOAN_TELLER_ID --借据主办柜员号 add by hulj 20221123
         ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)        LOAN_MGR_NAME --借据主办客户经理名称 add by hulj 20221123
         ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)    LOAN_MGR_BELONG_ORG_ID --借据主办客户经理所属机构 add by hulj 20221123
         ,T4.CUST_ID                                  DISCNT_CUST_ID         --直贴人客户编号
         ,A.SYS_IN_FLG                                SYS_IN_FLG--系统内标志： 1系统外 0系统内
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    INNER JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
      ON J.BILL_ID = A.BILL_ID
      AND NVL(TRIM(J.BILL_SUB_INTRV_ID),'-') = NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')
     AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002') --20220924 MW 修改'204010100001' 银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
     --AND (B.PAYOFF_DT >= V_MONTH_START_DATE OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0) --模型中过滤已结清的借据
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO H --对公贷款合同信息
      ON H.CONT_ID=B.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO C  --对公贷款账户信息
        ON B.DUBIL_ID = C.DUBIL_NUM
        AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')

    LEFT JOIN O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
         ON T3.DUBIL_ID = B.DUBIL_ID
         AND  T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ( SELECT bill_num,CUST_ID FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO a
              WHERE  A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
                     AND A.ENTRY_STATUS_CD = '03'
                    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') )T4
      ON A.BILL_NUM = T4.BILL_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = B.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = B.CUST_ID
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.PHYS_ADDR_TYPE_CD = '001001' --居住地
     AND TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
     AND F.ID_MARK <> 'D'
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      /*ON O.V_TRADE_NO = A.BILL_ID*/
      ON O.V_TRADE_NO = A.BILL_NUM                --MODIFY BY MW 20221209   根据源系统口径改为BILL_NUM关联
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN PTY_CPES_MEM TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.CNTPTY_BANK_NO)
     AND TTA.RN = 1
     --AND TTA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN PTY_CPES_MEM TTB --票交所会员 只有一天数据
      ON TTB.ORG_CN_ABBR = TRIM(A.CNTPTY_NAME)
     AND TTB.RN = 1
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级形态转码
      ON TB.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --五级形态转码
      ON TC.SRC_VALUE_CODE = B.COL_INT_TYPE_CD
     AND TC.SRC_CLASS_CODE = 'CD1386'
     AND TC.TAR_CLASS_CODE = 'D0061'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TD --借据状态转码
      ON TD.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
     AND TD.SRC_CLASS_CODE = 'CD2651'
     AND TD.TAR_CLASS_CODE = 'D0007'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TF --放款方式转码 CD1372-->D0104
      ON TF.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
     AND TF.SRC_CLASS_CODE = 'CD1372'
     AND TF.TAR_CLASS_CODE = 'D0104'
     AND TF.MOD_FLG = 'MDM'
    LEFT JOIN CODE_MAP TG --业务品种编号转码
     ON  TG.SRC_VALUE_CODE = B.STD_PROD_ID
     AND TG.SRC_CLASS_CODE = 'STD0002'
     AND TG.TAR_CLASS_CODE = 'T0001'
     AND TG.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                  FROM O_ICL_CMM_CLERK_INFO T
                 WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.TELLER_ID IS NOT NULL
                ) T18
        ON B.RGST_TELLER_ID = T18.TELLER_ID
       AND T18.RN = 1
      LEFT JOIN O_ICL_CMM_TELLER_INFO T19
        ON B.RGST_TELLER_ID = T19.TELLER_ID
       AND T19.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE  A.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --筛选记账成功的票据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
   V_STEP_DESC := '表内借据信息--汇总';
   V_STARTTIME := SYSDATE;

    INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD
  (
    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,CONT_ID                             --合同编号
    ,BILL_NO                             --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                             --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                             --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                 --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                             --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                     --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                     --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                       --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                         --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                         --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                             --逾期类型
    ,LOAN_USEAGE                         --贷款用途
    ,LVL5_CL                             --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                       --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                   --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                     --房地产贷款标志
    ,IALL_LOAN_FLG                       --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频率
    ,ASSET_TRAN_DT                       --资产转让日期
    ,EAST_FLG                            --EAST口径标识
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,OVD_INT_BAL                         --逾期利息金额
    ,LOAN_CRDT_LMT_TOT                   --单户授信额度
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --贴现、转贴现实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 add by hulj 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 add by hulj 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 add by hulj 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 add by hulj 20221123
    ,FIR_LON_DT                          --征信首贷日期 add by hulj 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 add by hulj 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 add by hulj 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 add by hulj 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 add by hulj 20221123
    ,CNCL_DT                             --核销日期
    ,FIXED_INT_MARK                      --利率是否固定（与利率类型不一致）
    ,DISCNT_CUST_ID                      --直贴人客户号
    ,SYS_IN_FLG
    )
    SELECT DISTINCT

    DATA_DT                              --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                            --借据编号
    ,CONT_ID                            --合同编号
    ,BILL_NO                            --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                            --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                            --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                    --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                    --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                      --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                        --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                        --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                            --逾期类型
    ,LOAN_USEAGE                        --贷款用途
    ,LVL5_CL                            --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                      --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                  --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                    --房地产贷款标志
    ,IALL_LOAN_FLG                      --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                      --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
    ,REPY_MODE                          --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                      --重组贷款标识
    ,ADJ_BAD_FLG                        --下调为不良标志
    ,ALDY_RCMM_FLG                      --曾重组标志
    ,CTON_PRD_LOAN_FLG                  --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                  --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                  --资产证券化产品编号
    ,EXEC_RATE                          --执行利率
    ,BASE_RATE                          --基准利率
    ,CNTR_GUA_LOAN_FLG                  --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                        --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                          --放款方式
    ,INT_CALC_MODE                      --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                        --信贷员工号
    ,ACCRD_INT                          --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                            --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                            --特别准备
    ,SPCL_LOAN_FLG                      --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                            --出资比例
    ,ETR_ACC                            --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                          --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                       --境内外标志
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频率
    ,ASSET_TRAN_DT                       --资产转让日期
    ,EAST_FLG                            --EAST口径标识
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,OVD_INT_BAL                         --逾期利息金额
    ,LOAN_CRDT_LMT_TOT                   --单户授信额度
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --贴现、转贴现实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 add by hulj 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 add by hulj 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 add by hulj 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 add by hulj 20221123
    ,FIR_LON_DT                          --征信首贷日期 add by hulj 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 add by hulj 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 add by hulj 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 add by hulj 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 add by hulj 20221123
    ,CNCL_DT                             --核销日期
    ,FIXED_INT_MARK                      --利率是否固定（与利率类型不一致）
    ,DISCNT_CUST_ID                      --直贴人客户号
    ,SYS_IN_FLG
    FROM
    M_LOAN_IN_DUBILL_INFO_TMP_BFD
    WHERE RCPT_ID IS NOT NULL;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM M_LOAN_IN_DUBILL_INFO_BFD T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID
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

  END ETL_INIT_M_LOAN_IN_DUBILL_INFO_BFD;
/

