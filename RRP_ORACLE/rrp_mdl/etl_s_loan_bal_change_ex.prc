CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_BAL_CHANGE_EX(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_BAL_CHANGE_EX
  *  功能描述：不良贷款余额变动分析表
  *  创建日期：20240322
  *  开发人员：卢伟博
  *  来源表：  M_LOAN_IN_DUBILL_INFO
  *
  *
  *  目标表：  S_LOAN_BAL_CHANGE_EX
  *  配置表：  CONFIG_AREA
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1    20240510  lwb      根据G12零售部分新增报表
  *              2    20241012  lwb      新增借新还旧当天还款金额逻辑
  *              3    20251114  HYF      补充取资产证券化收益权转让部分
  *              4    20260410  HYF      按惠州分行要求剔除跨年冲正借据R20220708694554599761
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                 --处理步骤
  V_STEP_DESC VARCHAR2(100);                --处理步骤描述
  V_P_DATE    VARCHAR2(8);                  --跑批数据日期
  V_STARTTIME DATE;                         --处理开始时间
  V_ENDTIME   DATE;                         --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                 --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                --分区名
  V_TAB_NAME VARCHAR2(100) := 'S_LOAN_BAL_CHANGE_EX'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_BAL_CHANGE_EX'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';   --来源系统 --默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY VARCHAR2(8);                 --上一天
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY:= TO_CHAR(TO_DATE(I_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');--上一天

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN_BAL_CHANGE_EX T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_BAL_CHANGE_EX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '记录贷款余额不良变动';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_BAL_CHANGE_EX
    (DATA_DT,    --数据日期
     RCPT_ID,    --借据号
     ORG_ID,    --机构号
     ORG_NM,    --机构名称
     CHANGE_BAL,    --余额变动金额
     CZFS_TYP,    --处置方式
     CZFS_BAL,    --处置金额
     CZFS_DT,    --处置时间
     ZS_HX_DT    --转让或核销时间
    )
  WITH TMP AS
 (SELECT /*+MATERIALIZE*/T.RCPT_ID,
         (T.TRF_LOAN_PRIN - NVL(T1.CNCL_LN_PRIN,T.CNCL_LOAN_PRIN)) AS REPAY_AMT, --转让收回现金
         T.ASSET_TRAN_DT AS TRAN_DT, --转让时间
         T.DATA_SRC
    FROM RRP_MDL.M_LOAN_TRF_REL_INFO T --转让表
    LEFT JOIN RRP_MDL.M_LOAN_CNCL_INFO T1
      ON T1.RCPT_ID = T.RCPT_ID
     AND T1.DATA_SRC = '零售贷款差额核销'
     AND T1.DATA_DT = V_P_DATE
   WHERE T.DATA_SRC IN ('零售贷款单笔转让')
     AND T.DATA_DT = V_P_DATE
   UNION ALL
  SELECT T1.RCPT_ID,
         T1.CNCL_LN_PRIN AS REPAY_AMT, --核销金额
         T1.CNCL_DT      AS TRAN_DT, --核销时间
         T1.DATA_SRC
    FROM RRP_MDL.M_LOAN_CNCL_INFO T1 --全额核销AND差额核销表
   WHERE T1.DATA_SRC IN ('零售贷款差额核销','零售贷款')
     AND T1.DATA_DT = V_P_DATE
   UNION ALL
  selECT T.ORIG_RCPT_NO RCPT_ID,
         T.LOAN_BAL AS REPAY_AMT, --借新还旧的金额
         T.LOAN_ACT_DSTR_DT AS TRAN_DT, --重组贷款的发放时间即转让时间,
         '借新还旧' AS DATA_SRC
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
   WHERE T.LOAN_FRM = '03' --借新还旧
     AND T.DATA_DT = V_P_DATE
     UNION ALL
     SELECT T.ORIG_RCPT_NO RCPT_ID,
         TT.LOAN_BAL_CHANGE-T.LOAN_AMT AS REPAY_AMT, --借新还旧的差额金额--MODIFY BY LWB 20241012
         T.LOAN_ACT_DSTR_DT AS TRAN_DT, --重组贷款的发放时间即转让时间,
         '借新还旧-当天还款' AS DATA_SRC
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
     INNER JOIN RRP_MDL.S_LOAN_BAL_CHANGE TT
      ON T.ORIG_RCPT_NO=TT.RCPT_ID
     AND TT.CHANGE_DT=T.LOAN_ACT_DSTR_DT
   WHERE T.LOAN_FRM = '03' --借新还旧
     AND TT.LOAN_BAL_CHANGE<>T.LOAN_AMT
     AND T.DATA_DT = V_P_DATE
     UNION ALL
    SELECT /*+MATERIALIZE*/T.RCPT_ID,
         (T.TRF_LOAN_PRIN - NVL(T1.CNCL_LN_PRIN,T.CNCL_LOAN_PRIN)) AS REPAY_AMT, --转让收回现金
         T.ASSET_TRAN_DT AS TRAN_DT, --转让时间
         '零售贷款单笔转让' AS DATA_SRC
    FROM RRP_MDL.M_LOAN_TRF_REL_INFO T --转让表
    LEFT JOIN RRP_MDL.M_LOAN_CNCL_INFO T1
      ON T1.RCPT_ID = T.RCPT_ID
     AND T1.DATA_SRC = '零售贷款差额核销'
     AND T1.DATA_DT = V_P_DATE
   WHERE T.DATA_SRC IN ('资产证券化')
     AND T.LOAN_BIZ_TYP = '001' --零售
     AND T.DATA_DT = V_P_DATE          
     ),
     TZ_TMP AS (SELECT T.RCPT_ID,T.CHANGE_DT
FROM RRP_MDL.S_LOAN_BAL_CHANGE T --增量表
INNER JOIN (SELECT T.RCPT_ID,T.LOAN_BAL_CHANGE FROM RRP_MDL.S_LOAN_BAL_CHANGE T
WHERE T.LOAN_BAL_CHANGE<0) TT  --记录不良贷款余额变动中因调账而产生的数据，业务反馈需剔除这类场景的数据
ON T.RCPT_ID=TT.RCPT_ID
WHERE ABS(T.LOAN_BAL_CHANGE)=ABS(TT.LOAN_BAL_CHANGE)
  )
  SELECT V_P_DATE                   AS DATA_DT,
         T.RCPT_ID                  AS RCPT_ID,
         TTTT.ORG_ID                AS ORG_ID,
         TTTT.ORG_NAME              AS ORG_NM,
         T.LOAN_BAL_CHANGE          AS CHANGE_BAL,
         CASE WHEN TT.DATA_SRC = '零售贷款单笔转让' THEN '转让'
              WHEN TT.DATA_SRC = '零售贷款差额核销' THEN '差额核销'
              WHEN TT.DATA_SRC = '零售贷款' THEN '全额核销'
              WHEN TT.DATA_SRC = '借新还旧' THEN '借新还旧'
              WHEN TT.DATA_SRC = '借新还旧-当天还款' THEN '不良贷款收回'--MODIFY BY LWB 20241012
              WHEN TT.DATA_SRC IS NULL THEN '不良贷款收回'
          END                       AS CZFS_TYP,
         NVL(TT.REPAY_AMT,T.LOAN_BAL_CHANGE) AS CZFS_BAL,
         T.CHANGE_DT                AS CZFS_DT,
         TT.TRAN_DT                 AS ZS_HX_DT
    FROM RRP_MDL.S_LOAN_BAL_CHANGE T --该表记录每天的不良贷款变动数据，为增量表
   INNER JOIN RRP_MDL.S_LOAN TTT
      ON TTT.RCPT_ID = T.RCPT_ID
     AND TTT.DATA_DT = V_P_DATE
   LEFT JOIN TZ_TMP TZ
     ON TZ.RCPT_ID=T.RCPT_ID
    AND T.CHANGE_DT=TZ.CHANGE_DT
    LEFT JOIN TMP TT
      ON TT.RCPT_ID = T.RCPT_ID
     AND TT.TRAN_DT = T.CHANGE_DT
    LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO TTTT
      ON TTTT.ORG_ID = TTT.ORG_ID
     AND TTTT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.DATA_SRC = '零售贷款'
     AND TZ.RCPT_ID IS NULL
     AND T.DATA_DT <= V_P_DATE --当年发放到跑批日期之间
     AND T.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
   UNION ALL
  SELECT V_P_DATE                   AS DATA_DT,
         TTT.RCPT_ID                AS RCPT_ID,
         TTTT.ORG_ID                AS ORG_ID,
         TTTT.ORG_NAME              AS ORG_NM,
         0                          AS CHANGE_BAL,
         CASE WHEN TT.DATA_SRC = '零售贷款单笔转让' THEN '转让后收回现金'
              WHEN TT.DATA_SRC = '零售贷款' THEN '核销后收回现金'
          END                       AS CZFS_TYP,
         TTT.TRA_AMT                AS CZFS_BAL,
         TTT.TRA_DT                 AS CZFS_BAL,
         TT.TRAN_DT                 AS ZS_HX_DT
    FROM RRP_MDL.M_TRA_LOAN_DTL TTT
   INNER JOIN TMP TT
      ON TT.RCPT_ID = TTT.RCPT_ID
     AND TT.TRAN_DT < TTT.DATA_DT
     AND TT.DATA_SRC IN ('零售贷款单笔转让', '零售贷款')
   INNER JOIN RRP_MDL.S_LOAN LOAN
      ON LOAN.RCPT_ID = TTT.RCPT_ID
     AND LOAN.DATA_DT = V_P_DATE
    LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO TTTT
      ON TTTT.ORG_ID = LOAN.ORG_ID
     AND TTTT.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TTT.DATA_SRC = '零售贷款收回'
     AND TTT.ABSTR = '贷款回收-本金'
     AND TTT.FLUSH_PATCH_FLG = '1'--正常的收回数据，剔除2：冲正的数据
     AND TTT.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD') --取数限制在当年到跑批日期之间
     AND TTT.DATA_DT <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --剔除跨年冲正借据 20260212
  DELETE FROM RRP_MDL.S_LOAN_BAL_CHANGE_EX A WHERE A.RCPT_ID  IN ('R20220708694554599761') AND A.CZFS_BAL < 0 AND A.DATA_DT = V_P_DATE;
  COMMIT;
  
  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  --程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    --V_STEP := V_STEP + 1;
    --V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_BAL_CHANGE_EX;
/

