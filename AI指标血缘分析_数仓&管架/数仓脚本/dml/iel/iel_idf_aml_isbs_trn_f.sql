: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_trn_f
CreateDate: 20240129
FileName:   ${iel_data_path}/aml_isbs_trn.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
etl_dt
,inr
,inidattim
,inifrm
,iniusr
,ininam
,ownref
,objtyp
,objinr
,objnam
,ssninr
,smhnxt
,usg
,usr
,cpldattim
,infdsp
,inftxt
,relflg
,comflg
,comdat
,cortrninr
,xreflg
,xrecurblk
,relcur
,relamt
,reloricur
,reloriamt
,relreq
,relres
,cnfflg
,evttxt
,rprusr
,ordinr
,exedat
,etyextkey
,bchkeyinr
,accbchinr
,relreq0
,relreq1
,relreq2
,relres0
,relres1
,relres2
,relusr1
,relusr2
,relusr3
,imginr
,branchinr
,orgflg
,addtxt
,gylsh
,gylsh1
,yewgzh
,cmtflg
,ctrbnknum
,ctrbnknam
,qjls
 from idl.aml_isbs_trn 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_trn.f.${batch_date}.dat" \
        charset=utf8
        safe=yes