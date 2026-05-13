CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_G5305(I_P_DATE IN INTEGER,
                                            O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_A_PHB_G5305
  *  功能描述：零售-融资担保机构代偿模型（G5305）
  *  创建日期：20221107
  *  开发人员：WYX
  *  来源表：
  *  目标表：A_PHB_G5305           --零售-融资担保机构代偿模型（G5305）
  *  配置表：M_ZFXRZDBJGMD         --GD04_13政府性融资担保机构名单
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221031   WYX        首次创建
  *   2    20240425   YJY        调整逻辑零售、网商贷从s_loan贷款业务整合表出数：
                                 1、202020200007-新心金融小微贷的产品全取，该产品部分担保方式为‘信用’的写死为‘保证’，对应的担保机构名称写死‘广东中盈盛达融资担保投资股份有限公司’，一直到结清为止。
                                 2、'202010200005'-平安普惠（消费）, '202020200002'-平安普惠（经营） 这两个产品只要20220701之后放款的数据
                                 3、‘是否普惠小微企业’按照S71贷款余额的口径取值
                                 4、借据号为‘R202111010055118353’、‘R202112170083231921’、‘R202111170064419596’、‘R202111100058868885’、‘R202111190065819809’
                                   业务反馈这5笔属于阶段性担保，目前也未结清，之前珠海分行是因为先做阶段性担保，办完抵押后客户经理自己觉得加一个保证比较好，现在如果让客户经理在系统更改，就要做贷后担保变更比较麻烦 。
                                   珠海分行反馈后续不会出现这种情况，加上之前每个季度都没报过这5笔，故写死不取这5笔借据。
                                 5、担保方式的获取逻辑为：主担保方式或子担保方式中含有‘保证’都纳取
                                 6、数据范围：贷款未结清或者本年发放或者往年发放且贷款已结清但有代偿金额
                                 7、深圳担保集团有限公司纳入融资担保机构
                                 8、零售非网商贷部分的代偿金额，经广州分行李逸申确认口径：用理赔确认表中的借据号匹配理赔申请表的借据号，取理赔申请表中最后一条申请记录，统计的理赔本金即为理赔申请表中的逾期总本金+未到期本金
  *   3    20240626   YJY        调整，担保合同有效标识不做限制;新增'担保合同是否有效标识'字段
  *   4    20240807   YJY        由于押品系统的贷款合同与担保合同关系表会删除已经失效的担保合同信息，会丢失当年放款当年结清的数据。需调整这部分数据从监管模型M_GUA_REL_BSN_CONT表中补这部分当年放款当年结清且失效的数据。
  *   5    20240819   YJY        优化代偿金额关联条件
  *   6    20241015   YJY        调整联合网贷逻辑，本年的放款参数改为上年年末
  *   7    20251225   HYF        修改贷款合同与担保合同关系表过滤取当前跑批日期
  **********************************************************************/
 AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_G5305';   --程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ; --表名
  V_PART_NAME  VARCHAR2(100); --分区名
  V_THIS_YEAR_BEGIN  VARCHAR2(8); --本年年初      --分析：于敬艺
  V_LAST_YEAR_END    VARCHAR2(8); --上年年末      --分析：于敬艺

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_G5305'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期
  V_THIS_YEAR_BEGIN := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD'),'YYYYMMDD'); --本年年初      --分析：于敬艺
  V_LAST_YEAR_END := TO_CHAR(TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD')-1,'YYYYMMDD'); --上年年末      --分析：于敬艺

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
  V_STEP      := 1 ;
  V_STEP_DESC := '零售-平安普惠（消费）平安普惠（经营）'; --'202010200005'-平安普惠（消费）, '202020200002'-平安普惠（经营） 这两个产品只要放款日期是20220701之后的数据
  V_STARTTIME := SYSDATE;
INSERT /*+APPEND*/ INTO A_PHB_G5305 NOLOGGING
    (
     BGRQ          --1 报告日期
    ,JGBH          --2 机构编号
    ,JGMC          --3 机构名称
    ,JGSZSJXZQ     --4 机构所在省级行政区
    ,ZHWYM         --5 账户唯一码
    ,JYWYM         --6 交易唯一码
    ,KHWYM         --7 客户唯一码
    ,KHMC          --8 客户名称
    ,TJXWQYLB      --9 统计小微企业类别
    ,SFPHXWQY      --10 是否普惠小微企业
    ,SXED          --11 授信额度
    ,FKRQ          --12 放款日期
    ,FKJE          --13 放款金额
    ,TJYE          --14 统计余额（元）
    ,DKDQRQ        --15 贷款到期日期
    ,BGRDKYQTS     --16 报告日贷款逾期天数
    ,TJYQTS        --17 统计逾期天数（天）
    ,TJYQBJJE      --18 统计逾期本金金额（元）
    ,WJFL          --19 五级分类
    ,DBJGBH        --20 担保机构编号
    ,DBJGMC        --21 担保机构名称
    ,DBFS          --22 担保方式
    ,SFRZDBGSBZ    --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ   --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ      --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK    --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE      --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE      --28 报告日尚未履行代偿责任金额（元）
    ,SFSC               --29 是否删除
    ,BZ                 --30 备注
    ,JYXKZBH            --31 经营许可证编号
    ,DBHTSFYX           --32 担保合同是否有效标识  --ADD BY YJY 20240626
    )
  WITH GUARTOR_NAME_TMP1 AS   --多对多，取担保公司名称包含“融资担保”的数据
  (
   SELECT /*+ materialize*/ *
     FROM
        (
          SELECT B.LOAN_CONT_ID      AS LOAN_CONT_ID,  --贷款合同号
                 A.GUARTOR_ID        AS GUARTOR_ID,    --担保机构编号
                 A.GOVER_FIN_GUAR_CORP_GUAR_FLG AS GOVER_FIN_GUAR_CORP_GUAR_FLG,  --政府性融资担保公司保证标志
                 A.GUARTOR_NAME      AS GUARTOR_NAME,   --担保机构名称
                 A.STATUS_CD         AS STATUS_CD,      --担保合同状态代码   --ADD BY YJY 20240626
                 ROW_NUMBER() OVER(PARTITION BY B.LOAN_CONT_ID ORDER BY B.GUAR_CONT_ID DESC, B.GUAR_START_DT DESC ) as RN
              FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A --担保合同表
        INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系表
                ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
               AND A.GUARTOR_NAME LIKE '%融资担保%'
               --AND A.STATUS_CD IN ('100', '101', '102', '109', '112') -- 取担保合同有效的    --MOD BY YJY IN 20240626
          )
  WHERE RN=1
  ),
  -- MOD BY YJY IN 20240807 处理当年失效的担保合同
  GUARTOR_NAME_TMP2 AS    --获取当年放款当年结清且失效的合同
  (
   select /*+ materialize*/ *
      from (
           SELECT T1.REAL_CONT_ID   AS LOAN_CONT_ID    --贷款合同   --MOD BY YJY 20241015 取真实的业务合同号
                 ,T2.GUARTOR_ID    AS GUARTOR_ID      --担保机构编号
                 ,T2.GOVER_FIN_GUAR_CORP_GUAR_FLG   AS GOVER_FIN_GUAR_CORP_GUAR_FLG     --政府性融资担保公司保证标志
                 ,T2.GUARTOR_NAME  AS GUARTOR_NAME    --担保机构名称
                 ,null             AS STATUS_CD      --担保合同状态代码
                 ,ROW_NUMBER() OVER(PARTITION BY t1.BIZ_CONT_ID ORDER BY t1.DATA_DT DESC) as RN
             FROM RRP_MDL.M_GUA_REL_BSN_CONT  T1  --贷款合同与担保合同关系表
       INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T2  --担保合同表
               ON T1.GUA_CONT_ID =T2.GUAR_CONT_ID
              AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              AND T2.GUARTOR_NAME LIKE '%融资担保%'
/*            WHERE T1.DATA_DT >= V_THIS_YEAR_BEGIN
               AND T1.DATA_DT < V_P_DATE*/
               WHERE T1.DATA_DT = V_P_DATE --MOD BY 20251225
               AND SUBSTR(T1.GUA_REL_RLV_DT,0,4)=SUBSTR(V_P_DATE,0,4)    --8担保关系解除日期
            )
    where RN=1
  ),
  GUARTOR_NAME_TMP3 AS  --汇总未失效和本年已失效的担保合同信息
     (
          SELECT /*+ materialize*/ LOAN_CONT_ID
                ,GUARTOR_ID
                ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                ,GUARTOR_NAME
                ,STATUS_CD
            FROM GUARTOR_NAME_TMP1  --未失效的担保合同信息
   UNION ALL
           SELECT /*+ materialize*/ LOAN_CONT_ID
                 ,GUARTOR_ID
                 ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                 ,GUARTOR_NAME
                 ,STATUS_CD
            FROM GUARTOR_NAME_TMP2  T1 --本年已失效的担保合同信息
            WHERE  T1.LOAN_CONT_ID NOT IN  ( SELECT T2.LOAN_CONT_ID  FROM GUARTOR_NAME_TMP1  T2)
     ),
  BNDCJE_TMP1 AS ( --本年代偿金额
                 SELECT /*+ materialize*/
                        T1.DUBIL_ID  AS   DUBIL_ID  --借据编号
                       ,T2.LPBJ      AS   BNDCJE    --担保理赔金额
                       ,MAX(T1.CFM_DT)  AS  CTF_DT  --确认日期
                  FROM RRP_MDL.O_IML_EVT_PH_SOC_CFM_EVT T1 --平安普惠理赔确认事件
            INNER JOIN  (SELECT A.DUBIL_ID
                               ,NVL(A.OVDUE_TOT_PRIC,0)+NVL(A.UNEXP_PRIC,0)  AS LPBJ   --逾期总本金+未到期本金=理赔本金
                               ,A.EVT_ID AS EVT_ID  --事件编号
                               ,A.LP_ID  AS LP_ID  --法人编号  
                          FROM RRP_MDL.O_IML_EVT_PH_SOC_APPL_EVT  A  --平安普惠理赔申请事件
                         WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                           AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                         )T2
                    ON T1.EVT_ID||T1.LP_ID = T2.EVT_ID||T2.LP_ID  --MOD BY YJY IN 20240819 通过事件号+法人编号为主键来关联取唯一一条借据信息
                 WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T1.INPUT_DT >=TO_DATE(V_THIS_YEAR_BEGIN,'YYYYMMDD')
              GROUP BY T1.DUBIL_ID,T2.LPBJ
               )
SELECT  /*+USE_HASH(T1,T2,T3,T4,T5,T6,T7)*/
       V_P_DATE                   AS BGRQ        --1 报告日期
      ,T1.ORG_ID                  AS JGBH        --2 机构号
      ,T3.ORG_NAME                AS JGMC        --3 机构名称
      ,'广东省'                   AS JGSZSJXZQ   --4 机构所在省级行政区
      ,T1.CONT_ID                 AS ZHWYM       --5 账户唯一码
      ,T1.RCPT_ID                 AS JYWYM       --6 交易唯一码
      ,T1.CUST_ID                 AS KHWYM       --7 客户唯一码
      ,T4.CUST_NM                 AS KHMC        --8 客户名称
      ,CASE WHEN T1.OPR_CUST_TYP ='A' THEN '个体工商户'
            WHEN T1.OPR_CUST_TYP ='B' THEN '小微企业主'
            ELSE '其他个人经营客户'
       END                        AS TJXWQYLB    --9 统计小微企业类别
      ,CASE WHEN T1.LOAN_BIZ_TYP  LIKE '0102%'         --个人只取经营性贷款  010201-商业用房贷款 010202-商用车贷款  010203-个人商住两用房贷款  010299-其他个人经营性贷款
             AND T1.STD_PROD_ID NOT IN ('201020100049')  --剔除个人赎楼贷款（经营）
             AND T1.OPR_CUST_TYP IN ('A','B')
             AND T1.CBRC_FLG  ='Y'
             AND T1.OPR_CRDT_TOT_AMT  <= 10000000
            THEN '是'
            ELSE '否'
       END                        AS SFPHXWQY    --10 是否普惠小微企业
      ,T1.SGL_CRDT_AMT            AS SXED        --11 授信额度
      ,T1.LOAN_ACT_DSTR_DT        AS FKRQ        --12 放款日期
      ,T1.LOAN_AMT                AS FKJE        --13 放款金额
      ,T1.LOAN_BAL                AS TJYE        --14 统计余额（元）
      ,T1.LOAN_ORIG_EXP_DT        AS DKDQRQ      --15 贷款到期日期
      ,T1.OVD_DAYS                AS BGRDKYQTS   --16 报告日贷款逾期天数
      ,T1.OVD_DAYS                AS TJYQTS      --17 统计逾期天数（天）
      ,T1.OVD_PRIN_BAL            AS TJYQBJJE    --18 统计逾期本金金额（元）
      ,CASE WHEN T1.LVL5_CL='01' THEN '正常类'
            WHEN T1.LVL5_CL='02' THEN '关注类'
            WHEN T1.LVL5_CL='03' THEN '次级类'
            WHEN T1.LVL5_CL='04' THEN '可疑类'
            WHEN T1.LVL5_CL='05' THEN '损失类'
       END                        AS WJFL        --19 五级分类
      ,T2.GUARTOR_ID              AS DBJGBH      --20 担保机构编号
      ,T2.GUARTOR_NAME            AS DBJGMC      --21 担保机构名称
      ,'保证'                     AS DBFS        --22 担保方式
      ,'是'                       AS SFRZDBGSBZ  --23 是否融资担保公司保证
      ,DECODE(T5.FLG,'Y','是','否')                    AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
      ,CASE WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '1'
            THEN '是'
            WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '0'
            THEN '否'
            ELSE '其他'
       END                        AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
      ,CASE WHEN T1.FKSSNBZ = 'Y' THEN '是'
            WHEN T1.FKSSNBZ = 'N' THEN '否'
       END                        AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
      ,CASE WHEN T7.DUBIL_ID IS NOT NULL
            THEN T7.BNDCJE
            ELSE 0
       END                        AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
      ,NULL                       AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
      ,'否'                       AS SFSC             --29 是否删除
      ,''                         AS BZ               --30 备注
      ,''                         AS JYXKZBH          --31 经营许可证编号
    ,CASE WHEN T2.STATUS_CD IN ('100', '101', '102', '109', '112')
          THEN '是'
          ELSE '否'
     END                        AS DBHTSFYX           --32 担保合同是否有效标识      --ADD BY YJY 20240626
     FROM RRP_MDL.S_LOAN T1  --贷款业务整合表
INNER JOIN RRP_MDL.M_LOAN_CONT_INFO T6 --贷款合同信息
        ON T1.CONT_ID = T6.CONT_ID
       AND T6.DATA_DT = V_P_DATE
       AND (T6.MAIN_GUA_MODE = '3' OR T6.SUB_GUA_MODE = 'C')
INNER JOIN GUARTOR_NAME_TMP3 T2  --担保临时表
        ON T2.LOAN_CONT_ID = T1.CONT_ID
LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T3 --内部机构信息表
       ON T3.ORG_ID = T1.ORG_ID
      AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4     --个人客户信息
       ON T1.CUST_ID = T4.CUST_ID
      AND T4.DATA_DT = V_P_DATE
LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K, FLG FROM RRP_MDL.M_ZFXRZDBJGMD) T5 -- GD04_13政府性融资担保机构名单
       ON T5.GUARTOR_ID_K = T2.GUARTOR_ID
LEFT JOIN BNDCJE_TMP1 T7  --本年代偿金额临时表
       ON T1.RCPT_ID = T7.DUBIL_ID
    WHERE T1.DATA_DT = V_P_DATE
      AND T1.DATA_SRC IN ('零售贷款')
      AND T1.STD_PROD_ID  IN ('202010200005', '202020200002')
      AND T1.LOAN_ACT_DSTR_DT >= '20220701'
      AND ( T1.LOAN_ACT_DSTR_DT >= V_THIS_YEAR_BEGIN
           OR T1.LOAN_BAL <>0
           OR T7.BNDCJE <> 0 )--代偿金额
   ;

   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 2;
  V_STEP_DESC := '零售-剔除平安普惠（消费）平安普惠（经营）';
  V_STARTTIME := SYSDATE;
INSERT /*+APPEND*/ INTO A_PHB_G5305 NOLOGGING
    (
     BGRQ          --1 报告日期
    ,JGBH          --2 机构编号
    ,JGMC          --3 机构名称
    ,JGSZSJXZQ     --4 机构所在省级行政区
    ,ZHWYM         --5 账户唯一码
    ,JYWYM         --6 交易唯一码
    ,KHWYM         --7 客户唯一码
    ,KHMC          --8 客户名称
    ,TJXWQYLB      --9 统计小微企业类别
    ,SFPHXWQY      --10 是否普惠小微企业
    ,SXED          --11 授信额度
    ,FKRQ          --12 放款日期
    ,FKJE          --13 放款金额
    ,TJYE          --14 统计余额（元）
    ,DKDQRQ        --15 贷款到期日期
    ,BGRDKYQTS     --16 报告日贷款逾期天数
    ,TJYQTS        --17 统计逾期天数（天）
    ,TJYQBJJE      --18 统计逾期本金金额（元）
    ,WJFL          --19 五级分类
    ,DBJGBH        --20 担保机构编号
    ,DBJGMC        --21 担保机构名称
    ,DBFS          --22 担保方式
    ,SFRZDBGSBZ    --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ   --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ      --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK    --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE      --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE      --28 报告日尚未履行代偿责任金额（元）
    ,SFSC               --29 是否删除
    ,BZ                 --30 备注
    ,JYXKZBH            --31 经营许可证编号
   ,DBHTSFYX           --32 担保合同是否有效标识      --ADD BY YJY 20240626
    )
  WITH GUARTOR_NAME_TMP1 AS   --多对多，取担保公司名称包含“融资担保”的数据
  (
   SELECT /*+ materialize*/ *
     FROM
        (
          SELECT B.LOAN_CONT_ID      AS LOAN_CONT_ID,  --贷款合同号
                 A.GUARTOR_ID        AS GUARTOR_ID,    --担保机构编号
                 A.GOVER_FIN_GUAR_CORP_GUAR_FLG AS GOVER_FIN_GUAR_CORP_GUAR_FLG,  --政府性融资担保公司保证标志
                 A.GUARTOR_NAME      AS GUARTOR_NAME,   --担保机构名称
                 A.STATUS_CD         AS STATUS_CD,      --担保合同状态代码     --ADD BY YJY 20240626
                 ROW_NUMBER() OVER(PARTITION BY B.LOAN_CONT_ID ORDER BY B.GUAR_CONT_ID DESC, B.GUAR_START_DT DESC ) as RN
              FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A --担保合同表
        INNER JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系表
                ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
               AND (A.GUARTOR_NAME LIKE '%融资担保%' or A.GUARTOR_NAME = '深圳担保集团有限公司')
               --AND A.STATUS_CD IN ('100', '101', '102', '109', '112') -- 取担保合同有效的      --MOD BY YJY IN 20240626
          )
  WHERE RN=1
  ),
  -- MOD BY YJY IN 20240807 处理当年失效的担保合同
  GUARTOR_NAME_TMP2 AS    --获取本年结清失效的担保数据
  (
   select /*+ materialize*/ *
      from (
           SELECT T1.REAL_CONT_ID   AS LOAN_CONT_ID    --贷款合同   --MOD BY YJY 20241015 取真实的业务合同号
                 ,T2.GUARTOR_ID    AS GUARTOR_ID      --担保机构编号
                 ,T2.GOVER_FIN_GUAR_CORP_GUAR_FLG   AS GOVER_FIN_GUAR_CORP_GUAR_FLG    -- 政府性融资担保公司保证标志
                 ,T2.GUARTOR_NAME  AS GUARTOR_NAME    --担保机构名称
                 ,null             AS STATUS_CD       --担保合同状态代码
                 ,ROW_NUMBER() OVER(PARTITION BY t1.REAL_CONT_ID/*BIZ_CONT_ID*/ ORDER BY t1.DATA_DT DESC) as RN
             FROM RRP_MDL.M_GUA_REL_BSN_CONT  T1
       INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT T2
               ON T1.GUA_CONT_ID =T2.GUAR_CONT_ID
              AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              AND (T2.GUARTOR_NAME LIKE '%融资担保%' or T2.GUARTOR_NAME = '深圳担保集团有限公司')
/*            WHERE T1.DATA_DT >= V_THIS_YEAR_BEGIN
              AND T1.DATA_DT < V_P_DATE*/
              WHERE T1.DATA_DT = V_P_DATE --MOD BY 20251225
              AND SUBSTR(T1.GUA_REL_RLV_DT,0,4)=SUBSTR(V_P_DATE,0,4)    --担保关系解除日期
            )
    where RN=1
  ),
  GUARTOR_NAME_TMP3 AS   --合并未失效和已失效的担保合同
     (
          SELECT /*+ materialize*/ LOAN_CONT_ID
                ,GUARTOR_ID
                ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                ,GUARTOR_NAME
                ,STATUS_CD
            FROM GUARTOR_NAME_TMP1
   UNION ALL
           SELECT /*+ materialize*/ LOAN_CONT_ID
                 ,GUARTOR_ID
                 ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                 ,GUARTOR_NAME
                 ,STATUS_CD
            FROM GUARTOR_NAME_TMP2 T1 --本年已失效的担保合同信息
            WHERE  T1.LOAN_CONT_ID NOT IN  ( SELECT T2.LOAN_CONT_ID  FROM GUARTOR_NAME_TMP1  T2)
     ),
  BNDCJE_TMP1 AS ( --本年代偿金额
                 SELECT /*+ materialize*/
                        T1.DUBIL_ID  AS   DUBIL_ID  --借据编号
                       ,T2.LPBJ      AS   BNDCJE    --担保理赔金额
                       ,MAX(T1.CFM_DT)  AS  CTF_DT  --确认日期
                  FROM RRP_MDL.O_IML_EVT_PH_SOC_CFM_EVT T1 --平安普惠理赔确认事件
            INNER JOIN  (SELECT A.DUBIL_ID
                               ,NVL(A.OVDUE_TOT_PRIC,0)+NVL(A.UNEXP_PRIC,0)  AS LPBJ   --逾期总本金+未到期本金=理赔本金
                               ,A.EVT_ID AS EVT_ID  --事件编号
                               ,A.LP_ID  AS LP_ID  --法人编号  
                          FROM RRP_MDL.O_IML_EVT_PH_SOC_APPL_EVT  A  --平安普惠理赔申请事件
                         WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                           AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                         )T2
                    ON T1.EVT_ID||T1.LP_ID = T2.EVT_ID||T2.LP_ID  --MOD BY YJY IN 20240819 通过事件号+法人编号为主键来关联取唯一一条借据信息
                 WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T1.INPUT_DT >=TO_DATE(V_THIS_YEAR_BEGIN,'YYYYMMDD')
              GROUP BY T1.DUBIL_ID,T2.LPBJ
               )
SELECT  /*+USE_HASH(T1,T2,T3,T4,T5,T6,T7,TT)*/
       V_P_DATE                   AS BGRQ        --1 报告日期
      ,T1.ORG_ID                  AS JGBH        --2 机构号
      ,T3.ORG_NAME                AS JGMC        --3 机构名称
      ,'广东省'                   AS JGSZSJXZQ   --4 机构所在省级行政区
      ,T1.CONT_ID                 AS ZHWYM       --5 账户唯一码
      ,T1.RCPT_ID                 AS JYWYM       --6 交易唯一码
      ,T1.CUST_ID                 AS KHWYM       --7 客户唯一码
      ,T4.CUST_NM                 AS KHMC        --8 客户名称
      ,CASE WHEN T1.OPR_CUST_TYP ='A' THEN '个体工商户'
            WHEN T1.OPR_CUST_TYP ='B' THEN '小微企业主'
            ELSE '其他个人经营客户'
       END                        AS TJXWQYLB    --9 统计小微企业类别
      ,CASE WHEN T1.LOAN_BIZ_TYP  LIKE '0102%'         --个人只取经营性贷款  010201-商业用房贷款 010202-商用车贷款  010203-个人商住两用房贷款  010299-其他个人经营性贷款
             AND T1.STD_PROD_ID NOT IN ('201020100049')  --剔除个人赎楼贷款（经营）
             AND T1.OPR_CUST_TYP IN ('A','B')
             AND T1.CBRC_FLG  ='Y'
             AND T1.OPR_CRDT_TOT_AMT  <= 10000000
             THEN '是'
             ELSE '否'
       END                        AS SFPHXWQY    --10 是否普惠小微企业
      ,T1.SGL_CRDT_AMT            AS SXED        --11 授信额度
      ,T1.LOAN_ACT_DSTR_DT        AS FKRQ        --12 放款日期
      ,T1.LOAN_AMT                AS FKJE        --13 放款金额
      ,T1.LOAN_BAL                AS TJYE        --14 统计余额（元）
      ,T1.LOAN_ORIG_EXP_DT        AS DKDQRQ      --15 贷款到期日期
      ,T1.OVD_DAYS                AS BGRDKYQTS   --16 报告日贷款逾期天数
      ,T1.OVD_DAYS                AS TJYQTS      --17 统计逾期天数（天）
      ,T1.OVD_PRIN_BAL            AS TJYQBJJE    --18 统计逾期本金金额（元）
      ,CASE WHEN T1.LVL5_CL='01' THEN '正常类'
            WHEN T1.LVL5_CL='02' THEN '关注类'
            WHEN T1.LVL5_CL='03' THEN '次级类'
            WHEN T1.LVL5_CL='04' THEN '可疑类'
            WHEN T1.LVL5_CL='05' THEN '损失类'
       END                        AS WJFL        --19 五级分类
      ,NVL(T2.GUARTOR_ID,TT.GUARTOR_ID)
                                  AS DBJGBH      --20 担保机构编号
      ,CASE WHEN T1.STD_PROD_ID = '202020200007'
            THEN '广东中盈盛达融资担保投资股份有限公司'
            ELSE NVL(T2.GUARTOR_NAME,TT.GUARTOR_NAME)
            END                   AS DBJGMC      --21 担保机构名称
      ,'保证'                     AS DBFS        --22 担保方式
      ,'是'                       AS SFRZDBGSBZ  --23 是否融资担保公司保证
      ,DECODE(T5.FLG,'Y','是','否')                    AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
      ,CASE WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '1'
            THEN '是'
            WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '0'
            THEN '否'
            ELSE '其他'
       END                        AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
      ,CASE WHEN T1.FKSSNBZ = 'Y' THEN '是'
            WHEN T1.FKSSNBZ = 'N' THEN '否'
       END                        AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
      ,CASE WHEN T7.DUBIL_ID IS NOT NULL
            THEN T7.BNDCJE
            ELSE 0
       END                        AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
      ,NULL                       AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
      ,'否'                       AS SFSC             --29 是否删除
      ,''                         AS BZ               --30 备注
      ,''                         AS JYXKZBH          --31 经营许可证编号
    ,CASE WHEN T2.STATUS_CD IN ('100', '101', '102', '109', '112')
          THEN '是'
        WHEN TT.STATUS_CD IN ('100', '101', '102', '109', '112')
          THEN '是'
      ELSE '否'
     END                       AS DBHTSFYX           --32 担保合同是否有效标识      --ADD BY YJY 20240626
     FROM RRP_MDL.S_LOAN T1  --贷款业务整合表
INNER JOIN RRP_MDL.M_LOAN_CONT_INFO T6 --贷款合同信息
        ON T1.CONT_ID = T6.CONT_ID
       AND T6.DATA_DT = V_P_DATE
LEFT JOIN GUARTOR_NAME_TMP3 T2  --担保临时表
       ON T2.LOAN_CONT_ID = T1.CONT_ID
LEFT JOIN GUARTOR_NAME_TMP3 TT  --担保临时表  --取额度合同号
       ON TT.LOAN_CONT_ID = T1.LMT_CONT_ID
      AND TT.LOAN_CONT_ID <> T1.CONT_ID
LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T3 --内部机构信息表
       ON T3.ORG_ID = T1.ORG_ID
      AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4     --个人客户信息
       ON T1.CUST_ID = T4.CUST_ID
      AND T4.DATA_DT = V_P_DATE
LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K, FLG FROM RRP_MDL.M_ZFXRZDBJGMD) T5 -- GD04_13政府性融资担保机构名单
       ON T5.GUARTOR_ID_K = NVL(T2.GUARTOR_ID,TT.GUARTOR_ID)
LEFT JOIN BNDCJE_TMP1 T7  --本年代偿金额临时表
       ON T1.RCPT_ID = T7.DUBIL_ID
    WHERE T1.DATA_DT = V_P_DATE
      AND T1.DATA_SRC IN ('零售贷款')
      AND T1.RCPT_ID NOT IN ('R202111010055118353','R202112170083231921','R202111170064419596','R202111100058868885','R202111190065819809')--剔除珠海分行5笔阶段性担保借据
      AND ( ( (T6.MAIN_GUA_MODE = '3' OR T6.SUB_GUA_MODE = 'C')
             AND T1.STD_PROD_ID NOT IN ('202010200005', '202020200002')
             AND (T2.LOAN_CONT_ID IS NOT NULL OR TT.LOAN_CONT_ID IS NOT NULL)) --剔除平安普惠（消费）平安普惠（经营）
          OR T1.STD_PROD_ID ='202020200007')--202020200007-新心金融小微贷
    AND ( T1.LOAN_ACT_DSTR_DT >=  V_THIS_YEAR_BEGIN
          OR T1.LOAN_BAL <> 0
          OR T7.BNDCJE <> 0 )--代偿金额
    ;

   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 3 ;
  V_STEP_DESC := '网商贷';
  V_STARTTIME := SYSDATE;
INSERT /*+APPEND*/ INTO A_PHB_G5305 NOLOGGING
    (
     BGRQ          --1 报告日期
    ,JGBH          --2 机构编号
    ,JGMC          --3 机构名称
    ,JGSZSJXZQ     --4 机构所在省级行政区
    ,ZHWYM         --5 账户唯一码
    ,JYWYM         --6 交易唯一码
    ,KHWYM         --7 客户唯一码
    ,KHMC          --8 客户名称
    ,TJXWQYLB      --9 统计小微企业类别
    ,SFPHXWQY      --10 是否普惠小微企业
    ,SXED          --11 授信额度
    ,FKRQ          --12 放款日期
    ,FKJE          --13 放款金额
    ,TJYE          --14 统计余额（元）
    ,DKDQRQ        --15 贷款到期日期
    ,BGRDKYQTS     --16 报告日贷款逾期天数
    ,TJYQTS        --17 统计逾期天数（天）
    ,TJYQBJJE      --18 统计逾期本金金额（元）
    ,WJFL          --19 五级分类
    ,DBJGBH        --20 担保机构编号
    ,DBJGMC        --21 担保机构名称
    ,DBFS          --22 担保方式
    ,SFRZDBGSBZ    --23 是否融资担保公司保证
    ,ZFXRZDBJGBJ   --24 政府性融资担保机构标记
    ,SFZFXRZDBGSBZ      --25 是否政府性融资担保公司保证
    ,SFNHJXXNYJYZTDK    --26 是否农户及新型农业经营主体贷款
    ,BNDLJSJHDDCJE      --27 本年度累计实际获得代偿金额（元）
    ,BGRSWLXDCZRJE      --28 报告日尚未履行代偿责任金额（元）
    ,SFSC               --29 是否删除
    ,BZ                 --30 备注
    ,JYXKZBH            --31 经营许可证编号
    ,DBHTSFYX           --32 担保合同是否有效标识       --ADD BY YJY 20240626
    )
  WITH GUARTOR_NAME_TMP1 AS   --多对多，取担保公司名称包含“融资担保”的数据
     (
            SELECT /*+ materialize*/
                   B.LOAN_CONT_ID,
                   A.GUARTOR_CUST_ID AS GUARTOR_CUST_ID ,
                   A.GOVER_FIN_GUAR_CORP_GUAR_FLG AS GOVER_FIN_GUAR_CORP_GUAR_FLG,  --政府性融资担保公司保证标志
                   A.STATUS_CD      AS STATUS_CD,   --担保合同状态代码     --ADD BY YJY 20240626
                   MAX(A.GUARTOR_NAME) AS GUARTOR_NAME   --担保机构名称
              FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO A --联合网贷担保合同信息
        INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA B --联合网贷贷款与担保合同关系
                ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
               AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
             WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
              -- AND A.STATUS_CD NOT IN ('4') -- 取担保合同有效的     --MOD BY YJY IN 20240626
               AND A.GUARTOR_NAME LIKE '%融资担保%'
          GROUP BY B.LOAN_CONT_ID,A.GUARTOR_CUST_ID,A.GOVER_FIN_GUAR_CORP_GUAR_FLG,A.STATUS_CD
  ),
  -- MOD BY YJY IN 20240807 处理当年失效的担保合同
  GUARTOR_NAME_TMP2 AS
    (       SELECT /*+ materialize*/ *
             FROM (SELECT T1.REAL_CONT_ID        AS LOAN_CONT_ID    --MOD BY YJY 20241015 取真实的业务合同号
                         ,T2.GUARTOR_CUST_ID    AS GUARTOR_CUST_ID
                         ,T2.GOVER_FIN_GUAR_CORP_GUAR_FLG   AS GOVER_FIN_GUAR_CORP_GUAR_FLG
                         ,T2.GUARTOR_NAME       AS GUARTOR_NAME
                         ,T2.STATUS_CD          AS STATUS_CD
                         ,ROW_NUMBER() OVER(PARTITION BY T1.BIZ_CONT_ID ORDER BY T1.DATA_DT DESC) AS RN
                     FROM RRP_MDL.M_GUA_REL_BSN_CONT  T1
                    INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO T2
                            ON T1.GUA_CONT_ID =T2.GUAR_CONT_ID
                           AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                           AND T2.GUARTOR_NAME LIKE '%融资担保%'
/*                    WHERE T1.DATA_DT >= V_THIS_YEAR_BEGIN
                      AND T1.DATA_DT < V_P_DATE*/
                      WHERE T1.DATA_DT = V_P_DATE --MOD BY 20251225
                      AND SUBSTR(T1.GUA_REL_RLV_DT,0,4)=SUBSTR(V_P_DATE,0,4)
                      AND T1.DATA_SRC ='联合网贷'
                 )
        WHERE RN=1
    ),
 GUARTOR_NAME_TMP3 AS
     (     SELECT /*+ materialize*/
                 LOAN_CONT_ID
                 ,GUARTOR_CUST_ID
                 ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                 ,GUARTOR_NAME
                 ,STATUS_CD
             FROM GUARTOR_NAME_TMP1
            UNION ALL
           SELECT /*+ materialize*/
                  LOAN_CONT_ID
                 ,GUARTOR_CUST_ID
                 ,GOVER_FIN_GUAR_CORP_GUAR_FLG
                 ,GUARTOR_NAME
                 ,STATUS_CD
             FROM GUARTOR_NAME_TMP2 T1 --本年已失效的担保合同信息
            WHERE  T1.LOAN_CONT_ID NOT IN  ( SELECT T2.LOAN_CONT_ID  FROM GUARTOR_NAME_TMP1  T2)
     ),
 UNITE_WL_REPAY_DTL_TMP  AS
       (SELECT /*+ MATERIALIZE*/
              DUBIL_ID
             ,CURRT_REPAY_AMT
         FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL
        WHERE REPAY_TYPE_CD ='05'
          AND REPAY_DT < TO_DATE(V_P_DATE,'YYYYMMDD')
          AND REPAY_DT >= TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')
      )
SELECT /*+USE_HASH(T1,T2,T3,T4,T5,T6,T7,T8,T9)*/
       V_P_DATE                   AS BGRQ        --1 报告日期
      ,T1.ORG_ID                  AS JGBH        --2 机构号
      ,T3.ORG_NAME                AS JGMC        --3 机构名称
      ,'广东省'                   AS JGSZSJXZQ   --4 机构所在省级行政区
      ,T1.CONT_ID                 AS ZHWYM       --5 账户唯一码
      ,T1.RCPT_ID                 AS JYWYM       --6 交易唯一码
      ,T1.CUST_ID                 AS KHWYM       --7 客户唯一码
      ,T4.CUST_NM                 AS KHMC        --8 客户名称
      ,CASE WHEN T1.OPR_CUST_TYP ='A' THEN '个体工商户'
            WHEN T1.OPR_CUST_TYP ='B' THEN '小微企业主'
            ELSE '其他个人经营客户'
       END                        AS TJXWQYLB    --9 统计小微企业类别
      ,CASE WHEN T1.LOAN_BIZ_TYP  LIKE '0102%'         --个人只取经营性贷款  010201-商业用房贷款 010202-商用车贷款  010203-个人商住两用房贷款  010299-其他个人经营性贷款
             AND T1.STD_PROD_ID NOT IN ('201020100049')  --剔除个人赎楼贷款（经营）
             AND T1.OPR_CUST_TYP IN ('A','B')
             AND T1.CBRC_FLG  ='Y'
             AND T1.OPR_CRDT_TOT_AMT  <= 10000000
             THEN '是'
             ELSE '否'
       END                        AS SFPHXWQY    --10 是否普惠小微企业
      ,T1.SGL_CRDT_AMT            AS SXED        --11 授信额度
      ,T1.LOAN_ACT_DSTR_DT        AS FKRQ        --12 放款日期
      ,T1.LOAN_AMT                AS FKJE        --13 放款金额
      ,T1.LOAN_BAL                AS TJYE        --14 统计余额（元）
      ,T1.LOAN_ORIG_EXP_DT        AS DKDQRQ      --15 贷款到期日期
      ,T1.OVD_DAYS                AS BGRDKYQTS   --16 报告日贷款逾期天数
      ,T1.OVD_DAYS                AS TJYQTS      --17 统计逾期天数（天）
      ,T1.OVD_PRIN_BAL            AS TJYQBJJE    --18 统计逾期本金金额（元）
      ,CASE WHEN T1.LVL5_CL='01' THEN '正常类'
            WHEN T1.LVL5_CL='02' THEN '关注类'
            WHEN T1.LVL5_CL='03' THEN '次级类'
            WHEN T1.LVL5_CL='04' THEN '可疑类'
            WHEN T1.LVL5_CL='05' THEN '损失类'
       END                        AS WJFL        --19 五级分类
      ,T2.GUARTOR_CUST_ID         AS DBJGBH      --20 担保机构编号
      ,CASE WHEN T1.STD_PROD_ID = '202020200007'
            THEN '广东中盈盛达融资担保投资股份有限公司'
            ELSE T2.GUARTOR_NAME
            END                   AS DBJGMC      --21 担保机构名称
      ,T1.TJDBFS                  AS DBFS        --22 担保方式
      ,'是'                       AS SFRZDBGSBZ  --23 是否融资担保公司保证
      ,DECODE(T5.FLG,'Y','是','否')                    AS ZFXRZDBJGBJ      --24 政府性融资担保机构标记
      ,CASE WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '1'
            THEN '是'
            WHEN T2.GOVER_FIN_GUAR_CORP_GUAR_FLG = '0'
            THEN '否'
            ELSE '其他'
       END                        AS SFZFXRZDBGSBZ    --25 是否政府性融资担保公司保证
      ,CASE WHEN T1.FKSSNBZ = 'Y' THEN '是'
            WHEN T1.FKSSNBZ = 'N' THEN '否'
       END                        AS SFNHJXXNYJYZTDK  --26 是否农户及新型农业经营主体贷款
      ,CASE WHEN T6.DUBIL_ID IS NOT NULL
            THEN T6.CURRT_REPAY_AMT
            ELSE 0
       END                        AS BNDLJSJHDDCJE    --27 本年度累计实际获得代偿金额（元）
      ,NULL                       AS BGRSWLXDCZRJE    --28 报告日尚未履行代偿责任金额（元）
      ,'否'                       AS SFSC             --29 是否删除
      ,''                         AS BZ               --30 备注
      ,''                         AS JYXKZBH          --31 经营许可证编号
    ,CASE WHEN T2.STATUS_CD <> '4'
          THEN '是'
          ELSE '否'
     END                        AS DBHTSFYX           --32 担保合同是否有效标识   --ADD BY YJY 20240626
     FROM RRP_MDL.S_LOAN T1  --贷款业务整合表
INNER JOIN RRP_MDL.M_LOAN_CONT_INFO T9 --贷款合同信息
        ON T1.CONT_ID = T9.CONT_ID
       AND T9.DATA_DT = V_P_DATE
       AND (T9.MAIN_GUA_MODE = '3' OR T9.SUB_GUA_MODE = 'C')
LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T7 --联合网贷借据信息   当前数据
       ON T1.RCPT_ID = T7.DUBIL_ID
      AND T7.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T8 --联合网贷借据信息   上年末已结清的借据
       ON T1.RCPT_ID = T8.DUBIL_ID
      AND T8.ETL_DT = TO_DATE(V_LAST_YEAR_END,'YYYYMMDD')
LEFT JOIN GUARTOR_NAME_TMP3 T2  --担保临时表
       ON T2.LOAN_CONT_ID = NVL(T7.CONT_ID,T8.CONT_ID)
LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T3 --内部机构信息表
       ON T3.ORG_ID = T1.ORG_ID
      AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4     --个人客户信息
       ON T1.CUST_ID = T4.CUST_ID
      AND T4.DATA_DT = V_P_DATE
LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K,FLG FROM RRP_MDL.M_ZFXRZDBJGMD) T5 -- GD04_13政府性融资担保机构名单
       ON T5.GUARTOR_ID_K = T2.GUARTOR_CUST_ID
LEFT JOIN UNITE_WL_REPAY_DTL_TMP  T6 --联合网贷还款明细  --ADD BY YJY IN 20240410 加工代偿金额
       ON T1.RCPT_ID = T6.DUBIL_ID
    WHERE T1.DATA_DT = V_P_DATE
      AND T1.DATA_SRC IN ('联合网贷')
      AND ( T1.LOAN_ACT_DSTR_DT >= V_LAST_YEAR_END   --MOD BY YJY 20241015 联合网贷包含上年年末的放款
           OR T1.LOAN_BAL <>0
           OR T6.CURRT_REPAY_AMT <> 0 )
      AND NVL(T7.CONT_ID ,T8.CONT_ID) IS NOT NULL
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
      FROM RRP_MDL.A_PHB_G5305 T
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

END ETL_A_PHB_G5305;
/

