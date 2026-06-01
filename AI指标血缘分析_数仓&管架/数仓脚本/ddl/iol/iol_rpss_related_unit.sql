/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpss_related_unit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpss_related_unit
whenever sqlerror continue none;
drop table ${iol_schema}.rpss_related_unit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_unit(
    related_id varchar2(20) -- 关联方编号
    ,unit_name varchar2(100) -- 单位名称
    ,certificate_no_dg varchar2(60) -- 对公证件号码1
    ,certificate_no_dg_t varchar2(60) -- 对公证件号码2
    ,relation varchar2(30) -- 担任职务或关联关系
    ,group_name varchar2(60) -- 单位归属的企业集团全称
    ,shareholding_ratio varchar2(100) -- 持股比例
    ,comments varchar2(255) -- 备注
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,belong_org varchar2(60) -- 归属机构
    ,mainten_org varchar2(60) -- 维护机构
    ,organization varchar2(60) -- 所属机构
    ,certificate_type_id_dg varchar2(60) -- 对公证件类型1
    ,certificate_type_id_dg_t varchar2(60) -- 对公证件类型2
    ,domestic_or_foreign_dg varchar2(20) -- 境内外标志1
    ,domestic_or_foreign_dg_t varchar2(20) -- 境内外标志2
    ,hold_related_type varchar2(20) -- 股东或关联方类型
    ,hold_related_industry varchar2(20) -- 股东或关联方所属行业
    ,hold_related_reg_address varchar2(255) -- 股东或关联方注册地
    ,hold_related_rel_type varchar2(20) -- 股东或关联方关系类型
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
grant select on ${iol_schema}.rpss_related_unit to ${iml_schema};
grant select on ${iol_schema}.rpss_related_unit to ${icl_schema};
grant select on ${iol_schema}.rpss_related_unit to ${idl_schema};
grant select on ${iol_schema}.rpss_related_unit to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpss_related_unit is '对公';
comment on column ${iol_schema}.rpss_related_unit.related_id is '关联方编号';
comment on column ${iol_schema}.rpss_related_unit.unit_name is '单位名称';
comment on column ${iol_schema}.rpss_related_unit.certificate_no_dg is '对公证件号码1';
comment on column ${iol_schema}.rpss_related_unit.certificate_no_dg_t is '对公证件号码2';
comment on column ${iol_schema}.rpss_related_unit.relation is '担任职务或关联关系';
comment on column ${iol_schema}.rpss_related_unit.group_name is '单位归属的企业集团全称';
comment on column ${iol_schema}.rpss_related_unit.shareholding_ratio is '持股比例';
comment on column ${iol_schema}.rpss_related_unit.comments is '备注';
comment on column ${iol_schema}.rpss_related_unit.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.rpss_related_unit.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.rpss_related_unit.created_stamp is '创建时间';
comment on column ${iol_schema}.rpss_related_unit.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.rpss_related_unit.belong_org is '归属机构';
comment on column ${iol_schema}.rpss_related_unit.mainten_org is '维护机构';
comment on column ${iol_schema}.rpss_related_unit.organization is '所属机构';
comment on column ${iol_schema}.rpss_related_unit.certificate_type_id_dg is '对公证件类型1';
comment on column ${iol_schema}.rpss_related_unit.certificate_type_id_dg_t is '对公证件类型2';
comment on column ${iol_schema}.rpss_related_unit.domestic_or_foreign_dg is '境内外标志1';
comment on column ${iol_schema}.rpss_related_unit.domestic_or_foreign_dg_t is '境内外标志2';
comment on column ${iol_schema}.rpss_related_unit.hold_related_type is '股东或关联方类型';
comment on column ${iol_schema}.rpss_related_unit.hold_related_industry is '股东或关联方所属行业';
comment on column ${iol_schema}.rpss_related_unit.hold_related_reg_address is '股东或关联方注册地';
comment on column ${iol_schema}.rpss_related_unit.hold_related_rel_type is '股东或关联方关系类型';
comment on column ${iol_schema}.rpss_related_unit.start_dt is '开始时间';
comment on column ${iol_schema}.rpss_related_unit.end_dt is '结束时间';
comment on column ${iol_schema}.rpss_related_unit.id_mark is '增删标志';
comment on column ${iol_schema}.rpss_related_unit.etl_timestamp is 'ETL处理时间戳';
