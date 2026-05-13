CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_BILL_DISCNT_INFO(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_BILL_DISCNT_INFO
  *  功能描述：票据贴现信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BILL_DISCNT_INFO
  *  目标表： O_ICL_CMM_BILL_DISCNT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
                3    20231109  hulj     优化O层
                4    20231206  hulj     优化O层增加分区
                5    20251017  YJY      新增业务细类编号
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_BILL_DISCNT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_BILL_DISCNT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO';
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
  V_STEP_DESC := '数据落地-票据贴现信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO
    (ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,BUS_ID                           --业务编号
    ,BATCH_ID                         --批次编号
    ,BILL_ENTRY_ID                    --票据记账编号
    ,STD_PROD_ID                      --标准产品编号
    ,BILL_ID                          --票据编号
    ,BILL_NUM                         --票据号码
    ,BILL_SUB_INTRV_ID                --子票据区间编号
    ,SUBJ_ID                          --科目编号
    ,INT_ADJ_SUBJ_ID                  --利息调整科目编号
    ,CUST_ID                          --客户编号
    ,CUST_NAME                        --客户名称
    ,BILL_MED_CD                      --票据介质代码
    ,BILL_KIND_CD                     --票据种类代码
    ,BUY_PROD_CD                      --买入产品代码
    ,DISCNT_BUS_TYPE_CD               --贴现业务类型代码
    ,ASSET_THD_CLS_CD                 --资产三分类代码
    ,SYS_IN_FLG                       --系统内标志
    ,CITY_WIDE_FLG                    --同城标志
    ,INT_ACCR_FLG                     --计息标志
    ,ADJ_DAYS                         --调整天数
    ,PROVI_TYPE_CD                    --计提类型代码
    ,BUY_WAY_CD                       --买入方式代码
    ,BILL_BUS_TYPE_CD                 --票据业务类型代码
    ,BF_CNTPTY_TYPE_CD                --前交易对手类型代码
    ,BF_CNTPTY_NAME                   --前交易对手名称
    ,BF_CNTPTY_FLG                    --前交易对手标志
    ,APPL_DT                          --申请日期
    ,RECV_DT                          --签收日期
    ,VALUE_DT                         --起息日期
    ,REVO_DT                          --撤销日期
    ,DRAW_DT                          --出票日期
    ,EXP_DT                           --到期日期
    ,DIR_RHER_NAME                    --直接前手名称
    ,DISCNT_APPLIT_ACCT_NUM           --贴现申请人账号
    ,DISCNT_APPLIT_BANK_NO            --贴现申请人行号
    ,DSCNT_PROPS_CATE_CD              --贴出人类别代码
    ,DSCNT_PROPS_NAME                 --贴出人名称
    ,DSCNT_PROPS_ORGNZ_CD             --贴出人组织机构代码
    ,DSCNT_PROPS_ACCT_NUM             --贴出人账号
    ,DSCNT_PROPS_OPEN_BANK_NO         --贴出人开户行行号
    ,DSCNT_NAME                       --贴入人名称
    ,DSCNT_BANK_NO                    --贴入人行号
    ,DRAWER_NAME                      --出票人名称
    ,DRAWER_CATE_CD                   --出票人类别代码
    ,DRAWER_ACCT_NUM                  --出票人账号
    ,DRAWER_OPEN_BANK_NO              --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME            --出票人开户行名称
    ,ACCPTOR_NAME                     --承兑人名称
    ,ACCPTOR_ACCT_NUM                 --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO             --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME           --承兑人开户行名称
    ,MAIN_GUAR_WAY_CD                 --主担保方式代码
    ,AGENT_DISCNT_FLG                 --代理贴现标志
    ,ONL_DISCNT_FLG                   --在线贴现标志
    ,ENTRY_STATUS_CD                  --记账状态代码
    ,ENTRY_DT                         --记账日期
    ,INT_ACCR_EXP_DT                  --计息到期日期
    ,DISCNT_INT_RAT                   --贴现利率
    ,DEFER_DAYS                       --顺延天数
    ,INT_ACCR_DAYS                    --计息天数
    ,NOT_NGBL_FLG                     --不得转让标志
    ,HXB_ACPT_FLG                     --我行承兑标志
    ,FLASH_DISCNT_FLG                 --秒贴标志
    ,CURR_CD                          --币种代码
    ,FAC_VAL_AMT                      --票面金额
    ,PAYOFF_FLG                       --结清标志
    ,RECEIPT_FLG                      --小票标志
    ,BILL_STATUS_CD                   --票据状态代码
    ,DISCNT_STATUS_CD                 --贴现状态代码
    ,EXP_STATUS_CD                    --到期状态代码
    ,REDCST_FLG                       --再贴现标志
    ,CURRT_BAL                        --当期余额
    ,INT_ADJ_BAL                      --利息调整余额
    ,TD_ACRU_INT                      --当日应计利息
    ,CURRT_ACRU_INT                   --当期应计利息
    ,INT_AMT                          --利息金额
    ,BUYER_PAY_INT_AMT                --买方付息金额
    ,ACTL_AMT                         --实付金额
    ,RISK_BEAR_FEE                    --风险承担费
    ,ISSUE_ORG_ID                     --签发机构编号
    ,ENTER_ACCT_ORG_ID                --入账机构编号
    ,CUST_MGR_ID                      --客户经理编号
    ,DEPT_ID                          --部门编号
    ,OPERR_ID                         --操作员编号
    ,AGENT_NAME                       --代理人名称
    ,DRAWER_CRDT_LEVEL_CD             --出票人信用等级代码
    ,DRAWER_RATING_ORG_NAME           --出票人评级机构名称
    ,DRAWER_RATING_EXP_DT             --出票人评级到期日期
    ,RELA_PARTY_QUE_REST_CD           --关联方查询结果代码
    ,JOB_CD                           --任务代码
    ,ETL_TIMESTAMP                    --数据处理时间
    ,BUS_SUBCLASS_ID                  --业务细类编号  ADD BY YJY 20251017
    )
  SELECT 
     ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,BUS_ID                           --业务编号
    ,BATCH_ID                         --批次编号
    ,BILL_ENTRY_ID                    --票据记账编号
    ,STD_PROD_ID                      --标准产品编号
    ,BILL_ID                          --票据编号
    ,BILL_NUM                         --票据号码
    ,BILL_SUB_INTRV_ID                --子票据区间编号
    ,SUBJ_ID                          --科目编号
    ,INT_ADJ_SUBJ_ID                  --利息调整科目编号
    ,CUST_ID                          --客户编号
    ,CUST_NAME                        --客户名称
    ,BILL_MED_CD                      --票据介质代码
    ,BILL_KIND_CD                     --票据种类代码
    ,BUY_PROD_CD                      --买入产品代码
    ,DISCNT_BUS_TYPE_CD               --贴现业务类型代码
    ,ASSET_THD_CLS_CD                 --资产三分类代码
    ,SYS_IN_FLG                       --系统内标志
    ,CITY_WIDE_FLG                    --同城标志
    ,INT_ACCR_FLG                     --计息标志
    ,ADJ_DAYS                         --调整天数
    ,PROVI_TYPE_CD                    --计提类型代码
    ,BUY_WAY_CD                       --买入方式代码
    ,BILL_BUS_TYPE_CD                 --票据业务类型代码
    ,BF_CNTPTY_TYPE_CD                --前交易对手类型代码
    ,BF_CNTPTY_NAME                   --前交易对手名称
    ,BF_CNTPTY_FLG                    --前交易对手标志
    ,APPL_DT                          --申请日期
    ,RECV_DT                          --签收日期
    ,VALUE_DT                         --起息日期
    ,REVO_DT                          --撤销日期
    ,DRAW_DT                          --出票日期
    ,EXP_DT                           --到期日期
    ,DIR_RHER_NAME                    --直接前手名称
    ,DISCNT_APPLIT_ACCT_NUM           --贴现申请人账号
    ,DISCNT_APPLIT_BANK_NO            --贴现申请人行号
    ,DSCNT_PROPS_CATE_CD              --贴出人类别代码
    ,DSCNT_PROPS_NAME                 --贴出人名称
    ,DSCNT_PROPS_ORGNZ_CD             --贴出人组织机构代码
    ,DSCNT_PROPS_ACCT_NUM             --贴出人账号
    ,DSCNT_PROPS_OPEN_BANK_NO         --贴出人开户行行号
    ,DSCNT_NAME                       --贴入人名称
    ,DSCNT_BANK_NO                    --贴入人行号
    ,DRAWER_NAME                      --出票人名称
    ,DRAWER_CATE_CD                   --出票人类别代码
    ,DRAWER_ACCT_NUM                  --出票人账号
    ,DRAWER_OPEN_BANK_NO              --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME            --出票人开户行名称
    ,ACCPTOR_NAME                     --承兑人名称
    ,ACCPTOR_ACCT_NUM                 --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO             --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME           --承兑人开户行名称
    ,MAIN_GUAR_WAY_CD                 --主担保方式代码
    ,AGENT_DISCNT_FLG                 --代理贴现标志
    ,ONL_DISCNT_FLG                   --在线贴现标志
    ,ENTRY_STATUS_CD                  --记账状态代码
    ,ENTRY_DT                         --记账日期
    ,INT_ACCR_EXP_DT                  --计息到期日期
    ,DISCNT_INT_RAT                   --贴现利率
    ,DEFER_DAYS                       --顺延天数
    ,INT_ACCR_DAYS                    --计息天数
    ,NOT_NGBL_FLG                     --不得转让标志
    ,HXB_ACPT_FLG                     --我行承兑标志
    ,FLASH_DISCNT_FLG                 --秒贴标志
    ,CURR_CD                          --币种代码
    ,FAC_VAL_AMT                      --票面金额
    ,PAYOFF_FLG                       --结清标志
    ,RECEIPT_FLG                      --小票标志
    ,BILL_STATUS_CD                   --票据状态代码
    ,DISCNT_STATUS_CD                 --贴现状态代码
    ,EXP_STATUS_CD                    --到期状态代码
    ,REDCST_FLG                       --再贴现标志
    ,CURRT_BAL                        --当期余额
    ,INT_ADJ_BAL                      --利息调整余额
    ,TD_ACRU_INT                      --当日应计利息
    ,CURRT_ACRU_INT                   --当期应计利息
    ,INT_AMT                          --利息金额
    ,BUYER_PAY_INT_AMT                --买方付息金额
    ,ACTL_AMT                         --实付金额
    ,RISK_BEAR_FEE                    --风险承担费
    ,ISSUE_ORG_ID                     --签发机构编号
    ,ENTER_ACCT_ORG_ID                --入账机构编号
    ,CUST_MGR_ID                      --客户经理编号
    ,DEPT_ID                          --部门编号
    ,OPERR_ID                         --操作员编号
    ,AGENT_NAME                       --代理人名称
    ,DRAWER_CRDT_LEVEL_CD             --出票人信用等级代码
    ,DRAWER_RATING_ORG_NAME           --出票人评级机构名称
    ,DRAWER_RATING_EXP_DT             --出票人评级到期日期
    ,RELA_PARTY_QUE_REST_CD           --关联方查询结果代码
    ,JOB_CD                           --任务代码
    ,ETL_TIMESTAMP                    --数据处理时间
    ,BUS_SUBCLASS_ID                  --业务细类编号  ADD BY YJY 20251017
    FROM ICL.V_CMM_BILL_DISCNT_INFO  --视图-票据贴现信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
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

END ETL_O_ICL_CMM_BILL_DISCNT_INFO;
/

