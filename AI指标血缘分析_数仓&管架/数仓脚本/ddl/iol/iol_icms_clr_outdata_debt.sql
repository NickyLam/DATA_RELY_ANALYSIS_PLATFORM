/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_outdata_debt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_outdata_debt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_outdata_debt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_outdata_debt(
    dateno date -- 期次
    ,debtno varchar2(60) -- 债券代码
    ,debtname varchar2(200) -- 债券名称
    ,debttype varchar2(96) -- 债券类型
    ,issuer varchar2(200) -- 发行方
    ,rating varchar2(20) -- 债券评级
    ,rating1 varchar2(20) -- 主体评级
    ,startdate date -- 起息日
    ,enddate date -- 到期日
    ,allprice number(24,6) -- 全价市值(元)
    ,price number(24,6) -- 净价市值(元)
    ,accamt number(24,6) -- 票面利息收入(元)
    ,limittime number(24,0) -- 待偿期(天)
    ,predictyield number(24,6) -- 到期收益率(%)
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
grant select on ${iol_schema}.icms_clr_outdata_debt to ${iml_schema};
grant select on ${iol_schema}.icms_clr_outdata_debt to ${icl_schema};
grant select on ${iol_schema}.icms_clr_outdata_debt to ${idl_schema};
grant select on ${iol_schema}.icms_clr_outdata_debt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_outdata_debt is '债券信息表--外部数据';
comment on column ${iol_schema}.icms_clr_outdata_debt.dateno is '期次';
comment on column ${iol_schema}.icms_clr_outdata_debt.debtno is '债券代码';
comment on column ${iol_schema}.icms_clr_outdata_debt.debtname is '债券名称';
comment on column ${iol_schema}.icms_clr_outdata_debt.debttype is '债券类型';
comment on column ${iol_schema}.icms_clr_outdata_debt.issuer is '发行方';
comment on column ${iol_schema}.icms_clr_outdata_debt.rating is '债券评级';
comment on column ${iol_schema}.icms_clr_outdata_debt.rating1 is '主体评级';
comment on column ${iol_schema}.icms_clr_outdata_debt.startdate is '起息日';
comment on column ${iol_schema}.icms_clr_outdata_debt.enddate is '到期日';
comment on column ${iol_schema}.icms_clr_outdata_debt.allprice is '全价市值(元)';
comment on column ${iol_schema}.icms_clr_outdata_debt.price is '净价市值(元)';
comment on column ${iol_schema}.icms_clr_outdata_debt.accamt is '票面利息收入(元)';
comment on column ${iol_schema}.icms_clr_outdata_debt.limittime is '待偿期(天)';
comment on column ${iol_schema}.icms_clr_outdata_debt.predictyield is '到期收益率(%)';
comment on column ${iol_schema}.icms_clr_outdata_debt.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_outdata_debt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_outdata_debt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_outdata_debt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_outdata_debt.etl_timestamp is 'ETL处理时间戳';
