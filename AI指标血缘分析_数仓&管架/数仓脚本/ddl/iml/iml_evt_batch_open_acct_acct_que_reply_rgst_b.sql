/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_batch_open_acct_acct_que_reply_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,msg_ind_no varchar2(60) -- 报文标识号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(750) -- 账户名称
    ,msg_id varchar2(100) -- 报文编号
    ,init_msg_ind_no varchar2(60) -- 原报文标识号
    ,que_acct_qtty number(30) -- 查询账户数量
    ,seq_num varchar2(60) -- 序号
    ,acct_que_rest_cd varchar2(30) -- 账户查询结果代码
    ,midgrod_tran_dt date -- 中台交易日期
    ,midgrod_tran_tm timestamp -- 中台交易时间
    ,msg_send_tm timestamp -- 报文发送时间
    ,init_dir_prtcpt_org_id varchar2(100) -- 发起直接参与机构编号
    ,init_prtcpt_org_id varchar2(100) -- 发起参与机构编号
    ,recv_dir_prtcpt_org_id varchar2(100) -- 接收直接参与机构编号
    ,recv_prtcpt_org_id varchar2(100) -- 接收参与机构编号
    ,sys_id varchar2(100) -- 系统编号
    ,remark varchar2(750) -- 备注
    ,idti_num_check_rest_cd varchar2(30) -- 身份号码校验结果代码
    ,cont_mode_check_rest_cd varchar2(30) -- 联系方式校验结果代码
    ,open_bank_no varchar2(60) -- 开户行行号
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,pbc_rest_cd varchar2(30) -- 人行处理结果代码
    ,pbc_proc_dt date -- 人行处理日期
    ,nostro_cd varchar2(30) -- 往来账代码
    ,bus_refuse_code varchar2(45) -- 业务拒绝码
    ,bus_refuse_info_desc varchar2(750) -- 业务拒绝信息描述
    ,bus_process_cd varchar2(45) -- 业务处理码
    ,bus_status_cd varchar2(30) -- 业务状态代码
    ,bus_refuse_process_cd varchar2(45) -- 业务拒绝处理码
    ,bus_refuse_info varchar2(750) -- 业务拒绝信息
    ,osb_tran_flow_num varchar2(100) -- osb交易流水号
    ,osb_return_code varchar2(45) -- osb返回码
    ,osb_return_info_desc varchar2(750) -- osb返回信息描述
    ,osb_return_status varchar2(45) -- osb返回状态
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b is '批量开户账户查询应答登记簿';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.msg_ind_no is '报文标识号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.acct_id is '账户编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.acct_name is '账户名称';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.msg_id is '报文编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.init_msg_ind_no is '原报文标识号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.que_acct_qtty is '查询账户数量';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.seq_num is '序号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.acct_que_rest_cd is '账户查询结果代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.midgrod_tran_tm is '中台交易时间';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.msg_send_tm is '报文发送时间';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.init_dir_prtcpt_org_id is '发起直接参与机构编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.init_prtcpt_org_id is '发起参与机构编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.recv_dir_prtcpt_org_id is '接收直接参与机构编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.recv_prtcpt_org_id is '接收参与机构编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.sys_id is '系统编号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.remark is '备注';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.idti_num_check_rest_cd is '身份号码校验结果代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.cont_mode_check_rest_cd is '联系方式校验结果代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.open_bank_no is '开户行行号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.pbc_rest_cd is '人行处理结果代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.pbc_proc_dt is '人行处理日期';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.nostro_cd is '往来账代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_refuse_code is '业务拒绝码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_refuse_info_desc is '业务拒绝信息描述';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_process_cd is '业务处理码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_status_cd is '业务状态代码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_refuse_process_cd is '业务拒绝处理码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.bus_refuse_info is '业务拒绝信息';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.osb_tran_flow_num is 'osb交易流水号';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.osb_return_code is 'osb返回码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.osb_return_info_desc is 'osb返回信息描述';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.osb_return_status is 'osb返回状态';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b.etl_timestamp is 'ETL处理时间戳';
