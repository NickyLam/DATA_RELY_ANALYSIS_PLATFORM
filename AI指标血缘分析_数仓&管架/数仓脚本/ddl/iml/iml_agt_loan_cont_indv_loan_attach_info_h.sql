/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_indv_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,cont_id varchar2(128) -- 合同编号
    ,buy_cont_id varchar2(250) -- 购房合同编号
    ,house_form_cd varchar2(30) -- 房屋形式代码
    ,house_level_cd varchar2(30) -- 房屋等级代码
    ,fir_buy_flg varchar2(10) -- 首次购房标志
    ,house_wat_num varchar2(250) -- 房屋权证号
    ,house_dtl_addr varchar2(2000) -- 房屋详细地址
    ,house_cnt number(10) -- 房屋套数
    ,house_tot_price number(30,2) -- 房屋总价
    ,arch_area number(30,2) -- 建筑面积
    ,set_of_area number(30,2) -- 套内面积
    ,arch_area_price varchar2(500) -- 建筑面积单价
    ,set_of_area_price varchar2(500) -- 套内面积单价
    ,first_pay_amt number(30,2) -- 首付金额
    ,first_pay_ratio number(18,6) -- 首付比例
    ,down_payment_src_descb varchar2(2000) -- 首付款来源描述
    ,loan_ratio number(18,6) -- 贷款比例
    ,estim_price number(30,2) -- 评估价格
    ,idtfy_price number(30,2) -- 认定价格
    ,estim_org_cert_no varchar2(60) -- 评估机构证件号码
    ,estim_org_name varchar2(500) -- 评估机构名称
    ,int_sub_flg varchar2(10) -- 贴息标志
    ,int_sub_ratio number(18,6) -- 贴息比例
    ,csner_cert_no varchar2(60) -- 委托人证件号码
    ,csner_name varchar2(1000) -- 委托人名称
    ,cap_dir_cd varchar2(30) -- 资金投向代码
    ,buy_insure_flg varchar2(10) -- 购买保险标志
    ,insure_breed_id varchar2(100) -- 保险品种编号
    ,insu_benef_lmt number(30,2) -- 保险金额
    ,insure_tenor number(10) -- 保险期限
    ,pay_obj_name varchar2(1000) -- 支付对象名称
    ,seller_corp_cd varchar2(30) -- 经销商企业代码
    ,seller_bus_lics_num varchar2(60) -- 经销商营业执照号码
    ,seller_corp_name varchar2(1000) -- 经销商企业名称
    ,estat_name varchar2(1000) -- 楼盘名称
    ,arti_mgmt_fee_price number(30,2) -- 物管费单价
    ,free_claim_rat number(18,8) -- 免赔率
    ,guar_flg varchar2(10) -- 担保标志
    ,guar_type_cd varchar2(30) -- 担保类型代码
    ,presell_lics_id varchar2(250) -- 预售许可证编号
    ,seller_bear_repo_duty_flg varchar2(10) -- 销售商承担回购责任标志
    ,rela_agt_id varchar2(250) -- 相关协议书编号
    ,insu_comp_name varchar2(1000) -- 保险公司名称
    ,insure_cont_id varchar2(250) -- 保险合同编号
    ,buy_estate_type_cd varchar2(30) -- 所购房产类型代码
    ,buy_estate_area number(30,2) -- 所购房产面积
    ,fitmt_tot_price number(30,2) -- 装修总价
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,comm_fee_mode_pay_cd varchar2(30) -- 手续费支付方式代码
    ,rela_agent_recd_id varchar2(250) -- 关联中介备案编号
    ,seller_ps_name varchar2(1000) -- 卖房人名称
    ,seller_ps_cert_no varchar2(60) -- 卖房人证件号码
    ,rel_esat_cert_id varchar2(250) -- 不动产证号
    ,car_type varchar2(100) -- 车型
    ,buy_car_cont_id varchar2(250) -- 购车合同编号
    ,buy_carp_dtl_addr varchar2(2000) -- 购车位详细地址
    ,carp_area number(30,2) -- 车位面积
    ,car_tot_price number(30,2) -- 汽车总价
    ,carp_tot_price number(30,2) -- 车位总价
    ,indv_opering_loan_cls_cd varchar2(30) -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg varchar2(10) -- 能开立单位结算账户标志
    ,loc_strate_new_indus_cd varchar2(30) -- 本地战略性新兴产业代码
    ,es_envi_prot_cls_cd varchar2(30) -- 节能环保分类代码
    ,entr_loan_risk_cls_cd varchar2(30) -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id varchar2(250) -- 委托贷款存款账户编号
    ,entr_dep_curr_cd varchar2(30) -- 委托存款币种代码
    ,entr_dep_amt number(30,2) -- 委托金额
    ,cap_src_descb varchar2(2000) -- 资金来源描述
    ,entr_cond_descb varchar2(2000) -- 委托条件描述
    ,indv_loan_comm_fee_rat number(18,6) -- 个人贷款手续费率
    ,lp_id varchar2(250) -- 法人编号
    ,estim_cert_type_cd varchar2(30) -- 评估证件类型代码
    ,arch_corp_name varchar2(1000) -- 建筑单位名称
    ,csner_cust_id varchar2(500) -- 委托人客户编号
    ,expt_lmt_flg varchar2(10) -- 例外额度标志
    ,repay_acct_id varchar2(100) -- 还款账户编号
    ,repay_acct_name varchar2(500) -- 还款账户名称
    ,deflt_repay_day varchar2(10) -- 默认还款日代码
    ,bar_flg varchar2(10) -- 随借随还标志
    ,hxb_open_supv_acct_flg varchar2(10) -- 在我行开立监管账户标志
    ,onl_apv_flg varchar2(10) -- 线上审批标志
    ,use_lmt_flg varchar2(10) -- 使用额度标志
    ,hxb_rela_party_flg varchar2(10) -- 我行关联方标志
    ,chn_id varchar2(100) -- 渠道编号
    ,repay_card_type_cd varchar2(30) -- 还款卡类型代码
    ,open_acct_bind_id_no varchar2(60) -- 开户绑定身份证号码
    ,open_acct_bind_mobile_no varchar2(60) -- 开户绑定手机号码
    ,incre_crdt_mode_cd varchar2(60) -- 增信模式代码
    ,acm_callbk_amt number(30,2) -- 累计回收金额
    ,final_enty_c_num varchar2(60) -- 最终实体卡号
    ,final_enty_c_name varchar2(500) -- 最终实体卡名称
    ,final_enty_c_open_bank_num varchar2(60) -- 最终实体卡开户行号
    ,final_enty_c_open_bank_name varchar2(500) -- 最终实体卡开户行名称
    ,final_enter_clear_bk_no varchar2(60) -- 最终入账账户清算行行号
    ,agclt_flg varchar2(10) -- 涉农标志
    ,green_crdt_subclass_cd varchar2(30) -- 绿色贷款用途代码
    ,high_tech_property_type_cd varchar2(30) -- 高技术产业类型代码
    ,digit_econ_core_property_type_cd varchar2(30) -- 数字经济核心产业类型代码
    ,dir_intel_prop_inte_property_type_cd varchar2(30) -- 投向知识产权密集型产业类型代码
    ,strtg_new_indus_type_cd varchar2(30) -- 战略新兴产业类型代码
    ,dir_cul_and_rela_property_type_cd varchar2(30) -- 投向文化及相关产业类型代码
    ,vehic_type_cd varchar2(30) -- 车辆类型代码
    ,green_consm_sub_type_cd varchar2(30) -- 绿色消费子类代码
    ,prod_chn_idf_cd varchar2(30) -- 产品渠道标识代码
    ,brwer_and_group_rela_cd varchar2(30) -- 借款人与集团关系代码
    ,add_co_brwer_flg varchar2(10) -- 新增共同借款人标志
    ,aldy_claim_flg varchar2(10) -- 已认领标志
    ,white_acct_flg varchar2(30) -- 白户标志
    ,bacct_mode_flg varchar2(10) -- 大账户模式标志
    ,cont_supt_renew_flg varchar2(10) -- 合同支持续期标志
    ,enforc_notz_flg varchar2(10) -- 强制执行公证标志
    ,file_int_accr_flg varchar2(10) -- 靠档计息标志
    ,fkd_appl_rela_id varchar2(100) -- 房快贷申请关联编号
    ,group_cust_aval_open_lmt number(30) -- 集团客户可用敞口额度
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,group_cust_id varchar2(100) -- 集团客户编号
    ,group_cust_name varchar2(500) -- 集团客户名称
    ,loan_distr_way_cd varchar2(30) -- 贷款发放方式代码
    ,mode_pay_cd varchar2(100) -- 支付方式代码
    ,enter_id varchar2(100) -- 入账账户编号
    ,enter_name varchar2(500) -- 入账账户名称
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,mobile_no varchar2(60) -- 手机号码
    ,proc_argue_way_cd varchar2(30) -- 解决争议方式代码
    ,proc_argue_way_remark varchar2(500) -- 解决争议方式备注
    ,wl_acct_rela_flow_num varchar2(100) -- 网贷账户关联流水号
    ,zjkj_tech_cont_actv_status_cd varchar2(30) -- 致景科技合同激活状态代码
    ,teller_id varchar2(100) -- 柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h is '贷款合同个人贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_cont_id is '购房合同编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_form_cd is '房屋形式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_level_cd is '房屋等级代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.fir_buy_flg is '首次购房标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_wat_num is '房屋权证号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_dtl_addr is '房屋详细地址';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_cnt is '房屋套数';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.house_tot_price is '房屋总价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.arch_area is '建筑面积';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.set_of_area is '套内面积';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.arch_area_price is '建筑面积单价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.set_of_area_price is '套内面积单价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.first_pay_amt is '首付金额';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.first_pay_ratio is '首付比例';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.down_payment_src_descb is '首付款来源描述';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.loan_ratio is '贷款比例';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.estim_price is '评估价格';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.idtfy_price is '认定价格';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.estim_org_cert_no is '评估机构证件号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.estim_org_name is '评估机构名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.int_sub_flg is '贴息标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.int_sub_ratio is '贴息比例';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.csner_cert_no is '委托人证件号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.csner_name is '委托人名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.cap_dir_cd is '资金投向代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_insure_flg is '购买保险标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.insure_breed_id is '保险品种编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.insu_benef_lmt is '保险金额';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.insure_tenor is '保险期限';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.pay_obj_name is '支付对象名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_corp_cd is '经销商企业代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_bus_lics_num is '经销商营业执照号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_corp_name is '经销商企业名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.estat_name is '楼盘名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.arti_mgmt_fee_price is '物管费单价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.free_claim_rat is '免赔率';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.guar_flg is '担保标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.presell_lics_id is '预售许可证编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_bear_repo_duty_flg is '销售商承担回购责任标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rela_agt_id is '相关协议书编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.insu_comp_name is '保险公司名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.insure_cont_id is '保险合同编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_estate_type_cd is '所购房产类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_estate_area is '所购房产面积';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.fitmt_tot_price is '装修总价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rela_agent_recd_id is '关联中介备案编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_ps_name is '卖房人名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.seller_ps_cert_no is '卖房人证件号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rel_esat_cert_id is '不动产证号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.car_type is '车型';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_car_cont_id is '购车合同编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.buy_carp_dtl_addr is '购车位详细地址';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.carp_area is '车位面积';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.car_tot_price is '汽车总价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.carp_tot_price is '车位总价';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.indv_opering_loan_cls_cd is '个人经营性贷款分类代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.open_corp_stl_acct_flg is '能开立单位结算账户标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.loc_strate_new_indus_cd is '本地战略性新兴产业代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.es_envi_prot_cls_cd is '节能环保分类代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.entr_loan_risk_cls_cd is '委托贷款风险分类代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.entr_loan_dep_acct_id is '委托贷款存款账户编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.entr_dep_curr_cd is '委托存款币种代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.entr_dep_amt is '委托金额';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.cap_src_descb is '资金来源描述';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.entr_cond_descb is '委托条件描述';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.estim_cert_type_cd is '评估证件类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.arch_corp_name is '建筑单位名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.csner_cust_id is '委托人客户编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.expt_lmt_flg is '例外额度标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.repay_acct_id is '还款账户编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.repay_acct_name is '还款账户名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.deflt_repay_day is '默认还款日代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.bar_flg is '随借随还标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.hxb_open_supv_acct_flg is '在我行开立监管账户标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.onl_apv_flg is '线上审批标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.use_lmt_flg is '使用额度标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.hxb_rela_party_flg is '我行关联方标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.repay_card_type_cd is '还款卡类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.open_acct_bind_id_no is '开户绑定身份证号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.incre_crdt_mode_cd is '增信模式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.acm_callbk_amt is '累计回收金额';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.final_enty_c_num is '最终实体卡号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.final_enty_c_name is '最终实体卡名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.final_enty_c_open_bank_num is '最终实体卡开户行号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.final_enty_c_open_bank_name is '最终实体卡开户行名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.final_enter_clear_bk_no is '最终入账账户清算行行号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.agclt_flg is '涉农标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.green_crdt_subclass_cd is '绿色贷款用途代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.high_tech_property_type_cd is '高技术产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.digit_econ_core_property_type_cd is '数字经济核心产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.dir_intel_prop_inte_property_type_cd is '投向知识产权密集型产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.dir_cul_and_rela_property_type_cd is '投向文化及相关产业类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.vehic_type_cd is '车辆类型代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.green_consm_sub_type_cd is '绿色消费子类代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.prod_chn_idf_cd is '产品渠道标识代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.brwer_and_group_rela_cd is '借款人与集团关系代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.add_co_brwer_flg is '新增共同借款人标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.aldy_claim_flg is '已认领标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.white_acct_flg is '白户标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.bacct_mode_flg is '大账户模式标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.cont_supt_renew_flg is '合同支持续期标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.enforc_notz_flg is '强制执行公证标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.file_int_accr_flg is '靠档计息标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.fkd_appl_rela_id is '房快贷申请关联编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.group_cust_aval_open_lmt is '集团客户可用敞口额度';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.group_cust_flg is '集团客户标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.group_cust_id is '集团客户编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.group_cust_name is '集团客户名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.loan_distr_way_cd is '贷款发放方式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.enter_id is '入账账户编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.proc_argue_way_cd is '解决争议方式代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.proc_argue_way_remark is '解决争议方式备注';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.wl_acct_rela_flow_num is '网贷账户关联流水号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.zjkj_tech_cont_actv_status_cd is '致景科技合同激活状态代码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
