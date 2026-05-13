CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CRDT_BUS_CONT_RISK_ADJ_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CRDT_BUS_CONT_RISK_ADJ_H
  *  功能描述：信贷业务合同风险调整历史
  *  创建日期：20230225
  *  开发人员：MW
  *  来源表：  O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H
  *
  *  目标表：  M_CRDT_BUS_CONT_RISK_ADJ_H
  *
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *    1   20230508  Liuyu    修改五级分类
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;          --处理步骤
  V_STEP_DESC VARCHAR2(100);         --处理步骤描述
  V_P_DATE    VARCHAR2(8);           --跑批数据日期
  V_STARTTIME DATE;                  --处理开始时间
  V_ENDTIME   DATE;                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);         --SQL执行描述信息
  V_DATE      DATE;                  --数据日期
  V_TAB_NAME  VARCHAR2(100) := 'M_CRDT_BUS_CONT_RISK_ADJ_H'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CRDT_BUS_CONT_RISK_ADJ_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_DATE := TO_DATE(V_P_DATE,'YYYYMMDD');

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_CRDT_BUS_CONT_RISK_ADJ_H T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷业务合同风险调整历史-对公信贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CRDT_BUS_CONT_RISK_ADJ_H
    (DATA_DT                     --01 数据日期
    ,AGT_ID                      --02 协议编号
    ,LP_ID                       --03 法人编号
    ,FLOW_NUM 	                 --04 流水号
    ,CUST_ID                     --05 客户编号
    ,CUST_NAME                   --06 客户名称
    ,BUS_CONT_ID                 --07 业务合同编号
    ,BUS_TYPE_CD                 --08 业务类型代码
    ,BUS_CURR_CD                 --09 业务币种代码
    ,BAL                         --10 余额
    ,BF_ADJ_LEVEL5_CLS_CD        --11 调整前五级分类代码
    ,A_ADJUST_LEVEL5_CLS_CD      --12 调整后五级分类代码
    ,BF_ADJ_LEVEL11_CLS_CD       --13 调整前十一级分类代码
    ,A_ADJUST_LEVEL11_CLS_CD     --14 调整后十一级分类代码
    ,ADJ_DT                      --15 调整日期
    ,MG_PROT_TELLER_ID           --16 管护柜员编号
    ,MG_PROT_ORG_ID              --17 管护机构编号
    ,RELA_FLOW_ID                --18 关联流程编号
    ,RELA_FLOW_TYPE_CD           --19 关联流程类型代码
    ,OBJ_TYPE_CD                 --20 对象类型代码
    ,OBJ_DESCB                   --21 对象描述
    ,INIT_TELLER_ID              --22 发起柜员编号
    ,ETL_DT                      --23 ETL处理日期
    ,SRC_TABLE_NAME              --24 源表名称
    ,JOB_CD                      --25 任务编码
    ,ETL_TIMESTAMP               --26 ETL处理时间戳
    ,DUBIL_ID                    --27 借据编号
    )
  SELECT V_P_DATE                                 AS DATA_DT                                  --01 数据日期
        ,T1.AGT_ID                                AS AGT_ID                                   --02 协议编号
        ,T1.LP_ID                                 AS LP_ID                                    --03 法人编号
        ,T1.FLOW_NUM                              AS FLOW_NUM 	                              --04 流水号
        ,T1.CUST_ID                               AS CUST_ID                                  --05 客户编号
        ,T1.CUST_NAME                             AS CUST_NAME                                --06 客户名称
        ,T1.BUS_CONT_ID                           AS BUS_CONT_ID                              --07 业务合同编号
        ,T1.BUS_TYPE_CD                           AS BUS_TYPE_CD                              --08 业务类型代码
        ,T1.BUS_CURR_CD                           AS BUS_CURR_CD                              --09 业务币种代码
        ,T1.BAL                                   AS BAL                                      --10 余额
        ,CASE WHEN T1.BF_ADJ_LEVEL5_CLS_CD LIKE '%正常%' OR T1.BF_ADJ_LEVEL5_CLS_CD = '01' THEN '10'
              WHEN T1.BF_ADJ_LEVEL5_CLS_CD LIKE '%关注%' OR T1.BF_ADJ_LEVEL5_CLS_CD = '02' THEN '20'
              WHEN T1.BF_ADJ_LEVEL5_CLS_CD LIKE '%次级%' OR T1.BF_ADJ_LEVEL5_CLS_CD = '03' THEN '30'
              WHEN T1.BF_ADJ_LEVEL5_CLS_CD LIKE '%可疑%' OR T1.BF_ADJ_LEVEL5_CLS_CD = '04' THEN '40'
              WHEN T1.BF_ADJ_LEVEL5_CLS_CD LIKE '%损失%' OR T1.BF_ADJ_LEVEL5_CLS_CD = '05' THEN '50'
              ELSE T1.BF_ADJ_LEVEL5_CLS_CD --MOD BY LIUYU 业务测试用中文,调整逻辑出码值
          END                                     AS BF_ADJ_LEVEL5_CLS_CD                     --11 调整前五级分类代码
        ,CASE WHEN T1.A_ADJUST_LEVEL5_CLS_CD LIKE '%正常%' OR T1.A_ADJUST_LEVEL5_CLS_CD = '01' THEN '10'
              WHEN T1.A_ADJUST_LEVEL5_CLS_CD LIKE '%关注%' OR T1.A_ADJUST_LEVEL5_CLS_CD = '02' THEN '20'
              WHEN T1.A_ADJUST_LEVEL5_CLS_CD LIKE '%次级%' OR T1.A_ADJUST_LEVEL5_CLS_CD = '03' THEN '30'
              WHEN T1.A_ADJUST_LEVEL5_CLS_CD LIKE '%可疑%' OR T1.A_ADJUST_LEVEL5_CLS_CD = '04' THEN '40'
              WHEN T1.A_ADJUST_LEVEL5_CLS_CD LIKE '%损失%' OR T1.A_ADJUST_LEVEL5_CLS_CD = '05' THEN '50'
              ELSE T1.A_ADJUST_LEVEL5_CLS_CD --MOD BY LIUYU 业务测试用中文,调整逻辑出码值
          END                                     AS A_ADJUST_LEVEL5_CLS_CD                   --12 调整后五级分类代码
        ,T1.BF_ADJ_LEVEL11_CLS_CD                 AS BF_ADJ_LEVEL11_CLS_CD                    --13 调整前十一级分类代码
        ,T1.A_ADJUST_LEVEL11_CLS_CD               AS A_ADJUST_LEVEL11_CLS_CD                  --14 调整后十一级分类代码
        ,T1.ADJ_DT                                AS ADJ_DT                                   --15 调整日期
        ,T1.MG_PROT_TELLER_ID                     AS MG_PROT_TELLER_ID                        --16 管护柜员编号
        ,T1.MG_PROT_ORG_ID                        AS MG_PROT_ORG_ID                           --17 管护机构编号
        ,T1.RELA_FLOW_ID                          AS RELA_FLOW_ID                             --18 关联流程编号
        ,T1.RELA_FLOW_TYPE_CD                     AS RELA_FLOW_TYPE_CD                        --19 关联流程类型代码
        ,T1.OBJ_TYPE_CD                           AS OBJ_TYPE_CD                              --20 对象类型代码
        ,T1.OBJ_DESCB                             AS OBJ_DESCB                                --21 对象描述
        ,T1.INIT_TELLER_ID                        AS INIT_TELLER_ID                           --22 发起柜员编号
        ,T1.ETL_DT                                AS ETL_DT                                   --23 ETL处理日期
        ,T1.SRC_TABLE_NAME                        AS SRC_TABLE_NAME                           --24 源表名称
        ,T1.JOB_CD                                AS JOB_CD                                   --25 任务编码
        ,T1.ETL_TIMESTAMP                         AS ETL_TIMESTAMP                            --26 ETL处理时间戳
        ,NVL(T2.DUBIL_ID, T3.DUBIL_ID)            AS DUBIL_ID                                 --27 借据编号
    FROM RRP_MDL.O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H T1 --信贷业务合同风险调整历史
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T2 --零售借据表
      ON T2.CONT_ID = T1.BUS_CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3 --对公借据
      ON T3.CONT_ID = T1.BUS_CONT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T4 --贷款产品信息表
      ON T4.PROD_ID = NVL(T2.STD_PROD_ID,T3.STD_PROD_ID)
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T4.LEVEL1_PROD_ID = '2' --取表内贷款业务
     AND TRUNC(T1.ADJ_DT,'Y') = TRUNC(V_DATE,'Y') --MOD BY LIUYU 改为本年
     AND T1.ADJ_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --调整日期小于报告日
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

END ETL_M_CRDT_BUS_CONT_RISK_ADJ_H;
/

