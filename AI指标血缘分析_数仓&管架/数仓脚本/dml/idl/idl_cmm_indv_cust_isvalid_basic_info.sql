/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_indv_cust_isvalid_basic_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_indv_cust_isvalid_basic_info drop partition p_${last_date};
alter table ${idl_schema}.cmm_indv_cust_isvalid_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_indv_cust_isvalid_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_indv_cust_isvalid_basic_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_id  -- 客户编号
    ,cust_type_cd  -- 客户类型代码
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,cert_exp_dt  -- 证件到期日期
    ,cert_issue_org  -- 证件签发机关
    ,cust_name  -- 客户名称
    ,cust_en_name  -- 客户英文名称
    ,open_acct_dt  -- 开户日期
    ,belong_org_id  -- 所属机构编号
    ,open_acct_teller_id  -- 开户柜员编号
    ,gender_cd  -- 性别代码
    ,open_acct_chn_cd  -- 开户渠道代码
    ,birth_dt  -- 出生日期
    ,marriage_situ_cd  -- 婚姻状况代码
    ,resd_status_cd  -- 居住状态代码
    ,estate_val_cd  -- 房产价值代码
    ,owner_type_cd  -- 业主类型代码
    ,politic_status_cd  -- 政治面貌代码
    ,nation_cd  -- 国籍代码
    ,dist_cd  -- 行政区域代码
    ,rg_cd  -- 地区代码
    ,nationty_cd  -- 民族代码
    ,nati_place  -- 籍贯
    ,cust_status_cd  -- 客户状态代码
    ,depositr_cate_cd  -- 存款人类别代码
    ,prov_pulation_type_cd  -- 供养人口类型代码
    ,child_number_cd  -- 子女人数代码
    ,cont_num  -- 联系号码
    ,cont_num_is_self_flg  -- 联系号码是否本人标志
    ,open_acct_rsrv_mobile_no  -- 开户预留手机号码
    ,elec_mail_addr  -- 电子邮件地址
    ,cust_lev_cd  -- 客户级别代码
    ,edu_cd  -- 学历代码
    ,degree_cd  -- 学位代码
    ,grad_sch  -- 毕业学校
    ,title_cd  -- 职称代码
    ,post_cd  -- 职务代码
    ,career_cd  -- 职业代码
    ,posta_addr  -- 通讯地址
    ,comm_zip_cd  -- 通讯邮政编码
    ,resdnt_addr  -- 常住地址
    ,resdnt_zip_cd  -- 常住邮政编码
    ,rpr_site  -- 户口所在地
    ,family_addr  -- 家庭地址
    ,family_zip_cd  -- 家庭邮政编码
    ,nome_phone_num  -- 家庭电话号码
    ,work_unit_name  -- 工作单位名称
    ,work_unit_addr  -- 工作单位地址
    ,work_unit_tel  -- 工作单位电话
    ,work_unit_zip_cd  -- 工作单位邮政编码
    ,work_unit_char_cd  -- 工作单位性质代码
    ,corp_bl_induty_type_cd  -- 单位所属行业类型代码
    ,corp_work_years  -- 单位工作年限
    ,indv_mon_inco  -- 个人月收入
    ,indv_anl_inco  -- 个人年收入
    ,family_mon_inco  -- 家庭月收入
    ,family_anl_inco  -- 家庭年收入
    ,tax_resdnt_idti_cd  -- 税收居民身份代码
    ,tax_red_cty_cd  -- 税收居民国家代码
    ,tax_num  -- 纳税人识别号
    ,tax_num_null_rs_descb  -- 纳税人识别号空值原因描述
    ,stament_flg  -- 自证声明标志
    ,indv_bus_flg  -- 个体工商户标志
    ,sm_bus_owner_flg  -- 小微企业主标志
    ,resdnt_flg  -- 居民标志
    ,farm_flg  -- 农户标志
    ,ghb_emply_flg  -- 本行员工标志
    ,ghb_shard_flg  -- 本行股东标志
    ,crdt_cust_flg  -- 授信客户标志
    ,real_name_flg  -- 实名标志
    ,dom_overs_flg  -- 境内外标志
    ,local_estate_flg  -- 当地房产标志
    ,local_soci_secu_flg  -- 当地社保标志
    ,ctysd_contr_oper_acct_flg  -- 农村承包经营户标志
    ,ghb_rela_peop_flg  -- 本行关系人标志
    ,hxb_shard_flg  -- 我行股东标志
    ,hxb_trast_inter_bus_flg  -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg  -- 我行代发工资户标志
    ,hxb_reg_cust_flg  -- 我行定期客户标志
    ,hxb_finc_cust_flg  -- 我行理财客户标志
    ,hxb_vip_cust_idf  -- 我行VIP客户标识
    ,spouse_and_child_img_flg  -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg  -- 享受国家优惠政策标志
    ,cust_mgr_id  -- 客户经理编号
    ,employ_type_cd  -- 雇佣类型代码
    ,clos_acct_dt  -- 销户日期
    ,clos_acct_org_id  -- 销户机构编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,have_car_flg  -- 拥有汽车标志
    ,salar_flg  -- 受薪人士标志
    ,civ_sert_flg  -- 公务员标志
    ,tax_red_en_name  -- 税收居民英文名称
    ,other_career_info  -- 其他职业信息
    ,curt_corp_empyt_dt  -- 现单位入职日期
    ,rela_tran_flg  -- 关联交易标志
    ,non_plat_cust_flg  -- 非平台客户标志
    ,cert_effect_dt  -- 证件生效日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd  -- 客户类型代码
    ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd  -- 证件类型代码
    ,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no  -- 证件号码
    ,t1.cert_exp_dt as cert_exp_dt  -- 证件到期日期
    ,replace(replace(t1.cert_issue_org,chr(13),''),chr(10),'') as cert_issue_org  -- 证件签发机关
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name  -- 客户名称
    ,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'') as cust_en_name  -- 客户英文名称
    ,t1.open_acct_dt as open_acct_dt  -- 开户日期
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id  -- 开户柜员编号
    ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd  -- 性别代码
    ,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd  -- 开户渠道代码
    ,t1.birth_dt as birth_dt  -- 出生日期
    ,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd  -- 婚姻状况代码
    ,replace(replace(t1.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd  -- 居住状态代码
    ,replace(replace(t1.estate_val_cd,chr(13),''),chr(10),'') as estate_val_cd  -- 房产价值代码
    ,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd  -- 业主类型代码
    ,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd  -- 政治面貌代码
    ,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd  -- 国籍代码
    ,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd  -- 行政区域代码
    ,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd  -- 地区代码
    ,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd  -- 民族代码
    ,replace(replace(t1.nati_place,chr(13),''),chr(10),'') as nati_place  -- 籍贯
    ,replace(replace(t1.cust_status_cd,chr(13),''),chr(10),'') as cust_status_cd  -- 客户状态代码
    ,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd  -- 存款人类别代码
    ,replace(replace(t1.prov_pulation_type_cd,chr(13),''),chr(10),'') as prov_pulation_type_cd  -- 供养人口类型代码
    ,replace(replace(t1.child_number_cd,chr(13),''),chr(10),'') as child_number_cd  -- 子女人数代码
    ,replace(replace(t1.cont_num,chr(13),''),chr(10),'') as cont_num  -- 联系号码
    ,replace(replace(t1.cont_num_is_self_flg,chr(13),''),chr(10),'') as cont_num_is_self_flg  -- 联系号码是否本人标志
    ,replace(replace(t1.open_acct_rsrv_mobile_no,chr(13),''),chr(10),'') as open_acct_rsrv_mobile_no  -- 开户预留手机号码
    ,replace(replace(t1.elec_mail_addr,chr(13),''),chr(10),'') as elec_mail_addr  -- 电子邮件地址
    ,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd  -- 客户级别代码
    ,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd  -- 学历代码
    ,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd  -- 学位代码
    ,replace(replace(t1.grad_sch,chr(13),''),chr(10),'') as grad_sch  -- 毕业学校
    ,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd  -- 职称代码
    ,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd  -- 职务代码
    ,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd  -- 职业代码
    ,replace(replace(t1.posta_addr,chr(13),''),chr(10),'') as posta_addr  -- 通讯地址
    ,replace(replace(t1.comm_zip_cd,chr(13),''),chr(10),'') as comm_zip_cd  -- 通讯邮政编码
    ,replace(replace(t1.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr  -- 常住地址
    ,replace(replace(t1.resdnt_zip_cd,chr(13),''),chr(10),'') as resdnt_zip_cd  -- 常住邮政编码
    ,replace(replace(t1.rpr_site,chr(13),''),chr(10),'') as rpr_site  -- 户口所在地
    ,replace(replace(t1.family_addr,chr(13),''),chr(10),'') as family_addr  -- 家庭地址
    ,replace(replace(t1.family_zip_cd,chr(13),''),chr(10),'') as family_zip_cd  -- 家庭邮政编码
    ,replace(replace(t1.nome_phone_num,chr(13),''),chr(10),'') as nome_phone_num  -- 家庭电话号码
    ,replace(replace(t1.work_unit_name,chr(13),''),chr(10),'') as work_unit_name  -- 工作单位名称
    ,replace(replace(t1.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr  -- 工作单位地址
    ,replace(replace(t1.work_unit_tel,chr(13),''),chr(10),'') as work_unit_tel  -- 工作单位电话
    ,replace(replace(t1.work_unit_zip_cd,chr(13),''),chr(10),'') as work_unit_zip_cd  -- 工作单位邮政编码
    ,replace(replace(t1.work_unit_char_cd,chr(13),''),chr(10),'') as work_unit_char_cd  -- 工作单位性质代码
    ,replace(replace(t1.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd  -- 单位所属行业类型代码
    ,t1.corp_work_years as corp_work_years  -- 单位工作年限
    ,t1.indv_mon_inco as indv_mon_inco  -- 个人月收入
    ,t1.indv_anl_inco as indv_anl_inco  -- 个人年收入
    ,t1.family_mon_inco as family_mon_inco  -- 家庭月收入
    ,t1.family_anl_inco as family_anl_inco  -- 家庭年收入
    ,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd  -- 税收居民身份代码
    ,replace(replace(t1.tax_red_cty_cd,chr(13),''),chr(10),'') as tax_red_cty_cd  -- 税收居民国家代码
    ,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num  -- 纳税人识别号
    ,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb  -- 纳税人识别号空值原因描述
    ,replace(replace(t1.stament_flg,chr(13),''),chr(10),'') as stament_flg  -- 自证声明标志
    ,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg  -- 个体工商户标志
    ,replace(replace(t1.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg  -- 小微企业主标志
    ,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg  -- 居民标志
    ,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg  -- 农户标志
    ,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg  -- 本行员工标志
    ,replace(replace(t1.ghb_shard_flg,chr(13),''),chr(10),'') as ghb_shard_flg  -- 本行股东标志
    ,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg  -- 授信客户标志
    ,replace(replace(t1.real_name_flg,chr(13),''),chr(10),'') as real_name_flg  -- 实名标志
    ,replace(replace(t1.dom_overs_flg,chr(13),''),chr(10),'') as dom_overs_flg  -- 境内外标志
    ,replace(replace(t1.local_estate_flg,chr(13),''),chr(10),'') as local_estate_flg  -- 当地房产标志
    ,replace(replace(t1.local_soci_secu_flg,chr(13),''),chr(10),'') as local_soci_secu_flg  -- 当地社保标志
    ,replace(replace(t1.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg  -- 农村承包经营户标志
    ,replace(replace(t1.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg  -- 本行关系人标志
    ,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg  -- 我行股东标志
    ,replace(replace(t1.hxb_trast_inter_bus_flg,chr(13),''),chr(10),'') as hxb_trast_inter_bus_flg  -- 在我行办理过中间业务标志
    ,replace(replace(t1.hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'') as hxb_payoff_sal_acct_flg  -- 我行代发工资户标志
    ,replace(replace(t1.hxb_reg_cust_flg,chr(13),''),chr(10),'') as hxb_reg_cust_flg  -- 我行定期客户标志
    ,replace(replace(t1.hxb_finc_cust_flg,chr(13),''),chr(10),'') as hxb_finc_cust_flg  -- 我行理财客户标志
    ,replace(replace(t1.hxb_vip_cust_idf,chr(13),''),chr(10),'') as hxb_vip_cust_idf  -- 我行VIP客户标识
    ,replace(replace(t1.spouse_and_child_img_flg,chr(13),''),chr(10),'') as spouse_and_child_img_flg  -- 配偶及子女移民标志
    ,replace(replace(t1.enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'') as enjoy_cty_prefr_policy_flg  -- 享受国家优惠政策标志
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id  -- 客户经理编号
    ,replace(replace(t1.employ_type_cd,chr(13),''),chr(10),'') as employ_type_cd  -- 雇佣类型代码
    ,t1.clos_acct_dt as clos_acct_dt  -- 销户日期
    ,replace(replace(t1.clos_acct_org_id,chr(13),''),chr(10),'') as clos_acct_org_id  -- 销户机构编号
    ,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id  -- 销户柜员编号
    ,replace(replace(t1.have_car_flg,chr(13),''),chr(10),'') as have_car_flg  -- 拥有汽车标志
    ,replace(replace(t1.salar_flg,chr(13),''),chr(10),'') as salar_flg  -- 受薪人士标志
    ,replace(replace(t1.civ_sert_flg,chr(13),''),chr(10),'') as civ_sert_flg  -- 公务员标志
    ,replace(replace(t1.tax_red_en_name,chr(13),''),chr(10),'') as tax_red_en_name  -- 税收居民英文名称
    ,replace(replace(t1.other_career_info,chr(13),''),chr(10),'') as other_career_info  -- 其他职业信息
    ,t1.curt_corp_empyt_dt as curt_corp_empyt_dt  -- 现单位入职日期
    ,replace(replace(t1.rela_tran_flg,chr(13),''),chr(10),'') as rela_tran_flg  -- 关联交易标志
    ,case when trim(t2.cust_id) is not null then '1' else '0' end as non_plat_cust_flg  -- 非平台客户标志
    ,replace(replace(t1.cert_effect_dt,chr(13),''),chr(10),'') as cert_effect_dt  -- 证件生效日期
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
from ${icl_schema}.cmm_indv_cust_basic_info t1    --个人客户是否有效基本信息
left join (select cust_id from (select cust_id
  from icl.cmm_dep_acct_info
 where etl_dt = to_date('${batch_date}','yyyymmdd')
/*
union all
select cust_id
  from icl.cmm_e_acct_info
 where etl_dt = to_date('${batch_date}','yyyymmdd')
 */
union all
select cust_id
  from icl.cmm_retl_loan_acct_info
 where etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select cust_id
  from icl.cmm_retl_loan_dubil_info
 where etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select cust_id
  from iml.agt_loan_appl_basic_info_h
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt >to_date('${batch_date}','yyyymmdd')
   and job_cd ='icmsf1'
) group by cust_id) t2
    on t1.cust_id=t2.cust_id
where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')  ;
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_indv_cust_isvalid_basic_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_indv_cust_isvalid_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);