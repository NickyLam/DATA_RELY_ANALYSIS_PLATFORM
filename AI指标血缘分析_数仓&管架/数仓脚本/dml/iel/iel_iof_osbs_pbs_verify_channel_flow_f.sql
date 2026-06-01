: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_osbs_pbs_verify_channel_flow_f
CreateDate: 20250416
FileName:   ${iel_data_path}/osbs_pbs_verify_channel_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pvc_transdate,chr(13),''),chr(10),'') as pvc_transdate
,replace(replace(t1.pvc_transtime,chr(13),''),chr(10),'') as pvc_transtime
,replace(replace(t1.pvc_branchname,chr(13),''),chr(10),'') as pvc_branchname
,replace(replace(t1.pvc_branchcode,chr(13),''),chr(10),'') as pvc_branchcode
,replace(replace(t1.pvc_sub_branchname,chr(13),''),chr(10),'') as pvc_sub_branchname
,replace(replace(t1.pvc_sub_branchcode,chr(13),''),chr(10),'') as pvc_sub_branchcode
,replace(replace(t1.pvc_ecifno,chr(13),''),chr(10),'') as pvc_ecifno
,replace(replace(t1.pvc_channel,chr(13),''),chr(10),'') as pvc_channel
,replace(replace(t1.pvc_scene,chr(13),''),chr(10),'') as pvc_scene
,replace(replace(t1.pvc_verify_channel,chr(13),''),chr(10),'') as pvc_verify_channel
,replace(replace(t1.pvc_bankno,chr(13),''),chr(10),'') as pvc_bankno
,replace(replace(t1.pvc_bankname,chr(13),''),chr(10),'') as pvc_bankname
,replace(replace(t1.pvc_cardno,chr(13),''),chr(10),'') as pvc_cardno
,replace(replace(t1.pvc_mobile,chr(13),''),chr(10),'') as pvc_mobile
,replace(replace(t1.pvc_result,chr(13),''),chr(10),'') as pvc_result
,replace(replace(t1.pvc_errorcode,chr(13),''),chr(10),'') as pvc_errorcode
,replace(replace(t1.pvc_errormsg,chr(13),''),chr(10),'') as pvc_errormsg
,replace(replace(t1.pvc_token,chr(13),''),chr(10),'') as pvc_token
,replace(replace(t1.pvc_ecifname,chr(13),''),chr(10),'') as pvc_ecifname
,replace(replace(t1.pvc_acctno,chr(13),''),chr(10),'') as pvc_acctno
,replace(replace(t1.pvc_acct_class,chr(13),''),chr(10),'') as pvc_acct_class
,replace(replace(t1.pvc_idno,chr(13),''),chr(10),'') as pvc_idno
,replace(replace(t1.pvc_idtype,chr(13),''),chr(10),'') as pvc_idtype
,replace(replace(t1.pvc_transflow,chr(13),''),chr(10),'') as pvc_transflow
,replace(replace(t1.pvc_extend1,chr(13),''),chr(10),'') as pvc_extend1
,replace(replace(t1.pvc_extend2,chr(13),''),chr(10),'') as pvc_extend2
,replace(replace(t1.pvc_extend3,chr(13),''),chr(10),'') as pvc_extend3

from ${iol_schema}.osbs_pbs_verify_channel_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_verify_channel_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
