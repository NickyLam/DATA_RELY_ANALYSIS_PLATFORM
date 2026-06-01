/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_careerinexinfo1997
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_careerinexinfo1997
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_careerinexinfo1997 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_careerinexinfo1997(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,fnc_alwc_incm number(38,0) -- 财政补助收入:eg09bj01
    ,supr_alwc_incm number(38,0) -- 上级补助收入:eg09bj02
    ,aflt_unit_pym number(38,0) -- 附属单位缴款:eg09bj03
    ,crer_incm number(38,0) -- 事业收入:eg09bj04
    ,bdgt_frgncptl_gld_incm number(38,0) -- 预算外资金收入:eg09bj05
    ,oicm number(38,0) -- 其他收入:eg09bj06
    ,crer_incm_sbtl number(38,0) -- 事业收入小计:eg09bj07
    ,oprt_incm number(38,0) -- 经营收入:eg09bj08
    ,oprt_incm_sbtl number(38,0) -- 经营收入小计:eg09bj09
    ,into_spclfnd number(38,0) -- 拨入专款:eg09bj10
    ,into_spclfnd_sbtl number(38,0) -- 拨入专款小计:eg09bj11
    ,incm_tot number(38,0) -- 收入总计:eg09bj12
    ,out_fee number(38,0) -- 拨出经费:eg09bj13
    ,tnov_supr_expn number(38,0) -- 上缴上级支出:eg09bj14
    ,to_aflt_unit_alwc number(38,0) -- 对附属单位补助:eg09bj15
    ,crer_expn number(38,0) -- 事业支出:eg09bj16
    ,fnc_alwc_expn number(38,0) -- 财政补助支出:eg09bj17
    ,bdgt_frgncptl_gld_expn number(38,0) -- 预算外资金支出:eg09bj18
    ,crer_sale_tax number(38,0) -- 销售税金:eg09bj19
    ,crrov_slfnc_nfrstr number(38,0) -- 结转自筹基建:eg09bj20
    ,crer_expn_sbtl number(38,0) -- 事业支出小计:eg09bj21
    ,oprt_expn number(38,0) -- 经营支出:eg09bj22
    ,oprt_sale_tax number(38,0) -- 销售税金:eg09bj23
    ,oprt_expn_sbtl number(38,0) -- 经营支出小计:eg09bj24
    ,out_spclfnd number(38,0) -- 拨出专款:eg09bj25
    ,spclfnd_expn number(38,0) -- 专款支出:eg09bj26
    ,spclfnd_sbtl number(38,0) -- 专款小计:eg09bj27
    ,expn_tot number(38,0) -- 支出总计:eg09bj28
    ,crer_srpls number(38,0) -- 事业结余:eg09bj29
    ,rglr_incm_srpls number(38,0) -- 正常收入结余:eg09bj30
    ,wd_awla_bfr_crer_expn number(38,0) -- 收回以前年度事业支出:eg09bj31
    ,oprt_srpls number(38,0) -- 经营结余:eg09bj32
    ,awla_bfr_oprt_loss number(38,0) -- 以前年度经营亏损:eg09bj33
    ,srpls_alct number(38,0) -- 结余分配:eg09bj34
    ,pymt_incmtax number(38,0) -- 应交所得税:eg09bj35
    ,rtrv_spclpps_fnd number(38,0) -- 提取专用基金:eg09bj36
    ,tfrin_crer_fnd number(38,0) -- 转入事业基金:eg09bj37
    ,othr_srpls_alct number(38,0) -- 其他结余分配:eg09bj38
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
grant select on ${iol_schema}.cqss_e_r_careerinexinfo1997 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo1997 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo1997 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo1997 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_careerinexinfo1997 is '事业单位收入支出表（1997 版）信息表';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.fnc_alwc_incm is '财政补助收入:eg09bj01';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.supr_alwc_incm is '上级补助收入:eg09bj02';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.aflt_unit_pym is '附属单位缴款:eg09bj03';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_incm is '事业收入:eg09bj04';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.bdgt_frgncptl_gld_incm is '预算外资金收入:eg09bj05';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oicm is '其他收入:eg09bj06';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_incm_sbtl is '事业收入小计:eg09bj07';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_incm is '经营收入:eg09bj08';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_incm_sbtl is '经营收入小计:eg09bj09';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.into_spclfnd is '拨入专款:eg09bj10';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.into_spclfnd_sbtl is '拨入专款小计:eg09bj11';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.incm_tot is '收入总计:eg09bj12';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.out_fee is '拨出经费:eg09bj13';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.tnov_supr_expn is '上缴上级支出:eg09bj14';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.to_aflt_unit_alwc is '对附属单位补助:eg09bj15';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_expn is '事业支出:eg09bj16';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.fnc_alwc_expn is '财政补助支出:eg09bj17';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.bdgt_frgncptl_gld_expn is '预算外资金支出:eg09bj18';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_sale_tax is '销售税金:eg09bj19';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crrov_slfnc_nfrstr is '结转自筹基建:eg09bj20';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_expn_sbtl is '事业支出小计:eg09bj21';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_expn is '经营支出:eg09bj22';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_sale_tax is '销售税金:eg09bj23';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_expn_sbtl is '经营支出小计:eg09bj24';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.out_spclfnd is '拨出专款:eg09bj25';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.spclfnd_expn is '专款支出:eg09bj26';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.spclfnd_sbtl is '专款小计:eg09bj27';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.expn_tot is '支出总计:eg09bj28';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crer_srpls is '事业结余:eg09bj29';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.rglr_incm_srpls is '正常收入结余:eg09bj30';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.wd_awla_bfr_crer_expn is '收回以前年度事业支出:eg09bj31';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.oprt_srpls is '经营结余:eg09bj32';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.awla_bfr_oprt_loss is '以前年度经营亏损:eg09bj33';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.srpls_alct is '结余分配:eg09bj34';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.pymt_incmtax is '应交所得税:eg09bj35';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.rtrv_spclpps_fnd is '提取专用基金:eg09bj36';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.tfrin_crer_fnd is '转入事业基金:eg09bj37';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.othr_srpls_alct is '其他结余分配:eg09bj38';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo1997.etl_timestamp is 'ETL处理时间戳';
