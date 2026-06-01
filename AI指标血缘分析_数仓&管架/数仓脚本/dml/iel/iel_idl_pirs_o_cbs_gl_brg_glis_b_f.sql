: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_cbs_gl_brg_glis_b_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_cbs_gl_brg_glis_b_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select acctdt
,brchno
,crcycd
,itemcd
,drltbl
,crltbl
,drtsam
,drtsnm
,crtsam
,crtsnm
,drctbl
,crctbl
,ioflag from idl.pirs_o_cbs_gl_brg_glis_b where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_cbs_gl_brg_glis_b_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes