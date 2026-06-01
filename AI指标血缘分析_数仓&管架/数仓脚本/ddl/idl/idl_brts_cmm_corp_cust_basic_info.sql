/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_corp_cust_basic_info
CreateDate: 20211129
FileType:   DDL
Logs:
    sundexin
*/

prompt creating table ${idl_schema}.cmm_corp_cust_basic_info
whenever sqlerror continue none;
drop table ${idl_schema}.cmm_corp_cust_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.cmm_corp_cust_basic_info(
    etl_dt date -- 数据日期   
    ,lp_id varchar2(60) -- 法人编号   
    ,cust_id varchar2(60) -- 客户编号   
    ,cust_name varchar2(100) -- 客户名称   
    ,cust_en_name varchar2(250) -- 客户英文名称   
    ,cust_kind_cd varchar2(20) -- 客户种类代码   
    ,open_acct_dt date -- 开户日期   
    ,belong_org_id varchar2(60) -- 所属机构编号   
    ,open_acct_org_id varchar2(60) -- 开户机构编号   
    ,open_acct_teller_id varchar2(60) -- 开户柜员编号   
    ,open_acct_chn_cd varchar2(10) -- 开户渠道代码   
    ,cust_mgr_id varchar2(60) -- 客户经理编号   
    ,cust_type_cd varchar2(10) -- 客户类型代码   
    ,crdt_cust_type_cd varchar2(20) -- 信贷客户类型代码   
    ,cust_lev_cd varchar2(10) -- 客户级别代码   
    ,depositr_cate_cd varchar2(30) -- 存款人类别代码   
    ,bal_pay_way_cd varchar2(10) -- 收支方式代码   
    ,cust_status_cd varchar2(10) -- 客户状态代码   
    ,corp_anl_inco number(30,2) -- 企业年收入   
    ,corp_year_bus_lmt number(30,2) -- 企业年营业额   
    ,corp_found_dt date -- 企业成立日期   
    ,corp_size_cd varchar2(10) -- 企业规模代码   
    ,indus_categy_cd varchar2(10) -- 行业门类代码   
    ,indus_type_cd varchar2(20) -- 行业类型代码   
    ,indus_type_cd_crdtc varchar2(10) -- 行业类型代码_征信   
    ,phone_crdtc varchar2(100) -- 联系电话_征信   
    ,corp_type_cd varchar2(10) -- 企业类型代码   
    ,cty_rg_cd varchar2(10) -- 国家和地区代码   
    ,rg_cd varchar2(30) -- 地区代码   
    ,econ_char_cd varchar2(10) -- 经济性质代码   
    ,econ_type_cd varchar2(10) -- 经济类型代码   
    ,orgnz_cd varchar2(60) -- 组织机构代码   
    ,orgnz_type_cd varchar2(10) -- 组织机构类型代码   
    ,natnal_econ_dept_type_cd varchar2(10) -- 国民经济部门类型代码   
    ,indus_level5_cls_cd varchar2(10) -- 行业五级分类代码   
    ,indus_crdt_rating_cd varchar2(10) -- 行业信用评级代码   
    ,soci_crdt_cd varchar2(30) -- 统一社会信用代码   
    ,bus_lics_num varchar2(60) -- 营业执照号   
    ,bus_lics_exp_dt date -- 营业执照到期日期   
    ,nation_tax_rgst_cert_num varchar2(60) -- 国税登记证号码   
    ,local_tax_rgst_cert_num varchar2(60) -- 地税登记证号码   
    ,fin_lics_num varchar2(60) -- 金融许可证号   
    ,pbc_pay_bank_no varchar2(60) -- 人行支付行号   
    ,econ_orgnz_form_cd varchar2(10) -- 经济组织形式代码   
    ,loan_card_no varchar2(60) -- 贷款卡号   
    ,oper_range varchar2(800) -- 经营范围   
    ,emply_qtty number(10) -- 员工数量   
    ,curr_cd varchar2(10) -- 币种代码   
    ,rgst_cap number(30,2) -- 注册资金   
    ,rgst_addr varchar2(500) -- 注册地址   
    ,rgst_dt date -- 注册日期   
    ,rgstion_cd varchar2(250) -- 登记注册代码   
    ,mang_field_prop_cd varchar2(10) -- 经营场地所有权代码   
    ,corp_rgstion_type varchar2(10) -- 企业登记注册类型   
    ,paid_in_capital number(30,2) -- 实收资本   
    ,paid_in_capital_curr_cd varchar2(10) -- 实收资本币种代码   
    ,invtor_cty_cd varchar2(10) -- 投资方国家代码   
    ,mang_field_area number(38,2) -- 经营场地面积   
    ,asset_tot number(30,2) -- 资产总额   
    ,net_asset_tot number(30,2) -- 净资产总额   
    ,single_lp_flg varchar2(10) -- 独立法人标志   
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志   
    ,rela_party_flg varchar2(10) -- 关联方标志   
    ,rela_group_type_cd varchar2(10) -- 关联集团类型代码   
    ,group_cust_flg varchar2(10) -- 集团客户标志   
    ,cbrc_sb_flg varchar2(10) -- 银监小企业标志   
    ,labor_inte_flg varchar2(10) -- 劳动密集型标志   
    ,hold_type_cd varchar2(10) -- 控股类型代码   
    ,off_shore_cust_flg varchar2(10) -- 离岸客户标志   
    ,prit_etp_flg varchar2(10) -- 民营企业标志   
    ,ctysd_corp_flg varchar2(10) -- 农村企业标志   
    ,corp_grow_stage_cd varchar2(30) -- 企业成长阶段代码   
    ,list_corp_type_cd varchar2(10) -- 上市公司类型代码   
    ,list_corp_flg varchar2(10) -- 上市企业标志   
    ,open_cap number(30,2) -- 开办资金   
    ,crdt_cust_flg varchar2(10) -- 授信客户标志   
    ,stament_flg varchar2(10) -- 自证声明标志   
    ,tax_org_cate_cd varchar2(30) -- 税收机构类别代码   
    ,tax_resdnt_cty_cd varchar2(500) -- 税收居民国家代码   
    ,tax_resdnt_idti_cd varchar2(30) -- 税收居民身份代码   
    ,tax_num varchar2(500) -- 纳税人识别号   
    ,tax_num_null_rs_descb varchar2(3000) -- 纳税人识别号空值原因描述   
    ,bel_thi_flg varchar2(10) -- 属于两高行业标志   
    ,trast_tax_regi_cert_flg varchar2(10) -- 办理税务登记证标志   
    ,cty_key_enterp_flg varchar2(10) -- 国家重点企业标志   
    ,group_corp_flg varchar2(10) -- 集团公司标志   
    ,group_cust_id varchar2(60) -- 集团客户编号   
    ,group_parent_corp_id varchar2(60) -- 集团母公司编号   
    ,lmt_or_encrge_indus_cd varchar2(10) -- 限制或鼓励行业代码   
    ,have_bod_flg varchar2(10) -- 有董事会标志   
    ,green_crdt_cust_flg varchar2(10) -- 绿色信贷客户标志   
    ,edu_hea_flg varchar2(10) -- 文教健康标志   
    ,inc_flg varchar2(10) -- 普惠标志   
    ,araf_flg varchar2(10) -- 三农标志   
    ,is_mx_mgmt_righ_flg varchar2(10) -- 有无进出口经营权标志   
    ,escp_debt_corp_flg varchar2(10) -- 逃废债企业标志   
    ,is_mx_oper_item_flg varchar2(10) -- 有无进出口经营项标志   
    ,resdnt_flg varchar2(10) -- 居民标志   
    ,dom_overs_flg varchar2(10) -- 境内外标志   
    ,work_addr varchar2(250) -- 办公地址   
    ,work_addr_zip_cd varchar2(60) -- 办公地址邮政编码   
    ,posta_addr varchar2(250) -- 通讯地址   
    ,posta_addr_zip_cd varchar2(60) -- 通讯地址邮政编码   
    ,prod_mang_addr varchar2(250) -- 生产经营地址   
    ,prod_mang_addr_zip_cd varchar2(60) -- 生产经营地址邮政编码   
    ,crdt_cust_risk_rating_cd varchar2(20) -- 信贷客户风险评级代码   
    ,crdt_cust_risk_rating_start_dt date -- 信贷客户风险评级开始日期   
    ,crdt_cust_risk_rating_exp_dt date -- 信贷客户风险评级到期日期   
    ,ownsp_type_cd varchar2(10) -- 所有制类型代码   
    ,corp_close_flg varchar2(10) -- 企业关停标志   
    ,gover_fin_plat_flg varchar2(10) -- 政府融资平台标志   
    ,short_check_blklist_flg varchar2(10) -- 空头支票黑名单标志   
    ,fir_lon_dt date -- 首贷日期   
    ,orgnz_surviv_status_cd varchar2(10) -- 组织机构存续状态代码   
    ,corp_idti_idf_type_cd varchar2(60) -- 企业身份标识类型代码   
    ,major_contrior_cnt number(10) -- 主要出资人个数   
    ,actl_ctrler_cnt number(10) -- 实际控制人个数   
    ,fin_dept_phone varchar2(60) -- 财务部门联系电话
    ,basic_acct_open_bank_name  varchar2(200) --基本账户开户行名称
    ,basic_acct_acct_num        varchar2(60)  --基本账户账号   
    ,green_crdt_cls_cd         varchar2(10)   --绿色信贷分类代码 
    ,sci_tech_corp_cls_cd      varchar2(10)   --科技型企业分类代码
    ,sci_tech_corp_idtfy_dt    date           --科技型企业认定日期 
    ,mang_site_cd   varchar2(30)              --经营所在地区代码
    ,strtg_cust_flg varchar2(10)              --战略客户标志
    ,create_chn_cd             varchar2(10)   --创建渠道代码     
    ,strate_new_indus_cls_cd   varchar2(10)   --战略性新兴产业分类代码
    ,lp_org_name	varchar2(250)               --法人机构名称  
    ,lp_org_type_cd	varchar2(30)              --法人机构类型代码
    ,lp_org_cust_id	varchar2(100)             --法人机构客户编号
    ,job_cd varchar2(10)                      --任务代码   
    ,etl_timestamp timestamp                  --数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.cmm_corp_cust_basic_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.cmm_corp_cust_basic_info is '对公客户基本信息';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.etl_dt is '数据日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.lp_id is '法人编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_id is '客户编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_name is '客户名称';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_en_name is '客户英文名称';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_kind_cd is '客户种类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.open_acct_dt is '开户日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.crdt_cust_type_cd is '信贷客户类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_lev_cd is '客户级别代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.depositr_cate_cd is '存款人类别代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.bal_pay_way_cd is '收支方式代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cust_status_cd is '客户状态代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_anl_inco is '企业年收入';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_year_bus_lmt is '企业年营业额';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_found_dt is '企业成立日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_size_cd is '企业规模代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.indus_categy_cd is '行业门类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.indus_type_cd is '行业类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.indus_type_cd_crdtc is '行业类型代码_征信';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.phone_crdtc is '联系电话_征信';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_type_cd is '企业类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cty_rg_cd is '国家和地区代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rg_cd is '地区代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.econ_char_cd is '经济性质代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.econ_type_cd is '经济类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.orgnz_cd is '组织机构代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.orgnz_type_cd is '组织机构类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.natnal_econ_dept_type_cd is '国民经济部门类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.indus_level5_cls_cd is '行业五级分类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.indus_crdt_rating_cd is '行业信用评级代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.soci_crdt_cd is '统一社会信用代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.bus_lics_num is '营业执照号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.bus_lics_exp_dt is '营业执照到期日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.nation_tax_rgst_cert_num is '国税登记证号码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.local_tax_rgst_cert_num is '地税登记证号码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.fin_lics_num is '金融许可证号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.pbc_pay_bank_no is '人行支付行号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.econ_orgnz_form_cd is '经济组织形式代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.loan_card_no is '贷款卡号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.oper_range is '经营范围';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.emply_qtty is '员工数量';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.curr_cd is '币种代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rgst_cap is '注册资金';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rgst_addr is '注册地址';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rgst_dt is '注册日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rgstion_cd is '登记注册代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.mang_field_prop_cd is '经营场地所有权代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_rgstion_type is '企业登记注册类型';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.paid_in_capital is '实收资本';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.paid_in_capital_curr_cd is '实收资本币种代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.invtor_cty_cd is '投资方国家代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.mang_field_area is '经营场地面积';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.asset_tot is '资产总额';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.net_asset_tot is '净资产总额';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.single_lp_flg is '独立法人标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rela_party_flg is '关联方标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.rela_group_type_cd is '关联集团类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.group_cust_flg is '集团客户标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cbrc_sb_flg is '银监小企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.labor_inte_flg is '劳动密集型标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.hold_type_cd is '控股类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.off_shore_cust_flg is '离岸客户标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.prit_etp_flg is '民营企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.ctysd_corp_flg is '农村企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_grow_stage_cd is '企业成长阶段代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.list_corp_type_cd is '上市公司类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.list_corp_flg is '上市企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.open_cap is '开办资金';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.crdt_cust_flg is '授信客户标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.stament_flg is '自证声明标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.tax_org_cate_cd is '税收机构类别代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.tax_resdnt_cty_cd is '税收居民国家代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.tax_num is '纳税人识别号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.bel_thi_flg is '属于两高行业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.trast_tax_regi_cert_flg is '办理税务登记证标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.cty_key_enterp_flg is '国家重点企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.group_corp_flg is '集团公司标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.group_cust_id is '集团客户编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.group_parent_corp_id is '集团母公司编号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.lmt_or_encrge_indus_cd is '限制或鼓励行业代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.have_bod_flg is '有董事会标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.green_crdt_cust_flg is '绿色信贷客户标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.edu_hea_flg is '文教健康标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.inc_flg is '普惠标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.araf_flg is '三农标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.is_mx_mgmt_righ_flg is '有无进出口经营权标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.escp_debt_corp_flg is '逃废债企业标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.is_mx_oper_item_flg is '有无进出口经营项标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.resdnt_flg is '居民标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.dom_overs_flg is '境内外标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.work_addr is '办公地址';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.work_addr_zip_cd is '办公地址邮政编码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.posta_addr is '通讯地址';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.posta_addr_zip_cd is '通讯地址邮政编码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.prod_mang_addr is '生产经营地址';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.prod_mang_addr_zip_cd is '生产经营地址邮政编码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.crdt_cust_risk_rating_cd is '信贷客户风险评级代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.crdt_cust_risk_rating_start_dt is '信贷客户风险评级开始日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.crdt_cust_risk_rating_exp_dt is '信贷客户风险评级到期日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.ownsp_type_cd is '所有制类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_close_flg is '企业关停标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.gover_fin_plat_flg is '政府融资平台标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.short_check_blklist_flg is '空头支票黑名单标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.fir_lon_dt is '首贷日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.orgnz_surviv_status_cd is '组织机构存续状态代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.corp_idti_idf_type_cd is '企业身份标识类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.major_contrior_cnt is '主要出资人个数';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.actl_ctrler_cnt is '实际控制人个数';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.fin_dept_phone is '财务部门联系电话';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.job_cd is '任务代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.basic_acct_open_bank_name is '基本账户开户行名称';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.basic_acct_acct_num is '基本账户账号';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.green_crdt_cls_cd is '绿色信贷分类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.sci_tech_corp_cls_cd is '科技型企业分类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.sci_tech_corp_idtfy_dt is '科技型企业认定日期';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.mang_site_cd is '经营所在地区代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.strtg_cust_flg is '战略客户标志';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.create_chn_cd is '创建渠道代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.strate_new_indus_cls_cd is '战略性新兴产业分类代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.lp_org_name is '法人机构名称';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.lp_org_type_cd is '法人机构类型代码';
comment on column ${idl_schema}.cmm_corp_cust_basic_info.lp_org_cust_id is '法人机构客户编号';
