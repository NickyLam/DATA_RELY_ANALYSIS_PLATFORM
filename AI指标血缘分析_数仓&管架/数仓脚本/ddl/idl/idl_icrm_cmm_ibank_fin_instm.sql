/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_cmm_ibank_fin_instm
CreateDate: 20230703
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icrm_cmm_ibank_fin_instm purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icrm_cmm_ibank_fin_instm(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,fin_instm_id varchar2(60) --金融工具编号
,asset_type_id varchar2(60) --资产类型编号
,market_type_id varchar2(60) --市场类型编号
,fin_instm_name varchar2(250) --金融工具名称
,fin_instm_abbr varchar2(250) --金融工具简称
,prod_type_cd varchar2(10) --产品类型代码
,asset_type_name varchar2(250) --资产类型名称
,prod_cls_tenor_cd varchar2(10) --产品分类期限代码
,issue_org_id varchar2(60) --发行机构编号
,discov_org_cls_name varchar2(250) --发现机构分类名称
,issue_dt date --发行日期
,value_dt date --起息日期
,exp_dt date --到期日期
,tenor_cd varchar2(10) --期限代码
,base_rat_id varchar2(60) --基准利率编号
,int_accr_base_cd varchar2(10) --计息基准代码
,int_rat_adj_way_cd varchar2(10) --利率调整方式代码
,issue_way_cd varchar2(10) --发行模式代码
,cty_cd varchar2(10) --国家代码
,curr_cd varchar2(10) --币种代码
,fac_val_amt number(30,2) --票面金额
,fac_val_int_rat number(18,8) --票面利率
,fwd_int_rat_curve varchar2(60) --远期利率曲线
,disct_int_rat_curve varchar2(60) --折现利率曲线
,risk_wt number(18,8) --风险权重
,pay_int_ped_cd varchar2(10) --付息周期代码
,pay_int_freq number(18) --付息频率
,fir_pay_int_dt date --首次付息日期
,belong_org_id varchar2(60) --所属机构编号
,std_prod_id varchar2(60) --标准产品编号
,underly_fin_instm_id varchar2(60) --标的金融工具编号
,underly_asset_type_id varchar2(60) --标的资产类型编号
,underly_market_type_id varchar2(60) --标的市场类型编号
,issuer_cust_id varchar2(60) --发行人客户编号
,mger_cust_id varchar2(60) --管理人客户编号
,mger_id varchar2(60) --管理人编号
,mger_name varchar2(500) --管理人名称
,mgmt_mode_cd varchar2(60) --管理模式代码
,int_rat_adj_ped_freq varchar2(10) --利率调整周期频率
,int_rat_adj_ped_corp_cd varchar2(30) --利率调整周期单位代码
,contn_weight_flg varchar2(10) --含权标志
,src_pay_int_ped_cd varchar2(10) --源付息周期代码
,cashflow_get_way_cd varchar2(30) --现金流获取方式代码
,spec_aim_vector_type_cd varchar2(60) --特定目的载体类型代码
,spec_aim_vector_code varchar2(60) --特定目的载体编码
,am_prod_stat_code varchar2(60) --资管产品统计编码
,issuer_id varchar2(60) --发行人编号
,issuer_rg_cd varchar2(60) --发行人地区代码
,move_way_cd varchar2(60) --运行方式代码
,non_uder_asset_cls_cd varchar2(60) --非底层资产分类代码
,non_uder_asset_subclass_cd varchar2(60) --非底层资产细类代码
,dr_input_freq_cd varchar2(10) --缓释录入频率代码
,dr_input_dt date --缓释录入日期
,dr_effect_dt date --缓释生效日期
,dr_exp_dt date --缓释到期日期
,margin_dr_ratio number(18,8) --保证金缓释比例
,hxb_dep_rcpt_dr_ratio number(18,8) --我行存单缓释比例
,tbond_dr_ratio number(18,8) --国债缓释比例
,chn_pb_bond_dr_ratio number(18,8) --我国政策性银行债券缓释比例
,chn_cb_dr_ratio number(18,8) --我国商业银行缓释比例
,chn_pub_dept_dr_ratio number(18,8) --我国公共部门缓释比例
,other_dr_ratio number(18,8) --其他缓释比例
,dr_prod_descb_info varchar2(500) --缓释品描述信息
,dr_acct_id varchar2(250) --缓释账户编号
,dr_acct_bal number(30,8) --缓释账户余额
,fund_open_dt date --基金开放日期
,actl_finer_cust_id varchar2(60) --实际融资人客户编号
,actl_finer_name varchar2(500) --实际融资人名称
,actl_finer_group_name varchar2(500) --实际融资人集团名称
,set_open_flg varchar2(10) --定开标志
,set_open_ped_cd varchar2(20) --定开周期代码
,open_type_cd varchar2(20) --开放类型代码
,incre_crdt_way_cd varchar2(60) --增信方式代码
,incre_crdt_main_name varchar2(500) --增信主体名称
,set_open_tenor_start_dt date --定开期限开始日期
,set_open_tenor_end_dt date --定开期限结束日期
,usage_descb varchar2(500) --用途描述
,guar_way_comb varchar2(500) --担保方式组合
,crdt_class_proj_flg varchar2(10) --信贷类项目标志
,asset_supt_secu_flg varchar2(10) --资产证券化产品标志
,noth_rating_abs_flg varchar2(10) --无评级资产证券化标志
,abs_flg varchar2(10) --再资产证券化标志
,list_dt date --上市日期
,nv_type_dir_indus_type_cd varchar2(10) --净值型投向行业类型代码

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_cmm_ibank_fin_instm to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_cmm_ibank_fin_instm is '同业金融工具';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fin_instm_id is '金融工具编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.asset_type_id is '资产类型编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.market_type_id is '市场类型编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fin_instm_name is '金融工具名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fin_instm_abbr is '金融工具简称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.asset_type_name is '资产类型名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.prod_cls_tenor_cd is '产品分类期限代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issue_org_id is '发行机构编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.discov_org_cls_name is '发现机构分类名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issue_dt is '发行日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.tenor_cd is '期限代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.base_rat_id is '基准利率编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issue_way_cd is '发行模式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.cty_cd is '国家代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fac_val_amt is '票面金额';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fac_val_int_rat is '票面利率';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fwd_int_rat_curve is '远期利率曲线';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.disct_int_rat_curve is '折现利率曲线';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.risk_wt is '风险权重';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.pay_int_ped_cd is '付息周期代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.pay_int_freq is '付息频率';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fir_pay_int_dt is '首次付息日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.underly_fin_instm_id is '标的金融工具编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.underly_asset_type_id is '标的资产类型编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.underly_market_type_id is '标的市场类型编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issuer_cust_id is '发行人客户编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.mger_cust_id is '管理人客户编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.mger_id is '管理人编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.mger_name is '管理人名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.mgmt_mode_cd is '管理模式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.contn_weight_flg is '含权标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.cashflow_get_way_cd is '现金流获取方式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.spec_aim_vector_type_cd is '特定目的载体类型代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.spec_aim_vector_code is '特定目的载体编码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.am_prod_stat_code is '资管产品统计编码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issuer_id is '发行人编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.issuer_rg_cd is '发行人地区代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.move_way_cd is '运行方式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.non_uder_asset_cls_cd is '非底层资产分类代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.non_uder_asset_subclass_cd is '非底层资产细类代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_input_freq_cd is '缓释录入频率代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_input_dt is '缓释录入日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_effect_dt is '缓释生效日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_exp_dt is '缓释到期日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.margin_dr_ratio is '保证金缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.hxb_dep_rcpt_dr_ratio is '我行存单缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.tbond_dr_ratio is '国债缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.chn_pb_bond_dr_ratio is '我国政策性银行债券缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.chn_cb_dr_ratio is '我国商业银行缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.chn_pub_dept_dr_ratio is '我国公共部门缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.other_dr_ratio is '其他缓释比例';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_prod_descb_info is '缓释品描述信息';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_acct_id is '缓释账户编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.dr_acct_bal is '缓释账户余额';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.fund_open_dt is '基金开放日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.actl_finer_cust_id is '实际融资人客户编号';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.actl_finer_name is '实际融资人名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.actl_finer_group_name is '实际融资人集团名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.set_open_flg is '定开标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.set_open_ped_cd is '定开周期代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.open_type_cd is '开放类型代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.incre_crdt_way_cd is '增信方式代码';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.incre_crdt_main_name is '增信主体名称';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.set_open_tenor_start_dt is '定开期限开始日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.set_open_tenor_end_dt is '定开期限结束日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.usage_descb is '用途描述';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.guar_way_comb is '担保方式组合';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.crdt_class_proj_flg is '信贷类项目标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.asset_supt_secu_flg is '资产证券化产品标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.noth_rating_abs_flg is '无评级资产证券化标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.abs_flg is '再资产证券化标志';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.list_dt is '上市日期';
comment on column ${idl_schema}.icrm_cmm_ibank_fin_instm.nv_type_dir_indus_type_cd is '净值型投向行业类型代码';

