CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_AGREEMENT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_AGREEMENT
  *  功能描述：合同/协议信息表
  *  创建日期：20230914
  *  开发人员：LYH
  *  来源表： IOL.NCBS_RB_AGREEMENT
  *  目标表： O_IOL_NCBS_RB_AGREEMENT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231018  LYH     首次创建
  *             2    20241227  YJY     优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_AGREEMENT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  
  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_NCBS_RB_AGREEMENT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_AGREEMENT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-合同/协议信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_NCBS_RB_AGREEMENT
  (ACCT_NAME                 --账户名称
  ,ACCT_SEQ_NO               --账户子账号
  ,BASE_ACCT_NO              --交易账号/卡号
  ,CLIENT_NO                 --客户编号
  ,CLIENT_SHORT              --客户简称
  ,PROD_TYPE                 --产品编号
  ,USER_ID                   --交易柜员编号
  ,AGREEMENT_CLASS           --协议分类
  ,AGREEMENT_CLOSE_ACCT_FLAG --签约后是否允许销户
  ,AGREEMENT_ID              --协议编号
  ,AGREEMENT_KEY             --协议键值
  ,AGREEMENT_KEY_TYPE        --协议键类型
  ,AGREEMENT_STATUS          --协议状态
  ,AGREEMENT_TYPE            --协议类型
  ,COMPANY                   --法人
  ,OUT_SIGN_CHANNEL          --解约渠道
  ,SIGN_CHANNEL              --签约渠道
  ,AGREEMENT_OPEN_DATE       --协议签订日期
  ,END_DATE                  --结束日期
  ,LAST_CHANGE_DATE          --最后修改日期
  ,OUT_SIGN_DATE             --解约日期
  ,SIGN_DATE                 --签约日期
  ,START_DATE                --开始日期
  ,TRAN_TIMESTAMP            --交易时间戳
  ,ACCT_CCY                  --账户币种
  ,AGRE_PROD_TYPE            --签约主产品类型
  ,AGREEMENT_AMT             --协议金额
  ,LAST_CHANGE_USER_ID       --最后修改柜员
  ,OPPOSITE_INTERNAL_KEY     --签约对方账户内部键
  ,OUT_SIGN_BRANCH           --解约机构
  ,OUT_SIGN_USER_ID          --解约柜员
  ,SIGN_BRANCH               --签约机构
  ,SIGN_USER_ID              --签约柜员
  ,TRAN_BRANCH               --核心交易机构编号
  ,START_DT                  --开始时间
  ,END_DT                    --结束时间
  ,ID_MARK                   --增删标志
  ,ETL_TIMESTAMP             --ETL处理时间戳
  )
  SELECT ACCT_NAME                 --账户名称
        ,ACCT_SEQ_NO               --账户子账号
        ,BASE_ACCT_NO              --交易账号/卡号
        ,CLIENT_NO                 --客户编号
        ,CLIENT_SHORT              --客户简称
        ,PROD_TYPE                 --产品编号
        ,USER_ID                   --交易柜员编号
        ,AGREEMENT_CLASS           --协议分类
        ,AGREEMENT_CLOSE_ACCT_FLAG --签约后是否允许销户
        ,AGREEMENT_ID              --协议编号
        ,AGREEMENT_KEY             --协议键值
        ,AGREEMENT_KEY_TYPE        --协议键类型
        ,AGREEMENT_STATUS          --协议状态
        ,AGREEMENT_TYPE            --协议类型
        ,COMPANY                   --法人
        ,OUT_SIGN_CHANNEL          --解约渠道
        ,SIGN_CHANNEL              --签约渠道
        ,AGREEMENT_OPEN_DATE       --协议签订日期
        ,END_DATE                  --结束日期
        ,LAST_CHANGE_DATE          --最后修改日期
        ,OUT_SIGN_DATE             --解约日期
        ,SIGN_DATE                 --签约日期
        ,START_DATE                --开始日期
        ,TRAN_TIMESTAMP            --交易时间戳
        ,ACCT_CCY                  --账户币种
        ,AGRE_PROD_TYPE            --签约主产品类型
        ,AGREEMENT_AMT             --协议金额
        ,LAST_CHANGE_USER_ID       --最后修改柜员
        ,OPPOSITE_INTERNAL_KEY     --签约对方账户内部键
        ,OUT_SIGN_BRANCH           --解约机构
        ,OUT_SIGN_USER_ID          --解约柜员
        ,SIGN_BRANCH               --签约机构
        ,SIGN_USER_ID              --签约柜员
        ,TRAN_BRANCH               --核心交易机构编号
        ,START_DT                  --开始时间
        ,END_DT                    --结束时间
        ,ID_MARK                   --增删标志
        ,ETL_TIMESTAMP             --ETL处理时间戳
    FROM IOL.NCBS_RB_AGREEMENT  --合同/协议信息表
   WHERE START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND ID_MARK <> 'D';

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

END ETL_O_IOL_NCBS_RB_AGREEMENT;
/

