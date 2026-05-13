CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_AMT_S71_LIUYUINIT(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_AMT_S71
  *  功能描述：S71普惠小微发放时授信额度表
  *  创建日期：20230217
  *  开发人员：刘宇
  *  来源表：   S_LOAN
  *  目标表：   S_LOAN_AMT_S71
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
*     1    20230424  liuyu    初始化授信逻辑
      2    20230522  liuyu    优化取=当月，优化日志
  **********************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;    -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_AMT_S71_LIUYUINIT'; -- 程序名称
  V_P_DATE  VARCHAR2(8);       -- 跑批数据日期
  V_STARTTIME DATE;            -- 处理开始时间
  V_ENDTIME DATE;              -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0;    -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);   -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30);    -- 来源系统
  V_STEP_DESC VARCHAR2(200);   --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_LAST_MONTH_END   VARCHAR2(8);       --上月末
  --V_THIS_MONTH_BEGIN VARCHAR2(8);       --本月初
  V_LAST_YEAR_END    VARCHAR2(8);       --上年末
  --V_THIS_YEAR_BEGIN  VARCHAR2(8);       --本年初
  V_FREQ_FLAG VARCHAR2(10);    --跑批频度标识
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_AMT_S71'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_MONTH_END   := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD');--上月末
  --V_THIS_MONTH_BEGIN := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');       --本月初
  V_LAST_YEAR_END    := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD');       --上年末
  --V_THIS_YEAR_BEGIN  := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD');       --本年初



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

  /*--判断跑批频度--

  V_FREQ_FLAG := FUN_FREQ(V_P_DATE,V_PROC_NAME);
  IF V_FREQ_FLAG='1' THEN*/

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表--加工上月末的授信总额';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_AMT_S71
  (
        DATA_DT                    ,        --数据日期
        ORG_NO                     ,        --机构号
        CUST_NO                    ,        --客户号
        RCPT_ID                    ,        --借据号
        CONT_ID                    ,        --合同编号
        RCPT_STAT                  ,        --借据状态
        CURR_CD                    ,        --币种
        LOAN_BIZ_TYP               ,        --贷款业务类型
        LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
        LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
        LVL5_CL                    ,        --五级分类
        LOAN_AMT                   ,        --放款金额
        LOAN_BAL                   ,        --贷款余额
        LOAN_NET_VAL               ,        --贷款净值
        STD_PROD_ID                ,        --标准产品编号
        LOAN_USEAGE                ,        --贷款用途
        INCOME_ANNUAL              ,        --年化收益
        FF_CRDT_TOTAL_LMT          ,        --发放时授信总额
        FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
        FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
        CBRC_FLG                   ,        --CBRC标志
        DSBR_FARM_FLG              ,        --放款时农户标志
        OPR_CUST_TYP               ,        --经营性客户类型
        NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
        LOAN_TERM                  ,        --贷款期限
        TJDBFS                     ,        --统计担保方式
        ENT_SCALE                  ,        --企业规模
        CORP_CUST_TYP              ,        --对公客户类型
        IS_CBRC_ENT                ,        --是否企业（银监）
        LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
        TECH_INNO_ENT_FLG          ,        --科创企业标志
        CUST_LRG_CL                ,        --客户大类
        DATA_SRC                   ,        --数据来源
        QTGRFNH                             --其他个人非农户标识
  )

  SELECT
        V_P_DATE        AS DATA_DT               --数据日期
       ,A.ORG_NO        AS ORG_NO                --机构编号
       ,A.CUST_NO       AS CUST_NO               --客户编号
       ,A.RCPT_ID       AS RCPT_ID               --借据编号
       ,A.CONT_ID       AS CONT_ID               --合同编号
       ,A.RCPT_STAT     AS RCPT_STAT             --借据状态
       ,A.CURR_CD       AS CURR_CD                   --币种
       ,A.LOAN_BIZ_TYP  AS LOAN_BIZ_TYP          --贷款业务类型
       ,A.LOAN_ACT_DSTR_DT
                        AS LOAN_ACT_DSTR_DT      --贷款实际发放日期
       ,A.LOAN_ORIG_EXP_DT
                        AS LOAN_ORIG_EXP_DT      --贷款原始到期日期
       ,A.LVL5_CL       AS LVL5_CL               --五级分类
       ,A.LOAN_AMT      AS LOAN_AMT              --放款金额
       ,A.LOAN_BAL      AS LOAN_BAL              --贷款余额
       ,A.LOAN_NET_VAL  AS LOAN_NET_VAL          --贷款净值
       ,A.STD_PROD_ID   AS STD_PROD_ID           --标准产品编号
       ,A.LOAN_USEAGE   AS LOAN_USEAGE           --贷款用途
       ,A.INCOME_ANNUAL AS INCOME_ANNUAL          --年化收益
       ,A.FF_CRDT_TOTAL_LMT
                        AS FF_CRDT_TOTAL_LMT      --发放时授信总额
       ,A.FF_OPR_CRDT_TOT_AMT
                        AS FF_OPR_CRDT_TOT_AMT    --发放经营授信总额
       ,A.FF_CON_CRDT_TOT_AMT
                        AS FF_CON_CRDT_TOT_AMT    --发放消费授信总额
       ,A.CBRC_FLG      AS CBRC_FLG               --CBRC标志
       ,A.DSBR_FARM_FLG AS DSBR_FARM_FLG          --放款时农户标志
       ,A.OPR_CUST_TYP  AS OPR_CUST_TYP           --经营性客户类型
       ,A.NON_REPY_PRIN_RENEW_FLG
                        AS NON_REPY_PRIN_RENEW_FLG   --无还本续贷标志
       ,A.LOAN_TERM     AS LOAN_TERM            --贷款期限
       ,A.TJDBFS        AS  TJDBFS              --统计担保方式
       ,A.ENT_SCALE     AS ENT_SCALE             --企业规模
       ,A.CORP_CUST_TYP AS CORP_CUST_TYP         --对公客户类型
       ,A.IS_CBRC_ENT   AS  IS_CBRC_ENT          --是否企业（银监）
       ,A.LOAN_DIR_BIO_FLG
                        AS LOAN_DIR_BIO_FLG      --贷款投向境内外标识
       ,A.TECH_INNO_ENT_FLG
                        AS TECH_INNO_ENT_FLG     --科创企业标志
       ,A.CUST_LRG_CL   AS CUST_LRG_CL           --客户大类
       ,A.DATA_SRC      AS DATA_SRC              --数据来源
       ,A.QTGRFNH       AS QTGRFNH               --其他个人非农户标识
   FROM RRP_MDL.S_LOAN_AMT_S71 A --S71普惠小微发放时授信额度表
  WHERE A.DATA_DT = V_LAST_MONTH_END  --上月末
    AND A.DATA_DT <> V_LAST_YEAR_END  --上年末 --上年的报送数据不纳入本年累计
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 -- 程序业务逻辑处理主体部分 --
 -- 初始化加工上月末数据

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表--加工当月发放的授信总额';
  V_STARTTIME := SYSDATE;
  INSERT  INTO RRP_MDL.S_LOAN_AMT_S71
  (
        DATA_DT                    ,        --数据日期
        ORG_NO                     ,        --机构号
        CUST_NO                    ,        --客户号
        RCPT_ID                    ,        --借据号
        CONT_ID                    ,        --合同编号
        RCPT_STAT                  ,        --借据状态
        CURR_CD                    ,        --币种
        LOAN_BIZ_TYP               ,        --贷款业务类型
        LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
        LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
        LVL5_CL                    ,        --五级分类
        LOAN_AMT                   ,        --放款金额
        LOAN_BAL                   ,        --贷款余额
        LOAN_NET_VAL               ,        --贷款净值
        STD_PROD_ID                ,        --标准产品编号
        LOAN_USEAGE                ,        --贷款用途
        INCOME_ANNUAL              ,        --年化收益
        FF_CRDT_TOTAL_LMT          ,        --发放时授信总额
        FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
        FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
        CBRC_FLG                   ,        --CBRC标志
        DSBR_FARM_FLG              ,        --放款时农户标志
        OPR_CUST_TYP               ,        --经营性客户类型
        NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
        LOAN_TERM                  ,        --贷款期限
        TJDBFS                     ,        --统计担保方式
        ENT_SCALE                  ,        --企业规模
        CORP_CUST_TYP              ,        --对公客户类型
        IS_CBRC_ENT                ,        --是否企业（银监）
        LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
        TECH_INNO_ENT_FLG          ,        --科创企业标志
        CUST_LRG_CL                ,        --客户大类
        DATA_SRC                   ,        --数据来源
        QTGRFNH                             --其他个人非农户标识
  )
  ---当月发放当月结清且期末没有有效授信的客户行内借据：
  WITH TMP1 AS(--零售&联合网贷，放款授信按照客户当月借据放款金额之和算当月授信
  SELECT A.CUST_ID
        ,SUM(A.LOAN_AMT)  AS LOAN_AMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP, 1, 4) NOT IN ('0104', '0103', '0101')
              THEN A.LOAN_AMT
              ELSE 0
         END)             AS FF_OPR_CRDT_TOT_AMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP, 1, 4) IN ('0104', '0103', '0101')
              THEN A.LOAN_AMT
              ELSE 0
         END)             AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = A.CUST_ID
     AND E.DATA_DT = V_P_DATE
   WHERE A.DATA_DT = '20230524'
     AND NVL(A.LOAN_BIZ_TYP, '0') NOT IN ('90', '99') ---剔除委托贷款、非标其他债券
     --AND A.SUBJ_ID NOT LIKE '810601%' -- 不能排除当年放款当年转让的数据
     AND A.DATA_SRC IN ('零售贷款', '联合网贷')
     AND (SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) =  SUBSTR(V_P_DATE,1,6)  --放款日期等于本月
           OR (A.DATA_SRC = '联合网贷'
            AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
            ))
     AND (NVL(E.CRDT_TOTAL_LMT, 0) = 0 OR E.CUST_ID IS NULL) -- 当月没关联上的就算
   GROUP BY A.CUST_ID
  ),
  TMP2 AS(--对公，放款授信按照客户借据对应额度合同金额之和算当月授信
  SELECT T.CUST_ID
        ,SUM(T.CONT_AMT) AS CONT_AMT
    FROM (SELECT A.CUST_ID
                ,D.CONT_ID
                ,D.CONT_AMT
            FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
            LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
              ON E.CUST_ID = A.CUST_ID
             AND E.DATA_DT = V_P_DATE
            LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO C -- 业务合同
              ON C.CONT_ID = A.CONT_ID
             AND C.DATA_DT = '20230524'
            LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO D -- 额度合同
              ON D.CONT_ID = C.CRDT_LMT_ID
             AND D.DATA_DT = '20230524'
           WHERE A.DATA_DT = '20230524'
             AND NVL(A.LOAN_BIZ_TYP, '0') NOT IN ('90', '99') ---剔除委托贷款、非标其他债券
             AND A.DATA_SRC IN ('对公信贷', '票据贴现')
             AND SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) =  SUBSTR(V_P_DATE,1,6)--放款日期等于本月
             AND (NVL(E.CRDT_TOTAL_LMT, 0) = 0 OR E.CUST_ID IS NULL) -- 当月没关联上的就算
           GROUP BY A.CUST_ID
                   ,D.CONT_ID
                   ,D.CONT_AMT) T
   GROUP BY T.CUST_ID
  ),
  TMP3 AS(
      --转贴现虽然调整了客户号，还是需要按照借据对应客户额度统计借据授信总额（按照信贷客户取授信） 20230228
      --20230301 又调整口径 转贴现直贴人有授信，取直贴人授信，没有则取借据放款金额
    SELECT A.DISCNT_CUST_ID
          ,SUM(A.LOAN_AMT) AS LOAN_AMT  -- 放款金额
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
        ON E.CUST_ID = NVL(A.DISCNT_CUST_ID, '-') -- 取直贴人客户号
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO C -- 业务合同
        ON C.CONT_ID = A.CONT_ID
       AND C.DATA_DT = '20230524'
     WHERE A.DATA_DT = '20230524'
       AND A.DATA_SRC IN ('票据转贴现')
       AND NVL(A.DISCNT_CUST_ID, '-') <> '-'
       AND SUBSTR(A.LOAN_ACT_DSTR_DT, 1, 6) = SUBSTR(V_P_DATE, 1, 6) --放款日期等于本月
       AND (NVL(E.CRDT_TOTAL_LMT, 0) = 0 OR E.CUST_ID IS NULL) -- 当月没关联上的就算
     GROUP BY A.DISCNT_CUST_ID
  )
  SELECT
        V_P_DATE        AS DATA_DT               --数据日期
       ,A.ORG_ID        AS ORG_NO                --机构编号
       ,A.CUST_ID       AS CUST_NO               --客户编号
       ,A.RCPT_ID       AS RCPT_ID               --借据编号
       ,A.CONT_ID       AS CONT_ID               --合同编号
       ,A.RCPT_STAT     AS RCPT_STAT             --借据状态
       ,A.CUR           AS CURR_CD                   --币种
       ,A.LOAN_BIZ_TYP  AS LOAN_BIZ_TYP          --贷款业务类型
       ,A.LOAN_ACT_DSTR_DT
                        AS LOAN_ACT_DSTR_DT      --贷款实际发放日期
       ,A.LOAN_ORIG_EXP_DT
                        AS LOAN_ORIG_EXP_DT      --贷款原始到期日期
       ,A.LVL5_CL       AS LVL5_CL               --五级分类
       ,A.LOAN_AMT      AS LOAN_AMT              --放款金额
       ,A.LOAN_BAL      AS LOAN_BAL              --贷款余额
       ,A.LOAN_NET_VAL  AS LOAN_NET_VAL          --贷款净值
       ,A.STD_PROD_ID
                        AS STD_PROD_ID           --标准产品编号
       ,A.LOAN_USEAGE   AS LOAN_USEAGE           --贷款用途
       ,A.INCOME_ANNUAL AS INCOME_ANNUAL          --年化收益
       ,COALESCE(T3.LOAN_AMT,T2.CONT_AMT,T1.LOAN_AMT,E.CRDT_TOTAL_LMT)
                        AS FF_CRDT_TOTAL_LMT      --发放时授信总额
       ,COALESCE(T1.FF_OPR_CRDT_TOT_AMT,E.OPR_CRDT_TOT_AMT,0)
                        AS FF_OPR_CRDT_TOT_AMT   --发放时经营授信总额
       ,COALESCE(T1.FF_CON_CRDT_TOT_AMT,NVL(E.CRDT_TOTAL_LMT,0)- NVL(E.OPR_CRDT_TOT_AMT,0))
                        AS FF_CON_CRDT_TOT_AMT   --发放时消费授信总额
       ,A.CBRC_FLG      AS CBRC_FLG               --CBRC标志
       ,A.DSBR_FARM_FLG
                        AS DSBR_FARM_FLG          --放款时农户标志
       ,A.OPR_CUST_TYP  AS OPR_CUST_TYP           --经营性客户类型
       ,A.NON_REPY_PRIN_RENEW_FLG
                        AS NON_REPY_PRIN_RENEW_FLG   --无还本续贷标志
       ,A.LOAN_TERM     AS LOAN_TERM            --贷款期限
       ,A.TJDBFS        AS TJDBFS              --统计担保方式
       ,A.ENT_SCALE     AS ENT_SCALE             --企业规模
       ,A.CORP_CUST_TYP AS CORP_CUST_TYP         --对公客户类型
       ,A.IS_CBRC_ENT   AS IS_CBRC_ENT          --是否企业（银监）
       ,A.LOAN_DIR_BIO_FLG
                        AS LOAN_DIR_BIO_FLG      --贷款投向境内外标识
       ,A.TECH_INNO_ENT_FLG
                        AS TECH_INNO_ENT_FLG     --科创企业标志
       ,A.CUST_LRG_CL   AS CUST_LRG_CL           --客户大类
       ,A.DATA_SRC      AS DATA_SRC              --数据来源
       ,''              AS QTGRFNH               --其他个人非农户标识   1-是 0-否
   FROM RRP_MDL.S_LOAN A --表内借据信息S层
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO B --表内借据表M层
     ON B.RCPT_ID = A.RCPT_ID
    AND B.DATA_DT = '20230524'
   LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
     ON E.CUST_ID = B.ICMS_CUST_ID -- 取信贷客户
    AND E.DATA_DT = V_P_DATE
   LEFT JOIN TMP1 T1
     ON T1.CUST_ID = A.CUST_ID --仅零售
   LEFT JOIN TMP2 T2
     ON T2.CUST_ID = A.CUST_ID --对公不含转贴现
   LEFT JOIN TMP3 T3
     ON T3.DISCNT_CUST_ID = A.CUST_ID --转贴现
   LEFT JOIN (SELECT
              A.CUST_ID --客户号
             ,A.BUSINFOEXISTFLAG --是否有效工商信息
             ,ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY APP_DT DESC ) AS RN
        FROM RRP_MDL.M_LOAN_APP_INFO A   --贷款申请信息
       WHERE A.DATA_DT = '20230524'
       ) G
     ON G.CUST_ID = A.CUST_ID
    AND G.RN = 1
  WHERE A.DATA_DT = '20230524'
    AND NVL(A.CUST_ID,'-') <> '-' -- 转帖现取不到客户号的剔除
    AND NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') ---剔除委托贷款、非标其他债券
    AND A.DATA_SRC IN ('零售贷款','联合网贷','对公信贷','票据贴现','票据转贴现')
    AND ( (A.DATA_SRC <> '联合网贷' AND SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) =  SUBSTR(V_P_DATE,1,6) )
           OR ( A.DATA_SRC = '联合网贷'
                AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
                AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') < LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD'))
            ));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S71普惠小微发放时授信额度表--查询数据是否重复';
  V_STARTTIME := SYSDATE;

    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN_AMT_S71 T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
 END IF;

   -- 如需要分析表，请用如下代码 --
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 /*   END IF;*/

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
     V_STEP := V_STEP + 1;
     V_ENDTIME := SYSDATE;
   O_ERRCODE := '1';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  END ETL_S_LOAN_AMT_S71_LIUYUINIT;
/

