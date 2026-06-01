/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_coll_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_coll_batch
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_coll_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_coll_batch(
    batch_id varchar2(60) -- 批次编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,bus_id varchar2(60) -- 业务编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,agt_apv_status_cd varchar2(10) -- 协议审批状态代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,init_coll_dt date -- 发起托收日期
    ,cust_open_bank_no varchar2(60) -- 客户开户行行号
    ,cust_name varchar2(500) -- 客户名称
    ,open_bank_name varchar2(500) -- 开户行行名称
    ,bus_sponsor_id varchar2(60) -- 业务发起人编号
    ,final_operr_id varchar2(60) -- 最后操作员编号
    ,final_oper_tm timestamp -- 最后操作时间
    ,valet_coll_flg varchar2(10) -- 代客托收标志
    ,send_out_coll_status_cd varchar2(30) -- 发出托收状态代码
    ,coll_appl_dt date -- 托收申请日期
    ,org_id varchar2(60) -- 机构编号
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
grant select on ${iml_schema}.agt_bill_coll_batch to ${icl_schema};
grant select on ${iml_schema}.agt_bill_coll_batch to ${idl_schema};
grant select on ${iml_schema}.agt_bill_coll_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_coll_batch is '票据托收批次';
comment on column ${iml_schema}.agt_bill_coll_batch.batch_id is '批次编号';
comment on column ${iml_schema}.agt_bill_coll_batch.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_coll_batch.cust_id is '客户编号';
comment on column ${iml_schema}.agt_bill_coll_batch.bus_id is '业务编号';
comment on column ${iml_schema}.agt_bill_coll_batch.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_bill_coll_batch.agt_apv_status_cd is '协议审批状态代码';
comment on column ${iml_schema}.agt_bill_coll_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_bill_coll_batch.init_coll_dt is '发起托收日期';
comment on column ${iml_schema}.agt_bill_coll_batch.cust_open_bank_no is '客户开户行行号';
comment on column ${iml_schema}.agt_bill_coll_batch.cust_name is '客户名称';
comment on column ${iml_schema}.agt_bill_coll_batch.open_bank_name is '开户行行名称';
comment on column ${iml_schema}.agt_bill_coll_batch.bus_sponsor_id is '业务发起人编号';
comment on column ${iml_schema}.agt_bill_coll_batch.final_operr_id is '最后操作员编号';
comment on column ${iml_schema}.agt_bill_coll_batch.final_oper_tm is '最后操作时间';
comment on column ${iml_schema}.agt_bill_coll_batch.valet_coll_flg is '代客托收标志';
comment on column ${iml_schema}.agt_bill_coll_batch.send_out_coll_status_cd is '发出托收状态代码';
comment on column ${iml_schema}.agt_bill_coll_batch.coll_appl_dt is '托收申请日期';
comment on column ${iml_schema}.agt_bill_coll_batch.org_id is '机构编号';
comment on column ${iml_schema}.agt_bill_coll_batch.start_dt is '开始时间';
comment on column ${iml_schema}.agt_bill_coll_batch.end_dt is '结束时间';
comment on column ${iml_schema}.agt_bill_coll_batch.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_coll_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_coll_batch.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_coll_batch.etl_timestamp is 'ETL处理时间戳';
