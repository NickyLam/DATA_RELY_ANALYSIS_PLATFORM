: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_dbtcraccrepyprfmninf_i
CreateDate: 20250704
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccrepyprfmninf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,infrpt_dt
,bal
,bal_chg_dt
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,lv5cl_afm_dt
,rctlyocact_repydy_prd
,rctlyoc_act_repy_tamt
,replace(replace(t1.rctly_oc_repy_form,chr(13),''),chr(10),'') as rctly_oc_repy_form
,rctly_oc_aptrpy_dt
,rctly_oc_repy_tamt
,cur_odue_tamt
,cur_odue_pnp
,dbtcr_acc_odue_monum
,srpls_repy_monum
,crt_dt_tm

from ${iol_schema}.cqss_e_r_dbtcraccrepyprfmninf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccrepyprfmninf.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
