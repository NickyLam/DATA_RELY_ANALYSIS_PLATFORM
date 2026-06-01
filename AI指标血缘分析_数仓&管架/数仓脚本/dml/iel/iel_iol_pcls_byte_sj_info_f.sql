: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_byte_sj_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_byte_sj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.reject_reason_big,chr(13),''),chr(10),'') as reject_reason_big
,replace(replace(t1.sx_reject_reason_tag,chr(13),''),chr(10),'') as sx_reject_reason_tag
,replace(replace(t1.reject_reason_small,chr(13),''),chr(10),'') as reject_reason_small
,t_1_cnt
,t_2_cnt
,t_3_cnt
,t_4_cnt
,t_5_cnt
,t_6_cnt
,t_7_cnt

from ${iol_schema}.pcls_byte_sj_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_byte_sj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
