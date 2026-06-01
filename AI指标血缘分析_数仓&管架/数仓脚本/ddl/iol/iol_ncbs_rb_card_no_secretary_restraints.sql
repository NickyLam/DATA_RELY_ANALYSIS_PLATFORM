/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_card_no_secretary_restraints
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_card_no_secretary_restraints
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_card_no_secretary_restraints(
    card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,limit_id varchar2(10) -- 限额编号
    ,limit_num number(5) -- 累计笔数
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,day_limit_avail number(17,2) -- 当日可用限额
    ,single_limit number(17,2) -- 账户单笔交易限额
    ,total_day_amt number(17,2) -- 单日累计小额免密限额
    ,no_password_status varchar2(1) -- 免密状态
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
grant select on ${iol_schema}.ncbs_rb_card_no_secretary_restraints to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_card_no_secretary_restraints to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_card_no_secretary_restraints to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_card_no_secretary_restraints to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_card_no_secretary_restraints is '借记卡小额免密限制信息表';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.company is '法人';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.limit_id is '限额编号';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.limit_num is '累计笔数';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.day_limit_avail is '当日可用限额';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.single_limit is '账户单笔交易限额';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.total_day_amt is '单日累计小额免密限额';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.no_password_status is '免密状态';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_card_no_secretary_restraints.etl_timestamp is 'ETL处理时间戳';
