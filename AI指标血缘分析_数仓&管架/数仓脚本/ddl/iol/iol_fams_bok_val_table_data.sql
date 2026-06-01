/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_val_table_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_val_table_data
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_val_table_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_val_table_data(
    seq_no varchar2(33) -- 流水号
    ,bookset_id varchar2(50) -- 账套代码
    ,bookset_name varchar2(200) -- 账套名称
    ,profit_type varchar2(50) -- 收益类型
    ,val_date date -- 估值日期
    ,detail_dist varchar2(50) -- 明细区分
    ,layering_id varchar2(80) -- 分层代码
    ,subject_no varchar2(300) -- 科目号
    ,subject_name varchar2(500) -- 科目名称
    ,fsubject_id varchar2(32) -- 上级科目号
    ,num_amt number(30,2) -- 数量
    ,unit_cost number(32,4) -- 单位成本
    ,cost number(30,2) -- 本币成本
    ,cost_percent number(30,14) -- 本币成本占净值比
    ,close_price number(30,14) -- 行情收市价
    ,market_value number(30,2) -- 本币估值
    ,value_percent number(30,14) -- 本币估值占净值比
    ,value_increment number(30,2) -- 本币估值增值
    ,bal_flag varchar2(50) -- 余额方向
    ,shadow_price_value number(30,2) -- 影子价格估值
    ,market_val_date date -- 行情日期
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,o_ccy varchar2(50) -- 原币币种
    ,exchange_rate number(15,8) -- 汇率(原币对本币)
    ,o_cost number(30,2) -- 原币成本
    ,o_market_value number(30,2) -- 原币估值
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
grant select on ${iol_schema}.fams_bok_val_table_data to ${iml_schema};
grant select on ${iol_schema}.fams_bok_val_table_data to ${icl_schema};
grant select on ${iol_schema}.fams_bok_val_table_data to ${idl_schema};
grant select on ${iol_schema}.fams_bok_val_table_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_val_table_data is '估值表数据';
comment on column ${iol_schema}.fams_bok_val_table_data.seq_no is '流水号';
comment on column ${iol_schema}.fams_bok_val_table_data.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_val_table_data.bookset_name is '账套名称';
comment on column ${iol_schema}.fams_bok_val_table_data.profit_type is '收益类型';
comment on column ${iol_schema}.fams_bok_val_table_data.val_date is '估值日期';
comment on column ${iol_schema}.fams_bok_val_table_data.detail_dist is '明细区分';
comment on column ${iol_schema}.fams_bok_val_table_data.layering_id is '分层代码';
comment on column ${iol_schema}.fams_bok_val_table_data.subject_no is '科目号';
comment on column ${iol_schema}.fams_bok_val_table_data.subject_name is '科目名称';
comment on column ${iol_schema}.fams_bok_val_table_data.fsubject_id is '上级科目号';
comment on column ${iol_schema}.fams_bok_val_table_data.num_amt is '数量';
comment on column ${iol_schema}.fams_bok_val_table_data.unit_cost is '单位成本';
comment on column ${iol_schema}.fams_bok_val_table_data.cost is '本币成本';
comment on column ${iol_schema}.fams_bok_val_table_data.cost_percent is '本币成本占净值比';
comment on column ${iol_schema}.fams_bok_val_table_data.close_price is '行情收市价';
comment on column ${iol_schema}.fams_bok_val_table_data.market_value is '本币估值';
comment on column ${iol_schema}.fams_bok_val_table_data.value_percent is '本币估值占净值比';
comment on column ${iol_schema}.fams_bok_val_table_data.value_increment is '本币估值增值';
comment on column ${iol_schema}.fams_bok_val_table_data.bal_flag is '余额方向';
comment on column ${iol_schema}.fams_bok_val_table_data.shadow_price_value is '影子价格估值';
comment on column ${iol_schema}.fams_bok_val_table_data.market_val_date is '行情日期';
comment on column ${iol_schema}.fams_bok_val_table_data.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_val_table_data.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_val_table_data.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_val_table_data.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_val_table_data.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_val_table_data.o_ccy is '原币币种';
comment on column ${iol_schema}.fams_bok_val_table_data.exchange_rate is '汇率(原币对本币)';
comment on column ${iol_schema}.fams_bok_val_table_data.o_cost is '原币成本';
comment on column ${iol_schema}.fams_bok_val_table_data.o_market_value is '原币估值';
comment on column ${iol_schema}.fams_bok_val_table_data.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_val_table_data.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_val_table_data.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_val_table_data.etl_timestamp is 'ETL处理时间戳';
