CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_FUD(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ISBS_FUD
  *  功能描述：远期结售汇信息表
  *  创建日期：20251208
  *  开发人员：于敬艺
  *  来源表： IOL.V_ISBS_FUD
  *  目标表： O_IOL_ISBS_FUD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251208  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ISBS_FUD'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_FUD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-远期结售汇信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_FUD NOLOGGING
    (        INR          --主键
             ,OWNREF      --Own Reference (业务参考号)
             ,NAM         --显示名称
             ,OPNDAT      --创建日期
             ,PROREF      --委托书编号
             ,OVAREF      --客户参数编号
             ,TRNWAY      --交易方向
             ,LMTTYP      --交割类型
             ,EXPDAT      --到期日
             ,FRGACT      --外币账号
             ,FRGCUR      --外币币别
             ,FRGAMT      --外币金额
             ,RAT         --成交汇率
             ,CNYACT      --人民币账号
             ,CNYCUR      --人民币币别
             ,CNYAMT      --人民币金额
             ,CLSDAT      --闭卷日期
             ,MRGACT      --保证金账号
             ,MRGCUR      --保证金币别
             ,CSHPCT      --保证金比例
             ,CSHPCTORI   --当前保证金比例
             ,APLPTYINR   --申请人PTY表INR
             ,APLPTAINR   --申请人PTA表INR
             ,APLNAM      --客户名称
             ,APLTYP      --客户类型
             ,APLREF      --客户参考号
             ,INQREF      --询价编号
             ,FIXLMT      --固定期限交割)
             ,BEGDAT      --起始日
             ,ENDDAT      --终止日
             ,STDLMT      --标准期限
             ,EXTLMT      --是否可宽限
             ,EXTFLG      --择期交割通知标志
             ,HDLTYP      --合理状态
             ,SYSRAT      --系统内平盘汇率
             ,SPTRAT      --远期价格
             ,APPDAT      --客户申请日期
             ,INFDSP      --Display Infotext
             ,SPREAD      --展期标志
             ,VER         --版本号
             ,CREDAT      --登记日期
             ,PNTTYP      --父业务类型
             ,PNTINR      --父业务主键
             ,BRANCHINR   --所属机构主键
             ,BCHKEYINR   --经办机构主键
             ,LSTAMT      --损益人民币金额
             ,SYFLG       --是否损失
             ,LOSAMT      --我行损失金额
             ,LOSCUR      --币种
             ,LSTCUR      --币种
             ,ETYEXTKEY   --业务主体信息
             ,TRNMAN      --交易主体
             ,TRDINT      --TRADE IN
             ,TRDOUT      --TRADE OUT
             ,REGREF      --Register reference
             ,SETDAT      --Settlement date
             ,SETREF      --交割编号
             ,CETRAT      --客户展期近端汇率
             ,CEURAT      --客户展期远端汇率
             ,CESAMT      --客户展期损益
             ,CESACT      --客户展期损益入/出账号
             ,BETRAT      --我行展期近端汇率
             ,BEURAT      --我行展期远端汇率
             ,BESAMT      --我行展期损益
             ,EUSINC      --展期价差收益
             ,EUDTYP      --日期展期类型
             ,CDRRAT      --客户对冲价格
             ,CDRAMT      --客户损失金额
             ,CDRACT      --客户扣款"号(违约)
             ,BDRRAT      --我行对冲价格
             ,BDRAMT      --我行违约损益
             ,DCRINC      --违约价差收益
             ,MRGCURBNK   --Margin Currency (保证金币别)
             ,CSHPCTBNK   --Margin Percent (保证金比例)
             ,CNYAMTBNK   --CN Amount (人民币金额-银行端)
             ,CNYCURBNK   --CN Currency (人民币币别-银行端)
             ,CVAREF      --客户协议编号
             ,INFFRGAMT   --通知交割金额
             ,INFEXPDAT   --通知交割到期日
             ,INFFVAREF   --签约编号
             ,INFADVFLG   --通知交割类型
             ,CLSFLG      --授信闭卷状态
             ,CDTREF      --授信编号
             ,LMTPCT      --授信额度比例
             ,CCVINT      --保证金计息方式
             ,CCVRAT      --保证金中间价
             ,LMDAMT      --授信额度扣减金额
             ,MRGAMT      --本次保证金金额
             ,LMTAMT      --展期新增授信额度
             ,MRGAMTBNK   --银行端保证金/授信额度
             ,OWNUSR      --Responsible User
             ,OLDOWNREF   --历史参考号
             ,MRGAMTPRT   --保证金余额
             ,PADFLG      --垫款标志
             ,SELFLG      --自营标志
             ,ZJLY        --资金来源
             ,RPTCOD      --申报代码
             ,DBWAY       --担保方式
             ,SETLMTTYP   --交割期限类型
             ,RCVBNKAMT   --收合作银行金额
             ,RCVTYP      --收款类
             ,OWNACT      --我行扣款/收款账号
             ,SEQNO       --账户序列号
             ,HKCHN       --汇款渠道
             ,START_DT    --开始时间
             ,END_DT      --结束时间
             ,ID_MARK     --增删标志
             ,ETL_TIMESTAMP      --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
            INR          --主键
             ,OWNREF      --Own Reference (业务参考号)
             ,NAM         --显示名称
             ,OPNDAT      --创建日期
             ,PROREF      --委托书编号
             ,OVAREF      --客户参数编号
             ,TRNWAY      --交易方向
             ,LMTTYP      --交割类型
             ,EXPDAT      --到期日
             ,FRGACT      --外币账号
             ,FRGCUR      --外币币别
             ,FRGAMT      --外币金额
             ,RAT         --成交汇率
             ,CNYACT      --人民币账号
             ,CNYCUR      --人民币币别
             ,CNYAMT      --人民币金额
             ,CLSDAT      --闭卷日期
             ,MRGACT      --保证金账号
             ,MRGCUR      --保证金币别
             ,CSHPCT      --保证金比例
             ,CSHPCTORI   --当前保证金比例
             ,APLPTYINR   --申请人PTY表INR
             ,APLPTAINR   --申请人PTA表INR
             ,APLNAM      --客户名称
             ,APLTYP      --客户类型
             ,APLREF      --客户参考号
             ,INQREF      --询价编号
             ,FIXLMT      --固定期限交割)
             ,BEGDAT      --起始日
             ,ENDDAT      --终止日
             ,STDLMT      --标准期限
             ,EXTLMT      --是否可宽限
             ,EXTFLG      --择期交割通知标志
             ,HDLTYP      --合理状态
             ,SYSRAT      --系统内平盘汇率
             ,SPTRAT      --远期价格
             ,APPDAT      --客户申请日期
             ,INFDSP      --Display Infotext
             ,SPREAD      --展期标志
             ,VER         --版本号
             ,CREDAT      --登记日期
             ,PNTTYP      --父业务类型
             ,PNTINR      --父业务主键
             ,BRANCHINR   --所属机构主键
             ,BCHKEYINR   --经办机构主键
             ,LSTAMT      --损益人民币金额
             ,SYFLG       --是否损失
             ,LOSAMT      --我行损失金额
             ,LOSCUR      --币种
             ,LSTCUR      --币种
             ,ETYEXTKEY   --业务主体信息
             ,TRNMAN      --交易主体
             ,TRDINT      --TRADE IN
             ,TRDOUT      --TRADE OUT
             ,REGREF      --Register reference
             ,SETDAT      --Settlement date
             ,SETREF      --交割编号
             ,CETRAT      --客户展期近端汇率
             ,CEURAT      --客户展期远端汇率
             ,CESAMT      --客户展期损益
             ,CESACT      --客户展期损益入/出账号
             ,BETRAT      --我行展期近端汇率
             ,BEURAT      --我行展期远端汇率
             ,BESAMT      --我行展期损益
             ,EUSINC      --展期价差收益
             ,EUDTYP      --日期展期类型
             ,CDRRAT      --客户对冲价格
             ,CDRAMT      --客户损失金额
             ,CDRACT      --客户扣款"号(违约)
             ,BDRRAT      --我行对冲价格
             ,BDRAMT      --我行违约损益
             ,DCRINC      --违约价差收益
             ,MRGCURBNK   --Margin Currency (保证金币别)
             ,CSHPCTBNK   --Margin Percent (保证金比例)
             ,CNYAMTBNK   --CN Amount (人民币金额-银行端)
             ,CNYCURBNK   --CN Currency (人民币币别-银行端)
             ,CVAREF      --客户协议编号
             ,INFFRGAMT   --通知交割金额
             ,INFEXPDAT   --通知交割到期日
             ,INFFVAREF   --签约编号
             ,INFADVFLG   --通知交割类型
             ,CLSFLG      --授信闭卷状态
             ,CDTREF      --授信编号
             ,LMTPCT      --授信额度比例
             ,CCVINT      --保证金计息方式
             ,CCVRAT      --保证金中间价
             ,LMDAMT      --授信额度扣减金额
             ,MRGAMT      --本次保证金金额
             ,LMTAMT      --展期新增授信额度
             ,MRGAMTBNK   --银行端保证金/授信额度
             ,OWNUSR      --Responsible User
             ,OLDOWNREF   --历史参考号
             ,MRGAMTPRT   --保证金余额
             ,PADFLG      --垫款标志
             ,SELFLG      --自营标志
             ,ZJLY        --资金来源
             ,RPTCOD      --申报代码
             ,DBWAY       --担保方式
             ,SETLMTTYP   --交割期限类型
             ,RCVBNKAMT   --收合作银行金额
             ,RCVTYP      --收款类
             ,OWNACT      --我行扣款/收款账号
             ,SEQNO       --账户序列号
             ,HKCHN       --汇款渠道
             ,START_DT    --开始时间
             ,END_DT      --结束时间
             ,ID_MARK     --增删标志
             ,ETL_TIMESTAMP      --ETL处理时间戳
    FROM IOL.V_ISBS_FUD   --远期结售汇信息表
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

  END ETL_O_IOL_ISBS_FUD;
/

