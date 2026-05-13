CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_AGT_CPES_BILL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_AGT_CPES_BILL_INFO
  *  功能描述：票交所票据信息
  *  创建日期：20230215
  *  开发人员：MW
  *  来源表：
  *  目标表： O_IML_AGT_CPES_BILL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230215  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_AGT_CPES_BILL_INFO'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_AGT_CPES_BILL_INFO ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_AGT_CPES_BILL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-票交所票据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_CPES_BILL_INFO
  (
						VOUCH_ID  --凭证编号
						,LP_ID  --法人编号
						,BILL_ID  --票据编号
						,BILL_NUM  --票据号码
						,BILL_MED_CD  --票据介质代码
						,BILL_TYPE_CD  --票据类型代码
						,DRAW_DT  --出票日期
						,EXP_DT  --到期日期
						,FAC_VAL_AMT  --票面金额
						,DRAWER_NAME  --出票人名称
						,DRAWER_ACCT_NUM  --出票人账号
						,DRAWER_SOCI_CRDT_CD  --出票人社会信用代码
						,DRAWER_OPEN_ACCT_ORG_CD  --出票人开户机构代码
						,DRAWER_OPEN_BANK_NO  --出票人开户行行号
						,DRAWER_OPEN_BANK_NAME  --出票人开户行名称
						,ACCPTOR_NAME  --承兑人名称
						,ACCPTOR_ACCT_NUM  --承兑人账号
						,ACCPTOR_SOCI_CRDT_CD  --承兑人社会信用代码
						,ACCPTOR_OPEN_ACCT_ORG_CD  --承兑人开户机构代码
						,ACCPTOR_OPEN_BANK_NO  --承兑人开户行行号
						,ACCPTOR_OPEN_BANK_NAME  --承兑人开户行名称
						,RECVER_NAME  --收款人名称
						,RECVER_ACCT_NUM  --收款人账号
						,RECVER_SOCI_CRDT_CD  --收款人社会信用代码
						,RECVER_OPEN_ACCT_ORG_CD  --收款人开户机构代码
						,RECVER_OPEN_BANK_NO  --收款人开户行行号
						,RECVER_OPEN_BANK_NAME  --收款人开户行名称
						,PAY_BANK_ORG_CD  --付款行机构代码
						,PAY_BANK_NO  --付款行行号
						,PAY_CFM_ORG_CD  --付款确认机构代码
						,DISCNT_BK_ORG_CD  --贴现行机构代码
						,DISCNT_GUAR_ORG_CD  --贴现保证机构代码
						,INVTRY_ORG_CD  --库存机构代码
						,BILL_CCUTION_STATUS_CD  --票据流转状态代码
						,RISK_BILL_STATUS_CD  --风险票据状态代码
						,BILL_INVTRY_STATUS_CD  --票据库存状态代码
						,BILL_STATUS_CD  --票据状态代码
						,INIT_CCUTION_STATUS_CD  --原流转状态代码
						,INIT_RISK_BILL_STATUS_CD  --原风险票据状态代码
						,INIT_BILL_STATUS_CD  --原票据状态代码
						,INIT_BILL_INVTRY_STATUS_CD  --原票据库存状态代码
						,DISCNT_DT  --贴现日期
						,BILL_SUB_INTRV_ID  --票据子区间编号
						,BILL_INTRV_STD_AMT  --票据区间标准金额
						,START_DT  --开始时间
						,END_DT  --结束时间
						,ID_MARK  --增删标志
						,SRC_TABLE_NAME  --源表名称
						,JOB_CD  --任务编码
						,ETL_TIMESTAMP  --ETL处理时间戳


    )
    SELECT

						VOUCH_ID  --凭证编号
						,LP_ID  --法人编号
						,BILL_ID  --票据编号
						,BILL_NUM  --票据号码
						,BILL_MED_CD  --票据介质代码
						,BILL_TYPE_CD  --票据类型代码
						,DRAW_DT  --出票日期
						,EXP_DT  --到期日期
						,FAC_VAL_AMT  --票面金额
						,DRAWER_NAME  --出票人名称
						,DRAWER_ACCT_NUM  --出票人账号
						,DRAWER_SOCI_CRDT_CD  --出票人社会信用代码
						,DRAWER_OPEN_ACCT_ORG_CD  --出票人开户机构代码
						,DRAWER_OPEN_BANK_NO  --出票人开户行行号
						,DRAWER_OPEN_BANK_NAME  --出票人开户行名称
						,ACCPTOR_NAME  --承兑人名称
						,ACCPTOR_ACCT_NUM  --承兑人账号
						,ACCPTOR_SOCI_CRDT_CD  --承兑人社会信用代码
						,ACCPTOR_OPEN_ACCT_ORG_CD  --承兑人开户机构代码
						,ACCPTOR_OPEN_BANK_NO  --承兑人开户行行号
						,ACCPTOR_OPEN_BANK_NAME  --承兑人开户行名称
						,RECVER_NAME  --收款人名称
						,RECVER_ACCT_NUM  --收款人账号
						,RECVER_SOCI_CRDT_CD  --收款人社会信用代码
						,RECVER_OPEN_ACCT_ORG_CD  --收款人开户机构代码
						,RECVER_OPEN_BANK_NO  --收款人开户行行号
						,RECVER_OPEN_BANK_NAME  --收款人开户行名称
						,PAY_BANK_ORG_CD  --付款行机构代码
						,PAY_BANK_NO  --付款行行号
						,PAY_CFM_ORG_CD  --付款确认机构代码
						,DISCNT_BK_ORG_CD  --贴现行机构代码
						,DISCNT_GUAR_ORG_CD  --贴现保证机构代码
						,INVTRY_ORG_CD  --库存机构代码
						,BILL_CCUTION_STATUS_CD  --票据流转状态代码
						,RISK_BILL_STATUS_CD  --风险票据状态代码
						,BILL_INVTRY_STATUS_CD  --票据库存状态代码
						,BILL_STATUS_CD  --票据状态代码
						,INIT_CCUTION_STATUS_CD  --原流转状态代码
						,INIT_RISK_BILL_STATUS_CD  --原风险票据状态代码
						,INIT_BILL_STATUS_CD  --原票据状态代码
						,INIT_BILL_INVTRY_STATUS_CD  --原票据库存状态代码
            ,DISCNT_DT  --贴现日期
            ,BILL_SUB_INTRV_ID  --票据子区间编号
            ,BILL_INTRV_STD_AMT  --票据区间标准金额
            ,START_DT  --开始时间
            ,END_DT  --结束时间
            ,ID_MARK  --增删标志
            ,SRC_TABLE_NAME  --源表名称
            ,JOB_CD  --任务编码
            ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_AGT_CPES_BILL_INFO  --视图-票交所票据信息
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

  END ETL_INIT_O_IML_AGT_CPES_BILL_INFO;
/

