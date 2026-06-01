: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_glms_gl_knp_item_f
CreateDate: 20180529
FileName:   ${iel_data_path}/gl_knp_item_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select itemcd
,itemna
,itemlv
,dtittg
,blncdn
,ioflag
,pmodtg
,upitem
,itemtp
,aslbtp
,itemrg from idl.glms_gl_knp_item where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/gl_knp_item_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes