/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_depreciationdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_depreciationdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_depreciationdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_depreciationdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(26) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,calcdate number -- 计算日期
    ,balance_id number -- 引用表2ID
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,assettype varchar2(30) -- 资产类别
    ,majorassetcode varchar2(30) -- 债券代码
    ,depreciatedvalue number -- 减值后净价
    ,lastmodified timestamp -- 最后更新时间
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
grant select on ${iol_schema}.ctms_tbs_v_depreciationdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_depreciationdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_depreciationdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_depreciationdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_depreciationdeals is '减值';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.calcdate is '计算日期';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.majorassetcode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.depreciatedvalue is '减值后净价';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.lastmodified is '最后更新时间';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_depreciationdeals.etl_timestamp is 'ETL处理时间戳';
