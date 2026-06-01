/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_guar_cont_guar_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,col_id varchar2(100) -- 押品编号
    ,incid_rela_status_cd varchar2(30) -- 关联关系状态代码
    ,remark varchar2(2000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(250) -- 更新柜员编号
    ,update_org_id varchar2(250) -- 更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h is '联合网贷担保合同与担保物关系历史';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.col_id is '押品编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.incid_rela_status_cd is '关联关系状态代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.remark is '备注';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_guar_rela_h.etl_timestamp is 'ETL处理时间戳';
