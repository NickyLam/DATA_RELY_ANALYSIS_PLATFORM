/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_s_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_s_task
whenever sqlerror continue none;
drop table ${iol_schema}.heps_s_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_s_task(
    task_id number -- 任务id
    ,customer_id number -- 客户id
    ,flow_id varchar2(50) -- 业务流水号
    ,actor_no varchar2(20) -- 负责人编号
    ,title varchar2(150) -- 任务标题
    ,official_valuation number -- 房屋估值
    ,plot_name varchar2(200) -- 楼盘名称
    ,house_location varchar2(1000) -- 定位
    ,customer_name varchar2(100) -- 客户姓名
    ,customer_mobile varchar2(20) -- 客户电话
    ,application_time date -- 申请时间
    ,task_status varchar2(20) -- 任务状态：00初审中，01待分配，02待下户核验/待补充资料，03待面谈面签，04终审中，05审核通过，06审核拒绝，07退回，08初审不通过，09状态未名 10终止
    ,loan_type varchar2(12) -- 贷款类型 0华兴快贷 1赎楼贷
    ,cus_card_no varchar2(32) -- 客户证件号
    ,house_area varchar2(32) -- 房屋面积
    ,house_level varchar2(3) -- 楼层
    ,high_loan_limit number(16,2) -- 最高可贷额度
    ,task_source varchar2(1) -- 1客户手机进件 2客户经理发起
    ,orgid varchar2(60) -- 机构号
    ,remark varchar2(256) -- 备注
    ,purpors varchar2(4) -- 贷款用途 01经营 02消费
    ,actor_name varchar2(50) -- 客户经理名称
    ,trial_time date -- 初审时间
    ,id_type varchar2(10) -- 证件类型
    ,pro_name varchar2(60) -- 产品名称
    ,devision_id varchar2(60) -- 行政区域编码
    ,plot_number varchar2(60) -- 楼盘编号
    ,approval_limit varchar2(60) -- 授信额度
    ,city_area_code varchar2(60) -- 城市编码
    ,city_name varchar2(120) -- 城市名称
    ,area_name varchar2(120) -- 区域名称
    ,is_tag varchar2(2) -- 
    ,ser_no varchar2(40) -- 赎楼贷业务流水号
    ,zj_actor_no varchar2(20) -- 质检员编号
    ,first_flow_id varchar2(90) -- 初审流水号
    ,pro_id varchar2(90) -- 产品编号
    ,actor_orgid varchar2(90) -- 客户经理账务机构号
    ,customer_no varchar2(90) -- 客户号
    ,source_company varchar2(50) -- 地推渠道来源
    ,xh_actor_no varchar2(20) -- 下户核验员编号
    ,xh_actor_name varchar2(90) -- 下户核验员姓名
    ,developers varchar2(60) -- 经纬度
    ,flowable_tag varchar2(2) -- 
    ,flowable_instance_id varchar2(50) -- 
    ,is_offline_sign varchar2(1) -- 是否提提放保线下签字；1-是2-否
    ,update_time date -- 最近更新时间
    ,entr_pay_id varchar2(60) -- 受托支付编号
    ,pay_seq varchar2(60) -- 支付序列
    ,pro_flow_no varchar2(60) -- 产品流程编号
    ,amount_type varchar2(2) -- 申请金额类型
    ,house_type varchar2(20) -- 房产类型
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
grant select on ${iol_schema}.heps_s_task to ${iml_schema};
grant select on ${iol_schema}.heps_s_task to ${icl_schema};
grant select on ${iol_schema}.heps_s_task to ${idl_schema};
grant select on ${iol_schema}.heps_s_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_s_task is '任务订单表';
comment on column ${iol_schema}.heps_s_task.task_id is '任务id';
comment on column ${iol_schema}.heps_s_task.customer_id is '客户id';
comment on column ${iol_schema}.heps_s_task.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_s_task.actor_no is '负责人编号';
comment on column ${iol_schema}.heps_s_task.title is '任务标题';
comment on column ${iol_schema}.heps_s_task.official_valuation is '房屋估值';
comment on column ${iol_schema}.heps_s_task.plot_name is '楼盘名称';
comment on column ${iol_schema}.heps_s_task.house_location is '定位';
comment on column ${iol_schema}.heps_s_task.customer_name is '客户姓名';
comment on column ${iol_schema}.heps_s_task.customer_mobile is '客户电话';
comment on column ${iol_schema}.heps_s_task.application_time is '申请时间';
comment on column ${iol_schema}.heps_s_task.task_status is '任务状态：00初审中，01待分配，02待下户核验/待补充资料，03待面谈面签，04终审中，05审核通过，06审核拒绝，07退回，08初审不通过，09状态未名 10终止';
comment on column ${iol_schema}.heps_s_task.loan_type is '贷款类型 0华兴快贷 1赎楼贷';
comment on column ${iol_schema}.heps_s_task.cus_card_no is '客户证件号';
comment on column ${iol_schema}.heps_s_task.house_area is '房屋面积';
comment on column ${iol_schema}.heps_s_task.house_level is '楼层';
comment on column ${iol_schema}.heps_s_task.high_loan_limit is '最高可贷额度';
comment on column ${iol_schema}.heps_s_task.task_source is '1客户手机进件 2客户经理发起';
comment on column ${iol_schema}.heps_s_task.orgid is '机构号';
comment on column ${iol_schema}.heps_s_task.remark is '备注';
comment on column ${iol_schema}.heps_s_task.purpors is '贷款用途 01经营 02消费';
comment on column ${iol_schema}.heps_s_task.actor_name is '客户经理名称';
comment on column ${iol_schema}.heps_s_task.trial_time is '初审时间';
comment on column ${iol_schema}.heps_s_task.id_type is '证件类型';
comment on column ${iol_schema}.heps_s_task.pro_name is '产品名称';
comment on column ${iol_schema}.heps_s_task.devision_id is '行政区域编码';
comment on column ${iol_schema}.heps_s_task.plot_number is '楼盘编号';
comment on column ${iol_schema}.heps_s_task.approval_limit is '授信额度';
comment on column ${iol_schema}.heps_s_task.city_area_code is '城市编码';
comment on column ${iol_schema}.heps_s_task.city_name is '城市名称';
comment on column ${iol_schema}.heps_s_task.area_name is '区域名称';
comment on column ${iol_schema}.heps_s_task.is_tag is '';
comment on column ${iol_schema}.heps_s_task.ser_no is '赎楼贷业务流水号';
comment on column ${iol_schema}.heps_s_task.zj_actor_no is '质检员编号';
comment on column ${iol_schema}.heps_s_task.first_flow_id is '初审流水号';
comment on column ${iol_schema}.heps_s_task.pro_id is '产品编号';
comment on column ${iol_schema}.heps_s_task.actor_orgid is '客户经理账务机构号';
comment on column ${iol_schema}.heps_s_task.customer_no is '客户号';
comment on column ${iol_schema}.heps_s_task.source_company is '地推渠道来源';
comment on column ${iol_schema}.heps_s_task.xh_actor_no is '下户核验员编号';
comment on column ${iol_schema}.heps_s_task.xh_actor_name is '下户核验员姓名';
comment on column ${iol_schema}.heps_s_task.developers is '经纬度';
comment on column ${iol_schema}.heps_s_task.flowable_tag is '';
comment on column ${iol_schema}.heps_s_task.flowable_instance_id is '';
comment on column ${iol_schema}.heps_s_task.is_offline_sign is '是否提提放保线下签字；1-是2-否';
comment on column ${iol_schema}.heps_s_task.update_time is '最近更新时间';
comment on column ${iol_schema}.heps_s_task.entr_pay_id is '受托支付编号';
comment on column ${iol_schema}.heps_s_task.pay_seq is '支付序列';
comment on column ${iol_schema}.heps_s_task.pro_flow_no is '产品流程编号';
comment on column ${iol_schema}.heps_s_task.amount_type is '申请金额类型';
comment on column ${iol_schema}.heps_s_task.house_type is '房产类型';
comment on column ${iol_schema}.heps_s_task.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_s_task.etl_timestamp is 'ETL处理时间戳';
