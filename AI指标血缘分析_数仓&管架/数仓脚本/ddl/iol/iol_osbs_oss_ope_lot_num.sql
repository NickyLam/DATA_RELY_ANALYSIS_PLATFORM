/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_oss_ope_lot_num
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_oss_ope_lot_num
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_oss_ope_lot_num purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_oss_ope_lot_num(
    id varchar2(128) -- 主键序号
    ,ecif_no varchar2(128) -- 客户号
    ,act_no varchar2(128) -- 关联活动序号
    ,tas_no varchar2(128) -- 任务序号
    ,pro_no varchar2(128) -- 产品序号
    ,safe_no varchar2(128) -- 补送维护序号
    ,lot_num varchar2(12) -- 抽奖次数
    ,get_time varchar2(32) -- 获取时间
    ,get_channel varchar2(32) -- 获取渠道 0 通过任务形式 1 补送维护
    ,is_use varchar2(3) -- 是否使用 0 未使用 1 已使用
    ,oss_efetimestart varchar2(32) -- 生效开始时间
    ,oss_efetimeend varchar2(32) -- 生效结束时间
    ,oss_createtime varchar2(32) -- 创建时间
    ,oss_updatetime varchar2(32) -- 修改时间
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
grant select on ${iol_schema}.osbs_oss_ope_lot_num to ${iml_schema};
grant select on ${iol_schema}.osbs_oss_ope_lot_num to ${icl_schema};
grant select on ${iol_schema}.osbs_oss_ope_lot_num to ${idl_schema};
grant select on ${iol_schema}.osbs_oss_ope_lot_num to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_oss_ope_lot_num is '活动运营-抽奖次数表';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.id is '主键序号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.ecif_no is '客户号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.act_no is '关联活动序号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.tas_no is '任务序号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.pro_no is '产品序号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.safe_no is '补送维护序号';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.lot_num is '抽奖次数';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.get_time is '获取时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.get_channel is '获取渠道 0 通过任务形式 1 补送维护';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.is_use is '是否使用 0 未使用 1 已使用';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.oss_efetimestart is '生效开始时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.oss_efetimeend is '生效结束时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.oss_createtime is '创建时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.oss_updatetime is '修改时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_oss_ope_lot_num.etl_timestamp is 'ETL处理时间戳';
