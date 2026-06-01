/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_cashinfoinf2002
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_cashinfoinf2002
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_cashinfoinf2002 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_cashinfoinf2002(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,rtpd_and_prd_lbrsvc_cash number(38,0) -- 销售商品和提供劳务收到的现金:eg05bj01
    ,rcvd_taxfee_ret number(38,0) -- 收到的税费返还:eg05bj02
    ,rdothr_wth_optavy_cash number(38,0) -- 收到的其他与经营活动有关的现金:eg05bj03
    ,oprt_avy_flwcsh_sbtl number(38,0) -- 经营活动现金流入小计:eg05bj04
    ,prch_cdty_acptsvc_pycsh number(38,0) -- 购买商品、接受劳务支付的现金:eg05bj05
    ,pygv_wkrs_forwkrs_pycsh number(38,0) -- 支付给职工以及为职工支付的现金:eg05bj06
    ,py_et_taxfee number(38,0) -- 支付的各项税费:eg05bj07
    ,py_othr_oprt_avy_cash number(38,0) -- 支付的其他与经营活动有关的现金:eg05bj08
    ,oprt_avy_cf_out_sbtl number(38,0) -- 经营活动现金流出小计:eg05bj09
    ,oprt_avy_gen_cf_netamt number(38,0) -- 经营活动产生的现金流量净额:eg05bj10
    ,wtd_ivsplc_rcvsch number(38,0) -- 收回投资所收到的现金:eg05bj11
    ,obis_icpl_rcvsch number(38,0) -- 取得投资收益所收到的现金:eg05bj12
    ,dpl_ast_plc_cash number(38,0) -- 处置固定资产无形资产和其他长期资产所收回的现金净额:eg05bj13
    ,rd_othr_ivs_avy_relcsh number(38,0) -- 收到的其他与投资活动有关的现金:eg05bj14
    ,ivs_avy_flowcash_sbtl number(38,0) -- 投资活动现金流入小计:eg05bj15
    ,acfxat_ast_plc_pycsh number(38,0) -- 购建固定资产无形资产和其他长期资产所支付的现金:eg05bj16
    ,ivs_plc_pycsh number(38,0) -- 投资所支付的现金:eg05bj17
    ,py_othr_ivs_avy_cash number(38,0) -- 支付的其他与投资活动有关的现金:eg05bj18
    ,ivs_avy_cf_out_sbtl number(38,0) -- 投资活动现金流出小计:eg05bj19
    ,ivs_avy_gen_cf_netamt number(38,0) -- 投资活动产生的现金流量净额:eg05bj20
    ,absrb_ivs_plc_cash number(38,0) -- 吸收投资所收到的现金:eg05bj21
    ,lnd_plc_rcvd_cash number(38,0) -- 借款所收到的现金:eg05bj22
    ,rcvd_othr_fnc_avy_cash number(38,0) -- 收到的其他与筹资活动有关的现金:eg05bj23
    ,fnc_avy_flowcash_sbtl number(38,0) -- 筹资活动现金流入小计:eg05bj24
    ,repy_dbt_plc_pys_cash number(38,0) -- 偿还债务所支付的现金:eg05bj25
    ,alct_dvdn_pft_cmpn_plc_pycsh number(38,0) -- 分配股利、利润或偿付利息所支付的现金:eg05bj26
    ,py_othr_fnc_avy_rel_cash number(38,0) -- 支付的其他与筹资活动有关的现金:eg05bj27
    ,fnc_avy_cf_out_sbtl number(38,0) -- 筹资活动现金流出小计:eg05bj28
    ,set_avy_gen_cf_num_netamt number(38,0) -- 筹集活动产生的现金流量净额:eg05bj29
    ,erch_to_cash_aff number(38,0) -- 汇率变动对现金的影响:eg05bj30
    ,cash_eqv_ntic_add_amt number(38,0) -- 现金及现金等价物净增加额:eg05bj31
    ,net_pft number(38,0) -- 净利润:eg05bj32
    ,acr_ast_dprcnrsrv number(38,0) -- 计提的资产减值准备:eg05bj33
    ,fix_ast_old number(38,0) -- 固定资产拆旧:eg05bj34
    ,intgbl_ast_amrz number(38,0) -- 无形资产摊销:eg05bj35
    ,longtrm_ppdex_amrz number(38,0) -- 长期待摊费用摊销:eg05bj36
    ,ppdex_rdc number(38,0) -- 待摊费用减少:eg05bj37
    ,pnex_add number(38,0) -- 预提费用增加:eg05bj38
    ,displ_ast_loss number(38,0) -- 处置固定资产无形资产和其他长期资产的损失:eg05bj39
    ,fix_ast_scrp_loss number(38,0) -- 固定资产报废损失:eg05bj40
    ,fncex number(38,0) -- 财务费用:eg05bj41
    ,ivs_loss number(38,0) -- 投资损失:eg05bj42
    ,dfr_taxpymt_crnt number(38,0) -- 递延税款贷项:eg05bj43
    ,ivnt_s_rdc number(38,0) -- 存货的减少:eg05bj44
    ,oprg_rcvb_prj_rdc number(38,0) -- 经营性应收项目的减少:eg05bj45
    ,oprg_pbl_prj_add number(38,0) -- 经营性应付项目的增加:eg05bj46
    ,othr_oprt_avy_cash_flow number(38,0) -- （净利润调节为经营活动现金流量科目下）其他:eg05bj47
    ,oprt_avy_cf_netamt number(38,0) -- 经营活动产生的现金流量净额:eg05bj48
    ,dbt_tfr_for_cptl number(38,0) -- 债务转为资本:eg05bj49
    ,in1yr_exp_cnvrt_cobd number(38,0) -- 一年内到期的可转换公司债券:eg05bj50
    ,fnc_rnt_fix_ast number(38,0) -- 融资租入固定资产:eg05bj51
    ,othr_not_cash_ivs number(38,0) -- （不涉及现金收支的投资和筹资活动科目下）其他:eg05bj52
    ,cash_endofprdbal number(38,0) -- 现金的期末余额:eg05bj53
    ,cash_bgnprdbal number(38,0) -- 现金的期初余额:eg05bj54
    ,cash_eqv_endofprdbal number(38,0) -- 现金等价物的期末余额:eg05bj55
    ,cash_eqv_bgnprdbal number(38,0) -- 现金等价物的期初余额:eg05bj56
    ,csheqv_ntic_add_amt number(38,0) -- 现金及现金等价物净增加额:eg05bj57
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
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2002 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2002 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2002 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_cashinfoinf2002 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_cashinfoinf2002 is '企业现金流量表（2002 版）信息表';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.rtpd_and_prd_lbrsvc_cash is '销售商品和提供劳务收到的现金:eg05bj01';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.rcvd_taxfee_ret is '收到的税费返还:eg05bj02';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.rdothr_wth_optavy_cash is '收到的其他与经营活动有关的现金:eg05bj03';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprt_avy_flwcsh_sbtl is '经营活动现金流入小计:eg05bj04';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.prch_cdty_acptsvc_pycsh is '购买商品、接受劳务支付的现金:eg05bj05';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.pygv_wkrs_forwkrs_pycsh is '支付给职工以及为职工支付的现金:eg05bj06';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.py_et_taxfee is '支付的各项税费:eg05bj07';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.py_othr_oprt_avy_cash is '支付的其他与经营活动有关的现金:eg05bj08';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprt_avy_cf_out_sbtl is '经营活动现金流出小计:eg05bj09';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprt_avy_gen_cf_netamt is '经营活动产生的现金流量净额:eg05bj10';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.wtd_ivsplc_rcvsch is '收回投资所收到的现金:eg05bj11';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.obis_icpl_rcvsch is '取得投资收益所收到的现金:eg05bj12';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.dpl_ast_plc_cash is '处置固定资产无形资产和其他长期资产所收回的现金净额:eg05bj13';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.rd_othr_ivs_avy_relcsh is '收到的其他与投资活动有关的现金:eg05bj14';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivs_avy_flowcash_sbtl is '投资活动现金流入小计:eg05bj15';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.acfxat_ast_plc_pycsh is '购建固定资产无形资产和其他长期资产所支付的现金:eg05bj16';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivs_plc_pycsh is '投资所支付的现金:eg05bj17';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.py_othr_ivs_avy_cash is '支付的其他与投资活动有关的现金:eg05bj18';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivs_avy_cf_out_sbtl is '投资活动现金流出小计:eg05bj19';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivs_avy_gen_cf_netamt is '投资活动产生的现金流量净额:eg05bj20';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.absrb_ivs_plc_cash is '吸收投资所收到的现金:eg05bj21';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.lnd_plc_rcvd_cash is '借款所收到的现金:eg05bj22';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.rcvd_othr_fnc_avy_cash is '收到的其他与筹资活动有关的现金:eg05bj23';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fnc_avy_flowcash_sbtl is '筹资活动现金流入小计:eg05bj24';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.repy_dbt_plc_pys_cash is '偿还债务所支付的现金:eg05bj25';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.alct_dvdn_pft_cmpn_plc_pycsh is '分配股利、利润或偿付利息所支付的现金:eg05bj26';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.py_othr_fnc_avy_rel_cash is '支付的其他与筹资活动有关的现金:eg05bj27';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fnc_avy_cf_out_sbtl is '筹资活动现金流出小计:eg05bj28';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.set_avy_gen_cf_num_netamt is '筹集活动产生的现金流量净额:eg05bj29';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.erch_to_cash_aff is '汇率变动对现金的影响:eg05bj30';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cash_eqv_ntic_add_amt is '现金及现金等价物净增加额:eg05bj31';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.net_pft is '净利润:eg05bj32';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.acr_ast_dprcnrsrv is '计提的资产减值准备:eg05bj33';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fix_ast_old is '固定资产拆旧:eg05bj34';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.intgbl_ast_amrz is '无形资产摊销:eg05bj35';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.longtrm_ppdex_amrz is '长期待摊费用摊销:eg05bj36';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ppdex_rdc is '待摊费用减少:eg05bj37';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.pnex_add is '预提费用增加:eg05bj38';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.displ_ast_loss is '处置固定资产无形资产和其他长期资产的损失:eg05bj39';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fix_ast_scrp_loss is '固定资产报废损失:eg05bj40';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fncex is '财务费用:eg05bj41';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivs_loss is '投资损失:eg05bj42';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.dfr_taxpymt_crnt is '递延税款贷项:eg05bj43';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.ivnt_s_rdc is '存货的减少:eg05bj44';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprg_rcvb_prj_rdc is '经营性应收项目的减少:eg05bj45';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprg_pbl_prj_add is '经营性应付项目的增加:eg05bj46';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.othr_oprt_avy_cash_flow is '（净利润调节为经营活动现金流量科目下）其他:eg05bj47';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.oprt_avy_cf_netamt is '经营活动产生的现金流量净额:eg05bj48';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.dbt_tfr_for_cptl is '债务转为资本:eg05bj49';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.in1yr_exp_cnvrt_cobd is '一年内到期的可转换公司债券:eg05bj50';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.fnc_rnt_fix_ast is '融资租入固定资产:eg05bj51';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.othr_not_cash_ivs is '（不涉及现金收支的投资和筹资活动科目下）其他:eg05bj52';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cash_endofprdbal is '现金的期末余额:eg05bj53';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cash_bgnprdbal is '现金的期初余额:eg05bj54';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cash_eqv_endofprdbal is '现金等价物的期末余额:eg05bj55';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.cash_eqv_bgnprdbal is '现金等价物的期初余额:eg05bj56';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.csheqv_ntic_add_amt is '现金及现金等价物净增加额:eg05bj57';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_cashinfoinf2002.etl_timestamp is 'ETL处理时间戳';
