/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_insu_comp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_insu_comp
whenever sqlerror continue none;
drop table ${iml_schema}.ref_insu_comp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_insu_comp(
    ta_cd varchar2(30) -- TA代码
    ,lp_id varchar2(60) -- 法人编号
    ,insure_bank_cd varchar2(30) -- 保险银行代码
    ,corp_name varchar2(150) -- 公司名称
    ,corp_abbr varchar2(150) -- 公司简称
    ,insu_comp_type_cd varchar2(30) -- 保险公司类型代码
    ,lmt_ctrl_type_cd varchar2(30) -- 额度控制类型代码
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
grant select on ${iml_schema}.ref_insu_comp to ${icl_schema};
grant select on ${iml_schema}.ref_insu_comp to ${idl_schema};
grant select on ${iml_schema}.ref_insu_comp to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_insu_comp is '保险公司';
comment on column ${iml_schema}.ref_insu_comp.ta_cd is 'TA代码';
comment on column ${iml_schema}.ref_insu_comp.lp_id is '法人编号';
comment on column ${iml_schema}.ref_insu_comp.insure_bank_cd is '保险银行代码';
comment on column ${iml_schema}.ref_insu_comp.corp_name is '公司名称';
comment on column ${iml_schema}.ref_insu_comp.corp_abbr is '公司简称';
comment on column ${iml_schema}.ref_insu_comp.insu_comp_type_cd is '保险公司类型代码';
comment on column ${iml_schema}.ref_insu_comp.lmt_ctrl_type_cd is '额度控制类型代码';
comment on column ${iml_schema}.ref_insu_comp.create_dt is '创建日期';
comment on column ${iml_schema}.ref_insu_comp.update_dt is '更新日期';
comment on column ${iml_schema}.ref_insu_comp.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_insu_comp.id_mark is '增删标志';
comment on column ${iml_schema}.ref_insu_comp.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_insu_comp.job_cd is '任务编码';
comment on column ${iml_schema}.ref_insu_comp.etl_timestamp is 'ETL处理时间戳';
