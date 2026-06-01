: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_isbs_gid_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_gid.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,inr
,ownref
,nam
,ownusr
,credat
,opndat
,clsdat
,oldref
,amedat
,orddat
,amenbr
,pndclm
,chato
,expdat
,liadat
,stacty
,ver
,hndtyp
,gidtxtmodflg
,gtxinr
,giduil
,expflg
,liaflg
,orcdat
,orcref
,orccur
,orcamt
,orcrat
,sndto
,purcan
,tenref
,tendat
,avidat
,tenclsdat
,decrea
,jurplc
,jurlaw
,acc
,resflg
,stagod
,redamt
,redcur
,reddat
,outcur
,outamt
,cnfsta
,partcon
,cnfdat
,cnfflg
,revflg
,etyextkey
,gartyp
,trmdat
,legfrm
,inudat
,feecoldat
,bchkeyinr
,branchinr
,teskeyunc
,juscod
,cunqii
,bilvvv
,decflg
,rskrat
,cshpct
,guaflg
,fincod
,fintyp
,relcshpct
,garfin from idl.aml_isbs_gid where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_gid.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes