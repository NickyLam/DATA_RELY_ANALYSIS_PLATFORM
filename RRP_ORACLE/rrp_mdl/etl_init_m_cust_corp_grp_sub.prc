CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_CORP_GRP_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_CORP_GRP_SUB
  *  功能描述：监管集市集团客户补充信息
  *  创建日期：20220609
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息
  *            IOL.ICMS_FINA_REPORT          --财报簿;财报,财报簿
  *            IOL.ICMS_FINA_SHEET           --财报表
  *            IOL.ICMS_FINA_ROW             --财报行数据;财报数据
  *
  *  目标表：  M_CUST_CORP_GRP_SUB  --集团客户信息子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230116  hulj     调整工商注册编号取值。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_CORP_GRP_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_CORP_GRP_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  -- V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

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

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入集团客户信息子表数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_CORP_GRP_SUB
  (
     DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,CUST_ID                   --客户编号
    ,SPL_CHAIN_CUST_FLG        --供应链客户标志
    ,SAIC_REGD_ID              --工商注册编号
    ,GRP_MBR_NUM               --集团成员数
    ,AST_LBY_TBL_TYP           --资产负债表类型
    ,AST_LBY_TBL_DT            --资产负债表日期
    ,CUR                       --币种
    ,AST_TOT_AMT               --资产总额
    ,LBY_TOT_AMT               --负债总额
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,AST_TOT_AMT_CRRS          --资产总额-客户风险
    ,LBY_TOT_AMT_CRRS          --负债总额-客户风险
    ,AST_LBY_TBL_DT_CRRS       --资产负债表日期-客户风险
    ,RPT_CYC                   --报表周期
  )
  WITH JT_CWBB AS --直取
  (  SELECT
     T.CUST_ID           --客户编号
    ,T.FIN_RPT_ID         --财务报表编号
    ,T.FIN_RPT_DT         --财务报表日期
    ,T.RPT_CYC           --报表周期
    ,T.RPT_CLBR           --报表口径
    ,T.CUR               --币种
    ,T.AST_TOT_AMT       --资产总额
    ,T.LBY_TOT_AMT       --负债总额
  FROM
    (SELECT
    C.CUSTOMERID       AS CUST_ID --客户编号
    ,FR.SUBJECTNO      AS FIN_RPT_ID  --财务报表编号
    ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')
                       AS FIN_RPT_DT  --财务报表日期
    ,'01'              AS RPT_CYC     --报表周期  --年
    ,CASE WHEN C.REPORTSCOPE ='01' THEN '02'  --合并报表
            WHEN C.REPORTSCOPE ='02' THEN '01'  --本部报表
            ELSE '99'  --其他
    END              AS RPT_CLBR        --报表口径
   ,'CNY'            AS CUR             --币种
   ,FR.VALUETWO      AS  AST_TOT_AMT     --资产总额
   ,FR.VALUETWO      AS  LBY_TOT_AMT     --负债总额
  FROM O_IOL_ICMS_FINA_ROW FR
  LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
            FROM  O_IOL_ICMS_FINA_SHEET FS
       WHERE FS.SHEETTYPE = 'BS')FS
       ON FS.SHEETNO = FR.SHEETNO
       AND FS.RN = 1
  JOIN (SELECT MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID
       FROM O_IOL_ICMS_FINA_REPORT FRN
       WHERE FRN.REPORTPERIOD='Y' /*AND FRN.REPORTSTATUS='Open'*/ --modify by tangan at 20230114
        GROUP BY CUSTOMERID)  C
  ON C.REPORTNO = FS.REPORTNO
  WHERE FR.SUBJECTNO IN ('804','807','1903','2906') )T  --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债
  ),JT_CWBB2 AS --通过集团成员财报汇总
  (  SELECT
     T2.GRP_CUST_ID      AS CUST_ID          --客户编号
    ,T1.FIN_RPT_ID       AS FIN_RPT_ID       --财务报表编号
    ,MAX(T1.FIN_RPT_DT)  AS FIN_RPT_DT       --财务报表日期
    ,MAX(T1.RPT_CYC)     AS RPT_CYC          --报表周期
    ,MAX(T1.RPT_CLBR)    AS RPT_CLBR         --报表口径
    ,MAX(T1.CUR)         AS CUR              --币种
    ,SUM(T1.AST_TOT_AMT) AS AST_TOT_AMT      --资产总额
    ,SUM(T1.LBY_TOT_AMT) AS LBY_TOT_AMT      --负债总额
  FROM
    (SELECT
    C.CUSTOMERID       AS CUST_ID --客户编号
    ,FR.SUBJECTNO      AS FIN_RPT_ID  --财务报表编号
    ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')
                       AS FIN_RPT_DT  --财务报表日期
    ,C.REPORTPERIOD   AS RPT_CYC     --报表周期  --年
    ,CASE WHEN C.REPORTSCOPE ='1' THEN '02'  --合并报表
            WHEN C.REPORTSCOPE ='2' THEN '01'  --本部报表
            ELSE '99'  --其他
    END              AS RPT_CLBR        --报表口径
   ,'CNY'            AS CUR             --币种
   ,FR.VALUETWO      AS  AST_TOT_AMT     --资产总额
   ,FR.VALUETWO      AS  LBY_TOT_AMT     --负债总额
  FROM O_IOL_ICMS_FINA_ROW FR
  LEFT JOIN (SELECT REPORTNO,SHEETNO,REPORTPERIOD,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
            FROM  O_IOL_ICMS_FINA_SHEET FS
       WHERE FS.SHEETTYPE = 'BS')FS
       ON FS.SHEETNO = FR.SHEETNO
       AND FS.RN = 1
  JOIN (SELECT MAX(REPORTPERIOD) REPORTPERIOD ,MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID
       FROM O_IOL_ICMS_FINA_REPORT FRN
       WHERE FRN.REPORTPERIOD='Y' /*AND FRN.REPORTSTATUS='Open'*/ --modify by tangan at 20230114
        GROUP BY CUSTOMERID)  C
  ON C.REPORTNO = FS.REPORTNO
  WHERE FR.SUBJECTNO IN ('804','807','1903','2906') )T1 --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债
  INNER JOIN --关联集团成员，集团的财报根据集团成员财报汇总 --modify by tangan at 20230114
  (SELECT DISTINCT
         A.GROUP_CUST_ID                       AS GRP_CUST_ID            --集团客户编号
        ,A.CUST_NAME                           AS MBR_NM                 --成员名称
        ,A.CUST_ID                             AS MBR_CUST_ID            --成员客户编号
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息  --mod by hulj20230113
    INNER JOIN (--集团客户
                 SELECT CUST_ID
                   FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
                  WHERE CRDT_CUST_TYPE_CD='5'
                    AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) B
       ON A.GROUP_CUST_ID = B.CUST_ID
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        AND A.GROUP_CUST_ID <> A.CUST_ID --剔除集团自身 modify by tangan at 20221118
  ) T2
  ON T1.CUST_ID = T2.MBR_CUST_ID
  GROUP BY T2.GRP_CUST_ID,T1.FIN_RPT_ID
  ),
  JT_CWBB_CRRS AS --直取
  (  SELECT
     T.CUST_ID           --客户编号
    ,T.FIN_RPT_ID         --财务报表编号
    ,T.FIN_RPT_DT         --财务报表日期
    ,T.RPT_CYC           --报表周期
    ,T.RPT_CLBR           --报表口径
    ,T.CUR               --币种
    ,T.AST_TOT_AMT       --资产总额
    ,T.LBY_TOT_AMT       --负债总额
  FROM
    (SELECT
    C.CUSTOMERID       AS CUST_ID --客户编号
    ,FR.SUBJECTNO      AS FIN_RPT_ID  --财务报表编号
    ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')
                       AS FIN_RPT_DT  --财务报表日期
    ,C.REPORTPERIOD   AS RPT_CYC     --报表周期  --年
    ,CASE WHEN C.REPORTSCOPE ='1' THEN '02'  --合并报表
            WHEN C.REPORTSCOPE ='2' THEN '01'  --本部报表
            ELSE '99'  --其他
    END              AS RPT_CLBR        --报表口径
   ,'CNY'            AS CUR             --币种
   ,FR.VALUETWO      AS  AST_TOT_AMT     --资产总额
   ,FR.VALUETWO      AS  LBY_TOT_AMT     --负债总额
  FROM O_IOL_ICMS_FINA_ROW FR
  LEFT JOIN (SELECT REPORTNO,SHEETNO,REPORTPERIOD,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
            FROM  O_IOL_ICMS_FINA_SHEET FS
       WHERE FS.SHEETTYPE = 'BS')FS
       ON FS.SHEETNO = FR.SHEETNO
       AND FS.RN = 1
  JOIN (SELECT MAX(REPORTPERIOD) REPORTPERIOD,MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID
       FROM O_IOL_ICMS_FINA_REPORT FRN
       WHERE FRN.REPORTPERIOD='Y' AND FRN.REPORTSTATUS='Finished'
        GROUP BY CUSTOMERID)  C
  ON C.REPORTNO = FS.REPORTNO
  WHERE FR.SUBJECTNO IN ('804','807','1903','2906') )T  --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债
  )

  SELECT
      TO_CHAR(A.ETL_DT, 'YYYYMMDD')           AS DATA_DT                   --数据日期
    ,A.LP_ID                                 AS LGL_REP_ID                --法人编号
    ,A.CUST_ID                               AS CUST_ID                   --客户编号
    ,NULL                                    AS SPL_CHAIN_CUST_FLG        --供应链客户标志
    ,NVL(A.SOCI_CRDT_CD,A.ORGNZ_CD)          AS SAIC_REGD_ID              --工商注册编号  --mod by hulj20230116
    ,NVL(TRIM(B.NUM),0)                      AS GRP_MBR_NUM               --集团成员数
   /* ,\*NVL(TRIM(C.RPT_CYC),B.RPT_CYC) *\
    NVL(C1.RPT_CLBR,C2.RPT_CLBR)             AS AST_LBY_TBL_TYP           --资产负债表类型
    ,NVL(C1.FIN_RPT_DT,C2.FIN_RPT_DT)        AS AST_LBY_TBL_DT            --资产负债表日期
    ,NVL(C1.CUR,C2.CUR)                      AS CUR                       --币种*/
  --,NVL(TRIM(C.AST_TOT_AMT),B.AST_TOT_AMT)  AS AST_TOT_AMT               --资产总额
    ,COALESCE(C1.RPT_CLBR,C2.RPT_CLBR,C3.RPT_CLBR,C4.RPT_CLBR)         AS AST_LBY_TBL_TYP           --资产负债表类型
    ,COALESCE(C1.FIN_RPT_DT,C2.FIN_RPT_DT,C3.FIN_RPT_DT,C4.FIN_RPT_DT) AS AST_LBY_TBL_DT            --资产负债表日期
    ,COALESCE(C1.CUR,C2.CUR,C3.CUR,C4.CUR,'CNY')                       AS CUR                       --币种
    ,CASE WHEN NVL(TRIM(C1.AST_TOT_AMT),0.00) <> 0.00 THEN NVL(TRIM(C1.AST_TOT_AMT),0.00)
          ELSE NVL(TRIM(C3.AST_TOT_AMT),0.00)
     END                                     AS AST_TOT_AMT               --资产总额 --调整
 -- ,NVL(TRIM(C.LBY_TOT_AMT),B.LBY_TOT_AMT)  AS LBY_TOT_AMT               --负债总额
    ,CASE WHEN NVL(TRIM(C2.LBY_TOT_AMT),0.00) <> 0.00 THEN NVL(TRIM(C2.LBY_TOT_AMT),0.00)
          ELSE NVL(TRIM(C4.LBY_TOT_AMT),0.00)
     END                                     AS LBY_TOT_AMT               --负债总额 --调整
    ,NULL                                    AS DEPT_LINE                 --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                  AS DATA_SRC                  --数据来源
    ,NVL(TRIM(D1.AST_TOT_AMT),0.00)          AS AST_TOT_AMT_CRRS          --资产总额-客户风险
    ,NVL(TRIM(D2.LBY_TOT_AMT),0.00)          AS LBY_TOT_AMT               --负债总额-客户风险
    ,COALESCE(D1.FIN_RPT_DT,D2.FIN_RPT_DT)   AS AST_LBY_TBL_DT_CRRS       --资产负债表日期-客户风险
    ,COALESCE(D1.RPT_CYC,D2.RPT_CYC)         AS RPT_CYC                   --报表周期
  FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息
  LEFT JOIN ( --集团成员数量
    SELECT B1.GROUP_CUST_ID
          ,COUNT(B1.CUST_ID) AS NUM
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B1  --对公客户基本信息
    WHERE B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(B1.GROUP_CUST_ID) IS NOT NULL
    GROUP BY B1.GROUP_CUST_ID
  ) B
  ON A.CUST_ID = B.GROUP_CUST_ID
  LEFT JOIN JT_CWBB C1  --资产总额
         ON A.CUST_ID = C1.CUST_ID
         AND C1.FIN_RPT_ID IN ('804','1903') --modify by tangan at 20230114
  LEFT JOIN JT_CWBB C2  --负债总额
         ON A.CUST_ID = C2.CUST_ID
         AND C2.FIN_RPT_ID IN ('807','2906') --modify by tangan at 20230114
  LEFT JOIN JT_CWBB2 C3  --资产总额
         ON A.CUST_ID = C3.CUST_ID
         AND C3.FIN_RPT_ID IN ('804','1903') --modify by tangan at 20230114
  LEFT JOIN JT_CWBB2 C4  --负债总额
         ON A.CUST_ID = C4.CUST_ID
         AND C4.FIN_RPT_ID IN ('807','2906') --modify by tangan at 20230114
  LEFT JOIN JT_CWBB_CRRS D1  --资产总额
         ON A.CUST_ID = D1.CUST_ID
         AND D1.FIN_RPT_ID IN ('804','1903') --modify by mw at 20230206
  LEFT JOIN JT_CWBB_CRRS D2  --负债总额
         ON A.CUST_ID = D2.CUST_ID
         AND D2.FIN_RPT_ID IN ('807','2906') --modify by mw at 20230206
  WHERE /*A.GROUP_CUST_FLG = '1' --集团客户*/
       A.CRDT_CUST_TYPE_CD='5' --集团客户 --mod by hulj 20230113 根据数仓提供口径按照以前的口径出数
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


/*
        V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产总额';
  V_STARTTIME := SYSDATE;

   MERGE INTO M_CUST_CORP_GRP_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,C.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT FRN
                      WHERE FRN.REPORTPERIOD='Y' AND FRN.REPORTSTATUS='Open'
                      GROUP BY CUSTOMERID)  C
                     ON C.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO = '804'
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID
  AND A.DATA_DT = V_P_DATE)

  WHEN MATCHED
  THEN UPDATE SET A.AST_TOT_AMT = B.VALUETWO;
   COMMIT;


  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入负债总额';
  V_STARTTIME := SYSDATE;

   MERGE INTO M_CUST_CORP_GRP_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,FRN.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT
                      WHERE REPORTPERIOD='Y' AND REPORTSTATUS='Open'
                      GROUP BY CUSTOMERID)  FRN
                     ON FRN.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO = '807'
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID
  AND A.DATA_DT = V_P_DATE)

  WHEN MATCHED
  THEN UPDATE SET A.LBY_TOT_AMT = B.VALUETWO;
  COMMIT;*/

 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CUST_CORP_GRP_SUB;
/

