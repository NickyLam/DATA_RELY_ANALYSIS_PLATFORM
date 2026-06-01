: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_myloan_crdt_appl_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_myloan_crdt_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(appl_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(crdt_appl_id,chr(13),''),chr(10),'')
,replace(replace(appl_flow_num,chr(13),''),chr(10),'')
,replace(replace(prod_id,chr(13),''),chr(10),'')
,appl_dt
,replace(replace(cust_name,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,crdt_lmt
,apv_start_tm
,apv_end_tm
,replace(replace(apv_status_cd,chr(13),''),chr(10),'')
,replace(replace(final_jud_advise_sucs_flg,chr(13),''),chr(10),'')
,final_jud_advise_tm
,replace(replace(cust_mgr_id,chr(13),''),chr(10),'')
,replace(replace(rgst_org_id,chr(13),''),chr(10),'')
,replace(replace(farm_flg,chr(13),''),chr(10),'')
,replace(replace(refuse_rs,chr(13),''),chr(10),'')
,replace(replace(mobile_no,chr(13),''),chr(10),'')
,crdt_sugst_lmt
,replace(replace(netw_vrfction_status_cd,chr(13),''),chr(10),'')
,replace(replace(prod_name,chr(13),''),chr(10),'')
,replace(replace(apv_rest_cd,chr(13),''),chr(10),'')
,replace(replace(bus_scene_cd,chr(13),''),chr(10),'')
,replace(replace(lmt_status_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,replace(replace(bank_supv_custs_mang_lab,chr(13),''),chr(10),'')
,replace(replace(pbc_custs_mang_lab,chr(13),''),chr(10),'')

from ${iml_schema}.agt_myloan_crdt_appl t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_crdt_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
