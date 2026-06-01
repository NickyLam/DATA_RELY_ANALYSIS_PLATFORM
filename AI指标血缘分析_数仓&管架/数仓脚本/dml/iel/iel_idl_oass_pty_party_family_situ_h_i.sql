: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_family_situ_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_party_family_situ_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.loc_resd_years as loc_resd_years
,t1.local_estate_flg as local_estate_flg
,t1.local_soci_secu_flg as local_soci_secu_flg
,t1.house_val_cd as house_val_cd
,t1.prov_pulation_type_cd as prov_pulation_type_cd
,t1.rpr_char_cd as rpr_char_cd
,t1.resdnt_status_cd as resdnt_status_cd
,t1.child_number_cd as child_number_cd
,t1.free_car_situ_cd as free_car_situ_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_family_situ_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_family_situ_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
