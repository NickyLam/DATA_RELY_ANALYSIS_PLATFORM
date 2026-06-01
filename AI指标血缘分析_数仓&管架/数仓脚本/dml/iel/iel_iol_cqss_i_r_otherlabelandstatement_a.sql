: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_otherlabelandstatement_a
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_otherlabelandstatement.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.obj_tp,chr(13),''),chr(10),'') as obj_tp
,replace(replace(t1.obj_idr,chr(13),''),chr(10),'') as obj_idr
,annttn_and_sttmnt_num
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm

from ${iol_schema}.cqss_i_r_otherlabelandstatement t1
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_otherlabelandstatement.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
