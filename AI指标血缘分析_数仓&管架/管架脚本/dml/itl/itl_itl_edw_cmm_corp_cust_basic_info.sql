/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_corp_cust_basic_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cmm_corp_cust_basic_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_corp_cust_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_corp_cust_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_corp_cust_basic_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_en_name -- 客户英文名称
    ,cust_kind_cd -- 客户种类代码
    ,open_acct_dt -- 开户日期
    ,belong_org_id -- 所属机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_teller_id -- 开户柜员编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,create_chn_cd -- 创建渠道代码
    ,cust_mgr_id -- 客户经理编号
    ,cust_type_cd -- 客户类型代码
    ,crdt_cust_type_cd -- 信贷客户类型代码
    ,cust_lev_cd -- 客户级别代码
    ,depositr_cate_cd -- 存款人类别代码
    ,bal_pay_way_cd -- 收支方式代码
    ,cust_status_cd -- 客户状态代码
    ,corp_anl_inco -- 企业年收入
    ,corp_year_bus_lmt -- 企业年营业额
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,indus_categy_cd -- 行业门类代码
    ,indus_type_cd -- 行业类型代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,phone_crdtc -- 联系电话_征信
    ,corp_type_cd -- 企业类型代码
    ,cty_rg_cd -- 国家和地区代码
    ,rg_cd -- 地区代码
    ,econ_char_cd -- 经济性质代码
    ,econ_type_cd -- 经济类型代码
    ,orgnz_cd -- 组织机构代码
    ,orgnz_type_cd -- 组织机构类型代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_level5_cls_cd -- 行业五级分类代码
    ,indus_crdt_rating_cd -- 行业信用评级代码
    ,soci_crdt_cd -- 统一社会信用代码
    ,bus_lics_num -- 营业执照号
    ,bus_lics_exp_dt -- 营业执照到期日期
    ,nation_tax_rgst_cert_num -- 国税登记证号码
    ,local_tax_rgst_cert_num -- 地税登记证号码
    ,fin_lics_num -- 金融许可证号
    ,pbc_pay_bank_no -- 人行支付行号
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,oper_range -- 经营范围
    ,emply_qtty -- 员工数量
    ,curr_cd -- 币种代码
    ,rgst_cap -- 注册资金
    ,rgst_addr -- 注册地址
    ,rgst_dt -- 注册日期
    ,rgstion_cd -- 登记注册代码
    ,mang_field_prop_cd -- 经营场地所有权代码
    ,corp_rgstion_type -- 企业登记注册类型
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,mang_field_area -- 经营场地面积
    ,asset_tot -- 资产总额
    ,net_asset_tot -- 净资产总额
    ,single_lp_flg -- 独立法人标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,rela_party_flg -- 关联方标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,group_cust_flg -- 集团客户标志
    ,cbrc_sb_flg -- 银监小企业标志
    ,labor_inte_flg -- 劳动密集型标志
    ,hold_type_cd -- 控股类型代码
    ,off_shore_cust_flg -- 离岸客户标志
    ,prit_etp_flg -- 民营企业标志
    ,ctysd_corp_flg -- 农村企业标志
    ,corp_grow_stage_cd -- 企业成长阶段代码
    ,list_corp_type_cd -- 上市公司类型代码
    ,strate_new_indus_cls_cd -- 战略性新兴产业分类代码
    ,list_corp_flg -- 上市企业标志
    ,strtg_cust_flg -- 战略客户标志
    ,open_cap -- 开办资金
    ,crdt_cust_flg -- 授信客户标志
    ,stament_flg -- 自证声明标志
    ,tax_org_cate_cd -- 税收机构类别代码
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,basic_acct_open_bank_name -- 基本账户开户行名称
    ,basic_acct_acct_num -- 基本账户账号
    ,tax_num -- 纳税人识别号
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,bel_thi_flg -- 属于两高行业标志
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团客户编号
    ,group_parent_corp_id -- 集团母公司编号
    ,lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,have_bod_flg -- 有董事会标志
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,green_crdt_cls_cd -- 绿色信贷分类代码
    ,sci_tech_corp_cls_cd -- 科技型企业分类代码
    ,sci_tech_corp_idtfy_dt -- 科技型企业认定日期
    ,edu_hea_flg -- 文教健康标志
    ,inc_flg -- 普惠标志
    ,araf_flg -- 三农标志
    ,is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,escp_debt_corp_flg -- 逃废债企业标志
    ,is_mx_oper_item_flg -- 有无进出口经营项标志
    ,resdnt_flg -- 居民标志
    ,dom_overs_flg -- 境内外标志
    ,work_addr -- 办公地址
    ,work_addr_zip_cd -- 办公地址邮政编码
    ,posta_addr -- 通讯地址
    ,posta_addr_zip_cd -- 通讯地址邮政编码
    ,prod_mang_addr -- 生产经营地址
    ,prod_mang_addr_zip_cd -- 生产经营地址邮政编码
    ,mang_site_cd -- 经营所在地区代码
    ,crdt_cust_risk_rating_cd -- 信贷客户风险评级代码
    ,crdt_cust_risk_rating_start_dt -- 信贷客户风险评级开始日期
    ,crdt_cust_risk_rating_exp_dt -- 信贷客户风险评级到期日期
    ,ownsp_type_cd -- 所有制类型代码
    ,corp_close_flg -- 企业关停标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,short_check_blklist_flg -- 空头支票黑名单标志
    ,fir_lon_dt -- 首贷日期
    ,orgnz_surviv_status_cd -- 组织机构存续状态代码
    ,corp_idti_idf_type_cd -- 企业身份标识类型代码
    ,major_contrior_cnt -- 主要出资人个数
    ,actl_ctrler_cnt -- 实际控制人个数
    ,fin_dept_phone -- 财务部门联系电话
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(cust_en_name), ' ') as cust_en_name -- 客户英文名称
    ,nvl(trim(cust_kind_cd), ' ') as cust_kind_cd -- 客户种类代码
    ,nvl(open_acct_dt, to_date('00010101', 'yyyymmdd')) as open_acct_dt -- 开户日期
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(open_acct_org_id), ' ') as open_acct_org_id -- 开户机构编号
    ,nvl(trim(open_acct_teller_id), ' ') as open_acct_teller_id -- 开户柜员编号
    ,nvl(trim(open_acct_chn_cd), ' ') as open_acct_chn_cd -- 开户渠道代码
    ,nvl(trim(create_chn_cd), ' ') as create_chn_cd -- 创建渠道代码
    ,nvl(trim(cust_mgr_id), ' ') as cust_mgr_id -- 客户经理编号
    ,nvl(trim(cust_type_cd), ' ') as cust_type_cd -- 客户类型代码
    ,nvl(trim(crdt_cust_type_cd), ' ') as crdt_cust_type_cd -- 信贷客户类型代码
    ,nvl(trim(cust_lev_cd), ' ') as cust_lev_cd -- 客户级别代码
    ,nvl(trim(depositr_cate_cd), ' ') as depositr_cate_cd -- 存款人类别代码
    ,nvl(trim(bal_pay_way_cd), ' ') as bal_pay_way_cd -- 收支方式代码
    ,nvl(trim(cust_status_cd), ' ') as cust_status_cd -- 客户状态代码
    ,nvl(trim(corp_anl_inco), 0) as corp_anl_inco -- 企业年收入
    ,nvl(trim(corp_year_bus_lmt), 0) as corp_year_bus_lmt -- 企业年营业额
    ,nvl(corp_found_dt, to_date('00010101', 'yyyymmdd')) as corp_found_dt -- 企业成立日期
    ,nvl(trim(corp_size_cd), ' ') as corp_size_cd -- 企业规模代码
    ,nvl(trim(indus_categy_cd), ' ') as indus_categy_cd -- 行业门类代码
    ,nvl(trim(indus_type_cd), ' ') as indus_type_cd -- 行业类型代码
    ,nvl(trim(indus_type_cd_crdtc), ' ') as indus_type_cd_crdtc -- 行业类型代码_征信
    ,nvl(trim(phone_crdtc), ' ') as phone_crdtc -- 联系电话_征信
    ,nvl(trim(corp_type_cd), ' ') as corp_type_cd -- 企业类型代码
    ,nvl(trim(cty_rg_cd), ' ') as cty_rg_cd -- 国家和地区代码
    ,nvl(trim(rg_cd), ' ') as rg_cd -- 地区代码
    ,nvl(trim(econ_char_cd), ' ') as econ_char_cd -- 经济性质代码
    ,nvl(trim(econ_type_cd), ' ') as econ_type_cd -- 经济类型代码
    ,nvl(trim(orgnz_cd), ' ') as orgnz_cd -- 组织机构代码
    ,nvl(trim(orgnz_type_cd), ' ') as orgnz_type_cd -- 组织机构类型代码
    ,nvl(trim(natnal_econ_dept_type_cd), ' ') as natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,nvl(trim(indus_level5_cls_cd), ' ') as indus_level5_cls_cd -- 行业五级分类代码
    ,nvl(trim(indus_crdt_rating_cd), ' ') as indus_crdt_rating_cd -- 行业信用评级代码
    ,nvl(trim(soci_crdt_cd), ' ') as soci_crdt_cd -- 统一社会信用代码
    ,nvl(trim(bus_lics_num), ' ') as bus_lics_num -- 营业执照号
    ,nvl(bus_lics_exp_dt, to_date('00010101', 'yyyymmdd')) as bus_lics_exp_dt -- 营业执照到期日期
    ,nvl(trim(nation_tax_rgst_cert_num), ' ') as nation_tax_rgst_cert_num -- 国税登记证号码
    ,nvl(trim(local_tax_rgst_cert_num), ' ') as local_tax_rgst_cert_num -- 地税登记证号码
    ,nvl(trim(fin_lics_num), ' ') as fin_lics_num -- 金融许可证号
    ,nvl(trim(pbc_pay_bank_no), ' ') as pbc_pay_bank_no -- 人行支付行号
    ,nvl(trim(econ_orgnz_form_cd), ' ') as econ_orgnz_form_cd -- 经济组织形式代码
    ,nvl(trim(loan_card_no), ' ') as loan_card_no -- 贷款卡号
    ,nvl(trim(stock_cd), ' ') as stock_cd -- 股票代码
    ,nvl(trim(oper_range), ' ') as oper_range -- 经营范围
    ,nvl(trim(emply_qtty), 0) as emply_qtty -- 员工数量
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(rgst_cap), 0) as rgst_cap -- 注册资金
    ,nvl(trim(rgst_addr), ' ') as rgst_addr -- 注册地址
    ,nvl(rgst_dt, to_date('00010101', 'yyyymmdd')) as rgst_dt -- 注册日期
    ,nvl(trim(rgstion_cd), ' ') as rgstion_cd -- 登记注册代码
    ,nvl(trim(mang_field_prop_cd), ' ') as mang_field_prop_cd -- 经营场地所有权代码
    ,nvl(trim(corp_rgstion_type), ' ') as corp_rgstion_type -- 企业登记注册类型
    ,nvl(trim(paid_in_capital), 0) as paid_in_capital -- 实收资本
    ,nvl(trim(paid_in_capital_curr_cd), ' ') as paid_in_capital_curr_cd -- 实收资本币种代码
    ,nvl(trim(invtor_cty_cd), ' ') as invtor_cty_cd -- 投资方国家代码
    ,nvl(trim(mang_field_area), 0) as mang_field_area -- 经营场地面积
    ,nvl(trim(asset_tot), 0) as asset_tot -- 资产总额
    ,nvl(trim(net_asset_tot), 0) as net_asset_tot -- 净资产总额
    ,nvl(trim(single_lp_flg), ' ') as single_lp_flg -- 独立法人标志
    ,nvl(trim(high_new_tech_corp_flg), ' ') as high_new_tech_corp_flg -- 高新技术企业标志
    ,nvl(trim(rela_party_flg), ' ') as rela_party_flg -- 关联方标志
    ,nvl(trim(rela_group_type_cd), ' ') as rela_group_type_cd -- 关联集团类型代码
    ,nvl(trim(lp_org_name), ' ') as lp_org_name -- 法人机构名称
    ,nvl(trim(lp_org_type_cd), ' ') as lp_org_type_cd -- 法人机构类型代码
    ,nvl(trim(lp_org_cust_id), ' ') as lp_org_cust_id -- 法人机构客户编号
    ,nvl(trim(group_cust_flg), ' ') as group_cust_flg -- 集团客户标志
    ,nvl(trim(cbrc_sb_flg), ' ') as cbrc_sb_flg -- 银监小企业标志
    ,nvl(trim(labor_inte_flg), ' ') as labor_inte_flg -- 劳动密集型标志
    ,nvl(trim(hold_type_cd), ' ') as hold_type_cd -- 控股类型代码
    ,nvl(trim(off_shore_cust_flg), ' ') as off_shore_cust_flg -- 离岸客户标志
    ,nvl(trim(prit_etp_flg), ' ') as prit_etp_flg -- 民营企业标志
    ,nvl(trim(ctysd_corp_flg), ' ') as ctysd_corp_flg -- 农村企业标志
    ,nvl(trim(corp_grow_stage_cd), ' ') as corp_grow_stage_cd -- 企业成长阶段代码
    ,nvl(trim(list_corp_type_cd), ' ') as list_corp_type_cd -- 上市公司类型代码
    ,nvl(trim(strate_new_indus_cls_cd), ' ') as strate_new_indus_cls_cd -- 战略性新兴产业分类代码
    ,nvl(trim(list_corp_flg), ' ') as list_corp_flg -- 上市企业标志
    ,nvl(trim(strtg_cust_flg), ' ') as strtg_cust_flg -- 战略客户标志
    ,nvl(trim(open_cap), 0) as open_cap -- 开办资金
    ,nvl(trim(crdt_cust_flg), ' ') as crdt_cust_flg -- 授信客户标志
    ,nvl(trim(stament_flg), ' ') as stament_flg -- 自证声明标志
    ,nvl(trim(tax_org_cate_cd), ' ') as tax_org_cate_cd -- 税收机构类别代码
    ,nvl(trim(tax_resdnt_cty_cd), ' ') as tax_resdnt_cty_cd -- 税收居民国家代码
    ,nvl(trim(tax_resdnt_idti_cd), ' ') as tax_resdnt_idti_cd -- 税收居民身份代码
    ,nvl(trim(basic_acct_open_bank_name), ' ') as basic_acct_open_bank_name -- 基本账户开户行名称
    ,nvl(trim(basic_acct_acct_num), ' ') as basic_acct_acct_num -- 基本账户账号
    ,nvl(trim(tax_num), ' ') as tax_num -- 纳税人识别号
    ,nvl(trim(tax_num_null_rs_descb), ' ') as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,nvl(trim(bel_thi_flg), ' ') as bel_thi_flg -- 属于两高行业标志
    ,nvl(trim(trast_tax_regi_cert_flg), ' ') as trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,nvl(trim(cty_key_enterp_flg), ' ') as cty_key_enterp_flg -- 国家重点企业标志
    ,nvl(trim(group_corp_flg), ' ') as group_corp_flg -- 集团公司标志
    ,nvl(trim(group_cust_id), ' ') as group_cust_id -- 集团客户编号
    ,nvl(trim(group_parent_corp_id), ' ') as group_parent_corp_id -- 集团母公司编号
    ,nvl(trim(lmt_or_encrge_indus_cd), ' ') as lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,nvl(trim(have_bod_flg), ' ') as have_bod_flg -- 有董事会标志
    ,nvl(trim(green_crdt_cust_flg), ' ') as green_crdt_cust_flg -- 绿色信贷客户标志
    ,nvl(trim(green_crdt_cls_cd), ' ') as green_crdt_cls_cd -- 绿色信贷分类代码
    ,nvl(trim(sci_tech_corp_cls_cd), ' ') as sci_tech_corp_cls_cd -- 科技型企业分类代码
    ,nvl(sci_tech_corp_idtfy_dt, to_date('00010101', 'yyyymmdd')) as sci_tech_corp_idtfy_dt -- 科技型企业认定日期
    ,nvl(trim(edu_hea_flg), ' ') as edu_hea_flg -- 文教健康标志
    ,nvl(trim(inc_flg), ' ') as inc_flg -- 普惠标志
    ,nvl(trim(araf_flg), ' ') as araf_flg -- 三农标志
    ,nvl(trim(is_mx_mgmt_righ_flg), ' ') as is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,nvl(trim(escp_debt_corp_flg), ' ') as escp_debt_corp_flg -- 逃废债企业标志
    ,nvl(trim(is_mx_oper_item_flg), ' ') as is_mx_oper_item_flg -- 有无进出口经营项标志
    ,nvl(trim(resdnt_flg), ' ') as resdnt_flg -- 居民标志
    ,nvl(trim(dom_overs_flg), ' ') as dom_overs_flg -- 境内外标志
    ,nvl(trim(work_addr), ' ') as work_addr -- 办公地址
    ,nvl(trim(work_addr_zip_cd), ' ') as work_addr_zip_cd -- 办公地址邮政编码
    ,nvl(trim(posta_addr), ' ') as posta_addr -- 通讯地址
    ,nvl(trim(posta_addr_zip_cd), ' ') as posta_addr_zip_cd -- 通讯地址邮政编码
    ,nvl(trim(prod_mang_addr), ' ') as prod_mang_addr -- 生产经营地址
    ,nvl(trim(prod_mang_addr_zip_cd), ' ') as prod_mang_addr_zip_cd -- 生产经营地址邮政编码
    ,nvl(trim(mang_site_cd), ' ') as mang_site_cd -- 经营所在地区代码
    ,nvl(trim(crdt_cust_risk_rating_cd), ' ') as crdt_cust_risk_rating_cd -- 信贷客户风险评级代码
    ,nvl(crdt_cust_risk_rating_start_dt, to_date('00010101', 'yyyymmdd')) as crdt_cust_risk_rating_start_dt -- 信贷客户风险评级开始日期
    ,nvl(crdt_cust_risk_rating_exp_dt, to_date('00010101', 'yyyymmdd')) as crdt_cust_risk_rating_exp_dt -- 信贷客户风险评级到期日期
    ,nvl(trim(ownsp_type_cd), ' ') as ownsp_type_cd -- 所有制类型代码
    ,nvl(trim(corp_close_flg), ' ') as corp_close_flg -- 企业关停标志
    ,nvl(trim(gover_fin_plat_flg), ' ') as gover_fin_plat_flg -- 政府融资平台标志
    ,nvl(trim(short_check_blklist_flg), ' ') as short_check_blklist_flg -- 空头支票黑名单标志
    ,nvl(fir_lon_dt, to_date('00010101', 'yyyymmdd')) as fir_lon_dt -- 首贷日期
    ,nvl(trim(orgnz_surviv_status_cd), ' ') as orgnz_surviv_status_cd -- 组织机构存续状态代码
    ,nvl(trim(corp_idti_idf_type_cd), ' ') as corp_idti_idf_type_cd -- 企业身份标识类型代码
    ,nvl(trim(major_contrior_cnt), 0) as major_contrior_cnt -- 主要出资人个数
    ,nvl(trim(actl_ctrler_cnt), 0) as actl_ctrler_cnt -- 实际控制人个数
    ,nvl(trim(fin_dept_phone), ' ') as fin_dept_phone -- 财务部门联系电话
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_corp_cust_basic_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_corp_cust_basic_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_corp_cust_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);