: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_billlist_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_billlist_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(batchno,chr(10),''),chr(13),'') as batchno
,replace(replace(contractno,chr(10),''),chr(13),'') as contractno
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(draweracctno,chr(10),''),chr(13),'') as draweracctno
,replace(replace(draweracctname,chr(10),''),chr(13),'') as draweracctname
,replace(replace(discountway,chr(10),''),chr(13),'') as discountway
,replace(replace(discounttype,chr(10),''),chr(13),'') as discounttype
,replace(replace(buybegindate,chr(10),''),chr(13),'') as buybegindate
,replace(replace(buyenddate,chr(10),''),chr(13),'') as buyenddate
,replace(replace(buybenddate,chr(10),''),chr(13),'') as buybenddate
,replace(replace(buyrate,chr(10),''),chr(13),'') as buyrate
,replace(replace(keyno,chr(10),''),chr(13),'') as keyno
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(billsum,chr(10),''),chr(13),'') as billsum
,replace(replace(billtype,chr(10),''),chr(13),'') as billtype
,replace(replace(billclass,chr(10),''),chr(13),'') as billclass
,replace(replace(billno,chr(10),''),chr(13),'') as billno
,replace(replace(draweracctno1,chr(10),''),chr(13),'') as draweracctno1
,replace(replace(draweracct1name,chr(10),''),chr(13),'') as draweracct1name
,replace(replace(isbas,chr(10),''),chr(13),'') as isbas
,replace(replace(acptdate,chr(10),''),chr(13),'') as acptdate
,replace(replace(acptdate2,chr(10),''),chr(13),'') as acptdate2
,replace(replace(duedate,chr(10),''),chr(13),'') as duedate
,replace(replace(payee,chr(10),''),chr(13),'') as payee
,replace(replace(payeeacctno,chr(10),''),chr(13),'') as payeeacctno
,replace(replace(payeeacctname,chr(10),''),chr(13),'') as payeeacctname
,replace(replace(paveeacctbankno,chr(10),''),chr(13),'') as paveeacctbankno
,replace(replace(changeday,chr(10),''),chr(13),'') as changeday
,replace(replace(discountsum,chr(10),''),chr(13),'') as discountsum
,replace(replace(discountdate,chr(10),''),chr(13),'') as discountdate
,replace(replace(billstatus,chr(10),''),chr(13),'') as billstatus
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(updateuserid,chr(10),''),chr(13),'') as updateuserid
,replace(replace(updateorgid,chr(10),''),chr(13),'') as updateorgid
,replace(replace(interestday,chr(10),''),chr(13),'') as interestday
,replace(replace(drawercustomer,chr(10),''),chr(13),'') as drawercustomer
,replace(replace(guarsum,chr(10),''),chr(13),'') as guarsum
,replace(replace(guaracctno,chr(10),''),chr(13),'') as guaracctno
,replace(replace(guarterm,chr(10),''),chr(13),'') as guarterm
,replace(replace(paysum,chr(10),''),chr(13),'') as paysum
,replace(replace(manualpay,chr(10),''),chr(13),'') as manualpay
,replace(replace(isbecustody,chr(10),''),chr(13),'') as isbecustody
,replace(replace(otherdraweracctno,chr(10),''),chr(13),'') as otherdraweracctno
,replace(replace(othertxbalance,chr(10),''),chr(13),'') as othertxbalance
,replace(replace(czflag,chr(10),''),chr(13),'') as czflag
,replace(replace(purchaserpercent,chr(10),''),chr(13),'') as purchaserpercent
,replace(replace(afeerate,chr(10),''),chr(13),'') as afeerate
,replace(replace(putoutorgid,chr(10),''),chr(13),'') as putoutorgid
,replace(replace(draweracctbankname,chr(10),''),chr(13),'') as draweracctbankname
,replace(replace(acceptor,chr(10),''),chr(13),'') as acceptor
,replace(replace(acceptorbankno,chr(10),''),chr(13),'') as acceptorbankno
,replace(replace(acceptorbankname,chr(10),''),chr(13),'') as acceptorbankname
,replace(replace(billdiscounttype,chr(10),''),chr(13),'') as billdiscounttype
,replace(replace(custbillacctname,chr(10),''),chr(13),'') as custbillacctname
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_billlist_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_billlist_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes