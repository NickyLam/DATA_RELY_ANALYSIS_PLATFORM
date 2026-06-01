: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_rela_ps_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_rela_ps_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.sorc_sys_cd as sorc_sys_cd
,t1.rela_ps_rela_type_cd as rela_ps_rela_type_cd
,t1.rela_ps_join_work_tm as rela_ps_join_work_tm
,t1.rela_ps_corp_phone as rela_ps_corp_phone
,t1.rela_ps_tel_num as rela_ps_tel_num
,t1.rela_ps_corp_name as rela_ps_corp_name
,t1.rela_ps_name as rela_ps_name
,t1.rela_ps_mobile_no as rela_ps_mobile_no
,t1.rela_ps_gender_cd as rela_ps_gender_cd
,t1.rela_ps_mon_inco as rela_ps_mon_inco
,t1.rela_ps_cert_no as rela_ps_cert_no
,t1.rela_ps_cert_type_cd as rela_ps_cert_type_cd
,t1.rela_ps_title_cd as rela_ps_title_cd
,t1.rela_ps_post_cd as rela_ps_post_cd
,t1.rela_ps_career_cd as rela_ps_career_cd
,t1.cty_rg_cd as cty_rg_cd
,t1.rela_ps_zip_cd as rela_ps_zip_cd
,t1.seq_num as seq_num
,t1.spouse_is_have_work as spouse_is_have_work
,t1.rela_ps_phys_addr as rela_ps_phys_addr
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_rela_ps_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_rela_ps_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
