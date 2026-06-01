/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dep_pd_mgmt_int_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dep_pd_mgmt_int_rat_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dep_pd_mgmt_int_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_pd_mgmt_int_rat_h(
    seq_num varchar2(60) -- 序号
    ,pd_cd varchar2(30) -- 期次代码
    ,lp_id varchar2(100) -- 法人编号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,evt_cate_id varchar2(100) -- 事件类别编号
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,cds_issue_year varchar2(60) -- 大额存单发行年度
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
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
grant select on ${iml_schema}.ref_dep_pd_mgmt_int_rat_h to ${icl_schema};
grant select on ${iml_schema}.ref_dep_pd_mgmt_int_rat_h to ${idl_schema};
grant select on ${iml_schema}.ref_dep_pd_mgmt_int_rat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dep_pd_mgmt_int_rat_h is '存款期次管理利率历史';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.seq_num is '序号';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.pd_cd is '期次代码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.prod_id is '产品编号';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.evt_cate_id is '事件类别编号';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.cds_issue_year is '大额存单发行年度';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dep_pd_mgmt_int_rat_h.etl_timestamp is 'ETL处理时间戳';
