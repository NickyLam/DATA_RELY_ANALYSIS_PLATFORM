/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_withdrawdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_withdrawdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_withdrawdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_withdrawdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(23) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,calcdate number -- 计提日期
    ,balance_id number -- 引用表2ID
    ,holdamount number -- 持仓量
    ,accruedinterest number -- 应计提利息
    ,receivableinterest number -- 应收利息
    ,withdrawinterest number -- 计提利息
    ,accruedinterest2 number -- 计提后应计利息
    ,keepfolder_id number -- 账户ID
    ,assettype varchar2(30) -- 资产类别
    ,majorassetcode varchar2(30) -- 主资产代码
    ,lastmodified timestamp -- 最后修改时间
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
grant select on ${iol_schema}.ctms_tbs_v_withdrawdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_withdrawdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_withdrawdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_withdrawdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_withdrawdeals is '计提';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.calcdate is '计提日期';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.holdamount is '持仓量';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.accruedinterest is '应计提利息';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.receivableinterest is '应收利息';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.withdrawinterest is '计提利息';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.accruedinterest2 is '计提后应计利息';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.majorassetcode is '主资产代码';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_withdrawdeals.etl_timestamp is 'ETL处理时间戳';
