/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_his_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_his_relation
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_his_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_his_relation(
    id varchar2(48) -- ID
    ,bus_id varchar2(96) -- 业务主键
    ,his_bus_id varchar2(96) -- 关联的名单业务编号
    ,entity_rp_type varchar2(3) -- 本层关联方类型
    ,entity_bus_id varchar2(96) -- 本层关联方业务编号
    ,super_rp_type varchar2(3) -- 前一层关联方类型
    ,super_bus_id varchar2(96) -- 前一层关联方业务编号
    ,super_rp_name varchar2(300) -- 前一层关联方名称
    ,super_ybj_card_type varchar2(15) -- 前一层证件类型
    ,super_card_no varchar2(150) -- 前一层关联方证件号码
    ,relation_type varchar2(5) -- 与前一层的关联关系
    ,is_share_holding varchar2(3) -- 与前一层之间是否有权益份额
    ,holding_pct number(8,4) -- 持有比例
    ,relation_info varchar2(3000) -- 关联关系说明
    ,data_state varchar2(3) -- 数据状态
    ,valid_state varchar2(3) -- 该关系是否仍然有效
    ,active_time date -- 关系生效时间
    ,invalid_time date -- 关系失效时间
    ,release_time date -- 关系解除时间
    ,process_time date -- 审核通过时间
    ,remarks varchar2(3000) -- 备注信息
    ,legal_org_code varchar2(383) -- 独立法人编码
    ,create_user varchar2(48) -- 创建人
    ,create_time date -- 创建时间
    ,create_org varchar2(48) -- 创建机构
    ,create_dep varchar2(48) -- 创建部门
    ,update_user varchar2(48) -- 修改人
    ,update_time date -- 修改时间
    ,update_org varchar2(48) -- 修改机构
    ,update_dep varchar2(48) -- 修改部门
    ,wf_state varchar2(3) -- 流程状态
    ,agree varchar2(383) -- 同意标识
    ,process_instance_id varchar2(96) -- 流程实例ID
    ,reserve1 varchar2(383) -- 备用字段1
    ,reserve2 varchar2(383) -- 备用字段2
    ,reserve3 varchar2(383) -- 备用字段3
    ,data_dt date -- 数据跑批日期
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
grant select on ${iol_schema}.rptm_rtm_rp_his_relation to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_relation to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_relation to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_his_relation is '关联方历史名单-关联关系主表';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.id is 'ID';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.bus_id is '业务主键';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.his_bus_id is '关联的名单业务编号';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.entity_rp_type is '本层关联方类型';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.entity_bus_id is '本层关联方业务编号';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.super_rp_type is '前一层关联方类型';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.super_bus_id is '前一层关联方业务编号';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.super_rp_name is '前一层关联方名称';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.super_ybj_card_type is '前一层证件类型';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.super_card_no is '前一层关联方证件号码';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.relation_type is '与前一层的关联关系';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.is_share_holding is '与前一层之间是否有权益份额';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.holding_pct is '持有比例';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.relation_info is '关联关系说明';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.data_state is '数据状态';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.valid_state is '该关系是否仍然有效';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.active_time is '关系生效时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.invalid_time is '关系失效时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.release_time is '关系解除时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.process_time is '审核通过时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.remarks is '备注信息';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.legal_org_code is '独立法人编码';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.create_user is '创建人';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.create_time is '创建时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.create_org is '创建机构';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.create_dep is '创建部门';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.update_user is '修改人';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.update_time is '修改时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.update_org is '修改机构';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.update_dep is '修改部门';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.wf_state is '流程状态';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.agree is '同意标识';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.process_instance_id is '流程实例ID';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.reserve1 is '备用字段1';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.reserve2 is '备用字段2';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.reserve3 is '备用字段3';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.data_dt is '数据跑批日期';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rptm_rtm_rp_his_relation.etl_timestamp is 'ETL处理时间戳';
