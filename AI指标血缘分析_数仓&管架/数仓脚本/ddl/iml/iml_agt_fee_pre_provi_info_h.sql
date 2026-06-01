/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fee_pre_provi_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fee_pre_provi_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fee_pre_provi_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_pre_provi_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,pre_provi_amort_id varchar2(100) -- 预提摊销编号
    ,pre_provi_dt date -- 预提日期
    ,pre_provi_status_cd varchar2(30) -- 预提状态代码
    ,subj_id varchar2(100) -- 科目编号
    ,fee_rat_cd varchar2(30) -- 费率代码
    ,td_pre_provi_amt number(30,2) -- 当日预提金额
    ,pre_provi_tot_amt number(30,2) -- 预提总金额
    ,acm_aldy_pre_provi_amt number(30,2) -- 累计已预提金额
    ,expns_amt number(30,2) -- 可支出金额
    ,aldy_expns_amt number(30,2) -- 已支出金额
    ,provi_amt_bal number(30,8) -- 计提金额差额
    ,amort_tenor_type_cd varchar2(30) -- 摊销期限类型代码
    ,amort_day number(10) -- 摊销日
    ,amort_mon number(10) -- 摊销月
    ,add_acct_dt date -- 补账日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,oper_dt date -- 操作日期
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,org_id varchar2(100) -- 机构编号
    ,init_bus_id varchar2(100) -- 原业务编号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,curr_cd varchar2(30) -- 币种代码
    ,int_heavy_begin_dt date -- 利息重算起始日期
    ,heavy_int_tot_amt number(30,2) -- 重算利息总金额
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(500) -- 客户经理姓名
    ,cntpty_cust_id varchar2(100) -- 对手客户编号
    ,cntpty_cust_name varchar2(500) -- 对手客户名称
    ,cntpty_bus_id varchar2(250) -- 对手业务编号
    ,CNTPTY_TYPE_CD varchar2(30) -- 交易对手客户类型代码
    ,remark varchar2(1000) -- 备注
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
grant select on ${iml_schema}.agt_fee_pre_provi_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_fee_pre_provi_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_fee_pre_provi_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fee_pre_provi_info_h is '费用预提信息历史';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.pre_provi_amort_id is '预提摊销编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.pre_provi_dt is '预提日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.pre_provi_status_cd is '预提状态代码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.subj_id is '科目编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.fee_rat_cd is '费率代码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.td_pre_provi_amt is '当日预提金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.pre_provi_tot_amt is '预提总金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.acm_aldy_pre_provi_amt is '累计已预提金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.expns_amt is '可支出金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.aldy_expns_amt is '已支出金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.provi_amt_bal is '计提金额差额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.amort_tenor_type_cd is '摊销期限类型代码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.amort_day is '摊销日';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.amort_mon is '摊销月';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.add_acct_dt is '补账日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.oper_dt is '操作日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.init_bus_id is '原业务编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.int_heavy_begin_dt is '利息重算起始日期';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.heavy_int_tot_amt is '重算利息总金额';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cust_mgr_name is '客户经理姓名';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cntpty_cust_id is '对手客户编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cntpty_cust_name is '对手客户名称';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.cntpty_bus_id is '对手业务编号';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.CNTPTY_TYPE_CD is '交易对手客户类型代码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.remark is '备注';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fee_pre_provi_info_h.etl_timestamp is 'ETL处理时间戳';
