CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_S71_BUSINESS
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_S71_BUSINESS
  *  功能描述：反映银行业金融机构对普惠金融重点领域的贷款支持情况，建立银行业普惠金融重点领域贷款统计指标体系。
               本表对我行普惠金融信息进行拓展定义，对公专用，以满足1104中S7101、SF7101报表中对普惠小微贷款需求。
  *  创建日期：20221031
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_FGB_S71_BUSINESS --普惠金融模型_对公
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人     修改原因
  *   1    20221101   liuyu      首次创建
  *   2    20230301   liuyu      按照业务口径重新调整逻辑
  *   3    20230530   liuyu      剔除转贴现ECIF客户号为空的数据
  *   4    20231108   LWB        新增放款时点的企业规模
  *   5    20240729   lwb        调整放款时企业规模的逻辑
  *   6    20260320   HYF        新增并购贷款类型、是否境外并购贷款、是否退役军人创办企业、放款月企业规模、放款月控股类型
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_S71_BUSINESS';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_S71_BUSINESS'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_S71_BUSINESS', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_FGB_S71_BUSINESS
    (    BGRQ                --001 报告日期
        ,JYWYM               --002 交易唯一码
        ,KHWYM               --003 客户唯一码
        ,ZWJGBH              --004 机构编号
        ,ZWJGMC              --005 机构名称
        ,DKLB                --006 贷款类别
        ,DGKHATJFL           --007 对公客户按统计分类
        ,SNDKFL              --008 涉农贷款分类
        ,TJDBFS              --009 统计担保方式
        ,SFWHBXD             --010 是否无还本续贷
        ,SXZED               --011 授信总额度（元）
        ,SXQJ_3000           --012 普惠授信区间（3000万）
        ,TJXWQYLB            --013 统计小微企业类别
        ,SFPHXWQY            --014 是否普惠小微企业
        ,TJYE                --015 统计余额（元）
        ,WJFL                --016 五级分类
        ,SFBL                --017 是否不良
        ,YSQSRQ              --018 原始起始日期
        ,YSDQRQ              --019 原始到期日期
        ,YSQXLB              --020 原始期限类别
        ,SFKCQY              --021 是否科创企业
        ,FKSSXED             --022 放款时授信额度（元）
        ,FKJE                --023 放款金额（元）
        ,ZXLL                --024 执行利率（年）
        ,NHLXSY              --025 年化利息收益（元）
        ,ZHWYM               --026 账户唯一码
        ,CUST_NAM            --027 客户中文名称
        ,FKSSFPHXWQY         --028 放款时是否普惠小微企业
        ,DEPARTMENTD         --029 归属系统
        ,FKSXQJ_3000         --030 放款时普惠授信区间（3000万）
        ,SXQJ_1000           --031 普惠授信区间(1000万)
        ,FKSXQJ_1000         --032 放款时普惠授信区间（1000万）
        ,BZCPMC              --033 标准产品名称
        ,ICMS_KHWYM          --034 信贷客户号
        ,ICMS_CUST_NAM       --035 信贷客户名称
        ,YWHTJE              --036 业务合同金额
        ,BGDKLX              --037 并购贷款类型
        ,SFTYJRCBQY          --038 是否退役军人创办企业
        ,FKSQYGM             --039 放款时企业规模        
        ,FKSKGLX             --040 放款时控股类型
        ,FKYQYGM             --041 放款月企业规模
        ,FKYKGLX             --042 放款月控股类型        
   )
   WITH TMP1 AS (
       SELECT T1.CUST_ID
              ,SUM(T1.LOAN_AMT) AS AMT --放款金额之和
         FROM RRP_MDL.S_LOAN T1
         LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T7  -- 授信额度表
           ON T7.CUST_ID = NVL(T1.CUST_ID,'-')
          AND T7.DATA_DT = V_P_DATE
        WHERE SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0302' --买断式转贴现
          AND T1.DATA_DT = V_P_DATE
          AND NVL(T1.CUST_ID,'-') <> '-'
          AND T1.LOAN_NET_VAL <> 0 -- 取余额不为0
          AND (NVL(T7.CRDT_TOTAL_LMT, 0) = 0 OR T7.CUST_ID IS NULL) --取当期没有授信直贴人
        GROUP BY T1.CUST_ID )
   SELECT
         T1.DATA_DT                                AS BGRQ         --001 报告日期
        ,T1.RCPT_ID                                AS JYWYM        --002 交易唯一码
        ,T1.CUST_ID                                AS KHWYM        --003 客户唯一码
        ,T1.ORG_ID                                 AS ZWJGBH       --004 机构编号
        ,T3.ORG_NM                                 AS ZWJGMC       --005 机构名称
        ,CASE WHEN (SUBSTR(T1.LOAN_BIZ_TYP, 1, 2) NOT IN ('03','04','05','07','90')
               AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) NOT IN ('0204','0205','0206'))
               AND TRIM(T1.LOAN_BIZ_TYP) IS NOT NULL
              THEN '普通贷款'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0301' THEN '贴现'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0302' THEN '买断式转贴现'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0204','0399') THEN '贸易融资'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0206' THEN '融资租赁'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0205' THEN '各项垫款'
              WHEN SUBSTR(T1.LOAN_BIZ_TYP, 1, 2) IN ('04','07') --从非金融机构买入返售资产/信用卡
              THEN '其他贷款'
              ELSE '不适用'
         END                                       AS DKLB         --006 贷款类别
        ,T1.CBRC_CUST_CL                           AS DGKHATJFL    --007 对公客户按统计分类
        ,CASE WHEN T5.AGCLT_LOAN_MAIN_TYPE_CD IN ('N22','N23') THEN '城市企业及各类组织涉农'
              WHEN T5.AGCLT_LOAN_MAIN_TYPE_CD IN ('N12','N13') THEN '农村企业及各类组织涉农'
         END                                       AS SNDKFL       --008 涉农贷款分类
        ,DECODE(T1.TJDBFS,'DZY','抵质押'
                         ,'BZ','保证'
                         ,'XY','信用'
                         ,'不适用')                AS TJDBFS       --009 统计担保方式
        ,CASE WHEN T1.NON_REPY_PRIN_RENEW_FLG = 'Y' THEN '是'
              WHEN T1.NON_REPY_PRIN_RENEW_FLG = 'N' THEN '否'
         END                                       AS SFWHBXD      --010 是否无还本续贷
        ,NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT)         AS SXZED        --011 授信总额度（元）
        ,CASE WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 1000000  THEN '单户授信100万元（含）以下'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 5000000  THEN '单户授信100-500万元（含）'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 10000000 THEN '单户授信500-1000万元（含）'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 30000000 THEN '单户授信1000-3000万元（含）'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) > 30000000  THEN '单户授信3000万元以上'
              ELSE '不适用'
         END                                       AS SXQJ_3000     --012 普惠授信区间（3000万）
        ,/*CASE WHEN T1.IS_CBRC_ENT = 'Y' THEN  -- 当客户为企业的前提下，取统计小微企业类别*/
         CASE WHEN T1.ENT_SCALE = 'S' THEN '小型企业'
              WHEN T1.ENT_SCALE = 'X' THEN '微型企业'
              ELSE '不适用'
         END                                       AS TJXWQYLB     --013 统计小微企业类别
        ,CASE WHEN T1.IS_CBRC_ENT = 'Y'
               AND T1.ENT_SCALE IN ('S','X')
               AND NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 10000000 -- 一千万以下
              THEN '是'
              ELSE '否'
         END                                       AS SFPHXWQY     --014 是否普惠小微企业
        ,NVL(T1.LOAN_NET_VAL,0) * T6.EXRT          AS TJYE         --015 统计余额（元）
        ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
              WHEN T1.LVL5_CL = '02' THEN '关注类'
              WHEN T1.LVL5_CL = '03' THEN '次级类'
              WHEN T1.LVL5_CL = '04' THEN '可疑类'
              WHEN T1.LVL5_CL = '05' THEN '损失类'
              ELSE '不适用'
         END                                       AS WJFL         --016 五级分类
        ,CASE WHEN T1.LVL5_CL IN ('03','04','05') 
              THEN '是'
              ELSE '否'
         END                                       AS SFBL         --017 是否不良
        ,T1.LOAN_ACT_DSTR_DT                       AS YSQSRQ       --018 原始起始日期
        ,T1.LOAN_ORIG_EXP_DT                       AS YSDQRQ       --019 原始到期日期
        ,CASE WHEN T1.LOAN_TERM = 'S' THEN '短期'
              WHEN T1.LOAN_TERM IN ('M','L') THEN '中长期'
              ELSE '不适用'
         END                                       AS YSQXLB       --020 原始期限类别
        ,--DECODE(T.SFKCQY,'Y','是','否')
         DECODE(T1.TECH_INNO_ENT_FLG,'1','是','否')AS SFKCQY       --021 是否科创企业  -- 参考S70逻辑
        ,T8.FF_CRDT_TOTAL_LMT                      AS FKSSXED      --022 放款时授信额度（元）
        ,T1.LOAN_AMT * T6.EXRT                     AS FKJE         --023 放款金额（元）
        ,T1.ACT_RATE                               AS ZXLL         --024 执行利率（年）
        ,T1.LOAN_AMT  * T6.EXRT * T1.ACT_RATE/100  AS NHLXSY       --025 年化利息收益（元）
        ,T1.CONT_ID                                AS ZHWYM        --026 账户唯一码
        ,T4.CUST_NM                                AS CUST_NAM     --027 客户中文名称
        ,''                                        AS FKSSFPHXWQY  --028 放款时是否普惠小微企业
        ,T1.DATA_SRC                               AS DEPARTMENTD  --029 归属系统
        ,CASE WHEN T8.FF_CRDT_TOTAL_LMT <= 1000000 THEN '单户授信100万元（含）以下'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 5000000 THEN '单户授信100-500万元（含）'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 10000000 THEN '单户授信500-1000万元（含）'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 30000000 THEN '单户授信1000-3000万元（含）'
              WHEN T8.FF_CRDT_TOTAL_LMT > 30000000 THEN '单户授信3000万元以上'
              ELSE '不适用'
         END                                       AS FKSXQJ_3000  --030 放款时普惠授信区间（3000万）
        ,CASE WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 100000 THEN '单户授信10万元（含）以下'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 1000000 THEN '单户授信10-100万元（含）'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 5000000 THEN '单户授信100-500万元（含）'
              WHEN NVL(T7.CRDT_TOTAL_LMT_ZT,T10.AMT) <= 10000000 THEN '单户授信500-1000万元（含）'
              ELSE '不适用'
         END                                       AS SXQJ_1000    --031 普惠授信区间(1000万)
        ,CASE WHEN T8.FF_CRDT_TOTAL_LMT <= 100000 THEN '单户授信10万元（含）以下'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 1000000 THEN '单户授信10-100万元（含）'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 5000000 THEN '单户授信100-500万元（含）'
              WHEN T8.FF_CRDT_TOTAL_LMT <= 10000000 THEN '单户授信500-1000万元（含）'
              ELSE '不适用'
         END                                       AS FKSXQJ_1000  --032 放款时普惠授信区间（1000万）
        ,T2.LOAN_STD_PROD_NM                       AS BZCPMC       --033 标准产品名称
        ,T2.ICMS_CUST_ID                           AS ICMS_KHWYM   --034 信贷客户号
        ,T9.CUST_NM                                AS ICMS_CUST_NAM--035 信贷客户名称
        ,T11.CONT_AMT                              AS YWHTJE       --036 业务合同金额
        ,CASE WHEN T1.BGDKLX = '10' THEN '控制型并购贷款'
              WHEN T1.BGDKLX = '20' THEN '参股型并购贷款'
         END                                       AS BGDKLX       --037 并购贷款类型
        ,CASE WHEN T1.SFTYJRCBQY = 'Y' THEN '是'
         ELSE '否' END                             AS SFTYJRCBQY   --038 是否退役军人创办企业
        ,CASE WHEN T1.FKSQYGM = 'L' THEN '大型企业'
              WHEN T1.FKSQYGM = 'M' THEN '中型企业'
              WHEN T1.FKSQYGM = 'S' THEN '小型企业'
              WHEN T1.FKSQYGM = 'X' THEN '微型企业'
         ELSE '其他法人客户' END                   AS FKSQYGM      --039 放款时企业规模        
        ,REPLACE(M1.TAR_VALUE_NAME,'企业','')      AS FKSKGLX      --040 放款时控股类型
        ,CASE WHEN T1.FKYQYGM = 'L' THEN '大型企业'
              WHEN T1.FKYQYGM = 'M' THEN '中型企业'
              WHEN T1.FKYQYGM = 'S' THEN '小型企业'
              WHEN T1.FKYQYGM = 'X' THEN '微型企业'
         ELSE '其他法人客户' END                   AS FKYQYGM      --041 放款月企业规模        
        ,REPLACE(M2.TAR_VALUE_NAME,'企业','')      AS FKYKGLX      --042 放款月控股类型        
    FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO T2 -- M层借据表
      ON T2.RCPT_ID = T1.RCPT_ID
     AND T2.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
      ON T3.ORG_ID = T1.ORG_ID
     AND T3.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T4 --对公客户信息
      ON T4.CUST_ID = NVL(T1.CUST_ID,'-')  -- 客户信息取直贴人
     AND T4.DATA_DT = V_P_DATE
     -- MOD BY LIUYU 20230530 调整关联过滤客户号为中文的转帖人
    LEFT JOIN RRP_MDL.S_LOAN_AGR_REL T5 --涉农贷款整合表
      ON T5.RCPT_ID = T1.RCPT_ID
     AND T5.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO T6 --汇率表
      ON T6.BASE_CUR = T1.CUR
     AND T6.CNV_CUR = 'CNY'
     AND T6.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T7  -- 授信额度表
      ON T7.CUST_ID = NVL(T1.CUST_ID,'-')
     AND T7.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S_LOAN_AMT_S71 T8 -- 放款授信额度表
      ON T8.RCPT_ID = T1.RCPT_ID
     AND T8.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T9 --对公客户信息
      ON T9.CUST_ID = T2.ICMS_CUST_ID
     AND T9.DATA_DT = V_P_DATE
    LEFT JOIN TMP1 T10
      ON T10.CUST_ID = NVL(T1.CUST_ID,'-') --转贴现特殊处理
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T11 -- 业务合同
      ON T11.CONT_ID = T1.CONT_ID
     AND T11.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M1
      ON M1.TAR_VALUE_CODE = SUBSTR(TRIM(T1.FKSKGLX),1,1) --企业控股类型 中类        
    LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME
                 FROM RRP_MDL.CODE_MAP  --码值表
                WHERE TAR_CLASS_CODE = 'C0004' --经济成分代码
                  AND SRC_CLASS_CODE = 'CD1417'
                  AND MOD_FLG = 'MDM' ) M2
      ON M2.TAR_VALUE_CODE = SUBSTR(TRIM(T1.FKYKGLX),1,1)  --企业控股类型 中类        
    /*LEFT JOIN RRP_MDL.S_LOAN T12
      ON T1.RCPT_ID=T12.RCPT_ID
     AND T12.DATA_DT='20231107'
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T13 --对公客户信息
      ON T13.CUST_ID = NVL(T1.CUST_ID,'-')  -- 客户信息取直贴人
     AND T13.DATA_DT = T1.LOAN_ACT_DSTR_DT*/
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
     AND T1.LOAN_DIR_BIO_FLG <> 'N'
     AND T1.CORP_CUST_TYP<>'E'
     AND (NVL(T1.LOAN_NET_VAL, 0) <> 0 --有余额
         OR SUBSTR(T1.LOAN_ACT_DSTR_DT, 1, 4) = SUBSTR(V_P_DATE, 1, 4)) --当年放款
       ;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_S71_BUSINESS T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
--插入过程跑批完成记录表
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
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_S71_BUSINESS;
/

