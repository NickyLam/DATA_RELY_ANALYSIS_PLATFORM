/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_corporate_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_corporate_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_corporate_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_corporate_tb(
    task_id varchar2(50) -- 任务号
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,acct_open_date date -- 客户开户日期
    ,organ_no varchar2(50) -- 发起机构号
    ,user_no varchar2(30) -- 发起柜员
    ,user_enable varchar2(1) -- 开户状态（0处理中，1记账完成）
    ,ea_phone varchar2(30) -- 联系电话
    ,ea_register_address varchar2(400) -- 注册地址
    ,ea_post_code varchar2(10) -- 邮编
    ,ea_trade_type varchar2(5) -- 所属行业类型
    ,ea_register_fund number(20,2) -- 注册资本
    ,ea_fund_quality varchar2(50) -- 资金性质
    ,ea_operate_scope varchar2(4000) -- 经营范围
    ,ea_tempacctdt_end date -- 临时户有效日期至
    ,ea_legal_rep varchar2(200) -- 法定代表人或单位负责人姓名
    ,ea_upcrna varchar2(200) -- 上级法人或主管单位名称
    ,ea_company_approve_no varchar2(50) -- 上级法人或主管基本存款账户开户许可证核准号
    ,ea_compay_fin_name varchar2(200) -- 上级法人/主管姓名
    ,ea_f_company_fin_paptype varchar2(50) -- 上级法人/主管证件种类
    ,ea_f_company_fin_papno varchar2(60) -- 上级法人/主管证件号码
    ,ea_deposit_type varchar2(3) -- 存款人类别
    ,ea_attor_oprno varchar2(8) -- 客户经理编号
    ,ea_papers_type2 varchar2(50) -- 第二证明文件类型
    ,ea_tax_certno varchar2(50) -- 国税登记证编号/地税登记证编号
    ,ea_company_fin_papno varchar2(60) -- 法人/负责人证件号码
    ,ea_company_fin_paptype varchar2(50) -- 法人/负责人证件种类
    ,ea_legal_iddt date -- 法人/负责人证件生效日期
    ,ea_deposit_name varchar2(200) -- 存款人名称
    ,ea_acct_name varchar2(200) -- 账户名称
    ,ea_certcode varchar2(50) -- 法人/负责人开户许可证核准号/基本存款账户编号
    ,ea_pre_seqno varchar2(50) -- 预受理编号
    ,ea_perpers_inval_type1 varchar2(50) -- 第一证明文件类型
    ,ea_perpers_inval_code1 varchar2(50) -- 第一证明文件编号
    ,ea_perpers_inval_date1 date -- 第一证明文件到期日
    ,ea_papers_type varchar2(4) -- 第一证件类型
    ,ea_compay_organiz_code varchar2(50) -- 上级法人或主管单位证明文件编号
    ,ea_country varchar2(3) -- 国家和地区
    ,ea_corp_org_type varchar2(50) -- 机构类别
    ,ea_tax_resident varchar2(50) -- 税收居民身份
    ,ea_acct_char varchar2(50) -- 账户性质
    ,ea_perpers_inval_code2 varchar2(50) -- 第二证明文件编号
    ,ea_perpers_inval_date2 date -- 第二证明文件到期日
    ,ei_year_limit varchar2(50) -- 年累计限额
    ,ei_business_flow varchar2(50) -- 业务流程设置
    ,ei_sign_mobile varchar2(30) -- 签约手机号码
    ,ei_seal_mode varchar2(50) -- 银企验印方式（对账单加盖印章种类）
    ,ei_mail_address varchar2(400) -- 银企邮寄地址
    ,ei_bczipcd varchar2(50) -- 银企邮编
    ,ei_linkman varchar2(50) -- 银企联系人
    ,ei_linktel varchar2(30) -- 银企联系电话
    ,ei_sendmode varchar2(50) -- 银企对账方式
    ,ei_acccycle varchar2(50) -- 银企对账周期
    ,ei_day_limit varchar2(50) -- 日累计限额
    ,ei_day_times varchar2(50) -- 日累计笔数
    ,ei_application varchar2(50) -- 基本服务申请
    ,ei_call_type varchar2(50) -- 查证类型
    ,ei_accredit_legal_name varchar2(200) -- 查证法定代表人(单位负责人)姓名
    ,ei_accredit_legal_tel varchar2(30) -- 查证法定代表人/单位负责人手机号码
    ,ei_accredit_legal_phone varchar2(30) -- 查证法定代表人/单位负责人固定电话
    ,ei_principal_checkorder varchar2(50) -- 查证人顺序
    ,ei_principal_funds_check varchar2(50) -- 资金查证人（至少两名）
    ,ei_mainfin_contect_name varchar2(50) -- 财务负责人姓名
    ,ei_mainfin_contect_tel varchar2(30) -- 财务负责人手机号码
    ,ei_mainfin_contect_phone varchar2(30) -- 财务负责人固定电话
    ,ei_fin_contect_checkorder varchar2(50) -- 查证人顺序
    ,ei_fin_contect_funds_check varchar2(50) -- 资金查证人（至少两名）
    ,ei_fin_contect_name1 varchar2(200) -- 财务人员1姓名
    ,ei_fin_contect_tel1 varchar2(30) -- 财务人员1手机号码
    ,ei_fin_contect_phone1 varchar2(30) -- 财务人员1固定电话
    ,ei_chrg_check1_order varchar2(50) -- 查证人顺序
    ,ei_chrg_funds_check1 varchar2(50) -- 资金查证人（至少两名）
    ,ei_fin_contect_name2 varchar2(200) -- 财务人员2姓名
    ,ei_fin_contect_tel2 varchar2(30) -- 财务人员2手机号码
    ,ei_fin_contect_phone2 varchar2(30) -- 财务人员2固定电话
    ,ei_chrg_check2_order varchar2(50) -- 查证人顺序
    ,ei_chrg_funds_check2 varchar2(50) -- 资金查证人（至少两名）
    ,em_organize_name varchar2(200) -- 【机构】机构名称
    ,em_corp_corporgtype varchar2(50) -- 【机构】类别
    ,em_tax_resident_type varchar2(50) -- 【机构】税收居民身份类型
    ,em_taxarea_taxno1 varchar2(50) -- 【机构】税收居民国地区与纳税人识别号①
    ,em_taxarea_taxno2 varchar2(50) -- 【机构】税收居民国地区与纳税人识别号②
    ,em_taxarea_taxno3 varchar2(50) -- 【机构】税收居民国地区与纳税人识别号③
    ,em_per_tax_null_reason1 varchar2(200) -- 【机构】不能提供识别号的原因①
    ,em_per_tax_null_reason2 varchar2(200) -- 【机构】不能提供识别号的原因②
    ,em_per_tax_null_reason3 varchar2(200) -- 【机构】不能提供识别号的原因③
    ,em_organize_address varchar2(400) -- 【机构】机构地址
    ,em_tax_english_name varchar2(200) -- 【机构】英文名称
    ,eb_benfi_company_type varchar2(50) -- 受益所有人企业所属类别
    ,eb_benfi_type varchar2(50) -- 受益所有人类型
    ,eb_benfi_name1 varchar2(200) -- 受益所有人1姓名
    ,eb_benfi_position1 varchar2(1) -- 受益所有人1职务
    ,eb_benfi_certtype1 varchar2(4) -- 受益所有人1证件类型
    ,eb_benfi_certno1 varchar2(60) -- 受益所有人1证件号码
    ,eb_benfi_certthrudate1 date -- 证件生效日期
    ,eb_benfi_address1 varchar2(400) -- 受益所有人1联系地址
    ,eb_benfi_name2 varchar2(200) -- 受益所有人2姓名
    ,eb_benfi_position2 varchar2(1) -- 受益所有人2职务
    ,eb_benfi_certtype2 varchar2(4) -- 受益所有人2证件类型
    ,eb_benfi_certno2 varchar2(60) -- 受益所有人2证件号码
    ,eb_benfi_certthrudate2 date -- 证件生效日期
    ,eb_benfi_address2 varchar2(400) -- 受益所有人2联系地址
    ,eb_benfi_name3 varchar2(200) -- 受益所有人3姓名
    ,eb_benfi_position3 varchar2(1) -- 受益所有人3职务
    ,eb_benfi_certtype3 varchar2(4) -- 受益所有人3证件类型
    ,eb_benfi_certno3 varchar2(60) -- 受益所有人3证件号码
    ,eb_benfi_certthrudate3 date -- 证件生效日期
    ,eb_benfi_address3 varchar2(400) -- 受益所有人3联系地址
    ,eb_benfi_name4 varchar2(200) -- 受益所有人4姓名
    ,eb_benfi_position4 varchar2(1) -- 受益所有人4职务
    ,eb_benfi_certtype4 varchar2(4) -- 受益所有人4证件类型
    ,eb_benfi_certno4 varchar2(60) -- 受益所有人4证件号码
    ,eb_benfi_certthrudate4 date -- 证件生效日期
    ,eb_benfi_address4 varchar2(400) -- 受益所有人4联系地址
    ,eb_benfi_name5 varchar2(200) -- 受益所有人5姓名
    ,eb_benfi_position5 varchar2(1) -- 受益所有人5职务
    ,eb_benfi_certtype5 varchar2(4) -- 受益所有人5证件类型
    ,eb_benfi_certno5 varchar2(60) -- 受益所有人5证件号码
    ,eb_benfi_certthrudate5 date -- 证件生效日期
    ,eb_benfi_address5 varchar2(400) -- 受益所有人5联系地址
    ,eb_control_name varchar2(200) -- 股东名称
    ,eb_control_paperno varchar2(60) -- 控股股东/实际控制人证件号码
    ,eb_control_paperstype varchar2(4) -- 控股股东/实际控制人证件类型
    ,eb_same_benfi varchar2(50) -- 同受益所有人
    ,eb_controller varchar2(50) -- 控制人/控股股东
    ,eb_control_paperdt varchar2(50) -- 控股股东/实际控制人有效期
    ,er_cop_name varchar2(200) -- 关联企业名称
    ,er_incidence_relation varchar2(5) -- 关联关系类型
    ,er_principal_name varchar2(200) -- 关联企业法定代表人名称
    ,er_organiz_code varchar2(50) -- 关联企业组织机构代码
    ,es_main_account varchar2(50) -- 主账号
    ,ct_croler1_name varchar2(200) -- 【控制人①】姓名
    ,ct_croler1_taxarea_nober1 varchar2(50) -- 【控制人①】税收居民国（地区）和纳税人识别号①
    ,ct_croler1_taxnullreason1 varchar2(200) -- 【控制人①】不能提供识别号的原因①
    ,ct_croler1_type varchar2(50) -- 【控制人①】控制人类型
    ,ct_croler1_englishname varchar2(200) -- 【控制人①】姓与名（英文或拼音）
    ,ct_croler1_tax_resident varchar2(50) -- 【控制人①】税收居民身份
    ,ct_croler1_address varchar2(400) -- 【控制人①】现居地址
    ,ct_croler1_taxarea_nober2 varchar2(50) -- 【控制人①】税收居民国（地区）和纳税人识别号②
    ,ct_croler1_taxarea_nober3 varchar2(50) -- 【控制人①】税收居民国（地区）和纳税人识别号③
    ,ct_croler1_birthday date -- 【控制人①】出生日期
    ,ct_croler1_taxnullreason2 varchar2(200) -- 【控制人①】不能提供识别号的原因②
    ,ct_croler1_taxnullreason3 varchar2(200) -- 【控制人①】不能提供识别号的原因③
    ,ct_croler_birth_place varchar2(400) -- 【控制人①】出生地址
    ,ct_croler2_name varchar2(200) -- 【控制人②】姓名
    ,ct_croler2_englishname varchar2(200) -- 【控制人②】姓与名（英文或拼音）
    ,ct_croler2_type varchar2(50) -- 【控制人②】控制人类型
    ,ct_croler2_tax_resident varchar2(50) -- 【控制人②】税收居民身份
    ,ct_croler2_birthday date -- 【控制人②】出生日期
    ,ct_croler2_address varchar2(400) -- 【控制人②】现居地址
    ,ct_croler2_taxarea_nober1 varchar2(50) -- 【控制人②】税收居民国（地区）和纳税人识别号①
    ,ct_croler2_taxarea_nober2 varchar2(50) -- 【控制人②】税收居民国（地区）和纳税人识别号②
    ,ct_croler2_taxarea_nober3 varchar2(50) -- 【控制人②】税收居民国（地区）和纳税人识别号③
    ,ct_croler2_taxnullreason1 varchar2(200) -- 【控制人②】不能提供识别号的原因①
    ,ct_croler2_taxnullreason2 varchar2(200) -- 【控制人②】不能提供识别号的原因②
    ,ct_croler2_taxnullreason3 varchar2(200) -- 【控制人②】不能提供识别号的原因③
    ,ct_croler2_birth_place varchar2(400) -- 【控制人②】出生地址
    ,ct_croler3_name varchar2(200) -- 【控制人③】姓名
    ,ct_croler3_englishname varchar2(200) -- 【控制人③】姓与名（英文或拼音）
    ,ct_croler3_type varchar2(50) -- 【控制人③】控制人类型
    ,ct_croler3_tax_resident varchar2(50) -- 【控制人③】税收居民身份
    ,ct_croler3_birthday date -- 【控制人③】出生日期
    ,ct_croler3_address varchar2(400) -- 【控制人③】现居地址
    ,ct_croler3_taxarea_nober1 varchar2(50) -- 【控制人③】税收居民国（地区）和纳税人识别号①
    ,ct_croler3_taxarea_nober2 varchar2(50) -- 【控制人③】税收居民国（地区）和纳税人识别号②
    ,ct_croler3_taxarea_nober3 varchar2(50) -- 【控制人③】税收居民国（地区）和纳税人识别号③
    ,ct_croler3_taxnullreason1 varchar2(200) -- 【控制人③】不能提供识别号的原因①
    ,ct_croler3_taxnullreason2 varchar2(200) -- 【控制人③】不能提供识别号的原因②
    ,ct_croler3_taxnullreason3 varchar2(200) -- 【控制人③】不能提供识别号的原因③
    ,ct_croler3_birth_place varchar2(400) -- 【控制人③】出生地址
    ,bq_trust_name1 varchar2(200) -- 受委托人1姓名
    ,bq_trust_certtype1 varchar2(50) -- 受委托人1证件种类
    ,bq_trust_certno1 varchar2(60) -- 受委托人1证件号码
    ,bq_trust_name2 varchar2(200) -- 受委托人2姓名
    ,bq_trust_certtype2 varchar2(50) -- 受委托人2证件种类
    ,bq_trust_certno2 varchar2(60) -- 受委托人2证件号码
    ,bq_accredit_name1 varchar2(200) -- 被授权人1姓名
    ,bq_accredit_certtype1 varchar2(50) -- 被授权人1证件种类
    ,bq_accredit_certno1 varchar2(60) -- 被授权人1证件号码
    ,bq_accredit_name2 varchar2(200) -- 被授权人2姓名
    ,bq_accredit_certtype2 varchar2(50) -- 被授权人2证件种类
    ,bq_accredit_certno2 varchar2(60) -- 被授权人2证件号码
    ,frozen_flag varchar2(2) -- 止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）
    ,acct_no varchar2(50) -- 账号
    ,visit_service varchar2(1) -- 上门服务(0:否 1：是)
    ,check_type varchar2(1) -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,account_active_flag varchar2(1) -- 账户激活标志 1-已激活 2-激活失败 0-未激活
    ,if_public_seal varchar2(2) -- 是否共用验印(1-是 0-否)
    ,if_seal varchar2(1) -- 是否倒验(1-是 0-否)
    ,cust_no varchar2(16) -- 客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,proxy_name varchar2(200) -- 代理人姓名
    ,proxy_papers_type varchar2(4) -- 代理人证件类型
    ,proxy_papers_number varchar2(60) -- 代理人证件号码
    ,trans_state varchar2(1) -- 处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]
    ,acct_cancel_date date -- 客户销户日期
    ,is_local_check varchar2(1) -- 是否双异地(1-是 0-否)
    ,acct_open_channel varchar2(20) -- 开户渠道
    ,charge_id varchar2(50) -- 审核柜员
    ,is_upload_new_form varchar2(1) -- 是否上传系统最新表单(0-否 1-是)
    ,doc_id varchar2(60) -- 影像批次号
    ,is_check varchar2(1) -- 是否核准（1-是 0-否，用于报备RPA）
    ,zone_cd varchar2(10) -- 注册地区代码
    ,reg_cap_ccy varchar2(8) -- 注册资金币种
    ,dirt_unt_lp_typ varchar2(1) -- 上级法人或主管单位信息（1-法定代表人 2-单位负责人）
    ,rec_type varchar2(1) -- 备案类型： 0本地备案1异地备案
    ,rpa_related_corp1 varchar2(200) -- 关联企业名称_1
    ,rpa_related_corp2 varchar2(200) -- 关联企业名称_2
    ,rpa_related_corp3 varchar2(200) -- 关联企业名称_3
    ,rpa_related_corp4 varchar2(200) -- 关联企业名称_4
    ,rpa_related_corp5 varchar2(200) -- 关联企业名称_5
    ,rpa_related_corp6 varchar2(200) -- 关联企业名称_6
    ,rpa_related_corp7 varchar2(200) -- 关联企业名称_7
    ,rpa_related_corp8 varchar2(200) -- 关联企业名称_8
    ,rpa_related_corp9 varchar2(200) -- 关联企业名称_9
    ,rpa_related_corp10 varchar2(200) -- 关联企业名称_10
    ,rpa_corper_name1 varchar2(200) -- 1法定代表人名称
    ,rpa_corper_name2 varchar2(200) -- 2法定代表人名称
    ,rpa_corper_name3 varchar2(200) -- 3法定代表人名称
    ,rpa_corper_name4 varchar2(200) -- 4法定代表人名称
    ,rpa_corper_name5 varchar2(200) -- 5法定代表人名称
    ,rpa_corper_name6 varchar2(200) -- 6法定代表人名称
    ,rpa_corper_name7 varchar2(200) -- 7法定代表人名称
    ,rpa_corper_name8 varchar2(200) -- 8法定代表人名称
    ,rpa_corper_name9 varchar2(200) -- 9法定代表人名称
    ,rpa_corper_name10 varchar2(200) -- 10法定代表人名称
    ,rpa_organze_code1 varchar2(20) -- 组织机构代码_1
    ,rpa_organze_code2 varchar2(20) -- 组织机构代码_2
    ,rpa_organze_code3 varchar2(20) -- 组织机构代码_3
    ,rpa_organze_code4 varchar2(20) -- 组织机构代码_4
    ,rpa_organze_code5 varchar2(20) -- 组织机构代码_5
    ,rpa_organze_code6 varchar2(20) -- 组织机构代码_6
    ,rpa_organze_code7 varchar2(20) -- 组织机构代码_7
    ,rpa_organze_code8 varchar2(20) -- 组织机构代码_8
    ,rpa_organze_code9 varchar2(20) -- 组织机构代码_9
    ,rpa_organze_code10 varchar2(20) -- 组织机构代码_10
    ,proxy_phone varchar2(30) -- 交易代办人联系电话
    ,proxy_invaldt date -- 代理人证件有效期
    ,is_proxy varchar2(2) -- 是否代理（1-是，2-否）
    ,is_bs_flag varchar2(1) -- 事后补扫是否完成,0-未完成，1-完成
    ,is_rpa_check varchar2(2) -- 是否经过rpa核查（1-是，0-否）
    ,business_type varchar2(10) -- 业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））
    ,found_date date -- 成立日期（营业执照）
    ,people_area_code varchar2(20) -- 人行地区代码
    ,usw_flg varchar2(2) -- 通存通兑
    ,ccy varchar2(6) -- 币种
    ,prd_typ varchar2(20) -- 产品类型
    ,check_dt varchar2(20) -- 核准日期
    ,bad_check_black varchar2(10) -- 空头支票黑名单状态
    ,ea_legal_end date -- 法人/负责人证件有效期结束日
    ,ea_work_address varchar2(200) -- 办公地址
    ,eb_name varchar2(200) -- 受益所有人客户名称
    ,ei_check_certificate_amt number(20,2) -- 设置查证金额
    ,ei_unit_name varchar2(200) -- 单位名称
    ,enter_firstparty varchar2(200) -- 企业银行账户管理协议（甲方）
    ,util_first_party varchar2(200) -- 单位银行账户管理协议（甲方）
    ,trade_code varchar2(5) -- 国民经济行业分类
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_bp_corporate_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_corporate_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_corporate_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_corporate_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_corporate_tb is '对公业务表';
comment on column ${iol_schema}.scps_bp_corporate_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_corporate_tb.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.scps_bp_corporate_tb.acct_open_date is '客户开户日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.organ_no is '发起机构号';
comment on column ${iol_schema}.scps_bp_corporate_tb.user_no is '发起柜员';
comment on column ${iol_schema}.scps_bp_corporate_tb.user_enable is '开户状态（0处理中，1记账完成）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_phone is '联系电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_register_address is '注册地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_post_code is '邮编';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_trade_type is '所属行业类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_register_fund is '注册资本';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_fund_quality is '资金性质';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_operate_scope is '经营范围';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_tempacctdt_end is '临时户有效日期至';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_legal_rep is '法定代表人或单位负责人姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_upcrna is '上级法人或主管单位名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_company_approve_no is '上级法人或主管基本存款账户开户许可证核准号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_compay_fin_name is '上级法人/主管姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_f_company_fin_paptype is '上级法人/主管证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_f_company_fin_papno is '上级法人/主管证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_deposit_type is '存款人类别';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_attor_oprno is '客户经理编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_papers_type2 is '第二证明文件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_tax_certno is '国税登记证编号/地税登记证编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_company_fin_papno is '法人/负责人证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_company_fin_paptype is '法人/负责人证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_legal_iddt is '法人/负责人证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_deposit_name is '存款人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_acct_name is '账户名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_certcode is '法人/负责人开户许可证核准号/基本存款账户编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_pre_seqno is '预受理编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_perpers_inval_type1 is '第一证明文件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_perpers_inval_code1 is '第一证明文件编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_perpers_inval_date1 is '第一证明文件到期日';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_papers_type is '第一证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_compay_organiz_code is '上级法人或主管单位证明文件编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_country is '国家和地区';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_corp_org_type is '机构类别';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_tax_resident is '税收居民身份';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_acct_char is '账户性质';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_perpers_inval_code2 is '第二证明文件编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_perpers_inval_date2 is '第二证明文件到期日';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_year_limit is '年累计限额';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_business_flow is '业务流程设置';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_sign_mobile is '签约手机号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_seal_mode is '银企验印方式（对账单加盖印章种类）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_mail_address is '银企邮寄地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_bczipcd is '银企邮编';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_linkman is '银企联系人';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_linktel is '银企联系电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_sendmode is '银企对账方式';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_acccycle is '银企对账周期';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_day_limit is '日累计限额';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_day_times is '日累计笔数';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_application is '基本服务申请';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_call_type is '查证类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_accredit_legal_name is '查证法定代表人(单位负责人)姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_accredit_legal_tel is '查证法定代表人/单位负责人手机号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_accredit_legal_phone is '查证法定代表人/单位负责人固定电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_principal_checkorder is '查证人顺序';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_principal_funds_check is '资金查证人（至少两名）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_mainfin_contect_name is '财务负责人姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_mainfin_contect_tel is '财务负责人手机号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_mainfin_contect_phone is '财务负责人固定电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_checkorder is '查证人顺序';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_funds_check is '资金查证人（至少两名）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_name1 is '财务人员1姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_tel1 is '财务人员1手机号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_phone1 is '财务人员1固定电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_chrg_check1_order is '查证人顺序';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_chrg_funds_check1 is '资金查证人（至少两名）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_name2 is '财务人员2姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_tel2 is '财务人员2手机号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_fin_contect_phone2 is '财务人员2固定电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_chrg_check2_order is '查证人顺序';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_chrg_funds_check2 is '资金查证人（至少两名）';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_organize_name is '【机构】机构名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_corp_corporgtype is '【机构】类别';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_tax_resident_type is '【机构】税收居民身份类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_taxarea_taxno1 is '【机构】税收居民国地区与纳税人识别号①';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_taxarea_taxno2 is '【机构】税收居民国地区与纳税人识别号②';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_taxarea_taxno3 is '【机构】税收居民国地区与纳税人识别号③';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_per_tax_null_reason1 is '【机构】不能提供识别号的原因①';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_per_tax_null_reason2 is '【机构】不能提供识别号的原因②';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_per_tax_null_reason3 is '【机构】不能提供识别号的原因③';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_organize_address is '【机构】机构地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.em_tax_english_name is '【机构】英文名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_company_type is '受益所有人企业所属类别';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_type is '受益所有人类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_name1 is '受益所有人1姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_position1 is '受益所有人1职务';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certtype1 is '受益所有人1证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certno1 is '受益所有人1证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certthrudate1 is '证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_address1 is '受益所有人1联系地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_name2 is '受益所有人2姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_position2 is '受益所有人2职务';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certtype2 is '受益所有人2证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certno2 is '受益所有人2证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certthrudate2 is '证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_address2 is '受益所有人2联系地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_name3 is '受益所有人3姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_position3 is '受益所有人3职务';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certtype3 is '受益所有人3证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certno3 is '受益所有人3证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certthrudate3 is '证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_address3 is '受益所有人3联系地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_name4 is '受益所有人4姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_position4 is '受益所有人4职务';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certtype4 is '受益所有人4证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certno4 is '受益所有人4证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certthrudate4 is '证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_address4 is '受益所有人4联系地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_name5 is '受益所有人5姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_position5 is '受益所有人5职务';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certtype5 is '受益所有人5证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certno5 is '受益所有人5证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_certthrudate5 is '证件生效日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_benfi_address5 is '受益所有人5联系地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_control_name is '股东名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_control_paperno is '控股股东/实际控制人证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_control_paperstype is '控股股东/实际控制人证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_same_benfi is '同受益所有人';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_controller is '控制人/控股股东';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_control_paperdt is '控股股东/实际控制人有效期';
comment on column ${iol_schema}.scps_bp_corporate_tb.er_cop_name is '关联企业名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.er_incidence_relation is '关联关系类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.er_principal_name is '关联企业法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.er_organiz_code is '关联企业组织机构代码';
comment on column ${iol_schema}.scps_bp_corporate_tb.es_main_account is '主账号';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_name is '【控制人①】姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxarea_nober1 is '【控制人①】税收居民国（地区）和纳税人识别号①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxnullreason1 is '【控制人①】不能提供识别号的原因①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_type is '【控制人①】控制人类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_englishname is '【控制人①】姓与名（英文或拼音）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_tax_resident is '【控制人①】税收居民身份';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_address is '【控制人①】现居地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxarea_nober2 is '【控制人①】税收居民国（地区）和纳税人识别号②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxarea_nober3 is '【控制人①】税收居民国（地区）和纳税人识别号③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_birthday is '【控制人①】出生日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxnullreason2 is '【控制人①】不能提供识别号的原因②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler1_taxnullreason3 is '【控制人①】不能提供识别号的原因③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler_birth_place is '【控制人①】出生地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_name is '【控制人②】姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_englishname is '【控制人②】姓与名（英文或拼音）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_type is '【控制人②】控制人类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_tax_resident is '【控制人②】税收居民身份';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_birthday is '【控制人②】出生日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_address is '【控制人②】现居地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxarea_nober1 is '【控制人②】税收居民国（地区）和纳税人识别号①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxarea_nober2 is '【控制人②】税收居民国（地区）和纳税人识别号②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxarea_nober3 is '【控制人②】税收居民国（地区）和纳税人识别号③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxnullreason1 is '【控制人②】不能提供识别号的原因①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxnullreason2 is '【控制人②】不能提供识别号的原因②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_taxnullreason3 is '【控制人②】不能提供识别号的原因③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler2_birth_place is '【控制人②】出生地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_name is '【控制人③】姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_englishname is '【控制人③】姓与名（英文或拼音）';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_type is '【控制人③】控制人类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_tax_resident is '【控制人③】税收居民身份';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_birthday is '【控制人③】出生日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_address is '【控制人③】现居地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxarea_nober1 is '【控制人③】税收居民国（地区）和纳税人识别号①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxarea_nober2 is '【控制人③】税收居民国（地区）和纳税人识别号②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxarea_nober3 is '【控制人③】税收居民国（地区）和纳税人识别号③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxnullreason1 is '【控制人③】不能提供识别号的原因①';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxnullreason2 is '【控制人③】不能提供识别号的原因②';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_taxnullreason3 is '【控制人③】不能提供识别号的原因③';
comment on column ${iol_schema}.scps_bp_corporate_tb.ct_croler3_birth_place is '【控制人③】出生地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_name1 is '受委托人1姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_certtype1 is '受委托人1证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_certno1 is '受委托人1证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_name2 is '受委托人2姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_certtype2 is '受委托人2证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_trust_certno2 is '受委托人2证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_name1 is '被授权人1姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_certtype1 is '被授权人1证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_certno1 is '被授权人1证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_name2 is '被授权人2姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_certtype2 is '被授权人2证件种类';
comment on column ${iol_schema}.scps_bp_corporate_tb.bq_accredit_certno2 is '被授权人2证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.frozen_flag is '止付状态（1-止付，01-止付失败，2-解止付，02-解止付失败）';
comment on column ${iol_schema}.scps_bp_corporate_tb.acct_no is '账号';
comment on column ${iol_schema}.scps_bp_corporate_tb.visit_service is '上门服务(0:否 1：是)';
comment on column ${iol_schema}.scps_bp_corporate_tb.check_type is '核准类型[0-无意义 1-自动核准 2-人工核准]';
comment on column ${iol_schema}.scps_bp_corporate_tb.account_active_flag is '账户激活标志 1-已激活 2-激活失败 0-未激活';
comment on column ${iol_schema}.scps_bp_corporate_tb.if_public_seal is '是否共用验印(1-是 0-否)';
comment on column ${iol_schema}.scps_bp_corporate_tb.if_seal is '是否倒验(1-是 0-否)';
comment on column ${iol_schema}.scps_bp_corporate_tb.cust_no is '客户编号';
comment on column ${iol_schema}.scps_bp_corporate_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.proxy_name is '代理人姓名';
comment on column ${iol_schema}.scps_bp_corporate_tb.proxy_papers_type is '代理人证件类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.proxy_papers_number is '代理人证件号码';
comment on column ${iol_schema}.scps_bp_corporate_tb.trans_state is '处理状态[1-处理中2-记账完成3-记账失败4-业务中止5-已冲正6-业务退票7-异常退票]';
comment on column ${iol_schema}.scps_bp_corporate_tb.acct_cancel_date is '客户销户日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_local_check is '是否双异地(1-是 0-否)';
comment on column ${iol_schema}.scps_bp_corporate_tb.acct_open_channel is '开户渠道';
comment on column ${iol_schema}.scps_bp_corporate_tb.charge_id is '审核柜员';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_upload_new_form is '是否上传系统最新表单(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_corporate_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_check is '是否核准（1-是 0-否，用于报备RPA）';
comment on column ${iol_schema}.scps_bp_corporate_tb.zone_cd is '注册地区代码';
comment on column ${iol_schema}.scps_bp_corporate_tb.reg_cap_ccy is '注册资金币种';
comment on column ${iol_schema}.scps_bp_corporate_tb.dirt_unt_lp_typ is '上级法人或主管单位信息（1-法定代表人 2-单位负责人）';
comment on column ${iol_schema}.scps_bp_corporate_tb.rec_type is '备案类型： 0本地备案1异地备案';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp1 is '关联企业名称_1';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp2 is '关联企业名称_2';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp3 is '关联企业名称_3';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp4 is '关联企业名称_4';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp5 is '关联企业名称_5';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp6 is '关联企业名称_6';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp7 is '关联企业名称_7';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp8 is '关联企业名称_8';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp9 is '关联企业名称_9';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_related_corp10 is '关联企业名称_10';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name1 is '1法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name2 is '2法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name3 is '3法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name4 is '4法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name5 is '5法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name6 is '6法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name7 is '7法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name8 is '8法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name9 is '9法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_corper_name10 is '10法定代表人名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code1 is '组织机构代码_1';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code2 is '组织机构代码_2';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code3 is '组织机构代码_3';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code4 is '组织机构代码_4';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code5 is '组织机构代码_5';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code6 is '组织机构代码_6';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code7 is '组织机构代码_7';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code8 is '组织机构代码_8';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code9 is '组织机构代码_9';
comment on column ${iol_schema}.scps_bp_corporate_tb.rpa_organze_code10 is '组织机构代码_10';
comment on column ${iol_schema}.scps_bp_corporate_tb.proxy_phone is '交易代办人联系电话';
comment on column ${iol_schema}.scps_bp_corporate_tb.proxy_invaldt is '代理人证件有效期';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_proxy is '是否代理（1-是，2-否）';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_bs_flag is '事后补扫是否完成,0-未完成，1-完成';
comment on column ${iol_schema}.scps_bp_corporate_tb.is_rpa_check is '是否经过rpa核查（1-是，0-否）';
comment on column ${iol_schema}.scps_bp_corporate_tb.business_type is '业务类型（0-单位账户开立，1-对公变更，2-对公开户（移动终端））';
comment on column ${iol_schema}.scps_bp_corporate_tb.found_date is '成立日期（营业执照）';
comment on column ${iol_schema}.scps_bp_corporate_tb.people_area_code is '人行地区代码';
comment on column ${iol_schema}.scps_bp_corporate_tb.usw_flg is '通存通兑';
comment on column ${iol_schema}.scps_bp_corporate_tb.ccy is '币种';
comment on column ${iol_schema}.scps_bp_corporate_tb.prd_typ is '产品类型';
comment on column ${iol_schema}.scps_bp_corporate_tb.check_dt is '核准日期';
comment on column ${iol_schema}.scps_bp_corporate_tb.bad_check_black is '空头支票黑名单状态';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_legal_end is '法人/负责人证件有效期结束日';
comment on column ${iol_schema}.scps_bp_corporate_tb.ea_work_address is '办公地址';
comment on column ${iol_schema}.scps_bp_corporate_tb.eb_name is '受益所有人客户名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_check_certificate_amt is '设置查证金额';
comment on column ${iol_schema}.scps_bp_corporate_tb.ei_unit_name is '单位名称';
comment on column ${iol_schema}.scps_bp_corporate_tb.enter_firstparty is '企业银行账户管理协议（甲方）';
comment on column ${iol_schema}.scps_bp_corporate_tb.util_first_party is '单位银行账户管理协议（甲方）';
comment on column ${iol_schema}.scps_bp_corporate_tb.trade_code is '国民经济行业分类';
comment on column ${iol_schema}.scps_bp_corporate_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_corporate_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_corporate_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_corporate_tb.etl_timestamp is 'ETL处理时间戳';
