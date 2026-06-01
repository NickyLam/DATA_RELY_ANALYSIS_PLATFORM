: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_org_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_org_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
     replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.sortno,chr(13),''),chr(10),'') as sortno
    ,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
    ,replace(replace(t.orglevel,chr(13),''),chr(10),'') as orglevel
    ,replace(replace(t.orgproperty,chr(13),''),chr(10),'') as orgproperty
    ,replace(replace(t.relativeorgid,chr(13),''),chr(10),'') as relativeorgid
    ,replace(replace(t.bankid,chr(13),''),chr(10),'') as bankid
    ,replace(replace(t.banklicense,chr(13),''),chr(10),'') as banklicense
    ,replace(replace(t.businesslicense,chr(13),''),chr(10),'') as businesslicense
    ,replace(replace(t.belongarea,chr(13),''),chr(10),'') as belongarea
    ,replace(replace(t.orgclass,chr(13),''),chr(10),'') as orgclass
    ,replace(replace(t.zipcode,chr(13),''),chr(10),'') as zipcode
    ,replace(replace(t.mainframeorgid,chr(13),''),chr(10),'') as mainframeorgid
    ,replace(replace(t.mainframeexgid,chr(13),''),chr(10),'') as mainframeexgid
    ,replace(replace(t.orgcode,chr(13),''),chr(10),'') as orgcode
    ,replace(replace(t.status,chr(13),''),chr(10),'') as status
    ,replace(replace(t.orgoldname,chr(13),''),chr(10),'') as orgoldname
    ,replace(replace(t.setupdate,chr(13),''),chr(10),'') as setupdate
    ,replace(replace(t.orgadd,chr(13),''),chr(10),'') as orgadd
    ,replace(replace(t.principal,chr(13),''),chr(10),'') as principal
    ,replace(replace(t.orgtel,chr(13),''),chr(10),'') as orgtel
    ,t.branchnum as branchnum
    ,t.cmnum as cmnum
    ,replace(replace(t.businesshours,chr(13),''),chr(10),'') as businesshours
    ,replace(replace(t.inputorg,chr(13),''),chr(10),'') as inputorg
    ,replace(replace(t.inputuser,chr(13),''),chr(10),'') as inputuser
    ,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
    ,replace(replace(t.inputtime,chr(13),''),chr(10),'') as inputtime
    ,replace(replace(t.updateuser,chr(13),''),chr(10),'') as updateuser
    ,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
    ,replace(replace(t.updatedate,chr(13),''),chr(10),'') as updatedate
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.belongorgid,chr(13),''),chr(10),'') as belongorgid
    ,replace(replace(t.hostno,chr(13),''),chr(10),'') as hostno
    ,t.vitualserialno as vitualserialno
    ,replace(replace(t.vitualid,chr(13),''),chr(10),'') as vitualid
    ,replace(replace(t.stampperson,chr(13),''),chr(10),'') as stampperson
    ,replace(replace(t.trytypeno,chr(13),''),chr(10),'') as trytypeno
    ,replace(replace(t.oaorganid,chr(13),''),chr(10),'') as oaorganid
    ,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_org_info t
where t.start_dt<=to_date('${batch_date}','yyyymmdd') and t.end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_org_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes