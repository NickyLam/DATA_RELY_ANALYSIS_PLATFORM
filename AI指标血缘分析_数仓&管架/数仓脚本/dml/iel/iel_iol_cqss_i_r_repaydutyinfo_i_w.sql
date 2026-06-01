: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_repaydutyinfo_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_repaydutyinfo_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t.idnt_inf_cgycd,chr(13),''),chr(10),'') as idnt_inf_cgycd
,replace(replace(t.rel_repy_rspl_tp,chr(13),''),chr(10),'') as rel_repy_rspl_tp
,t.acc_num as acc_num
,replace(replace(t.grnt_ctr_id,chr(13),''),chr(10),'') as grnt_ctr_id
,t.repy_rspl_qot as repy_rspl_qot
,t.tot_acba as tot_acba
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_repaydutyinfo t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_repaydutyinfo_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes