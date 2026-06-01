/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_micro_customer_base_info
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
create table ${iol_schema}.hgls_micro_customer_base_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_micro_customer_base_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_micro_customer_base_info_op purge;
drop table ${iol_schema}.hgls_micro_customer_base_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_micro_customer_base_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_micro_customer_base_info where 0=1;

create table ${iol_schema}.hgls_micro_customer_base_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_micro_customer_base_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_micro_customer_base_info_cl(
            info_id -- 主键ID
            ,code -- 
            ,loan_id -- 进件id
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,phone_address -- 手机号所在地
            ,marry_time -- 结婚时间
            ,live_years -- 居住年限
            ,live_info -- 居住情况
            ,economic_power_figures -- 家庭经济产人物
            ,is_have_children -- 是否有子女
            ,live_environment -- 居住环境
            ,bad_habits -- 不良嗜好
            ,work_info -- 工作情况
            ,family_membership -- 家庭成员健康情况
            ,parents_work_info -- 父母工作情况
            ,children_work_info -- 子女工作情况
            ,children_school_info -- 子女上学情况
            ,sesame_credit_score -- 个人芝麻信用分
            ,use_info -- 贷款资金使用明细
            ,own_funds_rate -- 自有资金占比情况
            ,children_num -- 子女人数
            ,children_join_busi -- 子女是否参与生意
            ,parent_join_busi -- 父母是否参与生意
            ,enterpr_legal_person_num -- 作为法人的企业数目
            ,enterpr_shareholder_num -- 作为股东的企业数目
            ,self_money -- 项目自有资金情况-自有资金
            ,loan_back -- 项目自有资金情况-货款回笼
            ,friends_loan -- 项目自有资金情况-亲友借款
            ,other_money -- 项目自有资金情况-其他
            ,race -- 民族
            ,marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
            ,politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
            ,member_num -- 家庭人数
            ,live_environment_other -- 居住环境其他情况
            ,parents_work_info_other -- 父母工作其他情况
            ,children_work_info_other -- 子女工作其他情况
            ,economic_power_figures_other -- 家庭经济产人物其他
            ,family_membership_other -- 家庭成员健康情况其他
            ,business_concern -- 生意关注度
            ,risk_note -- 客户风险情况概述
            ,survey_result -- 客户经理调查结论
            ,cust_type -- 进件客户类型：1，经营户；2，工薪族
            ,busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
            ,house_type -- 房抵类型：1，一抵业务；2，二抵业务
            ,work_total_years -- 工作总年限
            ,this_work_years -- 本单位工作年限
            ,house_num -- 主借人家庭房产数，字典值fcs
            ,car_count -- 车辆数目
            ,loan_apply_type -- 信贷产品类型：1,经营,2,消费
            ,spouse_work_info -- 配偶工作情况
            ,measure_type -- 压力测算类型
            ,reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
            ,balance -- 余额（不含本次贷款的月供）
            ,register_date -- 合同起始日期
            ,main_guarantee_type -- 主要担保方式
            ,work_name -- 工作单位
            ,work_region -- 单位地址省市区,多级斜杠隔开
            ,work_address -- 单位详细地址
            ,education -- 学历
            ,is_argi_loan -- 是否涉农贷款
            ,face_industry -- 投向行业,字典值txhy
            ,ipc_industry -- IPC行业分类，字典ipchyfl
            ,annual_personal_income -- 个人年均收入，单位元
            ,annual_home_income -- 家庭年均收入，单位元
            ,guarantee_type -- 担保方式，1信用，2，保证
            ,actual_repayment_period -- 实际还款期限
            ,actual_repayment_kind -- 实际还款方式
            ,has_house -- 本地有无房产1有0无
            ,featured_prod_category -- 特色产品类目，字典值tscplm
            ,house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
            ,house_zijian_num -- 农村自建房数量
            ,house_shangpin_num -- 商品房数量
            ,is_employee_of_bank -- 是否本行员工
            ,unit_phone -- 单位电话
            ,unit_property -- 单位性质xwddwxz
            ,unit_industry -- 单位所属行业txhy
            ,occupation -- 职业xwdzy
            ,positions -- 职务xwdzw
            ,jobtitle -- 职称xwdzc
            ,occupation_supplement -- 从业状况
            ,on_board_dt -- 入职日期
            ,house_price -- 房产价值
            ,live_years_type -- 居住年限-三色表
            ,retail_rate_back_msg -- 零售评级返回报文体
            ,outside_house -- 外地有无房产1有0无
            ,outside_house_zijian_num -- 外地农村自建房数量
            ,outside_house_shangpin_num -- 外地商品房数量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_micro_customer_base_info_op(
            info_id -- 主键ID
            ,code -- 
            ,loan_id -- 进件id
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,phone_address -- 手机号所在地
            ,marry_time -- 结婚时间
            ,live_years -- 居住年限
            ,live_info -- 居住情况
            ,economic_power_figures -- 家庭经济产人物
            ,is_have_children -- 是否有子女
            ,live_environment -- 居住环境
            ,bad_habits -- 不良嗜好
            ,work_info -- 工作情况
            ,family_membership -- 家庭成员健康情况
            ,parents_work_info -- 父母工作情况
            ,children_work_info -- 子女工作情况
            ,children_school_info -- 子女上学情况
            ,sesame_credit_score -- 个人芝麻信用分
            ,use_info -- 贷款资金使用明细
            ,own_funds_rate -- 自有资金占比情况
            ,children_num -- 子女人数
            ,children_join_busi -- 子女是否参与生意
            ,parent_join_busi -- 父母是否参与生意
            ,enterpr_legal_person_num -- 作为法人的企业数目
            ,enterpr_shareholder_num -- 作为股东的企业数目
            ,self_money -- 项目自有资金情况-自有资金
            ,loan_back -- 项目自有资金情况-货款回笼
            ,friends_loan -- 项目自有资金情况-亲友借款
            ,other_money -- 项目自有资金情况-其他
            ,race -- 民族
            ,marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
            ,politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
            ,member_num -- 家庭人数
            ,live_environment_other -- 居住环境其他情况
            ,parents_work_info_other -- 父母工作其他情况
            ,children_work_info_other -- 子女工作其他情况
            ,economic_power_figures_other -- 家庭经济产人物其他
            ,family_membership_other -- 家庭成员健康情况其他
            ,business_concern -- 生意关注度
            ,risk_note -- 客户风险情况概述
            ,survey_result -- 客户经理调查结论
            ,cust_type -- 进件客户类型：1，经营户；2，工薪族
            ,busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
            ,house_type -- 房抵类型：1，一抵业务；2，二抵业务
            ,work_total_years -- 工作总年限
            ,this_work_years -- 本单位工作年限
            ,house_num -- 主借人家庭房产数，字典值fcs
            ,car_count -- 车辆数目
            ,loan_apply_type -- 信贷产品类型：1,经营,2,消费
            ,spouse_work_info -- 配偶工作情况
            ,measure_type -- 压力测算类型
            ,reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
            ,balance -- 余额（不含本次贷款的月供）
            ,register_date -- 合同起始日期
            ,main_guarantee_type -- 主要担保方式
            ,work_name -- 工作单位
            ,work_region -- 单位地址省市区,多级斜杠隔开
            ,work_address -- 单位详细地址
            ,education -- 学历
            ,is_argi_loan -- 是否涉农贷款
            ,face_industry -- 投向行业,字典值txhy
            ,ipc_industry -- IPC行业分类，字典ipchyfl
            ,annual_personal_income -- 个人年均收入，单位元
            ,annual_home_income -- 家庭年均收入，单位元
            ,guarantee_type -- 担保方式，1信用，2，保证
            ,actual_repayment_period -- 实际还款期限
            ,actual_repayment_kind -- 实际还款方式
            ,has_house -- 本地有无房产1有0无
            ,featured_prod_category -- 特色产品类目，字典值tscplm
            ,house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
            ,house_zijian_num -- 农村自建房数量
            ,house_shangpin_num -- 商品房数量
            ,is_employee_of_bank -- 是否本行员工
            ,unit_phone -- 单位电话
            ,unit_property -- 单位性质xwddwxz
            ,unit_industry -- 单位所属行业txhy
            ,occupation -- 职业xwdzy
            ,positions -- 职务xwdzw
            ,jobtitle -- 职称xwdzc
            ,occupation_supplement -- 从业状况
            ,on_board_dt -- 入职日期
            ,house_price -- 房产价值
            ,live_years_type -- 居住年限-三色表
            ,retail_rate_back_msg -- 零售评级返回报文体
            ,outside_house -- 外地有无房产1有0无
            ,outside_house_zijian_num -- 外地农村自建房数量
            ,outside_house_shangpin_num -- 外地商品房数量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.info_id, o.info_id) as info_id -- 主键ID
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件id
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.phone_address, o.phone_address) as phone_address -- 手机号所在地
    ,nvl(n.marry_time, o.marry_time) as marry_time -- 结婚时间
    ,nvl(n.live_years, o.live_years) as live_years -- 居住年限
    ,nvl(n.live_info, o.live_info) as live_info -- 居住情况
    ,nvl(n.economic_power_figures, o.economic_power_figures) as economic_power_figures -- 家庭经济产人物
    ,nvl(n.is_have_children, o.is_have_children) as is_have_children -- 是否有子女
    ,nvl(n.live_environment, o.live_environment) as live_environment -- 居住环境
    ,nvl(n.bad_habits, o.bad_habits) as bad_habits -- 不良嗜好
    ,nvl(n.work_info, o.work_info) as work_info -- 工作情况
    ,nvl(n.family_membership, o.family_membership) as family_membership -- 家庭成员健康情况
    ,nvl(n.parents_work_info, o.parents_work_info) as parents_work_info -- 父母工作情况
    ,nvl(n.children_work_info, o.children_work_info) as children_work_info -- 子女工作情况
    ,nvl(n.children_school_info, o.children_school_info) as children_school_info -- 子女上学情况
    ,nvl(n.sesame_credit_score, o.sesame_credit_score) as sesame_credit_score -- 个人芝麻信用分
    ,nvl(n.use_info, o.use_info) as use_info -- 贷款资金使用明细
    ,nvl(n.own_funds_rate, o.own_funds_rate) as own_funds_rate -- 自有资金占比情况
    ,nvl(n.children_num, o.children_num) as children_num -- 子女人数
    ,nvl(n.children_join_busi, o.children_join_busi) as children_join_busi -- 子女是否参与生意
    ,nvl(n.parent_join_busi, o.parent_join_busi) as parent_join_busi -- 父母是否参与生意
    ,nvl(n.enterpr_legal_person_num, o.enterpr_legal_person_num) as enterpr_legal_person_num -- 作为法人的企业数目
    ,nvl(n.enterpr_shareholder_num, o.enterpr_shareholder_num) as enterpr_shareholder_num -- 作为股东的企业数目
    ,nvl(n.self_money, o.self_money) as self_money -- 项目自有资金情况-自有资金
    ,nvl(n.loan_back, o.loan_back) as loan_back -- 项目自有资金情况-货款回笼
    ,nvl(n.friends_loan, o.friends_loan) as friends_loan -- 项目自有资金情况-亲友借款
    ,nvl(n.other_money, o.other_money) as other_money -- 项目自有资金情况-其他
    ,nvl(n.race, o.race) as race -- 民族
    ,nvl(n.marry_time_long, o.marry_time_long) as marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
    ,nvl(n.politics_face, o.politics_face) as politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
    ,nvl(n.member_num, o.member_num) as member_num -- 家庭人数
    ,nvl(n.live_environment_other, o.live_environment_other) as live_environment_other -- 居住环境其他情况
    ,nvl(n.parents_work_info_other, o.parents_work_info_other) as parents_work_info_other -- 父母工作其他情况
    ,nvl(n.children_work_info_other, o.children_work_info_other) as children_work_info_other -- 子女工作其他情况
    ,nvl(n.economic_power_figures_other, o.economic_power_figures_other) as economic_power_figures_other -- 家庭经济产人物其他
    ,nvl(n.family_membership_other, o.family_membership_other) as family_membership_other -- 家庭成员健康情况其他
    ,nvl(n.business_concern, o.business_concern) as business_concern -- 生意关注度
    ,nvl(n.risk_note, o.risk_note) as risk_note -- 客户风险情况概述
    ,nvl(n.survey_result, o.survey_result) as survey_result -- 客户经理调查结论
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 进件客户类型：1，经营户；2，工薪族
    ,nvl(n.busi_cust_type, o.busi_cust_type) as busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
    ,nvl(n.house_type, o.house_type) as house_type -- 房抵类型：1，一抵业务；2，二抵业务
    ,nvl(n.work_total_years, o.work_total_years) as work_total_years -- 工作总年限
    ,nvl(n.this_work_years, o.this_work_years) as this_work_years -- 本单位工作年限
    ,nvl(n.house_num, o.house_num) as house_num -- 主借人家庭房产数，字典值fcs
    ,nvl(n.car_count, o.car_count) as car_count -- 车辆数目
    ,nvl(n.loan_apply_type, o.loan_apply_type) as loan_apply_type -- 信贷产品类型：1,经营,2,消费
    ,nvl(n.spouse_work_info, o.spouse_work_info) as spouse_work_info -- 配偶工作情况
    ,nvl(n.measure_type, o.measure_type) as measure_type -- 压力测算类型
    ,nvl(n.reimbursement_money, o.reimbursement_money) as reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
    ,nvl(n.balance, o.balance) as balance -- 余额（不含本次贷款的月供）
    ,nvl(n.register_date, o.register_date) as register_date -- 合同起始日期
    ,nvl(n.main_guarantee_type, o.main_guarantee_type) as main_guarantee_type -- 主要担保方式
    ,nvl(n.work_name, o.work_name) as work_name -- 工作单位
    ,nvl(n.work_region, o.work_region) as work_region -- 单位地址省市区,多级斜杠隔开
    ,nvl(n.work_address, o.work_address) as work_address -- 单位详细地址
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.is_argi_loan, o.is_argi_loan) as is_argi_loan -- 是否涉农贷款
    ,nvl(n.face_industry, o.face_industry) as face_industry -- 投向行业,字典值txhy
    ,nvl(n.ipc_industry, o.ipc_industry) as ipc_industry -- IPC行业分类，字典ipchyfl
    ,nvl(n.annual_personal_income, o.annual_personal_income) as annual_personal_income -- 个人年均收入，单位元
    ,nvl(n.annual_home_income, o.annual_home_income) as annual_home_income -- 家庭年均收入，单位元
    ,nvl(n.guarantee_type, o.guarantee_type) as guarantee_type -- 担保方式，1信用，2，保证
    ,nvl(n.actual_repayment_period, o.actual_repayment_period) as actual_repayment_period -- 实际还款期限
    ,nvl(n.actual_repayment_kind, o.actual_repayment_kind) as actual_repayment_kind -- 实际还款方式
    ,nvl(n.has_house, o.has_house) as has_house -- 本地有无房产1有0无
    ,nvl(n.featured_prod_category, o.featured_prod_category) as featured_prod_category -- 特色产品类目，字典值tscplm
    ,nvl(n.house_property_type, o.house_property_type) as house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
    ,nvl(n.house_zijian_num, o.house_zijian_num) as house_zijian_num -- 农村自建房数量
    ,nvl(n.house_shangpin_num, o.house_shangpin_num) as house_shangpin_num -- 商品房数量
    ,nvl(n.is_employee_of_bank, o.is_employee_of_bank) as is_employee_of_bank -- 是否本行员工
    ,nvl(n.unit_phone, o.unit_phone) as unit_phone -- 单位电话
    ,nvl(n.unit_property, o.unit_property) as unit_property -- 单位性质xwddwxz
    ,nvl(n.unit_industry, o.unit_industry) as unit_industry -- 单位所属行业txhy
    ,nvl(n.occupation, o.occupation) as occupation -- 职业xwdzy
    ,nvl(n.positions, o.positions) as positions -- 职务xwdzw
    ,nvl(n.jobtitle, o.jobtitle) as jobtitle -- 职称xwdzc
    ,nvl(n.occupation_supplement, o.occupation_supplement) as occupation_supplement -- 从业状况
    ,nvl(n.on_board_dt, o.on_board_dt) as on_board_dt -- 入职日期
    ,nvl(n.house_price, o.house_price) as house_price -- 房产价值
    ,nvl(n.live_years_type, o.live_years_type) as live_years_type -- 居住年限-三色表
    ,nvl(n.retail_rate_back_msg, o.retail_rate_back_msg) as retail_rate_back_msg -- 零售评级返回报文体
    ,nvl(n.outside_house, o.outside_house) as outside_house -- 外地有无房产1有0无
    ,nvl(n.outside_house_zijian_num, o.outside_house_zijian_num) as outside_house_zijian_num -- 外地农村自建房数量
    ,nvl(n.outside_house_shangpin_num, o.outside_house_shangpin_num) as outside_house_shangpin_num -- 外地商品房数量
    ,case when
            n.info_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.info_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.info_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_micro_customer_base_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_micro_customer_base_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.info_id = n.info_id
where (
        o.info_id is null
    )
    or (
        n.info_id is null
    )
    or (
        o.code <> n.code
        or o.loan_id <> n.loan_id
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.phone_address <> n.phone_address
        or o.marry_time <> n.marry_time
        or o.live_years <> n.live_years
        or o.live_info <> n.live_info
        or o.economic_power_figures <> n.economic_power_figures
        or o.is_have_children <> n.is_have_children
        or o.live_environment <> n.live_environment
        or o.bad_habits <> n.bad_habits
        or o.work_info <> n.work_info
        or o.family_membership <> n.family_membership
        or o.parents_work_info <> n.parents_work_info
        or o.children_work_info <> n.children_work_info
        or o.children_school_info <> n.children_school_info
        or o.sesame_credit_score <> n.sesame_credit_score
        or o.use_info <> n.use_info
        or o.own_funds_rate <> n.own_funds_rate
        or o.children_num <> n.children_num
        or o.children_join_busi <> n.children_join_busi
        or o.parent_join_busi <> n.parent_join_busi
        or o.enterpr_legal_person_num <> n.enterpr_legal_person_num
        or o.enterpr_shareholder_num <> n.enterpr_shareholder_num
        or o.self_money <> n.self_money
        or o.loan_back <> n.loan_back
        or o.friends_loan <> n.friends_loan
        or o.other_money <> n.other_money
        or o.race <> n.race
        or o.marry_time_long <> n.marry_time_long
        or o.politics_face <> n.politics_face
        or o.member_num <> n.member_num
        or o.live_environment_other <> n.live_environment_other
        or o.parents_work_info_other <> n.parents_work_info_other
        or o.children_work_info_other <> n.children_work_info_other
        or o.economic_power_figures_other <> n.economic_power_figures_other
        or o.family_membership_other <> n.family_membership_other
        or o.business_concern <> n.business_concern
        or o.risk_note <> n.risk_note
        or o.survey_result <> n.survey_result
        or o.cust_type <> n.cust_type
        or o.busi_cust_type <> n.busi_cust_type
        or o.house_type <> n.house_type
        or o.work_total_years <> n.work_total_years
        or o.this_work_years <> n.this_work_years
        or o.house_num <> n.house_num
        or o.car_count <> n.car_count
        or o.loan_apply_type <> n.loan_apply_type
        or o.spouse_work_info <> n.spouse_work_info
        or o.measure_type <> n.measure_type
        or o.reimbursement_money <> n.reimbursement_money
        or o.balance <> n.balance
        or o.register_date <> n.register_date
        or o.main_guarantee_type <> n.main_guarantee_type
        or o.work_name <> n.work_name
        or o.work_region <> n.work_region
        or o.work_address <> n.work_address
        or o.education <> n.education
        or o.is_argi_loan <> n.is_argi_loan
        or o.face_industry <> n.face_industry
        or o.ipc_industry <> n.ipc_industry
        or o.annual_personal_income <> n.annual_personal_income
        or o.annual_home_income <> n.annual_home_income
        or o.guarantee_type <> n.guarantee_type
        or o.actual_repayment_period <> n.actual_repayment_period
        or o.actual_repayment_kind <> n.actual_repayment_kind
        or o.has_house <> n.has_house
        or o.featured_prod_category <> n.featured_prod_category
        or o.house_property_type <> n.house_property_type
        or o.house_zijian_num <> n.house_zijian_num
        or o.house_shangpin_num <> n.house_shangpin_num
        or o.is_employee_of_bank <> n.is_employee_of_bank
        or o.unit_phone <> n.unit_phone
        or o.unit_property <> n.unit_property
        or o.unit_industry <> n.unit_industry
        or o.occupation <> n.occupation
        or o.positions <> n.positions
        or o.jobtitle <> n.jobtitle
        or o.occupation_supplement <> n.occupation_supplement
        or o.on_board_dt <> n.on_board_dt
        or o.house_price <> n.house_price
        or o.live_years_type <> n.live_years_type
        or o.retail_rate_back_msg <> n.retail_rate_back_msg
        or o.outside_house <> n.outside_house
        or o.outside_house_zijian_num <> n.outside_house_zijian_num
        or o.outside_house_shangpin_num <> n.outside_house_shangpin_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_micro_customer_base_info_cl(
            info_id -- 主键ID
            ,code -- 
            ,loan_id -- 进件id
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,phone_address -- 手机号所在地
            ,marry_time -- 结婚时间
            ,live_years -- 居住年限
            ,live_info -- 居住情况
            ,economic_power_figures -- 家庭经济产人物
            ,is_have_children -- 是否有子女
            ,live_environment -- 居住环境
            ,bad_habits -- 不良嗜好
            ,work_info -- 工作情况
            ,family_membership -- 家庭成员健康情况
            ,parents_work_info -- 父母工作情况
            ,children_work_info -- 子女工作情况
            ,children_school_info -- 子女上学情况
            ,sesame_credit_score -- 个人芝麻信用分
            ,use_info -- 贷款资金使用明细
            ,own_funds_rate -- 自有资金占比情况
            ,children_num -- 子女人数
            ,children_join_busi -- 子女是否参与生意
            ,parent_join_busi -- 父母是否参与生意
            ,enterpr_legal_person_num -- 作为法人的企业数目
            ,enterpr_shareholder_num -- 作为股东的企业数目
            ,self_money -- 项目自有资金情况-自有资金
            ,loan_back -- 项目自有资金情况-货款回笼
            ,friends_loan -- 项目自有资金情况-亲友借款
            ,other_money -- 项目自有资金情况-其他
            ,race -- 民族
            ,marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
            ,politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
            ,member_num -- 家庭人数
            ,live_environment_other -- 居住环境其他情况
            ,parents_work_info_other -- 父母工作其他情况
            ,children_work_info_other -- 子女工作其他情况
            ,economic_power_figures_other -- 家庭经济产人物其他
            ,family_membership_other -- 家庭成员健康情况其他
            ,business_concern -- 生意关注度
            ,risk_note -- 客户风险情况概述
            ,survey_result -- 客户经理调查结论
            ,cust_type -- 进件客户类型：1，经营户；2，工薪族
            ,busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
            ,house_type -- 房抵类型：1，一抵业务；2，二抵业务
            ,work_total_years -- 工作总年限
            ,this_work_years -- 本单位工作年限
            ,house_num -- 主借人家庭房产数，字典值fcs
            ,car_count -- 车辆数目
            ,loan_apply_type -- 信贷产品类型：1,经营,2,消费
            ,spouse_work_info -- 配偶工作情况
            ,measure_type -- 压力测算类型
            ,reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
            ,balance -- 余额（不含本次贷款的月供）
            ,register_date -- 合同起始日期
            ,main_guarantee_type -- 主要担保方式
            ,work_name -- 工作单位
            ,work_region -- 单位地址省市区,多级斜杠隔开
            ,work_address -- 单位详细地址
            ,education -- 学历
            ,is_argi_loan -- 是否涉农贷款
            ,face_industry -- 投向行业,字典值txhy
            ,ipc_industry -- IPC行业分类，字典ipchyfl
            ,annual_personal_income -- 个人年均收入，单位元
            ,annual_home_income -- 家庭年均收入，单位元
            ,guarantee_type -- 担保方式，1信用，2，保证
            ,actual_repayment_period -- 实际还款期限
            ,actual_repayment_kind -- 实际还款方式
            ,has_house -- 本地有无房产1有0无
            ,featured_prod_category -- 特色产品类目，字典值tscplm
            ,house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
            ,house_zijian_num -- 农村自建房数量
            ,house_shangpin_num -- 商品房数量
            ,is_employee_of_bank -- 是否本行员工
            ,unit_phone -- 单位电话
            ,unit_property -- 单位性质xwddwxz
            ,unit_industry -- 单位所属行业txhy
            ,occupation -- 职业xwdzy
            ,positions -- 职务xwdzw
            ,jobtitle -- 职称xwdzc
            ,occupation_supplement -- 从业状况
            ,on_board_dt -- 入职日期
            ,house_price -- 房产价值
            ,live_years_type -- 居住年限-三色表
            ,retail_rate_back_msg -- 零售评级返回报文体
            ,outside_house -- 外地有无房产1有0无
            ,outside_house_zijian_num -- 外地农村自建房数量
            ,outside_house_shangpin_num -- 外地商品房数量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_micro_customer_base_info_op(
            info_id -- 主键ID
            ,code -- 
            ,loan_id -- 进件id
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,phone_address -- 手机号所在地
            ,marry_time -- 结婚时间
            ,live_years -- 居住年限
            ,live_info -- 居住情况
            ,economic_power_figures -- 家庭经济产人物
            ,is_have_children -- 是否有子女
            ,live_environment -- 居住环境
            ,bad_habits -- 不良嗜好
            ,work_info -- 工作情况
            ,family_membership -- 家庭成员健康情况
            ,parents_work_info -- 父母工作情况
            ,children_work_info -- 子女工作情况
            ,children_school_info -- 子女上学情况
            ,sesame_credit_score -- 个人芝麻信用分
            ,use_info -- 贷款资金使用明细
            ,own_funds_rate -- 自有资金占比情况
            ,children_num -- 子女人数
            ,children_join_busi -- 子女是否参与生意
            ,parent_join_busi -- 父母是否参与生意
            ,enterpr_legal_person_num -- 作为法人的企业数目
            ,enterpr_shareholder_num -- 作为股东的企业数目
            ,self_money -- 项目自有资金情况-自有资金
            ,loan_back -- 项目自有资金情况-货款回笼
            ,friends_loan -- 项目自有资金情况-亲友借款
            ,other_money -- 项目自有资金情况-其他
            ,race -- 民族
            ,marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
            ,politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
            ,member_num -- 家庭人数
            ,live_environment_other -- 居住环境其他情况
            ,parents_work_info_other -- 父母工作其他情况
            ,children_work_info_other -- 子女工作其他情况
            ,economic_power_figures_other -- 家庭经济产人物其他
            ,family_membership_other -- 家庭成员健康情况其他
            ,business_concern -- 生意关注度
            ,risk_note -- 客户风险情况概述
            ,survey_result -- 客户经理调查结论
            ,cust_type -- 进件客户类型：1，经营户；2，工薪族
            ,busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
            ,house_type -- 房抵类型：1，一抵业务；2，二抵业务
            ,work_total_years -- 工作总年限
            ,this_work_years -- 本单位工作年限
            ,house_num -- 主借人家庭房产数，字典值fcs
            ,car_count -- 车辆数目
            ,loan_apply_type -- 信贷产品类型：1,经营,2,消费
            ,spouse_work_info -- 配偶工作情况
            ,measure_type -- 压力测算类型
            ,reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
            ,balance -- 余额（不含本次贷款的月供）
            ,register_date -- 合同起始日期
            ,main_guarantee_type -- 主要担保方式
            ,work_name -- 工作单位
            ,work_region -- 单位地址省市区,多级斜杠隔开
            ,work_address -- 单位详细地址
            ,education -- 学历
            ,is_argi_loan -- 是否涉农贷款
            ,face_industry -- 投向行业,字典值txhy
            ,ipc_industry -- IPC行业分类，字典ipchyfl
            ,annual_personal_income -- 个人年均收入，单位元
            ,annual_home_income -- 家庭年均收入，单位元
            ,guarantee_type -- 担保方式，1信用，2，保证
            ,actual_repayment_period -- 实际还款期限
            ,actual_repayment_kind -- 实际还款方式
            ,has_house -- 本地有无房产1有0无
            ,featured_prod_category -- 特色产品类目，字典值tscplm
            ,house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
            ,house_zijian_num -- 农村自建房数量
            ,house_shangpin_num -- 商品房数量
            ,is_employee_of_bank -- 是否本行员工
            ,unit_phone -- 单位电话
            ,unit_property -- 单位性质xwddwxz
            ,unit_industry -- 单位所属行业txhy
            ,occupation -- 职业xwdzy
            ,positions -- 职务xwdzw
            ,jobtitle -- 职称xwdzc
            ,occupation_supplement -- 从业状况
            ,on_board_dt -- 入职日期
            ,house_price -- 房产价值
            ,live_years_type -- 居住年限-三色表
            ,retail_rate_back_msg -- 零售评级返回报文体
            ,outside_house -- 外地有无房产1有0无
            ,outside_house_zijian_num -- 外地农村自建房数量
            ,outside_house_shangpin_num -- 外地商品房数量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.info_id -- 主键ID
    ,o.code -- 
    ,o.loan_id -- 进件id
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.phone_address -- 手机号所在地
    ,o.marry_time -- 结婚时间
    ,o.live_years -- 居住年限
    ,o.live_info -- 居住情况
    ,o.economic_power_figures -- 家庭经济产人物
    ,o.is_have_children -- 是否有子女
    ,o.live_environment -- 居住环境
    ,o.bad_habits -- 不良嗜好
    ,o.work_info -- 工作情况
    ,o.family_membership -- 家庭成员健康情况
    ,o.parents_work_info -- 父母工作情况
    ,o.children_work_info -- 子女工作情况
    ,o.children_school_info -- 子女上学情况
    ,o.sesame_credit_score -- 个人芝麻信用分
    ,o.use_info -- 贷款资金使用明细
    ,o.own_funds_rate -- 自有资金占比情况
    ,o.children_num -- 子女人数
    ,o.children_join_busi -- 子女是否参与生意
    ,o.parent_join_busi -- 父母是否参与生意
    ,o.enterpr_legal_person_num -- 作为法人的企业数目
    ,o.enterpr_shareholder_num -- 作为股东的企业数目
    ,o.self_money -- 项目自有资金情况-自有资金
    ,o.loan_back -- 项目自有资金情况-货款回笼
    ,o.friends_loan -- 项目自有资金情况-亲友借款
    ,o.other_money -- 项目自有资金情况-其他
    ,o.race -- 民族
    ,o.marry_time_long -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
    ,o.politics_face -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
    ,o.member_num -- 家庭人数
    ,o.live_environment_other -- 居住环境其他情况
    ,o.parents_work_info_other -- 父母工作其他情况
    ,o.children_work_info_other -- 子女工作其他情况
    ,o.economic_power_figures_other -- 家庭经济产人物其他
    ,o.family_membership_other -- 家庭成员健康情况其他
    ,o.business_concern -- 生意关注度
    ,o.risk_note -- 客户风险情况概述
    ,o.survey_result -- 客户经理调查结论
    ,o.cust_type -- 进件客户类型：1，经营户；2，工薪族
    ,o.busi_cust_type -- 个人经营性贷款客户类型，字典grjyxdkkhlx
    ,o.house_type -- 房抵类型：1，一抵业务；2，二抵业务
    ,o.work_total_years -- 工作总年限
    ,o.this_work_years -- 本单位工作年限
    ,o.house_num -- 主借人家庭房产数，字典值fcs
    ,o.car_count -- 车辆数目
    ,o.loan_apply_type -- 信贷产品类型：1,经营,2,消费
    ,o.spouse_work_info -- 配偶工作情况
    ,o.measure_type -- 压力测算类型
    ,o.reimbursement_money -- 本次贷款还款金额（首月/贷款本金+利息）
    ,o.balance -- 余额（不含本次贷款的月供）
    ,o.register_date -- 合同起始日期
    ,o.main_guarantee_type -- 主要担保方式
    ,o.work_name -- 工作单位
    ,o.work_region -- 单位地址省市区,多级斜杠隔开
    ,o.work_address -- 单位详细地址
    ,o.education -- 学历
    ,o.is_argi_loan -- 是否涉农贷款
    ,o.face_industry -- 投向行业,字典值txhy
    ,o.ipc_industry -- IPC行业分类，字典ipchyfl
    ,o.annual_personal_income -- 个人年均收入，单位元
    ,o.annual_home_income -- 家庭年均收入，单位元
    ,o.guarantee_type -- 担保方式，1信用，2，保证
    ,o.actual_repayment_period -- 实际还款期限
    ,o.actual_repayment_kind -- 实际还款方式
    ,o.has_house -- 本地有无房产1有0无
    ,o.featured_prod_category -- 特色产品类目，字典值tscplm
    ,o.house_property_type -- 房产类型：housePropertyType，1：农村自建房，2：商品房
    ,o.house_zijian_num -- 农村自建房数量
    ,o.house_shangpin_num -- 商品房数量
    ,o.is_employee_of_bank -- 是否本行员工
    ,o.unit_phone -- 单位电话
    ,o.unit_property -- 单位性质xwddwxz
    ,o.unit_industry -- 单位所属行业txhy
    ,o.occupation -- 职业xwdzy
    ,o.positions -- 职务xwdzw
    ,o.jobtitle -- 职称xwdzc
    ,o.occupation_supplement -- 从业状况
    ,o.on_board_dt -- 入职日期
    ,o.house_price -- 房产价值
    ,o.live_years_type -- 居住年限-三色表
    ,o.retail_rate_back_msg -- 零售评级返回报文体
    ,o.outside_house -- 外地有无房产1有0无
    ,o.outside_house_zijian_num -- 外地农村自建房数量
    ,o.outside_house_shangpin_num -- 外地商品房数量
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.hgls_micro_customer_base_info_bk o
    left join ${iol_schema}.hgls_micro_customer_base_info_op n
        on
            o.info_id = n.info_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_micro_customer_base_info_cl d
        on
            o.info_id = d.info_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_micro_customer_base_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_micro_customer_base_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_micro_customer_base_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_micro_customer_base_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_micro_customer_base_info exchange partition p_${batch_date} with table ${iol_schema}.hgls_micro_customer_base_info_cl;
alter table ${iol_schema}.hgls_micro_customer_base_info exchange partition p_20991231 with table ${iol_schema}.hgls_micro_customer_base_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_micro_customer_base_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_micro_customer_base_info_op purge;
drop table ${iol_schema}.hgls_micro_customer_base_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_micro_customer_base_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_micro_customer_base_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
