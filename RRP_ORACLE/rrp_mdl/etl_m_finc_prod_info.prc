CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_FINC_PROD_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：ETL_M_FINC_PROD_INFO
 *  功能描述：理财产品基础信息
 *  创建日期：20221231
 *  开发人员：MW
 *  来源表：O_ICL_CMM_FINC_PROD_BASIC_INFO --理财产品基础信息
 *
 *  目标表：  M_FINC_PROD_INFO
 *  配置表：
 *  修改情况：序号  修改日期  修改人   修改原因
 *               1  20250305  YJY      调整标准产品编号指标取源表标准产品编号
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;              --处理步骤
  V_STEP_DESC VARCHAR2(100);             --处理步骤描述
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);             --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_FINC_PROD_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_FINC_PROD_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_FINC_PROD_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_FINC_PROD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入理财产品基础信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FINC_PROD_INFO
    (DATA_DT                 	--数据日期
    ,ORG_ID                   --机构编号
    ,SUBJ_ID                  --科目编号
    ,CUR                      --币种
    ,STD_PROD_ID              --标准产品编号
    ,PROD_CODE                --产品代码
    ,PROD_TYPE                --产品种类
    ,OPER_TYP                 --业务模式
    ,PROCEEDS_CHARACTER       --收益特征
    ,ACTL_PROD_END_DT         --实际终止日期
    ,ONLINE_TRADE_FLG         --可互联网销售标志
    ,BANK_ISSUE_FLG           --本行发行标志
    ,CUST_TYPE                --客户类型
    ,END_PROD_AMT             --期末产品余额
    ,DEPTLINE                 --部门条线
    ,DATA_SRC                 --数据来源
    )
  SELECT V_P_DATE                                  AS DATA_DT              --数据日期
        ,T1.ACCT_INSTIT_ID                         AS ORG_ID               --机构编号
        ,NULL                                      AS SUBJ_ID              --科目编号
        ,T1.CURR_CD                                AS CUR                  --币种
        ,T1.STD_PROD_ID                            AS STD_PROD_ID          --标准产品编号
        ,T1.PROD_ID                                AS PROD_CODE            --产品代码
        ,'1'                                       AS PROD_TYPE            --产品种类
        ,'3'                                       AS OPER_TYP             --业务模式
        ,CASE WHEN T1.PRFT_TYPE_CD = '01' THEN 'a' --保本保收益型
              WHEN T1.PRFT_TYPE_CD = '02' THEN 'b' --保本浮动收益型
              WHEN T1.PRFT_TYPE_CD = '03' THEN 'c' --非保本浮动收益型
          END                                      AS PROCEEDS_CHARACTER   --收益特征
        ,TO_CHAR(T1.ACTL_EXP_DT,'YYYYMMDD')        AS ACTL_PROD_END_DT     --实际终止日期
        ,CASE WHEN T1.SELL_CHN_CD_COMB LIKE '%04%' OR T1.SELL_CHN_CD_COMB LIKE '%05%'
                OR T1.SELL_CHN_CD_COMB LIKE '%07%' OR T1.SELL_CHN_CD_COMB LIKE '%99%'
              THEN 'Y'
              ELSE 'N'
          END                                      AS ONLINE_TRADE_FLG     --可互联网销售标志
        ,'Y'                                       AS BANK_ISSUE_FLG       --本行发行标志
        ,'1'                                       AS CUST_TYPE            --客户类型
        ,T1.CURR_PRIC_BAL                          AS END_PROD_AMT         --期末产品余额
        ,NULL                                      AS DEPTLINE             --部门条线
        ,'理财产品'                                AS DATA_SRC             --数据来源
    FROM RRP_MDL.O_ICL_CMM_FINC_PROD_BASIC_INFO T1 --理财产品基础信息
   WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_M_FINC_PROD_INFO;
/

