/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_acct_ety_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_acct_ety_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_acct_ety_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_acct_ety_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,vouch_id varchar2(100) -- 凭证编号
    ,task_id varchar2(100) -- 任务编号
    ,vouch_dt date -- 凭证日期
    ,entry_flow_num varchar2(100) -- 分录流水号
    ,chg_id varchar2(100) -- 变动编号
    ,instr_id varchar2(100) -- 指令编号
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,entry_org_id varchar2(100) -- 记账机构编号
    ,subj_id varchar2(100) -- 科目编号
    ,intnal_acct_seq_num varchar2(60) -- 内部账序号
    ,core_acct_id varchar2(100) -- 核心账户编号
    ,entry_type_cd varchar2(30) -- 记账类型代码
    ,rbw_flg_cd varchar2(30) -- 冲补抹标志
    ,suspd_wrtoff_way_cd varchar2(30) -- 挂销账方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,entry_amt number(30,2) -- 记账金额
    ,sys_status_cd varchar2(30) -- 系统状态代码
    ,send_core_acct_flg varchar2(10) -- 发送核心账号标志
    ,accti_type_cd varchar2(30) -- 核算类型代码
    ,remark varchar2(375) -- 备注
    ,core_acct_name varchar2(375) -- 核心账户名称
    ,merge_flow_num varchar2(100) -- 合并流水号
    ,accti_obj_id varchar2(100) -- 核算对象编号
    ,chg_type_cd varchar2(30) -- 变动类型代码
    ,dtl_flg varchar2(10) -- 明细标志
    ,src_data_type_cd varchar2(30) -- 源数据类型代码
    ,send_accti_status_cd varchar2(30) -- 发送核算状态代码
    ,manual_vouch_flg varchar2(10) -- 手工凭证标志
    ,tax_type_cd varchar2(30) -- 征税类型代码
    ,tax_fee number(31,8) -- 税费
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,prod_id varchar2(100) -- 产品编号
    ,free_tax_id varchar2(100) -- 免税编号
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
grant select on ${iml_schema}.evt_ibank_acct_ety_evt to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_acct_ety_evt to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_acct_ety_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_acct_ety_evt is '同业会计分录事件';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.task_id is '任务编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.vouch_dt is '凭证日期';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.entry_flow_num is '分录流水号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.chg_id is '变动编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.instr_id is '指令编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.entry_org_id is '记账机构编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.subj_id is '科目编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.intnal_acct_seq_num is '内部账序号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.core_acct_id is '核心账户编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.entry_type_cd is '记账类型代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.rbw_flg_cd is '冲补抹标志';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.suspd_wrtoff_way_cd is '挂销账方式代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.entry_amt is '记账金额';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.sys_status_cd is '系统状态代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.send_core_acct_flg is '发送核心账号标志';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.accti_type_cd is '核算类型代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.remark is '备注';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.core_acct_name is '核心账户名称';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.merge_flow_num is '合并流水号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.accti_obj_id is '核算对象编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.chg_type_cd is '变动类型代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.dtl_flg is '明细标志';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.src_data_type_cd is '源数据类型代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.send_accti_status_cd is '发送核算状态代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.manual_vouch_flg is '手工凭证标志';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.tax_type_cd is '征税类型代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.tax_fee is '税费';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.prod_id is '产品编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.free_tax_id is '免税编号';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_acct_ety_evt.etl_timestamp is 'ETL处理时间戳';
