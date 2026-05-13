CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_RETL_LOAN_ASSET_TRAN_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_RETL_LOAN_ASSET_TRAN_H
  *  功能描述：零售贷款账户资产转让历史
  *  创建日期：20220401
  *  开发人员：
  *  来源表：
  *  目标表： O_IML_AGT_RETL_LOAN_ASSET_TRAN_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_RETL_LOAN_ASSET_TRAN_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_RETL_LOAN_ASSET_TRAN_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款账户资产转让历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_RETL_LOAN_ASSET_TRAN_H NOLOGGING
    (AGT_ID                          --协议编号
    ,LP_ID                           --法人编号
    ,DUBIL_ID                        --借据编号
    ,ACCT_ID                         --账户编号
    ,BUS_ORG_ID                      --营业机构编号
    ,ASSET_BAG_ID                    --资产包编号
    ,ASSET_BAG_NAME                  --资产包名称
    ,INIT_PROD_ID                    --原产品编号
    ,INIT_PROD_NAME                  --原产品名称
    ,PROD_ID                         --产品编号
    ,PROD_NAME                       --产品名称
    ,INIT_BUS_BREED_CD               --原业务品种代码
    ,BUS_BREED_CD                    --业务品种代码
    ,PKG_DT                          --封包日期
    ,PKG_FLOW_NUM                    --封包流水号
    ,UNPKG_DT                        --拆包日期
    ,UNPKG_FLOW_NUM                  --拆包流水号
    ,POST_PKG_TRAN_DT                --延后封包的交易日期
    ,POST_PKG_TRAN_FLOW_NUM          --延后封包交易流水号
    ,ASSET_TRAN_DT                   --资产转让日期
    ,ASSET_TRAN_FLOW_NUM             --资产转让流水号
    ,CANCEL_ASSET_BAG_DT             --取消资产包日期
    ,CANCEL_ASSET_BAG_FLOW_NUM       --取消资产包流水号
    ,ASSET_END_DT                    --资产终结日期
    ,ASSET_END_TRAN_FLOW_NUM         --资产终结交易流水号
    ,REDEM_DT                        --赎回日期
    ,REDEM_TRAN_FLOW_NUM             --赎回交易流水号
    ,BUY_DT                          --购买日期
    ,BUY_TRAN_FLOW_NUM               --购买交易流水号
    ,ASSET_STATUS_CD                 --资产状态代码
    ,PKG_PRIC_AMT                    --封包本金金额
    ,PKG_RECVBL_ACRU_INT             --封包应收应计利息
    ,PKG_COLL_ACRU_INT               --封包催收应计利息
    ,PKG_RECVBL_OVER_INT             --封包应收欠息
    ,PKG_COLL_OVER_INT               --封包催收欠息
    ,PKG_RECVBL_ACRU_PNLT            --封包应收应计罚息
    ,PKG_COLL_ACRU_PNLT              --封包催收应计罚息
    ,PKG_RECVBL_PNLT                 --封包应收罚息
    ,PKG_COLL_PNLT                   --封包催收罚息
    ,PKG_ACRU_COMP_INT               --封包应计复息
    ,PKG_COMP_INT                    --封包复息
    ,REPAID_PRIC_TOT                 --已偿本金总额
    ,REPAID_RECVBL_ACRU_INT          --已偿应收应计利息
    ,REPAID_COLL_ACRU_INT            --已偿催收应计利息
    ,REPAID_RECVBL_OVER_INT          --已偿应收欠息
    ,REPAID_COLL_OVER_INT            --已偿催收欠息
    ,REPAID_RECVBL_ACRU_PNLT         --已偿应收应计罚息
    ,REPAID_COLL_ACRU_PNLT           --已偿催收应计罚息
    ,REPAID_RECVBL_PNLT              --已偿应收罚息
    ,REPAID_COLL_PNLT                --已偿催收罚息
    ,REPAID_ACRU_COMP_INT            --已偿应计复息
    ,REPAID_COMP_INT                 --已偿复息
    ,LD_REPAID_PRIC_TOT              --上日已偿本金总额
    ,LD_REPAID_RECVBL_ACRU_INT       --上日已偿应收应计利息
    ,LD_REPAID_COLL_ACRU_INT         --上日已偿催收应计利息
    ,LD_REPAID_RECVBL_OVER_INT       --上日已偿应收欠息
    ,LD_REPAID_COLL_OVER_INT         --上日已偿催收欠息
    ,LD_REPAID_RECVBL_ACRU_PNLT      --上日已偿应收应计罚息
    ,LD_REPAID_COLL_ACRU_PNLT        --上日已偿催收应计罚息
    ,LD_REPAID_RECVBL_PNLT           --上日已偿应收罚息
    ,LD_REPAID_COLL_PNLT             --上日已偿催收罚息
    ,LD_REPAID_ACRU_COMP_INT         --上日已偿应计复息
    ,LD_REPAID_COMP_INT              --上日已偿复息
    ,TRAN_AMT                        --转让金额
    ,REDEM_AMT                       --赎回金额
    ,FINAL_FIN_TRAN_DT               --最后财务交易日期
    ,REC_STATUS_CD                   --记录状态代码
    ,START_DT                        --开始时间
    ,END_DT                          --结束时间
    ,ID_MARK                         --增删标志
    ,SRC_TABLE_NAME                  --源表名称
    ,JOB_CD                          --任务编码
    )
  SELECT /*+PARALLEL*/
         AGT_ID                          --协议编号
        ,LP_ID                           --法人编号
        ,DUBIL_ID                        --借据编号
        ,ACCT_ID                         --账户编号
        ,BUS_ORG_ID                      --营业机构编号
        ,ASSET_BAG_ID                    --资产包编号
        ,ASSET_BAG_NAME                  --资产包名称
        ,INIT_PROD_ID                    --原产品编号
        ,INIT_PROD_NAME                  --原产品名称
        ,PROD_ID                         --产品编号
        ,PROD_NAME                       --产品名称
        ,INIT_BUS_BREED_CD               --原业务品种代码
        ,BUS_BREED_CD                    --业务品种代码
        ,PKG_DT                          --封包日期
        ,PKG_FLOW_NUM                    --封包流水号
        ,UNPKG_DT                        --拆包日期
        ,UNPKG_FLOW_NUM                  --拆包流水号
        ,POST_PKG_TRAN_DT                --延后封包的交易日期
        ,POST_PKG_TRAN_FLOW_NUM          --延后封包交易流水号
        ,ASSET_TRAN_DT                   --资产转让日期
        ,ASSET_TRAN_FLOW_NUM             --资产转让流水号
        ,CANCEL_ASSET_BAG_DT             --取消资产包日期
        ,CANCEL_ASSET_BAG_FLOW_NUM       --取消资产包流水号
        ,ASSET_END_DT                    --资产终结日期
        ,ASSET_END_TRAN_FLOW_NUM         --资产终结交易流水号
        ,REDEM_DT                        --赎回日期
        ,REDEM_TRAN_FLOW_NUM             --赎回交易流水号
        ,BUY_DT                          --购买日期
        ,BUY_TRAN_FLOW_NUM               --购买交易流水号
        ,ASSET_STATUS_CD                 --资产状态代码
        ,PKG_PRIC_AMT                    --封包本金金额
        ,PKG_RECVBL_ACRU_INT             --封包应收应计利息
        ,PKG_COLL_ACRU_INT               --封包催收应计利息
        ,PKG_RECVBL_OVER_INT             --封包应收欠息
        ,PKG_COLL_OVER_INT               --封包催收欠息
        ,PKG_RECVBL_ACRU_PNLT            --封包应收应计罚息
        ,PKG_COLL_ACRU_PNLT              --封包催收应计罚息
        ,PKG_RECVBL_PNLT                 --封包应收罚息
        ,PKG_COLL_PNLT                   --封包催收罚息
        ,PKG_ACRU_COMP_INT               --封包应计复息
        ,PKG_COMP_INT                    --封包复息
        ,REPAID_PRIC_TOT                 --已偿本金总额
        ,REPAID_RECVBL_ACRU_INT          --已偿应收应计利息
        ,REPAID_COLL_ACRU_INT            --已偿催收应计利息
        ,REPAID_RECVBL_OVER_INT          --已偿应收欠息
        ,REPAID_COLL_OVER_INT            --已偿催收欠息
        ,REPAID_RECVBL_ACRU_PNLT         --已偿应收应计罚息
        ,REPAID_COLL_ACRU_PNLT           --已偿催收应计罚息
        ,REPAID_RECVBL_PNLT              --已偿应收罚息
        ,REPAID_COLL_PNLT                --已偿催收罚息
        ,REPAID_ACRU_COMP_INT            --已偿应计复息
        ,REPAID_COMP_INT                 --已偿复息
        ,LD_REPAID_PRIC_TOT              --上日已偿本金总额
        ,LD_REPAID_RECVBL_ACRU_INT       --上日已偿应收应计利息
        ,LD_REPAID_COLL_ACRU_INT         --上日已偿催收应计利息
        ,LD_REPAID_RECVBL_OVER_INT       --上日已偿应收欠息
        ,LD_REPAID_COLL_OVER_INT         --上日已偿催收欠息
        ,LD_REPAID_RECVBL_ACRU_PNLT      --上日已偿应收应计罚息
        ,LD_REPAID_COLL_ACRU_PNLT        --上日已偿催收应计罚息
        ,LD_REPAID_RECVBL_PNLT           --上日已偿应收罚息
        ,LD_REPAID_COLL_PNLT             --上日已偿催收罚息
        ,LD_REPAID_ACRU_COMP_INT         --上日已偿应计复息
        ,LD_REPAID_COMP_INT              --上日已偿复息
        ,TRAN_AMT                        --转让金额
        ,REDEM_AMT                       --赎回金额
        ,FINAL_FIN_TRAN_DT               --最后财务交易日期
        ,REC_STATUS_CD                   --记录状态代码
        ,START_DT                        --开始时间
        ,END_DT                          --结束时间
        ,ID_MARK                         --增删标志
        ,SRC_TABLE_NAME                  --源表名称
        ,JOB_CD                          --任务编码
    FROM IML.V_AGT_RETL_LOAN_ASSET_TRAN_H  --零售贷款账户资产转让历史_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_RETL_LOAN_ASSET_TRAN_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_RETL_LOAN_ASSET_TRAN_H;
/

