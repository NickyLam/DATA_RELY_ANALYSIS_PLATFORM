/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intstl_fee_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intstl_fee_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intstl_fee_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_fee_h(
    fee_id varchar2(100) -- 收费编号
    ,lp_id varchar2(60) -- 法人编号
    ,fee_cd varchar2(30) -- 费用代码
    ,bus_table_name varchar2(750) -- 业务表名称
    ,agt_id varchar2(100) -- 协议编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,fee_comnt varchar2(750) -- 费用说明
    ,fee_coll_begin_dt date -- 费用收取起始日期
    ,fee_coll_closing_dt date -- 费用收取截止日期
    ,fee_coll_shares number(10) -- 费用收取份数
    ,avg_fee number(30,6) -- 平均费用
    ,fee_curr_cd varchar2(30) -- 费用币种代码
    ,fee_amt number(30,6) -- 费用金额
    ,fee_convt_curr_cd varchar2(30) -- 费用折后币种代码
    ,fee_convt_amt number(30,6) -- 费用折后金额
    ,fee_enter_id varchar2(100) -- 费用入账账户编号
    ,party_id varchar2(100) -- 当事人编号
    ,init_tran_flow_num varchar2(100) -- 初始交易流水号
    ,tran_dt date -- 交易日期
    ,stl_tran_flow_num varchar2(100) -- 结算交易流水号
    ,stl_dt date -- 结算日期
    ,role_type_cd varchar2(30) -- 角色类型代码
    ,recvbl_amt number(30,6) -- 应收金额
    ,prefr_amt number(30,6) -- 优惠金额
    ,provi_amort_type_cd varchar2(30) -- 计提摊销类型代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_intstl_fee_h to ${icl_schema};
grant select on ${iml_schema}.agt_intstl_fee_h to ${idl_schema};
grant select on ${iml_schema}.agt_intstl_fee_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intstl_fee_h is '国结费用历史';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_id is '收费编号';
comment on column ${iml_schema}.agt_intstl_fee_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_cd is '费用代码';
comment on column ${iml_schema}.agt_intstl_fee_h.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_intstl_fee_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intstl_fee_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_comnt is '费用说明';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_coll_begin_dt is '费用收取起始日期';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_coll_closing_dt is '费用收取截止日期';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_coll_shares is '费用收取份数';
comment on column ${iml_schema}.agt_intstl_fee_h.avg_fee is '平均费用';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_curr_cd is '费用币种代码';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_amt is '费用金额';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_convt_curr_cd is '费用折后币种代码';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_convt_amt is '费用折后金额';
comment on column ${iml_schema}.agt_intstl_fee_h.fee_enter_id is '费用入账账户编号';
comment on column ${iml_schema}.agt_intstl_fee_h.party_id is '当事人编号';
comment on column ${iml_schema}.agt_intstl_fee_h.init_tran_flow_num is '初始交易流水号';
comment on column ${iml_schema}.agt_intstl_fee_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_intstl_fee_h.stl_tran_flow_num is '结算交易流水号';
comment on column ${iml_schema}.agt_intstl_fee_h.stl_dt is '结算日期';
comment on column ${iml_schema}.agt_intstl_fee_h.role_type_cd is '角色类型代码';
comment on column ${iml_schema}.agt_intstl_fee_h.recvbl_amt is '应收金额';
comment on column ${iml_schema}.agt_intstl_fee_h.prefr_amt is '优惠金额';
comment on column ${iml_schema}.agt_intstl_fee_h.provi_amort_type_cd is '计提摊销类型代码';
comment on column ${iml_schema}.agt_intstl_fee_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_intstl_fee_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_intstl_fee_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intstl_fee_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intstl_fee_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intstl_fee_h.etl_timestamp is 'ETL处理时间戳';
