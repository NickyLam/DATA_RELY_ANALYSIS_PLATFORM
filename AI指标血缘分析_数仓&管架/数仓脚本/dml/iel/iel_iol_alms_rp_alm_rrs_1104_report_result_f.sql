: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alms_rp_alm_rrs_1104_report_result_f
CreateDate: 20231107
FileName:   ${iel_data_path}/alms_rp_alm_rrs_1104_report_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.data_rpt_date,chr(13),''),chr(10),'') as data_rpt_date
,replace(replace(t1.data_rpt_no,chr(13),''),chr(10),'') as data_rpt_no
,replace(replace(t1.data_rpt_desc,chr(13),''),chr(10),'') as data_rpt_desc
,replace(replace(t1.data_line_no,chr(13),''),chr(10),'') as data_line_no
,replace(replace(t1.data_line_desc,chr(13),''),chr(10),'') as data_line_desc
,replace(replace(t1.data_val1,chr(13),''),chr(10),'') as data_val1
,replace(replace(t1.data_val2,chr(13),''),chr(10),'') as data_val2
,replace(replace(t1.data_val3,chr(13),''),chr(10),'') as data_val3
,replace(replace(t1.data_val4,chr(13),''),chr(10),'') as data_val4
,replace(replace(t1.data_val5,chr(13),''),chr(10),'') as data_val5
,replace(replace(t1.data_val6,chr(13),''),chr(10),'') as data_val6
,replace(replace(t1.data_val7,chr(13),''),chr(10),'') as data_val7
,replace(replace(t1.data_val8,chr(13),''),chr(10),'') as data_val8
,replace(replace(t1.data_val9,chr(13),''),chr(10),'') as data_val9
,replace(replace(t1.data_val10,chr(13),''),chr(10),'') as data_val10
,replace(replace(t1.data_val11,chr(13),''),chr(10),'') as data_val11
,replace(replace(t1.data_val12,chr(13),''),chr(10),'') as data_val12
,replace(replace(t1.data_val13,chr(13),''),chr(10),'') as data_val13
,replace(replace(t1.data_val14,chr(13),''),chr(10),'') as data_val14
,replace(replace(t1.data_val15,chr(13),''),chr(10),'') as data_val15
,replace(replace(t1.data_val16,chr(13),''),chr(10),'') as data_val16
,replace(replace(t1.data_val17,chr(13),''),chr(10),'') as data_val17
,replace(replace(t1.data_val18,chr(13),''),chr(10),'') as data_val18
,replace(replace(t1.data_val19,chr(13),''),chr(10),'') as data_val19
,replace(replace(t1.data_val20,chr(13),''),chr(10),'') as data_val20

from ${iol_schema}.alms_rp_alm_rrs_1104_report_result t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alms_rp_alm_rrs_1104_report_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
