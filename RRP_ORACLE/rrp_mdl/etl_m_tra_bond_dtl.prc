CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_BOND_DTL(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_BOND_DTL
  *  功能描述：监管集市债券交易流水，用于债券发行业务
  *  创建日期：20220616
  *  开发人员：程序员
  *  来源表：  M_TRA_BOND_DTL
  *            ICL.CMM_BOND_BASIC_INFO      --债券基本信息
  *            IML.EVT_BOND_ISSUE_TRAN_DTL  --债券发行交易明细
  *
  *  目标表：  M_TRA_BOND_DTL --债券业务交易流水
  *
  *  配置表：  M_TRA_BOND_DTL
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221122  hulj     增加数据重复校验
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
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_BOND_DTL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_BOND_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
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
  V_STEP_DESC := '插入债券业务交易流水信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TRA_BOND_DTL
    (DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,SEQ_NO            --流水号
    ,TRA_TYP           --交易类型
    ,OPP_ACC           --对方账号
    ,OPP_ACC_NM        --对方户名
    ,OPP_PBC_NO        --对方行号
    ,OPP_BANK_NM       --对方行名
    ,TRA_CHAN          --交易渠道
    ,CUR               --币种
    ,TRA_TLR_NO        --交易柜员号
    ,ABSTR             --摘要
    ,FLUSH_PATCH_FLG   --冲补抹标志
    ,TRA_DR_CR_FLG     --交易借贷标志
    ,TRA_TM            --交易时间
    ,ISU_UWRT_SIDE_FLG --发行承销方标志
    ,BOND_ID           --债券编号
    ,ISU_CASH_FLG      --发行兑付标志
    ,TRA_AMT           --交易金额
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')         AS DATA_DT           --数据日期
        ,B.LP_ID                              AS LGL_REP_ID        --法人编号
        ,A.TRAN_ID                            AS SEQ_NO            --流水号
        ,NULL                                 AS TRA_TYP           --交易类型
        ,NULL                                 AS OPP_ACC           --对方账号
        ,NULL                                 AS OPP_ACC_NM        --对方户名
        ,NULL                                 AS OPP_PBC_NO        --对方行号
        ,NULL                                 AS OPP_BANK_NM       --对方行名
        ,NULL                                 AS TRA_CHAN          --交易渠道
        ,B.CURR_CD                            AS CUR               --币种
        ,A.DEALER_ID                          AS TRA_TLR_NO        --交易柜员号
        ,NULL                                 AS ABSTR             --摘要
        ,NULL                                 AS FLUSH_PATCH_FLG   --冲补抹标志
        ,NULL                                 AS TRA_DR_CR_FLG     --交易借贷标志
        ,A.DLVY_DT                            AS TRA_TM            --交易时间
        ,NULL                                 AS ISU_UWRT_SIDE_FLG --发行承销方标志
        ,A.BOND_ID                            AS BOND_ID           --债券编号
        ,CASE WHEN CASE WHEN A.TRAN_DIR_CD = '02' THEN 'B' ELSE 'A' END = 'A' THEN '0'
              WHEN CASE WHEN A.TRAN_DIR_CD = '02' THEN 'B' ELSE 'A' END = 'B' THEN '1'
          END                                 AS ISU_CASH_FLG      --发行兑付标志
        ,A.STL_AMT                            AS TRA_AMT           --交易金额
        ,'00001'                              AS DEPT_LINE         --部门条线 --营运管理部
        ,SUBSTR(A.JOB_CD, 0, 4)               AS DATA_SRC          --数据来源
    FROM RRP_MDL.O_IML_EVT_BOND_ISSUE_TRAN_DTL A --债券发行交易明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON B.BOND_ID = A.BOND_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT S.BOND_ID,S.ENTRY_ORG_ID,S.CUSTM_BOND_ID,
                      ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY S.ISSUE_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST S
                WHERE S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) S --资金债券投资表 ADD BY HAP 20210819取机构号
      ON S.BOND_ID = A.BOND_ID
     AND S.RN = 1
   WHERE A.DLVY_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 数据重复校验 --
  WITH TMP1 AS (
  SELECT DATA_DT,SEQ_NO,BOND_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_BOND_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,SEQ_NO,BOND_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;

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

END ETL_M_TRA_BOND_DTL;
/

