CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IBANK_FIN_INSTM(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_IBANK_FIN_INSTM
  *  功能描述：同业金融工具
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_IBANK_FIN_INSTM
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250208  YJY      新增
  *             3    20251014  YJY      新增绿色融资标志
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_IBANK_FIN_INSTM'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业金融工具';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM
    (ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,FIN_INSTM_ID                     --金融工具编号
    ,ASSET_TYPE_ID                    --资产类型编号
    ,MARKET_TYPE_ID                   --市场类型编号
    ,FIN_INSTM_NAME                   --金融工具名称
    ,FIN_INSTM_ABBR                   --金融工具简称
    ,STD_PROD_ID                      --标准产品编号
    ,PROD_TYPE_CD                     --产品类型代码
    ,ASSET_TYPE_NAME                  --资产类型名称
    ,PROD_CLS_TENOR_CD                --产品分类期限代码
    ,ISSUE_ORG_ID                     --发行机构编号
    ,DISCOV_ORG_CLS_NAME              --发现机构分类名称
    ,ISSUE_DT                         --发行日期
    ,VALUE_DT                         --起息日期
    ,EXP_DT                           --到期日期
    ,TENOR_CD                         --期限代码
    ,BASE_RAT_ID                      --基准利率编号
    ,INT_ACCR_BASE_CD                 --计息基准代码
    ,INT_RAT_ADJ_WAY_CD               --利率调整方式代码
    ,ISSUE_WAY_CD                     --发行模式代码
    ,CTY_CD                           --国家代码
    ,CURR_CD                          --币种代码
    ,FAC_VAL_AMT                      --票面金额
    ,FAC_VAL_INT_RAT                  --票面利率
    ,FWD_INT_RAT_CURVE                --远期利率曲线
    ,DISCT_INT_RAT_CURVE              --折现利率曲线
    ,RISK_WT                          --风险权重
    ,PAY_INT_PED_CD                   --付息周期代码
    ,PAY_INT_FREQ                     --付息频率
    ,FIR_PAY_INT_DT                   --首次付息日期
    ,BELONG_ORG_ID                    --所属机构编号
    ,ISSUER_CUST_ID                   --发行人客户编号
    ,MGER_CUST_ID                     --管理人客户编号
    ,MGER_ID                          --管理人编号
    ,MGER_NAME                        --管理人名称
    ,MGMT_MODE_CD                     --管理模式代码
    ,CASHFLOW_GET_WAY_CD              --现金流获取方式代码
    ,SPEC_AIM_VECTOR_TYPE_CD          --特定目的载体类型代码
    ,SPEC_AIM_VECTOR_CODE             --特定目的载体编码
    ,AM_PROD_STAT_CODE                --资管产品统计编码
    ,ISSUER_ID                        --发行人编号
    ,ISSUER_RG_CD                     --发行人地区代码
    ,MOVE_WAY_CD                      --运行方式代码
    ,NON_UDER_ASSET_CLS_CD            --非底层资产分类代码
    ,NON_UDER_ASSET_SUBCLASS_CD       --非底层资产细类代码
    ,DR_INPUT_FREQ_CD                 --缓释录入频率代码
    ,DR_EFFECT_DT                     --缓释生效日期
    ,DR_EXP_DT                        --缓释到期日期
    ,MARGIN_DR_RATIO                  --保证金缓释比例
    ,HXB_DEP_RCPT_DR_RATIO            --我行存单缓释比例
    ,TBOND_DR_RATIO                   --国债缓释比例
    ,CHN_PB_BOND_DR_RATIO             --我国政策性银行债券缓释比例
    ,CHN_CB_DR_RATIO                  --我国商业银行缓释比例
    ,CHN_PUB_DEPT_DR_RATIO            --我国公共部门缓释比例
    ,OTHER_DR_RATIO                   --其他缓释比例
    ,DR_PROD_DESCB_INFO               --缓释品描述信息
    ,DR_ACCT_ID                       --缓释账户编号
    ,DR_ACCT_BAL                      --缓释账户余额
    ,FUND_OPEN_DT                     --基金开放日期
    ,ACTL_FINER_CUST_ID               --实际融资人客户编号
    ,ACTL_FINER_NAME                  --实际融资人名称
    ,ACTL_FINER_GROUP_NAME            --实际融资人集团名称
    ,SET_OPEN_TENOR_START_DT          --定开期限开始日期
    ,SET_OPEN_TENOR_END_DT            --定开期限结束日期
    ,SET_OPEN_FLG                     --定开标志
    ,SET_OPEN_PED_CD                  --定开周期代码
    ,OPEN_TYPE_CD                     --开放类型代码
    ,USAGE_DESCB                      --用途描述
    ,GUAR_WAY_COMB                    --担保方式组合
    ,CRDT_CLASS_PROJ_FLG              --信贷类项目标志
    ,JOB_CD                           --任务代码
    ,LIST_DT                          --上市日期
    ,THIS_PED_OPEN_TERMNT_DT          --本周期开放终止日期 --ADD BY LYH 20240108
    ,THIS_PED_HOLD_EXP_DT             --本周期持有到期日期 --ADD BY LYH 20240108
    ,CASH_MANAGE_FLG                  --现金管理类产品标志   ADD BY YJY 20250208
    ,GREEN_FIN_FLG                    --绿色融资标志  ADD BY YJY 20251014
    )
  SELECT 
     ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,FIN_INSTM_ID                     --金融工具编号
    ,ASSET_TYPE_ID                    --资产类型编号
    ,MARKET_TYPE_ID                   --市场类型编号
    ,FIN_INSTM_NAME                   --金融工具名称
    ,FIN_INSTM_ABBR                   --金融工具简称
    ,STD_PROD_ID                      --标准产品编号
    ,PROD_TYPE_CD                     --产品类型代码
    ,ASSET_TYPE_NAME                  --资产类型名称
    ,PROD_CLS_TENOR_CD                --产品分类期限代码
    ,ISSUE_ORG_ID                     --发行机构编号
    ,DISCOV_ORG_CLS_NAME              --发现机构分类名称
    ,ISSUE_DT                         --发行日期
    ,VALUE_DT                         --起息日期
    ,EXP_DT                           --到期日期
    ,TENOR_CD                         --期限代码
    ,BASE_RAT_ID                      --基准利率编号
    ,INT_ACCR_BASE_CD                 --计息基准代码
    ,INT_RAT_ADJ_WAY_CD               --利率调整方式代码
    ,ISSUE_WAY_CD                     --发行模式代码
    ,CTY_CD                           --国家代码
    ,CURR_CD                          --币种代码
    ,FAC_VAL_AMT                      --票面金额
    ,FAC_VAL_INT_RAT                  --票面利率
    ,FWD_INT_RAT_CURVE                --远期利率曲线
    ,DISCT_INT_RAT_CURVE              --折现利率曲线
    ,RISK_WT                          --风险权重
    ,PAY_INT_PED_CD                   --付息周期代码
    ,PAY_INT_FREQ                     --付息频率
    ,FIR_PAY_INT_DT                   --首次付息日期
    ,BELONG_ORG_ID                    --所属机构编号
    ,ISSUER_CUST_ID                   --发行人客户编号
    ,MGER_CUST_ID                     --管理人客户编号
    ,MGER_ID                          --管理人编号
    ,MGER_NAME                        --管理人名称
    ,MGMT_MODE_CD                     --管理模式代码
    ,CASHFLOW_GET_WAY_CD              --现金流获取方式代码
    ,SPEC_AIM_VECTOR_TYPE_CD          --特定目的载体类型代码
    ,SPEC_AIM_VECTOR_CODE             --特定目的载体编码
    ,AM_PROD_STAT_CODE                --资管产品统计编码
    ,ISSUER_ID                        --发行人编号
    ,ISSUER_RG_CD                     --发行人地区代码
    ,MOVE_WAY_CD                      --运行方式代码
    ,NON_UDER_ASSET_CLS_CD            --非底层资产分类代码
    ,NON_UDER_ASSET_SUBCLASS_CD       --非底层资产细类代码
    ,DR_INPUT_FREQ_CD                 --缓释录入频率代码
    ,DR_EFFECT_DT                     --缓释生效日期
    ,DR_EXP_DT                        --缓释到期日期
    ,MARGIN_DR_RATIO                  --保证金缓释比例
    ,HXB_DEP_RCPT_DR_RATIO            --我行存单缓释比例
    ,TBOND_DR_RATIO                   --国债缓释比例
    ,CHN_PB_BOND_DR_RATIO             --我国政策性银行债券缓释比例
    ,CHN_CB_DR_RATIO                  --我国商业银行缓释比例
    ,CHN_PUB_DEPT_DR_RATIO            --我国公共部门缓释比例
    ,OTHER_DR_RATIO                   --其他缓释比例
    ,DR_PROD_DESCB_INFO               --缓释品描述信息
    ,DR_ACCT_ID                       --缓释账户编号
    ,DR_ACCT_BAL                      --缓释账户余额
    ,FUND_OPEN_DT                     --基金开放日期
    ,ACTL_FINER_CUST_ID               --实际融资人客户编号
    ,ACTL_FINER_NAME                  --实际融资人名称
    ,ACTL_FINER_GROUP_NAME            --实际融资人集团名称
    ,SET_OPEN_TENOR_START_DT          --定开期限开始日期
    ,SET_OPEN_TENOR_END_DT            --定开期限结束日期
    ,SET_OPEN_FLG                     --定开标志
    ,SET_OPEN_PED_CD                  --定开周期代码
    ,OPEN_TYPE_CD                     --开放类型代码
    ,USAGE_DESCB                      --用途描述
    ,GUAR_WAY_COMB                    --担保方式组合
    ,CRDT_CLASS_PROJ_FLG              --信贷类项目标志
    ,JOB_CD                           --任务代码
    ,LIST_DT                          --上市日期
    ,THIS_PED_OPEN_TERMNT_DT          --本周期开放终止日期 --ADD BY LYH 20240108
    ,THIS_PED_HOLD_EXP_DT             --本周期持有到期日期 --ADD BY LYH 20240108
    ,CASH_MANAGE_FLG                  --现金管理类产品标志   ADD BY YJY 20250208
    ,GREEN_FIN_FLG                    --绿色融资标志  ADD BY YJY 20251014
    FROM ICL.V_CMM_IBANK_FIN_INSTM  --视图-同业金融工具
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

END ETL_O_ICL_CMM_IBANK_FIN_INSTM;
/

