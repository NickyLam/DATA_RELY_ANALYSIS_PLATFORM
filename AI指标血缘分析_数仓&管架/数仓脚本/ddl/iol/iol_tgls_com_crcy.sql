/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_crcy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_crcy
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_crcy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_crcy(
    crcycd varchar2(3) -- 币种代码
    ,crcyna varchar2(200) -- 币种名称
    ,crcyen varchar2(3) -- 币种数字代号
    ,crcysg varchar2(3) -- 币种符号
    ,crcydg number -- 币种小数位
    ,crcycg number -- 币种找零位
    ,dibstg varchar2(1) -- 找零标志
    ,usabtg varchar2(1) -- 启用标志
    ,cysgdg number -- 分段利息小数位
    ,isfold number(1) -- 是否折币币种
    ,convmd number(1) -- 折算方法类型
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
grant select on ${iol_schema}.tgls_com_crcy to ${iml_schema};
grant select on ${iol_schema}.tgls_com_crcy to ${icl_schema};
grant select on ${iol_schema}.tgls_com_crcy to ${idl_schema};
grant select on ${iol_schema}.tgls_com_crcy to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_crcy is '币种参数';
comment on column ${iol_schema}.tgls_com_crcy.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_com_crcy.crcyna is '币种名称';
comment on column ${iol_schema}.tgls_com_crcy.crcyen is '币种数字代号';
comment on column ${iol_schema}.tgls_com_crcy.crcysg is '币种符号';
comment on column ${iol_schema}.tgls_com_crcy.crcydg is '币种小数位';
comment on column ${iol_schema}.tgls_com_crcy.crcycg is '币种找零位';
comment on column ${iol_schema}.tgls_com_crcy.dibstg is '找零标志';
comment on column ${iol_schema}.tgls_com_crcy.usabtg is '启用标志';
comment on column ${iol_schema}.tgls_com_crcy.cysgdg is '分段利息小数位';
comment on column ${iol_schema}.tgls_com_crcy.isfold is '是否折币币种';
comment on column ${iol_schema}.tgls_com_crcy.convmd is '折算方法类型';
comment on column ${iol_schema}.tgls_com_crcy.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_crcy.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_crcy.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_crcy.etl_timestamp is 'ETL处理时间戳';
