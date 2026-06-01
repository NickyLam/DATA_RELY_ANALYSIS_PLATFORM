: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_maincmpsstffinf_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_maincmpsstffinf.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.main_cmps_stff_nm,chr(13),''),chr(10),'') as main_cmps_stff_nm
    ,replace(replace(t.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
    ,replace(replace(t.maincmps_stff_crdt_no,chr(13),''),chr(10),'') as maincmps_stff_crdt_no
    ,replace(replace(t.main_cmps_stff_pstn,chr(13),''),chr(10),'') as main_cmps_stff_pstn
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_maincmpsstffinf t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_maincmpsstffinf.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes