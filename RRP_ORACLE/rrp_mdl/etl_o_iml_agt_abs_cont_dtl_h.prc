CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_ABS_CONT_DTL_H(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_ABS_CONT_DTL_H
  *  功能描述：资产转让合同明细
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.AGT_ABS_CONT_DTL_H
  *  目标表： O_IML_AGT_ABS_CONT_DTL_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_ABS_CONT_DTL_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_ABS_CONT_DTL_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产转让合同明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_ABS_CONT_DTL_H
    (AGT_ID			                  --协议编号
    ,LP_ID			                  --法人编号
    ,ASSET_BAG_CONT_DTL_SEQ_NUM		--资产包合同明细序号
    ,ASSET_BAG_CONT_ID			      --资产包合同编号
    ,LOAN_NUM			                --贷款号
    ,DISTR_FLOW_NUM			          --放款流水号
    ,PROD_ID			                --产品编号
    ,CURR_CD			                --币种代码
    ,ACCT_ID			                --账户编号
    ,CUST_ID			                --客户编号
    ,ACCTI_STATUS_CD			        --核算状态代码
    ,BAL			                    --余额
    ,ASSET_ACCT_STATUS_CD			    --资产账户状态代码
    ,ISSUE_BATCH_NO			          --发行批次号
    ,ISSUE_FLOW_NUM			          --发行流水号
    ,ISSUE_CONVT_PREM			        --发行折溢价
    ,ISSUE_REVO_BATCH_NO			    --发行撤销批次号
    ,CIRCL_BUY_FLG			          --循环购买标志
    ,CIRCL_BUY_BATCH_NO			      --循环购买批次号
    ,CIRCL_BUY_FLOW_NUM			      --循环购买流水号
    ,CIRCL_BUY_DT			            --循环购买日期
    ,REVO_PKG_BATCH_NO			      --撤包批次号
    ,REVO_PKG_TRAN_FLOW_NUM			  --撤包交易流水号
    ,REVO_TRAN_REF_NO			        --撤销交易参考号
    ,REDEM_TRAN_FLOW_NUM			    --赎回交易流水号
    ,REDEM_BATCH_NO			          --赎回批次号
    ,REDEM_CONVT_PREM			        --赎回折溢价
    ,PKG_BATCH_NO			            --封包批次号
    ,PKG_FLOW_NUM			            --封包流水号
    ,PKG_TRAN_DT			            --封包交易日期
    ,TRAN_CODE_DESCB			        --交易码描述
    ,FINAL_MODIF_DT			          --最后修改日期
    ,START_DT			                --开始时间
    ,END_DT			                  --结束时间
    ,ID_MARK			                --增删标志
    ,SRC_TABLE_NAME			          --源表名称
    ,JOB_CD			                  --任务编码
    ,ETL_TIMESTAMP			          --etl处理时间戳
    )
  SELECT 
    AGT_ID			                  --协议编号
    ,LP_ID			                  --法人编号
    ,ASSET_BAG_CONT_DTL_SEQ_NUM		--资产包合同明细序号
    ,ASSET_BAG_CONT_ID			      --资产包合同编号
    ,LOAN_NUM			                --贷款号
    ,DISTR_FLOW_NUM			          --放款流水号
    ,PROD_ID			                --产品编号
    ,CURR_CD			                --币种代码
    ,ACCT_ID			                --账户编号
    ,CUST_ID			                --客户编号
    ,ACCTI_STATUS_CD			        --核算状态代码
    ,BAL			                    --余额
    ,ASSET_ACCT_STATUS_CD			    --资产账户状态代码
    ,ISSUE_BATCH_NO			          --发行批次号
    ,ISSUE_FLOW_NUM			          --发行流水号
    ,ISSUE_CONVT_PREM			        --发行折溢价
    ,ISSUE_REVO_BATCH_NO			    --发行撤销批次号
    ,CIRCL_BUY_FLG			          --循环购买标志
    ,CIRCL_BUY_BATCH_NO			      --循环购买批次号
    ,CIRCL_BUY_FLOW_NUM			      --循环购买流水号
    ,CIRCL_BUY_DT			            --循环购买日期
    ,REVO_PKG_BATCH_NO			      --撤包批次号
    ,REVO_PKG_TRAN_FLOW_NUM			  --撤包交易流水号
    ,REVO_TRAN_REF_NO			        --撤销交易参考号
    ,REDEM_TRAN_FLOW_NUM			    --赎回交易流水号
    ,REDEM_BATCH_NO			          --赎回批次号
    ,REDEM_CONVT_PREM			        --赎回折溢价
    ,PKG_BATCH_NO			            --封包批次号
    ,PKG_FLOW_NUM			            --封包流水号
    ,PKG_TRAN_DT			            --封包交易日期
    ,TRAN_CODE_DESCB			        --交易码描述
    ,FINAL_MODIF_DT			          --最后修改日期
    ,START_DT			                --开始时间
    ,END_DT			                  --结束时间
    ,ID_MARK			                --增删标志
    ,SRC_TABLE_NAME			          --源表名称
    ,JOB_CD			                  --任务编码
    ,ETL_TIMESTAMP			          --etl处理时间戳
    FROM IML.V_AGT_ABS_CONT_DTL_H  --视图-资产转让合同明细
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_ABS_CONT_DTL_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_ABS_CONT_DTL_H;
/

