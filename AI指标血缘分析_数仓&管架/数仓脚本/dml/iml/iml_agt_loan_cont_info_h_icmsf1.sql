/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_cont_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_cont_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_cont_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_cont_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_contract-1
insert into ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300002'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 合同编号
    ,P1.BAPSERIALNO -- 审批流水号
    ,P1.RELACONTRACTNO -- 关联合同编号
    ,P1.ARTIFICIALNO -- 文本合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,decode(P1.BUSINESSFLAG,'1','01','2','02','00',P1.BUSINESSFLAG) -- 额度合同标志
    ,P1.OLDCONTRACTNO -- 关联旧合同编号
    ,nvl(trim(P1.APPLYTYPE),'-') -- 申请方式代码
    ,nvl(trim(P1.OCCURTYPE),'-') -- 贷款发放类型代码
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,P1.OCCURDATE -- 发生日期
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.BUSINESSSUM -- 合同金额
    ,P1.PUTOUTSUM -- 实际出账金额
    ,P1.PUTOUTDATE -- 出账日期
    ,P1.BASEPRODUCT -- 基础产品编号
    ,P1.PRODUCTID -- 产品编号
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,P1.STARTDATE -- 合同生效日期
    ,decode(P1.MATURITY,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.MATURITY) -- 合同到期日期
    ,nvl(trim(P1.ISCYCLE),'-') -- 循环贷款标志
    ,nvl(trim(P1.RISKTYPE),'-') -- 风险类型代码
    ,nvl(trim(P1.ISLOWRISK),'-') -- 低风险业务标志
    ,nvl(trim(P1.ISREMOTEBUSINESS),'-') -- 异地业务标志
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,P1.FIXEDRATE -- 固定利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动类型代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,P1.FLOATRANGE -- 利率浮动值
    ,P1.EXECUTERATE -- 执行利率
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,decode(P1.HAVEADDITIONALVOUCH,null,'-','2','0',P1.HAVEADDITIONALVOUCH) -- 追加担保方式标志
    ,P1.ADDITIONCOMMAND -- 其他条件描述
    ,nvl(trim(P1.VOUCHTYPE2),'-') -- 担保方式代码二
    ,nvl(trim(P1.VOUCHTYPE3),'-') -- 担保方式代码三
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,nvl(trim(P1.VOUCHTYPEINNER),'-') -- 子担保方式代码
    ,case when P1.REPAYCYCLE='06' then '1'  
        else nvl(substr( P1.REPAYCYCLE,2,1),0) 
      end -- 还款周期
    ,case when P1.REPAYCYCLE='06' then 'O'
       else nvl(substr( P1.REPAYCYCLE,1,1),'-') 
      end -- 还款周期单位代码
    ,P1.REPAYDATE -- 默认还款日
    ,P1.SETTLEMENTACCOUNT -- 结算账户编号
    ,nvl(trim(P1.CREDITINVEST),'-') -- 授信投向代码
    ,nvl(trim(P1.NATIONALINDUSTRYTYPE),'-') -- 国标行业投向代码
    ,nvl(trim(P1.INTRAINDUSTRYTYPE),'-') -- 行内行业投向代码
    ,P1.PURPOSE -- 用途描述
    ,decode(trim(P1.COMPLETEFLAG),'','-','2','0',P1.COMPLETEFLAG) -- 数据录入已完善标志
    ,P1.RESERVESUM -- 预留金额
    ,P1.BALANCE -- 当前余额
    ,P1.NORMALBALANCE -- 正常余额
    ,P1.OVERDUEBALANCE -- 贷款逾期金额
    ,P1.DULLBALANCE -- 呆滞余额
    ,P1.BADBALANCE -- 呆账余额
    ,P1.INNERINTERESTBALANCE -- 表内欠息余额
    ,P1.OUTERINTERESTBALANCE -- 表外欠息余额
    ,P1.CAPITALPENALTYBALANCE -- 逾期罚息余额
    ,P1.INTERESTPENALTYBALANCE -- 复息余额
    ,P1.OVERDUEDAYS -- 贷款逾期天数
    ,P1.OWNINTERESTDAYS -- 欠息天数
    ,P1.CANCELSUM -- 核销本金
    ,P1.CANCELINTEREST -- 核销利息
    ,P1.PREDICTLOSTSUM -- 预测损失金额
    ,P1.BADCONFIRMDATE -- 首次认定不良日期
    ,nvl(trim(P1.STATUS),'9') -- 合同状态代码
    ,P1.EFFECTDATE -- 生效日期
    ,P1.FINISHDATE -- 终止日期
    ,P1.FINISHFLAG -- 结清标志
    ,nvl(trim(P1.OFFSHEETFLAG),'-') -- 表外标志
    ,P1.ISONLINEBUSINESS -- 线上业务标志
    ,nvl(trim(P1.BELONGDEPT),'-') -- 所属条线代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.CLNO -- 额度编号
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.OPERATEDATE -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,nvl(trim(P1.PAYFREQUENCYUNIT),'-') -- 指定周期单位代码
    ,nvl(trim(P1.PAYFREQUENCY),'-') -- 指定周期代码
    ,P1.RENEWTERMDATE -- 展期前到期日期
    ,P1.RENEWTOTALSUM -- 展期前金额
    ,P1.RENEWEXECUTEYEARRATE -- 展期前执行年利率
    ,nvl(trim(P1.ISBANKREL),'-') -- 我行关联方标志
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.TOTALSUM -- 额度敞口金额
    ,P1.OUTSTNDLMT -- 已占用额度
    ,nvl(trim(P1.BAILCURRENCY),'-') -- 保证金币种代码
    ,P1.BAILRATIO -- 保证金比例
    ,P1.BAILSUM -- 保证金金额
    ,P1.TOTALBALANCE -- 敞口金额
    ,P1.STATISTICSTOTALBALANCE -- 敞口金额统计
    ,P1.CREDITAGGREEMENT -- 额度合同编号
    ,P1.EXECUTEMONTHRATE -- 执行月利率
    ,nvl(trim(P1.REMART),'-') -- 资产三分类代码
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码 -- 五级分类代码
    ,P1.CLASSIFYDATE -- 五级分类日期
    ,nvl(trim(P1.CLASSIFYRESULTELEVEN),'20') -- 十一级分类代码
    ,P1.MANAGEUSERID -- 贷后管理柜员编号
    ,P1.MANAGEORGID -- 贷后管理机构编号
    ,${iml_schema}.dateformat_max2(P1.PIGEONHOLEDATE) -- 归档日期
    ,P1.FREEZEFLAG -- 冻结状态代码
    ,P1.OVERDUERATE -- 逾期执行利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,P1.PUTOUTORGID -- 核心出账机构编号
    ,P1.SETTLEMENTACCOUNTNAME -- 结算账户名称
    ,P1.LOANACCOUNTNO -- 入账账户编号
    ,P1.LOANACCOUNTNAME -- 入账账户名称
    ,P1.LOANACCOUNTORGID -- 入账账户开户机构编号
    ,P1.OLDSTATUS -- 备份状态代码
    ,P1.OLDCREDITAGGREEMENT -- 备份额度合同编号
    ,P1.PDGRATIO -- 手续费率
    ,P1.MIGTFLAG -- 迁移备注
    ,nvl(trim(P1.STRATEGICEMERGINGINDUSTRYTYPE),'-') -- 战略新兴产业类型代码
    ,nvl(trim(P1.isgxtechent),'-') -- 高新技术企业标志
    ,nvl(trim(P1.isscitechent),'-') -- 科技企业标志
    ,nvl(trim(P1.iskctechent),'-') -- 科创企业标志
    ,nvl(trim(P1.ISXXDQUOTA),'-') -- 新兴贷营销额度标志
    ,nvl(trim(P1.ISPENSIONINDUSTRY),'-') -- 养老产业标志
    ,nvl(trim(P1.IFSEEDLOAN),'-') -- 种业振兴贷款标志
    ,nvl(trim(P1.IFCOUNTYLOAN),'-') -- 县城城区贷款标志
    ,nvl(trim(P1.IFHIGHINDUSTRY),'-') -- 投向高技术产业标志
    ,nvl(trim(P1.NUMBERECONOMYTYPE),'-') -- 数字经济核心产业类型代码
    ,P1.REMARK -- 备注
    ,P1.PRODUCTCLASSIFY -- 产品大类编号
    ,P1.MIGTBUSINESSTYPE -- 转换前产品编号
    ,P1.MIGTCUSTOMERID -- 转换前客户编号
    ,nvl(trim(P1.REINFORCEFLAG),'-') -- 补登业务类型代码
    ,P1.BAILACCOUNT -- 保证金账户编号
    ,P1.BAILTRANSACCOUNT -- 保证金转出账户编号
    ,P1.TRANSFORMTIMES -- 更新次数
    ,P1.BDSERIALNO -- 借据编号
    ,nvl(trim(P1.ISSIGNEDCONTRACT),'-') -- 签订额度合同标志
    ,nvl(trim(P1.ISPAGERCONTRACT),'-') -- 签署纸质合同标志
    ,P1.PDGSUM -- 手续费金额
    ,P1.ICMSAPPROVEAMOUT -- 信贷审批可用金额
    ,P1.CONTRACTNOBEFOREEXTEND -- 展期前合同编号
    ,decode(P1.USEEXPOSURETYPE,'0','01','1','03',' ','-',P1.USEEXPOSURETYPE) -- 占用敞口额度风险类型代码
    ,nvl(trim(P1.ISOCCUPYCREDIT),'-') -- 占用他用额度标志
    ,P1.RISKAPPROVEAMOUT -- 风控审批可用金额
    ,P1.IFCAPPROVEBALANCE -- IFC数总审批可用金额
    ,P1.IFCAPPROVEAMOUNT -- IFC审批后额度合同金额
    ,nvl(trim(P1.WHETHERTORESTRUCTURETHELOAN),'-') -- 重组贷款标志
    ,nvl(trim(P1.ONLYNEWSMALLENTFLAG),'-') -- 专精特新小巨人企业标志
    ,nvl(trim(P1.ONLYNEWENTFLAG),'-') -- 专精特新中小企业标志
    ,nvl(trim(P1.TRANSFORMATIONANDUPGRADEID),'-') -- 工业企业技术改造升级标志
    ,nvl(trim(P1.CULTUREINDUSTRYFLAG),'-') -- 文化产业标志
    ,nvl(trim(P1.ADVANCEDMANUFLAG),'-') -- 先进制造业标志
    ,nvl(trim(P1.ISQUERYCREDITREPORT),'-') -- 自动查询贷后报告标志
    ,nvl(trim(P1.COMTICKETRECOURSEFLAG),'-') -- 商票保贴追索标志
    ,nvl(trim(P1.BIZCONTRWTHRDISCTPERS),'-') -- 贴现人保证金账户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_contract p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,cont_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.apv_flow_num, o.apv_flow_num) as apv_flow_num -- 审批流水号
    ,nvl(n.rela_cont_id, o.rela_cont_id) as rela_cont_id -- 关联合同编号
    ,nvl(n.text_cont_id, o.text_cont_id) as text_cont_id -- 文本合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.lmt_cont_flg, o.lmt_cont_flg) as lmt_cont_flg -- 额度合同标志
    ,nvl(n.rela_old_cont_id, o.rela_old_cont_id) as rela_old_cont_id -- 关联旧合同编号
    ,nvl(n.appl_way_cd, o.appl_way_cd) as appl_way_cd -- 申请方式代码
    ,nvl(n.loan_distr_type_cd, o.loan_distr_type_cd) as loan_distr_type_cd -- 贷款发放类型代码
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 发生日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.actl_out_acct_amt, o.actl_out_acct_amt) as actl_out_acct_amt -- 实际出账金额
    ,nvl(n.out_acct_dt, o.out_acct_dt) as out_acct_dt -- 出账日期
    ,nvl(n.base_prod_id, o.base_prod_id) as base_prod_id -- 基础产品编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.cont_effect_dt, o.cont_effect_dt) as cont_effect_dt -- 合同生效日期
    ,nvl(n.cont_exp_dt, o.cont_exp_dt) as cont_exp_dt -- 合同到期日期
    ,nvl(n.lmt_circl_flg, o.lmt_circl_flg) as lmt_circl_flg -- 循环贷款标志
    ,nvl(n.risk_type_cd, o.risk_type_cd) as risk_type_cd -- 风险类型代码
    ,nvl(n.low_risk_bus_flg, o.low_risk_bus_flg) as low_risk_bus_flg -- 低风险业务标志
    ,nvl(n.remote_bus_flg, o.remote_bus_flg) as remote_bus_flg -- 异地业务标志
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.fix_int_rat, o.fix_int_rat) as fix_int_rat -- 固定利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_flo_val, o.int_rat_flo_val) as int_rat_flo_val -- 利率浮动值
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.supp_guar_way_flg, o.supp_guar_way_flg) as supp_guar_way_flg -- 追加担保方式标志
    ,nvl(n.other_cond_descb, o.other_cond_descb) as other_cond_descb -- 其他条件描述
    ,nvl(n.guar_way_cd_two, o.guar_way_cd_two) as guar_way_cd_two -- 担保方式代码二
    ,nvl(n.guar_way_cd_three, o.guar_way_cd_three) as guar_way_cd_three -- 担保方式代码三
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.sub_guar_way_cd, o.sub_guar_way_cd) as sub_guar_way_cd -- 子担保方式代码
    ,nvl(n.repay_ped, o.repay_ped) as repay_ped -- 还款周期
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期单位代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.crdt_dir_cd, o.crdt_dir_cd) as crdt_dir_cd -- 授信投向代码
    ,nvl(n.nat_std_indus_dir_cd, o.nat_std_indus_dir_cd) as nat_std_indus_dir_cd -- 国标行业投向代码
    ,nvl(n.bank_int_indus_dir_cd, o.bank_int_indus_dir_cd) as bank_int_indus_dir_cd -- 行内行业投向代码
    ,nvl(n.usage_descb, o.usage_descb) as usage_descb -- 用途描述
    ,nvl(n.data_input_integy_flg, o.data_input_integy_flg) as data_input_integy_flg -- 数据录入已完善标志
    ,nvl(n.rsrv_amt, o.rsrv_amt) as rsrv_amt -- 预留金额
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.nomal_bal, o.nomal_bal) as nomal_bal -- 正常余额
    ,nvl(n.loan_ovdue_amt, o.loan_ovdue_amt) as loan_ovdue_amt -- 贷款逾期金额
    ,nvl(n.idle_bal, o.idle_bal) as idle_bal -- 呆滞余额
    ,nvl(n.bad_debt_bal, o.bad_debt_bal) as bad_debt_bal -- 呆账余额
    ,nvl(n.in_bs_over_int_bal, o.in_bs_over_int_bal) as in_bs_over_int_bal -- 表内欠息余额
    ,nvl(n.off_bs_over_int_bal, o.off_bs_over_int_bal) as off_bs_over_int_bal -- 表外欠息余额
    ,nvl(n.ovdue_pnlt_bal, o.ovdue_pnlt_bal) as ovdue_pnlt_bal -- 逾期罚息余额
    ,nvl(n.comp_int_bal, o.comp_int_bal) as comp_int_bal -- 复息余额
    ,nvl(n.loan_ovdue_days, o.loan_ovdue_days) as loan_ovdue_days -- 贷款逾期天数
    ,nvl(n.over_int_days, o.over_int_days) as over_int_days -- 欠息天数
    ,nvl(n.wrt_off_pric, o.wrt_off_pric) as wrt_off_pric -- 核销本金
    ,nvl(n.wrt_off_int, o.wrt_off_int) as wrt_off_int -- 核销利息
    ,nvl(n.pre_loss_amt, o.pre_loss_amt) as pre_loss_amt -- 预测损失金额
    ,nvl(n.fir_idtfy_non_dt, o.fir_idtfy_non_dt) as fir_idtfy_non_dt -- 首次认定不良日期
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.termnt_dt, o.termnt_dt) as termnt_dt -- 终止日期
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.off_bs_flg, o.off_bs_flg) as off_bs_flg -- 表外标志
    ,nvl(n.onl_bus_flg, o.onl_bus_flg) as onl_bus_flg -- 线上业务标志
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.spec_ped_corp_cd, o.spec_ped_corp_cd) as spec_ped_corp_cd -- 指定周期单位代码
    ,nvl(n.spec_ped_cd, o.spec_ped_cd) as spec_ped_cd -- 指定周期代码
    ,nvl(n.b_renew_exp_dt, o.b_renew_exp_dt) as b_renew_exp_dt -- 展期前到期日期
    ,nvl(n.b_renew_amt, o.b_renew_amt) as b_renew_amt -- 展期前金额
    ,nvl(n.b_renew_exec_year_int_rat, o.b_renew_exec_year_int_rat) as b_renew_exec_year_int_rat -- 展期前执行年利率
    ,nvl(n.hxb_rela_party_flg, o.hxb_rela_party_flg) as hxb_rela_party_flg -- 我行关联方标志
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.lmt_open_amt, o.lmt_open_amt) as lmt_open_amt -- 额度敞口金额
    ,nvl(n.occu_lmt, o.occu_lmt) as occu_lmt -- 已占用额度
    ,nvl(n.margin_curr_cd, o.margin_curr_cd) as margin_curr_cd -- 保证金币种代码
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 敞口金额
    ,nvl(n.open_amt_stat, o.open_amt_stat) as open_amt_stat -- 敞口金额统计
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.exec_mon_int_rat, o.exec_mon_int_rat) as exec_mon_int_rat -- 执行月利率
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.level5_cls_dt, o.level5_cls_dt) as level5_cls_dt -- 五级分类日期
    ,nvl(n.level11_cls_cd, o.level11_cls_cd) as level11_cls_cd -- 十一级分类代码
    ,nvl(n.lon_post_mgmt_teller_id, o.lon_post_mgmt_teller_id) as lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,nvl(n.lon_post_mgmt_org_id, o.lon_post_mgmt_org_id) as lon_post_mgmt_org_id -- 贷后管理机构编号
    ,nvl(n.file_dt, o.file_dt) as file_dt -- 归档日期
    ,nvl(n.froz_flg, o.froz_flg) as froz_flg -- 冻结状态代码
    ,nvl(n.ovdue_exec_int_rat, o.ovdue_exec_int_rat) as ovdue_exec_int_rat -- 逾期执行利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.core_out_acct_org_id, o.core_out_acct_org_id) as core_out_acct_org_id -- 核心出账机构编号
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_open_acct_org_id, o.enter_open_acct_org_id) as enter_open_acct_org_id -- 入账账户开户机构编号
    ,nvl(n.backup_status_cd, o.backup_status_cd) as backup_status_cd -- 备份状态代码
    ,nvl(n.backup_lmt_cont_id, o.backup_lmt_cont_id) as backup_lmt_cont_id -- 备份额度合同编号
    ,nvl(n.comm_fee_rat, o.comm_fee_rat) as comm_fee_rat -- 手续费率
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.high_new_tech_corp_flg, o.high_new_tech_corp_flg) as high_new_tech_corp_flg -- 高新技术企业标志
    ,nvl(n.scen_tech_corp_flg, o.scen_tech_corp_flg) as scen_tech_corp_flg -- 科技企业标志
    ,nvl(n.tech_inovt_corp_flg, o.tech_inovt_corp_flg) as tech_inovt_corp_flg -- 科创企业标志
    ,nvl(n.xxd_camp_lmt_flg, o.xxd_camp_lmt_flg) as xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,nvl(n.provi_for_aged_property_flg, o.provi_for_aged_property_flg) as provi_for_aged_property_flg -- 养老产业标志
    ,nvl(n.seed_loan_flg, o.seed_loan_flg) as seed_loan_flg -- 种业振兴贷款标志
    ,nvl(n.county_loan_flg, o.county_loan_flg) as county_loan_flg -- 县城城区贷款标志
    ,nvl(n.high_tech_property_flg, o.high_tech_property_flg) as high_tech_property_flg -- 投向高技术产业标志
    ,nvl(n.digit_econ_core_type_cd, o.digit_econ_core_type_cd) as digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.prod_gen_id, o.prod_gen_id) as prod_gen_id -- 产品大类编号
    ,nvl(n.tran_bf_prod_id, o.tran_bf_prod_id) as tran_bf_prod_id -- 转换前产品编号
    ,nvl(n.tran_bf_cust_id, o.tran_bf_cust_id) as tran_bf_cust_id -- 转换前客户编号
    ,nvl(n.attach_rgst_bus_type_cd, o.attach_rgst_bus_type_cd) as attach_rgst_bus_type_cd -- 补登业务类型代码
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_tran_out_acct_id, o.margin_tran_out_acct_id) as margin_tran_out_acct_id -- 保证金转出账户编号
    ,nvl(n.update_cnt, o.update_cnt) as update_cnt -- 更新次数
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.sign_lmt_cont_flg, o.sign_lmt_cont_flg) as sign_lmt_cont_flg -- 签订额度合同标志
    ,nvl(n.sign_paper_cont_flg, o.sign_paper_cont_flg) as sign_paper_cont_flg -- 签署纸质合同标志
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.crdt_apv_aval_amt, o.crdt_apv_aval_amt) as crdt_apv_aval_amt -- 信贷审批可用金额
    ,nvl(n.b_renew_cont_id, o.b_renew_cont_id) as b_renew_cont_id -- 展期前合同编号
    ,nvl(n.ocup_open_lmt_risk_type_cd, o.ocup_open_lmt_risk_type_cd) as ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,nvl(n.ocup_o_use_lmt_flg, o.ocup_o_use_lmt_flg) as ocup_o_use_lmt_flg -- 占用他用额度标志
    ,nvl(n.risk_mgmt_apv_aval_amt, o.risk_mgmt_apv_aval_amt) as risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,nvl(n.ifc_cnt_tot_apv_aval_amt, o.ifc_cnt_tot_apv_aval_amt) as ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,nvl(n.ifc_apved_lmt_cont_amt, o.ifc_apved_lmt_cont_amt) as ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,nvl(n.regroup_loan_flg, o.regroup_loan_flg) as regroup_loan_flg -- 重组贷款标志
    ,nvl(n.only_new_minorent_flg, o.only_new_minorent_flg) as only_new_minorent_flg -- 专精特新小巨人企业标志
    ,nvl(n.only_new_littlegiantent_flg, o.only_new_littlegiantent_flg) as only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,nvl(n.indent_tech_flg, o.indent_tech_flg) as indent_tech_flg -- 工业企业技术改造升级标志
    ,nvl(n.cul_property_flg, o.cul_property_flg) as cul_property_flg -- 文化产业标志
    ,nvl(n.advanced_manu_flg, o.advanced_manu_flg) as advanced_manu_flg -- 先进制造业标志
    ,nvl(n.auto_que_lon_post_rept_flg, o.auto_que_lon_post_rept_flg) as auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,nvl(n.buss_tiket_recs_flg, o.buss_tiket_recs_flg) as buss_tiket_recs_flg -- 商票保贴追索标志
    ,nvl(n.discnter_margin_acct_flg, o.discnter_margin_acct_flg) as discnter_margin_acct_flg -- 贴现人保证金账户标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_cont_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cont_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cont_id is null
    )
    or (
        o.apv_flow_num <> n.apv_flow_num
        or o.rela_cont_id <> n.rela_cont_id
        or o.text_cont_id <> n.text_cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.lmt_cont_flg <> n.lmt_cont_flg
        or o.rela_old_cont_id <> n.rela_old_cont_id
        or o.appl_way_cd <> n.appl_way_cd
        or o.loan_distr_type_cd <> n.loan_distr_type_cd
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.happ_dt <> n.happ_dt
        or o.curr_cd <> n.curr_cd
        or o.cont_amt <> n.cont_amt
        or o.actl_out_acct_amt <> n.actl_out_acct_amt
        or o.out_acct_dt <> n.out_acct_dt
        or o.base_prod_id <> n.base_prod_id
        or o.prod_id <> n.prod_id
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.cont_effect_dt <> n.cont_effect_dt
        or o.cont_exp_dt <> n.cont_exp_dt
        or o.lmt_circl_flg <> n.lmt_circl_flg
        or o.risk_type_cd <> n.risk_type_cd
        or o.low_risk_bus_flg <> n.low_risk_bus_flg
        or o.remote_bus_flg <> n.remote_bus_flg
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.fix_int_rat <> n.fix_int_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_flo_val <> n.int_rat_flo_val
        or o.exec_int_rat <> n.exec_int_rat
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.supp_guar_way_flg <> n.supp_guar_way_flg
        or o.other_cond_descb <> n.other_cond_descb
        or o.guar_way_cd_two <> n.guar_way_cd_two
        or o.guar_way_cd_three <> n.guar_way_cd_three
        or o.repay_way_cd <> n.repay_way_cd
        or o.sub_guar_way_cd <> n.sub_guar_way_cd
        or o.repay_ped <> n.repay_ped
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.stl_acct_id <> n.stl_acct_id
        or o.crdt_dir_cd <> n.crdt_dir_cd
        or o.nat_std_indus_dir_cd <> n.nat_std_indus_dir_cd
        or o.bank_int_indus_dir_cd <> n.bank_int_indus_dir_cd
        or o.usage_descb <> n.usage_descb
        or o.data_input_integy_flg <> n.data_input_integy_flg
        or o.rsrv_amt <> n.rsrv_amt
        or o.curr_bal <> n.curr_bal
        or o.nomal_bal <> n.nomal_bal
        or o.loan_ovdue_amt <> n.loan_ovdue_amt
        or o.idle_bal <> n.idle_bal
        or o.bad_debt_bal <> n.bad_debt_bal
        or o.in_bs_over_int_bal <> n.in_bs_over_int_bal
        or o.off_bs_over_int_bal <> n.off_bs_over_int_bal
        or o.ovdue_pnlt_bal <> n.ovdue_pnlt_bal
        or o.comp_int_bal <> n.comp_int_bal
        or o.loan_ovdue_days <> n.loan_ovdue_days
        or o.over_int_days <> n.over_int_days
        or o.wrt_off_pric <> n.wrt_off_pric
        or o.wrt_off_int <> n.wrt_off_int
        or o.pre_loss_amt <> n.pre_loss_amt
        or o.fir_idtfy_non_dt <> n.fir_idtfy_non_dt
        or o.cont_status_cd <> n.cont_status_cd
        or o.effect_dt <> n.effect_dt
        or o.termnt_dt <> n.termnt_dt
        or o.payoff_flg <> n.payoff_flg
        or o.off_bs_flg <> n.off_bs_flg
        or o.onl_bus_flg <> n.onl_bus_flg
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.lmt_id <> n.lmt_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.spec_ped_corp_cd <> n.spec_ped_corp_cd
        or o.spec_ped_cd <> n.spec_ped_cd
        or o.b_renew_exp_dt <> n.b_renew_exp_dt
        or o.b_renew_amt <> n.b_renew_amt
        or o.b_renew_exec_year_int_rat <> n.b_renew_exec_year_int_rat
        or o.hxb_rela_party_flg <> n.hxb_rela_party_flg
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.lmt_open_amt <> n.lmt_open_amt
        or o.occu_lmt <> n.occu_lmt
        or o.margin_curr_cd <> n.margin_curr_cd
        or o.margin_ratio <> n.margin_ratio
        or o.margin_amt <> n.margin_amt
        or o.open_amt <> n.open_amt
        or o.open_amt_stat <> n.open_amt_stat
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.exec_mon_int_rat <> n.exec_mon_int_rat
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.level5_cls_dt <> n.level5_cls_dt
        or o.level11_cls_cd <> n.level11_cls_cd
        or o.lon_post_mgmt_teller_id <> n.lon_post_mgmt_teller_id
        or o.lon_post_mgmt_org_id <> n.lon_post_mgmt_org_id
        or o.file_dt <> n.file_dt
        or o.froz_flg <> n.froz_flg
        or o.ovdue_exec_int_rat <> n.ovdue_exec_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.core_out_acct_org_id <> n.core_out_acct_org_id
        or o.stl_acct_name <> n.stl_acct_name
        or o.enter_id <> n.enter_id
        or o.enter_name <> n.enter_name
        or o.enter_open_acct_org_id <> n.enter_open_acct_org_id
        or o.backup_status_cd <> n.backup_status_cd
        or o.backup_lmt_cont_id <> n.backup_lmt_cont_id
        or o.comm_fee_rat <> n.comm_fee_rat
        or o.move_remark <> n.move_remark
        or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
        or o.high_new_tech_corp_flg <> n.high_new_tech_corp_flg
        or o.scen_tech_corp_flg <> n.scen_tech_corp_flg
        or o.tech_inovt_corp_flg <> n.tech_inovt_corp_flg
        or o.xxd_camp_lmt_flg <> n.xxd_camp_lmt_flg
        or o.provi_for_aged_property_flg <> n.provi_for_aged_property_flg
        or o.seed_loan_flg <> n.seed_loan_flg
        or o.county_loan_flg <> n.county_loan_flg
        or o.high_tech_property_flg <> n.high_tech_property_flg
        or o.digit_econ_core_type_cd <> n.digit_econ_core_type_cd
        or o.remark <> n.remark
        or o.prod_gen_id <> n.prod_gen_id
        or o.tran_bf_prod_id <> n.tran_bf_prod_id
        or o.tran_bf_cust_id <> n.tran_bf_cust_id
        or o.attach_rgst_bus_type_cd <> n.attach_rgst_bus_type_cd
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_tran_out_acct_id <> n.margin_tran_out_acct_id
        or o.update_cnt <> n.update_cnt
        or o.dubil_id <> n.dubil_id
        or o.sign_lmt_cont_flg <> n.sign_lmt_cont_flg
        or o.sign_paper_cont_flg <> n.sign_paper_cont_flg
        or o.comm_fee_amt <> n.comm_fee_amt
        or o.crdt_apv_aval_amt <> n.crdt_apv_aval_amt
        or o.b_renew_cont_id <> n.b_renew_cont_id
        or o.ocup_open_lmt_risk_type_cd <> n.ocup_open_lmt_risk_type_cd
        or o.ocup_o_use_lmt_flg <> n.ocup_o_use_lmt_flg
        or o.risk_mgmt_apv_aval_amt <> n.risk_mgmt_apv_aval_amt
        or o.ifc_cnt_tot_apv_aval_amt <> n.ifc_cnt_tot_apv_aval_amt
        or o.ifc_apved_lmt_cont_amt <> n.ifc_apved_lmt_cont_amt
        or o.regroup_loan_flg <> n.regroup_loan_flg
        or o.only_new_minorent_flg <> n.only_new_minorent_flg
        or o.only_new_littlegiantent_flg <> n.only_new_littlegiantent_flg
        or o.indent_tech_flg <> n.indent_tech_flg
        or o.cul_property_flg <> n.cul_property_flg
        or o.advanced_manu_flg <> n.advanced_manu_flg
        or o.auto_que_lon_post_rept_flg <> n.auto_que_lon_post_rept_flg
        or o.buss_tiket_recs_flg <> n.buss_tiket_recs_flg
        or o.discnter_margin_acct_flg <> n.discnter_margin_acct_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,apv_flow_num -- 审批流水号
    ,rela_cont_id -- 关联合同编号
    ,text_cont_id -- 文本合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,lmt_cont_flg -- 额度合同标志
    ,rela_old_cont_id -- 关联旧合同编号
    ,appl_way_cd -- 申请方式代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,cont_effect_dt -- 合同生效日期
    ,cont_exp_dt -- 合同到期日期
    ,lmt_circl_flg -- 循环贷款标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,remote_bus_flg -- 异地业务标志
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,repay_way_cd -- 还款方式代码
    ,sub_guar_way_cd -- 子担保方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,stl_acct_id -- 结算账户编号
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,usage_descb -- 用途描述
    ,data_input_integy_flg -- 数据录入已完善标志
    ,rsrv_amt -- 预留金额
    ,curr_bal -- 当前余额
    ,nomal_bal -- 正常余额
    ,loan_ovdue_amt -- 贷款逾期金额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_over_int_bal -- 表外欠息余额
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,comp_int_bal -- 复息余额
    ,loan_ovdue_days -- 贷款逾期天数
    ,over_int_days -- 欠息天数
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,pre_loss_amt -- 预测损失金额
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,termnt_dt -- 终止日期
    ,payoff_flg -- 结清标志
    ,off_bs_flg -- 表外标志
    ,onl_bus_flg -- 线上业务标志
    ,belong_strip_line_cd -- 所属条线代码
    ,apv_status_cd -- 审批状态代码
    ,lmt_id -- 额度编号
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,hxb_rela_party_flg -- 我行关联方标志
    ,loan_usage_cd -- 贷款用途代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,lmt_open_amt -- 额度敞口金额
    ,occu_lmt -- 已占用额度
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,open_amt -- 敞口金额
    ,open_amt_stat -- 敞口金额统计
    ,lmt_cont_id -- 额度合同编号
    ,exec_mon_int_rat -- 执行月利率
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id -- 贷后管理机构编号
    ,file_dt -- 归档日期
    ,froz_flg -- 冻结状态代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,core_out_acct_org_id -- 核心出账机构编号
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,backup_status_cd -- 备份状态代码
    ,backup_lmt_cont_id -- 备份额度合同编号
    ,comm_fee_rat -- 手续费率
    ,move_remark -- 迁移备注
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,scen_tech_corp_flg -- 科技企业标志
    ,tech_inovt_corp_flg -- 科创企业标志
    ,xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,seed_loan_flg -- 种业振兴贷款标志
    ,county_loan_flg -- 县城城区贷款标志
    ,high_tech_property_flg -- 投向高技术产业标志
    ,digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,remark -- 备注
    ,prod_gen_id -- 产品大类编号
    ,tran_bf_prod_id -- 转换前产品编号
    ,tran_bf_cust_id -- 转换前客户编号
    ,attach_rgst_bus_type_cd -- 补登业务类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,update_cnt -- 更新次数
    ,dubil_id -- 借据编号
    ,sign_lmt_cont_flg -- 签订额度合同标志
    ,sign_paper_cont_flg -- 签署纸质合同标志
    ,comm_fee_amt -- 手续费金额
    ,crdt_apv_aval_amt -- 信贷审批可用金额
    ,b_renew_cont_id -- 展期前合同编号
    ,ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,regroup_loan_flg -- 重组贷款标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,cul_property_flg -- 文化产业标志
    ,advanced_manu_flg -- 先进制造业标志
    ,auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,buss_tiket_recs_flg -- 商票保贴追索标志
    ,discnter_margin_acct_flg -- 贴现人保证金账户标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.cont_id -- 合同编号
    ,o.apv_flow_num -- 审批流水号
    ,o.rela_cont_id -- 关联合同编号
    ,o.text_cont_id -- 文本合同编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.lmt_cont_flg -- 额度合同标志
    ,o.rela_old_cont_id -- 关联旧合同编号
    ,o.appl_way_cd -- 申请方式代码
    ,o.loan_distr_type_cd -- 贷款发放类型代码
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.happ_dt -- 发生日期
    ,o.curr_cd -- 币种代码
    ,o.cont_amt -- 合同金额
    ,o.actl_out_acct_amt -- 实际出账金额
    ,o.out_acct_dt -- 出账日期
    ,o.base_prod_id -- 基础产品编号
    ,o.prod_id -- 产品编号
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.cont_effect_dt -- 合同生效日期
    ,o.cont_exp_dt -- 合同到期日期
    ,o.lmt_circl_flg -- 循环贷款标志
    ,o.risk_type_cd -- 风险类型代码
    ,o.low_risk_bus_flg -- 低风险业务标志
    ,o.remote_bus_flg -- 异地业务标志
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.fix_int_rat -- 固定利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_flo_val -- 利率浮动值
    ,o.exec_int_rat -- 执行利率
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.supp_guar_way_flg -- 追加担保方式标志
    ,o.other_cond_descb -- 其他条件描述
    ,o.guar_way_cd_two -- 担保方式代码二
    ,o.guar_way_cd_three -- 担保方式代码三
    ,o.repay_way_cd -- 还款方式代码
    ,o.sub_guar_way_cd -- 子担保方式代码
    ,o.repay_ped -- 还款周期
    ,o.repay_ped_cd -- 还款周期单位代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.stl_acct_id -- 结算账户编号
    ,o.crdt_dir_cd -- 授信投向代码
    ,o.nat_std_indus_dir_cd -- 国标行业投向代码
    ,o.bank_int_indus_dir_cd -- 行内行业投向代码
    ,o.usage_descb -- 用途描述
    ,o.data_input_integy_flg -- 数据录入已完善标志
    ,o.rsrv_amt -- 预留金额
    ,o.curr_bal -- 当前余额
    ,o.nomal_bal -- 正常余额
    ,o.loan_ovdue_amt -- 贷款逾期金额
    ,o.idle_bal -- 呆滞余额
    ,o.bad_debt_bal -- 呆账余额
    ,o.in_bs_over_int_bal -- 表内欠息余额
    ,o.off_bs_over_int_bal -- 表外欠息余额
    ,o.ovdue_pnlt_bal -- 逾期罚息余额
    ,o.comp_int_bal -- 复息余额
    ,o.loan_ovdue_days -- 贷款逾期天数
    ,o.over_int_days -- 欠息天数
    ,o.wrt_off_pric -- 核销本金
    ,o.wrt_off_int -- 核销利息
    ,o.pre_loss_amt -- 预测损失金额
    ,o.fir_idtfy_non_dt -- 首次认定不良日期
    ,o.cont_status_cd -- 合同状态代码
    ,o.effect_dt -- 生效日期
    ,o.termnt_dt -- 终止日期
    ,o.payoff_flg -- 结清标志
    ,o.off_bs_flg -- 表外标志
    ,o.onl_bus_flg -- 线上业务标志
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.lmt_id -- 额度编号
    ,o.oper_teller_id -- 业务经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.spec_ped_corp_cd -- 指定周期单位代码
    ,o.spec_ped_cd -- 指定周期代码
    ,o.b_renew_exp_dt -- 展期前到期日期
    ,o.b_renew_amt -- 展期前金额
    ,o.b_renew_exec_year_int_rat -- 展期前执行年利率
    ,o.hxb_rela_party_flg -- 我行关联方标志
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.lmt_open_amt -- 额度敞口金额
    ,o.occu_lmt -- 已占用额度
    ,o.margin_curr_cd -- 保证金币种代码
    ,o.margin_ratio -- 保证金比例
    ,o.margin_amt -- 保证金金额
    ,o.open_amt -- 敞口金额
    ,o.open_amt_stat -- 敞口金额统计
    ,o.lmt_cont_id -- 额度合同编号
    ,o.exec_mon_int_rat -- 执行月利率
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.level5_cls_cd -- 五级分类代码
    ,o.level5_cls_dt -- 五级分类日期
    ,o.level11_cls_cd -- 十一级分类代码
    ,o.lon_post_mgmt_teller_id -- 贷后管理柜员编号
    ,o.lon_post_mgmt_org_id -- 贷后管理机构编号
    ,o.file_dt -- 归档日期
    ,o.froz_flg -- 冻结状态代码
    ,o.ovdue_exec_int_rat -- 逾期执行利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.core_out_acct_org_id -- 核心出账机构编号
    ,o.stl_acct_name -- 结算账户名称
    ,o.enter_id -- 入账账户编号
    ,o.enter_name -- 入账账户名称
    ,o.enter_open_acct_org_id -- 入账账户开户机构编号
    ,o.backup_status_cd -- 备份状态代码
    ,o.backup_lmt_cont_id -- 备份额度合同编号
    ,o.comm_fee_rat -- 手续费率
    ,o.move_remark -- 迁移备注
    ,o.strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,o.high_new_tech_corp_flg -- 高新技术企业标志
    ,o.scen_tech_corp_flg -- 科技企业标志
    ,o.tech_inovt_corp_flg -- 科创企业标志
    ,o.xxd_camp_lmt_flg -- 新兴贷营销额度标志
    ,o.provi_for_aged_property_flg -- 养老产业标志
    ,o.seed_loan_flg -- 种业振兴贷款标志
    ,o.county_loan_flg -- 县城城区贷款标志
    ,o.high_tech_property_flg -- 投向高技术产业标志
    ,o.digit_econ_core_type_cd -- 数字经济核心产业类型代码
    ,o.remark -- 备注
    ,o.prod_gen_id -- 产品大类编号
    ,o.tran_bf_prod_id -- 转换前产品编号
    ,o.tran_bf_cust_id -- 转换前客户编号
    ,o.attach_rgst_bus_type_cd -- 补登业务类型代码
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_tran_out_acct_id -- 保证金转出账户编号
    ,o.update_cnt -- 更新次数
    ,o.dubil_id -- 借据编号
    ,o.sign_lmt_cont_flg -- 签订额度合同标志
    ,o.sign_paper_cont_flg -- 签署纸质合同标志
    ,o.comm_fee_amt -- 手续费金额
    ,o.crdt_apv_aval_amt -- 信贷审批可用金额
    ,o.b_renew_cont_id -- 展期前合同编号
    ,o.ocup_open_lmt_risk_type_cd -- 占用敞口额度风险类型代码
    ,o.ocup_o_use_lmt_flg -- 占用他用额度标志
    ,o.risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,o.ifc_cnt_tot_apv_aval_amt -- IFC数总审批可用金额
    ,o.ifc_apved_lmt_cont_amt -- IFC审批后额度合同金额
    ,o.regroup_loan_flg -- 重组贷款标志
    ,o.only_new_minorent_flg -- 专精特新小巨人企业标志
    ,o.only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,o.indent_tech_flg -- 工业企业技术改造升级标志
    ,o.cul_property_flg -- 文化产业标志
    ,o.advanced_manu_flg -- 先进制造业标志
    ,o.auto_que_lon_post_rept_flg -- 自动查询贷后报告标志
    ,o.buss_tiket_recs_flg -- 商票保贴追索标志
    ,o.discnter_margin_acct_flg -- 贴现人保证金账户标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_cont_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.cont_id = d.cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_cont_info_h;
--alter table ${iml_schema}.agt_loan_cont_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_cont_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_cont_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_cont_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_cont_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_cont_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_cont_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
