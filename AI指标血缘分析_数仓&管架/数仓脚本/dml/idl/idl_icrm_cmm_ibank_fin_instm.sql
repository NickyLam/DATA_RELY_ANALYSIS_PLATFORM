/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_ibank_fin_instm
CreateDate: 20230703
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_cmm_ibank_fin_instm drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_ibank_fin_instm add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_ibank_fin_instm (
etl_dt  --数据日期
,lp_id  --法人编号
,fin_instm_id  --金融工具编号
,asset_type_id  --资产类型编号
,market_type_id  --市场类型编号
,fin_instm_name  --金融工具名称
,fin_instm_abbr  --金融工具简称
,prod_type_cd  --产品类型代码
,asset_type_name  --资产类型名称
,prod_cls_tenor_cd  --产品分类期限代码
,issue_org_id  --发行机构编号
,discov_org_cls_name  --发现机构分类名称
,issue_dt  --发行日期
,value_dt  --起息日期
,exp_dt  --到期日期
,tenor_cd  --期限代码
,base_rat_id  --基准利率编号
,int_accr_base_cd  --计息基准代码
,int_rat_adj_way_cd  --利率调整方式代码
,issue_way_cd  --发行模式代码
,cty_cd  --国家代码
,curr_cd  --币种代码
,fac_val_amt  --票面金额
,fac_val_int_rat  --票面利率
,fwd_int_rat_curve  --远期利率曲线
,disct_int_rat_curve  --折现利率曲线
,risk_wt  --风险权重
,pay_int_ped_cd  --付息周期代码
,pay_int_freq  --付息频率
,fir_pay_int_dt  --首次付息日期
,belong_org_id  --所属机构编号
,std_prod_id  --标准产品编号
,underly_fin_instm_id  --标的金融工具编号
,underly_asset_type_id  --标的资产类型编号
,underly_market_type_id  --标的市场类型编号
,issuer_cust_id  --发行人客户编号
,mger_cust_id  --管理人客户编号
,mger_id  --管理人编号
,mger_name  --管理人名称
,mgmt_mode_cd  --管理模式代码
,int_rat_adj_ped_freq  --利率调整周期频率
,int_rat_adj_ped_corp_cd  --利率调整周期单位代码
,contn_weight_flg  --含权标志
,src_pay_int_ped_cd  --源付息周期代码
,cashflow_get_way_cd  --现金流获取方式代码
,spec_aim_vector_type_cd  --特定目的载体类型代码
,spec_aim_vector_code  --特定目的载体编码
,am_prod_stat_code  --资管产品统计编码
,issuer_id  --发行人编号
,issuer_rg_cd  --发行人地区代码
,move_way_cd  --运行方式代码
,non_uder_asset_cls_cd  --非底层资产分类代码
,non_uder_asset_subclass_cd  --非底层资产细类代码
,dr_input_freq_cd  --缓释录入频率代码
,dr_input_dt  --缓释录入日期
,dr_effect_dt  --缓释生效日期
,dr_exp_dt  --缓释到期日期
,margin_dr_ratio  --保证金缓释比例
,hxb_dep_rcpt_dr_ratio  --我行存单缓释比例
,tbond_dr_ratio  --国债缓释比例
,chn_pb_bond_dr_ratio  --我国政策性银行债券缓释比例
,chn_cb_dr_ratio  --我国商业银行缓释比例
,chn_pub_dept_dr_ratio  --我国公共部门缓释比例
,other_dr_ratio  --其他缓释比例
,dr_prod_descb_info  --缓释品描述信息
,dr_acct_id  --缓释账户编号
,dr_acct_bal  --缓释账户余额
,fund_open_dt  --基金开放日期
,actl_finer_cust_id  --实际融资人客户编号
,actl_finer_name  --实际融资人名称
,actl_finer_group_name  --实际融资人集团名称
,set_open_flg  --定开标志
,set_open_ped_cd  --定开周期代码
,open_type_cd  --开放类型代码
,incre_crdt_way_cd  --增信方式代码
,incre_crdt_main_name  --增信主体名称
,set_open_tenor_start_dt  --定开期限开始日期
,set_open_tenor_end_dt  --定开期限结束日期
,usage_descb  --用途描述
,guar_way_comb  --担保方式组合
,crdt_class_proj_flg  --信贷类项目标志
,asset_supt_secu_flg  --资产证券化产品标志
,noth_rating_abs_flg  --无评级资产证券化标志
,abs_flg  --再资产证券化标志
,list_dt  --上市日期
,nv_type_dir_indus_type_cd  --净值型投向行业类型代码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id --金融工具编号
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id --资产类型编号
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id --市场类型编号
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name --金融工具名称
,replace(replace(t1.fin_instm_abbr,chr(13),''),chr(10),'') as fin_instm_abbr --金融工具简称
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd --产品类型代码
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name --资产类型名称
,replace(replace(t1.prod_cls_tenor_cd,chr(13),''),chr(10),'') as prod_cls_tenor_cd --产品分类期限代码
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id --发行机构编号
,replace(replace(t1.discov_org_cls_name,chr(13),''),chr(10),'') as discov_org_cls_name --发现机构分类名称
,t1.issue_dt as issue_dt --发行日期
,t1.value_dt as value_dt --起息日期
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.tenor_cd,chr(13),''),chr(10),'') as tenor_cd --期限代码
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id --基准利率编号
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd --计息基准代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd --发行模式代码
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd --国家代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.fac_val_amt as fac_val_amt --票面金额
,t1.fac_val_int_rat as fac_val_int_rat --票面利率
,replace(replace(t1.fwd_int_rat_curve,chr(13),''),chr(10),'') as fwd_int_rat_curve --远期利率曲线
,replace(replace(t1.disct_int_rat_curve,chr(13),''),chr(10),'') as disct_int_rat_curve --折现利率曲线
,t1.risk_wt as risk_wt --风险权重
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd --付息周期代码
,t1.pay_int_freq as pay_int_freq --付息频率
,t1.fir_pay_int_dt as fir_pay_int_dt --首次付息日期
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id --所属机构编号
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.underly_fin_instm_id,chr(13),''),chr(10),'') as underly_fin_instm_id --标的金融工具编号
,replace(replace(t1.underly_asset_type_id,chr(13),''),chr(10),'') as underly_asset_type_id --标的资产类型编号
,replace(replace(t1.underly_market_type_id,chr(13),''),chr(10),'') as underly_market_type_id --标的市场类型编号
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id --发行人客户编号
,replace(replace(t1.mger_cust_id,chr(13),''),chr(10),'') as mger_cust_id --管理人客户编号
,replace(replace(t1.mger_id,chr(13),''),chr(10),'') as mger_id --管理人编号
,replace(replace(t1.mger_name,chr(13),''),chr(10),'') as mger_name --管理人名称
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd --管理模式代码
,replace(replace(t1.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq --利率调整周期频率
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd --利率调整周期单位代码
,replace(replace(t1.contn_weight_flg,chr(13),''),chr(10),'') as contn_weight_flg --含权标志
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd --源付息周期代码
,replace(replace(t1.cashflow_get_way_cd,chr(13),''),chr(10),'') as cashflow_get_way_cd --现金流获取方式代码
,replace(replace(t1.spec_aim_vector_type_cd,chr(13),''),chr(10),'') as spec_aim_vector_type_cd --特定目的载体类型代码
,replace(replace(t1.spec_aim_vector_code,chr(13),''),chr(10),'') as spec_aim_vector_code --特定目的载体编码
,replace(replace(t1.am_prod_stat_code,chr(13),''),chr(10),'') as am_prod_stat_code --资管产品统计编码
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id --发行人编号
,replace(replace(t1.issuer_rg_cd,chr(13),''),chr(10),'') as issuer_rg_cd --发行人地区代码
,replace(replace(t1.move_way_cd,chr(13),''),chr(10),'') as move_way_cd --运行方式代码
,replace(replace(t1.non_uder_asset_cls_cd,chr(13),''),chr(10),'') as non_uder_asset_cls_cd --非底层资产分类代码
,replace(replace(t1.non_uder_asset_subclass_cd,chr(13),''),chr(10),'') as non_uder_asset_subclass_cd --非底层资产细类代码
,replace(replace(t1.dr_input_freq_cd,chr(13),''),chr(10),'') as dr_input_freq_cd --缓释录入频率代码
,t1.dr_input_dt as dr_input_dt --缓释录入日期
,t1.dr_effect_dt as dr_effect_dt --缓释生效日期
,t1.dr_exp_dt as dr_exp_dt --缓释到期日期
,t1.margin_dr_ratio as margin_dr_ratio --保证金缓释比例
,t1.hxb_dep_rcpt_dr_ratio as hxb_dep_rcpt_dr_ratio --我行存单缓释比例
,t1.tbond_dr_ratio as tbond_dr_ratio --国债缓释比例
,t1.chn_pb_bond_dr_ratio as chn_pb_bond_dr_ratio --我国政策性银行债券缓释比例
,t1.chn_cb_dr_ratio as chn_cb_dr_ratio --我国商业银行缓释比例
,t1.chn_pub_dept_dr_ratio as chn_pub_dept_dr_ratio --我国公共部门缓释比例
,t1.other_dr_ratio as other_dr_ratio --其他缓释比例
,replace(replace(t1.dr_prod_descb_info,chr(13),''),chr(10),'') as dr_prod_descb_info --缓释品描述信息
,replace(replace(t1.dr_acct_id,chr(13),''),chr(10),'') as dr_acct_id --缓释账户编号
,t1.dr_acct_bal as dr_acct_bal --缓释账户余额
,t1.fund_open_dt as fund_open_dt --基金开放日期
,replace(replace(t1.actl_finer_cust_id,chr(13),''),chr(10),'') as actl_finer_cust_id --实际融资人客户编号
,replace(replace(t1.actl_finer_name,chr(13),''),chr(10),'') as actl_finer_name --实际融资人名称
,replace(replace(t1.actl_finer_group_name,chr(13),''),chr(10),'') as actl_finer_group_name --实际融资人集团名称
,replace(replace(t1.set_open_flg,chr(13),''),chr(10),'') as set_open_flg --定开标志
,replace(replace(t1.set_open_ped_cd,chr(13),''),chr(10),'') as set_open_ped_cd --定开周期代码
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd --开放类型代码
,replace(replace(t1.incre_crdt_way_cd,chr(13),''),chr(10),'') as incre_crdt_way_cd --增信方式代码
,replace(replace(t1.incre_crdt_main_name,chr(13),''),chr(10),'') as incre_crdt_main_name --增信主体名称
,t1.set_open_tenor_start_dt as set_open_tenor_start_dt --定开期限开始日期
,t1.set_open_tenor_end_dt as set_open_tenor_end_dt --定开期限结束日期
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb --用途描述
,replace(replace(t1.guar_way_comb,chr(13),''),chr(10),'') as guar_way_comb --担保方式组合
,replace(replace(t1.crdt_class_proj_flg,chr(13),''),chr(10),'') as crdt_class_proj_flg --信贷类项目标志
,replace(replace(t1.asset_supt_secu_flg,chr(13),''),chr(10),'') as asset_supt_secu_flg --资产证券化产品标志
,replace(replace(t1.noth_rating_abs_flg,chr(13),''),chr(10),'') as noth_rating_abs_flg --无评级资产证券化标志
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg --再资产证券化标志
,t1.list_dt as list_dt --上市日期
,replace(replace(t1.nv_type_dir_indus_type_cd,chr(13),''),chr(10),'') as nv_type_dir_indus_type_cd --净值型投向行业类型代码
from ${icl_schema}.cmm_ibank_fin_instm t1    --同业金融工具
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_ibank_fin_instm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
