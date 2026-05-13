CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_DEP_ACCT_LMT_INFO_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_DEP_ACCT_LMT_INFO_H
  *  功能描述：存款账户限制信息历史
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IML.V_AGT_DEP_ACCT_LMT_INFO_H
  *  目标表： O_IML_AGT_DEP_ACCT_LMT_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_DEP_ACCT_LMT_INFO_H'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_DEP_ACCT_LMT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款账户限制信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_DEP_ACCT_LMT_INFO_H NOLOGGING
    (     AGT_ID                    --协议编号
         ,LP_ID                        --法人编号
         ,ACCT_ID                    --账户编号
         ,TRAN_LMT_TYPE_CD                --交易限制类型代码
         ,LMT_ID                    --限制编号
         ,ACCT_LMT_STATUS_CD              --账户限制状态代码
         ,LMT_ACCT_RANGE_CD                --限制账户范围代码
         ,ACCT_LMT_AMT                  --账户限制金额
         ,SUB_LMT_CATE_CD                --子限制类别代码
         ,ACTL_CTRL_AMT                  --实际控制金额
         ,ACTL_EFFECT_DT                --实际生效日期
         ,EFFECT_DT                    --生效日期
         ,INVALID_DT                  --失效日期
         ,OVA_FLOW_NUM                  --全局流水号
         ,CUST_ID                    --客户编号
         ,CUST_NAME                    --客户名称
         ,DEP_TENOR                    --存款期限
         ,TENOR_TYPE_CD                --期限类型代码
         ,ACCT_ALDY_CHECK_FLG            --账户已复核标志
         ,ACCT_CHECK_DT                --账户复核日期
         ,TRAN_REF_NO                --交易参考号
         ,TRAN_CD                    --交易码
         ,TRAN_CHN_CD                --交易渠道代码
         ,TRAN_MEMO_DESCB            --交易摘要描述
         ,TRAN_DT                    --交易日期
         ,TRAN_TM                    --交易时间
         ,TRAN_AMT                    --交易金额
         ,TRAN_TELLER_ID                --交易柜员编号
         ,TRAN_ORG_ID                  --交易机构编号
         ,CNTPTY_ACCT_PROD_ID          --交易对手账户产品编号
         ,CNTPTY_ACCT_ID            --交易对手账户编号
         ,CNTPTY_ACCT_NAME            --交易对手账户名称
         ,CNTPTY_CUST_ACCT_NUM          --交易对手客户账号
         ,CNTPTY_CURR_CD            --交易对手币种代码
         ,CNTPTY_OPEN_ACCT_ORG_ID        --交易对手开户机构编号
         ,VOUCH_TYPE_CD                  --凭证类型代码
         ,BEGIN_CHECK_ID                --起始支票编号
         ,BEGIN_AMT                    --起始金额
         ,TERMNT_CHECK_ID                --终止支票编号
         ,STOP_AMT                    --截止金额
         ,ALDY_PAID_AMT                  --已还金额
         ,PAY_AMT                    --支付金额
         ,TOT_PAY_CNT                  --总支付笔数
         ,ALDY_PAY_CNT                  --已支付笔数
         ,INTERP_FLG                  --中断标志
         ,PM_FLG                    --抵质押标志
         ,MTG_ACCT_ID                  --抵押账户编号
         ,MTG_CUST_ACCT_NUM            --抵押客户账号
         ,MTG_ACCT_CURR_CD            --抵押账户币种代码
         ,MTG_ACCT_TYPE_CD            --抵押账户类型代码
         ,MATN_WAY_CD                --维护方式代码
         ,STL_FLOW_ID                --结算流水编号
         ,CHECK_ENTRY_CODE            --对账编码
         ,REVS_FLG                    --冲正标志
         ,WAIT_TO_FROZ_SEQ_NUM          --轮候冻结序号
         ,FULL_AMT_FROZ_FLG            --全额冻结标志
         ,CT_FROZ_FLG                --续冻标志
         ,FROZ_ORG_NAME                --冻结机关名称
         ,FROZ_ORG_LAW_DOC_NUM            --冻结机关法律文书号码
         ,FROZ_LEV                    --冻结级别
         ,UNFRZ_ORG_NAME            --解冻机关名称
         ,UNFRZ_ORG_LAW_DOC_NUM          --解冻机关法律文书号码
         ,UNLOSS_TM                    --解挂时间
         ,UNLOSS_TELLER_ID            --解挂柜员编号
         ,CAN_DEDUCT_AMT            --可扣划金额
         ,DEDUCT_LAW_DOC_NUM          --扣划法律文书号码
         ,AUTH_ORG_NAME                --有权机关名称
         ,EXEC_ORG_CD                --执行机关代码
         ,ASIT_EXEC_ITEM              --协助执行事项
         ,ENFORC_PS_1_NAME              --执法人1名称
         ,ENFORC_PS_1_CERT_A_TYPE_CD      --执法人1证件A类型代码
         ,ENFORC_PS_1_CERT_A_NO          --执法人1证件A号码
         ,ENFORC_PS_1_CERT_B_TYPE_CD    --执法人1证件B类型代码
         ,ENFORC_PS_1_CERT_B_NO        --执法人1证件B号码
         ,ENFORC_PS_2_NAME            --执法人2名称
         ,ENFORC_PS_2_CERT_A_TYPE_CD    --执法人2证件A类型代码
         ,ENFORC_PS_2_CERT_A_NO        --执法人2证件A号码
         ,ENFORC_PS_2_CERT_B_TYPE_CD    --执法人2证件B类型代码
         ,ENFORC_PS_2_CERT_B_NO        --执法人2证件B号码
         ,OPERR_1_NAME                --经办人1名称
         ,OPERR_1_CERT_A_TYPE_CD      --经办人1证件A类型代码
         ,OPERR_1_CERT_A_NO            --经办人1证件A号码
         ,OPERR_1_CERT_B_TYPE_CD        --经办人1证件B类型代码
         ,OPERR_1_CERT_B_NO            --经办人1证件B号码
         ,OPERR_2_NAME                --经办人2名称
         ,OPERR_2_CERT_A_TYPE_CD      --经办人2证件A类型代码
         ,OPERR_2_CERT_A_NO            --经办人2证件A号码
         ,OPERR_2_CERT_B_TYPE_CD        --经办人2证件B类型代码
         ,OPERR_2_CERT_B_NO            --经办人2证件B号码
         ,PROOF_CATE_CD                --证明人证件类型代码
         ,SRC_MODULE_TYPE_CD            --源模块类型代码
         ,SIGN_CHN_ID                --签约渠道编号
         ,SIGN_TELLER_ID              --签约柜员编号
         ,CHECK_TELLER_ID              --复核柜员编号
         ,AUTH_TELLER_ID              --授权柜员编号
         ,FINAL_MODIF_DT              --最后修改日期
         ,FINAL_MODIF_TELLER_ID            --最后修改柜员编号
         ,START_DT                    --开始时间
         ,END_DT                    --结束时间
         ,ID_MARK                    --增删标志
         ,SRC_TABLE_NAME                --源表名称
         ,JOB_CD                    --任务编码
         ,ETL_TIMESTAMP                  --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
           AGT_ID                    --协议编号
         ,LP_ID                        --法人编号
         ,ACCT_ID                    --账户编号
         ,TRAN_LMT_TYPE_CD                --交易限制类型代码
         ,LMT_ID                    --限制编号
         ,ACCT_LMT_STATUS_CD              --账户限制状态代码
         ,LMT_ACCT_RANGE_CD                --限制账户范围代码
         ,ACCT_LMT_AMT                  --账户限制金额
         ,SUB_LMT_CATE_CD                --子限制类别代码
         ,ACTL_CTRL_AMT                  --实际控制金额
         ,ACTL_EFFECT_DT                --实际生效日期
         ,EFFECT_DT                    --生效日期
         ,INVALID_DT                  --失效日期
         ,OVA_FLOW_NUM                  --全局流水号
         ,CUST_ID                    --客户编号
         ,CUST_NAME                    --客户名称
         ,DEP_TENOR                    --存款期限
         ,TENOR_TYPE_CD                --期限类型代码
         ,ACCT_ALDY_CHECK_FLG            --账户已复核标志
         ,ACCT_CHECK_DT                --账户复核日期
         ,TRAN_REF_NO                --交易参考号
         ,TRAN_CD                    --交易码
         ,TRAN_CHN_CD                --交易渠道代码
         ,TRAN_MEMO_DESCB            --交易摘要描述
         ,TRAN_DT                    --交易日期
         ,TRAN_TM                    --交易时间
         ,TRAN_AMT                    --交易金额
         ,TRAN_TELLER_ID                --交易柜员编号
         ,TRAN_ORG_ID                  --交易机构编号
         ,CNTPTY_ACCT_PROD_ID          --交易对手账户产品编号
         ,CNTPTY_ACCT_ID            --交易对手账户编号
         ,CNTPTY_ACCT_NAME            --交易对手账户名称
         ,CNTPTY_CUST_ACCT_NUM          --交易对手客户账号
         ,CNTPTY_CURR_CD            --交易对手币种代码
         ,CNTPTY_OPEN_ACCT_ORG_ID        --交易对手开户机构编号
         ,VOUCH_TYPE_CD                  --凭证类型代码
         ,BEGIN_CHECK_ID                --起始支票编号
         ,BEGIN_AMT                    --起始金额
         ,TERMNT_CHECK_ID                --终止支票编号
         ,STOP_AMT                    --截止金额
         ,ALDY_PAID_AMT                  --已还金额
         ,PAY_AMT                    --支付金额
         ,TOT_PAY_CNT                  --总支付笔数
         ,ALDY_PAY_CNT                  --已支付笔数
         ,INTERP_FLG                  --中断标志
         ,PM_FLG                    --抵质押标志
         ,MTG_ACCT_ID                  --抵押账户编号
         ,MTG_CUST_ACCT_NUM            --抵押客户账号
         ,MTG_ACCT_CURR_CD            --抵押账户币种代码
         ,MTG_ACCT_TYPE_CD            --抵押账户类型代码
         ,MATN_WAY_CD                --维护方式代码
         ,STL_FLOW_ID                --结算流水编号
         ,CHECK_ENTRY_CODE            --对账编码
         ,REVS_FLG                    --冲正标志
         ,WAIT_TO_FROZ_SEQ_NUM          --轮候冻结序号
         ,FULL_AMT_FROZ_FLG            --全额冻结标志
         ,CT_FROZ_FLG                --续冻标志
         ,FROZ_ORG_NAME                --冻结机关名称
         ,FROZ_ORG_LAW_DOC_NUM            --冻结机关法律文书号码
         ,FROZ_LEV                    --冻结级别
         ,UNFRZ_ORG_NAME            --解冻机关名称
         ,UNFRZ_ORG_LAW_DOC_NUM          --解冻机关法律文书号码
         ,UNLOSS_TM                    --解挂时间
         ,UNLOSS_TELLER_ID            --解挂柜员编号
         ,CAN_DEDUCT_AMT            --可扣划金额
         ,DEDUCT_LAW_DOC_NUM          --扣划法律文书号码
         ,AUTH_ORG_NAME                --有权机关名称
         ,EXEC_ORG_CD                --执行机关代码
         ,ASIT_EXEC_ITEM              --协助执行事项
         ,ENFORC_PS_1_NAME              --执法人1名称
         ,ENFORC_PS_1_CERT_A_TYPE_CD      --执法人1证件A类型代码
         ,ENFORC_PS_1_CERT_A_NO          --执法人1证件A号码
         ,ENFORC_PS_1_CERT_B_TYPE_CD    --执法人1证件B类型代码
         ,ENFORC_PS_1_CERT_B_NO        --执法人1证件B号码
         ,ENFORC_PS_2_NAME            --执法人2名称
         ,ENFORC_PS_2_CERT_A_TYPE_CD    --执法人2证件A类型代码
         ,ENFORC_PS_2_CERT_A_NO        --执法人2证件A号码
         ,ENFORC_PS_2_CERT_B_TYPE_CD    --执法人2证件B类型代码
         ,ENFORC_PS_2_CERT_B_NO        --执法人2证件B号码
         ,OPERR_1_NAME                --经办人1名称
         ,OPERR_1_CERT_A_TYPE_CD      --经办人1证件A类型代码
         ,OPERR_1_CERT_A_NO            --经办人1证件A号码
         ,OPERR_1_CERT_B_TYPE_CD        --经办人1证件B类型代码
         ,OPERR_1_CERT_B_NO            --经办人1证件B号码
         ,OPERR_2_NAME                --经办人2名称
         ,OPERR_2_CERT_A_TYPE_CD      --经办人2证件A类型代码
         ,OPERR_2_CERT_A_NO            --经办人2证件A号码
         ,OPERR_2_CERT_B_TYPE_CD        --经办人2证件B类型代码
         ,OPERR_2_CERT_B_NO            --经办人2证件B号码
         ,PROOF_CATE_CD                --证明人证件类型代码
         ,SRC_MODULE_TYPE_CD            --源模块类型代码
         ,SIGN_CHN_ID                --签约渠道编号
         ,SIGN_TELLER_ID              --签约柜员编号
         ,CHECK_TELLER_ID              --复核柜员编号
         ,AUTH_TELLER_ID              --授权柜员编号
         ,FINAL_MODIF_DT              --最后修改日期
         ,FINAL_MODIF_TELLER_ID            --最后修改柜员编号
         ,START_DT                    --开始时间
         ,END_DT                    --结束时间
         ,ID_MARK                    --增删标志
         ,SRC_TABLE_NAME                --源表名称
         ,JOB_CD                    --任务编码
         ,ETL_TIMESTAMP                  --ETL处理时间戳
    FROM IML.V_AGT_DEP_ACCT_LMT_INFO_H   --存款账户限制信息历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IML_AGT_DEP_ACCT_LMT_INFO_H;
/

