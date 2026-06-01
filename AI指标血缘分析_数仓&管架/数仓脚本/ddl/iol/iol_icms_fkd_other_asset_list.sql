/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_other_asset_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_other_asset_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_other_asset_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_other_asset_list(
    serialno varchar2(32) -- 主键
    ,relativeserialno varchar2(32) -- 业务流水号
    ,otherassettype varchar2(30) -- 其他资产证明类型
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_fkd_other_asset_list to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_other_asset_list to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_other_asset_list to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_other_asset_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_other_asset_list is '房快贷其他资产证明列表';
comment on column ${iol_schema}.icms_fkd_other_asset_list.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_other_asset_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_other_asset_list.otherassettype is '其他资产证明类型';
comment on column ${iol_schema}.icms_fkd_other_asset_list.migtflag is '';
comment on column ${iol_schema}.icms_fkd_other_asset_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_other_asset_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_other_asset_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_other_asset_list.etl_timestamp is 'ETL处理时间戳';
