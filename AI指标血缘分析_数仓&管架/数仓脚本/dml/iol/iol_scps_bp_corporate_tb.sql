/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_corporate_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scps_bp_corporate_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_corporate_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_corporate_tb_op purge;
drop table ${iol_schema}.scps_bp_corporate_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_corporate_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_corporate_tb where 0=1;

create table ${iol_schema}.scps_bp_corporate_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_corporate_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_corporate_tb_cl(
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
            ,people_area_code -- 人行地区代码
            ,usw_flg -- 通存通兑
            ,ccy -- 币种
            ,prd_typ -- 产品类型
            ,check_dt -- 核准日期
            ,bad_check_black -- 空头支票黑名单状态
            ,ea_legal_end -- 法人/负责人证件有效期结束日
            ,ea_work_address -- 办公地址
            ,eb_name -- 受益所有人客户名称
            ,ei_check_certificate_amt -- 设置查证金额
            ,ei_unit_name -- 单位名称
            ,enter_firstparty -- 企业银行账户管理协议（甲方）
            ,util_first_party -- 单位银行账户管理协议（甲方）
            ,trade_code -- 国民经济行业分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_corporate_tb_op(
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
            ,people_area_code -- 人行地区代码
            ,usw_flg -- 通存通兑
            ,ccy -- 币种
            ,prd_typ -- 产品类型
            ,check_dt -- 核准日期
            ,bad_check_black -- 空头支票黑名单状态
            ,ea_legal_end -- 法人/负责人证件有效期结束日
            ,ea_work_address -- 办公地址
            ,eb_name -- 受益所有人客户名称
            ,ei_check_certificate_amt -- 设置查证金额
            ,ei_unit_name -- 单位名称
            ,enter_firstparty -- 企业银行账户管理协议（甲方）
            ,util_first_party -- 单位银行账户管理协议（甲方）
            ,trade_code -- 国民经济行业分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 客户开户日期
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 发起机构号
    ,nvl(n.user_no, o.user_no) as user_no -- 发起柜员
    ,nvl(n.user_enable, o.user_enable) as user_enable -- 开户状态（0处理中，1记账完成）
    ,nvl(n.ea_phone, o.ea_phone) as ea_phone -- 联系电话
    ,nvl(n.ea_register_address, o.ea_register_address) as ea_register_address -- 注册地址
    ,nvl(n.ea_post_code, o.ea_post_code) as ea_post_code -- 邮编
    ,nvl(n.ea_trade_type, o.ea_trade_type) as ea_trade_type -- 所属行业类型
    ,nvl(n.ea_register_fund, o.ea_register_fund) as ea_register_fund -- 注册资本
    ,nvl(n.ea_fund_quality, o.ea_fund_quality) as ea_fund_quality -- 资金性质
    ,nvl(n.ea_operate_scope, o.ea_operate_scope) as ea_operate_scope -- 经营范围
    ,nvl(n.ea_tempacctdt_end, o.ea_tempacctdt_end) as ea_tempacctdt_end -- 临时户有效日期至
    ,nvl(n.ea_legal_rep, o.ea_legal_rep) as ea_legal_rep -- 法定代表人或单位负责人姓名
    ,nvl(n.ea_upcrna, o.ea_upcrna) as ea_upcrna -- 上级法人或主管单位名称
    ,nvl(n.ea_company_approve_no, o.ea_company_approve_no) as ea_company_approve_no -- 上级法人或主管基本存款账户开户许可证核准号
    ,nvl(n.ea_compay_fin_name, o.ea_compay_fin_name) as ea_compay_fin_name -- 上级法人/主管姓名
    ,nvl(n.ea_f_company_fin_paptype, o.ea_f_company_fin_paptype) as ea_f_company_fin_paptype -- 上级法人/主管证件种类
    ,nvl(n.ea_f_company_fin_papno, o.ea_f_company_fin_papno) as ea_f_company_fin_papno -- 上级法人/主管证件号码
    ,nvl(n.ea_deposit_type, o.ea_deposit_type) as ea_deposit_type -- 存款人类别
    ,nvl(n.ea_attor_oprno, o.ea_attor_oprno) as ea_attor_oprno -- 客户经理编号
    ,nvl(n.ea_papers_type2, o.ea_papers_type2) as ea_papers_type2 -- 第二证明文件类型
    ,nvl(n.ea_tax_certno, o.ea_tax_certno) as ea_tax_certno -- 国税登记证编号/地税登记证编号
    ,nvl(n.ea_company_fin_papno, o.ea_company_fin_papno) as ea_company_fin_papno -- 法人/负责人证件号码
    ,nvl(n.ea_company_fin_paptype, o.ea_company_fin_paptype) as ea_company_fin_paptype -- 法人/负责人证件种类
    ,nvl(n.ea_legal_iddt, o.ea_legal_iddt) as ea_legal_iddt -- 法人/负责人证件生效日期
    ,nvl(n.ea_deposit_name, o.ea_deposit_name) as ea_deposit_name -- 存款人名称
    ,nvl(n.ea_acct_name, o.ea_acct_name) as ea_acct_name -- 账户名称
    ,nvl(n.ea_certcode, o.ea_certcode) as ea_certcode -- 法人/负责人开户许可证核准号/基本存款账户编号
    ,nvl(n.ea_pre_seqno, o.ea_pre_seqno) as ea_pre_seqno -- 预受理编号
    ,nvl(n.ea_perpers_inval_type1, o.ea_perpers_inval_type1) as ea_perpers_inval_type1 -- 第一证明文件类型
    ,nvl(n.ea_perpers_inval_code1, o.ea_perpers_inval_code1) as ea_perpers_inval_code1 -- 第一证明文件编号
    ,nvl(n.ea_perpers_inval_date1, o.ea_perpers_inval_date1) as ea_perpers_inval_date1 -- 第一证明文件到期日
    ,nvl(n.ea_papers_type, o.ea_papers_type) as ea_papers_type -- 第一证件类型
    ,nvl(n.ea_compay_organiz_code, o.ea_compay_organiz_code) as ea_compay_organiz_code -- 上级法人或主管单位证明文件编号
    ,nvl(n.ea_country, o.ea_country) as ea_country -- 国家和地区
    ,nvl(n.ea_corp_org_type, o.ea_corp_org_type) as ea_corp_org_type -- 机构类别
    ,nvl(n.ea_tax_resident, o.ea_tax_resident) as ea_tax_resident -- 税收居民身份
    ,nvl(n.ea_acct_char, o.ea_acct_char) as ea_acct_char -- 账户性质
    ,nvl(n.ea_perpers_inval_code2, o.ea_perpers_inval_code2) as ea_perpers_inval_code2 -- 第二证明文件编号
    ,nvl(n.ea_perpers_inval_date2, o.ea_perpers_inval_date2) as ea_perpers_inval_date2 -- 第二证明文件到期日
    ,nvl(n.ei_year_limit, o.ei_year_limit) as ei_year_limit -- 年累计限额
    ,nvl(n.ei_business_flow, o.ei_business_flow) as ei_business_flow -- 业务流程设置
    ,nvl(n.ei_sign_mobile, o.ei_sign_mobile) as ei_sign_mobile -- 签约手机号码
    ,nvl(n.ei_seal_mode, o.ei_seal_mode) as ei_seal_mode -- 银企验印方式（对账单加盖印章种类）
    ,nvl(n.ei_mail_address, o.ei_mail_address) as ei_mail_address -- 银企邮寄地址
    ,nvl(n.ei_bczipcd, o.ei_bczipcd) as ei_bczipcd -- 银企邮编
    ,nvl(n.ei_linkman, o.ei_linkman) as ei_linkman -- 银企联系人
    ,nvl(n.ei_linktel, o.ei_linktel) as ei_linktel -- 银企联系电话
    ,nvl(n.ei_sendmode, o.ei_sendmode) as ei_sendmode -- 银企对账方式
    ,nvl(n.ei_acccycle, o.ei_acccycle) as ei_acccycle -- 银企对账周期
    ,nvl(n.ei_day_limit, o.ei_day_limit) as ei_day_limit -- 日累计限额
    ,nvl(n.ei_day_times, o.ei_day_times) as ei_day_times -- 日累计笔数
    ,nvl(n.ei_application, o.ei_application) as ei_application -- 基本服务申请
    ,nvl(n.ei_call_type, o.ei_call_type) as ei_call_type -- 查证类型
    ,nvl(n.ei_accredit_legal_name, o.ei_accredit_legal_name) as ei_accredit_legal_name -- 查证法定代表人(单位负责人)姓名
    ,nvl(n.ei_accredit_legal_tel, o.ei_accredit_legal_tel) as ei_accredit_legal_tel -- 查证法定代表人/单位负责人手机号码
    ,nvl(n.ei_accredit_legal_phone, o.ei_accredit_legal_phone) as ei_accredit_legal_phone -- 查证法定代表人/单位负责人固定电话
    ,nvl(n.ei_principal_checkorder, o.ei_principal_checkorder) as ei_principal_checkorder -- 查证人顺序
    ,nvl(n.ei_principal_funds_check, o.ei_principal_funds_check) as ei_principal_funds_check -- 资金查证人（至少两名）
    ,nvl(n.ei_mainfin_contect_name, o.ei_mainfin_contect_name) as ei_mainfin_contect_name -- 财务负责人姓名
    ,nvl(n.ei_mainfin_contect_tel, o.ei_mainfin_contect_tel) as ei_mainfin_contect_tel -- 财务负责人手机号码
    ,nvl(n.ei_mainfin_contect_phone, o.ei_mainfin_contect_phone) as ei_mainfin_contect_phone -- 财务负责人固定电话
    ,nvl(n.ei_fin_contect_checkorder, o.ei_fin_contect_checkorder) as ei_fin_contect_checkorder -- 查证人顺序
    ,nvl(n.ei_fin_contect_funds_check, o.ei_fin_contect_funds_check) as ei_fin_contect_funds_check -- 资金查证人（至少两名）
    ,nvl(n.ei_fin_contect_name1, o.ei_fin_contect_name1) as ei_fin_contect_name1 -- 财务人员1姓名
    ,nvl(n.ei_fin_contect_tel1, o.ei_fin_contect_tel1) as ei_fin_contect_tel1 -- 财务人员1手机号码
    ,nvl(n.ei_fin_contect_phone1, o.ei_fin_contect_phone1) as ei_fin_contect_phone1 -- 财务人员1固定电话
    ,nvl(n.ei_chrg_check1_order, o.ei_chrg_check1_order) as ei_chrg_check1_order -- 查证人顺序
    ,nvl(n.ei_chrg_funds_check1, o.ei_chrg_funds_check1) as ei_chrg_funds_check1 -- 资金查证人（至少两名）
    ,nvl(n.ei_fin_contect_name2, o.ei_fin_contect_name2) as ei_fin_contect_name2 -- 财务人员2姓名
    ,nvl(n.ei_fin_contect_tel2, o.ei_fin_contect_tel2) as ei_fin_contect_tel2 -- 财务人员2手机号码
    ,nvl(n.ei_fin_contect_phone2, o.ei_fin_contect_phone2) as ei_fin_contect_phone2 -- 财务人员2固定电话
    ,nvl(n.ei_chrg_check2_order, o.ei_chrg_check2_order) as ei_chrg_check2_order -- 查证人顺序
    ,nvl(n.ei_chrg_funds_check2, o.ei_chrg_funds_check2) as ei_chrg_funds_check2 -- 资金查证人（至少两名）
    ,nvl(n.em_organize_name, o.em_organize_name) as em_organize_name -- 【机构】机构名称
    ,nvl(n.em_corp_corporgtype, o.em_corp_corporgtype) as em_corp_corporgtype -- 【机构】类别
    ,nvl(n.em_tax_resident_type, o.em_tax_resident_type) as em_tax_resident_type -- 【机构】税收居民身份类型
    ,nvl(n.em_taxarea_taxno1, o.em_taxarea_taxno1) as em_taxarea_taxno1 -- 【机构】税收居民国地区与纳税人识别号①
    ,nvl(n.em_taxarea_taxno2, o.em_taxarea_taxno2) as em_taxarea_taxno2 -- 【机构】税收居民国地区与纳税人识别号②
    ,nvl(n.em_taxarea_taxno3, o.em_taxarea_taxno3) as em_taxarea_taxno3 -- 【机构】税收居民国地区与纳税人识别号③
    ,nvl(n.em_per_tax_null_reason1, o.em_per_tax_null_reason1) as em_per_tax_null_reason1 -- 【机构】不能提供识别号的原因①
    ,nvl(n.em_per_tax_null_reason2, o.em_per_tax_null_reason2) as em_per_tax_null_reason2 -- 【机构】不能提供识别号的原因②
    ,nvl(n.em_per_tax_null_reason3, o.em_per_tax_null_reason3) as em_per_tax_null_reason3 -- 【机构】不能提供识别号的原因③
    ,nvl(n.em_organize_address, o.em_organize_address) as em_organize_address -- 【机构】机构地址
    ,nvl(n.em_tax_english_name, o.em_tax_english_name) as em_tax_english_name -- 【机构】英文名称
    ,nvl(n.eb_benfi_company_type, o.eb_benfi_company_type) as eb_benfi_company_type -- 受益所有人企业所属类别
    ,nvl(n.eb_benfi_type, o.eb_benfi_type) as eb_benfi_type -- 受益所有人类型
    ,nvl(n.eb_benfi_name1, o.eb_benfi_name1) as eb_benfi_name1 -- 受益所有人1姓名
    ,nvl(n.eb_benfi_position1, o.eb_benfi_position1) as eb_benfi_position1 -- 受益所有人1职务
    ,nvl(n.eb_benfi_certtype1, o.eb_benfi_certtype1) as eb_benfi_certtype1 -- 受益所有人1证件类型
    ,nvl(n.eb_benfi_certno1, o.eb_benfi_certno1) as eb_benfi_certno1 -- 受益所有人1证件号码
    ,nvl(n.eb_benfi_certthrudate1, o.eb_benfi_certthrudate1) as eb_benfi_certthrudate1 -- 证件生效日期
    ,nvl(n.eb_benfi_address1, o.eb_benfi_address1) as eb_benfi_address1 -- 受益所有人1联系地址
    ,nvl(n.eb_benfi_name2, o.eb_benfi_name2) as eb_benfi_name2 -- 受益所有人2姓名
    ,nvl(n.eb_benfi_position2, o.eb_benfi_position2) as eb_benfi_position2 -- 受益所有人2职务
    ,nvl(n.eb_benfi_certtype2, o.eb_benfi_certtype2) as eb_benfi_certtype2 -- 受益所有人2证件类型
    ,nvl(n.eb_benfi_certno2, o.eb_benfi_certno2) as eb_benfi_certno2 -- 受益所有人2证件号码
    ,nvl(n.eb_benfi_certthrudate2, o.eb_benfi_certthrudate2) as eb_benfi_certthrudate2 -- 证件生效日期
    ,nvl(n.eb_benfi_address2, o.eb_benfi_address2) as eb_benfi_address2 -- 受益所有人2联系地址
    ,nvl(n.eb_benfi_name3, o.eb_benfi_name3) as eb_benfi_name3 -- 受益所有人3姓名
    ,nvl(n.eb_benfi_position3, o.eb_benfi_position3) as eb_benfi_position3 -- 受益所有人3职务
    ,nvl(n.eb_benfi_certtype3, o.eb_benfi_certtype3) as eb_benfi_certtype3 -- 受益所有人3证件类型
    ,nvl(n.eb_benfi_certno3, o.eb_benfi_certno3) as eb_benfi_certno3 -- 受益所有人3证件号码
    ,nvl(n.eb_benfi_certthrudate3, o.eb_benfi_certthrudate3) as eb_benfi_certthrudate3 -- 证件生效日期
    ,nvl(n.eb_benfi_address3, o.eb_benfi_address3) as eb_benfi_address3 -- 受益所有人3联系地址
    ,nvl(n.eb_benfi_name4, o.eb_benfi_name4) as eb_benfi_name4 -- 受益所有人4姓名
    ,nvl(n.eb_benfi_position4, o.eb_benfi_position4) as eb_benfi_position4 -- 受益所有人4职务
    ,nvl(n.eb_benfi_certtype4, o.eb_benfi_certtype4) as eb_benfi_certtype4 -- 受益所有人4证件类型
    ,nvl(n.eb_benfi_certno4, o.eb_benfi_certno4) as eb_benfi_certno4 -- 受益所有人4证件号码
    ,nvl(n.eb_benfi_certthrudate4, o.eb_benfi_certthrudate4) as eb_benfi_certthrudate4 -- 证件生效日期
    ,nvl(n.eb_benfi_address4, o.eb_benfi_address4) as eb_benfi_address4 -- 受益所有人4联系地址
    ,nvl(n.eb_benfi_name5, o.eb_benfi_name5) as eb_benfi_name5 -- 受益所有人5姓名
    ,nvl(n.eb_benfi_position5, o.eb_benfi_position5) as eb_benfi_position5 -- 受益所有人5职务
    ,nvl(n.eb_benfi_certtype5, o.eb_benfi_certtype5) as eb_benfi_certtype5 -- 受益所有人5证件类型
    ,nvl(n.eb_benfi_certno5, o.eb_benfi_certno5) as eb_benfi_certno5 -- 受益所有人5证件号码
    ,nvl(n.eb_benfi_certthrudate5, o.eb_benfi_certthrudate5) as eb_benfi_certthrudate5 -- 证件生效日期
    ,nvl(n.eb_benfi_address5, o.eb_benfi_address5) as eb_benfi_address5 -- 受益所有人5联系地址
    ,nvl(n.eb_control_name, o.eb_control_name) as eb_control_name -- 股东名称
    ,nvl(n.eb_control_paperno, o.eb_control_paperno) as eb_control_paperno -- 控股股东/实际控制人证件号码
    ,nvl(n.eb_control_paperstype, o.eb_control_paperstype) as eb_control_paperstype -- 控股股东/实际控制人证件类型
    ,nvl(n.eb_same_benfi, o.eb_same_benfi) as eb_same_benfi -- 同受益所有人
    ,nvl(n.eb_controller, o.eb_controller) as eb_controller -- 控制人/控股股东
    ,nvl(n.eb_control_paperdt, o.eb_control_paperdt) as eb_control_paperdt -- 控股股东/实际控制人有效期
    ,nvl(n.er_cop_name, o.er_cop_name) as er_cop_name -- 关联企业名称
    ,nvl(n.er_incidence_relation, o.er_incidence_relation) as er_incidence_relation -- 关联关系类型
    ,nvl(n.er_principal_name, o.er_principal_name) as er_principal_name -- 关联企业法定代表人名称
    ,nvl(n.er_organiz_code, o.er_organiz_code) as er_organiz_code -- 关联企业组织机构代码
    ,nvl(n.es_main_account, o.es_main_account) as es_main_account -- 主账号
    ,nvl(n.ct_croler1_name, o.ct_croler1_name) as ct_croler1_name -- 【控制人①】姓名
    ,nvl(n.ct_croler1_taxarea_nober1, o.ct_croler1_taxarea_nober1) as ct_croler1_taxarea_nober1 -- 【控制人①】税收居民国（地区）和纳税人识别号①
    ,nvl(n.ct_croler1_taxnullreason1, o.ct_croler1_taxnullreason1) as ct_croler1_taxnullreason1 -- 【控制人①】不能提供识别号的原因①
    ,nvl(n.ct_croler1_type, o.ct_croler1_type) as ct_croler1_type -- 【控制人①】控制人类型
    ,nvl(n.ct_croler1_englishname, o.ct_croler1_englishname) as ct_croler1_englishname -- 【控制人①】姓与名（英文或拼音）
    ,nvl(n.ct_croler1_tax_resident, o.ct_croler1_tax_resident) as ct_croler1_tax_resident -- 【控制人①】税收居民身份
    ,nvl(n.ct_croler1_address, o.ct_croler1_address) as ct_croler1_address -- 【控制人①】现居地址
    ,nvl(n.ct_croler1_taxarea_nober2, o.ct_croler1_taxarea_nober2) as ct_croler1_taxarea_nober2 -- 【控制人①】税收居民国（地区）和纳税人识别号②
    ,nvl(n.ct_croler1_taxarea_nober3, o.ct_croler1_taxarea_nober3) as ct_croler1_taxarea_nober3 -- 【控制人①】税收居民国（地区）和纳税人识别号③
    ,nvl(n.ct_croler1_birthday, o.ct_croler1_birthday) as ct_croler1_birthday -- 【控制人①】出生日期
    ,nvl(n.ct_croler1_taxnullreason2, o.ct_croler1_taxnullreason2) as ct_croler1_taxnullreason2 -- 【控制人①】不能提供识别号的原因②
    ,nvl(n.ct_croler1_taxnullreason3, o.ct_croler1_taxnullreason3) as ct_croler1_taxnullreason3 -- 【控制人①】不能提供识别号的原因③
    ,nvl(n.ct_croler_birth_place, o.ct_croler_birth_place) as ct_croler_birth_place -- 【控制人①】出生地址
    ,nvl(n.ct_croler2_name, o.ct_croler2_name) as ct_croler2_name -- 【控制人②】姓名
    ,nvl(n.ct_croler2_englishname, o.ct_croler2_englishname) as ct_croler2_englishname -- 【控制人②】姓与名（英文或拼音）
    ,nvl(n.ct_croler2_type, o.ct_croler2_type) as ct_croler2_type -- 【控制人②】控制人类型
    ,nvl(n.ct_croler2_tax_resident, o.ct_croler2_tax_resident) as ct_croler2_tax_resident -- 【控制人②】税收居民身份
    ,nvl(n.ct_croler2_birthday, o.ct_croler2_birthday) as ct_croler2_birthday -- 【控制人②】出生日期
    ,nvl(n.ct_croler2_address, o.ct_croler2_address) as ct_croler2_address -- 【控制人②】现居地址
    ,nvl(n.ct_croler2_taxarea_nober1, o.ct_croler2_taxarea_nober1) as ct_croler2_taxarea_nober1 -- 【控制人②】税收居民国（地区）和纳税人识别号①
    ,nvl(n.ct_croler2_taxarea_nober2, o.ct_croler2_taxarea_nober2) as ct_croler2_taxarea_nober2 -- 【控制人②】税收居民国（地区）和纳税人识别号②
    ,nvl(n.ct_croler2_taxarea_nober3, o.ct_croler2_taxarea_nober3) as ct_croler2_taxarea_nober3 -- 【控制人②】税收居民国（地区）和纳税人识别号③
    ,nvl(n.ct_croler2_taxnullreason1, o.ct_croler2_taxnullreason1) as ct_croler2_taxnullreason1 -- 【控制人②】不能提供识别号的原因①
    ,nvl(n.ct_croler2_taxnullreason2, o.ct_croler2_taxnullreason2) as ct_croler2_taxnullreason2 -- 【控制人②】不能提供识别号的原因②
    ,nvl(n.ct_croler2_taxnullreason3, o.ct_croler2_taxnullreason3) as ct_croler2_taxnullreason3 -- 【控制人②】不能提供识别号的原因③
    ,nvl(n.ct_croler2_birth_place, o.ct_croler2_birth_place) as ct_croler2_birth_place -- 【控制人②】出生地址
    ,nvl(n.ct_croler3_name, o.ct_croler3_name) as ct_croler3_name -- 【控制人③】姓名
    ,nvl(n.ct_croler3_englishname, o.ct_croler3_englishname) as ct_croler3_englishname -- 【控制人③】姓与名（英文或拼音）
    ,nvl(n.ct_croler3_type, o.ct_croler3_type) as ct_croler3_type -- 【控制人③】控制人类型
    ,nvl(n.ct_croler3_tax_resident, o.ct_croler3_tax_resident) as ct_croler3_tax_resident -- 【控制人③】税收居民身份
    ,nvl(n.ct_croler3_birthday, o.ct_croler3_birthday) as ct_croler3_birthday -- 【控制人③】出生日期
    ,nvl(n.ct_croler3_address, o.ct_croler3_address) as ct_croler3_address -- 【控制人③】现居地址
    ,nvl(n.ct_croler3_taxarea_nober1, o.ct_croler3_taxarea_nober1) as ct_croler3_taxarea_nober1 -- 【控制人③】税收居民国（地区）和纳税人识别号①
    ,nvl(n.ct_croler3_taxarea_nober2, o.ct_croler3_taxarea_nober2) as ct_croler3_taxarea_nober2 -- 【控制人③】税收居民国（地区）和纳税人识别号②
    ,nvl(n.ct_croler3_taxarea_nober3, o.ct_croler3_taxarea_nober3) as ct_croler3_taxarea_nober3 -- 【控制人③】税收居民国（地区）和纳税人识别号③
    ,nvl(n.ct_croler3_taxnullreason1, o.ct_croler3_taxnullreason1) as ct_croler3_taxnullreason1 -- 【控制人③】不能提供识别号的原因①
    ,nvl(n.ct_croler3_taxnullreason2, o.ct_croler3_taxnullreason2) as ct_croler3_taxnullreason2 -- 【控制人③】不能提供识别号的原因②
    ,nvl(n.ct_croler3_taxnullreason3, o.ct_croler3_taxnullreason3) as ct_croler3_taxnullreason3 -- 【控制人③】不能提供识别号的原因③
    ,nvl(n.ct_croler3_birth_place, o.ct_croler3_birth_place) as ct_croler3_birth_place -- 【控制人③】出生地址
    ,nvl(n.bq_trust_name1, o.bq_trust_name1) as bq_trust_name1 -- 受委托人1姓名
    ,nvl(n.bq_trust_certtype1, o.bq_trust_certtype1) as bq_trust_certtype1 -- 受委托人1证件种类
    ,nvl(n.bq_trust_certno1, o.bq_trust_certno1) as bq_trust_certno1 -- 受委托人1证件号码
    ,nvl(n.bq_trust_name2, o.bq_trust_name2) as bq_trust_name2 -- 受委托人2姓名
    ,nvl(n.bq_trust_certtype2, o.bq_trust_certtype2) as bq_trust_certtype2 -- 受委托人2证件种类
    ,nvl(n.bq_trust_certno2, o.bq_trust_certno2) as bq_trust_certno2 -- 受委托人2证件号码
    ,nvl(n.bq_accredit_name1, o.bq_accredit_name1) as bq_accredit_name1 -- 被授权人1姓名
    ,nvl(n.bq_accredit_certtype1, o.bq_accredit_certtype1) as bq_accredit_certtype1 -- 被授权人1证件种类
    ,nvl(n.bq_accredit_certno1, o.bq_accredit_certno1) as bq_accredit_certno1 -- 被授权人1证件号码
    ,nvl(n.bq_accredit_name2, o.bq_accredit_name2) as bq_accredit_name2 -- 被授权人2姓名
    ,nvl(n.bq_accredit_certtype2, o.bq_accredit_certtype2) as bq_accredit_certtype2 -- 被授权人2证件种类
    ,nvl(n.bq_accredit_certno2, o.bq_accredit_certno2) as bq_accredit_certno2 -- 被授权人2证件号码
    ,nvl(n.frozen_flag, o.frozen_flag) as frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 账号
    ,nvl(n.visit_service, o.visit_service) as visit_service -- 上门服务(0:否 1：是)
    ,nvl(n.check_type, o.check_type) as check_type -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,nvl(n.account_active_flag, o.account_active_flag) as account_active_flag -- 账户激活标志 1-已激活 2-激活失败 0-未激活
    ,nvl(n.if_public_seal, o.if_public_seal) as if_public_seal -- 是否共用验印(1-是 0-否)
    ,nvl(n.if_seal, o.if_seal) as if_seal -- 是否倒验(1-是 0-否)
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.proxy_name, o.proxy_name) as proxy_name -- 代理人姓名
    ,nvl(n.proxy_papers_type, o.proxy_papers_type) as proxy_papers_type -- 代理人证件类型
    ,nvl(n.proxy_papers_number, o.proxy_papers_number) as proxy_papers_number -- 代理人证件号码
    ,nvl(n.trans_state, o.trans_state) as trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,nvl(n.acct_cancel_date, o.acct_cancel_date) as acct_cancel_date -- 客户销户日期
    ,nvl(n.is_local_check, o.is_local_check) as is_local_check -- 是否双异地(1-是 0-否)
    ,nvl(n.acct_open_channel, o.acct_open_channel) as acct_open_channel -- 开户渠道
    ,nvl(n.charge_id, o.charge_id) as charge_id -- 审核柜员
    ,nvl(n.is_upload_new_form, o.is_upload_new_form) as is_upload_new_form -- 是否上传系统最新表单(0-否 1-是)
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像批次号
    ,nvl(n.is_check, o.is_check) as is_check -- 是否核准（1-是 0-否，用于报备RPA）
    ,nvl(n.zone_cd, o.zone_cd) as zone_cd -- 注册地区代码
    ,nvl(n.reg_cap_ccy, o.reg_cap_ccy) as reg_cap_ccy -- 注册资金币种
    ,nvl(n.dirt_unt_lp_typ, o.dirt_unt_lp_typ) as dirt_unt_lp_typ -- 上级法人或主管单位信息（1-法定代表人 2-单位负责人）
    ,nvl(n.rec_type, o.rec_type) as rec_type -- 备案类型： 0本地备案1异地备案
    ,nvl(n.rpa_related_corp1, o.rpa_related_corp1) as rpa_related_corp1 -- 关联企业名称_1
    ,nvl(n.rpa_related_corp2, o.rpa_related_corp2) as rpa_related_corp2 -- 关联企业名称_2
    ,nvl(n.rpa_related_corp3, o.rpa_related_corp3) as rpa_related_corp3 -- 关联企业名称_3
    ,nvl(n.rpa_related_corp4, o.rpa_related_corp4) as rpa_related_corp4 -- 关联企业名称_4
    ,nvl(n.rpa_related_corp5, o.rpa_related_corp5) as rpa_related_corp5 -- 关联企业名称_5
    ,nvl(n.rpa_related_corp6, o.rpa_related_corp6) as rpa_related_corp6 -- 关联企业名称_6
    ,nvl(n.rpa_related_corp7, o.rpa_related_corp7) as rpa_related_corp7 -- 关联企业名称_7
    ,nvl(n.rpa_related_corp8, o.rpa_related_corp8) as rpa_related_corp8 -- 关联企业名称_8
    ,nvl(n.rpa_related_corp9, o.rpa_related_corp9) as rpa_related_corp9 -- 关联企业名称_9
    ,nvl(n.rpa_related_corp10, o.rpa_related_corp10) as rpa_related_corp10 -- 关联企业名称_10
    ,nvl(n.rpa_corper_name1, o.rpa_corper_name1) as rpa_corper_name1 -- 1法定代表人名称
    ,nvl(n.rpa_corper_name2, o.rpa_corper_name2) as rpa_corper_name2 -- 2法定代表人名称
    ,nvl(n.rpa_corper_name3, o.rpa_corper_name3) as rpa_corper_name3 -- 3法定代表人名称
    ,nvl(n.rpa_corper_name4, o.rpa_corper_name4) as rpa_corper_name4 -- 4法定代表人名称
    ,nvl(n.rpa_corper_name5, o.rpa_corper_name5) as rpa_corper_name5 -- 5法定代表人名称
    ,nvl(n.rpa_corper_name6, o.rpa_corper_name6) as rpa_corper_name6 -- 6法定代表人名称
    ,nvl(n.rpa_corper_name7, o.rpa_corper_name7) as rpa_corper_name7 -- 7法定代表人名称
    ,nvl(n.rpa_corper_name8, o.rpa_corper_name8) as rpa_corper_name8 -- 8法定代表人名称
    ,nvl(n.rpa_corper_name9, o.rpa_corper_name9) as rpa_corper_name9 -- 9法定代表人名称
    ,nvl(n.rpa_corper_name10, o.rpa_corper_name10) as rpa_corper_name10 -- 10法定代表人名称
    ,nvl(n.rpa_organze_code1, o.rpa_organze_code1) as rpa_organze_code1 -- 组织机构代码_1
    ,nvl(n.rpa_organze_code2, o.rpa_organze_code2) as rpa_organze_code2 -- 组织机构代码_2
    ,nvl(n.rpa_organze_code3, o.rpa_organze_code3) as rpa_organze_code3 -- 组织机构代码_3
    ,nvl(n.rpa_organze_code4, o.rpa_organze_code4) as rpa_organze_code4 -- 组织机构代码_4
    ,nvl(n.rpa_organze_code5, o.rpa_organze_code5) as rpa_organze_code5 -- 组织机构代码_5
    ,nvl(n.rpa_organze_code6, o.rpa_organze_code6) as rpa_organze_code6 -- 组织机构代码_6
    ,nvl(n.rpa_organze_code7, o.rpa_organze_code7) as rpa_organze_code7 -- 组织机构代码_7
    ,nvl(n.rpa_organze_code8, o.rpa_organze_code8) as rpa_organze_code8 -- 组织机构代码_8
    ,nvl(n.rpa_organze_code9, o.rpa_organze_code9) as rpa_organze_code9 -- 组织机构代码_9
    ,nvl(n.rpa_organze_code10, o.rpa_organze_code10) as rpa_organze_code10 -- 组织机构代码_10
    ,nvl(n.proxy_phone, o.proxy_phone) as proxy_phone -- 交易代办人联系电话
    ,nvl(n.proxy_invaldt, o.proxy_invaldt) as proxy_invaldt -- 代理人证件有效期
    ,nvl(n.is_proxy, o.is_proxy) as is_proxy -- 是否代理（1-是，2-否）
    ,nvl(n.is_bs_flag, o.is_bs_flag) as is_bs_flag -- 事后补扫是否完成,0-未完成，1-完成
    ,nvl(n.is_rpa_check, o.is_rpa_check) as is_rpa_check -- 是否经过rpa核查（1-是，0-否）
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））
    ,nvl(n.found_date, o.found_date) as found_date -- 成立日期（营业执照）
    ,nvl(n.people_area_code, o.people_area_code) as people_area_code -- 人行地区代码
    ,nvl(n.usw_flg, o.usw_flg) as usw_flg -- 通存通兑
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.prd_typ, o.prd_typ) as prd_typ -- 产品类型
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 核准日期
    ,nvl(n.bad_check_black, o.bad_check_black) as bad_check_black -- 空头支票黑名单状态
    ,nvl(n.ea_legal_end, o.ea_legal_end) as ea_legal_end -- 法人/负责人证件有效期结束日
    ,nvl(n.ea_work_address, o.ea_work_address) as ea_work_address -- 办公地址
    ,nvl(n.eb_name, o.eb_name) as eb_name -- 受益所有人客户名称
    ,nvl(n.ei_check_certificate_amt, o.ei_check_certificate_amt) as ei_check_certificate_amt -- 设置查证金额
    ,nvl(n.ei_unit_name, o.ei_unit_name) as ei_unit_name -- 单位名称
    ,nvl(n.enter_firstparty, o.enter_firstparty) as enter_firstparty -- 企业银行账户管理协议（甲方）
    ,nvl(n.util_first_party, o.util_first_party) as util_first_party -- 单位银行账户管理协议（甲方）
    ,nvl(n.trade_code, o.trade_code) as trade_code -- 国民经济行业分类
    ,case when
            n.task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_corporate_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_corporate_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
where (
        o.task_id is null
    )
    or (
        n.task_id is null
    )
    or (
        o.glob_seq_num <> n.glob_seq_num
        or o.acct_open_date <> n.acct_open_date
        or o.organ_no <> n.organ_no
        or o.user_no <> n.user_no
        or o.user_enable <> n.user_enable
        or o.ea_phone <> n.ea_phone
        or o.ea_register_address <> n.ea_register_address
        or o.ea_post_code <> n.ea_post_code
        or o.ea_trade_type <> n.ea_trade_type
        or o.ea_register_fund <> n.ea_register_fund
        or o.ea_fund_quality <> n.ea_fund_quality
        or o.ea_operate_scope <> n.ea_operate_scope
        or o.ea_tempacctdt_end <> n.ea_tempacctdt_end
        or o.ea_legal_rep <> n.ea_legal_rep
        or o.ea_upcrna <> n.ea_upcrna
        or o.ea_company_approve_no <> n.ea_company_approve_no
        or o.ea_compay_fin_name <> n.ea_compay_fin_name
        or o.ea_f_company_fin_paptype <> n.ea_f_company_fin_paptype
        or o.ea_f_company_fin_papno <> n.ea_f_company_fin_papno
        or o.ea_deposit_type <> n.ea_deposit_type
        or o.ea_attor_oprno <> n.ea_attor_oprno
        or o.ea_papers_type2 <> n.ea_papers_type2
        or o.ea_tax_certno <> n.ea_tax_certno
        or o.ea_company_fin_papno <> n.ea_company_fin_papno
        or o.ea_company_fin_paptype <> n.ea_company_fin_paptype
        or o.ea_legal_iddt <> n.ea_legal_iddt
        or o.ea_deposit_name <> n.ea_deposit_name
        or o.ea_acct_name <> n.ea_acct_name
        or o.ea_certcode <> n.ea_certcode
        or o.ea_pre_seqno <> n.ea_pre_seqno
        or o.ea_perpers_inval_type1 <> n.ea_perpers_inval_type1
        or o.ea_perpers_inval_code1 <> n.ea_perpers_inval_code1
        or o.ea_perpers_inval_date1 <> n.ea_perpers_inval_date1
        or o.ea_papers_type <> n.ea_papers_type
        or o.ea_compay_organiz_code <> n.ea_compay_organiz_code
        or o.ea_country <> n.ea_country
        or o.ea_corp_org_type <> n.ea_corp_org_type
        or o.ea_tax_resident <> n.ea_tax_resident
        or o.ea_acct_char <> n.ea_acct_char
        or o.ea_perpers_inval_code2 <> n.ea_perpers_inval_code2
        or o.ea_perpers_inval_date2 <> n.ea_perpers_inval_date2
        or o.ei_year_limit <> n.ei_year_limit
        or o.ei_business_flow <> n.ei_business_flow
        or o.ei_sign_mobile <> n.ei_sign_mobile
        or o.ei_seal_mode <> n.ei_seal_mode
        or o.ei_mail_address <> n.ei_mail_address
        or o.ei_bczipcd <> n.ei_bczipcd
        or o.ei_linkman <> n.ei_linkman
        or o.ei_linktel <> n.ei_linktel
        or o.ei_sendmode <> n.ei_sendmode
        or o.ei_acccycle <> n.ei_acccycle
        or o.ei_day_limit <> n.ei_day_limit
        or o.ei_day_times <> n.ei_day_times
        or o.ei_application <> n.ei_application
        or o.ei_call_type <> n.ei_call_type
        or o.ei_accredit_legal_name <> n.ei_accredit_legal_name
        or o.ei_accredit_legal_tel <> n.ei_accredit_legal_tel
        or o.ei_accredit_legal_phone <> n.ei_accredit_legal_phone
        or o.ei_principal_checkorder <> n.ei_principal_checkorder
        or o.ei_principal_funds_check <> n.ei_principal_funds_check
        or o.ei_mainfin_contect_name <> n.ei_mainfin_contect_name
        or o.ei_mainfin_contect_tel <> n.ei_mainfin_contect_tel
        or o.ei_mainfin_contect_phone <> n.ei_mainfin_contect_phone
        or o.ei_fin_contect_checkorder <> n.ei_fin_contect_checkorder
        or o.ei_fin_contect_funds_check <> n.ei_fin_contect_funds_check
        or o.ei_fin_contect_name1 <> n.ei_fin_contect_name1
        or o.ei_fin_contect_tel1 <> n.ei_fin_contect_tel1
        or o.ei_fin_contect_phone1 <> n.ei_fin_contect_phone1
        or o.ei_chrg_check1_order <> n.ei_chrg_check1_order
        or o.ei_chrg_funds_check1 <> n.ei_chrg_funds_check1
        or o.ei_fin_contect_name2 <> n.ei_fin_contect_name2
        or o.ei_fin_contect_tel2 <> n.ei_fin_contect_tel2
        or o.ei_fin_contect_phone2 <> n.ei_fin_contect_phone2
        or o.ei_chrg_check2_order <> n.ei_chrg_check2_order
        or o.ei_chrg_funds_check2 <> n.ei_chrg_funds_check2
        or o.em_organize_name <> n.em_organize_name
        or o.em_corp_corporgtype <> n.em_corp_corporgtype
        or o.em_tax_resident_type <> n.em_tax_resident_type
        or o.em_taxarea_taxno1 <> n.em_taxarea_taxno1
        or o.em_taxarea_taxno2 <> n.em_taxarea_taxno2
        or o.em_taxarea_taxno3 <> n.em_taxarea_taxno3
        or o.em_per_tax_null_reason1 <> n.em_per_tax_null_reason1
        or o.em_per_tax_null_reason2 <> n.em_per_tax_null_reason2
        or o.em_per_tax_null_reason3 <> n.em_per_tax_null_reason3
        or o.em_organize_address <> n.em_organize_address
        or o.em_tax_english_name <> n.em_tax_english_name
        or o.eb_benfi_company_type <> n.eb_benfi_company_type
        or o.eb_benfi_type <> n.eb_benfi_type
        or o.eb_benfi_name1 <> n.eb_benfi_name1
        or o.eb_benfi_position1 <> n.eb_benfi_position1
        or o.eb_benfi_certtype1 <> n.eb_benfi_certtype1
        or o.eb_benfi_certno1 <> n.eb_benfi_certno1
        or o.eb_benfi_certthrudate1 <> n.eb_benfi_certthrudate1
        or o.eb_benfi_address1 <> n.eb_benfi_address1
        or o.eb_benfi_name2 <> n.eb_benfi_name2
        or o.eb_benfi_position2 <> n.eb_benfi_position2
        or o.eb_benfi_certtype2 <> n.eb_benfi_certtype2
        or o.eb_benfi_certno2 <> n.eb_benfi_certno2
        or o.eb_benfi_certthrudate2 <> n.eb_benfi_certthrudate2
        or o.eb_benfi_address2 <> n.eb_benfi_address2
        or o.eb_benfi_name3 <> n.eb_benfi_name3
        or o.eb_benfi_position3 <> n.eb_benfi_position3
        or o.eb_benfi_certtype3 <> n.eb_benfi_certtype3
        or o.eb_benfi_certno3 <> n.eb_benfi_certno3
        or o.eb_benfi_certthrudate3 <> n.eb_benfi_certthrudate3
        or o.eb_benfi_address3 <> n.eb_benfi_address3
        or o.eb_benfi_name4 <> n.eb_benfi_name4
        or o.eb_benfi_position4 <> n.eb_benfi_position4
        or o.eb_benfi_certtype4 <> n.eb_benfi_certtype4
        or o.eb_benfi_certno4 <> n.eb_benfi_certno4
        or o.eb_benfi_certthrudate4 <> n.eb_benfi_certthrudate4
        or o.eb_benfi_address4 <> n.eb_benfi_address4
        or o.eb_benfi_name5 <> n.eb_benfi_name5
        or o.eb_benfi_position5 <> n.eb_benfi_position5
        or o.eb_benfi_certtype5 <> n.eb_benfi_certtype5
        or o.eb_benfi_certno5 <> n.eb_benfi_certno5
        or o.eb_benfi_certthrudate5 <> n.eb_benfi_certthrudate5
        or o.eb_benfi_address5 <> n.eb_benfi_address5
        or o.eb_control_name <> n.eb_control_name
        or o.eb_control_paperno <> n.eb_control_paperno
        or o.eb_control_paperstype <> n.eb_control_paperstype
        or o.eb_same_benfi <> n.eb_same_benfi
        or o.eb_controller <> n.eb_controller
        or o.eb_control_paperdt <> n.eb_control_paperdt
        or o.er_cop_name <> n.er_cop_name
        or o.er_incidence_relation <> n.er_incidence_relation
        or o.er_principal_name <> n.er_principal_name
        or o.er_organiz_code <> n.er_organiz_code
        or o.es_main_account <> n.es_main_account
        or o.ct_croler1_name <> n.ct_croler1_name
        or o.ct_croler1_taxarea_nober1 <> n.ct_croler1_taxarea_nober1
        or o.ct_croler1_taxnullreason1 <> n.ct_croler1_taxnullreason1
        or o.ct_croler1_type <> n.ct_croler1_type
        or o.ct_croler1_englishname <> n.ct_croler1_englishname
        or o.ct_croler1_tax_resident <> n.ct_croler1_tax_resident
        or o.ct_croler1_address <> n.ct_croler1_address
        or o.ct_croler1_taxarea_nober2 <> n.ct_croler1_taxarea_nober2
        or o.ct_croler1_taxarea_nober3 <> n.ct_croler1_taxarea_nober3
        or o.ct_croler1_birthday <> n.ct_croler1_birthday
        or o.ct_croler1_taxnullreason2 <> n.ct_croler1_taxnullreason2
        or o.ct_croler1_taxnullreason3 <> n.ct_croler1_taxnullreason3
        or o.ct_croler_birth_place <> n.ct_croler_birth_place
        or o.ct_croler2_name <> n.ct_croler2_name
        or o.ct_croler2_englishname <> n.ct_croler2_englishname
        or o.ct_croler2_type <> n.ct_croler2_type
        or o.ct_croler2_tax_resident <> n.ct_croler2_tax_resident
        or o.ct_croler2_birthday <> n.ct_croler2_birthday
        or o.ct_croler2_address <> n.ct_croler2_address
        or o.ct_croler2_taxarea_nober1 <> n.ct_croler2_taxarea_nober1
        or o.ct_croler2_taxarea_nober2 <> n.ct_croler2_taxarea_nober2
        or o.ct_croler2_taxarea_nober3 <> n.ct_croler2_taxarea_nober3
        or o.ct_croler2_taxnullreason1 <> n.ct_croler2_taxnullreason1
        or o.ct_croler2_taxnullreason2 <> n.ct_croler2_taxnullreason2
        or o.ct_croler2_taxnullreason3 <> n.ct_croler2_taxnullreason3
        or o.ct_croler2_birth_place <> n.ct_croler2_birth_place
        or o.ct_croler3_name <> n.ct_croler3_name
        or o.ct_croler3_englishname <> n.ct_croler3_englishname
        or o.ct_croler3_type <> n.ct_croler3_type
        or o.ct_croler3_tax_resident <> n.ct_croler3_tax_resident
        or o.ct_croler3_birthday <> n.ct_croler3_birthday
        or o.ct_croler3_address <> n.ct_croler3_address
        or o.ct_croler3_taxarea_nober1 <> n.ct_croler3_taxarea_nober1
        or o.ct_croler3_taxarea_nober2 <> n.ct_croler3_taxarea_nober2
        or o.ct_croler3_taxarea_nober3 <> n.ct_croler3_taxarea_nober3
        or o.ct_croler3_taxnullreason1 <> n.ct_croler3_taxnullreason1
        or o.ct_croler3_taxnullreason2 <> n.ct_croler3_taxnullreason2
        or o.ct_croler3_taxnullreason3 <> n.ct_croler3_taxnullreason3
        or o.ct_croler3_birth_place <> n.ct_croler3_birth_place
        or o.bq_trust_name1 <> n.bq_trust_name1
        or o.bq_trust_certtype1 <> n.bq_trust_certtype1
        or o.bq_trust_certno1 <> n.bq_trust_certno1
        or o.bq_trust_name2 <> n.bq_trust_name2
        or o.bq_trust_certtype2 <> n.bq_trust_certtype2
        or o.bq_trust_certno2 <> n.bq_trust_certno2
        or o.bq_accredit_name1 <> n.bq_accredit_name1
        or o.bq_accredit_certtype1 <> n.bq_accredit_certtype1
        or o.bq_accredit_certno1 <> n.bq_accredit_certno1
        or o.bq_accredit_name2 <> n.bq_accredit_name2
        or o.bq_accredit_certtype2 <> n.bq_accredit_certtype2
        or o.bq_accredit_certno2 <> n.bq_accredit_certno2
        or o.frozen_flag <> n.frozen_flag
        or o.acct_no <> n.acct_no
        or o.visit_service <> n.visit_service
        or o.check_type <> n.check_type
        or o.account_active_flag <> n.account_active_flag
        or o.if_public_seal <> n.if_public_seal
        or o.if_seal <> n.if_seal
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.proxy_name <> n.proxy_name
        or o.proxy_papers_type <> n.proxy_papers_type
        or o.proxy_papers_number <> n.proxy_papers_number
        or o.trans_state <> n.trans_state
        or o.acct_cancel_date <> n.acct_cancel_date
        or o.is_local_check <> n.is_local_check
        or o.acct_open_channel <> n.acct_open_channel
        or o.charge_id <> n.charge_id
        or o.is_upload_new_form <> n.is_upload_new_form
        or o.doc_id <> n.doc_id
        or o.is_check <> n.is_check
        or o.zone_cd <> n.zone_cd
        or o.reg_cap_ccy <> n.reg_cap_ccy
        or o.dirt_unt_lp_typ <> n.dirt_unt_lp_typ
        or o.rec_type <> n.rec_type
        or o.rpa_related_corp1 <> n.rpa_related_corp1
        or o.rpa_related_corp2 <> n.rpa_related_corp2
        or o.rpa_related_corp3 <> n.rpa_related_corp3
        or o.rpa_related_corp4 <> n.rpa_related_corp4
        or o.rpa_related_corp5 <> n.rpa_related_corp5
        or o.rpa_related_corp6 <> n.rpa_related_corp6
        or o.rpa_related_corp7 <> n.rpa_related_corp7
        or o.rpa_related_corp8 <> n.rpa_related_corp8
        or o.rpa_related_corp9 <> n.rpa_related_corp9
        or o.rpa_related_corp10 <> n.rpa_related_corp10
        or o.rpa_corper_name1 <> n.rpa_corper_name1
        or o.rpa_corper_name2 <> n.rpa_corper_name2
        or o.rpa_corper_name3 <> n.rpa_corper_name3
        or o.rpa_corper_name4 <> n.rpa_corper_name4
        or o.rpa_corper_name5 <> n.rpa_corper_name5
        or o.rpa_corper_name6 <> n.rpa_corper_name6
        or o.rpa_corper_name7 <> n.rpa_corper_name7
        or o.rpa_corper_name8 <> n.rpa_corper_name8
        or o.rpa_corper_name9 <> n.rpa_corper_name9
        or o.rpa_corper_name10 <> n.rpa_corper_name10
        or o.rpa_organze_code1 <> n.rpa_organze_code1
        or o.rpa_organze_code2 <> n.rpa_organze_code2
        or o.rpa_organze_code3 <> n.rpa_organze_code3
        or o.rpa_organze_code4 <> n.rpa_organze_code4
        or o.rpa_organze_code5 <> n.rpa_organze_code5
        or o.rpa_organze_code6 <> n.rpa_organze_code6
        or o.rpa_organze_code7 <> n.rpa_organze_code7
        or o.rpa_organze_code8 <> n.rpa_organze_code8
        or o.rpa_organze_code9 <> n.rpa_organze_code9
        or o.rpa_organze_code10 <> n.rpa_organze_code10
        or o.proxy_phone <> n.proxy_phone
        or o.proxy_invaldt <> n.proxy_invaldt
        or o.is_proxy <> n.is_proxy
        or o.is_bs_flag <> n.is_bs_flag
        or o.is_rpa_check <> n.is_rpa_check
        or o.business_type <> n.business_type
        or o.found_date <> n.found_date
        or o.people_area_code <> n.people_area_code
        or o.usw_flg <> n.usw_flg
        or o.ccy <> n.ccy
        or o.prd_typ <> n.prd_typ
        or o.check_dt <> n.check_dt
        or o.bad_check_black <> n.bad_check_black
        or o.ea_legal_end <> n.ea_legal_end
        or o.ea_work_address <> n.ea_work_address
        or o.eb_name <> n.eb_name
        or o.ei_check_certificate_amt <> n.ei_check_certificate_amt
        or o.ei_unit_name <> n.ei_unit_name
        or o.enter_firstparty <> n.enter_firstparty
        or o.util_first_party <> n.util_first_party
        or o.trade_code <> n.trade_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_corporate_tb_cl(
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
            ,people_area_code -- 人行地区代码
            ,usw_flg -- 通存通兑
            ,ccy -- 币种
            ,prd_typ -- 产品类型
            ,check_dt -- 核准日期
            ,bad_check_black -- 空头支票黑名单状态
            ,ea_legal_end -- 法人/负责人证件有效期结束日
            ,ea_work_address -- 办公地址
            ,eb_name -- 受益所有人客户名称
            ,ei_check_certificate_amt -- 设置查证金额
            ,ei_unit_name -- 单位名称
            ,enter_firstparty -- 企业银行账户管理协议（甲方）
            ,util_first_party -- 单位银行账户管理协议（甲方）
            ,trade_code -- 国民经济行业分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_corporate_tb_op(
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
            ,people_area_code -- 人行地区代码
            ,usw_flg -- 通存通兑
            ,ccy -- 币种
            ,prd_typ -- 产品类型
            ,check_dt -- 核准日期
            ,bad_check_black -- 空头支票黑名单状态
            ,ea_legal_end -- 法人/负责人证件有效期结束日
            ,ea_work_address -- 办公地址
            ,eb_name -- 受益所有人客户名称
            ,ei_check_certificate_amt -- 设置查证金额
            ,ei_unit_name -- 单位名称
            ,enter_firstparty -- 企业银行账户管理协议（甲方）
            ,util_first_party -- 单位银行账户管理协议（甲方）
            ,trade_code -- 国民经济行业分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.glob_seq_num -- 全局流水号
    ,o.acct_open_date -- 客户开户日期
    ,o.organ_no -- 发起机构号
    ,o.user_no -- 发起柜员
    ,o.user_enable -- 开户状态（0处理中，1记账完成）
    ,o.ea_phone -- 联系电话
    ,o.ea_register_address -- 注册地址
    ,o.ea_post_code -- 邮编
    ,o.ea_trade_type -- 所属行业类型
    ,o.ea_register_fund -- 注册资本
    ,o.ea_fund_quality -- 资金性质
    ,o.ea_operate_scope -- 经营范围
    ,o.ea_tempacctdt_end -- 临时户有效日期至
    ,o.ea_legal_rep -- 法定代表人或单位负责人姓名
    ,o.ea_upcrna -- 上级法人或主管单位名称
    ,o.ea_company_approve_no -- 上级法人或主管基本存款账户开户许可证核准号
    ,o.ea_compay_fin_name -- 上级法人/主管姓名
    ,o.ea_f_company_fin_paptype -- 上级法人/主管证件种类
    ,o.ea_f_company_fin_papno -- 上级法人/主管证件号码
    ,o.ea_deposit_type -- 存款人类别
    ,o.ea_attor_oprno -- 客户经理编号
    ,o.ea_papers_type2 -- 第二证明文件类型
    ,o.ea_tax_certno -- 国税登记证编号/地税登记证编号
    ,o.ea_company_fin_papno -- 法人/负责人证件号码
    ,o.ea_company_fin_paptype -- 法人/负责人证件种类
    ,o.ea_legal_iddt -- 法人/负责人证件生效日期
    ,o.ea_deposit_name -- 存款人名称
    ,o.ea_acct_name -- 账户名称
    ,o.ea_certcode -- 法人/负责人开户许可证核准号/基本存款账户编号
    ,o.ea_pre_seqno -- 预受理编号
    ,o.ea_perpers_inval_type1 -- 第一证明文件类型
    ,o.ea_perpers_inval_code1 -- 第一证明文件编号
    ,o.ea_perpers_inval_date1 -- 第一证明文件到期日
    ,o.ea_papers_type -- 第一证件类型
    ,o.ea_compay_organiz_code -- 上级法人或主管单位证明文件编号
    ,o.ea_country -- 国家和地区
    ,o.ea_corp_org_type -- 机构类别
    ,o.ea_tax_resident -- 税收居民身份
    ,o.ea_acct_char -- 账户性质
    ,o.ea_perpers_inval_code2 -- 第二证明文件编号
    ,o.ea_perpers_inval_date2 -- 第二证明文件到期日
    ,o.ei_year_limit -- 年累计限额
    ,o.ei_business_flow -- 业务流程设置
    ,o.ei_sign_mobile -- 签约手机号码
    ,o.ei_seal_mode -- 银企验印方式（对账单加盖印章种类）
    ,o.ei_mail_address -- 银企邮寄地址
    ,o.ei_bczipcd -- 银企邮编
    ,o.ei_linkman -- 银企联系人
    ,o.ei_linktel -- 银企联系电话
    ,o.ei_sendmode -- 银企对账方式
    ,o.ei_acccycle -- 银企对账周期
    ,o.ei_day_limit -- 日累计限额
    ,o.ei_day_times -- 日累计笔数
    ,o.ei_application -- 基本服务申请
    ,o.ei_call_type -- 查证类型
    ,o.ei_accredit_legal_name -- 查证法定代表人(单位负责人)姓名
    ,o.ei_accredit_legal_tel -- 查证法定代表人/单位负责人手机号码
    ,o.ei_accredit_legal_phone -- 查证法定代表人/单位负责人固定电话
    ,o.ei_principal_checkorder -- 查证人顺序
    ,o.ei_principal_funds_check -- 资金查证人（至少两名）
    ,o.ei_mainfin_contect_name -- 财务负责人姓名
    ,o.ei_mainfin_contect_tel -- 财务负责人手机号码
    ,o.ei_mainfin_contect_phone -- 财务负责人固定电话
    ,o.ei_fin_contect_checkorder -- 查证人顺序
    ,o.ei_fin_contect_funds_check -- 资金查证人（至少两名）
    ,o.ei_fin_contect_name1 -- 财务人员1姓名
    ,o.ei_fin_contect_tel1 -- 财务人员1手机号码
    ,o.ei_fin_contect_phone1 -- 财务人员1固定电话
    ,o.ei_chrg_check1_order -- 查证人顺序
    ,o.ei_chrg_funds_check1 -- 资金查证人（至少两名）
    ,o.ei_fin_contect_name2 -- 财务人员2姓名
    ,o.ei_fin_contect_tel2 -- 财务人员2手机号码
    ,o.ei_fin_contect_phone2 -- 财务人员2固定电话
    ,o.ei_chrg_check2_order -- 查证人顺序
    ,o.ei_chrg_funds_check2 -- 资金查证人（至少两名）
    ,o.em_organize_name -- 【机构】机构名称
    ,o.em_corp_corporgtype -- 【机构】类别
    ,o.em_tax_resident_type -- 【机构】税收居民身份类型
    ,o.em_taxarea_taxno1 -- 【机构】税收居民国地区与纳税人识别号①
    ,o.em_taxarea_taxno2 -- 【机构】税收居民国地区与纳税人识别号②
    ,o.em_taxarea_taxno3 -- 【机构】税收居民国地区与纳税人识别号③
    ,o.em_per_tax_null_reason1 -- 【机构】不能提供识别号的原因①
    ,o.em_per_tax_null_reason2 -- 【机构】不能提供识别号的原因②
    ,o.em_per_tax_null_reason3 -- 【机构】不能提供识别号的原因③
    ,o.em_organize_address -- 【机构】机构地址
    ,o.em_tax_english_name -- 【机构】英文名称
    ,o.eb_benfi_company_type -- 受益所有人企业所属类别
    ,o.eb_benfi_type -- 受益所有人类型
    ,o.eb_benfi_name1 -- 受益所有人1姓名
    ,o.eb_benfi_position1 -- 受益所有人1职务
    ,o.eb_benfi_certtype1 -- 受益所有人1证件类型
    ,o.eb_benfi_certno1 -- 受益所有人1证件号码
    ,o.eb_benfi_certthrudate1 -- 证件生效日期
    ,o.eb_benfi_address1 -- 受益所有人1联系地址
    ,o.eb_benfi_name2 -- 受益所有人2姓名
    ,o.eb_benfi_position2 -- 受益所有人2职务
    ,o.eb_benfi_certtype2 -- 受益所有人2证件类型
    ,o.eb_benfi_certno2 -- 受益所有人2证件号码
    ,o.eb_benfi_certthrudate2 -- 证件生效日期
    ,o.eb_benfi_address2 -- 受益所有人2联系地址
    ,o.eb_benfi_name3 -- 受益所有人3姓名
    ,o.eb_benfi_position3 -- 受益所有人3职务
    ,o.eb_benfi_certtype3 -- 受益所有人3证件类型
    ,o.eb_benfi_certno3 -- 受益所有人3证件号码
    ,o.eb_benfi_certthrudate3 -- 证件生效日期
    ,o.eb_benfi_address3 -- 受益所有人3联系地址
    ,o.eb_benfi_name4 -- 受益所有人4姓名
    ,o.eb_benfi_position4 -- 受益所有人4职务
    ,o.eb_benfi_certtype4 -- 受益所有人4证件类型
    ,o.eb_benfi_certno4 -- 受益所有人4证件号码
    ,o.eb_benfi_certthrudate4 -- 证件生效日期
    ,o.eb_benfi_address4 -- 受益所有人4联系地址
    ,o.eb_benfi_name5 -- 受益所有人5姓名
    ,o.eb_benfi_position5 -- 受益所有人5职务
    ,o.eb_benfi_certtype5 -- 受益所有人5证件类型
    ,o.eb_benfi_certno5 -- 受益所有人5证件号码
    ,o.eb_benfi_certthrudate5 -- 证件生效日期
    ,o.eb_benfi_address5 -- 受益所有人5联系地址
    ,o.eb_control_name -- 股东名称
    ,o.eb_control_paperno -- 控股股东/实际控制人证件号码
    ,o.eb_control_paperstype -- 控股股东/实际控制人证件类型
    ,o.eb_same_benfi -- 同受益所有人
    ,o.eb_controller -- 控制人/控股股东
    ,o.eb_control_paperdt -- 控股股东/实际控制人有效期
    ,o.er_cop_name -- 关联企业名称
    ,o.er_incidence_relation -- 关联关系类型
    ,o.er_principal_name -- 关联企业法定代表人名称
    ,o.er_organiz_code -- 关联企业组织机构代码
    ,o.es_main_account -- 主账号
    ,o.ct_croler1_name -- 【控制人①】姓名
    ,o.ct_croler1_taxarea_nober1 -- 【控制人①】税收居民国（地区）和纳税人识别号①
    ,o.ct_croler1_taxnullreason1 -- 【控制人①】不能提供识别号的原因①
    ,o.ct_croler1_type -- 【控制人①】控制人类型
    ,o.ct_croler1_englishname -- 【控制人①】姓与名（英文或拼音）
    ,o.ct_croler1_tax_resident -- 【控制人①】税收居民身份
    ,o.ct_croler1_address -- 【控制人①】现居地址
    ,o.ct_croler1_taxarea_nober2 -- 【控制人①】税收居民国（地区）和纳税人识别号②
    ,o.ct_croler1_taxarea_nober3 -- 【控制人①】税收居民国（地区）和纳税人识别号③
    ,o.ct_croler1_birthday -- 【控制人①】出生日期
    ,o.ct_croler1_taxnullreason2 -- 【控制人①】不能提供识别号的原因②
    ,o.ct_croler1_taxnullreason3 -- 【控制人①】不能提供识别号的原因③
    ,o.ct_croler_birth_place -- 【控制人①】出生地址
    ,o.ct_croler2_name -- 【控制人②】姓名
    ,o.ct_croler2_englishname -- 【控制人②】姓与名（英文或拼音）
    ,o.ct_croler2_type -- 【控制人②】控制人类型
    ,o.ct_croler2_tax_resident -- 【控制人②】税收居民身份
    ,o.ct_croler2_birthday -- 【控制人②】出生日期
    ,o.ct_croler2_address -- 【控制人②】现居地址
    ,o.ct_croler2_taxarea_nober1 -- 【控制人②】税收居民国（地区）和纳税人识别号①
    ,o.ct_croler2_taxarea_nober2 -- 【控制人②】税收居民国（地区）和纳税人识别号②
    ,o.ct_croler2_taxarea_nober3 -- 【控制人②】税收居民国（地区）和纳税人识别号③
    ,o.ct_croler2_taxnullreason1 -- 【控制人②】不能提供识别号的原因①
    ,o.ct_croler2_taxnullreason2 -- 【控制人②】不能提供识别号的原因②
    ,o.ct_croler2_taxnullreason3 -- 【控制人②】不能提供识别号的原因③
    ,o.ct_croler2_birth_place -- 【控制人②】出生地址
    ,o.ct_croler3_name -- 【控制人③】姓名
    ,o.ct_croler3_englishname -- 【控制人③】姓与名（英文或拼音）
    ,o.ct_croler3_type -- 【控制人③】控制人类型
    ,o.ct_croler3_tax_resident -- 【控制人③】税收居民身份
    ,o.ct_croler3_birthday -- 【控制人③】出生日期
    ,o.ct_croler3_address -- 【控制人③】现居地址
    ,o.ct_croler3_taxarea_nober1 -- 【控制人③】税收居民国（地区）和纳税人识别号①
    ,o.ct_croler3_taxarea_nober2 -- 【控制人③】税收居民国（地区）和纳税人识别号②
    ,o.ct_croler3_taxarea_nober3 -- 【控制人③】税收居民国（地区）和纳税人识别号③
    ,o.ct_croler3_taxnullreason1 -- 【控制人③】不能提供识别号的原因①
    ,o.ct_croler3_taxnullreason2 -- 【控制人③】不能提供识别号的原因②
    ,o.ct_croler3_taxnullreason3 -- 【控制人③】不能提供识别号的原因③
    ,o.ct_croler3_birth_place -- 【控制人③】出生地址
    ,o.bq_trust_name1 -- 受委托人1姓名
    ,o.bq_trust_certtype1 -- 受委托人1证件种类
    ,o.bq_trust_certno1 -- 受委托人1证件号码
    ,o.bq_trust_name2 -- 受委托人2姓名
    ,o.bq_trust_certtype2 -- 受委托人2证件种类
    ,o.bq_trust_certno2 -- 受委托人2证件号码
    ,o.bq_accredit_name1 -- 被授权人1姓名
    ,o.bq_accredit_certtype1 -- 被授权人1证件种类
    ,o.bq_accredit_certno1 -- 被授权人1证件号码
    ,o.bq_accredit_name2 -- 被授权人2姓名
    ,o.bq_accredit_certtype2 -- 被授权人2证件种类
    ,o.bq_accredit_certno2 -- 被授权人2证件号码
    ,o.frozen_flag -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,o.acct_no -- 账号
    ,o.visit_service -- 上门服务(0:否 1：是)
    ,o.check_type -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,o.account_active_flag -- 账户激活标志 1-已激活 2-激活失败 0-未激活
    ,o.if_public_seal -- 是否共用验印(1-是 0-否)
    ,o.if_seal -- 是否倒验(1-是 0-否)
    ,o.cust_no -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.proxy_name -- 代理人姓名
    ,o.proxy_papers_type -- 代理人证件类型
    ,o.proxy_papers_number -- 代理人证件号码
    ,o.trans_state -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,o.acct_cancel_date -- 客户销户日期
    ,o.is_local_check -- 是否双异地(1-是 0-否)
    ,o.acct_open_channel -- 开户渠道
    ,o.charge_id -- 审核柜员
    ,o.is_upload_new_form -- 是否上传系统最新表单(0-否 1-是)
    ,o.doc_id -- 影像批次号
    ,o.is_check -- 是否核准（1-是 0-否，用于报备RPA）
    ,o.zone_cd -- 注册地区代码
    ,o.reg_cap_ccy -- 注册资金币种
    ,o.dirt_unt_lp_typ -- 上级法人或主管单位信息（1-法定代表人 2-单位负责人）
    ,o.rec_type -- 备案类型： 0本地备案1异地备案
    ,o.rpa_related_corp1 -- 关联企业名称_1
    ,o.rpa_related_corp2 -- 关联企业名称_2
    ,o.rpa_related_corp3 -- 关联企业名称_3
    ,o.rpa_related_corp4 -- 关联企业名称_4
    ,o.rpa_related_corp5 -- 关联企业名称_5
    ,o.rpa_related_corp6 -- 关联企业名称_6
    ,o.rpa_related_corp7 -- 关联企业名称_7
    ,o.rpa_related_corp8 -- 关联企业名称_8
    ,o.rpa_related_corp9 -- 关联企业名称_9
    ,o.rpa_related_corp10 -- 关联企业名称_10
    ,o.rpa_corper_name1 -- 1法定代表人名称
    ,o.rpa_corper_name2 -- 2法定代表人名称
    ,o.rpa_corper_name3 -- 3法定代表人名称
    ,o.rpa_corper_name4 -- 4法定代表人名称
    ,o.rpa_corper_name5 -- 5法定代表人名称
    ,o.rpa_corper_name6 -- 6法定代表人名称
    ,o.rpa_corper_name7 -- 7法定代表人名称
    ,o.rpa_corper_name8 -- 8法定代表人名称
    ,o.rpa_corper_name9 -- 9法定代表人名称
    ,o.rpa_corper_name10 -- 10法定代表人名称
    ,o.rpa_organze_code1 -- 组织机构代码_1
    ,o.rpa_organze_code2 -- 组织机构代码_2
    ,o.rpa_organze_code3 -- 组织机构代码_3
    ,o.rpa_organze_code4 -- 组织机构代码_4
    ,o.rpa_organze_code5 -- 组织机构代码_5
    ,o.rpa_organze_code6 -- 组织机构代码_6
    ,o.rpa_organze_code7 -- 组织机构代码_7
    ,o.rpa_organze_code8 -- 组织机构代码_8
    ,o.rpa_organze_code9 -- 组织机构代码_9
    ,o.rpa_organze_code10 -- 组织机构代码_10
    ,o.proxy_phone -- 交易代办人联系电话
    ,o.proxy_invaldt -- 代理人证件有效期
    ,o.is_proxy -- 是否代理（1-是，2-否）
    ,o.is_bs_flag -- 事后补扫是否完成,0-未完成，1-完成
    ,o.is_rpa_check -- 是否经过rpa核查（1-是，0-否）
    ,o.business_type -- 业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））
    ,o.found_date -- 成立日期（营业执照）
    ,o.people_area_code -- 人行地区代码
    ,o.usw_flg -- 通存通兑
    ,o.ccy -- 币种
    ,o.prd_typ -- 产品类型
    ,o.check_dt -- 核准日期
    ,o.bad_check_black -- 空头支票黑名单状态
    ,o.ea_legal_end -- 法人/负责人证件有效期结束日
    ,o.ea_work_address -- 办公地址
    ,o.eb_name -- 受益所有人客户名称
    ,o.ei_check_certificate_amt -- 设置查证金额
    ,o.ei_unit_name -- 单位名称
    ,o.enter_firstparty -- 企业银行账户管理协议（甲方）
    ,o.util_first_party -- 单位银行账户管理协议（甲方）
    ,o.trade_code -- 国民经济行业分类
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_corporate_tb_bk o
    left join ${iol_schema}.scps_bp_corporate_tb_op n
        on
            o.task_id = n.task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_corporate_tb_cl d
        on
            o.task_id = d.task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_corporate_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_corporate_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_corporate_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_corporate_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_corporate_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_corporate_tb_cl;
alter table ${iol_schema}.scps_bp_corporate_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_corporate_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_corporate_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_corporate_tb_op purge;
drop table ${iol_schema}.scps_bp_corporate_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_corporate_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_corporate_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
