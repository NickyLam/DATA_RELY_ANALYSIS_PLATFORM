/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_rgst_batch_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_rgst_batch_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_rgst_batch_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_rgst_batch_info_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rgst_id varchar2(100) -- 登记编号
    ,rgst_batch_id varchar2(100) -- 登记批次编号
    ,prod_id varchar2(100) -- 产品编号
    ,org_id varchar2(100) -- 机构编号
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,rgst_dt date -- 登记日期
    ,bus_rgst_type_cd varchar2(30) -- 业务登记类型代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,msg_status_cd varchar2(30) -- 报文状态代码
    ,final_modif_operr_id varchar2(100) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.evt_bill_rgst_batch_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_bill_rgst_batch_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_bill_rgst_batch_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_rgst_batch_info_h is '票据登记批次信息历史';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.rgst_id is '登记编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.rgst_batch_id is '登记批次编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.org_id is '机构编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.bus_rgst_type_cd is '业务登记类型代码';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.msg_status_cd is '报文状态代码';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_rgst_batch_info_h.etl_timestamp is 'ETL处理时间戳';
