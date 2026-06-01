: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cust_save_mobile_no_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_cust_save_mobile_no.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.save_mobile_no,chr(13),''),chr(10),'') as save_mobile_no
,replace(replace(t1.save_mobile_no_status_cd,chr(13),''),chr(10),'') as save_mobile_no_status_cd
,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'') as user_seq_num

from ${iml_schema}.pty_cust_save_mobile_no t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cust_save_mobile_no.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
