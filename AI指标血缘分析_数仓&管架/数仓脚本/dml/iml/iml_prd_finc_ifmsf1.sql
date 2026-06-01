/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_finc_ifmsf1
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
drop table ${iml_schema}.prd_finc_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_ifmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_finc add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_finc modify partition p_ifmsf1
    add subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_finc_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_finc partition for ('ifmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc_ifmsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,std_prod_id -- 标准产品编号
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,ref_yld_rat_comnt -- 参考收益率说明
    ,prod_cbond_id -- 产品中债编号
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_cd -- 产品发起人代码
    ,prod_trustee_cd -- 产品托管人代码
    ,prod_mger_cd -- 产品管理人代码
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,coll_post_close_exp_day -- 募集后封闭到期日
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_size -- 当前规模
    ,allow_divd_way_cd -- 允许的分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd -- 渠道代码
    ,allow_cust_group_list -- 允许客户组列表
    ,ctrl_flg -- 控制标志
    ,bta_ctrl_flg -- BTA控制标志
    ,charge_way_cd -- 收费方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,status_cd -- 状态代码
    ,tran_flg -- 转换标志
    ,curr_cd -- 币种代码
    ,ec_flg -- 钞汇标志
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
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_min_redem_lot -- 机构单笔最小赎回份额
    ,org_sig_max_redem_lot -- 机构单笔最大赎回份额
    ,org_redem_corp -- 机构赎回单位
    ,org_lowt_fund_tran_lot -- 机构最低基金转换份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_acct_amax_bamt -- 机构单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,realtm_redem_adv_exp_acct_id -- 实时赎回垫支账户编号
    ,redem_cap_avl_days -- 赎回资金到账天数
    ,divd_cap_avl_days -- 分红资金到账天数
    ,prod_exp_cap_avl_days -- 产品到期资金到账天数
    ,huge_redem_ratio -- 巨额赎回比例
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,supt_buy_way_cd -- 支持购买方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_finc
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_finc_ifmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_finc partition for ('ifmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbproduct-
insert into ${iml_schema}.prd_finc_ifmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,std_prod_id -- 标准产品编号
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,ref_yld_rat_comnt -- 参考收益率说明
    ,prod_cbond_id -- 产品中债编号
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_cd -- 产品发起人代码
    ,prod_trustee_cd -- 产品托管人代码
    ,prod_mger_cd -- 产品管理人代码
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,coll_post_close_exp_day -- 募集后封闭到期日
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_size -- 当前规模
    ,allow_divd_way_cd -- 允许的分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd -- 渠道代码
    ,allow_cust_group_list -- 允许客户组列表
    ,ctrl_flg -- 控制标志
    ,bta_ctrl_flg -- BTA控制标志
    ,charge_way_cd -- 收费方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,status_cd -- 状态代码
    ,tran_flg -- 转换标志
    ,curr_cd -- 币种代码
    ,ec_flg -- 钞汇标志
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
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_min_redem_lot -- 机构单笔最小赎回份额
    ,org_sig_max_redem_lot -- 机构单笔最大赎回份额
    ,org_redem_corp -- 机构赎回单位
    ,org_lowt_fund_tran_lot -- 机构最低基金转换份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_acct_amax_bamt -- 机构单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,realtm_redem_adv_exp_acct_id -- 实时赎回垫支账户编号
    ,redem_cap_avl_days -- 赎回资金到账天数
    ,divd_cap_avl_days -- 分红资金到账天数
    ,prod_exp_cap_avl_days -- 产品到期资金到账天数
    ,huge_redem_ratio -- 巨额赎回比例
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,supt_buy_way_cd -- 支持购买方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223001'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PRD_CODE -- 理财产品编号
    ,nvl(P3.PROMPT,' ')  -- 标准产品编号
    ,P1.MODEL_FLAG -- 产品归属类别代码
    ,P1.MODEL_COMMENT -- 参考收益率说明
    ,nvl(P4.DEBT_REGIST_CODE,' ') -- 产品中债编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@' || P1.PRD_TYPE END -- 产品类别代码
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_NAME -- 产品名称
    ,P1.PRD_NAME2 -- 产品别名
    ,P1.NAV -- 产品净值
    ,P1.FACE_VALUE -- 产品面值
    ,P1.ISS_PRICE -- 发行价格
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@' || P1.PRD_SPONSOR END -- 产品发起人代码
    ,P1.PRD_TRUSTEE -- 产品托管人代码
    ,P1.PRD_MANAGER -- 产品管理人代码
    ,P1.BRANCH_NO -- 产品主办机构编号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.IPO_START_DATE)) -- 募集开始日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.IPO_END_DATE)) -- 募集结束日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.ESTAB_DATE)) -- 产品成立日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.INCOME_DATE)) -- 产品起息日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.END_DATE)) -- 产品结束日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.INCOME_END_DATE)) -- 收益到期日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ISSUE_FAIL_DATE)) -- 募集失败日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ALIMIT_END_DATE)) -- 募集后封闭到期日
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.REAL_ESTAB_DATE)) -- 实际成立日期
    ,P1.PRD_MIN_BALA -- 产品最低募集金额
    ,P1.PRD_MAX_BALA -- 产品最高募集金额
    ,P1.PRD_MIN_SHARES -- 产品最低募集份额
    ,P1.PRD_MAX_SHARES -- 产品最高募集份额
    ,P1.PRD_ISSUE_REAL_BALA -- 产品实际募集金额
    ,P1.CURR_SCALE -- 当前规模
    ,P1.DIV_MODES -- 允许的分红方式代码
    ,P1.DIV_MODE -- 默认分红方式代码
    ,P1.INST_FLAG -- 销售区域控制标志
    ,P1.LIMIT_FLAG -- 额度控制标志
    ,P1.LIQU_MODE -- 募集期账务模式代码
    ,P1.LIQU_MODE2 -- 开放期账务模式代码
    ,P1.CHANNELS -- 渠道代码
    ,P1.CLIENT_GROUPS -- 允许客户组列表
    ,P1.CONTROL_FLAG -- 控制标志
    ,P1.CONTROL_FLAG2 -- BTA控制标志
    ,P1.SHARE_CLASS -- 收费方式代码
    ,P1.INTEREST_WAY -- 收益体现方式代码
    ,NVL(TRIM(P1.PRD_ATTR),'-') -- 产品属性代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.RISK_LEVEL) END -- 风险等级代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 状态代码
    ,P1.CONV_FLAG -- 转换标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.CASH_FLAG -- 钞汇标志
    ,TO_CHAR(P1.OPEN_TIME) -- 开市时间
    ,TO_CHAR(P1.CLOSE_TIME) -- 闭市时间
    ,P1.PSUB_UNIT -- 个人最小购买单位
    ,P1.PFIRST_AMT -- 个人首次最低投资金额
    ,P1.PAPP_AMT -- 个人追加最低投资金额
    ,P1.PMIN_INVEST_AMT -- 个人最低定投金额
    ,P1.PMIN_HOLD -- 个人最低持有份额
    ,P1.PMIN_RED -- 个人单笔最少赎回份额
    ,P1.PMAX_RED -- 个人单笔最大赎回份额
    ,P1.PRED_UNIT -- 个人赎回单位
    ,P1.PMIN_CONV_VOL -- 个人最低基金转换份额
    ,P1.PMAX_AMT -- 个人单笔最大购买金额
    ,P1.PMAX_ACCU_AMT -- 个人单户累计最大购买金额
    ,P1.OSUB_UNIT -- 机构最小购买单位
    ,P1.OFIRST_AMT -- 机构首次最低投资金额
    ,P1.OAPP_AMT -- 机构追加最低投资金额
    ,P1.OMIN_INVEST_AMT -- 机构最低定投金额
    ,P1.OMIN_HOLD -- 机构最低持有份额
    ,P1.OMIN_RED -- 机构单笔最小赎回份额
    ,P1.OMAX_RED -- 机构单笔最大赎回份额
    ,P1.ORED_UNIT -- 机构赎回单位
    ,P1.OMIN_CONV_VOL -- 机构最低基金转换份额
    ,P1.OMAX_AMT -- 机构单笔最大购买金额
    ,P1.OMAX_ACCU_AMT -- 机构单户累计最大购买金额
    ,TO_CHAR(P1.IPO_TIME) -- 募集开始时间
    ,P1.DEBIT_ACCOUNT -- 购买账户编号
    ,P1.CREBIT_ACCOUNT -- 赎回账户编号
    ,P1.RED_DRAW_ACCOUNT -- 实时赎回垫支账户编号
    ,P1.RED_DAYS -- 赎回资金到账天数
    ,P1.DIV_DAYS -- 分红资金到账天数
    ,P1.REFUND_DAYS -- 产品到期资金到账天数
    ,P1.LARGE_RED_RATE -- 巨额赎回比例
    ,P1.BASE_DAYS -- 产品计息基数
    ,P1.INTEREST_DAYS -- 认购利息计息基数
    ,P1.MANAGE_DAYS -- 管理费基础天数
    ,P1.GUEST_RATE*100 -- 预期收益率
    ,P1.CYCLE_DAYS -- 周期天数
    ,P1.TRANS_WAY -- 交易方式代码
    ,P1.RESERVE1 -- 产品模板编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P2.field_value END -- 支持购买方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbproduct' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbproduct p1
    left join ${iol_schema}.ifms_tbprdparamvalue p2 
      on p1.prd_code = p2.prd_code 
     and p2.field_code = 'buy_channel_ctrl'
     and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
     and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbdict p3 
      on p1.prd_attr = p3.val
     and p3.hs_key = 'K_HXYHZSJFINA'
     and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
     and p3.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wmps_tbproductadd p4 
      on p1.prd_code = p4.prd_code
     and p4.start_dt <= to_date('${batch_date}','yyyymmdd') 
     and p4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r4 
      on P1.PRD_TYPE = R4.SRC_CODE_VAL
     AND R4.SORC_SYS_CD= 'IFMS'
     AND R4.SRC_TAB_EN_NAME= 'IFMS_TBPRODUCT'
     AND R4.SRC_FIELD_EN_NAME= 'PRD_TYPE'
     AND R4.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R4.TARGET_TAB_FIELD_EN_NAME= 'PROD_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 
      on P1.PRD_SPONSOR = R6.SRC_CODE_VAL
     AND R6.SORC_SYS_CD= 'IFMS'
     AND R6.SRC_TAB_EN_NAME= 'IFMS_TBPRODUCT'
     AND R6.SRC_FIELD_EN_NAME= 'PRD_SPONSOR'
     AND R6.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R6.TARGET_TAB_FIELD_EN_NAME= 'PROD_SPONSOR_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 
      on TO_CHAR(P1.RISK_LEVEL) = R1.SRC_CODE_VAL
     AND R1.SORC_SYS_CD= 'IFMS'
     AND R1.SRC_TAB_EN_NAME= 'IFMS_TBPRODUCT'
     AND R1.SRC_FIELD_EN_NAME= 'RISK_LEVEL'
     AND R1.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R1.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r2
      on P1.STATUS = R2.SRC_CODE_VAL
     AND R2.SORC_SYS_CD= 'IFMS'
     AND R2.SRC_TAB_EN_NAME= 'IFMS_TBPRODUCT'
     AND R2.SRC_FIELD_EN_NAME= 'STATUS'
     AND R2.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R2.TARGET_TAB_FIELD_EN_NAME= 'STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3
      on P1.CURR_TYPE = R3.SRC_CODE_VAL
     AND R3.SORC_SYS_CD= 'IFMS'
     AND R3.SRC_TAB_EN_NAME= 'IFMS_TBPRODUCT'
     AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
     AND R3.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r7
      on NVL(P2.FIELD_VALUE,' ') = R7.SRC_CODE_VAL
     AND R7.SORC_SYS_CD= 'IFMS'
     AND R7.SRC_TAB_EN_NAME= 'IFMS_TBPRDPARAMVALUE'
     AND R7.SRC_FIELD_EN_NAME= 'FIELD_VALUE'
     AND R7.TARGET_TAB_EN_NAME= 'PRD_FINC'
     AND R7.TARGET_TAB_FIELD_EN_NAME= 'SUPT_BUY_WAY_CD'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_finc_ifmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_finc_ifmsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,std_prod_id -- 标准产品编号
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,ref_yld_rat_comnt -- 参考收益率说明
    ,prod_cbond_id -- 产品中债编号
    ,prod_cate_cd -- 产品类别代码
    ,ta_cd -- TA代码
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,prod_sponsor_cd -- 产品发起人代码
    ,prod_trustee_cd -- 产品托管人代码
    ,prod_mger_cd -- 产品管理人代码
    ,prod_host_org_id -- 产品主办机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,coll_post_close_exp_day -- 募集后封闭到期日
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_size -- 当前规模
    ,allow_divd_way_cd -- 允许的分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,chn_cd -- 渠道代码
    ,allow_cust_group_list -- 允许客户组列表
    ,ctrl_flg -- 控制标志
    ,bta_ctrl_flg -- BTA控制标志
    ,charge_way_cd -- 收费方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,prod_attr_cd -- 产品属性代码
    ,risk_level_cd -- 风险等级代码
    ,status_cd -- 状态代码
    ,tran_flg -- 转换标志
    ,curr_cd -- 币种代码
    ,ec_flg -- 钞汇标志
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
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_min_redem_lot -- 机构单笔最小赎回份额
    ,org_sig_max_redem_lot -- 机构单笔最大赎回份额
    ,org_redem_corp -- 机构赎回单位
    ,org_lowt_fund_tran_lot -- 机构最低基金转换份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_acct_amax_bamt -- 机构单户累计最大购买金额
    ,coll_start_tm -- 募集开始时间
    ,buy_acct_id -- 购买账户编号
    ,redem_acct_id -- 赎回账户编号
    ,realtm_redem_adv_exp_acct_id -- 实时赎回垫支账户编号
    ,redem_cap_avl_days -- 赎回资金到账天数
    ,divd_cap_avl_days -- 分红资金到账天数
    ,prod_exp_cap_avl_days -- 产品到期资金到账天数
    ,huge_redem_ratio -- 巨额赎回比例
    ,prod_int_accr_base -- 产品计息基数
    ,subscr_int_accr_base -- 认购利息计息基数
    ,mgmt_fee_base_days -- 管理费基础天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,tard_way_cd -- 交易方式代码
    ,prod_tepla_id -- 产品模板编号
    ,supt_buy_way_cd -- 支持购买方式代码
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
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.prod_belong_cate_cd, o.prod_belong_cate_cd) as prod_belong_cate_cd -- 产品归属类别代码
    ,nvl(n.ref_yld_rat_comnt, o.ref_yld_rat_comnt) as ref_yld_rat_comnt -- 参考收益率说明
    ,nvl(n.prod_cbond_id, o.prod_cbond_id) as prod_cbond_id -- 产品中债编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_alias, o.prod_alias) as prod_alias -- 产品别名
    ,nvl(n.prod_nv, o.prod_nv) as prod_nv -- 产品净值
    ,nvl(n.prod_fac_val, o.prod_fac_val) as prod_fac_val -- 产品面值
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.prod_sponsor_cd, o.prod_sponsor_cd) as prod_sponsor_cd -- 产品发起人代码
    ,nvl(n.prod_trustee_cd, o.prod_trustee_cd) as prod_trustee_cd -- 产品托管人代码
    ,nvl(n.prod_mger_cd, o.prod_mger_cd) as prod_mger_cd -- 产品管理人代码
    ,nvl(n.prod_host_org_id, o.prod_host_org_id) as prod_host_org_id -- 产品主办机构编号
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.prod_found_dt, o.prod_found_dt) as prod_found_dt -- 产品成立日期
    ,nvl(n.prod_value_dt, o.prod_value_dt) as prod_value_dt -- 产品起息日期
    ,nvl(n.prod_end_dt, o.prod_end_dt) as prod_end_dt -- 产品结束日期
    ,nvl(n.prft_exp_dt, o.prft_exp_dt) as prft_exp_dt -- 收益到期日期
    ,nvl(n.coll_fail_dt, o.coll_fail_dt) as coll_fail_dt -- 募集失败日期
    ,nvl(n.coll_post_close_exp_day, o.coll_post_close_exp_day) as coll_post_close_exp_day -- 募集后封闭到期日
    ,nvl(n.actl_found_dt, o.actl_found_dt) as actl_found_dt -- 实际成立日期
    ,nvl(n.prod_lowt_coll_amt, o.prod_lowt_coll_amt) as prod_lowt_coll_amt -- 产品最低募集金额
    ,nvl(n.prod_higt_coll_amt, o.prod_higt_coll_amt) as prod_higt_coll_amt -- 产品最高募集金额
    ,nvl(n.prod_lowt_coll_lot, o.prod_lowt_coll_lot) as prod_lowt_coll_lot -- 产品最低募集份额
    ,nvl(n.prod_higt_coll_lot, o.prod_higt_coll_lot) as prod_higt_coll_lot -- 产品最高募集份额
    ,nvl(n.prod_actl_coll_amt, o.prod_actl_coll_amt) as prod_actl_coll_amt -- 产品实际募集金额
    ,nvl(n.curr_size, o.curr_size) as curr_size -- 当前规模
    ,nvl(n.allow_divd_way_cd, o.allow_divd_way_cd) as allow_divd_way_cd -- 允许的分红方式代码
    ,nvl(n.deflt_divd_way_cd, o.deflt_divd_way_cd) as deflt_divd_way_cd -- 默认分红方式代码
    ,nvl(n.sell_rg_ctrl_flg, o.sell_rg_ctrl_flg) as sell_rg_ctrl_flg -- 销售区域控制标志
    ,nvl(n.lmt_ctrl_flg, o.lmt_ctrl_flg) as lmt_ctrl_flg -- 额度控制标志
    ,nvl(n.coll_term_acct_mode_cd, o.coll_term_acct_mode_cd) as coll_term_acct_mode_cd -- 募集期账务模式代码
    ,nvl(n.open_term_acct_mode_cd, o.open_term_acct_mode_cd) as open_term_acct_mode_cd -- 开放期账务模式代码
    ,nvl(n.chn_cd, o.chn_cd) as chn_cd -- 渠道代码
    ,nvl(n.allow_cust_group_list, o.allow_cust_group_list) as allow_cust_group_list -- 允许客户组列表
    ,nvl(n.ctrl_flg, o.ctrl_flg) as ctrl_flg -- 控制标志
    ,nvl(n.bta_ctrl_flg, o.bta_ctrl_flg) as bta_ctrl_flg -- BTA控制标志
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.prft_embody_way_cd, o.prft_embody_way_cd) as prft_embody_way_cd -- 收益体现方式代码
    ,nvl(n.prod_attr_cd, o.prod_attr_cd) as prod_attr_cd -- 产品属性代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.tran_flg, o.tran_flg) as tran_flg -- 转换标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ec_flg, o.ec_flg) as ec_flg -- 钞汇标志
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
    ,nvl(n.indv_sig_max_buy_amt, o.indv_sig_max_buy_amt) as indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,nvl(n.indv_single_acct_amax_bamt, o.indv_single_acct_amax_bamt) as indv_single_acct_amax_bamt -- 个人单户累计最大购买金额
    ,nvl(n.org_min_buy_corp, o.org_min_buy_corp) as org_min_buy_corp -- 机构最小购买单位
    ,nvl(n.org_fir_lowt_invest_amt, o.org_fir_lowt_invest_amt) as org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,nvl(n.org_supp_lowt_invest_amt, o.org_supp_lowt_invest_amt) as org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,nvl(n.org_lowt_aip_amt, o.org_lowt_aip_amt) as org_lowt_aip_amt -- 机构最低定投金额
    ,nvl(n.org_lowt_hold_lot, o.org_lowt_hold_lot) as org_lowt_hold_lot -- 机构最低持有份额
    ,nvl(n.org_sig_min_redem_lot, o.org_sig_min_redem_lot) as org_sig_min_redem_lot -- 机构单笔最小赎回份额
    ,nvl(n.org_sig_max_redem_lot, o.org_sig_max_redem_lot) as org_sig_max_redem_lot -- 机构单笔最大赎回份额
    ,nvl(n.org_redem_corp, o.org_redem_corp) as org_redem_corp -- 机构赎回单位
    ,nvl(n.org_lowt_fund_tran_lot, o.org_lowt_fund_tran_lot) as org_lowt_fund_tran_lot -- 机构最低基金转换份额
    ,nvl(n.org_sig_max_buy_amt, o.org_sig_max_buy_amt) as org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,nvl(n.org_single_acct_amax_bamt, o.org_single_acct_amax_bamt) as org_single_acct_amax_bamt -- 机构单户累计最大购买金额
    ,nvl(n.coll_start_tm, o.coll_start_tm) as coll_start_tm -- 募集开始时间
    ,nvl(n.buy_acct_id, o.buy_acct_id) as buy_acct_id -- 购买账户编号
    ,nvl(n.redem_acct_id, o.redem_acct_id) as redem_acct_id -- 赎回账户编号
    ,nvl(n.realtm_redem_adv_exp_acct_id, o.realtm_redem_adv_exp_acct_id) as realtm_redem_adv_exp_acct_id -- 实时赎回垫支账户编号
    ,nvl(n.redem_cap_avl_days, o.redem_cap_avl_days) as redem_cap_avl_days -- 赎回资金到账天数
    ,nvl(n.divd_cap_avl_days, o.divd_cap_avl_days) as divd_cap_avl_days -- 分红资金到账天数
    ,nvl(n.prod_exp_cap_avl_days, o.prod_exp_cap_avl_days) as prod_exp_cap_avl_days -- 产品到期资金到账天数
    ,nvl(n.huge_redem_ratio, o.huge_redem_ratio) as huge_redem_ratio -- 巨额赎回比例
    ,nvl(n.prod_int_accr_base, o.prod_int_accr_base) as prod_int_accr_base -- 产品计息基数
    ,nvl(n.subscr_int_accr_base, o.subscr_int_accr_base) as subscr_int_accr_base -- 认购利息计息基数
    ,nvl(n.mgmt_fee_base_days, o.mgmt_fee_base_days) as mgmt_fee_base_days -- 管理费基础天数
    ,nvl(n.expe_yld_rat, o.expe_yld_rat) as expe_yld_rat -- 预期收益率
    ,nvl(n.ped_days, o.ped_days) as ped_days -- 周期天数
    ,nvl(n.tard_way_cd, o.tard_way_cd) as tard_way_cd -- 交易方式代码
    ,nvl(n.prod_tepla_id, o.prod_tepla_id) as prod_tepla_id -- 产品模板编号
    ,nvl(n.supt_buy_way_cd, o.supt_buy_way_cd) as supt_buy_way_cd -- 支持购买方式代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.finc_prod_id <> n.finc_prod_id
                or o.std_prod_id <> n.std_prod_id
                or o.prod_belong_cate_cd <> n.prod_belong_cate_cd
                or o.ref_yld_rat_comnt <> n.ref_yld_rat_comnt
                or o.prod_cbond_id <> n.prod_cbond_id
                or o.prod_cate_cd <> n.prod_cate_cd
                or o.ta_cd <> n.ta_cd
                or o.prod_name <> n.prod_name
                or o.prod_alias <> n.prod_alias
                or o.prod_nv <> n.prod_nv
                or o.prod_fac_val <> n.prod_fac_val
                or o.issue_price <> n.issue_price
                or o.prod_sponsor_cd <> n.prod_sponsor_cd
                or o.prod_trustee_cd <> n.prod_trustee_cd
                or o.prod_mger_cd <> n.prod_mger_cd
                or o.prod_host_org_id <> n.prod_host_org_id
                or o.coll_start_dt <> n.coll_start_dt
                or o.coll_end_dt <> n.coll_end_dt
                or o.prod_found_dt <> n.prod_found_dt
                or o.prod_value_dt <> n.prod_value_dt
                or o.prod_end_dt <> n.prod_end_dt
                or o.prft_exp_dt <> n.prft_exp_dt
                or o.coll_fail_dt <> n.coll_fail_dt
                or o.coll_post_close_exp_day <> n.coll_post_close_exp_day
                or o.actl_found_dt <> n.actl_found_dt
                or o.prod_lowt_coll_amt <> n.prod_lowt_coll_amt
                or o.prod_higt_coll_amt <> n.prod_higt_coll_amt
                or o.prod_lowt_coll_lot <> n.prod_lowt_coll_lot
                or o.prod_higt_coll_lot <> n.prod_higt_coll_lot
                or o.prod_actl_coll_amt <> n.prod_actl_coll_amt
                or o.curr_size <> n.curr_size
                or o.allow_divd_way_cd <> n.allow_divd_way_cd
                or o.deflt_divd_way_cd <> n.deflt_divd_way_cd
                or o.sell_rg_ctrl_flg <> n.sell_rg_ctrl_flg
                or o.lmt_ctrl_flg <> n.lmt_ctrl_flg
                or o.coll_term_acct_mode_cd <> n.coll_term_acct_mode_cd
                or o.open_term_acct_mode_cd <> n.open_term_acct_mode_cd
                or o.chn_cd <> n.chn_cd
                or o.allow_cust_group_list <> n.allow_cust_group_list
                or o.ctrl_flg <> n.ctrl_flg
                or o.bta_ctrl_flg <> n.bta_ctrl_flg
                or o.charge_way_cd <> n.charge_way_cd
                or o.prft_embody_way_cd <> n.prft_embody_way_cd
                or o.prod_attr_cd <> n.prod_attr_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.status_cd <> n.status_cd
                or o.tran_flg <> n.tran_flg
                or o.curr_cd <> n.curr_cd
                or o.ec_flg <> n.ec_flg
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
                or o.indv_sig_max_buy_amt <> n.indv_sig_max_buy_amt
                or o.indv_single_acct_amax_bamt <> n.indv_single_acct_amax_bamt
                or o.org_min_buy_corp <> n.org_min_buy_corp
                or o.org_fir_lowt_invest_amt <> n.org_fir_lowt_invest_amt
                or o.org_supp_lowt_invest_amt <> n.org_supp_lowt_invest_amt
                or o.org_lowt_aip_amt <> n.org_lowt_aip_amt
                or o.org_lowt_hold_lot <> n.org_lowt_hold_lot
                or o.org_sig_min_redem_lot <> n.org_sig_min_redem_lot
                or o.org_sig_max_redem_lot <> n.org_sig_max_redem_lot
                or o.org_redem_corp <> n.org_redem_corp
                or o.org_lowt_fund_tran_lot <> n.org_lowt_fund_tran_lot
                or o.org_sig_max_buy_amt <> n.org_sig_max_buy_amt
                or o.org_single_acct_amax_bamt <> n.org_single_acct_amax_bamt
                or o.coll_start_tm <> n.coll_start_tm
                or o.buy_acct_id <> n.buy_acct_id
                or o.redem_acct_id <> n.redem_acct_id
                or o.realtm_redem_adv_exp_acct_id <> n.realtm_redem_adv_exp_acct_id
                or o.redem_cap_avl_days <> n.redem_cap_avl_days
                or o.divd_cap_avl_days <> n.divd_cap_avl_days
                or o.prod_exp_cap_avl_days <> n.prod_exp_cap_avl_days
                or o.huge_redem_ratio <> n.huge_redem_ratio
                or o.prod_int_accr_base <> n.prod_int_accr_base
                or o.subscr_int_accr_base <> n.subscr_int_accr_base
                or o.mgmt_fee_base_days <> n.mgmt_fee_base_days
                or o.expe_yld_rat <> n.expe_yld_rat
                or o.ped_days <> n.ped_days
                or o.tard_way_cd <> n.tard_way_cd
                or o.prod_tepla_id <> n.prod_tepla_id
                or o.supt_buy_way_cd <> n.supt_buy_way_cd
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
from ${iml_schema}.prd_finc_ifmsf1_tm n
    full join ${iml_schema}.prd_finc_ifmsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_finc truncate partition for ('ifmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_finc exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.prd_finc_ifmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_finc drop subpartition p_ifmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_finc to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_finc_ifmsf1_tm purge;
drop table ${iml_schema}.prd_finc_ifmsf1_ex purge;
drop table ${iml_schema}.prd_finc_ifmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_finc', partname => 'p_ifmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);