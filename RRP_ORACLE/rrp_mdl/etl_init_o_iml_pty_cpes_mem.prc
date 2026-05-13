CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_PTY_CPES_MEM(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_PTY_CPES_MEM
  *  功能描述：票交所会员
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_PTY_CPES_MEM
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_IML_PTY_CPES_MEM'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_PTY_CPES_MEM ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_PTY_CPES_MEM';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-票交所会员';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PTY_CPES_MEM
  (      ETL_DT  --数据日期
      ,PARTY_ID  --当事人编号
      ,LP_ID  --法人编号
      ,MEM_ID  --会员编号
      ,MEM_CD  --会员代码
      ,MEM_ORG_CD  --会员机构代码
      ,MEM_ORG_ID  --会员机构编号
      ,ORG_CATE_CD  --机构类别代码
      ,ORG_LEV_CD  --机构级别代码
      ,ORG_CN_FNAME  --机构中文全称
      ,ORG_EN_FNAME  --机构英文全称
      ,ORG_CN_ABBR  --机构中文简称
      ,ORG_EN_ABBR  --机构英文简称
      ,UNIFY_SOCI_CRDT_CD  --统一社会信用代码
      ,DIST_CD  --行政区划代码
      ,LP_LEV_CD  --法人级别代码
      ,ORG_HIBCHY_CD  --机构层级代码
      ,PROD_VALID_DT  --产品有效日期
      ,PROD_INVALID_DT  --产品失效日期
      ,ORG_STATUS_CD  --机构状态代码
      ,ORG_INTNAL_ACCT_NAME  --机构内部账户名称
      ,ORG_INTNAL_ACCT_NUM  --机构内部账户账号
      ,TRAN_ACCT_NUM  --交易账号
      ,TRAN_ACCT_STATUS_CD  --交易账户状态代码
      ,TRUST_ACCT_NUM  --托管账号
      ,TRUST_ACCT_STATUS_CD  --托管账户状态代码
      ,CPES_CAP_ACCT_NUM  --票交所资金账户账号
      ,CPES_CAP_ACCT_STATUS_CD  --票交所资金账户状态代码
      ,LEGAL_REP_OR_PRINC  --法定代表人或负责人
      ,WDRAW_ACCT_LG_PAY_SYS_BANK_NO  --出金账户开户行大额支付系统行号
      ,WDRAW_ACCT_NAME  --出金账户名称
      ,WDRAW_ACCT_NUM  --出金账户账号
      ,RGST_CAP  --注册资本
      ,ADDR  --地址
      ,COTAS  --联系人
      ,PHONE  --联系电话
      ,FAX  --传真
      ,ZIP_CD  --邮编
      ,SYS_PRTCPTR_BIGAMT_BANK_NO  --系统参与者大额行号
      ,SYS_PRTCPTR_BIGAMT_BANK_NAME  --系统参与者大额行名
      ,ELE_BILL_AGENT_BIGAMT_BANK_NO  --电票代理行大额行号
      ,ELE_BILL_AGENT_BIGAMT_ACCT_NUM  --电票代理行大额账号
      ,UDTAKE_ORG_CD  --承接机构代码
      ,CREATE_DT  --创建日期
      ,UPDATE_DT  --更新日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,PARTY_ID  --当事人编号
      ,LP_ID  --法人编号
      ,MEM_ID  --会员编号
      ,MEM_CD  --会员代码
      ,MEM_ORG_CD  --会员机构代码
      ,MEM_ORG_ID  --会员机构编号
      ,ORG_CATE_CD  --机构类别代码
      ,ORG_LEV_CD  --机构级别代码
      ,ORG_CN_FNAME  --机构中文全称
      ,ORG_EN_FNAME  --机构英文全称
      ,ORG_CN_ABBR  --机构中文简称
      ,ORG_EN_ABBR  --机构英文简称
      ,UNIFY_SOCI_CRDT_CD  --统一社会信用代码
      ,DIST_CD  --行政区划代码
      ,LP_LEV_CD  --法人级别代码
      ,ORG_HIBCHY_CD  --机构层级代码
      ,PROD_VALID_DT  --产品有效日期
      ,PROD_INVALID_DT  --产品失效日期
      ,ORG_STATUS_CD  --机构状态代码
      ,ORG_INTNAL_ACCT_NAME  --机构内部账户名称
      ,ORG_INTNAL_ACCT_NUM  --机构内部账户账号
      ,TRAN_ACCT_NUM  --交易账号
      ,TRAN_ACCT_STATUS_CD  --交易账户状态代码
      ,TRUST_ACCT_NUM  --托管账号
      ,TRUST_ACCT_STATUS_CD  --托管账户状态代码
      ,CPES_CAP_ACCT_NUM  --票交所资金账户账号
      ,CPES_CAP_ACCT_STATUS_CD  --票交所资金账户状态代码
      ,LEGAL_REP_OR_PRINC  --法定代表人或负责人
      ,WDRAW_ACCT_LG_PAY_SYS_BANK_NO  --出金账户开户行大额支付系统行号
      ,WDRAW_ACCT_NAME  --出金账户名称
      ,WDRAW_ACCT_NUM  --出金账户账号
      ,RGST_CAP  --注册资本
      ,ADDR  --地址
      ,COTAS  --联系人
      ,PHONE  --联系电话
      ,FAX  --传真
      ,ZIP_CD  --邮编
      ,SYS_PRTCPTR_BIGAMT_BANK_NO  --系统参与者大额行号
      ,SYS_PRTCPTR_BIGAMT_BANK_NAME  --系统参与者大额行名
      ,ELE_BILL_AGENT_BIGAMT_BANK_NO  --电票代理行大额行号
      ,ELE_BILL_AGENT_BIGAMT_ACCT_NUM  --电票代理行大额账号
      ,UDTAKE_ORG_CD  --承接机构代码
      ,CREATE_DT  --创建日期
      ,UPDATE_DT  --更新日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    FROM IML.V_PTY_CPES_MEM  --视图-票交所会员
   WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
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

  END ETL_INIT_O_IML_PTY_CPES_MEM;
/

