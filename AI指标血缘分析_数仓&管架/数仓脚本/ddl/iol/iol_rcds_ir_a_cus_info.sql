/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_a_cus_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_a_cus_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_a_cus_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_cus_info(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,customerid varchar2(40) -- 客户身份证号
    ,cus_name varchar2(40) -- 客户姓名
    ,cus_mobile varchar2(40) -- 手机号码
    ,cus_home_tel varchar2(40) -- 家庭电话
    ,cus_corp_name varchar2(200) -- 工作单位
    ,cus_corp_tel varchar2(40) -- 工作单位电话
    ,cus_home_ad varchar2(200) -- 居住地址
    ,cus_reg_ad varchar2(200) -- 户籍地址
    ,cus_post_ad varchar2(200) -- 通讯地址
    ,cus_corp_ad varchar2(200) -- 工作单位地址
    ,cus_email varchar2(40) -- 电子邮箱
    ,emergencontact_name varchar2(40) -- 紧急联系人姓名
    ,emergencontact_id varchar2(40) -- 紧急联系人身份证号
    ,emergencontact_mobile varchar2(40) -- 紧急联系人手机号
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
grant select on ${iol_schema}.rcds_ir_a_cus_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_a_cus_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_a_cus_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_a_cus_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_a_cus_info is '一次性数据-个人基本信息';
comment on column ${iol_schema}.rcds_ir_a_cus_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_a_cus_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_a_cus_info.customerid is '客户身份证号';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_name is '客户姓名';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_mobile is '手机号码';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_home_tel is '家庭电话';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_corp_name is '工作单位';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_corp_tel is '工作单位电话';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_home_ad is '居住地址';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_reg_ad is '户籍地址';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_post_ad is '通讯地址';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_corp_ad is '工作单位地址';
comment on column ${iol_schema}.rcds_ir_a_cus_info.cus_email is '电子邮箱';
comment on column ${iol_schema}.rcds_ir_a_cus_info.emergencontact_name is '紧急联系人姓名';
comment on column ${iol_schema}.rcds_ir_a_cus_info.emergencontact_id is '紧急联系人身份证号';
comment on column ${iol_schema}.rcds_ir_a_cus_info.emergencontact_mobile is '紧急联系人手机号';
comment on column ${iol_schema}.rcds_ir_a_cus_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_a_cus_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_a_cus_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_a_cus_info.etl_timestamp is 'ETL处理时间戳';
