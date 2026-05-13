CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL
  *  功能描述：微众存款账户IP核对明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-微众存款账户IP核对明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL
    (ETL_DT                        --数据日期
    ,AGT_ID                        --协议编号
    ,LP_ID                         --法人编号
    ,CUST_NAME                     --客户姓名
    ,CERT_NO                       --证件号码
    ,CUST_ID                       --客户编号
    ,GHB_CARD_NO                   --本行卡号
    ,WEBANK_CARD_NO                --微众银行卡号
    ,OPEN_IP                       --开户IP
    ,PERMT_IP                      --常驻IP
    ,CHECK_IP_FLG                  --核对IP标志
    ,GD_PROV_INT_FLG               --广东省内标志
    ,CHECK_TM                      --核对时间
    ,WDRAW_FLG                     --回撤标志
    ,WDRAW_TM                      --回撤时间
    ,WDRAW_RETURN_CODE             --回撤返回码
    ,WDRAW_RETURN_CODE_DESCB       --回撤返回码描述
    ,JOB_CD                        --任务代码
    )
  SELECT 
     ETL_DT                        --数据日期
    ,AGT_ID                        --协议编号
    ,LP_ID                         --法人编号
    ,CUST_NAME                     --客户姓名
    ,CERT_NO                       --证件号码
    ,CUST_ID                       --客户编号
    ,GHB_CARD_NO                   --本行卡号
    ,WEBANK_CARD_NO                --微众银行卡号
    ,OPEN_IP                       --开户IP
    ,PERMT_IP                      --常驻IP
    ,CHECK_IP_FLG                  --核对IP标志
    ,GD_PROV_INT_FLG               --广东省内标志
    ,CHECK_TM                      --核对时间
    ,WDRAW_FLG                     --回撤标志
    ,WDRAW_TM                      --回撤时间
    ,WDRAW_RETURN_CODE             --回撤返回码
    ,WDRAW_RETURN_CODE_DESCB       --回撤返回码描述
    ,JOB_CD                        --任务代码
    FROM IML.V_AGT_WE_DEP_ACCT_IP_CHECK_DTL  --视图-代理代销产品信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_AGT_WE_DEP_ACCT_IP_CHECK_DTL;
/

