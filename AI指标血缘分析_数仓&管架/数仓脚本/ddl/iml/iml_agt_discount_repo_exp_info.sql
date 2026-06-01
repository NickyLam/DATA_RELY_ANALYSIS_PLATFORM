/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_discount_repo_exp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_discount_repo_exp_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_discount_repo_exp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_discount_repo_exp_info(
    repo_exp_id varchar2(60) -- 回购到期编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,bus_dt date -- 业务日期
    ,batch_id varchar2(60) -- 批次编号
    ,prod_id varchar2(60) -- 产品编号
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,bus_org_id varchar2(60) -- 业务机构编号
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,clear_status_cd varchar2(10) -- 清算状态代码
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.agt_discount_repo_exp_info to ${icl_schema};
grant select on ${iml_schema}.agt_discount_repo_exp_info to ${idl_schema};
grant select on ${iml_schema}.agt_discount_repo_exp_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_discount_repo_exp_info is '转贴现回购到期信息';
comment on column ${iml_schema}.agt_discount_repo_exp_info.repo_exp_id is '回购到期编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.cont_id is '合同编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.bus_dt is '业务日期';
comment on column ${iml_schema}.agt_discount_repo_exp_info.batch_id is '批次编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_discount_repo_exp_info.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_discount_repo_exp_info.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.agt_discount_repo_exp_info.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_discount_repo_exp_info.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.agt_discount_repo_exp_info.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_discount_repo_exp_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_discount_repo_exp_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_discount_repo_exp_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_discount_repo_exp_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_discount_repo_exp_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_discount_repo_exp_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_discount_repo_exp_info.etl_timestamp is 'ETL处理时间戳';
