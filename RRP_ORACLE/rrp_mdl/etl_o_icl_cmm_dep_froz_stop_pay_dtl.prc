CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL(I_P_DATE IN INTEGER,
                                                                O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL
  *  功能描述：存款账户冻结止付明细，将数据从视图落地
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：  ICL.V_CMM_DEP_FROZ_STOP_PAY_DTL
  *  目标表：  O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
                2    20220615  梅炜      修改参数
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/
    
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-存款账户冻结止付明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL
    (ETL_DT                            --数据日期
    ,LP_ID                             --法人编号
    ,FROZ_STOP_PAY_DT                  --冻结止付日期
    ,FROZ_STOP_PAY_TIMESTAMP           --冻结止付时间戳
    ,FROZ_STOP_PAY_FLOW_NUM            --冻结止付流水号
    ,JOB_CD                            --任务代码
    ,SEQ_NUM                           --顺序号
    ,ETL_TIMESTAMP                     --数据处理时间
    ,TRAN_FLOW_NUM                     --交易流水号
    ,ACCT_ID                           --账户编号
    ,SUB_ACCT_ID                       --子户编号
    ,DEP_SUB_ACCT_ID                   --存款分户编号
    ,OLD_SUB_ACCT_ID                   --旧子户编号
    ,CUST_ID                           --客户编号
    ,CUST_NAME                         --客户名称
    ,CERT_ID                           --证明书编号
    ,PROOF_CATE_CD                     --证明类别代码
    ,STATUS_CD                         --状态代码
    ,CHN_CD                            --渠道代码
    ,FROZ_STOP_PAY_BUS_WAY_CD          --冻结止付业务方式代码
    ,FROZ_STOP_PAY_CATE_CD             --冻结止付类别代码
    ,OPERR_ID                          --操作员编号
    ,APV_TELLER_ID                     --审批柜员编号
    ,AUTH_TELLER_ID                    --授权柜员编号
    ,TRAN_ORG_ID                       --交易机构编号
    ,APPL_FROZ_AMT                     --申请冻结金额
    ,SURP_FROZ_AMT                     --剩余冻结金额
    ,FROZ_END_DT                       --冻结截至日期
    ,FROZ_RS                           --冻结原因
    ,EXEC_ORG_NAME                     --执行机关名称
    ,EXEC_CERT_CD_1                    --执行证件代码1
    ,EXEC_ID_1                         --执行编号1
    ,EXEC_CERT_CD_2                    --执行证件代码2
    ,EXEC_ID_2                         --执行编号2
    ,EXEC_PS_NAME_1                    --执行人名称1
    ,EXEC_PS_NAME_2                    --执行人名称2
    ,JUT_FROZ_STOP_PAY_FLG             --司法冻结止付标志
    ,JUT_FROZ_STOP_PAY_TYPE_CD         --司法冻结止付类型代码
    ,INV_CTRL_SYS_ID                   --查控系统编号
    ,INV_CTRL_SYS_NAME                 --查控系统名称
    ,INV_CTRL_CHAR                     --查控性质
    )
  SELECT 
     ETL_DT                            --数据日期
    ,LP_ID                             --法人编号
    ,FROZ_STOP_PAY_DT                  --冻结止付日期
    ,FROZ_STOP_PAY_TIMESTAMP           --冻结止付时间戳
    ,FROZ_STOP_PAY_FLOW_NUM            --冻结止付流水号
    ,JOB_CD                            --任务代码
    ,SEQ_NUM                           --顺序号
    ,ETL_TIMESTAMP                     --数据处理时间
    ,TRAN_FLOW_NUM                     --交易流水号
    ,ACCT_ID                           --账户编号
    ,SUB_ACCT_ID                       --子户编号
    ,DEP_SUB_ACCT_ID                   --存款分户编号
    ,OLD_SUB_ACCT_ID                   --旧子户编号
    ,CUST_ID                           --客户编号
    ,CUST_NAME                         --客户名称
    ,CERT_ID                           --证明书编号
    ,PROOF_CATE_CD                     --证明类别代码
    ,STATUS_CD                         --状态代码
    ,CHN_CD                            --渠道代码
    ,FROZ_STOP_PAY_BUS_WAY_CD          --冻结止付业务方式代码
    ,FROZ_STOP_PAY_CATE_CD             --冻结止付类别代码
    ,OPERR_ID                          --操作员编号
    ,APV_TELLER_ID                     --审批柜员编号
    ,AUTH_TELLER_ID                    --授权柜员编号
    ,TRAN_ORG_ID                       --交易机构编号
    ,APPL_FROZ_AMT                     --申请冻结金额
    ,SURP_FROZ_AMT                     --剩余冻结金额
    ,FROZ_END_DT                       --冻结截至日期
    ,FROZ_RS                           --冻结原因
    ,EXEC_ORG_NAME                     --执行机关名称
    ,EXEC_CERT_CD_1                    --执行证件代码1
    ,EXEC_ID_1                         --执行编号1
    ,EXEC_CERT_CD_2                    --执行证件代码2
    ,EXEC_ID_2                         --执行编号2
    ,EXEC_PS_NAME_1                    --执行人名称1
    ,EXEC_PS_NAME_2                    --执行人名称2
    ,JUT_FROZ_STOP_PAY_FLG             --司法冻结止付标志
    ,JUT_FROZ_STOP_PAY_TYPE_CD         --司法冻结止付类型代码
    ,INV_CTRL_SYS_ID                   --查控系统编号
    ,INV_CTRL_SYS_NAME                 --查控系统名称
    ,INV_CTRL_CHAR                     --查控性质
    FROM ICL.V_CMM_DEP_FROZ_STOP_PAY_DTL
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL', '', O_ERRCODE);

  --插入跑批完成记录--
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

END ETL_O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL;
/

