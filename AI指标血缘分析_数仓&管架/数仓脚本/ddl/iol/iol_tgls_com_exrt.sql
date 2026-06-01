/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_exrt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_exrt
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_exrt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_exrt(
    crcycd varchar2(3) -- 币种代码
    ,efctdt varchar2(8) -- 生效日期
    ,inefdt varchar2(8) -- 失效日期
    ,exrtst varchar2(1) -- 状态
    ,crcyna varchar2(200) -- 中文名称
    ,crcyen varchar2(3) -- 英文简称
    ,exunit number -- 换算单位
    ,csbypr number(12,7) -- 钞买价
    ,csslpr number(12,7) -- 钞卖价
    ,exbypr number(12,7) -- 汇买价
    ,exslpr number(12,7) -- 汇卖价
    ,middpr number(12,7) -- 中间价
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
grant select on ${iol_schema}.tgls_com_exrt to ${iml_schema};
grant select on ${iol_schema}.tgls_com_exrt to ${icl_schema};
grant select on ${iol_schema}.tgls_com_exrt to ${idl_schema};
grant select on ${iol_schema}.tgls_com_exrt to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_exrt is '人行汇率';
comment on column ${iol_schema}.tgls_com_exrt.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_com_exrt.efctdt is '生效日期';
comment on column ${iol_schema}.tgls_com_exrt.inefdt is '失效日期';
comment on column ${iol_schema}.tgls_com_exrt.exrtst is '状态';
comment on column ${iol_schema}.tgls_com_exrt.crcyna is '中文名称';
comment on column ${iol_schema}.tgls_com_exrt.crcyen is '英文简称';
comment on column ${iol_schema}.tgls_com_exrt.exunit is '换算单位';
comment on column ${iol_schema}.tgls_com_exrt.csbypr is '钞买价';
comment on column ${iol_schema}.tgls_com_exrt.csslpr is '钞卖价';
comment on column ${iol_schema}.tgls_com_exrt.exbypr is '汇买价';
comment on column ${iol_schema}.tgls_com_exrt.exslpr is '汇卖价';
comment on column ${iol_schema}.tgls_com_exrt.middpr is '中间价';
comment on column ${iol_schema}.tgls_com_exrt.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_exrt.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_exrt.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_exrt.etl_timestamp is 'ETL处理时间戳';
