/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svbs_hx_trans_jnl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svbs_hx_trans_jnl
whenever sqlerror continue none;
drop table ${iol_schema}.svbs_hx_trans_jnl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_hx_trans_jnl(
    access_jnl_no varchar2(48) -- 流水号
    ,trans_code varchar2(48) -- 交码
    ,trans_channel varchar2(24) -- 交易渠道
    ,cust_no varchar2(24) -- 客户号
    ,cust_name varchar2(48) -- 客户名称
    ,id_type varchar2(12) -- 证件类型
    ,id_no varchar2(48) -- 证件号码
    ,card_type varchar2(2) -- 卡类型
    ,card_no varchar2(48) -- 卡号
    ,client_id varchar2(24) -- 坐席编号
    ,branch_id varchar2(24) -- 机构编号
    ,auth_flag varchar2(2) -- 是否授权
    ,auth_result varchar2(2) -- 授权结果
    ,author_id varchar2(24) -- 授权用户编号
    ,cur_step varchar2(3) -- 当前步骤
    ,trans_time timestamp -- 交易时间
    ,update_time timestamp -- 更新时间
    ,trans_status varchar2(3) -- 交易状态
    ,trans_msg varchar2(96) -- 交易结果
    ,create_user varchar2(48) -- 创建用户
    ,update_user varchar2(48) -- 更新用户
    ,session_id varchar2(48) -- 会话Id
    ,session_id2 varchar2(48) -- 会话Id2
    ,session_id3 varchar2(48) -- 会话Id3
    ,session_id4 varchar2(48) -- 会话Id4
    ,session_id5 varchar2(48) -- 会话Id5
    ,session_id6 varchar2(48) -- 会话Id6
    ,session_id7 varchar2(48) -- 会话Id7
    ,session_id8 varchar2(48) -- 会话Id8
    ,session_id9 varchar2(48) -- 会话Id9
    ,trans_address varchar2(384) -- 交易地址
    ,task_state varchar2(2) -- 是否质检  否-0;是-1
    ,longitude varchar2(96) -- 经度
    ,latitude varchar2(96) -- 维度
    ,trans_city varchar2(384) -- 交易城市
    ,trans_city_code varchar2(48) -- 城市编码
    ,connect_type varchar2(2) -- 流水接通类型，0-未接通，1-已接通
    ,refuse_info varchar2(3000) -- 未接通的拒绝类型，如黑名单、未满18周岁等
    ,refuse_detail varchar2(4000) -- 拒绝内容明细
    ,trans_node_status varchar2(8) -- 交易节点状态
    ,is_risk_record varchar2(8) -- 是否是风险记录
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
grant select on ${iol_schema}.svbs_hx_trans_jnl to ${iml_schema};
grant select on ${iol_schema}.svbs_hx_trans_jnl to ${icl_schema};
grant select on ${iol_schema}.svbs_hx_trans_jnl to ${idl_schema};
grant select on ${iol_schema}.svbs_hx_trans_jnl to ${iel_schema};

-- comment
comment on table ${iol_schema}.svbs_hx_trans_jnl is '交易流水表';
comment on column ${iol_schema}.svbs_hx_trans_jnl.access_jnl_no is '流水号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_code is '交码';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_channel is '交易渠道';
comment on column ${iol_schema}.svbs_hx_trans_jnl.cust_no is '客户号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.cust_name is '客户名称';
comment on column ${iol_schema}.svbs_hx_trans_jnl.id_type is '证件类型';
comment on column ${iol_schema}.svbs_hx_trans_jnl.id_no is '证件号码';
comment on column ${iol_schema}.svbs_hx_trans_jnl.card_type is '卡类型';
comment on column ${iol_schema}.svbs_hx_trans_jnl.card_no is '卡号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.client_id is '坐席编号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.branch_id is '机构编号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.auth_flag is '是否授权';
comment on column ${iol_schema}.svbs_hx_trans_jnl.auth_result is '授权结果';
comment on column ${iol_schema}.svbs_hx_trans_jnl.author_id is '授权用户编号';
comment on column ${iol_schema}.svbs_hx_trans_jnl.cur_step is '当前步骤';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_time is '交易时间';
comment on column ${iol_schema}.svbs_hx_trans_jnl.update_time is '更新时间';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_status is '交易状态';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_msg is '交易结果';
comment on column ${iol_schema}.svbs_hx_trans_jnl.create_user is '创建用户';
comment on column ${iol_schema}.svbs_hx_trans_jnl.update_user is '更新用户';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id is '会话Id';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id2 is '会话Id2';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id3 is '会话Id3';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id4 is '会话Id4';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id5 is '会话Id5';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id6 is '会话Id6';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id7 is '会话Id7';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id8 is '会话Id8';
comment on column ${iol_schema}.svbs_hx_trans_jnl.session_id9 is '会话Id9';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_address is '交易地址';
comment on column ${iol_schema}.svbs_hx_trans_jnl.task_state is '是否质检  否-0;是-1';
comment on column ${iol_schema}.svbs_hx_trans_jnl.longitude is '经度';
comment on column ${iol_schema}.svbs_hx_trans_jnl.latitude is '维度';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_city is '交易城市';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_city_code is '城市编码';
comment on column ${iol_schema}.svbs_hx_trans_jnl.connect_type is '流水接通类型，0-未接通，1-已接通';
comment on column ${iol_schema}.svbs_hx_trans_jnl.refuse_info is '未接通的拒绝类型，如黑名单、未满18周岁等';
comment on column ${iol_schema}.svbs_hx_trans_jnl.refuse_detail is '拒绝内容明细';
comment on column ${iol_schema}.svbs_hx_trans_jnl.trans_node_status is '交易节点状态';
comment on column ${iol_schema}.svbs_hx_trans_jnl.is_risk_record is '是否是风险记录';
comment on column ${iol_schema}.svbs_hx_trans_jnl.start_dt is '开始时间';
comment on column ${iol_schema}.svbs_hx_trans_jnl.end_dt is '结束时间';
comment on column ${iol_schema}.svbs_hx_trans_jnl.id_mark is '增删标志';
comment on column ${iol_schema}.svbs_hx_trans_jnl.etl_timestamp is 'ETL处理时间戳';
