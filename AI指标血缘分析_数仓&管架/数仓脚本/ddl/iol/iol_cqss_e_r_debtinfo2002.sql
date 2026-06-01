/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_debtinfo2002
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_debtinfo2002
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_debtinfo2002 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_debtinfo2002(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,ccy_fnds number(38,0) -- 货币资金:eg01bj01
    ,shrttm_ivs number(38,0) -- 短期投资:eg01bj02
    ,rcvb_bl number(38,0) -- 应收票据:eg01bj03
    ,rbdn number(38,0) -- 应收股利:eg01bj04
    ,recint number(38,0) -- 应收利息:eg01bj05
    ,rcvb number(38,0) -- 应收账款:eg01bj06
    ,ohrv number(38,0) -- 其他应收款:eg01bj07
    ,prpy_accval number(38,0) -- 预付账款:eg01bj08
    ,ftrs_mrgn number(38,0) -- 期货保证金:eg01bj09
    ,rcvb_alwc_amt number(38,0) -- 应收补贴款:eg01bj10
    ,rcvb_eptrb number(38,0) -- 应收出口退税:eg01bj11
    ,ivnt number(38,0) -- 存货:eg01bj12
    ,ivnt_ori_mtrl number(38,0) -- 存货原材料:eg01bj13
    ,ivnt_mdupartcl number(38,0) -- 存货产成品:eg01bj14
    ,ppdex number(38,0) -- 待摊费用:eg01bj15
    ,pndg_lqud_ast_net_loss number(38,0) -- 待处理流动资产净损失:eg01bj16
    ,in1yr_exps_longtrm_clm_ivs number(38,0) -- 一年内到期的长期债权投资:eg01bj17
    ,othr_lqud_ast number(38,0) -- 其他流动资产:eg01bj18
    ,lqud_ast_tot number(38,0) -- 流动资产合计:eg01bj19
    ,ltemivs number(38,0) -- 长期投资:eg01bj20
    ,ltmeyis number(38,0) -- 长期股权投资:eg01bj21
    ,longtrm_clm_ivs number(38,0) -- 长期债权投资:eg01bj22
    ,mrg_prmg number(38,0) -- 合并价差:eg01bj23
    ,ltemivs_tot number(38,0) -- 长期投资合计:eg01bj24
    ,fix_ast_ori_prc number(38,0) -- 固定资产原价:eg01bj25
    ,acm_dprcn number(38,0) -- 累计折旧:eg01bj26
    ,fix_ast_netval number(38,0) -- 固定资产净值:eg01bj27
    ,fix_ast_val_dprcnrsrv number(38,0) -- 固定资产值减值准备:eg01bj28
    ,fix_ast_netamt number(38,0) -- 固定资产净额:eg01bj29
    ,fix_atcln number(38,0) -- 固定资产清理:eg01bj30
    ,prj_dnc number(38,0) -- 工程物资:eg01bj31
    ,ucpt number(38,0) -- 在建工程:eg01bj32
    ,pndg_fix_ast_net_loss number(38,0) -- 待处理固定资产净损失:eg01bj33
    ,fix_ast_tot number(38,0) -- 固定资产合计:eg01bj34
    ,intgbl_ast number(38,0) -- 无形资产:eg01bj35
    ,land_use_wght number(38,0) -- （无形资产科目下）土地使用权:eg01bj36
    ,dfr_ast number(38,0) -- 递延资产:eg01bj37
    ,fix_ast_fix number(38,0) -- （递延资产科目下）固定资产修理:eg01bj38
    ,fix_ast_chg_expn number(38,0) -- （递延资产科目下）固定资产改良支出:eg01bj39
    ,othr_longtrm_ast number(38,0) -- 其他长期资产:eg01bj40
    ,spcl_qsi_rsrv_dnc number(38,0) -- （其他长期资产科目下）特准储备物资:eg01bj41
    ,intgbl_and_othrast_tot number(38,0) -- 无形及其他资产合计:eg01bj42
    ,dfr_taxpymt_brw_itm number(38,0) -- 递延税款借项:eg01bj43
    ,ast_tot number(38,0) -- 资产总计:eg01bj44
    ,shrttm_lnd number(38,0) -- 短期借款:eg01bj45
    ,pbl_bl number(38,0) -- 应付票据:eg01bj46
    ,pbl_accval number(38,0) -- 应付账款:eg01bj47
    ,riav_accval number(38,0) -- 预收账款:eg01bj48
    ,pbl_wage number(38,0) -- 应付工资:eg01bj49
    ,pbl_wlfr_fee number(38,0) -- 应付福利费:eg01bj50
    ,pblpft number(38,0) -- 应付利润:eg01bj51
    ,acrtax number(38,0) -- 应交税金:eg01bj52
    ,othr_pymt_amt number(38,0) -- 其他应交款:eg01bj53
    ,otpl number(38,0) -- 其他应付款:eg01bj54
    ,pnex number(38,0) -- 预提费用:eg01bj55
    ,frcst_lby number(38,0) -- 预计负债:eg01bj56
    ,in1yr_exps_longtrm_lby number(38,0) -- 一年内到期的长期负债:eg01bj57
    ,othr_lqud_lby number(38,0) -- 其他流动负债:eg01bj58
    ,lqud_lby_tot number(38,0) -- 流动负债合计:eg01bj59
    ,longtrm_lnd number(38,0) -- 长期借款:eg01bj60
    ,pbl_bond number(38,0) -- 应付债券:eg01bj61
    ,longtrm_pybl number(38,0) -- 长期应付款:eg01bj62
    ,spcl_pybl number(38,0) -- 专项应付款:eg01bj63
    ,othr_longtrm_lby number(38,0) -- 其他长期负债:eg01bj64
    ,spcl_qsi_rsrv_fnd number(38,0) -- （其他长期负债科目下）特准储备基金:eg01bj65
    ,longtrm_lby_tot number(38,0) -- 长期负债合计:eg01bj66
    ,dfr_taxpymt_crnt number(38,0) -- 递延税款贷项:eg01bj67
    ,lby_tot number(38,0) -- 负债合计:eg01bj68
    ,less_num_shrh_rght number(38,0) -- 少数股东权益:eg01bj69
    ,arcptl number(38,0) -- 实收资本:eg01bj70
    ,cty_cptl number(38,0) -- 国家资本:eg01bj71
    ,colltvt_cptl number(38,0) -- 集体资本:eg01bj72
    ,lglpsn_cptl number(38,0) -- 法人资本:eg01bj73
    ,nal_lglpsn_cptl number(38,0) -- （法人资本科目下）国有法人资本:eg01bj74
    ,colltvt_lglpsn_cptl number(38,0) -- （法人资本科目下）集体法人资本:eg01bj75
    ,idv_cptl number(38,0) -- 个人资本:eg01bj76
    ,frgnmrch_cptl number(38,0) -- 外商资本:eg01bj77
    ,cptrsv number(38,0) -- 资本公积:eg01bj78
    ,splrsv number(38,0) -- 盈余公积:eg01bj79
    ,lgl_pblc number(38,0) -- （盈余公积科目下）法定盈余公积:eg01bj80
    ,pbwlf_gld number(38,0) -- （盈余公积科目下）公益金:eg01bj81
    ,splmt_lqud_cptl number(38,0) -- （盈余公积科目下）补充流动资本:eg01bj82
    ,not_cfms_ivs_loss number(38,0) -- 未确认的投资损失:eg01bj83
    ,uspt number(38,0) -- 未分配利润:eg01bj84
    ,frncy_rpt_cnvr_difamt number(38,0) -- 外币报表折算差额:eg01bj85
    ,owr_rght_tot number(38,0) -- 所有者权益合计:eg01bj86
    ,lby_and_owr_rght_tot number(38,0) -- 负债和所有者权益总计:eg01bj87
    ,crt_dt_tm date -- 创建日期时间
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_debtinfo2002 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2002 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2002 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2002 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_debtinfo2002 is '企业资产负债表（2002 版）信息表';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ccy_fnds is '货币资金:eg01bj01';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.shrttm_ivs is '短期投资:eg01bj02';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.rcvb_bl is '应收票据:eg01bj03';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.rbdn is '应收股利:eg01bj04';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.recint is '应收利息:eg01bj05';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.rcvb is '应收账款:eg01bj06';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ohrv is '其他应收款:eg01bj07';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.prpy_accval is '预付账款:eg01bj08';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ftrs_mrgn is '期货保证金:eg01bj09';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.rcvb_alwc_amt is '应收补贴款:eg01bj10';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.rcvb_eptrb is '应收出口退税:eg01bj11';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ivnt is '存货:eg01bj12';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ivnt_ori_mtrl is '存货原材料:eg01bj13';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ivnt_mdupartcl is '存货产成品:eg01bj14';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ppdex is '待摊费用:eg01bj15';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pndg_lqud_ast_net_loss is '待处理流动资产净损失:eg01bj16';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.in1yr_exps_longtrm_clm_ivs is '一年内到期的长期债权投资:eg01bj17';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.othr_lqud_ast is '其他流动资产:eg01bj18';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lqud_ast_tot is '流动资产合计:eg01bj19';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ltemivs is '长期投资:eg01bj20';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ltmeyis is '长期股权投资:eg01bj21';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.longtrm_clm_ivs is '长期债权投资:eg01bj22';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.mrg_prmg is '合并价差:eg01bj23';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ltemivs_tot is '长期投资合计:eg01bj24';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_ori_prc is '固定资产原价:eg01bj25';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.acm_dprcn is '累计折旧:eg01bj26';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_netval is '固定资产净值:eg01bj27';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_val_dprcnrsrv is '固定资产值减值准备:eg01bj28';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_netamt is '固定资产净额:eg01bj29';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_atcln is '固定资产清理:eg01bj30';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.prj_dnc is '工程物资:eg01bj31';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ucpt is '在建工程:eg01bj32';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pndg_fix_ast_net_loss is '待处理固定资产净损失:eg01bj33';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_tot is '固定资产合计:eg01bj34';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.intgbl_ast is '无形资产:eg01bj35';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.land_use_wght is '（无形资产科目下）土地使用权:eg01bj36';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.dfr_ast is '递延资产:eg01bj37';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_fix is '（递延资产科目下）固定资产修理:eg01bj38';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.fix_ast_chg_expn is '（递延资产科目下）固定资产改良支出:eg01bj39';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.othr_longtrm_ast is '其他长期资产:eg01bj40';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.spcl_qsi_rsrv_dnc is '（其他长期资产科目下）特准储备物资:eg01bj41';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.intgbl_and_othrast_tot is '无形及其他资产合计:eg01bj42';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.dfr_taxpymt_brw_itm is '递延税款借项:eg01bj43';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.ast_tot is '资产总计:eg01bj44';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.shrttm_lnd is '短期借款:eg01bj45';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbl_bl is '应付票据:eg01bj46';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbl_accval is '应付账款:eg01bj47';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.riav_accval is '预收账款:eg01bj48';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbl_wage is '应付工资:eg01bj49';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbl_wlfr_fee is '应付福利费:eg01bj50';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pblpft is '应付利润:eg01bj51';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.acrtax is '应交税金:eg01bj52';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.othr_pymt_amt is '其他应交款:eg01bj53';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.otpl is '其他应付款:eg01bj54';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pnex is '预提费用:eg01bj55';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.frcst_lby is '预计负债:eg01bj56';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.in1yr_exps_longtrm_lby is '一年内到期的长期负债:eg01bj57';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.othr_lqud_lby is '其他流动负债:eg01bj58';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lqud_lby_tot is '流动负债合计:eg01bj59';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.longtrm_lnd is '长期借款:eg01bj60';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbl_bond is '应付债券:eg01bj61';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.longtrm_pybl is '长期应付款:eg01bj62';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.spcl_pybl is '专项应付款:eg01bj63';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.othr_longtrm_lby is '其他长期负债:eg01bj64';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.spcl_qsi_rsrv_fnd is '（其他长期负债科目下）特准储备基金:eg01bj65';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.longtrm_lby_tot is '长期负债合计:eg01bj66';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.dfr_taxpymt_crnt is '递延税款贷项:eg01bj67';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lby_tot is '负债合计:eg01bj68';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.less_num_shrh_rght is '少数股东权益:eg01bj69';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.arcptl is '实收资本:eg01bj70';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.cty_cptl is '国家资本:eg01bj71';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.colltvt_cptl is '集体资本:eg01bj72';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lglpsn_cptl is '法人资本:eg01bj73';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.nal_lglpsn_cptl is '（法人资本科目下）国有法人资本:eg01bj74';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.colltvt_lglpsn_cptl is '（法人资本科目下）集体法人资本:eg01bj75';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.idv_cptl is '个人资本:eg01bj76';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.frgnmrch_cptl is '外商资本:eg01bj77';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.cptrsv is '资本公积:eg01bj78';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.splrsv is '盈余公积:eg01bj79';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lgl_pblc is '（盈余公积科目下）法定盈余公积:eg01bj80';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.pbwlf_gld is '（盈余公积科目下）公益金:eg01bj81';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.splmt_lqud_cptl is '（盈余公积科目下）补充流动资本:eg01bj82';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.not_cfms_ivs_loss is '未确认的投资损失:eg01bj83';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.uspt is '未分配利润:eg01bj84';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.frncy_rpt_cnvr_difamt is '外币报表折算差额:eg01bj85';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.owr_rght_tot is '所有者权益合计:eg01bj86';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.lby_and_owr_rght_tot is '负债和所有者权益总计:eg01bj87';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_debtinfo2002.etl_timestamp is 'ETL处理时间戳';
