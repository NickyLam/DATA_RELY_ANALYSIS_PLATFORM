: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_rgstcptlandmfndpsninf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_rgstcptlandmfndpsninf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.pbc_cr_fndd_psn_tp,chr(13),''),chr(10),'') as pbc_cr_fndd_psn_tp
    ,replace(replace(t.fndd_psn_part_cgy,chr(13),''),chr(10),'') as fndd_psn_part_cgy
    ,replace(replace(t.fndd_psn_nm,chr(13),''),chr(10),'') as fndd_psn_nm
    ,replace(replace(t.fndd_psn_part_idr_tp,chr(13),''),chr(10),'') as fndd_psn_part_idr_tp
    ,replace(replace(t.fndd_psn_part_idr_no,chr(13),''),chr(10),'') as fndd_psn_part_idr_no
    ,t.entp_cr_fndd_pctg as entp_cr_fndd_pctg
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_rgstcptlandmfndpsninf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_rgstcptlandmfndpsninf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes