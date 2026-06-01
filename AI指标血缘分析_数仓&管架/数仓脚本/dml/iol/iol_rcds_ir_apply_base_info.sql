/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_apply_base_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rcds_ir_apply_base_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_apply_base_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_apply_base_info_op purge;
drop table ${iol_schema}.rcds_ir_apply_base_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_apply_base_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_apply_base_info where 0=1;

create table ${iol_schema}.rcds_ir_apply_base_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_apply_base_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_apply_base_info_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,businesssum_or_apply_amount -- 承贷金额或申请金额
            ,serialno -- 申请流水号
            ,chanel -- 渠道
            ,businesstype_or_biz_type -- 业务品种或产品类别
            ,marriage_status_cd -- 婚姻状态
            ,gender_cd -- 性别
            ,edu_degree_cd -- 教育程度
            ,birth_date -- 出生日期
            ,indu_typ_cd -- 行业类型
            ,obiligate1 -- 预留1
            ,obiligate2 -- 预留2
            ,obiligate3 -- 预留3
            ,obiligate4 -- 预留4
            ,obiligate5 -- 预留5
            ,obiligate6 -- 预留6
            ,obiligate7 -- 预留7
            ,obiligate8 -- 预留8
            ,obiligate9 -- 预留9
            ,obiligate10 -- 预留10
            ,obiligate11 -- 预留11
            ,obiligate12 -- 预留12
            ,obiligate13 -- 预留13
            ,obiligate14 -- 预留14
            ,obiligate15 -- 预留15
            ,obiligate16 -- 预留16
            ,obiligate17 -- 预留17
            ,obiligate18 -- 预留18
            ,obiligate19 -- 预留19
            ,obiligate20 -- 预留20
            ,rep_id -- 报告编号
            ,non_loan_sum_cnt -- 未结清贷款信息汇总笔数
            ,house_loan_cnt -- 住房贷款笔数
            ,marriage_status_cd_std -- 婚姻状态(规则标准)
            ,gender_cd_std -- 性别(规则标准)
            ,edu_degree_cd_std -- 教育程度(规则标准)
            ,indu_typ_cd_std -- 行业类型(规则标准)
            ,childflag2 -- 有无子女
            ,dummy_mobile_no -- 有无申请人移动电话
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
            ,house_flag1 -- 本地有无房产
            ,house_value -- 房产价值
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,worknature_std -- 单位性质(规则标准)
            ,businesssum -- 申请金额
            ,businessrate -- 贷款利率
            ,termmonth -- 贷款期限
            ,customerid -- 客户身份证号
            ,apply_date -- 申请日期
            ,loan_cur -- 申请币种
            ,repay_mode -- 还款方式
            ,loan_purpose -- 贷款用途（住房改造, 购车,等等）
            ,prod_type_raw -- 贷款种类
            ,cus_manager -- 客户经理
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_share -- 申请人对经营体持股比例
            ,repay_mode_std -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_apply_base_info_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,businesssum_or_apply_amount -- 承贷金额或申请金额
            ,serialno -- 申请流水号
            ,chanel -- 渠道
            ,businesstype_or_biz_type -- 业务品种或产品类别
            ,marriage_status_cd -- 婚姻状态
            ,gender_cd -- 性别
            ,edu_degree_cd -- 教育程度
            ,birth_date -- 出生日期
            ,indu_typ_cd -- 行业类型
            ,obiligate1 -- 预留1
            ,obiligate2 -- 预留2
            ,obiligate3 -- 预留3
            ,obiligate4 -- 预留4
            ,obiligate5 -- 预留5
            ,obiligate6 -- 预留6
            ,obiligate7 -- 预留7
            ,obiligate8 -- 预留8
            ,obiligate9 -- 预留9
            ,obiligate10 -- 预留10
            ,obiligate11 -- 预留11
            ,obiligate12 -- 预留12
            ,obiligate13 -- 预留13
            ,obiligate14 -- 预留14
            ,obiligate15 -- 预留15
            ,obiligate16 -- 预留16
            ,obiligate17 -- 预留17
            ,obiligate18 -- 预留18
            ,obiligate19 -- 预留19
            ,obiligate20 -- 预留20
            ,rep_id -- 报告编号
            ,non_loan_sum_cnt -- 未结清贷款信息汇总笔数
            ,house_loan_cnt -- 住房贷款笔数
            ,marriage_status_cd_std -- 婚姻状态(规则标准)
            ,gender_cd_std -- 性别(规则标准)
            ,edu_degree_cd_std -- 教育程度(规则标准)
            ,indu_typ_cd_std -- 行业类型(规则标准)
            ,childflag2 -- 有无子女
            ,dummy_mobile_no -- 有无申请人移动电话
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
            ,house_flag1 -- 本地有无房产
            ,house_value -- 房产价值
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,worknature_std -- 单位性质(规则标准)
            ,businesssum -- 申请金额
            ,businessrate -- 贷款利率
            ,termmonth -- 贷款期限
            ,customerid -- 客户身份证号
            ,apply_date -- 申请日期
            ,loan_cur -- 申请币种
            ,repay_mode -- 还款方式
            ,loan_purpose -- 贷款用途（住房改造, 购车,等等）
            ,prod_type_raw -- 贷款种类
            ,cus_manager -- 客户经理
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_share -- 申请人对经营体持股比例
            ,repay_mode_std -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.businesssum_or_apply_amount, o.businesssum_or_apply_amount) as businesssum_or_apply_amount -- 承贷金额或申请金额
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.chanel, o.chanel) as chanel -- 渠道
    ,nvl(n.businesstype_or_biz_type, o.businesstype_or_biz_type) as businesstype_or_biz_type -- 业务品种或产品类别
    ,nvl(n.marriage_status_cd, o.marriage_status_cd) as marriage_status_cd -- 婚姻状态
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别
    ,nvl(n.edu_degree_cd, o.edu_degree_cd) as edu_degree_cd -- 教育程度
    ,nvl(n.birth_date, o.birth_date) as birth_date -- 出生日期
    ,nvl(n.indu_typ_cd, o.indu_typ_cd) as indu_typ_cd -- 行业类型
    ,nvl(n.obiligate1, o.obiligate1) as obiligate1 -- 预留1
    ,nvl(n.obiligate2, o.obiligate2) as obiligate2 -- 预留2
    ,nvl(n.obiligate3, o.obiligate3) as obiligate3 -- 预留3
    ,nvl(n.obiligate4, o.obiligate4) as obiligate4 -- 预留4
    ,nvl(n.obiligate5, o.obiligate5) as obiligate5 -- 预留5
    ,nvl(n.obiligate6, o.obiligate6) as obiligate6 -- 预留6
    ,nvl(n.obiligate7, o.obiligate7) as obiligate7 -- 预留7
    ,nvl(n.obiligate8, o.obiligate8) as obiligate8 -- 预留8
    ,nvl(n.obiligate9, o.obiligate9) as obiligate9 -- 预留9
    ,nvl(n.obiligate10, o.obiligate10) as obiligate10 -- 预留10
    ,nvl(n.obiligate11, o.obiligate11) as obiligate11 -- 预留11
    ,nvl(n.obiligate12, o.obiligate12) as obiligate12 -- 预留12
    ,nvl(n.obiligate13, o.obiligate13) as obiligate13 -- 预留13
    ,nvl(n.obiligate14, o.obiligate14) as obiligate14 -- 预留14
    ,nvl(n.obiligate15, o.obiligate15) as obiligate15 -- 预留15
    ,nvl(n.obiligate16, o.obiligate16) as obiligate16 -- 预留16
    ,nvl(n.obiligate17, o.obiligate17) as obiligate17 -- 预留17
    ,nvl(n.obiligate18, o.obiligate18) as obiligate18 -- 预留18
    ,nvl(n.obiligate19, o.obiligate19) as obiligate19 -- 预留19
    ,nvl(n.obiligate20, o.obiligate20) as obiligate20 -- 预留20
    ,nvl(n.rep_id, o.rep_id) as rep_id -- 报告编号
    ,nvl(n.non_loan_sum_cnt, o.non_loan_sum_cnt) as non_loan_sum_cnt -- 未结清贷款信息汇总笔数
    ,nvl(n.house_loan_cnt, o.house_loan_cnt) as house_loan_cnt -- 住房贷款笔数
    ,nvl(n.marriage_status_cd_std, o.marriage_status_cd_std) as marriage_status_cd_std -- 婚姻状态(规则标准)
    ,nvl(n.gender_cd_std, o.gender_cd_std) as gender_cd_std -- 性别(规则标准)
    ,nvl(n.edu_degree_cd_std, o.edu_degree_cd_std) as edu_degree_cd_std -- 教育程度(规则标准)
    ,nvl(n.indu_typ_cd_std, o.indu_typ_cd_std) as indu_typ_cd_std -- 行业类型(规则标准)
    ,nvl(n.childflag2, o.childflag2) as childflag2 -- 有无子女
    ,nvl(n.dummy_mobile_no, o.dummy_mobile_no) as dummy_mobile_no -- 有无申请人移动电话
    ,nvl(n.emp_status, o.emp_status) as emp_status -- 雇佣状态（自雇、受薪)
    ,nvl(n.emp_status_std, o.emp_status_std) as emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
    ,nvl(n.residence_type, o.residence_type) as residence_type -- 现住房状况（自有，租赁，合住等）
    ,nvl(n.residence_type_std, o.residence_type_std) as residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
    ,nvl(n.house_flag1, o.house_flag1) as house_flag1 -- 本地有无房产
    ,nvl(n.house_value, o.house_value) as house_value -- 房产价值
    ,nvl(n.industryage, o.industryage) as industryage -- 企业成立年限
    ,nvl(n.months_curr_address_raw, o.months_curr_address_raw) as months_curr_address_raw -- 现住址居住时间
    ,nvl(n.months_curr_employer, o.months_curr_employer) as months_curr_employer -- 现单位工作年限
    ,nvl(n.profsn_title_cd, o.profsn_title_cd) as profsn_title_cd -- 职称代码（初级、中级、高级）
    ,nvl(n.profsn_title_cd_std, o.profsn_title_cd_std) as profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
    ,nvl(n.verified_income_all, o.verified_income_all) as verified_income_all -- 认定月收入
    ,nvl(n.worknature, o.worknature) as worknature -- 单位性质
    ,nvl(n.worknature_std, o.worknature_std) as worknature_std -- 单位性质(规则标准)
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 申请金额
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 贷款利率
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 贷款期限
    ,nvl(n.customerid, o.customerid) as customerid -- 客户身份证号
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.loan_cur, o.loan_cur) as loan_cur -- 申请币种
    ,nvl(n.repay_mode, o.repay_mode) as repay_mode -- 还款方式
    ,nvl(n.loan_purpose, o.loan_purpose) as loan_purpose -- 贷款用途（住房改造, 购车,等等）
    ,nvl(n.prod_type_raw, o.prod_type_raw) as prod_type_raw -- 贷款种类
    ,nvl(n.cus_manager, o.cus_manager) as cus_manager -- 客户经理
    ,nvl(n.cus_name, o.cus_name) as cus_name -- 客户姓名
    ,nvl(n.cus_mobile, o.cus_mobile) as cus_mobile -- 手机号码
    ,nvl(n.cus_home_tel, o.cus_home_tel) as cus_home_tel -- 家庭电话
    ,nvl(n.cus_corp_name, o.cus_corp_name) as cus_corp_name -- 工作单位
    ,nvl(n.cus_corp_tel, o.cus_corp_tel) as cus_corp_tel -- 工作单位电话
    ,nvl(n.cus_home_ad, o.cus_home_ad) as cus_home_ad -- 居住地址
    ,nvl(n.cus_reg_ad, o.cus_reg_ad) as cus_reg_ad -- 户籍地址
    ,nvl(n.cus_post_ad, o.cus_post_ad) as cus_post_ad -- 通讯地址
    ,nvl(n.cus_corp_ad, o.cus_corp_ad) as cus_corp_ad -- 工作单位地址
    ,nvl(n.cus_email, o.cus_email) as cus_email -- 电子邮箱
    ,nvl(n.emergencontact_name, o.emergencontact_name) as emergencontact_name -- 紧急联系人姓名
    ,nvl(n.emergencontact_id, o.emergencontact_id) as emergencontact_id -- 紧急联系人身份证号
    ,nvl(n.emergencontact_mobile, o.emergencontact_mobile) as emergencontact_mobile -- 紧急联系人手机号
    ,nvl(n.ent_name, o.ent_name) as ent_name -- 经营体名称
    ,nvl(n.ent_id, o.ent_id) as ent_id -- 经营体注册号
    ,nvl(n.ent_est_date, o.ent_est_date) as ent_est_date -- 设立日期
    ,nvl(n.ent_legal_name, o.ent_legal_name) as ent_legal_name -- 法定代表人名称
    ,nvl(n.ent_tel, o.ent_tel) as ent_tel -- 经营体电话
    ,nvl(n.end_reg_ad, o.end_reg_ad) as end_reg_ad -- 注册地址
    ,nvl(n.ent_office_ad, o.ent_office_ad) as ent_office_ad -- 经营地址
    ,nvl(n.ent_reg_capital, o.ent_reg_capital) as ent_reg_capital -- 注册资本
    ,nvl(n.ent_real_capital, o.ent_real_capital) as ent_real_capital -- 实收资本
    ,nvl(n.ent_emp_num, o.ent_emp_num) as ent_emp_num -- 员工人数
    ,nvl(n.ent_cus_relation, o.ent_cus_relation) as ent_cus_relation -- 申请人与经营体之关系
    ,nvl(n.ent_cus_share, o.ent_cus_share) as ent_cus_share -- 申请人对经营体持股比例
    ,nvl(n.repay_mode_std, o.repay_mode_std) as repay_mode_std -- 
    ,case when
            n.grade_key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_apply_base_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_apply_base_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.data_time <> n.data_time
        or o.businesssum_or_apply_amount <> n.businesssum_or_apply_amount
        or o.serialno <> n.serialno
        or o.chanel <> n.chanel
        or o.businesstype_or_biz_type <> n.businesstype_or_biz_type
        or o.marriage_status_cd <> n.marriage_status_cd
        or o.gender_cd <> n.gender_cd
        or o.edu_degree_cd <> n.edu_degree_cd
        or o.birth_date <> n.birth_date
        or o.indu_typ_cd <> n.indu_typ_cd
        or o.obiligate1 <> n.obiligate1
        or o.obiligate2 <> n.obiligate2
        or o.obiligate3 <> n.obiligate3
        or o.obiligate4 <> n.obiligate4
        or o.obiligate5 <> n.obiligate5
        or o.obiligate6 <> n.obiligate6
        or o.obiligate7 <> n.obiligate7
        or o.obiligate8 <> n.obiligate8
        or o.obiligate9 <> n.obiligate9
        or o.obiligate10 <> n.obiligate10
        or o.obiligate11 <> n.obiligate11
        or o.obiligate12 <> n.obiligate12
        or o.obiligate13 <> n.obiligate13
        or o.obiligate14 <> n.obiligate14
        or o.obiligate15 <> n.obiligate15
        or o.obiligate16 <> n.obiligate16
        or o.obiligate17 <> n.obiligate17
        or o.obiligate18 <> n.obiligate18
        or o.obiligate19 <> n.obiligate19
        or o.obiligate20 <> n.obiligate20
        or o.rep_id <> n.rep_id
        or o.non_loan_sum_cnt <> n.non_loan_sum_cnt
        or o.house_loan_cnt <> n.house_loan_cnt
        or o.marriage_status_cd_std <> n.marriage_status_cd_std
        or o.gender_cd_std <> n.gender_cd_std
        or o.edu_degree_cd_std <> n.edu_degree_cd_std
        or o.indu_typ_cd_std <> n.indu_typ_cd_std
        or o.childflag2 <> n.childflag2
        or o.dummy_mobile_no <> n.dummy_mobile_no
        or o.emp_status <> n.emp_status
        or o.emp_status_std <> n.emp_status_std
        or o.residence_type <> n.residence_type
        or o.residence_type_std <> n.residence_type_std
        or o.house_flag1 <> n.house_flag1
        or o.house_value <> n.house_value
        or o.industryage <> n.industryage
        or o.months_curr_address_raw <> n.months_curr_address_raw
        or o.months_curr_employer <> n.months_curr_employer
        or o.profsn_title_cd <> n.profsn_title_cd
        or o.profsn_title_cd_std <> n.profsn_title_cd_std
        or o.verified_income_all <> n.verified_income_all
        or o.worknature <> n.worknature
        or o.worknature_std <> n.worknature_std
        or o.businesssum <> n.businesssum
        or o.businessrate <> n.businessrate
        or o.termmonth <> n.termmonth
        or o.customerid <> n.customerid
        or o.apply_date <> n.apply_date
        or o.loan_cur <> n.loan_cur
        or o.repay_mode <> n.repay_mode
        or o.loan_purpose <> n.loan_purpose
        or o.prod_type_raw <> n.prod_type_raw
        or o.cus_manager <> n.cus_manager
        or o.cus_name <> n.cus_name
        or o.cus_mobile <> n.cus_mobile
        or o.cus_home_tel <> n.cus_home_tel
        or o.cus_corp_name <> n.cus_corp_name
        or o.cus_corp_tel <> n.cus_corp_tel
        or o.cus_home_ad <> n.cus_home_ad
        or o.cus_reg_ad <> n.cus_reg_ad
        or o.cus_post_ad <> n.cus_post_ad
        or o.cus_corp_ad <> n.cus_corp_ad
        or o.cus_email <> n.cus_email
        or o.emergencontact_name <> n.emergencontact_name
        or o.emergencontact_id <> n.emergencontact_id
        or o.emergencontact_mobile <> n.emergencontact_mobile
        or o.ent_name <> n.ent_name
        or o.ent_id <> n.ent_id
        or o.ent_est_date <> n.ent_est_date
        or o.ent_legal_name <> n.ent_legal_name
        or o.ent_tel <> n.ent_tel
        or o.end_reg_ad <> n.end_reg_ad
        or o.ent_office_ad <> n.ent_office_ad
        or o.ent_reg_capital <> n.ent_reg_capital
        or o.ent_real_capital <> n.ent_real_capital
        or o.ent_emp_num <> n.ent_emp_num
        or o.ent_cus_relation <> n.ent_cus_relation
        or o.ent_cus_share <> n.ent_cus_share
        or o.repay_mode_std <> n.repay_mode_std
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_apply_base_info_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,businesssum_or_apply_amount -- 承贷金额或申请金额
            ,serialno -- 申请流水号
            ,chanel -- 渠道
            ,businesstype_or_biz_type -- 业务品种或产品类别
            ,marriage_status_cd -- 婚姻状态
            ,gender_cd -- 性别
            ,edu_degree_cd -- 教育程度
            ,birth_date -- 出生日期
            ,indu_typ_cd -- 行业类型
            ,obiligate1 -- 预留1
            ,obiligate2 -- 预留2
            ,obiligate3 -- 预留3
            ,obiligate4 -- 预留4
            ,obiligate5 -- 预留5
            ,obiligate6 -- 预留6
            ,obiligate7 -- 预留7
            ,obiligate8 -- 预留8
            ,obiligate9 -- 预留9
            ,obiligate10 -- 预留10
            ,obiligate11 -- 预留11
            ,obiligate12 -- 预留12
            ,obiligate13 -- 预留13
            ,obiligate14 -- 预留14
            ,obiligate15 -- 预留15
            ,obiligate16 -- 预留16
            ,obiligate17 -- 预留17
            ,obiligate18 -- 预留18
            ,obiligate19 -- 预留19
            ,obiligate20 -- 预留20
            ,rep_id -- 报告编号
            ,non_loan_sum_cnt -- 未结清贷款信息汇总笔数
            ,house_loan_cnt -- 住房贷款笔数
            ,marriage_status_cd_std -- 婚姻状态(规则标准)
            ,gender_cd_std -- 性别(规则标准)
            ,edu_degree_cd_std -- 教育程度(规则标准)
            ,indu_typ_cd_std -- 行业类型(规则标准)
            ,childflag2 -- 有无子女
            ,dummy_mobile_no -- 有无申请人移动电话
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
            ,house_flag1 -- 本地有无房产
            ,house_value -- 房产价值
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,worknature_std -- 单位性质(规则标准)
            ,businesssum -- 申请金额
            ,businessrate -- 贷款利率
            ,termmonth -- 贷款期限
            ,customerid -- 客户身份证号
            ,apply_date -- 申请日期
            ,loan_cur -- 申请币种
            ,repay_mode -- 还款方式
            ,loan_purpose -- 贷款用途（住房改造, 购车,等等）
            ,prod_type_raw -- 贷款种类
            ,cus_manager -- 客户经理
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_share -- 申请人对经营体持股比例
            ,repay_mode_std -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_apply_base_info_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,businesssum_or_apply_amount -- 承贷金额或申请金额
            ,serialno -- 申请流水号
            ,chanel -- 渠道
            ,businesstype_or_biz_type -- 业务品种或产品类别
            ,marriage_status_cd -- 婚姻状态
            ,gender_cd -- 性别
            ,edu_degree_cd -- 教育程度
            ,birth_date -- 出生日期
            ,indu_typ_cd -- 行业类型
            ,obiligate1 -- 预留1
            ,obiligate2 -- 预留2
            ,obiligate3 -- 预留3
            ,obiligate4 -- 预留4
            ,obiligate5 -- 预留5
            ,obiligate6 -- 预留6
            ,obiligate7 -- 预留7
            ,obiligate8 -- 预留8
            ,obiligate9 -- 预留9
            ,obiligate10 -- 预留10
            ,obiligate11 -- 预留11
            ,obiligate12 -- 预留12
            ,obiligate13 -- 预留13
            ,obiligate14 -- 预留14
            ,obiligate15 -- 预留15
            ,obiligate16 -- 预留16
            ,obiligate17 -- 预留17
            ,obiligate18 -- 预留18
            ,obiligate19 -- 预留19
            ,obiligate20 -- 预留20
            ,rep_id -- 报告编号
            ,non_loan_sum_cnt -- 未结清贷款信息汇总笔数
            ,house_loan_cnt -- 住房贷款笔数
            ,marriage_status_cd_std -- 婚姻状态(规则标准)
            ,gender_cd_std -- 性别(规则标准)
            ,edu_degree_cd_std -- 教育程度(规则标准)
            ,indu_typ_cd_std -- 行业类型(规则标准)
            ,childflag2 -- 有无子女
            ,dummy_mobile_no -- 有无申请人移动电话
            ,emp_status -- 雇佣状态（自雇、受薪)
            ,emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
            ,residence_type -- 现住房状况（自有，租赁，合住等）
            ,residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
            ,house_flag1 -- 本地有无房产
            ,house_value -- 房产价值
            ,industryage -- 企业成立年限
            ,months_curr_address_raw -- 现住址居住时间
            ,months_curr_employer -- 现单位工作年限
            ,profsn_title_cd -- 职称代码（初级、中级、高级）
            ,profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
            ,verified_income_all -- 认定月收入
            ,worknature -- 单位性质
            ,worknature_std -- 单位性质(规则标准)
            ,businesssum -- 申请金额
            ,businessrate -- 贷款利率
            ,termmonth -- 贷款期限
            ,customerid -- 客户身份证号
            ,apply_date -- 申请日期
            ,loan_cur -- 申请币种
            ,repay_mode -- 还款方式
            ,loan_purpose -- 贷款用途（住房改造, 购车,等等）
            ,prod_type_raw -- 贷款种类
            ,cus_manager -- 客户经理
            ,cus_name -- 客户姓名
            ,cus_mobile -- 手机号码
            ,cus_home_tel -- 家庭电话
            ,cus_corp_name -- 工作单位
            ,cus_corp_tel -- 工作单位电话
            ,cus_home_ad -- 居住地址
            ,cus_reg_ad -- 户籍地址
            ,cus_post_ad -- 通讯地址
            ,cus_corp_ad -- 工作单位地址
            ,cus_email -- 电子邮箱
            ,emergencontact_name -- 紧急联系人姓名
            ,emergencontact_id -- 紧急联系人身份证号
            ,emergencontact_mobile -- 紧急联系人手机号
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_share -- 申请人对经营体持股比例
            ,repay_mode_std -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.businesssum_or_apply_amount -- 承贷金额或申请金额
    ,o.serialno -- 申请流水号
    ,o.chanel -- 渠道
    ,o.businesstype_or_biz_type -- 业务品种或产品类别
    ,o.marriage_status_cd -- 婚姻状态
    ,o.gender_cd -- 性别
    ,o.edu_degree_cd -- 教育程度
    ,o.birth_date -- 出生日期
    ,o.indu_typ_cd -- 行业类型
    ,o.obiligate1 -- 预留1
    ,o.obiligate2 -- 预留2
    ,o.obiligate3 -- 预留3
    ,o.obiligate4 -- 预留4
    ,o.obiligate5 -- 预留5
    ,o.obiligate6 -- 预留6
    ,o.obiligate7 -- 预留7
    ,o.obiligate8 -- 预留8
    ,o.obiligate9 -- 预留9
    ,o.obiligate10 -- 预留10
    ,o.obiligate11 -- 预留11
    ,o.obiligate12 -- 预留12
    ,o.obiligate13 -- 预留13
    ,o.obiligate14 -- 预留14
    ,o.obiligate15 -- 预留15
    ,o.obiligate16 -- 预留16
    ,o.obiligate17 -- 预留17
    ,o.obiligate18 -- 预留18
    ,o.obiligate19 -- 预留19
    ,o.obiligate20 -- 预留20
    ,o.rep_id -- 报告编号
    ,o.non_loan_sum_cnt -- 未结清贷款信息汇总笔数
    ,o.house_loan_cnt -- 住房贷款笔数
    ,o.marriage_status_cd_std -- 婚姻状态(规则标准)
    ,o.gender_cd_std -- 性别(规则标准)
    ,o.edu_degree_cd_std -- 教育程度(规则标准)
    ,o.indu_typ_cd_std -- 行业类型(规则标准)
    ,o.childflag2 -- 有无子女
    ,o.dummy_mobile_no -- 有无申请人移动电话
    ,o.emp_status -- 雇佣状态（自雇、受薪)
    ,o.emp_status_std -- 雇佣状态（自雇、受薪)(规则标准)
    ,o.residence_type -- 现住房状况（自有，租赁，合住等）
    ,o.residence_type_std -- 现住房状况（自有，租赁，合住等）(规则标准)
    ,o.house_flag1 -- 本地有无房产
    ,o.house_value -- 房产价值
    ,o.industryage -- 企业成立年限
    ,o.months_curr_address_raw -- 现住址居住时间
    ,o.months_curr_employer -- 现单位工作年限
    ,o.profsn_title_cd -- 职称代码（初级、中级、高级）
    ,o.profsn_title_cd_std -- 职称代码（初级、中级、高级）(规则标准)
    ,o.verified_income_all -- 认定月收入
    ,o.worknature -- 单位性质
    ,o.worknature_std -- 单位性质(规则标准)
    ,o.businesssum -- 申请金额
    ,o.businessrate -- 贷款利率
    ,o.termmonth -- 贷款期限
    ,o.customerid -- 客户身份证号
    ,o.apply_date -- 申请日期
    ,o.loan_cur -- 申请币种
    ,o.repay_mode -- 还款方式
    ,o.loan_purpose -- 贷款用途（住房改造, 购车,等等）
    ,o.prod_type_raw -- 贷款种类
    ,o.cus_manager -- 客户经理
    ,o.cus_name -- 客户姓名
    ,o.cus_mobile -- 手机号码
    ,o.cus_home_tel -- 家庭电话
    ,o.cus_corp_name -- 工作单位
    ,o.cus_corp_tel -- 工作单位电话
    ,o.cus_home_ad -- 居住地址
    ,o.cus_reg_ad -- 户籍地址
    ,o.cus_post_ad -- 通讯地址
    ,o.cus_corp_ad -- 工作单位地址
    ,o.cus_email -- 电子邮箱
    ,o.emergencontact_name -- 紧急联系人姓名
    ,o.emergencontact_id -- 紧急联系人身份证号
    ,o.emergencontact_mobile -- 紧急联系人手机号
    ,o.ent_name -- 经营体名称
    ,o.ent_id -- 经营体注册号
    ,o.ent_est_date -- 设立日期
    ,o.ent_legal_name -- 法定代表人名称
    ,o.ent_tel -- 经营体电话
    ,o.end_reg_ad -- 注册地址
    ,o.ent_office_ad -- 经营地址
    ,o.ent_reg_capital -- 注册资本
    ,o.ent_real_capital -- 实收资本
    ,o.ent_emp_num -- 员工人数
    ,o.ent_cus_relation -- 申请人与经营体之关系
    ,o.ent_cus_share -- 申请人对经营体持股比例
    ,o.repay_mode_std -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_apply_base_info_bk o
    left join ${iol_schema}.rcds_ir_apply_base_info_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_apply_base_info_cl d
        on
            o.grade_key_id = d.grade_key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_apply_base_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_apply_base_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_apply_base_info_cl;
alter table ${iol_schema}.rcds_ir_apply_base_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_apply_base_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_apply_base_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_apply_base_info_op purge;
drop table ${iol_schema}.rcds_ir_apply_base_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_apply_base_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_apply_base_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
