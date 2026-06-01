/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_micro_customer_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_micro_customer_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_micro_customer_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_micro_customer_base_info(
    info_id number(22,0) -- 主键ID
    ,code varchar2(4000) -- 
    ,loan_id number(22,0) -- 进件id
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,phone_address varchar2(4000) -- 手机号所在地
    ,marry_time timestamp -- 结婚时间
    ,live_years varchar2(4000) -- 居住年限
    ,live_info varchar2(4000) -- 居住情况
    ,economic_power_figures varchar2(4000) -- 家庭经济产人物
    ,is_have_children number(22,0) -- 是否有子女
    ,live_environment varchar2(4000) -- 居住环境
    ,bad_habits varchar2(4000) -- 不良嗜好
    ,work_info varchar2(4000) -- 工作情况
    ,family_membership varchar2(4000) -- 家庭成员健康情况
    ,parents_work_info varchar2(4000) -- 父母工作情况
    ,children_work_info varchar2(4000) -- 子女工作情况
    ,children_school_info varchar2(4000) -- 子女上学情况
    ,sesame_credit_score number(22,0) -- 个人芝麻信用分
    ,use_info varchar2(4000) -- 贷款资金使用明细
    ,own_funds_rate varchar2(4000) -- 自有资金占比情况
    ,children_num number(22,0) -- 子女人数
    ,children_join_busi number(22,0) -- 子女是否参与生意
    ,parent_join_busi number(22,0) -- 父母是否参与生意
    ,enterpr_legal_person_num number(22,0) -- 作为法人的企业数目
    ,enterpr_shareholder_num number(22,0) -- 作为股东的企业数目
    ,self_money number(38,8) -- 项目自有资金情况-自有资金
    ,loan_back number(38,8) -- 项目自有资金情况-货款回笼
    ,friends_loan number(38,8) -- 项目自有资金情况-亲友借款
    ,other_money number(38,8) -- 项目自有资金情况-其他
    ,race varchar2(4000) -- 民族
    ,marry_time_long varchar2(4000) -- 结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上
    ,politics_face varchar2(4000) -- 政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士
    ,member_num number(22,0) -- 家庭人数
    ,live_environment_other varchar2(4000) -- 居住环境其他情况
    ,parents_work_info_other varchar2(4000) -- 父母工作其他情况
    ,children_work_info_other varchar2(4000) -- 子女工作其他情况
    ,economic_power_figures_other varchar2(4000) -- 家庭经济产人物其他
    ,family_membership_other varchar2(4000) -- 家庭成员健康情况其他
    ,business_concern varchar2(4000) -- 生意关注度
    ,risk_note varchar2(4000) -- 客户风险情况概述
    ,survey_result varchar2(4000) -- 客户经理调查结论
    ,cust_type varchar2(4000) -- 进件客户类型：1，经营户；2，工薪族
    ,busi_cust_type varchar2(4000) -- 个人经营性贷款客户类型，字典grjyxdkkhlx
    ,house_type varchar2(4000) -- 房抵类型：1，一抵业务；2，二抵业务
    ,work_total_years number(22,0) -- 工作总年限
    ,this_work_years number(22,0) -- 本单位工作年限
    ,house_num varchar2(4000) -- 主借人家庭房产数，字典值fcs
    ,car_count number(22,0) -- 车辆数目
    ,loan_apply_type varchar2(4000) -- 信贷产品类型：1,经营,2,消费
    ,spouse_work_info varchar2(4000) -- 配偶工作情况
    ,measure_type varchar2(4000) -- 压力测算类型
    ,reimbursement_money number(38,8) -- 本次贷款还款金额（首月/贷款本金+利息）
    ,balance number(38,8) -- 余额（不含本次贷款的月供）
    ,register_date varchar2(4000) -- 合同起始日期
    ,main_guarantee_type varchar2(4000) -- 主要担保方式
    ,work_name varchar2(4000) -- 工作单位
    ,work_region varchar2(4000) -- 单位地址省市区,多级斜杠隔开
    ,work_address varchar2(4000) -- 单位详细地址
    ,education varchar2(4000) -- 学历
    ,is_argi_loan number(22,0) -- 是否涉农贷款
    ,face_industry varchar2(4000) -- 投向行业,字典值txhy
    ,ipc_industry varchar2(4000) -- IPC行业分类，字典ipchyfl
    ,annual_personal_income number(38,8) -- 个人年均收入，单位元
    ,annual_home_income number(38,8) -- 家庭年均收入，单位元
    ,guarantee_type varchar2(4000) -- 担保方式，1信用，2，保证
    ,actual_repayment_period varchar2(4000) -- 实际还款期限
    ,actual_repayment_kind varchar2(4000) -- 实际还款方式
    ,has_house varchar2(4000) -- 本地有无房产1有0无
    ,featured_prod_category varchar2(4000) -- 特色产品类目，字典值tscplm
    ,house_property_type varchar2(4000) -- 房产类型：housePropertyType，1：农村自建房，2：商品房
    ,house_zijian_num number(22,0) -- 农村自建房数量
    ,house_shangpin_num number(22,0) -- 商品房数量
    ,is_employee_of_bank varchar2(4000) -- 是否本行员工
    ,unit_phone varchar2(4000) -- 单位电话
    ,unit_property varchar2(4000) -- 单位性质xwddwxz
    ,unit_industry varchar2(4000) -- 单位所属行业txhy
    ,occupation varchar2(4000) -- 职业xwdzy
    ,positions varchar2(4000) -- 职务xwdzw
    ,jobtitle varchar2(4000) -- 职称xwdzc
    ,occupation_supplement varchar2(4000) -- 从业状况
    ,on_board_dt varchar2(4000) -- 入职日期
    ,house_price number(38,8) -- 房产价值
    ,live_years_type varchar2(4000) -- 居住年限-三色表
    ,retail_rate_back_msg varchar2(4000) -- 零售评级返回报文体
    ,outside_house varchar2(4000) -- 外地有无房产1有0无
    ,outside_house_zijian_num number(22,0) -- 外地农村自建房数量
    ,outside_house_shangpin_num number(22,0) -- 外地商品房数量
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
grant select on ${iol_schema}.hgls_micro_customer_base_info to ${iml_schema};
grant select on ${iol_schema}.hgls_micro_customer_base_info to ${icl_schema};
grant select on ${iol_schema}.hgls_micro_customer_base_info to ${idl_schema};
grant select on ${iol_schema}.hgls_micro_customer_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_micro_customer_base_info is '借款人基本信息表';
comment on column ${iol_schema}.hgls_micro_customer_base_info.info_id is '主键ID';
comment on column ${iol_schema}.hgls_micro_customer_base_info.code is '';
comment on column ${iol_schema}.hgls_micro_customer_base_info.loan_id is '进件id';
comment on column ${iol_schema}.hgls_micro_customer_base_info.create_date is '申请日期';
comment on column ${iol_schema}.hgls_micro_customer_base_info.update_date is '更新时间';
comment on column ${iol_schema}.hgls_micro_customer_base_info.phone_address is '手机号所在地';
comment on column ${iol_schema}.hgls_micro_customer_base_info.marry_time is '结婚时间';
comment on column ${iol_schema}.hgls_micro_customer_base_info.live_years is '居住年限';
comment on column ${iol_schema}.hgls_micro_customer_base_info.live_info is '居住情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.economic_power_figures is '家庭经济产人物';
comment on column ${iol_schema}.hgls_micro_customer_base_info.is_have_children is '是否有子女';
comment on column ${iol_schema}.hgls_micro_customer_base_info.live_environment is '居住环境';
comment on column ${iol_schema}.hgls_micro_customer_base_info.bad_habits is '不良嗜好';
comment on column ${iol_schema}.hgls_micro_customer_base_info.work_info is '工作情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.family_membership is '家庭成员健康情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.parents_work_info is '父母工作情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.children_work_info is '子女工作情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.children_school_info is '子女上学情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.sesame_credit_score is '个人芝麻信用分';
comment on column ${iol_schema}.hgls_micro_customer_base_info.use_info is '贷款资金使用明细';
comment on column ${iol_schema}.hgls_micro_customer_base_info.own_funds_rate is '自有资金占比情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.children_num is '子女人数';
comment on column ${iol_schema}.hgls_micro_customer_base_info.children_join_busi is '子女是否参与生意';
comment on column ${iol_schema}.hgls_micro_customer_base_info.parent_join_busi is '父母是否参与生意';
comment on column ${iol_schema}.hgls_micro_customer_base_info.enterpr_legal_person_num is '作为法人的企业数目';
comment on column ${iol_schema}.hgls_micro_customer_base_info.enterpr_shareholder_num is '作为股东的企业数目';
comment on column ${iol_schema}.hgls_micro_customer_base_info.self_money is '项目自有资金情况-自有资金';
comment on column ${iol_schema}.hgls_micro_customer_base_info.loan_back is '项目自有资金情况-货款回笼';
comment on column ${iol_schema}.hgls_micro_customer_base_info.friends_loan is '项目自有资金情况-亲友借款';
comment on column ${iol_schema}.hgls_micro_customer_base_info.other_money is '项目自有资金情况-其他';
comment on column ${iol_schema}.hgls_micro_customer_base_info.race is '民族';
comment on column ${iol_schema}.hgls_micro_customer_base_info.marry_time_long is '结婚时长：1：未婚；2：3年以下；3：3-5年；4：5-10年；5：10年以上';
comment on column ${iol_schema}.hgls_micro_customer_base_info.politics_face is '政治面貌：1，群众；2，共青团员；3，中共党员,4，民主党派；5，无党派人士';
comment on column ${iol_schema}.hgls_micro_customer_base_info.member_num is '家庭人数';
comment on column ${iol_schema}.hgls_micro_customer_base_info.live_environment_other is '居住环境其他情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.parents_work_info_other is '父母工作其他情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.children_work_info_other is '子女工作其他情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.economic_power_figures_other is '家庭经济产人物其他';
comment on column ${iol_schema}.hgls_micro_customer_base_info.family_membership_other is '家庭成员健康情况其他';
comment on column ${iol_schema}.hgls_micro_customer_base_info.business_concern is '生意关注度';
comment on column ${iol_schema}.hgls_micro_customer_base_info.risk_note is '客户风险情况概述';
comment on column ${iol_schema}.hgls_micro_customer_base_info.survey_result is '客户经理调查结论';
comment on column ${iol_schema}.hgls_micro_customer_base_info.cust_type is '进件客户类型：1，经营户；2，工薪族';
comment on column ${iol_schema}.hgls_micro_customer_base_info.busi_cust_type is '个人经营性贷款客户类型，字典grjyxdkkhlx';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_type is '房抵类型：1，一抵业务；2，二抵业务';
comment on column ${iol_schema}.hgls_micro_customer_base_info.work_total_years is '工作总年限';
comment on column ${iol_schema}.hgls_micro_customer_base_info.this_work_years is '本单位工作年限';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_num is '主借人家庭房产数，字典值fcs';
comment on column ${iol_schema}.hgls_micro_customer_base_info.car_count is '车辆数目';
comment on column ${iol_schema}.hgls_micro_customer_base_info.loan_apply_type is '信贷产品类型：1,经营,2,消费';
comment on column ${iol_schema}.hgls_micro_customer_base_info.spouse_work_info is '配偶工作情况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.measure_type is '压力测算类型';
comment on column ${iol_schema}.hgls_micro_customer_base_info.reimbursement_money is '本次贷款还款金额（首月/贷款本金+利息）';
comment on column ${iol_schema}.hgls_micro_customer_base_info.balance is '余额（不含本次贷款的月供）';
comment on column ${iol_schema}.hgls_micro_customer_base_info.register_date is '合同起始日期';
comment on column ${iol_schema}.hgls_micro_customer_base_info.main_guarantee_type is '主要担保方式';
comment on column ${iol_schema}.hgls_micro_customer_base_info.work_name is '工作单位';
comment on column ${iol_schema}.hgls_micro_customer_base_info.work_region is '单位地址省市区,多级斜杠隔开';
comment on column ${iol_schema}.hgls_micro_customer_base_info.work_address is '单位详细地址';
comment on column ${iol_schema}.hgls_micro_customer_base_info.education is '学历';
comment on column ${iol_schema}.hgls_micro_customer_base_info.is_argi_loan is '是否涉农贷款';
comment on column ${iol_schema}.hgls_micro_customer_base_info.face_industry is '投向行业,字典值txhy';
comment on column ${iol_schema}.hgls_micro_customer_base_info.ipc_industry is 'IPC行业分类，字典ipchyfl';
comment on column ${iol_schema}.hgls_micro_customer_base_info.annual_personal_income is '个人年均收入，单位元';
comment on column ${iol_schema}.hgls_micro_customer_base_info.annual_home_income is '家庭年均收入，单位元';
comment on column ${iol_schema}.hgls_micro_customer_base_info.guarantee_type is '担保方式，1信用，2，保证';
comment on column ${iol_schema}.hgls_micro_customer_base_info.actual_repayment_period is '实际还款期限';
comment on column ${iol_schema}.hgls_micro_customer_base_info.actual_repayment_kind is '实际还款方式';
comment on column ${iol_schema}.hgls_micro_customer_base_info.has_house is '本地有无房产1有0无';
comment on column ${iol_schema}.hgls_micro_customer_base_info.featured_prod_category is '特色产品类目，字典值tscplm';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_property_type is '房产类型：housePropertyType，1：农村自建房，2：商品房';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_zijian_num is '农村自建房数量';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_shangpin_num is '商品房数量';
comment on column ${iol_schema}.hgls_micro_customer_base_info.is_employee_of_bank is '是否本行员工';
comment on column ${iol_schema}.hgls_micro_customer_base_info.unit_phone is '单位电话';
comment on column ${iol_schema}.hgls_micro_customer_base_info.unit_property is '单位性质xwddwxz';
comment on column ${iol_schema}.hgls_micro_customer_base_info.unit_industry is '单位所属行业txhy';
comment on column ${iol_schema}.hgls_micro_customer_base_info.occupation is '职业xwdzy';
comment on column ${iol_schema}.hgls_micro_customer_base_info.positions is '职务xwdzw';
comment on column ${iol_schema}.hgls_micro_customer_base_info.jobtitle is '职称xwdzc';
comment on column ${iol_schema}.hgls_micro_customer_base_info.occupation_supplement is '从业状况';
comment on column ${iol_schema}.hgls_micro_customer_base_info.on_board_dt is '入职日期';
comment on column ${iol_schema}.hgls_micro_customer_base_info.house_price is '房产价值';
comment on column ${iol_schema}.hgls_micro_customer_base_info.live_years_type is '居住年限-三色表';
comment on column ${iol_schema}.hgls_micro_customer_base_info.retail_rate_back_msg is '零售评级返回报文体';
comment on column ${iol_schema}.hgls_micro_customer_base_info.outside_house is '外地有无房产1有0无';
comment on column ${iol_schema}.hgls_micro_customer_base_info.outside_house_zijian_num is '外地农村自建房数量';
comment on column ${iol_schema}.hgls_micro_customer_base_info.outside_house_shangpin_num is '外地商品房数量';
comment on column ${iol_schema}.hgls_micro_customer_base_info.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_micro_customer_base_info.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_micro_customer_base_info.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_micro_customer_base_info.etl_timestamp is 'ETL处理时间戳';
