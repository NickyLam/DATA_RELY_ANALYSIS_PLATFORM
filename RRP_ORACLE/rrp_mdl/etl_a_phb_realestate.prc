CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_REALESTATE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_REALESTATE
  *  功能描述：以借据为粒度，整合房地产贷款所需的借据属性信息和客户属性信息。
  *  创建日期：20221110
  *  开发人员：徐菲
  *  来源表：S_LOAN_RL_EST  --房地产贷款整合表
  *  目标表：A_PHB_REALESTATE --房地产贷款基表_零售
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221110   xufei      首次创建
  *   2    20231024   tzj        修改押品最新估值取数口径，从房地产贷款整合表 取押品最新估值 字段
      3    20231116   lwb       修改取应还本金，利息在本月的数据
      4    20231225   HYF       调整家庭月收入逻辑，优先取月收入，月收入取不到再取年收入/12
      5    20240129   LWB        调整其他房地产贷款及其他以房地产为抵押贷款的出数逻辑
      6    20240208  LWB      同步房地产小基表，修改应还本金及利息的口径
      7    20240516  LWB      修改房地产贷款类别字段FDCDKLB
      8    20240523  lwb      修改贷款利率类别的取数方式
      9    20240627  LWB      增加房地产贷款类别：其他以房地产为抵押
      10   20250605  HYF      放开余额不为0过滤
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME   VARCHAR2(100) ; --表名
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_REALESTATE'; -- 程序名称
  V_PART_NAME  VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_REALESTATE'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期

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

  INSERT /*+APPEND PARALLEL(4)*/ INTO A_PHB_REALESTATE NOLOGGING
  (
       BGRQ                 --1 报告日期
      ,JYWYM                --2 交易唯一码
      ,ZHWYM                --3 账户唯一码
      ,JGBH                 --4 机构编号
      ,JGMC                 --5 机构名称
      ,KHWYM                --6 客户唯一码
      ,KHMC                 --7 客户名称
      ,FDCDKLB              --8 房地产贷款类别
      ,FDCDKLX              --9 房地产贷款类型
      ,SFBZXZLZF            --10 是否保障性租赁住房
      ,ZFZLDKLB             --11 住房租赁贷款类别
      ,DKJZB                --12 贷款价值比
      ,DKJZBQJ              --13 贷款价值比区间
      ,WJFL                 --14 五级分类
      ,TJYE                 --15 统计余额（元）
      ,ZFTS                 --16 住房套数
      ,SFXJZF               --17 是否新建住房
      ,DKLLJJD              --18 贷款利率加减点
      ,DKLLLB               --19 贷款利率类别
      ,JZMJ                 --20 建筑面积（平方米）
      ,JZMJQJ               --21 建筑面积区间
      ,JTYJSR               --22 家庭月均收入（元）
      ,YWYGLF               --23 月物业管理费（元）
      ,CZSRB                --24 偿债收入比（%）
      ,CZSRBQJ              --25 偿债收入比区间
      ,DKYWPZ               --26 贷款业务品种
      ,SFYFCDY              --27 是否有房产抵押
      ,ZFSJ                 --28 住房售价（元）
      ,ZFSFJE               --29 住房首付金额（元）
      ,YPZXGZ               --30 押品最新估值（元）
      ,SFZQ                 --31 是否展期
      ,TJYQTS               --32 统计逾期天数
      ,YQTSQJ               --33 逾期天数区间
      ,TJYQBJJE             --34 统计逾期本金金额（元）
      ,FKR                  --35 放款日
      ,FKJEY                --36 放款金额元
      ,DKYT                 --37 贷款用途
      ,ZHUDBFS              --38 主担保方式
      ,ZIDBFS               --39 子担保方式
      ,BCDKDYHKE            --40 本次贷款的月还款额（元）
      ,DYXFFJE              --41 当月新发放金额（元）
      ,YCYE                 --42 月初余额（元）
      ,DYHSJE               --43 当月回收金额（元）
  )
  WITH A_PHB_REALESTATE_TMP01 AS (
             SELECT DISTINCT 
                    B.RCPT_ID
                    ,'其他房地产' AS DATA_SRC
               FROM RRP_MDL.S_LOAN B
               LEFT JOIN RRP_MDL.S_LOAN_RL_EST A --房地产贷款整合表
                 ON A.RCPT_ID = B.RCPT_ID
                AND A.DATA_DT = B.DATA_DT
              WHERE B.DATA_DT = V_P_DATE --数据日期
                AND B.CUR = 'CNY' --币种
               /*AND (A.RL_EST_LOAN_TYP = '501' OR
                   (B.std_prod_id = '201010300006' OR
                   (substr(B.LOAN_BIZ_TYP, 1, 4) in ('0101', '0103', '0104') AND B.LOAN_USEAGE = '支付个人租房费用'))
                    OR(B.LOAN_BIZ_TYP LIKE '0102' AND B.LOAN_BIZ_TYP <> '010201' AND SUBSTR(B.LOAN_DIR_IDY,1,1)='K'))
               AND B.CUST_LRG_CL = '01' --零售(s67表中的“1.5.1 其中：经营性物业贷款”、“ 1.4住房租赁消费贷款”加上个人经营性贷款中投向行业为房地产业的借据（不含购买商业用房），按借据号去重)
               --AND SUBSTR(B.LOAN_ACT_DSTR_DT, 1, 6) = SUBSTR(V_P_DATE, 1, 6) --放款取本月*/
               AND (B.std_prod_id in ('201020100047','201020100048')--个人物业经营租金贷,个人经营性物业抵押贷款
                    OR (B.LOAN_BIZ_TYP='010299' AND B.LOAN_DIR_IDY LIKE 'K%' 
                        AND B.std_prod_id not in('201030100001','201030100002','201030100003','201030200001'
                                                 ,'201030200002','201030200003','201010300006'))--个人一手商用房按揭贷款,个人二手商用房按揭贷款、法拍贷、个人一手住房按揭贷款、个人二手住房按揭贷款、201030200003  法拍贷和兴居贷
                    )
               AND A.RCPT_ID IS NULL
     UNION ALL
            SELECT DISTINCT 
                   A.RCPT_ID
                   ,'其他以房地产为抵押' AS DATA_SRC
              FROM RRP_MDL.S_LOAN A
              LEFT JOIN RRP_MDL.S_LOAN_RL_EST B --房地产贷款整合表
                ON A.RCPT_ID = B.RCPT_ID
               AND B.DATA_DT =V_P_DATE
             INNER JOIN (SELECT A.CREDNO
                                ,SUM(A.DISTVALUE) AS BAL
                           FROM RRP_MDL.S_G13_BASE A
                           LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION B
                             ON A.GUARTYPE = B.GUARTYPE
                            AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                          WHERE A.DATA_DT = V_P_DATE
                            AND B.FIELDIDX IN ('30', '31', '32', '33', '34', '35')
                          GROUP BY A.CREDNO ) C
                ON A.RCPT_ID = C.CREDNO
             WHERE A.DATA_DT = V_P_DATE --数据日期
               AND B.RCPT_ID IS NULL
               AND A.LOAN_BAL <> 0
               AND A.CUST_LRG_CL = '01'
               AND (A.LOAN_BIZ_TYP NOT LIKE '0102%' OR(A.LOAN_BIZ_TYP LIKE '0102%' AND A.LOAN_DIR_IDY NOT LIKE 'K%'))
    )
       SELECT /*+PARALLEL(4)*/
         F.DATA_DT                                     AS BGRQ  --1 报告日期
        ,F.RCPT_ID                                     AS JYWYM --2 交易唯一码
        ,F.CONT_ID                                     AS ZHWYM --3 账户唯一码
        ,F.ORG_ID                                      AS JGBH  --4 机构编号
        ,B.ORG_NM                                      AS JGMC  --5 机构名称
        ,F.CUST_ID                                     AS KHWYM --6 客户唯一码
        ,D.CUST_NM                                     AS KHMC  --7 客户名称
        ,CASE WHEN SUBSTR(A.RL_EST_LOAN_TYP, 1, 3) IN ('101', '102', '103')
              THEN '地产开发贷款'
              WHEN SUBSTR(A.RL_EST_LOAN_TYP, 1, 3) IN ('111', '112', '113')
              THEN '住房开发贷款'
              WHEN A.RL_EST_LOAN_TYP = '114'
              THEN '商业用房开发贷款'
              WHEN A.RL_EST_LOAN_TYP IN ('115','119')
              THEN '其他房产开发贷款'
              WHEN A.RL_EST_LOAN_TYP IN ('2011','2021','2031')
              THEN '个人购买商业房产贷款'
              WHEN SUBSTR(A.RL_EST_LOAN_TYP, 1, 4) IN ('2032', '2033', '2034', '2035','2036')
              THEN '个人住房贷款'
              WHEN K.DATA_SRC='其他以房地产为抵押' THEN '其他以房地产为抵押贷款'
              WHEN F.LOAN_DIR_IDY LIKE 'K%'  --AND (F.LOAN_BIZ_TYP NOT LIKE '01%' OR F.LOAN_BIZ_TYP LIKE '0102%')
                OR A.RL_EST_LOAN_TYP IN ('501','502')
              THEN '其他房地产贷款'
              ELSE '不适用'
         END                                           AS FDCDKLB --8 房地产贷款类别
        ,DECODE(A.RL_EST_LOAN_TYP,
                  '502','房地产并购贷款',
                  '501','经营性物业贷款',
                  '114','商业用房开发贷款',
                  '2036','个人住房再交易房贷款',
                  '2033','个人住房新建房非抵押贷款（非保障性住房）',
                  '2032','个人住房新建房抵押贷款（非保障性住房）',
                  '2031','个人商业用房贷款',
                  '2011','商业用房购房贷款',
                  '103','其他地产开发贷款',
                  '113','其他住房开发贷款',
                  '1113','经济适用住房开发贷款-住房开发',
                  '其他房地产贷款')                   AS FDCDKLX      --9 房地产贷款类型
        ,'不适用'                                     AS SFBZXZLZF --10 是否保障性租赁住房--无业务
        ,CASE WHEN F.STD_PROD_ID IN('201010300006')
              THEN '住房租赁消费贷款'
              ELSE '不适用'
         END                                          AS ZFZLDKLB --11 住房租赁贷款类别
        ,A.LTV                                        AS DKJZB    --12 贷款价值比
        ,CASE WHEN A.LTV <= 50 
              THEN 'A LTV≤50%'
              WHEN 50 < A.LTV AND A.LTV <= 60 
              THEN '50%＜LTV≤60%'
              WHEN 60 < A.LTV AND A.LTV <= 70 
              THEN '60%＜LTV≤70%'
              WHEN 70 < A.LTV AND A.LTV <= 80 
              THEN '70%＜LTV≤80%'
              WHEN A.LTV > 80 
              THEN 'LTV﹥80%'
              WHEN A.LTV IS NULL 
              THEN '非抵押方式'
         END                                           AS DKJZBQJ --13 贷款价值比区间
        ,DECODE(F.LVL5_CL,'01','正常',
                          '02','关注',
                          '03','次级',
                          '04','可疑',
                          '05','损失','不适用')        AS WJFL --14 五级分类
        ,F.LOAN_NET_VAL*J.EXRT                         AS TJYE --15 统计余额（元）
        ,DECODE(A.ALDY_HAVE_HSE_NUM,'1','第一套房',
                                    '2','第二套房',
                                    '3','第三套房及以上',
                                    '不适用')          AS ZFTS --16 住房套数
        ,DECODE(A.IND_HSE_LOAN_TYP,'1','是','2','否')  AS SFXJZF --17 是否新建住房 --核实数据
        ,CASE WHEN NVL(F.RATE_TYP,'9') NOT IN ('0','1') 
               AND F.PRC_BASE_TYP = 'TR07'
              THEN F.BASE_RATE - F.ACT_RATE
              ELSE 0
         END                                           AS DKLLJJD --18 贷款利率加减点
        ,CASE WHEN A.RATE_TYP IN ('0') 
              THEN '固定利率贷款'
              WHEN A.RATE_TYP IN ('1', '2') AND A.INT_RAT_FLO_VAL<0 
              THEN 'R＜LPR'
              WHEN A.RATE_TYP IN ('1', '2') AND A.INT_RAT_FLO_VAL=0 
              THEN 'R=LPR'
              WHEN A.RATE_TYP IN ('1', '2') AND A.INT_RAT_FLO_VAL<60 
              THEN 'LPR＜R＜LPR+60bp'
              WHEN A.RATE_TYP IN ('1', '2') AND  A.INT_RAT_FLO_VAL=60 
              THEN 'R=LPR+60bp'
              WHEN A.RATE_TYP IN ('1', '2') AND  A.INT_RAT_FLO_VAL>60 
              THEN 'R﹥LPR+60bp'
              ELSE '其他'
         END                                           AS DKLLLB --19 贷款利率类别
        ,A.HSE_BLDG_AREA                               AS JZMJ   --20 建筑面积（平方米）
        ,CASE WHEN A.HSE_BLDG_AREA > 144
              THEN 'M﹥144m2'
              WHEN A.HSE_BLDG_AREA > 90
              THEN '90m2＜M≤144m2'
              WHEN A.HSE_BLDG_AREA > 0
              THEN 'M≤90m2'
              ELSE '不适用'
         END                                           AS JZMJQJ --21 建筑面积区间
        ,CASE WHEN NVL(D.FAMILY_MON_INCO,0) > 0 
              THEN NVL(D.FAMILY_MON_INCO,0)
              ELSE D.FAMILY_YEAR_INCOME/12  
         END                                           AS JTYJSR --22 家庭月均收入（元）
        ,A.MON_PTY_CHGS                                AS YWYGLF --23 月物业管理费（元）
        ,NVL(A.DSR,0)                                  AS CZSRB  --24 偿债收入比（%）
        ,CASE WHEN NVL(A.DSR,0) > 50
              THEN 'DSR﹥50%'
              WHEN NVL(A.DSR,0) > 30
              THEN '30%＜DSR≤50%'
              WHEN NVL(A.DSR,0) > 0
              THEN 'DSR≤30%'
              ELSE '不适用'
         END                                           AS CZSRBQJ --25 偿债收入比区间
        ,L.LOAN_PROD_NM                                AS DKYWPZ --26 贷款业务品种
        ,DECODE(A.HSE_PTY_MTG_FLG,'Y','是'
                                 ,'N','否'
                                 ,'不适用')            AS SFYFCDY --27 是否有房产抵押
        ,A.HOUSE_TOT_PRICE                             AS ZFSJ --28 住房售价（元）
        ,A.HOUSE_FIRST_PAY_AMT                         AS ZFSFJE --29 住房首付金额（元）
        --,E.CONFMAMT                                AS YPZXGZ --30 押品最新估值（元）
        ,A.BANK_IDNT_PRC_VAL                           AS YPZXGZ --30 押品最新估值（元）
        ,DECODE(F.EXTN_FLG,'Y','是','否')              AS SFZQ --31 是否展期
        ,F.OVD_DAYS                                    AS TJYQTS       --32 统计逾期天数（天）
        ,CASE WHEN F.OVD_DAYS > 360 THEN '逾期361天以上'
              WHEN F.OVD_DAYS > 180 THEN '逾期181天到360天'
              WHEN F.OVD_DAYS > 90 THEN '逾期91天到180天'
              WHEN F.OVD_DAYS > 60 THEN '逾期61天到90天'
              WHEN F.OVD_DAYS > 30 THEN '逾期31天到60天'
              WHEN F.OVD_DAYS > 0 THEN '逾期30天以内'
              ELSE '未逾期'
         END                                           AS YQTSQJ --33 逾期天数区间
        ,CASE WHEN F.OVD_DAYS = 0 
              THEN 0
              WHEN F.OVD_DAYS <= 90 
               AND (SUBSTR(F.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104') 
                    OR F.LOAN_BIZ_TYP = '010201') --个人消费
               AND F.GXH_PAY_TYPE IN ('1', '2', '6', '7', '8', '9', '11') --还款方式 1-等额本息  2-等额本金  6-气球贷  7-等额累进 8-等比累进  9-等本等息 11-按比例还本
               AND F.GXH_PAY_FREQ = 'M' --还款频率 按月还款
              THEN NVL(F.OVD_PRIN_BAL, 0) * J.EXRT --逾期金额
              ELSE (NVL(F.LOAN_BAL, 0) + NVL(F.INT_ADJ, 0)) * J.EXRT --贷款余额
         END                                           AS TJYQBJJE --34 统计逾期本金金额（元）--修改逻辑
        ,F.LOAN_ACT_DSTR_DT                            AS FKR --35 放款日
        ,F.LOAN_AMT                                    AS FKJEY --36 放款金额元
        ,F.LOAN_USEAGE                                 AS DKYT --37 贷款用途
        ,F.GUA_MODE                                    AS ZHUDBFS --38 主担保方式
        ,F.SUB_GUA_MODE                                AS ZIDBFS --39 子担保方式
        ,G.CURR_ISSUE_RECVBL_PRIC+G.CURR_ISSUE_INT_RECVBL  AS BCDKDYHKE --40 本次贷款的月还款额（元）
        ,CASE WHEN SUBSTR(F.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6)
              THEN F.LOAN_AMT * J.EXRT
              ELSE 0
         END                                           AS DYXFFJE  --41 当月新发放金额（元）
        ,NVL(H.LOAN_BAL * J.EXRT,0)                    AS YCYE     --42 月初余额（元）
        ,CASE WHEN SUBSTR(F.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6)
              THEN (H.LOAN_BAL +F.LOAN_AMT -F.LOAN_BAL)* J.EXRT
              ELSE (H.LOAN_BAL-A.LOAN_BAL )* J.EXRT
         END                                           AS DYHSJE   --43 当月回收金额（元）
    FROM RRP_MDL.S_LOAN F--房地产贷款整合表
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO B --机构表
      ON B.ORG_ID = F.ORG_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO BB   --零售贷款借据信息
      ON BB.DUBIL_ID = F.RCPT_ID
     AND BB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.S_LOAN_RL_EST A   --贷款业务整合表
      ON A.RCPT_ID =F.RCPT_ID
     AND A.DATA_SRC='零售贷款'
     AND A.DATA_DT =V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON F.CUST_ID = D.CUST_ID
     AND D.DATA_DT = V_P_DATE
    /*LEFT JOIN (SELECT CREDNO
                    ,SUM(CONFMAMT)  AS CONFMAMT
               FROM S_G13_BASE
               WHERE DATA_DT =V_P_DATE
               GROUP BY CREDNO) E
        ON F.RCPT_ID =E.CREDNO*/
    LEFT JOIN(  SELECT DUBIL_ID
                      ,MAX(JOB_CD) AS JOB_CD
                      ,MAX(ACCT_ID) AS ACCT_ID
                      ,MAX(CUST_ID) AS CUST_ID
                      ,MAX(REPAYBL_DT) AS REPAYBL_DT
                      ,SUM(CURR_ISSUE_RECVBL_PRIC) AS CURR_ISSUE_RECVBL_PRIC
                      ,SUM(CURR_ISSUE_INT_RECVBL) AS CURR_ISSUE_INT_RECVBL
                 FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN --零售贷款还款计划
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TRUNC(REPAYBL_DT,'MM')=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
                GROUP BY DUBIL_ID ) G
      ON F.RCPT_ID = G.DUBIL_ID
    LEFT JOIN RRP_MDL.S_LOAN   H --贷款业务整合表
      ON F.RCPT_ID =H.RCPT_ID
     AND H.DATA_DT =TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')-1,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表GROUP BY
      ON F.CUR = J.BASE_CUR   --基准币种
     AND J.CNV_CUR = 'CNY'     --折算币种
     AND J.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO L
      ON F.RCPT_ID=L.RCPT_ID
     AND L.DATA_DT=V_P_DATE
    LEFT JOIN (SELECT DISTINCT RCPT_ID, DATA_SRC FROM A_PHB_REALESTATE_TMP01) K
      ON F.RCPT_ID =K.RCPT_ID
   WHERE F.DATA_DT=V_P_DATE
       --AND F.DATA_SRC='零售贷款'
     AND F.CUST_LRG_CL = '01'
     --AND F.LOAN_BAL<>0 
     AND (A.RCPT_ID IS NOT NULL OR K.RCPT_ID IS NOT NULL)
       ;
       --AND A.CUR = 'CNY'
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
      FROM RRP_MDL.A_PHB_REALESTATE T
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

  END ETL_A_PHB_REALESTATE;
/

