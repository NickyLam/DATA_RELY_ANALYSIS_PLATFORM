: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_tzbl_jbxx_a
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_tzbl_jbxx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
,replace(replace(t1.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
,replace(replace(t1.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
,replace(replace(t1.farmer_flg,chr(13),''),chr(10),'') as farmer_flg
,replace(replace(t1.indv_indu_com_acct_flg,chr(13),''),chr(10),'') as indv_indu_com_acct_flg
,replace(replace(t1.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
,age
,replace(replace(t1.valid_gender_cd,chr(13),''),chr(10),'') as valid_gender_cd
,replace(replace(t1.native_place_cd,chr(13),''),chr(10),'') as native_place_cd
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.poli_face_cd,chr(13),''),chr(10),'') as poli_face_cd
,replace(replace(t1.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
,replace(replace(t1.highest_edu_degree_cd,chr(13),''),chr(10),'') as highest_edu_degree_cd
,replace(replace(t1.reside_status_cd,chr(13),''),chr(10),'') as reside_status_cd
,join_work_year
,join_enterprise_year
,replace(replace(t1.corp_blng_indu_cd,chr(13),''),chr(10),'') as corp_blng_indu_cd
,replace(replace(t1.corp_prop_cd,chr(13),''),chr(10),'') as corp_prop_cd
,replace(replace(t1.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
,replace(replace(t1.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
,replace(replace(t1.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
,raise_cnt
,family_anl_inc
,family_mon_income
,indv_mon_income
,indv_year_income
,replace(replace(t1.blkl_pty_flg,chr(13),''),chr(10),'') as blkl_pty_flg
,replace(replace(t1.crdt_pty_flg,chr(13),''),chr(10),'') as crdt_pty_flg
,replace(replace(t1.small_eown_flg,chr(13),''),chr(10),'') as small_eown_flg
,replace(replace(t1.pty_level_cd,chr(13),''),chr(10),'') as pty_level_cd
,replace(replace(t1.insd_and_otsd_flg,chr(13),''),chr(10),'') as insd_and_otsd_flg
,replace(replace(t1.work_stus,chr(13),''),chr(10),'') as work_stus
,house_value
,replace(replace(t1.exc_id,chr(13),''),chr(10),'') as exc_id
,generated_time
,replace(replace(t1.partition_month,chr(13),''),chr(10),'') as partition_month
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no

from ${iol_schema}.rsts_rcd_ir_tzbl_jbxx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_tzbl_jbxx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
