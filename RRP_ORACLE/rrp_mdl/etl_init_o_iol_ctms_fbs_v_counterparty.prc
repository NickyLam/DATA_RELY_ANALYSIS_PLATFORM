CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_CTMS_FBS_V_COUNTERPARTY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_CTMS_FBS_V_COUNTERPARTY
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_CTMS_FBS_V_COUNTERPARTY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_CTMS_FBS_V_COUNTERPARTY'; -- 程序名称
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

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_FBS_V_COUNTERPARTY';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_FBS_V_COUNTERPARTY NOLOGGING
    ( COUNTERPARTY_SEQ,                 --交易对手编号
      CUS_NUMBER,                       --机构编号
      LABEL,                            --其他系统编号
      COUNTERPARTY_CNAME,               --中文名称
      COUNTERPARTY_ENAME,               --英文名称
      CONTACT_NAME,                     --联系人
      TELEPHONE,                        --电话
      FAX,                              --传真
      UPDATE_USER,                      --更新用户
      UPDATE_TIME,                      --更新时间
      IS_ISSUER,                        --是否为发行者
      IS_BANK,                          --是否为银行
      IS_GUARANTEE,                     --是否为保证人
      IS_CUSTODY,                       --是否为托管机构
      CUSTOMER_TYPE,                    --行业类别
      PARENT,                           --母公司
      RATING_LEVEL,                     --內部信用訳級
      EX_CODE,                          --联行号
      EX_ACCOUNT,                       --人行大额支付系统号
      SWIFT_CODE,                       --SWIFT 电文代号
      REF_ISSUER_ID,                    --ISSUER, OR GUARANTEE 会有该字段
      CFETS_MEMBER_ID,                  --外汇编号或者第三方交易对手编号
      COUNTERPARTY_SHORT_CNAME,         --交易对手方中文简称
      COUNTERPARTY_SHORT_ENAME,         --交易对手方英文简称
      CFETS_FX_MEMBER_ID,               --外汇编号
      CFETS_MEMBER_ATTR,                --外汇会员类型
      COUNTERPARTY_FX_SHORT_ENAME,      --外汇交易对手方英文简称
      INTERBANKTYPE,                    --交易对手同业类型
      OVERSEAS,                         --境内境外
      START_DT,                         --开始时间
      END_DT,                           --结束时间
      ID_MARK                           --增删标志
     )
  SELECT /*+PARALLEL*/
         COUNTERPARTY_SEQ,                 --交易对手编号
         CUS_NUMBER,                       --机构编号
         LABEL,                            --其他系统编号
         COUNTERPARTY_CNAME,               --中文名称
         COUNTERPARTY_ENAME,               --英文名称
         CONTACT_NAME,                     --联系人
         TELEPHONE,                        --电话
         FAX,                              --传真
         UPDATE_USER,                      --更新用户
         UPDATE_TIME,                      --更新时间
         IS_ISSUER,                        --是否为发行者
         IS_BANK,                          --是否为银行
         IS_GUARANTEE,                     --是否为保证人
         IS_CUSTODY,                       --是否为托管机构
         CUSTOMER_TYPE,                    --行业类别
         PARENT,                           --母公司
         RATING_LEVEL,                     --內部信用訳級
         EX_CODE,                          --联行号
         EX_ACCOUNT,                       --人行大额支付系统号
         SWIFT_CODE,                       --SWIFT 电文代号
         REF_ISSUER_ID,                    --ISSUER, OR GUARANTEE 会有该字段
         CFETS_MEMBER_ID,                  --外汇编号或者第三方交易对手编号
         COUNTERPARTY_SHORT_CNAME,         --交易对手方中文简称
         COUNTERPARTY_SHORT_ENAME,         --交易对手方英文简称
         CFETS_FX_MEMBER_ID,               --外汇编号
         CFETS_MEMBER_ATTR,                --外汇会员类型
         COUNTERPARTY_FX_SHORT_ENAME,      --外汇交易对手方英文简称
         INTERBANKTYPE,                    --交易对手同业类型
         OVERSEAS,                         --境内境外
         START_DT,                         --开始时间
         END_DT,                           --结束时间
         ID_MARK                           --增删标志
    FROM IOL.V_CTMS_FBS_V_COUNTERPARTY   --交易对手视图_视图
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

  END ETL_INIT_O_IOL_CTMS_FBS_V_COUNTERPARTY;
/

