: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_rela_ps_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_rela_ps_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sorc_sys_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_rela_type_cd,chr(13),''),chr(10),'')
,rela_ps_join_work_tm
,replace(replace(rela_ps_corp_phone,chr(13),''),chr(10),'')
,replace(replace(rela_ps_tel_num,chr(13),''),chr(10),'')
,replace(replace(rela_ps_corp_name,chr(13),''),chr(10),'')
,replace(replace(rela_ps_name,chr(13),''),chr(10),'')
,replace(replace(rela_ps_mobile_no,chr(13),''),chr(10),'')
,replace(replace(rela_ps_gender_cd,chr(13),''),chr(10),'')
,rela_ps_mon_inco
,replace(replace(rela_ps_cert_no,chr(13),''),chr(10),'')
,replace(replace(rela_ps_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_title_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_post_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_career_cd,chr(13),''),chr(10),'')
,replace(replace(cty_rg_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_zip_cd,chr(13),''),chr(10),'')
,replace(replace(seq_num,chr(13),''),chr(10),'')
,replace(replace(spouse_is_have_work,chr(13),''),chr(10),'')
,replace(replace(rela_ps_phys_addr,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_rela_ps_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_rela_ps_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
