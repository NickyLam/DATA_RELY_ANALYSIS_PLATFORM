/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_appl_indv_loan_attach_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h(
etl_dt date --数据日期
,buy_cont_id varchar2(250) --购房合同编号
,house_form_cd varchar2(60) --房屋形式代码
,house_level_cd varchar2(60) --房屋等级代码
,fir_buy_flg varchar2(10) --首次购房标志
,house_wat_num varchar2(250) --房屋权证号
,house_dtl_addr varchar2(2000) --房屋详细地址
,house_cnt number(10,0) --房屋套数
,house_tot_price number(30,2) --房屋总价
,arch_area number(30,2) --建筑面积
,set_of_area number(30,2) --套内面积
,arch_area_price number(30,2) --建筑面积单价
,set_of_area_price number(30,2) --套内面积单价
,first_pay_amt number(30,2) --首付金额
,first_pay_ratio number(18,6) --首付比例
,down_payment_src_descb varchar2(2000) --首付款来源描述
,loan_ratio number(18,6) --贷款比例
,estim_price number(30,2) --评估价格
,idtfy_price number(30,2) --认定价格
,estim_org_cert_no varchar2(100) --评估机构证件号码
,estim_org_name varchar2(500) --评估机构名称
,int_sub_flg varchar2(10) --贴息标志
,int_sub_ratio number(18,6) --贴息比例
,cap_dir_cd varchar2(100) --资金投向代码
,buy_insure_flg varchar2(10) --购买保险标志
,insure_breed_id varchar2(500) --保险品种编号
,insu_benef_lmt number(30,2) --保险金额
,insure_tenor number(10,0) --保险期限
,distr_mode_pay_cd varchar2(60) --放款支付方式代码
,pay_obj_name varchar2(500) --支付对象名称
,car_type varchar2(250) --车型
,seller_corp_cd varchar2(100) --经销商企业代码
,seller_bus_lics_id varchar2(250) --经销商营业执照编号
,seller_corp_name varchar2(500) --经销商企业名称
,estat_name varchar2(500) --楼盘名称
,arti_mgmt_fee_price number(30,2) --物管费单价
,free_claim_rat number(18,8) --免赔率
,guar_flg varchar2(10) --担保标志
,guar_type_cd varchar2(60) --担保类型代码
,presell_lics_id varchar2(250) --预售许可证编号
,seller_bear_repo_duty_flg varchar2(10) --经销商承担回购责任标志
,rela_agt_id varchar2(250) --相关协议书编号
,insu_comp_name varchar2(500) --保险公司名称
,insure_cont_id varchar2(250) --保险合同编号
,buy_estate_type_cd varchar2(60) --所购房产类型代码
,buy_estate_area number(30,2) --所购房产面积
,fitmt_tot_price number(30,8) --装修总价
,comm_fee_amt number(30,2) --手续费金额
,comm_fee_mode_pay_cd varchar2(60) --手续费支付方式代码
,rela_agent_recd_id varchar2(250) --关联中介备案编号
,seller_ps_name varchar2(500) --卖房人名称
,seller_ps_cert_no varchar2(60) --卖房人证件号码
,rel_esat_cert_id varchar2(250) --不动产证件编号
,buy_car_cont_id varchar2(250) --购车合同编号
,buy_carp_dtl_addr varchar2(2000) --购车位详细地址
,carp_area number(30,2) --车位面积
,carp_tot_price number(30,8) --车位总价
,indv_opering_loan_cls_cd varchar2(60) --个人经营性贷款分类代码
,open_corp_stl_acct_flg varchar2(10) --能开立单位结算账户标志
,es_envi_prot_cls_cd varchar2(60) --节能环保分类代码
,entr_loan_risk_cls_cd varchar2(60) --委托贷款风险分类代码
,entr_loan_dep_acct_id varchar2(250) --委托贷款存款账户编号
,entr_dep_curr_cd varchar2(30) --委托存款币种代码
,entr_dep_amt number(30,2) --委托存款金额
,entr_cond_descb varchar2(2000) --委托条件描述
,car_tot_price number(30,8) --汽车总价
,indv_loan_comm_fee_rat number(18,8) --个人贷款手续费率
,lp_id varchar2(100) --法人编号
,arch_corp_name varchar2(500) --建筑单位名称
,expt_lmt_flg varchar2(60) --例外额度标志
,onl_apv_flg varchar2(60) --线上审批标志
,white_acct_flg varchar2(10) --白户标志
,bar_flg varchar2(60) --随借随还标志
,and_hxb_exist_incid_rela_flg varchar2(60) --与我行存在关联关系标志
,hxb_open_supv_acct_flg varchar2(60) --在我行开立监管账户标志
,blon_loan_amort_exp_dt date --气球贷摊销到期日期
,intd_blip_flg varchar2(10) --引入影像标志
,blip_flow_num varchar2(100) --影像流水号
,blip_cmplt_upload_flg varchar2(10) --影像完成上传标志
,sugst_loan_amt number(30,2) --建议贷款金额
,redem_house_lon_final_risk_mgmt_rest_cd varchar2(30) --赎楼贷最终风控结果代码
,deflt_repay_day varchar2(10) --默认还款日
,rela_flow_num varchar2(100) --关联流水号
,appl_lmt number(30,2) --申请额度
,recv_bank_name varchar2(500) --收款行名称
,recver_name varchar2(500) --收款人名称
,recver_acct_id varchar2(500) --收款人帐户编号
,grace_days number(10,0) --宽限天数
,open_acct_bind_mobile_no varchar2(60) --开户绑定手机号码
,flow_type_cd varchar2(30) --流程类型代码
,corp_lmt_ctrl_flg varchar2(30) --公司额度管控标志
,rtn_pric_ratio number(30,8) --归还本金比例
,rtn_pric_intrv varchar2(60) --归还本金间隔
,invstg_opinion_descb varchar2(4000) --调查意见描述
,crdt_level number(30,8) --信用等级
,apv_end_tm date --审批结束时间
,chn_id varchar2(100) --渠道编号
,rest_advise_sucs_flg varchar2(10) --结果通知成功标志
,apv_tm timestamp(6) --审批通过时间
,taxpayer_idtfy_num varchar2(250) --纳税人识别号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,appl_id varchar2(250) --申请编号
,appl_flow_num varchar2(250) --申请流水号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h is '贷款申请个人贷款附属信息历史';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_cont_id is '购房合同编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_form_cd is '房屋形式代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_level_cd is '房屋等级代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.fir_buy_flg is '首次购房标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_wat_num is '房屋权证号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_dtl_addr is '房屋详细地址';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_cnt is '房屋套数';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.house_tot_price is '房屋总价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.arch_area is '建筑面积';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.set_of_area is '套内面积';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.arch_area_price is '建筑面积单价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.set_of_area_price is '套内面积单价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.first_pay_amt is '首付金额';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.first_pay_ratio is '首付比例';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.down_payment_src_descb is '首付款来源描述';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.loan_ratio is '贷款比例';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.estim_price is '评估价格';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.idtfy_price is '认定价格';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.estim_org_cert_no is '评估机构证件号码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.estim_org_name is '评估机构名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.int_sub_flg is '贴息标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.int_sub_ratio is '贴息比例';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.cap_dir_cd is '资金投向代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_insure_flg is '购买保险标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.insure_breed_id is '保险品种编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.insu_benef_lmt is '保险金额';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.insure_tenor is '保险期限';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.pay_obj_name is '支付对象名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.car_type is '车型';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_corp_cd is '经销商企业代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_bus_lics_id is '经销商营业执照编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_corp_name is '经销商企业名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.estat_name is '楼盘名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.arti_mgmt_fee_price is '物管费单价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.free_claim_rat is '免赔率';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.guar_flg is '担保标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.presell_lics_id is '预售许可证编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_bear_repo_duty_flg is '经销商承担回购责任标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rela_agt_id is '相关协议书编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.insu_comp_name is '保险公司名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.insure_cont_id is '保险合同编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_estate_type_cd is '所购房产类型代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_estate_area is '所购房产面积';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.fitmt_tot_price is '装修总价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rela_agent_recd_id is '关联中介备案编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_ps_name is '卖房人名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.seller_ps_cert_no is '卖房人证件号码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rel_esat_cert_id is '不动产证件编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_car_cont_id is '购车合同编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.buy_carp_dtl_addr is '购车位详细地址';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.carp_area is '车位面积';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.carp_tot_price is '车位总价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.indv_opering_loan_cls_cd is '个人经营性贷款分类代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.open_corp_stl_acct_flg is '能开立单位结算账户标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.es_envi_prot_cls_cd is '节能环保分类代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.entr_loan_risk_cls_cd is '委托贷款风险分类代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.entr_loan_dep_acct_id is '委托贷款存款账户编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.entr_dep_curr_cd is '委托存款币种代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.entr_dep_amt is '委托存款金额';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.entr_cond_descb is '委托条件描述';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.car_tot_price is '汽车总价';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.arch_corp_name is '建筑单位名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.expt_lmt_flg is '例外额度标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.onl_apv_flg is '线上审批标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.white_acct_flg is '白户标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.bar_flg is '随借随还标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.and_hxb_exist_incid_rela_flg is '与我行存在关联关系标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.hxb_open_supv_acct_flg is '在我行开立监管账户标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.blon_loan_amort_exp_dt is '气球贷摊销到期日期';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.intd_blip_flg is '引入影像标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.blip_flow_num is '影像流水号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.blip_cmplt_upload_flg is '影像完成上传标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.sugst_loan_amt is '建议贷款金额';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.redem_house_lon_final_risk_mgmt_rest_cd is '赎楼贷最终风控结果代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.deflt_repay_day is '默认还款日';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rela_flow_num is '关联流水号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.appl_lmt is '申请额度';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.recv_bank_name is '收款行名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.recver_name is '收款人名称';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.recver_acct_id is '收款人帐户编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.grace_days is '宽限天数';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.flow_type_cd is '流程类型代码';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.corp_lmt_ctrl_flg is '公司额度管控标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rtn_pric_ratio is '归还本金比例';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rtn_pric_intrv is '归还本金间隔';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.invstg_opinion_descb is '调查意见描述';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.crdt_level is '信用等级';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.apv_end_tm is '审批结束时间';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.chn_id is '渠道编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.rest_advise_sucs_flg is '结果通知成功标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.apv_tm is '审批通过时间';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.appl_id is '申请编号';
comment on column ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h.appl_flow_num is '申请流水号';

