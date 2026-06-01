/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_amortizationdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_amortizationdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_amortizationdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_amortizationdeals(
    deal_id number -- 引用表ID
    ,deal_name varchar2(26) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,calcdate number -- 摊销日期
    ,balance_id number -- 引用表2ID
    ,holdamount number -- 持仓量
    ,cleanpricecost number -- 净价成本
    ,amortizeamount number -- 摊销金额
    ,cleanpricecost2 number -- 摊销后净价成本
    ,erate number -- 实际利率
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
grant select on ${iol_schema}.ctms_tbs_v_amortizationdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_amortizationdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_amortizationdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_amortizationdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_amortizationdeals is '摊销';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.deal_name is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.calcdate is '摊销日期';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.balance_id is '引用表2ID';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.holdamount is '持仓量';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.cleanpricecost is '净价成本';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.amortizeamount is '摊销金额';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.cleanpricecost2 is '摊销后净价成本';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.erate is '实际利率';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.assettype is '资产类别';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.majorassetcode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_amortizationdeals.etl_timestamp is 'ETL处理时间戳';
