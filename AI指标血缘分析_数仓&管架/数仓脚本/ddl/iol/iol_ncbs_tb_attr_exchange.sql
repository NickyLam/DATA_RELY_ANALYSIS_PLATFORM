/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_attr_exchange
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_attr_exchange
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_attr_exchange purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_attr_exchange(
    reference varchar2(50) -- 交易参考号
    ,company varchar2(20) -- 法人
    ,end_no varchar2(50) -- 终止号码数字串
    ,goods_name varchar2(50) -- 附属物品名称
    ,num number(5) -- 数量
    ,start_no varchar2(50) -- 起始号码数字串
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,details_seq_no varchar2(50) -- 明细序号
    ,tb_exchange_id varchar2(50) -- 尾箱交接编号
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
grant select on ${iol_schema}.ncbs_tb_attr_exchange to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_attr_exchange to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_attr_exchange to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_attr_exchange to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_attr_exchange is '尾箱交接附属物品信息表';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.company is '法人';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.end_no is '终止号码数字串';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.goods_name is '附属物品名称';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.num is '数量';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.start_no is '起始号码数字串';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.details_seq_no is '明细序号';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.tb_exchange_id is '尾箱交接编号';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_attr_exchange.etl_timestamp is 'ETL处理时间戳';
