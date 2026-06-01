/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_indv_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ba_personal_loan-1
insert into ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 申请流水号
    ,'9999' -- 法人编号
    ,P1.PURCHASECONTRACTID -- 购房合同编号
    ,nvl(trim(P1.HOUSINGFORM),'-') -- 房屋形式代码
    ,nvl(trim(P1.HOUSINGLEVEL),'-') -- 房屋等级代码
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
    ,nvl(trim(P1.LOANDIRECTION),'-') -- 资金投向代码
    ,nvl(trim(P1.ISINSURANCE),'-') -- 购买保险标志
    ,P1.INSURANCEVARIETY -- 保险品种编号
    ,P1.INSURANCE -- 保险金额
    ,P1.INSURANCEPERIOD -- 保险期限
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,P1.PAYMENTOBJECT -- 支付对象名称
    ,P1.VEHICLETYPE -- 车型
    ,nvl(trim(P1.ENTERPRISECODE),'-') -- 经销商企业代码
    ,P1.BUSINESSLICENCE -- 经销商营业执照编号
    ,P1.BUSINESSNAME -- 经销商企业名称
    ,P1.HOUSINGNAME -- 楼盘名称
    ,P1.PROPERTYUNITPRICE -- 物管费单价
    ,P1.EXCESS -- 免赔率
    ,nvl(trim(P1.ISBUSINESSGUARANTEE),'-') -- 担保标志
    ,nvl(trim(P1.GUARANTYTYPE),'-') -- 担保类型代码
    ,P1.PRESALEPERMITNO -- 预售许可证编号
    ,nvl(trim(P1.ISVENDORASSUMELIABILITY),'-') -- 经销商承担回购责任标志
    ,P1.GUARANTEEAGREEMENT -- 相关协议书编号
    ,P1.INSURERNAME -- 保险公司名称
    ,P1.INSURANCECONTRACTNO -- 保险合同编号
    ,nvl(trim(P1.PROPERTYTYPE),'-') -- 所购房产类型代码
    ,P1.PROPERTYAREA -- 所购房产面积
    ,P1.FITMENTPRICE -- 装修总价
    ,P1.FEESUM -- 手续费金额
    ,nvl(trim(P1.FEEPAYMENT),'-') -- 手续费支付方式代码
    ,P1.RECORDRELATIVESERIALNO -- 关联中介备案编号
    ,P1.SELLERNAME -- 卖房人名称
    ,P1.SELLERCERTID -- 卖房人证件号码
    ,P1.PROPERTYCONTRACTNO -- 不动产证号
    ,P1.VEHICLECONTRACTNO -- 购车合同编号
    ,P1.PARKINGADDRESS -- 购车位详细地址
    ,P1.PARKINGAREA -- 车位面积
    ,P1.STALLPRICE -- 车位总价
    ,nvl(trim(P1.PERSONALBUSINESSLOANSTYPE),'-') -- 个人经营性贷款分类代码
    ,nvl(trim(P1.ISOPENENTSETTLEACCOUNTS),'-') -- 能开立单位结算账户标志
    ,nvl(trim(P1.ESAEPCLASSIFY),'-') -- 节能环保分类代码
    ,nvl(trim(P1.MANDATERISKCLASSIFY),'-') -- 委托贷款风险分类代码
    ,P1.MANDATEDEPOSITACCOUNTS -- 委托贷款存款账户编号
    ,nvl(trim(P1.MANDATEDEPOSITCURRENCY),'-') -- 委托存款币种代码
    ,P1.MANDATEDEPOSITSUM -- 委托存款金额
    ,P1.MANDATEREQUIREMENT -- 委托条件描述
    ,P1.VEHICLEPRICE -- 汽车总价
    ,P1.FEERATIO -- 个人贷款手续费率
    ,P1.BUILDINGCOMPANY -- 建筑单位名称
    ,nvl(trim(P1.ISEXCEPTION),'-') -- 例外额度标志
    ,nvl(trim(P1.ISONLINE),'-') -- 线上审批标志
    ,nvl(trim(P1.ISWHITE),'-') -- 白户标志
    ,nvl(trim(P1.ISLOANANYTIME),'-') -- 随借随还标志
    ,P1.ISBANKREL -- 与我行存在关联关系标志
    ,nvl(trim(P1.ISJGACCOUNT),'-') -- 在我行开立监管账户标志
    ,P1.BALLOONAMORTENDDATE -- 气球贷摊销到期日期
    ,P1.ISIMAGE -- 引入影像标志
    ,P1.YXSERNO -- 影像流水号
    ,P1.IMAGEUPFLAG -- 影像完成上传标志
    ,P1.SUGGESTSUM -- 建议贷款金额
    ,P1.FINALRESULT -- 赎楼贷最终风控结果代码
    ,P1.REPAYMENTDATETYPE -- 默认还款日
    ,P1.RELSERIALNO -- 关联流水号
    ,P1.APPLYAMT -- 申请额度
    ,P1.PAYBANKNAME -- 收款行名称
    ,P1.PAYEENAME -- 收款人名称
    ,P1.PAYEEACCOUNTNO -- 收款人帐户编号
    ,P1.GRACEPERIOD -- 宽限天数
    ,P1.PAYEEACCOUNTTEL -- 开户绑定手机号码
    ,nvl(trim(P1.FLOWFLAG),'-')  -- 流程类型代码
    ,P1.COMPANYQUOTACONTROL -- 公司额度管控标志
    ,P1.RETURNCAPITALRATIO -- 归还本金比例
    ,nvl(trim(p1.RETURNCAPITALINTERVAL),0) -- 归还本金间隔
    ,P1.INVESTOINON -- 调查意见描述
    ,P1.CREDITSCORE -- 信用等级
    ,P1.ENDDATE -- 审批结束时间
    ,P1.CHANNELCODE -- 渠道编号
    ,P1.INFORMFLAG -- 结果通知成功标志
    ,decode(P1.PASSTIME,to_date('0001/1/1','yyyy/mm/dd'),to_date( '2999/12/31','yyyy/mm/dd'),P1.PASSTIME) -- 审批通过时间
    ,P1.TAXCODE -- 纳税人识别号
    ,nvl(trim(p1.loanpurposedetails),'000000') -- 贷款用途代码
    ,P1.LOANACCOUNTCLEARBANK -- 入账账户清算行行号
    ,nvl(trim(P1.PRODUCTCHANNEL),'0000') -- 产品渠道标识代码
    ,nvl(trim(P1.ISTHREEMONTHNEWCAR),'-') -- 三个月内上牌新车标志
    ,nvl(trim(P1.CARTYPE),'-') -- 车辆类型代码
    ,nvl(trim(P1.ISCANCEL),'-') -- 撤销标志
    ,P1.WORKINGMONTH -- 从业期限
    ,P1.EMPLOYMENTS -- 从业人员
    ,nvl(trim(P1.INDUSTRY),'-') -- 所属行业类型代码
    ,nvl(trim(P1.LOANPURPOSEDETAILS),'-') -- 贷款用途细类代码
    ,P1.PURPOSE -- 贷款用途描述
    ,P1.COMPANYBUSINESSSUM -- 公司授权总金额
    ,P1.ASSETSTOTAL -- 资产总额
    ,nvl(trim(P1.OTHERLIMITFLAG),'-') -- 占用他用额度标志
    ,P1.RESETAMT -- 重置额度
    ,P1.RISKCONTROLBACK -- 风控背景描述
    ,P1.BASERATEADJUSTPER -- 基准利率上浮比例
    ,nvl(trim(P1.GROUPCUSTCODE),'-') -- 集团客户标志
    ,P1.GROUPCUSTOMERID -- 集团客户编号
    ,P1.GROUPCUSTOMERNAME -- 集团客户名称
    ,P1.GROUPAVAILEXPOSURE -- 集团客户可用敞口额度
    ,nvl(trim(P1.ISCENTRALIZEDOFFICESTAFF),'-') -- 合同制作人员类型代码
    ,P1.OTHERLOANCONTRACTNO -- 借款合同编号
    ,nvl(trim(P1.ISADDAMT),'-') -- 提额标志
    ,nvl(trim(P1.ISRELATEDCOMPANY),'-') -- 借款企业为担保公司的关联企业标志
    ,nvl(trim(P1.GUARANTEECOMPANYNAME),'-') -- 见保即贷业务担保公司代码
    ,P1.INTENTGUARAMT -- 意向担保金额
    ,nvl(trim(P1.ISCOMPANYRELATEDPERSON),'-') -- 担保公司关联人标志
    ,P1.RECOMMENDEDAMT -- 担保公司推荐金额
    ,P1.RECOMMENDEDTERM -- 担保公司推荐期限
    ,P1.GUARCOMPANYTERM -- 担保公司推送期限
    ,P1.AUTHTELEPHONE -- 绑卡鉴权手机号
    ,P1.TELEPHONE -- 借款人手机号码
    ,nvl(trim(P1.CUSGRUOPRELATION),'00000') -- 借款人与集团关系代码
    ,P1.CERTID -- 借款人证件号码
    ,nvl(trim(P1.CERTTYPE),'0000') -- 借款人证件类型代码
    ,nvl(trim(P1.ISBACK),'-') -- 客户捞回标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUSCREDITSCORELEVEL END -- 客户信用评级代码
    ,nvl(trim(P1.INDTYPE),'-') -- 客户性质代码
    ,P1.OPERATIONLOANBALANCESKR -- 实控人经营性贷款余额
    ,P1.BUSIINCOME -- 营业收入
    ,nvl(trim(P1.FLOWBRANCHTYPE),'-') -- 流程分支类型代码
    ,P1.RUNENTYEARINCOME -- 流水推算的年销售收入
    ,P1.YEARINCOMERATE -- 预计销售收入年增长率
    ,nvl(trim(P1.SUBGREENCONSUMELOANPURPOSE),'-') -- 绿色消费子类代码
    ,nvl(trim(P1.GREENLOANPURPOSE),'-') -- 绿色贷款用途代码
    ,P1.USCCNO -- 统一社会信用代码
    ,P1.RELYCOMPANYCREDITNO -- 企业统一社会信用代码
    ,P1.COMPCERTID -- 企业证件号码
    ,nvl(trim(P1.COMPCERTTYPE),'0000') -- 企业证件类型代码
    ,P1.RELYCOMPANYNAME -- 企业名称
    ,nvl(trim(P1.ISSCIENTIFICTECHENT),'-') -- 科创企业标志
    ,nvl(trim(P1.ISTECHNOLOGYENT),'-') -- 科技型企业标志
    ,nvl(trim(P1.ISTECHNOLOGYSMALLANDMIDENT),'-') -- 科技型中小企业标志
    ,nvl(trim(P1.ISNATIONALTECHNOLOGINNOVATIONENT),'-') -- 国家技术创新示范企业标志
    ,nvl(trim(P1.ISHIGHTECHNOLOGYENT),'-') -- 高新技术企业标志
    ,nvl(trim(P1.ISOPERATINGENTINVOLVESPECIALIZED),'-') -- 专精特新企业标志
    ,nvl(trim(P1.ISSPECIALIZEDGIANTENT),'-') -- 专精特新小巨人企业标志
    ,nvl(trim(P1.ISSPECIALIZEDSMALLANDMIDENT),'-') -- 专精特新中小企业标志
    ,nvl(trim(P1.ISINDUSTRYSINGLECHAMPIONENT),'-') -- 制造业单项冠军企业标志
    ,nvl(trim(P1.ISAGRICULTURE),'-') -- 涉农标志
    ,nvl(trim(P1.ISGARDEN),'-') -- 园区贷标志
    ,nvl(trim(P1.ISCHECKCREDITREPORT),'-') -- 征信两岗已点击了征信报告按钮标志
    ,nvl(trim(P1.INSURFLAG),'-') -- 有保险标志
    ,P1.APPLYADDR -- 申请地点
    ,P1.SIGNADDR -- 签署地点
    ,P1.REFERRERID -- 推荐的客户经理编号
    ,P1.STARTDATE -- 审批开始时间
    ,nvl(trim(P1.ONLINEAPPROVERESULT),'-') -- 线上审批结果代码
    ,nvl(trim(P1.CHECKRESULT),'-') -- 校验结果代码
    ,P1.WARNINGINFO -- 预警信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ba_personal_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ba_personal_loan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUSCREDITSCORELEVEL = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BA_PERSONAL_LOAN'
        AND R1.SRC_FIELD_EN_NAME= 'CUSCREDITSCORELEVEL'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_INDV_LOAN_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_CRDT_RATING_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,appl_flow_num
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
        into ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
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
    ,nvl(n.cap_dir_cd, o.cap_dir_cd) as cap_dir_cd -- 资金投向代码
    ,nvl(n.buy_insure_flg, o.buy_insure_flg) as buy_insure_flg -- 购买保险标志
    ,nvl(n.insure_breed_id, o.insure_breed_id) as insure_breed_id -- 保险品种编号
    ,nvl(n.insu_benef_lmt, o.insu_benef_lmt) as insu_benef_lmt -- 保险金额
    ,nvl(n.insure_tenor, o.insure_tenor) as insure_tenor -- 保险期限
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.pay_obj_name, o.pay_obj_name) as pay_obj_name -- 支付对象名称
    ,nvl(n.car_type, o.car_type) as car_type -- 车型
    ,nvl(n.seller_corp_cd, o.seller_corp_cd) as seller_corp_cd -- 经销商企业代码
    ,nvl(n.seller_bus_lics_id, o.seller_bus_lics_id) as seller_bus_lics_id -- 经销商营业执照编号
    ,nvl(n.seller_corp_name, o.seller_corp_name) as seller_corp_name -- 经销商企业名称
    ,nvl(n.estat_name, o.estat_name) as estat_name -- 楼盘名称
    ,nvl(n.arti_mgmt_fee_price, o.arti_mgmt_fee_price) as arti_mgmt_fee_price -- 物管费单价
    ,nvl(n.free_claim_rat, o.free_claim_rat) as free_claim_rat -- 免赔率
    ,nvl(n.guar_flg, o.guar_flg) as guar_flg -- 担保标志
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.presell_lics_id, o.presell_lics_id) as presell_lics_id -- 预售许可证编号
    ,nvl(n.seller_bear_repo_duty_flg, o.seller_bear_repo_duty_flg) as seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,nvl(n.buy_car_cont_id, o.buy_car_cont_id) as buy_car_cont_id -- 购车合同编号
    ,nvl(n.buy_carp_dtl_addr, o.buy_carp_dtl_addr) as buy_carp_dtl_addr -- 购车位详细地址
    ,nvl(n.carp_area, o.carp_area) as carp_area -- 车位面积
    ,nvl(n.carp_tot_price, o.carp_tot_price) as carp_tot_price -- 车位总价
    ,nvl(n.indv_opering_loan_cls_cd, o.indv_opering_loan_cls_cd) as indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,nvl(n.open_corp_stl_acct_flg, o.open_corp_stl_acct_flg) as open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,nvl(n.es_envi_prot_cls_cd, o.es_envi_prot_cls_cd) as es_envi_prot_cls_cd -- 节能环保分类代码
    ,nvl(n.entr_loan_risk_cls_cd, o.entr_loan_risk_cls_cd) as entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,nvl(n.entr_loan_dep_acct_id, o.entr_loan_dep_acct_id) as entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,nvl(n.entr_dep_curr_cd, o.entr_dep_curr_cd) as entr_dep_curr_cd -- 委托存款币种代码
    ,nvl(n.entr_dep_amt, o.entr_dep_amt) as entr_dep_amt -- 委托存款金额
    ,nvl(n.entr_cond_descb, o.entr_cond_descb) as entr_cond_descb -- 委托条件描述
    ,nvl(n.car_tot_price, o.car_tot_price) as car_tot_price -- 汽车总价
    ,nvl(n.indv_loan_comm_fee_rat, o.indv_loan_comm_fee_rat) as indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,nvl(n.arch_corp_name, o.arch_corp_name) as arch_corp_name -- 建筑单位名称
    ,nvl(n.expt_lmt_flg, o.expt_lmt_flg) as expt_lmt_flg -- 例外额度标志
    ,nvl(n.onl_apv_flg, o.onl_apv_flg) as onl_apv_flg -- 线上审批标志
    ,nvl(n.white_acct_flg, o.white_acct_flg) as white_acct_flg -- 白户标志
    ,nvl(n.bar_flg, o.bar_flg) as bar_flg -- 随借随还标志
    ,nvl(n.and_hxb_exist_incid_rela_flg, o.and_hxb_exist_incid_rela_flg) as and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,nvl(n.hxb_open_supv_acct_flg, o.hxb_open_supv_acct_flg) as hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,nvl(n.blon_loan_amort_exp_dt, o.blon_loan_amort_exp_dt) as blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,nvl(n.intd_blip_flg, o.intd_blip_flg) as intd_blip_flg -- 引入影像标志
    ,nvl(n.blip_flow_num, o.blip_flow_num) as blip_flow_num -- 影像流水号
    ,nvl(n.blip_cmplt_upload_flg, o.blip_cmplt_upload_flg) as blip_cmplt_upload_flg -- 影像完成上传标志
    ,nvl(n.sugst_loan_amt, o.sugst_loan_amt) as sugst_loan_amt -- 建议贷款金额
    ,nvl(n.redem_house_lon_final_risk_mgmt_rest_cd, o.redem_house_lon_final_risk_mgmt_rest_cd) as redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.appl_lmt, o.appl_lmt) as appl_lmt -- 申请额度
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人帐户编号
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.open_acct_bind_mobile_no, o.open_acct_bind_mobile_no) as open_acct_bind_mobile_no -- 开户绑定手机号码
    ,nvl(n.flow_type_cd, o.flow_type_cd) as flow_type_cd -- 流程类型代码
    ,nvl(n.corp_lmt_ctrl_flg, o.corp_lmt_ctrl_flg) as corp_lmt_ctrl_flg -- 公司额度管控标志
    ,nvl(n.rtn_pric_ratio, o.rtn_pric_ratio) as rtn_pric_ratio -- 归还本金比例
    ,nvl(n.rtn_pric_intrv, o.rtn_pric_intrv) as rtn_pric_intrv -- 归还本金间隔
    ,nvl(n.invstg_opinion_descb, o.invstg_opinion_descb) as invstg_opinion_descb -- 调查意见描述
    ,nvl(n.crdt_level, o.crdt_level) as crdt_level -- 信用等级
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.rest_advise_sucs_flg, o.rest_advise_sucs_flg) as rest_advise_sucs_flg -- 结果通知成功标志
    ,nvl(n.apv_tm, o.apv_tm) as apv_tm -- 审批通过时间
    ,nvl(n.taxpayer_idtfy_num, o.taxpayer_idtfy_num) as taxpayer_idtfy_num -- 纳税人识别号
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.enter_clear_bk_no, o.enter_clear_bk_no) as enter_clear_bk_no -- 入账账户清算行行号
    ,nvl(n.prod_chn_idf_cd, o.prod_chn_idf_cd) as prod_chn_idf_cd -- 产品渠道标识代码
    ,nvl(n.three_mon_up_car_new_car_flg, o.three_mon_up_car_new_car_flg) as three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,nvl(n.vehic_type_cd, o.vehic_type_cd) as vehic_type_cd -- 车辆类型代码
    ,nvl(n.revo_flg, o.revo_flg) as revo_flg -- 撤销标志
    ,nvl(n.obtain_emply_tenor, o.obtain_emply_tenor) as obtain_emply_tenor -- 从业期限
    ,nvl(n.obtain_emply_person, o.obtain_emply_person) as obtain_emply_person -- 从业人员
    ,nvl(n.bl_induty_type_cd, o.bl_induty_type_cd) as bl_induty_type_cd -- 所属行业类型代码
    ,nvl(n.loan_usage_subclass_cd, o.loan_usage_subclass_cd) as loan_usage_subclass_cd -- 贷款用途细类代码
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.corp_auth_tot_amt, o.corp_auth_tot_amt) as corp_auth_tot_amt -- 公司授权总金额
    ,nvl(n.asset_tot, o.asset_tot) as asset_tot -- 资产总额
    ,nvl(n.ocup_o_use_lmt_flg, o.ocup_o_use_lmt_flg) as ocup_o_use_lmt_flg -- 占用他用额度标志
    ,nvl(n.reset_lmt, o.reset_lmt) as reset_lmt -- 重置额度
    ,nvl(n.risk_mgmt_descb, o.risk_mgmt_descb) as risk_mgmt_descb -- 风控背景描述
    ,nvl(n.base_rat_cu_ratio, o.base_rat_cu_ratio) as base_rat_cu_ratio -- 基准利率上浮比例
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.group_cust_id, o.group_cust_id) as group_cust_id -- 集团客户编号
    ,nvl(n.group_cust_name, o.group_cust_name) as group_cust_name -- 集团客户名称
    ,nvl(n.group_cust_aval_open_lmt, o.group_cust_aval_open_lmt) as group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,nvl(n.cont_make_person_type_cd, o.cont_make_person_type_cd) as cont_make_person_type_cd -- 合同制作人员类型代码
    ,nvl(n.borw_cont_id, o.borw_cont_id) as borw_cont_id -- 借款合同编号
    ,nvl(n.incr_lmt_flg, o.incr_lmt_flg) as incr_lmt_flg -- 提额标志
    ,nvl(n.borw_corp_rela_guar_corp_flg, o.borw_corp_rela_guar_corp_flg) as borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,nvl(n.lon_bus_guar_corp_cd, o.lon_bus_guar_corp_cd) as lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,nvl(n.wish_guar_amt, o.wish_guar_amt) as wish_guar_amt -- 意向担保金额
    ,nvl(n.guar_corp_rela_ps_flg, o.guar_corp_rela_ps_flg) as guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,nvl(n.guar_corp_recmd_amt, o.guar_corp_recmd_amt) as guar_corp_recmd_amt -- 担保公司推荐金额
    ,nvl(n.guar_corp_recmd_tenor, o.guar_corp_recmd_tenor) as guar_corp_recmd_tenor -- 担保公司推荐期限
    ,nvl(n.guar_corp_send_tenor, o.guar_corp_send_tenor) as guar_corp_send_tenor -- 担保公司推送期限
    ,nvl(n.bd_card_authen_mobile_no, o.bd_card_authen_mobile_no) as bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,nvl(n.brwer_mobile_no, o.brwer_mobile_no) as brwer_mobile_no -- 借款人手机号码
    ,nvl(n.brwer_and_group_rela_cd, o.brwer_and_group_rela_cd) as brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,nvl(n.brwer_cert_no, o.brwer_cert_no) as brwer_cert_no -- 借款人证件号码
    ,nvl(n.brwer_cert_type_cd, o.brwer_cert_type_cd) as brwer_cert_type_cd -- 借款人证件类型代码
    ,nvl(n.cust_back_flg, o.cust_back_flg) as cust_back_flg -- 客户捞回标志
    ,nvl(n.cust_crdt_rating_cd, o.cust_crdt_rating_cd) as cust_crdt_rating_cd -- 客户信用评级代码
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.ps_opering_loan_bal, o.ps_opering_loan_bal) as ps_opering_loan_bal -- 实控人经营性贷款余额
    ,nvl(n.bus_inco, o.bus_inco) as bus_inco -- 营业收入
    ,nvl(n.flow_brch_type_cd, o.flow_brch_type_cd) as flow_brch_type_cd -- 流程分支类型代码
    ,nvl(n.flow_calcu_year_sell_inco, o.flow_calcu_year_sell_inco) as flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,nvl(n.expect_sell_inco_year_grow_rat, o.expect_sell_inco_year_grow_rat) as expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,nvl(n.green_consm_sub_type_cd, o.green_consm_sub_type_cd) as green_consm_sub_type_cd -- 绿色消费子类代码
    ,nvl(n.green_loan_usage_cd, o.green_loan_usage_cd) as green_loan_usage_cd -- 绿色贷款用途代码
    ,nvl(n.unify_soci_crdt_cd, o.unify_soci_crdt_cd) as unify_soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.corp_unify_soci_crdt_cd, o.corp_unify_soci_crdt_cd) as corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,nvl(n.corp_cert_no, o.corp_cert_no) as corp_cert_no -- 企业证件号码
    ,nvl(n.corp_cert_type_cd, o.corp_cert_type_cd) as corp_cert_type_cd -- 企业证件类型代码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.tech_inovt_corp_flg, o.tech_inovt_corp_flg) as tech_inovt_corp_flg -- 科创企业标志
    ,nvl(n.scen_tech_corp_flg, o.scen_tech_corp_flg) as scen_tech_corp_flg -- 科技型企业标志
    ,nvl(n.scen_tech_med_side_enter_flg, o.scen_tech_med_side_enter_flg) as scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,nvl(n.cty_tech_inovt_corp_flg, o.cty_tech_inovt_corp_flg) as cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,nvl(n.high_new_tech_corp_flg, o.high_new_tech_corp_flg) as high_new_tech_corp_flg -- 高新技术企业标志
    ,nvl(n.corp_new_flg, o.corp_new_flg) as corp_new_flg -- 专精特新企业标志
    ,nvl(n.only_new_minorent_flg, o.only_new_minorent_flg) as only_new_minorent_flg -- 专精特新小巨人企业标志
    ,nvl(n.only_new_littlegiantent_flg, o.only_new_littlegiantent_flg) as only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,nvl(n.industry, o.industry) as industry -- 制造业单项冠军企业标志
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农标志
    ,nvl(n.rg_lon_flg, o.rg_lon_flg) as rg_lon_flg -- 园区贷标志
    ,nvl(n.iscrdtc_click_crdtc_rept_flg, o.iscrdtc_click_crdtc_rept_flg) as iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,nvl(n.lend_on_secu_flg, o.lend_on_secu_flg) as lend_on_secu_flg -- 有保险标志
    ,nvl(n.appl_site, o.appl_site) as appl_site -- 申请地点
    ,nvl(n.sign_site, o.sign_site) as sign_site -- 签署地点
    ,nvl(n.recmd_cust_mgr_id, o.recmd_cust_mgr_id) as recmd_cust_mgr_id -- 推荐的客户经理编号
    ,nvl(n.apv_start_tm, o.apv_start_tm) as apv_start_tm -- 审批开始时间
    ,nvl(n.onl_apv_rest_cd, o.onl_apv_rest_cd) as onl_apv_rest_cd -- 线上审批结果代码
    ,nvl(n.check_rest_cd, o.check_rest_cd) as check_rest_cd -- 校验结果代码
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
where (
        o.appl_id is null
        and o.appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.appl_flow_num is null
    )
    or (
        o.lp_id <> n.lp_id
        or o.buy_cont_id <> n.buy_cont_id
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
        or o.cap_dir_cd <> n.cap_dir_cd
        or o.buy_insure_flg <> n.buy_insure_flg
        or o.insure_breed_id <> n.insure_breed_id
        or o.insu_benef_lmt <> n.insu_benef_lmt
        or o.insure_tenor <> n.insure_tenor
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.pay_obj_name <> n.pay_obj_name
        or o.car_type <> n.car_type
        or o.seller_corp_cd <> n.seller_corp_cd
        or o.seller_bus_lics_id <> n.seller_bus_lics_id
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
        or o.buy_car_cont_id <> n.buy_car_cont_id
        or o.buy_carp_dtl_addr <> n.buy_carp_dtl_addr
        or o.carp_area <> n.carp_area
        or o.carp_tot_price <> n.carp_tot_price
        or o.indv_opering_loan_cls_cd <> n.indv_opering_loan_cls_cd
        or o.open_corp_stl_acct_flg <> n.open_corp_stl_acct_flg
        or o.es_envi_prot_cls_cd <> n.es_envi_prot_cls_cd
        or o.entr_loan_risk_cls_cd <> n.entr_loan_risk_cls_cd
        or o.entr_loan_dep_acct_id <> n.entr_loan_dep_acct_id
        or o.entr_dep_curr_cd <> n.entr_dep_curr_cd
        or o.entr_dep_amt <> n.entr_dep_amt
        or o.entr_cond_descb <> n.entr_cond_descb
        or o.car_tot_price <> n.car_tot_price
        or o.indv_loan_comm_fee_rat <> n.indv_loan_comm_fee_rat
        or o.arch_corp_name <> n.arch_corp_name
        or o.expt_lmt_flg <> n.expt_lmt_flg
        or o.onl_apv_flg <> n.onl_apv_flg
        or o.white_acct_flg <> n.white_acct_flg
        or o.bar_flg <> n.bar_flg
        or o.and_hxb_exist_incid_rela_flg <> n.and_hxb_exist_incid_rela_flg
        or o.hxb_open_supv_acct_flg <> n.hxb_open_supv_acct_flg
        or o.blon_loan_amort_exp_dt <> n.blon_loan_amort_exp_dt
        or o.intd_blip_flg <> n.intd_blip_flg
        or o.blip_flow_num <> n.blip_flow_num
        or o.blip_cmplt_upload_flg <> n.blip_cmplt_upload_flg
        or o.sugst_loan_amt <> n.sugst_loan_amt
        or o.redem_house_lon_final_risk_mgmt_rest_cd <> n.redem_house_lon_final_risk_mgmt_rest_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.rela_flow_num <> n.rela_flow_num
        or o.appl_lmt <> n.appl_lmt
        or o.recv_bank_name <> n.recv_bank_name
        or o.recver_name <> n.recver_name
        or o.recver_acct_id <> n.recver_acct_id
        or o.grace_days <> n.grace_days
        or o.open_acct_bind_mobile_no <> n.open_acct_bind_mobile_no
        or o.flow_type_cd <> n.flow_type_cd
        or o.corp_lmt_ctrl_flg <> n.corp_lmt_ctrl_flg
        or o.rtn_pric_ratio <> n.rtn_pric_ratio
        or o.rtn_pric_intrv <> n.rtn_pric_intrv
        or o.invstg_opinion_descb <> n.invstg_opinion_descb
        or o.crdt_level <> n.crdt_level
        or o.apv_end_tm <> n.apv_end_tm
        or o.chn_id <> n.chn_id
        or o.rest_advise_sucs_flg <> n.rest_advise_sucs_flg
        or o.apv_tm <> n.apv_tm
        or o.taxpayer_idtfy_num <> n.taxpayer_idtfy_num
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.enter_clear_bk_no <> n.enter_clear_bk_no
        or o.prod_chn_idf_cd <> n.prod_chn_idf_cd
        or o.three_mon_up_car_new_car_flg <> n.three_mon_up_car_new_car_flg
        or o.vehic_type_cd <> n.vehic_type_cd
        or o.revo_flg <> n.revo_flg
        or o.obtain_emply_tenor <> n.obtain_emply_tenor
        or o.obtain_emply_person <> n.obtain_emply_person
        or o.bl_induty_type_cd <> n.bl_induty_type_cd
        or o.loan_usage_subclass_cd <> n.loan_usage_subclass_cd
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.corp_auth_tot_amt <> n.corp_auth_tot_amt
        or o.asset_tot <> n.asset_tot
        or o.ocup_o_use_lmt_flg <> n.ocup_o_use_lmt_flg
        or o.reset_lmt <> n.reset_lmt
        or o.risk_mgmt_descb <> n.risk_mgmt_descb
        or o.base_rat_cu_ratio <> n.base_rat_cu_ratio
        or o.group_cust_flg <> n.group_cust_flg
        or o.group_cust_id <> n.group_cust_id
        or o.group_cust_name <> n.group_cust_name
        or o.group_cust_aval_open_lmt <> n.group_cust_aval_open_lmt
        or o.cont_make_person_type_cd <> n.cont_make_person_type_cd
        or o.borw_cont_id <> n.borw_cont_id
        or o.incr_lmt_flg <> n.incr_lmt_flg
        or o.borw_corp_rela_guar_corp_flg <> n.borw_corp_rela_guar_corp_flg
        or o.lon_bus_guar_corp_cd <> n.lon_bus_guar_corp_cd
        or o.wish_guar_amt <> n.wish_guar_amt
        or o.guar_corp_rela_ps_flg <> n.guar_corp_rela_ps_flg
        or o.guar_corp_recmd_amt <> n.guar_corp_recmd_amt
        or o.guar_corp_recmd_tenor <> n.guar_corp_recmd_tenor
        or o.guar_corp_send_tenor <> n.guar_corp_send_tenor
        or o.bd_card_authen_mobile_no <> n.bd_card_authen_mobile_no
        or o.brwer_mobile_no <> n.brwer_mobile_no
        or o.brwer_and_group_rela_cd <> n.brwer_and_group_rela_cd
        or o.brwer_cert_no <> n.brwer_cert_no
        or o.brwer_cert_type_cd <> n.brwer_cert_type_cd
        or o.cust_back_flg <> n.cust_back_flg
        or o.cust_crdt_rating_cd <> n.cust_crdt_rating_cd
        or o.cust_char_cd <> n.cust_char_cd
        or o.ps_opering_loan_bal <> n.ps_opering_loan_bal
        or o.bus_inco <> n.bus_inco
        or o.flow_brch_type_cd <> n.flow_brch_type_cd
        or o.flow_calcu_year_sell_inco <> n.flow_calcu_year_sell_inco
        or o.expect_sell_inco_year_grow_rat <> n.expect_sell_inco_year_grow_rat
        or o.green_consm_sub_type_cd <> n.green_consm_sub_type_cd
        or o.green_loan_usage_cd <> n.green_loan_usage_cd
        or o.unify_soci_crdt_cd <> n.unify_soci_crdt_cd
        or o.corp_unify_soci_crdt_cd <> n.corp_unify_soci_crdt_cd
        or o.corp_cert_no <> n.corp_cert_no
        or o.corp_cert_type_cd <> n.corp_cert_type_cd
        or o.corp_name <> n.corp_name
        or o.tech_inovt_corp_flg <> n.tech_inovt_corp_flg
        or o.scen_tech_corp_flg <> n.scen_tech_corp_flg
        or o.scen_tech_med_side_enter_flg <> n.scen_tech_med_side_enter_flg
        or o.cty_tech_inovt_corp_flg <> n.cty_tech_inovt_corp_flg
        or o.high_new_tech_corp_flg <> n.high_new_tech_corp_flg
        or o.corp_new_flg <> n.corp_new_flg
        or o.only_new_minorent_flg <> n.only_new_minorent_flg
        or o.only_new_littlegiantent_flg <> n.only_new_littlegiantent_flg
        or o.industry <> n.industry
        or o.agclt_flg <> n.agclt_flg
        or o.rg_lon_flg <> n.rg_lon_flg
        or o.iscrdtc_click_crdtc_rept_flg <> n.iscrdtc_click_crdtc_rept_flg
        or o.lend_on_secu_flg <> n.lend_on_secu_flg
        or o.appl_site <> n.appl_site
        or o.sign_site <> n.sign_site
        or o.recmd_cust_mgr_id <> n.recmd_cust_mgr_id
        or o.apv_start_tm <> n.apv_start_tm
        or o.onl_apv_rest_cd <> n.onl_apv_rest_cd
        or o.check_rest_cd <> n.check_rest_cd
        or o.warn_info <> n.warn_info
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,lp_id -- 法人编号
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
    ,cap_dir_cd -- 资金投向代码
    ,buy_insure_flg -- 购买保险标志
    ,insure_breed_id -- 保险品种编号
    ,insu_benef_lmt -- 保险金额
    ,insure_tenor -- 保险期限
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,pay_obj_name -- 支付对象名称
    ,car_type -- 车型
    ,seller_corp_cd -- 经销商企业代码
    ,seller_bus_lics_id -- 经销商营业执照编号
    ,seller_corp_name -- 经销商企业名称
    ,estat_name -- 楼盘名称
    ,arti_mgmt_fee_price -- 物管费单价
    ,free_claim_rat -- 免赔率
    ,guar_flg -- 担保标志
    ,guar_type_cd -- 担保类型代码
    ,presell_lics_id -- 预售许可证编号
    ,seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,buy_car_cont_id -- 购车合同编号
    ,buy_carp_dtl_addr -- 购车位详细地址
    ,carp_area -- 车位面积
    ,carp_tot_price -- 车位总价
    ,indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd -- 节能环保分类代码
    ,entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,entr_dep_amt -- 委托存款金额
    ,entr_cond_descb -- 委托条件描述
    ,car_tot_price -- 汽车总价
    ,indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,arch_corp_name -- 建筑单位名称
    ,expt_lmt_flg -- 例外额度标志
    ,onl_apv_flg -- 线上审批标志
    ,white_acct_flg -- 白户标志
    ,bar_flg -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,intd_blip_flg -- 引入影像标志
    ,blip_flow_num -- 影像流水号
    ,blip_cmplt_upload_flg -- 影像完成上传标志
    ,sugst_loan_amt -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,deflt_repay_day -- 默认还款日
    ,rela_flow_num -- 关联流水号
    ,appl_lmt -- 申请额度
    ,recv_bank_name -- 收款行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人帐户编号
    ,grace_days -- 宽限天数
    ,open_acct_bind_mobile_no -- 开户绑定手机号码
    ,flow_type_cd -- 流程类型代码
    ,corp_lmt_ctrl_flg -- 公司额度管控标志
    ,rtn_pric_ratio -- 归还本金比例
    ,rtn_pric_intrv -- 归还本金间隔
    ,invstg_opinion_descb -- 调查意见描述
    ,crdt_level -- 信用等级
    ,apv_end_tm -- 审批结束时间
    ,chn_id -- 渠道编号
    ,rest_advise_sucs_flg -- 结果通知成功标志
    ,apv_tm -- 审批通过时间
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,loan_usage_cd -- 贷款用途代码
    ,enter_clear_bk_no -- 入账账户清算行行号
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,vehic_type_cd -- 车辆类型代码
    ,revo_flg -- 撤销标志
    ,obtain_emply_tenor -- 从业期限
    ,obtain_emply_person -- 从业人员
    ,bl_induty_type_cd -- 所属行业类型代码
    ,loan_usage_subclass_cd -- 贷款用途细类代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_auth_tot_amt -- 公司授权总金额
    ,asset_tot -- 资产总额
    ,ocup_o_use_lmt_flg -- 占用他用额度标志
    ,reset_lmt -- 重置额度
    ,risk_mgmt_descb -- 风控背景描述
    ,base_rat_cu_ratio -- 基准利率上浮比例
    ,group_cust_flg -- 集团客户标志
    ,group_cust_id -- 集团客户编号
    ,group_cust_name -- 集团客户名称
    ,group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,cont_make_person_type_cd -- 合同制作人员类型代码
    ,borw_cont_id -- 借款合同编号
    ,incr_lmt_flg -- 提额标志
    ,borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,wish_guar_amt -- 意向担保金额
    ,guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,guar_corp_recmd_amt -- 担保公司推荐金额
    ,guar_corp_recmd_tenor -- 担保公司推荐期限
    ,guar_corp_send_tenor -- 担保公司推送期限
    ,bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,brwer_mobile_no -- 借款人手机号码
    ,brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,brwer_cert_no -- 借款人证件号码
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,cust_back_flg -- 客户捞回标志
    ,cust_crdt_rating_cd -- 客户信用评级代码
    ,cust_char_cd -- 客户性质代码
    ,ps_opering_loan_bal -- 实控人经营性贷款余额
    ,bus_inco -- 营业收入
    ,flow_brch_type_cd -- 流程分支类型代码
    ,flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,green_consm_sub_type_cd -- 绿色消费子类代码
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,unify_soci_crdt_cd -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_name -- 企业名称
    ,tech_inovt_corp_flg -- 科创企业标志
    ,scen_tech_corp_flg -- 科技型企业标志
    ,scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,corp_new_flg -- 专精特新企业标志
    ,only_new_minorent_flg -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,industry -- 制造业单项冠军企业标志
    ,agclt_flg -- 涉农标志
    ,rg_lon_flg -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg -- 有保险标志
    ,appl_site -- 申请地点
    ,sign_site -- 签署地点
    ,recmd_cust_mgr_id -- 推荐的客户经理编号
    ,apv_start_tm -- 审批开始时间
    ,onl_apv_rest_cd -- 线上审批结果代码
    ,check_rest_cd -- 校验结果代码
    ,warn_info -- 预警信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.appl_flow_num -- 申请流水号
    ,o.lp_id -- 法人编号
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
    ,o.cap_dir_cd -- 资金投向代码
    ,o.buy_insure_flg -- 购买保险标志
    ,o.insure_breed_id -- 保险品种编号
    ,o.insu_benef_lmt -- 保险金额
    ,o.insure_tenor -- 保险期限
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.pay_obj_name -- 支付对象名称
    ,o.car_type -- 车型
    ,o.seller_corp_cd -- 经销商企业代码
    ,o.seller_bus_lics_id -- 经销商营业执照编号
    ,o.seller_corp_name -- 经销商企业名称
    ,o.estat_name -- 楼盘名称
    ,o.arti_mgmt_fee_price -- 物管费单价
    ,o.free_claim_rat -- 免赔率
    ,o.guar_flg -- 担保标志
    ,o.guar_type_cd -- 担保类型代码
    ,o.presell_lics_id -- 预售许可证编号
    ,o.seller_bear_repo_duty_flg -- 经销商承担回购责任标志
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
    ,o.buy_car_cont_id -- 购车合同编号
    ,o.buy_carp_dtl_addr -- 购车位详细地址
    ,o.carp_area -- 车位面积
    ,o.carp_tot_price -- 车位总价
    ,o.indv_opering_loan_cls_cd -- 个人经营性贷款分类代码
    ,o.open_corp_stl_acct_flg -- 能开立单位结算账户标志
    ,o.es_envi_prot_cls_cd -- 节能环保分类代码
    ,o.entr_loan_risk_cls_cd -- 委托贷款风险分类代码
    ,o.entr_loan_dep_acct_id -- 委托贷款存款账户编号
    ,o.entr_dep_curr_cd -- 委托存款币种代码
    ,o.entr_dep_amt -- 委托存款金额
    ,o.entr_cond_descb -- 委托条件描述
    ,o.car_tot_price -- 汽车总价
    ,o.indv_loan_comm_fee_rat -- 个人贷款手续费率
    ,o.arch_corp_name -- 建筑单位名称
    ,o.expt_lmt_flg -- 例外额度标志
    ,o.onl_apv_flg -- 线上审批标志
    ,o.white_acct_flg -- 白户标志
    ,o.bar_flg -- 随借随还标志
    ,o.and_hxb_exist_incid_rela_flg -- 与我行存在关联关系标志
    ,o.hxb_open_supv_acct_flg -- 在我行开立监管账户标志
    ,o.blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,o.intd_blip_flg -- 引入影像标志
    ,o.blip_flow_num -- 影像流水号
    ,o.blip_cmplt_upload_flg -- 影像完成上传标志
    ,o.sugst_loan_amt -- 建议贷款金额
    ,o.redem_house_lon_final_risk_mgmt_rest_cd -- 赎楼贷最终风控结果代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.rela_flow_num -- 关联流水号
    ,o.appl_lmt -- 申请额度
    ,o.recv_bank_name -- 收款行名称
    ,o.recver_name -- 收款人名称
    ,o.recver_acct_id -- 收款人帐户编号
    ,o.grace_days -- 宽限天数
    ,o.open_acct_bind_mobile_no -- 开户绑定手机号码
    ,o.flow_type_cd -- 流程类型代码
    ,o.corp_lmt_ctrl_flg -- 公司额度管控标志
    ,o.rtn_pric_ratio -- 归还本金比例
    ,o.rtn_pric_intrv -- 归还本金间隔
    ,o.invstg_opinion_descb -- 调查意见描述
    ,o.crdt_level -- 信用等级
    ,o.apv_end_tm -- 审批结束时间
    ,o.chn_id -- 渠道编号
    ,o.rest_advise_sucs_flg -- 结果通知成功标志
    ,o.apv_tm -- 审批通过时间
    ,o.taxpayer_idtfy_num -- 纳税人识别号
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.enter_clear_bk_no -- 入账账户清算行行号
    ,o.prod_chn_idf_cd -- 产品渠道标识代码
    ,o.three_mon_up_car_new_car_flg -- 三个月内上牌新车标志
    ,o.vehic_type_cd -- 车辆类型代码
    ,o.revo_flg -- 撤销标志
    ,o.obtain_emply_tenor -- 从业期限
    ,o.obtain_emply_person -- 从业人员
    ,o.bl_induty_type_cd -- 所属行业类型代码
    ,o.loan_usage_subclass_cd -- 贷款用途细类代码
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.corp_auth_tot_amt -- 公司授权总金额
    ,o.asset_tot -- 资产总额
    ,o.ocup_o_use_lmt_flg -- 占用他用额度标志
    ,o.reset_lmt -- 重置额度
    ,o.risk_mgmt_descb -- 风控背景描述
    ,o.base_rat_cu_ratio -- 基准利率上浮比例
    ,o.group_cust_flg -- 集团客户标志
    ,o.group_cust_id -- 集团客户编号
    ,o.group_cust_name -- 集团客户名称
    ,o.group_cust_aval_open_lmt -- 集团客户可用敞口额度
    ,o.cont_make_person_type_cd -- 合同制作人员类型代码
    ,o.borw_cont_id -- 借款合同编号
    ,o.incr_lmt_flg -- 提额标志
    ,o.borw_corp_rela_guar_corp_flg -- 借款企业为担保公司的关联企业标志
    ,o.lon_bus_guar_corp_cd -- 见保即贷业务担保公司代码
    ,o.wish_guar_amt -- 意向担保金额
    ,o.guar_corp_rela_ps_flg -- 担保公司关联人标志
    ,o.guar_corp_recmd_amt -- 担保公司推荐金额
    ,o.guar_corp_recmd_tenor -- 担保公司推荐期限
    ,o.guar_corp_send_tenor -- 担保公司推送期限
    ,o.bd_card_authen_mobile_no -- 绑卡鉴权手机号
    ,o.brwer_mobile_no -- 借款人手机号码
    ,o.brwer_and_group_rela_cd -- 借款人与集团关系代码
    ,o.brwer_cert_no -- 借款人证件号码
    ,o.brwer_cert_type_cd -- 借款人证件类型代码
    ,o.cust_back_flg -- 客户捞回标志
    ,o.cust_crdt_rating_cd -- 客户信用评级代码
    ,o.cust_char_cd -- 客户性质代码
    ,o.ps_opering_loan_bal -- 实控人经营性贷款余额
    ,o.bus_inco -- 营业收入
    ,o.flow_brch_type_cd -- 流程分支类型代码
    ,o.flow_calcu_year_sell_inco -- 流水推算的年销售收入
    ,o.expect_sell_inco_year_grow_rat -- 预计销售收入年增长率
    ,o.green_consm_sub_type_cd -- 绿色消费子类代码
    ,o.green_loan_usage_cd -- 绿色贷款用途代码
    ,o.unify_soci_crdt_cd -- 统一社会信用代码
    ,o.corp_unify_soci_crdt_cd -- 企业统一社会信用代码
    ,o.corp_cert_no -- 企业证件号码
    ,o.corp_cert_type_cd -- 企业证件类型代码
    ,o.corp_name -- 企业名称
    ,o.tech_inovt_corp_flg -- 科创企业标志
    ,o.scen_tech_corp_flg -- 科技型企业标志
    ,o.scen_tech_med_side_enter_flg -- 科技型中小企业标志
    ,o.cty_tech_inovt_corp_flg -- 国家技术创新示范企业标志
    ,o.high_new_tech_corp_flg -- 高新技术企业标志
    ,o.corp_new_flg -- 专精特新企业标志
    ,o.only_new_minorent_flg -- 专精特新小巨人企业标志
    ,o.only_new_littlegiantent_flg -- 专精特新中小企业标志
    ,o.industry -- 制造业单项冠军企业标志
    ,o.agclt_flg -- 涉农标志
    ,o.rg_lon_flg -- 园区贷标志
    ,o.iscrdtc_click_crdtc_rept_flg -- 征信两岗已点击了征信报告按钮标志
    ,o.lend_on_secu_flg -- 有保险标志
    ,o.appl_site -- 申请地点
    ,o.sign_site -- 签署地点
    ,o.recmd_cust_mgr_id -- 推荐的客户经理编号
    ,o.apv_start_tm -- 审批开始时间
    ,o.onl_apv_rest_cd -- 线上审批结果代码
    ,o.check_rest_cd -- 校验结果代码
    ,o.warn_info -- 预警信息
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
from ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.appl_flow_num = d.appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_indv_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_indv_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
