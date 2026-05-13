CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_ICMS_DEPOSIT_APPLY_INFO (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_ICMS_DEPOSIT_APPLY_INFO
  *  功能描述：保证金解冻申请信息
  *  创建日期：20221208
  *  开发人员：梅炜
  *  来源表： IOL.V_ICMS_DEPOSIT_APPLY_INFO
  *  目标表： O_IOL_ICMS_DEPOSIT_APPLY_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_ICMS_DEPOSIT_APPLY_INFO'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_ICMS_DEPOSIT_APPLY_INFO  ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_ICMS_DEPOSIT_APPLY_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户账户注册手机号历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO
  (
        SERIALNO  --申请流水号
        ,REMAKE  --追加说明
        ,CUSNAME  --客户名称
        ,GRTEAC  --保证金帐号
        ,PIGEONHOLEDATE  --归档日期
        ,PDRIFV  --浮动值
        ,INPUTORGID  --登记机构
        ,CNTRTP  --协议类型1--承兑汇票协议 2–保函合同
        ,EXCHANGEDATE  --交易日期
        ,OTRVBLDN  --表外记账方向
        ,CRCYCD  --币种
        ,OTRVACNO  --表外账号
        ,FXFLTP  --利率类型（核心CRGTRT加）
        ,APPROVESTATUS  --流程状态
        ,HASCANCEL  --是否已撤销Y是N否默认可以为空
        ,ISOPEN  --是否释放敞口
        ,BATCHSERIALNO  --批次流水
        ,INITEXCHANGESERIALNO  --原交易流水号
        ,EXCHANGETIME  --交易日期
        ,INTERESTRATE  --协议利率
        ,BAILSUM  --已缴保证金金额
        ,INPUTUSERID  --登记人
        ,UPDATEUSERID  --更新人
        ,CONTRACTNO  --合同流水号
        ,PUTOUTNO  --出账流水号
        ,MATUDT  --到期日期票据到期日
        ,SUBACCOUNT  --子户号
        ,EXCHANGESERIALNO  --交易流水号
        ,BUSINESSTYPE  --转出业务类型
        ,OTSUSBTP  --冻结止付方式
        ,UPDATEORGID  --更新机构
        ,TRANAM  --金额
        ,EXCHANGESTATE  --交易状态
        ,DATAID  --唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
        ,BALANCE  --业务余额
        ,INPUTDATE  --登记日期
        ,GRTETP  --保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
        ,PUTOUTDATE  --业务起贷日
        ,PDRIFD  --利率浮动类型
        ,ISDISCOUNTFLAG  --是否当前借款人
        ,MIGTFLAG
        ,CUSID  --客户ID
        ,INTERESTMETHOD  --计息方法
        ,MATURITY  --业务到期日
        ,PRCSNA  --表外摘要
        ,ACPTNO  --票据号码此字段针对承兑（若GRTETP为2时此字段不能为空）
        ,OPERTP  --操作类型1--建立保证金对应关系 2–追加保证金
        ,TERMCD  --存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
        ,OTFRSPTP  --冻结止付类型
        ,OTFZREMK  --冻结止付原因
        ,INITEXCHANGEDATE  --原交易日期
        ,BUSINESSSUM  --业务金额
        ,OTRVACNA  --表外账号名
        ,UPDATEDATE  --更新日期
        ,ACCTNO  --转出账号
        ,OTFROZSQ  --子户冻结流水
        ,PDRIFM  --利率浮动方式
        ,INPUTTYPE  --生成来源
        ,BAILINTERESTMETHOD  --保证金账户属性
        ,DEPOSITTERMTYPE  --保证金账户属性
        ,DEPOSITTERM  --存期期限
        ,BAILINTERESTRATE  --保证金执行（协议）利率
        ,DEPOSITBASERATE  --存款基准利率
        ,BAILTERM  --保证金利率档次
       -- ,BAILBALANCEAMT  --保证金余额
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,ETL_TIMESTAMP  --ETL处理时间戳


    )
    SELECT
        SERIALNO  --申请流水号
        ,REMAKE  --追加说明
        ,CUSNAME  --客户名称
        ,GRTEAC  --保证金帐号
        ,PIGEONHOLEDATE  --归档日期
        ,PDRIFV  --浮动值
        ,INPUTORGID  --登记机构
        ,CNTRTP  --协议类型1--承兑汇票协议 2–保函合同
        ,EXCHANGEDATE  --交易日期
        ,OTRVBLDN  --表外记账方向
        ,CRCYCD  --币种
        ,OTRVACNO  --表外账号
        ,FXFLTP  --利率类型（核心CRGTRT加）
        ,APPROVESTATUS  --流程状态
        ,HASCANCEL  --是否已撤销Y是N否默认可以为空
        ,ISOPEN  --是否释放敞口
        ,BATCHSERIALNO  --批次流水
        ,INITEXCHANGESERIALNO  --原交易流水号
        ,EXCHANGETIME  --交易日期
        ,INTERESTRATE  --协议利率
        ,BAILSUM  --已缴保证金金额
        ,INPUTUSERID  --登记人
        ,UPDATEUSERID  --更新人
        ,CONTRACTNO  --合同流水号
        ,PUTOUTNO  --出账流水号
        ,MATUDT  --到期日期票据到期日
        ,SUBACCOUNT  --子户号
        ,EXCHANGESERIALNO  --交易流水号
        ,BUSINESSTYPE  --转出业务类型
        ,OTSUSBTP  --冻结止付方式
        ,UPDATEORGID  --更新机构
        ,TRANAM  --金额
        ,EXCHANGESTATE  --交易状态
        ,DATAID  --唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
        ,BALANCE  --业务余额
        ,INPUTDATE  --登记日期
        ,GRTETP  --保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
        ,PUTOUTDATE  --业务起贷日
        ,PDRIFD  --利率浮动类型
        ,ISDISCOUNTFLAG  --是否当前借款人
        ,MIGTFLAG
        ,CUSID  --客户ID
        ,INTERESTMETHOD  --计息方法
        ,MATURITY  --业务到期日
        ,PRCSNA  --表外摘要
        ,ACPTNO  --票据号码此字段针对承兑（若GRTETP为2时此字段不能为空）
        ,OPERTP  --操作类型1--建立保证金对应关系 2–追加保证金
        ,TERMCD  --存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
        ,OTFRSPTP  --冻结止付类型
        ,OTFZREMK  --冻结止付原因
        ,INITEXCHANGEDATE  --原交易日期
        ,BUSINESSSUM  --业务金额
        ,OTRVACNA  --表外账号名
        ,UPDATEDATE  --更新日期
        ,ACCTNO  --转出账号
        ,OTFROZSQ  --子户冻结流水
        ,PDRIFM  --利率浮动方式
        ,INPUTTYPE  --生成来源
        ,BAILINTERESTMETHOD  --保证金账户属性
        ,DEPOSITTERMTYPE  --保证金账户属性
        ,DEPOSITTERM  --存期期限
        ,BAILINTERESTRATE  --保证金执行（协议）利率
        ,DEPOSITBASERATE  --存款基准利率
        ,BAILTERM  --保证金利率档次
       -- ,BAILBALANCEAMT  --保证金余额
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IOL.V_ICMS_DEPOSIT_APPLY_INFO
    /**/  --视图-客户账户注册手机号历史
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

  END ETL_INIT_O_IOL_ICMS_DEPOSIT_APPLY_INFO ;
/

