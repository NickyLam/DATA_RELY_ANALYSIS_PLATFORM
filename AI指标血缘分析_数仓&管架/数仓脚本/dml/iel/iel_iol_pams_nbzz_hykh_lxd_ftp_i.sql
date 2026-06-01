: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_hykh_lxd_ftp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_nbzz_hykh_lxd_ftp.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.tjrq as tjrq
    ,t.khdxdh as khdxdh
    ,replace(replace(t.jrgjbh,chr(13),''),chr(10),'') as jrgjbh
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,t.ftpll as ftpll
    ,t.ftplxzcrlj as ftplxzcrlj
    ,t.ftplxzcylj as ftplxzcylj
    ,t.ftplxzcnlj as ftplxzcnlj
    ,t.ftplxsrrlj as ftplxsrrlj
    ,t.ftplxsrylj as ftplxsrylj
    ,t.ftplxsrnlj as ftplxsrnlj
    ,t.ftpjsrrlj as ftpjsrrlj
    ,t.ftpjsrylj as ftpjsrylj
    ,t.ftpjsrnlj as ftpjsrnlj
    ,t.fphftplxzcrlj as fphftplxzcrlj
    ,t.fphftplxzcylj as fphftplxzcylj
    ,t.fphftplxzcnlj as fphftplxzcnlj
    ,t.fphftplxsrrlj as fphftplxsrrlj
    ,t.fphftplxsrylj as fphftplxsrylj
    ,t.fphftplxsrnlj as fphftplxsrnlj
    ,t.fphftpjsrrlj as fphftpjsrrlj
    ,t.fphftpjsrylj as fphftpjsrylj
    ,t.fphftpjsrnlj as fphftpjsrnlj
    ,t.fpbl as fpbl
from iol.pams_nbzz_hykh_lxd_ftp t
  where t.tjrq= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_hykh_lxd_ftp.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes