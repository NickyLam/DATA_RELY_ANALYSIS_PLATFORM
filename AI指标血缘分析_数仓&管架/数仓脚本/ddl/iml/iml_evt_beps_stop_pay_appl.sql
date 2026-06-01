/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_beps_stop_pay_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_beps_stop_pay_appl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_beps_stop_pay_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_beps_stop_pay_appl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,appl_seq_num varchar2(100) -- 申请序号
    ,midgrod_dt date -- 中台日期
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,obank_init_stop_pay_flg varchar2(10) -- 他行发起止付标志
    ,appl_dt date -- 申请日期
    ,appl_clear_bk_no varchar2(100) -- 申请清算行行号
    ,appl_bk_no varchar2(100) -- 申请行行号
    ,reply_clear_bk_no varchar2(100) -- 应答清算行行号
    ,reply_bk_no varchar2(100) -- 应答行行号
    ,appl_type_cd varchar2(30) -- 申请类型代码
    ,appl_stop_pay_cnt varchar2(45) -- 申请止付笔数
    ,agree_stop_pay_cnt varchar2(45) -- 同意止付笔数
    ,init_init_org_id varchar2(250) -- 原发起机构编号
    ,init_recv_bank_no varchar2(100) -- 原收款行行号
    ,init_pay_bank_no varchar2(100) -- 原付款行行号
    ,init_entr_dt date -- 原委托日期
    ,init_dtl_ind_no varchar2(100) -- 原明细标识号
    ,init_bus_type_id varchar2(100) -- 原业务类型编号
    ,appl_stop_pay_amt number(30,2) -- 申请止付金额
    ,appl_remark varchar2(750) -- 申请备注
    ,reply_remark varchar2(750) -- 应答备注
    ,stop_pay_reply_status_cd varchar2(30) -- 止付应答状态代码
    ,appl_teller_id varchar2(250) -- 申请柜员编号
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,reply_dt date -- 应答日期
    ,send_dt date -- 发送日期
    ,send_tm timestamp -- 发送时间
    ,dept_id varchar2(100) -- 部门编号
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
grant select on ${iml_schema}.evt_beps_stop_pay_appl to ${icl_schema};
grant select on ${iml_schema}.evt_beps_stop_pay_appl to ${idl_schema};
grant select on ${iml_schema}.evt_beps_stop_pay_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_beps_stop_pay_appl is '小额止付申请';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_seq_num is '申请序号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.midgrod_dt is '中台日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.obank_init_stop_pay_flg is '他行发起止付标志';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_clear_bk_no is '申请清算行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_bk_no is '申请行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.reply_clear_bk_no is '应答清算行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.reply_bk_no is '应答行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_type_cd is '申请类型代码';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_stop_pay_cnt is '申请止付笔数';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.agree_stop_pay_cnt is '同意止付笔数';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_init_org_id is '原发起机构编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_recv_bank_no is '原收款行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_pay_bank_no is '原付款行行号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_entr_dt is '原委托日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_dtl_ind_no is '原明细标识号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.init_bus_type_id is '原业务类型编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_stop_pay_amt is '申请止付金额';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_remark is '申请备注';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.reply_remark is '应答备注';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.stop_pay_reply_status_cd is '止付应答状态代码';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.appl_teller_id is '申请柜员编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.reply_dt is '应答日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.send_dt is '发送日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.send_tm is '发送时间';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.dept_id is '部门编号';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_beps_stop_pay_appl.etl_timestamp is 'ETL处理时间戳';
