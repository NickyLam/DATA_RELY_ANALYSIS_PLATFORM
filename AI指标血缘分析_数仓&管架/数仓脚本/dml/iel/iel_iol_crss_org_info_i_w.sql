: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_org_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_org_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select orgid,sortno,orgname,orglevel,orgproperty,relativeorgid,bankid,banklicense,businesslicense,belongarea,orgclass,zipcode,mainframeorgid,mainframeexgid,orgcode,status,orgoldname,setupdate,orgadd,principal,orgtel,branchnum,cmnum,businesshours,inputorg,inputuser,inputdate,inputtime,updateuser,updatetime,updatedate,remark,belongorgid,hostno,vitualserialno,vitualid,stampperson,trytypeno,oaorganid,isinuse
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.crss_org_info where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_org_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes