CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CORP_CUST_S74(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CORP_CUST_S74
  *  功能描述：企业客户签约表
  *  创建日期：20250317
  *  开发人员：lwb
  *  来源表：    
  *  目标表：    M_CORP_CUST_S74
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20250317   lwb      新建
  ********************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;              --处理步骤
  V_STEP_DESC VARCHAR2(1000);             --处理步骤描述
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  --V_MONTH_START_DATE DATE;               --系统时间对应月初日期
  V_TAB_NAME  VARCHAR2(100) := 'M_CORP_CUST_S74'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CORP_CUST_S74'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  --V_PART_NAME VARCHAR2(100);   --分区名
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  --V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');
  --V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN'||' TRUNCATE PARTITION '||'写上分区名'); --分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  /*EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理*/
  /*DELETE FROM RRP_MDL.S_LOAN WHERE DATA_DT = V_P_DATE;
  COMMIT;*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '贷款业务整合表--普通贷款逻辑处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CORP_CUST_S74
    (DATA_DT             --数据日期
    ,SIGN_NETW_ID        --开户网点编号
    ,CUST_NAME           --客户名称
    ,CUST_ID             --客户编号
    ,CONL_BK_STATUS_CD   --网银客户状态代码
    ,CONL_BK_STATUS_NAME --企业网银状态
    ,SIGN_MBANK_FLG      --开通手机银行标志
    ,MBANK_SIGN_DT       --签约银企通时间    
    )
  WITH TMP_D_CONL_BK_CUST_DTL_01 AS (
      SELECT T1.CUST_ID                 AS CUST_ID                       --客户编号
            ,T1.OPEN_ACCT_BRAC_ID       AS OPEN_ACCT_BRAC_ID             --开户网点编号
            ,T1.ONL_BANK_CUST_STATUS_CD AS ONL_BANK_CUST_STATUS_CD       --网银客户状态代码
            ,T1.OPEN_ACCT_TM            AS OPEN_ACCT_TM                  --开户时间
            ,T1.FINAL_TRAN_TM           AS FINAL_TRAN_TM                 --最后交易时间
            ,T1.SIGN_YQT_FLG            AS SIGN_YQT_FLG                  --签约银企通标志
            ,T1.SIGN_YQT_TM             AS SIGN_YQT_TM                   --签约银企通时间
            ,T1.OA_WRTOFF_TM            AS OA_WRTOFF_TM                  --OA注销时间
            ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' 
                   AND T1.SIGN_YQT_FLG = '1' THEN '1' 
                  ELSE '0' 
              END                        AS OPEN_MBANK_FLG
      FROM ICL.CMM_CONL_BK_SIGN_INFO T1 --企业网银签约信息 
     INNER JOIN ( SELECT CUST_ID
                   FROM ICL.CMM_DEP_ACCT_INFO 
                  WHERE (SUBSTR(SUBJ_ID,1,4) IN ('2005','2010') OR SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
                     OR (SUBJ_ID = '20150102' AND STD_PROD_ID IN ('103010400001','103020800001')) )
                    AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  GROUP BY CUST_ID )  T2   --存款账户信息表 
        ON T2.CUST_ID = T1.CUST_ID
     WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T1.ONL_BANK_CUST_TYPE_CD IN ('1','2','3','5')    --客户类型代码 CD1880：0-虚拟客户,1-交易银行客户,2-网银客户,3-交易银行+网银客户,4-佳佳购车客户,5-OA企业,7-银企直连  
       AND T1.ONL_BANK_CUST_STATUS_CD IN ('0','4')    --账户状态代码 CD1873：0-正常,1-暂停,2-锁定(允许查询),3-冻结 (不允许查询),4-销户,5-欠款状态,6-活动,7-已故,9-未知   
       AND T1.CUST_CN_NAME NOT LIKE '%银行%')   --剔除客户中文名称中含有“银行”字样的对公单位客户 
 ,TMP_D_CONL_BK_CUST_DTL_02 AS (
        SELECT T1.CUST_ID AS CUST_ID                                        --客户编号
               ,SUM(CASE WHEN T3.DEP_ACCT_STATUS_CD IN ('N','I','A','D') THEN 1 ELSE 0 END ) AS VALID_ACCT_QTTY --NONE
          FROM ICL.CMM_CORP_CUST_BASIC_INFO  T1 --对公客户信息表 
          LEFT JOIN ICL.CMM_DEP_CUST_ACCT_INFO  T2 --存款主账户信息 
            ON T2.CUST_ID = T1.CUST_ID
           AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          LEFT JOIN ICL.CMM_DEP_ACCT_INFO  T3 --存款账户信息表 
            ON T3.CUST_ID = T1.CUST_ID
           AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         GROUP BY T1.CUST_ID )
 ,TMP_D_CONL_BK_CUST_DTL_03 AS (
     SELECT T1.CUST_ID AS CUST_ID                                        --客户编号
           ,SUM(NVL(T2.CL_CURR_CURRT_BAL,0)) AS DEP_BAL                  --折本币当期余额
           ,SUM(NVL(T2.CL_CURR_M_AVG_BAL,0)) AS DEP_M_AVG                --折本币月日均余额
           ,SUM(NVL(T2.CL_CURR_Y_AVG_BAL,0)) AS DEP_ACM_DAY_AVG_STAT_YEAR --折本币年日均余额
       FROM TMP_D_CONL_BK_CUST_DTL_01  T1 --临时表01 
       LEFT JOIN ICL.CMM_DEP_ACCT_INFO  T2 --存款账户信息表 
         ON T2.CUST_ID = T1.CUST_ID
        AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      WHERE (SUBSTR(SUBJ_ID,1,4) IN ('2005','2010') OR  SUBJ_ID IN ('20020101','20020102','20110101','20110102','20110103','20110104','20110105') 
            OR (SUBJ_ID='20150102' AND STD_PROD_ID IN ('103010400001','103020800001')) )
      GROUP BY T1.CUST_ID )
  SELECT 
         V_P_DATE               as DATA_DT --数据日期
        ,T1.OPEN_ACCT_BRAC_ID   AS SIGN_NETW_ID                     --开户网点编号
        ,T2.CUST_NAME           AS CUST_NAME                        --客户名称
        ,T1.CUST_ID             AS CUST_ID                          --客户编号
        --,T2.MAIN_CERT_TYPE_CD AS CERT_TYPE_CD                     --主证件类型代码
        --,T2.MAIN_CERT_NO AS CERT_NO                               --主证件号码
        ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY>0 THEN '1'
              WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY=0 THEN '0'
              WHEN T1.ONL_BANK_CUST_STATUS_CD = '4'  THEN '4'
          END                   AS CONL_BK_STATUS_CD                --网银客户状态代码
        ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY>0 THEN '开通'
              WHEN T1.ONL_BANK_CUST_STATUS_CD <> '4' AND T9.VALID_ACCT_QTTY=0 THEN '开通无账户'
              WHEN T1.ONL_BANK_CUST_STATUS_CD = '4' THEN '注销'
          END                   AS CONL_BK_STATUS_NAME              --企业网银状态
        ,CASE WHEN T1.OPEN_MBANK_FLG='0' THEN '未签约'
              WHEN T1.OPEN_MBANK_FLG='1' AND (T9.CUST_ID IS NULL OR T9.VALID_ACCT_QTTY=0) THEN '签约无账户'
              WHEN T1.OPEN_MBANK_FLG='1' AND T9.CUST_ID IS NOT NULL THEN '签约'
          END                   AS SIGN_MBANK_FLG                   --开通手机银行标志
        ,CASE WHEN T1.ONL_BANK_CUST_STATUS_CD <>'4' AND T1.SIGN_YQT_FLG='1'
              THEN TO_CHAR(T1.SIGN_YQT_TM,'YYYY-MM-DD') 
          END                   AS MBANK_SIGN_DT                    --签约银企通时间
   FROM TMP_D_CONL_BK_CUST_DTL_01  T1 --临时表01 
  INNER JOIN ICL.CMM_CORP_CUST_BASIC_INFO  T2 --对公客户信息表 
     ON T2.CUST_ID = T1.CUST_ID    --客户编号=客户编号
    AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  INNER JOIN TMP_D_CONL_BK_CUST_DTL_03  T3 --临时表03 
     ON T3.CUST_ID = T1.CUST_ID    --客户编号 = 客户编号
   LEFT JOIN TMP_D_CONL_BK_CUST_DTL_02  T9 --临时表02 
     ON T9.CUST_ID = T1.CUST_ID ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --记录正常日志
 

  /*--如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);*/

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CORP_CUST_S74;
/

