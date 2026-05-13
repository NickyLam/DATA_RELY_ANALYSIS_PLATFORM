CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_WL_CONT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                       O_ERRCODE OUT VARCHAR2 --错误代码
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_WL_CONT_INFO
  *  功能描述：网贷合同信息
  *  创建日期：20220317
  *  开发人员：易梓林
  *  来源表：
  *  目标表： O_IML_AGT_WL_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220317  易梓林   首次创建
  *             2    20250610  YJY      剔除删除数据  
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_WL_CONT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_WL_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-网贷合同信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_WL_CONT_INFO NOLOGGING
    (AGT_ID                --协议编号
    ,LP_ID                 --法人编号
    ,INTNAL_CONT_ID        --内部合同编号
    ,CONT_ID               --合同编号
    ,LOAN_PROD_ID          --贷款产品编号
    ,CRDT_APPL_ID          --授信申请编号
    ,LOAN_APPL_ID          --贷款申请编号
    ,CUST_ID               --客户编号
    ,ACCT_ID               --账户编号
    ,CHN_ID                --渠道编号
    ,OPEN_ACCT_BANK_NAME   --开户银行名称
    ,CARD_NO               --卡号
    ,CUST_NAME             --客户名称
    ,ID_NO                 --身份证号码
    ,OPEN_ACCT_MOBILE_NO   --开户手机号码
    ,CONT_AMT              --合同金额
    ,CURR_CD               --币种代码
    ,EXEC_INT_RAT          --执行利率
    ,COMM_FEE_RAT          --手续费率
    ,SERV_FEE_RAT          --服务费率
    ,LOAN_TENOR            --贷款期限
    ,REPAY_DAY             --还款日
    ,EFFECT_DT             --生效日期
    ,INVALID_DT            --失效日期
    ,GRACE_DAYS            --宽限天数
    ,CIRCL_FLG             --循环标志
    ,TENOR_TYPE_CD         --期限类型代码
    ,REPAY_WAY_CD          --还款方式代码
    ,GUAR_WAY_CD           --担保方式代码
    ,LOAN_USAGE_CD         --贷款用途代码
    ,OVDUE_PAY_FLG         --滞纳金标志
    ,INT_RAT_TYPE_CD       --利率类型代码
    ,FARM_FLG              --农户标志
    ,REPAY_CARD_TYPE_CD    --还款卡类型代码
    ,CONT_STATUS_CD        --合同状态代码
    ,CREATE_TM             --创建时间
    ,CREATE_DT             --创建日期
    ,UPDATE_DT             --更新日期
    ,ETL_DT                --ETL处理日期
    ,ID_MARK               --增删标志
    ,SRC_TABLE_NAME        --源表名称
    ,JOB_CD                --任务编码
    )
  SELECT /*+PARALLEL*/
     AGT_ID                --协议编号
    ,LP_ID                 --法人编号
    ,INTNAL_CONT_ID        --内部合同编号
    ,CONT_ID               --合同编号
    ,LOAN_PROD_ID          --贷款产品编号
    ,CRDT_APPL_ID          --授信申请编号
    ,LOAN_APPL_ID          --贷款申请编号
    ,CUST_ID               --客户编号
    ,ACCT_ID               --账户编号
    ,CHN_ID                --渠道编号
    ,OPEN_ACCT_BANK_NAME   --开户银行名称
    ,CARD_NO               --卡号
    ,CUST_NAME             --客户名称
    ,ID_NO                 --身份证号码
    ,OPEN_ACCT_MOBILE_NO   --开户手机号码
    ,CONT_AMT              --合同金额
    ,CURR_CD               --币种代码
    ,EXEC_INT_RAT          --执行利率
    ,COMM_FEE_RAT          --手续费率
    ,SERV_FEE_RAT          --服务费率
    ,LOAN_TENOR            --贷款期限
    ,REPAY_DAY             --还款日
    ,EFFECT_DT             --生效日期
    ,INVALID_DT            --失效日期
    ,GRACE_DAYS            --宽限天数
    ,CIRCL_FLG             --循环标志
    ,TENOR_TYPE_CD         --期限类型代码
    ,REPAY_WAY_CD          --还款方式代码
    ,GUAR_WAY_CD           --担保方式代码
    ,LOAN_USAGE_CD         --贷款用途代码
    ,OVDUE_PAY_FLG         --滞纳金标志
    ,INT_RAT_TYPE_CD       --利率类型代码
    ,FARM_FLG              --农户标志
    ,REPAY_CARD_TYPE_CD    --还款卡类型代码
    ,CONT_STATUS_CD        --合同状态代码
    ,CREATE_TM             --创建时间
    ,CREATE_DT             --创建日期
    ,UPDATE_DT             --更新日期
    ,ETL_DT                --ETL处理日期
    ,ID_MARK               --增删标志
    ,SRC_TABLE_NAME        --源表名称
    ,JOB_CD                --任务编码
    FROM IML.V_AGT_WL_CONT_INFO   --网贷合同信息_视图
    WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_WL_CONT_INFO','', O_ERRCODE);

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

END ETL_O_IML_AGT_WL_CONT_INFO;
/

