: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a08tcityinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a08tcityinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.citycd,chr(13),''),chr(10),'') as citycd
,replace(replace(t1.citynm,chr(13),''),chr(10),'') as citynm
,replace(replace(t1.citytp,chr(13),''),chr(10),'') as citytp
,replace(replace(t1.cityndcd,chr(13),''),chr(10),'') as cityndcd
,replace(replace(t1.chngnb,chr(13),''),chr(10),'') as chngnb
 from iol.mpcs_a08tcityinfo T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a08tcityinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes