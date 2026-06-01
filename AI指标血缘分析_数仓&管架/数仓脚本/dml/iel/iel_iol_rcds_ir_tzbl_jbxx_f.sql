: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_jbxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_jbxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
    ,replace(replace(t.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
    ,replace(replace(t.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
    ,replace(replace(t.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
    ,replace(replace(t.farmer_flg,chr(13),''),chr(10),'') as farmer_flg
    ,replace(replace(t.indv_indu_com_acct_flg,chr(13),''),chr(10),'') as indv_indu_com_acct_flg
    ,replace(replace(t.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
    ,t.age as age
    ,replace(replace(t.valid_gender_cd,chr(13),''),chr(10),'') as valid_gender_cd
    ,replace(replace(t.native_place_cd,chr(13),''),chr(10),'') as native_place_cd
    ,replace(replace(t.nation_cd,chr(13),''),chr(10),'') as nation_cd
    ,replace(replace(t.poli_face_cd,chr(13),''),chr(10),'') as poli_face_cd
    ,replace(replace(t.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
    ,replace(replace(t.highest_edu_degree_cd,chr(13),''),chr(10),'') as highest_edu_degree_cd
    ,replace(replace(t.reside_status_cd,chr(13),''),chr(10),'') as reside_status_cd
    ,t.join_work_year as join_work_year
    ,t.join_enterprise_year as join_enterprise_year
    ,replace(replace(t.corp_blng_indu_cd,chr(13),''),chr(10),'') as corp_blng_indu_cd
    ,replace(replace(t.corp_prop_cd,chr(13),''),chr(10),'') as corp_prop_cd
    ,replace(replace(t.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
    ,replace(replace(t.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
    ,replace(replace(t.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
    ,t.raise_cnt as raise_cnt
    ,t.family_anl_inc as family_anl_inc
    ,t.family_mon_income as family_mon_income
    ,t.indv_mon_income as indv_mon_income
    ,t.indv_year_income as indv_year_income
    ,replace(replace(t.blkl_pty_flg,chr(13),''),chr(10),'') as blkl_pty_flg
    ,replace(replace(t.crdt_pty_flg,chr(13),''),chr(10),'') as crdt_pty_flg
    ,replace(replace(t.small_eown_flg,chr(13),''),chr(10),'') as small_eown_flg
    ,replace(replace(t.pty_level_cd,chr(13),''),chr(10),'') as pty_level_cd
    ,replace(replace(t.insd_and_otsd_flg,chr(13),''),chr(10),'') as insd_and_otsd_flg
    ,replace(replace(t.work_stus,chr(13),''),chr(10),'') as work_stus
    ,t.house_value as house_value
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_jbxx t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_jbxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes