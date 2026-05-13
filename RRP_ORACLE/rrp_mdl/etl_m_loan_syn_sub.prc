CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_SYN_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_SYN_SUB
  *  功能描述：银团贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_SYN_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
                2    20221102  LHQ       改为新一代科目码值
                3    20221103  MW        根据上游口径更改与贷款申请信息的关联口径
                4    20221114  hulj      增加数据重复校验
                5    20250403  LIP       增加参加行，牵头行，代理行相关信息和银团贷款总金额的取数来源
                6    20250414  LAL       一表通，增加合同余额的取值逻辑
                7    20250613  LIP       调整银团贷款总金额，已发放银团贷款金额取数逻辑
                8    20251114  LIP       调整银团贷款总金额，已发放银团贷款金额取数逻辑
                9    20251118  LIP       根据严希婧口径，加工银团贷款总金额时，需对行名去重后汇总金额
                10   20251119  LIP       根据严希婧口径，加工代理行的取数
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
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_SYN_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_SYN_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
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

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '银团贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_SYN_SUB
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,CONT_ID             --合同编号
    ,LEAD_BANK_PBC_NO    --牵头行行号
    ,ATND_BANK_PBC_NO    --参加行行号
    ,AGCY_BANK_PBC_NO    --代理行行号
    ,LEAD_BANK_NM        --牵头行名称
    ,ATND_BANK_NM        --参加行行名
    ,AGCY_BANK_NM        --代理行行名
    ,AGCY_PART_LOAN_FLG  --代理参贷标志
    ,CUR                 --币种
    ,SYN_LOAN_TOT_AMT    --银团贷款总金额
    ,BEAR_LOAN_AMT       --承担贷款金额
    ,DSTR_SYN_LOAN_AMT   --已发放银团贷款金额
    ,DSTR_BEAR_LOAN_AMT  --已发放承担贷款金额
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,CONT_BAL            --合同余额  ADD BY LAL 20250414 一表通，增加字段
    )
    WITH AGT_LOAN_CRDT_ORG_WAY_INFO_H AS ( --MOD BY LIP 20251218 根据严希婧口径，加工银团贷款总金额时，需对行名去重后汇总金额
  SELECT /*+MATERIALIZE*/OBJ_ID --对象ID
         ,BANK_ROLE_TYPE_CD
         ,BANK_ID
         ,BANK_NAME
         ,PROMIS_LOAN_AMT
         ,AGENT_FLG --ADD BY LIP 20251226
         ,ROW_NUMBER() OVER(PARTITION BY OBJ_ID,BANK_NAME ORDER BY BANK_ROLE_TYPE_CD) RN
    FROM RRP_MDL.O_IML_AGT_LOAN_CRDT_ORG_WAY_INFO_H --贷款授信组织方式信息历史
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   LOAN_CRDT_ORG_WAY_INFO_H AS (--MOD BY LIP 20250613
  SELECT /*+MATERIALIZE*/OBJ_ID --对象ID
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '0' THEN TRIM(BANK_ID) END,';')   AS LEAD_BANK_PBC_NO --牵头行行号
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '0' THEN TRIM(BANK_NAME) END,';') AS LEAD_BANK_NM     --牵头行名称
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '1' THEN TRIM(BANK_ID) END,';')   AS ATND_BANK_PBC_NO --参加行行号
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '1' THEN TRIM(BANK_NAME) END,';') AS ATND_BANK_NM     --参加行行名
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '2' THEN TRIM(BANK_ID)
                                WHEN AGENT_FLG = '1' THEN TRIM(BANK_ID) --ADD BY LIP 20251226 根据严希婧口径，代理标识为是的也判断为代理行
                            END,';')   AS AGCY_BANK_PBC_NO --代理行行号
         ,LISTAGG(DISTINCT CASE WHEN BANK_ROLE_TYPE_CD = '2' THEN TRIM(BANK_NAME)
                                WHEN AGENT_FLG = '1' THEN TRIM(BANK_NAME) --ADD BY LIP 20251226 根据严希婧口径，代理标识为是的也判断为代理行
                            END,';') AS AGCY_BANK_NM     --代理行行名
         --,SUM(PROMIS_LOAN_AMT) AS SYN_LOAN_TOT_AMT --银团贷款总金额
         ,SUM(CASE WHEN RN = 1 THEN PROMIS_LOAN_AMT ELSE 0 END) AS SYN_LOAN_TOT_AMT --银团贷款总金额 --MOD BY LIP 20251218
    FROM AGT_LOAN_CRDT_ORG_WAY_INFO_H
   GROUP BY OBJ_ID)
  SELECT V_P_DATE                                        AS DATA_DT             --数据日期
        ,B.LP_ID                                         AS LGL_REP_ID          --法人编号
        ,B.CONT_ID                                       AS CONT_ID             --合同编号
        --MOD BY LIP 20250403 增加取数来源
        ,CASE WHEN TRIM(T2.HOST_BANK_NO) IS NOT NULL THEN TRIM(T2.HOST_BANK_NO)
              --ELSE TRIM(T5.BANK_ID)
              ELSE TRIM(T9.LEAD_BANK_PBC_NO) --MOD BY LIP 20250613
          END                                            AS LEAD_BANK_PBC_NO    --牵头行行号
        ,CASE WHEN TRIM(T2.PATIP_LOAN_BANK_NO) IS NOT NULL THEN TRIM(T2.PATIP_LOAN_BANK_NO)
              --ELSE TRIM(T6.BANK_ID)
              ELSE TRIM(T9.ATND_BANK_PBC_NO) --MOD BY LIP 20250613
          END                                            AS ATND_BANK_PBC_NO    --参加行行号
        ,CASE WHEN TRIM(T2.AGENT_BANK_NO) IS NOT NULL THEN TRIM(T2.AGENT_BANK_NO)
              --ELSE TRIM(T7.BANK_ID)
              ELSE TRIM(T9.AGCY_BANK_PBC_NO) --MOD BY LIP 20250613
          END                                            AS AGCY_BANK_PBC_NO    --代理行行号
        ,CASE WHEN TRIM(T4.HOST_BANK_NAME) IS NOT NULL THEN TRIM(T4.HOST_BANK_NAME)
              --ELSE TRIM(T5.BANK_NAME)
              ELSE TRIM(T9.LEAD_BANK_NM) --MOD BY LIP 20250613
          END                                            AS LEAD_BANK_NM        --牵头行名称
        ,CASE WHEN TRIM(T4.PATIP_LOAN_BANK_NAME) IS NOT NULL THEN TRIM(T4.PATIP_LOAN_BANK_NAME)
              --ELSE TRIM(T6.BANK_NAME)
              ELSE TRIM(T9.ATND_BANK_NM) --MOD BY LIP 20250613
          END                                            AS ATND_BANK_NM        --参加行行名
        ,CASE WHEN TRIM(T4.AGENT_BANK_NAME) IS NOT NULL THEN TRIM(T4.AGENT_BANK_NAME)
              --ELSE TRIM(T7.BANK_NAME)
              ELSE TRIM(T9.AGCY_BANK_NM) --MOD BY LIP 20250613
          END                                            AS AGCY_BANK_NM        --代理行行名
        ,CASE WHEN B.STD_PROD_ID IN ('203010400001','602060100001') THEN '0' --牵头行
              WHEN B.STD_PROD_ID IN ('203010400002') THEN '2' --参贷行
              WHEN B.STD_PROD_ID IN ('602060100002') THEN '1' --代理行
          END                                            AS AGCY_PART_LOAN_FLG  --代理参贷标志 --MODIFY BY TANGAN AT 20221121 代理参贷标志应通过标准产品进行映射
        ,B.CURR_CD                                       AS CUR                 --币种
        ,CASE WHEN NVL(T2.SYN_LOAN_TOT_AMT,0) <> 0 THEN T2.SYN_LOAN_TOT_AMT
              --WHEN B.STD_PROD_ID IN ('203010400002') THEN T9.SYN_LOAN_TOT_AMT --MOD BY LIP 20250613 银团贷款总金额 等于 各成员行承贷金额合计
              WHEN T9.OBJ_ID IS NOT NULL THEN T9.SYN_LOAN_TOT_AMT --MOD BY LIP 20251218 银团贷款总金额 等于 各成员行承贷金额合计
          END                                            AS SYN_LOAN_TOT_AMT    --银团贷款总金额
        ,B.CONT_AMT                                      AS BEAR_LOAN_AMT       --承担贷款金额
        --,B.SYN_LOAN_DISTR_AMT                            AS DSTR_SYN_LOAN_AMT   --已发放银团贷款金额
        ,CASE WHEN NVL(TO_NUMBER(TRIM(T10.TAGVALUE)),0) <> 0 THEN TO_NUMBER(TRIM(T10.TAGVALUE)) --MOD BY LIP 20251114
              WHEN NVL(B.SYN_LOAN_DISTR_AMT,0) <> 0 THEN B.SYN_LOAN_DISTR_AMT
              WHEN B.STD_PROD_ID IN ('203010400002') THEN B.ACM_DISTR_AMT --MOD BY LIP 20250613 如果我行为参加行，则默认该项为我行已发放银团贷款金额
          END                                            AS DSTR_SYN_LOAN_AMT   --已发放银团贷款金额
        ,B.ACM_DISTR_AMT                                 AS DSTR_BEAR_LOAN_AMT  --已发放承担贷款金额
        ,'800919'                                        AS DEPT_LINE           --部门条线 /*风险管理部'02'*/
        ,SUBSTR(B.JOB_CD,1,4)                            AS DATA_SRC            --数据来源
        --,T8.CONT_BAL                                     AS CONT_BAL            --合同余额  ADD BY LAL 20250414 一表通，增加字段
        ,CASE WHEN NVL(TO_NUMBER(TRIM(T11.TAGVALUE)),0) <> 0 THEN TO_NUMBER(TRIM(T11.TAGVALUE)) --MOD BY LIP 20251114
              ELSE T8.CONT_BAL
          END                                            AS CONT_BAL            --合同余额  ADD BY LAL 20250414 一表通，增加字段
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B --对公贷款合同信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO T2
      ON T2.CONT_ID = B.LMT_CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO T3
      ON T3.CRDT_LMT_APV_FLOW_NUM = T2.APV_FLOW_NUM
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO T4
      ON T4.LOAN_APPL_FLOW_NUM = T3.RELA_CRDT_LMT_APV_FLOW_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --MODIFY BY MW 20221103
    LEFT JOIN LOAN_CRDT_ORG_WAY_INFO_H T9 --MOD BY LIP 20250613
      ON T9.OBJ_ID = B.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO T8 --对公贷款业务合同补充信息 ADD BY LAL 20250414
      ON T8.CONT_ID = B.CONT_ID
     AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA T10 --标签值最终表 已发放银团贷款金额 --ADD BY LIP 20251114
      ON T10.OBJECTNO = B.CONT_ID
     AND T10.TAGHIREARCHY = '50' --业务合同层
     AND T10.TAGID = '2025102900000002' --2025102900000002-已发放银团贷款金额
     AND T10.ID_MARK <> 'D'
     AND T10.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T10.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA T11 --标签值最终表 已发放银团贷款余额 --ADD BY LIP 20251114
      ON T11.OBJECTNO = B.CONT_ID
     AND T11.TAGHIREARCHY = '50' --业务合同层
     AND T11.TAGID = '2025102900000003' --2025102900000003-已发放银团贷款余额
     AND T11.ID_MARK <> 'D'
     AND T11.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T11.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.STD_PROD_ID IN ('203010400001','203010400002','602060100001','602060100002') --MODIFY MW 20221102 '203010400001','203010400002' 银团贷款  '602060100001'，'602060100002 表外银团贷款
     AND B.CONT_ID IS NOT NULL
     AND B.SYN_LOAN_TOT_AMT IS NOT NULL
     AND B.CONT_AMT IS NOT NULL
     AND B.SYN_LOAN_DISTR_AMT IS NOT NULL
     AND B.ACM_DISTR_AMT IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,CONT_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_SYN_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CONT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     V_SQLMSG   := '数据重复';
     O_ERRCODE  := '1';
     V_ENDTIME  := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_SYN_SUB;
/

