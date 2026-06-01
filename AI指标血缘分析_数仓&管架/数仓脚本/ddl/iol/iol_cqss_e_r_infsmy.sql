/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_infsmy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_infsmy
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_infsmy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_infsmy(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,ftm_ext_crln_txn_s_yr varchar2(6) -- 首次有信贷交易的年份:eb01ar01
    ,ftmextrelrepyrspls_yr varchar2(6) -- 首次有相关还款责任的年份:eb01ar02
    ,hpncrlntxn_s_inst_num number(22) -- 发生信贷交易的机构数:eb01as01
    ,crnotclsg_ln_inst_num number(22) -- 征信未结清贷款机构数（当前有未结清信贷交易的机构数）:eb01as02
    ,dbtcr_txn_bal number(38,0) -- 借贷交易余额:eb01aj01
    ,berec_s_dbtcr_txn_bal number(38,0) -- 被追偿的借贷交易余额:eb01aj02
    ,fcs_cgy_dbtcr_txn_bal number(38,0) -- 关注类借贷交易余额:eb01aj03
    ,bad_cgy_dbtcr_txn_bal number(38,0) -- 不良类借贷交易余额:eb01aj04
    ,wrnt_txn_bal_bal number(38,0) -- 担保交易余额余额:eb01aj05
    ,fcs_cgy_wrnt_txn_bal number(38,0) -- 关注类担保交易余额:eb01aj06
    ,bad_cgy_wrnt_txn_bal number(38,0) -- 不良类担保交易余额:eb01aj07
    ,noncr_tnac_num number(22) -- 非信贷交易账户数:eb01bs01
    ,ow_tax_rcrd_num number(22) -- 欠税记录条数:eb01bs02
    ,cvl_jdgmt_rcrd_num number(22) -- 民事判决记录条数:eb01bs03
    ,efrcexe_rcrd_num number(22) -- 强制执行记录条数:eb01bs04
    ,admn_pnsh_rcrd_num number(22) -- 行政处罚记录条数:eb01bs05
    ,notclsgwrttclsentrnum number(22) -- 未结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):eb03as01
    ,alrdyclsgwtclsentrnum number(22) -- 已结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):eb03bs01
    ,dbtcrtxnrelrrspltpnum number(22) -- 借贷交易相关还款责任类型数量:eb05as01
    ,wrnttxnrelryrspltpnum number(22) -- 担保交易相关还款责任类型数量:eb05bs01
    ,hist_lby_mo_num number(22) -- 历史负债月份数(月份数):eb02cs01
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
grant select on ${iol_schema}.cqss_e_r_infsmy to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_infsmy to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_infsmy to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_infsmy to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_infsmy is '信息概要';
comment on column ${iol_schema}.cqss_e_r_infsmy.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_infsmy.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_infsmy.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_infsmy.ftm_ext_crln_txn_s_yr is '首次有信贷交易的年份:eb01ar01';
comment on column ${iol_schema}.cqss_e_r_infsmy.ftmextrelrepyrspls_yr is '首次有相关还款责任的年份:eb01ar02';
comment on column ${iol_schema}.cqss_e_r_infsmy.hpncrlntxn_s_inst_num is '发生信贷交易的机构数:eb01as01';
comment on column ${iol_schema}.cqss_e_r_infsmy.crnotclsg_ln_inst_num is '征信未结清贷款机构数（当前有未结清信贷交易的机构数）:eb01as02';
comment on column ${iol_schema}.cqss_e_r_infsmy.dbtcr_txn_bal is '借贷交易余额:eb01aj01';
comment on column ${iol_schema}.cqss_e_r_infsmy.berec_s_dbtcr_txn_bal is '被追偿的借贷交易余额:eb01aj02';
comment on column ${iol_schema}.cqss_e_r_infsmy.fcs_cgy_dbtcr_txn_bal is '关注类借贷交易余额:eb01aj03';
comment on column ${iol_schema}.cqss_e_r_infsmy.bad_cgy_dbtcr_txn_bal is '不良类借贷交易余额:eb01aj04';
comment on column ${iol_schema}.cqss_e_r_infsmy.wrnt_txn_bal_bal is '担保交易余额余额:eb01aj05';
comment on column ${iol_schema}.cqss_e_r_infsmy.fcs_cgy_wrnt_txn_bal is '关注类担保交易余额:eb01aj06';
comment on column ${iol_schema}.cqss_e_r_infsmy.bad_cgy_wrnt_txn_bal is '不良类担保交易余额:eb01aj07';
comment on column ${iol_schema}.cqss_e_r_infsmy.noncr_tnac_num is '非信贷交易账户数:eb01bs01';
comment on column ${iol_schema}.cqss_e_r_infsmy.ow_tax_rcrd_num is '欠税记录条数:eb01bs02';
comment on column ${iol_schema}.cqss_e_r_infsmy.cvl_jdgmt_rcrd_num is '民事判决记录条数:eb01bs03';
comment on column ${iol_schema}.cqss_e_r_infsmy.efrcexe_rcrd_num is '强制执行记录条数:eb01bs04';
comment on column ${iol_schema}.cqss_e_r_infsmy.admn_pnsh_rcrd_num is '行政处罚记录条数:eb01bs05';
comment on column ${iol_schema}.cqss_e_r_infsmy.notclsgwrttclsentrnum is '未结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):eb03as01';
comment on column ${iol_schema}.cqss_e_r_infsmy.alrdyclsgwtclsentrnum is '已结清担保交易分类汇总条目数量(担保交易分类汇总条目数量):eb03bs01';
comment on column ${iol_schema}.cqss_e_r_infsmy.dbtcrtxnrelrrspltpnum is '借贷交易相关还款责任类型数量:eb05as01';
comment on column ${iol_schema}.cqss_e_r_infsmy.wrnttxnrelryrspltpnum is '担保交易相关还款责任类型数量:eb05bs01';
comment on column ${iol_schema}.cqss_e_r_infsmy.hist_lby_mo_num is '历史负债月份数(月份数):eb02cs01';
comment on column ${iol_schema}.cqss_e_r_infsmy.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_infsmy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_infsmy.etl_timestamp is 'ETL处理时间戳';
