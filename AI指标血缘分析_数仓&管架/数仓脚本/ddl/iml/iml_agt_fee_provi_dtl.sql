/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fee_provi_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fee_provi_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fee_provi_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_provi_dtl(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,provi_flow_num varchar2(100) -- 计提流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,init_bus_id varchar2(100) -- 原业务编号
    ,tran_dt date -- 交易日期
    ,curr_cd varchar2(30) -- 币种代码
    ,int_amt number(30,2) -- 利息金额
    ,provi_status_cd varchar2(30) -- 计提状态代码
    ,provi_fee_type_cd varchar2(30) -- 计提费用类型代码
    ,provi_start_dt date -- 计提开始日期
    ,provi_end_dt date -- 计提结束日期
    ,provi_dt date -- 计提日期
    ,provi_int number(30,2) -- 计提利息
    ,provi_day_actl_provi_amt number(30,8) -- 计提日实际计提金额
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,freq_cd varchar2(30) -- 频率代码
    ,acm_provi_amt number(30,2) -- 累计计提金额
    ,wrt_off_int number(30,2) -- 核销利息
    ,int_a_calc_start_dt date -- 利息重算开始日期
    ,a_calc_int_tot_amt number(30,2) -- 重算利息总金额
    ,next_provi_dt date -- 下一计提日期
    ,cntpty_bus_id varchar2(250) -- 对手业务编号
    ,cntpty_cust_id varchar2(100) -- 对手客户编号
    ,cntpty_cust_name varchar2(500) -- 对手客户名称
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(500) -- 客户经理名称
    ,tran_tm date -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,core_tran_org_id varchar2(100) -- 核心交易机构编号
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
grant select on ${iml_schema}.agt_fee_provi_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_fee_provi_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_fee_provi_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fee_provi_dtl is '费用计提明细';
comment on column ${iml_schema}.agt_fee_provi_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_flow_num is '计提流水号';
comment on column ${iml_schema}.agt_fee_provi_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_fee_provi_dtl.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_fee_provi_dtl.int_amt is '利息金额';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_status_cd is '计提状态代码';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_fee_type_cd is '计提费用类型代码';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_start_dt is '计提开始日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_end_dt is '计提结束日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_dt is '计提日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_int is '计提利息';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_day_actl_provi_amt is '计提日实际计提金额';
comment on column ${iml_schema}.agt_fee_provi_dtl.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.agt_fee_provi_dtl.freq_cd is '频率代码';
comment on column ${iml_schema}.agt_fee_provi_dtl.acm_provi_amt is '累计计提金额';
comment on column ${iml_schema}.agt_fee_provi_dtl.wrt_off_int is '核销利息';
comment on column ${iml_schema}.agt_fee_provi_dtl.int_a_calc_start_dt is '利息重算开始日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.a_calc_int_tot_amt is '重算利息总金额';
comment on column ${iml_schema}.agt_fee_provi_dtl.next_provi_dt is '下一计提日期';
comment on column ${iml_schema}.agt_fee_provi_dtl.cntpty_bus_id is '对手业务编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.cntpty_cust_id is '对手客户编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.cntpty_cust_name is '对手客户名称';
comment on column ${iml_schema}.agt_fee_provi_dtl.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.cust_mgr_name is '客户经理名称';
comment on column ${iml_schema}.agt_fee_provi_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_fee_provi_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.core_tran_org_id is '核心交易机构编号';
comment on column ${iml_schema}.agt_fee_provi_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fee_provi_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fee_provi_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fee_provi_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fee_provi_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fee_provi_dtl.etl_timestamp is 'ETL处理时间戳';
