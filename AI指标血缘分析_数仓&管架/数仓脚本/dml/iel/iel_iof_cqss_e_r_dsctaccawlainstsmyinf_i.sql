: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_dsctaccawlainstsmyinf_i
CreateDate: 20250313
FileName:   ${iel_data_path}/cqss_e_r_dsctaccawlainstsmyinf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t1.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t1.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t1.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,not_clsg_acc
,bal_tot
,odue_tamt_tot
,odue_pnp_tot
,alrdy_clsg_acc
,alrdyclsgaccdstamttot
,crt_dt_tm

from ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dsctaccawlainstsmyinf.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
