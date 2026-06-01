/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_red
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_red
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_red purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_red(
    inr varchar2(12) -- 内部唯一流水号，主键
    ,sptinr varchar2(12) -- spt表inr
    ,smhinr varchar2(12) -- smh表inr
    ,trninr varchar2(12) -- trn表inr
    ,pyeacc varchar2(60) -- 收款人账号
    ,orcblk varchar2(212) -- 汇款人信息
    ,pyeblk varchar2(210) -- 收款人信息
    ,orcacc varchar2(60) -- 汇款人账号
    ,flg varchar2(2) -- 是否满足线上收汇确认条件标志
    ,inidattim timestamp -- 发起时间
    ,cur varchar2(5) -- 汇入币种
    ,amt number(16,3) -- 汇入金额
    ,orcbanknam varchar2(60) -- 汇款行名
    ,orcbic varchar2(17) -- 汇款行bic
    ,sndbic varchar2(18) -- 发报行bic
    ,dbusta varchar2(2) -- 收款客户单位基本情况表报送标志
    ,goptyp varchar2(2) -- 收款客户企业分类情况
    ,sigsta varchar2(2) -- 收款客户交易门户签约标志
    ,pyeextkey varchar2(30) -- 收款客户账号
    ,inftxt varchar2(120) -- 摘要信息
    ,docoth103 varchar2(120) -- 103报文路径
    ,docoth202 varchar2(120) -- 202报文路径
    ,monnat varchar2(2) -- 款项性质
    ,sta varchar2(2) -- 交易状态
    ,imgnum varchar2(45) -- 影像受理号
    ,boptxt varchar2(180) -- 申报信息数据
    ,zjcflg varchar2(2) -- 跨境资金池标识
    ,edtyp varchar2(2) -- 资金池业务类型
    ,basamt number(18,3) -- 资金池业务本金
    ,intamt number(18,3) -- 资金池业务利息
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
grant select on ${iol_schema}.isbs_red to ${iml_schema};
grant select on ${iol_schema}.isbs_red to ${icl_schema};
grant select on ${iol_schema}.isbs_red to ${idl_schema};
grant select on ${iol_schema}.isbs_red to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_red is '线上汇入汇款状态信息表';
comment on column ${iol_schema}.isbs_red.inr is '内部唯一流水号，主键';
comment on column ${iol_schema}.isbs_red.sptinr is 'spt表inr';
comment on column ${iol_schema}.isbs_red.smhinr is 'smh表inr';
comment on column ${iol_schema}.isbs_red.trninr is 'trn表inr';
comment on column ${iol_schema}.isbs_red.pyeacc is '收款人账号';
comment on column ${iol_schema}.isbs_red.orcblk is '汇款人信息';
comment on column ${iol_schema}.isbs_red.pyeblk is '收款人信息';
comment on column ${iol_schema}.isbs_red.orcacc is '汇款人账号';
comment on column ${iol_schema}.isbs_red.flg is '是否满足线上收汇确认条件标志';
comment on column ${iol_schema}.isbs_red.inidattim is '发起时间';
comment on column ${iol_schema}.isbs_red.cur is '汇入币种';
comment on column ${iol_schema}.isbs_red.amt is '汇入金额';
comment on column ${iol_schema}.isbs_red.orcbanknam is '汇款行名';
comment on column ${iol_schema}.isbs_red.orcbic is '汇款行bic';
comment on column ${iol_schema}.isbs_red.sndbic is '发报行bic';
comment on column ${iol_schema}.isbs_red.dbusta is '收款客户单位基本情况表报送标志';
comment on column ${iol_schema}.isbs_red.goptyp is '收款客户企业分类情况';
comment on column ${iol_schema}.isbs_red.sigsta is '收款客户交易门户签约标志';
comment on column ${iol_schema}.isbs_red.pyeextkey is '收款客户账号';
comment on column ${iol_schema}.isbs_red.inftxt is '摘要信息';
comment on column ${iol_schema}.isbs_red.docoth103 is '103报文路径';
comment on column ${iol_schema}.isbs_red.docoth202 is '202报文路径';
comment on column ${iol_schema}.isbs_red.monnat is '款项性质';
comment on column ${iol_schema}.isbs_red.sta is '交易状态';
comment on column ${iol_schema}.isbs_red.imgnum is '影像受理号';
comment on column ${iol_schema}.isbs_red.boptxt is '申报信息数据';
comment on column ${iol_schema}.isbs_red.zjcflg is '跨境资金池标识';
comment on column ${iol_schema}.isbs_red.edtyp is '资金池业务类型';
comment on column ${iol_schema}.isbs_red.basamt is '资金池业务本金';
comment on column ${iol_schema}.isbs_red.intamt is '资金池业务利息';
comment on column ${iol_schema}.isbs_red.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_red.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_red.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_red.etl_timestamp is 'ETL处理时间戳';
