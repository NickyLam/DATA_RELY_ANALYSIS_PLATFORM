: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_indv_cust_attach_info_f
CreateDate: 20260409
FileName:   ${iel_data_path}/cmm_indv_cust_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.family_farm_flg,chr(13),''),chr(10),'') as family_farm_flg
,replace(replace(t1.mls_acct_flg,chr(13),''),chr(10),'') as mls_acct_flg
,replace(replace(t1.disb_ps_flg,chr(13),''),chr(10),'') as disb_ps_flg
,replace(replace(t1.sm_bus_owner_cert_type,chr(13),''),chr(10),'') as sm_bus_owner_cert_type
,replace(replace(t1.sm_bus_owner_cert_no,chr(13),''),chr(10),'') as sm_bus_owner_cert_no
,replace(replace(t1.indv_bus_cert_type,chr(13),''),chr(10),'') as indv_bus_cert_type
,replace(replace(t1.indv_bus_cert_no,chr(13),''),chr(10),'') as indv_bus_cert_no
,replace(replace(t1.mang_enty_bl_induty_type_cd,chr(13),''),chr(10),'') as mang_enty_bl_induty_type_cd
,replace(replace(t1.latest_update_teller_id,chr(13),''),chr(10),'') as latest_update_teller_id
,replace(replace(t1.latest_update_org_id,chr(13),''),chr(10),'') as latest_update_org_id
,replace(replace(t1.latest_update_chn_cd,chr(13),''),chr(10),'') as latest_update_chn_cd
,latest_update_tm
,replace(replace(t1.crdt_cust_flg_cd,chr(13),''),chr(10),'') as crdt_cust_flg_cd
,replace(replace(t1.move_num,chr(13),''),chr(10),'') as move_num
,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'') as work_tel_num
,replace(replace(t1.ex_servsm_flg,chr(13),''),chr(10),'') as ex_servsm_flg
,replace(replace(t1.no_buslics_prc_flg,chr(13),''),chr(10),'') as no_buslics_prc_flg
,replace(replace(t1.inco_curr,chr(13),''),chr(10),'') as inco_curr
,replace(replace(t1.cross_bor_cust_flg,chr(13),''),chr(10),'') as cross_bor_cust_flg
,replace(replace(t1.crdt_cust_type_cd,chr(13),''),chr(10),'') as crdt_cust_type_cd

from ${icl_schema}.cmm_indv_cust_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_indv_cust_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
