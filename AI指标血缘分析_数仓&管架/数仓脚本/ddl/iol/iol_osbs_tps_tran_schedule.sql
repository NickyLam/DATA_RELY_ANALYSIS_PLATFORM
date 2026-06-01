/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_tran_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_tran_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_tran_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_tran_schedule(
    tts_schedule_no varchar2(32) -- 计划编号
    ,tts_ecifno varchar2(32) -- 统一客户号
    ,tts_submittime varchar2(17) -- 计划制定时间
    ,tts_securitytype varchar2(1) -- 安全认证方式
    ,tts_type varchar2(1) -- 计划类型 0：定时 1：定频
    ,tts_tranfreq varchar2(1) -- 交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年
    ,tts_timerrule varchar2(256) -- 定时规则
    ,tts_nextexedate varchar2(14) -- 下一次执行日期
    ,tts_state varchar2(1) -- 预约计划状态 0正常使用 1已完成 2已撤销 3正在执行
    ,tts_begindate varchar2(14) -- 定时或定频起始日期
    ,tts_enddate varchar2(14) -- 截止日期
    ,tts_canceldate varchar2(14) -- 撤销日期
    ,tts_plantimes number(22) -- 定制执行次数
    ,tts_exetimes number(22) -- 已执行次数
    ,tts_successtimes number(22) -- 成功次数
    ,tts_successamt number(15,2) -- 成功金额
    ,tts_failtimes number(22) -- 失败次数
    ,tts_failamt number(15,2) -- 失败金额
    ,tts_residuetimes number(22) -- 未执行次数
    ,tts_booktype varchar2(1) -- 预约属性 B普通预约 H家庭预约
    ,tts_channel varchar2(16) -- 渠道
    ,tts_limitname varchar2(32) -- 限额属性名
    ,tts_userno varchar2(32) -- 用户名
    ,tts_sysflag varchar2(2) -- 行内外转账标识
    ,tts_transtype varchar2(32) -- 交易类型
    ,tts_ecifname varchar2(64) -- 客户名
    ,tts_edittime varchar2(17) -- 修改时间
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
grant select on ${iol_schema}.osbs_tps_tran_schedule to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_tran_schedule to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_tran_schedule to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_tran_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_tran_schedule is '个人预约交易计划表';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_schedule_no is '计划编号';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_ecifno is '统一客户号';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_submittime is '计划制定时间';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_securitytype is '安全认证方式';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_type is '计划类型 0：定时 1：定频';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_tranfreq is '交易频率 O:一次D:每天W:每周M:每月P:每季度B=每半年Y=每年';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_timerrule is '定时规则';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_nextexedate is '下一次执行日期';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_state is '预约计划状态 0正常使用 1已完成 2已撤销 3正在执行';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_begindate is '定时或定频起始日期';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_enddate is '截止日期';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_canceldate is '撤销日期';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_plantimes is '定制执行次数';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_exetimes is '已执行次数';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_successtimes is '成功次数';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_successamt is '成功金额';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_failtimes is '失败次数';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_failamt is '失败金额';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_residuetimes is '未执行次数';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_booktype is '预约属性 B普通预约 H家庭预约';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_channel is '渠道';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_limitname is '限额属性名';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_userno is '用户名';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_sysflag is '行内外转账标识';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_transtype is '交易类型';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_ecifname is '客户名';
comment on column ${iol_schema}.osbs_tps_tran_schedule.tts_edittime is '修改时间';
comment on column ${iol_schema}.osbs_tps_tran_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_tran_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_tran_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_tran_schedule.etl_timestamp is 'ETL处理时间戳';
