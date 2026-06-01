/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_djb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_djb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_djb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_djb(
    inr varchar2(12) -- 主键
    ,trninr varchar2(12) -- trn表inr
    ,objinr varchar2(12) -- 关联表inr
    ,objtyp varchar2(9) -- 关联表类型
    ,thisint number(18,3) -- 本次代付利息金额
    ,thisdefint number(18,3) -- 本次代付罚息
    ,thisamt number(18,3) -- 本次代付本金金额
    ,stttendat date -- 付款期限开始时间
    ,ownref varchar2(24) -- 业务编号
    ,opertyp varchar2(2) -- 操作类型
    ,matdat date -- 交易到期
    ,jjh varchar2(36) -- 借据号
    ,iflastcol varchar2(2) -- 是否最后一次归集
    ,extkey varchar2(24) -- 客户号
    ,dfrate number(12,6) -- 代付利率
    ,dfdelrate number(12,6) -- 代付罚息利率
    ,cur varchar2(5) -- 代付币种
    ,amt number(18,3) -- 代付金额
    ,irtmic varchar2(5) -- 计息基准
    ,intadjamt number(17,2) -- 利息调整金额
    ,deladjamt number(17,2) -- 罚息调整金额
    ,sl_contract_no varchar2(45) -- 贷款合同号
    ,home_branch varchar2(18) -- 客户管理行
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
grant select on ${iol_schema}.isbs_djb to ${iml_schema};
grant select on ${iol_schema}.isbs_djb to ${icl_schema};
grant select on ${iol_schema}.isbs_djb to ${idl_schema};
grant select on ${iol_schema}.isbs_djb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_djb is '同业代付登记簿表';
comment on column ${iol_schema}.isbs_djb.inr is '主键';
comment on column ${iol_schema}.isbs_djb.trninr is 'trn表inr';
comment on column ${iol_schema}.isbs_djb.objinr is '关联表inr';
comment on column ${iol_schema}.isbs_djb.objtyp is '关联表类型';
comment on column ${iol_schema}.isbs_djb.thisint is '本次代付利息金额';
comment on column ${iol_schema}.isbs_djb.thisdefint is '本次代付罚息';
comment on column ${iol_schema}.isbs_djb.thisamt is '本次代付本金金额';
comment on column ${iol_schema}.isbs_djb.stttendat is '付款期限开始时间';
comment on column ${iol_schema}.isbs_djb.ownref is '业务编号';
comment on column ${iol_schema}.isbs_djb.opertyp is '操作类型';
comment on column ${iol_schema}.isbs_djb.matdat is '交易到期';
comment on column ${iol_schema}.isbs_djb.jjh is '借据号';
comment on column ${iol_schema}.isbs_djb.iflastcol is '是否最后一次归集';
comment on column ${iol_schema}.isbs_djb.extkey is '客户号';
comment on column ${iol_schema}.isbs_djb.dfrate is '代付利率';
comment on column ${iol_schema}.isbs_djb.dfdelrate is '代付罚息利率';
comment on column ${iol_schema}.isbs_djb.cur is '代付币种';
comment on column ${iol_schema}.isbs_djb.amt is '代付金额';
comment on column ${iol_schema}.isbs_djb.irtmic is '计息基准';
comment on column ${iol_schema}.isbs_djb.intadjamt is '利息调整金额';
comment on column ${iol_schema}.isbs_djb.deladjamt is '罚息调整金额';
comment on column ${iol_schema}.isbs_djb.sl_contract_no is '贷款合同号';
comment on column ${iol_schema}.isbs_djb.home_branch is '客户管理行';
comment on column ${iol_schema}.isbs_djb.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_djb.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_djb.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_djb.etl_timestamp is 'ETL处理时间戳';
