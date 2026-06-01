: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_i_r_latestmonthlyinfo_i
CreateDate: 20250210
FileName:   ${iel_data_path}/cqss_i_r_latestmonthlyinfo.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.mo,chr(13),''),chr(10),'') as mo
,replace(replace(t1.dbtcr_acc_st,chr(13),''),chr(10),'') as dbtcr_acc_st
,dbtcr_acba
,usd_lmt
,notisugsbigasinstmbal
,replace(replace(t1.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
,srpls_repy_prd
,setl_repydy
,tm_shldrepymt_amt
,tm_act_repy_amt
,rctlyocact_repydy_prd
,cur_odue_prd
,cur_odue_tamt
,odue31to60dynotretpnp
,odue61to90dynotretpnp
,odue91toohednotretpnp
,odueohedyabv_ntpa_bal
,od_ohedy_abv_ntpa_bal
,rctly6etrsmoavgus_lmt
,rctly6etrsmoavgod_bal
,max_us_lmt
,max_od_bal
,rpt_dt
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm

from ${iol_schema}.cqss_i_r_latestmonthlyinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_latestmonthlyinfo.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
