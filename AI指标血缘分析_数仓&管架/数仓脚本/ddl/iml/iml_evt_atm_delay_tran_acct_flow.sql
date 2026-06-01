/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_atm_delay_tran_acct_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_atm_delay_tran_acct_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_atm_delay_tran_acct_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_atm_delay_tran_acct_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,main_acct_id varchar2(100) -- 主账户编号
    ,sys_follow_id varchar2(100) -- 系统跟踪编号
    ,rsrv_mobile_no varchar2(100) -- 预留手机号
    ,curr_cd varchar2(30) -- 币种代码
    ,unionpay_curr_cd varchar2(30) -- 银联币种代码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,midgrod_tran_dt date -- 中台交易日期
    ,tran_dt date -- 交易日期
    ,tran_cd varchar2(30) -- 交易代码
    ,tran_type_cd varchar2(60) -- 交易类型代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,ghb_dtran_acct_fail_ag_cnt number(10) -- 本行延时转账失败重试次数
    ,delay_tran_acct_rest_cd varchar2(30) -- 延时转账处理结果代码
    ,fee_type_cd varchar2(30) -- 费用类型代码
    ,comm_fee number(30,2) -- 手续费
    ,clear_amt number(30,2) -- 清算金额
    ,tran_out_acct_id varchar2(100) -- 转出账户编号
    ,tran_out_acct_name varchar2(500) -- 转出账户名称
    ,tran_in_acct_id varchar2(100) -- 转入账户编号
    ,tran_in_acct_name varchar2(500) -- 转入账户名称
    ,open_acct_org_id varchar2(500) -- 开户机构编号
    ,proc_org_id varchar2(100) -- 受理机构编号
    ,send_org_id varchar2(100) -- 发送机构编号
    ,core_froz_flow_num varchar2(100) -- 核心冻结流水号
    ,core_froz_dt date -- 核心冻结日期
    ,core_deduct_flow_num varchar2(100) -- 核心扣款流水号
    ,core_deduct_dt date -- 核心扣款日期
    ,core_memo_code varchar2(100) -- 核心摘要码
    ,core_intfc_code varchar2(100) -- 核心接口码
    ,aldy_adj_entry_flg varchar2(60) -- 已调账标志
    ,err_cd varchar2(100) -- 错误码
    ,err_info varchar2(500) -- 错误信息
    ,sorc_sys_cd varchar2(30) -- 源系统代码
    ,pass_id varchar2(100) -- 通道编号
    ,mercht_type_cd varchar2(30) -- 商户类型代码
    ,proc_mercht_id varchar2(100) -- 受理商户编号
    ,proc_mercht_name varchar2(500) -- 受理商户名称
    ,init_sys_follow_id varchar2(100) -- 原系统跟踪编号
    ,init_ova_flow_num varchar2(100) -- 原全局流水号
    ,init_bus_flow_num varchar2(100) -- 原业务流水号
    ,init_tran_tm varchar2(100) -- 原交易时间
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,init_proc_org_id varchar2(100) -- 原受理机构编号
    ,init_send_org_id varchar2(100) -- 原发送机构编号
    ,equip_id varchar2(100) -- 设备号
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_atm_delay_tran_acct_flow to ${icl_schema};
grant select on ${iml_schema}.evt_atm_delay_tran_acct_flow to ${idl_schema};
grant select on ${iml_schema}.evt_atm_delay_tran_acct_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_atm_delay_tran_acct_flow is 'ATM延时转账流水';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.main_acct_id is '主账户编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.sys_follow_id is '系统跟踪编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.rsrv_mobile_no is '预留手机号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.unionpay_curr_cd is '银联币种代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.ghb_dtran_acct_fail_ag_cnt is '本行延时转账失败重试次数';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.delay_tran_acct_rest_cd is '延时转账处理结果代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.fee_type_cd is '费用类型代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.clear_amt is '清算金额';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_out_acct_id is '转出账户编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_out_acct_name is '转出账户名称';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_in_acct_id is '转入账户编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.tran_in_acct_name is '转入账户名称';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.proc_org_id is '受理机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.send_org_id is '发送机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_froz_flow_num is '核心冻结流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_froz_dt is '核心冻结日期';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_deduct_flow_num is '核心扣款流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_deduct_dt is '核心扣款日期';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_memo_code is '核心摘要码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.core_intfc_code is '核心接口码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.aldy_adj_entry_flg is '已调账标志';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.err_info is '错误信息';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.pass_id is '通道编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.mercht_type_cd is '商户类型代码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.proc_mercht_id is '受理商户编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.proc_mercht_name is '受理商户名称';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_sys_follow_id is '原系统跟踪编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_ova_flow_num is '原全局流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_bus_flow_num is '原业务流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_tran_tm is '原交易时间';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_proc_org_id is '原受理机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.init_send_org_id is '原发送机构编号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.equip_id is '设备号';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.remark is '备注';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_atm_delay_tran_acct_flow.etl_timestamp is 'ETL处理时间戳';
