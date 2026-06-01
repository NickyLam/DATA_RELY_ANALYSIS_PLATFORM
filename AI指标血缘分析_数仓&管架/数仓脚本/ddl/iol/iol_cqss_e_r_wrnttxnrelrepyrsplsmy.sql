/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_wrnttxnrelrepyrsplsmy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,rel_repy_rspl_tp varchar2(9) -- 相关还款责任类型(责任类型):eb05bd01
    ,repy_rspl_qot number(38,0) -- 还款责任限额:eb05bj01
    ,acc_num number(22) -- 账户数:eb05bs02
    ,bal number(38,0) -- 余额:eb05bj02
    ,fcs_cgy_bal number(38,0) -- 关注类余额:eb05bj03
    ,bad_cgy_bal number(38,0) -- 不良类余额:eb05bj04
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
grant select on ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy is '担保交易相关还款责任汇总信息';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.rel_repy_rspl_tp is '相关还款责任类型(责任类型):eb05bd01';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.repy_rspl_qot is '还款责任限额:eb05bj01';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.acc_num is '账户数:eb05bs02';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.bal is '余额:eb05bj02';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.fcs_cgy_bal is '关注类余额:eb05bj03';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.bad_cgy_bal is '不良类余额:eb05bj04';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_wrnttxnrelrepyrsplsmy.etl_timestamp is 'ETL处理时间戳';
