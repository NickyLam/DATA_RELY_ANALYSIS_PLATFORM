CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_DEP_RECVBL_FEE_DTL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_DEP_RECVBL_FEE_DTL
  *  功能描述：存款应收费用明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_DEP_RECVBL_FEE_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_DEP_RECVBL_FEE_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_DEP_RECVBL_FEE_DTL ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_DEP_RECVBL_FEE_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款应收费用明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_DEP_RECVBL_FEE_DTL
  (      ETL_DT  --数据日期
      ,EVT_ID  --事件编号
      ,RECVBL_FEE_SEQ_NUM  --应收费用序号
      ,LP_ID  --法人编号
      ,BUS_TRAN_DT  --业务交易日期
      ,SEQ_NUM  --序号
      ,CUST_ID  --客户编号
      ,CUST_TYPE_CD  --客户类型代码
      ,CUST_ACCT_NUM  --客户账号
      ,ACCT_NAME  --账户名称
      ,OPEN_ACCT_ORG_ID  --开户机构编号
      ,CHARGE_ACCT_ID  --收费账户编号
      ,CHARGE_ACCT_PROD_ID  --收费账户产品编号
      ,CHARGE_CUST_ACCT_NUM  --收费客户账号
      ,CHARGE_ACCT_CURR_CD  --收费账户币种代码
      ,ACCT_ID  --账户编号
      ,EFFECT_DT  --生效日期
      ,LAST_CHARGE_DT  --上一收费日期
      ,TRAN_REVS_DT  --交易冲正日期
      ,REVS_ORG_ID  --冲正机构编号
      ,CORE_TRAN_ORG_ID  --核心交易机构编号
      ,DEP_VOUCH_CATE_CD  --存款凭证类别代码
      ,VOUCH_ID  --凭证编号
      ,VOUCH_SUM_QTTY  --凭证合计数量
      ,DEP_AGT_ID  --存款协议编号
      ,CNTPTY_BUS_ID  --对手业务编号
      ,TRAN_REF_NO  --交易参考号
      ,DISCNT_FEE_AMT  --折扣费用金额
      ,FEE_TYPE_ID  --费用类型编号
      ,FEE_AMT  --费用金额
      ,INIT_FEE_AMT  --原始费用金额
      ,NEXT_CHARGE_DT  --下一收费日期
      ,TAX  --税金
      ,INIT_RECVBL_FEE_AMT  --原应收费用金额
      ,FEE_PRICE  --费用单价
      ,CHARGE_FREQ_CD  --收费频率代码
      ,TAX_RAT  --税率
      ,TAX_CATEGORY_CD  --税种代码
      ,NEED_PRFT_CUT_FLG  --需要分润标志
      ,TRAN_BANK_PRFT_CUT_AMT  --交易行分润金额
      ,FEE_CHARGE_WAY_CD  --费用收费方式代码
      ,GRACE_FLG  --宽限标志
      ,TRAN_REVD_FLG  --交易已冲正标志
      ,FEE_DISCNT_TYPE_CD  --费用折扣类型代码
      ,TRAN_BANK_RATIO  --交易行比例
      ,CHARGE_CURR_CD  --收费币种代码
      ,CHARGE_SUB_ACCT_NUM  --收费子账号
      ,CHARGE_DAY  --收费日
      ,TERMNT_NUM  --终止号码
      ,ACCT_BANK_RATIO  --账户行比例
      ,ACCT_BANK_PRFT_CUT_AMT  --账户行分润金额
      ,OWE_FEE_STATUS_CD  --欠费状态代码
      ,PRIOR_LEVEL  --优先等级
      ,FEE_DISCNT_RAT  --费用折扣率
      ,REVS_AUTH_TELLER_ID  --冲正授权柜员编号
      ,REVS_TELLER_ID  --冲正柜员编号
      ,TRAN_TM  --交易时间
      ,TRAN_TELLER_ID  --交易柜员编号
      ,FINAL_MODIF_DT  --最后修改日期
      ,FINAL_MODIF_TELLER_ID  --最后修改柜员编号
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,EVT_ID  --事件编号
      ,RECVBL_FEE_SEQ_NUM  --应收费用序号
      ,LP_ID  --法人编号
      ,BUS_TRAN_DT  --业务交易日期
      ,SEQ_NUM  --序号
      ,CUST_ID  --客户编号
      ,null--CUST_TYPE_CD  --客户类型代码
      ,CUST_ACCT_NUM  --客户账号
      ,ACCT_NAME  --账户名称
      ,OPEN_ACCT_ORG_ID  --开户机构编号
      ,CHARGE_ACCT_ID  --收费账户编号
      ,CHARGE_ACCT_PROD_ID  --收费账户产品编号
      ,CHARGE_CUST_ACCT_NUM  --收费客户账号
      ,CHARGE_ACCT_CURR_CD  --收费账户币种代码
      ,ACCT_ID  --账户编号
      ,EFFECT_DT  --生效日期
      ,LAST_CHARGE_DT  --上一收费日期
      ,TRAN_REVS_DT  --交易冲正日期
      ,REVS_ORG_ID  --冲正机构编号
      ,CORE_TRAN_ORG_ID  --核心交易机构编号
      ,DEP_VOUCH_CATE_CD  --存款凭证类别代码
      ,VOUCH_ID  --凭证编号
      ,VOUCH_SUM_QTTY  --凭证合计数量
      ,DEP_AGT_ID  --存款协议编号
      ,CNTPTY_BUS_ID  --对手业务编号
      ,TRAN_REF_NO  --交易参考号
      ,DISCNT_FEE_AMT  --折扣费用金额
      ,FEE_TYPE_ID  --费用类型编号
      ,FEE_AMT  --费用金额
      ,INIT_FEE_AMT  --原始费用金额
      ,NEXT_CHARGE_DT  --下一收费日期
      ,TAX  --税金
      ,INIT_RECVBL_FEE_AMT  --原应收费用金额
      ,FEE_PRICE  --费用单价
      ,CHARGE_FREQ_CD  --收费频率代码
      ,TAX_RAT  --税率
      ,TAX_CATEGORY_CD  --税种代码
      ,NEED_PRFT_CUT_FLG  --需要分润标志
      ,TRAN_BANK_PRFT_CUT_AMT  --交易行分润金额
      ,FEE_CHARGE_WAY_CD  --费用收费方式代码
      ,GRACE_FLG  --宽限标志
      ,TRAN_REVD_FLG  --交易已冲正标志
      ,FEE_DISCNT_TYPE_CD  --费用折扣类型代码
      ,TRAN_BANK_RATIO  --交易行比例
      ,CHARGE_CURR_CD  --收费币种代码
      ,CHARGE_SUB_ACCT_NUM  --收费子账号
      ,CHARGE_DAY  --收费日
      ,TERMNT_NUM  --终止号码
      ,ACCT_BANK_RATIO  --账户行比例
      ,ACCT_BANK_PRFT_CUT_AMT  --账户行分润金额
      ,OWE_FEE_STATUS_CD  --欠费状态代码
      ,PRIOR_LEVEL  --优先等级
      ,FEE_DISCNT_RAT  --费用折扣率
      ,REVS_AUTH_TELLER_ID  --冲正授权柜员编号
      ,REVS_TELLER_ID  --冲正柜员编号
      ,TRAN_TM  --交易时间
      ,TRAN_TELLER_ID  --交易柜员编号
      ,FINAL_MODIF_DT  --最后修改日期
      ,FINAL_MODIF_TELLER_ID  --最后修改柜员编号
    ,JOB_CD --任务代码
    FROM IML.V_EVT_DEP_RECVBL_FEE_DTL  --视图-存款应收费用明细
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IML_EVT_DEP_RECVBL_FEE_DTL;
/

