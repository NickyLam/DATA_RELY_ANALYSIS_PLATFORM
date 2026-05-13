CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_S71_CONSUME

(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_S71_CONSUME
  *  功能描述：为更加全面、准确反映银行业金融机构对普惠金融重点领域的贷款支持
  *            情况，结合现有小微企业、三农、扶贫等统计指标，建立银行业普惠金
  *            融重点领域贷款统计指标体系。本表对我行普惠金融信息进行拓展定义
  *            ，零售专用，以满足1104中S7103报表中对普惠消费贷款需求。
  *  创建日期：20221103
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_S71_CONSUME --普惠金融模型消费贷
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221103   liuyu      首次创建
      2    20231016   lwb        修改五级分类的码值映射
      3    20231017   lwb        修改PHXFSXQJ2的逻辑
      4    20231109   lwb        新增放款时统计小微企业类别，放款时农户标识字段
      5    20240925   LWB        调整放款日期的取数源，从表内借据表出数
      6    20250312   lwb      因2025新制度调整取数的范围
      7    20250328   lwb      调整放款月客户授信总额取数FF_CRDT_TOTAL_LMT
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_S71_CONSUME';
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
  V_TAB_NAME   := 'A_PHB_S71_CONSUME'; --表名,写目标表表名
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
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_PHB_S71_CONSUME
  (       BGRQ                       -- 1 报告日期
         ,JYWYM                      -- 2 交易唯一码
         ,KHWYM                      -- 3 客户唯一码
         ,SXED                       -- 5 报告日客户授信总额（元）
         ,XFDKSXED                   -- 6 报告日消费贷款授信额度（元）
         ,PHXFSXQJ                   -- 7 报告日消费授信区间
         ,WJFL                       -- 8 五级分类
         ,SFBL                       -- 9 是否不良
         ,TJYE                       -- 10 统计余额（元）
         ,SFLSPKH                    -- 11 是否历史贫困户
         ,SFDBH                      -- 12 是否低保户
         ,FKSSXED                    -- 13 放款月客户授信总额（元）
         ,FKJE                       -- 14 放款金额（元）
         ,ZXLL                       -- 15 执行利率（年）
         ,NHLXSY                     -- 16 年化利息收益（元）
         ,FKR                        -- 17 放款日
         ,ZWJGBH                     -- 18 机构编号
         ,ZWJGMC                     -- 19 机构名称
         ,GRDKYTLBMC                 -- 20 个人贷款用途类别名称
         ,SNDKFLMC                   -- 21 涉农贷款分类名称
         ,XFDKSXED2                  -- 22 放款月消费授信额度（元）
         ,PHXFSXQJ2                  -- 23 放款月消费授信区间
         ,DKYWPZMC                   -- 24 贷款业务品种 -- liuyu 新增字段
         ,FKSTJXWLB                  -- 25 放款时统计小微企业类别
         ,FKSNHBS                    -- 26 放款时农户标识
   )
   SELECT   T1.DATA_DT                                      AS  BGRQ       --1    报告日期
           ,T1.RCPT_ID                                      AS  JYWYM      --2    交易唯一码
           ,T1.CUST_NO                                      AS  KHWYM      --3    客户唯一码
           ,T1.SGL_CRDT_AMT                                 AS  SXED       --5    报告日客户授信总额（元）
           ,T1.CON_CRDT_TOT_AMT                             AS  XFDKSXED   --6    报告日消费贷款授信额度（元）
           ,CASE WHEN T1.CON_CRDT_TOT_AMT=0 THEN NULL
                 WHEN T1.CON_CRDT_TOT_AMT <= 10000 
                 THEN '单户授信1万元（含）以下'--单户授信1万元（含）以下
                 WHEN T1.CON_CRDT_TOT_AMT <= 100000  
                  AND T1.CON_CRDT_TOT_AMT > 10000
                 THEN '单户授信1万-10万元（含）'--单户授信1万-10万元（含）
                 WHEN T1.CON_CRDT_TOT_AMT > 100000 
                 THEN '单户授信10万元以上'
            END                                             AS  PHXFSXQJ   --7    报告日消费授信区间
           ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
                 WHEN T1.LVL5_CL = '02' THEN '关注类'
                 WHEN T1.LVL5_CL = '03' THEN '次级类'
                 WHEN T1.LVL5_CL = '04' THEN '可疑类'
                 WHEN T1.LVL5_CL = '05' THEN '损失类'
                 ELSE '不适用'
            END                                             AS  WJFL       --8    五级分类
          ,CASE WHEN T1.LVL5_CL IN ('03','04','05') 
                THEN '是'
                ELSE '否'
           END                                              AS  SFBL       --9    是否不良
          ,T1.LOAN_NET_VAL*T6.EXRT                          AS  TJYE       --10   统计余额（元）
          ,CASE WHEN T2.DKJJBH IS NOT NULL 
                THEN '是'
                ELSE '否'
           END                                              AS  SFLSPKH    --11   是否历史贫困户
          ,'否'                                             AS  SFDBH      --12   是否低保户
          ,T7.FF_CRDT_TOTAL_LMT/*FF_CON_CRDT_TOT_AMT*/                           AS  FKSSXED    --13   放款月客户授信总额（元）
          ,T1.LOAN_AMT                                      AS  FKJE       --14   放款金额（元）
          ,T3.EXEC_RATE                                     AS  ZXLL       --15   执行利率（年）
          ,T1.INCOME_ANNUAL                                 AS  NHSY       --16   年化利息收益（元）
          ,/*T1.LOAN_ACT_DSTR_DT*/T3.LOAN_ACT_DSTR_DT       AS  FKR        --17   放款日 MDF BY LWB 20240925
          ,T1.ORG_NO                                        AS  ZWJGBH     --18   机构编号
          ,T4.ORG_NM                                        AS  ZWJGMC     --19   机构名称
          ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN '个人经营性贷款'    				  --个人经营性贷款
	   			      WHEN T1.LOAN_BIZ_TYP = '010501' THEN '信用卡汽车分期'    						--信用卡汽车分期
	   			      WHEN T1.LOAN_BIZ_TYP = '010502' THEN '信用卡房屋装修分期'    				--信用卡房屋装修分期
	   			      WHEN T1.LOAN_BIZ_TYP = '010503' THEN '信用卡其他'    						    --信用卡其他
	   			      WHEN T1.LOAN_BIZ_TYP = '010301' THEN '汽车'    						           --汽车
	   			      WHEN T1.LOAN_BIZ_TYP = '010101' THEN '住房按揭贷款'      						 --住房按揭贷款
	   			      WHEN T1.LOAN_BIZ_TYP LIKE '01%' AND T3.LOAN_USEAGE IN ( '装修','装修房屋')  THEN '房屋装修贷款'    --房屋装修贷款
	   			      WHEN T1.LOAN_BIZ_TYP LIKE '01%' AND T3.LOAN_USEAGE = '购置耐用消费品' THEN '大件耐用消费品贷款'  		--大件耐用消费品贷款
	   			      WHEN T1.LOAN_BIZ_TYP IN ('010402','010403') THEN '国家助学贷款'      --国家助学贷款
	   			      WHEN T1.LOAN_BIZ_TYP = '010404' THEN '生源地助学贷款'    						--生源地助学贷款
	   			      WHEN T1.LOAN_BIZ_TYP = '010405' THEN '商业性助学贷款'    						--商业性助学贷款
	   			      WHEN T1.LOAN_BIZ_TYP = '010407' THEN '校园消费贷款' 								 --校园消费贷款
	   			      ELSE '其他'                                                          --其他
	   			 END                                               AS  GRDKYTLBMC --20   个人贷款用途类别名称
          ,CASE WHEN T5.FARM_FLG = 'Y'  THEN '农户'
                ELSE '非农户'
           END                                               AS  SNDKFLMC   --21   ECIF是否农户
          ,T1.FF_CON_CRDT_TOT_AMT                            AS  XFDKSXED2  --22   放款月消费授信额度（元）
          ,CASE WHEN T1.FF_CON_CRDT_TOT_AMT=0 THEN NULL
                WHEN T1.FF_CON_CRDT_TOT_AMT <= 10000 
                THEN '单户授信1万元（含）以下'--单户授信1万元（含）以下
                WHEN T1.FF_CON_CRDT_TOT_AMT <= 100000  
                 AND T1.FF_CON_CRDT_TOT_AMT > 10000
                THEN '单户授信1万-10万元（含）'--单户授信1万-10万元（含） 20231017
                WHEN T1.FF_CON_CRDT_TOT_AMT > 100000
                THEN '单户授信10万元以上'
           END                                               AS  PHXFSXQJ2  --23   放款月消费授信区间
          ,T3.LOAN_STD_PROD_NM                               AS  DKYWPZMC   --24   贷款业务品种名称
          ,t7.OPR_CUST_TYP                                   AS  FKSTJXWLB  --25   放款时统计小微企业类别
          ,T1.DSBR_FARM_FLG                                  AS  FKSNHBS    --26   放款时农户标识
     FROM RRP_MDL.S_LOAN_S7103 T1  --S7103普惠型消费贷款明细表
     LEFT JOIN RRP_MDL.S_LOAN_A3326 T2  --A3326明细结果表
       ON T2.DKJJBH = T1.RCPT_ID
      AND T2.SJRQ = V_P_DATE
     LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO T3 --表内借据信息
       ON T3.RCPT_ID = T1.RCPT_ID
      AND T3.DATA_DT =V_P_DATE
     LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T4 --机构表
       ON T4.ORG_ID = T1.ORG_NO
      AND T4.DATA_DT = V_P_DATE
     LEFT JOIN RRP_MDL.S_LOAN_AGR_REL T5 -- 涉农贷款S层表
       ON T5.RCPT_ID = T1.RCPT_ID
      AND T5.DATA_DT = V_P_DATE
     LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO T6  --汇率表
       ON T6.BASE_CUR = T1.CURR_CD  --基准币种
      AND T6.CNV_CUR = 'CNY'     --折算币种
      AND T6.DATA_DT = V_P_DATE
     LEFT JOIN RRP_MDL.S_LOAN_AMT_S71 T7 --S71普惠小微发放时授信额度表
       ON T7.RCPT_ID = T1.RCPT_ID
      AND T7.DATA_DT = V_P_DATE
    WHERE T1.DATA_DT =V_P_DATE
      AND ((T1.LOAN_BAL > 0 /*AND T1.CON_CRDT_TOT_AMT <= 100000*/ )-- 取存量业务数据
          OR (SUBSTR(T1.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4) /*AND T1.LOAN_AMT <= 100000*/)) --明细展示取当年放款
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
      FROM RRP_MDL.A_PHB_S71_CONSUME T
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

  END ETL_A_PHB_S71_CONSUME;
/

