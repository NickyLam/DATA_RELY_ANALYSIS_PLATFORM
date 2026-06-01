/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_exch_rat_type_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_exch_rat_type_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_exch_rat_type_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_exch_rat_type_para(
    lp_id varchar2(100) -- 法人编号
    ,exch_rat_type_cd varchar2(30) -- 汇率类型代码
    ,exch_rat_type_descb varchar2(500) -- 汇率类型描述
    ,quot_curr_cd varchar2(30) -- 报价币种代码
    ,exch_rat_float_cate_cd varchar2(30) -- 汇率浮动类别代码
    ,curr_pairs_exch_rat_flg varchar2(10) -- 货币对汇率标志
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
grant select on ${iml_schema}.ref_exch_rat_type_para to ${icl_schema};
grant select on ${iml_schema}.ref_exch_rat_type_para to ${idl_schema};
grant select on ${iml_schema}.ref_exch_rat_type_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_exch_rat_type_para is '汇率类型参数表';
comment on column ${iml_schema}.ref_exch_rat_type_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_exch_rat_type_para.exch_rat_type_cd is '汇率类型代码';
comment on column ${iml_schema}.ref_exch_rat_type_para.exch_rat_type_descb is '汇率类型描述';
comment on column ${iml_schema}.ref_exch_rat_type_para.quot_curr_cd is '报价币种代码';
comment on column ${iml_schema}.ref_exch_rat_type_para.exch_rat_float_cate_cd is '汇率浮动类别代码';
comment on column ${iml_schema}.ref_exch_rat_type_para.curr_pairs_exch_rat_flg is '货币对汇率标志';
comment on column ${iml_schema}.ref_exch_rat_type_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_exch_rat_type_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_exch_rat_type_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_exch_rat_type_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_exch_rat_type_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_exch_rat_type_para.etl_timestamp is 'ETL处理时间戳';
