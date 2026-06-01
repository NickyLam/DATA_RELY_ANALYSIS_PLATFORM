: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_careerinexinfo1997_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_careerinexinfo1997.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,t.fnc_alwc_incm as fnc_alwc_incm
    ,t.supr_alwc_incm as supr_alwc_incm
    ,t.aflt_unit_pym as aflt_unit_pym
    ,t.crer_incm as crer_incm
    ,t.bdgt_frgncptl_gld_incm as bdgt_frgncptl_gld_incm
    ,t.oicm as oicm
    ,t.crer_incm_sbtl as crer_incm_sbtl
    ,t.oprt_incm as oprt_incm
    ,t.oprt_incm_sbtl as oprt_incm_sbtl
    ,t.into_spclfnd as into_spclfnd
    ,t.into_spclfnd_sbtl as into_spclfnd_sbtl
    ,t.incm_tot as incm_tot
    ,t.out_fee as out_fee
    ,t.tnov_supr_expn as tnov_supr_expn
    ,t.to_aflt_unit_alwc as to_aflt_unit_alwc
    ,t.crer_expn as crer_expn
    ,t.fnc_alwc_expn as fnc_alwc_expn
    ,t.bdgt_frgncptl_gld_expn as bdgt_frgncptl_gld_expn
    ,t.crer_sale_tax as crer_sale_tax
    ,t.crrov_slfnc_nfrstr as crrov_slfnc_nfrstr
    ,t.crer_expn_sbtl as crer_expn_sbtl
    ,t.oprt_expn as oprt_expn
    ,t.oprt_sale_tax as oprt_sale_tax
    ,t.oprt_expn_sbtl as oprt_expn_sbtl
    ,t.out_spclfnd as out_spclfnd
    ,t.spclfnd_expn as spclfnd_expn
    ,t.spclfnd_sbtl as spclfnd_sbtl
    ,t.expn_tot as expn_tot
    ,t.crer_srpls as crer_srpls
    ,t.rglr_incm_srpls as rglr_incm_srpls
    ,t.wd_awla_bfr_crer_expn as wd_awla_bfr_crer_expn
    ,t.oprt_srpls as oprt_srpls
    ,t.awla_bfr_oprt_loss as awla_bfr_oprt_loss
    ,t.srpls_alct as srpls_alct
    ,t.pymt_incmtax as pymt_incmtax
    ,t.rtrv_spclpps_fnd as rtrv_spclpps_fnd
    ,t.tfrin_crer_fnd as tfrin_crer_fnd
    ,t.othr_srpls_alct as othr_srpls_alct
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_careerinexinfo1997 t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_careerinexinfo1997.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes