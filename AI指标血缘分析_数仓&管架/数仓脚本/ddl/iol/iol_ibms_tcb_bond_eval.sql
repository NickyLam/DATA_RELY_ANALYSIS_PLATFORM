/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tcb_bond_eval
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tcb_bond_eval
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tcb_bond_eval purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tcb_bond_eval(
    i_code varchar2(45) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,netprice number(10,4) -- 净价金额
    ,ai number(38,4) -- 应计利息
    ,yield number(10,6) -- 估价收益率
    ,term number(10,6) -- 待偿期
    ,modified_d number(10,6) -- 估价修正久期
    ,convexity number(10,6) -- 估价凸性
    ,dvbp number(10,6) -- 估价基点价值
    ,rd_modified number(10,6) -- 估价利差久期
    ,rd_convexity number(10,6) -- 估价利差凸性
    ,r_modified number(10,6) -- 估价利率久期
    ,r_convexity number(10,6) -- 估价利率凸性
    ,fullprice number(10,4) -- 估值类型
    ,is_onedate number(22) -- 来源
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22) -- 管道编号
    ,rd_yield number(12,6) -- 点差收益率
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_tcb_bond_eval to ${iml_schema};
grant select on ${iol_schema}.ibms_tcb_bond_eval to ${icl_schema};
grant select on ${iol_schema}.ibms_tcb_bond_eval to ${idl_schema};
grant select on ${iol_schema}.ibms_tcb_bond_eval to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tcb_bond_eval is '债券估值表';
comment on column ${iol_schema}.ibms_tcb_bond_eval.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tcb_bond_eval.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tcb_bond_eval.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tcb_bond_eval.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.end_date is '结束日期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.netprice is '净价金额';
comment on column ${iol_schema}.ibms_tcb_bond_eval.ai is '应计利息';
comment on column ${iol_schema}.ibms_tcb_bond_eval.yield is '估价收益率';
comment on column ${iol_schema}.ibms_tcb_bond_eval.term is '待偿期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.modified_d is '估价修正久期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.convexity is '估价凸性';
comment on column ${iol_schema}.ibms_tcb_bond_eval.dvbp is '估价基点价值';
comment on column ${iol_schema}.ibms_tcb_bond_eval.rd_modified is '估价利差久期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.rd_convexity is '估价利差凸性';
comment on column ${iol_schema}.ibms_tcb_bond_eval.r_modified is '估价利率久期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.r_convexity is '估价利率凸性';
comment on column ${iol_schema}.ibms_tcb_bond_eval.fullprice is '估值类型';
comment on column ${iol_schema}.ibms_tcb_bond_eval.is_onedate is '来源';
comment on column ${iol_schema}.ibms_tcb_bond_eval.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.pipe_id is '管道编号';
comment on column ${iol_schema}.ibms_tcb_bond_eval.rd_yield is '点差收益率';
comment on column ${iol_schema}.ibms_tcb_bond_eval.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_tcb_bond_eval.etl_timestamp is 'ETL处理时间戳';
