: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_latestinfo_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_latestinfo.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.dbtcr_acc_st,chr(13),''),chr(10),'') as dbtcr_acc_st
    ,t.cls_dt as cls_dt
    ,replace(replace(t.tfrout_mo,chr(13),''),chr(10),'') as tfrout_mo
    ,t.dbtcr_acba as dbtcr_acba
    ,t.rctly_oc_repydy_prd as rctly_oc_repydy_prd
    ,t.rctly_oc_repy_amt as rctly_oc_repy_amt
    ,replace(replace(t.pbc_lv5cl_cd,chr(13),''),chr(10),'') as pbc_lv5cl_cd
    ,replace(replace(t.cr_ln_repy_st,chr(13),''),chr(10),'') as cr_ln_repy_st
    ,t.rpt_dt as rpt_dt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_latestinfo t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_latestinfo.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes