: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_billlist_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_billlist_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select batchno
   ,contractno
   ,businesstype
   ,customername
   ,customerid
   ,draweracctno
   ,draweracctname
   ,discountway
   ,discounttype
   ,buybegindate
   ,buyenddate
   ,buybenddate
   ,buyrate
   ,keyno
   ,currency
   ,billsum
   ,billtype
   ,billclass
   ,billno
   ,draweracctno1
   ,draweracct1name
   ,isbas
   ,acptdate
   ,acptdate2
   ,duedate
   ,payee
   ,payeeacctno
   ,payeeacctname
   ,paveeacctbankno
   ,changeday
   ,discountsum
   ,discountdate
   ,billstatus
   ,inputdate
   ,updatedate
   ,updateuserid
   ,updateorgid
   ,interestday
   ,drawercustomer
   ,guarsum
   ,guaracctno
   ,guarterm
   ,paysum
   ,manualpay
   ,isbecustody
   ,otherdraweracctno
   ,othertxbalance
   ,czflag
from ${idl_schema}.odss_billlist_info
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_billlist_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes