/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cbb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cbb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cbb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cbb(
    inr varchar2(12) -- 唯一id
    ,objtyp varchar2(9) -- 对象表名称
    ,objinr varchar2(12) -- 对象inr
    ,cbc varchar2(9) -- 金额类型
    ,extid varchar2(24) -- 外部金额类型
    ,begdat date -- 起始日期
    ,enddat date -- 结束日期
    ,cur varchar2(5) -- 币种
    ,amt number(18,3) -- 金额
    ,cbeinr varchar2(12) -- cbe的inr
    ,xrfcur varchar2(5) -- 折算币种
    ,xrfamt number(18,3) -- 折算后金额
    ,comcur varchar2(5) -- 用于统计的币种
    ,comamt number(18,3) -- 用于统计的折算后金额
    ,xcocur varchar2(5) -- 用于统计的折算币种
    ,xcoamt number(18,3) -- 用于统计的金额折算成系统币种的金额
    ,frenum varchar2(24) -- 冻结编号
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
grant select on ${iol_schema}.isbs_cbb to ${iml_schema};
grant select on ${iol_schema}.isbs_cbb to ${icl_schema};
grant select on ${iol_schema}.isbs_cbb to ${idl_schema};
grant select on ${iol_schema}.isbs_cbb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cbb is 'Contract Balance信息';
comment on column ${iol_schema}.isbs_cbb.inr is '唯一id';
comment on column ${iol_schema}.isbs_cbb.objtyp is '对象表名称';
comment on column ${iol_schema}.isbs_cbb.objinr is '对象inr';
comment on column ${iol_schema}.isbs_cbb.cbc is '金额类型';
comment on column ${iol_schema}.isbs_cbb.extid is '外部金额类型';
comment on column ${iol_schema}.isbs_cbb.begdat is '起始日期';
comment on column ${iol_schema}.isbs_cbb.enddat is '结束日期';
comment on column ${iol_schema}.isbs_cbb.cur is '币种';
comment on column ${iol_schema}.isbs_cbb.amt is '金额';
comment on column ${iol_schema}.isbs_cbb.cbeinr is 'cbe的inr';
comment on column ${iol_schema}.isbs_cbb.xrfcur is '折算币种';
comment on column ${iol_schema}.isbs_cbb.xrfamt is '折算后金额';
comment on column ${iol_schema}.isbs_cbb.comcur is '用于统计的币种';
comment on column ${iol_schema}.isbs_cbb.comamt is '用于统计的折算后金额';
comment on column ${iol_schema}.isbs_cbb.xcocur is '用于统计的折算币种';
comment on column ${iol_schema}.isbs_cbb.xcoamt is '用于统计的金额折算成系统币种的金额';
comment on column ${iol_schema}.isbs_cbb.frenum is '冻结编号';
comment on column ${iol_schema}.isbs_cbb.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cbb.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cbb.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cbb.etl_timestamp is 'ETL处理时间戳';
