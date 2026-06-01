: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_fin_stat_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_fin_stat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(rec_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(rept_curr_cd,chr(13),''),chr(10),'')
,replace(replace(rept_corp_cd,chr(13),''),chr(10),'')
,replace(replace(rept_cali_type_cd,chr(13),''),chr(10),'')
,rept_dt
,replace(replace(rept_ped_cd,chr(13),''),chr(10),'')
,replace(replace(rept_note,chr(13),''),chr(10),'')
,replace(replace(rept_status_cd,chr(13),''),chr(10),'')
,replace(replace(rgst_org_id,chr(13),''),chr(10),'')
,rgst_dt
,replace(replace(rgst_user_id,chr(13),''),chr(10),'')
,replace(replace(audit_flg,chr(13),''),chr(10),'')
,replace(replace(audit_corp,chr(13),''),chr(10),'')
,replace(replace(audit_opinion,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_fin_stat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_fin_stat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
