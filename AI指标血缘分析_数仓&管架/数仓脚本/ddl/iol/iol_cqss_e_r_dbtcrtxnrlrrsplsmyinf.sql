/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_dbtcrtxnrlrrsplsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,rel_repy_rspl_tp varchar2(9) -- 相关还款责任类型:eb05ad01
    ,berecaccsrepyrspl_qot number(38,0) -- 被追偿账户的还款责任限额:eb05aj01
    ,be_rec_acc_tot number(22) -- 被追偿账户数合计:eb05as02
    ,be_rec_bal_tot number(38,0) -- 被追偿余额合计:eb05aj02
    ,othrdbtcrtrepyrsplqot number(38,0) -- 其他借贷交易的还款责任限额:eb05aj03
    ,othr_dbtcr_tnac_num number(22) -- 其他借贷交易账户数:eb05as03
    ,othr_dbtcr_tnac_bal number(38,0) -- 其他借贷交易账户余额:eb05aj04
    ,othrdbtcrtnafcscgybal number(38,0) -- 其他借贷交易账户关注类余额:eb05aj05
    ,othrdbtcrtnabadcgybal number(38,0) -- 其他借贷交易账户不良类余额:eb05aj06
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
grant select on ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf is '借贷交易相关还款责任汇总信息';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.rel_repy_rspl_tp is '相关还款责任类型:eb05ad01';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.berecaccsrepyrspl_qot is '被追偿账户的还款责任限额:eb05aj01';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.be_rec_acc_tot is '被追偿账户数合计:eb05as02';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.be_rec_bal_tot is '被追偿余额合计:eb05aj02';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.othrdbtcrtrepyrsplqot is '其他借贷交易的还款责任限额:eb05aj03';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.othr_dbtcr_tnac_num is '其他借贷交易账户数:eb05as03';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.othr_dbtcr_tnac_bal is '其他借贷交易账户余额:eb05aj04';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.othrdbtcrtnafcscgybal is '其他借贷交易账户关注类余额:eb05aj05';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.othrdbtcrtnabadcgybal is '其他借贷交易账户不良类余额:eb05aj06';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_dbtcrtxnrlrrsplsmyinf.etl_timestamp is 'ETL处理时间戳';
