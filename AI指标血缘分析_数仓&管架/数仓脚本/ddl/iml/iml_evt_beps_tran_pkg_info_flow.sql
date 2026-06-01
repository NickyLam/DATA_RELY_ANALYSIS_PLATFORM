/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_beps_tran_pkg_info_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_beps_tran_pkg_info_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_beps_tran_pkg_info_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_beps_tran_pkg_info_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,pkg_seq_num varchar2(60) -- 包序号
    ,pkg_entr_dt date -- 包委托日期
    ,pkg_init_clear_bk_no varchar2(60) -- 包发起清算行行号
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,pkg_init_clear_bk_rg_cd varchar2(30) -- 包发起清算行地区代码
    ,pkg_recv_clear_bk_no varchar2(60) -- 包接收清算行行号
    ,pkg_recv_clear_bk_rg_code varchar2(45) -- 包接收清算行地区码
    ,tran_dt date -- 交易日期
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,bank_int_proc_status_cd varchar2(30) -- 行内处理状态代码
    ,rtn_rcpt_day_tenor number(10) -- 回执日期限
    ,rtn_rcpt_dt date -- 回执日期
    ,tot number(10) -- 总笔数
    ,tot_amt number(30,2) -- 总金额
    ,sucs_cnt number(10) -- 成功笔数
    ,sucs_amt number(30,2) -- 成功金额
    ,fail_cnt number(10) -- 失败笔数
    ,fail_amt number(30,2) -- 失败金额
    ,curr_cd varchar2(30) -- 币种代码
    ,offs_bal_num_site number(10) -- 轧差场次
    ,offs_bal_dt date -- 轧差日期
    ,reissue_flg varchar2(10) -- 补发标志
    ,clear_dt date -- 清算日期
    ,brac_org_id varchar2(100) -- 网点机构编号
    ,pkg_tran_status_cd varchar2(30) -- 包交易状态代码
    ,cont_pkg_idf_cd varchar2(30) -- 往来包标识代码
    ,init_pkg_init_clear_bk_no varchar2(60) -- 原包发起清算行行号
    ,init_pkg_entr_dt date -- 原包委托日期
    ,init_pkg_midgrod_flow_num varchar2(100) -- 原包中台流水号
    ,init_pkg_seq_num varchar2(60) -- 原包序号
    ,reg_bus_batch_no varchar2(60) -- 定期业务批次号
    ,init_pkg_proc_status_cd varchar2(30) -- 原包处理状态代码
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,send_flow_num varchar2(100) -- 发送流水号
    ,check_entry_status_cd varchar2(30) -- 对账状态代码
    ,check_entry_dt date -- 对账日期
    ,cntpty_sys_edit_cd varchar2(30) -- 对手系统版本代码
    ,entry_fail_flg varchar2(10) -- 记账失败标志
    ,proc_idf_cd varchar2(30) -- 处理标识代码
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
grant select on ${iml_schema}.evt_beps_tran_pkg_info_flow to ${icl_schema};
grant select on ${iml_schema}.evt_beps_tran_pkg_info_flow to ${idl_schema};
grant select on ${iml_schema}.evt_beps_tran_pkg_info_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_beps_tran_pkg_info_flow is '小额交易包信息流水';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_seq_num is '包序号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_entr_dt is '包委托日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_init_clear_bk_no is '包发起清算行行号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_init_clear_bk_rg_cd is '包发起清算行地区代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_recv_clear_bk_no is '包接收清算行行号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_recv_clear_bk_rg_code is '包接收清算行地区码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.bank_int_proc_status_cd is '行内处理状态代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.rtn_rcpt_day_tenor is '回执日期限';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.rtn_rcpt_dt is '回执日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.tot is '总笔数';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.tot_amt is '总金额';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.sucs_amt is '成功金额';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.fail_amt is '失败金额';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.offs_bal_num_site is '轧差场次';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.offs_bal_dt is '轧差日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.reissue_flg is '补发标志';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.brac_org_id is '网点机构编号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.pkg_tran_status_cd is '包交易状态代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.cont_pkg_idf_cd is '往来包标识代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.init_pkg_init_clear_bk_no is '原包发起清算行行号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.init_pkg_entr_dt is '原包委托日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.init_pkg_midgrod_flow_num is '原包中台流水号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.init_pkg_seq_num is '原包序号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.reg_bus_batch_no is '定期业务批次号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.init_pkg_proc_status_cd is '原包处理状态代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.send_flow_num is '发送流水号';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.cntpty_sys_edit_cd is '对手系统版本代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.entry_fail_flg is '记账失败标志';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.proc_idf_cd is '处理标识代码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_beps_tran_pkg_info_flow.etl_timestamp is 'ETL处理时间戳';
