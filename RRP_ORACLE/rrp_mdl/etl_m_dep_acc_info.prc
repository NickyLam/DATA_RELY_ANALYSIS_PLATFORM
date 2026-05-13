CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_DEP_ACC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_DEP_ACC_INFO
  *  功能描述：监管集市银行所有存款账户信息，包括个人、对公、活期、定期
  *  创建日期：202205223
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_DEP_ACCT_INFO   --存款分户信息
  *            ICL.CMM_IFS_ACCT_INFO       --联合存款分户信息
  *  目标表：  M_DEP_ACC_INFO  --存款账户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220901  许晓滨   科目调整，与旧监管不同。
  *             2    20221031  许晓滨   新增字段，协定存款模式不做拆分
  *             3    20221102  HULJ     存款产品代码调整取值
  *             4    20221114  HULJ     增加数据重复校验
  *             5    20221227  HULJ     新增字段原始开户日期、原始到期日期
  *             6    20230104  HULJ     调整保证金类别取值口径
  *             7    20230725  LIP      增加最大利率，调整基准利率的取数
  *             8    20230825  LIP      存款账户利息明细没有利率类型的数据，从产品信息表中获取利率类型
  *             9    20231025  HYF      存款分户的应收利息调整为取当期应计利息,不需要加当期应付利息调整
  *             10   20240411  HYF      按业务口径调整大集中单位存款类型 C_DEPOSIT_TYPE
  *             11   20240618  LIP      增加旧账户编号，EAST用来报送
  *             12   20240809  LIP      当账户状态是销户且销户日期为空时，用销户时间当为销户日期
  *             13   20241011  HYF      新增存款余额_含电子现金DEP_CASH_BAL
  *             14   20241101  LIP      过滤旅通卡数据
  *             15   20241205  YJY      新增是否医保账户标志
  *             16   20250210  YJY      新增现金管理类产品标志
  *             17   20250513  LIP      因核心改造，阶梯历史表会有多条数据导致重复，所以程序对取利率相关信息的临时表进行排序，后面关联时取第一条数据
  *             18   20250928  YJY      修改普通存款部分的单位存款类型、大集中单位存款类型判断
  *             19   20260129  LYH      增加资金性质字段
  ************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);                         --处理步骤描述
  V_P_DATE    VARCHAR2(8);                           --跑批数据日期
  V_STARTTIME DATE;                                  --处理开始时间
  V_ENDTIME   DATE;                                  --处理结束时间
  V_SQLMSG    VARCHAR2(300);                         --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                         --分区名
  V_STEP      INTEGER := 0;                          --处理步骤
  V_SQLCOUNT  INTEGER := 0;                          --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_DEP_ACC_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_DEP_ACC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';            --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230725 加工存款账户的利率相关数据
  --根据业务口径：人民币活期部分根据最新的基准利率判断
  V_STEP := 3;
  V_STEP_DESC := '普通存款利率相关信息--人民币活期部分';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_DEP_ACC_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_DEP_ACC_INFO_TEMP01
  (  ACC_ID_EAST               --账户编号_EAST
    ,ACC_ID                    --账户编号
    ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号_新一代
    ,STD_PROD_ID               --标准产品代码
    ,ORG_ID                    --机构编号
    ,CUR                       --币种
    ,VAL_DT                    --起息日期
    ,INT_CALC_FLG              --计息标志
    ,INT_RAT_TYPE_CD           --利率类型代码
    ,BASE_RAT_ID               --基准利率编号
    ,BASE_RATE                 --基准利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,AGREE_INT_RAT_TYPE_CD     --协定存款利率类型代码
    ,AGREE_BASE_RAT_ID         --协定存款基准利率编号
    ,AGREE_BASE_RATE           --协定存款基准利率
    ,AGREE_MAX_FLOAT_POINT     --协定存款浮动点差上限
    ,AGREE_DEP_FLG             --协定存款标志
    ,DEP_PED_FREQ_CD           --存款期限 --ADD BY LIP 20250512
    ,RNM                       --序号 --ADD BY LIP 20250513
    )
    WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/CURR_CD,BANK_INT_INT_RAT_TYPE_CD,ORG_ID,PED_FREQ_CD,COUNT(1)
      FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H
     WHERE EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       --AND INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
       AND INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY CURR_CD,BANK_INT_INT_RAT_TYPE_CD,ORG_ID,PED_FREQ_CD
    HAVING COUNT(1) = 1)
  SELECT TA.ACCT_ID                                                             AS ACC_ID_EAST            --账户编号_EAST
         ,TA.CUST_ACCT_ID                                                       AS ACC_ID                 --账户编号
         ,TA.CUST_ACCT_SUB_ACCT_NUM                                             AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
         ,TA.STD_PROD_ID                                                        AS STD_PROD_ID            --标准产品代码
         ,TA.BELONG_ORG_ID                                                      AS ORG_ID                 --机构编号
         ,TA.CURR_CD                                                            AS CUR                    --币种
         ,TO_CHAR(TA.VALUE_DT,'YYYYMMDD')                                       AS VAL_DT                 --起息日期
         ,TA.INT_ACCR_FLG                                                       AS INT_CALC_FLG           --计息标志
         --NVL(REPLACE(TRIM(TB.INT_RAT_TYPE_CD),'-',''),TF.BANK_INT_INT_RAT_TYPE_CD) AS INT_RAT_TYPE_CD,  --利率类型代码
         ,NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))                AS INT_RAT_TYPE_CD        --利率类型代码
         ,COALESCE(TC.BASE_RAT_TYPE_ID,TE.BASE_RAT_TYPE_ID,TG.BASE_RAT_TYPE_ID) AS BASE_RAT_ID --基准利率编号
         --TD.BASE_RAT                                                           AS BASE_RATE,              --基准利率
         ,CASE WHEN TA.CURR_CD = 'CNY' AND C.TAR_VALUE_CODE IN ('0501','0502') --人民币活期部分取最新基准
              THEN TD.BASE_RAT
              WHEN TA.VALUE_DT <= TO_DATE('20120608','YYYYMMDD') --起息日在配置表之前的数据
              THEN TJ.BASE_RAT
              ELSE TD.BASE_RAT
           END                                                                  AS BASE_RATE              --基准利率
         ,COALESCE(TC.MAX_FLOAT_POINT,TE.MAX_FLOAT_POINT,TG.MAX_FLOAT_POINT)    AS MAX_FLOAT_POINT        --浮动点差上限
         ,DECODE(TA.AGREE_DEP_FLG,'1','XD1')                                    AS AGREE_INT_RAT_TYPE_CD  --协定存款利率类型代码
         ,DECODE(TA.AGREE_DEP_FLG,'1','2140')                                   AS AGREE_BASE_RAT_ID      --协定存款基准利率编号
         ,DECODE(TA.AGREE_DEP_FLG,'1',TI.BASE_RAT)                              AS AGREE_BASE_RATE        --协定存款基准利率
         ,DECODE(TA.AGREE_DEP_FLG,'1',TH.MAX_FLOAT_POINT)                       AS AGREE_MAX_FLOAT_POINT  --协定存款浮动点差上限
         ,TA.AGREE_DEP_FLG                                                      AS AGREE_DEP_FLG          --协定存款标志
         ,TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM                              AS DEP_PED_FREQ_CD        --存款期限 --ADD BY LIP 20250512
         ,ROW_NUMBER() OVER(PARTITION BY TA.ACCT_ID ORDER BY
             CASE WHEN TA.OPEN_ACCT_AMT - COALESCE(TC.LADR_AMT,TE.LADR_AMT,TG.LADR_AMT) >= 0
                  THEN TA.OPEN_ACCT_AMT - COALESCE(TC.LADR_AMT,TE.LADR_AMT,TG.LADR_AMT)
                  ELSE NULL
              END NULLS LAST,COALESCE(TC.EFFECT_DT,TE.EFFECT_DT,TG.EFFECT_DT) NULLS LAST) AS RNM --序号 --ADD BY LIP 20250513
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO TA
    LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL TB
      ON TB.ACCT_ID = TA.ACCT_ID
     AND TB.INT_CLS_CD = 'INT'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PRD_PROD_INT_RAT_INFO_H TJ --ADD BY LIP 20230825
      ON TJ.PROD_ID = TA.STD_PROD_ID
     AND (TB.INT_RAT_START_USE_WAY_CD = 'A' OR NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' OR TA.STD_PROD_ID = '103010200001') --根据付钦良口径，A的取产品
     AND TJ.EVT_CATE_ID = 'OPEN'
     AND TJ.INT_CLS_CD = 'INT'
     AND TJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TC --有存款期限的
      --ON TC.BANK_INT_INT_RAT_TYPE_CD = TB.INT_RAT_TYPE_CD
      ON TC.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     --AND TC.PED_FREQ_CD = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
     AND DECODE(TC.PED_FREQ_CD,'-','-0',TC.PED_FREQ_CD) = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM --MOD BY LIP 20241210
     --MOD BY LIP 20241210 医保卡的限制只取活期利率的数据
     AND (TC.BANK_INT_INT_RAT_TYPE_CD NOT IN ('YB') OR (TC.BANK_INT_INT_RAT_TYPE_CD = 'YB' AND TC.BASE_RAT_TYPE_ID = '2110'))
     AND TC.CURR_CD = TA.CURR_CD
     AND TC.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TC.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND TC.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TC.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TE --有存款期限的但是期限是日/月，且天数不固定的
      --ON TE.BANK_INT_INT_RAT_TYPE_CD = TB.INT_RAT_TYPE_CD
      ON TE.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     /*存款期限类型与基准利率对应：01-04对应活期基准利率；05-06对应定期三个月；07-08对应定期六个月；09-10对应定期一年；
       11-12对应定期二年；13-14对应定期三年；15-16对应定期5年*/
     AND TE.PED_FREQ_CD = CASE WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) = 0 THEN 'D0'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 90 THEN 'D0'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 180 THEN 'M3'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 360 THEN 'M6'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 720 THEN 'Y1'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 1080 THEN 'Y2'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 1800 THEN 'Y3'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') THEN 'Y5'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 3 THEN 'D0'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 6 THEN 'M3'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 12 THEN 'M6'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 24 THEN 'Y1'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 36 THEN 'Y2'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 60 THEN 'Y3'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' THEN 'Y5'
                           END
     AND TE.CURR_CD = TA.CURR_CD
     AND TE.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TE.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND TE.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TE.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TE.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TE.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP1 TF --无期限的，或者行内利率阶梯中只有一个配置数据的
      ON TF.CURR_CD = TA.CURR_CD
     AND TF.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     AND TF.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND DECODE(TF.PED_FREQ_CD,'-','-0',TF.PED_FREQ_CD) = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
     --AND TA.INT_ACCR_FLG = '1' --计息的
     /*AND TF.BANK_INT_INT_RAT_TYPE_CD = CASE WHEN NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' AND TA.STD_PROD_ID = '101010100001' THEN 'HQI'
                                            WHEN NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' AND TA.STD_PROD_ID = '103010200001' THEN 'HQB'
                                            WHEN NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' AND TA.STD_PROD_ID = '103010100001' THEN 'HQC'
                                            WHEN NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' AND TA.STD_PROD_ID = '101010200001' THEN 'HQV'
                                            ELSE NVL(TRIM(TB.INT_RAT_TYPE_CD),'-')
                                        END*/
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TG
      ON TG.CURR_CD = TF.CURR_CD
     AND TG.BANK_INT_INT_RAT_TYPE_CD = TF.BANK_INT_INT_RAT_TYPE_CD
     AND TG.PED_FREQ_CD = TF.PED_FREQ_CD
     AND TG.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TG.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND TG.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TG.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TG.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TG.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TD
      ON TD.BASE_RAT_ID = COALESCE(TC.BASE_RAT_TYPE_ID,TE.BASE_RAT_TYPE_ID,TG.BASE_RAT_TYPE_ID)
     AND TD.CURR_CD = TA.CURR_CD
     AND TD.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TD.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TJ --起息日在20120608之前的数据
      ON TJ.BASE_RAT_ID = COALESCE(TC.BASE_RAT_TYPE_ID,TE.BASE_RAT_TYPE_ID,TG.BASE_RAT_TYPE_ID)
     AND TJ.CURR_CD = TA.CURR_CD
     AND TJ.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')/*TA.VALUE_DT*/
     AND TJ.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')/*TA.VALUE_DT*/
     AND TA.VALUE_DT <= TO_DATE('20120608','YYYYMMDD')
     AND TJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TH
      ON TH.CURR_CD = TA.CURR_CD
     AND TH.BANK_INT_INT_RAT_TYPE_CD = 'XD1'
     AND TH.BASE_RAT_TYPE_ID = '2140'
     AND TH.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TH.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND TH.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TH.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TH.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TH.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TI
      ON TI.BASE_RAT_ID = '2140'
     AND TI.CURR_CD = TA.CURR_CD
     AND TI.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP C --码值映射表
      ON C.SRC_VALUE_CODE = TA.STD_PROD_ID
     AND C.SRC_CLASS_CODE = 'STD0001'
     AND C.TAR_CLASS_CODE = 'T0015'
     AND C.MOD_FLG = 'MDM'
   WHERE ((TA.CURR_CD = 'CNY' AND C.TAR_VALUE_CODE IN ('0501','0502'))
          OR (TA.VALUE_DT <= TO_DATE('20120608','YYYYMMDD') AND TA.STD_PROD_ID = '101020100002')) --起息日在配置表之前的
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --根据业务口径：非人民币活期部分按起息日的基准利率
  V_STEP := 4;
  V_STEP_DESC := '普通存款利率相关信息--非人民币活期部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_ACC_INFO_TEMP01
    ( ACC_ID_EAST               --账户编号_EAST
     ,ACC_ID                    --账户编号
     ,CUST_ACCT_SUB_ACCT_NUM    --客户账户子户号_新一代
     ,STD_PROD_ID               --标准产品代码
     ,ORG_ID                    --机构编号
     ,CUR                       --币种
     ,VAL_DT                    --起息日期
     ,INT_CALC_FLG              --计息标志
     ,INT_RAT_TYPE_CD           --利率类型代码
     ,BASE_RAT_ID               --基准利率编号
     ,BASE_RATE                 --基准利率
     ,MAX_FLOAT_POINT           --浮动点差上限
     ,AGREE_INT_RAT_TYPE_CD     --协定存款利率类型代码
     ,AGREE_BASE_RAT_ID         --协定存款基准利率编号
     ,AGREE_BASE_RATE           --协定存款基准利率
     ,AGREE_MAX_FLOAT_POINT     --协定存款浮动点差上限
     ,AGREE_DEP_FLG             --协定存款标志
     ,DEP_PED_FREQ_CD           --存款期限 --ADD BY LIP 20250512
     ,RNM                       --序号 --ADD BY LIP 20250513
    )
    WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/CURR_CD,BANK_INT_INT_RAT_TYPE_CD,ORG_ID,PED_FREQ_CD,COUNT(1)
      FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H
     WHERE EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       --AND INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
       AND INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY CURR_CD,BANK_INT_INT_RAT_TYPE_CD,ORG_ID,PED_FREQ_CD
    HAVING COUNT(1) = 1)
  SELECT  TA.ACCT_ID                                                            AS ACC_ID_EAST            --账户编号_EAST
         ,TA.CUST_ACCT_ID                                                       AS ACC_ID                 --账户编号
         ,TA.CUST_ACCT_SUB_ACCT_NUM                                             AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
         ,TA.STD_PROD_ID                                                        AS STD_PROD_ID            --标准产品代码
         ,TA.BELONG_ORG_ID                                                      AS ORG_ID                 --机构编号
         ,TA.CURR_CD                                                            AS CUR                    --币种
         ,TO_CHAR(TA.VALUE_DT,'YYYYMMDD')                                       AS VAL_DT                 --起息日期
         ,TA.INT_ACCR_FLG                                                       AS INT_CALC_FLG           --计息标志
         --NVL(REPLACE(TRIM(TB.INT_RAT_TYPE_CD),'-',''),TF.BANK_INT_INT_RAT_TYPE_CD) AS INT_RAT_TYPE_CD        --利率类型代码
         ,NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))                AS INT_RAT_TYPE_CD        --利率类型代码
         ,COALESCE(TC.BASE_RAT_TYPE_ID,TE.BASE_RAT_TYPE_ID,TG.BASE_RAT_TYPE_ID) AS BASE_RAT_ID            --基准利率编号
         ,TD.BASE_RAT                                                           AS BASE_RATE              --基准利率
         ,COALESCE(TC.MAX_FLOAT_POINT,TE.MAX_FLOAT_POINT,TG.MAX_FLOAT_POINT)    AS MAX_FLOAT_POINT        --浮动点差上限
         ,DECODE(TA.AGREE_DEP_FLG,'1','XD1')                                    AS AGREE_INT_RAT_TYPE_CD  --协定存款利率类型代码
         ,DECODE(TA.AGREE_DEP_FLG,'1','2140')                                   AS AGREE_BASE_RAT_ID      --协定存款基准利率编号
         ,DECODE(TA.AGREE_DEP_FLG,'1',TI.BASE_RAT)                              AS AGREE_BASE_RATE        --协定存款基准利率
         ,DECODE(TA.AGREE_DEP_FLG,'1',TH.MAX_FLOAT_POINT)                       AS AGREE_MAX_FLOAT_POINT  --协定存款浮动点差上限
         ,TA.AGREE_DEP_FLG                                                      AS AGREE_DEP_FLG          --协定存款标志
         ,TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM                              AS DEP_PED_FREQ_CD        --存款期限 --ADD BY LIP 20250512
         ,ROW_NUMBER() OVER(PARTITION BY TA.ACCT_ID ORDER BY 
             CASE WHEN TA.OPEN_ACCT_AMT - COALESCE(TC.LADR_AMT,TE.LADR_AMT,TG.LADR_AMT) >= 0
                  THEN TA.OPEN_ACCT_AMT - COALESCE(TC.LADR_AMT,TE.LADR_AMT,TG.LADR_AMT)
                  ELSE NULL
              END NULLS LAST,COALESCE(TC.EFFECT_DT,TE.EFFECT_DT,TG.EFFECT_DT) NULLS LAST) AS RNM --序号 --ADD BY LIP 20250513
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO TA
    LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL TB
      ON TB.ACCT_ID = TA.ACCT_ID
     AND TB.INT_CLS_CD = 'INT'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PRD_PROD_INT_RAT_INFO_H TJ --ADD BY LIP 20230825
      ON TJ.PROD_ID = TA.STD_PROD_ID
     AND (TB.INT_RAT_START_USE_WAY_CD = 'A' OR NVL(TRIM(TB.INT_RAT_TYPE_CD),'-') = '-' OR TA.STD_PROD_ID = '103010200001') --根据付钦良口径，A的取产品
     AND TJ.EVT_CATE_ID = 'OPEN'
     AND TJ.INT_CLS_CD = 'INT'
     AND TJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TC --有存款期限的
      --ON TC.BANK_INT_INT_RAT_TYPE_CD = TB.INT_RAT_TYPE_CD
      ON TC.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     --AND TC.PED_FREQ_CD = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
     AND DECODE(TC.PED_FREQ_CD,'-','-0',TC.PED_FREQ_CD) = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
     AND TC.CURR_CD = TA.CURR_CD
     AND TC.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TC.EFFECT_DT <= TA.VALUE_DT
     --AND TC.INVALID_DT > TA.VALUE_DT
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TC.INVALID_DT >= TA.VALUE_DT
     AND TC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TE --有存款期限的但是期限是日/月，且天数不固定的
      --ON TE.BANK_INT_INT_RAT_TYPE_CD = TB.INT_RAT_TYPE_CD
      ON TE.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     /*存款期限类型与基准利率对应：01-04对应活期基准利率；05-06对应定期三个月；07-08对应定期六个月；09-10对应定期一年；
       11-12对应定期二年；13-14对应定期三年；15-16对应定期5年*/
     AND TE.PED_FREQ_CD = CASE WHEN NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD)) = 'XYD' THEN '-' --ADD BY 20250113
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT = 0 THEN 'D0'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 90 THEN 'D0'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 180 THEN 'M3'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 360 THEN 'M6'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 720 THEN 'Y1'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 1080 THEN 'Y2'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' AND TA.EXP_DT - TA.VALUE_DT < 1800 THEN 'Y3'
                               WHEN TA.STD_PROD_ID = '103020700001' AND TA.DEP_TERM_TENOR_TYPE_CD||TA.DEP_TERM = '-0' THEN 'Y5'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) = 0 THEN 'D0'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 90 THEN 'D0'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 180 THEN 'M3'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 360 THEN 'M6'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 720 THEN 'Y1'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 1080 THEN 'Y2'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') AND TO_NUMBER(TA.DEP_TERM) < 1800 THEN 'Y3'
                               WHEN NVL(TRIM(TA.DEP_TERM_TENOR_TYPE_CD),'-') IN ('-','D') THEN 'Y5'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 3 THEN 'D0'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 6 THEN 'M3'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 12 THEN 'M6'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 24 THEN 'Y1'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 36 THEN 'Y2'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' AND TO_NUMBER(TA.DEP_TERM) < 60 THEN 'Y3'
                               WHEN TA.DEP_TERM_TENOR_TYPE_CD = 'M' THEN 'Y5'
                           END
     AND TE.CURR_CD = TA.CURR_CD
     AND TE.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TE.EFFECT_DT <= TA.VALUE_DT
     --AND TE.INVALID_DT > TA.VALUE_DT
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TE.INVALID_DT >= TA.VALUE_DT
     AND TE.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TE.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP1 TF --无期限的，或者行内利率阶梯中只有一个配置数据的
      ON TF.CURR_CD = TA.CURR_CD
     AND TF.BANK_INT_INT_RAT_TYPE_CD = NVL(TRIM(TJ.INT_RAT_TYPE_CD),TRIM(TB.INT_RAT_TYPE_CD))
     AND TF.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     --AND TF.PED_FREQ_CD = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
     AND DECODE(TF.PED_FREQ_CD,'-','-0',TF.PED_FREQ_CD) = TA.DEP_TERM_TENOR_TYPE_CD || TA.DEP_TERM
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TG
      ON TG.CURR_CD = TF.CURR_CD
     AND TG.BANK_INT_INT_RAT_TYPE_CD = TF.BANK_INT_INT_RAT_TYPE_CD
     AND TG.PED_FREQ_CD = TF.PED_FREQ_CD
     AND TG.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TG.EFFECT_DT <= TA.VALUE_DT
     --AND TG.INVALID_DT > TA.VALUE_DT
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TG.INVALID_DT >= TA.VALUE_DT
     AND TG.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TG.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TD
      ON TD.BASE_RAT_ID = COALESCE(TC.BASE_RAT_TYPE_ID,TE.BASE_RAT_TYPE_ID,TG.BASE_RAT_TYPE_ID)
     AND TD.CURR_CD = TA.CURR_CD
     AND TD.EFFECT_DT <= TA.VALUE_DT
     AND TD.INVALID_DT > TA.VALUE_DT
     AND TD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H TH
      ON TH.CURR_CD = TA.CURR_CD
     AND TH.BANK_INT_INT_RAT_TYPE_CD = 'XD1'
     AND TH.BASE_RAT_TYPE_ID = '2140'
     AND TH.ORG_ID = TA.BELONG_ORG_ID --ADD BY 20240607
     AND TH.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND TH.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND TH.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TH.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TH.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TI
      ON TI.BASE_RAT_ID = '2140'
     AND TI.CURR_CD = TA.CURR_CD
     AND TI.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TI.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_DEP_ACC_INFO_TEMP01 TEM --人民币活期部分
      ON TEM.ACC_ID_EAST = TA.ACCT_ID
     AND TEM.RNM = 1 --ADD BY LIP 20250513
   WHERE TEM.ACC_ID_EAST IS NULL
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  ETL_DBMS_STATS(V_P_DATE,'M_DEP_ACC_INFO_TEMP01','',O_ERRCODE); --表分析 --ADD BY LIP 20250513 对临时表进行表分析

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 5;
  V_STEP_DESC := '存款账户信息';
  V_STARTTIME := SYSDATE;
  /***存款分户信息***/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_ACC_INFO
    (DATA_DT                                  --数据日期
    ,LGL_REP_ID                               --法人编号
    ,ACC_ID                                   --账户编号
    ,CUST_ID                                  --客户编号
    ,ORG_ID                                   --机构编号
    ,CUR                                      --币种
    ,DEP_PROD_CD                              --存款产品代码
    ,DEP_PROD_TYP                             --存款产品类型
    ,VAL_DT                                   --起息日期
    ,DEP_BAL                                  --存款余额
    ,DEP_EXP_DT                               --存款到期日期
    ,CORP_IND_FLG                             --对公对私标志
    ,SUBJ_ID                                  --科目编号
    ,RATE                                     --利率
    ,OPEN_ACC_DT                              --开户日期
    ,OPEN_ACC_TLR_NO                          --开户柜员号
    ,CNL_ACC_DT                               --销户日期
    ,DEP_ACC_STAT                             --存款账户状态
    ,DEP_ACCT_STATUS_CD                       --存款账户状态原码值
    ,LAST_ACC_CHG_DT                          --上次动户日期
    ,CASH_REMIT_TYP                           --钞汇类型
    ,AGRT_DEP_PSN_TYP                         --协议存款人类型
    ,RATE_RE_PRC_DT                           --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG                  --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                             --可提前支取标志
    ,NTC_WD_DT                                --通知取款日期
    ,NTC_WD_AMT                               --通知取款金额
    ,CR_CRD_EX_PAY_FLG                        --信用卡溢缴款标志
    ,PBL_INT                                  --应付利息
    ,CO_DEP_TYP                               --单位存款类型
    ,DEP_INS_AMT                              --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                          --有业务关系存款金额
    ,TD_APVL_ACC_FLG                          --待核准账户标志
    ,INT_CALC_FLG                             --计息标志
    ,SPCL_DEP_TYP                             --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL                   --委托贷款基金细类
    ,CONSR_TYP                                --委托人类型
    ,IND_DMD_DEP_ACC_TYP                      --个人活期存款账户类型
    ,PBC_ACC_TYP                              --人行账户类型
    ,TIME_DMD_FLG                             --定活标志
    ,OPEN_ACC_CHAN                            --开户渠道
    ,PRC_BASE_TYP                             --定价基准类型
    ,RATE_TYP                                 --利率类型
    ,BASE_RATE                                --基准利率
    ,RATE_FLT_FREQ                            --利率浮动频率
    ,GUA_YLD                                  --保底收益率
    ,HIGH_YLD_RTO                             --最高收益率
    ,DIF_PLC_DEP_FLG                          --异地存款标志
    ,DEP_RSV_MODE                             --缴存准备金方式
    ,ACT_END_DT                               --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE                 --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                      --业务发生时点基准利率
    ,DEPT_LINE                                --部门条线
    ,DATA_SRC                                 --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                               --子账户编号
    ,ACC_ID_EAST                              --账户编号_EAST
    ,EAR_M_BAL                                --月初余额
    ,NEXT_INT_SET_DT                          --下次结息日期
    ,STD_PROD_ID                              --标准产品代码
    ,DEP_TERM                                 --存期
    ,IBANK_DEP_FLG                            --同业存款标志
    ,AGREE_DEP_EXP_DT                         --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG                            --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT                       --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT                       --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT                            --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT                        --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD                             --账户属性代码
    ,FROZ_FLG                                 --冻结标志
    ,ACCT_CARD_NO                             --客户账户卡号
    ,STOP_PAY_STATUS_CD                       --止付状态代码
    ,FROZ_DT                                  --冻结日期
    ,UNFRZ_DT                                 --解冻日期
    ,INIT_OPEN_ACCT_DT                        --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                              --原始到期日期  add by hulj 20221227
    ,C_DEPOSIT_TYPE                           --单位存款类型
    ,OVER_TERM_EXEC_INT_RAT                   --超期执行利率
    ,ACCT_MED                                 --账户介质
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    ,BASE_RATE_IMAS                           --基准利率_IMAS
    ,MAX_INT_RATE                             --最大利率
    ,INT_RAT_TYPE_CD                          --利率类型代码
    ,AGREE_BASE_RATE                          --协定存款基准利率
    ,AGREE_MAX_INT_RATE                       --协定存款最大利率
    ,BASE_RAT_ID                              --基准利率编号
    ,OLD_ACCT_ID                              --旧账户编号 --ADD BY LIP 20240618
    ,DEP_CASH_BAL                             --存款余额_含电子现金 -- ADD BY HYF 20241011
    ,HEAT_INSU_ACCT_FLG                       --是否医保账户标志   --ADD BY YJY 20241205
    ,CASH_MANAGE_FLG                          --是否现金管理类产品标志  --ADD BY YJY 20250210
    ,DEP_PED_FREQ_CD                          --存款期限 --ADD BY LIP 20250512
    ,CAP_CHAR_CD                              --资金性质代码 --ADD BY LYH 20260129
    )
  SELECT  /*+use_hash(a a1)*/ 
          TO_CHAR(A.ETL_DT,'YYYYMMDD')                       AS DATA_DT                  --数据日期
         ,A.LP_ID                                            AS LGL_REP_ID               --法人编号
         ,A.CUST_ACCT_ID                                     AS ACC_ID                   --账户编号
         ,A.CUST_ID                                          AS CUST_ID                  --客户编号
         ,A.BELONG_ORG_ID                                    AS ORG_ID                   --机构编号
         ,A.CURR_CD                                          AS CUR                      --币种
         ,A.STD_PROD_ID                                      AS DEP_PROD_CD              --存款产品代码 --MODIFY BY HULJ
         /*,CASE WHEN BZJ.BUSINESSTYPE = '601010100001' AND A.SUBJ_ID LIKE '2002%' THEN '0701'--银行承兑汇票保证金 --MOD BY HULJ 20230104 保证金类别
               WHEN BZJ.BUSINESSTYPE IN('601030100001','601030100007','601030200001') AND A.SUBJ_ID LIKE '2002%' THEN '0703'--保函保证金
               WHEN BZJ.BUSINESSTYPE IN('601020100001','601020100002','601020200001','601020200002') AND A.SUBJ_ID LIKE '2002%' THEN '0702'--信用证保证金
               WHEN A.SUBJ_ID LIKE '2002%' THEN '0799' --其他保证金*/
         ,CASE WHEN SUBSTR(HT.STD_PROD_ID,1,5) = '60101' AND A.SUBJ_ID LIKE '2002%' THEN '0701'--银行承兑汇票保证金 /*20230104 XUXIAOBIN ADD 保证金类别*/
               WHEN SUBSTR(HT.STD_PROD_ID,1,5) = '60103' AND A.SUBJ_ID LIKE '2002%' THEN '0703'--保函保证金
               WHEN SUBSTR(HT.STD_PROD_ID,1,5) = '60102' AND A.SUBJ_ID LIKE '2002%' THEN '0702'--信用证保证金
               WHEN A.SUBJ_ID LIKE '2002%' THEN '0799' --其他保证金
               WHEN A.SUBJ_ID IN ('20110101','20110201','20110210') --仅针对活期存款
                    AND A.AGREE_DEP_FLG LIKE '1' AND NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                    AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) <= 0
               THEN '0601'            --结算户存款
              /*WHEN A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
                     AND A.ACCT_CLS_CD IN ('11001','11002','11003','11004','21001','22002')
                     --基本存款账户,一般存款账户,临时存款账户,专用存款账户,个人人民币结算账户,个人外汇结算账户
                     AND A.AGREE_DEP_FLG = '1'  --ADD BY 20221124 xucx
              THEN '0601' --结算户存款   MODIFY BY MW 20221118*/
            /*WHEN A.SUBJ_ID IN( '20110101','20110201','20110210') --仅针对活期存款
                   AND A.AGREE_DEP_FLG = '1' THEN '0602' --协定户存款*/
              WHEN A.SUBJ_ID IN ('20110101','20110201','20110210') --仅针对活期存款
                   AND A.AGREE_DEP_FLG LIKE '1' AND (NVL(A.AGREE_DEP_INIT_AMT, 0) <> 0
                   AND (A.CURRT_BAL - NVL(A.AGREE_DEP_INIT_AMT, 0)) > 0)
              THEN '0602'            --协定户存款
              ELSE NVL(C.TAR_VALUE_CODE,A.STD_PROD_ID)
          END                                                AS DEP_PROD_TYP             --存款产品类型
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                     AS VAL_DT                   --起息日期
         ,A.CURRT_BAL                                        AS DEP_BAL                  --存款余额
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                       AS DEP_EXP_DT               --存款到期日期
         ,CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
               WHEN E.CUST_ID IS NOT NULL THEN '2'
           END                                               AS CORP_IND_FLG             --对公对私标志
         ,A.SUBJ_ID                                          AS SUBJ_ID                  --科目编号
         ,NVL(A.EXEC_INT_RAT, 0)                             AS RATE                     --利率
         ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')                 AS OPEN_ACC_DT              --开户日期
         ,TRIM(A.OPEN_ACCT_TELLER_ID)                        AS OPEN_ACC_TLR_NO          --开户柜员号
         ,CASE WHEN A.DEP_ACCT_STATUS_CD = 'C' AND TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231')
                    AND TO_CHAR(A.CLOS_ACCT_TM,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
               THEN TO_CHAR(A.CLOS_ACCT_TM,'YYYYMMDD') --MOD BY LIP 20240809 当账户状态是销户且销户日期为空时，用销户时间当为销户日期
               WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231') THEN '99991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
           END                                               AS CNL_ACC_DT               --销户日期
         ,NVL(TTA.TAR_VALUE_CODE,'99')                       AS DEP_ACC_STAT             --存款账户状态
         ,A.DEP_ACCT_STATUS_CD                               AS DEP_ACCT_STATUS_CD       --存款账户状态原码值
         ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD')          AS LAST_ACC_CHG_DT          --上次动户日期
         ,CASE WHEN A.EC_FLG = 'CA' THEN '02'--钞
               WHEN A.EC_FLG = 'TT' THEN '03'--汇
           END                                               AS CASH_REMIT_TYP           --钞汇类型
         ,G.AGT_DEP_TYPE_CD                                  AS AGRT_DEP_PSN_TYP         --协议存款人类型
         ,NULL                                               AS RATE_RE_PRC_DT           --利率重新定价日期
         ,NULL                                               AS INNR_ADV_EXP_OPTION_FLG  --内嵌提前到期期权标志
         ,A.ADVD_DRAW_FLG                                    AS ADV_DRAW_FLG             --可提前支取标志
         ,NULL                                               AS NTC_WD_DT                --通知取款日期
         ,NULL                                               AS NTC_WD_AMT               --通知取款金额
         ,NULL                                               AS CR_CRD_EX_PAY_FLG        --信用卡溢缴款标志
         --,NVL(A.CURRT_ACRU_INT,0)+NVL(A.CURRT_INT_PAYBL_ADJ,0) AS PBL_INT                --应付利息 --当期应计利息+当期应付利息调整
         ,NVL(A.CURRT_ACRU_INT,0)                            AS PBL_INT                   --应付利息 --当期应计利息 20231025
         ,CASE WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN (/*'1','2'*/'11','12','JJSB') --基金社保  --20231107hulj根据上游调整码值
               THEN 'C' --社保 --MOD BY YJY 20250928 修改存款性质代码，旧的1-社保基金-债券质押、2-社保基金-非债券质押改为11-社保基金-债券质押、12-社保基金-非债券质押
               WHEN /*E.DEPOSITR_CATE_CD = '103' AND*/ A.DEP_CHAR_CD IN(/*'3'*/'21','22','GJJ') --暂无公积金 --20231107hulj根据上游调整码值
               THEN 'E'   --住房公积金 --MOD BY YJY 20250928 修改存款性质代码，旧的3-住房公积金改为21-住房公积金-债券质押、22-住房公积金-非债券质押
               WHEN SUBSTR(A.SUBJ_ID,1,4) IN ( '2005' ,'2010' ,'3008') --2022/07/16 XUXIAOBIN MODIFY
               THEN 'F'   --财政性存款
               WHEN E.CUST_ID IS NOT NULL THEN 'A'    --企业存款
           END                                               AS CO_DEP_TYP               --单位存款类型 --20220920xuxiaobinadd
         ,NULL                                               AS DEP_INS_AMT              --被存款保险制度覆盖的金额
         ,NULL                                               AS BIZ_REL_DEP_AMT          --有业务关系存款金额
         ,NULL                                               AS TD_APVL_ACC_FLG          --待核准账户标志
         ,A.INT_ACCR_FLG                                     AS INT_CALC_FLG             --计息标志
         ,NULL                                               AS SPCL_DEP_TYP             --专项存款类型
         ,CASE WHEN A.SUBJ_ID LIKE '30070101%' --委托存款
               THEN '9012'
           END                                               AS ENTRS_LOAN_FUND_SUM_CL   --委托贷款基金细类
         ,NULL                                               AS CONSR_TYP                --委托人类型
         ,CASE WHEN A.ACCT_TYPE_CD IN ('1','2','3') THEN A.ACCT_TYPE_CD
               ELSE C.TAR_VALUE_CODE
           END                                               AS IND_DMD_DEP_ACC_TYP      --个人活期存款账户类型
         ,A.ACCT_CLS_CD                                      AS PBC_ACC_TYP              --人行账户类型
         ,A.RC_FLG                                           AS TIME_DMD_FLG             --定活标志
         ,A.OPEN_ACCT_CHN_TYPE_CD                            AS OPEN_ACC_CHAN            --开户渠道
         ,'TR09'                                             AS PRC_BASE_TYP             --定价基准类型 默认TR09：存款基准利率
         /*,CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
               ELSE '0' --浮动利率
           END                                               AS RATE_TYP                 --利率类型 默认固定利率*/
         ,'1'                                                AS RATE_TYP                 --利率类型 默认固定利率
         ,A.BASE_RAT                                         AS BASE_RATE                --基准利率
         ,'00'                                               AS RATE_FLT_FREQ            --利率浮动频率 固定利率不浮动
         ,NULL                                               AS GUA_YLD                  --保底收益率
         ,A.EXPE_HIGT_YLD_RAT                                AS HIGH_YLD_RTO             --最高收益率
         ,NULL                                               AS DIF_PLC_DEP_FLG          --异地存款标志
         ,'DR03'                                             AS DEP_RSV_MODE             --缴存准备金方式
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                       AS ACT_END_DT               --实际终止日期
         --,TO_CHAR(A1.EXEC_INT_RAT,'YYYYMMDD')              AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
         --,TO_CHAR(A1.VALUE_DT,'YYYYMMDD')                  AS BIZ_TMPNT_BASE_RATE      --业务发生时点基准利率
         /*,A1.EXEC_INT_RAT                                    AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
         ,A1.BASE_RAT                                        AS BIZ_TMPNT_BASE_RATE      --业务发生时点基准利率*/
         --MOD BY 20250114
         ,CASE WHEN A.VALUE_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN A.EXEC_INT_RAT
               WHEN A1.ACC_ID_EAST IS NOT NULL THEN A1.BIZ_OCCUR_TMPNT_ACT_RATE
           END                                               AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率
         ,CASE WHEN A.VALUE_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN A.BASE_RAT
               WHEN A1.ACC_ID_EAST IS NOT NULL THEN A1.BIZ_TMPNT_BASE_RATE
           END                                               AS BIZ_TMPNT_BASE_RATE      --业务发生时点基准利率
         ,NULL                                               AS DEPT_LINE                --部门条线 --计划财务部
         ,'普通存款'                                         AS DATA_SRC                 --数据来源
         ,A.CURRT_ACRU_INT                                   AS CRN_PRD_ACCRD_INT        --当期应计利息
         ,A.TD_ACRU_INT                                      AS INTDAY_ACCRD_INT         --当日应计利息
         ,A.APPROVAL_ID                                      AS APPROVAL_ID              --核准件编号
         ,A.CUST_TYPE_CD                                     AS CUST_TYP                 --客户类型
         ,NVL(TRIM(A.OLD_CUST_ACCT_SUB_ACCT_NUM),TRIM(A.CUST_ACCT_SUB_ACCT_NUM)) AS SUB_ACC_ID  --子账户编号20221102 XUXIAOBIN业务希望用回以前的
         ,A.ACCT_ID                                          AS ACC_ID_EAST              --账户编号_EAST
         ,A.EAR_M_BAL                                        AS EAR_M_BAL                --月初余额
         ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')              AS NEXT_INT_SET_DT          --下次结息日期
         ,A.STD_PROD_ID                                      AS STD_PROD_ID              --标准产品代码
         ,CASE WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('1Y','12M','365D')
               THEN '301' --一年
               WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('2Y','24M','730D')
               THEN '302' --二年
               WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('3Y','24M','1095D')
               THEN '303' --三年
               WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('5Y','60M')
               THEN '305' --五年
               WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('6Y','72M')
               THEN '306' --六年
               WHEN A.DEP_TERM||A.DEP_TERM_TENOR_TYPE_CD  IN ('8Y','96M')
               THEN '308' --8年
               ELSE '999'
           END                                               AS DEP_TERM                 --存期
         ,A.IBANK_DEP_FLG                                    AS IBANK_DEP_FLG            --同业存款标志
         ,TO_CHAR(A.AGREE_DEP_EXP_DT,'YYYYMMDD')             AS AGREE_DEP_EXP_DT         --协定存款到期日期(金数IMAS用)20221031 ADD
         ,A.AGREE_DEP_FLG                                    AS AGREE_DEP_FLG            --协定存款标志(金数IMAS用)20221031 ADD
         ,A.AGREE_DEP_INIT_AMT                               AS AGREE_DEP_INIT_AMT       --协定存款起存金额(金数IMAS用)20221031 ADD
         ,TO_CHAR(A.AGREE_DEP_VALUE_DT,'YYYYMMDD')           AS AGREE_DEP_VALUE_DT       --协定存款起息日期(金数IMAS用)20221031 ADD
         ,A.AGREE_INT_RAT                                    AS AGREE_INT_RAT            --协定利率(金数IMAS用)20221031 ADD
         ,TO_CHAR(A.AGREE_DEP_RELS_DT,'YYYYMMDD')            AS AGREE_DEP_RELS_DT        --协定存款解约日期(金数IMAS用)20221031 ADD
         ,G.FX_ACCT_CHAR_CD                                  AS ACCT_CHAR_CD             --账户属性代码
         ,A.FROZ_FLG                                         AS FROZ_FLG                 --冻结标志
         ,A.CUST_ACCT_CARD_NO                                AS ACCT_CARD_NO             --客户账户卡号
         ,A.STOP_PAY_STATUS_CD                               AS STOP_PAY_STATUS_CD       --止付状态代码
         ,TO_CHAR(A.FROZ_DT,'YYYYMMDD')                      AS FROZ_DT                  --冻结日期
         ,TO_CHAR(A.UNFRZ_DT,'YYYYMMDD')                     AS UNFRZ_DT                 --解冻日期
         ,TO_CHAR(G.INIT_OPEN_ACCT_DT,'YYYYMMDD')            AS INIT_OPEN_ACCT_DT        --原始开户日期  add by hulj 20221227
         ,TO_CHAR(G.INIT_EXP_DT,'YYYYMMDD')                  AS INIT_EXP_DT              --原始到期日期  add by hulj 20221227
         ,CASE 
               WHEN SUBSTR(COALESCE(E.SOCI_CRDT_CD,E.NATION_TAX_RGST_CERT_NUM,E.LOCAL_TAX_RGST_CERT_NUM,E.RGSTION_CD),0,2) IN ('N1','N2','N3') 
               THEN 'B'
               WHEN E.DEPOSITR_CATE_CD = '101' --企业法人
               THEN 'A'
               WHEN E.DEPOSITR_CATE_CD IN ('103','104','105','108','109','115') AND A.DEP_CHAR_CD IN ('CZCK','-',/*'4','5'*/'31','32','41')  --103 机关 3-其他财政性存款 4-其他--20231107hulj根据上游调整码值
               THEN 'B' --MOD BY YJY 20250928 修改存款性质代码，旧的4-其他财政性存款、5-其他改为31-其他财政性存款-债券质押、32-其他财政性存款-非债券质押、41-其他
               WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN (/*'1','2'*/'11','12','JJSB')   --'JJSB' 基金社保 1-社保基金 --20231107hulj根据上游调整码值
               THEN 'C' --MOD BY YJY 20250928 修改存款性质代码，旧的1-社保基金-债券质押、2-社保基金-非债券质押改为11-社保基金-债券质押、12-社保基金-非债券质押
               WHEN E.DEPOSITR_CATE_CD IN ('106','107')
               THEN 'D'
               WHEN A.DEP_CHAR_CD IN(/*'3'*/'21','22','GJJ') -- 2-公积金 --20231107hulj根据上游调整码值
               --MOD BY YJY 20250928 修改存款性质代码，旧的3-住房公积金改为21-住房公积金-债券质押、22-住房公积金-非债券质押
               THEN 'E'   --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
               WHEN E.CUST_ID IS NOT NULL THEN 'A'
           END                                               AS C_DEPOSIT_TYPE           --大集中单位存款类型
         ,A.OVER_TERM_EXEC_INT_RAT                           AS OVER_TERM_EXEC_INT_RAT   --超期执行利率
         ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6'  -- A存单
               WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5'  -- B折或一本通
               --WHEN H.VOUCH_FORM_CD = 'C' THEN '2'  -- C贷记卡 华兴无贷记卡
               WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1'  -- D借记卡
               WHEN H.VOUCH_FORM_CD IN('CHQ','CHK') THEN '4'  -- E支票
               ELSE '9'                             -- 其他
           END                                               AS ACCT_MED                 --账户介质
         ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1' ELSE '0' END AS LG_FROZ_FLG  --司法冻结标志
         ,A.CUST_ACCT_SUB_ACCT_NUM                           AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号_新一代
         /*,NVL(TE1.BASE_RATE,0)                               AS BASE_RATE_IMAS           --基准利率_IMAS
         ,NVL(TE1.BASE_RATE,0)+NVL(TE1.MAX_FLOAT_POINT,0)/100 AS MAX_INT_RATE            --最大利率*/
         ,COALESCE(TE1.BASE_RATE,A.BASE_RAT,0)               AS BASE_RATE_IMAS           --基准利率_IMAS
         ,COALESCE(TE1.BASE_RATE,A.BASE_RAT,0)+NVL(TE1.MAX_FLOAT_POINT,0)/100 AS MAX_INT_RATE            --最大利率
         ,TE1.INT_RAT_TYPE_CD                                AS INT_RAT_TYPE_CD          --利率类型代码
         ,NVL(TE1.AGREE_BASE_RATE,0)                         AS AGREE_BASE_RATE          --协定存款基准利率
         ,NVL(TE1.AGREE_BASE_RATE,0)+NVL(TE1.AGREE_MAX_FLOAT_POINT,0)/100 AS AGREE_MAX_INT_RATE  --协定存款最大利率
         ,TE1.BASE_RAT_ID                                    AS BASE_RAT_ID              --基准利率编号
         ,TRIM(A.OLD_ACCT_ID)                                AS OLD_ACCT_ID              --旧账户编号 --ADD BY LIP 20240618
         ,A.CURRT_BAL                                        AS DEP_CASH_BAL             --存款余额_含电子现金 -- ADD BY HYF 20241011
         ,CASE WHEN G.HEAT_INSU_ACCT_FLG = '1' THEN 'Y'
               ELSE 'N'
          END                                                AS HEAT_INSU_ACCT_FLG       --是否医保账户标志   -- ADD BY YJY 20241205
         ,CASE WHEN G.CASH_MANAGE_FLG = '1' THEN 'Y' 
               ELSE 'N'
          END                                                AS CASH_MANAGE_FLG          --是否现金管理类产品标志  --ADD BY YJY 20250210
         ,A.DEP_TERM_TENOR_TYPE_CD||A.DEP_TERM               AS DEP_PED_FREQ_CD          --存款期限 --ADD BY LIP 20250512
         ,G.CAP_CHAR_CD                                      AS CAP_CHAR_CD              --资金性质代码 --ADD BY LYH 20260129
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
   INNER/*LEFT*/ JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO G --存款账户附加信息 --MOD BY LIP 20241101
      ON G.ACCT_ID = A.ACCT_ID
     AND NVL(G.TRAVEL_CARD_ACCT_FLG,'0') = '0' --ADD BY LIP 20241101 过滤旅通卡数据
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO H --存款主账户信息
      ON H.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP C --码值映射表
      ON C.SRC_VALUE_CODE = A.STD_PROD_ID
     AND C.SRC_CLASS_CODE = 'STD0001'
     AND C.TAR_CLASS_CODE = 'T0015'
     AND C.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基础信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
    /*LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A1 --存款分户信息 取业务发生时点基准利率
      ON A1.ACCT_ID = A.ACCT_ID
     AND A1.ETL_DT = A.VALUE_DT*/
    LEFT JOIN RRP_MDL.M_DEP_ACC_INFO A1 --存款分户信息 取业务发生时点基准利率 --MOD BY 20250114 用上一天取到
      ON A1.ACC_ID_EAST = A.ACCT_ID
     AND A1.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD')
    /*20221104 许晓滨 ADD 区分保证金*/
    LEFT JOIN (SELECT BZJ.*,ROW_NUMBER()OVER(PARTITION BY BZJ.GRTEAC||BZJ.SUBACCOUNT ORDER BY EXCHANGEDATE,EXCHANGETIME DESC)RN
                 FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO BZJ
                WHERE BZJ.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BZJ.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TRIM(BZJ.GRTEAC) IS NOT NULL) BZJ--解冻保证金申请详情
      ON BZJ.GRTEAC = A.CUST_ACCT_ID
     AND BZJ.SUBACCOUNT = A.CUST_ACCT_SUB_ACCT_NUM
     AND BZJ.RN = 1
    /*LEFT JOIN (SELECT HT.*,ROW_NUMBER()OVER(PARTITION BY HT.CONT_ID ORDER BY HT.EXP_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO HT
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) HT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO HT
      ON HT.CONT_ID = BZJ.CONTRACTNO
     AND HT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND HT.RN = 1
    /*LEFT JOIN RRP_MDL.O_ICL_CMM_BA_ACCT_INFO D --银承账户信息
      ON D.BILL_NUM = DG.BILL_NUM
     AND D.ETL_DT = A.ETL_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO E --信用证账户信息
      ON E.LC_ID=DG.BILL_NUM
     AND E.ETL_DT = A.ETL_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO F --保函账户信息
      ON F.LOG_CONT_ID=DG.DUBIL_ID
     AND F.ETL_DT = A.ETL_DT*/
    LEFT JOIN (SELECT DISTINCT DEP_SUB_ACCT_ID
                 FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
                WHERE FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
                  AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
                  AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')--冻结截止日期
                  AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) DJ
      ON DJ.DEP_SUB_ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.M_DEP_ACC_INFO_TEMP01 TE1 --ADD BY LIP 20230731
      ON TE1.ACC_ID_EAST = A.ACCT_ID
     AND TE1.RNM = 1 --ADD BY LIP 20250513
   --科目筛选  20220901 XUXIAOBIN MODIFY
   WHERE (SUBSTR(A.SUBJ_ID,1,4) IN ('2011','2002','2010','2005','3007')) --2005 财政存款 2011 吸收存款（个人 对公） 2002 保证金 3007 委托存款
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 6;
  V_STEP_DESC := '插入存款账户信息-联合存款信息';
  V_STARTTIME := SYSDATE;
  /***联合存款分户信息***/
  INSERT INTO RRP_MDL.M_DEP_ACC_INFO
    (DATA_DT                            --数据日期
    ,LGL_REP_ID                         --法人编号
    ,ACC_ID                             --账户编号
    ,CUST_ID                            --客户编号
    ,ORG_ID                             --机构编号
    ,CUR                                --币种
    ,DEP_PROD_CD                        --存款产品代码
    ,DEP_PROD_TYP                       --存款产品类型
    ,VAL_DT                             --起息日期
    ,DEP_BAL                            --存款余额
    ,DEP_EXP_DT                         --存款到期日期
    ,CORP_IND_FLG                       --对公对私标志
    ,SUBJ_ID                            --科目编号
    ,RATE                               --利率
    ,OPEN_ACC_DT                        --开户日期
    ,OPEN_ACC_TLR_NO                    --开户柜员号
    ,CNL_ACC_DT                         --销户日期
    ,DEP_ACC_STAT                       --存款账户状态
    ,DEP_ACCT_STATUS_CD                 --存款账户状态原码值
    ,LAST_ACC_CHG_DT                    --上次动户日期
    ,CASH_REMIT_TYP                     --钞汇类型
    ,AGRT_DEP_PSN_TYP                   --协议存款人类型
    ,RATE_RE_PRC_DT                     --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG            --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                       --可提前支取标志
    ,NTC_WD_DT                          --通知取款日期
    ,NTC_WD_AMT                         --通知取款金额
    ,CR_CRD_EX_PAY_FLG                  --信用卡溢缴款标志
    ,PBL_INT                            --应付利息
    ,CO_DEP_TYP                         --单位存款类型
    ,DEP_INS_AMT                        --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                    --有业务关系存款金额
    ,TD_APVL_ACC_FLG                    --待核准账户标志
    ,INT_CALC_FLG                       --计息标志
    ,SPCL_DEP_TYP                       --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL             --委托贷款基金细类
    ,CONSR_TYP                          --委托人类型
    ,IND_DMD_DEP_ACC_TYP                --个人活期存款账户类型
    ,PBC_ACC_TYP                        --人行账户类型
    ,TIME_DMD_FLG                       --定活标志
    ,OPEN_ACC_CHAN                      --开户渠道
    ,PRC_BASE_TYP                       --定价基准类型
    ,RATE_TYP                           --利率类型
    ,BASE_RATE                          --基准利率
    ,RATE_FLT_FREQ                      --利率浮动频率
    ,GUA_YLD                            --保底收益率
    ,HIGH_YLD_RTO                       --最高收益率
    ,DIF_PLC_DEP_FLG                    --异地存款标志
    ,DEP_RSV_MODE                       --缴存准备金方式
    ,ACT_END_DT                         --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE           --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                --业务发生时点基准利率
    ,DEPT_LINE                          --部门条线
    ,DATA_SRC                           --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                          --子账户编号
    ,ACC_ID_EAST                         --账户编号_EAST
    ,EAR_M_BAL                           --月初余额
    ,NEXT_INT_SET_DT                     --下次结息日期
    ,STD_PROD_ID                         --标准产品编号
    ,DEP_TERM                            --存期
    ,IBANK_DEP_FLG                       --同业存款标志
    ,GD_PROV_INT_FLG                     --广东省内标志
    ,ACCT_CHAR_CD                        --账户属性代码
    ,FROZ_FLG                            --冻结标志
    ,ACCT_CARD_NO                        --客户账户卡号
    ,STOP_PAY_STATUS_CD                  --止付状态代码
    ,FROZ_DT                             --冻结日期
    ,UNFRZ_DT                            --解冻日期
    ,C_DEPOSIT_TYPE                      --大集中单位存款类型
    ,ACCT_MED                            --账户介质
    ,LG_FROZ_FLG                         --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM              --客户账户子户号_新一代
    ,BASE_RATE_IMAS                      --基准利率_IMAS
    ,MAX_INT_RATE                        --最大利率
    ,INT_RAT_TYPE_CD                     --利率类型代码
    ,AGREE_BASE_RATE                     --协定存款基准利率
    ,AGREE_MAX_INT_RATE                  --协定存款最大利率
    ,BASE_RAT_ID                         --基准利率编号
    ,DEP_CASH_BAL                        --存款余额_含电子现金 -- ADD BY HYF 20241011
    ,HEAT_INSU_ACCT_FLG                  --是否医保账户标志   --ADD BY YJY 20241205
    ,CASH_MANAGE_FLG                     --是否现金管理类产品标志  --ADD BY YJY 20250210
    ,DEP_PED_FREQ_CD                     --存款期限 --ADD BY LIP 20250512
    ,CAP_CHAR_CD                         --资金性质代码 --ADD BY LYH 20260129
    )
    WITH REF_BASE_RAT_H AS (
    SELECT /*+MATERIALIZE*/BASE_RAT_ID
           ,CURR_CD
           ,BASE_RAT
           ,ROW_NUMBER() OVER(PARTITION BY BASE_RAT_ID, CURR_CD ORDER BY EFFECT_DT DESC) RN
      FROM RRP_MDL.O_IML_REF_BASE_RAT_H
     WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
    REF_BANK_INT_LADR_H AS (
    SELECT  T.BASE_RAT_TYPE_ID AS BASE_RAT_ID
           ,T.BANK_INT_INT_RAT_TYPE_CD
           ,T.CURR_CD
           ,T.ORG_ID--MOD BY 20240607
           ,CASE WHEN T.BANK_INT_INT_RAT_TYPE_CD = 'HQI' THEN '20110210' --活期
                WHEN T.BANK_INT_INT_RAT_TYPE_CD = 'DR1' THEN '20110202' --定期
            END SUBJ_ID
           ,NVL(TA.BASE_RAT,0) BASE_RAT
           ,NVL(T.MAX_FLOAT_POINT,0) MAX_FLOAT_POINT
           ,NVL(TA.BASE_RAT,0) + NVL(T.MAX_FLOAT_POINT,0)/100 MAX_RAT
      FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H T
      LEFT JOIN REF_BASE_RAT_H TA
        ON TA.BASE_RAT_ID = T.BASE_RAT_TYPE_ID
       AND TA.CURR_CD = T.CURR_CD
       AND TA.RN = 1
     WHERE T.BASE_RAT_TYPE_ID IN ('2110','2124')
       AND T.BANK_INT_INT_RAT_TYPE_CD||T.PED_FREQ_CD IN ('HQI-','DR1Y1') --微众定期是一年期
       AND T.CURR_CD = 'CNY'
       AND T.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       --AND T.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
       AND T.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE HASH(A, B, C)*/
          TO_CHAR(A.ETL_DT,'YYYYMMDD')                          AS DATA_DT                --数据日期
         ,A.LP_ID                                                AS LGL_REP_ID             --法人编号
         ,A.CUST_ACCT_ID                                         AS ACC_ID                 --账户编号
         ,A.CUST_ID                                              AS CUST_ID                --客户编号
         --,KK.ORG_ID1                                           AS ORG_ID                   --机构编号
         ,A.OPEN_ACCT_ORG_ID                                     AS ORG_ID                 --机构编号
         ,A.CURR_CD                                              AS CUR                    --币种
         ,A.STD_PROD_ID                                          AS DEP_PROD_CD            --存款产品代码 --MODIFY BY HULJ  20221102
         ,NVL(C.TAR_VALUE_CODE,A.STD_PROD_ID)                    AS DEP_PROD_TYP           --存款产品类型
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                         AS VAL_DT                 --起息日期
         ,A.CURRT_BAL                                            AS DEP_BAL                --存款余额
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                           AS DEP_EXP_DT             --存款到期日期
         /*,DECODE(A.CORP_ACCT_FLG,'0','1','1','2', A.CORP_ACCT_FLG) AS CORP_IND_FLG --对公对私标志*/
         ,CASE WHEN D.CUST_ID IS NOT NULL THEN '1'
               WHEN F.CUST_ID IS NOT NULL THEN '2'
           END                                                   AS CORP_IND_FLG           --对公对私标志
         ,A.SUBJ_ID                                              AS SUBJ_ID                --科目编号
         ,NVL(A.EXEC_INT_RAT, 0)                                 AS RATE                   --利率
         ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')                    AS OPEN_ACC_DT            --开户日期
         ,TRIM(A.OPEN_ACCT_TELLER_ID)                            AS OPEN_ACC_TLR_NO        --开户柜员号
         ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231','29991231') THEN '99991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
           END                                                   AS CNL_ACC_DT             --销户日期
         /*0  销户 1  正常 2  冻结 -  未知 */
         ,CASE WHEN TTA.SRC_CLASS_CODE IS NOT NULL THEN NVL(TTA.TAR_VALUE_CODE,'99')
               WHEN A.DEP_ACCT_STATUS_CD = '1' THEN '01'
               WHEN A.DEP_ACCT_STATUS_CD = '2' THEN '04' --冻结
               WHEN A.DEP_ACCT_STATUS_CD = '0' THEN '02'
               ELSE '99'
           END                                                   AS DEP_ACC_STAT           --存款账户状态
         ,A.DEP_ACCT_STATUS_CD                                   AS DEP_ACCT_STATUS_CD     --存款账户状态原码值
         ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD')             AS LAST_ACC_CHG_DT        --上次动户日期
         ,'01'                                                   AS CASH_REMIT_TYP         --钞汇类型
         ,'Z'                                                    AS AGRT_DEP_PSN_TYP       --协议存款人类型 --联合存款无协议存款
         ,NULL                                                   AS RATE_RE_PRC_DT         --利率重新定价日期
         ,NULL                                                   AS INNR_ADV_EXP_OPTION_FLG--内嵌提前到期期权标志
         ,NULL                                                   AS ADV_DRAW_FLG           --可提前支取标志
         ,NULL                                                   AS NTC_WD_DT              --通知取款日期
         ,NULL                                                   AS NTC_WD_AMT             --通知取款金额
         ,NULL                                                   AS CR_CRD_EX_PAY_FLG      --信用卡溢缴款标志
         ,A.CURRT_ACRU_INT                                       AS PBL_INT                --应付利息
         --,'A'                                                    AS CO_DEP_TYP MD BY 20221112 XUCX   --单位存款类型
         ,CASE WHEN F.CUST_ID IS NOT NULL THEN 'A' END           AS CO_DEP_TYP             --单位存款类型
         ,NULL                                                   AS DEP_INS_AMT            --被存款保险制度覆盖的金额
         ,NULL                                                   AS BIZ_REL_DEP_AMT        --有业务关系存款金额
         ,NULL                                                   AS TD_APVL_ACC_FLG        --待核准账户标志
         ,NULL                                                   AS INT_CALC_FLG           --计息标志
         ,NULL                                                   AS SPCL_DEP_TYP           --专项存款类型
         ,NULL                                                   AS ENTRS_LOAN_FUND_SUM_CL --委托贷款基金细类
         ,NULL                                                   AS CONSR_TYP              --委托人类型
         ,CASE WHEN A.SAV_TYPE_CD = 'S01' THEN '9901' --2022/06/22 许晓滨 新增
               WHEN A.SAV_TYPE_CD = 'S02' THEN '9902'
           END                                                   AS IND_DMD_DEP_ACC_TYP  --个人活期存款账户类型 其他+活期储蓄户
         ,'9901'                                                 AS PBC_ACC_TYP          --人行账户类型
         ,A.RC_FLG                                               AS TIME_DMD_FLG         --定活标志
         ,A.OPEN_ACCT_CHN_CD                                     AS OPEN_ACC_CHAN        --开户渠道
         ,'TR09'                                                 AS PRC_BASE_TYP         --定价基准类型
         /*,CASE WHEN A.BASE_RAT_TYPE_CD = '4000' THEN '1' --固定利率
               ELSE '0' --浮动利率
           END                                                   AS RATE_TYP               --利率类型*/
         ,'1'                                                    AS RATE_TYP               --利率类型  --默认固定利率
         ,A.BASE_RAT                                             AS BASE_RATE              --基准利率
         ,'00'                                                   AS RATE_FLT_FREQ          --利率浮动频率--固定利率不浮动
         ,NULL                                                   AS GUA_YLD                --保底收益率
         ,NULL                                                   AS HIGH_YLD_RTO           --最高收益率
         ,NULL                                                   AS DIF_PLC_DEP_FLG        --异地存款标志
         ,'DR03'                                                 AS DEP_RSV_MODE           --缴存准备金方式
         ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')                     AS ACT_END_DT             --实际终止日期
         ,A1.EXEC_INT_RAT                                        AS BIZ_OCCUR_TMPNT_ACT_RATE --业务发生时点实际利率实际利率
         ,A1.BASE_RAT                                            AS BIZ_TMPNT_BASE_RATE    --业务发生时点基准利率基准利率
         ,NULL                                                   AS DEPT_LINE              --部门条线
         ,'联合存款'                                             AS DATA_SRC               --数据来源
         ,NULL                                                   AS CRN_PRD_ACCRD_INT
         ,NULL                                                   AS INTDAY_ACCRD_INT
         ,NULL                                                   AS APPROVAL_ID
         ,NULL                                                   AS CORE_ACC_TYP
         ,A.CUST_ACCT_SUB_ACCT_NUM                               AS SUB_ACC_ID             --子账户编号
         ,A.CUST_ACCT_ID || A.CUST_ACCT_SUB_ACCT_NUM             AS ACC_ID_EAST            --账户编号_EAST
         ,A.EAR_M_BAL                                            AS EAR_M_BAL              --月初余额
         ,TO_CHAR(A.NEXT_INT_SET_DT,'YYYYMMDD')                  AS NEXT_INT_SET_DT        --下次结息日期
         ,A.STD_PROD_ID                                          AS STD_PROD_ID            --标准产品编号
         ,A.DEP_TERM                                             AS DEP_TERM               --存期
         ,'0'                                                    AS IBANK_DEP_FLG          --同业存款标志
         ,T.GD_PROV_INT_FLG                                      AS GD_PROV_INT_FLG        --广东省内标志
         ,G.FX_ACCT_CHAR_CD                                      AS ACCT_CHAR_CD           --账户属性代码
         ,A.FROZ_STATUS_CD                                       AS FROZ_FLG               --冻结标志
         ,A.BIND_WEBANK_CARD_NO                                  AS ACCT_CARD_NO           --客户账户卡号
         ,A.STOP_PAY_STATUS_CD                                   AS STOP_PAY_STATUS_CD     --止付状态代码
         ,NULL                                                   AS FROZ_DT                --冻结日期
         ,NULL                                                   AS UNFRZ_DT               --解冻日期
         ,CASE WHEN F.DEPOSITR_CATE_CD = '101' THEN 'A'
               WHEN F.DEPOSITR_CATE_CD = '103' THEN 'B'
               WHEN F.DEPOSITR_CATE_CD IN ('106','107') THEN 'D'
               WHEN F.CUST_ID IS NOT NULL THEN 'A'  --MDF BY HAP 20210202只能是对公的有值，否则指标会统计个人部分的数据
           END                                                   AS C_DEPOSIT_TYPE         --大集中单位存款类型
         ,CASE WHEN H.VOUCH_FORM_CD = 'DCT' THEN '6'  -- A存单
               WHEN H.VOUCH_FORM_CD = 'PBK' THEN '5'  -- B折或一本通
               --WHEN H.VOUCH_FORM_CD = 'C' THEN '2'  -- C贷记卡 华兴无贷记卡
               WHEN H.VOUCH_FORM_CD = 'CRD' THEN '1'  -- D借记卡
               WHEN H.VOUCH_FORM_CD IN ('CHQ','CHK') THEN '4'  -- E支票
               ELSE '9' -- 其他
           END                                                   AS ACCT_MED               --账户介质
         ,NULL                                                   AS LG_FROZ_FLG            --司法冻结标志
         ,A.CUST_ACCT_SUB_ACCT_NUM                               AS CUST_ACCT_SUB_ACCT_NUM --客户账户子户号_新一代
         ,TB.BASE_RAT                                            AS BASE_RATE_IMAS         --基准利率_IMAS
         ,TB.MAX_RAT                                             AS MAX_INT_RATE           --最大利率
         ,TB.BANK_INT_INT_RAT_TYPE_CD                            AS INT_RAT_TYPE_CD        --利率类型代码
         ,0                                                      AS AGREE_BASE_RATE        --协定存款基准利率
         ,0                                                      AS AGREE_MAX_INT_RATE     --协定存款最大利率
         ,TB.BASE_RAT_ID                                         AS BASE_RAT_ID            --基准利率编号
         ,A.CURRT_BAL                                            AS DEP_CASH_BAL           --存款余额_含电子现金 -- ADD BY HYF 20241011
         ,'N'                                                    AS HEAT_INSU_ACCT_FLG     --是否医保账户标志   -- ADD BY YJY 20241205
         ,CASE WHEN G.CASH_MANAGE_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                                   AS CASH_MANAGE_FLG         --是否现金管理类产品标志  --ADD BY YJY 20250210
         ,A.DEP_TERM                                             AS DEP_PED_FREQ_CD         --存款期限 --ADD BY LIP 20250512
         ,G.CAP_CHAR_CD                                          AS CAP_CHAR_CD             --资金性质代码 --ADD BY LYH 20260129
    FROM RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO A  --联合存款分户信息
    LEFT JOIN (SELECT TT.*,ROW_NUMBER()OVER(PARTITION BY TT.CUST_ID ORDER BY TT.WEBANK_CARD_NO) RN
                 FROM RRP_MDL.O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL TT
                WHERE TT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T --微众存款账户IP核对明细
      ON T.WEBANK_CARD_NO = A.BIND_WEBANK_CARD_NO
     AND T.RN = 1
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = A.ACCT_INSTIT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO G --存款账户附加信息历史
      ON G.ACCT_ID = A.CUST_ACCT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO H --存款客户账户信息
      ON H.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP C --数仓码值映射表
      ON C.SRC_VALUE_CODE = A.STD_PROD_ID
     AND C.SRC_CLASS_CODE = 'STD0001'
     AND C.TAR_CLASS_CODE = 'T0015'
     AND C.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D
      ON D.CUST_ID = A.CUST_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F
      ON F.CUST_ID = A.CUST_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
      ON E.CD_VAL = A.DEP_ACCT_STATUS_CD
     AND E.CD_ID = 'CD1253' /*update by chenxl*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO A1 --联合存款分户信息 取业务发生时点基准利率和执行利率
      ON A1.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND A1.ETL_DT = A.VALUE_DT
    LEFT JOIN REF_BANK_INT_LADR_H TB
      ON TB.SUBJ_ID = A.SUBJ_ID
     AND TB.CURR_CD = A.CURR_CD
     AND TB.ORG_ID = A.OPEN_ACCT_ORG_ID --MOD BY 20240607
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
   WHERE A.SUBJ_ID IN ('20110210','20110202')--20110210 个人互联网取到活期存款 20110202 个人定期存款
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 7;
  V_STEP_DESC := '插入存款账户信息-电子现金账户';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_ACC_INFO
    (DATA_DT                                  --数据日期
    ,LGL_REP_ID                               --法人编号
    ,ACC_ID                                   --账户编号
    ,CUST_ID                                  --客户编号
    ,ORG_ID                                   --机构编号
    ,CUR                                      --币种
    ,DEP_PROD_CD                              --存款产品代码
    ,DEP_PROD_TYP                             --存款产品类型
    ,VAL_DT                                   --起息日期
    ,DEP_BAL                                  --存款余额
    ,DEP_EXP_DT                               --存款到期日期
    ,CORP_IND_FLG                             --对公对私标志
    ,SUBJ_ID                                  --科目编号
    ,RATE                                     --利率
    ,OPEN_ACC_DT                              --开户日期
    ,OPEN_ACC_TLR_NO                          --开户柜员号
    ,CNL_ACC_DT                               --销户日期
    ,DEP_ACC_STAT                             --存款账户状态
    ,DEP_ACCT_STATUS_CD                       --存款账户状态原码值
    ,LAST_ACC_CHG_DT                          --上次动户日期
    ,CASH_REMIT_TYP                           --钞汇类型
    ,AGRT_DEP_PSN_TYP                         --协议存款人类型
    ,RATE_RE_PRC_DT                           --利率重新定价日期
    ,INNR_ADV_EXP_OPTION_FLG                  --内嵌提前到期期权标志
    ,ADV_DRAW_FLG                             --可提前支取标志
    ,NTC_WD_DT                                --通知取款日期
    ,NTC_WD_AMT                               --通知取款金额
    ,CR_CRD_EX_PAY_FLG                        --信用卡溢缴款标志
    ,PBL_INT                                  --应付利息
    ,CO_DEP_TYP                               --单位存款类型
    ,DEP_INS_AMT                              --被存款保险制度覆盖的金额
    ,BIZ_REL_DEP_AMT                          --有业务关系存款金额
    ,TD_APVL_ACC_FLG                          --待核准账户标志
    ,INT_CALC_FLG                             --计息标志
    ,SPCL_DEP_TYP                             --专项存款类型
    ,ENTRS_LOAN_FUND_SUM_CL                   --委托贷款基金细类
    ,CONSR_TYP                                --委托人类型
    ,IND_DMD_DEP_ACC_TYP                      --个人活期存款账户类型
    ,PBC_ACC_TYP                              --人行账户类型
    ,TIME_DMD_FLG                             --定活标志
    ,OPEN_ACC_CHAN                            --开户渠道
    ,PRC_BASE_TYP                             --定价基准类型
    ,RATE_TYP                                 --利率类型
    ,BASE_RATE                                --基准利率
    ,RATE_FLT_FREQ                            --利率浮动频率
    ,GUA_YLD                                  --保底收益率
    ,HIGH_YLD_RTO                             --最高收益率
    ,DIF_PLC_DEP_FLG                          --异地存款标志
    ,DEP_RSV_MODE                             --缴存准备金方式
    ,ACT_END_DT                               --实际终止日期
    ,BIZ_OCCUR_TMPNT_ACT_RATE                 --业务发生时点实际利率
    ,BIZ_TMPNT_BASE_RATE                      --业务发生时点基准利率
    ,DEPT_LINE                                --部门条线
    ,DATA_SRC                                 --数据来源
    ,CRN_PRD_ACCRD_INT
    ,INTDAY_ACCRD_INT
    ,APPROVAL_ID
    ,CORE_ACC_TYP
    ,SUB_ACC_ID                               --子账户编号
    ,ACC_ID_EAST                              --账户编号_EAST
    ,EAR_M_BAL                                --月初余额
    ,NEXT_INT_SET_DT                          --下次结息日期
    ,STD_PROD_ID                              --标准产品代码
    ,DEP_TERM                                 --存期
    ,IBANK_DEP_FLG                            --同业存款标志
    ,AGREE_DEP_EXP_DT                         --协定存款到期日期(金数IMAS用)20221031 ADD
    ,AGREE_DEP_FLG                            --协定存款标志(金数IMAS用)20221031 ADD
    ,AGREE_DEP_INIT_AMT                       --协定存款起存金额(金数IMAS用)20221031 ADD
    ,AGREE_DEP_VALUE_DT                       --协定存款起息日期(金数IMAS用)20221031 ADD
    ,AGREE_INT_RAT                            --协定利率(金数IMAS用)20221031 ADD
    ,AGREE_DEP_RELS_DT                        --协定存款解约日期(金数IMAS用)20221031 ADD
    ,ACCT_CHAR_CD                             --账户属性代码
    ,FROZ_FLG                                 --冻结标志
    ,ACCT_CARD_NO                             --客户账户卡号
    ,STOP_PAY_STATUS_CD                       --止付状态代码
    ,FROZ_DT                                  --冻结日期
    ,UNFRZ_DT                                 --解冻日期
    ,INIT_OPEN_ACCT_DT                        --原始开户日期  add by hulj 20221227
    ,INIT_EXP_DT                              --原始到期日期  add by hulj 20221227
    ,LG_FROZ_FLG                              --司法冻结标志
    ,CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号_新一代
    ,BASE_RATE_IMAS                           --基准利率_IMAS
    ,MAX_INT_RATE                             --最大利率
    ,INT_RAT_TYPE_CD                          --利率类型代码
    ,AGREE_BASE_RATE                          --协定存款基准利率
    ,AGREE_MAX_INT_RATE                       --协定存款最大利率
    ,BASE_RAT_ID                              --基准利率编号
    ,DEP_CASH_BAL                             --存款余额_含电子现金 -- ADD BY HYF 20241011
    ,HEAT_INSU_ACCT_FLG                       --是否医保账户标志   --ADD BY YJY 20241205
    ,CASH_MANAGE_FLG                          --是否现金管理类产品标志  --ADD BY YJY 20250210
    ,DEP_PED_FREQ_CD                          --存款期限 --ADD BY LIP 20250512
    )
    WITH REF_BASE_RAT_H AS (
      SELECT /*+MATERIALIZE*/BASE_RAT_ID
             ,CURR_CD
             ,BASE_RAT
             ,ROW_NUMBER() OVER(PARTITION BY BASE_RAT_ID, CURR_CD ORDER BY EFFECT_DT DESC) RN
        FROM RRP_MDL.O_IML_REF_BASE_RAT_H
       WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE HASH(T1, T2, T3)*/
          V_P_DATE                                 AS DATA_DT                 --数据日期
         ,T1.LP_ID                                 AS LGL_REP_ID              --法人编号
         ,T1.CARD_NO                               AS ACC_ID                  --账户编号
         --,NVL(T2.CUST_ID,T3.CUST_ID)               CUST_ID                 --客户编号
         --MOD BY LIP 20230808改成从银行卡信息表取客户号
         ,COALESCE(T2.CUST_ID,T3.CUST_ID,G.CUST_ID) AS CUST_ID                 --客户编号
         --,T2.OPEN_ACCT_ORG_ID                      ORG_ID                  --机构编号
         --,T1.OPEN_ACCT_ORG_ID                      ORG_ID                  --机构编号 --MOD BY LIP 20230615
         ,NVL(T2.ACCT_BELONG_ORG_ID,T1.OPEN_ACCT_ORG_ID)                    
                                                   AS ORG_ID                  --机构编号 --MOD BY hyf 20241028
         ,T1.ELEC_CASH_ACCT_CURR_CD                AS CUR                     --币种
         ,'101010100004'                           AS DEP_PROD_CD             --存款产品代码
         ,'0502'                                   AS DEP_PROD_TYP            --存款产品类型--储蓄活期
         ,TO_CHAR(T1.APP_EFFECT_DT,'YYYYMMDD')     AS VAL_DT                  --起息日期
         ,T1.ELEC_CASH_ACCT_BAL                    AS DEP_BAL                 --存款余额
         ,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')    AS DEP_EXP_DT              --存款到期日期
         ,'1'                                      AS CORP_IND_FLG            --对公对私标志
         ,'20110201'                               AS SUBJ_ID                 --科目编号
         ,0                                        AS RATE                    --利率
         ,TO_CHAR(T1.ELEC_CASH_ACCT_OPEN_ACCT_DT,'YYYYMMDD')  AS OPEN_ACC_DT  --开户日期
         --,NULL                                     OPEN_ACC_TLR_NO         --开户柜员号
         --,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')    CNL_ACC_DT              --销户日期
         --MOD BY LIP 20230609 电子现金的取账户对应的开户柜员号和实际销户日期
         --,NVL(TRIM(T2.OPEN_ACCT_TELLER_ID),TRIM(T3.OPEN_ACCT_TELLER_ID)) OPEN_ACC_TLR_NO         --开户柜员号
         --MOD BY 20231115 部分换卡的取不到开户柜员号
         ,COALESCE(TRIM(T2.OPEN_ACCT_TELLER_ID),TRIM(T3.OPEN_ACCT_TELLER_ID),TRIM(G.CARD_ISS_TELLER_ID)) AS OPEN_ACC_TLR_NO         --开户柜员号
         ,TO_CHAR(T1.CLOS_ACCT_DT,'YYYYMMDD')      AS CNL_ACC_DT              --销户日期
         --,COD1.TAR_VALUE_CODE                     DEP_ACC_STAT            --存款账户状态
         --,T1.ELEC_CASH_ACCT_STATUS_CD             DEP_ACCT_STATUS_CD      --存款账户状态原码值
         --,'01'                                     DEP_ACC_STAT            --存款账户状态
         --,'A'                                      DEP_ACCT_STATUS_CD      --存款账户状态原码值
         --MOD BY LIP 20230615 当销户日期小于当前日期且流水号不为空的为正常，否则为销户
         ,CASE WHEN TRIM(T1.CLOS_ACCT_FLOW_NUM) IS NOT NULL AND TO_CHAR(T1.CLOS_ACCT_DT,'YYYYMMDD') <= V_P_DATE THEN '02'
               ELSE '01'
           END                                     AS DEP_ACC_STAT            --存款账户状态
         ,CASE WHEN TRIM(T1.CLOS_ACCT_FLOW_NUM) IS NOT NULL AND TO_CHAR(T1.CLOS_ACCT_DT,'YYYYMMDD') <= V_P_DATE THEN 'C'
               ELSE 'A'
           END                                     AS DEP_ACCT_STATUS_CD      --存款账户状态原码值
         ,NULL                                     AS LAST_ACC_CHG_DT         --上次动户日期
         ,'01'                                     AS CASH_REMIT_TYP          --钞汇类型
         ,NULL                                     AS AGRT_DEP_PSN_TYP        --协议存款人类型
         ,NULL                                     AS RATE_RE_PRC_DT          --利率重新定价日期
         ,NULL                                     AS INNR_ADV_EXP_OPTION_FLG --内嵌提前到期期权标志
         ,NULL                                     AS ADV_DRAW_FLG            --可提前支取标志
         ,NULL                                     AS NTC_WD_DT               --通知取款日期
         ,NULL                                     AS NTC_WD_AMT              --通知取款金额
         ,NULL                                     AS CR_CRD_EX_PAY_FLG       --信用卡溢缴款标志
         ,0                                        AS PBL_INT                 --应付利息
         ,NULL                                     AS CO_DEP_TYP              --单位存款类型
         ,NULL                                     AS DEP_INS_AMT             --被存款保险制度覆盖的金额
         ,NULL                                     AS BIZ_REL_DEP_AMT         --有业务关系存款金额
         ,NULL                                     AS TD_APVL_ACC_FLG         --待核准账户标志
         ,NULL                                     AS INT_CALC_FLG            --计息标志
         ,NULL                                     AS SPCL_DEP_TYP            --专项存款类型
         ,NULL                                     AS ENTRS_LOAN_FUND_SUM_CL  --委托贷款基金细类
         ,NULL                                     AS CONSR_TYP               --委托人类型
         ,'A3'                                     AS IND_DMD_DEP_ACC_TYP     --个人活期存款账户类型
         ,NULL                                     AS PBC_ACC_TYP             --人行账户类型
         --,NULL                                     TIME_DMD_FLG            --定活标志
         ,'0'                                      AS TIME_DMD_FLG            --定活标志 --MOD BY LIP 20230904
         --,NULL                                     OPEN_ACC_CHAN           --开户渠道
         --MOD BY 20240119
         ,COALESCE(TRIM(T2.OPEN_ACCT_CHN_CD),TRIM(T3.OPEN_ACCT_CHN_CD),TRIM(T2.OPEN_ACCT_CHN_CD)) AS OPEN_ACC_CHAN --开户渠道
         ,NULL                                     AS PRC_BASE_TYP            --定价基准类型
         ,'1'                                      AS RATE_TYP                --利率类型
         --,0                                        BASE_RATE               --基准利率
         ,NVL(T5.BASE_RAT,0)                       AS BASE_RATE               --基准利率
         ,NULL                                     AS RATE_FLT_FREQ           --利率浮动频率
         ,NULL                                     AS GUA_YLD                 --保底收益率
         ,NULL                                     AS HIGH_YLD_RTO            --最高收益率
         ,NULL                                     AS DIF_PLC_DEP_FLG         --异地存款标志
         ,'DR03'                                   AS DEP_RSV_MODE            --缴存准备金方式
         ,TO_CHAR(T1.APP_INVALID_DT,'YYYYMMDD')    AS ACT_END_DT              --实际终止日期
         ,0                                        AS BIZ_OCCUR_TMPNT_ACT_RATE--业务发生时点实际利率
         ,0                                        AS BIZ_TMPNT_BASE_RATE     --业务发生时点基准利率
         ,NULL                                     AS DEPT_LINE               --部门条线
         ,'电子现金账户'                           AS DATA_SRC                --数据来源
         ,NULL                                     AS CRN_PRD_ACCRD_INT
         ,NULL                                     AS INTDAY_ACCRD_INT
         ,NULL                                     AS APPROVAL_ID
         ,NULL                                     AS CORE_ACC_TYP
         ,T1.CARD_SER_NUM                          AS SUB_ACC_ID              --子账户编号
         ,T1.AGT_ID||CARD_SER_NUM                  AS ACC_ID_EAST             --账户编号_EAST
         ,NULL                                     AS EAR_M_BAL               --月初余额
         ,NULL                                     AS NEXT_INT_SET_DT         --下次结息日期
         ,'101010100004'                           AS STD_PROD_ID             --标准产品代码
         ,NULL                                     AS DEP_TERM                --存期
         ,NULL                                     AS IBANK_DEP_FLG           --同业存款标志
         ,NULL                                     AS AGREE_DEP_EXP_DT        --协定存款到期日期(金数IMAS用)20221031 ADD
         ,NULL                                     AS AGREE_DEP_FLG           --协定存款标志(金数IMAS用)20221031 ADD
         ,NULL                                     AS AGREE_DEP_INIT_AMT      --协定存款起存金额(金数IMAS用)20221031 ADD
         ,NULL                                     AS AGREE_DEP_VALUE_DT      --协定存款起息日期(金数IMAS用)20221031 ADD
         ,NULL                                     AS AGREE_INT_RAT           --协定利率(金数IMAS用)20221031 ADD
         ,NULL                                     AS AGREE_DEP_RELS_DT       --协定存款解约日期(金数IMAS用)20221031 ADD
         ,NULL                                     AS ACCT_CHAR_CD            --账户属性代码
         ,'0'                                      AS FROZ_FLG                --冻结标志
         ,T1.CARD_NO                               AS ACCT_CARD_NO            --客户账户卡号
         ,'0'                                      AS STOP_PAY_STATUS_CD      --止付状态代码
         ,NULL                                     AS FROZ_DT                 --冻结日期
         ,NULL                                     AS UNFRZ_DT                --解冻日期
         ,NULL                                     AS INIT_OPEN_ACCT_DT       --原始开户日期  add by hulj 20221227
         ,NULL                                     AS INIT_EXP_DT             --原始到期日期  add by hulj 20221227
         ,NULL                                     AS LG_FROZ_FLG             --司法冻结标志
         ,T1.CARD_SER_NUM                          AS CUST_ACCT_SUB_ACCT_NUM  --客户账户子户号_新一代
         --ADD BY LIP 20230803
         ,NVL(T5.BASE_RAT,0)                       AS BASE_RATE_IMAS          --基准利率_IMAS
         ,NVL(T5.BASE_RAT,0)+NVL(T4.MAX_FLOAT_POINT,0)/100 AS MAX_INT_RATE    --最大利率
         ,NVL(T4.BANK_INT_INT_RAT_TYPE_CD,0)       AS INT_RAT_TYPE_CD         --利率类型代码
         ,0                                        AS AGREE_BASE_RATE         --协定存款基准利率
         ,0                                        AS AGREE_MAX_INT_RATE      --协定存款最大利率
         ,T4.BASE_RAT_TYPE_ID                      AS BASE_RAT_ID             --基准利率编号
         ,T6.CURRT_BAL                             AS DEP_CASH_BAL            --存款余额_含电子现金 -- ADD BY HYF 20241011
         ,'N'                                      AS HEAT_INSU_ACCT_FLG      --是否医保账户标志   --ADD BY YJY 20241205
         ,'N'                                      AS CASH_MANAGE_FLG         --是否现金管理类产品标志  --ADD BY YJY 20250210
         ,'-0'                                     AS DEP_PED_FREQ_CD         --存款期限 --ADD BY LIP 20250512
    FROM RRP_MDL.O_IML_AGT_IC_CARD_ELEC_CASH_ACCT_H T1 --IC卡电子现金账户历史
    /*LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY T.CUST_ACCT_CARD_NO ORDER BY T.CUST_ACCT_SUB_ACCT_NUM) RN
                 FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO  T
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T2 --存款分户信息
      ON T2.CUST_ACCT_CARD_NO = T1.CARD_NO
     AND T2.RN = 1*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T2 --存款客户账户信息
      ON T2.CUST_ACCT_CARD_NO = T1.CARD_NO
     AND TRIM(T2.CUST_ACCT_CARD_NO) IS NOT NULL
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T3 --存款客户账户信息
      ON T3.CUST_ACCT_ID = T1.CARD_NO
     AND TRIM(T3.CUST_ACCT_ID) IS NOT NULL
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --MOD BY LIP 20230808 改成关联银行卡表取客户号
    LEFT JOIN RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO G --银行卡基本信息表
      ON G.CARD_NO = T1.CARD_NO
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP COD1 --账户状态转码
      ON COD1.SRC_VALUE_CODE = T1.ELEC_CASH_ACCT_STATUS_CD
     AND COD1.SRC_CLASS_CODE = 'CD2554'
     AND COD1.TAR_CLASS_CODE = 'Z0018'
     AND COD1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_REF_BANK_INT_LADR_H T4 --取活期的浮动利率 --ADD BY LIP 20230803
      ON T4.CURR_CD = T1.ELEC_CASH_ACCT_CURR_CD
     AND T4.BANK_INT_INT_RAT_TYPE_CD = 'HQI'
     AND T4.BASE_RAT_TYPE_ID = '2110'
     AND T4.ORG_ID = T1.OPEN_ACCT_ORG_ID --MOD BY 20240607
     AND T4.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     --AND T4.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     --MOD BY 20231206 20231208版本核心更新这个字段的历史拉链数据
     AND T4.INVALID_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN REF_BASE_RAT_H T5 --取活期的基准利率
      ON T5.BASE_RAT_ID = T4.BASE_RAT_TYPE_ID
     AND T5.CURR_CD = T4.CURR_CD
     AND T5.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_ELEC_CASH_ACCT T6
      ON T6.CUST_ACCT_CARD_NO = T1.CARD_NO
     AND T6.CUST_ACCT_SUB_ACCT_ID = T1.CARD_SER_NUM
     AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')     
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260302 更新电子现金开户柜员为空的数据
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '更新开户柜员为空的数据';
  MERGE INTO (SELECT * FROM RRP_MDL.M_DEP_ACC_INFO WHERE OPEN_ACC_TLR_NO IS NULL AND DATA_DT = V_P_DATE) T
  USING (SELECT * FROM RRP_MDL.M_DEP_ACC_INFO WHERE OPEN_ACC_TLR_NO IS NOT NULL 
            AND DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD')) TA
     ON (T.ACC_ID_EAST = TA.ACC_ID_EAST)
   WHEN MATCHED THEN UPDATE SET
  T.OPEN_ACC_TLR_NO = TA.OPEN_ACC_TLR_NO;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '查询数据是否重复';
    WITH TMP1 AS (
  SELECT DATA_DT,ACC_ID_EAST,COUNT(1)
    FROM RRP_MDL.M_DEP_ACC_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ACC_ID_EAST
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_SQLMSG  := 'M_DEP_ACC_INFO表DATA_DT,ACC_ID_EAST数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '程序跑批结束';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_DEP_ACC_INFO;
/

