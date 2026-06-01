/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_cont_indv_loan_attach_info_h
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
alter table ${idl_schema}.oass_agt_loan_cont_indv_loan_attach_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_cont_indv_loan_attach_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_cont_indv_loan_attach_info_h (
etl_dt  --数据日期
,buy_cont_id  --购房合同编号
,house_form_cd  --房屋形式代码
,house_level_cd  --房屋等级代码
,fir_buy_flg  --首次购房标志
,house_wat_num  --房屋权证号
,house_dtl_addr  --房屋详细地址
,house_cnt  --房屋套数
,house_tot_price  --房屋总价
,arch_area  --建筑面积
,set_of_area  --套内面积
,arch_area_price  --建筑面积单价
,set_of_area_price  --套内面积单价
,first_pay_amt  --首付金额
,first_pay_ratio  --首付比例
,down_payment_src_descb  --首付款来源描述
,loan_ratio  --贷款比例
,estim_price  --评估价格
,idtfy_price  --认定价格
,estim_org_cert_no  --评估机构证件号码
,estim_org_name  --评估机构名称
,int_sub_flg  --贴息标志
,int_sub_ratio  --贴息比例
,csner_cert_no  --委托人证件号码
,csner_name  --委托人名称
,cap_dir_cd  --资金投向代码
,buy_insure_flg  --购买保险标志
,insure_breed_id  --保险品种编号
,insu_benef_lmt  --保险金额
,insure_tenor  --保险期限
,pay_obj_name  --支付对象名称
,seller_corp_cd  --经销商企业代码
,seller_bus_lics_num  --经销商营业执照号码
,seller_corp_name  --经销商企业名称
,estat_name  --楼盘名称
,arti_mgmt_fee_price  --物管费单价
,free_claim_rat  --免赔率
,guar_flg  --担保标志
,guar_type_cd  --担保类型代码
,presell_lics_id  --预售许可证编号
,seller_bear_repo_duty_flg  --销售商承担回购责任标志
,rela_agt_id  --相关协议书编号
,insu_comp_name  --保险公司名称
,insure_cont_id  --保险合同编号
,buy_estate_type_cd  --所购房产类型代码
,buy_estate_area  --所购房产面积
,fitmt_tot_price  --装修总价
,comm_fee_amt  --手续费金额
,comm_fee_mode_pay_cd  --手续费支付方式代码
,rela_agent_recd_id  --关联中介备案编号
,seller_ps_name  --卖房人名称
,seller_ps_cert_no  --卖房人证件号码
,rel_esat_cert_id  --不动产证件编号
,car_type  --车型
,buy_car_cont_id  --购车合同编号
,buy_carp_dtl_addr  --购车位详细地址
,carp_area  --车位面积
,car_tot_price  --汽车总价
,carp_tot_price  --车位总价
,indv_opering_loan_cls_cd  --个人经营性贷款分类代码
,open_corp_stl_acct_flg  --能开立单位结算账户标志
,loc_strate_new_indus_cd  --本地战略性新兴产业代码
,es_envi_prot_cls_cd  --节能环保分类代码
,entr_loan_risk_cls_cd  --委托贷款风险分类代码
,entr_loan_dep_acct_id  --委托贷款存款账户编号
,entr_dep_curr_cd  --委托存款币种代码
,entr_dep_amt  --委托金额
,cap_src_descb  --资金来源描述
,entr_cond_descb  --委托条件描述
,indv_loan_comm_fee_rat  --个人贷款手续费率
,lp_id  --法人编号
,estim_cert_type_cd  --评估证件类型代码
,arch_corp_name  --建筑单位名称
,csner_cust_id  --委托人客户编号
,expt_lmt_flg  --例外额度标志
,repay_acct_id  --还款账户编号
,repay_acct_name  --还款账户名称
,deflt_repay_day  --默认还款日代码
,bar_flg  --随借随还标志
,hxb_open_supv_acct_flg  --在我行开立监管账户标志
,onl_apv_flg  --线上审批标志
,use_lmt_flg  --使用额度标志
,hxb_rela_party_flg  --我行关联方标志
,chn_id  --渠道编号
,repay_card_type_cd  --还款卡类型代码
,open_acct_bind_id_no  --开户绑定身份证号码
,open_acct_bind_mobile_no  --开户绑定手机号码
,incre_crdt_mode_cd  --增信模式代码
,acm_callbk_amt  --累计回收金额
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,cont_id  --合同编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.buy_cont_id,chr(13),''),chr(10),'') as buy_cont_id --购房合同编号
,replace(replace(t1.house_form_cd,chr(13),''),chr(10),'') as house_form_cd --房屋形式代码
,replace(replace(t1.house_level_cd,chr(13),''),chr(10),'') as house_level_cd --房屋等级代码
,replace(replace(t1.fir_buy_flg,chr(13),''),chr(10),'') as fir_buy_flg --首次购房标志
,replace(replace(t1.house_wat_num,chr(13),''),chr(10),'') as house_wat_num --房屋权证号
,replace(replace(t1.house_dtl_addr,chr(13),''),chr(10),'') as house_dtl_addr --房屋详细地址
,t1.house_cnt as house_cnt --房屋套数
,t1.house_tot_price as house_tot_price --房屋总价
,t1.arch_area as arch_area --建筑面积
,t1.set_of_area as set_of_area --套内面积
,replace(replace(t1.arch_area_price,chr(13),''),chr(10),'') as arch_area_price --建筑面积单价
,replace(replace(t1.set_of_area_price,chr(13),''),chr(10),'') as set_of_area_price --套内面积单价
,t1.first_pay_amt as first_pay_amt --首付金额
,t1.first_pay_ratio as first_pay_ratio --首付比例
,replace(replace(t1.down_payment_src_descb,chr(13),''),chr(10),'') as down_payment_src_descb --首付款来源描述
,t1.loan_ratio as loan_ratio --贷款比例
,t1.estim_price as estim_price --评估价格
,t1.idtfy_price as idtfy_price --认定价格
,replace(replace(t1.estim_org_cert_no,chr(13),''),chr(10),'') as estim_org_cert_no --评估机构证件号码
,replace(replace(t1.estim_org_name,chr(13),''),chr(10),'') as estim_org_name --评估机构名称
,replace(replace(t1.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg --贴息标志
,t1.int_sub_ratio as int_sub_ratio --贴息比例
,replace(replace(t1.csner_cert_no,chr(13),''),chr(10),'') as csner_cert_no --委托人证件号码
,replace(replace(t1.csner_name,chr(13),''),chr(10),'') as csner_name --委托人名称
,replace(replace(t1.cap_dir_cd,chr(13),''),chr(10),'') as cap_dir_cd --资金投向代码
,replace(replace(t1.buy_insure_flg,chr(13),''),chr(10),'') as buy_insure_flg --购买保险标志
,replace(replace(t1.insure_breed_id,chr(13),''),chr(10),'') as insure_breed_id --保险品种编号
,t1.insu_benef_lmt as insu_benef_lmt --保险金额
,t1.insure_tenor as insure_tenor --保险期限
,replace(replace(t1.pay_obj_name,chr(13),''),chr(10),'') as pay_obj_name --支付对象名称
,replace(replace(t1.seller_corp_cd,chr(13),''),chr(10),'') as seller_corp_cd --经销商企业代码
,replace(replace(t1.seller_bus_lics_num,chr(13),''),chr(10),'') as seller_bus_lics_num --经销商营业执照号码
,replace(replace(t1.seller_corp_name,chr(13),''),chr(10),'') as seller_corp_name --经销商企业名称
,replace(replace(t1.estat_name,chr(13),''),chr(10),'') as estat_name --楼盘名称
,t1.arti_mgmt_fee_price as arti_mgmt_fee_price --物管费单价
,t1.free_claim_rat as free_claim_rat --免赔率
,replace(replace(t1.guar_flg,chr(13),''),chr(10),'') as guar_flg --担保标志
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.presell_lics_id,chr(13),''),chr(10),'') as presell_lics_id --预售许可证编号
,replace(replace(t1.seller_bear_repo_duty_flg,chr(13),''),chr(10),'') as seller_bear_repo_duty_flg --销售商承担回购责任标志
,replace(replace(t1.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id --相关协议书编号
,replace(replace(t1.insu_comp_name,chr(13),''),chr(10),'') as insu_comp_name --保险公司名称
,replace(replace(t1.insure_cont_id,chr(13),''),chr(10),'') as insure_cont_id --保险合同编号
,replace(replace(t1.buy_estate_type_cd,chr(13),''),chr(10),'') as buy_estate_type_cd --所购房产类型代码
,t1.buy_estate_area as buy_estate_area --所购房产面积
,t1.fitmt_tot_price as fitmt_tot_price --装修总价
,t1.comm_fee_amt as comm_fee_amt --手续费金额
,replace(replace(t1.comm_fee_mode_pay_cd,chr(13),''),chr(10),'') as comm_fee_mode_pay_cd --手续费支付方式代码
,replace(replace(t1.rela_agent_recd_id,chr(13),''),chr(10),'') as rela_agent_recd_id --关联中介备案编号
,replace(replace(t1.seller_ps_name,chr(13),''),chr(10),'') as seller_ps_name --卖房人名称
,replace(replace(t1.seller_ps_cert_no,chr(13),''),chr(10),'') as seller_ps_cert_no --卖房人证件号码
,replace(replace(t1.rel_esat_cert_id,chr(13),''),chr(10),'') as rel_esat_cert_id --不动产证件编号
,replace(replace(t1.car_type,chr(13),''),chr(10),'') as car_type --车型
,replace(replace(t1.buy_car_cont_id,chr(13),''),chr(10),'') as buy_car_cont_id --购车合同编号
,replace(replace(t1.buy_carp_dtl_addr,chr(13),''),chr(10),'') as buy_carp_dtl_addr --购车位详细地址
,t1.carp_area as carp_area --车位面积
,t1.car_tot_price as car_tot_price --汽车总价
,t1.carp_tot_price as carp_tot_price --车位总价
,replace(replace(t1.indv_opering_loan_cls_cd,chr(13),''),chr(10),'') as indv_opering_loan_cls_cd --个人经营性贷款分类代码
,replace(replace(t1.open_corp_stl_acct_flg,chr(13),''),chr(10),'') as open_corp_stl_acct_flg --能开立单位结算账户标志
,replace(replace(t1.loc_strate_new_indus_cd,chr(13),''),chr(10),'') as loc_strate_new_indus_cd --本地战略性新兴产业代码
,replace(replace(t1.es_envi_prot_cls_cd,chr(13),''),chr(10),'') as es_envi_prot_cls_cd --节能环保分类代码
,replace(replace(t1.entr_loan_risk_cls_cd,chr(13),''),chr(10),'') as entr_loan_risk_cls_cd --委托贷款风险分类代码
,replace(replace(t1.entr_loan_dep_acct_id,chr(13),''),chr(10),'') as entr_loan_dep_acct_id --委托贷款存款账户编号
,replace(replace(t1.entr_dep_curr_cd,chr(13),''),chr(10),'') as entr_dep_curr_cd --委托存款币种代码
,t1.entr_dep_amt as entr_dep_amt --委托金额
,replace(replace(t1.cap_src_descb,chr(13),''),chr(10),'') as cap_src_descb --资金来源描述
,replace(replace(t1.entr_cond_descb,chr(13),''),chr(10),'') as entr_cond_descb --委托条件描述
,t1.indv_loan_comm_fee_rat as indv_loan_comm_fee_rat --个人贷款手续费率
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.estim_cert_type_cd,chr(13),''),chr(10),'') as estim_cert_type_cd --评估证件类型代码
,replace(replace(t1.arch_corp_name,chr(13),''),chr(10),'') as arch_corp_name --建筑单位名称
,replace(replace(t1.csner_cust_id,chr(13),''),chr(10),'') as csner_cust_id --委托人客户编号
,replace(replace(t1.expt_lmt_flg,chr(13),''),chr(10),'') as expt_lmt_flg --例外额度标志
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id --还款账户编号
,replace(replace(t1.repay_acct_name,chr(13),''),chr(10),'') as repay_acct_name --还款账户名称
,replace(replace(t1.deflt_repay_day,chr(13),''),chr(10),'') as deflt_repay_day --默认还款日代码
,replace(replace(t1.bar_flg,chr(13),''),chr(10),'') as bar_flg --随借随还标志
,replace(replace(t1.hxb_open_supv_acct_flg,chr(13),''),chr(10),'') as hxb_open_supv_acct_flg --在我行开立监管账户标志
,replace(replace(t1.onl_apv_flg,chr(13),''),chr(10),'') as onl_apv_flg --线上审批标志
,replace(replace(t1.use_lmt_flg,chr(13),''),chr(10),'') as use_lmt_flg --使用额度标志
,replace(replace(t1.hxb_rela_party_flg,chr(13),''),chr(10),'') as hxb_rela_party_flg --我行关联方标志
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id --渠道编号
,replace(replace(t1.repay_card_type_cd,chr(13),''),chr(10),'') as repay_card_type_cd --还款卡类型代码
,replace(replace(t1.open_acct_bind_id_no,chr(13),''),chr(10),'') as open_acct_bind_id_no --开户绑定身份证号码
,replace(replace(t1.open_acct_bind_mobile_no,chr(13),''),chr(10),'') as open_acct_bind_mobile_no --开户绑定手机号码
,replace(replace(t1.incre_crdt_mode_cd,chr(13),''),chr(10),'') as incre_crdt_mode_cd --增信模式代码
,t1.acm_callbk_amt as acm_callbk_amt --累计回收金额
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h t1    --贷款合同个人贷款附属信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_cont_indv_loan_attach_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
