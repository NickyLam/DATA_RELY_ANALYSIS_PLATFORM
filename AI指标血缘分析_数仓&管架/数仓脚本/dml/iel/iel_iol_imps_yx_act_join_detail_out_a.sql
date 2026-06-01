: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_imps_yx_act_join_detail_out_a
CreateDate: 20250609
FileName:   ${iel_data_path}/imps_yx_act_join_detail_out.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,p_date
,replace(replace(t1.hostcustno,chr(13),''),chr(10),'') as hostcustno
,replace(replace(t1.actid,chr(13),''),chr(10),'') as actid
,replace(replace(t1.actname,chr(13),''),chr(10),'') as actname
,replace(replace(t1.tooltypename,chr(13),''),chr(10),'') as tooltypename
,replace(replace(t1.jointime,chr(13),''),chr(10),'') as jointime
,replace(replace(t1.score,chr(13),''),chr(10),'') as score
,replace(replace(t1.gametime,chr(13),''),chr(10),'') as gametime
,replace(replace(t1.whethersuccess,chr(13),''),chr(10),'') as whethersuccess
,replace(replace(t1.winning,chr(13),''),chr(10),'') as winning
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno
,replace(replace(t1.prizename,chr(13),''),chr(10),'') as prizename
,replace(replace(t1.receiveinvalidtime,chr(13),''),chr(10),'') as receiveinvalidtime
,replace(replace(t1.orderstatus,chr(13),''),chr(10),'') as orderstatus
,replace(replace(t1.cardcouponsexpirationdate,chr(13),''),chr(10),'') as cardcouponsexpirationdate
,replace(replace(t1.cardcouponswriteoffdate,chr(13),''),chr(10),'') as cardcouponswriteoffdate
,replace(replace(t1.pricemoney,chr(13),''),chr(10),'') as pricemoney
,replace(replace(t1.signreward,chr(13),''),chr(10),'') as signreward
,replace(replace(t1.guessstate,chr(13),''),chr(10),'') as guessstate
,replace(replace(t1.guesswinpoints,chr(13),''),chr(10),'') as guesswinpoints
,replace(replace(t1.inviteeshostcustno,chr(13),''),chr(10),'') as inviteeshostcustno
,replace(replace(t1.invitationstatus,chr(13),''),chr(10),'') as invitationstatus
,replace(replace(t1.votingworkname,chr(13),''),chr(10),'') as votingworkname
,replace(replace(t1.receivedvotes,chr(13),''),chr(10),'') as receivedvotes
,replace(replace(t1.lootjoinnumber,chr(13),''),chr(10),'') as lootjoinnumber
,replace(replace(t1.consumptiontotalpoints,chr(13),''),chr(10),'') as consumptiontotalpoints
,replace(replace(t1.donattotalcount,chr(13),''),chr(10),'') as donattotalcount
,replace(replace(t1.totalguesscount,chr(13),''),chr(10),'') as totalguesscount
,replace(replace(t1.guesssuccesscount,chr(13),''),chr(10),'') as guesssuccesscount
,replace(replace(t1.totalguesssuccesspoints,chr(13),''),chr(10),'') as totalguesssuccesspoints
,replace(replace(t1.datatime,chr(13),''),chr(10),'') as datatime
,replace(replace(t1.returntime,chr(13),''),chr(10),'') as returntime
,baseid
,row_id

from ${iol_schema}.imps_yx_act_join_detail_out t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/imps_yx_act_join_detail_out.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
