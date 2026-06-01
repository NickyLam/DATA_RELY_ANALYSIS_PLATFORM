/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_pyfacc24esmpyfsttninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,stat_yrmo varchar2(11) -- 统计年月:ee01br01
    ,pblc_crer_pyf_st varchar2(2) -- 公用事业缴费状态(缴费状态):ee01bd01
    ,tm_pbl_amt number(38,0) -- 本月应缴金额:ee01bj01
    ,tm_rl_py_amt number(38,0) -- 本月实缴金额:ee01bj02
    ,acm_ow_amt number(38,0) -- 累计欠费金额:ee01bj03
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
grant select on ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf is '缴费账户过去24个月缴费情况信息';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.stat_yrmo is '统计年月:ee01br01';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.pblc_crer_pyf_st is '公用事业缴费状态(缴费状态):ee01bd01';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.tm_pbl_amt is '本月应缴金额:ee01bj01';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.tm_rl_py_amt is '本月实缴金额:ee01bj02';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.acm_ow_amt is '累计欠费金额:ee01bj03';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_pyfacc24esmpyfsttninf.etl_timestamp is 'ETL处理时间戳';
