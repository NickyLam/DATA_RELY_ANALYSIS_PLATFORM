/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ibank_tran_main_instr_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ibank_tran_main_instr_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ibank_tran_main_instr_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_tran_main_instr_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,main_instr_seq_num varchar2(100) -- 主指令序号
    ,instr_type_cd varchar2(60) -- 指令类型代码
    ,parent_fin_instm_market_type_id varchar2(100) -- 父金融工具市场类型编号
    ,parent_fin_instm_asset_type_id varchar2(100) -- 父金融工具资产类型编号
    ,parent_fin_instm_id varchar2(100) -- 父金融工具编号
    ,parent_instr_id varchar2(100) -- 父指令编号
    ,intnal_tran_flow_num varchar2(100) -- 内部交易流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,theory_clear_dt date -- 理论清算日期
    ,actl_stl_dt date -- 实际结算日期
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,apv_form_id varchar2(100) -- 审批单编号
    ,ext_bag_id varchar2(100) -- 外部成交编号
    ,exec_market_id varchar2(100) -- 执行市场编号
    ,theory_stl_dt date -- 理论结算日期
    ,cap_instr_id varchar2(100) -- 资金指令编号
    ,vch_instr_id varchar2(100) -- 券指令编号
    ,effect_tm timestamp -- 生效时间
    ,mender_name varchar2(750) -- 修改人名称
    ,mender_id varchar2(100) -- 修改人编号
    ,instr_status_cd varchar2(30) -- 指令状态代码
    ,not_price_flg varchar2(30) -- 未知价格标志
    ,intnal_cap_acct_id varchar2(100) -- 内部资金账户编号
    ,tran_dt date -- 交易日期
    ,stl_type_cd varchar2(30) -- 结算类型代码
    ,clear_cmplt_flg varchar2(30) -- 清算完成标志
    ,surviv_term_instr_flg varchar2(30) -- 存续期指令标志
    ,operr_id varchar2(100) -- 经办人编号
    ,operr_name varchar2(750) -- 经办人名称
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
grant select on ${iml_schema}.evt_ibank_tran_main_instr_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_ibank_tran_main_instr_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_ibank_tran_main_instr_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ibank_tran_main_instr_dtl is '同业主指令明细';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.main_instr_seq_num is '主指令序号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.instr_type_cd is '指令类型代码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.parent_fin_instm_market_type_id is '父金融工具市场类型编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.parent_fin_instm_asset_type_id is '父金融工具资产类型编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.parent_fin_instm_id is '父金融工具编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.parent_instr_id is '父指令编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.intnal_tran_flow_num is '内部交易流水号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.theory_clear_dt is '理论清算日期';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.actl_stl_dt is '实际结算日期';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.apv_form_id is '审批单编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.ext_bag_id is '外部成交编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.exec_market_id is '执行市场编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.theory_stl_dt is '理论结算日期';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.cap_instr_id is '资金指令编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.vch_instr_id is '券指令编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.effect_tm is '生效时间';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.mender_name is '修改人名称';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.mender_id is '修改人编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.instr_status_cd is '指令状态代码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.not_price_flg is '未知价格标志';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.stl_type_cd is '结算类型代码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.clear_cmplt_flg is '清算完成标志';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.surviv_term_instr_flg is '存续期指令标志';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.operr_id is '经办人编号';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.operr_name is '经办人名称';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ibank_tran_main_instr_dtl.etl_timestamp is 'ETL处理时间戳';
