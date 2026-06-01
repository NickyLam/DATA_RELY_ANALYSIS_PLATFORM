/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_dkje
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_dkje
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_dkje purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_dkje(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,a_ln_cm_lmt_tot number(24,6) -- 账户状态正常贷款发放金额合计
    ,a_ln_cm_pmt_tot number(24,6) -- 贷款应还金额合计
    ,a_ln_cm_bal_delq number(24,6) -- 贷款逾期金额合计
    ,a_ln_cm_bal_tot number(24,6) -- 贷款余额合计
    ,dti_calculate number(24,6) -- 收入负债比
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkje to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkje to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkje to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_dkje to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_dkje is '贷款金额';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.a_ln_cm_lmt_tot is '账户状态正常贷款发放金额合计';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.a_ln_cm_pmt_tot is '贷款应还金额合计';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.a_ln_cm_bal_delq is '贷款逾期金额合计';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.a_ln_cm_bal_tot is '贷款余额合计';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.dti_calculate is '收入负债比';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_dkje.etl_timestamp is 'ETL处理时间戳';
