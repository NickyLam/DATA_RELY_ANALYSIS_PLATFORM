/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_corp_cust_basic_info
CreateDate: 20211129
FileType:   DML
Logs:
    sundeixn
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_corp_cust_basic_info drop partition p_${last_date};
alter table ${idl_schema}.cmm_corp_cust_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_corp_cust_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_corp_cust_basic_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户名称
    ,cust_en_name  -- 客户英文名称
    ,cust_kind_cd  -- 客户种类代码
    ,open_acct_dt  -- 开户日期
    ,belong_org_id  -- 所属机构编号
    ,open_acct_org_id  -- 开户机构编号
    ,open_acct_teller_id  -- 开户柜员编号
    ,open_acct_chn_cd  -- 开户渠道代码
    ,cust_mgr_id  -- 客户经理编号
    ,cust_type_cd  -- 客户类型代码
    ,crdt_cust_type_cd  -- 信贷客户类型代码
    ,cust_lev_cd  -- 客户级别代码
    ,depositr_cate_cd  -- 存款人类别代码
    ,bal_pay_way_cd  -- 收支方式代码
    ,cust_status_cd  -- 客户状态代码
    ,corp_anl_inco  -- 企业年收入
    ,corp_year_bus_lmt  -- 企业年营业额
    ,corp_found_dt  -- 企业成立日期
    ,corp_size_cd  -- 企业规模代码
    ,indus_categy_cd  -- 行业门类代码
    ,indus_type_cd  -- 行业类型代码
    ,indus_type_cd_crdtc  -- 行业类型代码_征信
    ,phone_crdtc  -- 联系电话_征信
    ,corp_type_cd  -- 企业类型代码
    ,cty_rg_cd  -- 国家和地区代码
    ,rg_cd  -- 地区代码
    ,econ_char_cd  -- 经济性质代码
    ,econ_type_cd  -- 经济类型代码
    ,orgnz_cd  -- 组织机构代码
    ,orgnz_type_cd  -- 组织机构类型代码
    ,natnal_econ_dept_type_cd  -- 国民经济部门类型代码
    ,indus_level5_cls_cd  -- 行业五级分类代码
    ,indus_crdt_rating_cd  -- 行业信用评级代码
    ,soci_crdt_cd  -- 统一社会信用代码
    ,bus_lics_num  -- 营业执照号
    ,bus_lics_exp_dt  -- 营业执照到期日期
    ,nation_tax_rgst_cert_num  -- 国税登记证号码
    ,local_tax_rgst_cert_num  -- 地税登记证号码
    ,fin_lics_num  -- 金融许可证号
    ,pbc_pay_bank_no  -- 人行支付行号
    ,econ_orgnz_form_cd  -- 经济组织形式代码
    ,loan_card_no  -- 贷款卡号
    ,oper_range  -- 经营范围
    ,emply_qtty  -- 员工数量
    ,curr_cd  -- 币种代码
    ,rgst_cap  -- 注册资金
    ,rgst_addr  -- 注册地址
    ,rgst_dt  -- 注册日期
    ,rgstion_cd  -- 登记注册代码
    ,mang_field_prop_cd  -- 经营场地所有权代码
    ,corp_rgstion_type  -- 企业登记注册类型
    ,paid_in_capital  -- 实收资本
    ,paid_in_capital_curr_cd  -- 实收资本币种代码
    ,invtor_cty_cd  -- 投资方国家代码
    ,mang_field_area  -- 经营场地面积
    ,asset_tot  -- 资产总额
    ,net_asset_tot  -- 净资产总额
    ,single_lp_flg  -- 独立法人标志
    ,high_new_tech_corp_flg  -- 高新技术企业标志
    ,rela_party_flg  -- 关联方标志
    ,rela_group_type_cd  -- 关联集团类型代码
    ,group_cust_flg  -- 集团客户标志
    ,cbrc_sb_flg  -- 银监小企业标志
    ,labor_inte_flg  -- 劳动密集型标志
    ,hold_type_cd  -- 控股类型代码
    ,off_shore_cust_flg  -- 离岸客户标志
    ,prit_etp_flg  -- 民营企业标志
    ,ctysd_corp_flg  -- 农村企业标志
    ,corp_grow_stage_cd  -- 企业成长阶段代码
    ,list_corp_type_cd  -- 上市公司类型代码
    ,list_corp_flg  -- 上市企业标志
    ,open_cap  -- 开办资金
    ,crdt_cust_flg  -- 授信客户标志
    ,stament_flg  -- 自证声明标志
    ,tax_org_cate_cd  -- 税收机构类别代码
    ,tax_resdnt_cty_cd  -- 税收居民国家代码
    ,tax_resdnt_idti_cd  -- 税收居民身份代码
    ,tax_num  -- 纳税人识别号
    ,tax_num_null_rs_descb  -- 纳税人识别号空值原因描述
    ,bel_thi_flg  -- 属于两高行业标志
    ,trast_tax_regi_cert_flg  -- 办理税务登记证标志
    ,cty_key_enterp_flg  -- 国家重点企业标志
    ,group_corp_flg  -- 集团公司标志
    ,group_cust_id  -- 集团客户编号
    ,group_parent_corp_id  -- 集团母公司编号
    ,lmt_or_encrge_indus_cd  -- 限制或鼓励行业代码
    ,have_bod_flg  -- 有董事会标志
    ,green_crdt_cust_flg  -- 绿色信贷客户标志
    ,edu_hea_flg  -- 文教健康标志
    ,inc_flg  -- 普惠标志
    ,araf_flg  -- 三农标志
    ,is_mx_mgmt_righ_flg  -- 有无进出口经营权标志
    ,escp_debt_corp_flg  -- 逃废债企业标志
    ,is_mx_oper_item_flg  -- 有无进出口经营项标志
    ,resdnt_flg  -- 居民标志
    ,dom_overs_flg  -- 境内外标志
    ,work_addr  -- 办公地址
    ,work_addr_zip_cd  -- 办公地址邮政编码
    ,posta_addr  -- 通讯地址
    ,posta_addr_zip_cd  -- 通讯地址邮政编码
    ,prod_mang_addr  -- 生产经营地址
    ,prod_mang_addr_zip_cd  -- 生产经营地址邮政编码
    ,crdt_cust_risk_rating_cd  -- 信贷客户风险评级代码
    ,crdt_cust_risk_rating_start_dt  -- 信贷客户风险评级开始日期
    ,crdt_cust_risk_rating_exp_dt  -- 信贷客户风险评级到期日期
    ,ownsp_type_cd  -- 所有制类型代码
    ,corp_close_flg  -- 企业关停标志
    ,gover_fin_plat_flg  -- 政府融资平台标志
    ,short_check_blklist_flg  -- 空头支票黑名单标志
    ,fir_lon_dt  -- 首贷日期
    ,orgnz_surviv_status_cd  -- 组织机构存续状态代码
    ,corp_idti_idf_type_cd  -- 企业身份标识类型代码
    ,major_contrior_cnt  -- 主要出资人个数
    ,actl_ctrler_cnt  -- 实际控制人个数
    ,fin_dept_phone  -- 财务部门联系电话
    ,basic_acct_open_bank_name        --基本账户开户行名称
    ,basic_acct_acct_num              --基本账户账号
    ,green_crdt_cls_cd                --绿色信贷分类代码 
    ,sci_tech_corp_cls_cd             --科技型企业分类代码
    ,sci_tech_corp_idtfy_dt           --科技型企业认定日期  
    ,mang_site_cd                     --经营所在地区代码  
    ,strtg_cust_flg                   --战略客户标志
    ,create_chn_cd                    --创建渠道代码     
    ,strate_new_indus_cls_cd          --战略性新兴产业分类代码
    ,lp_org_name	                    --法人机构名称
    ,lp_org_type_cd	                  --法人机构类型代码
    ,lp_org_cust_id	                  --法人机构客户编号
    ,job_cd                           --任务代码
    ,etl_timestamp                    --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'')  -- 客户英文名称
    ,replace(replace(t1.cust_kind_cd,chr(13),''),chr(10),'')  -- 客户种类代码
    ,t1.open_acct_dt  -- 开户日期
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'')  -- 开户柜员编号
    ,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'')  -- 开户渠道代码
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'')  -- 客户类型代码
    ,replace(replace(t1.crdt_cust_type_cd,chr(13),''),chr(10),'')  -- 信贷客户类型代码
    ,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'')  -- 客户级别代码
    ,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'')  -- 存款人类别代码
    ,replace(replace(t1.bal_pay_way_cd,chr(13),''),chr(10),'')  -- 收支方式代码
    ,replace(replace(t1.cust_status_cd,chr(13),''),chr(10),'')  -- 客户状态代码
    ,t1.corp_anl_inco  -- 企业年收入
    ,t1.corp_year_bus_lmt  -- 企业年营业额
    ,t1.corp_found_dt  -- 企业成立日期
    ,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'')  -- 企业规模代码
    ,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'')  -- 行业门类代码
    ,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'')  -- 行业类型代码
    ,replace(replace(t1.indus_type_cd_crdtc,chr(13),''),chr(10),'')  -- 行业类型代码_征信
    ,replace(replace(t1.phone_crdtc,chr(13),''),chr(10),'')  -- 联系电话_征信
    ,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'')  -- 企业类型代码
    ,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'')  -- 国家和地区代码
    ,replace(replace(t1.rg_cd,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.econ_char_cd,chr(13),''),chr(10),'')  -- 经济性质代码
    ,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'')  -- 经济类型代码
    ,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'')  -- 组织机构代码
    ,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'')  -- 组织机构类型代码
    ,replace(replace(t1.natnal_econ_dept_type_cd,chr(13),''),chr(10),'')  -- 国民经济部门类型代码
    ,replace(replace(t1.indus_level5_cls_cd,chr(13),''),chr(10),'')  -- 行业五级分类代码
    ,replace(replace(t1.indus_crdt_rating_cd,chr(13),''),chr(10),'')  -- 行业信用评级代码
    ,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'')  -- 统一社会信用代码
    ,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'')  -- 营业执照号
    ,t1.bus_lics_exp_dt  -- 营业执照到期日期
    ,replace(replace(t1.nation_tax_rgst_cert_num,chr(13),''),chr(10),'')  -- 国税登记证号码
    ,replace(replace(t1.local_tax_rgst_cert_num,chr(13),''),chr(10),'')  -- 地税登记证号码
    ,replace(replace(t1.fin_lics_num,chr(13),''),chr(10),'')  -- 金融许可证号
    ,replace(replace(t1.pbc_pay_bank_no,chr(13),''),chr(10),'')  -- 人行支付行号
    ,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'')  -- 经济组织形式代码
    ,replace(replace(t1.loan_card_no,chr(13),''),chr(10),'')  -- 贷款卡号
    ,replace(replace(t1.oper_range,chr(13),''),chr(10),'')  -- 经营范围
    ,t1.emply_qtty  -- 员工数量
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.rgst_cap  -- 注册资金
    ,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'')  -- 注册地址
    ,t1.rgst_dt  -- 注册日期
    ,replace(replace(t1.rgstion_cd,chr(13),''),chr(10),'')  -- 登记注册代码
    ,replace(replace(t1.mang_field_prop_cd,chr(13),''),chr(10),'')  -- 经营场地所有权代码
    ,replace(replace(t1.corp_rgstion_type,chr(13),''),chr(10),'')  -- 企业登记注册类型
    ,t1.paid_in_capital  -- 实收资本
    ,replace(replace(t1.paid_in_capital_curr_cd,chr(13),''),chr(10),'')  -- 实收资本币种代码
    ,replace(replace(t1.invtor_cty_cd,chr(13),''),chr(10),'')  -- 投资方国家代码
    ,t1.mang_field_area  -- 经营场地面积
    ,t1.asset_tot  -- 资产总额
    ,t1.net_asset_tot  -- 净资产总额
    ,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'')  -- 独立法人标志
    ,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'')  -- 高新技术企业标志
    ,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'')  -- 关联方标志
    ,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'')  -- 关联集团类型代码
    ,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'')  -- 集团客户标志
    ,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'')  -- 银监小企业标志
    ,replace(replace(t1.labor_inte_flg,chr(13),''),chr(10),'')  -- 劳动密集型标志
    ,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'')  -- 控股类型代码
    ,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'')  -- 离岸客户标志
    ,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'')  -- 民营企业标志
    ,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'')  -- 农村企业标志
    ,replace(replace(t1.corp_grow_stage_cd,chr(13),''),chr(10),'')  -- 企业成长阶段代码
    ,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'')  -- 上市公司类型代码
    ,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'')  -- 上市企业标志
    ,t1.open_cap  -- 开办资金
    ,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'')  -- 授信客户标志
    ,replace(replace(t1.stament_flg,chr(13),''),chr(10),'')  -- 自证声明标志
    ,replace(replace(t1.tax_org_cate_cd,chr(13),''),chr(10),'')  -- 税收机构类别代码
    ,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'')  -- 税收居民国家代码
    ,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'')  -- 税收居民身份代码
    ,replace(replace(t1.tax_num,chr(13),''),chr(10),'')  -- 纳税人识别号
    ,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'')  -- 纳税人识别号空值原因描述
    ,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'')  -- 属于两高行业标志
    ,replace(replace(t1.trast_tax_regi_cert_flg,chr(13),''),chr(10),'')  -- 办理税务登记证标志
    ,replace(replace(t1.cty_key_enterp_flg,chr(13),''),chr(10),'')  -- 国家重点企业标志
    ,replace(replace(t1.group_corp_flg,chr(13),''),chr(10),'')  -- 集团公司标志
    ,replace(replace(t1.group_cust_id,chr(13),''),chr(10),'')  -- 集团客户编号
    ,replace(replace(t1.group_parent_corp_id,chr(13),''),chr(10),'')  -- 集团母公司编号
    ,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'')  -- 限制或鼓励行业代码
    ,replace(replace(t1.have_bod_flg,chr(13),''),chr(10),'')  -- 有董事会标志
    ,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'')  -- 绿色信贷客户标志
    ,replace(replace(t1.edu_hea_flg,chr(13),''),chr(10),'')  -- 文教健康标志
    ,replace(replace(t1.inc_flg,chr(13),''),chr(10),'')  -- 普惠标志
    ,replace(replace(t1.araf_flg,chr(13),''),chr(10),'')  -- 三农标志
    ,replace(replace(t1.is_mx_mgmt_righ_flg,chr(13),''),chr(10),'')  -- 有无进出口经营权标志
    ,replace(replace(t1.escp_debt_corp_flg,chr(13),''),chr(10),'')  -- 逃废债企业标志
    ,replace(replace(t1.is_mx_oper_item_flg,chr(13),''),chr(10),'')  -- 有无进出口经营项标志
    ,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'')  -- 居民标志
    ,replace(replace(t1.dom_overs_flg,chr(13),''),chr(10),'')  -- 境内外标志
    ,replace(replace(t1.work_addr,chr(13),''),chr(10),'')  -- 办公地址
    ,replace(replace(t1.work_addr_zip_cd,chr(13),''),chr(10),'')  -- 办公地址邮政编码
    ,replace(replace(t1.posta_addr,chr(13),''),chr(10),'')  -- 通讯地址
    ,replace(replace(t1.posta_addr_zip_cd,chr(13),''),chr(10),'')  -- 通讯地址邮政编码
    ,replace(replace(t1.prod_mang_addr,chr(13),''),chr(10),'')  -- 生产经营地址
    ,replace(replace(t1.prod_mang_addr_zip_cd,chr(13),''),chr(10),'')  -- 生产经营地址邮政编码
    ,replace(replace(t1.crdt_cust_risk_rating_cd,chr(13),''),chr(10),'')  -- 信贷客户风险评级代码
    ,t1.crdt_cust_risk_rating_start_dt  -- 信贷客户风险评级开始日期
    ,t1.crdt_cust_risk_rating_exp_dt  -- 信贷客户风险评级到期日期
    ,replace(replace(t1.ownsp_type_cd,chr(13),''),chr(10),'')  -- 所有制类型代码
    ,replace(replace(t1.corp_close_flg,chr(13),''),chr(10),'')  -- 企业关停标志
    ,replace(replace(t1.gover_fin_plat_flg,chr(13),''),chr(10),'')  -- 政府融资平台标志
    ,replace(replace(t1.short_check_blklist_flg,chr(13),''),chr(10),'')  -- 空头支票黑名单标志
    ,t1.fir_lon_dt  -- 首贷日期
    ,replace(replace(t1.orgnz_surviv_status_cd,chr(13),''),chr(10),'')  -- 组织机构存续状态代码
    ,replace(replace(t1.corp_idti_idf_type_cd,chr(13),''),chr(10),'')  -- 企业身份标识类型代码
    ,t1.major_contrior_cnt  -- 主要出资人个数
    ,t1.actl_ctrler_cnt  -- 实际控制人个数
    ,replace(replace(t1.fin_dept_phone,chr(13),''),chr(10),'')  -- 财务部门联系电话
    ,replace(replace(t1.basic_acct_open_bank_name,chr(13),''),chr(10),'')     --基本账户开户行名称 
    ,replace(replace(t1.basic_acct_acct_num,chr(13),''),chr(10),'')      --基本账户账号
    ,replace(replace(t1.green_crdt_cls_cd,chr(13),''),chr(10),'') as green_crdt_cls_cd
    ,replace(replace(t1.sci_tech_corp_cls_cd,chr(13),''),chr(10),'') as sci_tech_corp_cls_cd
    ,t1.sci_tech_corp_idtfy_dt as sci_tech_corp_idtfy_dt
    ,replace(replace(t1.mang_site_cd,chr(13),''),chr(10),'') as mang_site_cd                        --经营所在地区代码
    ,replace(replace(t1.strtg_cust_flg,chr(13),''),chr(10),'') as strtg_cust_flg                    --战略客户标志    
    ,replace(replace(t1.create_chn_cd,chr(13),''),chr(10),'') as create_chn_cd                      --创建渠道代码    
    ,replace(replace(t1.strate_new_indus_cls_cd,chr(13),''),chr(10),'') as strate_new_indus_cls_cd  --战略性新兴产业分类代码
    ,replace(replace(t1.lp_org_name,chr(13),''),chr(10),'') as lp_org_name                           --法人机构名称  
    ,replace(replace(t1.lp_org_type_cd,chr(13),''),chr(10),'') as lp_org_type_cd                     --法人机构类型代码
    ,replace(replace(t1.lp_org_cust_id,chr(13),''),chr(10),'') as lp_org_cust_id                     --法人机构客户编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')                                              --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp               --数据处理时间
from ${icl_schema}.cmm_corp_cust_basic_info t1                                                      --对公客户基本信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_corp_cust_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);