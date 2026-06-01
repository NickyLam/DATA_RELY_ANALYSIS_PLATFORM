/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_sys_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_sys_org
whenever sqlerror continue none;
drop table ${iol_schema}.atms_sys_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_sys_org(
    no varchar2(20) -- 机构编号
    ,name varchar2(160) -- 机构名称
    ,parent_org varchar2(20) -- 上级机构
    ,left_no number(38,0) -- 预排序左序号
    ,right_no number(38,0) -- 预排序右序号
    ,org_type varchar2(40) -- 机构类型
    ,moneyorg_flag varchar2(1) -- 是否是加钞机构
    ,x varchar2(20) -- 横坐标（经度）
    ,y varchar2(20) -- 纵坐标（纬度）
    ,address varchar2(200) -- 地址
    ,linkman varchar2(30) -- 联系人
    ,telephone varchar2(30) -- 电话
    ,mobile varchar2(30) -- 手机
    ,fax varchar2(30) -- 传真
    ,email varchar2(40) -- 电子邮箱
    ,business_range varchar2(256) -- 业务范围
    ,cup_area_code varchar2(8) -- 银联标准地区代码
    ,address_code varchar2(15) -- 地点代码
    ,area_no_province varchar2(10) -- 所属省级区域编码
    ,area_no_city varchar2(10) -- 所属地市级区域编码
    ,area_no_county varchar2(10) -- 所属县级区域编码
    ,area_type varchar2(3) -- 所处区域类型
    ,org_physics_catalog varchar2(3) -- 物理网点类型
    ,note varchar2(4000) -- 备注
    ,is_selfhelp number(5,0) -- 是否是自助银行
    ,is_bankoutlet number(5,0) -- 是否是网点
    ,area_no varchar2(10) -- 区域编码
    ,org_status number(5,0) -- 机构状态
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
grant select on ${iol_schema}.atms_sys_org to ${iml_schema};
grant select on ${iol_schema}.atms_sys_org to ${icl_schema};
grant select on ${iol_schema}.atms_sys_org to ${idl_schema};
grant select on ${iol_schema}.atms_sys_org to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_sys_org is '组织机构表';
comment on column ${iol_schema}.atms_sys_org.no is '机构编号';
comment on column ${iol_schema}.atms_sys_org.name is '机构名称';
comment on column ${iol_schema}.atms_sys_org.parent_org is '上级机构';
comment on column ${iol_schema}.atms_sys_org.left_no is '预排序左序号';
comment on column ${iol_schema}.atms_sys_org.right_no is '预排序右序号';
comment on column ${iol_schema}.atms_sys_org.org_type is '机构类型';
comment on column ${iol_schema}.atms_sys_org.moneyorg_flag is '是否是加钞机构';
comment on column ${iol_schema}.atms_sys_org.x is '横坐标（经度）';
comment on column ${iol_schema}.atms_sys_org.y is '纵坐标（纬度）';
comment on column ${iol_schema}.atms_sys_org.address is '地址';
comment on column ${iol_schema}.atms_sys_org.linkman is '联系人';
comment on column ${iol_schema}.atms_sys_org.telephone is '电话';
comment on column ${iol_schema}.atms_sys_org.mobile is '手机';
comment on column ${iol_schema}.atms_sys_org.fax is '传真';
comment on column ${iol_schema}.atms_sys_org.email is '电子邮箱';
comment on column ${iol_schema}.atms_sys_org.business_range is '业务范围';
comment on column ${iol_schema}.atms_sys_org.cup_area_code is '银联标准地区代码';
comment on column ${iol_schema}.atms_sys_org.address_code is '地点代码';
comment on column ${iol_schema}.atms_sys_org.area_no_province is '所属省级区域编码';
comment on column ${iol_schema}.atms_sys_org.area_no_city is '所属地市级区域编码';
comment on column ${iol_schema}.atms_sys_org.area_no_county is '所属县级区域编码';
comment on column ${iol_schema}.atms_sys_org.area_type is '所处区域类型';
comment on column ${iol_schema}.atms_sys_org.org_physics_catalog is '物理网点类型';
comment on column ${iol_schema}.atms_sys_org.note is '备注';
comment on column ${iol_schema}.atms_sys_org.is_selfhelp is '是否是自助银行';
comment on column ${iol_schema}.atms_sys_org.is_bankoutlet is '是否是网点';
comment on column ${iol_schema}.atms_sys_org.area_no is '区域编码';
comment on column ${iol_schema}.atms_sys_org.org_status is '机构状态';
comment on column ${iol_schema}.atms_sys_org.start_dt is '开始时间';
comment on column ${iol_schema}.atms_sys_org.end_dt is '结束时间';
comment on column ${iol_schema}.atms_sys_org.id_mark is '增删标志';
comment on column ${iol_schema}.atms_sys_org.etl_timestamp is 'ETL处理时间戳';
