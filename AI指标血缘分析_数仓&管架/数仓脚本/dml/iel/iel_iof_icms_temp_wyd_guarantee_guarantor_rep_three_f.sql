: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_guarantee_guarantor_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_guarantee_guarantor_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.guarcontractno,chr(13),''),chr(10),'') as guarcontractno
,replace(replace(t1.guarantorcustid,chr(13),''),chr(10),'') as guarantorcustid
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.guarantortype,chr(13),''),chr(10),'') as guarantortype
,replace(replace(t1.guarantorname,chr(13),''),chr(10),'') as guarantorname
,replace(replace(t1.guarantoridtype,chr(13),''),chr(10),'') as guarantoridtype
,replace(replace(t1.guarantoridno,chr(13),''),chr(10),'') as guarantoridno
,guarantyvalue
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid

from ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_guarantee_guarantor_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
