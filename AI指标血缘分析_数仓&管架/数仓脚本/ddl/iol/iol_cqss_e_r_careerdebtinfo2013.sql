/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_careerdebtinfo2013
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_careerdebtinfo2013
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_careerdebtinfo2013 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_careerdebtinfo2013(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,ccy_fnds number(38,0) -- 货币资金:eg08bj01
    ,shrttm_ivs number(38,0) -- 短期投资:eg08bj02
    ,fnc_shld_ret_lmt number(38,0) -- 财政应返还额度:eg08bj03
    ,rcvb_bl number(38,0) -- 应收票据:eg08bj04
    ,rcvb number(38,0) -- 应收账款:eg08bj05
    ,prpy_accval number(38,0) -- 预付账款:eg08bj06
    ,othr_rv number(38,0) -- 其他应收款:eg08bj07
    ,ivnt number(38,0) -- 存货:eg08bj08
    ,othr_lqud_ast number(38,0) -- 其他流动资产:eg08bj09
    ,lqud_ast_tot number(38,0) -- 流动资产合计:eg08bj10
    ,ltemivs number(38,0) -- 长期投资:eg08bj11
    ,fix_ast number(38,0) -- 固定资产:eg08bj12
    ,fix_ast_ori_prc number(38,0) -- 固定资产原价:eg08bj13
    ,acm_dprcn number(38,0) -- 累计折旧:eg08bj14
    ,ucpt number(38,0) -- 在建工程:eg08bj15
    ,intgbl_ast number(38,0) -- 无形资产:eg08bj16
    ,intgbl_ast_ori_prc number(38,0) -- 无形资产原价:eg08bj17
    ,acm_amrz number(38,0) -- 累计摊销:eg08bj18
    ,to_displ_ast number(38,0) -- 待处置资产损溢:eg08bj19
    ,non_lqud_ast_tot number(38,0) -- 非流动资产合计:eg08bj20
    ,ast_tot number(38,0) -- 资产总计:eg08bj21
    ,shrttm_lnd number(38,0) -- 短期借款:eg08bj22
    ,pbl_taxfee number(38,0) -- 应缴税费:eg08bj23
    ,pbl_trsr_amt number(38,0) -- 应缴国库款:eg08bj24
    ,pbl_fnc_spclacc_amt number(38,0) -- 应缴财政专户款:eg08bj25
    ,empe_wage_expn number(38,0) -- 应付职工薪酬:eg08bj26
    ,pbl_bl number(38,0) -- 应付票据:eg08bj27
    ,pbl_accval number(38,0) -- 应付账款:eg08bj28
    ,riav_accval number(38,0) -- 预收账款:eg08bj29
    ,othr_pl number(38,0) -- 其他应付款:eg08bj30
    ,othr_lqud_lby number(38,0) -- 其他流动负债:eg08bj31
    ,lqud_lby_tot number(38,0) -- 流动负债合计:eg08bj32
    ,longtrm_lnd number(38,0) -- 长期借款:eg08bj33
    ,longtrm_pybl number(38,0) -- 长期应付款:eg08bj34
    ,non_lqud_lby_tot number(38,0) -- 非流动负债合计:eg08bj35
    ,lby_tot number(38,0) -- 负债合计:eg08bj36
    ,crer_fnd number(38,0) -- 事业基金:eg08bj37
    ,non_lqud_ast_fnd number(38,0) -- 非流动资产基金:eg08bj38
    ,spclpps_fnd number(38,0) -- 专用基金:eg08bj39
    ,fnc_alwc_crrov number(38,0) -- 财政补助结转:eg08bj40
    ,fnc_alwc_srpls number(38,0) -- 财政补助结余:eg08bj41
    ,non_fnc_alwc_crrov number(38,0) -- 非财政补助结转:eg08bj42
    ,non_fnc_alwc_srpls number(38,0) -- 非财政补助结余:eg08bj43
    ,crer_srpls number(38,0) -- 事业结余:eg08bj44
    ,oprt_srpls number(38,0) -- 经营结余:eg08bj45
    ,netast_tot number(38,0) -- 净资产合计:eg08bj46
    ,lby_and_netast_tot number(38,0) -- 负债和净资产总计:eg08bj47
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
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo2013 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo2013 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo2013 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo2013 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_careerdebtinfo2013 is '事业单位资产负债表（2013 版）信息表';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.ccy_fnds is '货币资金:eg08bj01';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.shrttm_ivs is '短期投资:eg08bj02';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.fnc_shld_ret_lmt is '财政应返还额度:eg08bj03';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.rcvb_bl is '应收票据:eg08bj04';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.rcvb is '应收账款:eg08bj05';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.prpy_accval is '预付账款:eg08bj06';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.othr_rv is '其他应收款:eg08bj07';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.ivnt is '存货:eg08bj08';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.othr_lqud_ast is '其他流动资产:eg08bj09';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.lqud_ast_tot is '流动资产合计:eg08bj10';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.ltemivs is '长期投资:eg08bj11';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.fix_ast is '固定资产:eg08bj12';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.fix_ast_ori_prc is '固定资产原价:eg08bj13';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.acm_dprcn is '累计折旧:eg08bj14';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.ucpt is '在建工程:eg08bj15';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.intgbl_ast is '无形资产:eg08bj16';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.intgbl_ast_ori_prc is '无形资产原价:eg08bj17';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.acm_amrz is '累计摊销:eg08bj18';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.to_displ_ast is '待处置资产损溢:eg08bj19';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.non_lqud_ast_tot is '非流动资产合计:eg08bj20';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.ast_tot is '资产总计:eg08bj21';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.shrttm_lnd is '短期借款:eg08bj22';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.pbl_taxfee is '应缴税费:eg08bj23';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.pbl_trsr_amt is '应缴国库款:eg08bj24';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.pbl_fnc_spclacc_amt is '应缴财政专户款:eg08bj25';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.empe_wage_expn is '应付职工薪酬:eg08bj26';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.pbl_bl is '应付票据:eg08bj27';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.pbl_accval is '应付账款:eg08bj28';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.riav_accval is '预收账款:eg08bj29';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.othr_pl is '其他应付款:eg08bj30';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.othr_lqud_lby is '其他流动负债:eg08bj31';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.lqud_lby_tot is '流动负债合计:eg08bj32';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.longtrm_lnd is '长期借款:eg08bj33';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.longtrm_pybl is '长期应付款:eg08bj34';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.non_lqud_lby_tot is '非流动负债合计:eg08bj35';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.lby_tot is '负债合计:eg08bj36';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.crer_fnd is '事业基金:eg08bj37';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.non_lqud_ast_fnd is '非流动资产基金:eg08bj38';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.spclpps_fnd is '专用基金:eg08bj39';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.fnc_alwc_crrov is '财政补助结转:eg08bj40';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.fnc_alwc_srpls is '财政补助结余:eg08bj41';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.non_fnc_alwc_crrov is '非财政补助结转:eg08bj42';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.non_fnc_alwc_srpls is '非财政补助结余:eg08bj43';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.crer_srpls is '事业结余:eg08bj44';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.oprt_srpls is '经营结余:eg08bj45';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.netast_tot is '净资产合计:eg08bj46';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.lby_and_netast_tot is '负债和净资产总计:eg08bj47';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo2013.etl_timestamp is 'ETL处理时间戳';
