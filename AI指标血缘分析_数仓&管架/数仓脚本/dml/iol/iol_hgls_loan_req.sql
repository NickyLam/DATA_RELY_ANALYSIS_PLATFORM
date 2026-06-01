/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_req
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
create table ${iol_schema}.hgls_loan_req_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_req
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_req_op purge;
drop table ${iol_schema}.hgls_loan_req_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_req_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_req where 0=1;

create table ${iol_schema}.hgls_loan_req_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_req where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_req_cl(
            req_id -- 申请ID:主键
            ,prod_id -- 产品ID:外键
            ,prod_code -- 产品编码
            ,code -- 唯一编码
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prod_name -- 产品名称
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,cust_id -- 申请客户ID
            ,cust_name -- 客户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 统一信用代码证
            ,cust_type -- 客户类型：A，按揭白名单
            ,file_code -- 白名单文件编码
            ,id_card_no -- 身份证号码
            ,manage_code -- 分享人（系统用户）code
            ,survey_user_id -- 调查员id（归属人）
            ,transator_id -- 经办人ID
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,reconsider_ids -- 人工复议人员id
            ,share_user_id -- 分享者ID
            ,req_date -- 申请日期
            ,audit_date -- 审核日期
            ,loan_use -- 借款用途
            ,loan_use_other -- 借款用途
            ,reject_reason -- 审批拒绝原因
            ,reject_reason_other -- 审批拒绝原因
            ,auth_money -- 授信金额
            ,audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
            ,label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
            ,process_info -- 流程记录信息，多个流程以逗号分隔
            ,is_cancel -- 贷款是否取消，0否1是
            ,req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
            ,is_self -- 是否自主营销
            ,survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
            ,survey_date -- 准备调查时间
            ,loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
            ,update_date -- 更新时间
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,"comment" -- 备注信息
            ,is_credit_submit -- 信贷历史是否提交0否1是
            ,ismanual_audit -- 是否开启人工审核，0否1是
            ,intervene_status -- 复议成功状态 0失败1成功
            ,reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
            ,enterprise_code -- 企业编码
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,isfixed_rate -- 是否固定利率，0否1是
            ,loan_rate -- 贷款日利率（%）无锡需求，可以为空
            ,channel -- 渠道
            ,category -- 类别:(1.短信 2.软文 3.图片 4.中介)
            ,final_price -- 实际成交价
            ,access_rule -- 贷款准入规则
            ,final_loan_money -- 实际放款金额
            ,branch_code -- 支行信息code
            ,home_branch -- 归属支行code
            ,is_house_audit_submit -- 房贷初审是否提交，0否1是
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,remarks -- 备注
            ,risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
            ,collect_ele_submit -- 信息收集核查要素是否提交，0否1是
            ,query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
            ,year_rate -- 年利率
            ,sync_result -- 信贷同步结果
            ,exclude_count -- 业务量均分，统计排除标记，默认不排除
            ,next_req_code -- 更换产品后的code
            ,change_product_user_id -- 更换产品操作人id
            ,change_product_user_name -- 更换产品操作人姓名
            ,is_renew_loan -- 是否为续贷：0.否 1.是
            ,biz_breed_encode -- 业务编号（智慧零售唯一标识）
            ,is_first_loan -- 是否是首贷户，0否1是
            ,renew_ori_req_code -- 续贷原进件CODE
            ,comprehensive_money -- 综合授信额度
            ,minor_survey_user_id -- 陪调员id
            ,marital_status -- 婚姻状况
            ,apply_balance -- 申请金额(元)
            ,telephone -- 联系方式
            ,model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
            ,is_pos_cust -- 是否POS贷客户 true:是
            ,is_stock_cust -- 是否存量客户 true:是
            ,biz_cust_no -- 信贷客户编号
            ,biz_cust_create_date -- 信贷客户创建时间
            ,biz_contract_no -- 信贷合同编号
            ,is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
            ,business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
            ,scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
            ,agri_loan_type -- 涉农贷款类型，字典：sndklx
            ,contrac_no -- 安心签项目编号
            ,applyorderno -- 唯一申请编号（信贷交互使用）
            ,referrer_id -- 推荐员id
            ,is_revolving_loan -- 是否循环贷款
            ,retail_rate_value -- 零售评级返回分数
            ,after_last_time -- 上次过贷后模型时间
            ,business_label -- 行业群码值
            ,credit_line_amount -- 首贷授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_req_op(
            req_id -- 申请ID:主键
            ,prod_id -- 产品ID:外键
            ,prod_code -- 产品编码
            ,code -- 唯一编码
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prod_name -- 产品名称
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,cust_id -- 申请客户ID
            ,cust_name -- 客户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 统一信用代码证
            ,cust_type -- 客户类型：A，按揭白名单
            ,file_code -- 白名单文件编码
            ,id_card_no -- 身份证号码
            ,manage_code -- 分享人（系统用户）code
            ,survey_user_id -- 调查员id（归属人）
            ,transator_id -- 经办人ID
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,reconsider_ids -- 人工复议人员id
            ,share_user_id -- 分享者ID
            ,req_date -- 申请日期
            ,audit_date -- 审核日期
            ,loan_use -- 借款用途
            ,loan_use_other -- 借款用途
            ,reject_reason -- 审批拒绝原因
            ,reject_reason_other -- 审批拒绝原因
            ,auth_money -- 授信金额
            ,audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
            ,label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
            ,process_info -- 流程记录信息，多个流程以逗号分隔
            ,is_cancel -- 贷款是否取消，0否1是
            ,req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
            ,is_self -- 是否自主营销
            ,survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
            ,survey_date -- 准备调查时间
            ,loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
            ,update_date -- 更新时间
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,"comment" -- 备注信息
            ,is_credit_submit -- 信贷历史是否提交0否1是
            ,ismanual_audit -- 是否开启人工审核，0否1是
            ,intervene_status -- 复议成功状态 0失败1成功
            ,reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
            ,enterprise_code -- 企业编码
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,isfixed_rate -- 是否固定利率，0否1是
            ,loan_rate -- 贷款日利率（%）无锡需求，可以为空
            ,channel -- 渠道
            ,category -- 类别:(1.短信 2.软文 3.图片 4.中介)
            ,final_price -- 实际成交价
            ,access_rule -- 贷款准入规则
            ,final_loan_money -- 实际放款金额
            ,branch_code -- 支行信息code
            ,home_branch -- 归属支行code
            ,is_house_audit_submit -- 房贷初审是否提交，0否1是
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,remarks -- 备注
            ,risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
            ,collect_ele_submit -- 信息收集核查要素是否提交，0否1是
            ,query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
            ,year_rate -- 年利率
            ,sync_result -- 信贷同步结果
            ,exclude_count -- 业务量均分，统计排除标记，默认不排除
            ,next_req_code -- 更换产品后的code
            ,change_product_user_id -- 更换产品操作人id
            ,change_product_user_name -- 更换产品操作人姓名
            ,is_renew_loan -- 是否为续贷：0.否 1.是
            ,biz_breed_encode -- 业务编号（智慧零售唯一标识）
            ,is_first_loan -- 是否是首贷户，0否1是
            ,renew_ori_req_code -- 续贷原进件CODE
            ,comprehensive_money -- 综合授信额度
            ,minor_survey_user_id -- 陪调员id
            ,marital_status -- 婚姻状况
            ,apply_balance -- 申请金额(元)
            ,telephone -- 联系方式
            ,model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
            ,is_pos_cust -- 是否POS贷客户 true:是
            ,is_stock_cust -- 是否存量客户 true:是
            ,biz_cust_no -- 信贷客户编号
            ,biz_cust_create_date -- 信贷客户创建时间
            ,biz_contract_no -- 信贷合同编号
            ,is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
            ,business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
            ,scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
            ,agri_loan_type -- 涉农贷款类型，字典：sndklx
            ,contrac_no -- 安心签项目编号
            ,applyorderno -- 唯一申请编号（信贷交互使用）
            ,referrer_id -- 推荐员id
            ,is_revolving_loan -- 是否循环贷款
            ,retail_rate_value -- 零售评级返回分数
            ,after_last_time -- 上次过贷后模型时间
            ,business_label -- 行业群码值
            ,credit_line_amount -- 首贷授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.req_id, o.req_id) as req_id -- 申请ID:主键
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品ID:外键
    ,nvl(n.prod_code, o.prod_code) as prod_code -- 产品编码
    ,nvl(n.code, o.code) as code -- 唯一编码
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类型:1.网贷,2.经营贷
    ,nvl(n.loan_apply_type, o.loan_apply_type) as loan_apply_type -- 贷款类型
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.credit_on, o.credit_on) as credit_on -- 预授信模式:0.关闭,１.开启
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 申请客户ID
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户姓名
    ,nvl(n.ent_name, o.ent_name) as ent_name -- 企业名称
    ,nvl(n.credit_code, o.credit_code) as credit_code -- 统一信用代码证
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型：A，按揭白名单
    ,nvl(n.file_code, o.file_code) as file_code -- 白名单文件编码
    ,nvl(n.id_card_no, o.id_card_no) as id_card_no -- 身份证号码
    ,nvl(n.manage_code, o.manage_code) as manage_code -- 分享人（系统用户）code
    ,nvl(n.survey_user_id, o.survey_user_id) as survey_user_id -- 调查员id（归属人）
    ,nvl(n.transator_id, o.transator_id) as transator_id -- 经办人ID
    ,nvl(n.examiner_ids, o.examiner_ids) as examiner_ids -- 审查者id
    ,nvl(n.auditor_ids, o.auditor_ids) as auditor_ids -- 审批者id
    ,nvl(n.reconsider_ids, o.reconsider_ids) as reconsider_ids -- 人工复议人员id
    ,nvl(n.share_user_id, o.share_user_id) as share_user_id -- 分享者ID
    ,nvl(n.req_date, o.req_date) as req_date -- 申请日期
    ,nvl(n.audit_date, o.audit_date) as audit_date -- 审核日期
    ,nvl(n.loan_use, o.loan_use) as loan_use -- 借款用途
    ,nvl(n.loan_use_other, o.loan_use_other) as loan_use_other -- 借款用途
    ,nvl(n.reject_reason, o.reject_reason) as reject_reason -- 审批拒绝原因
    ,nvl(n.reject_reason_other, o.reject_reason_other) as reject_reason_other -- 审批拒绝原因
    ,nvl(n.auth_money, o.auth_money) as auth_money -- 授信金额
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
    ,nvl(n.label_status, o.label_status) as label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
    ,nvl(n.process_info, o.process_info) as process_info -- 流程记录信息，多个流程以逗号分隔
    ,nvl(n.is_cancel, o.is_cancel) as is_cancel -- 贷款是否取消，0否1是
    ,nvl(n.req_type, o.req_type) as req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
    ,nvl(n.is_self, o.is_self) as is_self -- 是否自主营销
    ,nvl(n.survey_status, o.survey_status) as survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
    ,nvl(n.survey_date, o.survey_date) as survey_date -- 准备调查时间
    ,nvl(n.loan_amount, o.loan_amount) as loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.repayment_kind, o.repayment_kind) as repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,nvl(n."comment", o."comment") as "comment" -- 备注信息
    ,nvl(n.is_credit_submit, o.is_credit_submit) as is_credit_submit -- 信贷历史是否提交0否1是
    ,nvl(n.ismanual_audit, o.ismanual_audit) as ismanual_audit -- 是否开启人工审核，0否1是
    ,nvl(n.intervene_status, o.intervene_status) as intervene_status -- 复议成功状态 0失败1成功
    ,nvl(n.reconsider_num, o.reconsider_num) as reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
    ,nvl(n.enterprise_code, o.enterprise_code) as enterprise_code -- 企业编码
    ,nvl(n.approve_num, o.approve_num) as approve_num -- 审批人数
    ,nvl(n.examine_num, o.examine_num) as examine_num -- 审查人数
    ,nvl(n.isfixed_rate, o.isfixed_rate) as isfixed_rate -- 是否固定利率，0否1是
    ,nvl(n.loan_rate, o.loan_rate) as loan_rate -- 贷款日利率（%）无锡需求，可以为空
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.category, o.category) as category -- 类别:(1.短信 2.软文 3.图片 4.中介)
    ,nvl(n.final_price, o.final_price) as final_price -- 实际成交价
    ,nvl(n.access_rule, o.access_rule) as access_rule -- 贷款准入规则
    ,nvl(n.final_loan_money, o.final_loan_money) as final_loan_money -- 实际放款金额
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 支行信息code
    ,nvl(n.home_branch, o.home_branch) as home_branch -- 归属支行code
    ,nvl(n.is_house_audit_submit, o.is_house_audit_submit) as is_house_audit_submit -- 房贷初审是否提交，0否1是
    ,nvl(n.isdel, o.isdel) as isdel -- 删除标识:0.未删除,1.已删除
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.risk_ele_submit, o.risk_ele_submit) as risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
    ,nvl(n.collect_ele_submit, o.collect_ele_submit) as collect_ele_submit -- 信息收集核查要素是否提交，0否1是
    ,nvl(n.query_number, o.query_number) as query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
    ,nvl(n.year_rate, o.year_rate) as year_rate -- 年利率
    ,nvl(n.sync_result, o.sync_result) as sync_result -- 信贷同步结果
    ,nvl(n.exclude_count, o.exclude_count) as exclude_count -- 业务量均分，统计排除标记，默认不排除
    ,nvl(n.next_req_code, o.next_req_code) as next_req_code -- 更换产品后的code
    ,nvl(n.change_product_user_id, o.change_product_user_id) as change_product_user_id -- 更换产品操作人id
    ,nvl(n.change_product_user_name, o.change_product_user_name) as change_product_user_name -- 更换产品操作人姓名
    ,nvl(n.is_renew_loan, o.is_renew_loan) as is_renew_loan -- 是否为续贷：0.否 1.是
    ,nvl(n.biz_breed_encode, o.biz_breed_encode) as biz_breed_encode -- 业务编号（智慧零售唯一标识）
    ,nvl(n.is_first_loan, o.is_first_loan) as is_first_loan -- 是否是首贷户，0否1是
    ,nvl(n.renew_ori_req_code, o.renew_ori_req_code) as renew_ori_req_code -- 续贷原进件CODE
    ,nvl(n.comprehensive_money, o.comprehensive_money) as comprehensive_money -- 综合授信额度
    ,nvl(n.minor_survey_user_id, o.minor_survey_user_id) as minor_survey_user_id -- 陪调员id
    ,nvl(n.marital_status, o.marital_status) as marital_status -- 婚姻状况
    ,nvl(n.apply_balance, o.apply_balance) as apply_balance -- 申请金额(元)
    ,nvl(n.telephone, o.telephone) as telephone -- 联系方式
    ,nvl(n.model_version, o.model_version) as model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
    ,nvl(n.is_pos_cust, o.is_pos_cust) as is_pos_cust -- 是否POS贷客户 true:是
    ,nvl(n.is_stock_cust, o.is_stock_cust) as is_stock_cust -- 是否存量客户 true:是
    ,nvl(n.biz_cust_no, o.biz_cust_no) as biz_cust_no -- 信贷客户编号
    ,nvl(n.biz_cust_create_date, o.biz_cust_create_date) as biz_cust_create_date -- 信贷客户创建时间
    ,nvl(n.biz_contract_no, o.biz_contract_no) as biz_contract_no -- 信贷合同编号
    ,nvl(n.is_ji_nong_dan, o.is_ji_nong_dan) as is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
    ,nvl(n.business_license_type, o.business_license_type) as business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
    ,nvl(n.relationship_of_enterprise, o.relationship_of_enterprise) as relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
    ,nvl(n.scale_judgment, o.scale_judgment) as scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
    ,nvl(n.agri_loan_type, o.agri_loan_type) as agri_loan_type -- 涉农贷款类型，字典：sndklx
    ,nvl(n.contrac_no, o.contrac_no) as contrac_no -- 安心签项目编号
    ,nvl(n.applyorderno, o.applyorderno) as applyorderno -- 唯一申请编号（信贷交互使用）
    ,nvl(n.referrer_id, o.referrer_id) as referrer_id -- 推荐员id
    ,nvl(n.is_revolving_loan, o.is_revolving_loan) as is_revolving_loan -- 是否循环贷款
    ,nvl(n.retail_rate_value, o.retail_rate_value) as retail_rate_value -- 零售评级返回分数
    ,nvl(n.after_last_time, o.after_last_time) as after_last_time -- 上次过贷后模型时间
    ,nvl(n.business_label, o.business_label) as business_label -- 行业群码值
    ,nvl(n.credit_line_amount, o.credit_line_amount) as credit_line_amount -- 首贷授信额度
    ,case when
            n.req_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.req_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.req_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_loan_req_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_req where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.req_id = n.req_id
where (
        o.req_id is null
    )
    or (
        n.req_id is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.prod_code <> n.prod_code
        or o.code <> n.code
        or o.prd_type <> n.prd_type
        or o.loan_apply_type <> n.loan_apply_type
        or o.prod_name <> n.prod_name
        or o.credit_on <> n.credit_on
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.ent_name <> n.ent_name
        or o.credit_code <> n.credit_code
        or o.cust_type <> n.cust_type
        or o.file_code <> n.file_code
        or o.id_card_no <> n.id_card_no
        or o.manage_code <> n.manage_code
        or o.survey_user_id <> n.survey_user_id
        or o.transator_id <> n.transator_id
        or o.examiner_ids <> n.examiner_ids
        or o.auditor_ids <> n.auditor_ids
        or o.reconsider_ids <> n.reconsider_ids
        or o.share_user_id <> n.share_user_id
        or o.req_date <> n.req_date
        or o.audit_date <> n.audit_date
        or o.loan_use <> n.loan_use
        or o.loan_use_other <> n.loan_use_other
        or o.reject_reason <> n.reject_reason
        or o.reject_reason_other <> n.reject_reason_other
        or o.auth_money <> n.auth_money
        or o.audit_status <> n.audit_status
        or o.label_status <> n.label_status
        or o.process_info <> n.process_info
        or o.is_cancel <> n.is_cancel
        or o.req_type <> n.req_type
        or o.is_self <> n.is_self
        or o.survey_status <> n.survey_status
        or o.survey_date <> n.survey_date
        or o.loan_amount <> n.loan_amount
        or o.update_date <> n.update_date
        or o.repayment_kind <> n.repayment_kind
        or o."comment" <> n."comment"
        or o.is_credit_submit <> n.is_credit_submit
        or o.ismanual_audit <> n.ismanual_audit
        or o.intervene_status <> n.intervene_status
        or o.reconsider_num <> n.reconsider_num
        or o.enterprise_code <> n.enterprise_code
        or o.approve_num <> n.approve_num
        or o.examine_num <> n.examine_num
        or o.isfixed_rate <> n.isfixed_rate
        or o.loan_rate <> n.loan_rate
        or o.channel <> n.channel
        or o.category <> n.category
        or o.final_price <> n.final_price
        or o.access_rule <> n.access_rule
        or o.final_loan_money <> n.final_loan_money
        or o.branch_code <> n.branch_code
        or o.home_branch <> n.home_branch
        or o.is_house_audit_submit <> n.is_house_audit_submit
        or o.isdel <> n.isdel
        or o.remarks <> n.remarks
        or o.risk_ele_submit <> n.risk_ele_submit
        or o.collect_ele_submit <> n.collect_ele_submit
        or o.query_number <> n.query_number
        or o.year_rate <> n.year_rate
        or o.sync_result <> n.sync_result
        or o.exclude_count <> n.exclude_count
        or o.next_req_code <> n.next_req_code
        or o.change_product_user_id <> n.change_product_user_id
        or o.change_product_user_name <> n.change_product_user_name
        or o.is_renew_loan <> n.is_renew_loan
        or o.biz_breed_encode <> n.biz_breed_encode
        or o.is_first_loan <> n.is_first_loan
        or o.renew_ori_req_code <> n.renew_ori_req_code
        or o.comprehensive_money <> n.comprehensive_money
        or o.minor_survey_user_id <> n.minor_survey_user_id
        or o.marital_status <> n.marital_status
        or o.apply_balance <> n.apply_balance
        or o.telephone <> n.telephone
        or o.model_version <> n.model_version
        or o.is_pos_cust <> n.is_pos_cust
        or o.is_stock_cust <> n.is_stock_cust
        or o.biz_cust_no <> n.biz_cust_no
        or o.biz_cust_create_date <> n.biz_cust_create_date
        or o.biz_contract_no <> n.biz_contract_no
        or o.is_ji_nong_dan <> n.is_ji_nong_dan
        or o.business_license_type <> n.business_license_type
        or o.relationship_of_enterprise <> n.relationship_of_enterprise
        or o.scale_judgment <> n.scale_judgment
        or o.agri_loan_type <> n.agri_loan_type
        or o.contrac_no <> n.contrac_no
        or o.applyorderno <> n.applyorderno
        or o.referrer_id <> n.referrer_id
        or o.is_revolving_loan <> n.is_revolving_loan
        or o.retail_rate_value <> n.retail_rate_value
        or o.after_last_time <> n.after_last_time
        or o.business_label <> n.business_label
        or o.credit_line_amount <> n.credit_line_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_req_cl(
            req_id -- 申请ID:主键
            ,prod_id -- 产品ID:外键
            ,prod_code -- 产品编码
            ,code -- 唯一编码
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prod_name -- 产品名称
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,cust_id -- 申请客户ID
            ,cust_name -- 客户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 统一信用代码证
            ,cust_type -- 客户类型：A，按揭白名单
            ,file_code -- 白名单文件编码
            ,id_card_no -- 身份证号码
            ,manage_code -- 分享人（系统用户）code
            ,survey_user_id -- 调查员id（归属人）
            ,transator_id -- 经办人ID
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,reconsider_ids -- 人工复议人员id
            ,share_user_id -- 分享者ID
            ,req_date -- 申请日期
            ,audit_date -- 审核日期
            ,loan_use -- 借款用途
            ,loan_use_other -- 借款用途
            ,reject_reason -- 审批拒绝原因
            ,reject_reason_other -- 审批拒绝原因
            ,auth_money -- 授信金额
            ,audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
            ,label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
            ,process_info -- 流程记录信息，多个流程以逗号分隔
            ,is_cancel -- 贷款是否取消，0否1是
            ,req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
            ,is_self -- 是否自主营销
            ,survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
            ,survey_date -- 准备调查时间
            ,loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
            ,update_date -- 更新时间
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,"comment" -- 备注信息
            ,is_credit_submit -- 信贷历史是否提交0否1是
            ,ismanual_audit -- 是否开启人工审核，0否1是
            ,intervene_status -- 复议成功状态 0失败1成功
            ,reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
            ,enterprise_code -- 企业编码
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,isfixed_rate -- 是否固定利率，0否1是
            ,loan_rate -- 贷款日利率（%）无锡需求，可以为空
            ,channel -- 渠道
            ,category -- 类别:(1.短信 2.软文 3.图片 4.中介)
            ,final_price -- 实际成交价
            ,access_rule -- 贷款准入规则
            ,final_loan_money -- 实际放款金额
            ,branch_code -- 支行信息code
            ,home_branch -- 归属支行code
            ,is_house_audit_submit -- 房贷初审是否提交，0否1是
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,remarks -- 备注
            ,risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
            ,collect_ele_submit -- 信息收集核查要素是否提交，0否1是
            ,query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
            ,year_rate -- 年利率
            ,sync_result -- 信贷同步结果
            ,exclude_count -- 业务量均分，统计排除标记，默认不排除
            ,next_req_code -- 更换产品后的code
            ,change_product_user_id -- 更换产品操作人id
            ,change_product_user_name -- 更换产品操作人姓名
            ,is_renew_loan -- 是否为续贷：0.否 1.是
            ,biz_breed_encode -- 业务编号（智慧零售唯一标识）
            ,is_first_loan -- 是否是首贷户，0否1是
            ,renew_ori_req_code -- 续贷原进件CODE
            ,comprehensive_money -- 综合授信额度
            ,minor_survey_user_id -- 陪调员id
            ,marital_status -- 婚姻状况
            ,apply_balance -- 申请金额(元)
            ,telephone -- 联系方式
            ,model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
            ,is_pos_cust -- 是否POS贷客户 true:是
            ,is_stock_cust -- 是否存量客户 true:是
            ,biz_cust_no -- 信贷客户编号
            ,biz_cust_create_date -- 信贷客户创建时间
            ,biz_contract_no -- 信贷合同编号
            ,is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
            ,business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
            ,scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
            ,agri_loan_type -- 涉农贷款类型，字典：sndklx
            ,contrac_no -- 安心签项目编号
            ,applyorderno -- 唯一申请编号（信贷交互使用）
            ,referrer_id -- 推荐员id
            ,is_revolving_loan -- 是否循环贷款
            ,retail_rate_value -- 零售评级返回分数
            ,after_last_time -- 上次过贷后模型时间
            ,business_label -- 行业群码值
            ,credit_line_amount -- 首贷授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_req_op(
            req_id -- 申请ID:主键
            ,prod_id -- 产品ID:外键
            ,prod_code -- 产品编码
            ,code -- 唯一编码
            ,prd_type -- 产品类型:1.网贷,2.经营贷
            ,loan_apply_type -- 贷款类型
            ,prod_name -- 产品名称
            ,credit_on -- 预授信模式:0.关闭,１.开启
            ,cust_id -- 申请客户ID
            ,cust_name -- 客户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 统一信用代码证
            ,cust_type -- 客户类型：A，按揭白名单
            ,file_code -- 白名单文件编码
            ,id_card_no -- 身份证号码
            ,manage_code -- 分享人（系统用户）code
            ,survey_user_id -- 调查员id（归属人）
            ,transator_id -- 经办人ID
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,reconsider_ids -- 人工复议人员id
            ,share_user_id -- 分享者ID
            ,req_date -- 申请日期
            ,audit_date -- 审核日期
            ,loan_use -- 借款用途
            ,loan_use_other -- 借款用途
            ,reject_reason -- 审批拒绝原因
            ,reject_reason_other -- 审批拒绝原因
            ,auth_money -- 授信金额
            ,audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
            ,label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
            ,process_info -- 流程记录信息，多个流程以逗号分隔
            ,is_cancel -- 贷款是否取消，0否1是
            ,req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
            ,is_self -- 是否自主营销
            ,survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
            ,survey_date -- 准备调查时间
            ,loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
            ,update_date -- 更新时间
            ,repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
            ,"comment" -- 备注信息
            ,is_credit_submit -- 信贷历史是否提交0否1是
            ,ismanual_audit -- 是否开启人工审核，0否1是
            ,intervene_status -- 复议成功状态 0失败1成功
            ,reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
            ,enterprise_code -- 企业编码
            ,approve_num -- 审批人数
            ,examine_num -- 审查人数
            ,isfixed_rate -- 是否固定利率，0否1是
            ,loan_rate -- 贷款日利率（%）无锡需求，可以为空
            ,channel -- 渠道
            ,category -- 类别:(1.短信 2.软文 3.图片 4.中介)
            ,final_price -- 实际成交价
            ,access_rule -- 贷款准入规则
            ,final_loan_money -- 实际放款金额
            ,branch_code -- 支行信息code
            ,home_branch -- 归属支行code
            ,is_house_audit_submit -- 房贷初审是否提交，0否1是
            ,isdel -- 删除标识:0.未删除,1.已删除
            ,remarks -- 备注
            ,risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
            ,collect_ele_submit -- 信息收集核查要素是否提交，0否1是
            ,query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
            ,year_rate -- 年利率
            ,sync_result -- 信贷同步结果
            ,exclude_count -- 业务量均分，统计排除标记，默认不排除
            ,next_req_code -- 更换产品后的code
            ,change_product_user_id -- 更换产品操作人id
            ,change_product_user_name -- 更换产品操作人姓名
            ,is_renew_loan -- 是否为续贷：0.否 1.是
            ,biz_breed_encode -- 业务编号（智慧零售唯一标识）
            ,is_first_loan -- 是否是首贷户，0否1是
            ,renew_ori_req_code -- 续贷原进件CODE
            ,comprehensive_money -- 综合授信额度
            ,minor_survey_user_id -- 陪调员id
            ,marital_status -- 婚姻状况
            ,apply_balance -- 申请金额(元)
            ,telephone -- 联系方式
            ,model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
            ,is_pos_cust -- 是否POS贷客户 true:是
            ,is_stock_cust -- 是否存量客户 true:是
            ,biz_cust_no -- 信贷客户编号
            ,biz_cust_create_date -- 信贷客户创建时间
            ,biz_contract_no -- 信贷合同编号
            ,is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
            ,business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
            ,relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
            ,scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
            ,agri_loan_type -- 涉农贷款类型，字典：sndklx
            ,contrac_no -- 安心签项目编号
            ,applyorderno -- 唯一申请编号（信贷交互使用）
            ,referrer_id -- 推荐员id
            ,is_revolving_loan -- 是否循环贷款
            ,retail_rate_value -- 零售评级返回分数
            ,after_last_time -- 上次过贷后模型时间
            ,business_label -- 行业群码值
            ,credit_line_amount -- 首贷授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.req_id -- 申请ID:主键
    ,o.prod_id -- 产品ID:外键
    ,o.prod_code -- 产品编码
    ,o.code -- 唯一编码
    ,o.prd_type -- 产品类型:1.网贷,2.经营贷
    ,o.loan_apply_type -- 贷款类型
    ,o.prod_name -- 产品名称
    ,o.credit_on -- 预授信模式:0.关闭,１.开启
    ,o.cust_id -- 申请客户ID
    ,o.cust_name -- 客户姓名
    ,o.ent_name -- 企业名称
    ,o.credit_code -- 统一信用代码证
    ,o.cust_type -- 客户类型：A，按揭白名单
    ,o.file_code -- 白名单文件编码
    ,o.id_card_no -- 身份证号码
    ,o.manage_code -- 分享人（系统用户）code
    ,o.survey_user_id -- 调查员id（归属人）
    ,o.transator_id -- 经办人ID
    ,o.examiner_ids -- 审查者id
    ,o.auditor_ids -- 审批者id
    ,o.reconsider_ids -- 人工复议人员id
    ,o.share_user_id -- 分享者ID
    ,o.req_date -- 申请日期
    ,o.audit_date -- 审核日期
    ,o.loan_use -- 借款用途
    ,o.loan_use_other -- 借款用途
    ,o.reject_reason -- 审批拒绝原因
    ,o.reject_reason_other -- 审批拒绝原因
    ,o.auth_money -- 授信金额
    ,o.audit_status -- 审批状态:1 待审批 2 审批通过 3审批拒绝
    ,o.label_status -- 标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核
    ,o.process_info -- 流程记录信息，多个流程以逗号分隔
    ,o.is_cancel -- 贷款是否取消，0否1是
    ,o.req_type -- 进件类型：1，公共进件，2，自主营销，3，渠道进件
    ,o.is_self -- 是否自主营销
    ,o.survey_status -- 调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）
    ,o.survey_date -- 准备调查时间
    ,o.loan_amount -- 申请金额,单位(万元),最大不超过产品定义的额度
    ,o.update_date -- 更新时间
    ,o.repayment_kind -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs
    ,o."comment" -- 备注信息
    ,o.is_credit_submit -- 信贷历史是否提交0否1是
    ,o.ismanual_audit -- 是否开启人工审核，0否1是
    ,o.intervene_status -- 复议成功状态 0失败1成功
    ,o.reconsider_num -- 复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2
    ,o.enterprise_code -- 企业编码
    ,o.approve_num -- 审批人数
    ,o.examine_num -- 审查人数
    ,o.isfixed_rate -- 是否固定利率，0否1是
    ,o.loan_rate -- 贷款日利率（%）无锡需求，可以为空
    ,o.channel -- 渠道
    ,o.category -- 类别:(1.短信 2.软文 3.图片 4.中介)
    ,o.final_price -- 实际成交价
    ,o.access_rule -- 贷款准入规则
    ,o.final_loan_money -- 实际放款金额
    ,o.branch_code -- 支行信息code
    ,o.home_branch -- 归属支行code
    ,o.is_house_audit_submit -- 房贷初审是否提交，0否1是
    ,o.isdel -- 删除标识:0.未删除,1.已删除
    ,o.remarks -- 备注
    ,o.risk_ele_submit -- 风险核查要素提交状态，0否1电调提交2二次补充信息提交
    ,o.collect_ele_submit -- 信息收集核查要素是否提交，0否1是
    ,o.query_number -- 调查报告查询编码-为随机数合字母组成，无特殊规律
    ,o.year_rate -- 年利率
    ,o.sync_result -- 信贷同步结果
    ,o.exclude_count -- 业务量均分，统计排除标记，默认不排除
    ,o.next_req_code -- 更换产品后的code
    ,o.change_product_user_id -- 更换产品操作人id
    ,o.change_product_user_name -- 更换产品操作人姓名
    ,o.is_renew_loan -- 是否为续贷：0.否 1.是
    ,o.biz_breed_encode -- 业务编号（智慧零售唯一标识）
    ,o.is_first_loan -- 是否是首贷户，0否1是
    ,o.renew_ori_req_code -- 续贷原进件CODE
    ,o.comprehensive_money -- 综合授信额度
    ,o.minor_survey_user_id -- 陪调员id
    ,o.marital_status -- 婚姻状况
    ,o.apply_balance -- 申请金额(元)
    ,o.telephone -- 联系方式
    ,o.model_version -- 是否走续贷模型，0不走续贷模型，1走续贷模型
    ,o.is_pos_cust -- 是否POS贷客户 true:是
    ,o.is_stock_cust -- 是否存量客户 true:是
    ,o.biz_cust_no -- 信贷客户编号
    ,o.biz_cust_create_date -- 信贷客户创建时间
    ,o.biz_contract_no -- 信贷合同编号
    ,o.is_ji_nong_dan -- 是否冀农担客户：0:否 1:是
    ,o.business_license_type -- 营业执照类型：1个体工商户、2企业、3无营业执照
    ,o.relationship_of_enterprise -- 借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联
    ,o.scale_judgment -- 规模判断：1大型、2中型、3小型、4微型、5其它
    ,o.agri_loan_type -- 涉农贷款类型，字典：sndklx
    ,o.contrac_no -- 安心签项目编号
    ,o.applyorderno -- 唯一申请编号（信贷交互使用）
    ,o.referrer_id -- 推荐员id
    ,o.is_revolving_loan -- 是否循环贷款
    ,o.retail_rate_value -- 零售评级返回分数
    ,o.after_last_time -- 上次过贷后模型时间
    ,o.business_label -- 行业群码值
    ,o.credit_line_amount -- 首贷授信额度
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
from ${iol_schema}.hgls_loan_req_bk o
    left join ${iol_schema}.hgls_loan_req_op n
        on
            o.req_id = n.req_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_req_cl d
        on
            o.req_id = d.req_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_loan_req;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_req') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_req drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_req add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_req exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_req_cl;
alter table ${iol_schema}.hgls_loan_req exchange partition p_20991231 with table ${iol_schema}.hgls_loan_req_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_req to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_req_op purge;
drop table ${iol_schema}.hgls_loan_req_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_req_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_req',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
