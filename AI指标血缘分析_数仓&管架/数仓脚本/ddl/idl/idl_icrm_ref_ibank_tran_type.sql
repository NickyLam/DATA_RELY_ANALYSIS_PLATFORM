/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_ibank_tran_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_ibank_tran_type
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_ibank_tran_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_ibank_tran_type(
    etl_dt date -- 数据日期
    ,tran_type_id varchar2(60) -- 交易类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_type_descb varchar2(100) -- 交易类型描述
    ,ped_instr_cd varchar2(10) -- 周期指令代码
    ,crdt_risk_check_flg varchar2(10) -- 信用风险审查标志
    ,check_admit_lib_flg varchar2(10) -- 校验准入库标志
    ,seq_num varchar2(60) -- 序号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_ibank_tran_type to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_ibank_tran_type is '同业交易类型';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.tran_type_id is '交易类型编号';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.tran_type_descb is '交易类型描述';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.ped_instr_cd is '周期指令代码';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.crdt_risk_check_flg is '信用风险审查标志';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.check_admit_lib_flg is '校验准入库标志';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.seq_num is '序号';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_ibank_tran_type.etl_timestamp is '数据处理时间';
