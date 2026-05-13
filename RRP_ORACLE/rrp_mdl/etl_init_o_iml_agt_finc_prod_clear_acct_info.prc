CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 理财产品清算账户信息
  **存储过程名称：    ETL_INIT_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO NOLOGGING
    (
       AGT_ID                           --协议编号
      ,LP_ID                            --法人编号
      ,PROD_ID                          --产品编号
      ,PROD_NAME                        --产品名称
      ,TA_CD                            --TA代码
      ,RGST_RGST_ACCT_BANK_ID           --注册登记账户银行编号
      ,COLL_CAP_VRFCTION_ACCT_ID        --募集验资账户编号
      ,COLL_CAP_VERI_ACCT_ACCT_NAME     --募集验资户账户名称
      ,CAP_VRFCTION_ACCT_BANK_ID        --验资账户银行编号
      ,MAKE_ACCT_BANK_ACCT_ID           --上帐银行账户编号
      ,MAKE_ACCT_BANK_ACCT_NUM_NAME     --上帐银行账号名称
      ,KEEP_ACCT_BANK_ACCT_ID           --下帐银行账户编号
      ,KEEP_ACCT_BANK_ACCT_NUM_NAME     --下帐银行账号名称
      ,STL_WAY_CD                       --结算方式代码
      ,TRUST_ORG_OPEN_BANK_NAME         --托管机构开户行名称
      ,TRUST_ORG_NAME                   --托管机构名称
      ,REMARK_1                         --备注1
      ,START_DT                         --开始日期
      ,END_DT                           --结束日期
      ,ID_MARK                          --删除标识
      ,SRC_TABLE_NAME                   --源表名称
      ,JOB_CD                           --任务代码
      ,ETL_TIMESTAMP                    --数据处理时间

    )
  SELECT /*+PARALLEL*/
          AGT_ID                           --协议编号
      ,LP_ID                            --法人编号
      ,PROD_ID                          --产品编号
      ,PROD_NAME                        --产品名称
      ,TA_CD                            --TA代码
      ,RGST_RGST_ACCT_BANK_ID           --注册登记账户银行编号
      ,COLL_CAP_VRFCTION_ACCT_ID        --募集验资账户编号
      ,COLL_CAP_VERI_ACCT_ACCT_NAME     --募集验资户账户名称
      ,CAP_VRFCTION_ACCT_BANK_ID        --验资账户银行编号
      ,MAKE_ACCT_BANK_ACCT_ID           --上帐银行账户编号
      ,MAKE_ACCT_BANK_ACCT_NUM_NAME     --上帐银行账号名称
      ,KEEP_ACCT_BANK_ACCT_ID           --下帐银行账户编号
      ,KEEP_ACCT_BANK_ACCT_NUM_NAME     --下帐银行账号名称
      ,STL_WAY_CD                       --结算方式代码
      ,TRUST_ORG_OPEN_BANK_NAME         --托管机构开户行名称
      ,TRUST_ORG_NAME                   --托管机构名称
      ,REMARK_1                         --备注1
      ,START_DT                         --开始日期
      ,END_DT                           --结束日期
      ,ID_MARK                          --删除标识
      ,SRC_TABLE_NAME                   --源表名称
      ,JOB_CD                           --任务代码
      ,ETL_TIMESTAMP                    --数据处理时
    FROM IML.V_AGT_FINC_PROD_CLEAR_ACCT_INFO   理财产品清算账户信息--视图

   ;
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


END ETL_INIT_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO;
/

