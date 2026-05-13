CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_CORP_FIN_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_CORP_FIN_SUB
  *  功能描述：监管集市对于本行需要收集财务信息的对公客户，报送财务报表相关信息。
  *  创建日期：20220610
  *  开发人员：HULIJUAN
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
  *             7    20240906  YJY      调整客户风险资产总额、负债总额、税前利润的逻辑
  *             8    20260206  LIP      调整报表取数逻辑，按照业务口径当期末值为空或0时取期初值
  *                                     因客户风险字段的取数口径和原字段一致，将客户风险的字段赋值逻辑去除
  **************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;               --处理步骤
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CUST_CORP_FIN_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_CORP_FIN_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CUST_CORP_FIN_SUB T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公客户财务信息子表信息';
  V_STARTTIME := SYSDATE;
  /*INSERT INTO RRP_MDL.M_CUST_CORP_FIN_SUB
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,CUST_ID                --客户编号
    ,FIN_RPT_ID             --财务报表编号
    ,FIN_RPT_DT             --财务报表日期
    ,RPT_CYC                --报表周期
    ,AUDIT_FLG              --审计标志
    ,AUDIT_CO_NM            --审计单位
    ,RPT_CLBR               --报表口径
    ,CUR                    --币种
    ,AST_TOT_AMT            --资产总额
    ,LBY_TOT_AMT            --负债总额
    ,PRE_TAX_PROFIT         --税前利润
    ,INCM_TAX               --所得税
    ,NET_PROFIT             --净利润
    ,MAIN_BIZ_INCOME        --主营业务收入
    ,CASH_NET_AMT           --现金流量净额
    ,IVNT                   --存货
    ,RECV_ACC_VAL           --应收账款
    ,OTH_RECV               --其他应收款
    ,CURR_AST_TOT_AMT       --流动资产总额
    ,CURR_LBY_TOT_AMT       --流动负债总额
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,AST_TOT_AMT_CRRS       --资产总额-客户风险
    ,LBY_TOT_AMT_CRRS       --负债总额-客户风险
    ,RPT_DT                 --报表日期-客户风险
    ,CURR_AST_TOT_AMT_CRRS  --流动资产总额-客户风险
    ,CURR_LBY_TOT_AMT_CRRS  --流动负债总额-客户风险
    ,PRE_TAX_PROFIT_CRRS    --税前利润-客户风险
    ,MAIN_BIZ_INCOME_CRRS   --主营业务收入-客户风险
    ,RECV_ACC_VAL_CRRS      --应收账款-客户风险
    ,OTH_RECV_CRRS          --其他应收款-客户风险
    ,RPT_CYC_CRRS           --报表周期-客户风险
    )
  WITH JT_CWBB AS --直取
    (SELECT \*+MATERIALIZE*\
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
       FROM (SELECT C.CUSTOMERID                AS CUST_ID      --客户编号
                   ,FR.SUBJECTNO                AS FIN_RPT_ID   --财务报表编号
                   ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')  AS FIN_RPT_DT  --财务报表日期
                   ,C.REPORTPERIOD              AS RPT_CYC      --报表周期  --年
                   ,CASE WHEN C.REPORTSCOPE = '01' THEN '02'  --合并报表
                         WHEN C.REPORTSCOPE = '02' THEN '01'  --本部报表
                         WHEN C.REPORTSCOPE = '1'  THEN '02'  --合并报表
                         WHEN C.REPORTSCOPE = '2'  THEN '01'  --本部报表
                         ELSE '99'  --其他
                     END                        AS RPT_CLBR     --报表口径
                   ,'CNY'                       AS CUR          --币种
                   ,FR.VALUETWO                 AS AST_TOT_AMT  --资产总额
                   ,FR.VALUETWO                 AS LBY_TOT_AMT  --负债总额
                   ,C.AUDITFLAG                 AS AUDITFLAG
                   ,C.AUDITINGAGENCY            AS AUDITINGAGENCY
                   ,C.ACCOUNTINGMONTH           AS ACCOUNTINGMONTH
               FROM (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY SHEETNO,SUBJECTNO ORDER BY UPDATEDATE DESC) RN
                       FROM RRP_MDL.O_IOL_ICMS_FINA_ROW T  --财报行数据;财报数据
                      WHERE T.ID_MARK <> 'D'
                        AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FR
               LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_SHEET FS   --财报表
                           WHERE FS.SHEETTYPE IN ('BS','PS','CFS')
                             AND FS.ID_MARK <> 'D'
                             AND FS.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FS.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FS
                 ON FS.SHEETNO = FR.SHEETNO
                AND FS.RN = 1
              INNER JOIN (SELECT  MAX(REPORTPERIOD)    AS REPORTPERIOD     --报表周期
                                 ,MAX(AUDITFLAG)       AS AUDITFLAG        --审计标志
                                 ,MAX(AUDITINGAGENCY)  AS AUDITINGAGENCY   --审计机构
                                 ,MAX(ACCOUNTINGMONTH) AS ACCOUNTINGMONTH  --会计月
                                 ,MAX(REPORTNO)        AS REPORTNO         --财报号
                                 ,MAX(REPORTSCOPE)     AS REPORTSCOPE      --报表口径
                                 ,MAX(CURRENCY)        AS CURRENCY         --币种
                                 ,CUSTOMERID           AS CUSTOMERID       --客户编号
                            FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT FRN   --财报簿
                           WHERE FRN.ID_MARK <> 'D'
                             AND FRN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FRN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                           GROUP BY CUSTOMERID) C
                 ON C.REPORTNO = FS.REPORTNO
                  \*804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债 801 旧准则流动资产 1171 新准则流动资产
                  805 旧准则流动负债 2281 新准则流动负债 515 旧准则利润总额 6505 新准则利润总额 516 旧准则所得税 6801 新准则所得税
                  517 旧准则净利润 6506 新准则净利润 501 旧主营业务收入 801308 新主营业务收入 5171 旧准则现金流量净额
                  7011 新准则现金流量净额 104 旧应收账款 1122 新应收账款 108 其他应收款 1221 其他应收款*\
              WHERE FR.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801','517',
                                     '6506','501','801308','5171','7011','104','1122','108','1221')
                AND FR.RN = 1) T),
  JT_CWBB_CRRS_BS AS --直取
    (SELECT \*+MATERIALIZE*\
            T.CUST_ID           --客户编号
           ,T.FIN_RPT_ID        --财务报表编号
           ,T.FIN_RPT_DT        --财务报表日期
           ,T.RPT_CYC           --报表周期
           ,T.RPT_CLBR          --报表口径
           ,T.CUR               --币种
           ,T.AST_TOT_AMT       --资产总额
           ,T.LBY_TOT_AMT       --负债总额
           ,T.AUDITFLAG         --审计标志
           ,T.AUDITINGAGENCY    --审计机构
           ,T.ACCOUNTINGMONTH   --会计月
       FROM (SELECT C.CUSTOMERID             AS CUST_ID           --客户编号
                   ,FR.SUBJECTNO             AS FIN_RPT_ID        --财务报表编号
                   ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')  AS FIN_RPT_DT        --财务报表日期
                   ,C.REPORTPERIOD           AS RPT_CYC           --报表周期
                   ,CASE WHEN C.REPORTSCOPE = '1' THEN '02'       --合并报表
                         WHEN C.REPORTSCOPE = '2' THEN '01'       --本部报表
                         ELSE '99'  --其他
                     END                     AS RPT_CLBR          --报表口径
                   ,'CNY'                    AS CUR               --币种
                   ,FR.VALUETWO              AS AST_TOT_AMT       --资产总额
                   ,FR.VALUETWO              AS LBY_TOT_AMT       --负债总额
                   ,C.AUDITFLAG              AS AUDITFLAG         --审计标志
                   ,C.AUDITINGAGENCY         AS AUDITINGAGENCY    --审计机构
                   ,C.ACCOUNTINGMONTH        AS ACCOUNTINGMONTH   --会计月
               FROM (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY SHEETNO,SUBJECTNO ORDER BY UPDATEDATE DESC) RN
                       FROM RRP_MDL.O_IOL_ICMS_FINA_ROW T  --财报行数据;财报数据
                      WHERE T.ID_MARK <> 'D'
                        AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FR
               LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_SHEET FS --财报表
                           WHERE FS.SHEETTYPE = 'BS' --BS 资产负债表
                             AND FS.ID_MARK <> 'D'
                             AND FS.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FS.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))FS
                 ON FS.SHEETNO = FR.SHEETNO
                AND FS.RN = 1
              INNER JOIN (SELECT  REPORTPERIOD       --报表周期
                                  ,AUDITFLAG          --审计标志
                                  ,AUDITINGAGENCY     --审计机构
                                  ,ACCOUNTINGMONTH    --会计月
                                  ,REPORTNO           --财报号
                                  ,REPORTSCOPE        --报表口径
                                  ,CURRENCY           --币种
                                  ,CUSTOMERID         --客户编号
                                  ,ROW_NUMBER() OVER(PARTITION BY CUSTOMERID ORDER BY ACCOUNTINGMONTH DESC,INPUTDATE DESC NULLS LAST) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT FRN   --财报簿;财报,财报簿(每位客户可以拥有多个财报簿;每个财报簿拥有多个财报表,如资产负债表,现金流量表)
                           WHERE FRN.ID_MARK <> 'D'
                             AND FRN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FRN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))  C
                 ON C.REPORTNO = FS.REPORTNO
                AND C.RN = 1
                 \*804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债 801 旧准则流动资产 1171 新准则流动资产
                 805 旧准则流动负债 2281 新准则流动负债 515 旧准则利润总额 6505 新准则利润总额 516 旧准则所得税 6801 新准则所得税
                 517 旧准则净利润 6506 新准则净利润 501 旧主营业务收入 801308 新主营业务收入 5171 旧准则现金流量净额
                 7011 新准则现金流量净额 104 旧应收账款 1122 新应收账款 108 其他应收款 1221 其他应收款*\
              WHERE FR.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801',
                                    \*'517','6506','501','801308','5171','7011',*\'104','1122','108','1221')
                AND FR.RN = 1) T),
  JT_CWBB_CRRS_PS AS --直取
    (SELECT \*+MATERIALIZE*\
            T.CUST_ID           --客户编号
           ,T.FIN_RPT_ID        --财务报表编号
           ,T.FIN_RPT_DT        --财务报表日期
           ,T.RPT_CYC           --报表周期
           ,T.RPT_CLBR          --报表口径
           ,T.CUR               --币种
           ,T.AST_TOT_AMT       --资产总额
           ,T.LBY_TOT_AMT       --负债总额
           ,T.AUDITFLAG         --审计标志
           ,T.AUDITINGAGENCY    --审计机构
           ,T.ACCOUNTINGMONTH   --会计月
       FROM (SELECT C.CUSTOMERID        AS CUST_ID      --客户编号
                   ,FR.SUBJECTNO        AS FIN_RPT_ID   --财务报表编号
                   ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD')  AS FIN_RPT_DT  --财务报表日期
                   ,C.REPORTPERIOD      AS RPT_CYC      --报表周期  --年
                   ,CASE WHEN C.REPORTSCOPE = '1' THEN '02'  --合并报表
                         WHEN C.REPORTSCOPE = '2' THEN '01'  --本部报表
                         ELSE '99'  --其他
                     END                AS RPT_CLBR     --报表口径
                   ,'CNY'               AS CUR          --币种
                   ,FR.VALUETWO         AS AST_TOT_AMT  --资产总额
                   ,FR.VALUETWO         AS LBY_TOT_AMT  --负债总额
                   ,C.AUDITFLAG         AS AUDITFLAG    --审计标志
                   ,C.AUDITINGAGENCY    AS AUDITINGAGENCY  --审计机构
                   ,C.ACCOUNTINGMONTH   AS ACCOUNTINGMONTH --会计月
               FROM (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY SHEETNO,SUBJECTNO ORDER BY UPDATEDATE DESC) RN
                       FROM RRP_MDL.O_IOL_ICMS_FINA_ROW T    --财报行数据;财报数据
                      WHERE T.ID_MARK <> 'D'
                        AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FR
               LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER (PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_SHEET FS --财报表
                           WHERE FS.SHEETTYPE = 'PS' --PS 利润表
                             AND FS.ID_MARK <> 'D'
                             AND FS.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FS.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FS
                 ON FS.SHEETNO = FR.SHEETNO
                AND FS.RN = 1
              INNER JOIN (SELECT \*MAX(REPORTPERIOD) REPORTPERIOD ,MAX(AUDITFLAG) AUDITFLAG,MAX(AUDITINGAGENCY) AUDITINGAGENCY,
                                 MAX(ACCOUNTINGMONTH),MAX(REPORTNO) REPORTNO,MAX(ACCOUNTINGMONTH) ACCOUNTINGMONTH,
                                 MAX(REPORTSCOPE) REPORTSCOPE,MAX(CURRENCY) CURRENCY,CUSTOMERID*\
                                 --MOD BY YJY 20240906  按照报表日期和更新日期排序，取当前最新财报数据
                                  REPORTPERIOD       --报表周期
                                 ,AUDITFLAG          --审计标志
                                 ,AUDITINGAGENCY     --审计机构
                                 ,ACCOUNTINGMONTH    --会计月
                                 ,REPORTNO           --财报号
                                 ,REPORTSCOPE        --报表口径
                                 ,CURRENCY           --币种
                                 ,CUSTOMERID         --客户编号
                                 ,ROW_NUMBER() OVER(PARTITION BY CUSTOMERID ORDER BY ACCOUNTINGMONTH DESC,INPUTDATE DESC NULLS LAST) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT FRN  --财报簿;财报,财报簿(每位客户可以拥有多个财报簿;每个财报簿拥有多个财报表,如资产负债表,现金流量表)
                           WHERE FRN.ID_MARK <> 'D'
                             AND FRN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FRN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))  C
                 ON C.REPORTNO = FS.REPORTNO
                AND C.RN = 1
                 \*804-旧准则总资产 807-旧准则总负这 1903-新准则总资产 2906-新准则总负债 801 旧准则流动资产 1171 新准则流动资产
                 805 旧准则流动负债 2281 新准则流动负债 515 旧准则利润总额 6505 新准则利润总额 516 旧准则所得税 6801 新准则所得税
                 517 旧准则净利润 6506 新准则净利润 501 旧主营业务收入 801308 新主营业务收入 5171 旧准则现金流量净额
                 7011 新准则现金流量净额 104 旧应收账款 1122 新应收账款 108 其他应收款 1221 其他应收款*\
              WHERE FR.SUBJECTNO IN (\*'804','807','1903','2906','1171','801','2281','805',*\
                                     '515','6505','516','6801','517','6506','501','801308'
                                     \*,'5171','7011',*\\*'104','1122','108','1221'*\)
                AND FR.RN = 1) T),
  JT_CWBB_CRRS_CFS AS --直取
    (SELECT \*+MATERIALIZE*\
            T.CUST_ID           --客户编号
           ,T.FIN_RPT_ID        --财务报表编号
           ,T.FIN_RPT_DT        --财务报表日期
           ,T.RPT_CYC           --报表周期
           ,T.RPT_CLBR          --报表口径
           ,T.CUR               --币种
           ,T.AST_TOT_AMT       --资产总额
           ,T.LBY_TOT_AMT       --负债总额
           ,T.AUDITFLAG         --审计标志
           ,T.AUDITINGAGENCY    --审计机构
           ,T.ACCOUNTINGMONTH   --会计月
       FROM (SELECT C.CUSTOMERID        AS CUST_ID      --客户编号
                   ,FR.SUBJECTNO        AS FIN_RPT_ID   --财务报表编号
                   ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(C.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD') AS FIN_RPT_DT  --财务报表日期
                   ,C.REPORTPERIOD      AS RPT_CYC      --报表周期  --年
                   ,CASE WHEN C.REPORTSCOPE = '1' THEN '02'  --合并报表
                         WHEN C.REPORTSCOPE = '2' THEN '01'  --本部报表
                         ELSE '99'  --其他
                     END                AS RPT_CLBR     --报表口径
                   ,'CNY'               AS CUR          --币种
                   ,FR.VALUETWO         AS AST_TOT_AMT  --资产总额
                   ,FR.VALUETWO         AS LBY_TOT_AMT  --负债总额
                   ,C.AUDITFLAG         AS AUDITFLAG
                   ,C.AUDITINGAGENCY    AS AUDITINGAGENCY
                   ,C.ACCOUNTINGMONTH   AS ACCOUNTINGMONTH
               FROM (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY SHEETNO,SUBJECTNO ORDER BY UPDATEDATE DESC) RN
                       FROM RRP_MDL.O_IOL_ICMS_FINA_ROW T    --财报行数据;财报数据
                      WHERE T.ID_MARK <> 'D'
                        AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) FR
               LEFT JOIN (SELECT REPORTNO,SHEETNO,ROW_NUMBER() OVER(PARTITION BY REPORTNO ORDER BY FS.INPUTDATE DESC) RN
                            FROM RRP_MDL.O_IOL_ICMS_FINA_SHEET FS  --财报表
                           WHERE FS.SHEETTYPE = 'CFS' --CFS	现金流量表
                             AND FS.ID_MARK <> 'D'
                             AND FS.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FS.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))FS
                 ON FS.SHEETNO = FR.SHEETNO
                AND FS.RN = 1
              INNER JOIN (SELECT MAX(REPORTPERIOD)    AS  REPORTPERIOD    --报表周期
                                ,MAX(AUDITFLAG)       AS  AUDITFLAG       --审计标志
                                ,MAX(AUDITINGAGENCY)  AS  AUDITINGAGENCY  --审计机构
                                ,MAX(ACCOUNTINGMONTH) AS  ACCOUNTINGMONTH --会计月
                                ,MAX(REPORTNO)        AS  REPORTNO        --财报号
                                ,MAX(REPORTSCOPE)     AS  REPORTSCOPE     --报表口径
                                ,MAX(CURRENCY)        AS  CURRENCY        --币种
                                ,CUSTOMERID           AS  CUSTOMERID      --客户编号
                            FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT FRN  --财报簿;财报,财报簿(每位客户可以拥有多个财报簿;每个财报簿拥有多个财报表,如资产负债表,现金流量表)
                           WHERE ID_MARK <> 'D'
                             AND FRN.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                             AND FRN.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                           GROUP BY CUSTOMERID) C
                 ON C.REPORTNO = FS.REPORTNO
              WHERE FR.SUBJECTNO IN ('5171','7011') --5171 旧准则现金流量净额  7011 新准则现金流量净额
                AND FR.RN = 1) T)
  SELECT T.DATA_DT               --数据日期
        ,T.LGL_REP_ID            --法人编号
        ,T.CUST_ID               --客户编号
        ,T.FIN_RPT_ID            --财务报表编号
        ,T.FIN_RPT_DT            --财务报表日期
        ,T.RPT_CYC               --报表周期
        ,T.AUDIT_FLG             --审计标志
        ,T.AUDIT_CO_NM           --审计单位
        ,T.RPT_CLBR              --报表口径
        ,T.CUR                   --币种
        ,T.AST_TOT_AMT           --资产总额
        ,T.LBY_TOT_AMT           --负债总额
        ,T.PRE_TAX_PROFIT        --税前利润
        ,T.INCM_TAX              --所得税
        ,T.NET_PROFIT            --净利润
        ,T.MAIN_BIZ_INCOME       --主营业务收入
        ,T.CASH_NET_AMT          --现金流量净额
        ,T.IVNT                  --存货
        ,T.RECV_ACC_VAL          --应收账款
        ,T.OTH_RECV              --其他应收款
        ,T.CURR_AST_TOT_AMT      --流动资产总额
        ,T.CURR_LBY_TOT_AMT      --流动负债总额
        ,T.DEPT_LINE             --部门条线
        ,T.DATA_SRC              --数据来源
        ,T.AST_TOT_AMT_CRRS      --资产总额-客户风险
        ,T.LBY_TOT_AMT_CRRS      --负债总额-客户风险
        ,T.RPT_DT                --报表日期-客户风险
        ,T.CURR_AST_TOT_AMT_CRRS --流动资产总额-客户风险
        ,T.CURR_LBY_TOT_AMT_CRRS --流动负债总额-客户风险
        ,T.PRE_TAX_PROFIT_CRRS   --税前利润-客户风险
        ,T.MAIN_BIZ_INCOME_CRRS  --主营业务收入-客户风险
        ,T.RECV_ACC_VAL_CRRS     --应收账款-客户风险
        ,T.OTH_RECV_CRRS         --其他应收款-客户风险
        ,T.RPT_CYC_CRRS          --报表周期-客户风险
    FROM (
    SELECT V_P_DATE                           AS DATA_DT               --数据日期
          ,'9999'                             AS LGL_REP_ID            --法人编号
          ,T1.CUST_ID                         AS CUST_ID               --客户编号
          ,T1.FIN_RPT_ID                      AS FIN_RPT_ID            --财务报表编号
          ,T1.FIN_RPT_DT                      AS FIN_RPT_DT            --财务报表日期
          ,CASE WHEN SUBSTR(T13.FIN_RPT_DT,5,2) = '12' THEN 'Y'
                WHEN SUBSTR(T13.FIN_RPT_DT,5,2) = '06' THEN 'H'
                WHEN SUBSTR(T13.FIN_RPT_DT,5,2) IN ('03','09') THEN 'Q'
                ELSE 'M'
            END                               AS RPT_CYC               --报表周期
          ,CASE WHEN T1.AUDITFLAG = '1' THEN 'Y'
                ELSE 'N'
            END                               AS AUDIT_FLG             --审计标志
          ,T1.AUDITINGAGENCY                  AS AUDIT_CO_NM           --审计单位
          ,T1.RPT_CLBR                        AS RPT_CLBR              --报表口径
          ,T1.CUR                             AS CUR                   --币种
          ,NVL(T13.AST_TOT_AMT,0)             AS AST_TOT_AMT           --资产总额
          ,NVL(T14.AST_TOT_AMT,0)             AS LBY_TOT_AMT           --总负债
          ,NVL(T6.AST_TOT_AMT,0)              AS PRE_TAX_PROFIT        --税前利润
          ,NVL(T7.AST_TOT_AMT,0)              AS INCM_TAX              --所得税
          ,NVL(T8.AST_TOT_AMT,0)              AS NET_PROFIT            --净利润
          ,NVL(T9.AST_TOT_AMT,0)              AS MAIN_BIZ_INCOME       --主营业务收入
          ,NVL(T10.AST_TOT_AMT,0)             AS CASH_NET_AMT          --现金流量净额
          ,NULL                               AS IVNT                  --存货
          ,NVL(T19.AST_TOT_AMT,0)             AS RECV_ACC_VAL          --应收账款
          ,NVL(T20.AST_TOT_AMT,0)             AS OTH_RECV              --其他应收款
          ,NVL(T15.AST_TOT_AMT,0)             AS CURR_AST_TOT_AMT      --流动资产总额
          ,NVL(T16.AST_TOT_AMT,0)             AS CURR_LBY_TOT_AMT      --流动资产总额
          ,NULL                               AS DEPT_LINE             --部门条线
          ,'对公客户财务报表'                 AS DATA_SRC              --数据来源
          ,NVL(T13.AST_TOT_AMT,0)             AS AST_TOT_AMT_CRRS      --资产总额-客户风险
          ,NVL(T14.AST_TOT_AMT,0)             AS LBY_TOT_AMT_CRRS      --负债总额-客户风险
          ,NVL(T13.FIN_RPT_DT,T14.FIN_RPT_DT) AS RPT_DT                --报表日期-客户风险
          ,NVL(T15.AST_TOT_AMT,0)             AS CURR_AST_TOT_AMT_CRRS --流动资产总额-客户风险
          ,NVL(T16.AST_TOT_AMT,0)             AS CURR_LBY_TOT_AMT_CRRS --流动负债总额-客户风险
          ,NVL(T17.AST_TOT_AMT,0)             AS PRE_TAX_PROFIT_CRRS   --税前利润-客户风险
          ,NVL(T18.AST_TOT_AMT,0)             AS MAIN_BIZ_INCOME_CRRS  --主营业务收入-客户风险
          ,NVL(T19.AST_TOT_AMT,0)             AS RECV_ACC_VAL_CRRS     --应收账款-客户风险
          ,NVL(T20.AST_TOT_AMT,0)             AS OTH_RECV_CRRS         --其他应收款-客户风险
          ,CASE WHEN SUBSTR(T13.FIN_RPT_DT,5,2) = '12' 
                THEN 'Y'
                WHEN SUBSTR(T13.FIN_RPT_DT,5,2) = '06'  
                THEN 'H'
                WHEN SUBSTR(T13.FIN_RPT_DT,5,2) IN ('03','09') 
                THEN 'Q'
                ELSE 'M'
            END                               AS RPT_CYC_CRRS          --报表周期-客户风险
          ,ROW_NUMBER() OVER(PARTITION BY T1.CUST_ID ORDER BY T1.ACCOUNTINGMONTH) RN
      FROM JT_CWBB T1
      LEFT JOIN JT_CWBB_CRRS_PS T6 --利润总额
        ON T6.CUST_ID = T1.CUST_ID
       AND T6.FIN_RPT_ID IN ('515','6505')
      LEFT JOIN JT_CWBB_CRRS_PS T7 --所得税
        ON T7.CUST_ID = T1.CUST_ID
       AND T7.FIN_RPT_ID IN ('516','6801')
      LEFT JOIN JT_CWBB_CRRS_PS T8 --净利润
        ON T8.CUST_ID = T1.CUST_ID
       AND T8.FIN_RPT_ID IN ('517','6506')
      LEFT JOIN JT_CWBB_CRRS_PS T9 --主营业务收入
        ON T9.CUST_ID = T1.CUST_ID
       AND T9.FIN_RPT_ID IN ('501','801308')
      LEFT JOIN JT_CWBB_CRRS_CFS T10 --现金流量净额
        ON T10.CUST_ID = T1.CUST_ID
       AND T10.FIN_RPT_ID IN ('5171','7011')
      LEFT JOIN JT_CWBB_CRRS_BS T13 --资产总额-CRRS
        ON T13.CUST_ID = T1.CUST_ID
       AND T13.FIN_RPT_ID IN ('804','1903')
      LEFT JOIN JT_CWBB_CRRS_BS T14 --负债总额-CRRS
        ON T14.CUST_ID = T1.CUST_ID
       AND T14.FIN_RPT_ID IN ('807','2906')
      LEFT JOIN JT_CWBB_CRRS_BS T15 --流动资产-CRRS
        ON T15.CUST_ID = T1.CUST_ID
       AND T15.FIN_RPT_ID IN ('801','1171')
      LEFT JOIN JT_CWBB_CRRS_BS T16 --流动负债-CRRS
        ON T16.CUST_ID = T1.CUST_ID
       AND T16.FIN_RPT_ID IN ('805','2281')
      LEFT JOIN JT_CWBB_CRRS_PS T17 --利润总额-CRRS
        ON T17.CUST_ID = T1.CUST_ID
       AND T17.FIN_RPT_ID IN ('515','6505')
      LEFT JOIN JT_CWBB_CRRS_PS T18 --主营业务收入-CRRS
        ON T18.CUST_ID = T1.CUST_ID
       AND T18.FIN_RPT_ID IN ('501','801308')
      LEFT JOIN JT_CWBB_CRRS_BS T19 --应收账款-CRRS
        ON T19.CUST_ID = T1.CUST_ID
       AND T19.FIN_RPT_ID IN ('104','1122')
      LEFT JOIN JT_CWBB_CRRS_BS T20 --其他应收款-CRRS
        ON T20.CUST_ID = T1.CUST_ID
       AND T20.FIN_RPT_ID IN ('108','1221')) T
   WHERE T.RN = 1;*/
  --MOD BY LIP 20260206 调整对公客户的财务报表取数
  /*INSERT INTO RRP_MDL.M_CUST_CORP_FIN_SUB
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,CUST_ID                --客户编号
    ,FIN_RPT_ID             --财务报表编号
    ,FIN_RPT_DT             --财务报表日期
    ,RPT_CYC                --报表周期
    ,AUDIT_FLG              --审计标志
    ,AUDIT_CO_NM            --审计单位
    ,RPT_CLBR               --报表口径
    ,CUR                    --币种
    ,AST_TOT_AMT            --资产总额
    ,LBY_TOT_AMT            --负债总额
    ,PRE_TAX_PROFIT         --税前利润
    ,INCM_TAX               --所得税
    ,NET_PROFIT             --净利润
    ,MAIN_BIZ_INCOME        --主营业务收入
    ,CASH_NET_AMT           --现金流量净额
    ,IVNT                   --存货
    ,RECV_ACC_VAL           --应收账款
    ,OTH_RECV               --其他应收款
    ,CURR_AST_TOT_AMT       --流动资产总额
    ,CURR_LBY_TOT_AMT       --流动负债总额
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    )
    WITH JT_CWBB_TMP AS (--财报明细
  SELECT T1.CUSTOMERID                              AS CUST_ID           --客户编号
        ,T1.REPORTNO                                AS REPORTNO          --财报号
        ,TO_CHAR(LAST_DAY(TO_DATE(REPLACE(T1.ACCOUNTINGMONTH,'/',''),'YYYYMM')),'YYYYMMDD') AS FIN_RPT_DT  --财务报表日期
        ,CASE WHEN T1.REPORTSCOPE IN ('1','01') THEN '02' --合并报表
              WHEN T1.REPORTSCOPE IN ('2','02') THEN '01' --本部报表
              ELSE '99' --其他
          END                                       AS RPT_CLBR          --报表口径
        ,T1.AUDITFLAG                               AS AUDITFLAG         --审计标志
        --,TRIM(T1.AUDITINGAGENCY)                    AS AUDITINGAGENCY    --审计机构
        ,REGEXP_REPLACE(T1.AUDITINGAGENCY,'[. 、/\]','') AS AUDITINGAGENCY    --审计机构
        ,'CNY'                                      AS CUR               --币种
        ,T2.SHEETTYPE                               AS SHEETTYPE         --报表类型 SheetType 财报页类型
        ,T2.SHEETNO                                 AS SHEETNO           --报表号
        ,T3.SUBJECTNO                               AS SUBJECTNO         --科目
        ,T4.ITEMNAME                                AS SUBJECTNM         --科目名
        ,TO_NUMBER(TRIM(T3.VALUETWO))               AS NEW_VALUE         --期末值
        ,TO_NUMBER(TRIM(T3.VALUEONE))               AS LAST_VALUE        --期初值
        --取客户最新报表对应的报表值
        ,ROW_NUMBER() OVER(PARTITION BY T1.CUSTOMERID,T3.SUBJECTNO ORDER BY T1.ACCOUNTINGMONTH DESC,T1.INPUTDATE DESC NULLS LAST) AS RN --序号
    FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT T1 --财报行数据;财报数据
   INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_SHEET T2 --财报表
      ON T2.REPORTNO = T1.REPORTNO
     AND T2.SHEETTYPE IN ('BS','PS','CFS') --BS 资产负债表 CFS 现金流量表 PS 利润表
     AND T2.ID_MARK <> 'D'
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_ROW T3 --财报行数据;财报数据
      ON T3.SHEETNO = T2.SHEETNO
     \*804-旧准则总资产 807-旧准则总负债 1903-新准则总资产 2906-新准则总负债 801 旧准则流动资产 1171 新准则流动资产
       805 旧准则流动负债 2281 新准则流动负债 515 旧准则利润总额 6505 新准则利润总额 516 旧准则所得税 6801 新准则所得税
       517 旧准则净利润 6506 新准则净利润 501 旧主营业务收入 801308 新主营业务收入 5171 旧准则现金流量净额
       7011 新准则现金流量净额 104 旧应收账款 1122 新应收账款 108 其他应收款 1221 其他应收款 1405存货*\
     \*AND T3.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801','517',
                          '6506','501','801308','5171','7011','104','1122','108','1221','1405')*\
     AND T3.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801','517',
                          '6506','6001','5171','7011','104','1122','108','1221','1405') --MOD BY LIP 20260210 主营业务收入改成取利润表中的第一大类“营业收入”6001
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_CODE_LIBRARY T4 --代码表
      ON T4.ITEMNO = T3.SUBJECTNO
     AND T4.CODENO IN ('GeneralEntNewBS','CompanyCombineCFS','CompanyCombinePS')
     AND T4.ID_MARK <> 'D'
     AND T4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                        AS DATA_DT                --数据日期
        ,'9999'                          AS LGL_REP_ID             --法人编号
        ,T.CUST_ID                       AS CUST_ID                --客户编号
        ,MAX(T.REPORTNO)                 AS FIN_RPT_ID             --财务报表编号
        ,MAX(T.FIN_RPT_DT)               AS FIN_RPT_DT             --财务报表日期
        ,MAX(CASE WHEN SUBSTR(T.FIN_RPT_DT,5,2) = '12' THEN 'Y'
                  WHEN SUBSTR(T.FIN_RPT_DT,5,2) = '06' THEN 'H'
                  WHEN SUBSTR(T.FIN_RPT_DT,5,2) IN ('03','09') THEN 'Q'
                  ELSE 'M'
              END)                       AS RPT_CYC                --报表周期
        ,MAX(CASE WHEN T.AUDITFLAG = '1' THEN 'Y'
                  ELSE 'N'
              END)                       AS AUDIT_FLG              --审计标志
        ,MAX(T.AUDITINGAGENCY)           AS AUDIT_CO_NM            --审计单位
        ,MAX(T.RPT_CLBR)                 AS RPT_CLBR               --报表口径
        ,MAX(T.CUR)                      AS CUR                    --币种
        ,MAX(CASE WHEN T.SUBJECTNO IN ('804','1903') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('804','1903') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS AST_TOT_AMT            --资产总额
        ,MAX(CASE WHEN T.SUBJECTNO IN ('807','2906') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('807','2906') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS LBY_TOT_AMT            --负债总额
        ,MAX(CASE WHEN T.SUBJECTNO IN ('515','6505') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('515','6505') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS PRE_TAX_PROFIT         --税前利润
        ,MAX(CASE WHEN T.SUBJECTNO IN ('516','6801') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('516','6801') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS INCM_TAX               --所得税
        ,MAX(CASE WHEN T.SUBJECTNO IN ('517','6506') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('517','6506') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS NET_PROFIT             --净利润
        \*,MAX(CASE WHEN T.SUBJECTNO IN ('501','801308') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('501','801308') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS MAIN_BIZ_INCOME        --主营业务收入*\
        ,MAX(CASE WHEN T.SUBJECTNO IN ('6001') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('6001') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS MAIN_BIZ_INCOME        --主营业务收入 --MOD BY LIP 20260210 与陈俊文确认了口径，主营业务收入取利润表中的第一大类“营业收入”
        ,MAX(CASE WHEN T.SUBJECTNO IN ('5171','7011') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('5171','7011') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS CASH_NET_AMT           --现金流量净额
        ,MAX(CASE WHEN T.SUBJECTNO IN ('1405') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('1405') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS IVNT                   --存货
        ,MAX(CASE WHEN T.SUBJECTNO IN ('104','1122') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('104','1122') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS RECV_ACC_VAL           --应收账款
        ,MAX(CASE WHEN T.SUBJECTNO IN ('108','1221') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('108','1221') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS OTH_RECV               --其他应收款
        ,MAX(CASE WHEN T.SUBJECTNO IN ('801','1171') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('801','1171') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS CURR_AST_TOT_AMT       --流动资产总额
        ,MAX(CASE WHEN T.SUBJECTNO IN ('805','2281') AND NVL(TRIM(T.NEW_VALUE),0) = 0 THEN T.LAST_VALUE
                  WHEN T.SUBJECTNO IN ('805','2281') THEN T.NEW_VALUE
                  ELSE 0
              END)                       AS CURR_LBY_TOT_AMT       --流动负债总额
        ,NULL                            AS DEPT_LINE              --部门条线
        ,'对公客户财务报表'              AS DATA_SRC               --数据来源
    FROM JT_CWBB_TMP T
   WHERE T.RN = 1 --取客户最新报表对应的报表值，上面的值已经唯一，所以取MAX不会导致信息错位
   GROUP BY T.CUST_ID;*/
  --MOD BY LIP 20260304 因通过上面的逻辑取数会有指标不是最新财报的数据，调整取数逻辑
  INSERT INTO RRP_MDL.M_CUST_CORP_FIN_SUB
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,CUST_ID                --客户编号
    ,FIN_RPT_ID             --财务报表编号
    ,FIN_RPT_DT             --财务报表日期
    ,RPT_CYC                --报表周期
    ,AUDIT_FLG              --审计标志
    ,AUDIT_CO_NM            --审计单位
    ,RPT_CLBR               --报表口径
    ,CUR                    --币种
    ,AST_TOT_AMT            --资产总额
    ,LBY_TOT_AMT            --负债总额
    ,PRE_TAX_PROFIT         --税前利润
    ,INCM_TAX               --所得税
    ,NET_PROFIT             --净利润
    ,MAIN_BIZ_INCOME        --主营业务收入
    ,CASH_NET_AMT           --现金流量净额
    ,IVNT                   --存货
    ,RECV_ACC_VAL           --应收账款
    ,OTH_RECV               --其他应收款
    ,CURR_AST_TOT_AMT       --流动资产总额
    ,CURR_LBY_TOT_AMT       --流动负债总额
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,INPUT_DT               --录入日期 --ADD BY LIP 20260304
    ,RN                     --序号 --ADD BY LIP 20260304
    ,ORG_ID                 --机构号 --ADD BY LIP 20260417
    ,UPDATE_DT              --更新日期 --ADD BY LIP 20260417
    )
    WITH FINA_ROW_TMP AS (--财报指标明细
  SELECT T2.REPORTNO                                AS REPORTNO               --财报号
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('804','1903') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('804','1903') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS AST_TOT_AMT            --资产总额
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('807','2906') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('807','2906') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS LBY_TOT_AMT            --负债总额
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('515','6505') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('515','6505') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS PRE_TAX_PROFIT         --税前利润
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('516','6801') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('516','6801') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS INCM_TAX               --所得税
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('517','6506') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('517','6506') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS NET_PROFIT             --净利润
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('501','6001') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('501','6001') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) --增加旧码值取数 --ADD BY LIP 20260331
                  ELSE 0
              END)                                  AS MAIN_BIZ_INCOME        --主营业务收入
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('5171','7011') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('5171','7011') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS CASH_NET_AMT           --现金流量净额
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('110','1405') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('110','1405') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS IVNT                   --存货
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('104','1122') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('104','1122') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS RECV_ACC_VAL           --应收账款
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('108','1221') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('108','1221') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS OTH_RECV               --其他应收款
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('801','1171') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('801','1171') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS CURR_AST_TOT_AMT       --流动资产总额
        ,MAX(CASE WHEN T3.SUBJECTNO IN ('805','2281') AND NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0) = 0 THEN NVL(TO_NUMBER(TRIM(T3.VALUEONE)),0)
                  WHEN T3.SUBJECTNO IN ('805','2281') THEN NVL(TO_NUMBER(TRIM(T3.VALUETWO)),0)
                  ELSE 0
              END)                                  AS CURR_LBY_TOT_AMT       --流动负债总额
    FROM RRP_MDL.O_IOL_ICMS_FINA_SHEET T2 --财报表
   INNER JOIN RRP_MDL.O_IOL_ICMS_FINA_ROW T3 --财报行数据;财报数据
      ON T3.SHEETNO = T2.SHEETNO
     /*804-旧准则总资产 807-旧准则总负债 1903-新准则总资产 2906-新准则总负债 801 旧准则流动资产 1171 新准则流动资产
       805 旧准则流动负债 2281 新准则流动负债 515 旧准则利润总额 6505 新准则利润总额 516 旧准则所得税 6801 新准则所得税
       517 旧准则净利润 6506 新准则净利润 501 旧主营业务收入 6001营业收入 801308 新主营业务收入 5171 旧准则现金流量净额
       7011 新准则现金流量净额 104 旧应收账款 1122 新应收账款 108 其他应收款 1221 其他应收款 110 旧准存货 1405存货*/
     AND T3.SUBJECTNO IN ('804','807','1903','2906','1171','801','2281','805','515','6505','516','6801','517',
                          '6506','501','6001','5171','7011','104','1122','108','1221','1405','110')
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.O_IOL_ICMS_CODE_LIBRARY T4 --代码表
      ON T4.ITEMNO = T3.SUBJECTNO
     AND T4.CODENO IN ('GeneralEntNewBS','CompanyCombineCFS','CompanyCombinePS')
     AND T4.ID_MARK <> 'D'
     AND T4.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T4.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
   WHERE T2.SHEETTYPE IN ('BS','PS','CFS') --BS 资产负债表 CFS 现金流量表 PS 利润表
     AND T2.ID_MARK <> 'D'
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T2.REPORTNO),
     JT_CWBB_TMP AS (--财报明细
  SELECT T1.CUSTOMERID                                     AS CUST_ID           --客户编号
        ,T1.REPORTNO                                       AS REPORTNO          --财报号
        ,TRIM(T1.INPUTORGID)                               AS ORG_ID            --机构号 --ADD BY LIP 20260417
        ,TO_CHAR(LAST_DAY(TO_DATE(SUBSTR(TRIM(REPLACE(T1.ACCOUNTINGMONTH,'/','')),1,6),'YYYYMM')),'YYYYMMDD') AS FIN_RPT_DT  --财务报表日期
        ,CASE WHEN T1.REPORTSCOPE IN ('1','01') THEN '02' --合并报表
              WHEN T1.REPORTSCOPE IN ('2','02') THEN '01' --本部报表
              ELSE '99' --其他
          END                                              AS RPT_CLBR          --报表口径
        ,T1.AUDITFLAG                                      AS AUDITFLAG         --审计标志
        ,TRIM(REGEXP_REPLACE(T1.AUDITINGAGENCY,'[.	 、/\'||CHR(10)||CHR(13)||']','')) AS AUDITINGAGENCY    --审计机构
        ,T1.INPUTDATE                                      AS INPUTDATE         --录入日期 --ADD BY LIP 20260304
        ,T1.UPDATEDATE                                     AS UPDATE_DT         --更新日期 --ADD BY LIP 20260417
        ,'CNY'                                             AS CUR               --币种
        ,T2.AST_TOT_AMT                                    AS AST_TOT_AMT       --资产总额
        ,T2.LBY_TOT_AMT                                    AS LBY_TOT_AMT       --负债总额
        ,T2.PRE_TAX_PROFIT                                 AS PRE_TAX_PROFIT    --税前利润
        ,T2.INCM_TAX                                       AS INCM_TAX          --所得税
        ,T2.NET_PROFIT                                     AS NET_PROFIT        --净利润
        ,T2.MAIN_BIZ_INCOME                                AS MAIN_BIZ_INCOME   --主营业务收入
        ,T2.CASH_NET_AMT                                   AS CASH_NET_AMT      --现金流量净额
        ,T2.IVNT                                           AS IVNT              --存货
        ,T2.RECV_ACC_VAL                                   AS RECV_ACC_VAL      --应收账款
        ,T2.OTH_RECV                                       AS OTH_RECV          --其他应收款
        ,T2.CURR_AST_TOT_AMT                               AS CURR_AST_TOT_AMT  --流动资产总额
        ,T2.CURR_LBY_TOT_AMT                               AS CURR_LBY_TOT_AMT  --流动负债总额
        ,ROW_NUMBER() OVER(PARTITION BY T1.CUSTOMERID ORDER BY T1.ACCOUNTINGMONTH DESC,T1.INPUTDATE DESC NULLS LAST) AS RN --序号 --取客户最新报表对应的报表值
    FROM RRP_MDL.O_IOL_ICMS_FINA_REPORT T1 --财报行数据;财报数据
   INNER JOIN FINA_ROW_TMP T2 --财报表
      ON T2.REPORTNO = T1.REPORTNO
     AND T2.AST_TOT_AMT > 0 --参考一表通，判断1903为空的则为没业务
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                          AS DATA_DT                --数据日期
        ,'9999'                                            AS LGL_REP_ID             --法人编号
        ,T.CUST_ID                                         AS CUST_ID                --客户编号
        ,T.REPORTNO                                        AS FIN_RPT_ID             --财务报表编号
        ,T.FIN_RPT_DT                                      AS FIN_RPT_DT             --财务报表日期
        ,CASE WHEN SUBSTR(T.FIN_RPT_DT,5,2) = '12' THEN 'Y'
              WHEN SUBSTR(T.FIN_RPT_DT,5,2) = '06' THEN 'H'
              WHEN SUBSTR(T.FIN_RPT_DT,5,2) IN ('03','09') THEN 'Q'
              ELSE 'M'
          END                                              AS RPT_CYC                --报表周期
        ,CASE WHEN T.AUDITFLAG = '1' THEN 'Y'
              ELSE 'N'
          END                                              AS AUDIT_FLG              --审计标志
        ,T.AUDITINGAGENCY                                  AS AUDIT_CO_NM            --审计单位
        ,T.RPT_CLBR                                        AS RPT_CLBR               --报表口径
        ,T.CUR                                             AS CUR                    --币种
        ,NVL(T.AST_TOT_AMT,0)                              AS AST_TOT_AMT            --资产总额
        ,NVL(T.LBY_TOT_AMT,0)                              AS LBY_TOT_AMT            --负债总额
        ,NVL(T.PRE_TAX_PROFIT,0)                           AS PRE_TAX_PROFIT         --税前利润
        ,NVL(T.INCM_TAX,0)                                 AS INCM_TAX               --所得税
        ,NVL(T.NET_PROFIT,0)                               AS NET_PROFIT             --净利润
        ,NVL(T.MAIN_BIZ_INCOME,0)                          AS MAIN_BIZ_INCOME        --主营业务收入
        ,NVL(T.CASH_NET_AMT,0)                             AS CASH_NET_AMT           --现金流量净额
        ,NVL(T.IVNT,0)                                     AS IVNT                   --存货
        ,NVL(T.RECV_ACC_VAL,0)                             AS RECV_ACC_VAL           --应收账款
        ,NVL(T.OTH_RECV,0)                                 AS OTH_RECV               --其他应收款
        ,NVL(T.CURR_AST_TOT_AMT,0)                         AS CURR_AST_TOT_AMT       --流动资产总额
        ,NVL(T.CURR_LBY_TOT_AMT,0)                         AS CURR_LBY_TOT_AMT       --流动负债总额
        ,NULL                                              AS DEPT_LINE              --部门条线
        ,'对公客户财务报表'                                AS DATA_SRC               --数据来源
        ,TO_CHAR(T.INPUTDATE,'YYYYMMDD')                   AS INPUT_DT               --录入日期 --ADD BY LIP 20260304
        ,T.RN                                              AS RN                     --序号 --ADD BY LIP 20260304
        ,T.ORG_ID                                          AS ORG_ID                 --机构号 --ADD BY LIP 20260417
        ,TO_CHAR(T.UPDATE_DT,'YYYYMMDD')                   AS UPDATE_DT              --更新日期 --ADD BY LIP 20260417
    FROM JT_CWBB_TMP T
   /*WHERE T.RN = 1*/; --取客户最新报表对应的报表值

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    /*WITH TMP1 AS (
  SELECT DATA_DT,CUST_ID,FIN_RPT_DT,RPT_CYC,COUNT(1)
    FROM RRP_MDL.M_CUST_CORP_FIN_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CUST_ID,FIN_RPT_DT,RPT_CYC
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;*/
    WITH TMP1 AS (
  SELECT DATA_DT,CUST_ID,FIN_RPT_ID,FIN_RPT_DT,RPT_CYC,COUNT(1) --增加财报编号为主键字段
    FROM RRP_MDL.M_CUST_CORP_FIN_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CUST_ID,FIN_RPT_ID,FIN_RPT_DT,RPT_CYC
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

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

END ETL_M_CUST_CORP_FIN_SUB;
/

