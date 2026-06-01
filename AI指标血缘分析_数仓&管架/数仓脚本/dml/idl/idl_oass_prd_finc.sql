/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_prd_finc
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_prd_finc drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_prd_finc add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_prd_finc (
etl_dt  --ETL处理日期
,finc_prod_id  --理财产品编号
,prod_belong_cate_cd  --产品归属类别代码
,ref_yld_rat_comnt  --参考收益率说明
,prod_cate_cd  --产品类别代码
,ta_cd  --TA代码
,prod_name  --产品名称
,prod_alias  --产品别名
,prod_nv  --产品净值
,prod_fac_val  --产品面值
,issue_price  --发行价格
,prod_sponsor_cd  --产品发起人代码
,prod_trustee_cd  --产品托管人代码
,prod_mger_cd  --产品管理人代码
,prod_host_org_id  --产品主办机构编号
,coll_start_dt  --募集开始日期
,coll_end_dt  --募集结束日期
,prod_found_dt  --产品成立日期
,prod_value_dt  --产品起息日期
,prod_end_dt  --产品结束日期
,prft_exp_dt  --收益到期日期
,coll_fail_dt  --募集失败日期
,coll_post_close_exp_day  --募集后封闭到期日
,actl_found_dt  --实际成立日期
,prod_lowt_coll_amt  --产品最低募集金额
,prod_higt_coll_amt  --产品最高募集金额
,prod_lowt_coll_lot  --产品最低募集份额
,prod_higt_coll_lot  --产品最高募集份额
,prod_actl_coll_amt  --产品实际募集金额
,curr_size  --当前规模
,allow_divd_way_cd  --允许的分红方式代码
,deflt_divd_way_cd  --默认分红方式代码
,sell_rg_ctrl_flg  --销售区域控制标志
,lmt_ctrl_flg  --额度控制标志
,coll_term_acct_mode_cd  --募集期账务模式代码
,open_term_acct_mode_cd  --开放期账务模式代码
,chn_cd  --渠道代码
,allow_cust_group_list  --允许客户组列表
,ctrl_flg  --控制标志
,bta_ctrl_flg  --BTA控制标志
,charge_way_cd  --收费方式代码
,prft_embody_way_cd  --收益体现方式代码
,prod_attr_cd  --产品属性代码
,risk_level_cd  --风险等级代码
,status_cd  --状态代码
,tran_flg  --转换标志
,curr_cd  --币种代码
,ec_flg  --钞汇标志
,open_tm  --开市时间
,close_tm  --闭市时间
,indv_min_buy_corp  --个人最小购买单位
,indv_fir_lowt_invest_amt  --个人首次最低投资金额
,indv_supp_lowt_invest_amt  --个人追加最低投资金额
,indv_lowt_aip_amt  --个人最低定投金额
,indv_lowt_hold_lot  --个人最低持有份额
,indv_sig_least_redem_lot  --个人单笔最少赎回份额
,indv_sig_max_redem_lot  --个人单笔最大赎回份额
,indv_redem_corp  --个人赎回单位
,indv_lowt_fund_tran_lot  --个人最低基金转换份额
,indv_sig_max_buy_amt  --个人单笔最大购买金额
,indv_single_acct_amax_bamt  --个人单户累计最大购买金额
,org_min_buy_corp  --机构最小购买单位
,org_fir_lowt_invest_amt  --机构首次最低投资金额
,org_supp_lowt_invest_amt  --机构追加最低投资金额
,org_lowt_aip_amt  --机构最低定投金额
,org_lowt_hold_lot  --机构最低持有份额
,org_sig_min_redem_lot  --机构单笔最小赎回份额
,org_sig_max_redem_lot  --机构单笔最大赎回份额
,org_redem_corp  --机构赎回单位
,org_lowt_fund_tran_lot  --机构最低基金转换份额
,org_sig_max_buy_amt  --机构单笔最大购买金额
,org_single_acct_amax_bamt  --机构单户累计最大购买金额
,coll_start_tm  --募集开始时间
,buy_acct_id  --购买账户编号
,redem_acct_id  --赎回账户编号
,realtm_redem_adv_exp_acct_id  --实时赎回垫支账户编号
,redem_cap_avl_days  --赎回资金到账天数
,divd_cap_avl_days  --分红资金到账天数
,prod_exp_cap_avl_days  --产品到期资金到账天数
,huge_redem_ratio  --巨额赎回比例
,prod_int_accr_base  --产品计息基数
,subscr_int_accr_base  --认购利息计息基数
,mgmt_fee_base_days  --管理费基础天数
,expe_yld_rat  --预期收益率
,ped_days  --周期天数
,tard_way_cd  --交易方式代码
,prod_tepla_id  --产品模板编号
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,supt_buy_way_cd  --支持购买方式代码
,std_prod_id  --开户柜员编号
,prod_id  --产品编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id --理财产品编号
,replace(replace(t1.prod_belong_cate_cd,chr(13),''),chr(10),'') as prod_belong_cate_cd --产品归属类别代码
,replace(replace(t1.ref_yld_rat_comnt,chr(13),''),chr(10),'') as ref_yld_rat_comnt --参考收益率说明
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd --产品类别代码
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name --产品名称
,replace(replace(t1.prod_alias,chr(13),''),chr(10),'') as prod_alias --产品别名
,t1.prod_nv as prod_nv --产品净值
,t1.prod_fac_val as prod_fac_val --产品面值
,t1.issue_price as issue_price --发行价格
,replace(replace(t1.prod_sponsor_cd,chr(13),''),chr(10),'') as prod_sponsor_cd --产品发起人代码
,replace(replace(t1.prod_trustee_cd,chr(13),''),chr(10),'') as prod_trustee_cd --产品托管人代码
,replace(replace(t1.prod_mger_cd,chr(13),''),chr(10),'') as prod_mger_cd --产品管理人代码
,replace(replace(t1.prod_host_org_id,chr(13),''),chr(10),'') as prod_host_org_id --产品主办机构编号
,t1.coll_start_dt as coll_start_dt --募集开始日期
,t1.coll_end_dt as coll_end_dt --募集结束日期
,t1.prod_found_dt as prod_found_dt --产品成立日期
,t1.prod_value_dt as prod_value_dt --产品起息日期
,t1.prod_end_dt as prod_end_dt --产品结束日期
,t1.prft_exp_dt as prft_exp_dt --收益到期日期
,t1.coll_fail_dt as coll_fail_dt --募集失败日期
,t1.coll_post_close_exp_day as coll_post_close_exp_day --募集后封闭到期日
,t1.actl_found_dt as actl_found_dt --实际成立日期
,t1.prod_lowt_coll_amt as prod_lowt_coll_amt --产品最低募集金额
,t1.prod_higt_coll_amt as prod_higt_coll_amt --产品最高募集金额
,t1.prod_lowt_coll_lot as prod_lowt_coll_lot --产品最低募集份额
,t1.prod_higt_coll_lot as prod_higt_coll_lot --产品最高募集份额
,t1.prod_actl_coll_amt as prod_actl_coll_amt --产品实际募集金额
,t1.curr_size as curr_size --当前规模
,replace(replace(t1.allow_divd_way_cd,chr(13),''),chr(10),'') as allow_divd_way_cd --允许的分红方式代码
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd --默认分红方式代码
,replace(replace(t1.sell_rg_ctrl_flg,chr(13),''),chr(10),'') as sell_rg_ctrl_flg --销售区域控制标志
,replace(replace(t1.lmt_ctrl_flg,chr(13),''),chr(10),'') as lmt_ctrl_flg --额度控制标志
,replace(replace(t1.coll_term_acct_mode_cd,chr(13),''),chr(10),'') as coll_term_acct_mode_cd --募集期账务模式代码
,replace(replace(t1.open_term_acct_mode_cd,chr(13),''),chr(10),'') as open_term_acct_mode_cd --开放期账务模式代码
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd --渠道代码
,replace(replace(t1.allow_cust_group_list,chr(13),''),chr(10),'') as allow_cust_group_list --允许客户组列表
,replace(replace(t1.ctrl_flg,chr(13),''),chr(10),'') as ctrl_flg --控制标志
,replace(replace(t1.bta_ctrl_flg,chr(13),''),chr(10),'') as bta_ctrl_flg --BTA控制标志
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd --收费方式代码
,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd --收益体现方式代码
,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'') as prod_attr_cd --产品属性代码
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd --风险等级代码
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd --状态代码
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg --转换标志
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg --钞汇标志
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm --开市时间
,replace(replace(t1.close_tm,chr(13),''),chr(10),'') as close_tm --闭市时间
,t1.indv_min_buy_corp as indv_min_buy_corp --个人最小购买单位
,t1.indv_fir_lowt_invest_amt as indv_fir_lowt_invest_amt --个人首次最低投资金额
,t1.indv_supp_lowt_invest_amt as indv_supp_lowt_invest_amt --个人追加最低投资金额
,t1.indv_lowt_aip_amt as indv_lowt_aip_amt --个人最低定投金额
,t1.indv_lowt_hold_lot as indv_lowt_hold_lot --个人最低持有份额
,t1.indv_sig_least_redem_lot as indv_sig_least_redem_lot --个人单笔最少赎回份额
,t1.indv_sig_max_redem_lot as indv_sig_max_redem_lot --个人单笔最大赎回份额
,t1.indv_redem_corp as indv_redem_corp --个人赎回单位
,t1.indv_lowt_fund_tran_lot as indv_lowt_fund_tran_lot --个人最低基金转换份额
,t1.indv_sig_max_buy_amt as indv_sig_max_buy_amt --个人单笔最大购买金额
,t1.indv_single_acct_amax_bamt as indv_single_acct_amax_bamt --个人单户累计最大购买金额
,t1.org_min_buy_corp as org_min_buy_corp --机构最小购买单位
,t1.org_fir_lowt_invest_amt as org_fir_lowt_invest_amt --机构首次最低投资金额
,t1.org_supp_lowt_invest_amt as org_supp_lowt_invest_amt --机构追加最低投资金额
,t1.org_lowt_aip_amt as org_lowt_aip_amt --机构最低定投金额
,t1.org_lowt_hold_lot as org_lowt_hold_lot --机构最低持有份额
,t1.org_sig_min_redem_lot as org_sig_min_redem_lot --机构单笔最小赎回份额
,t1.org_sig_max_redem_lot as org_sig_max_redem_lot --机构单笔最大赎回份额
,t1.org_redem_corp as org_redem_corp --机构赎回单位
,t1.org_lowt_fund_tran_lot as org_lowt_fund_tran_lot --机构最低基金转换份额
,t1.org_sig_max_buy_amt as org_sig_max_buy_amt --机构单笔最大购买金额
,t1.org_single_acct_amax_bamt as org_single_acct_amax_bamt --机构单户累计最大购买金额
,replace(replace(t1.coll_start_tm,chr(13),''),chr(10),'') as coll_start_tm --募集开始时间
,replace(replace(t1.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id --购买账户编号
,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id --赎回账户编号
,replace(replace(t1.realtm_redem_adv_exp_acct_id,chr(13),''),chr(10),'') as realtm_redem_adv_exp_acct_id --实时赎回垫支账户编号
,t1.redem_cap_avl_days as redem_cap_avl_days --赎回资金到账天数
,t1.divd_cap_avl_days as divd_cap_avl_days --分红资金到账天数
,t1.prod_exp_cap_avl_days as prod_exp_cap_avl_days --产品到期资金到账天数
,t1.huge_redem_ratio as huge_redem_ratio --巨额赎回比例
,t1.prod_int_accr_base as prod_int_accr_base --产品计息基数
,t1.subscr_int_accr_base as subscr_int_accr_base --认购利息计息基数
,t1.mgmt_fee_base_days as mgmt_fee_base_days --管理费基础天数
,t1.expe_yld_rat as expe_yld_rat --预期收益率
,t1.ped_days as ped_days --周期天数
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd --交易方式代码
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id --产品模板编号
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.supt_buy_way_cd,chr(13),''),chr(10),'') as supt_buy_way_cd --支持购买方式代码
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --开户柜员编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.prd_finc t1    --理财产品
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_prd_finc',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
