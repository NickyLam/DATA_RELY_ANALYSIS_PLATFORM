: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pcrs_guaranty_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/guaranty_contract_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
serialno
,contracttype
,guarantytype
,contractstatus
,contractno
,signdate
,begindate
,enddate
,customerid
,guarantorid
,guarantorname
,creditorgid
,creditorgname
,guarantycurrency
,guarantyvalue
,guarantyinfo
,otherdescribe
,checkguaranty
,reception
,receptionduty
,guaranryopinion
,checkguarantyman1
,checkguarantyman2
,inputorgid
,inputuserid
,inputdate
,updateuserid
,updatedate
,remark
,certtype
,certid
,othername
,loancardno
,guaranteeform
,commondate
,bailratio
,vouchtype
,econtracttype
,ectempsaveflag
,textcontractno
,shortorg
,orgname
,partyaaddress
,partyaphone
,partyafax
,partyaprincipal
,partyaduty
,partybname
,partybcerttype
,partybcertid
,partybaddress
,partybphone
,partybfax
,partyblegalperson
,partybpostcode
,partybduty
,textmaincontractno
,guarantyrange
,otherguarantyrange
,guarantyperiod
,otherguarantyperiod1
,otherguarantyperiod2
,notarizationflag
,otherpromise
,otherparties
,maincontractname
,maincontractcurrency
,maincontractsum
,compensatetype
,transfercreditrange
,begintime
,endtime
,financeitem7
,financeitem6
,guarantytype2
,printflag
,pigeonholedate
,quoteguarantyquota
,quoteguarantyquotano
,totalcopies
,partyacopies
,contractword
,contractno1
,contractname
,currency1
,contractsum1
,contractword2
,contractno2
,contractname2
,currency2
,contractsum2
,currency3
,contractsum3
,currency4
,contractsum4
,firstcreditparty
,firstcreditcurrency
,firstcreditsum
,secondcreditparty
,secondcreditcurrency
,secondcreditsum
,thirdcreditparty
,thirdcreditcurrency
,thirdcreditsum
from idl.pcrs_guaranty_contract
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/guaranty_contract_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes