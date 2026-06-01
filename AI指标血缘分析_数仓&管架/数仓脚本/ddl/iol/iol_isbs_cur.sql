/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cur
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cur
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cur purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cur(
    inr varchar2(12) -- 唯一inr
    ,cod varchar2(5) -- 货币种类
    ,newcur varchar2(5) -- 自定义的货币种类
    ,altcod varchar2(5) -- 可替换币种
    ,dec number(1,0) -- 货币小数位
    ,seq number(2,0) -- 利率录入操作列表
    ,acc1 varchar2(24) -- 账户兑换币种
    ,acc2 varchar2(24) -- 柜台账户兑换币种
    ,bsrmar number(14,6) -- 与中间价的差数
    ,sqrmar number(14,6) -- 与调整价的差数
    ,glbrat number(14,6) -- 账户平均汇率
    ,dif number(8,2) -- 汇率最大浮动值
    ,bas number(4,0) -- 基础汇率
    ,rndunt number(8,3) -- rounding unit of currency
    ,begdat date -- 开始时间
    ,enddat date -- 结束时间
    ,odrintday number(4,0) -- 汇率插入日期
    ,dbtday number(3,0) -- 借贷起息日
    ,cdtday number(3,0) -- 信贷起息日
    ,maxcur varchar2(5) -- 币种
    ,maxamt number(18,3) -- 最大金额
    ,ver varchar2(6) -- 版本号
    ,etgextkey varchar2(12) -- 实体组
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
grant select on ${iol_schema}.isbs_cur to ${iml_schema};
grant select on ${iol_schema}.isbs_cur to ${icl_schema};
grant select on ${iol_schema}.isbs_cur to ${idl_schema};
grant select on ${iol_schema}.isbs_cur to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cur is '货币信息';
comment on column ${iol_schema}.isbs_cur.inr is '唯一inr';
comment on column ${iol_schema}.isbs_cur.cod is '货币种类';
comment on column ${iol_schema}.isbs_cur.newcur is '自定义的货币种类';
comment on column ${iol_schema}.isbs_cur.altcod is '可替换币种';
comment on column ${iol_schema}.isbs_cur.dec is '货币小数位';
comment on column ${iol_schema}.isbs_cur.seq is '利率录入操作列表';
comment on column ${iol_schema}.isbs_cur.acc1 is '账户兑换币种';
comment on column ${iol_schema}.isbs_cur.acc2 is '柜台账户兑换币种';
comment on column ${iol_schema}.isbs_cur.bsrmar is '与中间价的差数';
comment on column ${iol_schema}.isbs_cur.sqrmar is '与调整价的差数';
comment on column ${iol_schema}.isbs_cur.glbrat is '账户平均汇率';
comment on column ${iol_schema}.isbs_cur.dif is '汇率最大浮动值';
comment on column ${iol_schema}.isbs_cur.bas is '基础汇率';
comment on column ${iol_schema}.isbs_cur.rndunt is 'rounding unit of currency';
comment on column ${iol_schema}.isbs_cur.begdat is '开始时间';
comment on column ${iol_schema}.isbs_cur.enddat is '结束时间';
comment on column ${iol_schema}.isbs_cur.odrintday is '汇率插入日期';
comment on column ${iol_schema}.isbs_cur.dbtday is '借贷起息日';
comment on column ${iol_schema}.isbs_cur.cdtday is '信贷起息日';
comment on column ${iol_schema}.isbs_cur.maxcur is '币种';
comment on column ${iol_schema}.isbs_cur.maxamt is '最大金额';
comment on column ${iol_schema}.isbs_cur.ver is '版本号';
comment on column ${iol_schema}.isbs_cur.etgextkey is '实体组';
comment on column ${iol_schema}.isbs_cur.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cur.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cur.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cur.etl_timestamp is 'ETL处理时间戳';
