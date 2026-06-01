: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_dbtcraccspcltxninf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_dbtcraccspcltxninf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.sptxn_tp,chr(13),''),chr(10),'') as sptxn_tp
    ,t.txn_dt as txn_dt
    ,t.cr_ln_sptxn_hpn_amt as cr_ln_sptxn_hpn_amt
    ,t.exdat_mdf_monum as exdat_mdf_monum
    ,replace(replace(t.tndtl_inf,chr(13),''),chr(10),'') as tndtl_inf
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_dbtcraccspcltxninf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_dbtcraccspcltxninf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes