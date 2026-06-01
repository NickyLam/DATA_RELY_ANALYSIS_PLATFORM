/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_discount_click_bag_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_discount_click_bag_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_discount_click_bag_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_discount_click_bag_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,dtl_ser_num varchar2(100) -- 明细序列号
    ,batch_ser_num varchar2(100) -- 批次序列号
    ,bill_ser_num varchar2(100) -- 票据序列号
    ,bill_id varchar2(100) -- 票据编号
    ,fac_val_amt number(30,2) -- 票面金额
    ,bill_exp_dt date -- 票据到期日期
    ,actl_exp_dt date -- 实际到期日期
    ,surp_tenor number(18,6) -- 剩余期限
    ,int_paybl number(30,2) -- 应付利息
    ,stl_amt number(30,2) -- 转贴现金额
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,valid_flg varchar2(10) -- 有效标志
    ,final_modif_tm timestamp -- 最后修改时间
    ,crdt_main_type_cd varchar2(30) -- 信用主体类型代码
    ,crdt_main_id varchar2(100) -- 信用主体编号
    ,bag_flg varchar2(10) -- 成交标志
    ,ctr_nt_ser_num varchar2(100) -- 成交单序列号
    ,ctr_nt_id varchar2(100) -- 成交单编号
    ,fir_buy_src_cd varchar2(30) -- 首次买入来源代码
    ,fir_cntpty_cust_id varchar2(100) -- 首次交易对手客户编号
    ,fir_cntpty_name varchar2(750) -- 首次交易对手名称
    ,fir_cntpty_ibank_no varchar2(100) -- 首次交易对手联行号
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
grant select on ${iml_schema}.evt_bill_discount_click_bag_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_bill_discount_click_bag_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_bill_discount_click_bag_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_discount_click_bag_dtl is '票据转贴现点击成交明细';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.dtl_ser_num is '明细序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.batch_ser_num is '批次序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.bill_ser_num is '票据序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.fac_val_amt is '票面金额';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.actl_exp_dt is '实际到期日期';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.surp_tenor is '剩余期限';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.int_paybl is '应付利息';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.stl_amt is '转贴现金额';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.crdt_main_type_cd is '信用主体类型代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.crdt_main_id is '信用主体编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.bag_flg is '成交标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.ctr_nt_ser_num is '成交单序列号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.fir_buy_src_cd is '首次买入来源代码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.fir_cntpty_cust_id is '首次交易对手客户编号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.fir_cntpty_name is '首次交易对手名称';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.fir_cntpty_ibank_no is '首次交易对手联行号';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_discount_click_bag_dtl.etl_timestamp is 'ETL处理时间戳';
