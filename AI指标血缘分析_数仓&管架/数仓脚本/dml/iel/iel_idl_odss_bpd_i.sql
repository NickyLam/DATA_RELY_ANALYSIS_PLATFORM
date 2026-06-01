: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bpd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bpd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
inr
,ownref
,nam
,fianam
,pntnam
,fiaref
,pntref
,credat
,opndat
,clsdat
,matdat
,intunt
,ownusr
,ver
,pntinr
,fpdinr
,pnttyp
,intrat
,intday
,liaextid
,fintyp
,pctfin
,intirt
,pntref1
,kuaday
,ywcur
,yjcur
,etyextkey
,punintrat
,tolrat
,marrat
,grarat
,branchinr
,bchkeyinr
,rskrat
,rsktyp
,finact
,fortyp
,lctyp
,fincod
,ovddat
,ovdflg
,feetyp
,feeamt
,actyld
,intamt
,othintamt
,fogamt
,fidinr
,totamt
,sndflg
,finblk
,syamt
,telamt
,sta
,cheamt
,benxiamt
,huanxiamt
,fhftyp
 from ${idl_schema}.odss_BPD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bpd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes