/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_prft_weight_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_prft_weight_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_prft_weight_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_prft_weight_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,prft_weight_gover_doc_id varchar2(250) -- 收益权政府批文编号
    ,prft_weight_gover_doc_name varchar2(500) -- 收益权政府批文名称
    ,eqty_cert_id varchar2(250) -- 权益证书编号
    ,eqty_owner_name varchar2(150) -- 权益所有人名称
    ,eqty_start_dt date -- 权益开始日期
    ,eqty_exp_dt date -- 权益到期日期
    ,other_comnt varchar2(4000) -- 其他说明
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_prft_weight_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_prft_weight_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_prft_weight_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_prft_weight_info is '押品收益权信息';
comment on column ${iml_schema}.ast_col_prft_weight_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_prft_weight_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_prft_weight_info.prft_weight_gover_doc_id is '收益权政府批文编号';
comment on column ${iml_schema}.ast_col_prft_weight_info.prft_weight_gover_doc_name is '收益权政府批文名称';
comment on column ${iml_schema}.ast_col_prft_weight_info.eqty_cert_id is '权益证书编号';
comment on column ${iml_schema}.ast_col_prft_weight_info.eqty_owner_name is '权益所有人名称';
comment on column ${iml_schema}.ast_col_prft_weight_info.eqty_start_dt is '权益开始日期';
comment on column ${iml_schema}.ast_col_prft_weight_info.eqty_exp_dt is '权益到期日期';
comment on column ${iml_schema}.ast_col_prft_weight_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_prft_weight_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_prft_weight_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_prft_weight_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_prft_weight_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_prft_weight_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_prft_weight_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_prft_weight_info.etl_timestamp is 'ETL处理时间戳';
