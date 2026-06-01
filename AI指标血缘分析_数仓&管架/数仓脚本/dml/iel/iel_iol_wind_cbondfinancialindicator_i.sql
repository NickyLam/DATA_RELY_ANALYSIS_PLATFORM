: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondfinancialindicator_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbondfinancialindicator.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,s_fa_extraordinary
,s_fa_deductedprofit
,s_fa_grossmargin
,s_fa_operateincome
,s_fa_investincome
,s_stmnote_finexp
,s_stm_is
,s_fa_ebit
,s_fa_ebitda
,s_fa_fcff
,s_fa_fcfe
,s_fa_exinterestdebt_current
,s_fa_exinterestdebt_noncurrent
,s_fa_interestdebt
,s_fa_netdebt
,s_fa_tangibleasset
,s_fa_workingcapital
,s_fa_networkingcapital
,s_fa_investcapital
,s_fa_retainedearnings
,s_fa_eps_basic
,s_fa_eps_diluted
,s_fa_eps_diluted2
,s_fa_bps
,s_fa_ocfps
,s_fa_grps
,s_fa_orps
,s_fa_surpluscapitalps
,s_fa_surplusreserveps
,s_fa_undistributedps
,s_fa_retainedps
,s_fa_cfps
,s_fa_ebitps
,s_fa_fcffps
,s_fa_fcfeps
,s_fa_netprofitmargin
,s_fa_grossprofitmargin
,s_fa_cogstosales
,s_fa_expensetosales
,s_fa_profittogr
,s_fa_saleexpensetogr
,s_fa_adminexpensetogr
,s_fa_finaexpensetogr
,s_fa_impairtogr_ttm
,s_fa_gctogr
,s_fa_optogr
,s_fa_ebittogr
,s_fa_roe
,s_fa_roe_deducted
,s_fa_roa2
,s_fa_roa
,s_fa_roic
,s_fa_roe_yearly
,s_fa_roa2_yearly
,s_fa_roe_avg
,s_fa_operateincometoebt
,s_fa_investincometoebt
,s_fa_nonoperateprofittoebt
,s_fa_taxtoebt
,s_fa_deductedprofittoprofit
,s_fa_salescashintoor
,s_fa_ocftoor
,s_fa_ocftooperateincome
,s_fa_capitalizedtoda
,s_fa_debttoassets
,s_fa_assetstoequity
,s_fa_dupont_assetstoequity
,s_fa_catoassets
,s_fa_ncatoassets
,s_fa_tangibleassetstoassets
,s_fa_intdebttototalcap
,s_fa_equitytototalcapital
,s_fa_currentdebttodebt
,s_fa_longdebtodebt
,s_fa_current
,s_fa_quick
,s_fa_cashratio
,s_fa_ocftoshortdebt
,s_fa_debttoequity
,s_fa_equitytodebt
,s_fa_equitytointerestdebt
,s_fa_tangibleassettodebt
,s_fa_tangassettointdebt
,s_fa_tangibleassettonetdebt
,s_fa_ocftodebt
,s_fa_ocftointerestdebt
,s_fa_ocftonetdebt
,s_fa_ebittointerest
,s_fa_longdebttoworkingcapital
,s_fa_ebitdatodebt
,s_fa_turndays
,s_fa_invturndays
,s_fa_arturndays
,s_fa_invturn
,s_fa_arturn
,s_fa_caturn
,s_fa_faturn
,s_fa_assetsturn
,s_fa_roa_yearly
,s_fa_dupont_roa
,s_stm_bs
,s_fa_prefinexpense_opprofit
,s_fa_nonopprofit
,s_fa_optoebt
,s_fa_noptoebt
,s_fa_ocftoprofit
,s_fa_cashtoliqdebt
,s_fa_cashtoliqdebtwithinterest
,s_fa_optoliqdebt
,s_fa_optodebt
,s_fa_roic_yearly
,s_fa_tot_faturn
,s_fa_profittoop
,s_qfa_operateincome
,s_qfa_investincome
,s_qfa_deductedprofit
,s_qfa_eps
,s_qfa_netprofitmargin
,s_qfa_grossprofitmargin
,s_qfa_expensetosales
,s_qfa_profittogr
,s_qfa_saleexpensetogr
,s_qfa_adminexpensetogr
,s_qfa_finaexpensetogr
,s_qfa_impairtogr_ttm
,s_qfa_gctogr
,s_qfa_optogr
,s_qfa_roe
,s_qfa_roe_deducted
,s_qfa_roa
,s_qfa_operateincometoebt
,s_qfa_investincometoebt
,s_qfa_deductedprofittoprofit
,s_qfa_salescashintoor
,s_qfa_ocftosales
,s_qfa_ocftoor
,s_fa_yoyeps_basic
,s_fa_yoyeps_diluted
,s_fa_yoyocfps
,s_fa_yoyop
,s_fa_yoyebt
,s_fa_yoynetprofit
,s_fa_yoynetprofit_deducted
,s_fa_yoyocf
,s_fa_yoyroe
,s_fa_yoybps
,s_fa_yoyassets
,s_fa_yoyequity
,s_fa_yoy_tr
,s_fa_yoy_or
,s_qfa_yoygr
,s_qfa_cgrgr
,s_qfa_yoysales
,s_qfa_cgrsales
,s_qfa_yoyop
,s_qfa_cgrop
,s_qfa_yoyprofit
,s_qfa_cgrprofit
,s_qfa_yoynetprofit
,s_qfa_cgrnetprofit
,s_fa_yoy_equity
,rd_expense

from ${iol_schema}.wind_cbondfinancialindicator t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondfinancialindicator.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
