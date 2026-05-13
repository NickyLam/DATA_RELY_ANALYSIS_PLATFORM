CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_ASTCONSV_APPL_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：资产保全申请信息历史
  **存储过程名称：    ETL_O_IML_AGT_ASTCONSV_APPL_INFO_H
  **存储过程创建日期：20250110
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250110    YJY        创建
  *  20251112    YJY        新增部分字段
  ****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_ASTCONSV_APPL_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_ASTCONSV_APPL_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产保全申请信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_ASTCONSV_APPL_INFO_H NOLOGGING 
  (   APPL_ID                     --申请编号
     ,LP_ID                       --法人编号
     ,APPL_FLOW_NUM               --申请流水号
     ,CUST_ID                     --客户编号
     ,CUST_NAME                   --客户名称
     ,THS_TM_ASSET_CLS_CD         --本次资产分类代码
     ,APPL_RS_DESCB               --申请原因描述
     ,DERATE_BF_PRIC_SUM          --减免前本金合计
     ,DERATE_BF_ADV_FEE_SUM       --减免前代垫费用合计
     ,DERATE_BF_COMP_INT_SUM      --减免前复利合计
     ,DERATE_BF_PNLT_SUM          --减免前罚息合计
     ,DERATE_BF_INT_SUM           --减免前利息合计
     ,APV_STATUS_CD               --审批状态代码
     ,CNTPTY_ID                   --交易对手编号
     ,CNTPTY_NAME                 --交易对手名称
     ,DUBIL_QTTY                  --借据数量
     ,BRWER_RESV_RECS_FLG         --对借款人保留追索权标志
     ,GUARTOR_RESV_RECS_FLG       --对保证人保留追索权标志
     ,EXIST_PROPTY_FLG            --存在财产线索标志
     ,ASSET_DESCB                 --资产线索描述
     ,OBJ_TYPE_CD                 --对象类型代码
     ,TRAN_TYPE_CD                --交易类型代码
     ,THS_TM_TRAN_PRIC_SUM        --本次交易本金合计
     ,THS_TM_TRAN_INT_SUM         --本次交易利息合计
     ,THS_TM_COMP_INT_SUM         --本次复利合计
     ,THS_TM_PNLT_SUM             --本次罚息合计
     ,THS_TM_TRAN_ADV_FEE_SUM     --本次交易代垫费用合计
     ,OPER_DT                     --经办日期
     ,OPER_BELONG_ORG_ID          --经办所属机构编号
     ,OPER_TELLER_ID              --经办柜员编号
     ,RELA_FLOW_NUM               --关联流水号
     ,THS_RETURN_POST_ACCT_RECL_AMT  --本次回款后应收款金额
     ,THS_RETURN_BF_ACCT_RECV_AMT --本次回款前应收款金额
     ,THS_TM_RETURN_AMT           --本次回款金额
     ,LAST_ACM_RETURN_AMT         --上一累计回款金额
     ,ACM_RETURN_AMT              --累计回款金额
     ,FST_RETURN_AMT              --首期回款金额
     ,RTN_SUIT_FEE_COSDETN        --用于归还诉讼费的对价
     ,WRT_OFF_TYPE_CD             --核销类型代码
     ,ACCT_RECVBL_ACCT_ID         --应收款账户编号
     ,ACCT_RECVBL_ACCT_NAME       --应收款账户名称
     ,ACCT_RECVBL_AMT             --应收款金额
     ,TRAN_PLAT_CD                --交易平台代码
     ,TRAN_CONT_ID                --转让合同编号
     ,TRAN_WAY_CD                 --转让方式代码
     ,TRAN_PRICE                  --转让价格
     ,REAL_TRAN_COSDETN           --真实转让对价
     ,TRAN_RETURN_ACCT_ID         --转让回款账户编号
     ,TRAN_RETURN_ACCT_NAME       --转让回款账户名称
     ,INSIDE_ACCT_OPEN_ORG_ID     --内部户开立机构编号
     ,RGST_DT                     --登记日期
     ,RGST_BELONG_ORG_ID          --登记所属机构编号
     ,RGST_TELLER_ID              --登记柜员编号
     ,UPDATE_TELLER_ID            --更新柜员编号
     ,UPDATE_ORG_ID               --更新机构编号
     ,REMARK                      --备注
     ,START_DT                    --开始时间
     ,END_DT                      --结束时间
     ,ID_MARK                     --增删标志
     ,SRC_TABLE_NAME              --源表名称
     ,JOB_CD                      --任务编码
     ,ETL_TIMESTAMP               --ETL处理时间戳
     ,DEBT_ASSET_ID	              --抵债资产编号      ADD BY YJY 20251112
     ,DEBT_ASSET_NAME	            --抵债资产名称      ADD BY YJY 20251112
     ,DEBT_AMT	                  --抵债金额          ADD BY YJY 20251112
     ,RECV_DT	                    --接收日期          ADD BY YJY 20251112
     ,DEBT_ASSET_TYPE_CD	        --抵债资产类型代码  ADD BY YJY 20251112
     ,DEBT_TYPE_CD	              --抵债类型代码      ADD BY YJY 20251112
     ,DISP_WAY_CD	                --处置方式代码      ADD BY YJY 20251112
     ,DISP_AMT	                  --处置金额          ADD BY YJY 20251112
     ,DISP_COMNT	                --处置说明          ADD BY YJY 20251112
     ,CREATE_MON	                --生成月份          ADD BY YJY 20251112
     ,CRDT_BAL	                  --授信余额          ADD BY YJY 20251112
     ,LOSS_AMT	                  --损失金额          ADD BY YJY 20251112
     ,CUST_TYPE_CD	              --客户类型代码      ADD BY YJY 20251112
     ,GUAR_WAY_CD	                --担保方式代码      ADD BY YJY 20251112
     ,GUARTOR	                    --保证人            ADD BY YJY 20251112
     ,MTG_DESCB	                  --抵押物描述        ADD BY YJY 20251112
     ,SUIT_PROG	                  --诉讼进展          ADD BY YJY 20251112
     ,LIQD_DISP_PROP	            --清收处置方案      ADD BY YJY 20251112
     ,LATEST_DISP_PROG	          --最新处置进展      ADD BY YJY 20251112
     ,NEXT_WORK_PLAN	            --下一步工作计划    ADD BY YJY 20251112
     ,EXIST_PROB	                --存在问题描述      ADD BY YJY 20251112
     ,DEDUCT_STL_ACCT_ID	        --扣款结算账户编号  ADD BY YJY 20251112
     ,DEDUCT_STL_ACCT_BAL	        --扣款结算账户余额  ADD BY YJY 20251112
     ,DEDUCT_AMT	                --扣划金额          ADD BY YJY 20251112
     ,DEDUCT_REASON	              --扣划理由          ADD BY YJY 20251112
     ,ON_ACCT_ID          	      --挂账编号          ADD BY YJY 20251112
     ,TRANE_CERT_TYPE_CD	        --受让方证件类型代码ADD BY YJY 20251112
     ,TRANE_CERT_NO	              --受让方证件号码    ADD BY YJY 20251112
     ,TRANE_ACCT_ID	              --受让方账户编号    ADD BY YJY 20251112
     ,TRANE_BANK_NO	              --受让方行号        ADD BY YJY 20251112
     ,TRANE_TRAN_ACCT_DT	        --受让方转账日期    ADD BY YJY 20251112
     ,PROP_ID	                    --方案编号          ADD BY YJY 20251112
     ,SIGN_DT	                    --签约日期          ADD BY YJY 20251112
     ,EFFECT_DT	                  --生效日期          ADD BY YJY 20251112
     ,AGT_CURR_CD                 --协议币种代码      ADD BY YJY 20251112
     ,AGT_AMT	                    --协议金额          ADD BY YJY 20251112
     ,MARGIN_AMT	                --保证金金额        ADD BY YJY 20251112
     ,MARGIN_RATIO	              --保证金比例        ADD BY YJY 20251112
     ,MARGIN_CURR_CD	            --保证金币种代码    ADD BY YJY 20251112
     ,COURT_JUDGE_ID	            --法院裁定书编号    ADD BY YJY 20251112
     ,INST_PAY_FLG	              --分期付款标志      ADD BY YJY 20251112
     ,INT_FULL_AMT_DERATE_FLG	    --利息全额减免标志  ADD BY YJY 20251112
    )
    SELECT
     APPL_ID                     --申请编号
     ,LP_ID                       --法人编号
     ,APPL_FLOW_NUM               --申请流水号
     ,CUST_ID                     --客户编号
     ,CUST_NAME                   --客户名称
     ,THS_TM_ASSET_CLS_CD         --本次资产分类代码
     ,APPL_RS_DESCB               --申请原因描述
     ,DERATE_BF_PRIC_SUM          --减免前本金合计
     ,DERATE_BF_ADV_FEE_SUM       --减免前代垫费用合计
     ,DERATE_BF_COMP_INT_SUM      --减免前复利合计
     ,DERATE_BF_PNLT_SUM          --减免前罚息合计
     ,DERATE_BF_INT_SUM           --减免前利息合计
     ,APV_STATUS_CD               --审批状态代码
     ,CNTPTY_ID                   --交易对手编号
     ,CNTPTY_NAME                 --交易对手名称
     ,DUBIL_QTTY                  --借据数量
     ,BRWER_RESV_RECS_FLG         --对借款人保留追索权标志
     ,GUARTOR_RESV_RECS_FLG       --对保证人保留追索权标志
     ,EXIST_PROPTY_FLG            --存在财产线索标志
     ,ASSET_DESCB                 --资产线索描述
     ,OBJ_TYPE_CD                 --对象类型代码
     ,TRAN_TYPE_CD                --交易类型代码
     ,THS_TM_TRAN_PRIC_SUM        --本次交易本金合计
     ,THS_TM_TRAN_INT_SUM         --本次交易利息合计
     ,THS_TM_COMP_INT_SUM         --本次复利合计
     ,THS_TM_PNLT_SUM             --本次罚息合计
     ,THS_TM_TRAN_ADV_FEE_SUM     --本次交易代垫费用合计
     ,OPER_DT                     --经办日期
     ,OPER_BELONG_ORG_ID          --经办所属机构编号
     ,OPER_TELLER_ID              --经办柜员编号
     ,RELA_FLOW_NUM               --关联流水号
     ,THS_RETURN_POST_ACCT_RECL_AMT  --本次回款后应收款金额
     ,THS_RETURN_BF_ACCT_RECV_AMT --本次回款前应收款金额
     ,THS_TM_RETURN_AMT           --本次回款金额
     ,LAST_ACM_RETURN_AMT         --上一累计回款金额
     ,ACM_RETURN_AMT              --累计回款金额
     ,FST_RETURN_AMT              --首期回款金额
     ,RTN_SUIT_FEE_COSDETN        --用于归还诉讼费的对价
     ,WRT_OFF_TYPE_CD             --核销类型代码
     ,ACCT_RECVBL_ACCT_ID         --应收款账户编号
     ,ACCT_RECVBL_ACCT_NAME       --应收款账户名称
     ,ACCT_RECVBL_AMT             --应收款金额
     ,TRAN_PLAT_CD                --交易平台代码
     ,TRAN_CONT_ID                --转让合同编号
     ,TRAN_WAY_CD                 --转让方式代码
     ,TRAN_PRICE                  --转让价格
     ,REAL_TRAN_COSDETN           --真实转让对价
     ,TRAN_RETURN_ACCT_ID         --转让回款账户编号
     ,TRAN_RETURN_ACCT_NAME       --转让回款账户名称
     ,INSIDE_ACCT_OPEN_ORG_ID     --内部户开立机构编号
     ,RGST_DT                     --登记日期
     ,RGST_BELONG_ORG_ID          --登记所属机构编号
     ,RGST_TELLER_ID              --登记柜员编号
     ,UPDATE_TELLER_ID            --更新柜员编号
     ,UPDATE_ORG_ID               --更新机构编号
     ,REMARK                      --备注
     ,START_DT                    --开始时间
     ,END_DT                      --结束时间
     ,ID_MARK                     --增删标志
     ,SRC_TABLE_NAME              --源表名称
     ,JOB_CD                      --任务编码
     ,ETL_TIMESTAMP               --ETL处理时间戳
     ,DEBT_ASSET_ID	              --抵债资产编号      ADD BY YJY 20251112
     ,DEBT_ASSET_NAME	            --抵债资产名称      ADD BY YJY 20251112
     ,DEBT_AMT	                  --抵债金额          ADD BY YJY 20251112
     ,RECV_DT	                    --接收日期          ADD BY YJY 20251112
     ,DEBT_ASSET_TYPE_CD	        --抵债资产类型代码  ADD BY YJY 20251112
     ,DEBT_TYPE_CD	              --抵债类型代码      ADD BY YJY 20251112
     ,DISP_WAY_CD	                --处置方式代码      ADD BY YJY 20251112
     ,DISP_AMT	                  --处置金额          ADD BY YJY 20251112
     ,DISP_COMNT	                --处置说明          ADD BY YJY 20251112
     ,CREATE_MON	                --生成月份          ADD BY YJY 20251112
     ,CRDT_BAL	                  --授信余额          ADD BY YJY 20251112
     ,LOSS_AMT	                  --损失金额          ADD BY YJY 20251112
     ,CUST_TYPE_CD	              --客户类型代码      ADD BY YJY 20251112
     ,GUAR_WAY_CD	                --担保方式代码      ADD BY YJY 20251112
     ,GUARTOR	                    --保证人            ADD BY YJY 20251112
     ,MTG_DESCB	                  --抵押物描述        ADD BY YJY 20251112
     ,SUIT_PROG	                  --诉讼进展          ADD BY YJY 20251112
     ,LIQD_DISP_PROP	            --清收处置方案      ADD BY YJY 20251112
     ,LATEST_DISP_PROG	          --最新处置进展      ADD BY YJY 20251112
     ,NEXT_WORK_PLAN	            --下一步工作计划    ADD BY YJY 20251112
     ,EXIST_PROB	                --存在问题描述      ADD BY YJY 20251112
     ,DEDUCT_STL_ACCT_ID	        --扣款结算账户编号  ADD BY YJY 20251112
     ,DEDUCT_STL_ACCT_BAL	        --扣款结算账户余额  ADD BY YJY 20251112
     ,DEDUCT_AMT	                --扣划金额          ADD BY YJY 20251112
     ,DEDUCT_REASON	              --扣划理由          ADD BY YJY 20251112
     ,ON_ACCT_ID          	      --挂账编号          ADD BY YJY 20251112
     ,TRANE_CERT_TYPE_CD	        --受让方证件类型代码ADD BY YJY 20251112
     ,TRANE_CERT_NO	              --受让方证件号码    ADD BY YJY 20251112
     ,TRANE_ACCT_ID	              --受让方账户编号    ADD BY YJY 20251112
     ,TRANE_BANK_NO	              --受让方行号        ADD BY YJY 20251112
     ,TRANE_TRAN_ACCT_DT	        --受让方转账日期    ADD BY YJY 20251112
     ,PROP_ID	                    --方案编号          ADD BY YJY 20251112
     ,SIGN_DT	                    --签约日期          ADD BY YJY 20251112
     ,EFFECT_DT	                  --生效日期          ADD BY YJY 20251112
     ,AGT_CURR_CD                 --协议币种代码      ADD BY YJY 20251112
     ,AGT_AMT	                    --协议金额          ADD BY YJY 20251112
     ,MARGIN_AMT	                --保证金金额        ADD BY YJY 20251112
     ,MARGIN_RATIO	              --保证金比例        ADD BY YJY 20251112
     ,MARGIN_CURR_CD	            --保证金币种代码    ADD BY YJY 20251112
     ,COURT_JUDGE_ID	            --法院裁定书编号    ADD BY YJY 20251112
     ,INST_PAY_FLG	              --分期付款标志      ADD BY YJY 20251112
     ,INT_FULL_AMT_DERATE_FLG	    --利息全额减免标志  ADD BY YJY 20251112
  FROM IML.V_AGT_ASTCONSV_APPL_INFO_H  --视图-资产保全申请信息历史
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_ASTCONSV_APPL_INFO_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_ASTCONSV_APPL_INFO_H;
/

