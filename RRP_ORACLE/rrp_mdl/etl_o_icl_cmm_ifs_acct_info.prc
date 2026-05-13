CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IFS_ACCT_INFO(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_IFS_ACCT_INFO
  *  功能描述：联合存款分户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_IFS_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  --V_TAB_NAME  VARCHAR2(100):= 'O_ICL_CMM_IFS_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_IFS_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-联合存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO
    (ETL_DT                            --数据日期
    ,LP_ID                             --法人编号
    ,CUST_ACCT_SUB_ACCT_NUM            --客户账户子户号
    ,CUST_ACCT_ID                      --客户账户编号
    ,ACCT_NAME                         --账户名称
    ,CUST_ID                           --客户编号
    ,STD_PROD_ID                       --标准产品编号
    ,PROD_ID                           --产品编号
    ,BIND_WEBANK_CARD_NO               --绑定微众银行卡号
    ,SUBJ_ID                           --科目编号
    ,CUST_TYPE_CD                      --客户类型代码
    ,EXT_PROD_ID                       --外部产品编号
    ,DEP_ACCT_STATUS_CD                --存款账户状态代码
    ,ACPT_PAY_STATUS_CD                --收付状态代码
    ,FROZ_STATUS_CD                    --冻结状态代码
    ,STOP_PAY_STATUS_CD                --止付状态代码
    ,DEP_TERM                          --存期
    ,SAV_TYPE_CD                       --储种代码
    ,EXEC_INT_RAT_CATE_CD              --执行利率类别代码
    ,PA_EXT_INT_RAT_CATE_CD            --部提利率类别代码
    ,OVDUE_INT_RAT_CATE_CD             --逾期利率类别代码
    ,BASE_RAT_TYPE_CD                  --基准利率类型代码
    ,INT_SET_WAY_CD                    --结息方式代码
    ,INT_ACCR_WAY_CD                   --计息方式代码
    ,INT_ACCR_BASE_CD                  --计息基准代码
    ,CORP_ACCT_FLG                     --对公账户标志
    ,RC_FLG                            --定活标志
    ,WEB_DEP_FLG                       --网络存款标志
    ,INT_ACCR_FLG                      --计息标志
    ,PART_DRAW_CNT                     --部分提取次数
    ,ACCT_INSTIT_ID                    --账务机构编号
    ,OPEN_ACCT_ORG_ID                  --开户机构编号
    ,OPEN_ACCT_TELLER_ID               --开户柜员编号
    ,OPEN_ACCT_FLOW_NUM                --开户流水号
    ,OPEN_ACCT_CHN_CD                  --开户渠道代码
    ,OPEN_ACCT_DT                      --开户日期
    ,OPEN_ACCT_TM                      --开户时间
    ,CLOSE_ACCT_ORG_ID                 --销户机构编号
    ,CLOS_ACCT_TELLER_ID               --销户柜员编号
    ,CLOS_ACCT_FLOW_NUM                --销户流水号
    ,CLOS_ACCT_DT                      --销户日期
    ,CLOS_ACCT_TM                      --销户时间
    ,ACCT_DT                           --账务日期
    ,VALUE_DT                          --起息日期
    ,EXP_DT                            --到期日期
    ,FINAL_ACTIV_ACCT_DT               --最后动户日期
    ,LAST_INT_SET_DT                   --上次结息日期
    ,NEXT_INT_SET_DT                   --下次结息日期
    ,FIR_VALUE_DT                      --首次起息日期
    ,BASE_RAT                          --基准利率
    ,EXEC_INT_RAT                      --执行利率
    ,INT_RAT_FLO_VAL                   --利率浮动值
    ,CURR_CD                           --币种代码
    ,TD_ACRU_INT                       --当日应计利息
    ,CURRT_ACRU_INT                    --当期应计利息
    ,CURRT_BAL                         --当期余额
    ,FROZ_AMT                          --冻结金额
    ,AVAL_BAL                          --可用余额
    ,STOP_PAY_AMT                      --止付金额
    ,CL_CURR_CURRT_BAL                 --折本币当期余额
    ,EAR_D_BAL                         --日初余额
    ,EAR_M_BAL                         --月初余额
    ,EAR_S_BAL                         --季初余额
    ,EAR_Y_BAL                         --年初余额
    ,Y_ACM_BAL                         --年累计余额
    ,S_ACM_BAL                         --季累计余额
    ,M_ACM_BAL                         --月累计余额
    ,CL_CURR_EAR_D_BAL                 --折本币日初余额
    ,CL_CURR_EAR_M_BAL                 --折本币月初余额
    ,CL_CURR_EAR_S_BAL                 --折本币季初余额
    ,CL_CURR_EAR_Y_BAL                 --折本币年初余额
    ,CL_CURR_Y_ACM_BAL                 --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL           --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL           --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL           --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL           --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL                 --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL           --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL           --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL           --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL                 --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL           --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL           --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL           --折本币年初月累计余额
    ,Y_AVG_BAL                         --年日均余额
    ,Q_AVG_BAL                         --季日均余额
    ,M_AVG_BAL                         --月日均余额
    ,CL_CURR_Y_AVG_BAL                 --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL                 --折本币季日均余额
    ,CL_CURR_M_AVG_BAL                 --折本币月日均余额
    ,JOB_CD                            --任务编码
    )
  SELECT ETL_DT                        --数据日期
        ,LP_ID                         --法人编号
        ,CUST_ACCT_SUB_ACCT_NUM        --客户账户子户号
        ,CUST_ACCT_ID                  --客户账户编号
        ,ACCT_NAME                     --账户名称
        ,CUST_ID                       --客户编号
        ,STD_PROD_ID                   --标准产品编号
        ,PROD_ID                       --产品编号
        ,BIND_WEBANK_CARD_NO           --绑定微众银行卡号
        ,SUBJ_ID                       --科目编号
        ,CUST_TYPE_CD                  --客户类型代码
        ,EXT_PROD_ID                   --外部产品编号
        ,DEP_ACCT_STATUS_CD            --存款账户状态代码
        ,ACPT_PAY_STATUS_CD            --收付状态代码
        ,FROZ_STATUS_CD                --冻结状态代码
        ,STOP_PAY_STATUS_CD            --止付状态代码
        ,DEP_TERM                      --存期
        ,SAV_TYPE_CD                   --储种代码
        ,EXEC_INT_RAT_CATE_CD          --执行利率类别代码
        ,PA_EXT_INT_RAT_CATE_CD        --部提利率类别代码
        ,OVDUE_INT_RAT_CATE_CD         --逾期利率类别代码
        ,BASE_RAT_TYPE_CD              --基准利率类型代码
        ,INT_SET_WAY_CD                --结息方式代码
        ,INT_ACCR_WAY_CD               --计息方式代码
        ,INT_ACCR_BASE_CD              --计息基准代码
        ,CORP_ACCT_FLG                 --对公账户标志
        ,RC_FLG                        --定活标志
        ,WEB_DEP_FLG                   --网络存款标志
        ,INT_ACCR_FLG                  --计息标志
        ,PART_DRAW_CNT                 --部分提取次数
        ,ACCT_INSTIT_ID                --账务机构编号
        ,OPEN_ACCT_ORG_ID              --开户机构编号
        ,OPEN_ACCT_TELLER_ID           --开户柜员编号
        ,OPEN_ACCT_FLOW_NUM            --开户流水号
        ,OPEN_ACCT_CHN_CD              --开户渠道代码
        ,OPEN_ACCT_DT                  --开户日期
        ,OPEN_ACCT_TM                  --开户时间
        ,CLOSE_ACCT_ORG_ID             --销户机构编号
        ,CLOS_ACCT_TELLER_ID           --销户柜员编号
        ,CLOS_ACCT_FLOW_NUM            --销户流水号
        ,CLOS_ACCT_DT                  --销户日期
        ,CLOS_ACCT_TM                  --销户时间
        ,ACCT_DT                       --账务日期
        ,VALUE_DT                      --起息日期
        ,EXP_DT                        --到期日期
        ,FINAL_ACTIV_ACCT_DT           --最后动户日期
        ,LAST_INT_SET_DT               --上次结息日期
        ,NEXT_INT_SET_DT               --下次结息日期
        ,FIR_VALUE_DT                  --首次起息日期
        ,BASE_RAT                      --基准利率
        ,EXEC_INT_RAT                  --执行利率
        ,INT_RAT_FLO_VAL               --利率浮动值
        ,CURR_CD                       --币种代码
        ,TD_ACRU_INT                   --当日应计利息
        ,CURRT_ACRU_INT                --当期应计利息
        ,CURRT_BAL                     --当期余额
        ,FROZ_AMT                      --冻结金额
        ,AVAL_BAL                      --可用余额
        ,STOP_PAY_AMT                  --止付金额
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
        ,JOB_CD
    FROM ICL.V_CMM_IFS_ACCT_INFO  --视图-联合存款分户信息
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

END ETL_O_ICL_CMM_IFS_ACCT_INFO;
/

