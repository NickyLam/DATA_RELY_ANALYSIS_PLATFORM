/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_ecds_bank_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_ecds_bank_data
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_ecds_bank_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_ecds_bank_data(
    id varchar2(60) -- ID
    ,bank_no varchar2(18) -- 联行号
    ,actor_type varchar2(5) -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,bank_other_code varchar2(6) -- 行别代码
    ,super_actor varchar2(18) -- 上级参与者
    ,local_node_code varchar2(9) -- 所在节点代码
    ,root_super_actor varchar2(105) -- 本行上级参与者
    ,cate_people_code varchar2(18) -- 所属人行代码
    ,city_code varchar2(9) -- 地市代码
    ,actor_full_call varchar2(300) -- 参与者全称
    ,actor_for_short varchar2(150) -- 参与者简称
    ,address varchar2(375) -- 地址
    ,post_edit varchar2(45) -- 邮编
    ,phone varchar2(300) -- 电话/电挂
    ,email varchar2(75) -- 电子邮件地址
    ,status varchar2(2) -- 状态： 0 无效 1 有效
    ,inure_date varchar2(15) -- 生效日期
    ,log_out_date varchar2(15) -- 注销日期
    ,update_time varchar2(39) -- 更新时间
    ,lately_update_work varchar2(2) -- 最近更新操作
    ,log_update_expect varchar2(12) -- 记录更新期数
    ,remark varchar2(375) -- 备注
    ,dn_field varchar2(300) -- DN域
    ,sn_field varchar2(300) -- SN域
    ,cert_bind_status varchar2(3) -- 证书绑定状态： 00 未绑定 01 已绑定
    ,meet_income_code varchar2(18) -- 接入点代码
    ,continue_row_num varchar2(18) -- 承接行号
    ,continue_meet_income varchar2(18) -- 承接行接入点
    ,if_continue varchar2(3) -- 是否有承接行： 0 否 1 是
    ,history_continue_con varchar2(150) -- 历史承接关系记录
    ,sttlm_acc_status varchar2(2) -- 清算账户状态
    ,sttlm_acc_update varchar2(15) -- 清算账户状态变更日期
    ,sttlm_acc_uptime varchar2(21) -- 清算帐户状态变更时间
    ,update_dt varchar2(12) -- UPDATE_DT
    ,update_tm varchar2(23) -- UPDATE_TM
    ,head_bank_no varchar2(18) -- HEAD_BANK_NO
    ,top_branch_no varchar2(30) -- TOP_BRANCH_NO
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
grant select on ${iol_schema}.bdms_bms_ecds_bank_data to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_ecds_bank_data to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_ecds_bank_data to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_ecds_bank_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_ecds_bank_data is '行名行号数据表';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.id is 'ID';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.bank_no is '联行号';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.actor_type is '参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.bank_other_code is '行别代码';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.super_actor is '上级参与者';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.local_node_code is '所在节点代码';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.root_super_actor is '本行上级参与者';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.cate_people_code is '所属人行代码';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.city_code is '地市代码';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.actor_full_call is '参与者全称';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.actor_for_short is '参与者简称';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.address is '地址';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.post_edit is '邮编';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.phone is '电话/电挂';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.email is '电子邮件地址';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.status is '状态： 0 无效 1 有效';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.inure_date is '生效日期';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.log_out_date is '注销日期';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.update_time is '更新时间';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.lately_update_work is '最近更新操作';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.log_update_expect is '记录更新期数';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.remark is '备注';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.dn_field is 'DN域';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.sn_field is 'SN域';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.cert_bind_status is '证书绑定状态： 00 未绑定 01 已绑定';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.meet_income_code is '接入点代码';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.continue_row_num is '承接行号';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.continue_meet_income is '承接行接入点';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.if_continue is '是否有承接行： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.history_continue_con is '历史承接关系记录';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.sttlm_acc_status is '清算账户状态';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.sttlm_acc_update is '清算账户状态变更日期';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.sttlm_acc_uptime is '清算帐户状态变更时间';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.update_dt is 'UPDATE_DT';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.update_tm is 'UPDATE_TM';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.head_bank_no is 'HEAD_BANK_NO';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.top_branch_no is 'TOP_BRANCH_NO';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_ecds_bank_data.etl_timestamp is 'ETL处理时间戳';
