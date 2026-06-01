/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wph_repay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wph_repay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wph_repay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_repay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,dubil_id varchar2(100) -- 借据编号
    ,tran_dt date -- 交易日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,callbk_type_cd varchar2(30) -- 回收类型代码
    ,callbk_prod_way_cd varchar2(30) -- 回收产生方式代码
    ,callbk_amt number(30,2) -- 回收金额
    ,actl_repay_dt date -- 实际还款日期
    ,serv_fee_amt number(30,2) -- 服务费金额
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
grant select on ${iml_schema}.evt_wph_repay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wph_repay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wph_repay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wph_repay_flow is '唯品会还款流水';
comment on column ${iml_schema}.evt_wph_repay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wph_repay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wph_repay_flow.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_wph_repay_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wph_repay_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wph_repay_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_wph_repay_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_wph_repay_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_wph_repay_flow.callbk_type_cd is '回收类型代码';
comment on column ${iml_schema}.evt_wph_repay_flow.callbk_prod_way_cd is '回收产生方式代码';
comment on column ${iml_schema}.evt_wph_repay_flow.callbk_amt is '回收金额';
comment on column ${iml_schema}.evt_wph_repay_flow.actl_repay_dt is '实际还款日期';
comment on column ${iml_schema}.evt_wph_repay_flow.serv_fee_amt is '服务费金额';
comment on column ${iml_schema}.evt_wph_repay_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wph_repay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wph_repay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wph_repay_flow.etl_timestamp is 'ETL处理时间戳';
