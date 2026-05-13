CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_IALL_CO_SUB(I_P_DATE IN INTEGER,
                                                   O_ERRCODE OUT VARCHAR2
                                                   )
/**************************************************************************
 *  程序名称：ETL_M_LOAN_IALL_CO_SUB
 *  功能描述：投贷联动合作公司信息
 *  创建日期：20220523
 *  开发人员：梅炜
 *  来源表：
 *  目标表：  M_LOAN_IALL_CO_SUB
 *  配置表：  CODE_MAP
 *  修改情况：序号  修改日期  修改人   修改原因
 *             1    20220523  梅炜      首次创建
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_IALL_CO_SUB'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_LOAN_IALL_CO_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_IALL_CO_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_LOAN_IALL_CO_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
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
  V_STEP_DESC := '投贷联动合作公司信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IALL_CO_SUB
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,ORG_ID             --机构编号
    ,COOP_CO_ID         --合作公司编号
    ,CO_NM              --公司名称
    ,ESTM_DT            --设立日期
    ,SUBS_FLG           --子公司标志
    ,EMP_NUM            --从业人数
    ,LOC_AREA_CD        --所在地行政区划代码
    ,ACT_PAY_CPTL       --实缴资本
    ,BANK_SHR_PCT       --银行股份占比
    ,ENT_GROW_UP_STAGE  --企业成长阶段
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    )
  SELECT V_P_DATE                      AS DATA_DT            --数据日期
        ,A.LP_ID                       AS LGL_REP_ID         --法人编号
        ,A.ORG_ID                      AS ORG_ID             --机构编号
        ,NULL                          AS COOP_CO_ID         --合作公司编号
        ,NULL                          AS CO_NM              --公司名称
        ,NULL                          AS ESTM_DT            --设立日期
        ,NULL                          AS SUBS_FLG           --子公司标志
        ,NULL                          AS EMP_NUM            --从业人数
        ,NULL                          AS LOC_AREA_CD        --所在地行政区划代码
        ,NULL                          AS ACT_PAY_CPTL       --实缴资本
        ,NULL                          AS BANK_SHR_PCT       --银行股份占比
        ,NULL                          AS ENT_GROW_UP_STAGE  --企业成长阶段
        ,'900919'                      AS DEPT_LINE          --部门条线
        ,UPPER(SUBSTR(A.JOB_CD,0,4))   AS DATA_SRC           --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A  --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.LOAN_TYPE_CD IN ('04') /*华兴无此类业务*/
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

END ETL_M_LOAN_IALL_CO_SUB;
/

