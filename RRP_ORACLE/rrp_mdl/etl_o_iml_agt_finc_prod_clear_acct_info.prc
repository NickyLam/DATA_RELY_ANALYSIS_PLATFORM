CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                    O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                    )
 /*******************************************************************
  **存储过程详细说明： 理财产品清算账户信息
  **存储过程名称：    ETL_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20240719    YJY        加注释
  *  20241226    YJY        优化脚本
  *  20251010    YJY        新增购买账户编号、赎回账户编号
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-理财产品清算账户信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO NOLOGGING
    (AGT_ID                           --协议编号
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
    ,BUY_ACCT_ID	                    --购买账户编号 ADD BY YJY 20251010
    ,REDEM_ACCT_ID	                  --赎回账户编号 ADD BY YJY 20251010
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
        ,BUY_ACCT_ID	                    --购买账户编号 ADD BY YJY 20251010
        ,REDEM_ACCT_ID	                  --赎回账户编号 ADD BY YJY 20251010
    FROM IML.V_AGT_FINC_PROD_CLEAR_ACCT_INFO --理财产品清算账户信息--视图
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_AGT_FINC_PROD_CLEAR_ACCT_INFO;
/

