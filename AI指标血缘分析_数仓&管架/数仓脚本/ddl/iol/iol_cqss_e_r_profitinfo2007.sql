/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_profitinfo2007
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_profitinfo2007
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_profitinfo2007 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_profitinfo2007(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,oprg_incm number(38,0) -- 营业收入:eg04bj01
    ,oprg_cost number(38,0) -- 营业成本:eg04bj02
    ,btschrg number(38,0) -- 营业税金及附加:eg04bj03
    ,sale_eps number(38,0) -- 销售费用:eg04bj04
    ,mtex number(38,0) -- 管理费用:eg04bj05
    ,fncex number(38,0) -- 财务费用:eg04bj06
    ,ammls number(38,0) -- 资产减值损失:eg04bj07
    ,frval_chg_ntincm number(38,0) -- 公允价值变动净收益:eg04bj08
    ,ivs_netincm number(38,0) -- 投资净收益:eg04bj09
    ,ascent_jnvnts_ivs_pft number(38,0) -- 对联营企业和合营企业的投资收益:eg04bj10
    ,oprg_pft number(38,0) -- 营业利润:eg04bj11
    ,nonoprgincm number(38,0) -- 营业外收入:eg04bj12
    ,nopex number(38,0) -- 营业外支出:eg04bj13
    ,non_lqud_ast_loss number(38,0) -- 非流动资产损失（其中：非流动资产处置损失）:eg04bj14
    ,pft_tamt number(38,0) -- 利润总额:eg04bj15
    ,incmtax_eps number(38,0) -- 所得税费用:eg04bj16
    ,net_pft number(38,0) -- 净利润:eg04bj17
    ,bsc_eps number(38,0) -- 基本每股收益:eg04bj18
    ,dut_eps number(38,0) -- 稀释每股收益:eg04bj19
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
grant select on ${iol_schema}.cqss_e_r_profitinfo2007 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2007 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2007 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_profitinfo2007 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_profitinfo2007 is '企业利润及利润分配表（2007 版）信息表';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.oprg_incm is '营业收入:eg04bj01';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.oprg_cost is '营业成本:eg04bj02';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.btschrg is '营业税金及附加:eg04bj03';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.sale_eps is '销售费用:eg04bj04';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.mtex is '管理费用:eg04bj05';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.fncex is '财务费用:eg04bj06';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.ammls is '资产减值损失:eg04bj07';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.frval_chg_ntincm is '公允价值变动净收益:eg04bj08';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.ivs_netincm is '投资净收益:eg04bj09';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.ascent_jnvnts_ivs_pft is '对联营企业和合营企业的投资收益:eg04bj10';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.oprg_pft is '营业利润:eg04bj11';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.nonoprgincm is '营业外收入:eg04bj12';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.nopex is '营业外支出:eg04bj13';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.non_lqud_ast_loss is '非流动资产损失（其中：非流动资产处置损失）:eg04bj14';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.pft_tamt is '利润总额:eg04bj15';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.incmtax_eps is '所得税费用:eg04bj16';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.net_pft is '净利润:eg04bj17';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.bsc_eps is '基本每股收益:eg04bj18';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.dut_eps is '稀释每股收益:eg04bj19';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_profitinfo2007.etl_timestamp is 'ETL处理时间戳';
