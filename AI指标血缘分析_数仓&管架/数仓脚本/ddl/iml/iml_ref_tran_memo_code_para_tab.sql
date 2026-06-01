/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tran_memo_code_para_tab
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tran_memo_code_para_tab
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tran_memo_code_para_tab purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tran_memo_code_para_tab(
    memo_code varchar2(60) -- 摘要码
    ,lp_id varchar2(100) -- 法人编号
    ,memo_code_descb varchar2(500) -- 摘要码描述
    ,memo_cls_cd varchar2(30) -- 摘要分类代码
    ,memo_cls_descb varchar2(500) -- 摘要分类描述
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
grant select on ${iml_schema}.ref_tran_memo_code_para_tab to ${icl_schema};
grant select on ${iml_schema}.ref_tran_memo_code_para_tab to ${idl_schema};
grant select on ${iml_schema}.ref_tran_memo_code_para_tab to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tran_memo_code_para_tab is '交易摘要码参数表';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.memo_code is '摘要码';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.lp_id is '法人编号';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.memo_code_descb is '摘要码描述';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.memo_cls_cd is '摘要分类代码';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.memo_cls_descb is '摘要分类描述';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tran_memo_code_para_tab.etl_timestamp is 'ETL处理时间戳';
