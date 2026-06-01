: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_account_draw_details_a
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_account_draw_details.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select drawdate
,accountid
,businessseqno
,businessid
,moduleid
,ptype
,gendate
,updatedate
,cashamt
,assetamt
,prinamt
,balanceflag
,yield
,tddraw_add
,tddraw_intpay_adj
,tddraw_repay_adj
,perioddraw
,totaldraw
,tdtounpaydraw
,tdtoactpaydraw
,totaltounpaydraw
,totaldraw_unadj
,tdactpayint
,totalactpayint
,totalunpayint
,lstmntdate
,unpayamt
,ystperioddraw
,ysttotaldraw
,ysttotaltounpaydraw
,ysttotaldraw_unadj
,ysttotalactpayint
,ysttotalunpayint
,payunpayintamt
,tdycosta
,ystcosta
,tdyprofitlossa
,ystprofitlossa
,tdycostcostb
,ystcostcostb
,tdycostintb
,ystcostintb
,tdyprofitlossb
,ystprofitlossb
,etl_dt
,etl_timestamp from iol.fams_bok_account_draw_details where etl_dt < to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_account_draw_details.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes