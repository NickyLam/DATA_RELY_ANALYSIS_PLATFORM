/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bigamt_cash_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bigamt_cash_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bigamt_cash_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bigamt_cash_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,core_flow_num varchar2(200) -- 核心流水号
    ,acct_name varchar2(500) -- 账户名称
    ,tran_card_id varchar2(100) -- 交易卡编号
    ,dep_draw_type_cd varchar2(30) -- 存取款类型代码
    ,dep_draw_type_comnt varchar2(500) -- 存取款类型说明
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_dt date -- 交易日期
    ,modif_dt date -- 修改日期
    ,org_id varchar2(100) -- 机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,modif_teller_id varchar2(100) -- 修改柜员编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,bigamt_cash_precon_id varchar2(100) -- 大额取现预约编号
    ,indus_categy_cd varchar2(30) -- 行业门类代码
    ,indus_gen_cd varchar2(30) -- 行业大类代码
    ,indus_middle_class_cd varchar2(30) -- 行业中类代码
    ,indus_sclass_cd varchar2(30) -- 行业小类代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,redt_amt_tot number(30,2) -- 转存金额汇总
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,agent_type_cd varchar2(30) -- 代理类型代码
    ,agent_cert_type_cd varchar2(30) -- 代理人证件类型代码
    ,agent_cert_no varchar2(200) -- 代理人证件号码
    ,agent_name varchar2(500) -- 代理人姓名
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.evt_bigamt_cash_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_bigamt_cash_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_bigamt_cash_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bigamt_cash_tran_dtl is '大额现金存取交易明细';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.flow_num is '流水号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_card_id is '交易卡编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.dep_draw_type_cd is '存取款类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.dep_draw_type_comnt is '存取款类型说明';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.modif_dt is '修改日期';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.org_id is '机构编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.modif_teller_id is '修改柜员编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.bigamt_cash_precon_id is '大额取现预约编号';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.indus_categy_cd is '行业门类代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.indus_gen_cd is '行业大类代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.indus_middle_class_cd is '行业中类代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.indus_sclass_cd is '行业小类代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.redt_amt_tot is '转存金额汇总';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.agent_type_cd is '代理类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.agent_cert_no is '代理人证件号码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.agent_name is '代理人姓名';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bigamt_cash_tran_dtl.etl_timestamp is 'ETL处理时间戳';
