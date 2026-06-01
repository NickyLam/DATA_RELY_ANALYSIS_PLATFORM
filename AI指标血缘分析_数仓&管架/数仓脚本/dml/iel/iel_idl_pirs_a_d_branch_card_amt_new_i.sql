: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_a_d_branch_card_amt_new_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_a_d_branch_card_amt_new_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,brchno
,cardno
,custno
,opendt
,cardtp
,cardlv
,hykbz
,fhykbz
,jzkbz
,zxkbz
,yrjckdbkbz
,yrjckyxkbz
,bnkkbz
,ymckdbkbz
,ymckyxkbz
,yrjcklcdbkbz
,yrjcklcyxkbz
,ymcklcdbkbz
,ymcklcyxkbz
,smkbz
,ryckdbkbz
,ryckyxkbz
,rycklcdbkbz
,rycklcyxkbz
,lstsdt
,closdt
from  idl.pirs_a_d_branch_card_amt_new where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_a_d_branch_card_amt_new_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes