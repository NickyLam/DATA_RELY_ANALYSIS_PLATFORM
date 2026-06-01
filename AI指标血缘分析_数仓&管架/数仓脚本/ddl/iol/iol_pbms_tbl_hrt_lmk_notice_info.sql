/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_hrt_lmk_notice_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info(
    pk_hrt_lmk_vip_notice number(22,0) -- 主键
    ,operate_type varchar2(9) -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
    ,merch_code varchar2(60) -- 商户编码
    ,sys_id varchar2(120) -- 系统编号
    ,channel_id varchar2(30) -- 渠道编码
    ,shop_id varchar2(30) -- 门店编码
    ,refer_no varchar2(192) -- 华润通申请流水号
    ,uuid varchar2(150) -- 请求唯一标识
    ,member_name varchar2(192) -- 姓名
    ,gender varchar2(9) -- 性别: 0-女，1-男
    ,national varchar2(9) -- 国籍: 参考数据落标-CN
    ,certi_type varchar2(60) -- 证件类型
    ,certi_no varchar2(96) -- 证件号码
    ,birthday varchar2(30) -- 生日: yyyy-mm-dd
    ,city varchar2(96) -- 所在城市
    ,address varchar2(768) -- 地址
    ,vip_card_no varchar2(60) -- 会员卡号
    ,bank_card_no varchar2(192) -- 银行卡号
    ,lmk_card_no varchar2(60) -- 联名卡号
    ,organization varchar2(96) -- 银行卡发卡组织
    ,card_level varchar2(96) -- 卡等级
    ,create_time varchar2(90) -- 创建时间
    ,update_time varchar2(90) -- 修改时间
    ,created_by varchar2(60) -- 创建人
    ,updated_by varchar2(60) -- 修改人
    ,del_flag number(5) -- 删除标志
    ,register_time varchar2(60) -- 注册时间
    ,mobile varchar2(33) -- 手机
    ,task_date varchar2(60) -- 任务日期
    ,bank_card_no_new varchar2(192) -- 新银行卡号
    ,lmk_card_no_new varchar2(60) -- 新联名卡号
    ,notice_flag varchar2(9) -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
    ,acti_no varchar2(90) -- 活动代码
    ,cust_id varchar2(60) -- 客户号
    ,biz_time varchar2(90) -- 业务处理时间
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
grant select on ${iol_schema}.pbms_tbl_hrt_lmk_notice_info to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_lmk_notice_info to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_lmk_notice_info to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_hrt_lmk_notice_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info is '华润通联名卡会员通知信息表';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.pk_hrt_lmk_vip_notice is '主键';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.operate_type is '操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.merch_code is '商户编码';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.sys_id is '系统编号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.channel_id is '渠道编码';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.shop_id is '门店编码';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.refer_no is '华润通申请流水号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.uuid is '请求唯一标识';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.member_name is '姓名';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.gender is '性别: 0-女，1-男';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.national is '国籍: 参考数据落标-CN';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.certi_type is '证件类型';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.certi_no is '证件号码';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.birthday is '生日: yyyy-mm-dd';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.city is '所在城市';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.address is '地址';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.vip_card_no is '会员卡号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.bank_card_no is '银行卡号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.lmk_card_no is '联名卡号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.organization is '银行卡发卡组织';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.card_level is '卡等级';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.update_time is '修改时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.created_by is '创建人';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.updated_by is '修改人';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.del_flag is '删除标志';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.register_time is '注册时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.mobile is '手机';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.task_date is '任务日期';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.bank_card_no_new is '新银行卡号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.lmk_card_no_new is '新联名卡号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.notice_flag is '0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.acti_no is '活动代码';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.biz_time is '业务处理时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_hrt_lmk_notice_info.etl_timestamp is 'ETL处理时间戳';
