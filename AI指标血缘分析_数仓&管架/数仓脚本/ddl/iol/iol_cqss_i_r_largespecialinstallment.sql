/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_largespecialinstallment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_largespecialinstallment
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_largespecialinstallment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_largespecialinstallment(
    id varchar2(96) -- 代码主键
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号
    ,msgidno varchar2(53) -- 报文标识号
    ,bigamt_spinstm_lmt number(38,0) -- 大额专项分期额度:pd01hj01
    ,instm_lmt_efdt date -- 分期额度生效日期:pd01hr01
    ,instm_lmt_exdat date -- 分期额度到期日期:pd01hr02
    ,usd_instm_amt number(38,0) -- 已用分期金额:pd01hj02
    ,multi_tenancy_id varchar2(30) -- 多实体标识
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
grant select on ${iol_schema}.cqss_i_r_largespecialinstallment to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_largespecialinstallment to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_largespecialinstallment to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_largespecialinstallment to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_largespecialinstallment is '二代借贷账户大额专项分期信息';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.cr_supr_rcrd_id is '征信上级记录编号';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.bigamt_spinstm_lmt is '大额专项分期额度:pd01hj01';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.instm_lmt_efdt is '分期额度生效日期:pd01hr01';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.instm_lmt_exdat is '分期额度到期日期:pd01hr02';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.usd_instm_amt is '已用分期金额:pd01hj02';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_largespecialinstallment.etl_timestamp is 'ETL处理时间戳';
