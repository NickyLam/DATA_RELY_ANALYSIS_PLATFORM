: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_specialtradeinfo_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_specialtradeinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.sptxn_tp,chr(13),''),chr(10),'') as sptxn_tp
    ,t.hpn_dt as hpn_dt
    ,t.exdat_mdf_monum as exdat_mdf_monum
    ,t.cr_ln_sptxn_hpn_amt as cr_ln_sptxn_hpn_amt
    ,replace(replace(t.pbccrlnsptxn_dtl_rcrd,chr(13),''),chr(10),'') as pbccrlnsptxn_dtl_rcrd
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_specialtradeinfo t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_specialtradeinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes