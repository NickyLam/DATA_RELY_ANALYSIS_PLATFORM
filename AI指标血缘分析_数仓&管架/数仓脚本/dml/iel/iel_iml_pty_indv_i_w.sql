: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_indv_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_indv_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.indv_en_name,chr(13),''),chr(10),'') as indv_en_name 
,t1.birth_dt as birth_dt 
,replace(replace(t1.birth_addr,chr(13),''),chr(10),'') as birth_addr 
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd 
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name 
,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg 
,replace(replace(t1.indv_bus_cert_no,chr(13),''),chr(10),'') as indv_bus_cert_no 
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd 
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd 
,replace(replace(t1.nati_place_cd,chr(13),''),chr(10),'') as nati_place_cd 
,replace(replace(t1.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd 
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd 
,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num 
,replace(replace(t1.real_name_flg,chr(13),''),chr(10),'') as real_name_flg 
,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd 
,replace(replace(t1.tax_resdnt_idti_type_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_type_cd 
,replace(replace(t1.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg 
,replace(replace(t1.sm_bus_owner_cert_no,chr(13),''),chr(10),'') as sm_bus_owner_cert_no 
,replace(replace(t1.sm_bus_owner_cert_type_cd,chr(13),''),chr(10),'') as sm_bus_owner_cert_type_cd 
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd 
,replace(replace(t1.name,chr(13),''),chr(10),'') as name 
,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd 
,replace(replace(t1.blood_type_cd,chr(13),''),chr(10),'') as blood_type_cd 
,replace(replace(t1.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg 
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg 
,replace(replace(t1.have_work_unit_flg,chr(13),''),chr(10),'') as have_work_unit_flg 
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd 
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd 
,replace(replace(t1.resdnt_char_cd,chr(13),''),chr(10),'') as resdnt_char_cd 
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd 
,replace(replace(t1.emply_flg,chr(13),''),chr(10),'') as emply_flg 
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd 
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg 
,replace(replace(t1.nati_place,chr(13),''),chr(10),'') as nati_place 
,t1.age as age 
,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd 
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd 
,replace(replace(t1.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg 
,replace(replace(t1.health_status_cd,chr(13),''),chr(10),'') as health_status_cd 
,replace(replace(t1.spoken,chr(13),''),chr(10),'') as spoken 
,replace(replace(t1.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg 
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd 
,replace(replace(t1.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg 
,replace(replace(t1.indv_party_type_cd,chr(13),''),chr(10),'') as indv_party_type_cd 
,replace(replace(t1.hxb_post_type_cd,chr(13),''),chr(10),'') as hxb_post_type_cd 
,replace(replace(t1.grad_school,chr(13),''),chr(10),'') as grad_school 
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg 
,replace(replace(t1.main_type_cd,chr(13),''),chr(10),'') as main_type_cd 
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_indv t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes