: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_khftpcl_a
CreateDate: 20250605
FileName:   ${iel_data_path}/pams_jxbb_khftpcl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tjrq
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.lx,chr(13),''),chr(10),'') as lx
,jgkhdxdh
,replace(replace(t1.khkhjg,chr(13),''),chr(10),'') as khkhjg
,replace(replace(t1.khssjg,chr(13),''),chr(10),'') as khssjg
,dyjsrhj
,ljjsrhj
,ckqmye
,ckdyrj
,ckljrj
,dycklxzc
,dyftpzysr
,dyckftpyyjsr
,ljcklxzc
,ljftpzysr
,ljckftpyyjsr
,dkqmye
,dkdyrj
,dkljrj
,dydklxsr
,dydkftpzycb
,dydkftpyyjsr
,ljdklxsr
,ljdkftpzycb
,ljdkftpyyjsr
,zjywsr
,lxdqmye
,lxddyrj
,lxdljrj
,lxddylxsr
,lxddyftpzycb
,lxddyftpjsr
,lxdljlxsr
,lxdljftpzycb
,lxdljftpjsr
,ztxqmye
,ztxdyrj
,ztxljrj
,ztxdylxzc
,ztxdyftpzysr
,ztxdyftpjsr
,ztxljlxzc
,ztxljftpzysr
,ztxljftpyyjsr
,ssjgkhdxdh

from ${iol_schema}.pams_jxbb_khftpcl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_khftpcl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
