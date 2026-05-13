CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_IND_LVL5_ADJ_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：M_LOAN_IND_LVL5_ADJ_H
 *  功能描述：五级形态变动记录（零售及联合网贷部分），每天跑批，与前一天数据对比，记录五级分类发生变化的数据
 *  创建日期：20230710
 *  开发人员：MW
 *  来源表：
 *  目标表：  M_LOAN_IND_LVL5_ADJ_H  --机构表
 *
 *  配置表：  CODE_MAP  --码值映射表
 *  修改情况：序号  修改日期  修改人   修改原因
 *             1    20230710  MW       CREATE
 *             2    20250521  YJY      修改联合网贷部分的借据号，取联合网贷借据表的核心借据编号
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(50) := 'M_LOAN_IND_LVL5_ADJ_H'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_IND_LVL5_ADJ_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := TO_CHAR(I_P_DATE); --获取跑批日期
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
  V_STEP_DESC := '插入目标表-零售贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IND_LVL5_ADJ_H
    (DATA_DT                        --数据日期
    ,DUBIL_ID                       --借据编号
    ,CONT_ID                        --合同编号
    ,CUST_ID                        --客户编号
    ,STD_PROD_ID                    --标准产品编号
    ,PROD_NAME                      --产品名称
    ,BEFORE_LVL5_CLS_CD             --调整前五级分类
    ,AFTER_LVL5_CLS_CD              --调整后五级分类
    ,ADJ_DT                         --调整日期
    ,DATA_SRC                       --数据来源
    )
  SELECT V_P_DATE                        AS DATA_DT                 --数据日期
        ,T1.DUBIL_ID                     AS DUBIL_ID                --借据编号
        ,T1.CONT_ID                      AS CONT_ID                 --合同编号
        ,T1.CUST_ID                      AS CUST_ID                 --合同编号
        ,T1.STD_PROD_ID                  AS STD_PROD_ID             --标准产品编号
        ,T3.PROD_NAME                    AS PROD_NAME               --产品名称
        ,CASE WHEN T2.LOAN_LEVEL5_CLS_CD IN ('10','90','99') THEN '正常'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('20') THEN '关注'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('30') THEN '次级'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('40') THEN '可疑'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('50') THEN '损失'
              ELSE '正常'
          END                            AS BEFORE_LVL5_CLS_CD      --调整前五级分类
        ,CASE WHEN T1.LOAN_LEVEL5_CLS_CD IN ('10','90','99') THEN '正常'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('20') THEN '关注'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('30') THEN '次级'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('40') THEN '可疑'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('50') THEN '损失'
              ELSE '正常'
          END                            AS AFTER_LVL5_CLS_CD       --调整后五级分类
        ,V_P_DATE                        AS ADJ_DT                  --调整日期
        ,'零售贷款'                      AS DATA_SRC                --数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T1  --零售贷款借据信息  --当天
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T2  --零售贷款借据信息  --前一天
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T3  --标准产品编号
      ON T3.PROD_ID = T1.STD_PROD_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (CASE WHEN T1.LOAN_LEVEL5_CLS_CD IN ('90','99') THEN '10'
               ELSE T1.LOAN_LEVEL5_CLS_CD END) <> (CASE WHEN T2.LOAN_LEVEL5_CLS_CD IN ('90','99') THEN '10'
               ELSE T2.LOAN_LEVEL5_CLS_CD END)
     AND T2.DUBIL_ID IS NOT NULL
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '插入目标表-联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IND_LVL5_ADJ_H
    (DATA_DT                        --数据日期
    ,DUBIL_ID                       --借据编号
    ,CONT_ID                        --合同编号
    ,CUST_ID                        --客户编号
    ,STD_PROD_ID                    --标准产品编号
    ,PROD_NAME                      --产品名称
    ,BEFORE_LVL5_CLS_CD             --调整前五级分类
    ,AFTER_LVL5_CLS_CD              --调整后五级分类
    ,ADJ_DT                         --调整日期
    ,DATA_SRC                       --数据来源
    )
  SELECT V_P_DATE                        AS DATA_DT                 --数据日期
        /*,T1.DUBIL_ID                     AS DUBIL_ID                --借据编号*/
        ,T1.CORE_DUBIL_ID                AS DUBIL_ID                 --借据编号 MOD BY YJY 20250521 取联合网贷的核心借据号 
        ,T1.DUBIL_ID                     AS CONT_ID                 --合同编号
        ,T1.CUST_ID                      AS CUST_ID                 --合同编号
        ,T1.STD_PROD_ID                  AS STD_PROD_ID             --标准产品编号
        ,T3.PROD_NAME                    AS PROD_NAME               --产品名称
        ,CASE WHEN T2.LOAN_LEVEL5_CLS_CD IN ('10','90','99') THEN '正常'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('20') THEN '关注'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('30') THEN '次级'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('40') THEN '可疑'
              WHEN T2.LOAN_LEVEL5_CLS_CD IN ('50') THEN '损失'
              ELSE '正常'
          END                            AS BEFORE_LVL5_CLS_CD      --调整前五级分类
        ,CASE WHEN T1.LOAN_LEVEL5_CLS_CD IN ('10','90','99') THEN '正常'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('20') THEN '关注'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('30') THEN '次级'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('40') THEN '可疑'
              WHEN T1.LOAN_LEVEL5_CLS_CD IN ('50') THEN '损失'
              ELSE '正常'
          END                            AS AFTER_LVL5_CLS_CD       --调整后五级分类
        ,TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD') AS ADJ_DT --调整日期
        ,'联合网贷'                      AS DATA_SRC                --数据来源
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T1  --联合网贷借据信息  --T-2
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T2  --联合网贷借据信息 --T-3
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T3  --标准产品编号
      ON T3.PROD_ID = T1.STD_PROD_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (CASE WHEN T1.LOAN_LEVEL5_CLS_CD IN ('90','99') THEN '10'
               ELSE T1.LOAN_LEVEL5_CLS_CD END) <> (CASE WHEN T2.LOAN_LEVEL5_CLS_CD IN ('90','99') THEN '10'
               ELSE T2.LOAN_LEVEL5_CLS_CD END)
     AND T2.DUBIL_ID IS NOT NULL
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_IND_LVL5_ADJ_H;
/

