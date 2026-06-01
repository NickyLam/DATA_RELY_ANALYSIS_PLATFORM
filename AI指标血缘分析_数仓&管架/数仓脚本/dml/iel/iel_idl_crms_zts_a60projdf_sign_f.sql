: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a60projdf_sign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a60projdf_sign_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
projno
,projtp
,acctno
,acctna
,offitl
,mailad
,glacno
,glacna
,bstype
,wdtype
,isnbnk
,compco
,feeamo
,dracno
,dracna
,coyhbl
,yhendt
,signdt
,cntrbr
,crtrus
,modidt
,mdtrbr
,mdtrus
,cntrst
,closdt
,closus
from ${idl_schema}.crms_zts_a60projdf_sign
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a60projdf_sign_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes