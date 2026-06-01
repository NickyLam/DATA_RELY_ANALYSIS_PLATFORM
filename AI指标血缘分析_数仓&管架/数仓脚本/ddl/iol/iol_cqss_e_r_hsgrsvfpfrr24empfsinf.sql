/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_hsgrsvfpfrr24empfsinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,stat_yrmo varchar2(11) -- 统计年月:ef05br01
    ,cr_hsgrsvfnd_pyf_stcd varchar2(30) -- 征信住房公积金缴费状态代码(缴费状态):ef05bd01
    ,tm_pbl_amt number(38,0) -- 本月应缴金额:ef05bj01
    ,tm_rl_py_amt number(38,0) -- 本月实缴金额:ef05bj02
    ,acm_ow_amt number(38,0) -- 累计欠费金额:ef05bj03
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
grant select on ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf is '住房公积金缴费记录过去24个月缴费情况信息';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.stat_yrmo is '统计年月:ef05br01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.cr_hsgrsvfnd_pyf_stcd is '征信住房公积金缴费状态代码(缴费状态):ef05bd01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.tm_pbl_amt is '本月应缴金额:ef05bj01';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.tm_rl_py_amt is '本月实缴金额:ef05bj02';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.acm_ow_amt is '累计欠费金额:ef05bj03';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_hsgrsvfpfrr24empfsinf.etl_timestamp is 'ETL处理时间戳';
