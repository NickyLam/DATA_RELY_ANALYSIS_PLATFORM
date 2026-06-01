/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_estimationdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_estimationdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_estimationdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_estimationdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(23) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,calcdate number -- 估值日期
    ,balance_id number -- 引用表2ID
    ,holdamount number -- 持仓量
    ,faceamountestimate number -- 账面估值
    ,marketestimate number -- 市场估值
    ,fairvaluealter number -- 公允价值变动
    ,pricedate number -- 公允价格日期
    ,fairprice number -- 公允价格
    ,pricesrc varchar2(5) -- 价格来源
    ,keepfolder_id number -- 账户ID
    ,assettype varchar2(30) -- 资产类别
    ,majorassetcode varchar2(30) -- 债券代码
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
grant select on ${iol_schema}.ctms_tbs_v_estimationdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_estimationdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_estimationdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_estimationdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_estimationdeals is '估值';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.calcdate is '估值日期';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.holdamount is '持仓量';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.faceamountestimate is '账面估值';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.marketestimate is '市场估值';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.fairvaluealter is '公允价值变动';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.pricedate is '公允价格日期';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.fairprice is '公允价格';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.pricesrc is '价格来源';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.majorassetcode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_estimationdeals.etl_timestamp is 'ETL处理时间戳';
