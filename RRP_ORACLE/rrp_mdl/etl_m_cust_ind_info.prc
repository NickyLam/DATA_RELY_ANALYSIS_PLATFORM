CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_IND_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_IND_INFO
  *  功能描述：监管集市自然人客户基本信息
  *  创建日期：20220607
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INDV_CUST_BASIC_INFO   --个人客户基本信息
  *            IML.PTY_PARTY_CERT_INFO_H  --当事人证件信息历史
  *            IOL.ALBS_BLS_CUST_ALL_AML --黑名单系统供数给反洗钱系统黑名单表
  *
  *  目标表：  M_CUST_IND_INFO --个人客户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期    修改人   修改原因
  *             1    20220507    程序员   首次创建
  *             2    20230512    MW       调整插入日志格式
  *             3    20230705    LYH      增加“居住地行政区划代码_金数"、“发证机关行政区划代码_金数” 两个字段逻辑
  *             4    20230818    LYH      修改“发证机关行政区划代码_金数” 由4位转换为6位
  *             5    20241118    HYF      新增经营性客户类型_网商贷、客户名称_网商贷、个体小微_配置表逻辑
  *             6    20241216    HYF      调整经营性客户类型_网商贷，只取网商贷客户，剔除同零售自营业务共有的客户
  *             7    20250210    HYF      调整经营性客户类型_网商贷，只取网商贷客户，剔除同零售自营和联合网贷非网商贷业务共有的客户
  *             8    20250320    HYF      调整境内外标志
  *             9    20250411    XZY      增加 个体工商户名称、行业从业年限、经营范围描述、注册地址、资产总额
  *             10   20250418    YJY      新增企业证件号码、企业名称
  *             11   20250512    YJY      新增退役军人标志、无营业执照负责人标志
  *             12   20250623    HYF      调整个体小微银监口径和人行口径，修改OPR_CUST_TYP/OPR_CUST_TYP_WSD补充字节小微逻辑
  *             13   20250721    LIP      调整个人客户信息_经营贷款客户类型认定口径
  *             14   20250901    YJY      新增证件签发国家代码字段，方便其他报送模块通过证件类型获取绿卡国籍代码
  *             15   20250923    YJY      修改证件签发国家代码字段：金数个人存款如客户存在辅助证件为绿卡，国别取绿卡中的国别，不取主证件国别
  *             16   20260312    YJY      新增信贷客户类型代码
  *             17   20260415    LIP       农户标志 -的码值判断为否
  *********************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;                            --处理步骤
  V_SQLCOUNT  INTEGER := 0;                            --更新或删除影响的记录数
  V_STARTTIME DATE;                                    --处理开始时间
  V_ENDTIME   DATE;                                    --处理结束时间
  V_STEP_DESC VARCHAR2(1000);                          --处理步骤描述
  V_P_DATE    VARCHAR2(8);                             --跑批数据日期
  V_SQLMSG    VARCHAR2(300);                           --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                           --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CUST_IND_INFO';      --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_IND_INFO';  --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';              --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
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
  EXECUTE IMMEDIATE ('ALTER SESSION ENABLE PARALLEL DML');
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '插入个人客户信息-信贷客户临时表';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_XD_CUST';
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.TMP_XD_CUST NOLOGGING
  SELECT /*+PARALLEL*/
         A.CUST_ID,MIN(A.FIR_DISTR_DT) AS DT
    FROM (SELECT CUST_ID,MIN(FIR_DISTR_DT) FIR_DISTR_DT
            FROM RRP_MDL.ADD_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息静态表
           WHERE FIR_DISTR_DT <> DATE '0001-01-01'
             AND TRIM(CUST_ID) IS NOT NULL
           GROUP BY CUST_ID
           UNION ALL
          SELECT CUST_ID,MIN(FIR_DISTR_DT) FIR_DISTR_DT
            FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息
           WHERE FIR_DISTR_DT <> DATE '0001-01-01'
             AND TRIM(CUST_ID) IS NOT NULL
             AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY CUST_ID
           UNION ALL
          SELECT CUST_ID,MIN(DISTR_DT) FIR_DISTR_DT
            FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO --联合网贷借据信息  保留当年结清及历史未结清
           WHERE TRIM(CUST_ID) IS NOT NULL
             AND DISTR_DT <> DATE '0001-01-01'
             AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY CUST_ID
           UNION ALL
          SELECT CUST_ID,MIN(DISTR_DT) FIR_DISTR_DT
            FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO_CLEAR --联合网贷借据信息 往年已结清
           WHERE TRIM(CUST_ID) IS NOT NULL
            AND DISTR_DT <> DATE '0001-01-01'
            /*AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
          GROUP BY CUST_ID) A
   GROUP BY A.CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*--ADD BY HYF 20250628
  V_STEP := 4;
  V_STEP_DESC := '插入个人客户信息-个体小微_银监配置表GTXW_YJ';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.GTXW_YJ';
  INSERT \*+APPEND PARALLEL*\ INTO RRP_MDL.GTXW_YJ NOLOGGING
    (CUST_ID
    ,CUST_NAME
    ,OPR_CUST_TYP_ZJXW
    )
  WITH TMP1 AS (--除字节小微外的客户号
  SELECT DISTINCT S.CUST_ID
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO S --零售贷款账户信息
   WHERE S.CURRT_BAL <> 0
     AND S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION
  --ADD BY HYF 20250623
  SELECT DISTINCT B.CUST_ID
   FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B --联合网贷借据信息
  WHERE B.CURRT_BAL <> 0
    AND B.STD_PROD_ID NOT IN ('202020200001','202020100001','202020200004') --剔除字节小微贷
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT \*+PARALLEL*\DISTINCT
         A.CUST_ID            AS CUST_ID
        ,T.CORP_NAME          AS CUST_NAME
        ,CASE WHEN D.INDV_BUS_FLG = '1' AND TRIM(T.CORP_NAME) IS NOT NULL THEN 'A' --个体工商户
              WHEN D.SM_BUS_OWNER_FLG = '1' AND TRIM(T.CORP_NAME) IS NOT NULL THEN 'B' --小微企业主
              ELSE 'Z'
          END                 AS OPR_CUST_TYP_ZJXW
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND (D.INDV_BUS_FLG = '1' \*个体工商户标志*\ OR D.SM_BUS_OWNER_FLG = '1' \*小微企业主标志*\)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_INDV_CUST_CORP_H T
      ON T.CUST_ID = A.CUST_ID
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP1 T1
      ON T1.CUST_ID = A.CUST_ID
   WHERE T1.CUST_ID IS NULL --取不在字节小微业务的客户 ADD BY HYF 20250623
     AND A.STD_PROD_ID IN ('202020200001') --只取字节小微贷
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY HYF 20241118
  V_STEP := 5;
  V_STEP_DESC := '插入个人客户信息-个体小微_人行配置表GTXW_DJZ';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.GTXW_DJZ';
  INSERT \*+APPEND PARALLEL*\ INTO RRP_MDL.GTXW_DJZ NOLOGGING
    (CUST_ID
    ,CUST_NAME
    ,OPR_CUST_TYP_WSD
    ,OPR_CUST_TYP_WSD_RH
    )
  WITH TMP1 AS (
  SELECT SERNO SERIALNO,COMPANYINFONAME
    FROM RRP_MDL.O_IOL_ICMS_MYBK_CS_EXTENT_INFO --网商贷初审扩展信息
   WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT SERIALNO,COMPANYINFONAME
    FROM RRP_MDL.O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO --网商贷助贷初审扩展信息
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT SERIALNO,COMPANYINFONAME
    FROM RRP_MDL.O_IOL_ICMS_MYBKZQ_CS_EXTENT_INFO --网商贷债权直转初审数据信息
   WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP2 AS (
  SELECT APP.CUST_ID
         ,TA.COMPANYINFONAME
         ,ROW_NUMBER() OVER(PARTITION BY APP.CUST_ID ORDER BY APP.APPL_DT DESC) AS RN --取最新申请
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_APPL_INFO APP  --联合网贷申请信息
   INNER JOIN TMP1 TA
      ON TA.SERIALNO = APP.LOAN_APPL_FLOW_NUM
   WHERE APP.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP3 AS (
  SELECT DISTINCT S.CUST_ID
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO S  --零售贷款账户信息
   WHERE S.CURRT_BAL <> 0
     AND S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION
  --ADD BY HYF 20250210
  SELECT DISTINCT B.CUST_ID
   FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B  --联合网贷借据信息
  WHERE B.CURRT_BAL <> 0
    AND B.STD_PROD_ID NOT IN ('202020100001','202020200004','202020200001') --剔除网商贷 ADD BY 20250623
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT \*+PARALLEL*\
         DISTINCT
         A.CUST_ID            AS CUST_ID
        ,T.COMPANYINFONAME    AS CUST_NAME
        ,CASE WHEN D.INDV_BUS_FLG = '1' AND T.CUST_ID IS NOT NULL AND TRIM(T.COMPANYINFONAME) IS NOT NULL THEN 'A' --个体工商户
              WHEN D.SM_BUS_OWNER_FLG = '1' THEN 'B' --小微企业主
              ELSE 'Z'
          END                 AS OPR_CUST_TYP_WSD
        ,CASE WHEN D.INDV_BUS_FLG = '1' AND T.CUST_ID IS NOT NULL AND TRIM(T.COMPANYINFONAME) IS NOT NULL THEN 'A' --个体工商户
              WHEN D.SM_BUS_OWNER_FLG = '1' AND TRIM(T.COMPANYINFONAME) LIKE '%公司%' THEN 'B' --小微企业主
              ELSE 'Z'
          END                 AS OPR_CUST_TYP_WSD_RH
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
   INNER JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D  --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND (D.INDV_BUS_FLG = '1' \*个体工商户标志*\ OR D.SM_BUS_OWNER_FLG = '1' \*小微企业主标志*\)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP2 T
      ON T.CUST_ID = A.CUST_ID
     AND T.RN = 1
    LEFT JOIN TMP3 T1
      ON T1.CUST_ID = A.CUST_ID
   WHERE T1.CUST_ID IS NULL --取不在网商贷业务的客户 ADD BY HYF 20241216
     AND A.STD_PROD_ID IN ('202020100001','202020200004') --只取网商贷 ADD BY 20250623
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  --MOD BY LIP 20250721 调整个人客户信息_经营贷款客户类型认定口径
  V_STEP := 4;
  V_STEP_DESC := '插入个人客户信息_经营贷款客户类型数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_CUST_IND_INFO_TMP';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_CUST_IND_INFO_TMP NOLOGGING
    (CUST_ID              --客户号
    ,OPR_CUST_TYP         --经营性客户类型
    ,CUST_NAME_WSD        --客户名称_网商贷
    ,CUST_NAME_YJ         --客户名称_银监
    ,OPR_CUST_TYP_WSD     --经营性客户类型_网商贷
    ,OPR_CUST_TYP_YJ      --经营性客户类型_银监
    ,STD_PROD_ID          --产品编号_区分网商贷和其他产品
    )
  WITH TMP1 AS (--网商贷贷款申请流水号对应的企业名称相关信息
  SELECT /*+MATERIALIZE*/SERNO SERIALNO,COMPANYINFONAME FROM RRP_MDL.O_IOL_ICMS_MYBK_CS_EXTENT_INFO --网商贷初审扩展信息
   WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT SERIALNO,COMPANYINFONAME FROM RRP_MDL.O_IOL_ICMS_MYBKZD_CS_EXTENT_INFO --网商贷助贷初审扩展信息
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT SERIALNO,COMPANYINFONAME FROM RRP_MDL.O_IOL_ICMS_MYBKZQ_CS_EXTENT_INFO --网商贷债权直转初审数据信息
   WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP2 AS (--网商贷的企业名称相关信息
  SELECT /*+MATERIALIZE*/APP.CUST_ID,TA.COMPANYINFONAME,
         ROW_NUMBER() OVER(PARTITION BY APP.CUST_ID ORDER BY APP.APPL_DT DESC) AS RN --取最新申请
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_APPL_INFO APP --联合网贷申请信息
   INNER JOIN TMP1 TA
      ON TA.SERIALNO = APP.LOAN_APPL_FLOW_NUM
   WHERE TRIM(APP.CUST_ID) IS NOT NULL
     AND APP.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP3 AS (--除网商贷 字节小微外的客户数据
  SELECT /*+MATERIALIZE*/DISTINCT S.CUST_ID
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO S --零售贷款账户信息
   WHERE S.CURRT_BAL <> 0
     AND S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  --ADD BY HYF 20250210
  SELECT DISTINCT B.CUST_ID
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B --联合网贷借据信息
    LEFT JOIN RRP_MDL.CODE_MAP TA --互联网经营贷款客户需特殊映射的数据
      ON TA.SRC_VALUE_CODE = B.STD_PROD_ID
     AND TA.SRC_CLASS_CODE = 'STD0002'
     AND TA.TAR_CLASS_CODE = 'OPR_CUST_TYP'
     AND TA.MOD_FLG = 'MDM'
   WHERE TA.SRC_VALUE_CODE IS NULL
     AND B.CURRT_BAL <> 0
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+PARALLEL*/
         A.CUST_ID                        AS CUST_ID              --客户号
        ,MAX(CASE WHEN D.INDV_BUS_FLG = '1' THEN 'A'
                  WHEN D.SM_BUS_OWNER_FLG = '1' THEN 'B'
              END)                        AS OPR_CUST_TYP         --经营性客户类型
        ,MAX(CASE WHEN TA.TAR_VALUE_CODE = 'WSD' THEN TRIM(T.COMPANYINFONAME) END) AS CUST_NAME_WSD        --客户名称_网商贷
        ,MAX(CASE WHEN TA.TAR_VALUE_CODE = 'YJ' THEN TRIM(T2.CORP_NAME) END) AS CUST_NAME_YJ         --客户名称_银监
        ,MAX(CASE WHEN TA.TAR_VALUE_CODE = 'WSD' AND D.INDV_BUS_FLG = '1' AND T.CUST_ID IS NOT NULL
                       AND TRIM(T.COMPANYINFONAME) IS NOT NULL THEN 'A' --个体工商户
                  WHEN TA.TAR_VALUE_CODE = 'WSD' AND D.SM_BUS_OWNER_FLG = '1' AND T.CUST_ID IS NOT NULL 
                       AND TRIM(T.COMPANYINFONAME) IS NOT NULL --按照业务20250718【监管报送个体工商户、小微企业主问题讨论_会议纪要】邮件，网商贷也加上名称不为空判断
                  THEN 'B' --小微企业主
                  WHEN TA.TAR_VALUE_CODE = 'WSD' THEN 'Z'
              END)                        AS OPR_CUST_TYP_WSD     --经营性客户类型_网商贷
        ,MAX(CASE WHEN TA.TAR_VALUE_CODE = 'YJ' AND D.INDV_BUS_FLG = '1' AND TRIM(T2.CORP_NAME) IS NOT NULL THEN 'A' --个体工商户
                  WHEN TA.TAR_VALUE_CODE = 'YJ' AND D.SM_BUS_OWNER_FLG = '1' AND TRIM(T2.CORP_NAME) IS NOT NULL THEN 'B' --小微企业主
                  WHEN TA.TAR_VALUE_CODE = 'YJ' THEN 'Z'
              END)                        AS OPR_CUST_TYP_YJ      --经营性客户类型_银监
        ,LISTAGG(DISTINCT TA.TAR_VALUE_CODE,';') WITHIN GROUP(ORDER BY TA.TAR_VALUE_CODE) AS STD_PROD_ID --产品编号_区分网商贷和其他产品
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
   INNER JOIN RRP_MDL.CODE_MAP TA --互联网经营贷款客户需特殊映射的数据
      ON TA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TA.SRC_CLASS_CODE = 'STD0002'
     AND TA.TAR_CLASS_CODE = 'OPR_CUST_TYP'
     AND TA.MOD_FLG = 'MDM'
   INNER JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO D --个人客户基本信息
      ON D.CUST_ID = A.CUST_ID
     AND (D.INDV_BUS_FLG = '1' /*个体工商户标志*/ OR D.SM_BUS_OWNER_FLG = '1' /*小微企业主标志*/)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN TMP2 T --网商贷的企业名称相关信息
      ON T.CUST_ID = A.CUST_ID
     AND T.RN = 1
    LEFT JOIN TMP3 T1 --除网商贷 字节小微外的客户数据
      ON T1.CUST_ID = A.CUST_ID
    LEFT JOIN RRP_MDL.O_IML_PTY_INDV_CUST_CORP_H T2 --字节小微企业名称信息
      ON T2.CUST_ID = A.CUST_ID
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.CUST_ID IS NULL --取不在网商贷业务的客户 ADD BY HYF 20241216
     --AND A.STD_PROD_ID IN ('202020100001','202020200004','202020200001') --网商贷,202020200001 字节小微
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 5;
  V_STEP_DESC := '插入个人客户信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+ APPEND PARALLEL */ INTO RRP_MDL.M_CUST_IND_INFO NOLOGGING
    (DATA_DT                       --数据日期
    ,LGL_REP_ID                    --法人编号
    ,ORG_ID                        --机构编号
    ,CUST_ID                       --客户编号
    ,CUST_NM                       --客户名称
    ,CUST_ENG_NM                   --客户英文名称
    ,CTRY_CD                       --国家代码
    ,RSDNT_FLG                     --居民标志
    ,CUST_BLNG_LAND_AREA_CD        --客户所属地行政区划代码
    ,CRDL_TYP                      --证件类型
    ,CRDL_NO                       --证件号码
    ,ISU_CERT_OFF_AREA_CD          --发证机关行政区划代码
    ,ISU_CERT_OFF_AREA_CD_BFD      --发证机关行政区划代码  ADD BY LYH 20230705，人行地区代码变更
    ,CRDL_EFF_DT                   --证件生效日期
    ,CRDL_EXP_DT                   --证件失效日期
    ,CRDL_ADDR                     --证件地址
    ,PHONE_NUM                     --手机号码
    ,ETHNIC                        --民族
    ,GENDER                        --性别
    ,BIRTH_DT                      --出生日期
    ,MARRIAGE_STAT                 --婚姻状况
    ,HIGH_DEGREE                   --最高学历
    ,CUST_BLNG_IDY                 --客户所属行业
    ,OCCUP                         --职业
    ,TITLE                         --职称
    ,JOB                           --职务
    ,IND_YEAR_INCOME               --个人年收入
    ,FAMILY_YEAR_INCOME            --家庭年收入
    ,CO_NM                         --单位名称
    ,CO_CHAR                       --单位性质
    ,CO_ADDR                       --单位地址
    ,CO_TEL                        --单位电话
    ,RSDNC_CTRY_CD                 --居住地国家代码
    ,RSDNC_ADDR                    --居住地址
    ,RSDNC_AREA_CD                 --居住地行政区划代码
    ,RSDNC_AREA_CD_BFD             --居住地行政区划代码_金数 ADD BY LYH 20230705，人行地区代码变更
    ,OPR_CUST_TYP                  --经营性客户类型
    ,BANK_EMP_FLG                  --本行员工标志
    ,FARM_FLG                      --农户标志
    ,CONT_SIDE_FARM_FLG            --承包方农户标志
    ,BLIST_FLG                     --上黑名单标志
    ,BLIST_DT                      --上黑名单日期
    ,BANK_SENIOR_FLG               --银行高管标志
    ,REL_PTY_FLG                   --关联方标志
    ,AGR_REL_LOAN_CERT_ISU_NUM     --发放支农贷款证数量
    ,ECON_ARCH_FLG                 --经济档案标志
    ,CRDT_FLG                      --信用户标志
    ,JUR_FLG                       --辖内标志
    ,OPEN_EBANK_FLG                --开通网银标志
    ,DISABLED_FLG                  --残疾人标志
    ,LOW_INCM_FLG                  --低保户标志
    ,CUST_CRDT_RTG                 --客户信用评级
    ,CUST_CR_RTG_TOT_GRD           --客户信用评级总等级数
    ,CUST_STAT                     --客户状态
    ,FIRST_ESTBL_CRDT_REL_DT       --首次建立信贷关系日期
    ,DEPT_LINE                     --部门条线
    ,DATA_SRC                      --数据来源
    ,BIO_FLG                       --境内外标志
    ,AGE                           --年龄
    ,DIST_CD                       --行政区划代码
    ,FAMILY_MON_INCO               --家庭月收入
    ,INDV_MON_INCO                 --个人月收入
    ,OPR_CUST_TYP_WSD              --经营性客户类型_网商贷  ADD BY HYF 20241118
    ,CUST_NM_WSD                   --客户名称_网商贷 ADD BY HYF 20241118
    ,INDV_BUS_NAME                 --个体工商户名称 ADD BY XZY 20250411
    ,INDUS_OBTAIN_EMPLY_YEARS      --行业从业年限 ADD BY XZY 20250411
    ,MANG_RANGE_DESCB              --经营范围描述 ADD BY XZY 20250411
    ,RGST_ADDR                     --注册地址 ADD BY XZY 20250411
    ,ASSET_TOT                     --资产总额 ADD BY XZY 20250411
    ,CORP_CERT_NO                  --企业证件号码 ADD BY YJY 20250418
    ,CORP_NAME                     --企业名称 ADD BY YJY 20250418
    ,EX_SERVSM_FLG                 --退役军人标志 ADD BY YJY 20250512
    ,NO_BUSLICS_PRC_FLG            --无营业执照负责人标志 ADD BY YJY 20250512
    ,ISSUE_CERT_ORG_CTY_CD         --证件签发国家代码 ADD BY YJY 20250901
    ,CRDT_CUST_TYPE_CD             --信贷客户类型代码 ADD BY YJY 20260312
    )
  SELECT /*+USE_HASH(A,C,T1,F,XZDM,XZDM1,GB1,GB2,GB3,GB4,AREA1,AREA2,AREA3,XZDM2,J,L,,M,BFD1,BFD2,DJZ)*/
         TO_CHAR(A.ETL_DT,'YYYYMMDD')                         AS DATA_DT                       --数据日期
        ,A.LP_ID                                              AS LGL_REP_ID                    --法人编号
        ,A.BELONG_ORG_ID                                      AS ORG_ID                        --机构编号
        ,A.CUST_ID                                            AS CUST_ID                       --客户编号
        ,REPLACE(REPLACE(A.CUST_NAME,'?',''),'？','')         AS CUST_NM                       --客户名称
        ,A.CUST_EN_NAME                                       AS CUST_ENG_NM                   --客户英文名称
        ,A.NATION_CD                                          AS CTRY_CD                       --国家代码
        ,CASE WHEN A.RESDNT_FLG = '0' THEN 'N' ELSE 'Y' END   AS RSDNT_FLG                     --居民标志
        ,A.RG_CD                                              AS CUST_BLNG_LAND_AREA_CD        --客户所属地行政区划代码
        ,CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO) = 18
               AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X')
              THEN '1010'  --身份证
              ELSE A.CERT_TYPE_CD
          END                                                 AS CRDL_TYP                      --证件类型
        ,A.CERT_NO                                            AS CRDL_NO                       --证件号码
        --UPDATE BY LYH 20230818，发证机关行政区划代码 由4位转为6位
        ,TRIM(NVL(XZDM1.TAR_VALUE_CODE,C.LICEN_ISSUE_AUTHO_DIST_CD))
                                                              AS ISU_CERT_OFF_AREA_CD          --发证机关行政区划代码
        ,COALESCE(BFD1.NEW_RH_AREA_CD,XZDM1.TAR_VALUE_CODE,C.LICEN_ISSUE_AUTHO_DIST_CD)
                                                              AS ISU_CERT_OFF_AREA_CD_BFD      --发证机关行政区划代码_金数  ADD BY LYH 20230705，人行地区代码变更
        ,C.CRDL_EFF_DT                                        AS CRDL_EFF_DT                   --证件生效日期
        ,NVL(C.CRDL_EXP_DT,TO_CHAR(A.CERT_EXP_DT,'YYYYMMDD')) AS CRDL_EXP_DT                   --证件失效日期
        ,C.CRDL_ADDR                                          AS CRDL_ADDR                     --证件地址
        ,NVL(TRIM(A.OPEN_ACCT_RSRV_MOBILE_NO),A.CONT_NUM)     AS PHONE_NUM                     --手机号码
        ,CASE WHEN A.NATIONTY_CD = '00'
              THEN NULL
              WHEN A.NATIONTY_CD IN ('58','97')
              THEN '97'
              ELSE CASE WHEN LENGTH(TRIM(A.NATIONTY_CD)) = 2
                        THEN TRIM(A.NATIONTY_CD)
                    END
          END                                                 AS ETHNIC                        --民族
        ,CASE WHEN A.GENDER_CD='1' THEN '1'
              WHEN A.GENDER_CD='2' THEN '2'
              WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=18
              THEN (CASE WHEN MOD(SUBSTR(A.CERT_NO,17,1),2)=1
                         THEN '1'
                         ELSE '2'
                    END)
              WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15
              THEN (CASE WHEN MOD(SUBSTR(A.CERT_NO,15,2),2)=1
                         THEN '1'
                         ELSE '2'
                     END)
              WHEN A.GENDER_CD='0' THEN '0'
              WHEN A.GENDER_CD='9' THEN '9'
          END                                                 AS GENDER                        --性别
        ,CASE WHEN LENGTH(A.CERT_NO)=18 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,8),'^[0-9]+[0-9]$')
               AND SUBSTR(A.CERT_NO,7,2) IN('19','20')
               AND ((SUBSTR(A.CERT_NO,11,2) IN ('01','03','05','07','08','10','12') AND SUBSTR(A.CERT_NO,13,2)<32 AND SUBSTR(A.CERT_NO,13,2)>00)
                   OR (SUBSTR(A.CERT_NO,11,2) IN ('02','04','06','09','11') AND SUBSTR(A.CERT_NO,13,2)<31 AND SUBSTR(A.CERT_NO,13,2)>00))
              THEN SUBSTR(A.CERT_NO,7,8)
              WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,6),'^[0-9]+[0-9]$')
               AND SUBSTR(A.CERT_NO,9,2)<13 AND SUBSTR(A.CERT_NO,9,2)>00 AND SUBSTR(A.CERT_NO,11,2)<32 AND SUBSTR(A.CERT_NO,11,2)>00
              THEN '19'||SUBSTR(A.CERT_NO,7,6)
              ELSE TO_CHAR(A.BIRTH_DT,'YYYYMMDD')
          END                                                 AS BIRTH_DT                      --出生日期
        ,F.TAR_VALUE_CODE                                     AS MARRIAGE_STAT                 --婚姻状况
        ,CASE WHEN TRIM(A.EDU_CD) IN ('00','95','99')
              THEN NULL
              WHEN LENGTH(TRIM(A.EDU_CD)) = 2
              THEN TRIM(A.EDU_CD)
          END                                                 AS HIGH_DEGREE                   --最高学历
        ,CASE WHEN LENGTHB(SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''),0,5)) <= 5  --码值中出现中文等不规范码值处理
               AND A.CORP_BL_INDUTY_TYPE_CD NOT LIKE '%null%'
               AND REGEXP_LIKE(SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''),0,1),'(A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T)$')
              THEN SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''),0,5)
              ELSE NULL
          END                                                 AS CUST_BLNG_IDY                 --客户所属行业
        ,A.CAREER_CD                                          AS OCCUP                         --职业
        ,A.TITLE_CD                                           AS TITLE                         --职称 --MODIFY BY MW 2022/11/04 改为取数仓原值
        ,A.POST_CD                                            AS JOB                           --职务
        ,A.INDV_ANL_INCO                                      AS IND_YEAR_INCOME               --个人年收入
        ,A.FAMILY_ANL_INCO                                    AS FAMILY_YEAR_INCOME            --家庭年收入
        ,A.WORK_UNIT_NAME                                     AS CO_NM                         --单位名称
        ,J.TAR_VALUE_CODE                                     AS CO_CHAR                       --单位性质
        ,A.WORK_UNIT_ADDR                                     AS CO_ADDR                       --单位地址
        ,A.WORK_UNIT_TEL                                      AS CO_TEL                        --单位电话
        ,A.NATION_CD                                          AS RSDNC_CTRY_CD                 --居住地国家代码
        ,NVL(NVL(NVL(TRIM(A.RESDNT_ADDR),TRIM(A.RPR_SITE)),TRIM(A.POSTA_ADDR)),A.FAMILY_ADDR)
                                                              AS RSDNC_ADDR                    --居住地址
        ,CASE WHEN A.RG_CD NOT IN ('000000','999999') AND LENGTH(TRIM(A.RG_CD)) = 6
              THEN COALESCE(GB1.AREA_CD,GB2.AREA_CD,GB3.AREA_CD,GB4.AREA_CD)
              WHEN C.LICEN_ISSUE_AUTHO_DIST_CD NOT IN ('000000','999999') AND LENGTH(TRIM(C.LICEN_ISSUE_AUTHO_DIST_CD)) = 6
              THEN C.LICEN_ISSUE_AUTHO_DIST_CD
              WHEN A.DIST_CD NOT IN ('9999','000000','999999') AND TRIM(A.DIST_CD) IS NOT NULL
               AND XZDM2.TAR_VALUE_CODE IS NOT NULL--部分码值取消导致出现空值，空值取身份证前6
              THEN XZDM2.TAR_VALUE_CODE
              WHEN (CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO) = 18
                          AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X')
                         THEN '1010' --身份证
                         ELSE A.CERT_TYPE_CD
                     END) = '1010'
              /*THEN COALESCE(GB2.TAR_VALUE_CODE,SUBSTR(A.CERT_NO,1,4)||'00')*/ --先取身份证前6位，再取身份证前4位
              THEN COALESCE(AREA1.AREA_CD,AREA2.AREA_CD,AREA3.AREA_CD,SUBSTR(A.CERT_NO,1,2)||'0000')
              ELSE TRIM(NVL(XZDM.TAR_VALUE_CODE,A.RG_CD))
          END                                                 AS RSDNC_AREA_CD                 --居住地行政区划代码
         --地区代码逻辑顺序 数仓地区代码转国标>行政区划代码（4位）转码>截取身份证前6位>截取身份证前4位||00
        ,NVL(BFD2.NEW_RH_AREA_CD,
             CASE WHEN A.RG_CD NOT IN ('000000','999999') AND LENGTH(TRIM(A.RG_CD)) = 6
                  /*THEN A.RG_CD*/
                  THEN COALESCE(GB1.AREA_CD,GB2.AREA_CD,GB3.AREA_CD,GB4.AREA_CD)
                  WHEN C.LICEN_ISSUE_AUTHO_DIST_CD NOT IN ('000000','999999') AND LENGTH(TRIM(C.LICEN_ISSUE_AUTHO_DIST_CD)) = 6
                  THEN C.LICEN_ISSUE_AUTHO_DIST_CD
                  WHEN A.DIST_CD NOT IN ('9999','000000','999999') AND TRIM(A.DIST_CD) IS NOT NULL
                   AND XZDM2.TAR_VALUE_CODE IS NOT NULL--部分码值取消导致出现空值，空值取身份证前6
                  THEN XZDM2.TAR_VALUE_CODE
                  WHEN (CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO) = 18
                              AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X')
                             THEN '1010' --身份证
                             ELSE A.CERT_TYPE_CD
                         END) = '1010'
                  /*THEN COALESCE(GB2.TAR_VALUE_CODE,SUBSTR(A.CERT_NO,1,4)||'00')*/ --先取身份证前6位，再取身份证前4位
                  THEN COALESCE(AREA1.AREA_CD,AREA2.AREA_CD,AREA3.AREA_CD,SUBSTR(A.CERT_NO,1,2)||'0000')
                  ELSE TRIM(NVL(XZDM.TAR_VALUE_CODE,A.RG_CD))
              END)                                            AS RSDNC_AREA_BFD                --居住地行政区划代码_金数 ADD BY LYH 20230705，人行地区代码变更
        --MOD BY HYF 20250623 根据业务要求，银监的客户类型判断：如果字节小微的个体小微属性:经营主体名称为空，则不判断为个体/小微
        ,CASE --WHEN YJ.CUST_ID IS NOT NULL THEN YJ.OPR_CUST_TYP_ZJXW
              WHEN T2.STD_PROD_ID = 'YJ' THEN T2.OPR_CUST_TYP_YJ --MOD BY LIP 20250721
              WHEN A.INDV_BUS_FLG = '1' THEN 'A' --个体工商户标志
              WHEN A.SM_BUS_OWNER_FLG = '1' THEN 'B' --小微企业主标志
              ELSE 'Z'
          END                                                 AS OPR_CUST_TYP                  --经营性客户类型 ADD BY HYF 20250623
        ,CASE WHEN A.GHB_EMPLY_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                                 AS BANK_EMP_FLG                  --本行员工标志
        ,CASE WHEN A.FARM_FLG = '1' THEN 'Y'
              WHEN A.FARM_FLG = '0' THEN 'N'
              WHEN A.FARM_FLG = '-' THEN 'N' --MOD BY LIP 20260414
              ELSE NULL
          END                                                 AS FARM_FLG                      --农户标志
        ,'N'                                                  AS CONT_SIDE_FARM_FLG            --承包方农户标志
        /*,CASE WHEN K.CUSTOMER_NO IS NOT NULL THEN 'Y'
              ELSE 'N'
          END                                                 AS BLIST_FLG                     --上黑名单标志*/
        ,NULL                                                 AS BLIST_FLG                     --上黑名单标志
        ,NULL/*K.CRT_DATE*/                                   AS BLIST_DT                      --上黑名单日期
        --为不影响日批次，黑名单表在EAST报表逻辑加工，不放在M层模型  modify by MW 20230512
        ,CASE WHEN L.CUST_ID IS NOT NULL THEN 'Y'
              ELSE 'N'
          END                                                 AS BANK_SENIOR_FLG               --银行高管标志
        /*,A.RELA_TRAN_FLG                                      AS REL_PTY_FLG                   --关联方标志*/
        ,CASE WHEN T1.PARTY_ID IS NOT NULL THEN 'Y'
              ELSE 'N'
          END                                                 AS REL_PTY_FLG                   --关联方标志
        ,NULL                                                 AS AGR_REL_LOAN_CERT_ISU_NUM     --发放支农贷款证数量
        ,NULL                                                 AS ECON_ARCH_FLG                 --经济档案标志
        ,NULL                                                 AS CRDT_FLG                      --信用户标志
        ,A.FARM_FLG                                           AS JUR_FLG                       --辖内标志
        ,NULL                                                 AS OPEN_EBANK_FLG                --开通网银标志
        ,NULL                                                 AS DISABLED_FLG                  --残疾人标志
        ,NULL                                                 AS LOW_INCM_FLG                  --低保户标志
        ,NULL                                                 AS CUST_CRDT_RTG                 --客户信用评级
        ,NULL                                                 AS CUST_CR_RTG_TOT_GRD           --客户信用评级总等级数
        ,CASE WHEN A.CUST_STATUS_CD = '2' THEN 'C'
              ELSE 'A'
          END                                                 AS CUST_STAT                     --客户状态
        ,CASE WHEN M.CUST_ID IS NOT NULL
              THEN TO_CHAR(M.DISTR_DT,'YYYYMMDD')
              ELSE NULL
          END                                                 AS FIRST_ESTBL_CRDT_REL_DT       --首次建立信贷关系日期
        ,'800924'                                             AS DEPT_LINE                     --部门条线 /*零售信贷部(普惠金融部)*/
        ,SUBSTR(A.JOB_CD,0,4)                                 AS DATA_SRC                      --数据来源
        ,CASE WHEN A.DOM_OVERS_FLG = '0' THEN 'N'
              ELSE 'Y'
          END                                                 AS BIO_FLG                       --境内外标志 MODYFY BY 20250320
        ,FLOOR(MONTHS_BETWEEN(TO_DATE(I_P_DATE,'YYYYMMDD'),
               CASE WHEN LENGTH(A.CERT_NO)=18 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,8),'^[0-9]+[0-9]$') AND SUBSTR(A.CERT_NO,7,2) IN ('19','20')
                     AND ((SUBSTR(A.CERT_NO,11,2) IN ('01','03','05','07','08','10','12') AND SUBSTR(A.CERT_NO,13,2)<32 AND SUBSTR(A.CERT_NO,13,2)>00)
                            OR (SUBSTR(A.CERT_NO,11,2) IN ('02','04','06','09','11') AND SUBSTR(A.CERT_NO,13,2)<31 AND SUBSTR(A.CERT_NO,13,2)>00))
                    THEN TO_DATE(SUBSTR(A.CERT_NO,7,8),'YYYY-MM-DD')
                    WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,6),'^[0-9]+[0-9]$')
                     AND SUBSTR(A.CERT_NO,9,2)<13 AND SUBSTR(A.CERT_NO,9,2)>00 AND SUBSTR(A.CERT_NO,11,2)<32 AND SUBSTR(A.CERT_NO,11,2)>00
                    THEN TO_DATE('19'||SUBSTR(A.CERT_NO,7,6),'YYYY-MM-DD')
                    ELSE A.BIRTH_DT
                END)/12)                                       AS AGE                          --年龄
        ,A.DIST_CD                                             AS DIST_CD                      --行政区划代码
        ,A.FAMILY_MON_INCO                                     AS FAMILY_MON_INCO              --家庭月收入
        ,A.INDV_MON_INCO                                       AS INDV_MON_INCO                --个人月收入
        --MOD BY HYF 20250623 根据业务要求，人行的客户类型判断：如果字节小微的个体小微属性:经营主体名称为空，则不判断为个体/小微
        /*,CASE WHEN YJ.OPR_CUST_TYP_ZJXW = 'Z' AND NVL(DJZ.OPR_CUST_TYP_WSD,'Z') = 'Z' THEN YJ.OPR_CUST_TYP_ZJXW
              WHEN DJZ.OPR_CUST_TYP_WSD = 'Z' AND NVL(YJ.OPR_CUST_TYP_ZJXW,'Z') = 'Z' THEN DJZ.OPR_CUST_TYP_WSD
              \*WHEN YJ.CUST_ID IS NOT NULL THEN YJ.OPR_CUST_TYP_ZJXW --字节小微部分
              WHEN DJZ.CUST_ID IS NOT NULL THEN DJZ.OPR_CUST_TYP_WSD --网商贷部分*\
              WHEN A.INDV_BUS_FLG = '1' THEN 'A' --个体工商户标志
              WHEN A.SM_BUS_OWNER_FLG = '1' THEN 'B' --小微企业主标志
              ELSE 'Z'
          END                                                  AS OPR_CUST_TYP_WSD             --经营性客户类型_网商贷 ADD BY HYF 20250623*/
        ,CASE WHEN T2.OPR_CUST_TYP_WSD = 'Z' AND NVL(T2.OPR_CUST_TYP_YJ,'Z') = 'Z' THEN T2.OPR_CUST_TYP_WSD
              WHEN T2.OPR_CUST_TYP_YJ = 'Z' AND NVL(T2.OPR_CUST_TYP_WSD,'Z') = 'Z' THEN T2.OPR_CUST_TYP_YJ
              WHEN A.INDV_BUS_FLG = '1' THEN 'A' --个体工商户标志
              WHEN A.SM_BUS_OWNER_FLG = '1' THEN 'B' --小微企业主标志
              ELSE 'Z'
          END                                                  AS OPR_CUST_TYP_WSD             --经营性客户类型_网商贷 MOD BY LIP 20250721
        --,NVL(YJ.CUST_NAME,DJZ.CUST_NAME)                       AS CUST_NM_WSD                  --客户名称_网商贷 ADD BY HYF 20241118
        ,NVL(T2.CUST_NAME_YJ,T2.CUST_NAME_WSD)                 AS CUST_NM_WSD                  --客户名称_网商贷 MOD BY LIP 20250721
        ,OH.INDV_BUS_NAME                                      AS INDV_BUS_NAME                --个体工商户名称 ADD BY XZY 20250411
        ,OH.INDUS_OBTAIN_EMPLY_YEARS                           AS INDUS_OBTAIN_EMPLY_YEARS     --行业从业年限 ADD BY XZY 20250411
        ,OH.MANG_RANGE_DESCB                                   AS MANG_RANGE_DESCB             --经营范围描述 ADD BY XZY 20250411
        ,OH.RGST_ADDR                                          AS RGST_ADDR                    --注册地址 ADD BY XZY 20250411
        ,OH.ASSET_TOT                                          AS ASSET_TOT                    --资产总额 ADD BY XZY 20250411
        ,OH.CORP_CERT_NO                                       AS CORP_CERT_NO                 --企业证件号码 ADD BY YJY 20250418
        ,OH.CORP_NAME                                          AS CORP_NAME                    --企业名称 ADD BY YJY 20250418
        ,CASE WHEN B.EX_SERVSM_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                                   AS EX_SERVSM_FLG                --退役军人标志 ADD BY YJY 20250512
        ,CASE WHEN B.NO_BUSLICS_PRC_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                                   AS NO_BUSLICS_PRC_FLG           --无营业执照负责人标志 ADD BY YJY 20250512
        ,NVL(C1.ISSUE_CERT_ORG_CTY_CD,'')                      AS ISSUE_CERT_ORG_CTY_CD        --证件签发国家代码  --ADD BY YJY 20250901 --MOD BY YJY 20250923 该字段目前仅存储证件类型为外国绿卡的国籍
        ,B.CRDT_CUST_TYPE_CD                                   AS CRDT_CUST_TYPE_CD            --信贷客户类型代码 ADD BY YJY 20260312 01-个体工商户 02-小微企业主 03-其他 04-大中型企业主 05-其他非企业负责人 06-其他无营业执照负责人
    FROM RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO A --个人客户基本信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_ATTACH_INFO B --个人客户补充信息 ADD BY YJY 20250512
      ON B.CUST_ID = A.CUST_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT PARTY_ID
                     ,CERT_NUM --证件号码
                     ,CERT_TYPE_CD --证件类型
                     ,LICEN_ISSUE_AUTHO_DIST_CD
                     ,TO_CHAR(CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
                     ,TO_CHAR(CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
                     ,CERT_ADDR                           AS CRDL_ADDR      --证件地址
                     ,SORC_SYS_CD
                     ,ISSUE_CERT_ORG_CTY_CD               AS ISSUE_CERT_ORG_CTY_CD  --证件签发国家代码  --ADD BY YJY 20250901
                     ,ROW_NUMBER() OVER(PARTITION BY PARTY_ID,CERT_NUM--,CERT_TYPE_CD
                                        ORDER BY CASE WHEN SORC_SYS_CD = 'EIFS' THEN 'A'
                                                      ELSE SORC_SYS_CD
                                                  END, --优先取ECIF
                                                  CERT_INVALID_DT DESC) AS RN
                 FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H --当事人证件信息历史
                WHERE TRIM(LICEN_ISSUE_AUTHO_DIST_CD) IS NOT NULL --发证机关代码不为空
                  AND TRIM(CERT_NUM) IS NOT NULL
                  AND REPLACE(CERT_NUM,'*','') IS NOT NULL
                  AND REPLACE(CERT_NUM,'0','') IS NOT NULL
                  AND TRIM(CERT_NUM) <> '/'
                  AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) C
      ON C.PARTY_ID = A.CUST_ID
     AND C.CERT_NUM = A.CERT_NO
     AND C.RN = 1
     --ADD BY YJY 20250923 获取绿卡的国籍
     LEFT JOIN (SELECT PARTY_ID
                     ,CERT_NUM --证件号码
                     ,CERT_TYPE_CD --证件类型
                     ,LICEN_ISSUE_AUTHO_DIST_CD
                     ,TO_CHAR(CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
                     ,TO_CHAR(CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
                     ,CERT_ADDR                           AS CRDL_ADDR      --证件地址
                     ,SORC_SYS_CD
                     ,ISSUE_CERT_ORG_CTY_CD               AS ISSUE_CERT_ORG_CTY_CD  --证件签发国家代码  --ADD BY YJY 20250901
                     ,ROW_NUMBER() OVER(PARTITION BY PARTY_ID --,CERT_NUM--,CERT_TYPE_CD
                                        ORDER BY CASE WHEN SORC_SYS_CD = 'EIFS' THEN 'A'
                                                      ELSE SORC_SYS_CD
                                                  END, --优先取ECIF
                                                  CERT_INVALID_DT DESC) AS RN
                 FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H --当事人证件信息历史
                WHERE TRIM(LICEN_ISSUE_AUTHO_DIST_CD) IS NOT NULL --发证机关代码不为空
                  AND TRIM(CERT_NUM) IS NOT NULL
                  AND REPLACE(CERT_NUM,'*','') IS NOT NULL
                  AND REPLACE(CERT_NUM,'0','') IS NOT NULL
                  AND TRIM(CERT_NUM) <> '/'
                  AND CERT_TYPE_CD IN ('1160') --1160-境外永久居留证（外国绿卡）
                  AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) C1
      ON C1.PARTY_ID = A.CUST_ID
     AND C1.RN = 1
    LEFT JOIN (SELECT * FROM (
              SELECT PARTY_ID,CERT_NO,SHARE_RATIO,ROW_NUMBER() OVER(PARTITION BY CERT_NO ORDER BY NUM) RN
                FROM (SELECT RELA_PARTY_ID AS PARTY_ID
                            ,TRIM(NVL(RELA_PARTY_CERT_ID_1,RELA_PARTY_CERT_ID_2)) AS CERT_NO
                            ,REPLACE(TRIM(RELA_PARTY_SHARE_RATIO),'%','') AS SHARE_RATIO
                            ,'1' NUM
                       FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO
                      WHERE --RELA_TYPE_CD IN ('10001','10002','20004') --20201216跟BA沟通，去掉次条件 BY HAP
                      --AND PARTY_ID = 'GHB' --20201216跟BA沟通，去掉次条件 BY HAP
                      /*AND*/ RELA_STATUS_CD = 'A' --20201014 BY WL 生产跑批发现关联方有重复且重复客户的状态未空，暂时置为取状态为 A 的
                        AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  UNION ALL  --20201216跟BA沟通，加上当事人的信息 BY HAP
                     SELECT PARTY_ID
                           ,TRIM(NVL(PARTY_CERT_ID_1, PARTY_CERT_ID_2)) AS CERT_NO
                           ,REPLACE(TRIM(PARTY_SHARE_RATIO),'%','') AS SHARE_RATIO
                           ,'2' NUM
                      FROM RRP_MDL.O_ICL_CMM_RELA_PARTY_BASIC_INFO
                     WHERE RELA_STATUS_CD = 'A' --20201014 BY WL 生产跑批发现关联方有重复且重复客户的状态未空，暂时置为取状态为 A 的
                       AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
                       ) T
                WHERE T.RN = 1) T1 --关联方基本信息 --ADD BY ZM 20200728
      ON T1.CERT_NO = A.CERT_NO
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_OPER_CORP_H OH --当事人经营企业历史 ADD BY XIEZY 20250411
      ON OH.PARTY_ID = A.CUST_ID
     AND OH.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND OH.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP F
      ON F.SRC_VALUE_CODE = A.MARRIAGE_SITU_CD
     AND F.SRC_CLASS_CODE = 'CD1002' --婚姻状况代码
     AND F.TAR_CLASS_CODE = 'C0010' --婚姻状况
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP XZDM --地区转行政区划代码
      ON XZDM.SRC_VALUE_CODE = A.RG_CD
     AND XZDM.SRC_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM.TAR_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM.MOD_FLG = 'MDM'
    --UPDATE BY LYH 20230818，发证机关行政区划代码 由4位转为6位
    LEFT JOIN RRP_MDL.CODE_MAP XZDM1 --地区转行政区划代码
      ON XZDM1.SRC_VALUE_CODE = C.LICEN_ISSUE_AUTHO_DIST_CD
     AND XZDM1.SRC_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM1.TAR_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM1.MOD_FLG = 'MDM'
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP GB1
      ON GB1.AREA_CD = SUBSTR(A.RG_CD,1,6)
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP GB2
      ON GB2.AREA_CD = SUBSTR(A.RG_CD,1,4)||'00'
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP GB3
      ON GB3.AREA_CD = SUBSTR(A.RG_CD,1,3)||'000'
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP GB4
      ON GB4.AREA_CD = SUBSTR(A.RG_CD,1,2)||'0000'
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP AREA1
      ON AREA1.AREA_CD = SUBSTR(A.CERT_NO,1,6)
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP AREA2
      ON AREA2.AREA_CD = SUBSTR(A.CERT_NO,1,4)||'00'
    LEFT JOIN RRP_PLAT.RPT_STD_AREA_INFO@LINK_RRP AREA3
      ON AREA3.AREA_CD = SUBSTR(A.CERT_NO,1,3)||'000'
    LEFT JOIN RRP_MDL.CODE_MAP XZDM2 --行政区划代码转行政区划代码
      ON XZDM2.SRC_VALUE_CODE = A.DIST_CD
     AND XZDM2.SRC_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM2.TAR_CLASS_CODE = 'CD1730' --行政区划代码
     AND XZDM2.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP J
      ON J.SRC_VALUE_CODE = A.WORK_UNIT_CHAR_CD
      --ON J.SRC_VALUE_CODE = CASE WHEN A.WORK_UNIT_CHAR_CD = '000' THEN '0' ELSE A.WORK_UNIT_CHAR_CD END
     AND J.SRC_CLASS_CODE = 'CD1407' --经济类型代码
     AND J.TAR_CLASS_CODE = 'C0050' --单位性质
     AND J.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.ADD_SENIOR L --银行高管补录表,留空后期等业务补录
      ON L.CUST_ID = A.CUST_ID
    LEFT JOIN RRP_MDL.TMP_XD_CUST M
      ON M.CUST_ID = A.CUST_ID
    LEFT JOIN RRP_MDL.AREA_CD_BFD BFD1 --ADD BY LYH 20230705，人行地区代码变更
      ON BFD1.OLD_RH_AREA_CD = NVL(XZDM1.TAR_VALUE_CODE,C.LICEN_ISSUE_AUTHO_DIST_CD)
    LEFT JOIN RRP_MDL.AREA_CD_BFD BFD2 --ADD BY LYH 20230705，人行地区代码变更
      ON BFD2.OLD_RH_AREA_CD = (CASE WHEN A.RG_CD NOT IN ('000000','999999') AND LENGTH(TRIM(A.RG_CD)) = 6
                                     THEN /*A.RG_CD*/COALESCE (GB1.AREA_CD,GB2.AREA_CD,GB3.AREA_CD,GB4.AREA_CD)
                                     WHEN C.LICEN_ISSUE_AUTHO_DIST_CD NOT IN ('000000','999999') AND LENGTH(TRIM(C.LICEN_ISSUE_AUTHO_DIST_CD)) = 6
                                     THEN C.LICEN_ISSUE_AUTHO_DIST_CD
                                     WHEN A.DIST_CD NOT IN ('9999','000000','999999') AND TRIM(A.DIST_CD) IS NOT NULL AND XZDM2.TAR_VALUE_CODE IS NOT NULL--部分码值取消导致出现空值，空值取身份证前6
                                     THEN XZDM2.TAR_VALUE_CODE
                                     WHEN (CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO)=18 AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X')
                                                THEN '1010'  --身份证
                                                ELSE A.CERT_TYPE_CD
                                            END) = '1010'
                                     THEN COALESCE(AREA1.AREA_CD,AREA2.AREA_CD,AREA3.AREA_CD,SUBSTR(A.CERT_NO,1,2)||'0000')
                                     ELSE TRIM(NVL(XZDM.TAR_VALUE_CODE,A.RG_CD))
                                 END)
    /*LEFT JOIN RRP_MDL.GTXW_DJZ DJZ --ADD BY HYF 20241118，个体小微_配置表
      ON DJZ.CUST_ID = A.CUST_ID
    LEFT JOIN RRP_MDL.GTXW_YJ YJ --ADD BY HYF 20250623，个体小微_银监配置表
      ON YJ.CUST_ID = A.CUST_ID*/
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO_TMP T2 --MOD BY LIP 20250721 个人客户信息_经营贷款客户类型
      ON T2.CUST_ID = A.CUST_ID
   WHERE A.CUST_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := 6;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,CUST_ID,COUNT(1)
    FROM RRP_MDL.M_CUST_IND_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CUST_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 7;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
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

END ETL_M_CUST_IND_INFO;
/

