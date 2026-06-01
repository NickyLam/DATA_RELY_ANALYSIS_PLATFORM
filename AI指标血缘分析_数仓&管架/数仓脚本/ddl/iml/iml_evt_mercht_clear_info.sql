/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_mercht_clear_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_mercht_clear_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_mercht_clear_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_clear_info(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,midgrod_tran_dt date -- 中台交易日期
    ,unionpay_tran_dt date -- 银联交易日期
    ,core_tran_dt date -- 核心交易日期
    ,clear_day_term date -- 清算日期
    ,midgrod_tran_flow_num varchar2(60) -- 中台交易流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,mercht_id varchar2(60) -- 商户编号
    ,acct_id varchar2(60) -- 账户编号
    ,org_id varchar2(60) -- 机构编号
    ,unionpay_org_id varchar2(60) -- 银联机构编号
    ,actl_enter_acct_id varchar2(60) -- 实际入账编号
    ,mercht_name varchar2(150) -- 商户名称
    ,sign_org_name varchar2(750) -- 签约机构名称
    ,expd_mercht_name varchar2(150) -- 拓展商名称
    ,tran_amt number(30,2) -- 交易金额
    ,mercht_serv_fee number(30,2) -- 商户服务费
    ,comm_fee number(30,2) -- 手续费
    ,consm_amt number(30,2) -- 消费金额
    ,rtn_goods_amt number(30,2) -- 退货金额
    ,consm_revs_amt number(30,2) -- 消费沖正金额
    ,rtn_goods_revs_amt number(30,2) -- 退货沖正金额
    ,debit_adj_amt number(30,2) -- 借记调整金额
    ,crdt_adj_amt number(30,2) -- 贷记调整金额
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,enter_acct_status_cd varchar2(10) -- 入账状态代码
    ,tran_tot number(30) -- 交易总笔数
    ,hxb_acct_flg varchar2(10) -- 我行账户标志
    ,postsc varchar2(750) -- 附言
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
grant select on ${iml_schema}.evt_mercht_clear_info to ${icl_schema};
grant select on ${iml_schema}.evt_mercht_clear_info to ${idl_schema};
grant select on ${iml_schema}.evt_mercht_clear_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_mercht_clear_info is '商户清算信息表';
comment on column ${iml_schema}.evt_mercht_clear_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_mercht_clear_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_mercht_clear_info.midgrod_tran_dt is '中台交易日期';
comment on column ${iml_schema}.evt_mercht_clear_info.unionpay_tran_dt is '银联交易日期';
comment on column ${iml_schema}.evt_mercht_clear_info.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_mercht_clear_info.clear_day_term is '清算日期';
comment on column ${iml_schema}.evt_mercht_clear_info.midgrod_tran_flow_num is '中台交易流水号';
comment on column ${iml_schema}.evt_mercht_clear_info.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_mercht_clear_info.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_mercht_clear_info.acct_id is '账户编号';
comment on column ${iml_schema}.evt_mercht_clear_info.org_id is '机构编号';
comment on column ${iml_schema}.evt_mercht_clear_info.unionpay_org_id is '银联机构编号';
comment on column ${iml_schema}.evt_mercht_clear_info.actl_enter_acct_id is '实际入账编号';
comment on column ${iml_schema}.evt_mercht_clear_info.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_mercht_clear_info.sign_org_name is '签约机构名称';
comment on column ${iml_schema}.evt_mercht_clear_info.expd_mercht_name is '拓展商名称';
comment on column ${iml_schema}.evt_mercht_clear_info.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_mercht_clear_info.mercht_serv_fee is '商户服务费';
comment on column ${iml_schema}.evt_mercht_clear_info.comm_fee is '手续费';
comment on column ${iml_schema}.evt_mercht_clear_info.consm_amt is '消费金额';
comment on column ${iml_schema}.evt_mercht_clear_info.rtn_goods_amt is '退货金额';
comment on column ${iml_schema}.evt_mercht_clear_info.consm_revs_amt is '消费沖正金额';
comment on column ${iml_schema}.evt_mercht_clear_info.rtn_goods_revs_amt is '退货沖正金额';
comment on column ${iml_schema}.evt_mercht_clear_info.debit_adj_amt is '借记调整金额';
comment on column ${iml_schema}.evt_mercht_clear_info.crdt_adj_amt is '贷记调整金额';
comment on column ${iml_schema}.evt_mercht_clear_info.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_mercht_clear_info.enter_acct_status_cd is '入账状态代码';
comment on column ${iml_schema}.evt_mercht_clear_info.tran_tot is '交易总笔数';
comment on column ${iml_schema}.evt_mercht_clear_info.hxb_acct_flg is '我行账户标志';
comment on column ${iml_schema}.evt_mercht_clear_info.postsc is '附言';
comment on column ${iml_schema}.evt_mercht_clear_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_mercht_clear_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_mercht_clear_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_mercht_clear_info.etl_timestamp is 'ETL处理时间戳';
