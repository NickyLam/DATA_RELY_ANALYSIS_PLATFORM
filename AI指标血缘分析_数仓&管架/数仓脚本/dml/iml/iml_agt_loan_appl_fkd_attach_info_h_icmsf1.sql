/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_fkd_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_fkd_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_fkd_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_fkd_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_fkd_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_fkd_iqp_loan_app-1
insert into ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.PRDCODE -- 产品编号
    ,P1.PRDNAME -- 产品名称
    ,P1.CTRLBRANCH -- 所属分行编号
    ,P1.APPCHANNEL -- 接入渠道编号
    ,P1.CHANNELNO -- 渠道编号
    ,P1.APPLYNO -- 信贷申请流水号
    ,P1.APPADVICE -- 审批意见
    ,P1.APPCONCLUSION -- 审批结论
    ,nvl(trim(P1.CERTTYPE),'0000') -- 主借人证件类型代码
    ,P1.CERTNO -- 主借人证件编号
    ,nvl(trim(P1.GENDER),'9') -- 性别代码
    ,P1.ISSAUTHORITY -- 证件签发机关名称
    ,P1.ISSCOUNTRY -- 签发国家
    ,P1.ISSDATE -- 签发日期
    ,P1.EXPIRYDATE -- 到期日期
    ,P1.BANKIND -- 本行员工标志
    ,P1.HASHOUSEIND -- 其他住房标志
    ,P1.HOUSECOUNT -- 房产数量
    ,nvl(trim(P1.PAYSOURCEN),'00') -- 还款来源代码
    ,P1.PARTNERCOOWNERIND -- 配偶共有人标志
    ,P1.PARTNERRELIND -- 配偶关联人标志
    ,nvl(trim(P1.BUSINESSTYPE),'03') -- 经营类型代码
    ,P1.MERCHANTNAME -- 商户名称
    ,nvl(trim(P1.BUSINESSADDRTYPE),'-')  -- 经营场所类型代码
    ,P1.BUSINESSADDR -- 经营场所
    ,P1.BSOPTNAME -- 经营者名称
    ,P1.ACTUALCONTROLER -- 实际控制人名称
    ,P1.BUSINESSSCOPE -- 经营范围
    ,P1.ENTERPRISENAME -- 企业名称
    ,P1.UNIFYSOCIALCREDITNUM -- 统一社会信用编号
    ,nvl(trim(P1.ORGINSTITUDECODE),'-') -- 组织机构代码
    ,P1.ENTLEGALPERSONNAME -- 企业法人姓名
    ,nvl(trim(P1.BORROWERIDENTITY),'-') -- 借款人身份代码
    ,P1.REGISTADDRESS -- 注册地址
    ,P1.REGISTASSETS -- 注册资本
    ,P1.REGISTDATE -- 注册日期
    ,nvl(trim(P1.CPTYPE),'-') -- 企业类型代码
    ,P1.BSSTARTDATE -- 营业起始日期
    ,P1.BSENDDATE -- 营业到期日期
    ,nvl(trim(P1.PRACTYEARS),0) -- 法人从业年限
    ,P1.LICENSENAME -- 许可证名称
    ,P1.LICENSENO -- 许可证编号
    ,P1.COMPANYYEAR -- 经营年限
    ,P1.USERBUSINESSSUM -- 客户经理意见金额
    ,nvl(trim(P1.USERLIMITTERM),0) -- 客户经理意见期限
    ,P1.RECOMMENDTYPE -- 推荐类型代码
    ,P1.RECOMMENDAGENCY -- 推荐中介名称
    ,P1.CREDITAMT -- 授信金额
    ,P1.INPUTTIME -- 终审申请时间
    ,P1.INPUTDATE -- 终审申请日期
    ,P1.AUTOSCORE -- 评分分值
    ,P1.ISCOLLECTCREDIT -- 征信查询情况代码
    ,nvl(trim(P1.INFORMFLAG),'-') -- 终审通知成功标志
    ,P1.LOANINFORMFLAG -- 放款通知成功标志
    ,P1.FAILREASON -- 拒绝原因描述
    ,P1.FINALAPPLYAMOUNT -- 终审审批额度
    ,P1.CUSID -- 客户编号
    ,P1.DETAILADDR -- 详细地址
    ,nvl(trim(P1.WORKNATURE),'5') -- 工作性质代码
    ,P1.INPUTBRID -- 管理机构编号
    ,P1.PHONE -- 手机号码
    ,${iml_schema}.timeformat_max2(P1.APPRENDTIME) -- 审批结束时间
    ,nvl(trim(P1.ISEMOJI),'-') -- 有影像文件标志
    ,P1.INPUTID -- 普惠金融分行客户经理编号
    ,P1.OWNERFLAG -- 借款人为实控人标志
    ,P1.LOANAMT -- 客户申请金额
    ,nvl(trim(P1.ISBANKREL),'-') -- 我行关联人标志
    ,nvl(trim(P1.ISOVERDUEMAIN),'-') -- 主借款人触碰征信逾期金额过大标志
    ,nvl(trim(P1.ISOVERDUEMAINCP),'-') -- 主借款人配偶触碰征信逾期金额过大标志
    ,P1.CONTNO -- 借款合同编号
    ,P1.GUARANTYID -- 押品编号
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,P1.LMTLOANAPPNO -- 额度合同信贷申请流水号
    ,nvl(trim(P1.CONTTYPE),'0') -- 合同类型代码
    ,decode(P1.ISONLINE,'2','0',' ','-',P1.ISONLINE) -- 线上标志
    ,decode(P1.RENEWALMODEL,'2','0',' ','-',P1.RENEWALMODEL) -- 线上续贷模式标志
    ,P1.RENEWALSTARTDATE -- 续贷起始日期
    ,P1.RENEWALENDDATE -- 续贷到期日期
    ,P1.LMTSERNO -- 额度合同编号
    ,decode(P1.ORIGINALLOAN,'2','0',' ','-',P1.ORIGINALLOAN) -- 有原贷款标志
    ,nvl(trim(P1.ISOTHERBANKMTG),'-') -- 他行在押房产标志
    ,P1.OBILLNO -- 原借据编号
    ,P1.OCONTNO -- 原合同编号
    ,P1.OLOANAMOUNT -- 原借据金额
    ,P1.OLOANBALANCE -- 原借据余额
    ,P1.ORGMTGBANK -- 原抵押银行名称
    ,P1.ORGMTGBANKBRANCH -- 原抵押银行分行名称
    ,nvl(trim(P1.OLOANISCIRCLE),'-') -- 原贷款循环标志
    ,P1.OBANKLOANAMT -- 原房屋贷款金额
    ,P1.OBANKLOANSURNOTBAL -- 原房屋贷款余额
    ,P1.OLOANSURTERM -- 原贷款剩余期限
    ,nvl(trim(P1.ORGHOUSELOANTYPE),'5') -- 原房产贷款类型代码
    ,P1.OTHERDIRECTION -- 原房贷其他备注
    ,${iml_schema}.dateformat_min(P1.LOANSTARTDATE) -- 贷款起始日期
    ,P1.LOANENDDATE -- 贷款到期日期
    ,P1.ORGHOUSELOANBALANCE -- 在押房产贷款余额
    ,nvl(trim(P1.ISBANKORG),'-') -- 银行机构标志
    ,P1.ISONLOANBANK -- 在贷银行名称
    ,P1.VILLATYPE -- 别墅类型
    ,P1.HOUSETYPELOCATION -- 户型位置
    ,nvl(to_number(regexp_replace(P1.ROWNO,'[^0-9.]','')) ,0) -- 联排数
    ,P1.GARDENAREA -- 花园面积
    ,P1.FREEAREA -- 赠送面积
    ,P1.ROOMPRICE -- 评估价值
    ,nvl(trim(P1.NATURELAND),'00') -- 土地性质代码
    ,P1.NATURELANDEXPLAIN -- 土地性质其他说明
    ,P1.DISPLACEOPERATLOANBAL -- 拟置换经营性贷款余额
    ,P1.INVTSTKPERC -- 借款人持股比例
    ,P1.COBOINVTSTKPERC -- 共借人持股比例
    ,P1.ONBRANCHBANK -- 客户经理所属分行机构编号
    ,P1.RISKLEVEL -- 风险等级代码
    ,P1.LOT -- 理财份额
    ,P1.NETVALUE -- 理财净值
    ,P1.PRINCIPALAMT -- 理财本金
    ,P1.WARNINGINFO -- 预警信息
    ,nvl(trim(P1.TAXFLG),'-') -- 涉税标志
    ,nvl(trim(P1.TAXRELATEDTYPE),'-') -- 涉税类型代码
    ,P1.TAXBUREAUSERNO -- 税局授权流水号
    ,P1.TAXPAYERIDENTINO -- 纳税人识别号
    ,nvl(trim(P1.EMPLOYMENTSITUATION),'99') -- 从业状况代码
    ,P1.ENTERPRISEYEARINCOME -- 企业年收入
    ,P1.ANNUALTAXREVENUE -- 纳税年收入
    ,P1.MONINCOME -- 税后月收入
    ,nvl(trim(P1.AGRIFLG),'-') -- 农户标志
    ,P1.RELATIONNAME -- 直系亲属姓名
    ,P1.RELATIONPHONE -- 直系亲属联系电话
    ,P1.URGENTCONTACTNAME -- 紧急联系人姓名
    ,P1.URGENTCONTACTPHONE -- 紧急联系人电话
    ,nvl(to_number(regexp_replace(P1.SOCIALMON,'[^0-9.]','')) ,0) -- 社保连续缴存月数
    ,nvl(to_number(regexp_replace(P1.ACCUMULFUNDMON,'[^0-9.]','')) ,0) -- 公积金连续缴存月数
    ,P1.ENTLEGALPERSONIDNO -- 企业法人证件号码
    ,nvl(to_number(regexp_replace(P1.DEVICEAMOUNT,'[^0-9.]','')) ,0) -- 企业设备数量
    ,P1.DEVICETOTALPRICE -- 企业设备资产总值
    ,P1.FIXEDFUNDLOANBALANCE -- 企业固定资产贷款余额
    ,P1.DEVICELOANBALANCE -- 企业设备融资租赁贷款余额
    ,P1.WORKINGLOANBALANCE -- 企业流动资金贷款余额
    ,nvl(trim(P1.ISCROSSREGIONRUN),'-') -- 跨区域经营标志
    ,P1.DOMICILEADDR -- 户籍地址
    ,nvl(trim(P1.NATUREREGISTERED),'00') -- 户籍性质代码
    ,nvl(trim(P1.RESILOCZONECD),'000000') -- 户籍地址所在地区代码
    ,nvl(trim(P1.UNTLOCZONECD),'000000') -- 单位地址所在地区代码
    ,P1.COMPPHONE -- 单位电话
    ,nvl(trim(P1.ISHAVECAR),'-') -- 有汽车标志
    ,nvl(to_number(regexp_replace(P1.PRELOANTERM,'[^0-9.]','')) ,0) -- 兴车贷贷款期限
    ,decode(P1.ISBORROWBOOK,'2','0',' ','-',P1.ISBORROWBOOK) -- 兴车贷同贷书生成成功标志
    ,P1.LICENSENUMBER -- 车牌号码
    ,P1.DRIVINGLICENSEDATE -- 行驶证发证日期
    ,P1.CARINVOICE -- 汽车裸车价格发票
    ,${iml_schema}.dateformat_max2(P1.AUTHOTIME) -- 影像资料授权日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.QRYOPERTP END -- 查询申请类型代码
    ,nvl(trim(P1.AUTHOTYPE),'-') -- 授权方式代码
    ,nvl(trim(P1.BIOMETRICS),'-') -- 生物识别技术代码
    ,P1.AUTHOSTRDATE -- 授权开始日期
    ,P1.AUTHOENDDATE -- 授权结束日期
    ,P1.RECACCT -- 经销商收款账户编号
    ,P1.RECACCTBANKNAME -- 经销商公司名称
    ,nvl(to_number(regexp_replace(P1.FACEIDENTIFISCORE,'[^0-9.]','')) ,0) -- 人脸识别分值
    ,nvl(trim(P1.ISWHITE),'-') -- 白户标志
    ,P1.WHITECUSID -- 白名单客户编号
    ,P1.WHITECERTCODE -- 白名单客户证件号码
    ,P1.CTRLORG -- 客户经理所属机构编号
    ,P1.APPLYAMT -- 申请金额
    ,nvl(trim(P1.CREDITMODEL),'-') -- 授信模式代码
    ,nvl(trim(P1.ISRISKCUST),'-') -- 风险客户标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CUSCREDITSCORELEVEL END -- 客户信用等级代码
    ,nvl(trim(P1.MANUALAPPROVAL),'-') -- 人工审批标志
    ,decode(P1.ISPREFLAG,'2','0',' ','-',P1.ISPREFLAG) -- 预终审标志
    ,P1.CHECKERSUGGEST -- 下户核验意见
    ,P1.INSPSUGGEST -- 质检岗意见
    ,P1.INSPSUM -- 质检岗建议金额
    ,nvl(to_number(regexp_replace(P1.INSPLIMITTERM,'[^0-9.]','')) ,0) -- 质检岗建议期限
    ,P1.INTERVIEWSUGGEST -- 面谈意见
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 终审审批状态代码
    ,nvl(trim(P1.WISDOMLOANMODE),'-') -- 华兴智贷模式代码
    ,nvl(trim(P1.ISADDEDVALUE),'-') -- 选择附加权益标志
    ,nvl(trim(P1.ISNEWCOBORROWER),'-') -- 新增共同借款人标志
    ,P1.SEQID -- 庙算请求流水号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fkd_iqp_loan_app' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fkd_iqp_loan_app p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.QRYOPERTP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_FKD_IQP_LOAN_APP'
        AND R1.SRC_FIELD_EN_NAME= 'QRYOPERTP'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_FKD_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'QUE_APPL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CUSCREDITSCORELEVEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_FKD_IQP_LOAN_APP'
        AND R2.SRC_FIELD_EN_NAME= 'CUSCREDITSCORELEVEL'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_APPL_FKD_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_CRDT_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.belong_brch_id, o.belong_brch_id) as belong_brch_id -- 所属分行编号
    ,nvl(n.access_chn_id, o.access_chn_id) as access_chn_id -- 接入渠道编号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 信贷申请流水号
    ,nvl(n.apv_opinion, o.apv_opinion) as apv_opinion -- 审批意见
    ,nvl(n.apv_concus, o.apv_concus) as apv_concus -- 审批结论
    ,nvl(n.main_debit_ps_cert_type_cd, o.main_debit_ps_cert_type_cd) as main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,nvl(n.main_debit_ps_cert_id, o.main_debit_ps_cert_id) as main_debit_ps_cert_id -- 主借人证件编号
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.issue_org, o.issue_org) as issue_org -- 证件签发机关名称
    ,nvl(n.issue_cty_cd, o.issue_cty_cd) as issue_cty_cd -- 签发国家
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 签发日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.ghb_emply_flg, o.ghb_emply_flg) as ghb_emply_flg -- 本行员工标志
    ,nvl(n.other_housing_flg, o.other_housing_flg) as other_housing_flg -- 其他住房标志
    ,nvl(n.estate_qtty, o.estate_qtty) as estate_qtty -- 房产数量
    ,nvl(n.repay_src_cd, o.repay_src_cd) as repay_src_cd -- 还款来源代码
    ,nvl(n.spouse_co_ownr_flg, o.spouse_co_ownr_flg) as spouse_co_ownr_flg -- 配偶共有人标志
    ,nvl(n.spouse_rela_ps_flg, o.spouse_rela_ps_flg) as spouse_rela_ps_flg -- 配偶关联人标志
    ,nvl(n.mang_type_cd, o.mang_type_cd) as mang_type_cd -- 经营类型代码
    ,nvl(n.mercht_name, o.mercht_name) as mercht_name -- 商户名称
    ,nvl(n.mang_site_type_cd, o.mang_site_type_cd) as mang_site_type_cd -- 经营场所类型代码
    ,nvl(n.mang_site, o.mang_site) as mang_site -- 经营场所
    ,nvl(n.oper_name, o.oper_name) as oper_name -- 经营者名称
    ,nvl(n.actl_ctrler_name, o.actl_ctrler_name) as actl_ctrler_name -- 实际控制人名称
    ,nvl(n.mang_range, o.mang_range) as mang_range -- 经营范围
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.unify_soci_crdt_id, o.unify_soci_crdt_id) as unify_soci_crdt_id -- 统一社会信用编号
    ,nvl(n.orgnz_cd, o.orgnz_cd) as orgnz_cd -- 组织机构代码
    ,nvl(n.corp_lp_name, o.corp_lp_name) as corp_lp_name -- 企业法人姓名
    ,nvl(n.brwer_idti_cd, o.brwer_idti_cd) as brwer_idti_cd -- 借款人身份代码
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资本
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 注册日期
    ,nvl(n.corp_type_cd, o.corp_type_cd) as corp_type_cd -- 企业类型代码
    ,nvl(n.bus_begin_dt, o.bus_begin_dt) as bus_begin_dt -- 营业起始日期
    ,nvl(n.bus_exp_dt, o.bus_exp_dt) as bus_exp_dt -- 营业到期日期
    ,nvl(n.lp_obtain_emply_years, o.lp_obtain_emply_years) as lp_obtain_emply_years -- 法人从业年限
    ,nvl(n.lics_name, o.lics_name) as lics_name -- 许可证名称
    ,nvl(n.lics_id, o.lics_id) as lics_id -- 许可证编号
    ,nvl(n.mang_years, o.mang_years) as mang_years -- 经营年限
    ,nvl(n.cust_mgr_opinion_amt, o.cust_mgr_opinion_amt) as cust_mgr_opinion_amt -- 客户经理意见金额
    ,nvl(n.cust_mgr_opinion_tenor, o.cust_mgr_opinion_tenor) as cust_mgr_opinion_tenor -- 客户经理意见期限
    ,nvl(n.recmd_type_cd, o.recmd_type_cd) as recmd_type_cd -- 推荐类型代码
    ,nvl(n.recmd_agent_name, o.recmd_agent_name) as recmd_agent_name -- 推荐中介名称
    ,nvl(n.crdt_amt, o.crdt_amt) as crdt_amt -- 授信金额
    ,nvl(n.final_jud_appl_tm, o.final_jud_appl_tm) as final_jud_appl_tm -- 终审申请时间
    ,nvl(n.final_jud_appl_dt, o.final_jud_appl_dt) as final_jud_appl_dt -- 终审申请日期
    ,nvl(n.score_val, o.score_val) as score_val -- 评分分值
    ,nvl(n.crdtc_que_situ_cd, o.crdtc_que_situ_cd) as crdtc_que_situ_cd -- 征信查询情况代码
    ,nvl(n.final_jud_advise_sucs_flg, o.final_jud_advise_sucs_flg) as final_jud_advise_sucs_flg -- 终审通知成功标志
    ,nvl(n.distr_advise_sucs_flg, o.distr_advise_sucs_flg) as distr_advise_sucs_flg -- 放款通知成功标志
    ,nvl(n.refuse_rs_descb, o.refuse_rs_descb) as refuse_rs_descb -- 拒绝原因描述
    ,nvl(n.final_jud_apv_lmt, o.final_jud_apv_lmt) as final_jud_apv_lmt -- 终审审批额度
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.dtl_addr, o.dtl_addr) as dtl_addr -- 详细地址
    ,nvl(n.work_char_cd, o.work_char_cd) as work_char_cd -- 工作性质代码
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.apv_end_tm, o.apv_end_tm) as apv_end_tm -- 审批结束时间
    ,nvl(n.blip_doc_flg, o.blip_doc_flg) as blip_doc_flg -- 有影像文件标志
    ,nvl(n.inc_fin_brch_cust_mgr_id, o.inc_fin_brch_cust_mgr_id) as inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,nvl(n.brwer_is_actl_ctrler_flg, o.brwer_is_actl_ctrler_flg) as brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,nvl(n.cust_appl_amt, o.cust_appl_amt) as cust_appl_amt -- 客户申请金额
    ,nvl(n.hxb_rela_ps_flg, o.hxb_rela_ps_flg) as hxb_rela_ps_flg -- 我行关联人标志
    ,nvl(n.main_brwer_amt_over_flg, o.main_brwer_amt_over_flg) as main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,nvl(n.main_brwer_wif_amt_over_flg, o.main_brwer_wif_amt_over_flg) as main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,nvl(n.borw_cont_id, o.borw_cont_id) as borw_cont_id -- 借款合同编号
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.lmt_cont_crdt_appl_flow_num, o.lmt_cont_crdt_appl_flow_num) as lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.onl_flg, o.onl_flg) as onl_flg -- 线上标志
    ,nvl(n.onl_conti_loan_mode_flg, o.onl_conti_loan_mode_flg) as onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,nvl(n.conti_loan_begin_dt, o.conti_loan_begin_dt) as conti_loan_begin_dt -- 续贷起始日期
    ,nvl(n.conti_loan_exp_dt, o.conti_loan_exp_dt) as conti_loan_exp_dt -- 续贷到期日期
    ,nvl(n.lmt_cont_id, o.lmt_cont_id) as lmt_cont_id -- 额度合同编号
    ,nvl(n.have_init_loan_flg, o.have_init_loan_flg) as have_init_loan_flg -- 有原贷款标志
    ,nvl(n.obank_estate_mtg_flg, o.obank_estate_mtg_flg) as obank_estate_mtg_flg -- 他行在押房产标志
    ,nvl(n.init_dubil_id, o.init_dubil_id) as init_dubil_id -- 原借据编号
    ,nvl(n.init_cont_id, o.init_cont_id) as init_cont_id -- 原合同编号
    ,nvl(n.init_dubil_amt, o.init_dubil_amt) as init_dubil_amt -- 原借据金额
    ,nvl(n.init_dubil_bal, o.init_dubil_bal) as init_dubil_bal -- 原借据余额
    ,nvl(n.init_mtg_bank_name, o.init_mtg_bank_name) as init_mtg_bank_name -- 原抵押银行名称
    ,nvl(n.init_mtg_bank_brch_name, o.init_mtg_bank_brch_name) as init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,nvl(n.init_loan_circl_flg, o.init_loan_circl_flg) as init_loan_circl_flg -- 原贷款循环标志
    ,nvl(n.init_house_loan_amt, o.init_house_loan_amt) as init_house_loan_amt -- 原房屋贷款金额
    ,nvl(n.init_house_loan_bal, o.init_house_loan_bal) as init_house_loan_bal -- 原房屋贷款余额
    ,nvl(n.init_loan_surp_tenor, o.init_loan_surp_tenor) as init_loan_surp_tenor -- 原贷款剩余期限
    ,nvl(n.init_estate_loan_type_cd, o.init_estate_loan_type_cd) as init_estate_loan_type_cd -- 原房产贷款类型代码
    ,nvl(n.init_house_lon_other_remark, o.init_house_lon_other_remark) as init_house_lon_other_remark -- 原房贷其他备注
    ,nvl(n.loan_begin_dt, o.loan_begin_dt) as loan_begin_dt -- 贷款起始日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.mtg_estate_loan_bal, o.mtg_estate_loan_bal) as mtg_estate_loan_bal -- 在押房产贷款余额
    ,nvl(n.bank_org_flg, o.bank_org_flg) as bank_org_flg -- 银行机构标志
    ,nvl(n.in_lon_bank_name, o.in_lon_bank_name) as in_lon_bank_name -- 在贷银行名称
    ,nvl(n.villa_type, o.villa_type) as villa_type -- 别墅类型
    ,nvl(n.dir_position, o.dir_position) as dir_position -- 户型位置
    ,nvl(n.row_num, o.row_num) as row_num -- 联排数
    ,nvl(n.rg_area, o.rg_area) as rg_area -- 花园面积
    ,nvl(n.present_area, o.present_area) as present_area -- 赠送面积
    ,nvl(n.estim_val, o.estim_val) as estim_val -- 评估价值
    ,nvl(n.land_char_cd, o.land_char_cd) as land_char_cd -- 土地性质代码
    ,nvl(n.land_char_other_comnt, o.land_char_other_comnt) as land_char_other_comnt -- 土地性质其他说明
    ,nvl(n.prep_repl_opering_loan_bal, o.prep_repl_opering_loan_bal) as prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,nvl(n.brwer_share_ratio, o.brwer_share_ratio) as brwer_share_ratio -- 借款人持股比例
    ,nvl(n.debit_ps_share_ratio, o.debit_ps_share_ratio) as debit_ps_share_ratio -- 共借人持股比例
    ,nvl(n.cust_mgr_belong_brch_org_id, o.cust_mgr_belong_brch_org_id) as cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.finc_lot, o.finc_lot) as finc_lot -- 理财份额
    ,nvl(n.finc_nv, o.finc_nv) as finc_nv -- 理财净值
    ,nvl(n.finc_pric, o.finc_pric) as finc_pric -- 理财本金
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.tax_flg, o.tax_flg) as tax_flg -- 涉税标志
    ,nvl(n.tax_type_cd, o.tax_type_cd) as tax_type_cd -- 涉税类型代码
    ,nvl(n.tax_bur_auth_flow_num, o.tax_bur_auth_flow_num) as tax_bur_auth_flow_num -- 税局授权流水号
    ,nvl(n.tax_num, o.tax_num) as tax_num -- 纳税人识别号
    ,nvl(n.obtain_emply_situ_cd, o.obtain_emply_situ_cd) as obtain_emply_situ_cd -- 从业状况代码
    ,nvl(n.corp_anl_inco, o.corp_anl_inco) as corp_anl_inco -- 企业年收入
    ,nvl(n.pay_tax_anl_inco, o.pay_tax_anl_inco) as pay_tax_anl_inco -- 纳税年收入
    ,nvl(n.at_mon_inco, o.at_mon_inco) as at_mon_inco -- 税后月收入
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.dir_line_kins_name, o.dir_line_kins_name) as dir_line_kins_name -- 直系亲属姓名
    ,nvl(n.dir_line_kins_phone, o.dir_line_kins_phone) as dir_line_kins_phone -- 直系亲属联系电话
    ,nvl(n.emerg_contact_name, o.emerg_contact_name) as emerg_contact_name -- 紧急联系人姓名
    ,nvl(n.emerg_contact_tel, o.emerg_contact_tel) as emerg_contact_tel -- 紧急联系人电话
    ,nvl(n.soci_secu_conti_mons, o.soci_secu_conti_mons) as soci_secu_conti_mons -- 社保连续缴存月数
    ,nvl(n.provi_fund_conti_deposite_mons, o.provi_fund_conti_deposite_mons) as provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,nvl(n.corp_lp_cert_no, o.corp_lp_cert_no) as corp_lp_cert_no -- 企业法人证件号码
    ,nvl(n.corp_equip_qtty, o.corp_equip_qtty) as corp_equip_qtty -- 企业设备数量
    ,nvl(n.corp_equip_asset_tot_val, o.corp_equip_asset_tot_val) as corp_equip_asset_tot_val -- 企业设备资产总值
    ,nvl(n.corp_fix_asset_loan_bal, o.corp_fix_asset_loan_bal) as corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,nvl(n.corp_equip_fin_rent_loan_bal, o.corp_equip_fin_rent_loan_bal) as corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,nvl(n.corp_curt_cap_loan_bal, o.corp_curt_cap_loan_bal) as corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,nvl(n.acrs_rg_mang_flg, o.acrs_rg_mang_flg) as acrs_rg_mang_flg -- 跨区域经营标志
    ,nvl(n.rpr_addr, o.rpr_addr) as rpr_addr -- 户籍地址
    ,nvl(n.rpr_char_cd, o.rpr_char_cd) as rpr_char_cd -- 户籍性质代码
    ,nvl(n.rpr_addr_site_cd, o.rpr_addr_site_cd) as rpr_addr_site_cd -- 户籍地址所在地区代码
    ,nvl(n.corp_addr_site_cd, o.corp_addr_site_cd) as corp_addr_site_cd -- 单位地址所在地区代码
    ,nvl(n.work_tel, o.work_tel) as work_tel -- 单位电话
    ,nvl(n.have_car_flg, o.have_car_flg) as have_car_flg -- 有汽车标志
    ,nvl(n.xcd_loan_tenor, o.xcd_loan_tenor) as xcd_loan_tenor -- 兴车贷贷款期限
    ,nvl(n.xcd_lon_create_sucs_flg, o.xcd_lon_create_sucs_flg) as xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,nvl(n.licen_no, o.licen_no) as licen_no -- 车牌号码
    ,nvl(n.drv_lics_issue_dt, o.drv_lics_issue_dt) as drv_lics_issue_dt -- 行驶证发证日期
    ,nvl(n.car_single_price_inv, o.car_single_price_inv) as car_single_price_inv -- 汽车裸车价格发票
    ,nvl(n.blip_matrl_auth_dt, o.blip_matrl_auth_dt) as blip_matrl_auth_dt -- 影像资料授权日期
    ,nvl(n.que_appl_type_cd, o.que_appl_type_cd) as que_appl_type_cd -- 查询申请类型代码
    ,nvl(n.auth_way_cd, o.auth_way_cd) as auth_way_cd -- 授权方式代码
    ,nvl(n.biome_trics, o.biome_trics) as biome_trics -- 生物识别技术代码
    ,nvl(n.auth_start_dt, o.auth_start_dt) as auth_start_dt -- 授权开始日期
    ,nvl(n.auth_end_dt, o.auth_end_dt) as auth_end_dt -- 授权结束日期
    ,nvl(n.seller_recvbl_acct_id, o.seller_recvbl_acct_id) as seller_recvbl_acct_id -- 经销商收款账户编号
    ,nvl(n.seller_corp_name, o.seller_corp_name) as seller_corp_name -- 经销商公司名称
    ,nvl(n.face_recn_score_val, o.face_recn_score_val) as face_recn_score_val -- 人脸识别分值
    ,nvl(n.white_list_cust_flg, o.white_list_cust_flg) as white_list_cust_flg -- 白户标志
    ,nvl(n.white_list_cust_id, o.white_list_cust_id) as white_list_cust_id -- 白名单客户编号
    ,nvl(n.white_list_cust_cert_no, o.white_list_cust_cert_no) as white_list_cust_cert_no -- 白名单客户证件号码
    ,nvl(n.cust_mgr_belong_org_id, o.cust_mgr_belong_org_id) as cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.crdt_mode_cd, o.crdt_mode_cd) as crdt_mode_cd -- 授信模式代码
    ,nvl(n.risk_cust_flg, o.risk_cust_flg) as risk_cust_flg -- 风险客户标志
    ,nvl(n.cust_crdt_level_cd, o.cust_crdt_level_cd) as cust_crdt_level_cd -- 客户信用等级代码
    ,nvl(n.manu_apv_flg, o.manu_apv_flg) as manu_apv_flg -- 人工审批标志
    ,nvl(n.pre_final_jud_flg, o.pre_final_jud_flg) as pre_final_jud_flg -- 预终审标志
    ,nvl(n.next_acct_check_opinion, o.next_acct_check_opinion) as next_acct_check_opinion -- 下户核验意见
    ,nvl(n.qlty_check_opinion, o.qlty_check_opinion) as qlty_check_opinion -- 质检岗意见
    ,nvl(n.qlty_check_sugst_amt, o.qlty_check_sugst_amt) as qlty_check_sugst_amt -- 质检岗建议金额
    ,nvl(n.qlty_check_sugst_tenor, o.qlty_check_sugst_tenor) as qlty_check_sugst_tenor -- 质检岗建议期限
    ,nvl(n.face_opinion, o.face_opinion) as face_opinion -- 面谈意见
    ,nvl(n.final_jud_apv_status_cd, o.final_jud_apv_status_cd) as final_jud_apv_status_cd -- 终审审批状态代码
    ,nvl(n.hxzd_mode_cd, o.hxzd_mode_cd) as hxzd_mode_cd -- 华兴智贷模式代码
    ,nvl(n.choice_addit_eqty_flg, o.choice_addit_eqty_flg) as choice_addit_eqty_flg -- 选择附加权益标志
    ,nvl(n.add_co_brwer_flg, o.add_co_brwer_flg) as add_co_brwer_flg -- 新增共同借款人标志
    ,nvl(n.ms_req_flow_num, o.ms_req_flow_num) as ms_req_flow_num -- 庙算请求流水号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.prod_id <> n.prod_id
        or o.prod_name <> n.prod_name
        or o.belong_brch_id <> n.belong_brch_id
        or o.access_chn_id <> n.access_chn_id
        or o.chn_id <> n.chn_id
        or o.crdt_appl_flow_num <> n.crdt_appl_flow_num
        or o.apv_opinion <> n.apv_opinion
        or o.apv_concus <> n.apv_concus
        or o.main_debit_ps_cert_type_cd <> n.main_debit_ps_cert_type_cd
        or o.main_debit_ps_cert_id <> n.main_debit_ps_cert_id
        or o.gender_cd <> n.gender_cd
        or o.issue_org <> n.issue_org
        or o.issue_cty_cd <> n.issue_cty_cd
        or o.issue_dt <> n.issue_dt
        or o.exp_dt <> n.exp_dt
        or o.ghb_emply_flg <> n.ghb_emply_flg
        or o.other_housing_flg <> n.other_housing_flg
        or o.estate_qtty <> n.estate_qtty
        or o.repay_src_cd <> n.repay_src_cd
        or o.spouse_co_ownr_flg <> n.spouse_co_ownr_flg
        or o.spouse_rela_ps_flg <> n.spouse_rela_ps_flg
        or o.mang_type_cd <> n.mang_type_cd
        or o.mercht_name <> n.mercht_name
        or o.mang_site_type_cd <> n.mang_site_type_cd
        or o.mang_site <> n.mang_site
        or o.oper_name <> n.oper_name
        or o.actl_ctrler_name <> n.actl_ctrler_name
        or o.mang_range <> n.mang_range
        or o.corp_name <> n.corp_name
        or o.unify_soci_crdt_id <> n.unify_soci_crdt_id
        or o.orgnz_cd <> n.orgnz_cd
        or o.corp_lp_name <> n.corp_lp_name
        or o.brwer_idti_cd <> n.brwer_idti_cd
        or o.rgst_addr <> n.rgst_addr
        or o.rgst_cap <> n.rgst_cap
        or o.rgst_dt <> n.rgst_dt
        or o.corp_type_cd <> n.corp_type_cd
        or o.bus_begin_dt <> n.bus_begin_dt
        or o.bus_exp_dt <> n.bus_exp_dt
        or o.lp_obtain_emply_years <> n.lp_obtain_emply_years
        or o.lics_name <> n.lics_name
        or o.lics_id <> n.lics_id
        or o.mang_years <> n.mang_years
        or o.cust_mgr_opinion_amt <> n.cust_mgr_opinion_amt
        or o.cust_mgr_opinion_tenor <> n.cust_mgr_opinion_tenor
        or o.recmd_type_cd <> n.recmd_type_cd
        or o.recmd_agent_name <> n.recmd_agent_name
        or o.crdt_amt <> n.crdt_amt
        or o.final_jud_appl_tm <> n.final_jud_appl_tm
        or o.final_jud_appl_dt <> n.final_jud_appl_dt
        or o.score_val <> n.score_val
        or o.crdtc_que_situ_cd <> n.crdtc_que_situ_cd
        or o.final_jud_advise_sucs_flg <> n.final_jud_advise_sucs_flg
        or o.distr_advise_sucs_flg <> n.distr_advise_sucs_flg
        or o.refuse_rs_descb <> n.refuse_rs_descb
        or o.final_jud_apv_lmt <> n.final_jud_apv_lmt
        or o.cust_id <> n.cust_id
        or o.dtl_addr <> n.dtl_addr
        or o.work_char_cd <> n.work_char_cd
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.mobile_no <> n.mobile_no
        or o.apv_end_tm <> n.apv_end_tm
        or o.blip_doc_flg <> n.blip_doc_flg
        or o.inc_fin_brch_cust_mgr_id <> n.inc_fin_brch_cust_mgr_id
        or o.brwer_is_actl_ctrler_flg <> n.brwer_is_actl_ctrler_flg
        or o.cust_appl_amt <> n.cust_appl_amt
        or o.hxb_rela_ps_flg <> n.hxb_rela_ps_flg
        or o.main_brwer_amt_over_flg <> n.main_brwer_amt_over_flg
        or o.main_brwer_wif_amt_over_flg <> n.main_brwer_wif_amt_over_flg
        or o.borw_cont_id <> n.borw_cont_id
        or o.col_id <> n.col_id
        or o.loan_type_cd <> n.loan_type_cd
        or o.lmt_cont_crdt_appl_flow_num <> n.lmt_cont_crdt_appl_flow_num
        or o.cont_type_cd <> n.cont_type_cd
        or o.onl_flg <> n.onl_flg
        or o.onl_conti_loan_mode_flg <> n.onl_conti_loan_mode_flg
        or o.conti_loan_begin_dt <> n.conti_loan_begin_dt
        or o.conti_loan_exp_dt <> n.conti_loan_exp_dt
        or o.lmt_cont_id <> n.lmt_cont_id
        or o.have_init_loan_flg <> n.have_init_loan_flg
        or o.obank_estate_mtg_flg <> n.obank_estate_mtg_flg
        or o.init_dubil_id <> n.init_dubil_id
        or o.init_cont_id <> n.init_cont_id
        or o.init_dubil_amt <> n.init_dubil_amt
        or o.init_dubil_bal <> n.init_dubil_bal
        or o.init_mtg_bank_name <> n.init_mtg_bank_name
        or o.init_mtg_bank_brch_name <> n.init_mtg_bank_brch_name
        or o.init_loan_circl_flg <> n.init_loan_circl_flg
        or o.init_house_loan_amt <> n.init_house_loan_amt
        or o.init_house_loan_bal <> n.init_house_loan_bal
        or o.init_loan_surp_tenor <> n.init_loan_surp_tenor
        or o.init_estate_loan_type_cd <> n.init_estate_loan_type_cd
        or o.init_house_lon_other_remark <> n.init_house_lon_other_remark
        or o.loan_begin_dt <> n.loan_begin_dt
        or o.loan_exp_dt <> n.loan_exp_dt
        or o.mtg_estate_loan_bal <> n.mtg_estate_loan_bal
        or o.bank_org_flg <> n.bank_org_flg
        or o.in_lon_bank_name <> n.in_lon_bank_name
        or o.villa_type <> n.villa_type
        or o.dir_position <> n.dir_position
        or o.row_num <> n.row_num
        or o.rg_area <> n.rg_area
        or o.present_area <> n.present_area
        or o.estim_val <> n.estim_val
        or o.land_char_cd <> n.land_char_cd
        or o.land_char_other_comnt <> n.land_char_other_comnt
        or o.prep_repl_opering_loan_bal <> n.prep_repl_opering_loan_bal
        or o.brwer_share_ratio <> n.brwer_share_ratio
        or o.debit_ps_share_ratio <> n.debit_ps_share_ratio
        or o.cust_mgr_belong_brch_org_id <> n.cust_mgr_belong_brch_org_id
        or o.risk_level_cd <> n.risk_level_cd
        or o.finc_lot <> n.finc_lot
        or o.finc_nv <> n.finc_nv
        or o.finc_pric <> n.finc_pric
        or o.warn_info <> n.warn_info
        or o.tax_flg <> n.tax_flg
        or o.tax_type_cd <> n.tax_type_cd
        or o.tax_bur_auth_flow_num <> n.tax_bur_auth_flow_num
        or o.tax_num <> n.tax_num
        or o.obtain_emply_situ_cd <> n.obtain_emply_situ_cd
        or o.corp_anl_inco <> n.corp_anl_inco
        or o.pay_tax_anl_inco <> n.pay_tax_anl_inco
        or o.at_mon_inco <> n.at_mon_inco
        or o.farm_flg <> n.farm_flg
        or o.dir_line_kins_name <> n.dir_line_kins_name
        or o.dir_line_kins_phone <> n.dir_line_kins_phone
        or o.emerg_contact_name <> n.emerg_contact_name
        or o.emerg_contact_tel <> n.emerg_contact_tel
        or o.soci_secu_conti_mons <> n.soci_secu_conti_mons
        or o.provi_fund_conti_deposite_mons <> n.provi_fund_conti_deposite_mons
        or o.corp_lp_cert_no <> n.corp_lp_cert_no
        or o.corp_equip_qtty <> n.corp_equip_qtty
        or o.corp_equip_asset_tot_val <> n.corp_equip_asset_tot_val
        or o.corp_fix_asset_loan_bal <> n.corp_fix_asset_loan_bal
        or o.corp_equip_fin_rent_loan_bal <> n.corp_equip_fin_rent_loan_bal
        or o.corp_curt_cap_loan_bal <> n.corp_curt_cap_loan_bal
        or o.acrs_rg_mang_flg <> n.acrs_rg_mang_flg
        or o.rpr_addr <> n.rpr_addr
        or o.rpr_char_cd <> n.rpr_char_cd
        or o.rpr_addr_site_cd <> n.rpr_addr_site_cd
        or o.corp_addr_site_cd <> n.corp_addr_site_cd
        or o.work_tel <> n.work_tel
        or o.have_car_flg <> n.have_car_flg
        or o.xcd_loan_tenor <> n.xcd_loan_tenor
        or o.xcd_lon_create_sucs_flg <> n.xcd_lon_create_sucs_flg
        or o.licen_no <> n.licen_no
        or o.drv_lics_issue_dt <> n.drv_lics_issue_dt
        or o.car_single_price_inv <> n.car_single_price_inv
        or o.blip_matrl_auth_dt <> n.blip_matrl_auth_dt
        or o.que_appl_type_cd <> n.que_appl_type_cd
        or o.auth_way_cd <> n.auth_way_cd
        or o.biome_trics <> n.biome_trics
        or o.auth_start_dt <> n.auth_start_dt
        or o.auth_end_dt <> n.auth_end_dt
        or o.seller_recvbl_acct_id <> n.seller_recvbl_acct_id
        or o.seller_corp_name <> n.seller_corp_name
        or o.face_recn_score_val <> n.face_recn_score_val
        or o.white_list_cust_flg <> n.white_list_cust_flg
        or o.white_list_cust_id <> n.white_list_cust_id
        or o.white_list_cust_cert_no <> n.white_list_cust_cert_no
        or o.cust_mgr_belong_org_id <> n.cust_mgr_belong_org_id
        or o.appl_amt <> n.appl_amt
        or o.crdt_mode_cd <> n.crdt_mode_cd
        or o.risk_cust_flg <> n.risk_cust_flg
        or o.cust_crdt_level_cd <> n.cust_crdt_level_cd
        or o.manu_apv_flg <> n.manu_apv_flg
        or o.pre_final_jud_flg <> n.pre_final_jud_flg
        or o.next_acct_check_opinion <> n.next_acct_check_opinion
        or o.qlty_check_opinion <> n.qlty_check_opinion
        or o.qlty_check_sugst_amt <> n.qlty_check_sugst_amt
        or o.qlty_check_sugst_tenor <> n.qlty_check_sugst_tenor
        or o.face_opinion <> n.face_opinion
        or o.final_jud_apv_status_cd <> n.final_jud_apv_status_cd
        or o.hxzd_mode_cd <> n.hxzd_mode_cd
        or o.choice_addit_eqty_flg <> n.choice_addit_eqty_flg
        or o.add_co_brwer_flg <> n.add_co_brwer_flg
        or o.ms_req_flow_num <> n.ms_req_flow_num
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,appl_flow_num -- 申请流水号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,belong_brch_id -- 所属分行编号
    ,access_chn_id -- 接入渠道编号
    ,chn_id -- 渠道编号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,apv_opinion -- 审批意见
    ,apv_concus -- 审批结论
    ,main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,main_debit_ps_cert_id -- 主借人证件编号
    ,gender_cd -- 性别代码
    ,issue_org -- 证件签发机关名称
    ,issue_cty_cd -- 签发国家
    ,issue_dt -- 签发日期
    ,exp_dt -- 到期日期
    ,ghb_emply_flg -- 本行员工标志
    ,other_housing_flg -- 其他住房标志
    ,estate_qtty -- 房产数量
    ,repay_src_cd -- 还款来源代码
    ,spouse_co_ownr_flg -- 配偶共有人标志
    ,spouse_rela_ps_flg -- 配偶关联人标志
    ,mang_type_cd -- 经营类型代码
    ,mercht_name -- 商户名称
    ,mang_site_type_cd -- 经营场所类型代码
    ,mang_site -- 经营场所
    ,oper_name -- 经营者名称
    ,actl_ctrler_name -- 实际控制人名称
    ,mang_range -- 经营范围
    ,corp_name -- 企业名称
    ,unify_soci_crdt_id -- 统一社会信用编号
    ,orgnz_cd -- 组织机构代码
    ,corp_lp_name -- 企业法人姓名
    ,brwer_idti_cd -- 借款人身份代码
    ,rgst_addr -- 注册地址
    ,rgst_cap -- 注册资本
    ,rgst_dt -- 注册日期
    ,corp_type_cd -- 企业类型代码
    ,bus_begin_dt -- 营业起始日期
    ,bus_exp_dt -- 营业到期日期
    ,lp_obtain_emply_years -- 法人从业年限
    ,lics_name -- 许可证名称
    ,lics_id -- 许可证编号
    ,mang_years -- 经营年限
    ,cust_mgr_opinion_amt -- 客户经理意见金额
    ,cust_mgr_opinion_tenor -- 客户经理意见期限
    ,recmd_type_cd -- 推荐类型代码
    ,recmd_agent_name -- 推荐中介名称
    ,crdt_amt -- 授信金额
    ,final_jud_appl_tm -- 终审申请时间
    ,final_jud_appl_dt -- 终审申请日期
    ,score_val -- 评分分值
    ,crdtc_que_situ_cd -- 征信查询情况代码
    ,final_jud_advise_sucs_flg -- 终审通知成功标志
    ,distr_advise_sucs_flg -- 放款通知成功标志
    ,refuse_rs_descb -- 拒绝原因描述
    ,final_jud_apv_lmt -- 终审审批额度
    ,cust_id -- 客户编号
    ,dtl_addr -- 详细地址
    ,work_char_cd -- 工作性质代码
    ,mgmt_org_id -- 管理机构编号
    ,mobile_no -- 手机号码
    ,apv_end_tm -- 审批结束时间
    ,blip_doc_flg -- 有影像文件标志
    ,inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,cust_appl_amt -- 客户申请金额
    ,hxb_rela_ps_flg -- 我行关联人标志
    ,main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,borw_cont_id -- 借款合同编号
    ,col_id -- 押品编号
    ,loan_type_cd -- 贷款类型代码
    ,lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,cont_type_cd -- 合同类型代码
    ,onl_flg -- 线上标志
    ,onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,conti_loan_begin_dt -- 续贷起始日期
    ,conti_loan_exp_dt -- 续贷到期日期
    ,lmt_cont_id -- 额度合同编号
    ,have_init_loan_flg -- 有原贷款标志
    ,obank_estate_mtg_flg -- 他行在押房产标志
    ,init_dubil_id -- 原借据编号
    ,init_cont_id -- 原合同编号
    ,init_dubil_amt -- 原借据金额
    ,init_dubil_bal -- 原借据余额
    ,init_mtg_bank_name -- 原抵押银行名称
    ,init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,init_loan_circl_flg -- 原贷款循环标志
    ,init_house_loan_amt -- 原房屋贷款金额
    ,init_house_loan_bal -- 原房屋贷款余额
    ,init_loan_surp_tenor -- 原贷款剩余期限
    ,init_estate_loan_type_cd -- 原房产贷款类型代码
    ,init_house_lon_other_remark -- 原房贷其他备注
    ,loan_begin_dt -- 贷款起始日期
    ,loan_exp_dt -- 贷款到期日期
    ,mtg_estate_loan_bal -- 在押房产贷款余额
    ,bank_org_flg -- 银行机构标志
    ,in_lon_bank_name -- 在贷银行名称
    ,villa_type -- 别墅类型
    ,dir_position -- 户型位置
    ,row_num -- 联排数
    ,rg_area -- 花园面积
    ,present_area -- 赠送面积
    ,estim_val -- 评估价值
    ,land_char_cd -- 土地性质代码
    ,land_char_other_comnt -- 土地性质其他说明
    ,prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,brwer_share_ratio -- 借款人持股比例
    ,debit_ps_share_ratio -- 共借人持股比例
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,risk_level_cd -- 风险等级代码
    ,finc_lot -- 理财份额
    ,finc_nv -- 理财净值
    ,finc_pric -- 理财本金
    ,warn_info -- 预警信息
    ,tax_flg -- 涉税标志
    ,tax_type_cd -- 涉税类型代码
    ,tax_bur_auth_flow_num -- 税局授权流水号
    ,tax_num -- 纳税人识别号
    ,obtain_emply_situ_cd -- 从业状况代码
    ,corp_anl_inco -- 企业年收入
    ,pay_tax_anl_inco -- 纳税年收入
    ,at_mon_inco -- 税后月收入
    ,farm_flg -- 农户标志
    ,dir_line_kins_name -- 直系亲属姓名
    ,dir_line_kins_phone -- 直系亲属联系电话
    ,emerg_contact_name -- 紧急联系人姓名
    ,emerg_contact_tel -- 紧急联系人电话
    ,soci_secu_conti_mons -- 社保连续缴存月数
    ,provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,corp_lp_cert_no -- 企业法人证件号码
    ,corp_equip_qtty -- 企业设备数量
    ,corp_equip_asset_tot_val -- 企业设备资产总值
    ,corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,acrs_rg_mang_flg -- 跨区域经营标志
    ,rpr_addr -- 户籍地址
    ,rpr_char_cd -- 户籍性质代码
    ,rpr_addr_site_cd -- 户籍地址所在地区代码
    ,corp_addr_site_cd -- 单位地址所在地区代码
    ,work_tel -- 单位电话
    ,have_car_flg -- 有汽车标志
    ,xcd_loan_tenor -- 兴车贷贷款期限
    ,xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,licen_no -- 车牌号码
    ,drv_lics_issue_dt -- 行驶证发证日期
    ,car_single_price_inv -- 汽车裸车价格发票
    ,blip_matrl_auth_dt -- 影像资料授权日期
    ,que_appl_type_cd -- 查询申请类型代码
    ,auth_way_cd -- 授权方式代码
    ,biome_trics -- 生物识别技术代码
    ,auth_start_dt -- 授权开始日期
    ,auth_end_dt -- 授权结束日期
    ,seller_recvbl_acct_id -- 经销商收款账户编号
    ,seller_corp_name -- 经销商公司名称
    ,face_recn_score_val -- 人脸识别分值
    ,white_list_cust_flg -- 白户标志
    ,white_list_cust_id -- 白名单客户编号
    ,white_list_cust_cert_no -- 白名单客户证件号码
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,appl_amt -- 申请金额
    ,crdt_mode_cd -- 授信模式代码
    ,risk_cust_flg -- 风险客户标志
    ,cust_crdt_level_cd -- 客户信用等级代码
    ,manu_apv_flg -- 人工审批标志
    ,pre_final_jud_flg -- 预终审标志
    ,next_acct_check_opinion -- 下户核验意见
    ,qlty_check_opinion -- 质检岗意见
    ,qlty_check_sugst_amt -- 质检岗建议金额
    ,qlty_check_sugst_tenor -- 质检岗建议期限
    ,face_opinion -- 面谈意见
    ,final_jud_apv_status_cd -- 终审审批状态代码
    ,hxzd_mode_cd -- 华兴智贷模式代码
    ,choice_addit_eqty_flg -- 选择附加权益标志
    ,add_co_brwer_flg -- 新增共同借款人标志
    ,ms_req_flow_num -- 庙算请求流水号
    ,final_update_dt -- 最后更新日期
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
    ,o.prod_id -- 产品编号
    ,o.prod_name -- 产品名称
    ,o.belong_brch_id -- 所属分行编号
    ,o.access_chn_id -- 接入渠道编号
    ,o.chn_id -- 渠道编号
    ,o.crdt_appl_flow_num -- 信贷申请流水号
    ,o.apv_opinion -- 审批意见
    ,o.apv_concus -- 审批结论
    ,o.main_debit_ps_cert_type_cd -- 主借人证件类型代码
    ,o.main_debit_ps_cert_id -- 主借人证件编号
    ,o.gender_cd -- 性别代码
    ,o.issue_org -- 证件签发机关名称
    ,o.issue_cty_cd -- 签发国家
    ,o.issue_dt -- 签发日期
    ,o.exp_dt -- 到期日期
    ,o.ghb_emply_flg -- 本行员工标志
    ,o.other_housing_flg -- 其他住房标志
    ,o.estate_qtty -- 房产数量
    ,o.repay_src_cd -- 还款来源代码
    ,o.spouse_co_ownr_flg -- 配偶共有人标志
    ,o.spouse_rela_ps_flg -- 配偶关联人标志
    ,o.mang_type_cd -- 经营类型代码
    ,o.mercht_name -- 商户名称
    ,o.mang_site_type_cd -- 经营场所类型代码
    ,o.mang_site -- 经营场所
    ,o.oper_name -- 经营者名称
    ,o.actl_ctrler_name -- 实际控制人名称
    ,o.mang_range -- 经营范围
    ,o.corp_name -- 企业名称
    ,o.unify_soci_crdt_id -- 统一社会信用编号
    ,o.orgnz_cd -- 组织机构代码
    ,o.corp_lp_name -- 企业法人姓名
    ,o.brwer_idti_cd -- 借款人身份代码
    ,o.rgst_addr -- 注册地址
    ,o.rgst_cap -- 注册资本
    ,o.rgst_dt -- 注册日期
    ,o.corp_type_cd -- 企业类型代码
    ,o.bus_begin_dt -- 营业起始日期
    ,o.bus_exp_dt -- 营业到期日期
    ,o.lp_obtain_emply_years -- 法人从业年限
    ,o.lics_name -- 许可证名称
    ,o.lics_id -- 许可证编号
    ,o.mang_years -- 经营年限
    ,o.cust_mgr_opinion_amt -- 客户经理意见金额
    ,o.cust_mgr_opinion_tenor -- 客户经理意见期限
    ,o.recmd_type_cd -- 推荐类型代码
    ,o.recmd_agent_name -- 推荐中介名称
    ,o.crdt_amt -- 授信金额
    ,o.final_jud_appl_tm -- 终审申请时间
    ,o.final_jud_appl_dt -- 终审申请日期
    ,o.score_val -- 评分分值
    ,o.crdtc_que_situ_cd -- 征信查询情况代码
    ,o.final_jud_advise_sucs_flg -- 终审通知成功标志
    ,o.distr_advise_sucs_flg -- 放款通知成功标志
    ,o.refuse_rs_descb -- 拒绝原因描述
    ,o.final_jud_apv_lmt -- 终审审批额度
    ,o.cust_id -- 客户编号
    ,o.dtl_addr -- 详细地址
    ,o.work_char_cd -- 工作性质代码
    ,o.mgmt_org_id -- 管理机构编号
    ,o.mobile_no -- 手机号码
    ,o.apv_end_tm -- 审批结束时间
    ,o.blip_doc_flg -- 有影像文件标志
    ,o.inc_fin_brch_cust_mgr_id -- 普惠金融分行客户经理编号
    ,o.brwer_is_actl_ctrler_flg -- 借款人为实控人标志
    ,o.cust_appl_amt -- 客户申请金额
    ,o.hxb_rela_ps_flg -- 我行关联人标志
    ,o.main_brwer_amt_over_flg -- 主借款人触碰征信逾期金额过大标志
    ,o.main_brwer_wif_amt_over_flg -- 主借款人配偶触碰征信逾期金额过大标志
    ,o.borw_cont_id -- 借款合同编号
    ,o.col_id -- 押品编号
    ,o.loan_type_cd -- 贷款类型代码
    ,o.lmt_cont_crdt_appl_flow_num -- 额度合同信贷申请流水号
    ,o.cont_type_cd -- 合同类型代码
    ,o.onl_flg -- 线上标志
    ,o.onl_conti_loan_mode_flg -- 线上续贷模式标志
    ,o.conti_loan_begin_dt -- 续贷起始日期
    ,o.conti_loan_exp_dt -- 续贷到期日期
    ,o.lmt_cont_id -- 额度合同编号
    ,o.have_init_loan_flg -- 有原贷款标志
    ,o.obank_estate_mtg_flg -- 他行在押房产标志
    ,o.init_dubil_id -- 原借据编号
    ,o.init_cont_id -- 原合同编号
    ,o.init_dubil_amt -- 原借据金额
    ,o.init_dubil_bal -- 原借据余额
    ,o.init_mtg_bank_name -- 原抵押银行名称
    ,o.init_mtg_bank_brch_name -- 原抵押银行分行名称
    ,o.init_loan_circl_flg -- 原贷款循环标志
    ,o.init_house_loan_amt -- 原房屋贷款金额
    ,o.init_house_loan_bal -- 原房屋贷款余额
    ,o.init_loan_surp_tenor -- 原贷款剩余期限
    ,o.init_estate_loan_type_cd -- 原房产贷款类型代码
    ,o.init_house_lon_other_remark -- 原房贷其他备注
    ,o.loan_begin_dt -- 贷款起始日期
    ,o.loan_exp_dt -- 贷款到期日期
    ,o.mtg_estate_loan_bal -- 在押房产贷款余额
    ,o.bank_org_flg -- 银行机构标志
    ,o.in_lon_bank_name -- 在贷银行名称
    ,o.villa_type -- 别墅类型
    ,o.dir_position -- 户型位置
    ,o.row_num -- 联排数
    ,o.rg_area -- 花园面积
    ,o.present_area -- 赠送面积
    ,o.estim_val -- 评估价值
    ,o.land_char_cd -- 土地性质代码
    ,o.land_char_other_comnt -- 土地性质其他说明
    ,o.prep_repl_opering_loan_bal -- 拟置换经营性贷款余额
    ,o.brwer_share_ratio -- 借款人持股比例
    ,o.debit_ps_share_ratio -- 共借人持股比例
    ,o.cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,o.risk_level_cd -- 风险等级代码
    ,o.finc_lot -- 理财份额
    ,o.finc_nv -- 理财净值
    ,o.finc_pric -- 理财本金
    ,o.warn_info -- 预警信息
    ,o.tax_flg -- 涉税标志
    ,o.tax_type_cd -- 涉税类型代码
    ,o.tax_bur_auth_flow_num -- 税局授权流水号
    ,o.tax_num -- 纳税人识别号
    ,o.obtain_emply_situ_cd -- 从业状况代码
    ,o.corp_anl_inco -- 企业年收入
    ,o.pay_tax_anl_inco -- 纳税年收入
    ,o.at_mon_inco -- 税后月收入
    ,o.farm_flg -- 农户标志
    ,o.dir_line_kins_name -- 直系亲属姓名
    ,o.dir_line_kins_phone -- 直系亲属联系电话
    ,o.emerg_contact_name -- 紧急联系人姓名
    ,o.emerg_contact_tel -- 紧急联系人电话
    ,o.soci_secu_conti_mons -- 社保连续缴存月数
    ,o.provi_fund_conti_deposite_mons -- 公积金连续缴存月数
    ,o.corp_lp_cert_no -- 企业法人证件号码
    ,o.corp_equip_qtty -- 企业设备数量
    ,o.corp_equip_asset_tot_val -- 企业设备资产总值
    ,o.corp_fix_asset_loan_bal -- 企业固定资产贷款余额
    ,o.corp_equip_fin_rent_loan_bal -- 企业设备融资租赁贷款余额
    ,o.corp_curt_cap_loan_bal -- 企业流动资金贷款余额
    ,o.acrs_rg_mang_flg -- 跨区域经营标志
    ,o.rpr_addr -- 户籍地址
    ,o.rpr_char_cd -- 户籍性质代码
    ,o.rpr_addr_site_cd -- 户籍地址所在地区代码
    ,o.corp_addr_site_cd -- 单位地址所在地区代码
    ,o.work_tel -- 单位电话
    ,o.have_car_flg -- 有汽车标志
    ,o.xcd_loan_tenor -- 兴车贷贷款期限
    ,o.xcd_lon_create_sucs_flg -- 兴车贷同贷书生成成功标志
    ,o.licen_no -- 车牌号码
    ,o.drv_lics_issue_dt -- 行驶证发证日期
    ,o.car_single_price_inv -- 汽车裸车价格发票
    ,o.blip_matrl_auth_dt -- 影像资料授权日期
    ,o.que_appl_type_cd -- 查询申请类型代码
    ,o.auth_way_cd -- 授权方式代码
    ,o.biome_trics -- 生物识别技术代码
    ,o.auth_start_dt -- 授权开始日期
    ,o.auth_end_dt -- 授权结束日期
    ,o.seller_recvbl_acct_id -- 经销商收款账户编号
    ,o.seller_corp_name -- 经销商公司名称
    ,o.face_recn_score_val -- 人脸识别分值
    ,o.white_list_cust_flg -- 白户标志
    ,o.white_list_cust_id -- 白名单客户编号
    ,o.white_list_cust_cert_no -- 白名单客户证件号码
    ,o.cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,o.appl_amt -- 申请金额
    ,o.crdt_mode_cd -- 授信模式代码
    ,o.risk_cust_flg -- 风险客户标志
    ,o.cust_crdt_level_cd -- 客户信用等级代码
    ,o.manu_apv_flg -- 人工审批标志
    ,o.pre_final_jud_flg -- 预终审标志
    ,o.next_acct_check_opinion -- 下户核验意见
    ,o.qlty_check_opinion -- 质检岗意见
    ,o.qlty_check_sugst_amt -- 质检岗建议金额
    ,o.qlty_check_sugst_tenor -- 质检岗建议期限
    ,o.face_opinion -- 面谈意见
    ,o.final_jud_apv_status_cd -- 终审审批状态代码
    ,o.hxzd_mode_cd -- 华兴智贷模式代码
    ,o.choice_addit_eqty_flg -- 选择附加权益标志
    ,o.add_co_brwer_flg -- 新增共同借款人标志
    ,o.ms_req_flow_num -- 庙算请求流水号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_loan_appl_fkd_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_fkd_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_fkd_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_fkd_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_fkd_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_fkd_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
