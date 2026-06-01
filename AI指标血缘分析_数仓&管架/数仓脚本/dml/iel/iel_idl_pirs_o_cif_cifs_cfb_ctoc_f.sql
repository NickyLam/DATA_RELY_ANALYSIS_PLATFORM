: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_cif_cifs_cfb_ctoc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_cif_cifs_cfb_ctoc_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select ctocno
,outsfg
,custno
,lawbno
,custsr from idl.pirs_o_cif_cifs_cfb_ctoc where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_cif_cifs_cfb_ctoc_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes