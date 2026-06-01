: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_actctrlrinf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_actctrlrinf.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.act_ctrlr_idnt_cgy,chr(13),''),chr(10),'') as act_ctrlr_idnt_cgy
    ,replace(replace(t.act_ctrlr_nm,chr(13),''),chr(10),'') as act_ctrlr_nm
    ,replace(replace(t.act_ctrlr_idnt_idr_tp,chr(13),''),chr(10),'') as act_ctrlr_idnt_idr_tp
    ,replace(replace(t.act_ctrlr_idnt_idr_no,chr(13),''),chr(10),'') as act_ctrlr_idnt_idr_no
    ,replace(replace(t.crdt_no,chr(13),''),chr(10),'') as crdt_no
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_actctrlrinf t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_actctrlrinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes