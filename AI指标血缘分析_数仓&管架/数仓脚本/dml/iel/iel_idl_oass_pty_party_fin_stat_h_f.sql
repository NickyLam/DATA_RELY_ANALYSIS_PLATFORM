: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_fin_stat_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_fin_stat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.rept_curr_cd as rept_curr_cd
,t1.rept_corp_cd as rept_corp_cd
,t1.rept_cali_type_cd as rept_cali_type_cd
,t1.rept_dt as rept_dt
,t1.rept_ped_cd as rept_ped_cd
,t1.rept_note as rept_note
,t1.rept_status_cd as rept_status_cd
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.rgst_user_id as rgst_user_id
,t1.audit_flg as audit_flg
,t1.audit_corp as audit_corp
,t1.audit_opinion as audit_opinion
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.rec_id as rec_id

from ${idl_schema}.oass_pty_party_fin_stat_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_fin_stat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
