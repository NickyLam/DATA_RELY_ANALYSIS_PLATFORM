/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_rktj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_rktj
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_rktj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_rktj(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,age_raw number(10,0) -- 年龄
    ,business_code varchar2(40) -- 行业类型（金融、建筑、通讯等）
    ,childflag2 varchar2(40) -- 有无子女
    ,dummy_employer varchar2(40) -- 有无工作单位
    ,dummy_home_address varchar2(40) -- 有无家庭地址
    ,dummy_work_address varchar2(40) -- 有无单位地址
    ,dummy_mobile_no varchar2(40) -- 有无申请人移动电话
    ,dummy_work_phone_no varchar2(40) -- 有无单位电话
    ,education varchar2(40) -- 教育程度
    ,emp_status varchar2(40) -- 雇佣状态（自雇、受薪)
    ,gender varchar2(40) -- 性别
    ,marriage_status varchar2(40) -- 婚姻状态
    ,residence_type varchar2(40) -- 现住房状况（自有，租赁，合住等）
    ,house_value number(24,6) -- 房产价值
    ,house_flag1 varchar2(40) -- 本地有无房产
    ,industryage number(17,2) -- 企业成立年限
    ,months_curr_address_raw number(17,2) -- 现住址居住时间
    ,months_curr_employer number(17,2) -- 现单位工作年限
    ,gender_marital varchar2(40) -- 性别与婚姻状态
    ,gender_residence varchar2(40) -- 性别与现住房状况
    ,residence_marital varchar2(40) -- 现住房状况与婚姻
    ,profsn_title_cd varchar2(40) -- 职称代码（初级、中级、高级）
    ,verified_income_all number(24,6) -- 认定月收入
    ,worknature varchar2(40) -- 单位性质
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
grant select on ${iol_schema}.rcds_ir_tzbl_a_rktj to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_rktj to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_rktj to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_rktj to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_rktj is '人口统计信息';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.age_raw is '年龄';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.business_code is '行业类型（金融、建筑、通讯等）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.childflag2 is '有无子女';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.dummy_employer is '有无工作单位';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.dummy_home_address is '有无家庭地址';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.dummy_work_address is '有无单位地址';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.dummy_mobile_no is '有无申请人移动电话';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.dummy_work_phone_no is '有无单位电话';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.education is '教育程度';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.emp_status is '雇佣状态（自雇、受薪)';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.gender is '性别';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.marriage_status is '婚姻状态';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.residence_type is '现住房状况（自有，租赁，合住等）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.house_value is '房产价值';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.house_flag1 is '本地有无房产';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.industryage is '企业成立年限';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.months_curr_address_raw is '现住址居住时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.months_curr_employer is '现单位工作年限';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.gender_marital is '性别与婚姻状态';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.gender_residence is '性别与现住房状况';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.residence_marital is '现住房状况与婚姻';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.profsn_title_cd is '职称代码（初级、中级、高级）';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.verified_income_all is '认定月收入';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.worknature is '单位性质';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_rktj.etl_timestamp is 'ETL处理时间戳';
