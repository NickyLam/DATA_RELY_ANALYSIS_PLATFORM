/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_apply_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_apply_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_apply_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_apply_base_info(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,businesssum_or_apply_amount number(24,6) -- 承贷金额或申请金额
    ,serialno varchar2(40) -- 申请流水号
    ,chanel varchar2(5) -- 渠道
    ,businesstype_or_biz_type varchar2(20) -- 业务品种或产品类别
    ,marriage_status_cd varchar2(5) -- 婚姻状态
    ,gender_cd varchar2(5) -- 性别
    ,edu_degree_cd varchar2(5) -- 教育程度
    ,birth_date varchar2(10) -- 出生日期
    ,indu_typ_cd varchar2(10) -- 行业类型
    ,obiligate1 varchar2(5) -- 预留1
    ,obiligate2 varchar2(5) -- 预留2
    ,obiligate3 varchar2(5) -- 预留3
    ,obiligate4 varchar2(5) -- 预留4
    ,obiligate5 varchar2(5) -- 预留5
    ,obiligate6 varchar2(10) -- 预留6
    ,obiligate7 varchar2(10) -- 预留7
    ,obiligate8 varchar2(10) -- 预留8
    ,obiligate9 varchar2(10) -- 预留9
    ,obiligate10 varchar2(10) -- 预留10
    ,obiligate11 varchar2(20) -- 预留11
    ,obiligate12 varchar2(20) -- 预留12
    ,obiligate13 varchar2(20) -- 预留13
    ,obiligate14 varchar2(20) -- 预留14
    ,obiligate15 varchar2(20) -- 预留15
    ,obiligate16 varchar2(50) -- 预留16
    ,obiligate17 varchar2(50) -- 预留17
    ,obiligate18 varchar2(50) -- 预留18
    ,obiligate19 varchar2(50) -- 预留19
    ,obiligate20 varchar2(50) -- 预留20
    ,rep_id varchar2(60) -- 报告编号
    ,non_loan_sum_cnt varchar2(18) -- 未结清贷款信息汇总笔数
    ,house_loan_cnt varchar2(18) -- 住房贷款笔数
    ,marriage_status_cd_std varchar2(5) -- 婚姻状态(规则标准)
    ,gender_cd_std varchar2(5) -- 性别(规则标准)
    ,edu_degree_cd_std varchar2(5) -- 教育程度(规则标准)
    ,indu_typ_cd_std varchar2(10) -- 行业类型(规则标准)
    ,childflag2 varchar2(40) -- 有无子女
    ,dummy_mobile_no varchar2(40) -- 有无申请人移动电话
    ,emp_status varchar2(40) -- 雇佣状态（自雇、受薪)
    ,emp_status_std varchar2(40) -- 雇佣状态（自雇、受薪)(规则标准)
    ,residence_type varchar2(40) -- 现住房状况（自有，租赁，合住等）
    ,residence_type_std varchar2(40) -- 现住房状况（自有，租赁，合住等）(规则标准)
    ,house_flag1 varchar2(40) -- 本地有无房产
    ,house_value varchar2(38) -- 房产价值
    ,industryage varchar2(38) -- 企业成立年限
    ,months_curr_address_raw varchar2(38) -- 现住址居住时间
    ,months_curr_employer varchar2(38) -- 现单位工作年限
    ,profsn_title_cd varchar2(40) -- 职称代码（初级、中级、高级）
    ,profsn_title_cd_std varchar2(40) -- 职称代码（初级、中级、高级）(规则标准)
    ,verified_income_all varchar2(38) -- 认定月收入
    ,worknature varchar2(40) -- 单位性质
    ,worknature_std varchar2(40) -- 单位性质(规则标准)
    ,businesssum varchar2(38) -- 申请金额
    ,businessrate varchar2(38) -- 贷款利率
    ,termmonth varchar2(38) -- 贷款期限
    ,customerid varchar2(40) -- 客户身份证号
    ,apply_date varchar2(10) -- 申请日期
    ,loan_cur varchar2(40) -- 申请币种
    ,repay_mode varchar2(40) -- 还款方式
    ,loan_purpose varchar2(40) -- 贷款用途（住房改造, 购车,等等）
    ,prod_type_raw varchar2(40) -- 贷款种类
    ,cus_manager varchar2(40) -- 客户经理
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
    ,ent_name varchar2(200) -- 经营体名称
    ,ent_id varchar2(40) -- 经营体注册号
    ,ent_est_date varchar2(10) -- 设立日期
    ,ent_legal_name varchar2(40) -- 法定代表人名称
    ,ent_tel varchar2(40) -- 经营体电话
    ,end_reg_ad varchar2(200) -- 注册地址
    ,ent_office_ad varchar2(200) -- 经营地址
    ,ent_reg_capital varchar2(38) -- 注册资本
    ,ent_real_capital varchar2(38) -- 实收资本
    ,ent_emp_num varchar2(38) -- 员工人数
    ,ent_cus_relation varchar2(40) -- 申请人与经营体之关系
    ,ent_cus_share varchar2(38) -- 申请人对经营体持股比例
    ,repay_mode_std varchar2(38) -- 
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
grant select on ${iol_schema}.rcds_ir_apply_base_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_apply_base_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_apply_base_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_apply_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_apply_base_info is '申请基础信息表';
comment on column ${iol_schema}.rcds_ir_apply_base_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_apply_base_info.businesssum_or_apply_amount is '承贷金额或申请金额';
comment on column ${iol_schema}.rcds_ir_apply_base_info.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.chanel is '渠道';
comment on column ${iol_schema}.rcds_ir_apply_base_info.businesstype_or_biz_type is '业务品种或产品类别';
comment on column ${iol_schema}.rcds_ir_apply_base_info.marriage_status_cd is '婚姻状态';
comment on column ${iol_schema}.rcds_ir_apply_base_info.gender_cd is '性别';
comment on column ${iol_schema}.rcds_ir_apply_base_info.edu_degree_cd is '教育程度';
comment on column ${iol_schema}.rcds_ir_apply_base_info.birth_date is '出生日期';
comment on column ${iol_schema}.rcds_ir_apply_base_info.indu_typ_cd is '行业类型';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate1 is '预留1';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate2 is '预留2';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate3 is '预留3';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate4 is '预留4';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate5 is '预留5';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate6 is '预留6';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate7 is '预留7';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate8 is '预留8';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate9 is '预留9';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate10 is '预留10';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate11 is '预留11';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate12 is '预留12';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate13 is '预留13';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate14 is '预留14';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate15 is '预留15';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate16 is '预留16';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate17 is '预留17';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate18 is '预留18';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate19 is '预留19';
comment on column ${iol_schema}.rcds_ir_apply_base_info.obiligate20 is '预留20';
comment on column ${iol_schema}.rcds_ir_apply_base_info.rep_id is '报告编号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.non_loan_sum_cnt is '未结清贷款信息汇总笔数';
comment on column ${iol_schema}.rcds_ir_apply_base_info.house_loan_cnt is '住房贷款笔数';
comment on column ${iol_schema}.rcds_ir_apply_base_info.marriage_status_cd_std is '婚姻状态(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.gender_cd_std is '性别(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.edu_degree_cd_std is '教育程度(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.indu_typ_cd_std is '行业类型(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.childflag2 is '有无子女';
comment on column ${iol_schema}.rcds_ir_apply_base_info.dummy_mobile_no is '有无申请人移动电话';
comment on column ${iol_schema}.rcds_ir_apply_base_info.emp_status is '雇佣状态（自雇、受薪)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.emp_status_std is '雇佣状态（自雇、受薪)(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.residence_type is '现住房状况（自有，租赁，合住等）';
comment on column ${iol_schema}.rcds_ir_apply_base_info.residence_type_std is '现住房状况（自有，租赁，合住等）(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.house_flag1 is '本地有无房产';
comment on column ${iol_schema}.rcds_ir_apply_base_info.house_value is '房产价值';
comment on column ${iol_schema}.rcds_ir_apply_base_info.industryage is '企业成立年限';
comment on column ${iol_schema}.rcds_ir_apply_base_info.months_curr_address_raw is '现住址居住时间';
comment on column ${iol_schema}.rcds_ir_apply_base_info.months_curr_employer is '现单位工作年限';
comment on column ${iol_schema}.rcds_ir_apply_base_info.profsn_title_cd is '职称代码（初级、中级、高级）';
comment on column ${iol_schema}.rcds_ir_apply_base_info.profsn_title_cd_std is '职称代码（初级、中级、高级）(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.verified_income_all is '认定月收入';
comment on column ${iol_schema}.rcds_ir_apply_base_info.worknature is '单位性质';
comment on column ${iol_schema}.rcds_ir_apply_base_info.worknature_std is '单位性质(规则标准)';
comment on column ${iol_schema}.rcds_ir_apply_base_info.businesssum is '申请金额';
comment on column ${iol_schema}.rcds_ir_apply_base_info.businessrate is '贷款利率';
comment on column ${iol_schema}.rcds_ir_apply_base_info.termmonth is '贷款期限';
comment on column ${iol_schema}.rcds_ir_apply_base_info.customerid is '客户身份证号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.apply_date is '申请日期';
comment on column ${iol_schema}.rcds_ir_apply_base_info.loan_cur is '申请币种';
comment on column ${iol_schema}.rcds_ir_apply_base_info.repay_mode is '还款方式';
comment on column ${iol_schema}.rcds_ir_apply_base_info.loan_purpose is '贷款用途（住房改造, 购车,等等）';
comment on column ${iol_schema}.rcds_ir_apply_base_info.prod_type_raw is '贷款种类';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_manager is '客户经理';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_name is '客户姓名';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_mobile is '手机号码';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_home_tel is '家庭电话';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_corp_name is '工作单位';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_corp_tel is '工作单位电话';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_home_ad is '居住地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_reg_ad is '户籍地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_post_ad is '通讯地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_corp_ad is '工作单位地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.cus_email is '电子邮箱';
comment on column ${iol_schema}.rcds_ir_apply_base_info.emergencontact_name is '紧急联系人姓名';
comment on column ${iol_schema}.rcds_ir_apply_base_info.emergencontact_id is '紧急联系人身份证号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.emergencontact_mobile is '紧急联系人手机号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_name is '经营体名称';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_id is '经营体注册号';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_est_date is '设立日期';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_legal_name is '法定代表人名称';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_tel is '经营体电话';
comment on column ${iol_schema}.rcds_ir_apply_base_info.end_reg_ad is '注册地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_office_ad is '经营地址';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_reg_capital is '注册资本';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_real_capital is '实收资本';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_emp_num is '员工人数';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_cus_relation is '申请人与经营体之关系';
comment on column ${iol_schema}.rcds_ir_apply_base_info.ent_cus_share is '申请人对经营体持股比例';
comment on column ${iol_schema}.rcds_ir_apply_base_info.repay_mode_std is '';
comment on column ${iol_schema}.rcds_ir_apply_base_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_apply_base_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_apply_base_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_apply_base_info.etl_timestamp is 'ETL处理时间戳';
