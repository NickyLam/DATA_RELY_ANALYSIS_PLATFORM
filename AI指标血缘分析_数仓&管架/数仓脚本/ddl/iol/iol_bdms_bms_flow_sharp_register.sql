/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_flow_sharp_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_flow_sharp_register
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_flow_sharp_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_flow_sharp_register(
    id varchar2(60) -- 主键
    ,flow_sharp_id varchar2(60) -- 流程id
    ,cur_node_id varchar2(60) -- 当前节点id
    ,cur_app_route_flag varchar2(2) -- 当前是否含审批路线
    ,next_node_id varchar2(60) -- 下一节点id
    ,next_app_route_flag varchar2(2) -- 当前是否含审批路线
    ,product_no varchar2(12) -- 产品类型编码
    ,protocol_no varchar2(60) -- 协议号
    ,contract_id varchar2(60) -- 协议id
    ,table_type varchar2(3) -- 表类型
    ,status varchar2(2) -- 流程状态
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_bms_flow_sharp_register to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_flow_sharp_register to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_flow_sharp_register to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_flow_sharp_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_flow_sharp_register is '流程节点登记表';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.id is '主键';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.flow_sharp_id is '流程id';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.cur_node_id is '当前节点id';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.cur_app_route_flag is '当前是否含审批路线';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.next_node_id is '下一节点id';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.next_app_route_flag is '当前是否含审批路线';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.product_no is '产品类型编码';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.protocol_no is '协议号';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.contract_id is '协议id';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.table_type is '表类型';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.status is '流程状态';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bms_flow_sharp_register.etl_timestamp is 'ETL处理时间戳';
