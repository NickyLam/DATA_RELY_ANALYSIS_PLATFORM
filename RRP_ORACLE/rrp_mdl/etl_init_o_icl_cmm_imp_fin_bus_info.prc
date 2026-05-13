CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_IMP_FIN_BUS_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_IMP_FIN_BUS_INFO
  *  功能描述：进口融资业务信息
  *  创建日期：20230104
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_ICL_CMM_IMP_FIN_BUS_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230104  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_IMP_FIN_BUS_INFO'; -- 程序名称
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
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_IMP_FIN_BUS_INFO ';
  /*-- EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_IMP_FIN_BUS_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
 /* V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_IMP_FIN_BUS_INFO', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-进口融资业务信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IMP_FIN_BUS_INFO
  (
                ETL_DT  --数据日期
                ,LP_ID  --法人编号
                ,AGT_ID  --协议编号
                ,BUS_ID  --业务编号
                ,DUBIL_ID  --借据编号
                ,TRUST_NAME  --信托收据名称
                ,FIN_ACCT_ID  --融资账户编号
                ,SUBJ_ID  --科目编号
                ,STD_PROD_ID  --标准产品编号
                ,OPER_ORG_ID  --经办机构编号
                ,BELONG_ORG_ID  --所属机构编号
                ,FIN_STATUS_CD  --融资状态代码
                ,TRUST_CREATE_DT  --信托收据创建日期
                ,TRUST_OPEN_DT  --信托收据开立日期
                ,TRUST_EXP_DT  --信托收据到期日期
                ,TRUST_EFFECT_DT  --信托收据生效日期
                ,TRUST_REVO_DT  --信托收据撤销日期
                ,ACTL_REPAY_DT  --实际还款日期
                ,NEGOT_DAYS  --押汇天数
                ,ACTL_NEGOT_DAYS  --实际押汇天数
                ,OVDUE_FLG  --逾期标志
                ,EXEC_INT_RAT  --执行利率
                ,OVDUE_INT_RAT  --逾期利率
                ,INT_ACCR_BASE_CD  --计息基准代码
                ,INT_SET_WAY_CD  --结息方式代码
                ,INT_RAT_ADJ_PED_CD  --利率调整周期代码
                ,PAYFAN_INT_AMT  --代付利息金额
                ,PAYFAN_PNLT_INT_RAT  --代付罚息利率
                ,PAYFAN_COMM_FEE_AMT  --代付手续费金额
                ,THS_TM_PAY_AMT  --本次付款金额
                ,CURR_CD  --币种代码
                ,PAYBL_PRIC_BAL  --应付本金余额
                ,JOB_CD  --任务代码
                ,ETL_TIMESTAMP  --数据处理时间

     )
     SELECT
                ETL_DT  --数据日期
                ,LP_ID  --法人编号
                ,AGT_ID  --协议编号
                ,BUS_ID  --业务编号
                ,DUBIL_ID  --借据编号
                ,TRUST_NAME  --信托收据名称
                ,FIN_ACCT_ID  --融资账户编号
                ,SUBJ_ID  --科目编号
                ,STD_PROD_ID  --标准产品编号
                ,OPER_ORG_ID  --经办机构编号
                ,BELONG_ORG_ID  --所属机构编号
                ,FIN_STATUS_CD  --融资状态代码
                ,TRUST_CREATE_DT  --信托收据创建日期
                ,TRUST_OPEN_DT  --信托收据开立日期
                ,TRUST_EXP_DT  --信托收据到期日期
                ,TRUST_EFFECT_DT  --信托收据生效日期
                ,TRUST_REVO_DT  --信托收据撤销日期
                ,ACTL_REPAY_DT  --实际还款日期
                ,NEGOT_DAYS  --押汇天数
                ,ACTL_NEGOT_DAYS  --实际押汇天数
                ,OVDUE_FLG  --逾期标志
                ,EXEC_INT_RAT  --执行利率
                ,OVDUE_INT_RAT  --逾期利率
                ,INT_ACCR_BASE_CD  --计息基准代码
                ,INT_SET_WAY_CD  --结息方式代码
                ,INT_RAT_ADJ_PED_CD  --利率调整周期代码
                ,PAYFAN_INT_AMT  --代付利息金额
                ,PAYFAN_PNLT_INT_RAT  --代付罚息利率
                ,PAYFAN_COMM_FEE_AMT  --代付手续费金额
                ,THS_TM_PAY_AMT  --本次付款金额
                ,CURR_CD  --币种代码
                ,PAYBL_PRIC_BAL  --应付本金余额
                ,JOB_CD  --任务代码
                ,ETL_TIMESTAMP  --数据处理时间
    FROM ICL.V_CMM_IMP_FIN_BUS_INFO
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

  END ETL_INIT_O_ICL_CMM_IMP_FIN_BUS_INFO;
/

