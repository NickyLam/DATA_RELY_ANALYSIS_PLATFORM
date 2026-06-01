/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol imps_ads_task_detail_di_out
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.imps_ads_task_detail_di_out
whenever sqlerror continue none;
drop table ${iol_schema}.imps_ads_task_detail_di_out purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.imps_ads_task_detail_di_out(
    base_id number -- 基准id
    ,main_account_id varchar2(4000) -- 主账号id
    ,app_id varchar2(4000) -- 项目id
    ,subject_id varchar2(4000) -- 主体id
    ,task_id varchar2(4000) -- 任务id
    ,schedule_id varchar2(4000) -- 调度id
    ,sub_task_id varchar2(4000) -- 子任务id/策略器id
    ,current_id_type varchar2(4000) -- 人群包的用户id类型
    ,current_id varchar2(4000) -- 人群包里的用户id
    ,current_version_index varchar2(4000) -- 实验组id
    ,send_id varchar2(4000) -- 通道用户id
    ,send_id_type varchar2(4000) -- 通道用户id类型
    ,coupon_uuid varchar2(4000) -- 发送内容里券码
    ,message varchar2(4000) -- 发送内容
    ,channel_type varchar2(4000) -- 通道类型
    ,channel_id varchar2(4000) -- 通道id
    ,click_flag number -- 点击标记，0为未点击，1为已点击
    ,click_time timestamp -- 点击时间
    ,arrive_flag number -- 到达标记，0为未到达、1为已到达
    ,arrive_time timestamp -- 到达时间
    ,trigger_success_flag number -- 发送标记，0为未发送、1为已发送
    ,trigger_time timestamp -- 发送时间
    ,is_probe_data number -- 是否为探针数据
    ,app_name varchar2(4000) -- 项目名称
    ,"mode" number -- 任务触发类型
    ,task_name varchar2(4000) -- 任务名称
    ,campaign_id number -- 活动id
    ,campaign_name varchar2(4000) -- 活动名称
    ,group_id number -- 任务分组id
    ,group_name varchar2(4000) -- 任务分组名称
    ,campaign_group_id number -- 活动分组id
    ,campaign_group_name varchar2(4000) -- 活动分组名称
    ,cohort_id number -- 人群id
    ,crowd_name varchar2(4000) -- 人群名称
    ,creator varchar2(4000) -- 创建人
    ,channel_name varchar2(4000) -- 通道名称
    ,sub_task_name varchar2(4000) -- 策略器名称
    ,coupon_id varchar2(4000) -- 权益id
    ,coupon_name varchar2(4000) -- 权益名称
    ,start_time timestamp -- 任务开始时间
    ,end_time timestamp -- 任务结束时间
    ,window_popup_flag number -- 弹窗标记，0为未弹窗，1为已弹窗
    ,window_popup_time timestamp -- 弹窗时间
    ,market_plan_id number -- 营销计划id
    ,finish_a_events varchar2(4000) -- 完成a事件
    ,unfinish_b_events varchar2(4000) -- 未完成b事件
    ,short_links_info varchar2(4000) -- 短链信息
    ,magic_links_info varchar2(4000) -- 魔方落地页信息
    ,p_date date -- 日期
    ,task_type varchar2(768) -- 任务类型，task为触达任务、canvas为流程画布
    ,seq_id number -- 序号
    ,tunnel_type varchar2(4000) -- 
    ,ecif_id varchar2(4000) -- 客户号
    ,content varchar2(4000) -- 内容
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
grant select on ${iol_schema}.imps_ads_task_detail_di_out to ${iml_schema};
grant select on ${iol_schema}.imps_ads_task_detail_di_out to ${icl_schema};
grant select on ${iol_schema}.imps_ads_task_detail_di_out to ${idl_schema};
grant select on ${iol_schema}.imps_ads_task_detail_di_out to ${iel_schema};

-- comment
comment on table ${iol_schema}.imps_ads_task_detail_di_out is '营销平台策略触达明细表';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.base_id is '基准id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.main_account_id is '主账号id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.app_id is '项目id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.subject_id is '主体id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.task_id is '任务id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.schedule_id is '调度id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.sub_task_id is '子任务id/策略器id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.current_id_type is '人群包的用户id类型';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.current_id is '人群包里的用户id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.current_version_index is '实验组id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.send_id is '通道用户id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.send_id_type is '通道用户id类型';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.coupon_uuid is '发送内容里券码';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.message is '发送内容';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.channel_type is '通道类型';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.channel_id is '通道id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.click_flag is '点击标记，0为未点击，1为已点击';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.click_time is '点击时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.arrive_flag is '到达标记，0为未到达、1为已到达';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.arrive_time is '到达时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.trigger_success_flag is '发送标记，0为未发送、1为已发送';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.trigger_time is '发送时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.is_probe_data is '是否为探针数据';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.app_name is '项目名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out."mode" is '任务触发类型';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.task_name is '任务名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.campaign_id is '活动id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.campaign_name is '活动名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.group_id is '任务分组id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.group_name is '任务分组名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.campaign_group_id is '活动分组id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.campaign_group_name is '活动分组名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.cohort_id is '人群id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.crowd_name is '人群名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.creator is '创建人';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.channel_name is '通道名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.sub_task_name is '策略器名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.coupon_id is '权益id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.coupon_name is '权益名称';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.start_time is '任务开始时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.end_time is '任务结束时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.window_popup_flag is '弹窗标记，0为未弹窗，1为已弹窗';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.window_popup_time is '弹窗时间';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.market_plan_id is '营销计划id';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.finish_a_events is '完成a事件';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.unfinish_b_events is '未完成b事件';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.short_links_info is '短链信息';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.magic_links_info is '魔方落地页信息';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.p_date is '日期';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.task_type is '任务类型，task为触达任务、canvas为流程画布';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.seq_id is '序号';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.tunnel_type is '';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.ecif_id is '客户号';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.etl_timestamp is 'ETL处理时间戳';
comment on column ${iol_schema}.imps_ads_task_detail_di_out.content is '内容';
