: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dsctaccawlainstsmyinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dsctaccawlainstsmyinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.mtit_ecd,chr(13),''),chr(10),'') as mtit_ecd
,replace(replace(t.repy_rspl_bnctg,chr(13),''),chr(10),'') as repy_rspl_bnctg
,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,t.not_clsg_acc as not_clsg_acc
,t.bal_tot as bal_tot
,t.odue_tamt_tot as odue_tamt_tot
,t.odue_pnp_tot as odue_pnp_tot
,t.alrdy_clsg_acc as alrdy_clsg_acc
,t.alrdyclsgaccdstamttot as alrdyclsgaccdstamttot
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_dsctaccawlainstsmyinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dsctaccawlainstsmyinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes