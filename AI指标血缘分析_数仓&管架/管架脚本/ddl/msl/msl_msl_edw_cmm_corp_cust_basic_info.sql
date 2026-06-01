/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_corp_cust_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_corp_cust_basic_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_corp_cust_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_corp_cust_basic_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,cust_id varchar2(60)
    ,cust_name varchar2(250)
    ,cust_en_name varchar2(250)
    ,cust_kind_cd varchar2(20)
    ,open_acct_dt date
    ,belong_org_id varchar2(60)
    ,open_acct_org_id varchar2(60)
    ,open_acct_teller_id varchar2(60)
    ,open_acct_chn_cd varchar2(10)
    ,create_chn_cd varchar2(10)
    ,cust_mgr_id varchar2(100)
    ,cust_type_cd varchar2(10)
    ,crdt_cust_type_cd varchar2(20)
    ,cust_lev_cd varchar2(10)
    ,depositr_cate_cd varchar2(30)
    ,bal_pay_way_cd varchar2(10)
    ,cust_status_cd varchar2(10)
    ,corp_anl_inco number(30,2)
    ,corp_year_bus_lmt number(30,2)
    ,corp_found_dt date
    ,corp_size_cd varchar2(10)
    ,indus_categy_cd varchar2(10)
    ,indus_type_cd varchar2(20)
    ,indus_type_cd_crdtc varchar2(10)
    ,phone_crdtc varchar2(100)
    ,corp_type_cd varchar2(10)
    ,cty_rg_cd varchar2(10)
    ,rg_cd varchar2(30)
    ,econ_char_cd varchar2(10)
    ,econ_type_cd varchar2(10)
    ,orgnz_cd varchar2(60)
    ,orgnz_type_cd varchar2(10)
    ,natnal_econ_dept_type_cd varchar2(10)
    ,indus_level5_cls_cd varchar2(10)
    ,indus_crdt_rating_cd varchar2(10)
    ,soci_crdt_cd varchar2(30)
    ,bus_lics_num varchar2(60)
    ,bus_lics_exp_dt date
    ,nation_tax_rgst_cert_num varchar2(60)
    ,local_tax_rgst_cert_num varchar2(60)
    ,fin_lics_num varchar2(60)
    ,pbc_pay_bank_no varchar2(60)
    ,econ_orgnz_form_cd varchar2(10)
    ,loan_card_no varchar2(60)
    ,oper_range varchar2(2500)
    ,emply_qtty number(30)
    ,curr_cd varchar2(10)
    ,rgst_cap number(30,2)
    ,rgst_addr varchar2(500)
    ,rgst_dt date
    ,rgstion_cd varchar2(250)
    ,mang_field_prop_cd varchar2(10)
    ,corp_rgstion_type varchar2(10)
    ,paid_in_capital number(30,2)
    ,paid_in_capital_curr_cd varchar2(10)
    ,invtor_cty_cd varchar2(10)
    ,mang_field_area number(38,2)
    ,asset_tot number(30,2)
    ,net_asset_tot number(30,2)
    ,single_lp_flg varchar2(10)
    ,high_new_tech_corp_flg varchar2(10)
    ,rela_party_flg varchar2(10)
    ,rela_group_type_cd varchar2(10)
    ,lp_org_name varchar2(250)
    ,lp_org_type_cd varchar2(30)
    ,lp_org_cust_id varchar2(100)
    ,group_cust_flg varchar2(10)
    ,cbrc_sb_flg varchar2(10)
    ,labor_inte_flg varchar2(10)
    ,hold_type_cd varchar2(10)
    ,off_shore_cust_flg varchar2(10)
    ,prit_etp_flg varchar2(10)
    ,ctysd_corp_flg varchar2(10)
    ,corp_grow_stage_cd varchar2(30)
    ,list_corp_type_cd varchar2(10)
    ,strate_new_indus_cls_cd varchar2(10)
    ,list_corp_flg varchar2(10)
    ,strtg_cust_flg varchar2(10)
    ,open_cap number(30,2)
    ,crdt_cust_flg varchar2(10)
    ,stament_flg varchar2(10)
    ,tax_org_cate_cd varchar2(30)
    ,tax_resdnt_cty_cd varchar2(500)
    ,tax_resdnt_idti_cd varchar2(30)
    ,basic_acct_open_bank_name varchar2(200)
    ,basic_acct_acct_num varchar2(60)
    ,tax_num varchar2(500)
    ,tax_num_null_rs_descb varchar2(3000)
    ,bel_thi_flg varchar2(10)
    ,trast_tax_regi_cert_flg varchar2(10)
    ,cty_key_enterp_flg varchar2(10)
    ,group_corp_flg varchar2(10)
    ,group_cust_id varchar2(60)
    ,group_parent_corp_id varchar2(60)
    ,lmt_or_encrge_indus_cd varchar2(10)
    ,have_bod_flg varchar2(10)
    ,green_crdt_cust_flg varchar2(10)
    ,green_crdt_cls_cd varchar2(10)
    ,sci_tech_corp_cls_cd varchar2(10)
    ,sci_tech_corp_idtfy_dt date
    ,edu_hea_flg varchar2(10)
    ,inc_flg varchar2(10)
    ,araf_flg varchar2(10)
    ,is_mx_mgmt_righ_flg varchar2(10)
    ,escp_debt_corp_flg varchar2(10)
    ,is_mx_oper_item_flg varchar2(10)
    ,resdnt_flg varchar2(10)
    ,dom_overs_flg varchar2(10)
    ,work_addr varchar2(500)
    ,work_addr_zip_cd varchar2(60)
    ,posta_addr varchar2(500)
    ,posta_addr_zip_cd varchar2(60)
    ,prod_mang_addr varchar2(500)
    ,prod_mang_addr_zip_cd varchar2(60)
    ,mang_site_cd varchar2(30)
    ,crdt_cust_risk_rating_cd varchar2(20)
    ,crdt_cust_risk_rating_start_dt date
    ,crdt_cust_risk_rating_exp_dt date
    ,ownsp_type_cd varchar2(10)
    ,corp_close_flg varchar2(10)
    ,gover_fin_plat_flg varchar2(10)
    ,short_check_blklist_flg varchar2(10)
    ,fir_lon_dt date
    ,orgnz_surviv_status_cd varchar2(10)
    ,corp_idti_idf_type_cd varchar2(60)
    ,major_contrior_cnt number(10)
    ,actl_ctrler_cnt number(10)
    ,fin_dept_phone varchar2(60)
    ,group_type_cd varchar2(10)
    ,green_bond_proj_flg varchar2(10)
    ,stock_cd varchar2(60)
    ,dep_class_cust_flg varchar2(10)
    ,loan_class_cust_flg varchar2(10)
    ,guar_class_cust_flg varchar2(10)
    ,anti_mon_lau_belong_org_id varchar2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_corp_cust_basic_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_corp_cust_basic_info is '对公客户基本信息';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_name is '客户名称';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_en_name is '客户英文名称';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_kind_cd is '客户种类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.open_acct_dt is '客户开户日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.open_acct_org_id is '开户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.open_acct_teller_id is '开户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.create_chn_cd is '创建渠道编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_mgr_id is '客户经理编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_type_cd is '客户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.crdt_cust_type_cd is '信贷客户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_lev_cd is '客户级别代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.depositr_cate_cd is '存款人类别代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.bal_pay_way_cd is '收支方式代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cust_status_cd is '客户状态代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_anl_inco is '企业年收入';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_year_bus_lmt is '企业年营业额';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_found_dt is '企业成立日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_size_cd is '企业规模代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.indus_categy_cd is '行业门类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.indus_type_cd is '行业类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.indus_type_cd_crdtc is '行业类型代码_征信';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.phone_crdtc is '联系电话_征信';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_type_cd is '企业类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cty_rg_cd is '国家和地区代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rg_cd is '地区代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.econ_char_cd is '经济性质代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.econ_type_cd is '经济类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.orgnz_cd is '组织机构代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.orgnz_type_cd is '组织机构类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.natnal_econ_dept_type_cd is '国民经济部门类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.indus_level5_cls_cd is '行业五级分类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.indus_crdt_rating_cd is '行业信用评级代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.soci_crdt_cd is '统一社会信用代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.bus_lics_num is '营业执照号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.bus_lics_exp_dt is '营业执照到期日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.nation_tax_rgst_cert_num is '国税登记证号码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.local_tax_rgst_cert_num is '地税登记证号码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.fin_lics_num is '金融许可证号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.pbc_pay_bank_no is '人行支付行号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.econ_orgnz_form_cd is '经济组织形式代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.loan_card_no is '贷款卡号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.oper_range is '经营范围';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.emply_qtty is '员工数量';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rgst_cap is '注册资金';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rgst_addr is '注册地址';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rgst_dt is '注册日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rgstion_cd is '登记注册代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.mang_field_prop_cd is '经营场地所有权代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_rgstion_type is '企业登记注册类型';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.paid_in_capital is '实收资本';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.paid_in_capital_curr_cd is '实收资本币种代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.invtor_cty_cd is '投资方国家代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.mang_field_area is '经营场地面积';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.asset_tot is '资产总额';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.net_asset_tot is '净资产总额';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.single_lp_flg is '独立法人标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rela_party_flg is '关联方标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.rela_group_type_cd is '关联集团类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.lp_org_name is '法人机构名称';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.lp_org_type_cd is '法人机构类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.lp_org_cust_id is '法人机构客户编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.group_cust_flg is '集团客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cbrc_sb_flg is '银监小企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.labor_inte_flg is '劳动密集型标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.hold_type_cd is '控股类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.off_shore_cust_flg is '离岸客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.prit_etp_flg is '民营企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.ctysd_corp_flg is '农村企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_grow_stage_cd is '企业成长阶段代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.list_corp_type_cd is '上市公司类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.strate_new_indus_cls_cd is '战略性新兴产业分类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.list_corp_flg is '上市企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.strtg_cust_flg is '战略客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.open_cap is '开办资金';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.crdt_cust_flg is '授信客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.stament_flg is '自证声明标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.tax_org_cate_cd is '税收机构类别代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.tax_resdnt_cty_cd is '税收居民国家代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.basic_acct_open_bank_name is '基本账户开户行名称';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.basic_acct_acct_num is '基本账户账号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.tax_num is '纳税人识别号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.bel_thi_flg is '属于两高行业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.trast_tax_regi_cert_flg is '办理税务登记证标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.cty_key_enterp_flg is '国家重点企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.group_corp_flg is '集团公司标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.group_cust_id is '集团客户编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.group_parent_corp_id is '集团母公司编号';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.lmt_or_encrge_indus_cd is '限制或鼓励行业代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.have_bod_flg is '有董事会标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.green_crdt_cust_flg is '绿色信贷客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.green_crdt_cls_cd is '绿色信贷分类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.sci_tech_corp_cls_cd is '科技型企业分类代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.sci_tech_corp_idtfy_dt is '科技型企业认定日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.edu_hea_flg is '文教健康标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.inc_flg is '普惠标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.araf_flg is '三农标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.is_mx_mgmt_righ_flg is '有无进出口经营权标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.escp_debt_corp_flg is '逃废债企业标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.is_mx_oper_item_flg is '有无进出口经营项标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.resdnt_flg is '居民标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.dom_overs_flg is '境内外标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.work_addr is '办公地址';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.work_addr_zip_cd is '办公地址邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.posta_addr is '通讯地址';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.posta_addr_zip_cd is '通讯地址邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.prod_mang_addr is '生产经营地址';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.prod_mang_addr_zip_cd is '生产经营地址邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.mang_site_cd is '经营所在地区代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.crdt_cust_risk_rating_cd is '信贷客户风险评级代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.crdt_cust_risk_rating_start_dt is '信贷客户风险评级开始日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.crdt_cust_risk_rating_exp_dt is '信贷客户风险评级到期日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.ownsp_type_cd is '所有制类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_close_flg is '企业关停标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.gover_fin_plat_flg is '政府融资平台标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.short_check_blklist_flg is '空头支票黑名单标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.fir_lon_dt is '首贷日期';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.orgnz_surviv_status_cd is '组织机构存续状态代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.corp_idti_idf_type_cd is '企业身份标识类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.major_contrior_cnt is '主要出资人个数';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.actl_ctrler_cnt is '实际控制人个数';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.fin_dept_phone is '财务部门联系电话';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.group_type_cd is '集团类型代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.green_bond_proj_flg is '绿色债券项目标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.stock_cd is '股票代码';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.dep_class_cust_flg is '存款类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.loan_class_cust_flg is '贷款类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.guar_class_cust_flg is '担保类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_corp_cust_basic_info.anti_mon_lau_belong_org_id is '反洗钱归属机构编号';
