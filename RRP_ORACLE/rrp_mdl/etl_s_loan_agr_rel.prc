CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_AGR_REL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_AGR_REL
  *  功能描述：涉农贷款整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CUST_IND_INFO
  *            M_GUA_REL_COLL
  *            M_GUA_COLL_INFO
  *            M_LOAN_DISC_INT_SUB
  *            S_LOAN
  *            M_CUST_CORP_INFO
  *            M_GUA_REL_BSN_CONT
  *            M_LOAN_AGR_REL_SUB
  *
  *
  *  目标表：  S_LOAN_AGR_REL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230103  于敬艺   1）、新增贷款投向境内外标识、贷款余额净值、经营授信总额
  *                                     2）、修改农村集体经济组织贷款标志，从对公客户信息表出
  *            2     20230425   HYF     新增标准产品编号
  *            3     20230922   LWB    涉农贷款剔除贴现的数据
  *            4     20240124   HYF    新增放款时涉农标志、放款时客户类型、年化收益
  *            5     20240523   HYF    新增种业振兴贷款标志、县城区贷款标志
  *            6     20240920   HYF    修改主担保方式逻辑按照统计担保方式加工
  *            7     20250514   HYF    新增放款机构号将891转出的机构号固定，方便报表累放指标出数
  *            8     20260408   HYF    修改主担保方式逻辑，优先判定抵质押，其次到保证，最后是信用
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;            --处理步骤
  V_STEP_DESC VARCHAR2(1000);           --处理步骤描述
  V_P_DATE    VARCHAR2(8);             --跑批数据日期
  V_STARTTIME DATE;                    --处理开始时间
  V_ENDTIME   DATE;                    --处理结束时间
  V_SQLCOUNT  INTEGER := 0;            --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);           --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);           --分区名
  V_TAB_NAME  VARCHAR2(100) := 'S_LOAN_AGR_REL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_AGR_REL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN_AGR_REL T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  --EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '涉农贷款整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_AGR_REL
    (DATA_DT,                        --数据日期
     LGL_REP_ID,                     --法人编号
     ORG_ID,                         --机构编号
     RCPT_ID,                        --借据编号
     CUST_ID,                        --客户编号
     CUR,                            --币种
     LOAN_BAL,                       --贷款余额
     --LOAN_AMT,                     --放款金额
     LOAN_AMT,                       --放款金额
     LOAN_ACT_DSTR_DT,               --贷款实际发放日期
     LOAN_ORIG_EXP_DT,               --贷款原始到期日期
     LOAN_TERM,                      --贷款期限
     OVD_DAYS,                       --逾期天数
     LOAN_BIZ_TYP,                   --贷款业务类型
     LOAN_DIR_IDY,                   --贷款投向行业
     ACT_RATE,                       --实际利率
     BASE_RATE,                      --基准利率
     LPR,                            --LPR利率
     OCG_RATE_LVL,                   --按利率水平
     LVL5_CL,                        --五级分类
     MAIN_GUA_MODE,                  --主要担保方式
     CORP_CUST_TYP,                  --对公客户类型
     OPR_CUST_TYP,                   --经营性客户类型
     ENT_SCALE,                      --企业规模
     SYN_LOAN_FLG,                   --银团贷款标志
     AGR_REL_LOAN_CHAR,              --涉农贷款性质
     AGR_REL_LOAN_BIZ_TYP,           --涉农贷款业务类型
     FARM_FLG,                       --农户标志
     CRDT_FLG,                       --信用户标志
     CONT_SIDE_FARM_FLG,             --承包方农户标志
     VIL_CITY_FLG,                   --农村城市标志
     FAMILY_FARM_LOAN_FLG,           --家庭农场贷款标志
     AGR_LDR_ENT_FLG,                --农业产业化龙头企业贷款标志
     FARMER_PROF_COOP_FLG,           --农民专业合作社贷款标志
     AGR_PROF_BIG_CUST_LOAN_FLG,     --农业专业大户贷款标志
     AGR_CPRSV_DVLP_LOAN_FLG,        --农业综合开发贷款标志
     FARMER_COOP_LOAN_FLG,           --农民合作社贷款标志
     VIL_COLLTV_ECON_ORG_LOAN_FLG,   --农村集体经济组织贷款标志
     TWO_RT_LOAN_GUA_MODE,           --两权贷款担保方式
     VIL_THREE_RT_MTG_LOAN_CL,       --农村三权抵押贷款分类
     CNTRL_FINC_CUM_DISC_INT_AMT,    --中央财政累计贴息金额
     LCL_FINC_CUM_DISC_INT_AMT,      --地方财政累计贴息金额
     SGL_CRDT_AMT,                   --单户授信金额
     OPR_CRDT_TOT_AMT,               --经营授信总额
     COLL_VAL,                       --押品价值
     RCPT_STAT,                      --借据状态
     JUR_FLG,                        --辖内标志
     LAND_THIRDPARTY_LOAN_TYP,       --将承包土地的经营权抵押给第三方的担保贷款类型
     FARMER_THIRDPARTY_LOAN_TYP,     --将农民住房财产权抵押给第三方的担保贷款类型
     CBRC_FLG,                       --CBRC标识
     BIO_LOAN_FLG,                   --境内外贷款标志
     DEPT_LINE,                      --部门条线
     DATA_SRC,                       --数据来源
     AGCLT_LOAN_MAIN_TYPE_CD,        --涉农贷款主体类型代码
     FAIR_VAL_CHG,                   --公允价值变动
     INT_ADJ,                        --调整利息
     CUST_NAME,                      --客户名称
     LOAN_DIR_BIO_FLG,               --贷款投向境内外标识
     LOAN_NET_VAL,                   --贷款余额净值
     IS_CBRC_ENT,                    --是否企业（银监）
     STD_PROD_ID,                    --标准产品编号
     FKSSNBZ,                        --放款时涉农标志
     FKSKHLX,                        --放款时客户类型
     INCOME_ANNUAL,                  --年化收益
     SEED_LOAN_FLG,                  --种业振兴贷款标志
     COUNTY_LOAN_FLG,                --县城区贷款标志
     FK_ORG_ID                       --累放层机构号
     )
  /*WITH TMP AS (
    SELECT \*+ MATERIALIZE*\ A.RCPT_ID
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --贷款业务整合表，剔除部分条件下放款日期在'20190930'之前的数据
     INNER JOIN RRP_MDL.M_LOAN_AGR_REL_SUB B --涉农贷款子表
        ON A.RCPT_ID = B.RCPT_ID
       AND B.DATA_DT = V_P_DATE
     WHERE \*A.AGR_REL_LOAN_FLG = 'Y'
       AND A.DATA_SRC IN ('对公信贷','零售贷款','联合网贷')
       AND*\ (B.FARM_LOAN_FLG = 'Y' OR
             (A.LOAN_BIZ_TYP LIKE '0102%'--个人经营性贷款
              AND (SUBSTR(A.LOAN_DIR_IDY,1,4) IN ('C201','C204','C262','C263','C357','F511','G595')
                  OR SUBSTR(A.LOAN_DIR_IDY, 1, 5) IN ('C1711','C1712','C1713','C1731','C1732','C1741',
                                                     'C1742','C2730','C2740','C2921','C3323','C4024',
                                                     'F5121','F5123','F5124','F5152','F5166','F5167',
                                                     'F5168','F5171','F5221','F5223','F5224','F5252',
                                                     'M7330','M7511','M7530'))))
       AND A.DISTR_DT <= '20190930'
       AND A.DATA_DT = V_P_DATE),*/
  WITH TMP1 AS (
    SELECT /*+ MATERIALIZE*/ RCPT_ID,SUM(COLL_SPLT_NEW_VAL) COLL_SPLT_NEW_VAL,
           SUM(RCPT_SPLT_BAL) RCPT_SPLT_BAL,SUM(COLL_SPLT_INIT_VAL) COLL_SPLT_INIT_VAL
      FROM RRP_MDL.M_GUA_COLL_VAL_SPLT YP  --资产借据分配历史 --20220929 XUXIAOBIN MODIFY
     WHERE YP.DATA_DT = V_P_DATE
     GROUP BY RCPT_ID)
  SELECT /* +USER_HASH(A B C D ) LEADDING A*/
         A.DATA_DT                            AS DATA_DT,                         --数据日期
         A.LGL_REP_ID                         AS LGL_REP_ID,                      --法人编号
         A.ORG_ID                             AS ORG_ID,                          --机构编号
         A.RCPT_ID                            AS RCPT_ID,                         --借据编号
         A.CUST_ID                            AS CUST_ID,                         --客户编号
         A.CUR                                AS CUR,                             --币种
         A.LOAN_BAL                           AS LOAN_BAL,                        --贷款余额
         --A.LOAN_AMT                           AS LOAN_AMT,                        --放款金额
         A.LOAN_AMT                           AS LOAN_AMT,                        --放款金额
         A.LOAN_ACT_DSTR_DT                   AS LOAN_ACT_DSTR_DT,                --贷款实际发放日期
         A.LOAN_ORIG_EXP_DT                   AS LOAN_ORIG_EXP_DT,                --贷款原始到期日期
         A.LOAN_TERM                          AS LOAN_TERM,                       --贷款期限
         A.OVD_DAYS                           AS OVD_DAYS,                        --逾期天数
         A.LOAN_BIZ_TYP                       AS LOAN_BIZ_TYP,                    --贷款业务类型
         A.LOAN_DIR_IDY                       AS LOAN_DIR_IDY,                    --贷款投向行业
         A.ACT_RATE                           AS ACT_RATE,                        --实际利率
         A.BASE_RATE                          AS BASE_RATE,                       --基准利率
         CASE WHEN A.PRC_BASE_TYP = 'TR07' THEN A.BASE_RATE
              ELSE 0
          END                                 AS LPR,                             --LPR利率
         CASE WHEN A.BASE_RATE = 0 OR A.BASE_RATE IS NULL THEN 0
              ELSE ROUND(A.ACT_RATE / A.BASE_RATE, 4)
          END                                 AS OCG_RATE_LVL,                    --按利率水平
         A.LVL5_CL                            AS LVL5_CL,                         --五级分类
         --A.GUA_MODE                           AS MAIN_GUA_MODE,                   --主要担保方式
         --子担保方式采用两套码值兜底，目前信贷供数存的是ABCD而非标准的子担保方式码值1234
         CASE WHEN A.GUA_MODE = '1' OR F.SUB_GUA_MODE IN ('B','3') THEN '1' --抵押
              WHEN A.GUA_MODE = '2' OR F.SUB_GUA_MODE IN ('A','4') THEN '2' --质押
              WHEN A.GUA_MODE = '3' OR F.SUB_GUA_MODE IN ('C','2') THEN '3' --保证
              WHEN A.GUA_MODE = '4' OR F.SUB_GUA_MODE IN ('D','1') THEN '4' --信用
         END                                  AS MAIN_GUA_MODE,                   --主要担保方式       
         A.CORP_CUST_TYP                      AS CORP_CUST_TYP,                   --对公客户类型
         A.OPR_CUST_TYP                       AS OPR_CUST_TYP,                    --经营性客户类型
         A.ENT_SCALE                          AS ENT_SCALE,                       --企业规模
         A.SYN_LOAN_FLG                       AS SYN_LOAN_FLG,                    --银团贷款标志
         B.AGR_REL_LOAN_CHAR                  AS AGR_REL_LOAN_CHAR,               --涉农贷款性质
         B.AGR_REL_LOAN_BIZ_TYP               AS AGR_REL_LOAN_BIZ_TYP,            --涉农贷款业务类型
         NVL(A.FARM_FLG,'N')                  AS FARM_FLG,                        --农户标志
         D.CRDT_FLG                           AS CRDT_FLG,                        --信用户标志
         D.CONT_SIDE_FARM_FLG                 AS CONT_SIDE_FARM_FLG,              --承包方农户标志
         C.VIL_CITY_FLG                       AS VIL_CITY_FLG,                    --农村城市标志
         B.FAMILY_FARM_LOAN_FLG               AS FAMILY_FARM_LOAN_FLG,            --家庭农场贷款标志
         B.AGR_LDR_ENT_FLG                    AS AGR_LDR_ENT_FLG,                 --农业产业化龙头企业贷款标志
         C.FARMER_PROF_COOP_FLG               AS FARMER_PROF_COOP_FLG,            --农民专业合作社贷款标志
         B.AGR_PROF_BIG_CUST_LOAN_FLG         AS AGR_PROF_BIG_CUST_LOAN_FLG,      --农业专业大户贷款标志
         B.AGR_CPRSV_DVLP_LOAN_FLG            AS AGR_CPRSV_DVLP_LOAN_FLG,         --农业综合开发贷款标志
         B.FARMER_COOP_LOAN_FLG               AS FARMER_COOP_LOAN_FLG,            --农民合作社贷款标志
         --B.VIL_COLLTV_ECON_ORG_LOAN_FLG     AS VIL_COLLTV_ECON_ORG_LOAN_FLG,    --农村集体经济组织贷款标志
         C.VIL_COLLTV_ECON_ORG_FLG            AS VIL_COLLTV_ECON_ORG_LOAN_FLG,    --农村集体经济组织贷款标志 UPDATE BY 于敬艺 20230103
         B.TWO_RT_LOAN_GUA_MODE               AS TWO_RT_LOAN_GUA_MODE,            --两权贷款担保方式
         B.VIL_THREE_RT_MTG_LOAN_CL           AS VIL_THREE_RT_MTG_LOAN_CL,        --农村三权抵押贷款分类
         CASE WHEN E.DISC_INT_LOAN_TYP LIKE '1%' THEN E.PAID_IN_DISC_INT_AMT
              ELSE 0
          END                                  AS CNTRL_FINC_CUM_DISC_INT_AMT,    --中央财政累计贴息金额
         CASE WHEN E.DISC_INT_LOAN_TYP LIKE '2%' THEN E.PAID_IN_DISC_INT_AMT
              ELSE 0
          END                                  AS LCL_FINC_CUM_DISC_INT_AMT,      --地方财政累计贴息金额
         A.SGL_CRDT_AMT                        AS SGL_CRDT_AMT,                   --单户授信金额
         A.OPR_CRDT_TOT_AMT                    AS OPR_CRDT_TOT_AMT,               --经营授信总额
         /*H.BANK_IDNT_PRC_VAL                   AS COLL_VAL,                       --押品价值*/
         YP.COLL_SPLT_NEW_VAL                  AS COLL_VAL,                       --押品价值
         A.RCPT_STAT                           AS RCPT_STAT,                      --借据状态
         D.JUR_FLG                             AS JUR_FLG,                        --辖内标志
         B.LAND_THIRDPARTY_LOAN_TYP            AS LAND_THIRDPARTY_LOAN_TYP,       --将承包土地的经营权抵押给第三方的担保贷款类型
         B.FARMER_THIRDPARTY_LOAN_TYP          AS FARMER_THIRDPARTY_LOAN_TYP,     --将农民住房财产权抵押给第三方的担保贷款类型
         'Y'                                   AS CBRC_FLG,                       --CBRC标识
         A.BIO_LOAN_FLG                        AS BIO_LOAN_FLG,                   --境内外贷款标志
         A.DEPT_LINE                           AS DEPT_LINE,                      --部门条线
         A.DATA_SRC                            AS DATA_SRC,                       --数据来源
         B.AGCLT_LOAN_MAIN_TYPE_CD             AS AGCLT_LOAN_MAIN_TYPE_CD,        --涉农贷款主体类型代码
         A.FAIR_VAL_CHG                        AS FAIR_VAL_CHG,                   --公允价值变动
         A.INT_ADJ                             AS INT_ADJ,                        --调整利息
         NVL(C.CUST_NM,D.CUST_NM)              AS CUST_NAME,                      --客户名称
         A.LOAN_DIR_BIO_FLG                    AS LOAN_DIR_BIO_FLG,               --贷款投向境内外标识 ADD BY 于敬艺 20230103
         NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) AS LOAN_NET_VAL,--贷款余额净值 ADD BY 于敬艺 20230103
         A.IS_CBRC_ENT                         AS IS_CBRC_ENT,                    --是否企业（银监）
         A.STD_PROD_ID                         AS STD_PROD_ID,                    --标准产品编号
         A.FKSSNBZ                             AS FKSSNBZ,                        --放款时涉农标志
         A.FKSKHLX                             AS FKSKHLX,                        --放款时客户类型
         A.INCOME_ANNUAL                       AS INCOME_ANNUAL,                  --年化收益
         A.SEED_LOAN_FLG                       AS SEED_LOAN_FLG,                  --种业振兴贷款标志
         A.COUNTY_LOAN_FLG                     AS COUNTY_LOAN_FLG,                --县城区贷款标志
         A.FK_ORG_ID                           AS FK_ORG_ID                       --累放层机构号
    FROM RRP_MDL.S_LOAN A --贷款业务整合表
   INNER JOIN RRP_MDL.M_LOAN_AGR_REL_SUB B --涉农贷款子表
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = A.CUST_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_DISC_INT_SUB E --贴息贷款子表
      ON E.RCPT_ID = B.RCPT_ID
     AND E.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO F --贷款合同信息
      ON F.CONT_ID = A.CONT_ID
     AND F.DATA_DT = V_P_DATE     
    LEFT JOIN TMP1 YP
      ON YP.RCPT_ID = A.RCPT_ID
    /*LEFT JOIN RRP_MDL.M_GUA_REL_BSN_CONT F --担保合同和业务合同对应关系表
      ON F.BIZ_CONT_ID = A.CONT_ID
     AND F.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_GUA_REL_COLL G --担保合同与押品对应关系表
      ON G.GUA_CONT_ID = F.GUA_CONT_ID
     AND G.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_GUA_COLL_INFO H --抵质押物详细信息
      ON H.COLL_ID = G.COLL_ID
     AND H.DATA_DT = V_P_DATE*/
   WHERE /*A.AGR_REL_LOAN_FLG = 'Y'
     AND NOT EXISTS (SELECT 1 FROM TMP A WHERE A.RCPT_ID = B.RCPT_ID)--按业务要求，剔除部分条件下放款日期在'20190930'之前的数据
     AND A.DATA_SRC IN ('对公信贷','零售贷款','联合网贷')
     AND*/ A.DATA_SRC <> '票据贴现'
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款业务整合表--查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN_AGR_REL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP      := 4;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_AGR_REL;
/

