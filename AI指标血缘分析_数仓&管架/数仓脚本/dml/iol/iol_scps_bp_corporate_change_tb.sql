/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_corporate_change_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_corporate_change_tb_ex purge;
alter table ${iol_schema}.scps_bp_corporate_change_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scps_bp_corporate_change_tb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scps_bp_corporate_change_tb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_corporate_change_tb where 0=1;

insert /*+ append */ into ${iol_schema}.scps_bp_corporate_change_tb_ex(
    task_id -- 任务号
    ,glob_seq_num -- 全局流水号
    ,acct_open_date -- 客户开户日期
    ,organ_no -- 发起机构号
    ,user_no -- 发起柜员
    ,user_enable -- 开户状态（0处理中，1记账完成）
    ,ea_phone -- 联系电话
    ,ea_register_address -- 注册地址
    ,ea_post_code -- 邮编
    ,ea_trade_type -- 所属行业类型
    ,ea_register_fund -- 注册资本
    ,ea_fund_quality -- 资金性质
    ,ea_operate_scope -- 经营范围
    ,ea_tempacctdt_end -- 临时户有效日期至
    ,ea_legal_rep -- 法定代表人或单位负责人姓名
    ,ea_upcrna -- 上级法人或主管单位名称
    ,ea_company_approve_no -- 上级法人或主管基本存款账户开户许可证核准号
    ,ea_compay_fin_name -- 上级法人/主管姓名
    ,ea_f_company_fin_paptype -- 上级法人/主管证件种类
    ,ea_f_company_fin_papno -- 上级法人/主管证件号码
    ,ea_deposit_type -- 存款人类别
    ,ea_attor_oprno -- 客户经理编号
    ,ea_papers_type2 -- 第二证明文件类型
    ,ea_tax_certno -- 国税登记证编号/地税登记证编号
    ,ea_company_fin_papno -- 法人/负责人证件号码
    ,ea_company_fin_paptype -- 法人/负责人证件种类
    ,ea_legal_iddt -- 法人/负责人证件生效日期
    ,ea_deposit_name -- 存款人名称
    ,ea_acct_name -- 账户名称
    ,ea_certcode -- 法人/负责人开户许可证核准号/基本存款账户编号
    ,ea_pre_seqno -- 预受理编号
    ,ea_perpers_inval_type1 -- 第一证明文件类型
    ,ea_perpers_inval_code1 -- 第一证明文件编号
    ,ea_perpers_inval_date1 -- 第一证明文件到期日
    ,ea_papers_type -- 第一证件类型
    ,ea_compay_organiz_code -- 上级法人或主管单位证明文件编号
    ,ea_country -- 国家和地区
    ,ea_corp_org_type -- 机构类别
    ,ea_tax_resident -- 税收居民身份
    ,ea_acct_char -- 账户性质
    ,ea_perpers_inval_code2 -- 第二证明文件编号
    ,ea_perpers_inval_date2 -- 第二证明文件到期日
    ,ei_year_limit -- 年累计限额
    ,ei_business_flow -- 业务流程设置
    ,ei_sign_mobile -- 签约手机号码
    ,ei_seal_mode -- 银企验印方式（对账单加盖印章种类）
    ,ei_mail_address -- 银企邮寄地址
    ,ei_bczipcd -- 银企邮编
    ,ei_linkman -- 银企联系人
    ,ei_linktel -- 银企联系电话
    ,ei_sendmode -- 银企对账方式
    ,ei_acccycle -- 银企对账周期
    ,ei_day_limit -- 日累计限额
    ,ei_day_times -- 日累计笔数
    ,ei_application -- 基本服务申请
    ,ei_call_type -- 查证类型
    ,ei_accredit_legal_name -- 查证法定代表人(单位负责人)姓名
    ,ei_accredit_legal_tel -- 查证法定代表人/单位负责人手机号码
    ,ei_accredit_legal_phone -- 查证法定代表人/单位负责人固定电话
    ,ei_principal_checkorder -- 查证人顺序
    ,ei_principal_funds_check -- 资金查证人（至少两名）
    ,ei_mainfin_contect_name -- 财务负责人姓名
    ,ei_mainfin_contect_tel -- 财务负责人手机号码
    ,ei_mainfin_contect_phone -- 财务负责人固定电话
    ,ei_fin_contect_checkorder -- 查证人顺序
    ,ei_fin_contect_funds_check -- 资金查证人（至少两名）
    ,ei_fin_contect_name1 -- 财务人员1姓名
    ,ei_fin_contect_tel1 -- 财务人员1手机号码
    ,ei_fin_contect_phone1 -- 财务人员1固定电话
    ,ei_chrg_check1_order -- 查证人顺序
    ,ei_chrg_funds_check1 -- 资金查证人（至少两名）
    ,ei_fin_contect_name2 -- 财务人员2姓名
    ,ei_fin_contect_tel2 -- 财务人员2手机号码
    ,ei_fin_contect_phone2 -- 财务人员2固定电话
    ,ei_chrg_check2_order -- 查证人顺序
    ,ei_chrg_funds_check2 -- 资金查证人（至少两名）
    ,em_organize_name -- 【机构】机构名称
    ,em_corp_corporgtype -- 【机构】类别
    ,em_tax_resident_type -- 【机构】税收居民身份类型
    ,em_taxarea_taxno1 -- 【机构】税收居民国地区与纳税人识别号①
    ,em_taxarea_taxno2 -- 【机构】税收居民国地区与纳税人识别号②
    ,em_taxarea_taxno3 -- 【机构】税收居民国地区与纳税人识别号③
    ,em_per_tax_null_reason1 -- 【机构】不能提供识别号的原因①
    ,em_per_tax_null_reason2 -- 【机构】不能提供识别号的原因②
    ,em_per_tax_null_reason3 -- 【机构】不能提供识别号的原因③
    ,em_organize_address -- 【机构】机构地址
    ,em_tax_english_name -- 【机构】英文名称
    ,eb_benfi_company_type -- 受益所有人企业所属类别
    ,eb_benfi_type -- 受益所有人类型
    ,eb_benfi_name1 -- 受益所有人1姓名
    ,eb_benfi_position1 -- 受益所有人1职务
    ,eb_benfi_certtype1 -- 受益所有人1证件类型
    ,eb_benfi_certno1 -- 受益所有人1证件号码
    ,eb_benfi_certthrudate1 -- 证件生效日期
    ,eb_benfi_address1 -- 受益所有人1联系地址
    ,eb_benfi_name2 -- 受益所有人2姓名
    ,eb_benfi_position2 -- 受益所有人2职务
    ,eb_benfi_certtype2 -- 受益所有人2证件类型
    ,eb_benfi_certno2 -- 受益所有人2证件号码
    ,eb_benfi_certthrudate2 -- 证件生效日期
    ,eb_benfi_address2 -- 受益所有人2联系地址
    ,eb_benfi_name3 -- 受益所有人3姓名
    ,eb_benfi_position3 -- 受益所有人3职务
    ,eb_benfi_certtype3 -- 受益所有人3证件类型
    ,eb_benfi_certno3 -- 受益所有人3证件号码
    ,eb_benfi_certthrudate3 -- 证件生效日期
    ,eb_benfi_address3 -- 受益所有人3联系地址
    ,eb_benfi_name4 -- 受益所有人4姓名
    ,eb_benfi_position4 -- 受益所有人4职务
    ,eb_benfi_certtype4 -- 受益所有人4证件类型
    ,eb_benfi_certno4 -- 受益所有人4证件号码
    ,eb_benfi_certthrudate4 -- 证件生效日期
    ,eb_benfi_address4 -- 受益所有人4联系地址
    ,eb_benfi_name5 -- 受益所有人5姓名
    ,eb_benfi_position5 -- 受益所有人5职务
    ,eb_benfi_certtype5 -- 受益所有人5证件类型
    ,eb_benfi_certno5 -- 受益所有人5证件号码
    ,eb_benfi_certthrudate5 -- 证件生效日期
    ,eb_benfi_address5 -- 受益所有人5联系地址
    ,eb_control_name -- 股东名称
    ,eb_control_paperno -- 控股股东/实际控制人证件号码
    ,eb_control_paperstype -- 控股股东/实际控制人证件类型
    ,eb_same_benfi -- 同受益所有人
    ,eb_controller -- 控制人/控股股东
    ,eb_control_paperdt -- 控股股东/实际控制人有效期
    ,er_cop_name -- 关联企业名称
    ,er_incidence_relation -- 关联关系类型
    ,er_principal_name -- 关联企业法定代表人名称
    ,er_organiz_code -- 关联企业组织机构代码
    ,es_main_account -- 主账号
    ,ct_croler1_name -- 【控制人①】姓名
    ,ct_croler1_taxarea_nober1 -- 【控制人①】税收居民国（地区）和纳税人识别号①
    ,ct_croler1_taxnullreason1 -- 【控制人①】不能提供识别号的原因①
    ,ct_croler1_type -- 【控制人①】控制人类型
    ,ct_croler1_englishname -- 【控制人①】姓与名（英文或拼音）
    ,ct_croler1_tax_resident -- 【控制人①】税收居民身份
    ,ct_croler1_address -- 【控制人①】现居地址
    ,ct_croler1_taxarea_nober2 -- 【控制人①】税收居民国（地区）和纳税人识别号②
    ,ct_croler1_taxarea_nober3 -- 【控制人①】税收居民国（地区）和纳税人识别号③
    ,ct_croler1_birthday -- 【控制人①】出生日期
    ,ct_croler1_taxnullreason2 -- 【控制人①】不能提供识别号的原因②
    ,ct_croler1_taxnullreason3 -- 【控制人①】不能提供识别号的原因③
    ,ct_croler_birth_place -- 【控制人①】出生地址
    ,ct_croler2_name -- 【控制人②】姓名
    ,ct_croler2_englishname -- 【控制人②】姓与名（英文或拼音）
    ,ct_croler2_type -- 【控制人②】控制人类型
    ,ct_croler2_tax_resident -- 【控制人②】税收居民身份
    ,ct_croler2_birthday -- 【控制人②】出生日期
    ,ct_croler2_address -- 【控制人②】现居地址
    ,ct_croler2_taxarea_nober1 -- 【控制人②】税收居民国（地区）和纳税人识别号①
    ,ct_croler2_taxarea_nober2 -- 【控制人②】税收居民国（地区）和纳税人识别号②
    ,ct_croler2_taxarea_nober3 -- 【控制人②】税收居民国（地区）和纳税人识别号③
    ,ct_croler2_taxnullreason1 -- 【控制人②】不能提供识别号的原因①
    ,ct_croler2_taxnullreason2 -- 【控制人②】不能提供识别号的原因②
    ,ct_croler2_taxnullreason3 -- 【控制人②】不能提供识别号的原因③
    ,ct_croler2_birth_place -- 【控制人②】出生地址
    ,ct_croler3_name -- 【控制人③】姓名
    ,ct_croler3_englishname -- 【控制人③】姓与名（英文或拼音）
    ,ct_croler3_type -- 【控制人③】控制人类型
    ,ct_croler3_tax_resident -- 【控制人③】税收居民身份
    ,ct_croler3_birthday -- 【控制人③】出生日期
    ,ct_croler3_address -- 【控制人③】现居地址
    ,ct_croler3_taxarea_nober1 -- 【控制人③】税收居民国（地区）和纳税人识别号①
    ,ct_croler3_taxarea_nober2 -- 【控制人③】税收居民国（地区）和纳税人识别号②
    ,ct_croler3_taxarea_nober3 -- 【控制人③】税收居民国（地区）和纳税人识别号③
    ,ct_croler3_taxnullreason1 -- 【控制人③】不能提供识别号的原因①
    ,ct_croler3_taxnullreason2 -- 【控制人③】不能提供识别号的原因②
    ,ct_croler3_taxnullreason3 -- 【控制人③】不能提供识别号的原因③
    ,ct_croler3_birth_place -- 【控制人③】出生地址
    ,bq_trust_name1 -- 受委托人1姓名
    ,bq_trust_certtype1 -- 受委托人1证件种类
    ,bq_trust_certno1 -- 受委托人1证件号码
    ,bq_trust_name2 -- 受委托人2姓名
    ,bq_trust_certtype2 -- 受委托人2证件种类
    ,bq_trust_certno2 -- 受委托人2证件号码
    ,bq_accredit_name1 -- 被授权人1姓名
    ,bq_accredit_certtype1 -- 被授权人1证件种类
    ,bq_accredit_certno1 -- 被授权人1证件号码
    ,bq_accredit_name2 -- 被授权人2姓名
    ,bq_accredit_certtype2 -- 被授权人2证件种类
    ,bq_accredit_certno2 -- 被授权人2证件号码
    ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,acct_no -- 账号
    ,visit_service -- 上门服务(0:否 1：是)
    ,check_type -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,account_active_flag -- 账户激活标志 1-已激活 2-激活失败 0-未激活
    ,if_public_seal -- 是否共用验印(1-是 0-否)
    ,if_seal -- 是否倒验(1-是 0-否)
    ,cust_no -- 客户编号
    ,cust_name -- 客户名称
    ,proxy_name -- 代理人姓名
    ,proxy_papers_type -- 代理人证件类型
    ,proxy_papers_number -- 代理人证件号码
    ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,acct_cancel_date -- 客户销户日期
    ,is_local_check -- 是否双异地(1-是 0-否)
    ,acct_open_channel -- 开户渠道
    ,charge_id -- 审核柜员
    ,is_upload_new_form -- 是否上传系统最新表单(0-否 1-是)
    ,doc_id -- 影像批次号
    ,is_check -- 是否核准（1-是 0-否，用于报备RPA）
    ,zone_cd -- 注册地区代码
    ,reg_cap_ccy -- 注册资金币种
    ,dirt_unt_lp_typ -- 上级法人或主管单位信息（1-法定代表人 2-单位负责人）
    ,rec_type -- 备案类型： 0本地备案1异地备案
    ,rpa_related_corp1 -- 关联企业名称_1
    ,rpa_related_corp2 -- 关联企业名称_2
    ,rpa_related_corp3 -- 关联企业名称_3
    ,rpa_related_corp4 -- 关联企业名称_4
    ,rpa_related_corp5 -- 关联企业名称_5
    ,rpa_related_corp6 -- 关联企业名称_6
    ,rpa_related_corp7 -- 关联企业名称_7
    ,rpa_related_corp8 -- 关联企业名称_8
    ,rpa_related_corp9 -- 关联企业名称_9
    ,rpa_related_corp10 -- 关联企业名称_10
    ,rpa_corper_name1 -- 1法定代表人名称
    ,rpa_corper_name2 -- 2法定代表人名称
    ,rpa_corper_name3 -- 3法定代表人名称
    ,rpa_corper_name4 -- 4法定代表人名称
    ,rpa_corper_name5 -- 5法定代表人名称
    ,rpa_corper_name6 -- 6法定代表人名称
    ,rpa_corper_name7 -- 7法定代表人名称
    ,rpa_corper_name8 -- 8法定代表人名称
    ,rpa_corper_name9 -- 9法定代表人名称
    ,rpa_corper_name10 -- 10法定代表人名称
    ,rpa_organze_code1 -- 组织机构代码_1
    ,rpa_organze_code2 -- 组织机构代码_2
    ,rpa_organze_code3 -- 组织机构代码_3
    ,rpa_organze_code4 -- 组织机构代码_4
    ,rpa_organze_code5 -- 组织机构代码_5
    ,rpa_organze_code6 -- 组织机构代码_6
    ,rpa_organze_code7 -- 组织机构代码_7
    ,rpa_organze_code8 -- 组织机构代码_8
    ,rpa_organze_code9 -- 组织机构代码_9
    ,rpa_organze_code10 -- 组织机构代码_10
    ,proxy_phone -- 交易代办人联系电话
    ,proxy_invaldt -- 代理人证件有效期
    ,is_proxy -- 是否代理（1-是，2-否）
    ,is_bs_flag -- 事后补扫是否完成,0-未完成，1-完成
    ,is_rpa_check -- 是否经过rpa核查（1-是，0-否）
    ,business_type -- 业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））
    ,found_date -- 成立日期（营业执照）
    ,change_date -- 变更时间
    ,change_content -- 变更内容
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    task_id -- 任务号
    ,glob_seq_num -- 全局流水号
    ,acct_open_date -- 客户开户日期
    ,organ_no -- 发起机构号
    ,user_no -- 发起柜员
    ,user_enable -- 开户状态（0处理中，1记账完成）
    ,ea_phone -- 联系电话
    ,ea_register_address -- 注册地址
    ,ea_post_code -- 邮编
    ,ea_trade_type -- 所属行业类型
    ,ea_register_fund -- 注册资本
    ,ea_fund_quality -- 资金性质
    ,ea_operate_scope -- 经营范围
    ,ea_tempacctdt_end -- 临时户有效日期至
    ,ea_legal_rep -- 法定代表人或单位负责人姓名
    ,ea_upcrna -- 上级法人或主管单位名称
    ,ea_company_approve_no -- 上级法人或主管基本存款账户开户许可证核准号
    ,ea_compay_fin_name -- 上级法人/主管姓名
    ,ea_f_company_fin_paptype -- 上级法人/主管证件种类
    ,ea_f_company_fin_papno -- 上级法人/主管证件号码
    ,ea_deposit_type -- 存款人类别
    ,ea_attor_oprno -- 客户经理编号
    ,ea_papers_type2 -- 第二证明文件类型
    ,ea_tax_certno -- 国税登记证编号/地税登记证编号
    ,ea_company_fin_papno -- 法人/负责人证件号码
    ,ea_company_fin_paptype -- 法人/负责人证件种类
    ,ea_legal_iddt -- 法人/负责人证件生效日期
    ,ea_deposit_name -- 存款人名称
    ,ea_acct_name -- 账户名称
    ,ea_certcode -- 法人/负责人开户许可证核准号/基本存款账户编号
    ,ea_pre_seqno -- 预受理编号
    ,ea_perpers_inval_type1 -- 第一证明文件类型
    ,ea_perpers_inval_code1 -- 第一证明文件编号
    ,ea_perpers_inval_date1 -- 第一证明文件到期日
    ,ea_papers_type -- 第一证件类型
    ,ea_compay_organiz_code -- 上级法人或主管单位证明文件编号
    ,ea_country -- 国家和地区
    ,ea_corp_org_type -- 机构类别
    ,ea_tax_resident -- 税收居民身份
    ,ea_acct_char -- 账户性质
    ,ea_perpers_inval_code2 -- 第二证明文件编号
    ,ea_perpers_inval_date2 -- 第二证明文件到期日
    ,ei_year_limit -- 年累计限额
    ,ei_business_flow -- 业务流程设置
    ,ei_sign_mobile -- 签约手机号码
    ,ei_seal_mode -- 银企验印方式（对账单加盖印章种类）
    ,ei_mail_address -- 银企邮寄地址
    ,ei_bczipcd -- 银企邮编
    ,ei_linkman -- 银企联系人
    ,ei_linktel -- 银企联系电话
    ,ei_sendmode -- 银企对账方式
    ,ei_acccycle -- 银企对账周期
    ,ei_day_limit -- 日累计限额
    ,ei_day_times -- 日累计笔数
    ,ei_application -- 基本服务申请
    ,ei_call_type -- 查证类型
    ,ei_accredit_legal_name -- 查证法定代表人(单位负责人)姓名
    ,ei_accredit_legal_tel -- 查证法定代表人/单位负责人手机号码
    ,ei_accredit_legal_phone -- 查证法定代表人/单位负责人固定电话
    ,ei_principal_checkorder -- 查证人顺序
    ,ei_principal_funds_check -- 资金查证人（至少两名）
    ,ei_mainfin_contect_name -- 财务负责人姓名
    ,ei_mainfin_contect_tel -- 财务负责人手机号码
    ,ei_mainfin_contect_phone -- 财务负责人固定电话
    ,ei_fin_contect_checkorder -- 查证人顺序
    ,ei_fin_contect_funds_check -- 资金查证人（至少两名）
    ,ei_fin_contect_name1 -- 财务人员1姓名
    ,ei_fin_contect_tel1 -- 财务人员1手机号码
    ,ei_fin_contect_phone1 -- 财务人员1固定电话
    ,ei_chrg_check1_order -- 查证人顺序
    ,ei_chrg_funds_check1 -- 资金查证人（至少两名）
    ,ei_fin_contect_name2 -- 财务人员2姓名
    ,ei_fin_contect_tel2 -- 财务人员2手机号码
    ,ei_fin_contect_phone2 -- 财务人员2固定电话
    ,ei_chrg_check2_order -- 查证人顺序
    ,ei_chrg_funds_check2 -- 资金查证人（至少两名）
    ,em_organize_name -- 【机构】机构名称
    ,em_corp_corporgtype -- 【机构】类别
    ,em_tax_resident_type -- 【机构】税收居民身份类型
    ,em_taxarea_taxno1 -- 【机构】税收居民国地区与纳税人识别号①
    ,em_taxarea_taxno2 -- 【机构】税收居民国地区与纳税人识别号②
    ,em_taxarea_taxno3 -- 【机构】税收居民国地区与纳税人识别号③
    ,em_per_tax_null_reason1 -- 【机构】不能提供识别号的原因①
    ,em_per_tax_null_reason2 -- 【机构】不能提供识别号的原因②
    ,em_per_tax_null_reason3 -- 【机构】不能提供识别号的原因③
    ,em_organize_address -- 【机构】机构地址
    ,em_tax_english_name -- 【机构】英文名称
    ,eb_benfi_company_type -- 受益所有人企业所属类别
    ,eb_benfi_type -- 受益所有人类型
    ,eb_benfi_name1 -- 受益所有人1姓名
    ,eb_benfi_position1 -- 受益所有人1职务
    ,eb_benfi_certtype1 -- 受益所有人1证件类型
    ,eb_benfi_certno1 -- 受益所有人1证件号码
    ,eb_benfi_certthrudate1 -- 证件生效日期
    ,eb_benfi_address1 -- 受益所有人1联系地址
    ,eb_benfi_name2 -- 受益所有人2姓名
    ,eb_benfi_position2 -- 受益所有人2职务
    ,eb_benfi_certtype2 -- 受益所有人2证件类型
    ,eb_benfi_certno2 -- 受益所有人2证件号码
    ,eb_benfi_certthrudate2 -- 证件生效日期
    ,eb_benfi_address2 -- 受益所有人2联系地址
    ,eb_benfi_name3 -- 受益所有人3姓名
    ,eb_benfi_position3 -- 受益所有人3职务
    ,eb_benfi_certtype3 -- 受益所有人3证件类型
    ,eb_benfi_certno3 -- 受益所有人3证件号码
    ,eb_benfi_certthrudate3 -- 证件生效日期
    ,eb_benfi_address3 -- 受益所有人3联系地址
    ,eb_benfi_name4 -- 受益所有人4姓名
    ,eb_benfi_position4 -- 受益所有人4职务
    ,eb_benfi_certtype4 -- 受益所有人4证件类型
    ,eb_benfi_certno4 -- 受益所有人4证件号码
    ,eb_benfi_certthrudate4 -- 证件生效日期
    ,eb_benfi_address4 -- 受益所有人4联系地址
    ,eb_benfi_name5 -- 受益所有人5姓名
    ,eb_benfi_position5 -- 受益所有人5职务
    ,eb_benfi_certtype5 -- 受益所有人5证件类型
    ,eb_benfi_certno5 -- 受益所有人5证件号码
    ,eb_benfi_certthrudate5 -- 证件生效日期
    ,eb_benfi_address5 -- 受益所有人5联系地址
    ,eb_control_name -- 股东名称
    ,eb_control_paperno -- 控股股东/实际控制人证件号码
    ,eb_control_paperstype -- 控股股东/实际控制人证件类型
    ,eb_same_benfi -- 同受益所有人
    ,eb_controller -- 控制人/控股股东
    ,eb_control_paperdt -- 控股股东/实际控制人有效期
    ,er_cop_name -- 关联企业名称
    ,er_incidence_relation -- 关联关系类型
    ,er_principal_name -- 关联企业法定代表人名称
    ,er_organiz_code -- 关联企业组织机构代码
    ,es_main_account -- 主账号
    ,ct_croler1_name -- 【控制人①】姓名
    ,ct_croler1_taxarea_nober1 -- 【控制人①】税收居民国（地区）和纳税人识别号①
    ,ct_croler1_taxnullreason1 -- 【控制人①】不能提供识别号的原因①
    ,ct_croler1_type -- 【控制人①】控制人类型
    ,ct_croler1_englishname -- 【控制人①】姓与名（英文或拼音）
    ,ct_croler1_tax_resident -- 【控制人①】税收居民身份
    ,ct_croler1_address -- 【控制人①】现居地址
    ,ct_croler1_taxarea_nober2 -- 【控制人①】税收居民国（地区）和纳税人识别号②
    ,ct_croler1_taxarea_nober3 -- 【控制人①】税收居民国（地区）和纳税人识别号③
    ,ct_croler1_birthday -- 【控制人①】出生日期
    ,ct_croler1_taxnullreason2 -- 【控制人①】不能提供识别号的原因②
    ,ct_croler1_taxnullreason3 -- 【控制人①】不能提供识别号的原因③
    ,ct_croler_birth_place -- 【控制人①】出生地址
    ,ct_croler2_name -- 【控制人②】姓名
    ,ct_croler2_englishname -- 【控制人②】姓与名（英文或拼音）
    ,ct_croler2_type -- 【控制人②】控制人类型
    ,ct_croler2_tax_resident -- 【控制人②】税收居民身份
    ,ct_croler2_birthday -- 【控制人②】出生日期
    ,ct_croler2_address -- 【控制人②】现居地址
    ,ct_croler2_taxarea_nober1 -- 【控制人②】税收居民国（地区）和纳税人识别号①
    ,ct_croler2_taxarea_nober2 -- 【控制人②】税收居民国（地区）和纳税人识别号②
    ,ct_croler2_taxarea_nober3 -- 【控制人②】税收居民国（地区）和纳税人识别号③
    ,ct_croler2_taxnullreason1 -- 【控制人②】不能提供识别号的原因①
    ,ct_croler2_taxnullreason2 -- 【控制人②】不能提供识别号的原因②
    ,ct_croler2_taxnullreason3 -- 【控制人②】不能提供识别号的原因③
    ,ct_croler2_birth_place -- 【控制人②】出生地址
    ,ct_croler3_name -- 【控制人③】姓名
    ,ct_croler3_englishname -- 【控制人③】姓与名（英文或拼音）
    ,ct_croler3_type -- 【控制人③】控制人类型
    ,ct_croler3_tax_resident -- 【控制人③】税收居民身份
    ,ct_croler3_birthday -- 【控制人③】出生日期
    ,ct_croler3_address -- 【控制人③】现居地址
    ,ct_croler3_taxarea_nober1 -- 【控制人③】税收居民国（地区）和纳税人识别号①
    ,ct_croler3_taxarea_nober2 -- 【控制人③】税收居民国（地区）和纳税人识别号②
    ,ct_croler3_taxarea_nober3 -- 【控制人③】税收居民国（地区）和纳税人识别号③
    ,ct_croler3_taxnullreason1 -- 【控制人③】不能提供识别号的原因①
    ,ct_croler3_taxnullreason2 -- 【控制人③】不能提供识别号的原因②
    ,ct_croler3_taxnullreason3 -- 【控制人③】不能提供识别号的原因③
    ,ct_croler3_birth_place -- 【控制人③】出生地址
    ,bq_trust_name1 -- 受委托人1姓名
    ,bq_trust_certtype1 -- 受委托人1证件种类
    ,bq_trust_certno1 -- 受委托人1证件号码
    ,bq_trust_name2 -- 受委托人2姓名
    ,bq_trust_certtype2 -- 受委托人2证件种类
    ,bq_trust_certno2 -- 受委托人2证件号码
    ,bq_accredit_name1 -- 被授权人1姓名
    ,bq_accredit_certtype1 -- 被授权人1证件种类
    ,bq_accredit_certno1 -- 被授权人1证件号码
    ,bq_accredit_name2 -- 被授权人2姓名
    ,bq_accredit_certtype2 -- 被授权人2证件种类
    ,bq_accredit_certno2 -- 被授权人2证件号码
    ,frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,acct_no -- 账号
    ,visit_service -- 上门服务(0:否 1：是)
    ,check_type -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,account_active_flag -- 账户激活标志 1-已激活 2-激活失败 0-未激活
    ,if_public_seal -- 是否共用验印(1-是 0-否)
    ,if_seal -- 是否倒验(1-是 0-否)
    ,cust_no -- 客户编号
    ,cust_name -- 客户名称
    ,proxy_name -- 代理人姓名
    ,proxy_papers_type -- 代理人证件类型
    ,proxy_papers_number -- 代理人证件号码
    ,trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,acct_cancel_date -- 客户销户日期
    ,is_local_check -- 是否双异地(1-是 0-否)
    ,acct_open_channel -- 开户渠道
    ,charge_id -- 审核柜员
    ,is_upload_new_form -- 是否上传系统最新表单(0-否 1-是)
    ,doc_id -- 影像批次号
    ,is_check -- 是否核准（1-是 0-否，用于报备RPA）
    ,zone_cd -- 注册地区代码
    ,reg_cap_ccy -- 注册资金币种
    ,dirt_unt_lp_typ -- 上级法人或主管单位信息（1-法定代表人 2-单位负责人）
    ,rec_type -- 备案类型： 0本地备案1异地备案
    ,rpa_related_corp1 -- 关联企业名称_1
    ,rpa_related_corp2 -- 关联企业名称_2
    ,rpa_related_corp3 -- 关联企业名称_3
    ,rpa_related_corp4 -- 关联企业名称_4
    ,rpa_related_corp5 -- 关联企业名称_5
    ,rpa_related_corp6 -- 关联企业名称_6
    ,rpa_related_corp7 -- 关联企业名称_7
    ,rpa_related_corp8 -- 关联企业名称_8
    ,rpa_related_corp9 -- 关联企业名称_9
    ,rpa_related_corp10 -- 关联企业名称_10
    ,rpa_corper_name1 -- 1法定代表人名称
    ,rpa_corper_name2 -- 2法定代表人名称
    ,rpa_corper_name3 -- 3法定代表人名称
    ,rpa_corper_name4 -- 4法定代表人名称
    ,rpa_corper_name5 -- 5法定代表人名称
    ,rpa_corper_name6 -- 6法定代表人名称
    ,rpa_corper_name7 -- 7法定代表人名称
    ,rpa_corper_name8 -- 8法定代表人名称
    ,rpa_corper_name9 -- 9法定代表人名称
    ,rpa_corper_name10 -- 10法定代表人名称
    ,rpa_organze_code1 -- 组织机构代码_1
    ,rpa_organze_code2 -- 组织机构代码_2
    ,rpa_organze_code3 -- 组织机构代码_3
    ,rpa_organze_code4 -- 组织机构代码_4
    ,rpa_organze_code5 -- 组织机构代码_5
    ,rpa_organze_code6 -- 组织机构代码_6
    ,rpa_organze_code7 -- 组织机构代码_7
    ,rpa_organze_code8 -- 组织机构代码_8
    ,rpa_organze_code9 -- 组织机构代码_9
    ,rpa_organze_code10 -- 组织机构代码_10
    ,proxy_phone -- 交易代办人联系电话
    ,proxy_invaldt -- 代理人证件有效期
    ,is_proxy -- 是否代理（1-是，2-否）
    ,is_bs_flag -- 事后补扫是否完成,0-未完成，1-完成
    ,is_rpa_check -- 是否经过rpa核查（1-是，0-否）
    ,business_type -- 业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））
    ,found_date -- 成立日期（营业执照）
    ,change_date -- 变更时间
    ,change_content -- 变更内容
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scps_bp_corporate_change_tb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scps_bp_corporate_change_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_corporate_change_tb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_corporate_change_tb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scps_bp_corporate_change_tb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_corporate_change_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);