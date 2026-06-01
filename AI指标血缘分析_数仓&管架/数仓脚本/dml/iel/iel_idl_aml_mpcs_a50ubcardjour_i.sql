: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_mpcs_a50ubcardjour_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a50ubcardjour.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,acqinstid
,fwdinstid
,systrace
,transtime
,transcode
,transdate
,tlrnbr
,brnnbr
,trantype
,channels
,msgtype
,priacct
,procecode
,workcode
,transamt
,onlnbl
,avalbl
,cravbl
,trxfee
,localtime
,localdate
,exprdate
,settlmtdate
,mchnttype
,posentrymode
,servicecode
,trackdata2
,trackdata3
,retrivarefnum
,authridresp
,respcode
,acptermnlid
,accptrid
,accttrnameloc
,addtnlrespcd
,privatedate
,currcycode
,pindata
,reserve
,rcvinstid
,cupsreserve
,oldacqinstid
,oldfwdinstid
,oldsystrace
,oldtranstime
,inputdata
,outputdata
,outacctnbr
,inacctnbr
,atmctrace
,linkid
,headinfo
,status
,errcode
,errmsg
,tertype
,promty
,acqinstctrycd
,cardholdamt
,cardholdrate
,settlmtamt
,newfwdinstid
,channeltp
,cardseq
,inpbocelem
,outpbocelem
,atmcrust
,trncd
,foriegnbl
,acctype
,openbrch
,fee
,card_type
,card_trn_typ
,scene
,cross_flag
,fallback_fg
,petty_flag
,respcode_s
,memo_cd
,memo_det
,global_seq
,trn_seq
,old_trn_seq
,upp_status
,host_nbr
,host_date
,dly_trn_id
,dly_trn_dt
,dly_yl_stu
,dly_status
,cust_termid
,cust_ip
,client_sim
,client_gps
,mobile
,cust_no
,cust_name
,trn_time
,back_acct_date
,oldtranscode from idl.aml_mpcs_a50ubcardjour where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a50ubcardjour.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes