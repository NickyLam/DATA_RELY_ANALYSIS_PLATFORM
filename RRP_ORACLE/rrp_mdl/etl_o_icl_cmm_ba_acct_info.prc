CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_BA_ACCT_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_BA_ACCT_INFO
  *  功能描述：银承账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BA_ACCT_INFO
  *  目标表： O_ICL_CMM_BA_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
        3    20260306  YJY      改为分区表并调整存储
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_BA_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_BA_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-银承账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BA_ACCT_INFO
  (   
        ETL_DT                      --数据日期
       ,LP_ID                       --法人编号
       ,ACCT_ID                     --账户编号
       ,BILL_NUM                    --票据号码
       ,ACPT_ORG_ID                 --承兑机构编号
       ,STL_ACCT_NUM                --结算账号
       ,SUBJ_ID                     --科目编号
       ,BILL_MED_CD                 --票据介质代码
       ,BILL_TYPE_CD                --票据类型代码
       ,MARGIN_ACCT_NUM             --保证金账号
       ,MARGIN_DEP_TERM             --保证金存期
       ,DRAW_DT                     --出票日期
       ,CLOSE_DT                    --关闭日期
       ,CLOSE_FLOW                  --关闭流水
       ,EXP_DT                      --到期日期
       ,BILL_STATUS                 --票据状态
       ,CLOSE_WAY                   --关闭方式
       ,PYMC_ACCT_NUM               --备款账号
       ,PYMC_DT                     --备款日期
       ,PYMC_FLOW                   --备款流水
       ,PYMC_WAY                    --备款方式
       ,ADVC_FLG                    --垫款标志
       ,ADVC_DUBIL_ID               --垫款借据编号
       ,ADVC_EXEC_INT_RAT           --垫款执行利率
       ,ADVC_INT_RAT_CU_RATIO       --垫款利率上浮比例
       ,INT_RAT_BASE_TYPE_CD        --利率基准类型代码
       ,FAC_VAL_CURR                --票面币种
       ,MARGIN_CURR                 --保证金币种
       ,MARGIN_RATIO                --保证金比例
       ,MARGIN_AMT                  --保证金金额
       ,ADVC_AMT                    --垫款金额
       ,COMM_FEE                    --手续费
       ,FAC_VAL_AMT                 --票面金额
       ,CURRT_BAL                   --当期余额
       ,CL_CURR_CURRT_BAL           --折本币当期余额
       ,EAR_D_BAL                   --日初余额
       ,EAR_M_BAL                   --月初余额
       ,EAR_S_BAL                   --季初余额
       ,EAR_Y_BAL                   --年初余额
       ,Y_ACM_BAL                   --年累计余额
       ,S_ACM_BAL                   --季累计余额
       ,M_ACM_BAL                   --月累计余额
       ,CL_CURR_EAR_D_BAL           --折本币日初余额
       ,CL_CURR_EAR_M_BAL           --折本币月初余额
       ,CL_CURR_EAR_S_BAL           --折本币季初余额
       ,CL_CURR_EAR_Y_BAL           --折本币年初余额
       ,CL_CURR_Y_ACM_BAL           --折本币年累计余额
       ,CL_CURR_EAR_D_Y_ACM_BAL     --折本币日初年累计余额
       ,CL_CURR_EAR_M_Y_ACM_BAL     --折本币月初年累计余额
       ,CL_CURR_EAR_S_Y_ACM_BAL     --折本币季初年累计余额
       ,CL_CURR_EAR_Y_Y_ACM_BAL     --折本币年初年累计余额
       ,CL_CURR_S_ACM_BAL           --折本币季累计余额
       ,CL_CURR_EAR_D_S_ACM_BAL     --折本币日初季累计余额
       ,CL_CURR_EAR_S_S_ACM_BAL     --折本币季初季累计余额
       ,CL_CURR_EAR_Y_S_ACM_BAL     --折本币年初季累计余额
       ,CL_CURR_M_ACM_BAL           --折本币月累计余额
       ,CL_CURR_EAR_D_M_ACM_BAL     --折本币日初月累计余额
       ,CL_CURR_EAR_M_M_ACM_BAL     --折本币月初月累计余额
       ,CL_CURR_EAR_Y_M_ACM_BAL     --折本币年初月累计余额
       ,Y_AVG_BAL                   --年日均余额
       ,Q_AVG_BAL                   --季日均余额
       ,M_AVG_BAL                   --月日均余额
       ,CL_CURR_Y_AVG_BAL           --折本币年日均余额
       ,CL_CURR_Q_AVG_BAL           --折本币季日均余额
       ,CL_CURR_M_AVG_BAL           --折本币月日均余额
       ,JOB_CD                      --任务代码
       ,BILL_ENTRY_ID               --票据记账编号
       ,STD_PROD_ID                 --标准产品编号
   )
  SELECT 
       ETL_DT                      --数据日期
       ,LP_ID                       --法人编号
       ,ACCT_ID                     --账户编号
       ,BILL_NUM                    --票据号码
       ,ACPT_ORG_ID                 --承兑机构编号
       ,STL_ACCT_NUM                --结算账号
       ,SUBJ_ID                     --科目编号
       ,BILL_MED_CD                 --票据介质代码
       ,BILL_TYPE_CD                --票据类型代码
       ,MARGIN_ACCT_NUM             --保证金账号
       ,MARGIN_DEP_TERM             --保证金存期
       ,DRAW_DT                     --出票日期
       ,CLOSE_DT                    --关闭日期
       ,CLOSE_FLOW                  --关闭流水
       ,EXP_DT                      --到期日期
       ,BILL_STATUS                 --票据状态
       ,CLOSE_WAY                   --关闭方式
       ,PYMC_ACCT_NUM               --备款账号
       ,PYMC_DT                     --备款日期
       ,PYMC_FLOW                   --备款流水
       ,PYMC_WAY                    --备款方式
       ,ADVC_FLG                    --垫款标志
       ,ADVC_DUBIL_ID               --垫款借据编号
       ,ADVC_EXEC_INT_RAT           --垫款执行利率
       ,ADVC_INT_RAT_CU_RATIO       --垫款利率上浮比例
       ,INT_RAT_BASE_TYPE_CD        --利率基准类型代码
       ,FAC_VAL_CURR                --票面币种
       ,MARGIN_CURR                 --保证金币种
       ,MARGIN_RATIO                --保证金比例
       ,MARGIN_AMT                  --保证金金额
       ,ADVC_AMT                    --垫款金额
       ,COMM_FEE                    --手续费
       ,FAC_VAL_AMT                 --票面金额
       ,CURRT_BAL                   --当期余额
       ,CL_CURR_CURRT_BAL           --折本币当期余额
       ,EAR_D_BAL                   --日初余额
       ,EAR_M_BAL                   --月初余额
       ,EAR_S_BAL                   --季初余额
       ,EAR_Y_BAL                   --年初余额
       ,Y_ACM_BAL                   --年累计余额
       ,S_ACM_BAL                   --季累计余额
       ,M_ACM_BAL                   --月累计余额
       ,CL_CURR_EAR_D_BAL           --折本币日初余额
       ,CL_CURR_EAR_M_BAL           --折本币月初余额
       ,CL_CURR_EAR_S_BAL           --折本币季初余额
       ,CL_CURR_EAR_Y_BAL           --折本币年初余额
       ,CL_CURR_Y_ACM_BAL           --折本币年累计余额
       ,CL_CURR_EAR_D_Y_ACM_BAL     --折本币日初年累计余额
       ,CL_CURR_EAR_M_Y_ACM_BAL     --折本币月初年累计余额
       ,CL_CURR_EAR_S_Y_ACM_BAL     --折本币季初年累计余额
       ,CL_CURR_EAR_Y_Y_ACM_BAL     --折本币年初年累计余额
       ,CL_CURR_S_ACM_BAL           --折本币季累计余额
       ,CL_CURR_EAR_D_S_ACM_BAL     --折本币日初季累计余额
       ,CL_CURR_EAR_S_S_ACM_BAL     --折本币季初季累计余额
       ,CL_CURR_EAR_Y_S_ACM_BAL     --折本币年初季累计余额
       ,CL_CURR_M_ACM_BAL           --折本币月累计余额
       ,CL_CURR_EAR_D_M_ACM_BAL     --折本币日初月累计余额
       ,CL_CURR_EAR_M_M_ACM_BAL     --折本币月初月累计余额
       ,CL_CURR_EAR_Y_M_ACM_BAL     --折本币年初月累计余额
       ,Y_AVG_BAL                   --年日均余额
       ,Q_AVG_BAL                   --季日均余额
       ,M_AVG_BAL                   --月日均余额
       ,CL_CURR_Y_AVG_BAL           --折本币年日均余额
       ,CL_CURR_Q_AVG_BAL           --折本币季日均余额
       ,CL_CURR_M_AVG_BAL           --折本币月日均余额
       ,JOB_CD                      --任务代码
       ,BILL_ENTRY_ID               --票据记账编号
       ,STD_PROD_ID                 --标准产品编号
    FROM ICL.V_CMM_BA_ACCT_INFO --视图-银承账户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_BA_ACCT_INFO;
/

