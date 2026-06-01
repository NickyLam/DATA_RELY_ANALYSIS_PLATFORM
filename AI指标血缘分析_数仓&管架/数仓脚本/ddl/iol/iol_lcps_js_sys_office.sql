/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lcps_js_sys_office
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lcps_js_sys_office
whenever sqlerror continue none;
drop table ${iol_schema}.lcps_js_sys_office purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lcps_js_sys_office(
    office_code varchar2(96) -- 机构编码
    ,parent_code varchar2(96) -- 父级编号
    ,parent_codes varchar2(1500) -- 所有父级编号
    ,tree_sort number(10) -- 本级排序号（升序）
    ,tree_sorts varchar2(1500) -- 所有级别排序号
    ,tree_leaf varchar2(2) -- 是否最末级
    ,tree_level number(4) -- 层次级别
    ,tree_names varchar2(1500) -- 全节点名
    ,view_code varchar2(150) -- 机构代码
    ,office_name nvarchar2(300) -- 机构名称
    ,full_name varchar2(300) -- 机构全称
    ,office_type varchar2(2) -- 机构类型
    ,leader varchar2(150) -- 负责人
    ,phone varchar2(150) -- 办公电话
    ,address varchar2(383) -- 联系地址
    ,zip_code varchar2(150) -- 邮政编码
    ,email varchar2(450) -- 电子邮箱
    ,status varchar2(2) -- 状态（0正常 1删除 2停用）
    ,create_by varchar2(96) -- 创建者
    ,create_date timestamp -- 创建时间
    ,update_by varchar2(96) -- 更新者
    ,update_date timestamp -- 更新时间
    ,remarks nvarchar2(1500) -- 备注信息
    ,corp_code varchar2(96) -- 租户代码
    ,corp_name nvarchar2(300) -- 租户名称
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
grant select on ${iol_schema}.lcps_js_sys_office to ${iml_schema};
grant select on ${iol_schema}.lcps_js_sys_office to ${icl_schema};
grant select on ${iol_schema}.lcps_js_sys_office to ${idl_schema};
grant select on ${iol_schema}.lcps_js_sys_office to ${iel_schema};

-- comment
comment on table ${iol_schema}.lcps_js_sys_office is '组织机构表';
comment on column ${iol_schema}.lcps_js_sys_office.office_code is '机构编码';
comment on column ${iol_schema}.lcps_js_sys_office.parent_code is '父级编号';
comment on column ${iol_schema}.lcps_js_sys_office.parent_codes is '所有父级编号';
comment on column ${iol_schema}.lcps_js_sys_office.tree_sort is '本级排序号（升序）';
comment on column ${iol_schema}.lcps_js_sys_office.tree_sorts is '所有级别排序号';
comment on column ${iol_schema}.lcps_js_sys_office.tree_leaf is '是否最末级';
comment on column ${iol_schema}.lcps_js_sys_office.tree_level is '层次级别';
comment on column ${iol_schema}.lcps_js_sys_office.tree_names is '全节点名';
comment on column ${iol_schema}.lcps_js_sys_office.view_code is '机构代码';
comment on column ${iol_schema}.lcps_js_sys_office.office_name is '机构名称';
comment on column ${iol_schema}.lcps_js_sys_office.full_name is '机构全称';
comment on column ${iol_schema}.lcps_js_sys_office.office_type is '机构类型';
comment on column ${iol_schema}.lcps_js_sys_office.leader is '负责人';
comment on column ${iol_schema}.lcps_js_sys_office.phone is '办公电话';
comment on column ${iol_schema}.lcps_js_sys_office.address is '联系地址';
comment on column ${iol_schema}.lcps_js_sys_office.zip_code is '邮政编码';
comment on column ${iol_schema}.lcps_js_sys_office.email is '电子邮箱';
comment on column ${iol_schema}.lcps_js_sys_office.status is '状态（0正常 1删除 2停用）';
comment on column ${iol_schema}.lcps_js_sys_office.create_by is '创建者';
comment on column ${iol_schema}.lcps_js_sys_office.create_date is '创建时间';
comment on column ${iol_schema}.lcps_js_sys_office.update_by is '更新者';
comment on column ${iol_schema}.lcps_js_sys_office.update_date is '更新时间';
comment on column ${iol_schema}.lcps_js_sys_office.remarks is '备注信息';
comment on column ${iol_schema}.lcps_js_sys_office.corp_code is '租户代码';
comment on column ${iol_schema}.lcps_js_sys_office.corp_name is '租户名称';
comment on column ${iol_schema}.lcps_js_sys_office.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.lcps_js_sys_office.etl_timestamp is 'ETL处理时间戳';
