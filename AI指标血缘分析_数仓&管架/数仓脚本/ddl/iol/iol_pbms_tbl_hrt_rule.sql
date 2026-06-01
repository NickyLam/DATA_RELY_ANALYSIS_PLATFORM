/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_hrt_rule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_hrt_rule
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_hrt_rule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_hrt_rule(
    pk_hrt_rule number(22) -- 主键
    ,activity_code varchar2(192) -- 活动代码
    ,rule_name varchar2(384) -- 规则名称
    ,stat_item varchar2(192) -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
    ,window_days number(22) -- 观察期天数，如30天内
    ,min_value number(18,2) -- 下限值
    ,include_min varchar2(3) -- 是否包含下限：0-不含，1-含
    ,max_value number(18,2) -- 上限值，为空或null则为无上限
    ,include_max varchar2(3) -- 是否包含上限：0-不含，1-含
    ,unit varchar2(3) -- 单位：0-元，1-万元，2-百万元
    ,effective_begin date -- 生效时间
    ,effective_end date -- 失效时间
    ,status varchar2(3) -- 状态：0-未启用，1-启用
    ,remark varchar2(4000) -- 备注
    ,created_by varchar2(60) -- 创建人，系统创建写system
    ,create_time varchar2(60) -- 创建时间
    ,updated_by varchar2(60) -- 更新人，系统创建写system
    ,update_time varchar2(60) -- 更新时间
    ,del_flag number(22,0) -- 逻辑删除标志（0-正常，1-删除）
    ,give_bonus number(18,2) -- 赠送积分
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
grant select on ${iol_schema}.pbms_tbl_hrt_rule to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_rule to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_rule to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_rule to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_hrt_rule is '华润通资产达标及区间规则表';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.pk_hrt_rule is '主键';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.activity_code is '活动代码';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.rule_name is '规则名称';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.stat_item is '统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.window_days is '观察期天数，如30天内';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.min_value is '下限值';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.include_min is '是否包含下限：0-不含，1-含';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.max_value is '上限值，为空或null则为无上限';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.include_max is '是否包含上限：0-不含，1-含';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.unit is '单位：0-元，1-万元，2-百万元';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.effective_begin is '生效时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.effective_end is '失效时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.status is '状态：0-未启用，1-启用';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.remark is '备注';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.created_by is '创建人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.updated_by is '更新人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.update_time is '更新时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.del_flag is '逻辑删除标志（0-正常，1-删除）';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.give_bonus is '赠送积分';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_hrt_rule.etl_timestamp is 'ETL处理时间戳';
