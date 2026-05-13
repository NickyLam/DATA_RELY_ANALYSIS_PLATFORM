CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_RENEW_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                            O_ERRCODE  OUT VARCHAR2 --错误代码
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_RENEW_INFO_H
  *  功能描述：贷款展期信息历史
  *  创建日期：20240506
  *  开发人员：YUJINGYI
  *  来源表：
  *  目标表： O_IML_AGT_LOAN_RENEW_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240506  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_RENEW_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_RENEW_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款展期信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_LOAN_RENEW_INFO_H
    (AGT_ID                   --协议编号
    ,LP_ID                    --法人编号
    ,RENEW_FLOW_NUM           --展期流水号
    ,PRECON_ID                --预约编号
    ,RELA_DUBIL_ID            --关联借据编号
    ,OUT_ACCT_FLOW_NUM        --出账流水号
    ,RENEW_STATUS_CD          --展期状态代码
    ,HAPP_DT                  --发生日期
    ,INIT_INT_RAT             --原利率
    ,INIT_EXP_DT              --原到期日期
    ,RENEW_AMT                --展期金额
    ,B_RENEW_AMT              --展期前金额
    ,RENEW_YEAR_TENOR         --展期年期限
    ,RENEW_MON_TENOR          --展期月期限
    ,RENEW_DAY_TENOR          --展期日期限
    ,A_RENEW_INT_RAT          --展期后利率
    ,A_RENEW_EXP_DT           --展期后到期日期
    ,ENTR_PAY_DT              --受托支付日期
    ,ORG_ID                   --机构编号
    ,OPER_TELLER_ID           --操作柜员编号
    ,UPDATE_FLG               --更新标志
    ,REMARK                   --备注
    ,START_DT                 --开始日期
    ,END_DT                   --结束日期
    ,ID_MARK                  --删除标识
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    )
  SELECT /*+PARALLEL*/
         AGT_ID                   --协议编号
        ,LP_ID                    --法人编号
        ,RENEW_FLOW_NUM           --展期流水号
        ,PRECON_ID                --预约编号
        ,RELA_DUBIL_ID            --关联借据编号
        ,OUT_ACCT_FLOW_NUM        --出账流水号
        ,RENEW_STATUS_CD          --展期状态代码
        ,HAPP_DT                  --发生日期
        ,INIT_INT_RAT             --原利率
        ,INIT_EXP_DT              --原到期日期
        ,RENEW_AMT                --展期金额
        ,B_RENEW_AMT              --展期前金额
        ,RENEW_YEAR_TENOR         --展期年期限
        ,RENEW_MON_TENOR          --展期月期限
        ,RENEW_DAY_TENOR          --展期日期限
        ,A_RENEW_INT_RAT          --展期后利率
        ,A_RENEW_EXP_DT           --展期后到期日期
        ,ENTR_PAY_DT              --受托支付日期
        ,ORG_ID                   --机构编号
        ,OPER_TELLER_ID           --操作柜员编号
        ,UPDATE_FLG               --更新标志
        ,REMARK                   --备注
        ,START_DT                 --开始日期
        ,END_DT                   --结束日期
        ,ID_MARK                  --删除标识
        ,SRC_TABLE_NAME           --源表名称
        ,JOB_CD                   --任务代码
        ,ETL_TIMESTAMP            --数据处理时间
    FROM IML.V_AGT_LOAN_RENEW_INFO_H   --贷款展期信息历史--视图
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_RENEW_INFO_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_RENEW_INFO_H;
/

