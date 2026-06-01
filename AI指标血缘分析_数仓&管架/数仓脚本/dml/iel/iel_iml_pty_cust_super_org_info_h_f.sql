: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_super_org_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_super_org_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,rgst_dt
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.comer_rgst_and_non_comer_rgst_cert_num,chr(13),''),chr(10),'') as comer_rgst_and_non_comer_rgst_cert_num
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.org_crdt_id,chr(13),''),chr(10),'') as org_crdt_id
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg

from ${iml_schema}.pty_cust_super_org_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_super_org_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
