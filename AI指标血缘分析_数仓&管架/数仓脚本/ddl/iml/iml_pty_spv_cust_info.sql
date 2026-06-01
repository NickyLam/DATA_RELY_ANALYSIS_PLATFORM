/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_spv_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_spv_cust_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_spv_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_spv_cust_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,spv_cust_id varchar2(100) -- SPV客户编号
    ,spv_id varchar2(60) -- SPV编号
    ,spv_name varchar2(250) -- SPV名称
    ,spv_type_cd varchar2(30) -- SPV类型代码
    ,am_prod_stat_type_id varchar2(100) -- 资管产品统计类型编号
    ,cash_mgmt_prod_flg varchar2(10) -- 现金管理产品标志
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
grant select on ${iml_schema}.pty_spv_cust_info to ${icl_schema};
grant select on ${iml_schema}.pty_spv_cust_info to ${idl_schema};
grant select on ${iml_schema}.pty_spv_cust_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_spv_cust_info is 'SPV客户信息';
comment on column ${iml_schema}.pty_spv_cust_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_spv_cust_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_spv_cust_info.spv_cust_id is 'SPV客户编号';
comment on column ${iml_schema}.pty_spv_cust_info.spv_id is 'SPV编号';
comment on column ${iml_schema}.pty_spv_cust_info.spv_name is 'SPV名称';
comment on column ${iml_schema}.pty_spv_cust_info.spv_type_cd is 'SPV类型代码';
comment on column ${iml_schema}.pty_spv_cust_info.am_prod_stat_type_id is '资管产品统计类型编号';
comment on column ${iml_schema}.pty_spv_cust_info.cash_mgmt_prod_flg is '现金管理产品标志';
comment on column ${iml_schema}.pty_spv_cust_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_spv_cust_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_spv_cust_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_spv_cust_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_spv_cust_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_spv_cust_info.etl_timestamp is 'ETL处理时间戳';
