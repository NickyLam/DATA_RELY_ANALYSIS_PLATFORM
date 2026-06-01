: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cms_business_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cms_business_type_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
typeno
,sortno
,typename
,typesortno
,subtypecode
,infoset
,displaytemplet
,attribute1
,attribute2
,attribute3
,attribute4
,attribute5
,attribute6
,attribute7
,attribute8
,attribute9
,attribute10
,remark
,applydetailno
,approvedetailno
,contractdetailno
,inputuser
,inputorg
,inputtime
,updateuser
,updatetime
,attribute11
,attribute12
,attribute13
,attribute14
,attribute15
,attribute16
,attribute17
,attribute18
,attribute19
,attribute20
,attribute21
,attribute22
,attribute23
,attribute24
,attribute25
,isinuse
,cklstlist
,isloancontrol
,trytype
,rwaattribute
from idl.irrs_o_cms_business_type
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cms_business_type_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes