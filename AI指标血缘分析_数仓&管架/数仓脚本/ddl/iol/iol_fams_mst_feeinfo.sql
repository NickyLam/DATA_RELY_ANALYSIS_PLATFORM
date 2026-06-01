/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_feeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_feeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_feeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_feeinfo(
    fee_id varchar2(32) -- 费用代码
    ,fee_name varchar2(200) -- 费用名称
    ,apply_type varchar2(50) -- 关联范围，产品、通道、其他
    ,fee_type varchar2(50) -- 费用类型，托管费、管理费、增加附加税等
    ,basic_bill varchar2(50) -- 计费基数，存续本金、资产规模
    ,basis varchar2(50) -- 计息基准
    ,charge_type varchar2(50) -- 收费类型，计提费用，不规则费用
    ,org_type varchar2(50) -- 机构类型
    ,org_type2 varchar2(50) -- 机构二级类型
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_mst_feeinfo to ${iml_schema};
grant select on ${iol_schema}.fams_mst_feeinfo to ${icl_schema};
grant select on ${iol_schema}.fams_mst_feeinfo to ${idl_schema};
grant select on ${iol_schema}.fams_mst_feeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_feeinfo is '费用品种';
comment on column ${iol_schema}.fams_mst_feeinfo.fee_id is '费用代码';
comment on column ${iol_schema}.fams_mst_feeinfo.fee_name is '费用名称';
comment on column ${iol_schema}.fams_mst_feeinfo.apply_type is '关联范围，产品、通道、其他';
comment on column ${iol_schema}.fams_mst_feeinfo.fee_type is '费用类型，托管费、管理费、增加附加税等';
comment on column ${iol_schema}.fams_mst_feeinfo.basic_bill is '计费基数，存续本金、资产规模';
comment on column ${iol_schema}.fams_mst_feeinfo.basis is '计息基准';
comment on column ${iol_schema}.fams_mst_feeinfo.charge_type is '收费类型，计提费用，不规则费用';
comment on column ${iol_schema}.fams_mst_feeinfo.org_type is '机构类型';
comment on column ${iol_schema}.fams_mst_feeinfo.org_type2 is '机构二级类型';
comment on column ${iol_schema}.fams_mst_feeinfo.remark is '备注';
comment on column ${iol_schema}.fams_mst_feeinfo.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_feeinfo.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_feeinfo.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_feeinfo.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_feeinfo.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_feeinfo.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_feeinfo.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_feeinfo.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_feeinfo.etl_timestamp is 'ETL处理时间戳';
