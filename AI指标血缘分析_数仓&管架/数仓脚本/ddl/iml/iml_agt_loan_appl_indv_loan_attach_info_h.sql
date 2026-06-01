/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_indv_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h(
    appl_id varchar2(250) -- 申请编号
    ,appl_flow_num varchar2(250) -- 申请流水号
    ,lp_id varchar2(100) -- 法人编号
    ,buy_cont_id varchar2(250) -- 购房合同编号
    ,house_form_cd varchar2(60) -- 房屋形式代码
    ,house_level_cd varchar2(60) -- 房屋等级代码
    ,fir_buy_flg varchar2(10) -- 首次购房标志
    ,house_wat_num varchar2(250) -- 房屋权证号
    ,house_dtl_addr varchar2(2000) -- 房屋详细地址
    ,house_cnt number(10) -- 房屋套数
    ,house_tot_price number(30,2) -- 房屋总价
    ,arch_area number(30,2) -- 建筑面积
    ,set_of_area number(30,2) -- 套内面积
    ,arch_area_price number(30,2) -- 建筑面积单价
    ,set_of_area_price number(30,2) -- 套内面积单价
    ,first_pay_amt number(30,2) -- 首付金额
    ,first_pay_ratio number(18,6) -- 首付比例
    ,down_payment_src_descb varchar2(2000) -- 首付款来源描述
    ,loan_ratio number(18,6) -- 贷款比例
    ,estim_price number(30,2) -- 评估价格
    ,idtfy_price number(30,2) -- 认定价格
    ,estim_org_cert_no varchar2(100) -- 评估机构证件号码
    ,estim_org_name varchar2(500) -- 评估机构名称
    ,int_sub_flg varchar2(10) -- 贴息标志
    ,int_sub_ratio number(18,6) -- 贴息比例
    ,cap_dir_cd varchar2(100) -- 资金投向代码
    ,buy_insure_flg varchar2(10) -- 购买保险标志
    ,insure_breed_id varchar2(500) -- 保险品种编号
    ,insu_benef_lmt number(30,2) -- 保险金额
    ,insure_tenor number(10) -- 保险期限
    ,distr_mode_pay_cd varchar2(60) -- 放款支付方式代码
    ,pay_obj_name varchar2(500) -- 支付对象名称
    ,car_type varchar2(250) -- 车型
    ,seller_corp_cd varchar2(100) -- 经销商企业代码
    ,seller_bus_lics_id varchar2(250) -- 经销商营业执照编号
    ,seller_corp_name varchar2(500) -- 经销商企业名称
    ,estat_name varchar2(500) -- 楼盘名称
    ,arti_mgmt_fee_price number(30,2) -- 物管费单价
    ,free_claim_rat number(18,8) -- 免赔率
    ,guar_flg varchar2(10) -- 担保标志
    ,guar_type_cd varchar2(60) -- 担保类型代码
    ,presell_lics_id varchar2(250) -- 预售许可证编号
    ,seller_bear_repo_duty_flg varchar2(10) -- 经销商承担回购责任标志
    ,rela_agt_id varchar2(250) -- 相关协议书编号
    ,insu_comp_name varchar2(500) -- 保险公司名称
    ,insure_cont_id varchar2(250) -- 保险合同编号
    ,buy_estate_type_cd varchar2(60) -- 所购房产类型代码
    ,buy_estate_area number(30,2) -- 所购房产面积
    ,fitmt_tot_price number(30,8) -- 装修总价
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,comm_fee_mode_pay_cd varchar2(60) -- 手续费支付方式代码
    ,rela_agent_recd_id varchar2(250) -- 关联中介备案编号
    ,seller_ps_name varchar2(500) -- 卖房人名称
    ,seller_ps_cert_no varchar2(60) -- 卖房人证件号码
    ,rel_esat_cert_id varchar2(250) -- 不动产证号
    ,buy_car_cont_id varchar2(250) -- 购车合同编号
    ,buy_carp_dtl_addr varchar2(2000) -- 购车位详细地址
    ,carp_area number(30,2) -- 车位面积
    ,carp_tot_price number(30,8) -- 车位总价
    ,indv_opering_loan_cls_cd varchar2(60) -- 个人经营性贷款分类代码
    ,open_corp_stl_acct_flg varchar2(10) -- 能开立单位结算账户标志
    ,es_envi_prot_cls_cd varchar2(60) -- 节能环保分类代码
    ,entr_loan_risk_cls_cd varchar2(60) -- 委托贷款风险分类代码
    ,entr_loan_dep_acct_id varchar2(250) -- 委托贷款存款账户编号
    ,entr_dep_curr_cd varchar2(30) -- 委托存款币种代码
    ,entr_dep_amt number(30,2) -- 委托存款金额
    ,entr_cond_descb varchar2(2000) -- 委托条件描述
    ,car_tot_price number(30,8) -- 汽车总价
    ,indv_loan_comm_fee_rat number(18,8) -- 个人贷款手续费率
    ,arch_corp_name varchar2(500) -- 建筑单位名称
    ,expt_lmt_flg varchar2(60) -- 例外额度标志
    ,onl_apv_flg varchar2(60) -- 线上审批标志
    ,white_acct_flg varchar2(10) -- 白户标志
    ,bar_flg varchar2(60) -- 随借随还标志
    ,and_hxb_exist_incid_rela_flg varchar2(60) -- 与我行存在关联关系标志
    ,hxb_open_supv_acct_flg varchar2(60) -- 在我行开立监管账户标志
    ,blon_loan_amort_exp_dt date -- 气球贷摊销到期日期
    ,intd_blip_flg varchar2(10) -- 引入影像标志
    ,blip_flow_num varchar2(100) -- 影像流水号
    ,blip_cmplt_upload_flg varchar2(10) -- 影像完成上传标志
    ,sugst_loan_amt number(30,2) -- 建议贷款金额
    ,redem_house_lon_final_risk_mgmt_rest_cd varchar2(30) -- 赎楼贷最终风控结果代码
    ,deflt_repay_day varchar2(10) -- 默认还款日
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,appl_lmt number(30,2) -- 申请额度
    ,recv_bank_name varchar2(500) -- 收款行名称
    ,recver_name varchar2(500) -- 收款人名称
    ,recver_acct_id varchar2(500) -- 收款人帐户编号
    ,grace_days number(10) -- 宽限天数
    ,open_acct_bind_mobile_no varchar2(60) -- 开户绑定手机号码
    ,flow_type_cd varchar2(30) -- 流程类型代码
    ,corp_lmt_ctrl_flg varchar2(30) -- 公司额度管控标志
    ,rtn_pric_ratio number(30,8) -- 归还本金比例
    ,rtn_pric_intrv varchar2(60) -- 归还本金间隔
    ,invstg_opinion_descb varchar2(4000) -- 调查意见描述
    ,crdt_level number(30,8) -- 信用等级
    ,apv_end_tm date -- 审批结束时间
    ,chn_id varchar2(100) -- 渠道编号
    ,rest_advise_sucs_flg varchar2(10) -- 结果通知成功标志
    ,apv_tm timestamp -- 审批通过时间
    ,taxpayer_idtfy_num varchar2(250) -- 纳税人识别号
    ,loan_usage_cd varchar2(30) -- 贷款用途代码
    ,enter_clear_bk_no varchar2(60) -- 入账账户清算行行号
    ,prod_chn_idf_cd varchar2(30) -- 产品渠道标识代码
    ,three_mon_up_car_new_car_flg varchar2(10) -- 三个月内上牌新车标志
    ,vehic_type_cd varchar2(30) -- 车辆类型代码
    ,revo_flg varchar2(10) -- 撤销标志
    ,obtain_emply_tenor number(18,8) -- 从业期限
    ,obtain_emply_person number(30) -- 从业人员
    ,bl_induty_type_cd varchar2(30) -- 所属行业类型代码
    ,loan_usage_subclass_cd varchar2(2000) -- 贷款用途细类代码
    ,loan_usage_descb varchar2(1000) -- 贷款用途描述
    ,corp_auth_tot_amt number(30,2) -- 公司授权总金额
    ,asset_tot number(30,2) -- 资产总额
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,reset_lmt number(30) -- 重置额度
    ,risk_mgmt_descb varchar2(500) -- 风控背景描述
    ,base_rat_cu_ratio number(18,6) -- 基准利率上浮比例
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,group_cust_id varchar2(100) -- 集团客户编号
    ,group_cust_name varchar2(500) -- 集团客户名称
    ,group_cust_aval_open_lmt number(30,8) -- 集团客户可用敞口额度
    ,cont_make_person_type_cd varchar2(30) -- 合同制作人员类型代码
    ,borw_cont_id varchar2(100) -- 借款合同编号
    ,incr_lmt_flg varchar2(10) -- 提额标志
    ,borw_corp_rela_guar_corp_flg varchar2(10) -- 借款企业为担保公司的关联企业标志
    ,lon_bus_guar_corp_cd varchar2(250) -- 见保即贷业务担保公司代码
    ,wish_guar_amt number(30,8) -- 意向担保金额
    ,guar_corp_rela_ps_flg varchar2(10) -- 担保公司关联人标志
    ,guar_corp_recmd_amt number(30,8) -- 担保公司推荐金额
    ,guar_corp_recmd_tenor number(30) -- 担保公司推荐期限
    ,guar_corp_send_tenor number(30) -- 担保公司推送期限
    ,bd_card_authen_mobile_no varchar2(100) -- 绑卡鉴权手机号
    ,brwer_mobile_no varchar2(60) -- 借款人手机号码
    ,brwer_and_group_rela_cd varchar2(30) -- 借款人与集团关系代码
    ,brwer_cert_no varchar2(60) -- 借款人证件号码
    ,brwer_cert_type_cd varchar2(30) -- 借款人证件类型代码
    ,cust_back_flg varchar2(10) -- 客户捞回标志
    ,cust_crdt_rating_cd varchar2(30) -- 客户信用评级代码
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,ps_opering_loan_bal number(30,8) -- 实控人经营性贷款余额
    ,bus_inco number(30,8) -- 营业收入
    ,flow_brch_type_cd varchar2(30) -- 流程分支类型代码
    ,flow_calcu_year_sell_inco number(30,8) -- 流水推算的年销售收入
    ,expect_sell_inco_year_grow_rat number(30,8) -- 预计销售收入年增长率
    ,green_consm_sub_type_cd varchar2(30) -- 绿色消费子类代码
    ,green_loan_usage_cd varchar2(30) -- 绿色贷款用途代码
    ,unify_soci_crdt_cd varchar2(100) -- 统一社会信用代码
    ,corp_unify_soci_crdt_cd varchar2(100) -- 企业统一社会信用代码
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,corp_cert_type_cd varchar2(30) -- 企业证件类型代码
    ,corp_name varchar2(500) -- 企业名称
    ,tech_inovt_corp_flg varchar2(10) -- 科创企业标志
    ,scen_tech_corp_flg varchar2(10) -- 科技型企业标志
    ,scen_tech_med_side_enter_flg varchar2(10) -- 科技型中小企业标志
    ,cty_tech_inovt_corp_flg varchar2(10) -- 国家技术创新示范企业标志
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
    ,corp_new_flg varchar2(10) -- 专精特新企业标志
    ,only_new_minorent_flg varchar2(10) -- 专精特新小巨人企业标志
    ,only_new_littlegiantent_flg varchar2(10) -- 专精特新中小企业标志
    ,industry varchar2(10) -- 制造业单项冠军企业标志
    ,agclt_flg varchar2(10) -- 涉农标志
    ,rg_lon_flg varchar2(10) -- 园区贷标志
    ,iscrdtc_click_crdtc_rept_flg varchar2(10) -- 征信两岗已点击了征信报告按钮标志
    ,lend_on_secu_flg varchar2(10) -- 有保险标志
    ,appl_site varchar2(500) -- 申请地点
    ,sign_site varchar2(500) -- 签署地点
    ,recmd_cust_mgr_id varchar2(100) -- 推荐的客户经理编号
    ,apv_start_tm timestamp -- 审批开始时间
    ,onl_apv_rest_cd varchar2(30) -- 线上审批结果代码
    ,check_rest_cd varchar2(30) -- 校验结果代码
    ,warn_info varchar2(4000) -- 预警信息
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
grant select on ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h is '贷款申请个人贷款附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_cont_id is '购房合同编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_form_cd is '房屋形式代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_level_cd is '房屋等级代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.fir_buy_flg is '首次购房标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_wat_num is '房屋权证号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_dtl_addr is '房屋详细地址';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_cnt is '房屋套数';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.house_tot_price is '房屋总价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.arch_area is '建筑面积';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.set_of_area is '套内面积';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.arch_area_price is '建筑面积单价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.set_of_area_price is '套内面积单价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.first_pay_amt is '首付金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.first_pay_ratio is '首付比例';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.down_payment_src_descb is '首付款来源描述';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.loan_ratio is '贷款比例';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.estim_price is '评估价格';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.idtfy_price is '认定价格';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.estim_org_cert_no is '评估机构证件号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.estim_org_name is '评估机构名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.int_sub_flg is '贴息标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.int_sub_ratio is '贴息比例';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cap_dir_cd is '资金投向代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_insure_flg is '购买保险标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.insure_breed_id is '保险品种编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.insu_benef_lmt is '保险金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.insure_tenor is '保险期限';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.pay_obj_name is '支付对象名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.car_type is '车型';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_corp_cd is '经销商企业代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_bus_lics_id is '经销商营业执照编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_corp_name is '经销商企业名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.estat_name is '楼盘名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.arti_mgmt_fee_price is '物管费单价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.free_claim_rat is '免赔率';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_flg is '担保标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.presell_lics_id is '预售许可证编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_bear_repo_duty_flg is '经销商承担回购责任标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rela_agt_id is '相关协议书编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.insu_comp_name is '保险公司名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.insure_cont_id is '保险合同编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_estate_type_cd is '所购房产类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_estate_area is '所购房产面积';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.fitmt_tot_price is '装修总价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.comm_fee_mode_pay_cd is '手续费支付方式代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rela_agent_recd_id is '关联中介备案编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_ps_name is '卖房人名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.seller_ps_cert_no is '卖房人证件号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rel_esat_cert_id is '不动产证号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_car_cont_id is '购车合同编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.buy_carp_dtl_addr is '购车位详细地址';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.carp_area is '车位面积';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.carp_tot_price is '车位总价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.indv_opering_loan_cls_cd is '个人经营性贷款分类代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.open_corp_stl_acct_flg is '能开立单位结算账户标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.es_envi_prot_cls_cd is '节能环保分类代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.entr_loan_risk_cls_cd is '委托贷款风险分类代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.entr_loan_dep_acct_id is '委托贷款存款账户编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.entr_dep_curr_cd is '委托存款币种代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.entr_dep_amt is '委托存款金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.entr_cond_descb is '委托条件描述';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.car_tot_price is '汽车总价';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.indv_loan_comm_fee_rat is '个人贷款手续费率';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.arch_corp_name is '建筑单位名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.expt_lmt_flg is '例外额度标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.onl_apv_flg is '线上审批标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.white_acct_flg is '白户标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.bar_flg is '随借随还标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.and_hxb_exist_incid_rela_flg is '与我行存在关联关系标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.hxb_open_supv_acct_flg is '在我行开立监管账户标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.blon_loan_amort_exp_dt is '气球贷摊销到期日期';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.intd_blip_flg is '引入影像标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.blip_flow_num is '影像流水号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.blip_cmplt_upload_flg is '影像完成上传标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.sugst_loan_amt is '建议贷款金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.redem_house_lon_final_risk_mgmt_rest_cd is '赎楼贷最终风控结果代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.appl_lmt is '申请额度';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.recver_acct_id is '收款人帐户编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.grace_days is '宽限天数';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.open_acct_bind_mobile_no is '开户绑定手机号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.flow_type_cd is '流程类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_lmt_ctrl_flg is '公司额度管控标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rtn_pric_ratio is '归还本金比例';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rtn_pric_intrv is '归还本金间隔';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.invstg_opinion_descb is '调查意见描述';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.crdt_level is '信用等级';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.apv_end_tm is '审批结束时间';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rest_advise_sucs_flg is '结果通知成功标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.apv_tm is '审批通过时间';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.enter_clear_bk_no is '入账账户清算行行号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.prod_chn_idf_cd is '产品渠道标识代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.three_mon_up_car_new_car_flg is '三个月内上牌新车标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.vehic_type_cd is '车辆类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.revo_flg is '撤销标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.obtain_emply_tenor is '从业期限';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.obtain_emply_person is '从业人员';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.bl_induty_type_cd is '所属行业类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.loan_usage_subclass_cd is '贷款用途细类代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_auth_tot_amt is '公司授权总金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.asset_tot is '资产总额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.reset_lmt is '重置额度';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.risk_mgmt_descb is '风控背景描述';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.base_rat_cu_ratio is '基准利率上浮比例';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.group_cust_flg is '集团客户标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.group_cust_id is '集团客户编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.group_cust_name is '集团客户名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.group_cust_aval_open_lmt is '集团客户可用敞口额度';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cont_make_person_type_cd is '合同制作人员类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.borw_cont_id is '借款合同编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.incr_lmt_flg is '提额标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.borw_corp_rela_guar_corp_flg is '借款企业为担保公司的关联企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.lon_bus_guar_corp_cd is '见保即贷业务担保公司代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.wish_guar_amt is '意向担保金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_corp_rela_ps_flg is '担保公司关联人标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_corp_recmd_amt is '担保公司推荐金额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_corp_recmd_tenor is '担保公司推荐期限';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.guar_corp_send_tenor is '担保公司推送期限';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.bd_card_authen_mobile_no is '绑卡鉴权手机号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.brwer_mobile_no is '借款人手机号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.brwer_and_group_rela_cd is '借款人与集团关系代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.brwer_cert_no is '借款人证件号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.brwer_cert_type_cd is '借款人证件类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cust_back_flg is '客户捞回标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cust_crdt_rating_cd is '客户信用评级代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.ps_opering_loan_bal is '实控人经营性贷款余额';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.bus_inco is '营业收入';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.flow_brch_type_cd is '流程分支类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.flow_calcu_year_sell_inco is '流水推算的年销售收入';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.expect_sell_inco_year_grow_rat is '预计销售收入年增长率';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.green_consm_sub_type_cd is '绿色消费子类代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.green_loan_usage_cd is '绿色贷款用途代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_unify_soci_crdt_cd is '企业统一社会信用代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_name is '企业名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.tech_inovt_corp_flg is '科创企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.scen_tech_corp_flg is '科技型企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.scen_tech_med_side_enter_flg is '科技型中小企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.cty_tech_inovt_corp_flg is '国家技术创新示范企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.corp_new_flg is '专精特新企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.only_new_minorent_flg is '专精特新小巨人企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.only_new_littlegiantent_flg is '专精特新中小企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.industry is '制造业单项冠军企业标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.agclt_flg is '涉农标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.rg_lon_flg is '园区贷标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.iscrdtc_click_crdtc_rept_flg is '征信两岗已点击了征信报告按钮标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.lend_on_secu_flg is '有保险标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.appl_site is '申请地点';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.sign_site is '签署地点';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.recmd_cust_mgr_id is '推荐的客户经理编号';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.apv_start_tm is '审批开始时间';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.onl_apv_rest_cd is '线上审批结果代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.check_rest_cd is '校验结果代码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.warn_info is '预警信息';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
