/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_property_type_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_property_type_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_property_type_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_type_info(
    id number(22) -- 
    ,property_type varchar2(30) -- 资产种类
    ,pledge_rate number(8,4) -- 质押率
    ,risk_level varchar2(2) -- 风险级别     1-  低 2-  中3-  高
    ,effective_date varchar2(12) -- 生效日期
    ,valid_flag varchar2(2) -- 是否有效   0-无效 1-有效
    ,max_pledge_amt number(12,4) -- 最高质押规模
    ,last_upd_oper_id number(22) -- 最后更新操作员
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,remark varchar2(192) -- 备注
    ,branch_id number(22) -- 机构id
    ,detail_type varchar2(3) -- 详细类型 1-保本理财 2-非保本理财
    ,quota_type varchar2(2) -- 额度类型 1-低风险额度 2-敞口额度"
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
grant select on ${iol_schema}.bdps_property_type_info to ${iml_schema};
grant select on ${iol_schema}.bdps_property_type_info to ${icl_schema};
grant select on ${iol_schema}.bdps_property_type_info to ${idl_schema};
grant select on ${iol_schema}.bdps_property_type_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_property_type_info is '资产种类表';
comment on column ${iol_schema}.bdps_property_type_info.id is '';
comment on column ${iol_schema}.bdps_property_type_info.property_type is '资产种类';
comment on column ${iol_schema}.bdps_property_type_info.pledge_rate is '质押率';
comment on column ${iol_schema}.bdps_property_type_info.risk_level is '风险级别     1-  低 2-  中3-  高';
comment on column ${iol_schema}.bdps_property_type_info.effective_date is '生效日期';
comment on column ${iol_schema}.bdps_property_type_info.valid_flag is '是否有效   0-无效 1-有效';
comment on column ${iol_schema}.bdps_property_type_info.max_pledge_amt is '最高质押规模';
comment on column ${iol_schema}.bdps_property_type_info.last_upd_oper_id is '最后更新操作员';
comment on column ${iol_schema}.bdps_property_type_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_property_type_info.remark is '备注';
comment on column ${iol_schema}.bdps_property_type_info.branch_id is '机构id';
comment on column ${iol_schema}.bdps_property_type_info.detail_type is '详细类型 1-保本理财 2-非保本理财';
comment on column ${iol_schema}.bdps_property_type_info.quota_type is '额度类型 1-低风险额度 2-敞口额度"';
comment on column ${iol_schema}.bdps_property_type_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_property_type_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_property_type_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_property_type_info.etl_timestamp is 'ETL处理时间戳';
