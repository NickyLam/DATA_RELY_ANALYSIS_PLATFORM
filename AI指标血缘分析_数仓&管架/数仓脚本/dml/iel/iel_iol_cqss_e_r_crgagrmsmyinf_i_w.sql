: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_crgagrmsmyinf_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_crgagrmsmyinf_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.non_rcr_lmt_tot as non_rcr_lmt_tot
,t.useds_non_rcr_lmt_tot as useds_non_rcr_lmt_tot
,t.srplsavlsnonrvllmttot as srplsavlsnonrvllmttot
,t.rcr_lmt_tot as rcr_lmt_tot
,t.used_s_rcr_lmt_tot as used_s_rcr_lmt_tot
,t.srplsavls_rvl_lmt_tot as srplsavls_rvl_lmt_tot
,replace(replace(t.wthr_cntn_crg_qot,chr(13),''),chr(10),'') as wthr_cntn_crg_qot
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_crgagrmsmyinf t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_crgagrmsmyinf_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes