/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_xrt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_xrt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_xrt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_xrt(
    inr varchar2(12) -- 唯一id
    ,cur varchar2(5) -- 货币
    ,begdat date -- 开始日期
    ,enddat date -- 结束日期
    ,buyrat number(14,6) -- 买入价格
    ,midrat number(14,6) -- 中间价格
    ,selrat number(14,6) -- 卖出价格
    ,ttrrat number(14,6) -- 指定买价
    ,odrrat number(14,6) -- 指定卖价
    ,ver varchar2(6) -- 版本
    ,resrat number(14,6) -- 卖出参考汇率
    ,rebrat number(14,6) -- 买入参考汇率
    ,ibrrat number(14,6) -- 内部
    ,sel1rat number(14,6) -- 买入价格1
    ,buy1rat number(14,6) -- 钞买入价格
    ,etgextkey varchar2(12) -- 实体
    ,xrttim varchar2(30) -- xrt时间
    ,inebpr number(14,7) -- 现钞买入价
    ,inespr number(14,7) -- 现钞卖出价
    ,inslpr number(14,7) -- 内部价
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
grant select on ${iol_schema}.isbs_xrt to ${iml_schema};
grant select on ${iol_schema}.isbs_xrt to ${icl_schema};
grant select on ${iol_schema}.isbs_xrt to ${idl_schema};
grant select on ${iol_schema}.isbs_xrt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_xrt is '汇率表';
comment on column ${iol_schema}.isbs_xrt.inr is '唯一id';
comment on column ${iol_schema}.isbs_xrt.cur is '货币';
comment on column ${iol_schema}.isbs_xrt.begdat is '开始日期';
comment on column ${iol_schema}.isbs_xrt.enddat is '结束日期';
comment on column ${iol_schema}.isbs_xrt.buyrat is '买入价格';
comment on column ${iol_schema}.isbs_xrt.midrat is '中间价格';
comment on column ${iol_schema}.isbs_xrt.selrat is '卖出价格';
comment on column ${iol_schema}.isbs_xrt.ttrrat is '指定买价';
comment on column ${iol_schema}.isbs_xrt.odrrat is '指定卖价';
comment on column ${iol_schema}.isbs_xrt.ver is '版本';
comment on column ${iol_schema}.isbs_xrt.resrat is '卖出参考汇率';
comment on column ${iol_schema}.isbs_xrt.rebrat is '买入参考汇率';
comment on column ${iol_schema}.isbs_xrt.ibrrat is '内部';
comment on column ${iol_schema}.isbs_xrt.sel1rat is '买入价格1';
comment on column ${iol_schema}.isbs_xrt.buy1rat is '钞买入价格';
comment on column ${iol_schema}.isbs_xrt.etgextkey is '实体';
comment on column ${iol_schema}.isbs_xrt.xrttim is 'xrt时间';
comment on column ${iol_schema}.isbs_xrt.inebpr is '现钞买入价';
comment on column ${iol_schema}.isbs_xrt.inespr is '现钞卖出价';
comment on column ${iol_schema}.isbs_xrt.inslpr is '内部价';
comment on column ${iol_schema}.isbs_xrt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_xrt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_xrt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_xrt.etl_timestamp is 'ETL处理时间戳';
