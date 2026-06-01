/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_bt_qm_queue_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his(
    work_date varchar2(32) -- 日期格式yyyymmdd pk
    ,queue_num varchar2(36) -- 队列号 前缀起始位三位队列数001开始递增 pk
    ,branch varchar2(36) -- 机构号 pk
    ,branch_name varchar2(256) -- 机构名
    ,transfer_num varchar2(8) -- 转移次数,未转移号码为0,每转移一次递增1 从而生成多个相同排队号
    ,qm_num varchar2(48) -- 排队机编号
    ,qm_ip varchar2(256) -- 排队机ip pk
    ,queue_seq varchar2(48) -- 排队机取号流水
    ,softcall_teller varchar2(48) -- 服务实体柜员号
    ,softcall_teller_name varchar2(256) -- 服务实体柜员名
    ,softcall_seq varchar2(48) -- 软叫号流水
    ,bs_id varchar2(40) -- 业务id
    ,bs_name_ch varchar2(256) -- 业务名称(中文)
    ,queuetype_id varchar2(40) -- 队列id
    ,queuetype_name varchar2(256) -- 队列名称
    ,custtype_i varchar2(128) -- 内部客户类型
    ,node_id varchar2(40) -- 节点id
    ,win_num varchar2(12) -- 处理窗口号
    ,window_ip varchar2(256) -- 处理窗口ip
    ,queuenum_type varchar2(8) -- 排队号类型,1-普通,2-转移,3-预约,4-指定叫号
    ,custinfo_type varchar2(8) -- 证件类型
    ,custtype_name varchar2(256) -- 客户类型名称
    ,custinfo_num varchar2(120) -- 证件号码
    ,queue_status varchar2(8) -- 状态 0-取号 1-业务办理中 2-业务办理结束 3-弃号 4-转移
    ,en_queue_time varchar2(32) -- 进队时间 hhmmss
    ,de_queue_time varchar2(32) -- 出队时间 hhmmss
    ,start_serv_time varchar2(32) -- 服务开始时间 hhmmss
    ,finish_serv_time varchar2(32) -- 服务结束时间 hhmmss
    ,assess_status varchar2(8) -- 客户评价结果 0-非常满意 1-一般满意 2-不满意
    ,reserv_flag varchar2(8) -- 预约标志 0-无 1-有
    ,reserv_id varchar2(40) -- 预约id
    ,remaind_flag varchar2(8) -- 提醒标志 0-否 1-是
    ,remaind_phone varchar2(80) -- 手机号
    ,noti_waitnum varchar2(40) -- 前面的等待人数
    ,noti_setnum varchar2(40) -- 设定的通知等待人数
    ,isnotify varchar2(8) -- 是否已经通知 0 未通知，1 已通知
    ,isbefore varchar2(8) -- 是否预填单
    ,beforestatus varchar2(8) -- 填单状态:0-未完成；1-已完成
    ,vcalltime varchar2(32) -- 虚拟叫号时间
    ,vcalltime_2 varchar2(32) -- 按等待时间计算的虚拟时间
    ,vcalltime2 varchar2(32) -- 虚拟叫号时间2
    ,check_queue_value varchar2(20) -- 排队号验证码
    ,client_no varchar2(64) -- 客户号
    ,custlevel varchar2(128) -- 客户持卡最高级别
    ,assess_code varchar2(8) -- 评价代码
    ,etl_dt date -- 数据日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_bt_qm_queue_his to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_bt_qm_queue_his is '排队系统流水信息表-历史';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.work_date is '日期格式yyyymmdd pk';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queue_num is '队列号 前缀起始位三位队列数001开始递增 pk';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.branch is '机构号 pk';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.branch_name is '机构名';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.transfer_num is '转移次数,未转移号码为0,每转移一次递增1 从而生成多个相同排队号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.qm_num is '排队机编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.qm_ip is '排队机ip pk';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queue_seq is '排队机取号流水';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.softcall_teller is '服务实体柜员号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.softcall_teller_name is '服务实体柜员名';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.softcall_seq is '软叫号流水';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.bs_id is '业务id';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.bs_name_ch is '业务名称(中文)';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queuetype_id is '队列id';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queuetype_name is '队列名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.custtype_i is '内部客户类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.node_id is '节点id';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.win_num is '处理窗口号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.window_ip is '处理窗口ip';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queuenum_type is '排队号类型,1-普通,2-转移,3-预约,4-指定叫号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.custinfo_type is '证件类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.custtype_name is '客户类型名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.custinfo_num is '证件号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.queue_status is '状态 0-取号 1-业务办理中 2-业务办理结束 3-弃号 4-转移';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.en_queue_time is '进队时间 hhmmss';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.de_queue_time is '出队时间 hhmmss';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.start_serv_time is '服务开始时间 hhmmss';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.finish_serv_time is '服务结束时间 hhmmss';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.assess_status is '客户评价结果 0-非常满意 1-一般满意 2-不满意';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.reserv_flag is '预约标志 0-无 1-有';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.reserv_id is '预约id';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.remaind_flag is '提醒标志 0-否 1-是';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.remaind_phone is '手机号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.noti_waitnum is '前面的等待人数';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.noti_setnum is '设定的通知等待人数';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.isnotify is '是否已经通知 0 未通知，1 已通知';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.isbefore is '是否预填单';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.beforestatus is '填单状态:0-未完成；1-已完成';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.vcalltime is '虚拟叫号时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.vcalltime_2 is '按等待时间计算的虚拟时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.vcalltime2 is '虚拟叫号时间2';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.check_queue_value is '排队号验证码';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.client_no is '客户号';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.custlevel is '客户持卡最高级别';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.assess_code is '评价代码';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_qm_queue_his.etl_timestamp is 'ETL处理时间戳';