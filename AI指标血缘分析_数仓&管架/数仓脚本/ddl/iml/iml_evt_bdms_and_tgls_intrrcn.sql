/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bdms_and_tgls_intrrcn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bdms_and_tgls_intrrcn
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bdms_and_tgls_intrrcn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bdms_and_tgls_intrrcn(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,intrrcn_flow_num varchar2(100) -- 交互流水号
    ,sys_id varchar2(100) -- 系统编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,seq_num varchar2(60) -- 序号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_amt_type_cd varchar2(30) -- 交易金额类型代码
    ,tran_amt number(30,2) -- 交易金额
    ,init_tran_dt date -- 原交易日期
    ,agt_id varchar2(250) -- 协议编号
    ,chn_id varchar2(100) -- 渠道编号
    ,sellbl_prod_id varchar2(100) -- 可售产品编号
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,revs_bus_status_cd varchar2(60) -- 冲正业务状态代码
    ,revs_tm varchar2(30) -- 冲正时间
    ,bill_id varchar2(100) -- 票据编号
    ,batch_no varchar2(100) -- 批次号
    ,dtl_id varchar2(100) -- 明细编号
    ,send_tgls_batch number(22) -- 发送核算中台批次
    ,send_tgls__end_day_batch number(22) -- 发送核算中台日终批次
    ,end_day_feedback_status_cd varchar2(30) -- 日终反馈状态代码
    ,send_tgls__doc_name varchar2(500) -- 发送核算中台文件名称
    ,err_cd varchar2(10) -- 错误码
    ,err_info varchar2(500) -- 错误信息
    ,acct_instit_id varchar2(100) -- 账务机构编号
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
grant select on ${iml_schema}.evt_bdms_and_tgls_intrrcn to ${icl_schema};
grant select on ${iml_schema}.evt_bdms_and_tgls_intrrcn to ${idl_schema};
grant select on ${iml_schema}.evt_bdms_and_tgls_intrrcn to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bdms_and_tgls_intrrcn is '票据与核算中台交互事件';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.intrrcn_flow_num is '交互流水号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.sys_id is '系统编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.seq_num is '序号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_amt_type_cd is '交易金额类型代码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.agt_id is '协议编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.revs_flow_num is '冲正流水号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.revs_bus_status_cd is '冲正业务状态代码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.revs_tm is '冲正时间';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.batch_no is '批次号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.dtl_id is '明细编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.send_tgls_batch is '发送核算中台批次';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.send_tgls__end_day_batch is '发送核算中台日终批次';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.end_day_feedback_status_cd is '日终反馈状态代码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.send_tgls__doc_name is '发送核算中台文件名称';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.err_cd is '错误码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.err_info is '错误信息';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bdms_and_tgls_intrrcn.etl_timestamp is 'ETL处理时间戳';
