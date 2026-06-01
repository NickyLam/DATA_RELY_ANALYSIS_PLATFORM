/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_indv_cust_basic_info
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
--alter table ${itl_schema}.itl_edw_cmm_indv_cust_basic_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_indv_cust_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_indv_cust_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_indv_cust_basic_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_effect_dt -- 证件生效日期
    ,cert_exp_dt -- 证件到期日期
    ,cert_issue_org -- 证件签发机关
    ,cust_name -- 客户名称
    ,cust_en_name -- 客户英文名称
    ,open_acct_dt -- 开户日期
    ,belong_org_id -- 所属机构编号
    ,open_acct_teller_id -- 开户柜员编号
    ,gender_cd -- 性别代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,create_chn_cd -- 创建渠道代码
    ,birth_dt -- 出生日期
    ,marriage_situ_cd -- 婚姻状况代码
    ,resd_status_cd -- 居住状态代码
    ,estate_val_cd -- 房产价值代码
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,nation_cd -- 国籍代码
    ,dist_cd -- 行政区域代码
    ,rg_cd -- 地区代码
    ,nationty_cd -- 民族代码
    ,nati_place -- 籍贯
    ,cust_status_cd -- 客户状态代码
    ,depositr_cate_cd -- 存款人类别代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,child_number_cd -- 子女人数代码
    ,cont_num -- 联系号码
    ,cont_num_is_self_flg -- 联系号码是否本人标志
    ,open_acct_rsrv_mobile_no -- 开户预留手机号码
    ,elec_mail_addr -- 电子邮件地址
    ,cust_lev_cd -- 客户级别代码
    ,edu_cd -- 学历代码
    ,degree_cd -- 学位代码
    ,grad_sch -- 毕业学校
    ,title_cd -- 职称代码
    ,post_cd -- 职务代码
    ,career_cd -- 职业代码
    ,posta_addr -- 通讯地址
    ,comm_zip_cd -- 通讯邮政编码
    ,resdnt_addr -- 常住地址
    ,resdnt_zip_cd -- 常住邮政编码
    ,rpr_site -- 户口所在地
    ,family_addr -- 家庭地址
    ,family_zip_cd -- 家庭邮政编码
    ,nome_phone_num -- 家庭电话号码
    ,work_unit_name -- 工作单位名称
    ,work_unit_addr -- 工作单位地址
    ,work_unit_tel -- 工作单位电话
    ,work_unit_zip_cd -- 工作单位邮政编码
    ,work_unit_char_cd -- 工作单位性质代码
    ,corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,corp_work_years -- 单位工作年限
    ,indv_mon_inco -- 个人月收入
    ,indv_anl_inco -- 个人年收入
    ,family_mon_inco -- 家庭月收入
    ,family_anl_inco -- 家庭年收入
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,tax_red_cty_cd -- 税收居民国家代码
    ,tax_num -- 纳税人识别号
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,stament_flg -- 自证声明标志
    ,indv_bus_flg -- 个体工商户标志
    ,sm_bus_owner_flg -- 小微企业主标志
    ,resdnt_flg -- 居民标志
    ,farm_flg -- 农户标志
    ,ghb_emply_flg -- 本行员工标志
    ,ghb_shard_flg -- 本行股东标志
    ,crdt_cust_flg -- 授信客户标志
    ,real_name_flg -- 实名标志
    ,dom_overs_flg -- 境内外标志
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,hxb_shard_flg -- 我行股东标志
    ,hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,hxb_reg_cust_flg -- 我行定期客户标志
    ,hxb_finc_cust_flg -- 我行理财客户标志
    ,hxb_vip_cust_idf -- 我行VIP客户标识
    ,spouse_and_child_img_flg -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,cust_mgr_id -- 客户经理编号
    ,employ_type_cd -- 雇佣类型代码
    ,clos_acct_dt -- 销户日期
    ,clos_acct_org_id -- 销户机构编号
    ,clos_acct_teller_id -- 销户柜员编号
    ,have_car_flg -- 拥有汽车标志
    ,salar_flg -- 受薪人士标志
    ,civ_sert_flg -- 公务员标志
    ,tax_red_en_name -- 税收居民英文名称
    ,other_career_info -- 其他职业信息
    ,curt_corp_empyt_dt -- 现单位入职日期
    ,rela_tran_flg -- 关联方标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(cust_type_cd), ' ') as cust_type_cd -- 客户类型代码
    ,nvl(trim(cert_type_cd), ' ') as cert_type_cd -- 证件类型代码
    ,nvl(trim(cert_no), ' ') as cert_no -- 证件号码
    ,nvl(cert_effect_dt, to_date('00010101', 'yyyymmdd')) as cert_effect_dt -- 证件生效日期
    ,nvl(cert_exp_dt, to_date('00010101', 'yyyymmdd')) as cert_exp_dt -- 证件到期日期
    ,nvl(trim(cert_issue_org), ' ') as cert_issue_org -- 证件签发机关
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(cust_en_name), ' ') as cust_en_name -- 客户英文名称
    ,nvl(open_acct_dt, to_date('00010101', 'yyyymmdd')) as open_acct_dt -- 开户日期
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(open_acct_teller_id), ' ') as open_acct_teller_id -- 开户柜员编号
    ,nvl(trim(gender_cd), ' ') as gender_cd -- 性别代码
    ,nvl(trim(open_acct_chn_cd), ' ') as open_acct_chn_cd -- 开户渠道代码
    ,nvl(trim(create_chn_cd), ' ') as create_chn_cd -- 创建渠道代码
    ,nvl(birth_dt, to_date('00010101', 'yyyymmdd')) as birth_dt -- 出生日期
    ,nvl(trim(marriage_situ_cd), ' ') as marriage_situ_cd -- 婚姻状况代码
    ,nvl(trim(resd_status_cd), ' ') as resd_status_cd -- 居住状态代码
    ,nvl(trim(estate_val_cd), ' ') as estate_val_cd -- 房产价值代码
    ,nvl(trim(owner_type_cd), ' ') as owner_type_cd -- 业主类型代码
    ,nvl(trim(politic_status_cd), ' ') as politic_status_cd -- 政治面貌代码
    ,nvl(trim(nation_cd), ' ') as nation_cd -- 国籍代码
    ,nvl(trim(dist_cd), ' ') as dist_cd -- 行政区域代码
    ,nvl(trim(rg_cd), ' ') as rg_cd -- 地区代码
    ,nvl(trim(nationty_cd), ' ') as nationty_cd -- 民族代码
    ,nvl(trim(nati_place), ' ') as nati_place -- 籍贯
    ,nvl(trim(cust_status_cd), ' ') as cust_status_cd -- 客户状态代码
    ,nvl(trim(depositr_cate_cd), ' ') as depositr_cate_cd -- 存款人类别代码
    ,nvl(trim(prov_pulation_type_cd), ' ') as prov_pulation_type_cd -- 供养人口类型代码
    ,nvl(trim(child_number_cd), ' ') as child_number_cd -- 子女人数代码
    ,nvl(trim(cont_num), ' ') as cont_num -- 联系号码
    ,nvl(trim(cont_num_is_self_flg), ' ') as cont_num_is_self_flg -- 联系号码是否本人标志
    ,nvl(trim(open_acct_rsrv_mobile_no), ' ') as open_acct_rsrv_mobile_no -- 开户预留手机号码
    ,nvl(trim(elec_mail_addr), ' ') as elec_mail_addr -- 电子邮件地址
    ,nvl(trim(cust_lev_cd), ' ') as cust_lev_cd -- 客户级别代码
    ,nvl(trim(edu_cd), ' ') as edu_cd -- 学历代码
    ,nvl(trim(degree_cd), ' ') as degree_cd -- 学位代码
    ,nvl(trim(grad_sch), ' ') as grad_sch -- 毕业学校
    ,nvl(trim(title_cd), ' ') as title_cd -- 职称代码
    ,nvl(trim(post_cd), ' ') as post_cd -- 职务代码
    ,nvl(trim(career_cd), ' ') as career_cd -- 职业代码
    ,nvl(trim(posta_addr), ' ') as posta_addr -- 通讯地址
    ,nvl(trim(comm_zip_cd), ' ') as comm_zip_cd -- 通讯邮政编码
    ,nvl(trim(resdnt_addr), ' ') as resdnt_addr -- 常住地址
    ,nvl(trim(resdnt_zip_cd), ' ') as resdnt_zip_cd -- 常住邮政编码
    ,nvl(trim(rpr_site), ' ') as rpr_site -- 户口所在地
    ,nvl(trim(family_addr), ' ') as family_addr -- 家庭地址
    ,nvl(trim(family_zip_cd), ' ') as family_zip_cd -- 家庭邮政编码
    ,nvl(trim(nome_phone_num), ' ') as nome_phone_num -- 家庭电话号码
    ,nvl(trim(work_unit_name), ' ') as work_unit_name -- 工作单位名称
    ,nvl(trim(work_unit_addr), ' ') as work_unit_addr -- 工作单位地址
    ,nvl(trim(work_unit_tel), ' ') as work_unit_tel -- 工作单位电话
    ,nvl(trim(work_unit_zip_cd), ' ') as work_unit_zip_cd -- 工作单位邮政编码
    ,nvl(trim(work_unit_char_cd), ' ') as work_unit_char_cd -- 工作单位性质代码
    ,nvl(trim(corp_bl_induty_type_cd), ' ') as corp_bl_induty_type_cd -- 单位所属行业类型代码
    ,nvl(trim(corp_work_years), 0) as corp_work_years -- 单位工作年限
    ,nvl(trim(indv_mon_inco), 0) as indv_mon_inco -- 个人月收入
    ,nvl(trim(indv_anl_inco), 0) as indv_anl_inco -- 个人年收入
    ,nvl(trim(family_mon_inco), 0) as family_mon_inco -- 家庭月收入
    ,nvl(trim(family_anl_inco), 0) as family_anl_inco -- 家庭年收入
    ,nvl(trim(tax_resdnt_idti_cd), ' ') as tax_resdnt_idti_cd -- 税收居民身份代码
    ,nvl(trim(tax_red_cty_cd), ' ') as tax_red_cty_cd -- 税收居民国家代码
    ,nvl(trim(tax_num), ' ') as tax_num -- 纳税人识别号
    ,nvl(trim(tax_num_null_rs_descb), ' ') as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,nvl(trim(stament_flg), ' ') as stament_flg -- 自证声明标志
    ,nvl(trim(indv_bus_flg), ' ') as indv_bus_flg -- 个体工商户标志
    ,nvl(trim(sm_bus_owner_flg), ' ') as sm_bus_owner_flg -- 小微企业主标志
    ,nvl(trim(resdnt_flg), ' ') as resdnt_flg -- 居民标志
    ,nvl(trim(farm_flg), ' ') as farm_flg -- 农户标志
    ,nvl(trim(ghb_emply_flg), ' ') as ghb_emply_flg -- 本行员工标志
    ,nvl(trim(ghb_shard_flg), ' ') as ghb_shard_flg -- 本行股东标志
    ,nvl(trim(crdt_cust_flg), ' ') as crdt_cust_flg -- 授信客户标志
    ,nvl(trim(real_name_flg), ' ') as real_name_flg -- 实名标志
    ,nvl(trim(dom_overs_flg), ' ') as dom_overs_flg -- 境内外标志
    ,nvl(trim(local_estate_flg), ' ') as local_estate_flg -- 当地房产标志
    ,nvl(trim(local_soci_secu_flg), ' ') as local_soci_secu_flg -- 当地社保标志
    ,nvl(trim(ctysd_contr_oper_acct_flg), ' ') as ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,nvl(trim(ghb_rela_peop_flg), ' ') as ghb_rela_peop_flg -- 本行关系人标志
    ,nvl(trim(hxb_shard_flg), ' ') as hxb_shard_flg -- 我行股东标志
    ,nvl(trim(hxb_trast_inter_bus_flg), ' ') as hxb_trast_inter_bus_flg -- 在我行办理过中间业务标志
    ,nvl(trim(hxb_payoff_sal_acct_flg), ' ') as hxb_payoff_sal_acct_flg -- 我行代发工资户标志
    ,nvl(trim(hxb_reg_cust_flg), ' ') as hxb_reg_cust_flg -- 我行定期客户标志
    ,nvl(trim(hxb_finc_cust_flg), ' ') as hxb_finc_cust_flg -- 我行理财客户标志
    ,nvl(trim(hxb_vip_cust_idf), ' ') as hxb_vip_cust_idf -- 我行VIP客户标识
    ,nvl(trim(spouse_and_child_img_flg), ' ') as spouse_and_child_img_flg -- 配偶及子女移民标志
    ,nvl(trim(enjoy_cty_prefr_policy_flg), ' ') as enjoy_cty_prefr_policy_flg -- 享受国家优惠政策标志
    ,nvl(trim(cust_mgr_id), ' ') as cust_mgr_id -- 客户经理编号
    ,nvl(trim(employ_type_cd), ' ') as employ_type_cd -- 雇佣类型代码
    ,nvl(clos_acct_dt, to_date('00010101', 'yyyymmdd')) as clos_acct_dt -- 销户日期
    ,nvl(trim(clos_acct_org_id), ' ') as clos_acct_org_id -- 销户机构编号
    ,nvl(trim(clos_acct_teller_id), ' ') as clos_acct_teller_id -- 销户柜员编号
    ,nvl(trim(have_car_flg), ' ') as have_car_flg -- 拥有汽车标志
    ,nvl(trim(salar_flg), ' ') as salar_flg -- 受薪人士标志
    ,nvl(trim(civ_sert_flg), ' ') as civ_sert_flg -- 公务员标志
    ,nvl(trim(tax_red_en_name), ' ') as tax_red_en_name -- 税收居民英文名称
    ,nvl(trim(other_career_info), ' ') as other_career_info -- 其他职业信息
    ,nvl(curt_corp_empyt_dt, to_date('00010101', 'yyyymmdd')) as curt_corp_empyt_dt -- 现单位入职日期
    ,nvl(trim(rela_tran_flg), ' ') as rela_tran_flg -- 关联方标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_indv_cust_basic_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_indv_cust_basic_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_indv_cust_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);