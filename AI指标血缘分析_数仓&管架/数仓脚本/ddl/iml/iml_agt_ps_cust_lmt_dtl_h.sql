/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ps_cust_lmt_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ps_cust_lmt_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ps_cust_lmt_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ps_cust_lmt_dtl_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,lmt_type_descb varchar2(500) -- 限额类型描述
    ,lmt_agt_id varchar2(100) -- 限额协议编号
    ,lmt_obj_id varchar2(100) -- 限额对象编号
    ,lmt_type_val varchar2(100) -- 限制类型值
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.agt_ps_cust_lmt_dtl_h to ${icl_schema};
grant select on ${iml_schema}.agt_ps_cust_lmt_dtl_h to ${idl_schema};
grant select on ${iml_schema}.agt_ps_cust_lmt_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ps_cust_lmt_dtl_h is 'PPPS客户限额明细历史';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.lmt_type_descb is '限额类型描述';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.lmt_agt_id is '限额协议编号';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.lmt_obj_id is '限额对象编号';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.lmt_type_val is '限制类型值';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.remark is '备注';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ps_cust_lmt_dtl_h.etl_timestamp is 'ETL处理时间戳';
