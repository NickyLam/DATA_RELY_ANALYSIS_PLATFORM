/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_discount_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_discount_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_discount_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_discount_dtl(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,discount_dtl_id varchar2(60) -- 转贴现明细编号
    ,cont_id varchar2(60) -- 合同编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_amt number(30,2) -- 贴现票据金额
    ,bill_exp_dt date -- 票据到期日期
    ,actl_exp_dt date -- 实际到期日期
    ,surp_tenor number(10) -- 剩余期限
    ,exp_surp_tenor number(10) -- 到期剩余期限
    ,int_paybl number(30,2) -- 应付利息
    ,exp_int_paybl number(30,2) -- 到期应付利息
    ,stl_amt number(30,2) -- 转贴现金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,lmt_ocup_status_cd varchar2(10) -- 额度占用状态代码
    ,proc_status_cd varchar2(10) -- 处理状态代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,valid_flg varchar2(10) -- 有效标志
    ,crdt_main_type_cd varchar2(30) -- 信用主体类型代码
    ,crdt_main_id varchar2(60) -- 信用主体编号
    ,bill_intrv_std_amt number(30,2) -- 票据区间标准金额
    ,bf_split_intrv_id varchar2(60) -- 拆前区间编号
    ,init_bill_amt number(30,2) -- 原始票据金额
    ,bill_num varchar2(60) -- 票据号码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
    ,fir_buy_src_cd varchar2(30) -- 首次买入来源代码
    ,fir_cntpty_cust_id varchar2(100) -- 首次交易对手客户编号
    ,fir_cntpty_name varchar2(750) -- 首次交易对手名称
    ,fir_cntpty_ibank_no varchar2(100) -- 首次交易对手联行号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_bill_discount_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_bill_discount_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_bill_discount_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_discount_dtl is '票据转贴现明细';
comment on column ${iml_schema}.agt_bill_discount_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.discount_dtl_id is '转贴现明细编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.cont_id is '合同编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_id is '票据编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_amt is '贴现票据金额';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.agt_bill_discount_dtl.actl_exp_dt is '实际到期日期';
comment on column ${iml_schema}.agt_bill_discount_dtl.surp_tenor is '剩余期限';
comment on column ${iml_schema}.agt_bill_discount_dtl.exp_surp_tenor is '到期剩余期限';
comment on column ${iml_schema}.agt_bill_discount_dtl.int_paybl is '应付利息';
comment on column ${iml_schema}.agt_bill_discount_dtl.exp_int_paybl is '到期应付利息';
comment on column ${iml_schema}.agt_bill_discount_dtl.stl_amt is '转贴现金额';
comment on column ${iml_schema}.agt_bill_discount_dtl.exp_stl_amt is '到期结算金额';
comment on column ${iml_schema}.agt_bill_discount_dtl.lmt_ocup_status_cd is '额度占用状态代码';
comment on column ${iml_schema}.agt_bill_discount_dtl.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.agt_bill_discount_dtl.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_bill_discount_dtl.valid_flg is '有效标志';
comment on column ${iml_schema}.agt_bill_discount_dtl.crdt_main_type_cd is '信用主体类型代码';
comment on column ${iml_schema}.agt_bill_discount_dtl.crdt_main_id is '信用主体编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_intrv_std_amt is '票据区间标准金额';
comment on column ${iml_schema}.agt_bill_discount_dtl.bf_split_intrv_id is '拆前区间编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.init_bill_amt is '原始票据金额';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_num is '票据号码';
comment on column ${iml_schema}.agt_bill_discount_dtl.bill_sub_intrv_id is '票据子区间号';
comment on column ${iml_schema}.agt_bill_discount_dtl.fir_buy_src_cd is '首次买入来源代码';
comment on column ${iml_schema}.agt_bill_discount_dtl.fir_cntpty_cust_id is '首次交易对手客户编号';
comment on column ${iml_schema}.agt_bill_discount_dtl.fir_cntpty_name is '首次交易对手名称';
comment on column ${iml_schema}.agt_bill_discount_dtl.fir_cntpty_ibank_no is '首次交易对手联行号';
comment on column ${iml_schema}.agt_bill_discount_dtl.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bill_discount_dtl.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bill_discount_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bill_discount_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_discount_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_discount_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_discount_dtl.etl_timestamp is 'ETL处理时间戳';
