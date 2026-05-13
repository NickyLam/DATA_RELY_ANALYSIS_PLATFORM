CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_ASTCONSV_DUBIL_RELA_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：资产保全与借据关联信息历史
  **存储过程名称：    ETL_O_IML_AGT_ASTCONSV_DUBIL_RELA_H
  **存储过程创建日期：20250110
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250110    YJY        创建
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_ASTCONSV_DUBIL_RELA_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_ASTCONSV_DUBIL_RELA_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产保全与借据关联信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_ASTCONSV_DUBIL_RELA_H NOLOGGING 
  (   APPL_ID                          --申请编号
      ,LP_ID                           --法人编号
      ,FLOW_NUM                        --流水号
      ,RELA_FLOW_NUM                   --关联流水号
      ,BUS_TYPE_CD                     --业务类型代码
      ,THS_TM_ASSET_CLS_CD             --本次资产分类代码
      ,ALDY_CMPLT_FLG                  --已完善标志
      ,DISP_PLAN_AND_PROG_DESCB        --处置计划及进展描述
      ,ON_ACCT_SEQ_NUM                 --挂账序号
      ,DERATE_BF_PRIC_TOT              --减免前本金汇总
      ,DERATE_PRIC                     --减免本金
      ,DERATE_PROVI_COMP_INT           --减免计提复利
      ,DERATE_PROVI_INT                --减免计提利息
      ,DERATE_PROVI_PNLT               --减免计提罚息
      ,DERATE_OVDUE_PRIC               --减免逾期本金
      ,DERATE_INT_RAT                  --减免利率
      ,DERATE_ACTL_OWE_COMP_INT        --减免实欠复利
      ,DERATE_ACTL_OWE_INT             --减免实欠利息
      ,DERATE_ACTL_OWE_PNLT            --减免实欠罚息
      ,ACCTI_STATUS_CD                 --核算状态代码
      ,LAST_ASSET_CLS_CD               --上一资产分类代码
      ,ASSET_DESCB                     --资产线索描述
      ,CORE_SUCS_RETURN_REST_FLG       --核心成功返回结果标志
      ,CORE_RETURN_REST                --核心返回结果
      ,THS_RETURN_POST_ACCT_RECL_AMT   --本次回款后应收款金额
      ,THS_RETURN_BF_ACCT_RECV_AMT     --本次回款前应收款金额
      ,ACM_RETURN_AMT                  --累计回款金额
      ,REVS_STATUS_CD                  --冲正状态代码
      ,ASSIGN_TRAN_PRICE               --分配转让价格
      ,ASSIGN_TRAN_FST_PRICE           --分配转让首期价格
      ,ASSIGN_TRAN_ACCT_RECVBL_PRICE   --分配转让应收款价格
      ,WRT_OFF_ADV_FEE                 --核销代垫费用
      ,SUIT_PROG_DESCB                 --诉讼进展描述
      ,RGST_DT                         --登记日期
      ,RGST_BELONG_ORG_ID              --登记所属机构编号
      ,RGST_TELLER_ID                  --登记柜员编号
      ,UPDATE_TELLER_ID                --更新柜员编号
      ,UPDATE_ORG_ID                   --更新机构编号
      ,REMARK                          --备注
      ,START_DT                        --开始时间
      ,END_DT                          --结束时间
      ,ID_MARK                         --增删标志
      ,SRC_TABLE_NAME                  --源表名称
      ,JOB_CD                          --任务编码
      ,ETL_TIMESTAMP                   --ETL处理时间戳
    )
    SELECT
      APPL_ID                          --申请编号
      ,LP_ID                           --法人编号
      ,FLOW_NUM                        --流水号
      ,RELA_FLOW_NUM                   --关联流水号
      ,BUS_TYPE_CD                     --业务类型代码
      ,THS_TM_ASSET_CLS_CD             --本次资产分类代码
      ,ALDY_CMPLT_FLG                  --已完善标志
      ,DISP_PLAN_AND_PROG_DESCB        --处置计划及进展描述
      ,ON_ACCT_SEQ_NUM                 --挂账序号
      ,DERATE_BF_PRIC_TOT              --减免前本金汇总
      ,DERATE_PRIC                     --减免本金
      ,DERATE_PROVI_COMP_INT           --减免计提复利
      ,DERATE_PROVI_INT                --减免计提利息
      ,DERATE_PROVI_PNLT               --减免计提罚息
      ,DERATE_OVDUE_PRIC               --减免逾期本金
      ,DERATE_INT_RAT                  --减免利率
      ,DERATE_ACTL_OWE_COMP_INT        --减免实欠复利
      ,DERATE_ACTL_OWE_INT             --减免实欠利息
      ,DERATE_ACTL_OWE_PNLT            --减免实欠罚息
      ,ACCTI_STATUS_CD                 --核算状态代码
      ,LAST_ASSET_CLS_CD               --上一资产分类代码
      ,ASSET_DESCB                     --资产线索描述
      ,CORE_SUCS_RETURN_REST_FLG       --核心成功返回结果标志
      ,CORE_RETURN_REST                --核心返回结果
      ,THS_RETURN_POST_ACCT_RECL_AMT   --本次回款后应收款金额
      ,THS_RETURN_BF_ACCT_RECV_AMT     --本次回款前应收款金额
      ,ACM_RETURN_AMT                  --累计回款金额
      ,REVS_STATUS_CD                  --冲正状态代码
      ,ASSIGN_TRAN_PRICE               --分配转让价格
      ,ASSIGN_TRAN_FST_PRICE           --分配转让首期价格
      ,ASSIGN_TRAN_ACCT_RECVBL_PRICE   --分配转让应收款价格
      ,WRT_OFF_ADV_FEE                 --核销代垫费用
      ,SUIT_PROG_DESCB                 --诉讼进展描述
      ,RGST_DT                         --登记日期
      ,RGST_BELONG_ORG_ID              --登记所属机构编号
      ,RGST_TELLER_ID                  --登记柜员编号
      ,UPDATE_TELLER_ID                --更新柜员编号
      ,UPDATE_ORG_ID                   --更新机构编号
      ,REMARK                          --备注
      ,START_DT                        --开始时间
      ,END_DT                          --结束时间
      ,ID_MARK                         --增删标志
      ,SRC_TABLE_NAME                  --源表名称
      ,JOB_CD                          --任务编码
      ,ETL_TIMESTAMP                   --ETL处理时间戳
  FROM IML.V_AGT_ASTCONSV_DUBIL_RELA_H  --视图-资产保全与借据关联信息历史
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_ASTCONSV_DUBIL_RELA_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_ASTCONSV_DUBIL_RELA_H;
/

