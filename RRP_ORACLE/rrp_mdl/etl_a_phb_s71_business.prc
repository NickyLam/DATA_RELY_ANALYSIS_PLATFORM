CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_S71_BUSINESS

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_S71_BUSINESS
  *  功能描述：为更加全面、准确反映银行业金融机构对普惠金融重点领域的贷款支持
  *            情况，结合现有小微企业、三农、扶贫等统计指标，建立银行业普惠金
  *            融重点领域贷款统计指标体系。本表对我行普惠金融信息进行拓展定义
  *            ，零售专用，以满足1104中S7101、S7102报表中对普惠经营贷款需求。
  *  创建日期：20221103
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_S71_BUSINESS --普惠金融模型经营贷
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人     修改原因
  *   1    20221103   liuyu      首次创建
  *   2    20230523   liuyu      调整S7102区间根据禹晴意见调整码值映射，调整码值
  *   3    20230606   liuyu      新增需求：加上个人非农户经营贷款标志
  *   4    20230614   liuyu      调整口径，不需要授信总额区间，
  *   5    20230808   hyf        按业务禹晴口径，S7101需重新纳入 201030100001 个人一手商用房按揭贷款
  *                                       201030100002 个人二手商用房按揭贷款 201030100003	法拍贷（商用房）,
  *                                       不纳入 201020100049 个人赎楼贷款（经营）
  *   6    20231109   lwb        新增放款时统计小微企业类别，放款时农户标识字段
  *   7    20240229   LWB        时点农户标志修改出数口径，改从S_LOAN出数
  *   8    20241119   HYF        新增201020100049-个人赎楼贷款（经营）
  *   9    20241209   HYF        调整201020100049-个人赎楼贷款（经营）过滤范围
  *   10   20260309   HYF        调整客户号取值，优先继承上月客户号
  *   11   20260324   HYF        新增无营业执照负责人标志、退役军人标志
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_S71_BUSINESS';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ; --表名
  V_PART_NAME  VARCHAR2(100); --分区名

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_S71_BUSINESS'; --表名,写目标表表名
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

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.A_PHB_S71_BUSINESS
  (
         BGRQ                    -- 1 报告日期
        ,JYWYM                   -- 2 交易唯一码
        ,ZHWYM                   -- 3 账户唯一码
        ,KHWYM                   -- 4 客户唯一码
        ,CUST_NAM                -- 5 客户中文名称
        ,ZWJGBH                  -- 6 机构编号
        ,ZWJGMC                  -- 7 机构名称
        ,DKLB                    -- 8 贷款类别
        ,TJYWPZ                  -- 9 统计业务品种
        ,TJYWPZMC                -- 10 统计业务品种名称
        ,GRDKYTLB                -- 11 个人贷款用途类别
        ,GRDKYTLBMC              -- 12 个人贷款用途类别名称
        ,FKR                     -- 13 放款日
        ,YSQSRQ                  -- 14 原始起始日期
        ,YSDQRQ                  -- 15 原始到期日期
        ,QXY                     -- 16 期限月
        ,YSQXLB                  -- 17 原始期限类别
        ,TJDBFS                  -- 18 统计担保方式
        ,SNDKFL                  -- 19 涉农贷款分类
        ,SNDKFLMC                -- 20 涉农贷款分类名称
        ,TJXWQYLB                -- 21 统计小微企业类别
        ,TJXWQYLBMC              -- 22 统计小微企业类别名称
        ,WJFL                    -- 23 五级分类
        ,SFBL                    -- 24 是否不良
        ,FKJE                    -- 25 放款金额（元）
        ,TJYE                    -- 26 统计余额（元）
        ,TJYE_W                  -- 27 统计余额（万元）
        ,ZXLL                    -- 28 执行利率（年）
        ,NHLXSY                  -- 29 年化利息收益（元）
        ,SXZED                   -- 30 授信总额度（元）
        ,SFPHXWQY                -- 31 是否普惠小微企业
        ,PHXWSXQJ                -- 32 普惠小微授信区间
        ,PHSNSXQJ                -- 33 普惠涉农授信区间
        ,FKSSXED                 -- 34 放款时授信额度（元）
        ,LSFKSFPHXWQY            -- 35 零售放款是否普惠小微企业
        ,PHJRSXQJ                -- 36 普惠放款小微授信区间
        ,PHFKSXQJ                -- 37 普惠放款涉农授信区间
        ,SFCYDBDK                -- 38 是否创业担保贷款
        ,SFWHBXD                 -- 39 是否无还本续贷
        ,SFCJR                   -- 40 是否残疾人
        ,SFFPXEXD                -- 41 是否扶贫小额信贷
        ,SFJTNC                  -- 42 是否家庭农场
        ,SFLSPKH                 -- 43 是否历史贫困户
        ,SFNH                    -- 44 是否农户
        ,DEPARTMENTD             -- 45 归属系统
        ,GRFNHJYDBZ              -- 46 个人非农户经营贷标志
        ,FKSTJXWLB               -- 47 放款时统计小微企业类别
        ,FKSNHBS                 -- 48 放款时农户标识
        ,EX_SERVSM_FLG           -- 49 退役军人标志
        ,NO_BUSLICS_PRC_FLG      -- 50 无营业执照负责人标志        
  )
   SELECT
         T1.DATA_DT                                        AS BGRQ                    -- 1 报告日期
        ,T1.RCPT_ID                                        AS JYWYM                   -- 2 交易唯一码
        ,T1.CONT_ID                                        AS ZHWYM                   -- 3 账户唯一码
        ,NVL(T9.CUST_NO,T1.CUST_ID)                        AS KHWYM                   -- 4 客户唯一码
        ,T4.CUST_NM                                        AS CUST_NAM                -- 5 客户中文名称
        ,T1.ORG_ID                                         AS ZWJGBH                  -- 6 机构编号
        ,T3.ORG_NM                                         AS ZWJGMC                  -- 7 机构名称
        ,'普通贷款'                                        AS DKLB                    -- 8 贷款类别
        ,T8.LOAN_PROD_ID                                   AS TJYWPZ                  -- 9 统计业务品种
        ,T8.LOAN_PROD_NM                                   AS TJYWPZMC                -- 10 统计业务品种名称
        ,''                                                AS GRDKYTLB                -- 11 个人贷款用途类别
        ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN '个人经营性贷款'   --个人经营性贷款
              WHEN T1.LOAN_BIZ_TYP = '010301' THEN '汽车'               --汽车
              WHEN T1.LOAN_BIZ_TYP = '010101' THEN '住房按揭贷款'       --住房按揭贷款
              WHEN T1.LOAN_BIZ_TYP LIKE '01%' AND T8.LOAN_USEAGE IN ( '装修','装修房屋') THEN '房屋装修贷款'      --房屋装修贷款
              WHEN T1.LOAN_BIZ_TYP LIKE '01%' AND T8.LOAN_USEAGE = '购置耐用消费品' THEN '大件耐用消费品贷款'     --大件耐用消费品贷款
              WHEN T1.LOAN_BIZ_TYP IN ('010402','010403') THEN '国家助学贷款'     --国家助学贷款
              WHEN T1.LOAN_BIZ_TYP = '010404' THEN '生源地助学贷款'               --生源地助学贷款
              WHEN T1.LOAN_BIZ_TYP = '010405' THEN '商业性助学贷款'               --商业性助学贷款
               --校园消费贷款
              ELSE '其他'   --其他
         END                                               AS GRDKYTLBMC              -- 12 个人贷款用途类别名称
        ,T1.LOAN_ACT_DSTR_DT                               AS FKR                     -- 13 放款日
        ,T1.LOAN_ACT_DSTR_DT                               AS YSQSRQ                  -- 14 原始起始日期
        ,T1.LOAN_ORIG_EXP_DT                               AS YSDQRQ                  -- 15 原始到期日期
/*        ,CASE WHEN T8.DATA_SRC = '零售贷款'
              THEN CASE WHEN T8.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN 12  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         ELSE MONTHS_BETWEEN(TO_DATE(T8.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T8.LOAN_ACT_DSTR_DT,'YYYYMMDD')) END
              WHEN T8.DATA_SRC = '联合网贷'
              THEN (TO_DATE(T8.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T8.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30
              WHEN T8.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
              THEN MONTHS_BETWEEN(TO_DATE(T8.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T8.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
         END                                               AS QXY                     -- 16 期限月*/
        ,MONTHS_BETWEEN(TO_DATE(T8.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T8.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                                           AS QXY                     -- 16 期限月
        ,CASE WHEN T1.LOAN_TERM = 'S' THEN '短期'
              WHEN T1.LOAN_TERM IN ('M','L') THEN '中长期'
              ELSE '不适用'
         END                                               AS YSQXLB                  -- 17 原始期限类别
        ,DECODE(T1.TJDBFS,'DZY','抵质押'
                         ,'BZ','保证'
                         ,'XY','信用'
                         ,'不适用')                        AS TJDBFS                  -- 18 统计担保方式
        ,''                                                AS SNDKFL                  -- 19 涉农贷款分类
        ,CASE WHEN T1.FARM_FLG = 'Y' THEN '农户涉农'
              WHEN T1.FARM_FLG = 'N' AND T5.RCPT_ID IS NOT NULL THEN '非农户个人涉农'
              ELSE '非涉农'
         END                                               AS SNDKFLMC                -- 20 涉农贷款分类名称
        ,''                                                AS TJXWQYLB                -- 21 统计小微企业类别
        ,CASE WHEN T4.OPR_CUST_TYP = 'A' THEN '个体工商户'
              WHEN T4.OPR_CUST_TYP = 'B' THEN '小微企业主'
              WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN '其他个人经营客户'
              ELSE '不适用'
         END                                               AS TJXWQYLBMC              -- 22 统计小微企业类别名称
        ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
              WHEN T1.LVL5_CL = '02' THEN '关注类'
              WHEN T1.LVL5_CL = '03' THEN '次级类'
              WHEN T1.LVL5_CL = '04' THEN '可疑类'
              WHEN T1.LVL5_CL = '05' THEN '损失类'
              ELSE '不适用'
         END                                               AS WJFL                    -- 23 五级分类
        ,CASE WHEN T1.LVL5_CL IN ('03','04','05') THEN '是'
              ELSE '否'
         END                                               AS SFBL                    -- 24 是否不良
        ,NVL(T1.LOAN_AMT,0) * T6.EXRT                      AS FKJE                    -- 25 放款金额（元）
        ,NVL(T1.LOAN_BAL,0) * T6.EXRT                      AS TJYE                    -- 26 统计余额（元）
        ,NVL(T1.LOAN_BAL,0) * T6.EXRT / 10000              AS TJYE_W                  -- 27 统计余额（万元）
        ,T1.ACT_RATE                                       AS ZXLL                    -- 28 执行利率（年）
        ,NVL(T1.INCOME_ANNUAL,0)                           AS NHLXSY                  -- 29 年化利息收益（元）
        ,T1.SGL_CRDT_AMT                                   AS SXZED                   -- 30 授信总额度（元）
        ,CASE WHEN T4.OPR_CUST_TYP IN ('A','B')
               AND T1.OPR_CRDT_TOT_AMT <= 10000000
              THEN '是'
              ELSE '否'
         END                                               AS SFPHXWQY                -- 31 是否普惠小微企业
        ,CASE WHEN T1.OPR_CRDT_TOT_AMT <= 1000000 THEN '单户经营授信100万元（含）以下'
              WHEN T1.OPR_CRDT_TOT_AMT <= 5000000 THEN '单户经营授信100-500万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 10000000 THEN '单户经营授信500-1000万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 30000000 THEN '单户经营授信1000-3000万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT > 30000000 THEN '单户经营授信3000万元以上'
						  ELSE '不适用'
         END                                               AS PHXWSXQJ                -- 32 普惠小微授信区间
        ,CASE WHEN T1.OPR_CRDT_TOT_AMT <= 100000 THEN '单户经营授信10万元（含）以下'
              WHEN T1.OPR_CRDT_TOT_AMT <= 1000000 THEN '单户经营授信10-100万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 5000000 THEN '单户经营授信100-500万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT <= 10000000 THEN '单户经营授信500-1000万元（含）'
              WHEN T1.OPR_CRDT_TOT_AMT > 10000000 THEN '单户经营授信1000万元以上'
						  ELSE '不适用' --modby liuyu 根据禹晴意见调整码值映射，调整码值
         END                                               AS PHSNSXQJ                -- 33 普惠涉农授信区间
        ,T9.FF_CRDT_TOTAL_LMT                              AS FKSSXED                 -- 34 放款时授信额度（元）
        ,''                                                AS LSFKSFPHXWQY            -- 35 零售放款是否普惠小微企业
        ,CASE WHEN T9.FF_OPR_CRDT_TOT_AMT <= 1000000 THEN '单户经营授信100万元（含）以下'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 5000000 THEN '单户经营授信100-500万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 10000000 THEN '单户经营授信500-1000万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 30000000 THEN '单户经营授信1000-3000万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT > 30000000 THEN  '单户经营授信3000万元以上'
						  ELSE '不适用'
         END                                               AS PHJRSXQJ                -- 36 普惠放款小微授信区间
        ,CASE WHEN T9.FF_OPR_CRDT_TOT_AMT <= 100000 THEN '单户经营授信10万元（含）以下'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 1000000 THEN '单户经营授信10-100万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 5000000 THEN '单户经营授信100-500万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT <= 10000000 THEN '单户经营授信500-1000万元（含）'
              WHEN T9.FF_OPR_CRDT_TOT_AMT > 10000000 THEN '单户经营授信1000万元以上'
					    ELSE '不适用' --modby liuyu 根据禹晴意见调整码值映射，调整码值
         END                                               AS PHFKSXQJ                -- 37 普惠放款涉农授信区间
        ,CASE WHEN T1.ENT_GUA_LOAN_TYP IN ('0','1') 
              THEN '是' 
              ELSE '否' 
         END                                               AS SFCYDBDK                -- 38 是否创业担保贷款
        ,DECODE(T1.NON_REPY_PRIN_RENEW_FLG,'Y','是','否')  AS SFWHBXD                 -- 39 是否无还本续贷
        ,DECODE(T4.DISABLED_FLG,'Y','是','否')             AS SFCJR                   -- 40 是否残疾人
        ,'否'                                              AS SFFPXEXD                -- 41 是否扶贫小额信贷
        ,DECODE(T5.FAMILY_FARM_LOAN_FLG ,'Y','是','否')    AS SFJTNC                  -- 42 是否家庭农场
        ,'否'                                              AS SFLSPKH                 -- 43 是否历史贫困户
        ,DECODE(T1.FARM_FLG,'Y','是','否')                 AS SFNH                    -- 44 是否农户
        ,CASE WHEN T1.DATA_SRC = '零售贷款' THEN '零售贷款'
              WHEN T1.DATA_SRC = '联合网贷' THEN '联合网贷'
         END                                               AS DEPARTMENTD             -- 45 归属系统
        ,DECODE(T1.QTGRFNH,'1','是','否')                  AS GRFNHJYDBZ              -- 46 个人非农户经营贷标志
        ,T1.FKSKHLX                                        AS FKSTJXWLB               -- 47 放款时统计小微企业类别
        ,T1.FKSSNBZ                                        AS FKSNHBS                 -- 48 放款时农户标识
        ,CASE WHEN T1.EX_SERVSM_FLG = 'Y' THEN '是'
         ELSE '否' END                                     AS EX_SERVSM_FLG           -- 49 退役军人标志
        ,CASE WHEN T1.NO_BUSLICS_PRC_FLG = 'Y' THEN '是'
         ELSE '否' END                                     AS NO_BUSLICS_PRC_FLG      -- 50 无营业执照负责人标志         
    FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
      ON T1.ORG_ID = T3.ORG_ID
     AND T3.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4 --个人客户信息
      ON T1.CUST_ID = T4.CUST_ID
     AND T4.DATA_DT = V_P_DATE
    LEFT JOIN S_LOAN_AGR_REL T5
      ON T1.RCPT_ID = T5.RCPT_ID
     AND T5.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO T6 --汇率表
      ON T6.BASE_CUR = T1.CUR
     AND T6.CNV_CUR = 'CNY'
     AND T6.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO T8  -- 表内借据信息
      ON T1.RCPT_ID = T8.RCPT_ID
     AND T8.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.S_LOAN_AMT_S71 T9 --S71普惠小微发放时授信额度表
      ON T9.RCPT_ID = T1.RCPT_ID
     AND T9.DATA_DT = V_P_DATE
   WHERE T1.DATA_DT = V_P_DATE
     AND T1.DATA_SRC IN ('零售贷款','联合网贷')
     -- 取存量客户、当年放款、上年末的联合网贷数据
     AND ( NVL(T1.LOAN_BAL,0) > 0
          OR ( (T1.DATA_SRC = '零售贷款' 
                AND T1.STD_PROD_ID = '201020100049'
                AND TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD') >= TO_DATE('20241101', 'YYYYMMDD')
                AND TRUNC(TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD'), 'Y') = TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y'))
             OR (T1.DATA_SRC = '零售贷款' 
                 AND T1.STD_PROD_ID <> '201020100049'
                 AND TRUNC(TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD'), 'Y') = TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y'))
             OR (T1.DATA_SRC = '联合网贷' 
                 AND TRUNC(TO_DATE(T1.LOAN_ACT_DSTR_DT,'YYYYMMDD'),'DD') >= TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Y') - 1) ) 
          )       
     AND T1.LOAN_BIZ_TYP LIKE '0102%' --取经营贷款
     --AND T1.STD_PROD_ID NOT IN ('201020100049') -- MOD BY HYF 20230808 按照禹晴邮件剔除经营里面的个人赎楼贷款（经营）
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
      FROM RRP_MDL.A_PHB_S71_BUSINESS T
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
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_S71_BUSINESS;
/

