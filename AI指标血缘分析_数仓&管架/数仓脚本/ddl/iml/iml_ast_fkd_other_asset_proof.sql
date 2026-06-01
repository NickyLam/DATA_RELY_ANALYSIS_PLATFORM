/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_fkd_other_asset_proof
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_fkd_other_asset_proof
whenever sqlerror continue none;
drop table ${iml_schema}.ast_fkd_other_asset_proof purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_fkd_other_asset_proof(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_proof_list_id varchar2(60) -- 资产证明列表编号
    ,bus_flow_num varchar2(60) -- 业务流水号
    ,other_asset_proof_type varchar2(100) -- 其他资产证明类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_fkd_other_asset_proof to ${icl_schema};
grant select on ${iml_schema}.ast_fkd_other_asset_proof to ${idl_schema};
grant select on ${iml_schema}.ast_fkd_other_asset_proof to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_fkd_other_asset_proof is '房快贷其他资产证明';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.asset_id is '资产编号';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.lp_id is '法人编号';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.asset_proof_list_id is '资产证明列表编号';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.other_asset_proof_type is '其他资产证明类型';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.start_dt is '开始时间';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.end_dt is '结束时间';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.id_mark is '增删标志';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.job_cd is '任务编码';
comment on column ${iml_schema}.ast_fkd_other_asset_proof.etl_timestamp is 'ETL处理时间戳';
