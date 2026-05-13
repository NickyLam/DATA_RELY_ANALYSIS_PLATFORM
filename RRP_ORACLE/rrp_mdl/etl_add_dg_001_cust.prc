CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_DG_001_CUST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_DG_001_CUST
  *  功能描述：补录表-对公-客户基表。
  *  创建日期：20221213
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息表
  *            IML.PTY_IBANK_CUST_CHAT_INFO  --同业客户特有信息
  *            IML.PTY_PARTY_CERT_INFO_H     --当事人证件信息历史
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  ADD_DG_001_CUST  --客户基表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221114  hulj     首次创建。
  *   2    20230426  Liuyu    删除当天新增数据,客户补录表不接收新增客户条数补录
  *   3    20230512  liuyu    调整只保留报告期余额客户和当年放款客户
  *   4    20230530  liuyu    调整继承上天数据逻辑
  *   5    20230531  liuyu    数据重复，添加重复提示
  *   6    20230612  liuyu    调整客户下发补录机构逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER        := 0;                      -- 处理步骤
  V_STEP_DESC   VARCHAR2(100);                            -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100)  := 'ETL_ADD_DG_001_CUST';  -- 程序名称
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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_ADD_DG_001_CUST';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := 2;
  V_STEP_DESC := '备份当期数据-从ETL表继承';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_001_CUST_L
  (
    DATA_DATE           --01 数据日期
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
         ,COALESCE(T.ACCT_ORG_NUM,TRIM(T2.BELONG_ORG_ID),T2.OPEN_ACCT_ORG_ID) 	--02 账务机构编号
         ,T.KHWYM               --04 客户唯一码
         ,T.KHMC                --05 客户名称
         ,T.ZJLX                --06 证件类型
         ,T.ZJHM                --07 证件号码
         ,T.SFGTQY              --09 是否关停企业
         ,T.BXCDJMFYLB          --11 本行承担/减免费用类別
         ,T.BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
         ,T.SYS_SOURCE          --13 来源系统
    FROM (
         SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
           FROM ADD_DG_001_CUST_ETL A
          WHERE A.DATA_DATE = (SELECT MAX(DATA_DATE) FROM ADD_DG_001_CUST_ETL)
         ) T
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T2
     ON T.KHWYM = T2.CUST_ID
    AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.RN = 1;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 3;
   V_STEP_DESC := '备份当期数据-从ADD表继承';
   V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_001_CUST_L
  (
    DATA_DATE           --01 数据日期
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
      FROM RRP_MDL.ADD_DG_001_CUST T1
     WHERE T1.DATA_DATE = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') --取前一天数据
       AND NOT EXISTS (SELECT 1
                         FROM RRP_MDL.ADD_DG_001_CUST_L T2
                        WHERE T1.KHWYM = T2.KHWYM
                          AND T2.DATA_DATE = V_P_DATE)
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 支持重跑 --
  V_STEP      := 4;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);--增加当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  V_STEP      := 5;
  V_STEP_DESC := '处理数据-跑批数据插入临时表';
  V_STARTTIME := SYSDATE;

  INSERT INTO TMP_ADD_DG_001_CUST NOLOGGING
  (
    DATA_DATE           --01 数据日期
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
  WITH TMP AS
  (SELECT /*+ materialize*/ PARTY_ID,CERT_TYPE_CD,CERT_NUM FROM (
    SELECT /*+ materialize*/
               TT.PARTY_ID
              ,TT.CERT_TYPE_CD
              ,TT.CERT_NUM
              ,ROW_NUMBER() OVER(PARTITION BY TT.PARTY_ID ORDER BY (CASE WHEN TT.CERT_TYPE_CD = '2313' AND LENGTH(TT.CERT_NUM)=18 THEN 1
                                                                         WHEN TT.CERT_TYPE_CD = '2072' AND LENGTH(TT.CERT_NUM)=18 THEN 2 --2072-地税登记证,根据3证合一，没有统一信用证先取税务登记证
                                                                         WHEN TT.CERT_TYPE_CD = '2071' AND LENGTH(TT.CERT_NUM)=18 THEN 3 --2071-国税登记证,根据3证合一，没有统一信用证先取税务登记证
                                                                         WHEN TT.CERT_TYPE_CD = '2020' THEN 4
                                                                         WHEN TT.CERT_TYPE_CD = '2090' THEN 5
                                                                         WHEN TT.CERT_TYPE_CD = '2999' THEN 6
                                                                    END
                                                                   ) ASC,TT.SORC_SYS_CD DESC, TT.START_DT DESC) RN   --金数优先级为2313>2020>2090>2999
             FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H TT  --当事人证件信息历史
            INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B  --对公客户基本信息表
               ON TT.PARTY_ID = B.CUST_ID
              AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            WHERE TT.CERT_NUM IS NOT NULL
              AND TT.CERT_NUM <> '******'
              AND TT.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              AND TT.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') )
            WHERE RN = 1 )
  ,TMP01 AS (
              SELECT /*+ materialize*/ CUST_ID 
                FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款账户信息
               WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND (A.STD_PROD_ID LIKE '203%' OR A.STD_PROD_ID LIKE '204%' /*OR A.STD_PROD_ID LIKE '6%'*/)
                 AND (A.DISTR_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') OR A.DUBIL_BAL <> 0)
               GROUP BY CUST_ID )
  SELECT /*+USE_HASH(T1 T2 T3)*/
         V_P_DATE                                                  AS DATA_DATE           --01 数据日期
        ,CASE WHEN T1.CUST_ID IN ('5000024671','5000003354','5000008743','5000019808','5000035650') THEN '805001'
              WHEN T1.BELONG_ORG_ID LIKE '800993%' THEN '801001'
              ELSE NVL(TRIM(T1.BELONG_ORG_ID),T1.OPEN_ACCT_ORG_ID)
         END                                                       AS ACCT_ORG_NUM        --02 账务机构编号
        ,T1.CUST_ID                                                AS KHWYM               --04 客户唯一码
        ,T1.CUST_NAME                                              AS KHMC                --05 客户名称
        ,CASE WHEN T3.CERT_TYPE_CD = '2313' THEN '236' --236-统一信用证代码
              WHEN T3.CERT_TYPE_CD IN ('2071','2072') AND LENGTH(T3.CERT_NUM) = 18 THEN '236'
              WHEN T3.CERT_TYPE_CD = '2020' THEN '21'  --21-组织机构代码证
              WHEN T3.CERT_TYPE_CD = '2090' THEN '2F'  --2F-金融许可证
              WHEN T3.CERT_TYPE_CD = '2999' THEN '2X'  --2X-其他
         END                                                       AS ZJLX                --06 证件类型
        ,REPLACE(T3.CERT_NUM,'-','')                               AS ZJHM                --07 证件号码
        ,CASE WHEN T1.CUST_ID = '5000050641' THEN 'N'             -- 该客户默认为'N'
              WHEN T1.CORP_CLOSE_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                                       AS SFGTQY              --09 是否关停企业
        ,NULL                                                      AS BXCDJMFYLB          --11 本行承担/减免费用类別
        ,NULL                                                      AS BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元）
        ,'对公'                                                    AS SYS_SOURCE          --13 来源系统
   FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T1 --对公客户基本信息表
  INNER JOIN TMP01 T2
     ON T2.CUST_ID = T1.CUST_ID
   LEFT JOIN TMP T3
     ON T3.PARTY_ID = T1.CUST_ID
  WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := 6;
  V_STEP_DESC := '处理数据-插入目标表';
  V_STARTTIME := SYSDATE;

  INSERT INTO ADD_DG_001_CUST
  (
    DATA_DATE           --01 数据日期
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
        V_P_DATE                                            AS DATA_DATE           --01 数据日期
       ,CASE WHEN T1.ACCT_ORG_NUM IN ('801001','805001') THEN T1.ACCT_ORG_NUM
             WHEN COALESCE(T2.ACCT_ORG_NUM,T3.ACCT_ORG_NUM,T1.ACCT_ORG_NUM)  = '800958866'  THEN '891'
             ELSE COALESCE(T2.ACCT_ORG_NUM,T3.ACCT_ORG_NUM,T1.ACCT_ORG_NUM)
        END                                                 AS ACCT_ORG_NUM        --02 账务机构编号
       ,T1.KHWYM                                            AS KHWYM               --04 客户唯一码
       ,T1.KHMC                                             AS KHMC                --05 客户名称
       ,T1.ZJLX                                             AS ZJLX                --06 证件类型
       ,T1.ZJHM                                             AS ZJHM                --07 证件号码
       ,COALESCE(T2.SFGTQY,T3.SFGTQY,T1.SFGTQY)             AS SFGTQY              --09 是否关停企业
       ,COALESCE(T2.BXCDJMFYLB,T3.BXCDJMFYLB,T1.BXCDJMFYLB) AS BXCDJMFYLB          --11 本行承担/减免费用类別
       ,COALESCE(T2.BNLJCDHJMDXDXGFYJE,T3.BNLJCDHJMDXDXGFYJE,T1.BNLJCDHJMDXDXGFYJE)
                                                            AS BNLJCDHJMDXDXGFYJE  --12 本年累计承担或减免的信贷相关费用金额（元） --update by lyh 20220930,继承上一天数据
       ,T1.SYS_SOURCE                                       AS SYS_SOURCE          --13 来源系统
   FROM TMP_ADD_DG_001_CUST T1     --当天跑批数据
   LEFT JOIN ADD_DG_001_CUST_L T2  --当天跑批后补录数据
     ON T1.KHWYM = T2.KHWYM
   LEFT JOIN ( SELECT A.*,ROW_NUMBER()OVER(PARTITION BY A.KHWYM ORDER BY A.SYS_OPER_DATE DESC) RN
                FROM ADD_DG_001_CUST_ETL A
               WHERE A.DATA_DATE = (SELECT MAX(TT.DATA_DATE) FROM ADD_DG_001_CUST_ETL TT WHERE TT.DATA_DATE < V_P_DATE)
              ) T3               --上一天数据
     ON T1.KHWYM = T3.KHWYM
    AND T3.RN = 1 ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP      := 7;
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
    SELECT DATA_DATE,KHWYM,COUNT(1)
      FROM RRP_MDL.ADD_DG_001_CUST T
     WHERE DATA_DATE = V_P_DATE
     GROUP BY DATA_DATE,KHWYM
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

END ETL_ADD_DG_001_CUST;
/

