/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cif_client_verification
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cif_client_verification
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cif_client_verification purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_client_verification(
    client_no varchar2(16) -- 客户编号
    ,remark varchar2(600) -- 备注
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,is_save varchar2(1) -- 留存标志
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_code varchar2(50) -- 状态码
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,treatment varchar2(2) -- 处理种类
    ,verification_result varchar2(2) -- 核查结果
    ,verification_source_type varchar2(10) -- 核查渠道
    ,verify_status varchar2(1) -- 核查状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,verification_date date -- 核实日期
    ,unverification_reason varchar2(200) -- 无法核实原因
    ,verification_branch varchar2(12) -- 核查机构
    ,verification_user_id varchar2(8) -- 核实柜员
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cif_client_verification to ${iml_schema};
grant select on ${iol_schema}.ncbs_cif_client_verification to ${icl_schema};
grant select on ${iol_schema}.ncbs_cif_client_verification to ${idl_schema};
grant select on ${iol_schema}.ncbs_cif_client_verification to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cif_client_verification is '个人客户身份核实情况表';
comment on column ${iol_schema}.ncbs_cif_client_verification.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cif_client_verification.remark is '备注';
comment on column ${iol_schema}.ncbs_cif_client_verification.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cif_client_verification.company is '法人';
comment on column ${iol_schema}.ncbs_cif_client_verification.is_save is '留存标志';
comment on column ${iol_schema}.ncbs_cif_client_verification.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_cif_client_verification.ret_code is '状态码';
comment on column ${iol_schema}.ncbs_cif_client_verification.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_cif_client_verification.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cif_client_verification.treatment is '处理种类';
comment on column ${iol_schema}.ncbs_cif_client_verification.verification_result is '核查结果';
comment on column ${iol_schema}.ncbs_cif_client_verification.verification_source_type is '核查渠道';
comment on column ${iol_schema}.ncbs_cif_client_verification.verify_status is '核查状态';
comment on column ${iol_schema}.ncbs_cif_client_verification.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cif_client_verification.verification_date is '核实日期';
comment on column ${iol_schema}.ncbs_cif_client_verification.unverification_reason is '无法核实原因';
comment on column ${iol_schema}.ncbs_cif_client_verification.verification_branch is '核查机构';
comment on column ${iol_schema}.ncbs_cif_client_verification.verification_user_id is '核实柜员';
comment on column ${iol_schema}.ncbs_cif_client_verification.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cif_client_verification.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cif_client_verification.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cif_client_verification.etl_timestamp is 'ETL处理时间戳';
