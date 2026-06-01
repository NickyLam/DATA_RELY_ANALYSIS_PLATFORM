: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_guarantee_cont_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_guarantee_cont_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.guarcontractno,chr(13),''),chr(10),'') as guarcontractno
,replace(replace(t1.maincontracttype,chr(13),''),chr(10),'') as maincontracttype
,guaramt
,replace(replace(t1.ccycd,chr(13),''),chr(10),'') as ccycd
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.guarcustno,chr(13),''),chr(10),'') as guarcustno
,replace(replace(t1.guarcustname,chr(13),''),chr(10),'') as guarcustname
,replace(replace(t1.guarcusttype,chr(13),''),chr(10),'') as guarcusttype
,replace(replace(t1.guarcustidtype,chr(13),''),chr(10),'') as guarcustidtype
,replace(replace(t1.guarcustidno,chr(13),''),chr(10),'') as guarcustidno
,replace(replace(t1.guarcontracttype,chr(13),''),chr(10),'') as guarcontracttype
,replace(replace(t1.guartype,chr(13),''),chr(10),'') as guartype
,replace(replace(t1.guarstartdate,chr(13),''),chr(10),'') as guarstartdate
,replace(replace(t1.guarenddate,chr(13),''),chr(10),'') as guarenddate
,replace(replace(t1.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t1.guarcontractsts,chr(13),''),chr(10),'') as guarcontractsts
,replace(replace(t1.operator,chr(13),''),chr(10),'') as operator
,replace(replace(t1.guarantortype,chr(13),''),chr(10),'') as guarantortype
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid
,replace(replace(t1.isplatformguar,chr(13),''),chr(10),'') as isplatformguar

from ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_guarantee_cont_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
