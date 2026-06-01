/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_cashinfoinf2007
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_cashinfoinf2007
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_cashinfoinf2007 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_cashinfoinf2007(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash number(38,0) -- 销售商品和提供劳务收到的现金:eg06bj01
    ,rcvd_taxfee_ret number(38,0) -- 收到的税费返还:eg06bj02
    ,rdothr_wth_optavy_cash number(38,0) -- 收到其他与经营活动有关的现金:eg06bj03
    ,oprt_avy_flwcsh_sbtl number(38,0) -- 经营活动现金流入小计:eg06bj04
    ,prch_cdty_acptsvc_pycsh number(38,0) -- 购买商品、接受劳务支付的现金:eg06bj05
    ,pygv_wkrs_forwkrs_pycsh number(38,0) -- 支付给职工以及为职工支付的现金:eg06bj06
    ,py_et_taxfee number(38,0) -- 支付的各项税费:eg06bj07
    ,py_othr_oprt_avy_cash number(38,0) -- 支付其他与经营活动有关的现金:eg06bj08
    ,oprt_avy_cf_out_sbtl number(38,0) -- 经营活动现金流出小计:eg06bj09
    ,oprt_avy_gen_cf_netamt number(38,0) -- 经营活动产生的现金流量净额:eg06bj10
    ,wtd_ivsplc_rcvsch number(38,0) -- 收回投资所收到的现金:eg06bj11
    ,obis_icpl_rcvsch number(38,0) -- 取得投资收益所收到的现金:eg06bj12
    ,dpl_ast_plc_cash number(38,0) -- 处置固定资产无形资产和其他长期资产所收回的现金净额:eg06bj13
    ,dpl_subs_oprgcl_cshntat number(38,0) -- 处置子公司及其他营业单位收到的现金净额:eg06bj14
    ,rd_othr_ivs_avy_relcsh number(38,0) -- 收到其他与投资活动有关的现金:eg06bj15
    ,ivs_avy_flowcash_sbtl number(38,0) -- 投资活动现金流入小计:eg06bj16
    ,acfxat_ast_plc_pycsh number(38,0) -- 购建固定资产无形资产和其他长期资产所支付的现金:eg06bj17
    ,ivs_plc_pycsh number(38,0) -- 投资所支付的现金:eg06bj18
    ,obtn_subs_oprg_pyt_cshntat number(38,0) -- 取得子公司及其他营业单位支付的现金净额:eg06bj19
    ,py_othr_ivs_avy_cash number(38,0) -- 支付其他与投资活动有关的现金:eg06bj20
    ,ivs_avy_cf_out_sbtl number(38,0) -- 投资活动现金流出小计:eg06bj21
    ,ivs_avy_gen_cf_netamt number(38,0) -- 投资活动产生的现金流量净额:eg06bj22
    ,absrb_ivs_plc_cash number(38,0) -- 吸收投资收到的现金:eg06bj23
    ,obtn_lnd_rcvds_cash number(38,0) -- 取得借款收到的现金:eg06bj24
    ,rcvd_othr_fnc_avy_cash number(38,0) -- 收到其他与筹资活动有关的现金:eg06bj25
    ,fnc_avy_flowcash_sbtl number(38,0) -- 筹资活动现金流入小计:eg06bj26
    ,repy_dbt_plc_pys_cash number(38,0) -- 偿还债务所支付的现金:eg06bj27
    ,alct_dvdn_pft_cmpn_plc_pycsh number(38,0) -- 分配股利、利润或偿付利息所支付的现金:eg06bj28
    ,py_othr_fnc_avy_cash number(38,0) -- 支付其他与筹资活动有关的现金:eg06bj29
    ,fnc_avy_cf_out_sbtl number(38,0) -- 筹资活动现金流出小计:eg06bj30
    ,set_avy_gen_cf_netamt number(38,0) -- 筹集活动产生的现金流量净额:eg06bj31
    ,erch_csh_and_csheqv_aff number(38,0) -- 汇率变动对现金及现金等价物的影响:eg06bj32
    ,casheqv_add_amt number(38,0) -- 现金及现金等价物净增加额:eg06bj33
    ,bop_casheqv_bal number(38,0) -- 期初现金及现金等价物余额:eg06bj34
    ,eop_casheqv_bal number(38,0) -- 期末现金及现金等价物余额:eg06bj35
    ,net_pft number(38,0) -- 净利润:eg06bj36
    ,ast_dprcnrsrv number(38,0) -- 资产减值准备:eg06bj37
    ,ast_dprcn number(38,0) -- 固定资产折旧、油气资产折耗、生产性生物资产折旧:eg06bj38
    ,intgbl_ast_amrz number(38,0) -- 无形资产摊销:eg06bj39
    ,longtrm_ppdex_amrz number(38,0) -- 长期待摊费用摊销:eg06bj40
    ,ppdex_rdc number(38,0) -- 待摊费用减少:eg06bj41
    ,pnex_add number(38,0) -- 预提费用增加:eg06bj42
    ,displ_ast_loss number(38,0) -- 处置固定资产无形资产和其他长期资产的损失:eg06bj43
    ,fix_ast_scrp_loss number(38,0) -- 固定资产报废损失:eg06bj44
    ,fairval_chg_loss number(38,0) -- 公允价值变动损失:eg06bj45
    ,fncex number(38,0) -- 财务费用:eg06bj46
    ,ivs_loss number(38,0) -- 投资损失:eg06bj47
    ,dfr_incmtax_ast_rdc number(38,0) -- 递延所得税资产减少:eg06bj48
    ,dfr_incmtax_lby_add number(38,0) -- 递延所得税负债增加:eg06bj49
    ,ivnts_rdc number(38,0) -- 存货的减少:eg06bj50
    ,oprg_rcvb_prjs_rdc number(38,0) -- 经营性应收项目的减少:eg06bj51
    ,oprg_pbl_prjs_add number(38,0) -- 经营性应付项目的增加:eg06bj52
    ,othr_oprt_avy_cash_flow number(38,0) -- （净利润调节为经营活动现金流量科目下）其他:eg06bj53
    ,oprt_avy_cf_netamt number(38,0) -- 经营活动产生的现金流量净额:eg06bj54
    ,dbt_tfr_for_cptl number(38,0) -- 债务转为资本:eg06bj55
    ,in1yr_exps_cnvrt_cobd number(38,0) -- 一年内到期的可转换公司债券:eg06bj56
    ,fnc_rnt_fix_ast number(38,0) -- 融资租入固定资产:eg06bj57
    ,cash_endofprdbal number(38,0) -- 现金的期末余额:eg06bj58
    ,cash_bgnprdbal number(38,0) -- 现金的期初余额:eg06bj59
    ,cash_eqvs_endofprdbal number(38,0) -- 现金等价物的期末余额:eg06bj60
    ,cash_eqvs_bgnprdbal number(38,0) -- 现金等价物的期初余额:eg06bj61
    ,csheqv_ntic_add_amt number(38,0) -- 现金及现金等价物净增加额:eg06bj62
    ,othr_not_cash_ivs number(38,0) -- （不涉及现金收支的投资和筹资活动科目下）其他:eg06bj63
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2007 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2007 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2007 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2007 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_cashinfoinf2007 is '企业现金流量表（2007 版）信息表';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.rtpd_and_prd_lbrsvc_cash is '销售商品和提供劳务收到的现金:eg06bj01';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.rcvd_taxfee_ret is '收到的税费返还:eg06bj02';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.rdothr_wth_optavy_cash is '收到其他与经营活动有关的现金:eg06bj03';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprt_avy_flwcsh_sbtl is '经营活动现金流入小计:eg06bj04';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.prch_cdty_acptsvc_pycsh is '购买商品、接受劳务支付的现金:eg06bj05';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.pygv_wkrs_forwkrs_pycsh is '支付给职工以及为职工支付的现金:eg06bj06';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.py_et_taxfee is '支付的各项税费:eg06bj07';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.py_othr_oprt_avy_cash is '支付其他与经营活动有关的现金:eg06bj08';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprt_avy_cf_out_sbtl is '经营活动现金流出小计:eg06bj09';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprt_avy_gen_cf_netamt is '经营活动产生的现金流量净额:eg06bj10';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.wtd_ivsplc_rcvsch is '收回投资所收到的现金:eg06bj11';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.obis_icpl_rcvsch is '取得投资收益所收到的现金:eg06bj12';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.dpl_ast_plc_cash is '处置固定资产无形资产和其他长期资产所收回的现金净额:eg06bj13';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.dpl_subs_oprgcl_cshntat is '处置子公司及其他营业单位收到的现金净额:eg06bj14';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.rd_othr_ivs_avy_relcsh is '收到其他与投资活动有关的现金:eg06bj15';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivs_avy_flowcash_sbtl is '投资活动现金流入小计:eg06bj16';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.acfxat_ast_plc_pycsh is '购建固定资产无形资产和其他长期资产所支付的现金:eg06bj17';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivs_plc_pycsh is '投资所支付的现金:eg06bj18';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.obtn_subs_oprg_pyt_cshntat is '取得子公司及其他营业单位支付的现金净额:eg06bj19';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.py_othr_ivs_avy_cash is '支付其他与投资活动有关的现金:eg06bj20';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivs_avy_cf_out_sbtl is '投资活动现金流出小计:eg06bj21';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivs_avy_gen_cf_netamt is '投资活动产生的现金流量净额:eg06bj22';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.absrb_ivs_plc_cash is '吸收投资收到的现金:eg06bj23';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.obtn_lnd_rcvds_cash is '取得借款收到的现金:eg06bj24';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.rcvd_othr_fnc_avy_cash is '收到其他与筹资活动有关的现金:eg06bj25';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fnc_avy_flowcash_sbtl is '筹资活动现金流入小计:eg06bj26';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.repy_dbt_plc_pys_cash is '偿还债务所支付的现金:eg06bj27';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.alct_dvdn_pft_cmpn_plc_pycsh is '分配股利、利润或偿付利息所支付的现金:eg06bj28';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.py_othr_fnc_avy_cash is '支付其他与筹资活动有关的现金:eg06bj29';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fnc_avy_cf_out_sbtl is '筹资活动现金流出小计:eg06bj30';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.set_avy_gen_cf_netamt is '筹集活动产生的现金流量净额:eg06bj31';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.erch_csh_and_csheqv_aff is '汇率变动对现金及现金等价物的影响:eg06bj32';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.casheqv_add_amt is '现金及现金等价物净增加额:eg06bj33';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.bop_casheqv_bal is '期初现金及现金等价物余额:eg06bj34';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.eop_casheqv_bal is '期末现金及现金等价物余额:eg06bj35';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.net_pft is '净利润:eg06bj36';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ast_dprcnrsrv is '资产减值准备:eg06bj37';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ast_dprcn is '固定资产折旧、油气资产折耗、生产性生物资产折旧:eg06bj38';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.intgbl_ast_amrz is '无形资产摊销:eg06bj39';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.longtrm_ppdex_amrz is '长期待摊费用摊销:eg06bj40';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ppdex_rdc is '待摊费用减少:eg06bj41';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.pnex_add is '预提费用增加:eg06bj42';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.displ_ast_loss is '处置固定资产无形资产和其他长期资产的损失:eg06bj43';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fix_ast_scrp_loss is '固定资产报废损失:eg06bj44';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fairval_chg_loss is '公允价值变动损失:eg06bj45';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fncex is '财务费用:eg06bj46';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivs_loss is '投资损失:eg06bj47';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.dfr_incmtax_ast_rdc is '递延所得税资产减少:eg06bj48';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.dfr_incmtax_lby_add is '递延所得税负债增加:eg06bj49';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.ivnts_rdc is '存货的减少:eg06bj50';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprg_rcvb_prjs_rdc is '经营性应收项目的减少:eg06bj51';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprg_pbl_prjs_add is '经营性应付项目的增加:eg06bj52';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.othr_oprt_avy_cash_flow is '（净利润调节为经营活动现金流量科目下）其他:eg06bj53';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.oprt_avy_cf_netamt is '经营活动产生的现金流量净额:eg06bj54';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.dbt_tfr_for_cptl is '债务转为资本:eg06bj55';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.in1yr_exps_cnvrt_cobd is '一年内到期的可转换公司债券:eg06bj56';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.fnc_rnt_fix_ast is '融资租入固定资产:eg06bj57';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.cash_endofprdbal is '现金的期末余额:eg06bj58';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.cash_bgnprdbal is '现金的期初余额:eg06bj59';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.cash_eqvs_endofprdbal is '现金等价物的期末余额:eg06bj60';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.cash_eqvs_bgnprdbal is '现金等价物的期初余额:eg06bj61';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.csheqv_ntic_add_amt is '现金及现金等价物净增加额:eg06bj62';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.othr_not_cash_ivs is '（不涉及现金收支的投资和筹资活动科目下）其他:eg06bj63';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2007.etl_timestamp is 'ETL处理时间戳';
