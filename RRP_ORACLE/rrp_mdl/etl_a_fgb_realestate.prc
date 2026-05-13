CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_REALESTATE
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_REALESTATE
  *  功能描述：以借据为粒度，整合房地产贷款所需的借据属性信息和客户属性信息。
  *  创建日期：20221109
  *  开发人员：徐菲
  *  来源表：S_LOAN_RL_EST  --房地产贷款整合表
  *  目标表：A_FGB_REALESTATE --房地产贷款基表_对公
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221109   xufei      首次创建
  *   2    20230524   lIUYU      根据业务测试反馈调整贷款利率加减点字段逻辑
      3    20240408   lwb         按业务王玲要求增加一部分借据为其他房地产
      4    20240416   LWB         新增展期未到期贷款标志
      5    20240513   LWB      新增是否因资金链断裂导致的逾期未交付项目
      6    20250117   LWB      修改房地产贷款类别的逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_REALESTATE';
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
  V_TAB_NAME := 'A_FGB_REALESTATE'; --表名,写目标表表名
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

  ETL_PARTITION_ADD(I_P_DATE, 'A_FGB_REALESTATE', '1', O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

     INSERT /*+APPEND*/ INTO   A_FGB_REALESTATE NOLOGGING (
     BGRQ         --1 报告日期
    ,JYWYM        --2 交易唯一码
    ,YWHTBH       --3 业务合同编号
    ,JGBH         --4 机构编号
    ,JGMC         --5 机构名称
    ,FDCDKLX      --6 房地产贷款类型
    ,FDCDKLB      --7 房地产贷款类别
    ,BZXDKLB      --8 保障性贷款类别
    ,ZFZLDKLB     --9 住房租赁贷款类别
    ,BZXZLZFDKLB  --10保障性租赁住房贷款类别
    ,ZBJBL        --11 资本金比例
    ,ZBJBLQJ      --12 资本金比例区间
    ,DKJZB        --13 贷款价值比
    ,DKJZBQJ      --14 贷款价值比区间
    ,WJFL         --15 五级分类
    ,TJYE         --16 统计余额（元）
    ,DKLLJJD      --17 贷款利率加减点
    ,DKLLLB       --18 贷款利率类别
    ,DKYWPZ       --19 贷款业务品种
    ,SFJYXWYDK    --20 是否经营性物业贷款
    ,SFFDCBGDK    --21 是否房地产并购贷款
    ,SFYFCDY      --22 是否有房产抵押
    ,XMZTZ        --23 项目总投资（元）
    ,XMZBJ        --24 项目资本金（元）
    ,SFZQ         --25 是否展期
    ,TJYQTS       --26 统计逾期天数（天）
    ,YQTSQJ       --27 逾期天数区间
    ,TJYQBJJE     --28 统计逾期本金金额（元）
    ,ZHWYM        --29 账户唯一码
    ,KHWYM        --30 客户唯一码
    ,KHMC         --31 客户名称
    ,FKR          --32 放款日
    ,FKJEY        --33 放款金额元
    ,DYXFFJE      --34 当月新发放金额（元）
    ,YCYE         --35 月初余额（元）
    ,DYHSJE       --36 当月回收金额（元）
    ,YPZXGZ       --37 最新的押品评估价值
    ,renew_flg_wdq  --38展期未到期标志 add by lwb
    ,SFYZLLDLYQWJFXM --是否因资金链断裂导致的逾期未交付项目
  )
    WITH A_FGB_REALESTATE_TMP AS
     (SELECT  DISTINCT T3.RCPT_ID
        FROM RRP_MDL.S_LOAN T3
        LEFT JOIN RRP_MDL.S_LOAN_RL_EST T2 --房地产贷款整合表
          ON T2.RCPT_ID = T3.RCPT_ID
         AND T2.DATA_DT = T3.DATA_DT
        LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U
          ON U.DATA_DT = V_P_DATE
         AND U.BASE_CUR = T3.CUR
         AND U.CNV_CUR = 'CNY'
       WHERE T3.DATA_DT = V_P_DATE --数据日期
         AND T3.CUR = 'CNY' --币种
         AND ((T2.RL_EST_LOAN_TYP IN ('501', '502')) OR
             (T3.RCPT_ID NOT IN
             (SELECT DISTINCT T2.RCPT_ID
                 FROM RRP_MDL.S_LOAN_RL_EST T2
                WHERE ((SUBSTR(T2.RL_EST_LOAN_TYP, 1, 3) IN
                      ('102', '111', '112', '113'))
                   OR (T2.RL_EST_LOAN_TYP IN
                      ('114', '115', '119', '2011', '2021', '2031'))
                   OR (SUBSTR(T2.RL_EST_LOAN_TYP, 1, 4) IN
                      ('2032', '2033', '2034', '2035', '2036'))
                      ) AND T2.DATA_DT=V_P_DATE
                      )AND SUBSTR(T3.LOAN_DIR_IDY, 1, 1) = 'K'
                      )
                      )
         AND T3.CUST_LRG_CL = '02' --对公(1.5.1 其中：经营性物业贷款+ 1.5.2 其中：房地产并购贷款+除去1.1~1.4的所有借据剩下投向房地产业的借据，按借据号去重)  
      --AND SUBSTR(T3.LOAN_ACT_DSTR_DT, 1, 6) = SUBSTR(V_P_DATE, 1, 6)
      UNION ALL
      SELECT DISTINCT T2.RCPT_ID
        FROM RRP_MDL.S_LOAN T2
        LEFT JOIN RRP_MDL.S_LOAN_RL_EST T3 --房地产贷款整合表
          ON T2.RCPT_ID = T3.RCPT_ID
         AND T3.DATA_DT = V_P_DATE
       INNER JOIN (SELECT T2.CREDNO, SUM(T2.DISTVALUE) AS BAL
                    FROM RRP_MDL.S_G13_BASE T2
                    LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION T3
                      ON T2.GUARTYPE = T3.GUARTYPE
                     --AND T3.GUARTYPE <> 'ZY0304001'
                     AND T3.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
                   WHERE T2.DATA_DT = V_P_DATE
                     AND T3.FIELDIDX IN ('30', '31', '32', '33', '34', '35')
                   GROUP BY T2.CREDNO, T3.FIELDIDX) T4
          ON T2.RCPT_ID = T4.CREDNO
       WHERE T2.DATA_DT = V_P_DATE --数据日期
         AND T3.RCPT_ID IS NULL
         AND T2.LOAN_BAL <> 0
         AND T2.CUST_LRG_CL = '02'
         AND T2.LOAN_DIR_IDY NOT LIKE 'K%' -- 不投向房地产的借据

      ),
    GUA_COLL_INFO AS
     (SELECT T2.CREDNO,
             SUM(NVL(T2.CONFMAMT, 0)) CONFMAMT,
             MAX(CASE
                   WHEN T3.FIELDIDX IN ('30', '31', '32', '33', '34', '35') THEN
                    'Y'
                   ELSE
                    'N'
                 END) AS REL_COLL --MDF BY XMZ 20230202 业务容炳华确认房地产贷款类型为这6类
        FROM S_G13_BASE T2
        LEFT JOIN RRP_MDL.O_IOL_MIMS_YP_G13RELATION T3
          ON T2.GUARTYPE = T3.GUARTYPE
         --AND T3.GUARTYPE <> 'ZY0304001'
         AND T3.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
       WHERE T2.DATA_DT = V_P_DATE
       GROUP BY T2.CREDNO, T3.FIELDIDX
      UNION ALL
      SELECT T2.RCPT_ID, SUM(NVL(T2.CONFMAMT, 0)) CONFMAMT, ''
        FROM RRP_MDL.S_S67_YP T2 --个人住房贷款和个人购买商用房贷款取不到押品价值的借据由业务老师补录押品价值
       GROUP BY T2.RCPT_ID)

    SELECT T1.DATA_DT                              AS BGRQ --1 报告日期
          ,T1.RCPT_ID                              AS JYWYM --2 交易唯一码
          ,T1.CONT_ID                              AS YWHTBH -- 业务合同编号
          ,T1.ORG_ID                               AS JGBH --3 机构编号
          ,T3.ORG_NM                               AS JGMC --4 机构名称
          ,CASE
             WHEN T2.RL_EST_LOAN_TYP = '502' THEN '房地产并购贷款'
             WHEN T2.RL_EST_LOAN_TYP = '501' THEN '经营性物业贷款'
             WHEN T2.RL_EST_LOAN_TYP = '114' THEN '商业用房开发贷款'
             WHEN T2.RL_EST_LOAN_TYP = '2036' THEN '个人住房再交易房贷款'
             WHEN T2.RL_EST_LOAN_TYP = '2033' THEN '个人住房新建房非抵押贷款（非保障性住房）'
             WHEN T2.RL_EST_LOAN_TYP = '2032' THEN '个人住房新建房抵押贷款（非保障性住房）'
             WHEN T2.RL_EST_LOAN_TYP = '2031' THEN '个人商业用房贷款'
             WHEN T2.RL_EST_LOAN_TYP = '2011' THEN '商业用房购房贷款'
             WHEN T2.RL_EST_LOAN_TYP = '103' THEN '其他地产开发贷款'
             WHEN T2.RL_EST_LOAN_TYP = '113' THEN '其他住房开发贷款'
             WHEN T2.RL_EST_LOAN_TYP = '1113' THEN '经济适用住房开发贷款-住房开发'
             ELSE
              CASE
                WHEN T1.LOAN_DIR_IDY NOT LIKE 'K%' AND T13.RCPT_ID IS NULL THEN
                 '其他以房地产为抵押的贷款'
                ELSE
                 '其他房地产贷款'
              END
           END                                     AS FDCDKLX --5 房地产贷款类型
          ,CASE WHEN SUBSTR(T2.RL_EST_LOAN_TYP, 1, 3) IN ('101', '102', '103') THEN
              '地产开发贷款'
             WHEN SUBSTR(T2.RL_EST_LOAN_TYP, 1, 3) IN ('111', '112', '113') THEN
              '住房开发贷款'
             WHEN T2.RL_EST_LOAN_TYP = '114' THEN
              '商业用房开发贷款'
             WHEN T2.RL_EST_LOAN_TYP IN ('115', '119') THEN
              '其他房产开发贷款'
             WHEN T2.RL_EST_LOAN_TYP IN ('2011', '2021', '2031') THEN
              '企业购买商业房产贷款'
             WHEN SUBSTR(T2.RL_EST_LOAN_TYP, 1, 4) IN
                  ('2032', '2033', '2034', '2035', '2036') THEN
              '个人住房贷款'
             WHEN T1.LOAN_DIR_IDY LIKE 'K%' OR
                  T2.RL_EST_LOAN_TYP IN ('501', '502')OR T13.RCPT_ID IS NOT NULL THEN --20240408 MODIFY BY LWB
              '其他房地产贷款'
             ELSE
              '不适用'
           END                                     AS FDCDKLB --6 房地产贷款类别
          ,NVL2(T2.AFP_TYP, '保障性安居工程开发贷款', '不适用') AS BZXDKLB --7 保障性贷款类别
          ,CASE
             WHEN T7.ZFZLDKLB = '01' THEN
              '住房租赁开发贷款'
             WHEN T7.ZFZLDKLB = '02' THEN
              '住房租赁经营贷款'
             WHEN T7.ZFZLDKLB = '03' THEN
              '住房租赁购买贷款'
             WHEN T7.ZFZLDKLB = '04' THEN
              '住房租赁消费贷款'
             WHEN T7.ZFZLDKLB = '05' THEN
              '其他'
             ELSE
              '不适用'
           END                                     AS ZFZLDKLB --8 住房租赁贷款类别  --补录
          ,CASE
             WHEN T7.BZXZLZFDKLB = '01' THEN
              '保障性租赁住房开发贷款'
             WHEN T7.BZXZLZFDKLB = '02' THEN
              '保障性租赁住房经营贷款'
             WHEN T7.BZXZLZFDKLB = '03' THEN
              '保障性租赁住房购买贷款'
             ELSE
              '不适用'
           END                                     AS BZXZLZFDKLB --9 保障性租赁住房贷款类别  --补录
          ,CASE
             WHEN T10.PROJ_TOT_INVEST = 0 OR T10.PROJ_TOT_INVEST IS NULL THEN
              0
             ELSE
              T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100
           END AS ZBJBL --10 资本金比例
          ,CASE
             WHEN NVL(T10.PROJ_TOT_INVEST, 0) = 0 THEN
              '不适用'
             ELSE
              CASE
                WHEN ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 20 THEN
                 '资本金≤20%'
                WHEN 20 < ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) AND
                     ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 25 THEN
                 '20%<资本金≤25%'
                WHEN 25 < ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) AND
                     ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 30 THEN
                 '25%<资本金≤30%'
                WHEN 30 < ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) AND
                     ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 35 THEN
                 '30%<资本金≤35%'
                WHEN 35 < ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) AND
                     ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 40 THEN
                 '35%＜资本金≤40%'
                WHEN 40 < ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) AND
                     ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) <= 45 THEN
                 '40%＜资本金≤45%'
                WHEN ROUND(T10.CPTL_FND / T10.PROJ_TOT_INVEST * 100, 2) > 45 THEN
                 '资本金﹥45%'
              END
           END                                     AS ZBJBLQJ --11 资本金比例区间
          ,CASE
             WHEN NVL(T11.CONFMAMT, 0) = 0 THEN
              NULL
             ELSE
              (T1.LOAN_BAL / T11.CONFMAMT) * 100
           END                                     AS DKJZB --12 贷款价值比
          ,CASE
             WHEN NVL(T11.CONFMAMT, 0) != 0 THEN
              CASE
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 80 THEN
                 'LTV>80%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 70 THEN
                 '70%＜LTV≤80%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 60 THEN
                 '60%＜LTV≤70%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 50 THEN
                 '50%＜LTV≤60%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 40 THEN
                 '40%＜LTV≤50%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 30 THEN
                 '30%＜LTV≤40%'
                WHEN (T1.LOAN_BAL / T11.CONFMAMT) * 100 > 0 THEN
                 'LTV≤30%'
                ELSE
                 '非抵押方式'
              END
             ELSE
              '非抵押方式'
           END                                     AS DKJZBQJ --13 贷款价值比区间
          ,DECODE(T1.LVL5_CL, '01','正常',
                             '02','关注',
                             '03','次级',
                             '04','可疑',
                             '05','损失',
                  '不适用')                        AS WJFL --14 五级分类
          ,T1.LOAN_NET_VAL * T6.EXRT                 AS TJYE --15 统计余额（元）
          ,CASE
             WHEN NVL(T1.RATE_TYP, '9') NOT IN ('0', '1') AND
                  T1.PRC_BASE_TYP = 'TR07' THEN
              /*T1.BASE_RATE - T1.ACT_RATE*/
              T1.ACT_RATE - T1.BASE_RATE --mod by liuyu 20230524
             ELSE
              0
           END                                     AS DKLLJJD --16 贷款利率加减点  --个人购房贷款的指标
          ,CASE
             WHEN T9.RATE_TYP IN ('1', '0') THEN
              '固定利率贷款'
             WHEN T9.FIXED_INT_MARK = '0' THEN
              '固定利率贷款'
             WHEN T9.RATE_TYP = '2' THEN
              '浮动利率贷款'
             ELSE
              '其他'
           END                                     AS DKLLLB --17 贷款利率类别 --个人购房贷款的指标
          ,T9.LOAN_PROD_NM                         AS DKYWPZ --18 贷款业务品种
          ,DECODE(T2.RL_EST_LOAN_TYP, '501', '是', '否')
                                                   AS SFJYXWYDK --19 是否经营性物业贷款
          ,DECODE(T2.RL_EST_LOAN_TYP, '502', '是', '否')
                                                   AS SFFDCBGDK --20 是否房地产并购贷款
          ,DECODE(T11.REL_COLL, 'Y', '是', '否')   AS SFYFCDY --21 是否有房产抵押
          ,T10.PROJ_TOT_INVEST                     AS XMZTZ --22 项目总投资（元）
          ,T10.CPTL_FND                            AS XMZBJ --23 项目资本金（元）
          ,DECODE(T1.EXTN_FLG, 'Y', '是', '否')    AS SFZQ --24 是否展期
          ,T1.OVD_DAYS                             AS TJYQTS --25 统计逾期天数（天）
          ,CASE
             WHEN T1.OVD_DAYS > 360 THEN
              '逾期361天以上'
             WHEN T1.OVD_DAYS > 180 THEN
              '逾期181天到360天'
             WHEN T1.OVD_DAYS > 90 THEN
              '逾期91天到180天'
             WHEN T1.OVD_DAYS > 60 THEN
              '逾期61天到90天'
             WHEN T1.OVD_DAYS > 30 THEN
              '逾期31天到60天'
             WHEN T1.OVD_DAYS > 0 THEN
              '逾期30天以内'
             ELSE
              '未逾期'
           END                                     AS YQTSQJ --26 逾期天数区间
          ,CASE
             WHEN T1.OVD_DAYS > 0 THEN
              T1.LOAN_BAL * T6.EXRT
             ELSE
              0
           END                                     AS TJYQBJJE --27 统计逾期本金金额（元）
          ,T1.CONT_ID                               AS ZHWYM --28 账户唯一码
          ,T1.CUST_ID                               AS KHWYM --29 客户唯一码
          ,T4.CUST_NM                               AS KHMC --30 客户名称
          ,TO_DATE(T1.LOAN_ACT_DSTR_DT, 'YYYYMMDD')
                                                  AS FKR --31 放款日
          ,T1.LOAN_AMT * T6.EXRT                     AS FKJEY --32 放款金额元
          ,CASE
             WHEN SUBSTR(T1.LOAN_ACT_DSTR_DT, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN
              T1.LOAN_AMT * T6.EXRT
             ELSE
              0
           END                                     AS DYXFFJE --33 当月新发放金额（元）
          ,NVL(T5.LOAN_NET_VAL * T6.EXRT, 0)         AS YCYE --34 月初余额（元）
          ,CASE
             WHEN SUBSTR(T1.LOAN_ACT_DSTR_DT, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN
              (T5.LOAN_BAL + T1.LOAN_AMT - T1.LOAN_BAL) * T6.EXRT
             ELSE
              (T5.LOAN_BAL - T1.LOAN_BAL) * T6.EXRT
           END                                     AS DYHSJE --35 当月回收金额（元）
          ,T8.CONFMAMT                             AS YPZXGZ --36 最新的押品评估价值 --对公不需要押品价值
          ,t1.renew_flg_wdq                        as renew_flg_wdq --37展期未到期贷款 add  by lwb
          ,T1.SFYZLLDLYQWJFXM                      AS SFYZLLDLYQWJFXM --是否因资金链断裂导致的逾期未交付项目
      FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
      LEFT JOIN RRP_MDL.S_LOAN_RL_EST T2 --房地产贷款整合表
        ON T2.RCPT_ID = T1.RCPT_ID
       AND T2.DATA_DT = T1.DATA_DT
       AND T2.DATA_SRC = '对公信贷'
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
        ON T3.ORG_ID = T1.ORG_ID
       AND T3.DATA_DT = T1.DATA_DT
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T4 --对公客户信息
        ON T4.CUST_ID = T1.CUST_ID
       AND T4.DATA_DT = T1.DATA_DT
      LEFT JOIN RRP_MDL.S_LOAN T5 --贷款业务整合表 月初余额
        ON T5.RCPT_ID = T1.RCPT_ID
       AND T5.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'MM') - 1, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO T6 --汇率表
        ON T6.BASE_CUR = T1.CUR
       AND T6.CNV_CUR = 'CNY'
       AND T6.DATA_DT = T1.DATA_DT
      LEFT JOIN (SELECT T.*,
                        ROW_NUMBER() OVER(PARTITION BY JYWYM ORDER BY JYWYM) AS RN
                   FROM M_ADD_DG_006_HOUSE_LAND T --住房贷款补录表
                  WHERE T.DATA_DATE = V_P_DATE) T7
        ON T7.JYWYM = T1.RCPT_ID
       AND T7.RN = 1
       AND T7.DATA_DATE = V_P_DATE
      LEFT JOIN (SELECT CREDNO, SUM(CONFMAMT) AS CONFMAMT
                   FROM S_G13_BASE -- G13贷款押品分配结果表
                  WHERE DATA_DT = V_P_DATE
                  GROUP BY CREDNO) T8
        ON T8.CREDNO = T1.RCPT_ID
      LEFT JOIN M_LOAN_IN_DUBILL_INFO T9 --表内借据表
        ON T9.RCPT_ID = T1.RCPT_ID
       AND T9.DATA_DT = V_P_DATE
      LEFT JOIN M_LOAN_PROJ_SUB T10 --项目贷款子表
        ON T10.CONT_ID = T1.CONT_ID
       AND T10.DATA_DT = V_P_DATE
      LEFT JOIN (SELECT CREDNO, SUM(CONFMAMT) CONFMAMT, MAX(REL_COLL) REL_COLL
                   FROM GUA_COLL_INFO
                  GROUP BY CREDNO) T11
        ON T11.CREDNO = T1.RCPT_ID
      LEFT JOIN (SELECT DISTINCT RCPT_ID FROM A_FGB_REALESTATE_TMP A) T12
        ON T12.RCPT_ID = T1.RCPT_ID
      LEFT JOIN RRP_MDL.S67_OTHER_LOAN T13
        ON T13.RCPT_ID=T1.RCPT_ID
     WHERE T1.DATA_DT = V_P_DATE
       AND T1.CUST_LRG_CL = '02'
       AND (T2.RL_EST_LOAN_TYP IS NOT NULL OR T12.RCPT_ID IS NOT NULL OR T13.RCPT_ID IS NOT NULL);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT BGRQ,JYWYM,COUNT(1)
      FROM RRP_MDL.A_FGB_REALESTATE T
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

  END ETL_A_FGB_REALESTATE;
/

