/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_tran_instr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_tran_instr_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_tran_instr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_tran_instr_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,instr_seq_num number(22) -- 指令序号
    ,parent_instr_seq_num number(22) -- 父指令序号
    ,ext_instr_seq_num varchar2(60) -- 外部指令序号
    ,rela_cap_instr_seq_num number(22) -- 关联资金指令序号
    ,rela_vch_instr_seq_num number(22) -- 关联券指令序号
    ,rela_main_instr_seq_num number(22) -- 关联主指令序号
    ,actl_accti_main_seq_num number(22) -- 实际核算主指令序号
    ,adj_entry_main_seq_num number(22) -- 调账主指令序号
    ,intnal_tran_flow_num varchar2(60) -- 内部交易流水号
    ,obj_id varchar2(60) -- 对象编号
    ,instr_bus_type_cd varchar2(30) -- 指令业务类型代码
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,intnal_cap_acct_id varchar2(60) -- 内部资金账户编号
    ,parent_instm_market_type_id varchar2(60) -- 父金融工具市场类型编号
    ,parent_instm_asset_type_id varchar2(60) -- 父金融工具资产类型编号
    ,parent_fin_instm_id varchar2(60) -- 父金融工具编号
    ,instr_type_cd varchar2(10) -- 指令类型代码
    ,instr_status_cd number(22) -- 指令状态代码
    ,acpt_pay_instr_cd varchar2(10) -- 收付款指令代码
    ,tran_bus_type_cd varchar2(10) -- 交易业务类型代码
    ,stl_way_cd varchar2(20) -- 结算方式代码
    ,stl_type_cd varchar2(10) -- 结算类型代码
    ,apv_status_cd varchar2(10) -- 审批状态代码
    ,actl_rp_flg varchar2(10) -- 实收付标志
    ,clear_flow_flg varchar2(10) -- 清算流水标志
    ,surviv_term_flg varchar2(10) -- 存续期标志
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(375) -- 交易对手名称
    ,exec_market_id varchar2(60) -- 执行市场编号
    ,memo_info varchar2(750) -- 摘要信息
    ,theory_clear_dt date -- 理论清算日期
    ,theory_stl_dt date -- 理论结算日期
    ,actl_stl_dt date -- 实际结算日期
    ,tran_dt date -- 交易日期
    ,cfm_dt date -- 确认日期
    ,repay_dt date -- 还款日期
    ,final_mender_id varchar2(60) -- 最后修改人编号
    ,final_mender_name varchar2(150) -- 最后修改人名称
    ,checker_id varchar2(60) -- 复核人编号
    ,operr_id varchar2(60) -- 经办人编号
    ,operr_name varchar2(150) -- 经办人名称
    ,curr_cd varchar2(10) -- 币种代码
    ,acru_int number(30,8) -- 应计利息
    ,pric_bal number(30,8) -- 本金余额
    ,recvbl_uncol_int number(30,8) -- 应收未收利息
    ,recvbl_uncol_pric number(30,8) -- 应收未收本金
    ,chg_qtty number(30,8) -- 变动数量
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_ibank_tran_instr_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_tran_instr_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_tran_instr_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_tran_instr_dtl is '同业交易指令明细';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.instr_seq_num is '指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.parent_instr_seq_num is '父指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.ext_instr_seq_num is '外部指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.rela_cap_instr_seq_num is '关联资金指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.rela_vch_instr_seq_num is '关联券指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.rela_main_instr_seq_num is '关联主指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.actl_accti_main_seq_num is '实际核算主指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.adj_entry_main_seq_num is '调账主指令序号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.intnal_tran_flow_num is '内部交易流水号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.instr_bus_type_cd is '指令业务类型代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.parent_instm_market_type_id is '父金融工具市场类型编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.parent_instm_asset_type_id is '父金融工具资产类型编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.parent_fin_instm_id is '父金融工具编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.instr_type_cd is '指令类型代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.instr_status_cd is '指令状态代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.acpt_pay_instr_cd is '收付款指令代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.tran_bus_type_cd is '交易业务类型代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.stl_way_cd is '结算方式代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.stl_type_cd is '结算类型代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.apv_status_cd is '审批状态代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.actl_rp_flg is '实收付标志';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.clear_flow_flg is '清算流水标志';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.surviv_term_flg is '存续期标志';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.exec_market_id is '执行市场编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.memo_info is '摘要信息';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.theory_clear_dt is '理论清算日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.theory_stl_dt is '理论结算日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.actl_stl_dt is '实际结算日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.cfm_dt is '确认日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.repay_dt is '还款日期';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.final_mender_id is '最后修改人编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.final_mender_name is '最后修改人名称';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.checker_id is '复核人编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.operr_id is '经办人编号';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.operr_name is '经办人名称';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.recvbl_uncol_int is '应收未收利息';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.recvbl_uncol_pric is '应收未收本金';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.chg_qtty is '变动数量';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_tran_instr_dtl.etl_timestamp is 'ETL处理时间戳';
