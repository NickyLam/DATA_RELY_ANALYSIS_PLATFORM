CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_ACCT_LOAN_WSD
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_ACCT_LOAN_WSD
  *  功能描述：网商贷账务基表
  *  创建日期：20230616
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_ACCT_LOAN_WSD --网商贷账务基表
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人        修改原因
  *   1    20230616   liuyu         创建过程
  *   2    20230823   LWB           修改区域代码关联重复的问题
  *   3    20230824   lwb           新增借据状态字段，修改出资比例的规则
  *   4    20231017   HYF           修改出资比例，直取表内借据表
  *   5    20240604   YJY           新增担保方字段，参考G5305网商贷担保机构逻辑
  *   6    20240625   YJY           调整担保合同的规则，无效的担保合同也取
  *   7    20240807   YJY           由于押品系统的贷款合同与担保合同关系表会删除已经失效的担保合同信息，会丢失当年放款当年结清的数据。需调整这部分数据从监管模型M_GUA_REL_BSN_CONT表中补这部分当年放款当年结清且失效的数据。
  *   8    20240819   YJY           优化有效和当年失效的担保机构数据
  *   9    20241119   HYF           修改循环贷，新增网商贷时点客户类型_人行、企业名称_网商贷
  *   10   20250711   HYF           合同实际期限区间名称同原始期限区间名称逻辑保持一致
  *   11   20251203   HYF           修改期限按照12个月算
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_ACCT_LOAN_WSD';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100);    --表名
  V_PART_NAME  VARCHAR2(100);    --分区名
  V_LAST_YEAR_END    VARCHAR2(8); --上年年末      --ADD IN 20240604
  V_THIS_YEAR_BEGIN  VARCHAR2(8); --本年年初      --分析：于敬艺
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_ACCT_LOAN_WSD'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  V_LAST_YEAR_END := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'); --上年年末      --ADD IN 20240604
  V_THIS_YEAR_BEGIN := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD'),'YYYYMMDD'); --本年年初      --分析：于敬艺


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := 2 ;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 3 ;
  V_STEP_DESC := '网商贷数据_插入主表';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.A_PHB_ACCT_LOAN_WSD NOLOGGING
    (
           BGRQ                               --01 报告日期
          ,XDJJH                              --02 信贷借据号
          ,KHH                                --03 客户号
          ,SFZH                               --04 身份证号
          ,KHMC                               --05 客户名称
          ,TJXWQYLB                           --06 统计小微企业类别
          ,SFPHXWQY                           --07 是否普惠小微企业
          ,SFNH                               --08 是否农户
          ,SSSF                               --09 所属省份
          ,SSCS                               --10 所属城市
          ,JZDZ                               --11 居住地址
          ,SFGDSNDK                           --12 是否广东省内贷款
          ,SFWHFZHSZDDK                       --13 是否我行分支行所在地贷款
          ,DKPZ                               --14 贷款品种
          ,ZDBFSMC                            --15 主担保方式名称
          ,YWCZMS                             --16 业务出资模式
          ,DKFFNF                             --17 贷款发放年份
          ,SNMWJFL                            --18 上年末五级分类
          ,YSQSRQ                             --19 原始起始日期
          ,YSDQRQ                             --20 原始到期日期
          ,SJJQRQ                             --21 实际结清日期
          ,FKSZSXED                           --22 放款时总授信额度（元）
          ,FKSJYXSXED                         --23 放款时经营性贷款授信额度（元）
          ,FKSZSXEDQJ                         --24 放款时总授信额度区间
          ,FKSJYXSXEDQJ                       --25 放款时经营性贷款授信额度区间
          ,FKJE                               --26 放款金额（元）
          ,ZXLL                               --27 执行利率
          ,NHLX                               --28 年化利息（元）
          ,LXSYL                              --29 利息收益率
          ,SYLX                               --30 收益利率
          ,LXSY                               --31 利息收益（元）
          ,QXLB                               --32 期限类别
          ,QXT                                --33 期限天
          ,QXY                                --34 期限月
          ,FKJEQXY                            --35 放款金额（元）*期限月
          ,QXQJ                               --36 期限区间
          ,DKHKFS                             --37 贷款还款方式
          ,TXGMJJHYML                         --38 投向国民经济行业门类
          ,TXGMJJHYDL                         --39 投向国民经济行业大类
          ,SSHYML                             --40 所属行业门类
          ,SSHYDL                             --41 所属行业大类
          ,SFHX                               --42 是否核销
          ,SDZSXED                            --43 时点总授信额度（元）
          ,SDJYXSXED                          --44 时点经营性贷款授信额度（元）
          ,SDZSXEDQJ                          --45 时点总授信额度区间
          ,SDJYXSXEDQJ                        --46 时点经营性贷款授信额度区间
          ,DKYE                               --47 贷款余额（元）
          ,ZCBJ                               --48 正常本金（元）
          ,YQBJ                               --49 逾期本金（元）
          ,DKLX                               --50 贷款利息（元）
          ,ZCLX                               --51 正常利息
          ,QX                                 --52 欠息（含罚息复利）
          ,HXRQ                               --53 核销日期
          ,HXBJ                               --54 核销本金
          ,HXLX                               --55 核销利息
          ,HXHBJYE                            --56 核销后本金余额
          ,HXHLXYE                            --57 核销后利息余额
          ,WJFLMC                             --58 五级分类名称
          ,SFYQDK                             --59 是否逾期贷款
          ,SFBLDK                             --60 是否不良贷款
          ,ZYQTS                              --61 总逾期天数
          ,BJYQTS                             --62 本金逾期天数
          ,LXYQTS                             --63 利息逾期天数
          ,ZZYQRQ                             --64 最早逾期日期
          ,YQQJG09                            --65 逾期区间G09
          ,YQQJS63                            --66 逾期区间S63
          ,KHNL                               --67 客户年龄
          ,JJZT                               --68借据状态 modify by lwb
          ,DBF                                --69 担保方    ADD IN 20240604
          ,WSDSDKHLX_RH                       --70 网商贷时点客户类型_人行 ADD BY HYF 20241119
          ,QYMC_WSD                           --71 企业名称_网商贷 ADD BY HYF 20241119
    )
WITH GUARTOR_NAME_TMP1 AS   --多对多，取担保公司名称包含“融资担保”的数据
      (
            SELECT /*+ materialize*/
                   B.LOAN_CONT_ID    AS LOAN_CONT_ID,
                   LISTAGG(A.GUARTOR_NAME,',') WITHIN GROUP(ORDER BY B.LOAN_CONT_ID) AS GUARTOR_NAME --担保机构名称
              FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A --联合网贷担保合同信息
        INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B --联合网贷贷款与担保合同关系
                ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
               AND A.GUARTOR_NAME LIKE '%融资担保%'
          GROUP BY B.LOAN_CONT_ID
     ),
  -- MOD BY YJY IN 20240807 处理当年失效的担保合同
  GUARTOR_NAME_TMP2 AS
    (       SELECT /*+ materialize*/ *
             FROM (SELECT T1.BIZ_CONT_ID        AS LOAN_CONT_ID
                         ,T2.GUARTOR_NAME       AS GUARTOR_NAME
                         ,ROW_NUMBER() OVER(PARTITION BY T1.BIZ_CONT_ID ORDER BY T1.DATA_DT DESC) AS RN
                     FROM RRP_MDL.M_GUA_REL_BSN_CONT  T1
                    INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO T2
                            ON T1.GUA_CONT_ID =T2.GUAR_CONT_ID
                           AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                           AND T2.GUARTOR_NAME LIKE '%融资担保%'
                    WHERE T1.DATA_DT >= V_THIS_YEAR_BEGIN
                      AND T1.DATA_DT < V_P_DATE
                      AND SUBSTR(T1.GUA_REL_RLV_DT,0,4)=SUBSTR(V_P_DATE,0,4)
                      AND T1.DATA_SRC ='联合网贷'
                 )
        WHERE RN=1
    ),
 GUARTOR_NAME_TMP3 AS
     (     SELECT /*+ materialize*/
                 LOAN_CONT_ID
                 ,GUARTOR_NAME
             FROM GUARTOR_NAME_TMP1
            UNION ALL
           SELECT /*+ materialize*/
                  LOAN_CONT_ID
                 ,GUARTOR_NAME
             FROM GUARTOR_NAME_TMP2  T1
            WHERE T1.LOAN_CONT_ID NOT IN  (SELECT T2.LOAN_CONT_ID  FROM GUARTOR_NAME_TMP1  T2)   --MOD BY YJY IN 20240819
     )
   SELECT /*+USE_HASH(T1,T2,T3,T4,T5,T6,T7,T8,M1,M2,M3,M4,M5)*/
           T1.DATA_DT                        AS BGRQ                --01 报告日期
          ,T1.RCPT_ID                        AS XDJJH                --02 信贷借据号
          ,T1.CUST_ID                        AS KHH                  --03 客户号
          ,T3.CRDL_NO                        AS SFZH                --04 身份证号
          ,T3.CUST_NM                        AS KHMC                --05 客户名称
          ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%' THEN  -- 取经营贷款客户
                CASE WHEN T1.OPR_CUST_TYP = 'A' THEN '个体工商户'
                     WHEN T1.OPR_CUST_TYP = 'B' THEN '小微企业主'
                     WHEN T1.OPR_CUST_TYP = 'Z' THEN '其他个人经营客户'
                     ELSE '其他个人经营客户'
                END
                ELSE '不适用'
           END                               AS TJXWQYLB            --06 统计小微企业类别
          ,CASE WHEN T1.LOAN_BIZ_TYP LIKE '0102%'
                     AND T1.OPR_CUST_TYP IN ('A','B')
                     AND T1.OPR_CRDT_TOT_AMT <= 10000000   -- 取经营额度判断
                THEN '是'
                ELSE '否'
           END                               AS SFPHXWQY            --07 是否普惠小微企业
          ,DECODE(T1.FARM_FLG,'Y','是','否') AS SFNH                --08 是否农户
          ,NVL(M6.SRC_VALUE_NAME,T3.CUST_BLNG_LAND_AREA_CD)
                                             AS SSSF                --09 所属省份
          ,NVL(M7.TAR_VALUE_NAME,T3.CUST_BLNG_LAND_AREA_CD)
                                             AS SSCS                --10 所属城市
          ,NVL(T3.RSDNC_ADDR,T3.RSDNC_AREA_CD)
                                             AS JZDZ                --11 居住地址
          ,CASE WHEN SUBSTR(T3.CUST_BLNG_LAND_AREA_CD,0,2) = '44'
                THEN '是'
                WHEN T3.RSDNC_ADDR LIKE '广东省%'
                THEN '是'
                ELSE '否'
           END                               AS SFGDSNDK            --12 是否广东省内贷款
          ,CASE WHEN SUBSTR(T3.CUST_BLNG_LAND_AREA_CD,0,4)
                IN ('4401','4403','4404','4405','4406','4407','4408','4412','4413','4419','4420')
                THEN '是'
                ELSE '否'
           END                                AS SFWHFZHSZDDK        --13 是否我行分支行所在地贷款
          ,T2.LOAN_PROD_NM                   AS DKPZ                --14 贷款品种
          ,DECODE(T1.GUA_MODE,'1','抵押','2','质押','3','保证','4','信用','不适用')
                                             AS ZDBFSMC            --15 主担保方式名称
          ,T2.FND_PCT                        AS YWCZMS              --16 业务出资模式
          ,SUBSTR(T1.LOAN_ACT_DSTR_DT,0,4)   AS DKFFNF              --17 贷款发放年份
           -- 每个自然年的最后一天归为下一年，如2022-12-31的贷款发放年份算2023年
          ,CASE WHEN T4.LVL5_CL = '01' THEN '正常类'
                WHEN T4.LVL5_CL = '02' THEN '关注类'
                WHEN T4.LVL5_CL = '03' THEN '次级类'
                WHEN T4.LVL5_CL = '04' THEN '可疑类'
                WHEN T4.LVL5_CL = '05' THEN '损失类'
           END                               AS SNMWJFL              --18 上年末五级分类
          ,TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYY/MM/DD')
                                             AS YSQSRQ              --19 原始起始日期
          ,TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYY/MM/DD')
                                             AS YSDQRQ              --20 原始到期日期
          ,TO_DATE(T2.ACT_END_DT,'YYYY/MM/DD')
                                             AS SJJQRQ              --21 实际结清日期
          ,T5.FF_CRDT_TOTAL_LMT              AS FKSZSXED            --22 放款时总授信额度（元）
          ,T5.FF_OPR_CRDT_TOT_AMT            AS FKSJYXSXED          --23 放款时经营性贷款授信额度（元）
          ,CASE WHEN T5.FF_CRDT_TOTAL_LMT <= 100000   THEN '10万（含）以内'
                WHEN T5.FF_CRDT_TOTAL_LMT <= 1000000  THEN '10-100万（含）'
                WHEN T5.FF_CRDT_TOTAL_LMT <= 5000000  THEN '100-500万（含）'
                WHEN T5.FF_CRDT_TOTAL_LMT <= 10000000 THEN '500-1000万（含）'
                WHEN T5.FF_CRDT_TOTAL_LMT <= 30000000 THEN '1000-3000万（含）'
                WHEN T5.FF_CRDT_TOTAL_LMT >  30000000 THEN '3000万以上'
           END                               AS FKSZSXEDQJ          --24 放款时总授信额度区间
          ,CASE WHEN T5.FF_OPR_CRDT_TOT_AMT <= 100000   THEN '10万（含）以内'
                WHEN T5.FF_OPR_CRDT_TOT_AMT <= 1000000  THEN '10-100万（含）'
                WHEN T5.FF_OPR_CRDT_TOT_AMT <= 5000000  THEN '100-500万（含）'
                WHEN T5.FF_OPR_CRDT_TOT_AMT <= 10000000 THEN '500-1000万（含）'
                WHEN T5.FF_OPR_CRDT_TOT_AMT <= 30000000 THEN '1000-3000万（含）'
                WHEN T5.FF_OPR_CRDT_TOT_AMT >  30000000 THEN '3000万以上'
           END                               AS FKSJYXSXEDQJ        --25 放款时经营性贷款授信额度区间
          ,T1.LOAN_AMT                       AS FKJE                --26 放款金额（元）
          ,T2.EXEC_RATE/100                  AS ZXLL                --27 执行利率
          ,T1.INCOME_ANNUAL                  AS NHLX                --28 年化利息（元）
          ,CASE WHEN T1.LOAN_AMT= 0 THEN 0
           ELSE T1.INCOME_ANNUAL/T1.LOAN_AMT*100 END
                                             AS LXSYL               --29 利息收益率
          ,CASE WHEN T1.LOAN_AMT= 0 THEN 0
           ELSE T1.INCOME_ANNUAL/T1.LOAN_AMT*100 END                               
                                             AS SYLX               --30 收益利率
          ,T1.INCOME_ANNUAL                  AS LXSY                --31 利息收益（元）
          ,CASE WHEN T1.LOAN_TERM IN ('S') THEN '短期'
                WHEN T1.LOAN_TERM IN ('M','L') THEN '中长期'
                ELSE '不适用'
           END                               AS QXLB                --32 期限类别
          ,TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')
                                             AS QXT                  --33 期限天
/*          ,(TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30
                                             AS QXY                 --34 期限月*/
          ,MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                             AS QXY                 --34 期限月
/*          ,T1.LOAN_AMT  * (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30*/
          ,T1.LOAN_AMT*MONTHS_BETWEEN(TO_DATE(T1.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD'))
                                             AS FKJEQXY             --35 放款金额（元）*期限月
/*          ,CASE WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >60 THEN 'L'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >36 THEN 'M'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >24 THEN 'M'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=13 THEN 'M'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >6 THEN 'S'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >3 THEN 'S'
                WHEN (TO_DATE(T2.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(T2.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=0 THEN 'S'
           END                               AS QXQJ              --36 期限区间*/
          ,T1.LOAN_TERM                      AS QXQJ              --36 期限区间
          ,M1.SRC_VALUE_NAME                 AS DKHKFS            --37 贷款还款方式
          ,M2.SRC_VALUE_NAME                 AS TXGMJJHYML        --38 投向国民经济行业门类
          ,M3.SRC_VALUE_NAME                 AS TXGMJJHYDL        --39 投向国民经济行业大类
          ,M4.SRC_VALUE_NAME                 AS SSHYML            --40 所属行业门类
          ,M5.SRC_VALUE_NAME                 AS SSHYDL            --41 所属行业大类
          ,DECODE(T6.WRT_OFF_FLG,'1','是','否')
                                             AS SFHX                --42 是否核销
          ,T1.SGL_CRDT_AMT                   AS SDZSXED            --43 时点总授信额度（元）
          ,T1.OPR_CRDT_TOT_AMT               AS SDJYXSXED          --44 时点经营性贷款授信额度（元）
          ,CASE WHEN T1.SGL_CRDT_AMT <= 100000   THEN '10万（含）以内'
                WHEN T1.SGL_CRDT_AMT <= 1000000  THEN '10-100万（含）'
                WHEN T1.SGL_CRDT_AMT <= 5000000  THEN '100-500万（含）'
                WHEN T1.SGL_CRDT_AMT <= 10000000 THEN '500-1000万（含）'
                WHEN T1.SGL_CRDT_AMT <= 30000000 THEN '1000-3000万（含）'
                WHEN T1.SGL_CRDT_AMT >  30000000 THEN '3000万以上'
           END                               AS SDZSXEDQJ          --45 时点总授信额度区间
          ,CASE WHEN T1.OPR_CRDT_TOT_AMT <= 100000   THEN '10万（含）以内'
                WHEN T1.OPR_CRDT_TOT_AMT <= 1000000  THEN '10-100万（含）'
                WHEN T1.OPR_CRDT_TOT_AMT <= 5000000  THEN '100-500万（含）'
                WHEN T1.OPR_CRDT_TOT_AMT <= 10000000 THEN '500-1000万（含）'
                WHEN T1.OPR_CRDT_TOT_AMT <= 30000000 THEN '1000-3000万（含）'
                WHEN T1.OPR_CRDT_TOT_AMT >  30000000 THEN '3000万以上'
           END                               AS SDJYXSXEDQJ        --46 时点经营性贷款授信额度区间
          ,T1.LOAN_NET_VAL                   AS DKYE              --47 贷款余额（元）
          ,T6.NOMAL_PRIC                     AS ZCBJ              --48 正常本金（元）
          ,T6.OVDUE_PRIC                     AS YQBJ              --49 逾期本金（元）
          ,T6.NOMAL_INT+T6.NOMAL_INT AS DKLX                --50 贷款利息（元）
          ,T6.NOMAL_INT                      AS ZCLX                --51 正常利息
          ,T6.OVDUE_INT+T6.RECVBL_OVER_INT+T6.RECVBL_PNLT
                                             AS QX                  --52 欠息（含罚息复利）
          ,T8.FIR_WRT_OFF_DT                 AS HXRQ                --53 核销日期
          ,T6.WRT_OFF_PRIC                   AS HXBJ                --54 核销本金
          ,T6.WRT_OFF_INT
                                             AS HXLX                --55 核销利息
          ,T6.PRIC_BAL - T6.WRT_OFF_PRIC
                                             AS HXHBJYE            --56 核销后本金余额
          ,T6.NOMAL_INT + T6.NOMAL_INT - T6.WRT_OFF_INT
                                             AS HXHLXYE            --57 核销后利息余额
          ,CASE WHEN T1.LVL5_CL = '01' THEN '正常类'
                WHEN T1.LVL5_CL = '02' THEN '关注类'
                WHEN T1.LVL5_CL = '03' THEN '次级类'
                WHEN T1.LVL5_CL = '04' THEN '可疑类'
                WHEN T1.LVL5_CL = '05' THEN '损失类'
           END                              AS WJFLMC              --58 五级分类名称
          ,CASE WHEN NVL(T1.OVD_DAYS,0) > 0 THEN '是'
                ELSE '否'
           END                              AS SFYQDK              --59 是否逾期贷款
          ,CASE WHEN T1.LVL5_CL IN ('03','04','05') THEN '是'
                ELSE '否'
           END                              AS SFBLDK              --60 是否不良贷款
          ,NVL(T1.OVD_DAYS,0)               AS ZYQTS              --61 总逾期天数
          ,CASE WHEN TRIM(T2.PRIN_OVD_DT) IS NOT NULL
                THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(T2.PRIN_OVD_DT,'YYYYMMDD')
           END                              AS BJYQTS              --62 本金逾期天数
          ,CASE WHEN TRIM(T2.INT_OVD_DT) IS NOT NULL
                THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(T2.INT_OVD_DT,'YYYYMMDD')
           END                              AS LXYQTS              --63 利息逾期天数
          ,CASE WHEN NVL(T1.OVD_DAYS,0) > 0
                THEN TO_DATE(V_P_DATE,'YYYYMMDD') - T1.OVD_DAYS
           END                              AS ZZYQRQ              --64 最早逾期日期
          ,CASE WHEN NVL(T1.OVD_DAYS,0) = 0    THEN '逾期0天(未逾期）'
                WHEN NVL(T1.OVD_DAYS,0) <= 30  THEN '逾期1-30天贷款'
                WHEN NVL(T1.OVD_DAYS,0) <= 60  THEN '逾期31-60天贷款'
                WHEN NVL(T1.OVD_DAYS,0) <= 90  THEN '逾期61-90天贷款'
                WHEN NVL(T1.OVD_DAYS,0) <= 360 THEN '逾期91-360天贷款'
           END                              AS YQQJG09            --65 逾期区间G09
          ,CASE WHEN NVL(T1.OVD_DAYS,0) = 0    THEN '未逾期'
                WHEN NVL(T1.OVD_DAYS,0) <= 60  THEN '逾期60天以内'
                WHEN NVL(T1.OVD_DAYS,0) <= 90  THEN '逾期61天-90天'
                WHEN NVL(T1.OVD_DAYS,0) <= 360 THEN '逾期91天到360天'
                WHEN NVL(T1.OVD_DAYS,0) > 360  THEN '逾期361天以上'
           END                              AS YQQJS63            --66 逾期区间S63
          ,FLOOR(MONTHS_BETWEEN(TO_DATE(V_P_DATE,'YYYYMMDD')
               ,TO_DATE(SUBSTR(T3.CRDL_NO,7,8),'YYYYMMDD')
                )/12
                )                    AS KHNL               --67客户年龄
          ,CASE WHEN T1.RCPT_STAT='C0201' THEN '核销'
                WHEN T1.RCPT_STAT='A' THEN '正常'
                WHEN T1.RCPT_STAT='B' THEN '逾期'
                WHEN T1.LOAN_NET_VAL=0 THEN '结清'
                END AS JJZT   --68 借据状态
          ,T12.GUARTOR_NAME          AS DBF       --69 担保方    ADD IN 20240604
          ,CASE WHEN T1.OPR_CUST_TYP_WSD_RH = 'A' THEN '个体工商户'
               WHEN T1.OPR_CUST_TYP_WSD_RH = 'B' THEN '小微企业主'
           END                       AS OPR_CUST_TYP_WSD_RH       --70 时点客户类型_人行
          ,T1.CUST_NM_WSD            AS QYMC_WSD                  --71 企业名称_网商贷
      FROM RRP_MDL.S_LOAN                      T1 --S层借据表
      LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO  T2 --M层表内借据表
        ON T2.RCPT_ID = T1.RCPT_ID
       AND T2.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_IND_INFO        T3 --个人客户信息表
        ON T3.CUST_ID = T1.CUST_ID
       AND T3.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_LOAN                 T4 --上年末五级分类
        ON T4.RCPT_ID = T1.RCPT_ID
       AND T4.DATA_DT = SUBSTR(V_P_DATE,0,4) - 1 || '1231'
      LEFT JOIN RRP_MDL.S_LOAN_AMT_S71         T5
        ON T5.RCPT_ID = T1.RCPT_ID
       AND T5.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO  T6 -- 数仓借据表
        ON T6.DUBIL_ID = T1.RCPT_ID
       AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO T8 --联合网贷核销信息
        ON T1.RCPT_ID = T8.DUBIL_ID
       AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP M1 --码值表
        ON M1.TAR_CLASS_CODE = 'CD1072' --还款方式
       AND M1.SRC_CLASS_CODE = 'CD1072'
       AND M1.MOD_FLG = 'EAST'
       AND M1.SRC_VALUE_CODE = T1.GXH_PAY_TYPE
      LEFT JOIN RRP_MDL.CODE_MAP M2 --码值表
        ON M2.TAR_CLASS_CODE = 'P0003' --行业类别
       AND M2.SRC_CLASS_CODE = 'P0003'
       AND M2.MOD_FLG = 'MDM'
       AND M2.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,1) --投向行业 门类
      LEFT JOIN RRP_MDL.CODE_MAP M3 --码值表
        ON M3.TAR_CLASS_CODE = 'P0003' --行业类别
       AND M3.SRC_CLASS_CODE = 'P0003'
       AND M3.MOD_FLG = 'MDM'
       AND M3.SRC_VALUE_CODE = SUBSTR(TRIM(T1.LOAN_DIR_IDY),1,3) --投向行业 大类
      LEFT JOIN RRP_MDL.CODE_MAP M4 --码值表
        ON M4.TAR_CLASS_CODE = 'P0003' --行业类别
       AND M4.SRC_CLASS_CODE = 'P0003'
       AND M4.MOD_FLG = 'MDM'
       AND M4.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,1) --所属行业 门类
      LEFT JOIN RRP_MDL.CODE_MAP M5 --码值表
        ON M5.TAR_CLASS_CODE = 'P0003' --行业类别
       AND M5.SRC_CLASS_CODE = 'P0003'
       AND M5.MOD_FLG = 'MDM'
       AND M5.SRC_VALUE_CODE = SUBSTR(TRIM(T1.CUST_BLNG_IDY),1,3) --所属行业 大类
      /*LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO_BFD@LINK_RRP M6
        ON M6.AREA_CD = T3.RSDNC_AREA_CD*/
      LEFT JOIN RRP_MDL.CODE_MAP M6 --所在地区 省
       ON M6.TAR_VALUE_CODE = SUBSTR(T3.CUST_BLNG_LAND_AREA_CD,0,2)||'0000'
      AND M6.SRC_CLASS_CODE = 'CD00002'
      AND M6.TAR_CLASS_CODE = 'CD00002'
      AND M6.MOD_FLG = 'BFD'
      LEFT JOIN (SELECT DISTINCT TAR_VALUE_CODE,TAR_VALUE_NAME FROM RRP_MDL.CODE_MAP
                   WHERE  SRC_CLASS_CODE = 'CD00002'
                      AND TAR_CLASS_CODE = 'CD00002'
                      AND MOD_FLG = 'BFD') M7 --所在地区 市
       ON M7.TAR_VALUE_CODE = SUBSTR(T3.CUST_BLNG_LAND_AREA_CD,0,4)||'00'
      LEFT JOIN RRP_MDL.CODE_MAP M8 --所在地区 区
       ON M8.TAR_VALUE_CODE = SUBSTR(T3.CUST_BLNG_LAND_AREA_CD,0,6)
      AND M8.SRC_CLASS_CODE = 'CD00002'
      AND M8.TAR_CLASS_CODE = 'CD00002'
      AND M8.MOD_FLG = 'BFD'
    --ADD IN 20240604 BEGIN 担保方逻辑加工--
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO  T10 --联合网贷借据信息   当前数据
          ON T1.RCPT_ID = T10.DUBIL_ID
       AND T10.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO  T11 --联合网贷借据信息   上年末已结清的借据
          ON T1.RCPT_ID = T11.DUBIL_ID
       AND T11.ETL_DT = TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')
   LEFT JOIN GUARTOR_NAME_TMP3 T12
       ON T12.LOAN_CONT_ID = NVL(T10.CONT_ID,T11.CONT_ID)
   -- ADD IN 20240604 END 担保方逻辑加工 --
     WHERE T1.DATA_DT = V_P_DATE
       AND T1.DATA_SRC = '联合网贷'
       AND T1.STD_PROD_ID IN ('202020100001','202020200004') --网商贷/网商贷引流
       AND (T1.LOAN_NET_VAL  <> 0
            OR T2.LOAN_ACT_DSTR_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') - 1,'YYYYMMDD')--联合网贷新增去年末数据
            OR T2.rcpt_stat='C0201')--核销的数据
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
    SELECT BGRQ,XDJJH,COUNT(1)
      FROM RRP_MDL.A_PHB_ACCT_LOAN_WSD T
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ,XDJJH
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

  END ETL_A_PHB_ACCT_LOAN_WSD;
/

