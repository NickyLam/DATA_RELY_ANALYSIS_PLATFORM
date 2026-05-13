CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_LOG_ACCT_INFO(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_LOG_ACCT_INFO
  *  功能描述：保函账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_LOG_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20241219  YJY      新增交易完成时间
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_ICL_CMM_LOG_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-保函账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_LOG_ACCT_INFO
    (ETL_DT                        --数据日期
    ,LP_ID                         --法人编号
    ,ACCT_ID                       --账户编号
    ,BUS_ID                        --业务编号
    ,LOG_CONT_ID                   --保函合同编号
    ,LOG_ACCT_NUM                  --保函账号
    ,STD_PROD_ID                   --标准产品编号
    ,OUT_ACCT_ACCT_NUM             --出账账号
    ,STL_ACCT_NUM                  --结算账号
    ,CRDT_CONTR_NO                 --信贷合同号
    ,RECVBL_NUM                    --收款账号
    ,SUBJ_CD                       --科目代码
    ,LOG_KIND_CD                   --保函种类代码
    ,FIN_LOG_FLG                   --融资性保函标志
    ,OVERS_LOG_FLG                 --境外保函标志
    ,ADVC_FLG                      --垫款标志
    ,ADVC_DUBIL_ID                 --垫款借据编号
    ,LOG_STATUS                    --保函状态
    ,WRTOFF_WAY                    --注销方式
    ,GUAR_WAY_CD                   --担保方式代码
    ,TENOR                         --期限
    ,BENEFC_NAME                   --受益人名称
    ,BENEFC_ACCT_NUM               --受益人账号
    ,BENEFC_OPEN_BANK_NAME         --受益人开户行名称
    ,GUAR_ORG_ID                   --担保机构编号
    ,ACCT_INSTIT_ID                --账务机构编号
    ,MGMT_ORG_ID                   --管理机构编号
    ,OPER_ORG_ID                   --经办机构编号
    ,OPEN_DT                       --开立日期
    ,WRTOFF_DT                     --注销日期
    ,START_DT                      --起始日期
    ,EXP_DT                        --到期日期
    ,OPEN_FLOW                     --开立流水
    ,WRTOFF_FLOW                   --注销流水
    ,CURR_CD                       --币种代码
    ,NOMAL_INT_RAT                 --正常利率
    ,OVDUE_INT_RAT                 --逾期利率
    ,ADVC_INT_RAT                  --垫款利率
    ,COMM_FEE_RAT                  --手续费费率
    ,COMM_FEE_AMT                  --手续费金额
    ,COMPENS_AMT                   --赔付金额
    ,ADVC_AMT                      --垫款金额
    ,MARGIN_ACCT_NUM               --保证金账号
    ,MARGIN_CURR                   --保证金币种
    ,MARGIN_RATIO                  --保证金比例
    ,MARGIN_AMT                    --保证金金额
    ,LOG_AMT                       --保函金额
    ,CURRT_BAL                     --当期余额
    ,CL_CURR_CURRT_BAL             --折本币当期余额
    ,EAR_D_BAL                     --日初余额
    ,EAR_M_BAL                     --月初余额
    ,EAR_S_BAL                     --季初余额
    ,EAR_Y_BAL                     --年初余额
    ,Y_ACM_BAL                     --年累计余额
    ,S_ACM_BAL                     --季累计余额
    ,M_ACM_BAL                     --月累计余额
    ,CL_CURR_EAR_D_BAL             --折本币日初余额
    ,CL_CURR_EAR_M_BAL             --折本币月初余额
    ,CL_CURR_EAR_S_BAL             --折本币季初余额
    ,CL_CURR_EAR_Y_BAL             --折本币年初余额
    ,CL_CURR_Y_ACM_BAL             --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL       --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL       --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL       --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL       --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL             --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL       --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL       --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL       --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL             --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL       --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL       --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL       --折本币年初月累计余额
    ,Y_AVG_BAL                     --年日均余额
    ,Q_AVG_BAL                     --季日均余额
    ,M_AVG_BAL                     --月日均余额
    ,CL_CURR_Y_AVG_BAL             --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL             --折本币季日均余额
    ,CL_CURR_M_AVG_BAL             --折本币月日均余额
    ,MARGIN_SUB_ACCT_NUM           --保证金子户号
    ,JOB_CD                        --任务代码
    ,BENEFC_CTY_CD                 --受益人国家代码
    ,TRAN_CMPLT_TM                 --交易完成时间  ADD BY YJY 20241219
    )
  SELECT 
     ETL_DT                        --数据日期
    ,LP_ID                         --法人编号
    ,ACCT_ID                       --账户编号
    ,BUS_ID                        --业务编号
    ,LOG_CONT_ID                   --保函合同编号
    ,LOG_ACCT_NUM                  --保函账号
    ,STD_PROD_ID                   --标准产品编号
    ,OUT_ACCT_ACCT_NUM             --出账账号
    ,STL_ACCT_NUM                  --结算账号
    ,CRDT_CONTR_NO                 --信贷合同号
    ,RECVBL_NUM                    --收款账号
    ,SUBJ_CD                       --科目代码
    ,LOG_KIND_CD                   --保函种类代码
    ,FIN_LOG_FLG                   --融资性保函标志
    ,OVERS_LOG_FLG                 --境外保函标志
    ,ADVC_FLG                      --垫款标志
    ,ADVC_DUBIL_ID                 --垫款借据编号
    ,LOG_STATUS                    --保函状态
    ,WRTOFF_WAY                    --注销方式
    ,GUAR_WAY_CD                   --担保方式代码
    ,TENOR                         --期限
    ,BENEFC_NAME                   --受益人名称
    ,BENEFC_ACCT_NUM               --受益人账号
    ,BENEFC_OPEN_BANK_NAME         --受益人开户行名称
    ,GUAR_ORG_ID                   --担保机构编号
    ,ACCT_INSTIT_ID                --账务机构编号
    ,MGMT_ORG_ID                   --管理机构编号
    ,OPER_ORG_ID                   --经办机构编号
    ,OPEN_DT                       --开立日期
    ,WRTOFF_DT                     --注销日期
    ,START_DT                      --起始日期
    ,EXP_DT                        --到期日期
    ,OPEN_FLOW                     --开立流水
    ,WRTOFF_FLOW                   --注销流水
    ,CURR_CD                       --币种代码
    ,NOMAL_INT_RAT                 --正常利率
    ,OVDUE_INT_RAT                 --逾期利率
    ,ADVC_INT_RAT                  --垫款利率
    ,COMM_FEE_RAT                  --手续费费率
    ,COMM_FEE_AMT                  --手续费金额
    ,COMPENS_AMT                   --赔付金额
    ,ADVC_AMT                      --垫款金额
    ,MARGIN_ACCT_NUM               --保证金账号
    ,MARGIN_CURR                   --保证金币种
    ,MARGIN_RATIO                  --保证金比例
    ,MARGIN_AMT                    --保证金金额
    ,LOG_AMT                       --保函金额
    ,CURRT_BAL                     --当期余额
    ,CL_CURR_CURRT_BAL             --折本币当期余额
    ,EAR_D_BAL                     --日初余额
    ,EAR_M_BAL                     --月初余额
    ,EAR_S_BAL                     --季初余额
    ,EAR_Y_BAL                     --年初余额
    ,Y_ACM_BAL                     --年累计余额
    ,S_ACM_BAL                     --季累计余额
    ,M_ACM_BAL                     --月累计余额
    ,CL_CURR_EAR_D_BAL             --折本币日初余额
    ,CL_CURR_EAR_M_BAL             --折本币月初余额
    ,CL_CURR_EAR_S_BAL             --折本币季初余额
    ,CL_CURR_EAR_Y_BAL             --折本币年初余额
    ,CL_CURR_Y_ACM_BAL             --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL       --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL       --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL       --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL       --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL             --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL       --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL       --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL       --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL             --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL       --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL       --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL       --折本币年初月累计余额
    ,Y_AVG_BAL                     --年日均余额
    ,Q_AVG_BAL                     --季日均余额
    ,M_AVG_BAL                     --月日均余额
    ,CL_CURR_Y_AVG_BAL             --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL             --折本币季日均余额
    ,CL_CURR_M_AVG_BAL             --折本币月日均余额
    ,MARGIN_SUB_ACCT_NUM           --保证金子户号
    ,JOB_CD                        --任务代码
    ,BENEFC_CTY_CD                 --受益人国家代码
    ,TRAN_CMPLT_TM                 --交易完成时间  ADD BY YJY 20241219
    FROM ICL.V_CMM_LOG_ACCT_INFO  --视图-保函账户信息
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

END ETL_O_ICL_CMM_LOG_ACCT_INFO;
/

