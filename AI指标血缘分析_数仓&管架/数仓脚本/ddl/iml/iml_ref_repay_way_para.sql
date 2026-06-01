/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_repay_way_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_repay_way_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_repay_way_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_repay_way_para(
    repay_way_cd varchar2(30) -- 还款方式代码
    ,lp_id varchar2(100) -- 法人编号
    ,repay_way_descb varchar2(500) -- 还款方式描述
    ,pric_int_proc_way_cd varchar2(30) -- 本息处理方式代码
    ,fst_term_flg varchar2(10) -- 首期破期标志
    ,pric_repay_type_cd varchar2(30) -- 本金还款类型代码
    ,calc_formu varchar2(30) -- 计算公式
    ,acpt_pay_idf_cd varchar2(30) -- 收付标识代码
    ,term_end_merge_days number(10) -- 期末合并天数
    ,term_end_merge_type_cd varchar2(30) -- 期末合并类型代码
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
grant select on ${iml_schema}.ref_repay_way_para to ${icl_schema};
grant select on ${iml_schema}.ref_repay_way_para to ${idl_schema};
grant select on ${iml_schema}.ref_repay_way_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_repay_way_para is '还款方式参数';
comment on column ${iml_schema}.ref_repay_way_para.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.ref_repay_way_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_repay_way_para.repay_way_descb is '还款方式描述';
comment on column ${iml_schema}.ref_repay_way_para.pric_int_proc_way_cd is '本息处理方式代码';
comment on column ${iml_schema}.ref_repay_way_para.fst_term_flg is '首期破期标志';
comment on column ${iml_schema}.ref_repay_way_para.pric_repay_type_cd is '本金还款类型代码';
comment on column ${iml_schema}.ref_repay_way_para.calc_formu is '计算公式';
comment on column ${iml_schema}.ref_repay_way_para.acpt_pay_idf_cd is '收付标识代码';
comment on column ${iml_schema}.ref_repay_way_para.term_end_merge_days is '期末合并天数';
comment on column ${iml_schema}.ref_repay_way_para.term_end_merge_type_cd is '期末合并类型代码';
comment on column ${iml_schema}.ref_repay_way_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_repay_way_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_repay_way_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_repay_way_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_repay_way_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_repay_way_para.etl_timestamp is 'ETL处理时间戳';
