: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_guar_cont_guar_rela_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_guar_cont_guar_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.obj_type_name as obj_type_name
,t1.obj_id as obj_id
,t1.guar_id as guar_id
,t1.guar_cont_id as guar_cont_id
,t1.rela_status_cd as rela_status_cd
,t1.rgst_org_id as rgst_org_id
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_dt as rgst_dt
,t1.update_org_id as update_org_id
,t1.update_teller_id as update_teller_id
,t1.modif_dt as modif_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_guar_cont_guar_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_guar_cont_guar_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
