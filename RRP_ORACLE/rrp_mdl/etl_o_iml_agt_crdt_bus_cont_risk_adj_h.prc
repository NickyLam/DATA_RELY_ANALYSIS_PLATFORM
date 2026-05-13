CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H
  *  功能描述：信贷业务合同风险调整历史
  *  创建日期：20221222
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_CRDT_BUS_CONT_RISK_ADJ_H
  *  目标表： O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221222  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-信贷业务合同风险调整历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H
    (AGT_ID                    --协议编号
    ,LP_ID                     --法人编号
    ,FLOW_NUM                  --流水号
    ,CUST_ID                   --客户编号
    ,CUST_NAME                 --客户名称
    ,BUS_CONT_ID               --业务合同编号
    ,BUS_TYPE_CD               --业务类型代码
    ,BUS_CURR_CD               --业务币种代码
    ,BAL                       --余额
    ,BF_ADJ_LEVEL5_CLS_CD      --调整前五级分类代码
    ,A_ADJUST_LEVEL5_CLS_CD    --调整后五级分类代码
    ,BF_ADJ_LEVEL11_CLS_CD     --调整前十一级分类代码
    ,A_ADJUST_LEVEL11_CLS_CD   --调整后十一级分类代码
    ,ADJ_DT                    --调整日期
    ,MG_PROT_TELLER_ID         --管护柜员编号
    ,MG_PROT_ORG_ID            --管护机构编号
    ,RELA_FLOW_ID              --关联流程编号
    ,RELA_FLOW_TYPE_CD         --关联流程类型代码
    ,OBJ_TYPE_CD               --对象类型代码
    ,OBJ_DESCB                 --对象描述
    ,INIT_TELLER_ID            --发起柜员编号
    ,ETL_DT                    --ETL处理日期
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    --,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT 
     AGT_ID                    --协议编号
    ,LP_ID                     --法人编号
    ,FLOW_NUM                  --流水号
    ,CUST_ID                   --客户编号
    ,CUST_NAME                 --客户名称
    ,BUS_CONT_ID               --业务合同编号
    ,BUS_TYPE_CD               --业务类型代码
    ,BUS_CURR_CD               --业务币种代码
    ,BAL                       --余额
    ,BF_ADJ_LEVEL5_CLS_CD      --调整前五级分类代码
    ,A_ADJUST_LEVEL5_CLS_CD    --调整后五级分类代码
    ,BF_ADJ_LEVEL11_CLS_CD     --调整前十一级分类代码
    ,A_ADJUST_LEVEL11_CLS_CD   --调整后十一级分类代码
    ,ADJ_DT                    --调整日期
    ,MG_PROT_TELLER_ID         --管护柜员编号
    ,MG_PROT_ORG_ID            --管护机构编号
    ,RELA_FLOW_ID              --关联流程编号
    ,RELA_FLOW_TYPE_CD         --关联流程类型代码
    ,OBJ_TYPE_CD               --对象类型代码
    ,OBJ_DESCB                 --对象描述
    ,INIT_TELLER_ID            --发起柜员编号
    ,ETL_DT                    --ETL处理日期
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    --,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_AGT_CRDT_BUS_CONT_RISK_ADJ_H
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');  --视图-信贷业务合同风险调整历史

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_CRDT_BUS_CONT_RISK_ADJ_H;
/

