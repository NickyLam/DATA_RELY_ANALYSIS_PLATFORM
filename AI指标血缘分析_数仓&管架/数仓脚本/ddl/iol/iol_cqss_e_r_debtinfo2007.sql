/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_debtinfo2007
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_debtinfo2007
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_debtinfo2007 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_debtinfo2007(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,ccy_fnds number(38,0) -- 货币资金:eg02bj01
    ,tdfnast number(38,0) -- 交易性金融资产:eg02bj02
    ,rcvb_bl number(38,0) -- 应收票据:eg02bj03
    ,rcvb number(38,0) -- 应收账款:eg02bj04
    ,prpy_accval number(38,0) -- 预付账款:eg02bj05
    ,recint number(38,0) -- 应收利息:eg02bj06
    ,rbdn number(38,0) -- 应收股利:eg02bj07
    ,ohrv number(38,0) -- 其他应收款:eg02bj08
    ,ivnt number(38,0) -- 存货:eg02bj09
    ,in1yr_exps_non_lqud_ast number(38,0) -- 一年内到期的非流动资产:eg02bj10
    ,othr_lqud_ast number(38,0) -- 其他流动资产:eg02bj11
    ,lqud_ast_tot number(38,0) -- 流动资产合计:eg02bj12
    ,csls_fast number(38,0) -- 可供出售的金融资产:eg02bj13
    ,heldtmatinvm number(38,0) -- 持有至到期投资:eg02bj14
    ,ltmeyis number(38,0) -- 长期股权投资:eg02bj15
    ,longtrm_rcvb number(38,0) -- 长期应收款:eg02bj16
    ,ivs_prp_rlest number(38,0) -- 投资性房地产:eg02bj17
    ,fix_ast number(38,0) -- 固定资产:eg02bj18
    ,ucpt number(38,0) -- 在建工程:eg02bj19
    ,prj_dnc number(38,0) -- 工程物资:eg02bj20
    ,fix_atcln number(38,0) -- 固定资产清理:eg02bj21
    ,pd_prp_blgc_ast number(38,0) -- 生产性生物资产:eg02bj22
    ,oil_ast number(38,0) -- 油气资产:eg02bj23
    ,intgbl_ast number(38,0) -- 无形资产:eg02bj24
    ,dvlp_expn number(38,0) -- 开发支出:eg02bj25
    ,gdwl number(38,0) -- 商誉:eg02bj26
    ,longtrm_ppdex number(38,0) -- 长期待摊费用:eg02bj27
    ,dfr_incmtax_ast number(38,0) -- 递延所得税资产:eg02bj28
    ,othr_non_lqud_ast number(38,0) -- 其他非流动资产:eg02bj29
    ,non_lqud_ast_tot number(38,0) -- 非流动资产合计:eg02bj30
    ,ast_tot number(38,0) -- 资产总计:eg02bj31
    ,shrttm_lnd number(38,0) -- 短期借款:eg02bj32
    ,fncastheldforlby number(38,0) -- 交易性金融负债:eg02bj33
    ,pbl_bl number(38,0) -- 应付票据:eg02bj34
    ,pbl_accval number(38,0) -- 应付账款:eg02bj35
    ,riav_accval number(38,0) -- 预收账款:eg02bj36
    ,plit number(38,0) -- 应付利息:eg02bj37
    ,empewageexpn number(38,0) -- 应付职工薪酬:eg02bj38
    ,ptxf number(38,0) -- 应交税费:eg02bj39
    ,pbl_dvdn number(38,0) -- 应付股利:eg02bj40
    ,othr_pl number(38,0) -- 其他应付款:eg02bj41
    ,in1yr_exps_non_lqud_lby number(38,0) -- 一年内到期的非流动负债:eg02bj42
    ,othr_lqud_lby number(38,0) -- 其他流动负债:eg02bj43
    ,lqud_lby_tot number(38,0) -- 流动负债合计:eg02bj44
    ,longtrm_lnd number(38,0) -- 长期借款:eg02bj45
    ,pbl_bond number(38,0) -- 应付债券:eg02bj46
    ,longtrm_pybl number(38,0) -- 长期应付款:eg02bj47
    ,spcl_pybl number(38,0) -- 专项应付款:eg02bj48
    ,frcst_lby number(38,0) -- 预计负债:eg02bj49
    ,dfr_incmtax_lby number(38,0) -- 递延所得税负债:eg02bj50
    ,othr_non_lqud_lby number(38,0) -- 其他非流动负债:eg02bj51
    ,non_lqud_lby_tot number(38,0) -- 非流动负债合计:eg02bj52
    ,lby_tot number(38,0) -- 负债合计:eg02bj53
    ,arcptl number(38,0) -- 实收资本（或股本）:eg02bj54
    ,cptrsv number(38,0) -- 资本公积:eg02bj55
    ,sub_trrstk number(38,0) -- 减：库存股:eg02bj56
    ,splrsv number(38,0) -- 盈余公积:eg02bj57
    ,uspt number(38,0) -- 未分配利润:eg02bj58
    ,owr_rght_tot number(38,0) -- 所有者权益合计:eg02bj59
    ,lby_and_owr_rght_tot number(38,0) -- 负债和所有者权益合计:eg02bj60
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
grant select on ${iol_schema}.cqss_e_r_debtinfo2007 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2007 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2007 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_debtinfo2007 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_debtinfo2007 is '企业资产负债表（2007 版）信息表';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ccy_fnds is '货币资金:eg02bj01';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.tdfnast is '交易性金融资产:eg02bj02';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.rcvb_bl is '应收票据:eg02bj03';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.rcvb is '应收账款:eg02bj04';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.prpy_accval is '预付账款:eg02bj05';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.recint is '应收利息:eg02bj06';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.rbdn is '应收股利:eg02bj07';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ohrv is '其他应收款:eg02bj08';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ivnt is '存货:eg02bj09';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.in1yr_exps_non_lqud_ast is '一年内到期的非流动资产:eg02bj10';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.othr_lqud_ast is '其他流动资产:eg02bj11';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.lqud_ast_tot is '流动资产合计:eg02bj12';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.csls_fast is '可供出售的金融资产:eg02bj13';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.heldtmatinvm is '持有至到期投资:eg02bj14';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ltmeyis is '长期股权投资:eg02bj15';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.longtrm_rcvb is '长期应收款:eg02bj16';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ivs_prp_rlest is '投资性房地产:eg02bj17';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.fix_ast is '固定资产:eg02bj18';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ucpt is '在建工程:eg02bj19';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.prj_dnc is '工程物资:eg02bj20';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.fix_atcln is '固定资产清理:eg02bj21';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.pd_prp_blgc_ast is '生产性生物资产:eg02bj22';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.oil_ast is '油气资产:eg02bj23';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.intgbl_ast is '无形资产:eg02bj24';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.dvlp_expn is '开发支出:eg02bj25';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.gdwl is '商誉:eg02bj26';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.longtrm_ppdex is '长期待摊费用:eg02bj27';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.dfr_incmtax_ast is '递延所得税资产:eg02bj28';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.othr_non_lqud_ast is '其他非流动资产:eg02bj29';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.non_lqud_ast_tot is '非流动资产合计:eg02bj30';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ast_tot is '资产总计:eg02bj31';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.shrttm_lnd is '短期借款:eg02bj32';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.fncastheldforlby is '交易性金融负债:eg02bj33';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.pbl_bl is '应付票据:eg02bj34';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.pbl_accval is '应付账款:eg02bj35';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.riav_accval is '预收账款:eg02bj36';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.plit is '应付利息:eg02bj37';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.empewageexpn is '应付职工薪酬:eg02bj38';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.ptxf is '应交税费:eg02bj39';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.pbl_dvdn is '应付股利:eg02bj40';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.othr_pl is '其他应付款:eg02bj41';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.in1yr_exps_non_lqud_lby is '一年内到期的非流动负债:eg02bj42';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.othr_lqud_lby is '其他流动负债:eg02bj43';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.lqud_lby_tot is '流动负债合计:eg02bj44';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.longtrm_lnd is '长期借款:eg02bj45';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.pbl_bond is '应付债券:eg02bj46';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.longtrm_pybl is '长期应付款:eg02bj47';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.spcl_pybl is '专项应付款:eg02bj48';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.frcst_lby is '预计负债:eg02bj49';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.dfr_incmtax_lby is '递延所得税负债:eg02bj50';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.othr_non_lqud_lby is '其他非流动负债:eg02bj51';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.non_lqud_lby_tot is '非流动负债合计:eg02bj52';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.lby_tot is '负债合计:eg02bj53';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.arcptl is '实收资本（或股本）:eg02bj54';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.cptrsv is '资本公积:eg02bj55';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.sub_trrstk is '减：库存股:eg02bj56';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.splrsv is '盈余公积:eg02bj57';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.uspt is '未分配利润:eg02bj58';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.owr_rght_tot is '所有者权益合计:eg02bj59';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.lby_and_owr_rght_tot is '负债和所有者权益合计:eg02bj60';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_debtinfo2007.etl_timestamp is 'ETL处理时间戳';
