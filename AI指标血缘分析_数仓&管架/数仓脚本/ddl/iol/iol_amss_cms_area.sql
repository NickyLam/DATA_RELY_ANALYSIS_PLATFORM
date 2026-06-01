/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_area
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_area
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_area purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_area(
    area_code varchar2(16) -- 地区编号.
    ,area_name varchar2(64) -- 地区名称.
    ,area_type number(4,0) -- 地区类型.1国家，2省份，3城市，4县/区
    ,parent_area varchar2(16) -- 所属地区.
    ,zip_code varchar2(16) -- 邮政编号.
    ,tel_code varchar2(3) -- 电话区号.生成渠道编号时要用到
    ,enabled number(1,0) -- 是否启用.
    ,name_py varchar2(64) -- 地区名称全拼.
    ,name_spy varchar2(64) -- 地区名称拼音缩写.
    ,remark varchar2(256) -- 备注.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,ali_v2_area_code varchar2(16) -- 支付宝V2地区编码
    ,best_pay_area_code varchar2(32) -- 翼支付地区码
    ,hebao_area_code varchar2(32) -- 和包地区编码
    ,union_pay_area_code varchar2(32) -- 银联地区编号
    ,sft_area_code varchar2(128) -- 盛付通地区编码
    ,sft_area_name varchar2(128) -- 盛付通地区名
    ,cfca_area_code varchar2(128) -- 清算协会地区编码
    ,jl_area_code varchar2(32) -- 嘉联地区码
    ,yz_area_code varchar2(32) -- 银总地区编码
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
grant select on ${iol_schema}.amss_cms_area to ${iml_schema};
grant select on ${iol_schema}.amss_cms_area to ${icl_schema};
grant select on ${iol_schema}.amss_cms_area to ${idl_schema};
grant select on ${iol_schema}.amss_cms_area to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_area is '地区表';
comment on column ${iol_schema}.amss_cms_area.area_code is '地区编号.';
comment on column ${iol_schema}.amss_cms_area.area_name is '地区名称.';
comment on column ${iol_schema}.amss_cms_area.area_type is '地区类型.1国家，2省份，3城市，4县/区';
comment on column ${iol_schema}.amss_cms_area.parent_area is '所属地区.';
comment on column ${iol_schema}.amss_cms_area.zip_code is '邮政编号.';
comment on column ${iol_schema}.amss_cms_area.tel_code is '电话区号.生成渠道编号时要用到';
comment on column ${iol_schema}.amss_cms_area.enabled is '是否启用.';
comment on column ${iol_schema}.amss_cms_area.name_py is '地区名称全拼.';
comment on column ${iol_schema}.amss_cms_area.name_spy is '地区名称拼音缩写.';
comment on column ${iol_schema}.amss_cms_area.remark is '备注.';
comment on column ${iol_schema}.amss_cms_area.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_area.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_area.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_area.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_area.ali_v2_area_code is '支付宝V2地区编码';
comment on column ${iol_schema}.amss_cms_area.best_pay_area_code is '翼支付地区码';
comment on column ${iol_schema}.amss_cms_area.hebao_area_code is '和包地区编码';
comment on column ${iol_schema}.amss_cms_area.union_pay_area_code is '银联地区编号';
comment on column ${iol_schema}.amss_cms_area.sft_area_code is '盛付通地区编码';
comment on column ${iol_schema}.amss_cms_area.sft_area_name is '盛付通地区名';
comment on column ${iol_schema}.amss_cms_area.cfca_area_code is '清算协会地区编码';
comment on column ${iol_schema}.amss_cms_area.jl_area_code is '嘉联地区码';
comment on column ${iol_schema}.amss_cms_area.yz_area_code is '银总地区编码';
comment on column ${iol_schema}.amss_cms_area.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_area.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_area.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_area.etl_timestamp is 'ETL处理时间戳';
