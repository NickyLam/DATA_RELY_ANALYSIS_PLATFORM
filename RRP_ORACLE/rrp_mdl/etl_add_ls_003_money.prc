CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_LS_003_MONEY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_LS_003_MONEY
  *  功能描述：补录表-零售-账务基表。
  *  创建日期：20221220
  *  开发人员：liuyu
  *  来源表：  ICL.CMM_RETL_LOAN_ACCT_INFO  --零售贷款账户信息表
  *            ICL.CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息表
               ICL.CMM_RETL_LOAN_CONT_INFO  --零售贷款合同信息表
               ICL.CMM_INDV_CUST_BASIC_INFO --个人客户基本信息表
               ICL.CMM_STD_PROD_INFO --贷款产品信息表
               RRP_MDL.CODE_MAP  --码值映射表(贷款类型)
  *  目标表：  ADD_LS_003_MONEY  -零售-账务基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221220  liuyu    首次创建。
  *             2    20230530  liuyu    调整继承上天数据逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                        -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                              -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30)   := 'ETL_ADD_LS_003_MONEY';   -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_LS_003_MONEY';       -- 报表名称
  V_PART_NAME   VARCHAR2(100);                              -- 分区名称
  V_P_DATE      VARCHAR2(8);                                -- 跑批数据日期
  V_STARTTIME   DATE;                                       -- 处理开始时间
  V_ENDTIME     DATE;                                       -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                        -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                              -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                               -- 来源系统
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_LS_003_MONEY_L';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_LS_003_MONEY';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

 /***备份当期数据***/
  INSERT INTO ADD_LS_003_MONEY_L
  (  DATA_DATE       --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
  )
  SELECT
     V_P_DATE        --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
  FROM (
    SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_OPER_DATE DESC) RN
    FROM ADD_LS_003_MONEY_ETL A
    WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_LS_003_MONEY_ETL)
       ) T
  WHERE T.RN = 1
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 3;
  V_STEP_DESC := '备份当期数据-从ADD表继承';
  V_STARTTIME := SYSDATE;

 /***备份当期数据***/
  INSERT INTO ADD_LS_003_MONEY_L
  (  DATA_DATE       --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
  )
  SELECT
     V_P_DATE        --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
      FROM RRP_MDL.ADD_LS_003_MONEY T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_LS_003_MONEY_L T2
                        WHERE T1.JYWYM = T2.JYWYM
                          AND T2.DATA_DATE = V_P_DATE)
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



   -- 支持重跑 --
  V_STEP      := 3;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  --DELETE FROM ADD_LS_003_MONEY T WHERE T.DATA_DATE = V_P_DATE;--普通表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 4;
  V_STEP_DESC := '处理数据-插入临时表';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP_ADD_LS_003_MONEY NOLOGGING
  (  DATA_DATE       --01 数据日期
    ,ACCT_ORG_NUM    --02 账务机构编号
    ,JYWYM           --03 交易唯一码
    ,ZHWYM           --04 账户唯一码
    ,KHWYM           --05 客户唯一码
    ,KHMC            --06 客户名称
    ,DKYWPZMC        --07 贷款业务品种名称
    ,TJYE            --08 统计余额（元）
    ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
    ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
  )
  SELECT /*+ PARALLEL(A,4) */
         V_P_DATE                                   AS DATA_DATE       --01 数据日期
        ,A.ACCT_INSTIT_ID                           AS ACCT_ORG_NUM    --02 账务机构编号
        ,A.DUBIL_NUM                                AS JYWYM           --03 交易唯一码
        ,A.CONT_ID                                  AS ZHWYM           --04 账户唯一码
        ,A.CUST_ID                                  AS KHWYM           --05 客户唯一码
        ,F.CUST_NAME                                AS KHMC            --06 客户名称
        ,C.PROD_NAME                                AS DKYWPZMC        --07 贷款业务品种名称
        ,A.CURRT_BAL                                AS TJYE            --08 统计余额（元）
        ,F.CORP_BL_INDUTY_TYPE_CD                   AS SSGMJJHYXLDM    --09 所属国民经济行业小类代码  补录字段，可置空，继承上一天数据
        ,B.DIR_INDUS_CD                             AS TXGMJJXYXLDM    --10 投向国民经济行业小类代码  补录字段，可置空，继承上一天数据
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
      ON B.DUBIL_ID = A.DUBIL_NUM
     AND B.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO  C    --标准产品信息
      ON C.PROD_ID = A.STD_PROD_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA  --零售贷款合同信息表
      ON TA.CONT_ID = A.CONT_ID
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON B.STD_PROD_ID = TTA.SRC_VALUE_CODE
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'    --监管集市明细层
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F --个人客户基本信息
      ON F.CUST_ID = A.CUST_ID
     AND F.ETL_DT  = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.CURRT_BAL > 0 --余额大于0
     AND (NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID) LIKE '0102%' --个人经营贷款区分
          OR (A.STD_PROD_ID IN ('201030100001','201030100002') -- 个人商用房
                AND TA.BORW_USAGE_TYPE_CD = '100301' ))
     AND (TRIM(B.DIR_INDUS_CD) IS NULL
          OR TRIM(B.DIR_INDUS_CD) = '-'
          OR TRIM(B.DIR_INDUS_CD) LIKE '%@%'
          OR TRIM(F.CORP_BL_INDUTY_TYPE_CD) IS NULL
          OR TRIM(F.CORP_BL_INDUTY_TYPE_CD) = '-'
          OR TRIM(F.CORP_BL_INDUTY_TYPE_CD) LIKE '%@%'
          OR TRIM(F.CORP_BL_INDUTY_TYPE_CD) = 'Z') --为空或非国标的个人经营性贷款
     AND A.WRT_OFF_FLG <> '1' --剔除核销
     AND A.SUBJ_ID NOT LIKE '8106%' --剔除转让
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 5;
  V_STEP_DESC := '处理数据-插入目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_LS_003_MONEY
      (
         DATA_DATE       --01 数据日期
        ,ACCT_ORG_NUM    --02 账务机构编号
        ,JYWYM           --03 交易唯一码
        ,ZHWYM           --04 账户唯一码
        ,KHWYM           --05 客户唯一码
        ,KHMC            --06 客户名称
        ,DKYWPZMC        --07 贷款业务品种名称
        ,TJYE            --08 统计余额（元）
        ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
        ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
      )
  SELECT /*+ PARALLEL(A,4) */
       V_P_DATE                                            AS DATA_DATE           --01 数据日期
      ,T1.ACCT_ORG_NUM                                     AS ACCT_ORG_NUM        --02 账务机构编号
      ,T1.JYWYM                                            AS JYWYM               --03 交易唯一码
      ,T1.ZHWYM                                            AS ZHWYM               --04 账户唯一码
      ,T1.KHWYM                                            AS KHWYM               --05 客户唯一码
      ,T1.KHMC                                             AS KHMC                --06 客户名称
      ,T1.DKYWPZMC                                         AS DKYWPZMC            --07 贷款业务品种名称
      ,T1.TJYE                                             AS TJYE                --08 统计余额（元）
      ,COALESCE(T2.SSGMJJHYXLDM,T3.SSGMJJHYXLDM,T1.SSGMJJHYXLDM)
                                                           AS SSGMJJHYXLDM        --09 所属国民经济行业小类代码
      ,COALESCE(T2.TXGMJJXYXLDM,T3.TXGMJJXYXLDM,T1.TXGMJJXYXLDM)
                                                           AS TXGMJJXYXLDM        --10 投向国民经济行业小类代码
       FROM TMP_ADD_LS_003_MONEY T1  -- 当天跑批数据
       LEFT JOIN ADD_LS_003_MONEY_L T2 --当天补录后数据
            ON T1.JYWYM = T2.JYWYM
       LEFT JOIN (SELECT T.*
                       FROM ADD_LS_003_MONEY_ETL T
                      WHERE T.DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_LS_003_MONEY_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
                    ) T3            --上一天数据
            ON T1.JYWYM = T3.JYWYM
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

/*   V_STEP      := 6;
   V_STEP_DESC := '处理数据-上一期数据插入目标表';
   V_STARTTIME := SYSDATE;

    INSERT INTO ADD_LS_003_MONEY
   (
         DATA_DATE       --01 数据日期
        ,ACCT_ORG_NUM    --02 账务机构编号
        ,JYWYM           --03 交易唯一码
        ,ZHWYM           --04 账户唯一码
        ,KHWYM           --05 客户唯一码
        ,KHMC            --06 客户名称
        ,DKYWPZMC        --07 贷款业务品种名称
        ,TJYE            --08 统计余额（元）
        ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
        ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   )
   SELECT
         V_P_DATE        --01 数据日期
        ,ACCT_ORG_NUM    --02 账务机构编号
        ,JYWYM           --03 交易唯一码
        ,ZHWYM           --04 账户唯一码
        ,KHWYM           --05 客户唯一码
        ,KHMC            --06 客户名称
        ,DKYWPZMC        --07 贷款业务品种名称
        ,TJYE            --08 统计余额（元）
        ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
        ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   FROM ADD_LS_003_MONEY_ETL A
   WHERE A.DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_LS_003_MONEY_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
   AND NOT EXISTS (SELECT 1 FROM ADD_LS_003_MONEY T WHERE T.DATA_DATE = V_P_DATE AND A.JYWYM = T.JYWYM)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/
   /*V_STEP      := 7;
   V_STEP_DESC := '处理数据-当期增加的数据插入目标表';
   V_STARTTIME := SYSDATE;

    INSERT INTO ADD_LS_003_MONEY
   (
         DATA_DATE       --01 数据日期
        ,ACCT_ORG_NUM    --02 账务机构编号
        ,JYWYM           --03 交易唯一码
        ,ZHWYM           --04 账户唯一码
        ,KHWYM           --05 客户唯一码
        ,KHMC            --06 客户名称
        ,DKYWPZMC        --07 贷款业务品种名称
        ,TJYE            --08 统计余额（元）
        ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
        ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   )
   SELECT
         V_P_DATE        --01 数据日期
        ,ACCT_ORG_NUM    --02 账务机构编号
        ,JYWYM           --03 交易唯一码
        ,ZHWYM           --04 账户唯一码
        ,KHWYM           --05 客户唯一码
        ,KHMC            --06 客户名称
        ,DKYWPZMC        --07 贷款业务品种名称
        ,TJYE            --08 统计余额（元）
        ,SSGMJJHYXLDM    --09 所属国民经济行业小类代码
        ,TXGMJJXYXLDM    --10 投向国民经济行业小类代码
   FROM ADD_LS_003_MONEY_L A
   WHERE NOT EXISTS (SELECT 1 FROM ADD_LS_003_MONEY T WHERE T.DATA_DATE = V_P_DATE AND A.JYWYM = T.JYWYM)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/
   V_STEP      := 8;
   V_STEP_DESC := '增加表分析及跑批过程完成表';
   V_STARTTIME := SYSDATE;

     --表分析
     ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PART_NAME, O_ERRCODE);
     --插入过程跑批完成记录表
     INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
     VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 数据重复校验 --
  WITH TMP1 AS (
    SELECT DATA_DATE,JYWYM,COUNT(1)
      FROM RRP_MDL.ADD_LS_003_MONEY T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,JYWYM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

   -- 程序跑批结束记录 --
   V_STEP      := 9;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
EXCEPTION
   WHEN OTHERS THEN
     V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE   := '1';
     V_ENDTIME   := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_LS_003_MONEY;
/

