CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_CORP_FIN_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_CORP_FIN_SUB
  *  功能描述：监管集市对于本行需要收集财务信息的对公客户，报送财务报表相关信息。
  *  创建日期：20220610
  *  开发人员：hulijuan
  *  来源表：  IOL.ICMS_FINA_REPORT       --财报簿;财报,财报簿
  *            IOL.ICMS_FINA_ROW          --财报行数据;财报数据
  *            IOL.ICMS_FINA_SHEET        --财报表
  *            IOL.ICMS_CUSTOMER_INFO     --客户基本信息
  *  目标表：  M_CUST_CORP_FIN_SUB        --对公客户财务信息子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221107  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20220206  MW       新增客户风险用资产负债总额。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_CORP_FIN_SUB'; -- 程序名称
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
  V_TAB_NAME := 'M_CUST_CORP_FIN_SUB'; --表名
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
  V_STEP_DESC := '插入对公客户财务信息子表信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_CORP_FIN_SUB
  (
   DATA_DT             --数据日期
    ,LGL_REP_ID        --法人编号
    ,CUST_ID           --客户编号
    ,FIN_RPT_ID        --财务报表编号
    ,FIN_RPT_DT        --财务报表日期
    ,RPT_CYC           --报表周期
    ,AUDIT_FLG         --审计标志
    ,AUDIT_CO_NM       --审计单位
    ,RPT_CLBR          --报表口径
    ,CUR               --币种
    ,AST_TOT_AMT       --资产总额
    ,LBY_TOT_AMT       --负债总额
    ,PRE_TAX_PROFIT    --税前利润
    ,INCM_TAX          --所得税
    ,NET_PROFIT        --净利润
    ,MAIN_BIZ_INCOME   --主营业务收入
    ,CASH_NET_AMT      --现金流量净额
    ,IVNT              --存货
    ,RECV_ACC_VAL      --应收账款
    ,OTH_RECV          --其他应收款
    ,CURR_AST_TOT_AMT  --流动资产总额
    ,CURR_LBY_TOT_AMT  --流动负债总额
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
    ,AST_TOT_AMT_CRRS  --资产总额-客户风险
    ,LBY_TOT_AMT_CRRS  --负债总额-客户风险
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
    ,T.AUDITFLAG
    ,T.AUDITINGAGENCY
    ,T.ACCOUNTINGMONTH
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
   ,C.AUDITFLAG      AS  AUDITFLAG
   ,C.AUDITINGAGENCY AS AUDITINGAGENCY
   ,C.ACCOUNTINGMONTH   AS ACCOUNTINGMONTH
  FROM O_IOL_ICMS_FINA_ROW FR
  LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
            FROM  O_IOL_ICMS_FINA_SHEET FS
       WHERE FS.SHEETTYPE = 'BS')FS
       ON FS.SHEETNO = FR.SHEETNO
       AND FS.RN = 1
  JOIN (SELECT MAX(AUDITFLAG) AUDITFLAG,MAX(AUDITINGAGENCY) AUDITINGAGENCY,MAX(ACCOUNTINGMONTH),MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID
       FROM O_IOL_ICMS_FINA_REPORT FRN
       WHERE FRN.REPORTPERIOD='Y' /*AND FRN.REPORTSTATUS='Open'*/ --modify by tangan at 20230114
        GROUP BY CUSTOMERID)  C
  ON C.REPORTNO = FS.REPORTNO
  WHERE FR.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801','517','6506','501','801308'
  ,'5171','7011','104','1122','108','1221') )T  --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债
  ),--801 旧准则流动资产 1171 新准则流动资产    805  旧准则流动负债  2281 新准则流动负债
   --515 旧准则利润总额 6505 新准则利润总额    516  旧准则所得税    6801 新准则所得税
   --517 旧准则净利润  6506 新准则净利润       501  旧主营业务收入 801308  新主营业务收入
   --5171 旧准则现金流量净额  7011 新准则现金流量净额  104 旧应收账款 1122 新应收账款
   --108 其他应收款  1221 其他应收款
 JT_CWBB_CRRS AS --直取
  (  SELECT
     T.CUST_ID           --客户编号
    ,T.FIN_RPT_ID        --财务报表编号
    ,T.FIN_RPT_DT        --财务报表日期
    ,T.RPT_CYC           --报表周期
    ,T.RPT_CLBR          --报表口径
    ,T.CUR               --币种
    ,T.AST_TOT_AMT       --资产总额
    ,T.LBY_TOT_AMT       --负债总额
    ,T.AUDITFLAG
    ,T.AUDITINGAGENCY
    ,T.ACCOUNTINGMONTH
  FROM
    (SELECT
    C.CUSTOMERID       AS CUST_ID     --客户编号
    ,FR.SUBJECTNO      AS FIN_RPT_ID  --财务报表编号
    ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')
                       AS FIN_RPT_DT  --财务报表日期
    ,C.REPORTPERIOD    AS RPT_CYC     --报表周期  --年
    ,CASE WHEN C.REPORTSCOPE ='1' THEN '02'  --合并报表
            WHEN C.REPORTSCOPE ='2' THEN '01'  --本部报表
            ELSE '99'  --其他
    END              AS RPT_CLBR        --报表口径
   ,'CNY'            AS CUR             --币种
   ,FR.VALUETWO      AS  AST_TOT_AMT     --资产总额
   ,FR.VALUETWO      AS  LBY_TOT_AMT     --负债总额
   ,C.AUDITFLAG      AS  AUDITFLAG
   ,C.AUDITINGAGENCY AS AUDITINGAGENCY
   ,C.ACCOUNTINGMONTH   AS ACCOUNTINGMONTH
  FROM O_IOL_ICMS_FINA_ROW FR
  LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
            FROM  O_IOL_ICMS_FINA_SHEET FS
       WHERE FS.SHEETTYPE = 'BS')FS
       ON FS.SHEETNO = FR.SHEETNO
       AND FS.RN = 1
  JOIN (SELECT MAX(REPORTPERIOD) REPORTPERIOD ,MAX(AUDITFLAG) AUDITFLAG,MAX(AUDITINGAGENCY) AUDITINGAGENCY,MAX(ACCOUNTINGMONTH),MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID
       FROM O_IOL_ICMS_FINA_REPORT FRN
       WHERE FRN.REPORTPERIOD='Y' AND FRN.REPORTSTATUS='Finished'
        GROUP BY CUSTOMERID)  C
  ON C.REPORTNO = FS.REPORTNO
  WHERE FR.SUBJECTNO IN ('804','807','1903','2906') )T  --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债  --804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债
  )
  SELECT
     T.DATA_DT           --数据日期
    ,T.LGL_REP_ID        --法人编号
    ,T.CUST_ID           --客户编号
    ,T.FIN_RPT_ID        --财务报表编号
    ,T.FIN_RPT_DT        --财务报表日期
    ,T.RPT_CYC           --报表周期
    ,T.AUDIT_FLG         --审计标志
    ,T.AUDIT_CO_NM       --审计单位
    ,T.RPT_CLBR          --报表口径
    ,T.CUR               --币种
    ,T.AST_TOT_AMT       --资产总额
    ,T.LBY_TOT_AMT       --负债总额
    ,T.PRE_TAX_PROFIT    --税前利润
    ,T.INCM_TAX          --所得税
    ,T.NET_PROFIT        --净利润
    ,T.MAIN_BIZ_INCOME   --主营业务收入
    ,T.CASH_NET_AMT      --现金流量净额
    ,T.IVNT              --存货
    ,T.RECV_ACC_VAL      --应收账款
    ,T.OTH_RECV          --其他应收款
    ,T.CURR_AST_TOT_AMT  --流动资产总额
    ,T.CURR_LBY_TOT_AMT  --流动负债总额
    ,T.DEPT_LINE         --部门条线
    ,T.DATA_SRC          --数据来源
    ,T.AST_TOT_AMT_CRRS  --资产总额-客户风险
    ,T.LBY_TOT_AMT_CRRS  --负债总额-客户风险
    FROM
    (
    SELECT
      V_P_DATE           AS DATA_DT
      ,'9999'            AS LGL_REP_ID
      ,T1.CUST_ID        AS CUST_ID
      ,T1.FIN_RPT_ID     AS FIN_RPT_ID
      ,T1.FIN_RPT_DT     AS FIN_RPT_DT
      ,T1.RPT_CYC        AS RPT_CYC
      ,CASE WHEN T1.AUDITFLAG = '1' THEN 'Y'
            ELSE 'N'
       END               AS AUDIT_FLG
      ,T1.AUDITINGAGENCY AS AUDIT_CO_NM
      ,T1.RPT_CLBR
      ,T1.CUR
      ,NVL(T2.AST_TOT_AMT,0)
                         AS AST_TOT_AMT   --资产总额
      ,NVL(T3.AST_TOT_AMT,0)
                         AS LBY_TOT_AMT   --总负债
      ,NVL(T6.AST_TOT_AMT,0)
                         AS PRE_TAX_PROFIT --税前利润
      ,NVL(T7.AST_TOT_AMT,0)
                         AS INCM_TAX       --所得税
      ,NVL(T8.AST_TOT_AMT,0)
                         AS NET_PROFIT     --净利润
      ,NVL(T9.AST_TOT_AMT,0)
                         AS MAIN_BIZ_INCOME --主营业务收入
      ,NVL(T10.AST_TOT_AMT,0)
                         AS CASH_NET_AMT   --现金流量净额
      ,NULL
                         AS IVNT           --存货
      ,NVL(T11.AST_TOT_AMT,0)
                         AS RECV_ACC_VAL   --应收账款
      ,NVL(T12.AST_TOT_AMT,0)
                         AS OTH_RECV       --其他应收款
      ,NVL(T4.AST_TOT_AMT,0)
                         AS CURR_AST_TOT_AMT --流动资产总额
      ,NVL(T5.AST_TOT_AMT,0)
                         AS CURR_LBY_TOT_AMT --流动资产总额
      ,NULL              AS DEPT_LINE
      ,'对公客户财务报表' AS DATA_SRC
      ,NVL(T13.AST_TOT_AMT,0)
                         AS AST_TOT_AMT_CRRS --资产总额-客户风险
      ,NVL(T14.AST_TOT_AMT,0)
                         AS LBY_TOT_AMT_CRRS --负债总额-客户风险
      ,ROW_NUMBER()OVER (PARTITION BY T1.CUST_ID ORDER BY  T1.ACCOUNTINGMONTH ) RN
    FROM JT_CWBB         T1
    LEFT JOIN JT_CWBB    T2
      ON T1.CUST_ID = T2.CUST_ID
      AND T2.FIN_RPT_ID IN ('804','1903') --资产总额
    LEFT JOIN JT_CWBB    T3
      ON T1.CUST_ID = T3.CUST_ID
      AND T3.FIN_RPT_ID IN ('807','2906') --总负债
    LEFT JOIN JT_CWBB    T4
      ON T1.CUST_ID = T4.CUST_ID
      AND T4.FIN_RPT_ID IN ('801','1171') --流动资产
    LEFT JOIN JT_CWBB    T5
      ON T1.CUST_ID = T5.CUST_ID
      AND T5.FIN_RPT_ID IN ('805','2281') --流动负债
    LEFT JOIN JT_CWBB    T6
      ON T1.CUST_ID = T6.CUST_ID
      AND T6.FIN_RPT_ID IN ('515','6505') --利润总额
    LEFT JOIN JT_CWBB   T7
      ON T1.CUST_ID = T7.CUST_ID
      AND T7.FIN_RPT_ID IN ('516','6801') --所得税
    LEFT JOIN JT_CWBB   T8
      ON T1.CUST_ID = T8.CUST_ID
      AND T8.FIN_RPT_ID IN ('517','6506') --净利润
    LEFT JOIN JT_CWBB   T9
      ON T1.CUST_ID = T9.CUST_ID
      AND T9.FIN_RPT_ID IN ('501','801308') --主营业务收入
   LEFT JOIN JT_CWBB    T10
      ON T1.CUST_ID = T10.CUST_ID
      AND T10.FIN_RPT_ID IN ('5171','7011') --现金流量净额
   LEFT JOIN JT_CWBB    T11
      ON T1.CUST_ID = T11.CUST_ID
      AND T11.FIN_RPT_ID IN ('104','1122')  --应收账款
   LEFT JOIN JT_CWBB   T12
      ON T1.CUST_ID = T12.CUST_ID
      AND T12.FIN_RPT_ID IN ('108','1221')  --其他应收款
   LEFT JOIN JT_CWBB_CRRS  T13
      ON T1.CUST_ID = T13.CUST_ID
      AND T13.FIN_RPT_ID IN ('804','1903')   --资产总额-CRRS
   LEFT JOIN JT_CWBB_CRRS  T14
      ON T1.CUST_ID = T14.CUST_ID            --负债总额-CRRS
      AND T14.FIN_RPT_ID IN ('807','2906')
   )T

  WHERE T.RN = 1
  ;
 /*

   INSERT INTO M_CUST_CORP_FIN_SUB
  (
   DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,CUST_ID           --客户编号
    ,FIN_RPT_ID        --财务报表编号
    ,FIN_RPT_DT        --财务报表日期
    ,RPT_CYC           --报表周期
    ,AUDIT_FLG         --审计标志
    ,AUDIT_CO_NM       --审计单位
    ,RPT_CLBR          --报表口径
    ,CUR               --币种
    ,AST_TOT_AMT       --资产总额
    ,LBY_TOT_AMT       --负债总额
    ,PRE_TAX_PROFIT    --税前利润
    ,INCM_TAX          --所得税
    ,NET_PROFIT        --净利润
    ,MAIN_BIZ_INCOME   --主营业务收入
    ,CASH_NET_AMT      --现金流量净额
    ,IVNT              --存货
    ,RECV_ACC_VAL      --应收账款
    ,OTH_RECV          --其他应收款
    ,CURR_AST_TOT_AMT  --流动资产总额
    ,CURR_LBY_TOT_AMT  --流动负债总额
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
  )
  FROM
  (
  SELECT
       V_P_DATE                                                                      AS DATA_DT          --数据日期
      ,'9999'                                                                        AS LGL_REP_ID       --法人编号
      ,A.CUSTOMERID                                                                  AS CUST_ID          --客户编号
      ,A.REPORTNO                                                                    AS FIN_RPT_ID       --财务报表编号
      ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(A.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')  AS FIN_RPT_DT       --财务报表日期
      ,CASE WHEN A.REPORTPERIOD = 'M' THEN '04'  --月
            WHEN A.REPORTPERIOD = 'Q' THEN '03'  --季
            WHEN A.REPORTPERIOD = 'H' THEN '02'  --半年
            WHEN A.REPORTPERIOD = 'Y' THEN '01'  --年
            ELSE '99'  --其他
       END                                                                           AS RPT_CYC          --报表周期
      ,CASE WHEN A.AUDITFLAG = '1' THEN 'Y'
            ELSE 'N'
       END                                                                           AS AUDIT_FLG        --审计标志
      ,A.AUDITINGAGENCY                                                                 AS AUDIT_CO_NM      --审计单位
      ,CASE WHEN A.REPORTSCOPE ='2' THEN '02'  --合并报表
            WHEN A.REPORTSCOPE ='1' THEN '01'  --本部报表
            ELSE '99'  --其他
       END                                                                           AS RPT_CLBR         --报表口径
      ,A.CURRENCY                                                                    AS CUR              --币种
      ,NVL(B.A804,0) AS AST_TOT_AMT      --资产总额
      ,NVL(B.A807,0) AS LBY_TOT_AMT      --负债总额
      ,NVL(B.A515,0) AS PRE_TAX_PROFIT     --税前利润
      ,NVL(B.A516,0) AS INCM_TAX           --所得税
      ,NVL(B.A517,0) AS NET_PROFIT         --净利润
      ,NVL(B.A518,0) AS MAIN_BIZ_INCOME  --主营业务收入
      ,NVL(B.A522,0) AS CASH_NET_AMT       --现金流量净额
      ,NULL          AS IVNT               --存货
      ,NVL(B.A520,0) AS RECV_ACC_VAL       --应收账款
      ,NVL(B.A521,0) AS OTH_RECV           --其他应收款
      ,NULL          AS CURR_AST_TOT_AMT   --流动资产总额
      ,NULL          AS CURR_LBY_TOT_AMT   --流动负债总额
      ,\*'04'  *\ '800926' \*公司银行总部*\                                                                      AS DEPT_LINE        --部门条线
      ,'对公财务信息'                                                                     AS DATA_SRC         --数据来源
      ,ROW_NUMBER() OVER(PARTITION BY A.CUSTOMERID ORDER BY A.ACCOUNTINGMONTH DESC)       AS NUM
    FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT A --财报簿;财报,财报簿
    INNER JOIN (--财报数据
      SELECT
           T1.CUSTOMERID
          ,T1.REPORTNO
          ,MAX(DECODE(T3.SUBJECTNO, '804', T3.VALUETWO, '')) AS A804
          ,MAX(DECODE(T3.SUBJECTNO, '807', T3.VALUETWO, '')) AS A807
          ,MAX(DECODE(T3.SUBJECTNO, '515', T3.VALUETWO, '')) AS A515
          ,MAX(DECODE(T3.SUBJECTNO, '516', T3.VALUETWO, '')) AS A516
          ,MAX(DECODE(T3.SUBJECTNO, '517', T3.VALUETWO, '')) AS A517
          ,MAX(DECODE(T3.SUBJECTNO, '501', T3.VALUETWO, '')) AS A518
          ,MAX(DECODE(T3.SUBJECTNO, '104', T3.VALUETWO, '')) AS A520
          ,MAX(DECODE(T3.SUBJECTNO, '108', T3.VALUETWO, '')) AS A521
          ,MAX(DECODE(T3.SUBJECTNO, '810', T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '811', T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '812', T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, 'b75', T3.VALUETWO, '')) AS A522
      FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT T1     --财报簿;财报,财报簿
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_SHEET T2   --财报表
              ON T1.CUSTOMERID = T2.CUSTOMERID
             AND T1.ACCOUNTINGMONTH = t2.ACCOUNTINGMONTH
             AND T1.REPORTSCOPE = T2.REPORTSCOPE
             AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_ROW T3     --财报行数据;财报数据
              ON T2.SHEETNO = T3.SHEETNO
             AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.REPORTTYPENO IN ('029', '020')
        AND T3.SUBJECTNO IN ('804','807','515','516','517','501','104','108','810','811','812','b75')
      GROUP BY T1.CUSTOMERID,T1.REPORTNO
      UNION ALL
      SELECT
           T1.CUSTOMERID
          ,T1.REPORTNO
          ,MAX(DECODE(T3.SUBJECTNO, '804', T3.VALUETWO, '')) AS A804
          ,MAX(DECODE(T3.SUBJECTNO, '729', T3.VALUETWO, '')) AS A807
          ,MAX(DECODE(T3.SUBJECTNO, '840', T3.VALUETWO, '')) AS A515
          ,MAX(DECODE(T3.SUBJECTNO, '841', T3.VALUETWO, '')) AS A516
          ,MAX(DECODE(T3.SUBJECTNO, '842', T3.VALUETWO, '')) AS A517
          ,MAX(DECODE(T3.SUBJECTNO, '820', T3.VALUETWO, '')) AS A518
          ,MAX(DECODE(T3.SUBJECTNO, '854', T3.VALUETWO, '')) AS A520
          ,MAX(DECODE(T3.SUBJECTNO, '855', T3.VALUETWO, '')) AS A521
          ,MAX(DECODE(T3.SUBJECTNO, '610', T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '1218',T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '1223',T3.VALUETWO, '')) AS A522
      FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT T1     --财报簿;财报,财报簿
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_SHEET T2   --财报表
              ON T1.CUSTOMERID = T2.CUSTOMERID
             AND T1.ACCOUNTINGMONTH = T2.ACCOUNTINGMONTH
             AND T1.REPORTSCOPE = T2.REPORTSCOPE
             AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_ROW T3     --财报行数据;财报数据
              ON T2.SHEETNO = T3.SHEETNO
             AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.REPORTTYPENO IN ('030', '039', '040', '049')
        AND T3.SUBJECTNO IN ('804', '729', '840', '841', '842', '820','854','855','610','1218','1223')
      GROUP BY T1.CUSTOMERID,T1.REPORTNO
      UNION ALL
      SELECT
           T1.CUSTOMERID
          ,T1.REPORTNO
          ,MAX(DECODE(T3.SUBJECTNO, '19d',  T3.VALUETWO, '')) AS A804
          ,MAX(DECODE(T3.SUBJECTNO, '807',  T3.VALUETWO, '')) AS A807
          ,0.0 AS A515
          ,MAX(DECODE(T3.SUBJECTNO, 'z82',  T3.VALUETWO, '')) AS A516
          ,0.0 AS A517
          ,MAX(DECODE(T3.SUBJECTNO, '564',  T3.VALUETWO, '')) AS A518
          ,MAX(DECODE(T3.SUBJECTNO, '19f',  T3.VALUETWO, '')) AS A520
          ,MAX(DECODE(T3.SUBJECTNO, '19e',  T3.VALUETWO, '')) AS A521
          ,MAX(DECODE(T3.SUBJECTNO, '810',  T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '811',  T3.VALUETWO, ''))
          +MAX(DECODE(T3.SUBJECTNO, '812',  T3.VALUETWO, '')) AS A522
      FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT T1    --财报簿;财报,财报簿
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_SHEET T2  --财报表
              ON T1.CUSTOMERID = T2.CUSTOMERID
             AND T1.ACCOUNTINGMONTH = T2.ACCOUNTINGMONTH
             AND T1.REPORTSCOPE = T2.REPORTSCOPE
             AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_ROW T3    --财报行数据;财报数据
              ON T2.SHEETNO = T3.SHEETNO
             AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      WHERE T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
        AND T1.REPORTTYPENO ='019'
        AND T3.SUBJECTNO IN ('19d', '807', 'z82', '564','19f','19e','810','811','812')
      GROUP BY T1.CUSTOMERID,T1.REPORTNO
    ) B
           ON A.CUSTOMERID = B.CUSTOMERID
          AND A.REPORTNO = B.REPORTNO
   \* LEFT JOIN RRP_MDL.O_IOL_ICMS_CUSTOMER_INFO C --客户基本信息

           ON A.CUSTOMERID = C.CUSTOMERID
          AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') *\
    WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.REPORTNO IS NOT NULL
      AND A.ACCOUNTINGMONTH IS NOT NULL
  ) T
  WHERE T.NUM = 1
  ;*/
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


 /*      V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入资产总额';
  V_STARTTIME := SYSDATE;

   MERGE INTO M_CUST_CORP_FIN_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,C.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT FRN
                      WHERE FRN.REPORTPERIOD='Y' \*AND FRN.REPORTSTATUS='Open'*\
                      GROUP BY CUSTOMERID)  C
                     ON C.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO IN ('1903','804')
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID)

  WHEN MATCHED
  THEN UPDATE SET A.AST_TOT_AMT = B.VALUETWO;
   COMMIT;


  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入负债总额';
  V_STARTTIME := SYSDATE;

   MERGE INTO M_CUST_CORP_FIN_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,FRN.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT
                      WHERE REPORTPERIOD='Y' \*AND REPORTSTATUS='Open'*\
                      GROUP BY CUSTOMERID)  FRN
                     ON FRN.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO IN ('2906','807')
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID)
  WHEN MATCHED
  THEN UPDATE SET A.LBY_TOT_AMT = B.VALUETWO;
  COMMIT;


 V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入流动资金总额';
  V_STARTTIME := SYSDATE;


   MERGE INTO M_CUST_CORP_FIN_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,FRN.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT
                      WHERE REPORTPERIOD='Y' \*AND REPORTSTATUS='Open'*\
                      GROUP BY CUSTOMERID)  FRN
                     ON FRN.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO IN ('1171','801')
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID)
  WHEN MATCHED
  THEN UPDATE SET A.LBY_TOT_AMT = B.VALUETWO;
  COMMIT;

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入流动负债总额';
  V_STARTTIME := SYSDATE;

     MERGE INTO M_CUST_CORP_FIN_SUB A
  USING
   ( SELECT FR.SUBJECTNO,FR.VALUETWO,FRN.CUSTOMERID  FROM O_IOL_ICMS_FINA_ROW FR
                 LEFT JOIN O_IOL_ICMS_FINA_SHEET FS
                      ON FS.SHEETNO = FR.SHEETNO
                    AND FS.SHEETTYPE = 'BS'
                 LEFT JOIN (SELECT MAX(REPORTNO) REPORTNO,CUSTOMERID FROM O_IOL_ICMS_FINA_REPORT
                      WHERE REPORTPERIOD='Y' \*AND REPORTSTATUS='Open'*\
                      GROUP BY CUSTOMERID)  FRN
                     ON FRN.REPORTNO = FS.REPORTNO
                     WHERE FR.SUBJECTNO IN ('2281','805')
                     ) B
  ON (A.CUST_ID = B.CUSTOMERID)
  WHEN MATCHED
  THEN UPDATE SET A.LBY_TOT_AMT = B.VALUETWO;
  COMMIT;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
*/


         -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,FIN_RPT_DT,RPT_CYC,COUNT(1)
      FROM M_CUST_CORP_FIN_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID,FIN_RPT_DT,RPT_CYC
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

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

  END ETL_INIT_M_CUST_CORP_FIN_SUB;
/

