/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tfnd_nav
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tfnd_nav
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tfnd_nav purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tfnd_nav(
    f_id number(16,0) -- 主键
    ,i_code varchar2(45) -- 基金代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,f_totalnav number(38,4) -- 总净价
    ,f_yield_7d number(31,15) -- 七天年化收益率
    ,f_pubdate varchar2(15) -- 公布日期
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,imp_date varchar2(15) -- 导入时间
    ,pipe_id number(22) -- 管道id
    ,f_cumu_nav varchar2(60) -- 累积单位净值
    ,f_profit_1w number(31,15) -- 七天万分收益
    ,f_unitnav number(31,15) -- 单位净价
    ,f_scal number(38,2) -- 基金规模（元）
    ,f_count number(38,2) -- 基金总份额
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
grant select on ${iol_schema}.ibms_tfnd_nav to ${iml_schema};
grant select on ${iol_schema}.ibms_tfnd_nav to ${icl_schema};
grant select on ${iol_schema}.ibms_tfnd_nav to ${idl_schema};
grant select on ${iol_schema}.ibms_tfnd_nav to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tfnd_nav is '基金收益行情';
comment on column ${iol_schema}.ibms_tfnd_nav.f_id is '主键';
comment on column ${iol_schema}.ibms_tfnd_nav.i_code is '基金代码';
comment on column ${iol_schema}.ibms_tfnd_nav.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tfnd_nav.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tfnd_nav.f_totalnav is '总净价';
comment on column ${iol_schema}.ibms_tfnd_nav.f_yield_7d is '七天年化收益率';
comment on column ${iol_schema}.ibms_tfnd_nav.f_pubdate is '公布日期';
comment on column ${iol_schema}.ibms_tfnd_nav.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_tfnd_nav.end_date is '结束日期';
comment on column ${iol_schema}.ibms_tfnd_nav.imp_date is '导入时间';
comment on column ${iol_schema}.ibms_tfnd_nav.pipe_id is '管道id';
comment on column ${iol_schema}.ibms_tfnd_nav.f_cumu_nav is '累积单位净值';
comment on column ${iol_schema}.ibms_tfnd_nav.f_profit_1w is '七天万分收益';
comment on column ${iol_schema}.ibms_tfnd_nav.f_unitnav is '单位净价';
comment on column ${iol_schema}.ibms_tfnd_nav.f_scal is '基金规模（元）';
comment on column ${iol_schema}.ibms_tfnd_nav.f_count is '基金总份额';
comment on column ${iol_schema}.ibms_tfnd_nav.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tfnd_nav.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tfnd_nav.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tfnd_nav.etl_timestamp is 'ETL处理时间戳';
