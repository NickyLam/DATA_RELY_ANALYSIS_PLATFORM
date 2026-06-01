/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_rgst_batch_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_rgst_batch_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_rgst_batch_dtl_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rgst_dtl_id varchar2(100) -- 登记明细编号
    ,rgst_id varchar2(100) -- 登记编号
    ,rgst_way_cd varchar2(30) -- 登记方式代码
    ,bill_id varchar2(100) -- 票据编号
    ,bus_dt date -- 业务日期
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,proc_status_cd varchar2(30) -- 处理状态代码
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
grant select on ${iml_schema}.evt_bill_rgst_batch_dtl_h to ${icl_schema};
grant select on ${iml_schema}.evt_bill_rgst_batch_dtl_h to ${idl_schema};
grant select on ${iml_schema}.evt_bill_rgst_batch_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_rgst_batch_dtl_h is '票据登记批次明细历史';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.rgst_dtl_id is '登记明细编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.rgst_id is '登记编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.rgst_way_cd is '登记方式代码';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.bus_dt is '业务日期';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_rgst_batch_dtl_h.etl_timestamp is 'ETL处理时间戳';
