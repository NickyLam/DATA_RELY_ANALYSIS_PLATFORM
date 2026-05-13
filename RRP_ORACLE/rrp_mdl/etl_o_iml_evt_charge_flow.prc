CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CHARGE_FLOW(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                      )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_CHARGE_FLOW
  *  功能描述：收费流水
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_CHARGE_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_CHARGE_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_EVT_CHARGE_FLOW T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CHARGE_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-收费流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_CHARGE_FLOW
    (ETL_DT                              --数据日期
    ,EVT_ID                              --事件编号
    ,LP_ID                               --法人编号
    ,CHARGE_SEQ_NUM                      --收费序号
    ,TRAN_DT                             --交易日期
    ,FLOW_NUM                            --流水号
    ,TRAN_SEQ_NUM                        --交易序号
    ,DEP_AGT_ID                          --存款协议编号
    ,CUST_ACCT_NUM                       --客户账号
    ,CURR_CD                             --币种代码
    ,SUB_ACCT_NUM                        --子账号
    ,PROD_ID                             --产品编号
    ,DEP_VOUCH_CATE_CD                   --存款凭证类别代码
    ,VOUCH_BEGIN_NUM                     --凭证起始号码
    ,VOUCH_SUM_QTTY                      --凭证合计数量
    ,CUST_ID                             --客户编号
    ,CUST_TYPE_CD                        --客户类型代码
    ,OPEN_ACCT_ORG_ID                    --开户机构编号
    ,ACCT_FLG_IDF                        --账户标识符
    ,ACCT_ID                             --账户编号
    ,EFFECT_DT                           --生效日期
    ,REVS_ORG_ID                         --冲正机构编号
    ,TRAN_CD                             --交易码
    ,TRAN_ORG_ID                         --交易机构编号
    ,OVA_FLOW_NUM                        --全局流水号
    ,TRAN_REF_NO                         --交易参考号
    ,TRAN_BANK_RATIO                     --交易行比例
    ,INIT_RECVBL_FEE_AMT                 --原应收费用金额
    ,FEE_CHARGE_WAY_CD                   --费用收费方式代码
    ,COMM_FEE_COLL_WAY_CD                --手续费收取方式代码
    ,FEE_TYPE_ID                         --费用类型编号
    ,ACCT_DMIC_CHARGE_CURR_CD            --收费币种代码
    ,ACCT_DMIC_FEE_AMT                   --费用金额
    ,FEE_DISCNT_RAT                      --费用折扣率
    ,FEE_DISCNT_TYPE_CD                  --费用折扣类型代码
    ,RECVBL_FEE_SEQ_NUM                  --应收费用序号
    ,ACCT_BANK_PRFT_CUT_AMT              --账户行分润金额
    ,INIT_FEE_AMT                        --原始费用金额
    ,DISCNT_FEE_AMT                      --折扣费用金额
    ,TRAN_BANK_PRFT_CUT_AMT              --交易行分润金额
    ,TAX                                 --税金
    ,FEE_PRICE                           --费用单价
    ,TAX_RAT                             --税率
    ,TAX_CATEGORY_CD                     --税种代码
    ,AMORT_TM_TYPE_CD                    --摊销时间类型代码
    ,AMORT_TENOR_TYPE_CD                 --摊销期限类型代码
    ,AMORT_DAY                           --摊销日
    ,AMORT_MON                           --摊销月
    ,AMORT_FLG                           --摊销标志
    ,PRFT_CUT_FLG                        --分润标志
    ,POST_FLG                            --过账标志
    ,TRAN_REVD_FLG                       --交易已冲正标志
    ,TRAN_ACCT_SERV_FEE_REVS_SEQ_NUM     --转账服务费冲正序号
    ,REVS_AUTH_TELLER                    --冲正授权柜员编号
    ,REVS_TELLER                         --冲正柜员编号
    ,ORG_TRAN_SEQ_NUM                    --机构交易序号
    ,END_DAY_ONL_CD                      --日终联机代码
    ,TERMNT_NUM                          --终止号码
    ,ACCT_BANK_RATIO                     --账户行比例
    ,CNTPTY_CUST_ACCT_NUM                --对手业务编号
    ,CNTPTY_NAME                         --交易对手名称
    ,CORE_FLOW_NUM                       --核心流水号
    ,TRAN_TM                             --交易时间
    ,TRAN_TELLER_ID                      --交易柜员编号
    ,AMORT_CLOSING_DT                    --摊销截止日期
    ,BUS_FLOW_NUM                        --业务流水号
    ,AMORT_BEGIN_DT                      --摊销起始日期
    ,JOB_CD                              --任务代码
    )
  SELECT 
    ETL_DT                              --数据日期
    ,EVT_ID                              --事件编号
    ,LP_ID                               --法人编号
    ,CHARGE_SEQ_NUM                      --收费序号
    ,TRAN_DT                             --交易日期
    ,FLOW_NUM                            --流水号
    ,TRAN_SEQ_NUM                        --交易序号
    ,DEP_AGT_ID                          --存款协议编号
    ,CUST_ACCT_NUM                       --客户账号
    ,CURR_CD                             --币种代码
    ,SUB_ACCT_NUM                        --子账号
    ,PROD_ID                             --产品编号
    ,DEP_VOUCH_CATE_CD                   --存款凭证类别代码
    ,VOUCH_BEGIN_NUM                     --凭证起始号码
    ,VOUCH_SUM_QTTY                      --凭证合计数量
    ,CUST_ID                             --客户编号
    ,NULL     AS CUST_TYPE_CD            --客户类型代码
    ,OPEN_ACCT_ORG_ID                    --开户机构编号
    ,ACCT_FLG_IDF                        --账户标识符
    ,ACCT_ID                             --账户编号
    ,EFFECT_DT                           --生效日期
    ,REVS_ORG_ID                         --冲正机构编号
    ,TRAN_CD                             --交易码
    ,TRAN_ORG_ID                         --交易机构编号
    ,OVA_FLOW_NUM                        --全局流水号
    ,TRAN_REF_NO                         --交易参考号
    ,TRAN_BANK_RATIO                     --交易行比例
    ,INIT_RECVBL_FEE_AMT                 --原应收费用金额
    ,FEE_CHARGE_WAY_CD                   --费用收费方式代码
    ,COMM_FEE_COLL_WAY_CD                --手续费收取方式代码
    ,FEE_TYPE_ID                         --费用类型编号
    ,ACCT_DMIC_CHARGE_CURR_CD            --收费币种代码
    ,ACCT_DMIC_FEE_AMT                   --费用金额
    ,FEE_DISCNT_RAT                      --费用折扣率
    ,FEE_DISCNT_TYPE_CD                  --费用折扣类型代码
    ,RECVBL_FEE_SEQ_NUM                  --应收费用序号
    ,ACCT_BANK_PRFT_CUT_AMT              --账户行分润金额
    ,INIT_FEE_AMT                        --原始费用金额
    ,DISCNT_FEE_AMT                      --折扣费用金额
    ,TRAN_BANK_PRFT_CUT_AMT              --交易行分润金额
    ,TAX                                 --税金
    ,FEE_PRICE                           --费用单价
    ,TAX_RAT                             --税率
    ,TAX_CATEGORY_CD                     --税种代码
    ,AMORT_TM_TYPE_CD                    --摊销时间类型代码
    ,AMORT_TENOR_TYPE_CD                 --摊销期限类型代码
    ,AMORT_DAY                           --摊销日
    ,AMORT_MON                           --摊销月
    ,AMORT_FLG                           --摊销标志
    ,PRFT_CUT_FLG                        --分润标志
    ,POST_FLG                            --过账标志
    ,TRAN_REVD_FLG                       --交易已冲正标志
    ,TRAN_ACCT_SERV_FEE_REVS_SEQ_NUM     --转账服务费冲正序号
    ,REVS_AUTH_TELLER                    --冲正授权柜员编号
    ,REVS_TELLER                         --冲正柜员编号
    ,ORG_TRAN_SEQ_NUM                    --机构交易序号
    ,END_DAY_ONL_CD                      --日终联机代码
    ,TERMNT_NUM                          --终止号码
    ,ACCT_BANK_RATIO                     --账户行比例
    ,CNTPTY_CUST_ACCT_NUM                --对手业务编号
    ,CNTPTY_NAME                         --交易对手名称
    ,CORE_FLOW_NUM                       --核心流水号
    ,TRAN_TM                             --交易时间
    ,TRAN_TELLER_ID                      --交易柜员编号
    ,AMORT_CLOSING_DT                    --摊销截止日期
    ,BUS_FLOW_NUM                        --业务流水号
    ,AMORT_BEGIN_DT                      --摊销起始日期
    ,JOB_CD                              --任务代码
    FROM IML.V_EVT_CHARGE_FLOW  --视图-代理代销产品信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_EVT_CHARGE_FLOW;
/

