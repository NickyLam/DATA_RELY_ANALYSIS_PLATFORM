/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_apv_indv_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,apv_flow_num varchar2(100) -- 审批流水号
    ,buy_cont_id varchar2(100) -- 购房合同编号
    ,house_form_cd varchar2(30) -- 房屋形式代码
    ,house_level_cd varchar2(30) -- 房屋等级代码
    ,fir_buy_flg varchar2(10) -- 首次购房标志
    ,house_wat_num varchar2(250) -- 房屋权证号
    ,house_dtl_addr varchar2(1000) -- 房屋详细地址
    ,house_cnt number(10) -- 房屋套数
    ,house_tot_price number(30,2) -- 房屋总价
    ,arch_area number(30,2) -- 建筑面积
    ,set_of_area number(30,2) -- 套内面积
    ,arch_area_price number(30,2) -- 建筑面积单价
    ,set_of_area_price number(30,2) -- 套内面积单价
    ,first_pay_amt number(30,2) -- 首付金额
    ,first_pay_ratio number(18,6) -- 首付比例
    ,down_payment_src_descb varchar2(1000) -- 首付款来源描述
    ,loan_ratio number(18,6) -- 贷款比例
    ,estim_price number(30,2) -- 评估价格
    ,idtfy_price number(30,2) -- 认定价格
    ,estim_org_cert_no varchar2(60) -- 评估机构证件号码
    ,estim_org_name varchar2(500) -- 评估机构名称
    ,int_sub_flg varchar2(10) -- 贴息标志
    ,int_sub_ratio number(18,6) -- 贴息比例
    ,usage_descb varchar2(1000) -- 用途描述
    ,cap_dir_cd varchar2(30) -- 资金投向代码
    ,buy_insure_flg varchar2(10) -- 购买保险标志
    ,insure_breed_id varchar2(250) -- 保险品种编号
    ,insu_benef_lmt number(30,2) -- 保险金额
    ,insure_tenor number(10) -- 保险期限
    ,distr_mode_pay_cd varchar2(30) -- 放款支付方式代码
    ,pay_obj_name varchar2(500) -- 支付对象名称
    ,car_type varchar2(100) -- 车型
    ,seller_corp_cd varchar2(30) -- 经销商企业代码
    ,seller_bus_lics_id varchar2(100) -- 经销商营业执照编号
    ,seller_corp_name varchar2(500) -- 经销商企业名称
    ,estat_name varchar2(500) -- 楼盘名称
    ,arti_mgmt_fee_price number(30,2) -- 物管费单价
    ,car_tot_price number(30,2) -- 汽车总价
    ,free_claim_rat number(18,8) -- 免赔率
    ,guar_flg varchar2(10) -- 担保标志
    ,guar_type_cd varchar2(30) -- 担保类型代码
    ,presell_lics_id varchar2(100) -- 预售许可证编号
    ,seller_bear_repo_duty_flg varchar2(10) -- 经销商承担回购责任标志
    ,rela_agt_id varchar2(100) -- 相关协议书编号
    ,insu_comp_name varchar2(500) -- 保险公司名称
    ,insure_cont_id varchar2(100) -- 保险合同编号
    ,buy_estate_type_cd varchar2(30) -- 所购房产类型代码
    ,buy_estate_area number(30,2) -- 所购房产面积
    ,fitmt_tot_price number(30,2) -- 装修总价
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,comm_fee_mode_pay_cd varchar2(30) -- 手续费支付方式代码
    ,rela_agent_recd_id varchar2(100) -- 关联中介备案编号
    ,seller_ps_name varchar2(500) -- 卖房人名称
    ,seller_ps_cert_no varchar2(60) -- 卖房人证件号码
    ,rel_esat_cert_id varchar2(100) -- 不动产证号
    ,buy_car_cont_id varchar2(100) -- 购车合同编号
    ,buy_carp_dtl_addr varchar2(1000) -- 购车位详细地址
    ,carp_area number(30,2) -- 车位面积
    ,carp_tot_price number(30,2) -- 车位总价
    ,indv_opering_loan_cls_cd varchar2(30) -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg varchar2(10) -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd varchar2(30) -- 节能环保分类代码
    ,entr_loan_risk_cls_cd varchar2(30) -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id varchar2(100) -- 委托贷款存款账户编号
    ,entr_dep_curr_cd varchar2(30) -- 委托存款币种代码
    ,entr_dep_amt number(30,2) -- 委托存款金额
    ,entr_cond_descb varchar2(1000) -- 委托条件描述
    ,indv_loan_comm_fee_rat number(18,6) -- 个人贷款手续费率
    ,lp_id varchar2(100) -- 法人编号
    ,arch_corp_name varchar2(500) -- 建筑单位名称
    ,and_hxb_exist_incid_rela_flg varchar2(10) -- 与我行存在关联关系标志
    ,appl_lmt number(30) -- 申请额度
    ,appl_rest_advise_sucs_flg varchar2(10) -- 申请结果通知成功标志
    ,appl_site varchar2(500) -- 申请地点
    ,sign_site varchar2(500) -- 签署地点
    ,borw_cont_id varchar2(100) -- 借款合同编号
    ,brwer_and_group_rela_cd varchar2(30) -- 借款人与集团关系代码
    ,brwer_cert_no varchar2(60) -- 借款人证件号码
    ,brwer_cert_type_cd varchar2(30) -- 借款人证件类型代码
    ,brwer_mobile_no varchar2(60) -- 借款人手机号码
    ,bd_card_authen_mobile_no varchar2(100) -- 绑卡鉴权手机号
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,corp_cert_type_cd varchar2(30) -- 企业证件类型代码
    ,corp_name varchar2(500) -- 企业名称
    ,corp_unify_soci_crdt_cd varchar2(100) -- 企业统一社会信用代码
    ,tax_num varchar2(100) -- 纳税人识别号
    ,unify_soci_crdt_cd varchar2(100) -- 统一社会信用代码
    ,group_cust_aval_open_lmt number(30,8) -- 集团客户可用敞口额度
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,group_cust_id varchar2(100) -- 集团客户编号
    ,group_cust_name varchar2(500) -- 集团客户名称
    ,check_rest_cd varchar2(30) -- 校验结果代码
    ,conptr_crdt_score number(18,6) -- 机评信用分
    ,cust_back_flg varchar2(10) -- 客户捞回标志
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,fix_repay_day date -- 固定还款日
    ,green_consm_sub_type_cd varchar2(30) -- 绿色消费子类代码
    ,green_loan_usage_cd varchar2(30) -- 绿色贷款用途代码
    ,guar_type_comb varchar2(500) -- 担保类型组合
    ,hxb_open_supv_acct_flg varchar2(10) -- 在我行开立监管账户标志
    ,intd_blip_flg varchar2(10) -- 引入影像标志
    ,invstger_opinion varchar2(4000) -- 调查人意见
    ,iscrdtc_click_crdtc_rept_flg varchar2(10) -- 征信两岗已点击了征信报告按钮标志
    ,loan_appl_rela_flow_num varchar2(100) -- 贷款申请关联流水号
    ,loan_chn_src_cd varchar2(30) -- 贷款渠道来源代码
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,onl_apv_flg varchar2(10) -- 线上审批标志
    ,onl_apv_rest_cd varchar2(30) -- 线上审批结果代码
    ,apv_start_dt date -- 审批开始日期
    ,apv_end_dt date -- 审批结束日期
    ,apved_dt date -- 审批通过日期
    ,prod_chn_idf_cd varchar2(30) -- 产品渠道标识代码
    ,sugst_loan_lmt number(30) -- 建议贷款额度
    ,incr_lmt_flg varchar2(10) -- 提额标志
    ,reset_lmt number(30) -- 重置额度
    ,expt_lmt_flg varchar2(10) -- 例外额度标志
    ,base_rat_cu_ratio number(18,6) -- 基准利率上浮比例
    ,recvbl_acct_bank_num varchar2(250) -- 收款账户行号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,bar_flg varchar2(10) -- 随借随还标志
    ,revo_flg varchar2(10) -- 撤销标志
    ,risk_mgmt_descb varchar2(500) -- 风控背景描述
    ,vehic_type_cd varchar2(30) -- 车辆类型代码
    ,white_list_cust_flg varchar2(10) -- 白户标志
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
grant select on ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h is '贷款审批个人贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.apv_flow_num is '审批流水号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_cont_id is '购房合同编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_form_cd is '房屋形式代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_level_cd is '房屋等级代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.fir_buy_flg is '首次购房标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_wat_num is '房屋权证号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_dtl_addr is '房屋详细地址';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_cnt is '房屋套数';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.house_tot_price is '房屋总价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.arch_area is '建筑面积';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.set_of_area is '套内面积';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.arch_area_price is '建筑面积单价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.set_of_area_price is '套内面积单价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.first_pay_amt is '首付金额';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.first_pay_ratio is '首付比例';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.down_payment_src_descb is '首付款来源描述';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.loan_ratio is '贷款比例';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.estim_price is '评估价格';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.idtfy_price is '认定价格';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.estim_org_cert_no is '评估机构证件号码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.estim_org_name is '评估机构名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.int_sub_flg is '贴息标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.int_sub_ratio is '贴息比例';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.usage_descb is '用途描述';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.cap_dir_cd is '资金投向代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_insure_flg is '购买保险标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.insure_breed_id is '保险品种编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.insu_benef_lmt is '保险金额';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.insure_tenor is '保险期限';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.pay_obj_name is '支付对象名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.car_type is '车型';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_corp_cd is '经销商企业代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_bus_lics_id is '经销商营业执照编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_corp_name is '经销商企业名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.estat_name is '楼盘名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.arti_mgmt_fee_price is '物管费单价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.car_tot_price is '汽车总价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.free_claim_rat is '免赔率';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.guar_flg is '担保标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.presell_lics_id is '预售许可证编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_bear_repo_duty_flg is '经销商承担回购责任标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.rela_agt_id is '相关协议书编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.insu_comp_name is '保险公司名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.insure_cont_id is '保险合同编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_estate_type_cd is '所购房产类型代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_estate_area is '所购房产面积';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.fitmt_tot_price is '装修总价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.rela_agent_recd_id is '关联中介备案编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_ps_name is '卖房人名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.seller_ps_cert_no is '卖房人证件号码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.rel_esat_cert_id is '不动产证号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_car_cont_id is '购车合同编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.buy_carp_dtl_addr is '购车位详细地址';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.carp_area is '车位面积';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.carp_tot_price is '车位总价';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.indv_opering_loan_cls_cd is '个人经营性贷款分类代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.open_corp_stl_acct_flg is '能开立单位结算账户标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.es_envi_prot_cls_cd is '节能环保分类代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.entr_loan_risk_cls_cd is '委托贷款风险分类代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.entr_loan_dep_acct_id is '委托贷款存款账户编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.entr_dep_curr_cd is '委托存款币种代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.entr_dep_amt is '委托存款金额';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.entr_cond_descb is '委托条件描述';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.arch_corp_name is '建筑单位名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.and_hxb_exist_incid_rela_flg is '与我行存在关联关系标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.appl_lmt is '申请额度';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.appl_rest_advise_sucs_flg is '申请结果通知成功标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.appl_site is '申请地点';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.sign_site is '签署地点';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.borw_cont_id is '借款合同编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.brwer_and_group_rela_cd is '借款人与集团关系代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.brwer_cert_no is '借款人证件号码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.brwer_cert_type_cd is '借款人证件类型代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.brwer_mobile_no is '借款人手机号码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.bd_card_authen_mobile_no is '绑卡鉴权手机号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.corp_name is '企业名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.corp_unify_soci_crdt_cd is '企业统一社会信用代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.tax_num is '纳税人识别号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.group_cust_aval_open_lmt is '集团客户可用敞口额度';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.group_cust_flg is '集团客户标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.group_cust_id is '集团客户编号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.group_cust_name is '集团客户名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.check_rest_cd is '校验结果代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.conptr_crdt_score is '机评信用分';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.cust_back_flg is '客户捞回标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.fix_repay_day is '固定还款日';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.green_consm_sub_type_cd is '绿色消费子类代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.green_loan_usage_cd is '绿色贷款用途代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.guar_type_comb is '担保类型组合';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.hxb_open_supv_acct_flg is '在我行开立监管账户标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.intd_blip_flg is '引入影像标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.invstger_opinion is '调查人意见';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.iscrdtc_click_crdtc_rept_flg is '征信两岗已点击了征信报告按钮标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.loan_appl_rela_flow_num is '贷款申请关联流水号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.loan_chn_src_cd is '贷款渠道来源代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.onl_apv_flg is '线上审批标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.onl_apv_rest_cd is '线上审批结果代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.apv_start_dt is '审批开始日期';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.apv_end_dt is '审批结束日期';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.apved_dt is '审批通过日期';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.prod_chn_idf_cd is '产品渠道标识代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.sugst_loan_lmt is '建议贷款额度';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.incr_lmt_flg is '提额标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.reset_lmt is '重置额度';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.expt_lmt_flg is '例外额度标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.base_rat_cu_ratio is '基准利率上浮比例';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.recvbl_acct_bank_num is '收款账户行号';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.bar_flg is '随借随还标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.revo_flg is '撤销标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.risk_mgmt_descb is '风控背景描述';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.vehic_type_cd is '车辆类型代码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
