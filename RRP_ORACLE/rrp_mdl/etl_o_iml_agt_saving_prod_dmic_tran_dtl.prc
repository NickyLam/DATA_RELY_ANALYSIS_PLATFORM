CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL(I_P_DATE IN INTEGER, --跑批日期
                                                                    O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL
  *  功能描述：储蓄产品户动账交易明细
  *  创建日期：20220325
  *  开发人员：陈宜玲
  *  来源表：
  *  目标表： O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL
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
  V_PART_NAME VARCHAR2(50);               --表分区名字
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'P'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL';
  --删除当日数据，防止多次跑批导致数据翻倍
  SELECT COUNT(1) INTO V_SQLCOUNT FROM USER_TAB_PARTITIONS T WHERE T.TABLE_NAME = V_TAB_NAME AND T.PARTITION_NAME = V_PART_NAME;
  IF V_SQLCOUNT = 1 THEN
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;
  END IF;
  --创建当日分区
  EXECUTE IMMEDIATE 'ALTER TABLE '||V_TAB_NAME||' ADD PARTITION '||V_PART_NAME||' VALUES '||'('||'TO_DATE('''||V_P_DATE||''',''YYYYMMDD'')'||')'||' COMPRESS NOLOGGING';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-储蓄产品户动账交易明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL NOLOGGING
    (AGT_ID                             --协议编号
    ,LP_ID                              --法人编号
    ,DTL_SEQ_NUM                        --明细序号
    ,LIAB_ACCT_NUM                      --负债账号
    ,ACCT_NAME                          --账户名称
    ,BAL_NAME_FIELD                     --余额名称字段
    ,TRAN_AMT                           --交易金额
    ,BAL                                --余额
    ,CUST_ACCT_NUM                      --客户账号
    ,ACCT_NUM_SEQ_NUM                   --账号序号
    ,PROD_ID                            --产品编号
    ,DEBIT_CRDT_FLG                     --借贷标志
    ,TRAN_CURR_CD                       --交易币种代码
    ,EC_FLG                             --钞汇标志
    ,PROD_BELONG_OBJ_CD                 --产品所属对象代码
    ,CASH_TRANS_CD                      --现转代码
    ,CNTPTY_FIN_INST_TYPE_CD            --对方金融机构类型代码
    ,REC_STATUS_CD                      --记录状态代码
    ,DEP_TERM                           --存期代码
    ,VOUCH_KIND_CD                      --凭证种类代码
    ,VOUCH_BATCH_NO                     --凭证批号
    ,VOUCH_SEQ_NUM                      --凭证序号
    ,TRAN_CHN                           --交易渠道代码
    ,EXT_TRAN_CODE                      --外部交易码
    ,INTNAL_TRAN_CODE                   --内部交易码
    ,TRAN_ORG_ID                        --交易机构编号
    ,TRAN_ACCT_INSTIT_ID                --交易账务机构编号
    ,OPEN_ACCT_ORG_ID                   --开户机构编号
    ,ACCT_ACCT_INSTIT_ID                --账户账务机构编号
    ,OPERR_ID                           --操作员编号
    ,CNTPTY_CUST_ACCT_NUM               --对方客户账号
    ,CNTPTY_ACCT_NAME                   --对方账户名称
    ,CNTPTY_FIN_INST_NAME               --对方金融机构名称
    ,CNTPTY_ACCT_OPEN_BANK_NUM          --交易对手账户开户行号
    ,TELLER_FLOW_NUM                    --柜员流水号
    ,TRAST_DT                           --办理日期
    ,TRAST_TM                           --办理时间
    ,HOST_DT                            --主机日期
    ,REVS_CD                            --冲正代码
    ,BREVS_FLG                          --被冲正标志
    ,WA_INIT_DT                         --错账原日期
    ,WA_INIT_TELLER_FLOW_NUM            --错账原柜员流水号
    ,TRAN_PROC_CHAR                     --交易处理性质
    ,MATN_TELLER_ID                     --维护柜员编号
    ,MATN_ORG_ID                        --维护机构编号
    ,MATN_DT                            --维护日期
    ,MATN_TM                            --维护时间
    ,UPDATE_TM_STAMP                    --更新时间戳
    ,MEMO_ID                            --摘要编号
    ,MEMO_DESCB                         --摘要描述
    ,CNTPTY_ACCT_NUM                    --对方账号
    ,ETL_DT                             --数据日期
    ,SRC_TABLE_NAME                     --源表名称
    ,JOB_CD                             --任务代码
    )
  SELECT /*+PARALLEL*/
        AGT_ID                             --协议编号
        ,LP_ID                              --法人编号
        ,DTL_SEQ_NUM                        --明细序号
        ,LIAB_ACCT_NUM                      --负债账号
        ,ACCT_NAME                          --账户名称
        ,BAL_NAME_FIELD                     --余额名称字段
        ,TRAN_AMT                           --交易金额
        ,BAL                                --余额
        ,CUST_ACCT_NUM                      --客户账号
        ,ACCT_NUM_SEQ_NUM                   --账号序号
        ,PROD_ID                            --产品编号
        ,DEBIT_CRDT_FLG                     --借贷标志
        ,TRAN_CURR_CD                       --交易币种代码
        ,EC_FLG                             --钞汇标志
        ,PROD_BELONG_OBJ_CD                 --产品所属对象代码
        ,CASH_TRANS_CD                      --现转代码
        ,CNTPTY_FIN_INST_TYPE_CD            --对方金融机构类型代码
        ,REC_STATUS_CD                      --记录状态代码
        ,DEP_TERM                           --存期代码
        ,VOUCH_KIND_CD                      --凭证种类代码
        ,VOUCH_BATCH_NO                     --凭证批号
        ,VOUCH_SEQ_NUM                      --凭证序号
        ,TRAN_CHN                           --交易渠道代码
        ,EXT_TRAN_CODE                      --外部交易码
        ,INTNAL_TRAN_CODE                   --内部交易码
        ,TRAN_ORG_ID                        --交易机构编号
        ,TRAN_ACCT_INSTIT_ID                --交易账务机构编号
        ,OPEN_ACCT_ORG_ID                   --开户机构编号
        ,ACCT_ACCT_INSTIT_ID                --账户账务机构编号
        ,OPERR_ID                           --操作员编号
        ,CNTPTY_CUST_ACCT_NUM               --对方客户账号
        ,CNTPTY_ACCT_NAME                   --对方账户名称
        ,CNTPTY_FIN_INST_NAME               --对方金融机构名称
        ,CNTPTY_ACCT_OPEN_BANK_NUM          --交易对手账户开户行号
        ,TELLER_FLOW_NUM                    --柜员流水号
        ,TRAST_DT                           --办理日期
        ,TRAST_TM                           --办理时间
        ,HOST_DT                            --主机日期
        ,REVS_CD                            --冲正代码
        ,BREVS_FLG                          --被冲正标志
        ,WA_INIT_DT                         --错账原日期
        ,WA_INIT_TELLER_FLOW_NUM            --错账原柜员流水号
        ,TRAN_PROC_CHAR                     --交易处理性质
        ,MATN_TELLER_ID                     --维护柜员编号
        ,MATN_ORG_ID                        --维护机构编号
        ,MATN_DT                            --维护日期
        ,MATN_TM                            --维护时间
        ,UPDATE_TM_STAMP                    --更新时间戳
        ,MEMO_ID                            --摘要编号
        ,MEMO_DESCB                         --摘要描述
        ,CNTPTY_ACCT_NUM                    --对方账号
        ,ETL_DT                             --数据日期
        ,SRC_TABLE_NAME                     --源表名称
        ,JOB_CD                             --任务代码
    FROM IML.V_AGT_SAVING_PROD_DMIC_TRAN_DTL  --储蓄产品户动账交易明细_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL',V_PART_NAME, O_ERRCODE);

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

END ETL_O_IML_AGT_SAVING_PROD_DMIC_TRAN_DTL;
/

