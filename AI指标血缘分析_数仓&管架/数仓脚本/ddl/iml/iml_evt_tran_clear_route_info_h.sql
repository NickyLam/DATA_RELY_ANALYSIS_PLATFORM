/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tran_clear_route_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tran_clear_route_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tran_clear_route_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tran_clear_route_info_h(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_id varchar2(60) -- 交易编号
    ,ghb_pay_clear_route_seq_num varchar2(60) -- 本方付清算路径序号
    ,ghb_recvbl_clear_route_seq_num varchar2(60) -- 本方收清算路径序号
    ,cntpty_recvbl_clear_route_seq_num varchar2(60) -- 对方收清算路径序号
    ,cntpty_pay_clear_route_seq_num varchar2(60) -- 对方付清算路径序号
    ,tran_type_descb varchar2(150) -- 交易类型描述
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
grant select on ${iml_schema}.evt_tran_clear_route_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_tran_clear_route_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_tran_clear_route_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tran_clear_route_info_h is '交易清算路径信息历史';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.tran_id is '交易编号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.ghb_pay_clear_route_seq_num is '本方付清算路径序号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.ghb_recvbl_clear_route_seq_num is '本方收清算路径序号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.cntpty_recvbl_clear_route_seq_num is '对方收清算路径序号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.cntpty_pay_clear_route_seq_num is '对方付清算路径序号';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.tran_type_descb is '交易类型描述';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tran_clear_route_info_h.etl_timestamp is 'ETL处理时间戳';
