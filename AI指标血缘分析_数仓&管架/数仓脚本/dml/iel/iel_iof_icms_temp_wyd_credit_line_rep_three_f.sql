: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_credit_line_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_credit_line_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.limitno,chr(13),''),chr(10),'') as limitno
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.custidtype,chr(13),''),chr(10),'') as custidtype
,replace(replace(t1.custidno,chr(13),''),chr(10),'') as custidno
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.circulflag,chr(13),''),chr(10),'') as circulflag
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,creditline
,replace(replace(t1.credittype,chr(13),''),chr(10),'') as credittype
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t1.initdate,chr(13),''),chr(10),'') as initdate
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.freezeflag,chr(13),''),chr(10),'') as freezeflag
,replace(replace(t1.adjustdate,chr(13),''),chr(10),'') as adjustdate
,replace(replace(t1.extenddate,chr(13),''),chr(10),'') as extenddate
,availablecredit

from ${iol_schema}.icms_temp_wyd_credit_line_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_credit_line_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
