/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubqsinsumcn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubqsinsumcn
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubqsinsumcn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubqsinsumcn(
    transdate varchar2(12) -- 清算日期
    ,coutseq number(22) -- 序号
    ,curr varchar2(5) -- 清算货币代码
    ,sect varchar2(3) -- 卡产品类型
    ,stac varchar2(3) -- 统计内容
    ,trol varchar2(3) -- 交易角色
    ,mstp varchar2(6) -- 报文类型
    ,pcod varchar2(3) -- 交易处理码
    ,pscc varchar2(3) -- 服务点条件码
    ,mdor varchar2(2) -- 交易发起方式
    ,scod varchar2(5) -- 交易代码
    ,cpro varchar2(3) -- 账户结算类型
    ,amot number(15,2) -- 交易金额
    ,traf number(15,2) -- 手续费
    ,logf number(15,2) -- 品牌费
    ,ertf number(15,2) -- 差错费用
    ,podf number(15,2) -- 周期计费
    ,stif number(15,2) -- 代授权费用
    ,plog number(15,2) -- 脱机交易小额打包品牌费
    ,neta number(15,2) -- 净金额
    ,brchbr varchar2(21) -- 机构代码
    ,clear_no varchar2(3) -- 银联清算场次号
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
grant select on ${iol_schema}.mpcs_a51ubqsinsumcn to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubqsinsumcn to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubqsinsumcn to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubqsinsumcn to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubqsinsumcn is '银联SUMN文件登记表';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.transdate is '清算日期';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.coutseq is '序号';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.curr is '清算货币代码';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.sect is '卡产品类型';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.stac is '统计内容';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.trol is '交易角色';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.mstp is '报文类型';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.pcod is '交易处理码';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.pscc is '服务点条件码';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.mdor is '交易发起方式';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.scod is '交易代码';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.cpro is '账户结算类型';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.amot is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.traf is '手续费';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.logf is '品牌费';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.ertf is '差错费用';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.podf is '周期计费';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.stif is '代授权费用';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.plog is '脱机交易小额打包品牌费';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.neta is '净金额';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.brchbr is '机构代码';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.clear_no is '银联清算场次号';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubqsinsumcn.etl_timestamp is 'ETL处理时间戳';
