/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_valbal_table_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_valbal_table_status
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_valbal_table_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_valbal_table_status(
    finprod_id varchar2(100) -- 产品代码
    ,finprod_name varchar2(200) -- 产品名称
    ,val_date date -- 估值日期
    ,val_bal_flag varchar2(100) -- 估值表余额表标志
    ,capital number(30,2) -- 理财份额
    ,asset_value number(30,2) -- 产品总净值/本日收益
    ,total_net_value number(30,14) -- 累计净值
    ,seven_day_rate number(30,14) -- 七日年化收益率
    ,pay_profit number(30,14) -- 应付利润
    ,file_id varchar2(1000) -- 附件uuid
    ,net_unit_value number(30,14) -- 单位净值/万份收益/利率
    ,check_status varchar2(100) -- 对账状态
    ,check_result varchar2(100) -- 对账结果
    ,confirm_status varchar2(100) -- 确认状态
    ,notice_status varchar2(100) -- 下发状态
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,tdy_yield number(30,14) -- 当日年化收益率
    ,redeem_notice_status varchar2(100) -- 总额到期数据下发状态
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
grant select on ${iol_schema}.fams_bok_valbal_table_status to ${iml_schema};
grant select on ${iol_schema}.fams_bok_valbal_table_status to ${icl_schema};
grant select on ${iol_schema}.fams_bok_valbal_table_status to ${idl_schema};
grant select on ${iol_schema}.fams_bok_valbal_table_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_valbal_table_status is '估值表余额表状态表';
comment on column ${iol_schema}.fams_bok_valbal_table_status.finprod_id is '产品代码';
comment on column ${iol_schema}.fams_bok_valbal_table_status.finprod_name is '产品名称';
comment on column ${iol_schema}.fams_bok_valbal_table_status.val_date is '估值日期';
comment on column ${iol_schema}.fams_bok_valbal_table_status.val_bal_flag is '估值表余额表标志';
comment on column ${iol_schema}.fams_bok_valbal_table_status.capital is '理财份额';
comment on column ${iol_schema}.fams_bok_valbal_table_status.asset_value is '产品总净值/本日收益';
comment on column ${iol_schema}.fams_bok_valbal_table_status.total_net_value is '累计净值';
comment on column ${iol_schema}.fams_bok_valbal_table_status.seven_day_rate is '七日年化收益率';
comment on column ${iol_schema}.fams_bok_valbal_table_status.pay_profit is '应付利润';
comment on column ${iol_schema}.fams_bok_valbal_table_status.file_id is '附件uuid';
comment on column ${iol_schema}.fams_bok_valbal_table_status.net_unit_value is '单位净值/万份收益/利率';
comment on column ${iol_schema}.fams_bok_valbal_table_status.check_status is '对账状态';
comment on column ${iol_schema}.fams_bok_valbal_table_status.check_result is '对账结果';
comment on column ${iol_schema}.fams_bok_valbal_table_status.confirm_status is '确认状态';
comment on column ${iol_schema}.fams_bok_valbal_table_status.notice_status is '下发状态';
comment on column ${iol_schema}.fams_bok_valbal_table_status.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_valbal_table_status.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_valbal_table_status.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_valbal_table_status.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_valbal_table_status.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_valbal_table_status.tdy_yield is '当日年化收益率';
comment on column ${iol_schema}.fams_bok_valbal_table_status.redeem_notice_status is '总额到期数据下发状态';
comment on column ${iol_schema}.fams_bok_valbal_table_status.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_valbal_table_status.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_valbal_table_status.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_valbal_table_status.etl_timestamp is 'ETL处理时间戳';
