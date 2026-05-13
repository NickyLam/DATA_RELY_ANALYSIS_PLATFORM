CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_POV_ALLE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_POV_ALLE
  *  功能描述：金融精准扶贫整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_POV_ALLE_SUB
  *            M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *            M_LOAN_AGR_REL_SUB
  *            M_PUB_ORG_INFO
  *
  *
  *  目标表：  S_LOAN_POV_ALLE
  *  配置表：  CONFIG_AREA
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230103  于敬艺   新增贷款余额净值、经营授信总额
  *            2     20230206  黄一凡   新增贷款用途，修改统计担保方式
  *            3     20230811  HYF     新增机构表日期过滤
  *            4     20231012  HYF     修改放款日期取值
  *            5     20260413  HYF     修改担保方式取数逻辑，T日放款的取合同表当天的数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_POV_ALLE'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_POV_ALLE'; --表名
  V_PART_NAME := 'PARTITION_'||V_YESTADAY;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_POV_ALLE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_POV_ALLE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


 -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_YESTADAY, 'S_LOAN_POV_ALLE', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '金融精准扶贫整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_POV_ALLE
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       RCPT_ID, --借据编号
       CUR, --币种
       LOAN_BAL, --贷款余额
       LOAN_AMT, --放款金额
       ACT_RATE, --实际利率
       LOAN_BIZ_TYP, --贷款业务类型
       POV_ALLE_LOAN_BIZ_VRTY, --扶贫贷款业务品种
       DSBR_DT, --贷款实际发放日期
       LOAN_TERM, --贷款期限
       MAIN_GUA_MODE, --统计担保方式
       LOAN_DIR_IDY_CL, --贷款投向行业门类
       FAMILY_FARM_LOAN_FLG, --家庭农场贷款标志
       AGR_LDR_ENT_FLG, --农业产业化龙头企业贷款标志
       FARMER_PROF_COOP_FLG, --农民专业合作社贷款标志
       AGR_PROF_BIG_CUST_LOAN_FLG, --农业专业大户贷款标志
       REC_POOR_PSN_LOAN_TYP, --建档立卡贫困户贷款类型
       POV_ALLE_LOAN_FLG, --精准扶贫贴息贷款标志
       POV_ALLE_SML_LOAN_FLG, --扶贫小额信贷标志
       POV_ALLE_LOAN_IDNT_TYP, --扶贫贷款认定类型
       POV_ALLE_DRV_REC_NUM, --扶贫带动建档立卡人数
       POV_ALLE_DRV_SHK_NUM, --扶贫带动已脱贫人数
       SGL_CRDT_AMT, --单户授信金额
       LVL5_CL, --五级分类
       CUST_LRG_CL, --客户大类
       CNTY_DMN_RGN_FLG, -- 县域地区标志
       DEPT_LINE, --部门条线
       DATA_SRC, --数据来源
       REC_POOR_FLG,  --建档立卡贫困户标志
       POV_ALLE_LOAN_CL, --扶贫贷款认定类型
       POV_ALLE_LOAN_TYP, --扶贫贷款类型
       FAIR_VAL_CHG,      --公允价值变动
       INT_ADJ,            --利息调整
       LOAN_NET_VAL,        -- 贷款净值
       OPR_CRDT_TOT_AMT,   --经营授信总额
       STD_PROD_ID, --标准产品编号
       LOAN_USEAGE --贷款用途
       )
      SELECT A.DATA_DT                                             AS DATA_DT, --数据日期
             A.LGL_REP_ID                                          AS LGL_REP_ID, --法人编号
             A.ORG_ID                                              AS ORG_ID, --机构编号
             A.CUST_ID                                             AS CUST_ID, --客户编号
             A.RCPT_ID                                             AS RCPT_ID, --借据编号
             B.CUR                                                 AS CUR, --币种
             CASE WHEN SUBSTR(B.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
              ELSE NVL(B.LOAN_BAL,0)
             END                                                   AS LOAN_BAL, --贷款余额
             A.AMT                                                 AS LOAN_AMT, --放款金额
             ''/*B.ACT_RATE*/                                      AS ACT_RATE, --实际利率
             CASE WHEN B.LOAN_BIZ_TYP LIKE '01%'
                   AND B.LOAN_USEAGE LIKE '%耐用消费品%' THEN '010303'
              ELSE B.LOAN_BIZ_TYP END                              AS LOAN_BIZ_TYP, --贷款业务类型
             A.POV_ALLE_LOAN_BIZ_VRTY                              AS POV_ALLE_LOAN_BIZ_VRTY, --扶贫贷款业务品种
             B.DISTR_DT                                            AS DISTR_DT, --贷款实际发放日期
/*             CASE WHEN B.DATA_SRC = '零售贷款'
              THEN (CASE WHEN B.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN 'S'  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>60 THEN 'L'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>36 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>24 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>12 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>6 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>3 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>=0 THEN 'S'
                    END)
              WHEN B.DATA_SRC = '联合网贷'
              THEN (CASE WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >60 THEN 'L'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >36 THEN 'M'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >24 THEN 'M'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >=13 THEN 'M'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >6 THEN 'S'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >3 THEN 'S'
                         WHEN (TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(B.DISTR_DT,'YYYYMMDD')) / 30 >=0 THEN 'S'
                    END)
              WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
              THEN (CASE WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>60 THEN 'L'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>36 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>24 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>12 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>6 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>3 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>=0 THEN 'S'
                    END)
            END                                                    AS LOAN_TERM, --贷款期限*/
            CASE WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>60 THEN 'L'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>36 THEN 'M'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>24 THEN 'M'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>12 THEN 'M'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>6 THEN 'S'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>3 THEN 'S'
                 WHEN MONTHS_BETWEEN(TO_DATE(B.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(B.DISTR_DT,'YYYYMMDD'))>=0 THEN 'S'
             END                                                   AS LOAN_TERM, --贷款期限                                                
             CASE WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND S.SUB_GUA_MODE IN ('3','4','5','6','7','8')-- 3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
                  THEN 'DZY' --抵质押贷款
                  WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND S.SUB_GUA_MODE = '2'   --2-保证
                  THEN 'BZ' --保证贷款
                  WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND S.SUB_GUA_MODE = '1'   --1-信用
                  THEN 'XY' --信用贷款        --对公
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND  ( S.MAIN_GUA_MODE IN ('1','2')  OR S.SUB_GUA_MODE IN ('3','4','5','6','7','8'))-- 3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
                  THEN 'DZY' --抵质押贷款
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND ( S.MAIN_GUA_MODE ='3'  OR S.SUB_GUA_MODE = '2'  )--2-保证
                  THEN 'BZ' --保证贷款
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND  (S.MAIN_GUA_MODE ='4'  OR S.SUB_GUA_MODE  = '1' ) --1-信用
                  THEN 'XY' --信用贷款       --个人
                  --补充取T日放款逻辑
                  WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND T.SUB_GUA_MODE IN ('3','4','5','6','7','8')-- 3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
                  THEN 'DZY' --抵质押贷款
                  WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND T.SUB_GUA_MODE = '2'   --2-保证
                  THEN 'BZ' --保证贷款
                  WHEN B.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
                  AND T.SUB_GUA_MODE = '1'   --1-信用
                  THEN 'XY' --信用贷款        --对公
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND  ( T.MAIN_GUA_MODE IN ('1','2')  OR T.SUB_GUA_MODE IN ('3','4','5','6','7','8'))-- 3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
                  THEN 'DZY' --抵质押贷款
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND ( T.MAIN_GUA_MODE ='3'  OR T.SUB_GUA_MODE = '2'  )--2-保证
                  THEN 'BZ' --保证贷款
                  WHEN B.DATA_SRC IN ('零售贷款', '联合网贷')
                  AND  (T.MAIN_GUA_MODE ='4'  OR T.SUB_GUA_MODE  = '1' ) --1-信用
                  THEN 'XY' --信用贷款       --个人                 
             ELSE 'Z'  END                                         AS MAIN_GUA_MODE, --统计担保方式
             B.LOAN_DIR_IDY                                        AS LOAN_DIR_IDY_CL, --贷款投向行业门类
             E.FAMILY_FARM_LOAN_FLG                                AS FAMILY_FARM_LOAN_FLG, --家庭农场贷款标志
             E.AGR_LDR_ENT_FLG                                     AS AGR_LDR_ENT_FLG, --农业产业化龙头企业贷款标志
             E.FARMER_PROF_COOP_FLG                                AS FARMER_PROF_COOP_FLG, --农民专业合作社贷款标志
             E.AGR_PROF_BIG_CUST_LOAN_FLG                          AS AGR_PROF_BIG_CUST_LOAN_FLG, --农业专业大户贷款标志
             A.REC_POOR_PSN_LOAN_TYP                               AS REC_POOR_PSN_LOAN_TYP, --建档立卡贫困户贷款类型
             A.POV_ALLE_LOAN_FLG                                   AS POV_ALLE_LOAN_FLG, --精准扶贫贴息贷款标志
             A.POV_ALLE_SML_LOAN_FLG                               AS POV_ALLE_SML_LOAN_FLG, --扶贫小额信贷标志
             A.POV_ALLE_LOAN_IDNT_TYP                              AS POV_ALLE_LOAN_IDNT_TYP, --扶贫贷款认定类型
             A.POV_ALLE_DRV_NUM - A.POV_ALLE_DRV_SHK_NUM           AS POV_ALLE_DRV_REC_NUM, --扶贫带动建档立卡人数
             A.POV_ALLE_DRV_SHK_NUM                                AS POV_ALLE_DRV_SHK_NUM, --扶贫带动已脱贫人数
             ''                                                    AS SGL_CRDT_AMT, --单户授信金额
             B.LVL5_CL                                             AS LVL5_CL, --五级分类
             CASE
               WHEN D.CUST_ID IS NOT NULL OR C.CUST_CL = 'E' THEN
                '01' --对私客户(含个体工商户)
               WHEN C.CUST_ID IS NOT NULL AND C.CUST_CL != 'E' THEN
                '02' --对公客户（剔除个体工商户）
             END                                                   AS CUST_LRG_CL, --客户大类

             CASE WHEN Z1.CNTY_DMN          = 'Y'                        THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z2.CNTY_DMN = 'Y' THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z3.CNTY_DMN = 'Y' THEN 'Y' ELSE 'N' END AS CNTY_DMN_RGN_FLG, -- 县域地区标志

             B.DEPT_LINE                                           AS DEPT_LINE, --部门条线
             B.DATA_SRC                                            AS DATA_SRC, --数据来源
             CASE WHEN A.REC_POOR_PSN_LOAN_TYP = '201' THEN 'Y'
                  WHEN A.REC_POOR_PSN_LOAN_TYP = '101' THEN 'N'
             ELSE ''
             END                                                   AS REC_POOR_FLG,--建档立卡贫困户标志
             A.POV_ALLE_LOAN_IDNT_TYP                              AS POV_ALLE_LOAN_CL, --扶贫贷款认定类型
             A.POV_ALLE_LOAN_BIZ_VRTY                              AS POV_ALLE_LOAN_TYP,  --扶贫贷款类型
             B.FAIR_VAL_CHG                                        AS FAIR_VAL_CHG,      --公允价值变动
             B.INT_ADJ                                             AS INT_ADJ,            --利息调整
             CASE WHEN SUBSTR(B.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
              ELSE NVL(B.LOAN_BAL,0) + NVL(B.FAIR_VAL_CHG,0) - NVL(B.INT_ADJ,0)
             END                                                   AS LOAN_NET_VAL ,      -- 贷款净值
             ''                                                    AS OPR_CRDT_TOT_AMT,    --经营授信总额
             A.STD_PROD_ID                                         AS STD_PROD_ID, --标准产品编号
             B.LOAN_USEAGE                                         AS LOAN_USEAGE --贷款用途
        FROM M_LOAN_POV_ALLE_SUB A --精准扶贫贷款子表
        LEFT JOIN M_LOAN_IN_DUBILL_INFO_BFD B --表内借据表BFD
          ON A.RCPT_ID = B.RCPT_ID
         AND B.DATA_DT = V_YESTADAY
        LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO S --贷款合同信息
         ON B.CONT_ID = S.CONT_ID
        AND S.DATA_DT = V_YESTADAY
        LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T --贷款合同信息 --ADD BY 20260413
         ON T.CONT_ID = S.CONT_ID
        AND T.DATA_DT = V_P_DATE        
        LEFT JOIN M_CUST_CORP_INFO C --对公客户信息表
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_YESTADAY
        LEFT JOIN M_CUST_IND_INFO D --个人客户信息
          ON A.CUST_ID = D.CUST_ID
         AND D.DATA_DT = V_YESTADAY
        LEFT JOIN M_LOAN_AGR_REL_SUB E --涉农贷款子表
          ON B.RCPT_ID = E.RCPT_ID
         AND E.DATA_DT = V_YESTADAY
        LEFT JOIN M_PUM_ORG_INFO  J  --机构表
          ON A.ORG_ID = J.ORG_ID
         AND J.DATA_DT = V_YESTADAY
        LEFT JOIN CONFIG_AREA     Z1 --中国行政区划2020
          ON J.REGD_LAND_AREA_CD = Z1.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z2 --中国行政区划2020
          ON C.REGD_LAND_AREA_CD = Z2.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z3 --中国行政区划2020
          ON D.RSDNC_AREA_CD     = Z3.NEW_AREA_CD
       WHERE /*A.ACURT_POV_ALLE_LOAN_FLG='Y'
         AND*/ A.DATA_DT = V_YESTADAY;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;



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
   --V_STEP := V_STEP + 1;
     --V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_POV_ALLE;
/

