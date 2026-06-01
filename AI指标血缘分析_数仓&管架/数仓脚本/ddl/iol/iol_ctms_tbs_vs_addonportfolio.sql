/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_addonportfolio
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_addonportfolio
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_addonportfolio(
    addonportfolio_id number -- 从属投资组合ID
    ,aspclient_id number -- 部门ID
    ,owner_number number -- 拥有者ID
    ,owner_code varchar2(192) -- 拥有者代码
    ,owner_name varchar2(192) -- 拥有者名称
    ,portfolio_id number -- 投组ID
    ,portfolioname varchar2(120) -- 投组名称
    ,keepfolder_id_default number -- 默认账户ID
    ,assettype_id_default number -- 默认资产类型ID
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number -- 数据源应用设置ID
    ,buztype_id_default number -- 业务类型ID
    ,status varchar2(2) -- 状态
    ,nstd_id_default number -- 非标资产类别
    ,pntt_type varchar2(2) -- 
    ,asset_code varchar2(24) -- 
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
grant select on ${iol_schema}.ctms_tbs_vs_addonportfolio to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_addonportfolio to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_addonportfolio to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_addonportfolio to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_addonportfolio is '投组账户信息';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.addonportfolio_id is '从属投资组合ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.owner_number is '拥有者ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.owner_code is '拥有者代码';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.owner_name is '拥有者名称';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.portfolio_id is '投组ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.portfolioname is '投组名称';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.keepfolder_id_default is '默认账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.assettype_id_default is '默认资产类型ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.datasymbol_id is '数据源应用设置ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.buztype_id_default is '业务类型ID';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.status is '状态';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.nstd_id_default is '非标资产类别';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.pntt_type is '';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.asset_code is '';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_addonportfolio.etl_timestamp is 'ETL处理时间戳';
