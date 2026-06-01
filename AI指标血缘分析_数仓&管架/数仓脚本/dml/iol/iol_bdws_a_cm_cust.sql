/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_cm_cust
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
drop table ${iol_schema}.bdws_a_cm_cust_ex purge;
alter table ${iol_schema}.bdws_a_cm_cust add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_a_cm_cust truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_a_cm_cust_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_a_cm_cust where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_a_cm_cust_ex(
    cust_id -- 
    ,cust_name -- 
    ,ecif_cust_id -- 
    ,open_dt -- 
    ,sex -- 
    ,age -- 
    ,birth_dt -- 
    ,doc_type -- 
    ,idenumber -- 
    ,phone -- 
    ,asset_lev -- 
    ,mag_org_id -- 
    ,mag_org_name -- 
    ,mag_cst_org_id -- 
    ,mag_cst_org_name -- 
    ,mag_cst_mgr_id -- 
    ,mag_cst_mgr -- 
    ,sys_user_id -- 
    ,sys_user -- 
    ,house_telephone -- 
    ,ghb_emply_flg -- 
    ,mrtl_status -- 
    ,telephone -- 
    ,occupation -- 
    ,cust_state -- 
    ,law_cust_name -- 
    ,law_tel -- 
    ,address -- 
    ,nation_code -- 
    ,corp_prop -- 
    ,industry_type -- 
    ,found_date -- 
    ,tel -- 
    ,reg_curr_type -- 
    ,reg_cptl -- 
    ,reg_addr -- 
    ,is_sh -- 
    ,nation -- 
    ,ft_opac_time -- 
    ,open_org_name -- 
    ,is_hx -- 
    ,is_gh -- 
    ,card_type -- 
    ,fist_phon -- 
    ,edu_level -- 
    ,asset_bal -- 
    ,unti_xz -- 
    ,hang_ye -- 
    ,activity -- 
    ,loyalty -- 
    ,contribute -- 
    ,level_risk -- 
    ,child_num -- 
    ,per_income -- 
    ,fim_income -- 
    ,is_per_loan -- 
    ,account_num -- 
    ,use_bank_server -- 
    ,card_level -- 
    ,lc_risk -- 
    ,jj_risk -- 
    ,bx_risk -- 
    ,zg_risk -- 
    ,clos_acct_dt -- 
    ,et_dt -- 
    ,political_outlook -- 
    ,education -- 
    ,english_name -- 
    ,corporate_name -- 
    ,industry -- 
    ,corporate_nature -- 
    ,duties -- 
    ,positional_titles -- 
    ,nationality -- 
    ,religion -- 
    ,pinyin -- 
    ,is_leader -- 
    ,kid_num -- 
    ,kid_age -- 
    ,community -- 
    ,branch_bank -- 
    ,pet_type -- 
    ,is_executive -- 
    ,type_of_operation -- 
    ,business_products -- 
    ,shop_location -- 
    ,other -- 
    ,highest_card_rating -- 
    ,is_pay_by_othre_cust -- 
    ,is_hx_staff -- 
    ,positional -- 
    ,is_shop -- 
    ,pyhsical_card -- 
    ,is_contiue_cust -- 
    ,family_addr -- 
    ,elec_mail_addr -- 
    ,resd_status_cd -- 
    ,estate_val_cd -- 
    ,nome_phone_num -- 
    ,gg_org_id -- 
    ,gg_org_name -- 
    ,resdnt_addr -- 
    ,rpr_site -- 
    ,posta_addr -- 
    ,party_status_type_cd -- 
    ,qual_invtor_cert_flg -- 
    ,qual_invtor_vlid_tenor -- 
    ,lc_risk_date -- 
    ,is_new_risk -- 
    ,high_risk_flag -- 
    ,is_lingui -- 
    ,risk_level -- 
    ,new_rating_invalid_dt -- 
    ,jj_risk_date -- 
    ,bx_risk_date -- 
    ,zg_risk_date -- 
    ,cert_exp_dt -- 
    ,gh_brch_org_id -- 
    ,gh_brch_org_name -- 
    ,gh_subbrch_org_id -- 
    ,gh_subbrch_org_name -- 
    ,gg_brch_org_id -- 
    ,gg_brch_org_name -- 
    ,gg_subbrch_org_id -- 
    ,gg_subbrch_org_name -- 
    ,new_citizen_flg -- 
    ,first_open_i_acct_dt -- 
    ,is_stop_no_counter_tran -- 
    ,cust_max_aum -- 
    ,cust_max_aum_date -- 
    ,cust_avgm_aum -- 
    ,cust_avgm_aum_date -- 
    ,is_register_mgm -- 
    ,sysbrch_id -- 
    ,sysbrch_name -- 
    ,syssubbrch_id -- 
    ,syssubbrch_name -- 
    ,if_bill -- 
    ,load_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_id -- 
    ,cust_name -- 
    ,ecif_cust_id -- 
    ,open_dt -- 
    ,sex -- 
    ,age -- 
    ,birth_dt -- 
    ,doc_type -- 
    ,idenumber -- 
    ,phone -- 
    ,asset_lev -- 
    ,mag_org_id -- 
    ,mag_org_name -- 
    ,mag_cst_org_id -- 
    ,mag_cst_org_name -- 
    ,mag_cst_mgr_id -- 
    ,mag_cst_mgr -- 
    ,sys_user_id -- 
    ,sys_user -- 
    ,house_telephone -- 
    ,ghb_emply_flg -- 
    ,mrtl_status -- 
    ,telephone -- 
    ,occupation -- 
    ,cust_state -- 
    ,law_cust_name -- 
    ,law_tel -- 
    ,address -- 
    ,nation_code -- 
    ,corp_prop -- 
    ,industry_type -- 
    ,found_date -- 
    ,tel -- 
    ,reg_curr_type -- 
    ,reg_cptl -- 
    ,reg_addr -- 
    ,is_sh -- 
    ,nation -- 
    ,ft_opac_time -- 
    ,open_org_name -- 
    ,is_hx -- 
    ,is_gh -- 
    ,card_type -- 
    ,fist_phon -- 
    ,edu_level -- 
    ,asset_bal -- 
    ,unti_xz -- 
    ,hang_ye -- 
    ,activity -- 
    ,loyalty -- 
    ,contribute -- 
    ,level_risk -- 
    ,child_num -- 
    ,per_income -- 
    ,fim_income -- 
    ,is_per_loan -- 
    ,account_num -- 
    ,use_bank_server -- 
    ,card_level -- 
    ,lc_risk -- 
    ,jj_risk -- 
    ,bx_risk -- 
    ,zg_risk -- 
    ,clos_acct_dt -- 
    ,et_dt -- 
    ,political_outlook -- 
    ,education -- 
    ,english_name -- 
    ,corporate_name -- 
    ,industry -- 
    ,corporate_nature -- 
    ,duties -- 
    ,positional_titles -- 
    ,nationality -- 
    ,religion -- 
    ,pinyin -- 
    ,is_leader -- 
    ,kid_num -- 
    ,kid_age -- 
    ,community -- 
    ,branch_bank -- 
    ,pet_type -- 
    ,is_executive -- 
    ,type_of_operation -- 
    ,business_products -- 
    ,shop_location -- 
    ,other -- 
    ,highest_card_rating -- 
    ,is_pay_by_othre_cust -- 
    ,is_hx_staff -- 
    ,positional -- 
    ,is_shop -- 
    ,pyhsical_card -- 
    ,is_contiue_cust -- 
    ,family_addr -- 
    ,elec_mail_addr -- 
    ,resd_status_cd -- 
    ,estate_val_cd -- 
    ,nome_phone_num -- 
    ,gg_org_id -- 
    ,gg_org_name -- 
    ,resdnt_addr -- 
    ,rpr_site -- 
    ,posta_addr -- 
    ,party_status_type_cd -- 
    ,qual_invtor_cert_flg -- 
    ,qual_invtor_vlid_tenor -- 
    ,lc_risk_date -- 
    ,is_new_risk -- 
    ,high_risk_flag -- 
    ,is_lingui -- 
    ,risk_level -- 
    ,new_rating_invalid_dt -- 
    ,jj_risk_date -- 
    ,bx_risk_date -- 
    ,zg_risk_date -- 
    ,cert_exp_dt -- 
    ,gh_brch_org_id -- 
    ,gh_brch_org_name -- 
    ,gh_subbrch_org_id -- 
    ,gh_subbrch_org_name -- 
    ,gg_brch_org_id -- 
    ,gg_brch_org_name -- 
    ,gg_subbrch_org_id -- 
    ,gg_subbrch_org_name -- 
    ,new_citizen_flg -- 
    ,first_open_i_acct_dt -- 
    ,is_stop_no_counter_tran -- 
    ,cust_max_aum -- 
    ,cust_max_aum_date -- 
    ,cust_avgm_aum -- 
    ,cust_avgm_aum_date -- 
    ,is_register_mgm -- 
    ,sysbrch_id -- 
    ,sysbrch_name -- 
    ,syssubbrch_id -- 
    ,syssubbrch_name -- 
    ,if_bill -- 
    ,load_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_a_cm_cust
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_a_cm_cust exchange partition p_${batch_date} with table ${iol_schema}.bdws_a_cm_cust_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_a_cm_cust to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_a_cm_cust_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_a_cm_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);