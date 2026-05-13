CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_AGENT_CONSMT_PROD_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_AGENT_CONSMT_PROD_INFO
  *  功能描述：代理代销产品信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_AGENT_CONSMT_PROD_INFO
  *  目标表： O_ICL_CMM_AGENT_CONSMT_PROD_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
                3    20250226  YJY      新增养老目标基金标志
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; 	             --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_AGENT_CONSMT_PROD_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_AGENT_CONSMT_PROD_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_AGENT_CONSMT_PROD_INFO';
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-代理代销产品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_AGENT_CONSMT_PROD_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,PROD_ID                    --产品编号
    ,STD_PROD_ID                --标准产品编号
    ,PROD_NAME                  --产品名称
    ,PROD_FNAME                 --产品全称
    ,PROD_TEPLA_ID              --产品模板编号
    ,PROD_TEPLA_COMNT           --产品模板说明
    ,TA_CD                      --TA代码
    ,CONSMT_BUS_TYPE_CD         --代销业务类型代码
    ,PROD_TYPE_CD               --产品类型代码
    ,PROD_SCLASS_CD             --产品小类代码
    ,ISSUER_ID                  --发行人编号
    ,ISSUER_NAME                --发行人名称
    ,TRUSTEE_ID                 --托管人编号
    ,TRUSTEE_NAME               --托管人名称
    ,MGER_ID                    --管理人编号
    ,MGER_NAME                  --管理人名称
    ,FUND_MGR                   --基金经理
    ,DEPT_ID                    --部门编号
    ,ORG_ID                     --机构编号
    ,COLL_START_DT              --募集开始日期
    ,COLL_END_DT                --募集结束日期
    ,FOUND_DT                   --成立日期
    ,END_DT                     --结束日期
    ,VALUE_DT                   --起息日期
    ,INT_CLOSING_DT             --利息截止日期
    ,NEXT_OPEN_START_DT         --下一开放开始日期
    ,NEXT_OPEN_END_DT           --下一开放结束日期
    ,PRFT_EXP_DT                --收益到期日期
    ,ACTL_FOUND_DT              --实际成立日期
    ,SP_ACCT_ID                 --认申购账户编号
    ,REDEM_ACCT_ID              --赎回账户编号
    ,COMM_FEE_ASSIGN_ACCT_ID    --手续费分配账户编号
    ,MGMT_FEE_ASSIGN_ACCT_ID    --管理费分配账户编号
    ,ALLOW_CHN_GROUP_ID         --允许渠道组编号
    ,ALLOW_CUST_GROUP_ID        --允许客户组编号
    ,SELL_RG_CTRL_FLG           --销售区域控制标志
    ,LMT_CTRL_FLG               --额度控制标志
    ,PED_OPEN_FLG               --周期开放型标志
    ,ALLOW_DIVD_WAY_CD          --允许分红方式代码
    ,DEFLT_DIVD_WAY_CD          --默认分红方式代码
    ,PRFT_EMBODY_WAY_CD         --收益体现方式代码
    ,PRFT_TYPE_CD               --收益类型代码
    ,CHARGE_TYPE_CD             --收费类型代码
    ,PROD_ATTR_CD               --产品属性代码
    ,RISK_LEVEL_CD              --风险等级代码
    ,ESTIM_LEVEL_CD             --评估等级代码
    ,PROD_STATUS_CD             --产品状态代码
    ,TRAN_FLG_CD                --转换标志代码
    ,TARD_WAY_CD                --交易方式代码
    ,EC_FLG_CD                  --钞汇标志代码
    ,PRFT_CURR_CD               --收益币种代码
    ,CURR_CD                    --币种代码
    ,SUPT_BUY_WAY_CD            --支持购买方式代码
    ,CTRL_FLG_INFO              --控制标志信息
    ,BTA_CTRL_FLG_INFO          --BTA控制标志信息
    ,ISSUE_PRICE                --发行价格
    ,EXPE_YLD_RAT               --预期收益率
    ,LOWT_COLL_AMT              --最低募集金额
    ,HIGT_COLL_AMT              --最高募集金额
    ,LOWT_COLL_LOT              --最低募集份额
    ,HIGT_COLL_LOT              --最高募集份额
    ,ACTL_COLL_AMT              --实际募集金额
    ,CURR_COLL_SIZE             --当前募集规模
    ,INDV_FIR_LOWT_INVEST_AMT   --个人首次最低投资金额
    ,ACVMNT_BASE                --业绩基准
    ,PED_DAYS                   --周期天数
    ,NV_DAYS                    --净值天数
    ,CURR_TOT_LOT               --当前总份额
    ,CURR_ACM_NV                --当前累计净值
    ,NV                         --净值
    ,NV_DT                      --净值日期
    ,FAC_VAL                    --面值
    ,SALE_FEE_RAT               --销售费率
    ,DIFF_PRICE_FEE_RAT         --差价费率
    ,INSURE_PROD_PROJ_TYPE_CD   --保险产品项目类型代码
    ,DIR_INSURE_CD              --定向保险代码
    ,INSURE_RETURN_DAYS         --保险返回天数
    ,REDEM_CAP_AVL_DAYS         --赎回资金到账天数
    ,PROVI_FOR_AGED_TARGET_FUND_FLG  --养老目标基金标志
    )
  SELECT TO_DATE(V_P_DATE,'YYYYMMDD') ETL_DT                     --数据日期
        ,LP_ID                      --法人编号
        ,PROD_ID                    --产品编号
        ,STD_PROD_ID                --标准产品编号
        ,PROD_NAME                  --产品名称
        ,PROD_FNAME                 --产品全称
        ,PROD_TEPLA_ID              --产品模板编号
        ,PROD_TEPLA_COMNT           --产品模板说明
        ,TA_CD                      --TA代码
        ,CONSMT_BUS_TYPE_CD         --代销业务类型代码
        ,PROD_TYPE_CD               --产品类型代码
        ,PROD_SCLASS_CD             --产品小类代码
        ,ISSUER_ID                  --发行人编号
        ,ISSUER_NAME                --发行人名称
        ,TRUSTEE_ID                 --托管人编号
        ,TRUSTEE_NAME               --托管人名称
        ,MGER_ID                    --管理人编号
        ,MGER_NAME                  --管理人名称
        ,FUND_MGR                   --基金经理
        ,DEPT_ID                    --部门编号
        ,ORG_ID                     --机构编号
        ,COLL_START_DT              --募集开始日期
        ,COLL_END_DT                --募集结束日期
        ,FOUND_DT                   --成立日期
        ,END_DT                     --结束日期
        ,VALUE_DT                   --起息日期
        ,INT_CLOSING_DT             --利息截止日期
        ,NEXT_OPEN_START_DT         --下一开放开始日期
        ,NEXT_OPEN_END_DT           --下一开放结束日期
        ,PRFT_EXP_DT                --收益到期日期
        ,ACTL_FOUND_DT              --实际成立日期
        ,SP_ACCT_ID                 --认申购账户编号
        ,REDEM_ACCT_ID              --赎回账户编号
        ,COMM_FEE_ASSIGN_ACCT_ID    --手续费分配账户编号
        ,MGMT_FEE_ASSIGN_ACCT_ID    --管理费分配账户编号
        ,ALLOW_CHN_GROUP_ID         --允许渠道组编号
        ,ALLOW_CUST_GROUP_ID        --允许客户组编号
        ,SELL_RG_CTRL_FLG           --销售区域控制标志
        ,LMT_CTRL_FLG               --额度控制标志
        ,PED_OPEN_FLG               --周期开放型标志
        ,ALLOW_DIVD_WAY_CD          --允许分红方式代码
        ,DEFLT_DIVD_WAY_CD          --默认分红方式代码
        ,PRFT_EMBODY_WAY_CD         --收益体现方式代码
        ,PRFT_TYPE_CD               --收益类型代码
        ,CHARGE_TYPE_CD             --收费类型代码
        ,PROD_ATTR_CD               --产品属性代码
        ,RISK_LEVEL_CD              --风险等级代码
        ,ESTIM_LEVEL_CD             --评估等级代码
        ,PROD_STATUS_CD             --产品状态代码
        ,TRAN_FLG_CD                --转换标志代码
        ,TARD_WAY_CD                --交易方式代码
        ,EC_FLG_CD                  --钞汇标志代码
        ,PRFT_CURR_CD               --收益币种代码
        ,CURR_CD                    --币种代码
        ,SUPT_BUY_WAY_CD            --支持购买方式代码
        ,CTRL_FLG_INFO              --控制标志信息
        ,BTA_CTRL_FLG_INFO          --BTA控制标志信息
        ,ISSUE_PRICE                --发行价格
        ,EXPE_YLD_RAT               --预期收益率
        ,LOWT_COLL_AMT              --最低募集金额
        ,HIGT_COLL_AMT              --最高募集金额
        ,LOWT_COLL_LOT              --最低募集份额
        ,HIGT_COLL_LOT              --最高募集份额
        ,ACTL_COLL_AMT              --实际募集金额
        ,CURR_COLL_SIZE             --当前募集规模
        ,INDV_FIR_LOWT_INVEST_AMT   --个人首次最低投资金额
        ,ACVMNT_BASE                --业绩基准
        ,PED_DAYS                   --周期天数
        ,NV_DAYS                    --净值天数
        ,CURR_TOT_LOT               --当前总份额
        ,CURR_ACM_NV                --当前累计净值
        ,NV                         --净值
        ,NV_DT                      --净值日期
        ,FAC_VAL                    --面值
        ,SALE_FEE_RAT               --销售费率
        ,DIFF_PRICE_FEE_RAT         --差价费率
        ,INSURE_PROD_PROJ_TYPE_CD   --保险产品项目类型代码
        ,DIR_INSURE_CD              --定向保险代码
        ,INSURE_RETURN_DAYS         --保险返回天数
        ,REDEM_CAP_AVL_DAYS         --赎回资金到账天数
        ,PROVI_FOR_AGED_TARGET_FUND_FLG  --养老目标基金标志
    FROM ICL.V_CMM_AGENT_CONSMT_PROD_INFO --视图-代理代销产品信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_AGENT_CONSMT_PROD_INFO;
/

