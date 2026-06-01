/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_counter_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_counter_party
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_counter_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_counter_party(
    counter_id varchar2(32) -- 交易对手代码
    ,counter_type varchar2(50) -- 交易对手类型，市场机构、资管产品、通道
    ,counter_name varchar2(200) -- 交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。
    ,link_id varchar2(32) -- 关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品
    ,manager_id varchar2(32) -- 管理人，资管产品时录入
    ,head_bank varchar2(32) -- 所属总行
    ,contact varchar2(200) -- 联系人
    ,contact_way varchar2(1000) -- 联系方式
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,link_dept_code varchar2(32) -- 关联内部机构
    ,p_type_one varchar2(50) -- 人行一级分类
    ,p_type_two varchar2(50) -- 人行二级分类
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_mst_counter_party to ${iml_schema};
grant select on ${iol_schema}.fams_mst_counter_party to ${icl_schema};
grant select on ${iol_schema}.fams_mst_counter_party to ${idl_schema};
grant select on ${iol_schema}.fams_mst_counter_party to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_counter_party is '交易对手';
comment on column ${iol_schema}.fams_mst_counter_party.counter_id is '交易对手代码';
comment on column ${iol_schema}.fams_mst_counter_party.counter_type is '交易对手类型，市场机构、资管产品、通道';
comment on column ${iol_schema}.fams_mst_counter_party.counter_name is '交易对手名称，市场机构取机构名称，通道取金融产品简称，资管产品由页面输入。';
comment on column ${iol_schema}.fams_mst_counter_party.link_id is '关联代码，市场机构关联机构信息、资管产品无，通道关联标的类金融产品';
comment on column ${iol_schema}.fams_mst_counter_party.manager_id is '管理人，资管产品时录入';
comment on column ${iol_schema}.fams_mst_counter_party.head_bank is '所属总行';
comment on column ${iol_schema}.fams_mst_counter_party.contact is '联系人';
comment on column ${iol_schema}.fams_mst_counter_party.contact_way is '联系方式';
comment on column ${iol_schema}.fams_mst_counter_party.remark is '备注';
comment on column ${iol_schema}.fams_mst_counter_party.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_counter_party.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_counter_party.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_counter_party.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_counter_party.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_counter_party.link_dept_code is '关联内部机构';
comment on column ${iol_schema}.fams_mst_counter_party.p_type_one is '人行一级分类';
comment on column ${iol_schema}.fams_mst_counter_party.p_type_two is '人行二级分类';
comment on column ${iol_schema}.fams_mst_counter_party.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_counter_party.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_counter_party.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_counter_party.etl_timestamp is 'ETL处理时间戳';
