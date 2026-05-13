CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_AC_HIST(I_P_DATE IN INTEGER,
	                              O_ERRCODE OUT VARCHAR2
	                               )
	  /**************************************************************************
	  *  程序名称：ETL_O_IOL_NCBS_RB_AC_HIST
	  *  功能描述：账户状态变化核算流水表
	  *  创建日期：20230302
	  *  开发人员：MW
	  *  来源表： IOL.V_NCBS_RB_AC_HIST
	  *  目标表： O_IOL_NCBS_RB_AC_HIST
	  *  配置表：
	  *  修改情况：序号  修改日期  修改人   修改原因
	  *             1    20220619  MW      首次创建
	  ***************************************************************************/
	  AS
	  -- 定义变量 --
	  V_STEP      INTEGER := 0; -- 处理步骤
	  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_AC_HIST'; -- 程序名称
	  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
	  V_STARTTIME DATE; -- 处理开始时间
	  V_ENDTIME DATE;   -- 处理结束时间
	  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
	  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
	  V_SYSTEM    VARCHAR2(30); -- 来源系统
	  V_STEP_DESC VARCHAR2(200); --任务名称
	  BEGIN

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
	  DELETE FROM O_IOL_NCBS_RB_AC_HIST T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
	  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_NCBS_RB_AC_HIST';
	  V_SQLCOUNT := SQL%ROWCOUNT;
	  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
	  O_ERRCODE := '0';
	  V_ENDTIME := SYSDATE;
	  COMMIT;
	  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


	  -- 程序业务逻辑处理主体部分 --
	  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
	  V_STEP_DESC := '数据落地-账户状态变化核算流水表';
	  V_STARTTIME := SYSDATE;
	  INSERT INTO RRP_MDL.O_IOL_NCBS_RB_AC_HIST
	  (
						ACCT_SEQ_NO  --账户子账号
						,ACCT_STATUS  --账户状态
						,AMT_TYPE  --金额类型
						,BASE_ACCT_NO  --交易账号/卡号
						,BUSINESS_UNIT  --账套
						,CCY  --币种
						,CLIENT_NO  --客户编号
						,CLIENT_TYPE  --客户类型
						,GL_CODE  --科目代码
						,INTERNAL_KEY  --账户内部键值
						,PROD_TYPE  --产品编号
						,PROFIT_CENTER  --利润中心
						,REFERENCE  --交易参考号
						,TRAN_TYPE  --交易类型
						,USER_ID  --交易柜员编号
						,ACCT_DESC  --账户描述
						,BANK_SEQ_NO  --银行交易序号
						,COMPANY  --法人
						,EVENT_TYPE  --事件类型
						,GL_POSTED_FLAG  --过账标记
						,LENDER  --贷款人
						,NARRATIVE  --摘要
						,REVERSAL_FLAG  --交易是否已冲正
						,SEQ_NO  --序号
						,SOURCE_MODULE  --源模块
						,SOURCE_TYPE  --渠道编号
						,ACCOUNTING_STATUS  --核算状态
						,REVERSAL_DATE  --冲正日期
						,TRAN_DATE  --交易日期
						,TRAN_TIMESTAMP  --交易时间戳
						,ACCT_BRANCH  --开户机构编号
						,ACCT_CCY  --账户币种
						,TRAN_AMT  --交易金额
						,TRAN_BRANCH  --核心交易机构编号
						,REACCOUNT_CD  --对账代码
						,BUS_SEQ_NO  --业务流水号
						,CHARGE_PAY_FLAG  --收入支出标识
						,CHANNEL_SEQ_NO  --全局流水号|渠道流水号
						,OLD_BRANCH  --变更前机构
						,ETL_DT  --ETL处理日期
						,ETL_TIMESTAMP  --ETL处理时间戳
	    )
	    SELECT
						ACCT_SEQ_NO  --账户子账号
						,ACCT_STATUS  --账户状态
						,AMT_TYPE  --金额类型
						,BASE_ACCT_NO  --交易账号/卡号
						,BUSINESS_UNIT  --账套
						,CCY  --币种
						,CLIENT_NO  --客户编号
						,CLIENT_TYPE  --客户类型
						,GL_CODE  --科目代码
						,INTERNAL_KEY  --账户内部键值
						,PROD_TYPE  --产品编号
						,PROFIT_CENTER  --利润中心
						,REFERENCE  --交易参考号
						,TRAN_TYPE  --交易类型
						,USER_ID  --交易柜员编号
            ,ACCT_DESC  --账户描述
            ,BANK_SEQ_NO  --银行交易序号
            ,COMPANY  --法人
            ,EVENT_TYPE  --事件类型
            ,GL_POSTED_FLAG  --过账标记
            ,LENDER  --贷款人
            ,NARRATIVE  --摘要
            ,REVERSAL_FLAG  --交易是否已冲正
            ,SEQ_NO  --序号
            ,SOURCE_MODULE  --源模块
            ,SOURCE_TYPE  --渠道编号
            ,ACCOUNTING_STATUS  --核算状态
            ,REVERSAL_DATE  --冲正日期
            ,TRAN_DATE  --交易日期
            ,TRAN_TIMESTAMP  --交易时间戳
            ,ACCT_BRANCH  --开户机构编号
            ,ACCT_CCY  --账户币种
            ,TRAN_AMT  --交易金额
            ,TRAN_BRANCH  --核心交易机构编号
            ,REACCOUNT_CD  --对账代码
            ,BUS_SEQ_NO  --业务流水号
            ,CHARGE_PAY_FLAG  --收入支出标识
            ,CHANNEL_SEQ_NO  --全局流水号|渠道流水号
            ,OLD_BRANCH  --变更前机构
            ,ETL_DT  --ETL处理日期
            ,ETL_TIMESTAMP  --ETL处理时间戳
      FROM IOL.V_NCBS_RB_AC_HIST  --视图-账户状态变化核算流水表
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
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
    V_STEP := V_STEP + 1;
       V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    END ETL_O_IOL_NCBS_RB_AC_HIST;
/

