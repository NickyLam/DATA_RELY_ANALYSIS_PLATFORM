/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_collectsrule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_collectsrule
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_collectsrule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_collectsrule(
    tcr_collectno varchar2(32) -- 计划编号
    ,tcr_transdate varchar2(14) -- 计划制定日期
    ,tcr_periodtype varchar2(1) -- 定时种类
    ,tcr_periodfreq varchar2(1) -- 归集周期
    ,tcr_periodrule varchar2(256) -- 归集规则
    ,tcr_periodstate varchar2(1) -- 状态
    ,tcr_begindate varchar2(14) -- 起始日期
    ,tcr_enddate varchar2(14) -- 截止日期
    ,tcr_periodday varchar2(2) -- 执行日
    ,tcr_canceldate varchar2(14) -- 取消日期
    ,tcr_ecifno varchar2(32) -- 客户号
    ,tcr_userno varchar2(32) -- 用户号
    ,tcr_authtype varchar2(1) -- 客户类型（用于限额）
    ,tcr_ransauthtype varchar2(1) -- 安全工具类型
    ,tcr_suctimes number(22) -- 执行成功次数
    ,tcr_sucamt number(15,2) -- 成功金额
    ,tcr_failtimes number(22) -- 执行失败次数
    ,tcr_failamt number(15,2) -- 失败金额
    ,tcr_ordertimes number(22) -- 定制执行次数
    ,tcr_exetimes number(22) -- 已执行次数
    ,tcr_remaintimes number(22) -- 未执行次数
    ,tcr_channel varchar2(16) -- 渠道
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
grant select on ${iol_schema}.osbs_tps_collectsrule to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_collectsrule to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_collectsrule to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_collectsrule to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_collectsrule is '资金自动归集定时计划表';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_collectno is '计划编号';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_transdate is '计划制定日期';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_periodtype is '定时种类';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_periodfreq is '归集周期';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_periodrule is '归集规则';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_periodstate is '状态';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_begindate is '起始日期';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_enddate is '截止日期';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_periodday is '执行日';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_canceldate is '取消日期';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_ecifno is '客户号';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_userno is '用户号';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_authtype is '客户类型（用于限额）';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_ransauthtype is '安全工具类型';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_suctimes is '执行成功次数';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_sucamt is '成功金额';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_failtimes is '执行失败次数';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_failamt is '失败金额';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_ordertimes is '定制执行次数';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_exetimes is '已执行次数';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_remaintimes is '未执行次数';
comment on column ${iol_schema}.osbs_tps_collectsrule.tcr_channel is '渠道';
comment on column ${iol_schema}.osbs_tps_collectsrule.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_collectsrule.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_collectsrule.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_collectsrule.etl_timestamp is 'ETL处理时间戳';
