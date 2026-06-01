/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_equity_nav
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_equity_nav
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_equity_nav purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_nav(
    e_id number(16,0) -- 主键
    ,i_code varchar2(45) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,total_nav number(38,4) -- 总净值
    ,unit_nav number(10,6) -- 单位净值
    ,profit_1w number(15,6) -- 万份收益
    ,yield_7d number(10,6) -- 7日年华收益
    ,pub_date varchar2(15) -- 公布日期
    ,beg_date varchar2(15) -- 生效日
    ,end_date varchar2(15) -- 失效日
    ,imp_date varchar2(15) -- 
    ,pipe_id number(22,0) -- 
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
grant select on ${iol_schema}.ibms_ttrd_equity_nav to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_nav to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_nav to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_nav to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_equity_nav is '';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.e_id is '主键';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.total_nav is '总净值';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.unit_nav is '单位净值';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.profit_1w is '万份收益';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.yield_7d is '7日年华收益';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.pub_date is '公布日期';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.beg_date is '生效日';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.end_date is '失效日';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.imp_date is '';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.pipe_id is '';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_equity_nav.etl_timestamp is 'ETL处理时间戳';
