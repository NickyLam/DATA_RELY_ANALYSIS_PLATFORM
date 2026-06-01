/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fam_tx_trading_volume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fam_tx_trading_volume
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fam_tx_trading_volume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fam_tx_trading_volume(
    cdate date -- 交易日期
    ,blng_org_id varchar2(150) -- 交易机构号
    ,orer_userno varchar2(60) -- 操作柜员号
    ,orer_username varchar2(600) -- 操作柜员名
    ,auth_userno varchar2(60) -- 授权柜员号
    ,auth_username varchar2(600) -- 授权柜员名称
    ,auth_orgid varchar2(96) -- 授权机构号
    ,txn_num varchar2(150) -- 交易码
    ,txn_desc varchar2(600) -- 交易名称
    ,begin_time timestamp -- 交易开始时间
    ,end_time timestamp -- 交易结束时间
    ,txn_id varchar2(4000) -- 业务流水号
    ,src_cd varchar2(150) -- 系统代码
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
grant select on ${iol_schema}.fams_fam_tx_trading_volume to ${iml_schema};
grant select on ${iol_schema}.fams_fam_tx_trading_volume to ${icl_schema};
grant select on ${iol_schema}.fams_fam_tx_trading_volume to ${idl_schema};
grant select on ${iol_schema}.fams_fam_tx_trading_volume to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fam_tx_trading_volume is '映山红-营运业务交易量';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.cdate is '交易日期';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.blng_org_id is '交易机构号';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.orer_userno is '操作柜员号';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.orer_username is '操作柜员名';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.auth_userno is '授权柜员号';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.auth_username is '授权柜员名称';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.auth_orgid is '授权机构号';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.txn_num is '交易码';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.txn_desc is '交易名称';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.begin_time is '交易开始时间';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.end_time is '交易结束时间';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.txn_id is '业务流水号';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.src_cd is '系统代码';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_fam_tx_trading_volume.etl_timestamp is 'ETL处理时间戳';
