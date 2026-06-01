: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_khjhgl_mx_f
CreateDate: 20260114
FileName:   ${iel_data_path}/pams_khfa_khjhgl_mx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,mxfabh
,fabh
,khnf
,replace(replace(t1.jhmc,chr(13),''),chr(10),'') as jhmc
,replace(replace(t1.khdx,chr(13),''),chr(10),'') as khdx
,lrry
,lrsj
,jgkhdxdh
,hykhdxdh
,replace(replace(t1.khzbdh,chr(13),''),chr(10),'') as khzbdh
,replace(replace(t1.dw,chr(13),''),chr(10),'') as dw
,dbjs
,ndmbzone
,ndmbztwo
,ndmbzthree
,zlddzone
,zlddztwo
,zlddzthree
,janone
,jantwo
,janthree
,febone
,febtwo
,febthree
,marone
,martwo
,marthree
,aprone
,aprtwo
,aprthree
,mayone
,maytwo
,maythree
,junone
,juntwo
,junthree
,julone
,jultwo
,julthree
,augone
,augtwo
,augthree
,septone
,septtwo
,septthree
,octone
,octtwo
,octthree
,novone
,novtwo
,novthree
,decone
,dectwo
,decthree

from ${iol_schema}.pams_khfa_khjhgl_mx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_khjhgl_mx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
