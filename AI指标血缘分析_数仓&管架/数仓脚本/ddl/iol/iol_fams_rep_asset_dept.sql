/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_asset_dept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_asset_dept
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_asset_dept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_asset_dept(
    rep_finprod_id varchar2(100) -- 金融产品代码
    ,finprod_market_id varchar2(64) -- 市场代码，可以按规则生成，或者手输，不校验唯一
    ,rep_finprod_name varchar2(600) -- 金融产品名称
    ,rep_issue_party_id varchar2(12) -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
    ,rep_asset_type varchar2(100) -- 资产/负债类别
    ,rep_ccy varchar2(100) -- 币种
    ,rep_trade_market varchar2(100) -- 交易流通场所
    ,rep_send_status varchar2(100) -- 报送状态
    ,rep_status_date date -- 数据日期
    ,is_rep_target varchar2(100) -- 是否报送对象
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_rep_asset_dept to ${iml_schema};
grant select on ${iol_schema}.fams_rep_asset_dept to ${icl_schema};
grant select on ${iol_schema}.fams_rep_asset_dept to ${idl_schema};
grant select on ${iol_schema}.fams_rep_asset_dept to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_asset_dept is '资产报送';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_rep_asset_dept.finprod_market_id is '市场代码，可以按规则生成，或者手输，不校验唯一';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_finprod_name is '金融产品名称';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_issue_party_id is '发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_asset_type is '资产/负债类别';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_ccy is '币种';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_trade_market is '交易流通场所';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_send_status is '报送状态';
comment on column ${iol_schema}.fams_rep_asset_dept.rep_status_date is '数据日期';
comment on column ${iol_schema}.fams_rep_asset_dept.is_rep_target is '是否报送对象';
comment on column ${iol_schema}.fams_rep_asset_dept.create_user is '创建人';
comment on column ${iol_schema}.fams_rep_asset_dept.create_dept is '创建部门';
comment on column ${iol_schema}.fams_rep_asset_dept.create_time is '创建时间';
comment on column ${iol_schema}.fams_rep_asset_dept.update_user is '更新人';
comment on column ${iol_schema}.fams_rep_asset_dept.update_time is '更新时间';
comment on column ${iol_schema}.fams_rep_asset_dept.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_rep_asset_dept.etl_timestamp is 'ETL处理时间戳';
