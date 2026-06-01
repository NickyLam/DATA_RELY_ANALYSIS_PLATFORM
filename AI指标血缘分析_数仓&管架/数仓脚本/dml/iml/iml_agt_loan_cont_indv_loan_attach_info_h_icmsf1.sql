/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_cont_indv_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bc_personal_loan-1
insert into ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300002'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 合同编号
    ,P1.PURCHASECONTRACTID -- 购房合同编号
    ,nvl(TRIM(P1.HOUSINGFORM),'-') -- 房屋形式代码
    ,nvl(TRIM(P1.HOUSINGLEVEL),'-') -- 房屋等级代码
    ,nvl(trim(P1.ISFIRSTPURCHASE),'-') -- 首次购房标志
    ,P1.PROPERTYCERTID -- 房屋权证号
    ,P1.HOUSINGADDRESS -- 房屋详细地址
    ,P1.HOUSINGSUM -- 房屋套数
    ,P1.HOUSINGPRICE -- 房屋总价
    ,P1.BUILDINGAREA -- 建筑面积
    ,P1.SUITESAREA -- 套内面积
    ,P1.BUILDINGUNITPRICE -- 建筑面积单价
    ,P1.SUITESUNITPRICE -- 套内面积单价
    ,P1.DOWNPAYMENT -- 首付金额
    ,P1.PAYMENTRATIO -- 首付比例
    ,P1.PAYMENTBASIS -- 首付款来源描述
    ,P1.LOANRATIO -- 贷款比例
    ,P1.EVALUATEPRICE -- 评估价格
    ,P1.DETERMPRICE -- 认定价格
    ,P1.EVALUATIONCERTID -- 评估机构证件号码
    ,P1.EVALUATIONNAME -- 评估机构名称
    ,nvl(trim(P1.ISDISCOUNT),'-') -- 贴息标志
    ,P1.DISCOUNTRATIO -- 贴息比例
    ,P1.PRINCIPALCERTID -- 委托人证件号码
    ,P1.PRINCIPALNAME -- 委托人名称
    ,nvl(TRIM(P1.LOANDIRECTION),'-') -- 资金投向代码
    ,nvl(trim(P1.ISINSURANCE),'-') -- 购买保险标志
    ,P1.INSURANCEVARIETY -- 保险品种编号
    ,P1.INSURANCE -- 保险金额
    ,P1.INSURANCEPERIOD -- 保险期限
    ,P1.PAYMENTOBJECT -- 支付对象名称
    ,nvl(TRIM(P1.ENTERPRISECODE),'-') -- 经销商企业代码
    ,P1.BUSINESSLICENCE -- 经销商营业执照号码
    ,P1.BUSINESSNAME -- 经销商企业名称
    ,P1.HOUSINGNAME -- 楼盘名称
    ,P1.PROPERTYUNITPRICE -- 物管费单价
    ,P1.EXCESS -- 免赔率
    ,nvl(trim(P1.ISBUSINESSGUARANTEE),'-') -- 担保标志
    ,nvl(TRIM(P1.GUARANTYTYPE),'-') -- 担保类型代码
    ,P1.PRESALEPERMITNO -- 预售许可证编号
    ,P1.ISVENDORASSUMELIABILITY -- 销售商承担回购责任标志
    ,P1.GUARANTEEAGREEMENT -- 相关协议书编号
    ,P1.INSURERNAME -- 保险公司名称
    ,P1.INSURANCECONTRACTNO -- 保险合同编号
    ,nvl(TRIM(P1.PROPERTYTYPE),'-') -- 所购房产类型代码
    ,P1.PROPERTYAREA -- 所购房产面积
    ,P1.FITMENTPRICE -- 装修总价
    ,P1.FEESUM -- 手续费金额
    ,nvl(TRIM(P1.FEEPAYMENT),'-') -- 手续费支付方式代码
    ,P1.RECORDRELATIVESERIALNO -- 关联中介备案编号
    ,P1.SELLERNAME -- 卖房人名称
    ,P1.SELLERCERTID -- 卖房人证件号码
    ,P1.PROPERTYCONTRACTNO -- 不动产证号
    ,P1.VEHICLETYPE -- 车型
    ,P1.VEHICLECONTRACTNO -- 购车合同编号
    ,P1.PARKINGADDRESS -- 购车位详细地址
    ,P1.PARKINGAREA -- 车位面积
    ,P1.VEHICLEPRICE -- 汽车总价
    ,P1.STALLPRICE -- 车位总价
    ,nvl(TRIM(P1.PERSONALBUSINESSLOANSTYPE),'-') -- 个人经营性贷款分类代码
    ,nvl(trim(P1.ISOPENENTSETTLEACCOUNTS),'-') -- 能开立单位结算账户标志
    ,nvl(TRIM(P1.LOCALSTRATEGICINDUSTRY),'-') -- 本地战略性新兴产业代码
    ,nvl(TRIM(P1.ESAEPCLASSIFY),'-') -- 节能环保分类代码
    ,nvl(TRIM(P1.MANDATERISKCLASSIFY),'-') -- 委托贷款风险分类代码
    ,P1.MANDATEDEPOSITACCOUNTS -- 委托贷款存款账户编号
    ,nvl(trim(P1.MANDATEDEPOSITCURRENCY),'-') -- 委托存款币种代码
    ,P1.MANDATEDEPOSITSUM -- 委托金额
    ,P1.FUNDSPROVIDED -- 资金来源描述
    ,P1.MANDATEREQUIREMENT -- 委托条件描述
    ,P1.FEERATIO -- 个人贷款手续费率
    ,'9999' -- 法人编号
    ,nvl(trim(P1.EVALUATIONCERTTYPE),'0000') -- 评估证件类型代码
    ,P1.BUILDINGCOMPANY -- 建筑单位名称
    ,P1.CLIENTNO -- 委托人客户编号
    ,nvl(trim(P1.ISEXCEPTION),'-') -- 例外额度标志
    ,P1.REPAYMENTACCOUNT -- 还款账户编号
    ,P1.REPAYMENTACCNAME -- 还款账户名称
    ,nvl(trim(P1.REPAYDATETYPE),'0') -- 默认还款日代码
    ,nvl(trim(P1.ISLOANANYTIME),'-') -- 随借随还标志
    ,nvl(trim(P1.ISJGACCOUNT),'-') -- 在我行开立监管账户标志
    ,nvl(trim(P1.ISONLINE),'-') -- 线上审批标志
    ,P1.WTHRUSELMT -- 使用额度标志
    ,nvl(trim(P1.ISBANKREL),'-') -- 我行关联方标志
    ,P1.CHANNELNO -- 渠道编号
    ,nvl(TRIM(P1.PAYACCOUNTTYPE),'-') -- 还款卡类型代码
    ,P1.PAYACCOUNTCERTID -- 开户绑定身份证号码
    ,P1.PAYACCOUNTTEL -- 开户绑定手机号码
    ,nvl(trim(P1.CREDITINCRMODE),'-') -- 增信模式代码
    ,P1.TOTALRECYLEAMT -- 累计回收金额
    ,P1.ENDACCOUNTNO -- 最终实体卡号
    ,P1.ENDACCOUNTNAME -- 最终实体卡名称
    ,P1.ENDBANKNO -- 最终实体卡开户行号
    ,P1.ENDBANKNAME -- 最终实体卡开户行名称
    ,P1.ENDCLEARBANKNO -- 最终入账账户清算行行号
    ,nvl(trim(P1.isagriculture),'-') -- 涉农标志
    ,nvl(trim(P1.greenloanpurpose),'-') -- 绿色贷款用途代码
    ,nvl(trim(P1.HIGHINDUSTRY),'-') -- 高技术产业类型代码
    ,nvl(trim(P1.ECONOMYINDUSTRY),'-') -- 数字经济核心产业类型代码
    ,nvl(trim(P1.INTELLECTUALINDUSTRY),'-') -- 投向知识产权密集型产业类型代码
    ,nvl(trim(P1.STRATEGICINDUSTRY),'-') -- 战略新兴产业类型代码
    ,nvl(trim(P1.CULTUREINDUSTRY),'-') -- 投向文化及相关产业类型代码
    ,nvl(trim(P1.CARTYPE),'-') -- 车辆类型代码
    ,nvl(trim(P1.SUBGREENCONSUMELOANPURPOSE),'-') -- 绿色消费子类代码
    ,nvl(trim(P1.PRODUCTCHANNEL),'0000') -- 产品渠道标识代码
    ,nvl(trim(P1.RELATIONSHIP),'00000') -- 借款人与集团关系代码
    ,nvl(trim(P1.ISNEWCOBORROWER),'-') -- 新增共同借款人标志
    ,decode(P1.ISCLAIM,'2','0',' ','-',P1.ISCLAIM) -- 已认领标志
    ,nvl(trim(P1.ISWHITE),'-') -- 白户标志
    ,nvl(trim(P1.ISBIGACCOUNTMODE),'-') -- 大账户模式标志
    ,nvl(trim(P1.RENEWALFLAG),'-') -- 合同支持续期标志
    ,decode(P1.ISFORCEDEAL,'2','0',' ','-',P1.ISFORCEDEAL) -- 强制执行公证标志
    ,nvl(trim(P1.ISBELONGTERM),'-') -- 靠档计息标志
    ,P1.RELSERIALNO -- 房快贷申请关联编号
    ,P1.AVAILEXPOSURE -- 集团客户可用敞口额度
    ,decode(P1.ISGROUPCUSTOMER,'2','0',' ','-',P1.ISGROUPCUSTOMER) -- 集团客户标志
    ,P1.GROUPCUSTCODE -- 集团客户编号
    ,P1.GROUPCUSTNAME -- 集团客户名称
    ,nvl(trim(P1.PAYWAY),'0') -- 贷款发放方式代码
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 支付方式代码
    ,P1.LOANACCOUNTNO -- 入账账户编号
    ,P1.LOANACCOUNTNAME -- 入账账户名称
    ,nvl(trim(P1.BIGLOANPURPOSE),'000000') -- 贷款用途代码
    ,P1.PURPOSE -- 贷款用途描述
    ,P1.TELEPHONE -- 手机号码
    ,nvl(trim(P1.DEALDISPUTEWAY),'4') -- 解决争议方式代码
    ,P1.DEALDISPUTETXT -- 解决争议方式备注
    ,P1.ACCOUNTSERIALNO -- 网贷账户关联流水号
    ,nvl(trim(P1.ZJKJSTATUS),'-') -- 致景科技合同激活状态代码
    ,P1.CLAIMPERSON -- 柜员编号
    ,P1.CENTRALIZEOPERAID -- 登记所属机构编号
    ,${iml_schema}.dateformat_max2(P1.CLAIMDATE) -- 登记日期
    ,P1.CENTRALIZEORGID -- 登记机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bc_personal_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bc_personal_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.buy_cont_id, o.buy_cont_id) as buy_cont_id -- 购房合同编号
    ,nvl(n.house_form_cd, o.house_form_cd) as house_form_cd -- 房屋形式代码
    ,nvl(n.house_level_cd, o.house_level_cd) as house_level_cd -- 房屋等级代码
    ,nvl(n.fir_buy_flg, o.fir_buy_flg) as fir_buy_flg -- 首次购房标志
    ,nvl(n.house_wat_num, o.house_wat_num) as house_wat_num -- 房屋权证号
    ,nvl(n.house_dtl_addr, o.house_dtl_addr) as house_dtl_addr -- 房屋详细地址
    ,nvl(n.house_cnt, o.house_cnt) as house_cnt -- 房屋套数
    ,nvl(n.house_tot_price, o.house_tot_price) as house_tot_price -- 房屋总价
    ,nvl(n.arch_area, o.arch_area) as arch_area -- 建筑面积
    ,nvl(n.set_of_area, o.set_of_area) as set_of_area -- 套内面积
    ,nvl(n.arch_area_price, o.arch_area_price) as arch_area_price -- 建筑面积单价
    ,nvl(n.set_of_area_price, o.set_of_area_price) as set_of_area_price -- 套内面积单价
    ,nvl(n.first_pay_amt, o.first_pay_amt) as first_pay_amt -- 首付金额
    ,nvl(n.first_pay_ratio, o.first_pay_ratio) as first_pay_ratio -- 首付比例
    ,nvl(n.down_payment_src_descb, o.down_payment_src_descb) as down_payment_src_descb -- 首付款来源描述
    ,nvl(n.loan_ratio, o.loan_ratio) as loan_ratio -- 贷款比例
    ,nvl(n.estim_price, o.estim_price) as estim_price -- 评估价格
    ,nvl(n.idtfy_price, o.idtfy_price) as idtfy_price -- 认定价格
    ,nvl(n.estim_org_cert_no, o.estim_org_cert_no) as estim_org_cert_no -- 评估机构证件号码
    ,nvl(n.estim_org_name, o.estim_org_name) as estim_org_name -- 评估机构名称
    ,nvl(n.int_sub_flg, o.int_sub_flg) as int_sub_flg -- 贴息标志
    ,nvl(n.int_sub_ratio, o.int_sub_ratio) as int_sub_ratio -- 贴息比例
    ,nvl(n.csner_cert_no, o.csner_cert_no) as csner_cert_no -- 委托人证件号码
    ,nvl(n.csner_name, o.csner_name) as csner_name -- 委托人名称
    ,nvl(n.cap_dir_cd, o.cap_dir_cd) as cap_dir_cd -- 资金投向代码
    ,nvl(n.buy_insure_flg, o.buy_insure_flg) as buy_insure_flg -- 购买保险标志
    ,nvl(n.insure_breed_id, o.insure_breed_id) as insure_breed_id -- 保险品种编号
    ,nvl(n.insu_benef_lmt, o.insu_benef_lmt) as insu_benef_lmt -- 保险金额
    ,nvl(n.insure_tenor, o.insure_tenor) as insure_tenor -- 保险期限
    ,nvl(n.pay_obj_name, o.pay_obj_name) as pay_obj_name -- 支付对象名称
    ,nvl(n.seller_corp_cd, o.seller_corp_cd) as seller_corp_cd -- 经销商企业代码
    ,nvl(n.seller_bus_lics_num, o.seller_bus_lics_num) as seller_bus_lics_num -- 经销商营业执照号码
    ,nvl(n.seller_corp_name, o.seller_corp_name) as seller_corp_name -- 经销商企业名称
    ,nvl(n.estat_name, o.estat_name) as estat_name -- 楼盘名称
    ,nvl(n.arti_mgmt_fee_price, o.arti_mgmt_fee_price) as arti_mgmt_fee_price -- 物管费单价
    ,nvl(n.free_claim_rat, o.free_claim_rat) as free_claim_rat -- 免赔率
    ,nvl(n.guar_flg, o.guar_flg) as guar_flg -- 担保标志
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.presell_lics_id, o.presell_lics_id) as presell_lics_id -- 预售许可证编号
    ,nvl(n.seller_bear_repo_duty_flg, o.seller_bear_repo_duty_flg) as seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,nvl(n.rela_agt_id, o.rela_agt_id) as rela_agt_id -- 相关协议书编号
    ,nvl(n.insu_comp_name, o.insu_comp_name) as insu_comp_name -- 保险公司名称
    ,nvl(n.insure_cont_id, o.insure_cont_id) as insure_cont_id -- 保险合同编号
    ,nvl(n.buy_estate_type_cd, o.buy_estate_type_cd) as buy_estate_type_cd -- 所购房产类型代码
    ,nvl(n.buy_estate_area, o.buy_estate_area) as buy_estate_area -- 所购房产面积
    ,nvl(n.fitmt_tot_price, o.fitmt_tot_price) as fitmt_tot_price -- 装修总价
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.comm_fee_mode_pay_cd, o.comm_fee_mode_pay_cd) as comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,nvl(n.rela_agent_recd_id, o.rela_agent_recd_id) as rela_agent_recd_id -- 关联中介备案编号
    ,nvl(n.seller_ps_name, o.seller_ps_name) as seller_ps_name -- 卖房人名称
    ,nvl(n.seller_ps_cert_no, o.seller_ps_cert_no) as seller_ps_cert_no -- 卖房人证件号码
    ,nvl(n.rel_esat_cert_id, o.rel_esat_cert_id) as rel_esat_cert_id -- 不动产证号
    ,nvl(n.car_type, o.car_type) as car_type -- 车型
    ,nvl(n.buy_car_cont_id, o.buy_car_cont_id) as buy_car_cont_id -- 购车合同编号
    ,nvl(n.buy_carp_dtl_addr, o.buy_carp_dtl_addr) as buy_carp_dtl_addr -- 购车位详细地址
    ,nvl(n.carp_area, o.carp_area) as carp_area -- 车位面积
    ,nvl(n.car_tot_price, o.car_tot_price) as car_tot_price -- 汽车总价
    ,nvl(n.carp_tot_price, o.carp_tot_price) as carp_tot_price -- 车位总价
    ,nvl(n.indv_opering_loan_cls_cd, o.indv_opering_loan_cls_cd) as indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,nvl(n.open_corp_stl_acct_flg, o.open_corp_stl_acct_flg) as open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,nvl(n.loc_strate_new_indus_cd, o.loc_strate_new_indus_cd) as loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,nvl(n.es_envi_prot_cls_cd, o.es_envi_prot_cls_cd) as es_envi_prot_cls_cd -- 节能环保分类代码
    ,nvl(n.entr_loan_risk_cls_cd, o.entr_loan_risk_cls_cd) as entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,nvl(n.entr_loan_dep_acct_id, o.entr_loan_dep_acct_id) as entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,nvl(n.entr_dep_curr_cd, o.entr_dep_curr_cd) as entr_dep_curr_cd -- 委托存款币种代码
    ,nvl(n.entr_dep_amt, o.entr_dep_amt) as entr_dep_amt -- 委托金额
    ,nvl(n.cap_src_descb, o.cap_src_descb) as cap_src_descb -- 资金来源描述
    ,nvl(n.entr_cond_descb, o.entr_cond_descb) as entr_cond_descb -- 委托条件描述
    ,nvl(n.indv_loan_comm_fee_rat, o.indv_loan_comm_fee_rat) as indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.estim_cert_type_cd, o.estim_cert_type_cd) as estim_cert_type_cd -- 评估证件类型代码
    ,nvl(n.arch_corp_name, o.arch_corp_name) as arch_corp_name -- 建筑单位名称
    ,nvl(n.csner_cust_id, o.csner_cust_id) as csner_cust_id -- 委托人客户编号
    ,nvl(n.expt_lmt_flg, o.expt_lmt_flg) as expt_lmt_flg -- 例外额度标志
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.repay_acct_name, o.repay_acct_name) as repay_acct_name -- 还款账户名称
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日代码
    ,nvl(n.bar_flg, o.bar_flg) as bar_flg -- 随借随还标志
    ,nvl(n.hxb_open_supv_acct_flg, o.hxb_open_supv_acct_flg) as hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,nvl(n.onl_apv_flg, o.onl_apv_flg) as onl_apv_flg -- 线上审批标志
    ,nvl(n.use_lmt_flg, o.use_lmt_flg) as use_lmt_flg -- 使用额度标志
    ,nvl(n.hxb_rela_party_flg, o.hxb_rela_party_flg) as hxb_rela_party_flg -- 我行关联方标志
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.repay_card_type_cd, o.repay_card_type_cd) as repay_card_type_cd -- 还款卡类型代码
    ,nvl(n.open_acct_bind_id_no, o.open_acct_bind_id_no) as open_acct_bind_id_no -- 开户绑定身份证号码
    ,nvl(n.open_acct_bind_mobile_no, o.open_acct_bind_mobile_no) as open_acct_bind_mobile_no -- 开户绑定手机号码
    ,nvl(n.incre_crdt_mode_cd, o.incre_crdt_mode_cd) as incre_crdt_mode_cd -- 增信模式代码
    ,nvl(n.acm_callbk_amt, o.acm_callbk_amt) as acm_callbk_amt -- 累计回收金额
    ,nvl(n.final_enty_c_num, o.final_enty_c_num) as final_enty_c_num -- 最终实体卡号
    ,nvl(n.final_enty_c_name, o.final_enty_c_name) as final_enty_c_name -- 最终实体卡名称
    ,nvl(n.final_enty_c_open_bank_num, o.final_enty_c_open_bank_num) as final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,nvl(n.final_enty_c_open_bank_name, o.final_enty_c_open_bank_name) as final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,nvl(n.final_enter_clear_bk_no, o.final_enter_clear_bk_no) as final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农标志
    ,nvl(n.green_crdt_subclass_cd, o.green_crdt_subclass_cd) as green_crdt_subclass_cd -- 绿色贷款用途代码
    ,nvl(n.high_tech_property_type_cd, o.high_tech_property_type_cd) as high_tech_property_type_cd -- 高技术产业类型代码
    ,nvl(n.digit_econ_core_property_type_cd, o.digit_econ_core_property_type_cd) as digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,nvl(n.dir_intel_prop_inte_property_type_cd, o.dir_intel_prop_inte_property_type_cd) as dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.dir_cul_and_rela_property_type_cd, o.dir_cul_and_rela_property_type_cd) as dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,nvl(n.vehic_type_cd, o.vehic_type_cd) as vehic_type_cd -- 车辆类型代码
    ,nvl(n.green_consm_sub_type_cd, o.green_consm_sub_type_cd) as green_consm_sub_type_cd -- 绿色消费子类代码
    ,nvl(n.prod_chn_idf_cd, o.prod_chn_idf_cd) as prod_chn_idf_cd -- 产品渠道标识代码
    ,nvl(n.brwer_and_group_rela_cd, o.brwer_and_group_rela_cd) as brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,nvl(n.add_co_brwer_flg, o.add_co_brwer_flg) as add_co_brwer_flg -- 新增共同借款人标志
    ,nvl(n.aldy_claim_flg, o.aldy_claim_flg) as aldy_claim_flg -- 已认领标志
    ,nvl(n.white_acct_flg, o.white_acct_flg) as white_acct_flg -- 白户标志
    ,nvl(n.bacct_mode_flg, o.bacct_mode_flg) as bacct_mode_flg -- 大账户模式标志
    ,nvl(n.cont_supt_renew_flg, o.cont_supt_renew_flg) as cont_supt_renew_flg -- 合同支持续期标志
    ,nvl(n.enforc_notz_flg, o.enforc_notz_flg) as enforc_notz_flg -- 强制执行公证标志
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,nvl(n.fkd_appl_rela_id, o.fkd_appl_rela_id) as fkd_appl_rela_id -- 房快贷申请关联编号
    ,nvl(n.group_cust_aval_open_lmt, o.group_cust_aval_open_lmt) as group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.group_cust_id, o.group_cust_id) as group_cust_id -- 集团客户编号
    ,nvl(n.group_cust_name, o.group_cust_name) as group_cust_name -- 集团客户名称
    ,nvl(n.loan_distr_way_cd, o.loan_distr_way_cd) as loan_distr_way_cd -- 贷款发放方式代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.proc_argue_way_cd, o.proc_argue_way_cd) as proc_argue_way_cd -- 解决争议方式代码
    ,nvl(n.proc_argue_way_remark, o.proc_argue_way_remark) as proc_argue_way_remark -- 解决争议方式备注
    ,nvl(n.wl_acct_rela_flow_num, o.wl_acct_rela_flow_num) as wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,nvl(n.zjkj_tech_cont_actv_status_cd, o.zjkj_tech_cont_actv_status_cd) as zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.rgst_belong_org_id, o.rgst_belong_org_id) as rgst_belong_org_id -- 登记所属机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
where (
        o.agt_id is null
        and o.cont_id is null
    )
    or (
        n.agt_id is null
        and n.cont_id is null
    )
    or (
        o.buy_cont_id <> n.buy_cont_id
        or o.house_form_cd <> n.house_form_cd
        or o.house_level_cd <> n.house_level_cd
        or o.fir_buy_flg <> n.fir_buy_flg
        or o.house_wat_num <> n.house_wat_num
        or o.house_dtl_addr <> n.house_dtl_addr
        or o.house_cnt <> n.house_cnt
        or o.house_tot_price <> n.house_tot_price
        or o.arch_area <> n.arch_area
        or o.set_of_area <> n.set_of_area
        or o.arch_area_price <> n.arch_area_price
        or o.set_of_area_price <> n.set_of_area_price
        or o.first_pay_amt <> n.first_pay_amt
        or o.first_pay_ratio <> n.first_pay_ratio
        or o.down_payment_src_descb <> n.down_payment_src_descb
        or o.loan_ratio <> n.loan_ratio
        or o.estim_price <> n.estim_price
        or o.idtfy_price <> n.idtfy_price
        or o.estim_org_cert_no <> n.estim_org_cert_no
        or o.estim_org_name <> n.estim_org_name
        or o.int_sub_flg <> n.int_sub_flg
        or o.int_sub_ratio <> n.int_sub_ratio
        or o.csner_cert_no <> n.csner_cert_no
        or o.csner_name <> n.csner_name
        or o.cap_dir_cd <> n.cap_dir_cd
        or o.buy_insure_flg <> n.buy_insure_flg
        or o.insure_breed_id <> n.insure_breed_id
        or o.insu_benef_lmt <> n.insu_benef_lmt
        or o.insure_tenor <> n.insure_tenor
        or o.pay_obj_name <> n.pay_obj_name
        or o.seller_corp_cd <> n.seller_corp_cd
        or o.seller_bus_lics_num <> n.seller_bus_lics_num
        or o.seller_corp_name <> n.seller_corp_name
        or o.estat_name <> n.estat_name
        or o.arti_mgmt_fee_price <> n.arti_mgmt_fee_price
        or o.free_claim_rat <> n.free_claim_rat
        or o.guar_flg <> n.guar_flg
        or o.guar_type_cd <> n.guar_type_cd
        or o.presell_lics_id <> n.presell_lics_id
        or o.seller_bear_repo_duty_flg <> n.seller_bear_repo_duty_flg
        or o.rela_agt_id <> n.rela_agt_id
        or o.insu_comp_name <> n.insu_comp_name
        or o.insure_cont_id <> n.insure_cont_id
        or o.buy_estate_type_cd <> n.buy_estate_type_cd
        or o.buy_estate_area <> n.buy_estate_area
        or o.fitmt_tot_price <> n.fitmt_tot_price
        or o.comm_fee_amt <> n.comm_fee_amt
        or o.comm_fee_mode_pay_cd <> n.comm_fee_mode_pay_cd
        or o.rela_agent_recd_id <> n.rela_agent_recd_id
        or o.seller_ps_name <> n.seller_ps_name
        or o.seller_ps_cert_no <> n.seller_ps_cert_no
        or o.rel_esat_cert_id <> n.rel_esat_cert_id
        or o.car_type <> n.car_type
        or o.buy_car_cont_id <> n.buy_car_cont_id
        or o.buy_carp_dtl_addr <> n.buy_carp_dtl_addr
        or o.carp_area <> n.carp_area
        or o.car_tot_price <> n.car_tot_price
        or o.carp_tot_price <> n.carp_tot_price
        or o.indv_opering_loan_cls_cd <> n.indv_opering_loan_cls_cd
        or o.open_corp_stl_acct_flg <> n.open_corp_stl_acct_flg
        or o.loc_strate_new_indus_cd <> n.loc_strate_new_indus_cd
        or o.es_envi_prot_cls_cd <> n.es_envi_prot_cls_cd
        or o.entr_loan_risk_cls_cd <> n.entr_loan_risk_cls_cd
        or o.entr_loan_dep_acct_id <> n.entr_loan_dep_acct_id
        or o.entr_dep_curr_cd <> n.entr_dep_curr_cd
        or o.entr_dep_amt <> n.entr_dep_amt
        or o.cap_src_descb <> n.cap_src_descb
        or o.entr_cond_descb <> n.entr_cond_descb
        or o.indv_loan_comm_fee_rat <> n.indv_loan_comm_fee_rat
        or o.lp_id <> n.lp_id
        or o.estim_cert_type_cd <> n.estim_cert_type_cd
        or o.arch_corp_name <> n.arch_corp_name
        or o.csner_cust_id <> n.csner_cust_id
        or o.expt_lmt_flg <> n.expt_lmt_flg
        or o.repay_acct_id <> n.repay_acct_id
        or o.repay_acct_name <> n.repay_acct_name
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.bar_flg <> n.bar_flg
        or o.hxb_open_supv_acct_flg <> n.hxb_open_supv_acct_flg
        or o.onl_apv_flg <> n.onl_apv_flg
        or o.use_lmt_flg <> n.use_lmt_flg
        or o.hxb_rela_party_flg <> n.hxb_rela_party_flg
        or o.chn_id <> n.chn_id
        or o.repay_card_type_cd <> n.repay_card_type_cd
        or o.open_acct_bind_id_no <> n.open_acct_bind_id_no
        or o.open_acct_bind_mobile_no <> n.open_acct_bind_mobile_no
        or o.incre_crdt_mode_cd <> n.incre_crdt_mode_cd
        or o.acm_callbk_amt <> n.acm_callbk_amt
        or o.final_enty_c_num <> n.final_enty_c_num
        or o.final_enty_c_name <> n.final_enty_c_name
        or o.final_enty_c_open_bank_num <> n.final_enty_c_open_bank_num
        or o.final_enty_c_open_bank_name <> n.final_enty_c_open_bank_name
        or o.final_enter_clear_bk_no <> n.final_enter_clear_bk_no
        or o.agclt_flg <> n.agclt_flg
        or o.green_crdt_subclass_cd <> n.green_crdt_subclass_cd
        or o.high_tech_property_type_cd <> n.high_tech_property_type_cd
        or o.digit_econ_core_property_type_cd <> n.digit_econ_core_property_type_cd
        or o.dir_intel_prop_inte_property_type_cd <> n.dir_intel_prop_inte_property_type_cd
        or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
        or o.dir_cul_and_rela_property_type_cd <> n.dir_cul_and_rela_property_type_cd
        or o.vehic_type_cd <> n.vehic_type_cd
        or o.green_consm_sub_type_cd <> n.green_consm_sub_type_cd
        or o.prod_chn_idf_cd <> n.prod_chn_idf_cd
        or o.brwer_and_group_rela_cd <> n.brwer_and_group_rela_cd
        or o.add_co_brwer_flg <> n.add_co_brwer_flg
        or o.aldy_claim_flg <> n.aldy_claim_flg
        or o.white_acct_flg <> n.white_acct_flg
        or o.bacct_mode_flg <> n.bacct_mode_flg
        or o.cont_supt_renew_flg <> n.cont_supt_renew_flg
        or o.enforc_notz_flg <> n.enforc_notz_flg
        or o.file_int_accr_flg <> n.file_int_accr_flg
        or o.fkd_appl_rela_id <> n.fkd_appl_rela_id
        or o.group_cust_aval_open_lmt <> n.group_cust_aval_open_lmt
        or o.group_cust_flg <> n.group_cust_flg
        or o.group_cust_id <> n.group_cust_id
        or o.group_cust_name <> n.group_cust_name
        or o.loan_distr_way_cd <> n.loan_distr_way_cd
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.enter_id <> n.enter_id
        or o.enter_name <> n.enter_name
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.mobile_no <> n.mobile_no
        or o.proc_argue_way_cd <> n.proc_argue_way_cd
        or o.proc_argue_way_remark <> n.proc_argue_way_remark
        or o.wl_acct_rela_flow_num <> n.wl_acct_rela_flow_num
        or o.zjkj_tech_cont_actv_status_cd <> n.zjkj_tech_cont_actv_status_cd
        or o.teller_id <> n.teller_id
        or o.rgst_belong_org_id <> n.rgst_belong_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_org_id <> n.rgst_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,buy_cont_id -- 购房合同编号
    ,house_form_cd -- 房屋形式代码
    ,house_level_cd -- 房屋等级代码
    ,fir_buy_flg -- 首次购房标志
    ,house_wat_num -- 房屋权证号
    ,house_dtl_addr -- 房屋详细地址
    ,house_cnt -- 房屋套数
    ,house_tot_price -- 房屋总价
    ,arch_area -- 建筑面积
    ,set_of_area -- 套内面积
    ,arch_area_price -- 建筑面积单价
    ,set_of_area_price -- 套内面积单价
    ,first_pay_amt -- 首付金额
    ,first_pay_ratio -- 首付比例
    ,down_payment_src_descb -- 首付款来源描述
    ,loan_ratio -- 贷款比例
    ,estim_price -- 评估价格
    ,idtfy_price -- 认定价格
    ,estim_org_cert_no -- 评估机构证件号码
    ,estim_org_name -- 评估机构名称
    ,int_sub_flg -- 贴息标志
    ,int_sub_ratio -- 贴息比例
    ,csner_cert_no -- 委托人证件号码
    ,csner_name -- 委托人名称
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,pay_obj_name -- 支付对象名称
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_num -- 经销商营业执照号码
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,rela_agt_id -- 相关协议书编号
    ,insu_comp_name -- 保险公司名称
    ,insure_cont_id -- 保险合同编号
    ,buy_estate_type_cd -- 所购房产类型代码
    ,buy_estate_area -- 所购房产面积
    ,fitmt_tot_price -- 装修总价
    ,comm_fee_amt -- 手续费金额
    ,comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,rela_agent_recd_id -- 关联中介备案编号
    ,seller_ps_name -- 卖房人名称
    ,seller_ps_cert_no -- 卖房人证件号码
    ,rel_esat_cert_id -- 不动产证号
    ,car_type -- 车型
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,car_tot_price -- 汽车总价
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托金额
    ,cap_src_descb -- 资金来源描述
    ,entr_cond_descb -- 委托条件描述
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,lp_id -- 法人编号
    ,estim_cert_type_cd -- 评估证件类型代码
    ,arch_corp_name -- 建筑单位名称
    ,csner_cust_id -- 委托人客户编号
    ,expt_lmt_flg -- 例外额度标志
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,deflt_repay_day -- 默认还款日代码
    ,bar_flg -- 随借随还标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,onl_apv_flg -- 线上审批标志
    ,use_lmt_flg -- 使用额度标志
    ,hxb_rela_party_flg -- 我行关联方标志
    ,chn_id -- 渠道编号
    ,repay_card_type_cd -- 还款卡类型代码
    ,open_acct_bind_id_no -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,acm_callbk_amt -- 累计回收金额
    ,final_enty_c_num -- 最终实体卡号
    ,final_enty_c_name -- 最终实体卡名称
    ,final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,agclt_flg -- 涉农标志
    ,green_crdt_subclass_cd -- 绿色贷款用途代码
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,aldy_claim_flg -- 已认领标志
    ,white_acct_flg -- 白户标志
    ,bacct_mode_flg -- 大账户模式标志
    ,cont_supt_renew_flg -- 合同支持续期标志
    ,enforc_notz_flg -- 强制执行公证标志
    ,file_int_accr_flg -- 靠档计息标志
    ,fkd_appl_rela_id -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,mode_pay_cd -- 支付方式代码
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,loan_usage_cd -- 贷款用途代码
    ,loan_usage_descb -- 贷款用途描述
    ,mobile_no -- 手机号码
    ,proc_argue_way_cd -- 解决争议方式代码
    ,proc_argue_way_remark -- 解决争议方式备注
    ,wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,teller_id -- 柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.cont_id -- 合同编号
    ,o.buy_cont_id -- 购房合同编号
    ,o.house_form_cd -- 房屋形式代码
    ,o.house_level_cd -- 房屋等级代码
    ,o.fir_buy_flg -- 首次购房标志
    ,o.house_wat_num -- 房屋权证号
    ,o.house_dtl_addr -- 房屋详细地址
    ,o.house_cnt -- 房屋套数
    ,o.house_tot_price -- 房屋总价
    ,o.arch_area -- 建筑面积
    ,o.set_of_area -- 套内面积
    ,o.arch_area_price -- 建筑面积单价
    ,o.set_of_area_price -- 套内面积单价
    ,o.first_pay_amt -- 首付金额
    ,o.first_pay_ratio -- 首付比例
    ,o.down_payment_src_descb -- 首付款来源描述
    ,o.loan_ratio -- 贷款比例
    ,o.estim_price -- 评估价格
    ,o.idtfy_price -- 认定价格
    ,o.estim_org_cert_no -- 评估机构证件号码
    ,o.estim_org_name -- 评估机构名称
    ,o.int_sub_flg -- 贴息标志
    ,o.int_sub_ratio -- 贴息比例
    ,o.csner_cert_no -- 委托人证件号码
    ,o.csner_name -- 委托人名称
    ,o.cap_dir_cd -- 资金投向代码
    ,o.buy_insure_flg -- 购买保险标志
    ,o.insure_breed_id -- 保险品种编号
    ,o.insu_benef_lmt -- 保险金额
    ,o.insure_tenor -- 保险期限
    ,o.pay_obj_name -- 支付对象名称
    ,o.seller_corp_cd -- 经销商企业代码
    ,o.seller_bus_lics_num -- 经销商营业执照号码
    ,o.seller_corp_name -- 经销商企业名称
    ,o.estat_name -- 楼盘名称
    ,o.arti_mgmt_fee_price -- 物管费单价
    ,o.free_claim_rat -- 免赔率
    ,o.guar_flg -- 担保标志
    ,o.guar_type_cd -- 担保类型代码
    ,o.presell_lics_id -- 预售许可证编号
    ,o.seller_bear_repo_duty_flg -- 销售商承担回购责任标志
    ,o.rela_agt_id -- 相关协议书编号
    ,o.insu_comp_name -- 保险公司名称
    ,o.insure_cont_id -- 保险合同编号
    ,o.buy_estate_type_cd -- 所购房产类型代码
    ,o.buy_estate_area -- 所购房产面积
    ,o.fitmt_tot_price -- 装修总价
    ,o.comm_fee_amt -- 手续费金额
    ,o.comm_fee_mode_pay_cd -- 手续费支付方式代码
    ,o.rela_agent_recd_id -- 关联中介备案编号
    ,o.seller_ps_name -- 卖房人名称
    ,o.seller_ps_cert_no -- 卖房人证件号码
    ,o.rel_esat_cert_id -- 不动产证号
    ,o.car_type -- 车型
    ,o.buy_car_cont_id -- 购车合同编号
    ,o.buy_carp_dtl_addr -- 购车位详细地址
    ,o.carp_area -- 车位面积
    ,o.car_tot_price -- 汽车总价
    ,o.carp_tot_price -- 车位总价
    ,o.indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,o.open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,o.loc_strate_new_indus_cd -- 本地战略性新兴产业代码
    ,o.es_envi_prot_cls_cd -- 节能环保分类代码
    ,o.entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,o.entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,o.entr_dep_curr_cd -- 委托存款币种代码
    ,o.entr_dep_amt -- 委托金额
    ,o.cap_src_descb -- 资金来源描述
    ,o.entr_cond_descb -- 委托条件描述
    ,o.indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,o.lp_id -- 法人编号
    ,o.estim_cert_type_cd -- 评估证件类型代码
    ,o.arch_corp_name -- 建筑单位名称
    ,o.csner_cust_id -- 委托人客户编号
    ,o.expt_lmt_flg -- 例外额度标志
    ,o.repay_acct_id -- 还款账户编号
    ,o.repay_acct_name -- 还款账户名称
    ,o.deflt_repay_day -- 默认还款日代码
    ,o.bar_flg -- 随借随还标志
    ,o.hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,o.onl_apv_flg -- 线上审批标志
    ,o.use_lmt_flg -- 使用额度标志
    ,o.hxb_rela_party_flg -- 我行关联方标志
    ,o.chn_id -- 渠道编号
    ,o.repay_card_type_cd -- 还款卡类型代码
    ,o.open_acct_bind_id_no -- 开户绑定身份证号码
    ,o.open_acct_bind_mobile_no -- 开户绑定手机号码
    ,o.incre_crdt_mode_cd -- 增信模式代码
    ,o.acm_callbk_amt -- 累计回收金额
    ,o.final_enty_c_num -- 最终实体卡号
    ,o.final_enty_c_name -- 最终实体卡名称
    ,o.final_enty_c_open_bank_num -- 最终实体卡开户行号
    ,o.final_enty_c_open_bank_name -- 最终实体卡开户行名称
    ,o.final_enter_clear_bk_no -- 最终入账账户清算行行号
    ,o.agclt_flg -- 涉农标志
    ,o.green_crdt_subclass_cd -- 绿色贷款用途代码
    ,o.high_tech_property_type_cd -- 高技术产业类型代码
    ,o.digit_econ_core_property_type_cd -- 数字经济核心产业类型代码
    ,o.dir_intel_prop_inte_property_type_cd -- 投向知识产权密集型产业类型代码
    ,o.strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,o.dir_cul_and_rela_property_type_cd -- 投向文化及相关产业类型代码
    ,o.vehic_type_cd -- 车辆类型代码
    ,o.green_consm_sub_type_cd -- 绿色消费子类代码
    ,o.prod_chn_idf_cd -- 产品渠道标识代码
    ,o.brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,o.add_co_brwer_flg -- 新增共同借款人标志
    ,o.aldy_claim_flg -- 已认领标志
    ,o.white_acct_flg -- 白户标志
    ,o.bacct_mode_flg -- 大账户模式标志
    ,o.cont_supt_renew_flg -- 合同支持续期标志
    ,o.enforc_notz_flg -- 强制执行公证标志
    ,o.file_int_accr_flg -- 靠档计息标志
    ,o.fkd_appl_rela_id -- 房快贷申请关联编号
    ,o.group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,o.group_cust_flg -- 集团客户标志
    ,o.group_cust_id -- 集团客户编号
    ,o.group_cust_name -- 集团客户名称
    ,o.loan_distr_way_cd -- 贷款发放方式代码
    ,o.mode_pay_cd -- 支付方式代码
    ,o.enter_id -- 入账账户编号
    ,o.enter_name -- 入账账户名称
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.mobile_no -- 手机号码
    ,o.proc_argue_way_cd -- 解决争议方式代码
    ,o.proc_argue_way_remark -- 解决争议方式备注
    ,o.wl_acct_rela_flow_num -- 网贷账户关联流水号
    ,o.zjkj_tech_cont_actv_status_cd -- 致景科技合同激活状态代码
    ,o.teller_id -- 柜员编号
    ,o.rgst_belong_org_id -- 登记所属机构编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_org_id -- 登记机构编号
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
from ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.cont_id = d.cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_cont_indv_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_cont_indv_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
