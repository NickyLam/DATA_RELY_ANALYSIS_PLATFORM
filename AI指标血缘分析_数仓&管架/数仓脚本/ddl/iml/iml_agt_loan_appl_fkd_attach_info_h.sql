/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_appl_fkd_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_appl_fkd_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_fkd_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,belong_brch_id varchar2(250) -- 所属分行编号
    ,access_chn_id varchar2(100) -- 接入渠道编号
    ,chn_id varchar2(100) -- 渠道编号
    ,crdt_appl_flow_num varchar2(100) -- 信贷申请流水号
    ,apv_opinion varchar2(3000) -- 审批意见
    ,apv_concus varchar2(500) -- 审批结论
    ,main_debit_ps_cert_type_cd varchar2(30) -- 主借人证件类型代码
    ,main_debit_ps_cert_id varchar2(100) -- 主借人证件编号
    ,gender_cd varchar2(30) -- 性别代码
    ,issue_org varchar2(500) -- 证件签发机关名称
    ,issue_cty_cd varchar2(30) -- 签发国家
    ,issue_dt date -- 签发日期
    ,exp_dt date -- 到期日期
    ,ghb_emply_flg varchar2(10) -- 本行员工标志
    ,other_housing_flg varchar2(10) -- 其他住房标志
    ,estate_qtty number(30) -- 房产数量
    ,repay_src_cd varchar2(30) -- 还款来源代码
    ,spouse_co_ownr_flg varchar2(10) -- 配偶共有人标志
    ,spouse_rela_ps_flg varchar2(10) -- 配偶关联人标志
    ,mang_type_cd varchar2(30) -- 经营类型代码
    ,mercht_name varchar2(500) -- 商户名称
    ,mang_site_type_cd varchar2(30) -- 经营场所类型代码
    ,mang_site varchar2(500) -- 经营场所
    ,oper_name varchar2(500) -- 经营者名称
    ,actl_ctrler_name varchar2(500) -- 实际控制人名称
    ,mang_range varchar2(500) -- 经营范围
    ,corp_name varchar2(500) -- 企业名称
    ,unify_soci_crdt_id varchar2(100) -- 统一社会信用编号
    ,orgnz_cd varchar2(30) -- 组织机构代码
    ,corp_lp_name varchar2(500) -- 企业法人姓名
    ,brwer_idti_cd varchar2(30) -- 借款人身份代码
    ,rgst_addr varchar2(500) -- 注册地址
    ,rgst_cap number(30,2) -- 注册资本
    ,rgst_dt date -- 注册日期
    ,corp_type_cd varchar2(30) -- 企业类型代码
    ,bus_begin_dt date -- 营业起始日期
    ,bus_exp_dt date -- 营业到期日期
    ,lp_obtain_emply_years number(10) -- 法人从业年限
    ,lics_name varchar2(500) -- 许可证名称
    ,lics_id varchar2(100) -- 许可证编号
    ,mang_years number(10) -- 经营年限
    ,cust_mgr_opinion_amt number(30,2) -- 客户经理意见金额
    ,cust_mgr_opinion_tenor number(10) -- 客户经理意见期限
    ,recmd_type_cd varchar2(30) -- 推荐类型代码
    ,recmd_agent_name varchar2(500) -- 推荐中介名称
    ,crdt_amt number(30,2) -- 授信金额
    ,final_jud_appl_tm varchar2(100) -- 终审申请时间
    ,final_jud_appl_dt date -- 终审申请日期
    ,score_val varchar2(10) -- 评分分值
    ,crdtc_que_situ_cd varchar2(30) -- 征信查询情况代码
    ,final_jud_advise_sucs_flg varchar2(10) -- 终审通知成功标志
    ,distr_advise_sucs_flg varchar2(10) -- 放款通知成功标志
    ,refuse_rs_descb varchar2(4000) -- 拒绝原因描述
    ,final_jud_apv_lmt number(30,2) -- 终审审批额度
    ,cust_id varchar2(100) -- 客户编号
    ,dtl_addr varchar2(500) -- 详细地址
    ,work_char_cd varchar2(30) -- 工作性质代码
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,mobile_no varchar2(60) -- 手机号码
    ,apv_end_tm timestamp -- 审批结束时间
    ,blip_doc_flg varchar2(10) -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id varchar2(100) -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg varchar2(10) -- 借款人为实控人标志
    ,cust_appl_amt number(30,2) -- 客户申请金额
    ,hxb_rela_ps_flg varchar2(10) -- 我行关联人标志
    ,main_brwer_amt_over_flg varchar2(10) -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg varchar2(10) -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id varchar2(100) -- 借款合同编号
    ,col_id varchar2(100) -- 押品编号
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num varchar2(100) -- 额度合同信贷申请流水号
    ,cont_type_cd varchar2(30) -- 合同类型代码
    ,onl_flg varchar2(10) -- 线上标志
    ,onl_conti_loan_mode_flg varchar2(10) -- 线上续贷模式标志
    ,conti_loan_begin_dt date -- 续贷起始日期
    ,conti_loan_exp_dt date -- 续贷到期日期
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,have_init_loan_flg varchar2(10) -- 有原贷款标志
    ,obank_estate_mtg_flg varchar2(10) -- 他行在押房产标志
    ,init_dubil_id varchar2(100) -- 原借据编号
    ,init_cont_id varchar2(100) -- 原合同编号
    ,init_dubil_amt number(30,2) -- 原借据金额
    ,init_dubil_bal number(30,2) -- 原借据余额
    ,init_mtg_bank_name varchar2(500) -- 原抵押银行名称
    ,init_mtg_bank_brch_name varchar2(500) -- 原抵押银行分行名称
    ,init_loan_circl_flg varchar2(10) -- 原贷款循环标志
    ,init_house_loan_amt number(30,8) -- 原房屋贷款金额
    ,init_house_loan_bal number(30,8) -- 原房屋贷款余额
    ,init_loan_surp_tenor number(30,2) -- 原贷款剩余期限
    ,init_estate_loan_type_cd varchar2(30) -- 原房产贷款类型代码
    ,init_house_lon_other_remark varchar2(500) -- 原房贷其他备注
    ,loan_begin_dt date -- 贷款起始日期
    ,loan_exp_dt date -- 贷款到期日期
    ,mtg_estate_loan_bal number(30,8) -- 在押房产贷款余额
    ,bank_org_flg varchar2(10) -- 银行机构标志
    ,in_lon_bank_name varchar2(500) -- 在贷银行名称
    ,villa_type varchar2(500) -- 别墅类型
    ,dir_position varchar2(500) -- 户型位置
    ,row_num number(30) -- 联排数
    ,rg_area number(30,8) -- 花园面积
    ,present_area number(30,8) -- 赠送面积
    ,estim_val number(30,2) -- 评估价值
    ,land_char_cd varchar2(30) -- 土地性质代码
    ,land_char_other_comnt varchar2(500) -- 土地性质其他说明
    ,prep_repl_opering_loan_bal number(30,2) -- 拟置换经营性贷款余额
    ,brwer_share_ratio number(18,6) -- 借款人持股比例
    ,debit_ps_share_ratio number(18,6) -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id varchar2(100) -- 客户经理所属分行机构编号
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,finc_lot number(30,2) -- 理财份额
    ,finc_nv number(30,2) -- 理财净值
    ,finc_pric number(30,2) -- 理财本金
    ,warn_info varchar2(4000) -- 预警信息
    ,tax_flg varchar2(10) -- 涉税标志
    ,tax_type_cd varchar2(30) -- 涉税类型代码
    ,tax_bur_auth_flow_num varchar2(100) -- 税局授权流水号
    ,tax_num varchar2(100) -- 纳税人识别号
    ,obtain_emply_situ_cd varchar2(30) -- 从业状况代码
    ,corp_anl_inco number(30,2) -- 企业年收入
    ,pay_tax_anl_inco number(30,2) -- 纳税年收入
    ,at_mon_inco number(30,2) -- 税后月收入
    ,farm_flg varchar2(10) -- 农户标志
    ,dir_line_kins_name varchar2(500) -- 直系亲属姓名
    ,dir_line_kins_phone varchar2(60) -- 直系亲属联系电话
    ,emerg_contact_name varchar2(500) -- 紧急联系人姓名
    ,emerg_contact_tel varchar2(100) -- 紧急联系人电话
    ,soci_secu_conti_mons number(30) -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons number(30) -- 公积金连续缴存月数
    ,corp_lp_cert_no varchar2(60) -- 企业法人证件号码
    ,corp_equip_qtty number(30) -- 企业设备数量
    ,corp_equip_asset_tot_val number(30,2) -- 企业设备资产总值
    ,corp_fix_asset_loan_bal number(30,2) -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal number(30,2) -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal number(30,2) -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg varchar2(10) -- 跨区域经营标志
    ,rpr_addr varchar2(500) -- 户籍地址
    ,rpr_char_cd varchar2(30) -- 户籍性质代码
    ,rpr_addr_site_cd varchar2(30) -- 户籍地址所在地区代码
    ,corp_addr_site_cd varchar2(30) -- 单位地址所在地区代码
    ,work_tel varchar2(60) -- 单位电话
    ,have_car_flg varchar2(10) -- 有汽车标志
    ,xcd_loan_tenor number(10) -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg varchar2(10) -- 兴车贷同贷书生成成功标志
    ,licen_no varchar2(100) -- 车牌号码
    ,drv_lics_issue_dt date -- 行驶证发证日期
    ,car_single_price_inv number(30,8) -- 汽车裸车价格发票
    ,blip_matrl_auth_dt date -- 影像资料授权日期
    ,que_appl_type_cd varchar2(30) -- 查询申请类型代码
    ,auth_way_cd varchar2(30) -- 授权方式代码
    ,biome_trics varchar2(30) -- 生物识别技术代码
    ,auth_start_dt date -- 授权开始日期
    ,auth_end_dt date -- 授权结束日期
    ,seller_recvbl_acct_id varchar2(100) -- 经销商收款账户编号
    ,seller_corp_name varchar2(500) -- 经销商公司名称
    ,face_recn_score_val number(18,8) -- 人脸识别分值
    ,white_list_cust_flg varchar2(10) -- 白户标志
    ,white_list_cust_id varchar2(100) -- 白名单客户编号
    ,white_list_cust_cert_no varchar2(60) -- 白名单客户证件号码
    ,cust_mgr_belong_org_id varchar2(100) -- 客户经理所属机构编号
    ,appl_amt number(30,2) -- 申请金额
    ,crdt_mode_cd varchar2(30) -- 授信模式代码
    ,risk_cust_flg varchar2(10) -- 风险客户标志
    ,cust_crdt_level_cd varchar2(30) -- 客户信用等级代码
    ,manu_apv_flg varchar2(10) -- 人工审批标志
    ,pre_final_jud_flg varchar2(10) -- 预终审标志
    ,next_acct_check_opinion varchar2(2000) -- 下户核验意见
    ,qlty_check_opinion varchar2(2000) -- 质检岗意见
    ,qlty_check_sugst_amt number(30,8) -- 质检岗建议金额
    ,qlty_check_sugst_tenor number(10) -- 质检岗建议期限
    ,face_opinion varchar2(2000) -- 面谈意见
    ,final_jud_apv_status_cd varchar2(30) -- 终审审批状态代码
    ,hxzd_mode_cd varchar2(30) -- 华兴智贷模式代码
    ,choice_addit_eqty_flg varchar2(10) -- 选择附加权益标志
    ,add_co_brwer_flg varchar2(10) -- 新增共同借款人标志
    ,ms_req_flow_num varchar2(100) -- 庙算请求流水号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_loan_appl_fkd_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_appl_fkd_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_appl_fkd_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_appl_fkd_attach_info_h is '贷款申请房快贷附属信息历史';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.belong_brch_id is '所属分行编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.access_chn_id is '接入渠道编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.crdt_appl_flow_num is '信贷申请流水号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.apv_opinion is '审批意见';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.apv_concus is '审批结论';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.main_debit_ps_cert_type_cd is '主借人证件类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.main_debit_ps_cert_id is '主借人证件编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.issue_org is '证件签发机关名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.issue_cty_cd is '签发国家';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.issue_dt is '签发日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.ghb_emply_flg is '本行员工标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.other_housing_flg is '其他住房标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.estate_qtty is '房产数量';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.repay_src_cd is '还款来源代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.spouse_co_ownr_flg is '配偶共有人标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.spouse_rela_ps_flg is '配偶关联人标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mang_type_cd is '经营类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mercht_name is '商户名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mang_site_type_cd is '经营场所类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mang_site is '经营场所';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.oper_name is '经营者名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.actl_ctrler_name is '实际控制人名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mang_range is '经营范围';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_name is '企业名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.unify_soci_crdt_id is '统一社会信用编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.orgnz_cd is '组织机构代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_lp_name is '企业法人姓名';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.brwer_idti_cd is '借款人身份代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rgst_addr is '注册地址';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rgst_cap is '注册资本';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rgst_dt is '注册日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_type_cd is '企业类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.bus_begin_dt is '营业起始日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.bus_exp_dt is '营业到期日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.lp_obtain_emply_years is '法人从业年限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.lics_name is '许可证名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.lics_id is '许可证编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mang_years is '经营年限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_mgr_opinion_amt is '客户经理意见金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_mgr_opinion_tenor is '客户经理意见期限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.recmd_type_cd is '推荐类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.recmd_agent_name is '推荐中介名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.crdt_amt is '授信金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_jud_appl_tm is '终审申请时间';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_jud_appl_dt is '终审申请日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.score_val is '评分分值';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.crdtc_que_situ_cd is '征信查询情况代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_jud_advise_sucs_flg is '终审通知成功标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.distr_advise_sucs_flg is '放款通知成功标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.refuse_rs_descb is '拒绝原因描述';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_jud_apv_lmt is '终审审批额度';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.dtl_addr is '详细地址';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.work_char_cd is '工作性质代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.apv_end_tm is '审批结束时间';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.blip_doc_flg is '有影像文件标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.inc_fin_brch_cust_mgr_id is '普惠金融分行客户经理编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.brwer_is_actl_ctrler_flg is '借款人为实控人标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_appl_amt is '客户申请金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.hxb_rela_ps_flg is '我行关联人标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.main_brwer_amt_over_flg is '主借款人触碰征信逾期金额过大标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.main_brwer_wif_amt_over_flg is '主借款人配偶触碰征信逾期金额过大标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.borw_cont_id is '借款合同编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.col_id is '押品编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.lmt_cont_crdt_appl_flow_num is '额度合同信贷申请流水号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cont_type_cd is '合同类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.onl_flg is '线上标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.onl_conti_loan_mode_flg is '线上续贷模式标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.conti_loan_begin_dt is '续贷起始日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.conti_loan_exp_dt is '续贷到期日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.have_init_loan_flg is '有原贷款标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.obank_estate_mtg_flg is '他行在押房产标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_dubil_id is '原借据编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_cont_id is '原合同编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_dubil_amt is '原借据金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_dubil_bal is '原借据余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_mtg_bank_name is '原抵押银行名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_mtg_bank_brch_name is '原抵押银行分行名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_loan_circl_flg is '原贷款循环标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_house_loan_amt is '原房屋贷款金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_house_loan_bal is '原房屋贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_loan_surp_tenor is '原贷款剩余期限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_estate_loan_type_cd is '原房产贷款类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.init_house_lon_other_remark is '原房贷其他备注';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.loan_begin_dt is '贷款起始日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.mtg_estate_loan_bal is '在押房产贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.bank_org_flg is '银行机构标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.in_lon_bank_name is '在贷银行名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.villa_type is '别墅类型';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.dir_position is '户型位置';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.row_num is '联排数';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rg_area is '花园面积';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.present_area is '赠送面积';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.estim_val is '评估价值';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.land_char_cd is '土地性质代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.land_char_other_comnt is '土地性质其他说明';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.prep_repl_opering_loan_bal is '拟置换经营性贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.brwer_share_ratio is '借款人持股比例';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.debit_ps_share_ratio is '共借人持股比例';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_mgr_belong_brch_org_id is '客户经理所属分行机构编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.finc_lot is '理财份额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.finc_nv is '理财净值';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.finc_pric is '理财本金';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.warn_info is '预警信息';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.tax_flg is '涉税标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.tax_type_cd is '涉税类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.tax_bur_auth_flow_num is '税局授权流水号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.tax_num is '纳税人识别号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.obtain_emply_situ_cd is '从业状况代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_anl_inco is '企业年收入';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.pay_tax_anl_inco is '纳税年收入';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.at_mon_inco is '税后月收入';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.farm_flg is '农户标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.dir_line_kins_name is '直系亲属姓名';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.dir_line_kins_phone is '直系亲属联系电话';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.emerg_contact_name is '紧急联系人姓名';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.emerg_contact_tel is '紧急联系人电话';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.soci_secu_conti_mons is '社保连续缴存月数';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.provi_fund_conti_deposite_mons is '公积金连续缴存月数';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_lp_cert_no is '企业法人证件号码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_equip_qtty is '企业设备数量';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_equip_asset_tot_val is '企业设备资产总值';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_fix_asset_loan_bal is '企业固定资产贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_equip_fin_rent_loan_bal is '企业设备融资租赁贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_curt_cap_loan_bal is '企业流动资金贷款余额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.acrs_rg_mang_flg is '跨区域经营标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rpr_addr is '户籍地址';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rpr_char_cd is '户籍性质代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.rpr_addr_site_cd is '户籍地址所在地区代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.corp_addr_site_cd is '单位地址所在地区代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.work_tel is '单位电话';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.have_car_flg is '有汽车标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.xcd_loan_tenor is '兴车贷贷款期限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.xcd_lon_create_sucs_flg is '兴车贷同贷书生成成功标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.licen_no is '车牌号码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.drv_lics_issue_dt is '行驶证发证日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.car_single_price_inv is '汽车裸车价格发票';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.blip_matrl_auth_dt is '影像资料授权日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.que_appl_type_cd is '查询申请类型代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.auth_way_cd is '授权方式代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.biome_trics is '生物识别技术代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.auth_start_dt is '授权开始日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.auth_end_dt is '授权结束日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.seller_recvbl_acct_id is '经销商收款账户编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.seller_corp_name is '经销商公司名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.face_recn_score_val is '人脸识别分值';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.white_list_cust_flg is '白户标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.white_list_cust_id is '白名单客户编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.white_list_cust_cert_no is '白名单客户证件号码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_mgr_belong_org_id is '客户经理所属机构编号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.appl_amt is '申请金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.crdt_mode_cd is '授信模式代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.risk_cust_flg is '风险客户标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.cust_crdt_level_cd is '客户信用等级代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.manu_apv_flg is '人工审批标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.pre_final_jud_flg is '预终审标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.next_acct_check_opinion is '下户核验意见';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.qlty_check_opinion is '质检岗意见';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.qlty_check_sugst_amt is '质检岗建议金额';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.qlty_check_sugst_tenor is '质检岗建议期限';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.face_opinion is '面谈意见';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_jud_apv_status_cd is '终审审批状态代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.hxzd_mode_cd is '华兴智贷模式代码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.choice_addit_eqty_flg is '选择附加权益标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.add_co_brwer_flg is '新增共同借款人标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.ms_req_flow_num is '庙算请求流水号';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_appl_fkd_attach_info_h.etl_timestamp is 'ETL处理时间戳';
