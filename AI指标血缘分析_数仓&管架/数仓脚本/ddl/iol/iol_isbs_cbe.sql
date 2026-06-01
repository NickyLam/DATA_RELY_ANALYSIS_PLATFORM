/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cbe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cbe
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cbe purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cbe(
    inr varchar2(12) -- 唯一id
    ,objtyp varchar2(9) -- 对象类型
    ,objinr varchar2(12) -- 对象inr
    ,extid varchar2(24) -- 外部金额类型
    ,cbt varchar2(9) -- 金额类型
    ,trntyp varchar2(9) -- 交易表名
    ,trninr varchar2(12) -- 交易表的inr
    ,dat date -- 发生日期
    ,cur varchar2(5) -- 币种
    ,amt number(18,3) -- 金额
    ,relflg varchar2(2) -- 授权标志
    ,credat date -- 创建日期
    ,xrfcur varchar2(5) -- 折算币种
    ,xrfamt number(18,3) -- 折算后的金额
    ,nam varchar2(60) -- 描述
    ,acc varchar2(51) -- 账号1
    ,acc2 varchar2(51) -- 账号2
    ,optdat date -- 其他可选日期
    ,gledat date -- 记账日期
    ,nompct number(3,0) -- 保证金应收比例
    ,chkflg varchar2(2) -- 检查标志
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
grant select on ${iol_schema}.isbs_cbe to ${iml_schema};
grant select on ${iol_schema}.isbs_cbe to ${icl_schema};
grant select on ${iol_schema}.isbs_cbe to ${idl_schema};
grant select on ${iol_schema}.isbs_cbe to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cbe is 'CBB对应的发生额信息';
comment on column ${iol_schema}.isbs_cbe.inr is '唯一id';
comment on column ${iol_schema}.isbs_cbe.objtyp is '对象类型';
comment on column ${iol_schema}.isbs_cbe.objinr is '对象inr';
comment on column ${iol_schema}.isbs_cbe.extid is '外部金额类型';
comment on column ${iol_schema}.isbs_cbe.cbt is '金额类型';
comment on column ${iol_schema}.isbs_cbe.trntyp is '交易表名';
comment on column ${iol_schema}.isbs_cbe.trninr is '交易表的inr';
comment on column ${iol_schema}.isbs_cbe.dat is '发生日期';
comment on column ${iol_schema}.isbs_cbe.cur is '币种';
comment on column ${iol_schema}.isbs_cbe.amt is '金额';
comment on column ${iol_schema}.isbs_cbe.relflg is '授权标志';
comment on column ${iol_schema}.isbs_cbe.credat is '创建日期';
comment on column ${iol_schema}.isbs_cbe.xrfcur is '折算币种';
comment on column ${iol_schema}.isbs_cbe.xrfamt is '折算后的金额';
comment on column ${iol_schema}.isbs_cbe.nam is '描述';
comment on column ${iol_schema}.isbs_cbe.acc is '账号1';
comment on column ${iol_schema}.isbs_cbe.acc2 is '账号2';
comment on column ${iol_schema}.isbs_cbe.optdat is '其他可选日期';
comment on column ${iol_schema}.isbs_cbe.gledat is '记账日期';
comment on column ${iol_schema}.isbs_cbe.nompct is '保证金应收比例';
comment on column ${iol_schema}.isbs_cbe.chkflg is '检查标志';
comment on column ${iol_schema}.isbs_cbe.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cbe.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cbe.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cbe.etl_timestamp is 'ETL处理时间戳';
