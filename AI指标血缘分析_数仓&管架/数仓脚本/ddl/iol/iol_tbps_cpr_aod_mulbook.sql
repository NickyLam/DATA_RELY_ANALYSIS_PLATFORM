/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_aod_mulbook
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_aod_mulbook
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_aod_mulbook purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_aod_mulbook(
    cam_cstno varchar2(30) -- 客户号
    ,cam_firstbookno varchar2(3) -- 一级账簿编号
    ,cam_secondbookno varchar2(3) -- 二级账簿编号
    ,cam_thirdbookno varchar2(4) -- 三级账簿编号
    ,cam_bookno varchar2(12) -- 账簿编号
    ,cam_bookname varchar2(512) -- 账簿名称
    ,cam_bookgrade varchar2(1) -- 账簿级别
    ,cam_ifbandacc varchar2(1) -- 是否绑定单位结算账户：1绑定，2不绑定
    ,cam_accno varchar2(20) -- 单位结算账号
    ,cam_motherbookno varchar2(12) -- 上级账簿编号
    ,cam_createbooktime varchar2(14) -- 创建账簿时间
    ,cam_bookstate varchar2(1) -- 账簿状态：1正常，2作废
    ,cam_amount varchar2(40) -- 账簿余额
    ,cam_motheracc varchar2(20) -- 签约母账户
    ,cam_accnostatu varchar2(40) -- 结算卡状态:0正常；1关闭；2未加挂卡
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
grant select on ${iol_schema}.tbps_cpr_aod_mulbook to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_aod_mulbook to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_aod_mulbook to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_aod_mulbook to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_aod_mulbook is '单位结算卡账务清分_多级账簿';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_cstno is '客户号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_firstbookno is '一级账簿编号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_secondbookno is '二级账簿编号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_thirdbookno is '三级账簿编号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_bookno is '账簿编号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_bookname is '账簿名称';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_bookgrade is '账簿级别';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_ifbandacc is '是否绑定单位结算账户：1绑定，2不绑定';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_accno is '单位结算账号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_motherbookno is '上级账簿编号';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_createbooktime is '创建账簿时间';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_bookstate is '账簿状态：1正常，2作废';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_amount is '账簿余额';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_motheracc is '签约母账户';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.cam_accnostatu is '结算卡状态:0正常；1关闭；2未加挂卡';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_aod_mulbook.etl_timestamp is 'ETL处理时间戳';
