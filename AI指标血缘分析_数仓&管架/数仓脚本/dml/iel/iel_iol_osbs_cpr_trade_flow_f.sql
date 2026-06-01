: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_cpr_trade_flow_f
CreateDate: 20240403
FileName:   ${iel_data_path}/osbs_cpr_trade_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ctf_trade_flowno,chr(13),''),chr(10),'') as ctf_trade_flowno
,replace(replace(t1.ctf_transtime,chr(13),''),chr(10),'') as ctf_transtime
,replace(replace(t1.ctf_transdate,chr(13),''),chr(10),'') as ctf_transdate
,replace(replace(t1.ctf_transcode,chr(13),''),chr(10),'') as ctf_transcode
,replace(replace(t1.ctf_action,chr(13),''),chr(10),'') as ctf_action
,replace(replace(t1.ctf_ecifno,chr(13),''),chr(10),'') as ctf_ecifno
,replace(replace(t1.ctf_userno,chr(13),''),chr(10),'') as ctf_userno
,replace(replace(t1.ctf_channel,chr(13),''),chr(10),'') as ctf_channel
,replace(replace(t1.ctf_ecifname,chr(13),''),chr(10),'') as ctf_ecifname
,replace(replace(t1.ctf_menuid,chr(13),''),chr(10),'') as ctf_menuid
,replace(replace(t1.ctf_state,chr(13),''),chr(10),'') as ctf_state
,replace(replace(t1.ctf_returncode,chr(13),''),chr(10),'') as ctf_returncode
,replace(replace(t1.ctf_returnmsg,chr(13),''),chr(10),'') as ctf_returnmsg
,replace(replace(t1.ctf_accno,chr(13),''),chr(10),'') as ctf_accno
,ctf_amonut
,replace(replace(t1.ctf_currency,chr(13),''),chr(10),'') as ctf_currency
,replace(replace(t1.ctf_sendflowno,chr(13),''),chr(10),'') as ctf_sendflowno
,replace(replace(t1.ctf_src_sendflowno,chr(13),''),chr(10),'') as ctf_src_sendflowno
,replace(replace(t1.ctf_hostflowno,chr(13),''),chr(10),'') as ctf_hostflowno
,ctf_fee
,replace(replace(t1.ctf_parentlogno,chr(13),''),chr(10),'') as ctf_parentlogno
,replace(replace(t1.ctf_rootlogno,chr(13),''),chr(10),'') as ctf_rootlogno
,replace(replace(t1.ctf_authrefusecause,chr(13),''),chr(10),'') as ctf_authrefusecause
,replace(replace(t1.ctf_accessflowno,chr(13),''),chr(10),'') as ctf_accessflowno
,replace(replace(t1.ctf_host_returntime,chr(13),''),chr(10),'') as ctf_host_returntime
,replace(replace(t1.ctf_svrtranscode,chr(13),''),chr(10),'') as ctf_svrtranscode
,replace(replace(t1.ctf_customerip,chr(13),''),chr(10),'') as ctf_customerip
,replace(replace(t1.ctf_hostname,chr(13),''),chr(10),'') as ctf_hostname
,replace(replace(t1.ctf_src_serverip,chr(13),''),chr(10),'') as ctf_src_serverip
,replace(replace(t1.ctf_clientmac,chr(13),''),chr(10),'') as ctf_clientmac
,replace(replace(t1.ctf_clientos,chr(13),''),chr(10),'') as ctf_clientos
,replace(replace(t1.ctf_clientbrowser,chr(13),''),chr(10),'') as ctf_clientbrowser
,replace(replace(t1.ctf_clientnunittype,chr(13),''),chr(10),'') as ctf_clientnunittype
,replace(replace(t1.ctf_clientterminateno,chr(13),''),chr(10),'') as ctf_clientterminateno
,replace(replace(t1.ctf_sessionid,chr(13),''),chr(10),'') as ctf_sessionid
,replace(replace(t1.ctf_relflowno,chr(13),''),chr(10),'') as ctf_relflowno
,replace(replace(t1.ctf_securitytype,chr(13),''),chr(10),'') as ctf_securitytype
,replace(replace(t1.ctf_authstate,chr(13),''),chr(10),'') as ctf_authstate
,replace(replace(t1.ctf_delegateflag,chr(13),''),chr(10),'') as ctf_delegateflag
,replace(replace(t1.ctf_authstep,chr(13),''),chr(10),'') as ctf_authstep
,replace(replace(t1.ctf_senddate,chr(13),''),chr(10),'') as ctf_senddate
,replace(replace(t1.ctf_sendtime,chr(13),''),chr(10),'') as ctf_sendtime
,ctf_totalcount
,replace(replace(t1.ctf_remark,chr(13),''),chr(10),'') as ctf_remark
,replace(replace(t1.ctf_authflag,chr(13),''),chr(10),'') as ctf_authflag
,replace(replace(t1.ctf_authtype,chr(13),''),chr(10),'') as ctf_authtype
,replace(replace(t1.ctf_applogintype,chr(13),''),chr(10),'') as ctf_applogintype
,replace(replace(t1.ctf_biz_flow_no,chr(13),''),chr(10),'') as ctf_biz_flow_no
,replace(replace(t1.ctf_chain_track_no,chr(13),''),chr(10),'') as ctf_chain_track_no
,replace(replace(t1.ctf_send_flow_no,chr(13),''),chr(10),'') as ctf_send_flow_no
,replace(replace(t1.ctf_faceno,chr(13),''),chr(10),'') as ctf_faceno
,replace(replace(t1.ctf_imei,chr(13),''),chr(10),'') as ctf_imei
,replace(replace(t1.ctf_udid,chr(13),''),chr(10),'') as ctf_udid
,replace(replace(t1.ctf_sim,chr(13),''),chr(10),'') as ctf_sim

from ${iol_schema}.osbs_cpr_trade_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_cpr_trade_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
