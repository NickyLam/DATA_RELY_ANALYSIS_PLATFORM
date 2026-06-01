/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_bond_ibmsf1
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
drop table ${iml_schema}.prd_ibank_bond_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ibank_bond add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ibank_bond modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_bond_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_bond partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,shse_cd -- 上交所代码
    ,szse_cd -- 深交所代码
    ,bank_amg_cd -- 银行间代码
    ,curr_cd -- 币种代码
    ,cty_or_rg_cd -- 国家或地区代码
    ,quot_way_cd -- 报价方式代码
    ,issue_org_id -- 发行机构编号
    ,bond_intnal_id -- 债券内部编号
    ,cn_abbr -- 中文简称
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls_name -- 产品分类名称
    ,bond_cls_name -- 债券分类名称
    ,acctnt_cls_name -- 会计分类名称
    ,bond_fac_val -- 债券面值
    ,fac_val_int_rat -- 票面利率
    ,issue_price -- 发行价格
    ,issue_dt -- 债券发行日期
    ,list_dt -- 上市日期
    ,value_dt -- 债券起息日期
    ,exp_dt -- 债券到期日期
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,tenor_cd -- 期限代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,contn_weight_type_cd -- 含权类型代码
    ,pric_repay_type_cd -- 本金偿还类型代码
    ,caption_type_cd -- 资产化类型代码
    ,payoff_level_cd -- 清偿等级代码
    ,trust_market_id -- 托管市场编号
    ,rgst_market_id -- 登记市场编号
    ,issue_way_cd -- 发行方式代码
    ,actl_issue_size -- 实际发行规模
    ,issuer_id -- 发行人编号
    ,issuer_name -- 发行人名称
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_type_cd -- 票息类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,pay_int_cnt -- 付息次数
    ,fir_pay_int_dt -- 首次付息日期
    ,fir_int_accr_start_dt -- 首次计息开始日期
    ,fir_int_accr_exp_dt -- 首次计息到期日期
    ,pay_int_ped_cd -- 付息周期代码
    ,pay_int_adj_rule -- 付息调整规则
    ,int_accr_ped_cd -- 计息周期代码
    ,int_accr_adj_rule -- 计息调整规则
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_adj_rule -- 利率调整规则
    ,set_int_day_drift_ped_cd -- 定息日偏移周期代码
    ,set_int_day_adj_rule -- 定息日调整规则
    ,init_int_rat -- 初始利率
    ,init_int_rat_mult -- 初始利率倍数
    ,init_uplmi_int_rat -- 初始上限利率
    ,init_lolmi_int_rat -- 初始下限利率
    ,ex_type_cd -- 行权类型代码
    ,fir_ex_dt -- 首个行权日期
    ,fir_exec_price -- 首个执行价格
    ,fir_compst_int_rat -- 首个补偿利率
    ,public_issue_flg -- 公开发行标志
    ,effect_flg -- 生效标志
    ,updater_name -- 更新人名称
    ,checker_name -- 复核人名称
    ,std_prod_id -- 标准产品编号
    ,mgmt_mode_cd -- 管理模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,abs_flg -- 再资产证券化标志
    ,in_level_tot_amt -- 该档次总金额
    ,prod_currt_tot_bal_bilon -- 产品当期总余额(亿)
    ,hold_level_currt_bal_bilon -- 持有档次当期余额(亿)
    ,bond_item_rating_dt -- 债项评级日期
    ,main_rating_dt -- 主体评级日期
    ,main_rating_cd -- 主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,estate_bond_name -- 房地产债券类型名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ibank_bond_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ibank_bond partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_tbnd-b_p_class
insert into ${iml_schema}.prd_ibank_bond_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,shse_cd -- 上交所代码
    ,szse_cd -- 深交所代码
    ,bank_amg_cd -- 银行间代码
    ,curr_cd -- 币种代码
    ,cty_or_rg_cd -- 国家或地区代码
    ,quot_way_cd -- 报价方式代码
    ,issue_org_id -- 发行机构编号
    ,bond_intnal_id -- 债券内部编号
    ,cn_abbr -- 中文简称
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls_name -- 产品分类名称
    ,bond_cls_name -- 债券分类名称
    ,acctnt_cls_name -- 会计分类名称
    ,bond_fac_val -- 债券面值
    ,fac_val_int_rat -- 票面利率
    ,issue_price -- 发行价格
    ,issue_dt -- 债券发行日期
    ,list_dt -- 上市日期
    ,value_dt -- 债券起息日期
    ,exp_dt -- 债券到期日期
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,tenor_cd -- 期限代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,contn_weight_type_cd -- 含权类型代码
    ,pric_repay_type_cd -- 本金偿还类型代码
    ,caption_type_cd -- 资产化类型代码
    ,payoff_level_cd -- 清偿等级代码
    ,trust_market_id -- 托管市场编号
    ,rgst_market_id -- 登记市场编号
    ,issue_way_cd -- 发行方式代码
    ,actl_issue_size -- 实际发行规模
    ,issuer_id -- 发行人编号
    ,issuer_name -- 发行人名称
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_type_cd -- 票息类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,pay_int_cnt -- 付息次数
    ,fir_pay_int_dt -- 首次付息日期
    ,fir_int_accr_start_dt -- 首次计息开始日期
    ,fir_int_accr_exp_dt -- 首次计息到期日期
    ,pay_int_ped_cd -- 付息周期代码
    ,pay_int_adj_rule -- 付息调整规则
    ,int_accr_ped_cd -- 计息周期代码
    ,int_accr_adj_rule -- 计息调整规则
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_adj_rule -- 利率调整规则
    ,set_int_day_drift_ped_cd -- 定息日偏移周期代码
    ,set_int_day_adj_rule -- 定息日调整规则
    ,init_int_rat -- 初始利率
    ,init_int_rat_mult -- 初始利率倍数
    ,init_uplmi_int_rat -- 初始上限利率
    ,init_lolmi_int_rat -- 初始下限利率
    ,ex_type_cd -- 行权类型代码
    ,fir_ex_dt -- 首个行权日期
    ,fir_exec_price -- 首个执行价格
    ,fir_compst_int_rat -- 首个补偿利率
    ,public_issue_flg -- 公开发行标志
    ,effect_flg -- 生效标志
    ,updater_name -- 更新人名称
    ,checker_name -- 复核人名称
    ,std_prod_id -- 标准产品编号
    ,mgmt_mode_cd -- 管理模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,abs_flg -- 再资产证券化标志
    ,in_level_tot_amt -- 该档次总金额
    ,prod_currt_tot_bal_bilon -- 产品当期总余额(亿)
    ,hold_level_currt_bal_bilon -- 持有档次当期余额(亿)
    ,bond_item_rating_dt -- 债项评级日期
    ,main_rating_dt -- 主体评级日期
    ,main_rating_cd -- 主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,estate_bond_name -- 房地产债券类型名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,P1.SH_CODE -- 上交所代码
    ,P1.SZ_CODE -- 深交所代码
    ,P1.YH_CODE -- 银行间代码
    ,P1.CURRENCY -- 币种代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COUNTRY END -- 国家或地区代码
    ,P1.Q_TYPE -- 报价方式代码
    ,P1.B_ISSUER_CODE -- 发行机构编号
    ,P1.D_CODE -- 债券内部编号
    ,P1.CHINESESPELL -- 中文简称
    ,P1.B_NAME -- 债券名称
    ,replace(replace(replace(P1.B_NAME_FULL,chr(9),''),chr(10),''),chr(13),'') -- 债券全称
    ,P1.P_TYPE -- 产品类型代码
    ,P1.P_CLASS -- 产品分类名称
    ,P1.B_P_CLASS -- 债券分类名称
    ,P1.P_CLASS_ACT -- 会计分类名称
    ,P1.B_PAR_VALUE -- 债券面值
    ,P1.B_COUPON * 100 -- 票面利率
    ,P1.B_ISSUE_PRICE -- 发行价格
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_ISSUE_DATE) -- 债券发行日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_LIST_DATE) -- 上市日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_START_DATE) -- 债券起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.B_MTR_DATE) -- 债券到期日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.B_ACTUAL_MTR_DATE) -- 债券实际到期日期
    ,P1.B_TERM -- 期限代码
    ,P1.I_CODE_BENCH -- 基准利率编号
    ,P1.A_TYPE_BENCH -- 基准资产类型编号
    ,P1.M_TYPE_BENCH -- 基准市场类型编号
    ,P1.B_EMBOPT_TYPE -- 含权类型代码
    ,COALESCE(P1.B_AMORTIZING,'-') -- 本金偿还类型代码
    ,COALESCE(P1.B_AS_TYPE,'000') -- 资产化类型代码
    ,UPPER(SUBSTR(P1.B_SENIORITY,1,3)) -- 清偿等级代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.HOST_MARKET END -- 托管市场编号
    ,P1.BJ_MARKET -- 登记市场编号
    ,P1.B_ISSUE_MODE -- 发行方式代码
    ,P1.B_ACTUAL_ISSUE_AMOUNT -- 实际发行规模
    ,P1.ISSUER_ID -- 发行人编号
    ,P1.B_ISSUER -- 发行人名称
    ,P1.WARRANTOR_ID -- 担保人编号
    ,P1.B_WARRANTOR -- 担保人名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.B_DAYCOUNT END -- 计息基准代码
    ,P1.B_COUPON_TYPE -- 票息类型代码
    ,P1.B_COUPON_TYPE -- 利率调整方式代码
    ,P1.B_CASH_TIMES -- 付息次数
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_FST_PAY_DATE) -- 首次付息日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_FST_REG_CALC_START_DATE) -- 首次计息开始日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_INITIAL_FIXING_DATE) -- 首次计息到期日期
    ,case when trim(p1.b_pay_freq) is null then
        '0D'
       else
        (case when p1.b_pay_freq = 'irreg' then
           '0D'
          else
           p1.b_pay_freq
        end)
     end -- 付息周期代码
    ,P1.B_PAY_BIZDAY_CONVERTION -- 付息调整规则
    ,P1.B_CALC_FREQ -- 计息周期代码
    ,P1.B_CALC_BIZDAY_CONVERTION -- 计息调整规则
    ,P1.B_RESET_FREQ -- 利率调整周期代码
    ,P1.B_RESET_BIZDAY_CONVERTION -- 利率调整规则
    ,P1.B_FIXING_DATES_OFFSET -- 定息日偏移周期代码
    ,P1.B_FIXING_BIZDAY_CONVERTION -- 定息日调整规则
    ,P1.B_INITIAL_RATE -- 初始利率
    ,P1.B_MULTIPLIER -- 初始利率倍数
    ,P1.B_CAP_RATE -- 初始上限利率
    ,P1.B_FLOOR_RATE -- 初始下限利率
    ,COALESCE(TRIM(P1.B_EXERCISE_STYLE),'-') -- 行权类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.B_EXERCISE_DATE) -- 首个行权日期
    ,P1.B_STRIKE_PRICE -- 首个执行价格
    ,P1.B_COMPENSATION_RATE -- 首个补偿利率
    ,COALESCE(TRIM(P1.PUBLIC_ISSUE),'-') -- 公开发行标志
    ,COALESCE(TRIM(P1.USABLE_FLAG),'-') -- 生效标志
    ,P1.UPDATE_USER -- 更新人名称
    ,P1.ACCOUNT_USER -- 复核人名称
    ,nvl(P2.prod_code,' ') -- 标准产品编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.MANAGE_MODE END -- 管理模式代码
    ,case when trim(P1.B_PAY_FREQ) is null then  '0D' 
          when P1.B_PAY_FREQ='irreg' then 'IR'
      else P1.B_PAY_FREQ  end -- 源付息周期代码
    ,nvl(trim(P3.HXABS_AGAINABS),'-') -- 再资产证券化标志
    ,nvl(P3.HX_AMOUNT_LEVEL,0.00) -- 该档次总金额
    ,nvl(P3.HX_BLC,0.00000000) -- 产品当期总余额(亿)
    ,nvl(P3.HX_BLC_LEVEL,0.00000000)  -- 持有档次当期余额(亿)
    ,${iml_schema}.DATEFORMAT_MAX2(P3.HX_GRADE_DATE_BOND) -- 债项评级日期
    ,${iml_schema}.DATEFORMAT_MAX2(P3.HX_GRADE_DATE_INST) -- 主体评级日期
    ,nvl(trim(P3.HX_INST_GRADE),'-') -- 主体评级代码
    ,nvl(trim(P3.HX_INST_GRADE_ORG),' ') -- 主体评级机构名称
    ,decode(trim(P3.HX_IS_STC),'是','1','否','0','','-',P3.HX_IS_STC) -- STC标志
    ,decode(trim(P3.HX_PRIORITY_LEVEL),'优先','1','非优先','0','','-',P3.HX_PRIORITY_LEVEL) -- 优先档次标志
    ,nvl(trim(P3.HX_ESTATE_BOND_TYPE),' ') -- 房地产债券类型名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tbnd' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ibms_tbnd p1
  left join ${iol_schema}.ibms_ttrd_instrument p2
    on p1.i_code = p2.i_code
   and p1.a_type = p2.a_type
   and p1.m_type = p2.m_type
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_trpt_tbnd_ext p3
    on p1.i_code = p3.i_code
   and p1.a_type = p3.a_type
   and p1.m_type = p3.m_type
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.country = r2.src_code_val
   and r2.sorc_sys_cd = 'IBMS'
   and r2.src_tab_en_name = 'IBMS_TBND'
   and r2.src_field_en_name = 'COUNTRY'
   and r2.target_tab_en_name = 'PRD_IBANK_BOND'
   and r2.target_tab_field_en_name = 'CTY_OR_RG_CD'
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.b_daycount = r3.src_code_val
   and r3.sorc_sys_cd = 'IBMS'
   and r3.src_tab_en_name = 'IBMS_TBND'
   and r3.src_field_en_name = 'B_DAYCOUNT'
   and r3.target_tab_en_name = 'PRD_IBANK_BOND'
   and r3.target_tab_field_en_name = 'INT_ACCR_BASE_CD'
  left join ${iml_schema}.ref_pub_cd_map r5
    on p1.manage_mode = r5.src_code_val
   and r5.sorc_sys_cd = 'IBMS'
   and r5.src_tab_en_name = 'IBMS_TBND'
   and r5.src_field_en_name = 'MANAGE_MODE'
   and r5.target_tab_en_name = 'PRD_IBANK_BOND'
   and r5.target_tab_field_en_name = 'MGMT_MODE_CD'
  left join ${iml_schema}.ref_pub_cd_map r6
    on p1.host_market = r6.src_code_val
   and r6.sorc_sys_cd = 'IBMS'
   and r6.src_tab_en_name = 'IBMS_TBND'
   and r6.src_field_en_name = 'HOST_MARKET'
   and r6.target_tab_en_name = 'PRD_IBANK_BOND'
   and r6.target_tab_field_en_name = 'TRUST_MARKET_ID'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_bond_ibmsf1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
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
insert /*+ append */ into ${iml_schema}.prd_ibank_bond_ibmsf1_ex(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,shse_cd -- 上交所代码
    ,szse_cd -- 深交所代码
    ,bank_amg_cd -- 银行间代码
    ,curr_cd -- 币种代码
    ,cty_or_rg_cd -- 国家或地区代码
    ,quot_way_cd -- 报价方式代码
    ,issue_org_id -- 发行机构编号
    ,bond_intnal_id -- 债券内部编号
    ,cn_abbr -- 中文简称
    ,bond_name -- 债券名称
    ,bond_fname -- 债券全称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls_name -- 产品分类名称
    ,bond_cls_name -- 债券分类名称
    ,acctnt_cls_name -- 会计分类名称
    ,bond_fac_val -- 债券面值
    ,fac_val_int_rat -- 票面利率
    ,issue_price -- 发行价格
    ,issue_dt -- 债券发行日期
    ,list_dt -- 上市日期
    ,value_dt -- 债券起息日期
    ,exp_dt -- 债券到期日期
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,tenor_cd -- 期限代码
    ,base_rat_id -- 基准利率编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,contn_weight_type_cd -- 含权类型代码
    ,pric_repay_type_cd -- 本金偿还类型代码
    ,caption_type_cd -- 资产化类型代码
    ,payoff_level_cd -- 清偿等级代码
    ,trust_market_id -- 托管市场编号
    ,rgst_market_id -- 登记市场编号
    ,issue_way_cd -- 发行方式代码
    ,actl_issue_size -- 实际发行规模
    ,issuer_id -- 发行人编号
    ,issuer_name -- 发行人名称
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,int_accr_base_cd -- 计息基准代码
    ,coupon_type_cd -- 票息类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,pay_int_cnt -- 付息次数
    ,fir_pay_int_dt -- 首次付息日期
    ,fir_int_accr_start_dt -- 首次计息开始日期
    ,fir_int_accr_exp_dt -- 首次计息到期日期
    ,pay_int_ped_cd -- 付息周期代码
    ,pay_int_adj_rule -- 付息调整规则
    ,int_accr_ped_cd -- 计息周期代码
    ,int_accr_adj_rule -- 计息调整规则
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_adj_rule -- 利率调整规则
    ,set_int_day_drift_ped_cd -- 定息日偏移周期代码
    ,set_int_day_adj_rule -- 定息日调整规则
    ,init_int_rat -- 初始利率
    ,init_int_rat_mult -- 初始利率倍数
    ,init_uplmi_int_rat -- 初始上限利率
    ,init_lolmi_int_rat -- 初始下限利率
    ,ex_type_cd -- 行权类型代码
    ,fir_ex_dt -- 首个行权日期
    ,fir_exec_price -- 首个执行价格
    ,fir_compst_int_rat -- 首个补偿利率
    ,public_issue_flg -- 公开发行标志
    ,effect_flg -- 生效标志
    ,updater_name -- 更新人名称
    ,checker_name -- 复核人名称
    ,std_prod_id -- 标准产品编号
    ,mgmt_mode_cd -- 管理模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,abs_flg -- 再资产证券化标志
    ,in_level_tot_amt -- 该档次总金额
    ,prod_currt_tot_bal_bilon -- 产品当期总余额(亿)
    ,hold_level_currt_bal_bilon -- 持有档次当期余额(亿)
    ,bond_item_rating_dt -- 债项评级日期
    ,main_rating_dt -- 主体评级日期
    ,main_rating_cd -- 主体评级代码
    ,main_rating_org_name -- 主体评级机构名称
    ,stc_flg -- STC标志
    ,prior_level_flg -- 优先档次标志
    ,estate_bond_name -- 房地产债券类型名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.shse_cd, o.shse_cd) as shse_cd -- 上交所代码
    ,nvl(n.szse_cd, o.szse_cd) as szse_cd -- 深交所代码
    ,nvl(n.bank_amg_cd, o.bank_amg_cd) as bank_amg_cd -- 银行间代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cty_or_rg_cd, o.cty_or_rg_cd) as cty_or_rg_cd -- 国家或地区代码
    ,nvl(n.quot_way_cd, o.quot_way_cd) as quot_way_cd -- 报价方式代码
    ,nvl(n.issue_org_id, o.issue_org_id) as issue_org_id -- 发行机构编号
    ,nvl(n.bond_intnal_id, o.bond_intnal_id) as bond_intnal_id -- 债券内部编号
    ,nvl(n.cn_abbr, o.cn_abbr) as cn_abbr -- 中文简称
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.bond_fname, o.bond_fname) as bond_fname -- 债券全称
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_cls_name, o.prod_cls_name) as prod_cls_name -- 产品分类名称
    ,nvl(n.bond_cls_name, o.bond_cls_name) as bond_cls_name -- 债券分类名称
    ,nvl(n.acctnt_cls_name, o.acctnt_cls_name) as acctnt_cls_name -- 会计分类名称
    ,nvl(n.bond_fac_val, o.bond_fac_val) as bond_fac_val -- 债券面值
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 债券发行日期
    ,nvl(n.list_dt, o.list_dt) as list_dt -- 上市日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 债券起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 债券到期日期
    ,nvl(n.bond_actl_exp_dt, o.bond_actl_exp_dt) as bond_actl_exp_dt -- 债券实际到期日期
    ,nvl(n.tenor_cd, o.tenor_cd) as tenor_cd -- 期限代码
    ,nvl(n.base_rat_id, o.base_rat_id) as base_rat_id -- 基准利率编号
    ,nvl(n.base_asset_type_id, o.base_asset_type_id) as base_asset_type_id -- 基准资产类型编号
    ,nvl(n.base_market_type_id, o.base_market_type_id) as base_market_type_id -- 基准市场类型编号
    ,nvl(n.contn_weight_type_cd, o.contn_weight_type_cd) as contn_weight_type_cd -- 含权类型代码
    ,nvl(n.pric_repay_type_cd, o.pric_repay_type_cd) as pric_repay_type_cd -- 本金偿还类型代码
    ,nvl(n.caption_type_cd, o.caption_type_cd) as caption_type_cd -- 资产化类型代码
    ,nvl(n.payoff_level_cd, o.payoff_level_cd) as payoff_level_cd -- 清偿等级代码
    ,nvl(n.trust_market_id, o.trust_market_id) as trust_market_id -- 托管市场编号
    ,nvl(n.rgst_market_id, o.rgst_market_id) as rgst_market_id -- 登记市场编号
    ,nvl(n.issue_way_cd, o.issue_way_cd) as issue_way_cd -- 发行方式代码
    ,nvl(n.actl_issue_size, o.actl_issue_size) as actl_issue_size -- 实际发行规模
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.issuer_name, o.issuer_name) as issuer_name -- 发行人名称
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.coupon_type_cd, o.coupon_type_cd) as coupon_type_cd -- 票息类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.pay_int_cnt, o.pay_int_cnt) as pay_int_cnt -- 付息次数
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.fir_int_accr_start_dt, o.fir_int_accr_start_dt) as fir_int_accr_start_dt -- 首次计息开始日期
    ,nvl(n.fir_int_accr_exp_dt, o.fir_int_accr_exp_dt) as fir_int_accr_exp_dt -- 首次计息到期日期
    ,nvl(n.pay_int_ped_cd, o.pay_int_ped_cd) as pay_int_ped_cd -- 付息周期代码
    ,nvl(n.pay_int_adj_rule, o.pay_int_adj_rule) as pay_int_adj_rule -- 付息调整规则
    ,nvl(n.int_accr_ped_cd, o.int_accr_ped_cd) as int_accr_ped_cd -- 计息周期代码
    ,nvl(n.int_accr_adj_rule, o.int_accr_adj_rule) as int_accr_adj_rule -- 计息调整规则
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_adj_rule, o.int_rat_adj_rule) as int_rat_adj_rule -- 利率调整规则
    ,nvl(n.set_int_day_drift_ped_cd, o.set_int_day_drift_ped_cd) as set_int_day_drift_ped_cd -- 定息日偏移周期代码
    ,nvl(n.set_int_day_adj_rule, o.set_int_day_adj_rule) as set_int_day_adj_rule -- 定息日调整规则
    ,nvl(n.init_int_rat, o.init_int_rat) as init_int_rat -- 初始利率
    ,nvl(n.init_int_rat_mult, o.init_int_rat_mult) as init_int_rat_mult -- 初始利率倍数
    ,nvl(n.init_uplmi_int_rat, o.init_uplmi_int_rat) as init_uplmi_int_rat -- 初始上限利率
    ,nvl(n.init_lolmi_int_rat, o.init_lolmi_int_rat) as init_lolmi_int_rat -- 初始下限利率
    ,nvl(n.ex_type_cd, o.ex_type_cd) as ex_type_cd -- 行权类型代码
    ,nvl(n.fir_ex_dt, o.fir_ex_dt) as fir_ex_dt -- 首个行权日期
    ,nvl(n.fir_exec_price, o.fir_exec_price) as fir_exec_price -- 首个执行价格
    ,nvl(n.fir_compst_int_rat, o.fir_compst_int_rat) as fir_compst_int_rat -- 首个补偿利率
    ,nvl(n.public_issue_flg, o.public_issue_flg) as public_issue_flg -- 公开发行标志
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.updater_name, o.updater_name) as updater_name -- 更新人名称
    ,nvl(n.checker_name, o.checker_name) as checker_name -- 复核人名称
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.mgmt_mode_cd, o.mgmt_mode_cd) as mgmt_mode_cd -- 管理模式代码
    ,nvl(n.src_pay_int_ped_cd, o.src_pay_int_ped_cd) as src_pay_int_ped_cd -- 源付息周期代码
    ,nvl(n.abs_flg, o.abs_flg) as abs_flg -- 再资产证券化标志
    ,nvl(n.in_level_tot_amt, o.in_level_tot_amt) as in_level_tot_amt -- 该档次总金额
    ,nvl(n.prod_currt_tot_bal_bilon, o.prod_currt_tot_bal_bilon) as prod_currt_tot_bal_bilon -- 产品当期总余额(亿)
    ,nvl(n.hold_level_currt_bal_bilon, o.hold_level_currt_bal_bilon) as hold_level_currt_bal_bilon -- 持有档次当期余额(亿)
    ,nvl(n.bond_item_rating_dt, o.bond_item_rating_dt) as bond_item_rating_dt -- 债项评级日期
    ,nvl(n.main_rating_dt, o.main_rating_dt) as main_rating_dt -- 主体评级日期
    ,nvl(n.main_rating_cd, o.main_rating_cd) as main_rating_cd -- 主体评级代码
    ,nvl(n.main_rating_org_name, o.main_rating_org_name) as main_rating_org_name -- 主体评级机构名称
    ,nvl(n.stc_flg, o.stc_flg) as stc_flg -- STC标志
    ,nvl(n.prior_level_flg, o.prior_level_flg) as prior_level_flg -- 优先档次标志
    ,nvl(n.estate_bond_name, o.estate_bond_name) as estate_bond_name -- 房地产债券类型名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.fin_instm_id is null
                and o.asset_type_id is null
                and o.market_type_id is null
                and o.lp_id is null
            ) or (
                o.shse_cd <> n.shse_cd
                or o.szse_cd <> n.szse_cd
                or o.bank_amg_cd <> n.bank_amg_cd
                or o.curr_cd <> n.curr_cd
                or o.cty_or_rg_cd <> n.cty_or_rg_cd
                or o.quot_way_cd <> n.quot_way_cd
                or o.issue_org_id <> n.issue_org_id
                or o.bond_intnal_id <> n.bond_intnal_id
                or o.cn_abbr <> n.cn_abbr
                or o.bond_name <> n.bond_name
                or o.bond_fname <> n.bond_fname
                or o.prod_type_cd <> n.prod_type_cd
                or o.prod_cls_name <> n.prod_cls_name
                or o.bond_cls_name <> n.bond_cls_name
                or o.acctnt_cls_name <> n.acctnt_cls_name
                or o.bond_fac_val <> n.bond_fac_val
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.issue_price <> n.issue_price
                or o.issue_dt <> n.issue_dt
                or o.list_dt <> n.list_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.bond_actl_exp_dt <> n.bond_actl_exp_dt
                or o.tenor_cd <> n.tenor_cd
                or o.base_rat_id <> n.base_rat_id
                or o.base_asset_type_id <> n.base_asset_type_id
                or o.base_market_type_id <> n.base_market_type_id
                or o.contn_weight_type_cd <> n.contn_weight_type_cd
                or o.pric_repay_type_cd <> n.pric_repay_type_cd
                or o.caption_type_cd <> n.caption_type_cd
                or o.payoff_level_cd <> n.payoff_level_cd
                or o.trust_market_id <> n.trust_market_id
                or o.rgst_market_id <> n.rgst_market_id
                or o.issue_way_cd <> n.issue_way_cd
                or o.actl_issue_size <> n.actl_issue_size
                or o.issuer_id <> n.issuer_id
                or o.issuer_name <> n.issuer_name
                or o.guartor_id <> n.guartor_id
                or o.guartor_name <> n.guartor_name
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.coupon_type_cd <> n.coupon_type_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.pay_int_cnt <> n.pay_int_cnt
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.fir_int_accr_start_dt <> n.fir_int_accr_start_dt
                or o.fir_int_accr_exp_dt <> n.fir_int_accr_exp_dt
                or o.pay_int_ped_cd <> n.pay_int_ped_cd
                or o.pay_int_adj_rule <> n.pay_int_adj_rule
                or o.int_accr_ped_cd <> n.int_accr_ped_cd
                or o.int_accr_adj_rule <> n.int_accr_adj_rule
                or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
                or o.int_rat_adj_rule <> n.int_rat_adj_rule
                or o.set_int_day_drift_ped_cd <> n.set_int_day_drift_ped_cd
                or o.set_int_day_adj_rule <> n.set_int_day_adj_rule
                or o.init_int_rat <> n.init_int_rat
                or o.init_int_rat_mult <> n.init_int_rat_mult
                or o.init_uplmi_int_rat <> n.init_uplmi_int_rat
                or o.init_lolmi_int_rat <> n.init_lolmi_int_rat
                or o.ex_type_cd <> n.ex_type_cd
                or o.fir_ex_dt <> n.fir_ex_dt
                or o.fir_exec_price <> n.fir_exec_price
                or o.fir_compst_int_rat <> n.fir_compst_int_rat
                or o.public_issue_flg <> n.public_issue_flg
                or o.effect_flg <> n.effect_flg
                or o.updater_name <> n.updater_name
                or o.checker_name <> n.checker_name
                or o.std_prod_id <> n.std_prod_id
                or o.mgmt_mode_cd <> n.mgmt_mode_cd
                or o.src_pay_int_ped_cd <> n.src_pay_int_ped_cd
                or o.abs_flg <> n.abs_flg
                or o.in_level_tot_amt <> n.in_level_tot_amt
                or o.prod_currt_tot_bal_bilon <> n.prod_currt_tot_bal_bilon
                or o.hold_level_currt_bal_bilon <> n.hold_level_currt_bal_bilon
                or o.bond_item_rating_dt <> n.bond_item_rating_dt
                or o.main_rating_dt <> n.main_rating_dt
                or o.main_rating_cd <> n.main_rating_cd
                or o.main_rating_org_name <> n.main_rating_org_name
                or o.stc_flg <> n.stc_flg
                or o.prior_level_flg <> n.prior_level_flg
                or o.estate_bond_name <> n.estate_bond_name
            ) or (
                 case when (
                           n.fin_instm_id is null
                           and n.asset_type_id is null
                           and n.market_type_id is null
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
                n.fin_instm_id is null
                and n.asset_type_id is null
                and n.market_type_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_ibmsf1_tm n
    full join ${iml_schema}.prd_ibank_bond_ibmsf1_bk o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ibank_bond truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ibank_bond exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_bond_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ibank_bond drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_bond to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ibank_bond_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_ibmsf1_ex purge;
drop table ${iml_schema}.prd_ibank_bond_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_bond', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);