CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_AGT_VOUCH_ACCT_RELA_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_AGT_VOUCH_ACCT_RELA_H
  *  功能描述：凭证账户关系历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_VOUCH_ACCT_RELA_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_AGT_VOUCH_ACCT_RELA_H'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE; --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

   SELECT CASE WHEN I_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN I_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN I_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN I_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN I_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN I_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_AGT_VOUCH_ACCT_RELA_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-凭证账户关系历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_VOUCH_ACCT_RELA_H
  (   --   ETL_DT  --数据日期
      AGT_ID  --协议编号
      ,LP_ID  --法人编号
      ,CUST_ACCT_NUM  --客户账号
      ,DEP_VOUCH_CATE_CD  --存款凭证类别代码
      ,VOUCH_NO  --凭证号码
      ,PROD_ID  --产品编号
      ,CURR_CD  --币种代码
      ,SUB_ACCT_NUM  --子账号
      ,CARD_NO  --卡号
      ,VOUCH_KIND_CD  --凭证种类代码
      ,VOUCH_STATUS_CD  --凭证状态代码
      ,VOUCH_ORIG_STATUS_CD  --凭证原状态代码
      ,TRAN_REF_NO  --交易参考号
      ,PM_FLG  --抵质押标志
      ,PM_ID  --抵质押编号
      ,CUST_ID  --客户编号
      ,TRAN_MEMO_DESCB  --交易摘要描述
      ,TRAN_DT  --交易日期
      ,CANCEL_RS_CD  --作废原因代码
      ,START_DT  --开始日期
      ,END_DT  --结束日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    )
    SELECT

      --ETL_DT  --数据日期
      AGT_ID  --协议编号
      ,LP_ID  --法人编号
      ,CUST_ACCT_NUM  --客户账号
      ,DEP_VOUCH_CATE_CD  --存款凭证类别代码
      ,VOUCH_NO  --凭证号码
      ,PROD_ID  --产品编号
      ,CURR_CD  --币种代码
      ,SUB_ACCT_NUM  --子账号
      ,CARD_NO  --卡号
      ,VOUCH_KIND_CD  --凭证种类代码
      ,VOUCH_STATUS_CD  --凭证状态代码
      ,VOUCH_ORIG_STATUS_CD  --凭证原状态代码
      ,TRAN_REF_NO  --交易参考号
      ,PM_FLG  --抵质押标志
      ,PM_ID  --抵质押编号
      ,CUST_ID  --客户编号
      ,TRAN_MEMO_DESCB  --交易摘要描述
      ,TRAN_DT  --交易日期
      ,CANCEL_RS_CD  --作废原因代码
      ,START_DT  --开始日期
      ,END_DT  --结束日期
      ,ID_MARK  --删除标识
    ,JOB_CD --任务代码
    FROM IML.V_AGT_VOUCH_ACCT_RELA_H;  --视图-凭证账户关系历史
   -- WHERE ETL_DT = V_P_DATE;

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

  END ETL_INIT_O_IML_AGT_VOUCH_ACCT_RELA_H;
/

