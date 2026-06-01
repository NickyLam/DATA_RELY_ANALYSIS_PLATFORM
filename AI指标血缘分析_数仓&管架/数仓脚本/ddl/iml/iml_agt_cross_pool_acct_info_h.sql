/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cross_pool_acct_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cross_pool_acct_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cross_pool_acct_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cross_pool_acct_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,init_agt_id varchar2(100) -- 原协议编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(375) -- 账户名称
    ,net_flow_in_lmt number(30,2) -- 净流入额度
    ,used_lmt number(30,2) -- 已使用额度
    ,insto_dt date -- 入库日期
    ,agt_status_cd varchar2(30) -- 协议状态代码
    ,final_modif_tm timestamp -- 最后修改时间
    ,cust_id varchar2(100) -- 客户编号
    ,tran_flow_num varchar2(100) -- 交易流水号
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
grant select on ${iml_schema}.agt_cross_pool_acct_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_cross_pool_acct_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_cross_pool_acct_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cross_pool_acct_info_h is '跨境资金池账户信息历史';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.init_agt_id is '原协议编号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.net_flow_in_lmt is '净流入额度';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.used_lmt is '已使用额度';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.insto_dt is '入库日期';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.agt_status_cd is '协议状态代码';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cross_pool_acct_info_h.etl_timestamp is 'ETL处理时间戳';
