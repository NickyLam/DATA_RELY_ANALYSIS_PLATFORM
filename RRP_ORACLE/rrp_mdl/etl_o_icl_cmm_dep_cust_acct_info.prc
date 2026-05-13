CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_CUST_ACCT_INFO(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_DEP_CUST_ACCT_INFO
  *  功能描述：存款主账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_DEP_CUST_ACCT_INFO
  *  目标表： O_ICL_CMM_DEP_CUST_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221615           修改参数
  *             3    20231109  hulj     优化O层
  *             4    20241031  YJY      新增旅行通相关字段
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_DEP_CUST_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_DEP_CUST_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-存款主账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO
    (ETL_DT                                 --数据日期
    ,LP_ID                                  --法人编号
    ,CUST_ACCT_ID                           --客户账户编号
    ,CUST_ACCT_NAME                         --客户账户名称
    ,CUST_ID                                --客户编号
    ,MAX_SUB_ACCT_NUM                       --最大子户号
    ,STD_PROD_ID                            --标准产品编号
    ,DRAWDOWN_WAY_CD                        --支取方式代码
    ,ACCT_STATUS_CD                         --账户状态代码
    ,ACCT_DRAWDOWN_WAY_STATUS               --账户支取方式状态
    ,FROZ_STATUS_CD                         --冻结状态代码
    ,STOP_PAY_STATUS_CD                     --止付状态代码
    ,ACPT_PAY_STATUS_CD                     --收付状态代码
    ,ACCT_USAGE_CD                          --账户用途代码
    ,VOUCH_KIND_CD                          --凭证种类代码
    ,VOUCH_CHAR_CD                          --凭证性质代码
    ,VOUCH_FORM_CD                          --凭证形式代码
    ,SLEEP_ACCT_FLG                         --睡眠户标志
    ,DORMT_ACCT_FLG                         --不动户标志
    ,PRIVAVY_ACCT_FLG                       --隐私账户标志
    ,ACCT_BELONG_ORG_ID                     --账户所属机构编号
    ,OPEN_ACCT_ORG_ID                       --开户机构编号
    ,OPEN_ACCT_TELLER_ID                    --开户柜员编号
    ,OPEN_ACCT_CHN_CD                       --开户渠道代码
    ,OPEN_ACCT_FLOW_NUM                     --开户流水号
    ,OPEN_ACCT_DT                           --开户日期
    ,OPEN_ACCT_TM                           --开户时间
    ,CLOSE_ACCT_ORG_ID                      --销户机构编号
    ,CLOS_ACCT_TELLER_ID                    --销户柜员编号
    ,CLOS_ACCT_FLOW_NUM                     --销户流水号
    ,CLOS_ACCT_DT                           --销户日期
    ,CLOS_ACCT_TM                           --销户时间
    ,ACCT_TYPE_CD                           --账户类型代码
    ,E_ACCT_TYPE_CD                         --电子账户类型代码
    ,E_ACCT_STATUS_CD                       --电子账户状态代码
    ,NETW_VRFCTION_REST_CD                  --联网核查结果代码
    ,VRIF_STATUS_CD                         --核实状态代码
    ,UNVRIF_RS_DESCB                        --无法核实原因描述
    ,DISP_METHOD_DESCB                      --处置方法描述
    ,TRAN_CHN_STATUS_CD                     --交易渠道状态代码
    ,CORP_ACCT_FLG                          --对公账户标志
    ,BIND_ACCT_FLG                          --绑定账户标志
    ,JOB_CD                                 --任务代码
    ,FISCAL_DEP_FLG                         --财政性存款标志
    ,CUST_ACCT_CARD_NO                      --客户账户卡号
    ,CURR_CD
    ,ACCT_ATTR_CD                           --账户属性代码
    ,ACCT_ID                                --账户编号           ADD BY YJY 20241031    
    ,REG_ACCT_TYPE_CD                       --定期账户类型代码   ADD BY YJY 20241031
    ,SRC_MODULE_TYPE_CD                     --源模块类型代码     ADD BY YJY 20241031
    ,GENERAL_EXCH_FLG                       --通兑标志           ADD BY YJY 20241031
    ,GENERAL_EXCH_ORG_ID                    --通兑机构编号       ADD BY YJY 20241031
    ,TRAVEL_CARD_ACCT_FLG                   --旅行通账户标志     ADD BY YJY 20241031
    ,TRAVEL_CARD_VALID_DT                   --旅行通卡有效期     ADD BY YJY 20241031

    )
  SELECT 
     TO_DATE(V_P_DATE,'YYYYMMDD') AS ETL_DT --数据日期
    ,LP_ID                                  --法人编号
    ,CUST_ACCT_ID                           --客户账户编号
    ,CUST_ACCT_NAME                         --客户账户名称
    ,CUST_ID                                --客户编号
    ,MAX_SUB_ACCT_NUM                       --最大子户号
    ,STD_PROD_ID                            --标准产品编号
    ,DRAWDOWN_WAY_CD                        --支取方式代码
    ,ACCT_STATUS_CD                         --账户状态代码
    ,ACCT_DRAWDOWN_WAY_STATUS               --账户支取方式状态
    ,FROZ_STATUS_CD                         --冻结状态代码
    ,STOP_PAY_STATUS_CD                     --止付状态代码
    ,ACPT_PAY_STATUS_CD                     --收付状态代码
    ,ACCT_USAGE_CD                          --账户用途代码
    ,VOUCH_KIND_CD                          --凭证种类代码
    ,VOUCH_CHAR_CD                          --凭证性质代码
    ,VOUCH_FORM_CD                          --凭证形式代码
    ,SLEEP_ACCT_FLG                         --睡眠户标志
    ,DORMT_ACCT_FLG                         --不动户标志
    ,PRIVAVY_ACCT_FLG                       --隐私账户标志
    ,ACCT_BELONG_ORG_ID                     --账户所属机构编号
    ,OPEN_ACCT_ORG_ID                       --开户机构编号
    ,OPEN_ACCT_TELLER_ID                    --开户柜员编号
    ,OPEN_ACCT_CHN_CD                       --开户渠道代码
    ,OPEN_ACCT_FLOW_NUM                     --开户流水号
    ,OPEN_ACCT_DT                           --开户日期
    ,OPEN_ACCT_TM                           --开户时间
    ,CLOSE_ACCT_ORG_ID                      --销户机构编号
    ,CLOS_ACCT_TELLER_ID                    --销户柜员编号
    ,CLOS_ACCT_FLOW_NUM                     --销户流水号
    ,CLOS_ACCT_DT                           --销户日期
    ,CLOS_ACCT_TM                           --销户时间
    ,ACCT_TYPE_CD                           --账户类型代码
    ,E_ACCT_TYPE_CD                         --电子账户类型代码
    ,E_ACCT_STATUS_CD                       --电子账户状态代码
    ,NETW_VRFCTION_REST_CD                  --联网核查结果代码
    ,VRIF_STATUS_CD                         --核实状态代码
    ,UNVRIF_RS_DESCB                        --无法核实原因描述
    ,DISP_METHOD_DESCB                      --处置方法描述
    ,TRAN_CHN_STATUS_CD                     --交易渠道状态代码
    ,CORP_ACCT_FLG                          --对公账户标志
    ,BIND_ACCT_FLG                          --绑定账户标志
    ,JOB_CD                                 --任务代码
    ,FISCAL_DEP_FLG                         --财政性存款标志
    ,CUST_ACCT_CARD_NO                      --客户账户卡号
    ,CURR_CD
    ,ACCT_ATTR_CD                           --账户属性代码
    ,ACCT_ID                                --账户编号           ADD BY YJY 20241031    
    ,REG_ACCT_TYPE_CD                       --定期账户类型代码   ADD BY YJY 20241031
    ,SRC_MODULE_TYPE_CD                     --源模块类型代码     ADD BY YJY 20241031
    ,GENERAL_EXCH_FLG                       --通兑标志           ADD BY YJY 20241031
    ,GENERAL_EXCH_ORG_ID                    --通兑机构编号       ADD BY YJY 20241031
    ,REPLACE(TRAVEL_CARD_ACCT_FLG,'-','0') AS TRAVEL_CARD_ACCT_FLG --旅行通账户标志     ADD BY YJY 20241031
    ,TRAVEL_CARD_VALID_DT                   --旅行通卡有效期     ADD BY YJY 20241031
    FROM ICL.V_CMM_DEP_CUST_ACCT_INFO --视图-存款主账户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_O_ICL_CMM_DEP_CUST_ACCT_INFO;
/

