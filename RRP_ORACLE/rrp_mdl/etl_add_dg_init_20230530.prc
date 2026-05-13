CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_INIT_20230530(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
程序名称：ETL_ADD_DG_001_CUST，程序名称：ETL_ADD_DG_003_MONEY
  *  功能描述：补录表-对公-客户基表/账务基表初始化29号业务补录数据。
  ***************************************************************************/
   AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                      -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                            -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100)  := 'ETL_ADD_DG_INIT_20230530';  -- 程序名称
  V_TABLE_NAME  VARCHAR2(30)   := 'ADD_DG_001_CUST';      -- 报表名称
  V_PART_NAME   VARCHAR2(100);                            -- 分区名称
  V_P_DATE      VARCHAR2(8);                              -- 跑批数据日期
  V_STARTTIME   DATE;                                     -- 处理开始时间
  V_ENDTIME     DATE;                                     -- 处理结束时间
  V_SQLCOUNT    INTEGER        := 0;                      -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                            -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                             -- 来源系统

   BEGIN
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_STEP      := 1;
  V_STEP_DESC := '删除当期临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_001_CUST_L';
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_001_CUST';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 2;
  V_STEP_DESC := '备份客户补录表0530数据';
  V_STARTTIME := SYSDATE;


  INSERT INTO ADD_DG_001_CUST_L
  (
    DATA_DATE            --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --04 客户唯一码
   ,KHMC                --05 客户名称
   ,ZJLX                --06 证件类型
   ,ZJHM                --07 证件号码
   ,SFGTQY              --09 是否关停企业
   ,BXCDJMFYLB          --11 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --13 来源系统
  )
  SELECT
          V_P_DATE            --01 数据日期
         ,ACCT_ORG_NUM        --02 账务机构编号
         ,KHWYM               --04 客户唯一码
         ,KHMC                --05 客户名称
         ,ZJLX                --06 证件类型
         ,ZJHM                --07 证件号码
         ,SFGTQY              --09 是否关停企业
         ,BXCDJMFYLB          --11 本行承担/减免费用类別
         ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
         ,SYS_SOURCE          --13 来源系统
  FROM
  ( SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_SOURCE DESC) RN
           FROM ADD_DG_001_CUST A
          WHERE A.DATA_DATE = '20230530'
   )T
   WHERE T.RN = 1
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 3;
  V_STEP_DESC := '表继承0529业务补录数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'ALTER TABLE ADD_DG_001_CUST TRUNCATE PARTITION PARTITION_20230530';
  INSERT INTO ADD_DG_001_CUST
  (
    DATA_DATE            --01 数据日期
   ,ACCT_ORG_NUM        --02 账务机构编号
   ,KHWYM               --04 客户唯一码
   ,KHMC                --05 客户名称
   ,ZJLX                --06 证件类型
   ,ZJHM                --07 证件号码
   ,SFGTQY              --09 是否关停企业
   ,BXCDJMFYLB          --11 本行承担/减免费用类別
   ,BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
   ,SYS_SOURCE          --13 来源系统
  )
  SELECT
          V_P_DATE              DATA_DATE           --01 数据日期
         ,T1.ACCT_ORG_NUM       KHWYM               --02 账务机构编号
         ,T1.KHWYM              KHWYM               --04 客户唯一码
         ,T1.KHMC               KHMC                 --05 客户名称
         ,T1.ZJLX               ZJLX                 --06 证件类型
         ,T1.ZJHM               ZJHM                --07 证件号码
         ,COALESCE(T3.SFGTQY,T2.SFGTQY,T1.SFGTQY)
                                  SFGTQY              --09 是否关停企业
         ,COALESCE(T3.BXCDJMFYLB,T2.BXCDJMFYLB,T1.BXCDJMFYLB)
                                 BXCDJMFYLB          --11 本行承担/减免费用类別
         ,COALESCE(T2.BNLJCDHJMDXDXGFYJE,T3.BNLJCDHJMDXDXGFYJE,T1.BNLJCDHJMDXDXGFYJE)
                                 BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
         ,T1.SYS_SOURCE          SYS_SOURCE          --13 来源系统
       FROM   RRP_MDL.ADD_DG_001_CUST_L T1
  LEFT JOIN   (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                FROM RRP_MDL.ADD_DG_001_CUST_ETL A
                WHERE A.DATA_DATE = '20230529') T2
       ON T1.KHWYM = T2.KHWYM
       AND T2.RN = 1
  LEFT JOIN (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                FROM RRP_MDL.ADD_DG_001_CUST_ETL A
                WHERE A.DATA_DATE = '20230530') T3
       ON T1.KHWYM = T2.KHWYM
       AND T3.RN = 1
  WHERE T1.DATA_DATE = '20230530'
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP      := 4;
  V_STEP_DESC := '备份对公账务补录表0530数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE ADD_DG_003_MONEY_L';
  INSERT INTO ADD_DG_003_MONEY_L NOLOGGING
     (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE,        --01 数据日期,
           ACCT_ORG_NUM,    --02 账务机构编号,
           JYWYM,           --03 交易唯一码,
           ZHWYM,           --04 账户唯一码,
           KHWYM,           --05 客户唯一码,
           KHMC,            --06 客户名称,
           PJBH,            --07 票据编号,
           JBJGMC,          --08 经办机构名称,
           JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
           ZWJGMC,          --10 账务机构名称,
           ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
           TXGTJCYML,       --12 投向高技术产业门类,
           SFTXGJSCY,       --13 是否投向高技术产业,
           TXGJSZZYDLMC,    --14 投向高技术制造业大类,
           GJSCYMC,         --15 高技术产业名称,
           SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
           ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
           TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
           SZJJHXCYMC,      --19 数字经济核心产业名称,
           TXZLXXXCYML,     --20 投向战略性新兴产业门类,
           ZYXXXCYMC,       --21 战略性新兴产业名称,
           SFTXWHCYDL,      --22 是否投向文化产业大类,
           WHCYMC,          --23 文化产业名称,
           SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
           SFYSHZ,          --25 是否银税合作,
           SFNYCYHLTQY,     --26 是否农业产业化龙头企业
           SFYQ,            --27 是否延期,
           SYS_SOURCE,      --28 来源系统,
           SFGXRBZ,         --29 是否关系人保证,
           KHZBKHJLKHH,     --30 客户主办客户经理客户号,
           KHZBGYH,         --31 客户主办柜员号,
           KHZBKHJLMC,      --32 客户主办客户经理名称,
           KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
           JJZBKHJLH,       --34 借据主办客户经理号,
           JJZBGYH,         --35 借据主办柜员号,
           JJZBKHJLMC,      --36 借据主办客户经理名称,
           JJZBKHJLSSJG     --37 借据主办客户经理所属机构
      FROM (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.JYWYM ORDER BY A.SYS_SOURCE DESC) RN
              FROM ADD_DG_003_MONEY A
             WHERE A.DATA_DATE =  '20230530'
            ) T
    WHERE T.RN = 1
    ;
    V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 5;
  V_STEP_DESC := '表继承0529业务补录数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'ALTER TABLE ADD_DG_001_CUST TRUNCATE PARTITION PARTITION_20230530';
   INSERT INTO ADD_DG_003_MONEY NOLOGGING
    (
       DATA_DATE,       --01 数据日期,
       ACCT_ORG_NUM,    --02 账务机构编号,
       JYWYM,           --03 交易唯一码,
       ZHWYM,           --04 账户唯一码,
       KHWYM,           --05 客户唯一码,
       KHMC,            --06 客户名称,
       PJBH,            --07 票据编号,
       JBJGMC,          --08 经办机构名称,
       JBJGJGSZXZQHDM,  --09 经办机构机构所在行政区划代码,
       ZWJGMC,          --10 账务机构名称,
       ZWJGJGSZXZQHDM,  --11 账务机构机构所在行政区划代码,
       TXGTJCYML,       --12 投向高技术产业门类,
       SFTXGJSCY,       --13 是否投向高技术产业,
       TXGJSZZYDLMC,    --14 投向高技术制造业大类,
       GJSCYMC,         --15 高技术产业名称,
       SFTXZSCQMJXCY,   --16 是否投向知识产权密集型产业,
       ZSCQMJXCYMC,     --17 知识产权密集型产业名称,
       TXSZJJHXCYDL,    --18 投向数字经济核心产业大类,
       SZJJHXCYMC,      --19 数字经济核心产业名称,
       TXZLXXXCYML,     --20 投向战略性新兴产业门类,
       ZYXXXCYMC,       --21 战略性新兴产业名称,
       SFTXWHCYDL,      --22 是否投向文化产业大类,
       WHCYMC,          --23 文化产业名称,
       SFGYQYJSGZSJDK,  --24 是否工业企业技术改造升级贷款,
       SFYSHZ,          --25 是否银税合作,
       SFNYCYHLTQY,     --26 是否农业产业化龙头企业
       SFYQ,            --27 是否延期,
       SYS_SOURCE,      --28 来源系统,
       SFGXRBZ,         --29 是否关系人保证,
       KHZBKHJLKHH,     --30 客户主办客户经理客户号,
       KHZBGYH,         --31 客户主办柜员号,
       KHZBKHJLMC,      --32 客户主办客户经理名称,
       KHZBKHJLSSJG,    --33 客户主办客户经理所属机构,
       JJZBKHJLH,       --34 借据主办客户经理号,
       JJZBGYH,         --35 借据主办柜员号,
       JJZBKHJLMC,      --36 借据主办客户经理名称,
       JJZBKHJLSSJG     --37 借据主办客户经理所属机构
    )
    SELECT /*+ PARALLEL*/
           V_P_DATE                                                        AS DATA_DATE         --01 数据日期
          ,T1.ACCT_ORG_NUM                                                 AS ACCT_ORG_NUM      --02 账务机构编号
          ,T1.JYWYM                                                        AS JYWYM             --03 交易唯一码
          ,T1.ZHWYM                                                        AS ZHWYM             --04 账户唯一码
          ,T1.KHWYM                                                        AS KHWYM             --05 客户唯一码
          ,T1.KHMC                                                         AS KHMC              --06 客户名称
          ,T1.PJBH                                                         AS PJBH              --07 票据编号
          ,T1.JBJGMC                                                       AS JBJGMC            --08 经办机构名称
          ,T1.JBJGJGSZXZQHDM                                               AS JBJGJGSZXZQHDM    --09 经办机构机构所在行政区划代码
          ,T1.ZWJGMC                                                       AS ZWJGMC            --10 账务机构名称
          ,T1.ZWJGJGSZXZQHDM                                               AS ZWJGJGSZXZQHDM    --11 账务机构机构所在行政区划代码
          ,COALESCE(TRIM(T2.TXGTJCYML),T3.TXGTJCYML,T1.TXGTJCYML)                AS TXGTJCYML         --12 投向高技术产业门类
          ,COALESCE(TRIM(T2.SFTXGJSCY),T3.SFTXGJSCY,T1.SFTXGJSCY)                AS SFTXGJSCY         --13 是否投向高技术产业
          ,COALESCE(TRIM(T2.TXGJSZZYDLMC),T3.TXGJSZZYDLMC,T1.TXGJSZZYDLMC)       AS TXGJSZZYDLMC      --14 投向高技术制造业大类
          ,COALESCE(TRIM(T2.GJSCYMC),T3.GJSCYMC,T1.GJSCYMC)                      AS GJSCYMC           --15 高技术产业名称
          ,COALESCE(TRIM(T2.SFTXZSCQMJXCY),T3.SFTXZSCQMJXCY,T1.SFTXZSCQMJXCY)    AS SFTXZSCQMJXCY     --16 是否投向知识产权密集型产业
          ,COALESCE(TRIM(T2.ZSCQMJXCYMC),T3.ZSCQMJXCYMC,T1.ZSCQMJXCYMC)          AS ZSCQMJXCYMC       --17 知识产权密集型产业名称
          ,COALESCE(TRIM(T2.TXSZJJHXCYDL),T3.TXSZJJHXCYDL,T1.TXSZJJHXCYDL)       AS TXSZJJHXCYDL      --18 投向数字经济核心产业大类
          ,COALESCE(TRIM(T2.SZJJHXCYMC),T3.SZJJHXCYMC,T1.SZJJHXCYMC)             AS SZJJHXCYMC        --19 数字经济核心产业名称
          ,COALESCE(TRIM(T2.TXZLXXXCYML),T3.TXZLXXXCYML,T1.TXZLXXXCYML)          AS TXZLXXXCYML       --20 投向战略性新兴产业门类
          ,COALESCE(TRIM(T2.ZYXXXCYMC),T3.ZYXXXCYMC,T1.ZYXXXCYMC)                AS ZYXXXCYMC         --21 战略性新兴产业名称
          ,COALESCE(TRIM(T2.SFTXWHCYDL),T3.SFTXWHCYDL,T1.SFTXWHCYDL)             AS SFTXWHCYDL        --22 是否投向文化产业大类
          ,COALESCE(TRIM(T2.WHCYMC),T3.WHCYMC,T1.WHCYMC)                         AS WHCYMC            --23 文化产业名称
          ,COALESCE(TRIM(T2.SFGYQYJSGZSJDK),T3.SFGYQYJSGZSJDK,T1.SFGYQYJSGZSJDK) AS SFGYQYJSGZSJDK    --24 是否工业企业技术改造升级贷款
          ,COALESCE(TRIM(T2.SFYSHZ),T3.SFYSHZ,T1.SFYSHZ)                         AS SFYSHZ            --25 是否银税合作
          ,COALESCE(TRIM(T2.SFNYCYHLTQY),T3.SFNYCYHLTQY,T1.SFNYCYHLTQY)          AS SFNYCYHLTQY       --26 是否农业产业化龙头企业
          ,COALESCE(TRIM(T2.SFYQ),T3.SFYQ,T1.SFYQ)                               AS SFYQ              --27 是否延期
          ,COALESCE(TRIM(T2.SYS_SOURCE),T3.SYS_SOURCE,T1.SYS_SOURCE)             AS SYS_SOURCE        --28 来源系统
          ,COALESCE(TRIM(T2.SFGXRBZ),T3.SFGXRBZ,T1.SFGXRBZ)                      AS SFGXRBZ           --29 是否关系人保证
          ,COALESCE(TRIM(T2.KHZBKHJLKHH),T3.KHZBKHJLKHH,T1.KHZBKHJLKHH)          AS KHZBKHJLKHH       --30 客户主办客户经理客户号
          ,COALESCE(TRIM(T2.KHZBGYH),T3.KHZBGYH,T1.KHZBGYH)                      AS KHZBGYH           --31 客户主办柜员号
          ,COALESCE(TRIM(T2.KHZBKHJLMC),T3.KHZBKHJLMC,T1.KHZBKHJLMC)             AS KHZBKHJLMC        --32 客户主办客户经理名称
          ,COALESCE(TRIM(T2.KHZBKHJLSSJG),T3.KHZBKHJLSSJG,T1.KHZBKHJLSSJG)       AS KHZBKHJLSSJG      --33 客户主办客户经理所属机构
          ,COALESCE(TRIM(T2.JJZBKHJLH),T3.JJZBKHJLH,T1.JJZBKHJLH)                AS JJZBKHJLH         --34 借据主办客户经理号
          ,COALESCE(TRIM(T2.JJZBGYH),T3.JJZBGYH,T1.JJZBGYH)                      AS JJZBGYH           --35 借据主办柜员号
          ,COALESCE(TRIM(T2.JJZBKHJLMC),T3.JJZBKHJLMC,T1.JJZBKHJLMC)             AS JJZBKHJLMC        --36 借据主办客户经理名称
          ,COALESCE(TRIM(T2.JJZBKHJLSSJG),T3.JJZBKHJLSSJG,T1.JJZBKHJLSSJG)       AS JJZBKHJLSSJG      --37 借据主办客户经理所属机构
      FROM ADD_DG_003_MONEY_L T1    --当天跑批数据
      LEFT JOIN  (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                FROM RRP_MDL.ADD_DG_003_MONEY_ETL A
                WHERE A.DATA_DATE = '20230530') T2
           ON T1.JYWYM = T2.JYWYM
           AND T2.RN = 1
     LEFT JOIN  (SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                FROM RRP_MDL.ADD_DG_003_MONEY_ETL A
                WHERE A.DATA_DATE = '20230529') T3
            ON T1.JYWYM = T3.JYWYM
            AND T3.RN = 1
      WHERE T1.DATA_DATE = '20230530'
      ;
     V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

      V_STEP      := 6;
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

END ETL_ADD_DG_INIT_20230530;
/

