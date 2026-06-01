/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_cap_stl_instr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_cap_stl_instr_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_cap_stl_instr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_cap_stl_instr_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,cap_instr_seq_num varchar2(100) -- 资金指令序号
    ,main_instr_seq_num varchar2(100) -- 主指令序号
    ,level2_cap_acct_id varchar2(100) -- 二级资金账户编号
    ,level1_cap_acct_id varchar2(100) -- 一级资金账户编号
    ,cap_flow_dir_cd varchar2(30) -- 资金流向代码
    ,curr_cd varchar2(30) -- 币种代码
    ,chg_qtty number(38,8) -- 变动数量
    ,froz_qtty number(38,8) -- 冻结数量
    ,stl_dt date -- 结算日期
    ,actl_stl_dt date -- 实际结算日期
    ,tran_way_cd varchar2(30) -- 转账方式代码
    ,ghb_bank_acct_num varchar2(200) -- 本方银行账户编号
    ,ghb_bank_acct_name varchar2(750) -- 本方银行账户名称
    ,ghb_open_bank_num varchar2(200) -- 本方开户行号
    ,ghb_open_bank_name varchar2(750) -- 本方开户行名称
    ,cntpty_bank_no varchar2(200) -- 交易对手银行行号
    ,cntpty_bank_acct_num varchar2(200) -- 对手银行账号
    ,cntpty_acct_name varchar2(750) -- 交易对手账户名称
    ,cntpty_open_bank_num varchar2(200) -- 交易对手开户行号
    ,cntpty_open_bank_name varchar2(750) -- 交易对手开户行名称
    ,oper_tm timestamp -- 经办时间
    ,operr_name varchar2(750) -- 经办人名称
    ,merge_acpt_pay_id varchar2(100) -- 合并收付编号
    ,remark varchar2(1500) -- 备注
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
grant select on ${iml_schema}.evt_ibank_cap_stl_instr_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_cap_stl_instr_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_cap_stl_instr_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_cap_stl_instr_dtl is '同业资金指令明细';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cap_instr_seq_num is '资金指令序号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.main_instr_seq_num is '主指令序号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.level2_cap_acct_id is '二级资金账户编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.level1_cap_acct_id is '一级资金账户编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cap_flow_dir_cd is '资金流向代码';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.chg_qtty is '变动数量';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.froz_qtty is '冻结数量';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.stl_dt is '结算日期';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.actl_stl_dt is '实际结算日期';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.tran_way_cd is '转账方式代码';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.ghb_bank_acct_num is '本方银行账户编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.ghb_bank_acct_name is '本方银行账户名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.ghb_open_bank_num is '本方开户行号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.ghb_open_bank_name is '本方开户行名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cntpty_bank_no is '交易对手银行行号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cntpty_bank_acct_num is '对手银行账号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cntpty_open_bank_num is '交易对手开户行号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.cntpty_open_bank_name is '交易对手开户行名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.oper_tm is '经办时间';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.operr_name is '经办人名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.merge_acpt_pay_id is '合并收付编号';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.remark is '备注';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_cap_stl_instr_dtl.etl_timestamp is 'ETL处理时间戳';
