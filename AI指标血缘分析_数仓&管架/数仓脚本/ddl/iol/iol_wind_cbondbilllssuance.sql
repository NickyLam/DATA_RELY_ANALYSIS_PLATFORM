/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondbilllssuance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondbilllssuance
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondbilllssuance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondbilllssuance(
    object_id varchar2(100) -- 对象ID
    ,s_info_windcode varchar2(40) -- Wind代码
    ,bill_name varchar2(100) -- 票据名称
    ,issue_ann_date varchar2(8) -- 发行公告日期
    ,list_ann_date varchar2(8) -- 上市公告日期
    ,issue_date varchar2(8) -- 发行日期
    ,list_date varchar2(8) -- 上市日期
    ,ptotal_num_issues number(20,4) -- 计划发行总量(万元)
    ,total_num_issues number(20,4) -- 实际发行总量(万元)
    ,issue_type varchar2(100) -- 发行方式
    ,s_info_par number(20,4) -- 面额
    ,term number(20,4) -- 期限(月)
    ,paymentdate varchar2(8) -- 缴款日
    ,carry_date varchar2(8) -- 起息日
    ,maturity_date varchar2(8) -- 到期日
    ,tender_method varchar2(100) -- 招标方式
    ,issue_price number(20,4) -- 发行价格
    ,tendrst_referyield number(20,4) -- 利率/参考收益率（%）
    ,issue_gobject varchar2(200) -- 发行对象
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
grant select on ${iol_schema}.wind_cbondbilllssuance to ${iml_schema};
grant select on ${iol_schema}.wind_cbondbilllssuance to ${icl_schema};
grant select on ${iol_schema}.wind_cbondbilllssuance to ${idl_schema};
grant select on ${iol_schema}.wind_cbondbilllssuance to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondbilllssuance is '央行票据发行';
comment on column ${iol_schema}.wind_cbondbilllssuance.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondbilllssuance.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondbilllssuance.bill_name is '票据名称';
comment on column ${iol_schema}.wind_cbondbilllssuance.issue_ann_date is '发行公告日期';
comment on column ${iol_schema}.wind_cbondbilllssuance.list_ann_date is '上市公告日期';
comment on column ${iol_schema}.wind_cbondbilllssuance.issue_date is '发行日期';
comment on column ${iol_schema}.wind_cbondbilllssuance.list_date is '上市日期';
comment on column ${iol_schema}.wind_cbondbilllssuance.ptotal_num_issues is '计划发行总量(万元)';
comment on column ${iol_schema}.wind_cbondbilllssuance.total_num_issues is '实际发行总量(万元)';
comment on column ${iol_schema}.wind_cbondbilllssuance.issue_type is '发行方式';
comment on column ${iol_schema}.wind_cbondbilllssuance.s_info_par is '面额';
comment on column ${iol_schema}.wind_cbondbilllssuance.term is '期限(月)';
comment on column ${iol_schema}.wind_cbondbilllssuance.paymentdate is '缴款日';
comment on column ${iol_schema}.wind_cbondbilllssuance.carry_date is '起息日';
comment on column ${iol_schema}.wind_cbondbilllssuance.maturity_date is '到期日';
comment on column ${iol_schema}.wind_cbondbilllssuance.tender_method is '招标方式';
comment on column ${iol_schema}.wind_cbondbilllssuance.issue_price is '发行价格';
comment on column ${iol_schema}.wind_cbondbilllssuance.tendrst_referyield is '利率/参考收益率（%）';
comment on column ${iol_schema}.wind_cbondbilllssuance.issue_gobject is '发行对象';
comment on column ${iol_schema}.wind_cbondbilllssuance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondbilllssuance.etl_timestamp is 'ETL处理时间戳';
