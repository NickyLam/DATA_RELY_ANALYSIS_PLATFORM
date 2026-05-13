CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_RETL_CONT_CSNER_RELA_H(I_P_DATE IN INTEGER, --跑批日期
                                                                         O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_RETL_CONT_CSNER_RELA_H
  *  功能描述：零售贷款合同与委托人关系历史
  *  创建日期：20220318
  *  开发人员：
  *  来源表：
  *  目标表： O_IML_AGT_RETL_CONT_CSNER_RELA_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_RETL_CONT_CSNER_RELA_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_RETL_CONT_CSNER_RELA_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款合同与委托人关系历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_RETL_CONT_CSNER_RELA_H NOLOGGING
    (AGT_ID                        --协议编号
    ,LP_ID                         --法人编号
    ,BUS_FLOW_NUM                  --业务流水号
    ,CONT_ID                       --合同编号
    ,BRWER_ID                      --借款人编号
    ,BRWER_NAME                    --借款人名称
    ,CSNER_ID                      --委托人编号
    ,CSNER_TYPE_CD                 --委托人类型代码
    ,CONTRI_ACCT_ID                --出资账户编号
    ,CONTRI_ACCT_NAME              --出资账户名称
    ,CONTRI_ACCT_PT_TYPE_CD        --出资账户支付工具类型代码
    ,PRIC_ENTER_ACCT_ID            --本金入账账户编号
    ,PRIC_ENTER_ACCT_NAME          --本金入账账户名称
    ,PRIC_ACCT_PT_TYPE_CD          --本金账户支付工具类型代码
    ,INT_ENTER_ACCT_ID             --利息入账账户编号
    ,INT_ENTER_ACCT_NAME           --利息入账账户名称
    ,INT_ACCT_PT_TYPE_CD           --利息账户支付工具类型代码
    ,COMM_FEE_COLL_ACCT_NUM        --手续费收取账号
    ,COMM_FEE_COLL_ACCT_NAME       --手续费收取账号名称
    ,COMM_FEE_ACCT_PT_TYPE_CD      --手续费账户支付工具类型代码
    ,STAMP_TAX_ACCT_NUM            --印花税扣税账号
    ,STAMP_TAX_ACCT_NAME           --印花税扣税账号名称
    ,STAMP_TAX_ACCT_PT_TYPE_CD     --印花税账号支付工具类型代码
    ,ENTR_DEP_ACCT_ID              --委托存款账户编号
    ,ENTR_DEP_ACCT_NAME            --委托存款账户名称
    ,ENTR_DEP_ACCT_PT_TYPE_CD      --委托存款账户支付工具类型代码
    ,ENTR_DEP_ACCT_OPEN_BANK_NUM   --委托存款账户行内开户行号
    ,ENTR_DEP_ACCT_OPEN_BANK_NAME  --委托存款账户行内开户行名称
    ,CSNER_NAME                    --委托人姓名
    ,START_DT                      --开始时间
    ,END_DT                        --结束时间
    ,ID_MARK                       --增删标志
    ,SRC_TABLE_NAME                --源表名称
    ,JOB_CD                        --任务编码
    )
  SELECT /*+PARALLEL*/
         AGT_ID                        --协议编号
        ,LP_ID                         --法人编号
        ,BUS_FLOW_NUM                  --业务流水号
        ,CONT_ID                       --合同编号
        ,BRWER_ID                      --借款人编号
        ,BRWER_NAME                    --借款人名称
        ,CSNER_ID                      --委托人编号
        ,CSNER_TYPE_CD                 --委托人类型代码
        ,CONTRI_ACCT_ID                --出资账户编号
        ,CONTRI_ACCT_NAME              --出资账户名称
        ,CONTRI_ACCT_PT_TYPE_CD        --出资账户支付工具类型代码
        ,PRIC_ENTER_ACCT_ID            --本金入账账户编号
        ,PRIC_ENTER_ACCT_NAME          --本金入账账户名称
        ,PRIC_ACCT_PT_TYPE_CD          --本金账户支付工具类型代码
        ,INT_ENTER_ACCT_ID             --利息入账账户编号
        ,INT_ENTER_ACCT_NAME           --利息入账账户名称
        ,INT_ACCT_PT_TYPE_CD           --利息账户支付工具类型代码
        ,COMM_FEE_COLL_ACCT_NUM        --手续费收取账号
        ,COMM_FEE_COLL_ACCT_NAME       --手续费收取账号名称
        ,COMM_FEE_ACCT_PT_TYPE_CD      --手续费账户支付工具类型代码
        ,STAMP_TAX_ACCT_NUM            --印花税扣税账号
        ,STAMP_TAX_ACCT_NAME           --印花税扣税账号名称
        ,STAMP_TAX_ACCT_PT_TYPE_CD     --印花税账号支付工具类型代码
        ,ENTR_DEP_ACCT_ID              --委托存款账户编号
        ,ENTR_DEP_ACCT_NAME            --委托存款账户名称
        ,ENTR_DEP_ACCT_PT_TYPE_CD      --委托存款账户支付工具类型代码
        ,ENTR_DEP_ACCT_OPEN_BANK_NUM   --委托存款账户行内开户行号
        ,ENTR_DEP_ACCT_OPEN_BANK_NAME  --委托存款账户行内开户行名称
        ,CSNER_NAME                    --委托人姓名
        ,START_DT                      --开始时间
        ,END_DT                        --结束时间
        ,ID_MARK                       --增删标志
        ,SRC_TABLE_NAME                --源表名称
        ,JOB_CD                        --任务编码
    FROM IML.V_AGT_RETL_CONT_CSNER_RELA_H       --零售贷款合同与委托人关系历史_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT>TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_RETL_CONT_CSNER_RELA_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_RETL_CONT_CSNER_RELA_H;
/

