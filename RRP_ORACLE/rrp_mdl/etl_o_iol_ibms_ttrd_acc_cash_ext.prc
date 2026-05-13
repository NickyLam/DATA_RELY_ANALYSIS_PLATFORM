CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_ACC_CASH_EXT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_ACC_CASH_EXT
  *  功能描述：一级资金账户表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IBMS_TTRD_ACC_CASH_EXT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_ACC_CASH_EXT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACC_CASH_EXT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-一级资金账户表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACC_CASH_EXT NOLOGGING
    (    ACCID                     --账户代码
        ,ACCNAME                   --账户名称
        ,MARKETS                   --交易市场
        ,EXHACC                    --交易所账户
        ,PASSWORD                  --账户密码
        ,STATUS                    --0：创建中, 11：已启用,  22：停用中  3：已停用
        ,CURRENCY                  --币种
        ,DN_RATIO                  --等待补充
        ,THRESHOLD                 --等待补充
        ,LARGE_PAY_ACCNO           --大额支付行号
        ,RATE                      --利率
        ,BANK_CODE                 --开户银行行号
        ,BANK_NAME                 --开户银行名称
        ,OPEN_DATE                 --开户时间
        ,IS_DVP                    --1 是 0 否
        ,CUSTOMER_ID               --客户（交易对手）编码
        ,CUSTOMER_NAME             --客户（交易对手）名称
        ,INNER_ACCID               --内部资金账号ID
        ,ENABLED                   --启用--等待补充
        ,HANDS_BANK_CODE           --农信银行号
        ,COUPONTYPE                --计息方式
        ,ACCOUNTTYPE               --1-普通 2-保证金 3-特种
        ,INNER_CODE                --内部账号
        ,OLDINST_ID                --记账机构
        ,INNER_ACCNAME             --内部账名称
        ,PAYMENT_FREQ              --付息频率
        ,RATE_DEF_ID               --利率定义ID
        ,UPDATE_USER               --更新者
        ,UPDATE_TIME               --更新时间
        ,CREATE_TIME               --创建日期
        ,INVEST_TYPE               --0自有资产（自营业务）、1客户资产（代客、理财）
        ,PAY_MONTH                 --支付月份
        ,PAY_DAY                   --支付日期
        ,I_ID                      --机构号
        ,COUPON                    --利率
        ,CLOSE_DATE                --销户时间
        ,P_TYPE                    --产品分类
        ,P_CLASS                   --产品类型
        ,SUBJ_CODE                 --科目号
        ,SWIFT_CODE                --SWIFT_CODE
        ,MID_BANK_ACCT_CODE        --中间行账号
        ,MID_BANK_NAME             --中间行名称
        ,MID_SWIFT_CODE            --中间行SWIFT代码
        ,USE_CASH_ACC              --SWIFT报文是否含账号
        ,BANK_LEGAL_PERSON_NAME    --开户行法人名称
        ,BRANCH_BANK_NUMBER        --存款行网点行号
        ,ACCOUNT_NATURE            --账户性质
        ,ACCOUNT_ATTRIBUTE         --账户属性
        ,START_DT                  --开始时间
        ,END_DT                    --结束时间
        ,ID_MARK                   --增删标志
    )
  SELECT /*+PARALLEL*/
       ACCID                     --账户代码
      ,ACCNAME                   --账户名称
      ,MARKETS                   --交易市场
      ,EXHACC                    --交易所账户
      ,PASSWORD                  --账户密码
      ,STATUS                    --0：创建中, 11：已启用,  22：停用中  3：已停用
      ,CURRENCY                  --币种
      ,DN_RATIO                  --等待补充
      ,THRESHOLD                 --等待补充
      ,LARGE_PAY_ACCNO           --大额支付行号
      ,RATE                      --利率
      ,BANK_CODE                 --开户银行行号
      ,BANK_NAME                 --开户银行名称
      ,OPEN_DATE                 --开户时间
      ,IS_DVP                    --1 是 0 否
      ,CUSTOMER_ID               --客户（交易对手）编码
      ,CUSTOMER_NAME             --客户（交易对手）名称
      ,INNER_ACCID               --内部资金账号ID
      ,ENABLED                   --启用--等待补充
      ,HANDS_BANK_CODE           --农信银行号
      ,COUPONTYPE                --计息方式
      ,ACCOUNTTYPE               --1-普通 2-保证金 3-特种
      ,INNER_CODE                --内部账号
      ,OLDINST_ID                --记账机构
      ,INNER_ACCNAME             --内部账名称
      ,PAYMENT_FREQ              --付息频率
      ,RATE_DEF_ID               --利率定义ID
      ,UPDATE_USER               --更新者
      ,UPDATE_TIME               --更新时间
      ,CREATE_TIME               --创建日期
      ,INVEST_TYPE               --0自有资产（自营业务）、1客户资产（代客、理财）
      ,PAY_MONTH                 --支付月份
      ,PAY_DAY                   --支付日期
      ,I_ID                      --机构号
      ,COUPON                    --利率
      ,CLOSE_DATE                --销户时间
      ,P_TYPE                    --产品分类
      ,P_CLASS                   --产品类型
      ,SUBJ_CODE                 --科目号
      ,SWIFT_CODE                --SWIFT_CODE
      ,MID_BANK_ACCT_CODE        --中间行账号
      ,MID_BANK_NAME             --中间行名称
      ,MID_SWIFT_CODE            --中间行SWIFT代码
      ,USE_CASH_ACC              --SWIFT报文是否含账号
      ,BANK_LEGAL_PERSON_NAME    --开户行法人名称
      ,BRANCH_BANK_NUMBER        --存款行网点行号
      ,ACCOUNT_NATURE            --账户性质
      ,ACCOUNT_ATTRIBUTE         --账户属性
      ,START_DT                  --开始时间
      ,END_DT                    --结束时间
      ,ID_MARK                   --增删标志
    FROM IOL.V_IBMS_TTRD_ACC_CASH_EXT   --一级资金账户表_视图
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

  END ETL_O_IOL_IBMS_TTRD_ACC_CASH_EXT;
/

