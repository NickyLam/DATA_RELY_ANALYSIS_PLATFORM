: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_labelandstatement_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_labelandstatement.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.inf_unit_tp,chr(13),''),chr(10),'') as inf_unit_tp
    ,replace(replace(t.annttn_and_sttmnt_tp,chr(13),''),chr(10),'') as annttn_and_sttmnt_tp
    ,replace(replace(t.annttnor_sttmnt_cntnt,chr(13),''),chr(10),'') as annttnor_sttmnt_cntnt
    ,t.add_dt as add_dt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_labelandstatement t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_labelandstatement.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes