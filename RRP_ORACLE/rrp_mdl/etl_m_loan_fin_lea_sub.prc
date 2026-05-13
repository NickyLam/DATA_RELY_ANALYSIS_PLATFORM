CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_FIN_LEA_SUB(I_P_DATE IN INTEGER,
                                                   O_ERRCODE OUT VARCHAR2
                                                   )
/**************************************************************************
 *  程序名称：ETL_M_LOAN_FIN_LEA_SUB
 *  功能描述：融资租赁子表
 *  创建日期：20220615
 *  开发人员：梅炜
 *  来源表：
 *  目标表：  ETL_M_LOAN_FIN_LEA_SUB
 *  配置表：  CODE_MAP
 *  修改情况：序号  修改日期  修改人   修改原因
 *             1    20220523  梅炜      首次创建
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);          --任务名称
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_FIN_LEA_SUB'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_LOAN_FIN_LEA_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_FIN_LEA_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'ETL_M_LOAN_FIN_LEA_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
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
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '融资租赁子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_FIN_LEA_SUB
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,RCPT_ID            --借据编号
    ,FIN_LEASE_TYP      --融资租赁类型
    ,FIN_LEASE_MODE     --融资租赁方式
    ,LEASE_ULYG         --租赁标的物
    ,LEASE_CO_NM        --租赁公司名称
    ,LEASE_CO_CRDL_TYP  --租赁公司证件类别
    ,LEASE_CO_CRDL_NO   --租赁公司证件号码
    ,COMM_CUR           --手续费币种
    ,COMM_AMT           --手续费金额
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    )
  SELECT V_P_DATE                     AS DATA_DT            --数据日期
        ,A.LP_ID                      AS LGL_REP_ID         --法人编号
        ,A.DUBIL_ID                   AS RCPT_ID            --借据编号
        ,NULL                         AS FIN_LEASE_TYP      --融资租赁类型
        ,NULL                         AS FIN_LEASE_MODE     --融资租赁方式
        ,NULL                         AS LEASE_ULYG         --租赁标的物
        ,NULL                         AS LEASE_CO_NM        --租赁公司名称
        ,NULL                         AS LEASE_CO_CRDL_TYP  --租赁公司证件类别
        ,NULL                         AS LEASE_CO_CRDL_NO   --租赁公司证件号码
        ,NULL                         AS COMM_CUR           --手续费币种
        ,NULL                         AS COMM_AMT           --手续费金额
        ,'800919'                     AS DEPT_LINE          --部门条线 /*风险管理部*/
        ,UPPER(SUBSTR(A.JOB_CD,0,4))  AS DATA_SRC           --数据来源
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A  --零售贷款借据信息
  WHERE A.DUBIL_ID IS NOT NULL
    AND A.LOAN_TYPE_CD LIKE '000%'
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

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

END ETL_M_LOAN_FIN_LEA_SUB;
/

