/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_decl_info_status_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_decl_info_status_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_decl_info_status_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_decl_info_status_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,status_id varchar2(100) -- 状态编号
    ,edit_id varchar2(100) -- 版本编号
    ,temp_decl_flow_num varchar2(100) -- 临时申报流水号
    ,init_enty_id varchar2(100) -- 原始实体编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,rela_table_name varchar2(750) -- 关联表名称
    ,rela_decl_id varchar2(100) -- 关联申报编号
    ,decl_num varchar2(60) -- 申报号码
    ,trade_gen_cd varchar2(30) -- 贸易大类代码
    ,money_idf_cd varchar2(30) -- 款项标识代码
    ,base_info_status_cd varchar2(30) -- 基础信息状态代码
    ,decl_info_status_cd varchar2(30) -- 申报信息状态代码
    ,wrt_off_info_status_cd varchar2(30) -- 核销信息状态代码
    ,yga_e_acct_info_status_cd varchar2(30) -- 粤港电子账户信息状态代码
    ,bus_oper_teller_id varchar2(100) -- 业务经办人编号
    ,auth_dt date -- 授权日期
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
grant select on ${iml_schema}.agt_decl_info_status_h to ${icl_schema};
grant select on ${iml_schema}.agt_decl_info_status_h to ${idl_schema};
grant select on ${iml_schema}.agt_decl_info_status_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_decl_info_status_h is '申报信息状态历史';
comment on column ${iml_schema}.agt_decl_info_status_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_decl_info_status_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_decl_info_status_h.status_id is '状态编号';
comment on column ${iml_schema}.agt_decl_info_status_h.edit_id is '版本编号';
comment on column ${iml_schema}.agt_decl_info_status_h.temp_decl_flow_num is '临时申报流水号';
comment on column ${iml_schema}.agt_decl_info_status_h.init_enty_id is '原始实体编号';
comment on column ${iml_schema}.agt_decl_info_status_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_decl_info_status_h.rela_table_name is '关联表名称';
comment on column ${iml_schema}.agt_decl_info_status_h.rela_decl_id is '关联申报编号';
comment on column ${iml_schema}.agt_decl_info_status_h.decl_num is '申报号码';
comment on column ${iml_schema}.agt_decl_info_status_h.trade_gen_cd is '贸易大类代码';
comment on column ${iml_schema}.agt_decl_info_status_h.money_idf_cd is '款项标识代码';
comment on column ${iml_schema}.agt_decl_info_status_h.base_info_status_cd is '基础信息状态代码';
comment on column ${iml_schema}.agt_decl_info_status_h.decl_info_status_cd is '申报信息状态代码';
comment on column ${iml_schema}.agt_decl_info_status_h.wrt_off_info_status_cd is '核销信息状态代码';
comment on column ${iml_schema}.agt_decl_info_status_h.yga_e_acct_info_status_cd is '粤港电子账户信息状态代码';
comment on column ${iml_schema}.agt_decl_info_status_h.bus_oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_decl_info_status_h.auth_dt is '授权日期';
comment on column ${iml_schema}.agt_decl_info_status_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_decl_info_status_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_decl_info_status_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_decl_info_status_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_decl_info_status_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_decl_info_status_h.etl_timestamp is 'ETL处理时间戳';
