/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_b_t_cm_contact
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_b_t_cm_contact
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_b_t_cm_contact purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_b_t_cm_contact(
    contact_id varchar2(4000) -- ID
    ,cust_id varchar2(4000) -- 客户ID
    ,phone varchar2(4000) -- 手机号码
    ,contact_sts varchar2(4000) -- 是否有效
    ,contact_channel varchar2(4000) -- 联络渠道
    ,contact_type varchar2(4000) -- 联络类型
    ,contact_cont varchar2(4000) -- 服务内容
    ,contact_dt varchar2(4000) -- 联系日期
    ,cust_back varchar2(4000) -- 客户反馈
    ,int_prod varchar2(4000) -- 意向产品
    ,contact_name varchar2(4000) -- 联系人
    ,update_dt varchar2(4000) -- 待跟进日期
    ,send_tate varchar2(4000) -- 发送时间
    ,relation varchar2(4000) -- 客户关系类型
    ,nomal_behave varchar2(4000) -- 客户异常行为
    ,nom_cust_name varchar2(4000) -- 异常行为客户
    ,is_noble_metal varchar2(4000) -- 是否异常
    ,contact_address varchar2(4000) -- 地点
    ,notice_date varchar2(4000) -- 提醒时间
    ,flag number(10,0) -- 修改标志
    ,des varchar2(4000) -- 摘要
    ,task_id varchar2(4000) -- 任务ID
    ,update_cont varchar2(4000) -- 跟进内容
    ,create_user_id varchar2(4000) -- 创建人
    ,create_org_id varchar2(4000) -- 创建人机构
    ,remark varchar2(4000) -- 备注
    ,create_time varchar2(4000) -- 创建时间
    ,buy_amt number(18,2) -- 购买金额
    ,statr_time varchar2(4000) -- 开始时间
    ,end_time varchar2(4000) -- 结束时间
    ,update_time varchar2(4000) -- 更新维护时间
    ,cust_type varchar2(4000) -- 客户类型
    ,updater varchar2(4000) -- 维护人中文姓名
    ,updater_id varchar2(4000) -- 维护人ID
    ,wct_id varchar2(4000) -- 微信号
    ,concat_type varchar2(4000) -- 联系方式
    ,act_no varchar2(4000) -- 活动编号
    ,band_no varchar2(4000) -- 波段编号
    ,sign_in varchar2(4000) -- 签到记录 0:未签到 1：已签到
    ,lot_start_time varchar2(4000) -- 签到有效开始时间
    ,lot_end_time varchar2(4000) -- 签到有效结束时间
    ,lot_date varchar2(4000) -- 签到有效时间
    ,mkt_pro_type varchar2(4000) -- 营销产品类型
    ,yx_amt number(18,2) -- 意向金额
    ,is_gh varchar2(4000) -- 是否管户
    ,is_gg varchar2(4000) -- 是否共管
    ,leave_sts varchar2(4000) -- 审批状态
    ,yd_num number(10,0) -- 华兴云店联络次数
    ,load_date varchar2(4000) -- 数据日期
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
grant select on ${iol_schema}.bdws_b_t_cm_contact to ${iml_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact to ${icl_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact to ${idl_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_b_t_cm_contact is '客户联络表';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_id is 'ID';
comment on column ${iol_schema}.bdws_b_t_cm_contact.cust_id is '客户ID';
comment on column ${iol_schema}.bdws_b_t_cm_contact.phone is '手机号码';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_sts is '是否有效';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_channel is '联络渠道';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_type is '联络类型';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_cont is '服务内容';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_dt is '联系日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact.cust_back is '客户反馈';
comment on column ${iol_schema}.bdws_b_t_cm_contact.int_prod is '意向产品';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_name is '联系人';
comment on column ${iol_schema}.bdws_b_t_cm_contact.update_dt is '待跟进日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact.send_tate is '发送时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.relation is '客户关系类型';
comment on column ${iol_schema}.bdws_b_t_cm_contact.nomal_behave is '客户异常行为';
comment on column ${iol_schema}.bdws_b_t_cm_contact.nom_cust_name is '异常行为客户';
comment on column ${iol_schema}.bdws_b_t_cm_contact.is_noble_metal is '是否异常';
comment on column ${iol_schema}.bdws_b_t_cm_contact.contact_address is '地点';
comment on column ${iol_schema}.bdws_b_t_cm_contact.notice_date is '提醒时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.flag is '修改标志';
comment on column ${iol_schema}.bdws_b_t_cm_contact.des is '摘要';
comment on column ${iol_schema}.bdws_b_t_cm_contact.task_id is '任务ID';
comment on column ${iol_schema}.bdws_b_t_cm_contact.update_cont is '跟进内容';
comment on column ${iol_schema}.bdws_b_t_cm_contact.create_user_id is '创建人';
comment on column ${iol_schema}.bdws_b_t_cm_contact.create_org_id is '创建人机构';
comment on column ${iol_schema}.bdws_b_t_cm_contact.remark is '备注';
comment on column ${iol_schema}.bdws_b_t_cm_contact.create_time is '创建时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.buy_amt is '购买金额';
comment on column ${iol_schema}.bdws_b_t_cm_contact.statr_time is '开始时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.end_time is '结束时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.update_time is '更新维护时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.cust_type is '客户类型';
comment on column ${iol_schema}.bdws_b_t_cm_contact.updater is '维护人中文姓名';
comment on column ${iol_schema}.bdws_b_t_cm_contact.updater_id is '维护人ID';
comment on column ${iol_schema}.bdws_b_t_cm_contact.wct_id is '微信号';
comment on column ${iol_schema}.bdws_b_t_cm_contact.concat_type is '联系方式';
comment on column ${iol_schema}.bdws_b_t_cm_contact.act_no is '活动编号';
comment on column ${iol_schema}.bdws_b_t_cm_contact.band_no is '波段编号';
comment on column ${iol_schema}.bdws_b_t_cm_contact.sign_in is '签到记录 0:未签到 1：已签到';
comment on column ${iol_schema}.bdws_b_t_cm_contact.lot_start_time is '签到有效开始时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.lot_end_time is '签到有效结束时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.lot_date is '签到有效时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact.mkt_pro_type is '营销产品类型';
comment on column ${iol_schema}.bdws_b_t_cm_contact.yx_amt is '意向金额';
comment on column ${iol_schema}.bdws_b_t_cm_contact.is_gh is '是否管户';
comment on column ${iol_schema}.bdws_b_t_cm_contact.is_gg is '是否共管';
comment on column ${iol_schema}.bdws_b_t_cm_contact.leave_sts is '审批状态';
comment on column ${iol_schema}.bdws_b_t_cm_contact.yd_num is '华兴云店联络次数';
comment on column ${iol_schema}.bdws_b_t_cm_contact.load_date is '数据日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact.etl_timestamp is 'ETL处理时间戳';
