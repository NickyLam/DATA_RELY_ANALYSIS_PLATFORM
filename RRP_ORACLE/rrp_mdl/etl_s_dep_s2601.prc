CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_DEP_S2601(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_S_DEP_S2601
  *  功能描述：S2601存款结果表
  *  创建日期：20240325
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  S_DEP_S2601
  *  配置表：  CODE_MAP

      单位存款特殊处理构成：
     1.单位贷款的个体工商户存款 --划分为个人存款
     2.保险公司存款 --含有两部分，AGRT_DEP_PSN_TYP=A 与S_DEP里面20150102科目，其中20150102科目比总账少1千多块
     3.普通单位存款剔除1,2点


      个人存款特殊处理构成：
     1.个人除普通存款外需增加单位贷款的个体工商户存款 --个人活期部分有1000多块的电子现金总分不平，总账比明细多1000多块
     2.看S2601表结构需新增，互联网存款部分（待确认）
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240325   lwb     新增
                2    20240626   LWB     个人存款的逻辑新增过滤条件
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_DEP_S2601'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_DEP_S2601'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入单位存款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_DEP_S2601 
  (    DATA_DT
      ,ORG_ID 
      ,CUST_ID 
      ,ACC_ID  
      ,DEP_PROD_TYP
      ,CUST_ACCT_SUB_ACCT_NUM 
      ,SUBJ_ID 
      ,ACC_BAL  
      ,PBL_INT  
      ,STD_PROD_ID
      ,DEP_S26_TYP 
      ,DATA_SRC  
      ,REGD_LAND_AREA_CD 
      ,DEP_START_DT  
      ,DEP_EXP_DT 
      ,DEP_TERM  --存款期限
      ,ACC_CUR
      ,IS_ONLINE
   )
  SELECT  V_P_DATE              AS DATA_DT --数据日期
          ,A.ORG_ID                        --机构号
          ,A.CUST_ID                       --客户号
          ,A.ACC_ID                        --存款账户
          ,A.DEP_PROD_TYP                  --存款类型
          ,A.CUST_ACCT_SUB_ACCT_NUM        --子账户号
          ,A.SUBJ_ID                       --科目
          ,a.ACC_BAL            AS ACC_BAL --账户余额折币
          ,A.PBL_INT                       --利息
          ,A.STD_PROD_ID                   --产品编号
          ,CASE WHEN FO.CUST_CL ='E' THEN '个人存款'
                WHEN (A.AGRT_DEP_PSN_TYP = 'A' OR A.SUBJ_ID='20150102')  THEN '保险公司存款'
                ELSE '单位存款' 
            END                 AS  DEP_S26_TYP 
          ,'单位存款'           AS DATA_SRC  
          ,SUBSTR(FO.REGD_LAND_AREA_CD,0,2)||'0000' AS REGD_LAND_AREA_CD --行政区划代码
          ,A.DEP_START_DT                 --存款起始日期
          ,A.DEP_EXP_DT                   --存款到期日期
          ,CASE WHEN A.SUBJ_ID = '20110101' THEN '活期'
                WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >60 THEN '五年以上'
                WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >36 THEN '三年至五年含'
                WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >12 THEN '一年至三年含'
                WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >6 THEN '六个月至一年含'
                WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >0 THEN '六个月以内含' 
            END                 AS DEP_TERM  --存款期限
           ,A.ACC_CUR
           ,'Z'                 AS IS_ONLINE
     FROM RRP_MDL.S_DEP A --存款业务整合表
     LEFT JOIN RRP_MDL.M_CUST_CORP_INFO FO
       ON A.CUST_ID = FO.CUST_ID
      AND FO.DATA_DT = V_P_DATE
    WHERE A.DATA_DT = V_P_DATE
      AND (A.SUBJ_ID IN('20110101', '20110102', '20110103', '20110104', '20110105','20150102') 
           OR SUBSTR(A.SUBJ_ID, 1, 6) IN ('200201', '200299')) --S_DEP的20150102为保险公司存款
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入个人存款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_DEP_S2601 
  ( DATA_DT
    ,ORG_ID 
    ,CUST_ID 
    ,ACC_ID  
    ,DEP_PROD_TYP
    ,CUST_ACCT_SUB_ACCT_NUM 
    ,SUBJ_ID 
    ,ACC_BAL  
    ,PBL_INT  
    ,STD_PROD_ID
    ,DEP_S26_TYP 
    ,DATA_SRC  
    ,REGD_LAND_AREA_CD 
    ,DEP_START_DT  
    ,DEP_EXP_DT 
    ,DEP_TERM  --存款期限
    ,ACC_CUR
    ,IS_ONLINE
    ,OPEN_ACC_CHAN
 )
     WITH TMP AS (
          SELECT DISTINCT A.CUST_ACCT_ID
            FROM ICL.V_CMM_DEP_ACCT_INFO A
            LEFT JOIN ICL.V_CMM_DEP_CUST_ACCT_INFO D
              ON A.CUST_ACCT_ID = D.CUST_ACCT_ID
             AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           INNER JOIN ICL.CMM_INDV_CUST_BASIC_INFO C
              ON A.CUST_ID = C.CUST_ID
             AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO B --汇率表
              ON A.CURR_CD = B.BASE_CUR --基准币种
             AND B.CNV_CUR = 'CNY' --折算币种
             AND B.DATA_DT = V_P_DATE
           WHERE A.CUST_ACCT_ID IN (SELECT B.CUST_ACCT_ID
                                      FROM ICL.V_CMM_DEP_CUST_ACCT_INFO B
                                     WHERE B.ACCT_TYPE_CD = '2' --2类户
                                       AND B.CUST_ID NOT IN (SELECT B.CUST_ID
                                                               FROM ICL.V_CMM_DEP_CUST_ACCT_INFO B
                                                              WHERE B.ACCT_TYPE_CD = '1' --1类户
                                                                AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
                                       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') )
            AND D.OPEN_ACCT_CHN_CD <> '100001' --剔除柜面开户渠道
            AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   )
        SELECT  V_P_DATE        AS DATA_DT --数据日期
                ,A.ORG_ID                  --机构号
                ,A.CUST_ID                 --客户号
                ,A.ACC_ID                  --存款账户
                ,A.DEP_PROD_TYP            --存款类型
                ,A.CUST_ACCT_SUB_ACCT_NUM  --子账户号
                ,A.SUBJ_ID                 --科目
                ,a.ACC_BAL      AS ACC_BAL --账户余额折币
                ,A.PBL_INT                 --利息
                ,A.STD_PROD_ID             --产品编号
                ,'个人存款'     AS DEP_S26_TYP 
                ,'个人存款'     AS DATA_SRC  
                ,SUBSTR(AA.CRDL_NO,0,2)||'0000' AS REGD_LAND_AREA_CD --行政区划代码
                ,A.DEP_START_DT            --存款起始日期
                ,A.DEP_EXP_DT              --存款到期日期
                ,CASE WHEN A.SUBJ_ID IN ('20110201', '20110210') THEN '活期'
                      WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >60 THEN '五年以上'
                      WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >36 THEN '三年至五年含'
                      WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >12 THEN '一年至三年含'
                      WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >6 THEN '六个月至一年含'
                      WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >0 THEN '六个月以内含' 
                   END           AS DEP_TERM  --存款期限
                 ,A.ACC_CUR
                 ,CASE WHEN AAA.CUST_ACCT_ID IS NOT NULL 
                       THEN 'Y' 
                       ELSE 'N' 
                   END           AS IS_ONLINE
                 ,A.OPEN_ACC_CHAN
           FROM RRP_MDL.S_DEP A --存款业务整合表
           LEFT JOIN RRP_MDL.M_CUST_IND_INFO AA
             ON A.CUST_ID=AA.CUST_ID
            AND AA.DATA_DT=V_P_DATE
          INNER JOIN TMP AAA
             ON AAA.CUST_ACCT_ID=A.ACC_ID
          WHERE A.DATA_DT = V_P_DATE
            AND A.OPEN_ACC_CHAN IN ('302001','304003')--304003：微信小程序  302001：个人手机银行
            AND (A.SUBJ_ID IN ('20110201','20110210','20110202','20110203',
                              '20110205','20110208','20110209','20110207','20110204')
                 OR SUBSTR(A.SUBJ_ID, 1, 6) = '200202')
               ;
               
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := 3;
  V_STEP_DESC := '插入联合存款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_DEP_S2601 
  (   DATA_DT
      ,ORG_ID 
      ,CUST_ID 
      ,ACC_ID  
      ,DEP_PROD_TYP
      ,CUST_ACCT_SUB_ACCT_NUM 
      ,SUBJ_ID 
      ,ACC_BAL  
      ,PBL_INT  
      ,STD_PROD_ID
      ,DEP_S26_TYP 
      ,DATA_SRC  
      ,REGD_LAND_AREA_CD 
      ,DEP_START_DT  
      ,DEP_EXP_DT 
      ,DEP_TERM  --存款期限
      ,ACC_CUR
      ,IS_ONLINE
 )
       SELECT  V_P_DATE         AS DATA_DT --数据日期
               ,A.ORG_ID                   --机构号
               ,A.CUST_ID                  --客户号
               ,A.ACC_ID                   --存款账户
               ,A.DEP_PROD_TYP             --存款类型
               ,A.CUST_ACCT_SUB_ACCT_NUM   --子账户号
               ,A.SUBJ_ID                  --科目
               ,a.ACC_BAL      AS ACC_BAL  --账户余额折币
               ,A.PBL_INT                  --利息
               ,A.STD_PROD_ID              --产品编号
               ,'联合存款'     AS DEP_S26_TYP 
               ,'联合存款'     AS DATA_SRC  
               ,SUBSTR(AA.CRDL_NO,0,2)||'0000' AS REGD_LAND_AREA_CD --行政区划代码
               ,A.DEP_START_DT             --存款起始日期
               ,A.DEP_EXP_DT               --存款到期日期
               ,CASE WHEN A.SUBJ_ID IN ('20110201', '20110210') THEN '活期'
                     WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >60 THEN '五年以上'
                     WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >36 THEN '三年至五年含'
                     WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >12 THEN '一年至三年含'
                     WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >6 THEN '六个月至一年含'
                     WHEN MONTHS_BETWEEN(TO_DATE(A.DEP_EXP_DT, 'YYYYMMDD'),TO_DATE(A.DEP_START_DT, 'YYYYMMDD')) >0 THEN '六个月以内含' 
                 END            AS DEP_TERM  --存款期限
               ,A.ACC_CUR
               ,'Y'             AS IS_ONLINE
          FROM RRP_MDL.S_DEP A --存款业务整合表
          LEFT JOIN RRP_MDL.M_CUST_IND_INFO AA
            ON A.CUST_ID=AA.CUST_ID
           AND AA.DATA_DT=V_P_DATE
         WHERE A.DATA_DT = V_P_DATE
           AND SUBSTR(A.DEP_PROD_TYP, 0, 2) = '01'
           AND A.CBRC_FLG = 'Y'
           AND A.CUST_LRG_CL = '01' --对私客户
           AND A.DATA_SRC = '联合存款'  --第三方平台
               ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



  V_STEP := 5;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := 6;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;

    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_DEP_S2601;
/

