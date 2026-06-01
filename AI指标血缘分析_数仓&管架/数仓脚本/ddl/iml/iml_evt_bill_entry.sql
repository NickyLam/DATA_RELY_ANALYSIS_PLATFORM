/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_entry
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_entry(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entry_bill_id varchar2(60) -- 记账票据编号
    ,hq_org_id varchar2(60) -- 总行机构编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,entry_tran_num varchar2(60) -- 记账交易号
    ,prod_id varchar2(60) -- 产品编号
    ,cont_id varchar2(60) -- 合同编号
    ,agt_id varchar2(60) -- 协议编号
    ,bus_id varchar2(60) -- 业务编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,int_accr_exp_dt date -- 计息到期日期
    ,int_accr_days number(10) -- 计息天数
    ,interest number(30,2) -- 利息
    ,fac_val_amt number(30,2) -- 票面金额
    ,buyer_pay_int_amt number(30,2) -- 买方付息金额
    ,actl_recv_amt number(30,2) -- 实收金额
    ,actl_amt number(30,2) -- 贴现金额
    ,comm_fee number(30,2) -- 手续费
    ,todos number(30,2) -- 工本费
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,intfc_return_code varchar2(90) -- 接口返回码
    ,intfc_return_type_cd varchar2(60) -- 接口返回类型代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,entry_tm timestamp -- 记账时间
    ,update_tm timestamp -- 更新时间
    ,final_modif_operr_id varchar2(60) -- 最后修改操作员编号
    ,rgst_cter_ccution_id varchar2(60) -- 登记中心流转编号
    ,bank_core_entry_flow_num varchar2(100) -- 银行核心记账流水号
    ,fin_org_id varchar2(60) -- 财务机构编号
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
    ,h_data_flg varchar2(100) -- 历史数据标志
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
grant select on ${iml_schema}.evt_bill_entry to ${icl_schema};
grant select on ${iml_schema}.evt_bill_entry to ${idl_schema};
grant select on ${iml_schema}.evt_bill_entry to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_entry is '票据记账事件';
comment on column ${iml_schema}.evt_bill_entry.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_entry.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_entry.entry_bill_id is '记账票据编号';
comment on column ${iml_schema}.evt_bill_entry.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_bill_entry.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_bill_entry.entry_tran_num is '记账交易号';
comment on column ${iml_schema}.evt_bill_entry.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_entry.cont_id is '合同编号';
comment on column ${iml_schema}.evt_bill_entry.agt_id is '协议编号';
comment on column ${iml_schema}.evt_bill_entry.bus_id is '业务编号';
comment on column ${iml_schema}.evt_bill_entry.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bill_entry.bill_num is '票据号码';
comment on column ${iml_schema}.evt_bill_entry.int_accr_exp_dt is '计息到期日期';
comment on column ${iml_schema}.evt_bill_entry.int_accr_days is '计息天数';
comment on column ${iml_schema}.evt_bill_entry.interest is '利息';
comment on column ${iml_schema}.evt_bill_entry.fac_val_amt is '票面金额';
comment on column ${iml_schema}.evt_bill_entry.buyer_pay_int_amt is '买方付息金额';
comment on column ${iml_schema}.evt_bill_entry.actl_recv_amt is '实收金额';
comment on column ${iml_schema}.evt_bill_entry.actl_amt is '贴现金额';
comment on column ${iml_schema}.evt_bill_entry.comm_fee is '手续费';
comment on column ${iml_schema}.evt_bill_entry.todos is '工本费';
comment on column ${iml_schema}.evt_bill_entry.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_bill_entry.intfc_return_code is '接口返回码';
comment on column ${iml_schema}.evt_bill_entry.intfc_return_type_cd is '接口返回类型代码';
comment on column ${iml_schema}.evt_bill_entry.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_entry.entry_tm is '记账时间';
comment on column ${iml_schema}.evt_bill_entry.update_tm is '更新时间';
comment on column ${iml_schema}.evt_bill_entry.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_bill_entry.rgst_cter_ccution_id is '登记中心流转编号';
comment on column ${iml_schema}.evt_bill_entry.bank_core_entry_flow_num is '银行核心记账流水号';
comment on column ${iml_schema}.evt_bill_entry.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.evt_bill_entry.bill_sub_intrv_id is '票据子区间号';
comment on column ${iml_schema}.evt_bill_entry.h_data_flg is '历史数据标志';
comment on column ${iml_schema}.evt_bill_entry.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bill_entry.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_entry.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_entry.etl_timestamp is 'ETL处理时间戳';
