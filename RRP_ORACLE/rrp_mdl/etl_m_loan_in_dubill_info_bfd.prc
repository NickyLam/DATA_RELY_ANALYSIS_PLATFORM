CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_IN_DUBILL_INFO_BFD(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
/**************************************************************************
  *  程序名称：ETL_M_LOAN_IN_DUBILL_INFO_BFD
  *  功能描述：表内借据信息-所有以个人客户和机构名义开展信贷业务时所签订的信贷业务借据信息（仅表内部分+委托贷款），不含信用卡业务。
  *  核销、转让如果余额不为0，接数时，处理为0
  *  创建日期：20221214
  *  开发人员：
  *  来源表：
  *  目标表：  M_LOAN_IN_DUBILL_INFO_BFD
  *  配置表：  CODE_MAP
  *  修改 ：   例：当传入参数为1号，跑的数为30号 仅特殊处理零售，联合网贷部分
  *         MW   20230522  取消减值结果表逻辑
  *      许晓滨  20230612  联合网贷实际终止日调整逻辑
  *        MW    20230711  新增内部结转标志，调整日志记录
  *        HULJ  20230728  新增福费廷需求6个字段
  *        LYH   20230925  网商贷债权直转 发放日期 取 原始发放日期
  *        LYH   20231012  增加 DISTR_DT 字段，取 网商贷债权直转 转入日期
  *        LYH   20240116  调整贷款原始到期日期，零售部分口径取展期前的原始到期日
  *        LYH   20240612  调整联合网贷 精准扶贫贷款标志 字段逻辑(与ETL_M_LOAN_IN_DUBILL_INFO逻辑保持一致)
  *        LIP   20240704  网商贷3.0调整网商贷部分的原始到期日，重组，展期等相关字段
  *        YJY   20250521  调整联合网贷借据号逻辑，取核心借据号字段；新增第三方借据编号
  *        YJY   20250725  回退联合网贷部分的借据号
  *        LYH   20251111  调整分期乐、微业贷3.0产品跑批日期
  *        LYH   20260127  增加账户变更类别代码ACCT_MODIF_CATE_CD字段   
  *        YJY   20260204  1）按信贷通知内容,201020100014、201020100024、201020100051、201020100052新增互联贷款业务标签，参考201020100062 饲料e贷-海大集团
                           2）零售部分的互联网贷款标识、循环贷标识和公共模型口径保持一致
  *        YJY   20260226  华兴好易贷（信用） 201010300040\华兴好易贷（经营-信用）201020100060判断是否线下核身为否的则为互联网
  *        LYH   20260309  增加重组贷款标志字段
  *        YJY   20260312  对公信贷部分新增字段：是否境外并购贷款、并购贷款类型、是否退役军人创办企业
  **********************************************************************/
AS
  -- 定义变量 --
  V_STEP        INTEGER := 0;             --处理步骤
  V_P_DATE      VARCHAR2(8);              --跑批数据日期
  V_YESTADAY    VARCHAR2(8);              --跑批数据日期上一天
  V_STARTTIME   DATE;                     --处理开始时间
  V_ENDTIME     DATE;                     --处理结束时间
  V_SQLCOUNT    INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC   VARCHAR2(200);            --任务名称
  V_PART_NAME   VARCHAR2(100);            --分区名
  V_TAB_NAME    VARCHAR2(100) := 'M_LOAN_IN_DUBILL_INFO_BFD'; --表名
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_LOAN_IN_DUBILL_INFO_BFD'; --程序名称
  V_SYSTEM      VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE);
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); --上日
  V_PART_NAME := 'PARTITION_'||V_YESTADAY;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD T WHERE T.DATA_DT = V_YESTADAY AND T.DATA_SRC IN ('零售贷款','联合网贷','对公信贷');
  COMMIT;
  --零售 联合网贷数据日期为昨日，重跑清数
  DELETE FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD T WHERE T.DATA_DT = V_P_DATE AND T.DATA_SRC IN ('票据贴现','票据转贴现');
  COMMIT;
  --票据贴现 票据转贴现数据日期为当日，重跑清数
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_LOAN_IN_DUBILL_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/ --暂未分区
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_YESTADAY,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  --EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 处理首贷日标志 --';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD';
  --加工客户的首笔借据及首次放款日期
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD
    (CUST_ID, RCPT_ID, LOAN_ACT_DSTR_DT)
  WITH TMP1 AS (
  SELECT /*+PARALLEL*/CUST_ID, DUBIL_ID AS RCPT_ID ,CASE WHEN FIR_DISTR_DT = DATE '0001-01-01' THEN NULL ELSE FIR_DISTR_DT END AS LOAN_ACT_DSTR_DT
    FROM RRP_MDL.ADD_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息静态表
   WHERE FIR_DISTR_DT <> DATE '0001-01-01'
     AND TRIM(CUST_ID) IS NOT NULL
   UNION ALL
  SELECT /*+PARALLEL*/ CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   UNION ALL
  SELECT /*+PARALLEL*/ CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT /*+PARALLEL*/ CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END  AS LOAN_ACT_DSTR_DT
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO_CLEAR
   UNION ALL
  SELECT /*+PARALLEL*/ CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')),
  TMP2 AS(
  SELECT T.CUST_ID,T.RCPT_ID,TO_CHAR(T.LOAN_ACT_DSTR_DT, 'YYYYMMDD') LOAN_ACT_DSTR_DT,
         ROW_NUMBER() OVER(PARTITION BY T.CUST_ID ORDER BY T.LOAN_ACT_DSTR_DT,T.RCPT_ID NULLS LAST) RN--20230130 XUXIAOBIN MODIFY
    FROM TMP1 T)
  SELECT T.CUST_ID, T.RCPT_ID, T.LOAN_ACT_DSTR_DT
    FROM TMP2 T
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总1 --';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD';
  COMMIT;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD
    (CUST_ACCT_ID             --账户编号
    ,CUST_ACCT_NAME           --账户户名
    ,ACCT_BELONG_ORG_ID       --账户所属机构
    ,ORG_ID1                  --账户所属机构映射报送机构
    ,FIN_INST_CODE            --银行机构代码
    ,FIN_LICS_NUM             --金融许可证号
    ,ORG_NAME                 --银行机构名称
    ,COUNTY_CD                --机构地区
    )
  SELECT  A.CUST_ACCT_ID             --账户编号
         ,A.CUST_ACCT_NAME           --账户户名
         ,NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) AS ACCT_BELONG_ORG_ID       --账户所属机构
         ,B.ORG_ID1                  --账户所属机构映射报送机构
         ,B.FIN_INST_CODE            --银行机构代码
         ,B.FIN_LICS_NUM             --金融许可证号
         ,B.ORG_NAME                 --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总2 --';
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD
    ( CUST_ACCT_ID             --账户编号
     ,CUST_ACCT_NAME          --账户户名
     ,ACCT_BELONG_ORG_ID       --账户所属机构
     ,ORG_ID1                  --账户所属机构映射报送机构
     ,FIN_INST_CODE            --银行机构代码
     ,FIN_LICS_NUM             --金融许可证号
     ,ORG_NAME                 --银行机构名称
     ,COUNTY_CD                 --机构地区
     )
  SELECT  A.MAIN_ACCT_ID AS CUST_ACCT_ID            --账户编号
         ,A.ACCT_NAME    AS CUST_ACCT_NAME          --账户户名
         ,TRIM(A.BELONG_ORG_ID) AS ACCT_BELONG_ORG_ID  --账户所属机构
         ,B.ORG_ID1                                 --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                           --银行机构代码
         ,B.FIN_LICS_NUM                            --金融许可证号
         ,B.ORG_NAME                 --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C--内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6; 
  V_STEP_DESC := '精准扶贫临时表数据处理-1';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TMP_BFD');
  EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP03_BFD');
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP03_BFD  --表内借据信息--精准扶贫按证件
    (CERT_NO      --01 证件号
    ,TPZT         --02 脱贫状态
    ,ACCT_DURAN   --03 扶贫名录期间
    ,QG_FLAG      --04 全国标志
    )
  SELECT CERT_NO      --01 证件号
        ,TPZT         --02 脱贫状态
        ,ACCT_DURAN   --03 扶贫名录期间
        ,QG_FLAG      --04 全国标志
    FROM (SELECT P1.PKHSFZH         AS CERT_NO     --01 证件号
                ,'已脱贫'           AS TPZT        --02 脱贫状态
                ,'2021-04'          AS ACCT_DURAN  --03扶贫名录期间
                ,'1'                AS QG_FLAG     --04 全国标志
            FROM RRP_MDL.ADD_JZFP_LIST_CN_202104 P1  --精准扶贫全国名录  --MODIFY BY LIUYU 20211210 发放日为20210401 之后按此名录为准
           WHERE P1.TPZT = '脱贫'
           GROUP BY P1.PKHSFZH   --ADD BY LIUYU 20220110 202104名单全部是脱贫，默认已脱贫
         );

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP04_BFD');
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04_BFD --表内借据信息--精准扶贫按客户
    (CUST_ID     --01 客户号
    ,CERT_NO     --02 证件号
    ,TPZT        --03 脱贫状态
    ,ACCT_DURAN  --04 扶贫名录期间
    )
  SELECT P1.CUST_ID      --01 客户号
        ,P1.CERT_NO      --02 证件号
        ,P2.TPZT         --03 脱贫状态
        ,P2.ACCT_DURAN   --04 扶贫名录期间
    FROM RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO P1   --个人客户基本信息表
   INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP03_BFD P2
      ON P1.CERT_NO = P2.CERT_NO
   WHERE P1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 7; 
  V_STEP_DESC := '表内借据信息--对公信贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP_BFD
    (DATA_DT                             --数据日期
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
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频度
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号
    ,OPER_TELLER_ID                      --经办柜员编号
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期
    ,RENEW_EXP_DAY                       --展期到期日期
    ,FIR_LON_DT                          --征信首贷日期
    ,LOAN_MGR_ID                         --借据主办客户经理号
    ,LOAN_TELLER_ID                      --借据主办柜员号
    ,LOAN_MGR_NAME                       --借据主办客户经理名称
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构
    ,CNCL_DT                             --核销日期
    ,FIXED_INT_MARK                      --利率是否固定
    ,LC_BENEFC                           --信用证受益人 add by hulj20230728
    ,FIX_INT_RAT_FLG                     --固定利率标志 add by hulj20230728
    ,LC_ISSUER                           --信用证开证人 add by hulj20230728
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
	  ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
	  ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    )
  WITH CORP_LOAN_REPAY_PLAN AS (
        SELECT N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT,MAX(N.VALUE_DT) VALUE_DT,
               SUM(CASE WHEN N.OVDUE_FLG = '1' THEN 1 ELSE 0 END) OVDUE_FLG --N.OVDUE_FLG = '1' --逾期标志为是 0为否
               ,CASE WHEN MIN(N.REPAY_FLG)='0' THEN 0 ELSE 1 END  REPAY_FLG --N.REPAY_FLG = '0'  --未偿还
          FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN N
         WHERE N.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
         GROUP BY N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT),
  CORP_LOAN_REPAY_PLAN_1 AS(
        SELECT  N.DUBIL_ID
               ,MAX(N.TOT_PERDS) AS TOT_PERDS
               ,MAX(N.REPAY_PERDS) AS REPAY_PERDS
               ,MAX(CASE WHEN N.VALUE_DT > TO_DATE(V_YESTADAY,'YYYYMMDD') THEN 0 ELSE N.REPAY_PERDS END) AS CURR_PERDS
               ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                          AND N.REPAYBL_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
                          AND N.REPAY_FLG = 0 --未偿还
                         THEN 1 ELSE 0 END) AS LXQKQS --连续欠款期数
               ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                          AND N.REPAYBL_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
                          AND N.REPAY_FLG = 0 --未偿还
                        THEN 1 ELSE 0 END) AS LJQKQS --累计欠款期数
          FROM CORP_LOAN_REPAY_PLAN N --对公贷款还款计划
         WHERE N.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
         GROUP BY N.DUBIL_ID), --MODIFY BY HULJ20221107  连续欠款期数,累计欠款期数
  DK_RZXX AS (
        SELECT T.BILL_NUM,T.DRAWER_CUST_ID,T.RECVER_NAME,T.RECVER_ACCT_NUM,T.RECVER_OPEN_BANK_NO,T.RECVER_OPEN_BANK_NAME,
               ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY
                            CASE WHEN TRIM(T.DRAWER_ACCT_NUM) = '0' THEN NULL ELSE TRIM(T.DRAWER_ACCT_NUM) END NULLS LAST) RN
          FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T
         WHERE T.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
         UNION ALL
        SELECT T1.BILL_NUM,NULL,T1.RECVER_NAME,T1.RECVER_ACCT_NUM,T1.RECVER_OPEN_BANK_NUM,
               T1.RECVER_OPEN_BANK_NAME,ROW_NUMBER() OVER(PARTITION BY T1.BILL_NUM ORDER BY BILL_ID) RN
          FROM RRP_MDL.ADD_AGT_BILL_INFO_HIS T1)--取历史票据
  SELECT V_YESTADAY                                                       AS DATA_DT                     --数据日期
        ,A.LP_ID                                                          AS LGL_REP_ID                  --法人编号
        ,B.ACCT_ID                                                        AS ACC_ID                      --账户编号
        ,A.DUBIL_ID                                                       AS RCPT_ID                     --借据编号
        ,E.CONT_ID                                                        AS CONT_ID                     --合同编号
        ,NVL(TRIM(A.BILL_NUM),TRIM(L1.BILL_NUM))                          AS BILL_NO                     --票据号码
        ,NULL                                                             AS COOP_AGRT_ID                --合作协议编号
        ,B.CUST_ID                                                        AS CUST_ID                     --客户编号
        ,B.ACCT_INSTIT_ID                                                 AS ORG_ID                      --机构编号
        ,B.SUBJ_ID                                                        AS SUBJ_ID                     --科目编号
        ,A.STD_PROD_ID                                                    AS LOAN_STD_PROD_ID            --贷款标准产品编号
        ,C.PROD_NAME                                                      AS LOAN_STD_PROD_NM            --贷款标准产品名称
        ,C.PROD_ID                                                        AS LOAN_PROD_ID                --贷款产品编号
        ,C.PROD_NAME                                                      AS LOAN_PROD_NM                --贷款产品名称
        ,NVL(TA.TAR_VALUE_CODE,A.STD_PROD_ID)                             AS LOAN_BIZ_TYP                --贷款业务类型
        ,A.CURR_CD                                                        AS CUR                         --币种
        ,B.DUBIL_AMT                                                      AS LOAN_AMT                    --借款金额
        ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              WHEN B.WRT_OFF_FLG <> '1' 
              THEN CASE WHEN B.SUBJ_ID LIKE '1313%'
                        THEN NVL(B.OVDUE_PRIC_BAL, 0) + NVL(B.IDLE_PRIC, 0) + NVL(B.BAD_DEBT_PRIC, 0)
                        ELSE NVL(B.PRIC_BAL, 0) - NVL(B.WRT_OFF_PRIC, 0)
                    END
          END                                                             AS LOAN_BAL                    --贷款余额
        ,B.TRADE_FIN_INT_ADJ                                              AS INT_ADJ                     --利息调整        
        ,NVL(AA.N_PV_VARIATION, 0)                                        AS FAIR_VAL_CHG                --公允价值变动
        ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              ELSE B.OVDUE_PRIC + B.IDLE_PRIC + B.BAD_DEBT_PRIC
          END                                                             AS OVD_PRIN_BAL                --逾期本金余额
        ,B.IN_BS_OVER_INT_BAL                                             AS IN_INT_OVD_BAL              --表内欠息余额
        ,B.OFF_BS_OVER_INT_BAL                                            AS OUT_INT_OVD_BAL             --表外欠息余额
        ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(B.DISTR_DT,'YYYYMMDD')
          END                                                             AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
        ,CASE WHEN B.RENEW_FLG = '1' THEN TO_CHAR(A.EXEC_EXP_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.APOT_EXP_DT,'YYYYMMDD')
          END                                                             AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
        ,TO_CHAR(B.EXP_DT,'YYYYMMDD')                                     AS LOAN_ACT_EXP_DT             --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               AND D.FIR_WRT_OFF_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
              THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')
              WHEN TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               AND B.ASSET_TRAN_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
              THEN TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD')
              WHEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')
              ELSE '29991231'
          END                                                             AS ACT_END_DT                  --实际终止日期
        ,TO_CHAR(B.LAST_REPAY_DT,'YYYYMMDD')                              AS LAST_REPY_DT                --上次还款日期
        ,M1.LAST_REPY_AMT                                                 AS LAST_REPY_AMT               --上次还款金额
        ,CASE WHEN TO_CHAR(B.VALUE_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(B.VALUE_DT,'YYYYMMDD')
          END                                                             AS VAL_DT                      --起息日期
        ,CASE WHEN TO_CHAR(B.OPEN_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(B.OPEN_ACCT_DT,'YYYYMMDD')
          END                                                             AS OPEN_ACC_DT                 --开户日期
        ,CASE WHEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')
          END                                                             AS CNL_ACC_DT                  --销户日期
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(B.ETL_DT - B.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                                             AS PRIN_OVD_DT                 --本金逾期日期
        ,CASE WHEN B.INT_OVDUE_DAYS >0
              THEN TO_CHAR(B.ETL_DT - B.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                                             AS INT_OVD_DT                  --利息逾期日期
        ,GREATEST(B.PRIC_OVDUE_DAYS,B.INT_OVDUE_DAYS)                     AS OVD_DAYS                    --逾期天数
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN B.PRIC_OVDUE_DAYS = 0 AND B.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                                             AS OVD_TYP                     --逾期类型
        ,CASE WHEN TRIM(E.LOAN_USAGE_DESCB) IS NOT NULL THEN E.LOAN_USAGE_DESCB
              WHEN A.STD_PROD_ID IN ('203010500001','402020100003') THEN '企业日常经营周转' --法透、同业法透
              WHEN A.STD_PROD_ID LIKE ('203040%') THEN '其他-垫款'
          END                                                             AS LOAN_USEAGE                 --贷款用途
        ,TB.TAR_VALUE_CODE                                                AS LVL5_CL                     --五级分类
        ,TTM.TAR_VALUE_CODE                                               AS GUA_MODE                    --担保方式
        ,CASE WHEN G.RG_CD = '810000' THEN 'HKG'
              WHEN G.RG_CD = '820000' THEN 'MAC'
              WHEN G.RG_CD = '710000' THEN 'TWN'
              WHEN NVL(TRIM(G.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111') THEN TRIM(G.INVTOR_CTY_CD)
              WHEN TRIM(G.RG_CD) NOT IN ('1000','999999','000000') THEN TRIM(G.RG_CD)
              WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(F.DIST_CD)
          END                                                             AS LOAN_DIR_RGN               --贷款投向地区 modify by hulj 20221108补充客户的地区代码，身份证类型判断时加上临时身份证
        ,A.DIR_INDUS_CD                                                   AS LOAN_DIR_IDY               --贷款投向行业
        ,CASE WHEN B.SUBJ_ID = '13030104' THEN 'Y' ELSE 'N' END           AS SYN_LOAN_FLG               --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN (/*'203010300001',*/'203010200003','203010200004','203010200005','203010200006')--('1050010', '1030010', '1030020','1050020')
              THEN 'Y'
              ELSE 'N'
          END                                                             AS PROJ_LOAN_FLG              --项目贷款标志--modify by hulj 剔除经营性物业贷款,并购贷款
        ,NULL                                                             AS IDY_STRU_ADJ_TYP           --产业结构调整类型
        ,NULL                                                             AS IDY_TRNST_UPG_FLG          --工业转型升级标志
        ,NULL                                                             AS STRTG_EMER_IDY_TYP         --战略新兴产业类型
        ,'N'                                                              AS BANK_TAX_COOP_LOAN_FLG     --银税合作贷款标志
        ,CASE WHEN E.AGCLT_FLG = '1' THEN 'Y' ELSE 'N' END                AS AGR_REL_LOAN_FLG            --涉农贷款标志
        ,CASE WHEN E.ESTATE_LOAN_TYPE_CD IS NULL THEN 'N' ELSE 'Y' END    AS RL_EST_LOAN_FLG             --房地产贷款标志
        ,NULL                                                             AS IALL_LOAN_FLG               --投贷联动贷款标志
        ,NULL                                                             AS OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
        ,NULL                                                             AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
        ,NULL                                                             AS ENT_GUA_LOAN_TYP            --创业担保贷款类型
        ,NULL                                                             AS CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
        ,CASE WHEN B.GOVER_FIN_PLAT_LOAN_FLG = '1' THEN 'Y' ELSE 'N' END  AS LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
        ,NULL                                                             AS LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                             AS FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                             AS POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
        ,TJ.TAR_VALUE_CODE                                                AS LOAN_HDL_CHAN               --贷款办理渠道
        ,'N'                                                              AS NET_LOAN_FLG                --互联网贷款标志
        ,'0'                                                              AS NET_LOAN_PROD_TYP           --网贷产品类别
        ,NULL                                                             AS CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
        ,CASE WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '1M' THEN '01' --按月
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '3M' THEN '02' --按季
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '6M' THEN '03' --按半年
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '12M' THEN '04' --按年
              ELSE TC.TAR_VALUE_CODE
          END                                                             AS REPY_MODE                   --还款方式
        /*,TD.TAR_VALUE_CODE                                                AS LOAN_FRM                    --贷款形式  --20221121 严希婧反馈该字段取值有误，参考east5.0口径修改 LHQ*/
       ,CASE WHEN A.DUBIL_ID IN ('2019102813808005','2019102813808006','2019102813808007','20230728000167001','20221215023001', '20221216122340001', '20221208122325001', '20221211001001', '20221216122341001') 
              THEN '04'  -- 重组
              WHEN CZ1.DUEBILLSERIALNO IS NOT NULL THEN '9906' -- 9906-其他-调整还款计划  --ADD BY YJY 20260319增加判断对公信贷重组贷款的逻辑，信贷系统未对重组类型-调整还款计划的合同进行改造
              WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('VAL') --续期 --UPDATE BY YJY 20260311 
              THEN '05' --05-无还本续贷  
              WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('REP') --调整还款计划 --UPDATE BY YJY 20260311 
              THEN '9906' --9906-其他-调整还款计划  --MOD BY YJY 20251226 按照业务王玲的要求，在业务合同层里发生类型是“重组”的才抽取出来。重组方式“续期”金数归“01”续贷，“调整还款计划”归”03“其他
              WHEN WHBXD.DUBIL_ID IS NOT NULL
              THEN '05'  --05-无还本续贷         --MOD BY YJY 20250103 无还本续贷通过借据取信贷系统打的标签，其他仍通过合同的贷款形式映射码值             
              ELSE TD.TAR_VALUE_CODE 
          END                                                            AS LOAN_FRM                    --贷款形式
        /*,CASE WHEN E.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202')--0201 展期 0204 债务重组 0202 借新还旧
              THEN 'Y'
              ELSE 'N'
          END                                                             AS RCMM_LOAN_FLG               --重组贷款标识*/
        ,CASE WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('VAL','REP') --VAL续期、REP调整还款计划 --UPDATE BY YJY 20260311 
              THEN 'Y' ----MOD BY YJY 20251226 按照业务王玲的要求，在业务合同层里发生类型是“重组”的才抽取出来。重组方式“续期”金数归“01”续贷，“调整还款计划”归”03“其他
              WHEN CZ1.DUEBILLSERIALNO IS NOT NULL THEN 'Y'
              /*WHEN CZ.OBJECTNO  IS NOT NULL
              THEN 'Y' --MOD BY YJY 20250303 优先关联信贷系统贷款重组关联表的借据
              WHEN E.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202')
              THEN 'Y' --0201展期 0204债务重组 0202借新还旧 */ --MOD BY YJY 20251226 王玲确认因信贷系统优化了发生额类型，这部分取数逻辑不准确
              ELSE 'N'
         END                                                              AS RCMM_LOAN_FLG               --重组贷款标识
        ,NULL                                                             AS ADJ_BAD_FLG                 --下调为不良标志
        ,NULL                                                             AS ALDY_RCMM_FLG               --曾重组标志
        ,NULL                                                             AS CTON_PRD_LOAN_FLG           --缩期贷款标志
        ,NULL                                                             AS CASH_TRF_FLG                --现转标志
        ,DECODE(H1.DUBIL_ID, NULL,'N','Y')                                AS FST_LOAN_FLG                --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.DUBIL_ID, NULL,'N','Y')                                AS FIRST_LOAN_FLG              --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                                             AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
        ,CASE WHEN SUBSTR(G.GREEN_CRDT_CLS_CD,1,1) IN ('A','B','C','D','E','F')
              AND A.STD_PROD_ID NOT IN ('203020700001','203020700002','602030100001','602030100002','602060200001','203020700002','203020700001')
              THEN 'Y' --排除委托贷款 --MODIFY BY HULJ排除203020700002 出口代付  203020700001 进口代付
              ELSE 'N'
          END                                                             AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
        ,NULL                                                             AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
        ,TXLX.TAR_VALUE_CODE                                              AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式20220921 XUXIAOBIN MODIFY
        ,NULL                                                             AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志 MODIFY BY MW 20221229 对公无精准扶贫
        ,CASE WHEN B.NEXT_INT_RAT_ADJ_DT = DATE '2999-12-31' THEN NULL
              ELSE TO_CHAR(B.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD')
          END                                                             AS RATE_RE_PRC_DT              --利率重新定价日期
        ,CASE WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01'---按日
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02'--按周
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03'---按月
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04'--按季
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05'--按半年
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06'--按年
              ELSE '99'
          END                                                             AS RATE_FLT_FREQ               --利率浮动频率
        ,TTK.TAR_VALUE_CODE                                               AS RATE_TYP                    --利率类型
        ,NULL                                                             AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
        ,B.EXEC_INT_RAT                                                   AS EXEC_RATE                   --执行利率
        ,B.BASE_RAT                                                       AS BASE_RATE                   --基准利率
        ,NULL                                                             AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
        ,E.INT_RAT_FLO_VAL                                                AS RATE_FLT_VAL                --利率浮动值
        ,CASE WHEN B.INT_RAT_CURVE_TYPE_CD IN ('241','242') THEN 'TR07'
              ELSE TI.TAR_VALUE_CODE
          END                                                             AS PRC_BASE_TYP                --定价基准类型
        ,CASE WHEN (A.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') OR B.TOT_PERDS = 0) THEN B.CURR_ISSUE_PERDS
              WHEN NVL(B.TOT_PERDS,0) > 0 THEN NVL(B.TOT_PERDS,0)
              ELSE B.TOT_PERDS
          END                                                             AS TOT_PRD_NUM                 --总期数
        ,CASE WHEN (B.CURR_ISSUE_PERDS > B.TOT_PERDS AND B.TOT_PERDS <> 0) THEN B.TOT_PERDS
              WHEN NVL(B.CURR_ISSUE_PERDS,0) > 0 THEN NVL(B.CURR_ISSUE_PERDS,0)
              WHEN NVL(I.REPAY_PERDS,0) >= NVL(I.TOT_PERDS,0) THEN NVL(I.TOT_PERDS,0)
              ELSE NVL(I.REPAY_PERDS,0)/*+1*/
          END                                                             AS CURR_PRD                   --当前期数
        ,NVL(I.LJQKQS,0)                                                  AS CUM_DEBT_PRD_NUM           --累计欠款期数
        ,NVL(I.LXQKQS,0)                                                  AS CNU_DEBT_PRD_NUM           --连续欠款期数
        ,NVL(B.RENEW_CNT,0)                                               AS EXTN_CNT                   --展期次数
        ,CASE WHEN A.MONEY_USE_TYPE_CD = '2' THEN '01'
              ELSE NVL(TE.TAR_VALUE_CODE,'01')
          END                                                             AS DSBR_MODE                  --放款方式
        ,NVL(TF.TAR_VALUE_CODE,'9901')                                    AS INT_CALC_MODE              --计息方式
        ,A.MARGIN_RATIO                                                   AS MRGN_PCT                   --保证金比例
        ,A.MARGIN_CURR_CD                                                 AS MRGN_CUR                   --保证金币种
        ,A.MARGIN_AMT                                                     AS MRGN                       --保证金
        ,A.MARGIN_ACCT_NUM                                                AS MRGN_ACC                   --保证金账号
        ,CASE WHEN TRIM(B.CUST_MGR_ID) IS NOT NULL AND TRIM(B.CUST_MGR_ID) <> 'M0001' THEN TRIM(B.CUST_MGR_ID)
              WHEN TRIM(A.OPER_TELLER_ID) IS NOT NULL THEN TRIM(A.OPER_TELLER_ID)
              WHEN TRIM(E.MGMT_TELLER_ID) IS NOT NULL THEN TRIM(E.MGMT_TELLER_ID)
              WHEN TRIM(E.RGST_TELLER_ID) IS NOT NULL THEN TRIM(E.RGST_TELLER_ID)
          END                                                             AS LOAN_OFR_NO                --信贷员工号 --modify by hulj 20221107
        ,A.NEXT_TERM_REPAY_INT_AMT                                        AS ACCRD_INT                  --应计利息
        ,NULL                                                             AS PRO_IMPT                   --减值准备
        ,NULL                                                             AS COM_PRO                    --一般准备
        ,NULL                                                             AS SPCL_PRO                   --专项准备
        ,NULL                                                             AS ESP_PRO                    --特别准备
        ,NULL                                                             AS SPCL_LOAN_FLG              --专项贷款标志
        ,A.RELA_DUBIL_ID                                                  AS ORIG_RCPT_NO               --原借据号
        ,CASE WHEN A.STD_PROD_ID IN ('203010400001','203010400002') AND NVL(E1.SYN_LOAN_TOT_AMT,0) <> 0
              THEN (A.DUBIL_AMT/E1.SYN_LOAN_TOT_AMT)*100
          END                                                             AS FND_PCT                    --出资比例
        ,CASE WHEN B.SUBJ_ID LIKE '131301%' THEN TRIM(TZ.RECVER_ACCT_NUM) --承兑垫款
              WHEN TRIM(B.LOAN_DISTR_ACCT_NUM) IS NOT NULL THEN TRIM(B.LOAN_DISTR_ACCT_NUM)
          END                                                             AS ETR_ACC                    --入账账号 --modify by hulj
        ,CASE WHEN B.SUBJ_ID LIKE '131301%' THEN TRIM(TZ.RECVER_NAME) --承兑垫款
              WHEN TRIM(JJ.CUST_ACCT_NAME) IS NOT NULL THEN TRIM(JJ.CUST_ACCT_NAME)
              WHEN TRIM(A.RECVBL_ACCT_NAME) IS NOT NULL THEN TRIM(A.RECVBL_ACCT_NAME)
          END                                                             AS ETR_ACC_NM                 --入账账号户名
        ,CASE WHEN B.SUBJ_ID LIKE '13130101%' THEN TRIM(TZ.RECVER_OPEN_BANK_NAME) --承兑垫款
              WHEN TRIM(JJ.ORG_NAME) IS NOT NULL THEN TRIM(JJ.ORG_NAME)
              WHEN TRIM(A.RECVBL_BANK_NAME) IS NOT NULL THEN TRIM(A.RECVBL_BANK_NAME)
          END                                                             AS LOAN_ETR_ACC_OPEN_BANK_NM  --贷款入账账号开户行名称/*HULJ20221008*/
        ,B.LOAN_REPAY_NUM                                                 AS REPY_ACC                   --还款账号
        ,J.ORG_NAME                                                       AS LOAN_REPY_ACC_OPEN_BANK_NM --贷款还款账号开户行名称
        ,CASE WHEN B.ASSET_TRAN_STATUS_CD = '121' THEN 'C0202'
              ELSE TG.TAR_VALUE_CODE
          END                                                             AS RCPT_STAT                  --借据状态
        ,CASE WHEN TH.TAR_VALUE_CODE IS NOT NULL THEN TH.TAR_VALUE_CODE
              WHEN B.LOAN_ACCT_STATUS_CD = '0' THEN '02'
              WHEN B.LOAN_ACCT_STATUS_CD = '1' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '2' THEN '02'
              WHEN B.LOAN_ACCT_STATUS_CD = '3' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '4' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '5' THEN '02'
          END                                                             AS ACC_STAT                    --账户状态
        ,CASE WHEN E.CIRCL_FLG = '0' THEN 'N' ELSE 'Y' END                AS REV_LOAN_FLG                --循环贷贷款标志
        ,NULL                                                             AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
        ,B.NEXT_REPAY_INT_AMT                                             AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
        ,CASE WHEN G.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
              WHEN G.DOM_OVERS_FLG = '0' THEN 'N'
              ELSE 'Z'
          END                                                             AS BIO_LOAN_FLG                --境内外标志--MODIFY BY MW 20221103 ,1-境内，0境外
        ,NULL                                                             AS DEPT_LINE                   --部门条线
        ,'对公信贷'                                                       AS DATA_SRC                    --数据来源
        ,E.LMT_CONT_ID                                                    AS LMT_CONT_ID                 --额度合同编号
        ,B.REPAY_WAY_CD                                                   AS GXH_PAY_TYPE                --还款方式
        ,B.REPAY_PED_CORP_CD                                              AS GXH_PAY_FREQ                --还款频率
        ,TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD')                              AS ASSET_TRAN_DT               --资产转让日期
        ,CASE WHEN A.OVERS_LOAN_FLG = '1' THEN 'N'--境外
              WHEN A.OVERS_LOAN_FLG = '0' THEN 'Y'--境内
              ELSE 'Z' --未知
          END                                                             AS LOAN_DIR_BIO_FLG            --贷款投向境内外标识
        ,CASE WHEN A.REFAC_LOAN_STATUS_CD = '1' THEN 'Y' ELSE 'N' END     AS REFAC_FLG                   --支小再贷款标识
        ,CASE WHEN A.STD_PROD_ID IN('203020300002','203030600002','203020300001','203030600001') --福费廷
              THEN B.DUBIL_AMT * (1-NVL(INT_SUB_RATIO,0))  --贴息后的金额
          END                                                             AS BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
        ,B.LOAN_MODAL_CD                                                  AS LOAN_MODAL_CD               --贷款形态代码
        ,A.OPER_ORG_ID                                                    AS OPER_ORG_ID                 --经办机构编号 ADD BY HULJ 20221122
        ,A.OPER_TELLER_ID                                                 AS OPER_TELLER_ID              --经办柜员编号 ADD BY HULJ 20221122
        ,H2.LOAN_ACT_DSTR_DT                                              AS LOAN_ACT_FIRST_DT           --本行首贷日期 ADD BY HULJ 20221122
        ,TO_CHAR(B.RENEW_EXP_DAY,'YYYYMMDD')                              AS RENEW_EXP_DAY               --展期到期日期 ADD BY HULJ 20221122
        ,TO_CHAR(G.FIR_LON_DT,'YYYYMMDD')                                 AS FIR_LON_DT                  --征信首贷日期 ADD BY HULJ 20221123
        ,A.RGST_TELLER_ID                                                 AS LOAN_MGR_ID                 --借据主办客户经理号 ADD BY HULJ 20221123
        ,A.RGST_TELLER_ID                                                 AS LOAN_TELLER_ID              --借据主办柜员号 ADD BY HULJ 20221123
        ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)                             AS LOAN_MGR_NAME               --借据主办客户经理名称 ADD BY HULJ 20221123
        ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)                         AS LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构 ADD BY HULJ 20221123
        ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')                             AS CNCL_DT                     --核销日期
        ,A.INT_RAT_ADJ_WAY_CD                                             AS FIXED_INT_MARK              --利率是否固定
        ,A8.LC_BENEFC                                                     AS LC_BENEFC                   --信用证受益人 add by hulj 20230728
        ,A8.FIX_INT_RAT_FLG                                               AS FIX_INT_RAT_FLG             --固定利率标志 add by hulj 20230728
        ,A8.LC_ISSUER                                                     AS LC_ISSUER                   --信用证开证人 add by hulj 20230728
        ,CASE WHEN BG.CONT_ID IS NOT NULL 
               AND BG.TAGID = '2026031090000004' 
			         AND BG.TAGVALUE = '1' 
		          THEN 'Y'
			        ELSE 'N'
		      END                                                             AS SFJWBGDK                   --是否境外并购贷款  ADD BY YJY 20260312
	      ,CASE WHEN BG.CONT_ID IS NOT NULL 
               AND BG.TAGID = '2026031090000005' 
			        THEN BG.TAGVALUE  --10-控制型并购贷款 20-参股型并购贷款
		      END                                                             AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
	      ,CASE WHEN JR.CUST_ID IS NOT NULL 
               AND JR.TAGVALUE = '1'  
		          THEN 'Y'
			        ELSE 'N'
		      END                                                             AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息表
      ON B.DUBIL_NUM = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息表
      ON C.PROD_ID = A.STD_PROD_ID
     AND C.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息
      ON D.DUBIL_ID = A.DUBIL_ID
     AND D.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
      ON E.CONT_ID = A.CONT_ID
     AND E.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E1 --对公贷款合同信息
      ON E1.CONT_ID = E.LMT_CONT_ID
     AND E1.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
      ON T3.DUBIL_ID = A.DUBIL_ID
     AND T3.START_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H A8 --贷款出账对公贷款附属信息历史add by hulj20230728
      ON A8.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND A8.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A8.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DUBIL_ID,REPAY_DT
                      ,SUM(CURRT_REPAY_PRIC+CURRT_REPAY_INT+CURRT_REPAY_PNLT+CURRT_REPAY_COMP_INT+CURRT_REPAY_FEE) AS LAST_REPY_AMT
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL --对公贷款交易明细（取上次交易金额）
                GROUP BY DUBIL_ID,REPAY_DT) M1
      ON M1.DUBIL_ID = A.DUBIL_ID
     AND M1.REPAY_DT = B.LAST_REPAY_DT
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD J --表内借据信息表临时表02
      ON J.CUST_ACCT_ID = B.LOAN_REPAY_NUM
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02_BFD JJ --表内借据信息表临时表02
      ON JJ.CUST_ACCT_ID = B.LOAN_DISTR_ACCT_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO L1 --对公贷款借据信息表
      ON L1.DUBIL_ID = A.RELA_DUBIL_ID
     AND L1.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN DK_RZXX TZ --取承兑垫款的入账账号--票据的出票人
      ON TZ.BILL_NUM = NVL(TRIM(A.BILL_NUM),TRIM(L1.BILL_NUM))
     AND TZ.RN = 1
    LEFT JOIN RRP_MDL.CODE_MAP TA --码值映射表(贷款业务类别)
      ON TA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TA.SRC_CLASS_CODE = 'STD0002'
     AND TA.TAR_CLASS_CODE = 'T0001'
     AND TA.MOD_FLG = 'MDM'  --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TB --码值映射表(贷款五级分类)
      ON TB.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'  --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TC --码值映射表(还款方式)
      ON TC.SRC_VALUE_CODE = B.INT_SET_WAY_CD
     AND TC.SRC_CLASS_CODE = 'CD2778'
     AND TC.TAR_CLASS_CODE = 'D0103'
     AND TC.MOD_FLG = 'MDM'  --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TD --码值映射表(贷款形式)
      ON TD.SRC_VALUE_CODE = A.LOAN_HAPP_TYPE_CD
     AND TD.SRC_CLASS_CODE = 'CD1364'
     AND TD.TAR_CLASS_CODE = 'D0008'
     AND TD.MOD_FLG = 'MDM'   --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TE --码值映射表(放款形式)
      ON TE.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
     AND TE.SRC_CLASS_CODE = 'CD1372'
     AND TE.TAR_CLASS_CODE = 'D0104'
     AND TE.MOD_FLG = 'MDM'   --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TF --码值映射表(计息形式)
      ON TF.SRC_VALUE_CODE = B.INT_SET_WAY_CD
     AND TF.SRC_CLASS_CODE = 'CD2778'
     AND TF.TAR_CLASS_CODE = 'D0061'
     AND TF.MOD_FLG = 'MDM'    --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TG --码值映射表(借据状态)
      ON TG.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
     AND TG.SRC_CLASS_CODE = 'CD2554' --MODIFY BY XIEYUGENG 20221011 数仓码值变化 CD2651->CD2554
     AND TG.TAR_CLASS_CODE = 'D0007'
     AND TG.MOD_FLG = 'MDM'    --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TH --码值映射表(账户状态)
      ON TH.SRC_VALUE_CODE = B.LOAN_ACCT_STATUS_CD
     AND TH.SRC_CLASS_CODE = 'CD2554'
     AND TH.TAR_CLASS_CODE = 'Z0018'
     AND TH.MOD_FLG = 'MDM'    --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TI --码值映射表(利率种类转码)
      ON TI.SRC_VALUE_CODE = B.INT_RAT_CURVE_TYPE_CD
     AND TI.SRC_CLASS_CODE = 'CD1010'
     AND TI.TAR_CLASS_CODE = 'Z0015'
     AND TI.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTK --码值映射表(利率类型转码)
      ON TTK.SRC_VALUE_CODE = B.INT_RAT_FLOAT_WAY_CD
     AND TTK.SRC_CLASS_CODE = 'CD1016'
     AND TTK.TAR_CLASS_CODE = 'Z0007'
     AND TTK.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TJ --码值映射表(渠道转码)
      ON TJ.SRC_VALUE_CODE = E.TRAST_CHN_CD
     AND TJ.SRC_CLASS_CODE = 'CD2366'
     AND TJ.TAR_CLASS_CODE = 'Z0014'
     AND TJ.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTL --码值映射表(利率调整频率)
      ON TTL.SRC_VALUE_CODE = B.INT_RAT_ADJ_PED_CORP_CD
     AND TTL.SRC_CLASS_CODE = 'CD1041'
     AND TTL.TAR_CLASS_CODE = 'D0105'
     AND TTL.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTM --码值映射表(担保方式转码)
      ON TTM.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TTM.SRC_CLASS_CODE = 'CD2656'
     AND TTM.TAR_CLASS_CODE = 'D0002'
     AND TTM.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TXLX --贴息贷款类型 20220921 XUXIAOBIN MODIFY
      ON TXLX.SRC_VALUE_CODE = E.LOAN_FIN_SUPT_WAY_CD
     AND TXLX.SRC_CLASS_CODE = 'D0016'--贴息贷款类型
     AND TXLX.TAR_CLASS_CODE = 'D0016'
     AND TXLX.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE AA --估值报告表
      ON AA.V_TRADE_NO = A.DUBIL_ID
     AND AA.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = A.CUST_ID
     AND F.PHYS_ADDR_TYPE_CD = '001001'
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.START_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息
      ON G.CUST_ID = A.CUST_ID
     AND G.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN CORP_LOAN_REPAY_PLAN_1 I --对公贷款还款计划
      ON I.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN (SELECT DUBIL_ID
                 FROM (SELECT ROW_NUMBER() OVER(PARTITION BY B.CUST_ID ORDER BY B.DISTR_DT,B.DUBIL_ID ASC) AS RN,B.DUBIL_ID
                         FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B
                        WHERE B.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD'))
                WHERE RN = 1) H1--取是否首贷标志 ADD BY 20220824 XUXIAOBIN
      ON A.DUBIL_ID = H1.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD H2
      ON H2.RCPT_ID = A.DUBIL_ID --取是否首贷日期  MOD BY HULJ20221122
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T18 --行员信息表 ADD BY HULJ20221123
      ON T18.CLERK_ID = A.RGST_TELLER_ID
     AND T18.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
      ON T19.TELLER_ID = A.RGST_TELLER_ID
     AND T19.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')   --ADD BY HULJ20221123
    --MOD BY YJY 20250103 获取信贷系统无还本续贷为“是”的借据
   LEFT JOIN (SELECT A.OBJECTNO AS DUBIL_ID  --业务流水号
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '60' --标签层级
                 AND A.TAGID = '2024120900000002' --标签编号：是否无还本续贷
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) WHBXD 
     ON WHBXD.DUBIL_ID = A.DUBIL_ID  
   --ADD BY YJY 20260311 取重组贷款标识
   LEFT JOIN ( SELECT BP.SERIALNO          AS SERIALNO -- 续期出账
                     ,BE.RELATIVEDUEBILLNO AS RELATIVEDUEBILLNO -- 借据号
                     ,BE.EXTENDEFFECTDATE  AS EXTENDEFFECTDATE -- 展期生效日
                     ,BP.RENEWALTYPE       AS RENEWALTYPE --重组类型
                 FROM RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT BP -- 出账信息表出账信息表
                 LEFT JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_EXTENSION BE -- 展期信息表展期信息表
                   ON BE.PUTOUTNO = BP.SERIALNO
                  AND BE.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BE.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO EI--对公账户信息表
                   ON EI.DUBIL_NUM = BE.RELATIVEDUEBILLNO
                  AND EI.RENEW_FLG = '1' --展期标志 
                  AND EI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE BP.OCCURTYPE = '0209' --发生类型：0209-重组
                  AND BP.RENEWALTYPE IN ('VAL','REP') --展期类型: VAL-续期、REP-调整还款计划
                  AND BP.APPROVESTATUS = 'Finished'
                  AND BP.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BP.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BE.EXTENDEFFECTDATE >= TO_DATE('20260109', 'YYYYMMDD') )CZ
     ON CZ.RELATIVEDUEBILLNO = A.DUBIL_ID
   --ADD BY YJY 20260319 取重组贷款标识,增加判断对公信贷重组贷款的逻辑，信贷系统未对重组类型-调整还款计划的合同进行改造
   LEFT JOIN ( SELECT BP.DUEBILLSERIALNO --借据号
                 FROM RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT EC
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT BC
                   ON EC.SERIALNO = BC.RELACONTRACTNO
                  AND BC.BUSINESSFLAG = '2'
                  AND BC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_DUEBILL BD 
                   ON BC.SERIALNO = BD.CONTRACTSERIALNO
                  AND BD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT BP 
                   ON BD.PUTOUTSERIALNO = BP.SERIALNO  
                  AND BP.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BP.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE EC.RENEWALTYPE = 'REP' 
                  AND EC.BUSINESSFLAG = '1'
                  AND EC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND EC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') )CZ1
     ON CZ1.DUEBILLSERIALNO = A.DUBIL_ID
     --ADD BY YJY 20260312 取并购贷款
   LEFT JOIN (  SELECT A.OBJECTNO AS CONT_ID  --业务合同号
                      ,A.TAGID    AS TAGID    --标签编号
                      ,A.TAGVALUE AS TAGVALUE --标签值
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '50' --标签层级 业务合同
                 AND A.TAGID IN ( '2026031090000004'  --是否境外并购贷款
                                 ,'2026031090000005') --并购贷款类型
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') ) BG
     ON BG.CONT_ID = A.CONT_ID
   --ADD BY YJY 20260312 是否退役军人创办企业
   LEFT JOIN ( SELECT A.OBJECTNO AS CUST_ID  --客户号
                     ,A.TAGVALUE AS TAGVALUE --标签值
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '10' --标签层级 客户编号
                 AND A.TAGID = '2026030990000004' --是否退役军人创办企业
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') ) JR
     ON JR.CUST_ID = A.CUST_ID
   WHERE (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID LIKE '6020%' OR A.STD_PROD_ID IS NULL
         OR E.STD_PROD_ID LIKE '2%' OR E.STD_PROD_ID LIKE '6020%' OR E.STD_PROD_ID IS NULL )
     AND A.DUBIL_ID  IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 8;
  V_STEP_DESC := '表内借据信息--零售贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP_BFD
    (DATA_DT                             --数据日期
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
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频率
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
    ,CNCL_DT                             --核销日期     ADD BY MW 20221123
    ,FIXED_INT_MARK                      --利率是否固定
    ,ACCT_MODIF_CATE_CD                  --账户变更类别代码 --ADD BY LYH 20260127
    ,REGROUP_LOAN_FLG                    --重组贷款标志  ADD BY LYH 20260309
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    )
  WITH RETL_LOAN_REPAY_PLAN AS (
  SELECT  D.DUBIL_ID
         ,MAX(TOT_PERDS) AS TOT_PERDS
         ,MAX(REPAY_PERDS) AS REPAY_PERDS
         ,MAX(CASE WHEN D.VALUE_DT > TO_DATE(V_YESTADAY,'YYYYMMDD') THEN 0 ELSE REPAY_PERDS END) AS CURR_PERDS
         ,SUM(CASE WHEN (D.OVDUE_FLG = '1' --逾期标志为是
                       AND D.REPAYBL_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
                       AND D.REPAY_FLG = '0') --未偿还
                  THEN 1 ELSE 0 END) AS LXQKQS --连续欠款期数
         ,SUM(CASE WHEN (D.OVDUE_FLG = '1' --逾期标志为是
                       AND D.REPAYBL_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')
                       AND D.REPAY_FLG = '0') --未偿还
                  THEN 1 ELSE 0 END) AS LJQKQS --累计欠款期数
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN D --零售贷款还款计划
   WHERE D.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
   GROUP BY D.DUBIL_ID)
  --ADD BY LYH 20260127
  ,CL_AMEND AS (
  SELECT /*+ MATERIALIZE */
         T.*,ROW_NUMBER() OVER(PARTITION BY T.MODIF_CONTENT_KEY_VAL ORDER BY T.MODIF_DT DESC NULLS LAST,T.TRAN_TM DESC NULLS LAST) RN
    FROM RRP_MDL.O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL T
   WHERE T.ACCT_MODIF_CATE_CD IN ('EXTENSION', 'MATS') --延期：EXTENSION，缩期：MATS
     AND T.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                    AS DATA_DT                   --数据日期
        ,A.LP_ID                                         AS LGL_REP_ID                --法人编号
        ,A.ACCT_ID                                       AS ACC_ID                    --账户编号
        ,A.DUBIL_NUM                                     AS RCPT_ID                   --借据编号
        ,A.CONT_ID                                       AS CONT_ID                   --合同编号
        ,NULL                                            AS BILL_NO                   --票据号码
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
          END                                            AS COOP_AGRT_ID              --合作协议编号
        ,A.CUST_ID                                       AS CUST_ID                   --客户编号
        ,A.ACCT_INSTIT_ID                                AS ORG_ID                    --机构编号
        ,A.SUBJ_ID                                       AS SUBJ_ID                   --科目编号
        ,A.STD_PROD_ID                                   AS LOAN_STD_PROD_ID          --贷款标准产品编号
        ,C.PROD_NAME                                     AS LOAN_STD_PROD_NM          --贷款标准产品名称
        ,A.STD_PROD_ID                                   AS LOAN_PROD_ID              --贷款产品编号
        ,C.PROD_NAME                                     AS LOAN_PROD_NM              --贷款产品名称
        ,CASE WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100101' THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100102' THEN '010302' --房屋装修贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD IN ('100109') THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0102%' AND TA.BORW_USAGE_TYPE_CD IN ('100201') THEN '010202' --商用车贷款
              WHEN A.STD_PROD_ID IN ('201030200001','201030200002','201030200003') THEN '010101' --个人住房按揭商业贷款
              WHEN A.STD_PROD_ID IN ('201030200001','201030200002') AND TA.BORW_USAGE_TYPE_CD <> '100301' THEN '010101' --个人中长期住房贷款(个人住房按揭商业贷款)
              WHEN A.STD_PROD_ID IN ('201030100001','201030100002') AND TA.BORW_USAGE_TYPE_CD = '100301' THEN '010201' --个人中长期住房贷款(商业用房贷款)
              ELSE NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)
          END                                            AS LOAN_BIZ_TYP              --贷款业务类型
        ,A.CURR_CD                                       AS CUR                       --币种
        ,A.DUBIL_AMT                                     AS LOAN_AMT                  --借款金额
        ,CASE WHEN A.WRT_OFF_FLG ='1' THEN 0
              ELSE A.CURRT_BAL
          END                                            AS LOAN_BAL                  --贷款余额
        ,0                                               AS INT_ADJ                   --利息调整
        ,0                                               AS FAIR_VAL_CHG              --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_PRIC_BAL, 0)
          END                                            AS OVD_PRIN_BAL              --逾期本金余额
        ,A.IN_BS_INT                                     AS IN_INT_OVD_BAL            --表内欠息余额
        ,A.OFF_BS_INT                                    AS OUT_INT_OVD_BAL           --表外欠息余额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                  AS LOAN_ACT_DSTR_DT          --贷款实际发放日期
        ,TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD')               AS LOAN_ORIG_EXP_DT          --贷款原始到期日期 mod by lyh 20240116
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                    AS LOAN_ACT_EXP_DT           --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               AND D.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
              WHEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               AND A.ASSET_TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')  THEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') --资产转让日期
              WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                            AS ACT_END_DT                --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')             AS LAST_REPY_DT              --上次还款日期
        ,NULL                                            AS LAST_REPY_AMT             --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                  AS VAL_DT                    --起息日期
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')              AS OPEN_ACC_DT               --开户日期
        ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
          END                                            AS CNL_ACC_DT                --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                            AS PRIN_OVD_DT               --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0 THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                            AS INT_OVD_DT                --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)    AS OVD_DAYS                  --逾期天数
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN B.PRIC_OVDUE_DAYS = 0 AND B.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                            AS OVD_TYP                   --逾期类型
        ,PUB.CD_DESCB                                    AS LOAN_USEAGE               --贷款用途  --MODIFY BY MW 20221220 直取数仓码值表，不做额外转码
        ,TTC.TAR_VALUE_CODE                              AS LVL5_CL                   --五级分类
        ,TTM.TAR_VALUE_CODE                              AS GUA_MODE                  --担保方式
        ,CASE WHEN F.CERT_TYPE_CD = '1010' THEN
              CASE WHEN SUBSTR(SUBSTR(F.CERT_NO,1,6),-4)='0000' THEN SUBSTR(F.CERT_NO,1,2)||'0101'
                   WHEN SUBSTR(SUBSTR(F.CERT_NO,1,6),-2)='00' AND SUBSTR(F.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                   THEN SUBSTR(F.CERT_NO,1,4) || '01'
                   ELSE SUBSTR(F.CERT_NO,1,6)
               END
          END                                            AS LOAN_DIR_RGN              --贷款投向地区
        ,CASE WHEN B.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(B.DIR_INDUS_CD,'Z')
          END                                            AS LOAN_DIR_IDY              --贷款投向行业
        ,NULL                                            AS SYN_LOAN_FLG              --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN (/*'203010200001'*/'203010200003','203010200004','203010200005','203010200006')--('1050010', '1030010', '1030020','1050020')
              THEN 'Y'
              ELSE 'N'
          END                                            AS PROJ_LOAN_FLG             --项目贷款标志
        ,NULL                                            AS IDY_STRU_ADJ_TYP          --产业结构调整类型
        ,NULL                                            AS IDY_TRNST_UPG_FLG         --工业转型升级标志
        ,NULL                                            AS STRTG_EMER_IDY_TYP        --战略新兴产业类型
        ,CASE WHEN A.STD_PROD_ID IN ('201020100003','201020100012')  ---201020100003税兴贷、201020100012税兴贷（网贷）
                   OR TA.COPRATOR_ID IN ('2290000001')  --深圳微众税银信息服务有限公司
              THEN 'Y'
              ELSE 'N'
          END                                            AS BANK_TAX_COOP_LOAN_FLG    --银税合作贷款标志
        ,CASE WHEN (F.FARM_FLG = '1') THEN 'Y'
              ELSE 'N'
          END                                            AS AGR_REL_LOAN_FLG          --涉农贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('201030100001','201030100002','201030200001','201030200002')
              THEN 'Y'
              ELSE 'N'
          END                                            AS RL_EST_LOAN_FLG           --房地产贷款标志
        ,NULL                                            AS IALL_LOAN_FLG             --投贷联动贷款标志
        ,NULL                                            AS OV_SEA_MRG_LOAN_FLG       --境外并购贷款标志
        ,NULL                                            AS GRN_LOAN_USEAGE_CL        --绿色贷款用途分类
        ,NULL                                            AS ENT_GUA_LOAN_TYP          --创业担保贷款类型
        ,NULL                                            AS CAMPUS_CNSMP_LOAN_FLG     --校园消费贷款标志
        ,NULL                                            AS LCL_GOVFINPLTF_LOAN_FLG   --地方政府融资平台贷款标志
        ,NULL                                            AS LAND_THIRDPARTY_LOAN_TYP  --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                            AS FARMER_THIRDPARTY_LOAN_TY --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                            AS POV_ALLE_REC_FLG          --未脱贫建档立卡户贷款标志
        ,NVL(TJ.TAR_VALUE_CODE,M.CHN_ID)                 AS LOAN_HDL_CHAN             --贷款办理渠道
        /*,CASE WHEN B.STD_PROD_ID IN ('202010200005','202020200002','202010200008','202010200003',
                   '202020200006','202020200005','202010200004','202020200003')
              THEN 'Y'
              ELSE 'N'
          END  */
         --MOD BY YJY 20260204 优先判断尽调标志为否的则为互联网贷款业务
        ,CASE /*WHEN B.STD_PROD_ID IN ('201010300040','201020100060') AND B.DUE_DILIGENCE_FLG <> '1' THEN 'Y' --201010300040华兴易贷（信用）201020100060华兴好易贷（经营-信用） --mod by yjy 20250805*/
              WHEN B.STD_PROD_ID IN ('201010300040','201020100060') AND B.OUTLINE_VRIF_IDTI_FLG <> '1' THEN 'Y' --mod BY YJY 20260226 判断是否线下核身为否的则为互联网
              WHEN B.STD_PROD_ID IN ('201010300035',/*'201010300041',*/'201020100059') THEN 'Y' --201010300035华兴易贷（担保）201010300041华兴好易贷（华强）201020100059华兴好易贷（经营-担保）--MOD BY YJY 20250103 默认互联网贷款
              WHEN B.STD_PROD_ID IN ('201020100062','201020100061'
                                     ,'201020100014','201020100024','201020100051','201020100052') 
               --ADD BY YJY  201020100014、201020100024、201020100051、201020100052新增互联贷款业务标签，参考201020100062 饲料e贷-海大集团
               AND HD.DUBIL_ID IS NOT NULL THEN 'Y' --饲料e贷-海大集团\兴采贷 ADD BY YJY 20250717 关联标签表判断是否互联网业务
              WHEN B.STD_PROD_ID = '202010200012' THEN 'Y' --202010200012-360借条 默认互联网贷款 ADD BY YJY 20250826
         ELSE NVL(CONFIG1.NET_LOAN_FLG,'N')
         END                                             AS NET_LOAN_FLG              --互联网贷款标志
         ,'0'                                            AS NET_LOAN_PROD_TYP         --网贷产品类别
        ,NULL                                            AS CR_CRD_BIZ_OD_TYP         --类信用卡业务透支类型
        ,CASE WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '1M' THEN '01' --按月
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '3M' THEN '02' --按季
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '6M' THEN '03' --按半年
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '12M' THEN '04' --按年
              ELSE TTE.TAR_VALUE_CODE
          END                                            AS REPY_MODE                 --还款方式
        ,'01'                                            AS LOAN_FRM                  --贷款形式   --20221121  参考east5.0口径修改 LHQ
        ,CASE WHEN TA.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202')--0201 展期 0204 债务重组 0202 借新还旧
              THEN 'Y'
              ELSE 'N'
          END                                            AS RCMM_LOAN_FLG             --重组贷款标识
        ,NULL                                            AS ADJ_BAD_FLG               --下调为不良标志
        ,NULL                                            AS ALDY_RCMM_FLG             --曾重组标志
        ,NULL                                            AS CTON_PRD_LOAN_FLG         --缩期贷款标志
        ,NULL                                            AS CASH_TRF_FLG              --现转标志
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')               AS FST_LOAN_FLG              --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')               AS FIRST_LOAN_FLG            --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                            AS PBOC_GRN_LOAN_FLG         --PBOC绿色贷款标志
        ,'N'                                             AS CBRC_GRN_LOAN_FLG         --CBRC绿色贷款标志
        ,NULL                                            AS CNSMP_SCN_LOAN_FLG        --消费场景贷款标志
        ,NULL                                            AS LOAN_FINC_SPT_MODE        --贷款财政扶持方式
        ,CASE WHEN (AD.POVERTY_LOAN_FLG LIKE '%返贫%' OR AD.POVERTY_LOAN_FLG LIKE '%未脱贫%') THEN 'N'
              WHEN (AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫') THEN 'Y'
              WHEN A.DISTR_DT > TO_DATE('20211231', 'YYYYMMDD') AND AC.CUST_ID IS NOT NULL THEN 'Y'
              ELSE NULL
          END                                            AS ACURT_POV_ALLE_LOAN_FLG   --精准扶贫贷款标志
        ,CASE WHEN A.NEXT_INT_RAT_ADJ_DT = DATE'0001-01-01' THEN NULL
              ELSE TO_CHAR(A.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD')
          END                                            AS RATE_RE_PRC_DT             --利率重新定价日期 20221109 XUXIAOBIN MODIFY
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1D' THEN '01'--按日
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN('7D','1W') THEN '02'--按周
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='1M' THEN '03'--按月
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='3M' THEN '04'--按季
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='6M' THEN '05'--按半年
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD='12M' THEN '06'--按年
              ELSE '99'
          END                                            AS RATE_FLT_FREQ             --利率浮动频率
        ,TTK.TAR_VALUE_CODE                              AS RATE_TYP                  --利率类型
        ,NULL                                            AS AST_SCRTZ_PROD_ID         --资产证券化产品编号
        ,A.EXEC_INT_RAT                                  AS EXEC_RATE                 --执行利率
        ,A.BASE_RAT                                      AS BASE_RATE                 --基准利率
        ,NULL                                            AS CNTR_GUA_LOAN_FLG         --反担保贷款标志
        ,B.INT_RAT_FLO_VAL                               AS RATE_FLT_VAL              --利率浮动值
        ,CASE WHEN A.BASE_RAT_ID IN ('2231','2232') THEN 'TR07' --MODIFY CCH 20221025 根据新监管码值，2231、2232对应报表的LPR
              ELSE TI.TAR_VALUE_CODE
          END                                            AS PRC_BASE_TYP              --定价基准类型
        ,CASE WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS --因贷款产品跑批问题，部分借据的还款计划被清掉了
              THEN A.CURR_ISSUE_PERDS
              ELSE A.TOT_PERDS
          END                                            AS TOT_PRD_NUM               --总期数
        ,A.CURR_ISSUE_PERDS                              AS CURR_PRD                  --当前期数
        ,NVL(DD.LJQKQS,0)                                AS CUM_DEBT_PRD_NUM          --累计欠款期数
        ,NVL(DD.LXQKQS,0)                                AS CNU_DEBT_PRD_NUM          --连续欠款期数
        ,NVL(A.RENEW_CNT,0)                              AS EXTN_CNT                  --展期次数
        ,NVL(TTG.TAR_VALUE_CODE,'01')                    AS DSBR_MODE                 --放款方式
        ,NVL(TRIM(TTH.TAR_VALUE_CODE),'9901')            AS INT_CALC_MODE             --计息方式
        ,NULL                                            AS MRGN_PCT                  --保证金比例
        ,NULL                                            AS MRGN_CUR                  --保证金币种
        ,NULL                                            AS MRGN                      --保证金
        ,NULL                                            AS MRGN_ACC                  --保证金账号
        ,B.CUST_MGR_ID                                   AS LOAN_OFR_NO               --信贷员工号
        ,A.CURRT_ACRU_INT                                AS ACCRD_INT                 --应计利息
        ,NULL                                            AS PRO_IMPT                  --减值准备
        ,NULL                                            AS COM_PRO                   --一般准备
        ,NULL                                            AS SPCL_PRO                  --专项准备
        ,NULL                                            AS ESP_PRO                   --特别准备
        ,NULL                                            AS SPCL_LOAN_FLG             --专项贷款标志
        ,NULL                                            AS ORIG_RCPT_NO              --原借据号
        ,100                                             AS FND_PCT                   --出资比例
        ,A.LOAN_DISTR_ACCT_NUM                           AS ETR_ACC                   --入账账号
        ,NULL                                            AS ETR_ACC_NM                --入账账号户名
        ,NULL                                            AS LOAN_ETR_ACC_OPEN_BANK_NM --贷款入账账号开户行名称
        ,A.LOAN_REPAY_NUM                                AS REPY_ACC                  --还款账号
        ,NULL                                            AS LOAN_REPY_ACC_OPEN_BANK_N --贷款还款账号开户行名称
        ,CASE WHEN A.ASSET_TRAN_STATUS_CD = '121' THEN 'C0202' --转让
              WHEN A.WRT_OFF_FLG = '1' THEN 'C0201'  --核销 modify by tangan at 20230103
              WHEN A.LOAN_ACCT_STATUS_CD = 'C' THEN 'C01' --结清 modify by tangan at 20230103
              WHEN A.LOAN_MODAL_CD = 'ZHC' THEN 'A'  --正常 modify by tangan at 20230103
              WHEN A.LOAN_MODAL_CD IN ('YUQ','FYJ','FY') THEN 'B'  --逾期 modify by tangan at 20230103
              ELSE TTI.TAR_VALUE_CODE
          END                                            AS RCPT_STAT                 --借据状态
        ,TTJ.TAR_VALUE_CODE                              AS ACC_STAT                  --账户状态
        /*,CASE WHEN A.CIRCL_LOAN_FLG = '0' THEN 'N'
              WHEN A.CIRCL_LOAN_FLG = '1'THEN 'Y'
              ELSE A.CIRCL_LOAN_FLG
          END*/
        ,CASE WHEN B.STD_PROD_ID IN ('201020100014','201020100012','201020100024'
                                     ,'201020100051','201020100052','201020100054' --新增201020100054好企贷-IPC产品为循环贷
                                     ,'201020100062','201020100061')
              THEN 'Y' --modify by lwb 新增两个饲料e贷 --mod by yjy 20250718 新增饲料e贷-海大集团  201020100062、兴采贷  201020100061 
              WHEN A.CIRCL_LOAN_FLG = '0' THEN 'N'  
              WHEN A.CIRCL_LOAN_FLG = '1'THEN 'Y'
              ELSE A.CIRCL_LOAN_FLG
          END                                            AS REV_LOAN_FLG              --循环贷贷款标志
        ,NULL                                            AS REL_PSN_GUA_LOAN_FLG      --关系人保证贷款标志
        ,A.NEXT_REPAY_INT_AMT                            AS BEAR_OR_RED_AMT           --承担或减免的信贷费用金额
        ,CASE WHEN F.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
              WHEN F.DOM_OVERS_FLG ='0' THEN 'N'  --MODIFY BY 20221103 1：境内 0 ：境外
              ELSE 'Z'
          END                                            AS BIO_LOAN_FLG              --客户境内外标志
        ,'800924'                                        AS DEPT_LINE                 --部门条线
        ,'零售贷款'                                      AS DATA_SRC                  --数据来源
        ,TA.LMT_CONT_ID                                  AS LMT_CONT_ID               --额度合同编号
        ,A.REPAY_WAY_CD                                  AS GXH_PAY_TYPE              --还款方式
        ,A.REPAY_PED_CORP_CD                             AS GXH_PAY_FREQ              --还款频率
        ,TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD')             AS ASSET_TRAN_DT             --资产转让日期
        ,'Y'                                             AS LOAN_DIR_BIO_FLG          --贷款投向境内外标识 --零售贷款默认为境内
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_INT_AMT, 0)
          END                                            AS OVD_INT_BAL               --逾期利息金额
        ,B.CUST_CRDT_TOT                                 AS LOAN_CRDT_LMT_TOT         --放款时单户授信总额度
        ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1' THEN 'Y'
              ELSE 'N'
          END                                            AS REFAC_FLG                 --支小再贷款标识
        ,NULL                                            AS BILL_ACT_AMT              --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                            AS LOAN_MODAL_CD             --贷款形态代码
        ,NULL                                            AS OPER_ORG_ID               --经办机构编号 MOD BY HULJ 20221122
        ,NULL                                            AS OPER_TELLER_ID            --经办柜员编号 MOD BY HULJ 20221122
        ,H1.LOAN_ACT_DSTR_DT                             AS LOAN_ACT_FIRST_DT         --本行首贷日期 MOD BY HULJ 20221122
        ,TO_CHAR(A.RENEW_EXP_DT,'YYYYMMDD')              AS RENEW_EXP_DAY             --展期到期日期 MOD BY HULJ 20221122
        ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')            AS CNCL_DT                   --核销日期     ADD BY MW 20221123
        ,A.INT_RAT_ADJ_WAY_CD                            AS FIXED_INT_MARK            --利率是否固定
        ,CATE.ACCT_MODIF_CATE_CD                         AS ACCT_MODIF_CATE_CD        --账户变更类别代码 --ADD BY LYH 20260127
        ,B.REGROUP_LOAN_FLG                              AS REGROUP_LOAN_FLG          --重组贷款标志  ADD BY LYH 20260309
        ,NULL                                            AS SFJWBGDK                  --是否境外并购贷款  ADD BY YJY 20260312
        ,NULL                                            AS BGDKLX                    --并购贷款类型  ADD BY YJY 20260312
        ,NULL                                            AS SFTYJRCBQY                --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA  --零售贷款合同信息表
      ON TA.CONT_ID = A.CONT_ID
     AND TA.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO M
      ON M.LOAN_APPL_FLOW_NUM = TA.APV_FLOW_NUM
     AND M.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO  C    --标准产品信息
      ON C.PROD_ID = A.STD_PROD_ID
     AND C.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息
      ON D.DUBIL_ID = A.DUBIL_NUM
     AND D.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F --个人客户基本信息
      ON F.CUST_ID = A.CUST_ID
     AND F.ETL_DT  = TO_DATE(V_YESTADAY,'YYYYMMDD')
    LEFT JOIN RETL_LOAN_REPAY_PLAN DD
      ON DD.DUBIL_ID = B.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04_BFD AC --精准扶贫按客户整合
      ON AC.CUST_ID = A.CUST_ID
     AND AC.ACCT_DURAN = '2021-04'
    LEFT JOIN RRP_MDL.ADD_POVERTY_RELIF AD  --精准扶贫名录20211231填报数据基表
      ON AD.LOAN_NUM = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD PUB --公共代码表 取贷款用途
      ON PUB.CD_ID = 'CD1274'
     AND PUB.CD_VAL = TA.BORW_USAGE_TYPE_CD
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON TTA.SRC_VALUE_CODE = B.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'    --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --码值映射表(贷款用途)
      ON TTB.SRC_VALUE_CODE = TA.BORW_USAGE_TYPE_CD
     AND TTB.SRC_CLASS_CODE = 'CD1274'
     AND TTB.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTC  --码值映射表(五级分类)
      ON TTC.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND TTC.SRC_CLASS_CODE = 'CD1032'
     AND TTC.TAR_CLASS_CODE = 'D0005'
     AND TTC.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTE  --码值映射表(还款方式)
      ON TTE.SRC_VALUE_CODE = A.INT_SET_WAY_CD
     AND TTE.SRC_CLASS_CODE = 'CD2778'
     AND TTE.TAR_CLASS_CODE = 'D0103'
     AND TTE.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTF  --码值映射表(贷款形式)
      ON TTF.SRC_VALUE_CODE = B.LOAN_HAPP_TYPE_CD
     AND TTF.SRC_CLASS_CODE = 'CD1364'
     AND TTF.TAR_CLASS_CODE = 'D0008'
     AND TTF.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTG  --码值映射表(放款方式)
      ON TTG.SRC_VALUE_CODE = B.MODE_PAY_CD
     AND TTG.SRC_CLASS_CODE = 'CD1372'
     AND TTG.TAR_CLASS_CODE = 'D0104'
     AND TTG.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTH  --码值映射表(计息方式)
      ON TTH.SRC_VALUE_CODE = A.INT_SET_WAY_CD
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
    LEFT JOIN RRP_MDL.CODE_MAP TI    --利率种类转码
      ON TI.SRC_VALUE_CODE = A.INT_RAT_BASE_TYPE_CD
     AND TI.SRC_CLASS_CODE = 'CD1010'
     AND TI.TAR_CLASS_CODE = 'Z0015'
     AND TI.MOD_FLG = 'MDM'     --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTK   --利率类型转码
      ON TTK.SRC_VALUE_CODE = A.INT_RAT_FLOAT_WAY_CD
     AND TTK.SRC_CLASS_CODE = 'CD1016'
     AND TTK.TAR_CLASS_CODE = 'Z0007'
     AND TTK.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TJ
      ON TJ.SRC_VALUE_CODE = M.CHN_ID
     AND TJ.SRC_CLASS_CODE = 'CD2366'
     AND TJ.TAR_CLASS_CODE = 'Z0014'
     AND TJ.MOD_FLG = 'MDM'      --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTL  --利率调整频率
      ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
     AND TTL.SRC_CLASS_CODE = 'CD1041'
     AND TTL.TAR_CLASS_CODE = 'D0105'
     AND TTL.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TTM  --担保方式转码
      ON TTM.SRC_VALUE_CODE = B.GUAR_WAY_CD
     AND TTM.SRC_CLASS_CODE = 'CD2656'
     AND TTM.TAR_CLASS_CODE = 'D0002'
     AND TTM.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD H1
      ON H1.RCPT_ID = A.DUBIL_NUM  --ADD BY 20220824 XUXIAOBIN  取是否首贷标志
    --ADD BY YJY 20260204 判断互联网业务  
    LEFT JOIN RRP_MDL.CONFIG_LOAN_PROD CONFIG1
     ON CONFIG1.STD_PROD_ID = A.STD_PROD_ID
   LEFT JOIN (SELECT A.OBJECTNO AS DUBIL_ID  --业务流水号
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '60' --标签层级
                 AND A.TAGID = '2025080800000001' --标签编号：互联网业务
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) HD
       ON HD.DUBIL_ID = A.DUBIL_NUM
    --ADD BY LYH 20260127
    LEFT JOIN CL_AMEND CATE
      ON CATE.MODIF_CONTENT_KEY_VAL = A.ACCT_ID
     AND CATE.RN = 1
   WHERE A.DUBIL_NUM IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_YESTADAY,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 9;
  V_STEP_DESC := '表内借据信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP_BFD
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ACC_ID                      --账户编号
    ,RCPT_ID                     --借据编号
    ,THIRD_RCPT_ID               --第三方借据编号  ADD BY YJY 20250521
    ,CONT_ID                     --合同编号
    ,BILL_NO                     --票据号码
    ,COOP_AGRT_ID                --合作协议编号
    ,CUST_ID                     --客户编号
    ,ORG_ID                      --机构编号
    ,SUBJ_ID                     --科目编号
    ,LOAN_STD_PROD_ID            --贷款标准产品编号
    ,LOAN_STD_PROD_NM            --贷款标准产品名称
    ,LOAN_PROD_ID                --贷款产品编号
    ,LOAN_PROD_NM                --贷款产品名称
    ,LOAN_BIZ_TYP                --贷款业务类型
    ,CUR                         --币种
    ,LOAN_AMT                    --借款金额
    ,LOAN_BAL                    --贷款余额
    ,INT_ADJ                     --利息调整
    ,FAIR_VAL_CHG                --公允价值变动
    ,OVD_PRIN_BAL                --逾期本金余额
    ,IN_INT_OVD_BAL              --表内欠息余额
    ,OUT_INT_OVD_BAL             --表外欠息余额
    ,LOAN_ACT_DSTR_DT            --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT            --贷款原始到期日期
    ,LOAN_ACT_EXP_DT             --贷款实际到期日期
    ,ACT_END_DT                  --实际终止日期
    ,LAST_REPY_DT                --上次还款日期
    ,LAST_REPY_AMT               --上次还款金额
    ,VAL_DT                      --起息日期
    ,OPEN_ACC_DT                 --开户日期
    ,CNL_ACC_DT                  --销户日期
    ,PRIN_OVD_DT                 --本金逾期日期
    ,INT_OVD_DT                  --利息逾期日期
    ,OVD_DAYS                    --逾期天数
    ,OVD_TYP                     --逾期类型
    ,LOAN_USEAGE                 --贷款用途
    ,LVL5_CL                     --五级分类
    ,GUA_MODE                    --担保方式
    ,LOAN_DIR_RGN                --贷款投向地区
    ,LOAN_DIR_IDY                --贷款投向行业
    ,SYN_LOAN_FLG                --银团贷款标志
    ,PROJ_LOAN_FLG               --项目贷款标志
    ,IDY_STRU_ADJ_TYP            --产业结构调整类型
    ,IDY_TRNST_UPG_FLG           --工业转型升级标志
    ,STRTG_EMER_IDY_TYP          --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
    ,AGR_REL_LOAN_FLG            --涉农贷款标志
    ,RL_EST_LOAN_FLG             --房地产贷款标志
    ,IALL_LOAN_FLG               --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP            --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN               --贷款办理渠道
    ,NET_LOAN_FLG                --互联网贷款标志
    ,NET_LOAN_PROD_TYP           --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
    ,REPY_MODE                   --还款方式
    ,LOAN_FRM                    --贷款形式
    ,RCMM_LOAN_FLG               --重组贷款标识
    ,ADJ_BAD_FLG                 --下调为不良标志
    ,ALDY_RCMM_FLG               --曾重组标志
    ,CTON_PRD_LOAN_FLG           --缩期贷款标志
    ,CASH_TRF_FLG                --现转标志
    ,FST_LOAN_FLG                --首贷户贷款标志
    ,FIRST_LOAN_FLG              --首次贷款标志
    ,PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE          --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
    ,RATE_RE_PRC_DT              --利率重新定价日期
    ,RATE_FLT_FREQ               --利率浮动频率
    ,RATE_TYP                    --利率类型
    ,AST_SCRTZ_PROD_ID           --资产证券化产品编号
    ,EXEC_RATE                   --执行利率
    ,BASE_RATE                   --基准利率
    ,CNTR_GUA_LOAN_FLG           --反担保贷款标志
    ,RATE_FLT_VAL                --利率浮动值
    ,PRC_BASE_TYP                --定价基准类型
    ,TOT_PRD_NUM                 --总期数
    ,CURR_PRD                    --当前期数
    ,CUM_DEBT_PRD_NUM            --累计欠款期数
    ,CNU_DEBT_PRD_NUM            --连续欠款期数
    ,EXTN_CNT                    --展期次数
    ,DSBR_MODE                   --放款方式
    ,INT_CALC_MODE               --计息方式
    ,MRGN_PCT                    --保证金比例
    ,MRGN_CUR                    --保证金币种
    ,MRGN                        --保证金
    ,MRGN_ACC                    --保证金账号
    ,LOAN_OFR_NO                 --信贷员工号
    ,ACCRD_INT                   --应计利息
    ,PRO_IMPT                    --减值准备
    ,COM_PRO                     --一般准备
    ,SPCL_PRO                    --专项准备
    ,ESP_PRO                     --特别准备
    ,SPCL_LOAN_FLG               --专项贷款标志
    ,ORIG_RCPT_NO                --原借据号
    ,FND_PCT                     --出资比例
    ,ETR_ACC                     --入账账号
    ,ETR_ACC_NM                  --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
    ,REPY_ACC                    --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
    ,RCPT_STAT                   --借据状态
    ,ACC_STAT                    --账户状态
    ,REV_LOAN_FLG                --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
    ,BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                --境内外标志
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,LMT_CONT_ID                 --额度合同编号
    ,GXH_PAY_TYPE                --还款方式
    ,GXH_PAY_FREQ                --还款频率
    ,LOAN_DIR_BIO_FLG            --贷款投向境内外标识
    ,OVD_INT_BAL                 --逾期利息金额
    ,REFAC_FLG                   --支小再贷款标识
    ,BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD               --贷款形态代码
    ,OPER_ORG_ID                 --经办机构编号 MOD BY HULJ 20221122
    ,OPER_TELLER_ID              --经办柜员编号 MOD BY HULJ 20221122
    ,LOAN_ACT_FIRST_DT           --本行首贷日期 MOD BY HULJ 20221122
    ,RENEW_EXP_DAY               --展期到期日期 MOD BY HULJ 20221122
    ,CNCL_DT                     --核销日期     ADD BY MW 20221123
    ,FIXED_INT_MARK              --利率是否固定
    ,INTNAL_CARR_FLG             --内部结转标志
    ,CRED_RHT_TURN_FLG           --债权直转标志 ADD BY HULJ20230914
    ,LOAN_TYPE_CD                --借据类型代码 ADD BY HULJ20230914
    ,DISTR_DT                    --放款日期（网商贷直转 转入日期） ADD BY LYH 20231012
    ,REGROUP_LOAN_FLG            --重组贷款标志  ADD BY LYH 20260309
    ,SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    )
  WITH UNITE_WL_REPAY_PLAN AS (
    SELECT  B.DUBIL_ID
           ,MAX(B.TOT_PERDS) AS TOT_PERDS
           ,MAX(B.REPAY_PERDS) AS REPAY_PERDS
           ,MAX(CASE WHEN B.REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE B.REPAY_PERDS END) AS CURR_PERDS
           ,SUM(CASE WHEN (TO_CHAR(B.PRIC_TURN_OVDUE_DT) NOT IN ('20991231','00010101')
                          OR TO_CHAR(B.INT_TURN_OVDUE_DT) NOT IN ('20991231','00010101'))
                     AND B.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND B.OVDUE_FLG = '1' AND B.REPAY_FLG = '0'
                    THEN 1 ELSE 0 END) AS LXQKQS --连续欠款期数
           ,SUM(CASE WHEN B.OVDUE_FLG = '1' AND B.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 1 ELSE 0 END) AS LJQKQS --累计欠款期数
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN B --联合网贷还款计划
     WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY B.DUBIL_ID)
  SELECT V_YESTADAY                                   AS DATA_DT                     --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID                  --法人编号
        ,A.DUBIL_ID                                   AS ACC_ID                      --账户编号
        /*,A.DUBIL_ID                                   AS RCPT_ID                     --借据编号 */
        /*,A.CORE_DUBIL_ID                              AS RCPT_ID                     --借据编号  MOD BY YJY 20250521 取联合网贷的核心借据号 
        ,A.DUBIL_ID                                   AS THIRD_RCPT_ID               --第三方借据编号  ADD BY YJY 20250521 */
        ,A.DUBIL_ID                                   AS RCPT_ID                     --借据编号
        ,A.CORE_DUBIL_ID                              AS THIRD_RCPT_ID               --第三方借据编号  --MOD  BY YJY 20250725 借据编号取第三方借据，第三方借据取行内借据
        ,A.DUBIL_ID                                   AS CONT_ID                     --合同编号
        ,A.DUBIL_ID                                   AS BILL_NO                     --票据号码
        ,CASE WHEN A.STD_PROD_ID = '202010100006' THEN '微银（联贷）字Y第496号'--微粒贷
              WHEN A.STD_PROD_ID  IN( '202010100001') THEN '10048663J'--借呗
              WHEN A.STD_PROD_ID  IN( '202010100003') THEN 'sign-1-180292131121'--花呗
              WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN 'JDJR-XFJR-2019-0284'--京东金条
          END                                         AS COOP_AGRT_ID                --合作协议编号
        ,A.CUST_ID                                    AS CUST_ID                     --客户编号
        ,A.ACCT_INSTIT_ID                             AS ORG_ID                      --机构编号
        ,A.SUBJ_ID                                    AS SUBJ_ID                     --科目编号
        ,A.STD_PROD_ID                                AS LOAN_STD_PROD_ID            --贷款标准产品编号
        ,M.PROD_NAME                                  AS LOAN_STD_PROD_NM            --贷款标准产品名称
        ,A.STD_PROD_ID                                AS LOAN_PROD_ID                --贷款产品编号
        --MOD BY LIP 20230915 将网商贷债权直转的标记出来以便区分
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '网商贷（债权直转）'
              ELSE NVL(TTA.SRC_VALUE_NAME,A.STD_PROD_ID)
          END                                         AS LOAN_PROD_NM                --贷款产品名称
        ,NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)        AS LOAN_BIZ_TYP                --贷款业务类型
        ,A.CURR_CD                                    AS CUR                         --币种
        ,A.DUBIL_AMT                                  AS LOAN_AMT                    --借款金额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE A.CURRT_BAL
          END                                         AS LOAN_BAL                    --贷款余额
        ,0                                            AS INT_ADJ                     --利息调整
        ,0                                            AS FAIR_VAL_CHG                --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_PRIC, 0) + NVL(A.IDLE_PRIC,0)
          END                                         AS OVD_PRIN_BAL                --逾期本金余额
        ,A.IN_BS_OVER_INT_BAL                         AS IN_INT_OVD_BAL              --表内欠息余额
        ,A.OFF_BS_OVER_INT_BAL                        AS OUT_INT_OVD_BAL             --表外欠息余额
        --UPDATE BY LYH 20230925，金数网商贷债券直转 发放日期 取 原始放款日期 
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') 
               AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
               AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD') 
              ELSE TO_CHAR(A.DISTR_DT,'YYYYMMDD')
          END                                         AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
        --花呗存在原始到期日期可以更改的场景  参考旧金数取花呗取还款计划中的到期日
        ,CASE WHEN A.STD_PROD_ID = '202010100003' 
              THEN TO_CHAR(NVL(K.REPAYBL_DT,A.EXP_DT),'YYYYMMDD')
              --MOD BY LIP 20240704 网商贷3.0调整原始到期日期取数
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
              THEN TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                         AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
        ,CASE WHEN A.STD_PROD_ID = '202010100003' 
              THEN TO_CHAR(NVL(K.REPAYBL_DT,A.EXP_DT),'YYYYMMDD')
              ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                         AS LOAN_ACT_EXP_DT             --贷款实际到期日期
        ,CASE WHEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               AND TFF.FIR_WRT_OFF_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD') 
              THEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) =0
               AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
              THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') --20230612 xuxiaobin MODIFY
              WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231') 
              THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')
              ELSE ''
          END                                         AS ACT_END_DT                  --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')          AS LAST_REPY_DT                --上次还款日期
        ,NULL                                         AS LAST_REPY_AMT               --上次还款金额
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')           AS VAL_DT                      --起息日期
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')               AS OPEN_ACC_DT                 --开户日期
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')              AS CNL_ACC_DT                  --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                         AS PRIN_OVD_DT                 --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0 
              THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                         AS INT_OVD_DT                  --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVD_DAYS                    --逾期天数
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 
               AND A.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN A.PRIC_OVDUE_DAYS > 0 
               AND A.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN A.PRIC_OVDUE_DAYS = 0 
               AND A.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                         AS OVD_TYP                     --逾期类型
        ,PUB.CD_DESCB                                 AS LOAN_USEAGE  --20220825 XUXIAOBIN  --贷款用途
        ,TTC.TAR_VALUE_CODE                           AS LVL5_CL                            --五级分类
        ,TTM.TAR_VALUE_CODE                           AS GUA_MODE                            --担保方式
        ,NVL(CASE WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-4)='0000' 
                  THEN SUBSTR(C.RG_COUNTY_CD,1,2)||'0101'
                  WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-2)='00' 
                   AND SUBSTR(TRIM(C.RG_COUNTY_CD),1,6) NOT IN ('441900','442000','460300','460400')
                  THEN SUBSTR(C.RG_COUNTY_CD,1,4)||'01'
                  ELSE SUBSTR(TRIM(C.RG_COUNTY_CD),1,6)
              END,
             CASE WHEN E.CERT_TYPE_CD = '1010' 
                  THEN CASE WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-4)='0000' 
                            THEN SUBSTR(E.CERT_NO,1,2)||'0101'
                            WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-2)='00' 
                             AND SUBSTR(E.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                            THEN SUBSTR(E.CERT_NO,1,4) || '01'
                            ELSE SUBSTR(E.CERT_NO,1,6)
                        END
             END)                                    AS LOAN_DIR_RGN                --贷款投向地区
        ,CASE WHEN A.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(A.DIR_INDUS_CD,'Z')
          END                                        AS LOAN_DIR_IDY                --贷款投向行业
        ,CASE WHEN A.STD_PROD_ID IN ('203010400001','203010400002') THEN 'Y'
              ELSE 'N'
          END                                        AS BANK_TAX_COOP_LOAN_FLG    --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN (/*'203010200001',*/'203010200003','203010200004','203010200005','203010200006')--('1050010', '1030010', '1030020','1050020')
              THEN 'Y'
              ELSE 'N'
          END                                         AS PROJ_LOAN_FLG               --项目贷款标志  --经业务确认 经营性物业贷款划分为一版固定资产贷款
        ,NULL                                         AS IDY_STRU_ADJ_TYP            --产业结构调整类型
        ,NULL                                         AS IDY_TRNST_UPG_FLG           --工业转型升级标志
        ,NULL                                         AS STRTG_EMER_IDY_TYP          --战略新兴产业类型
        ,'N'                                          AS BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
        ,CASE WHEN (E.FARM_FLG = '1') THEN 'Y'
              ELSE 'N'
          END                                         AS AGR_REL_LOAN_FLG            --涉农贷款标志
        ,NULL                                         AS RL_EST_LOAN_FLG             --房地产贷款标志
        ,NULL                                         AS IALL_LOAN_FLG               --投贷联动贷款标志
        ,NULL                                         AS OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
        ,NULL                                         AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
        ,NULL                                         AS ENT_GUA_LOAN_TYP            --创业担保贷款类型
        ,NULL                                         AS CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
        ,NULL                                         AS LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
        ,NULL                                         AS LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                         AS FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                         AS POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
        ,'08'                                         AS LOAN_HDL_CHAN               --贷款办理渠道
        ,'Y'                                          AS NET_LOAN_FLG                --互联网贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('202010100001','202010100002'
                                    ,'202010100003','202010100004'
                                    ,'202010100005','202010100006'
                                    ,'202020100001')
              THEN '1' --联合贷
              WHEN A.STD_PROD_ID IN ('202010200002','202010200004'
                                    ,'202020200003','202020200008'
                                    ,'202010200007')
              THEN '2' --助贷
              ELSE '3' --自营
          END                                         AS NET_LOAN_PROD_TYP           --网贷产品类别
        ,NULL                                         AS CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
        ,TTD.TAR_VALUE_CODE                           AS THREPY_MODE                 --还款方式
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') 
               AND A.REGROUP_FLG = '1' 
              THEN '04' --重组贷款
              ELSE '01'
          END                                         AS LOAN_FRM                            --贷款形式
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') 
               AND A.REGROUP_FLG = '1' 
              THEN 'Y'
              ELSE 'N'
          END                                         AS RCMM_LOAN_FLG               --重组贷款标识
        ,NULL                                         AS ADJ_BAD_FLG                 --下调为不良标志
        ,NULL                                         AS ALDY_RCMM_FLG               --曾重组标志
        ,NULL                                         AS CTON_PRD_LOAN_FLG           --缩期贷款标志
        ,NULL                                         AS CASH_TRF_FLG                --现转标志
        ,DECODE(H2.RCPT_ID, NULL,'N', 'Y')            AS FST_LOAN_FLG                --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H2.RCPT_ID, NULL,'N', 'Y')            AS FIRST_LOAN_FLG              --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                         AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
        ,'N'                                          AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
        ,NULL                                         AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
        ,NULL                                         AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式
        /*,CASE WHEN A.DISTR_DT >= DATE '2021-05-01' AND A.STD_PROD_ID = '202010100003' THEN 'N'
              WHEN ((AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫')
                   OR (A.DISTR_DT > DATE'2021-12-31' AND AC.CUST_ID IS NOT NULL))
              THEN 'Y'
              ELSE 'N'
          END                                         ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志*/
        --MOD BY LYH 20240612，精准扶贫贷款标志 拷贝 ETL_M_LOAN_IN_DUBILL_INFO 逻辑
        ,CASE WHEN (AD.POVERTY_LOAN_FLG LIKE '%返贫%' OR AD.POVERTY_LOAN_FLG LIKE '%未脱贫%') THEN 'N'
              WHEN (AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫') THEN 'Y'
              WHEN A.DISTR_DT >= DATE '2021-05-01' AND A.STD_PROD_ID = '202010100003' THEN NULL
              WHEN (A.DISTR_DT > DATE '2021-12-31' AND AC.CUST_ID IS NOT NULL) THEN 'Y'
              ELSE NULL
          END                                         AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
        ,NULL                                         AS RATE_RE_PRC_DT              --利率重新定价日期
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01'--按日
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02'--按周
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03'--按月
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04'--按季
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05'--按半年
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06'--按年
              ELSE '99'
          END                                         AS RATE_FLT_FREQ               --利率浮动频率
        ,TTK.TAR_VALUE_CODE                           AS RATE_TYP                    --利率类型
        ,NULL                                         AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
        ,A.EXEC_INT_RAT                               AS EXEC_RATE                   --执行利率
        ,A.BASE_RAT                                   AS BASE_RATE                   --基准利率
        ,NULL                                         AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
        ,A.INT_RAT_FLO_VAL                            AS RATE_FLT_VAL                --利率浮动值
        ,CASE WHEN A.STD_PROD_ID = '202010100006' THEN 'TR07' --微粒贷  --MODIFY BY HULJ 20221107 更改标准产品编号
              ELSE TI.TAR_VALUE_CODE
          END                                         AS PRC_BASE_TYP                --定价基准类型
        ,CASE WHEN (A.TOT_PERDS = 0 OR A.PAYOFF_DT <= TO_DATE(V_YESTADAY,'YYYYMMDD')) 
              THEN A.CURR_ISSUE_PERDS
              WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS 
              THEN A.TOT_PERDS + 1
              ELSE A.TOT_PERDS
          END                                         AS TOT_PRD_NUM                 --总期数
        ,A.CURR_ISSUE_PERDS                           AS CURR_PRD                    --当前期数
        ,NVL(B.LJQKQS,0)                              AS CUM_DEBT_PRD_NUM            --累计欠款期数
        ,NVL(B.LXQKQS,0)                              AS CNU_DEBT_PRD_NUM            --连续欠款期数
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') 
               AND A.REGROUP_LOAN_TYPE_CD = '0010' THEN 1 --0010还款计划变更+展期
              WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS THEN 1
              ELSE 0
          END                                         AS EXTN_CNT                    --展期次数
        ,'01'                                         AS DSBR_MODE                   --放款方式
        ,TTE.TAR_VALUE_CODE                           AS INT_CALC_MODE               --计息方式
        ,NULL                                         AS MRGN_PCT                    --保证金比例
        ,NULL                                         AS MRGN_CUR                    --保证金币种
        ,NULL                                         AS MRGN                        --保证金
        ,NULL                                         AS MRGN_ACC                    --保证金账号
        ,A.CUST_MGR_ID                                AS LOAN_OFR_NO                 --信贷员工号
        ,A.CURRT_ACRU_INT                             AS ACCRD_INT                   --应计利息
        ,NULL                                         AS PRO_IMPT                    --减值准备
        ,NULL                                         AS COM_PRO                     --一般准备
        ,NULL                                         AS SPCL_PRO                    --专项准备
        ,NULL                                         AS ESP_PRO                     --特别准备
        ,NULL                                         AS SPCL_LOAN_FLG               --专项贷款标志
        ,NULL                                         AS ORIG_RCPT_NO                --原借据号
         --MOD BY LIP 20230915 根据吴楚非的口径调整网商贷的出资比例
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                   AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN 100 --债权直转的出资比例 100
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                   AND A.DISTR_DT >= TO_DATE('20180901','YYYYMMDD')
                   AND A.DISTR_DT < TO_DATE('20190901','YYYYMMDD')) --日期带时间戳，用小于下一天
              THEN 90
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                   AND A.DISTR_DT >= TO_DATE('20190901','YYYYMMDD')
                   AND A.DISTR_DT < TO_DATE('20201208','YYYYMMDD'))
              THEN 100
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                   AND A.DISTR_DT >= TO_DATE('20201208','YYYYMMDD')
                   AND A.DISTR_DT < TO_DATE('20211125','YYYYMMDD'))
              THEN 90
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                   AND A.DISTR_DT >= TO_DATE('20211125','YYYYMMDD')
                   AND A.DISTR_DT < TO_DATE('20230412','YYYYMMDD'))
              THEN 65
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                   AND A.DISTR_DT >= TO_DATE('20230412','YYYYMMDD'))
              THEN 70
              WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'C' --保证
                   AND A.DISTR_DT >= TO_DATE('20230101','YYYYMMDD'))
              THEN 70
              ELSE HZF.BHCZBL*100
          END                                         AS FND_PCT                     --出资比例
        ,TRIM(A.ENTER_ACCT_ACCT_NUM)                  AS ETR_ACC                     --入账账号
        ,CASE WHEN A.STD_PROD_ID IN ('202010100004') OR TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN E.CUST_NAME
          END                                         AS ETR_ACC_NM                  --入账账号户名
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006') AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
              WHEN A.STD_PROD_ID IN ('202010100004') THEN '京东'  --modify by hulj 20221107 更改标准产品编号
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                         AS LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
        ,CASE WHEN TRIM(A.REPAY_NUM) IS NOT NULL THEN TRIM(A.REPAY_NUM)
              ELSE TRIM(A.ENTER_ACCT_ACCT_NUM)
          END                                         AS REPY_ACC                    --还款账号
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006') AND NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL THEN '微信'
              WHEN A.STD_PROD_ID IN ('202010100004') THEN '京东'  --modify by hulj 20221107 更改标准产品编号
              WHEN NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL THEN '支付宝'
          END                                         AS LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
        ,CASE WHEN A.OVDUE_FLG = '1' THEN 'B'
              WHEN A.WRT_OFF_FLG = '1' THEN 'C0201'
              ELSE TTF.TAR_VALUE_CODE
          END                                         AS RCPT_STAT                   --借据状态
        ,CASE WHEN A.CONT_STATUS_CD = 'NORMAL' THEN '01'   --正常
              WHEN A.CONT_STATUS_CD = 'OVD' THEN '01'   --逾期
              WHEN A.CONT_STATUS_CD = 'CLEAR' THEN '02'   --结清
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) = 0
                   AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN '02'
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) > 0 THEN '01'
              ELSE TTG.TAR_VALUE_CODE
          END                                         AS ACC_STAT                    --账户状态
        ,'N'                                          AS REV_LOAN_FLG                --循环贷贷款标志
        ,NULL                                         AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
        ,NULL                                         AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
        ,CASE WHEN A.DOM_OVERS_FLG IN('1','@1') THEN 'Y'
              WHEN A.DOM_OVERS_FLG ='0' THEN 'N' --MODIFY BY MW 20221103 1:境内 0：境外
              ELSE 'Z'
          END                                         AS BIO_LOAN_FLG                --境内外标志
        ,'800924'                                     AS DEPT_LINE                   --部门条线
        ,'联合网贷'                                   AS DATA_SRC                    --数据来源
        ,A.DUBIL_ID                                   AS LMT_CONT_ID                 --额度合同编号
        ,A.REPAY_WAY_CD                               AS GXH_PAY_TYPE                --还款方式
        ,A.PRIC_REPAY_FREQ_CD                         AS GXH_PAY_FREQ                --还款频度
        ,'Y'                                          AS LOAN_DIR_BIO_FLG            --贷款投向境内外标识
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_INT, 0)
          END                                         AS OVD_INT_BAL                 --逾期利息金额
        ,'N'                                          AS REFAC_FLG                   --支小再贷款标识
        ,NULL                                         AS BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                         AS LOAN_MODAL_CD               --贷款形态代码
        ,NULL                                         AS OPER_ORG_ID                 --经办机构编号
        ,NULL                                         AS OPER_TELLER_ID              --经办柜员编号
        ,H2.LOAN_ACT_DSTR_DT                          AS LOAN_ACT_FIRST_DT           --本行首贷日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS RENEW_EXP_DAY               --展期到期日期
        ,TO_CHAR(TFF.FIR_WRT_OFF_DT ,'YYYYMMDD')      AS CNCL_DT                     --核销日期
        ,A.INT_RAT_ADJ_WAY_CD                         AS FIXED_INT_MARK              --利率是否固定
        ,A.INTNAL_CARR_FLG                            AS INTNAL_CARR_FLG             --内部结转标志
        ,A.CRED_RHT_TURN_FLG                          AS CRED_RHT_TURN_FLG           --债权直转标志 add by hulj20230914
        ,A.LOAN_TYPE_CD                               AS LOAN_TYPE_CD                --借据类型代码 add by hulj20230914
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')               AS DISTR_DT                    --放款日期（网商贷直转 转入日期） ADD BY LYH 20231012
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
              THEN A.REGROUP_FLG
              ELSE '0'
          END                                         AS REGROUP_LOAN_FLG            --重组贷款标志  ADD BY LYH 20260309
        ,NULL                                         AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
        ,NULL                                         AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
        ,NULL                                         AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO M  --标准产品信息
      ON M.PROD_ID = A.STD_PROD_ID
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
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO TFF --联合网贷核销信息
      ON TFF.DUBIL_ID = A.DUBIL_ID
     AND TFF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04_BFD AC --精准扶贫按客户整合
      ON AC.CUST_ID = A.CUST_ID
     AND AC.ACCT_DURAN = '2021-04'
    LEFT JOIN RRP_MDL.ADD_POVERTY_RELIF AD  --精准扶贫名录20211231填报数据基表
      ON AD.LOAN_NUM = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD PUB   --公共代码表 取贷款用途
      ON PUB.CD_ID = 'CD1274'
     AND PUB.CD_VAL = A.LOAN_USAGE_CD
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTB  --码值映射表(贷款用途)
      ON TTB.SRC_VALUE_CODE = A.LOAN_USAGE_CD
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
    LEFT JOIN RRP_MDL.CODE_MAP TI --利率种类转码
      ON TI.SRC_VALUE_CODE = A.INT_RAT_BASE_TYPE_CD
     AND TI.SRC_CLASS_CODE = 'CD1010'
     AND TI.TAR_CLASS_CODE = 'Z0015'
     AND TI.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTK   --利率类型转码
      ON TTK.SRC_VALUE_CODE = A.INT_RAT_FLOAT_WAY_CD
     AND TTK.SRC_CLASS_CODE = 'CD1016'
     AND TTK.TAR_CLASS_CODE = 'Z0007'
     AND TTK.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TTL --利率调整频率
      ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
     AND TTL.SRC_CLASS_CODE = 'CD1041'
     AND TTL.TAR_CLASS_CODE = 'D0105'
     AND TTL.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TTM  --担保方式转码
      ON TTM.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TTM.SRC_CLASS_CODE = 'CD2656'
     AND TTM.TAR_CLASS_CODE = 'D0002'
     AND TTM.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00_BFD H2
      ON H2.RCPT_ID = A.DUBIL_ID  --ADD BY 20221122 hulj  取是否首贷日期
    LEFT JOIN (SELECT DUBIL_ID,MAX(REPAYBL_DT) AS REPAYBL_DT   --应还款日期
                 FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN --联合网贷还款计划
                WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY DUBIL_ID) K
      ON K.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN (SELECT STD_PROD_ID   AS STD_PROD_ID  --标准产品编号
                     ,MIN(HZFS)     AS HZFS         --合作方式
                     ,MAX(BHCZBL)   AS BHCZBL       --本行出资比例
                 FROM RRP_MDL.M_DICT_G09_HZF --G09互联网贷款产品信息静态表
                GROUP BY STD_PROD_ID) HZF   --ADD BY WEIYONGZHAO 20230523 关联取网贷产品和类别
      ON HZF.STD_PROD_ID = A.STD_PROD_ID
   WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.DUBIL_ID IS NOT NULL
     --ADD BY LYH 20251111
     AND A.ETL_DT IN (CASE WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') --分期乐、微业贷3.0 T-1
                           THEN TO_DATE(V_YESTADAY,'YYYYMMDD')
                           ELSE TO_DATE(V_P_DATE,'YYYYMMDD')
                       END )
     AND A.ETL_DT IN (TO_DATE(V_P_DATE,'YYYYMMDD'),TO_DATE(V_YESTADAY,'YYYYMMDD'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 10;
  V_STEP_DESC := '表内借据信息--汇总';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD
    (DATA_DT                             --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,THIRD_RCPT_ID                       --第三方借据编号  ADD BY YJY 20250521
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
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
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
    ,SYS_IN_FLG                          --系统内标识
    ,HXB_ACPT_FLG                        --我行承兑标识
    ,BILL_SUB_INTRV_ID                   --子票据区间编号
    ,BILL_ID                             --票据编号
    ,BATCH_ID                            --批次编号
    ,INTNAL_CARR_FLG                     --内部结转标志
    ,LC_BENEFC                           --信用证受益人
    ,FIX_INT_RAT_FLG                     --固定利率标志
    ,LC_ISSUER                           --信用证开证人
    ,CRED_RHT_TURN_FLG                   --债权直转标志 ADD BY HULJ20230914
    ,LOAN_TYPE_CD                        --借据类型代码 ADD BY HULJ20230914
    ,DISTR_DT                            --放款日期（网商贷直转 转入日期） ADD BY LYH 20231012
    ,ACCT_MODIF_CATE_CD                  --账户变更类别代码      ADD BY LYH 20260127
    ,REGROUP_LOAN_FLG                    --重组贷款标志  ADD BY LYH 20260309
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    )
  SELECT DISTINCT
         DATA_DT                             --数据日期
        ,LGL_REP_ID                          --法人编号
        ,ACC_ID                              --账户编号
        ,RCPT_ID                             --借据编号
        ,THIRD_RCPT_ID                       --第三方借据编号  ADD BY YJY 20250521
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
        ,LOAN_HDL_CHAN                       --贷款办理渠道
        ,NET_LOAN_FLG                        --互联网贷款标志
        ,NET_LOAN_PROD_TYP                   --网贷产品类别
        ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
        ,REPY_MODE                           --还款方式
        ,LOAN_FRM                            --贷款形式
        ,RCMM_LOAN_FLG                       --重组贷款标识
        ,ADJ_BAD_FLG                         --下调为不良标志
        ,ALDY_RCMM_FLG                       --曾重组标志
        ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
        ,CASH_TRF_FLG                        --现转标志
        ,FST_LOAN_FLG                        --首贷户贷款标志
        ,FIRST_LOAN_FLG                      --首次贷款标志
        ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
        ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
        ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
        ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
        ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
        ,RATE_RE_PRC_DT                      --利率重新定价日期
        ,RATE_FLT_FREQ                       --利率浮动频率
        ,RATE_TYP                            --利率类型
        ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
        ,EXEC_RATE                           --执行利率
        ,BASE_RATE                           --基准利率
        ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
        ,RATE_FLT_VAL                        --利率浮动值
        ,PRC_BASE_TYP                        --定价基准类型
        ,TOT_PRD_NUM                         --总期数
        ,CURR_PRD                            --当前期数
        ,CUM_DEBT_PRD_NUM                    --累计欠款期数
        ,CNU_DEBT_PRD_NUM                    --连续欠款期数
        ,EXTN_CNT                            --展期次数
        ,DSBR_MODE                           --放款方式
        ,INT_CALC_MODE                       --计息方式
        ,MRGN_PCT                            --保证金比例
        ,MRGN_CUR                            --保证金币种
        ,MRGN                                --保证金
        ,MRGN_ACC                            --保证金账号
        ,LOAN_OFR_NO                         --信贷员工号
        ,ACCRD_INT                           --应计利息
        ,PRO_IMPT                            --减值准备
        ,COM_PRO                             --一般准备
        ,SPCL_PRO                            --专项准备
        ,ESP_PRO                             --特别准备
        ,SPCL_LOAN_FLG                       --专项贷款标志
        ,ORIG_RCPT_NO                        --原借据号
        ,FND_PCT                             --出资比例
        ,ETR_ACC                             --入账账号
        ,ETR_ACC_NM                          --入账账号户名
        ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
        ,REPY_ACC                            --还款账号
        ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
        ,RCPT_STAT                           --借据状态
        ,ACC_STAT                            --账户状态
        ,REV_LOAN_FLG                        --循环贷贷款标志
        ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
        ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
        ,BIO_LOAN_FLG                        --境内外标志
        ,DEPT_LINE                           --部门条线
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
        ,SYS_IN_FLG                          --系统内标识
        ,HXB_ACPT_FLG                        --我行承兑标识
        ,BILL_SUB_INTRV_ID                   --子票据区间编号
        ,BILL_ID                             --票据编号
        ,BATCH_ID                            --批次编号
        ,INTNAL_CARR_FLG                     --内部结转标志
        ,LC_BENEFC                           --信用证受益人
        ,FIX_INT_RAT_FLG                     --固定利率标志
        ,LC_ISSUER                           --信用证开证人
        ,CRED_RHT_TURN_FLG                   --债权直转标志 add by hulj20230914
        ,LOAN_TYPE_CD                        --借据类型代码 add by hulj20230914
        ,NVL(DISTR_DT,LOAN_ACT_DSTR_DT)      --放款日期（网商贷直转 转入日期） ADD BY LYH 20231012
        ,ACCT_MODIF_CATE_CD                  --账户变更类别代码 --ADD BY LYH 20260127
        ,REGROUP_LOAN_FLG                    --重组贷款标志  ADD BY LYH 20260309
        ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
        ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
        ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP_BFD
   WHERE RCPT_ID IS NOT NULL;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    
  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := 11;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1),DATA_SRC
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD T
     WHERE DATA_DT IN (V_P_DATE)
     GROUP BY DATA_DT, RCPT_ID,DATA_SRC
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;
  WITH TMP2 AS (
    SELECT DATA_DT, RCPT_ID,COUNT(1),DATA_SRC
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_BFD T
     WHERE DATA_DT IN (V_YESTADAY)
     GROUP BY DATA_DT, RCPT_ID,DATA_SRC
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP2;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  ETL_DBMS_STATS(V_YESTADAY, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_YESTADAY,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STEP := 11;
  V_STARTTIME := SYSDATE;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_IN_DUBILL_INFO_BFD;
/

