/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_m6_noth_tran_list_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_m6_noth_tran_list_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_m6_noth_tran_list_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_m6_noth_tran_list_h(
    agt_id varchar2(250) -- 协议编号
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,doubt_acct_vrif_status_cd varchar2(30) -- 可疑账户核实状态代码
    ,sync_dt date -- 同步日期
    ,effect_dt date -- 生效日期
    ,input_org_id varchar2(100) -- 录入机构编号
    ,blklist_id varchar2(100) -- 黑名单编号
    ,blklist_check_tm timestamp -- 黑名单检查时间
    ,blklist_cust_flg varchar2(10) -- 黑名单客户标志
    ,teller_id varchar2(100) -- 柜员编号
    ,list_src_cd varchar2(30) -- 名单来源代码
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
grant select on ${iml_schema}.agt_m6_noth_tran_list_h to ${icl_schema};
grant select on ${iml_schema}.agt_m6_noth_tran_list_h to ${idl_schema};
grant select on ${iml_schema}.agt_m6_noth_tran_list_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_m6_noth_tran_list_h is '六个月无交易名单历史';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.doubt_acct_vrif_status_cd is '可疑账户核实状态代码';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.sync_dt is '同步日期';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.input_org_id is '录入机构编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.blklist_id is '黑名单编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.blklist_check_tm is '黑名单检查时间';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.blklist_cust_flg is '黑名单客户标志';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.list_src_cd is '名单来源代码';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_m6_noth_tran_list_h.etl_timestamp is 'ETL处理时间戳';
