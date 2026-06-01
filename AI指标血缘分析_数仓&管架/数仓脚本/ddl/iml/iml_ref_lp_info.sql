/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_lp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_lp_info
whenever sqlerror continue none;
drop table ${iml_schema}.ref_lp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_lp_info(
    corp_id varchar2(100) -- 公司编号
    ,lp_id varchar2(100) -- 法人编号
    ,corp_name varchar2(500) -- 公司名称
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,multi_lp_allow_acrs_lp_que_flg varchar2(10) -- 多法人允许跨法人查询标志
    ,general_exch_lp_id varchar2(100) -- 通兑法人编号
    ,general_storage_lp_id varchar2(100) -- 通存法人编号
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
grant select on ${iml_schema}.ref_lp_info to ${icl_schema};
grant select on ${iml_schema}.ref_lp_info to ${idl_schema};
grant select on ${iml_schema}.ref_lp_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_lp_info is '法人信息';
comment on column ${iml_schema}.ref_lp_info.corp_id is '公司编号';
comment on column ${iml_schema}.ref_lp_info.lp_id is '法人编号';
comment on column ${iml_schema}.ref_lp_info.corp_name is '公司名称';
comment on column ${iml_schema}.ref_lp_info.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.ref_lp_info.multi_lp_allow_acrs_lp_que_flg is '多法人允许跨法人查询标志';
comment on column ${iml_schema}.ref_lp_info.general_exch_lp_id is '通兑法人编号';
comment on column ${iml_schema}.ref_lp_info.general_storage_lp_id is '通存法人编号';
comment on column ${iml_schema}.ref_lp_info.start_dt is '开始时间';
comment on column ${iml_schema}.ref_lp_info.end_dt is '结束时间';
comment on column ${iml_schema}.ref_lp_info.id_mark is '增删标志';
comment on column ${iml_schema}.ref_lp_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_lp_info.job_cd is '任务编码';
comment on column ${iml_schema}.ref_lp_info.etl_timestamp is 'ETL处理时间戳';
