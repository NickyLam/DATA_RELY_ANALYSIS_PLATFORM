CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_ELEC_BILL_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_ELEC_BILL_TRAN_FLOW
  *  功能描述：银联网联交易关系子表
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_ELEC_BILL_TRAN_FLOW
  *  目标表： O_IML_EVT_ELEC_BILL_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221201  XUXIAOBIN     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_ELEC_BILL_TRAN_FLOW'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_ELEC_BILL_TRAN_FLOW ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_ELEC_BILL_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-银联网联交易关系子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_ELEC_BILL_TRAN_FLOW
  (
			EVT_ID,                      --   事件编号,
BILL_ID,                     --   票据编号,
LP_ID,                       --   法人编号,
INFO_TYPE_CD,                --   信息类型代码,
BILL_NUM,                    --   票据号码,
REQER_CATE_CD,               --  请求方类别代码,
REQER_NAME,                  --   请求方名称,
REQER_ORGNZ_CD,              --   请求方组织机构代码,
REQER_ACCT_NUM,              --   请求方账号,
REQER_OPEN_BANK_NO,          --   请求方开户行行号,
RECVER_NAME,                 --   接收方名称,
RECVER_ORGNZ_CD,             --   接收方组织机构代码,
RECVER_ACCT_NUM,             --   接收方账号,
RECVER_OPEN_BANK_NO,         --   接收方开户行行号,
RECV_DT,                     --   签收日期,
ONL_CLEAR_CD,                --   线上清算代码,
NOT_NGBL_CD,                 --   不得转让代码,
INT_RAT,                     --   利率,
REDEM_INT_RAT,               --   赎回利率,
TRAN_AMT,                    --   交易金额,
REDEM_ACTL_AMT,              --   赎回实付金额,
DISCNT_KIND_CD,              --   贴现种类代码,
APPL_DT,                     --   申请日期,
SUGST_PAY_AMT,               --   提示付款金额,
REFUSE_PAY_CD,               --   拒付代码,
RECS_TYPE_CD,                --   追索类型代码,
PAYOFF_DT,                   --   清偿日期,
LH_BUY_TRAN_ID,              --   上手买入交易编号,
TRAN_STATUS_DESCB,           --   交易状态描述,
BILL_STATUS_CD,              --   票据状态代码,
TRAN_ID,                     --   交易编号,
H_DATA_FLG,                  --   历史数据标志,
ETL_DT,                      --   ETL处理日期,
SRC_TABLE_NAME,              --   源表名称,
JOB_CD,                      --   任务编码,
ETL_TIMESTAMP                --   ETL处理时间戳

    )
    SELECT
				EVT_ID,                      --   事件编号,
BILL_ID,                     --   票据编号,
LP_ID,                       --   法人编号,
INFO_TYPE_CD,                --   信息类型代码,
BILL_NUM,                    --   票据号码,
REQER_CATE_CD,               --  请求方类别代码,
REQER_NAME,                  --   请求方名称,
REQER_ORGNZ_CD,              --   请求方组织机构代码,
REQER_ACCT_NUM,              --   请求方账号,
REQER_OPEN_BANK_NO,          --   请求方开户行行号,
RECVER_NAME,                 --   接收方名称,
RECVER_ORGNZ_CD,             --   接收方组织机构代码,
RECVER_ACCT_NUM,             --   接收方账号,
RECVER_OPEN_BANK_NO,         --   接收方开户行行号,
RECV_DT,                     --   签收日期,
ONL_CLEAR_CD,                --   线上清算代码,
NOT_NGBL_CD,                 --   不得转让代码,
INT_RAT,                     --   利率,
REDEM_INT_RAT,               --   赎回利率,
TRAN_AMT,                    --   交易金额,
REDEM_ACTL_AMT,              --   赎回实付金额,
DISCNT_KIND_CD,              --   贴现种类代码,
APPL_DT,                     --   申请日期,
SUGST_PAY_AMT,               --   提示付款金额,
REFUSE_PAY_CD,               --   拒付代码,
RECS_TYPE_CD,                --   追索类型代码,
PAYOFF_DT,                   --   清偿日期,
LH_BUY_TRAN_ID,              --   上手买入交易编号,
TRAN_STATUS_DESCB,           --   交易状态描述,
BILL_STATUS_CD,              --   票据状态代码,
TRAN_ID,                     --   交易编号,
H_DATA_FLG,                  --   历史数据标志,
ETL_DT,                      --   ETL处理日期,
SRC_TABLE_NAME,              --   源表名称,
JOB_CD,                      --   任务编码,
ETL_TIMESTAMP                --   ETL处理时间戳
    FROM IML.V_EVT_ELEC_BILL_TRAN_FLOW  --视图-银联网联交易关系子表

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

  END ETL_INIT_O_IML_EVT_ELEC_BILL_TRAN_FLOW;
/

