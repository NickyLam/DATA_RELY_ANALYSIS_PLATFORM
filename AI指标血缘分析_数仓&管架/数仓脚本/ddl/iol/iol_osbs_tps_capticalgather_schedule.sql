/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_capticalgather_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_capticalgather_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_capticalgather_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_capticalgather_schedule(
    tgs_capticalgather_no varchar2(32) -- 资金归集编号
    ,tgs_ecifno varchar2(32) -- 统一客户号
    ,tgs_userno varchar2(32) -- 用户顺序号
    ,tgs_submitdate varchar2(14) -- 计划制定日期
    ,tgs_type varchar2(1) -- 定时种类
    ,tgs_tranfreq varchar2(1) -- 交易频率
    ,tgs_periodrule varchar2(256) -- 归集规则
    ,tts_nextexedate varchar2(14) -- 下一次执行日期
    ,tgs_state varchar2(1) -- 状态
    ,tgs_begindate varchar2(14) -- 起始日期
    ,tgs_enddate varchar2(14) -- 截止日期
    ,tgs_periodday varchar2(2) -- 执行日
    ,tgs_canceldate varchar2(14) -- 取消日期
    ,tgs_transtime varchar2(17) -- 计划制定时间
    ,tgs_authtype varchar2(1) -- 客户类型（用于限额）
    ,tgs_transauthtype varchar2(1) -- 安全工具类型
    ,tgs_successtimes number(22) -- 执行成功次数
    ,tgs_successamt number(15,2) -- 成功金额
    ,tgs_failtimes number(22) -- 执行失败次数
    ,tgs_failamt number(15,2) -- 失败金额
    ,tgs_plantimes number(22) -- 计划执行次数
    ,tgs_exetimes number(22) -- 已执行次数
    ,tgs_residuetimes number(22) -- 未执行次数
    ,tgs_channel varchar2(16) -- 渠道
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_tps_capticalgather_schedule to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_schedule to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_schedule to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_capticalgather_schedule is '个人资金归集计划表';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_capticalgather_no is '资金归集编号';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_ecifno is '统一客户号';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_submitdate is '计划制定日期';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_type is '定时种类';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_tranfreq is '交易频率';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_periodrule is '归集规则';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tts_nextexedate is '下一次执行日期';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_state is '状态';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_begindate is '起始日期';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_enddate is '截止日期';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_periodday is '执行日';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_canceldate is '取消日期';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_transtime is '计划制定时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_authtype is '客户类型（用于限额）';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_transauthtype is '安全工具类型';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_successtimes is '执行成功次数';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_successamt is '成功金额';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_failtimes is '执行失败次数';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_failamt is '失败金额';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_plantimes is '计划执行次数';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_exetimes is '已执行次数';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_residuetimes is '未执行次数';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.tgs_channel is '渠道';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_capticalgather_schedule.etl_timestamp is 'ETL处理时间戳';
