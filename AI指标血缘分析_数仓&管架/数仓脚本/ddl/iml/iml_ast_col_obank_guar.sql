/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_obank_guar
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_obank_guar
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_obank_guar purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_obank_guar(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(100) -- 法人编号
    ,seq_num varchar2(100) -- 序号
    ,hxb_prior_seq_comb_cd number -- 我行优先偿权顺序组合代码
    ,obank_name varchar2(750) -- 他行名称
    ,obank_set_sec_right_amt number(20,4) -- 他行设定担保权金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_obank_guar to ${icl_schema};
grant select on ${iml_schema}.ast_col_obank_guar to ${idl_schema};
grant select on ${iml_schema}.ast_col_obank_guar to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_obank_guar is '押品他行担保';
comment on column ${iml_schema}.ast_col_obank_guar.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_obank_guar.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_obank_guar.seq_num is '序号';
comment on column ${iml_schema}.ast_col_obank_guar.hxb_prior_seq_comb_cd is '我行优先偿权顺序组合代码';
comment on column ${iml_schema}.ast_col_obank_guar.obank_name is '他行名称';
comment on column ${iml_schema}.ast_col_obank_guar.obank_set_sec_right_amt is '他行设定担保权金额';
comment on column ${iml_schema}.ast_col_obank_guar.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_obank_guar.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_obank_guar.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_obank_guar.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_obank_guar.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_obank_guar.etl_timestamp is 'ETL处理时间戳';
