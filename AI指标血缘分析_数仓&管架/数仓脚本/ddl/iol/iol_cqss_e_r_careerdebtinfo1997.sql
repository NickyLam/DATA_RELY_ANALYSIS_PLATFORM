/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_careerdebtinfo1997
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_careerdebtinfo1997
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_careerdebtinfo1997 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_careerdebtinfo1997(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,cash number(38,0) -- 现金:eg07bj01
    ,bk_dp number(38,0) -- 银行存款:eg07bj02
    ,rcvb_bl number(38,0) -- 应收票据:eg07bj03
    ,rcvb number(38,0) -- 应收账款:eg07bj04
    ,prpy_accval number(38,0) -- 预付账款:eg07bj05
    ,othr_rv number(38,0) -- 其他应收款:eg07bj06
    ,mtrl number(38,0) -- 材料:eg07bj07
    ,fsh_prdt number(38,0) -- 产成品:eg07bj08
    ,ext_ivs number(38,0) -- 对外投资:eg07bj09
    ,fix_ast number(38,0) -- 固定资产:eg07bj10
    ,intgbl_ast number(38,0) -- 无形资产:eg07bj11
    ,ast_tot number(38,0) -- 资产合计:eg07bj12
    ,out_fee number(38,0) -- 拨出经费:eg07bj13
    ,out_spclfnd number(38,0) -- 拨出专款:eg07bj14
    ,spclfnd_expn number(38,0) -- 专款支出:eg07bj15
    ,crer_expn number(38,0) -- 事业支出:eg07bj16
    ,oprt_expn number(38,0) -- 经营支出:eg07bj17
    ,cost_eps number(38,0) -- 成本费用:eg07bj18
    ,sale_tax number(38,0) -- 销售税金:eg07bj19
    ,tnov_supr_expn number(38,0) -- 上缴上级支出:eg07bj20
    ,to_aflt_unit_alwc number(38,0) -- 对附属单位补助:eg07bj21
    ,crrov_slfnc_nfrstr number(38,0) -- 结转自筹基建:eg07bj22
    ,expn_tot number(38,0) -- 支出合计:eg07bj23
    ,ast_dt_cgy_tot number(38,0) -- 资产部类总计:eg07bj24
    ,dbt_fud number(38,0) -- 借记款项:eg07bj25
    ,pbl_bl number(38,0) -- 应付票据:eg07bj26
    ,pbl_accval number(38,0) -- 应付账款:eg07bj27
    ,riav_accval number(38,0) -- 预收账款:eg07bj28
    ,otpl number(38,0) -- 其他应付款:eg07bj29
    ,pbl_bdgt_amt number(38,0) -- 应缴预算款:eg07bj30
    ,pbl_fnc_spclacc_amt number(38,0) -- 应缴财政专户款:eg07bj31
    ,acrtax number(38,0) -- 应交税金:eg07bj32
    ,lby_tot number(38,0) -- 负债合计:eg07bj33
    ,crer_fnd number(38,0) -- 事业基金:eg07bj34
    ,com_fnd number(38,0) -- 一般基金:eg07bj35
    ,ivs_fnd number(38,0) -- 投资基金:eg07bj36
    ,fix_fnd number(38,0) -- 固定基金:eg07bj37
    ,spclpps_fnd number(38,0) -- 专用基金:eg07bj38
    ,crer_srpls number(38,0) -- 事业结余:eg07bj39
    ,oprt_srpls number(38,0) -- 经营结余:eg07bj40
    ,netast_tot number(38,0) -- 净资产合计:eg07bj41
    ,fnc_alwc_incm number(38,0) -- 财政补助收入:eg07bj42
    ,supr_alwc_incm number(38,0) -- 上级补助收入:eg07bj43
    ,into_spclfnd number(38,0) -- 拨入专款:eg07bj44
    ,crer_incm number(38,0) -- 事业收入:eg07bj45
    ,oprt_incm number(38,0) -- 经营收入:eg07bj46
    ,aflt_unit_pym number(38,0) -- 附属单位缴款:eg07bj47
    ,othr_icm number(38,0) -- 其他收入:eg07bj48
    ,incm_tot number(38,0) -- 收入合计:eg07bj49
    ,lby_dt_cgy_tot number(38,0) -- 负债部类总计:eg07bj50
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
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo1997 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo1997 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo1997 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_careerdebtinfo1997 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_careerdebtinfo1997 is '事业单位资产负债表（1997 版）信息表';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.cash is '现金:eg07bj01';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.bk_dp is '银行存款:eg07bj02';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.rcvb_bl is '应收票据:eg07bj03';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.rcvb is '应收账款:eg07bj04';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.prpy_accval is '预付账款:eg07bj05';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.othr_rv is '其他应收款:eg07bj06';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.mtrl is '材料:eg07bj07';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.fsh_prdt is '产成品:eg07bj08';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.ext_ivs is '对外投资:eg07bj09';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.fix_ast is '固定资产:eg07bj10';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.intgbl_ast is '无形资产:eg07bj11';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.ast_tot is '资产合计:eg07bj12';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.out_fee is '拨出经费:eg07bj13';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.out_spclfnd is '拨出专款:eg07bj14';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.spclfnd_expn is '专款支出:eg07bj15';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crer_expn is '事业支出:eg07bj16';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.oprt_expn is '经营支出:eg07bj17';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.cost_eps is '成本费用:eg07bj18';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.sale_tax is '销售税金:eg07bj19';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.tnov_supr_expn is '上缴上级支出:eg07bj20';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.to_aflt_unit_alwc is '对附属单位补助:eg07bj21';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crrov_slfnc_nfrstr is '结转自筹基建:eg07bj22';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.expn_tot is '支出合计:eg07bj23';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.ast_dt_cgy_tot is '资产部类总计:eg07bj24';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.dbt_fud is '借记款项:eg07bj25';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.pbl_bl is '应付票据:eg07bj26';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.pbl_accval is '应付账款:eg07bj27';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.riav_accval is '预收账款:eg07bj28';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.otpl is '其他应付款:eg07bj29';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.pbl_bdgt_amt is '应缴预算款:eg07bj30';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.pbl_fnc_spclacc_amt is '应缴财政专户款:eg07bj31';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.acrtax is '应交税金:eg07bj32';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.lby_tot is '负债合计:eg07bj33';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crer_fnd is '事业基金:eg07bj34';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.com_fnd is '一般基金:eg07bj35';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.ivs_fnd is '投资基金:eg07bj36';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.fix_fnd is '固定基金:eg07bj37';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.spclpps_fnd is '专用基金:eg07bj38';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crer_srpls is '事业结余:eg07bj39';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.oprt_srpls is '经营结余:eg07bj40';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.netast_tot is '净资产合计:eg07bj41';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.fnc_alwc_incm is '财政补助收入:eg07bj42';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.supr_alwc_incm is '上级补助收入:eg07bj43';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.into_spclfnd is '拨入专款:eg07bj44';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crer_incm is '事业收入:eg07bj45';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.oprt_incm is '经营收入:eg07bj46';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.aflt_unit_pym is '附属单位缴款:eg07bj47';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.othr_icm is '其他收入:eg07bj48';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.incm_tot is '收入合计:eg07bj49';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.lby_dt_cgy_tot is '负债部类总计:eg07bj50';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_careerdebtinfo1997.etl_timestamp is 'ETL处理时间戳';
