: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_lxdftpmx_recal_i
CreateDate: 20250819
FileName:   ${iel_data_path}/pams_jxbb_lxdftpmx_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.jrgjbh,chr(13),''),chr(10),'') as jrgjbh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.jydf,chr(13),''),chr(10),'') as jydf
,jyr
,dqr
,replace(replace(t1.bzdm,chr(13),''),chr(10),'') as bzdm
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,tzje
,qmye
,dyrj
,ljrj
,yqsyl
,ftpjg
,replace(replace(t1.jxfs,chr(13),''),chr(10),'') as jxfs
,replace(replace(t1.tzlx,chr(13),''),chr(10),'') as tzlx
,replace(replace(t1.ssfhhh,chr(13),''),chr(10),'') as ssfhhh
,replace(replace(t1.ssfh,chr(13),''),chr(10),'') as ssfh
,dylxsr
,dyftpzycb
,dyftpjsr
,ljlxsr
,ljftpzycb
,ljftpjsr
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.khjlxm,chr(13),''),chr(10),'') as khjlxm
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh
,fpbl
,fphtzje
,fphqmye
,fphdyrj
,fphljrj
,fphdylxsr
,fphdyftpzycb
,fphdyftpjsr
,fphljlxsr
,fphljftpzycb
,fphljftpjsr
,replace(replace(t1.wjfl,chr(13),''),chr(10),'') as wjfl
,yqxyss
,fxjqzcje
,xgfxjqzcje
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,recal_dt
,ljtzysje
,tzhljftpjsy
,ljtzfyje
,jjljftpjsy
,fphljtzysje
,fphtzhljftpjsy
,fphljtzfyje
,fphjjljftpjsy
,dytzysje
,tzhdyftpjsy
,dytzfyje
,jjdyftpjsy
,fphdytzysje
,fphtzhdyftpjsy
,fphdytzfyje
,fphjjdyftpjsy

from ${iol_schema}.pams_jxbb_lxdftpmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_lxdftpmx_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
