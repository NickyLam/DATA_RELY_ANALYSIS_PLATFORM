/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_consmt_fund_prod_nfssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm purge;
drop table ${iml_schema}.prd_consmt_fund_prod_nfssf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_consmt_fund_prod add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_consmt_fund_prod modify partition p_nfssf1
    add subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_consmt_fund_prod_nfssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_consmt_fund_prod partition for ('nfssf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,belong_cate_cd -- 归属类别代码
    ,prod_tepla -- 产品模板
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_id -- 产品托管人编号
    ,prod_mger_id -- 产品管理人编号
    ,prod_host_dept_id -- 产品主办部门编号
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_closing_dt -- 利息截止日期
    ,prft_exp_dt -- 收益到期日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,prod_curr_size -- 产品当前规模
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg_cd -- 额度控制标志代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd_comb -- 渠道代码组合
    ,allow_cust_type_cd_comb -- 允许客户类型代码组合
    ,tepla_flg_cd -- 模板标志代码
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,charge_way_cd -- 收费方式代码
    ,out_charge_flg -- 外收费标志
    ,subscr_export_mode_cd -- 认购导出模式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,estim_level_cd -- 评估等级代码
    ,status_cd -- 状态代码
    ,tran_flg_cd -- 转换标志代码
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,curr_cd -- 币种代码
    ,prft_curr_cd -- 收益币种代码
    ,ec_flg -- 钞汇标志
    ,discnt_way_cd -- 折扣方式代码
    ,open_tm -- 开市时间
    ,close_tm -- 闭市时间
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_least_redem_lot -- 个人单笔最少赎回份额
    ,indv_sig_max_redem_lot -- 个人单笔最大赎回份额
    ,indv_redem_corp -- 个人赎回单位
    ,indv_lowt_fund_tran_lot -- 个人最低基金转换份额
    ,indv_lowt_reg_redem_lot -- 个人最低定赎份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,aip_fail_cnt -- 定投失败次数
    ,sp_acct_id -- 认申购账户编号
    ,redem_acct_id -- 赎回账户编号
    ,comm_fee_assign_acct_id -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id -- 管理费分配账户编号
    ,redem_cap_avl_days -- 赎回资金到帐天数
    ,divd_cap_avl_days -- 分红资金到帐天数
    ,prod_exp_cap_avl_days -- 产品到期资金到帐天数
    ,issue_fail_refund_days -- 发行失败退款天数
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_consmt_fund_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_consmt_fund_prod_nfssf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_consmt_fund_prod partition for ('nfssf1') where 0=1;

-- 2.1 insert data to tm table
-- nfss_tbproduct-
insert into ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,belong_cate_cd -- 归属类别代码
    ,prod_tepla -- 产品模板
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_id -- 产品托管人编号
    ,prod_mger_id -- 产品管理人编号
    ,prod_host_dept_id -- 产品主办部门编号
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_closing_dt -- 利息截止日期
    ,prft_exp_dt -- 收益到期日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,prod_curr_size -- 产品当前规模
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg_cd -- 额度控制标志代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd_comb -- 渠道代码组合
    ,allow_cust_type_cd_comb -- 允许客户类型代码组合
    ,tepla_flg_cd -- 模板标志代码
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,charge_way_cd -- 收费方式代码
    ,out_charge_flg -- 外收费标志
    ,subscr_export_mode_cd -- 认购导出模式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,estim_level_cd -- 评估等级代码
    ,status_cd -- 状态代码
    ,tran_flg_cd -- 转换标志代码
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,curr_cd -- 币种代码
    ,prft_curr_cd -- 收益币种代码
    ,ec_flg -- 钞汇标志
    ,discnt_way_cd -- 折扣方式代码
    ,open_tm -- 开市时间
    ,close_tm -- 闭市时间
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_least_redem_lot -- 个人单笔最少赎回份额
    ,indv_sig_max_redem_lot -- 个人单笔最大赎回份额
    ,indv_redem_corp -- 个人赎回单位
    ,indv_lowt_fund_tran_lot -- 个人最低基金转换份额
    ,indv_lowt_reg_redem_lot -- 个人最低定赎份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,aip_fail_cnt -- 定投失败次数
    ,sp_acct_id -- 认申购账户编号
    ,redem_acct_id -- 赎回账户编号
    ,comm_fee_assign_acct_id -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id -- 管理费分配账户编号
    ,redem_cap_avl_days -- 赎回资金到帐天数
    ,divd_cap_avl_days -- 分红资金到帐天数
    ,prod_exp_cap_avl_days -- 产品到期资金到帐天数
    ,issue_fail_refund_days -- 发行失败退款天数
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223008'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.MODEL_FLAG -- 归属类别代码
    ,P1.MODEL_COMMENT -- 产品模板
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.PRD_TYPE END -- 产品类别代码
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,nvl(P2.PROMPT,' ') -- 标准产品编号
    ,P1.PRD_CODE -- 原产品编号
    ,P1.PRD_NAME -- 产品名称
    ,P1.PRD_NAME2 -- 产品描述
    ,P1.NAV -- 产品净值
    ,${iml_schema}.DATEFORMAT_MIN(P1.NAV_DATE) -- 净值日期
    ,P1.NAV_DAYS -- 净值天数
    ,P1.FACE_VALUE -- 产品面值
    ,P1.ISS_PRICE -- 发行价格
    ,P1.PRD_SPONSOR -- 产品发起人编号
    ,P1.PRD_TRUSTEE -- 产品托管人编号
    ,P1.PRD_MANAGER -- 产品管理人编号
    ,P1.DEP_ID -- 产品主办部门编号
    ,P1.BRANCH_NO -- 产品主办机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.IPO_START_DATE) -- 募集开始日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.IPO_END_DATE) -- 募集结束日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ESTAB_DATE) -- 产品成立日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.INCOME_DATE) -- 产品起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 产品结束日期
    ,${iml_schema}.DATEFORMAT_MAX(p1.INTEREST_END_DATE) -- 利息截止日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.INCOME_END_DATE) -- 收益到期日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ALIMIT_END_DATE) -- 募集后封闭到期日期
    ,${iml_schema}.DATEFORMAT_MAX(p1.REAL_ESTAB_DATE) -- 实际成立日期
    ,P1.PRD_MIN_BALA -- 产品最低募集金额
    ,P1.PRD_MAX_BALA -- 产品最高募集金额
    ,P1.PRD_MIN_SHARES -- 产品最低募集份额
    ,P1.PRD_MAX_SHARES -- 产品最高募集份额
    ,P1.PRD_ISSUE_REAL_BALA -- 产品实际募集金额
    ,P1.CURR_SCALE -- 产品当前规模
    ,P1.DIV_MODES -- 允许分红方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 默认分红方式代码
    ,NVL(TRIM(P1.INST_FLAG),'-') -- 销售区域控制标志
    ,P1.LIMIT_FLAG -- 额度控制标志代码
    ,P1.LIQU_MODE -- 募集期账务模式代码
    ,P1.LIQU_MODE2 -- 开放期账务模式代码
    ,P1.CHANNELS -- 渠道代码组合
    ,P1.CLIENT_GROUPS -- 允许客户类型代码组合
    ,NVL(TRIM(P1.TEMP_FLAG),'-') -- 模板标志代码
    ,P1.CONTROL_FLAG -- 控制标志组合
    ,P1.CONTROL_FLAG2 -- BTA控制标志组合
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,NVL(TRIM(P1.SUB_MODE),'-') -- 外收费标志
    ,NVL(TRIM(P1.SUB_EXP),'9') -- 认购导出模式代码
    ,P1.INTEREST_WAY -- 收益体现方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PRD_ATTR END -- 产品属性代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.RISK_LEVEL END -- 风险等级代码
    ,NVL(TRIM(P1.GRADE),'-') -- 评估等级代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 状态代码
    ,P1.CONV_FLAG -- 转换标志代码
    ,P1.PRD_TOTVOL -- 产品当前总份额
    ,P1.TOT_NAV -- 产品累计净值
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.INCOME_CURR_TYPE END -- 收益币种代码
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标志
    ,NVL(TRIM(P1.AGIO_TYPE),'-') -- 折扣方式代码
    ,P1.OPEN_TIME -- 开市时间
    ,P1.CLOSE_TIME -- 闭市时间
    ,P1.PSUB_UNIT -- 个人最小购买单位
    ,P1.PFIRST_AMT -- 个人首次最低投资金额
    ,P1.PAPP_AMT -- 个人追加最低投资金额
    ,P1.PMIN_INVEST_AMT -- 个人最低定投金额
    ,P1.PMIN_HOLD -- 个人最低持有份额
    ,P1.PMIN_RED -- 个人单笔最少赎回份额
    ,P1.PMAX_RED -- 个人单笔最大赎回份额
    ,P1.PRED_UNIT -- 个人赎回单位
    ,P1.PMIN_CONV_VOL -- 个人最低基金转换份额
    ,P1.PMIN_RED_VOL -- 个人最低定赎份额
    ,P1.PMAX_AMT -- 个人单笔最大购买金额
    ,P1.PMAX_ACCU_AMT -- 个人单户累计最大购买金额
    ,P1.IPO_TIME -- 募集开始时间
    ,P1.INVEST_FAIL_TIMES -- 定投失败次数
    ,P1.DEBIT_ACCOUNT -- 认申购账户编号
    ,P1.CREBIT_ACCOUNT -- 赎回账户编号
    ,P1.CHARGE_ACCOUNT -- 手续费分配账户编号
    ,P1.MANAGE_ACCOUNT -- 管理费分配账户编号
    ,P1.RED_DAYS -- 赎回资金到帐天数
    ,P1.DIV_DAYS -- 分红资金到帐天数
    ,P1.REFUND_DAYS -- 产品到期资金到帐天数
    ,P1.FAIL_DAYS -- 发行失败退款天数
    ,P1.BASE_DAYS -- 产品计息基数
    ,P1.INTEREST_DAYS -- 认购利息计息基数
    ,P1.MANAGE_DAYS -- 管理费基础天数
    ,P1.GUEST_RATE -- 预期收益率
    ,P1.CYCLE_DAYS -- 周期天数
    ,NVL(TRIM(P1.TRANS_WAY),'9') -- 交易方式代码
    ,P1.RESERVE1 -- 产品模板编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tbproduct' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
   from ${iol_schema}.nfss_tbproduct p1
       left join  ${iol_schema}.ifms_tbdict p2 
         on p2.val = p1.prd_attr
        and p2.hs_key = 'K_HXYHZSJDXFUND'
        and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
        and p2.end_dt > to_date('${batch_date}','yyyymmdd')
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R7 ON P1.PRD_TYPE= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'NFSS'
        AND R7.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R7.SRC_FIELD_EN_NAME= 'PRD_TYPE'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'PROD_CATE_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R2 ON P1.DIV_MODE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DEFLT_DIVD_WAY_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R3 ON P1.PRD_ATTR= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R3.SRC_FIELD_EN_NAME= 'PRD_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PROD_ATTR_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R8 ON TO_CHAR(P1.RISK_LEVEL)= R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'NFSS'
        AND R8.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R8.SRC_FIELD_EN_NAME= 'RISK_LEVEL'
        AND R8.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R4 ON P1.STATUS= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R4.SRC_FIELD_EN_NAME= 'STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'STATUS_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R5 ON P1.CURR_TYPE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'NFSS'
        AND R5.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R5.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
       LEFT JOIN ${iml_schema}.REF_PUB_CD_MAP R6 ON P1.INCOME_CURR_TYPE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'NFSS'
        AND R6.SRC_TAB_EN_NAME= 'NFSS_TBPRODUCT'
        AND R6.SRC_FIELD_EN_NAME= 'INCOME_CURR_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_CONSMT_FUND_PROD'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'PRFT_CURR_CD'
      where p1.start_dt <= to_date('${batch_date}','yyyymmdd')
        and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_consmt_fund_prod_nfssf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,belong_cate_cd -- 归属类别代码
    ,prod_tepla -- 产品模板
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,std_prod_id -- 标准产品编号
    ,init_prod_id -- 原产品编号
    ,prod_name -- 产品名称
    ,prod_descb -- 产品描述
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_id -- 产品托管人编号
    ,prod_mger_id -- 产品管理人编号
    ,prod_host_dept_id -- 产品主办部门编号
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_closing_dt -- 利息截止日期
    ,prft_exp_dt -- 收益到期日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,prod_curr_size -- 产品当前规模
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg_cd -- 额度控制标志代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd_comb -- 渠道代码组合
    ,allow_cust_type_cd_comb -- 允许客户类型代码组合
    ,tepla_flg_cd -- 模板标志代码
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,charge_way_cd -- 收费方式代码
    ,out_charge_flg -- 外收费标志
    ,subscr_export_mode_cd -- 认购导出模式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,estim_level_cd -- 评估等级代码
    ,status_cd -- 状态代码
    ,tran_flg_cd -- 转换标志代码
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,curr_cd -- 币种代码
    ,prft_curr_cd -- 收益币种代码
    ,ec_flg -- 钞汇标志
    ,discnt_way_cd -- 折扣方式代码
    ,open_tm -- 开市时间
    ,close_tm -- 闭市时间
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_least_redem_lot -- 个人单笔最少赎回份额
    ,indv_sig_max_redem_lot -- 个人单笔最大赎回份额
    ,indv_redem_corp -- 个人赎回单位
    ,indv_lowt_fund_tran_lot -- 个人最低基金转换份额
    ,indv_lowt_reg_redem_lot -- 个人最低定赎份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,aip_fail_cnt -- 定投失败次数
    ,sp_acct_id -- 认申购账户编号
    ,redem_acct_id -- 赎回账户编号
    ,comm_fee_assign_acct_id -- 手续费分配账户编号
    ,mgmt_fee_assign_acct_id -- 管理费分配账户编号
    ,redem_cap_avl_days -- 赎回资金到帐天数
    ,divd_cap_avl_days -- 分红资金到帐天数
    ,prod_exp_cap_avl_days -- 产品到期资金到帐天数
    ,issue_fail_refund_days -- 发行失败退款天数
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.belong_cate_cd, o.belong_cate_cd) as belong_cate_cd -- 归属类别代码
    ,nvl(n.prod_tepla, o.prod_tepla) as prod_tepla -- 产品模板
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_descb, o.prod_descb) as prod_descb -- 产品描述
    ,nvl(n.prod_nv, o.prod_nv) as prod_nv -- 产品净值
    ,nvl(n.nv_dt, o.nv_dt) as nv_dt -- 净值日期
    ,nvl(n.nv_days, o.nv_days) as nv_days -- 净值天数
    ,nvl(n.prod_fac_val, o.prod_fac_val) as prod_fac_val -- 产品面值
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.prod_sponsor_id, o.prod_sponsor_id) as prod_sponsor_id -- 产品发起人编号
    ,nvl(n.prod_trustee_id, o.prod_trustee_id) as prod_trustee_id -- 产品托管人编号
    ,nvl(n.prod_mger_id, o.prod_mger_id) as prod_mger_id -- 产品管理人编号
    ,nvl(n.prod_host_dept_id, o.prod_host_dept_id) as prod_host_dept_id -- 产品主办部门编号
    ,nvl(n.prod_host_org_id, o.prod_host_org_id) as prod_host_org_id -- 产品主办机构编号
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.prod_found_dt, o.prod_found_dt) as prod_found_dt -- 产品成立日期
    ,nvl(n.prod_value_dt, o.prod_value_dt) as prod_value_dt -- 产品起息日期
    ,nvl(n.prod_end_dt, o.prod_end_dt) as prod_end_dt -- 产品结束日期
    ,nvl(n.int_closing_dt, o.int_closing_dt) as int_closing_dt -- 利息截止日期
    ,nvl(n.prft_exp_dt, o.prft_exp_dt) as prft_exp_dt -- 收益到期日期
    ,nvl(n.aft_coll_close_exp_dt, o.aft_coll_close_exp_dt) as aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,nvl(n.actl_found_dt, o.actl_found_dt) as actl_found_dt -- 实际成立日期
    ,nvl(n.prod_lowt_coll_amt, o.prod_lowt_coll_amt) as prod_lowt_coll_amt -- 产品最低募集金额
    ,nvl(n.prod_higt_coll_amt, o.prod_higt_coll_amt) as prod_higt_coll_amt -- 产品最高募集金额
    ,nvl(n.prod_lowt_coll_lot, o.prod_lowt_coll_lot) as prod_lowt_coll_lot -- 产品最低募集份额
    ,nvl(n.prod_higt_coll_lot, o.prod_higt_coll_lot) as prod_higt_coll_lot -- 产品最高募集份额
    ,nvl(n.prod_actl_coll_amt, o.prod_actl_coll_amt) as prod_actl_coll_amt -- 产品实际募集金额
    ,nvl(n.prod_curr_size, o.prod_curr_size) as prod_curr_size -- 产品当前规模
    ,nvl(n.allow_divd_way_cd, o.allow_divd_way_cd) as allow_divd_way_cd -- 允许分红方式代码
    ,nvl(n.deflt_divd_way_cd, o.deflt_divd_way_cd) as deflt_divd_way_cd -- 默认分红方式代码
    ,nvl(n.sell_rg_ctrl_flg, o.sell_rg_ctrl_flg) as sell_rg_ctrl_flg -- 销售区域控制标志
    ,nvl(n.lmt_ctrl_flg_cd, o.lmt_ctrl_flg_cd) as lmt_ctrl_flg_cd -- 额度控制标志代码
    ,nvl(n.coll_term_acct_mode_cd, o.coll_term_acct_mode_cd) as coll_term_acct_mode_cd -- 募集期账务模式代码
    ,nvl(n.open_term_acct_mode_cd, o.open_term_acct_mode_cd) as open_term_acct_mode_cd -- 开放期账务模式代码
    ,nvl(n.chn_cd_comb, o.chn_cd_comb) as chn_cd_comb -- 渠道代码组合
    ,nvl(n.allow_cust_type_cd_comb, o.allow_cust_type_cd_comb) as allow_cust_type_cd_comb -- 允许客户类型代码组合
    ,nvl(n.tepla_flg_cd, o.tepla_flg_cd) as tepla_flg_cd -- 模板标志代码
    ,nvl(n.ctrl_flg_comb, o.ctrl_flg_comb) as ctrl_flg_comb -- 控制标志组合
    ,nvl(n.bta_ctrl_flg_comb, o.bta_ctrl_flg_comb) as bta_ctrl_flg_comb -- BTA控制标志组合
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.out_charge_flg, o.out_charge_flg) as out_charge_flg -- 外收费标志
    ,nvl(n.subscr_export_mode_cd, o.subscr_export_mode_cd) as subscr_export_mode_cd -- 认购导出模式代码
    ,nvl(n.prft_embody_way_cd, o.prft_embody_way_cd) as prft_embody_way_cd -- 收益体现方式代码
    ,nvl(n.prod_attr_cd, o.prod_attr_cd) as prod_attr_cd -- 产品属性代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.estim_level_cd, o.estim_level_cd) as estim_level_cd -- 评估等级代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.tran_flg_cd, o.tran_flg_cd) as tran_flg_cd -- 转换标志代码
    ,nvl(n.prod_curr_tot_lot, o.prod_curr_tot_lot) as prod_curr_tot_lot -- 产品当前总份额
    ,nvl(n.prod_acm_nv, o.prod_acm_nv) as prod_acm_nv -- 产品累计净值
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.prft_curr_cd, o.prft_curr_cd) as prft_curr_cd -- 收益币种代码
    ,nvl(n.ec_flg, o.ec_flg) as ec_flg -- 钞汇标志
    ,nvl(n.discnt_way_cd, o.discnt_way_cd) as discnt_way_cd -- 折扣方式代码
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开市时间
    ,nvl(n.close_tm, o.close_tm) as close_tm -- 闭市时间
    ,nvl(n.indv_min_buy_corp, o.indv_min_buy_corp) as indv_min_buy_corp -- 个人最小购买单位
    ,nvl(n.indv_fir_lowt_invest_amt, o.indv_fir_lowt_invest_amt) as indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,nvl(n.indv_supp_lowt_invest_amt, o.indv_supp_lowt_invest_amt) as indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,nvl(n.indv_lowt_aip_amt, o.indv_lowt_aip_amt) as indv_lowt_aip_amt -- 个人最低定投金额
    ,nvl(n.indv_lowt_hold_lot, o.indv_lowt_hold_lot) as indv_lowt_hold_lot -- 个人最低持有份额
    ,nvl(n.indv_sig_least_redem_lot, o.indv_sig_least_redem_lot) as indv_sig_least_redem_lot -- 个人单笔最少赎回份额
    ,nvl(n.indv_sig_max_redem_lot, o.indv_sig_max_redem_lot) as indv_sig_max_redem_lot -- 个人单笔最大赎回份额
    ,nvl(n.indv_redem_corp, o.indv_redem_corp) as indv_redem_corp -- 个人赎回单位
    ,nvl(n.indv_lowt_fund_tran_lot, o.indv_lowt_fund_tran_lot) as indv_lowt_fund_tran_lot -- 个人最低基金转换份额
    ,nvl(n.indv_lowt_reg_redem_lot, o.indv_lowt_reg_redem_lot) as indv_lowt_reg_redem_lot -- 个人最低定赎份额
    ,nvl(n.indv_sig_max_buy_amt, o.indv_sig_max_buy_amt) as indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,nvl(n.indv_single_acct_amax_bamt, o.indv_single_acct_amax_bamt) as indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,nvl(n.coll_start_tm, o.coll_start_tm) as coll_start_tm -- 募集开始时间
    ,nvl(n.aip_fail_cnt, o.aip_fail_cnt) as aip_fail_cnt -- 定投失败次数
    ,nvl(n.sp_acct_id, o.sp_acct_id) as sp_acct_id -- 认申购账户编号
    ,nvl(n.redem_acct_id, o.redem_acct_id) as redem_acct_id -- 赎回账户编号
    ,nvl(n.comm_fee_assign_acct_id, o.comm_fee_assign_acct_id) as comm_fee_assign_acct_id -- 手续费分配账户编号
    ,nvl(n.mgmt_fee_assign_acct_id, o.mgmt_fee_assign_acct_id) as mgmt_fee_assign_acct_id -- 管理费分配账户编号
    ,nvl(n.redem_cap_avl_days, o.redem_cap_avl_days) as redem_cap_avl_days -- 赎回资金到帐天数
    ,nvl(n.divd_cap_avl_days, o.divd_cap_avl_days) as divd_cap_avl_days -- 分红资金到帐天数
    ,nvl(n.prod_exp_cap_avl_days, o.prod_exp_cap_avl_days) as prod_exp_cap_avl_days -- 产品到期资金到帐天数
    ,nvl(n.issue_fail_refund_days, o.issue_fail_refund_days) as issue_fail_refund_days -- 发行失败退款天数
    ,nvl(n.prod_int_accr_base, o.prod_int_accr_base) as prod_int_accr_base -- 产品计息基数
    ,nvl(n.subscr_int_accr_base, o.subscr_int_accr_base) as subscr_int_accr_base -- 认购利息计息基数
    ,nvl(n.mgmt_fee_base_days, o.mgmt_fee_base_days) as mgmt_fee_base_days -- 管理费基础天数
    ,nvl(n.expe_yld_rat, o.expe_yld_rat) as expe_yld_rat -- 预期收益率
    ,nvl(n.ped_days, o.ped_days) as ped_days -- 周期天数
    ,nvl(n.tard_way_cd, o.tard_way_cd) as tard_way_cd -- 交易方式代码
    ,nvl(n.prod_tepla_id, o.prod_tepla_id) as prod_tepla_id -- 产品模板编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.belong_cate_cd <> n.belong_cate_cd
                or o.prod_tepla <> n.prod_tepla
                or o.prod_cate_cd <> n.prod_cate_cd
                or o.ta_cd <> n.ta_cd
                or o.std_prod_id <> n.std_prod_id
                or o.init_prod_id <> n.init_prod_id
                or o.prod_name <> n.prod_name
                or o.prod_descb <> n.prod_descb
                or o.prod_nv <> n.prod_nv
                or o.nv_dt <> n.nv_dt
                or o.nv_days <> n.nv_days
                or o.prod_fac_val <> n.prod_fac_val
                or o.issue_price <> n.issue_price
                or o.prod_sponsor_id <> n.prod_sponsor_id
                or o.prod_trustee_id <> n.prod_trustee_id
                or o.prod_mger_id <> n.prod_mger_id
                or o.prod_host_dept_id <> n.prod_host_dept_id
                or o.prod_host_org_id <> n.prod_host_org_id
                or o.coll_start_dt <> n.coll_start_dt
                or o.coll_end_dt <> n.coll_end_dt
                or o.prod_found_dt <> n.prod_found_dt
                or o.prod_value_dt <> n.prod_value_dt
                or o.prod_end_dt <> n.prod_end_dt
                or o.int_closing_dt <> n.int_closing_dt
                or o.prft_exp_dt <> n.prft_exp_dt
                or o.aft_coll_close_exp_dt <> n.aft_coll_close_exp_dt
                or o.actl_found_dt <> n.actl_found_dt
                or o.prod_lowt_coll_amt <> n.prod_lowt_coll_amt
                or o.prod_higt_coll_amt <> n.prod_higt_coll_amt
                or o.prod_lowt_coll_lot <> n.prod_lowt_coll_lot
                or o.prod_higt_coll_lot <> n.prod_higt_coll_lot
                or o.prod_actl_coll_amt <> n.prod_actl_coll_amt
                or o.prod_curr_size <> n.prod_curr_size
                or o.allow_divd_way_cd <> n.allow_divd_way_cd
                or o.deflt_divd_way_cd <> n.deflt_divd_way_cd
                or o.sell_rg_ctrl_flg <> n.sell_rg_ctrl_flg
                or o.lmt_ctrl_flg_cd <> n.lmt_ctrl_flg_cd
                or o.coll_term_acct_mode_cd <> n.coll_term_acct_mode_cd
                or o.open_term_acct_mode_cd <> n.open_term_acct_mode_cd
                or o.chn_cd_comb <> n.chn_cd_comb
                or o.allow_cust_type_cd_comb <> n.allow_cust_type_cd_comb
                or o.tepla_flg_cd <> n.tepla_flg_cd
                or o.ctrl_flg_comb <> n.ctrl_flg_comb
                or o.bta_ctrl_flg_comb <> n.bta_ctrl_flg_comb
                or o.charge_way_cd <> n.charge_way_cd
                or o.out_charge_flg <> n.out_charge_flg
                or o.subscr_export_mode_cd <> n.subscr_export_mode_cd
                or o.prft_embody_way_cd <> n.prft_embody_way_cd
                or o.prod_attr_cd <> n.prod_attr_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.estim_level_cd <> n.estim_level_cd
                or o.status_cd <> n.status_cd
                or o.tran_flg_cd <> n.tran_flg_cd
                or o.prod_curr_tot_lot <> n.prod_curr_tot_lot
                or o.prod_acm_nv <> n.prod_acm_nv
                or o.curr_cd <> n.curr_cd
                or o.prft_curr_cd <> n.prft_curr_cd
                or o.ec_flg <> n.ec_flg
                or o.discnt_way_cd <> n.discnt_way_cd
                or o.open_tm <> n.open_tm
                or o.close_tm <> n.close_tm
                or o.indv_min_buy_corp <> n.indv_min_buy_corp
                or o.indv_fir_lowt_invest_amt <> n.indv_fir_lowt_invest_amt
                or o.indv_supp_lowt_invest_amt <> n.indv_supp_lowt_invest_amt
                or o.indv_lowt_aip_amt <> n.indv_lowt_aip_amt
                or o.indv_lowt_hold_lot <> n.indv_lowt_hold_lot
                or o.indv_sig_least_redem_lot <> n.indv_sig_least_redem_lot
                or o.indv_sig_max_redem_lot <> n.indv_sig_max_redem_lot
                or o.indv_redem_corp <> n.indv_redem_corp
                or o.indv_lowt_fund_tran_lot <> n.indv_lowt_fund_tran_lot
                or o.indv_lowt_reg_redem_lot <> n.indv_lowt_reg_redem_lot
                or o.indv_sig_max_buy_amt <> n.indv_sig_max_buy_amt
                or o.indv_single_acct_amax_bamt <> n.indv_single_acct_amax_bamt
                or o.coll_start_tm <> n.coll_start_tm
                or o.aip_fail_cnt <> n.aip_fail_cnt
                or o.sp_acct_id <> n.sp_acct_id
                or o.redem_acct_id <> n.redem_acct_id
                or o.comm_fee_assign_acct_id <> n.comm_fee_assign_acct_id
                or o.mgmt_fee_assign_acct_id <> n.mgmt_fee_assign_acct_id
                or o.redem_cap_avl_days <> n.redem_cap_avl_days
                or o.divd_cap_avl_days <> n.divd_cap_avl_days
                or o.prod_exp_cap_avl_days <> n.prod_exp_cap_avl_days
                or o.issue_fail_refund_days <> n.issue_fail_refund_days
                or o.prod_int_accr_base <> n.prod_int_accr_base
                or o.subscr_int_accr_base <> n.subscr_int_accr_base
                or o.mgmt_fee_base_days <> n.mgmt_fee_base_days
                or o.expe_yld_rat <> n.expe_yld_rat
                or o.ped_days <> n.ped_days
                or o.tard_way_cd <> n.tard_way_cd
                or o.prod_tepla_id <> n.prod_tepla_id
            ) or (
                 case when (
                           n.prod_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm n
    full join ${iml_schema}.prd_consmt_fund_prod_nfssf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_consmt_fund_prod truncate partition for ('nfssf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_consmt_fund_prod exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.prd_consmt_fund_prod_nfssf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_consmt_fund_prod drop subpartition p_nfssf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_consmt_fund_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_consmt_fund_prod_nfssf1_tm purge;
drop table ${iml_schema}.prd_consmt_fund_prod_nfssf1_ex purge;
drop table ${iml_schema}.prd_consmt_fund_prod_nfssf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_consmt_fund_prod', partname => 'p_nfssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);