/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharemjrholdertrade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharemjrholdertrade
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharemjrholdertrade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharemjrholdertrade(
    object_id varchar2(150) -- 对象id
    ,s_info_windcode varchar2(60) -- wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,transact_startdate varchar2(12) -- 变动起始日期
    ,transact_enddate varchar2(12) -- 变动截至日期
    ,holder_name varchar2(750) -- 持有人
    ,holder_type varchar2(2) -- 持有人类型
    ,transact_type varchar2(15) -- 买卖方向
    ,transact_quantity number(20,4) -- 变动数量
    ,transact_quantity_ratio number(20,4) -- 变动数量占流通量比例(%)
    ,holder_quantity_new number(20,4) -- 最新持有流通数量
    ,holder_quantity_new_ratio number(20,4) -- 最新持有流通数量占流通量比例(%)
    ,avg_price number(20,4) -- 平均价格
    ,whether_agreed_repur_trans number(1,0) -- 是否约定购回式交易
    ,blocktrade_quantity number(20,4) -- 通过大宗交易系统的变动数量
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_asharemjrholdertrade to ${iml_schema};
grant select on ${iol_schema}.wind_asharemjrholdertrade to ${icl_schema};
grant select on ${iol_schema}.wind_asharemjrholdertrade to ${idl_schema};
grant select on ${iol_schema}.wind_asharemjrholdertrade to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharemjrholdertrade is '中国A股重要股东增减持';
comment on column ${iol_schema}.wind_asharemjrholdertrade.object_id is '对象id';
comment on column ${iol_schema}.wind_asharemjrholdertrade.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_asharemjrholdertrade.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharemjrholdertrade.transact_startdate is '变动起始日期';
comment on column ${iol_schema}.wind_asharemjrholdertrade.transact_enddate is '变动截至日期';
comment on column ${iol_schema}.wind_asharemjrholdertrade.holder_name is '持有人';
comment on column ${iol_schema}.wind_asharemjrholdertrade.holder_type is '持有人类型';
comment on column ${iol_schema}.wind_asharemjrholdertrade.transact_type is '买卖方向';
comment on column ${iol_schema}.wind_asharemjrholdertrade.transact_quantity is '变动数量';
comment on column ${iol_schema}.wind_asharemjrholdertrade.transact_quantity_ratio is '变动数量占流通量比例(%)';
comment on column ${iol_schema}.wind_asharemjrholdertrade.holder_quantity_new is '最新持有流通数量';
comment on column ${iol_schema}.wind_asharemjrholdertrade.holder_quantity_new_ratio is '最新持有流通数量占流通量比例(%)';
comment on column ${iol_schema}.wind_asharemjrholdertrade.avg_price is '平均价格';
comment on column ${iol_schema}.wind_asharemjrholdertrade.whether_agreed_repur_trans is '是否约定购回式交易';
comment on column ${iol_schema}.wind_asharemjrholdertrade.blocktrade_quantity is '通过大宗交易系统的变动数量';
comment on column ${iol_schema}.wind_asharemjrholdertrade.opdate is '';
comment on column ${iol_schema}.wind_asharemjrholdertrade.opmode is '';
comment on column ${iol_schema}.wind_asharemjrholdertrade.start_dt is '开始时间';
comment on column ${iol_schema}.wind_asharemjrholdertrade.end_dt is '结束时间';
comment on column ${iol_schema}.wind_asharemjrholdertrade.id_mark is '增删标志';
comment on column ${iol_schema}.wind_asharemjrholdertrade.etl_timestamp is 'ETL处理时间戳';
