/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_receivable_toll
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_receivable_toll
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_receivable_toll purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_toll(
    clrid varchar2(32) -- 押品编号
    ,inappdocsubtype varchar2(30) -- 收费权细类
    ,inappdocno varchar2(120) -- 收费权政府批文文号
    ,inappdocnum varchar2(200) -- 收费权政府批文名称
    ,certificatecode varchar2(60) -- 收费权利证书号
    ,startdate date -- 权益开始时间
    ,duedate date -- 权益到期时间
    ,province varchar2(30) -- 所在/注册省份
    ,city varchar2(30) -- 所在/注册市
    ,address varchar2(200) -- 详细地址
    ,openbankname varchar2(100) -- 专用账户开户行名称
    ,accountno varchar2(60) -- 专用账户账号
    ,accountname varchar2(100) -- 专用账户名称
    ,remark varchar2(4000) -- 其他说明
    ,yearlimit number(38) -- 剩余收费年限(年)
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_receivable_toll to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_toll to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_toll to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_receivable_toll to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_receivable_toll is '应收账款类之收费权信息表';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.inappdocsubtype is '收费权细类';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.inappdocno is '收费权政府批文文号';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.inappdocnum is '收费权政府批文名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.certificatecode is '收费权利证书号';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.startdate is '权益开始时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.duedate is '权益到期时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.address is '详细地址';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.openbankname is '专用账户开户行名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.accountno is '专用账户账号';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.accountname is '专用账户名称';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.yearlimit is '剩余收费年限(年)';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_receivable_toll.etl_timestamp is 'ETL处理时间戳';
