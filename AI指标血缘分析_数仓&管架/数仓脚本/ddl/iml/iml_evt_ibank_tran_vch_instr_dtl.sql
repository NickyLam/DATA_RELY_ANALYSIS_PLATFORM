/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_tran_vch_instr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_tran_vch_instr_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_tran_vch_instr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_vch_instr_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,secu_instr_seq_num varchar2(100) -- 券指令序号
    ,main_instr_seq_num varchar2(100) -- 主指令序号
    ,ext_vch_acct_id varchar2(100) -- 外部券账户编号
    ,intnal_vch_acct_id varchar2(100) -- 内部券账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,fin_instm_name varchar2(750) -- 金融工具名称
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,merge_acpt_pay_id varchar2(100) -- 合并收付编号
    ,cap_flow_dir_cd varchar2(30) -- 资金流向代码
    ,curr_cd varchar2(30) -- 币种代码
    ,fee_cost_chg number(38,8) -- 费用成本变动
    ,acru_int_cost_chg number(38,8) -- 应计利息成本变动
    ,actl_acru_int number(38,8) -- 实际应计利息
    ,actl_net_price_amt number(38,8) -- 实际净价金额
    ,recvbl_uncol_int number(38,8) -- 应收未收利息
    ,recvbl_uncol_pric number(38,8) -- 应收未收本金
    ,pl_fee number(38,8) -- 损益费用
    ,int_recvbl_resv_flg varchar2(30) -- 应收利息保留标志
    ,recvbl_pric_resv_flg varchar2(30) -- 应收本金保留标志
    ,bal_qtty_chg number(38,8) -- 余额数量变动
    ,froz_qtty number(38,8) -- 冻结数量
    ,calc_closing_dt date -- 计算截止日期
    ,stl_dt date -- 结算日期
    ,actl_stl_dt date -- 实际结算日期
    ,prod_cls_name varchar2(750) -- 产品分类名称
    ,full_price_cost_chg number(38,8) -- 全价成本变动
    ,ghb_zzd_trust_acct_num varchar2(300) -- 本方中债登托管账号
    ,cntpty_zzd_trust_acct_num varchar2(300) -- 对手中债登托管账号
    ,effect_tm timestamp -- 生效时间
    ,stl_denom number(38,8) -- 结算面额
    ,accti_tran_flow_num varchar2(100) -- 核算交易流水号
    ,theory_fee number(38,8) -- 理论费用
    ,fee_cost number(38,8) -- 费用成本
    ,accti_impam_obj_flg varchar2(30) -- 核算减值对象标志
    ,start_int_accr_dt date -- 开始计息日期
    ,expect_qtty number(38,8) -- 预计数量
    ,expect_denom number(38,8) -- 预计面额
    ,operr_name varchar2(750) -- 经办人名称
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
grant select on ${iml_schema}.evt_ibank_tran_vch_instr_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_tran_vch_instr_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_tran_vch_instr_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_tran_vch_instr_dtl is '同业券指令明细';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.secu_instr_seq_num is '券指令序号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.main_instr_seq_num is '主指令序号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.ext_vch_acct_id is '外部券账户编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.intnal_vch_acct_id is '内部券账户编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.fin_instm_name is '金融工具名称';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.market_type_id is '市场类型编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.merge_acpt_pay_id is '合并收付编号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.cap_flow_dir_cd is '资金流向代码';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.fee_cost_chg is '费用成本变动';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.acru_int_cost_chg is '应计利息成本变动';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.actl_acru_int is '实际应计利息';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.actl_net_price_amt is '实际净价金额';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.recvbl_uncol_int is '应收未收利息';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.recvbl_uncol_pric is '应收未收本金';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.pl_fee is '损益费用';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.int_recvbl_resv_flg is '应收利息保留标志';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.recvbl_pric_resv_flg is '应收本金保留标志';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.bal_qtty_chg is '余额数量变动';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.froz_qtty is '冻结数量';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.calc_closing_dt is '计算截止日期';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.stl_dt is '结算日期';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.actl_stl_dt is '实际结算日期';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.prod_cls_name is '产品分类名称';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.full_price_cost_chg is '全价成本变动';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.ghb_zzd_trust_acct_num is '本方中债登托管账号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.cntpty_zzd_trust_acct_num is '对手中债登托管账号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.effect_tm is '生效时间';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.stl_denom is '结算面额';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.accti_tran_flow_num is '核算交易流水号';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.theory_fee is '理论费用';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.fee_cost is '费用成本';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.accti_impam_obj_flg is '核算减值对象标志';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.start_int_accr_dt is '开始计息日期';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.expect_qtty is '预计数量';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.expect_denom is '预计面额';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.operr_name is '经办人名称';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.remark is '备注';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_tran_vch_instr_dtl.etl_timestamp is 'ETL处理时间戳';
