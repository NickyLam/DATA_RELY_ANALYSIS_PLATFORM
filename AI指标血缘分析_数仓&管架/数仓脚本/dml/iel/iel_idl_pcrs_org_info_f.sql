: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pcrs_org_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/org_info_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
orgid
,sortno
,orgname
,orglevel
,orgproperty
,relativeorgid
,bankid
,banklicense
,businesslicense
,belongarea
,orgclass
,zipcode
,mainframeorgid
,mainframeexgid
,orgcode
,status
,orgoldname
,setupdate
,orgadd
,principal
,orgtel
,branchnum
,cmnum
,businesshours
,inputorg
,inputuser
,inputdate
,inputtime
,updateuser
,updatetime
,updatedate
,remark
,belongorgid
,hostno
,vitualserialno
,vitualid
,stampperson
,trytypeno
from idl.pcrs_org_info
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/org_info_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes