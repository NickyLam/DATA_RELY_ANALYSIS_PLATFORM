: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_cpd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_cpd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,nam
,pyeptyinr
,pyeptainr
,pyenam
,pyeref
,pybptyinr
,pybptainr
,pybnam
,pybref
,orcptyinr
,orcptainr
,orcnam
,orcref
,oriptyinr
,oriptainr
,orinam
,oriref
,valdat
,opndat
,clsdat
,chato
,credat
,ownusr
,ver
,detchgcod
,paytyp
,stagod
,stacty
,etyextkey
,sysno
,othbch
,gors
,feecur
,feeamt
,trntyp
,paytype
,paydat
,clityp
,trdint
,curf33b
,cur71f
,amt71f
,amtf33b
,f36
,f23e
,f23b
,trdout
,swftyp
,trdinr
,rel21
,branchinr
,bchkeyinr
,accmod
,sztyp
,sndbanref
,orcact
,pyeact
,canflg
,nraflg
,qsqdbh from idl.aml_isbs_cpd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_cpd.f.${batch_date}.dat" \
        charset=utf8
        safe=yes