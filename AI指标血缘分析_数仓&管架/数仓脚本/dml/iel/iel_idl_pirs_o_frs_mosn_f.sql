: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_frs_mosn_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_frs_mosn_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select trandt
,trantm
,serino
,payno
,pkgtyp
,channel
,branch
,oubank
,inbank
,rspscd
,msgtxt
,trancd
,senddt
,workdt
,batch
,groupn
,dcflag
,transt
,oldst
,amount
,debank
,paybank
,deacct
,deacnm
,deacadr
,crbank
,incbank
,cracct
,cracnm
,cracadr
,purpos
,notetp
,noteno
,issudt
,result
,appdda
,reason
,srcadt
,srcsno
,whacct
,linkid
,tlrnbr
,chctlr
,auttlr
,enctlr
,ruztlr
,checdt
,authdt
,keladt
,kelsno
,stridt
,strino
,strcdt
,strcsn
,digest
,reserv1
,reserv2
,reserv3
,reserv4
,remark
,payasq
,prtcnt
 from idl.pirs_o_frs_mosn where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_frs_mosn_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes