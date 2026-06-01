: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_rela_ps_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_rela_ps_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd 
,replace(replace(t1.rela_ps_rela_type_cd,chr(13),''),chr(10),'') as rela_ps_rela_type_cd 
,t1.rela_ps_join_work_tm as rela_ps_join_work_tm 
,replace(replace(t1.rela_ps_corp_phone,chr(13),''),chr(10),'') as rela_ps_corp_phone 
,replace(replace(t1.rela_ps_tel_num,chr(13),''),chr(10),'') as rela_ps_tel_num 
,replace(replace(t1.rela_ps_corp_name,chr(13),''),chr(10),'') as rela_ps_corp_name 
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name 
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no 
,replace(replace(t1.rela_ps_gender_cd,chr(13),''),chr(10),'') as rela_ps_gender_cd 
,t1.rela_ps_mon_inco as rela_ps_mon_inco 
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no 
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd 
,replace(replace(t1.rela_ps_title_cd,chr(13),''),chr(10),'') as rela_ps_title_cd 
,replace(replace(t1.rela_ps_post_cd,chr(13),''),chr(10),'') as rela_ps_post_cd 
,replace(replace(t1.rela_ps_career_cd,chr(13),''),chr(10),'') as rela_ps_career_cd 
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd 
,replace(replace(t1.rela_ps_zip_cd,chr(13),''),chr(10),'') as rela_ps_zip_cd 
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num 
,replace(replace(t1.spouse_is_have_work,chr(13),''),chr(10),'') as spouse_is_have_work 
,replace(replace(t1.rela_ps_phys_addr,chr(13),''),chr(10),'') as rela_ps_phys_addr 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_rela_ps_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_rela_ps_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes