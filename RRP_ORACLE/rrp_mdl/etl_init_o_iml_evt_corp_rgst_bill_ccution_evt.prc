CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT
  *  功能描述：企业登记中心票据流转事件
  *  创建日期：20230215
  *  开发人员：MW
  *  来源表：
  *  目标表： O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230215  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT'; -- 程序名称
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
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-企业登记中心票据流转事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT
  (
					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,RGST_ID  --登记编号
					,BILL_ID  --票据编号
					,RECV_ID  --签收编号
					,PROD_ID  --产品编号
					,PROD_NAME  --产品名称
					,BILL_MED_CD  --票据介质代码
					,BILL_TYPE_CD  --票据类型代码
					,BUS_TYPE_CD  --业务类型代码
					,BUS_ATTR_CD  --业务属性代码
					,BUS_DIR_CD  --业务方向代码
					,BILL_SRC_CD  --票据来源代码
					,BILL_NUM  --票据号码
					,BILL_SUB_INTRV_ID  --票据子区间编号
					,BILL_AMT  --票据金额
					,TRAN_DT  --交易日期
					,REQER_TYPE_CD  --请求方类型代码
					,REQER_NAME  --请求方名称
					,REQER_SOCI_CRDT_CD  --请求方社会信用代码
					,REQER_ACCT_TYPE_CD  --请求方账户类型代码
					,REQER_ACCT_ID  --请求方账户编号
					,REQER_ACCT_NAME  --请求方账户名称
					,REQER_OPEN_BANK_NO  --请求方开户行行号
					,REQER_MEM_CD  --请求方会员代码
					,REQER_ORG_CD  --请求方机构代码
					,RECVER_TYPE_CD  --接收方类型代码
					,RECVER_NAME  --接收方名称
					,RECVER_SOCI_CRDT_CD  --接收方社会信用代码
					,RECVER_ACCT_TYPE_CD  --接收方账户类型代码
					,RECVER_ACCT_ID  --接收方账户编号
					,RECVER_ACCT_NAME  --接收方账户名称
					,RECVER_OPEN_BANK_NO  --接收方开户行行号
					,RECVER_MEM_CD  --接收方会员代码
					,RECVER_ORG_CD  --接收方机构代码
					,DISCNT_INT_RAT  --贴现利率
					,DISCNT_ACTL_AMT  --贴现实付金额
					,NOT_NGBL_CD  --不得转让代码
					,ONL_CLEAR_FLG  --线上清算标志
					,ENTER_ID  --入账账户编号
					,ENTER_ACCT_BANK_NO  --入账行号
					,REPLY_IDF_CD  --应答标识代码
					,RECV_DT  --签收日期
					,REFUSE_PAY_CD  --拒付代码
					,REFUSE_PAY_REMARK_INFO  --拒付备注信息
					,RECS_TYPE_CD  --追偿类型代码
					,ACTL_INT  --实付利息
					,INT_ACCR_EXP_DT  --计息到期日期
					,INT_PAYER_NAME  --付息人名称
					,INT_PAYER_ACCT_ID  --付息人账户编号
					,INT_PAYER_OPEN_BANK_NAME  --付息人开户行名称
					,COMM_FEE  --手续费
					,TODOS  --工本费
					,PAY_INT_RATIO  --付息比例
					,BUYER_PAY_INT_INT  --买方付息利息
					,TOT_INT  --总利息
					,STOP_PAY_TYPE_CD  --止付类型代码
					,STOP_PAY_RS_DESCB  --止付原因描述
					,REMIT_STOP_PAY_TYPE_CD  --解除止付类型代码
					,REMIT_STOP_PAY_RS_DESCB  --解除止付原因描述
					,SURP_TENOR  --剩余期限
					,STL_AMT  --结算金额
					,STL_REST_CD  --结算结果代码
					,STL_DT  --结算日期
					,PAYOFF_TYPE_CD  --结清类型代码
					,TRAN_STATUS_CD  --交易状态代码
					,START_DT  --开始时间
					,END_DT  --结束时间
					,ID_MARK  --增删标志
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT

					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,RGST_ID  --登记编号
					,BILL_ID  --票据编号
					,RECV_ID  --签收编号
					,PROD_ID  --产品编号
					,PROD_NAME  --产品名称
					,BILL_MED_CD  --票据介质代码
					,BILL_TYPE_CD  --票据类型代码
					,BUS_TYPE_CD  --业务类型代码
					,BUS_ATTR_CD  --业务属性代码
					,BUS_DIR_CD  --业务方向代码
					,BILL_SRC_CD  --票据来源代码
					,BILL_NUM  --票据号码
					,BILL_SUB_INTRV_ID  --票据子区间编号
					,BILL_AMT  --票据金额
					,TRAN_DT  --交易日期
					,REQER_TYPE_CD  --请求方类型代码
					,REQER_NAME  --请求方名称
					,REQER_SOCI_CRDT_CD  --请求方社会信用代码
					,REQER_ACCT_TYPE_CD  --请求方账户类型代码
					,REQER_ACCT_ID  --请求方账户编号
					,REQER_ACCT_NAME  --请求方账户名称
					,REQER_OPEN_BANK_NO  --请求方开户行行号
					,REQER_MEM_CD  --请求方会员代码
					,REQER_ORG_CD  --请求方机构代码
					,RECVER_TYPE_CD  --接收方类型代码
					,RECVER_NAME  --接收方名称
					,RECVER_SOCI_CRDT_CD  --接收方社会信用代码
					,RECVER_ACCT_TYPE_CD  --接收方账户类型代码
					,RECVER_ACCT_ID  --接收方账户编号
					,RECVER_ACCT_NAME  --接收方账户名称
					,RECVER_OPEN_BANK_NO  --接收方开户行行号
					,RECVER_MEM_CD  --接收方会员代码
					,RECVER_ORG_CD  --接收方机构代码
					,DISCNT_INT_RAT  --贴现利率
					,DISCNT_ACTL_AMT  --贴现实付金额
					,NOT_NGBL_CD  --不得转让代码
					,ONL_CLEAR_FLG  --线上清算标志
					,ENTER_ID  --入账账户编号
					,ENTER_ACCT_BANK_NO  --入账行号
					,REPLY_IDF_CD  --应答标识代码
					,RECV_DT  --签收日期
					,REFUSE_PAY_CD  --拒付代码
					,REFUSE_PAY_REMARK_INFO  --拒付备注信息
					,RECS_TYPE_CD  --追偿类型代码
					,ACTL_INT  --实付利息
					,INT_ACCR_EXP_DT  --计息到期日期
					,INT_PAYER_NAME  --付息人名称
					,INT_PAYER_ACCT_ID  --付息人账户编号
					,INT_PAYER_OPEN_BANK_NAME  --付息人开户行名称
					,COMM_FEE  --手续费
					,TODOS  --工本费
					,PAY_INT_RATIO  --付息比例
					,BUYER_PAY_INT_INT  --买方付息利息
					,TOT_INT  --总利息
					,STOP_PAY_TYPE_CD  --止付类型代码
					,STOP_PAY_RS_DESCB  --止付原因描述
					,REMIT_STOP_PAY_TYPE_CD  --解除止付类型代码
					,REMIT_STOP_PAY_RS_DESCB  --解除止付原因描述
					,SURP_TENOR  --剩余期限
					,STL_AMT  --结算金额
					,STL_REST_CD  --结算结果代码
					,STL_DT  --结算日期
					,PAYOFF_TYPE_CD  --结清类型代码
					,TRAN_STATUS_CD  --交易状态代码
					,START_DT  --开始时间
					,END_DT  --结束时间
					,ID_MARK  --增删标志
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_CORP_RGST_BILL_CCUTION_EVT  --视图-企业登记中心票据流转事件
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_INIT_O_IML_EVT_CORP_RGST_BILL_CCUTION_EVT;
/

