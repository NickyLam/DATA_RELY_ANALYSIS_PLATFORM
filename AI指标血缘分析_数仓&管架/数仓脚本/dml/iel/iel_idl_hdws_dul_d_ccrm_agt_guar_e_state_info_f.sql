: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_e_state_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_e_state_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
t1.coll_id as coll_id
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.e_state_typ_cd as e_state_typ_cd
,t1.bldg_stru_typ_cd as bldg_stru_typ_cd
,t1.fini_prd_house_flg as fini_prd_house_flg
,t1.dlvy_bldg_dt as dlvy_bldg_dt
,t1.arch_area as arch_area
,t1.e_state_cert_num as e_state_cert_num
,t1.land_ctf_num as land_ctf_num
,t1.land_rit_typ_cd as land_rit_typ_cd
,t1.land_use_area as land_use_area
,t1.land_trmi_usage_dt as land_trmi_usage_dt
,t1.rgn_encd as rgn_encd
,t1.rgn_name as rgn_name
,t1.floor_qty as floor_qty
,t1.data_src_cd as data_src_cd

from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_e_state_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_e_state_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
