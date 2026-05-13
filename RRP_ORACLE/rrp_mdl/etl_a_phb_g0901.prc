CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_G0901
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_G0901
  *  功能描述：零售_互联网小基表
  *  创建日期：20221103
  *  开发人员：韦永钊
  *  来源表：
  *  目标表：A_PHB_G0901 --零售_互联网小基表
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人            修改原因
  *  001   20221107   weiyongzhao       创建过程
  *  002   20230523   weiyongzhao       优化出数逻辑，产品编号不能写死，改从配置表出
  *  003   20230523   liuyu             修改期限月字段逻辑
  *  004   20251128   HYF               调整出数逻辑，不从配置表出数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(300) := 'ETL_A_PHB_G0901';
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
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_G0901'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '零售数据_插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.A_PHB_G0901 NOLOGGING
    (
          BGRQ                      --001 报告日期
         ,JYWYM                     --002 交易唯一码
         ,KHWYM                     --003 客户唯一码
         ,YWHTBH                    --004 业务合同编号
         ,ZJHM                      --005 证件号码
         ,HM                        --006 户名
         ,ZWJGBH                    --007 账务机构编号
         ,ZWJGMC                    --008 账务机构名称
         ,HLWDKYTLB                 --009 互联网贷款用途类别
         ,HZFS                      --010 合作方式
         ,TJYE                      --011 统计余额（元）
         ,WJFL                      --012 五级分类
         ,SFBL                      --013 是否不良
         ,YSQSRQ                    --014 原始起始日期
         ,YSDQRQ                    --015 原始到期日期
         ,QXY                       --016 期限月
         ,SFYQ                      --017 是否逾期
         ,YQTSQJ                    --018 逾期天数区间
         ,TJDBFS                    --019 统计担保方式
         ,HTSJQXQJ                  --020 合同实际期限区间
         ,JKRCSRQ                   --021 借款人出生日期
         ,JKRNLQJ                   --022 借款人年龄区间
         ,DKZFFS                    --023 贷款支付方式
         ,SXZED                     --024 授信总额度（元）
         ,TJXWQYLB                  --025 统计小微企业类别
         ,SFPHXWQY                  --026 是否普惠小微企业
         ,FKJE                      --027 放款金额（元）
         ,TGGTCZFWHZFMC             --028 提供共同出资服务合作方名称
         ,TGDBZXFWHZFMC             --029 提供担保增信服务合作方名称
         ,TGBFFXPJFWHZFMC           --030 提供部分风险评价服务合作方名称
         ,TJYQBJJE                  --031 统计逾期本金金额（元）
         ,DKYWPZ                    --032 贷款业务品种
         ,DKYWPZMC                  --033 贷款业务品种名称
         ,DEPARTMENTD               --034 归属部门
         ,BHCZBL                    --035 本行出资比例
         ,HZFCZBL                   --036 合作方出资比例
    )
      WITH TMP_AGRT AS (
    SELECT A.COOP_AGRT_ID,MAX(A.PNR_NM) PNR_NM,MAX(A.PNR_CRDL_NO) PNR_CRDL_NO
          ,MAX(A.PNR_TYP) PNR_TYP,MAX(A.COOP_MODE) COOP_MODE
      FROM RRP_MDL.M_LOAN_NET_COOP_SUB A --互联网贷款合作协议表
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID),
TMP_CONT_COOP_AGRT_ID AS (
    SELECT COOP_AGRT_ID
      FROM RRP_MDL.M_LOAN_CONT_INFO 
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID ),
  TMP_COOP_AGRT_ID AS (
    SELECT C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL) COOP_AGRT_ID_ST 
    FROM TMP_CONT_COOP_AGRT_ID C 
     CONNECT BY LEVEL <= LENGTH(C.COOP_AGRT_ID) - LENGTH(REPLACE(C.COOP_AGRT_ID, ';')) + 1
     GROUP BY C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL)),
    LOAN_CONT_INFO_TMP AS (
    SELECT T1.CONT_ID,MAX(T3.PNR_NM) PNR_NM,MAX(T3.PNR_CRDL_NO) PNR_CRDL_NO
          ,MAX(T3.PNR_TYP) PNR_TYP,MAX(T3.COOP_MODE) COOP_MODE
      FROM RRP_MDL.S_LOAN T1
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T2 ON T2.CONT_ID = T1.CONT_ID AND T2.DATA_DT = V_P_DATE
      LEFT JOIN TMP_COOP_AGRT_ID T4 ON T4.COOP_AGRT_ID = T2.COOP_AGRT_ID
      LEFT JOIN TMP_AGRT T3 ON T3.COOP_AGRT_ID = T4.COOP_AGRT_ID_ST
      WHERE T1.NET_LOAN_FLG = 'Y'
       AND T1.DATA_DT = V_P_DATE
    GROUP BY T1.CONT_ID)
   SELECT T1.DATA_DT                AS BGRQ                      --001 报告日期
         ,T1.RCPT_ID                AS JYWYM                     --002 交易唯一码
         ,T1.CUST_ID                AS KHWYM                     --003 客户唯一码
         ,T1.CONT_ID                AS YWHTBH                    --004 业务合同编号
         ,T4.CRDL_NO                AS ZJHM                      --005 证件号码
         ,T4.CUST_NM                AS HM                        --006 户名
         ,T1.ORG_ID                 AS ZWJGBH                    --007 账务机构编号
         ,T3.ORG_NM                 AS ZWJGMC                    --008 账务机构名称
         ,CASE WHEN T1.IND_OPR_LOAN_FLG = 'N' THEN '个人消费'
               WHEN T1.IND_OPR_LOAN_FLG = 'Y' THEN '个人生产经营'
          END                       AS HLWDKYTLB                 --009 互联网贷款用途类别
/*         ,CASE WHEN T5.HZFS = '01'   THEN '联合贷'  --联合贷
               WHEN T5.HZFS = '02' THEN '本行助贷'  --本行助贷 无业务
               WHEN T5.HZFS = '03' THEN '助贷本行'  --助贷本行
           END                       AS HZFS                      --010 合作方式*/
         ,CASE WHEN T1.FND_PCT < 100 THEN '联合贷'  --联合贷
               WHEN T1.FND_PCT = 100 THEN '助贷本行'  --助贷本行
          END                       AS HZFS                      --010 合作方式
         ,T1.LOAN_BAL * U.EXRT      AS TJYE                      --011 统计余额（元）
         ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
               WHEN T1.LVL5_CL = '02' THEN '关注类'
               WHEN T1.LVL5_CL = '03' THEN '次级类'
               WHEN T1.LVL5_CL = '04' THEN '可疑类'
               WHEN T1.LVL5_CL = '05' THEN '损失类'
          END                       AS WJFL                      --012 五级分类
         ,CASE WHEN T1.LVL5_CL IN ('03','04','05') THEN '是'
               ELSE '否'
          END                       AS SFBL                      --013 是否不良
         ,T1.LOAN_ACT_DSTR_DT       AS YSQSRQ                    --014 原始起始日期
         ,T1.LOAN_ORIG_EXP_DT       AS YSDQRQ                    --015 原始到期日期
/*         ,CASE WHEN T1.DATA_SRC = '零售贷款'
               THEN (CASE WHEN T1.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN 12  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         ELSE MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                    END)
              WHEN T1.DATA_SRC = '联合网贷'
              THEN (TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30
          END -- MOD BY LIUYU 20230523 调整期限月逻辑
                                    AS QXY                       --016 期限月*/
         ,MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                    AS QXY                       --016 期限月                                    
         ,CASE WHEN T1.OVD_DAYS > 0 THEN '是'
               ELSE '否'
          END                       AS SFYQ                      --017 是否逾期
         ,CASE WHEN NVL(T1.OVD_DAYS,0) = 0  THEN '未逾期'
               WHEN T1.OVD_DAYS <= 30      THEN '逾期30天以内'
               WHEN T1.OVD_DAYS <= 60      THEN '逾期31天到60天'
               WHEN T1.OVD_DAYS <= 90      THEN '逾期61天到90天'
               WHEN T1.OVD_DAYS <= 180     THEN '逾期91天到180天'
               WHEN T1.OVD_DAYS <= 270     THEN '逾期181天到270天'
               WHEN T1.OVD_DAYS <= 360     THEN '逾期271天到360天'
               WHEN T1.OVD_DAYS > 360      THEN '逾期361天以上'
          END                       AS YQTSQJ                    --018 逾期天数区间
         ,DECODE(T1.TJDBFS,'DZY','抵质押','BZ','保证','XY','信用','不适用')
                                    AS TJDBFS                    --019 统计担保方式
         ,CASE WHEN MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT, 'YYYY-MM-DD')
                                  ,TO_DATE(T1.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 6  THEN '0-6个月（含）'
               WHEN MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT, 'YYYY-MM-DD')
                                  ,TO_DATE(T1.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 12 THEN '6个月-1年（含）'
               WHEN MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT, 'YYYY-MM-DD')
                                  ,TO_DATE(T1.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) <= 36 THEN '1年-3年（含）'
               WHEN MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT, 'YYYY-MM-DD')
                                  ,TO_DATE(T1.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) > 36  THEN '3年以上'
          END                       AS HTSJQXQJ                  --020 合同实际期限区间
         ,T4.BIRTH_DT               AS JKRCSRQ                   --021 借款人出生日期
         ,CASE WHEN FLOOR((TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD') - TO_DATE(T4.BIRTH_DT,'YYYYMMDD'))/360) <= 25 THEN '25岁（含）以下'
               WHEN FLOOR((TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD') - TO_DATE(T4.BIRTH_DT,'YYYYMMDD'))/360) <= 35 THEN '25岁-35岁（含）'
               WHEN FLOOR((TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD') - TO_DATE(T4.BIRTH_DT,'YYYYMMDD'))/360) <= 45 THEN '35岁-45岁（含）'
               WHEN FLOOR((TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD') - TO_DATE(T4.BIRTH_DT,'YYYYMMDD'))/360) <= 55 THEN '45岁-55岁（含）'
               ELSE '55岁以上'
          END                       AS JKRNLQJ                   --022 借款人年龄区间
         ,CASE WHEN T1.DATA_SRC = '联合网贷' OR T1.STD_PROD_ID = '551612310' OR T1.DSBR_MODE = '01' THEN '自主支付'
               WHEN T1.DSBR_MODE = '02' THEN '受托支付'
               ELSE '不适用'
          END                       AS DKZFFS                    --023 贷款支付方式
         ,T1.SGL_CRDT_AMT           AS SXZED                     --024 授信总额度（元）
         ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN CASE WHEN T1.OPR_CUST_TYP = 'A' THEN '个体工商户'
                                                           WHEN T1.OPR_CUST_TYP = 'B' THEN '小微企业主'
                                                           WHEN T1.OPR_CUST_TYP = 'Z' THEN '其他个人经营客户'
                                                           ELSE '不适用'
                                                       END
               ELSE '不适用'
           END                           AS TJXWQYLB                  --025 统计小微企业类别
         ,CASE WHEN T1.OPR_CUST_TYP IN ('A','B') AND T1.SGL_CRDT_AMT <= 10000000
               THEN '是'
               ELSE '否'
          END                       AS SFPHXWQY                  --026 是否普惠小微企业
         ,T1.LOAN_AMT * U.EXRT      AS FKJE                      --027 放款金额（元）
         --,T5.TGGTCZFWHZFHZFMC       AS TGGTCZFWHZFMC             --028 提供共同出资服务合作方名称
         ,CASE WHEN T5.COOP_MODE LIKE '%02%' THEN T5.PNR_NM
          END                       AS TGGTCZFWHZFMC             --028 提供共同出资服务合作方名称
         --,T5.TGDBZXFWHZFMC        AS TGDBZXFWHZFMC             --029 提供担保增信服务合作方名称
         ,CASE WHEN T5.COOP_MODE LIKE '%05%' THEN T5.PNR_NM
          END                       AS TGDBZXFWHZFMC             --029 提供担保增信服务合作方名称         
         --,T5.TGBFFXPJFWHZFMC        AS TGBFFXPJFWHZFMC           --030 提供部分风险评价服务合作方名称
         ,CASE WHEN T5.COOP_MODE LIKE '%09%' THEN T5.PNR_NM
          END                       AS TGBFFXPJFWHZFMC           --030 提供部分风险评价服务合作方名称         
         ,CASE WHEN T1.OVD_DAYS <=0 THEN 0
               WHEN T1.OVD_DAYS > 0 AND T1.OVD_DAYS <= 90
                    AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199')
                    AND T1.GXH_PAY_FREQ IN ('M','03') --按月还款
                    AND T1.GXH_PAY_TYPE IN ('1','2','6','7','8','9','11')
               THEN T1.OVD_PRIN_BAL * U.EXRT
               ELSE T1.LOAN_BAL * U.EXRT
          END                       AS TJYQBJJE                  --031 统计逾期本金金额（元）
         ,T1.STD_PROD_ID            AS DKYWPZ                    --032 贷款业务品种
         ,M2.TAR_VALUE_NAME         AS DKYWPZMC                  --033 贷款业务品种名称
         ,CASE WHEN T1.DATA_SRC = '零售贷款' THEN '零售贷款'
               WHEN T1.DATA_SRC = '联合网贷' THEN '联合网贷'
          END                       AS DEPARTMENTD               --034 归属部门
/*         ,CASE WHEN T1.STD_PROD_ID = '202020100001'
                      THEN CASE WHEN (T1.LOAN_ACT_DSTR_DT >= 20180901 AND T1.LOAN_ACT_DSTR_DT < 20190901)
                                     OR (T1.LOAN_ACT_DSTR_DT >= 20201208 AND T1.LOAN_ACT_DSTR_DT < 20211125)
                                THEN 0.90 --浙江网商(出资占比10%)
                                WHEN T1.LOAN_ACT_DSTR_DT >= 20190901 AND T1.LOAN_ACT_DSTR_DT < 20201208
                                THEN 1 --浙江网商(出资占比0%)
                                ELSE 0.65 --浙江网商(出资占比35%)
                           END
                      WHEN T1.STD_PROD_ID = '202020200004'
                      THEN 1 --浙江网商(出资占比0)
                      ELSE T5.BHCZBL --其他产品本行出资比例
                 END                AS BHCZBL                    --035 本行出资比例*/
         ,T1.FND_PCT/100            AS BHCZBL                    --035 本行出资比例 MOD BY 20251124
/*         ,CASE WHEN T1.STD_PROD_ID = '202020100001'
                      THEN CASE WHEN (T1.LOAN_ACT_DSTR_DT >= 20180901 AND T1.LOAN_ACT_DSTR_DT < 20190901)
                                     OR (T1.LOAN_ACT_DSTR_DT >= 20201208 AND T1.LOAN_ACT_DSTR_DT < 20211125)
                                THEN 0.10 --浙江网商(出资占比10%)
                                WHEN T1.LOAN_ACT_DSTR_DT >= 20190901 AND T1.LOAN_ACT_DSTR_DT < 20201208
                                THEN 0.00 --浙江网商(出资占比0%)
                                ELSE 0.35 --浙江网商(出资占比35%)
                           END
                      WHEN T1.STD_PROD_ID = '202020200004'
                      THEN 0.00 --浙江网商(出资占比0)
                      ELSE T5.HZJGCZBL --其他产品合作机构出资比例
                 END                 AS HZFCZBL                   --036 合作方出资比例*/
         ,T1.FND_PCT_HZF/100         AS HZFCZBL                   --036 合作方出资比例 MOD BY 20251124
    FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
           ON T3.ORG_ID = T1.ORG_ID
          AND T3.DATA_DT = T1.DATA_DT
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4 --个人客户信息
           ON T4.CUST_ID = T1.CUST_ID
          AND T4.DATA_DT = T1.DATA_DT
/*    LEFT JOIN (SELECT HLWDKYTLB     AS HLWDKYTLB --互联网贷款用途类别
                     --,YWPZBH        AS YWPZBH    --业务品种编号  -- MODIFY BY WEIYONGZHAO 20230523 取标准产品编号关联
                     ,STD_PROD_ID   AS STD_PROD_ID  --标准产品编号
                     ,MIN(HZFS)     AS HZFS      --合作方式
                     ,MAX(CASE WHEN HZJGTGFWLX LIKE '%B%' THEN HZFMC END) --合作机构提供服务类型
                                    AS TGGTCZFWHZFHZFMC  --提供共同出资服务合作方名称
                     ,MAX(CASE WHEN HZJGTGFWLX LIKE '%F%' THEN HZFMC END)
                                    AS TGDBZXFWHZFMC     --提供担保增信服务合作方名称
                     ,MAX(CASE WHEN HZJGTGFWLX LIKE '%E%' THEN HZFMC END)
                                    AS TGBFFXPJFWHZFMC   --提供部分风险评价服务合作方名称
                     ,MAX(HZJGCZBL) AS HZJGCZBL          --合作机构出资比例
                     ,MAX(BHCZBL)   AS BHCZBL            --本行出资比例
               FROM RRP_MDL.M_DICT_G09_HZF
               -- 新一代补录表改静态表，直接取数
               GROUP BY HLWDKYTLB,\*YWPZBH*\STD_PROD_ID) T5 --G09互联网贷款产品信息静态表
    			 ON T5.STD_PROD_ID = T1.STD_PROD_ID*/
    --关联合作协议子表取合作方等相关信息 ADD BY 20251203
    LEFT JOIN LOAN_CONT_INFO_TMP T5  
           ON T5.CONT_ID = T1.CONT_ID
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
           ON U.DATA_DT = T1.DATA_DT
          AND U.BASE_CUR = T1.CUR
          AND U.CNV_CUR = 'CNY'
    LEFT JOIN RRP_MDL.CODE_MAP M1 --码值表
           ON M1.TAR_CLASS_CODE = 'T0001' --贷款类型
          AND M1.SRC_CLASS_CODE = 'T0001'
          AND M1.MOD_FLG = 'IMAS'
          AND M1.SRC_VALUE_CODE = T1.LOAN_BIZ_TYP
    LEFT JOIN RRP_MDL.CODE_MAP M2 --码值表
	       ON M2.TAR_CLASS_CODE='IMAS_2'
		    AND M2.SRC_CLASS_CODE='IMAS_2'
		    AND M2.MOD_FLG='IMAS'
        AND M2.TAR_VALUE_CODE=T1.STD_PROD_ID
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('零售贷款','联合网贷')
    AND T1.NET_LOAN_FLG = 'Y'  --互联网贷款标志
    AND (NVL(T1.LOAN_BAL,0) <> 0 --有余额
          OR ( T1.DATA_SRC IN ('零售贷款')  AND SUBSTR(T1.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4)
               ) --当年放款
          OR ( T1.DATA_SRC IN ('联合网贷') AND T1.LOAN_ACT_DSTR_DT >= SUBSTR(V_P_DATE ,1,4)-1||'1231'
              ) --联合网贷包含去年末一天
         )
   ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_PHB_G0901 T
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

  END ETL_A_PHB_G0901;
/

