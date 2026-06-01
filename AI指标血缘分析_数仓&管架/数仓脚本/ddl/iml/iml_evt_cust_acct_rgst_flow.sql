/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cust_acct_rgst_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cust_acct_rgst_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cust_acct_rgst_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_acct_rgst_flow(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,midgrod_tran_code varchar2(90) -- 中台交易码
    ,msg_type varchar2(30) -- 报文类型
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,pbc_flow_num varchar2(60) -- 人行流水号
    ,tran_tm timestamp -- 交易时间
    ,origi_bank_no varchar2(60) -- 发起行行号
    ,recv_bank_no varchar2(60) -- 接收行行号
    ,acct_rgst_bus_type_cd varchar2(10) -- 账户注册业务类型代码
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,acct_attr_cd varchar2(10) -- 账户属性代码
    ,onl_bank_sys_open_bank_no varchar2(60) -- 网银系统开户行行号
    ,acct_num varchar2(100) -- 账号
    ,acct_name varchar2(300) -- 账户名称
    ,mask_acct_name varchar2(300) -- 掩码账户名称
    ,acct_open_bank_no varchar2(60) -- 账户开户行行号
    ,acct_clear_bank_no varchar2(60) -- 账户清算行行号
    ,mobile_no varchar2(100) -- 手机号码
    ,remark varchar2(1500) -- 备注
    ,wrtoff_bank_no varchar2(4000) -- 注销行行号
    ,new_acct_num varchar2(100) -- 新账号
    ,new_acct_rgst_attr_cd varchar2(10) -- 新账户注册属性代码
    ,new_acct_rgst_bank_no varchar2(60) -- 新账户注册行行号
    ,cont_flg varchar2(10) -- 往来标志
    ,bus_status_cd varchar2(10) -- 业务状态代码
    ,bus_refuse_cd varchar2(10) -- 业务拒绝代码
    ,pbc_proc_dt date -- 人行处理日期
    ,err_info varchar2(1500) -- 错误信息
    ,rgst_status_cd varchar2(10) -- 注册状态代码
    ,chn_id varchar2(60) -- 渠道编号
    ,chn_flow_num varchar2(60) -- 渠道流水号
    ,st_msg_ser_num varchar2(60) -- 短信序列号
    ,init_pbc_flow_num varchar2(60) -- 原人行流水号
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
grant select on ${iml_schema}.evt_cust_acct_rgst_flow to ${icl_schema};
grant select on ${iml_schema}.evt_cust_acct_rgst_flow to ${idl_schema};
grant select on ${iml_schema}.evt_cust_acct_rgst_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cust_acct_rgst_flow is '客户账户注册流水';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.midgrod_tran_code is '中台交易码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.msg_type is '报文类型';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.pbc_flow_num is '人行流水号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.origi_bank_no is '发起行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.recv_bank_no is '接收行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_rgst_bus_type_cd is '账户注册业务类型代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_attr_cd is '账户属性代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.onl_bank_sys_open_bank_no is '网银系统开户行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_num is '账号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_name is '账户名称';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.mask_acct_name is '掩码账户名称';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_open_bank_no is '账户开户行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.acct_clear_bank_no is '账户清算行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.mobile_no is '手机号码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.remark is '备注';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.wrtoff_bank_no is '注销行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.new_acct_num is '新账号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.new_acct_rgst_attr_cd is '新账户注册属性代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.new_acct_rgst_bank_no is '新账户注册行行号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.cont_flg is '往来标志';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.bus_status_cd is '业务状态代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.bus_refuse_cd is '业务拒绝代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.pbc_proc_dt is '人行处理日期';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.err_info is '错误信息';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.rgst_status_cd is '注册状态代码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.st_msg_ser_num is '短信序列号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.init_pbc_flow_num is '原人行流水号';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cust_acct_rgst_flow.etl_timestamp is 'ETL处理时间戳';
