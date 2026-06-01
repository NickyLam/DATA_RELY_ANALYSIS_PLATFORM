/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_sm_trans_link_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_sm_trans_link_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_sm_trans_link_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_sm_trans_link_tb(
    trans_id varchar2(8) -- 业务种类
    ,trans_name varchar2(100) -- 业务种类名称
    ,trans_desc varchar2(500) -- 业务种类描述
    ,transtype varchar2(20) -- 业务类别
    ,bus_id varchar2(6) -- 业务流程id
    ,last_modi_date varchar2(14) -- 最后修改时间
    ,service_object varchar2(2) -- 服务对象
    ,bank_no varchar2(10) -- 银行号
    ,system_no varchar2(10) -- 系统号
    ,mode_type varchar2(1) -- 作业模式
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_sm_trans_link_tb to ${iml_schema};
grant select on ${iol_schema}.scps_sm_trans_link_tb to ${icl_schema};
grant select on ${iol_schema}.scps_sm_trans_link_tb to ${idl_schema};
grant select on ${iol_schema}.scps_sm_trans_link_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_sm_trans_link_tb is '业务种类定义表';
comment on column ${iol_schema}.scps_sm_trans_link_tb.trans_id is '业务种类';
comment on column ${iol_schema}.scps_sm_trans_link_tb.trans_name is '业务种类名称';
comment on column ${iol_schema}.scps_sm_trans_link_tb.trans_desc is '业务种类描述';
comment on column ${iol_schema}.scps_sm_trans_link_tb.transtype is '业务类别';
comment on column ${iol_schema}.scps_sm_trans_link_tb.bus_id is '业务流程id';
comment on column ${iol_schema}.scps_sm_trans_link_tb.last_modi_date is '最后修改时间';
comment on column ${iol_schema}.scps_sm_trans_link_tb.service_object is '服务对象';
comment on column ${iol_schema}.scps_sm_trans_link_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_sm_trans_link_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_sm_trans_link_tb.mode_type is '作业模式';
comment on column ${iol_schema}.scps_sm_trans_link_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_sm_trans_link_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_sm_trans_link_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_sm_trans_link_tb.etl_timestamp is 'ETL处理时间戳';
