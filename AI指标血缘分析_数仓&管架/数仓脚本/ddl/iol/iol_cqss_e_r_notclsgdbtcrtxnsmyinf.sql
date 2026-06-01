/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_notclsgdbtcrtxnsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(75) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,astdsp_bsn_acc number(22) -- 资产处置业务账户数:eb02as01
    ,astdsp_bsn_bal number(38,0) -- 资产处置业务余额:eb02aj01
    ,rctly_oc_displ_dt date -- 最近一次处置日期:eb02ar01
    ,adcsh_bsn_acc number(22) -- 垫款业务账户数:eb02as02
    ,adcsh_bsn_bal number(38,0) -- 垫款业务余额:eb02aj02
    ,adcshrctlyocrepydyprd date -- 垫款最近一次还款日期:eb02ar02
    ,cur_odue_tamt number(38,0) -- 当前逾期总额(逾期总额):eb02aj03
    ,cur_odue_pnp number(38,0) -- 当前逾期本金(逾期本金):eb02aj04
    ,odin_adoth number(38,0) -- 逾期利息及其他:eb02aj05
    ,othrdbtcrtclsyentrnum number(22) -- 其他借贷交易分类汇总条目数量:eb02as03
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
grant select on ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf is '未结清借贷交易汇总信息';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.astdsp_bsn_acc is '资产处置业务账户数:eb02as01';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.astdsp_bsn_bal is '资产处置业务余额:eb02aj01';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.rctly_oc_displ_dt is '最近一次处置日期:eb02ar01';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.adcsh_bsn_acc is '垫款业务账户数:eb02as02';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.adcsh_bsn_bal is '垫款业务余额:eb02aj02';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.adcshrctlyocrepydyprd is '垫款最近一次还款日期:eb02ar02';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.cur_odue_tamt is '当前逾期总额(逾期总额):eb02aj03';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.cur_odue_pnp is '当前逾期本金(逾期本金):eb02aj04';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.odin_adoth is '逾期利息及其他:eb02aj05';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.othrdbtcrtclsyentrnum is '其他借贷交易分类汇总条目数量:eb02as03';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_notclsgdbtcrtxnsmyinf.etl_timestamp is 'ETL处理时间戳';
